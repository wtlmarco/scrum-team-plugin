# SDD — Software Design Document · Modelo do conjunto

O SDD é o desenho do sistema, dividido por responsabilidade para que qualquer pessoa (ou agente) implemente uma parte sem carregar o documento inteiro — princípio de contexto mínimo suficiente (regra R3).

## Os sete documentos de conteúdo

| Arquivo | Etapa | Conteúdo | Dono | Modelo |
|---|---|---|---|---|
| `00-overview-objectives.md` | funcional | Visão geral, objetivos, fases, roadmap | PO | [modelo](00-overview-objectives.md) |
| `01-requirements.md` | funcional | Requisitos funcionais e não funcionais | PO | [modelo](01-requirements.md) |
| `02-flows-and-roles.md` | funcional | Modelo conceitual, atores e fluxos | PO | [modelo](02-flows-and-roles.md) |
| `03-architecture.md` | técnica | Princípios, estrutura, componentes e integrações | Arquiteto | [modelo](03-architecture.md) |
| `04-data-model.md` | técnica | Entidades, campos, enums, relacionamentos | Arquiteto | [modelo](04-data-model.md) |
| `05-api-model.md` | técnica | Endpoints, contratos e formato de erro | Arquiteto | [modelo](05-api-model.md) |
| `06-changelog.md` | contínua | Histórico cumulativo de mudanças | PO | [modelo](06-changelog.md) |

**Sete linhas, sete documentos.** A coluna **Etapa** diz de que lado de cada portão o documento está: os três `funcional` sobem primeiro e passam pelo **portão ①**; os três `técnica` só começam depois dele e passam pelo **②**; o `06-changelog` corre em paralelo, a partir da primeira mudança funcional aceita.

> **Os sete sobem por dois portões.** `00`, `01` e `02` formam o **SDD funcional** (dono: PO) e passam pelo **portão ①** — aprovação do stakeholder — antes de o Arquiteto escrever `03`, `04` e `05`, o **SDD técnico**, que passa pelo **portão ②** antes de a primeira História nascer (R15 · [`../README.md`](../README.md)). Os portões são de **aprovação**, não de arquivo: o conjunto continua sendo um só, com versão única.

> **O oitavo arquivo é o índice.** O `README.md` do SDD no projeto (dono: **PO**) não é documento de conteúdo — é o único índice do conjunto, e o que precisa existir desde o dia 1, para que cada documento tenha lugar quando nascer. Seu modelo é a seção seguinte. Por isso o conjunto tem **oito arquivos: sete de conteúdo (`00`–`06`) mais o índice**.

## Modelo do índice (`README.md` do SDD no projeto)

```markdown
# SDD — <nome do produto>

**Versão atual:** <x.y> · **Data:** <data> · **Status:** <Draft | Em implementação | Estável>

<Uma frase: o que este conjunto descreve e por que está dividido em arquivos por responsabilidade.>

## Índice

| Arquivo | Conteúdo |
|---|---|
| `00-overview-objectives.md` | Visão geral do produto, objetivos e visão de evolução |
| `01-requirements.md` | Requisitos funcionais (RF) e não funcionais (RNF) |
| `02-flows-and-roles.md` | Modelo conceitual, papéis dos atores e fluxos |
| `03-architecture.md` | Princípios arquiteturais, estrutura, componentes e integrações |
| `04-data-model.md` | Entidades, relacionamentos e regras de modelagem |
| `05-api-model.md` | Endpoints e contratos |
| `06-changelog.md` | Histórico de mudanças |

## Documentos relacionados (fora deste diretório)

| Documento | Conteúdo |
|---|---|
| <diretório de ADRs> | Decisões arquiteturais formalizadas |
| <padrões de engenharia> | Normativos agnósticos de produto |
| <documentos de implementação> | Escopo, progresso, inventário de código e pendências |

## Stack

<Tecnologias principais, em uma linha.>
```

## Regras do conjunto

- **Versão única para o conjunto.** Os sete documentos de conteúdo (`00`–`06`) evoluem juntos; a versão fica no índice e no changelog, não espalhada por arquivo.
- **Marque o que mudou.** A convenção `*(novo vX.Y)*` / `*(revisado vX.Y)*` ao lado do título de uma seção permite ler a evolução sem abrir o changelog.
- **Referência cruzada em vez de repetição.** Um fato vive num documento só; os outros apontam para ele. Duplicar é criar duas verdades para manter.
- **Nada de código de implementação.** O SDD descreve o desenho; exemplos existem para desambiguar contrato, não para servir de fonte.
- **A grafia é contrato.** O que está em `04` e `05` é o nome real no código.

## Como o QA valida

| Frente | O que checa |
|---|---|
| Nomenclatura | entidade, campo, enum e rota do código batem com `04`/`05` |
| Completude | requisito implementado tem entrada em `01` com critério verificável |
| Aderência | princípio de `03` tem consequência observável no código |
| Atualidade | nenhuma seção descreve algo removido ou nunca construído |
| Consistência | nenhum documento contradiz outro |
