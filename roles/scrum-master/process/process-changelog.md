# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v3.54 — Mutação pela regra e margem do dev: o Arquiteto diz o que provar, o dev escreve o trecho e corrige o defeito do próprio teste, com travas no fechamento (SM + Arquiteto + Dev + QA) — 04/11/2026

**Instrução** (stakeholder, 04/11/2026, relatório de encadeamento do sprint 5 do garden: "vamos seguir com as duas", depois da explicação do problema, da proposta e do ganho de cada uma).
**Medido (sprint 5 do garden):** o maior plano trazia 19 mutações com a linha de código original, escritas antes de o código existir; mutação com trecho escrito de outro jeito pelo dev sai `inconclusivo` e vira 🔺 GAP ao Opus. Das 4 decisões de GAP dessa Task, 2 eram defeito do próprio teste (medida contra a raiz de 360 px; popover lido antes de renderizar) e 1 era CSS que a regra do projeto já definia (44 px); só 1 era desenho.
**Classificação:** formato (plano: mutação pela regra, regra 18; regra 30; relatório: `**Mutações:**` e `### Ajustes na margem`) · regra (R4 ganha a margem do dev) · instrumento (`plan.ps1`, `verify.ps1`, `close.ps1` R7-margem). **Sem regra nova** (34). **Papéis movidos (R17):** 4 — SM, Arquiteto, Dev, QA.

### O que mudou
- **Arquiteto** (`implementation-plan.md` regras 18 e 30, `fix-plan.md`, modelos do plano externo): a mutação se declara **pela regra** (`· regra: <o que quebra>`); literal só com trecho que já existe uma vez no código — o `plan.ps1` reprova o adivinhado.
- **Dev** (`agents/developer.md` regras 1 e 6, `delivery-report.md`): escreve o trecho e o mutante das mutações pela regra no relatório; corrige sem GAP o defeito mecânico do próprio teste e o CSS que a regra do projeto define, registrando em `### Ajustes na margem`.
- **SM** (`working-rules.md` R4 e o índice): a margem é a exceção explícita do "não antecipar escopo", com as travas do `close`.
- **QA** (README, frente 2): confere que a mutação do dev ataca a regra declarada e que cada ajuste é mesmo da margem.

### Por quê
O modelo mais caro escrevia código que ainda não existia, e cada diferença de grafia custava uma volta ao Opus e uma instância nova do dev. Defeito do teste e valor de CSS já definido não são decisão de desenho. A prova não afrouxa: a mutação continua obrigatória e rodada, e o ajuste no teste só fecha se a mutação dele for pega na árvore final.

### Conflitos com o processo vigente
R4 e o template diziam "o que não está no plano vira GAP, nunca improviso": a margem é exceção nomeada, com instrumento. A regra 18 (v3.46) pedia o trecho exato no plano: passa a valer só para trecho que já existe.

### Como saberemos que funcionou
Sprint 6: zero mutação `inconclusivo` por trecho; 🔺 GAPs ao Arquiteto por Task construída abaixo do sprint 5; ajustes na margem por Task e quantos o QA julgou divergentes (alvo zero).

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.51 que saiu do vivo × arquivo (`.Contains`) | True; o vivo fica com v3.54, v3.53, v3.52 | ✅ |
| Entrega | `release.ps1` (C3); `run-check-tests.ps1`; `run-guard-tests.ps1` | ver CHANGELOG v3.54.0 | ✅ |

### Parte mecânica (implementada pela sessão principal, citada aqui)
`lib.ps1` `Get-Mutations` (forma pela regra), `Get-DeliveryText`, `Get-TaskMutations`, `Get-MarginAdjustments`; `verify.ps1 -Mode mutation` roda a linha do dev (e de novo quando ela muda); `close.ps1` R7-margem (bloqueante); `plan.ps1` regra 18; `fix.ps1` aceita a forma pela regra.

### Addendum v3.54.1 — alvo que se religa, margem stub, plano reconferido no meio da construção (SM + Arq + Dev + QA) — 05/11/2026

