# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v3.33.1 — O papel chamador retrata o consumo do `operator`; o registro o soma em linhas por chamador (SM) — 29/09/2026

**Instrução** (stakeholder, `/review`, item de `note.md` "Consumo do `operator` não aparece no registro de consumo do sprint"): "que o uso do operator possa ser retratado pelo seu chamador, assim teríamos a economia nessa transferência de atividade".

**Classificação:** formato de documento (`consumption.md`, `retrospective.md`, `plugin-report.md`) + extensão de verificação de regra existente (R28) + comportamento de agente/relatório dos papéis chamadores (fora do alcance do SM, aplicado pelos donos). Sem regra nova. Rodada de **um papel aplicando na mão do SM** (os demais papéis aplicam a própria contraparte, ver abaixo) — barreira aplicável: 10 KB.

**Lacuna (confirmada):** o `operator` roda aninhado dentro do papel chamador; a sessão só recebe o total do papel e nunca vê o `operator`. O registro só tinha linha por invocação de papel, então o consumo delegado ou ficava invisível ou (se fosse dentro do número do papel) impossível de separar — e sem separar não há como saber se delegar economiza.

**Conflito levantado na triagem e decidido pelo stakeholder:** "Quem escreve" dizia que o papel nunca grava a própria linha; a instrução pede que o chamador retrate. **Posição B adotada:** o papel retrata, em seção própria do relatório; **a sessão** grava as linhas — um escritor só, o registro continua do SM. Totais: o `operator` **entra** no Total do sprint, em linhas próprias por chamador (`operator ← arc`, `operator ← qa`…), cada uma com o modelo do `operator` (o `model:` de `agents/operator.md`, "configurado, não servido"). Sem piso nem teto.

### O que mudou

| Documento | Seção | Mudança |
|---|---|---|
| `templates/consumption.md` | cabeçalho, "o que mede", registro, totais, regras | Papel aceita `operator`; linha-modelo com Nota `chamado por <papel>; job <caminho>`; Totais com `operator ← <chamador>` e Total do sprint (papéis + `operator`); "Quem escreve" cobre o `operator` (papel retrata em "Execução delegada", sessão grava na mesma passada); premissa de não-duplicidade como ressalva (R7) |
| `templates/retrospective.md` | "Consumo real do sprint" | Linhas `operator ← <chamador>` e Total; bullet "Delegação ao `operator`" (chamador × `operator` por Task/História, com modelos, candidato a investigar); bullet de contagem R28; premissa |
| `templates/plugin-report.md` | seção 1 | Mesmas linhas por chamador e bullet de delegação (Tasks anônimas, sem afirmar economia absoluta) |
| `workflow.md` | §5c; registro de consumo; retro como análise; "Como o SM verifica" | O consumo real inclui o `operator` retratado; quem escreve; contagem jobs × linhas |
| `working-rules.md` | R28 ("SM verifica") | Estendida com a verificação por contagem — `.team-project/operator/<sprint>/` × linhas `operator`; relatório de papel que delegou sem "Execução delegada" é achado contra o chamador. Sem regra nova |
| `artifact-ownership.md` | §1, linha de consumo | Toda chamada ao `operator` vira linha |
| `roles/scrum-master/README.md`, `how-to.md`, `deliverables/team-project/README.md` | ponteiros | Coerência de referência cruzada (exceção de curadoria) |

### Por quê

Sem o consumo do `operator` no registro, o total do sprint subestimava o time e a pergunta que motivou R28 — delegar a execução pesada ao modelo barato **economiza**? — ficava sem número. Com a linha por chamador, a retro compara, por Task, o custo do papel e o do `operator` que ele chamou, com o modelo de cada um. **Ressalva honesta:** isso compara custos, não mede a economia absoluta (falta o cenário sem delegação); por isso é "candidato a investigar".

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda |
|---|---|
| **Arquiteto · QA · Dev · UX** (chamadores) | Retratam cada chamada ao `operator` na seção **"Execução delegada"** do relatório final: Operator job · Task/História · Modelo · Tokens · Duração (ou "não disponível — motivo"). Aplicação em `roles/<papel>/`, feita pelos donos |
| **Quem orquestra** | Grava as linhas `operator` na mesma passada da linha do papel (instrução em `commands/`, proposta ao stakeholder) |
| **SM** | Confere a contagem de jobs × linhas `operator`; lê a delegação na retro e no relatório |

### Conflitos com o processo vigente

Um, resolvido (acima): "quem escreve". R7 mantida (sem número → "não disponível — motivo"). R28 intacta — só ganha a verificação. **Premissa a validar:** o número que o papel devolve não inclui o do `operator` aninhado. Se uma medição mostrar soma dupla, volta ao `/review`.

### Como saberemos que funcionou

