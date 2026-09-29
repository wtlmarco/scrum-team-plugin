# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
| [`v3.30`](process-changelog-archive.md) | R29 nova: checkpoint de sessão entre fases heterogêneas; item de build em background fechado por já coberto (R28); sequenciamento de branch do projeto-cliente fora do alcance (SM) — 22/09/2026 |
| [`v3.29`](process-changelog-archive.md) | R28 troca o mecanismo impossível pelo implementável (arquivo na origem + agente `operator`); R26 aceita medição do `operator`; agente conta sobe a 7 (SM + PO + Arquiteto + QA + UX) — 21/09/2026 |
| [`v3.28`](process-changelog-archive.md) | R26(i) passa a cobrir o plano inteiro, não só o primeiro passo; R28 nova poda o log de build do contexto do subagente (SM) — 21/09/2026 |
| [`v3.27`](process-changelog-archive.md) | Os três pontos abertos de `note.md` resolvidos em formulário: teto da R17 escala, R27 nova, R5 ganha o lado de quem orquestra (SM) — 20/09/2026 |
| [`v3.26`](process-changelog-archive.md) | UX desce de Opus para Sonnet, por medição de custo (stakeholder) — 20/09/2026 |
| [`v3.25`](process-changelog-archive.md) | R26 (plano mede o ambiente); gate desligado/não exercitado é 🔺 GAP; consumo cobre notificação parcial; R9 decide-e-documenta (item 2a) (SM + Arquiteto) — 20/09/2026 |
| [`v3.24`](process-changelog-archive.md) | O ciclo do sprint: ③ em lote sobre pacote navegável, bloqueio em dois degraus, registro por sprint (5 papéis) — 20/09/2026 · *com addendum de 20/09/2026 sobre o teto da R17* |
| [`v3.23`](process-changelog-archive.md) | Segundo giro Act: a tabela de indicadores parava de dizer algo novo em 13 das 23 linhas (SM) — 18/09/2026 |
| [`v3.22`](process-changelog-archive.md) | Giro Act do ciclo de eficiência: footprint remedido e a arqueologia do `consult` sai de §5c (SM) — 18/09/2026 |
| [`v3.21`](process-changelog-archive.md) | Product Backlog deixa de conter a História: índice com ponteiro, conteúdo em arquivo próprio do PO (§1d) |
| [`v3.20`](process-changelog-archive.md) | Pendência do stakeholder resolvida em formulário: R22 ganha o meio de apresentação, restrito a quem orquestra (SM) — 18/09/2026 |
| [`v3.19`](process-changelog-archive.md) | Pasta `sprints/<n>/` para Review/Retrospectiva/snapshot, burndown desenhado (R24), tríade R18, duas contagens e uma contradição entre normativos (SM) — 16/09/2026 |
| [`v3.18`](process-changelog-archive.md) | As três decisões escaladas em v3.17 fechadas: arquivamento por sprint, granularidade definitiva, e as duas propostas aplicadas sob a restrição de escopo `.team-project/` (SM) — 15/09/2026 |
| [`v3.17`](process-changelog-archive.md) | Registro de consumo do time: propriedade, modelo e gancho no ciclo de eficiência; gravação e exibição propostas ao stakeholder (SM) — 15/09/2026 |
| [`v3.16`](process-changelog-archive.md) | Tabela de custo remedida (v3.4 → v3.16) e R18 realinhada ao modelo de branch em uso (`develop`, empilhamento) (SM) — 14/09/2026 |
| [`v3.15`](process-changelog-archive.md) | `/po accept` alinhado a R21, vão de alcance do `/review` fechado, resíduo de find-replace e numeração da própria entrada corrigidos (SM + Arquiteto) — 14/09/2026 |
| [`v3.14`](process-changelog-archive.md) | Nascimento dos documentos de implementação declarado, rastreio de pendências no onboarding, bug do stakeholder no fluxo e em `.team-project/note.md`, e curadoria da rodada (SM) — 12/09/2026 |
| [`v3.13`](process-changelog-archive.md) | O bug entra pelo PO: classificação do relato do stakeholder, e a fila `.team-project/note.md` tratada em lote (PO) — 12/09/2026 |
| [`v3.12`](process-changelog-archive.md) | Pendências e bugs num só registro: campo `origem`, leitura filtrada do stakeholder e estado de escalação em `pending.md` (QA) — 12/09/2026 |
| [`v3.11`](process-changelog-archive.md) | Delegar tarefa simples de PO/SM/UX/QA ao dev (Haiku): proposta avaliada e descartada — 12/09/2026 |
| [`v3.10`](process-changelog-archive.md) | Pendentes de v3.8/v3.9 aplicados a pedido do stakeholder: timeout do Arquiteto, verificação do protótipo no comando e retomada nativa entre invocações — 12/09/2026 |
| [`v3.9`](process-changelog-archive.md) | Spike do Arquiteto para de travar: timeout/backoff na borda externa, checkpoint por etapa e modo leve de verificação — 12/09/2026 |
| [`v3.8`](process-changelog-archive.md) | Harness do protótipo grava enquanto roda e mede o próprio escopo: checkpoint por tela e modo leve (UX) — 12/09/2026 |
| [`v3.7`](process-changelog-archive.md) | Consumo de sessão em uso intensivo: leitura incremental, checkpoint de verificação pesada, limite de paralelismo e modo leve de verificação (parte geral, SM) — 12/09/2026 |
| [`v3.6`](process-changelog-archive.md) | Pergunta ao stakeholder ganha forma fixa: opções descritas, recomendação e a via de pedir mais contexto (R22) — 10/09/2026 |
| [`v3.5`](process-changelog-archive.md) | Três reforços de coerência: banner do README no gate de fechamento, mensagem de bloqueio do `/review` e avaliação de impacto no `/team update` — 10/09/2026 |
| [`v3.4`](process-changelog-archive.md) | Substantivo homônimo em lista de proibição: a régua, as cinco correções e o fecho do `/review note` — 09/09/2026 |
| [`v3.3`](process-changelog-archive.md) | O canal do stakeholder é o PO; o broadcast acaba; prazo, plano e status mudam de dono — 08/09/2026 |
| [`v3.2`](process-changelog-archive.md) | A métrica de eficiência para de medir história fria; o `/review` sai do caminho quente — 08/09/2026 |
| [`v3.1`](process-changelog-archive.md) | Protótipo funcional em HTML vira entregável e pré-condição do portão ①; o Sprint Backlog ganha o próprio nome — 08/09/2026 |
| [`v3.0`](process-changelog-archive.md) | Redesenho do modelo de trabalho: História e Task, sprint como caixa de tempo, aceite na Sprint Review — 08/09/2026 |
| [`v2.11`](process-changelog-archive.md) | Guias de raiz ganham dono; roteiro de instalação endurecido; R19 passa a exigir checagem semântica — 07/09/2026 |
| [`v2.10`](process-changelog-archive.md) | Reavaliação do conjunto: caminho de escrita do `/review`, contagem de regras e modo `note` reconciliados — 07/09/2026 |
| [`v2.9`](process-changelog-archive.md) | Processo de atualização e lançamento do plugin ganha documento e dono — 06/09/2026 |
| [`v2.8`](process-changelog-archive.md) | Evolução do processo num comando só: `/review`, guardado ao repositório-fonte, com `note.md` como fila — 06/09/2026 |
| [`v2.7`](process-changelog-archive.md) | Faxina pós-isolamento em plugin: resíduo de caminho, contagens do UX e extração dos modos frios — 06/09/2026 |
| [`v2.6`](process-changelog-archive.md) | QA frente 2 ganha a redação final: objeto próprio e o terceiro achado de processo — 06/09/2026 |
| [`v2.5`](process-changelog-archive.md) | Obsolescência corrigida nos documentos do Arquiteto: comply sob demanda e Ficha até V21 — 06/09/2026 |
| [`v2.4`](process-changelog-archive.md) | Aderência ao plano × aderência ao standard: `/arc comply` e a frente 2 do QA verificam objetos diferentes — 06/09/2026 |
| [`v2.3`](process-changelog-archive.md) | PO ganha a forma completa do RNF de performance e a cadeia RNF → V18 → veredito — 06/09/2026 |
| [`v2.2`](process-changelog-archive.md) | QA alinhado a R16 e ganha a frente de desempenho; veredito endereçado ao stakeholder — 06/09/2026 |
| [`v2.1`](process-changelog-archive.md) | PERF-TEST fechada: desempenho vira obrigação verificável nos dois níveis do `standards/` — 06/09/2026 |
| [`v2.0`](process-changelog-archive.md) | Changelog arquivado, contrato do `review` extraído, ciclo de eficiência PDCA e teto por entrada (R17) — 06/09/2026 |
| [`v1.9`](process-changelog-archive.md) | Arquiteto e dev revistos à luz de `.team/standards/` como base compartilhada; GAP de tipo `standard` ganha forma — 05/09/2026 |
| [`v1.8`](process-changelog-archive.md) | `standards/` promovido a diretório de primeiro nível e reclassificado como base de qualidade compartilhada (R16) — 05/09/2026 |
| [`v1.7`](process-changelog-archive.md) | Onboarding do projeto (R14) e brainstorm de descoberta funcional (R15) — 05/09/2026 |
| [`v1.6`](process-changelog-archive.md) | UX com repertório de padrões consolidados e método de pesquisa acionável por gatilho — 02/09/2026 |
| [`v1.5`](process-changelog-archive.md) | SM com repertório de PMBOK e APF acionável por gatilho, sobre a base Scrum — 02/09/2026 |
| [`v1.4`](process-changelog-archive.md) | Standards em dois níveis: princípios agnósticos de linguagem (Clean Architecture · Clean Code · CQRS · cobertura 80%) — 02/09/2026 |
| [`v1.3`](process-changelog-archive.md) | Reavaliação obrigatória no `review`, e os documentos do dev passam ao Arquiteto — 02/09/2026 |
| [`v1.2`](process-changelog-archive.md) | Evolução do processo distribuída por papel — 02/09/2026 |
| [`v1.1`](process-changelog-archive.md) | Comando de evolução do processo — 02/09/2026 · *(substituída pela v1.2)* |
| [`v1.0`](process-changelog-archive.md) | Linha de base do time — 01–02/09/2026 |

