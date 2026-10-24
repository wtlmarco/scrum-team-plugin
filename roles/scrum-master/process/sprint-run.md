# `/sm sprint run` — roteiro da execução do sprint

> **Dono:** SM · **Fonte única do `run`** (v3.34; reescrito na v3.51; sessão curta, espera sem sondagem e registro de decisões na v3.52). Lido **só** quando `commands/sm.md` entra no modo `sprint run`. Contexto do ciclo: [`workflow-sprint.md` §5g](workflow-sprint.md) · regras R1, R12, R20, R22, R25, R27, R28.
> **v3.51 — a sessão não decide o próximo passo relendo este roteiro: pergunta ao script.** `scripts/checks/run.ps1 next` lê o quadro e o disco e devolve a próxima ação pronta (papel, modelo, prompt curto com os caminhos, o comando de volta). Medido no benchmark: a sessão principal era 35 % do custo do sprint, a 274 mil tokens por chamada; com a orquestração em script, o coordenador do protótipo custou 6 %.

**Quem executa.** A **sessão** que recebeu `/sm sprint run` orquestra: roda `run.ps1`, dispara o papel que ele indica e volta ao script. O Agent `scrum-master` só entra quando o fechamento pede julgamento (passo 7).

**Sessão curta, aberta limpa (v3.52 · R29).** O `run` corre em sessões curtas — **uma Task por sessão** é o alvo (contexto de ~50 a 80 mil tokens em vez de 300 a 400 mil; no P-r1 a sessão era 67 % do custo do `run`, mediana de 376 mil tokens por chamada). **Leitura de abertura, fixa e nada além dela:** (1) o cartão de passagem que o prompt traz — o `README.md` do projeto (§1 a §5 e §7) só se o cartão não bastar; (2) `.team-project/scrum-master/context.md`; (3) `sprints/<n>/sprint-backlog.md` (o pacote aprovado e o quadro); (4) **`run.ps1 next`**, que devolve o resto. O `run-log.md` **não** é leitura de abertura: só em retomada, bloqueio e Review (§Registro de decisões). **Fecho:** na parada permitida (§Pausa segura), a sessão diz, em uma linha, o próximo passo **em sessão nova (`/clear` e `/sm sprint run`)**; no fim da fila, o formulário de §Ao fim da fila e `/clear` e `/sm sprint review`.

## O sprint, em seis etapas

| # | Etapa | Quem | O que o `run.ps1 next` devolve |
|---|---|---|---|
| 1 | **Preparo da construção**, por História (passo próprio do `next`, **sequencial**: o preparo de História independente não corre ao lado do dev) | QA, depois Arquiteto | cenários executáveis que faltam (`.team-project/quality-assurance/scenarios/<H-ID>.scn`, linguagem do `accept.ps1`) e, com eles prontos, **os planos de todas as Tasks da História numa instância do Arquiteto** (template enxuto, regras 22 a 25). Cada plano passa pelo `plan.ps1` antes do dev. **O plano é construção** (decisão do stakeholder, 2026-10-21): conta no custo do sprint. v3.51.4: as Tasks ⬜ da História vão a 🟦 quando o preparo dela começa (o próprio `next` marca); **sem `targets` no `guards.json` não há `.scn`** — o `accept.ps1` não roda, e os cenários ficam rastreados nos planos e provados por teste |
| 2 | **Construção**, Task a Task (R1) | dev | `run.ps1 start -Task <ID>`: escopo e marcador (`dispatch.ps1`), cartão de passagem e o prompt. O dev constrói, roda `verify` (focado, completo, mutação se o plano a declara) e **os cenários da Task no alvo real** (`accept.ps1 -Task <ID> -Only <cenários>`), e **corrige sozinho** o que falhar. Dúvida de desenho → 🔺 GAP. `verify` com **exit 3 = parcial**: o tempo da chamada acabou (limite de 10 min da ferramenta); o **mesmo comando**, de novo, continua de onde parou |
| 3 | **Fechamento da Task** | script | `run.ps1 done -Task <ID> -Result ok`: confere com o `close.ps1` (sem `-Apply`); fecha → marca 🟪 e roda o `close.ps1 -Apply`, que fecha **pela evidência do dev** (R7, R7-verify, R7-mutação, R7-aceite, R12 "a consolidar"). Não fecha → a Task fica em 🟨 e volta ao dev em **instância nova, em primeiro plano**, com o cartão de passagem e o que falta (§Retomada). Fechada → o script faz o **commit do código da Task** (passo 7) e grava o **`.team-project/.safe-point`**: **parada permitida** (§Pausa segura) |
| 4 | **Validação do sprint** — o portão do QA | operator, depois QA | o `operator` mede (`quality.ps1 -Id S<n>` e `accept.ps1 -Task S<n>`, todos os cenários, com captura); o QA, numa passada só, julga código e produto e escreve `sprints/<n>/validation.md` ([`templates/sprint-validation.md`](../../quality-assurance/templates/sprint-validation.md)) |
| 5 | **Correção dos achados** | dev (dúvida → Arquiteto) | um dev por grupo de achados; depois o `operator` mede de novo e o QA, em instância nova, revisa o veredito |
| 6 | **Consolidação dos documentos vivos** (R12, A5) e fim da fila | Arquiteto, uma vez | as seções "Documentos vivos (R12)" dos relatórios viram o SDD técnico atualizado (`sprints/<n>/docs-consolidation.md`); depois, o formulário de autorização da Review (§Ao fim da fila) |

