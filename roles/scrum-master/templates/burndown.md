# Template — Burndown do Sprint

> **Dono:** SM · Vive em `.team-project/sprints/<n>/burndown.md`
> Nasce no `/sm sprint plan` (linha de abertura, dia 0 — **a data da aprovação do pacote de abertura**, não a do fechamento da Planning · R25), ganha uma linha a cada `/sm board` e a cada `/sm close <T-ID>` (R24), e **fecha** — sem mais edição — no `/sm sprint close`, junto com a retrospectiva e o próprio Sprint Backlog.
> **O que mede:** a estimativa restante (unidade do projeto) das Tasks ainda não fechadas (✅) do sprint corrente, em série datada — não o estado de cada Task, que já está no Sprint Backlog. **De onde sai o dado:** o Registro de transições de [`sprint-backlog.md`](sprint-backlog.md), na mesma pasta (R24). Este arquivo é a leitura em série daquele registro, não uma segunda fonte de verdade — se divergirem, o Registro de transições vence.

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

## Fechamento *(preenchido só no `/sm sprint close`)*
- **Estimativa restante final:** <n> — <zero, se o sprint fechou todas as Tasks | o que ficou, e para onde foi (Product Backlog, com a História — R5)>
- **Objetivo do sprint atingido?** <ver Sprint Review — não é este documento que decide>
```

## Como preencher

- **Uma linha por evento que muda o estado de pelo menos uma Task**, não por dia corrido. Sprint sem eventos num dia não gera linha vazia — burndown não é diário por obrigação, é por evento.
- **Est. restante só cai quando uma Task fecha (✅).** Mover uma Task para 🟦/🟨/🟪 não reduz o restante — só muda a composição das colunas de estado. Se uma linha mostrar o restante caindo sem uma linha de fechamento correspondente no Registro de transições, o dado está errado (R24 · SM verifica).
- **Granularidade declarada, não escondida.** A data das transições 🟦/🟨/🟪 é a data da rodada de `/sm board` que sincronizou o marcador — não a data exata em que o papel terminou o passo. Abertura (dia 0) e fechamento de Task (✅, `/sm close`) são sempre exatos, porque nascem de um comando do próprio SM. Leia o gráfico sabendo disso — é o mesmo princípio do "não exercitado" que o QA declara quando o ambiente não permite verificação plena.
- **O dia 0 é a aprovação do pacote, não o fim da Planning** (R25 · [`../process/workflow.md` §5f](../process/workflow.md)). Entre as duas datas há a costura do protótipo do sprint e a navegação do stakeholder; contar a janela do fim da Planning infla o sprint com tempo em que nenhuma Task podia estar em construção.
- **Fechado no `/sm sprint close`.** A última linha da série é a foto final; nenhuma edição depois — é histórico, como a Retrospectiva e o Review do mesmo sprint, e vive na mesma pasta `sprints/<n>/`.

## Custo — declarado, não escondido

Este artefato **reaproveita** a leitura que o `/sm board` já faz para sincronizar o quadro — não abre um canal de coleta próprio, e não pede a nenhum outro papel (Arquiteto, dev, QA) que grave timestamp nenhum nos próprios comandos. O preço dessa economia é a granularidade: sprint acompanhado de perto (`/sm board` frequente) produz um burndown fino; sprint sem acompanhamento intermediário produz um burndown grosseiro, com só o ponto de abertura e os pontos de fechamento de Task. **Rodar `/sm board` só para alimentar o gráfico, sem necessidade real de acompanhamento, inverte o custo-benefício** — o burndown é subproduto do acompanhamento do sprint, nunca motivo para criar rodadas de `/sm board` que o sprint não pediria de outra forma.

**Se o time precisar de granularidade fina por estado (🟦/🟨/🟪 com timestamp exato do próprio papel que terminou o passo),** isso exige instruir `commands/arc.md`, `commands/dev.md` e `commands/qa.md` a reportar o instante da transição — fora do alcance do SM (são do stakeholder/Arquiteto) e fora do escopo desta versão do artefato. Registrar como pedido explícito ao stakeholder, não assumir.

## Exemplo de leitura

> Dia 0: 8 Tasks, 12 unidades restantes. Dia 3 (`/sm close T-041`): 11 restantes, T-041 fechada. Dia 7 (`/sm board`, sem fechamento): ainda 11 restantes, mas 3 Tasks em 🟨 — o board mudou, o burndown não, porque nenhuma fechou. Dia 9 (`/sm close T-042`, `T-043`): 8 restantes.
> Leitura: o sprint teve ritmo de fechamento concentrado nas duas últimas rodadas — não dá para saber se 🟨 demorou 4 dias ou 1, porque a granularidade intermediária é a do `/sm board`, não do evento real (declarado acima, não escondido).
