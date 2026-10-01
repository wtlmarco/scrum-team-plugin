# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v3.36 — R27 confere a energia e retoma o mesmo agente; Task pesada em segundo plano; ocorrência de plugin só se registra no `run` e se pergunta na Review; `replicate-in-new-project.md` fundido no `how-to.md` (SM) — 01/10/2026

**Instrução** (stakeholder, `/review note`, sete itens de `note.md`, resolvidos em formulário R22). Itens literais: (1) "quando uma invocação voltar 'interrompida' sem ação do stakeholder, a orquestração deve conferir os eventos de energia na janela da falha e classificar como falha de ambiente com causa"; (2) "Retomada, não reinício: abri um agente novo na retentativa. O correto era retomar o mesmo por SendMessage"; (3) "o sprint run deve disparar Arquiteto e QA com run_in_background: true quando a Task for pesada"; (4) "o sprint run pode avisar o stakeholder uma vez para impedir a suspensão do PC"; (5) "na retrospective levar falhas na execução do plugin ou um uso abusivo de tokens … abrir uma vez no sprint run o formulario … investigar e gerar relatorio e correcao ao fabricante do plugin … ou ignorar e seguir"; (6) "Os arquivos review-contract, team-init, team-update, team-version precisam ficar na raiz?"; (7) "o arquivo replicate-in-new-project ainda precisa existir se temos o how-to?".
**Classificação:** regra (R27), etapa de fluxo (`sprint run`), cerimônia (Review e retrospectiva), formato de documento (`plugin-report.md` condicional) e propriedade/estrutura de guias de raiz. Papel único: SM.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `process/working-rules.md` · `working-rules-index.md` | R27 (texto, Evita, SM verifica) · linha R27 | **Antes de retentar**, a orquestração confere energia/suspensão do SO na janela da falha e classifica **falha de ambiente com causa e horário** — nunca defeito do plugin nem culpa de alguém (suspender o PC é decisão do stakeholder). **Retentar é retomar:** o mesmo agente por `SendMessage` (R3); instância nova só se ele não existe mais e depois de ler o disco (R5). Contagem de regras inalterada (31) |
| `process/sprint-run.md` | "Quando a fila para" · nova seção "Task pesada" · "Como o SM verifica" | Remissão a R27 (energia + `SendMessage`); **Task pesada** = estimativa ≥ 2× a mediana do sprint ou já acionou o `operator` → `architect` e `quality-assurance` com `run_in_background: true`, série R1 mantida; ocorrência de plugin **só se registra** no quadro, sem formulário no `run` |
| `process/workflow-sprint.md` | §5e Review · Sprint Retrospective (novo parágrafo "Ocorrência de plugin", fonte única) · verificação | **Ocorrência de plugin** = ≥ 2 falhas R27 persistentes no sprint **ou** consumo de um papel > 2× a média dos últimos sprints. O formulário R22 **investigar · ignorar e seguir · pedir mais contexto** abre **uma vez por sprint, no contato da Review** (R25 intacta: nenhum contato novo). Falha de ambiente com causa externa não conta. `plugin-report.md` passa a **condicional a "investigar"** |
| `templates/retrospective.md` · `plugin-report.md` · `process/artifact-ownership.md` · `roles/scrum-master/README.md` · `templates/project-context.md` · `deliverables/team-project/README.md` · `how-to.md` | blocos do relatório ao dono do plugin | Ponteiros alinhados: `plugin-report.md` só existe quando houve "investigar"; retrospectiva registra a ocorrência e a escolha; relatório traz a ocorrência que o motivou |
| `how-to.md` | nova seção "Calibrar a instalação" (+ parágrafo "Uma origem, vários projetos") | Recebe do `replicate-in-new-project.md` o que era único: composição de modelos (passo 4), primeira rodada de validação (passo 6) e o checklist, uma vez, ao fim da instalação |
| `replicate-in-new-project.md` | — | **Removido** (`git rm`). Passos 1, 2 e 5 já eram do `how-to.md` (instalar, `/team init`, cenários A/B); passo 3 (entregáveis) vive em `deliverables/README.md` |
| `rituals/` (**novo**) · `commands/team.md` l.14–16 · `commands/review.md` l.52 e l.56 · `agents/{scrum-master,product-owner,quality-assurance,user-experience}.md` · `README.md` (índice e l.191) · `artifact-ownership.md` l.36 e l.56 · `workflow-processo.md` l.45 e l.100 · `working-rules.md` l.146 e l.162 · `deliverables/team-project/README.md` l.21 e l.69 · `rituals/review-contract.md` (l.3, l.5 e l.69) | item 6 | `review-contract.md`, `team-init.md`, `team-update.md` e `team-version.md` **movidos da raiz para `rituals/`** (pelo stakeholder, à mão: o `git mv` foi negado ao SM). Curadoria de referência cruzada aplicada pelo SM: ponteiros `${CLAUDE_PLUGIN_ROOT}/rituals/…` e `RAIZ/rituals/…`, links relativos (`../`) e a lista de guias de raiz. Os guias usam `${CLAUDE_PLUGIN_ROOT}/…` para o resto, sem link relativo próprio além do `review-contract.md` |
| `README.md` · `standards/README.md` · `commands/arc.md` l.12 · `commands/review.md` l.52 · `review-contract.md` l.69 · `artifact-ownership.md` l.15 e l.56 | ponteiros e listas de guias de raiz | Cinco ponteiros repontados para `how-to.md` e o arquivo sai das listas (curadoria de referência cruzada). Índice de estrutura do `README.md` ganha a linha de `team-version.md`, que faltava |

