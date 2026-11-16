# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
| [`v3.58`](process-changelog-archive.md) | Security Engineer: pentest e secure code review sob demanda, com o laço que leva o achado ao standard do Arquiteto (SM + Arquiteto + Security Engineer) — 12/11/2026 · *com addendum v3.58.3* |
| [`v3.57`](process-changelog-archive.md) | O sprint real: protocolo de espera, sessão medida e reiniciada pelo teto, suíte só pelo verify, Arquiteto com contexto enxuto e o que o sprint 5 do garden não tinha onde pôr (SM + Arquiteto + Dev + QA) — 07/11/2026 · *com addenda v3.57.1 a v3.57.3* |
| [`v3.56`](process-changelog-archive.md) | A lição de cada GAP no lugar certo: origem e destino na decisão, conhecimento do projeto que atravessa sprints, armadilhas da stack e o SM atualizando o lado do projeto no fechamento (SM + Arquiteto + Dev + QA) — 06/11/2026 |
| [`v3.55`](process-changelog-archive.md) | Fechamento da margem, verificador por caminho e padrão de ids de teste (SM + Arquiteto + Dev + QA) — 05/11/2026 |
| [`v3.54`](process-changelog-archive.md) | Mutação pela regra e margem do dev: o Arquiteto diz o que provar, o dev escreve o trecho e corrige o defeito do próprio teste, com travas no fechamento (SM + Arquiteto + Dev + QA) — 04/11/2026 · *com addenda v3.54.1 e v3.54.2* |
| [`v3.53`](process-changelog-archive.md) | Plano pela ficha: a quebra em Tasks traz a ficha de cada Task, um Arquiteto por Task e o template do plano só com o operativo (SM + Arquiteto + Dev + QA) — 28/10/2026 · *com addenda v3.53.1 a v3.53.7* |
| [`v3.52`](process-changelog-archive.md) | Orquestrador enxuto: sessão nova por ritual, `run` em sessões curtas, espera sem sondagem, registro de decisões e commit por Task (SM) — 23/10/2026 |
| [`v3.51`](process-changelog-archive.md) | O sprint do benchmark: dev constrói e verifica sozinho, plano por História ao lado dos cenários, portão do QA no fim, orquestração por script, contexto e cache, ambiente em qualquer tecnologia (SM + Arquiteto + Dev + QA + PO) — 21/10/2026 |
| [`v3.50`](process-changelog-archive.md) | Mudança de layout se prova em render real: navegador headless, 3 fontes × telas, mutação que quebra a medição; addendum: as paradas do `run` fecham no texto (SM + Arquiteto + Dev + QA) — 16/10/2026 |
| [`v3.49`](process-changelog-archive.md) | Custo medido nos transcripts: retorno curto à sessão com o relatório do dev em arquivo, Arquiteto novo quando o cache venceu, toque de cache da sessão, gravação por etapa e dev por F-ID no `fix` (SM + Arquiteto + Dev + QA) — 16/10/2026 |
| [`v3.48`](process-changelog-archive.md) | O que o primeiro sprint do piloto mostrou: relatório do `operator` gravado pelo hook, guardas sem falha aberta nem falso negado, C1 que fecha o que é legítimo; addendum v3.48.1: `verify.testItem` (SM + Arquiteto + Dev + QA) — 14/10/2026 |
| [`v3.47`](process-changelog-archive.md) | Modelo por papel (G17), perfil Arquiteto executor, modo benchmark (G18) e ritual "modo projeto": o plugin pronto para o experimento sem intervenção (SM + Arquiteto + QA + Dev) — 10/10/2026 · *com addendum v3.47.1 de 12/10/2026* |
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

## v3.61 — Sprint 0: o backlog funcional abre sobre documentação conforme e ambiente de testes provado — o onboarding pergunta onde está a documentação e decide o sprint 0 (SM + PO + Arquiteto + QA) — 16/11/2026

