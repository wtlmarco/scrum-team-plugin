# Fluxo de Trabalho — Como o trabalho circula entre os papéis

> **Dono:** SM · Complementa [`working-rules.md`](working-rules.md): lá estão as regras, aqui está a mecânica.

## 1. Duas unidades: a **História** e a **Task**

| Unidade | Responde | Dono | Enfoque | Vive em |
|---|---|---|---|---|
| **História** | *que valor o stakeholder recebe* | PO | **só funcional** — regra, protótipo, critério de aceite | arquivo próprio (`.team-project/product-owner/stories/`), indexada pelo Product Backlog; **cópia congelada** em `sprints/<n>/stories/` quando o pacote é aprovado |
| **Task** | *que trabalho o time faz para entregar aquele valor* | SM (quadro) · Arquiteto (o plano dentro dela) | técnico — passos, arquivos, verificação | Sprint Backlog (`.team-project/sprints/<n>/sprint-backlog.md`) |

**O Product Backlog é o índice ordenado das Histórias** (v3.21 — [`artifact-ownership.md` §1d](artifact-ownership.md)); cada uma vive em arquivo próprio. Uma História nasce do SDD, é detalhada quando vai entrar num sprint, e é quebrada em Tasks pelo time na Planning Meeting. **Toda Task pertence a exatamente uma História** (R20); Task sem História é trabalho que ninguém pediu.

A Task carrega ID, título, História de origem, dono, dependências, estimativa, critério de pronto, **evidência esperada** e o **Plano de Implementação** escrito pelo Arquiteto. A convenção de IDs de cada projeto está em `.team-project/scrum-master/context.md` — tipicamente `H-nnn` para História, `T-nnn` para Task, sufixo para quebra (`T-012a`, `T-012b`), e o ID do GAP reusado quando a Task nasce de um GAP.

## 2. Do SDD à entrega — a cadeia

```
SDD funcional (PO: 00, 01, 02) + protótipo funcional em HTML (UX)
  └─ ① stakeholder NAVEGA o protótipo e aprova ──▶ SDD técnica (Arquiteto: 03, 04, 05)
       └─ ② aprovada ──▶ Histórias (PO), uma por arquivo ──▶ índice = Product Backlog
            └─ detalhamento da História: regras · especificação de tela (UX) · critérios de aceite
                 └─ Planning Meeting ──▶ Sprint Backlog fechado
                      └─ time quebra em Tasks, estima e corta na capacidade (§5e)
                           └─ pacote de abertura: Sprint Backlog + critérios + protótipo do sprint
                                └─ ③ stakeholder NAVEGA e aprova o pacote — o sprint arranca
                                     └─ Arquiteto escreve o Plano de Implementação
                                          └─ dev constrói ──▶ QA dá veredito ──▶ SM fecha a Task
                                               └─ Sprint Review: ④ aceite por História
                                                    └─ Sprint Retrospective
```

Os quatro portões numerados são os gates de §8. **O detalhamento da História é sempre e apenas funcional** — nenhuma decisão técnica entra ali; ela nasce na Task, no Plano de Implementação. **O ③ é aprovado depois da Planning, em lote, sobre um pacote navegável** (R20 · R25 · §5e): o stakeholder tem **dois pontos de contato por sprint** — a abertura e a Review —, e entre eles o time roda a fila sozinho (§5g).

### 2a. Ciclo da Task

| # | Etapa | Quem | Comando | Saída |
|---|---|---|---|---|
| 0 | Onboarding do projeto *(uma vez, projeto novo ou retomado)* | SM coordena, os seis papéis participam | `/sm onboarding` | Entendimento alinhado, contexto preenchido, quadro aberto (R14 · §5a) |
| 0b | Brainstorm *(só ideia sem documentação)* | SM facilita · fase 1: stakeholder + PO + UX · fase 2: + Arquiteto | `/team brainstorm <ideia>` | Brief funcional fechado, pronto para o SDD (R15 · §5b) |
| 1 | História criada a partir do SDD | PO | `/po story <ID>` | Arquivo da História criado, com o valor declarado, e linha nova no índice do Product Backlog |
| 2 | Detalhamento da História *(quando ela candidata a um sprint)* | PO, com o UX nos protótipos | `/po story <ID>` (modo detalhe) · `/ux journey` · `/ux screen <ID>` | Regras, protótipos e critérios de aceite — só funcional |
| 3 | Planning Meeting | SM conduz, o time inteiro participa | `/sm sprint plan` | Sprint Backlog: Histórias candidatas quebradas em Tasks, estimadas, dentro da capacidade; **pacote de abertura montado** (§5e) |
| 3b | **Pacote de abertura — portão ③ em lote** | UX costura · PO junta · SM submete · **stakeholder navega e aprova** | passos 9–11 de `/sm sprint plan` · `/ux prototype sprint <n>` | Pacote aprovado e datado: é o ③ de **todas** as Histórias do sprint, e o sprint arranca (R25 · §5g) |
| 4 | Plano de Implementação | Arquiteto | `/arc plan <Task>` | Plano dentro da Task, citando a especificação de tela e as seções de standard. Persistido em `.team-project/sprints/<n>/plan/` |
| 5 | Construção | dev | `/dev <Task>` | Código + testes + relatório de entrega |
| 6 | Gap durante a construção | dev → Arquiteto | `/arc question` → `/dev gap` | Decisão do Arquiteto, dev retoma |
| 7 | Validação | QA | `/qa <Task>` | Veredito ✅/⚠️/❌ com evidência |
| 8 | Fechamento da Task | SM | `/sm close <Task>` | Quadro + documento de status atualizados — **fechamento técnico, não aceite**. Linha nova no Registro de transições do Sprint Backlog (De: 🟪, Para: ✅) e ponto novo no burndown do sprint (R24) |
| 9 | Sprint Review | PO demonstra, stakeholder decide | `/sm review` | História aceita / com ressalva / rejeitada · gaps e débitos ao backlog |
| 10 | Sprint Retrospective | SM conduz | `/sm sprint close` | Retrospectiva + fechamento do sprint (§5c · §5e) |

`/team cycle <Task>` encadeia 4→5→6→7 sem intervenção manual e para no primeiro problema; os modos parciais `/team plan|build|qa <Task>` rodam uma etapa só. Use os comandos individuais para acompanhar etapa por etapa. **Escopo de sprint do `cycle`** — rodar a fila inteira do sprint numa invocação, em série (R1) — é **proposta ao stakeholder**, não aplicada: `commands/team.md` é dele. Enquanto não entrar, a fila do sprint roda Task a Task, e é o §5g que garante que o stakeholder não é acionado entre os dois pontos de contato.

As etapas 0 e 0b são **anteriores à cadeia** e não se repetem por Task: o onboarding acontece uma vez por projeto (R14); o brainstorm, uma vez por ideia sem documentação (R15), e alimenta o SDD funcional, não o substitui. A etapa 3b acontece **uma vez por sprint**, entre a Planning e a primeira Task em construção.

**O aceite não está no fechamento da Task.** A etapa 8 encerra o trabalho técnico com o veredito do QA; quem diz que o valor chegou é o aceite por História, na Sprint Review (R21 · etapa 9) — o PO conduz, o stakeholder decide. Task fechada dentro de uma História rejeitada volta ao sprint seguinte junto com as demais da mesma História.

## 3. Definition of Ready

### 3a. DoR da História — pode entrar na Planning Meeting?

- [ ] Rastreia a um requisito do SDD funcional já aprovado (portão ① de §8)
- [ ] O valor ao stakeholder está escrito em uma frase — o que ele passa a conseguir fazer
- [ ] Regras funcionais escritas, sem decisão técnica embutida
- [ ] **História com interface:** **especificação de tela** do UX existente, com os seis estados e os critérios de acessibilidade. É ela que o UX costura no protótipo do sprint depois do corte (§5e passo 10) — costurar não é reespecificar
- [ ] Critérios de aceite escritos pelo PO e **verificáveis**
- [ ] **Bloqueios varridos** — dependência, lacuna e risco conhecidos sanados na Planning, ou a História não entra (R25 · §5e passo 3)
- [ ] Detalhamento funcional **completo**, com os critérios prontos para entrar no **pacote de abertura** que o stakeholder aprova depois do corte de capacidade (portão ③ em lote). A História entra na Planning com o ③ ainda pendente, e **nenhuma Task dela vai à construção antes do pacote aprovado** (R20 · R25 · §5e)

### 3b. DoR da Task — pode entrar em construção?

- [ ] Pertence a uma História que passou pela DoR da História (R20)
- [ ] O **pacote de abertura do sprint** está aprovado e datado no Sprint Backlog — é ali que o ③ desta História aconteceu (R25 · §5g)
- [ ] Origem rastreada (GAP registrado ou critério de aceite da História)
- [ ] Estimativa registrada na unidade declarada em `.team-project/README.md` (§5e)
- [ ] Dependências resolvidas ou explicitamente aceitas como risco
- [ ] Plano de Implementação existente, dimensionado para uma unidade de trabalho (R2)
- [ ] Segurança endereçada **no plano** quando a Task é sensível (R11)
- [ ] Comandos de verificação executáveis neste ambiente, ou a limitação declarada (R7)

## 4. Definition of Done

### 4a-i. DoD da Task — o trabalho técnico acabou?

