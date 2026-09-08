# Fluxo de Trabalho — Como o trabalho circula entre os papéis

> **Dono:** SM · Complementa [`working-rules.md`](working-rules.md): lá estão as regras, aqui está a mecânica.

## 1. Duas unidades: a **História** e a **Task**

| Unidade | Responde | Dono | Enfoque | Vive em |
|---|---|---|---|---|
| **História** | *que valor o stakeholder recebe* | PO | **só funcional** — regra, protótipo, critério de aceite | Product Backlog (`.team-project/product-owner/`) |
| **Task** | *que trabalho o time faz para entregar aquele valor* | SM (quadro) · Arquiteto (o plano dentro dela) | técnico — passos, arquivos, verificação | Sprint Backlog (`.team-project/scrum-master/`) |

**O conjunto das Histórias é o Product Backlog.** Uma História nasce do SDD, é detalhada quando vai entrar num sprint, e é quebrada em Tasks pelo time na Planning Meeting. **Toda Task pertence a exatamente uma História** (R20); Task sem História é trabalho que ninguém pediu.

A Task carrega ID, título, História de origem, dono, dependências, estimativa, critério de pronto, **evidência esperada** e o **Plano de Implementação** escrito pelo Arquiteto. A convenção de IDs de cada projeto está em `.team-project/scrum-master/context.md` — tipicamente `H-nnn` para História, `T-nnn` para Task, sufixo para quebra (`T-012a`, `T-012b`), e o ID do GAP reusado quando a Task nasce de um GAP.

## 2. Do SDD à entrega — a cadeia

```
SDD funcional (PO: 00, 01, 02)
  └─ ① stakeholder aprova ──▶ SDD técnica (Arquiteto: 03, 04, 05)
       └─ ② aprovada ──▶ Histórias (PO)  ═══ conjunto = Product Backlog
            └─ detalhamento da História: regras · protótipos (UX) · critérios de aceite
                 └─ ③ stakeholder aprova, apresentado pelo PO
                      └─ Planning Meeting ──▶ Sprint Backlog
                           └─ time quebra em Tasks e estima (§5e)
                                └─ Arquiteto escreve o Plano de Implementação
                                     └─ dev constrói ──▶ QA dá veredito ──▶ SM fecha a Task
                                          └─ Sprint Review: ④ PO aceita a História
                                               └─ Sprint Retrospective
```

Os quatro portões numerados são os gates de §8. **O detalhamento da História é sempre e apenas funcional** — nenhuma decisão técnica entra ali; ela nasce na Task, no Plano de Implementação.

### 2a. Ciclo da Task

| # | Etapa | Quem | Comando | Saída |
|---|---|---|---|---|
| 0 | Onboarding do projeto *(uma vez, projeto novo ou retomado)* | SM coordena, os seis papéis participam | `/sm onboarding` | Entendimento alinhado, contexto preenchido, quadro aberto (R14 · §5a) |
| 0b | Brainstorm *(só ideia sem documentação)* | SM facilita · fase 1: stakeholder + PO + UX · fase 2: + Arquiteto | `/team brainstorm <ideia>` | Brief funcional fechado, pronto para o SDD (R15 · §5b) |
| 1 | História criada a partir do SDD | PO | `/po story <ID>` | História no Product Backlog, com o valor declarado |
| 2 | Detalhamento da História *(quando ela candidata a um sprint)* | PO, com o UX nos protótipos | `/po story <ID>` (modo detalhe) · `/ux journey` · `/ux screen <ID>` | Regras, protótipos e critérios de aceite — só funcional |
| 3 | Planning Meeting | SM conduz, o time inteiro participa | `/sm sprint plan` | Sprint Backlog: Histórias aprovadas quebradas em Tasks, estimadas, dentro da capacidade (§5e) |
| 4 | Plano de Implementação | Arquiteto | `/arc plan <Task>` | Plano dentro da Task, citando a especificação de tela e as seções de standard |
| 5 | Construção | dev | `/dev <Task>` | Código + testes + relatório de entrega |
| 6 | Gap durante a construção | dev → Arquiteto | `/arc question` → `/dev gap` | Decisão do Arquiteto, dev retoma |
| 7 | Validação | QA | `/qa <Task>` | Veredito ✅/⚠️/❌ com evidência |
| 8 | Fechamento da Task | SM | `/sm close <Task>` | Quadro + documento de status atualizados — **fechamento técnico, não aceite** |
| 9 | Sprint Review | PO demonstra, stakeholder responde | `/sm review` | História aceita / com ressalva / rejeitada · gaps e débitos ao backlog |
| 10 | Sprint Retrospective | SM conduz | `/sm sprint close` | Retrospectiva + fechamento do sprint (§5c · §5e) |

