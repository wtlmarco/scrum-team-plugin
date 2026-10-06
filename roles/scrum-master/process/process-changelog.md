# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
| [`v3.43`](process-changelog-archive.md) | `sprint run` sem paradas fora do contrato: lista fechada de paradas, rota do gate protegido, negação ao dev vira 🔺 GAP, interrupção pelo stakeholder e marcador acompanhando a Task; addendum: veredito pelo primeiro marcador, desvio aceito no R4, código de saída do `operator` (SM + Arquiteto + QA) — 05/10/2026 |
| [`v3.42`](process-changelog-archive.md) | Guardas por papel (fase 2): gate protegido, teste ignorado, `Agent` só ao `operator`, matriz de propriedade, escopo do dev e pasta do job — G5 · G6 · G7 · G8 · G9 · G11 (SM + Arquiteto) — 04/10/2026 |
| [`v3.41`](process-changelog-archive.md) | R34: contato remoto por Remote Control — identidade do projeto, pendência em disco, fim do `sprint run` em formulário de autorização da Review e protótipo publicável como artifact (SM + UX) — 03/10/2026 |
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

## v3.46 — Plano em contrato conferido antes do dev, prova de falha por mutação, trilha leve por Task, Arquiteto um passo à frente e fechamento pela sessão (SM + Arquiteto + Dev + QA) — 06/10/2026

**Instrução** (stakeholder): "pode aplicar", sobre `proposta-custo-run.md` com as decisões D2, D3, D5, D6 e D7 (formulário de 06/10/2026, todas pela recomendação). Terceiro e último pacote da §4 da proposta (M2, resto da M3, M5 `close -Apply`, M6, M7), sobre a v3.45.1. **Causas medidas no piloto (v3.42):** 5 de 8 Tasks com defeito no código literal do plano (Opus escrevendo código sem compilar, 20 a 70 mil tokens e 10 a 30 min por ciclo de 🔺 GAP); a prova de falha sem lugar (6 negações da G9 a arquivo temporário, prova rodada pelo dev e de novo pelo QA); Task de harness com o pacote inteiro (~530 mil tokens); o SM chamado só para edição mecânica (213 mil tokens em 8 fechamentos); plano fora do caminho crítico proibido pela série total, embora a R1 o permita.
**Classificação:** formato de documento (plano, Sprint Backlog) · instrumento (`plan.ps1` novo, `verify.ps1 -Mode mutation`, C1 `R7-mutação`, `close.ps1 -Apply`) · fluxo (`sprint-run.md` 1, 3, 7, §Disparo; Planning passo 5) · comportamento de agente (Arquiteto lê o índice de `standards/` e a seção do modo). **Sem regra nova** (34): reforça R7, R8, R23, R1, R24.
**Papéis movidos (R17):** 4 — SM, Arquiteto, Dev, QA → barreira de 15 360 B.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `implementation-plan.md` | regras 7, 17–20 · §6 · cabeçalho · Variante leve (nova) | **plano é contrato**: escolha que não muda comportamento, contrato, camada ou standard é do dev; trecho literal até 15 linhas ou `**Validado em:**`; teste não vai escrito no plano; `**Mutações:**` por teste (`- M<k> · teste … · produção · trecho → mutante`) ou `sem prova:`; `plan.ps1` antes do dev; `**Planejado durante:**`; `**Trilha:**` e a variante leve |
| `scripts/checks/plan.ps1` (novo) | — | lista legível com teste · protegidos · blocos (≤ 8, Pronto com exit 0) · trecho ≤ 15 linhas ou validado · mutações dentro da lista · critério mecânico da leve; exit 1 = o plano volta ao Arquiteto |
| `verify.ps1` | `-Mode mutation -Plan [-Only]` | sobre a árvore do último `full`: troca o trecho (uma ocorrência, arquivo do plano), roda o teste focado, espera exit ≠ 0, restaura byte a byte (BOM preservado; backup restaurado na próxima execução se o processo morrer); árvore tem de voltar igual; amostragem do QA mantém as outras do registro |
| `close.ps1` (C1) | `R7-mutação` · `-Apply` | toda mutação do plano pega, na árvore do `full` (bloqueante com `verify`); `-Apply`: sem falha bloqueante, marca ✅, grava Registro e Série (estimativa baixada, composição recontada), roda o `-Post` e imprime a entrada de status pré-preenchida |
| `agents/architect.md` · README do Arquiteto | leitura · passo 4 | `standards/README.md` e só as seções da Task (não os ~135 KB a cada invocação); a seção do modo, não o README inteiro; plano em contrato e `plan.ps1` antes de responder |
| `sprint-run.md` | 1 · 3 · 7 · §Disparo · Como o SM verifica | leve em Sonnet; `plan.ps1` antes do dev (reprovado volta ao mesmo Arquiteto); `-Mode mutation` no fim; **a sessão fecha com `close.ps1 -Apply`**, o Agent `scrum-master` só com julgamento; Arquiteto planeja a Task independente seguinte durante a construção |
| `agents/developer.md` · `agents/quality-assurance.md` · README do QA | prova de falha · trilha leve | o dev roda a mutação e não cria arquivo temporário; o QA julga se a mutação representa a regra e reexecuta uma por amostragem; Task leve: frentes 1, 2 (objeto 1), 4 e cenários |
| `templates/sprint-backlog.md` · `workflow-sprint.md` Planning 5 · `working-rules.md` R23 · índice das regras | Trilha | coluna `Trilha` (`plena`/`leve`) com o critério mecânico; quadro anterior sem a coluna = plena |
| README do SM · `COVERAGE.md` · `how-to.md` | — | o `close` da sessão; a escrita temporária da mutação fora da G9 e os limites dela |
| Sessão (stakeholder) | `scripts/*` e testes · `agents/*` · `plugin.json` · `README.md` · `CHANGELOG.md` | aplicados pela sessão, a pedido |