- [ ] Todos os passos do plano concluídos, ou os pendentes explicitamente reportados (R5)
- [ ] Testes do plano escritos e passando; build sem avisos
- [ ] Cobertura dentro do limiar declarado no projeto, sem regressão
- [ ] Registros de infraestrutura feitos (injeção de dependência, migration, mapeamento de erro), conforme a stack
- [ ] Isolamento entre escopos preservado e coberto por teste quando aplicável
- [ ] Veredito ✅ do QA com saída real de comando (R7)
- [ ] Documentos de qualidade e evidências atualizados pelo QA; documento de status pelo SM (R12)

### 4a-ii. DoD da História — o valor chegou?

- [ ] Todas as Tasks da História fechadas pela DoD da Task
- [ ] Cada critério de aceite da História tem evidência registrada pelo QA apontando a Task que o cumpre
- [ ] Demonstrada na Sprint Review
- [ ] **Aceite registrado** (R21) — conduzido pelo PO, com a decisão do stakeholder por História
- [ ] Gaps e débitos levantados na Review estão no Product Backlog com dono

## 4a. Aderência: `/arc comply` e a frente 2 do QA verificam objetos diferentes

`/arc comply` **não é etapa do ciclo** (as etapas de construção são 4→5→6→7 na numeração da §2a; `commands/team.md` modo `cycle` usa um índice local próprio, 0–6, só das etapas de construção). É uma revisão de aderência **sob demanda**, em um de dois momentos: (a) o Arquiteto a roda antes de entregar ao QA quando a entrega é grande ou tocou muitos passos; (b) é a rota de volta dos achados de aderência de execução do veredito (⚠️/❌), antes do `/dev resume`. Não roda no `/team cycle` nem nos modos parciais.

| Verificação | Objeto | Pergunta |
|---|---|---|
| `/arc comply` | o **Plano de Implementação vigente** | cada passo foi executado como escrito (assinatura, anel, arquivo, nomenclatura, registro de infra), e **a seção de standard que o passo citou está aplicada** no código? — o autor conferindo a execução da própria instrução |
| `/qa <Task>` frente 2 | o **normativo `${CLAUDE_PLUGIN_ROOT}/standards/`** e a **completude do plano ante a Task** | (1) o plano **omitiu** uma seção de standard que a Task exigia? (2) o plano **citou a seção errada** para o que a Task faz? (3) — interseção — a seção citada está cumprida no código? |

O comply **não julga se o plano citou o conjunto certo ou completo de seções** — um autor não audita a própria omissão. Esse é o valor próprio da frente 2: pegar o defeito que o Arquiteto estruturalmente não vê. A interseção (seção citada × código) o QA **reverifica de forma independente**, como já faz a frente 3 apesar do checklist de segurança no plano — não confia no comply, que pode nem ter rodado.

**Como o SM verifica que o QA fez a checagem dele e não a do Arquiteto:** o veredito da frente 2 traz, para cada área de engenharia que a Task toca, **a seção de standard que a Task exigia × a seção citada no plano**, com um de quatro estados por linha:
- citada e aplicada — ok;
- citada e divergente do código — **reprovação** (R16);
- **exigida pela Task e ausente do plano** — achado de processo ao `/review`;
- citada errada para o que a Task faz — achado de processo ao `/review`.

Veredito de frente 2 que só reproduz a tabela passo × conforme do comply, sem a coluna "seção exigida pela Task × seção citada", indica que o QA fez a checagem do Arquiteto, não a dele — o SM registra como achado de processo contra o veredito.

## 5. Cerimônias

| Cerimônia | Quando | Comando | Duração alvo |
|---|---|---|---|
| Onboarding do projeto | projeto novo ou retomado, antes do primeiro sprint | `/sm onboarding` | resposta única + registro (§5a) |
| Brainstorm de descoberta | ideia nova cuja área não tem documentação (visão / requisitos / fluxos) | `/team brainstorm <ideia>` | rodadas até ponto fixo (§5b) |
| Refinamento funcional | ideia nova em área já documentada | `/po analyze <ideia>` | resposta única |
| **Protótipo funcional** | junto com o SDD funcional, antes do portão ① | `/ux prototype` | HTML navegável ([`deliverables/prototype/`](../../../deliverables/prototype/README.md)) |
| Escrita e detalhamento de História | História nasce do SDD; é detalhada quando candidata a um sprint | `/po story <ID>` | 1 História |
| **Planning Meeting** | abre cada sprint | `/sm sprint plan` | Sprint Backlog fechado (§5e) |
| Daily | início de cada sessão | `/po status` | 6 linhas |
| Refinamento técnico | antes de construir uma Task | `/arc plan <Task>` | 1 plano |
| Validação | ao fim de cada Task | `/qa <Task>` | veredito com evidência |
| **Pacote de abertura do sprint** | logo depois da Planning, antes de a construção começar | `/sm sprint plan` passos 9–11 + `/ux prototype` (costura do sprint) | Sprint Backlog fechado + critérios de aceite + protótipo navegável, **navegados e aprovados pelo stakeholder** — é o **③ em lote** (§5e · §5g) |
| **Sprint Review** | fecha cada sprint, antes da retrospectiva | `/sm review` | veredito por História + gaps e débitos, ambos ao Product Backlog na mesma sessão (§5e · §5g) |
| **Sprint Retrospective** | fecha cada sprint, depois da Review | `/sm sprint close` | [template](../templates/retrospective.md) · mede o footprint do processo (§5c) |
| Auditoria cruzada | a cada 3 sprints | `/qa audit` | achados, sem correção |
| Acordo facilitado | questão que atravessa papéis e precisa de **uma** posição | `/sm agreement <questão>` | o SM chama **só os papéis que a questão toca**, consolida uma recomendação e registra a divergência que sobrou |
| Melhoria de processo | quando o stakeholder instrui uma mudança de método | `/review <instrução>` | documento do papel atualizado + entrada no changelog do processo |
| Revisão de processo | a cada 3 retrospectivas, ou quando uma métrica estoura | `/review metrics` | **uma** proposta de mudança, com o indicador que a valida; é também o giro **Act** do ciclo de eficiência (§5c) |
| Curadoria do processo | quando dois papéis mudam algo que se contradiz | `/review` | consolidação do changelog e escalação do que ficou inconsistente |
| Auditoria de processo | a cada replicação, ou quando o time cresce | `/review audit` | achados de coerência interna de `${CLAUDE_PLUGIN_ROOT}/` |
| Lançamento de entrega | quando o stakeholder fecha uma versão | branch + PR + bump de `version`; cliente: `/team update` | entrada no `CHANGELOG.md` (§5d · R18) |

## 5a. Ritual de onboarding do projeto (R14)

Acontece **uma vez**, quando o time recebe um projeto novo ou retoma um abandonado, antes da primeira Planning Meeting. O SM coordena; os seis papéis participam. **A documentação existente do projeto é a primeira fonte — o stakeholder é consultado só sobre o que ela não responde.**

| # | Passo | Quem | O que produz |
|---|---|---|---|
| 1 | **Inventário das fontes** — listar o que existe: `.team-project/README.md`, o SDD, ADRs, os documentos de implementação, mapa de código, registro de GAPs | SM, sozinho | Tabela documento → existe? → última atualização → dono |
| 2 | **Lista de lacunas contra a documentação** — para cada coisa que o time precisa saber para planejar (objetivo do produto, fase, stack, ambiente, fontes da verdade, capacidade, duração do sprint, unidade de estimativa, restrições, riscos abertos), marcar: respondido pelo doc X / parcial / ausente | SM, sozinho | Lista de lacunas com origem |
| 3 | **Bifurcação** — (a) documentação funcional essencial **ausente** (sem visão geral, sem requisitos, sem fluxos) → abrir `brainstorm` (§5b) e **pausar** o onboarding até ele fechar; (b) documentação **desatualizada ou contraditória** (ex.: status diz "concluído", GAPs dizem o contrário) → registrar a divergência como risco no quadro e acionar `/qa audit`; o onboarding segue com a divergência declarada, não arredondada | SM | Decisão de rota registrada |
| 4 | **Leitura de entrada do time** — cada um dos outros cinco papéis lê `.team-project/README.md` + o seu `context.md` e reporta, em ≤10 linhas: o que entendeu como seu mandato neste projeto, o que precisa e não está documentado, um risco que enxerga do seu ângulo | PO · Arquiteto · UX · dev · QA | Cinco leituras de entrada |
| 5 | **Consolidação + perguntas ao stakeholder** — o SM funde as leituras num quadro único e produz **uma** lista de perguntas que só o stakeholder responde: estratégicas (provedor, alvo da retomada, ordem de prioridade), a **duração do sprint** e a **unidade de estimativa** se ainda não estiverem no contexto, e lacunas funcionais pequenas que a documentação não cobriu e que não justificam um brainstorm. Cada pergunta segue a forma fixa de R22: por que bloqueia · alternativas descritas · recomendação do time (R9 — o time tentou responder antes) · a via de pedir mais contexto **sempre como última opção**, resolvida em formulário pela sessão que orquestra o onboarding, não em texto corrido | SM | Lista de decisões pendentes do stakeholder |
| 6 | **Registro do alinhamento** — o SM escreve o entendimento comum no contexto do projeto (`.team-project/README.md` e os `context.md` recebem aporte de cada papel) e abre o quadro de trabalho | SM | Contexto do projeto preenchido e datado, quadro aberto |