**Por que assim** (benchmark de 2026-10, `plano-plugin-p-plus.md`): no P-r6 o Arquiteto planejou Task a Task no caminho crítico (41 % do custo, 632 min) e o QA reverificou cada Task (13 instâncias); o dev em Haiku custou 3 %. No protótipo do benchmark, o executor que repetia build e navegação depois do construtor nunca achou defeito real. O plano por História, a verificação pelo próprio dev e um portão só no fim cortam as releituras sem tirar nenhuma verificação.

## Pré-condições — conferidas antes de disparar o primeiro agente

Falhou qualquer uma: **pare e reporte** — não peça nada ao stakeholder aqui.

1. **Pacote aprovado** no Sprint Backlog (data, quem aprovou, decisão e ponteiro do protótipo navegado; com `bench` ligado, "navegação simulada (benchmark)" vale). Sem isso, nenhuma Task entra em construção (R20 · R25).
2. **`<T-ID>` no backlog**, na forma `sprint run <T-ID>`, com História e estimativa. Task fora do quadro entra antes como entrada fora da Planning ([`workflow-sprint.md` §5e](workflow-sprint.md)).
3. **Task com cenários mapeados** (R30, DoR). A etapa 1 transforma os mapeados em executáveis.
4. **Alvo pronto** quando o projeto tem `guards.json → targets`: `scripts/checks/target.ps1 -Target <alvo> -Repair` uma vez no início (emulador desenhando a tela, site no ar). Falha de ambiente não é defeito de ninguém: bloqueio de ambiente com a ação para o stakeholder.

**Run ativo (v3.44 · G14).** Conferidas as pré-condições, antes do primeiro agente, a sessão grava `.team-project/.active-run` — `{ "trilha": "sprint", "id": "<n>", "desde": "<aaaa-mm-dd hh:mm>" }`. A G14 libera aos papéis o operacional e nega o que está fora da lista, sem pedido de permissão parando o run. A sessão **apaga o marcador em toda parada legítima**.

## Ordem da fila e retomada

