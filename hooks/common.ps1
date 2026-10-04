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
    $line = '{0} | {1} | {2} | {3} | {4} | {5}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Guard, $role, $tool, $Target, $clean
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

# Repositorio-fonte do plugin (onde o /review roda): a matriz vale sobre roles/, agents/, hooks/...
function Test-PluginSource([string]$ProjectDir) {
    return (Test-Path -LiteralPath (Join-Path $ProjectDir '.claude-plugin/plugin.json')) -and
           (Test-Path -LiteralPath (Join-Path $ProjectDir 'roles/scrum-master/process/artifact-ownership.md'))
}
