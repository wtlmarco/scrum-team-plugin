# Propriedade de Artefatos — Quem escreve o quê

> **Dono:** SM · Cada arquivo tem **um único dono**. Quem não é dono lê, cita e pede alteração — nunca edita. É o que impede dois papéis de escreverem a mesma verdade em direções diferentes.

## 1. Matriz

Os caminhos concretos dos documentos do projeto estão em `.team-project/README.md` §4.

| Artefato | Dono | Regra |
|---|---|---|
| Código-fonte | dev | Só os arquivos listados no Plano de Implementação vigente |
| **Histórias** (`.team-project/product-owner/`) | **PO** | Unidade de valor. Conteúdo **só funcional** — regra, protótipo, critério de aceite; decisão técnica ali é achado de processo (R20). Modelo em [`../../product-owner/templates/user-story.md`](../../product-owner/templates/user-story.md) |
| **Tasks** (linhas do Sprint Backlog) | **SM** (a linha) · **Arquiteto** (o plano dentro dela) | Unidade de trabalho. Toda Task pertence a exatamente uma História (R20); a Task carrega estimativa, dependências, evidência esperada e o Plano de Implementação |
| Planos de Implementação (`.team-project/architect/plans/`) | Arquiteto | Um plano por Task, nome `<Task-ID>-<slug>.md`. É o conteúdo técnico da Task, não um artefato irmão dela |
| Arquitetura, modelo de dados, modelo de API (SDD) | Arquiteto | Grafia de entidades e endpoints é contrato — modelos em [`../../../deliverables/sdd/README.md`](../../../deliverables/sdd/README.md) |
| ADRs | Arquiteto | Decisão estrutural recorrente |
| `${CLAUDE_PLUGIN_ROOT}/standards/**` | **Arquiteto (dono editorial)** · dev e QA consumidores obrigatórios | Base de qualidade comum dos três (R16). Única caneta é do Arquiteto — muda só por `/review`. Agnóstico de produto — nunca ajustar para acomodar caso específico. Dev roteia defeito por 🔺 GAP, QA por achado de processo; os dois ao Arquiteto. Divergência de engenharia entre os três decide o Arquiteto; o que ultrapassa engenharia sobe ao stakeholder pelo SM |
| Mapas de jornada (`.team-project/user-experience/journeys/`) | UX | Um por objetivo do usuário |
| Especificações de tela (`.team-project/user-experience/screens/`) | UX | Os seis estados e os critérios de acessibilidade são obrigatórios |
| **Protótipo funcional** (`.team-project/user-experience/prototype/`) | **UX** | **Entregável** e **pré-condição do portão ①**: HTML navegável cobrindo os fluxos principais de `02-flows-and-roles`. O stakeholder **navega** antes de aprovar o SDD funcional — aprovação por leitura não vale (R15). Modelo em [`../../user-experience/templates/functional-prototype.md`](../../user-experience/templates/functional-prototype.md); critérios em [`../../../deliverables/prototype/README.md`](../../../deliverables/prototype/README.md) |
| Protótipos de tela e explorações | UX | Exploração da tela de uma História, no detalhamento (portão ③). Não é código de produção, e **não substitui** o protótipo funcional do ① |
| Objetivos, requisitos, fluxos, changelog funcional (SDD) | PO | Modelos e critérios em [`../../../deliverables/README.md`](../../../deliverables/README.md) |
| Escopo e critérios de sucesso | PO | Marcação exige evidência do QA — modelo em [`../../../deliverables/implementation/01-scope-and-criteria.md`](../../../deliverables/implementation/01-scope-and-criteria.md) |
| Product Backlog (`.team-project/product-owner/`) | PO | **O conjunto das Histórias.** Priorizado por valor e risco funcional; recebe também os gaps, débitos e ressalvas levantados na Sprint Review |
| **Plano de entrega** — que Histórias saem em que sprint | **PO** | Ele recebe do time as estimativas e do SM a capacidade, e **decide o que entra e quando sai**. Seção do Product Backlog, não documento novo |
| **Status executivo ao stakeholder** | **PO** | "Onde estamos, o que está bloqueado, o que vem" — em nível de **História**, não de Task. Lê o Sprint Backlog do SM e o registro de evidências do QA; não os edita. Saída de `/po status` |
| **Análise de impacto** | **PO** | O objeto é o **plano de entrega**. Consolida três insumos com dono declarado: quadro e capacidade do **SM**, retrabalho e contrato do **Arquiteto**, risco e recomendação seus. **Não é arbitragem** — não há disputa, é análise de mudança a um plano que é dele. Saída de `/po impact` |
| Documento de status/progresso | SM | Memória de progresso e decisões — modelo em [`../../../deliverables/implementation/02-status.md`](../../../deliverables/implementation/02-status.md). **Homônimo** do "status executivo ao stakeholder" duas linhas acima, que é do PO: a forma de escrever essa fronteira sem derrubar o modo de ninguém está em **§1b** |
| Sprint Backlog / quadro de trabalho (`.team-project/scrum-master/`) | SM | As Tasks do sprint corrente, com objetivo do sprint, estimativa e capacidade. Fechado na Planning Meeting; **não cresce durante o sprint** (R4 · [`workflow.md` §5e](workflow.md)). O SM responde por **quanto cabe, em que ordem e o que está bloqueado** — não por prazo nem por prioridade de valor, que são do PO (§6a) |
| Registro de sprint — objetivo, Review e retrospectiva | SM | Um por sprint. O aceite registrado ali é do PO (R21); o SM registra, não aceita |
| Registro de onboarding · brief de `brainstorm` | SM (**facilitação**) | Saída de `/sm onboarding` e `/team brainstorm` — registro do entendimento alinhado e do brief funcional. **Não substitui** a propriedade do PO sobre o requisito nem a divisão de autoria do SDD (PO: visão/requisitos/fluxos; Arquiteto: arquitetura/dados/API). Não vira arquivo permanente sem lugar declarado em `.team-project/` |
| `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/**` | SM | Processo — muda só a pedido do stakeholder, via `/review` (Agent `scrum-master`) |
| `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/process-changelog.md` | SM (**curador**) | **Exceção à regra de dono único:** todo papel acrescenta a entrada da sua própria mudança de processo; o SM cura — consolida, aponta contradição e escala o que ficou inconsistente. Entrada nunca é reescrita |
| `${CLAUDE_PLUGIN_ROOT}/roles/<papel>/README.md`, `skills.md`, `templates/` | o próprio papel | Roteiro e modelos do papel — evoluem por `/review`, que roteia ao agente do papel dono, com registro no changelog do processo |
| `${CLAUDE_PLUGIN_ROOT}/roles/developer/**` | **Arquiteto** | **Exceção:** o dev não revisa os próprios normativos — roda no modelo mais simples do time, calibrado para executar plano, não para reescrever a regra que o governa. O Arquiteto revisa por `/review`, usando os 🔺 GAPs e as seções "Não fiz" dos relatórios como evidência |
| Contexto do projeto (`.team-project/**/context.md`) | SM, com aporte de cada papel | O papel dono do assunto propõe; o SM mantém a coerência |
| Mapa/inventário de código | QA | Uma linha por arquivo — modelo em [`../../../deliverables/implementation/03-code-map.md`](../../../deliverables/implementation/03-code-map.md) |
| Registro de GAPs abertos | QA | Levantado sobre código; vence a narrativa de status — modelo em [`../../../deliverables/implementation/pending.md`](../../../deliverables/implementation/pending.md) |
| Registro de evidências (`.team-project/quality-assurance/`) | QA | Comando, saída, veredito |
| `${CLAUDE_PLUGIN_ROOT}/agents/*`, `commands/*`, `.claude-plugin/*` | stakeholder | Composição e comportamento do time |
| **Guias e rituais de raiz** — `README.md`, `how-to.md`, `replicate-in-new-project.md`, `review-contract.md`, `team-init.md`, `team-update.md`, `team-version.md` | stakeholder | Face de instalação e operação do plugin — irmãos de `agents/`+`commands/` na propriedade. O `/review` **propõe com o texto pronto**, não aplica. O **SM mantém a coerência de referência cruzada** (contagens, ponteiros, nomes de modo, índice de estrutura) e reporta a deriva como achado — manter o ponteiro certo não é reescrever o guia |
| `CHANGELOG.md` (raiz) — changelog de entregas | stakeholder | Registro das entregas versionadas do plugin (`vMAJOR.MINOR.PATCH`). O SM **reconcilia** no `/review`: toda entrada de `process-changelog.md` tem par aqui na mesma linha `vX.Y`; `version` de `.claude-plugin/plugin.json` == topo do `CHANGELOG.md` (R18 · [`workflow.md` §5d](workflow.md)) |
| Processo de lançamento — branch, PR, bump de `version`, `/team update` | stakeholder | Fecha a versão e corta a entrega. Roteiro em [`workflow.md` §5d](workflow.md); regra em R18. O SM verifica a rastreabilidade da entrega, não corta a release |