- **Ordem:** por dependência declarada no Sprint Backlog. Task com dependência não satisfeita é pulada e retomada quando destravar. O `run.ps1 next` já aplica a ordem.
- **Retomada:** o `run` nunca replaneja Task que já tem plano; entra no passo que o marcador e o disco indicam (o `run.ps1 next` lê os dois). Sessão que reabre com `.active-run` retoma a fila no primeiro turno (o `SessionStart` manda; v3.51).
- **Paradas legítimas — lista fechada:** **(a)** fim da fila → formulário de autorização da Review; **(b)** bloqueio que o degrau 1 não fechou **e** nenhuma Task elegível → formulário de R22; **(c)** pré-condição falha; **(d)** interrupção pelo stakeholder; **(e)** pausa pedida pelo stakeholder, no ponto seguro (§Pausa segura, v3.51.4); **(f)** **ponto seguro** — `.team-project/.safe-point` gravado pelo `run.ps1 done` que fechou a Task (v3.52, §Pausa segura): a sessão **pode** parar, e a próxima continua pelo `.active-run` e por `run.ps1 next`. **Fora do `.safe-point`, fim de Task não é ponto de parada por iniciativa da sessão**; "sigo?", "marco natural", tamanho da fila e consumo de tokens também não. A guarda **G20** (hook `Stop`, v3.51) barra o fim de turno com Task elegível e `.active-run` gravado, **exceto com o `.safe-point` presente** (v3.52); não há mais agente em segundo plano a esperar (§Disparo). O limite de uso da conta não é parada da sessão — o harness corta o turno (§Retomada após limite de uso); a G20 não barra esse turno.
- **Bloqueio:** a Task vai a 🔴 (`mark.ps1 -To blocked`) e ao degrau 1 (PO e Arquiteto); a fila **segue** nas independentes. Só o que o degrau 1 não fecha sobe ao stakeholder, na forma de R22 e do H1 ([`templates/stakeholder-question.md`](../templates/stakeholder-question.md)).
- **Falha de ambiente** (`verify` ou `accept` com exit 4, v3.51): não é defeito; nenhum papel caro depura ambiente. `run.ps1 done -Result env` dá a rota: `target.ps1 -Repair` uma vez, o mesmo dev retoma; sem reparo, bloqueio de ambiente.
- **Invocação interrompida sem ação do stakeholder (R27):** confira energia do SO e o transcript do subagente, classifique a causa e retome — pelo §Retomada.
- **Interrompida pelo stakeholder:** a sessão não reexecuta a chamada rejeitada; deixa o disco consistente (`.active-run` apagado) e responde em uma linha onde parou. O próximo `sprint run` retoma pelo marcador.
- **Ocorrência de plugin só se registra:** falha R27 persistente ou consumo de um papel > 2× a média vira linha em "Bloqueios e riscos abertos"; o formulário abre uma vez, na Review.

## Por Task — os passos que outros documentos citam

| # | Passo | Como (v3.51) |
|---|---|---|
| 1 | Plano | escrito na etapa 1, por História; Task com interface cita a especificação de tela ([`workflow.md` §3a](workflow.md)) |
| 2 | Escalação do Arquiteto | só mudança funcional, impacto significativo, arquitetura fora do SDD ou decisão estratégica; sem escalação, segue (R25) |
| 3 | **Desenvolvedor** | `run.ps1 start -Task <ID>` grava `.active-task` (JSON que a G9 lê) e marca 🟦/⬜ → 🟨 pelo `dispatch.ps1`, gera o cartão e imprime o prompt. **Arquivos protegidos** do plano: a sessão aplica o diff antes do dev. **Plano em blocos:** uma instância de dev por bloco, na ordem de `**Depende de:**`. **Perfil executor** (`models.json` → `"executor": "architect"`): o Arquiteto implementa no lugar do dev, com a mesma evidência. **Escalonamento:** duas instâncias encerradas no mesmo bloco sem o Pronto → a terceira com `model: "sonnet"` (registro no quadro) |
| 4 | Gap | 🔺 GAP vai ao Arquiteto em **instância nova** com os caminhos (`run.ps1 done -Result gap` imprime o prompt; Task em 🟪 volta a 🟨); a decisão volta ao dev em **instância nova, em primeiro plano**, com o cartão de passagem e o caminho da decisão (nunca `SendMessage` — §Retomada). A rota do GAP é uma linha no `run-log.md` (§Registro de decisões). Negação de guarda ao dev (G9, G6, G5) é sempre 🔺 GAP. O prompt de GAP nunca pede escrita, compilação ou execução no projeto |
| 5 | Aceite da Task | os cenários da Task rodam no alvo pelo próprio dev (`accept.ps1`), com captura; falhou, ele corrige. Sem `targets` no `guards.json`, a prova no alvo fica para o portão |
| 6 | Falha no fechamento | o `close.ps1` diz o que falta; volta ao mesmo dev. **A sessão não reexecuta verificação de papel**: dúvida sobre o que o dev entregou se resolve com `verify.ps1 -Mode check` (compara a árvore) |
| 7 | **Fechamento técnico** | `run.ps1 done -Task <ID> -Result ok` → conferência, 🟨 → 🟪 e `close.ps1 -Apply`: marca ✅, grava Registro e Série (estimativa baixada), roda o `-Post` e imprime a entrada de status pré-preenchida. **Commit da Task (v3.52 · R31):** fechada a Task, o **script** faz o commit só do código da Task, com a mensagem **`T-<nnn>: <título>`** — uma Task por commit, referenciando o ID ([`artifact-ownership.md`](artifact-ownership.md) §4 Convenções, "uma Task por commit sempre que possível") —, **nunca `.team-project/`** (fora do git, R31; `docs/` entra se o produto o tem). Cada Task fechada vira ponto de restauração: limite de conta, queda de máquina ou `git clean` não perdem o sprint (P-r1: 5 Tasks fechadas, todo o código não rastreado). **Projeto sem git:** checkpoint por cópia dos arquivos da Task, como o `fix run` já faz ([`fix-run.md`](fix-run.md) §Run passo 2: lista de arquivos e cópia dos trechos originais). Commit que falha não reprova a Task: vira linha no `run-log.md` e bloqueio de ambiente. O Agent `scrum-master` só entra quando o C1 pede decisão, com `**Desvio aceito:**` ou mudança de `context.md` ou do Product Backlog |
| 8 | Saída da Task | `dispatch.ps1 -Clear` (apaga `.active-task` e `.active-executor`); siga para a próxima — sem pergunta, sem resumo |

