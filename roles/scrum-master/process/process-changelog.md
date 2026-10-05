# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
| [`v3.40`](process-changelog-archive.md) | R33: trilha `fix` para defeito e ajuste pequeno — critério verificável na entrada, plano e execução em bloco, consumo próprio, piso de evidência por Correção e conferência C4 (SM + PO + Arquiteto + QA + UX) — 03/10/2026 |
| [`v3.39`](process-changelog-archive.md) | Guardas e conferências mecânicas: hooks de plugin (G1 · G2 · G3 · G4 · G13) e três scripts (C1 · C2 · C3) tiram do julgamento o que é mecânico (SM + QA) — 02/10/2026 |
| [`v3.38`](process-changelog-archive.md) | Medir custo e resultado: Categoria e Unidade no registro de consumo, bloco "Custo × resultado" na retrospectiva, modelo de benchmark A/B/C e "História de origem" no defeito (SM + PO + QA) — 02/10/2026 |
| [`v3.37`](process-changelog-archive.md) | R32: consultoria externa especializada pelo `/sm consulting` — técnica e de negócio, carta sanitizada, até 3 réplicas, validação do time antes do formulário (SM + PO + Arquiteto + QA + UX) — 02/10/2026 |
| [`v3.36`](process-changelog-archive.md) | R27 confere a energia e retoma o mesmo agente; Task pesada em segundo plano; ocorrência de plugin só se registra no `run` e se pergunta na Review; `replicate-in-new-project.md` fundido no `how-to.md` (SM) — 01/10/2026 |
| [`v3.35`](process-changelog-archive.md) | `.team-project/` sai do git (R31); R28 enxuta: relatório do job com teto, `report-<log>.md` por chamada, dev isento, log podado não é achado; consumo fora de sprint em `.team-project/consumption.md` (SM) — 30/09/2026 |
| [`v3.34 (parte 3)`](process-changelog-archive.md) | Novo modo `/sm sdd`: do brief ao SDD aprovado e às Histórias, com os portões ① e ② disparados pelo próprio modo (SM + PO + UX + Arquiteto) — 30/09/2026 |
| [`v3.34 (parte 2)`](process-changelog-archive.md) | Split do `workflow.md`, índice das regras, roteiro do `run` como fonte única e correções da auditoria (SM) — 29/09/2026 |
| [`v3.34`](process-changelog-archive.md) | Cadência do sprint em cinco modos do `/sm` (prepare · plan · run · review · close); `/team cycle\|plan\|build\|qa` removidos; decisão de portão em formulário (R22) (SM + PO + Arquiteto + QA + UX) — 29/09/2026 |
| [`v3.33.1`](process-changelog-archive.md) | O papel chamador retrata o consumo do `operator`; o registro o soma em linhas por chamador (SM) — 29/09/2026 |
| [`v3.33`](process-changelog-archive.md) | Retrospectiva analisa consumo por papel e por modelo, procura ineficiência e gera o relatório ao dono do plugin (SM) — 29/09/2026 |
| [`v3.32`](process-changelog-archive.md) | R30: QA mapeia cenário de teste funcional/regressivo na Planning e o executa no veredito; GAP não-bloqueante ganha caminho ao Product Backlog (SM) — 23/09/2026 |
| [`v3.31`](process-changelog-archive.md) | QA cobre aderência de execução e de standard na mesma frente 2; `/arc comply` sai do ciclo; `cycle sprint` deixa de ser "proposta" (SM) — 23/09/2026 |
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

## v3.43 — `sprint run` sem paradas fora do contrato: lista fechada de paradas, rota do gate protegido, negação ao dev vira 🔺 GAP, interrupção pelo stakeholder e marcador acompanhando a Task (SM + Arquiteto) — 05/10/2026

