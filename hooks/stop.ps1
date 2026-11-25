# Stop — G20 (v3.51, proposta a das paradas do run): durante o sprint run, a sessão não encerra o turno com Task elegível
# no quadro. Paradas legítimas (sprint-run.md §Ordem da fila): fim da fila → formulário da Review · bloqueio sem elegível
# · pré-condição falha · interrupção do stakeholder — em todas a sessão apaga o .active-run antes. v3.52: ponto seguro
# (.safe-point, Task recém-fechada) também libera, sem apagar o .active-run — a sessão curta por Task (R29). Esperar agente
# também não é parada: a notificação reabre a sessão (.active-agents, gravado pela PreToolUse). v3.52.2 (note.md item 2): todo
# agente é assíncrono — vale qualquer agente desta sessão, sem olhar "bg".
# v3.53.5: a decisão "esperar" do run.ps1 next (.next-verdict, 30 min) também libera; a Task em construção é a citada.
# v3.65.7: a decisão "agir" (o next mandou disparar um agente) barra sem agente em voo, com ou sem Task elegível.
# Medido no piloto: 4 paradas fora do contrato e ~24,5 h de fila parada. Exit 2 devolve o motivo à sessão, que continua.
# Qualquer exceção → exit 1 (falha aberta, D5). Cobertura e limites: hooks/COVERAGE.md.

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

# v3.65.11: o texto da última fala da sessão (as partes "text" da última entrada assistant com texto; '' sem ela).
function Get-LastAssistantText([string]$Path) {
    $tail = @(Get-Content -LiteralPath $Path -Encoding UTF8 -Tail 80)
    for ($i = $tail.Count - 1; $i -ge 0; $i--) {
        $l = $tail[$i]
        if ($l -notmatch '"type"\s*:\s*"assistant"') { continue }
        try { $j = $l | ConvertFrom-Json } catch { continue }
        $parts = @(@($j.message.content) | Where-Object { $_ -and $_.PSObject.Properties['type'] -and [string]$_.type -eq 'text' } | ForEach-Object { [string]$_.text })
        if ($parts.Count) { return ($parts -join "`n") }
    }
    return ''
}
# A fala termina pedindo uma decisão: '?' numa das 4 últimas linhas com texto (fora de bloco de código e de citação), ou a
# frase que pede a escolha ("como quer seguir", "qual você escolhe", "até você responder"…).
function Test-TextQuestion([string]$Text) {
    $t = [regex]::Replace($Text, '(?s)```.*?```', '')
    $lines = @($t -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -and $_ -notmatch '^>' })
    if (-not $lines.Count) { return $false }
    $last = @($lines | Select-Object -Last 4)
    if (@($last | Where-Object { $_ -match '\?\**\s*$' }).Count) { return $true }
    return ($t -match '(?i)(como (você )?quer seguir|qual (você )?(escolhe|prefere)|preciso que você (diga|decida|escolha|responda)|até você responder|aguardo (a )?(sua )?(resposta|decisão))')
}