### 1a. `${CLAUDE_PLUGIN_ROOT}/standards/` — dono editorial único, consumo compartilhado (R16)

"Base compartilhada entre Arquiteto, dev e QA" **não afrouxa o invariante de dono único** — o dono *editorial* continua sendo um só, o Arquiteto, e a caneta muda só por `/review`. O que é compartilhado é a **obrigação de consumo** e o **direito de levantar defeito**:

| Papel | Sobre `${CLAUDE_PLUGIN_ROOT}/standards/` | Como propõe mudança |
|---|---|---|
| **Arquiteto** | Dono editorial. Escreve, versiona, mantém a coerência entre nível 1 e perfis de nível 2 | `/review` |
| **dev** | Consumidor obrigatório: aplica a regra ao executar o plano | 🔺 GAP apontando contradição / lacuna / regra inverificável → Arquiteto decide → `/review` roteia a correção do texto ao Arquiteto (o dev não edita os próprios normativos — v1.3) |
| **QA** | Consumidor obrigatório: valida a entrega contra os standards | Achado de processo (não achado de código) → `/review` roteia ao Arquiteto |

**Desempate:** quando os três discordam sobre uma regra de engenharia, decide o **Arquiteto** — é o dono do desenho técnico. A divergência que ultrapassa engenharia (custo, prazo, escopo, política) sobe ao **stakeholder pelo SM**, com as posições lado a lado (consolidação de acordo). Defeito num standard **não se corrige de passagem** — vale a mesma regra do QA que acha defeito fora da Task (abrir registro, não corrigir).