### Por quê
O texto mais caro do sprint — o plano em Opus — era o que menos se validava, porque a regra 7 pedia o código inteiro e a G8 (certa) proíbe o Arquiteto de compilar no projeto. Contrato com mutação desloca o "como" para quem tem o compilador e mantém o controle: a Conferência do passo, o `verify` e a mutação dizem se o resultado está certo, sem o Arquiteto escrever o corpo. A prova de falha passa a ser dado do plano, executada uma vez por script e amostrada pelo QA. A trilha leve aplica a R23 à Task: menos escopo verificado, a mesma evidência. O `close -Apply` tira um agente do caminho de cada fechamento — a escrita é a mesma que a sessão já faz a cada transição (§Marcador).

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Arquiteto | escreve contrato e mutações; trecho longo só validado; passa no `plan.ps1`; lê o índice dos standards; adianta o plano da Task independente |
| Dev | escreve o corpo; roda `-Mode mutation` no fim; não cria arquivo para provar falha |
| QA | julga a mutação e reexecuta uma; frentes reduzidas na leve |
| SM / sessão | `plan.ps1` antes do dev; `close.ps1 -Apply`; trilha decidida na Planning |

### Verificação (R19)
| Item | Comando | Resultado | |
|---|---|---|---|
| Conferências | `run-check-tests.ps1` | 52 casos · 0 falharam (11 novos: mutação sem execução não fecha; mutação pega com árvore restaurada; `R7-mutação` ok; mutação decorativa com `-Only` reprova e mantém a amostra anterior; `-Apply` grava quadro, Registro, Série, `-Post` ok e entrada de status; `-Apply` de novo = 2; `-Apply` com R12 pendente não toca o quadro; plano em contrato ok; plano com código longo, 9 arquivos sem bloco, sem teste, sem mutação e sem protegidos reprova; leve com 6 arquivos volta à plena) | ✅ |
| Guardas | `run-guard-tests.ps1` | 85 casos · 0 falharam | ✅ |
| Release | `release.ps1` | exit 0 — R18 v3.46.0 · R17 bloco v3.46 ≤ 15 360 (v3.43 arquivada) · ps1-5.1 16 · ownership 53 · órfãos 45 | ✅ |

**Não exercitado:** um `sprint run` real com plano em contrato, mutação e `-Apply`; mutação em arquivo com CRLF misto ou codificação que não seja UTF-8 (o script lê e grava UTF-8, preservando o BOM).

