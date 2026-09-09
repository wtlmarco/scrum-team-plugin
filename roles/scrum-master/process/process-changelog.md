# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v3.3 — O canal do stakeholder é o PO; o broadcast acaba; prazo, plano e status mudam de dono — 08/09/2026

**Instrução:** *(stakeholder, direta)* "podemos remover o comando `/team <mensagem>` pois eu como stakeholder devo me relacionar com o PO prioritariamente pois ele controla as minhas demandas, mas posso levar questões ao Arquiteto ou UX diretamente. O SM como mantenedor do processo tem como responsabilidade o PDCA do processo… Um acerto é o prazo, ele também é definido pelo PO e não o SM, o PO recebe as estimativas das tarefas do time mas como o representante do Produto ele detém o plano de entrega. O SM é processo, organização e eficiência. No caso do `/team agreement` podemos direcionar o comando ao PO que deverá orquestrar os envolvidos." Mais três decisões por questionário: **árbitro pelo tipo do achado** para o degrau 2 do QA · **SM mantém os rituais**, e prazo/status/planejamento vão ao PO · o acordo vira **`/sm agreement`**, não broadcast.

**Classificação:** escopo de papel (governança: quem fala com quem, e quem detém prazo, plano e status) + comportamento de agente (dois modos removidos, dois criados) + fluxo (§6 escalação, §6a e §6b novas, §5e Planning) + propriedade de artefato (plano de entrega e status executivo ganham dono) + formato de documento (modelo de status muda de papel e de unidade).

**Uma proposta foi aceita com correção.** O stakeholder propôs que o **PO orquestrasse o acordo**. Isso foi apontado como conflito e a proposta virou **`/sm agreement`**: o achado que atravessa papéis é, com frequência, *"o requisito está errado ou a implementação está?"* — e nessa pergunta **o PO é parte**. Fazê-lo conduzir o julgamento do próprio artefato contraria o princípio que já sustenta a frente 2 do QA (§4a: *um autor não audita a própria omissão*) e a regra de que o dev não revisa os próprios normativos. **Quem facilita é o SM, porque não é dono de requisito, desenho nem evidência.** O stakeholder acatou.

### O que mudou

| Documento | Onde | O quê |
|---|---|---|
| `commands/team.md` | modos | **`consult` removido** — não há mais broadcast. Sem termo reconhecido, `/team` **roteia sem disparar agente**: demanda ao PO, técnica ao Arquiteto, tela ao UX, questão que atravessa a `/sm agreement`, ideia sem cobertura a `brainstorm`. **`agreement` removido** daqui |
| `commands/sm.md` · `agents/scrum-master.md` · `roles/scrum-master/README.md` | modos, mandato | **`agreement` criado** — facilitação, não broadcast: o SM identifica **quais papéis a questão toca** (2–3, nunca os seis), consolida uma recomendação e registra a divergência. **`status` removido** |
| `commands/po.md` · `agents/product-owner.md` · `roles/product-owner/README.md` | modos, mandato | **`status` criado.** O PO passa a ser declarado **o canal do stakeholder** e dono de **prazo, plano de entrega e status** |
| `templates/status.md` | `roles/scrum-master/` → **`roles/product-owner/`** | Muda de dono **e de unidade**: fala em **Histórias**, não em Tasks. "Entregue" é História **aceita na Review** (R21) — não Task fechada nem soma delas. Lê o Sprint Backlog do SM, não o edita |
| `templates/product-backlog.md` | **seção nova** | **Plano de entrega** — que Histórias saem em que sprint, com soma estimada, capacidade do SM e compromisso externo. Seção do backlog, **não documento novo**, para não haver duas verdades sobre prazo |
| `process/workflow.md` | **§6a nova** | *O canal do stakeholder é o PO.* Declara o que mudou de dono e por quê: **quem ordena o backlog por valor e é dono das Histórias é quem pode dizer quando o valor chega**. Ao SM fica a pergunta vizinha — **quanto cabe** |
| | **§6b nova** | *Achado que atravessa papéis — o QA roteia pelo objeto.* Tabela de objeto → dono, a regra de que **quem recebe e não é dono devolve**, e o porquê de não haver orquestrador |
| | §6 escalação | "dúvida de prioridade → SM" **vira** "prioridade, prazo, plano → PO" e "capacidade, fila, bloqueio → SM" |
| | §5e Planning | **O SM facilita, o PO decide o conteúdo**: passa a 7 passos — o PO seleciona (2) e o PO corta no limite (6); o SM confere a DoR e **apresenta a conta** da capacidade (5). *"O SM não veta escopo por valor e o PO não altera a conta de capacidade"* |
| | §5, §5c | Daily passa a `/po status`; "Consulta ao time" e "Acordo" viram uma linha só, `/sm agreement`; a tabela de custo por comando perde os dois broadcasts |
| `process/artifact-ownership.md` | matriz, §3 | **Plano de entrega** e **status executivo** entram com dono PO; o Sprint Backlog ganha a fronteira explícita (*quanto cabe, não quando sai*); **4 conflitos novos**, entre eles "stakeholder quer saber prazo → é do PO" e "SM quer tirar História por baixo valor → valor é do PO" |
| `roles/quality-assurance/README.md` | escada de falha | Degrau 2 **vira dois**: `2 · Outro dono` (o QA classifica pelo objeto e entrega) e `2b · Não consigo classificar` (raro — vai a `/sm agreement`) |
| raiz e `.team-project/` | `README.md`, `how-to.md`, `project-context.md`, `replicate-in-new-project.md` | Superfície de comandos, seção "com quem o stakeholder fala", escada de falha e o bloco fixo §8 |