### Por quê
- **R27 (1+2):** a falha medida foi três chamadas "interrompidas" que eram suspensão do PC — sem a conferência, o ambiente vira mistério ou culpa; sem a retomada por `SendMessage`, cada retentativa joga fora o contexto já pago.
- **Task pesada (3):** um bloqueio de 27 minutos da sessão por falha que só se sabia ao fim; em segundo plano a falha chega como notificação, e a série (R1) não muda.
- **Ocorrência de plugin (5):** o relatório ao fabricante era sempre gerado, sem decisão do stakeholder e sem gatilho objetivo; agora tem limiar verificável, uma pergunta por sprint no contato que já existe, e o "ignorar" é resposta válida.
- **Fusão (7):** dois guias com a mesma instalação e o mesmo "nova estrutura" divergem — já havia a contagem "8 comandos e 7 agentes" duplicada.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Sessão que orquestra | Confere energia antes de retentar; retoma por `SendMessage`; dispara Arquiteto/QA em segundo plano em Task pesada; abre o formulário de ocorrência na Review |
| SM | Registra a ocorrência no quadro durante o `run`; gera `plugin-report.md` só com "investigar"; verifica a conferência de energia no relato de falha |

### Conflitos com o processo vigente
- **Item 4 descartado pelo stakeholder:** "se o PC suspender foi determinado pelo stakeholder e não é um problema" — nada aplicado; a conferência de energia do item 1 só **classifica** a falha com a causa.
- **Item 5, opção B:** a posição A (formulário durante o `run`) contrariava "não peça nada ao stakeholder aqui" (sprint-run) e R25 ("dois pontos de contato por sprint"); ficou a B — o `run` só registra e a Review pergunta.
- **Item 3:** `commands/arc.md` e `commands/qa.md` trazem `run_in_background: false` literal; só o `sprint-run.md` foi mudado, e o literal vira proposta (abaixo).

### Como saberemos que funcionou
Primeira falha de invocação do próximo sprint: relato traz energia (causa/horário ou "nada achado") e a forma da retomada; nenhuma instância nova aberta onde o agente ainda existia (`ListAgents`). Task pesada com marca de segundo plano no registro de consumo. Zero formulário de plugin durante o `run`; no máximo um por sprint, na Review. Prazo: dois sprints.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Remoção | `git rm replicate-in-new-project.md` | `rm 'replicate-in-new-project.md'`; 60 linhas removidas; `how-to.md` 203 → 230 linhas não vazias; entrada v3.34 (parte 2) arquivada idêntica (`Contains` do texto original de `HEAD` no arquivo: True) | ✅ |
| Substituição de padrão | `Select-String 'replicate-in-new-project'` em todos os `*.md` fora de `CHANGELOG*`/`process-changelog*`/`note.md` | 0 ocorrências; as 6 novas referências a `how-to.md` § "Calibrar a instalação"/"Instalar…" lidas no contexto | ✅ |
| Contagem | `Select-String '^### R\d+\.'` em `working-rules.md` · `'^\| R\d+ '` em `working-rules-index.md` | 31 · 31 (inalterada) | ✅ |
| Links | varredura de `](caminho)` relativos nos 14 arquivos tocados | 0 quebrados novos; 1 preexistente (`project-context.md` → `how-to.md`, texto de modelo copiado ao projeto, fora desta rodada) | ✅ |
| Extração (item 6) | `Get-ChildItem -File` na raiz e em `rituals/` | raiz: `.gitignore`, `CHANGELOG.md`, `how-to.md`, `note.md`, `README.md`; `rituals/`: os 4 guias | ✅ |
| Substituição de padrão (item 6) | `Grep` de `review-contract`, `team-init`, `team-update`, `team-version` fora de changelogs e `note.md`, cada ocorrência lida no contexto | ver bloco "Evidência do item 6" abaixo | ✅ |

**Item 6 (aplicado no mesmo dia):** o `git mv` foi negado ao SM pelo harness; o stakeholder moveu os quatro arquivos à mão e o SM aplicou só a curadoria de referência cruzada. O git os vê como delete + untracked até o stakeholder dar `git add`.

**Nota de migração.** Projeto instalado em versão anterior lê os guias (`team-init.md`, `team-update.md`, `team-version.md`) **pela raiz do plugin** (`${CLAUDE_PLUGIN_ROOT}/…`). O `commands/team.md` novo aponta para `rituals/`; as duas coisas chegam juntas pelo `/team update` e **só valem depois de reiniciar a sessão**. Quem copiou algum desses guias para fora do plugin precisa trocar o caminho.

### Fecho — propostas aplicadas pelo stakeholder (01/10/2026)
- **Propostas de `commands/` aprovadas e aplicadas:** `commands/sm.md` l.35 (R27 aponta para a fonte única, com conferência de energia e retomada por `SendMessage`) e `commands/arc.md`/`commands/qa.md` l.10 (`run_in_background: false` salvo no `sprint run` de Task pesada).
- **Release (R18):** `plugin.json` 3.36.0 · entrada `v3.36.0` no topo de `CHANGELOG.md` · banner `v3.36.0` no `README.md`. Branch `feat/v3.36.0` a partir de `develop`, com o `rituals/` adicionado ao git (renomeação), e PR para `develop`.
- **Pendente:** reinício da sessão (comportamento de agente) e, na primeira falha de invocação, conferir o relato com energia e forma de retomada.

---

## v3.35 — `.team-project/` sai do git (R31); R28 enxuta: relatório do job com teto, `report-<log>.md` por chamada, dev isento, log podado não é achado; consumo fora de sprint em `.team-project/consumption.md` (SM) — 30/09/2026

