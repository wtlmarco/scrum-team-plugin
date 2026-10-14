# Funcoes comuns aos despachantes de guarda (hooks/*.ps1).
# Requisito: Windows PowerShell 5.1 (powershell.exe, o do Windows) - os hooks chamam "powershell", nao "pwsh".
# Sem recurso exclusivo do PowerShell 7. Falha aberta (D5): quem chama
# trata excecao com exit 1, que o harness le como erro nao bloqueante.

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Read-HookInput {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { return $null }
    return $raw | ConvertFrom-Json
}

function Get-ProjectDir([object]$HookInput) {
    if ($env:CLAUDE_PROJECT_DIR) { return $env:CLAUDE_PROJECT_DIR }
    if ($HookInput -and $HookInput.cwd) { return [string]$HookInput.cwd }
    return (Get-Location).Path
}

# Configuracao por projeto: .team-project/guards.json. Ausente ou invalida -> padrao.
function Get-GuardConfig([string]$ProjectDir) {
    $cfg = [ordered]@{
        disabled         = @()
        maxInlineLines   = 300
        probe            = $false
        # Fase 2 (v3.42): G5 arquivos de gate, G8 codigo-fonte (vazio = tudo fora de .team-project/ e docs/), G6 padroes de teste ignorado
        protectedPaths   = @('**/.editorconfig', '**/Directory.Build.props', '**/Directory.Build.targets', '**/*.ruleset', '**/.globalconfig',
                             '.gitlab-ci.yml', '.github/workflows/**', '.pre-commit-config.yaml', '.husky/**', '.git/hooks/**')
        sourceRoots      = @()
        testSkipPatterns = @('[Skip', '[Ignore', 'Skip =', 'Skip=', '.skip(', 'xit(', 'xdescribe(', 'xtest(', '@Disabled', '@Ignore', 'pytest.mark.skip', 't.Skip(')
        # v3.44 (G14): prefixos dos comandos de build/teste/lint do projeto, liberados aos papeis durante o run
        runCommands      = @()
        # v3.47 (G18) - modo benchmark: respostas do dossie ao AskUserQuestion e agente em primeiro plano; $null = desligado
        bench            = $null
        state            = 'ausente'
    }
    $path = Join-Path $ProjectDir '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $path)) { return $cfg }
    try {
        $json = Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($null -ne $json.disabled)         { $cfg.disabled         = @($json.disabled) }
        if ($null -ne $json.maxInlineLines)   { $cfg.maxInlineLines   = [int]$json.maxInlineLines }
        if ($null -ne $json.probe)            { $cfg.probe            = [bool]$json.probe }
        if ($null -ne $json.protectedPaths)   { $cfg.protectedPaths   = @($json.protectedPaths) }
        if ($null -ne $json.sourceRoots)      { $cfg.sourceRoots      = @($json.sourceRoots) }
        if ($null -ne $json.testSkipPatterns) { $cfg.testSkipPatterns = @($json.testSkipPatterns) }
        if ($null -ne $json.runCommands)      { $cfg.runCommands      = @($json.runCommands) }
        if ($null -ne $json.bench)            { $cfg.bench            = $json.bench }
        $cfg.state = 'ok'
    } catch {
        $cfg.state = 'invalido'
    }
    return $cfg
}

function Test-GuardEnabled($Config, [string]$Id) {
    return -not ($Config.disabled -contains $Id)
}

# Uma linha por decisao em .team-project/guards.log; so existe em projeto com o time instalado.
function Write-GuardLog([string]$ProjectDir, [string]$Guard, [object]$HookInput, [string]$Target, [string]$Message) {
    $dir = Join-Path $ProjectDir '.team-project'
    if (-not (Test-Path -LiteralPath $dir)) { return }
    $role = 'sessao'
    if ($HookInput -and $HookInput.agent_type) { $role = [string]$HookInput.agent_type }
    $tool = ''
    if ($HookInput -and $HookInput.tool_name) { $tool = [string]$HookInput.tool_name }
    $clean = ($Message -replace '\s+', ' ').Trim()
    $flatTarget = ([string]$Target -replace '\s+', ' ').Trim()   # v3.48: comando multilinha quebrava o log em linhas soltas
    $line = '{0} | {1} | {2} | {3} | {4} | {5}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Guard, $role, $tool, $flatTarget, $clean
    try {
        [System.IO.File]::AppendAllText((Join-Path $dir 'guards.log'), $line + [Environment]::NewLine, (New-Object System.Text.UTF8Encoding($false)))
    } catch { }
}