**Instrução:** (stakeholder, 16/11/2026, depois de perguntar como usar QA, Sec, Arquiteto e PO em tarefas avulsas) "Não poderíamos considerar o processo de onboarding o questionamento da onde está a documentação, se não existir propor criá-la disparando uma atividade de sprint 0 para isso com a criação da documentação e do ambiente de testes, se existir o sprint 0 irá revisá-la e adequá-la aos pontos de boas práticas de qualidade tanto arquitetural quanto funcional e somente assim iniciar um backlog funcional. Avalie."; avaliação com cinco ajustes aceita: "Sim, implemente a v3.61.0 numa branch feat".
**Medido (garden, sprints 4–6):** 84% do custo do plano no S6 veio antes da primeira escrita — exploração do código que a documentação não respondia; as paradas do S6 por ambiente (emulador, Docker, prova no aparelho) aconteceram no meio do run, com Task em construção. No onboarding, documentação funcional ausente ia ao `brainstorm`, que descobre o que construir, não o que existe; a documentação técnica e o ambiente de testes não eram conferidos.
**Classificação:** regra (R35; R14 ajustada) · cerimônia (sprint 0: `plan`, `run`, `review`, `area`) · formato de documento (quadro do sprint 0, conformidade do QA, plano de ambiente) · instrumento (`foundation.ps1`; G25; C2 R35)

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `working-rules.md` · `working-rules-index.md` | R14 · R35 (nova) · Resumo | o onboarding decide o sprint 0; R35: SDD `00`–`06` nos modelos, conferido pelo QA contra o código, e ambiente provado antes do primeiro `prepare`; dispensa só pelo stakeholder |
| `workflow-sprint0.md` (novo) | — | `plan` (assess → init → formulário do escopo → approve), `run` (laço `foundation.ps1 next`), `review` (formulário único → close), `area` |
| `workflow-ritos.md` | §5a passo 3 · condição de saída · rastreio de pendências | "onde está a documentação, e ela serve?": tabela do `assess` e rota; projeto com código vai ao sprint 0, sem código ao brainstorm |
| `workflow-sprint.md` | prepare, passo 1 | a candidata cai numa área documentada; o requisito aceito no sprint 0 vale como ① e ② |
| `templates/foundation.md` · `quality-assurance/templates/conformance.md` · `architect/templates/foundation-env-plan.md` (novos) | — | o quadro, a conformidade por documento (régua + amostra `arquivo:linha` + verificabilidade) e o plano de ambiente com o `guards.json` proposto |
| `templates/project-context.md` · `deliverables/team-project/README.md` · `artifact-ownership.md` §1e | §2 · §8 · A pasta do sprint 0 | a linha `Sprint 0 (fundação)`; as sequências de início; `sprints/0/` e os donos |
| `team-update.md` | 7n (novo) | projeto em andamento não ganha a linha: adotar é `/sm sprint0 plan` |

### Por quê
O backlog nascia sobre documentação que ninguém tinha conferido contra o código: o QA sem requisito verificável para escrever cenário, o Arquiteto pagando a exploração a cada plano, o sprint parando por ambiente que devia estar pronto antes da primeira Task. Os cinco ajustes da avaliação seguram o outro extremo: **liberar por área** (o transversal e a 1ª onda, o resto quando o backlog chegar — `area`), **régua verificável** (os modelos do SDD, não "boas práticas" em aberto), **documentar como é** (má prática vira dívida no backlog, o sprint 0 não refatora), **ambiente com condição de pronto objetiva** (`verify`, `run.prereqs`, baseline, um cenário no alvo) e **mecânica própria** — o executor de Task só dispara dev e a G8 não deixa o dev escrever o SDD, então o sprint 0 tem quadro e script próprios, fora do índice "Sprint corrente".

### Conflitos com o processo vigente
R14 dizia "documentação funcional ausente aciona o brainstorm": vale agora só para projeto sem código. R15 cobra o ① antes do `03`–`05`: o documento aceito no sprint 0 fica fora (o C2 o isenta pela data do aceite). A v3.34 (parte 2) recusou um "sprint 0" para o plano de calibração (quebraria o índice do sprint corrente): este não entra no índice. R20 (Task sob História) não se aplica: o quadro do sprint 0 é de itens `S0-nn`, sem Task de entrega.

### Como saberemos que funcionou
No próximo projeto que fizer o onboarding: o sprint 0 fecha com até 2 devoluções por item; o 1º sprint funcional não para por ambiente; o custo de exploração do plano (antes do 1º `Write`) cai abaixo de 50% (era 84% no S6 do garden). Sprint 0 com mais de 3 itens 🔴, ou mais longo que o 1º sprint funcional, volta ao `/review`.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.58 que saiu do vivo × arquivo (`.Contains`) | True; o vivo fica com v3.61, v3.60, v3.59 | ✅ |
| Entrega | `release.ps1` (C3); `run-check-tests.ps1`; `run-guard-tests.ps1` | ver CHANGELOG v3.61.0 | ✅ |