### Pendente do stakeholder
Atualizar o plugin, `/team update` (7g, 7h) e reiniciar. **Medir** com o consumo da v3.45 os indicadores da §5 da proposta nos dois sprints seguintes (tokens por Task, suítes por Task, ciclos de GAP por defeito de plano). Remover `proposta-custo-run.md` depois do aceite desta entrada.

---

## v3.45 — Consumo medido no transcript (G16), R28 por Task e plano em blocos de até 8 arquivos com uma instância de dev por bloco (SM + Arquiteto + Dev + QA + UX) — 06/10/2026

**Instrução** (stakeholder): "Avalie profundamente pois realmente a execução está onerosa e demorada; gere a proposta de correção", sobre o relatório de processo do primeiro `sprint run` de um projeto-piloto (v3.42, 04–06/10/2026: 8 de 19 Tasks, 4,99 M tokens registrados, ~620 mil por Task fechada, ~34 h corridas). Proposta em `proposta-custo-run.md`, decisões D1–D7 em formulário (todas pela recomendação), "pode aplicar". **Esta entrega é o primeiro pacote da §4** (M0, M5, blocos da M3/M4); `verify.ps1` (M1) vem na v3.45.1 e o resto na v3.46.
**Classificação:** instrumento (G16 novo, `consumption.ps1` novo, C1 R28) · formato de documento (consumo, Execução delegada, plano, relatório do dev) · fluxo (`sprint-run.md` passo 3). **Sem regra nova** (34): reforça R28, R7, R1.
**Papéis movidos (R17):** 5 — SM, Arquiteto, Dev, QA, UX → barreira de 17 920 B.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `hooks/subagent-stop.ps1` (novo) · `hooks.json` · `session-start.ps1` | `SubagentStop` · **G16** | uma linha por rodada de subagente em `.team-project/usage.jsonl`, somada no transcript dele (dedup por `message.id`): processado, contexto 1ª/pico/final, modelo servido, duração, Task do prompt, filhos (`agentId`), destino; retomada = rodada nova com o delta; nunca bloqueia |
| `scripts/checks/consumption.ps1` (novo) | — | reescreve as linhas medidas (`medido:` na Nota) e os Totais de cada `consumption.md` aberto; mantém as linhas à mão; categoria mecânica (retomada, QA depois de QA, Arquiteto/dev depois de QA, Arquiteto depois do dev = `retrabalho`); `triagem;` em F-ID fora do bloco; sprint/bloco fechado recusado |
| `templates/consumption.md` | cabeçalho · §O que mede · Registro · Totais · §Como gravar · §Regras | Tokens = **processado**; a Nota traz o número da notificação; uma linha por **rodada**; modelo **servido**; a sessão só roda o script e grava a linha de sessão; Totais com "Σ notificação" (linhas antigas somam só ali) |
| `scripts/checks/close.ps1` (C1) | R28 | conta **por Task**: `report*.md` de `operator/<n>/<T-ID>…/` + os citados na §11 do plano e na evidência × linhas `operator` daquela Task |
| `agents/{developer,quality-assurance,architect,operator}.md` · `commands/qa.md` · `delivery-report.md` · `verdict.md` · `evidence.md` · `implementation-plan.md` §11 · `spike-checkpoint.md` · protótipos do UX · `skills.md` de Dev, QA, Arquiteto e UX | Execução delegada | vira **índice dos jobs** (job + Task); ninguém copia token nem duração; job da Task em `operator/<n>/<T-ID>[-<slug>]/`; o `operator` diz quando o `report` não foi gravado |
| `implementation-plan.md` regra 2 · §4 | blocos | acima de 8 arquivos, `### Bloco <k>` com `**Arquivos do bloco:**`, `**Depende de:**`, `**Pronto do bloco:**` |
| `sprint-run.md` passo 3 · §Disparo · Como o SM verifica · `agents/developer.md` item 9 · `delivery-report.md` | blocos · consumo | uma instância de dev por bloco; duas sem o Pronto no mesmo bloco → a terceira com `model: "sonnet"`; o dev para quando o Pronto não bate; a sessão roda o `consumption.ps1` |
| `working-rules.md` R28 · índice · `workflow-sprint.md` · `workflow-processo.md` · README do SM · `artifact-ownership.md` §1 (linha nova `usage.jsonl`) · `ownership.json` | — | alinhados |
| Sessão (stakeholder) | `hooks/*` · `COVERAGE.md` · testes · `team-update.md` 7g · `how-to.md` · `plugin.json` · `README.md` · `CHANGELOG.md` | aplicados pela sessão, a pedido |

