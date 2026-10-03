# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v3.40 — R33: trilha `fix` para defeito e ajuste pequeno — critério verificável na entrada, plano e execução em bloco, consumo próprio, piso de evidência por Correção e conferência C4 (SM + PO + Arquiteto + QA + UX) — 03/10/2026

**Instrução** (stakeholder, `/review`): "aplicar a proposta em `proposta-fix.md` (terceira da rodada evaluation → guards → fix)". Decisões do formulário de 02–03/10/2026: **P1** o Arquiteto escreve os mini-planos · **P2** N = 5 · **P3** o ✅ do QA encerra a Correção, sem aceite na Review (reabrir = anotar no `note.md` citando a F-ID) · **P4** o UX só atualiza quando a especificação de tela cita o texto literal · **P5** ordem evaluation → guards → fix · **P6** teto de 5 Correções e 2N arquivos · regra **R33** (a `remote` passa a R34) · **C4 sim** (`fix.ps1`, escrito pela sessão) · **R15 com emenda**.
**Classificação:** regra nova (R33; R25 e R15 emendadas, R20 com uma frase; R23 mantida; saldo +1) · fluxo (`/sm fix`, `fix plan`, `fix run`; §5g reescrito) · formato de documento (ficha, mini-plano, índice, pasta do bloco, variantes do veredito e do consumo) · propriedade de artefato (`fixes.md`, `fixes/`) · instrumento (C4) · comportamento de agente (`commands/`, aplicado pela sessão).
**Papéis movidos (R17):** 5 — SM, PO, Arquiteto, QA e UX → barreira de 17 920 B.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/scrum-master/process/working-rules.md` · `working-rules-index.md` | R33 · R25 · R20 · R15 · R28 · tabelas | **R33 nova**: critérios C1–C8, bloco com consumo próprio, piso por Correção, promoção obrigatória, "SM verifica" = **C4** (parcial) e o julgamento declarado. R25: "construir produto" + a única exceção (a trilha); `fixes/` fora da pasta do sprint. R15: o delta de ajuste é a única exceção ao ①. R20: Correção não é Task. R28: caminho `operator/B-<nnn>/<F-ID\|bloco>/`. Índice R1–R33, `C4` na legenda, linha R33 sem [close]. Contagem 32 → 33 |
| `roles/scrum-master/process/fix-run.md` (novo) | §Elegibilidade · §Triagem · §Plan · §Run · §Promoção · §Fechamento | Fonte única da trilha. `run` passo 0 = C4 `-Pre` (exit 1: não começa); passo 5 = C4 antes de gravar o estado final (exit 1: só as F-IDs listadas não fecham, D6); commit `F-<nnn>:` por Correção |
| `process/workflow-sprint.md` §5g · `workflow.md` §8 · `artifact-ownership.md` §1 · §1c | Manutenção · gates · matriz | Elegível → trilha `fix`, sem folga nem histórico; os três sprints só para a correção pontual não elegível; gates técnicos por Correção; linhas de `fixes.md` (escritor a sessão), ficha (PO), pasta do bloco (SM · Arquiteto · QA); retenção por bloco; poda dos jobs do bloco depois do fechamento |
| `templates/consumption.md` · `fix-log.md` (novo) · `retrospective.md` · `project-context.md` | destinos · índice · "Trilha fix no período" · §2a | Três destinos por prioridade; a **triagem fica nos destinos de sempre**, com Nota `triagem;`; Unidade `B-<nnn>`; variante "bloco" com custo por Correção fechada; `fixes.md` (devolvida leva o motivo na célula "Promovida para"); indicadores do §8; rótulos "Limite de arquivos por Correção (N)" e "Teto de Correções por bloco" |
| `deliverables/team-project/README.md` | manifesto | `fixes.md` e `fixes/` não semeados; N e teto no README do projeto; `operator/B-<nnn>/` |
| `roles/product-owner/` | `templates/fix-card.md` (novo) · `README.md` · `skills.md` · `templates/note.md` | Ficha com C1–C4, reprodução, delta, confirmação do stakeholder, destino; `/po bug` e `/po note` seguem `fix-run.md` §Triagem (ajuste, "elegível à trilha fix", História do aceite **por item** ao `/qa bug` em lista, reaberta **sem novo escape**); aplicação do delta no `fix run` (R12, R15 emendada); sem aceite na Review (P3) |
| `roles/architect/` · `roles/developer/` | `templates/fix-plan.md` (novo, 14 regras, teto de 60 linhas por F-ID) · `README.md` · `skills.md` §3 · `gap.md` · `delivery-report.md` | Mini-planos do bloco e revalidação (D9); promoção (C5–C8) com o critério que caiu; dev: uma Correção por vez, commit `F-<nnn>:` com `git add -- <arquivo>`, sem git checkpoint com os trechos originais, teste falha antes pela asserção e passa depois; relatório com "Teste de regressão: saída antes / saída depois" |
| `roles/quality-assurance/` | `templates/verdict.md` ("Variante trilha fix") · `README.md` · `deliverables/implementation/pending.md` | `bug` em lista; veredito por F-ID com os rótulos que o C4 lê (`**Antes:** exit`, `**Depois:** exit 0`, `**Commit:**`, `### Escopo`, `### Documentos vivos (R12)`, `## Fechamento`); defeito funcional vira `SC-nnn`; entrada do `pending.md` fecha com ponteiro `F-<nnn>`/`B-<nnn>` |
| `roles/user-experience/README.md` | "Texto de tela na trilha fix" | Só com citação literal (grep em `screens/` e `journeys/`); uma invocação por bloco |
| *Aplicado pela sessão* | `scripts/checks/fix.ps1` (C4, `-Pre` e completo) · `tests/run-check-tests.ps1` · `commands/sm.md` · `po.md` · `qa.md` · `how-to.md` · `README.md` · `plugin.json` 3.40.0 · `CHANGELOG.md` | C4 com promovidas fora do teto e commits `F-<nnn>:` (inclusive retrabalho) nos itens 5 e 9; `fix`, `fix plan`, `fix run`; cenários D e F; banner e estrutura |

