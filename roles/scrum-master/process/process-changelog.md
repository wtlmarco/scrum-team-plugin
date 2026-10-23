# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v3.51 — O sprint do benchmark: dev constrói e verifica sozinho, plano por História ao lado dos cenários, portão do QA no fim, orquestração por script, contexto e cache, ambiente em qualquer tecnologia (SM + Arquiteto + Dev + QA + PO) — 21/10/2026

**Instrução** (stakeholder, 21/10/2026, a partir do benchmark P × N-forte × protótipo Coordenador–Operador; plano aprovado em `plano-plugin-p-plus.md`, decisões no §8 e em formulário): manter o processo e a documentação antes e depois da Sprint, mas chegar o mais perto possível do N-forte na construção — o plano e os cenários prontos antes do dev, o dev (Haiku) construindo, verificando e corrigindo sozinho, o QA como portão de validação do produto (qualidade de código e funcional, com prova no alvo real) uma vez no fim, a dúvida subindo ao Arquiteto só quando é dúvida; atacar a transferência de contexto e a perda de cache; scripts para qualquer tecnologia (Android e Web nesta versão; API e Windows desktop depois); toda decisão ao stakeholder com o problema simples, um exemplo e formulário; os itens do `note.md` e as propostas pendentes.
**Classificação:** fluxo da Sprint e da trilha `fix` · formato de documento (plano, relatório de entrega, validação do sprint, Kanban) · comportamento de agente (os seis papéis) · guardas novas (G19, G20) e guarda alterada (G3) · scripts novos e alterados · standard (perfis de nível 2 por tecnologia). **Sem regra nova** (34): R7, R12, R22 e R30 ganham o parágrafo v3.51.

### O que mudou

- **Construção (A1–A6).** A Sprint abre com o **preparo da construção** por História: o QA escreve os cenários executáveis (`.scn`, linguagem do `accept.ps1`), depois **uma instância do Arquiteto** escreve os planos de todas as Tasks da História. O plano fica enxuto (regras 22 a 25: ~12 KB, cenários, risco, layout novo) e o `plan.ps1` confere tamanho, cenários, risco e render. O **dev** constrói, roda `verify` e os cenários da Task no alvo, e corrige sozinho; a Task fecha pela **evidência do dev** (`close.ps1`, R7-aceite). O **QA** é o portão do sprint (`/qa sprint <n>`, `validation.md`): mede pelo `operator` (`quality.ps1`, `accept.ps1`) e julga SOLID, clean code, aderência e segurança. Documentos vivos (R12) consolidados **uma vez** pelo Arquiteto (`docs-consolidation.md`). Teste pelo risco, freado pela cobertura medida no portão.
- **Orquestração (B1, B2).** `scripts/checks/run.ps1` (`next`, `start`, `done`, `handoff`) devolve a próxima ação pronta; o `sprint-run.md` foi reescrito para esse fluxo (34 KB → ~14 KB).
- **Contexto e cache (C1–C5).** Papel em Sonnet ou Opus parado há mais de 5 min abre **instância nova** com o **cartão de passagem** (~2 KB, `handoff/<T-ID>.md`); a **G19** nega o `SendMessage` fora disso. Comando longo só no dev, no `operator` ou em script. Os agentes leem só as seções do README do time que usam; o dev lê cabeçalho, §6, §9 e o próprio bloco do plano.
- **Ambiente (D1–D4) em qualquer tecnologia.** `verify.ps1` com tempo limite próprio, árvore de processos encerrada e higiene por ferramenta (`tool-hygiene.json`: Gradle sem daemon, `dotnet` sem reúso de nó, `CI=true` no Node); **exit 4 = falha de ambiente**. `target.ps1` (pré-voo e reparo: emulador desenhando a tela, site no ar) e `accept.ps1` (cenários no alvo, Android por uiautomator, Web por Playwright com Edge/Chrome de reserva, captura por cenário), com a trava de dono único. `SessionStart` avisa perfil do Windows com acento.
- **Trilha `fix` (§3a).** Defeito vira cenário `FX-<nnn>` (falha antes, passa depois, com captura); métricas só dos arquivos tocados; formulário dos ajustes no formato H1.
- **Organização (G1–G4).** `kanban.md` no lugar do `burndown.md` (Kanban, Burndown e o controle das Tasks embaixo); `kanban.html` regravado a cada transição, sem token. `standards/stacks/<tecnologia>/` (.NET com `desktop.md`, Kotlin/Android, React, Angular) com ferramenta por regra Q, coluna "ecossistema restrito" e Ficha pré-preenchida; índice com identificadores.
- **Comunicação (H1).** Modelo `templates/stakeholder-question.md`; a G3 nega formulário sem exemplo prático.
- **Paradas (propostas a e b).** Hook `Stop` (**G20**): barra o fim de turno com Task elegível e `.active-run`; o `SessionStart` **retoma** o run em vez de só avisar. Proposta c (energia) no `how-to.md`; proposta d (render no `plan.ps1`) entrou ajustada pelo A6. O `proposals-pending.md` foi apagado (todas aplicadas).
- **Medição (M1).** `transcript-metrics.js activity`: custo por atividade, igual para qualquer braço do benchmark.

