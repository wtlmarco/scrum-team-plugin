# Portão do QA por marcos (v3.63.0) — o passo 3 do run.ps1 next, carregado por ele (usa as variáveis e funções do run.ps1:
# $Root, $S, $n, $tasks, $E, $plugin, $todoMk, Out, Say, Get-AgentLine, Get-VerdictOf, Test-PoDebt, Add-RunLog).
# Origem: sprint 6 do projeto piloto (15–17/11/2026) — 3 rodadas reprovadas, quase todas por ambiente; cada rodada refez a
# qualidade inteira e os 49 cenários; o validation.md citava prova que a rodada seguinte apagou.
#   A · o accept que parou no ambiente não é medição: reparo e repetição (-Resume); a 2ª vez, ou a configuração do alvo, vai
#       ao stakeholder — nunca ao QA, a uma Q-S<n> ou ao Arquiteto.
#   C · cada frente tem base: a árvore de produção (sem teste nem quality.toolingPaths) e o conjunto de cenários.
#   D · a rodada nova mede só o que venceu e o QA julga só as frentes vencidas e os achados abertos.
#   E/F · validation.md com a tabela de achados (ID S<n>-F<k>, Cause, State); a causa decide o dono, na ordem fixa
#       requirement → screen → design → scenario → code. Sem a tabela, o caminho de antes (Q-S<n> pelos "Volta para: dev").
#   H · a prova que o QA julga é copiada para sprints/<n>/proof/S<n>/round-<k>/ antes de cada rodada.
# v3.63.1 (sprint 6 do projeto piloto, 18/11): toda falha de cenário do aceite passa pelo diagnóstico do operator (AMBIENTE ·
#   APP · PLANO) antes de virar ambiente ou de ir ao QA; o alvo preso por outro processo espera (o dono anda) ou vai ao
#   stakeholder na primeira vez (parado), com o target.ps1 -Kill; o mesmo result.json pedindo reparo pela 3ª vez também.
# v3.64.0 (sprint 6 do projeto piloto, 18/11): o portão preso no formato antigo — a rodada focada pede a tabela com Cause e a
#   conversão dos achados antigos; nenhuma Q-S<n> nova com outra aberta (os achados vão a ela, e o Arquiteto emenda o plano);
#   "**Corrige:** <Q-S>" substitui a antiga; Q-S em 🔴 vai à rota do bloqueio, não a "esperar"; o diagnóstico do operator mais
#   novo que o veredito pede a rodada focada; checkpoint das Tasks abertas antes de medir; a suíte só reaproveitada por inputs
#   roda de fato (verify -Fresh) antes da qualidade; outro projeto com a máquina (trava pesada) → esperar.
# v3.64.1 (sprint 6 do projeto piloto, 18/11): Task em 🔴 segura a medição (rota do bloqueio dela, sem operator), e a rota do
#   bloqueio da correção em 🔴 vem antes da rodada focada.
# v3.65.5 (sprint 6 do projeto piloto, 21/11): a resolução vale até a rodada seguinte (o achado que segue aberto volta ao dono);
#   a parte do .scn de uma resolução code vai ao QA quando a Q-S fecha, antes da rodada nova; a Q-S fechada só pede rodada
#   focada uma vez (gate.json → judged.qs).
# Sai com exit quando há o que fazer; volta sem sair com o portão passado (✅, ou ⚠️ com a decisão do PO).

