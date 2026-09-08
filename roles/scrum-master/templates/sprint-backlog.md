# Sprint Backlog

> **DOCUMENTO VIVO** · **Dono:** SM · **Atualizado em:** <data> · **Estado:** <proposta | vigente>
> Vive em `.team-project/scrum-master/sprint-backlog.md`. As Tasks saem da quebra das Histórias aprovadas, na Planning Meeting ([`../process/workflow.md` §5e](../process/workflow.md)).

## Sprint <n>

| | |
|---|---|
| **Objetivo do sprint** | <uma frase, derivada das Histórias que entraram> |
| **Janela** | <início> → <fim> · duração declarada em `.team-project/README.md` |
| **Capacidade** | <n> · média entregue nos 3 sprints anteriores: <n> |
| **Somatório planejado** | <n> — <dentro da capacidade \| acima, com a justificativa em nota> |

**Capacidade:** <n> desenvolvedor(es). Com um só dev, este quadro é uma **fila** — uma Task em 🟨 por vez (R1). *Est.* é na unidade declarada no contexto do projeto.

Legenda de estado: ⬜ a fazer · 🟦 plano · 🟨 construção · 🟪 QA · ✅ fechada (técnica) · 🔴 bloqueada

> **Fechada ≠ aceita.** ✅ significa veredito ✅ do QA e `/sm close`. O aceite é da **História**, pelo PO, na Sprint Review (R21).

---

## História H-<nnn> — <título> (<criticidade>)

<Uma frase dizendo que valor esta História destrava e por que vem nesta posição.>

**Detalhamento aprovado pelo stakeholder em:** <data — portão ③. Sem isso a História não deveria estar aqui.>

| ID | Task | Est. | Dono | Depende de | Critério de pronto / evidência |
|---|---|---|---|---|---|
| ⬜ T-<nnn> | <o que é feito, em uma linha> | <n> | dev | <IDs ou —> | <como se prova que ficou pronto> |

> Nota do SM: <serialização forçada, migration compartilhada, risco específico — só quando houver>

---

## Entradas fora da Planning

> O Sprint Backlog **não cresce** durante o sprint (R4). A única exceção é o GAP que bloqueia uma História já no sprint. Toda entrada aqui declara **o que saiu para caber**.

| Task | História | Por que entrou fora da Planning | O que saiu para caber | Data |
|---|---|---|---|---|

## Bloqueios e riscos abertos

| # | Task / História | Natureza | Quem destrava | Desde |
|---|---|---|---|---|

## Decisões pendentes do stakeholder

1. <decisão> — destrava <ID>.

---

*Atualizado pelo SM na Planning (`/sm sprint plan`), no acompanhamento (`/sm board`) e a cada `/sm close <T-ID>`. Encerrado em `/sm sprint close`.*

---

## Como preencher

- **ID** — segue a convenção do projeto (`.team-project/scrum-master/context.md`): `T-nnn` para Task, `H-nnn` para História; Task nascida de GAP reusa o ID do GAP; quebra usa sufixo (`T-012a`).
- **Toda Task fica sob a História a que pertence.** Task sem História é violação de R20 e não entra no quadro.
- **Est.** — na unidade declarada no projeto, atribuída pelo time na Planning. Task acima de uma unidade é candidata a quebra (R2), sempre dentro da mesma História.
- **Depende de** — dependência real de execução, não de preferência. É o que define a ordem, mais do que a criticidade.
- **Critério de pronto / evidência** — precisa citar o comando, teste ou passo de UI que prova a conclusão. "Funcionando" não é critério.
- **Uma migration por Task.** Tasks que compartilham a mesma migration viram uma Task só.
- **No fechamento do sprint**, Task não concluída volta ao Product Backlog **junto com a História** — não fica pendurada no quadro do sprint seguinte (R5 · §5e).

### Exemplo

```
## História H-014 — Exportar o resultado da análise (alta)

Destrava a saída do dado da plataforma: hoje o analista refaz o quadro no slide.
Detalhamento aprovado pelo stakeholder em: 03/09/2026

| ⬜ T-041 | Endpoint de exportação respeitando o filtro aplicado | 1 | dev | — | Teste de integração: 214 linhas na tela = 214 no arquivo |
| ⬜ T-042 | Assinatura e expiração de 24h no link de download | 1 | dev | T-041 | Teste: assinatura válida (200), expirada (410), adulterada (403) |
| ⬜ T-043 | Filtro de colunas por permissão do perfil | 1 | dev | T-041 | Teste de isolamento: perfil júnior não recebe a coluna de custo |
```
