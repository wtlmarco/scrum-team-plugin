# Pré-voo do alvo de execução (v3.51, D3): confere se o alvo está pronto para rodar o app e, com -Repair, tenta consertar
# uma vez. Mesmo contrato para todos os alvos; um adaptador por tecnologia em targets/. Configuração em guards.json → targets.
# Uso (raiz do projeto): powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/target.ps1" -Target android [-Repair] [-Unlock]
#   android  emulador ou aparelho: conectado, iniciado, tela desenhando (captura com tamanho real), uiautomator respondendo,
#            tempo ligado abaixo de targets.android.maxUptimeHours · reparo: reinicia o AVD de targets.android.avd
#   web      site no ar (targets.web.health ou url) e Node instalado · reparo: sobe o servidor por targets.web.start
#   (api e desktop: próximo incremento)
# -Unlock apaga a trava de dono único (.team-project/.target-lock) deixada por um executor que caiu.
# Exit 0 = alvo pronto · 2 = erro de uso · 4 = FALHA DE AMBIENTE (o motivo e a ação na saída). Quem vê 4 não depura o app.

param(
    [Parameter(Mandatory = $true)][ValidateSet('android', 'web')][string]$Target,
    [switch]$Repair,
    [switch]$Unlock,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')

try {
    if ($Unlock) { $lp = Join-Path $Root '.team-project/.target-lock'; if (Test-Path -LiteralPath $lp) { Remove-Item -LiteralPath $lp -Force; [Console]::Out.WriteLine('target: trava removida') } }
    $targets = Get-TargetsConfig $Root
    $cfg = if ($targets -and $targets.PSObject.Properties[$Target]) { $targets.$Target } else { $null }
    if ($Target -eq 'android') { . (Join-Path $PSScriptRoot 'targets/android.ps1'); $init = Initialize-Android $cfg; $health = { Test-AndroidHealth }; $fix = { Repair-Android } }
    else {
        if (-not $cfg) { [Console]::Error.WriteLine('target: guards.json sem targets.web'); exit 2 }
        . (Join-Path $PSScriptRoot 'targets/web.ps1'); $init = Initialize-Web $cfg $Root; $health = { Test-WebHealth }; $fix = { Repair-Web }
    }
    if ($init) { [Console]::Out.WriteLine("target ${Target}: FALHA DE AMBIENTE — $init"); exit 4 }
    $lock = Enter-TargetLock $Root $Target "target.ps1 $Target"
    if ($lock) { [Console]::Out.WriteLine("target ${Target}: FALHA DE AMBIENTE — $lock"); exit 4 }
    try {
        $h = & $health
        if ($h -and $Repair) { [Console]::Out.WriteLine("target ${Target}: $h — tentando o reparo"); $h = & $fix }
    } finally { Exit-TargetLock $Root }
    if ($h) { [Console]::Out.WriteLine("target ${Target}: FALHA DE AMBIENTE — $h" + $(if (-not $Repair) { ' (rode com -Repair para tentar consertar)' } else { '' })); exit 4 }
    [Console]::Out.WriteLine("target ${Target}: pronto")
    exit 0
} catch {
    [Console]::Error.WriteLine("target: erro — $($_.Exception.Message)")
    exit 2
}
