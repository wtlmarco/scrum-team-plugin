# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
| [`v3.46`](process-changelog-archive.md) | Plano em contrato conferido antes do dev, prova de falha por mutação, trilha leve por Task, Arquiteto um passo à frente e fechamento pela sessão (SM + Arquiteto + Dev + QA) — 06/10/2026 |
| [`v3.45`](process-changelog-archive.md) | Consumo medido no transcript (G16), R28 por Task e plano em blocos de até 8 arquivos com uma instância de dev por bloco; addendum v3.45.1: verificação uma vez só, amarrada à árvore (SM + Arquiteto + Dev + QA + UX) — 06/10/2026 |
| [`v3.44`](process-changelog-archive.md) | Run sem trava: o Arquiteto decide e não escreve no código (G8 nega), a G14 libera o operacional do run, a G15 registra pedido de permissão; addendum v3.44.1/v3.44.2 (SM + Arquiteto) — 06/10/2026 |
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

## v3.49 — Custo medido nos transcripts: retorno curto à sessão com o relatório do dev em arquivo, Arquiteto novo quando o cache venceu, toque de cache da sessão, gravação por etapa e dev por F-ID no `fix` (SM + Arquiteto + Dev + QA) — 16/10/2026

**Instrução** (stakeholder): "Pode seguir", sobre a classificação dos itens de `note.md` a aplicar antes do benchmark (antigos 1, 2, 11, 13 e 15), com as decisões do formulário de 16/10/2026: retomada → **"Arquiteto novo"**; relatório → **"Retorno curto + arquivo"**. **Condução:** os agentes do time não estavam carregados na sessão que aplicou (plugin instalado em outro diretório de configuração). Por isso a sessão conduziu os cinco passos de `review-contract.md`, respeitando o alcance de cada papel, e aplicou `agents/`, `commands/`, `README.md`, `rituals/`, `hooks/ownership.json` e `scripts/` só pela decisão do stakeholder.
**Causas medidas** nos transcripts do primeiro sprint do piloto (04–13/10, plugin 3.46.0; 758 M tokens, ~US$ 282 em preço de API):
- **A sessão principal** é ~40 % do custo, com 403 mil tokens por chamada; ~37 % do crescimento dela são retornos de agente (estimado).
- **As quebras de cache** custaram ~US$ 96 (34 %), quase todas por expiração. US$ 38 vieram da sessão esperando agente por mais de 1 h, e US$ 22 de 16 retomadas do Arquiteto (Opus, 288 mil tokens) depois de o cache de 5 min vencer.
- **Trabalho perdido em interrupção:** o Arquiteto ficou ~2 h sem gravar o plano, e o QA 5 h 33 min sem gravar a evidência.

**Classificação:**
- fluxo: `sprint-run.md` passos 3–6, §Disparo e §Retomada (nova); `fix-run.md` passos 2–3 e §Bloco;
- regra: a R27 ganha a exceção do Arquiteto, e a R28 ganha o retorno à sessão;
- propriedade: `delivery/` no sprint e `delivery.md` no bloco, dono dev; `architect/breakdown/`;
- formato: o relatório de entrega passa a ser arquivo;
- comportamento de agente.

**Sem regra nova** (34).
**Papéis movidos (R17):** 4 — SM, Arquiteto, Dev, QA → barreira de 15 360 B.

