# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
| [`v3.62`](process-changelog-archive.md) | A prova do app híbrido no aparelho é de primeira classe: o id é lido pelo CDP e a configuração do alvo vai ao stakeholder, não ao Arquiteto (SM + Arquiteto + QA) — 16/11/2026 |
| [`v3.61`](process-changelog-archive.md) | Sprint 0: o backlog funcional abre sobre documentação conforme e ambiente de testes provado — o onboarding pergunta onde está a documentação e decide o sprint 0 (SM + PO + Arquiteto + QA) — 16/11/2026 |
| [`v3.60`](process-changelog-archive.md) | A ficha leva os trechos (o Arquiteto do plano lê uma vez e escreve) e o kanban acompanha o prazo: previsão por parte, farol e burndown visual, com o registro técnico no consumo (SM + Arquiteto) — 15/11/2026 · *com addendum v3.60.1* |
| [`v3.59`](process-changelog-archive.md) | Acompanhar o sprint em palavras simples: a fala da sessão, o Resumo do quadro e o /team-status para quem é de negócio, com o técnico sob pedido (SM + PO + Arquiteto) — 14/11/2026 · *com addendum v3.59.2* |
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

## v3.65 — Revisão geral: uma fonte por regra, o plano grande com precedência escrita e o normativo sem história (SM + Arquiteto + Dev) — 19/11/2026

**Instrução:** (stakeholder, 19/11/2026, depois do `/review audit` da v3.64.5) corrigir tudo agora, antes do benchmark: achados A1-xx a A4-xx do relatório de auditoria (80), plano em `melhorias/plano-v3.65.0.md`.
**Classificação:** regra · fluxo · propriedade de artefato · formato de documento · comportamento de agente (proposto e aplicado pelo stakeholder, Q3).

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `process/sprint-run.md` | §Plano acima de 30 KB (nova) | **Fonte única** da regra do plano grande, com a precedência: antes da construção a Task se divide pelos blocos do plano; construção começada (plano emendado por decisão do stakeholder, da Q-S ou de GAP) a Task não se divide, o Arquiteto substitui o texto derrubado pela decisão, sem acrescentar ao lado nem cortar o que vale, e roda o `plan.ps1` até passar; reprovação repetida sobe ao degrau 1. As paradas, o bloqueio e a retomada apontam para ela (A3-01..04, A3-16) |
| `process/sprint-run.md` | §Uma correção do portão por vez, §Disparo e espera, constantes | Os parágrafos cumulativos viram regras curtas com a precedência explícita e sem marca de versão (A3-20). A decisão do stakeholder que emenda o plano vai ao bloco `**Decisão do stakeholder (<data> · replan\|portão):**` com Origem e Lição, fora do teto, e a `architect/decisions/S<n>.md` se vale para mais de uma Task; **nunca** a `**Plano corrigido durante a execução:**`, que é só erro do próprio plano e métrica do benchmark (A2-01). O executor com `accept` ou reparo vivos devolve `⏸ esperando: <comando>` e para; a sessão segue o `next` e o redispara (A3-09). História, medições e o piloto da ficha saem (A4-10); a regra de sessão do run fica só na R29 (A4-01); a lista "quem decide" só na tabela de `stakeholder-question.md`, sem o dado "12 de 22" (A4-02, A4-03); fim do ttoque de cache (A4-09); siglas de plano (A4-16) |
| `process/working-rules.md` | R4 · R5 · R14 · R15 | R4: o C1 confere `git diff --name-only` × lista do plano (Q1; `close.ps1` pelo stakeholder/sessão) e a margem do dev aponta para `agents/developer.md` (A1-01, A4-04). Texto igual ao que o código confere: R5 (C1 `n-a` fixo), R14 (sem conferência de data), R15 (a metade ② não tem aplicação) (A1-08, A1-12, A1-13) |
| `process/working-rules.md` | R28 · R29 | R28: o portão roda `verify -Mode full -Fresh` (cobertura só por `inputs`), o dev tem o `detach.ps1`, o Security Engineer entra na G7, o layout do job aponta para `agents/operator.md` (A3-11, A3-12, A1-14, A4-06). R29 passa a ser a fonte da regra de sessão e lista o sprint 0 (A1-18) |
| `process/working-rules.md` | geral | "Evita:" em uma frase sem o caso medido; racionais e notas vX.Y saem (o caso vai a este changelog); sai o "Resumo em uma tela" e a R34 duplicada (A4-07, A4-12, A1-22); R17–R19 saem do normativo e viram ponteiro para `rituals/review-contract.md` (A4-11) |
| `process/artifact-ownership.md` · `hooks/ownership.json` | §1 · §1e | Donos de `gate/`, `proof/`, `gate.json`, `lessons.md`, `architect/breakdown/`, `.ask-route`, `.stakeholder-seen` e `scripts/**`; árvore e tabela de §1e completas (handoff, validation, docs-consolidation, pack); listas de guardas e rituais sem enumeração; fronteira: a previsão do quadro é do SM, o plano de entrega e o prazo ao stakeholder são do PO (A3-14, A3-15, A4-18..21) |
| `templates/stakeholder-question.md` · `README.md` do SM · `templates/benchmark.md` | tabela "a decisão é dele?" · contagem · métrica | Sair de 🔴 é `mark.ps1 -Reopen resume\|replan` (A2-05); R1–R35 (A3-13); a métrica "Plano corrigido" só conta erro do próprio plano |
| `roles/architect/*` (Arquiteto) | README · `implementation-plan.md` regras 22 e 29 · `external-plan.md` | A regra do plano grande e o bloco de decisão do stakeholder com Origem e Lição, iguais às de `sprint-run.md`; `plan-rules-why.md` removido com os 2 ponteiros (−25,2 KB) e notas de versão fora das regras do template (A3-04, A2-01, A4-15, A4-23) |
| `roles/developer/*` (Arquiteto aplica) | `templates/gap.md` · README | CONFIGURAÇÃO DO ALVO com o `cdp.pageUrl` que não casa nenhuma página; G14 nega `Start-Sleep` com ou sem `runCommands` (A3-18, A1-03) |