**O que o SM pergunta primeiro à documentação:** propósito e fase do produto (`00-overview`), requisitos e seus critérios de aceite (`01-requirements`), atores e fluxos (`02-flows`), princípios de arquitetura e vinculação de stack (`03-architecture`), contratos de dados e API (`04`/`05`), o que está construído e com que evidência (`02-status`, `03-code-map`, `pending`), ambiente e comandos de verificação, capacidade declarada, limitações conhecidas, riscos e bloqueios abertos.

**Os quatro documentos de implementação nascem quando o projeto os exige, não no `/team init`.** `01-scope-and-criteria`, `02-status`, `03-code-map` e `pending` não fazem parte do que o `init` semeia ([`deliverables/team-project/README.md`](../../../deliverables/team-project/README.md)) — nascem na primeira vez que o projeto precisa deles (retomada, primeiro fechamento de Task, primeira auditoria). O que faltava não era o manifesto listá-los antecipadamente: era **algo lembrar o SM de declará-los** quando nascem. Regra: todo documento de implementação, no instante em que nasce, entra na mesma sessão em `.team-project/README.md` §4 "Fontes da verdade" ([`templates/project-context.md`](../templates/project-context.md)), com o dono — nunca fica implícito só porque o caminho já é convenção. **Como o SM verifica:** todo caminho citado em `pending`/`02-status`/`03-code-map`/`01-scope-and-criteria` que já tem conteúdo real aparece como linha em `.team-project/README.md` §4; documento com conteúdo e sem linha em §4 é achado de processo contra o próprio SM.

**Rastreio de pendências e bugs existentes, sem duplicar `/qa audit`.** O onboarding é o primeiro momento em que o time vê o projeto — pendência e bug preexistentes que não forem capturados agora se perdem misturados ao trabalho novo. Três fontes, sem sobreposição:
- **Código, em projeto retomado:** já é a bifurcação (b) do passo 3 e a sequência declarada em `project-context.md` §8 ("Projeto retomado": `/sm onboarding` → `/qa audit` → `/qa baseline`) — o SM não duplica aqui, só confirma no inventário do passo 1 que o registro de GAPs vai nascer dessa sequência, se ainda não existir.
- **Documentação herdada divergente:** também é a bifurcação (b) do passo 3 — vira risco no quadro e aciona `/qa audit`.
- **O que o stakeholder já sabe estar quebrado, e ainda não está escrito em lugar nenhum:** é o que faltava. No passo 5, o SM pergunta explicitamente por isso, e cada item vira relato roteado ao **PO** (`/po bug <relato>`, §6a) — nunca uma entrada direta em `pending.md`, que continua sendo escrita só pela QA depois de confirmar.

**O que o SM escala ao stakeholder** (só depois de esgotar a documentação e o time): decisões estratégicas (stack, provedor, custo, alvo da retomada, prioridade acima da ordem de dependência do SM), os dois parâmetros de cadência (duração do sprint, unidade de estimativa) e lacunas funcionais pequenas não respondíveis pela documentação — sempre na forma fixa de R22: opções descritas, recomendação e a via de pedir mais contexto, resolvida em formulário, não em texto corrido.

**Condição de saída — o onboarding está pronto quando:**
- [ ] Toda linha do inventário de fontes está preenchida (existe / desatualizada / ausente), e toda "ausência de doc funcional essencial" foi produzida via brainstorm ou aceita como risco pelo stakeholder.
- [ ] Os outros cinco papéis registraram a leitura de entrada (mandato entendido + o que falta + um risco); o SM coordena e consolida, não escreve uma sobre si.
- [ ] A lista de perguntas só-do-stakeholder foi respondida ou explicitamente adiada com o risco aceito.
- [ ] `.team-project/README.md` reflete o entendimento alinhado (objetivo, fase, stack, ambiente, fontes da verdade, capacidade, **duração do sprint**, **unidade de estimativa**, restrições) e toda divergência status × código está no quadro como risco.
- [ ] O quadro existe, com ao menos uma onda de Histórias candidatas, ou uma nota de que o planejamento está bloqueado aguardando brainstorm/decisão do stakeholder.
- [ ] Pendências e bugs preexistentes estão rastreados — por `/qa audit`+`/qa baseline` (projeto retomado) ou por relato do stakeholder roteado ao PO (`/po bug`, projeto novo com defeito conhecido) — nunca perdidos por não caberem em nenhuma pergunta do onboarding.

**Como o SM verifica que aconteceu:** a resposta do onboarding traz a tabela de inventário preenchida e as cinco leituras de entrada; `.team-project/README.md` está datado em/após o onboarding com §4 e §7 populadas; nenhuma Planning Meeting do projeto precede o registro de onboarding; toda divergência narrativa × código é linha na tabela de riscos do quadro; todo documento de implementação com conteúdo real tem linha em §4; e o passo 5 registra a pergunta ao stakeholder sobre defeito conhecido ainda não documentado, mesmo quando a resposta é "nenhum".

## 5b. Ritual de brainstorm de descoberta (R15)

Acionado quando o stakeholder traz uma ideia — um desejo dele — para a qual **não há cobertura** em visão geral / requisitos / fluxos: produto greenfield ou área de capacidade genuinamente nova. Ideia em área já documentada vai por `/po analyze`, não por aqui. O SM **facilita** (abre a sessão, mantém as fases, registra convergência/divergência, declara o fechamento) e **não decide conteúdo funcional**.

### Fase 1 — Formação funcional · participantes: stakeholder + PO + UX

Objetivo: um **entendimento funcional base** — o problema do usuário, quem são os usuários, a jornada central, o valor, a fronteira grosseira de escopo (o que está dentro / explicitamente fora), as regras principais, os casos de borda óbvios.

- O PO conduz o enquadramento funcional (problema, regra, escopo); o UX contribui a jornada, o contexto de uso e as implicações de usabilidade/acessibilidade; o stakeholder fornece intenção e restrições e responde perguntas diretamente — aqui o diálogo direto com o stakeholder é o **mecanismo de co-criação**, não uma falha de escalação (R9).
- Arquiteto, dev e QA **não** entram na fase 1 — de propósito, para a forma funcional se estabelecer sem restrição técnica prematura.
- Saída da fase 1: um **brief funcional** — ainda não um requisito formal, e muito menos uma História. É o insumo que o PO transforma em `01-requirements` / `00-overview` / `02-flows` e o UX em jornadas.
- Fecha quando PO e UX concordam que a ideia tem base funcional estável e o stakeholder confirma que corresponde à intenção.

### Fase 2 — Viabilidade e proposta · participantes: + Arquiteto

- O Arquiteto avalia o brief funcional quanto a viabilidade: encaixe arquitetural, implicações de contrato/dados, risco de integração, dimensionamento grosseiro, alternativas, o que é barato × caro.
- **Rodada de análise e proposta:** Arquiteto levanta restrições/opções → PO/UX ajustam o brief funcional → Arquiteto reavalia. Repete. O SM registra o delta de cada rodada.
- O Arquiteto **aconselha**; não reescreve requisito. Se a viabilidade força mudança funcional, quem muda é o PO (propriedade inalterada). Se força troca de escopo/custo além do mandato do time, sobe ao stakeholder.

### Critério de convergência — o brainstorm está fechado quando:
- [ ] O brief funcional ficou estável numa rodada inteira de fase 2 sem nova objeção bloqueante do Arquiteto (ponto fixo).
- [ ] O stakeholder confirma que a ideia moldada ainda corresponde à intenção.
- [ ] A fronteira de escopo está escrita: o que entra na primeira fatia, o que fica explicitamente adiado.
- [ ] Toda pergunta funcional aberta foi respondida ou está listada como premissa conhecida, com dono.
- [ ] O Arquiteto declarou, em um parágrafo, que a ideia moldada é construível dentro da capacidade declarada — ou nomeou a restrição que precisa ser aceita.

### Transição para o SDD (conforme [`deliverables/README.md`](../../../deliverables/README.md))
No fechamento, o SM registra o brief e distribui a elaboração — **sem escrever os sete documentos de conteúdo de uma vez**, só o que a primeira fatia exige, e **na ordem dos portões ① e ② de §8**:

| Ordem | Documento | Dono | Comando |
|---|---|---|---|
| 1 | `00-overview-objectives`, `01-requirements` (com critério de aceite + como verificar), `02-flows-and-roles`, início do `06-changelog`, índice do SDD — **o SDD funcional** | **PO** | `/po requirement <ID>` por requisito · `/po analyze` se uma sub-ideia ainda precisa de decisão formal |
| 1 | Mapas de jornada das jornadas moldadas | **UX** | `/ux journey <fluxo>` |
| 1 | **Protótipo funcional em HTML** — todo fluxo principal de `02-flows-and-roles` navegável ponta a ponta, com os estados de exceção e o "fora" declarado na página | **UX** | `/ux prototype` |
| — | **Portão ①: o stakeholder NAVEGA o protótipo e aprova o SDD funcional** — aprovar lendo texto é aprovar uma descrição; o que se valida aqui é o entendimento, e ele só aparece na navegação | stakeholder | — |
| 2 | `03-architecture` (incl. Ficha de Vinculação de Stack §2b), `04-data-model`, `05-api-model` — só as partes da primeira fatia — **o SDD técnico** | **Arquiteto** | — |
| — | **Portão ②: o SDD técnico é aprovado** | stakeholder | — |
| 3 | Histórias a partir dos requisitos aprovados | **PO** | `/po story <ID>` |

