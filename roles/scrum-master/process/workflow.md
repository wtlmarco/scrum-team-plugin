# Fluxo de Trabalho — Como o trabalho circula entre os papéis

> **Dono:** SM · Complementa [`working-rules.md`](working-rules.md): lá estão as regras, aqui está a mecânica.

## 1. Duas unidades: a **História** e a **Task**

| Unidade | Responde | Dono | Enfoque | Vive em |
|---|---|---|---|---|
| **História** | *que valor o stakeholder recebe* | PO | **só funcional** — regra, protótipo, critério de aceite | arquivo próprio (`.team-project/product-owner/stories/`), indexada pelo Product Backlog; **cópia congelada** em `sprints/<n>/stories/` quando o pacote é aprovado |
| **Task** | *que trabalho o time faz para entregar aquele valor* | SM (quadro) · Arquiteto (o plano dentro dela) | técnico — passos, arquivos, verificação | Sprint Backlog (`.team-project/sprints/<n>/sprint-backlog.md`) |

**O Product Backlog é o índice ordenado das Histórias** (v3.21 — [`artifact-ownership.md` §1d](artifact-ownership.md)); cada uma vive em arquivo próprio. Uma História nasce do SDD, é detalhada quando vai entrar num sprint, e é quebrada em Tasks pelo time na Planning Meeting. **Toda Task pertence a exatamente uma História** (R20); Task sem História é trabalho que ninguém pediu.

A Task carrega ID, título, História de origem, dono, dependências, estimativa, critério de pronto, **evidência esperada**, o **Plano de Implementação** escrito pelo Arquiteto e a **referência aos cenários de teste mapeados pela QA** (lista de IDs de `.team-project/quality-assurance/scenarios/`, novos e regressivos — R30). A convenção de IDs de cada projeto está em `.team-project/scrum-master/context.md` — tipicamente `H-nnn` para História, `T-nnn` para Task, sufixo para quebra (`T-012a`, `T-012b`), e o ID do GAP reusado quando a Task nasce de um GAP.

## 2. Do SDD à entrega — a cadeia

```
`/sm sdd` (SDD funcional — PO: 00, 01, 02 · jornadas e protótipo funcional em HTML — UX)
  └─ ① stakeholder NAVEGA o protótipo e aprova ──▶ SDD técnica (Arquiteto: 03, 04, 05)
       └─ ② aprovada ──▶ Histórias (PO), uma por arquivo ──▶ índice = Product Backlog
            └─ detalhamento da História: regras · especificação de tela (UX) · critérios de aceite
                 └─ `/sm sprint prepare`: candidatas até a DoR (Histórias · telas · cenários de teste)
                 └─ Planning Meeting (`/sm sprint plan`) ──▶ Sprint Backlog fechado
                      └─ time quebra em Tasks, estima e corta na capacidade (§5e)
                           └─ pacote de abertura: Sprint Backlog + critérios + protótipo do sprint
                                └─ ③ stakeholder NAVEGA e aprova o pacote — o sprint arranca
                                     └─ `/sm sprint run`: Arquiteto escreve o Plano de Implementação
                                          └─ dev constrói ──▶ QA dá veredito ──▶ SM fecha a Task
                                               └─ Sprint Review (`/sm sprint review`): ④ aceite por História
                                                    └─ Sprint Retrospective
```

Os quatro portões numerados são os gates de §8. **O detalhamento da História é sempre e apenas funcional** — nenhuma decisão técnica entra ali; ela nasce na Task, no Plano de Implementação. **O ③ é aprovado depois da Planning, em lote, sobre um pacote navegável** (R20 · R25 · §5e): o stakeholder tem **dois pontos de contato por sprint** — a abertura e a Review —, e entre eles o time roda a fila sozinho (§5g).

### 2a. Ciclo da Task