**Instrução:** stakeholder, 05/11 (carta da sessão do sprint 5 do garden; "pode seguir" com A, B e C). Muda: o pré-voo religa o emulador de rede antes de dizer "fora" e a sessão cita a causa dele no formulário de bloqueio; a margem do dev ganha o **stub** da dependência nova em teste que já existe e monta um arquivo do plano; decisão de 🔺 GAP com a construção começada **substitui** o trecho que derrubou (sem divisão), a contagem vale também pelo último commit e o `start` recusa plano acima do teto. Recusados: campo `reconnect` no `guards.json`, comandos de diagnóstico liberados à sessão e regra do `plan.ps1` que adivinha `inject()`. Sem regra nova (34). **Indicador (sprint 6):** zero bloqueio de ambiente com o emulador no ar; zero 🔺 GAP por stub de teste; zero dev começando com plano reprovado. **Evidência:** CHANGELOG v3.54.1.

### Addendum v3.54.2 — accept que para no estado de partida, progresso visível, quadro em dia (SM + Dev + QA) — 05/11/2026

**Instrução:** stakeholder, 05/11 (pontos 3 e 4 da mesma carta; "pode fazer" com D, E, F e G). Muda: os 2 primeiros cenários na mesma tela param o accept como **estado de partida**, sem reparo e sem reabertura automática, e com decisão do stakeholder; o estado de partida se declara em `targets.android.baseline`, que o QA aponta; a espera de um accept mostra o avanço e **SEM AVANÇO**; o quadro mostra a Task nova em ⬜ e o motivo da 🔴, e reabre pelo alvo de volta uma vez só. Recusados: tipos de bloqueio e a sessão abrir a captura. Sem regra nova (34). **Indicador (sprint 6):** nenhum accept acima de 15 min sem cenário passando; nenhuma Task reaberta duas vezes pelo alvo; nenhuma Task do Sprint Backlog fora do quadro. **Evidência:** CHANGELOG v3.54.2.

---

## v3.53 — Plano pela ficha: a quebra em Tasks traz a ficha de cada Task, um Arquiteto por Task e o template do plano só com o operativo (SM + Arquiteto + Dev + QA) — 28/10/2026

**Instrução** (stakeholder, 28/10/2026, `note.md` itens 7 e 8, "pode então fazer" depois da explicação de como um item pesa no outro). **Decisão:** a primeira opção do piloto do item 8, ficha por Task na Planning + um Arquiteto por Task; os itens 7 e 8 numa entrega só, porque um sem o outro rende pouco. Os lotes por dependência ficam como segunda opção.
**Medido (sprint 4 do garden, plugin 3.52.2, transcripts da sessão `3af98c37…`):** a instância "Planos da H-K1" (8 planos, 100 chamadas, contexto de 19 → 434 mil) custou ≈ US$ 16,3, 63 % dos subagentes, 97 % disso em cache lido. A abertura chegava a ~117 mil antes da pesquisa: README 10,6 mil, `breakdown/S4.md` 19,1 mil, `sprint-backlog.md` 9,0 mil, template 15,6 mil, `plan.ps1` 11,9 mil; a listagem de `sprints/3/plan` (8,9 mil) não foi usada. A seção "Regras do formato" era 16,5 KB dos 34,9 KB do template.
**Causa:** cada chamada do modelo reenvia a conversa inteira acumulada, então o custo é a abertura somada à pesquisa e aos planos já escritos, reprocessados a cada passo. **Estimativa (não medição):** por Task com a abertura de hoje, −14 %; só o item 7, −9 %; com a abertura enxuta, −34 %; com a ficha, abertura ~35 mil e ≈ US$ 6 a 7 na H-K1 (≈ −55 %).
**Classificação:** fluxo (preparo do `sprint run`) · formato (template do plano: regras só operativas e regra 28; modelo novo `breakdown.md`) · comportamento de agente (abertura do Arquiteto pela ficha; não abrir o `plan.ps1`). **Sem regra nova** (34): a regra 25 do template muda de "uma instância por História" para "por Task com ficha; por História sem ela". **Papéis movidos (R17):** 2 — SM, Arquiteto.

