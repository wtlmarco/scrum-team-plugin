# Fluxo de Trabalho — Como as tarefas circulam entre os papéis

> **Dono:** SM · Complementa [`working-rules.md`](working-rules.md): lá estão as regras, aqui está a mecânica.

## 1. Unidade de trabalho: o **item**

Todo trabalho é um item com **ID**. A convenção de IDs de cada projeto está em `.team-project/scrum-master/context.md` — tipicamente: reusar o ID do GAP quando existir, usar o ID do requisito para escopo novo, `OPS-nn` para item de processo, e sufixo para quebra (`<ID>a`, `<ID>b`).

Um item só entra no quadro com: ID · título · origem · dono · dependências · critério de pronto · **evidência esperada**.

## 2. Ciclo completo

| # | Etapa | Quem | Comando | Saída |
|---|---|---|---|---|
| 0 | Onboarding do projeto *(uma vez, projeto novo ou retomado)* | SM coordena, os seis papéis participam | `/sm onboarding` | Entendimento alinhado, contexto do projeto preenchido, quadro aberto (R14 · §5a) |
| 0b | Brainstorm *(só ideia sem documentação)* | SM facilita · fase 1: stakeholder + PO + UX · fase 2: + Arquiteto | `/team brainstorm <ideia>` | Brief funcional fechado, pronto para a elaboração do SDD (R15 · §5b) |
| 1 | Análise funcional | PO | `/po analyze <ideia>` | Decisão + requisito com critério de aceite |
| 2 | Entrada no backlog | SM | `/sm plan` | Item no quadro, ordenado, com dependências |
| 2a | Jornada e tela *(só item com interface)* | UX | `/ux screen <ID>` | Especificação com os seis estados e critérios de acessibilidade |
| 3 | Especificação técnica | Arquiteto | `/arc plan <ID>` | Plano de Execução no projeto, citando a especificação de tela |
| 4 | Construção | dev | `/dev <ID>` | Código + testes + relatório de entrega |
| 5 | Gap durante a construção | dev → Arquiteto | `/arc question` → `/dev gap` | Decisão do Arquiteto, dev retoma |
| 6 | Validação | QA | `/qa <ID>` | Veredito ✅/⚠️/❌ com evidência |
| 7 | Aceite | PO | `/po accept <ID>` | Aceito / com ressalva / rejeitado |
| 8 | Fechamento | SM | `/sm close <ID>` | Quadro + documento de status atualizados |

`/team cycle <ID>` encadeia 3→4→5→6 sem intervenção manual e para no primeiro problema. Use os comandos individuais para acompanhar etapa por etapa.

As etapas 0 e 0b são **anteriores ao ciclo** e não se repetem por item: o onboarding acontece uma vez por projeto (R14); o brainstorm acontece uma vez por ideia sem documentação (R15) e alimenta a etapa 1, não a substitui.

## 3. Definition of Ready (DoR) — pode entrar em construção?

- [ ] Critério de aceite escrito pelo PO e verificável
- [ ] Origem rastreada (GAP registrado ou requisito especificado)
- [ ] Dependências resolvidas ou explicitamente aceitas como risco
- [ ] **Item com interface:** especificação de tela do UX existente, com os seis estados e os critérios de acessibilidade
- [ ] Plano de Execução existente, dimensionado para uma unidade de trabalho (R2)
- [ ] Segurança endereçada **no plano** quando o item é sensível (R11)
- [ ] Comandos de verificação executáveis neste ambiente, ou a limitação declarada (R7)

## 4. Definition of Done (DoD) — está pronto?

- [ ] Todos os passos do plano concluídos, ou os pendentes explicitamente reportados (R5)
- [ ] Testes do plano escritos e passando; build sem avisos
- [ ] Cobertura dentro do limiar declarado no projeto, sem regressão
- [ ] Registros de infraestrutura feitos (injeção de dependência, migration, mapeamento de erro), conforme a stack
- [ ] Isolamento entre escopos preservado e coberto por teste quando aplicável
- [ ] Veredito ✅ do QA com saída real de comando (R7)
- [ ] Documentos de qualidade e evidências atualizados pelo QA; documento de status pelo SM (R12)
- [ ] Aceite do PO registrado

## 4a. Aderência: `/arc comply` e a frente 2 do QA verificam objetos diferentes

`/arc comply` **não é etapa do ciclo** (o ciclo é 0→1→2→3→4→5; ver `commands/team.md`). É uma revisão de aderência **sob demanda**, em um de dois momentos: (a) o Arquiteto a roda antes de entregar ao QA quando a entrega é grande ou tocou muitos passos; (b) é a rota de volta dos achados de aderência de execução do veredito (⚠️/❌), antes do `/dev resume`. Não roda no `/team cycle` nem nos modos parciais.