### O que mudou
| Documento | Mudança |
|---|---|
| `working-rules.md` R27 · R28 | R27: o Arquiteto parado há mais de 5 min é aberto em instância nova, que lê o disco. R28: **retorno à sessão** no `run`, em até 15 linhas (estado · arquivo · próximo · execução delegada); o conteúdo fica no artefato e passa pelo caminho; fora do `run`, vale o artefato inteiro |
| `sprint-run.md` | passo 3: relatório em `sprints/<n>/delivery/<T-ID>.md`; passo 4: GAP ao Arquiteto pelo caminho (o mesmo se parou há menos de 5 min, senão um novo); §Retomada; §Disparo: retorno curto e **toque de cache** (`CronCreate` `17,47 * * * *` junto com o `.active-run`, fora do benchmark, em avaliação); Como o SM verifica |
| `fix-run.md` | dev **uma instância por F-ID**, com o `.active-task` da F-ID; relatório em `fixes/B-<nnn>/delivery.md`; GAP a Arquiteto novo; N + 2 invocações por bloco |
| README do Arquiteto · `workflow-sprint.md` Planning 4 | plano gravado seção a seção; quebra em Tasks em `architect/breakdown/S<n>.md` a cada História; `/arc question` em instância nova lê só o plano, o GAP e o código citado |
| README do QA | evidência aberta no passo 1 e gravada frente a frente; retorno curto |
| `delivery-report.md` · `gap.md` · README do dev | onde fica o relatório; seções acrescentadas no fim; o GAP no mesmo arquivo; na calibração, o relatório continua na resposta |
| `artifact-ownership.md` §1 · §1e · `hooks/ownership.json` · `deliverables/team-project/README.md` | linhas novas para os relatórios de entrega e o `delivery.md` do bloco (dono dev; escritores dev e Arquiteto executor); `architect/breakdown/`; `scripts/metrics/` junto de `hooks/`; cinco donos na pasta do sprint |
| Pela decisão do stakeholder | `agents/*` (retorno curto; o dev grava o relatório; o QA lê o arquivo; o Arquiteto em instância nova) · `commands/dev.md` · `README.md` (tipos de documento) · `team-update.md` 7j · `scripts/metrics/` (novo) · 5 casos novos da G8 · `note.md` renumerado |

### Por quê
O registro do time media o volume dos subagentes. Medido em US$ e com a sessão incluída, o custo está na sessão (40 %) e no Arquiteto (38 %); o dev em Haiku é ~5 %. Dois mecanismos explicam a maior parte:
- **O que volta inteiro para a sessão é relido em cada chamada seguinte dela.** Os papéis já gravavam o artefato (plano, evidência); faltava o relatório do dev, que só existia na resposta. Com ele em arquivo, a sessão passa caminhos.
- **O cache que vence durante a espera é regravado inteiro.** Para o Arquiteto, as duas formas de manter o cache vivo foram medidas e descartadas. O cache de 1 h para subagentes (`CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL`, documentado no Claude Code), simulado no mesmo sprint, sairia US$ 5,6 **mais caro**: toda gravação passa a 2×, e as retomadas caras vieram depois de mais de 1 h. O toque, por sua vez, não alcança subagente. Na sessão, o toque compensa: as esperas de 1 a 4 h custaram US$ 27,8 regravando, contra ~US$ 5 com um toque a cada 30 min.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Dev | grava o relatório de entrega (e o GAP) em arquivo e devolve o retorno curto; no fix, uma instância por F-ID |
| Arquiteto | grava o plano e a quebra por etapa; numa instância nova, lê só o plano, o GAP e o código citado |
| QA | lê o relatório do arquivo; grava a evidência frente a frente; retorno curto |
| Sessão / SM | passa caminhos, não conteúdo; decide entre a mesma instância e uma nova pelo tempo parado; cria e apaga o toque junto com o `.active-run` |

### Conflitos com o processo vigente
- **R27 e o passo 4 do `sprint-run.md`** mandavam sempre retomar o mesmo agente por `SendMessage`. Levado ao stakeholder (formulário de 16/10/2026): só a retomada do Arquiteto muda, decidida pelo tempo parado.
- **O README** classificava o relatório de entrega como "saída". Reclassificado como vivo, pela mesma decisão.