O brief de brainstorm **não** é entregável permanente: é absorvido por `00-overview` / `01-requirements` e pelo registro de processo, e não vira arquivo novo sem lugar declarado em `.team-project/`.

**Como o SM verifica:** a saída do brainstorm mostra as duas fases com os participantes declarados — fase 1 sem o Arquiteto, fase 2 com ele; cada rodada de fase 2 tem delta registrado ou "sem mudança — ponto fixo"; no fechamento, `00-overview` + `01-requirements` + `02-flows` são criados/atualizados pelo PO no mesmo ciclo (R12) e o índice do SDD mostra a versão nova; **o protótipo funcional existe, cobre todo fluxo principal de `02-flows` e tem o registro de navegação do stakeholder datado**; **nenhum documento do SDD técnico foi escrito antes do portão ①, e nenhuma História antes do portão ②**; o brief não virou arquivo sem lugar declarado.

## 5c. Ciclo de eficiência dos documentos do processo (PDCA)

O custo dos documentos de `${CLAUDE_PLUGIN_ROOT}/` não pode depender de uma faxina eventual do stakeholder. Cada papel verifica periodicamente o peso dos **próprios** documentos e propõe corte. O ciclo usa gatilhos que **já existem** — nenhuma cerimônia nova.

| Fase | Onde já acontece | O que a eficiência acrescenta |
|---|---|---|
| **Plan** | `/review metrics` (a cada 3 retrospectivas, ou métrica estourada) | Reafirma o teto de footprint por papel e o alvo do período: ao menos **uma** remoção candidata nomeada |
| **Do** | operação normal + cada `/review` | Papéis editam seus documentos; toda entrada de changelog respeita R17 |
| **Check** | `/review` sem instrução (reavaliação do conjunto, linha "Excesso") + retrospectiva | Passa a ser quantitativo: o papel mede seu footprint e compara com o valor anterior registrado; a retrospectiva registra total e Δ |
| **Act** | `/review metrics` + `/review <instrução>` | O SM consolida os footprints numa tabela por papel, escolhe **uma** mudança, roteia o corte ao dono; entrada no changelog com o indicador (KB antes/depois) |

**Métrica por papel — dois números, nunca somados num só:**

| Número | O que mede | Como | Por que separado |
|---|---|---|---|
| **Carga fixa** | o que entra no prompt em **toda** invocação daquele papel | `agents/<papel>.md` + `commands/<papel>.md` | é o único custo que se paga sempre; **é aqui que corte vale mais** |
| **Conjunto sob demanda** | o que o papel **pode** ler, conforme a tarefa | `roles/<papel>/` — README, skills, templates; para o SM, também `process/`, **exceto `process-changelog.md` e `process-changelog-archive.md`** | é pago por leitura, não por invocação (R3) |

**Por que o changelog fica fora da conta.** O arquivo de changelog é **frio por construção** — só é lido em `/review history` — e **cresce de forma monotônica por decisão do próprio processo**: R17 manda arquivar, não apagar. Contá-lo faz o SM aparecer com ~320 KB contra ~30 KB dos outros papéis, dos quais metade é história arquivada; o giro **Act** então aponta sempre para o SM e nunca para o desperdício real, que está na carga fixa. **Medida errada não corrige nada — dirige o corte para o lugar errado.**

**Onde o corte rende mais, em ordem:** (1) a **carga fixa** dos 12 arquivos de `agents/` + `commands/`, porque é multiplicada por toda invocação; (2) o **bloco fixo §8 do `.team-project/README.md`**, lido por todo papel em toda invocação; (3) o conjunto sob demanda, que já é protegido por R3.

**Os dois primeiros são proposta, nunca aplicação direta** — `agents/` e `commands/` são do stakeholder (§1), e `.team-project/` é do projeto. O Act mede, encontra e propõe com o texto pronto; ele autoriza item a item no fecho. A exceção de curadoria do SM não cobre remoção aí. Só o item (3) o `/review` aplica sozinho (v3.22).

**Onde cada arquivo é carregado — e por que isso muda a conta.** `commands/<x>.md` entra no **contexto principal** quando o stakeholder digita `/x`; `agents/<papel>.md` entra no contexto do **subagente** que aquele comando dispara. Os dois nunca se somam no mesmo contexto para o mesmo papel: um comando de papel só custa `commands/<x>.md` + `agents/<papel>.md`, mas um broadcast custa **`commands/team.md` uma vez, mais um `agents/<papel>.md` por subagente disparado** — nunca os seis arquivos de comando.

**Custo por comando, em carga fixa** (antes de qualquer leitura de `.team-project/`):

| Comando | Carga fixa | O que dispara |
|---|---|---|
| `/team brainstorm <ideia>` | ~39 KB | SM + PO + UX, depois + Arquiteto |
| `/team cycle <T-ID>` | ~27 KB | Arquiteto → dev → QA, em série |
| `/sm agreement <questão>` | ~15 KB + um `agents/<papel>.md` por papel chamado (2–3 típicos) | SM + os envolvidos |
| `/review <instrução>` | ~14 KB + ~10 KB do contrato por papel roteado | SM (triagem) + o papel dono |
| `/sm` · `/po` · `/ux` · `/arc` · `/qa` · `/dev` | 15,4 · 16,7 · 11,2 · 10,4 · 11,1 · 7,1 KB | um papel |

> Os números por papel somam `commands/<x>.md` + `agents/<papel>.md`. **Remedidos em v3.16 (14/09/2026)** — a remedição anterior era da v3.4 e nunca tinha sido refeita; o achado que mais importa: a carga fixa do **PO** cresceu **13 → 16,7 KB (+28%)** sem ninguém notar, o maior salto do grupo (SM +3%, UX +2%, Arquiteto +4%, QA +11%, dev +1%; total do grupo 66 → 71,9 KB, +9%). Comando de medição, para a próxima remedição ser mecânica:
> ```powershell
> Get-ChildItem agents,commands -File | Select-Object Name,Length
> ```
> — soma manualmente `agents/<papel>.md` + `commands/<papel>.md` por papel; `/team brainstorm` e `/team cycle` somam `commands/team.md` + um `agents/<papel>.md` por papel disparado; `/review` soma `commands/review.md` + `agents/scrum-master.md` (triagem), mais `review-contract.md` (~10 KB, também remedido, sem variação relevante) por papel roteado. Remedir é parte da fase **Check**; tabela de custo que não se remede vira folclore — a v3.4 avisou isso e a própria tabela virou o exemplo.

**Chame só quem a questão toca — não existe broadcast dos seis.** O canal do stakeholder é o PO (§6a), e questão que atravessa papéis vai por `/sm agreement`, cujo passo 1 identifica **quais papéis a questão toca** — dois ou três, nunca os seis por precaução. É onde a lição de R3 vive hoje, e o ganho é nos dois eixos: menos um `agents/<papel>.md` por papel não chamado e — o que pesa mais — menos uma rodada de leitura de contexto de projeto por subagente não disparado.

**Três coisas que a carga fixa não mostra, e que costumam dominar o custo real:**
1. **O modelo importa mais que os KB.** `/arc` roda em **Opus**; `/sm`, `/po`, `/qa` e `/ux` em **Sonnet**; `/dev` em **Haiku**. `/arc` carrega menos que `/sm` e custa mais. Ranquear a tabela por KB inverte a ordem real — pondere por preço do modelo antes de escolher onde cortar.
2. **A leitura em tempo de execução costuma superar a carga fixa.** Todo agente lê `.team-project/README.md` e o seu `context.md`; o QA lê ainda o plano, o relatório do dev, as seções de `standards/` citadas e o código. Num broadcast isso é multiplicado pelo número de subagentes.
3. **As respostas voltam.** Cada saída de subagente retorna ao contexto principal para consolidação — num `/team brainstorm` ou `/team cycle`, uma por papel disparado.

**A tabela sustenta ordem de grandeza, não delta exato.** A coluna por papel soma `commands/` + `agents/`, e o que o `/sm agreement` acrescenta é só `agents/` por papel chamado. Ordem de grandeza basta para decidir; estimar o resto repete o erro que a v3.2 corrigiu.

**Gatilhos:**
- *Medição* — em todo `/review` sem instrução (o papel já faz a reavaliação do conjunto ali; passa a anexar os dois números) e na retrospectiva de cada sprint (o SM mede o total do processo).
- *Giro completo* — casado com `/review metrics`: a cada 3 retrospectivas — ou seja, a cada 3 sprints —, ou antecipado por limiar.
- *Limiar que dispara Act fora de cadência* — footprint de um papel cresce > 20% entre dois giros sem regra ou cerimônia nova que o justifique; **ou** qualquer entrada de changelog passa de 10 KB (R17); **ou** o footprint total de `${CLAUDE_PLUGIN_ROOT}/` cresce dois giros seguidos sem nenhuma remoção registrada.