| # | Etapa | Quem | Comando | Saída |
|---|---|---|---|---|
| 0 | Onboarding do projeto *(uma vez, projeto novo ou retomado)* | SM coordena, os seis papéis participam | `/sm onboarding` | Entendimento alinhado, contexto preenchido, quadro aberto (R14 · §5a) |
| 0b | Brainstorm *(só ideia sem documentação)* | SM facilita · fase 1: stakeholder + PO + UX · fase 2: + Arquiteto | `/sm brainstorm <ideia>` (orquestrado pela sessão; fora da cadência do sprint) | Brief funcional fechado, pronto para o SDD (R15 · §5b) |
| 0c | **Transição para o SDD** *(depois do brainstorm — ideia nova — ou do `/po analyze` com decisão — área já documentada)* | SM orquestra pela sessão · PO + UX (SDD funcional, jornadas, protótipo) → **① formulário** → Arquiteto (SDD técnico da fatia) → **② formulário** → PO (Histórias) | `/sm sdd [<tema>]` (§5h) | SDD funcional e técnico da fatia **aprovados (① e ②)** e Histórias no Product Backlog, prontas para o `prepare`. Os formulários dos portões são disparados pelo próprio `sdd` |
| 1 | História criada a partir do SDD *(dentro do `/sm sdd`, etapa 5; ou avulsa, para requisito já aprovado)* | PO | `/po story <ID>` | Arquivo da História criado, com o valor declarado, e linha nova no índice do Product Backlog |
| 2 | Detalhamento da História *(quando ela candidata a um sprint)* | PO, com o UX nos protótipos | `/po story <ID>` (modo detalhe) · `/ux journey` · `/ux screen <ID>` | Regras, protótipos e critérios de aceite — só funcional |
| 2b | **Preparação do sprint** — leva as candidatas até a DoR | SM coordena · PO, UX e QA produzem em paralelo · Arquiteto (varredura técnica, opcional) | `/sm sprint prepare` (dispara `/po story` modo detalhe · `/ux journey`/`screen` · `/qa scenarios create` · `/arc question`) | Lista de candidatas com a **DoR-a** verificada (§3a), **gravada em `.team-project/scrum-master/context.md` §"Candidatas do próximo sprint"** — é o que o `plan` lê. **Sem aprovação do stakeholder** — o ③ é do `plan` |
| 3 | Planning Meeting | SM conduz, o time inteiro participa | `/sm sprint plan` | Sprint Backlog: Histórias candidatas quebradas em Tasks, estimadas, dentro da capacidade; **pacote de abertura montado** (§5e) |
| 3b | **Pacote de abertura — portão ③ em lote** | UX costura · PO junta · SM submete · **stakeholder navega e aprova** | passos 9–11 de `/sm sprint plan` · `/ux prototype sprint <n>` | Pacote aprovado e datado: é o ③ de **todas** as Histórias do sprint, e o sprint arranca (R25 · §5g) |
| 4 | Plano de Implementação | Arquiteto | `/arc plan <Task>` (dentro de `/sm sprint run`) | Plano dentro da Task, citando a especificação de tela e as seções de standard. Persistido em `.team-project/sprints/<n>/plan/` |
| 5 | Construção | dev | `/dev <Task>` | Código + testes + relatório de entrega |
| 6 | Gap durante a construção | dev → Arquiteto | `/arc question` → `/dev gap` | Decisão do Arquiteto, dev retoma |
| 7 | Validação | QA | `/qa <Task>` | Veredito ✅/⚠️/❌ com evidência — **inclui sempre, na mesma invocação, a checagem de aderência de execução ao plano e de completude/correção do standard citado** (§4a) **e o resultado dos cenários de teste mapeados na Planning, incluindo os regressivos aplicáveis** (R30); a Task não fecha sem essa cobertura |
| 8 | Fechamento da Task | SM | `/sm close <Task>` (feito pelo `/sm sprint run` quando o veredito é ✅ **e** o campo "Documentos vivos (R12)" do veredito está "atualizados" — [`sprint-run.md`](sprint-run.md) passo 7 —; ou manual) | Quadro + documento de status atualizados — **fechamento técnico, não aceite**. Linha nova no Registro de transições do Sprint Backlog (De: 🟪, Para: ✅) e ponto novo no burndown do sprint (R24) |
| 9 | Sprint Review | PO demonstra, stakeholder decide | `/sm sprint review` | História aceita / com ressalva / rejeitada · gaps e débitos ao backlog |
| 10 | Sprint Retrospective | SM conduz | `/sm sprint close` | Retrospectiva + fechamento do sprint (§5c · §5e) |

**`/sm sprint run`** encadeia as etapas 4→5→6→7→8 — a fila do sprint corrente, ou uma Task com `sprint run <T-ID>` — e para no primeiro problema **daquela Task**. **O roteiro (pré-condições, ordem, retomada, passos por Task, fechamento) é fonte única em [`sprint-run.md`](sprint-run.md)** e não se repete aqui. Entre a aprovação do pacote e a Sprint Review o time opera sem acionar o stakeholder (R25 · §5g). **Não existem mais os modos `/team cycle`, `/team plan`, `/team build`, `/team qa`** (v3.34): a granularidade por etapa é a dos comandos de papel — `/arc plan <Task>`, `/dev <Task>`, `/qa <Task>`, `/sm close <Task>` (estes não conferem o pacote aprovado: quem o confere é o `run` e o SM, R20 · R25).

**A cadência completa, toda do `/sm`, é `brainstorm → sdd → prepare → plan → run → review → close`; o sprint tem cinco modos, todos do SM:** `/sm sprint prepare` → `sprint plan` → `sprint run` → `sprint review` → `sprint close` (mais `board` e `close <T-ID>` de apoio). `/sm review` segue como **alias** de `sprint review` (decisão no changelog do processo); os documentos usam `sprint review`.

As etapas 0, 0b e 0c são **anteriores à cadeia** e não se repetem por Task: o onboarding acontece uma vez por projeto (R14); o brainstorm, uma vez por ideia sem documentação (R15), e alimenta o SDD funcional, não o substitui; a 0c (`/sm sdd`) acontece uma vez por ideia/evolução e entrega as Histórias que o `prepare` recebe. A etapa 2b (`sprint prepare`) acontece **uma vez por sprint**, antes da Planning, e **não sobe ao stakeholder**; a etapa 3b acontece **uma vez por sprint**, entre a Planning e a primeira Task em construção.

