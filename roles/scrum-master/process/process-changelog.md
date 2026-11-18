# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

---
## v3.62 — A prova do app híbrido no aparelho é de primeira classe: o id é lido pelo CDP e a configuração do alvo vai ao stakeholder, não ao Arquiteto (SM + Arquiteto + QA) — 16/11/2026

**Instrução:** (stakeholder, 16/11/2026, sobre o item 25 de `note.md`, depois de análise no garden) versão com plano; `assert-count` e `assert-order` valem para a lista inteira; revogada a espera pelo espelho do id no `aria-label`; correção genérica para qualquer app híbrido. Depois: "aplicar a fase G do plano-v3.62.0".
**Medido (garden, sprints 4 a 6):** no alvo `android` com WebView, todo cenário por id dava "tag não encontrada"; 10 das 18 decisões do Arquiteto do S6 e 8 itens do README §7 eram sobre o meio de prova; a Task fechava com `NÃO EXERCITADA (ambiente)` ou com "prova por outro executor, com desvio registrado". A premissa dos documentos (o id chega ao `uiautomator`, ou pelo `aria-label`) foi desmentida em Android 15 / WebView 124.
**Classificação:** instrumento (`targets.android.locator = "cdp"`, `scenario-language.md`; parte mecânica no `CHANGELOG.md` v3.62.0) · rota (CONFIGURAÇÃO DO ALVO: exit 4 com `configuration` no `result.json` vai ao stakeholder) · formato de documento (standards e roteiros do dev, do Arquiteto e da QA)

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `sprint-run.md` | passo 4 (Gap) · Paradas legítimas · Falha de ambiente | a CONFIGURAÇÃO DO ALVO não é GAP: o `run.ps1 done -Result env` a leva ao stakeholder (🔴 "configuração do alvo", rota `configuracao-do-alvo`), sem `operator` de diagnóstico, reparo, dev, Arquiteto nem reabertura automática; o `deviceProofFallback` não se aplica; o `result.json` com `locator: "cdp"` é prova de primeira classe |
| `templates/stakeholder-question.md` | Antes de perguntar | linha nova da configuração do alvo; "ids não publicados" sai da linha da prova que não roda |
| `standards/test-ids.md` · `standards/scenario-language.md` (novo) · guias Angular, React, Ionic/Capacitor, Kotlin | §2, §4, §6 · índice · IONIC-3 | o id do app híbrido é lido pelo CDP; saem "Não há driver por CDP", o `[PARCIAL]` como limite e a evidência com caminho de um projeto; IONIC-3 recomenda `locator: cdp`, `hiddenScopes`, depuração da WebView e `readyExpr`/`failExpr`; os guias deixam de afirmar que o `uiautomator` lê o id; exemplos `horta.*` → `pedido.*` (Arquiteto) |
| `roles/developer/{README,templates/gap}.md` · `roles/architect/templates/{implementation-plan,technical-decision}.md` | rota de GAP · P3 · ids | a CONFIGURAÇÃO DO ALVO sai da rota de GAP (não é GAP, nem ambiente da Task, nem decisão do Arquiteto) (Arquiteto) |
| `roles/quality-assurance/README.md` | l. 58 e 116 | a tela da WebView de app híbrido é cenário executável com `locator: "cdp"`; saem o limite `[PARCIAL]` e o "🔺 GAP ao Arquiteto por WebView opaca"; "tag não encontrada" em híbrido com `uiautomator` é configuração do alvo; o `result.json` com cdp é prova de primeira classe no portão, sem desvio registrado (QA) |
| `note.md` | item 25 · item 8 | o item 25 sai da fila (aplicado); ficam as provas de campo no item 8 |