`/team cycle <Task>` encadeia 4→5→6→7 sem intervenção manual e para no primeiro problema; os modos parciais `/team plan|build|qa <Task>` rodam uma etapa só. Use os comandos individuais para acompanhar etapa por etapa.

As etapas 0 e 0b são **anteriores à cadeia** e não se repetem por Task: o onboarding acontece uma vez por projeto (R14); o brainstorm, uma vez por ideia sem documentação (R15), e alimenta o SDD funcional, não o substitui.

**O aceite não está no fechamento da Task.** A etapa 8 encerra o trabalho técnico com o veredito do QA; quem diz que o valor chegou é o PO, por História, na Sprint Review (R21 · etapa 9). Task fechada dentro de uma História rejeitada volta ao sprint seguinte junto com as demais da mesma História.

## 3. Definition of Ready

### 3a. DoR da História — pode entrar na Planning Meeting?

- [ ] Rastreia a um requisito do SDD funcional já aprovado (portão ① de §8)
- [ ] O valor ao stakeholder está escrito em uma frase — o que ele passa a conseguir fazer
- [ ] Regras funcionais escritas, sem decisão técnica embutida
- [ ] **História com interface:** protótipo do UX existente, com os seis estados e os critérios de acessibilidade
- [ ] Critérios de aceite escritos pelo PO e **verificáveis**
- [ ] Aprovada pelo stakeholder, apresentada pelo PO (portão ③)

### 3b. DoR da Task — pode entrar em construção?

- [ ] Pertence a uma História que passou pela DoR da História (R20)
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
- [ ] **Aceite do PO registrado** (R21)
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
| Escrita e detalhamento de História | História nasce do SDD; é detalhada quando candidata a um sprint | `/po story <ID>` | 1 História |
| **Planning Meeting** | abre cada sprint | `/sm sprint plan` | Sprint Backlog fechado (§5e) |
| Daily | início de cada sessão | `/sm status` | 6 linhas |
| Refinamento técnico | antes de construir uma Task | `/arc plan <Task>` | 1 plano |
| Validação | ao fim de cada Task | `/qa <Task>` | veredito com evidência |
| **Sprint Review** | fecha cada sprint, antes da retrospectiva | `/sm review` | aceite por História + gaps e débitos (§5e) |
| **Sprint Retrospective** | fecha cada sprint, depois da Review | `/sm sprint close` | [template](../templates/retrospective.md) · mede o footprint do processo (§5c) |
| Auditoria cruzada | a cada 3 sprints | `/qa audit` | achados, sem correção |
| Consulta ao time | decisão que atravessa papéis | `/team <pergunta>` | posições + convergências + divergências |
| Acordo | quando se quer uma posição única | `/team agreement <questão>` | recomendação do SM, com a divergência registrada |
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
| 5 | **Consolidação + perguntas ao stakeholder** — o SM funde as leituras num quadro único e produz **uma** lista de perguntas que só o stakeholder responde: estratégicas (provedor, alvo da retomada, ordem de prioridade), a **duração do sprint** e a **unidade de estimativa** se ainda não estiverem no contexto, e lacunas funcionais pequenas que a documentação não cobriu e que não justificam um brainstorm. Cada pergunta traz: por que bloqueia · opções · recomendação do time (R9 — o time tentou responder antes) | SM | Lista de decisões pendentes do stakeholder |
| 6 | **Registro do alinhamento** — o SM escreve o entendimento comum no contexto do projeto (`.team-project/README.md` e os `context.md` recebem aporte de cada papel) e abre o quadro de trabalho | SM | Contexto do projeto preenchido e datado, quadro aberto |

**O que o SM pergunta primeiro à documentação:** propósito e fase do produto (`00-overview`), requisitos e seus critérios de aceite (`01-requirements`), atores e fluxos (`02-flows`), princípios de arquitetura e vinculação de stack (`03-architecture`), contratos de dados e API (`04`/`05`), o que está construído e com que evidência (`02-status`, `03-code-map`, `pending`), ambiente e comandos de verificação, capacidade declarada, limitações conhecidas, riscos e bloqueios abertos.