function Normalize-PathText([string]$Path) {
    if ([string]::IsNullOrEmpty($Path)) { return '' }
    return ($Path -replace '\\', '/').TrimEnd('/').ToLowerInvariant()
}

# Papel do agente: sufixo de agent_type ("team:developer" -> "developer", medido pela sonda em 2026-10-04).
# Sem agent_type = sessao principal -> $null (as guardas por papel nao se aplicam a ela).
function Get-AgentRole([object]$HookInput) {
    if (-not $HookInput -or -not $HookInput.agent_type) { return $null }
    return (([string]$HookInput.agent_type) -replace '^.*:', '').ToLowerInvariant()
}

# Caminho relativo ao projeto, normalizado (minusculas, "/"); $null se fora do projeto.
function Get-RelativePath([string]$ProjectDir, [string]$Path) {
    if ([string]::IsNullOrWhiteSpace($Path)) { return $null }
    if (-not [System.IO.Path]::IsPathRooted($Path)) { $Path = Join-Path $ProjectDir $Path }
    try { $Path = [System.IO.Path]::GetFullPath($Path) } catch { }
    $file = Normalize-PathText $Path
    $base = Normalize-PathText $ProjectDir
    if ($file.StartsWith($base + '/')) { return $file.Substring($base.Length + 1) }
    return $null
}

# Glob -> regex ancorada: "**/" = zero ou mais pastas, "**" = qualquer coisa, "*" e "?" nao cruzam "/".
function Convert-GlobToRegex([string]$Glob) {
    $g = Normalize-PathText $Glob
    $sb = New-Object System.Text.StringBuilder
    $i = 0
    while ($i -lt $g.Length) {
        $c = [string]$g[$i]
        if ($c -eq '*') {
            if ($i + 1 -lt $g.Length -and [string]$g[$i + 1] -eq '*') {
                if ($i + 2 -lt $g.Length -and [string]$g[$i + 2] -eq '/') { [void]$sb.Append('(?:.*/)?'); $i += 3; continue }
                [void]$sb.Append('.*'); $i += 2; continue
            }
            [void]$sb.Append('[^/]*')
        } elseif ($c -eq '?') { [void]$sb.Append('[^/]') }
        else { [void]$sb.Append([regex]::Escape($c)) }
        $i++
    }
    return '^' + $sb.ToString() + '$'
}

function Test-GlobMatch([string]$RelPath, [object[]]$Globs) {
    foreach ($g in @($Globs)) { if ($RelPath -match (Convert-GlobToRegex ([string]$g))) { return $true } }
    return $false
}

# Marcadores gravados pela sessao (dono SM): .active-run (sprint run / fix run em andamento, G14)
# e .active-spike (spike ou pedido do stakeholder declarado, G8). Ausente ou invalido -> $null.
function Get-Marker([string]$ProjectDir, [string]$Name) {
    $p = Join-Path $ProjectDir ".team-project/$Name"
    if (-not (Test-Path -LiteralPath $p)) { return $null }
    try { return (Get-Content -LiteralPath $p -Raw -Encoding UTF8 | ConvertFrom-Json) } catch { return $null }
}

