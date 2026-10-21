# Stop — G20 (v3.51, proposta a das paradas do run): durante o sprint run, a sessão não encerra o turno com Task elegível
# no quadro. Paradas legítimas (sprint-run.md §Ordem da fila): fim da fila → formulário da Review · bloqueio sem elegível
# · pré-condição falha · interrupção do stakeholder — em todas a sessão apaga o .active-run antes. Esperar agente em
# segundo plano também não é parada: a notificação reabre a sessão (.active-agents, gravado pela PreToolUse).
# Medido no piloto: 4 paradas fora do contrato e ~24,5 h de fila parada. Exit 2 devolve o motivo à sessão, que continua.
# Qualquer exceção → exit 1 (falha aberta, D5). Cobertura e limites: hooks/COVERAGE.md.

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

try {
    $hookInput = Read-HookInput
    if ($null -eq $hookInput) { exit 0 }
    $projectDir = Get-ProjectDir $hookInput
    $tp = Join-Path $projectDir '.team-project'
    if (-not (Test-Path -LiteralPath $tp)) { exit 0 }
    $cfg = Get-GuardConfig $projectDir
    if (-not (Test-GuardEnabled $cfg 'G20')) { exit 0 }
    $run = Get-Marker $projectDir '.active-run'
    if ($null -eq $run -or [string]$run.trilha -ne 'sprint') { exit 0 }   # v1: só a trilha sprint

    # Laço: o Claude Code já continua por causa de um bloqueio anterior. Da 3ª vez em 10 min, libera e registra.
    if ($hookInput.stop_hook_active -eq $true) {
        $log = Join-Path $tp 'guards.log'; $recent = 0
        if (Test-Path -LiteralPath $log) {
            $lim = (Get-Date).AddMinutes(-10)
            foreach ($l in (Get-Content -LiteralPath $log -Encoding UTF8 -Tail 50)) { if ($l -match 'G20' -and $l -match 'bloqueio') { $m = [regex]::Match($l, '(\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}(:\d{2})?)'); if ($m.Success) { try { if ([datetime]::Parse($m.Groups[1].Value) -ge $lim) { $recent++ } } catch { } } } }
        }
        if ($recent -ge 3) { Write-GuardLog $projectDir 'G20' $hookInput '' 'liberado após 3 bloqueios'; exit 0 }
    }
    # Espera legítima por agente em segundo plano (menos de 3 h; mais velho é resto de queda).
    $agents = @(Get-ActiveAgents $projectDir | Where-Object { try { ((Get-Date) - [datetime]::Parse([string]$_.desde)).TotalHours -lt 3 } catch { $false } })
    if ($agents.Count) { exit 0 }
    # Turno do toque de cache.
    $tr = [string]$hookInput.transcript_path
    if ($tr -and (Test-Path -LiteralPath $tr)) {
        $lastUser = $null
        foreach ($l in (Get-Content -LiteralPath $tr -Encoding UTF8 -Tail 40)) { if ($l -match '"type":"user"') { $lastUser = $l } }
        if ($lastUser -and $lastUser -match '\[toque de cache\]') { exit 0 }
    }

    # Task elegível: ⬜ (ou 🟦/🟨/🟪 em voo) com as dependências todas ✅.
    $board = Join-Path $tp "sprints/$([string]$run.id)/sprint-backlog.md"
    if (-not (Test-Path -LiteralPath $board)) { exit 0 }
    $done = [char]::ConvertFromUtf32(0x2705)
    $open = @([char]::ConvertFromUtf32(0x2B1C), [char]::ConvertFromUtf32(0x1F7E6), [char]::ConvertFromUtf32(0x1F7E8), [char]::ConvertFromUtf32(0x1F7EA))
    $rows = @(); $header = $null
    foreach ($line in (Get-Content -LiteralPath $board -Encoding UTF8)) {
        if (-not $line.TrimStart().StartsWith('|')) { $header = $null; continue }
        $cells = @($line.Trim().Trim('|') -split '\|' | ForEach-Object { $_.Trim() })
        if ($cells[0] -eq 'ID') { $header = $cells; continue }
        if (-not $header -or $line -match '^\s*\|[\s:\-|]+\|\s*$') { continue }
        $id = [regex]::Match($cells[0], '[A-Z]+-\d+[a-z]?').Value; if (-not $id) { continue }
        $di = [array]::IndexOf($header, ($header | Where-Object { $_ -like 'Depende*' } | Select-Object -First 1))
        $rows += [pscustomobject]@{ Id = $id; Cell = $cells[0]; Deps = $(if ($di -ge 0 -and $di -lt $cells.Count) { @([regex]::Matches($cells[$di], '[A-Z]+-\d+[a-z]?') | ForEach-Object { $_.Value }) } else { @() }) }
    }
    $closed = @($rows | Where-Object { $_.Cell.Contains($done) } | ForEach-Object { $_.Id })
    $eligible = @($rows | Where-Object { $c = $_.Cell; ($open | Where-Object { $c.Contains($_) }).Count -gt 0 -and @($_.Deps | Where-Object { $closed -notcontains $_ }).Count -eq 0 })
    if (-not $eligible.Count) { exit 0 }
    $t = $eligible[0]
    Write-GuardLog $projectDir 'G20' $hookInput $t.Id 'bloqueio: fim de turno com Task elegível'
    [Console]::Error.WriteLine("[G20] O sprint run está em andamento (.active-run, sprint $([string]$run.id)) e a Task $($t.Id) está elegível. Encerrar o turno aqui não é parada legítima (sprint-run.md §Ordem da fila): siga — run.ps1 next. Só encerre por (a) fim da fila → formulário de autorização da Review, (b) Task marcada 🔴 sem elegível restante → formulário de R22, (c) pré-condição falha, (d) interrupção do stakeholder — nesses casos apague o .active-run antes. Esperando agente em segundo plano? A notificação reabre a sessão.")
    exit 2
} catch {
    exit 1
}