**Modo de falha que evita:** duas cabeças respondendo *quando o valor chega*. O SM detinha "prazos" enquanto o PO ordenava o backlog por valor e era dono das Histórias — e o stakeholder tinha seis interlocutores para uma pergunta que tem um dono. Também mata a via mais cara do time: o broadcast que reunia seis papéis para uma pergunta que quase sempre tinha um só.

**Quem passa a ser cobrado de forma diferente:** o **PO** (ganha prazo, plano de entrega e status, e passa a ser o canal); o **SM** (perde prazo e status, ganha a facilitação de acordo e a ênfase em rituais); o **QA** (roteia pelo objeto em vez de convocar o time); o **stakeholder** (fala com o PO, e com Arquiteto/UX quando quiser).

**Indicador de sucesso:** nenhum pedido de prazo ou status respondido pelo SM; nenhum acordo facilitado que tenha chamado papel que a questão não tocava; nenhuma História no Sprint Backlog escolhida por outro que não o PO.

### Evidência (R19)

| Classe | Comando | Resultado |
|---|---|---|
| Arquivamento | `Compare-Object` do bloco `## v3.0` movido × `git show HEAD` | **67 × 67 linhas, diff = 0.** Índice de arquivadas ganhou a linha `v3.0` |
| Renomeação | `git mv roles/scrum-master/templates/status.md → roles/product-owner/templates/status.md` | rename detectado pelo git; conteúdo reescrito para a unidade História |
| Substituição de padrão | `/team <mensagem>` · `/team <questão>` · `/team agreement` · `/sm status` · `prazo é do SM` | **0 ocorrências** de cada, fora dos changelogs |
| **Checagem semântica** | leitura de cada tabela de comando e de cada escada de falha | a tabela do `/team` em `how-to.md` usava `<ID>` e **não casou** com a substituição automática — pego na leitura, corrigido à mão. Idem a linha de estrutura `scrum-master/ processo, quadro, status` no `README.md` |
| Ponteiros | varredura de todo `](….md)` relativo | **0 quebrados** *(1 falso positivo conhecido: link dentro do bloco gerado de `project-context.md`)* |
| Encoding | decodificação UTF-8 estrita de todo `*.md` | **0 arquivos inválidos** |

### Pendente do stakeholder

