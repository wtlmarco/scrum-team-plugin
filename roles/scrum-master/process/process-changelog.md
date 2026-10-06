# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
| [`v3.41`](process-changelog-archive.md) | R34: contato remoto por Remote Control — identidade do projeto, pendência em disco, fim do `sprint run` em formulário de autorização da Review e protótipo publicável como artifact (SM + UX) — 03/10/2026 |
| [`v3.40`](process-changelog-archive.md) | R33: trilha `fix` para defeito e ajuste pequeno — critério verificável na entrada, plano e execução em bloco, consumo próprio, piso de evidência por Correção e conferência C4 (SM + PO + Arquiteto + QA + UX) — 03/10/2026 |
| [`v3.39`](process-changelog-archive.md) | Guardas e conferências mecânicas: hooks de plugin (G1 · G2 · G3 · G4 · G13) e três scripts (C1 · C2 · C3) tiram do julgamento o que é mecânico (SM + QA) — 02/10/2026 |
| [`v3.38`](process-changelog-archive.md) | Medir custo e resultado: Categoria e Unidade no registro de consumo, bloco "Custo × resultado" na retrospectiva, modelo de benchmark A/B/C e "História de origem" no defeito (SM + PO + QA) — 02/10/2026 |
| [`v3.37`](process-changelog-archive.md) | R32: consultoria externa especializada pelo `/sm consulting` — técnica e de negócio, carta sanitizada, até 3 réplicas, validação do time antes do formulário (SM + PO + Arquiteto + QA + UX) — 02/10/2026 |
| [`v3.36`](process-changelog-archive.md) | R27 confere a energia e retoma o mesmo agente; Task pesada em segundo plano; ocorrência de plugin só se registra no `run` e se pergunta na Review; `replicate-in-new-project.md` fundido no `how-to.md` (SM) — 01/10/2026 |
| [`v3.35`](process-changelog-archive.md) | `.team-project/` sai do git (R31); R28 enxuta: relatório do job com teto, `report-<log>.md` por chamada, dev isento, log podado não é achado; consumo fora de sprint em `.team-project/consumption.md` (SM) — 30/09/2026 |
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

## v3.44 — Run sem trava: o Arquiteto decide e não escreve no código (G8 nega), a G14 libera o operacional do run, a G15 registra pedido de permissão, a R27 lê o transcript; o que sobe ao stakeholder (SM + Arquiteto + PO) — 06/10/2026

