# Modelo — `pending.md`

> **Dono:** QA · **Muda quando:** um GAP é aberto, fechado ou confirmado como não-gap · **Revisa:** SM (entra na fila), Arquiteto (viabilidade da correção)

É o **registro do que está quebrado**, levantado sobre o código e não sobre a narrativa. É a fonte mais confiável do conjunto de implementação — e a que dá origem ao backlog de retomada de um projeto parado.

## Estrutura

```markdown
# PENDING — GAPs de Implementação

> **Data da revisão:** <data>
> **Escopo:** <o que foi auditado — que partes do código, contra quais documentos>
> **Método:** leitura direta do código-fonte, não das anotações de progresso. Cada item traz evidência no arquivo real.
> **Natureza:** registro de pendências **abertas**. Item resolvido sai daqui e é registrado em `02-status.md`.

## 1. Legenda de criticidade
| Nível | Significado |
|---|---|
| 🔴 Crítica | Funcionalidade documentada não funciona ponta a ponta, ou exposição de segurança concreta |
| 🟠 Alta | Requisito/critério declarado como atendido e não atendido de fato; ou risco operacional relevante |
| 🟡 Média | Divergência entre especificação e código, lacuna de robustez, funcionalidade parcial |
| 🟢 Baixa | Dívida técnica, higiene de repositório, documentação e decisões a formalizar |

## 2. Resumo executivo
| Módulo | 🔴 | 🟠 | 🟡 | 🟢 | Total |
|---|---:|---:|---:|---:|---:|

> **Resolvidos desde a revisão inicial:** <ID> (<o que resolveu>, <data>)

**Leitura de uma frase:** <onde estão os buracos, em linguagem de consequência>

## 3. Critérios de sucesso — reavaliação
<Cada critério de `01-scope-and-criteria`, com a situação real contra o código.>

| # | Critério | Situação real | GAPs relacionados |
|---|---|---|---|

## 4. 🔴 Críticas
### <MÓDULO>-<NN> — <título afirmativo do defeito>
**Módulo:** <área> · **Criticidade:** 🔴
**Evidência:** [<arquivo>:<linha>](<caminho>#L<linha>) — <o fato observado>
**Impacto:** <o que deixa de funcionar, e para quem>
**Ação sugerida:** <direção de correção, não o plano>

## 5. 🟠 Altas
…
## 6. 🟡 Médias · ## 7. 🟢 Baixas
<Podem ser agrupadas por módulo quando forem muitas.>

## 8. Ordem de ataque sugerida
<Agrupada por dependência real, não por criticidade isolada. É o insumo do `/sm plan`.>

## 9. O que **não** é gap
<Itens que pareciam lacuna e foram verificados como corretos, com evidência. Evita retrabalho de auditorias futuras.>

## 10. Manutenção deste documento
<Como abrir, fechar e confirmar não-gap.>
```

O formato de uma entrada individual está em [`../../roles/quality-assurance/templates/gap-record.md`](../../roles/quality-assurance/templates/gap-record.md).

## Regras

- **Levantado sobre código, não sobre anotação.** Todo item tem `arquivo:linha`. Sem evidência conclusiva, o item não entra — fica como suspeita no veredito até ser confirmado.
- **Ordem de ataque por dependência real.** Criticidade diz o que dói mais; dependência diz o que é possível fazer agora. É a seção que o SM usa para montar a fila.
- **A seção "o que não é gap" é entrega, não sobra.** Confirmar que algo está correto poupa a próxima auditoria de reabrir a mesma suspeita.
- **A reavaliação dos critérios é o coração do documento.** É onde a diferença entre "declarado" e "real" fica visível — e onde um projeto retomado descobre o tamanho verdadeiro do trabalho.
- **Item resolvido sai daqui** e é registrado em `02-status.md`. Nunca os dois no mesmo lugar (R12).
- **IDs no padrão `MÓDULO-NN`**, nunca reaproveitados.

## Falhas comuns

| Falha | Consequência |
|---|---|
| GAP sem `arquivo:linha` | Vira suspeita disfarçada de fato; alguém gasta uma sessão para descobrir que não existe |
| Ordem de ataque por criticidade pura | A fila trava: item 🔴 que depende de outro 🔴 é planejado primeiro |
| Impacto escrito em linguagem de código | O stakeholder não consegue priorizar — não sabe quem é prejudicado |
| Documento que só cresce | Sem a seção de resolvidos, ninguém percebe o progresso e a retomada parece infinita |

## Quando este documento nasce

Num projeto novo, `pending.md` começa vazio e cresce com os achados de cada validação. Num projeto **retomado**, ele é o **primeiro** documento a ser produzido: `/qa audit` + `/qa baseline` geram o levantamento que vira o backlog inicial.