**Instrução** (stakeholder): "aplique o proposta-run-interrupcoes.md para termos um teste mais correto" — pré-requisito do benchmark de projeto (simulação sem intervenção). Origem: 4 interrupções e 1 queixa de burndown em `note.md` (sprint 1 de um projeto-piloto). Decisões do formulário de 05/10/2026: **P2 — sessão principal aplica o arquivo protegido** (com o pedido de permissão do harness) · **P5 — sem modo novo:** "já existe uma marcação, ela só precisa refletir onde a tarefa está" (a sessão marca no momento da transição; `board --marca` descartado) · versão única v3.43.0.
**Classificação:** fluxo (`sprint-run.md`, `fix-run.md`) · formato de documento (plano: `**Arquivos protegidos:**`, §12, teste de cada arquivo de produção na lista) · propriedade de artefato (a sessão escreve marcador e transição no `run`) · comportamento de agente (card do dev, `commands/sm.md`, mensagens da G5/G9 — aplicados pela sessão). **Sem regra nova** (34): reforça R22, R24, R25, R27 e R7.
**Papéis movidos (R17):** 2 — SM e Arquiteto → barreira de 10 240 B.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `sprint-run.md` | Quem executa · Ordem da fila · passos 1, 3–6, 8 · §Marcador (nova) · Como o SM verifica | **P1** paradas legítimas em lista fechada (fim da fila, bloqueio de R22 sem Task elegível, pré-condição, interrupção); fim de Task não é parada; "sigo?", fronteira de História e resumo no meio da fila proibidos; Task 🔴 não para o `run`. **P2** passo 3: a sessão aplica o diff de `**Arquivos protegidos:**` antes do dev; recusado → 🔴 e a fila segue. **P3** passo 4: deny de G9/G6/G5 ao dev é sempre 🔺 GAP, nunca pergunta ao stakeholder. **P4** interrupção pelo stakeholder: não reexecuta, disco consistente, uma linha, espera. **P5** a sessão marca ⬜→🟦→🟨→🟪 (e 🟪→🟨, →🔴) na hora: marcador, Registro de transições e linha de composição no burndown; o `run` deixa de acionar `board` |
| `fix-run.md` | §Run | Mesmas paradas, deny ao dev = GAP, timeout = não exercitado |
| `working-rules.md` | R24 | A sessão do `run` também grava transição; intermediários exatos no `run`; Task fechada sem → 🟦/🟨/🟪 é achado |
| `artifact-ownership.md` | §1 Sprint Backlog · Burndown | Escritor adicional no `run`: a sessão (marcador e linhas), como no `.active-task` |
| `templates/burndown.md` · `sprint-backlog.md` | cabeçalho · granularidade · custo · Registro de transições | Linha por transição do `run`, com data e hora |
| `roles/architect/templates/implementation-plan.md` | cabeçalho · §12 (nova) · regras 15 e 16 · exemplo | `**Arquivos protegidos:** nenhum \| ver §12`, separado por linha em branco (a G9 não o lê); §12 com o diff exato; teste de cada arquivo de produção na lista, ou `sem teste: <arquivo> — <motivo>` na §6 |
| `roles/scrum-master/README.md` | `sprint run` | SM só no `close` |
| Sessão (stakeholder) | `agents/developer.md` (timeout ≠ limpo; gate protegido é da §12) · `commands/sm.md` (tabela de modos; R27 com ação do stakeholder) · `hooks/pre-tool.ps1` (mensagens G5 e G9 dão a rota) · `hooks/COVERAGE.md` · `run-guard-tests.ps1` (`ExpectErr` + 3 casos) · `plugin.json` · `README.md` · `CHANGELOG.md` | Aplicados pela sessão |