- **Fecho da entrega:** passa a **`v3.3.0`** — carrega quatro entradas de processo (v3.0, v3.1, v3.2, v3.3).
- **Reiniciar a sessão** — `agents/` e `commands/` mudaram.
- ~~**`impact-analysis.md` continua no SM**~~ — **resolvida no addendum abaixo.**

### Addendum — 08/09/2026 · a análise de impacto migra ao PO

*(Anexado, não reescrito — R17. Resolve a pendência que esta mesma entrada declarou; não corrige nada acima.)*

**Instrução:** *(stakeholder, direta)* "sim, migra também."

**O que mudou:** `templates/impact-analysis.md` sai de `roles/scrum-master/` e vai para `roles/product-owner/` (`git mv`); **`/sm impact` vira `/po impact <mudança>`**. O objeto da análise é o **plano de entrega** — manter a análise no SM deixaria o dono do plano sem o instrumento que o altera.

**A fronteira que não migrou.** O template passa a declarar **três insumos com dono explícito**, e o PO **consolida sem inventar nenhum**: quadro, capacidade e "o que sai para caber" vêm do **SM**; retrabalho, contrato e migration vêm do **Arquiteto**, porque **o PO não decide "como"**; risco e recomendação são dele. Regras novas: *"não invente insumo técnico — estimar retrabalho sem o Arquiteto é opinião com aparência de número"* e *"não recalcule capacidade — a conta é do SM"*.

**Por que isto não contradiz o `/sm agreement` desta mesma entrada.** Lá o SM facilita porque há **disputa** e o PO seria **parte** (*"o requisito está errado ou a implementação está?"*). Aqui **não há disputa**: é a análise de uma mudança a um plano que é do PO. **Reunir insumo para informar a própria decisão não é arbitrar** — arbitrar é decidir entre duas partes, e o PO não está julgando ninguém. A distinção está escrita nos dois documentos, para que a próxima leitura não os veja como contraditórios.

**R13 se divide, e continua coerente:** **nomear o instrumento é do SM** — método é o domínio dele, e ele **sinaliza o gatilho** de controle integrado de mudanças; **conduzir a mudança de baseline é do PO**, porque a baseline vive no plano de entrega. Refletido em `skills.md` §9, `working-rules.md` R13, `commands/{sm,po}.md` e nos dois roteiros.

**Evidência (R19):** `git mv` detectado como rename; **`grep '/sm impact'` fora dos changelogs = 0**; a **leitura no contexto** pegou três ocorrências que a substituição de padrão não casaria — o título da seção no roteiro do SM, a linha da tabela de documentos dele e o texto de `skills.md` §9, todos reescritos à mão para a divisão insumo/instrumento. **Sem bump de versão:** a entrega segue `v3.3.0`, porque isto completa uma decisão já registrada, não abre uma nova.

---

## v3.2 — A métrica de eficiência para de medir história fria; o `/review` sai do caminho quente — 08/09/2026

**Instrução:** *(stakeholder, direta)* "faça uma revisão de processo geral e otimização sempre com o objetivo de otimizar o gasto com tokens e garantia de qualidade do processo e do produto desenvolvido pelo time."

**Classificação:** formato de documento (extração de conteúdo frio do caminho quente) + regra (a métrica de §5c e os indicadores de retrospectiva mudam de definição). Nenhum fluxo, cerimônia, portão ou propriedade de artefato alterado — **a garantia de qualidade não foi tocada**, e a auditoria abaixo confirma que continua íntegra.

### Medição — a fase Check do PDCA (§5c)

| Papel | Carga fixa antes | Carga fixa depois | Δ |
|---|---|---|---|
| scrum-master | 13,5 KB | 12,7 KB | −6% |
| product-owner | 10,4 KB | 10,0 KB | −4% |
| architect | 10,9 KB | 9,8 KB | −10% |
| user-experience | 11,2 KB | 10,7 KB | −4% |
| developer | 7,4 KB | 6,9 KB | −7% |
| quality-assurance | 10,2 KB | 9,6 KB | −6% |
| **Total** | **63,6 KB** | **59,7 KB** | **−6%** |