### Por quê
A mesma regra morava em quatro ou cinco lugares (script, mensagem, `agents/*`, roteiro, modelo externo) e cada correção atingia só os que o incidente tocava; o parágrafo cumulativo deixava duas versões divergirem sem mostrar a precedência. Cada regra tocada fica com **uma fonte** e ponteiros de uma linha. O normativo que todo papel carrega perdeu a história (casos medidos, racionais, marcas de versão), que o changelog guarda. Casos medidos que saíram do texto: sprint 6 do piloto com 12 de 22 formulários sem rota (A4-03); sessão do run a ~800 mil tokens e 13 pontos seguros sem `/clear` (R29); 303M tokens em 20 subagentes e 123 retornos de 5,5 KB (R28); 48 `Start-Sleep` e US$ 3,68 no P-r1 (G22); 84% do custo do plano antes da primeira escrita (R35); inflação do changelog de 1,4 KB (v1.0) a 17,1 KB (v1.8) (R17).

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| SM | Aplica a R4 com o diff × plano do C1; confere o executor `⏸ esperando` e a precedência do plano grande; mantém o dono de `gate/`, `proof/`, `lessons.md` e dos marcadores do run |
| Arquiteto | Plano acima de 30 KB com construção começada: substitui, não corta nem divide; decisão do stakeholder no bloco próprio, nunca em "Plano corrigido durante a execução" |
| Dev | A margem do dev vive só em `agents/developer.md`; `detach.ps1` para comando próprio acima de ~2 min |
| PO · UX · QA | Escrevem a resolução do achado do portão em `gate/<ID>.md`, agora com linha na matriz |

### Conflitos com o processo vigente
Nenhum aberto: a R4 (diff × plano) segue a decisão Q1; o resto preserva o sentido das regras (cortou-se história, repetição e caso medido).