### Por quê
O registro de consumo copiava o número da notificação, e esse número — medido em dois transcripts desta máquina — é o **contexto da última chamada**, não o processado (49 004 × 273 190; 53 245 × 322 194). O sprint do piloto custou de 5 a 6 vezes os 4,99 M anotados, quase tudo leitura de cache; e a transcrição à mão teve seis correções. Sem medida certa, nenhuma das mudanças seguintes da proposta se avalia. O R28 contava o sprint inteiro: uma divergência reprovava todo fechamento seguinte (7 de 8 no piloto). Blocos de até ~8 arquivos acabaram com as paradas do dev por contexto esgotado no próprio piloto (T-009, T-010); a regra não existia.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Sessão que orquestra | roda `consumption.ps1`; não transcreve número; uma instância de dev por bloco; escalona a terceira para Sonnet |
| Arquiteto | divide em blocos acima de 8 arquivos, com o Pronto de cada um; §11 é índice |
| Dev | executa um bloco; para quando o Pronto não bate; ID da Task no pedido ao `operator` |
| QA · UX | Execução delegada como índice |
| SM | confere consumo medido e R28 por Task |

### Verificação (R19)
| Item | Comando | Resultado | |
|---|---|---|---|
| Guardas | `run-guard-tests.ps1` | 84 casos · 0 falharam (3 novos: rodada com dedup por `message.id`, Task do prompt e filho; parada sem chamada nova não grava; retomada = rodada 2 com o delta e o modelo servido) | ✅ |
| Conferências | `run-check-tests.ps1` | 33 casos · 0 falharam (novos: R28 por Task com outra Task divergente; Task sem `operator`; `consumption.ps1` mantém manual e sessão, não duplica, liga o `operator` ao chamador, recusa sprint fechado; C1 lendo as linhas medidas) | ✅ |
| Release | `release.ps1` | R18 ok v3.45.0 · R17 ok (bloco v3.45 ≤ 17 920; v3.42 arquivada) · ps1-5.1 ok (14) · ownership ok (52) · órfãos ok (45) · exit 0 | ✅ |
| Hook real | `subagent-stop.ps1` num transcript desta máquina (`agent-a537fd715c6f98b7e`) | 9 chamadas, 322 194 processados, contexto final 52 082 (notificação: 53 245), 1,35 s; segunda parada sem chamada nova não grava | ✅ |

**Não exercitado:** o `SubagentStop` disparado pelo harness num `sprint run` (campo do caminho do transcript não documentado — o hook deriva; a sonda grava os campos recebidos); `operator` aninhado ligado ao chamador num run real.

### Pendente do stakeholder
Atualizar o plugin, `/team update` (passo 7g) e **reiniciar a sessão**; no primeiro run, `"probe": true` para ver os campos do `SubagentStop`. `proposta-custo-run.md` fica até a v3.46.

### Addendum — 06/10/2026 (v3.45.1): verificação uma vez só, amarrada à árvore
**Instrução** (stakeholder): a mesma ("pode aplicar"), segundo pacote da §4 da proposta (M1, decisão D1). **Causa medida no piloto:** a mesma suíte (~2 min) e a mesma prova de falha (4 a 8 min) rodavam duas ou três vezes por Task — dev pelo `operator`, QA pelo `operator` de novo, a sessão com `--include` —, porque nenhuma evidência estava amarrada ao código: o "nunca aceite alegação" do QA chocava com o "não reexecuta para conferir" da R28. **Classificação:** instrumento (`verify.ps1` novo, `Get-WorkTree`, C1 `R7-verify`) · fluxo (dev, QA, sessão). **Sem regra nova:** R7 e R28 ganham a frase que resolve o choque.