**Instrução** (stakeholder, `/review note`, em três momentos no mesmo dia). (1) *"Otimizar a evidência do Operator para guardar o trecho do log … e não o log inteiro para não precisar subir no git … um log que passa de 100MB afetando o Git"*. (2) *"O registro de consumo dentro do sprint está sendo registrado em consumption.md; agora, onde está registrando os gastos das tarefas que estão fora do sprint?"* — e a decisão: *um arquivo `consumption.md` na raiz de `.team-project/`, no mesmo modelo*. (3) Decisão final: **remover `.team-project/` do git** — `.gitignore` com `.team-project/` na raiz; o git recebe só o produto (código e `docs/`); continuidade e retrabalho aceitos; documento de produto não referencia `.team-project/`; comportamento de agentes, comandos e guias de raiz autorizado; sem bump de versão.
**Classificação:** regra de trabalho (R28 reescrita; **R31 nova**) · propriedade de artefato (`.team-project/consumption.md`; §1f produto × processo) · formato de documento · comportamento de agente e de comando (aplicado por autorização do stakeholder).
**Papéis movidos (R17):** 6 — SM, PO, Arquiteto, dev (documentos do dev, pelo Arquiteto), QA e UX → barreira 20 KB (10 KB até dois papéis + 2,5 KB × 4 adicionais; teto absoluto 20 KB). Entrada final: 17,6 KB (≤ 20 KB).

### Desenho final
O desenho intermediário do mesmo dia (relatório versionado como "único arquivo no git", `.gitignore` de `*.log`, "resolve em qualquer máquina", "log ausente") **foi substituído antes de qualquer release** pelo que segue; nada dele sobra em `roles/scrum-master/`, `agents/`, `commands/` nem nos guias.
- **R31 (nova):** `.team-project/` inteiro fora do git; o repositório recebe só o produto; o estado da gestão é local e sem histórico; **documento de produto (`docs/`) nunca referencia `.team-project/`** (o processo pode citar `docs/`). Verifica-se por `git ls-files .team-project` vazio, `git check-ignore`, e grep de `.team-project` em `docs/` e nos modelos que o geram.
- **R28 (enxuta):** (a) cada chamada deixa um `report.md` — trecho decisivo + contagens + ponteiro do log — com **teto de 200 linhas e 20 KB**, para economizar o contexto de quem lê; (b) **várias chamadas na mesma pasta de job → um `report-<log>.md` por chamada**, sem sobrescrita; (c) o **build de fim de passo do dev** continua dele, isento de `report` (log redirecionado + trecho no relatório de entrega); (d) **severidade mista no aceite:** `report` ausente = rejeição (R7); acima do teto = achado de processo, e o aceite segue pelo trecho; (e) retenção e poda do log bruto viram **gestão de disco local** — log podado não é achado e o `report` sobrevive; com gatilho disparado e log podado, re-rodar pelo `operator` ou "não verificado — log podado". Some: "versionado", "único no git", "resolve em qualquer máquina", `.gitignore` de `*.log`. **Exceção de coerência com R31:** em documento de produto (`docs/`), só o trecho — o ponteiro fica no artefato de processo que o cita.
- **Consumo fora de sprint:** `.team-project/consumption.md` (mantido; agora local também), mesmo modelo, Nota `pre-sprint;`/`entre-sprints;`, sem rotação, sem transcrição; substitui a subseção de `context.md` e o passo 9 da Planning.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `process/working-rules.md` | R28 (corpo · Evita · SM verifica) · **R31** · resumo | R28 no desenho final acima; contagem de fechamento em duas janelas (sprint × sprint; `pre-sprint/` desde o fechamento anterior × fora de sprint); R31 nova com "o que evita" e "como o SM verifica" |
| `process/working-rules-index.md` | linhas R28 e R31 · título | Acompanha (R1–R31) |
| `process/artifact-ownership.md` | §1 (linha do consumo fora de sprint) · §1c · **§1f (novo)** | `.team-project/consumption.md`, dono SM, sem rotação; §1f "Produto × processo — o que o git recebe" |
| `process/workflow-sprint.md` · `workflow-sdd.md` · `workflow-processo.md` | §5e passo 9 · registro de consumo · verificação de fechamento · §5h · §5c | O `consumption.md` do sprint nasce vazio; sem transcrição; contagem de R28 por `report` |
| `templates/consumption.md` · `retrospective.md` · `project-context.md` · `roles/scrum-master/README.md` | Como gravar · Regras · contagem R28 · passos 3 e 9 · tabela de artefatos | Destino por estado do sprint; `report-<log>` na identificação da chamada; subseção antiga de `context.md` migrada no `update` |
| `deliverables/README.md` · `deliverables/team-project/README.md` | índice · manifesto (linha `.gitignore` `.team-project/`, aviso "tudo aqui é local") | Produto × processo (R31); acumulado de consumo inclui o arquivo da raiz |
| `agents/operator.md` | "Onde grava" · "Formato do relatório" · "Retenção" | `report.md` ≤ 200 linhas · 20 KB com conferência antes de devolver; `report-<log>.md` por chamada; segmento `pre-sprint/` = "sem sprint aberto"; poda = disco local |
| `agents/quality-assurance.md` (l. 38) · `agents/scrum-master.md` (l. 34) | regra de registro · contagem | Ponteiro do job (`report`), log podado não é achado; 31 regras |
| `commands/{sm,po,arc,ux,qa,dev}.md` | "Registro de consumo" | Destino: sprint aberto → `sprints/<n>/consumption.md`; senão `.team-project/consumption.md` |
| `team-init.md` · `team-update.md` (**passo 7b novo**) · `how-to.md` · `README.md` · `replicate-in-new-project.md` | árvore · `.gitignore` · migração · "onde mora" | `init` acrescenta `.team-project/` ao `.gitignore` (só acrescenta) e cria o `consumption.md` vazio; `update` 7b reescrito: `.gitignore` → desrastrear → **limpar o histórico** (backup, `filter-repo`, push forçado) → verificação, cada passo destrutivo com confirmação no momento da execução; migra a subseção antiga |
| `process/artifact-ownership.md` | §1 (nova linha) | **Jobs do `operator`** (`.team-project/operator/**`): SM verifica e poda, papel chamador cita |
| `CHANGELOG.md` · `.claude-plugin/plugin.json` · `README.md` (banner) | entrada `v3.35.0` · `version` · "Versão atual" | Release (R18): `3.35.0` nos três; `marketplace.json` não tem `version` |
| `process/process-changelog(-archive).md` | — | v3.34 arquivada (R17, três entradas mantidas) |

