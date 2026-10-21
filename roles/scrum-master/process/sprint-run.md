# `/sm sprint run` — roteiro da execução do sprint

> **Dono:** SM · **Fonte única do `run`** (v3.34; reescrito na v3.51). Lido **só** quando `commands/sm.md` entra no modo `sprint run`. Contexto do ciclo: [`workflow-sprint.md` §5g](workflow-sprint.md) · regras R1, R12, R20, R22, R25, R27, R28.
> **v3.51 — a sessão não decide o próximo passo relendo este roteiro: pergunta ao script.** `scripts/checks/run.ps1 next` lê o quadro e o disco e devolve a próxima ação pronta (papel, modelo, prompt curto com os caminhos, o comando de volta). Medido no benchmark: a sessão principal era 35 % do custo do sprint, a 274 mil tokens por chamada; com a orquestração em script, o coordenador do protótipo custou 6 %.

**Quem executa.** A **sessão** que recebeu `/sm sprint run` orquestra: roda `run.ps1`, dispara o papel que ele indica e volta ao script. O Agent `scrum-master` só entra quando o fechamento pede julgamento (passo 7).

## O sprint, em seis etapas

| # | Etapa | Quem | O que o `run.ps1 next` devolve |
|---|---|---|---|
| 1 | **Preparo da construção**, por História | QA, depois Arquiteto | cenários executáveis que faltam (`.team-project/quality-assurance/scenarios/<H-ID>.scn`, linguagem do `accept.ps1`) e, com eles prontos, **os planos de todas as Tasks da História numa instância do Arquiteto** (template enxuto, regras 22 a 25). Cada plano passa pelo `plan.ps1` antes do dev. **O plano é construção** (decisão do stakeholder, 2026-10-21): conta no custo do sprint |
| 2 | **Construção**, Task a Task (R1) | dev | `run.ps1 start -Task <ID>`: escopo e marcador (`dispatch.ps1`), cartão de passagem e o prompt. O dev constrói, roda `verify` (focado, completo, mutação se o plano a declara) e **os cenários da Task no alvo real** (`accept.ps1 -Task <ID> -Only <cenários>`), e **corrige sozinho** o que falhar. Dúvida de desenho → 🔺 GAP |
| 3 | **Fechamento da Task** | script | `run.ps1 done -Task <ID> -Result ok` → `close.ps1 -Apply`: fecha **pela evidência do dev** (R7, R7-verify, R7-mutação, R7-aceite, R12 "a consolidar"). Não fecha → volta ao **mesmo** dev por `SendMessage` com o que falta |
| 4 | **Validação do sprint** — o portão do QA | operator, depois QA | o `operator` mede (`quality.ps1 -Id S<n>` e `accept.ps1 -Task S<n>`, todos os cenários, com captura); o QA, numa passada só, julga código e produto e escreve `sprints/<n>/validation.md` ([`templates/sprint-validation.md`](../../quality-assurance/templates/sprint-validation.md)) |
| 5 | **Correção dos achados** | dev (dúvida → Arquiteto) | um dev por grupo de achados; depois o `operator` mede de novo e o QA, em instância nova, revisa o veredito |
| 6 | **Consolidação dos documentos vivos** (R12, A5) e fim da fila | Arquiteto, uma vez | as seções "Documentos vivos (R12)" dos relatórios viram o SDD técnico atualizado; depois, o formulário de autorização da Review (§Ao fim da fila) |

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
- **Paradas legítimas — lista fechada:** **(a)** fim da fila → formulário de autorização da Review; **(b)** bloqueio que o degrau 1 não fechou **e** nenhuma Task elegível → formulário de R22; **(c)** pré-condição falha; **(d)** interrupção pelo stakeholder. **Fim de Task não é ponto de parada**; "sigo?", "marco natural", tamanho da fila e consumo de tokens também não. A guarda **G20** (hook `Stop`, v3.51) barra o fim de turno com Task elegível e `.active-run` gravado; esperar agente em segundo plano é legítimo (`.active-agents`).
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
| 4 | Gap | 🔺 GAP vai ao Arquiteto em **instância nova** com os caminhos (`run.ps1 done -Result gap` imprime o prompt); a decisão volta ao **mesmo** dev por `SendMessage`. Negação de guarda ao dev (G9, G6, G5) é sempre 🔺 GAP. O prompt de GAP nunca pede escrita, compilação ou execução no projeto |
| 5 | Aceite da Task | os cenários da Task rodam no alvo pelo próprio dev (`accept.ps1`), com captura; falhou, ele corrige. Sem `targets` no `guards.json`, a prova no alvo fica para o portão |
| 6 | Falha no fechamento | o `close.ps1` diz o que falta; volta ao mesmo dev. **A sessão não reexecuta verificação de papel**: dúvida sobre o que o dev entregou se resolve com `verify.ps1 -Mode check` (compara a árvore) |
| 7 | **Fechamento técnico** | `run.ps1 done -Task <ID> -Result ok` → `close.ps1 -Apply`: marca ✅, grava Registro e Série (estimativa baixada), roda o `-Post` e imprime a entrada de status pré-preenchida. O Agent `scrum-master` só entra quando o C1 pede decisão, com `**Desvio aceito:**` ou mudança de `context.md` ou do Product Backlog |
| 8 | Saída da Task | `dispatch.ps1 -Clear` (apaga `.active-task` e `.active-executor`); siga para a próxima — sem pergunta, sem resumo |