### Por quê

Medido no P-r6 (Mente Ativa, v3.50.1, transcripts): Arquiteto 41 % do custo e 632 min de relógio; sessão principal 35 %, a 274 mil tokens por chamada; dev em Haiku 3 %. O plugin escreveu mais documento (planos de 42 KB em média) que código e 6× mais teste que o N-forte. Perda de cache: 15 % no P-r6, 30 % no protótipo, zero no N-forte. No protótipo, a vistoria repetida depois do construtor nunca achou defeito real, e 38 % do custo foram chamadas que só diagnosticaram ambiente quebrado.

### Quem passa a ser cobrado de forma diferente

- **Dev:** fecha a Task com a própria evidência, inclusive os cenários no alvo; corrige sem esperar o QA; exit 4 é parar e dizer.
- **QA:** sai da verificação por Task; entra no portão do sprint e na escrita dos cenários executáveis; não roda comando longo.
- **Arquiteto:** planeja por História, sem instância por Task; consolida R12 uma vez; não roda comando longo.
- **Sessão / SM:** orquestra por `run.ps1`; não retoma papel caro depois de 5 min; formulários no formato H1.

### Conflitos com o processo vigente

O `/qa <ID>` continua para validação avulsa fora do `run`; a evidência do QA por Task (`evidence/`) continua aceita pelo `close.ps1` (regra anterior). Sprint aberto antes da v3.51 segue com o `burndown.md` e o controle no `sprint-backlog.md` — os scripts leem os dois lugares.

### Como saberemos que funcionou

Etapa 6a do benchmark (P+ no SunScape, contra N-forte e protótipo, mesmo oráculo): a construção do dev ≤ 1,5× o custo e ≤ 2× o relógio do N-forte; qualidade 15/15 e lote 4/4; documentação não abaixo do P-r6 na avaliação cega. Projeção registrada no plano: de US$ 59 para ~US$ 28 num projeto como o Mente Ativa.

### Evidência (R19)

Suítes: guardas e conferências (contagem na entrega), C3, `claude plugin validate`. Validação real: `accept.ps1` e `target.ps1 -Repair` no emulador do benchmark (3 cenários do SunScape com captura; reinício do AVD em 88 s) e num site local pelo Edge headless (deslizante, toque, contagem, ordem; servidor subido e encerrado pelo executor).

### Pendente do stakeholder

Autorização de custo da Etapa 6a (P+ no SunScape). API e Windows desktop no executor de cenários: próximo incremento.

### Addendum v3.51.4 — o run do SunScape e o sprint 2 do garden: G14 lendo o que os papéis escrevem, limite de uso legível, quadro que não perde linha (SM + Arquiteto + Dev + UX) — 23/10/2026

**Instrução** (stakeholder, 23/10/2026, `note.md` itens 1–16 e `plugin-report-garden.md` itens 1–27, tudo numa entrega só; item 14 decidido em 23/10: reduzir a partida do Gradle sem tirar mutação nem verificação completa).
**Classificação:** guardas (G8, G14, G16, G20) · fluxo do `run` (paradas, retomada, marcador) · formato (Kanban, plano) · instrumentos (`run`, `mark`, `close`, `kanban`, `plan`, `verify`, `dispatch`). **Regra nova: nenhuma.** Paradas legítimas ganham **(e)** pausa pedida pelo stakeholder no ponto seguro (o stakeholder pediu o ponto seguro no item 11).

