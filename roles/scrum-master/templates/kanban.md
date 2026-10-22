# Template — Kanban do Sprint (Kanban · Burndown · Controle)

> **Dono:** SM · Vive em `.team-project/sprints/<n>/kanban.md` (v3.51; até a v3.50, `burndown.md`, sem o Kanban nem o controle — sprint aberto antes continua com ele, e os scripts leem os dois).
> **Um arquivo para acompanhar o sprint** (pedido do stakeholder, 2026-10-21): primeiro **onde cada Task está** (o Kanban), depois **quanto falta** (o Burndown: Série e Registro de transições) e, embaixo, **o controle** — o que entrou fora da Planning, o que está bloqueado e o que espera o stakeholder. O `sprint-backlog.md` fica só com as Histórias e as Tasks.
> Nasce no `/sm sprint plan` (linha de abertura, dia 0 — **a data da aprovação do pacote de abertura**, não a do fechamento da Planning · R25), ganha **uma linha na Série e uma no Registro a cada transição de marcador** — no `sprint run`, gravadas pelo `mark.ps1` e pelo `close.ps1 -Apply` no momento da passagem ([`sprint-run.md`](../process/sprint-run.md) §Marcador); fora dele, no `/sm board` e no `/sm close <T-ID>` (R24) —, e **fecha** — sem mais edição — no `/sm sprint close`.
> **Só Markdown (v3.51.2):** não há página HTML. `scripts/checks/kanban.ps1` regrava o `## Kanban` e a `## Rodadas` — ao fim de cada rodada de agente (hook G16) e a cada transição (`mark.ps1`, `close.ps1`). É script: **não custa token**.
> **Bloco de fix:** `fixes/<B-nnn>/kanban.md`, gerado **inteiro** por `kanban.ps1 -Block B-<nnn>` (`-Init` no `fix plan`) — ver a variante no fim.

```markdown
# Kanban — Sprint <n>

## Kanban
*(Regravado pelo `kanban.ps1` — não editar à mão.)*

| ⬜ A fazer | 🟦 Plano | 🟨 Construção | 🟪 Verificação | ✅ Fechada | 🔴 Bloqueada |
|---|---|---|---|---|---|
| T-<nnn> | | | | | |

## Rodadas
*(Regravada pelo `kanban.ps1` ao fim de cada rodada — não editar à mão. Custo = tokens e tempo, sem valor em dinheiro.)*

- **Por tarefa e fase:** Plano (Arquiteto) · Construção (dev) · Verificação (QA + operator) · Outros (PO, SM, UX) — `tokens · tempo`, e a linha Consolidado.
- **Por papel e modelo:** uma linha por par, com o Total.
- **Rodada a rodada:** uma linha por rodada (data e hora, Task ou F-ID, papel, modelo, tokens, tempo), a mais nova primeiro.

## Linha de base

| | |
|---|---|
| **Sprint** | <n> |
| **Janela** | <início> → <fim> |
| **Estimativa total planejada** | <n> <unidade> — soma de todas as Tasks na abertura |

## Série

| Dia | Data | Evento | Est. restante | Tasks restantes | ⬜ | 🟦 | 🟨 | 🟪 | ✅ | 🔴 |
|---|---|---|---|---|---|---|---|---|---|---|
| 0 | <data> | Abertura do sprint — **pacote aprovado** | <n> | <n> | <n> | 0 | 0 | 0 | 0 | 0 |
| 0 | <aaaa-mm-dd hh:mm> | T-<nnn> ⬜ → 🟦 | <n> | <n> | <n> | 1 | 0 | 0 | 0 | 0 |

## Registro de transições (R24)

| Task | De → Para | Quando | Por quem |
|---|---|---|---|
| T-<nnn> | ⬜ → 🟦 | <aaaa-mm-dd hh:mm> | Arquiteto |

## Controle

### Entradas fora da Planning

> O Sprint Backlog **não cresce** durante o sprint (R4). A única exceção é o GAP que bloqueia uma História já no sprint. Toda entrada declara **o que saiu para caber** — ou a **Decisão do stakeholder** com data e onde ela está. Sem uma das duas, o C1 reprova a R4.

| Task | História | Por que entrou fora da Planning | O que saiu para caber | Data | Decisão do stakeholder |
|---|---|---|---|---|---|

### Bloqueios e riscos abertos

> **Todo bloqueio nomeia o degrau em que está** (R25 · [`../process/workflow-sprint.md` §5g](../process/workflow-sprint.md)). Bloqueio de ambiente (v3.51: `verify` ou `accept` com exit 4 que o reparo não resolveu) traz a ação para o stakeholder.

| # | Task / História | Natureza | Degrau | Quem destrava | Desde |
|---|---|---|---|---|---|
| 1 | <T-nnn / H-nnn> | <dependência · lacuna funcional · risco técnico · qualidade · ambiente> | <par PO+Arquiteto desde <data> \| escalado ao stakeholder em <data> \| estratégico — direto> | <papel ou stakeholder> | <data> |

### Decisões pendentes do stakeholder

> Chega aqui **só o que o degrau 1 não fechou** (PO + Arquiteto), mais a **decisão estratégica**, que vai direto. Cada linha sobe na forma de **R22** e do **H1** ([`stakeholder-question.md`](stakeholder-question.md)): o problema simples, um exemplo, as opções e a via de pedir mais contexto.

| # | Decisão pendente | Por que o degrau 1 não fechou (ou "estratégica — direto") | Task(s) que destrava | Desde |
|---|---|---|---|---|

## Fechamento *(preenchido só no `/sm sprint close`)*
- **Estimativa restante final:** <n> — <zero, se o sprint fechou todas as Tasks | o que ficou, e para onde foi (Product Backlog, com a História — R5)>
- **Objetivo do sprint atingido?** <ver Sprint Review — não é este documento que decide>
```