### Por quê
No sprint 1 do piloto o `run` parou quatro vezes sem motivo de contrato: ofereceu parar depois de uma Task fechada, travou num `ci.yml` que nenhum subagente pode editar (sem rota), repassou ao stakeholder a negação da G9 de um `*.spec.ts` esquecido no plano, e não retomou depois de uma interrupção manual. O burndown só via abertura e fechamentos porque o `board` rodava no fim da Task. O benchmark de projeto exige `sprint run` e `fix run` sem intervenção — cada parada fora do contrato seria medida como custo do plugin, não como defeito.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Sessão que orquestra | não para entre Tasks; aplica o diff protegido no passo 3; transforma deny ao dev em GAP; marca cada transição; responde em uma linha à interrupção |
| Arquiteto | lista o teste de cada arquivo de produção; arquivo de gate vai à §12 com diff exato |
| dev | timeout não é resultado; arquivo de gate é da §12 |
| SM | entra só no `close`; verifica paradas, linhas de transição e `.active-task` × 🟨 |

### Verificação (R19)
| Item | Comando | Resultado | |
|---|---|---|---|
| Guardas | `powershell -NoProfile -File scripts/checks/tests/run-guard-tests.ps1` | 54 casos · 0 falharam (G5 cita `sprint-run.md passo 3`; §12 fora do escopo da G9; teste listado liberado) | ✅ |
| Conferências | `powershell -NoProfile -File scripts/checks/tests/run-check-tests.ps1` | 20 casos · 0 falharam (C1 R24 lê a data de `aaaa-mm-dd hh:mm`) | ✅ |
| Release (R17 · R18) | `powershell -NoProfile -File scripts/checks/release.ps1` | R18 ok: plugin.json = CHANGELOG = README L3 = v3.43.0, processo 3.43/3.42/3.41 com entrega · R17 ok: bloco v3.43 ≤ 10240 (2 papéis), 3 entradas vivas (v3.40 arquivada) · ps1-5.1 ok · ownership ok: 50 regras · órfãos ok: 45 modelos · exit 0 | ✅ |

**Não exercitado:** um `sprint run` real com a v3.43 (exige plugin atualizado e sessão reiniciada). **Não mecanizado:** a conferência "teste de cada arquivo de produção na lista" do plano — fica na verificação do SM e na frente 2 do QA até existir conferência de plano por script.

### Pendente do stakeholder
Atualizar o plugin e **reiniciar a sessão**. Remover `proposta-run-interrupcoes.md` depois do aceite desta entrada. Os cinco itens de `note.md` que originaram a P1–P5 saíram da fila; ficaram os três achados de processo do mesmo sprint que esta entrada não trata (`operator` e "código 0", R7 do `close.ps1` com histórico na linha, R4 sem registro da decisão do stakeholder).

---

## v3.42 — Guardas por papel (fase 2): gate protegido, teste ignorado, `Agent` só ao `operator`, matriz de propriedade, escopo do dev e pasta do job — G5 · G6 · G7 · G8 · G9 · G11 (SM + Arquiteto) — 04/10/2026