**Instrução** (stakeholder): "Gere um plano de alteração para corrigir esses problemas", sobre o relato de um projeto-piloto (v3.42, 05–06/10/2026): quatro chamadas a agentes voltaram "interrupted" — uma por pergunta da G8 (Arquiteto escrevendo `relogio.service.spec.ts`, recusada), três paradas de 24 min a 5 h 33 min sem nada no `guards.log`. Mais duas perguntas da G8 aceitas. As quatro escritas do Arquiteto vieram do prompt de GAP da sessão ("valide contra o compilador"). Plano em `proposta-run-sem-travas.md`. **Decisões do stakeholder (06/10/2026):** **D1** — "o Arquiteto pode resolver questões técnicas operacionais mais complexas sem precisar subir para eu decidir… ele orienta e passa para o demandante a resposta" (fecha o P2 da v3.42: G8 nega, sem pergunta); **D2** — registrar o pedido de permissão **e** "no operacional do sprint run e fix os guards… podem permitir o acesso"; **D3** — lista liberada no `init`/`update`: ok; **revista no mesmo dia** ("ela não deveria estar no `.team-project` para o usuário do plugin?"): a lista é só `runCommands` no `guards.json`, aplicada pela G14 — o plugin não escreve em `.claude/settings*.json` (o harness só lê permissão de lá, e fora do run o stakeholder está presente). **Detalhe (mesmo dia):** Arquiteto e PO sobem ao stakeholder só mudança funcional, impacto significativo ou arquitetura fora do SDD que altera significativamente o esperado do sistema.
**Classificação:** instrumento (G8, G14, G15, G13; `notification.ps1` novo) · fluxo (`sprint-run.md`, `fix-run.md`) · propriedade de artefato (`.active-run`, `.active-spike`) · regra (R27: segunda conferência) · comportamento de agente (card do Arquiteto) · roteamento (`workflow.md` §6). **Sem regra nova** (34): reforça R25, R27, R9, R28.
**Papéis movidos (R17):** 3 — SM, Arquiteto e PO → barreira de 12 800 B.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `hooks/pre-tool.ps1` · `common.ps1` | G8 · G14 (nova) | **G8** nega código-fonte ao Arquiteto salvo com `.active-spike`, com a rota na mensagem (scratchpad · `operator` no sprint · prova do teste com o dev); vale também para escrita pelo `PowerShell`/`Bash` (heurística, `*.log` liberado). Nenhuma guarda pergunta mais (`Ask` removida). **G14** — com `.active-run`, papel do time: `allow` em `Edit`/`Write` no projeto ou no temporário e em comando cujos segmentos estão todos na lista (git sem push, leitura, `Get-WinEvent`, `runCommands`, conferências `scripts/checks`); nega `--no-verify`, `Invoke-Expression`, `Start-Process`, escrita por `[IO.File]`, escrita fora do projeto e — com `runCommands` preenchido — o que está fora da lista |
| `hooks/notification.ps1` (novo) · `hooks.json` | `Notification · permission_prompt` | **G15** grava o pedido de permissão no `guards.log`, com o texto e o run ativo |
| `hooks/session-start.ps1` | G13 | lista G14/G15; avisa `.active-run`/`.active-spike` sobrando |
| `ownership.json` · `artifact-ownership.md` §1 | linha nova | `.active-run` e `.active-spike`: dono SM, escritor a sessão |
| `deliverables/team-project/guards.json` | `runCommands` | chave nova, vazia no modelo |
| `sprint-run.md` | pré-condições · paradas · R27 · passos 2 e 4 · Como o SM verifica | `.active-run` gravado antes do 1º agente e apagado em toda parada; R27 com as duas conferências e "permissão pendente"; escalação só pelo critério novo; prompt de GAP nunca pede escrita/compilação no projeto; deny G8 por prompt é achado contra a orquestração; linha G15 no run vai à retro |
| `fix-run.md` | §Run, paradas | o mesmo contrato; no fix, validação do Arquiteto só no scratchpad |
| `working-rules.md` | R27 | segunda conferência: transcript do subagente (último `tool_use` sem `tool_result`) e linhas G15; classificação "permissão pendente" |
| `roles/architect/README.md` · `skills.md` §11 · `templates/fix-plan.md` regra 6 | `/arc question` 3–4 · §Validar sem escrever no produto (nova) · spike | questão técnica operacional decide e devolve; sobe só o critério novo; validar por scratchpad, `operator` (sprint) ou "não validado"; spike só com `.active-spike`; prova do teste de regressão é do dev |
| `roles/product-owner/README.md` · `workflow.md` §6 | degrau 1 · roteamento | o que sobe ao stakeholder, e só isso; questão técnica operacional → Arquiteto |
| `rituals/team-update.md` 7e · 7f (novo) · `team-init.md` 4a (novo) | — | `runCommands` no `.team-project/guards.json` a partir do `developer/context.md`, só acrescentando, um formulário; o plugin não escreve em `.claude/settings*.json` |
| Sessão (stakeholder) | `agents/architect.md` · `hooks/COVERAGE.md` · `run-guard-tests.ps1` (+19 casos) · `plugin.json` · `README.md` · `CHANGELOG.md` | Aplicados pela sessão, a pedido |

### Por quê
A lista fechada de paradas da v3.43 não cobria duas saídas do contrato que o piloto mediu: a **pergunta da própria guarda** (G8 `ask`) e o **pedido de permissão do harness**, que trava o subagente — em primeiro ou segundo plano — até alguém responder, sem rastro no `guards.log`. A primeira nascia de prompt da orquestração; a segunda virava "interrompido" sem causa, e a sessão chegou a atribuí-la ao stakeholder (R27 já proibia). A documentação do Claude Code (consultada em 06/10/2026) confirma que `permissionDecision: "allow"` num `PreToolUse` pula o pedido também em subagente — por isso a liberação vive na guarda, restrita ao run e ao que as outras guardas já conferiram.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Sessão que orquestra | grava e apaga `.active-run` (e `.active-spike`); prompt de GAP sem escrita no projeto; R27 com as duas conferências; acrescenta prefixo de build/teste/lint a `runCommands` quando falta |
| Arquiteto | decide a questão técnica e devolve; não escreve no código fora de spike declarado; registra como validou |
| PO | sobe ao stakeholder só o critério novo |
| SM | verifica marcadores sobrando, deny G8 por prompt e linhas G15 no run |