| Verificação | Objeto | Pergunta |
|---|---|---|
| `/arc comply` | o **Plano de Execução vigente** | cada passo foi executado como escrito (assinatura, anel, arquivo, nomenclatura, registro de infra), e **a seção de standard que o passo citou está aplicada** no código? — o autor conferindo a execução da própria instrução |
| `/qa <ID>` frente 2 | o **normativo `${CLAUDE_PLUGIN_ROOT}/standards/`** e a **completude do plano ante o item** | (1) o plano **omitiu** uma seção de standard que o item exigia? (2) o plano **citou a seção errada** para o que o item faz? (3) — interseção — a seção citada está cumprida no código? |

O comply **não julga se o plano citou o conjunto certo ou completo de seções** — um autor não audita a própria omissão. Esse é o valor próprio da frente 2: pegar o defeito que o Arquiteto estruturalmente não vê. A interseção (seção citada × código) o QA **reverifica de forma independente**, como já faz a frente 3 apesar do checklist de segurança no plano — não confia no comply, que pode nem ter rodado.

**Como o SM verifica que o QA fez a checagem dele e não a do Arquiteto:** o veredito da frente 2 traz, para cada área de engenharia que o item toca, **a seção de standard que o item exigia × a seção citada no plano**, com um de quatro estados por linha:
- citada e aplicada — ok;
- citada e divergente do código — **reprovação** (R16);
- **exigida pelo item e ausente do plano** — achado de processo ao `/arc review`;
- citada errada para o que o item faz — achado de processo ao `/arc review`.

Veredito de frente 2 que só reproduz a tabela passo × conforme do comply, sem a coluna "seção exigida pelo item × seção citada", indica que o QA fez a checagem do Arquiteto, não a dele — o SM registra como achado de processo contra o veredito.

## 5. Cerimônias

| Cerimônia | Quando | Comando | Duração alvo |
|---|---|---|---|
| Onboarding do projeto | projeto novo ou retomado, antes do primeiro `/sm plan` | `/sm onboarding` | resposta única + registro (§5a) |
| Brainstorm de descoberta | ideia nova cuja área não tem documentação (visão / requisitos / fluxos) | `/team brainstorm <ideia>` | rodadas até ponto fixo (§5b) |
| Planejamento | início de cada ciclo | `/sm plan` | resposta única |
| Daily | início de cada sessão | `/sm status` | 6 linhas |
| Refinamento funcional | ideia nova em área já documentada | `/po analyze <ideia>` | resposta única |
| Refinamento técnico | antes de construir | `/arc plan <ID>` | 1 plano |
| Review | ao fim do item | `/qa <ID>` → `/po accept <ID>` | veredito + aceite |
| Retrospectiva | a cada 3 itens fechados | `/sm impact retro` | [template](../templates/retrospective.md) · mede o footprint do processo (§5c) |
| Auditoria cruzada | a cada 3 ciclos | `/qa audit` | achados, sem correção |
| Consulta ao time | decisão que atravessa papéis | `/team <pergunta>` | posições + convergências + divergências |
| Acordo | quando se quer uma posição única | `/team agreement <questão>` | recomendação do SM, com a divergência registrada |
| Melhoria de processo | quando o stakeholder instrui uma mudança de método | `/<papel> review <instrução>` | documento do papel atualizado + entrada no changelog do processo |
| Revisão de processo | a cada 3 retrospectivas, ou quando uma métrica estoura | `/sm review metrics` | **uma** proposta de mudança, com o indicador que a valida; é também o giro **Act** do ciclo de eficiência (§5c) |
| Curadoria do processo | quando dois papéis mudam algo que se contradiz | `/sm review` | consolidação do changelog e escalação do que ficou inconsistente |
| Auditoria de processo | a cada replicação, ou quando o time cresce | `/sm review audit` | achados de coerência interna de `${CLAUDE_PLUGIN_ROOT}/` |

## 5a. Ritual de onboarding do projeto (R14)

Acontece **uma vez**, quando o time recebe um projeto novo ou retoma um abandonado, antes do primeiro `/sm plan`. O SM coordena; os seis papéis participam. **A documentação existente do projeto é a primeira fonte — o stakeholder é consultado só sobre o que ela não responde.**