### O que mudou
- **Planning, passo 4** (`workflow-sprint.md`, `roles/architect/README.md` §Quebra em Tasks, `templates/breakdown.md` novo): na seção de cada História do `breakdown/S<n>.md`, as **decisões comuns** (nomes que mais de uma Task usa, com a grafia final) e uma **ficha por Task** — `**Código a ler:**` (caminho, linha e porquê), `**Fontes:**` (SDD, standards, tela) e `**Nomes comuns:**`. A ficha só aponta; até ~25 linhas.
- **`sprint-run.md` etapa 1, "Por que assim" e §Como o SM verifica; `commands/sm.md`:** Task com ficha → um Arquiteto por Task, que abre o recorte da ficha, o template, o plano da dependência e o `architect/context.md`; primeiro a Task cujas dependências já têm plano, uma por vez (R1). Task sem ficha → a História numa instância, como na v3.51. Indicador do piloto no "Como o SM verifica".
- **Template do plano:** regras só com o operativo, numeração mantida (1–27), ✓ nas que o `plan.ps1` confere e "não abra o script"; o texto até a v3.52.3, íntegro, foi **relocado** para `roles/architect/plan-rules-why.md` (não é leitura do plano). Cabeçalho com `**Li além da ficha:**`; **regra 28** (plano pela ficha). 33,6 → 22,7 KB.
- **`agents/architect.md`:** leitura de abertura do plano pela ficha; o código do `plan.ps1` não é leitura. **`roles/architect/README.md`** §Preparo e a tabela de documentos; `deliverables/team-project/README.md` (linha do `breakdown/`).

### Por quê
O plano por História (v3.51) tirou a releitura por Task do P-r6, mas a instância longa passou a reprocessar a própria pesquisa e os planos já escritos a cada chamada. Dividir por Task só rende com a abertura pequena, e a abertura só fica pequena se alguém já tiver separado o que cada Task precisa ler: é o Arquiteto da Planning, que já tem a História e o código abertos para quebrar em Tasks. O template enxuto vale nas duas formas, mas pesa mais por Task: cada instância paga a abertura e grava o cache dela de novo.

### Conflitos com o processo vigente
A regra 25 e o "Por que assim" da v3.51 (plano por História) passam a valer só para Task sem ficha. O P-r6 mostrou o plano por Task custando 41 % — aquele era por Task **sem ficha**, relendo o projeto inteiro; o risco é medido no piloto.

### Quem passa a ser cobrado de forma diferente
**Arquiteto:** escreve a ficha e as decisões comuns na Planning; no plano pela ficha, declara o que leu além dela e usa os nomes comuns literalmente; não abre o `plan.ps1`. **SM/sessão:** confere no "Como o SM verifica" um Arquiteto por Task com ficha e o indicador do piloto. **Demais papéis:** sem mudança.

### Como saberemos que funcionou
Próximo sprint, contra o sprint 4: US$ do plano por Task construída (`consumption.md`) ao menos 40 % menor; 🔺 GAPs de plano por Task construída sem subir (sprint 4: um por Task); arquivos em `**Li além da ficha:**` por plano — ficha com muitos é ficha incompleta. Custo que não cai, ou GAP que sobe, devolve ao `/review` com os lotes por dependência como segunda opção.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.50 que saiu do vivo × arquivo (`.Contains`) | True; o vivo fica com v3.53, v3.52, v3.51 | ✅ |
| Extração/remoção | "Regras do formato" do template no HEAD (regras 1 a 27) × `plan-rules-why.md` (`.Contains`); `Length` do template | True; 33 628 → 22 693 B | ✅ |
| Substituição de padrão | `Grep` de "regra 25"/"planos de todas as Tasks"/"uma instância do Arquiteto" fora dos changelogs | só o fallback sem ficha (`run.ps1`, testes, comentário do G16), lido no contexto | ✅ |
| Entrega | `release.ps1` (C3); `run-check-tests.ps1`; `run-guard-tests.ps1` | C3 exit 0 (R18 3.53.0 nos três; R17 bloco v3.53 ≤ 10 240, 2 papéis, 3 entradas; ownership 63; órfãos 49 ok); conferências 206/0 (+6); guardas 253/0 (+1) | ✅ |

### Parte mecânica (implementada pela sessão principal, citada aqui)
`lib.ps1` `Get-Ficha`/`Resolve-FichaPath`; `run.ps1 next` grava `sprints/<n>/handoff/<T-ID>-ficha.md` e dispara o Arquiteto da Task; `plan.ps1` regra 28 (`**Li além da ficha:**`, nomes comuns no plano, caminhos da ficha existem); G16 (`subagent-stop.ps1`) não conta como trabalho da rodada o ID dentro de caminho (o plano da dependência citado no prompt rateava a rodada entre as duas Tasks).

### Addendum v3.53.1 — teto de contexto do dev, agente vivo de outra sessão, aceite sem assert (SM + Dev + QA) — 01/11/2026