### Como saberemos que funcionou
No próximo sprint real, medido com `scripts/metrics/transcript-metrics.js` contra o sprint 1 do piloto, **mecanismo por mecanismo**:
- retornos de agente em até 15 % do crescimento da sessão (`growth --session`; eram ~37 %);
- regravação do Arquiteto depois de devolver em até US$ 5 (`breaks`; eram US$ 22, em 16 retomadas), sem subir o número de GAPs por plano;
- regravação da sessão por pausa de mais de 1 h com agente rodando em até US$ 10 (eram US$ 38), e nenhum toque em que a sessão trabalhou;
- nenhuma interrupção que descarte plano ou veredito parcial.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | `Select-String` em todo `*.md` fora dos changelogs: `uma F-ID por vez` · `quatro donos diferentes` · `três subpastas de outros donos` · a linha "Saída" antiga do README | zero ocorrências | ✅ |
| Leitura no contexto | `delivery/` e `delivery.md` (27 ocorrências em 16 arquivos) e `§Retomada` (8 em 6), lidos um a um | caminho, dono e seção coerentes em cada ocorrência; a pasta do sprint passa a ter cinco donos e quatro subpastas de outros donos | ✅ |
| Arquivamento de entrada | o bloco v3.46 que saiu do vivo × o que entrou no arquivo (`.Contains`) | idêntico; `git diff --stat`: −44 no vivo, +45 no arquivo (o separador) | ✅ |
| Guardas | `run-guard-tests.ps1` | 166 casos · 0 falharam (5 novos da G8: dev em `delivery/` e em `delivery.md` do bloco liberados; QA em `delivery/` e dev em `plan.md` do bloco negados; Arquiteto em `breakdown/` liberado) | ✅ |
| Conferências | `run-check-tests.ps1` | 91 casos · 0 falharam | ✅ |
| Medição | `transcript-metrics.js cost · breaks · session · waits · growth` sobre o piloto | reproduz os números da análise (US$ 282,3; quebras US$ 95,7; sessão com 697 chamadas e 403 mil por chamada; plano com 18 % do crescimento) | ✅ |

**Não exercitado:** um `sprint run` real com retorno curto, instância nova do Arquiteto e o toque (o `CronCreate` disparando durante a espera da notificação). O ensaio do benchmark roda em primeiro plano, onde o toque não dispara.

### Pendente do stakeholder
Propostas com especificação, sem texto aplicado:
- **G19 (nova):** `PreToolUse · SendMessage` na sessão. Nega o `SendMessage` a uma instância de `team:architect` cuja última rodada no `usage.jsonl` terminou há mais de 5 min, com a rota "instância nova — `sprint-run.md` §Retomada". É o instrumento da exceção da R27.
- **G16:** gravar o tamanho da resposta final (linhas e bytes) no `usage.jsonl`. É o instrumento do retorno curto (R28).
- **Itens 3, 4 e 5 de `note.md`** (scripts e hooks): o marcador por script; o preparo do disparo num passo só; a sessão no registro do time pelo `transcript_path`. Os itens de consumo entraram no addendum abaixo.

Depois de mesclar: atualizar o plugin no piloto e no benchmark, `/team update` (7j), reiniciar a sessão.

### Addendum — o registro de consumo que fecha, atualizado pelo hook, com o modelo servido (16/10/2026)
**Instrução** (stakeholder): "Vamos seguir na opção 1": itens 1, 6 e 10 da fila, e a investigação do item 9. **Causa:** no piloto, os Totais diziam 100 invocações contra 137 linhas no Registro, e o fechamento os corrigiu à mão. Havia uma linha de `operator` sem chamador, o SM aparecia com 0 processado (só tinha a notificação), e "haiku" juntava Haiku 4.5 e 5.5, com preço por token ~10× diferente. A sessão rodou `consumption.ps1` 33 vezes e editou o `consumption.md` à mão 20 vezes, a ~400 mil tokens por chamada.
**Classificação:** instrumento (`consumption.ps1`, G16) · formato (`templates/consumption.md`, `plugin-report.md`, `retrospective.md`). **Sem regra nova.**