| Documento | Mudança |
|---|---|
| `scripts/checks/verify.ps1` (novo) · `lib.ps1` | `-Mode focused` (`{tests}`) · `full` (build, lint, suíte, cobertura) · `check` (só compara); comandos de `guards.json` → `verify`; código de saída real (`-EncodedCommand`, cmdlet que falha = 1); log por comando e `result.json` em `.team-project/verify/<n>/<ID>/`, com a **impressão digital da árvore** — tree do git num índice temporário, novo não rastreado incluído, `.team-project/` fora — antes e depois |
| `close.ps1` (C1) | `R7-verify` bloqueante quando `verify` está configurado: `full` presente, todo exit 0, árvore igual à do disco |
| `working-rules.md` R7 · R28 | saída do `verify.ps1` para a árvore do disco é saída real; não se reexecuta — nem QA, nem sessão; `operator` fica para o que o `verify` não cobre |
| `agents/developer.md` 6 · `delivery-report.md` | `focused` durante o bloco, `full` uma vez no fim, linhas coladas |
| `agents/quality-assurance.md` · README do QA (frente 4, `/qa <ID>` 3) · `verdict.md` | começa por `-Mode check`; igual e verde → cita, não reexecuta; diferente → `full` dele, uma vez; o tempo vai para "o teste pega a regressão" |
| `sprint-run.md` 3 · 5 · 7 · `fix-run.md` · `implementation-plan.md` §7 e Pronto · `how-to.md` | a sessão não reexecuta verificação de papel; prompt do dev com o `verify`; C1 lê o `result.json` |
| `guards.json` (modelo) · `team-update.md` 7h (novo) · `team-init.md` 4a · `ownership.json` · `artifact-ownership.md` §1 (linha nova) | chave `verify`; preenchida a partir do `developer/context.md` num formulário; `.team-project/verify/` sem escritor de papel |

**Verificação (R19):** `run-check-tests.ps1` → 41 casos · 0 falharam (8 novos: `focused` sem `-Tests` = 2; `full` verde grava `result.json`; C1 `R7-verify` ok com a árvore igual; `check` igual = 0; arquivo novo não rastreado → `check` diferente e C1 não fecha; suíte com exit 4 → código real e C1 não fecha) · `run-guard-tests.ps1` → 85 · 0 (G14 libera o `verify.ps1` ao dev) · `release.ps1` → exit 0 (R18 v3.45.1; R17 bloco v3.45 ≤ 17 920; ps1-5.1 15; ownership 53; órfãos 45). **Não exercitado:** `verify.ps1` com a toolchain real de um projeto (npm/dotnet) e suíte acima do timeout da ferramenta (600 s — acima disso, `operator`).

---

## v3.44 — Run sem trava: o Arquiteto decide e não escreve no código (G8 nega), a G14 libera o operacional do run, a G15 registra pedido de permissão, a R27 lê o transcript; o que sobe ao stakeholder (SM + Arquiteto + PO) — 06/10/2026