---

## v3.33 — Retrospectiva analisa consumo por papel e por modelo, procura ineficiência e gera o relatório ao dono do plugin (SM) — 29/09/2026

**Instrução** (`note.md`, `/review note`, item único): usar a retrospectiva para melhorar o processo analisando o uso de tokens de cada papel durante o sprint e os modelos usados em cada um, em busca de ineficiência por processo repetitivo, gap, bloqueio, falha e uso excessivo de tokens, **por meio de um relatório enviado ao dono do plugin**, para que o modelo possa ser melhorado.

**Classificação:** cerimônia (retrospectiva) + formato de documento (`consumption.md`, `retrospective.md`) + propriedade de artefato nova (`plugin-report.md`, SM). Sem regra nova: nenhuma obrigação de papel muda, só o conteúdo de uma cerimônia do SM e um artefato dele. Rodada de **um papel** (SM) — barreira aplicável: 10 KB.

**Levantamento das lacunas (confirmado contra os arquivos, não presumido):**

| Lacuna | Veredito | Evidência |
|---|---|---|
| (a) modelo por papel/invocação não é registrado | **real** | `consumption.md` só tinha Tokens e Duração; `retrospective.md` idem |
| (b) a retro não analisa ineficiência | **real** | a seção de consumo só somava por papel e comparava com o sprint anterior; "Divergência contra a carga fixa" era a única leitura |
| (c) sem relatório formal ao dono do plugin | **real, em parte** | havia a tabela "Sintomas para o `note.md`", que o stakeholder "decide se leva" — sem consumo, sem modelo, sem ineficiência e **sem regra contra vazamento de contexto do projeto** |
| tokens de cada papel por sprint; retro lê o registro; PDCA (§5c) | **já existia** | não duplicado |

