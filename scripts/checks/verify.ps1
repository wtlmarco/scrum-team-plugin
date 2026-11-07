# Evidência mecânica (v3.45.1, R7 · R28): roda os comandos de verificação do projeto (guards.json → verify), grava o log
# de cada um em disco e o resultado — comando, código de saída real, linhas decisivas, duração — em
# .team-project/verify/<sprint|B-nnn>/<ID>/result.json, amarrado à IMPRESSÃO DIGITAL da árvore de trabalho (o tree do git
# com tudo o que está no disco, novo não rastreado incluído). Mesma impressão = mesmo código: quem confere não reexecuta.
# Uso (a partir da raiz do projeto; timeout da ferramenta 600000 ms):
#   powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/verify.ps1" -Task T-041 -Mode focused -Tests <arquivos de teste>
#   … -Mode full     build, lint, suite e coverage configurados — no fim do bloco ou da Task (dev) e quando a árvore mudou (QA)
#   … -Mode check    só compara a árvore de agora com a do último full; não roda nada (QA, sessão, C1)
#   … -Mode mutation -Plan <plano>   prova de falha (v3.46): para cada linha de **Mutações:** do plano, troca o trecho no
#                    arquivo de produção, roda o teste focado e ESPERA exit ≠ 0; restaura byte a byte; a árvore tem de voltar igual
#                    (-Only M1,M3 roda só essas — amostragem do QA)
#                    v3.54: a mutação declarada pela REGRA no plano ("· regra: <o que quebra>") roda com o trecho e o
#                    mutante que o dev escreveu no bloco **Mutações:** do relatório de entrega (Get-TaskMutations, lib.ps1)
#                    v3.47.1: antes das mutações, a LINHA DE BASE — o teste focado sem mutação tem de passar e executar
#                    teste; mutação só conta como pega se o log não mostrar compilação quebrada, zero teste ou runner caído
#                    (padrões embutidos + guards.json → verify.inconclusive; verify.caught, se houver, tem de aparecer).
#                    Senão "inconclusivo — motivo". -MaxMinutes (padrão 8) para a chamada antes do vigia de 600 s: o que
#                    ficou pendente roda no MESMO comando de novo, que continua de onde parou (exit 3 = parcial).
# -Tests aceita lista por vírgula ("a,b", como chega pelo powershell -File) ou por espaço. guards.json → verify.testRoot
# (ex.: "source/") tira esse prefixo do {tests} quando o comando focado roda dentro dessa pasta.
# v3.48.1: guards.json → verify.testItem — o molde de CADA teste no {tests}, para runner que não recebe caminho de arquivo:
# {path} = o caminho (padrão) · {class} = o nome qualificado da classe (src/<conjunto>/java|kotlin/a/b/FooTest.kt → a.b.FooTest).
# Gradle: "focused": "./gradlew testDebugUnitTest {tests}", "testItem": "--tests {class}" → --tests a.b.FooTest --tests a.b.BarTest.
# v3.55.0 (B1): verify.focused também aceita LISTA DE OBJETOS { "command": "...{tests}...", "paths": ["source/scripts/alvo/**"],
# "testRoot": "source/", "testItem": "..." } — o comando é escolhido pelo caminho do teste (primeiro objeto cujo glob casa; sem
# casamento, o primeiro item sem "paths"; nenhum → exit 2). Vale no focused e na mutação (linha de base e mutantes usam o comando
# do teste); testRoot e testItem do objeto valem sobre os globais. Sem "paths" em nenhum item, tudo se comporta como antes.
# Saída: ~10 linhas (o log fica no disco). Exit 0 = tudo com código 0 (check: árvore igual e full verde) · 1 = algum
# comando falhou, árvore diferente ou sem full · 2 = erro de uso (sem guards.json → verify, sem git) · 3 = mutação parcial ·
# 4 = FALHA DE AMBIENTE (v3.51): tempo esgotado ou saída com assinatura conhecida de ambiente (tool-hygiene.json) — não é
# defeito do código: o papel não depura; a sessão tenta o reparo (target.ps1 -Repair) uma vez e, sem sucesso, bloqueio de ambiente.
# 5 = OCUPADO (v3.52.3): outra rodada desta Task ainda roda — não dispare outra. v3.53.2: -WaitBusySeconds <n> espera
#     ela acabar dentro da mesma chamada (até n s; 540 cabe no vigia de 600 s) e segue com a rodada desta chamada.
# v3.51: -TimeoutMinutes (ou guards.json → verify.timeoutMinutes, padrão 9) por comando; verify.env = variáveis do filho
# v3.57.0: verify.buildTimeoutMinutes = teto próprio dos comandos "build…" (o APK do Gradle leva mais que a suíte); o resto
# segue o timeoutMinutes. full verde com alvo android e APK mais velho que o código sai com "atenção: … não regerou o APK".
# (ex.: GRADLE_USER_HOME numa junção ASCII); a higiene da ferramenta (Gradle sem daemon, dotnet sem reúso de nó, CI=true no
# node) entra sozinha, de scripts/checks/tool-hygiene.json.

# v3.51.4 (note.md itens 12 e 14, garden item 18):
#   -Mode full retomável: os comandos que não cabem em -MaxMinutes (padrão 8) ficam pendentes e o MESMO comando, de novo,
#     continua de onde parou na mesma árvore (exit 3 = parcial) — build ~8 min + suíte ~2 min passavam dos 600 s da ferramenta.
#   guards.json → verify.daemon: true — o daemon do Gradle LIGADO só durante a chamada: os comandos da mesma chamada o
#     reaproveitam (sem a partida de ~1 min a cada um) e o verify.ps1 o encerra no fim, antes de devolver o controle (o
#     daemon solto prendia o chamador). Desligado (padrão), vale a higiene de antes: sem daemon.
#   -Mode mutation -Precheck: sem rodar teste, confere que cada trecho aparece uma vez no arquivo e, com verify.compile,
#     que cada mutante compila — logo depois da construção, antes do full (garden item 27).
#   cada chamada soma o tempo de comando em verify/<seg>/<ID>/time.jsonl — o kanban.md mostra a espera de comando por Task.
# v3.52.3 (note.md itens 2, 4 e 5, sprint 4 do garden):
#   o orçamento do -Mode full estima CADA comando pela história dele (o maior tempo das últimas 5 rodadas daquela chave nos
#     result.json de verify/) — antes, pela duração do comando anterior: lint de 20 s → suíte de 500 s → 630–709 s, e a
#     ferramenta moveu a chamada para segundo plano. Sem história da chave, vale a regra antiga.
#   uma rodada por Task de cada vez (verify.lock na pasta da Task): a segunda chamada sai com exit 5 enquanto a primeira
#     roda — o dev disparou um full sobre outro em segundo plano e o Karma caiu (Disconnected).
#   comando que passa de 80 % do teto por comando sai com "atenção:" — estourar o teto é exit 4 sem defeito no código.
# v3.53.6 (sprint 5 do garden, item 4): ids de teste como padrão de código. No fim do -Mode full, a chave "testids" (mais
#   um comando no result.json) REPROVA (exit 1) quando (a) um id citado pelos cenários de tela da Task (coluna Cenários do
#   quadro, sem "(teste)" e sem "# aguarda" de outra Task) não existe literalmente no código de produção — constante ou
#   prefixo de id dinâmico valem — ou (b) um controle interativo dos arquivos da Task (**Arquivos tocados:** do plano; sem
#   plano, os mudados no git) não tem id: Compose (Button(, TextField(, Checkbox(, Switch(, .clickable, items( de lista…
#   sem testTag() e web (<button, <input, <select, <textarea, <a com ação sem data-testid). Saída com o id e o .scn, ou
#   arquivo:linha. Exceção explícita: "// sem-testid: <motivo>" (ou {/* … */}, <!-- … -->) na linha ou na anterior.
param(
    [Parameter(Mandatory = $true)][string]$Task,
    [ValidateSet('focused', 'full', 'check', 'mutation')][string]$Mode = 'full',
    [string[]]$Tests = @(),
    [string]$Plan = '',
    [string[]]$Only = @(),
    [int]$MaxMinutes = 8,
    [double]$TimeoutMinutes = 0,
    [switch]$Precheck,
    [int]$WaitBusySeconds = 0,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '..\..\hooks\common.ps1')   # v3.55.0 (B1): Test-GlobMatch, o mesmo casamento de glob dos hooks (protectedPaths)