**O que o SM escala ao stakeholder** (só depois de esgotar a documentação e o time): decisões estratégicas (stack, provedor, custo, alvo da retomada, prioridade acima da ordem de dependência do SM), os dois parâmetros de cadência (duração do sprint, unidade de estimativa) e lacunas funcionais pequenas não respondíveis pela documentação — sempre com opções + recomendação.

**Condição de saída — o onboarding está pronto quando:**
- [ ] Toda linha do inventário de fontes está preenchida (existe / desatualizada / ausente), e toda "ausência de doc funcional essencial" foi produzida via brainstorm ou aceita como risco pelo stakeholder.
- [ ] Os outros cinco papéis registraram a leitura de entrada (mandato entendido + o que falta + um risco); o SM coordena e consolida, não escreve uma sobre si.
- [ ] A lista de perguntas só-do-stakeholder foi respondida ou explicitamente adiada com o risco aceito.
- [ ] `.team-project/README.md` reflete o entendimento alinhado (objetivo, fase, stack, ambiente, fontes da verdade, capacidade, **duração do sprint**, **unidade de estimativa**, restrições) e toda divergência status × código está no quadro como risco.
- [ ] O quadro existe, com ao menos uma onda de Histórias candidatas, ou uma nota de que o planejamento está bloqueado aguardando brainstorm/decisão do stakeholder.

**Como o SM verifica que aconteceu:** a resposta do onboarding traz a tabela de inventário preenchida e as cinco leituras de entrada; `.team-project/README.md` está datado em/após o onboarding com §4 e §7 populadas; nenhuma Planning Meeting do projeto precede o registro de onboarding; toda divergência narrativa × código é linha na tabela de riscos do quadro.

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
| — | **Portão ①: o stakeholder aprova o SDD funcional** | stakeholder | — |
| 2 | `03-architecture` (incl. Ficha de Vinculação de Stack §2b), `04-data-model`, `05-api-model` — só as partes da primeira fatia — **o SDD técnico** | **Arquiteto** | — |
| — | **Portão ②: o SDD técnico é aprovado** | stakeholder | — |
| 3 | Histórias a partir dos requisitos aprovados | **PO** | `/po story <ID>` |

O brief de brainstorm **não** é entregável permanente: é absorvido por `00-overview` / `01-requirements` e pelo registro de processo, e não vira arquivo novo sem lugar declarado em `.team-project/`.

**Como o SM verifica:** a saída do brainstorm mostra as duas fases com os participantes declarados — fase 1 sem o Arquiteto, fase 2 com ele; cada rodada de fase 2 tem delta registrado ou "sem mudança — ponto fixo"; no fechamento, `00-overview` + `01-requirements` + `02-flows` são criados/atualizados pelo PO no mesmo ciclo (R12) e o índice do SDD mostra a versão nova; **nenhum documento do SDD técnico foi escrito antes do portão ①, e nenhuma História antes do portão ②**; o brief não virou arquivo sem lugar declarado.

## 5c. Ciclo de eficiência dos documentos do processo (PDCA)

O custo dos documentos de `${CLAUDE_PLUGIN_ROOT}/` não pode depender de uma faxina eventual do stakeholder. Cada papel verifica periodicamente o peso dos **próprios** documentos e propõe corte. O ciclo usa gatilhos que **já existem** — nenhuma cerimônia nova.

| Fase | Onde já acontece | O que a eficiência acrescenta |
|---|---|---|
| **Plan** | `/review metrics` (a cada 3 retrospectivas, ou métrica estourada) | Reafirma o teto de footprint por papel e o alvo do período: ao menos **uma** remoção candidata nomeada |
| **Do** | operação normal + cada `/review` | Papéis editam seus documentos; toda entrada de changelog respeita R17 |
| **Check** | `/review` sem instrução (reavaliação do conjunto, linha "Excesso") + retrospectiva | Passa a ser quantitativo: o papel mede seu footprint e compara com o valor anterior registrado; a retrospectiva registra total e Δ |
| **Act** | `/review metrics` + `/review <instrução>` | O SM consolida os footprints numa tabela por papel, escolhe **uma** mudança, roteia o corte ao dono; entrada no changelog com o indicador (KB antes/depois) |

**Métrica por papel:** KB da carga fixa por invocação (`agents/<papel>.md` + `commands/<papel>.md`) **+** KB do conjunto do papel (`roles/<papel>/` — README, skills, templates; para o SM, também `process/`).