function Invoke-GateStep {
    $sid = "S$n"
    $qDir = (Get-VerifyDir $Root $sid) -replace '[\\/]verify[\\/]', '/quality/'
    $aDir = (Get-VerifyDir $Root $sid) -replace '[\\/]verify[\\/]', '/accept/'
    $qr = Join-Path $qDir 'result.json'; $ar = Join-Path $aDir 'result.json'
    $tcfg = Get-TargetsConfig $Root; $hasTarget = [bool]$tcfg
    $tn = if ($tcfg) { @($tcfg.PSObject.Properties | ForEach-Object { $_.Name } | Where-Object { $_ -in 'android', 'web' })[0] } else { '' }
    $readJ = { param($p) if (Test-Path -LiteralPath $p) { try { return (Read-Text $p | ConvertFrom-Json) } catch { } }; return $null }
    $qj = & $readJ $qr; $aj = if ($hasTarget) { & $readJ $ar } else { $null }
    $prodNow = Get-ProductionTree $Root
    $scnNow = Get-ScenarioSetHash (Get-SprintScenarioFiles $Root)
    $tree = Get-WorkTree $Root
    # Base de um result.json: a árvore de produção (v3.63.0); o result.json anterior a ela compara a árvore inteira, como antes.
    $sameBase = { param($j) if (-not $j) { return $false }; if ($j.PSObject.Properties['prod'] -and $j.prod) { return ([string]$j.prod -eq [string]$prodNow) }; return (-not $tree -or -not $j.tree -or [string]$j.tree -eq $tree) }
    $qFresh = & $sameBase $qj
    $aCfg = if ($aj -and $aj.PSObject.Properties['configuration'] -and $aj.configuration) { [string]$aj.configuration } else { '' }
    $aEnv = if ($aj -and -not $aCfg -and $aj.environment) { [string]$aj.environment } else { '' }
    $aScnOk = (-not $aj) -or -not ($aj.PSObject.Properties['scenariosHash'] -and $aj.scenariosHash) -or ([string]$aj.scenariosHash -eq $scnNow)
    # v3.63.1 (sprint 6 do projeto piloto, pedido 1): o diagnóstico do operator sobre a falha de cenário desta rodada do aceite.
    $diagRel = ".team-project/operator/$n/$sid-alvo/diagnostico.md"
    $need = if ($hasTarget -and $aj -and (& $sameBase $aj) -and $aScnOk) { Get-AcceptDiagnosisNeed $aj } else { $null }
    $diag = if ($need -and $need.Need) { Read-AcceptDiagnosis (Join-Path $Root $diagRel) $ar } else { $null }
    # A interrupção que o diagnóstico atribuiu ao app ou ao plano não é ambiente: a rodada vale como medição e vai ao QA.
    if ($aEnv -and $diag -and $diag.Verdict -in 'APP', 'PLANO') { $aEnv = '' }
    $aFresh = (-not $hasTarget) -or ($aj -and (& $sameBase $aj) -and $aScnOk -and -not $aEnv -and -not $aCfg)
    $gate = Get-GateState $S
    $val = Join-Path $S 'validation.md'; $vv = Get-VerdictOf $val
    # v3.52.2 (C6): ⚠️ com "**Decisão do PO:** aceito com dívida — …" passa o portão; ❌ nunca.
    $poDebt = ($vv -eq $E.Warn) -and (Test-PoDebt $val)
    if ($vv -eq $E.Done -or $poDebt) { return }
    $short = { param($t) $x = (([string]$t -replace '["|]', "'") -replace '\s+', ' ').Trim(); if ($x.Length -gt 200) { $x.Substring(0, 200) + '…' } else { $x } }
    $accRel = ".team-project/$(($aDir.Substring($Root.Length).TrimStart('\', '/')) -replace '\\', '/' -replace '^\.team-project/', '')"
    $diagAsk = {
        param([string]$Why)
        Out "PRÓXIMA AÇÃO: validação do sprint $n — diagnosticar a falha do aceite antes de $Why (operator; v3.63.1: toda falha de cenário passa pelo diagnóstico — AMBIENTE · APP · PLANO)"
        Say 'Revisão final: um teste no aparelho falhou; estou vendo nas capturas e no registro do aparelho se o problema é do app, do teste ou do aparelho.'
        Out "  $(Get-AgentLine 'operator')"
        Out "  prompt: `"$(Get-AcceptDiagPrompt "sessão $sid" $sid $accRel $diagRel $tn $plugin $need)`""
        Out '  depois: run.ps1 next — o next lê o veredito: AMBIENTE → reparo e retomada do aceite · APP → o QA registra o achado como code (vai ao dev) · PLANO → o QA registra como scenario (Dono QA: o .scn) ou design (Dono Arquiteto), com o elemento e onde ele fica na tela'
        exit 0
    }
    $diagTxt = if ($diag) { ", o diagnóstico do operator $diagRel (veredito $($diag.Verdict)$(if ($diag.Element) { "; elemento: $($diag.Element)" })$(if ($diag.Where) { "; onde: $($diag.Where)" }): APP → achado com Cause code; PLANO → Cause scenario (Dono QA) ou design (Dono Arquiteto), com o elemento e onde ele fica na tela na coluna Onde; AMBIENTE → Cause environment)" } else { '' }

    $qsRows = @($tasks | Where-Object { $_.Id -match "^Q-S$n([a-z]?)$" })
    # v3.64.0 (item 8 B; sprint 6 do projeto piloto, 18/11): a correção que outra substituiu (o plano da nova declara
    # **Corrige:** <a antiga>) conta como encerrada — no piloto, a Q-S6d em 🔴, que a Q-S6e corrige, segurava o portão.
    $supersededBy = @{}
    foreach ($q in $qsRows) {
        if (-not $q.Plan -or $q.Plan -match '^plan/?$') { continue }
        $qp = Join-Path $S $q.Plan; if (-not (Test-Path -LiteralPath $qp -PathType Leaf)) { continue }
        $cm = [regex]::Match((Read-Text $qp), '(?m)^\*\*Corrige:\*\*([^\r\n]*)')
        if ($cm.Success) { foreach ($m in [regex]::Matches($cm.Groups[1].Value, "Q-S$n[a-z]?(?![\w-])")) { if ($m.Value -ne $q.Id) { $supersededBy[$m.Value] = $q.Id } } }
    }
    $redQ = [char]::ConvertFromUtf32(0x1F534)
    # O motivo do 🔴 de uma Task: a última linha dela em "Bloqueios e riscos abertos" (kanban.md, ou o quadro antigo).
    $blockWhy = {
        param([string]$Id)
        foreach ($f in @((Join-Path $S 'kanban.md'), (Join-Path $S 'sprint-backlog.md'))) {
            if (-not (Test-Path -LiteralPath $f)) { continue }
            foreach ($t in (Get-Tables (Read-Text $f))) {
                $ni = -1; $ti = -1; for ($i = 0; $i -lt $t.Header.Count; $i++) { if ($t.Header[$i] -match '^Natureza') { $ni = $i }; if ($t.Header[$i] -match '^Task') { $ti = $i } }
                if ($ni -lt 0 -or $ti -lt 0) { continue }
                $hit = @($t.Rows | Where-Object { (Get-Cell $_ $ti) -match "(?<![\w-])$([regex]::Escape($Id))(?![\w-])" })
                if ($hit.Count) { return (& $short (Clean-Cell (Get-Cell $hit[-1] $ni))) }
            }
        }
        return 'motivo não registrado em Bloqueios e riscos abertos'
    }
    # A rota do bloqueio das Tasks em 🔴 (v3.64.0 item 8 B; v3.64.1 também antes de medir).
    $redRoute = {
        param($Red, [string]$Ctx)
        $ids = ($Red | ForEach-Object { $_.Id }) -join ', '
        $why = (($Red | ForEach-Object { "$($_.Id): $(& $blockWhy $_.Id)" }) -join '; ')
        $envR = -not @($Red | Where-Object { (& $blockWhy $_.Id) -notmatch '(?i)alvo|ambiente|emulador|aparelho|estado de partida|karma|navegador|browser' }).Count
        Set-AskRoute $Root $(if ($envR) { 'ambiente' } else { 'bloqueio' }) (($Red | ForEach-Object { $_.Id }) -join ',') "Task em 🔴 no portão: $why"
        Out "PRÓXIMA AÇÃO: destravar $ids (🔴) — $Ctx$why"
        Say $(if ($envR) { 'A revisão final está parada porque uma correção parou num problema do ambiente de teste. Preciso de você para resolver o ambiente; depois ela retoma de onde parou.' } else { 'A revisão final está esperando uma correção que parou. Preciso destravá-la para seguir.' })
        Out "  o motivo está em Bloqueios e riscos abertos (kanban.md); ambiente → formulário ao stakeholder, com a linha de Bloqueios. A resposta decide como a Task sai de 🔴: reparo fora do repositório (máquina, emulador, configuração dele) → $plugin/mark.ps1 -Task <ID> -To build -Reopen resume e run.ps1 next (o executor retoma pelo cartão); decisão que muda o que o plano manda (configuração de teste, guards.json, arquivo fora do plano, algo que ele proíbe) → $plugin/mark.ps1 -Task <ID> -To build -Reopen replan -Decision `"<a resposta>`" e run.ps1 next (o Arquiteto emenda o plano antes do dev, v3.64.2); decisão → degrau 1 (PO + Arquiteto), depois o formulário (R22). Não abra outra Q-S$n."
        exit 0
    }

    # ---------- v3.64.1 · Task em 🔴 segura a medição ----------
    # Sprint 6 do projeto piloto (18/11): a Q-S6e parou em 🔴 pelo Karma (verify full), o $open do run.ps1 não conta Task em
    # 🔴, a fila parecia vazia e o portão mediu de novo o aceite (21 cenários) sobre o código parcial da correção — a regra da
    # rota do bloqueio só vinha depois do veredito. Medir com uma Task parada não traz informação ao portão: com o que venceu
    # e uma Task em 🔴 (que nenhuma outra substitui), vai à rota do bloqueio dela, sem operator. A Task com "prova no alvo
    # pendente" fica de fora: o run.ps1 next a reabre sozinho quando o alvo volta (v3.53.6), e o aceite do portão com o alvo
    # fora já vai ao reparo e ao stakeholder (A).
    $tpHold = @(Get-TargetPendingIds $S)
    $redHold = @($tasks | Where-Object { $_.Mark -eq $redQ -and -not $supersededBy.ContainsKey($_.Id) -and $tpHold -notcontains $_.Id } | Sort-Object Id -Unique)
    if ($redHold.Count -and (-not $qFresh -or -not $aFresh)) {
        & $redRoute $redHold 'a medição do portão do sprint espera: medir com Task em 🔴 roda o aceite sobre código que não fechou. '
    }

    # ---------- v3.63.1 · o alvo preso por outro processo (pedidos 5 e 7) ----------
    # Sprint 6 do projeto piloto (18/11): o operator travou, o watchdog o encerrou e o accept que ele disparou seguiu vivo segurando
    # o alvo. O reparo recusava ("em uso por accept S6"), o accept recusava sem gravar result.json, e o next repetia "reparar e
    # repetir" para sempre. Com o alvo em uso: o dono que anda → esperar (watcher); parado, ou processo que não é do plugin →
    # stakeholder na PRIMEIRA vez, com o target.ps1 -Kill (que encerra o dono da trava e a árvore dele).
    if ($hasTarget) {
        $tb = Get-TargetBusy $Root
        if ($tb -and ($tb.Plugin -or ($tb.PSObject.Properties['Heavy'] -and $tb.Heavy)) -and -not $tb.Pulse.Stalled) {   # v3.64.0: outro projeto com a máquina, andando → esperar
            Set-NextVerdict $Root 'esperar' $sid "alvo em uso: $($tb.Text)"
            Out "PRÓXIMA AÇÃO: esperar — o alvo $($tb.Target) está em uso por $($tb.Text). Não dispare reparo nem outro aceite: os dois recusam o alvo em uso (e dois automatizadores no mesmo alvo quebram os dois)."
            Out (Get-WatcherLine)
            exit 3
        }
        if ($tb) {
            $whyB = & $short "alvo $($tb.Target) preso por $($tb.Text)"
            Set-AskRoute $Root 'ambiente' $sid $whyB
            Add-RunLog $S $n $sid "portão: alvo preso por '$($tb.Owner)' (PID $($tb.Pid)) → stakeholder na primeira vez (formulário); sem reparo nem aceite repetidos" $whyB "accept/$n/$sid/"
            Out "PRÓXIMA AÇÃO: formulário ao stakeholder — o alvo $($tb.Target) está preso por $($tb.Text)"
            Out "  não repare nem repita o aceite: os dois recusam o alvo em uso (v3.63.1). Opções ao stakeholder: $(if ($tb.Foreign) { "o aparelho está com OUTRO projeto ($($tb.Project)) — esperar ele terminar; parado, encerrá-lo pela sessão daquele projeto ($plugin/target.ps1 -Target $($tb.Target) -Kill -Root '$($tb.Project)'); para rodar os dois ao mesmo tempo, cada projeto declara o seu aparelho em guards.json → targets.android.serial (v3.63.2)" } elseif ($tb.Plugin) { "encerrar o processo parado — $plugin/target.ps1 -Target $($tb.Target) -Kill (encerra o dono da trava e a árvore dele) e run.ps1 next (o aceite retoma com -Resume)" } else { "o processo não é um script do plugin reconhecível pela trava — ele o encerra à mão e a sessão roda $plugin/target.ps1 -Target $($tb.Target) -Unlock e run.ps1 next" }); ou seguir esperando."
            Say $(if ($tb.Foreign) { 'A revisão final parou porque o aparelho de teste está sendo usado por outro projeto e o teste dele parece parado. Preciso de você para decidir se espero ou encerro aquele teste.' } else { 'A revisão final parou porque um teste anterior ficou preso no aparelho de teste. Preciso de você para decidir se encerro esse teste e retomo.' })
            exit 0
        }
    }

    # ---------- A · o accept que parou no ambiente não é medição ----------
    if ($hasTarget -and $aj -and ($aCfg -or $aEnv) -and (& $sameBase $aj) -and $aScnOk) {
        # v3.63.1: a interrupção com sinal do app (reiniciado, WebView recriada, sem foco, fechado) ou cenário que falhou antes
        # dela vai ao diagnóstico ANTES do reparo — "app não ficou na frente" sozinho não é prova de ambiente.
        if (-not $aCfg -and $need -and $need.Need -and -not $diag) { & $diagAsk 'tratar como ambiente' }
        if (-not $aCfg -and [string]$gate.env.at -ne [string]$aj.at) { $gate.env.attempts = [int]$gate.env.attempts + 1; $gate.env.at = [string]$aj.at; Set-GateState $S $gate }
        # v3.63.1 (pedido 7): o mesmo result.json pedindo reparo de novo = o aceite não rodou depois do último pedido (alvo
        # recusado, operator encerrado) — na 2ª repetição vai ao stakeholder, em vez de repetir para sempre.
        if (-not $aCfg) { if ([string]$gate.env.sentAt -eq [string]$aj.at) { $gate.env.sent = [int]$gate.env.sent + 1 } else { $gate.env.sent = 1; $gate.env.sentAt = [string]$aj.at }; Set-GateState $S $gate }
        $why = & $short $(if ($aCfg) { "CONFIGURAÇÃO DO ALVO: $aCfg" } else { $aEnv })
        $stuck = (-not $aCfg) -and [int]$gate.env.sent -ge 3
        if ($stuck) { $why = & $short "o aceite não rodou de novo depois de 2 pedidos de reparo e repetição (o result.json é o mesmo, de $([string]$aj.at)): $aEnv" }
        if ($aCfg -or [int]$gate.env.attempts -ge 2 -or $stuck) {
            $how = if ($aCfg) { '(configuração do alvo)' } elseif ($stuck) { '— e o aceite não rodou de novo depois de 2 pedidos de reparo' } else { "pela $($gate.env.attempts)ª vez seguida, depois do reparo" }
            Set-AskRoute $Root 'ambiente' $sid $why
            if ([string]$gate.env.asked -ne [string]$aj.at) {
                Add-RunLog $S $n $sid "portão: o aceite parou no ambiente $how → stakeholder (formulário); sem QA, sem Q-S$n, sem Arquiteto" $why "accept/$n/$sid/result.md"
                $gate['env']['asked'] = [string]$aj.at; Set-GateState $S $gate
            }
            Out "PRÓXIMA AÇÃO: formulário ao stakeholder — o aceite do portão do sprint $n parou no ambiente ${how}: $why"
            Out "  não é veredito: o QA não julga, nenhuma Q-S$n abre e o Arquiteto não entra (v3.63.0). Opções ao stakeholder: ele repara o alvo ou ajusta guards.json / a massa de dados e a sessão roda run.ps1 next (o aceite retoma com -Resume); ou segue esperando.$(if ($stuck) { " Se o alvo segue preso por um processo, $plugin/target.ps1 -Target $tn -Kill encerra o dono da trava (v3.63.1)." })"
            Say "A revisão final parou porque o aparelho de teste não funcionou$(if ($aCfg) { ' como está configurado' } elseif ($stuck) { ' e o teste não conseguiu rodar de novo' } else { ' duas vezes seguidas' }). Não é defeito do app: preciso de você para decidir como seguir."
            exit 0
        }
        Out "PRÓXIMA AÇÃO: validação do sprint $n — reparar o alvo e repetir o aceite (operator; o aceite parou no ambiente, não é veredito — v3.63.0)"
        Say 'A revisão final parou porque o aparelho de teste falhou. Estou religando o aparelho e retomando os testes de onde pararam.'
        Out "  parou: $why"
        Out "  $(Get-AgentLine 'operator')"
        Out "  prompt: `"Chamador: sessão $sid — Rode na raiz: $plugin/target.ps1 -Target $tn -Repair e, pronto, $plugin/accept.ps1 -Task $sid -Resume (retoma: os cenários que já passaram com o mesmo app instalado não rodam de novo). Devolva o caminho do result.md e a linha de resumo.`""
        Out "  depois: run.ps1 next"
        exit 0
    }
    if ([int]$gate.env.attempts -or [int]$gate.env.sent) { $gate.env.attempts = 0; $gate.env.at = ''; $gate.env.sent = 0; $gate.env.sentAt = ''; Set-GateState $S $gate }

    # ---------- C/D · medir só o que venceu ----------
    if (-not $qFresh -or -not $aFresh) {
        $cmds = @(); $whyM = @()
        # v3.64.0 (item 7 C, decisão D7): a suíte desta árvore só existe reaproveitada por "inputs" → a revisão final a roda de
        # fato antes da qualidade (a Q11 não aceita a reaproveitada).
        if (-not $qFresh -and $tree) {
            $realS = $false; $inpS = $false
            foreach ($vf0 in @(Get-ChildItem -LiteralPath (Join-Path $Root '.team-project/verify') -Recurse -Filter 'result.json' -File -ErrorAction SilentlyContinue)) {
                try { $vj0 = Read-Text $vf0.FullName | ConvertFrom-Json } catch { continue }
                if (-not $vj0.full -or [string]$vj0.full.tree -ne $tree) { continue }
                foreach ($c0 in @($vj0.full.commands | Where-Object { [string]$_.key -match '^suite\d*$' -and [int]$_.exit -eq 0 })) { if ($c0.PSObject.Properties['reusedBy'] -and [string]$c0.reusedBy -eq 'inputs') { $inpS = $true } else { $realS = $true } }
            }
            if ($inpS -and -not $realS) { $cmds += "$plugin/verify.ps1 -Task $sid -Mode full -Fresh"; $whyM += 'suíte: só reaproveitada por inputs nesta árvore (a revisão final roda de fato)' }
        }
        if (-not $qFresh) { $cmds += "$plugin/quality.ps1 -Id $sid"; $whyM += $(if ($qj) { 'qualidade: o código de produção mudou' } else { 'qualidade: sem medição' }) }
        if (-not $aFresh) {
            $cmds += "$plugin/accept.ps1 -Task $sid -Resume"
            $whyM += $(if (-not $aj) { 'aceite: sem medição' } elseif (-not $aScnOk) { 'aceite: os cenários mudaram' } else { 'aceite: o código de produção mudou' })
        }
        # v3.64.0 (item 6 C): antes de medir, o código das Tasks não fechadas vai num checkpoint (só o escopo de cada plano), e o
        # que sobrar pendente aparece — no piloto, o portão mediu as ferramentas da Q-S6d sem commit (achado S6-F4-2).
        foreach ($ot in @($tasks | Where-Object { $_.Mark -ne $E.Done })) { $ckG = Save-TaskCheckpoint $Root $S $ot 'antes da medição do portão'; if ($ckG) { Out "  $ckG" } }
        $pendG = @(Get-GitPendingFiles $Root | Where-Object { $_ -notmatch '^docs/' })
        if ($pendG.Count) { Out "  atenção: pendente sem commit no disco, que a medição inclui: $(($pendG | Select-Object -First 5) -join ', ')$(if ($pendG.Count -gt 5) { " e mais $($pendG.Count - 5)" }) — commit da dona, chore, ou guards.json → treeIgnore" }
        Out "PRÓXIMA AÇÃO: validação do sprint $n — medir (operator, comandos longos fora das instâncias caras; C3): $($whyM -join ' · ')"
        Say $(if (-not $qj -and -not $aj) { 'Todas as partes do sprint estão prontas. Começou a revisão final: rodando todos os testes do app.' } else { 'Revisão final: medindo de novo só o que a correção mudou.' })
        Out "  $(Get-AgentLine 'operator')"
        Out ("  prompt: `"Chamador: sessão $sid — Rode na raiz: " + ($cmds -join ' e ') + $(if (-not $aFresh) { ' (o -Resume reaproveita os cenários que já passaram com o mesmo app instalado e o mesmo texto de cenário)' } else { '' }) + ". Exit 4 = ambiente: rode target.ps1 -Repair uma vez e repita — salvo quando a linha do accept traz 'sinal do app' ou 'em uso por' (não repita: devolva a linha; o next leva ao diagnóstico ou ao stakeholder). Devolva os caminhos dos result.md e as linhas de resumo.`"")
        Out "  depois: run.ps1 next"
        exit 0
    }

    # v3.63.1 (pedido 1): cenário que falhou nesta rodada do aceite → o diagnóstico antes do QA julgar; o veredito vai ao prompt
    # do QA, que registra o achado com a causa que ele aponta (APP → code; PLANO → scenario ou design, com o elemento e onde).
    if ($need -and $need.Need -and -not $diag) { & $diagAsk 'o julgamento do QA' }

    # A rodada em curso e a prova que o QA vai julgar (H).
    $verdicts = if (Test-Path -LiteralPath $val) { @([regex]::Matches((Read-Text $val), '(?m)^\*\*Veredito[^*\r\n]*:\*\*')).Count } else { 0 }
    $roundNow = $verdicts + 1
    $proofRel = "sprints/$n/proof/$sid/round-$roundNow"
    $copyProof = {
        $pd = Join-Path $S "proof/$sid/round-$roundNow"
        $k = Copy-Proof $qDir (Join-Path $pd 'quality'); if ($hasTarget) { $k += Copy-Proof $aDir (Join-Path $pd 'accept') }
        $gate.proof = $roundNow
        $gate.round = $roundNow
        # v3.65.5: as Q-S fechadas que esta rodada já julga — "Q-S fechada" só é novidade para a rodada seguinte se não estiver aqui.
        $gate.judged = [ordered]@{ prod = [string]$prodNow; scn = [string]$scnNow; accept = $(if ($aj) { [string]$aj.at } else { '' }); quality = $(if ($qj) { [string]$qj.at } else { '' }); qs = (@($qsRows | Where-Object { $_.Mark -eq $E.Done } | ForEach-Object { $_.Id }) -join ',') }
        Set-GateState $S $gate
        return $k
    }
    $proofTxt = ".team-project/$proofRel/quality/result.md" + $(if ($hasTarget) { " e .team-project/$proofRel/accept/result.md (com as capturas em .team-project/$proofRel/accept/)" } else { '' })
    $dpRel = if (Test-Path -LiteralPath (Join-Path $S 'device-pending.md')) { ", a lista de prova no aparelho pendente .team-project/sprints/$n/device-pending.md (cada linha: o cenário passou no accept do sprint ou fica como dívida no validation.md, com a Task e o motivo)" } else { '' }
    $fmt = "o modelo sprint-validation (v3.63.0): a tabela ## Frentes (Front functional|measured|review|security · State pass|fail · Round · Proof) e a tabela ## Achados (ID S$n-F<k> · Task · Achado · Onde · Cause code|design|scenario|screen|requirement|environment · Owner · State open)"

    if ($null -eq $vv -or $vv -eq '') {
        $k = & $copyProof
        Out "PRÓXIMA AÇÃO: validação do sprint $n — julgar (QA, rodada 1; portão da Review)"
        Say 'Revisão final: a qualidade está avaliando tudo o que foi entregue no sprint.'
        Out "  prova da rodada: .team-project/$proofRel/ ($k arquivo(s), sem logs brutos)"
        Out "  $(Get-AgentLine 'quality-assurance')"
        Out "  prompt: `"/qa sprint $n — leia $proofTxt$dpRel$diagTxt, os planos e o diff do sprint. Julgue SOLID, clean code, aderência à arquitetura e aos planos, padrões e segurança, citando standards/ (Q<n>). Escreva .team-project/sprints/$n/validation.md com o veredito e $fmt — cada achado com UMA causa, que decide o dono; cite a prova pelos caminhos de proof/. Não rode build nem o app. Volte em até 15 linhas.`""
        exit 0
    }

    $vf = Read-ValidationFindings $val
    $valAt = (Get-Item -LiteralPath $val).LastWriteTime
    $boardTxt = if (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md')) { Read-Text (Join-Path $S 'sprint-backlog.md') } else { '' }
    # A correção substituída (acima) não cobre achado: o que só ela citava vai à correção aberta.
    $qsOf = { param($fid) @($qsRows | Where-Object { -not $supersededBy.ContainsKey($_.Id) } | Where-Object { $q = $_; @(($boardTxt -split "`r?`n") | Where-Object { $_ -match '^\s*\|' -and $_.Contains($q.Id) -and $_.Contains($fid) }).Count }) }
    $qsOpen = @($qsRows | Where-Object { $_.Mark -ne $E.Done -and -not $supersededBy.ContainsKey($_.Id) })
    # v3.65.5 (sprint 6 do projeto piloto, 21/11): a Q-S fechada que uma rodada já julgou não é novidade — no piloto, a Q-S6h
    # fechada fazia toda chamada do next abrir outra rodada focada (rodadas 9 e 10 sem nada mudado). A fonte é o gate.json
    # (judged.qs, gravado a cada rodada); o gate.json anterior à v3.65.5 não tem a lista, e vale o relatório de entrega da Q-S
    # (delivery/<ID>.md) mais velho que o validation.md.
    $judgedQs = $null   # (atribuição direta: um if que devolve @() vazio daria $null, e a lista vazia contaria como ausente)
    if ($gate.judged -and $gate.judged.Contains('qs')) { $judgedQs = @(([string]$gate.judged.qs) -split ',' | Where-Object { $_ }) }
    $qsJudged = {
        param($q)
        if ($null -ne $judgedQs) { return ($judgedQs -contains $q.Id) }
        $dv = Join-Path $S "delivery/$($q.Id).md"
        return ((Test-Path -LiteralPath $dv) -and (Get-Item -LiteralPath $dv).LastWriteTime -lt $valAt)
    }
    # A correção que ainda vale para o achado: aberta, ou fechada e ainda não julgada.
    $qsLive = { param($fid) @(& $qsOf $fid | Where-Object { $_.Mark -ne $E.Done -or -not (& $qsJudged $_) }) }
    # v3.65.5: a resolução vale até a rodada seguinte. O achado que segue aberto num validation.md mais novo que o gate/<ID>.md
    # foi julgado depois dela e não se resolveu (no piloto, o "done" do S6-F7 segurou o achado por duas rodadas). Ela passa a
    # "stale" e o achado volta ao dono. A exceção é a resolução code com a parte do cenário ainda não aplicada: a correção não
    # foi inteira, e quem a testou testou só a metade.
    $effRes = {
        param([string]$Id)
        $r = Get-FindingResolution $S $Id
        if (-not $r -or -not $r.value) { return $r }
        $r.stale = $false
        if ($r.at -ge $valAt) { return $r }
        if ($r.value -eq 'code' -and (Get-FindingScenarioPart $S $Id).need) { return $r }
        $r.stale = $true
        return $r
    }
    $resolved = { param([string]$Id) $r = & $effRes $Id; [bool]($r -and $r.value -and -not $r.stale) }
    foreach ($k in $supersededBy.Keys) { if (@($qsRows | Where-Object { $_.Id -eq $k -and $_.Mark -ne $E.Done }).Count) { Out "  nota: a $k conta como substituída pela $($supersededBy[$k]) (o plano dela declara **Corrige:** $k) — não segura o portão" } }
    # v3.64.0 (item 8 B): achados novos para uma correção já aberta — a linha dela ganha os IDs e o Arquiteto emenda o plano
    # (o plano foi escrito para outros achados: no piloto, a Q-S6e só podia tocar a ferramenta do alvo, e os achados de código
    # pediam o app). Nunca uma Q-S nova ao lado da aberta.
    $toOpenQ = {
        param([string]$What, [string]$IdsTxt)
        $q = @($qsOpen | Sort-Object { $_.Id } -Descending)[0]
        $planQ = if ($q.Plan -and $q.Plan -notmatch '^plan/?$') { ".team-project/sprints/$n/$($q.Plan)" } else { '(sem plano ainda)' }
        Out "PRÓXIMA AÇÃO: incluir $What na $($q.Id) — a correção do portão já aberta ($($q.Mark)); não abra outra Q-S$n (v3.64.0)"
        Say 'A revisão final encontrou problemas no app; eles vão para a correção que já está aberta, e o arquiteto ajusta o plano dela.'
        Out "  1. a sessão acrescenta $IdsTxt na coluna Task da linha da $($q.Id) no quadro (é por eles que o portão sabe o que ela corrige)"
        Out "  2. $(Get-AgentLine 'architect') — prompt: `"/arc question — emende o plano $planQ da $($q.Id) para cobrir $IdsTxt (leia .team-project/sprints/$n/validation.md, só esses achados$(if ($diag) { ", e o diagnóstico $diagRel" })): passos, **Arquivos tocados:** e **Cenários:**; registre a inclusão no bloco **Decisão do stakeholder (<data> · portão):**, com **Origem:** e **Lição:** como na decisão de GAP — não em **Plano corrigido durante a execução:**, que é só erro do próprio plano (v3.65.0). Depois rode $plugin/plan.ps1 -Plan $planQ e volte em até 10 linhas.`""
        Out "  3. depois: run.ps1 next$(if ($q.Mark -eq $redQ) { " — a $($q.Id) está 🔴 ($(& $blockWhy $q.Id)): o next leva ao destravamento dela" })"
        exit 0
    }

    # A rodada focada (D): o que mudou desde a última rodada disparada — só essas frentes e os achados abertos vão ao QA.
    $revise = {
        param([string]$Reason)
        $j = $gate.judged
        $stale = @(); $kept = @()
        $codeStale = -not $j -or [string]$j.prod -ne [string]$prodNow -or [string]$j.quality -ne $(if ($qj) { [string]$qj.at } else { '' })
        $funcStale = $hasTarget -and (-not $j -or [string]$j.accept -ne $(if ($aj) { [string]$aj.at } else { '' }) -or [string]$j.scn -ne [string]$scnNow)
        if ($funcStale) { $stale += 'functional' } elseif ($hasTarget) { $kept += 'functional' }
        foreach ($fr in 'measured', 'review', 'security') { if ($codeStale) { $stale += $fr } else { $kept += $fr } }
        $openF = @($vf.Findings.Values | Where-Object { $_.state -eq 'open' } | ForEach-Object { $_.id })
        $k = & $copyProof
        Out "PRÓXIMA AÇÃO: validação do sprint $n — revisar o veredito (QA, instância nova, rodada $roundNow focada): $Reason"
        Say 'Revisão final: a qualidade está conferindo só o que a correção mudou.'
        Out "  frentes a julgar: $(if ($stale.Count) { $stale -join ', ' } else { 'nenhuma (só os achados)' }) · ficam como estavam: $(if ($kept.Count) { $kept -join ', ' } else { '—' }) · achados abertos: $(if ($openF.Count) { $openF -join ', ' } else { 'nenhum' })"
        Out "  prova da rodada: .team-project/$proofRel/ ($k arquivo(s))"
        Out "  $(Get-AgentLine 'quality-assurance')"
        $resTxt = if (Test-Path -LiteralPath (Join-Path $S 'gate')) { ', as resoluções dos donos em .team-project/sprints/' + $n + '/gate/' } else { '' }
        Out "  prompt: `"/qa sprint $n — rodada $roundNow, focada: leia $proofTxt$resTxt$diagTxt e o diff das Tasks Q-S$n. Julgue SÓ as frentes $(if ($stale.Count) { $stale -join ', ' } else { '(nenhuma — a base de todas é a mesma)' }) e os achados $(if ($openF.Count) { $openF -join ', ' } else { '(nenhum aberto)' }); $(if ($kept.Count) { "as frentes $($kept -join ', ') ficam como estavam (a base delas não mudou) — não as reabra" } else { 'todas as frentes venceram' }). Acrescente no fim de .team-project/sprints/$n/validation.md a seção ## Rodada $roundNow com a tabela | ID | Task | Achado | Onde | Cause | Owner | State | Evidência | (ID S$n-F<k>; Cause code|design|scenario|screen|requirement|environment, UMA por achado, na coluna — não dentro do ID; State open|fixed|debt|wontfix)$(if (-not $vf.HasTable) { " — o validation.md ainda está no formato anterior à v3.63.0 (achados sem a coluna Cause): reescreva nessa tabela CADA achado antigo ainda aberto, com ID S$n-F<k> novo e uma causa (o que já foi resolvido fica como está)" }) e a linha **Veredito (rodada $roundNow):** ✅ | ⚠️ | ❌ — não apague a rodada anterior. Não rode build nem o app. Volte em até 15 linhas.`""
        Out "  depois: run.ps1 next"
        exit 0
    }

    # ---------- validation.md no formato anterior à v3.63.0: o caminho de antes ----------
    # v3.64.0 (item 8 C): o diagnóstico do operator sobre o aceite também é informação nova para o veredito — no piloto, o das
    # 20:16 separava APP e PLANO, e o validation.md das 15:38 seguia valendo porque só o result.json contava.
    $diagAbs = Join-Path $Root $diagRel
    $measFiles = @($qr, $ar, $diagAbs | Where-Object { Test-Path -LiteralPath $_ })
    $newestMeas = { @($measFiles | ForEach-Object { [pscustomobject]@{ At = (Get-Item -LiteralPath $_).LastWriteTime; Diag = ($_ -eq $diagAbs) } } | Sort-Object At -Descending) }
    if (-not $vf.HasTable) {
        $nm = @(& $newestMeas)
        if ($nm.Count -and $nm[0].At -gt $valAt) { & $revise $(if ($nm[0].Diag) { 'o diagnóstico do aceite é mais novo que o validation.md' } else { 'a medição é mais nova que o validation.md' }) }
        # v3.64.0 (item 8 B): com uma correção aberta, os achados vão para ela.
        if ($qsOpen.Count) { & $toOpenQ "os achados 'Volta para: dev' do validation.md" "os números dos achados 'Volta para: dev' da última rodada do validation.md" }
        $qs = @($qsRows | ForEach-Object { $_.Id })
        $qid = if (-not $qs.Count) { "Q-S$n" } else { $sfx = @($qs | ForEach-Object { if ($_ -match '([a-z])$') { [int][char]$Matches[1] } else { [int][char]'a' } } | Sort-Object -Descending)[0]; "Q-S$n" + [char]($sfx + 1) }
        Out "PRÓXIMA AÇÃO: abrir $qid — correção do portão (validation.md: veredito $vv, sem decisão do PO; formato anterior à v3.63.0, sem a tabela de achados com Cause)"
        Say $(if ($vv -eq $E.Warn) { 'A revisão final encontrou pontos a melhorar. O dono do produto decide se aceita como pendência para depois; se não, abro uma tarefa de correção.' } else { 'A revisão final encontrou problemas que precisam de correção antes da apresentação; abrindo uma tarefa de correção.' })
        Out "  1. a sessão grava a linha da $qid no quadro, seção '## Correção do portão — sprint $n' (a tabela das Histórias: ID, Task, Est., Dono, Depende de, Plano, Evidência, Cenários…), marcador $todoMk, com os achados 'Volta para: dev' do validation.md"
        Out "  2. achado com 'Volta para: Arquiteto' → /arc question (instância nova) com o caminho do validation.md"
        Out "  3. depois: run.ps1 next — o Arquiteto escreve o plano de correção (template fix-plan ou plano enxuto) e o executor de Task conduz a $qid; fechada, o operator mede de novo e o QA revisa o veredito. O ✅ das Tasks originais não muda (R25)"
        if ($vv -eq $E.Warn) { Set-AskRoute $Root 'portao' $sid 'veredito ⚠️ do portão: o PO aceita como dívida (formulário)'; Out "  ⚠️ que o PO aceita como dívida (formulário): a sessão grava no validation.md **Decisão do PO:** aceito com dívida — <motivo e onde a dívida está registrada>; com ela o portão passa (❌ nunca passa)" }
        exit 0
    }

    # ---------- F · rota por causa ----------
    $open = @($vf.Findings.Values | Where-Object { $_.state -eq 'open' })
    $bad = @($open | Where-Object { -not $_.cause -or $_.cause.StartsWith('?') -or $script:Causes -notcontains $_.cause -or $_.cause -in 'appearance', 'process' })
    if ($bad.Count) {
        Out "PRÓXIMA AÇÃO: validação do sprint $n — o QA classifica $(($bad | ForEach-Object { "$($_.id) ($(if ($_.cause) { $_.cause } else { 'sem causa' }))" }) -join ', ') (instância nova; sem a causa não há dono)"
        Out "  $(Get-AgentLine 'quality-assurance')"
        Out "  prompt: `"/qa sprint $n — em .team-project/sprints/$n/validation.md, os achados $(($bad | ForEach-Object { $_.id }) -join ', ') estão sem causa válida. Dê a cada um UMA causa na coluna Cause da tabela de achados: code (o app não faz o que a especificação diz), design (o plano está errado), scenario (o .scn está errado), screen (a tela não previa o caso), requirement (o critério está confuso ou mudou), environment (alvo, massa, configuração). Só isso: não refaça o julgamento nem rode nada. Volte em até 5 linhas.`""
        exit 0
    }
    # Ambiente que o QA ainda registrou (A): reparo e repetição do aceite — nunca Q-S<n>.
    $envF = @($open | Where-Object { $_.cause -eq 'environment' -and -not (& $resolved $_.id) })
    if ($envF.Count -and $hasTarget) {
        Out "PRÓXIMA AÇÃO: validação do sprint $n — $(($envF | ForEach-Object { $_.id }) -join ', ') de ambiente: reparar o alvo e repetir o aceite (operator); não abre Q-S$n"
        Out "  $(Get-AgentLine 'operator')"
        Out "  prompt: `"Chamador: sessão $sid — Rode na raiz: $plugin/target.ps1 -Target $tn -Repair e $plugin/accept.ps1 -Task $sid -Resume. Depois grave .team-project/sprints/$n/gate/<ID>.md para $(($envF | ForEach-Object { $_.id }) -join ', ') com a linha **Resolution:** done — <o que o reparo resolveu e o resumo do accept>. Devolva o caminho do result.md e a linha de resumo.`""
        Out "  depois: run.ps1 next"
        exit 0
    }
    $owners = @{ requirement = @('product-owner', '/po', 'requisito'); screen = @('user-experience', '/ux', 'tela'); design = @('architect', '/arc question', 'desenho'); scenario = @('quality-assurance', '/qa', 'cenário') }
    foreach ($c in @($script:CauseOrder | Where-Object { $_ -ne 'code' })) {
        $items = @($open | Where-Object { $_.cause -eq $c -and -not (& $resolved $_.id) })
        if (-not $items.Count) { continue }
        $o = $owners[$c]
        foreach ($it in $items) { $gate.routed[$it.id] = [int]$(if ($gate.routed.Contains($it.id)) { $gate.routed[$it.id] } else { 0 }) + 1 }
        Set-GateState $S $gate
        $again = @($items | Where-Object { [int]$gate.routed[$_.id] -gt 2 })
        if ($again.Count) {
            Set-AskRoute $Root 'portao' $sid "$($o[2]): $($o[1]) disparado 2 vezes sem uma resolução que se sustente para $(($again | ForEach-Object { $_.id }) -join ', ')"
            Out "PRÓXIMA AÇÃO: formulário ao stakeholder — $(($again | ForEach-Object { $_.id }) -join ', ') ($($o[2])) sem resolução que se sustente depois de 2 disparos de $($o[1]) (sem gravar, ou a rodada seguinte manteve o achado aberto): decidir à mão (gravar .team-project/sprints/$n/gate/<ID>.md) ou aceitar como dívida"
            exit 0
        }
        # v3.65.5: a resolução que a rodada seguinte desmentiu vai no prompt — o dono não repete a mesma correção.
        $staleTxt = { param($id) $r = & $effRes $id; if ($r -and $r.value -and $r.stale) { " [a resolução anterior ($($r.value): $(& $short $r.text)) não se sustentou: a última rodada do validation.md manteve o achado aberto — corrija de outro jeito]" } else { '' } }
        $list = ($items | ForEach-Object { "$($_.id) ($($_.task)): $(& $short $_.text)$(& $staleTxt $_.id)" }) -join '; '
        $resLine = "grave, para cada achado, .team-project/sprints/$n/gate/<ID>.md com a linha **Resolution:** done|code$(if ($c -eq 'requirement') { '|debt' }) — <o que decidiu ou mudou> (done = resolvido sem mudar o app; code = o app precisa mudar, e a Q-S$n vai citar o achado$(if ($c -eq 'requirement') { '; debt = aceito como dívida, com o lugar no Product Backlog' })). Com code, se depois da mudança do app o .scn também precisa mudar, acrescente a linha **Scenario:** <os SC e o que muda em cada um> — o portão manda o QA aplicá-la quando a Q-S$n fechar, antes da rodada nova (v3.65.5)"
        Out "PRÓXIMA AÇÃO: validação do sprint $n — $($o[2]): $(($items | ForEach-Object { $_.id }) -join ', ') → $($o[1]) (instância nova; ordem requirement → screen → design → scenario → code)"
        Say $(switch ($c) { 'requirement' { 'A revisão final achou um ponto de regra ou de critério: o dono do produto vai decidir.' } 'screen' { 'A revisão final achou um caso que a tela não previa: o UX vai ajustar a especificação da tela.' } 'design' { 'A revisão final achou um ponto de desenho técnico: o arquiteto vai decidir.' } default { 'A revisão final achou um teste desatualizado: a qualidade vai corrigir o teste.' } })
        if ($c -eq 'requirement') { Set-AskRoute $Root 'portao' $sid 'achado de requisito do portão: o PO decide; o que for do stakeholder vem em formulário' }
        Out "  $(Get-AgentLine $o[0])"
        $task = switch ($c) {
            'requirement' { "decida cada achado de requisito do portão do sprint ${n}: $list. O que é decisão do stakeholder (muda o que o usuário vê ou faz, ou o escopo), devolva na primeira linha STAKEHOLDER: <a pergunta e as opções> — a sessão leva em formulário e grava a resolução com a resposta" }
            'screen' { "revise a especificação da tela de cada achado do portão do sprint ${n}: $list. Acrescente o caso que faltou (estado, layout, fluxo) na especificação da tela, sem mudar o app" }
            'design' { "decida cada achado de desenho do portão do sprint ${n}: $list. A decisão fica registrada (architect/decisions/S$n.md); correção no app vai na Q-S$n, com o plano de correção" }
            default { "corrija o .scn de cada achado de cenário do portão do sprint ${n}: $list. Só o cenário citado; rode $plugin/accept.ps1 -ParseOnly; o operator mede de novo só esse cenário" }
        }
        Out "  prompt: `"$($o[1]) — $task. Leia .team-project/sprints/$n/validation.md (só os achados citados) e a prova em .team-project/sprints/$n/proof/$sid/. Depois, $resLine. Volte em até 15 linhas.`""
        Out "  depois: run.ps1 next"
        exit 0
    }
    # code: os achados de código e os que o dono resolveu como 'code' — cada um citado por uma Q-S<n> do quadro.
    $codeF = @($open | Where-Object { $_.cause -eq 'code' -or ($(& $resolved $_.id) -and (& $effRes $_.id).value -eq 'code') })
    # v3.65.5 · a metade do teste: a resolução code que também muda o .scn, com a(s) Q-S que a cobrem fechada(s) → o QA aplica a
    # parte do cenário ANTES da rodada nova (no piloto, o S6-F10 e o S6-F15 ficaram com o app pronto e o .scn antigo).
    $scnHalf = @($codeF | Where-Object { $cov = @(& $qsOf $_.id); $cov.Count -and -not @($cov | Where-Object { $_.Mark -ne $E.Done }).Count -and (Get-FindingScenarioPart $S $_.id).need })
    if ($scnHalf.Count) {
        foreach ($it in $scnHalf) { $k5 = "$($it.id)/scn"; $gate.routed[$k5] = [int]$(if ($gate.routed.Contains($k5)) { $gate.routed[$k5] } else { 0 }) + 1 }
        Set-GateState $S $gate
        $againS = @($scnHalf | Where-Object { [int]$gate.routed["$($_.id)/scn"] -gt 2 })
        if ($againS.Count) {
            Set-AskRoute $Root 'portao' $sid "cenário: /qa disparado 2 vezes sem aplicar a parte do .scn de $(($againS | ForEach-Object { $_.id }) -join ', ')"
            Out "PRÓXIMA AÇÃO: formulário ao stakeholder — $(($againS | ForEach-Object { $_.id }) -join ', ') (parte do cenário da correção) sem a linha **Scenario applied:** depois de 2 disparos do /qa: aplicar à mão (o .scn e a linha no gate/<ID>.md) ou aceitar como dívida"
            exit 0
        }
        $listS = ($scnHalf | ForEach-Object { $qq = (@(& $qsOf $_.id) | ForEach-Object { $_.Id }) -join ', '; "$($_.id) ($($_.task); o app já mudou na $qq): $(& $short (Get-FindingScenarioPart $S $_.id).text)" }) -join '; '
        Out "PRÓXIMA AÇÃO: validação do sprint $n — cenário: aplicar a parte do .scn de $(($scnHalf | ForEach-Object { $_.id }) -join ', ') → /qa (instância nova; a correção do app fechou, o teste ainda é o antigo — sem isso a rodada nova julgaria o mesmo .scn, v3.65.5)"
        Say 'A correção no app ficou pronta; agora a qualidade ajusta os testes que dependiam dela, antes de testar de novo.'
        Out "  $(Get-AgentLine 'quality-assurance')"
        Out "  prompt: `"/qa — aplique a parte do cenário da correção do portão do sprint ${n}: $listS. Só os cenários citados; rode $plugin/accept.ps1 -ParseOnly. Depois acrescente em .team-project/sprints/$n/gate/<ID>.md, sem apagar a linha **Resolution:**, a linha **Scenario applied:** <data> — <os SC e o que mudou em cada um>. O operator mede de novo só o que mudou. Volte em até 10 linhas.`""
        Out "  depois: run.ps1 next"
        exit 0
    }
    # v3.65.5: a Q-S que fechou e já foi julgada não cobre mais o achado code que segue aberto — ele precisa de correção nova.
    # O achado com resolução code que ainda vale (gravada ou completada depois da última rodada) segue coberto pela Q-S dele.
    $uncovered = @($codeF | Where-Object { if (& $resolved $_.id) { -not @(& $qsOf $_.id).Count } else { -not @(& $qsLive $_.id).Count } })
    if ($uncovered.Count -and $qsOpen.Count) { & $toOpenQ "$(($uncovered | ForEach-Object { $_.id }) -join ', ') (causa code)" "os IDs $(($uncovered | ForEach-Object { $_.id }) -join ', ')" }
    if ($uncovered.Count) {
        $qs = @($qsRows | ForEach-Object { $_.Id })
        $qid = if (-not $qs.Count) { "Q-S$n" } else { $sfx = @($qs | ForEach-Object { if ($_ -match '([a-z])$') { [int][char]$Matches[1] } else { [int][char]'a' } } | Sort-Object -Descending)[0]; "Q-S$n" + [char]($sfx + 1) }
        Out "PRÓXIMA AÇÃO: abrir $qid — correção do portão: $(($uncovered | ForEach-Object { $_.id }) -join ', ') (causa code)"
        Say 'A revisão final encontrou problemas no app que precisam de correção antes da apresentação; abrindo uma tarefa de correção.'
        Out "  1. a sessão grava a linha da $qid no quadro, seção '## Correção do portão — sprint $n' (a tabela das Histórias: ID, Task, Est., Dono, Depende de, Plano, Evidência, Cenários…), marcador $todoMk, com os IDs $(($uncovered | ForEach-Object { $_.id }) -join ', ') na coluna Task (é por eles que o portão sabe o que a $qid corrige)"
        Out "  2. depois: run.ps1 next — o Arquiteto escreve o plano de correção e o executor de Task conduz a $qid; fechada, o operator mede de novo só o que ela mudou e o QA revisa só o que venceu. O ✅ das Tasks originais não muda (R25)"
        if ($vv -eq $E.Warn) { Set-AskRoute $Root 'portao' $sid 'veredito ⚠️ do portão: o PO aceita como dívida (formulário)'; Out "  ⚠️ que o PO aceita como dívida (formulário): a sessão grava no validation.md **Decisão do PO:** aceito com dívida — <motivo e onde a dívida está registrada>; com ela o portão passa (❌ nunca passa)" }
        exit 0
    }
    # Tudo roteado: há resolução, Q-S fechada ou medição nova depois do veredito → o QA revisa (rodada focada).
    $newer = @()
    $nm = @(& $newestMeas)
    if ($nm.Count -and $nm[0].At -gt $valAt) { $newer += $(if ($nm[0].Diag) { 'diagnóstico novo do aceite' } else { 'medição nova' }) }
    if (@($open | Where-Object { $r = Get-FindingResolution $S $_.id; $r -and $r.value -and $r.at -gt $valAt }).Count) { $newer += 'resoluções dos donos' }
    # v3.65.5: só a Q-S fechada que nenhuma rodada julgou ainda — antes contava toda Q-S ✅, e o next abria rodada após rodada
    # com o mesmo app e o mesmo .scn.
    if (@($codeF | ForEach-Object { & $qsOf $_.id } | Where-Object { $_.Mark -eq $E.Done -and -not (& $qsJudged $_) }).Count) { $newer += 'Q-S fechada' }
    # v3.64.0 (item 8 B): a correção que cobre os achados está em 🔴 — ela só reabre por ação de alguém; "esperar" deixaria o
    # watcher olhando uma Task parada. Vai à rota do bloqueio dela. v3.64.1: ANTES da rodada focada — a medição ou a resolução
    # mais nova que o veredito mandava o QA julgar de novo o código parcial da correção parada, e esta rota nunca chegava.
    $redCover = @($codeF | ForEach-Object { & $qsOf $_.id } | Where-Object { $_.Mark -eq $redQ -and -not $supersededBy.ContainsKey($_.Id) } | Sort-Object Id -Unique)
    if ($redCover.Count) { & $redRoute $redCover "os achados abertos do portão do sprint $n dependem dela(s): " }
    if ($newer.Count -or -not $open.Count) { & $revise $(if ($newer.Count) { $newer -join ' · ' } else { 'nenhum achado aberto, veredito ainda não aprovado' }) }
    Out "PRÓXIMA AÇÃO: esperar — os achados abertos do portão do sprint $n já têm dono: $(($open | ForEach-Object { "$($_.id) ($($_.cause))" }) -join ', '); a Q-S$n que os corrige ainda não fechou"
    exit 3
}
