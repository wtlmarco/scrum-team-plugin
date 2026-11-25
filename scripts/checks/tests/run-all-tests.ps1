# Roda as duas suítes do plugin em paralelo — v3.64.1, níveis, -Changed, -Detach e grupos das guardas na v3.66.1.
# A suíte de conferências (run-check-tests.ps1) é dividida em blocos independentes (suite-blocks.ps1, Get-SuiteUnits), e a
# suíte das guardas (run-guard-tests.ps1) nos grupos das seções dela (Get-GuardGroups); cada bloco e cada grupo roda num
# processo próprio, com o seu $tmp, e o pool equilibra os dois pelos tempos medidos. Cada chamada de script de um caso tem
# prazo (-CheckTimeoutSec): passou dele, a árvore do processo é encerrada e o caso falha com "TEMPO ESGOTADO".
#
# Uso (na raiz do repositório-fonte):
#   powershell -NoProfile -File scripts/checks/tests/run-all-tests.ps1            # dia a dia: pula o nível lento
#   powershell -NoProfile -File scripts/checks/tests/run-all-tests.ps1 -Full      # tudo — a conferência antes do PR
#   powershell -NoProfile -File scripts/checks/tests/run-all-tests.ps1 -Changed   # só o que a mudança toca (e o C3)
#   powershell -NoProfile -File scripts/checks/tests/run-all-tests.ps1 -Only 'portão|G14'   # os blocos/grupos com caso que casa
#   powershell -NoProfile -File scripts/checks/tests/run-all-tests.ps1 -Full -Detach        # num processo que sobrevive à sessão
#   powershell -NoProfile -File scripts/checks/tests/run-all-tests.ps1 -Wait '<pasta>'      # acompanha a rodada desacoplada
# Nível lento (v3.66.1, item A): a unidade com caso cujo último tempo medido passa de -SlowSec (20 s) fica fora sem -Full; a
#   saída diz quantos casos e quanto tempo isso poupou. Caso novo (sem medição) é rápido até ser medido. -Only roda o que casa,
#   lento ou não.
# -Changed (item B): os arquivos alterados em relação a -Base (develop), nos commits da branch e no disco. Biblioteca comum
#   (lib.ps1, hooks/common.ps1, plain.ps1, impasse-lib.ps1, hooks/*.json) roda tudo; script ou documento alterado roda os
#   blocos e os grupos que o citam (e os dos scripts que o carregam); linha alterada na própria suíte roda a unidade dela. O
#   C3 (release.ps1) roda sempre. Não substitui o -Full antes do PR.
# -Detach (item D): sobe a rodada num processo fora da árvore da sessão (Start-DetachedJob, lib.ps1) e volta na hora com a
#   pasta e o processo; a rodada grava summary.txt (contagem, falhas com a saída, os mais lentos, a parede) e, no fim,
#   "FIM exit=<código>". -Wait <pasta> espera até -WaitSeconds (540) e imprime o resumo; exit 3 = ainda rodando.
# -Workers <n> (item E; padrão: o menor entre núcleos − 1, memória livre ÷ 1,5 GB e 6; com menos de 4 GB livres, no máximo 2,
#   com aviso) · -CheckTimeoutSec <s> (padrão 240) · -Suites check,guard · -ListBlocks (o que rodaria, e por quê).
# Os tempos de cada caso e de cada grupo das guardas ficam em %LOCALAPPDATA%\team-plugin\test-times.json: equilibram os blocos
# e decidem o nível da próxima rodada.
# Saída: as falhas (com a saída do caso), os 12 mais lentos, o tempo de parede e "N casos · F falharam"; exit 1 com falha.
param(
    [string]$Only = '',
    [switch]$Full,
    [switch]$Changed,
    [string]$Base = 'develop',
    [int]$Workers = 0,
    [int]$CheckTimeoutSec = 240,
    [double]$SlowSec = 20,
    [string[]]$Suites = @('check', 'guard'),
    [switch]$ListBlocks,
    [switch]$Detach,
    [string]$Wait = '',
    [int]$WaitSeconds = 540,
    # Para os testes do próprio script (v3.66.1): outro repositório, outras suítes, outro arquivo de tempos, sem o C3, e a
    # memória e os núcleos medidos trocados.
    [string]$Root = '',
    [string]$CheckSuite = '',
    [string]$GuardSuite = '',
    [string]$TimesFile = '',
    [string]$RunsDir = '',
    [switch]$NoRelease,
    [double]$FreeGB = -1,
    [int]$Cores = 0,
    [int]$SleepGapSec = 60,
    # Uso interno do -Detach.
    [string]$SummaryFile = '',
    [switch]$Progress
)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
. (Join-Path $here 'suite-blocks.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($true)
$u8 = New-Object System.Text.UTF8Encoding($false)
$repo = if ($Root) { (Resolve-Path -LiteralPath $Root).Path } else { (Resolve-Path (Join-Path $here '..\..\..')).Path }
$appData = if ($env:LOCALAPPDATA) { $env:LOCALAPPDATA } else { [System.IO.Path]::GetTempPath() }
$script:outL = New-Object System.Collections.Generic.List[string]
function Say([string]$s) { $script:outL.Add($s) }
function Show-Progress([string]$s) { if ($Progress) { [Console]::Out.WriteLine($s); [Console]::Out.Flush() } }
# A rodada termina por aqui: imprime, grava o resumo (rodada desacoplada) com o FIM e sai com o código.
function Exit-Run([int]$Code) {
    foreach ($l in $script:outL) { Write-Output $l }
    if ($SummaryFile) { try { [System.IO.File]::WriteAllText($SummaryFile, (($script:outL -join "`r`n") + "`r`nFIM exit=$Code`r`n"), $u8) } catch { } }
    exit $Code
}
# O trap vale para o script inteiro (no PowerShell ele cobre o escopo todo): o erro de qualquer trecho vira o resumo com o FIM.
trap { Say "run-all-tests: parou com erro — $($_.Exception.Message) (linha $($_.InvocationInfo.ScriptLineNumber))"; Exit-Run 2 }

# ---------- -Wait: acompanha a rodada desacoplada ----------
if ($Wait) {
    . (Join-Path $here '..\lib.ps1')
    $job = Wait-DetachedJob $Wait $WaitSeconds
    if (-not $job) { Write-Output "run-all-tests -Wait: nenhuma rodada em $Wait"; exit 2 }
    $sum = Join-Path $Wait 'summary.txt'
    $jo = Join-Path $Wait 'job.out'
    if ($job.State -eq 'running') {
        $last = ''
        if (Test-Path -LiteralPath $jo) {
            # A rodada segura o job.out aberto para escrita: lê com o compartilhamento dela.
            $txt = ''; try { $fs = New-Object System.IO.FileStream($jo, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite); $sr = New-Object System.IO.StreamReader($fs, [System.Text.Encoding]::UTF8); $txt = $sr.ReadToEnd(); $sr.Close() } catch { }
            $pl = @($txt -split "`r?`n" | Where-Object { $_ -match '^pronto: ' }); if ($pl.Count) { $last = " · $($pl[-1])" }
        }
        Write-Output ("a rodada segue (há {0:N0} min, processo {1}){2} — chame -Wait '{3}' de novo" -f $job.Minutes, $job.Pid, $last, $Wait)
        exit 3
    }
    if (Test-Path -LiteralPath $sum) { Write-Output ([System.IO.File]::ReadAllText($sum, [System.Text.Encoding]::UTF8).TrimEnd()); if ($null -ne $job.Exit) { exit $job.Exit }; exit 2 }
    Write-Output "a rodada parou sem gravar o resumo (estado $($job.State), exit $($job.Exit)) — fim da saída:"
    foreach ($f in @($jo, (Join-Path $Wait 'job.err'))) { if (Test-Path -LiteralPath $f) { $t = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8); Write-Output $t.Substring([Math]::Max(0, $t.Length - 3000)).TrimEnd() } }
    exit 2
}

