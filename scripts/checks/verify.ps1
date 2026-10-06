# Evidência mecânica (v3.45.1, R7 · R28): roda os comandos de verificação do projeto (guards.json → verify), grava o log
# de cada um em disco e o resultado — comando, código de saída real, linhas decisivas, duração — em
# .team-project/verify/<sprint|B-nnn>/<ID>/result.json, amarrado à IMPRESSÃO DIGITAL da árvore de trabalho (o tree do git
# com tudo o que está no disco, novo não rastreado incluído). Mesma impressão = mesmo código: quem confere não reexecuta.
# Uso (a partir da raiz do projeto; timeout da ferramenta 600000 ms):
#   powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/verify.ps1" -Task T-041 -Mode focused -Tests <arquivos de teste>
#   … -Mode full     build, lint, suite e coverage configurados — no fim do bloco ou da Task (dev) e quando a árvore mudou (QA)
#   … -Mode check    só compara a árvore de agora com a do último full; não roda nada (QA, sessão, C1)
# Saída: ~10 linhas (o log fica no disco). Exit 0 = tudo com código 0 (check: árvore igual e full verde) · 1 = algum
# comando falhou, árvore diferente ou sem full · 2 = erro de uso (sem guards.json → verify, sem git).

param(
    [Parameter(Mandatory = $true)][string]$Task,
    [ValidateSet('focused', 'full', 'check')][string]$Mode = 'full',
    [string[]]$Tests = @(),
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

function Get-Decisive([string]$Log) {
    $lines = @([System.IO.File]::ReadAllLines($Log, $utf8))
    $hit = @($lines | Where-Object { $_ -match '(?i)\b(pass(ed|ing)?|fail(ed|ures?)?|errors?|warnings?|tests?|total|coverage|cobertura|threshold)\b|\d+(\.\d+)?\s*%' } | Select-Object -Last 4)
    if ($hit.Count -eq 0) { $hit = @($lines | Where-Object { $_.Trim() } | Select-Object -Last 2) }
    return @{ Lines = $lines.Count; Decisive = @($hit | ForEach-Object { $t = $_.Trim(); if ($t.Length -gt 200) { $t.Substring(0, 200) + '…' } else { $t } }) }
}

try {
    $tp = Join-Path $Root '.team-project'
    $cfgPath = Join-Path $tp 'guards.json'
    if (-not (Test-Path -LiteralPath $cfgPath)) { [Console]::Error.WriteLine("verify: $cfgPath não existe — rode na raiz do projeto ou passe -Root."); exit 2 }
    $cfg = Read-Text $cfgPath | ConvertFrom-Json
    $verify = $cfg.verify
    $dir = Get-VerifyDir $Root $Task
    $resPath = Join-Path $dir 'result.json'
    $prev = $null
    if (Test-Path -LiteralPath $resPath) { try { $prev = Read-Text $resPath | ConvertFrom-Json } catch { } }

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
    $plan = if ($Mode -eq 'focused') { @('focused', 'lint') } else { @('build', 'lint', 'suite', 'coverage') }
    $jobs = @()
    foreach ($k in $plan) { $i = 0; foreach ($c in (Get-Commands $verify $k)) { $i++; $jobs += @{ Key = $(if ($i -gt 1) { "$k$i" } else { $k }); Cmd = $c } } }
    if ($Mode -eq 'focused') {
        if (-not ($jobs | Where-Object { $_.Key -like 'focused*' })) { [Console]::Error.WriteLine('verify: guards.json → verify sem "focused" (o comando do teste focado, com {tests}).'); exit 2 }
        if ($Tests.Count -eq 0) { [Console]::Error.WriteLine('verify: -Mode focused pede -Tests <arquivos de teste do bloco>.'); exit 2 }
    } elseif ($jobs.Count -eq 0) { [Console]::Error.WriteLine('verify: guards.json → verify sem build, lint, suite nem coverage.'); exit 2 }

    New-Item -ItemType Directory -Force $dir | Out-Null
    $results = @()
    foreach ($j in $jobs) {
        $cmd = $j.Cmd.Replace('{tests}', (($Tests | ForEach-Object { if ($_ -match '\s') { "'$_'" } else { $_ } }) -join ' '))
        $log = Join-Path $dir "$Mode-$($j.Key).log"
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        # Código de saída real: o do último comando nativo; cmdlet que falha sem código = 1 (contrato do operator, item 2).
        $wrapped = '$global:LASTEXITCODE = 0; ' + $cmd + '; if (-not $?) { if ($LASTEXITCODE) { exit $LASTEXITCODE } else { exit 1 } }; exit $LASTEXITCODE'
        $enc = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($wrapped))   # aspas do comando passam intactas
        $p = Start-Process -FilePath 'powershell' -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-EncodedCommand', $enc) -WorkingDirectory $Root -RedirectStandardOutput $log -RedirectStandardError "$log.err" -NoNewWindow -PassThru -Wait
        $code = $p.ExitCode
        if (Test-Path -LiteralPath "$log.err") { $err = [System.IO.File]::ReadAllText("$log.err", $utf8); if ($err) { [System.IO.File]::AppendAllText($log, $err, $utf8) }; Remove-Item -LiteralPath "$log.err" -Force }
        [System.IO.File]::AppendAllText($log, "`nEXIT=$code`n", $utf8)
        $d = Get-Decisive $log
        $results += [ordered]@{ key = $j.Key; command = $cmd; exit = $code; seconds = [int]$sw.Elapsed.TotalSeconds; log = ($log.Substring($Root.Length + 1) -replace '\\', '/'); lines = $d.Lines; decisive = $d.Decisive }
    }
    $after = Get-WorkTree $Root
    $run = [ordered]@{ at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); tree = $tree; tree_after = $after; tests = $Tests; commands = $results }

    $res = [ordered]@{ task = $Task; full = $null; focused = $null; mutation = $null }
    if ($prev) { foreach ($k in 'full', 'focused', 'mutation') { if ($prev.PSObject.Properties[$k]) { $res[$k] = $prev.$k } } }
    $res[$Mode] = $run
    [System.IO.File]::WriteAllText($resPath, ($res | ConvertTo-Json -Depth 8), $utf8)

    $bad = @($results | Where-Object { [int]$_.exit -ne 0 })
    [Console]::Out.WriteLine("verify $Mode $Task · árvore $($tree.Substring(0, 12)) · " + $(if ($bad.Count) { "$($bad.Count) comando(s) com falha" } else { 'tudo exit 0' }) + " · $($resPath.Substring($Root.Length + 1) -replace '\\', '/')")
    foreach ($r in $results) { [Console]::Out.WriteLine("  $($r.key): exit $($r.exit) · $($r.seconds) s · $(@($r.decisive) | Select-Object -Last 1) · log $($r.log) ($($r.lines) linhas)") }
    if ($after -ne $tree) { [Console]::Out.WriteLine("  atenção: os comandos alteraram a árvore (antes $($tree.Substring(0, 12)), depois $(([string]$after).Substring(0, [Math]::Min(12, ([string]$after).Length)))) — arquivo gerado fora do .gitignore; a evidência vale para a árvore de antes") }
    if ($bad.Count) { exit 1 }
    exit 0
} catch {
    [Console]::Error.WriteLine("verify: erro — $($_.Exception.Message)")
    exit 2
}
