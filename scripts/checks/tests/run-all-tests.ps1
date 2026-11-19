# Roda as duas suítes do plugin em paralelo — v3.64.1. A suíte de conferências (run-check-tests.ps1) é dividida em blocos
# independentes (suite-blocks.ps1), e cada bloco roda num processo próprio, com o seu $tmp. A suíte de guardas
# (run-guard-tests.ps1) roda inteira ao lado, porque os casos dela dividem o mesmo projeto falso. Cada chamada de script de
# um caso tem prazo (-CheckTimeoutSec): passou dele, a árvore do processo é encerrada e o caso falha com "TEMPO ESGOTADO".
# Antes, um verify preso segurou a suíte por 29 min.
#
# Uso (na raiz do repositório-fonte):
#   powershell -NoProfile -File scripts/checks/tests/run-all-tests.ps1                  # tudo, em paralelo
#   powershell -NoProfile -File scripts/checks/tests/run-all-tests.ps1 -Only 'portão|G14' # só os blocos com caso que casa
#   -Workers <n> (padrão: núcleos − 1, de 2 a 8) · -CheckTimeoutSec <s> (padrão 240) · -Suites check,guard · -ListBlocks
# Sem -Only, roda tudo: é a conferência antes do commit. Com -Only, os blocos com algum caso cujo nome casa (regex), e a
# suíte de guardas só se algum caso dela casar (ela roda inteira: os casos dependem dos anteriores).
# Os tempos de cada bloco ficam em %LOCALAPPDATA%\team-plugin\test-times.json e equilibram os blocos da próxima rodada.
# Saída: as falhas (com a saída do caso), os 12 mais lentos, o tempo de parede e "N casos · F falharam"; exit 1 com falha.
param(
    [string]$Only = '',
    [int]$Workers = 0,
    [int]$CheckTimeoutSec = 240,
    [string[]]$Suites = @('check', 'guard'),
    [switch]$ListBlocks
)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
. (Join-Path $here 'suite-blocks.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($true)
$wall = [System.Diagnostics.Stopwatch]::StartNew()
if ($Workers -le 0) { $Workers = [Math]::Max(2, [Math]::Min(8, [Environment]::ProcessorCount - 1)) }
$env:TEAM_TEST_CHECK_TIMEOUT_S = [string]$CheckTimeoutSec   # os blocos e a suíte de guardas herdam
$Suites = @($Suites | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim().ToLowerInvariant() } | Where-Object { $_ })
$run = Join-Path ([System.IO.Path]::GetTempPath()) ('team-all-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force $run | Out-Null
$timesP = Join-Path $(if ($env:LOCALAPPDATA) { $env:LOCALAPPDATA } else { [System.IO.Path]::GetTempPath() }) 'team-plugin\test-times.json'
$times = @{}
if (Test-Path -LiteralPath $timesP) { try { foreach ($pp in (Get-Content -LiteralPath $timesP -Raw -Encoding UTF8 | ConvertFrom-Json).PSObject.Properties) { $times[$pp.Name] = [double]$pp.Value } } catch { } }

# ---------- os blocos da suíte de conferências ----------
$jobs = @()
if ($Suites -contains 'check') {
    $sf = Join-Path $here 'run-check-tests.ps1'
    $su = Get-SuiteUnits $sf
    $units = @($su.Units)
    if ($Only) { $units = @($units | Where-Object { @($_.Checks | Where-Object { $_ -match $Only }).Count }) }
    $w = { param($u) $s = 0.0; foreach ($c in $u.Checks) { $s += $(if ($times.ContainsKey($c)) { $times[$c] } else { 4.0 }) }; if (-not $u.Checks.Count) { $s = 1.0 }; $s }
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
        $bf = Join-Path $here ".bloco-$bi-$([guid]::NewGuid().ToString('N').Substring(0, 6)).ps1"   # ao lado da suíte: $PSScriptRoot igual
        [System.IO.File]::WriteAllText($bf, $body.ToString(), $utf8)
        $jobs += [pscustomobject]@{ Name = "check-$bi"; File = $bf; Result = $res; Log = (Join-Path $run "check-$bi.log"); Units = @($bk); Weight = (($bk | ForEach-Object { & $w $_ }) | Measure-Object -Sum).Sum; Lines = "$($bk[0].From)–$($bk[-1].To)"; Proc = $null; Watch = $null }
    }
}
if ($Suites -contains 'guard') {
    $gf = Join-Path $here 'run-guard-tests.ps1'
    $gNames = @([regex]::Matches([System.IO.File]::ReadAllText($gf, [System.Text.Encoding]::UTF8), "@\{ Name = '((?:[^']|'')*)'") | ForEach-Object { $_.Groups[1].Value -replace "''", "'" })
    if (-not $Only -or @($gNames | Where-Object { $_ -match $Only }).Count) {
        $jobs = @([pscustomobject]@{ Name = 'guard'; File = $gf; Result = ''; Log = (Join-Path $run 'guard.log'); Units = @(); Weight = 1e9; Lines = 'inteira'; Proc = $null; Watch = $null }) + $jobs
    }
}
if ($ListBlocks) {
    foreach ($j in $jobs) { Write-Output ("{0,-9} linhas {1,-11} peso {2,7:N0} s  casos {3}" -f $j.Name, $j.Lines, $(if ($j.Name -eq 'guard') { 0 } else { $j.Weight }), $(if ($j.Name -eq 'guard') { $gNames.Count } else { (@($j.Units | ForEach-Object { $_.Checks }) ).Count })) }
    foreach ($j in $jobs) { if ($j.Name -ne 'guard') { Remove-Item -LiteralPath $j.File -Force -ErrorAction SilentlyContinue } }
    Remove-Item -Recurse -Force $run -ErrorAction SilentlyContinue
    exit 0
}
if (-not $jobs.Count) { Remove-Item -Recurse -Force $run -ErrorAction SilentlyContinue; Write-Output "nenhum caso casa com -Only '$Only'"; exit 1 }

