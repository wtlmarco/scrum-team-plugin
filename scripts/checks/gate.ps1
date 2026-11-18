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
    $aFresh = (-not $hasTarget) -or ($aj -and (& $sameBase $aj) -and $aScnOk -and -not $aEnv -and -not $aCfg)
    $gate = Get-GateState $S
    $val = Join-Path $S 'validation.md'; $vv = Get-VerdictOf $val
    # v3.52.2 (C6): ⚠️ com "**Decisão do PO:** aceito com dívida — …" passa o portão; ❌ nunca.
    $poDebt = ($vv -eq $E.Warn) -and (Test-PoDebt $val)
    if ($vv -eq $E.Done -or $poDebt) { return }
    $short = { param($t) $x = (([string]$t -replace '["|]', "'") -replace '\s+', ' ').Trim(); if ($x.Length -gt 200) { $x.Substring(0, 200) + '…' } else { $x } }

    # ---------- A · o accept que parou no ambiente não é medição ----------
    if ($hasTarget -and $aj -and ($aCfg -or $aEnv) -and (& $sameBase $aj) -and $aScnOk) {
        if (-not $aCfg -and [string]$gate.env.at -ne [string]$aj.at) { $gate.env.attempts = [int]$gate.env.attempts + 1; $gate.env.at = [string]$aj.at; Set-GateState $S $gate }
        $why = & $short $(if ($aCfg) { "CONFIGURAÇÃO DO ALVO: $aCfg" } else { $aEnv })
        if ($aCfg -or [int]$gate.env.attempts -ge 2) {
            Set-AskRoute $Root 'ambiente' $sid $why
            if ([string]$gate.env.asked -ne [string]$aj.at) {
                Add-RunLog $S $n $sid "portão: o aceite parou no ambiente $(if ($aCfg) { '(configuração do alvo)' } else { "pela $($gate.env.attempts)ª vez seguida" }) → stakeholder (formulário); sem QA, sem Q-S$n, sem Arquiteto" $why "accept/$n/$sid/result.md"
                $gate['env']['asked'] = [string]$aj.at; Set-GateState $S $gate
            }
            Out "PRÓXIMA AÇÃO: formulário ao stakeholder — o aceite do portão do sprint $n parou no ambiente $(if ($aCfg) { '(configuração do alvo)' } else { "pela $($gate.env.attempts)ª vez seguida, depois do reparo" }): $why"
            Out "  não é veredito: o QA não julga, nenhuma Q-S$n abre e o Arquiteto não entra (v3.63.0). Opções ao stakeholder: ele repara o alvo ou ajusta guards.json / a massa de dados e a sessão roda run.ps1 next (o aceite retoma com -Resume); ou segue esperando."
            Say "A revisão final parou porque o aparelho de teste não funcionou$(if ($aCfg) { ' como está configurado' } else { ' duas vezes seguidas' }). Não é defeito do app: preciso de você para decidir como seguir."
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
    if ([int]$gate.env.attempts) { $gate.env.attempts = 0; $gate.env.at = ''; Set-GateState $S $gate }

    # ---------- C/D · medir só o que venceu ----------
    if (-not $qFresh -or -not $aFresh) {
        $cmds = @(); $whyM = @()
        if (-not $qFresh) { $cmds += "$plugin/quality.ps1 -Id $sid"; $whyM += $(if ($qj) { 'qualidade: o código de produção mudou' } else { 'qualidade: sem medição' }) }
        if (-not $aFresh) {
            $cmds += "$plugin/accept.ps1 -Task $sid -Resume"
            $whyM += $(if (-not $aj) { 'aceite: sem medição' } elseif (-not $aScnOk) { 'aceite: os cenários mudaram' } else { 'aceite: o código de produção mudou' })
        }
        Out "PRÓXIMA AÇÃO: validação do sprint $n — medir (operator, comandos longos fora das instâncias caras; C3): $($whyM -join ' · ')"
        Say $(if (-not $qj -and -not $aj) { 'Todas as partes do sprint estão prontas. Começou a revisão final: rodando todos os testes do app.' } else { 'Revisão final: medindo de novo só o que a correção mudou.' })
        Out "  $(Get-AgentLine 'operator')"
        Out ("  prompt: `"Chamador: sessão $sid — Rode na raiz: " + ($cmds -join ' e ') + $(if (-not $aFresh) { ' (o -Resume reaproveita os cenários que já passaram com o mesmo app instalado e o mesmo texto de cenário)' } else { '' }) + ". Exit 4 = ambiente: rode target.ps1 -Repair uma vez e repita. Devolva os caminhos dos result.md e as linhas de resumo.`"")
        Out "  depois: run.ps1 next"
        exit 0
    }

    # A rodada em curso e a prova que o QA vai julgar (H).
    $verdicts = if (Test-Path -LiteralPath $val) { @([regex]::Matches((Read-Text $val), '(?m)^\*\*Veredito[^*\r\n]*:\*\*')).Count } else { 0 }
    $roundNow = $verdicts + 1
    $proofRel = "sprints/$n/proof/$sid/round-$roundNow"
    $copyProof = {
        $pd = Join-Path $S "proof/$sid/round-$roundNow"
        $k = Copy-Proof $qDir (Join-Path $pd 'quality'); if ($hasTarget) { $k += Copy-Proof $aDir (Join-Path $pd 'accept') }
        $gate.proof = $roundNow
        $gate.round = $roundNow
        $gate.judged = [ordered]@{ prod = [string]$prodNow; scn = [string]$scnNow; accept = $(if ($aj) { [string]$aj.at } else { '' }); quality = $(if ($qj) { [string]$qj.at } else { '' }) }
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
        Out "  prompt: `"/qa sprint $n — leia $proofTxt$dpRel, os planos e o diff do sprint. Julgue SOLID, clean code, aderência à arquitetura e aos planos, padrões e segurança, citando standards/ (Q<n>). Escreva .team-project/sprints/$n/validation.md com o veredito e $fmt — cada achado com UMA causa, que decide o dono; cite a prova pelos caminhos de proof/. Não rode build nem o app. Volte em até 15 linhas.`""
        exit 0
    }

    $vf = Read-ValidationFindings $val
    $valAt = (Get-Item -LiteralPath $val).LastWriteTime
    $qsRows = @($tasks | Where-Object { $_.Id -match "^Q-S$n([a-z]?)$" })
    $boardTxt = if (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md')) { Read-Text (Join-Path $S 'sprint-backlog.md') } else { '' }
    $qsOf = { param($fid) @($qsRows | Where-Object { $q = $_; @(($boardTxt -split "`r?`n") | Where-Object { $_ -match '^\s*\|' -and $_.Contains($q.Id) -and $_.Contains($fid) }).Count }) }

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
        Out "  prompt: `"/qa sprint $n — rodada $roundNow, focada: leia $proofTxt$resTxt e o diff das Tasks Q-S$n. Julgue SÓ as frentes $(if ($stale.Count) { $stale -join ', ' } else { '(nenhuma — a base de todas é a mesma)' }) e os achados $(if ($openF.Count) { $openF -join ', ' } else { '(nenhum aberto)' }); $(if ($kept.Count) { "as frentes $($kept -join ', ') ficam como estavam (a base delas não mudou) — não as reabra" } else { 'todas as frentes venceram' }). Acrescente no fim de .team-project/sprints/$n/validation.md a seção ## Rodada $roundNow com a tabela | ID | State | Evidência | (State open|fixed|debt|wontfix; achado novo com ID novo e Cause) e a linha **Veredito (rodada $roundNow):** ✅ | ⚠️ | ❌ — não apague a rodada anterior. Não rode build nem o app. Volte em até 15 linhas.`""
        Out "  depois: run.ps1 next"
        exit 0
    }

    # ---------- validation.md no formato anterior à v3.63.0: o caminho de antes ----------
    if (-not $vf.HasTable) {
        $measAt = @($qr, $ar | Where-Object { Test-Path -LiteralPath $_ } | ForEach-Object { (Get-Item -LiteralPath $_).LastWriteTime } | Sort-Object -Descending)
        if ($measAt.Count -and $measAt[0] -gt $valAt) { & $revise 'a medição é mais nova que o validation.md' }
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
    $envF = @($open | Where-Object { $_.cause -eq 'environment' -and -not (Get-FindingResolution $S $_.id) })
    if ($envF.Count -and $hasTarget) {
        Out "PRÓXIMA AÇÃO: validação do sprint $n — $(($envF | ForEach-Object { $_.id }) -join ', ') de ambiente: reparar o alvo e repetir o aceite (operator); não abre Q-S$n"
        Out "  $(Get-AgentLine 'operator')"
        Out "  prompt: `"Chamador: sessão $sid — Rode na raiz: $plugin/target.ps1 -Target $tn -Repair e $plugin/accept.ps1 -Task $sid -Resume. Depois grave .team-project/sprints/$n/gate/<ID>.md para $(($envF | ForEach-Object { $_.id }) -join ', ') com a linha **Resolution:** done — <o que o reparo resolveu e o resumo do accept>. Devolva o caminho do result.md e a linha de resumo.`""
        Out "  depois: run.ps1 next"
        exit 0
    }
    $owners = @{ requirement = @('product-owner', '/po', 'requisito'); screen = @('user-experience', '/ux', 'tela'); design = @('architect', '/arc question', 'desenho'); scenario = @('quality-assurance', '/qa', 'cenário') }
    foreach ($c in @($script:CauseOrder | Where-Object { $_ -ne 'code' })) {
        $items = @($open | Where-Object { $_.cause -eq $c -and -not ((Get-FindingResolution $S $_.id) -and (Get-FindingResolution $S $_.id).value) })
        if (-not $items.Count) { continue }
        $o = $owners[$c]
        foreach ($it in $items) { $gate.routed[$it.id] = [int]$(if ($gate.routed.Contains($it.id)) { $gate.routed[$it.id] } else { 0 }) + 1 }
        Set-GateState $S $gate
        $again = @($items | Where-Object { [int]$gate.routed[$_.id] -gt 2 })
        if ($again.Count) {
            Set-AskRoute $Root 'portao' $sid "$($o[2]): $($o[1]) disparado 2 vezes sem gravar a resolução de $(($again | ForEach-Object { $_.id }) -join ', ')"
            Out "PRÓXIMA AÇÃO: formulário ao stakeholder — $(($again | ForEach-Object { $_.id }) -join ', ') ($($o[2])) sem resolução depois de 2 disparos de $($o[1]): decidir à mão (gravar .team-project/sprints/$n/gate/<ID>.md) ou aceitar como dívida"
            exit 0
        }
        $list = ($items | ForEach-Object { "$($_.id) ($($_.task)): $(& $short $_.text)" }) -join '; '
        $resLine = "grave, para cada achado, .team-project/sprints/$n/gate/<ID>.md com a linha **Resolution:** done|code$(if ($c -eq 'requirement') { '|debt' }) — <o que decidiu ou mudou> (done = resolvido sem mudar o app; code = o app precisa mudar, e a Q-S$n vai citar o achado$(if ($c -eq 'requirement') { '; debt = aceito como dívida, com o lugar no Product Backlog' }))"
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
    $codeF = @($open | Where-Object { $_.cause -eq 'code' -or ((Get-FindingResolution $S $_.id) -and (Get-FindingResolution $S $_.id).value -eq 'code') })
    $uncovered = @($codeF | Where-Object { -not @(& $qsOf $_.id).Count })
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
    $measAt = @($qr, $ar | Where-Object { Test-Path -LiteralPath $_ } | ForEach-Object { (Get-Item -LiteralPath $_).LastWriteTime } | Sort-Object -Descending)
    if ($measAt.Count -and $measAt[0] -gt $valAt) { $newer += 'medição nova' }
    if (@($open | Where-Object { $r = Get-FindingResolution $S $_.id; $r -and $r.value -and $r.at -gt $valAt }).Count) { $newer += 'resoluções dos donos' }
    if (@($codeF | ForEach-Object { & $qsOf $_.id } | Where-Object { $_.Mark -eq $E.Done }).Count) { $newer += 'Q-S fechada' }
    if ($newer.Count -or -not $open.Count) { & $revise $(if ($newer.Count) { $newer -join ' · ' } else { 'nenhum achado aberto, veredito ainda não aprovado' }) }
    Out "PRÓXIMA AÇÃO: esperar — os achados abertos do portão do sprint $n já têm dono: $(($open | ForEach-Object { "$($_.id) ($($_.cause))" }) -join ', '); a Q-S$n que os corrige ainda não fechou"
    exit 3
}