| Documento | Mudança |
|---|---|
| `scripts/checks/consumption.ps1` | modelo servido com versão (`haiku 4.5`); Totais com uma linha por papel e modelo, **Instâncias** e **Rodadas** em colunas separadas, e `não medido — só notificação` no grupo sem medida; `operator` sem filho na linha do pai ganha o chamador pela rodada de outro papel, na mesma Task, que contém o início dele (`chamado por <papel> (pelo horário)`) |
| `hooks/subagent-stop.ps1` (G16) | roda o `consumption.ps1` no destino ao fim de cada rodada, no mesmo processo e com a saída fora do harness; uma falha vira linha `G16 · consumo` |
| `templates/consumption.md` · `plugin-report.md` · `retrospective.md` · `sprint-run.md` §Disparo · `how-to.md` · `COVERAGE.md` · `team-update.md` 7j | a sessão só roda o script antes de uma conferência; colunas e modelo novos; corrigida uma linha de regra colada à anterior no modelo do consumo |
| `scripts/metrics/transcript-metrics.js` | descarta evento repetido (mesmo `uuid`): a "parada de 68 h" do piloto era uma linha regravada antes de uma compactação; `waits` cai de ~206 h para ~137 h, e custo e quebras não mudam |
| `note.md` | saem os itens de consumo; o item das paradas é reescrito com a investigação: ~24,5 h fora do contrato, ~122 h de máquina suspensa com agentes rodando, ~6,8 h de decisão legítima do stakeholder |

**Verificação (R19):** `run-check-tests.ps1` → 93 · 0 (2 novos: Totais com instâncias × rodadas e o modelo com versão; chamador pelo horário); `run-guard-tests.ps1` → 167 · 0 (1 novo: a G16 grava a linha medida no `consumption.md` do sprint aberto); `release.ps1` ok. **Não exercitado:** a G16 rodando o script num sprint real, e duas rodadas terminando no mesmo instante (as duas reescrevem a partir do `usage.jsonl`, e a última vence com os dados completos).

---

## v3.48 — O que o primeiro sprint do piloto mostrou: relatório do `operator` gravado pelo hook, guardas sem falha aberta nem falso negado, C1 que fecha o que é legítimo (SM + Arquiteto + Dev + QA) — 14/10/2026

**Instrução** (stakeholder): "Pode aplicar", sobre `avaliacao-first-result.md` — grupos A (fechamento) e B (guardas). Base: `first-result/plugin-report.md` (relatório do SM do piloto, plugin 3.46.0 instalado), `first-result/guards.log` (04 a 13/10/2026, 4 821 linhas) e o `guards.json` do projeto; os comandos negados foram **reexecutados contra o hook da v3.47.1** antes da correção. **Causas medidas:** 9 edições do dev sem G6/G8/G9 (`.active-task` não JSON derrubava o hook — falha aberta); 6 falsos negados na G8/G9 (`>` dentro de texto lido como destino); ≥ 19 na G14 (caminho entre aspas virava `""`, conferência com `2>&1`, `Get-Process`, `npm --prefix`, `[Math]::`); C1 com R26/R28 `falhou` em toda Task com `operator` (o harness recusa relatório gravado por subagente), sem lugar para a decisão do stakeholder na R4, lendo só o bloco mais novo da evidência (R7) e com o `-Apply` saindo com exit 2 no quadro anterior à v3.44.1.
**Classificação:** instrumento (G9, G11, G14, G15, G16, `Get-WriteTargets`, C1, `plan.ps1`) · formato de documento (Sprint Backlog: coluna "Decisão do stakeholder"; plano: regra 16) · comportamento de agente (`operator`: relatório em texto, pasta do job citada). **Sem regra nova** (34): R28 muda quem grava o `report`; R4 ganha o registro da exceção decidida.
**Papéis movidos (R17):** 4 — SM, Arquiteto, Dev (via `operator`/guardas), QA.