### Rodadas 2 e 4 — os papéis simplificam os próprios documentos; correções da reavaliação (curadoria do SM)
Nenhum papel editou este arquivo; uma linha por papel, pelo relato dos donos.
- **PO** — `acceptance.md` (o aceite confere o `report`); `01-scope-and-criteria.md` migrado para **Sprint/História** (H-nnn, `[x]` só com aceite na Review, congelamento R4/R25; §4 e duplicidades removidas); skill 9 nova; "Como o QA valida" virou ponteiro para as seis frentes. −32 linhas.
- **QA** — "ponteiro do log" → "ponteiro do `report`" em todo o alcance; citações de passo nomeadas; `pending.md` e `03-code-map.md` sem caminho de processo (R31); `/arc comply` fora de `verdict.md`; README enxuto. 7 arquivos, +24/−24.
- **UX** — `deliverables/prototype/README.md` como fonte única dos critérios (regras dos modelos e passos do roteiro viraram ponteiros); saem o campo "Log bruto" das fichas e as "Falhas comuns" de `screen-spec` e `journey-map`; limiares e "Como se verifica" em §9. −42 linhas, −6,1 KB.
- **Arquiteto (+ dev e standards)** — `compliance-review.md` **apagado** (fim do `/arc comply`; aderência só na frente 2 do QA); `standards/` **Vigentes**; lista única de gatilhos de GAP em `gap.md`; fonte única para R16, checklist de segurança e ADR; exemplos neutros de stack. −124 linhas, −9,7 KB (−8,7%).
- **SM** — R28 em subitens (8,9 → 6,1 KB) com o consumo fora de sprint só em `templates/consumption.md`; R31 verifica o diretório de produto declarado no §4; `project-context.md` (árvore e §4); `/arc comply` fora de `commands/arc.md`, `agents/architect.md` e guias; "prepare, passo N"/"Planning, passo N"; consumo dos 6 `commands/` só em ponteiro (carga fixa 62.971 → 61.770 B, `/sm` 13.436 B); `dev resume` corrige só o achado do QA; `team-update` 7b por `AskUserQuestion`; escopo por sprint em `artifact-ownership`, `deliverables/README.md`, `implementation/README.md` e `02-status.md`; suíte de cenários na linha do QA de `review-contract.md`.

### Por quê
**R31:** o repositório do produto carregava estado de gestão e logs de centenas de MB; o desenho intermediário tentava salvar o que dava (relatório no git, log fora) e acabou criando três estados por arquivo. Tirar o `.team-project/` inteiro elimina o problema pela raiz, ao custo aceito pelo stakeholder de não ter histórico do processo nem continuidade entre máquinas. A regra de links decorre: produto que aponta para `.team-project/` quebra para quem clona. **R28:** sem versionamento, o valor do `report` é economizar contexto (daí o teto), não ser evidência distribuída; uma pasta com mais de uma chamada sobrescrevia o relatório da primeira (achado do Arquiteto); o build de fim de passo do dev nunca foi chamada ao `operator`; e podar log é higiene de disco.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| `operator` | `report` ≤ 200 linhas e 20 KB, conferido antes de devolver; `report-<log>.md` quando há mais de uma chamada na pasta |
| QA · Arquiteto · UX · Dev · PO | Ponteiro = `report` do job; "versionado / resolve em qualquer máquina / fora do git" saem; aceite: `report` ausente = rejeição, acima do teto = achado (lista por papel na entrega do `/review`) |
| Dono de modelo de produto (PO, Arquiteto, QA, UX) | Modelo que gera `docs/` não cita `.team-project/` (R31) |
| SM | Verifica `git ls-files .team-project`, `.gitignore` e grep em `docs/`; consumo fora de sprint direto no arquivo da raiz |
| Stakeholder | Migração 7b: aprova o desrastreamento; decide limpar (ou não) o histórico |

### Conflitos com o processo vigente
Resolvidos pela decisão do stakeholder: R28 ("versionado com o projeto"; "ponteiro que resolve") e §1c (retenção só em pasta) deixaram de conflitar ao reescrever R28 e declarar o registro fora de sprint. Pendências de 30/09 (várias chamadas por pasta; build do dev; severidade no aceite) decididas em (b), (c), (d) acima.