**Instrução** (stakeholder): "Gere um plano de alteração para corrigir esses problemas", sobre o relato de um projeto-piloto (v3.42, 05–06/10/2026): quatro chamadas a agentes voltaram "interrupted" — uma por pergunta da G8 (Arquiteto escrevendo `relogio.service.spec.ts`, recusada), três paradas de 24 min a 5 h 33 min sem nada no `guards.log`. Mais duas perguntas da G8 aceitas. As quatro escritas do Arquiteto vieram do prompt de GAP da sessão ("valide contra o compilador"). Plano em `proposta-run-sem-travas.md`. **Decisões do stakeholder (06/10/2026):** **D1** — "o Arquiteto pode resolver questões técnicas operacionais mais complexas sem precisar subir para eu decidir… ele orienta e passa para o demandante a resposta" (fecha o P2 da v3.42: G8 nega, sem pergunta); **D2** — registrar o pedido de permissão **e** "no operacional do sprint run e fix os guards… podem permitir o acesso"; **D3** — lista liberada no `init`/`update`: ok; **revista no mesmo dia** ("ela não deveria estar no `.team-project` para o usuário do plugin?"): a lista é só `runCommands` no `guards.json`, aplicada pela G14 — o plugin não escreve em `.claude/settings*.json` (o harness só lê permissão de lá, e fora do run o stakeholder está presente). **Detalhe (mesmo dia):** Arquiteto e PO sobem ao stakeholder só mudança funcional, impacto significativo ou arquitetura fora do SDD que altera significativamente o esperado do sistema.
**Classificação:** instrumento (G8, G14, G15, G13; `notification.ps1` novo) · fluxo (`sprint-run.md`, `fix-run.md`) · propriedade de artefato (`.active-run`, `.active-spike`) · regra (R27: segunda conferência) · comportamento de agente (card do Arquiteto) · roteamento (`workflow.md` §6). **Sem regra nova** (34): reforça R25, R27, R9, R28.
**Papéis movidos (R17):** 3 — SM, Arquiteto e PO → barreira de 12 800 B.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `hooks/pre-tool.ps1` · `common.ps1` | G8 · G14 (nova) | **G8** nega código-fonte ao Arquiteto salvo com `.active-spike`, com a rota na mensagem (scratchpad · `operator` no sprint · prova do teste com o dev); vale também para escrita pelo `PowerShell`/`Bash` (heurística, `*.log` liberado). Nenhuma guarda pergunta mais (`Ask` removida). **G14** — com `.active-run`, papel do time: `allow` em `Edit`/`Write` no projeto ou no temporário e em comando cujos segmentos estão todos na lista (git sem push, leitura, `Get-WinEvent`, `runCommands`, conferências `scripts/checks`); nega `--no-verify`, `Invoke-Expression`, `Start-Process`, escrita por `[IO.File]`, escrita fora do projeto e — com `runCommands` preenchido — o que está fora da lista |
| `hooks/notification.ps1` (novo) · `hooks.json` | `Notification · permission_prompt` | **G15** grava o pedido de permissão no `guards.log`, com o texto e o run ativo |
| `hooks/session-start.ps1` | G13 | lista G14/G15; avisa `.active-run`/`.active-spike` sobrando |
| `ownership.json` · `artifact-ownership.md` §1 | linha nova | `.active-run` e `.active-spike`: dono SM, escritor a sessão |
| `deliverables/team-project/guards.json` | `runCommands` | chave nova, vazia no modelo |
| `sprint-run.md` | pré-condições · paradas · R27 · passos 2 e 4 · Como o SM verifica | `.active-run` gravado antes do 1º agente e apagado em toda parada; R27 com as duas conferências e "permissão pendente"; escalação só pelo critério novo; prompt de GAP nunca pede escrita/compilação no projeto; deny G8 por prompt é achado contra a orquestração; linha G15 no run vai à retro |
| `fix-run.md` | §Run, paradas | o mesmo contrato; no fix, validação do Arquiteto só no scratchpad |
| `working-rules.md` | R27 | segunda conferência: transcript do subagente (último `tool_use` sem `tool_result`) e linhas G15; classificação "permissão pendente" |
| `roles/architect/README.md` · `skills.md` §11 · `templates/fix-plan.md` regra 6 | `/arc question` 3–4 · §Validar sem escrever no produto (nova) · spike | questão técnica operacional decide e devolve; sobe só o critério novo; validar por scratchpad, `operator` (sprint) ou "não validado"; spike só com `.active-spike`; prova do teste de regressão é do dev |
| `roles/product-owner/README.md` · `workflow.md` §6 | degrau 1 · roteamento | o que sobe ao stakeholder, e só isso; questão técnica operacional → Arquiteto |
| `rituals/team-update.md` 7e · 7f (novo) · `team-init.md` 4a (novo) | — | `runCommands` no `.team-project/guards.json` a partir do `developer/context.md`, só acrescentando, um formulário; o plugin não escreve em `.claude/settings*.json` |
| Sessão (stakeholder) | `agents/architect.md` · `hooks/COVERAGE.md` · `run-guard-tests.ps1` (+19 casos) · `plugin.json` · `README.md` · `CHANGELOG.md` | Aplicados pela sessão, a pedido |