- `sprint-run.md`: 🟦 no preparo, sem `.scn` sem `targets`; `run.ps1 done` confere, marca 🟪 e fecha (GAP → 🟨); `verify` exit 3 = parcial; §Retomada após limite de uso; §Pausa segura; "## Agora"; marcador sob trava.
- Modelos `kanban.md` e `sprint-backlog.md`; dev (exit 3, `target.ps1`, `-Precheck`, comando no topo do bloco); Arquiteto (`plan.ps1` cobra §3/§9 e trecho único); UX (a linha do protótipo no pacote é do SM); `kotlin-android/quality.md` (`verify.daemon`, `verify.compile`).
- **Fora do plugin:** item 9 (driver do benchmark). **Sem mecanismo novo:** item 8 (custo da T-001 — voltas da G14 e replano; medir com a "Espera de comando"); item 7 (o UX não estava no run: G19 no SDD, G8 na Planning).
- **Pendente do stakeholder:** Task habilitadora sem História (garden 20) contra a R20 — o close segue reprovando até a decisão.
- **Indicador:** próximo braço P+ com ≤ 3 negações da G14 e nenhuma de leitura; zero R7/R24/R28 por formato; `.usage-limit` em toda parada por limite.
- **Evidência (R19):** guardas 217/0 (+28), conferências 159/0 (+19), C3 ok.

### Addendum v3.51.3 — kanban do bloco de fix marcado na entrada de cada fase (SM) — 22/10/2026

**Instrução** (stakeholder, `note.md`): "o kanban do sprint e do fix devem ser atualizado a cada transição de fase de trabalho para verdadeiramente indicar o status da evolução das tarefas". No sprint o quadro já acompanha cada transição (`mark.ps1`, `close.ps1`, G16); no bloco de fix o estado da F-ID era deduzido de rodadas **concluídas**, então ficava em ⬜ durante a rodada do dev.
**Classificação:** fluxo da trilha `fix` (roteiro SM) · formato de documento (`kanban.md`) · script alterado (`kanban.ps1`, aplicado pelo stakeholder). **Sem regra nova** (34).

- `kanban.ps1 -Block B-<nnn> -Fid F-<n> -To plan|build|qa` marca a F-ID na **entrada** da fase (`fixes/B-<nnn>/.marks`) e regrava na hora; as rodadas (G16) só confirmam o estado e somam custo.
- `fix-run.md`: **Marca de fase** no preâmbulo do §Run (antes de acionar dev, Arquiteto ou QA; QA uma chamada por F-ID), `-To plan` no passo 4 do §Plan, fechamento sem `-Fid`.
- `templates/kanban.md`: variante do bloco marca na entrada de cada fase (fechamento e "Critério que caiu" seguem derivados); notas dizem "a cada transição e ao fim de cada rodada"; histórico de versão enxugado do cabeçalho.
- **Indicador:** no próximo `fix run`, cada F-ID tem a marca de entrada (🟦/🟨/🟪) no `kanban.md` antes da primeira rodada da fase.
- **Evidência (R19):** `release.ps1` (C3) ok, conferências 140/0, guardas 189/0; `-Fid F-1 -To build` em bloco de teste moveu a F-ID ⬜ → 🟨 com "marca na entrada da fase", e F-ID fora do plano foi recusada.

### Addendum v3.51.2 — relato de uso do `fix` e um quadro só (SM + Arquiteto + Dev + QA + PO) — 22/10/2026

**Instrução** (stakeholder, 21 e 22/10/2026, `note.md`, itens 1–10 e decisões em formulário): resolver, pela opção que **não aumenta o gasto**, o que a v3.51.1 mostrou na trilha `fix` (negações da G14 ao dev e ao Arquiteto, ficha negada pela G8, veredito reprovado pelo C4 por formato, `consumption.md` do bloco que não nasce, `verify -Mode mutation` que não rodou) e dar ao sprint e ao bloco **um quadro só**, em Markdown, com o gasto de cada rodada. Hooks, scripts, versão e CHANGELOG aplicados direto nesta rodada.
**Classificação:** comportamento de agente (roteiros do dev, do Arquiteto e do QA) · formato de documento (`kanban.md`, `fix-plan.md`, `verdict.md`) · guarda alterada (G14, G16) · script novo (`kanban.ps1`, no lugar do `kanban-html.ps1`) e alterados · fluxo da trilha `fix`. **Sem regra nova** (34).