**Checkpoint entre fases heterogêneas (R29).** Quando a fila de correções (`.team-project/note.md`, §5g) ou o ciclo de Tasks chega a um estado verde (lint/build/teste passando) e a próxima etapa muda de natureza — por exemplo, entrar no **Ciclo de uma entrega** de §5d, que envolve build nativo e release —, a sessão que orquestra fecha ou `/clear` antes de abrir a etapa seguinte: ela não precisa herdar o histórico de diagnóstico de uma fase que já fechou.

**O aceite não está no fechamento da Task.** A etapa 8 encerra o trabalho técnico com o veredito do QA; quem diz que o valor chegou é o aceite por História, na Sprint Review (R21 · etapa 9) — o PO conduz, o stakeholder decide. Task fechada dentro de uma História rejeitada volta ao sprint seguinte junto com as demais da mesma História.

## 3. Definition of Ready

### 3a. DoR da História — pode entrar na Planning Meeting?

A DoR tem **duas metades**, porque uma delas só é cumprível *dentro* da Planning (v3.34). A **DoR-a** é o que o `/sm sprint prepare` verifica **antes** da Planning; a **DoR-b** é o passo 3 da própria Planning.

**DoR-a — verificada no `prepare` (§5e "Preparação"):**

- [ ] Rastreia a um requisito do SDD funcional aprovado (portão ①) **e o SDD técnico da fatia está aprovado (portão ②)** — a História vem de `/sm sdd` (§5h); História de requisito sem ② não entra no `prepare` (portões ① e ② de §8). *Projeto retomado:* o SDD existente, reconhecido no onboarding (R14), vale como aprovado; sem SDD, `/sm sdd`
- [ ] O valor ao stakeholder está escrito em uma frase — o que ele passa a conseguir fazer
- [ ] Regras funcionais escritas, sem decisão técnica embutida
- [ ] **História com interface:** **especificação de tela** do UX existente, com os seis estados e os critérios de acessibilidade. É ela que o UX costura no protótipo do sprint depois do corte (§5e Planning, passo 10) — costurar não é reespecificar
- [ ] Critérios de aceite escritos pelo PO e **verificáveis**
- [ ] Detalhamento funcional **completo**, com os critérios prontos para entrar no **pacote de abertura** que o stakeholder aprova depois do corte de capacidade (portão ③ em lote). A História entra na Planning com o ③ ainda pendente, e **nenhuma Task dela vai à construção antes do pacote aprovado** (R20 · R25 · §5e)

**DoR-b — cumprida na Planning (passo 3, §5e):**

- [ ] **Bloqueios varridos** — dependência, lacuna e risco conhecidos sanados na Planning, ou a História não entra (R25). A varredura técnica opcional do `prepare` adianta este item, mas **não o dá por cumprido**

O passo 2 da Planning **não reconfere a DoR-a**: confirma que a História consta como "DoR-a verificada" em `.team-project/scrum-master/context.md` §"Candidatas do próximo sprint" (gravada pelo `prepare`) e devolve ao `prepare` a que não consta.

### 3b. DoR da Task — pode entrar em construção?

- [ ] Pertence a uma História que passou pela DoR da História (R20)
- [ ] O **pacote de abertura do sprint** está aprovado e datado no Sprint Backlog — é ali que o ③ desta História aconteceu (R25 · §5g)
- [ ] Origem rastreada (GAP registrado ou critério de aceite da História)
- [ ] Estimativa registrada na unidade declarada em `.team-project/README.md` (§5e)
- [ ] Dependências resolvidas ou explicitamente aceitas como risco
- [ ] Plano de Implementação existente, dimensionado para uma unidade de trabalho (R2)
- [ ] Segurança endereçada **no plano** quando a Task é sensível (R11)
- [ ] **Cenários de teste mapeados pela QA** — novos (do critério de aceite da Task) e regressivos aplicáveis (ou "nenhum aplicável", com o motivo) — referenciados no Sprint Backlog (R30)
- [ ] Comandos de verificação executáveis neste ambiente, ou a limitação declarada (R7)

## 4. Definition of Done

### 4a-i. DoD da Task — o trabalho técnico acabou?

- [ ] Todos os passos do plano concluídos, ou os pendentes explicitamente reportados (R5)
- [ ] Testes do plano escritos e passando; build sem avisos
- [ ] Cobertura dentro do limiar declarado no projeto, sem regressão
- [ ] Registros de infraestrutura feitos (injeção de dependência, migration, mapeamento de erro), conforme a stack
- [ ] Isolamento entre escopos preservado e coberto por teste quando aplicável
- [ ] Veredito ✅ do QA com saída real de comando (R7)
- [ ] **Frente 2 do veredito cobre os dois objetos** — aderência de execução ao plano e completude/correção do standard citado (§4a); Task sem essa dupla cobertura não fecha
- [ ] **Cenários mapeados da Task executados**, incluindo os regressivos aplicáveis, com resultado registrado no veredito (R30)
- [ ] Documentos de qualidade e evidências atualizados pelo QA; documento de status pelo SM (R12)

**Como o SM confere o fechamento (`/sm close`).** Percorre [`working-rules-index.md`](working-rules-index.md) — uma linha por regra, com o que conferir —, **não** o `working-rules.md` inteiro (71 KB). O texto completo de uma regra só é aberto quando a linha do índice aponta violação ou dúvida.

### 4a-ii. DoD da História — o valor chegou?