### Por quê
O desvio institucionalizado custava uma decisão por Task: o `accept` só reconhecia o `uiautomator`, e a prova que funcionava (CDP) vivia num script do projeto e só entrava "por decisão". Dar ao plugin o executor que fala com a WebView tira o meio de prova da pauta do Arquiteto; separar a configuração do alvo da falha do app tira do dev, do operator e do Arquiteto um conserto que não é deles (o build e o `guards.json` são do stakeholder) e acaba com a ida repetida ao stakeholder pela mesma causa, agora com a mensagem que diz o que corrigir.

### Conflitos com o processo vigente
Nenhum com regra. Contraria o texto da v3.53.3 (GAP da prova no alvo vai ao `operator`) só para a configuração do alvo, que a v3.62.0 identifica antes do 1º cenário. A v3.60.1 (`run.deviceProofFallback`) segue valendo para estado de partida e serviço fora do ar, não para a configuração.

### Como saberemos que funcionou
Nos próximos sprints com app híbrido: nenhum 🔺 GAP ambiente por id não encontrado e nenhum de "WebView opaca"; nenhum `[PARCIAL]` por WebView; nenhuma decisão do Arquiteto sobre meio de prova; Tasks fechadas pelo `result.json` sem linha de desvio no `run-log.md`; a configuração do alvo chega ao stakeholder uma vez, com a correção dita. Prova de campo pendente em `note.md` item 8: `accept -Target android` com `locator: cdp` num app híbrido real, `done` fechando pelo `result.json`, zero `NÃO EXERCITADA` por id e id dinâmico confirmado em execução.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.59 que saiu do vivo × arquivo (`.Contains`) | True; o vivo fica com v3.62, v3.61, v3.60 | ✅ |
| Substituição de padrão | `Grep` de `Não há driver por CDP\|horta\|desvio registrado\|outro executor` em `standards/` e `roles/{developer,architect}` | zero (conferido pelo Arquiteto) | ✅ |
| Entrega | `release.ps1` (C3) | R17 e R18 ok | ✅ |

### Parte mecânica (implementada pela sessão principal, citada aqui)
`targets/android-cdp.js`, `cdp-verbs.js`, `dom-probe.js`; `android.ps1`, `accept.ps1` (exit 4 com `configuration`), `run.ps1` (rota `configuracao-do-alvo`), `web-runner.js` na semântica comum; teste de paridade. Detalhe e suítes no `CHANGELOG.md` v3.62.0.

### Decidido pelo stakeholder (formulário de 16/11)
- **Nome de projeto como procedência:** neutralizado para "projeto piloto" em todos os documentos do plugin (`standards/`, `roles/`, `agents/`, `rituals/`, `how-to.md`, `hooks/COVERAGE.md` e modelos). Data e sprint ficam, então a ligação com a medição continua rastreável. Os changelogs e os comentários de script ficam como histórico.
- **Tela de fora do app com `locator: "cdp"`:** é provada por teste (`(teste)` no cenário), conforme `standards/scenario-language.md` §3. O modo misto (passos de tela do sistema pelo `uiautomator`) ficou como item 26 da fila do `/review`.
- **Guia e rituais:** o `how-to.md` passou a ensinar o `locator: "cdp"`. O `team-init` o propõe para stack híbrida, e o `team-update` ganhou o passo 7o.

### Addendum v3.62.2 — comando longo em processo próprio: ninguém encerra o turno para esperar um comando (SM + Dev + operator) — 2026-11-17

**Instrução:** (stakeholder, 17/11/2026) "Preciso de uma solução definitiva para esse ponto pq travou o processo por diversas vezes, investigue"; depois, "implemente na versão fix 3.62.2".
**Medido (garden, S6, Q-S6d, 16–17/11):** a suíte de 17–25 min passou dos 600 s da ferramenta, foi para segundo plano e o dev encerrou o turno com `ESPERANDO`. O Claude Code a encerrou junto ("it is terminated when you give your final response and no notification can follow that"), o aviso não veio, e o executor e a sessão esperaram até alguém digitar: 7 instâncias de dev numa Task, e uma suíte rodada à mão para escapar. Nas transcrições de 30 dias, a mesma chamada recebe ora o aviso, ora o encerramento, conforme a versão (2.1.308, 2.1.310, 2.1.325 e 2.1.326 encerram). Ensaio: o encerramento leva a árvore inteira; o processo criado pelo WMI sobrevive.
**Classificação:** instrumento (`verify.ps1` e `detach.ps1` rodam o comando em processo próprio e só o acompanham; o `run.ps1` não espera rodada que não acorda ninguém) · regra (exit 3 = rode o mesmo comando no mesmo turno; nenhum papel encerra o turno esperando comando; `run_in_background` negado também ao operator).