### O que mudou
| Documento | Mudança |
|---|---|
| `hooks/pre-tool.ps1` | G9 nega com `.active-task` ilegível; `Get-WriteTargets` mascara texto entre aspas e resolve variável atribuída a literal no mesmo comando; G14 restaura o texto entre aspas para ler o destino, aceita conferência com `2>&1` ou `Out-String` no fim, `Get-Process`, `npm --prefix`, método estático de leitura, confere destino de `*>`, mensagens próprias para `Start-Sleep` e `robocopy`; G11 só no segmento `<n>`/`pre-sprint`/`B-nnn` |
| `hooks/subagent-stop.ps1` (G16) | rodada do `operator` grava a última resposta como `report.md` (ou `report-<agente>-r<rodada>.md`) na pasta do job citada; campo `report` no `usage.jsonl` |
| `hooks/notification.ps1` · `hooks/common.ps1` | G15 ignora o `AskUserQuestion`; `guards.log` com alvo numa linha |
| `scripts/checks/close.ps1` (C1) | R28 conta todo `report*.md` das pastas citadas; R7/R12/R4/R30 leem a última rodada **com** veredito; R4 aceita "Decisão do stakeholder" datada; `-Apply` grava o Registro no `sprint-backlog.md` quando o burndown não o tem |
| `scripts/checks/plan.ps1` | linha `dono`: arquivo de outro papel (matriz) ou de gate na lista reprova o plano |
| `agents/operator.md` · R28 (`working-rules.md`) · `templates/consumption.md` | o relatório é a resposta; o hook grava; a resposta cita a pasta do job |
| `templates/sprint-backlog.md` · `implementation-plan.md` regra 16 · `sprint-run.md` passo 3 · `team-update.md` 7i · `COVERAGE.md` | coluna nova; arquivo de outro papel fora da lista; `.active-task` é JSON; migração do Registro e do `testRoot`; cobertura v3.48 |

### Por quê
A proposta das guardas pedia dois sprints sem linha `erro` e com até um falso positivo por guarda; o piloto reprovou as duas, e a G12 não pode entrar enquanto o C1 diverge do fechamento legítimo. O caso mais grave não aparecia no relatório do SM: a falha aberta é silenciosa por desenho (D5) e só o `guards.log` a mostra. A regra que fica: dado ruim do projeto decide (nega com a rota); só defeito do hook falha aberto. O `report` do `operator` passa ao hook porque a recusa é do harness — contorná-la pelo shell burlaria a recusa; gravar a resposta depois que ela existe não.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| `operator` | não grava `report.md`; devolve o relatório em texto, citando a pasta do job |
| Arquiteto | `**Arquivos tocados:**` só com arquivo do executor (o `plan.ps1` reprova o resto) |
| SM / sessão | `.active-task` em JSON; entrada fora da Planning com "o que saiu" **ou** "Decisão do stakeholder" datada |
| QA | revisão/nota acima da rodada não esconde mais o veredito |

### Verificação (R19)
`run-guard-tests.ps1` → **161** casos · 0 falharam (21 novos); `run-check-tests.ps1` → **89** · 0 (8 novos). Replay do `guards.log` do piloto contra o hook novo: os falsos negados reproduzíveis passam; o que segue negado são comandos que o log truncou em 120 caracteres (aspas sem fechar), `Start-Sleep` (com a rota nova), `robocopy`, script `.ps1` do scratchpad e `run_in_background` — negações corretas. **Não exercitado:** um `sprint run` real; se o `SubagentStop` traz a resposta final do `operator` no transcript antes do hook rodar (a suíte usa transcript montado).

### Pendente do stakeholder
Grupo C da avaliação (retomada por `SendMessage` com contexto grande, Totais do consumo por instância, onde gravar a quebra em Tasks, prova de UI com render real) vai pelo `/review` — registrado como sintoma em `note.md`, itens 1 a 5. A contagem dos 2 sprints do indicador da fase 2 e da condição da G12 recomeça com esta versão instalada no piloto.

### Addendum v3.48.1 — `verify.testItem`: o teste focado em runner que recebe classe (14/10/2026)
**Instrução** (stakeholder): "atualize o necessário para iniciarmos o teste de benchmark". **Causa:** os três projetos-padrão do benchmark são Android/Gradle; o `verify.ps1` troca `{tests}` pelos **caminhos** dos arquivos de teste, e o `--tests` do Gradle espera **classe** — o `focused`, a linha de base e toda mutação dariam "No tests found" (`inconclusivo`), e o C1 não fecharia nenhuma Task com `**Mutações:**`.
**Classificação:** instrumento (`verify.ps1`) · formato (`guards.json` → `verify.testItem`). **Sem regra nova.**

