# `/sm sprint run` — roteiro da execução do sprint

> **Dono:** SM · **Fonte única do `run`** (v3.34). Lido **só** quando `commands/sm.md` entra no modo `sprint run`; `commands/sm.md`, o README do SM e `workflow.md` §2a apontam para cá e **não repetem** o roteiro. Contexto do ciclo: [`workflow-sprint.md` §5g](workflow-sprint.md) · regras R1, R12, R20, R22, R25, R27.

**Quem executa.** A **sessão** que recebeu `/sm sprint run` orquestra: dispara cada papel (`user-experience`, `architect`, `developer`, `quality-assurance`) diretamente e só aciona o Agent `scrum-master` para o que é do SM — `board` e `close <T-ID>`. O Agent `scrum-master` não dispara outros agentes.

## Duas formas

| Forma | Escopo |
|---|---|
| `sprint run` | a **fila inteira** do sprint corrente, Task a Task, **em série** (R1) |
| `sprint run <T-ID>` | **uma** Task, do plano ao fechamento |

## Pré-condições — conferidas antes de disparar o primeiro agente

Ambas as formas. Falhou qualquer uma: **pare e reporte** — não peça nada ao stakeholder aqui.

1. **Pacote aprovado.** Leia `.team-project/README.md` §2 (sprint corrente), abra `.team-project/sprints/<n>/sprint-backlog.md` e confirme que "Pacote de abertura" tem **data de aprovação, quem aprovou, decisão e ponteiro do protótipo navegado**. Sem isso, nenhuma Task entra em construção (R20 · R25). O pacote se pede em `sprint plan`, não aqui.
2. **`<T-ID>` no backlog.** Na forma `sprint run <T-ID>`, a Task tem de existir no Sprint Backlog do sprint corrente, com História de origem e estimativa (R20 · [`workflow.md` §3b](workflow.md)). Task fora do quadro **não roda por aqui**: entra antes como **entrada fora da Planning** (GAP que bloqueia História em voo, ou correção pontual — [`workflow-sprint.md` §5e "Durante o sprint"](workflow-sprint.md)), registrada por `/sm board` com "o que saiu para caber". Sem sprint corrente (antes da 1ª Planning) **não há Task de entrega**; só a **calibração** da instalação usa os comandos de papel (`/arc plan`, `/dev`, `/qa`), com veredito na conversa e sem `close`; o plano avulso é gravado em `.team-project/architect/calibration/<Task-ID>-<slug>.md` ([`artifact-ownership.md`](artifact-ownership.md) §1) e, se a Task entrar depois no Sprint Backlog, o plano fica onde está (a coluna Plano aponta para ele).
3. **Task com cenários mapeados** (R30) — DoR da Task ([`workflow.md` §3b](workflow.md)). Sem eles, a Task é pulada e reportada.

## Ordem da fila e retomada

- **Ordem:** por dependência declarada no Sprint Backlog, não por criticidade. Task com dependência não satisfeita é **pulada** e retomada quando destravar.
- **Retomada pelo marcador da Task** — o `run` nunca replaneja Task que já tem plano. Entra no passo que o marcador indica: ⬜ → Arquiteto · 🟦 → dev · 🟨 → `/dev resume <T-ID>` (sessão interrompida, R5) · 🟪 → QA (ou o dev, se o veredito foi ⚠️/❌ — passo 6). Isso vale também depois de veredito ⚠️/❌ corrigido e depois de interrupção.
- **Quando a fila para:** no primeiro problema **daquela Task**; a fila **segue nas Tasks cujas dependências estão satisfeitas**. Bloqueio vai ao **degrau 1** (PO e Arquiteto conversam — [`workflow-sprint.md` §5g](workflow-sprint.md)); só o que eles não fecham sobe ao stakeholder, na forma de R22 (formulário) — exceto **decisão estratégica**, que escala direto. Não acione o stakeholder por nada que o degrau 1 possa fechar, **nem para informar andamento**: o registro é o quadro e o relatório final.
- **Invocação interrompida sem ação do stakeholder (R27):** confira a energia/suspensão do SO na janela da falha, classifique como **falha de ambiente com causa e horário** e **retome o mesmo agente por `SendMessage`** — instância nova só se ele não existir mais, depois de ler o estado em disco (R5).
- **Ocorrência de plugin só se registra:** falha R27 persistente ou consumo de um papel > 2× a média dos últimos sprints vira uma linha em "Bloqueios e riscos abertos" — **sem formulário aqui**; o formulário investigar × ignorar abre uma vez, na Review ([`workflow-sprint.md` §5e](workflow-sprint.md) "Ocorrência de plugin").

## Por Task — a sessão encadeia, parando no primeiro problema