### Por quê
Corrigir um defeito de três linhas custava quase o mesmo que entregar uma Task de História — seis invocações por correção, cada uma pagando de novo a carga fixa do papel — e antes do terceiro sprint não havia caminho pequeno nenhum. O custo empurra o stakeholder a pedir a correção "por fora", e o consumo das correções dentro do sprint distorce a capacidade observada. A trilha corta a cerimônia (de seis para três papéis) e amortiza a carga fixa pelo bloco, **sem** tirar o que dá qualidade: evidência real (R7), gate técnico, teste que falha antes e passa depois e verificador diferente de quem corrigiu, **por Correção**. Para a trilha não virar atalho de feature disfarçada, a entrada é fechada por oito critérios que se conferem lendo o requisito, o plano e o código — e o que é mecânico é conferido pelo **C4**, não por julgamento.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| SM | Orquestra `plan`/`run` pela sessão, roda C4 `-Pre` e C4 completo e cola a saída, mantém `fixes.md`, lê a "Trilha fix no período" na retrospectiva |
| PO | Triagem com C1–C4 e delta do ajuste na ficha; História do aceite por item; aplica o delta só depois do ✅ |
| Arquiteto | Mini-plano por F-ID (C5–C8, arquivos, teste, revalidação); promove o que cai |
| dev | Uma Correção por vez, diff isolado, teste antes e depois colados |
| QA | Reproduz em lote, veredito por F-ID com os rótulos exatos, suíte do módulo uma vez por bloco |
| UX | Só quando a especificação cita o texto literal |
| Stakeholder | Confirma cada ajuste em formulário no `fix plan`; recebe o resultado por F-ID; reabre anotando a F-ID |

