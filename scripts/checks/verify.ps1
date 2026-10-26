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
# Saída: ~10 linhas (o log fica no disco). Exit 0 = tudo com código 0 (check: árvore igual e full verde) · 1 = algum
# comando falhou, árvore diferente ou sem full · 2 = erro de uso (sem guards.json → verify, sem git) · 3 = mutação parcial ·
# 4 = FALHA DE AMBIENTE (v3.51): tempo esgotado ou saída com assinatura conhecida de ambiente (tool-hygiene.json) — não é
# defeito do código: o papel não depura; a sessão tenta o reparo (target.ps1 -Repair) uma vez e, sem sucesso, bloqueio de ambiente.
# v3.51: -TimeoutMinutes (ou guards.json → verify.timeoutMinutes, padrão 9) por comando; verify.env = variáveis do filho
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
param(
    [Parameter(Mandatory = $true)][string]$Task,
    [ValidateSet('focused', 'full', 'check', 'mutation')][string]$Mode = 'full',
    [string[]]$Tests = @(),
    [string]$Plan = '',
    [string[]]$Only = @(),
    [int]$MaxMinutes = 8,
    [double]$TimeoutMinutes = 0,
    [switch]$Precheck,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
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
function Invoke-Logged([string]$Key, [string]$Cmd, [string]$Log) {
    $extra = [ordered]@{}
    if ($verify -and $verify.PSObject.Properties['env'] -and $verify.env) { foreach ($p in $verify.env.PSObject.Properties) { $extra[$p.Name] = [string]$p.Value } }
    $daemon = $verify -and $verify.PSObject.Properties['daemon'] -and $verify.daemon -eq $true
    if ($daemon -and -not $extra.Contains('GRADLE_OPTS')) { $extra['GRADLE_OPTS'] = (([string]$env:GRADLE_OPTS -replace '-Dorg\.gradle\.daemon=\w+', '').Trim() + ' -Dorg.gradle.daemon=true').Trim() }
    $r = Invoke-ProjectCommand $Root $Key $Cmd $Log $script:timeoutMinutes ([pscustomobject]$extra) -KeepDescendants:$daemon
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

function Format-Tests([string[]]$List) {
    $pre = ''; if ($verify -and $verify.PSObject.Properties['testRoot']) { $pre = (([string]$verify.testRoot).Trim() -replace '\\', '/').TrimEnd('/') + '/' }
    $item = '{path}'; if ($verify -and $verify.PSObject.Properties['testItem'] -and $verify.testItem) { $item = [string]$verify.testItem }
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
    '(?i)\bTransform failed\b', '(?i)\bBuild failed with \d+ errors?\b', '(?i)\bTests:\s+0 total\b', '(?m)^\s*\S+\.java:\d+: error:')

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
    $focusedCmd = @(Get-Commands $verify 'focused')

    if ($Mode -eq 'mutation') {
        # Prova de falha (v3.46): só sobre a árvore do último full verde — a mutação prova o teste daquele código.
        if (-not $Plan -or -not (Test-Path -LiteralPath (Join-Path $Root $Plan))) { [Console]::Error.WriteLine('verify: -Mode mutation pede -Plan <caminho do plano, relativo à raiz>.'); exit 2 }
        if ($focusedCmd.Count -eq 0) { [Console]::Error.WriteLine('verify: guards.json → verify sem "focused" — a mutação roda o teste focado.'); exit 2 }
        if ($Precheck) {
            # v3.51.4 (garden item 27): conferência prévia, sem teste — trecho único no arquivo e, com verify.compile, mutante que compila.
            $pt = Read-Text (Join-Path $Root $Plan); $pm = @(Get-Mutations $pt); if ($Only.Count) { $pm = @($pm | Where-Object { $Only -contains $_.Id }) }
            $compile = @(Get-Commands $verify 'compile') | Select-Object -First 1
            $probs = @(); $okIds = @()
            foreach ($mu in $pm) {
                $rel = ($mu.File -replace '\\', '/') -replace '^\./', ''; $f2 = Join-Path $Root $rel
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
            [Console]::Out.WriteLine("verify mutation -Precheck $Task · $($okIds.Count) de $($pm.Count) mutação(ões) prontas" + $(if ($compile) { ' (trecho único e mutante compila)' } else { ' (trecho único; sem verify.compile, a compilação se vê na mutação)' }))
            foreach ($p in $probs) { [Console]::Out.WriteLine("  $p — o plano é do Arquiteto: 🔺 GAP com esta linha") }
            if ($probs.Count) { exit 1 } else { exit 0 }
        }
        $full = if ($prev) { $prev.full } else { $null }
        if ($null -eq $full -or [string]$full.tree -ne $tree) { [Console]::Error.WriteLine("verify: a mutação roda sobre a árvore do último full — rode -Mode full antes (árvore agora $($tree.Substring(0, 12)))."); exit 2 }
        $planText = Read-Text (Join-Path $Root $Plan)
        $planMuts = @(Get-Mutations $planText)
        $muts = $planMuts
        if ($Only.Count) { $muts = @($muts | Where-Object { $Only -contains $_.Id }) }
        if ($muts.Count -eq 0) { [Console]::Error.WriteLine('verify: nenhuma linha "- M<k> · teste `…` · `…` · `trecho` → `mutante`" em **Mutações:** do plano' + $(if ($Only.Count) { ' com ' + ($Only -join ',') } else { '' }) + '.'); exit 2 }
        # Retomada (v3.47.1): sem -Only, o que já tem resultado conclusivo nesta mesma árvore não roda de novo — a chamada
        # anterior parou no -MaxMinutes e esta continua de onde ela parou.
        $sameTree = $prev -and $prev.mutation -and [string]$prev.mutation.tree -eq $tree
        if (-not $Only.Count -and $sameTree) {
            $done = @(@($prev.mutation.items) | Where-Object { ([string]$_.result) -match '^(ok|falhou)\b' } | ForEach-Object { [string]$_.id })
            $muts = @($muts | Where-Object { $done -notcontains $_.Id })
        }
        $scope = @(Get-PlanScope $planText)
        New-Item -ItemType Directory -Force $dir | Out-Null
        $items = @(); $pending = @()
        $budget = [System.Diagnostics.Stopwatch]::StartNew(); $lastSec = 0; $ranAny = $false
        $base = @{}   # teste → $null (passou e executou) ou o motivo de não servir de linha de base
        foreach ($mu in $muts) {
            $rel = ($mu.File -replace '\\', '/') -replace '^\./', ''
            $item = [ordered]@{ id = $mu.Id; test = $mu.Test; file = $rel; result = ''; exit = $null; decisive = @(); log = '' }
            $full2 = Join-Path $Root $rel
            if ($scope -notcontains $rel) { $item.result = 'inconclusivo — arquivo fora de **Arquivos tocados:** do plano'; $items += $item; continue }
            if (-not (Test-Path -LiteralPath $full2)) { $item.result = 'inconclusivo — arquivo não existe'; $items += $item; continue }
            if ($mu.Find -eq '') { $item.result = 'inconclusivo — trecho vazio no plano (crase dupla ou trecho com crase: escolha outro trecho)'; $items += $item; continue }
            # Orçamento: a próxima execução não cabe → fica pendente para a próxima chamada (a primeira sempre roda).
            if ($ranAny -and ($budget.Elapsed.TotalSeconds + $lastSec) -gt ($MaxMinutes * 60)) { $pending += $mu.Id; continue }
            $ranAny = $true
            if (-not $base.ContainsKey($mu.Test)) {
                $bk = 'base-' + ($base.Count + 1)
                $b = Invoke-Logged $bk $focusedCmd[0].Replace('{tests}', (Format-Tests @($mu.Test))) (Join-Path $dir "mutation-$bk.log")
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
                $r = Invoke-Logged $mu.Id $focusedCmd[0].Replace('{tests}', (Format-Tests @($mu.Test))) (Join-Path $dir "mutation-$($mu.Id).log")
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
        foreach ($it in $items) { [Console]::Out.WriteLine("  $($it.id) $($it.file): $($it.result)" + $(if ($null -ne $it.exit) { " · exit $($it.exit) · $(@($it.decisive) | Select-Object -Last 1)" } else { '' })) }
        foreach ($it in @($merged | Where-Object { $want -contains [string]$_.id })) { [Console]::Out.WriteLine("  $($it.id) $($it.file): $($it.result) (chamada anterior, mesma árvore)") }
        if ($pending.Count) { [Console]::Out.WriteLine("  parcial: $($pending -join ', ') não couberam em -MaxMinutes $MaxMinutes — rode o MESMO comando de novo; ele continua de onde parou."); exit 3 }
        if ($badM.Count) { exit 1 }
        exit 0
    }

    $keys = if ($Mode -eq 'focused') { @('focused', 'lint') } else { @('build', 'lint', 'suite', 'coverage') }   # $plan seria o -Plan (string)
    $jobs = @()
    foreach ($k in $keys) { $i = 0; foreach ($c in (Get-Commands $verify $k)) { $i++; $jobs += @{ Key = $(if ($i -gt 1) { "$k$i" } else { $k }); Cmd = $c } } }
    if ($Mode -eq 'focused') {
        if (-not ($jobs | Where-Object { $_.Key -like 'focused*' })) { [Console]::Error.WriteLine('verify: guards.json → verify sem "focused" (o comando do teste focado, com {tests}).'); exit 2 }
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
    foreach ($j in $jobs) {
        if ($Mode -eq 'full' -and $ranAny -and ($budget.Elapsed.TotalSeconds + $lastSec) -gt ($MaxMinutes * 60)) { $pendingJobs += $j.Key; continue }
        $ranAny = $true
        $r1 = Invoke-Logged $j.Key $j.Cmd.Replace('{tests}', (Format-Tests $Tests)) (Join-Path $dir "$Mode-$($j.Key).log")
        $results += $r1; $lastSec = $r1.seconds
    }
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
        [Console]::Out.WriteLine("  parcial: rode o MESMO comando de novo — ele continua de onde parou (exit 3); a árvore não pode mudar entre as chamadas.")
        exit 3
    }

    $bad = @($results | Where-Object { [int]$_.exit -ne 0 })
    $envBad = @($results | Where-Object { $_.environment })
    [Console]::Out.WriteLine("verify $Mode $Task · árvore $($tree.Substring(0, 12)) · " + $(if ($envBad.Count) { "FALHA DE AMBIENTE em $($envBad.Count) comando(s)" } elseif ($bad.Count) { "$($bad.Count) comando(s) com falha" } else { 'tudo exit 0' }) + " · $($resPath.Substring($Root.Length + 1) -replace '\\', '/')")
    foreach ($r in $results) { [Console]::Out.WriteLine("  $($r.key): exit $($r.exit) · $($r.seconds) s · $(@($r.decisive) | Select-Object -Last 1) · log $($r.log) ($($r.lines) linhas)") }
    foreach ($r in $envBad) { [Console]::Out.WriteLine("  ambiente ($($r.key)): $($r.environment)") }
    foreach ($w in $script:hygieneWarnings) { [Console]::Out.WriteLine("  atenção: $w") }
    if ($after -ne $tree) { [Console]::Out.WriteLine("  atenção: os comandos alteraram a árvore (antes $($tree.Substring(0, 12)), depois $(([string]$after).Substring(0, [Math]::Min(12, ([string]$after).Length)))) — arquivo gerado fora do .gitignore; a evidência vale para a árvore de antes") }
    if ($envBad.Count) { [Console]::Out.WriteLine('  não é defeito do código: não depure; a sessão tenta o reparo do ambiente uma vez (target.ps1 -Repair) e, sem sucesso, bloqueio de ambiente'); exit 4 }
    if ($bad.Count) { exit 1 }
    exit 0
} catch {
    [Console]::Error.WriteLine("verify: erro — $($_.Exception.Message)")
    exit 2
} finally {
    Complete-Call $dir
}