### Parte mecânica (implementada pela sessão principal, citada aqui)
`foundation.ps1` (novo): `assess`, `init`, `approve`, `next`, `check [-Item]`, `area`, `close`, `dispense`, `gate`. `prompt-submit.ps1`: G25 bloqueia `/sm sprint prepare|plan` com o sprint 0 exigido e não concluído; G21 conhece `sm sprint0 <modo>`. `project.ps1`: R35 e a isenção da R15. `commands/sm.md`: modo `sprint0` e pré-condições.

### Pendente do stakeholder
Nada.

---

## v3.60 — A ficha leva os trechos (o Arquiteto do plano lê uma vez e escreve) e o kanban acompanha o prazo: previsão por parte, farol e burndown visual, com o registro técnico no consumo (SM + Arquiteto) — 15/11/2026 · *com addendum v3.60.1*

**Instrução:** (stakeholder, 14–15/11/2026, sobre a H-M do garden dividida em 3 Tasks) "Não seria melhor o Desenvolvedor Haiku receber as 3 tarefas de uma mesma vez"; depois "avalie talvez a possibilidade de em somente uma interação com o Arquiteto ele já gerar os 3 planos sem precisar reler tudo de novo … assim mantemos o benefício da divisão menor para evitar os erros do Haiku e otimizamos o Arquiteto", "consegue fazer uma simulação para ver qual seria o modo mais otimizado" e "pode implementar essa melhoria em uma branch feat". A divisão para o dev fica como está.
**Medido (sprint 6 do garden, H-M, plugin 3.58.2):** os 3 planos (T-092 a T-094) custaram US$ 9,02 em 125 chamadas; 111 delas e 84 % do custo foram exploração antes do primeiro `Write` (~75 buscas, leituras em pedaços — o `migracoes.spec.ts` foi aberto 7 vezes). O que os 3 leram em comum era pouco (template, `context.md`, `.scn`); o template, ~35 mil caracteres, era lido inteiro na 1ª chamada e reenviado em todas as outras. A ficha apontava 4 arquivos; o plano leu ~11. O breakdown do S6 já trazia as linhas medidas na Planning.
**Simulação** (calibrada nas 3 conversas: reconstrói US$ 8,95 dos 9,02): um Arquiteto para a História, explorando, US$ 13,57; o atual com o template enxuto, 8,05; um por Task com os trechos no recorte e o guia, 4,37 a 6,85 (base 5,67); um para a História com os trechos, 5,24 a 9,28, com contexto acima de 260 mil.
**Classificação:** formato (ficha com faixa `caminho:a-b` e seção `§`; recorte com os trechos e o guia de escrita) · comportamento de agente (o Arquiteto do plano abre a ficha e o `context.md` numa chamada, não abre o template inteiro e pede o que faltar numa chamada só)

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `templates/breakdown.md` | abertura · regras 2, 3 e 6 | a ficha aponta a faixa que o plano usa (`caminho:a-b`, `:c-d` na mesma linha) e a seção da fonte (`§2.5`, `§2–§7`, `§"título"`); quem copia é o script; faixa fora do arquivo se corrige antes do plano |
| `templates/implementation-plan.md` | regra 28 | o recorte traz os trechos, o resumo da dependência e o guia; a regra inteira só pela linha que o guia dá; o que faltar, numa chamada |
| `agents/architect.md` · `roles/architect/README.md` | Plano pela ficha · Preparo · Ficha por Task | a abertura nova; a medição e a simulação |
| `workflow-sprint.md` | Planning, passo 4 | código com faixa, fontes com seção |
| `sprint-run.md` | Como o SM verifica · O que fica onde · Marcador | indicador da v3.60; a Série e o Registro no `consumption.md`, sob a trava dele |
| `working-rules.md` (R24) · `artifact-ownership.md` · `workflow-sprint.md` §5f | — | a Série e o Registro no `consumption.md` do sprint; o Burndown visual no `kanban.md` |
| `templates/kanban.md` · `templates/consumption.md` | estrutura e §Como preencher | o Kanban com a previsão, a seção Burndown e as regras do prazo; as quatro seções técnicas no consumo |