**Instrução:** stakeholder, 31/10/2026, avaliação do `plugin-report.md` do fim do sprint 4 do garden ("pode executar" sobre os defeitos e a medição). Sem regra nova (34), sem conflito; o piloto da ficha (v3.53) não foi medido, porque o sprint foi planejado na 3.52.2. **Medido:** 6 instâncias de dev com 61 a 159 chamadas, pico até 242 mil e 34 % do US$ dos subagentes (na de 157, cache lido ≈ 71 % do custo da rodada); dois devs no mesmo emulador depois de abrir uma segunda sessão; `accept` "18 de 18" sem nenhum assert. **Mudou:** dev — teto de contexto (G23, `guards.json → devContextCap`, padrão 100 mil): grava `### Parei no passo` e volta com `TETO` (`agents/developer.md` regra 11); executor — `done -Result teto` e o `start` que recusa outro dev vivo (`agents/task-runner.md`); QA — cada cenário com ao menos um `assert-*` (README §preparo); SM — `sprint-run.md` §Retomada após queda (segunda sessão aberta, limite na mesma sessão) e `team-remote.md` §1a (troca de sessão). Instrumentos: CHANGELOG v3.53.1. **Estimativa, não medição:** −35 a −45 % do cache lido nas instâncias longas do dev; custo novo de uma carga fixa (≈ 18 mil) e do ponto de retomada por corte. **Indicador:** próximo sprint com zero dev acima de 100 mil de contexto, Σ US$ das instâncias longas abaixo dos 34 %, 🔺 GAP por Task ≤ 1,7 e nenhum redisparo com agente vivo. **Evidência:** conferências 214/0, guardas 264/0, C3 ok.

### Addendum v3.53.2 — toda pergunta ao stakeholder em formulário (SM) — 01/11/2026

**Instrução:** stakeholder, 01/11/2026: "sempre vir como modo formulário", com uma opção para digitar e outra para pedir mais esclarecimento, de maneira simples. Também pediu que o problema fosse corrigido na origem, sem uma volta a mais. **Mudou:** R22 vale para **toda** pergunta da sessão ao stakeholder, não só para a decisão. Isso inclui dado, confirmação e próximo passo. Na pergunta aberta, as respostas prováveis viram opções e o campo "Outro" do formulário serve para digitar. "Pedir mais contexto" traz a explicação curta e repete o formulário na mesma resposta. A linguagem é simples, com termo técnico só quando é indispensável, e isso é orientação, não bloqueio. A forma entra no contexto de toda sessão pelo `SessionStart`. Uma guarda no `Stop` foi descartada porque custaria uma volta do modelo, e o stakeholder pediu que não houvesse. Sem regra nova (34). **Indicador:** nenhuma pergunta em texto corrido ao stakeholder no próximo sprint, contada na retrospectiva. **Evidência:** CHANGELOG v3.53.2.

**Plano do Arquiteto (Arquiteto · SM):** decisão do stakeholder sobre o relatório prévio do sprint 5 do garden, em que o Arquiteto gastou 84% e cortar planos custou ~US$ 9. O plano não se corta por tamanho; acima de ~30 KB só se avisa Task grande. A ficha ganha **Arquivos previstos** (até 6, acima disso a Task se divide). O `run.ps1 next` confere a ficha antes do Opus e põe nela o resumo do plano da dependência. A leitura é por trecho. Sem regra nova. **Indicador:** o Arquiteto gasta 35–40% menos por plano no próximo sprint, sem mais GAPs de plano.

**Bloqueios do run (QA · SM · Dev):** 11 de 19 decisões do sprint 5 vieram de nomes de teste. Cenário diz o modo de prova (`(teste)` sem `.scn`); nomes que faltam viram Task na Planning; `# aguarda <T-ID>` no `.scn` adia o cenário; `verify -WaitBusySeconds`; reparo do emulador em `targets.android.repair`. Sem regra nova. **Indicador:** zero formulário de mapeamento no run.

### Addendum v3.53.3 — construção e prova sem retrabalho (SM + Dev + QA) — 02/11/2026