No primeiro sprint fechado após a atualização: nº de linhas `operator` no `consumption.md` = nº de chamadas em `.team-project/operator/<sprint>/` (pasta de job, mais um por log adicional na mesma pasta); a retro traz a tabela de delegação preenchida ou "nenhuma delegação". Sinal de falha: jobs sem linha, ou relatório de papel que delegou sem "Execução delegada".

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento | `.Contains()` do bloco `## v3.31` (salvo antes de mover) no `process-changelog-archive.md` | `True` — íntegro; índice ganhou a linha `v3.31` | ✅ |
| Coerência de índice | regex `^## v3\.[0-9.]+ ` em `process-changelog.md` | 3 entradas (v3.33.1, v3.33, v3.32) | ✅ |
| Substituição de padrão | `Select-String "Execução delegada"` em `process/`, `templates/`, README do SM (fora changelogs) | `artifact-ownership.md:33` · `workflow.md:378` · `working-rules.md:58` · `consumption.md` ×3 · `retrospective.md:51` · `README.md:134` — cada uma lida no contexto; nome idêntico ao dos relatórios dos papéis | ✅ |
| Substituição de padrão | `Select-String "operator ←"` em `templates/` | `consumption.md`, `retrospective.md`, `plugin-report.md`, uma linha de totais cada; Total do sprint dos três diz "papéis + `operator`" | ✅ |
| Coerência (leitura) | "Quem escreve" × "nunca é ele quem grava" em `consumption.md` | a frase antiga permanece verdadeira (o papel não grava a própria linha) e a exceção "vale também para o `operator`" vem logo após: papel retrata, sessão grava | ✅ |
| Contagem | `^### R\d+\.` em `working-rules.md` | 30 — sem regra nova | ✅ |
| Teto de entrada (R17) | bloco `## v3.33.1`, UTF-8 | 9.098 B após a curadoria (rodada de SM + Arquiteto + QA + UX; barreira 17,5 KB), sob a barreira | ✅ |
| Coerência (leitura) | regra única da célula "Operator job" lida em `consumption.md:48`, `working-rules.md:58`, `workflow.md:392`, `retrospective.md:52` × células de `delivery-report.md`, `verdict.md`, `evidence.md`, `functional-prototype.md`, `sprint-prototype.md`, `architect/skills.md` | contagem de R28 agora em chamadas nos 4 normativos/modelos do SM; formatos dos papéis compatíveis | ✅ |

### Pendente do stakeholder

Nenhum. Bump R18 aplicado pela sessão principal com autorização do stakeholder em 29/09/2026: `plugin.json` `3.33.1`, banner do `README.md` e entrada `v3.33.1` no `CHANGELOG.md`; `commands/` e `agents/` também aplicados (ver "Aplicação dos papéis"). Mudança em `agents/`/`commands/` só vale após reiniciar a sessão.

### Aplicação dos papéis e curadoria (29/09/2026)

| Papel | Documentos | Retrato |
|---|---|---|
| **QA** | `skills.md` §2 ("Retrato da chamada"), `README.md` passo 3, `templates/verdict.md`, `templates/evidence.md` | seção "Execução delegada" (5 colunas) no veredito e na evidência |
| **UX** | `skills.md` §10 (retrato + "Como se verifica"), `templates/functional-prototype.md`, `templates/sprint-prototype.md`, `README.md` | seção na ficha do protótipo |
| **Arquiteto** (e Dev, aplicado por ele) | `roles/architect/skills.md` §14 ("Retrato da delegação", na resposta, não no plano/ADR), `README.md` item 4; `roles/developer/templates/delivery-report.md`, `skills.md` §6, `README.md` passo 6 | seção no relatório do dev; build de fim de passo rodado pelo próprio dev **não** entra |
| **Sessão / stakeholder** | `commands/{arc,qa,ux,dev,team}.md`, `agents/{architect,quality-assurance,developer,user-experience,operator}.md`, `plugin.json` 3.33.1 | grava as linhas `operator`; papel só retrata; `operator` não relata o próprio consumo |

**Divergência resolvida (curadoria):** o Dev traz na célula "Operator job" caminho + log (`.team-project/operator/3/ABC-02/ — test.log`), porque no dev `<job>` = `<T-ID>` e duas chamadas da mesma Task caem na mesma pasta; QA e UX trazem só o caminho. **Regra única**, agora em `consumption.md` ("Identificação da chamada"): célula = caminho do job, acrescido de `— <log>` quando houver mais de uma chamada na mesma pasta. Os três formatos são compatíveis com ela; nenhum roteiro de papel precisou ser reescrito. Consequência: a contagem de R28 passa a ser de **chamadas**, não de pastas (ajustada em `working-rules.md`, `workflow.md`, `retrospective.md`, `consumption.md` e neste "Como saberemos").