**Gatilhos:**
- *Medição* — em todo `/review` sem instrução (o papel já faz a reavaliação do conjunto ali; passa a anexar os dois números) e na retrospectiva de cada sprint (o SM mede o total do processo).
- *Giro completo* — casado com `/review metrics`: a cada 3 retrospectivas — ou seja, a cada 3 sprints —, ou antecipado por limiar.
- *Limiar que dispara Act fora de cadência* — footprint de um papel cresce > 20% entre dois giros sem regra ou cerimônia nova que o justifique; **ou** qualquer entrada de changelog passa de 10 KB (R17); **ou** o footprint total de `${CLAUDE_PLUGIN_ROOT}/` cresce dois giros seguidos sem nenhuma remoção registrada.

**Onde fica registrado, para ser comparável no tempo:** a tabela de footprint por papel vai na saída de `/review metrics`; quando o giro gera entrada no changelog — o caso normal, um corte por giro —, os números ficam ali, no campo "Como saberemos que funcionou" do modelo [`process-change.md`](../templates/process-change.md). Entre giros, a retrospectiva carrega a linha "carga fixa do processo (KB): atual / retro anterior / Δ" como série contínua.

**O que a fase Check candidata à remoção:** modelo que ninguém referencia, seção que repete outra, regra sem citação em 3 sprints, entrada de changelog acima do teto. Processo que só cresce deixa de ser seguido — revisar é também remover.

## 5d. Atualização e lançamento do plugin

O **processo do time** (os documentos de `${CLAUDE_PLUGIN_ROOT}/`) evolui por `/review`, no repositório-fonte. Chegar às instalações onde o time está instalado é outro passo: uma **entrega versionada**. Os dois registros não se confundem —

| Registro | Arquivo | Versão | Alimentado por | Dono |
|---|---|---|---|---|
| Evolução das regras de trabalho | `roles/scrum-master/process/process-changelog.md` | `vX.Y` | `/review` (SM cura) | SM |
| Entrega do plugin às instalações | `CHANGELOG.md` (raiz) | `vMAJOR.MINOR.PATCH` | fechamento de entrega | stakeholder |

### Ciclo de uma entrega
1. **Branch** `fix/vX.Y.Z` ou `feat/vX.Y.Z` a partir de `main`.
2. As correções e melhorias da entrega — inclusive as aplicadas por `/review` — vão nessa branch, que acumula até o stakeholder sinalizar o fechamento da versão.
3. **PR para `main`**, para aprovação do stakeholder.
4. **Bump** de `version` em `.claude-plugin/plugin.json` para `vX.Y.Z`.
5. **Entrada** no topo de `CHANGELOG.md`: o que foi entregue, a branch e como verificar.
6. No merge, os clientes são avisados e atualizam com **`/team update`** (ou os comandos nativos `claude plugin marketplace update` + `claude plugin update`).

### Regra de numeração
- `MAJOR.MINOR` acompanham a versão do changelog do processo **quando a entrega inclui mudança de processo**: uma entrega que carrega uma entrada nova de `process-changelog.md` (`vX.Y`) é lançada como `vX.Y.0`. A colisão numérica entre os dois changelogs é intencional e sinaliza o par.
- `PATCH` (`vX.Y.1`, `vX.Y.2`…) é correção sobre a mesma linha, sem mudança de processo.
- Entrega de escopo fechado (nova capacidade de comando, faxina, correção) incrementa `MINOR` ou `PATCH` sem tocar o changelog do processo — e a entrada em `CHANGELOG.md` diz isso explicitamente.

### O que o SM reconcilia (curadoria do `/review`)
- Toda entrada nova de `process-changelog.md` tem entrada correspondente em `CHANGELOG.md` na mesma linha `vX.Y`, ou a divergência é registrada.
- `version` de `.claude-plugin/plugin.json` == a versão da entrada do topo de `CHANGELOG.md`.
- Nenhuma entrada de `CHANGELOG.md` afirma "sem mudança de processo" quando a entrega, de fato, carrega uma.

### `/team update` — lado da instalação
Roda **na cópia instalada**, nunca no repositório-fonte (guarda: recusa se `${CLAUDE_PLUGIN_ROOT}/.git/` existir). Compara a `version` instalada com a do `main` da origem canônica, mostra o delta do `CHANGELOG.md` e, após confirmação, aplica. Reiniciar a sessão continua manual. Os passos estão em [`team-update.md`](../../../team-update.md), lido só nesse modo; `commands/team.md` só aponta para lá.

