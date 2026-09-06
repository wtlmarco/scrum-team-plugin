# Quadro de Trabalho — Sprint Backlog

> **DOCUMENTO VIVO** · **Dono:** SM · **Atualizado em:** <data> · **Estado:** <proposta | vigente>
> Vive em `.team-project/scrum-master/work-board.md`. Fonte dos itens: <origem — levantamento de GAPs, backlog do PO>

Legenda de estado: ⬜ backlog · 🟦 plano · 🟨 construção · 🟪 QA · 🟩 aceite · ✅ fechado · 🔴 bloqueado

**Capacidade:** <n> desenvolvedor(es). Com um só dev, este quadro é uma **fila** — um item em 🟨 por vez. *Est.* é na unidade declarada no contexto do projeto.

---

## Bloco <n> — <objetivo do bloco> (<criticidade>)

<Uma frase dizendo o que este bloco destrava e por que vem nesta posição.>

| ID | Item | Est. | Dono | Depende de | Critério de pronto / evidência |
|---|---|---|---|---|---|
| ⬜ <ID> | <o que é feito, em uma linha> | <n> | dev | <IDs ou —> | <como se prova que ficou pronto> |

> Nota do SM: <serialização forçada, migration compartilhada, risco específico — só quando houver>

---

## Bloqueios e riscos abertos

| # | Item | Natureza | Quem destrava | Desde |
|---|---|---|---|---|

## Decisões pendentes do stakeholder

1. <decisão> — destrava <ID>.

---

*Atualizado pelo SM a cada `/sm plan`, `/sm board` e `/sm close <ID>`.*

---

## Como preencher

- **ID** — segue a convenção do projeto (`.team-project/scrum-master/context.md`): reusa o ID do GAP quando existir; escopo novo usa o do requisito; item de processo usa `OPS-nn`; quebra usa sufixo (`<ID>a`).
- **Est.** — na unidade declarada no projeto. Item acima de uma unidade é candidato a quebra (R2).
- **Depende de** — dependência real de execução, não de preferência. É o que define a ordem, mais do que a criticidade.
- **Critério de pronto / evidência** — precisa citar o comando, teste ou passo de UI que prova a conclusão. "Funcionando" não é critério.
- **Uma migration por item.** Itens que compartilham a mesma migration viram um item só.

### Exemplo

```
| ⬜ ABC-01 | Endpoint de download validando assinatura e expiração | 1 | dev | ABC-02 | Teste de integração: assinatura válida (200), expirada (410), adulterada (403) · smoke baixando um arquivo real |
```