| # | Passo | Quem | O que produz |
|---|---|---|---|
| 1 | **Inventário das fontes** — listar o que existe: `.team-project/README.md`, o SDD, ADRs, os documentos de implementação, mapa de código, registro de GAPs | SM, sozinho | Tabela documento → existe? → última atualização → dono |
| 2 | **Lista de lacunas contra a documentação** — para cada coisa que o time precisa saber para planejar (objetivo do produto, fase, stack, ambiente, fontes da verdade, capacidade, restrições, riscos abertos), marcar: respondido pelo doc X / parcial / ausente | SM, sozinho | Lista de lacunas com origem |
| 3 | **Bifurcação** — (a) documentação funcional essencial **ausente** (sem visão geral, sem requisitos, sem fluxos) → abrir `brainstorm` (§5b) e **pausar** o onboarding até ele fechar; (b) documentação **desatualizada ou contraditória** (ex.: status diz "concluído", GAPs dizem o contrário) → registrar a divergência como risco no quadro e acionar `/qa audit`; o onboarding segue com a divergência declarada, não arredondada | SM | Decisão de rota registrada |
| 4 | **Leitura de entrada do time** — cada um dos outros cinco papéis lê `.team-project/README.md` + o seu `context.md` e reporta, em ≤10 linhas: o que entendeu como seu mandato neste projeto, o que precisa e não está documentado, um risco que enxerga do seu ângulo | PO · Arquiteto · UX · dev · QA | Cinco leituras de entrada |
| 5 | **Consolidação + perguntas ao stakeholder** — o SM funde as leituras num quadro único e produz **uma** lista de perguntas que só o stakeholder responde: estratégicas (provedor, alvo da retomada, ordem de prioridade) e lacunas funcionais pequenas que a documentação não cobriu e que não justificam um brainstorm. Cada pergunta traz: por que bloqueia · opções · recomendação do time (R9 — o time tentou responder antes) | SM | Lista de decisões pendentes do stakeholder |
| 6 | **Registro do alinhamento** — o SM escreve o entendimento comum no contexto do projeto (`.team-project/README.md` e os `context.md` recebem aporte de cada papel) e abre o quadro de trabalho | SM | Contexto do projeto preenchido e datado, quadro aberto |

**O que o SM pergunta primeiro à documentação:** propósito e fase do produto (`00-overview`), requisitos e seus critérios de aceite (`01-requirements`), atores e fluxos (`02-flows`), princípios de arquitetura e vinculação de stack (`03-architecture`), contratos de dados e API (`04`/`05`), o que está construído e com que evidência (`02-status`, `03-code-map`, `pending`), ambiente e comandos de verificação, capacidade declarada, limitações conhecidas, riscos e bloqueios abertos.

**O que o SM escala ao stakeholder** (só depois de esgotar a documentação e o time): decisões estratégicas (stack, provedor, custo, alvo da retomada, prioridade acima da ordem de dependência do SM) e lacunas funcionais pequenas não respondíveis pela documentação — sempre com opções + recomendação.

**Condição de saída — o onboarding está pronto quando:**
- [ ] Toda linha do inventário de fontes está preenchida (existe / desatualizada / ausente), e toda "ausência de doc funcional essencial" foi produzida via brainstorm ou aceita como risco pelo stakeholder.
- [ ] Os seis papéis registraram a leitura de entrada (mandato entendido + o que falta + um risco).
- [ ] A lista de perguntas só-do-stakeholder foi respondida ou explicitamente adiada com o risco aceito.
- [ ] `.team-project/README.md` reflete o entendimento alinhado (objetivo, fase, stack, ambiente, fontes da verdade, capacidade, restrições) e toda divergência status × código está no quadro como risco.
- [ ] O quadro existe, com ao menos a primeira onda de itens, ou uma nota de que o planejamento está bloqueado aguardando brainstorm/decisão do stakeholder.

**Como o SM verifica que aconteceu:** a resposta do onboarding traz a tabela de inventário preenchida e as seis leituras de entrada; `.team-project/README.md` está datado em/após o onboarding com §4 e §7 populadas; nenhum `/sm plan` do projeto precede o registro de onboarding; toda divergência narrativa × código é linha na tabela de riscos do quadro.

## 5b. Ritual de brainstorm de descoberta (R15)

Acionado quando o stakeholder traz uma ideia — um desejo dele — para a qual **não há cobertura** em visão geral / requisitos / fluxos: produto greenfield ou área de capacidade genuinamente nova. Ideia em área já documentada vai por `/po analyze`, não por aqui. O SM **facilita** (abre a sessão, mantém as fases, registra convergência/divergência, declara o fechamento) e **não decide conteúdo funcional**.

### Fase 1 — Formação funcional · participantes: stakeholder + PO + UX