### Conflitos com o processo vigente
- **R25** ("não há dois jeitos"): emendada — vale para **construir produto**; a trilha é a única exceção, fechada por critério verificável, e o ajuste passa por formulário antes de ser construído.
- **R15** (SDD funcional só por `/sm sdd` com ①): **emendada** (decisão do stakeholder) — o delta de **ajuste** (no máximo um requisito existente, formulário antes, aplicado ao SDD só depois do ✅) é a única exceção.
- **R20** (Task com História): a Correção não é Task; promovida, nasce Task com História.
- **R21** (aceite só na Review): sem conflito — Correção não é História; o ✅ do QA encerra (P3). A taxa de reabertura passa a ser o único sinal do stakeholder sobre a trilha.
- **R23**: mantida; a trilha não é "modo leve", é escopo fechado com verificação plena. **R1**: só o `fix run` disputa a construção (nenhuma Task em 🟨, conferido pelo C4 `-Pre`).

### Como saberemos que funcionou
- **Custo:** mediana do custo por Correção fechada ≤ **40%** da mediana por Task de correção pontual (ponderada por modelo). **Bloco médio ≥ 2** Correções.
- **Qualidade:** reabertura ≤ **10%** (acima, reabre a P3). **Promoção entre 10% e 40%** (abaixo: critério frouxo; acima: triagem ruim). Zero Correção fechada acima de N arquivos; zero linha de consumo de bloco no sprint.
- Revisão depois das 10 primeiras Correções ou de 2 sprints.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Contagem | `Select-String '^### R\d+\.'` em `working-rules.md` · `'^\| R\d+ '` no índice · `'^\| R\d+ \|'` no resumo | 33 · 33 · 33 (antes: 32) | ✅ |
| Substituição de padrão | `Select-String -CaseSensitive 'Não há dois jeitos de trabalhar'` em `working-rules.md` | 0; a frase nova ("Para **construir produto** não há dois jeitos…", R25) lida no contexto | ✅ |
| Substituição de padrão | `Select-String 'R1.R32\|32 regras\|R30-R32'` fora dos changelogs | 0; novas ocorrências (`README.md:189`, `roles/scrum-master/README.md:185`, `agents/scrum-master.md:34`, índice) lidas: "33 regras", "R30-R33", "R1–R33" | ✅ |
| Referência | `Select-String 'fix-card.md\|fix-plan.md\|fix-log.md\|fix-run.md'` fora dos changelogs | arquivos que citam: 9 · 8 · 4 · 16 — nenhum órfão; seções `fix-run.md` §Elegibilidade · §Triagem · §Plan · §Run · §Fechamento existem como os ponteiros dos outros papéis as citam | ✅ |
| Arquivamento | `-ceq` do bloco `## v3.37` movido contra o texto que saiu do vivo; `Contains` no arquivo | True; 7 472 B; zero linha fora do separador | ✅ |
| Teste | `powershell -NoProfile -File scripts/checks/tests/run-guard-tests.ps1` | `17 casos · 0 falharam`, exit 0 (reexecutado) | ✅ |
| Teste | `powershell -NoProfile -File scripts/checks/tests/run-check-tests.ps1` | `16 casos · 0 falharam`, exit 0 (reexecutado). C4: feliz exit 0 com R33/1–10 ok · `-Pre` sem Task em 🟨 exit 0 · `-Pre` com T-041 em 🟨 exit 1 "não começa" · teste que não falhou antes + promoção sem motivo + linha `B-001` no consumo do sprint → exit 1, "Não fecham: F-002, F-003", F-001 fecha, consumo como aviso | ✅ |
| Teste | `fix.ps1` contra o exemplo do próprio `fix-plan.md` (Arquiteto) | `-Pre` exit 0; completo exit 0 | ✅ |
| Release (R17 · R18) | `powershell -NoProfile -File scripts/checks/release.ps1` (depois de gravar a v3.40) | R18 ok: plugin.json = CHANGELOG = README L3 = v3.40.0; processo 3.40, 3.39, 3.38 com entrega · R17 ok: bloco v3.40 com 11371 bytes ≤ barreira 17920 (5 papéis); 3 entradas vivas · órfãos ok: 45 modelos, todos referenciados · exit 0 | ✅ |
**Não exercitado:** C4 contra um bloco de projeto real; disparo do `fix run` pela sessão (exige plugin atualizado e sessão reiniciada); PowerShell 7 — fora do requisito (o requisito é o Windows PowerShell 5.1 do computador dos projetos, exercitado nas suítes).