### 1b. Substantivo homônimo — como se escreve uma proibição sem derrubar um modo

Alguns substantivos nomeiam **dois artefatos de donos diferentes**. O caso canônico está nesta própria matriz: **status executivo ao stakeholder** (PO, saída de `/po status`) e **documento de status/progresso** (SM) são linhas distintas, com donos distintos, e chamam-se as duas "status". Os outros homônimos vivos do time:

| Substantivo | Artefato A | Artefato B |
|---|---|---|
| **status** | status executivo ao stakeholder — **PO**, `/po status` | documento de status/progresso — **SM** |
| **especificação** | especificação funcional — **PO** · especificação técnica — **Arquiteto** | "Especificação técnica" é também o nome da **frente 2 do QA**, que valida contra ela sem escrevê-la |
| **protótipo** | protótipo funcional do ① — **UX** | protótipo de tela do ③ — **UX**, escopo e portão diferentes |
| **documentação** | entregáveis do projeto — PO, Arquiteto, QA | relatório de entrega e 🔺 GAP — **saídas obrigatórias do dev** |

**A regra.** Nas listas de **"Não faz"** e **"Proibido"** — as linhas mais curtas e mais obedecidas de cada ficha (`roles/<papel>/README.md`) e de cada card (`agents/<papel>.md`) —, o substantivo homônimo **nunca entra cru**. Toda menção qualifica **qual dos dois** e **nomeia o dono**:

| Forma | Exemplo | Efeito |
|---|---|---|
| ❌ **cru** | `Não faz: …, status, …` | O papel conclui que **nenhum** status é dele e recusa o próprio modo |
| ✅ **qualificado + dono** | `Não responde por … nem status **ao stakeholder** — é do PO (§6a)` — [`../README.md`](../README.md), linha "Não faz" | Nega um artefato e preserva o outro |

