# Template — Protótipo Funcional (`/ux prototype`)

> **Dono:** UX · **Entregável** — critérios completos em [`deliverables/prototype/README.md`](../../../deliverables/prototype/README.md)
> **Pré-condição do portão ①**: o protótipo está pronto para o stakeholder navegar antes de aprovar o SDD funcional — a navegação é **dele**, e "aprovar" a declara (D2 · R34). O UX garante o HTML **autocontido, pronto para publicar** como artifact.
> **Não é o protótipo do sprint** ([`sprint-prototype.md`](sprint-prototype.md)), que é peça do pacote de abertura (③ em lote): este cobre os fluxos principais do SDD funcional, aquele cobre as Histórias de um sprint. Ter este recente **não dispensa** aquele.

## Estrutura de arquivos

```
.team-project/user-experience/prototype/
├── index.html          ← AUTOCONTIDO: índice dos fluxos + todos os fluxos (uma seção/âncora por fluxo) + o que está fora; CSS e JS inline
├── README.md           ← esta ficha, preenchida
└── verification-log.md ← checkpoint da verificação: append-only, uma linha por tela/fluxo
```

**Sem build, sem servidor, sem back-end.** Abre com duplo clique. Se precisar de `npm`, `docker` ou terminal, está grande demais para um protótipo.

**Autocontido, pronto para publicar (R34 · D5).** O stakeholder pode navegar o protótipo no celular, como **artifact privado** que a **sessão que orquestra** publica (o UX não publica — entrega o arquivo). Por isso `index.html` é **um arquivo só**, e este é o arquivo publicado. Contrato do arquivo:

- scripts externos **só** de cdnjs, jsdelivr, unpkg, tailwind ou jquery; fontes **só** do Google Fonts; todo o resto **inline** (CSS, JS, imagens `data:`);
- **≤ 16 MB** (imagens `data:` contam);
- **só dados fictícios** (R11 — o artifact fica guardado no claude.ai; nada de dado real de cliente);
- **identidade visual do próprio produto** — nada que imite a marca de empresa real de terceiros (a publicação pode ser recusada);
- **layout mobile verificado** (o celular só mostra o mobile; produto com site: o desktop segue pela navegação declarada — D2).

Verificação, na ficha: bloco "Publicável como artifact" abaixo.

## Ficha do protótipo (`prototype/README.md`)

```markdown
# Protótipo Funcional — <produto / fatia> — v<n>

**Dono:** UX · **Atualizado em:** <data> · **Estado:** <em elaboração | navegado | aprovado no ① | vencido>
**Cobre a fatia:** <qual — a mesma que o SDD funcional descreve>

## Como abrir
Abrir `index.html` no navegador. Nada mais.

## Fluxos cobertos
| Fluxo (de `02-flows-and-roles`) | Ator | Onde (âncora em `index.html`) | Caminho completo? | Estados de exceção |
|---|---|---|---|---|
| <nome do fluxo> | <ator> | `index.html#<fluxo>` | ✅ / parcial: <o que falta> | vazio ✅ · erro ✅ · sem permissão ✅ |

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

## Publicável como artifact (R34 · D5)
**Pronto para publicar:** ✅ <data> · ❌ <o que falta>
**Conferido:** scripts externos só de cdnjs/jsdelivr/unpkg/tailwind/jquery · fontes só Google Fonts · resto inline · tamanho <n> MB (≤ 16) · dados só fictícios · identidade visual do próprio produto · layout mobile exercitado (<largura>)
**Versão a publicar:** `<rótulo>` (ex.: `① v2`) — o rótulo identifica a versão; republicar substitui o conteúdo da mesma URL, então cada portão registra a que aprovou.
*(Quem publica é a sessão que orquestra, logada na conta remota do projeto; o UX só entrega o arquivo pronto. Publicação, URL e republicação não são minhas.)*

## Registro do portão ①
**Navegado pelo stakeholder em:** <data> · canal: <celular | terminal> · declarada [· artifact: <URL> · <rótulo>]
**Divergências encontradas na navegação:** <lista, ou "nenhuma">
*(Registro único do ①: o formulário é coletado pelo `/sm sdd` — etapa 2; o UX só transcreve. A navegação é **do stakeholder**: "aprovar" a **declara**, e a linha acima anota a declaração e o canal por onde ele decidiu. `· artifact:` só quando o link foi publicado e levado ao formulário, com a URL e o rótulo da versão que ele viu. O rótulo `**Navegado pelo stakeholder em:**` e a data logo após são lidos pela conferência C2 — não reformular. O SM aponta para esta ficha em `context.md`.)*
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
