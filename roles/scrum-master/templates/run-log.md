# Template — Registro de decisões do run (`sprints/<n>/run-log.md` · `fixes/B-<nnn>/run-log.md`)

> **Dono:** SM · **Escritores:** a sessão que orquestra o `/sm sprint run` ou o `/sm fix run` (mesmo precedente do `consumption.md`) e o **executor de Task** (`task-runner`, v3.52.2), só as linhas da Task ou F-ID que conduz · **Nasce** no primeiro registro do run · Roteiros: [`../process/sprint-run.md`](../process/sprint-run.md) §Registro de decisões · [`../process/fix-run.md`](../process/fix-run.md) · Regra: R29 (a sessão nova não herda a conversa)

```markdown
# Registro de decisões do run — <S<n> | B-<nnn>>
> DOCUMENTO VIVO até o fechamento do sprint/bloco · Dono: SM · Escritores: a sessão que orquestra e o executor de Task (só as linhas da Task dele)

| Quando | Item | Decisão | Porquê | Evidência |
|---|---|---|---|---|
| aaaa-mm-dd hh:mm | T-<nnn> / F-<nnn> / S<n> | <o que foi decidido, em uma frase> | <a razão, em uma frase> | <caminho do arquivo, comando ou linha do guards.log> |
```

## Regras

- **Uma linha por decisão que não está em outro lugar.** Entra: rota de 🔺 GAP (quem decidiu e onde), retomada (mesmo agente ou instância nova, e por quê), bloqueio e o degrau, escolha entre opções, exceção do roteiro, Task pulada. **Não entra** o que o quadro, o cartão ou um script já guardam (tabela abaixo).
- **Quem lê, e quando:** a sessão nova **só** em retomada do run, em bloqueio e na Review (`/sm sprint review` / fechamento do bloco). Fora disso não é leitura de abertura — não pesa o contexto.
- **Sem conteúdo colado:** o porquê cabe em uma linha e a evidência é um **caminho** (R28). Linha longa é sinal de que o assunto pede o plano, o relatório ou a ficha — e o log só aponta para eles.
- **Quem escreve o quê (v3.52.2).** O executor de Task: rota de GAP, retomada por instância nova, reparo de ambiente e a parada da Task que conduz, com o ID dela no Item — **no `sprint run`, a rota do GAP e a queda de ambiente o `run.ps1 done -Result gap|env` grava por ele** (v3.52.3), e ele acrescenta a decisão que o Arquiteto estendeu a outras Tasks. A sessão: retomada após queda (o que o `.interrupted` trouxe), bloqueio e degrau, Task pulada, abertura da `Q-S<n>`, decisão do portão. Ninguém escreve linha de outro.
- **Só se acrescenta.** Linha escrita não se reescreve; correção é linha nova. Fecha com o sprint (`sprints/<n>/`) ou com o bloco (`## Fechamento`).

## O que fica onde — sem duplicar

| Arquivo | Guarda | O `run-log.md` NÃO repete |
|---|---|---|
| `kanban.md` — "Registro de transições" e Série | cada mudança de marcador da Task (🟦 🟨 🟪 ✅ 🔴), quem a produziu e quando | a transição; só o **porquê** quando ele não é óbvio (ex.: Task 🔴 e o degrau) |
| `handoff/<T-ID>.md` (cartão de passagem) | o estado da Task para uma instância nova: plano, decisões do papel, o que falta | o conteúdo do cartão; o log só diz que a retomada foi por instância nova e por quê |
| `guards.log` | cada negação de guarda (hora, papel, alvo) | a negação; o log registra a **rota** tomada (🔺 GAP, ajuste) e aponta a linha |
| `.usage-limit` | o sinal do corte por limite de uso da conta (apagado pelo `run.ps1 next`) | o corte; o log só anota a retomada se houve escolha (qual agente voltou, como) |
| `.safe-point` | o ponto seguro depois da Task fechada (task, sprint, desde; só no `sprint run`) | a parada |
| `.interrupted` | os agentes em voo quando a sessão anterior caiu (movidos pelo `SessionStart`; lidos e apagados pelo `run.ps1 next`) | a lista; o log anota só a retomada e o que voltou |

Em resumo: **estado e transição** estão no quadro; **negação** no `guards.log`; **passagem de contexto** no cartão; **corte de conta** no `.usage-limit`; o `run-log.md` guarda só a **decisão e o porquê** que nenhum deles carrega.