### Verificação (R19)
| Item | Comando | Resultado | |
|---|---|---|---|
| Guardas | `powershell -NoProfile -File scripts/checks/tests/run-guard-tests.ps1` | 73 casos · 0 falharam (G8 nega com a rota, libera com `.active-spike` e no scratchpad, nega `Set-Content` em código; G14 libera git/leitura composta/`runCommands`/C1/escrita no escopo e no temporário, deixa ao harness sem run e sem `runCommands`, nega fora da lista, `--no-verify`, destino variável e fora do projeto; G15 grava; G13 avisa marcador) | ✅ |
| Release (R17 · R18) | `powershell -NoProfile -File scripts/checks/release.ps1` | R18 ok: plugin.json = CHANGELOG = README L3 = v3.44.0, processo 3.44/3.43/3.42 com entrega · R17 ok: bloco v3.44 ≤ 12800 (3 papéis), 3 entradas vivas (v3.41 arquivada) · ps1-5.1 ok: 12 scripts · ownership ok: 51 regras · órfãos ok: 45 modelos · exit 0; `run-check-tests.ps1` → 25 · 0 | ✅ |

**Não exercitado:** um `sprint run` e um `fix run` reais com a v3.44. **A confirmar no disparo real:** se o evento `Notification · permission_prompt` dispara para pedido feito dentro de subagente (a documentação não diz); se `allow` da G14 prevalece sobre regra `ask`/`deny` do `settings` (não documentado). Sem a G15, a R27 segue pelo transcript.

### Pendente do stakeholder
Atualizar o plugin, rodar `/team update` (passo 7f) em cada projeto e **reiniciar a sessão**; no primeiro run, `"probe": true` para ver as linhas `G14 allow` e `G15`. Remover `proposta-run-sem-travas.md` depois do aceite desta entrada.

### Addendum — 06/10/2026 (mesma v3.44.0): segundo relato, cinco interrupções
**Instrução** (stakeholder): "Faça uma averiguação profunda sobre essas reclamações e tendo essa certeza pode aplicar". **Relato** (outro usuário): cinco chamadas `Agent` em primeiro plano "interrupted", sem ação dele; não é limite de tempo (uma de 82 min terminou bem); duas coincidem, em até 70 ms, com a entrega de notificação de agente em fila; quase todos os subagentes estavam parados esperando (comando em segundo plano, pergunta de autorização ou nada registrado). **Averiguação:** (1) transcripts desta máquina — em todo "interrupted" de pedido de permissão, logo antes vem o `tool_result` "The user doesn't want to proceed" (pedido fechado sem aprovação); os demais são Esc durante a ferramenta; (2) issue anthropics/claude-code#84346 (fechada sem correção) — vigia de ~600 s sobre requisição de modelo parada sai como "interrupted by user"; (3) documentação — pedido de permissão em subagente **não expira**; notificação **não interrompe** ferramenta em curso (confirmado aqui com comando em primeiro plano); sessão interativa dispara subagente em segundo plano por padrão; (4) **não medido:** se notificação fecha pedido pendente (o modo desta sessão não abre pedido). **Conclusão:** a coincidência com notificação não está provada; o que está provado é que o papel parado esperando — permissão, comando em segundo plano ou modelo — derruba a chamada em primeiro plano e prende a sessão, e os seis `commands/` forçavam esse primeiro plano.