**Ponto devolvido ao UX (roteiro do outro papel):** `templates/sprint-prototype.md`:94 já usava "Execução delegada" como **rótulo de regra** ("Execução delegada, veredito meu (R28)"), agora também nome da seção de retrato — ambiguidade de leitura na mesma ficha. O nome da seção fica fixo porque o SM e os demais papéis o citam. **Resolvido pelo UX:** rótulo da regra renomeado para "Delegação da verificação, veredito meu (R28)"; o rótulo antigo só existia ali, e `grep "Execução delegada"` em `roles/user-experience/` devolve só a seção de retrato (5 ocorrências em 4 arquivos).

### Reavaliação e ajustes finais (29/09/2026)

Uma reavaliação (`/review` vazio) achou três pontos; o stakeholder mandou resolver os três, ainda dentro da v3.33.1.

| # | Achado | Resolução | Dono |
|---|---|---|---|
| 1 | Jobs de `operator/pre-sprint/` (Arquiteto e UX antes do sprint 1) nunca entravam no registro: `consumption.md` só nasce no `/sm sprint plan` e a contagem de R28 só olhava `operator/<sprint>/` | Ao criar o **primeiro** `consumption.md`, o SM lança uma linha `operator` por job de `pre-sprint/`, **transcrita** da "Execução delegada" do chamador (Nota `pre-sprint;`); contagem de R28 = `<sprint>/` + `pre-sprint/` ainda não contado; cada job é contado uma vez; invocações de papel anteriores não são reconstruídas (R7). Em `working-rules.md` R28, `workflow.md:392`, `consumption.md`, `retrospective.md:52`; `commands/sm.md` (sprint plan) aplicado pela sessão principal | SM |
| 2 | `evidence.md`: seções do bloco-modelo sem cabeçalho, desalinhadas a `verdict.md` | Cinco seções viraram `###`. Só apresentação | QA |
| 3 | "Execução delegada" do Arquiteto vivia só no texto da resposta, sem modelo verificável; o checkpoint de spike não tinha modelo | Seção 11 nova + regra 14 em `implementation-plan.md`; modelo **novo** `roles/architect/templates/spike-checkpoint.md`; `skills.md` §12/§14 e `README.md` apontam para eles; **não há terceira casa** (execução fora de plano é spike). A resposta repete as linhas para a sessão transcrever. `agents/architect.md` aplicado pela sessão principal | Arquiteto |

**Ajustes de coerência (SM):** `working-rules.md` R28 — o registro conferido é a seção do relatório (QA, UX, Dev) **ou** a seção 11 do plano/do checkpoint de spike (Arquiteto); `artifact-ownership.md` §1, linha de checkpoints, cita o modelo novo; `consumption.md` e R28 dizem de onde o SM transcreve o job do Arquiteto; ponteiros do modelo novo em `README.md` (estrutura de templates), `deliverables/team-project/README.md` e `project-context.md` (exceção de curadoria).

**Verificado sem contradição:** seção 11 do plano × frente 2 do QA (a regra 14 declara que a frente 2 não a confere — não é passo; a tabela passo × conforme e a regra 13 seguem intactas); `consumption.md` × `commands/sm.md` × R28 (mesma sequência: primeiro registro, uma linha por job, transcrita, `pre-sprint;`).

| Quem | Passa a ser cobrado |
|---|---|
| **SM** | Ingere os jobs `pre-sprint/` na Planning que cria o primeiro registro; sem a seção do chamador, "não disponível — motivo" e achado contra o chamador |
| **Arquiteto** | Registra cada chamada ao `operator` **no artefato** (seção 11 do plano ou checkpoint de spike) e repete na resposta; job sem linha é achado |
| **QA** | Nada novo (só apresentação de `evidence.md`) |

**Resolvido pelo Arquiteto:** `roles/architect/skills.md` §14 (linhas 179, 200, 207) e `templates/implementation-plan.md:33` passam a `<sprint|pre-sprint>`, como QA e UX; ficam com `<sprint>` só o exemplo preenchido do plano (156, 188) e os do Dev, cujo job é sempre de Task dentro do sprint. Aplicado também em `commands/sm.md` (sprint plan): a origem da transcrição do Arquiteto é a seção 11 do plano ou o checkpoint de spike.

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | `Select-String "operator/pre-sprint"` em `process/`, `templates/`, `commands/sm.md`, lido em contexto | `working-rules.md` R28, `workflow.md:392`, `consumption.md` ×2, `retrospective.md:52`, `sm.md:17` — mesma regra (soma `<sprint>/` + `pre-sprint/` ainda não contado; uma vez) | ✅ |
| Substituição de padrão | `Select-String "spike-checkpoint"` em `*.md` fora de changelogs | `artifact-ownership.md:18`, `architect/README.md`, `architect/skills.md`, `README.md`, `deliverables/team-project/README.md`, `project-context.md`; alvos resolvem | ✅ |
| Cobertura de modelos | `Test-Path roles\architect\templates\spike-checkpoint.md` · leitura de `implementation-plan.md` seção 11 e regra 14 | `True`; seção 11 presente, regra 14 exclui a frente 2 do QA | ✅ |