| Documento | Mudança |
|---|---|
| `scripts/checks/verify.ps1` | `testItem`: molde por teste com `{path}` (padrão) e `{class}` (`src/<conjunto>/java\|kotlin\|scala\|groovy/…` → nome qualificado; fora disso, o nome do arquivo) |
| `deliverables/team-project/guards.json` · `team-update.md` 7h | chave opcional documentada, com o exemplo do Gradle |

**Verificação (R19):** `run-check-tests.ps1` → 91 · 0 (2 novos: Gradle com `testRoot` + `--tests {class}`; `{path}::{class}` fora do padrão `src/`); `run-guard-tests.ps1` → 161 · 0. **Não exercitado:** um Gradle real — o ensaio do P é o primeiro.

---

## v3.47 — Modelo por papel (G17), perfil Arquiteto executor, modo benchmark (G18) e ritual "modo projeto": o plugin pronto para o experimento sem intervenção (SM + Arquiteto + QA + Dev) — 10/10/2026

**Instrução** (stakeholder): "já habilite esse chaveamento configurável pelo `models.json` sendo possível para todas as rules" (M1, generalizada a todos os papéis) e, depois, "pode executar [M2, M3 e M4] sobre a branch 3.47.0 como um novo commit" — sobre `proposta-benchmark-projeto.md` (§9, §13). **Causa:** o modelo de cada papel estava fixo no `model:` de `agents/<papel>.md` e em duas exceções do processo; o experimento de benchmark em modo projeto exige três coisas que o plugin não tinha — variar o papel que implementa (P2), responder os formulários sem o stakeholder e tratar a navegação do protótipo como simulada — e um roteiro para o conjunto.
**Classificação:** instrumento (G17 e G18 no `pre-tool.ps1`, `models.ps1`, C2) · formato (`models.json`, `.active-executor`, `guards.json` → `bench`) · fluxo (`sprint-run.md` §Modelo por papel, §Modo benchmark, passos 3, 4 e 8) · comportamento de agente (`/arc execute`) · ritual (`benchmark.md` §7). **Sem regra nova** (34).
**Papéis movidos (R17):** 4 — SM, Arquiteto, QA, Dev → barreira de 15 360 B.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `.team-project/models.json` (novo, opcional, **do stakeholder**) | — | chave = papel ou apelido do comando; valor `opus` `sonnet` `haiku` `fable`; `""` = não configurado; **chave ligada vence o agente e as exceções** (trilha leve, 3ª instância); `executor` liga o perfil Arquiteto executor |
| `hooks/pre-tool.ps1` · `common.ps1` | **G17** | nega o disparo pela ferramenta `Agent` cujo modelo efetivo difere do `models.json`; sessão e `operator` disparado por papel; arquivo ilegível ou valor inválido → ignorado |
| `hooks/pre-tool.ps1` | **perfil executor (M2)** | `models.json` → `executor: architect` **e** `.active-executor`: a **G8** libera o código ao Arquiteto, a **G9** o limita aos arquivos do plano (rota "corrija o plano"), a **G6** veta teste ignorado; marcador sem perfil é ignorado |
| `hooks/pre-tool.ps1` | **G18 (M3)** | `guards.json` → `bench`: o `AskUserQuestion` é **negado com a resposta do dossiê** (`answers`: regex pergunta → regex rótulo; sem regra, a recomendada; nunca "Pedir mais contexto"), `questions.log` por braço, e `foreground` nega `Agent` em segundo plano |
| `scripts/checks/project.ps1` (C2) | R15 | "navegação simulada (benchmark)" aceita **só com `bench` ligado**; fora dele, falha |
| `scripts/checks/models.ps1` (novo) | `-Role` · `-Check` · tabela | modelo configurado, validação e efetivo dos 7 papéis, com o estado do perfil executor |
| `agents/architect.md` · `roles/architect/README.md` | `/arc execute <ID>` | o Arquiteto implementa o próprio plano: contrato do dev, plano errado se corrige (linha em `**Plano corrigido durante a execução:**`), mudança funcional continua subindo, sem planejar a Task seguinte |
| `sprint-run.md` | §Modelo por papel · §Modo benchmark · passos 3, 4, 8 · pré-condição 1 | despacho por `models.json`; perfil executor no passo 3; apagar `.active-executor` na saída da Task; "navegação simulada" vale com `bench` |
| `rituals/benchmark.md` §7 · `templates/benchmark.md` | modo projeto | projeto-padrão, braços P · N · N-forte, escopo de 1 sprint + `fix`, oráculo oculto, rubrica de documentação, sonda de manutenibilidade, regra datada, laço de melhoria, modelo do `result.md` |
| `artifact-ownership.md` §1 · `ownership.json` · manifesto · `how-to.md` · `COVERAGE.md` | linhas novas | `models.json` (stakeholder); `.active-executor` com `.active-run`/`.active-spike`; G17, G18 e o perfil executor |

