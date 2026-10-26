# Stop — G20 (v3.51, proposta a das paradas do run): durante o sprint run, a sessão não encerra o turno com Task elegível
# no quadro. Paradas legítimas (sprint-run.md §Ordem da fila): fim da fila → formulário da Review · bloqueio sem elegível
# · pré-condição falha · interrupção do stakeholder — em todas a sessão apaga o .active-run antes. v3.52: ponto seguro
# (.safe-point, Task recém-fechada) também libera, sem apagar o .active-run — a sessão curta por Task (R29). Esperar agente
# também não é parada: a notificação reabre a sessão (.active-agents, gravado pela PreToolUse). v3.52.2 (note.md item 2): todo
# agente é assíncrono — vale qualquer agente desta sessão, sem olhar "bg".
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
    # Espera legítima por agente em voo. v3.52.2 (note.md item 2): o Agent não tem mais run_in_background — toda chamada volta
    # "lançado" e o aviso reabre a sessão; o filtro "bg" barrava a espera (195 G20 no sprint 3 do piloto). Vale QUALQUER agente
    # disparado nesta sessão (session = session_id do hook; registro antigo sem session também) com sinal de vida há menos de
    # 3 h (mais velho é resto de queda); agente de outra sessão não segura o turno.
    $sid = [string]$hookInput.session_id
    $agents = @(Get-ActiveAgents $projectDir | Where-Object { $s = if ($_.PSObject.Properties['session']) { [string]$_.session } else { '' }; -not $s -or -not $sid -or $s -eq $sid } | Where-Object { (Get-AgentIdleHours $_) -lt 3 })
    if ($agents.Count) { exit 0 }
    $tr = [string]$hookInput.transcript_path
    # v3.51.4 (note.md itens 2, 6 e 11): o turno acabou por limite de uso da conta (resposta sintética do harness) — não é
    # parada fora do contrato e "siga" não adianta: grava o sinal .usage-limit, registra e libera. Erro de API sintético
    # sem ser limite também libera (a retomada é da sessão seguinte).
    $limit = Get-LimitFromTranscript $tr
    if ($limit) {
        $item = ''; $ag = @(Get-ActiveAgents $projectDir | Select-Object -First 1); if ($ag.Count -and $ag[0].work) { $item = [string]$ag[0].work }
        Set-LimitMarker $projectDir $limit 'sessão' $item
        Write-GuardLog $projectDir 'G20' $hookInput '' "liberado: limite de uso da conta — $limit (sinal em .team-project/.usage-limit)"
        exit 0
    }
    if (Test-Path -LiteralPath (Join-Path $tp '.usage-limit')) { exit 0 }   # run parado por limite: a retomada passa pelo run.ps1 next
    # v3.52 (R29, parada (f)): o run.ps1 done que fechou a Task grava .safe-point — fim de Task é parada permitida; a próxima
    # sessão retoma pelo .active-run e o run.ps1 next. O próximo start apaga o marcador (Task em voo volta a ser barrada).
    $sp = Get-Marker $projectDir '.safe-point'
    if ($null -ne $sp) { Write-GuardLog $projectDir 'G20' $hookInput ([string]$sp.task) 'liberado: ponto seguro (Task fechada; a próxima sessão retoma pelo run.ps1 next)'; exit 0 }
    if ($tr -and (Test-Path -LiteralPath $tr)) {
        $tail = @(Get-Content -LiteralPath $tr -Encoding UTF8 -Tail 40)
        $lastAsst = @($tail | Where-Object { $_ -match '"type":"assistant"' } | Select-Object -Last 1)
        if ($lastAsst.Count -and ($lastAsst[0] -match '<synthetic>' -or $lastAsst[0] -match '"isApiErrorMessage":true')) { Write-GuardLog $projectDir 'G20' $hookInput '' 'liberado: o turno acabou em erro de API (resposta sintética)'; exit 0 }
        # Turno do toque de cache.
        $lastUser = $null
        foreach ($l in $tail) { if ($l -match '"type":"user"') { $lastUser = $l } }
        if ($lastUser -and $lastUser -match '\[toque de cache\]') { exit 0 }
    }

    # Task elegível: ⬜ (ou 🟦/🟨/🟪 em voo) com as dependências todas ✅.
    $board = Join-Path $tp "sprints/$([string]$run.id)/sprint-backlog.md"
    if (-not (Test-Path -LiteralPath $board)) { exit 0 }
    $done = [char]::ConvertFromUtf32(0x2705)
    $open = @([char]::ConvertFromUtf32(0x2B1C), [char]::ConvertFromUtf32(0x1F7E6), [char]::ConvertFromUtf32(0x1F7E8), [char]::ConvertFromUtf32(0x1F7EA))
    $rows = @(); $header = $null; $inTasks = $false
    $idRe = 'Q-S\d+[a-z]?|[A-Z]+-\d+[a-z]?'   # v3.52.2 (C5): Q-S<n> antes — "[A-Z]+-\d+" não casa "Q-S3"
    foreach ($line in (Get-Content -LiteralPath $board -Encoding UTF8)) {
        # v3.51.4: só as tabelas sob "## História …" ou "## Habilitadora …" (mesma regra do Get-SprintTasks, garden item 20).
        # v3.52.2 (note.md item 15): e "## Correção do portão — sprint <n>", com IDs Q-S<n>[a-z]?.
        if ($line -match '^##\s') { $inTasks = $line -match '^##\s+(Hist[oó]ria\s+H-|(?i)habilitadora|(?i)corre[çc][ãa]o do port[ãa]o)'; $header = $null; continue }
        if (-not $line.TrimStart().StartsWith('|')) { $header = $null; continue }
        if (-not $inTasks) { continue }
        $cells = @($line.Trim().Trim('|') -split '\|' | ForEach-Object { $_.Trim() })
        if ($cells[0] -eq 'ID') { $header = $cells; continue }
        if (-not $header -or $line -match '^\s*\|[\s:\-|]+\|\s*$') { continue }
        $id = [regex]::Match($cells[0], $idRe).Value; if (-not $id) { continue }
        $di = [array]::IndexOf($header, ($header | Where-Object { $_ -like 'Depende*' } | Select-Object -First 1))
        $rows += [pscustomobject]@{ Id = $id; Cell = $cells[0]; Deps = $(if ($di -ge 0 -and $di -lt $cells.Count) { @([regex]::Matches($cells[$di], $idRe) | ForEach-Object { $_.Value }) } else { @() }) }
    }
    $closed = @($rows | Where-Object { $_.Cell.Contains($done) } | ForEach-Object { $_.Id })
    $eligible = @($rows | Where-Object { $c = $_.Cell; ($open | Where-Object { $c.Contains($_) }).Count -gt 0 -and @($_.Deps | Where-Object { $closed -notcontains $_ }).Count -eq 0 })
    if (-not $eligible.Count) { exit 0 }
    $t = $eligible[0]
    Write-GuardLog $projectDir 'G20' $hookInput $t.Id 'bloqueio: fim de turno com Task elegível'
    [Console]::Error.WriteLine("[G20] O sprint run está em andamento (.active-run, sprint $([string]$run.id)) e a Task $($t.Id) está elegível. Encerrar o turno aqui não é parada legítima (sprint-run.md §Ordem da fila): siga — rode run.ps1 next e faça a PRÓXIMA AÇÃO que ele imprimir (dev de volta: run.ps1 done -Task <ID> -Result ok|gap|env). Só encerre por (a) fim da fila → formulário de autorização da Review, (b) Task marcada 🔴 sem elegível restante → formulário de R22, (c) pré-condição falha, (d) interrupção do stakeholder, (e) pausa pedida pelo stakeholder entre Tasks (sprint-run.md §Pausa segura) — nesses casos apague o .active-run antes; (f) ponto seguro: o run.ps1 done que fecha a Task grava .team-project/.safe-point e libera o fim de turno sem apagar o .active-run. Para esperar um agente: dispare e encerre o turno; o aviso reabre a sessão.")
    exit 2
} catch {
    exit 1
}