Objetivo: um **entendimento funcional base** — o problema do usuário, quem são os usuários, a jornada central, o valor, a fronteira grosseira de escopo (o que está dentro / explicitamente fora), as regras principais, os casos de borda óbvios.

- O PO conduz o enquadramento funcional (problema, regra, escopo); o UX contribui a jornada, o contexto de uso e as implicações de usabilidade/acessibilidade; o stakeholder fornece intenção e restrições e responde perguntas diretamente — aqui o diálogo direto com o stakeholder é o **mecanismo de co-criação**, não uma falha de escalação (R9).
- Arquiteto, dev e QA **não** entram na fase 1 — de propósito, para a forma funcional se estabelecer sem restrição técnica prematura.
- Saída da fase 1: um **brief funcional** — ainda não um requisito formal. É o insumo que o PO transforma em `01-requirements` / `00-overview` / `02-flows` e o UX em jornadas.
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
No fechamento, o SM registra o brief e distribui a elaboração — **sem escrever os sete documentos de uma vez**, só o que a primeira fatia exige:

| Documento | Dono | Comando |
|---|---|---|
| `00-overview-objectives`, `01-requirements` (com critério de aceite + como verificar), `02-flows-and-roles`, início do `06-changelog`, índice do SDD | **PO** | `/po requirement <ID>` por requisito · `/po analyze` se uma sub-ideia ainda precisa de decisão formal |
| Mapas de jornada das jornadas moldadas | **UX** | `/ux journey <fluxo>` · `/ux screen <ID>` quando os itens forem planejados |
| `03-architecture` (incl. Ficha de Vinculação de Stack §2b), `04-data-model`, `05-api-model` — só as partes da primeira fatia | **Arquiteto** | `/arc plan <ID>` cita essas seções |
| Itens no quadro a partir dos requisitos | **SM** | `/sm plan` |

O brief de brainstorm **não** é entregável permanente: é absorvido por `00-overview` / `01-requirements` e pelo registro de processo, e não vira arquivo novo sem lugar declarado em `.team-project/`.

**Como o SM verifica:** a saída do brainstorm mostra as duas fases com os participantes declarados — fase 1 sem o Arquiteto, fase 2 com ele; cada rodada de fase 2 tem delta registrado ou "sem mudança — ponto fixo"; no fechamento, `00-overview` + `01-requirements` + `02-flows` são criados/atualizados pelo PO no mesmo ciclo (R12) e o índice do SDD mostra a versão nova; nenhum documento do SDD foi escrito antes do fechamento; o brief não virou arquivo sem lugar declarado.

## 5c. Ciclo de eficiência dos documentos do processo (PDCA)

O custo dos documentos de `${CLAUDE_PLUGIN_ROOT}/` não pode depender de uma faxina eventual do stakeholder. Cada papel verifica periodicamente o peso dos **próprios** documentos e propõe corte. O ciclo usa gatilhos que **já existem** — nenhuma cerimônia nova.

| Fase | Onde já acontece | O que a eficiência acrescenta |
|---|---|---|
| **Plan** | `/sm review metrics` (a cada 3 retrospectivas, ou métrica estourada) | Reafirma o teto de footprint por papel e o alvo do período: ao menos **uma** remoção candidata nomeada |
| **Do** | operação normal + cada `/<papel> review` | Papéis editam seus documentos; toda entrada de changelog respeita R17 |
| **Check** | `/<papel> review` sem instrução (reavaliação do conjunto, linha "Excesso") + retrospectiva | Passa a ser quantitativo: o papel mede seu footprint e compara com o valor anterior registrado; a retrospectiva registra total e Δ |
| **Act** | `/sm review metrics` + `/<papel> review <instrução>` | O SM consolida os footprints numa tabela por papel, escolhe **uma** mudança, roteia o corte ao dono; entrada no changelog com o indicador (KB antes/depois) |

**Métrica por papel:** KB da carga fixa por invocação (`agents/<papel>.md` + `commands/<papel>.md`) **+** KB do conjunto do papel (`roles/<papel>/` — README, skills, templates; para o SM, também `process/`).

**Gatilhos:**
- *Medição* — em todo `/<papel> review` sem instrução (o papel já faz a reavaliação do conjunto ali; passa a anexar os dois números) e na retrospectiva (o SM mede o total do processo).
- *Giro completo* — casado com `/sm review metrics`: a cada 3 retrospectivas, ou antecipado por limiar.
- *Limiar que dispara Act fora de cadência* — footprint de um papel cresce > 20% entre dois giros sem regra ou cerimônia nova que o justifique; **ou** qualquer entrada de changelog passa de 10 KB (R17); **ou** o footprint total de `${CLAUDE_PLUGIN_ROOT}/` cresce dois giros seguidos sem nenhuma remoção registrada.

