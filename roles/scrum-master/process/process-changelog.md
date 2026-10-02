# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v3.37 — R32: consultoria externa especializada pelo `/sm consulting` — técnica e de negócio, carta sanitizada, até 3 réplicas, validação do time antes do formulário (SM + PO + Arquiteto + QA + UX) — 02/10/2026

**Instrução** (stakeholder, proposta `proposta-consulting.md`, com as decisões D1–D10 já tomadas): "Decisões técnicas especializadas (banco de dados, segurança, design, arquitetura, infraestrutura) hoje saem só do conhecimento do próprio time, sem forma de buscar uma segunda opinião externa com rastreabilidade; e o ADR registra a decisão já tomada, sem apresentar ao stakeholder opções comparáveis para escolher. O mesmo vale para o lado funcional: quando o projeto entra numa área de negócio que o time não domina, o PO escreve requisitos e regras só com o que o stakeholder sabe dizer, sem apoio especializado nos processos daquela área."
**Classificação:** regra nova (R32) · etapa de fluxo (modo `/sm consulting`) · formato de documento (6 modelos) · propriedade de artefato (`consulting/`; `business-proposal.md` do PO) · comportamento de agente (`commands/sm.md`, aplicado pelo stakeholder).

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `process/working-rules.md` · `working-rules-index.md` | R32 · resumo · verificação binária · índice | Regra nova. Consultor sempre externo (humano ou IA), do registro do projeto; o stakeholder transporta; SM abre e conduz; papéis do domínio escrevem e validam; Arquiteto (técnico) ou PO (`business`) escrevem proposta e registro final; sanitização do QA por rodada (+ PO no `business`); teto de 3 réplicas; decisão em R22; **só fora do `sprint run`** (D8). Contagem 31 → 32 |
| `process/workflow.md` | §5 · §6 | Cerimônia "Consultoria externa"; linha de escalação "decisão especializada → `/sm consulting` (opcional, antes do stakeholder)" |
| `process/artifact-ownership.md` | §1 (ADRs · casos · requisitos) · §1c | Linha `consulting/` com dono por arquivo; ADR via `adr-proposal`; regra funcional via `business-proposal`; caso fora da pasta do sprint, como o spike |
| `roles/scrum-master/README.md` | novo §`/sm consulting` · documentos | Roteiro em 7 passos, tabela domínio × autores × validadores, checklist de sanitização e de consenso |
| `roles/scrum-master/templates/` | `consulting-case` · `service-letter` · `consultant-response` · `reply` (novos) · `project-context.md` | Modelos do caso; §7a "Registro de consultores" (lista livre de áreas, D10; critério de guarda do dado) com a lista de exemplo **comentada**; `consulting/` na estrutura; modo na §8 |
| `deliverables/team-project/README.md` | manifesto | `consulting/` não semeada, reconcilia os modelos; §7a do README como estrutura + conteúdo local |
| `roles/architect/` | `templates/adr-proposal.md` (novo) · `adr.md` (regra "Origem") · `skills.md` §7 · `README.md` | Proposta com 3 opções R22, recomendação do time × do consultor, parecer dos validadores; ADR resultante sem citar `consulting/` |
| `roles/product-owner/` | `templates/business-proposal.md` (novo) · `skills.md` §10 · `README.md` | Processo futuro em 3 opções, sem solução técnica (R20), destino no formato do §4 de `functional-analysis`; quando pedir, seção da carta, coassinatura, incorporação ao SDD |
| `roles/quality-assurance/skills.md` | §14 (novo) | Conferência de sanitização por rodada, com tabela |
| `roles/user-experience/skills.md` | §11 (novo) | Seção da carta (design; jornada atual no `business`) e validação quando a jornada muda |
| `commands/sm.md` · `how-to.md` · `README.md` · `agents/scrum-master.md` | modo · pré-condição · cenário G · contagem | Aplicados a pedido do stakeholder (texto pronto da proposta); "31 regras" → "32" |

