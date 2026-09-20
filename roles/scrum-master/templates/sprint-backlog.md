# Sprint Backlog

> **DOCUMENTO VIVO** · **Dono:** SM · **Atualizado em:** <data> · **Estado:** <proposta | vigente | **fechado** em <data>>
> Vive em `.team-project/sprints/<n>/sprint-backlog.md` — dentro da pasta do sprint a que pertence ([`../process/artifact-ownership.md` §1e](../process/artifact-ownership.md)). As Tasks saem da quebra das Histórias candidatas, na Planning Meeting ([`../process/workflow.md` §5e](../process/workflow.md)).
> **Vive e fecha no mesmo lugar:** no `/sm sprint close` este arquivo é **fechado**, não copiado — não existe `sprint-backlog-snapshot.md`.
> O caminho não é fixo: `.team-project/README.md` §2 declara **qual é o sprint corrente**, e é por lá que qualquer papel acha este quadro.

## Sprint <n>

| | |
|---|---|
| **Objetivo do sprint** | <uma frase, derivada das Histórias que entraram> |
| **Janela** | <início> → <fim> · duração declarada em `.team-project/README.md` |
| **Capacidade** | <n> · média entregue nos 3 sprints anteriores: <n> |
| **Somatório planejado** | <n> — <dentro da capacidade \| acima, com a justificativa em nota> |
| **Decisões da Planning** | [`planning.md`](planning.md) — o corte, a varredura de bloqueios e **o que veio da Review anterior e não entrou** |

### Pacote de abertura — o portão ③ deste sprint (R25 · [`../process/workflow.md` §5g](../process/workflow.md))

| | |
|---|---|
| **Aprovado em** | <data — **é o dia 0 do burndown**; nenhuma Task entra em construção antes dela> |
| **Aprovado por** | <stakeholder — nome> |
| **Protótipo navegável do sprint** | <caminho/URL do protótipo costurado com as telas das Histórias que entraram> · **navegado em** <data> · **fluxo ponta a ponta coberto:** <qual> |
| **O que foi submetido** | Sprint Backlog fechado (abaixo) + critérios de aceite das Histórias que entraram + o protótipo acima + `planning.md` |
| **Ajustes pedidos na aprovação** | <o que mudou antes do aceite \| nenhum> |
| **`stories/` congelado em** | <data — as Histórias como foram aprovadas; alterar depois é violação de escopo (R4)> |

> Sem esta seção preenchida, **o sprint não arrancou**: esta aprovação é o portão ③ de **todas** as Histórias abaixo, de uma vez (R20 · R25).

**Capacidade:** <n> desenvolvedor(es). Com um só dev, este quadro é uma **fila** — uma Task em 🟨 por vez (R1). *Est.* é na unidade declarada no contexto do projeto.

Legenda de estado: ⬜ a fazer · 🟦 plano · 🟨 construção · 🟪 QA · ✅ fechada (técnica) · 🔴 bloqueada

> **Fechada ≠ aceita.** ✅ significa veredito ✅ do QA e `/sm close`. O aceite é da **História**, na Sprint Review — o PO conduz, o **stakeholder decide** (R21).

---

## História H-<nnn> — <título> (<criticidade>)

<Uma frase dizendo que valor esta História destrava e por que vem nesta posição.>

**Congelada em:** [`stories/H-<nnn>.md`](stories/) — a História como foi aprovada no pacote de abertura (dono: PO). A fonte **viva** continua sendo o Product Backlog.
**Portão ③:** aprovado no **pacote de abertura deste sprint**, na data acima. Sem ele, nenhuma Task desta História entra em construção.

| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Critério de pronto |
|---|---|---|---|---|---|---|---|
| ⬜ T-<nnn> | <o que é feito, em uma linha> | <n> | dev | <IDs ou —> | [`plan/T-<nnn>-<slug>.md`](plan/) | [`evidence/T-<nnn>.md`](evidence/) | <como se prova que ficou pronto> |

> Nota do SM: <serialização forçada, migration compartilhada, risco específico — só quando houver>

---

## Registro de transições (dado bruto do burndown — R24)

> Toda vez que o marcador de uma Task muda, uma linha entra aqui. Abertura (⬜) e fechamento (✅) são exatos, com a data do `/sm sprint plan`/`/sm close`; estados intermediários (🟦/🟨/🟪) têm a data da rodada de `/sm board` que sincronizou o marcador — não a data exata em que o papel terminou o passo. [`burndown.md`](burndown.md), na mesma pasta, é a leitura em série desta tabela.

| Task | De → Para | Quando | Por quem |
|---|---|---|---|
| T-<nnn> | ⬜ → 🟦 | <data> | Arquiteto (`/arc plan`) |

## Entradas fora da Planning

> O Sprint Backlog **não cresce** durante o sprint (R4). A única exceção é o GAP que bloqueia uma História já no sprint. Toda entrada aqui declara **o que saiu para caber**.