### Por quê
O custo de uma instância é chamadas × contexto: cada chamada reenvia a conversa inteira. A exploração do plano refazia a busca que a Planning já tinha feito. Juntar os planos numa instância não resolve: o que se poupa (prompt e template uma vez) é menor que carregar a exploração da Task anterior em todas as chamadas da seguinte — foi o H-K1 do sprint 4 (US$ 16,3) que levou à v3.53. Trazer os trechos prontos tira as chamadas sem crescer a instância, e o dev continua recebendo Task de até 6 arquivos.

**As linhas andam com o código** (stakeholder, 15/11: "uma tarefa pode modificar o código e assim as referências irão quebrar"): a ficha é da Planning, e no garden 6 de 60 faixas tinham andado até o plano (`migracoes.ts:1131`, 80 linhas). O `run.ps1 next` traduz a faixa pelo `git diff` desde o início do sprint (ou desde a correção da ficha), copia no lugar novo, diz quanto andou e por qual Task, e marca ⚠ quando o próprio trecho mudou. A seção (`§`) se acha pelo título. O pacote do plano externo recebe os mesmos trechos, e o roteiro dele (`external-plan.md`) passa a mandar citar as linhas de hoje, não as da ficha.

**Acompanhamento** (stakeholder, 15/11: "passar do Kanban para consumption: Série, Registro de Transições, Rodada a Rodada, Espera de Comando"; "estimativa de tempo de cada tarefa … do Sprint e um farol No Prazo, Atrasado e adiantado"; "um gráfico Burndown visual"): as quatro seções técnicas vão ao `consumption.md` (R24 passa a apontar para lá; a Série nasce no `kanban.md` na Planning e o `kanban.ps1` a leva no run); o `kanban.md` ganha a previsão de cada parte pelo ritmo medido no sprint, a linha **Prazo** com o farol no Resumo e a seção **Burndown** (gráfico Mermaid e tabela). Prazo: fim da Janela · duração do sprint · a estimativa em dias.

### Conflitos com o processo vigente
Nenhum com regra. A ficha continua só apontando (regra 1 do breakdown). R24 muda o arquivo, não a regra: uma transição continua sendo uma linha no Registro e uma na Série, no mesmo arquivo e no mesmo momento. O template continua a única fonte do formato: o guia é gerado dele a cada recorte, e sem as marcas de forma o prompt volta a mandar abrir o template. Ficha antiga, com `caminho:linha`, segue valendo, com janela de 40 linhas.

### Como saberemos que funcionou
Sprint 7 do garden: ~10 chamadas por plano (eram 33 a 50); US$ do plano por Task perto de 2 (era 2,3 a 3,5); `**Li além da ficha:**` com até 2 arquivos; reprovações do `plan.ps1` e 🔺 GAPs de plano por Task não maiores que no S6. Plano que não barateia, ou GAP de plano que sobe, volta ao `/review`.

### Verificação
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.57 que saiu do vivo × arquivo (`.Contains`) | True; o vivo fica com v3.60, v3.59, v3.58 | ✅ |
| Entrega | `release.ps1` (C3); `run-check-tests.ps1`; `run-guard-tests.ps1` | ver CHANGELOG v3.60.0 | ✅ |

### Parte mecânica (implementada pela sessão principal, citada aqui)
`lib.ps1`: `Get-FichaCodeRefs`, `Get-FichaSourceRefs`, `Get-MdSectionSpan`, `Get-FichaExcerpts`, `Get-FichaBadRanges`, `Get-PlanGuide`; `Get-Ficha` devolve as faixas e as seções. `run.ps1`: o recorte ganha os trechos e o guia, a faixa fora do arquivo vai à correção da ficha, e o prompt do Arquiteto do plano muda (sem guia, o de antes).

### Addendum v3.60.1 — o time decide o que o stakeholder já respondeu (SM + Arquiteto + QA) — 2026-11-15