Custo de um broadcast `/team <mensagem>`: **69 KB** (os seis fixos + `commands/team.md`), antes de qualquer leitura de `.team-project/`. É a operação mais cara do time por uma ordem de grandeza.

### O que mudou

| Documento | Onde | O quê |
|---|---|---|
| `agents/{scrum-master,product-owner,architect,user-experience,quality-assurance}.md` | seção final | A seção "Evolução dos seus documentos" **era duplicação literal** de `review-contract.md` §"Alcance por papel" — inclusive os "cuidados do Arquiteto sobre `standards/`", quase palavra por palavra. Reduzida a **um parágrafo** que aponta para o contrato e preserva a única regra que precisa ser lida antes dele: *escreva na RAIZ, nunca em `${CLAUDE_PLUGIN_ROOT}`*. **−1,9 KB de caminho quente, zero informação perdida** |
| `commands/{po,arc,qa,ux,dev,sm}.md` | seção final | O parágrafo "Evolução dos documentos do X — não é aqui" repetia o que o `review-contract.md` já diz. Comprimido a **uma linha de roteamento** (`/X review …` → `/review …`), que é a única parte usada em tempo de invocação. As instruções operacionais ("ao receber o veredito/relatório…") foram **preservadas na íntegra** |
| `process/workflow.md` | §5c, "Métrica por papel" | **Passa a ser dois números, nunca somados:** *carga fixa* (`agents/` + `commands/`, paga em toda invocação) e *conjunto sob demanda* (`roles/<papel>/`, **sem os changelogs**). Seção nova ordenando onde o corte rende mais, e o custo do broadcast declarado |
| `process/working-rules.md` | indicadores | A linha única de footprint vira **duas**, alinhadas à métrica nova |
| `templates/retrospective.md` | métricas | Idem: carga fixa e conjunto separados; o teto de entrada de changelog (R17) vira linha própria |
| `review-contract.md` | `/review metrics` | O giro **Act** passa a exigir os dois números separados, e a preferir a remoção na carga fixa |

**O defeito que a métrica tinha.** `roles/scrum-master/` mede **320,9 KB**, dos quais **159,4 KB (50%) são o changelog arquivado** — frio por construção (só lido em `/review history`) e **monotonicamente crescente por decisão do próprio processo**, já que R17 manda arquivar em vez de apagar. Contra ~30 KB dos outros papéis, o SM aparecia dez vezes mais pesado por causa de história que ninguém carrega. O giro **Act** apontaria sempre para o SM e nunca para o desperdício real, que estava nos 63,6 KB de carga fixa. **Métrica errada não deixa de corrigir — dirige o corte para o lugar errado**, e teria custado ao time um giro inteiro de PDCA cortando o documento errado.

**Modo de falha que evita:** o ciclo de eficiência otimizar o que não custa e ignorar o que custa. É o análogo, para o processo, do que R7 evita no produto: decidir sem medir o que importa.

**Quem passa a ser cobrado de forma diferente:** o **SM** (reporta dois números na retrospectiva, não um) e **todo papel** no `/review metrics`.

**Indicador de sucesso:** a carga fixa total não volta a subir sem regra ou cerimônia nova que a justifique; o próximo `/review metrics` propõe remoção na carga fixa, não no conjunto sob demanda.

### Auditoria de qualidade — o que foi verificado e está íntegro

| Verificação | Resultado |
|---|---|
| Toda regra tem forma de verificação ("SM verifica") | **21/21** |
| Contagem declarada × real de regras | 21 × 21, e 21 linhas no resumo |
| Modelo órfão (template que ninguém referencia) | **0** |
| Links `.md` quebrados | **0** *(1 falso positivo: link dentro do bloco markdown gerado de `project-context.md`)* |
| Portões, gates, DoR/DoD, escada de falha, seis frentes do QA | **inalterados** — nenhum controle de qualidade foi removido nesta entrada |

### Evidência (R19)

