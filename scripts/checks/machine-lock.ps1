# Trava de trabalho pesado da máquina (v3.64.0, item 7 B — decisão D6 do stakeholder em 18/11/2026), para scripts FORA do
# plugin: o script de um projeto que sobe emulador ou roda uma suíte longa por conta própria toma a mesma trava que o verify
# (suíte), o accept e o target.ps1 (boot e reparo do emulador) tomam. Trabalho pesado de projetos diferentes roda um por vez.
# Origem: sprint 6 do projeto piloto — às 19:21 outro projeto subiu um servidor do adb próprio e um emulador com GPU por
# software no meio da suíte do Karma; o emulador do piloto caiu e a suíte ficou 2,6× mais lenta.
#
# Uso (no script do projeto, antes do trabalho pesado):
#   powershell -NoProfile -File "<plugin>/scripts/checks/machine-lock.ps1" -Take -Owner "setup-android bench" [-WaitMin 30] [-Root <projeto>] [-HolderPid <pid>]
#   ... trabalho pesado ...
#   powershell -NoProfile -File "<plugin>/scripts/checks/machine-lock.ps1" -Release [-HolderPid <pid>]
#   powershell -NoProfile -File "<plugin>/scripts/checks/machine-lock.ps1" -Who
# -HolderPid: o processo que segura a trava (padrão: quem chamou este script). A trava vale enquanto ele vive; morto, ela é
#   de quem vier. Dentro do mesmo projeto (-Root) a trava é reentrante.
# Exit: 0 tomada / solta / livre (-Who) · 3 ocupada por outro projeto depois do prazo (a linha diz quem) · 2 uso.
param(
    [switch]$Take,
    [switch]$Release,
    [switch]$Who,
    [string]$Owner = '',
    [double]$WaitMin = -1,
    [int]$HolderPid = 0,
    [string]$Root = (Get-Location).Path
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
if (@($Take, $Release, $Who | Where-Object { $_ }).Count -ne 1) { [Console]::Error.WriteLine('machine-lock: use um de -Take, -Release ou -Who.'); exit 2 }
if (-not $HolderPid) { try { $HolderPid = [int](Get-CimInstance Win32_Process -Filter "ProcessId=$PID" -ErrorAction Stop).ParentProcessId } catch { $HolderPid = $PID } }
$Root = ([string]$Root).TrimEnd('\', '/')
if ($Who) {
    $p = Get-HeavyLockPath
    $l = $null; if (Test-Path -LiteralPath $p) { try { $l = Read-Text $p | ConvertFrom-Json } catch { } }
    if ($l -and (Test-TargetLockHolderAlive $l)) { [Console]::Out.WriteLine("machine-lock: em uso por '$([string]$l.owner)' de $([string]$l.root) (PID $([int]$l.pid), desde $([string]$l.desde))") }
    else { [Console]::Out.WriteLine('machine-lock: livre') }
    exit 0
}
if ($Release) { Exit-HeavyLock $HolderPid; [Console]::Out.WriteLine("machine-lock: solta (PID $HolderPid)"); exit 0 }
if (-not $Owner) { [Console]::Error.WriteLine('machine-lock: -Take pede -Owner <quem> (aparece para os outros projetos).'); exit 2 }
$b = Wait-HeavyLock $Root $Owner $WaitMin $HolderPid
if ($b) { [Console]::Out.WriteLine("machine-lock: ocupada — $b"); exit 3 }
[Console]::Out.WriteLine("machine-lock: tomada por '$Owner' (PID $HolderPid, projeto $Root)")
exit 0
