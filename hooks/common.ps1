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
        # v3.53.1 (G23): teto de contexto por instancia do dev, em tokens da ultima chamada; 0 = desligado
        devContextCap    = 100000
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
        if ($null -ne $json.devContextCap)    { $cfg.devContextCap    = [int]$json.devContextCap }
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

# v3.54.1: Test-MountingSpec (margem stub do dev, G9 e close R7-margem) num arquivo sem efeito ao carregar.
. (Join-Path $PSScriptRoot 'test-files.ps1')

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

# v3.56.0 (C): stacks do projeto pela inferencia, sem a chave guards.json -> "stacks" - a raiz e as pastas do primeiro nivel
# (package.json, build.gradle, *.csproj). Usada pelo lib.ps1 (Get-Stacks) e pelo SessionStart (G13, aviso).
function Get-InferredStacks([string]$Root) {
    # Só a raiz e as pastas do primeiro nível (source/, app/…), sem node_modules, .git e .team-project — varrer fundo custa.
    $dirs = @($Root) + @(Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^(node_modules|\.git|\.team-project|dist|build|bin|obj)$' } | ForEach-Object { $_.FullName })
    $st = @(); $pkg = ''; $grad = ''; $net = $false
    foreach ($d in $dirs) {
        $p = Join-Path $d 'package.json'; if (Test-Path -LiteralPath $p -PathType Leaf) { $pkg += "`n" + [System.IO.File]::ReadAllText($p) }
        foreach ($g in @('build.gradle', 'build.gradle.kts', 'app/build.gradle', 'app/build.gradle.kts')) { $gp = Join-Path $d $g; if (Test-Path -LiteralPath $gp -PathType Leaf) { $grad += "`n" + [System.IO.File]::ReadAllText($gp) } }
        if (@(Get-ChildItem -LiteralPath $d -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in '.csproj', '.sln' }).Count) { $net = $true }
    }
    if ($pkg -match '"@angular/core"') { $st += 'angular' }
    if ($pkg -match '"@ionic/(angular|core|react|vue)"|"@capacitor/core"') { $st += 'ionic-capacitor' }
    if ($pkg -match '"react"\s*:' -and $st -notcontains 'ionic-capacitor') { $st += 'react' }
    if ($grad -match '(?i)kotlin' -and $st -notcontains 'ionic-capacitor') { $st += 'kotlin-android' }
    if ($net) { $st += 'dotnet' }
    return @($st | Select-Object -Unique)
}
function Test-GlobMatch([string]$RelPath, [object[]]$Globs) {
    foreach ($g in @($Globs)) { if ($RelPath -match (Convert-GlobToRegex ([string]$g))) { return $true } }
    return $false
}

# v3.57.3 (G7, chamador do operator): o papel escrito na linha "Chamador: <papel> <ID>" no nome curto do consumo — dev, arc,
# qa, ux, sm, po, task-runner (aceita "executor") e sessão. '' quando não é papel conhecido.
$script:CallerByRole = @{ 'developer' = 'dev'; 'architect' = 'arc'; 'quality-assurance' = 'qa'; 'user-experience' = 'ux'; 'scrum-master' = 'sm'; 'product-owner' = 'po'; 'security-engineer' = 'sec'; 'task-runner' = 'task-runner' }
function Get-CallerToken([string]$Text) {
    $x = ([string]$Text).Trim().Trim('`', '*', '.', ',', ':', ';', '"', "'").ToLowerInvariant() -replace 'ã', 'a'
    switch -Regex ($x) {
        '^(dev|developer|desenvolvedor)$' { return 'dev' }
        '^(arc|arquiteto|architect)$' { return 'arc' }
        '^(qa|quality-assurance)$' { return 'qa' }
        '^(ux|user-experience)$' { return 'ux' }
        '^(sm|scrum-master)$' { return 'sm' }
        '^(po|product-owner)$' { return 'po' }
        '^(sec|security-engineer)$' { return 'sec' }
        '^(executor|task-runner)$' { return 'task-runner' }
        '^(sessao|session)$' { return 'sessão' }
    }
    return ''
}