---
## v3.33 — Retrospectiva analisa consumo por papel e por modelo, procura ineficiência e gera o relatório ao dono do plugin (SM) — 29/09/2026

**Instrução** (`note.md`, `/review note`, item único): usar a retrospectiva para melhorar o processo analisando o uso de tokens de cada papel durante o sprint e os modelos usados em cada um, em busca de ineficiência por processo repetitivo, gap, bloqueio, falha e uso excessivo de tokens, **por meio de um relatório enviado ao dono do plugin**, para que o modelo possa ser melhorado.

**Classificação:** cerimônia (retrospectiva) + formato de documento (`consumption.md`, `retrospective.md`) + propriedade de artefato nova (`plugin-report.md`, SM). Sem regra nova: nenhuma obrigação de papel muda, só o conteúdo de uma cerimônia do SM e um artefato dele. Rodada de **um papel** (SM) — barreira aplicável: 10 KB.

**Levantamento das lacunas (confirmado contra os arquivos, não presumido):**

| Lacuna | Veredito | Evidência |
|---|---|---|
| (a) modelo por papel/invocação não é registrado | **real** | `consumption.md` só tinha Tokens e Duração; `retrospective.md` idem |
| (b) a retro não analisa ineficiência | **real** | a seção de consumo só somava por papel e comparava com o sprint anterior; "Divergência contra a carga fixa" era a única leitura |
| (c) sem relatório formal ao dono do plugin | **real, em parte** | havia a tabela "Sintomas para o `note.md`", que o stakeholder "decide se leva" — sem consumo, sem modelo, sem ineficiência e **sem regra contra vazamento de contexto do projeto** |
| tokens de cada papel por sprint; retro lê o registro; PDCA (§5c) | **já existia** | não duplicado |

**Observabilidade do modelo (o que se pode afirmar):** a notificação de fim de subagente devolve tokens (um total) e duração — **não o modelo**. O que a sessão que orquestra vê é o agente que disparou e o `model:` do cartão `agents/<papel>.md` (hoje: Opus no Arquiteto, Sonnet em SM/PO/QA/UX, Haiku em dev/`operator`) ou um override que ela passou. O registro grava **o modelo configurado, não o servido**; sem leitura do cartão nem override, "não disponível — motivo". Divisão entrada/saída/cache não é observável e a análise não a presume.

### O que mudou

| Documento | Seção | Mudança |
|---|---|---|
| `templates/consumption.md` | tabela de registro, totais, regras | Coluna **Modelo** por invocação e nos totais; regra "modelo é o configurado, não o servido" (com a régua "não disponível — motivo" e a nota de que tokens são um total) |
| `templates/retrospective.md` | "Consumo real do sprint" | Coluna Modelo; nova tabela de **ineficiência** com cinco verificações mensuráveis sobre o registro — papel repetido na mesma Task/História (alerta a partir de 3), Task/História cara (> 2× a média), papel desproporcional (contra a carga fixa), modelo × trabalho, consumo × falha (cruza com reprovação, reabertura, GAP, bloqueio); regra "aponta onde olhar, não o que cortar" |
| `templates/retrospective.md` | "Sintomas para o `note.md`" → "Relatório ao dono do plugin" | A tabela de sintomas **sai daqui** e vai para o novo arquivo; a retro guarda o ponteiro e duas linhas de encerramento (gerado? relido contra vazamento? encaminhado?) |
| `templates/plugin-report.md` | **novo** | Relatório em 5 seções — consumo por papel × modelo, ineficiências, bloqueios/falhas de processo (com o degrau de R25), sintomas, encaminhamento —, com **lista do que não entra** (nome, cliente, domínio, código, caminho, ID de Task/História — "Task A") e o fluxo: SM escreve, **stakeholder lê e encaminha**, `/review` no clone-fonte transforma em mudança |
| `workflow.md` | §5c (parágrafo novo); "Como o SM verifica"; fechamento de `sprints/<n>/` | A retro como análise de consumo e origem do relatório; +1 linha de verificação (modelo por linha, leitura de ineficiência, relatório sem contexto); `plugin-report.md` entra na lista da pasta completa |
| `artifact-ownership.md` | linha de consumo (§1); árvore e tabela §1e | `plugin-report.md`: dono SM, sai do projeto pela mão do stakeholder; consumo cita o modelo |
| `README.md` do SM; `templates/project-context.md`; `how-to.md`; `team-init.md`; `README.md` (raiz); `deliverables/team-project/README.md` | árvores e índices de `sprints/<n>/` | Coerência de referência cruzada: `plugin-report.md` listado onde a pasta é descrita (exceção de curadoria, sem mudança de comportamento) |