## Validação do sprint — o portão do QA (v3.51)

**Quando:** todas as Tasks ✅ (ou 🔴 com o bloqueio registrado). **O QA é o portão de validação do produto entregue pelo dev** (decisão do stakeholder, 2026-10-21) e a **premissa da Review**:
- **Funcional, com prova no alvo real:** todos os cenários do sprint, com o app rodando (emulador, navegador com o site no ar), uma captura por cenário. Cenário "não exercitado" reprova o portão — é bloqueio de ambiente, nunca aprovação.
- **Qualidade de código:** a parte mensurável sai do `quality.ps1` (cobertura com limiar, regra de dependência, limites numéricos, lint, duplicação, TODO e supressão — as regras Q do nível 1 de `standards/`); o julgamento (SOLID, clean code, aderência à arquitetura e aos planos, padrões da tecnologia, segurança) é do QA, com `arquivo:linha`.
- **Medir é do `operator`, em primeiro plano (nunca a sessão, v3.52); julgar é do QA.** Comando longo dentro de uma instância cara vence o cache dela (5 min) — o QA não roda build, suíte nem o app (C3).
- Achados: execução → dev; dúvida de desenho → Arquiteto. Depois, nova medição e nova rodada do QA no mesmo `validation.md`.

## Disparo e espera — primeiro plano, a sessão fica bloqueada (v3.52)

**Todo agente do `run` sai em primeiro plano** (sem `run_in_background`): a chamada bloqueia a sessão até o papel devolver o retorno curto — medido no P-r1: 62 disparos em primeiro plano, até 3.824 s, nenhum devolvido antes da hora; bloquear custa **zero chamadas**. A série (R1) se mantém: um papel por vez. **Causa confirmada das esperas caras** (P-r1: 48 chamadas de `Start-Sleep` de 60 a 598 s, US$ 3,68, cada uma relendo o contexto inteiro): **(a)** retomada por `SendMessage`, que volta na hora enquanto o papel segue sozinho, e a sessão sonda `delivery/T-nnn.md`; **(b)** a sessão rodando ela mesma comando longo em segundo plano (aceite, lote com `adb`, verificação) e sondando a saída a cada ~10 min por horas — trabalho do `operator` (R28). Daí três regras, todas contra a sondagem:
1. **Nenhuma espera por `Start-Sleep` (nem loop de checagem do disco) na sessão durante o `run`** — a guarda **G22** (`hooks/pre-tool.ps1`) nega à sessão principal `Start-Sleep` e comando em segundo plano enquanto há `.active-run`. Esperar é estar dentro da chamada bloqueante do papel.
2. **A sessão nunca roda comando longo ela mesma — nem em segundo plano:** aceite, lote, verificação, `adb`, build vão ao `operator`, **em primeiro plano** (R28; ele devolve o retorno curto e o `report` no disco). A sessão só roda os scripts curtos do `run.ps1`.
3. **Nenhum agente do `run` em segundo plano**; por isso não há mais "preparo ao lado do dev" (exceção da R1 retirada): o preparo (QA e Arquiteto) de História independente é o **passo 1 do `run.ps1 next`**, em sequência, antes ou depois da construção, na ordem que o `next` indica.