### Como saberemos que funcionou
No primeiro projeto atualizado: `git ls-files .team-project` vazio e `git check-ignore -v .team-project/README.md` devolvendo a regra; `git status` sem arquivo de `.team-project/`; nenhum `.team-project/` em `docs/`; nenhum `report` sobrescrito (um `report-<log>.md` por chamada na mesma pasta); `.team-project/consumption.md` com uma linha por invocação fora de sprint.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição | `Select-String` em `roles/scrum-master`, `agents`, `commands`, guias de raiz, `deliverables/{README,implementation/README,team-project/*}` por `resolve em qualquer máquina`, `só o report.md`, `git recebe só o report`, `*.log` do `.gitignore`, `versionado com o projeto`, `ainda não contadas`, `transcreve nele`, `log (bruto) ausente` | 0 ocorrências | ✅ |
| Substituição (contagem) | `Select-String '30 regras\|R1.R30'` fora dos changelogs / `'31 regras\|R1.R31'` | 0 / 4 (`agents/scrum-master.md:34`, `working-rules-index.md:1`, `roles/scrum-master/README.md:154`, `README.md:184`); a lista de blocos de `README.md:184` passou a "método R13-R27 e R30-R31" | ✅ |
| Substituição (leitura em contexto) | leitura das ocorrências novas de `report-<log>`, `.team-project/consumption.md` e `.gitignore` | destino, nome e o "só acrescenta" idênticos em R28, `consumption.md`, `operator.md`, `team-init.md`, `team-update.md` 7b | ✅ |
| Substituição (R31 no plugin) | `Select-String '\.team-project' deliverables/sdd, deliverables/implementation` (modelos de produto) | 2 ocorrências (`03-code-map.md:4`, `pending.md:4`), do QA, **roteadas**; `adr.md:3,63` (orientação fora do bloco do ADR) sinalizado ao Arquiteto; `deliverables/prototype/` é processo | ✅ (achados roteados) |
| Arquivamento | `git diff --numstat` dos changelogs (passo anterior, inalterado) | archive `+82 −0` | ✅ |
| Grep cruzado final (rodada 2) | `Select-String` em `roles/ deliverables/ standards/ agents/ commands/` e guias de raiz (98 arquivos, sem `*changelog*`, `CHANGELOG.md` e `note.md`) por: `(log\|report)…versionad` · `(log\|report)…fora do git` · `qualquer máquina` · `único…no git\|só o report` · `log (bruto )?ausente` | **0 / 0 / 0 / 0 / 0**. Controles lidos em contexto: `fora do git` tem 10 ocorrências, todas sobre `.team-project/` inteiro (R31: `working-rules.md:57,233`, `deliverables/README.md:5,16`, `deliverables/team-project/README.md:5,21`, `how-to.md:186`, `README.md:10,14`, `team-init.md:33`), nenhuma sobre log ou `report`; `versionad` perto de log/report: só R18 (`artifact-ownership.md:56`, `working-rules-index.md:43`, entrega versionada do plugin) | ✅ |
| Grep cruzado final (R31) | `Select-String '\.team-project' deliverables/sdd, deliverables/implementation` | 0 ocorrências (o QA reescreveu `03-code-map.md:4` e `pending.md:4`) | ✅ |
| Coerência | `Select-String 'Exceção \(R31\)'` em `working-rules.md`; `Select-String 'report-<log>' agents/operator.md`; leitura de `adr.md` (bloco ```markdown``` nas linhas 7–46) e de `requirement.md:3` | exceção em `working-rules.md:55`; `operator.md:40`; `adr.md:3,63` e `requirement.md:3` estão fora do bloco do modelo → legítimos | ✅ |
| Fila | `Get-Content note.md` | "Abertas" vazia; `git diff --stat note.md` vazio (idêntico ao HEAD) | ✅ |
| Release (R18) | `plugin.json` `version` · 1ª `## v` de `CHANGELOG.md` · 1ª linha "Versão atual" de `README.md` · contagem de `## v3.35 ` em `process-changelog.md` | `3.35.0` · `## v3.35.0 — 2026-09-30` · `**Versão atual: v3.35.0**` · 1 entrada `v3.35` (par `vX.Y` ↔ `vX.Y.0`); `marketplace.json` sem `version` | ✅ |
| Formato (release e migração) | bytes iniciais e LF solto em `CHANGELOG.md`, `plugin.json`, `README.md`, `team-update.md`, `team-init.md` | 0 BOM e 0 LF solto nos cinco | ✅ |
| Migração 7b | títulos `## 7b.` e `## 8.` em `team-update.md`; leitura do passo | 7b na linha 99 e passo 8 na 118 (separados por linha em branco); ordem (a) `.gitignore` → (b) desrastrear → (c) backup + `filter-repo` + push → (d) verificação; confirmação "no momento da execução" nos passos 2 e 3; pula em projeto não-git | ✅ |
| Propriedade | busca de "Jobs do `operator`" em `artifact-ownership.md` | 1 linha na matriz §1 (SM verifica e poda · papel chamador cita) | ✅ |
| Grep final (rodada 4) | `Select-String` em todos os `.md` fora de changelogs: `comply\|compliance-review` · `R25 ?\(b\)` · `ponteiro do log` · `30 regras\|R1.R30` · `31 regras\|R1.R31` | 0 · 6 (UX, citações válidas: R25 tem o item "(b) Cada sprint entrega valor real") · 1 (a própria R28, `working-rules.md:57`) · 0 · 4 | ✅ |
| Links (rodada 4) | script sobre os 103 `.md`, fora de blocos de código | 7 apontamentos, todos placeholders (`sprint-backlog.md:43,48`) ou texto de changelog; **0 links reais quebrados**; `compliance-review.md` não existe mais | ✅ |
| R18 (rodada 4) | `plugin.json` `version` · 1ª `## v` de `CHANGELOG.md` · banner de `README.md` | `3.35.0` == `## v3.35.0 — 2026-09-30` == `v3.35.0` | ✅ |
| Formato | bytes iniciais e `(?<!\r)\n` dos 47 arquivos modificados | 0 com BOM e 0 com LF solto (corrigidos `how-to.md` e `team-init.md`, que tinham LF) | ✅ (desvio corrigido) |