A forma certa já existe e é a do **SM**: ele é dono do documento de status e mesmo assim declara o que **não** é dele sem ambiguidade, porque qualifica o destinatário (*ao stakeholder*) e nomeia o dono (*é do PO*). É esta a forma a copiar.

**O verbo é a outra metade.** Quando o papel tem relação **legítima** com o artefato do outro — lê, cita, valida contra —, a proibição também declara **qual verbo** está proibido, senão ela apaga a relação junto com a propriedade. O caso é o QA: *"a especificação"* não diz se o vedado é escrevê-la ou também validar contra ela, e validar contra ela é a **frente 2** do papel. A forma completa é `**escrever ou editar** a especificação técnica (é do Arquiteto) — **validar contra** ela é a sua frente 2`.

**Por que a lista de proibição, e não qualquer menção.** Ela é lida como a fronteira do papel e, na prática, **vence a linha que concede** o modo: é mais curta, está mais perto do fim do documento e costuma ser a última coisa que o agente lê antes de agir. Quando o prior do domínio empurra na mesma direção — *"status é do Scrum Master"* —, a palavra crua não precisa convencer ninguém: basta não contradizer. Uma linha de tabela concedendo o modo, quatro linhas acima, não segura.

**Como o SM verifica** — critério de aceitação, citável nas entradas de changelog dos papéis:

1. Para cada papel, cruzar a linha **"Não faz"** de `roles/<papel>/README.md` e a linha **"Proibido"** de `agents/<papel>.md` contra os **modos** e as **responsabilidades declaradas** do mesmo papel (a linha "Responde por", a lista de responsabilidades do card, os títulos de seção do roteiro).
2. **Todo substantivo que aparecer dos dois lados é achado.** Ou ganha qualificador **e** dono na proibição — mais o **verbo**, se o papel tem relação legítima com o artefato —, ou sai dela.
3. A verificação é **de leitura, não de `grep`** — a palavra ocorre nas duas formas, e o `grep` não distingue o uso qualificado do cru. Contar ocorrências aqui não prova nada (R19).

**Origem:** v3.4, a partir de um `/po status` em campo que entregou a leitura de produto e **em seguida se desautorizou**, oferecendo ao stakeholder um `/sm status` extinto na v3.3.

## 2. Fluxo de um artefato entre papéis

```
[projeto novo/retomado] ─▶ SM conduz onboarding (§5a) ─▶ contexto do projeto alinhado
[ideia sem documentação] ─▶ SM facilita brainstorm (§5b): PO+UX, depois +Arquiteto ─▶ brief funcional
           │
ideia ─────▶ PO escreve o SDD funcional · UX faz o protótipo em HTML
              └─▶ ① stakeholder NAVEGA o protótipo e aprova
              └─▶ Arquiteto escreve o SDD técnico ──② aprovado
                    └─▶ PO escreve a História e a prioriza no Product Backlog
                          └─▶ PO detalha (UX faz o protótipo) ──③ stakeholder aprova
                                └─▶ Planning: o time quebra em Tasks e estima
                                      └─▶ SM fecha o Sprint Backlog
                                            └─▶ Arquiteto escreve o Plano de Implementação
                                                  └─▶ dev escreve código+testes
                                                        └─▶ QA registra evidência
                                        ┌───────────────────────┘
                                        ├─▶ QA atualiza inventário de código e registro de GAPs
                                        ├─▶ SM atualiza o status e fecha a Task
                                        └─▶ Sprint Review: ④ PO aceita a História
                                              └─▶ SM conduz a retrospectiva e fecha o sprint
```

Os quatro portões numerados são os gates de [`workflow.md` §8](workflow.md). Repare que o **fechamento da Task é do SM e é técnico**; o **aceite é do PO, por História, na Review** (R21). Os dois nunca são o mesmo ato, e nunca são do mesmo papel.

## 3. Conflitos comuns e como resolver