| Classe | Comando | Resultado |
|---|---|---|
| Arquivamento | `Compare-Object` do bloco `## v2.11` movido × `git show HEAD` | **53 × 53 linhas, diff = 0.** Índice de arquivadas ganhou a linha `v2.11` |
| Extração | tamanho de `agents/` + `commands/` antes e depois | 63,6 KB → 59,7 KB (−6%); por papel, na tabela acima |
| **Integridade da extração** | `grep` de "Alcance por papel" e dos 5 papéis em `review-contract.md`; `grep` do roteamento `/X review` nos 6 comandos | contrato cobre **5/5** papéis e os cuidados de `standards/`; roteamento preservado em **6/6** comandos |
| **Encoding** | contagem de mojibake (`Ã`, `â€`, `Â`) em `agents/` e `commands/` | **0.** Uma primeira tentativa da extração usou `Get-Content` (ANSI no PS 5.1) com `WriteAllLines` (UTF-8) e **corrompeu 5 arquivos por dupla codificação** — detectado porque os *bytes subiram enquanto as linhas caíam*; revertido com `git checkout` e refeito com `ReadAllText`/`WriteAllText` |
| Auditoria | varredura de regras sem verificação, modelos órfãos, contagens e links | tabela acima |

### Pendente do stakeholder

- **Fecho da entrega:** a entrega passa a **`v3.2.0`** — carrega três entradas de processo (v3.0, v3.1, v3.2).
- **Reiniciar a sessão** — `agents/*` e `commands/*` mudaram.
- **Não aplicado, proposto:** o bloco fixo §8 do `.team-project/README.md` custa **2,6 KB lidos por todo papel em toda invocação**. Cortá-lo exige decidir o que o agente precisa saber de cor sobre a superfície de comandos — é a maior economia restante, e é sua a caneta sobre esse bloco.

### Addendum — 08/09/2026 · correção do custo de broadcast

*(Anexado, não reescrito — R17. A entrada acima fica como foi registrada.)*

O número **"69 KB por broadcast"** registrado acima **está errado**. Ele somava os seis arquivos de `commands/` à carga do broadcast, e eles **não são carregados ali**: `commands/<x>.md` entra no **contexto principal** quando o stakeholder digita `/x`; `agents/<papel>.md` entra no contexto do **subagente**. Um broadcast carrega `commands/team.md` **uma vez** mais um `agents/<papel>.md` por subagente — nunca os seis arquivos de comando.

**Valores corretos:** `/team <mensagem>` = **47,9 KB** · `/team agreement` = 55,1 KB · `/team brainstorm` = 36,6 KB · `/team cycle` = 27,6 KB. A ordem de grandeza e a conclusão não mudam — o broadcast continua sendo a operação mais cara —, mas o número estava 44% acima do real.

**O que a correção acrescentou ao normativo:** `workflow.md` §5c passou a declarar **onde cada arquivo é carregado** (principal × subagente), a tabela de custo por comando, e as **três coisas que a carga fixa não mostra** e costumam dominar o custo real — o **modelo** de cada agente (`/arc` e `/ux` em Opus, `/dev` em Haiku: `/arc` carrega menos que `/sm` e custa mais), a **leitura em tempo de execução** (que costuma superar a carga fixa e é multiplicada pelo número de subagentes) e o **retorno das respostas** ao contexto principal na consolidação.

**Como foi detectado:** o stakeholder perguntou quais são os comandos mais caros do time; a conta refeita papel a papel não fechou com o registrado. **Modo de falha que isto expõe:** medir sem declarar *onde* cada arquivo é carregado produz número plausível e errado — e a v3.2 é exatamente uma entrada sobre não confiar em métrica mal definida.

---

## v3.1 — Protótipo funcional em HTML vira entregável e pré-condição do portão ①; o Sprint Backlog ganha o próprio nome — 08/09/2026

**Instrução:** *(stakeholder, direta)* "nos documentos do team-project está faltando o SprintBacklog; a elaboração do protótipo funcional em html também é entregável e requisito antes de aprovar a sdd funcional."