**Instrução:** (stakeholder, 15/11/2026) "analise o sprint 6 do garden e veja todas as paradas que aguardaram minha interação… quais ainda podem ser tratadas para o próprio PO, SM ou Arquiteto tomarem as decisões"; depois, "pode aplicar as propostas".
**Medido (garden, S6, de 14/11 15h a 15/11):** a prova no aparelho que não roda (ids não publicados, estado de partida) foi ao stakeholder 4 vezes com a mesma resposta, e na T-090 duas vezes, porque a decisão não chegou ao plano; "arquivos soltos" de outra Task, 3 formulários e 4 voltas do dev; Docker desligado, 4 formulários; "encurtar ou dividir" um plano que passou de 30 KB com as decisões de GAP; pausar exigiu apagar o `.active-run` pelo Explorador; uma rota da G24 deixou passar outras perguntas.
**Classificação:** instrumento (`run.ps1 prove` e `pause`; política e pré-requisitos no `guards.json`; retrato dos arquivos alheios; teto do plano sem as decisões de GAP) · regra (G24: uma pergunta por rota; o update não retoma o run).

| Documento | Seção | Mudança |
|---|---|---|
| `sprint-run.md` | Paradas legítimas · Pausa segura | pausa por `run.ps1 pause`; prova por teste por `run.ps1 prove` ou pela política; a rota vale para um formulário |
| `stakeholder-question.md` | Antes de perguntar | oito linhas novas de "quem decide" (prova no aparelho, decisão que não chegou ao plano, plano > 30 KB, arquivos alheios, id dinâmico, serviço desligado, pausa, atualização) |
| `team-update.md` | 9. Feche | o update não retoma o run nem pergunta "retomar agora?" |
| `deliverables/team-project/guards.json` | `_exemplos` | `run.deviceProofFallback` e `run.prereqs` |

---

## v3.59 — Acompanhar o sprint em palavras simples: a fala da sessão, o Resumo do quadro e o /team-status para quem é de negócio, com o técnico sob pedido (SM + PO + Arquiteto) — 14/11/2026 · *com addendum v3.59.2*

**Instrução:** (stakeholder, 14/11/2026) "precisamos melhorar as frases de conversação e posicionamento na sessão do orquestrador e no kanban para facilitar o acompanhamento … frases simples e mais diretas que deem clareza do que está acontecendo para alguém de negócio entender, sem termos técnicos, que podem ser solicitados caso necessário"; avaliação aprovada por inteiro ("pode fazer todas").
**Medido (sprint 6 do garden, 14/11):** o quadro do `kanban.md` mostrava só códigos (`T-069b`, `T-070a`); os bloqueios e as decisões ficavam no fim de 58 KB, depois das tabelas de tokens; o "Agora" chegou a mostrar `QA | — | trabalhando`; o `/team-status` mostrava a T-069a "em execução" e PARADA ao mesmo tempo que "Fechada", e "131 decisões" esperando o stakeholder, 98 delas resolvidas; a sessão repetia o vocabulário do `run.ps1 next` (PRÓXIMA AÇÃO, R12, `.scn`, executor de Task, GAP).
**Classificação:** formato (`## Resumo` e `## Detalhe técnico` no `kanban.md`, quadro em lista por etapa, coluna **Para o stakeholder** no Sprint Backlog, `/team-status detalhe`) · comportamento de agente (a sessão do `sprint run` fala pela linha `PARA O STAKEHOLDER:`) · propriedade (o PO escreve o nome de negócio de cada Task na Planning)

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `sprint-run.md` | §Fala ao stakeholder (nova) · §Como o SM verifica · passo 8 · §Marcador | a fala da sessão é a linha `PARA O STAKEHOLDER:` do `next`, copiada, uma por turno; o técnico, só quando o stakeholder pede; o `done` apaga o registro da Task fechada |
| `workflow-sprint.md` | §5e passo 4 | o PO escreve o nome de negócio de cada Task (coluna **Para o stakeholder**) |
| `templates/sprint-backlog.md` | tabela e §Como preencher | coluna **Para o stakeholder**, a última |
| `templates/kanban.md` | estrutura e §Como preencher | Resumo · Agora · Kanban · Controle · Fechamento; depois Detalhe técnico (Linha de base, Série, Registro, Rodadas); o quadro em lista por etapa, com o nome de negócio |
| `commands/sm.md`, `commands/team-status.md`, `how-to.md` | `sprint run` · `/team-status` | a fala ao stakeholder; `/team-status` simples por padrão e `detalhe` para o técnico |