**Observabilidade do modelo (o que se pode afirmar):** a notificação de fim de subagente devolve tokens (um total) e duração — **não o modelo**. O que a sessão que orquestra vê é o agente que disparou e o `model:` do cartão `agents/<papel>.md` (hoje: Opus no Arquiteto, Sonnet em SM/PO/QA/UX, Haiku em dev/`operator`) ou um override que ela passou. O registro grava **o modelo configurado, não o servido**; sem leitura do cartão nem override, "não disponível — motivo". Divisão entrada/saída/cache não é observável e a análise não a presume.

### O que mudou

| Documento | Seção | Mudança |
|---|---|---|
| `templates/consumption.md` | tabela de registro, totais, regras | Coluna **Modelo** por invocação e nos totais; regra "modelo é o configurado, não o servido" (com a régua "não disponível — motivo" e a nota de que tokens são um total) |
| `templates/retrospective.md` | "Consumo real do sprint" | Coluna Modelo; nova tabela de **ineficiência** com cinco verificações mensuráveis sobre o registro — papel repetido na mesma Task/História (alerta a partir de 3), Task/História cara (> 2× a média), papel desproporcional (contra a carga fixa), modelo × trabalho, consumo × falha (cruza com reprovação, reabertura, GAP, bloqueio); regra "aponta onde olhar, não o que cortar" |
| `templates/retrospective.md` | "Sintomas para o `note.md`" → "Relatório ao dono do plugin" | A tabela de sintomas **sai daqui** e vai para o novo arquivo; a retro guarda o ponteiro e duas linhas de encerramento (gerado? relido contra vazamento? encaminhado?) |
| `templates/plugin-report.md` | **novo** | Relatório em 5 seções — consumo por papel × modelo, ineficiências, bloqueios/falhas de processo (com o degrau de R25), sintomas, encaminhamento —, com **lista do que não entra** (nome, cliente, domínio, código, caminho, ID de Task/História — "Task A") e o fluxo: SM escreve, **stakeholder lê e encaminha**, `/review` no clone-fonte transforma em mudança |
| `workflow.md` | §5c (parágrafo novo); "Como o SM verifica"; fechamento de `sprints/<n>/` | A retro como análise de consumo e origem do relatório; +1 linha de verificação (modelo por linha, leitura de ineficiência, relatório sem contexto); `plugin-report.md` entra na lista da pasta completa |
| `artifact-ownership.md` | linha de consumo (§1); árvore e tabela §1e | `plugin-report.md`: dono SM, sai do projeto pela mão do stakeholder; consumo cita o modelo |
| `README.md` do SM; `templates/project-context.md`; `how-to.md`; `team-init.md`; `README.md` (raiz); `deliverables/team-project/README.md` | árvores e índices de `sprints/<n>/` | Coerência de referência cruzada: `plugin-report.md` listado onde a pasta é descrita (exceção de curadoria, sem mudança de comportamento) |

### Por quê

O consumo era **medido e ninguém o interpretava**: a retro somava tokens por papel e parava, sem dizer se um papel foi chamado três vezes para a mesma Task, se uma Task custou o triplo das outras ou se o trabalho mecânico caiu no modelo caro — e sem o modelo registrado, "Arquiteto custa mais que o SM" não distinguia preço de modelo de volume de trabalho (§5c já avisa que o modelo pesa mais que os KB). E o caminho de volta ao dono do plugin era uma tabela solta que o stakeholder teria de recortar à mão da retrospectiva — que carrega contexto do projeto —, sem barreira de vazamento. Um arquivo próprio, sem contexto, com fluxo declarado, dá ao `/review` evidência numérica em vez de impressão.

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda |
|---|---|
| **SM** | Na retro, lê o registro por ineficiência e escreve `plugin-report.md` sem contexto de projeto; verifica que cada linha de consumo traz o modelo |
| **Quem orquestra** | Grava o modelo em cada linha (instrução nos sete comandos de papel, aplicada em 29/09/2026) |
| **Stakeholder** | Lê o relatório antes de encaminhar — é a barreira final contra vazamento — e decide o que vai ao `note.md` |

### Conflitos com o processo vigente

Nenhum. Confrontado com: R7 (número sem fonte → regra "n/a"/"não disponível", sem estimativa); R25/§5f (pasta fecha por último — o relatório é escrito antes do fechamento, entra na lista); "o projeto não edita o plugin" (mantido: só relata, o stakeholder encaminha, o `/review` decide); `/review` nunca grava consumo (inalterado); ação única da retro (mantida, o relatório não a substitui). Efeito colateral: projeto com `consumption.md` de versão anterior tem linhas sem a coluna Modelo — `/team update` mostra o delta de estrutura e pede aprovação; linhas antigas ficam sem o valor.

### Como saberemos que funcionou

