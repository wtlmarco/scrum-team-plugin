# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

---

## v3.0 — Redesenho do modelo de trabalho: História e Task, sprint como caixa de tempo, aceite na Sprint Review — 08/09/2026

**Instrução:** *(stakeholder, via questionário)* o bloco "Revisão do Processo" de `note.md` (15 linhas descrevendo uma cadeia Scrum completa) mais as respostas a seis decisões: sprint como caixa de tempo · SDD funcional/técnico como **portão**, não documento · hierarquia História → Task, com o plano dentro da Task · **aceite só na Sprint Review** · estimativa da Task pelo time na Planning · comandos novos `/po story`, `/sm sprint`, `/sm review`.

**Classificação:** fluxo (§2, §2a, §3, §4, §5, §5e nova) + regra (R1–R2, R4–R8, R11–R17 reescritas; **R20 e R21 novas**) + propriedade de artefato (História, Task, Sprint Backlog, registro de sprint) + formato de documento (modelos de História, Sprint Review, quadro, backlog, aceite, retrospectiva, plano) + comportamento de agente (6 agents, 8 commands) + escopo de papel (PO ganha a História; SM ganha a cadência; QA deixa de ser "o último passo antes do PO").

### O que mudou

| Documento | Onde | O quê |
|---|---|---|
| `process/workflow.md` | §1, §2, §2a | Duas unidades declaradas: **História** (valor, PO, só funcional) e **Task** (trabalho, SM + Arquiteto). Cadeia SDD → História → Sprint → Task com **quatro portões**. Ciclo da Task em 11 etapas |
| | §3, §4 | DoR e DoD **desdobradas em duas**: da História (§3a, §4a-ii) e da Task (§3b, §4a-i). "Aceite do PO" sai da DoD da Task |
| | §5, **§5e nova** | Planning Meeting, Sprint Review e Sprint Retrospective entram nas cerimônias; §5e descreve o sprint como caixa de tempo — Planning em 6 passos com estimativa e **capacidade observada**, escopo congelado, Review, retrospectiva, e como o SM verifica |
| | §5b, §8 | Transição para o SDD ganha os portões ① (funcional) e ② (técnico); a tabela de gates ganha os quatro |
| | §5d | `/team update` passa a **reconciliar o `.team-project/`** (item 29 de `note.md`) |
| `process/working-rules.md` | R1–R17 | Reescritas sobre Task/História/sprint. R14 passa a bloquear a **primeira Planning**; R15 ganha os dois portões do SDD |
| | **R20 nova** | *História é a unidade de valor; Task é a unidade de trabalho.* Toda Task pertence a uma História; detalhamento é **só funcional**; trabalho técnico precisa de História que declare o valor |
| | **R21 nova** | *Aceite funcional é por História, na Sprint Review.* Fechar Task é técnico. **História rejeitada devolve todas as Tasks, inclusive as aprovadas pelo QA** — preço aceito conscientemente |
| | indicadores | Passam a rodar por sprint; linhas novas de R20, R21 e estimado × entregue. **19 → 21 regras** |
| `process/artifact-ownership.md` | matriz, §2, §3, §4 | História (PO), Task (SM + Arquiteto), registro de sprint; Product Backlog = conjunto das Histórias; fluxo com os quatro portões; 5 conflitos novos; IDs `H-nnn`/`T-nnn` |
| `roles/product-owner/` | **`templates/user-story.md` novo** | A História em dois estados (esboço · detalhada), com o portão ③ |
| | `product-backlog.md`, `acceptance.md`, README | Backlog vira o conjunto das Histórias, com estados; aceite muda de alvo (História) e de lugar (Review); modo `/po story` |
| `roles/scrum-master/` | **`templates/sprint-review.md` novo** | Registro da Review: o SM conduz e registra, o PO aceita |
| | `work-board.md`, `retrospective.md`, `status-entry.md`, README | Quadro vira Sprint Backlog com cabeçalho de sprint e Tasks sob a História; retro roda por sprint, depois da Review; status-entry registra fechamento técnico; modos `sprint plan`, `sprint close`, `review` |
| `roles/architect/` | `execution-plan.md` → **`implementation-plan.md`** | Renomeado e reposicionado: **é o conteúdo técnico da Task**, não um artefato irmão. É o primeiro e único lugar onde entra decisão técnica |
| `deliverables/` | `README.md`, `sdd/README.md` | Os dois portões do SDD documentados, com o porquê de cada um. O conjunto continua **um só, com versão única** |
| | **`team-project/README.md` novo** | Manifesto do `.team-project/` (itens 27–28 de `note.md`): o que o `init` cria, de onde cada arquivo nasce e **a classe de reconciliação** de cada um. É índice, não cópia |
| `team-update.md` | **passo 7 novo** | Reconciliação do `.team-project/` em três classes, **sem apagar conteúdo do projeto sem aprovação**. 7 → 8 passos |
| `team-init.md` | passos 2, 3, 5 | Aponta o manifesto; coleta **duração do sprint** e **unidade de estimativa** |
| raiz | `README.md`, `how-to.md` | Superfície de comandos com `<H-ID>` × `<T-ID>`; caminho padrão redesenhado com os portões; desambiguação `/sm review` × `/review` |
| `agents/*`, `commands/*` | 6 + 8 arquivos | Superfície, contagens e limites atualizados *(propriedade do stakeholder — aplicado por instrução direta dele, não por proposta do `/review`)* |