**Instrução:** stakeholder, 02/11/2026, avaliação do meio do sprint 5 do garden (itens 1 a 5 aceitos). O título do bloco passou a declarar Dev e QA, que os addenda v3.53.1 e v3.53.2 já tocavam. **Medido:** ~US$ 100 com 4 de 16 Tasks fechadas, sendo o Arquiteto 84 % dos subagentes. O contrato de nomes de teste cresceu 3× (~US$ 19 de Opus): os `.scn` de quatro Histórias foram escritos antes da Task que cria os nomes. As capturas da falha do aceite mostravam a tela inicial do Android ou a página do cenário anterior, e o time leu "APK sem os ids". A T-058 teve 3 devs, porque o dev que esperava um comando em segundo plano parecia ter voltado. **Mudou:** o preparo é de uma História por vez, e a que depende de outra vem depois (`sprint-run.md` passo 1). O GAP da prova no alvo vai ao operator, pelas capturas, antes do Arquiteto. O dev que espera comando volta com `ESPERANDO`, e `done`, `start` e `next` não redisparam enquanto o verify ou o accept da Task roda. Sem regra nova (34). **Indicador (sprint 6):** zero dev duplicado; zero GAP de alvo no Opus sem veredito do operator; nenhum plano refeito por contrato que mudou depois; Arquiteto em retrabalho bem abaixo dos US$ 28,6. **Evidência:** CHANGELOG v3.53.3.

### Addendum v3.53.4 — plano externo (SM + Arquiteto) — 02/11/2026

**Instrução:** stakeholder, 02/11/2026: tirar do limite da conta Claude o trabalho que mais pesa, mantendo controles e scripts. **Medido:** sprint 5 do garden, Arquiteto US$ 66,77 de ~US$ 100 (planos 38,2 · retrabalho 28,6); dev US$ 3,13. **Mudou:** opção do projeto `guards.json` → `"run": { "planner": "external", "tasks": [] }`, desligada por padrão. O plano da Task com ficha sai num pacote por História (`sprints/<n>/pack/`) para um assistente de fora; o `run.ps1 next` só o aceita depois do `plan.ps1`, e o reprovado volta num pacote de correção. O 🔺 GAP dessa Task também vai num pacote. Na trilha fix, a mesma chave manda para fora os mini-planos do `/sm fix plan` (conferidos pelo `fix.ps1 -PlanOnly`; o modo retoma no passo 4) e o 🔺 GAP de uma Correção; a estrutura do fix não muda. Ficha, cenários, construção e fechamento seguem no Claude. Sem regra nova (34). **Indicador (piloto, 3 Tasks do sprint 6):** plano aprovado em até uma correção, GAPs de PLANO não acima dos do Opus, US$ de Arquiteto dessas Tasks perto de zero. **Evidência:** CHANGELOG v3.53.4.

### Addendum v3.53.5 — espera com sinal de vida e um emulador só (SM + Dev) — 02/11/2026

**Instrução:** stakeholder, 02/11/2026, no sprint 5 do garden: "acompanhar essas paradas longas pra saber se são travamentos" e mostrar no `/team-status` a Task em execução e há quanto tempo ela roda. **Medido:** o reparo do alvo (`target.ps1 -Repair`) ficou 81 min parado com 1 s de CPU, à espera de `adb emu kill`. A causa eram dois emuladores, um AVD local e um container Docker, nas mesmas portas 5554/5555. A trava do alvo tinha dono `target.ps1 android`, que o `next` não via, e a G20 barrou 43 fins de turno na T-042 enquanto o `next` mandava esperar a T-061. **Mudou:**
- todo `adb` tem prazo, e o reparo recusa abrir um segundo emulador com as portas ocupadas;
- `targets.android.serial` fixa o aparelho de trabalho;
- o reparo do alvo também segura a Task;
- cada espera do `next` traz o sinal de vida (tempo, CPU, processo, último arquivo) e `POSSÍVEL TRAVAMENTO`, que vai ao stakeholder em formulário;
- a G20 segue a decisão "esperar" do `next` (`.next-verdict`, 30 min) e cita a Task em construção;
- o `/team-status` ganhou "Em execução" com `PARADA`.

Sem regra nova (34). **Indicador (sprint 6):** nenhuma espera acima de 15 min sem `POSSÍVEL TRAVAMENTO` ou resultado; bloqueios da G20 por dia abaixo de 5; zero reparo do alvo que passe de 10 min. **Evidência:** CHANGELOG v3.53.5.

### Addendum v3.53.6 — Task grande se divide, prova pendente bloqueia (SM + Arq + Dev + QA) — 04/11/2026

