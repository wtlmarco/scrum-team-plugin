# Modelo — `01-scope-and-criteria.md`

> **Dono:** PO · **Muda quando:** o escopo de um sprint é definido, concluído ou revisto · **Revisa:** SM (planejamento), QA (verificabilidade dos critérios)

É o documento do **combinado**: que Histórias cada sprint entrega e como saber que o produto chegou onde precisava chegar. Não é o quadro de trabalho — o quadro é a fila do momento, este é o acordo de escopo. A unidade de valor é a **História** (R20); Task é trabalho do time e não aparece aqui.

## Estrutura

```markdown
# ESCOPO — Histórias e Critérios de Sucesso

# 1. Histórias por sprint

## Sprint 0 — <objetivo do sprint> *(concluído em <data>)*
<Uma frase: o que este sprint entrega e por que vem nesta posição.>

- [x] H-<nnn> — <título na voz do usuário> — aceita na Review de <data>
- [ ] H-<nnn> — <título na voz do usuário>

**Depende de:** <sprints anteriores ou decisões externas>
**Entregável observável ao fim do sprint:** <o que dá para demonstrar na Review>

## Sprint 1 — <objetivo>
…

# 2. Estratégia de entrega
<Por que os sprints estão nesta ordem: dependência, redução de risco, valor entregue cedo.>

# 3. Critérios de sucesso
<A régua do produto, independente de sprint. Numerados e estáveis.>

| # | Critério | Como verificar |
|---|---|---|
| 1 | <o que o produto precisa fazer> | <comando, fluxo ou medição que comprova> |
```

## Regras

- **Marcar `[x]` exige a História aceita na Sprint Review** (R21), com evidência registrada pelo QA. Task fechada, ou soma de Tasks fechadas, não marca nada. A marcação é do PO; a evidência é do QA.
- **Critério de sucesso tem "como verificar".** Sem isso ninguém consegue dizer se o produto chegou lá — e o critério vira retórica.
- **Critérios são numerados e estáveis.** Há código, testes e registros de status apontando para os números.
- **Escopo do sprint congela na aprovação do pacote de abertura** (R4 · R25). História nova não entra no sprint em curso: vai ao Product Backlog e é replanejada no sprint seguinte — é o que impede escopo antecipado.
- **O que ficou fora vive no "Fora de escopo" do Product Backlog**, com o gatilho de reavaliação. Não se duplica aqui.

## Falhas comuns

| Falha | Como detectar |
|---|---|
| Sprint inteiro marcado como concluído, com critérios não atendidos | Cruzar com `pending.md` — é o achado nº 1 de auditoria em projeto retomado |
| História marcada `[x]` por Tasks fechadas, sem aceite na Review | Conferir o dossiê de aceite da História (R21) |
| Critério de sucesso sem verificação | Ninguém consegue produzir evidência; o aceite vira opinião |
| Histórias acrescentadas no meio do sprint, sem registro | O sprint estoura e ninguém sabe explicar por quê |

## Relação com os demais documentos

- Cada História rastreia até um requisito (`01-requirements` do SDD) ou a um GAP (`pending.md`).
- O progresso real de cada sprint é registrado em `02-status.md` pelo SM.
- A reavaliação honesta dos critérios contra o código vive em `pending.md`, feita pelo QA — quando os dois divergem, `pending` vence.