**Consumo:** o hook G16 mede cada rodada; a sessão não transcreve número. **Retorno curto (R28):** todo prompt pede até 15 linhas; a sessão passa caminhos, nunca o conteúdo colado.

**Toque de cache da sessão — retirado (v3.52).** Escolha e motivo: com a chamada bloqueante, o toque (`CronCreate` a cada 30 min) não dispara durante a espera, que era o caso que ele cobria; com a sessão curta (~50 a 80 mil tokens, uma Task), regravar o contexto custa centavos (~US$ 0,15 a 0,20 por sessão nova contra o toque, que era outra chamada relendo o contexto inteiro a cada 30 min). A sessão **não cria** `CronCreate` ao gravar o `.active-run`. Em sessão longa interativa (o stakeholder seguiu sem `/clear` por várias Tasks) o toque não é exigido; se o stakeholder o quiser, é pedido dele.

## Retomada — sempre instância nova, em primeiro plano (v3.49; ampliada na v3.51; reescrita na v3.52)

- **Qualquer papel, inclusive Haiku (dev, `operator`): instância nova em primeiro plano, com o cartão de passagem** (`run.ps1 handoff -Task <ID>`, ~2 KB) e os caminhos do artefato que motivou a volta (o que falta, a decisão do GAP, o `delivery/T-nnn.md`). A sessão fica bloqueada até a volta. **Nunca `SendMessage` seguido de sondagem.**
- **`SendMessage` no `run` — escolha e motivo:** para Haiku era permitido (v3.49: o contexto dele é barato e ele "guarda o que já leu"); a causa confirmada das esperas mudou a conta. O `SendMessage` é **assíncrono** — volta na hora e a sessão não tem como esperar sem sondar — e o ganho que justificava a exceção é pequeno: o dev lê cabeçalho, §6, §9 e o próprio bloco do plano e recebe o cartão, um custo de poucos centavos em Haiku. Logo **o `SendMessage` não é usado no `run` por nenhum papel**. Para Sonnet ou Opus a regra já valia (cache de 5 min vencido, P-r6: Arquiteto 7×, US$ 3,4; PO, UX e SM, US$ 1,5). A guarda **G19** passa a negar o `SendMessage` a qualquer papel enquanto há `.active-run` (proposta registrada no changelog v3.52; a guarda é do stakeholder).
- **O que a instância nova não tem:** o raciocínio que não ficou escrito. Por isso toda decisão vai para o plano (R9) ou para o relatório, e a retomada/rota fica no `run-log.md` (§Registro de decisões).

## Registro de decisões — `run-log.md` (v3.52)

`sprints/<n>/run-log.md` (e `fixes/B-<nnn>/run-log.md` no `fix run`), no modelo [`templates/run-log.md`](../templates/run-log.md): **uma linha por decisão que não está no quadro nem no cartão** — quando · item · decisão · porquê · onde está a evidência. Entram: rota de GAP, retomada (instância nova e por quê), bloqueio e degrau, escolha entre opções, Task pulada, exceção do roteiro. A sessão o escreve na hora da decisão. **A sessão nova o lê só em retomada do run, em bloqueio e na Review** — nunca na abertura.

**O que fica onde (sem duplicar):** a transição de cada Task (quem, quando) é do `kanban.md` — "Registro de transições" e Série; a passagem de contexto de uma Task é do cartão (`handoff/<T-ID>.md`); a negação de guarda é do `guards.log`; o corte por limite de conta é do `.usage-limit`; a parada no ponto seguro é do `.safe-point`. O `run-log.md` guarda só a **decisão e o porquê** que nenhum deles carrega, apontando a linha ou o arquivo como evidência.

## Retomada após limite de uso da conta (v3.51.4)