| # | Etapa | Como |
|---|---|---|
| 0 | **Especificação de tela** — só Task com interface | Confira que existe `.team-project/user-experience/screens/<slug>.md` com os seis estados e os critérios de acessibilidade (a DoR da História — [`workflow.md` §3a](workflow.md) — já a exige). **Ausente = defeito de DoR:** pare a Task e devolva ao PO/UX; **não** produza a especificação aqui. Task sem interface: diga explicitamente que a etapa não se aplica |
| 1 | **Arquiteto** (`architect`) | Diagnóstico com evidência, desenho, impacto e Plano de Implementação em `.team-project/sprints/<n>/plan/<ID>-<slug>.md`, dentro da capacidade declarada. Havendo especificação de tela, o plano a **cita**, não a reinterpreta |
| 2 | **Escalação do Arquiteto** | Se escalou algo (decisão estratégica, lacuna funcional), **pare** — o degrau 1 vem antes de qualquer pergunta ao stakeholder. Sem escalação, siga: **não há resumo ao stakeholder por Task** (R25: dois pontos de contato por sprint) |
| 3 | **Desenvolvedor** (`developer`) | Recebe o caminho do plano e a regra de parar e reportar 🔺 GAP em vez de improvisar |
| 4 | **Gap** | Se houve 🔺 GAP: leve-o ao `architect` (sem replanejar por conta própria) e devolva a decisão ao dev por `SendMessage`, preservando o contexto dele. Repita quantas vezes for preciso. O Arquiteto **decide e registra no plano; não reproduz na máquina** — build, lint ou teste que o dev afirmou é objeto do QA (R9 · R7) |
| 5 | **QA** (`quality-assurance`) | Acione com `/qa <ID>` — o roteiro do comando define os insumos (plano, especificação de tela, relatório do dev, critério de aceite, cenários mapeados) e as seis frentes; **esta lista não os repete**. Veredito ✅/⚠️/❌ |
| 6 | **Veredito ⚠️ ou ❌** | **Não** siga para o fechamento. Devolva pela rota do próprio veredito: aderência de execução → **direto** ao dev por `/dev resume <ID>`; defeito do plano → Arquiteto por 🔺 GAP/`/arc question` **e** achado de processo na fila do `/review`; defeito do próprio standard → só a fila do `/review`. Depois do conserto, a Task reentra pelo marcador (🟪) |
| 7 | **Fechamento técnico** | Se o veredito é ✅ **e** o campo **"Documentos vivos (R12)"** do veredito está "atualizados" (preenchido pelo QA, com o que cada dono atualizou), acione o Agent `scrum-master` em `close <T-ID>`, que **começa por `scripts/checks/close.ps1 -Task <T-ID>`** (lê `### Documentos vivos (R12)` e `### Escopo` do bloco da evidência; exit 1 = não fecha) e só depois faz: quadro, status, Registro de transições, burndown. **Campo ausente, vazio ou "pendente" → não fecha:** devolva ao dono do documento (R12). O **aceite continua sendo da História**, na Sprint Review (R21) |
| 8 | **Transições** | Ao fim de cada Task (fechada, bloqueada ou pulada), acione o `scrum-master` em `board` **uma vez**: sincroniza ⬜→🟦→🟨→🟪 e grava as linhas no Registro de transições (R24). Sem isso o burndown do sprint fica só com abertura e fechamentos |

## Task pesada — Arquiteto e QA em segundo plano

**Task pesada** = estimativa **≥ 2× a mediana** das estimativas do sprint, ou Task que já acionou o `operator` (R28). Nela, a sessão dispara `architect` e `quality-assurance` com **`run_in_background: true`**: a série (R1) se mantém — a sessão **aguarda a notificação** antes da etapa seguinte —, mas a falha chega como notificação, não como bloqueio da sessão. Task não pesada segue em primeiro plano. A retomada continua por `SendMessage` (R3 · R27), e a linha de consumo é gravada com o número da notificação **final** ([`templates/consumption.md`](../templates/consumption.md)).

## Ao fim da fila

Reporte: o que fechou, o que ficou bloqueado **e em que degrau**, o que foi pulado por dependência. Próximo passo: `/sm sprint review`.

## Como o SM verifica

- Nenhuma Task em 🟨 sem a data do pacote no Sprint Backlog (R20 · R25).
- `sprint run <T-ID>` de Task fora do quadro é achado contra a orquestração.
- Nenhuma Task fechada sem veredito ✅ **e** "Documentos vivos (R12)" preenchido; cada `close` tem linha no Registro de transições (R24).
- Nenhuma mensagem ao stakeholder entre a aprovação do pacote e a Review que não seja pergunta de bloqueio em formulário (R22 · R25).
- Falha de invocação relatada traz a conferência de energia e a forma da retomada (R27); Task pesada despachada em segundo plano, ou o motivo de não ter sido; ocorrência de plugin registrada no quadro e **nenhum** formulário dela durante o `run`.
- Consumo: uma linha por subagente disparado, incluindo as do `operator` retratadas pelo chamador (R28 — [`templates/consumption.md`](../templates/consumption.md)).