| Documento | Mudança |
|---|---|
| `sprint-run.md` §Disparo (era §Task pesada) · Como o SM verifica · `fix-run.md` | **todo** agente do `run` com `run_in_background: true`; série R1 mantida aguardando a notificação; encerrar o turno à espera não é parada |
| `commands/{arc,dev,qa,po,ux,sm}.md` | `run_in_background: false`, salvo no `sprint run`/`fix run` (`true`) |
| `hooks/pre-tool.ps1` G14 · `COVERAGE.md` · `how-to.md` | nega comando com `run_in_background: true` aos papéis no run, salvo `operator` (R28) |
| `working-rules.md` R27 · `sprint-run.md` | transcript lido pelas três assinaturas: permissão fechada (com a `G15`) · ~600 s de silêncio (vigia) · notificação no mesmo segundo (só registro); sem nenhuma, "causa não identificada" |

**Verificação (R19):** `run-guard-tests.ps1` → 75 casos · 0 falharam (G14 nega comando em segundo plano ao QA, libera ao `operator`) · `release.ps1` → exit 0 (R17: bloco v3.44 ≤ 12800). **Não exercitado:** um run real todo em segundo plano.

### Addendum — 06/10/2026 (v3.44.1): burndown parado até o fim da Task
**Instrução** (stakeholder): item do `note.md` ("o Registro de transições… deveria ficar dentro do `burndown.md`… o burndown parece congelado até o final da tarefa"), aplicado como v3.44.1. **Causa:** a terceira edição do §Marcador (linha na Série) não era conferida — o C1 só lia → ✅ —, a sessão podia gravar o Registro e pular a Série; o `burndown.md` ainda descrevia a granularidade de antes do `run`. **Classificação:** formato de documento · instrumento (C1 R24). **Sem regra nova.**

| Documento | Mudança |
|---|---|
| `templates/burndown.md` · `sprint-backlog.md` | Registro de transições sai do quadro e vive no burndown, ao lado da Série; Evento cita a passagem; texto anterior ao `run` removido |
| R24 · `workflow-sprint.md` §5f · `sprint-run.md` §Marcador · `artifact-ownership.md` §1 · índice | transição = linha no Registro + linha na Série, no mesmo arquivo |
| `close.ps1` · `fix.ps1` · `lib.ps1` | R24 `-Post` exige → 🟦/🟨/🟪 e uma linha da Série por transição; Registro lido do burndown, com recuo ao Sprint Backlog (sprint aberto antes) |

**Verificação (R19):** `run-check-tests.ps1` → 28 casos · 0 falharam (Registro legado lido; Série parada e → 🟨 ausente reprovam o R24). **Não exercitado:** um `sprint run` real gravando no burndown.

### Addendum — 06/10/2026 (v3.44.2): o `guards.log` do primeiro `sprint run`
**Instrução** (stakeholder): "pode corrigir", sobre o `guards.log` do primeiro `sprint run` (v3.42/3.43): 7 linhas `erro` (`IsPathRooted`) e 2 negações da G9 em `Env:`. **Classificação:** instrumento (heurística do `PowerShell` em G5/G8/G9/G14). **Sem regra nova.** `pre-tool.ps1`: alvo com caractere inválido descartado; drive que não é de arquivo fora de G5/G8/G9; G14 libera drive da sessão e nega outro. `COVERAGE.md` alinhado.

**Verificação (R19):** `run-guard-tests.ps1` → 81 casos · 0 falharam; os 6 novos reprovam no código anterior. **Não exercitado:** run real com a v3.44.2. Indicador da fase 2 recomeça aqui (`proposta-guards-fase2.md`).

---

## v3.43 — `sprint run` sem paradas fora do contrato: lista fechada de paradas, rota do gate protegido, negação ao dev vira 🔺 GAP, interrupção pelo stakeholder e marcador acompanhando a Task; addendum: veredito pelo primeiro marcador, desvio aceito no R4, código de saída do `operator` (SM + Arquiteto + QA) — 05/10/2026