## Validação do sprint — o portão do QA (v3.51)

**Quando:** todas as Tasks ✅ (ou 🔴 com o bloqueio registrado). **O QA é o portão de validação do produto entregue pelo dev** (decisão do stakeholder, 2026-10-21) e a **premissa da Review**:
- **Funcional, com prova no alvo real:** todos os cenários do sprint, com o app rodando (emulador, navegador com o site no ar), uma captura por cenário. Cenário "não exercitado" reprova o portão — é bloqueio de ambiente, nunca aprovação.
- **Qualidade de código:** a parte mensurável sai do `quality.ps1` (cobertura com limiar, regra de dependência, limites numéricos, lint, duplicação, TODO e supressão — as regras Q do nível 1 de `standards/`); o julgamento (SOLID, clean code, aderência à arquitetura e aos planos, padrões da tecnologia, segurança) é do QA, com `arquivo:linha`.
- **Medir é do `operator`; julgar é do QA.** Comando longo dentro de uma instância cara vence o cache dela (5 min) — o QA não roda build, suíte nem o app (C3).
- Achados: execução → dev; dúvida de desenho → Arquiteto. Depois, nova medição e nova rodada do QA no mesmo `validation.md`.

## Disparo em segundo plano — todo agente do `run`

Todo agente do `run` sai com **`run_in_background: true`**. A série (R1) se mantém: a sessão aguarda a notificação antes da etapa seguinte e não dispara dois papéis ao mesmo tempo — exceção da R1: com o dev em construção, o preparo (QA e Arquiteto) de uma História **independente** pode correr ao lado. **Encerrar o turno à espera da notificação não é parada** (o `.active-agents` registra o agente; a G20 libera). **Exceção — modo benchmark com `bench.foreground`:** todo agente em primeiro plano. **Consumo:** o hook G16 mede cada rodada; a sessão não transcreve número. **Retorno curto (R28):** todo prompt pede até 15 linhas; a sessão passa caminhos, nunca o conteúdo colado.

**Toque de cache da sessão (v3.49, em avaliação).** Fora do modo benchmark, ao gravar o `.active-run`, a sessão cria `CronCreate` com `cron: "17,47 * * * *"`, recorrente, prompt **`[toque de cache] Não execute nada nem retome o run. Responda só: OK.`**, e o apaga em toda parada legítima (`CronDelete`). Ao receber o toque: responde `OK` e encerra o turno.

## Retomada — o mesmo agente ou um novo (v3.49; ampliada na v3.51)

- **Papel em Haiku (dev, operator):** retomar pelo `SendMessage` — ele guarda o que já leu, e regravar o contexto dele custa pouco.
- **Papel em Sonnet ou Opus (Arquiteto, QA, PO, UX, SM) parado há mais de 5 min:** **instância nova**, nunca `SendMessage`. O cache de um subagente dura 5 min; depois disso a retomada regrava todo o contexto no modelo caro (P-r6: Arquiteto 7×, US$ 3,4; PO, UX e SM, US$ 1,5). A instância nova recebe o **cartão de passagem** (`run.ps1 handoff -Task <ID>`, ~2 KB) e os caminhos do artefato que motivou a volta. A guarda **G19** nega o `SendMessage` fora dessa regra.
- **O que a instância nova não tem:** o raciocínio que não ficou escrito. Por isso toda decisão vai para o plano (R9) ou para o relatório.

## Modelo por papel — `.team-project/models.json` (v3.47)

