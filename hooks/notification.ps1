# Notification (permission_prompt) — G15 (v3.44): todo pedido de permissão do harness vira linha no guards.log,
# com o texto da mensagem. É o rastro que faltava para a R27: pedido sem resposta trava o papel e não deixava registro.
# Só registra; nunca bloqueia. Qualquer exceção → exit 1 (falha aberta, D5). Cobertura e limites: hooks/COVERAGE.md.

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

try {
    $hookInput = Read-HookInput
    if ($null -eq $hookInput) { exit 0 }
    $projectDir = Get-ProjectDir $hookInput
    $cfg = Get-GuardConfig $projectDir
    if (-not (Test-GuardEnabled $cfg 'G15')) { exit 0 }
    $type = [string]$hookInput.notification_type
    if ($type -and $type -ne 'permission_prompt') { exit 0 }
    $run = Get-Marker $projectDir '.active-run'
    $ctx = if ($null -ne $run) { "run ativo: $([string]$run.trilha) $([string]$run.id)" } else { 'sem run ativo' }
    Write-GuardLog $projectDir 'G15' $hookInput 'permissão' ("pedido de permissão do harness ($ctx): " + [string]$hookInput.message)
    exit 0
} catch {
    exit 1
}
