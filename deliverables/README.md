# Entregáveis do Projeto — Modelos e Responsabilidades

Além de código, o time produz e mantém um **conjunto de documentos de projeto**. Eles não são burocracia: são a memória que permite retomar um projeto meses depois, e a referência contra a qual o QA valida cada entrega.

Este diretório guarda **a estrutura desses documentos**, para que qualquer projeto novo comece com o mesmo esqueleto. O conteúdo preenchido vive no projeto; o caminho concreto está em `.team-project/README.md` §4.

## Conjuntos

| Conjunto | Responde | Onde está o modelo |
|---|---|---|
| **SDD** — Software Design Document | **O que o sistema é**: objetivos, requisitos, fluxos, arquitetura, dados, API e histórico | [`sdd/`](sdd/README.md) |
| **Implementação** | **Como a construção está indo**: escopo combinado, progresso, mapa de código, pendências | [`implementation/`](implementation/README.md) |
| **ADR** — Architecture Decision Record | **Por que se decidiu assim**: uma decisão estrutural por documento | [`../roles/architect/templates/adr.md`](../roles/architect/templates/adr.md) |
| **Padrões de engenharia** *(relacionado — não é entregável)* | **Como se constrói aqui**: normativos agnósticos de produto | [`../standards/`](../standards/README.md) |

> **Padrões de engenharia não são um entregável.** São normativo/guia (ver os quatro tipos de documento em [`../README.md`](../README.md)): o time se apoia neles, mas não os elabora nem os versiona por projeto, e o QA não os valida a cada entrega — valida a entrega *contra* eles. Ficam em [`../standards/`](../standards/README.md), diretório de primeiro nível do plugin, irmão de `deliverables/`. Dono editorial: Arquiteto; consumo obrigatório: dev e QA (R16). Entram nesta tabela só para descoberta.

## Propriedade — quem responde por cada documento

Um documento tem **um dono**, que responde pelo conteúdo e pela atualização. Os demais leem, citam e pedem mudança.

| Documento | Dono | Muda quando | Quem revisa |
|---|---|---|---|
| `00-overview-objectives` | **PO** | O produto muda de objetivo, fase ou roadmap | Stakeholder |
| `01-requirements` | **PO** | Requisito novo, alterado ou descontinuado | QA (verificabilidade) |
| `02-flows-and-roles` | **PO** | Muda o modelo conceitual, um ator ou um fluxo | Arquiteto (viabilidade) |
| `03-architecture` | **Arquiteto** | Decisão estrutural, componente ou princípio novo | QA (aderência do código) |
| `04-data-model` | **Arquiteto** | Entidade, campo, enum ou relacionamento | QA (código × modelo) |
| `05-api-model` | **Arquiteto** | Endpoint, contrato ou formato de erro | QA (rota × documento) |
| `06-changelog` | **PO** | Toda mudança funcional aceita | SM (fechamento) |
| `README` (índice) | **PO** | Documento novo entra no conjunto | — |
| `01-scope-and-criteria` | **PO** | Escopo de um ciclo é definido, concluído ou revisto | SM, QA |
| `02-status` | **SM** | Um item é fechado ou um ciclo termina | QA (auditoria) |
| `03-code-map` | **QA** | Arquivo de código criado, alterado ou removido | Arquiteto |
| `pending` | **QA** | GAP aberto, fechado ou confirmado como não-gap | SM, Arquiteto |

O SM não escreve nenhum documento do SDD — mas **bloqueia o fechamento de um item** cuja mudança não tenha sido refletida neles (regra R12). Em compensação, é o único dono do documento de status.

**Cobertura por papel:** PO 6 documentos · Arquiteto 3 + ADRs (e é o **dono editorial** dos padrões de engenharia, que não são entregável) · QA 2 · SM 1. O dev não é dono de nenhum — sua entrega é código, testes e relatório.

## Como o time usa estes documentos

```
PO escreve objetivo e requisito ──▶ Arquiteto desenha arquitetura, dados e API
                                        └──▶ Plano de Execução cita a seção aplicável
                                              └──▶ dev implementa com a grafia exata
                                                    └──▶ QA valida código × documento
                                                          └──▶ PO registra no changelog
```

Duas consequências práticas:

- **A grafia é contrato.** Nome de entidade, campo, enum e rota nascem em `04-data-model` e `05-api-model`; qualquer divergência no código é achado de QA, não detalhe (regra R10).
- **Documento desatualizado é defeito.** O QA valida a frente "documentação" em toda entrega; documento que não reflete o código vira GAP.

## Ordem de elaboração num projeto novo

1. `00-overview-objectives` — sem objetivo declarado, priorizar é chute.
2. `01-requirements` — o suficiente para o primeiro ciclo, não o catálogo inteiro.
3. `02-flows-and-roles` — quando houver mais de um ator ou etapa assíncrona.
4. `03-architecture` — depois que os requisitos do primeiro ciclo estiverem estáveis.
5. `04-data-model` e `05-api-model` — junto com o primeiro Plano de Execução que os exija.
6. `06-changelog` — a partir da primeira mudança funcional aceita.

**Não escreva os sete documentos de conteúdo (`00`–`06`) de uma vez.** Documento escrito antes da necessidade envelhece antes de ser lido. O que precisa existir desde o dia 1 é o `README` do conjunto — o oitavo arquivo do SDD, e o único índice —, para que cada documento tenha lugar quando nascer.

## Critérios de qualidade — o que o QA verifica

| Critério | Vale para |
|---|---|
| Todo requisito tem critério de aceite **e** como verificar | `01` |
| Toda entidade documentada existe no código com a mesma grafia | `04` |
| Todo endpoint documentado existe e responde o contrato descrito | `05` |
| Todo princípio arquitetural tem consequência observável no código | `03` |
| Nenhuma seção descreve funcionalidade removida ou nunca construída | todos |
| Mudança funcional aceita tem entrada no changelog | `06` |
| Nenhum documento contradiz outro do conjunto | todos |
| Item concluído tem arquivo correspondente no mapa de código | `01-scope` × `03-code-map` |
| Item concluído tem evidência (comando + saída), não só narrativa | `02-status` |
| Todo GAP tem `arquivo:linha`, impacto e criticidade | `pending` |
| Nenhum critério marcado como atendido sem evidência | `01-scope` × `02-status` |

A auditoria cruzada (`/qa audit`) existe justamente para verificar periodicamente os critérios que atravessam documentos, não só os de um item.

## A regra de confiança entre documentos

Estes documentos divergem com o tempo. A hierarquia é fixa:

```
saída real de comando  >  pending  >  03-code-map  >  02-status  >  01-scope
   (fato observado)   (sobre código) (por sessão)   (narrativa)   (combinado)
```

Quando o status diz "concluído" e o registro de pendências diz o contrário, **o levantamento sobre código vence** — e a divergência vira risco no quadro, não um arredondamento.