### Por quê
A lista fechada de paradas da v3.43 não cobria duas saídas do contrato que o piloto mediu: a **pergunta da própria guarda** (G8 `ask`) e o **pedido de permissão do harness**, que trava o subagente — em primeiro ou segundo plano — até alguém responder, sem rastro no `guards.log`. A primeira nascia de prompt da orquestração; a segunda virava "interrompido" sem causa, e a sessão chegou a atribuí-la ao stakeholder (R27 já proibia). A documentação do Claude Code (consultada em 06/10/2026) confirma que `permissionDecision: "allow"` num `PreToolUse` pula o pedido também em subagente — por isso a liberação vive na guarda, restrita ao run e ao que as outras guardas já conferiram.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Sessão que orquestra | grava e apaga `.active-run` (e `.active-spike`); prompt de GAP sem escrita no projeto; R27 com as duas conferências; acrescenta prefixo de build/teste/lint a `runCommands` quando falta |
| Arquiteto | decide a questão técnica e devolve; não escreve no código fora de spike declarado; registra como validou |
| PO | sobe ao stakeholder só o critério novo |
| SM | verifica marcadores sobrando, deny G8 por prompt e linhas G15 no run |

### Verificação (R19)
| Item | Comando | Resultado | |
|---|---|---|---|
| Guardas | `powershell -NoProfile -File scripts/checks/tests/run-guard-tests.ps1` | 73 casos · 0 falharam (G8 nega com a rota, libera com `.active-spike` e no scratchpad, nega `Set-Content` em código; G14 libera git/leitura composta/`runCommands`/C1/escrita no escopo e no temporário, deixa ao harness sem run e sem `runCommands`, nega fora da lista, `--no-verify`, destino variável e fora do projeto; G15 grava; G13 avisa marcador) | ✅ |
| Release (R17 · R18) | `powershell -NoProfile -File scripts/checks/release.ps1` | R18 ok: plugin.json = CHANGELOG = README L3 = v3.44.0, processo 3.44/3.43/3.42 com entrega · R17 ok: bloco v3.44 ≤ 12800 (3 papéis), 3 entradas vivas (v3.41 arquivada) · ps1-5.1 ok: 12 scripts · ownership ok: 51 regras · órfãos ok: 45 modelos · exit 0; `run-check-tests.ps1` → 25 · 0 | ✅ |

**Não exercitado:** um `sprint run` e um `fix run` reais com a v3.44. **A confirmar no disparo real:** se o evento `Notification · permission_prompt` dispara para pedido feito dentro de subagente (a documentação não diz); se `allow` da G14 prevalece sobre regra `ask`/`deny` do `settings` (não documentado). Sem a G15, a R27 segue pelo transcript.

### Pendente do stakeholder
Atualizar o plugin, rodar `/team update` (passo 7f) em cada projeto e **reiniciar a sessão**; no primeiro run, `"probe": true` para ver as linhas `G14 allow` e `G15`. Remover `proposta-run-sem-travas.md` depois do aceite desta entrada.

### Addendum — 06/10/2026 (mesma v3.44.0): segundo relato, cinco interrupções
**Instrução** (stakeholder): "Faça uma averiguação profunda sobre essas reclamações e tendo essa certeza pode aplicar". **Relato** (outro usuário): cinco chamadas `Agent` em primeiro plano "interrupted", sem ação dele; não é limite de tempo (uma de 82 min terminou bem); duas coincidem, em até 70 ms, com a entrega de notificação de agente em fila; quase todos os subagentes estavam parados esperando (comando em segundo plano, pergunta de autorização ou nada registrado). **Averiguação:** (1) transcripts desta máquina — em todo "interrupted" de pedido de permissão, logo antes vem o `tool_result` "The user doesn't want to proceed" (pedido fechado sem aprovação); os demais são Esc durante a ferramenta; (2) issue anthropics/claude-code#84346 (fechada sem correção) — vigia de ~600 s sobre requisição de modelo parada sai como "interrupted by user"; (3) documentação — pedido de permissão em subagente **não expira**; notificação **não interrompe** ferramenta em curso (confirmado aqui com comando em primeiro plano); sessão interativa dispara subagente em segundo plano por padrão; (4) **não medido:** se notificação fecha pedido pendente (o modo desta sessão não abre pedido). **Conclusão:** a coincidência com notificação não está provada; o que está provado é que o papel parado esperando — permissão, comando em segundo plano ou modelo — derruba a chamada em primeiro plano e prende a sessão, e os seis `commands/` forçavam esse primeiro plano.