| Task | História | Por que entrou fora da Planning | O que saiu para caber | Data |
|---|---|---|---|---|

## Bloqueios e riscos abertos

> **Todo bloqueio nomeia o degrau em que está** (R25 · [`../process/workflow.md` §5g](../process/workflow.md)). Linha sem degrau é achado de processo; bloqueio parado no degrau 1 por mais de uma caixa de tempo **escala**.

| # | Task / História | Natureza | Degrau | Quem destrava | Desde |
|---|---|---|---|---|---|
| 1 | <T-nnn / H-nnn> | <dependência · lacuna funcional · risco técnico · qualidade> | <par PO+Arquiteto desde <data> \| escalado ao stakeholder em <data> \| estratégico — direto> | <papel ou stakeholder> | <data> |

## Decisões pendentes do stakeholder

> Chega aqui **só o que o degrau 1 não fechou** (PO + Arquiteto), mais a **decisão estratégica**, que vai direto. Cada linha sobe na forma fixa de **R22**: opções descritas · recomendação do time · a via de pedir mais contexto.

| # | Decisão pendente | Por que o degrau 1 não fechou (ou "estratégica — direto") | Task(s) que destrava | Desde |
|---|---|---|---|---|
| 1 | <a decisão, em uma frase> | <o que PO e Arquiteto concluíram, e onde ficaram presos> | <IDs> | <data> |

---

*Atualizado pelo SM na Planning (`/sm sprint plan`), no acompanhamento (`/sm board`) e a cada `/sm close <T-ID>`. **Fechado** em `/sm sprint close` — sem cópia nem snapshot; este arquivo é o registro do sprint.*

---

## Como preencher

- **ID** — segue a convenção do projeto (`.team-project/scrum-master/context.md`): `T-nnn` para Task, `H-nnn` para História; Task nascida de GAP reusa o ID do GAP; quebra usa sufixo (`T-012a`).
- **Toda Task fica sob a História a que pertence.** Task sem História é violação de R20 e não entra no quadro.
- **As colunas Plano e Evidência são ponteiros, não conteúdo.** O plano é do Arquiteto (`plan/`), a evidência é do QA (`evidence/`), e este quadro é o que **relaciona** História ↔ Task ↔ plano ↔ evidência ([`../process/artifact-ownership.md` §1e](../process/artifact-ownership.md)). Ponteiro que não resolve é achado de processo.
- **O ponteiro do protótipo do sprint fica no pacote de abertura, não numa cópia.** O artefato é do UX e vive onde ele declara; duplicá-lo aqui criaria duas verdades.
- **Est.** — na unidade declarada no projeto, atribuída pelo time na Planning. Task acima de uma unidade é candidata a quebra (R2), sempre dentro da mesma História.
- **Depende de** — dependência real de execução, não de preferência. É o que define a ordem, mais do que a criticidade.
- **Critério de pronto / evidência** — precisa citar o comando, teste ou passo de UI que prova a conclusão. "Funcionando" não é critério.
- **Uma migration por Task.** Tasks que compartilham a mesma migration viram uma Task só.
- **No fechamento do sprint**, Task não concluída volta ao Product Backlog **junto com a História** — não fica pendurada no quadro do sprint seguinte (R5 · §5e).
- **Toda mudança de marcador ganha linha no Registro de transições** (R24), mesmo quando a Task não muda de estado numa rodada de `/sm board` — nesse caso, não escreva linha nenhuma; "sem transição" não é evento.
- **🔴 não para a fila do sprint.** A Task bloqueada ganha a linha de transição e entra em "Bloqueios e riscos abertos" **com o degrau nomeado**; a fila segue nas Tasks cujas dependências estão satisfeitas. Só o que o degrau 1 (PO + Arquiteto) não fechar sobe a "Decisões pendentes do stakeholder" (R25).

### Exemplo

```
## História H-014 — Exportar o resultado da análise (alta)

Destrava a saída do dado da plataforma: hoje o analista refaz o quadro no slide.
Congelada em: stories/H-014.md · Portão ③: pacote de abertura aprovado em 03/09/2026

| ⬜ T-041 | Endpoint de exportação respeitando o filtro aplicado | 1 | dev | — | plan/T-041-export-endpoint.md | evidence/T-041.md | Teste de integração: 214 linhas na tela = 214 no arquivo |
| ⬜ T-042 | Assinatura e expiração de 24h no link de download | 1 | dev | T-041 | plan/T-042-signed-url.md | evidence/T-042.md | Teste: assinatura válida (200), expirada (410), adulterada (403) |
| ⬜ T-043 | Filtro de colunas por permissão do perfil | 1 | dev | T-041 | plan/T-043-column-acl.md | evidence/T-043.md | Teste de isolamento: perfil júnior não recebe a coluna de custo |
```