O stakeholder escolhe o modelo de cada papel em `.team-project/models.json` (`{ "developer": "sonnet", "architect": "opus" }`; chaves `architect`, `developer`, `operator`, `product-owner`, `quality-assurance`, `scrum-master`, `user-experience` ou o apelido `arc dev po qa sm ux`; valores `opus`, `sonnet`, `haiku`, `fable`).
1. O `run.ps1` e o `dispatch.ps1` imprimem o modelo de cada disparo (`models.ps1 -Role <papel>` só o modelo; vazio = o do agente).
2. **Chave ligada vence** o `model:` do agente e as exceções do processo (trilha leve, terceira instância do bloco).
3. Vale para todo disparo do papel, no `run`, no `fix run` e avulso. Retomada por `SendMessage` continua no modelo da instância.
4. A guarda **G17** nega disparo com outro modelo; a sessão dispara de novo com o valor certo.
5. O modelo servido está em cada linha do `usage.jsonl`; servido ≠ configurado é achado do `/review`.

## Modo benchmark — `guards.json` → `bench` (v3.47 · M3)

O experimento de benchmark ([`rituals/benchmark.md`](../../../rituals/benchmark.md) §7) roda o `run` sem o stakeholder. Com `bench` no `guards.json`, a guarda **G18**: (1) **responde o `AskUserQuestion` pelo dossiê** — nega a pergunta e devolve `[bench] resposta do stakeholder: <opção>`; a sessão segue com essa decisão; cada pergunta vai ao `questions.log`; (2) com **`foreground: true`**, nega `Agent` em segundo plano. A navegação do protótipo vira `n/a — navegação simulada (benchmark)`. **Sem a ferramenta `AskUserQuestion` (`claude -p`, v3.50.1):** cada formulário vira `scripts/checks/bench-answer.ps1 -Question … -Header … -Options "A|B|C"`, que responde pelo mesmo dossiê.

## Marcador — o quadro mostra onde a Task está

Legenda: ⬜ a fazer · 🟦 plano · 🟨 construção · 🟪 em verificação · ✅ fechada · 🔴 bloqueada. Toda transição é uma chamada: `scripts/checks/mark.ps1 -Task <T-ID> -To <plan|build|qa|blocked|todo>` troca o marcador no quadro e grava o Registro de transições e a Série; o ✅ é do `close.ps1 -Apply`. O `run.ps1 start` e o `dispatch.ps1` já marcam a entrada em construção.

## Ao fim da fila

Reporte: o que fechou, o que ficou bloqueado e em que degrau, o que foi pulado, e o veredito do portão. **Quando o `run` percorreu a fila e a validação e a consolidação estão feitas**, a sessão chama `AskUserQuestion` — **formulário de autorização da Review**, no formato do H1. Em projeto com Identificador remoto, grava antes a pendência em `README.md` §7 (R34). Opções: **Iniciar a Review agora** · **Iniciar depois** (item em §7) · **Resolver bloqueio antes** (só se houver Task bloqueada) · **Pedir mais contexto**. Iniciar a Review não é aceite (R21); formulário expirado = "iniciar depois", nunca recusa.

## Como o SM verifica

- Nenhuma Task em 🟨 sem a data do pacote (R20 · R25); toda Task fechada pelo `close.ps1` com R7, R7-verify, R7-mutação, R7-aceite e R12 ok.
- Preparo por História: os planos de uma História saíram de uma instância do Arquiteto e passaram pelo `plan.ps1`; os cenários executáveis existem antes do dev.
- Portão: `validation.md` com veredito, as medições do `operator` da árvore validada e a prova no alvo; Review só com ✅ (ou ⚠️ com a dívida aceita pelo PO) e a consolidação dos documentos vivos feita.
- Nenhuma mensagem ao stakeholder entre a aprovação do pacote e a Review que não seja formulário (bloqueio, ajustes do `fix plan`, autorização da Review), todos no formato do H1.
- Retomada: papel caro retomado por `SendMessage` depois de 5 min é achado contra a orquestração (a G19 nega); instância nova sem o cartão de passagem também.
- Paradas: sessão encerrada com Task elegível e `.active-run` é achado (a G20 barra); nenhum `.active-run`, `.active-task` nem `.target-lock` sobrando no fim.
- Guardas por papel: toda negação está no `guards.log`; negação ao dev seguida de 🔺 GAP é o caminho certo; contorno é achado contra o papel.