### Por quê

O consumo era **medido e ninguém o interpretava**: a retro somava tokens por papel e parava, sem dizer se um papel foi chamado três vezes para a mesma Task, se uma Task custou o triplo das outras ou se o trabalho mecânico caiu no modelo caro — e sem o modelo registrado, "Arquiteto custa mais que o SM" não distinguia preço de modelo de volume de trabalho (§5c já avisa que o modelo pesa mais que os KB). E o caminho de volta ao dono do plugin era uma tabela solta que o stakeholder teria de recortar à mão da retrospectiva — que carrega contexto do projeto —, sem barreira de vazamento. Um arquivo próprio, sem contexto, com fluxo declarado, dá ao `/review` evidência numérica em vez de impressão.

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda |
|---|---|
| **SM** | Na retro, lê o registro por ineficiência e escreve `plugin-report.md` sem contexto de projeto; verifica que cada linha de consumo traz o modelo |
| **Quem orquestra** | Grava o modelo em cada linha (instrução nos sete comandos de papel, aplicada em 29/09/2026) |
| **Stakeholder** | Lê o relatório antes de encaminhar — é a barreira final contra vazamento — e decide o que vai ao `note.md` |

### Conflitos com o processo vigente

Nenhum. Confrontado com: R7 (número sem fonte → regra "n/a"/"não disponível", sem estimativa); R25/§5f (pasta fecha por último — o relatório é escrito antes do fechamento, entra na lista); "o projeto não edita o plugin" (mantido: só relata, o stakeholder encaminha, o `/review` decide); `/review` nunca grava consumo (inalterado); ação única da retro (mantida, o relatório não a substitui). Efeito colateral: projeto com `consumption.md` de versão anterior tem linhas sem a coluna Modelo — `/team update` mostra o delta de estrutura e pede aprovação; linhas antigas ficam sem o valor.

### Como saberemos que funcionou

No primeiro sprint fechado após a atualização do projeto para `v3.33.0`: (1) toda linha de `consumption.md` traz modelo ou "não disponível — motivo"; (2) `retrospective.md` tem a tabela de ineficiência preenchida (ou "nenhuma", cada uma sustentada por linha do registro); (3) `plugin-report.md` existe na pasta fechada e uma leitura por `Select-String` dos nomes de projeto/cliente devolve zero. Sinal de falha: relatório com ID real de Task ou nome de domínio.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | `Select-String -Pattern "Sintomas para o .note.md. do plugin"` em toda a RAIZ, exceto changelogs | 1 ocorrência, o título da seção 4 do **novo** `plugin-report.md` (intencional: é o mesmo formato de sintoma). Era 1 no `retrospective.md` e 1 no `README.md` do SM — ambos reescritos, cada trecho novo lido ao lado do ponteiro para `plugin-report.md` | ✅ |
| Substituição de padrão | `Select-String -Pattern "plugin-report" -Path` em todos os arquivos que listam a pasta `sprints/<n>/` (workflow, artifact-ownership, README do SM, project-context, how-to, team-init, README raiz, deliverables/team-project) | ocorrência em cada um; a lista de `workflow.md` (2 pontos) e a árvore de `artifact-ownership.md` conferem entre si | ✅ |
| Extração/adição | `Select-String -Path templates/plugin-report.md -Pattern "^## "` e `Test-Path` | 5 seções numeradas + Regras; arquivo existe | ✅ |
| Arquivamento | `Compare-Object` do bloco `## v3.30` (texto salvo antes de mover) contra o mesmo trecho no arquivo | 0 diferenças; índice de arquivadas com a linha `v3.30` | ✅ |
| Coerência de índice | `## v3.` em `process-changelog.md` | 3 entradas (v3.33, v3.32, v3.31) | ✅ |
| Teto de entrada (R17) | bloco `## v3.33`, `[IO.File]::ReadAllText` UTF-8 explícito; um papel → barreira 10 KB | ver "Teto" abaixo | ✅ |
| Substituição de padrão (aplicação 29/09/2026) | `grep "modelo (o \`model:\`" commands/` · `grep plugin-report commands/sm.md` | 7 ocorrências (`sm`, `po`, `arc`, `ux`, `qa`, `dev`, `team`), cada uma apontando o cartão existente em `agents/`; 1 em `sprint close` | ✅ |

### Aplicado a pedido do stakeholder (29/09/2026)