- [ ] Todas as Tasks da História fechadas pela DoD da Task
- [ ] Cada critério de aceite da História tem evidência registrada pelo QA apontando a Task que o cumpre
- [ ] Demonstrada na Sprint Review
- [ ] **Aceite registrado** (R21) — conduzido pelo PO, com a decisão do stakeholder por História
- [ ] Gaps e débitos levantados na Review estão no Product Backlog com dono

## 4a. Aderência de execução e de standard — as duas, na frente 2 do QA

A verificação de aderência não é sob demanda nem do Arquiteto: acontece **dentro de `/qa <Task>`, na frente 2, ao fim de toda Task construída pelo dev** — a Task não fecha sem ela (DoD §4a-i). **É a única verificação de aderência do processo** — não existe modo do Arquiteto que a faça. Dois objetos, sempre os dois no mesmo veredito:

| Objeto | Pergunta | Contra o quê |
|---|---|---|
| **Aderência de execução ao plano** | cada passo do Plano de Implementação foi executado como escrito — assinatura, anel/camada, arquivo, nomenclatura, registro de infra? | o **Plano de Implementação vigente** |
| **Completude e correção do plano** | o plano **omitiu** uma seção de standard que a Task exigia? **citou a seção errada** para o que a Task faz? a seção citada está **de fato aplicada** no código? | o normativo `${CLAUDE_PLUGIN_ROOT}/standards/` e a Task |

**Por que o QA, e não o Arquiteto — motivo registrado, custo.** O Arquiteto é o papel mais caro do time (§5c). Conferir se o código seguiu um plano já escrito é mecânico — passo a passo, contra um documento fechado — e não exige o julgamento de desenho que só o Arquiteto tem; fazer o modelo mais caro do time reexecutar essa comparação em toda Task multiplicava o custo sem ganho de rigor. A independência não se perde: o QA continua não sendo o autor do plano, e é essa distância — a mesma que já sustentava o objeto 2 desde a v2.4 — que garante que a checagem de execução não vira autoconferência do próprio Arquiteto.

**Rota de volta, pelo tipo de defeito — nunca a mesma para os dois:**

| Defeito | Volta para | Comando |
|---|---|---|
| **Aderência de execução** — código diverge do que o plano escreveu (passo pulado, arquivo errado, nomenclatura trocada, registro de infra faltando) | **dev**, direto — o plano estava certo, a execução não seguiu | `/dev resume` |
| **Defeito do plano** — omissão de seção de standard, seção citada errada, passo inexequível ou ambíguo | **Dois destinos, nunca um só**: **Arquiteto** desbloqueia a Task (🔺 GAP — só ele decide desenho) **e**, em paralelo, **achado de processo ao `/review`** — o GAP resolve esta Task, o achado evita a próxima repetir a mesma lacuna | `/arc question` → plano revisado → dev retoma · **+** achado de processo → `/review` |
| **Defeito do próprio `standards/`** | **Arquiteto**, por `/review` (R16) | — |

**Como o SM verifica que a frente 2 cobriu os dois objetos.** O veredito traz **duas tabelas, sempre as duas**:
- **passo do plano × conforme** — uma linha por passo do Plano de Implementação, com o estado (conforme / divergente, e o que diverge) — objeto 1;
- **seção exigida pela Task × seção citada no plano** — quatro estados por linha: citada e aplicada (ok); citada e divergente do código (**reprovação**, R16); exigida pela Task e ausente do plano (**rota dupla**: 🔺 GAP → `/arc question` desbloqueia a Task **e** achado de processo → `/review` corrige o hábito); citada errada para o que a Task faz (mesma rota dupla) — objeto 2.

Veredito que traz só uma das duas tabelas não cobriu os dois objetos — o SM registra como achado de processo contra o veredito, do mesmo jeito que já registrava quando só a tabela do objeto 2 aparecia sozinha.

## 5. Cerimônias