**Instrução** (stakeholder): "pode aplicar criando a branch a partir de develop" a `proposta-guards-fase2.md`, depois da sonda de 04/10/2026 num `/sm sprint plan` real. Decisões do formulário de 04/10/2026: **P1 — fase 2 inteira** (a recomendação era G7 + G9 + G6 primeiro) · **P2 — adiada:** a G8 entra com `ask` ao Arquiteto em código-fonte, decisão `ask` × `deny` + pedido registrado depois de 2 sprints de `guards.log` · versão-alvo v3.42.0, levando junto o addendum da v3.41 (previsto como v3.41.1).
**Classificação:** instrumento (G5–G9, G11; C3 `ownership`) · formato de documento (`**Arquivos tocados:**` legível por script; `.active-task`) · propriedade de artefato (linha `.active-task`; `ownership.json` derivado da matriz) · fluxo (`sprint run` passos 3, 4, 8; `fix run` passo 2 e fechamento; `/dev`) · comportamento de agente (cards, `hooks/`, `scripts/`, `commands/dev.md`, guias: aplicados pela sessão). **Sem regra nova** (34): as guardas reforçam R4, R7, R8, R28 e a matriz — critério de entrada de regra mecânica (`review-contract.md`).
**Papéis movidos (R17):** 2 — SM e Arquiteto → barreira de 10 240 B.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `artifact-ownership.md` | §1 | Linha nova **Escopo ativo do dev** (`.active-task`: dono SM, escritor a sessão); linha `hooks/` cita G5–G9/G11 e declara `hooks/ownership.json` **derivado** desta matriz (mudou a matriz, muda o JSON no mesmo ciclo — R12) |
| `sprint-run.md` · `fix-run.md` | passos 3, 4, 8 · passo 2 e §Fechamento · "Como o SM verifica" | A sessão grava `.active-task` antes de disparar o dev e o apaga quando a Task/bloco sai dele; GAP que acrescenta arquivo entra na lista do plano; deny seguido de contorno é achado |
| `working-rules.md` · `working-rules-index.md` | R4 · R7 · R8 · R28 · legenda | "Instrumento" ganha G9 (R4, R8), G5/G6 (R7), G7/G11 (R28); G8 = a matriz |
| `deliverables/team-project/` | `README.md` · `guards.json` | Chaves `protectedPaths`, `sourceRoots`, `testSkipPatterns`; linha `.active-task` (não semeada) |
| `roles/architect/templates/` | `implementation-plan.md` (regra 15, exemplo) · `fix-plan.md` | `**Arquivos tocados:**` = lista fechada, um caminho por linha entre crases; `- produção:`/`- teste:` também lidos pela G9 |
| Sessão (stakeholder) | `hooks/` (`pre-tool.ps1`, `common.ps1`, `session-start.ps1`, `hooks.json` + `Agent`, `ownership.json`, `COVERAGE.md`) · `release.ps1` (C3 `ownership`) · suítes · `agents/` (dev, arquiteto, QA, UX, operator) · `commands/dev.md` · `team-update.md` (7e) · `how-to.md` · `README.md` · `plugin.json` · `CHANGELOG.md` | Aplicados pela sessão |

### Por quê
A sonda resolveu a dúvida que travava a fase 2: dentro do subagente o hook recebe `agent_type` = `team:<papel>`; na sessão principal, nada. Com isso o "papel X não faz Y" dos cards passa a valer mesmo quando o modelo esquece — inclusive o dev em Haiku, que é quem mais improvisa escopo. O filtro casa o sufixo (`(^|:)developer$`), como a G4 já fazia com o `operator`.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Sessão / SM | grava e apaga `.active-task`; lê os deny no `guards.log` na retrospectiva |
| Arquiteto | lista de arquivos do plano legível e completa (produção e teste); GAP que acrescenta arquivo entra nela; código-fonte só com o "sim" do stakeholder |
| dev | barrado fora do plano, em gate e em teste ignorado — o caminho é 🔺 GAP |
| Stakeholder | responde a pergunta da G8 quando o Arquiteto vai escrever código; ajusta `protectedPaths`/`sourceRoots` do projeto |

### Conflitos com o processo vigente
- **R25** (sem pergunta ao stakeholder durante o `run`): o `ask` da G8 é uma pergunta. Só dispara se o Arquiteto escrever código — fora do papel dele no `run` —, e a P2 o revisa com dados. Registrado, não resolvido.
- **Matriz × JSON:** duas fontes possíveis. Resolvido: a matriz é a fonte, o JSON cita linha e dono, o C3 reprova a divergência.