**Onde fica registrado, para ser comparável no tempo:** a tabela de footprint por papel vai na saída de `/sm review metrics`; quando o giro gera entrada no changelog — o caso normal, um corte por giro —, os números ficam ali, no campo "Como saberemos que funcionou" do modelo [`process-change.md`](../templates/process-change.md). Entre giros, a retrospectiva carrega a linha "carga fixa do processo (KB): atual / retro anterior / Δ" como série contínua.

**O que a fase Check candidata à remoção:** modelo que ninguém referencia, seção que repete outra, regra sem citação em 3 ciclos, entrada de changelog acima do teto. Processo que só cresce deixa de ser seguido — revisar é também remover.

## 6. Escalação

```
dúvida de implementação  ──▶ Arquiteto        (dev nunca decide sozinho)
dúvida de regra/fluxo    ──▶ PO
dúvida de tela/jornada   ──▶ UX
dúvida de prioridade     ──▶ SM
lacuna de especificação  ──▶ PO ──▶ stakeholder (3 opções + recomendação)
decisão estratégica      ──▶ stakeholder       (stack, provedor, custo, risco aceito)
exceção a um padrão      ──▶ stakeholder ──▶ ADR escrita pelo Arquiteto
defeito em ${CLAUDE_PLUGIN_ROOT}/standards/ ──▶ Arquiteto (dev: 🔺 GAP · QA: achado de processo) ──▶ /arc review   (R16)
```

Nenhum agente devolve pergunta ao stakeholder sem antes tentar resolvê-la no papel correto (R9). **Exceção declarada:** no `brainstorm` (§5b) e no passo 5 do `onboarding` (§5a) o stakeholder é participante — o diálogo direto ali é co-criação, não escalação; o que sobe a ele mesmo assim vem com opções e recomendação.

**Quando a dúvida atravessa papéis**, use `/team` em vez de perguntar a cada um: os cinco respondem em paralelo e a resposta já vem com convergências e divergências separadas. Com `/team agreement`, o SM consolida numa recomendação única. **Consultar o time não transfere a decisão**: o dono do assunto continua decidindo no seu domínio, e o que sobra de divergência sobe ao stakeholder.

## 7. Sequenciamento

1. **Um item em construção por dev** (R1). Com um único dev, o quadro é fila, não board paralelo.
2. **O paralelismo é entre papéis** — dev no item *n*, Arquiteto no *n+1*, PO no *n+2*.
3. **Item cabe em uma unidade de trabalho** (R2); acima disso, quebra em `<ID>a`/`<ID>b`.
4. **Passos ordenados para manter o repositório íntegro** no maior número de pontos intermediários (R5).
5. **Uma migration de banco por item**; itens que compartilham migration viram um item só.
6. **Interrupção é estado** — o relatório diz onde parou; a retomada continua dali.

> Se o time tiver **mais de um dev**, reative a regra de faixas: no máximo uma faixa por dev, com conjuntos de arquivos **disjuntos**; havendo interseção, serialize e registre o motivo; migration nunca em paralelo; arquivo de configuração compartilhado pertence a uma faixa por ciclo.

## 8. Gates de qualidade (não negociáveis)

| Gate | Bloqueia | Responsável | Regra |
|---|---|---|---|
| Onboarding concluído | primeiro `/sm plan` do projeto | SM | R14 |
| Ideia sem documentação passou por `brainstorm` | primeiro documento do SDD daquela área | SM | R15 |
| Especificação de tela existe *(item com interface)* | planejamento | UX | R8 |
| Plano de Execução existe | construção | Arquiteto | R8 |
| Plano cita a seção de `${CLAUDE_PLUGIN_ROOT}/standards/` que a mudança de engenharia toca | construção | Arquiteto | R16 |
| Seção de standard **exigida pelo item** presente no plano e aplicada no código | veredito | QA | R16 · §4a |
| Build sem avisos + testes passando | veredito | QA | R7 |
| Segurança: identidade, permissão, auditoria, segredo | veredito | QA | R11 |
| Documentação atualizada | aceite | QA | R12 |
| Aceite funcional | fechamento | PO | — |
| Evidência registrada | fechamento | QA/SM | R7 |

## 9. Ambiente de verificação

Os comandos, os limiares e as limitações conhecidas do ambiente são específicos de cada projeto e vivem em `.team-project/quality-assurance/context.md` (verificação) e `.team-project/developer/context.md` (execução).

**Regra que não muda:** limitação de ambiente que impeça uma verificação é **declarada** no veredito como "não exercitado", nunca omitida.