As propostas de `commands/` foram aprovadas e aplicadas: as sete instruções de gravação de consumo passam a gravar o **modelo** (o `model:` do cartão em `agents/`, ou o override; sem leitura, "não disponível — motivo"), e `/sm sprint close` passa a gerar `plugin-report.md`. Bump R18: `plugin.json` `3.33.0`, banner do `README.md` e entrada `v3.33.0` no `CHANGELOG.md`. Mudança em `commands/` só vale após reiniciar a sessão.

**Teto (R17):** bloco `## v3.33`, `[IO.File]::ReadAllText` UTF-8, medido em 29/09/2026 — **9.137 B**, sob a barreira de 10 KB (1 papel).

---
## v3.32 — R30: QA mapeia cenário de teste funcional/regressivo na Planning e o executa no veredito; GAP não-bloqueante ganha caminho explícito ao Product Backlog (SM) — 23/09/2026

**Instrução** (`note.md`, triagem `/review note`, três itens fechados numa decisão do stakeholder via `AskUserQuestion`): **(1)** QA lê Histórias aprovadas + protótipo funcional e monta cenários de teste funcionais do sprint, também regressivos pelo impacto da Task; **(2)** isso ocorre a cada sprint — mapeado na Planning por Task, executado na entrega do dev, mesmo conceito de "Histórias aprovadas para o sprint" aplicado aos cenários; **(3)** erros/gaps de cenário entram no Backlog para o próximo sprint. Decisão do stakeholder sobre o conflito de R25 §5e: **GAP que bloqueia História em voo continua virando Task no sprint corrente** (R25 intacto); só o que **não bloqueia** vai ao Product Backlog — e o stakeholder pediu para fechar a lacuna preexistente de **quem** escreve essa linha. Decisão sobre onde a suíte vive: **avaliar aderência** de "ficar na área da QA e ser referenciada como Task no Sprint Backlog" contra `artifact-ownership.md` §1/§1c/§1e — aderente, aplicado como tal.

**Classificação:** etapa de fluxo + propriedade de artefato nova (regra de trabalho, R30) + formato de documento (roteiro/skills/templates do QA e do PO, aplicando a própria contraparte da regra). **Rodada de três papéis aplicando na própria mão** (SM em `working-rules.md`/`workflow.md`/`artifact-ownership.md`; QA em `roles/quality-assurance/`; PO em `roles/product-owner/`) — as três aplicações datam do mesmo `/review` de 23/09/2026 e compõem uma entrada só (R17, precedente v3.25/v3.31: a unidade é a decisão, não o papel). Barreira aplicável: **12,5 KB** (10 KB + 2,5 KB pelo terceiro papel).

### O que mudou

| Documento | Seção | Mudança |
|---|---|---|
| `working-rules.md` | Bloco C, após R27 | **R30 nova**: QA mapeia cenários (novos + regressivos) por Task na Planning, a partir do critério de aceite do PO e do protótipo funcional; opera o critério, não o reescreve (dúvida escala ao PO por R9/§6b, sem redeclarar); execução pesada segue R28; GAP de cenário bloqueante vira Task no sprint corrente (R25 intacto), não-bloqueante ganha par no Product Backlog escrito pelo PO — mecânica que fecha a lacuna geral de todo GAP não-bloqueante de `pending.md`, não só o de cenário |
| `workflow.md` | §1 (Task); §2a etapas 3/7; §3b DoR; §4a-i DoD; §5e passo 4 e "Durante o sprint"; §8 gates | Task ganha campo "cenários mapeados (IDs)"; etapa 7 e o veredito cobrem o resultado; DoR/DoD exigem cenário mapeado/executado; "Durante o sprint" ganha `pending.md` (QA) → PO → Product Backlog; +2 linhas de gate |
| `artifact-ownership.md` | matriz §1; §1c; §1e; §4 | Nova linha **Suíte de cenários** (`.team-project/quality-assurance/scenarios/`, dono QA, fora da pasta, acumulada); Tasks/Product Backlog/GAPs atualizadas; §1c/§1e (quatro artefatos fora da pasta) e §4 (`SC-nnn`) incluem a suíte |

### Por quê

Sem cenário mapeado antes da construção, a verificação funcional era reinventada a cada Task, sem memória do que já tinha sido coberto — uma Task quebrava um fluxo que já funcionava e isso só aparecia na Review ou em produção. E, sem o passo mecânico `pending.md` → PO → Product Backlog, um GAP confirmado pela QA fora da Sprint Review ficava preso no registro da QA sem nunca concorrer no próximo sprint, apesar de `workflow.md` §5e já dizer que deveria — lacuna preexistente, exposta por este item, não criada por ele.