**Onde fica registrado, para ser comparável no tempo:** a tabela de footprint por papel vai na saída de `/review metrics`; quando o giro gera entrada no changelog — o caso normal, um corte por giro —, os números ficam ali, no campo "Como saberemos que funcionou" do modelo [`process-change.md`](../templates/process-change.md). Entre giros, a retrospectiva carrega a linha "carga fixa do processo (KB): atual / retro anterior / Δ" como série contínua.

**Pegada estática × consumo real — os dois convivem, nunca se somam (v3.17).** Tudo acima mede a **pegada estática**: bytes de `agents/`+`commands/`+`roles/`, fixa por versão do plugin e igual em qualquer projeto que instale o time — é proxy de custo do **processo**, não gasto. Quando o projeto mantém [`.team-project/sprints/<n>/consumption.md`](../templates/consumption.md) (SM, modelo em `templates/consumption.md`), existe também o **consumo real**: tokens e duração por invocação, que a sessão que orquestra recebe quando cada subagente termina e registra numa linha — variável por projeto e por sprint, ao contrário da pegada estática. A fase **Check** passa a citar os dois lado a lado quando o registro existe (a retrospectiva soma o real do sprint numa **seção própria**, com total e quebra por papel — ver [`templates/retrospective.md`](../templates/retrospective.md)); a fase **Act** usa a divergência entre eles como achado: papel com carga fixa pequena e consumo real alto (ou o oposto) é candidato a investigar, não a cortar às cegas. **O consumo real mede o trabalho dos papéis — não o custo da sessão principal, que não enxerga o próprio consumo**; não é o total gasto no projeto, é um piso. **O acumulado do projeto é derivado, não mantido:** somar os `sprints/<n>/consumption.md` responde "quanto o time custou até aqui" sem uma tabela viva que precise ser conciliada a cada fechamento.

**O que a fase Check candidata à remoção:** modelo que ninguém referencia, seção que repete outra, regra sem citação em 3 sprints, entrada de changelog acima do teto. Processo que só cresce deixa de ser seguido — revisar é também remover.

## 5d. Atualização e lançamento do plugin

O **processo do time** (os documentos de `${CLAUDE_PLUGIN_ROOT}/`) evolui por `/review`, no repositório-fonte. Chegar às instalações onde o time está instalado é outro passo: uma **entrega versionada**. Os dois registros não se confundem —

| Registro | Arquivo | Versão | Alimentado por | Dono |
|---|---|---|---|---|
| Evolução das regras de trabalho | `roles/scrum-master/process/process-changelog.md` | `vX.Y` | `/review` (SM cura) | SM |
| Entrega do plugin às instalações | `CHANGELOG.md` (raiz) | `vMAJOR.MINOR.PATCH` | fechamento de entrega | stakeholder |

### Ciclo de uma entrega
1. **Branch** `fix/vX.Y.Z` ou `feat/vX.Y.Z` a partir de `develop` — ou, se a entrega depende de uma entrega anterior ainda não mesclada, **empilhada** a partir da branch dessa entrega (dois precedentes: `v3.14.0` sobre `fix/v3.10.0`, `v3.16.0` sobre `fix/v3.15.0`); a entrada de `CHANGELOG.md` (passo 6) declara a base nos dois casos.
2. As correções e melhorias da entrega — inclusive as aplicadas por `/review` — vão nessa branch, que acumula até o stakeholder sinalizar o fechamento da versão.
3. **PR para `develop`**, para aprovação do stakeholder. `develop` é a linha de integração contínua; `main` recebe `develop` quando o stakeholder decide consolidar a linha estável — esse merge não é parte do ciclo por-entrega.
4. **Bump** de `version` em `.claude-plugin/plugin.json` para `vX.Y.Z`.
5. **Banner** "Versão atual" no topo do `README.md` (raiz) atualizado para `vX.Y.Z` — mesma checagem que os passos 4 e 6 já pedem para `plugin.json` e `CHANGELOG.md`; é o passo que faltou no fechamento da `v3.4.0`, quando só `plugin.json` e `CHANGELOG.md` foram tocados e o README ficou anunciando `v3.3.0`.
6. **Entrada** no topo de `CHANGELOG.md`: o que foi entregue, a branch (com a base, se empilhada) e como verificar.
7. No merge, os clientes são avisados e atualizam com **`/team update`** (ou os comandos nativos `claude plugin marketplace update` + `claude plugin update`).

### Regra de numeração
- `MAJOR.MINOR` acompanham a versão do changelog do processo **quando a entrega inclui mudança de processo**: uma entrega que carrega uma entrada nova de `process-changelog.md` (`vX.Y`) é lançada como `vX.Y.0`. A colisão numérica entre os dois changelogs é intencional e sinaliza o par.
- `PATCH` (`vX.Y.1`, `vX.Y.2`…) é correção sobre a mesma linha, sem mudança de processo.
- Entrega de escopo fechado (nova capacidade de comando, faxina, correção) incrementa `MINOR` ou `PATCH` sem tocar o changelog do processo — e a entrada em `CHANGELOG.md` diz isso explicitamente.

### O que o SM reconcilia (curadoria do `/review`)
- Toda entrada nova de `process-changelog.md` tem entrada correspondente em `CHANGELOG.md` na mesma linha `vX.Y`, ou a divergência é registrada.
- `version` de `.claude-plugin/plugin.json` == a versão da entrada do topo de `CHANGELOG.md`.
- O banner "Versão atual" no topo do `README.md` (raiz) == `version` de `.claude-plugin/plugin.json` == a versão da entrada do topo de `CHANGELOG.md`.
- Nenhuma entrada de `CHANGELOG.md` afirma "sem mudança de processo" quando a entrega, de fato, carrega uma.

### `/team update` — lado da instalação
Roda **na cópia instalada**, nunca no repositório-fonte (guarda: recusa se `${CLAUDE_PLUGIN_ROOT}/.git/` existir). Compara a `version` instalada com a do `main` da origem canônica, mostra o delta do `CHANGELOG.md` e, após confirmação, aplica. **Depois disso, reconcilia o `.team-project/`** com os modelos da versão nova, conforme o manifesto de [`deliverables/team-project/README.md`](../../../deliverables/team-project/README.md) — porque atualizar o plugin atualiza `${CLAUDE_PLUGIN_ROOT}` e nada do que o `init` instanciou, que derivaria em silêncio a cada versão. Reiniciar a sessão continua manual. Os nove passos estão em [`team-update.md`](../../../team-update.md), lido só nesse modo; `commands/team.md` só aponta para lá.

**O `update` nunca apaga conteúdo do projeto sem aprovação.** Cópia literal ele substitui avisando; estrutura com conteúdo local ele **propõe** o delta, arquivo por arquivo; conflito entre o que o time editou e o que o modelo mudou vai ao stakeholder ou vira pendência no quadro.

## 5e. O sprint — caixa de tempo

O sprint é a **unidade de cadência do time**: uma caixa de tempo de duração fixa, declarada em `.team-project/README.md` e respondida pelo stakeholder no onboarding (§5a, passo 5). O processo não fixa a duração — fixa que ela **não muda dentro do sprint**.

### Planning Meeting — abre o sprint (`/sm sprint plan`)

**O SM facilita o ritual; o PO decide o conteúdo.** O SM mantém a caixa de tempo, cobra a DoR, conduz a quebra e fecha a conta da capacidade — **não escolhe o que entra**. Quem escolhe é o PO, que detém o plano de entrega.

| # | Passo | Quem | Saída |
|---|---|---|---|
| 1 | Fechar o sprint anterior, se houver: Review feita, retrospectiva registrada, Tasks não concluídas devolvidas ao Product Backlog **com a História a que pertencem** | SM (facilita) | Sprint anterior encerrado |
| 2 | Selecionar as Histórias candidatas, na ordem do Product Backlog e conforme o **plano de entrega** — **só as que passaram na DoR da História** (§3a) — e conferir que o conjunto forma uma **fatia vertical demonstrável**, não meio fluxo (R25) | **PO decide** · SM confere a DoR e o critério de valor, e devolve o que não passou | Lista de candidatas |
| 3 | **Varredura de bloqueios** sobre as candidatas: dependência não resolvida, lacuna de especificação, risco conhecido. Sanado aqui, ou a História **não entra** | SM conduz · PO (funcional) e Arquiteto (técnico) respondem | Candidatas sem bloqueio aberto, ou devolvidas ao Product Backlog |
| 4 | Quebrar cada História em **Tasks** | o time (Arquiteto conduz, dev e QA contribuem) | Tasks com título, dependências e critério de pronto |
| 5 | **Estimar cada Task** na unidade declarada em `.team-project/README.md` | o time | Estimativa por Task |
| 6 | Somar e comparar com a **capacidade do sprint** — observada, não negociada | SM apresenta a conta | Quanto cabe |
| 7 | **Cortar no limite da capacidade**: o que sai, sai por decisão de valor | **PO decide** o que fica de fora | Sprint Backlog fechado |
| 8 | Declarar o **objetivo do sprint** em uma frase, derivado das Histórias que entraram | PO | Objetivo do sprint no quadro |
| 9 | Abrir `.team-project/sprints/<n>/` — o contêiner e as três subpastas com dono (`stories/` PO · `plan/` Arquiteto · `evidence/` QA) — e gravar `planning.md`: decisões da Planning, o corte, e **o que veio da Review anterior e não entrou, com o motivo** (R25) | SM escreve · PO fornece a priorização | `sprints/<n>/planning.md` ([`templates/planning.md`](../templates/planning.md)) |
| 10 | **Montar e submeter o pacote de abertura**: o UX **costura num protótipo navegável do sprint** as telas das Histórias que sobraram do corte, o PO junta os critérios de aceite delas, o SM anexa o Sprint Backlog fechado, o objetivo e o `planning.md`. O stakeholder **navega e aprova**; o SM registra data + quem aprovou + o ponteiro do protótipo + ajustes pedidos, no Sprint Backlog. Essa aprovação é o **portão ③ de todas as Histórias do sprint** | UX costura · PO junta · SM submete e registra · **stakeholder navega e aprova** | Pacote aprovado e datado — sem ele o sprint não arranca (R20 · R25) |
| 11 | **Congelar `sprints/<n>/stories/`** (o PO copia cada História como foi aprovada), abrir `burndown.md` com a linha do dia 0 — **a data é a da aprovação do pacote**, não a do fechamento da Planning — e atualizar a linha **"Sprint corrente"** de `.team-project/README.md` §2, que é o único índice para o quadro vivo | PO congela · SM abre o burndown e atualiza o índice | `stories/` congelado · `sprints/<n>/burndown.md` criado (R24 · §5f) · sprint corrente declarado |