No primeiro sprint fechado após a atualização do projeto para `v3.33.0`: (1) toda linha de `consumption.md` traz modelo ou "não disponível — motivo"; (2) `retrospective.md` tem a tabela de ineficiência preenchida (ou "nenhuma", cada uma sustentada por linha do registro); (3) `plugin-report.md` existe na pasta fechada e uma leitura por `Select-String` dos nomes de projeto/cliente devolve zero. Sinal de falha: relatório com ID real de Task ou nome de domínio.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | `Select-String -Pattern "Sintomas para o .note.md. do plugin"` em toda a RAIZ, exceto changelogs | 1 ocorrência, o título da seção 4 do **novo** `plugin-report.md` (intencional: é o mesmo formato de sintoma). Era 1 no `retrospective.md` e 1 no `README.md` do SM — ambos reescritos, cada trecho novo lido ao lado do ponteiro para `plugin-report.md` | ✅ |
| Substituição de padrão | `Select-String -Pattern "plugin-report" -Path` em todos os arquivos que listam a pasta `sprints/<n>/` (workflow, artifact-ownership, README do SM, project-context, how-to, team-init, README raiz, deliverables/team-project) | ocorrência em cada um; a lista de `workflow.md` (2 pontos) e a árvore de `artifact-ownership.md` conferem entre si | ✅ |
| Extração/adição | `Select-String -Path templates/plugin-report.md -Pattern "^## "` e `Test-Path` | 5 seções numeradas + Regras; arquivo existe | ✅ |
| Arquivamento | `Compare-Object` do bloco `## v3.30` (texto salvo antes de mover) contra o mesmo trecho no arquivo | 0 diferenças; índice de arquivadas com a linha `v3.30` | ✅ |
| Coerência de índice | `## v3.` em `process-changelog.md` | 3 entradas (v3.33, v3.32, v3.31) | ✅ |
| Teto de entrada (R17) | bloco `## v3.33`, `[IO.File]::ReadAllText` UTF-8 explícito; um papel → barreira 10 KB | ver "Teto" abaixo | ✅ |
| Substituição de padrão (aplicação 29/09/2026) | `grep "modelo (o \`model:\`" commands/` · `grep plugin-report commands/sm.md` | 7 ocorrências (`sm`, `po`, `arc`, `ux`, `qa`, `dev`, `team`), cada uma apontando o cartão existente em `agents/`; 1 em `sprint close` | ✅ |

### Aplicado a pedido do stakeholder (29/09/2026)

As propostas de `commands/` foram aprovadas e aplicadas: as sete instruções de gravação de consumo passam a gravar o **modelo** (o `model:` do cartão em `agents/`, ou o override; sem leitura, "não disponível — motivo"), e `/sm sprint close` passa a gerar `plugin-report.md`. Bump R18: `plugin.json` `3.33.0`, banner do `README.md` e entrada `v3.33.0` no `CHANGELOG.md`. Mudança em `commands/` só vale após reiniciar a sessão.

**Teto (R17):** bloco `## v3.33`, `[IO.File]::ReadAllText` UTF-8, medido em 29/09/2026 — **9.137 B**, sob a barreira de 10 KB (1 papel).

---
## v3.32 — R30: QA mapeia cenário de teste funcional/regressivo na Planning e o executa no veredito; GAP não-bloqueante ganha caminho explícito ao Product Backlog (SM) — 23/09/2026

**Instrução** (`note.md`, triagem `/review note`, três itens fechados numa decisão do stakeholder via `AskUserQuestion`): **(1)** QA lê Histórias aprovadas + protótipo funcional e monta cenários de teste funcionais do sprint, também regressivos pelo impacto da Task; **(2)** isso ocorre a cada sprint — mapeado na Planning por Task, executado na entrega do dev, mesmo conceito de "Histórias aprovadas para o sprint" aplicado aos cenários; **(3)** erros/gaps de cenário entram no Backlog para o próximo sprint. Decisão do stakeholder sobre o conflito de R25 §5e: **GAP que bloqueia História em voo continua virando Task no sprint corrente** (R25 intacto); só o que **não bloqueia** vai ao Product Backlog — e o stakeholder pediu para fechar a lacuna preexistente de **quem** escreve essa linha. Decisão sobre onde a suíte vive: **avaliar aderência** de "ficar na área da QA e ser referenciada como Task no Sprint Backlog" contra `artifact-ownership.md` §1/§1c/§1e — aderente, aplicado como tal.

**Classificação:** etapa de fluxo + propriedade de artefato nova (regra de trabalho, R30) + formato de documento (roteiro/skills/templates do QA e do PO, aplicando a própria contraparte da regra). **Rodada de três papéis aplicando na própria mão** (SM em `working-rules.md`/`workflow.md`/`artifact-ownership.md`; QA em `roles/quality-assurance/`; PO em `roles/product-owner/`) — as três aplicações datam do mesmo `/review` de 23/09/2026 e compõem uma entrada só (R17, precedente v3.25/v3.31: a unidade é a decisão, não o papel). Barreira aplicável: **12,5 KB** (10 KB + 2,5 KB pelo terceiro papel).

### O que mudou

| Documento | Seção | Mudança |
|---|---|---|
| `working-rules.md` | Bloco C, após R27 | **R30 nova**: QA mapeia cenários (novos + regressivos) por Task na Planning, a partir do critério de aceite do PO e do protótipo funcional; opera o critério, não o reescreve (dúvida escala ao PO por R9/§6b, sem redeclarar); execução pesada segue R28; GAP de cenário bloqueante vira Task no sprint corrente (R25 intacto), não-bloqueante ganha par no Product Backlog escrito pelo PO — mecânica que fecha a lacuna geral de todo GAP não-bloqueante de `pending.md`, não só o de cenário |
| `workflow.md` | §1 (Task); §2a etapas 3/7; §3b DoR; §4a-i DoD; §5e passo 4 e "Durante o sprint"; §8 gates | Task ganha campo "cenários mapeados (IDs)"; etapa 7 e o veredito cobrem o resultado; DoR/DoD exigem cenário mapeado/executado; "Durante o sprint" ganha `pending.md` (QA) → PO → Product Backlog; +2 linhas de gate |
| `artifact-ownership.md` | matriz §1; §1c; §1e; §4 | Nova linha **Suíte de cenários** (`.team-project/quality-assurance/scenarios/`, dono QA, fora da pasta, acumulada); Tasks/Product Backlog/GAPs atualizadas; §1c/§1e (quatro artefatos fora da pasta) e §4 (`SC-nnn`) incluem a suíte |

### Por quê

Sem cenário mapeado antes da construção, a verificação funcional era reinventada a cada Task, sem memória do que já tinha sido coberto — uma Task quebrava um fluxo que já funcionava e isso só aparecia na Review ou em produção. E, sem o passo mecânico `pending.md` → PO → Product Backlog, um GAP confirmado pela QA fora da Sprint Review ficava preso no registro da QA sem nunca concorrer no próximo sprint, apesar de `workflow.md` §5e já dizer que deveria — lacuna preexistente, exposta por este item, não criada por ele.