try {
    $hookInput = Read-HookInput
    if ($null -eq $hookInput) { exit 0 }
    $projectDir = Get-ProjectDir $hookInput
    $tp = Join-Path $projectDir '.team-project'
    if (-not (Test-Path -LiteralPath $tp)) { exit 0 }
    $cfg = Get-GuardConfig $projectDir
    # v3.66.0 — G26 (R36, matriz de impasses): fora da sessão que conduz o sprint run (dentro dela, a G20), o turno que termina
    # oferecendo uma ação do roteiro ("Quer que eu acione a QA?", "Posso anotar no documento?") sem rota ao stakeholder. Na
    # preparação do sprint 7 do projeto piloto (23/11), 7 chamadas eram licença para o próprio trabalho. A frase é heurística
    # de texto: guards.json → impasses.offerGuard "warn" (padrão — só registra no guards.log) ou "enforce" (barra; a 3ª vez
    # em 10 min passa, como a G20). Frases: hooks/impasses.json → offerPhrases.
    $run = Get-Marker $projectDir '.active-run'
    $rsO = Get-Marker $projectDir '.run-session'; $sidO = [string]$hookInput.session_id
    $runSessionO = ($null -ne $run -and [string]$run.trilha -eq 'sprint' -and (($null -eq $rsO) -or (-not $sidO) -or ([string]$rsO.session -eq $sidO)))
    if (-not $runSessionO -and (Test-GuardEnabled $cfg 'G26') -and -not (Test-PluginSource $projectDir)) {
        $trO = [string]$hookInput.transcript_path
        if ($trO -and (Test-Path -LiteralPath $trO)) {
            $hitO = Find-OfferPhrase (Get-LastAssistantText $trO) @((Get-ImpasseMatrix $projectDir).OfferPhrases)
            if ($hitO) {
                $arO = Get-Marker $projectDir '.ask-route'; $arAgeO = 999
                if ($null -ne $arO) { try { $arAgeO = ((Get-Date) - [datetime]::ParseExact([string]$arO.at, 'yyyy-MM-dd HH:mm:ss', $null)).TotalMinutes } catch { } }
                if ($arAgeO -ge 15) {
                    $modeO = 'warn'
                    try { $gj = Get-Content -LiteralPath (Join-Path $tp 'guards.json') -Raw -Encoding UTF8 | ConvertFrom-Json; if ([string]$gj.impasses.offerGuard -eq 'enforce') { $modeO = 'enforce' } } catch { }
                    $short = if ($hitO.Length -gt 140) { $hitO.Substring(0, 140) + '…' } else { $hitO }
                    if ($modeO -ne 'enforce') { Write-GuardLog $projectDir 'G26' $hookInput '' "aviso (warn): fim de turno oferecendo ação do roteiro sem rota — '$short'"; exit 0 }
                    if ($hookInput.stop_hook_active -eq $true) {
                        $logO = Join-Path $tp 'guards.log'; $recentO = 0
                        if (Test-Path -LiteralPath $logO) { $limO = (Get-Date).AddMinutes(-10); foreach ($l in (Get-Content -LiteralPath $logO -Encoding UTF8 -Tail 50)) { if ($l -match '\| G26 \|' -and $l -match 'bloqueio') { $mO = [regex]::Match($l, '(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})'); if ($mO.Success -and [datetime]::Parse($mO.Groups[1].Value) -ge $limO) { $recentO++ } } } }
                        if ($recentO -ge 2) { Write-GuardLog $projectDir 'G26' $hookInput '' 'liberado após 2 bloqueios'; exit 0 }
                    }
                    Write-GuardLog $projectDir 'G26' $hookInput '' "bloqueio: fim de turno oferecendo ação do roteiro sem rota — '$short'"
                    [Console]::Error.WriteLine("[G26] A sua fala termina oferecendo uma ação ('$short') sem rota ao stakeholder. Pela matriz de impasses (roles/scrum-master/process/impasse-matrix.md, R36), passo do roteiro, registro em documento, ordem do trabalho e decisão técnica, de desenho, de produto ou de prova são do time: execute pelo dono e informe em uma linha. Na dúvida: impasse.ps1 raise -Type <tipo> … diz o dono. Se for mesmo do stakeholder, o raise grava a rota e a pergunta vai em formulário (AskUserQuestion), não em texto.")
                    exit 2
                }
            }
        }
    }
    if (-not (Test-GuardEnabled $cfg 'G20')) { exit 0 }
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
    # v3.65.11 (garden S6, 22/11 02:21): a sessão discordou do run.ps1 next e parou com uma pergunta ESCRITA ao stakeholder,
    # cheia de hash, exit 4 e nome de arquivo, sobre trabalho do próprio time (reinstalar o app, repetir o aceite). Pergunta
    # escrita não passa pela G3 (forma) nem pela G24 (rota) — só o formulário passa. Barra o fim de turno da sessão que conduz
    # o run quando a última fala termina em pergunta (ou pede a escolha) sem rota ao stakeholder nos últimos 15 min.
    $sidQ = [string]$hookInput.session_id
    $rsQ = Get-Marker $projectDir '.run-session'
    $isRunSession = ($null -eq $rsQ) -or (-not $sidQ) -or ([string]$rsQ.session -eq $sidQ)
    $trQ = [string]$hookInput.transcript_path
    if ($isRunSession -and $trQ -and (Test-Path -LiteralPath $trQ)) {
        $lastTxt = Get-LastAssistantText $trQ
        if ($lastTxt -and (Test-TextQuestion $lastTxt)) {
            $arQ = Get-Marker $projectDir '.ask-route'
            $arAge = 999; if ($null -ne $arQ) { try { $arAge = ((Get-Date) - [datetime]::ParseExact([string]$arQ.at, 'yyyy-MM-dd HH:mm:ss', $null)).TotalMinutes } catch { } }
            if ($arAge -ge 15) {
                Write-GuardLog $projectDir 'G20' $hookInput '' 'bloqueio: pergunta escrita ao stakeholder durante o run, sem formulário nem rota'
                [Console]::Error.WriteLine("[G20] O sprint run está em andamento e a sua última fala termina numa pergunta escrita ao stakeholder. Pergunta escrita não passa pela forma (G3) nem pela rota (G24). Antes, confira se a decisão é dele (a matriz de impasses, roles/scrum-master/process/impasse-matrix.md — R36): discordar do run.ps1 next, instalar ou reparar o aparelho, repetir o aceite, 'sigo?' ou 'tento de novo?' não são — leve ao Arquiteto (/arc question, degrau 1) ou ao operator, e siga a fila. Se for dele: rode run.ps1 next até a rota ao stakeholder e use o formulário (AskUserQuestion), partindo da linha PARA O STAKEHOLDER (.team-project/.ask-route → plain), sem código de tarefa, hash nem nome de arquivo.")
                exit 2
            }
        }
    }
    # Espera legítima por agente em voo. v3.52.2 (note.md item 2): o Agent não tem mais run_in_background — toda chamada volta
    # "lançado" e o aviso reabre a sessão; o filtro "bg" barrava a espera (195 G20 no sprint 3 do piloto). Vale QUALQUER agente
    # disparado nesta sessão (session = session_id do hook; registro antigo sem session também) com sinal de vida há menos de
    # 3 h (mais velho é resto de queda); agente de outra sessão não segura o turno.
    # v3.66.2 (garden S7, T-100, 24/11 08:01): o corte de 3 h aceitava como "em voo" o dev interrompido às 07:53 (último sinal
    # às 06:45) e o executor "aguardando filho" dele, e a sessão encerrou o turno sem ninguém que a acordasse. A régua é a do
    # run.ps1 (Get-LiveAgents: sinal há menos de 20 min, rodada aberta, sem interrupção na transcrição, filho vivo).
    $sid = [string]$hookInput.session_id
    $agents = @(Get-LiveAgents $projectDir '*' | Where-Object { $s = if ($_.PSObject.Properties['session']) { [string]$_.session } else { '' }; -not $s -or -not $sid -or $s -eq $sid })
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
    # v3.53.4: o run.ps1 next parou esperando o plano externo (pacote com o stakeholder) — a .external-plan libera o fim de
    # turno; o próximo next a apaga e lê pack/in/.
    $xp = Get-Marker $projectDir '.external-plan'
    if ($null -ne $xp) { Write-GuardLog $projectDir 'G20' $hookInput '' "liberado: esperando o plano externo ($((@($xp.pendente) | ForEach-Object { [string]$_ }) -join ', '))"; exit 0 }
    # v3.53.5 (sprint 5 do garden: 43 bloqueios num dia, todos na T-042, com o next mandando esperar a T-061): a G20 segue a
    # decisão do run.ps1 next (.next-verdict "esperar": agente vivo ou comando da Task rodando) por 30 min. Mais velha, barra
    # de novo: a sessão roda o next, que regrava a decisão e mostra o sinal de vida da espera (POSSÍVEL TRAVAMENTO).
    $nv = Get-Marker $projectDir '.next-verdict'
    # v3.57.2 (note.md item 21): "reiniciar" — a sessão passou do teto de contexto sem agente em voo; o fim do turno é o
    # caminho para o stakeholder rodar /clear e /sm sprint run (o run retoma do quadro e do .active-run).
    if ($null -ne $nv -and [string]$nv.acao -eq 'reiniciar') {
        $nvAge = try { ((Get-Date) - [datetime]::ParseExact([string]$nv.at, 'yyyy-MM-dd HH:mm:ss', $null)).TotalMinutes } catch { 999 }
        if ($nvAge -lt 30) { Write-GuardLog $projectDir 'G20' $hookInput ([string]$nv.task) "liberado: o run.ps1 next mandou $([string]$nv.acao) ($([string]$nv.motivo))"; exit 0 }
    }
    # v3.66.2 (garden S7, T-100, 24/11 08:01): o "esperar" do next liberava o fim de turno sozinho por 30 min. O watcher voltou
    # "vivo", a sessão encerrou o turno sem redisparar ninguém e o verify terminou às 08:24 sem que ninguém rodasse o next. A
    # espera só é legítima com quem avise: um agente desta sessão em voo (liberado acima — o watcher conta). Sem ele, barra.
    if ($null -ne $nv -and [string]$nv.acao -eq 'esperar') {
        # O travamento repetido manda esperar e leva ao stakeholder (rota gravada): a decisão é dele.
        $arW = Get-Marker $projectDir '.ask-route'
        if ($null -ne $arW -and [string]$arW.at -ge [string]$nv.at) { Write-GuardLog $projectDir 'G20' $hookInput ([string]$arW.task) "liberado: a rota ao stakeholder ($([string]$arW.rota)) veio com a espera"; exit 0 }
        Write-GuardLog $projectDir 'G20' $hookInput ([string]$nv.task) "bloqueio: espera sem quem avise ($([string]$nv.motivo))"
        [Console]::Error.WriteLine("[G20] O run.ps1 next mandou esperar ($([string]$nv.motivo)), mas nenhum agente desta sessão está em voo para avisar quando a espera mudar: encerrar o turno agora deixa o time parado até alguém digitar. Dispare o watcher com a linha que o next imprimiu (Agent subagent_type 'team:watcher', model 'haiku', description 'Watcher da espera', prompt 'Rode a sonda do seu roteiro e devolva a linha.') e então encerre o turno — o aviso dele reabre a sessão quando a espera terminar ou travar. Se a espera já acabou, rode run.ps1 next.")
        exit 2
    }
    if ($tr -and (Test-Path -LiteralPath $tr)) {
        $tail = @(Get-Content -LiteralPath $tr -Encoding UTF8 -Tail 40)
        $lastAsst = @($tail | Where-Object { $_ -match '"type":"assistant"' } | Select-Object -Last 1)
        if ($lastAsst.Count -and ($lastAsst[0] -match '<synthetic>' -or $lastAsst[0] -match '"isApiErrorMessage":true')) { Write-GuardLog $projectDir 'G20' $hookInput '' 'liberado: o turno acabou em erro de API (resposta sintética)'; exit 0 }
        # v3.65.0 (A4-09): saiu o ramo do "toque de cache" (CronCreate), retirado na v3.52 — nada mais gera esse turno.
    }
    # v3.65.7 (garden S6: o next mandou o operator medir às 7:56, a sessão só escreveu o aviso e o time ficou parado até 8:34):
    # o next que imprime um disparo grava a ação pendente (.next-verdict "agir"). Sem agente desta sessão em voo (já liberado
    # acima), o fim de turno é barrado em qualquer fase — portão, consolidação, Review —, não só com Task elegível no quadro.
    # O agente que voltou também não libera: o passo seguinte é o run.ps1 next, que regrava a decisão. A rota ao stakeholder
    # gravada depois da ação (.ask-route) libera: a decisão é dele.
    if ($null -ne $nv -and [string]$nv.acao -eq 'agir') {
        $ar = Get-Marker $projectDir '.ask-route'
        if ($null -ne $ar -and [string]$ar.at -ge [string]$nv.at) { Write-GuardLog $projectDir 'G20' $hookInput ([string]$ar.task) "liberado: a rota ao stakeholder ($([string]$ar.rota)) veio depois da ação pendente"; exit 0 }
        Write-GuardLog $projectDir 'G20' $hookInput ([string]$nv.task) "bloqueio: ação pendente do run.ps1 next sem agente em voo ($([string]$nv.motivo))"
        [Console]::Error.WriteLine("[G20] O sprint run está em andamento (.active-run, sprint $([string]$run.id)) e o run.ps1 next deixou uma ação pendente: $([string]$nv.motivo). Nenhum agente desta sessão está em voo, então encerrar o turno aqui deixa o time parado. Se o agente ainda não foi disparado, dispare-o agora com o prompt que o next imprimiu e encerre o turno (o aviso reabre a sessão). Se ele já voltou, rode run.ps1 next e faça a PRÓXIMA AÇÃO que ele imprimir. Só encerre por parada legítima (sprint-run.md §Ordem da fila): fim da fila, bloqueio sem elegível, pré-condição falha, interrupção ou pausa pedida pelo stakeholder — nesses casos apague o .active-run antes.")
        exit 2
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
    if (-not $eligible.Count) { Write-GuardLog $projectDir 'G20' $hookInput '' 'liberado: nenhuma Task elegível no quadro e nenhuma ação pendente do next'; exit 0 }
    $t = $eligible[0]
    # v3.53.5: a Task em construção (.active-task) vem antes, como no run.ps1 next — a G20 citava a T-042 (primeira do
    # quadro) enquanto o next construía a T-061.
    $atk = Get-Marker $projectDir '.active-task'
    if ($null -ne $atk -and $atk.id) { $cur = @($eligible | Where-Object { $_.Id -eq [string]$atk.id }); if ($cur.Count) { $t = $cur[0] } }
    # v3.53.1 (plugin-report do sprint 4 do garden, item 3): a Task elegível já tem executor ou dev vivo de OUTRA sessão aberta
    # no mesmo projeto — o run.ps1 next manda esperar, e barrar o fim de turno levaria a redisparar (dois devs no mesmo alvo).
    if (@(Get-LiveAgents $projectDir $t.Id | Where-Object { ([string]$_.type -replace '^.*:', '') -in 'task-runner', 'developer' -and (Test-AgentHostAlive $_) -eq $true }).Count) {
        Write-GuardLog $projectDir 'G20' $hookInput $t.Id 'liberado: a Task tem agente vivo de outra sessão (run.ps1 next manda esperar)'; exit 0
    }
    Write-GuardLog $projectDir 'G20' $hookInput $t.Id 'bloqueio: fim de turno com Task elegível'
    [Console]::Error.WriteLine("[G20] O sprint run está em andamento (.active-run, sprint $([string]$run.id)) e a Task $($t.Id) está elegível. Encerrar o turno aqui não é parada legítima (sprint-run.md §Ordem da fila): siga — rode run.ps1 next e faça a PRÓXIMA AÇÃO que ele imprimir (dev de volta: run.ps1 done -Task <ID> -Result ok|gap|env|teto). Só encerre por (a) fim da fila → formulário de autorização da Review, (b) Task marcada 🔴 sem elegível restante → formulário de R22, (c) pré-condição falha, (d) interrupção do stakeholder, (e) pausa pedida pelo stakeholder entre Tasks (sprint-run.md §Pausa segura) — nesses casos apague o .active-run antes; (f) ponto seguro: o run.ps1 done que fecha a Task grava .team-project/.safe-point e libera o fim de turno sem apagar o .active-run. Para esperar um agente: dispare e encerre o turno; o aviso reabre a sessão.")
    exit 2
} catch {
    # v3.65.0 (A1-02): a falha aberta deixa rastro — o COVERAGE promete a linha `erro` no guards.log em todo despachante
    try { Write-GuardLog $projectDir 'erro' $hookInput 'stop.ps1' $_.Exception.Message } catch { }
    exit 1
}
