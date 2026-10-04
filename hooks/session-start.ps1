# SessionStart — G13: autoteste de uma linha (estado do guards.json, guardas ativas e desativadas). Nunca bloqueia.

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

try {
    $hookInput = Read-HookInput
    $projectDir = Get-ProjectDir $hookInput
    if (-not (Test-Path -LiteralPath (Join-Path $projectDir '.team-project'))) { exit 0 }   # projeto sem o time: silêncio
    $cfg = Get-GuardConfig $projectDir
    if (-not (Test-GuardEnabled $cfg 'G13')) { exit 0 }

    $all = 'G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8', 'G9', 'G11'
    $on  = @($all | Where-Object { Test-GuardEnabled $cfg $_ })
    $off = @($all | Where-Object { -not (Test-GuardEnabled $cfg $_) })
    $line = "Guardas do time (hooks/COVERAGE.md): ativas " + ($(if ($on.Count) { $on -join ', ' } else { 'nenhuma' })) +
            "; desativadas " + ($(if ($off.Count) { $off -join ', ' } else { 'nenhuma' })) +
            "; guards.json " + $cfg.state + $(if ($cfg.probe) { '; sonda ligada' } else { '' }) + '.'
    if ($cfg.state -eq 'invalido') { $line += ' guards.json inválido: valem os padrões — corrija ou recrie a partir do modelo.' }
    [Console]::Out.Write($line)
    exit 0
} catch {
    exit 1
}