**Instrução:** stakeholder, 04/11, sobre o relatório do sprint 5 do garden. Muda:
- plano acima de 30 KB reprova e a Task vai à divisão, com o plano como base; nunca se corta;
- id de teste é padrão de código: id do `.scn` fora do código e controle sem id reprovam o `verify`;
- Task sem prova no alvo por ambiente vai a 🔴 e volta quando o alvo responde; não fecha ✅;
- consumo medido pela cota da assinatura, não por US$.

Sem regra nova (34). **Indicador (sprint 6):** zero plano acima de 30 KB no dev; zero "tag não encontrada" no accept; zero ✅ sem prova no alvo; cota por Task no `consumption.md`. **Evidência:** CHANGELOG v3.53.6.

### Addendum v3.53.7 — prova pela camada certa, decisão do sprint num lugar só (Arq + Dev + QA) — 04/11/2026

**Instrução:** stakeholder, 04/11 (encadeamento do sprint 5 do garden). Muda: o QA prova cada critério na camada mais barata, e o cenário de aparelho declara a massa (`seed`); premissa de layout se mede executando; decisão de GAP comum fica uma vez em `architect/decisions/S<n>.md`, citada pelo plano. Sem regra nova (34). **Indicador (sprint 6):** zero decisão copiada entre planos; cenários tirados da prova por gesto ou massa perto de zero. **Evidência:** CHANGELOG v3.53.7.

---

## v3.52 — Orquestrador enxuto: sessão nova por ritual, `run` em sessões curtas, espera sem sondagem, registro de decisões e commit por Task (SM) — 23/10/2026

**Instrução** (stakeholder, 23/10/2026, `note.md` itens 1 a 9 e decisões em formulário): reduzir o custo da sessão que orquestra, medido no benchmark `sunscape-P-r1` (plugin v3.51.3). Decisões: (1) o fim de cada Task é **parada permitida** (`.team-project/.safe-point`); (2) **ampliar a R29**, sem regra nova; (3) o brief do brainstorm é gravado ao **fechar**, em `scrum-master/context.md` §"SDD em elaboração"; (4) hooks e scripts a sessão principal implementa.
**Medido (itens 1 a 4):** passo `run` de 504 min, US$ 14,20; a sessão que orquestra gastou 67 % (US$ 10,76 em 113 chamadas, mediana de 376 mil tokens, máximo de 438 mil), quase tudo releitura do próprio contexto; leitura de documentos pesou ~6 %, a construção ~US$ 6,3 e o dev em Haiku menos de US$ 1. O contexto já chegava a ~200 mil quando o `run` começava (init a plan na mesma sessão). **48 chamadas de `Start-Sleep`** (60 a 598 s) custaram US$ 3,68. A trilha `fix` começaria com ~440 mil tokens.
**Causa confirmada da espera (item 3):** o disparo em primeiro plano bloqueia normalmente (62 disparos, até 3.824 s) — a hipótese do vigia de 600 s caiu. Vem de **(a)** retomada por `SendMessage`, assíncrona, com a sessão sondando o disco, e **(b)** a sessão rodando ela mesma comando longo em segundo plano (aceite, lotes com `adb`) e sondando por horas — trabalho do `operator` (R28).
**Classificação:** fluxo (`run`, `fix`, rituais) · regra ampliada (R29; R15 e R27 com exceção) · formato (modelo novo `run-log.md`) · propriedade (`run-log.md`, `.safe-point`). **Sem regra nova** (34). **Papéis movidos (R17):** 1 — SM.