O harness corta o turno quando a conta atinge o limite de uso ("You've hit your session limit · resets …", HTTP 429). **Não é parada fora do contrato nem falha de papel** (R27: ambiente). O hook que vê a resposta sintética — a G16 no fim da rodada do subagente, ou o `Stop` no turno da sessão — grava **`.team-project/.usage-limit`** (`desde`, `reset`, quem, item) e a linha no `guards.log`; a G20 não barra esse turno. Na retomada, depois do reset:
1. `run.ps1 next` mostra a linha **RETOMADA** com o motivo e apaga o sinal.
2. **Agente que caiu no meio:** retome em **instância nova, em primeiro plano, com o cartão** (§Retomada; v3.52: sem `SendMessage`). O que ele já fez está no disco.
3. **Verificação pela metade:** o `verify.ps1` continua de onde parou na mesma árvore (`result.json` com `full_partial` ou `mutation.pending`; `mutation-pending.json` restaura o arquivo mutado antes de qualquer coisa). Rode o **mesmo** comando.
4. O tempo parado não conta como trabalho: a G16 tira da duração da rodada toda lacuna acima de 20 min entre duas chamadas (`paused_s`), e o `kanban.md` mostra a pausa à parte.

## Pausa segura — o ponto seguro é parada permitida (v3.51.4; ampliada na v3.52)

**Ponto seguro automático (v3.52).** Ao fechar a Task (`run.ps1 done` que fechou), o script grava **`.team-project/.safe-point`** — JSON `{ "task": "T-<nnn>", "sprint": "<n>", "desde": "<aaaa-mm-dd hh:mm:ss>" }` (só no `sprint run`: a G20 não vê a trilha `fix`, cuja unidade já é o bloco). Com ele presente, a **G20 deixa a sessão parar** (parada **(f)**), sem apagar o `.active-run`: a próxima sessão continua por `run.ps1 next`, que mostra a linha **RETOMADA: ponto seguro…** e apaga o marcador. O marcador vale só entre o `done` e o `next`/`start` seguinte: a sessão que segue na mesma conversa passa pelo `next`, e a G20 volta a barrar. **Uso interativo: opcional** — o stakeholder pode seguir na mesma sessão (atrito de `/clear` a cada Task); **benchmark: o driver relança** `/sm sprint run` em sessão nova até a fila acabar. É a terceira fronteira da R29. Ao parar, a sessão diz uma linha: Task fechada, próximo passo **em sessão nova (`/clear` e `/sm sprint run`)**.

**Pausa pedida pelo stakeholder (e).**

O `run.ps1 next` imprime o **consumo medido do sprint** (tokens e minutos, sem a sessão — é um piso) e, com Task fechada, a **estimativa das abertas** pela média por Task. O stakeholder decide com esse número se o sprint cabe na janela de uso. **Ponto seguro de pausa:** logo depois de um `run.ps1 done` que fechou a Task — nada fica pela metade (nenhuma Task em 🟨, nenhum agente em voo). Pausar ali: a sessão apaga o `.active-run` (parada **(e)**) e diz em uma linha onde parou; o próximo `sprint run` retoma pelo marcador.

## Modelo por papel — `.team-project/models.json` (v3.47)

O stakeholder escolhe o modelo de cada papel em `.team-project/models.json` (`{ "developer": "sonnet", "architect": "opus" }`; chaves `architect`, `developer`, `operator`, `product-owner`, `quality-assurance`, `scrum-master`, `user-experience` ou o apelido `arc dev po qa sm ux`; valores `opus`, `sonnet`, `haiku`, `fable`).
1. O `run.ps1` e o `dispatch.ps1` imprimem o modelo de cada disparo (`models.ps1 -Role <papel>` só o modelo; vazio = o do agente).
2. **Chave ligada vence** o `model:` do agente e as exceções do processo (trilha leve, terceira instância do bloco).
3. Vale para todo disparo do papel, no `run`, no `fix run` e avulso. A instância nova da retomada usa o modelo configurado do papel.
4. A guarda **G17** nega disparo com outro modelo; a sessão dispara de novo com o valor certo.
5. O modelo servido está em cada linha do `usage.jsonl`; servido ≠ configurado é achado do `/review`.

## Modo benchmark — `guards.json` → `bench` (v3.47 · M3)

O experimento de benchmark ([`rituals/benchmark.md`](../../../rituals/benchmark.md) §7) roda o `run` sem o stakeholder. Com `bench` no `guards.json`, a guarda **G18**: (1) **responde o `AskUserQuestion` pelo dossiê** — nega a pergunta e devolve `[bench] resposta do stakeholder: <opção>`; a sessão segue com essa decisão; cada pergunta vai ao `questions.log`; (2) com **`foreground: true`**, nega `Agent` em segundo plano. A navegação do protótipo vira `n/a — navegação simulada (benchmark)`. **Sem a ferramenta `AskUserQuestion` (`claude -p`, v3.50.1):** cada formulário vira `scripts/checks/bench-answer.ps1 -Question … -Header … -Options "A|B|C"`, que responde pelo mesmo dossiê.