### Pendente do stakeholder
Nada a aplicar — `commands/`, `how-to.md`, `README.md`, `scripts/`, `plugin.json` e `CHANGELOG.md` aplicados nesta entrega. Mudança de comportamento de agente só vale **após atualizar o plugin e reiniciar a sessão**. Remover `proposta-fix.md` depois do aceite desta entrada. `proposta-remote.md` já foi renumerada para R34.

---

## v3.39 — Guardas e conferências mecânicas: hooks de plugin (G1 · G2 · G3 · G4 · G13) e três scripts (C1 `close.ps1` · C2 `project.ps1` · C3 `release.ps1`) tiram do julgamento o que é mecânico (SM + QA) — 02/10/2026

**Instrução** (stakeholder, `/review`; formulário de 02/10/2026 sobre a triagem de `proposta-guards.md`): aplicar a fase 1 mais C1/C2/C3 — verificação mecânica das regras que têm forma objetiva, para que o `/sm close` e a retrospectiva deixem de reler arquivos que um script já conferiu. T11 e T12 aceitas. Decisões: G1 bloqueia **tudo** de `.team-project/` no stage, inclusive remoção, e a migração R31 (passo 7b de `/team update`) o desliga no `guards.json` durante o passo; G3 universal, com o motivo do deny lembrando que até pergunta simples segue a forma de R22; G4 silencia quando `agent_type` termina em `operator`; Windows PowerShell 5.1 (requisito: o do computador que roda os projetos — esclarecido pelo stakeholder em 03/10/2026; o PowerShell 7 não é requisito); C3 manual antes do PR; G9 (bloqueia) fica na fase 2.
**Classificação:** formato de documento (campos lidos por script; coluna "Instrumento") · propriedade de artefato (`guards.json`, `guards.log`, `hooks/`, `scripts/checks/`) · cerimônia (`/sm close`, retrospectiva) · comportamento de agente (hooks) — o que é de `hooks/`, `scripts/`, `rituals/`, `commands/` e raiz foi **aplicado pela sessão por decisão do stakeholder**. **Sem regra nova** (R1–R32 não mudam de texto).
**Papéis movidos (R17):** 2 — SM e QA → barreira de 10 KB.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/scrum-master/process/working-rules.md` | linhas "SM verifica" | marcador `**Instrumento:**` em 19 regras + 1 item na R28; texto das regras intacto |
| `roles/scrum-master/process/working-rules-index.md` | tabelas R1–R32 | coluna **Instrumento** (C1, C2, C3, G1, G3, G4; `— (julgamento)` onde só há leitura) e legenda |
| `roles/scrum-master/README.md` · `templates/status-entry.md` · `process/sprint-run.md` | `/sm close` · entrada de status · passo 7 | o `close` começa por `close.ps1 -Task <T-ID>`, cola a saída (exit 1 = não fecha, R7/R12) e, depois de gravar a transição, roda `-Post` (R24); o SM só abre o arquivo da regra que falhou |
| `roles/scrum-master/templates/sprint-backlog.md` | Pacote de abertura | linha `**Aprovado em**` (aaaa-mm-dd), lida por C1 em R20/R25 |
| `roles/scrum-master/templates/retrospective.md` | nova seção | "Guardas: deny legítimo · falso positivo · desligadas · latência" (fonte `guards.log`) e a tabela de C2 |
| `roles/scrum-master/templates/benchmark.md` | braço B′ | habilitado só com a fase 2 de guards (G5–G11) |
| `roles/scrum-master/process/artifact-ownership.md` | §1 | `guards.json`/`guards.log`; `hooks/` e `scripts/checks/` do stakeholder |
| `deliverables/team-project/README.md` · `guards.json` (novo) | manifesto | `guards.json` estrutura + conteúdo local (preserva `disabled`); `guards.log` conteúdo do projeto, não reconciliado |
| `roles/quality-assurance/templates/evidence.md` · `verdict.md` · `README.md` (passo 6) | fim do bloco de evidência | `### Documentos vivos (R12)` com `**Estado:** atualizados \| pendentes` e `### Escopo` com `**Fora do plano:** nada \| <lista>`, **cabeçalhos e rótulos exatos**; o QA transcreve do veredito para o bloco |
| *Aplicado pela sessão* | `hooks/` · `scripts/checks/` · `rituals/` · `commands/` · `README.md` · `how-to.md` · `plugin.json` 3.39.0 · `CHANGELOG.md` | G1 G2 G3 + sonda, G4, G13; C1 C2 C3 e testes; `team-update` 7b desliga G1 e 7c cria `guards.json`; `review audit` começa por C3; seção "Quando uma guarda bloqueia" |