### O que mudou
- **R29 ampliada** (`working-rules.md`, índice): troca de ritual, fronteira sprint → fix e cada Task do `run`; tudo o que o ritual decide fica em disco antes de fechar. **R15:** o brainstorm não escreve durante as fases, mas **ao fechar** grava o brief (≤ 15 linhas, fronteira de escopo, confirmação) em `context.md` §"SDD em elaboração". **R27:** no `run` a retomada é sempre instância nova em primeiro plano.
- **Cada ritual** (`workflow-ritos.md` onboarding e brainstorm, `workflow-sdd.md`, `workflow-sprint.md` prepare/plan/review/close, `sprint-run.md`, `fix-run.md` note → fix plan → fix run): lista fixa de leitura na abertura e fecho "em sessão nova (`/clear` e o comando)".
- **`sprint-run.md`:** sessão curta, uma Task por sessão; commit `T-<nnn>: <título>` no fechamento (nunca `.team-project/`, R31; sem git, cópia como o `fix run`); parada **(f)** e `.safe-point`; §Disparo e espera (primeiro plano, sem `Start-Sleep`, comando longo só pelo `operator`); §Retomada sem `SendMessage` — **inclusive Haiku** (assíncrono, e o ganho de reaproveitar o contexto dele é de centavos); **toque de cache retirado** (não dispara durante a chamada bloqueante, e a sessão curta regrava barato); preparo de História independente vira passo sequencial do `next` (exceção da R1 retirada); §Registro de decisões.
- **`templates/run-log.md`** (novo): quando · item · decisão · porquê · evidência; `sprints/<n>/` e `fixes/B-<nnn>/`; lido só em retomada, bloqueio e Review; diz o que fica no `kanban.md`, `handoff/`, `guards.log`, `.usage-limit` e `.safe-point`. `artifact-ownership.md`: linhas do `run-log.md` e do `.safe-point`.

### Por quê
Quase todo o custo da sessão era reler contexto longo; sessão curta (50 a 80 mil), espera dentro da chamada bloqueante e passagem pelo disco o tiram sem retirar verificação alguma. Estimativa (não medição): a releitura do `run` do P-r1 (US$ 14,5) cairia para ~US$ 3 e a espera (US$ 3,7) para perto de zero; cada sessão nova regrava ~US$ 0,15 a 0,20.

### Conflitos com o processo vigente
O "Fim de Task não é parada" do `sprint-run.md` e a G20 ganham a exceção do `.safe-point`. A v3.49 mandava retomar Haiku por `SendMessage` e criar o toque de cache: esta entrada reverte as duas. A G19 hoje só nega papel caro depois de 5 min.

### Quem passa a ser cobrado de forma diferente
**Sessão/SM:** abre cada ritual lendo só a lista fixa, para em sessão nova, não sonda o disco nem roda comando longo, anota o `run-log.md`. **Dev:** o commit da Task é do script. **Demais papéis:** sem mudança de roteiro.

### Como saberemos que funcionou
P-r2 (SunScape, mesma regra de comparação): contexto mediano da sessão ≤ 80 mil tokens e máximo ≤ 150 mil; zero chamada de `Start-Sleep` da sessão no `run`; releitura da sessão ≤ US$ 4; cada Task ✅ com um commit `T-<nnn>:`; nenhum ritual iniciado na sessão que já rodou outro sem aviso.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.49 que saiu do vivo × arquivo (`.Contains`) | True; vivo termina em `---`, arquivo tem v3.49 antes da v3.48 | ✅ |
| Substituição de padrão | `Grep` de `SendMessage`/`segundo plano`/`CronCreate`/toque em `roles/scrum-master/` | restam só `consumption.md` (histórico de rodada) e `artifact-ownership.md` (`.active-agents`), lidos no contexto; o resto reescrito e lido | ✅ |
| Entrega | `release.ps1` (C3); `run-check-tests.ps1`; `run-guard-tests.ps1` | C3 exit 1 só por R18 (v3.52 ainda sem CHANGELOG/bump, a sessão escreve); R17 ok (bloco 5,8 KB, 1 papel), ownership 62 ok, órfãos ok; conferências 161/0; guardas 227/0 | ✅ (R18 esperado) |

### Parte mecânica (implementada pela sessão principal, citada aqui)
`run.ps1 done` grava `.team-project/.safe-point` (JSON `task`, `sprint`, `desde`; só no `sprint run`) e faz o commit `T-<nnn>: <título>` (sem `.team-project/`; sem git, checkpoint por cópia); `next` mostra RETOMADA e apaga o marcador (o `start` também). **G20** libera com `.safe-point`; **G21** (`hooks/prompt-submit.ps1`) avisa ritual aberto em sessão que já rodou outro; **G22** (`pre-tool`) nega à sessão principal `Start-Sleep` e comando em segundo plano durante o `run`. **Ainda proposta ao stakeholder:** G19 negar `SendMessage` a qualquer papel com `.active-run`; retirar o `CronCreate` do toque de cache onde `SessionStart`/`commands` o mencionem; `ownership.json` para o `run-log.md`; driver do benchmark sem `--resume`.

### Addendum v3.52.2 — executor de Task, agente assíncrono, retomada após queda, plano que prova, Q-S<n> e Review adiada (SM + Arquiteto + Dev + QA + UX) — 26/10/2026