**O sprint não arranca no instante em que a Planning fecha.** Entre o passo 8 e o passo 11 existe uma etapa real de calendário: costurar o protótipo do sprint e esperar o stakeholder navegá-lo. É o preço do ③ em lote, e é menor que o do ③ História por História, mas não é zero: o SM o conta na janela do sprint, e o dia 0 do burndown é o da **aprovação do pacote** — Task não entra em construção antes dele. O protótipo do sprint não é trabalho novo de especificação: o UX **já** entregou a especificação de tela de cada História candidata antes da Planning (§3a · §8), e o que se faz aqui é **costurar as telas que entraram** num caminho navegável.

**Pacote reprovado ou aprovado com ajuste volta à Planning:** o PO reordena, o corte é refeito, o protótipo é recosturado, e o pacote é resubmetido. Nada vai à construção antes. **O custo disso é declarado:** História reprovada no pacote perde a quebra e a estimativa já feitas (R20).

**A capacidade é observada, não negociada.** O SM apresenta a média entregue nos três sprints anteriores; sprint que entra acima dela exige justificativa escrita no quadro — é o gatilho de R2 aplicado ao lote. **O SM não veta escopo por valor e o PO não altera a conta de capacidade**: o primeiro diz *se cabe*, o segundo diz *o que entra*.

### Durante o sprint

O escopo do Sprint Backlog **não cresce**. Trabalho novo que aparece — GAP, pedido do stakeholder, débito — entra no Product Backlog e concorre na Planning seguinte. A exceção é o GAP que **bloqueia uma História já no sprint**: vira Task da mesma História, e o SM registra a entrada fora de Planning no quadro, com o que saiu para caber. **O escopo aprovado no pacote é o que o stakeholder viu:** Task nova que altere o que ele aprovou espera a Review, a não ser que caiba inteira dentro de uma História já aprovada e do seu critério de aceite. E **`sprints/<n>/stories/` está congelado** — mudar uma História durante o sprint é violação de escopo (R4 · R25).

### Sprint Review — fecha o trabalho (`/sm review`)

É o **segundo ponto de contato** do sprint (R25 · §5g). O PO demonstra cada História do sprint ao stakeholder, **contra os critérios de aceite que ele aprovou no pacote de abertura**, e o QA fornece a evidência por Task. **O PO conduz o aceite e escreve o dossiê critério a critério; o stakeholder decide, por História** (R21). Saída, por História: **aceita** · **aceita com ressalva** (a ressalva vira Task no Product Backlog, com dono) · **rejeitada** (todas as Tasks da História voltam ao Product Backlog, inclusive as que passaram no QA — R21). Gaps, débitos, ressalvas e erros identificados entram no Product Backlog **na mesma sessão** (R12), com dono — o PO os prioriza para o sprint seguinte, e essa priorização volta ao stakeholder embutida no próximo pacote (§5e passo 9 · R25). Bloqueio ainda aberto sobe aqui, na forma fixa de R22. O registro escrito da Review é gravado em `.team-project/sprints/<n>/review.md`.

### Sprint Retrospective — fecha o sprint (`/sm sprint close`)

Roda **depois** da Review, com o resultado dela à vista. Usa o [modelo de retrospectiva](../templates/retrospective.md), mede o footprint do processo (§5c) e produz as ações corretivas do sprint seguinte. Encerra o sprint: nada mais entra nele.

**Fechamento de `sprints/<n>/` (R24 · §5f).** Depois da retrospectiva registrada em `sprints/<n>/retrospective.md`, o SM **fecha** `sprints/<n>/sprint-backlog.md` — o quadro vivo do sprint para de ser editável no estado final, sem cópia nenhuma — e fecha `sprints/<n>/burndown.md` (seção "Fechamento" preenchida, sem mais edição depois). Os arquivos da pasta (`planning.md`, `sprint-backlog.md`, `stories/`, `plan/`, `evidence/`, `consumption.md`, `burndown.md`, `review.md`, `retrospective.md`) formam o registro completo e imutável do sprint. Esse fechamento acontece **depois** de Tasks inacabadas voltarem ao Product Backlog e de ressalvas virarem entradas com dono — o quadro fechado retrata o estado final, não um estado intermediário.

> **Não existe `sprint-backlog-snapshot.md`.** O Sprint Backlog vivo já mora dentro da pasta do sprint e simplesmente **fecha** no `/sm sprint close`, em vez de ser copiado: um arquivo e uma operação a menos, e nenhuma chance de o snapshot divergir do original.

**Registro de consumo do sprint.** `sprints/<n>/consumption.md` ([`templates/consumption.md`](../templates/consumption.md)) é escrito ao longo do sprint pela sessão que orquestra cada invocação e **fecha junto com a pasta** — não há arquivamento a fazer, porque o registro já nasce dentro do sprint a que pertence. A retrospectiva o lê **antes** do fechamento, na seção própria de consumo (§5c · [`templates/retrospective.md`](../templates/retrospective.md)). O acumulado do projeto é **derivado** — soma-se `sprints/*/consumption.md` quando alguém pergunta —, não mantido vivo.

### Como o SM verifica que o sprint aconteceu como escrito

- Toda Task do Sprint Backlog rastreia a uma História que passou pela DoR da História; Task órfã é violação de R20.
- Toda Task tem estimativa registrada antes da construção; Task sem estimativa não entra em construção.
- Nenhuma História foi aceita fora da Sprint Review (R21); nenhum `/po accept` mira uma Task.
- O **pacote de abertura** está aprovado e datado no Sprint Backlog — com quem aprovou e o ponteiro do protótipo navegado — **antes da primeira Task em construção** (R20 · R25); `planning.md` traz a lista do que veio da Review anterior e **não** entrou, com o motivo; a coluna Decisão de `review.md` está preenchida por História (R21).
- Todo bloqueio do quadro nomeia **o degrau em que está** — par PO+Arquiteto, escalado ao stakeholder, ou estratégico direto (R25).
- Nenhum arquivo de `sprints/<n>/stories/` foi alterado depois da data de aprovação do pacote (R4 · R25).
- Toda entrada de escopo fora da Planning tem a linha "o que saiu para caber" no quadro.
- Review e retrospectiva do sprint anterior estão registradas antes da Planning seguinte.
- Quando o projeto registra consumo, `sprints/<n>/consumption.md` existe e a retrospectiva o leu antes do fechamento da pasta (§5c).
- `.team-project/sprints/<n>/` existe desde a Planning (com `planning.md` e, após a aprovação do pacote, `burndown.md` de abertura) e termina o sprint completa — `sprint-backlog.md` fechado, `burndown.md` fechado, `review.md`, `retrospective.md`, e as três subpastas com o que seus donos produziram. Pasta incompleta no `/sm sprint close` é achado de processo (R24 · R25).

## 5f. Burndown do sprint — de onde vem o dado, e o que ele não mostra (R24)

O burndown mede a **estimativa restante** (unidade do projeto) das Tasks ainda não fechadas do sprint corrente, em série datada — não o estado de cada Task, que já está no Sprint Backlog. Ele existe porque, sem um ponto datado a cada evento, "o sprint está indo bem" é opinião reconstituída no fechamento, o mesmo modo de falha que R7 nomeia para evidência de código.

**De onde sai o dado.** O Sprint Backlog tem uma seção própria, o **Registro de transições** ([`templates/sprint-backlog.md`](../templates/sprint-backlog.md)): uma linha por mudança de marcador de Task (`Task · De → Para · Quando · Por quem`). `sprints/<n>/burndown.md` ([`templates/burndown.md`](../templates/burndown.md)) é a leitura em série desse registro — nunca uma segunda fonte de verdade. Os dois vivem na mesma pasta do sprint.