| Cerimônia | Quando | Comando | Duração alvo |
|---|---|---|---|
| Onboarding do projeto | projeto novo ou retomado, antes do primeiro sprint | `/sm onboarding` | resposta única + registro (§5a) |
| Brainstorm de descoberta | ideia nova cuja área não tem documentação (visão / requisitos / fluxos) | `/sm brainstorm <ideia>` | rodadas até ponto fixo (§5b) |
| Refinamento funcional | ideia nova em área já documentada | `/po analyze <ideia>` | resposta única |
| **Transição para o SDD** | depois do brainstorm (ideia nova) ou do `/po analyze` (área documentada); antes do `prepare` | `/sm sdd [<tema>]` | SDD funcional e técnico aprovados (①②) + Histórias no Product Backlog (§5h) |
| **Protótipo funcional** | dentro do `/sm sdd`, antes do portão ① | `/ux prototype` (despachado pelo `sdd`) | HTML navegável ([`deliverables/prototype/`](../../../deliverables/prototype/README.md)) |
| Escrita e detalhamento de História | História nasce do SDD; é detalhada quando candidata a um sprint | `/po story <ID>` | 1 História |
| **Preparação do sprint** | antes da Planning, quando há candidatas | `/sm sprint prepare` | candidatas com a DoR verificada; não sobe ao stakeholder (§5e) |
| **Planning Meeting** | abre cada sprint | `/sm sprint plan` | Sprint Backlog fechado (§5e) |
| Daily | início de cada sessão | `/po status` | 6 linhas |
| Refinamento técnico | antes de construir uma Task | `/arc plan <Task>` | 1 plano |
| Validação | ao fim de cada Task | `/qa <Task>` | veredito com evidência |
| **Pacote de abertura do sprint** | logo depois da Planning, antes de a construção começar | `/sm sprint plan` passos 9–11 + `/ux prototype` (costura do sprint) | Sprint Backlog fechado + critérios de aceite + protótipo navegável, **navegados e aprovados pelo stakeholder** — é o **③ em lote** (§5e · §5g) |
| **Execução do sprint** | entre o pacote aprovado e a Review | `/sm sprint run` | fila fechada Task a Task, com veredito do QA e fechamento técnico (§5g) |
| **Sprint Review** | fecha cada sprint, antes da retrospectiva | `/sm sprint review` | veredito por História + gaps e débitos, ambos ao Product Backlog na mesma sessão (§5e · §5g) |
| **Sprint Retrospective** | fecha cada sprint, depois da Review | `/sm sprint close` | [template](../templates/retrospective.md) · mede o footprint do processo (§5c) |
| Auditoria cruzada | a cada 3 sprints | `/qa audit` | achados, sem correção |
| Acordo facilitado | questão que atravessa papéis e precisa de **uma** posição | `/sm agreement <questão>` | o SM chama **só os papéis que a questão toca**, consolida uma recomendação e registra a divergência que sobrou |
| Melhoria de processo | quando o stakeholder instrui uma mudança de método | `/review <instrução>` | documento do papel atualizado + entrada no changelog do processo |
| Revisão de processo | a cada 3 retrospectivas, ou quando uma métrica estoura | `/review metrics` | **uma** proposta de mudança, com o indicador que a valida; é também o giro **Act** do ciclo de eficiência (§5c) |
| Curadoria do processo | quando dois papéis mudam algo que se contradiz | `/review` | consolidação do changelog e escalação do que ficou inconsistente |
| Auditoria de processo | a cada replicação, ou quando o time cresce | `/review audit` | achados de coerência interna de `${CLAUDE_PLUGIN_ROOT}/` |
| Lançamento de entrega | quando o stakeholder fecha uma versão | branch + PR + bump de `version`; cliente: `/team update` | entrada no `CHANGELOG.md` (§5d · R18) |


## 5a–5h. Cerimônias com roteiro próprio — onde estão

O corpo destas seções saiu deste arquivo em v3.34 para que quem só precisa do núcleo (DoR, DoD, gates, escalação) não pague 94 KB. **A numeração não mudou.**

| Seção | Assunto | Arquivo | Quem lê |
|---|---|---|---|
| §5a | Onboarding (R14) | [`workflow-ritos.md`](workflow-ritos.md) | `/sm onboarding` |
| §5b | Brainstorm de descoberta (R15) | [`workflow-ritos.md`](workflow-ritos.md) | `/sm brainstorm` |
| §5h | **Transição para o SDD** (R15) | [`workflow-sdd.md`](workflow-sdd.md) | `/sm sdd` |
| §5c | Ciclo de eficiência (PDCA) | [`workflow-processo.md`](workflow-processo.md) | `/review metrics`, retrospectiva |
| §5d | Atualização e lançamento do plugin | [`workflow-processo.md`](workflow-processo.md) | lançamento de versão |
| §5e | O sprint: Preparação · Planning · Review · Retrospectiva | [`workflow-sprint.md`](workflow-sprint.md) | `/sm sprint prepare\|plan\|review\|close` |
| §5f | Burndown (R24) | [`workflow-sprint.md`](workflow-sprint.md) | `/sm board`, `/sm close` |
| §5g | Ciclo do sprint: pacote, bloqueio em dois degraus, manutenção (R25) | [`workflow-sprint.md`](workflow-sprint.md) | `/sm sprint plan`, bloqueios |
| — | Roteiro do `/sm sprint run` | [`sprint-run.md`](sprint-run.md) | `/sm sprint run` |


## 6. Escalação

```
dúvida de implementação  ──▶ Arquiteto        (dev nunca decide sozinho)
dúvida de regra/fluxo    ──▶ PO
dúvida de tela/jornada   ──▶ UX
prioridade, prazo, plano ──▶ PO               (detém o plano de entrega — §6a)
bug relatado pelo stakeholder ──▶ PO classifica (defeito · escopo · dúvida de uso) ──▶ defeito aciona a QA (§6a · v3.13)
bug achado pelo próprio time ──▶ direto ao registro da QA (dev: 🔺 GAP · QA: achado próprio · Arquiteto/UX: §6b) — não passa pelo PO (§6a · v3.14)
capacidade, fila, bloqueio ─▶ SM              (quanto cabe, em que ordem)
lacuna de especificação  ──▶ PO ──▶ stakeholder (opções descritas + recomendação + pedir mais contexto, em formulário — R22)
decisão estratégica      ──▶ stakeholder       (stack, provedor, custo, risco aceito)
exceção a um padrão      ──▶ stakeholder ──▶ ADR escrita pelo Arquiteto
defeito em ${CLAUDE_PLUGIN_ROOT}/standards/ ──▶ Arquiteto (dev: 🔺 GAP · QA: achado de processo) ──▶ /review   (R16)
achado que atravessa papéis ──▶ o QA roteia pelo objeto da dúvida (§6b)
```