### Por quê
A opinião externa já acontecia por fora — colada em conversa, sem dono, sem sanitização e sem opções comparáveis. A regra a torna **dado, não decisão**: ninguém do time responde por ela sem validar, nada sensível sai sem assinatura, o ciclo tem teto e o stakeholder escolhe entre 3 opções maduras. No `business`, dá ao PO apoio especializado sem trazer solução técnica para o requisito.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| SM | Abre e conduz casos; recusa `consulting` com sprint em `run`; cobra assinaturas, checklist e teto |
| Arquiteto | Escreve a carta técnica, valida, escreve `adr-proposal` e o ADR resultante |
| PO | Necessidade em toda carta; no `business`, *as-is*, coassinatura, `business-proposal` e incorporação ao SDD |
| QA | Assina a sanitização de toda rodada que sai; no `security`, escreve e valida |
| UX | Contexto de design; jornada atual no `business`; valida quando a jornada muda |
| Sessão que orquestra | Dispara só os papéis do domínio; formulário R22 no consenso ou no teto |

### Conflitos com o processo vigente
- **R25** (dois contatos por sprint): resolvido por **D8** — consulting só fora do `sprint run`; caso aberto fica suspenso até o `close`; decisão estratégica em voo segue R25(c).
- **R21 / SM não escreve ADR:** o SM só conduz; consenso é dos validadores; proposta e registro, do dono do destino.
- **R31:** ADR e SDD resultantes não citam `consulting/` — regra nos dois modelos de proposta e em `adr.md`.

### Como saberemos que funcionou
Nos 3 primeiros casos: consenso em ≤ 3 réplicas em todos · zero proposta sem parecer dos validadores · zero rodada sem assinatura de sanitização (e sem a do PO, no `business`) · decisão em formulário em 100%. No primeiro caso `business`: zero solução técnica no texto incorporado ao SDD. A Retrospective registra qual consultor rendeu mais por domínio (e por área). Carga fixa medida no `/review metrics` seguinte.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Contagem | `Select-String '^### R\d+\.'` em `working-rules.md` · `'^\| R\d+ '` em `working-rules-index.md` · `'^\| R\d+ \|'` no resumo | 32 · 32 · 32 | ✅ |
| Substituição de padrão | `Grep '31 regras\|R1.R31\|R30-R31'` fora dos changelogs | 0; as 4 ocorrências novas (`README.md:186`, `roles/scrum-master/README.md:154`, `working-rules-index.md:1`, `agents/scrum-master.md:34`) lidas no contexto — a lista de blocos do `README.md` passou a "método R13-R27 e R30-R32" | ✅ |
| Referência | `Select-String 'consulting'` nos 4 normativos, no manifesto e em `commands/sm.md` | `working-rules` 2 · índice 1 · `workflow` 2 · `artifact-ownership` 3 · manifesto 1 · `sm.md` 3 | ✅ |
| Órfão | arquivos `.md` que citam cada modelo novo (fora de propostas e changelogs) | `service-letter` 6 · `consultant-response` 5 · `reply` 6 · `consulting-case` 3 · `adr-proposal` 8 · `business-proposal` 7 — nenhum órfão | ✅ |
| Arquivamento | entrada v3.34 (parte 3) movida para o arquivo; `Contains` do texto de `HEAD` no arquivo | True (13.616 caracteres) | ✅ |
| Carga fixa | bytes (LF) de `commands/sm.md` · `agents/scrum-master.md`, `HEAD` → agora | 6.843 → 7.472 (+629) · 6.656 → 6.656 | ✅ |

### Pendente do stakeholder
Nada a aplicar — `commands/sm.md`, `how-to.md`, `README.md` e versão aplicados nesta entrega. Mudança de comando só vale **após reiniciar a sessão**. Primeiro uso real: preencher o §7a do `.team-project/README.md` (o `/team update` traz a estrutura).

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