| Situação | Errado | Certo |
|---|---|---|
| Dev percebe requisito ambíguo | Decidir e seguir | 🔺 GAP → Arquiteto → (se funcional) PO |
| Dev não sabe o que mostrar no estado vazio ou de erro | Inventar a tela | 🔺 GAP → UX; a especificação é corrigida |
| UX precisa de um dado que a API não expõe | Supor o contrato | Levantar ao Arquiteto antes de fechar a especificação |
| UX quer mudar uma regra para simplificar a tela | Mudar no desenho | Escalação ao PO — regra é dele |
| Arquiteto quer renomear entidade da especificação | Renomear no plano | Mudança formal: PO aprova, Arquiteto atualiza o modelo, migration explícita |
| QA encontra defeito fora da Task | Corrigir de passagem | Abrir GAP; SM entra na fila |
| Stakeholder quer saber prazo ou andamento | Perguntar ao SM | É do **PO**: ele detém o plano de entrega e o status (§6a). O SM responde quanto cabe, não quando sai |
| Achado do QA atravessa papéis | Reunir os seis, ou empurrar ao PO por ser o canal | O QA roteia pelo **objeto da dúvida** (§6b); só quando não consegue classificar é que o SM facilita por `/sm agreement` |
| PO quer refazer a conta de capacidade para caber mais | Renegociar a média entregue | A capacidade é **observada**. O PO decide o que **sai**, não quanto cabe |
| SM quer tirar uma História do sprint por achá-la de baixo valor | Cortar do Sprint Backlog | Valor é do PO. O SM aponta risco e capacidade; quem corta por valor é o PO |
| PO detalha a História citando arquivo, classe ou endpoint | Deixar passar — "é só contexto" | Devolver ao PO: o detalhamento é só funcional; o técnico nasce no Plano de Implementação (R20) |
| Surge trabalho técnico que nenhuma História cobre | Criar Task solta no sprint | PO escreve a História que declara o valor, ainda que o beneficiário seja o time (R20) |
| Task pronta dentro de uma História rejeitada na Review | Fechar a Task e seguir | Toda a História volta ao Product Backlog, com as Tasks boas junto (R21) |
| Stakeholder pede escopo novo no meio do sprint | Encaixar no Sprint Backlog | Vai ao Product Backlog e concorre na Planning seguinte; exceção só para GAP que bloqueia História já no sprint, com "o que saiu para caber" registrado |
| Frente 2 do QA parece repetir o `/arc comply` | Reexecutar a tabela passo × conforme do comply | Checar o que o comply não vê: plano omitiu ou errou a seção que a Task exigia — [`workflow.md` §4a](workflow.md) |
| SM vê status divergente do código | Ajustar o status pela intuição | Acionar `/qa audit`; corrigir com o achado |
| Um papel recusa o **próprio modo** citando a lista de "Não faz" | Aceitar a recusa — "está escrito lá" | O substantivo está cru (§1b). A linha que **concede** o modo vence; a proibição é corrigida no mesmo ciclo, com qualificador e dono |
| Mudança de `/review` aplicada mas não lançada | Assumir que as instalações já a têm | Entra numa entrega: branch, bump de `version`, entrada no `CHANGELOG.md` (R18 · [`workflow.md` §5d](workflow.md)) |
| PO quer marcar critério de sucesso como atendido | Marcar direto | Exige evidência no registro do QA |

## 4. Convenções

- **Idioma:** documentação e comunicação no idioma do time; código, identificadores e mensagens de commit seguem o padrão já existente no repositório.
- **IDs:** padrão definido no contexto do projeto; nunca reaproveitados. Convenção padrão: `H-nnn` para História, `T-nnn` para Task, sufixo para quebra (`T-012a`, `T-012b`); Task nascida de um GAP reusa o ID do GAP.
- **Commits:** uma Task por commit sempre que possível, referenciando o ID da Task.
- **Resolver GAP:** o QA remove a entrada do registro de GAPs e o SM registra a correção no documento de status — nunca os dois no mesmo arquivo.
- **Documento vivo** traz no topo a marcação **DOCUMENTO VIVO**, o dono e a data da última atualização.
- **Nomes de arquivo em `${CLAUDE_PLUGIN_ROOT}/` e `.team-project/`:** inglês, kebab-case, sem acento. Conteúdo no idioma do time. Documento vivo e modelo compartilham o nome — o modelo fica em `templates/`.
