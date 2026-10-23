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
# v3.51.4: "pasta/**" no fim casa tambem a propria pasta - New-Item -ItemType Directory .../delivery e Copy-Item ... -Destination
# .../stories/ caiam na regra generica ("dono ambiguo", garden itens 6 e 25; note.md item 1), embora a pasta tenha linha.
function Convert-GlobToRegex([string]$Glob) {
    $g = Normalize-PathText $Glob
    $sb = New-Object System.Text.StringBuilder
    $i = 0
    while ($i -lt $g.Length) {
        $c = [string]$g[$i]
        if ($c -eq '/' -and $g.Substring($i) -eq '/**') { [void]$sb.Append('(?:/.*)?'); break }
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
# Agentes disparados pela sessao (v3.51, G20; v3.51.4): .team-project/.active-agents, lista JSON de
# { type, description, desde, bg, agent_id, work, last, at }. A PreToolUse acrescenta a cada Agent da sessao em projeto com o
# time - em primeiro ou segundo plano, com ou sem .active-run (o .active-run gravado na mesma resposta do primeiro disparo
# chegava depois do hook e o agente ficava fora, garden item 5); a PreToolUse do proprio subagente grava a ultima acao
# (last, at) e o agent_id; a SubagentStop tira o agente. O hook Stop libera o fim de turno enquanto ha agente em SEGUNDO
# plano (bg) em voo ha menos de 3 h. O kanban.md mostra todos em "## Agora" (note.md item 15, garden item 11).
function Get-ActiveAgents([string]$ProjectDir) {
    $p = Join-Path $ProjectDir '.team-project/.active-agents'
    if (-not (Test-Path -LiteralPath $p)) { return @() }
    # No 5.1 o ConvertFrom-Json devolve a lista como UM objeto: o ForEach-Object a desenrola (antes vinha uma lista dentro de outra).
    try { return @((Get-Content -LiteralPath $p -Raw -Encoding UTF8 | ConvertFrom-Json) | ForEach-Object { $_ }) } catch { return @() }
}
function Set-ActiveAgents([string]$ProjectDir, $List) {
    $p = Join-Path $ProjectDir '.team-project/.active-agents'
    if (-not @($List).Count) { if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force } }
    else { [System.IO.File]::WriteAllText($p, (ConvertTo-Json -InputObject @($List) -Depth 3 -Compress), (New-Object System.Text.UTF8Encoding($false))) }
    Write-NowSection $ProjectDir @($List)
}
function Add-ActiveAgent([string]$ProjectDir, [string]$Type, [string]$Description, [bool]$Background = $true) {
    $work = ''; $wm = [regex]::Match($Description, '(?<![\w-])(T-\d+[a-z]?|F-\d+|B-\d+|H-\d+)(?![\w])'); if ($wm.Success) { $work = $wm.Value }
    $now = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    # Registro com mais de 6 h é resto de queda (a SubagentStop não veio): sai ao entrar o próximo.
    $old = @(Get-ActiveAgents $ProjectDir | Where-Object { try { ((Get-Date) - [datetime]::Parse([string]$_.desde)).TotalHours -lt 6 } catch { $false } })
    $l = $old + @([pscustomobject]@{ type = $Type; description = $Description; desde = $now; bg = $Background; agent_id = ''; work = $work; last = 'disparado'; at = $now })
    Set-ActiveAgents $ProjectDir $l
}
# Ultima acao de um subagente (PreToolUse dele): casa pelo agent_id; senao, o mais antigo do mesmo tipo ainda sem agent_id.
function Update-ActiveAgent([string]$ProjectDir, [string]$AgentId, [string]$Type, [string]$Action) {
    $l = @(Get-ActiveAgents $ProjectDir); if (-not $l.Count) { return }
    $t = $Type -replace '^.*:', ''
    $ix = -1
    for ($i = 0; $i -lt $l.Count; $i++) { if ($AgentId -and [string]$l[$i].agent_id -eq $AgentId) { $ix = $i; break } }
    if ($ix -lt 0) { for ($i = 0; $i -lt $l.Count; $i++) { if (-not [string]$l[$i].agent_id -and ([string]$l[$i].type -replace '^.*:', '') -eq $t) { $ix = $i; break } } }
    if ($ix -lt 0) { return }
    $a = $l[$ix]
    foreach ($k in 'agent_id', 'last', 'at') { if (-not $a.PSObject.Properties[$k]) { $a | Add-Member -NotePropertyName $k -NotePropertyValue '' } }
    if ($AgentId) { $a.agent_id = $AgentId }
    $a.last = (($Action -replace '\s+', ' ').Trim()); if ($a.last.Length -gt 90) { $a.last = $a.last.Substring(0, 90) + '…' }
    $a.at = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Set-ActiveAgents $ProjectDir $l
}
function Remove-ActiveAgent([string]$ProjectDir, [string]$Type, [string]$AgentId = '') {
    $l = @(Get-ActiveAgents $ProjectDir); if (-not $l.Count) { return }
    $ix = -1
    if ($AgentId) { for ($i = 0; $i -lt $l.Count; $i++) { if ([string]$l[$i].agent_id -eq $AgentId) { $ix = $i; break } } }
    if ($ix -lt 0) { for ($i = 0; $i -lt $l.Count; $i++) { if ([string]$l[$i].type -eq $Type -or ([string]$l[$i].type -replace '^team:', '') -eq ($Type -replace '^team:', '')) { $ix = $i; break } } }
    if ($ix -lt 0) { return }
    $keep = @(); for ($i = 0; $i -lt $l.Count; $i++) { if ($i -ne $ix) { $keep += $l[$i] } }
    Set-ActiveAgents $ProjectDir $keep
}

# Sprint corrente lido pelos hooks (mesma regra de scripts/checks/lib.ps1 Get-CurrentSprint, v3.51.4). $null sem a linha.
function Get-SprintNumber([string]$ProjectDir) {
    $readme = Join-Path $ProjectDir '.team-project/README.md'
    if (-not (Test-Path -LiteralPath $readme)) { return $null }
    $m = [regex]::Match([System.IO.File]::ReadAllText($readme), '(?im)^\|\s*\*{0,2}Sprint corrente\*{0,2}\s*\|\s*(?:\*\*)?\s*(?:sprint\s*)?(?:\*\*)?\s*(\d+)')
    if ($m.Success) { return $m.Groups[1].Value }
    return $null
}

# "## Agora" do kanban.md do sprint corrente (v3.51.4): uma linha por agente ativo - papel, item, ultima acao, ha quanto
# tempo. Regravada so essa secao, sem custo de token, a cada disparo, acao e volta de agente. Sprint fechado ou sem
# kanban.md: nada. Falha nunca sobe (hook).
function Write-NowSection([string]$ProjectDir, $List) {
    try {
        $n = Get-SprintNumber $ProjectDir; if (-not $n) { return }
        $kb = Join-Path $ProjectDir ".team-project/sprints/$n/kanban.md"
        if (-not (Test-Path -LiteralPath $kb) -or (Test-Path -LiteralPath (Join-Path $ProjectDir ".team-project/sprints/$n/retrospective.md"))) { return }
        $now = Get-Date
        $rows = @('## Agora', '*(Regravado pelos hooks a cada disparo, ação e volta de agente — não editar à mão. "Há" = desde a última ação.)*', '')
        if (-not @($List).Count) { $rows += 'Nenhum agente em execução.' }
        else {
            $rows += '| Papel | Item | Última ação | Há | Desde |'; $rows += '|---|---|---|---|---|'
            foreach ($a in @($List)) {
                $at = try { [datetime]::Parse([string]$(if ($a.at) { $a.at } else { $a.desde })) } catch { $now }
                $since = try { ([datetime]::Parse([string]$a.desde)).ToString('HH:mm') } catch { '?' }
                $mins = [int][Math]::Max(0, ($now - $at).TotalMinutes)
                $last = ([string]$a.last -replace '\|', '/'); if (-not $last) { $last = 'disparado' }
                $rows += "| $(([string]$a.type) -replace '^.*:', '')$(if ($a.bg -eq $false) { '' } else { ' (2º plano)' }) | $(if ($a.work) { $a.work } else { '—' }) | ``$last`` | $mins min | $since |"
            }
        }
        $block = ($rows -join "`n") + "`n`n"
        $u8 = New-Object System.Text.UTF8Encoding($false)
        $lp = "$kb.lock"; $fs = $null
        for ($i = 0; $i -lt 20 -and $null -eq $fs; $i++) { try { $fs = [System.IO.File]::Open($lp, 'OpenOrCreate', 'ReadWrite', 'None') } catch { Start-Sleep -Milliseconds 100 } }
        try {
            $text = [System.IO.File]::ReadAllText($kb, $u8)
            $sec = [regex]::Match($text, '(?ms)^##\s+Agora\s*\r?\n.*?(?=^##\s|\z)')
            if ($sec.Success) { $text = $text.Substring(0, $sec.Index) + $block + $text.Substring($sec.Index + $sec.Length) }
            else {
                $at2 = [regex]::Match($text, '(?m)^##\s+Kanban\s*$')
                if ($at2.Success) { $text = $text.Substring(0, $at2.Index) + $block + $text.Substring($at2.Index) } else { $text = $text.TrimEnd() + "`n`n" + $block }
            }
            [System.IO.File]::WriteAllText($kb, $text, $u8)
        } finally { if ($fs) { $fs.Dispose(); Remove-Item -LiteralPath $lp -Force -ErrorAction SilentlyContinue } }
    } catch { }
}

# Limite de uso da conta (v3.51.4, note.md itens 2, 6, 11 e garden item 26): o harness encerra a chamada com uma resposta
# sintetica ("You've hit your session limit · resets 11:50pm", HTTP 429). O hook que a ve grava .team-project/.usage-limit
# { desde, reset, quem, item, texto } - o sinal legivel de que o run parou por limite de conta, nao fora do contrato. O
# run.ps1 next o mostra e o apaga quando a sessao segue; o hook Stop nao barra o fim de turno com ele.
$script:LimitRe = '(?i)(hit your (session|usage|weekly|daily)? ?limit|usage limit (reached|exceeded)|rate.?limit(ed)?\b|\b429\b.*(too many|limit)|limit (reached|exceeded).*reset|resets? (at )?\d{1,2}(:\d{2})?\s*(am|pm)?)'
function Get-LimitFromTranscript([string]$Path, [int]$Tail = 30) {
    if (-not $Path -or -not (Test-Path -LiteralPath $Path)) { return $null }
    $hit = $null
    foreach ($l in (Get-Content -LiteralPath $Path -Encoding UTF8 -Tail $Tail)) {
        if ($l.IndexOf('"type":"assistant"') -lt 0) { continue }
        $synthetic = $l.IndexOf('<synthetic>') -ge 0 -or $l.IndexOf('"isApiErrorMessage":true') -ge 0
        if (-not $synthetic) { $hit = $null; continue }        # resposta normal depois do limite: a sessao seguiu
        try { $o = $l | ConvertFrom-Json; $txt = (@($o.message.content) | Where-Object { $_.type -eq 'text' } | ForEach-Object { [string]$_.text }) -join ' ' } catch { $txt = $l }
        if ($txt -match $script:LimitRe) { $hit = ($txt -replace '\s+', ' ').Trim() }
    }
    return $hit
}
function Set-LimitMarker([string]$ProjectDir, [string]$Text, [string]$Who, [string]$Item) {
    $p = Join-Path $ProjectDir '.team-project/.usage-limit'
    $reset = ([regex]::Match($Text, '(?i)resets?\s+(at\s+)?([^·.,;)]+)')).Groups[2].Value.Trim()
    $o = [ordered]@{ desde = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); reset = $reset; quem = $Who; item = $Item; texto = $(if ($Text.Length -gt 200) { $Text.Substring(0, 200) } else { $Text }) }
    if (Test-Path -LiteralPath $p) { try { $old = Get-Content -LiteralPath $p -Raw -Encoding UTF8 | ConvertFrom-Json; if ($old.desde) { $o.desde = [string]$old.desde } } catch { } }
    [System.IO.File]::WriteAllText($p, ($o | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false)))
}

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