# ---------- -Detach: a mesma rodada num processo que sobrevive à sessão ----------
if ($Detach) {
    . (Join-Path $here '..\lib.ps1')
    $runs = if ($RunsDir) { $RunsDir } else { Join-Path $appData 'team-plugin\suite-runs' }
    New-Item -ItemType Directory -Force $runs | Out-Null
    foreach ($old in @(Get-ChildItem -LiteralPath $runs -Directory -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) })) { Remove-Item -LiteralPath $old.FullName -Recurse -Force -ErrorAction SilentlyContinue }
    $dir = Join-Path $runs ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0, 4))
    $q = { param($v) "'" + ([string]$v -replace "'", "''") + "'" }
    $argv = @()
    foreach ($kv in $PSBoundParameters.GetEnumerator()) {
        if (@('Detach', 'Wait', 'WaitSeconds', 'SummaryFile', 'Progress') -contains $kv.Key) { continue }
        $v = $kv.Value
        if ($v -is [System.Management.Automation.SwitchParameter]) { if ($v.IsPresent) { $argv += "-$($kv.Key)" } }
        elseif ($v -is [array]) { $argv += "-$($kv.Key) $((@($v | ForEach-Object { & $q $_ })) -join ',')" }
        else { $argv += "-$($kv.Key) $(& $q $v)" }
    }
    $cmd = "& $(& $q $PSCommandPath) $($argv -join ' ') -SummaryFile $(& $q (Join-Path $dir 'summary.txt')) -Progress; exit `$LASTEXITCODE"
    $why = Start-DetachedJob -Dir $dir -Root $repo -Command $cmd -Sig 'run-all-tests' -Label 'suíte do plugin'
    if ($why) { Write-Output "run-all-tests -Detach: $why"; exit 2 }
    $job = Get-DetachedJob $dir
    Write-Output "rodada desacoplada: $dir · processo $($job.Pid)"
    Write-Output "acompanhe: powershell -NoProfile -File scripts/checks/tests/run-all-tests.ps1 -Wait '$dir'"
    exit 0
}