**Instrução** (stakeholder): "aplique o proposta-run-interrupcoes.md para termos um teste mais correto" — pré-requisito do benchmark de projeto (simulação sem intervenção). Origem: 4 interrupções e 1 queixa de burndown em `note.md` (sprint 1 de um projeto-piloto). Decisões do formulário de 05/10/2026: **P2 — sessão principal aplica o arquivo protegido** (com o pedido de permissão do harness) · **P5 — sem modo novo:** "já existe uma marcação, ela só precisa refletir onde a tarefa está" (a sessão marca no momento da transição; `board --marca` descartado) · versão única v3.43.0.
**Classificação:** fluxo (`sprint-run.md`, `fix-run.md`) · formato de documento (plano: `**Arquivos protegidos:**`, §12, teste de cada arquivo de produção na lista) · propriedade de artefato (a sessão escreve marcador e transição no `run`) · comportamento de agente (card do dev, `commands/sm.md`, mensagens da G5/G9 — aplicados pela sessão). **Sem regra nova** (34): reforça R22, R24, R25, R27 e R7.
**Papéis movidos (R17):** 3 — SM, Arquiteto e QA (este no addendum) → barreira de 12 800 B.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `sprint-run.md` | Quem executa · Ordem da fila · passos 1, 3–6, 8 · §Marcador (nova) · Como o SM verifica | **P1** paradas legítimas em lista fechada (fim da fila, bloqueio de R22 sem Task elegível, pré-condição, interrupção); fim de Task não é parada; "sigo?", fronteira de História e resumo no meio da fila proibidos; Task 🔴 não para o `run`. **P2** passo 3: a sessão aplica o diff de `**Arquivos protegidos:**` antes do dev; recusado → 🔴 e a fila segue. **P3** passo 4: deny de G9/G6/G5 ao dev é sempre 🔺 GAP, nunca pergunta ao stakeholder. **P4** interrupção pelo stakeholder: não reexecuta, disco consistente, uma linha, espera. **P5** a sessão marca ⬜→🟦→🟨→🟪 (e 🟪→🟨, →🔴) na hora: marcador, Registro de transições e linha de composição no burndown; o `run` deixa de acionar `board` |
| `fix-run.md` | §Run | Mesmas paradas, deny ao dev = GAP, timeout = não exercitado |
| `working-rules.md` | R24 | A sessão do `run` também grava transição; intermediários exatos no `run`; Task fechada sem → 🟦/🟨/🟪 é achado |
| `artifact-ownership.md` | §1 Sprint Backlog · Burndown | Escritor adicional no `run`: a sessão (marcador e linhas), como no `.active-task` |
| `templates/burndown.md` · `sprint-backlog.md` | cabeçalho · granularidade · custo · Registro de transições | Linha por transição do `run`, com data e hora |
| `roles/architect/templates/implementation-plan.md` | cabeçalho · §12 (nova) · regras 15 e 16 · exemplo | `**Arquivos protegidos:** nenhum \| ver §12`, separado por linha em branco (a G9 não o lê); §12 com o diff exato; teste de cada arquivo de produção na lista, ou `sem teste: <arquivo> — <motivo>` na §6 |
| `roles/scrum-master/README.md` | `sprint run` | SM só no `close` |
| Sessão (stakeholder) | `agents/developer.md` (timeout ≠ limpo; gate protegido é da §12) · `commands/sm.md` (tabela de modos; R27 com ação do stakeholder) · `hooks/pre-tool.ps1` (mensagens G5 e G9 dão a rota) · `hooks/COVERAGE.md` · `run-guard-tests.ps1` (`ExpectErr` + 3 casos) · `plugin.json` · `README.md` · `CHANGELOG.md` | Aplicados pela sessão |

### Por quê
No sprint 1 do piloto o `run` parou quatro vezes sem motivo de contrato: ofereceu parar depois de uma Task fechada, travou num `ci.yml` que nenhum subagente pode editar (sem rota), repassou ao stakeholder a negação da G9 de um `*.spec.ts` esquecido no plano, e não retomou depois de uma interrupção manual. O burndown só via abertura e fechamentos porque o `board` rodava no fim da Task. O benchmark de projeto exige `sprint run` e `fix run` sem intervenção — cada parada fora do contrato seria medida como custo do plugin, não como defeito.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Sessão que orquestra | não para entre Tasks; aplica o diff protegido no passo 3; transforma deny ao dev em GAP; marca cada transição; responde em uma linha à interrupção |
| Arquiteto | lista o teste de cada arquivo de produção; arquivo de gate vai à §12 com diff exato |
| dev | timeout não é resultado; arquivo de gate é da §12 |
| SM | entra só no `close`; verifica paradas, linhas de transição e `.active-task` × 🟨 |

