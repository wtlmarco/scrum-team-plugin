# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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