**Modo de falha que evita:** o time entregar Tasks tecnicamente corretas que, somadas, não entregam nada que o stakeholder reconheça como valor — e não haver momento formal em que isso apareça. Antes, "entregue" era a soma de aprovações técnicas por item; agora é o aceite de uma História, ante o stakeholder, contra critérios que ele mesmo aprovou.

**Quem passa a ser cobrado de forma diferente:** o **PO** (escreve e detalha Histórias, e só aceita na Review); o **SM** (conduz a cadência do sprint e **não aceita nada**); o **QA** (valida por Task e fornece evidência na Review, em vez de ser "o último passo antes do PO"); o **UX** (protótipo migra para o detalhamento da História, antes da Planning); o **stakeholder** (passa a ter quatro portões de aprovação).

**Indicador de sucesso:** nenhuma Task sem História de origem no Sprint Backlog; nenhuma História na Planning sem o portão ③ registrado; nenhum aceite fora da Review; desvio estimado × entregue abaixo de 25% a partir do terceiro sprint.

### Conflitos resolvidos

| Conflito | Com que regra | Resolução |
|---|---|---|
| "Sprint Backlog" era apelido do quadro do SM; `note.md` dava o artefato ao PO | dono único (`artifact-ownership.md`) | O Sprint Backlog **continua do SM**; o que é do PO é a História e o Product Backlog |
| "Task" e "Plano de Execução" seriam dois artefatos | referência cruzada em vez de repetição | O plano vira **conteúdo da Task**; um nome só, `Plano de Implementação` |
| SDD funcional/técnico como dois documentos | "versão única para o conjunto" (`sdd/README.md`) | Viraram **portões de aprovação**; a estrutura de 8 arquivos fica intacta |
| Sprint como 2º relógio ao lado de "a cada 3 itens" | gatilhos de §5, §5c | Todos os gatilhos passam a contar **sprints**; o relógio por item foi removido |
| `/sm review` colidia com o `/review` do processo | `commands/sm.md` dizia "não há mais `/sm review`" | Mantido o nome escolhido pelo stakeholder, com **tabela de desambiguação** em `commands/sm.md`, `roles/scrum-master/README.md`, `README.md`, `how-to.md` e no `project-context.md` |
| Item 27 pedia mover todos os modelos para `deliverables/` | `roles/<papel>/templates/` é do papel | `deliverables/team-project/` é **manifesto/índice**, não cópia — resolve o sintoma sem criar duas verdades |

### Evidência (R19)

| Classe | Comando | Resultado |
|---|---|---|
| Arquivamento | `Compare-Object` do bloco `## v2.9` movido × `git show HEAD:…/process-changelog.md` linhas 159–205 | **47 linhas × 47 linhas, diff = 0.** Relocado íntegro; índice de arquivadas ganhou a linha `v2.9` |
| Substituição de padrão | `Plano de Execução` → `Plano de Implementação` e `execution-plan.md` → `implementation-plan.md`, em todo `*.md` menos changelogs e `note.md` | 19 arquivos alterados; `grep` do padrão antigo = 0 |
| Substituição de padrão | `item` → `Task` com concordância de gênero, idiom `item a item` protegido | 56 arquivos alterados |
| **Checagem semântica** da substituição acima | varredura de concordância + **leitura de cada ocorrência no contexto** | **13 erros de concordância** corrigidos (`um Task aberta`, `a Task inteiro`, `Task concluído`…) e **4 falsos positivos** revertidos, onde `Item` era rótulo genérico de linha de tabela: `README.md` → "Arquivo / pasta"; `compliance-review.md` → "Verificação"; `cross-audit.md` → "Especificação"; `product-backlog.md` → "O que". O `grep` zerado teria mentido nos quatro |
| Substituição de padrão | `19 regras` → `21 regras`, `R13-R19` → `R13-R21`, `/sm plan` → `/sm sprint plan` | 6 arquivos; residual dos três padrões e de `sprint sprint` = 0 |
| Extração / criação | `deliverables/team-project/README.md`, `templates/user-story.md`, `templates/sprint-review.md` | 3 novos, referenciados de `deliverables/README.md`, dos READMEs dos papéis e da matriz |
| Renomeação | `git mv execution-plan.md → implementation-plan.md` | rename detectado pelo git (77%); nenhum ponteiro órfão |

### Pendente do stakeholder

- **Fecho da entrega:** bump para `3.0.0` e entrada `v3.0.0` no `CHANGELOG.md` (R18), na branch `feat/v3.0.0`.
- **Reiniciar a sessão** — `agents/` e `commands/` só entram em vigor no próximo carregamento.
- **Projetos instalados** precisam de `/team update`; o vocabulário mudou, então quadro e backlog existentes pedem leitura antes de aplicar.
- **`note.md`:** o bloco "Revisão do Processo" e os itens 27–29 saem da fila, consumidos aqui.