| Documento | Seção | Mudança |
|---|---|---|
| `sprint-run.md` | Disparo e espera, item 5 · Constantes · Ciclo do executor | o comando longo roda em processo próprio e é acompanhado no mesmo turno; a rodada do verify não depende do dev; o `ESPERANDO` sem comando acompanhável não segura o run; 480 s como constante |
| `agents/developer.md` · `roles/developer/README.md` | passo 6 · Falhou, eu corrijo | exit 3 = rodando: o mesmo comando no mesmo turno; nunca encerrar o turno para esperar; comando longo fora do verify pelo `detach.ps1` |
| `agents/operator.md` | Espera | comando longo pelo `detach.ps1`, acompanhado no mesmo turno; sem segundo plano |
| `agents/task-runner.md` | passo 3 | `ESPERANDO` do dev: não esperar o aviso; o `done` diz o passo (dev novo reencontra a rodada) |
| `hooks/COVERAGE.md` | G14 · bloco v3.62.2 | `run_in_background` negado a todo papel; o comando de dentro do `detach.ps1` conferido |


### Addendum v3.62.3 — o executor de cenários do projeto roda pelo `accept.ps1` (Arquiteto + Dev + QA + operator) — 2026-11-17

**Instrução:** (stakeholder, 17/11/2026, sobre a Q-S6d do garden: "hoje não há como acompanhar o aceite pela pasta de resultados") "Vamos fazer a correção na versão 3.62.3". Formulário do mesmo dia: o script do projeto roda **pelo plugin**; o resultado vem **das linhas** da saída; o estado de partida é **do plugin**.
**Medido (garden, S6, Q-S6d, 17/11):** o plano declarou `**Aceite:** não roda` citando o D-16 ("o `accept.ps1` no android não acha id do app") e mandou o operator provar os 49 cenários pelo `prova-cdp.mjs` numa pasta de job. O `guards.json` do projeto já declarava `locator: cdp` desde a v3.62.0. A prova correu sem trava do alvo, sem `progress.json` e sem conferir o APK instalado, e ficou fora de `.team-project/accept/`.
**Classificação:** formato (``**Aceite:** comando — `<cmd>` ``, contrato do executor em `standards/scenario-language.md` §5) · regra (34: `não roda` citando script do projeto reprova; cenário provado fora do `accept` não é evidência de aceite) · instrumento (`accept.ps1`, `plan.ps1`, cartão do `run.ps1`).

| Documento | Seção | Mudança |
|---|---|---|
| `standards/scenario-language.md` | §5 (nova) | executor do projeto: marcadores, ambiente, linhas de resultado, códigos de saída, repetição, o que o `accept` grava |
| `roles/architect/templates/implementation-plan.md` · `external-plan.md` | cabeçalho · regra 34 do checklist | linha `**Aceite:** comando`; `não roda` só para cenário provado pelos testes do plano |
| `roles/architect/plan-rules-why.md` | 34 | o caso da Q-S6d e por que o `não roda` com script reprova |
| `agents/developer.md` | passo 12 | a prova é o `accept.ps1` do cartão; o executor direto não vale |
| `agents/operator.md` | regras | pedido de rodar o executor do projeto como prova vai pelo `accept.ps1 -Task` |
| `agents/quality-assurance.md` | evidência do `verify` | cenário provado fora do `accept` não é evidência de aceite; `não roda` com script é achado de processo |
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