# ---------- o pool: no máximo $Workers processos, o mais pesado primeiro ----------
$queue = New-Object System.Collections.Queue
foreach ($j in @($jobs | Sort-Object Weight -Descending)) { $queue.Enqueue($j) }
$running = @(); $done = @()
while ($queue.Count -or $running.Count) {
    while ($queue.Count -and $running.Count -lt $Workers) {
        $j = $queue.Dequeue()
        $j.Watch = [System.Diagnostics.Stopwatch]::StartNew()
        # A suíte de guardas sai pela página OEM se ninguém fixa o UTF-8 — o resumo "N casos · F falharam" não casaria.
        $argv = if ($j.Name -eq 'guard') { @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', "[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding(`$false); & '$($j.File)'; exit `$LASTEXITCODE") } else { @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $j.File) }
        $j.Proc = Start-Process powershell -WindowStyle Hidden -PassThru -RedirectStandardOutput $j.Log -RedirectStandardError ($j.Log + '.err') -ArgumentList $argv
        $null = $j.Proc.Handle   # sem o handle guardado, o ExitCode do processo de Start-Process volta vazio
        $running += $j
    }
    Start-Sleep -Milliseconds 500
    foreach ($j in @($running | Where-Object { $_.Proc.HasExited })) { $j.Watch.Stop(); $running = @($running | Where-Object { $_ -ne $j }); $done += $j }
}

# ---------- o resultado ----------
$rows = @(); $failOut = New-Object System.Text.StringBuilder; $nCases = 0; $nFail = 0
foreach ($j in $done) {
    $log = if (Test-Path -LiteralPath $j.Log) { [System.IO.File]::ReadAllText($j.Log, [System.Text.Encoding]::UTF8) } else { '' }
    $err = if (Test-Path -LiteralPath ($j.Log + '.err')) { [System.IO.File]::ReadAllText($j.Log + '.err', [System.Text.Encoding]::UTF8) } else { '' }
    if ($j.Name -eq 'guard') {
        $m = [regex]::Match($log, '(\d+) casos · (\d+) falharam')
        if ($m.Success) { $nCases += [int]$m.Groups[1].Value; $nFail += [int]$m.Groups[2].Value; if ([int]$m.Groups[2].Value) { [void]$failOut.AppendLine("==== guardas ($([int]$m.Groups[2].Value) falharam)"); foreach ($l in ($log -split "`r?`n" | Where-Object { $_ -match 'FALHOU' })) { [void]$failOut.AppendLine($l) } } }
        else { $nFail++; [void]$failOut.AppendLine("==== guardas: a suíte não terminou (exit $($j.Proc.ExitCode))`n$($log.Substring([Math]::Max(0, $log.Length - 2000)))`n$err") }
        continue
    }
    Remove-Item -LiteralPath $j.File -Force -ErrorAction SilentlyContinue
    $expected = @($j.Units | ForEach-Object { $_.Checks }).Count
    $got = @(); $bf = 0
    if (Test-Path -LiteralPath $j.Result) { try { $rj = Get-Content -LiteralPath $j.Result -Raw -Encoding UTF8 | ConvertFrom-Json; $got = @($rj.rows | ForEach-Object { $_ }); $bf = [int]$rj.fail } catch { } }
    $rows += $got; $nCases += $got.Count
    $bad = @($got | Where-Object { $_.Ok -ne 'ok' })
    $bf = [Math]::Max($bf, $bad.Count)   # o $fail do bloco conta também a falha que não passa pelo Check (caso 1)
    $nFail += $bf
    if ($bf) { [void]$failOut.AppendLine("==== $($j.Name) (linhas $($j.Lines)): $bf falharam"); [void]$failOut.AppendLine($log.TrimEnd()) }
    if ($got.Count -lt $expected) {
        $nFail += ($expected - $got.Count)
        [void]$failOut.AppendLine("==== $($j.Name) (linhas $($j.Lines)): $($expected - $got.Count) caso(s) não rodaram — o bloco parou (exit $($j.Proc.ExitCode))")
        [void]$failOut.AppendLine($log.Substring([Math]::Max(0, $log.Length - 3000)).TrimEnd()); if ($err.Trim()) { [void]$failOut.AppendLine($err.Trim()) }
    }
    foreach ($g in $got) { $times[[string]$g.Caso] = [double]$g.Seg }
}
try { New-Item -ItemType Directory -Force (Split-Path $timesP) | Out-Null; [System.IO.File]::WriteAllText($timesP, ($times | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false))) } catch { }
if ($nFail -gt 0) { [void]$failOut.AppendLine("logs dos blocos: $run (apague depois de ler)") } else { Remove-Item -Recurse -Force $run -ErrorAction SilentlyContinue }
if ($failOut.Length) { Write-Output $failOut.ToString().TrimEnd() }
foreach ($sl in @($rows | Sort-Object { [int]$_.Seg } -Descending | Select-Object -First 12)) { $sn = [string]$sl.Caso; Write-Output ("lento: {0,5} s  {1}" -f $sl.Seg, $(if ($sn.Length -gt 110) { $sn.Substring(0, 110) } else { $sn })) }
foreach ($j in @($done | Sort-Object { $_.Watch.Elapsed.TotalSeconds } -Descending)) { Write-Output ("bloco: {0,-9} {1,6:N0} s  linhas {2}" -f $j.Name, $j.Watch.Elapsed.TotalSeconds, $j.Lines) }
Write-Output ("parede: {0:N0} s com {1} processos em paralelo{2}" -f $wall.Elapsed.TotalSeconds, $Workers, $(if ($Only) { " · -Only '$Only'" } else { '' }))
Write-Output ("{0} casos · {1} falharam" -f $nCases, $nFail)
if ($nFail -gt 0) { exit 1 }
exit 0