**Instrução** (stakeholder, 26/10/2026, `note.md` itens 1–17, avaliação do sprint 3 do piloto em v3.52.0; tudo numa entrega). **Decisões:** opção A — executor de Task (spike aprovado: subagente espera o filho encerrando o turno, três níveis, um aviso só à sessão); correção do portão = Task `Q-S<n>`; Review adiável por caminho formal; o SDD de mudança visível o Arquiteto consolida (o dev não edita).
**Medido:** sessão por `message.id` 207 → 228 mi (+10 %; a análise somava por linha, ~1,8×); 87/87 rodadas assíncronas; 195 bloqueios G20 (~230 respostas "aguardando", ~100 mi); 27 de 29 GAPs nascidos no plano.
**Classificação:** fluxo (`run`, `fix run`, Review) · regra ampliada (R21, R25, R27, R28, R29, R33) · formato (plano: Contagem, Premissas, Documentos vivos; `sprint-validation`; `sprint-review` adiada; seção Q-S) · propriedade (`run-log.md` com o executor; `.interrupted`) · agente novo (`task-runner`). **Sem regra nova** (34). Este bloco é a reversão parcial da v3.52 no que supunha agente em primeiro plano e `/clear` por Task.

- **SM:** `sprint-run.md` (§Disparo e espera, §Executor de Task, §Retomada após queda, §Validação com Q-S<n> e Decisão do PO, escalonamento por falha de papel); `fix-run.md` (executor por F-ID); `working-rules(-index).md`; `artifact-ownership.md`; `workflow-sprint.md` §5e; modelos `sprint-review`, `sprint-backlog`, `kanban`, `run-log`, `consumption` (sessão por `message.id`), `retrospective`, `plugin-report`; `commands/sm.md`, `dev.md`, `po.md`; `agents/task-runner.md`.
- **Arquiteto:** "decida, documente e prove — não construa"; regras 26 (Premissas) e 27 (Documentos vivos) do plano; mutante que compila; contagem pelo próprio Arquiteto, execução pelo `operator`. **Dev:** volta ao executor; cita `report.md` e o chamador do `operator` (R28).
- **QA:** veredito `**Veredito (rodada N):**` e `**Decisão do PO:**` (só ⚠️); achado do portão vira Q-S<n>. **UX:** `/ux prototype` com abertura e fecho (R29). **Rituais:** init/update §7k propõem `quality` e `verify.compile`.
- **Instrumentos (stakeholder, aplicados nesta entrega):** G20 sem filtro `bg`; `.active-agents` com `session`/`parent`; SessionStart → `.interrupted`; G7/G8 do executor; `run.ps1` (executor, retomada, commit `-F`, veredito, Q-S, `SESSÃO:`), `plan.ps1` (Contagem, Premissas, Documentos vivos), `lib.ps1` (`Get-Mutations`, `Get-PlanScope`, `targets: {}`, árvore sem `docs/`), `close`/`kanban`/`project`/`consumption`.
- **Indicador:** próximo sprint com zero G20 por espera, linha `SESSÃO:` ≤ 150 mil, orquestração por Task ≤ 5 mi, GAPs de origem no plano ≤ 10 de cada 29, toda correção do portão como Q-S<n>.
- **Evidência (R19):** guardas 249/0 (+20), conferências 190/0 (+27), C3 ok; `grep` de `run_in_background`/"primeiro plano"/"2º plano" nos documentos de processo: só histórico, lido no contexto.

### Addendum v3.52.3 — espera da verificação, aceite sem alvo, GAP no registro, consumo em US$ (SM + Dev) — 27/10/2026

**Instrução:** stakeholder, 27/10/2026, `/review` dos itens 1–5, 9 e 10 do `note.md` (sprint 4 do garden). Sem regra nova (34), sem conflito. **Mudou:** dev — comando movido para segundo plano: encerre o turno e espere o aviso; exit 5 (`agents/developer.md` regra 6, `roles/developer/README.md`); modelos `run-log.md` (o `done` grava GAP e ambiente) e `consumption.md` (coluna US$). Instrumentos: CHANGELOG v3.52.3. **Indicador:** zero "moved to the background" e zero espera por sondagem no próximo sprint. **Evidência:** conferências 200/0, guardas 252/0, C3 ok.

---