**Verificação (R19):** `run-guard-tests.ps1` → 132 casos · 0 falharam (47 novos desde a v3.46: G17, perfil executor, G18); `run-check-tests.ps1` → 74 casos · 0 falharam (22 novos: `models.ps1`, C2). **Não exercitado:** um `sprint run` real com qualquer das três configurações sob `claude -p`; se o harness lê a negação do `AskUserQuestion` como resposta — o ensaio do P0 é o primeiro teste real.

### Addendum v3.47.1 — prova de falha que só conta com o teste rodando, mutação em fatias, G14 sem falso negado (12/10/2026)
**Instrução** (stakeholder): "Sim faça" — itens 1 a 3 da avaliação de `relatorio-processo-sprint-1-parte-2.md` (projeto-piloto, 07 a 12/10). **Causa:** `verify.ps1` contava como mutação pega **todo** exit ≠ 0 — mutante que não compila, `Executed 0 of 0`, navegador desconectado (T-012 fechada com prova inválida e reaberta); a mutação inteira (~25 min) numa chamada estourava o vigia de 600 s; a G14 cortava `(Get-Content f).Count` nos parênteses e negava o `.Count` como comando — a forma que o próprio card do `operator` manda usar —, e a mensagem não dizia qual trecho do comando composto falhou (🔺 GAP indevido).
**Classificação:** instrumento (`verify.ps1`, `plan.ps1`, G14) · formato (`guards.json` → `verify.testRoot`, `inconclusive`, `caught`) · comportamento de agente (dev, QA: exit 3 e `inconclusivo`). **Sem regra nova.**

| Documento | Mudança |
|---|---|
| `scripts/checks/verify.ps1` | **linha de base** por teste (sem mutação: passa e executa teste) · `inconclusivo` com compilação quebrada, zero teste ou runner caído (padrões embutidos + `inconclusive`; `caught` opcional) · trecho vazio não estoura · **`-MaxMinutes`** (padrão 8) → exit 3, a chamada seguinte na mesma árvore continua · `-Tests`/`-Only` em lista por vírgula (`powershell -File`) · `testRoot` |
| `scripts/checks/plan.ps1` | trecho de mutação vazio (crase dupla) reprova |
| `hooks/pre-tool.ps1` (G14) | propriedade entre parênteses liberada, método negado · `git branch` só de listagem · `--version` · a negação cita o trecho recusado |
| `agents/developer.md` · `agents/quality-assurance.md` · `sprint-run.md` passo 3 · modelo do plano (regra 18) · `team-update.md` 7h · modelo do `guards.json` · `COVERAGE.md` | exit 3 = rodar de novo; `inconclusivo` não é pega; mutante tem de compilar; chaves opcionais |

**Verificação (R19):** `run-check-tests.ps1` → 81 casos · 0 falharam (7 novos); `run-guard-tests.ps1` → 140 · 0 (8 novos). **Fora deste addendum:** o `report.md` do `operator` — o harness recusa a subagente gravar relatório ("Subagents should return findings as text, not write report files", testado em 12/10), e contornar pelo shell seria burlar a recusa; o contrato da R28 muda em entrega própria.