## 5e. O sprint — caixa de tempo

O sprint é a **unidade de cadência do time**: uma caixa de tempo de duração fixa, declarada em `.team-project/README.md` e respondida pelo stakeholder no onboarding (§5a, passo 5). O processo não fixa a duração — fixa que ela **não muda dentro do sprint**.

### Planning Meeting — abre o sprint (`/sm sprint plan`)

| # | Passo | Quem | Saída |
|---|---|---|---|
| 1 | Fechar o sprint anterior, se houver: Review feita, retrospectiva registrada, Tasks não concluídas devolvidas ao Product Backlog **com a História a que pertencem** | SM | Sprint anterior encerrado |
| 2 | Selecionar as Histórias candidatas do Product Backlog, na ordem do PO, **só as que passaram na DoR da História** (§3a) | PO propõe, SM confere a DoR | Lista de candidatas |
| 3 | Quebrar cada História em **Tasks** | o time (Arquiteto conduz, dev e QA contribuem) | Tasks com título, dependências e critério de pronto |
| 4 | **Estimar cada Task** na unidade declarada em `.team-project/README.md` | o time | Estimativa por Task |
| 5 | Somar as estimativas e cortar no limite da **capacidade do sprint** — a capacidade sai da média das entregas anteriores, não do desejo | SM | Sprint Backlog fechado |
| 6 | Declarar o **objetivo do sprint** em uma frase, derivado das Histórias que entraram | PO | Objetivo do sprint no quadro |

**A capacidade é observada, não negociada.** Sprint que entra com soma acima da média entregue nos três sprints anteriores exige justificativa escrita no quadro — é o gatilho de R2 aplicado ao lote.

### Durante o sprint

O escopo do Sprint Backlog **não cresce**. Trabalho novo que aparece — GAP, pedido do stakeholder, débito — entra no Product Backlog e concorre na Planning seguinte. A exceção é o GAP que **bloqueia uma História já no sprint**: vira Task da mesma História, e o SM registra a entrada fora de Planning no quadro, com o que saiu para caber.

### Sprint Review — fecha o trabalho (`/sm review`)

O PO demonstra cada História do sprint ao stakeholder, **contra os critérios de aceite que ele mesmo aprovou no detalhamento**, e o QA fornece a evidência por Task. Saída, por História: **aceita** · **aceita com ressalva** (a ressalva vira Task no Product Backlog, com dono) · **rejeitada** (todas as Tasks da História voltam ao Product Backlog, inclusive as que passaram no QA — R21). Gaps e débitos identificados entram no Product Backlog na mesma sessão (R12).

### Sprint Retrospective — fecha o sprint (`/sm sprint close`)

Roda **depois** da Review, com o resultado dela à vista. Usa o [modelo de retrospectiva](../templates/retrospective.md), mede o footprint do processo (§5c) e produz as ações corretivas do sprint seguinte. Encerra o sprint: nada mais entra nele.

### Como o SM verifica que o sprint aconteceu como escrito

- Toda Task do Sprint Backlog rastreia a uma História que passou pela DoR da História; Task órfã é violação de R20.
- Toda Task tem estimativa registrada antes da construção; Task sem estimativa não entra em construção.
- Nenhuma História foi aceita fora da Sprint Review (R21); nenhum `/po accept` mira uma Task.
- Toda entrada de escopo fora da Planning tem a linha "o que saiu para caber" no quadro.
- Review e retrospectiva do sprint anterior estão registradas antes da Planning seguinte.

## 6. Escalação

```
dúvida de implementação  ──▶ Arquiteto        (dev nunca decide sozinho)
dúvida de regra/fluxo    ──▶ PO
dúvida de tela/jornada   ──▶ UX
dúvida de prioridade     ──▶ SM
lacuna de especificação  ──▶ PO ──▶ stakeholder (3 opções + recomendação)
decisão estratégica      ──▶ stakeholder       (stack, provedor, custo, risco aceito)
exceção a um padrão      ──▶ stakeholder ──▶ ADR escrita pelo Arquiteto
defeito em ${CLAUDE_PLUGIN_ROOT}/standards/ ──▶ Arquiteto (dev: 🔺 GAP · QA: achado de processo) ──▶ /review   (R16)
```