### Como saberemos que funcionou
Em 2 sprints: zero arquivo fora do plano no diff de Task fechada (R4) e de Correção fechada (C4 item 5); zero teste ignorado introduzido pelo dev; `guards.log` sem linha `erro`; falso positivo ≤ 1 por guarda; contagem dos `ask` da G8 para decidir a P2.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Sonda (entrada) | linhas `probe` do `guards.log` de um projeto, `/sm sprint plan` de 04/10/2026 | `agent_type=team:product-owner` · `team:architect` · `team:user-experience` · `team:quality-assurance` · `team:scrum-master`; sessão `agent_type=(ausente)`; `script_ms` 144–393 | ✅ |
| Teste | `run-guard-tests.ps1` | `51 casos · 0 falharam` (30 novos: G5–G9, G11, G8 no repositório-fonte, projeto sem o time) | ✅ |
| Teste | `run-check-tests.ps1` | `20 casos · 0 falharam` (1 novo: `ownership.json` com dono divergente → exit 1) | ✅ |
| Arquivamento | `Contains` ordinal do bloco `## v3.39` no arquivo, depois de sair do vivo | True (7 506 B); índice com a linha `v3.39`; 3 entradas vivas (v3.42, v3.41, v3.40) | ✅ |
| Carga fixa (caracteres, `git show HEAD:` → arquivo) | cards | `developer` 3 896 → 3 960 · `architect` 5 316 → 5 278 · `quality-assurance` 6 534 → 6 437 · `user-experience` 5 469 → 5 474 · `operator` 5 941 → 5 990 · `commands/dev.md` 2 083 → 2 313 | medida |
| Release (R17 · R18 · ownership) | `powershell -NoProfile -File scripts/checks/release.ps1` (depois de gravar a v3.42) | R18 ok: plugin.json = CHANGELOG = README L3 = v3.42.0; processo 3.42, 3.41, 3.40 com entrega · R17 ok: bloco v3.42 ≤ barreira 10240 (2 papéis); 3 entradas vivas · ps1-5.1 ok: 11 scripts com BOM · ownership ok: 50 regras batem com linha e dono de §1, 7 com nota · órfãos ok: 45 modelos · exit 0 | ✅ |
**Não exercitado:** disparo real de cada guarda numa sessão com o plugin atualizado (só os testes, que entregam ao despachante o JSON do harness); `team:developer` e `team:operator` literais (deduzidos); o `ask` da G8 dentro de subagente no harness real.

### Pendente do stakeholder
Atualizar o plugin e **reiniciar a sessão**; `/team update` (passo 7e) em cada projeto; ligar a sonda no primeiro `sprint run` para confirmar `team:developer`/`team:operator`. Remover `proposta-guards-fase2.md` depois do aceite desta entrada (a fase 3, G12, segue registrada em `hooks/COVERAGE.md`).

---

## v3.41 — R34: contato remoto por Remote Control — identidade do projeto, pendência em disco, fim do `sprint run` em formulário de autorização da Review e protótipo publicável como artifact (SM + UX) — 03/10/2026