$wall = [System.Diagnostics.Stopwatch]::StartNew()
if ($Workers -le 0) {
    $dw = Get-DefaultWorkers $(if ($Cores -gt 0) { $Cores } else { [Environment]::ProcessorCount }) $(if ($FreeGB -ge 0) { $FreeGB } else { Get-FreeMemoryGB })
    $Workers = $dw.Workers
    if ($dw.Busy) { Say "máquina ocupada: $Workers processos; a rodada fica mais lenta" }
}
$env:TEAM_TEST_CHECK_TIMEOUT_S = [string]$CheckTimeoutSec   # os blocos e os grupos das guardas herdam
$Suites = @($Suites | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim().ToLowerInvariant() } | Where-Object { $_ })
$cf = if ($CheckSuite) { (Resolve-Path -LiteralPath $CheckSuite).Path } else { Join-Path $here 'run-check-tests.ps1' }
$gf = if ($GuardSuite) { (Resolve-Path -LiteralPath $GuardSuite).Path } else { Join-Path $here 'run-guard-tests.ps1' }
$run = Join-Path ([System.IO.Path]::GetTempPath()) ('team-all-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force $run | Out-Null
$timesP = if ($TimesFile) { $TimesFile } else { Join-Path $appData 'team-plugin\test-times.json' }
$times = @{}
if (Test-Path -LiteralPath $timesP) { try { foreach ($pp in (Get-Content -LiteralPath $timesP -Raw -Encoding UTF8 | ConvertFrom-Json).PSObject.Properties) { $times[$pp.Name] = [double]$pp.Value } } catch { } }
# Blocos de uma rodada que morreu no meio (sessão caída) ficam ao lado da suíte: os de mais de 6 h saem.
foreach ($ob in @(Get-ChildItem -LiteralPath (Split-Path $cf) -Filter '.bloco-*.ps1' -Force -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt (Get-Date).AddHours(-6) })) { Remove-Item -LiteralPath $ob.FullName -Force -ErrorAction SilentlyContinue }