| Documento | Mudança |
|---|---|
| `sprint-run.md` §Disparo (era §Task pesada) · Como o SM verifica · `fix-run.md` | **todo** agente do `run` com `run_in_background: true`; série R1 mantida aguardando a notificação; encerrar o turno à espera não é parada |
| `commands/{arc,dev,qa,po,ux,sm}.md` | `run_in_background: false`, salvo no `sprint run`/`fix run` (`true`) |
| `hooks/pre-tool.ps1` G14 · `COVERAGE.md` · `how-to.md` | nega comando com `run_in_background: true` aos papéis no run, salvo `operator` (R28) |
| `working-rules.md` R27 · `sprint-run.md` | transcript lido pelas três assinaturas: permissão fechada (com a `G15`) · ~600 s de silêncio (vigia) · notificação no mesmo segundo (só registro); sem nenhuma, "causa não identificada" |

**Verificação (R19):** `run-guard-tests.ps1` → 75 casos · 0 falharam (G14 nega comando em segundo plano ao QA, libera ao `operator`) · `release.ps1` → exit 0 (R17: bloco v3.44 ≤ 12800). **Não exercitado:** um run real todo em segundo plano.

### Addendum — 06/10/2026 (v3.44.1): burndown parado até o fim da Task
**Instrução** (stakeholder): item do `note.md` ("o Registro de transições… deveria ficar dentro do `burndown.md`… o burndown parece congelado até o final da tarefa"), aplicado como v3.44.1. **Causa:** a terceira edição do §Marcador (linha na Série) não era conferida — o C1 só lia → ✅ —, a sessão podia gravar o Registro e pular a Série; o `burndown.md` ainda descrevia a granularidade de antes do `run`. **Classificação:** formato de documento · instrumento (C1 R24). **Sem regra nova.**

| Documento | Mudança |
|---|---|
| `templates/burndown.md` · `sprint-backlog.md` | Registro de transições sai do quadro e vive no burndown, ao lado da Série; Evento cita a passagem; texto anterior ao `run` removido |
| R24 · `workflow-sprint.md` §5f · `sprint-run.md` §Marcador · `artifact-ownership.md` §1 · índice | transição = linha no Registro + linha na Série, no mesmo arquivo |
| `close.ps1` · `fix.ps1` · `lib.ps1` | R24 `-Post` exige → 🟦/🟨/🟪 e uma linha da Série por transição; Registro lido do burndown, com recuo ao Sprint Backlog (sprint aberto antes) |

**Verificação (R19):** `run-check-tests.ps1` → 28 casos · 0 falharam (Registro legado lido; Série parada e → 🟨 ausente reprovam o R24). **Não exercitado:** um `sprint run` real gravando no burndown.

### Addendum — 06/10/2026 (v3.44.2): o `guards.log` do primeiro `sprint run`
**Instrução** (stakeholder): "pode corrigir", sobre o `guards.log` do primeiro `sprint run` (v3.42/3.43): 7 linhas `erro` (`IsPathRooted`) e 2 negações da G9 em `Env:`. **Classificação:** instrumento (heurística do `PowerShell` em G5/G8/G9/G14). **Sem regra nova.** `pre-tool.ps1`: alvo com caractere inválido descartado; drive que não é de arquivo fora de G5/G8/G9; G14 libera drive da sessão e nega outro. `COVERAGE.md` alinhado.

**Verificação (R19):** `run-guard-tests.ps1` → 81 casos · 0 falharam; os 6 novos reprovam no código anterior. **Não exercitado:** run real com a v3.44.2. Indicador da fase 2 recomeça aqui (`proposta-guards-fase2.md`).