### 6a. O canal do stakeholder é o PO

O stakeholder **não consulta os seis papéis**. Ele se relaciona com o **PO**, que controla as suas demandas e responde por **valor, escopo, prioridade, prazo, plano de entrega, status e defeito que ele reporta** (`/po bug <relato>` avulso, ou a fila `.team-project/note.md` tratada em lote por `/po note` — v3.13); e pode levar questão **técnica ao Arquiteto** ou **de tela ao UX** diretamente, quando quiser. **Bug não abre canal novo:** o PO classifica o relato (defeito · mudança de escopo disfarçada · dúvida de uso) e só aciona a **QA** quando é defeito — não existe caminho direto stakeholder→QA.

**A bifurcação do bug é pela origem do achado, não pela gravidade nem pelo tipo (v3.14).** Bug que o **stakeholder relata** entra pelo PO, como acima. Bug que o **próprio time acha durante o trabalho** — QA numa validação, dev implementando (🔺 GAP), Arquiteto ou UX num achado roteado pelo objeto da dúvida (§6b) — vai **direto ao registro da QA**, pelos canais que já existem, e **não passa pelo PO**: ele não é gargalo de achado técnico interno. A diferença está no que o PO agrega — julgar se o que o stakeholder chama de "bug" é de fato defeito, contra o critério de aceite aprovado — e esse julgamento só existe no relato que vem de **fora** do time; achado interno já chega com a evidência `arquivo:linha` e a classificação óbvia, então mandá-lo dar a volta pelo PO seria repasse sem agregar nada.

**O canal não muda de dono — o que muda é a frequência do gate (R25 · §5g).** O PO continua sendo o canal. O stakeholder é acionado em **dois momentos por sprint**: a aprovação do **pacote de abertura** (o ③ em lote) e a **Review** (o ④, por História). Fora deles, sobe a ele o que o **degrau 2** manda subir — bloqueio que PO e Arquiteto não fecharam, e decisão estratégica, que vai direto —, sempre na forma fixa de R22. Tudo o mais é igual: `/po status` responde a qualquer momento, `/po bug` e `/po note` continuam abertos, e a fila `.team-project/note.md` alimenta a manutenção (§5g). **Execução contínua é ausência de interrupção, não ausência de informação nem de aprovação**: time que para de reportar "porque o sprint está rodando" está violando §6a, não cumprindo R25; e time que leva ao stakeholder uma dúvida que o par PO+Arquiteto resolveria devolveu pela janela o gate que R25 agregou na fronteira do sprint.

**Isso não tira do PO a visão de capacidade.** Defeito interno que vira Task segue o roteiro comum de GAP (§5e "Durante o sprint"): entra no Product Backlog e concorre na Planning seguinte, ou — se bloqueia História já no sprint — vira Task da mesma História, com "o que saiu para caber" registrado no quadro. Nos dois casos o PO enxerga o efeito no plano de entrega porque lê o Product Backlog e o Sprint Backlog em `/po status` (`roles/product-owner/README.md`) — não precisa de um segundo canal de aviso para saber que capacidade foi consumida.

O **SM não é canal de demanda** — é **processo, organização e eficiência**, e **facilitador de todos os envolvidos**. O stakeholder o encontra em três lugares: nos **rituais do Scrum**, que o SM gere; no **`/sm agreement`**, quando uma questão atravessa papéis e precisa de uma posição única; e na **cobrança dos portões** que dependem dele. O `/review` — aperfeiçoamento do processo — é do SM e roda só no repositório-fonte do plugin.

**O que mudou de dono, e por quê.** Prazo, planejamento e status eram do SM e passaram ao **PO**: quem ordena o Product Backlog por valor × risco e é dono das Histórias é quem pode dizer **quando o valor chega**. Ao SM fica a pergunta vizinha e diferente — **quanto cabe**: capacidade observada, fila, dependência e bloqueio. Um diz *o que entra e quando sai*; o outro, *se cabe*.

### 6b. Achado que atravessa papéis — o QA roteia pelo objeto

Não há orquestrador. O QA classifica o achado pelo **objeto da dúvida** e o entrega ao dono:

| A dúvida é sobre… | Vai para | Comando |
|---|---|---|
| regra, valor, escopo ou critério de aceite | **PO** | `/po` |
| desenho, contrato, camada ou seção de standard | **Arquiteto** | `/arc question` |
| jornada, tela, usabilidade ou acessibilidade | **UX** | `/ux` |
| o achado toca dois donos e o QA **não consegue** classificar | **SM**, que facilita o acordo | `/sm agreement` |

**Quem recebe e não é dono devolve** — dizendo de quem é. Devolução não é recusa: é a classificação sendo corrigida por quem tem o contexto. Errar a rota custa uma devolução; reunir seis papéis para não errar custa muito mais.

**A origem do achado não muda o degrau.** Quando o achado nasce de um defeito que o PO acionou (relato do stakeholder, §6a), o QA investiga e roteia pela mesma escada de sempre — construção, outro dono, ou visão especialista do Arquiteto — só registrando `Origem: stakeholder` em `pending.md`. O canal de entrada muda; a classificação pelo objeto da dúvida, não. **É esta a escada que o achado interno (§6a) sempre seguiu** — bug que o próprio time acha entra direto aqui, com `Origem: time`, sem o passo extra do PO.