### Verificação (R19)
| Item | Comando | Resultado | |
|---|---|---|---|
| Guardas | `powershell -NoProfile -File scripts/checks/tests/run-guard-tests.ps1` | 54 casos · 0 falharam (G5 cita `sprint-run.md passo 3`; §12 fora do escopo da G9; teste listado liberado) | ✅ |
| Conferências | `powershell -NoProfile -File scripts/checks/tests/run-check-tests.ps1` | 20 casos · 0 falharam (C1 R24 lê a data de `aaaa-mm-dd hh:mm`) | ✅ |
| Release (R17 · R18) | `powershell -NoProfile -File scripts/checks/release.ps1` | R18 ok: plugin.json = CHANGELOG = README L3 = v3.43.0, processo 3.43/3.42/3.41 com entrega · R17 ok: bloco v3.43 ≤ 10240 (2 papéis), 3 entradas vivas (v3.40 arquivada) · ps1-5.1 ok · ownership ok: 50 regras · órfãos ok: 45 modelos · exit 0 | ✅ |

**Não exercitado:** um `sprint run` real com a v3.43 (exige plugin atualizado e sessão reiniciada). **Não mecanizado:** a conferência "teste de cada arquivo de produção na lista" do plano — fica na verificação do SM e na frente 2 do QA até existir conferência de plano por script.

### Pendente do stakeholder
Atualizar o plugin e **reiniciar a sessão**. Remover `proposta-run-interrupcoes.md` depois do aceite desta entrada. Os cinco itens de `note.md` que originaram a P1–P5 saíram da fila; ficaram os três achados de processo do mesmo sprint que esta entrada não trata — tratados no addendum abaixo, no mesmo dia.

### Addendum — 05/10/2026 (`/review note`, entregue na mesma v3.43.0): os três achados de processo do sprint 1 do piloto, e um quarto
**Instrução** (stakeholder): "pode rodar o /review note". Fonte: `scrum-master/context.md` do piloto (achado de processo de 05/10/2026) e o bloqueio 14 do quadro. **Classificação:** instrumento (C1 R7/R4/R28, C4 item 4) · formato de documento (evidência e veredito: `**Desvio aceito:**`; um bloco `##` completo por rodada) · comportamento de agente (card do `operator`) · regra (R4 "SM verifica", R28 nome da pasta). **Sem regra nova** (34).

| # | Sintoma | Causa | Mudança |
|---|---|---|---|
| 1 | O `operator` tabulou "código 0" para provas que reprovam e não gravou `report.md` | o código lido era o do *wrapper* da ferramenta `PowerShell`; nada mandava conferir o relatório em disco | card: `$LASTEXITCODE` capturado na mesma chamada e gravado como `EXIT=<n>` no log; prova que deve reprovar compara o real com o esperado; `Test-Path` do `report` antes de responder |
| 2 | `close.ps1` R7 barrou a T-019 duas vezes: revisão do QA sem `**Veredito:**`, depois "✅ único" com ⚠️/❌ do histórico na linha | o C1 lê só o bloco mais recente e exigia a linha sem nenhum outro marcador | C1 e C4 leem o **primeiro** marcador da linha (`Get-VerdictMark`, `lib.ps1`); `evidence.md`: toda rodada é bloco `##` completo, e o primeiro marcador é o veredito |
| 3 | R4 barrou "Fora do plano" com desvio que o stakeholder decidiu manter (`ci.yml:6-7`) | não havia rótulo para a decisão; qualquer arquivo listado era falha | `**Desvio aceito:** aaaa-mm-dd — quem decidiu — onde está` em `evidence.md` e `verdict.md` (Arquiteto se técnico e incluído no plano; stakeholder por formulário se muda escopo); C1 R4 aceita com data, falha sem ela; não vale na trilha `fix` (lá é promoção) |
| 4 | Job do Arquiteto em `operator/sprint-1/` ficou fora da contagem do C1 (0 reports) | `<sprint>` sem valor definido; o C1 conta `operator/<n>/` | R28 e card: `<sprint>` é o número; C1 R28 aponta `operator/sprint-<n>/` como nome fora do padrão |