### Por quê
Quem acompanha o sprint é de negócio. O que ele vê precisa dizer o que está pronto, o que anda, o que parou e por quê, e o que depende dele, sem precisar saber o que é uma Task, um GAP ou o `accept`. A regra H1 já dava essa forma ao formulário, mas o acompanhamento contínuo não tinha regra. As frases saem de um script (`plain.ps1`), não do modelo: custam zero token e são as mesmas no quadro, no `/team-status` e na fala da sessão. O código da parte vai sempre no fim, entre parênteses, para o stakeholder pedir o detalhe pelo nome que o time usa.

### Conflitos com o processo vigente
A regra "nenhuma mensagem ao stakeholder entre a aprovação do pacote e a Review que não seja formulário" passa a admitir a linha `PARA O STAKEHOLDER:`. A sessão já escrevia algo a cada fim de turno, e nada definia o que era. O Controle (Bloqueios, Decisões) continua escrito à mão pelo SM. O Resumo e o quadro só o traduzem, e a natureza do bloqueio deve ser escrita sem caminho de arquivo nem nome de regra.

### Como saberemos que funcionou
Sprint 7 do garden: nenhuma fala da sessão com `PRÓXIMA AÇÃO`, sigla de regra ou caminho de arquivo sem o stakeholder ter pedido detalhe (transcript); toda Task do quadro com a coluna **Para o stakeholder** preenchida na Planning; o `/team-status` sem Task "em execução" que já está ✅; "Precisa de você" com o número real de decisões abertas.

### Verificação
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.56 que saiu do vivo × arquivo (`.Contains`) | o vivo fica com v3.59, v3.58, v3.57 | ✅ |
| Entrega | `release.ps1` (C3); `run-check-tests.ps1`; `run-guard-tests.ps1` | ver CHANGELOG v3.59.0 | ✅ |

### Parte mecânica (implementada pela sessão principal, citada aqui)
`scripts/checks/plain.ps1` novo (nome de cada parte, papel, ação, etapa, motivo de parada, pendências do README §7, o Resumo); `kanban.ps1` (Resumo, quadro em lista, ordem das seções); `team-view.ps1` (visão simples e `-Detail`; Task do registro já ✅ ou 🔴 fora de "em execução"; pendências sem as resolvidas); `run.ps1` (`PARA O STAKEHOLDER:` em cada ação do `next`, "Pronto/Parou" uma vez por `.stakeholder-seen`, `dispatch -Clear` no `done`); `external-plan.ps1`; `hooks/common.ps1` (o "## Agora" com nomes de negócio); `hooks/prompt-submit.ps1` (`/team-status detalhe`).


### Addendum v3.59.2 — a consolidação dos documentos vivos é conferida, chega aos donos e é versionada (SM + Arquiteto) — 2026-11-14

**Instrução:** (stakeholder, 14/11/2026) "toda tarefa gera, quando necessário, a atualização do SDD? Quem faz? Sempre a documentação está atualizada?"; depois da avaliação, "faça as três correções no plugin".
**Medido (garden, sprints 5 e 6):** a consolidação do sprint 5 está "feita" desde 09/11, mas `architecture.md`, `data-model.md` e os ADRs 0001 e 0011 continuam sem commit. A parte do `api-spec.md` entrou no commit da T-079. Os 4 pedidos ao PO nunca foram aplicados: o `requirements.md` não muda desde 31/10, e o RF-MAN-02 ainda diz "um canteiro por vez", com o manejo em vários canteiros construído no sprint 5. A Review conferia só a linha `**Estado:** feita`.
**Classificação:** instrumento (`run.ps1 next`: `Get-ConsolidationRows`, `Test-DocChangedInSprint`, `Save-DocsCommit`, `.docs-check.json`) · fluxo (os donos dos pedidos disparados no passo 6) · formato (modelo `roles/architect/templates/docs-consolidation.md`).

| Documento | Seção | Mudança |
|---|---|---|
| `working-rules.md` | R12 | "feita" é conferida no git; os pedidos vão aos donos; commit próprio dos documentos; o que não mudou vai à Review |
| `sprint-run.md` | passo 6 | os donos dos pedidos (PO, UX, SM, QA), uma vez cada; o commit é do script |
| `artifact-ownership.md` | Consolidação dos documentos vivos | o dono aplica no documento dele; o commit não é do Arquiteto nem dos donos |
| `roles/architect/README.md` · `templates/docs-consolidation.md` (novo) | Documentos vivos | as três tabelas que o script lê; o Arquiteto não faz commit |