**Avaliação de aderência do local da suíte** (pedido do stakeholder): **aderente** manter a suíte na área da QA, fora de `sprints/<n>/`, com o Sprint Backlog carregando só a referência (lista de IDs) por Task — critério e racional completos ficam em `artifact-ownership.md` §1c/§1e (norma que governa o assunto), esta entrada só referencia. Nenhuma parte do pedido foi considerada não aderente.

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda para ele |
|---|---|
| **QA** | Mapeia cenários (novos + regressivos) por Task na Planning, além de já contribuir na quebra (§5e passo 4); executa e registra o resultado no veredito; aponta GAP não-bloqueante para o PO com o ID de `pending.md`. Contraparte de roteiro/skills/templates aplicada nesta mesma entrada — ver "Aplicação do QA", abaixo |
| **PO** | Ganha a obrigação explícita de abrir a linha do Product Backlog para todo GAP não-bloqueante que a QA registrar em `pending.md`, citando o ID, no mesmo ciclo da confirmação (R12) — antes implícito em `workflow.md` §5e, agora mecânico. Contraparte de roteiro/skills/templates aplicada nesta mesma entrada — ver "Aplicação do PO", abaixo |
| **SM** | Verifica o campo de cenários no Sprint Backlog (DoR/DoD), a dupla cobertura do veredito e o par GAP↔Product Backlog nas duas pontas |

### Conflitos com o processo vigente

Um só, já resolvido pelo stakeholder (registrado em B(i) da triagem): item 5 do `note.md`, lido ao pé da letra, mandaria **todo** erro/GAP de cenário para o próximo sprint — contradizendo a exceção de R25 §5e ("GAP que bloqueia uma História já no sprint vira Task da mesma História", imediato, não represado). **Resolução:** a exceção de R25 fica intacta; R30 só formaliza o caminho do que **não** bloqueia. Registrado como parte da própria regra nova (R30, working-rules.md), não como pendência aberta.

### Como saberemos que funcionou

No próximo sprint que rodar `/sm sprint plan`, toda Task do Sprint Backlog cita cenários mapeados (ou "nenhum aplicável" com motivo) antes de entrar em construção, e nenhum veredito de `/qa <Task>` fecha sem o resultado deles. Em `pending.md`, todo GAP não-bloqueante registrado a partir desta versão tem par datado no Product Backlog dentro do mesmo sprint em que foi confirmado — GAP sem par depois de uma Planning inteira é o sinal de que a mecânica não pegou.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Extração/adição de regra nova | `Select-String -Path working-rules.md -Pattern "^### R30"` | 1 ocorrência, "### R30. Cenário de teste funcional e regressivo é mapeado na Planning e executado no veredito do QA" | ✅ |
| Substituição de padrão | `Select-String -Path artifact-ownership.md -Pattern "Três artefatos ficam fora"` | 0 ocorrências (era 1) — substituído por "Quatro artefatos ficam fora..." com a suíte de cenários incluída e lida no contexto | ✅ |
| Substituição de padrão | `Select-String -Path workflow.md,working-rules.md,artifact-ownership.md -Pattern "R30"` | `workflow.md`: 9 · `working-rules.md`: 1 · `artifact-ownership.md`: 6 — total 16, cada ocorrência lida no contexto de inserção | ✅ |
| Extração/remoção | Contagem de linhas do bloco "Como o SM verifica" (§5e) e da tabela de gates (§8) antes/depois | "Como o SM verifica": 9 → 10 linhas (+1, a de R30); gates: 20 → 22 linhas (+2, construção e veredito) | ✅ |
| Substituição de padrão (aplicação 25/09/2026) | `grep mcp__claude-in-chrome agents/{operator,quality-assurance}.md` · `grep "scenarios (create\|run)" commands/qa.md` · `git diff --stat -- agents/ commands/` | ferramenta nos 2 cards; hint + 2 modos em `commands/qa.md`; `git diff --stat`: 3 arquivos, 8 inserções / 3 remoções — cada trecho lido, coerente com o roteiro do QA (R30) | ✅ |

*(Tamanho da entrada consolidada e pendente do stakeholder: no fecho, depois das aplicações do QA e do PO — uma lista e uma medição só.)*

### Aplicação do QA (`/review`, 23/09/2026) — `roles/quality-assurance/`

| Documento | Mudança |
|---|---|
| `README.md` | Suíte nas Entradas/Saídas/Escreve; seção de mapeamento/execução; "Planning Meeting" no roteiro; `/qa <ID>` passo 4/6 |
| `skills.md` | Skill 13 nova — critério de aceite → cenário, sem reescrevê-lo |
| `templates/verdict.md` | Seção de cenários, roteamento por bloqueio |
| `templates/evidence.md` | Mesma tabela de cenários do veredito |
| `templates/cross-audit.md` | Passe 1 ganha checagem de cenário |
| `templates/scenario.md` (novo) | Modelo `SC-nnn` |
| `templates/scenarios-index.md` (novo) | Modelo do índice |