**Quando é gravado, e por quem.** O SM é quem escreve as duas coisas (o Sprint Backlog é dele — §1 da matriz de propriedade), em três momentos:
- **Abertura do sprint** (`/sm sprint plan`, passo 11) — todas as Tasks entram ⬜; linha de base do burndown com a soma total planejada. Data exata: a da **aprovação do pacote de abertura**, não a do fechamento da Planning (§5e passo 10), porque é dali que a construção pode começar.
- **Cada rodada de `/sm board`** — o SM sincroniza o marcador de cada Task com o que os papéis reportaram desde a última rodada (⬜→🟦 quando o Arquiteto planejou, 🟦→🟨 quando o dev começou, 🟨→🟪 quando o QA deu veredito) e grava uma linha por transição encontrada. **A data é a da rodada**, não a do evento real — granularidade declarada, não escondida.
- **Cada `/sm close <T-ID>`** — transição para ✅ (ou 🔴, se bloqueada), sempre com data exata. É o único evento que reduz a estimativa restante do burndown.

**Custo, declarado.** Este desenho reaproveita a leitura que o `/sm board` já faz — não pede a nenhum outro papel que grave timestamp no próprio comando. O preço é a granularidade: sprint com `/sm board` raro produz um burndown grosseiro (poucos pontos entre a abertura e os fechamentos); rodar `/sm board` só para alimentar o gráfico inverteria o custo-benefício. Granularidade fina por estado, com o instante exato de cada papel, exigiria tocar `commands/arc.md`/`commands/dev.md`/`commands/qa.md` — fora do alcance do SM nesta versão; fica registrado como possível pedido futuro ao stakeholder, não assumido.

**Onde persiste e quando fecha.** `.team-project/sprints/<n>/burndown.md`, criado na abertura do sprint (§5e passo 11), atualizado a cada `/sm board` e `/sm close`, e fechado — sem mais edição — no `/sm sprint close`, junto com `retrospective.md` e o próprio `sprint-backlog.md`.

## 5g. O ciclo do sprint — pacote aprovado, execução contínua, bloqueio em dois degraus (R25)

O sprint é a **unidade de aprovação e de entrega**. O stakeholder tem **dois compromissos por sprint, e só dois** — a **abertura**, onde navega e aprova o pacote (③ em lote), e a **Review**, onde decide por História (④). Entre os dois, o time roda a fila do sprint sem acioná-lo. Não há modo a declarar nem a armar: é assim que o time trabalha.

### Ponto de contato 1 — o pacote de abertura, que é o ③ em lote

Montado nos **passos 9 e 10 da Planning** (§5e), depois do corte de capacidade, porque só depois do corte se sabe **quais** Histórias entraram. Quatro peças, e as quatro são obrigatórias:

| Peça | Quem monta | Por que está no pacote |
|---|---|---|
| **Sprint Backlog fechado** — Histórias que entraram, Tasks, estimativas, dependências, objetivo do sprint | SM | é o compromisso que o stakeholder está aprovando: este trabalho, neste tempo |
| **Critérios de aceite** das Histórias que entraram | PO | é contra eles que a Review vai medir; aprovar o sprint sem ler os critérios é aprovar um título |
| **Protótipo navegável do sprint** — as telas dessas Histórias costuradas num caminho que se atravessa | UX | **navegar é o que torna a aprovação real** — mesmo princípio do portão ① (R15), agora em escala de sprint. E é a verificação do valor real: protótipo que não atravessa um fluxo ponta a ponta denuncia um sprint que não entrega fatia usável |
| **`planning.md`** — as decisões da Planning e **o que veio da Review anterior e não entrou, com o motivo** | SM escreve · PO fornece a priorização | no pacote o stakeholder vê o que **entrou**; sem esta lista, pendência crítica despriorizada passa despercebida. O PO **propõe** (valor × risco é dele, §6a); o stakeholder **aprova e pode devolver** |

**Sequenciamento — o que é novo e o que não é.** O UX **já** produz a especificação de tela de cada História candidata **antes** da Planning: é pré-condição da DoR da História e do gate do §8, e isso não muda. O trabalho novo é **costurar num protótipo navegável do sprint as telas das Histórias que sobraram do corte**. Consequência declarada: **o sprint não arranca no mesmo instante em que a Planning fecha** — há a montagem do pacote e a navegação do stakeholder entre as duas coisas, e o **dia 0 do burndown é a data da aprovação do pacote** (§5f).

O SM registra no Sprint Backlog: **data da aprovação · quem aprovou · o ponteiro do protótipo navegado · os ajustes pedidos** ([`templates/sprint-backlog.md`](../templates/sprint-backlog.md)). Essa linha **é o portão ③ de todas as Histórias do sprint**. Pacote reprovado ou aprovado com ajuste volta à Planning — nada vai à construção antes (§5e).

**O custo, declarado.** História reprovada no pacote perde a quebra e a estimativa já feitas (R20). O risco é baixo: o que se avalia ali é detalhamento funcional derivado do SDD aprovado no ①, e a Planning é barata perto do sprint.

### Como roda, entre os dois pontos

| # | O que acontece | Quem |
|---|---|---|
| 1 | História nasce do SDD aprovado no ① | PO |
| 2 | Detalhamento funcional: regras, especificação de tela, critérios de aceite verificáveis | PO, com o UX |
| 3 | Planning: varredura de bloqueios, quebra em Tasks, estimativa, corte na capacidade, objetivo | o time (SM conduz) |
| 4 | **Pacote de abertura — portão ③ em lote** | UX costura · PO junta · SM submete · **stakeholder navega e aprova** |
| 5 | `stories/` congelado; plano · construção · veredito · `/sm close`, Task a Task, **até o fim da fila do sprint** (`/team cycle sprint`, ou os comandos individuais) — todos os gates técnicos do §8 valem iguais | PO congela · Arquiteto · dev · QA · SM |
| 6 | Bloqueio que aparece: **PO e Arquiteto conversam**; não fecharam, escala na forma de R22 | PO + Arquiteto → SM registra o degrau |
| 7 | **Sprint Review — aceite por História**, gaps e débitos ao Product Backlog na mesma sessão | SM aciona e registra · PO demonstra e conduz o aceite · QA dá evidência · **stakeholder decide** |
| 8 | Retrospectiva e fechamento de `sprints/<n>/` | SM |
| 9 | Sprint seguinte | o time — repete de 1 a 8 |

**Execução contínua não é silêncio.** O canal do stakeholder continua sendo o PO (§6a): `/po status` responde a qualquer momento onde o time está, e ele pode olhar quando quiser. O que se agrega na fronteira do sprint é o **gate**, não a informação.

### Bloqueio — dois degraus antes do stakeholder (R25)

| Degrau | Onde | Quem resolve | O que acontece se não resolver |
|---|---|---|---|
| **0 — varredura** | na **Planning**, passo 3 (§5e) | SM conduz; PO responde o funcional, Arquiteto o técnico | a História **não entra** no sprint; volta ao Product Backlog. O pacote aprovado já vem sem bloqueio aberto |
| **1 — o par** | durante o sprint | **PO e Arquiteto conversam** — é o par certo, porque a pergunta quase sempre é *"o requisito está errado ou o desenho está?"* (R9 · §6b) | sobe ao degrau 2. O SM registra no quadro o resultado da conversa, resolvida ou não |
| **2 — o stakeholder** | quando o par não fecha | stakeholder, na **forma fixa de R22**: opções descritas · recomendação · a via de pedir mais contexto | fica aberto no quadro, com data e dono — e o SM o leva à Review |

**Exceção que pula o degrau 1: decisão estratégica** — stack, provedor, custo, risco aceito — escala **direto** ao stakeholder. É dele por definição (§6), e o par não pode resolvê-la; fazê-la passar pelo degrau 1 seria só atraso.

**`/sm agreement` não é degrau obrigatório.** Fica disponível se PO e Arquiteto quiserem facilitação do SM sobre a mesma questão — é a via do §6b quando o achado toca dois donos e ninguém consegue classificar.

**Veredito ⚠️/❌ do QA numa Task não é bloqueio.** É local: volta ao dev/Arquiteto pelo caminho que já existe (§4a · §6b). Só vira bloqueio se a resolução exigir decisão que o par não tem — e aí entra no degrau 1 como qualquer outra.

**O que o SM registra.** Toda linha de "Bloqueios e riscos abertos" do Sprint Backlog nomeia **o degrau em que está** (`par PO+Arquiteto desde <data>` · `escalado ao stakeholder em <data>` · `estratégico — direto`), quem destrava e desde quando. Bloqueio sem degrau nomeado é achado de processo; bloqueio parado no degrau 1 por mais de uma caixa de tempo escala.

### Manutenção — a fila `.team-project/note.md`

Sobre um produto já aceito, o ciclo é o mesmo, com uma bifurcação de forma de atendimento:

1. O stakeholder registra os relatos em `.team-project/note.md`, como sintoma (§6a).
2. O **PO** trata a fila em lote por `/po note`: classifica cada item (defeito · mudança de escopo disfarçada · dúvida de uso) e aciona a QA no que for defeito.
3. O PO decide a **forma de atendimento**, contra a **capacidade observada** (§5e — a média entregue nos três sprints anteriores, na unidade do projeto):