### Decisões finais do stakeholder (rodada 3, 30/09/2026)
1. **Protótipo = processo.** Funcional e do sprint ficam em `.team-project/user-experience/prototype/`, fora do git; nada mudou nos documentos (R31 cita o protótipo como processo).
2. **Dono de `.team-project/operator/**`:** o SM verifica e poda; o papel chamador cita o `report`. Linha nova na matriz de `artifact-ownership.md` (§1).
3. **Limpeza do histórico aprovada**, e a pasta `.team-project/` já commitada também sai do git. O passo 7b de `team-update.md` foi reescrito: (a) `.gitignore`; (b) desrastrear com `git rm --cached` + commit; (c) limpar o histórico com `git filter-repo --path .team-project --invert-paths`, **backup obrigatório antes** (cópia local e `git clone --mirror`), instalação ou alternativa (BFG) se o `filter-repo` faltar, `git push --force` de branches e tags, com os avisos (re-clonar ou rebasear; GitHub pode manter objetos em cache e PRs antigas); (d) verificação por `git log --all -- .team-project` vazio e `git count-objects -vH` antes e depois. **Cada passo destrutivo exige confirmação explícita do stakeholder no momento da execução no projeto**; projeto que não é repositório git pula. `team-init.md` remete ao 7b.
4. **Teto das capturas de tela do `operator`:** só se o disco local virar problema. Nenhuma mudança.
5. **Release aprovada:** `plugin.json` 3.35.0 · entrada `v3.35.0` no topo de `CHANGELOG.md` (par da `v3.35` deste changelog) · banner `v3.35.0` no `README.md` (R18). `marketplace.json` não tem `version`. Branch, commit e push **não** feitos: ficam para o stakeholder autorizar.

### Pendente do stakeholder
- **Git da entrega (R18):** criar a branch `feat/v3.35.0` a partir de `develop`, commitar e abrir o PR — não feito aqui. Mensagem de commit no padrão das entregas anteriores: `v3.35.0: .team-project fora do git (R31), R28 enxuta e consumo fora de sprint`.
- **Execução da migração nos projetos:** a limpeza do histórico e o `push --force` só rodam no projeto, com a confirmação do stakeholder no momento (7b).
- `agents/` e `commands/` só valem após reiniciar a sessão.

---

## v3.34 (parte 3) — Novo modo `/sm sdd`: a transição do brief ao SDD aprovado e às Histórias, com os portões ① e ② disparados pelo próprio modo (SM + PO + UX + Arquiteto) — 30/09/2026

**Instrução** (stakeholder, `/review`, formulário): *"Por qual comando, depois do brainstorm, se elabora o SDD funcional e o técnico que servem de base para o `/sm sprint prepare`?"* — a resposta era uma sequência manual (`/po requirement` → `/po analyze` → `/ux journey` → `/ux prototype` → ① → `/arc` em modo livre → ② → `/po story`), e os formulários dos portões dependiam de "a sessão que orquestrou o comando anterior". **Decisões:** (1) novo modo **`/sm sdd`**, orquestrado pela sessão, com a cadência `brainstorm → sdd → prepare → plan → run → review → close`; (2) alcance nos **dois casos** — ideia nova depois do brainstorm e evolução de área já documentada depois do `/po analyze` (só o delta, portões só no que mudou).

**Classificação:** cerimônia + etapa de fluxo + comportamento de comando (proposta). Entrada **separada** (a "parte 2" tem 14 KB); mesma versão, pois a v3.34.0 está na branch aberta.

