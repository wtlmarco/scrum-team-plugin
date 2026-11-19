# Sentinela do prazo por caso — v3.64.1. A suíte (run-check-tests.ps1, inteira ou num bloco do run-all-tests.ps1) a sobe no
# preâmbulo. A cada 3 s, o processo filho da suíte que passou de -TimeoutSec tem a árvore encerrada (taskkill /T /F) e ganha
# uma linha em -Log; o Invoke-Check vê a linha nova e marca o caso como TEMPO ESGOTADO. Sai sozinha quando a suíte acaba.
# Origem: um verify full de caso ficou 29 min esperando a rodada desprendida e segurou a suíte inteira (19/11/2026).
param([int]$Parent, [int]$TimeoutSec = 240, [string]$Log)
$ErrorActionPreference = 'SilentlyContinue'
while ($true) {
    if (-not (Get-Process -Id $Parent -ErrorAction SilentlyContinue)) { exit 0 }
    $now = Get-Date
    foreach ($c in @(Get-CimInstance Win32_Process -Filter "ParentProcessId=$Parent")) {
        if ([int]$c.ProcessId -eq $PID -or -not $c.CreationDate) { continue }
        # O console da suíte (conhost.exe) é filho dela e vive o tempo todo: encerrá-lo derruba a própria suíte.
        if ([string]$c.Name -in 'conhost.exe', 'WerFault.exe') { continue }
        $age = ($now - $c.CreationDate).TotalSeconds
        if ($age -lt $TimeoutSec) { continue }
        $cl = [string]$c.CommandLine; if ($cl.Length -gt 300) { $cl = $cl.Substring(0, 300) + '…' }
        [System.IO.File]::AppendAllText($Log, ("{0} · pid {1} · {2:N0} s · {3}`r`n" -f $now.ToString('HH:mm:ss'), $c.ProcessId, $age, $cl), (New-Object System.Text.UTF8Encoding($false)))
        & taskkill.exe /PID $c.ProcessId /T /F 2>&1 | Out-Null
    }
    Start-Sleep -Seconds 3
}