. (Join-Path $PSScriptRoot 'lib.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Get-Commands($Verify, [string]$Key) {
    $v = $Verify.PSObject.Properties[$Key]
    if ($null -eq $v -or $null -eq $v.Value) { return @() }
    return @(@($v.Value) | Where-Object { $_ -and ([string]$_).Trim() } | ForEach-Object { [string]$_ })
}

# Roda um comando do projeto num PowerShell filho, com o código de saída real, saída inteira no log. Devolve o resultado.
# v3.51 (D1/D4): tempo limite próprio (verify.timeoutMinutes, padrão 9, abaixo do vigia de 600 s) — estourou, a árvore do
# processo é encerrada e o resultado é exit 124 com "falha de ambiente: tempo esgotado"; ao terminar, os descendentes que
# sobraram (daemon) são encerrados; a higiene da ferramenta (tool-hygiene.json) e verify.env entram como variáveis de
# ambiente do filho; saída que casa assinatura conhecida de ambiente marca o comando como falha de ambiente.
$script:hygieneWarnings = @()
$script:daemonPids = @(); $script:cmdSeconds = 0; $script:cmdRuns = 0
# v3.57.0 (plugin-report do sprint 5 do garden, item 12): o build do APK (Gradle, assembleDebug) leva mais que a suíte e não tem
# por que dividir o teto dela. guards.json → verify.buildTimeoutMinutes vale só para os comandos "build…"; o resto segue o
# verify.timeoutMinutes. Estourou: exit 124, árvore encerrada (o daemon do Gradle, se verify.daemon, fica), falha de ambiente.
function Get-CommandTimeout([string]$Key) {
    if ($Key -match '^build' -and $verify -and $verify.PSObject.Properties['buildTimeoutMinutes'] -and [double]$verify.buildTimeoutMinutes -gt 0) { return [double]$verify.buildTimeoutMinutes }
    return $script:timeoutMinutes
}
function Invoke-Logged([string]$Key, [string]$Cmd, [string]$Log) {
    $extra = [ordered]@{}
    if ($verify -and $verify.PSObject.Properties['env'] -and $verify.env) { foreach ($p in $verify.env.PSObject.Properties) { $extra[$p.Name] = [string]$p.Value } }
    $daemon = $verify -and $verify.PSObject.Properties['daemon'] -and $verify.daemon -eq $true
    if ($daemon -and -not $extra.Contains('GRADLE_OPTS')) { $extra['GRADLE_OPTS'] = (([string]$env:GRADLE_OPTS -replace '-Dorg\.gradle\.daemon=\w+', '').Trim() + ' -Dorg.gradle.daemon=true').Trim() }
    # v3.57.0 (item 8): TEAM_TEST_CLOCK_SKEW_MIN_ONCE só existe nos testes — simula o salto de relógio da suspensão na 1ª rodada.
    $skew = 0.0; if ($env:TEAM_TEST_CLOCK_SKEW_MIN_ONCE -and -not $script:skewUsed) { $skew = [double]$env:TEAM_TEST_CLOCK_SKEW_MIN_ONCE; $script:skewUsed = $true }
    $tmo = Get-CommandTimeout $Key
    $r = Invoke-ProjectCommand $Root $Key $Cmd $Log $tmo ([pscustomobject]$extra) -KeepDescendants:$daemon -ClockSkewMin $skew
    # Suspensão do sistema no meio do comando: a rodada não vale como prova — repete UMA vez (protocolo de espera, regra 5) e
    # registra a suspensão. Suspensa de novo, fica como falha de ambiente (exit 4): não é defeito do código.
    if ($r.suspended) {
        $first = [string]$r.environment
        if ($r.Contains('kept')) { $script:daemonPids += @($r.kept) }
        $r = Invoke-ProjectCommand $Root $Key $Cmd $Log $tmo ([pscustomobject]$extra) -KeepDescendants:$daemon
        if (-not $r.suspended) { $r.warnings = @($r.warnings) + @("$Key`: $first — rodada repetida e válida") }
    }
    $r.Remove('suspended')
    foreach ($w in @($r.warnings)) { if ($w -and $script:hygieneWarnings -notcontains $w) { $script:hygieneWarnings += $w } }
    $r.Remove('warnings')
    if ($r.Contains('kept')) { $script:daemonPids += @($r.kept); $r.Remove('kept') }
    $script:cmdSeconds += [int]$r.seconds; $script:cmdRuns++
    return $r
}
# Fim da chamada: o daemon guardado é encerrado (com os descendentes) e o tempo de comando vai ao time.jsonl.
function Complete-Call([string]$Dir) {
    foreach ($id in @($script:daemonPids | Select-Object -Unique)) { $null = Stop-ProcessTree ([int]$id) }
    $script:daemonPids = @()
    if ($Dir -and $script:cmdRuns -gt 0) {
        try { New-Item -ItemType Directory -Force $Dir | Out-Null; [System.IO.File]::AppendAllText((Join-Path $Dir 'time.jsonl'), (([ordered]@{ at = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'); mode = $Mode; seconds = $script:cmdSeconds } | ConvertTo-Json -Compress) + "`n"), $utf8) } catch { }
    }
}
# Lista que chega por powershell -File vem numa string só ("a,b"): divide por vírgula e, se o item não é um caminho que
# existe, por espaço.
function Split-List([string[]]$List) {
    $out = @()
    foreach ($x in @($List)) {
        foreach ($part in ([string]$x -split ',')) {
            $t = $part.Trim()
            if (-not $t) { continue }
            if ($t -match '\s' -and -not (Test-Path -LiteralPath (Join-Path $Root $t))) { $out += @($t -split '\s+' | Where-Object { $_ }) } else { $out += $t }
        }
    }
    return $out
}

# Nome qualificado da classe de teste a partir do caminho (v3.48.1): o trecho depois de src/<conjunto>/(java|kotlin|scala|groovy)/,
# sem extensão, com "." no lugar de "/"; fora desse padrão, o nome do arquivo sem extensão.
function Get-TestClass([string]$Path) {
    $m = [regex]::Match($Path, '(?:^|/)src/[^/]+/(?:java|kotlin|scala|groovy)/(.+)\.[^./]+$')
    if ($m.Success) { return ($m.Groups[1].Value -replace '/', '.') }
    return [System.IO.Path]::GetFileNameWithoutExtension($Path)
}

# v3.55.0 (B1): verify.focused aceita string, lista de strings (como sempre) ou lista de objetos
#   { "command": "...{tests}...", "paths": ["glob"], "testRoot": "...", "testItem": "..." }.
# Sem nenhum objeto com "paths", vale o comportamento de sempre (todo comando roda com todos os testes). Com "paths", cada teste
# vai ao primeiro objeto cujo glob casa o caminho; sem casamento, ao primeiro item sem "paths" (o padrão).
function Get-FocusedItems {
    $out = @()
    if (-not $verify -or -not $verify.PSObject.Properties['focused'] -or $null -eq $verify.focused) { return @() }
    foreach ($x in @($verify.focused)) {
        if ($null -eq $x) { continue }
        if ($x -is [string]) { if ($x.Trim()) { $out += [pscustomobject]@{ Command = $x; Paths = @(); TestRoot = $null; TestItem = $null } }; continue }
        $c = if ($x.PSObject.Properties['command']) { [string]$x.command } else { '' }
        if (-not $c.Trim()) { continue }
        $out += [pscustomobject]@{
            Command  = $c
            Paths    = @(if ($x.PSObject.Properties['paths'] -and $x.paths) { @($x.paths) | Where-Object { $_ } | ForEach-Object { [string]$_ } })
            TestRoot = $(if ($x.PSObject.Properties['testRoot'] -and $null -ne $x.testRoot) { [string]$x.testRoot } else { $null })
            TestItem = $(if ($x.PSObject.Properties['testItem'] -and $x.testItem) { [string]$x.testItem } else { $null })
        }
    }
    return $out
}
function Resolve-FocusedItem($Items, [string]$TestPath) {
    $items2 = @($Items)
    if (-not $items2.Count) { return $null }
    if (-not @($items2 | Where-Object { $_.Paths.Count }).Count) { return $items2[0] }   # legado: o primeiro comando
    $t = ($TestPath -replace '\\', '/') -replace '^\./', ''
    foreach ($it in $items2) { if ($it.Paths.Count -and (Test-GlobMatch $t $it.Paths)) { return $it } }
    foreach ($it in $items2) { if (-not $it.Paths.Count) { return $it } }
    return $null
}

function Format-Tests([string[]]$List, $FItem = $null) {
    $pre = ''; if ($verify -and $verify.PSObject.Properties['testRoot']) { $pre = (([string]$verify.testRoot).Trim() -replace '\\', '/').TrimEnd('/') + '/' }
    if ($FItem -and $null -ne $FItem.TestRoot) { $pre = if (([string]$FItem.TestRoot).Trim()) { (([string]$FItem.TestRoot).Trim() -replace '\\', '/').TrimEnd('/') + '/' } else { '' } }
    $item = '{path}'; if ($verify -and $verify.PSObject.Properties['testItem'] -and $verify.testItem) { $item = [string]$verify.testItem }
    if ($FItem -and $FItem.TestItem) { $item = [string]$FItem.TestItem }
    return (($List | ForEach-Object {
        $t = ([string]$_ -replace '\\', '/') -replace '^\./', ''
        if ($pre -ne '/' -and $t.StartsWith($pre, [StringComparison]::OrdinalIgnoreCase)) { $t = $t.Substring($pre.Length) }
        $p = if ($t -match '\s') { "'$t'" } else { $t }
        $item.Replace('{path}', $p).Replace('{class}', (Get-TestClass $t))
    }) -join ' ')
}

# Sinais de que o teste NÃO rodou de verdade (v3.47.1): o exit ≠ 0 de um mutante que não compila, de zero teste executado
# ou do runner que caiu não prova nada. Embutidos (as stacks do processo) + guards.json → verify.inconclusive.
$script:inconclusiveBase = @(
    'Executed 0 of 0', '\bDisconnected\b', '(?i)\bno tests? (were )?found\b', '(?i)\bno tests ran\b', '(?i)no test is available',
    '(?i)\bERROR collecting\b', '\berror TS\d{4}\b', '\berror CS\d{4}\b', '(?i)\bcompilation (error|failed)\b', '(?m)^e: (file:|/|\w:)',
    '(?i)\bcannot find symbol\b', '\bSyntaxError\b',
    # v3.52.1 (garden item 28): mutante que não compila saiu "pego" no TypeScript — ts-jest, Karma e o Angular imprimem o código
    # sem a palavra "error" na frente (`src/x.ts:12:5 - TS18047: …`, `Error: … TS2339: …`); Jest, webpack e esbuild avisam que a
    # suíte nem rodou. Um teste que reprova por falha de compilação ou de transformação não provou nada.
    '\bTS\d{4,5}:', '(?i)\bTest suite failed to run\b', '(?i)\bModule build failed\b', '(?i)\bFailed to compile\b',
    '(?i)\bTransform failed\b', '(?i)\bBuild failed with \d+ errors?\b', '(?i)\bTests:\s+0 total\b', '(?m)^\s*\S+\.java:\d+: error:',
    # v3.55.0 (B2): node:test sem teste executado ("ℹ tests 0" / "# tests 0") ou arquivo que o runner não achou.
    '(?m)^\s*(#|ℹ)\s*tests 0\b', "(?i)\bCould not find '")

function Get-Inconclusive([string]$Log) {
    $pats = @($script:inconclusiveBase)
    if ($verify -and $verify.PSObject.Properties['inconclusive']) { $pats += @(@($verify.inconclusive) | Where-Object { $_ } | ForEach-Object { [string]$_ }) }
    $text = [System.IO.File]::ReadAllText($Log, $utf8)
    foreach ($p in $pats) {
        $m = [regex]::Match($text, $p)
        if ($m.Success) {
            $s = $text.LastIndexOf("`n", [Math]::Max(0, $m.Index - 1)) + 1; $e2 = $text.IndexOf("`n", $m.Index); if ($e2 -lt 0) { $e2 = $text.Length }
            $line = $text.Substring($s, $e2 - $s).Trim(); if ($line.Length -gt 160) { $line = $line.Substring(0, 160) + '…' }
            return $line
        }
    }
    return $null
}

# Classifica uma execução do teste focado sobre o mutante.
function Get-MutationVerdict($Run) {
    $full = Join-Path $Root $Run.log
    $why = Get-Inconclusive $full
    if ($why) { return "inconclusivo — o teste não rodou de verdade: $why" }
    if ([int]$Run.exit -eq 0) { return 'falhou — o teste passou com a regra removida (decoração)' }
    if ($verify.PSObject.Properties['caught'] -and $verify.caught) {
        if (-not ([regex]::IsMatch([System.IO.File]::ReadAllText($full, $utf8), [string]$verify.caught))) { return "inconclusivo — exit $($Run.exit) sem a marca de teste reprovado (verify.caught)" }
    }
    return 'ok — o teste reprovou com a regra removida'
}

# v3.52.3 (note.md item 2): duração esperada de cada comando do full — o maior tempo das últimas 5 rodadas da chave (build,
# lint, suite, suite2…) nos result.json de .team-project/verify/, de qualquer Task: a suíte dura o mesmo de uma Task à outra.
function Get-CommandEstimates([string]$Root) {
    $hist = @{}
    $vd = Join-Path $Root '.team-project/verify'
    if (-not (Test-Path -LiteralPath $vd)) { return @{} }
    foreach ($f in @(Get-ChildItem -LiteralPath $vd -Recurse -Filter 'result.json' -File -ErrorAction SilentlyContinue)) {
        try { $j = Read-Text $f.FullName | ConvertFrom-Json } catch { continue }
        foreach ($sec in 'full', 'full_partial') {
            $blk = $j.PSObject.Properties[$sec]; if (-not $blk -or -not $blk.Value) { continue }
            $at = if ($blk.Value.PSObject.Properties['at']) { [string]$blk.Value.at } else { $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss') }
            foreach ($c in @($blk.Value.commands)) {
                if (-not $c -or -not $c.key -or $null -eq $c.seconds) { continue }
                $k = [string]$c.key; if (-not $hist.ContainsKey($k)) { $hist[$k] = @() }
                $hist[$k] += [pscustomobject]@{ At = $at; Seconds = [int]$c.seconds }
            }
        }
    }
    $est = @{}
    foreach ($k in $hist.Keys) { $est[$k] = (@($hist[$k] | Sort-Object At -Descending | Select-Object -First 5) | Measure-Object Seconds -Maximum).Maximum }
    return $est
}

# v3.52.3 (note.md item 4): trava da Task — CreateNew é atômico; trava de processo que já morreu (ou de outro processo com o
# mesmo PID) é resto e sai. Devolve $null quando a trava é desta chamada, ou o conteúdo da trava de quem roda.
function Enter-VerifyLock([string]$Dir) {
    New-Item -ItemType Directory -Force $Dir | Out-Null
    $lp = Join-Path $Dir 'verify.lock'
    $me = Get-Process -Id $PID
    for ($try = 0; $try -lt 2; $try++) {
        try {
            $fs = [System.IO.File]::Open($lp, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
            $b = $utf8.GetBytes((([ordered]@{ pid = $PID; started = $me.StartTime.ToString('o'); mode = $Mode; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }) | ConvertTo-Json -Compress))
            $fs.Write($b, 0, $b.Length); $fs.Close()
            $script:lockPath = $lp
            return $null
        } catch [System.IO.IOException] {
            $other = $null; try { $other = Read-Text $lp | ConvertFrom-Json } catch { }
            $p = if ($other -and $other.pid) { Get-Process -Id ([int]$other.pid) -ErrorAction SilentlyContinue } else { $null }
            if ($p -and $other.started -and $p.StartTime.ToString('o') -eq [string]$other.started) { return $other }
            Remove-Item -LiteralPath $lp -Force -ErrorAction SilentlyContinue
        }
    }
    return $null
}

# Mutações do plano e escopo do plano: Get-Mutations e Get-PlanScope vivem no lib.ps1 desde a v3.52.2 (note.md itens 7 e 10)
# — um leitor só para o plan.ps1, o verify.ps1, o close.ps1 e o commit da Task (run.ps1).

# Escrita temporária em produto: restaura o que uma execução interrompida deixou mutado, antes de qualquer coisa.
function Restore-Pending([string]$Dir) {
    $pend = Join-Path $Dir 'mutation-pending.json'
    if (-not (Test-Path -LiteralPath $pend)) { return $null }
    $pj = Read-Text $pend | ConvertFrom-Json
    $full = Join-Path $Root ([string]$pj.file)
    [System.IO.File]::WriteAllBytes($full, [System.IO.File]::ReadAllBytes((Join-Path $Dir 'mutation.bak')))
    Remove-Item -LiteralPath $pend, (Join-Path $Dir 'mutation.bak') -Force
    return [string]$pj.file
}

try {
    $tp = Join-Path $Root '.team-project'
    $cfgPath = Join-Path $tp 'guards.json'
    if (-not (Test-Path -LiteralPath $cfgPath)) { [Console]::Error.WriteLine("verify: $cfgPath não existe — rode na raiz do projeto ou passe -Root."); exit 2 }
    $cfg = Read-Text $cfgPath | ConvertFrom-Json
    $verify = $cfg.verify
    $script:timeoutMinutes = if ($TimeoutMinutes -gt 0) { $TimeoutMinutes } elseif ($verify -and $verify.PSObject.Properties['timeoutMinutes'] -and [double]$verify.timeoutMinutes -gt 0) { [double]$verify.timeoutMinutes } else { 9 }
    $Tests = @(Split-List $Tests); $Only = @(Split-List $Only)
    $dir = Get-VerifyDir $Root $Task
    $resPath = Join-Path $dir 'result.json'
    $prev = $null
    if ($Mode -ne 'check') {
        # Antes do Restore-Pending: a mutação de uma rodada viva NÃO é resto de interrupção.
        $busy = Enter-VerifyLock $dir
        # v3.53.2 (sprint 5 do garden): o dev caiu, a rodada dele seguiu viva e o dev novo recebeu OCUPADO — o executor não
        # espera processo e pausou o run duas vezes, até o stakeholder digitar de novo. Com -WaitBusySeconds a MESMA chamada
        # espera a rodada anterior acabar (uma chamada bloqueada, sem sondagem do modelo) e depois roda a sua.
        if ($busy -and $WaitBusySeconds -gt 0) {
            $first = $busy; $sw = [System.Diagnostics.Stopwatch]::StartNew()
            while ($busy -and $sw.Elapsed.TotalSeconds -lt $WaitBusySeconds) { Start-Sleep -Seconds 5; $busy = Enter-VerifyLock $dir }
            if (-not $busy) { [Console]::Out.WriteLine("verify: esperou $([int]$sw.Elapsed.TotalSeconds) s pela rodada anterior ($([string]$first.mode), pid $($first.pid)); segue a desta chamada.") }
        }
        if ($busy) {
            [Console]::Out.WriteLine("verify $Mode $Task`: OCUPADO — outra rodada desta Task ($([string]$busy.mode), pid $($busy.pid), desde $($busy.at)) ainda roda. Não dispare outra: rode o mesmo comando com -WaitBusySeconds 540, que espera ela acabar nesta chamada e segue (sem pausar o run).")
            exit 5
        }
    }
    if (Test-Path -LiteralPath $resPath) { try { $prev = Read-Text $resPath | ConvertFrom-Json } catch { } }

    $restored = Restore-Pending $dir   # mutação interrompida: o arquivo volta antes de qualquer medida
    if ($restored) { [Console]::Out.WriteLine("verify: $restored restaurado de uma mutação interrompida.") }
    $tree = Get-WorkTree $Root
    if (-not $tree) { [Console]::Error.WriteLine('verify: sem repositório git na raiz — a impressão digital da árvore não existe; verificação pelo operator (R28).'); exit 2 }

    if ($Mode -eq 'check') {
        $full = if ($prev) { $prev.full } else { $null }
        if ($null -eq $full) { [Console]::Out.WriteLine("verify check $Task`: sem verify full registrado em $($resPath.Substring($Root.Length + 1)) — rode -Mode full."); exit 1 }
        $same = [string]$full.tree -eq $tree
        $green = @($full.commands | Where-Object { [int]$_.exit -ne 0 }).Count -eq 0
        [Console]::Out.WriteLine("verify check $Task`: árvore " + $(if ($same) { "IGUAL ao full de $($full.at)" } else { "DIFERENTE do full de $($full.at) (agora $($tree.Substring(0, 12)), full $(([string]$full.tree).Substring(0, 12)))" }) + "; full " + $(if ($green) { 'verde' } else { 'com falha' }))
        foreach ($c in @($full.commands)) { [Console]::Out.WriteLine("  $($c.key): exit $($c.exit) · $(@($c.decisive) | Select-Object -Last 1)") }
        if ($same -and $green) { exit 0 } else { exit 1 }
    }

    if ($null -eq $verify) { [Console]::Error.WriteLine('verify: guards.json sem a chave "verify" — o /team update (passo 7h) a preenche a partir do developer/context.md.'); exit 2 }
    $focusedItems = @(Get-FocusedItems)
    $focusedCmd = @($focusedItems | ForEach-Object { $_.Command })

    if ($Mode -eq 'mutation') {
        # Prova de falha (v3.46): só sobre a árvore do último full verde — a mutação prova o teste daquele código.
        if (-not $Plan -or -not (Test-Path -LiteralPath (Join-Path $Root $Plan))) { [Console]::Error.WriteLine('verify: -Mode mutation pede -Plan <caminho do plano, relativo à raiz>.'); exit 2 }
        if ($focusedCmd.Count -eq 0) { [Console]::Error.WriteLine('verify: guards.json → verify sem "focused" — a mutação roda o teste focado.'); exit 2 }
        # v3.57.0 (plugin-report do sprint 5 do garden, item A6): mutante do plano que não compila só aparecia depois de ~20 min de
        # mutação. Com verify.compile declarado, a mutação roda o Precheck SOZINHA antes — se não há um verde registrado para esta
        # árvore (precheck.json) — e para cedo, com a lista; nunca depende de alguém lembrar. Sem verify.compile a compilação dos
        # mutantes não tem como ser conferida de antemão: o aviso é alto, porque o erro só vai aparecer dentro da mutação.
        $compileDecl = @(Get-Commands $verify 'compile') | Select-Object -First 1
        $autoPre = $false
        if (-not $Precheck -and $compileDecl) {
            $pjf = Join-Path $dir 'precheck.json'; $green = $false
            if (Test-Path -LiteralPath $pjf) { try { $pr = Read-Text $pjf | ConvertFrom-Json; $green = ([string]$pr.tree -eq $tree) -and ([int]$pr.problems -eq 0) -and ($pr.compile -eq $true) } catch { } }
            $autoPre = -not $green
        }
        if (-not $Precheck -and -not $compileDecl) { [Console]::Out.WriteLine('  ATENÇÃO: o projeto não declara verify.compile em guards.json — a compilação dos mutantes NÃO foi conferida de antemão; um mutante que não compila só aparece dentro da mutação (minutos por mutante). Declare verify.compile (comando que só compila, sem rodar teste) e rode -Mode mutation -Precheck.') }
        if ($Precheck -or $autoPre) {
            # v3.51.4 (garden item 27): conferência prévia, sem teste — trecho único no arquivo e, com verify.compile, mutante que compila.
            $pt = Read-Text (Join-Path $Root $Plan); $pm = @(Get-TaskMutations $Root $Plan $pt $Task); if ($Only.Count) { $pm = @($pm | Where-Object { $Only -contains $_.Id }) }
            $compile = @(Get-Commands $verify 'compile') | Select-Object -First 1
            $probs = @(); $okIds = @()
            foreach ($mu in $pm) {
                $rel = ($mu.File -replace '\\', '/') -replace '^\./', ''; $f2 = Join-Path $Root $rel
                if ($mu.Problem) { $probs += "$($mu.Id): $($mu.Problem)"; continue }
                if (-not (Test-Path -LiteralPath $f2)) { $probs += "$($mu.Id): $rel não existe"; continue }
                if ($mu.Find -eq '') { $probs += "$($mu.Id): trecho vazio"; continue }
                $bytes = [System.IO.File]::ReadAllBytes($f2); $bom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
                $txt = (New-Object System.Text.UTF8Encoding($false)).GetString($bytes, $(if ($bom) { 3 } else { 0 }), $bytes.Length - $(if ($bom) { 3 } else { 0 }))
                $hits = 0; $ix = $txt.IndexOf($mu.Find, [StringComparison]::Ordinal); $first = $ix
                while ($ix -ge 0) { $hits++; $ix = $txt.IndexOf($mu.Find, $ix + [Math]::Max(1, $mu.Find.Length), [StringComparison]::Ordinal) }
                if ($hits -ne 1) { $probs += "$($mu.Id): o trecho aparece $hits vez(es) em $rel (precisa ser 1)"; continue }
                if ($compile) {
                    New-Item -ItemType Directory -Force $dir | Out-Null
                    [System.IO.File]::WriteAllBytes((Join-Path $dir 'mutation.bak'), $bytes)
                    [System.IO.File]::WriteAllText((Join-Path $dir 'mutation-pending.json'), (@{ file = $rel; id = $mu.Id } | ConvertTo-Json -Compress), $utf8)
                    try {
                        [System.IO.File]::WriteAllText($f2, $txt.Substring(0, $first) + $mu.Replace + $txt.Substring($first + $mu.Find.Length), (New-Object System.Text.UTF8Encoding($bom)))
                        $cr = Invoke-Logged "compile-$($mu.Id)" $compile (Join-Path $dir "precheck-$($mu.Id).log")
                    } finally {
                        [System.IO.File]::WriteAllBytes($f2, $bytes)
                        foreach ($tmpf in 'mutation-pending.json', 'mutation.bak') { $pth = Join-Path $dir $tmpf; if (Test-Path -LiteralPath $pth) { [System.IO.File]::Delete($pth) } }
                    }
                    if ([int]$cr.exit -ne 0) { $probs += "$($mu.Id): o mutante não compila ($compile exit $($cr.exit) · $(@($cr.decisive) | Select-Object -Last 1))"; continue }
                }
                $okIds += $mu.Id
            }
            if ((Get-WorkTree $Root) -ne $tree) { [Console]::Error.WriteLine('verify: ERRO — a árvore não voltou igual depois da conferência prévia. Confira com git status/git diff.'); exit 2 }
            [Console]::Out.WriteLine("verify mutation -Precheck$(if ($autoPre) { ' (automático, antes da mutação)' }) $Task · $($okIds.Count) de $($pm.Count) mutação(ões) prontas" + $(if ($compile) { ' (trecho único e mutante compila)' } else { ' (trecho único; ATENÇÃO: sem verify.compile a compilação dos mutantes NÃO foi conferida — só aparece na mutação)' }))
            try { New-Item -ItemType Directory -Force $dir | Out-Null; [System.IO.File]::WriteAllText((Join-Path $dir 'precheck.json'), ([ordered]@{ tree = $tree; at = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'); compile = [bool]$compile; ok = @($okIds); problems = $probs.Count } | ConvertTo-Json -Compress), $utf8) } catch { }
            # v3.54: a mutação declarada pela regra é do dev — o trecho dele se corrige no relatório, sem GAP.
            foreach ($p in $probs) { $own = $p -match '^(M\d+):' -and @($pm | Where-Object { $_.Id -eq $Matches[1] -and $_.Source -eq 'dev' }).Count; [Console]::Out.WriteLine("  $p — " + $(if ($own) { 'a linha é sua (mutação pela regra): corrija o trecho no bloco **Mutações:** do relatório' } else { 'o plano é do Arquiteto: 🔺 GAP com esta linha' })) }
            if ($probs.Count) { exit 1 } elseif ($Precheck) { exit 0 }
        }
        $full = if ($prev) { $prev.full } else { $null }
        if ($null -eq $full -or [string]$full.tree -ne $tree) { [Console]::Error.WriteLine("verify: a mutação roda sobre a árvore do último full — rode -Mode full antes (árvore agora $($tree.Substring(0, 12)))."); exit 2 }
        $planText = Read-Text (Join-Path $Root $Plan)
        $planMuts = @(Get-TaskMutations $Root $Plan $planText $Task)   # v3.54: com o trecho do dev nas declaradas pela regra
        $muts = $planMuts
        if ($Only.Count) { $muts = @($muts | Where-Object { $Only -contains $_.Id }) }
        if ($muts.Count -eq 0) { [Console]::Error.WriteLine('verify: nenhuma linha "- M<k> · teste `…` · `…` · `trecho` → `mutante`" em **Mutações:** do plano' + $(if ($Only.Count) { ' com ' + ($Only -join ',') } else { '' }) + '.'); exit 2 }
        # Retomada (v3.47.1): sem -Only, o que já tem resultado conclusivo nesta mesma árvore não roda de novo — a chamada
        # anterior parou no -MaxMinutes e esta continua de onde ela parou.
        $sameTree = $prev -and $prev.mutation -and [string]$prev.mutation.tree -eq $tree
        if (-not $Only.Count -and $sameTree) {
            $doneIt = @(@($prev.mutation.items) | Where-Object { ([string]$_.result) -match '^(ok|falhou)\b' })
            # v3.54: o trecho do dev vive no relatório, fora da árvore — trocado o trecho, a mutação roda de novo.
            $muts = @($muts | Where-Object { $id = $_.Id; $d = @($doneIt | Where-Object { [string]$_.id -eq $id }) | Select-Object -First 1; -not $d -or ($_.Source -eq 'dev' -and ([string]$d.find -ne [string]$_.Find -or [string]$d.replace -ne [string]$_.Replace)) })
        }
        $scope = @(Get-PlanScope $planText)
        New-Item -ItemType Directory -Force $dir | Out-Null
        $items = @(); $pending = @()
        $budget = [System.Diagnostics.Stopwatch]::StartNew(); $lastSec = 0; $ranAny = $false
        $base = @{}   # teste → $null (passou e executou) ou o motivo de não servir de linha de base
        foreach ($mu in $muts) {
            $rel = ($mu.File -replace '\\', '/') -replace '^\./', ''
            $item = [ordered]@{ id = $mu.Id; test = $mu.Test; file = $rel; result = ''; exit = $null; decisive = @(); log = '' }
            # v3.54: a declarada pela regra leva a regra e o trecho do dev ao registro — o QA confere que ela ataca a regra.
            if ($mu.Source -eq 'dev') { $item.rule = $mu.Rule; $item.find = $mu.Find; $item.replace = $mu.Replace }
            if ($mu.Problem) { $item.result = "inconclusivo — $($mu.Problem)"; $items += $item; continue }
            $full2 = Join-Path $Root $rel
            if ($scope -notcontains $rel) { $item.result = 'inconclusivo — arquivo fora de **Arquivos tocados:** do plano'; $items += $item; continue }
            if (-not (Test-Path -LiteralPath $full2)) { $item.result = 'inconclusivo — arquivo não existe'; $items += $item; continue }
            if ($mu.Find -eq '') { $item.result = 'inconclusivo — trecho vazio no plano (crase dupla ou trecho com crase: escolha outro trecho)'; $items += $item; continue }
            # Orçamento: a próxima execução não cabe → fica pendente para a próxima chamada (a primeira sempre roda).
            if ($ranAny -and ($budget.Elapsed.TotalSeconds + $lastSec) -gt ($MaxMinutes * 60)) { $pending += $mu.Id; continue }
            $ranAny = $true
            $fi = Resolve-FocusedItem $focusedItems $mu.Test
            if (-not $fi) { [Console]::Error.WriteLine("verify: nenhum item de verify.focused casa o teste $($mu.Test) (paths) e não há item padrão sem paths."); exit 2 }
            if (-not $base.ContainsKey($mu.Test)) {
                $bk = 'base-' + ($base.Count + 1)
                $b = Invoke-Logged $bk $fi.Command.Replace('{tests}', (Format-Tests @($mu.Test) $fi)) (Join-Path $dir "mutation-$bk.log")
                $bw = Get-Inconclusive (Join-Path $Root $b.log)
                $base[$mu.Test] = if ([int]$b.exit -ne 0) { "o teste falha sem mutação (linha de base exit $($b.exit), $($b.log))" } elseif ($bw) { "a linha de base não executou teste: $bw" } else { $null }
                $lastSec = $b.seconds
            }
            if ($base[$mu.Test]) { $item.result = "inconclusivo — $($base[$mu.Test])"; $items += $item; continue }
            $bytes = [System.IO.File]::ReadAllBytes($full2)
            $bom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
            $skip = if ($bom) { 3 } else { 0 }
            $text = (New-Object System.Text.UTF8Encoding($false)).GetString($bytes, $skip, $bytes.Length - $skip)
            $hits = 0; $ix = $text.IndexOf($mu.Find, [StringComparison]::Ordinal); $first = $ix
            while ($ix -ge 0) { $hits++; $ix = $text.IndexOf($mu.Find, $ix + [Math]::Max(1, $mu.Find.Length), [StringComparison]::Ordinal) }
            if ($hits -ne 1) { $item.result = "inconclusivo — o trecho aparece $hits vez(es) em $rel (precisa ser 1)"; $items += $item; continue }
            $mutated = $text.Substring(0, $first) + $mu.Replace + $text.Substring($first + $mu.Find.Length)
            [System.IO.File]::WriteAllBytes((Join-Path $dir 'mutation.bak'), $bytes)
            [System.IO.File]::WriteAllText((Join-Path $dir 'mutation-pending.json'), (@{ file = $rel; id = $mu.Id } | ConvertTo-Json -Compress), $utf8)
            try {
                [System.IO.File]::WriteAllText($full2, $mutated, (New-Object System.Text.UTF8Encoding($bom)))
                $r = Invoke-Logged $mu.Id $fi.Command.Replace('{tests}', (Format-Tests @($mu.Test) $fi)) (Join-Path $dir "mutation-$($mu.Id).log")
            } finally {
                [System.IO.File]::WriteAllBytes($full2, $bytes)
                foreach ($tmpf in 'mutation-pending.json', 'mutation.bak') { $pth = Join-Path $dir $tmpf; if (Test-Path -LiteralPath $pth) { [System.IO.File]::Delete($pth) } }
            }
            $item.exit = $r.exit; $item.decisive = $r.decisive; $item.log = $r.log
            $item.result = Get-MutationVerdict $r
            $lastSec = $r.seconds
            $items += $item
        }
        $after = Get-WorkTree $Root
        if ($after -ne $tree) { [Console]::Error.WriteLine("verify: ERRO — a árvore não voltou igual depois das mutações ($($tree.Substring(0, 12)) → $($after.Substring(0, 12))). Confira com git status/git diff antes de seguir."); exit 2 }
        # Amostragem (-Only) e retomada sobre a mesma árvore substituem só as mutações que rodaram; as outras do registro ficam.
        $merged = @()
        if ($sameTree) { $ran = @($items | ForEach-Object { $_.id }); $merged = @(@($prev.mutation.items) | Where-Object { $ran -notcontains [string]$_.id }) }
        $all = @($merged) + @($items) | Sort-Object { [int](([string]$_.id) -replace '\D', '') }
        $res = [ordered]@{ task = $Task; full = $prev.full; focused = $prev.focused; mutation = [ordered]@{ at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); tree = $tree; plan = $Plan; only = $Only; pending = $pending; items = $all } }
        [System.IO.File]::WriteAllText($resPath, ($res | ConvertTo-Json -Depth 8), $utf8)
        $want = @($(if ($Only.Count) { $Only } else { $planMuts | ForEach-Object { $_.Id } }))
        $mine = @($all | Where-Object { $want -contains [string]$_.id })
        $okN = @($mine | Where-Object { ([string]$_.result).StartsWith('ok') }).Count
        $badM = @($mine | Where-Object { -not ([string]$_.result).StartsWith('ok') })
        [Console]::Out.WriteLine("verify mutation $Task · árvore $($tree.Substring(0, 12)) (restaurada igual) · $okN de $($want.Count) mutação(ões) pegas pelo teste" + $(if ($pending.Count) { " · $($pending.Count) pendente(s)" } else { '' }) + " · $($resPath.Substring($Root.Length + 1) -replace '\\', '/')")
        foreach ($it in $items) { [Console]::Out.WriteLine("  $($it.id) $($it.file): $($it.result)" + $(if ($null -ne $it.exit) { " · exit $($it.exit) · $(@($it.decisive) | Select-Object -Last 1)" } else { '' }) + $(if ($it.Contains('rule')) { " · regra: $($it.rule) · trecho do dev: ``$($it.find)`` → ``$($it.replace)``" } else { '' })) }
        foreach ($it in @($merged | Where-Object { $want -contains [string]$_.id })) { [Console]::Out.WriteLine("  $($it.id) $($it.file): $($it.result) (chamada anterior, mesma árvore)") }
        if ($pending.Count) { [Console]::Out.WriteLine("  parcial: $($pending -join ', ') não couberam em -MaxMinutes $MaxMinutes — rode o MESMO comando de novo; ele continua de onde parou."); exit 3 }
        if ($badM.Count) { exit 1 }
        exit 0
    }

    $keys = if ($Mode -eq 'focused') { @('focused', 'lint') } else { @('build', 'lint', 'suite', 'coverage') }   # $plan seria o -Plan (string)
    $jobs = @()
    foreach ($k in $keys) {
        if ($k -eq 'focused') {
            # v3.55.0 (B1): com "paths", os testes se agrupam pelo comando que o caminho escolhe; sem, todo comando leva todos os testes.
            $routed = @($focusedItems | Where-Object { $_.Paths.Count }).Count -gt 0
            if (-not $routed) { $i = 0; foreach ($fi0 in $focusedItems) { $i++; $jobs += @{ Key = $(if ($i -gt 1) { "focused$i" } else { 'focused' }); Cmd = $fi0.Command; FItem = $fi0 } }; continue }
            $groups = [ordered]@{}
            foreach ($tp in @(Split-List $Tests)) {
                $fi1 = Resolve-FocusedItem $focusedItems $tp
                if (-not $fi1) { [Console]::Error.WriteLine("verify: nenhum item de verify.focused casa o teste $tp (paths) e não há item padrão sem paths."); exit 2 }
                $gk1 = 'k' + [array]::IndexOf(@($focusedItems), $fi1)   # chave de texto: o índice inteiro de um [ordered] é posicional
                if (-not $groups.Contains($gk1)) { $groups[$gk1] = @() }
                $groups[$gk1] += $tp
            }
            $i = 0
            foreach ($gk in @($groups.Keys)) { $i++; $fi2 = @($focusedItems)[[int]$gk.Substring(1)]; $jobs += @{ Key = $(if ($i -gt 1) { "focused$i" } else { 'focused' }); Cmd = $fi2.Command; FItem = $fi2; Tests = @($groups[$gk]) } }
            continue
        }
        $i = 0; foreach ($c in (Get-Commands $verify $k)) { $i++; $jobs += @{ Key = $(if ($i -gt 1) { "$k$i" } else { $k }); Cmd = $c } }
    }
    if ($Mode -eq 'focused') {
        if (-not $focusedItems.Count) { [Console]::Error.WriteLine('verify: guards.json → verify sem "focused" (o comando do teste focado, com {tests}).'); exit 2 }
        if ($Tests.Count -eq 0) { [Console]::Error.WriteLine('verify: -Mode focused pede -Tests <arquivos de teste do bloco>.'); exit 2 }
    } elseif ($jobs.Count -eq 0) { [Console]::Error.WriteLine('verify: guards.json → verify sem build, lint, suite nem coverage.'); exit 2 }

    New-Item -ItemType Directory -Force $dir | Out-Null
    $results = @(); $pendingJobs = @()
    # v3.51.4: retomada do full parcial na mesma árvore — os comandos que já rodaram não rodam de novo.
    if ($Mode -eq 'full' -and $prev -and $prev.PSObject.Properties['full_partial'] -and $prev.full_partial -and [string]$prev.full_partial.tree -eq $tree) {
        $results = @(@($prev.full_partial.commands) | ForEach-Object { $h = [ordered]@{}; foreach ($p in $_.PSObject.Properties) { $h[$p.Name] = $p.Value }; $h })
        $doneKeys = @($results | ForEach-Object { [string]$_.key })
        $jobs = @($jobs | Where-Object { $doneKeys -notcontains $_.Key })
    }
    $budget = [System.Diagnostics.Stopwatch]::StartNew(); $lastSec = 0; $ranAny = $false
    $estimates = if ($Mode -eq 'full') { Get-CommandEstimates $Root } else { @{} }
    foreach ($j in $jobs) {
        $need = if ($estimates.ContainsKey($j.Key)) { [int]$estimates[$j.Key] } else { $lastSec }   # v3.52.3: a história da chave
        if ($Mode -eq 'full' -and $ranAny -and ($budget.Elapsed.TotalSeconds + $need) -gt ($MaxMinutes * 60)) { $pendingJobs += $j.Key; continue }
        $ranAny = $true
        $jt = if ($j.ContainsKey('Tests')) { $j.Tests } else { $Tests }
        $r1 = Invoke-Logged $j.Key $j.Cmd.Replace('{tests}', (Format-Tests $jt $j.FItem)) (Join-Path $dir "$Mode-$($j.Key).log")
        $results += $r1; $lastSec = $r1.seconds
    }
    # v3.53.6 (sprint 5 do garden, item 4): ids de teste conferidos no fim do full — (a) todo id dos cenários de tela da Task
    # existe no código de produção; (b) nenhum controle interativo sem id nos arquivos da Task. Entra como mais um comando
    # (chave "testids"), então o check, o close.ps1 (R7-verify) e o QA o leem como os outros. Só quando há o que conferir.
    $tidLines = @()
    if ($Mode -eq 'full' -and -not $pendingJobs.Count) {
        $tsw = [System.Diagnostics.Stopwatch]::StartNew()
        $tid = Get-TestIdFindings $Root $Task
        if ($tid.Applies) {
            $tidLines = @(@($tid.Missing | ForEach-Object { "id ausente no código: $_" }) + @($tid.Untagged | ForEach-Object { "sem id de teste: $_" }))
            $head = if ($tidLines.Count) { "ids de teste: $(@($tid.Missing).Count) id(s) dos cenários fora do código, $(@($tid.Untagged).Count) controle(s) sem id" } else { "ids de teste: $($tid.Ids) id(s) dos cenários no código, $($tid.Files) arquivo(s) de tela com todo controle identificado" }
            $tlog = Join-Path $dir 'full-testids.log'
            $body = @($head) + $tidLines + @($tid.Notes) + @('', "EXIT=$(if ($tidLines.Count) { 1 } else { 0 })")
            [System.IO.File]::WriteAllText($tlog, ($body -join "`n") + "`n", $utf8)
            $results += [ordered]@{ key = 'testids'; command = 'ids de teste dos cenários e dos controles (verify.ps1, v3.53.6)'; exit = $(if ($tidLines.Count) { 1 } else { 0 }); seconds = [int]$tsw.Elapsed.TotalSeconds
                                    log = ($tlog.Substring($Root.Length + 1) -replace '\\', '/'); lines = $body.Count; decisive = @($head); environment = $null; hygiene = @() }
        }
    }
    # v3.52.3 (note.md item 5): comando perto do teto por comando — ao passar dele, vira exit 4 (ambiente) sem defeito no código.
    $near = @($results | Where-Object { $cl = [int]((Get-CommandTimeout ([string]$_.key)) * 60); -not $_.environment -and [int]$_.seconds -ge 0.8 * $cl } | ForEach-Object { $ceil = [int]((Get-CommandTimeout ([string]$_.key)) * 60); "$($_.key) levou $($_.seconds) s, $([int](100 * [int]$_.seconds / $ceil)) % do teto por comando ($ceil s, verify.timeoutMinutes$(if ($_.key -match '^build' -and $verify.PSObject.Properties['buildTimeoutMinutes']) { ' / buildTimeoutMinutes' })) — ao passar dele vira falha de ambiente (exit 4). Reporte a quem orquestra: o projeto divide o comando em guards.json → verify (lista: suite, suite2…); teto acima de 9 min passa dos 600 s da ferramenta" })
    $after = Get-WorkTree $Root
    $run = [ordered]@{ at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); tree = $tree; tree_after = $after; tests = $Tests; commands = $results }

    $res = [ordered]@{ task = $Task; full = $null; focused = $null; mutation = $null; full_partial = $null }
    if ($prev) { foreach ($k in 'full', 'focused', 'mutation') { if ($prev.PSObject.Properties[$k]) { $res[$k] = $prev.$k } } }
    if ($pendingJobs.Count) { $res.full_partial = [ordered]@{ tree = $tree; commands = $results; pending = $pendingJobs } }
    else { $res[$Mode] = $run }
    [System.IO.File]::WriteAllText($resPath, ($res | ConvertTo-Json -Depth 8), $utf8)
    if ($pendingJobs.Count) {
        [Console]::Out.WriteLine("verify full $Task · árvore $($tree.Substring(0, 12)) · PARCIAL: $(@($results).Count) comando(s) rodado(s), pendente(s): $($pendingJobs -join ', ')")
        foreach ($r in $results) { [Console]::Out.WriteLine("  $($r.key): exit $($r.exit) · $($r.seconds) s · $(@($r.decisive) | Select-Object -Last 1)") }
        foreach ($w in $near) { [Console]::Out.WriteLine("  atenção: $w") }
        [Console]::Out.WriteLine("  parcial: rode o MESMO comando de novo — ele continua de onde parou (exit 3); a árvore não pode mudar entre as chamadas.")
        exit 3
    }

    $bad = @($results | Where-Object { [int]$_.exit -ne 0 })
    $envBad = @($results | Where-Object { $_.environment })
    [Console]::Out.WriteLine("verify $Mode $Task · árvore $($tree.Substring(0, 12)) · " + $(if ($envBad.Count) { "FALHA DE AMBIENTE em $($envBad.Count) comando(s)" } elseif ($bad.Count) { "$($bad.Count) comando(s) com falha" } else { 'tudo exit 0' }) + " · $($resPath.Substring($Root.Length + 1) -replace '\\', '/')")
    foreach ($r in $results) { [Console]::Out.WriteLine("  $($r.key): exit $($r.exit) · $($r.seconds) s · $(@($r.decisive) | Select-Object -Last 1) · log $($r.log) ($($r.lines) linhas)") }
    foreach ($r in $envBad) { [Console]::Out.WriteLine("  ambiente ($($r.key)): $($r.environment)") }
    # v3.53.6 (item 4): cada id ausente (com o cenário e o .scn) e cada controle sem id (arquivo:linha).
    foreach ($l in @($tidLines | Select-Object -First 40)) { [Console]::Out.WriteLine("    $l") }
    if ($tidLines.Count -gt 40) { [Console]::Out.WriteLine("    … e mais $($tidLines.Count - 40) no log testids") }
    # v3.57.0 (item 7): o aviso de atributo divergente e os ids dinâmicos declarados (não conferidos) saem no console, não só no log.
    if ($Mode -eq 'full' -and $tid) { foreach ($nt in @($tid.Notes | Where-Object { $_ -match '^(atributo de teste|id dinâmico)' })) { [Console]::Out.WriteLine("  ids de teste: $nt") } }
    if ($tidLines.Count) { [Console]::Out.WriteLine('  ids de teste: o dev cria no código o id que o .scn cita (testTag / data-testid, standards/stacks/<tecnologia>/guide.md) e põe id em todo controle interativo; exceção só com "// sem-testid: <motivo>" na linha ou na anterior') }
    foreach ($w in @($script:hygieneWarnings) + $near) { [Console]::Out.WriteLine("  atenção: $w") }
    # v3.57.0 (plugin-report do sprint 5 do garden, item 14): o APK mais velho que o código só aparecia no accept (exit 2, "reconstrua"),
    # depois do dev e do QA. Ao fim de um full verde, num projeto com alvo android, o aviso vem já aqui: o build não regerou o APK.
    if ($Mode -eq 'full' -and -not $envBad.Count -and -not $bad.Count) {
        $tcA = Get-TargetsConfig $Root
        if ($tcA -and $tcA.PSObject.Properties['android']) {
            $apkA = Get-LatestApk $Root
            if ($apkA) { $stA = Get-ApkStaleness $apkA; if ($stA.Stale) { $modN = Split-Path $stA.Module -Leaf; [Console]::Out.WriteLine("  atenção: o APK $modN$($stA.ApkFull.Substring($stA.Module.Length)) é de $($stA.ApkTime.ToString('yyyy-MM-dd HH:mm:ss')) e $modN$($stA.File.Substring($stA.Module.Length)) mudou em $($stA.FileTime.ToString('yyyy-MM-dd HH:mm:ss')): o comando 'build' não regerou o APK — rode $($stA.Task) (ou ponha no verify.build do guards.json) antes do accept, que recusa APK velho (exit 2)") } }
        }
    }
    if ($after -ne $tree) { [Console]::Out.WriteLine("  atenção: os comandos alteraram a árvore (antes $($tree.Substring(0, 12)), depois $(([string]$after).Substring(0, [Math]::Min(12, ([string]$after).Length)))) — arquivo gerado fora do .gitignore; a evidência vale para a árvore de antes") }
    if ($envBad.Count) { [Console]::Out.WriteLine('  não é defeito do código: não depure; a sessão tenta o reparo do ambiente uma vez (target.ps1 -Repair) e, sem sucesso, bloqueio de ambiente'); exit 4 }
    if ($bad.Count) { exit 1 }
    exit 0
} catch {
    [Console]::Error.WriteLine("verify: erro — $($_.Exception.Message)")
    exit 2
} finally {
    Complete-Call $dir
    if ($script:lockPath) { Remove-Item -LiteralPath $script:lockPath -Force -ErrorAction SilentlyContinue }
}
