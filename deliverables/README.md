# Entregáveis do Projeto — Modelos e Responsabilidades

Além de código, o time produz e mantém um **conjunto de documentos de projeto**. Eles não são burocracia: são a memória que permite retomar um projeto meses depois, e a referência contra a qual o QA valida cada entrega.

Este diretório guarda **a estrutura desses documentos**, para que qualquer projeto novo comece com o mesmo esqueleto. O conteúdo preenchido vive no projeto; o caminho concreto está em `.team-project/README.md` §4.

## Conjuntos

| Conjunto | Responde | Onde está o modelo |
|---|---|---|
| **Protótipo funcional** | **O que o stakeholder aprova antes de aprovar o texto**: HTML navegável dos fluxos principais — pré-condição do portão ① | [`prototype/`](prototype/README.md) |
| **SDD** — Software Design Document | **O que o sistema é**: objetivos, requisitos, fluxos, arquitetura, dados, API e histórico | [`sdd/`](sdd/README.md) |
| **Implementação** | **Como a construção está indo**: escopo combinado, progresso, mapa de código, pendências | [`implementation/`](implementation/README.md) |
| **`.team-project/`** | **Como o time opera neste projeto**: o contexto que o `/team init` cria e o `/team update` reconcilia | [`team-project/`](team-project/README.md) |
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
| Protótipo funcional (HTML) | **UX** | Fluxo principal muda, antes do ① | Stakeholder (navega e aprova) |
| `01-scope-and-criteria` | **PO** | Escopo de um ciclo é definido, concluído ou revisto | SM, QA |
| `02-status` | **SM** | Uma Task é fechado ou um ciclo termina | QA (auditoria) |
| `03-code-map` | **QA** | Arquivo de código criado, alterado ou removido | Arquiteto |
| `pending` | **QA** | GAP aberto, fechado ou confirmado como não-gap | SM, Arquiteto |

O SM não escreve nenhum documento do SDD — mas **bloqueia o fechamento de uma Task** cuja mudança não tenha sido refletida neles (regra R12). Em compensação, é o único dono do documento de status.

**Cobertura por papel:** PO 6 documentos · Arquiteto 3 + ADRs (e é o **dono editorial** dos padrões de engenharia, que não são entregável) · QA 2 · SM 1. O dev não é dono de nenhum — sua entrega é código, testes e relatório.

## Como o time usa estes documentos

```
PO escreve objetivo e requisito ──▶ Arquiteto desenha arquitetura, dados e API
                                        └──▶ Plano de Implementação cita a seção aplicável
                                              └──▶ dev implementa com a grafia exata
                                                    └──▶ QA valida código × documento
                                                          └──▶ PO registra no changelog
```

Duas consequências práticas:

- **A grafia é contrato.** Nome de entidade, campo, enum e rota nascem em `04-data-model` e `05-api-model`; qualquer divergência no código é achado de QA, não detalhe (regra R10).
- **Documento desatualizado é defeito.** O QA valida a frente "documentação" em toda entrega; documento que não reflete o código vira GAP.

## Ordem de elaboração num projeto novo — e os dois portões

O SDD sobe em **duas etapas, com aprovação entre elas** (R15 · [`workflow.md` §8](../roles/scrum-master/process/workflow.md)). O conjunto continua sendo **um só, com versão única**: os portões são de **aprovação**, não de arquivo.

| Etapa | Documentos | Dono | Portão |
|---|---|---|---|
| **SDD funcional** | `00-overview-objectives` · `01-requirements` · `02-flows-and-roles` | PO | **① o stakeholder NAVEGA o protótipo e aprova** — e só então o técnico começa |
| **Protótipo funcional** | HTML navegável dos fluxos principais de `02` ([`prototype/`](prototype/README.md)) | UX | pré-condição do ① |
| **SDD técnico** | `03-architecture` · `04-data-model` · `05-api-model` | Arquiteto | **② aprovado** — e só então nascem as Histórias |
| *(contínuo)* | `06-changelog` | PO | a partir da primeira mudança funcional aceita |

Dentro de cada etapa, a ordem:

1. `00-overview-objectives` — sem objetivo declarado, priorizar é chute.
2. `01-requirements` — o suficiente para a primeira fatia, não o catálogo inteiro.
3. `02-flows-and-roles` — quando houver mais de um ator ou etapa assíncrona.
4. `03-architecture` — depois do portão ①, com os requisitos da primeira fatia estáveis.
5. `04-data-model` e `05-api-model` — as partes que a primeira fatia exige.
6. `06-changelog` — a partir da primeira mudança funcional aceita.

**Por que o portão ① existe:** desenhar arquitetura, modelo de dados e contrato de API sobre um entendimento funcional que o stakeholder ainda não referendou é o jeito mais caro de descobrir que ele queria outra coisa — joga-se fora desenho técnico, não texto. **Por que o ① exige protótipo navegado:** aprovar `00`/`01`/`02` lendo é aprovar uma descrição; a divergência entre o que o stakeholder imaginou e o que o time entendeu só aparece quando ele **atravessa o fluxo**, e o que se joga fora ali é HTML descartável. **Por que o ② existe:** História escrita antes de o técnico ser viável promete valor que o time ainda não sabe se consegue entregar.

**Não escreva os sete documentos de conteúdo (`00`–`06`) de uma vez.** Documento escrito antes da necessidade envelhece antes de ser lido. O que precisa existir desde o dia 1 é o `README` do conjunto — o oitavo arquivo do SDD, e o único índice —, para que cada documento tenha lugar quando nascer.

**Depois do portão ②, o SDD vira Histórias** (R20). O PO escreve cada uma com o valor declarado ([`user-story.md`](../roles/product-owner/templates/user-story.md)); o conjunto delas **é** o Product Backlog. A História é detalhada só quando candidata a um sprint, e passa pelo **portão ③** — aprovação do stakeholder — antes da Planning Meeting.

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
| Task concluída tem arquivo correspondente no mapa de código | `01-scope` × `03-code-map` |
| Task concluída tem evidência (comando + saída), não só narrativa | `02-status` |
| Todo GAP tem `arquivo:linha`, impacto e criticidade | `pending` |
| Nenhum critério marcado como atendido sem evidência | `01-scope` × `02-status` |

A auditoria cruzada (`/qa audit`) existe justamente para verificar periodicamente os critérios que atravessam documentos, não só os de uma Task.

## A regra de confiança entre documentos

Estes documentos divergem com o tempo. A hierarquia é fixa:

```
saída real de comando  >  pending  >  03-code-map  >  02-status  >  01-scope
   (fato observado)   (sobre código) (por sessão)   (narrativa)   (combinado)
```

Quando o status diz "concluído" e o registro de pendências diz o contrário, **o levantamento sobre código vence** — e a divergência vira risco no quadro, não um arredondamento.
