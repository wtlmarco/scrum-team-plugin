# Template — Burndown do Sprint

> **Dono:** SM · Vive em `.team-project/sprints/<n>/burndown.md`
> Nasce no `/sm sprint plan` (linha de abertura, dia 0 — **a data da aprovação do pacote de abertura**, não a do fechamento da Planning · R25), ganha **uma linha na Série e uma no Registro a cada transição de marcador** — no `sprint run`, escritas pela sessão no momento da passagem ([`sprint-run.md`](../process/sprint-run.md) §Marcador); fora dele, no `/sm board` e no `/sm close <T-ID>` (R24) —, e **fecha** — sem mais edição — no `/sm sprint close`, junto com a retrospectiva e o Sprint Backlog.
> **O que mede:** a estimativa restante (unidade do projeto) das Tasks ainda não fechadas (✅) do sprint corrente, em série datada, e **onde cada Task está** a cada passagem. O marcador vigente de cada Task continua no [`sprint-backlog.md`](sprint-backlog.md); o **Registro de transições** — o histórico datado das passagens, dado bruto do burndown — vive **aqui**, ao lado da Série que o lê, para quem acompanha o sprint ver o andamento num arquivo só (v3.44.1; antes, o Registro ficava no Sprint Backlog).

```markdown
# Burndown — Sprint <n>

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
| T-<nnn> | ⬜ → 🟦 | <aaaa-mm-dd hh:mm> | Arquiteto (`/arc plan`) |

## Fechamento *(preenchido só no `/sm sprint close`)*
- **Estimativa restante final:** <n> — <zero, se o sprint fechou todas as Tasks | o que ficou, e para onde foi (Product Backlog, com a História — R5)>
- **Objetivo do sprint atingido?** <ver Sprint Review — não é este documento que decide>
```

## Como preencher

- **Uma transição = uma linha no Registro + uma linha na Série, no mesmo arquivo e no mesmo momento.** O **Evento** da Série cita a Task e a passagem (`T-041 🟦 → 🟨`); rodada de `/sm board` que move várias Tasks pode fazer uma linha só na Série, citando todas. Sprint sem eventos num dia não gera linha vazia — burndown é por evento, não diário por obrigação.
- **Est. restante só cai quando uma Task fecha (✅).** Passar a 🟦/🟨/🟪 não reduz o restante — muda a composição das colunas de estado, e é ela que mostra o sprint andando entre um fechamento e outro. Restante caindo sem a linha → ✅ correspondente no Registro é dado errado (R24 · SM verifica).
- **Granularidade declarada, não escondida.** No `sprint run`, toda transição (🟦/🟨/🟪/🔴) é gravada **no momento** em que a sessão passa a Task ao papel seguinte (data e hora). Fora do `run` (Task tocada por comando avulso de papel), a data é a da rodada de `/sm board` que sincronizou o marcador. Abertura (dia 0) e fechamento (✅, `/sm close`) são sempre exatos.
- **O dia 0 é a aprovação do pacote, não o fim da Planning** (R25 · [`../process/workflow-sprint.md` §5f](../process/workflow-sprint.md)). Entre as duas datas há a costura do protótipo do sprint e a navegação do stakeholder; contar a janela do fim da Planning infla o sprint com tempo em que nenhuma Task podia estar em construção.
- **Fechado no `/sm sprint close`.** A última linha da Série é a foto final; nenhuma edição depois — é histórico, como a Retrospectiva e o Review do mesmo sprint, e vive na mesma pasta `sprints/<n>/`.
- **Conferido no `close`.** O `close.ps1 -Post` (C1) exige a linha → ✅ no Registro, as passagens → 🟦, → 🟨 e → 🟪 da Task e, na Série, uma linha citando a Task para cada transição dela no Registro — Série com menos linhas é o burndown parado até o fim da Task. Sprint aberto antes da v3.44.1, com o Registro ainda no Sprint Backlog, é lido de lá.

## Custo — declarado, não escondido

Este artefato **reaproveita** o que já acontece: no `sprint run`, a sessão já sabe a cada passo para quem passou a Task e grava a transição sem disparar agente (o marcador no Sprint Backlog, e o Registro e a Série aqui); fora dele, a leitura que o `/sm board` já faz para sincronizar o quadro. Não pede a nenhum papel (Arquiteto, dev, QA) que grave timestamp nos próprios comandos. Fora do `run`, a granularidade é a do acompanhamento: sem `/sm board` intermediário, só aparecem a abertura e os fechamentos. **Rodar `/sm board` só para alimentar o gráfico, sem necessidade real de acompanhamento, inverte o custo-benefício** — o burndown é subproduto do acompanhamento do sprint, nunca motivo para criar rodadas que o sprint não pediria de outra forma.

## Exemplo de leitura

> Dia 0: 8 Tasks, 12 unidades restantes. Dia 1 (`run`): T-041 ⬜ → 🟦 às 10:05, 🟦 → 🟨 às 11:40. Dia 2: T-041 🟨 → 🟪 às 16:20; restante ainda 12 — a composição mostra uma Task em QA. Dia 3 (`/sm close T-041`): 11 restantes.
> Leitura: a T-041 ficou ~29 h em construção e ~1 dia em QA — visível enquanto acontecia, não só no fechamento.