#### O que mudou

- **Item 1 (e 5, consequência).** `fix-run.md` §Run passo 2 cita o comando completo do `verify.ps1` (`-Mode full`, depois `-Mode mutation -Plan …`), um por chamada, sem `cmd /c`, `-ExecutionPolicy` nem `Tee`; o `developer/README.md` diz que teste do projeto é o prefixo de `runCommands` puro. **G14** (`hooks/pre-tool.ps1`): script de conferência liberado também como trecho de comando composto (`Set-Location …; $log = …; powershell -NoProfile -File "<plugin>/scripts/checks/x.ps1" … | Select-Object …`), **só com o caminho dentro de `${CLAUDE_PLUGIN_ROOT}/scripts/checks/` (antes passava qualquer `scripts/checks/*.ps1`, inclusive do projeto). Sem o item 1, o dev não escreveria evidência à mão em `verify/` (item 5).
- **Item 2.** A negação de `cmd /c` diz "rode o comando direto, sem cmd /c".
- **Item 3.** `$env:TEMP`/`$env:TMP` em variável ou no destino se resolve (criar pasta no scratchpad passa); **executar arquivo do scratchpad (`node` etc.) continua negado** — contornaria a G8 e a G9. No run (`sprint run`, `fix plan`, `fix run`) o Arquiteto valida lendo o código e escreve "não validado — o dev confirma no passo <n>"; scratchpad executável e `operator` ficam só no sprint fora do run (`architect/README.md`, `fix-run.md`).
- **Item 4 (sem exceção na matriz).** `fix-run.md` §Promoção: o Arquiteto registra `**Critério que caiu:**` no mini-plano; dev e QA, no próprio relatório, e a sessão copia a linha para o mini-plano (sem invocar o Arquiteto só para isso); a sessão muda o estado e devolve ao PO, que grava `## Destino` na ficha (a linha que o C4 confere) **na invocação que a promoção já dispara**. A ficha continua só do PO.
- **Item 6.** `quality-assurance/templates/verdict.md` (trilha fix): o formato que o C4 lê (R33/3) fica explícito — `> comando` em linha própria, saída em bloco nas linhas seguintes, `exit <n>` na linha do rótulo. O C4 **não foi flexibilizado**.
- **Item 7.** `kanban.ps1 -Block B-<nnn> -Init` cria a pasta, o `consumption.md` e o `kanban.md` do bloco no passo 2 do `fix plan`; o hook G16 (`subagent-stop.ps1`) os cria na primeira rodada se faltarem (rede).
- **Item 8.** `fix-plan.md` ganha `**Mutações:**` por F-ID no formato do `verify.ps1`; o `-Mode mutation` lê todos os blocos e, sem `**Arquivos tocados:**`, usa `- produção:`/`- teste:` como escopo; o dev o roda depois do `full` do bloco.
- **Itens 9 e 10 — um quadro só.** `kanban.html` e `kanban-html.ps1` **saem do plugin**. O `kanban.ps1` regrava, ao fim de cada rodada (G16) e a cada transição (`mark.ps1`, `close.ps1`), o `## Kanban` e a nova `## Rodadas` do `sprints/<n>/kanban.md` — por tarefa e fase (Plano · Construção · Verificação · Outros), por papel e modelo, e rodada a rodada, **custo = tokens e tempo** — e o `fixes/B-<nnn>/kanban.md` **inteiro** (F-IDs nas colunas do sprint; promovida e devolvida como nota no Registro). `fix-run.md` §Fechamento roda `kanban.ps1 -Block` uma vez depois do `## Fechamento`. Documentos: `templates/kanban.md` (seção Rodadas e variante do bloco), `artifact-ownership.md` §1 (bloco), `project-context.md`, `how-to.md`, `rituals/team-init.md` sem o `kanban.html`.
- **Roteiro mais curto.** `fix-run.md` §Run: 7 443 → 6 383 B (arquivo: 21 771 → 21 451 B), com as regras novas dentro.

#### Por quê

Cada negação custou uma invocação extra ou a sessão fazendo o trabalho do papel (o dev sem `verify`, o PO copiando uma linha, o QA reescrevendo um veredito); o quadro em dois formatos repetia a informação e o gasto da rodada só aparecia no `consumption.md`. As correções saem de roteiro, modelo e script — nada de papel novo nem instância a mais.