### Como saberemos que funcionou
Nenhuma Task em construção dividida e nenhum plano emendado com o texto antigo ao lado da decisão; zero decisão do stakeholder em "Plano corrigido" nos planos do braço P; `working-rules.md` + `sprint-run.md` abaixo de 170 KB (de 189 KB) e a nova rodada de `/review audit` com zero achado aberto nas frentes tocadas.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Extração/remoção | `git cat-file -s HEAD:<arquivo>` × `(Get-Item <arquivo>).Length` | working-rules 118118→102173 B · sprint-run 73364→66500 B · artifact-ownership 64177→67136 B (+linhas de dono) · index 13885→14267 B | ✅ |
| Substituição de padrão | `Select-String '34 regras\|R1–R34\|R30-R34\|12 de 22\|Resumo em uma tela\|toque de cache'` nos documentos do SM, fora dos changelogs | 0 ocorrências; `v3\.\d` em `sprint-run.md`: 0 (cada "(v3.x)" removido lido no contexto) | ✅ |
| Arquivamento | `diff` do bloco v3.62 do vivo (antes) × arquivo | zero linhas fora do separador | ✅ |
| Conferência | `scripts/checks/release.ps1` | R17 ok · ps1-5.1 ok · ownership ok (72 regras) · órfãos ok · R18 falha só pela versão (README L3, de outro papel) | ✅ |

### Pendente do stakeholder
`rituals/review-contract.md` §Regras do repositório-fonte (R17–R19, texto pronto): a guarda G8 negou a escrita ao SM; sem ele, o ponteiro da R17–R19 em `working-rules.md` aponta para a seção a criar. `close.ps1` (C1 × diff do plano, Q1) e os `agents/*` são do stakeholder.

---

## v3.64 — A evidência que o script já sabe, o cartão que só diz o que o plano diz, a árvore e a máquina com dono e o portão que não duplica correção (SM + Arquiteto + Dev + QA) — 18/11/2026

**Instrução:** (stakeholder, 18/11/2026) "consegue fazer uma análise no projeto garden para identificar tudo que gerou retrabalho durante o sprint 6"; depois "monte o plano de correção dos itens 2, 5 e 6", "inclua no plano v3.64.0" (a parada da Q-S6e no Karma), "inclua somente o necessário para resolver no plugin" (o portão que mandava abrir a Q-S6f) e "pode construir". Decisões D1–D8 em formulário, no mesmo dia (`melhorias/plano-v3.64.0.md` §8).
**Medido (piloto, S6, 11 a 18/11):** 58 reprovações do `done` viraram "dev novo, só a evidência, não mude código" — 9 eram só papel, 18 só um comando, 17 repetiam a anterior igual, e com a suíte vermelha o dev não podia mudar código; o cartão dizia "**Verificação:** sem verify" (o estado) e o dev leu "não rode" (T-083, T-093); a T-090 parada em 🔴 deixou 6 arquivos no disco e a T-093 só fechou com um commit à mão (`6e84fcf`); às 19:21 de 18/11 outro projeto da máquina subiu um servidor do adb próprio e um emulador no meio da suíte do Karma — o emulador do piloto caiu e a suíte ficou 2,6× mais lenta — e o diagnóstico mandou abrir Task de configuração; o `validation.md` começado antes da v3.63.0 nunca chegou ao caminho por causa, e o `next` mandou abrir a Q-S6f com a Q-S6e aberta para os mesmos 21 cenários.
**Classificação:** rota (a reprovação do `done` segue a natureza — script, operator, dev, ambiente; repetição idêntica escalona; uma `Q-S<n>` por vez; Q-S em 🔴 vai ao bloqueio) · instrumento (prova registrada e R12 escritos pelo script; checkpoint; `treeIgnore`; diagnóstico da máquina; trava pesada e `machine-lock.ps1`; `inputs` e `lastGreen`) · formato de documento (cartão em duas seções; tabela da rodada com `Cause`).

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `agents/task-runner.md` | O ciclo, passo 4a | a reprovação do `done` pela natureza: mecânica o script preenche · prova não rodada → operator, sem dev · vermelha ou escopo → dev normal, que pode mudar código · a mesma reprovação pela 2ª vez → Arquiteto (ou stakeholder, ambiente) |
| `roles/developer/templates/delivery-report.md` | Documentos vivos · Ajustes na margem | sem a seção R12, o `done` a escreve; com o verify verde, a saída não precisa ser colada (`### Prova registrada`); a linha de margem que se lê é aviso |
| `roles/quality-assurance/templates/sprint-validation.md` | Rodada 2 | a tabela da rodada é a dos achados (com `Cause` na coluna); o formato antigo converte os achados abertos |
| `sprint-run.md` | §Validação do sprint · Correção do portão | uma `Q-S<n>` por vez, achados novos à aberta com o plano emendado pelo Arquiteto, `**Corrige:**` substitui, 🔴 vai ao bloqueio, o diagnóstico do operator é informação nova; checkpoint antes de medir; a suíte reaproveitada por `inputs` roda de fato na revisão final |
| `how-to.md` | Alvos | um servidor do adb por máquina e uma porta de emulador por projeto; trabalho pesado um por vez (`machine-lock.ps1` para scripts do projeto); `inputs` da suíte; `treeIgnore` e o checkpoint |