**Evidência (R19):** `R30` em 7 arquivos do QA, 15 ocorrências (README:3 · skills:3 · verdict:3 · evidence:1 · cross-audit:1 · scenario:2 · scenarios-index:2) — conferido por `grep`, cada ocorrência lida no contexto. `git diff --stat -- roles/quality-assurance/`: 5 arquivos, 82 inserções / 7 remoções, + 2 arquivos novos — conferido.

**Dois achados devolvidos ao SM** (fora do alcance do QA) — tratados em "Curadoria do SM", abaixo.

### Aplicação do PO (`/review`, 23/09/2026) — `roles/product-owner/`

| Documento | Mudança |
|---|---|
| `README.md` | Seção nova — GAP não-bloqueante da QA vira linha no Product Backlog; `/po bug` passo 5 unificado ao mesmo caminho |
| `skills.md` | Skill 3/8 apontam a mesma fonte, sem duplicar |
| `templates/product-backlog.md` | Seção "GAPs não-bloqueantes (origem `pending.md`, QA)" |
| `templates/user-story.md` | Nota: Critérios de aceite é a fonte que a QA opera, sem reescrevê-la |

**Por quê:** `/po bug` (passo 5) e a skill 8 descreviam o mesmo destino em prosa divergente — unificados nesta entrada.

**Evidência (R19):** `R30` em 4 arquivos do PO, 11 ocorrências (README:5 · skills:2 · product-backlog:3 · user-story:1) — conferido por `grep`, cada ocorrência lida no contexto. `git diff --stat -- roles/product-owner/`: 4 arquivos, 22 inserções / 4 remoções — conferido.

### Curadoria do SM — dois achados do QA aplicados, e referência cruzada da rodada

O QA devolveu dois achados fora do alcance dele — nenhum é comportamento, os dois são coerência de referência cruzada já coberta pela exceção de `review-contract.md` §Limites, aplicados direto:

- **`sprint-backlog.md`** (SM): ganha a coluna **Cenários** (ponteiro, nunca cópia) — faltava para a referência que R30 já exige (DoR/DoD).
- **`deliverables/README.md`** (SM): linha nova para a Suíte de Cenários em "Conjuntos".
- **`deliverables/team-project/README.md`** (achado da própria curadoria): manifesto e "O que fica FORA da pasta" passam a citar `scenarios/`, já nomeada em `artifact-ownership.md` §1e.

**Contradição entre os dois papéis (QA × PO):** nenhuma — caminho da suíte, par modelo×arquivo e "quem escreve o quê" conferidos lado a lado, mesma fronteira, sem sobreposição nem lacuna.

**Evidência (R19):** as três edições acima (`sprint-backlog.md`, `deliverables/README.md`, `deliverables/team-project/README.md`) lidas depois de aplicadas — coluna nova resolve no exemplo; linha nova resolve nos dois links; a frase "O que fica FORA" cita os quatro artefatos, mesma contagem de `artifact-ownership.md` §1e.

### Pendente do stakeholder (consolidado — SM + QA + PO, uma lista só)

**Aprovado e aplicado pelo stakeholder em 25/09/2026** (sessão principal, em nome dele), com o texto abaixo — os dois itens saem de `note.md` (Abertas), que volta a ficar vazia:

| Arquivo | Mudança |
|---|---|
| `agents/operator.md` | `tools:` ganha `mcp__claude-in-chrome`; item **8** do contrato — cenário de navegador em lote (R30) roda por Claude in Chrome, uma linha por cenário no relatório; sem extensão, `inconclusivo — sem ferramenta` |
| `agents/quality-assurance.md` | `tools:` ganha `mcp__claude-in-chrome`; parágrafo novo — cenário isolado roda no próprio QA, grupo/suíte inteira vai ao `operator` (R28); sem extensão conectada na sessão, ⚠️ **não executado — sem ferramenta** |
| `commands/qa.md` | `argument-hint` e corpo ganham `scenarios create` (povoa a suíte a partir do SDD + protótipo) e `scenarios run <SC-nnn\|grupo\|all>` (isolado no QA; grupo/`all` no `operator`), roteando GAP por R30 |
| `roles/quality-assurance/{README.md,templates/scenario.md,templates/scenarios-index.md}` (QA) | "sem ferramenta no card" → "extensão não conectada na sessão"; Roteiro por modo aponta os dois modos novos. Evidência: `Select-String "ferramenta.{0,40}(não existe\|não tem\|não carrego\|fora do meu alcance)"` → 0 (era 4) |

**Condição inalterada, causa diferente:** o card tem a ferramenta; sem a extensão conectada, o resultado segue ⚠️ não executado — sem ferramenta.

**Teto (R17):** bloco `## v3.32`, `[IO.File]::ReadAllText` UTF-8, medido em 25/09/2026 — **12.718 B**, sob 12,5 KB (3 papéis).

---