#### Quem passa a ser cobrado de forma diferente

- **Dev:** roda o `verify` com o comando completo e sem decoração; reporta a promoção no relatório.
- **Arquiteto:** no run não executa nada — lê e marca "não validado"; escreve `**Mutações:**` e a promoção no mini-plano.
- **QA:** escreve `Antes`/`Depois` no formato que o C4 lê. **PO:** grava `## Destino` na invocação da promoção. **SM/sessão:** `-Init` no `fix plan`, `kanban.ps1 -Block` no fechamento, e copia para o mini-plano a promoção que o dev ou o QA reportou.

#### Conflitos com o processo vigente

Nenhum. A G14 ficou **mais estreita** num ponto (só scripts do plugin) e mais larga noutro (trecho composto). A matriz de propriedade não mudou de dono; o `kanban.md` do bloco é do SM, escrito por script. O `kanban.html` da v3.51 (acima) é revertido por esta entrada.

#### Como saberemos que funcionou

No próximo `fix run`: zero negações G14 ao dev em `verify.ps1` e ao Arquiteto por executar arquivo do scratchpad; `verify mutation` com ok em cada F-ID não promovida; nenhuma F-ID reprovada pelo C4 R33/3 por formato; `consumption.md` e `kanban.md` do bloco existindo desde o `fix plan`; nenhum `Edit`/`Write` negado pela G8 na ficha.

#### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | `Grep "kanban\.html\|kanban-html"` em `RAIZ/`, fora de `CHANGELOG.md`, `plano-plugin-p-plus.md`, v3.51 arquivada e testes que afirmam a ausência | zero fora de `process-changelog.md` (v3.51 e este adendo, histórico), `kanban.ps1:1` e dos testes que afirmam a ausência (`run-check-tests.ps1`); `note.md` limpo | ✅ |
| Extração/remoção | `Length` de `fix-run.md` e do §Run, antes (HEAD) × depois | 21 771 → 21 451 B; §Run 7 443 → 6 383 B | ✅ |
| Entrega | `release.ps1` (C3) | R18 ok (3.51.2 nos três); R17 ok (bloco v3.51 com 13 658 B ≤ 17 920, 5 papéis, 3 entradas); ps1-5.1 ok; ownership ok (62 regras); órfãos ok (47 modelos) | ✅ |

#### Pendente do stakeholder

Reiniciar a sessão (comportamento de agente e guarda mudam). Versão, `CHANGELOG.md` e `note.md` da sessão.
---
## v3.50 — Mudança de layout se prova em render real: navegador headless, 3 fontes × telas, mutação que quebra a medição; e as paradas do `run` fecham no texto (SM + Arquiteto + Dev + QA) — 16/10/2026