**Avaliação de aderência do local da suíte** (pedido do stakeholder): **aderente** manter a suíte na área da QA, fora de `sprints/<n>/`, com o Sprint Backlog carregando só a referência (lista de IDs) por Task — critério e racional completos ficam em `artifact-ownership.md` §1c/§1e (norma que governa o assunto), esta entrada só referencia. Nenhuma parte do pedido foi considerada não aderente.

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda para ele |
|---|---|
| **QA** | Mapeia cenários (novos + regressivos) por Task na Planning, além de já contribuir na quebra (§5e passo 4); executa e registra o resultado no veredito; aponta GAP não-bloqueante para o PO com o ID de `pending.md`. Contraparte de roteiro/skills/templates aplicada nesta mesma entrada — ver "Aplicação do QA", abaixo |
| **PO** | Ganha a obrigação explícita de abrir a linha do Product Backlog para todo GAP não-bloqueante que a QA registrar em `pending.md`, citando o ID, no mesmo ciclo da confirmação (R12) — antes implícito em `workflow.md` §5e, agora mecânico. Contraparte de roteiro/skills/templates aplicada nesta mesma entrada — ver "Aplicação do PO", abaixo |
| **SM** | Verifica o campo de cenários no Sprint Backlog (DoR/DoD), a dupla cobertura do veredito e o par GAP↔Product Backlog nas duas pontas |

### Conflitos com o processo vigente

Um só, já resolvido pelo stakeholder (registrado em B(i) da triagem): item 5 do `note.md`, lido ao pé da letra, mandaria **todo** erro/GAP de cenário para o próximo sprint — contradizendo a exceção de R25 §5e ("GAP que bloqueia uma História já no sprint vira Task da mesma História", imediato, não represado). **Resolução:** a exceção de R25 fica intacta; R30 só formaliza o caminho do que **não** bloqueia. Registrado como parte da própria regra nova (R30, working-rules.md), não como pendência aberta.

### Como saberemos que funcionou

No próximo sprint que rodar `/sm sprint plan`, toda Task do Sprint Backlog cita cenários mapeados (ou "nenhum aplicável" com motivo) antes de entrar em construção, e nenhum veredito de `/qa <Task>` fecha sem o resultado deles. Em `pending.md`, todo GAP não-bloqueante registrado a partir desta versão tem par datado no Product Backlog dentro do mesmo sprint em que foi confirmado — GAP sem par depois de uma Planning inteira é o sinal de que a mecânica não pegou.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Extração/adição de regra nova | `Select-String -Path working-rules.md -Pattern "^### R30"` | 1 ocorrência, "### R30. Cenário de teste funcional e regressivo é mapeado na Planning e executado no veredito do QA" | ✅ |
| Substituição de padrão | `Select-String -Path artifact-ownership.md -Pattern "Três artefatos ficam fora"` | 0 ocorrências (era 1) — substituído por "Quatro artefatos ficam fora..." com a suíte de cenários incluída e lida no contexto | ✅ |
| Substituição de padrão | `Select-String -Path workflow.md,working-rules.md,artifact-ownership.md -Pattern "R30"` | `workflow.md`: 9 · `working-rules.md`: 1 · `artifact-ownership.md`: 6 — total 16, cada ocorrência lida no contexto de inserção | ✅ |
| Extração/remoção | Contagem de linhas do bloco "Como o SM verifica" (§5e) e da tabela de gates (§8) antes/depois | "Como o SM verifica": 9 → 10 linhas (+1, a de R30); gates: 20 → 22 linhas (+2, construção e veredito) | ✅ |
| Substituição de padrão (aplicação 25/09/2026) | `grep mcp__claude-in-chrome agents/{operator,quality-assurance}.md` · `grep "scenarios (create\|run)" commands/qa.md` · `git diff --stat -- agents/ commands/` | ferramenta nos 2 cards; hint + 2 modos em `commands/qa.md`; `git diff --stat`: 3 arquivos, 8 inserções / 3 remoções — cada trecho lido, coerente com o roteiro do QA (R30) | ✅ |

*(Tamanho da entrada consolidada e pendente do stakeholder: no fecho, depois das aplicações do QA e do PO — uma lista e uma medição só.)*

### Aplicação do QA (`/review`, 23/09/2026) — `roles/quality-assurance/`

| Documento | Mudança |
|---|---|
| `README.md` | Suíte nas Entradas/Saídas/Escreve; seção de mapeamento/execução; "Planning Meeting" no roteiro; `/qa <ID>` passo 4/6 |
| `skills.md` | Skill 13 nova — critério de aceite → cenário, sem reescrevê-lo |
| `templates/verdict.md` | Seção de cenários, roteamento por bloqueio |
| `templates/evidence.md` | Mesma tabela de cenários do veredito |
| `templates/cross-audit.md` | Passe 1 ganha checagem de cenário |
| `templates/scenario.md` (novo) | Modelo `SC-nnn` |
| `templates/scenarios-index.md` (novo) | Modelo do índice |

**Evidência (R19):** `R30` em 7 arquivos do QA, 15 ocorrências (README:3 · skills:3 · verdict:3 · evidence:1 · cross-audit:1 · scenario:2 · scenarios-index:2) — conferido por `grep`, cada ocorrência lida no contexto. `git diff --stat -- roles/quality-assurance/`: 5 arquivos, 82 inserções / 7 remoções, + 2 arquivos novos — conferido.

**Dois achados devolvidos ao SM** (fora do alcance do QA) — tratados em "Curadoria do SM", abaixo.

### Aplicação do PO (`/review`, 23/09/2026) — `roles/product-owner/`