### Pendente do stakeholder
Nada.

---
## v3.63 — O portão do QA por marcos: ambiente não vira veredito, a rodada nova mede e julga só o que venceu, cada achado tem causa e dono, e a prova de cada rodada fica no sprint (SM + QA + PO + UX + Arquiteto + Dev) — 17/11/2026

**Instrução:** (stakeholder, 17/11/2026) "Avalie se o processo de QA desde que inicia possui marcos do processo sobre as diversas validações que realiza pois uma falha em um deles não necessariamente poderá reiniciar todo o processo do zero"; "existe na falha dos cenários uma marcação do motivo para talvez resolvê-lo a nível de UX, PO, Arquiteto ou dev?"; "o Kanban, consumption precisam controlar também essa tarefa além de dentro do sprint guardar as evidências das entregas". Formulários do mesmo dia: tudo numa 3.63.0; nomes em inglês; o portão vira item controlado; guardar o resultado e as capturas, sem os logs brutos. Plano em `melhorias/plano-v3.63.0.md`.
**Medido (garden, S6, 15–17/11):** 3 rodadas do portão reprovadas, quase todas por ambiente, e 4 Tasks de correção (Q-S6 a Q-S6d); cada rodada refez a qualidade inteira e os 49 cenários, também depois de correções só na ferramenta de prova; o `validation.md` citava `accept/6/S6/result.md` das rodadas 1 e 2, e só existia o da última; o "Volta para" só tinha dev e Arquiteto, em texto livre; a medição e o julgamento do portão caíram em `n/a · sprint-6` no consumo (~2,1 mi de tokens); o "## Agora" mostrou como trabalhando agentes encerrados havia 37 min.
**Classificação:** instrumento (`gate.ps1`; `accept.ps1 -Resume`; `Get-ProductionTree`, `gate.json`, `proof/`; G16 e registro de agentes) · formato de documento (`validation.md` com `## Frentes` e `## Achados`: ID `S<n>-F<k>`, `Cause`, `State`; `**Cause:**` no GAP; `gate/<ID>.md` com `**Resolution:**`) · rota (a causa decide o dono: PO, UX, Arquiteto, QA, `Q-S<n>`, reparo) · cerimônia (rodada focada do QA).

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `sprint-run.md` | passos 4 e 5 da tabela · §Validação do sprint · Gap (natureza → causa) | o portão por marcos (medir só o que venceu, ambiente fora do veredito, prova guardada, causa com dono em ordem fixa, rodada focada); a `Q-S<n>` cita os IDs; quadro e consumo do portão |
| `quality-assurance/templates/sprint-validation.md` · `quality-assurance/README.md` · `agents/quality-assurance.md` | modelo inteiro · `/qa sprint <n>` passos 1, 2, 4 e 5 | tabelas `## Frentes` e `## Achados` com valores fixos em inglês; ID que não se reaproveita; a prova citada por `proof/`; rodada focada sem reabrir frente mantida |
| `developer/templates/gap.md` · `agents/developer.md` · `agents/task-runner.md` | linha do GAP · rota | `**Cause:**` com `appearance`, `design`, `scenario`, `screen`, `requirement`, `process`, `environment` (os nomes antigos são sinônimos); `screen` → UX, `requirement` → PO, `scenario` → QA |
| `user-experience/README.md` · `agents/user-experience.md` | achado ou GAP de tela | o UX acrescenta o caso na especificação da tela e grava a resolução |
| `product-owner/README.md` · `agents/product-owner.md` | achado ou GAP de requisito | o PO decide o que é dele e devolve em `STAKEHOLDER:` o que é do stakeholder; resolução `done`, `code` ou `debt` |
| `scrum-master/templates/sprint-backlog.md` | linha da `Q-S<n>` | os IDs dos achados que ela corrige |
| `standards/scenario-language.md` | §6 (nova) | `-Resume`: identidade do app, hash do cenário, o que o `result.json` passa a trazer |
| `how-to.md` · `hooks/COVERAGE.md` | `/team-status` · pastas · bloco v3.63.0 | a revisão final no `/team-status` e no `kanban.md`; a pasta `proof/`; G16 com o portão; o registro sem sinal; o que o `host_pid` prova |