**Instrução** (stakeholder, `/review`): "finalizamos os testes do `proposta-remote.md`, podemos rodar o review e aplicá-lo". Decisões D1–D6 da proposta (Remote Control; ① e ③ respondíveis no celular com a navegação **declarada**; Identificador remoto; fim do `run` em formulário; artifact privado pela conta do celular; conta por projeto) e as do formulário de 03/10/2026: **G3 estendida** (prefixo + pendência em §7) · pendência = **item numerado em §7**, sem rótulo "Aguarda stakeholder" · **fim do `fix run` sem formulário** (R33 intacta) · ficha do ① na opção A · protótipo num `index.html` único (ratificado).
**Classificação:** regra nova (R34; R15, R22 e R25 emendadas, R27 por remissão; saldo +1) · fluxo (fim do `sprint run`, portões ①–④, `/team remote`) · formato de documento (campos remotos em §1, item numerado em §7, linhas do ③, ficha do ①) · instrumento (G3, C2 linha R34) · comportamento de agente (`commands/`, `hooks/`, `scripts/`, `rituals/`, `how-to.md`: aplicados pela sessão).
**Papéis movidos (R17):** 2 — SM e UX → barreira de 10 240 B.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `working-rules.md` · `working-rules-index.md` | R34 · R15 · R22 · R25 · R27 · tabelas | **R34 nova** ("SM verifica" = G3 + C2 parcial, julgamento declarado). R15: navegação é do stakeholder e "aprovar" declara; 7 regras do artifact. R22: decisão de portão com navegação declarada, ④ com resumo do dossiê, pendência gravada antes. R25: três formulários admitidos na janela; fim do `run` abre o 2º ponto fixo. Índice R1–R34; contagem 33 → 34 em `README.md`, `agents/scrum-master.md`, `roles/scrum-master/README.md` |
| `sprint-run.md` · `fix-run.md` | Ao fim da fila · §Plan · §Fechamento | Formulário de autorização da Review (4 opções; "iniciar depois" fica em §7); ajustes do `fix plan` com prefixo e pendência por pergunta; fim do `fix run` declarado **sem** formulário |
| `workflow-sdd.md` · `workflow-sprint.md` · `workflow.md` | ① ② · passo 10 e Review · §8 | Prefixo, pendência, canal e declaração de navegação; ④ com resumo do dossiê |
| `templates/` (SM) | `project-context` · `sprint-backlog` · `sprint-review` | §1 com `Identificador remoto`, `Conta remota`, `Verificação remota`; linhas `Canal da decisão` e `Protótipo (URL · rótulo)` no ③; texto de uso do §7 **fora** do bloco copiado (o C2 lê o README por padrões) |
| `deliverables/team-project/README.md` | manifesto | §1 remoto = estrutura + conteúdo local (o `update` cria vazio) |
| UX (`roles/user-experience/`, `deliverables/prototype/README.md`) | protótipo | `index.html` único e autocontido, "Publicável como artifact" com rótulo de versão, ficha do ① com `canal: … · declarada [· artifact: …]`, ficha do ③ com Canal e Artifact, A1–A6 |
| Sessão (stakeholder) | `hooks/pre-tool.ps1` (G3) · `project.ps1` (C2 R34) · `rituals/team-remote.md` (novo) · `team-update.md` · `commands/` · `how-to.md` · `plugin.json` | Aplicados pela sessão |

### Por quê
O stakeholder conduz vários projetos e só responde na frente do terminal: a sessão para e, quando ele volta, não há sinal de qual projeto espera o quê. Pelo celular o risco é responder no projeto errado, ler formulário expirado como recusa e perder a pergunta quando a sessão cai. R34 põe a identidade na mensagem, a pendência em disco antes da pergunta e a limitação medida (sem *push* no Android) dentro do desenho. A navegação passa a ser responsabilidade declarada porque o protótipo não abre no celular sem artifact.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| SM / sessão | prefixo e pendência em §7 antes de todo formulário; formulário de fim do `run`; registro do ③ com canal e URL · rótulo |
| UX | entrega o HTML único publicável (a sessão publica); registra canal na ficha |
| Stakeholder | aprovar ① e ③ declara a navegação; abrir App → Code para ver o que espera |

### Conflitos com o processo vigente
- **R15 · R22 · R25(a)** exigiam navegar "fora do formulário e antes dele"; D2 move a navegação para responsabilidade declarada. **Resolvido pelo stakeholder (D2, D5)**; as três regras foram reescritas.
- **R25** "nenhuma mensagem entre pacote e Review": emendada (bloqueio, ajustes do `fix plan`, autorização da Review). **R22 L189**: registro ≠ resolução mantido, com a exceção de ordem de R34. **R33**: intacta. **R21, R27, R31, R3, R5**: sem conflito (carga fixa medida abaixo).