| Documento | Mudança |
|---|---|
| `README.md` | Seção nova — GAP não-bloqueante da QA vira linha no Product Backlog; `/po bug` passo 5 unificado ao mesmo caminho |
| `skills.md` | Skill 3/8 apontam a mesma fonte, sem duplicar |
| `templates/product-backlog.md` | Seção "GAPs não-bloqueantes (origem `pending.md`, QA)" |
| `templates/user-story.md` | Nota: Critérios de aceite é a fonte que a QA opera, sem reescrevê-la |

**Por quê:** `/po bug` (passo 5) e a skill 8 descreviam o mesmo destino em prosa divergente — unificados nesta entrada.

**Evidência (R19):** `R30` em 4 arquivos do PO, 11 ocorrências (README:5 · skills:2 · product-backlog:3 · user-story:1) — conferido por `grep`, cada ocorrência lida no contexto. `git diff --stat -- roles/product-owner/`: 4 arquivos, 22 inserções / 4 remoções — conferido.

### Curadoria do SM — dois achados do QA aplicados, e referência cruzada da rodada

O QA devolveu dois achados fora do alcance dele — nenhum é comportamento, os dois são coerência de referência cruzada já coberta pela exceção de `review-contract.md` §Limites, aplicados direto:

- **`sprint-backlog.md`** (SM): ganha a coluna **Cenários** (ponteiro, nunca cópia) — faltava para a referência que R30 já exige (DoR/DoD).
- **`deliverables/README.md`** (SM): linha nova para a Suíte de Cenários em "Conjuntos".
- **`deliverables/team-project/README.md`** (achado da própria curadoria): manifesto e "O que fica FORA da pasta" passam a citar `scenarios/`, já nomeada em `artifact-ownership.md` §1e.

**Contradição entre os dois papéis (QA × PO):** nenhuma — caminho da suíte, par modelo×arquivo e "quem escreve o quê" conferidos lado a lado, mesma fronteira, sem sobreposição nem lacuna.

**Evidência (R19):** as três edições acima (`sprint-backlog.md`, `deliverables/README.md`, `deliverables/team-project/README.md`) lidas depois de aplicadas — coluna nova resolve no exemplo; linha nova resolve nos dois links; a frase "O que fica FORA" cita os quatro artefatos, mesma contagem de `artifact-ownership.md` §1e.

### Pendente do stakeholder (consolidado — SM + QA + PO, uma lista só)

**Aprovado e aplicado pelo stakeholder em 25/09/2026** (sessão principal, em nome dele), com o texto abaixo — os dois itens saem de `note.md` (Abertas), que volta a ficar vazia:

| Arquivo | Mudança |
|---|---|
| `agents/operator.md` | `tools:` ganha `mcp__claude-in-chrome`; item **8** do contrato — cenário de navegador em lote (R30) roda por Claude in Chrome, uma linha por cenário no relatório; sem extensão, `inconclusivo — sem ferramenta` |
| `agents/quality-assurance.md` | `tools:` ganha `mcp__claude-in-chrome`; parágrafo novo — cenário isolado roda no próprio QA, grupo/suíte inteira vai ao `operator` (R28); sem extensão conectada na sessão, ⚠️ **não executado — sem ferramenta** |
| `commands/qa.md` | `argument-hint` e corpo ganham `scenarios create` (povoa a suíte a partir do SDD + protótipo) e `scenarios run <SC-nnn\|grupo\|all>` (isolado no QA; grupo/`all` no `operator`), roteando GAP por R30 |
| `roles/quality-assurance/{README.md,templates/scenario.md,templates/scenarios-index.md}` (QA) | "sem ferramenta no card" → "extensão não conectada na sessão"; Roteiro por modo aponta os dois modos novos. Evidência: `Select-String "ferramenta.{0,40}(não existe\|não tem\|não carrego\|fora do meu alcance)"` → 0 (era 4) |

**Condição inalterada, causa diferente:** o card tem a ferramenta; sem a extensão conectada, o resultado segue ⚠️ não executado — sem ferramenta.

**Teto (R17):** bloco `## v3.32`, `[IO.File]::ReadAllText` UTF-8, medido em 25/09/2026 — **12.718 B**, sob 12,5 KB (3 papéis).

---

## v3.31 — QA passa a cobrir aderência de execução, não só o standard; `/arc comply` sai do ciclo; `cycle sprint` deixa de ser "proposta" (SM) — 23/09/2026

**Instrução** (stakeholder, `/review`, três decisões): **(1)** `workflow.md`:53 dizia que `cycle sprint` "é proposta ao stakeholder, não aplicada", mas `commands/team.md`:60–84 já o implementa — corrigir sem duplicar o comando. **(2)** "o QA é quem executa essa tarefa usando o plano definido pelo Arquiteto, e isso é importante para evitar o consumo pelo Arquiteto, que custa muito mais" — a verificação de aderência de execução ao plano passa à frente 2 do QA, ao lado da completude/correção do standard que ela já cobria; `/arc comply` sai do ciclo e da rota de volta, só sobrevive como exceção pedida pelo stakeholder. **(3)** "Adicionar como uma tarefa do sprint a ser executada pelo QA ao fim de cada tarefa executada pelo DEV" — Task não fecha sem essa dupla checagem.

**Classificação:** obsolescência de fluxo (item 1) + fluxo, com reatribuição de responsabilidade entre papéis (item 2) + reforço de gate existente, sem regra nova (item 3). **Rodada de três papéis aplicando na própria mão** (SM em `workflow.md`/`artifact-ownership.md`; Arquiteto em `roles/architect/`, `standards/` e `roles/developer/` — R16/v1.3; QA em `roles/quality-assurance/`) — as três aplicações datam do mesmo `/review` de 23/09/2026 e compõem uma entrada só (R17, precedente v3.25: a unidade é a decisão, não o papel). Barreira aplicável: **12,5 KB** (10 KB + 2,5 KB pelo terceiro papel).

### O que mudou