# v3.50.1 - modo benchmark: resposta do dossie a um formulario (G18 em pre-tool.ps1 e scripts/checks/bench-answer.ps1).
function Resolve-BenchPath([string]$ProjectDir, [string]$Path) {
    if ([string]::IsNullOrWhiteSpace($Path)) { return $null }
    if ([System.IO.Path]::IsPathRooted($Path)) { return $Path }
    return (Join-Path $ProjectDir $Path)
}
function Write-BenchLog([object]$Config, [string]$ProjectDir, [string]$Theme, [string]$Origin, [string]$Question, [string]$Answer) {
    $arm = if ($Config.bench.arm) { ([string]$Config.bench.arm -replace '[^\w.-]', '_') } else { 'default' }
    $dir = Join-Path $ProjectDir ".team-project/benchmark/$arm"
    try {
        New-Item -ItemType Directory -Force $dir | Out-Null
        $line = '{0} | {1} | {2} | {3} | {4}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Theme, $Origin, (($Question -replace '\s+', ' ').Trim()), (($Answer -replace '\s+', ' ').Trim())
        [System.IO.File]::AppendAllText((Join-Path $dir 'questions.log'), $line + [Environment]::NewLine, (New-Object System.Text.UTF8Encoding($false)))
    } catch { }
}
# Responde cada pergunta de um AskUserQuestion pelo dossie (bench.answers). $null = sem bench ou sem respostas; senao, os rotulos.
function Get-BenchAnswers([object]$Config, [string]$ProjectDir, [object]$ToolInput) {
    if ($null -eq $Config.bench -or -not $Config.bench.answers) { return $null }
    $path = Resolve-BenchPath $ProjectDir ([string]$Config.bench.answers)
    if (-not $path -or -not (Test-Path -LiteralPath $path)) { return $null }
    $rules = @((Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json).respostas)
    $answers = @()
    foreach ($q in @($ToolInput.questions)) {
        $opts = @($q.options)
        $text = ([string]$q.question + ' ' + [string]$q.header)
        $hit = $null
        foreach ($r in $rules) { if ($r.match -and ($text -match [string]$r.match)) { $hit = $r; break } }
        $pick = $null
        if ($hit -and $hit.pick) { $pick = @($opts | Where-Object { ([string]$_.label) -match [string]$hit.pick } | Select-Object -First 1)[0] }
        $origin = if ($pick) { 'dossie' } else { 'recomendada' }
        if (-not $pick) { $pick = @($opts | Where-Object { ([string]$_.label) -match '(?i)recomend' } | Select-Object -First 1)[0] }
        if (-not $pick) { $pick = @($opts | Where-Object { ([string]$_.label) -notmatch '(?i)^pedir mais contexto' } | Select-Object -First 1)[0] }
        if (-not $pick) { $pick = $opts[0] }
        $label = [string]$pick.label
        $theme = if ($hit -and $hit.tema) { [string]$hit.tema } else { '(fora do dossie)' }
        Write-BenchLog $Config $ProjectDir $theme $origin ([string]$q.question) $label
        $answers += $label
    }
    return ,$answers
}
function Format-BenchAnswers([string[]]$Answers) {
    if ($Answers.Count -eq 1) { return "resposta do stakeholder: $($Answers[0])" }
    return 'resposta do stakeholder: ' + (@(0..($Answers.Count - 1) | ForEach-Object { "pergunta $($_ + 1) → $($Answers[$_])" }) -join ' · ')
}