# ---------- -Changed: o que mudou e o que isso toca ----------
$chg = $null
if ($Changed) {
    $cr = Get-ChangedFiles $repo $Base
    if ($cr.Error) { Say "-Changed: $($cr.Error) — roda como sem -Changed"; $Changed = $false }
    else {
        $relOf = { param($p) $rp = $p.Substring($repo.Length).TrimStart('\', '/') -replace '\\', '/'; $rp }
        $cRel = & $relOf $cf; $gRel = & $relOf $gf
        $libs = @($cr.Files | Where-Object { Test-SharedLib $_ })
        $names = Get-AffectedNames $repo $cr.Files @($cRel, $gRel)
        $chg = [pscustomobject]@{ Files = $cr.Files; All = $(if ($libs.Count) { "biblioteca comum alterada ($($libs -join ', '))" } else { $null }); Names = $names
            CheckLines = $(if ($cr.Files -contains $cRel) { Get-ChangedLineSet $repo $cr.MergeBase $cRel } else { 'none' })
            GuardLines = $(if ($cr.Files -contains $gRel) { Get-ChangedLineSet $repo $cr.MergeBase $gRel } else { 'none' }) }
        Say "-Changed: $($cr.Files.Count) arquivo(s) alterado(s) desde $($cr.MergeBase.Substring(0, [Math]::Min(7, $cr.MergeBase.Length))) ($Base)$(if ($chg.All) { " — $($chg.All): roda tudo" })"
        foreach ($f in $cr.Files) { Say "  mudou: $f" }
    }
}
# A linha alterada da suíte cai neste trecho? 'none' = a suíte não mudou; $null = a suíte inteira é nova.
function Test-LinesHit($Set, [int]$From, [int]$To) {
    if ($Set -is [string]) { return $false }
    if ($null -eq $Set) { return $true }
    for ($l = $From; $l -le $To; $l++) { if ($Set.Contains($l)) { return $true } }
    return $false
}
function Test-LinesOutside($Set, $Ranges) {
    if ($Set -is [string]) { return $false }
    if ($null -eq $Set) { return $true }
    foreach ($l in $Set) { $in = $false; foreach ($r in $Ranges) { if ($l -ge $r[0] -and $l -le $r[1]) { $in = $true; break } }; if (-not $in) { return $true } }
    return $false
}

# ---------- os blocos da suíte de conferências ----------
$jobs = @(); $skipSlow = 0; $skipSlowSec = 0.0; $chgOut = 0
$w = { param($u) $s = 0.0; foreach ($c in $u.Checks) { $s += $(if ($times.ContainsKey($c)) { $times[$c] } else { 4.0 }) }; if (-not $u.Checks.Count) { $s = 1.0 }; $s }
if ($Suites -contains 'check') {
    $su = Get-SuiteUnits $cf
    $units = @($su.Units)
    foreach ($u in $units) { $u | Add-Member -NotePropertyName Why -NotePropertyValue '' -Force }
    if ($Only) { $units = @($units | Where-Object { @($_.Checks | Where-Object { $_ -match $Only }).Count }) }
    elseif ($Changed) {
        $pt = Get-PreambleTouch $su.PreStatements @() $chg.Names
        $allWhy = if ($chg.All) { $chg.All } elseif ($pt.All) { "preâmbulo da suíte $($pt.All)" } elseif (Test-LinesOutside $chg.CheckLines @(, @($su.Begin, $su.End))) { 'preâmbulo da suíte alterado' } else { '' }
        $keep = @()
        foreach ($u in $units) {
            $why = $allWhy
            if (-not $why -and (Test-LinesHit $chg.CheckLines $u.From $u.To)) { $why = 'caso alterado na suíte' }
            if (-not $why) { $why = Find-Touch (($su.Lines[($u.From - 1)..($u.To - 1)]) -join "`n") $chg.Names $pt.Touched }
            if ($why) { $u.Why = $why; $keep += $u } else { $chgOut++ }
        }
        $units = $keep
    }
    if (-not $Full -and -not $Only) {
        $fast = @()
        foreach ($u in $units) { if ((Get-UnitTier $u $times $SlowSec) -eq 'slow') { $skipSlow += $u.Checks.Count; $skipSlowSec += (& $w $u) } else { $fast += $u } }
        $units = $fast
    }
    # Blocos: unidades vizinhas juntas até ~1/(3·Workers) do total — poucos processos (o preâmbulo custa ~2 s cada) e
    # trabalho miúdo o bastante para o pool equilibrar.
    $total = 0.0; foreach ($u in $units) { $total += (& $w $u) }
    $target = [Math]::Max(20.0, $total / (3 * $Workers))
    $blocks = @(); $cur = @(); $cw = 0.0
    foreach ($u in $units) {
        $uw = & $w $u
        if ($cur.Count -and $cw + $uw -gt $target) { $blocks += , @($cur); $cur = @(); $cw = 0.0 }
        $cur += $u; $cw += $uw
    }
    if ($cur.Count) { $blocks += , @($cur) }
    $bi = 0
    foreach ($bk in $blocks) {
        $bi++
        $body = New-Object System.Text.StringBuilder
        # O processo do bloco tem a saída redirecionada: sem isto, ele lê a saída dos scripts (UTF-8) pela página OEM e os
        # padrões com acento ou emoji não casam.
        [void]$body.AppendLine('[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false); $OutputEncoding = [Console]::OutputEncoding')
        [void]$body.AppendLine($su.Preamble)   # o preâmbulo sobe a sentinela do prazo (check-watchdog.ps1)
        foreach ($u in $bk) { [void]$body.AppendLine(($su.Lines[($u.From - 1)..($u.To - 1)] -join "`r`n")) }
        $res = Join-Path $run "check-$bi.json"
        [void]$body.AppendLine('try { Stop-Process -Id $script:watchdog.Id -Force -ErrorAction SilentlyContinue } catch { }')
        [void]$body.AppendLine('Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue')
        [void]$body.AppendLine("[System.IO.File]::WriteAllText('$res', (ConvertTo-Json -InputObject ([ordered]@{ fail = `$fail; rows = @(`$rows) }) -Depth 4), (New-Object System.Text.UTF8Encoding(`$false)))")
        [void]$body.AppendLine('exit 0')
        $bf = Join-Path (Split-Path $cf) ".bloco-$bi-$([guid]::NewGuid().ToString('N').Substring(0, 6)).ps1"   # ao lado da suíte: $PSScriptRoot igual
        if (-not $ListBlocks) { [System.IO.File]::WriteAllText($bf, $body.ToString(), $utf8) }
        $whys = @($bk | Where-Object { $_.Why } | ForEach-Object { $_.Why } | Select-Object -Unique)
        $jobs += [pscustomobject]@{ Name = "check-$bi"; Kind = 'check'; File = $bf; Result = $res; Log = (Join-Path $run "check-$bi.log"); Units = @($bk); Expected = @($bk | ForEach-Object { $_.Checks }).Count; Weight = (($bk | ForEach-Object { & $w $_ }) | Measure-Object -Sum).Sum; Lines = "$($bk[0].From)–$($bk[-1].To)"; Why = $whys; TimeKey = ''; Proc = $null; Watch = $null }
    }
}
# ---------- os grupos da suíte das guardas (v3.66.1, item C) ----------
if ($Suites -contains 'guard') {
    $gg = Get-GuardGroups $gf
    $gsel = @($gg.Groups)
    $gWhy = @{}
    if ($Only) { $gsel = @($gsel | Where-Object { @($_.Names | Where-Object { $_ -match $Only }).Count -or ($null -eq $_.Cases -and $_.Text -match $Only) }) }
    elseif ($Changed) {
        $pt = Get-PreambleTouch $gg.PreStatements $gg.Runner $chg.Names
        $ranges = @(, @($gg.CasesFrom, $gg.CasesTo)); foreach ($g in $gg.Groups) { if ($null -eq $g.Cases) { $ranges += , @($g.From, $g.To) } }
        $allWhy = if ($chg.All) { $chg.All } elseif ($pt.All) { "executor das guardas $($pt.All)" } elseif (Test-LinesOutside $chg.GuardLines $ranges) { 'preâmbulo ou executor das guardas alterado' } else { '' }
        $keep = @()
        foreach ($g in $gsel) {
            $why = $allWhy
            if (-not $why) {
                if ($null -eq $chg.GuardLines) { $why = 'suíte das guardas nova' }
                elseif ($chg.GuardLines -isnot [string]) {
                    if (Test-LinesHit $chg.GuardLines $g.From $g.To) { $why = 'caso alterado na suíte' }
                }
            }
            if (-not $why) { $why = Find-Touch $g.Text $chg.Names $pt.Touched }
            if ($why) { $gWhy[$g.Index] = $why; $keep += $g } else { $chgOut++ }
        }
        $gsel = $keep
    }
    foreach ($g in $gsel) {
        $key = "guard-group: $($g.Title)"
        $res = Join-Path $run "guard-$($g.Index).json"
        $jobs += [pscustomobject]@{ Name = "guard-$($g.Index)"; Kind = 'guard'; File = $gf; Group = $g.Index; Result = $res; Log = (Join-Path $run "guard-$($g.Index).log"); Units = @(); Expected = $(if ($null -eq $g.Cases) { -1 } else { $g.Count }); Weight = $(if ($times.ContainsKey($key)) { $times[$key] } else { 15.0 }); Lines = "$($g.From)–$($g.To)"; Why = @($(if ($gWhy.ContainsKey($g.Index)) { $gWhy[$g.Index] })); TimeKey = $key; Title = $g.Title; Proc = $null; Watch = $null }
    }
}
$doRelease = -not $Only -and -not $NoRelease
$tierLine = if ($skipSlow) { "nível lento fora: $skipSlow casos (≈ $([int]$skipSlowSec) s de trabalho poupados) — -Full roda todos; a conferência antes do PR é -Full" } else { '' }
if ($ListBlocks) {
    foreach ($j in $jobs) {
        $n = if ($j.Kind -eq 'guard') { $(if ($j.Expected -ge 0) { $j.Expected } else { '?' }) } else { $j.Expected }
        Say ("{0,-9} linhas {1,-11} peso {2,7:N0} s  casos {3}{4}" -f $j.Name, $j.Lines, $j.Weight, $n, $(if ($j.Kind -eq 'guard') { "  · $($j.Title)" } else { '' }))
        foreach ($y in @($j.Why | Where-Object { $_ })) { Say "  entrou: $y" }
    }
    if ($Changed) { Say "-Changed: $($jobs.Count) bloco(s)/grupo(s) entram; $chgOut unidade(s)/grupo(s) ficam de fora$(if ($doRelease) { '; o C3 (release.ps1) roda sempre' })" }
    if ($tierLine) { Say $tierLine }
    Say "processos: $Workers"
    Remove-Item -Recurse -Force $run -ErrorAction SilentlyContinue
    Exit-Run 0
}
if (-not $jobs.Count -and -not ($Changed -and $doRelease)) { Remove-Item -Recurse -Force $run -ErrorAction SilentlyContinue; Say "nenhum caso casa com -Only '$Only'"; Exit-Run 1 }

# ---------- o pool: no máximo $Workers processos, o mais pesado primeiro ----------
$queue = New-Object System.Collections.Queue
foreach ($j in @($jobs | Sort-Object Weight -Descending)) { $queue.Enqueue($j) }
$running = @(); $done = @()
# v3.66.1: a máquina suspensa (tampa fechada, espera moderna) congela a rodada; uma volta do pool que levou mais de 60 s é
# suspensão. A rodada diz quanto tempo dormiu e não grava os tempos no test-times.json — os casos congelados pareceriam lentos
# e o nível lento pularia casos rápidos (24/11: 231 casos fora em vez de 13).
$slept = 0.0; $tick = Get-Date
while ($queue.Count -or $running.Count) {
    $nowT = Get-Date; if (($nowT - $tick).TotalSeconds -gt $SleepGapSec) { $slept += ($nowT - $tick).TotalSeconds }; $tick = $nowT
    while ($queue.Count -and $running.Count -lt $Workers) {
        $j = $queue.Dequeue()
        $j.Watch = [System.Diagnostics.Stopwatch]::StartNew()
        # A suíte das guardas sai pela página OEM se ninguém fixa o UTF-8.
        $argv = if ($j.Kind -eq 'guard') { @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', "[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding(`$false); & '$($j.File)' -Groups $($j.Group) -ResultFile '$($j.Result)'; exit `$LASTEXITCODE") } else { @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $j.File) }
        # protocolo: filho da suíte — o pool espera por ele aqui mesmo.
        $j.Proc = Start-Process powershell -WindowStyle Hidden -PassThru -RedirectStandardOutput $j.Log -RedirectStandardError ($j.Log + '.err') -ArgumentList $argv
        $null = $j.Proc.Handle   # sem o handle guardado, o ExitCode do processo de Start-Process volta vazio
        $running += $j
    }
    Start-Sleep -Milliseconds 500
    foreach ($j in @($running | Where-Object { $_.Proc.HasExited })) {
        $j.Watch.Stop(); $running = @($running | Where-Object { $_ -ne $j }); $done += $j
        Show-Progress ("pronto: {0} ({1}/{2}, {3:N0} s)" -f $j.Name, $done.Count, $jobs.Count, $j.Watch.Elapsed.TotalSeconds)
    }
}

# ---------- o resultado ----------
$rows = @(); $failOut = New-Object System.Text.StringBuilder; $nCases = 0; $nFail = 0
foreach ($j in $done) {
    $log = if (Test-Path -LiteralPath $j.Log) { [System.IO.File]::ReadAllText($j.Log, [System.Text.Encoding]::UTF8) } else { '' }
    $err = if (Test-Path -LiteralPath ($j.Log + '.err')) { [System.IO.File]::ReadAllText($j.Log + '.err', [System.Text.Encoding]::UTF8) } else { '' }
    if ($j.Kind -eq 'check') { Remove-Item -LiteralPath $j.File -Force -ErrorAction SilentlyContinue }
    $got = @(); $bf = 0; $hasRes = $false
    if (Test-Path -LiteralPath $j.Result) { try { $rj = Get-Content -LiteralPath $j.Result -Raw -Encoding UTF8 | ConvertFrom-Json; $got = @($rj.rows | ForEach-Object { $_ }); $bf = [int]$rj.fail; $hasRes = $true } catch { } }
    $rows += $got; $nCases += $got.Count
    $bad = @($got | Where-Object { $_.Ok -ne 'ok' })
    $bf = [Math]::Max($bf, $bad.Count)   # o $fail do bloco conta também a falha que não passa pelo Check (caso 1)
    $nFail += $bf
    $label = if ($j.Kind -eq 'guard') { "$($j.Name) (guardas · $($j.Title))" } else { "$($j.Name) (linhas $($j.Lines))" }
    if ($bf) {
        [void]$failOut.AppendLine("==== ${label}: $bf falharam")
        if ($j.Kind -eq 'guard') { foreach ($b in $bad) { [void]$failOut.AppendLine("FALHOU  $($b.Caso) — esperado $($b.Esperado), obtido $($b.Obtido) · $($b.Mensagem)") } } else { [void]$failOut.AppendLine($log.TrimEnd()) }
    }
    $missing = if ($j.Expected -ge 0) { $j.Expected - $got.Count } elseif (-not $hasRes) { 1 } else { 0 }
    if ($missing -gt 0) {
        $nFail += $missing
        [void]$failOut.AppendLine("==== ${label}: $missing caso(s) não rodaram — o processo parou (exit $($j.Proc.ExitCode))")
        [void]$failOut.AppendLine($log.Substring([Math]::Max(0, $log.Length - 3000)).TrimEnd()); if ($err.Trim()) { [void]$failOut.AppendLine($err.Trim()) }
    }
    if ($j.Kind -eq 'check') { foreach ($g in $got) { $times[[string]$g.Caso] = [double]$g.Seg } }
    elseif ($hasRes) { $times[$j.TimeKey] = [Math]::Round($j.Watch.Elapsed.TotalSeconds, 1) }
}
# v3.65.0 (achado C3-R18 da revisão geral): a rodada inteira é a conferência antes do commit e inclui o C3 (release.ps1) —
# da v3.64.0 à v3.64.5 seis entregas saíram com o C3 vermelho (README na versão antiga) porque nada o rodava.
if ($doRelease) {
    $relOut = (& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $here '..\release.ps1') -Root $repo 2>&1 | Out-String)
    $nCases++
    if ($LASTEXITCODE -ne 0) { $nFail++; [void]$failOut.AppendLine("==== C3 (release.ps1) reprovou (exit $LASTEXITCODE)"); [void]$failOut.AppendLine($relOut.TrimEnd()) }
}
if ($slept -gt 0) { Say ("a máquina ficou suspensa ~{0:N0} s durante a rodada (tampa fechada ou espera): as falhas por TEMPO ESGOTADO podem ser dela, e os tempos desta rodada não foram gravados — refaça com a máquina acordada" -f $slept) }
else { try { New-Item -ItemType Directory -Force (Split-Path $timesP) | Out-Null; [System.IO.File]::WriteAllText($timesP, ($times | ConvertTo-Json -Compress), $u8) } catch { } }
if ($nFail -gt 0) { [void]$failOut.AppendLine("logs dos blocos: $run (apague depois de ler)") } else { Remove-Item -Recurse -Force $run -ErrorAction SilentlyContinue }
if ($failOut.Length) { Say $failOut.ToString().TrimEnd() }
foreach ($sl in @($rows | Sort-Object { [int]$_.Seg } -Descending | Select-Object -First 12)) { $sn = [string]$sl.Caso; Say ("lento: {0,5} s  {1}" -f $sl.Seg, $(if ($sn.Length -gt 110) { $sn.Substring(0, 110) } else { $sn })) }
foreach ($j in @($done | Sort-Object { $_.Watch.Elapsed.TotalSeconds } -Descending | Select-Object -First 12)) { Say ("bloco: {0,-9} {1,6:N0} s  {2}" -f $j.Name, $j.Watch.Elapsed.TotalSeconds, $(if ($j.Kind -eq 'guard') { "guardas · $($j.Title)" } else { "linhas $($j.Lines)" })) }
if ($tierLine) { Say $tierLine }
$mode = if ($Only) { " · -Only '$Only'" } elseif ($Changed) { " · -Changed ($($jobs.Count) bloco(s)/grupo(s); $chgOut de fora)" } elseif ($Full) { ' · -Full' } else { ' · sem o nível lento' }
Say ("parede: {0:N0} s com {1} processos em paralelo{2}" -f $wall.Elapsed.TotalSeconds, $Workers, $mode)
Say ("{0} casos · {1} falharam" -f $nCases, $nFail)
if ($nFail -gt 0) { Exit-Run 1 }
Exit-Run 0