**Instrução** (stakeholder, `/review note`, item 2, decisão "Render real" de 16/10/2026; item 4 movido da v3.49): Task que muda layout ou estilo visível exige, no plano, caixas medidas em navegador headless, 3 tamanhos de fonte × as telas relevantes; prova só por estrutura não basta; a mutação tem de quebrar a medição. **Causa medida:** layout (Ionic) provado por CSSOM/seletor passou no plano, no QA e na mutação e quebrou no aparelho (~15,5 M tokens de conserto no piloto).
**Classificação:** formato de documento (plano, veredito, evidência, relatório de entrega) · standard (`implementation-principles.md`) · comportamento de agente (QA decide "interface" e executa a medição). **Sem regra nova** (34): reforça R23 e R26. A R17 abriu esta versão, e não um addendum da v3.49, porque o bloco v3.49 estava na barreira (15 344 de 15 360 B); o item 4 foi **movido** para cá, texto intacto.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/architect/templates/implementation-plan.md` | §3, §6, §9, regra 21, trilha leve | Linha do navegador headless medido; tabela **Render real** (teste × tela × 3 fontes × caixas × "deve falhar se…"); linha fixa de 🔺 GAP (headless ausente); regra 21; leve **nunca** com interface |
| `roles/architect/templates/fix-plan.md` · `roles/architect/README.md` | regra 15 · regra 21 e indicador | Correção de layout: o teste de regressão é de render; sem headless no `developer/context.md` é C7 ✘ e promoção |
| `standards/implementation-principles.md` | §5.1, §6, §7 | Nível **Render**; "mudança de layout se prova em render real"; **V22** (navegador/driver, versão, comando); linha 23 do quadro (Task volta ao dev) |
| `roles/developer/templates/delivery-report.md` | regras | Saída do render em trecho **e** ponteiro; render pulado ou trocado por estrutura é 🔺 GAP |
| `roles/quality-assurance/README.md` · `templates/verdict.md` · `evidence.md` · `scenario.md` | frente 1, `/qa`, trilha leve; tabela **Render real**; cenário | O QA decide se há interface, **executa ou reexecuta** o comando de V22, confere 3 fontes × telas e a mutação sobre a medição; sem render real é ❌ ou 🔺 GAP, nunca ✅; cenário não prova layout; Task "leve" com interface = achado de processo à Planning |
| `roles/scrum-master/process/fix-run.md` · `deliverables/sdd/03-architecture.md` | §Plan passo 4 · Ficha | Ponteiro à regra 15 do `fix-plan.md`; a Ficha passa a V1–V22 |

### Por quê
Estrutura (regra presente, seletor que casa, snapshot) não prova geometria: o navegador pode aplicar a regra e a caixa quebrar mesmo assim. Sem a medição no plano, o QA não tinha o que reexecutar e a mutação sobre uma regra de estilo "matava" sem tocar a caixa; o defeito só aparecia no aparelho do stakeholder, depois de três portões. A leve fica de fora porque a prova exige o navegador medido na §3, que ela não tem.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Arquiteto | Task com interface sem tabela **Render real**, headless medido na §3 e mutação sobre a medição não sai do plano; layout provado por estrutura é achado de processo contra ele |
| Dev | Entrega a saída do teste de render; trocar a medição por teste de estrutura não é decisão dele (🔺 GAP) |
| QA | Em Task com interface, executa a medição e reprova ou abre GAP sem ela; "há interface?" é julgamento dele, por stack |
| SM | Task "leve" com interface devolve-se à trilha plena na Planning |

### Conflitos com o processo vigente
Nenhum (R23 e R26 reforçadas). Trilha leve do Arquiteto ("nunca com interface") e do QA ("se chegou como leve, a render é exigida e vira achado") dizem a mesma coisa pelos dois lados.

### Como saberemos que funcionou
Zero defeito de layout achado pelo stakeholder no aparelho depois do ✅ do QA em Task com interface; todo veredito de Task com interface traz a tabela **Render real** preenchida (conferível em `evidence/<T-ID>.md`).

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| substituição de padrão | `Select-String -List "Render real\|render real\|regra 21\|V22"` em `roles/architect`, `roles/developer`, `roles/quality-assurance`, `standards/implementation-principles.md` | 9 arquivos (os 9 da tabela acima), cada ocorrência lida no contexto | ✅ |
| substituição de padrão | `Select-String "render real \(v3\.49\)"` em `implementation-plan.md` · `Grep "V1–V21"` fora dos changelogs | 0 · 0 (regra 21 marcada v3.50, que o Arquiteto escreveu como v3.49; Ficha de `03-architecture.md` passa a V1–V22) | ✅ (2 resíduos consertados) |
| arquivamento | bloco v3.49 e v3.47 do HEAD × working tree (`git show HEAD:` contra o arquivo, `-ceq`); `git diff HEAD -U0` do changelog | v3.49 igual ao HEAD (o addendum saiu dele; hunks só no índice, no bloco v3.50 e na saída da v3.47); v3.48 igual; v3.47 no arquivo igual ao HEAD; addendum movido sem uma linha diferente | ✅ |
| extração/remoção | `powershell -NoProfile -File scripts/checks/release.ps1` | R17 ok (bloco v3.50 ≤ 15 360 B, 4 papéis, 3 entradas vivas), ps1-5.1, ownership e órfãos ok; R18 falha só por `CHANGELOG.md` ainda na v3.49.0 (a sessão escreve a entrada) | ✅ (R18 esperado) |

### Pendente do stakeholder
**(d) `scripts/checks/plan.ps1`: resultado novo `render`** (Arquiteto; texto em [`proposals-pending.md`](proposals-pending.md) §Item 2); as três propostas do addendum abaixo seguem pendentes. **Achado do QA:** a trilha `fix` não tem tabela **Render real** no veredito, embora a regra 15 do `fix-plan.md` exija o teste de render.

### Addendum — as paradas do `run`: o texto fecha, o instrumento fica proposto (16/10/2026)
**Instrução** (`/review note`, item 4). **Causa medida:** 4 paradas fora da lista fechada (~24,5 h) e ~122 h de máquina suspensa com `.active-run` (71 h sem retomar). **Sem regra nova** (regra mecânica só com guarda).
- `sprint-run.md` §Ordem da fila e §Como o SM verifica: não-paradas listadas; formulário de bloqueio só com a Task 🔴, degrau 1 aberto e fila esgotada; retomada da fila ao reabrir com `.active-run`. R25(c): ponteiro.
- **Achado:** nenhuma regra sobre atualizar o plugin no meio do sprint (`team-update.md` só cobre migração de pastas). Sem regra criada.
- **Indicador:** zero parada fora da lista no próximo `run` real (`waits` > 1 h com Task ⬜ elegível).
- **Evidência (R19):** `release.ps1` ok; `Select-String` de "duas condições" em `sprint-run.md` → 0 (corrigido para "três").
- **Pendente do stakeholder:** (a) hook `Stop` G20, (b) `session-start.ps1` com retomada, (c) `how-to.md` energia — texto e especificação em [`proposals-pending.md`](proposals-pending.md).

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
- Os itens de scripts e hooks da fila entraram nos addenda abaixo; ficam em `note.md` os 5 itens de desenho e medição.

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

### Addendum — as escritas mecânicas da sessão em script (16/10/2026)
**Instrução** (stakeholder): "Pode fazer o 3 que são scripts mecânicos". **Causa medida:** no piloto, a sessão gastou 18 chamadas em quadro e burndown, 50 em `.active-*` e 33 em `consumption.ps1`, a ~400 mil tokens cada. Um `.active-task` gravado fora do formato derrubou a G9. E a sessão, ~40 % do custo, não entrava no registro do time.
**Classificação:** instrumento (`mark.ps1` e `dispatch.ps1` novos, `consumption.ps1 -Session`, G16) · fluxo (`sprint-run.md` passos 3, 7, 8, §Marcador e §Modelo por papel; `fix-run.md` passo 2). **Sem regra nova.**

| Documento | Mudança |
|---|---|
| `scripts/checks/mark.ps1` (novo) | `-Task -To plan\|build\|qa\|blocked\|todo`: troca o marcador no quadro, acrescenta a linha da Série (composição recontada, estimativa inalterada) e a do Registro (no burndown, ou no quadro anterior à v3.44.1). Calcula tudo antes de gravar. Recusa o ✅, que é do `close.ps1 -Apply` |
| `scripts/checks/dispatch.ps1` (novo) | grava o `.active-task` em JSON (e o `.active-executor` no perfil executor), marca pelo `mark.ps1` e imprime o papel efetivo, o `model` do `models.json` e o `run_in_background` (falso no benchmark com `foreground`); `-Clear` apaga os dois marcadores |
| `consumption.ps1 -Session` · G16 | a G16 grava o `session_transcript` em cada linha; com `-Session` (no `close` e na retrospectiva, nunca no hook), o script mede a sessão desde a primeira rodada do destino, deduplicado por `message.id` e `uuid`, e a escreve como linha `sessão` medida, que entra nos Totais. Sem `-Session`, a linha já medida fica |
| `sprint-run.md` · `fix-run.md` · `commands/dev.md` · `artifact-ownership.md` · `templates/consumption.md` · `COVERAGE.md` · `README.md` · `team-update.md` 7j | os passos usam os scripts; a sessão medida no registro |

**Verificação (R19):** `run-check-tests.ps1` → 105 · 0 (12 novos: `mark` em quadro, Série e Registro, a composição recontada, o marcador repetido e o ✅ recusados; `dispatch` com o JSON, o marcador, o modelo do `models.json`, o primeiro plano no benchmark, o executor, o `-Clear` e o dev sem plano; `-Session` com o `uuid` repetido descartado e a linha mantida sem `-Session`); `run-guard-tests.ps1` → 167 · 0; `release.ps1` ok. **Medido:** o `-Session` sobre um transcript real de sessão do piloto (9,4 MB, 418 chamadas) leva 7 s no PowerShell 5.1 e dá 204,6 M processados, coerente com `scripts/metrics`. **Não exercitado:** os três scripts num sprint real.

---