**Verificação (R19):** `run-check-tests.ps1` → 25 casos · 0 falharam (novos: ✅ com histórico ok; ⚠ antes do ✅ falha; desvio aceito com data ok; sem data falha + `operator/sprint-1` apontado; C4 ✅ com histórico fecha e ⚠ não) · `run-guard-tests.ps1` → 54 · 0 · `release.ps1` → exit 0. **Não exercitado:** o card do `operator` num job real.

---

## v3.42 — Guardas por papel (fase 2): gate protegido, teste ignorado, `Agent` só ao `operator`, matriz de propriedade, escopo do dev e pasta do job — G5 · G6 · G7 · G8 · G9 · G11 (SM + Arquiteto) — 04/10/2026

**Instrução** (stakeholder): "pode aplicar criando a branch a partir de develop" a `proposta-guards-fase2.md`, depois da sonda de 04/10/2026 num `/sm sprint plan` real. Decisões do formulário de 04/10/2026: **P1 — fase 2 inteira** (a recomendação era G7 + G9 + G6 primeiro) · **P2 — adiada:** a G8 entra com `ask` ao Arquiteto em código-fonte, decisão `ask` × `deny` + pedido registrado depois de 2 sprints de `guards.log` · versão-alvo v3.42.0, levando junto o addendum da v3.41 (previsto como v3.41.1).
**Classificação:** instrumento (G5–G9, G11; C3 `ownership`) · formato de documento (`**Arquivos tocados:**` legível por script; `.active-task`) · propriedade de artefato (linha `.active-task`; `ownership.json` derivado da matriz) · fluxo (`sprint run` passos 3, 4, 8; `fix run` passo 2 e fechamento; `/dev`) · comportamento de agente (cards, `hooks/`, `scripts/`, `commands/dev.md`, guias: aplicados pela sessão). **Sem regra nova** (34): as guardas reforçam R4, R7, R8, R28 e a matriz — critério de entrada de regra mecânica (`review-contract.md`).
**Papéis movidos (R17):** 2 — SM e Arquiteto → barreira de 10 240 B.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `artifact-ownership.md` | §1 | Linha nova **Escopo ativo do dev** (`.active-task`: dono SM, escritor a sessão); linha `hooks/` cita G5–G9/G11 e declara `hooks/ownership.json` **derivado** desta matriz (mudou a matriz, muda o JSON no mesmo ciclo — R12) |
| `sprint-run.md` · `fix-run.md` | passos 3, 4, 8 · passo 2 e §Fechamento · "Como o SM verifica" | A sessão grava `.active-task` antes de disparar o dev e o apaga quando a Task/bloco sai dele; GAP que acrescenta arquivo entra na lista do plano; deny seguido de contorno é achado |
| `working-rules.md` · `working-rules-index.md` | R4 · R7 · R8 · R28 · legenda | "Instrumento" ganha G9 (R4, R8), G5/G6 (R7), G7/G11 (R28); G8 = a matriz |
| `deliverables/team-project/` | `README.md` · `guards.json` | Chaves `protectedPaths`, `sourceRoots`, `testSkipPatterns`; linha `.active-task` (não semeada) |
| `roles/architect/templates/` | `implementation-plan.md` (regra 15, exemplo) · `fix-plan.md` | `**Arquivos tocados:**` = lista fechada, um caminho por linha entre crases; `- produção:`/`- teste:` também lidos pela G9 |
| Sessão (stakeholder) | `hooks/` (`pre-tool.ps1`, `common.ps1`, `session-start.ps1`, `hooks.json` + `Agent`, `ownership.json`, `COVERAGE.md`) · `release.ps1` (C3 `ownership`) · suítes · `agents/` (dev, arquiteto, QA, UX, operator) · `commands/dev.md` · `team-update.md` (7e) · `how-to.md` · `README.md` · `plugin.json` · `CHANGELOG.md` | Aplicados pela sessão |