Nenhum agente devolve pergunta ao stakeholder sem antes tentar resolvê-la no papel correto (R9). **Exceções declaradas:** no `brainstorm` (§5b), no passo 5 do `onboarding` (§5a), na **aprovação do detalhamento da História** (portão ③) e na **Sprint Review** (portão ④) o stakeholder é participante — o diálogo direto ali é co-criação ou aceite, não escalação; o que sobe a ele mesmo assim vem com opções e recomendação.

**Quando a dúvida atravessa papéis**, use `/team` em vez de perguntar a cada um: os seis respondem em paralelo e a resposta já vem com convergências e divergências separadas. Com `/team agreement`, o SM consolida numa recomendação única. **Consultar o time não transfere a decisão**: o dono do assunto continua decidindo no seu domínio, e o que sobra de divergência sobe ao stakeholder.

## 7. Sequenciamento

1. **Uma Task em construção por dev** (R1). Com um único dev, o Sprint Backlog é fila, não board paralelo.
2. **O paralelismo é entre papéis** — dev na Task *n*, Arquiteto planejando a *n+1*, PO detalhando a História do sprint seguinte.
3. **Task cabe em uma unidade de trabalho** (R2); acima disso, quebra em `<ID>a`/`<ID>b` — nunca estourando a fronteira da História.
4. **Passos ordenados para manter o repositório íntegro** no maior número de pontos intermediários (R5).
5. **Uma migration de banco por Task**; Tasks que compartilham migration viram uma Task só.
6. **Interrupção é estado** — o relatório diz onde parou; a retomada continua dali. Sprint que termina com Task em construção devolve a Task ao Product Backlog junto com a História.

> Se o time tiver **mais de um dev**, reative a regra de faixas: no máximo uma faixa por dev, com conjuntos de arquivos **disjuntos**; havendo interseção, serialize e registre o motivo; migration nunca em paralelo; arquivo de configuração compartilhado pertence a uma faixa por sprint.

## 8. Gates de qualidade (não negociáveis)

| Gate | Bloqueia | Responsável | Regra |
|---|---|---|---|
| Onboarding concluído | primeira Planning Meeting do projeto | SM | R14 |
| Ideia sem documentação passou por `brainstorm` | primeiro documento do SDD daquela área | SM | R15 |
| **① SDD funcional (`00`,`01`,`02`) aprovado pelo stakeholder** | primeira escrita do SDD técnico (`03`,`04`,`05`) | PO apresenta · SM verifica | R15 · §5b |
| **② SDD técnico aprovado** | escrita da primeira História daquela área | Arquiteto apresenta · SM verifica | §5b |
| **③ Detalhamento da História aprovado pelo stakeholder** | entrada da História na Planning Meeting | PO apresenta · SM verifica | R20 · §3a |
| Protótipo de tela existe *(História com interface)* | aprovação do detalhamento | UX | R8 |
| Task pertence a uma História que passou na DoR da História | quebra na Planning | SM | R20 |
| Estimativa registrada na unidade do projeto | construção | SM | R2 · §5e |
| Plano de Implementação existe | construção | Arquiteto | R8 |
| Plano cita a seção de `${CLAUDE_PLUGIN_ROOT}/standards/` que a mudança de engenharia toca | construção | Arquiteto | R16 |
| Seção de standard **exigida pela Task** presente no plano e aplicada no código | veredito | QA | R16 · §4a |
| Build sem avisos + testes passando | veredito | QA | R7 |
| Segurança: identidade, permissão, auditoria, segredo | veredito | QA | R11 |
| Documentação atualizada | fechamento da Task | QA | R12 |
| Evidência registrada | fechamento da Task | QA/SM | R7 |
| **④ Aceite funcional da História, na Sprint Review** | encerramento do sprint | PO | R21 · §5e |
| Bump de `version` + entrada no `CHANGELOG.md` nomeando a branch | merge do PR em `main` | stakeholder (SM verifica) | R18 · §5d |

## 9. Ambiente de verificação

Os comandos, os limiares e as limitações conhecidas do ambiente são específicos de cada projeto e vivem em `.team-project/quality-assurance/context.md` (verificação) e `.team-project/developer/context.md` (execução).

**Regra que não muda:** limitação de ambiente que impeça uma verificação é **declarada** no veredito como "não exercitado", nunca omitida.
