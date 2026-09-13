# Implementação — Modelo do conjunto

Enquanto o SDD descreve **o que o sistema é**, este conjunto descreve **como a construção está indo**. São os quatro documentos que respondem, a qualquer momento: o que foi combinado, o que já foi feito, onde está cada coisa no código, e o que ainda está quebrado.

## Os quatro documentos

| Arquivo | Responde | Dono | Modelo |
|---|---|---|---|
| `01-scope-and-criteria.md` | O que foi combinado construir, e como saber que ficou pronto | PO | [modelo](01-scope-and-criteria.md) |
| `02-status.md` | O que já foi feito, com que evidência, e que decisões foram tomadas | SM | [modelo](02-status.md) |
| `03-code-map.md` | Onde está cada arquivo de código e a que entrega pertence | QA | [modelo](03-code-map.md) |
| `pending.md` | O que está quebrado, com evidência, criticidade e **origem** (`time` \| `stakeholder` — o que ele chama de "bug") | QA | [modelo](pending.md) |

## Por que este conjunto existe

Um projeto longo perde memória de três formas, e cada documento cobre uma:

| Perda | Sintoma | Documento que evita |
|---|---|---|
| **Do combinado** | "isso estava no escopo?" | `01-scope-and-criteria` |
| **Do porquê** | uma decisão é redescoberta e rediscutida do zero | `02-status` (seção de decisões) |
| **Do onde** | reimplementar algo que já existe, com outro nome | `03-code-map` |
| **Do que falta** | descobrir em produção o que a equipe já sabia | `pending` |

## A regra de confiança entre eles

Estes documentos podem divergir — e divergem. A hierarquia é fixa:

```
saída real de comando  >  pending.md  >  03-code-map.md  >  02-status.md
   (fato observado)     (levantado      (mantido por      (narrativa de
                        sobre código)     sessão)         quem implementou)
```

Quando `02-status` diz que algo está concluído e `pending` mostra o contrário, **o levantamento sobre código vence**. Essa divergência não é resolvida por opinião: vira risco no quadro do SM e um `/qa audit`.

## Como circulam numa Task

```
PO marca escopo/critério ──▶ dev implementa
                              └──▶ QA atualiza 03-code-map e pending, registra evidência
                                    └──▶ PO aceita ──▶ SM registra em 02-status e fecha
```

Nenhum dos quatro é escrito por dois papéis. `02-status` é do SM mesmo quando o fato veio do QA; `pending` é do QA mesmo quando o GAP foi notado pelo dev.

## Sobre o "protocolo de sessão"

Projetos construídos por agentes com contexto limitado costumam ter também um documento de **protocolo de sessão** — o que anexar, em que ordem, como abrir e fechar. Neste time isso é processo, não entregável: vive em [`../../roles/scrum-master/process/workflow.md`](../../roles/scrum-master/process/workflow.md) e nas [regras de trabalho](../../roles/scrum-master/process/working-rules.md), especialmente R3 (contexto mínimo suficiente) e R5 (interrupção é estado).

Se um projeto herdar um documento desses, ele pode ser mantido como referência histórica — mas o processo vigente é o do time.

## Critérios de qualidade — o que o QA verifica

| Critério | Documento |
|---|---|
| Task marcada como concluído tem arquivo correspondente no mapa de código | `01` × `03` |
| Task concluída tem evidência (comando + saída), não só narrativa | `02` |
| Toda decisão fora da especificação está registrada, com data e justificativa | `02` |
| Todo GAP tem `arquivo:linha`, impacto, criticidade e origem (`time` \| `stakeholder`) declarados | `pending` |
| Nenhum arquivo de código relevante está ausente do mapa | `03` |
| Nenhum critério marcado como atendido sem evidência | `01` × `02` |

A auditoria cruzada (`/qa audit`) percorre exatamente essas verificações — ver [`../../roles/quality-assurance/templates/cross-audit.md`](../../roles/quality-assurance/templates/cross-audit.md).
