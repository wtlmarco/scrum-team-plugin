# Template — Protótipo Funcional (`/ux prototype`)

> **Dono:** UX · **Entregável** — critérios completos em [`deliverables/prototype/README.md`](../../../deliverables/prototype/README.md)
> **Pré-condição do portão ①**: o stakeholder navega o protótipo antes de aprovar o SDD funcional.
> **Não é o protótipo do sprint** ([`sprint-prototype.md`](sprint-prototype.md)), que é peça do pacote de abertura (③ em lote): este cobre os fluxos principais do SDD funcional, aquele cobre as Histórias de um sprint. Ter este recente **não dispensa** aquele.

## Estrutura de arquivos

```
.team-project/user-experience/prototype/
├── index.html          ← ponto de entrada único: índice dos fluxos + o que está fora
├── README.md           ← esta ficha, preenchida
├── verification-log.md ← checkpoint da verificação: append-only, uma linha por tela/fluxo
├── flows/
│   ├── <fluxo-1>.html
│   └── <fluxo-2>.html
└── assets/
    └── style.css       ← um arquivo só; sem build, sem dependência externa
```

**Sem build, sem servidor, sem back-end.** Abre com duplo clique. Se precisar de `npm`, `docker` ou terminal, está grande demais para um protótipo.

## Ficha do protótipo (`prototype/README.md`)

```markdown
# Protótipo Funcional — <produto / fatia> — v<n>

**Dono:** UX · **Atualizado em:** <data> · **Estado:** <em elaboração | navegado | aprovado no ① | vencido>
**Cobre a fatia:** <qual — a mesma que o SDD funcional descreve>

## Como abrir
Abrir `index.html` no navegador. Nada mais.

## Fluxos cobertos
| Fluxo (de `02-flows-and-roles`) | Ator | Arquivo | Caminho completo? | Estados de exceção |
|---|---|---|---|---|
| <nome do fluxo> | <ator> | `flows/<arquivo>.html` | ✅ / parcial: <o que falta> | vazio ✅ · erro ✅ · sem permissão ✅ |

## Requisitos da fatia representados
| RF | Aparece no protótipo? | Onde |
|---|---|---|
| RF-<nnn> | ✅ / ❌ (está em "fora") | <fluxo/tela> |

## O que está FORA deste protótipo
<Escrito também na própria `index.html`. É o que evita aprovar por engano
algo que o stakeholder supôs incluído.>

- <o que não está representado, e por quê>

## Premissas que o protótipo assume
<Coisas que o protótipo mostra de um jeito e ainda não estão decididas —
para o stakeholder não confundir escolha com decisão.>

| Premissa | Se mudar, o que muda no protótipo |
|---|---|

## Registro de verificação (harness)
**Modo desta rodada:** <completo | leve> · **Por quê:** <primeira entrega | mudança transversal
| ajuste pontual em: <telas nomeadas>>
**Rodadas leves consecutivas desde a última completa:** <n de 3>
**Telas/fluxos executados nesta rodada:** <lista>
**O restante está coberto pela verificação completa de:** <data> · protótipo v<n>
**Checkpoint:** `verification-log.md` — <n> linhas · última em <data/hora>
**Relatório do job (R28):** <caminho do `report` devolvido pelo `operator`>

## Execução delegada
| Operator job | Task/História | Modelo | Tokens | Duração |
|---|---|---|---|---|
| `.team-project/operator/<sprint\|pre-sprint>/<job>/` | <Task/História> | <`model:` de `agents/operator.md`> | <n, ou "não disponível — <motivo>"> | <t, ou "não disponível — <motivo>"> |

Uma linha por chamada, com o que ela devolveu ao terminar; nunca estimado (R7). Sem chamada: "nenhuma". Não grava em `consumption.md` — a sessão que disparou transcreve ([`../skills.md` §10](../skills.md)).

## Registro do portão ①
**Navegado pelo stakeholder em:** <data>
**Divergências encontradas na navegação:** <lista, ou "nenhuma">
*(Registro único do ①: o formulário é coletado pelo `/sm sdd` — etapa 2 — depois da navegação; o UX só transcreve. O SM aponta para esta ficha em `context.md`.)*
**Decisão do stakeholder (formulário R22):** <aprovar | aprovar com ajuste | reprovar | pedir mais contexto> · em <data>
**Ajuste pedido:** <o que ele pediu, nas palavras dele — ou "—" se aprovou sem ajuste>
**Situação:** <aprovado | aprovado com ajuste no SDD funcional | devolvido | aguardando contexto>
```

## Checkpoint da verificação (`verification-log.md`)

Gravado **a cada tela ou fluxo concluído**, durante a execução — não ao final. É o que faz uma sessão cortada no meio custar o que faltava, e não tudo de novo (R5 aplicada à verificação, [`../skills.md` §10](../skills.md)).

```markdown
# Verificação do protótipo — registro append-only
| Data/hora | Protótipo | Rodada (modo) | Tela/fluxo | Critérios exercitados | Veredito | O que falhou (trecho) | Ponteiro (`report`) |
|---|---|---|---|---|---|---|---|
| <aaaa-mm-dd hh:mm> | v<n> | <nº> (completo\|leve) | <tela/fluxo> | <critérios, nomeados> | ✅ \| ❌ \| não exercitada | <medido × exigido, elemento, arquivo — ou "—"> | <caminho do `report.md` ou `report-<log>.md` da rodada> |
```

**Nunca reescrever linha antiga.** Reexecução é linha nova. Na retomada, roda-se só o que **não tem linha** da versão corrente.

**As duas últimas colunas andam juntas** (R28): a saída bruta fica em log no disco local e o registro guarda o **trecho** que localiza a falha **mais** o ponteiro do `report` do job — nunca o log colado inteiro, nunca o ponteiro sozinho. Log podado não é achado; gatilho de R28 disparado com o log podado manda re-rodar pelo `operator` ou registrar "não verificado — log podado" (R7). Veredito do `operator` `inconclusivo` entra como **não exercitada**, com o motivo, jamais como ✅ ([`../skills.md` §10](../skills.md)).

## Regras

Os critérios do entregável (pré-condição do ①, navegar ≠ ler, dados plausíveis, estados de exceção, sem decisão técnica, vida do documento) vivem em [`deliverables/prototype/README.md`](../../../deliverables/prototype/README.md) — fonte única, não repetidos aqui; a verificação, em [`../skills.md` §10](../skills.md). Específico desta ficha:

- **Trecho e ponteiro, nunca um sozinho (R28).** Ficha e registro trazem os dois; o harness é delegado ao `operator` e o veredito é do UX.
- **Verificação se grava enquanto acontece.** Uma linha no `verification-log.md` por tela/fluxo concluído; o que tem linha da versão corrente não roda de novo.