### Por quê
O `/sm close` relia o índice e vários arquivos para dizer o que um comando prova em milissegundos (existe bloco de evidência? documentos vivos atualizados? linha do R24? duas Tasks em construção?), e a R22/R31 só valiam por disciplina. Conferência mecânica falha por cansaço, não por falta de regra: o script a faz igual toda vez e deixa o SM e o QA no que é julgamento. O desenho fixa **onde** o mecânico acaba: R5 e R16 só em parte, regras de qualidade de conteúdo continuam do SM.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| SM | roda `close.ps1` antes de ler qualquer arquivo e cola a saída; lê `guards.log` e roda C2 na retrospectiva; mantém a coluna "Instrumento" e `guards.json` (modelo) |
| QA | transcreve para o bloco da evidência `Estado` e `Fora do plano` com os rótulos exatos — grafia diferente reprova C1 |
| Stakeholder | recebe deny de G1/G2/G3 com o motivo no ato; desliga uma guarda no `guards.json`, nunca em silêncio (vira linha na retrospectiva) |
| PO · Arquiteto · UX · dev | sem mudança de regra; G3 passa a negar pergunta ao stakeholder fora da forma de R22 |

### Conflitos com o processo vigente
G1 × passo 7b de `/team update` (a migração R31 remove arquivos de `.team-project/` do git): **bloquear tudo**, e o 7b desliga G1 durante o passo (decisão do stakeholder). G3 × pergunta simples: universal, deny com motivo. G4 × `operator`: silenciado. Nenhuma regra vigente contradita.

### Como saberemos que funcionou
- **Tokens médios da invocação `close`** (Categoria `cerimônia`) caem **≥ 30%** contra a média dos 2 sprints anteriores. Se não caírem, o script roda **e** o SM relê tudo — achado de processo.
- Retrospectiva: **falso positivo de guarda = 0** recorrente e nenhuma guarda desligada sem linha na retro.
- **C1 contra uma Task fechada de projeto real** bate com o fechamento manual (ainda não exercitado).

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | comparação ordinal do bloco `## v3.36` movido contra o texto que saiu do vivo | `-ceq` = True; 10331 B, zero linha fora do separador | ✅ |
| Substituição de padrão | `Select-String -Pattern '\*\*Instrumento:\*\*' working-rules.md` | 20 ocorrências (19 regras + item da R28), cada uma lida no fim da linha | ✅ |
| Substituição de padrão | linhas `^\| R\d+ ` com a coluna nova em `working-rules-index.md` | 32 (R1–R32) | ✅ |
| Teste | `powershell -NoProfile -File scripts/checks/tests/run-guard-tests.ps1` | `17 casos · 0 falharam`, exit 0 (reexecutado) | ✅ |
| Teste | `powershell -NoProfile -File scripts/checks/tests/run-check-tests.ps1` | `12 casos · 0 falharam`, exit 0 (reexecutado) | ✅ |
| Release (R17 · R18) | `powershell -NoProfile -File scripts/checks/release.ps1` (depois de gravar a v3.39) | R18 ok: plugin.json = CHANGELOG = README L3 = v3.39.0, processo 3.39/3.38/3.37 com entrega · R17 ok: bloco v3.39 com 7291 B ≤ 10240 (2 papéis), 3 entradas vivas · órfãos ok: 42 modelos · exit 0 | ✅ |
**Não exercitado:** disparo real dos hooks no harness (exige plugin atualizado e sessão reiniciada); C1 contra Task fechada de projeto real; PowerShell 7 — fora do requisito (o requisito é o Windows PowerShell 5.1 do computador dos projetos, exercitado nas suítes). Latência medida: 0,6–0,8 s por disparo (612, 726, 775, 702, 754 ms).