### Por quê
A sonda resolveu a dúvida que travava a fase 2: dentro do subagente o hook recebe `agent_type` = `team:<papel>`; na sessão principal, nada. Com isso o "papel X não faz Y" dos cards passa a valer mesmo quando o modelo esquece — inclusive o dev em Haiku, que é quem mais improvisa escopo. O filtro casa o sufixo (`(^|:)developer$`), como a G4 já fazia com o `operator`.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Sessão / SM | grava e apaga `.active-task`; lê os deny no `guards.log` na retrospectiva |
| Arquiteto | lista de arquivos do plano legível e completa (produção e teste); GAP que acrescenta arquivo entra nela; código-fonte só com o "sim" do stakeholder |
| dev | barrado fora do plano, em gate e em teste ignorado — o caminho é 🔺 GAP |
| Stakeholder | responde a pergunta da G8 quando o Arquiteto vai escrever código; ajusta `protectedPaths`/`sourceRoots` do projeto |

### Conflitos com o processo vigente
- **R25** (sem pergunta ao stakeholder durante o `run`): o `ask` da G8 é uma pergunta. Só dispara se o Arquiteto escrever código — fora do papel dele no `run` —, e a P2 o revisa com dados. Registrado, não resolvido.
- **Matriz × JSON:** duas fontes possíveis. Resolvido: a matriz é a fonte, o JSON cita linha e dono, o C3 reprova a divergência.

### Como saberemos que funcionou
Em 2 sprints: zero arquivo fora do plano no diff de Task fechada (R4) e de Correção fechada (C4 item 5); zero teste ignorado introduzido pelo dev; `guards.log` sem linha `erro`; falso positivo ≤ 1 por guarda; contagem dos `ask` da G8 para decidir a P2.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Sonda (entrada) | linhas `probe` do `guards.log` de um projeto, `/sm sprint plan` de 04/10/2026 | `agent_type=team:product-owner` · `team:architect` · `team:user-experience` · `team:quality-assurance` · `team:scrum-master`; sessão `agent_type=(ausente)`; `script_ms` 144–393 | ✅ |
| Teste | `run-guard-tests.ps1` | `51 casos · 0 falharam` (30 novos: G5–G9, G11, G8 no repositório-fonte, projeto sem o time) | ✅ |
| Teste | `run-check-tests.ps1` | `20 casos · 0 falharam` (1 novo: `ownership.json` com dono divergente → exit 1) | ✅ |
| Arquivamento | `Contains` ordinal do bloco `## v3.39` no arquivo, depois de sair do vivo | True (7 506 B); índice com a linha `v3.39`; 3 entradas vivas (v3.42, v3.41, v3.40) | ✅ |
| Carga fixa (caracteres, `git show HEAD:` → arquivo) | cards | `developer` 3 896 → 3 960 · `architect` 5 316 → 5 278 · `quality-assurance` 6 534 → 6 437 · `user-experience` 5 469 → 5 474 · `operator` 5 941 → 5 990 · `commands/dev.md` 2 083 → 2 313 | medida |
| Release (R17 · R18 · ownership) | `powershell -NoProfile -File scripts/checks/release.ps1` (depois de gravar a v3.42) | R18 ok: plugin.json = CHANGELOG = README L3 = v3.42.0; processo 3.42, 3.41, 3.40 com entrega · R17 ok: bloco v3.42 ≤ barreira 10240 (2 papéis); 3 entradas vivas · ps1-5.1 ok: 11 scripts com BOM · ownership ok: 50 regras batem com linha e dono de §1, 7 com nota · órfãos ok: 45 modelos · exit 0 | ✅ |
**Não exercitado:** disparo real de cada guarda numa sessão com o plugin atualizado (só os testes, que entregam ao despachante o JSON do harness); `team:developer` e `team:operator` literais (deduzidos); o `ask` da G8 dentro de subagente no harness real.

### Pendente do stakeholder
Atualizar o plugin e **reiniciar a sessão**; `/team update` (passo 7e) em cada projeto; ligar a sonda no primeiro `sprint run` para confirmar `team:developer`/`team:operator`. Remover `proposta-guards-fase2.md` depois do aceite desta entrada (a fase 3, G12, segue registrada em `hooks/COVERAGE.md`).

---