| Documento | Seção | Mudança |
|---|---|---|
| `workflow.md` | §2a, fecho da cadeia (linha do `cycle`) | "Escopo de sprint do `cycle`… é **proposta ao stakeholder**, não aplicada" → `cycle sprint` está **implementado** em `commands/team.md`, sem duplicar o conteúdo do comando |
| `workflow.md` | §2a, etapa 7 (Validação) | Saída passa a citar, sempre, a checagem de aderência de execução **e** de standard, na mesma invocação |
| `workflow.md` | **§4a reescrita** — título e corpo | De "`/arc comply` × frente 2, objetos diferentes" para "Aderência de execução e de standard — as duas, na frente 2 do QA": dois objetos no mesmo veredito, motivo de custo, rota de volta por tipo de defeito (execução → dev direto; defeito do plano → GAP ao Arquiteto **e** achado de processo, rota dupla), `/arc comply` fora do ciclo, verificação do SM com as **duas tabelas** obrigatórias |
| `workflow.md` | §4a-i (DoD da Task) | Bullet novo: frente 2 cobre os dois objetos; Task não fecha sem os dois |
| `workflow.md` | §8 (gates) | Linha do gate de standard vira "aderência de execução **e** standard, as duas, na mesma frente 2"; frase de abertura do §8 ganha "aderência de execução" ao lado de "standard" |
| `artifact-ownership.md` | §3, "Conflitos comuns" | Linha do `/arc comply` reescrita: a tabela passo × conforme não é redundante — é o objeto 1, obrigatório, desde que o `/arc comply` saiu do ciclo |

### Por quê

`/arc comply` cobria a aderência de execução por **autoconferência do próprio autor do plano**, sob demanda, nunca garantida em toda Task. Motivo do stakeholder: **custo** — o Arquiteto é o papel mais caro do time (§5c), e reexecutar Task a Task uma comparação mecânica contra um documento já escrito não exige o julgamento de desenho que só ele tem. O QA já fazia o objeto 2 (completude do standard) de forma independente desde a v2.4; a mesma independência passa a cobrir o objeto 1, sem papel novo — mesma leitura do plano e do código, uma pergunta a mais na mesma frente. Item 1 fecha obsolescência simples: `workflow.md` descrevia `cycle sprint` como não implementado quando `commands/team.md` já o executa.

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda |
|---|---|
| **QA** | Frente 2 de `/qa <Task>` traz **duas tabelas sempre** — passo × conforme e seção exigida × citada — em vez de só a segunda; roda **ao fim de toda Task**, não sob demanda |
| **Arquiteto** | Deixa de rodar `/arc comply` no ciclo ou como rota de volta padrão; só a pedido nomeado do stakeholder |
| **Dev** | Achado de aderência de execução volta **direto** por `/dev resume`, sem Arquiteto |
| **SM** | Verifica as duas tabelas da frente 2; trata `cycle sprint` como implementado |

### Conflitos

- R16 (dono editorial do Arquiteto sobre `standards/`) — sem conflito: muda quem confere a execução do plano, não o dono do standard.
- Independência da frente 2 desde a v2.4 ("autor não audita a própria omissão") — sem conflito, reforça: o QA, não-autor do plano, herda o objeto 1.

### Como saberemos que funcionou

Próximo veredito de frente 2 traz as duas tabelas, sempre; próximo achado de aderência de execução é resolvido por `/dev resume` sem uma chamada de `/arc comply` no meio; nenhum relatório de `/team cycle sprint` trata o modo como "ainda não implementado".

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | `proposta ao stakeholder.{0,20}não aplicada` em `workflow.md` | 0 — única ocorrência reescrita para "implementado", coerente com `commands/team.md`:60-84 | ✅ |
| Substituição de padrão | `comply` em `workflow.md` e `artifact-ownership.md` | 2, ambas novas e coerentes: nenhuma sobra dizendo que ele ainda roda no ciclo | ✅ |
| Coerência (leitura) | §2a etapa 7, §4a-i, §8, §4a lidos lado a lado | os quatro concordam: frente 2 cobre os dois objetos, sempre, Task não fecha sem eles | ✅ |
| Contagem | `^### R\d+\.` em `working-rules.md` | 29·29, sem mudança — nenhuma regra nova | ✅ |
| Arquivamento (teto 3) | bloco `v3.28` relocado, `Compare-Object` UTF-8 | 0 diferenças; índice com a linha nova | ✅ |
| Teto de entrada (R17), consolidado | bloco `## v3.31` inteiro (SM + Arquiteto + QA), `[IO.File]::ReadAllText` UTF-8; rodada de **3 papéis** → barreira 12,5 KB | **≈12,3 KB**, sob a barreira, medido depois de consolidar as 3 aplicações numa entrada só (nota: esta própria linha altera o total em poucas dezenas de bytes; valor final confirmado no relatório do `/review`) | ✅ |

*(Pendente do stakeholder desta entrada: consolidado ao final, depois das aplicações do Arquiteto e do QA — uma lista só, sem repetir `arquivo:linha`.)*

### Aplicação do Arquiteto (`/review`, 23/09/2026) — `roles/architect/` · `standards/` · `roles/developer/`

| Documento | Mudança |
|---|---|
| `roles/architect/README.md` | "Responde por" sem "aderência arquitetural"; `/arc question` item 3 e §Bloqueio apontam §4a; seção `/arc comply` vira "Aderência do código ao plano — não é minha" (exceção a pedido do stakeholder); bullet novo em "Como sei": plano conferível sem julgamento de desenho |
| `roles/architect/skills.md` | §2: linha "Conferência" no raso × bom; §12: "auditoria de aderência pedida pelo stakeholder"; §13: linha `/arc comply` removida |
| `templates/implementation-plan.md` | Campo **Conferência** por passo (+ exemplo) e regra 13 — dele sai a tabela passo × conforme do QA |
| `templates/compliance-review.md` | Mantido, **só exceção**: rotas (a)/(b) e modo leve da rota de volta saem; cabeçalho exige o pedido do stakeholder |
| `standards/implementation-principles.md` §7 | Linhas 5 e 13: verificação passa à frente 2 do QA, consequência "Task volta ao dev" |
| `roles/developer/` | README passo 7 (achado de execução volta direto por `/dev resume`); `skills.md` §6 e `delivery-report.md` sem citar o Arquiteto como revisor |