### Por quê
O portão tinha marcos grossos: a medição valia pela árvore inteira, então qualquer correção refazia tudo, e o aceite que caía no ambiente virava veredito do QA e correção do dev. A falha de um marco reiniciava os outros. E o achado só tinha dois destinos, então o que era da tela ou do critério voltava ao dev, e a especificação continuava sem o caso.

### Conflitos com o processo vigente
Nenhum com regra. Muda a rota da natureza `produto` do GAP (v3.57.0: ia direto ao formulário do stakeholder) — agora passa pelo PO, que é o canal do stakeholder (R22). O "cenário não exercitado reprova o portão" da v3.51 fica: o que muda é que o ambiente é reparado antes de o QA julgar.

### Como saberemos que funcionou
No próximo portão de um projeto com alvo: nenhuma `Q-S<n>` aberta por ambiente; a rodada 2 roda só os cenários que falharam, não rodaram ou mudaram; nenhuma frente de código rejulgada depois de correção só em ferramenta de prova; todo caminho de prova citado no `validation.md` existe no fim do sprint; o consumo separa o custo de cada rodada do portão.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.60 que saiu do vivo × arquivo (`.Contains`) | True; o vivo fica com v3.63, v3.62, v3.61 | ✅ |
| Comportamento | `run-check-tests.ps1`, casos marcados v3.63.0 | ver `CHANGELOG.md` v3.63.0 | ✅ |
| Entrega | `release.ps1` (C3) | R17 e R18 ok | ✅ |

### Parte mecânica (implementada pela sessão principal, citada aqui)
`scripts/checks/gate.ps1` (novo), `run.ps1` (portão, `done -Cause`, registro ignorado), `accept.ps1` (`-Resume`), `lib.ps1` (árvore de produção, `gate.json`, achados, prova, causas), `quality.ps1`, `close.ps1` (`proof/<ID>/`), `kanban.ps1`, `team-view.ps1`, `consumption.ps1`, `hooks/subagent-stop.ps1`, `hooks/common.ps1`. Detalhe e suítes no `CHANGELOG.md` v3.63.0.

### Decidido pelo stakeholder (formulários de 17/11)
- Uma entrega só (3.63.0), com os marcos do QA, as causas com dono, o controle no quadro e no consumo e a prova guardada.
- Identificadores novos em inglês; o texto para pessoas continua em português.
- Guardar o resultado e as capturas de cada rodada e de cada Task, sem os logs brutos.

### Addendum v3.63.1 — toda falha de cenário do aceite passa pelo diagnóstico, com a prova do aparelho, e o alvo preso não prende o run (SM + QA + Arquiteto) — 2026-11-18