# G14 (run sem trava) — lista base, reparo declarado e casamento por prefixo. v3.55.0: moraram no pre-tool.ps1; o plan.ps1
# (regra 32, "### Comandos da Task") confere os comandos do plano com os MESMOS, sem um segundo casamento.
$script:runBase = @(
    'git status', 'git diff', 'git log', 'git show', 'git grep', 'git blame', 'git add', 'git commit', 'git restore --staged',
    'git rev-parse', 'git ls-files', 'git branch --show-current', 'git check-ignore', 'git stash list',
    # v3.53.1 (plugin-report do sprint 4 do garden, item 7): git só de leitura — cada um virava parada e formulário no run.
    'git cat-file', 'git ls-tree', 'git rev-list', 'git show-ref', 'git merge-base', 'git describe', 'git name-rev',
    'git worktree list', 'git remote -v', 'git tag -l', 'git tag --list', 'git config --get', 'git config --list', 'git stash show',
    'get-childitem', 'gci', 'ls', 'dir', 'get-content', 'gc', 'cat', 'type', 'get-item', 'gi', 'get-itemproperty', 'test-path',
    'resolve-path', 'split-path', 'join-path', 'select-string', 'sls', 'select-object', 'select', 'where-object', 'where', '?',
    'foreach-object', '%', 'sort-object', 'sort', 'group-object', 'measure-object', 'measure', 'compare-object', 'format-table',
    'ft', 'format-list', 'fl', 'out-string', 'out-null', 'write-output', 'echo', 'write-host', 'get-date', 'get-location', 'pwd',
    'set-location', 'cd', 'push-location', 'pop-location', 'convertfrom-json', 'convertto-json', 'get-command', 'get-filehash',
    'get-member', 'get-winevent', 'get-process', 'get-ciminstance', 'get-wmiobject',
    'head', 'tail', 'wc', 'grep', 'rg', 'find', 'uniq', 'diff', 'which', 'stat', 'tree', 'true')

# v3.53.6 (sprint 5 do garden, item 6): o reparo que o projeto declara em guards.json → targets.<alvo>.repair (ex.:
# "docker restart horta-emulador; adb connect localhost:5555") entra na lista da G14 — cada trecho (separado por ;, && ou
# ||) como prefixo, como as entradas de runCommands. Antes o dev rodava o reparo à mão e a G14 negava.
function Get-RepairCommands([string]$ProjectDir) {
    $g = Join-Path $ProjectDir '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $g)) { return @() }
    try { $j = Get-Content -LiteralPath $g -Raw -Encoding UTF8 | ConvertFrom-Json } catch { return @() }
    if (-not $j -or -not $j.PSObject.Properties['targets'] -or $null -eq $j.targets) { return @() }
    $out = @()
    foreach ($t in @($j.targets.PSObject.Properties)) {
        $v = $t.Value
        if ($null -eq $v -or $v -isnot [pscustomobject] -or -not $v.PSObject.Properties['repair'] -or -not [string]$v.repair) { continue }
        foreach ($piece in ([string]$v.repair -split ';|&&|\|\||\r?\n')) { $x = $piece.Trim(); if ($x) { $out += $x } }
    }
    return $out
}

# O casamento por prefixo da lista da G14: o trecho (minúsculo, e a forma com as aspas devolvidas) é igual à entrada ou começa
# por ela seguida de espaço/tabulação.
function Test-CommandPrefix([string]$Low, [string]$LowRestored, [string]$Prefix) {
    $pl = ([string]$Prefix).Trim().ToLowerInvariant()
    return [bool]($pl -and ($Low -eq $pl -or $Low.StartsWith($pl + ' ') -or $Low.StartsWith($pl + "`t") -or $LowRestored -eq $pl -or $LowRestored.StartsWith($pl + ' ')))
}

