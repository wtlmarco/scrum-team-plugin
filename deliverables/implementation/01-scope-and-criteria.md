# Modelo — `01-scope-and-criteria.md`

> **Dono:** PO · **Muda quando:** escopo de um ciclo é definido, concluído ou revisto · **Revisa:** SM (planejamento), QA (verificabilidade dos critérios)

É o documento do **combinado**: o que cada ciclo entrega e como saber que o produto chegou onde precisava chegar. Não é o quadro de trabalho — o quadro é a fila do momento, este é o acordo de escopo.

## Estrutura

```markdown
# ESCOPO — Tarefas e Critérios de Sucesso

# 1. Tarefas por ciclo

## Ciclo 0 — <nome> *(concluído em <data>)*
<Uma frase: o que este ciclo entrega e por que vem nesta posição.>

- [x] <tarefa concluída>
- [ ] <tarefa pendente>

**Depende de:** <ciclos anteriores ou decisões externas>
**Entregável observável ao fim do ciclo:** <o que dá para demonstrar>

## Ciclo 1 — <nome>
…

# 2. Estratégia de implementação
<Por que os ciclos estão nesta ordem: dependência técnica, redução de risco, valor entregue cedo.>

# 3. Critérios de sucesso
<A régua do produto, independente de ciclo. Numerados e estáveis.>

| # | Critério | Como verificar |
|---|---|---|
| 1 | <o que o produto precisa fazer> | <comando, fluxo ou medição que comprova> |

# 4. Backlog pós-escopo atual
<O que ficou fora, com o motivo e o gatilho de reavaliação.>
```

## Regras

- **Marcar `[x]` exige evidência.** A marcação é do PO, mas a evidência vem do QA. Tarefa marcada sem evidência é o defeito mais comum deste documento.
- **Critério de sucesso tem "como verificar".** Sem isso ninguém consegue dizer se o produto chegou lá — e o critério vira retórica.
- **Critérios são numerados e estáveis.** Há código, testes e registros de status apontando para os números.
- **Tarefa nova não entra durante a execução de um ciclo.** Entra no backlog e é replanejada — é o que impede escopo antecipado (R4).
- **O que ficou fora fica escrito**, com gatilho de reavaliação. Decisão de não fazer também é decisão.

## Falhas comuns

| Falha | Como detectar |
|---|---|
| Ciclo inteiro marcado como concluído, com critérios não atendidos | Cruzar com `pending.md` — é o achado nº 1 de auditoria em projeto retomado |
| Critério de sucesso sem verificação | Ninguém consegue produzir evidência; o aceite vira opinião |
| Tarefas acrescentadas no meio do ciclo, sem registro | O ciclo estoura e ninguém sabe explicar por quê |
| Backlog sem gatilho de reavaliação | A mesma ideia volta toda semana |

## Relação com os demais documentos

- Cada tarefa rastreia até um requisito (`01-requirements` do SDD) ou a um GAP (`pending.md`).
- O progresso real de cada ciclo é registrado em `02-status.md` pelo SM.
- A reavaliação honesta dos critérios contra o código vive em `pending.md`, feita pelo QA — quando os dois divergem, `pending` vence.