### Pendente do stakeholder
Nada a aplicar — `hooks/`, `scripts/`, `rituals/`, `commands/`, `README.md`, `how-to.md`, `plugin.json` e `CHANGELOG.md` aplicados nesta entrega. Mudança de comportamento de agente e os hooks só valem **após atualizar o plugin e reiniciar a sessão**.

---
## v3.38 — Medir custo e resultado: Categoria e Unidade no registro de consumo, bloco "Custo × resultado" na retrospectiva, modelo de benchmark A/B/C e "História de origem" no defeito (SM + PO + QA) — 02/10/2026

**Instrução** (stakeholder, `/review`; decisões P1–P4 do formulário de 02/10/2026): "aplicar a proposta em `proposta-evaluation.md`" — saber se o plugin aumenta a qualidade com custo otimizado ou não faz diferença frente ao Claude sem ele, com o registro de consumo já em uso num projeto novo. Primeira da rodada `evaluation` → `guards` → `fix`.
**Classificação:** formato de documento (colunas, bloco, modelo, campo) · propriedade de artefato (`benchmark/`) · cerimônia (retrospectiva). **Sem regra nova; carga fixa zero** (`commands/` e `agents/` intactos).

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/scrum-master/templates/consumption.md` | tabelas · §Como gravar · §Regras | Colunas **Categoria** e **Unidade** (modelo e variante fora de sprint). Regra de `retrabalho` (invocação depois do primeiro ⚠️/❌ ou de 🔺 GAP). **Linha de sessão** (`/usage` colado, custo US$ observado) com **premissa R7 própria, distinta da do `operator`**: até a verificação no piloto **não se soma** às linhas por invocação, é lida à parte |
| `roles/scrum-master/templates/retrospective.md` | bloco novo · Regras | "Custo × resultado" (8 indicadores, leitura em 3 linhas, no máximo uma ação). Fonte de "Defeitos que escaparam" = `pending.md` (a janela de 2 sprints atravessa a pasta); conta só `H-nnn` + sprint do aceite dentro da janela |
| `roles/scrum-master/templates/benchmark.md` *(novo)* | — | Experimento A/B/C (+ B′ opcional, habilitado quando `guards` estiver aplicada). Regra de decisão **datada antes da 1ª execução**: 50% · 3× · 25% como padrão, linha "inconclusivo → ampliar a amostra", **diferença mínima de 3 defeitos** |
| `process/artifact-ownership.md` §1 · `deliverables/team-project/README.md` · `roles/scrum-master/README.md` | linha `.team-project/benchmark/` · índice de modelos | Dono SM; stakeholder executa os braços; não semeada |
| `process/workflow-processo.md` | §5c | A pegada estática convive com "Custo × resultado"; não se somam |
| `roles/product-owner/` (`README.md` · `skills.md` · `templates/note.md`) | `/po bug` passo 6 · `/po note` passo 3 · skill 8 | **História de origem** (`H-nnn` + sprint do aceite, lida do quadro e dos dossiês, sem abrir código; janela de 2 sprints; "fora da janela" · "não identificada"); passada à QA no `/qa bug` e citada no Product Backlog; orientação opcional ao stakeholder em `note.md` |
| `roles/quality-assurance/` (`README.md` · `skills.md` · `templates/gap-record.md`) · `deliverables/implementation/pending.md` | "Defeito reportado pelo stakeholder" passo 2 · competência 12 · "Abrir um GAP" · formato e regra | Grava a História de origem **como o PO passou, sem reinterpretar** (quatro valores); "não identificada" só se resolve com `arquivo:linha`; entrada `Origem: stakeholder` sem o campo é formato incompleto e não conta no resumo (§2, §2.1) |

### Por quê
"O plugin compensa?" não tinha resposta com dado: o processo media o tamanho dos próprios documentos e o consumo por invocação, mas não **o que o produto ganhou** nem **onde o custo está**. Sem Categoria e Unidade o corte de custo é chute; sem a História de origem não há "defeito que escapou", o indicador que mede o que o processo existe para impedir; sem regra de decisão datada antes, qualquer resultado confirma o que já se acreditava. A premissa própria da linha de sessão existe porque **não se sabe** se o `/usage` já inclui os subagentes — somar às cegas dobraria o custo (R7: sem evidência, não aconteceu).

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Sessão que orquestra | Preenche Categoria e Unidade por classificação (nunca estimativa); grava a linha de sessão do `/usage` quando o stakeholder a cola |
| SM | Preenche "Custo × resultado" na retrospectiva; mantém `benchmark/` quando o stakeholder abre o experimento |
| PO | No `/po bug`, registra a História de origem de defeito em funcionalidade já aceita |
| QA | Transcreve o campo no `pending.md` sem reinterpretar; entrada `Origem: stakeholder` sem ele é formato incompleto |
| Stakeholder | Roda `/usage` no fim da sessão e cola; executa os braços do benchmark |

### Conflitos com o processo vigente
- **R7** (nunca estimar): custo US$ só do `/usage` (observado) ou derivado na retrospectiva, com fórmula e preço ao lado; Categoria é classificação mecânica. **R28** inalterada: o `operator` entra como `verificação`. **§1c:** `benchmark/` fica fora da pasta do sprint de propósito (atravessa sprints, como o spike).
- **Auto-contradição corrigida (SM):** "Métrica sem fonte não entra… todas na pasta do próprio sprint" excluía o `pending.md`, fonte de "Defeitos que escaparam"; exceção declarada em `retrospective.md`.
- **Escalado e decidido pelo stakeholder (ver "Decisões" abaixo; o nome "História de origem" nas linhas acima é o da primeira redação, hoje "História do aceite"):** (1) **homonímia** — "História de origem" já é o campo Task→História de R20 (Sprint Backlog, `agents/scrum-master.md`, retrospectiva, `working-rules`); o campo novo é outro objeto (a História aceita onde o defeito nasceu). Candidato: renomear o novo para "História do aceite" no PO, QA e `pending.md`. (2) **"fora da janela"** — o PO o descreve como a mesma `H-nnn` "marcada fora da janela"; QA, `gap-record.md` e `pending.md` o listam como valor **alternativo** a `H-nnn`. Falta dizer se o ID acompanha o marcador. (3) **"não aplicável"** aparece no PO só no passo 7 e em `/po note`, não no passo 6 que define os valores; os três documentos de QA o têm entre os quatro.

### Como saberemos que funcionou
Na **primeira retrospectiva** depois da aplicação: "Custo × resultado" preenchido, com no máximo **uma** célula "não disponível" por indicador e a fração `cerimônia` conhecida. Nos defeitos do stakeholder do período: 100% das entradas `Origem: stakeholder` com a linha `História de origem`. Quando o stakeholder abrir o benchmark: `protocol.md` com a regra datada antes do 1º resultado e `result.md` lido por ela, sem limiar alterado. A premissa da linha de sessão fecha na verificação do piloto; se não fechar em dois sprints, volta ao `/review`.

### Evidência (R19)
Reexecutada pelo SM na curadoria, em amostra de cada papel.
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão (SM) | `Grep` do cabeçalho `\| Data \| Papel \| Modelo \| Comando \| Task/História \|` em todo o repositório (sem `proposta-*.md`) | 2 ocorrências, ambas em `consumption.md` (linhas 20 e 37), as duas com `Categoria \| Unidade \| Tokens`; `Categoria` nas linhas 20, 37, 40, 61, 81 | ✅ |
| Referência (SM) | `Grep -c benchmark` fora de `proposta-*.md`; `rituals/benchmark` em `roles/scrum-master/` | `team-project/README.md` 1 · `scrum-master/README.md` 1 · `benchmark.md` 3 · `artifact-ownership.md` 1 (todas para `templates/benchmark.md`); `rituals/benchmark`: 0 — nenhum ponteiro órfão | ✅ |
| Contagem (PO) | `Select-String 'História de origem'` por arquivo, em `roles/product-owner/` (sem changelog) | `README.md` 3 · `skills.md` 1 · `templates/note.md` 3 = 7 linhas em 3 arquivos | ✅ |
| Contagem (QA) | idem em `roles/quality-assurance/` e `pending.md` | `README.md` 1 · `skills.md` 1 · `gap-record.md` 4; `pending.md` linhas 52, 72, 82 | ✅ |
| Arquivamento | entrada v3.35 movida; `Contains` do texto de `HEAD` no arquivo | True (17.555 caracteres); `process-changelog.md` fica com v3.38, v3.37, v3.36 | ✅ |
| Carga fixa | `git status --porcelain commands agents rituals how-to.md README.md CHANGELOG.md .claude-plugin` | vazio — nada alterado ali; 13 arquivos modificados + `benchmark.md` novo, todos de `roles/` e `deliverables/` | ✅ |
| Migração (T14) | leitura de `rituals/team-update.md` passo 8 e `deliverables/team-project/README.md` linhas 20, 53 e 76 | `consumption.md` (sprint) e `.team-project/consumption.md` (fora de sprint) constam como "Sim — estrutura"; o passo 8 mostra o delta de coluna e pede aprovação por arquivo; sprint fechado é "histórico imutável — não reconcilie" | ✅ — `team-update.md` **não muda** |

**Migração:** a coluna nova entra no meio da tabela; ao aprovar o delta, as linhas existentes ganham duas células vazias — passado não se reconstrói.

### Decisões do stakeholder (formulário de 02/10/2026) sobre "Para escalar"
1. **Homonímia:** o campo novo do defeito passa a se chamar **"História do aceite"** (PO, QA, `pending.md` e `retrospective.md` renomeados); "História de origem" fica só para o campo Task→História de R20.
2. **"fora da janela" leva o ID.** Quatro valores: `H-nnn + sprint do aceite` · `H-nnn · fora da janela` · `não identificada` · `não aplicável`. Nota da retrospectiva alinhada (só o primeiro entra na contagem).
3. **"não aplicável" no passo 6 do `/po bug`:** o PO completa a lista de valores.

### Aplicado pela sessão, por decisão do stakeholder
`rituals/benchmark.md` (novo, sob demanda) · `commands/po.md` (modo `bug`) · `commands/qa.md` · `how-to.md` (cenário H) · versão **v3.38.0** (`plugin.json`, `README.md`, `CHANGELOG.md`, R18). Pontos de coerência do SM para `rituals/benchmark.md` (`templates/benchmark.md`, `artifact-ownership.md` §1, `deliverables/team-project/README.md`, `review-contract.md`): acrescentados em `templates/benchmark.md`, `artifact-ownership.md` §1 e `deliverables/team-project/README.md`; `review-contract.md` **não enumera rituais** (conferido), nada a apontar. `roles/scrum-master/README.md` já aponta para o modelo e fica como está.

### Pendente
- **Verificação da premissa da linha de sessão** no projeto-piloto: um `/po status` com `/usage` antes e depois, comparado com a linha do PO; o resultado volta ao `/review`.
- **Reiniciar a sessão** (mudança de comando só vale depois) e **`/team update`** nos projetos.