### O que mudou (fase do SM)
| Documento | Seção | Mudança |
|---|---|---|
| `process/workflow-sdd.md` (novo, 7,4 KB) | **§5h** | Roteiro do `/sm sdd`: casos A/B e pré-condições (brief fechado **ou** `/po analyze` com decisão; onboarding); estado e retomada em `context.md` §"SDD em elaboração"; 5 etapas com quem é despachado; ① e ② em formulário **disparados pelo `sdd`**; portão sem delta (só com delta nulo declarado pelo dono); saída; o que não faz; consumo pré-sprint; verificação |
| `process/workflow-ritos.md` | §5b "Transição para o SDD" | A tabela vira ponteiro para §5h; o brief passa a ter lugar declarado (`context.md` §"SDD em elaboração", ≤15 linhas); verificação dos portões migra para §5h |
| `process/workflow.md` | §2 · §2a (linha **0c**, linha 1) · §5 (nova linha; "Protótipo funcional") · tabela §5a–5h · §3a DoR-a · §8 (①②) | `/sm sdd` na cadeia e nas cerimônias; ① e ② disparados pelo `sdd` (fim do "quem orquestrou o comando anterior"); DoR-a exige SDD aprovado (① e ②) — projeto retomado: SDD reconhecido no onboarding vale |
| `process/workflow-sprint.md` | §5e "Preparação" passo 1 | `prepare` só recebe Histórias **de SDD aprovado (① e ②)**; requisito sem ② volta ao `sdd` |
| `process/working-rules.md` · `working-rules-index.md` | R15 | Elaboração do SDD por `/sm sdd`; formulários dos portões do próprio `sdd`; regra do portão sem delta (evolução) |
| `process/artifact-ownership.md` | §1 · diagrama | Nova linha: "SDD em elaboração" (seção do `context.md` do SM), com o brief e a decisão do ② |
| `templates/project-context.md` · `consumption.md` | tabela `/sm` · "Por onde começar" · `context.md` do SM · subseção de consumo | `sdd` na tabela e nas sequências; §"SDD em elaboração"; subseção "Consumo pré-sprint (prepare · sdd)" (era "do prepare") |
| `roles/scrum-master/README.md` | nova `/sm sdd` · tabela de documentos · brainstorm · prepare | seção do modo; ponteiros |
| `README.md` · `how-to.md` · `replicate-in-new-project.md` · `team-init.md` | comandos · caminhos A/D · diagrama | `sdd` na lista de modos, no caminho padrão e nas sequências; `/po requirement` → `/ux prototype` → ① → ② manual sai dos caminhos |
| **Aplicação das propostas** (orquestrador, com autorização do stakeholder) | `commands/{sm,po,arc,ux,dev}.md` · `agents/{scrum-master,product-owner,architect,user-experience}.md` | As 9 propostas de `proposals-v2/` **aplicadas**; frontmatter dos 4 agentes conferido igual ao HEAD; 0 resíduos de `architect/plans` ou "sessão que orquestrou" em `commands/` e `agents/` (a ocorrência em `commands/qa.md:27` é a regra geral de R22, correta) |
| **Ajustes finais dos donos** | `roles/user-experience/README.md:56` · `templates/functional-prototype.md:100` · `templates/requirement.md` · `templates/functional-analysis.md` | UX: "portões só dentro do `sdd`" (carga fixa UX 10.842 B); PO: campo **"O que muda (caso B do `/sm sdd`)"** (`requirement.md` 5.699 → 6.169 B; `functional-analysis.md` 2.480 → 2.614 B), README do PO aponta para eles |
| **`how-to.md` reescrito — a pedido direto do stakeholder** (guia de raiz, dele; fora da exceção de curadoria do SM) | `how-to.md` · `team-version.md:21` · `replicate-in-new-project.md:12,:22,:62` · `README.md:17,:42` · `templates/project-context.md:138` | Guia por uso: "Em um minuto" · "o que você quer → comando" · cenários A–F · "Os seus quatro portões" · regras · "Referência dos comandos" · onde cada coisa mora · "Instalar e manter atualizado" (com "Problemas de instalação"). Ponteiros dos demais documentos atualizados para as seções novas; `project-context.md:138` diz que a cópia do guia é criada pelo `/team init` e **substituída** pelo `/team update` (cópia literal — `team-update.md:107`) |
| `process/workflow-sprint.md` §5g "Manutenção" | correção pontual (2 ocorrências) | O caminho manual "caminho C" (`/arc question` → `/arc plan` → `/dev` → `/qa` → `/sm close`) vira: `/arc question` se a causa não é óbvia → entrada fora da Planning registrada por `/sm board` com "o que saiu para caber" → `/sm sprint run <T-ID>`, alinhado a `sprint-run.md` pré-condição 2 e ao how-to |
| **Regressão da parte 2 corrigida** (achado do Arquiteto) | `team-update.md:76,:97` × plano de calibração | A parte 2 pôs o plano de calibração em `.team-project/architect/plans/`, que o `team-update` trata como **caminho legado a migrar** (verificação exige zero ocorrências). **Decisão do SM:** o caminho de calibração passa a **`.team-project/architect/calibration/<Task-ID>-<slug>.md`**, sem colisão, e o `team-update` **não é tocado**. Trocado em `artifact-ownership.md` §1/§1e, `sprint-run.md` (pré-condição 2), `deliverables/team-project/README.md`, `project-context.md` (árvore), README do Arquiteto e `implementation-plan.md:3` (só o nome do caminho); nas propostas `commands/arc.md`, `agents/architect.md` e `commands/dev.md`. As menções `architect/plans` nesta e nas entradas anteriores são **históricas** |
| `process/workflow-sdd.md` §5h | etapa 5 · portões | **Etapa 5 só começa depois do ② registrado (ou dispensado com motivo)**; a versão aprovada no `06-changelog` é do PO e vem **antes** das Histórias (achado do PO). Nova regra: **portões só se decidem dentro do `sdd`** — `/ux prototype` e `/arc` avulsos não abrem nem fecham ①/② (resolve a divergência UX × Arquiteto sobre "avulso → a sessão") |
| **PO** — `roles/product-owner/README.md` · `deliverables/sdd/README.md` | `/po analyze` · `/po requirement` · `/po story` (Esboço) · regras do SDD | Decisão formal do `analyze` habilita o `sdd` (caso B) e declara o que muda; `requirement` chamado pelo `sdd` (etapa 1a), delta nulo com motivo dispensa ①; `story` (etapa 5) registra a versão aprovada no `06-changelog` e atualiza o índice (R12) |
| **UX** — `roles/user-experience/README.md:47,:56` · `templates/functional-prototype.md:76,:100` | `/ux prototype` · registro do ① | Despachado pelo `sdd` (etapa 1c, depois de `02`; caso B só os fluxos afetados); ficha = registro único do ①, UX transcreve |
| **Arquiteto** — `roles/architect/README.md` · `templates/implementation-plan.md:3` | SDD técnico da fatia · indicador · `/arc plan` (calibração) | Caminho oficial é o `sdd` (etapa 3); modo livre só conversa avulsa; delta nulo com motivo dispensa ②; formulário do ② é do `sdd` |
| `proposals-v2/commands/sm.md` · `agents/scrum-master.md` | linha `sdd`, description, hint, pré-condições | **Proposta** (`commands/`, `agents/` são do stakeholder): `/sm` de carga fixa 13.455 B (`sm.md` 6.807 + agente 6.648), dentro de ≤13,5 KB |
| `process/process-changelog(-archive).md` | — | v3.33.1 arquivada (R17, três entradas mantidas); "Pendente" da parte 2 atualizado (propostas aplicadas em 29–30/09 na `feat/v3.34.0`, frontmatter dos 6 agentes igual ao HEAD, bump v3.34.0; **pendentes: reinício de sessão e remedição da tabela de custo**) |

### Por quê
O caminho do brief às Histórias era o único trecho do processo sem comando dono: cinco comandos de papel em sequência manual e dois portões cujo formulário dependia de lembrar qual sessão orquestrou qual comando (R22). Sem um dono, o `prepare` recebia "Histórias" de origem não verificável. O `/sm sdd` dá dono, estado (retomável) e portões próprios, e fecha a cadeia até o `prepare`.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| PO | escreve `00`/`01`/`02`/`06`/índice e depois as Histórias (esboço) **dentro do `sdd`**; declara o delta funcional no caso B (base para dispensar ①) |
| UX | jornadas e protótipo funcional despachados pelo `sdd`; o formulário do ① é do `sdd` (a decisão continua na ficha do protótipo) |
| Arquiteto | SDD técnico despachado pelo `sdd`; declara o delta técnico no caso B (base para dispensar ②); o formulário do ② é do `sdd` |
| SM | abre e mantém §"SDD em elaboração"; verifica ①②→Histórias e que `prepare` só recebe Histórias de SDD aprovado |