## Marcador — o quadro mostra onde a Task está

Legenda: ⬜ a fazer · 🟦 plano · 🟨 construção · 🟪 em verificação · ✅ fechada · 🔴 bloqueada. Toda transição é uma chamada: `scripts/checks/mark.ps1 -Task <T-ID> -To <plan|build|qa|blocked|todo>` troca o marcador no quadro e grava o Registro de transições e a Série; o ✅ é do `close.ps1 -Apply`. Os scripts marcam sozinhos (v3.51.4): o `run.ps1 next`, 🟦 no início do preparo da História; o `run.ps1 start`/`dispatch.ps1`, 🟨; o `run.ps1 done`, 🟪 antes do fechamento e 🟨 de volta num GAP. O Evento da Série traz quem produziu a transição (`T-041 🟦 → 🟨 · dev`). O quadro, o Registro e a Série se gravam sob a trava do `kanban.md` (`kanban.md.lock`), que a G16 também usa — duas escritas ao mesmo tempo apagavam uma linha da Série.

**Sinal de vida (v3.51.4).** O `kanban.md` tem a seção **"## Agora"**: uma linha por agente disparado pela sessão — papel, item, última ação e há quanto tempo —, regravada pelos hooks a cada disparo, a cada ação do subagente e na volta. Rodada de 10 a 40 min de build ou teste deixa de parecer travada.

## Ao fim da fila

Reporte: o que fechou, o que ficou bloqueado e em que degrau, o que foi pulado, e o veredito do portão. **Quando o `run` percorreu a fila e a validação e a consolidação estão feitas**, a sessão chama `AskUserQuestion` — **formulário de autorização da Review**, no formato do H1. Em projeto com Identificador remoto, grava antes a pendência em `README.md` §7 (R34). Opções: **Iniciar a Review agora** · **Iniciar depois** (item em §7) · **Resolver bloqueio antes** (só se houver Task bloqueada) · **Pedir mais contexto**. Iniciar a Review não é aceite (R21); formulário expirado = "iniciar depois", nunca recusa.

## Como o SM verifica

- Nenhuma Task em 🟨 sem a data do pacote (R20 · R25); toda Task fechada pelo `close.ps1` com R7, R7-verify, R7-mutação, R7-aceite e R12 ok.
- Preparo por História: os planos de uma História saíram de uma instância do Arquiteto e passaram pelo `plan.ps1`; os cenários executáveis existem antes do dev.
- Portão: `validation.md` com veredito, as medições do `operator` da árvore validada e a prova no alvo; Review só com ✅ (ou ⚠️ com a dívida aceita pelo PO) e a consolidação dos documentos vivos feita.
- Nenhuma mensagem ao stakeholder entre a aprovação do pacote e a Review que não seja formulário (bloqueio, ajustes do `fix plan`, autorização da Review), todos no formato do H1.
- Retomada: `SendMessage` no `run` é achado contra a orquestração (a G19 nega papel caro depois de 5 min; v3.52: qualquer papel); instância nova sem o cartão de passagem também.
- Espera (G22 nega no ato): nenhuma chamada `Start-Sleep` da sessão durante o `run`, nenhum comando longo (aceite, lote, verificação, `adb`) rodado pela sessão, em segundo plano ou não (o `guards.log` e o transcript mostram; achado contra a orquestração, R28).
- Paradas: sessão encerrada com Task elegível e `.active-run` **sem `.safe-point`** é achado (a G20 barra); nenhum `.active-run`, `.active-task` nem `.target-lock` sobrando no fim; cada Task ✅ tem o commit `T-<nnn>: …` (projeto com git) ou o checkpoint por cópia, e nenhum `.team-project/` entrou nele (R31).
- Registro: `run-log.md` com a rota de cada GAP, retomada e bloqueio do sprint, sem repetir o que o quadro, o cartão e o `guards.log` já guardam.
- Guardas por papel: toda negação está no `guards.log`; negação ao dev seguida de 🔺 GAP é o caminho certo; contorno é achado contra o papel.