## Como preencher

- **Uma transição = uma linha no Registro + uma linha na Série, no mesmo arquivo e no mesmo momento.** O **Evento** da Série cita a Task e a passagem (`T-041 🟦 → 🟨`). Sprint sem eventos num dia não gera linha vazia — o burndown é por evento.
- **Est. restante só cai quando uma Task fecha (✅).** Passar a 🟦/🟨/🟪 não reduz o restante — muda a composição das colunas de estado.
- **O dia 0 é a aprovação do pacote, não o fim da Planning** (R25 · [`../process/workflow-sprint.md` §5f](../process/workflow-sprint.md)).
- **O Kanban e as Rodadas são gerados** — editar à mão é perder a edição na próxima rodada ou transição. O controle (Entradas, Bloqueios, Decisões) é do SM, escrito à mão.
- **Fechado no `/sm sprint close`.** A última linha da Série é a foto final; nenhuma edição depois.
- **Conferido no `close`.** O `close.ps1 -Post` (C1) exige a linha → ✅ no Registro, as passagens da Task e, na Série, uma linha para cada transição dela. Sprint aberto antes da v3.44.1, com o Registro no Sprint Backlog, é lido de lá; antes da v3.51, do `kanban.md`.

## Custo — declarado, não escondido

Este artefato **reaproveita** o que já acontece: no `sprint run`, os scripts gravam a transição sem disparar agente; fora dele, a leitura que o `/sm board` já faz. O Kanban e as Rodadas são gerados por script, sem modelo. **Rodar `/sm board` só para alimentar o gráfico inverte o custo-benefício.**

## Variante — bloco de fix (`fixes/B-<nnn>/kanban.md`)

Gerado **inteiro** pelo `kanban.ps1 -Block B-<nnn>` (`-Init` no `fix plan`, junto com o `consumption.md` do bloco; a G16 cria os dois na primeira rodada se faltarem). Seções: **Kanban** das F-IDs, com as **mesmas colunas do sprint**; **Registro de transições**, derivado das rodadas (dev → 🟨, Arquiteto na F-ID → 🟦, QA → 🟪; fechamento do `verdict.md` → ✅, com "(promovida)" ou "(devolvida)" como nota; "Critério que caiu" → 🔴 "(promoção)"); **Rodadas**, como acima. Sem Série, burndown nem Controle. Com `**Fechado em:**` no `verdict.md`, o script não regrava mais (a pasta é imutável).