### Conflitos com o processo vigente
Nenhum com regra escrita. Ponto de atenção: **R15 diz que os portões não se negociam** — o "portão sem delta" (caso B) não abre exceção: só se dispensa o que **não mudou**, com o delta nulo declarado pelo dono e o motivo em `context.md`.

### Como saberemos que funcionou
Nos próximos dois ciclos de SDD: (a) zero `03`/`04`/`05` datado antes do registro do ① e zero História antes do ②; (b) todo `prepare` cita Histórias de SDD aprovado; (c) zero portão ①/② em texto corrido; (d) o número de comandos digitados entre o brainstorm e o `prepare` cai de ~8 para 1; (e) toda retomada de `sdd` entra na etapa correta (estado em `context.md`).

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição | grep `/po requirement <ID>\s+o brief` e a sequência `→ /po requirement → /ux prototype` em `.md` de RAIZ (exceto changelogs) | 0 restos da sequência manual fora de `workflow-sdd.md:7` (que a cita para dizer que foi substituída) | ✅ |
| Referência cruzada | ocorrências de `/sm sdd`\|`workflow-sdd` por arquivo | 14 arquivos, 64 ocorrências, cada uma lida no contexto (contagem/lista adjacente: tabela do `/sm` de `README.md`, `how-to.md`, `project-context.md` traz **11 modos**) | ✅ |
| Links | resolução de `](x.md)` em todos os `.md` (exceto `CHANGELOG.md` e o arquivo) | 0 quebrados novos (só o `how-to.md` do template e o texto literal `x.md` desta linha) | ✅ |
| Extração | bytes: `workflow.md` 39.053 → 40.506 · `workflow-ritos.md` 14.592 → 13.391 · `workflow-sdd.md` novo 7.424 · `working-rules.md` 71.630 → 72.145 | o `sdd` só é lido em `/sm sdd` | ✅ |
| Arquivamento | `Contains` do bloco v3.33.1 (98 linhas) no arquivo; entradas vivas | `True`; entradas: parte 3, parte 2, v3.34 (três) | ✅ |
| Carga fixa | `Length` de `proposals-v2/commands/sm.md` + `agents/scrum-master.md` | 6.807 + 6.648 = **13.455 B** (era 13.345; teto 13.500) | ✅ |
| Substituição (regressão) | `Select-String "architect/plans"` em `.md` de RAIZ e `proposals-v2/` (exceto changelogs e `team-update.md`) | 0 depois da troca para `architect/calibration`; sobram só `commands/arc.md:12`, `agents/architect.md:55` e `commands/dev.md:10` de RAIZ, que as propostas substituem; `team-update.md:76,:97` intacto | ✅ |
| Coerência das propostas | bytes e `diff` linha a linha RAIZ × `proposals-v2/` das 6 propostas dos papéis; ①/② e "avulso" | só linhas editadas, nenhuma removida sem contraparte (`po.md` 8/8, `arc.md` 3/3, `ux.md` 3/3, `agents/po` 8/9, `architect` 2/2, `user-experience` 1/1); ①/② são do `sdd` em `sm.md`, `arc.md:22`, `ux.md:31`; **1 divergência** ("avulso" decidia ① no UX e não decidia ② no Arquiteto) resolvida na §5h | ✅ |
| Carga fixa | `Length` agente + comando, aplicado → proposto | `/sm` 13.345 → 13.455 · `/po` 11.066 → 11.207 · `/arc` 8.563 → 8.497 · `/ux` 10.710 → 10.897 · `/dev` 6.113 → 6.119 · `/qa` 11.622 → 11.622; total 61.419 → 61.797 (era 95.021 antes da v3.34) | ✅ |
| Leitura | `consumption.md` §Como gravar (achado do UX) | existe (linha 39) | ✅ |
| Aplicação | conferência do orquestrador: frontmatter dos 4 agentes × HEAD; grep `architect/plans` e "sessão que orquestrou" em `commands/` e `agents/` | igual ao HEAD; 0 resíduos (1 ocorrência legítima em `qa.md:27`) | ✅ |
| Referência cruzada (how-to novo) | grep em RAIZ (exceto changelogs, `note.md`, `proximo.md`) de `how-to.md` + `§`, "quatro caminhos", "caminho [A-D]", "Os comandos"; cada ocorrência lida contra os headings do how-to novo | 7 ponteiros resolvem (`§"Referência dos comandos"` → how-to:154; `§"Instalar e manter atualizado"` → :226; "cenário A" → :42; "quatro portões" → :129); **1 resto** — `README.md:42` ("os 4 caminhos de entrada") — corrigido; "caminho C" em `workflow-sprint.md:149,:155` corrigido | ✅ |
| Desvio | parágrafo "Pendente" da entrada v3.34 apagado por engano no arquivamento da v3.33.1 | recomposto com ponteiro para a "parte 2" e nota; o texto original listava as 14 propostas, hoje na "parte 2" e no `CHANGELOG.md` v3.34.0 | ⚠️ registrado |

### Pendente do stakeholder
**Aplicado** em 29–30/09/2026 na `feat/v3.34.0`: as 9 propostas de `commands/` e `agents/` e os ajustes finais do PO e do UX (frontmatter dos agentes igual ao HEAD); o `how-to.md` novo foi feito a pedido direto do stakeholder e o `CHANGELOG.md` v3.34.0 já tem as linhas do `/sm sdd`, da calibração e do how-to. **Continuam pendentes:** o **reinício da sessão** (comportamento de agente só vale depois) e a **remedição da tabela de custo** (`workflow-processo.md` §5c; carga fixa atual: `/sm` 13.455 · `/po` 11.207 · `/arc` 8.497 · `/ux` 10.842 · `/dev` 6.119 · `/qa` 11.622 B).