# Marcadores gravados pela sessao (dono SM): .active-run (sprint run / fix run em andamento, G14)
# e .active-spike (spike ou pedido do stakeholder declarado, G8). Ausente ou invalido -> $null.
# Agentes em voo (v3.51, G20; v3.51.4; v3.52.2): .team-project/.active-agents, lista JSON de
# { type, description, desde, session, parent, agent_id, work, last, at }. A PreToolUse acrescenta TODO Agent em projeto com
# o time - da sessao (parent '') e de papel (parent = agent_id de quem disparou; o executor de Task e os filhos dele, note.md
# item 4), com ou sem .active-run (garden item 5); a PreToolUse do proprio subagente grava a ultima acao (last, at) e o
# agent_id; a SubagentStop tira o agente (com filho vivo, fica como 'aguardando filho'). v3.52.2 (note.md item 2): todo
# agente e assincrono - o Stop libera o fim de turno enquanto ha agente DESTA sessao com sinal de vida ha menos de 3 h.
# SessionStart startup/resume move o registro para .team-project/.interrupted (item 3). O kanban.md mostra todos em "## Agora".
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
# v3.59.1 (sprint 6 do garden, T-069b): cada hook é um processo e lia-alterava-gravava o .active-agents sem trava. Com a
# SubagentStop do dev e a PreToolUse do executor no mesmo segundo (19:25:26), a gravação da PreToolUse — feita sobre a lista
# lida ANTES da remoção — devolveu o dev ao registro; o executor, ao parar de vez, ficou "aguardando filho" de um dev já
# encerrado, e o run.ps1 next mandou esperar 20 min. Mutex nomeado por projeto (processos diferentes); sem a trava em 5 s, segue
# sem ela (hook nunca prende o harness).
function Invoke-ActiveAgentsLocked([string]$ProjectDir, [scriptblock]$Body) {
    $name = 'Global\team-active-agents-' + ([System.BitConverter]::ToString((New-Object System.Security.Cryptography.SHA1Managed).ComputeHash([System.Text.Encoding]::UTF8.GetBytes(([string]$ProjectDir).ToLowerInvariant().TrimEnd('\', '/'))))).Replace('-', '').Substring(0, 16)
    $m = $null; $own = $false
    try {
        $m = New-Object System.Threading.Mutex($false, $name)
        try { $own = $m.WaitOne(5000) } catch [System.Threading.AbandonedMutexException] { $own = $true }
        return (& $Body)
    } finally {
        if ($own) { try { $m.ReleaseMutex() } catch { } }
        if ($m) { $m.Dispose() }
    }
}
# v3.59.1: a última rodada encerrada de cada agente, lida do usage.jsonl (a SubagentStop grava uma linha por rodada, com ts =
# fim da rodada). @{ <agent_id> = @{ ts; description; children } } só dos ids pedidos.
function Get-AgentRounds([string]$ProjectDir, [string[]]$Ids) {
    $out = @{}
    $ids = @($Ids | Where-Object { $_ })
    $p = Join-Path $ProjectDir '.team-project/usage.jsonl'
    if (-not $ids.Count -or -not (Test-Path -LiteralPath $p)) { return $out }
    foreach ($line in [System.IO.File]::ReadLines($p)) {
        $hit = $false; foreach ($id in $ids) { if ($line.IndexOf($id) -ge 0) { $hit = $true; break } }
        if (-not $hit) { continue }
        try { $r = $line | ConvertFrom-Json } catch { continue }
        $aid = [string]$r.agent_id
        if ($ids -contains $aid) { $out[$aid] = @{ ts = [string]$r.ts; description = [string]$r.description; children = @($r.children); waiting = [bool]($r.PSObject.Properties['waiting'] -and $r.waiting) } }
    }
    return $out
}
# v3.59.1: o registro do agente ainda espera trabalho? Falso quando a rodada mais recente dele já terminou depois do último
# sinal de vida (a linha do usage.jsonl é posterior ao 'at'): o agente parou e nenhuma ação veio depois — resto de corrida.
# Rodada encerrada com "ESPERANDO <comando>" (waiting) conta como aberta: o agente volta com o fim do comando.
function Test-AgentRoundOpen($Agent, $Rounds) {
    $id = [string]$Agent.agent_id
    if (-not $id -or -not $Rounds.ContainsKey($id)) { return $true }
    if ($Rounds[$id].waiting) { return $true }
    try { return ([datetime]::Parse([string]$Rounds[$id].ts) -lt [datetime]::Parse([string]$Agent.at)) } catch { return $true }
}
# v3.59.1: filhos do agente que ainda contam — registro com parent = ele e rodada aberta.
function Get-PendingChildren($List, [string]$AgentId, $Rounds) {
    if (-not $AgentId) { return @() }
    return @($List | Where-Object { $_.PSObject.Properties['parent'] -and [string]$_.parent -eq $AgentId -and (Test-AgentRoundOpen $_ $Rounds) })
}
# Horas desde o último sinal de vida do registro (at; senão desde). Ilegível = muito velho.
function Get-AgentIdleHours($Agent) {
    try { return ((Get-Date) - [datetime]::Parse([string]$(if ($Agent.at) { $Agent.at } else { $Agent.desde }))).TotalHours } catch { return 1e6 }
}
# v3.53.1 (plugin-report do sprint 4 do garden, item 3): o processo do Claude Code que hospeda o agente - o primeiro ancestral
# do hook que nao e shell. O SessionStart de uma segunda sessao aberta no mesmo projeto tratava os agentes vivos da primeira
# como mortos, e o run.ps1 next redisparava a Task: dois devs no mesmo emulador. @{ pid; start } ou $null.
function Get-HostProcess {
    # v3.66.1 (item D): a suíte do plugin simula o hospedeiro (TEAM_TEST_HOST_PID = um processo vivo dela) — fora de uma sessão
    # do Claude Code (a rodada desacoplada) não há ancestral que não seja shell. Na produção a variável não existe.
    if ($env:TEAM_TEST_HOST_PID) {
        $tp = Get-Process -Id ([int]$env:TEAM_TEST_HOST_PID) -ErrorAction SilentlyContinue
        if ($tp) { try { return @{ pid = [int]$tp.Id; start = $tp.StartTime.ToString('yyyy-MM-dd HH:mm:ss') } } catch { } }
        return $null
    }
    try {
        $id = $PID
        for ($i = 0; $i -lt 6; $i++) {
            $p = Get-CimInstance Win32_Process -Filter "ProcessId=$id" -ErrorAction Stop
            if (-not $p) { return $null }
            if ($i -gt 0 -and [string]$p.Name -notmatch '^(?i)(powershell|pwsh|cmd|bash|sh|conhost|wsl)(\.exe)?$') {
                return @{ pid = [int]$p.ProcessId; start = $p.CreationDate.ToString('yyyy-MM-dd HH:mm:ss') }
            }
            $id = [int]$p.ParentProcessId; if (-not $id) { return $null }
        }
    } catch { }
    return $null
}
# O processo que hospeda o agente segue vivo? $true/$false; $null = registro sem host_pid (anterior à v3.53.1).
function Test-AgentHostAlive($Agent) {
    if (-not $Agent.PSObject.Properties['host_pid'] -or -not $Agent.host_pid) { return $null }
    $p = Get-Process -Id ([int]$Agent.host_pid) -ErrorAction SilentlyContinue
    if (-not $p) { return $false }
    try { return ($p.StartTime.ToString('yyyy-MM-dd HH:mm:ss') -eq [string]$Agent.host_start) } catch { return $true }   # sem acesso ao início: existe
}
# v3.63.0 (sprint 6 do projeto piloto, Q-S6d, 17/11): registro sem sinal de vida — mais de $MaxIdleMin min sem ação de
# ferramenta, ou o processo hospedeiro encerrado — e sem filho vivo no registro. O run.ps1 já não o contava como vivo
# (Get-LiveAgents), mas o "## Agora" e o /team-status o mostravam "trabalhando" 37 min depois de ele sumir, e alguém renomeou o
# .active-agents à mão. O host_pid é o processo do Claude Code que hospeda a SESSÃO: vivo, prova que a sessão existe, não o agente.
function Test-AgentStale($Agent, $List = @(), [int]$MaxIdleMin = 20) {
    $idle = (Get-AgentIdleHours $Agent) * 60
    if ($idle -lt $MaxIdleMin -and (Test-AgentHostAlive $Agent) -ne $false) { return $false }
    $id = [string]$Agent.agent_id
    if ($id -and @(@($List) | Where-Object { $_.PSObject.Properties['parent'] -and [string]$_.parent -eq $id -and -not (Test-AgentStale $_ @() $MaxIdleMin) }).Count) { return $false }
    return $true
}
# v3.63.0: tira do .active-agents os registros sem sinal de vida do item (todos, com $Work vazio) e os leva ao .interrupted,
# como a SessionStart faz com os da sessão anterior. Devolve os registros removidos (quem chama diz e grava no run-log).
function Remove-StaleAgents([string]$ProjectDir, [string]$Work = '', [int]$MaxIdleMin = 20) {
    $script:StaleRemoved = @()
    $null = Invoke-ActiveAgentsLocked $ProjectDir {
        $all = @(Get-ActiveAgents $ProjectDir)
        $st = @($all | Where-Object { (-not $Work -or [string]$_.work -eq $Work) -and (Test-AgentStale $_ $all $MaxIdleMin) })
        if ($st.Count) {
            $ip = Join-Path $ProjectDir '.team-project/.interrupted'
            $prev = @(); if (Test-Path -LiteralPath $ip) { try { $prev = @((Get-Content -LiteralPath $ip -Raw -Encoding UTF8 | ConvertFrom-Json) | ForEach-Object { $_ }) } catch { $prev = @() } }
            $recs = @($st | ForEach-Object { [pscustomobject][ordered]@{ type = [string]$_.type; work = [string]$_.work; parent = [string]$_.parent; desde = [string]$_.desde; last = [string]$_.last; at = [string]$_.at; session = [string]$_.session; agent_id = $(if ($_.PSObject.Properties['agent_id']) { [string]$_.agent_id } else { '' }); transcript = ''; session_transcript = ''; reason = "sem sinal de vida há $MaxIdleMin min ou mais" } })
            [System.IO.File]::WriteAllText($ip, (ConvertTo-Json -InputObject @($prev + $recs) -Depth 3 -Compress), (New-Object System.Text.UTF8Encoding($false)))
            Set-ActiveAgents $ProjectDir @($all | Where-Object { $st -notcontains $_ })
        }
        $script:StaleRemoved = $st
    }
    return @($script:StaleRemoved)
}
# Agentes do item ainda vivos: processo hospedeiro vivo (ou desconhecido) e sinal de vida há menos de $MaxIdleMin minutos
# (um verify full fica até ~10 min sem ação de ferramenta). Agente cortado sem SubagentStop sai daqui ao passar do prazo.
function Get-LiveAgents([string]$ProjectDir, [string]$Work, [int]$MaxIdleMin = 20) {
    $all = @(Get-ActiveAgents $ProjectDir)
    $cand = @($all | Where-Object { [string]$_.work -eq $Work -and (Get-AgentIdleHours $_) * 60 -lt $MaxIdleMin -and (Test-AgentHostAlive $_) -ne $false })
    if (-not $cand.Count) { return @() }
    # v3.59.1 (T-069b): registro cuja rodada já terminou não é agente vivo; "aguardando filho" só vale com filho de rodada aberta
    # ou, sem ele, nos 3 min seguintes ao fim do último filho (o aviso do filho está acordando o pai). Antes, os dois esperavam
    # os 20 min do prazo de sinal de vida.
    $rounds = Get-AgentRounds $ProjectDir @($all | ForEach-Object { [string]$_.agent_id })
    return @($cand | Where-Object {
        $a = $_
        if ([string]$a.last -ne 'aguardando filho') { return (Test-AgentRoundOpen $a $rounds) }
        if (@(Get-PendingChildren $all ([string]$a.agent_id) $rounds).Count) { return $true }
        $kids = @(); if ($rounds.ContainsKey([string]$a.agent_id)) { $kids = @($rounds[[string]$a.agent_id].children) }
        $lastKid = $null; $lastWaiting = $false
        foreach ($k in $kids) { if ($rounds.ContainsKey([string]$k)) { try { $t = [datetime]::Parse([string]$rounds[[string]$k].ts); if (-not $lastKid -or $t -gt $lastKid) { $lastKid = $t; $lastWaiting = [bool]$rounds[[string]$k].waiting } } catch { } } }
        if (-not $kids.Count) { return $true }   # sem a lista de filhos no usage.jsonl: comportamento anterior
        if ($lastWaiting) { return $true }       # o último filho parou com ESPERANDO: o comando dele ainda o acorda
        if (-not $lastKid) {
            # Filho que ainda não parou nenhuma vez: o pai espera de fato (a rodada do filho não tem linha ainda).
            $missing = @($kids | Where-Object { -not $rounds.ContainsKey([string]$_) })
            return [bool]$missing.Count
        }
        return (((Get-Date) - $lastKid).TotalMinutes -lt 3)
    })
}
# v3.62.2: o agente só conta como vivo por uma rodada encerrada com "ESPERANDO <comando>" — a dele, ou, no "aguardando filho",
# a do último filho. Essa espera só vale se o comando ainda roda: o Claude Code encerra o comando do agente quando ele dá a
# resposta final, e o aviso não vem (Q-S6d do garden: o executor e a sessão esperaram horas). Quem tem o estado do comando
# (run.ps1: Get-TaskWait) descarta esse agente quando nada da Task roda.
function Test-AgentOnlyWaiting([string]$ProjectDir, $Agent) {
    $id = [string]$Agent.agent_id
    if (-not $id) { return $false }
    $all = @(Get-ActiveAgents $ProjectDir)
    $rounds = Get-AgentRounds $ProjectDir @($all | ForEach-Object { [string]$_.agent_id })
    if ([string]$Agent.last -ne 'aguardando filho') {
        if (-not $rounds.ContainsKey($id) -or -not $rounds[$id].waiting) { return $false }
        try { return ([datetime]::Parse([string]$rounds[$id].ts) -ge [datetime]::Parse([string]$Agent.at)) } catch { return $true }
    }
    if (@(Get-PendingChildren $all $id $rounds | Where-Object { -not (Test-AgentOnlyWaiting $ProjectDir $_) }).Count) { return $false }
    $kids = @(); if ($rounds.ContainsKey($id)) { $kids = @($rounds[$id].children) }
    $last = $null; $lastW = $false
    foreach ($k in $kids) { if ($rounds.ContainsKey([string]$k)) { try { $t = [datetime]::Parse([string]$rounds[[string]$k].ts); if (-not $last -or $t -gt $last) { $last = $t; $lastW = [bool]$rounds[[string]$k].waiting } } catch { } } }
    return $lastW
}
function Add-ActiveAgent([string]$ProjectDir, [string]$Type, [string]$Description, [string]$Session = '', [string]$Parent = '') {
    # v3.52.2 (note.md item 15): Q-S<n> (correção do portão) também é item de trabalho.
    $work = ''; $wm = [regex]::Match($Description, '(?<![\w-])(Q-S\d+[a-z]?|T-\d+[a-z]?|S\d+-F\d+|F-\d+|B-\d+|H-\d+|S\d+)(?![\w])'); if ($wm.Success) { $work = $wm.Value }
    $now = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    # v3.52.2 (note.md itens 2-4): sem "bg" (todo agente é assíncrono); session = sessão que disparou, parent = agente que disparou.
    # v3.53.1: host_pid/host_start = o processo do Claude Code que hospeda o agente (Get-HostProcess).
    $hp = Get-HostProcess
    $null = Invoke-ActiveAgentsLocked $ProjectDir {
        # Registro sem sinal de vida há mais de 6 h é resto de queda (a SubagentStop não veio): sai ao entrar o próximo.
        $old = @(Get-ActiveAgents $ProjectDir | Where-Object { (Get-AgentIdleHours $_) -lt 6 })
        $l = $old + @([pscustomobject][ordered]@{ type = $Type; description = $Description; desde = $now; session = $Session; parent = $Parent; agent_id = ''; work = $work; last = 'disparado'; at = $now
            host_pid = $(if ($hp) { $hp.pid } else { 0 }); host_start = $(if ($hp) { $hp.start } else { '' }) })
        Set-ActiveAgents $ProjectDir $l
    }
}
# Ultima acao de um subagente (PreToolUse dele): casa pelo agent_id; senao, o mais antigo do mesmo tipo ainda sem agent_id.
# v3.59.1 (sprint 6 do garden, T-069b, 19:14): agente que encerrou o turno esperando um comando em segundo plano sai do
# registro (SubagentStop sem filho) e, acordado pelo fim do comando, voltava a agir FORA dele — o executor parou sem filho, o
# run.ps1 next não viu ninguém e mandou um segundo executor (dois na mesma Task por 12 min). Agora a ação de um agent_id já
# conhecido no usage.jsonl o devolve ao registro, com a descrição, o item e o pai (quem o tem na lista de filhos).
function Update-ActiveAgent([string]$ProjectDir, [string]$AgentId, [string]$Type, [string]$Action, [string]$Session = '') {
    $hp = $null; $hpRead = $false
    $null = Invoke-ActiveAgentsLocked $ProjectDir {
        $l = @(Get-ActiveAgents $ProjectDir)
        $t = $Type -replace '^.*:', ''
        $ix = -1
        for ($i = 0; $i -lt $l.Count; $i++) { if ($AgentId -and [string]$l[$i].agent_id -eq $AgentId) { $ix = $i; break } }
        if ($ix -lt 0) { for ($i = 0; $i -lt $l.Count; $i++) { if (-not [string]$l[$i].agent_id -and ([string]$l[$i].type -replace '^.*:', '') -eq $t) { $ix = $i; break } } }
        if ($ix -lt 0) {
            if (-not $AgentId) { return }
            $p = Join-Path $ProjectDir '.team-project/usage.jsonl'
            if (-not (Test-Path -LiteralPath $p)) { return }
            $desc = $null; $parent = ''
            foreach ($line in [System.IO.File]::ReadLines($p)) {
                if ($line.IndexOf($AgentId) -lt 0) { continue }
                try { $r = $line | ConvertFrom-Json } catch { continue }
                if ([string]$r.agent_id -eq $AgentId) { $desc = [string]$r.description }
                elseif (@($r.children) -contains $AgentId) { $parent = [string]$r.agent_id }
            }
            if ($null -eq $desc) { return }   # agente que nunca parou: o registro dele não é deste hook
            $wm = [regex]::Match($desc, '(?<![\w-])(Q-S\d+[a-z]?|T-\d+[a-z]?|S\d+-F\d+|F-\d+|B-\d+|H-\d+|S\d+)(?![\w])')
            if (-not $hpRead) { $hp = Get-HostProcess; $hpRead = $true }
            $now = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            $l += [pscustomobject][ordered]@{ type = $Type; description = "$desc (retomado)"; desde = $now; session = $Session; parent = $parent; agent_id = $AgentId
                work = $(if ($wm.Success) { $wm.Value } else { '' }); last = ''; at = $now
                host_pid = $(if ($hp) { $hp.pid } else { 0 }); host_start = $(if ($hp) { $hp.start } else { '' }) }
            $ix = $l.Count - 1
        }
        $a = $l[$ix]
        foreach ($k in 'agent_id', 'last', 'at') { if (-not $a.PSObject.Properties[$k]) { $a | Add-Member -NotePropertyName $k -NotePropertyValue '' } }
        if ($AgentId) { $a.agent_id = $AgentId }
        $a.last = (($Action -replace '\s+', ' ').Trim()); if ($a.last.Length -gt 90) { $a.last = $a.last.Substring(0, 90) + '…' }
        $a.at = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        Set-ActiveAgents $ProjectDir $l
    }
}
function Remove-ActiveAgent([string]$ProjectDir, [string]$Type, [string]$AgentId = '') {
    return (Invoke-ActiveAgentsLocked $ProjectDir {
        $l = @(Get-ActiveAgents $ProjectDir); if (-not $l.Count) { return '' }
        $ix = -1
        if ($AgentId) { for ($i = 0; $i -lt $l.Count; $i++) { if ([string]$l[$i].agent_id -eq $AgentId) { $ix = $i; break } } }
        # v3.59.1 (T-069b, 19:56): sem o agent_id no registro, o tipo casava o PRIMEIRO do tipo — o executor velho, de outro
        # agent_id — e o remarcava "aguardando filho" com hora nova: o resto de 19:27 ganhou mais 20 min. Pelo tipo, só registro
        # ainda sem agent_id (o agente parou antes da primeira ação de ferramenta).
        if ($ix -lt 0) { for ($i = 0; $i -lt $l.Count; $i++) { if ((-not $AgentId -or -not [string]$l[$i].agent_id) -and ([string]$l[$i].type -eq $Type -or ([string]$l[$i].type -replace '^team:', '') -eq ($Type -replace '^team:', ''))) { $ix = $i; break } } }
        if ($ix -lt 0) { return '' }
        # v3.52.2 (note.md item 4): o executor de Task encerra o turno com o filho vivo e é acordado pelo aviso dele — fica no
        # registro (a G20 e a retomada o veem), marcado 'aguardando filho'. Filho = registro com parent = o agent_id dele.
        # v3.59.1: só filho de rodada aberta; o registro de filho que já parou (resto de corrida) sai junto.
        $me = [string]$l[$ix].agent_id
        $kids = @(); if ($me) { $kids = @($l | Where-Object { $_.PSObject.Properties['parent'] -and [string]$_.parent -eq $me }) }
        $rounds = if ($kids.Count) { Get-AgentRounds $ProjectDir @($kids | ForEach-Object { [string]$_.agent_id }) } else { @{} }
        $pending = @(Get-PendingChildren $kids $me $rounds)
        $stale = @($kids | Where-Object { $pending -notcontains $_ })
        if ($pending.Count) {
            $a = $l[$ix]
            foreach ($k in 'last', 'at') { if (-not $a.PSObject.Properties[$k]) { $a | Add-Member -NotePropertyName $k -NotePropertyValue '' } }
            $a.last = 'aguardando filho'; $a.at = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            Set-ActiveAgents $ProjectDir @($l | Where-Object { $stale -notcontains $_ })
            return 'aguardando filho'
        }
        $keep = @(); for ($i = 0; $i -lt $l.Count; $i++) { if ($i -ne $ix -and $stale -notcontains $l[$i]) { $keep += $l[$i] } }
        Set-ActiveAgents $ProjectDir $keep
        return 'removido'
    })
}

# Sprint corrente lido pelos hooks (mesma regra de scripts/checks/lib.ps1 Get-CurrentSprint, v3.51.4). $null sem a linha.
function Get-SprintNumber([string]$ProjectDir) {
    $readme = Join-Path $ProjectDir '.team-project/README.md'
    if (-not (Test-Path -LiteralPath $readme)) { return $null }
    $m = [regex]::Match([System.IO.File]::ReadAllText($readme), '(?im)^\|\s*\*{0,2}Sprint corrente\*{0,2}\s*\|\s*(?:\*\*)?\s*(?:sprint\s*)?(?:\*\*)?\s*(\d+)')
    if ($m.Success) { return $m.Groups[1].Value }
    return $null
}

# "## Agora" do kanban.md do sprint corrente (v3.51.4): uma linha por agente ativo. Regravada so essa secao, sem custo de
# token, a cada disparo, acao e volta de agente. Sprint fechado ou sem kanban.md: nada. Falha nunca sobe (hook).
# v3.57.1 (note.md item 11): para quem acompanha, nao para quem depura — o papel com nome de gente, a Task com o titulo do
# backlog, o que ele faz numa frase simples (Get-PlainAction) e HORARIOS FIXOS. O "Ha N min" era calculado ao gravar e o
# arquivo so muda na acao seguinte: aberto 12 min depois, ainda dizia "0 min" (o comando cru continua no .active-agents e no
# /team-status, que calcula na leitura).
# v3.59.0: Get-PlainRole, Get-PlainAction e o nome de cada parte (Get-PlainNames) moram em scripts/checks/plain.ps1 — a mesma
# fonte do quadro, do /team-status e da linha PARA O STAKEHOLDER: do run.ps1 next.
. (Join-Path $PSScriptRoot '..\scripts\checks\plain.ps1')
function Write-NowSection([string]$ProjectDir, $List) {
    try {
        $n = Get-SprintNumber $ProjectDir; if (-not $n) { return }
        $kb = Join-Path $ProjectDir ".team-project/sprints/$n/kanban.md"
        if (-not (Test-Path -LiteralPath $kb) -or (Test-Path -LiteralPath (Join-Path $ProjectDir ".team-project/sprints/$n/retrospective.md"))) { return }
        $now = Get-Date
        $rows = @('## Agora', "*(Quem do time está trabalhando neste momento. Atualizado às $($now.ToString('HH:mm')), a cada ação — os horários são fixos: compare com o relógio. Detalhe técnico: ``/team-status detalhe``.)*", '')
        if (-not @($List).Count) { $rows += 'Ninguém do time está trabalhando neste momento.' }
        else {
            $titles = Get-PlainNames $ProjectDir $n   # v3.59.0: o nome de negócio da parte, com o código no fim
            $rows += '| Quem | Em quê | O que está fazendo | Última ação às | Começou às |'; $rows += '|---|---|---|---|---|'
            foreach ($a in @($List)) {
                $at = try { ([datetime]::Parse([string]$(if ($a.at) { $a.at } else { $a.desde }))).ToString('HH:mm') } catch { '?' }
                $since = try { ([datetime]::Parse([string]$a.desde)).ToString('HH:mm') } catch { '?' }
                $doing = (Get-PlainAction ([string]$a.last)) -replace '\|', '/'
                if (Test-AgentStale $a @($List)) { $doing = "sem sinal desde $at — provavelmente encerrado" }   # v3.63.0
                # v3.52.2 (note.md itens 2 e 4): todo agente é assíncrono; o filho mostra quem o chamou.
                $by = ''
                if ($a.PSObject.Properties['parent'] -and [string]$a.parent) { $pa = @(@($List) | Where-Object { [string]$_.agent_id -eq [string]$a.parent } | Select-Object -First 1); if ($pa.Count) { $by = ' (chamado pelo ' + (Get-PlainRole ([string]$pa[0].type)) + ')' } }
                $wk = [string]$a.work
                $task = if ($wk) { (Get-PlainLabel $titles $wk) -replace '\|', '/' } else { '—' }
                $rows += "| $(Get-PlainRole ([string]$a.type))$by | $task | $doing | $at | $since |"
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
# Transcript do subagente: o campo do evento, se vier; senão <dir do transcript da sessão>/<sessão>/subagents/agent-<id>.jsonl.
# v3.53.1: daqui (era do subagent-stop.ps1) — a PreToolUse do dev também o lê (G23).
function Get-AgentTranscript([object]$HookInput) {
    foreach ($name in 'agent_transcript_path', 'subagent_transcript_path') {
        $p = $HookInput.PSObject.Properties[$name]
        if ($p -and $p.Value -and (Test-Path -LiteralPath ([string]$p.Value))) { return [string]$p.Value }
    }
    $parent = [string]$HookInput.transcript_path
    $id = [string]$HookInput.agent_id
    if (-not $parent -or -not $id) { return $null }
    $dir = Join-Path (Split-Path $parent) ([System.IO.Path]::GetFileNameWithoutExtension($parent))
    $cand = Join-Path $dir "subagents/agent-$id.jsonl"
    if (Test-Path -LiteralPath $cand) { return $cand }
    return $null
}
# v3.53.1 (G23): contexto da última chamada ao modelo (entrada + cache gravado + cache lido), lido só no fim do transcript
# (até 256 KB) — o hook roda a cada comando do dev e não pode reler o arquivo inteiro. 0 = sem chamada legível.
function Get-LastContext([string]$Path) {
    if (-not $Path -or -not (Test-Path -LiteralPath $Path)) { return 0 }
    $fs = $null
    try {
        $fs = [System.IO.File]::Open($Path, 'Open', 'Read', 'ReadWrite')
        $len = [Math]::Min($fs.Length, 262144); [void]$fs.Seek(-$len, 'End')
        $buf = New-Object byte[] $len; $got = $fs.Read($buf, 0, $len)
        $lines = ([System.Text.Encoding]::UTF8.GetString($buf, 0, $got)) -split "`n"
        for ($i = $lines.Count - 1; $i -ge 0; $i--) {
            $l = $lines[$i]
            if ($l.IndexOf('"type":"assistant"') -lt 0 -or $l.IndexOf('"usage"') -lt 0 -or $l.IndexOf('<synthetic>') -ge 0) { continue }
            try { $u = ($l | ConvertFrom-Json).message.usage } catch { continue }
            if ($u) { return [int64]$u.input_tokens + [int64]$u.cache_creation_input_tokens + [int64]$u.cache_read_input_tokens }
        }
    } catch { } finally { if ($fs) { $fs.Dispose() } }
    return 0
}
# v3.53.1 (plugin-report, item 14): versão do plugin que roda o hook (.claude-plugin/plugin.json); '' se ilegível.
function Get-PluginVersion {
    try { return [string]((Get-Content -LiteralPath (Join-Path $PSScriptRoot '..\.claude-plugin\plugin.json') -Raw -Encoding UTF8 | ConvertFrom-Json).version) } catch { return '' }
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
# v3.52.2: o executor de Task (task-runner) fica fora de propósito — instrumento do run, modelo fixo no agents/task-runner.md
# (sonnet); a G17 cala para ele e o models.json o trata como papel desconhecido.
# Chave que falta = o modelo do proprio agente (agents/<papel>.md) e as excecoes do processo. Chave ligada VENCE tudo.
# Chave que comeca com "_" e comentario. Valor ou chave invalida e ignorado e listado em Problems; arquivo
# ilegivel = como ausente (falha aberta, D5).
$script:ModelRoles   = @('architect', 'developer', 'operator', 'product-owner', 'quality-assurance', 'scrum-master', 'security-engineer', 'user-experience')
$script:ModelAliases = @{ arc = 'architect'; dev = 'developer'; po = 'product-owner'; qa = 'quality-assurance'; sm = 'scrum-master'; sec = 'security-engineer'; ux = 'user-experience' }
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

# v3.66.0: a linha "Agent:" do disparo de um papel, com o modelo do models.json ou do proprio agente. Fonte unica do
# run.ps1 (Get-AgentLine) e do impasse.ps1 (o dono do impasse).
function Get-AgentDispatchText([string]$ProjectDir, [string]$Role) {
    $mc = Get-ModelsConfig $ProjectDir
    $dm = Get-AgentDefaultModel $Role; if (-not $dm) { $dm = "agents/$Role.md" }
    $model = if ($mc.State -eq 'ok' -and $mc.Models.ContainsKey($Role)) { "model `"$($mc.Models[$Role])`" (models.json)" } else { "model do agente ($dm)" }
    return "Agent: subagent_type `"team:$Role`" · $model — dispare e encerre o turno; o aviso traz a volta"
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