### Como saberemos que funcionou
Nos 2 sprints seguintes, por projeto remoto: **100%** das decisões de portão e bloqueio com prefixo e pendência anterior · **zero** decisão no projeto errado · ① e ③ com canal registrado em 100% · mediana formulário → decisão **menor** que a dos 2 sprints anteriores; sem queda, a Retrospective decide se mantém.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Contagem | `Select-String '^### R\d+\.'` em `working-rules.md` · `'^\| R\d+ '` no índice · `'^\| R\d+ \|'` no resumo | 34 · 34 · 34 (antes: 33) | ✅ |
| Substituição de padrão | `Select-String '33 regras\|R1–R33\|R30-R33\|R1-R33'` em `*.md/.ps1/.json` fora dos changelogs e propostas | 0; novas (`README.md:189`, `agents/scrum-master.md:34`, `roles/scrum-master/README.md:185`, índice) lidas: "34 regras", "R30-R34", "R1–R34" (4 linhas) | ✅ |
| Substituição de padrão | `Select-String 'fora do formulário e antes\|acontece fora do formulário'` em `*.md` | 0; as reescritas (R22, R25(a), `workflow.md`, `workflow-sdd.md`) lidas no contexto | ✅ |
| Referência | `Select-String 'team-remote'` em `commands/team.md`, `README.md` | `team.md:17` · `README.md:49` — sem órfão | ✅ |
| Arquivamento | `-ceq` do bloco `## v3.38` no arquivo contra o texto que saiu do vivo | True (`Contains` do texto do bloco no arquivo; 10 268 B; zero linha fora do separador); índice com a linha `v3.38`; 3 entradas vivas (v3.41, v3.40, v3.39) | ✅ |
| Teste | `run-guard-tests.ps1` · `run-check-tests.ps1` | `21 casos · 0 falharam` · `19 casos · 0 falharam` (4 e 3 casos novos de G3/C2 R34) | ✅ |
| Carga fixa (caracteres, antes → depois) | `git show HEAD:` × arquivo | `commands/sm.md` 8 215 → 8 769 · `team.md` 2 895 → 3 465 · `po.md` 5 336 → 5 465 · `ux.md` 5 219 → 5 724 | medida |
| Release (R17 · R18) | `powershell -NoProfile -File scripts/checks/release.ps1` (depois de gravar a v3.41) | R18 ok: plugin.json = CHANGELOG = README L3 = v3.41.0; processo 3.41, 3.40, 3.39 com entrega · R17 ok: bloco v3.41 com 7618 bytes ≤ barreira 10240 (2 papéis); 3 entradas vivas · ps1-5.1 ok: 11 scripts com BOM · órfãos ok: 45 modelos, todos referenciados · exit 0 | ✅ |
**Não exercitado:** G3 contra um `AskUserQuestion` real do harness (só os testes); C2 R34 contra projeto real com Identificador; `/team remote` de ponta a ponta num projeto (o mecanismo foi medido no spike M10–M21).

### Pendente do stakeholder
Nada a aplicar. Mudança de hook, comando e agente só vale **após atualizar o plugin e reiniciar a sessão**; `/team update` (passo 7d) e `/team remote` em cada projeto. Remover `proposta-remote.md` depois do aceite desta entrada.

### Addendum — 04/10/2026 (previsto como v3.41.1, entregue na v3.42.0): a saída de qualquer modo leva decisão em formulário (R22)
**Achado (stakeholder, num projeto):** o `/sm sprint prepare` devolveu 9 decisões do stakeholder e 2 do PO em tabela de prosa, "responda ou aceite as recomendações", sem `AskUserQuestion`. **Causa:** `prepare` "não sobe ao stakeholder" (lido como "sem formulário"), nenhum passo previa as decisões que os papéis levantam, e os `commands/` mandavam "destacar em uma linha" a decisão — que a sessão cumpria em prosa. **Emenda:** R22 ganha o parágrafo "A saída de qualquer modo também" (até 4 perguntas por chamada, várias chamadas) e o "SM verifica" cobre fim de modo; `prepare` ganha o passo 7 e passa a "não cria portão nem aprovação"; `sm.md`, `po.md`, `arc.md`, `ux.md` e `team.md` trocam "destaque" por `AskUserQuestion`. **Sem regra nova** (34 regras). **Não coberto por guarda:** a G3 só vê pergunta feita; resumo em prosa segue sendo achado de verificação do SM.