**Por que não há um orquestrador único:** o achado de degrau 2 é, com frequência, *"o requisito está errado ou a implementação está?"* — e o PO é **parte** nessa pergunta. Pedir a ele que conduza o julgamento do próprio artefato contraria o mesmo princípio que sustenta a frente 2 do QA (§4a: *um autor não audita a própria omissão*) e a regra de que o dev não revisa os próprios normativos. Quando é preciso reunir posições, quem facilita é o **SM**, que não é dono de requisito, desenho nem evidência.

Nenhum agente devolve pergunta ao stakeholder sem antes tentar resolvê-la no papel correto (R9) — e, dentro do sprint, sem antes passar pelo **degrau 1** de R25 (PO e Arquiteto), salvo decisão estratégica, que vai direto (§5g). **Exceções declaradas:** no `brainstorm` (§5b), no passo 5 do `onboarding` (§5a), na **aprovação do pacote de abertura** (portão ③, §5e) e na **Sprint Review** (portão ④) o stakeholder é participante — o diálogo direto ali é co-criação ou aceite, não escalação. **A decisão de cada portão (①②③④), porém, é resolvida em formulário** (R22, estendido na v3.34): *aprovar · aprovar com ajuste · reprovar · pedir mais contexto* — no ④, **uma pergunta por História**; a **navegação do protótipo acontece fora do formulário**, antes dele. O que sobe a ele fora desses momentos vem na forma fixa de R22 — opções descritas, recomendação e a via de pedir mais contexto, **resolvida em formulário pela sessão que orquestra**, não em texto corrido.

**Quando a dúvida atravessa papéis**, use `/sm agreement <questão>`: o SM identifica **quais papéis a questão toca**, chama só esses, consolida **uma** recomendação e registra a divergência que sobrou. Não é broadcast — reunir os seis para uma questão de dois é desperdício (R3). **Acordo não transfere a decisão**: o dono do assunto continua decidindo no seu domínio, e o que sobra de divergência sobe ao stakeholder.

## 7. Sequenciamento

1. **Uma Task em construção por dev** (R1). Com um único dev, o Sprint Backlog é fila, não board paralelo.
2. **O paralelismo é entre papéis** — dev na Task *n*, Arquiteto planejando a *n+1*, PO detalhando a História do sprint seguinte.
2a. **Paralelismo de papéis pesados tem limite, fora dos fluxos que já o preveem de propósito.** Quem orquestra evita disparar **três ou mais papéis pesados** (Arquiteto, UX, e qualquer outro que esteja fazendo verificação real custosa — harness completo, chamada real a API externa) **simultaneamente**, porque isso empilha picos de consumo de tokens/tempo na mesma janela e contribui para estourar o limite de taxa da conta. **Não revoga** o paralelismo já desenhado deliberadamente em fluxos como o `brainstorm` (§5b — fase 1 com PO+UX simultâneos, fase 2 com o Arquiteto entrando logo em seguida) e o `sprint prepare` (§5e — PO, UX e QA em paralelo, mais a varredura do Arquiteto, que é opcional): esses continuam como estão. **Como o SM verifica:** nenhuma leva de disparo do orquestrador soma três ou mais `agents/<papel>.md` pesados simultâneos fora de um fluxo que já prevê esse paralelismo por desenho (`brainstorm`, `sprint prepare`); ocorrência fora desses fluxos é achado de processo, roteado a quem orquestrou.
3. **Task cabe em uma unidade de trabalho** (R2); acima disso, quebra em `<ID>a`/`<ID>b` — nunca estourando a fronteira da História.
4. **Passos ordenados para manter o repositório íntegro** no maior número de pontos intermediários (R5).
5. **Uma migration de banco por Task**; Tasks que compartilham migration viram uma Task só.
6. **Interrupção é estado** — o relatório diz onde parou; a retomada continua dali. Sprint que termina com Task em construção devolve a Task ao Product Backlog junto com a História.

> Se o time tiver **mais de um dev**, reative a regra de faixas: no máximo uma faixa por dev, com conjuntos de arquivos **disjuntos**; havendo interseção, serialize e registre o motivo; migration nunca em paralelo; arquivo de configuração compartilhado pertence a uma faixa por sprint.

## 8. Gates de qualidade (não negociáveis)