**Classificação:** entregável novo (protótipo funcional) + regra (R15 ganha a pré-condição do ①) + fluxo (§5b, §5, §8) + propriedade de artefato (o protótipo deixa de ser "exploração" e vira entregável do UX) + formato de documento (modelo novo, renomeação do quadro) + escopo de papel (o UX passa a ter entregável que **bloqueia um portão**).

**Complementa a [`v3.0`](#), não a corrige.** A v3.0 fica como está (R17: entrada nunca é reescrita); o que ela descreveu como "portão ① — o stakeholder aprova o SDD funcional" passa a exigir, a partir daqui, **protótipo navegado**.

### O que mudou

| Documento | Onde | O quê |
|---|---|---|
| **`deliverables/prototype/README.md` novo** | — | O **protótipo funcional** como entregável: por que vem antes do ①, a tabela que o distingue do protótipo de tela do ③, as 7 exigências, o que ele **não** é, os critérios verificados no portão e como ele vence quando a fatia fecha |
| **`roles/user-experience/templates/functional-prototype.md` novo** | — | Estrutura de arquivos (`index.html` + `flows/` + `assets/`, sem build) e a **ficha** com a tabela fluxo × caminho completo, os requisitos representados, o "fora", as premissas e o **registro datado da navegação do stakeholder** |
| `process/working-rules.md` | **R15** | Título e corpo ganham "o ① com protótipo navegado". O modo de falha evitado passa de três para quatro: *o stakeholder aprovar por escrito um produto que só vai **ver** depois de construído* — o mais caro dos quatro, porque o retrabalho já é código. "SM verifica" ganha a exigência do registro de navegação |
| | indicadores | Linha nova: portão ① sem protótipo, sem registro datado de navegação, ou com fluxo principal de `02-flows` sem caminho no protótipo → **o ① foi aprovado por leitura** |
| `process/workflow.md` | §2, §5, §5b, §8 | O diagrama da cadeia mostra o protótipo antes do ①; cerimônia nova na tabela de §5; a transição do brainstorm ganha a linha do protótipo e o ① passa a ler "o stakeholder **NAVEGA** o protótipo e aprova"; §8 ganha **duas** linhas de gate (o protótipo existe · o ① com protótipo navegado); "como o SM verifica" do §5b exige o registro |
| `process/artifact-ownership.md` | matriz, §2 | A linha "Protótipos \| UX \| Exploração, não código de produção" **vira duas**: o **protótipo funcional** (entregável, pré-condição do ①) e os **protótipos de tela e explorações** (portão ③, que **não substituem** o primeiro). O fluxo de §2 mostra o UX no ramo do ① |
| `roles/user-experience/` | README, `/ux prototype` | O modo se desdobra: **`/ux prototype` sem argumento** é o protótipo funcional (7 passos, incluindo conduzir a navegação e registrar); **`/ux prototype <tela>`** continua sendo exploração de tela. Tabela de documentos ganha o entregável |
| `agents/user-experience.md` · `commands/ux.md` | descrição, responsabilidades, modos | O protótipo funcional vira a **responsabilidade 1** do papel; `argument-hint` e a descrição do agente passam a nomeá-lo *(propriedade do stakeholder — aplicado por instrução direta dele)* |
| `deliverables/README.md` | conjuntos, ordem, propriedade | Conjunto novo na tabela; o ① passa a ler "NAVEGA o protótipo e aprova"; linha nova em "por que o portão ① existe"; o protótipo entra na matriz de propriedade (dono UX, revisa stakeholder) |
| **Sprint Backlog** | `templates/work-board.md` → **`sprint-backlog.md`** | O achado do stakeholder: a v3.0 renomeou o **título** do quadro para "Sprint Backlog" e deixou o **arquivo** como `work-board.md`, de modo que em `.team-project/scrum-master/` o artefato central do sprint continuava com o nome antigo. `git mv` + 9 arquivos reapontados, incluindo o manifesto e o passo 7 do `team-update.md` |
| `.team-project/` | estrutura | `user-experience/` ganha `prototype/`; `scrum-master/` passa a listar `sprint-backlog.md`. Refletido em `team-init.md`, `project-context.md`, no manifesto `deliverables/team-project/` e no `README.md` da raiz |

**Modo de falha que evita:** o stakeholder aprovar `00`/`01`/`02` **lendo** e descobrir a divergência só quando o produto existe. A divergência entre o que ele imaginou e o que o time entendeu aparece sempre na primeira vez que ele atravessa o fluxo; a única variável é quanto já foi construído até lá. O protótipo antecipa esse momento para o ponto em que o descarte custa HTML, não arquitetura e código.

**Quem passa a ser cobrado de forma diferente:** o **UX** (ganha um entregável que **bloqueia** um portão, e a obrigação de conduzir a navegação, não de apresentar); o **stakeholder** (não aprova o SDD funcional sem navegar); o **Arquiteto** (não começa o SDD técnico sem o registro de navegação); o **SM** (passa a verificar o registro datado como parte de R15).

**Indicador de sucesso:** todo portão ① com registro datado de navegação e com 100% dos fluxos principais de `02-flows-and-roles` cobertos; nenhuma ocorrência de "aprovado sem navegar" nas retrospectivas.

### Conflitos resolvidos

| Conflito | Com que regra | Resolução |
|---|---|---|
| `artifact-ownership.md` dizia "Protótipos — exploração, **não** entregável" | a instrução do stakeholder diz que é entregável | A linha virou **duas**: o funcional é entregável; o de tela segue exploração. Nenhuma das duas verdades foi apagada |
| O detalhamento da História (③) já exigia protótipo | R20 · DoR da História | São **dois protótipos com escopos diferentes** — produto × tela —, e a tabela de `deliverables/prototype/README.md` declara a distinção para que um não seja usado como desculpa para não fazer o outro |
| "Protótipo é descartável" × "protótipo é entregável" | — | Convivem: é entregável **e** descartável. A ficha marca **vencido** quando a fatia fecha, e a verdade passa a ser o produto |

### Evidência (R19)

| Classe | Comando | Resultado |
|---|---|---|
| Arquivamento | `Compare-Object` do bloco `## v2.10` movido × `git show HEAD:…/process-changelog.md` | **62 × 63 linhas, diferença = 1 linha em branco final**; conteúdo idêntico. Índice de arquivadas ganhou a linha `v2.10` |
| Substituição de padrão | `work-board.md` → `sprint-backlog.md` (+ `git mv` do modelo) | 9 arquivos alterados; **`grep 'work-board'` fora dos changelogs = 0** |
| **Checagem semântica** | leitura das linhas de estrutura do `.team-project/` e das tabelas de comando em cada arquivo | `README.md` da raiz tinha a árvore de `roles/` com `work-board`, fora do padrão de caminho — pego na leitura, não pelo `grep` de caminho |
| Extração / criação | `deliverables/prototype/README.md`, `templates/functional-prototype.md` | 2 novos, referenciados de `deliverables/README.md`, da matriz de propriedade, do README e do agent do UX |
| Ponteiros | varredura de todo `](…​.md)` relativo contra o disco | **1 link quebrado real encontrado e corrigido**: o manifesto `deliverables/team-project/README.md` apontava `sdd/README.md` e `implementation/README.md` como se estivesse em `deliverables/` — corrigidos para `../sdd/` e `../implementation/`. Restante: 0 |
| Manifesto | `claude plugin validate . --strict` | passou |

### Pendente do stakeholder

- **Fecho da entrega:** a entrega passa de `v3.0.0` para **`v3.1.0`** — carrega **duas** entradas de processo (v3.0 e v3.1), como a v2.9.0 carregou três. Bump e entrada única no `CHANGELOG.md` (R18), na branch `feat/v3.0.0`.
- **Reiniciar a sessão** — `agents/user-experience.md` e `commands/ux.md` mudaram.
- **Nome da branch:** continua `feat/v3.0.0` embora a entrega saia como `v3.1.0`. Renomear ou aceitar a divergência é decisão sua; a entrada do `CHANGELOG.md` nomeia a branch real.