**Instrução:** (stakeholder, 18/11/2026, sessão `/sm sprint run` do projeto piloto) "Esse erro não era previsto tratar pelo plugin retornando ao dev, ao UX ou ao PO para indicar qual botão acionar e onde ele está?" — com a lista de pedidos do sprint 6 (diagnóstico automático em toda falha de cenário; "app não ficou na frente" com motivo e registro do aparelho; foco e WebView recriada como sinais separados; identidade do app no `-Resume`; órfão de accept no travamento do operator; sonda de travamento pelo progresso; escalonamento do laço de reparo).
**Medido (piloto, S6, 18/11):** um operator travou 600 s e foi encerrado pelo watchdog; o `accept.ps1 -Task S6 -Resume` que ele disparou (PID 15292, de 06:13 a 08:22) segurou o alvo, o reparo recusou "em uso por accept S6", o `target.ps1 -Kill` disse "nada registrado" e o `next` repetiu "reparar e repetir" — o accept recusado não gravava `result.json`, então a contagem do portão nunca subia. Depois, o SC-118 falhou duas vezes ("a conexão com a página caiu", a captura na aba Geral, não na Estufa) e o cenário seguinte parou em "não ficou na frente, foco: nenhum"; o `next` tratou como ambiente, sem diagnóstico; o diagnóstico pedido à mão saiu AMBIENTE sem registro do aparelho. O `-Resume` leu "apk:?" (o APK instalado pelo comando do projeto, sem arquivo local) e rodou todos.
**Classificação:** rota (falha de cenário → diagnóstico antes do ambiente e antes do QA; PLANO → QA ou Arquiteto com o elemento e onde; o alvo preso → esperar ou stakeholder na primeira vez; o navegador da suíte que cai duas vezes no mesmo teste → dev) · instrumento (registro do aparelho e sinal do app no `accept`; identidade do app instalado; trava com hora de criação e pasta; `target.ps1 -Kill` encerra o dono da trava; o `verify` repete a rodada em que o navegador caiu).

| Documento | Seção | Mudança |
|---|---|---|
| `sprint-run.md` | §Validação do sprint, item 2 | o diagnóstico antes do reparo e do julgamento; AMBIENTE só com prova; o alvo preso por outro processo; a 3ª repetição do mesmo `result.json` vai ao stakeholder |
| `agents/operator.md` | regra 9 | o diagnóstico vale para toda falha de cenário (Task e portão); lê o registro do aparelho e o sinal; grava `Cenário:`, `Motivo:`, `Elemento:`, `Onde:` e `Dono:`; o órfão sai por `target.ps1 -Kill` |
| `standards/scenario-language.md` | §6 | a identidade do `-Resume` é a do app instalado no aparelho; `signal`, `log` e `environmentSignal` no `result.json` |
| `sprint-run.md` · `agents/operator.md` | §Validação do sprint, item 2 · regra 9 | quem usa o aparelho por `target.ps1 -Who`; duplicado por `-KillDuplicates`; a trava atômica e o `-Unlock` que recusa dono vivo |

**Quem usa o aparelho** (mesmo dia: a sessão e o plugin leram um accept, o invólucro e os observadores da mesma rodada como "três accepts", e dois observadores foram encerrados): `target.ps1 -Who` mostra quem usa o alvo, sem adivinhar por lista de processos; `-KillDuplicates` encerra só o duplicado deste projeto; a trava é atômica, não é tomada de dono vivo que anda e o `-Unlock` recusa com o dono vivo.

**Dois projetos, um emulador** (v3.63.2, mesmo dia, pergunta do stakeholder): a trava do aparelho, comum aos projetos da máquina (`%LOCALAPPDATA%\team-plugin\device-locks`), tomada junto com a do projeto — o accept, o reparo e o `-Release` de um projeto não entram no aparelho que outro usa; o `next` espera ou leva ao stakeholder. Os dois ao mesmo tempo: um `targets.android.serial` por projeto.

**O navegador da suíte que cai no meio** (Karma "no message in 120000 ms", Q-S6d, duas quedas seguidas no `verify full`): não é teste reprovado. O `verify` repete a rodada uma vez, com a memória conferida. Caiu de novo no mesmo teste: um teste trava o navegador — código, vai ao dev. Caiu em pontos diferentes: carga ou memória — ambiente, com a medida; o prazo do runner e as flags do navegador são do projeto (Task, com o Arquiteto).