| Volume do lote classificado | Caminho |
|---|---|
| Cabe na **folga do sprint corrente** e não bloqueia História em voo | **correção pontual**: caminho C do fluxo (`/arc question` quando a causa não é óbvia → `/arc plan` → `/dev` → `/qa` → `/sm close`), com a entrada fora da Planning registrada e "o que saiu para caber" (§5e) |
| **Excede a folga**, ou toca mais de uma História/área, ou soma acima da capacidade observada | **sprint de manutenção**: as Histórias entram no Product Backlog e o lote vai a `/sm sprint plan` |
| O projeto **ainda não tem três sprints** de histórico | **sprint planejado**, sempre — sem capacidade observada não há folga verificável, e é o sprint que produz a medição |

**Quem decide é o PO; contra o quê, a capacidade observada.** O SM fornece a conta (folga, Tasks em voo, dependências) e recusa a correção pontual que não couber; o PO decide o que entra e em que forma (§6a). Não há limiar mágico de "n itens": o divisor é a capacidade que **este** projeto já demonstrou.

**Onde entram os dois pontos de contato aqui.** O **sprint de manutenção** é um sprint como os outros: tem pacote de abertura e Review com aceite por História. A **correção pontual** não é sprint e não tem pacote — segue o caminho C, com a entrada fora de Planning e o "o que saiu para caber" registrados (§5e), e o seu resultado aparece na Review do sprint corrente. Exigir aprovação de sprint para uma correção pontual sobre um produto já aceito seria burocracia sem ganho: ali o baseline é conhecido e a regressão é detectável pelo QA.

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

Nenhum agente devolve pergunta ao stakeholder sem antes tentar resolvê-la no papel correto (R9) — e, dentro do sprint, sem antes passar pelo **degrau 1** de R25 (PO e Arquiteto), salvo decisão estratégica, que vai direto (§5g). **Exceções declaradas:** no `brainstorm` (§5b), no passo 5 do `onboarding` (§5a), na **aprovação do pacote de abertura** (portão ③, §5e) e na **Sprint Review** (portão ④) o stakeholder é participante — o diálogo direto ali é co-criação ou aceite, não escalação. O que sobe a ele fora desses momentos vem na forma fixa de R22 — opções descritas, recomendação e a via de pedir mais contexto, **resolvida em formulário pela sessão que orquestra**, não em texto corrido.

**Quando a dúvida atravessa papéis**, use `/sm agreement <questão>`: o SM identifica **quais papéis a questão toca**, chama só esses, consolida **uma** recomendação e registra a divergência que sobrou. Não é broadcast — reunir os seis para uma questão de dois é desperdício (R3). **Acordo não transfere a decisão**: o dono do assunto continua decidindo no seu domínio, e o que sobra de divergência sobe ao stakeholder.

## 7. Sequenciamento

1. **Uma Task em construção por dev** (R1). Com um único dev, o Sprint Backlog é fila, não board paralelo.
2. **O paralelismo é entre papéis** — dev na Task *n*, Arquiteto planejando a *n+1*, PO detalhando a História do sprint seguinte.
2a. **Paralelismo de papéis pesados tem limite, fora dos fluxos que já o preveem de propósito.** Quem orquestra evita disparar **três ou mais papéis pesados** (Arquiteto, UX, e qualquer outro que esteja fazendo verificação real custosa — harness completo, chamada real a API externa) **simultaneamente**, porque isso empilha picos de consumo de tokens/tempo na mesma janela e contribui para estourar o limite de taxa da conta. **Não revoga** o paralelismo já desenhado deliberadamente em fluxos como o `brainstorm` (§5b — fase 1 com PO+UX simultâneos, fase 2 com o Arquiteto entrando logo em seguida): esses continuam como estão. **Como o SM verifica:** nenhuma leva de disparo do orquestrador soma três ou mais `agents/<papel>.md` pesados simultâneos fora de um fluxo que já prevê esse paralelismo por desenho (`brainstorm`); ocorrência fora desses fluxos é achado de processo, roteado a quem orquestrou.
3. **Task cabe em uma unidade de trabalho** (R2); acima disso, quebra em `<ID>a`/`<ID>b` — nunca estourando a fronteira da História.
4. **Passos ordenados para manter o repositório íntegro** no maior número de pontos intermediários (R5).
5. **Uma migration de banco por Task**; Tasks que compartilham migration viram uma Task só.
6. **Interrupção é estado** — o relatório diz onde parou; a retomada continua dali. Sprint que termina com Task em construção devolve a Task ao Product Backlog junto com a História.

> Se o time tiver **mais de um dev**, reative a regra de faixas: no máximo uma faixa por dev, com conjuntos de arquivos **disjuntos**; havendo interseção, serialize e registre o motivo; migration nunca em paralelo; arquivo de configuração compartilhado pertence a uma faixa por sprint.

## 8. Gates de qualidade (não negociáveis)

**Nenhum gate abaixo é dispensável.** Dois — o **③** e o **④** — mudam de **forma e de momento**, nunca de dono: o ③ é aprovado pelo stakeholder **em lote, depois da Planning**, sobre o **pacote de abertura do sprint** (Sprint Backlog fechado + critérios de aceite + protótipo navegável + `planning.md`), em vez de História por História antes dela; e o ④ é o **aceite por História na Review**, que o PO conduz e o **stakeholder decide** (R21 · R25 · §5e · §5g). As duas linhas estão marcadas na tabela. **Todo o resto é incondicional** — o ①, o ②, e cada gate de qualidade técnica (plano, standard, build e testes, segurança, documentação, evidência): nada dispensa evidência real (R7) nem gate técnico, pela mesma condição de guarda-corpo que R23 impõe ao modo leve. Gate marcado como dispensado citando o ciclo do sprint é achado de processo — **o ciclo do sprint agrega gates funcionais na fronteira do sprint; não remove nenhum**.

| Gate | Bloqueia | Responsável | Regra |
|---|---|---|---|
| Onboarding concluído | primeira Planning Meeting do projeto | SM | R14 |
| Ideia sem documentação passou por `brainstorm` | primeiro documento do SDD daquela área | SM | R15 |
| **Protótipo funcional em HTML existe e cobre os fluxos principais** | o portão ① | UX | R8 · R15 |
| **① SDD funcional (`00`,`01`,`02`) aprovado pelo stakeholder, com o protótipo NAVEGADO** | primeira escrita do SDD técnico (`03`,`04`,`05`) | PO e UX apresentam · SM verifica | R15 · §5b |
| **② SDD técnico aprovado** | escrita da primeira História daquela área | Arquiteto apresenta · SM verifica | §5b |
| **③ Detalhamento da História aprovado pelo stakeholder — em lote, no pacote de abertura do sprint**, depois da Planning | **entrada de qualquer Task do sprint em construção** | PO apresenta · UX costura o protótipo do sprint · SM submete e registra | R20 · R25 · §3a · §5e passos 9–10 |
| **Especificação de tela existe** *(História com interface)* — com os seis estados e os critérios de acessibilidade | entrada da História na Planning (DoR — §3a) | UX | R8 |
| **Protótipo navegável do sprint existe, cobre as Histórias que entraram e atravessa um fluxo ponta a ponta** | a aprovação do pacote de abertura, e portanto o arranque do sprint | UX | R25 · §5e passo 10 |
| **`planning.md` declara o que veio da Review anterior e não entrou, com o motivo** | a submissão do pacote ao stakeholder | SM escreve · PO fornece a priorização | R25 · §5e passo 9 |
| **Bloqueio passou pelo degrau 1 (PO + Arquiteto)** antes de subir ao stakeholder — exceto decisão estratégica, que vai direto | a escalação ao stakeholder dentro do sprint | SM registra o degrau | R9 · R25 · §5g |
| Task pertence a uma História que passou na DoR da História | quebra na Planning | SM | R20 |
| Estimativa registrada na unidade do projeto | construção | SM | R2 · §5e |
| Plano de Implementação existe | construção | Arquiteto | R8 |
| Plano traz o **ambiente medido** (comando + saída — próprias ou do `operator`, com o caminho do log bruto), os comandos citados validados naquela versão, e parada incondicional para pré-requisito **ausente** | construção | Arquiteto | R26 |
| Plano cita a seção de `${CLAUDE_PLUGIN_ROOT}/standards/` que a mudança de engenharia toca | construção | Arquiteto | R16 |
| Seção de standard **exigida pela Task** presente no plano e aplicada no código | veredito | QA | R16 · §4a |
| Build sem avisos + testes passando | veredito | QA | R7 |
| Segurança: identidade, permissão, auditoria, segredo | veredito | QA | R11 |
| Documentação atualizada | fechamento da Task | QA | R12 |
| Evidência registrada | fechamento da Task | QA/SM | R7 |
| **④ Aceite funcional da História, na Sprint Review** — o PO conduz o aceite e escreve o dossiê; o **stakeholder decide**, por História | encerramento do sprint | PO demonstra · QA dá evidência · SM aciona e registra | R21 · R25 · §5e · §5g |
| Bump de `version` + banner "Versão atual" do `README.md` + entrada no `CHANGELOG.md` nomeando a branch | merge do PR em `develop` | stakeholder (SM verifica) | R18 · §5d |

## 9. Ambiente de verificação

Os comandos, os limiares e as limitações conhecidas do ambiente são específicos de cada projeto e vivem em `.team-project/quality-assurance/context.md` (verificação) e `.team-project/developer/context.md` (execução).

**Regra que não muda:** limitação de ambiente que impeça uma verificação é **declarada** no veredito como "não exercitado", nunca omitida.