**Nenhum gate abaixo é dispensável.** Parte do texto dos gates cita seções que migraram: §5a–5b em [`workflow-ritos.md`](workflow-ritos.md), §5c–5d em [`workflow-processo.md`](workflow-processo.md), §5e–5g em [`workflow-sprint.md`](workflow-sprint.md) (numeração inalterada). Dois — o **③** e o **④** — mudam de **forma e de momento**, nunca de dono: o ③ é aprovado pelo stakeholder **em lote, depois da Planning**, sobre o **pacote de abertura do sprint** (Sprint Backlog fechado + critérios de aceite + protótipo navegável + `planning.md`), em vez de História por História antes dela; e o ④ é o **aceite por História na Review**, que o PO conduz e o **stakeholder decide** (R21 · R25 · §5e · §5g). As duas linhas estão marcadas na tabela. **A decisão dos quatro portões do stakeholder (①②③④) é tomada em formulário** — *aprovar · aprovar com ajuste · reprovar · pedir mais contexto*, uma pergunta por História no ④ — depois de o stakeholder navegar o que há para navegar (R22). **Todo o resto é incondicional** — o ①, o ②, e cada gate de qualidade técnica (plano, aderência de execução e standard, build e testes, segurança, documentação, evidência): nada dispensa evidência real (R7) nem gate técnico, pela mesma condição de guarda-corpo que R23 impõe ao modo leve. Gate marcado como dispensado citando o ciclo do sprint é achado de processo — **o ciclo do sprint agrega gates funcionais na fronteira do sprint; não remove nenhum**.

| Gate | Bloqueia | Responsável | Regra |
|---|---|---|---|
| Onboarding concluído | `sprint prepare` e a primeira Planning Meeting do projeto | SM | R14 |
| Ideia sem documentação passou por `brainstorm` | primeiro documento do SDD daquela área | SM | R15 |
| **Protótipo funcional em HTML existe e cobre os fluxos principais** | o portão ① | UX | R8 · R15 |
| **① SDD funcional (`00`,`01`,`02`) aprovado pelo stakeholder, com o protótipo NAVEGADO** | primeira escrita do SDD técnico (`03`,`04`,`05`) | PO e UX apresentam · SM verifica · **o formulário é disparado pelo `/sm sdd`** (§5h · R22) | R15 · §5b |
| **② SDD técnico aprovado** | escrita da primeira História daquela área | Arquiteto apresenta (dentro do `/sm sdd`) · SM verifica · **o formulário é disparado pelo `/sm sdd`** (§5h · R22) | §5b |
| **③ Detalhamento da História aprovado pelo stakeholder — em lote, no pacote de abertura do sprint**, depois da Planning | **entrada de qualquer Task do sprint em construção** | PO apresenta · UX costura o protótipo do sprint · SM submete e registra | R20 · R25 · §3a · §5e Planning, passos 9–10 |
| **Especificação de tela existe** *(História com interface)* — com os seis estados e os critérios de acessibilidade | entrada da História na Planning (DoR — §3a) | UX | R8 |
| **Protótipo navegável do sprint existe, cobre as Histórias que entraram e atravessa um fluxo ponta a ponta** | a aprovação do pacote de abertura, e portanto o arranque do sprint | UX | R25 · §5e Planning, passo 10 |
| **`planning.md` declara o que veio da Review anterior e não entrou, com o motivo** | a submissão do pacote ao stakeholder | SM escreve · PO fornece a priorização | R25 · §5e Planning, passo 9 |
| **Bloqueio passou pelo degrau 1 (PO + Arquiteto)** antes de subir ao stakeholder — exceto decisão estratégica, que vai direto | a escalação ao stakeholder dentro do sprint | SM registra o degrau | R9 · R25 · §5g |
| Task pertence a uma História com **DoR-a** verificada no `prepare` (§3a); a **DoR-b** é o passo 3 da Planning | quebra na Planning | SM | R20 |
| Estimativa registrada na unidade do projeto | construção | SM | R2 · §5e |
| Plano de Implementação existe | construção | Arquiteto | R8 |
| Plano traz o **ambiente medido** (comando + saída — próprias ou do `operator`, com o caminho do log bruto), os comandos citados validados naquela versão, e parada incondicional para pré-requisito **ausente** | construção | Arquiteto | R26 |
| Plano cita a seção de `${CLAUDE_PLUGIN_ROOT}/standards/` que a mudança de engenharia toca | construção | Arquiteto | R16 |
| **Cenários de teste (novos e regressivos) mapeados por Task, referenciados no Sprint Backlog** | construção | QA | R30 |
| **Aderência de execução ao plano**, e seção de standard **exigida pela Task** presente no plano e aplicada no código — as duas, na mesma frente 2 | veredito | QA | R16 · §4a |
| **Cenários mapeados executados, com resultado registrado no veredito** — inclui os regressivos aplicáveis | veredito | QA | R30 |
| Build sem avisos + testes passando | veredito | QA | R7 |
| Segurança: identidade, permissão, auditoria, segredo | veredito | QA | R11 |
| Documentação atualizada | fechamento da Task | QA | R12 |
| Evidência registrada | fechamento da Task | QA/SM | R7 |
| **④ Aceite funcional da História, na Sprint Review** — o PO conduz o aceite e escreve o dossiê; o **stakeholder decide**, por História | encerramento do sprint | PO demonstra · QA dá evidência · SM aciona e registra | R21 · R25 · §5e · §5g |
| Bump de `version` + banner "Versão atual" do `README.md` + entrada no `CHANGELOG.md` nomeando a branch | merge do PR em `develop` | stakeholder (SM verifica) | R18 · §5d |

## 9. Ambiente de verificação

Os comandos, os limiares e as limitações conhecidas do ambiente são específicos de cada projeto e vivem em `.team-project/quality-assurance/context.md` (verificação) e `.team-project/developer/context.md` (execução).

**Regra que não muda:** limitação de ambiente que impeça uma verificação é **declarada** no veredito como "não exercitado", nunca omitida.