**Evidência (R19):** `comply` em `roles/architect/`, `standards/`, `roles/developer/` → 3, todas a exceção; zero em `standards/` e `roles/developer/`.

### Aplicação do QA (`/review`, 23/09/2026) — `roles/quality-assurance/`

| Documento | Mudança |
|---|---|
| `README.md` | Frente 2 reescrita: **objeto 1** (execução — critério é o campo **Conferência** do plano, R13) ao lado do **objeto 2** (standard); degrau 1 da escada sem `/arc comply` |
| `skills.md` §2 | Tabela "passo × conforme" usa a **Conferência** como critério; leitura eficiente (plano + diff, uma vez cada); comparação pesada delegável ao `operator` (R28); passo inconferível vira 🔺 GAP |
| `skills.md` §10 | Rota da omissão/citação errada de standard corrigida para a **dupla** (🔺 GAP → `/arc question` **e** achado de processo → `/review`) |
| `templates/verdict.md` | Sub-tabela **"passo × conforme"** (objeto 1) ao lado de **"seção exigida × citada"** (objeto 2); regra nova: frente 2 sem as duas tabelas é achado de processo |

**Achado corrigido pelo QA:** `README.md`/`skills.md` roteavam omissão/citação errada **só** para `/review`, sem GAP. Corrigido para a rota dupla.

**Evidência (R19):** `comply` em `roles/quality-assurance/` → 2, ambas explicativas, zero como mecanismo vigente. Tabelas e rotas dos 4 documentos concordam entre si.

### Curadoria do SM — §4a não reunia a rota dupla num lugar só

Achado: "Rota de volta" nomeava **um** destino para "Defeito do plano" (Arquiteto, GAP); o resumo de estados do objeto 2 nomeava os mesmos dois estados só como "achado de processo" — nenhuma das duas, sozinha, registrava os **dois** destinos que o QA já implementava. **Corrigido no normativo:** as duas linhas de `workflow.md` §4a agora nomeiam os dois destinos juntos; o texto do QA já estava certo e não mudou.

**Evidência (R19):** as duas linhas de `workflow.md` §4a citam GAP **e** achado de processo juntos; nenhuma tabela resta com destino único.

### Pendente do stakeholder (consolidado — SM + Arquiteto + QA, uma lista só)

**Aplicado pelo stakeholder em 23/09/2026** (autorizou na mesma sessão), com o texto abaixo — inclusive o bump para `3.31.0` e a entrada no `CHANGELOG.md`. A verificação final achou mais uma sobra, fora da lista e também aplicada: `agents/architect.md` (item 4 de Responsabilidades e `description`) ainda mandava o Arquiteto revisar aderência "sob demanda, por sua iniciativa"; e a `description` de `agents/quality-assurance.md` passou a nomear a aderência ao Plano de Implementação:

| Arquivo:linha | Hoje (resumo) | Proposta (texto pronto) |
|---|---|---|
| `commands/team.md`:82 | comply "sob demanda" antes do `/dev resume` | "devolva os achados conforme a rota do próprio veredito — aderência de execução vai **direto** a `/dev resume <ID>`; defeito do plano vai a `/arc question` **e** entra como achado de processo na fila do `/review`; defeito do standard só à fila do `/review`. `/arc comply` **não** roda neste ciclo: só como exceção pedida nomeadamente pelo stakeholder (`workflow.md` §4a)" |
| `commands/qa.md`:30 | mesma rota antiga | "achado de aderência de execução (objeto 1) → `/dev resume <ID>`, direto; achado de defeito do plano (objeto 2) → `/arc question` **e** achado de processo à fila do `/review`; defeito do standard → só fila do `/review`. `/arc comply` não entra nesta escada — só roda como exceção pedida nomeadamente pelo stakeholder" |
| `commands/arc.md`:16 | comply "sob demanda", rota de volta de achado ⚠️/❌ | "**Só roda como exceção explícita, pedida nomeadamente pelo stakeholder** — não é etapa do ciclo nem rota de volta de achado de aderência (isso é da frente 2 do `/qa`, `workflow.md` §4a)" |
| `agents/scrum-master.md`:41 | "a frente 2 existe apesar do `/arc comply`" | "a frente 2 do QA cobre sozinha a aderência de execução e a de standard, sem o Arquiteto" |
| `README.md`:115 | sem marcar a restrição | acrescentar, no parêntese: "(aderência do código ao plano, **só como exceção pedida pelo stakeholder** — a frente 2 do `/qa` cobre isso em toda Task)" |
| `README.md`:105 · `how-to.md`:66 | listam `comply` como modo | **sem correção** — o modo continua existindo, só como exceção; nome de modo é cross-reference já coberta pela curadoria do SM |
| `.claude-plugin/plugin.json` · banner do `README.md` · topo do `CHANGELOG.md` | `3.30.0` | bump para `3.31.0` (par com este `vX.Y`, R18); `CHANGELOG.md`: "## v3.31.0 — QA cobre aderência de execução e de standard na mesma frente 2; `/arc comply` vira exceção pedida pelo stakeholder. Branch: `feat/v3.31.0` a partir de `develop`. Verificar: `/qa <Task>` produz as duas tabelas sempre; ver `process-changelog.md` v3.31." |

**Resolvido nesta rodada, fora da lista acima** (dentro do alcance do SM, sem esperar o stakeholder): `roles/scrum-master/templates/project-context.md`:113 ganhou o mesmo qualificador *(exceção pedida pelo stakeholder)* ao lado de `comply <T-ID>`. `CHANGELOG.md`:72 é entrada histórica de uma versão anterior — R17 não reescreve entrada antiga, e o texto ali já se referia ao comportamento da época; não é sobra desta rodada.

---