# v3.47 (G17) - modelo por papel: .team-project/models.json, do stakeholder e opcional.
# Chaves = os 7 agentes do time (ou o apelido do comando: arc dev po qa sm ux); valores = o enum da ferramenta Agent.
# Chave que falta = o modelo do proprio agente (agents/<papel>.md) e as excecoes do processo. Chave ligada VENCE tudo.
# Chave que comeca com "_" e comentario. Valor ou chave invalida e ignorado e listado em Problems; arquivo
# ilegivel = como ausente (falha aberta, D5).
$script:ModelRoles   = @('architect', 'developer', 'operator', 'product-owner', 'quality-assurance', 'scrum-master', 'user-experience')
$script:ModelAliases = @{ arc = 'architect'; dev = 'developer'; po = 'product-owner'; qa = 'quality-assurance'; sm = 'scrum-master'; ux = 'user-experience' }
$script:ModelValues  = @('opus', 'sonnet', 'haiku', 'fable')

function Get-ModelsConfig([string]$ProjectDir) {
    $res = @{ State = 'ausente'; Models = @{}; Problems = @(); Executor = $null }
    $path = Join-Path $ProjectDir '.team-project/models.json'
    if (-not (Test-Path -LiteralPath $path)) { return $res }
    try { $json = Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json }
    catch { $res.State = 'invalido'; $res.Problems = @('JSON ilegivel'); return $res }
    $res.State = 'ok'
    foreach ($p in $json.PSObject.Properties) {
        $key = $p.Name.Trim().ToLowerInvariant()
        if ($key.StartsWith('_')) { continue }
        if ($key -eq 'executor') {                                                     # perfil, nao papel (v3.47, M2)
            $ev = ([string]$p.Value).Trim().ToLowerInvariant()
            if ($ev -eq 'architect') { $res.Executor = 'architect' }
            elseif ($ev) { $res.Problems += "executor: valor '$($p.Value)' invalido (use architect)" }
            continue
        }
        $role = if ($script:ModelAliases.ContainsKey($key)) { $script:ModelAliases[$key] } else { $key }
        if ($script:ModelRoles -notcontains $role) { $res.Problems += "papel desconhecido '$($p.Name)'"; continue }
        $val = ([string]$p.Value).Trim().ToLowerInvariant()
        if ([string]::IsNullOrEmpty($val)) { continue }                              # "" ou null = nao configurado
        if ($script:ModelValues -notcontains $val) { $res.Problems += "$role`: modelo '$($p.Value)' fora de $($script:ModelValues -join '|')"; continue }
        $res.Models[$role] = $val
    }
    return $res
}

# Modelo do proprio agente (frontmatter de agents/<papel>.md); $null se nao achar.
function Get-AgentDefaultModel([string]$Role) {
    $f = Join-Path $PSScriptRoot "..\agents\$Role.md"
    if (-not (Test-Path -LiteralPath $f)) { return $null }
    $head = (Get-Content -LiteralPath $f -TotalCount 15 -Encoding UTF8) -join "`n"
    $m = [regex]::Match($head, '(?m)^model:\s*(\S+)')
    if ($m.Success) { return $m.Groups[1].Value.ToLowerInvariant() }
    return $null
}

# v3.47 (M2) - perfil Arquiteto executor: models.json "executor": "architect" liga o perfil; o marcador .active-executor
# (gravado pela sessao no passo 3 do sprint run, como o .active-task) diz que o Arquiteto esta implementando a Task.
# O marcador sozinho nao basta: sem o perfil no models.json ele e ignorado (G8 continua negando codigo ao Arquiteto).
function Test-ExecutorActive([string]$ProjectDir) {
    if ($null -eq (Get-Marker $ProjectDir '.active-executor')) { return $false }
    $mc = Get-ModelsConfig $ProjectDir
    return ($mc.State -eq 'ok' -and $mc.Executor -eq 'architect')
}
# Repositorio-fonte do plugin (onde o /review roda): a matriz vale sobre roles/, agents/, hooks/...
function Test-PluginSource([string]$ProjectDir) {
    return (Test-Path -LiteralPath (Join-Path $ProjectDir '.claude-plugin/plugin.json')) -and
           (Test-Path -LiteralPath (Join-Path $ProjectDir 'roles/scrum-master/process/artifact-ownership.md'))
}
