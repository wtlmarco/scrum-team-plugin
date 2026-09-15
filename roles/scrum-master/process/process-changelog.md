# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v3.17 — Registro de consumo do time: propriedade, modelo e gancho no ciclo de eficiência; gravação e exibição propostas ao stakeholder (SM) — 15/09/2026

> **Fecho do `/review note` — três itens, um assunto.** Os três de `RAIZ/note.md` são "não há contabilidade de custo do time", escritos como sintomas separados. Insumo apurado nesta sessão: a coleta não exige mecanismo novo — quando um subagente termina, a sessão que o disparou já recebe tokens e duração (evidência real: 205k/136k/21k/224k/83k nesta sessão); faltava alguém gravar, e onde.

**Instrução:** *(stakeholder, via `/review note`)* (1) "Não sei quanto o time custou neste projeto. Desde o `/team init` não há registro de consumo por papel nem por período..."; (2) "A retrospectiva e o `/review metrics` discutem eficiência sem número real de consumo — só a pegada estática..."; (3) "Não há onde consultar o consumo acumulado do time no projeto sem abrir changelog e somar na mão."

**Triagem:**

| Item | Classificação | Documento-alvo | Papel dono |
|---|---|---|---|
| 1 — sem registro de consumo | propriedade de artefato (novo) | `artifact-ownership.md` + `templates/consumption-log.md` + manifesto `deliverables/team-project/README.md` | SM (aplicado) |
| 2 — eficiência sem número real | etapa de fluxo (`workflow.md` §5c) + formato de documento (`templates/retrospective.md`) | os dois | SM (aplicado) |
| 3 — sem consulta agregada | comportamento de agente (exibição em `/team version`) | `team-version.md` | stakeholder (**proposta**, não aplicada) |

A gravação da linha após cada subagente retornar também é comportamento de agente, em `commands/*` — **proposta**, não aplicada.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `artifact-ownership.md` | §1, linha nova | Registro de consumo do time — dono SM, `.team-project/scrum-master/consumption-log.md`, modelo `templates/consumption-log.md` |
| `roles/scrum-master/templates/consumption-log.md` | arquivo novo (34 linhas) | Uma linha por invocação (data · papel · comando · Task/História · tokens · duração · nota), totais derivados por papel, nota do que o número não mede, relação com `/review metrics` |
| `roles/scrum-master/README.md` | "Documentos que administro" | Linha nova apontando ao modelo |
| `deliverables/team-project/README.md` | Manifesto | Linha nova, classe "estrutura + conteúdo local" |
| `team-init.md` | árvore do passo 2 + prosa | `consumption-log.md` somado a `scrum-master/` (coerência de referência cruzada — SM aplica) |
| `roles/scrum-master/process/workflow.md` | §5c | Parágrafo novo: pegada estática × consumo real convivem, nunca se somam; Check cita os dois quando o registro existe, Act usa a divergência como achado |
| `roles/scrum-master/templates/retrospective.md` | Métricas do sprint + Regras | Linha nova de consumo real por sprint (`n/a` sem registro) + nota de que mede trabalho dos papéis, não a sessão |

### Por quê
A pegada estática de `/review metrics` — hoje a única leitura — mede o custo fixo do *processo*, igual em todo projeto; não mede o que o time gastou *construindo o produto*, que varia por projeto e sprint. Sem o segundo número, "esse papel está caro" era palpite, e a fase Check comparava a única métrica que tinha, proxy desde a v3.2. A sessão principal não enxerga o próprio consumo — por isso os três documentos tocados declaram que o número mede o **trabalho dos papéis**, não o custo total: sem a ressalva, o total seria lido como se fosse a sessão inteira.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| SM | Dono do modelo e da propriedade; soma o consumo real na retrospectiva quando o registro existe |
| Demais papéis | Nenhum grava a própria linha — quem grava é sempre a sessão que orquestrou aquela invocação (fato apurado nesta sessão), nunca o papel |
| stakeholder | Duas propostas de texto pronto e duas decisões escaladas, ambas abaixo |

### Conflitos com o processo vigente
Nenhum. O registro novo não substitui `/review metrics` — o parágrafo de `workflow.md` §5c existe justamente para as duas medidas não virarem duas verdades sobre "custo".

### Decisões escaladas — não decidi sozinho
1. **Retenção.** Sem política, o registro cresce sem fim e repete o modo de falha que R17 já corrigiu no changelog (v1.0→v1.8, 12× em nove versões). Opções: **(a)** manter tudo; **(b)** arquivar por sprint fechado, padrão R17 (só o total do sprint fica no vivo); **(c)** o SM decide caso a caso. **Recomendação:** (b). Até a decisão, o modelo não remove nem arquiva nenhuma linha — conservador por padrão, não a política final.
2. **Granularidade do que entra.** Toda invocação vira linha, mesmo a trivial (ex.: "Arquiteto trocando uma palavra", 21k tokens), ou só as que tocam Task/História? Opções: **(a)** toda invocação; **(b)** só as ligadas a Task/História — mais enxuto, perde o custo de coordenação avulsa. **Recomendação:** (a), até haver volume real para julgar — filtrar depois é mais barato que reconstruir o que não foi gravado.

Terceira dúvida do mesmo tipo, **não escalada**: número indisponível. Resolvida por extensão direta de R7 — "não disponível — <motivo>", nunca estimar. É regra vigente, não decisão nova.

### Como saberemos que funcionou
Próxima retrospectiva (repositório-fonte ou projeto instalado) cita a linha de consumo real ao lado da carga fixa sem confundir as duas. Próximo `/review metrics` compara as duas medidas sem somá-las. Se o stakeholder aprovar as propostas abaixo, a próxima entrega registra a primeira linha real do registro e a primeira consulta agregada por `/team version`.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | `Compare-Object` do bloco `## v3.14` pré-sessão (`git show HEAD:...`, 64 linhas) × relocado em `process-changelog-archive.md` (64 linhas) | 0 diferenças | ✅ |
| Extração/criação de arquivo | `(Get-Content roles\scrum-master\templates\consumption-log.md).Count` | arquivo não existia antes (0); 34 linhas depois — referenciado por `artifact-ownership.md`, `roles/scrum-master/README.md`, `deliverables/team-project/README.md`, `workflow.md`, `retrospective.md` | ✅ |
| Substituição/extensão de padrão | `Select-String -Path * -Pattern "consumption-log" -Recurse` (RAIZ) | 9 ocorrências em 7 arquivos (`deliverables/team-project/README.md`, `team-init.md` ×2, `artifact-ownership.md`, `workflow.md`, `roles/scrum-master/README.md`, `retrospective.md`, o próprio `consumption-log.md`) — cada uma lida no contexto: manifesto, árvore + prosa de `team-init.md`, linha de matriz, parágrafo §5c, linha da tabela de documentos, linha de métrica; nenhuma órfã ou contraditória | ✅ |
| Fronteira não ultrapassada | `git status --porcelain` | só arquivos do alcance do SM tocados (listados em "O que mudou" + tríade de versão + este bloco); `commands/*`, `agents/*`, `team-version.md` intocados — as duas propostas ficam pendentes | ✅ |
| Tríade do R18 | `plugin.json`, topo `CHANGELOG.md`, banner `README.md` | os três `3.17.0` | ✅ |

### Pendente do stakeholder
**Duas decisões escaladas** (retenção e granularidade — ver acima), mais **duas propostas de texto pronto**, não aplicadas (`commands/*` e `team-version.md` são do stakeholder):

**1. Gravação — mesmo texto em `commands/sm.md`, `commands/po.md`, `commands/arc.md`, `commands/ux.md`, `commands/qa.md`, `commands/dev.md`** (trocar `<papel>`):
```
## Registro de consumo (se `.team-project/scrum-master/consumption-log.md` existir)
Ao subagente retornar, você — a sessão que orquestrou — recebe o total de tokens e a duração desta invocação. Acrescente uma linha ao registro: data, papel `<papel>`, comando, Task/História (se houver), tokens, duração. Número indisponível: registre "não disponível — <motivo>", nunca estime (R7).
```
Em `commands/team.md`, mesmo texto, no plural — "uma linha por subagente disparado nesta invocação".

**2. Exibição — `team-version.md`, item novo "e) O que o time gastou de fato", após o item d) existente:**
```
## e) O que o time gastou de fato (se houver registro)
Se `.team-project/scrum-master/consumption-log.md` existir, leia os totais e responda a soma por papel do período pedido (ou o acumulado, se não especificado) — tokens e nº de invocações. Deixe explícito que este número mede o trabalho dos papéis — a sessão principal não se autoobserva, e o total de uma sessão inteira não está aqui. Se o registro não existir, diga isso.
```

**Item 3 de `note.md` permanece na fila** — a resolução inteira dele é esta segunda proposta, não aplicada; itens 1 e 2 saem, por terem aplicação real neste ciclo.

**Mudança de comportamento de agente/comando não se aplica** — nenhum `agents/`/`commands/` foi tocado; as duas propostas só valem, se aprovadas, após reiniciar a sessão.

---

## v3.16 — Tabela de custo remedida (v3.4 → v3.16) e R18 realinhada ao modelo de branch em uso (`develop`, empilhamento) (SM) — 14/09/2026

> **Duas mudanças do alcance do SM**, roteadas por `/review` direto (sem passar por `note.md`). A primeira fecha o item 1 da fila de `note.md`: a tabela de custo por comando de `workflow.md` §5c avisava, desde a própria v3.4, que "tabela de custo que não se remede vira folclore" — nunca tinha sido remedida. A segunda nasceu de uma observação do stakeholder ao pedir esta própria entrega ("gere uma branch a partir de `develop`"), contrastada com a prática registrada em `CHANGELOG.md` desde a `v3.6.0`.

**Instrução:** *(stakeholder, via `/review`)* Remedir a tabela de custo com os números atuais, anexar o comando de medição e datar; realinhar R18 ao modelo de branch (`develop`) que o time já usa, cobrindo também o caso de branch empilhada — com a alçada de PARAR e escalar se a mudança de modelo de branch fosse julgada decisão estratégica do stakeholder em vez de reconciliação. Avaliada: não é — é reconciliação de normativo contra prática já registrada e confirmada nesta mesma sessão.

**Classificação:** formato de documento (tabela de custo, `workflow.md` §5c) + regra (R18, `working-rules.md`) + coerência de referência cruzada (`workflow.md` §5d/§8, `CHANGELOG.md` cabeçalho, `README.md`, `templates/retrospective.md`).

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/scrum-master/process/workflow.md` | §5c, tabela "Custo por comando" | Números da v3.4 substituídos pelos atuais (SM 15,4 · PO 16,7 · UX 11,2 · Arquiteto 10,4 · QA 11,1 · dev 7,1 KB); `/team brainstorm` ~37→~39 KB, `/team cycle` ~26→~27 KB, `/review` ~15→~14 KB de base; comando de medição anexado (`Get-ChildItem agents,commands -File \| Select-Object Name,Length`) e a nota datada (14/09/2026) |
| `roles/scrum-master/process/working-rules.md` | R18 (corpo, Evita, SM verifica) | "a partir de `main`, PR para `main`" → "a partir de `develop` — ou empilhada —, PR para `develop`"; `main` descrita como linha estável que recebe `develop` por decisão do stakeholder; "SM verifica" trocado de `git log main` para `git log develop` |
| `roles/scrum-master/process/workflow.md` | §5d "Ciclo de uma entrega" (passo 1 e 3) | Passo 1 cobre branch empilhada com os dois precedentes (`v3.14.0`, `v3.16.0`); passo 3 explica `main`/`develop`; passo 6 menciona declarar a base quando empilhada |
| `roles/scrum-master/process/workflow.md` | §8, linha do gate de entrega | "merge do PR em `main`" → "merge do PR em `develop`" |
| `roles/scrum-master/templates/retrospective.md` | linha de indicador R18 | "merge em `main`" → "merge em `develop`" |
| `CHANGELOG.md` | cabeçalho do ritual (linhas 6-10) | Realinhado ao mesmo modelo, coerência de referência cruzada com R18 (curadoria do SM em guia de raiz) |
| `README.md` | linha 4, banner de versionamento | "a partir de `main`" → "a partir de `develop` (ou empilhada), PR para `develop`" — mesma curadoria de referência cruzada |

### Por quê
A tabela de custo é a base numérica de toda decisão do ciclo de eficiência (`workflow.md` §5c/§5d) — com números de nove versões atrás, o giro **Act** corta no lugar errado. O achado que mais importa: a carga fixa do **PO** cresceu **13 → 16,7 KB (+28%)** sem que nenhum giro de `/review metrics` o notasse, porque a tabela nunca foi remedida para comparar. R18 descrevia um modelo de branch que zero entregas reais seguem desde a `v3.6.0` (evidência no próprio `CHANGELOG.md`: `v3.10.0`, `v3.14.0`, `v3.14.1`, `v3.15.0` todas saem para `develop`) — normativo que a prática já abandonou sem ninguém atualizar é o mesmo modo de falha da tabela de custo, só que em regra em vez de número.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| SM | próxima remedição da tabela de custo é mecânica (comando anexado), não arqueologia; toda entrega nova declara base `develop` (ou a branch empilhada) na entrada do `CHANGELOG.md`, e o SM verifica contra `git log develop`, não `main` |
| Demais papéis | sem mudança de prática — nenhum já seguia o modelo antigo |

### Conflitos com o processo vigente
Nenhum de conteúdo. Uma divergência **não** aplicada, registrada abaixo.

**Divergência registrada — proposta recusada.** Eu (SM) havia sugerido, na mesma sessão, remover a seção "Evolução dos seus documentos — `/review`" dos 5 `agents/*.md` (economia de carga fixa). **Recusada na condução do `/review`**, não pelo stakeholder — que depois autorizou a entrega com a recusa já dentro dela. Motivo, registrado sem suavizar: aquele bloco já é o resultado da compressão feita na v2.7 (`process-changelog-archive.md:1031`) e carrega duas salvaguardas ausentes de `commands/review.md:57` — "nunca escreva em `${CLAUDE_PLUGIN_ROOT}`" e "sem a RAIZ, pare e peça" — que corrigem um defeito observado em campo (`process-changelog-archive.md:869`: quatro papéis lendo o contrato da cópia instalada). Cortar 2,4 KB reabriria esse modo de falha. Não aplicada; não entra em `agents/*.md`.

### Como saberemos que funcionou
Próximo giro de `/review metrics` (§5c) remede a tabela usando o comando anexado sem precisar reconstruir a metodologia; o Δ contra esta remedição aparece sem surpresa de duas dígitos como a do PO nesta entrada. Próxima entrega nova declara `fix/vX.Y.Z` a partir de `develop` (ou empilhada, com a base nomeada) na entrada do `CHANGELOG.md`, sem citar `main` como origem.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | `Get-ChildItem -Recurse -Include *.md \| Where-Object { $_.FullName -notmatch 'changelog' -and $_.FullName -notmatch 'CHANGELOG' } \| Select-String -Pattern "a partir de \`main\`\|PR para \`main\`"` | 0 ocorrências (excluídos `CHANGELOG.md`/`*changelog*.md`, onde entradas históricas narram corretamente o modelo antigo em vigor na época — não se reescrevem, R17) | ✅ |
| Substituição de padrão | `Select-String -Path roles\scrum-master\process\workflow.md -Pattern "~37 KB\|~26 KB\|Medidos em v3.4\|15 . 13 . 11 . 10 . 10 . 7 KB"` | 0 ocorrências | ✅ |
| Substituição de padrão — leitura em contexto | `working-rules.md` R18 completa, `workflow.md` §5d passos 1/3/6, §8 linha do gate, `templates/retrospective.md` linha do indicador, `CHANGELOG.md:6-10`, `README.md:4` | cada ocorrência nova é coerente com o texto ao lado — nenhuma menciona `main` como origem de branch; `main` só aparece como linha estável que recebe `develop` | ✅ |
| Arquivamento de entrada (pré-condição do teto de 3 — `process-changelog.md:10`, esta entrada some a 4ª) | `Compare-Object` do bloco `## v3.13` pré-sessão (64 linhas, índice 178..241 do array de linhas) × relocado em `process-changelog-archive.md` (índice 10..73) | 0 diferenças — bloco idêntico, só a posição mudou | ✅ |
| Fronteira não ultrapassada | `git status --porcelain` | 8 arquivos, todos do alcance do SM: `plugin.json`, `CHANGELOG.md`, `README.md` (tríade R18 + curadoria de referência cruzada), `process-changelog-archive.md`, `process-changelog.md`, `workflow.md`, `working-rules.md`, `templates/retrospective.md` | ✅ |
| Tríade do R18 | `plugin.json`, topo `CHANGELOG.md`, banner `README.md` | os três `3.16.0` | ✅ |

### Pendente do stakeholder
Nada novo. A divergência sobre remover a seção `/review` dos `agents/*.md` já foi decidida (recusada) — ver acima.

**Mudança de comportamento de agente/comando não se aplica** — nenhum `agents/`/`commands/` foi tocado.

---

## v3.15 — `/po accept` alinhado a R21, vão de alcance do `/review` fechado, resíduo de find-replace e numeração da própria entrada corrigidos (SM + Arquiteto) — 14/09/2026

> **Fecho do `/review audit` desta sessão, em duas rodadas.** 1ª: três achados do audit original — **(1)** alta, `/po accept` mirando Task contra R21 em `commands/qa.md`/`commands/team.md`; **(2)** média, `02-status.md`/`deliverables/README.md` sem linha na tabela de alcance; **(3)** baixa, resíduo `item`→`Task` em 4+1 documentos (parte do Arquiteto em `standards/`, aplicada e verificada por ele, só consolidada aqui). 2ª: um code review independente sobre o trabalho ainda não commitado achou 9 defeitos nesta própria aplicação — corrigidos abaixo, marcados **2ª rodada**.

**Instrução:** *(stakeholder)* 1ª rodada — "dispare todas as correções" em `agents/`/`commands/`/raiz, mais decisão sobre `deliverables/README.md` entrar no alcance do SM e bump da tríade. 2ª rodada — autorização explícita para corrigir os 9 achados do code review, inclusive em `commands/` e na tríade de versão.

**Classificação:** regra (R21) + escopo de papel (alcance do `review-contract.md`) + propriedade de artefato (`artifact-ownership.md`, linha nova) + formato de documento (concordância verbal; numeração da própria entrada).

**Conflito — numeração da entrada (achado 6).** Nasceu `v3.14.2`, três partes, copiando o `CHANGELOG.md` em vez da convenção `vX.Y` deste changelog. Ainda não commitada nem publicada quando corrigida — não é "entrada antiga" protegida contra reescrita (R17/linha 6): terminar de escrevê-la no lugar certo é fechamento, não reescrita. **Resolução:** renumerada `v3.15`. Consequência por R18 ("entrada nova sai como `vX.Y.0`"): a entrega no `CHANGELOG.md` deixava de casar sendo `v3.14.2` (PATCH sobre a linha `3.14`, que não carregava entrada nova) — renumerada `v3.15.0`, com `plugin.json`/banner do `README.md`/branch atualizados junto. Não reescreve `v3.14`/`v3.14.1`. Tratada como reconciliação de referência cruzada dentro do próprio alcance do SM (R18), não escalada; registrada para o stakeholder reverter se discordar do enquadramento.

### O que mudou
| Documento | Mudança |
|---|---|
| `commands/qa.md:24` | `/po accept <ID>` → `/sm close <ID>` no ✅; aceite explicado como posterior (R21) |
| `commands/team.md:70` | mesma correção; **2ª rodada** — metade ⚠️/❌ ainda dizia "não siga para o **aceite**" → "para o **fechamento**" |
| `agents/developer.md:42` · `deliverables/README.md:36` · `deliverables/implementation/02-status.md:3` | resíduo `permTask`/"é fechado" → concordância corrigida |
| `standards/implementation-quality.md:194` *(Arquiteto, R16)* | idem, "os dois permTask que" → "permitem que" |
| `review-contract.md` (alcance do SM) | **2ª rodada** — passa a citar os **três** índices transversais, não só dois |
| `artifact-ownership.md` §1 *(2ª rodada, não tocado na 1ª)* | linha nova: `deliverables/README.md`, `deliverables/implementation/README.md`, `deliverables/team-project/README.md` — dono **SM**, curadoria |
| `process-changelog-archive.md` *(2ª rodada, ausente da 1ª)* | `## v3.12` relocado — pré-condição do teto de 3 (`process-changelog.md:10`) para esta entrada caber |
| `.claude-plugin/plugin.json` · `CHANGELOG.md` · `README.md` | tríade R18 → `3.15.0` (**2ª rodada**, não `3.14.2` — ver conflito acima) |

### Por quê
`/po accept <ID>` mirava Task antes de `/sm close`, contra R21 desde a v3.3 — alvo e ordem errados, sugerindo aceite antes do fechamento técnico; a 1ª rodada corrigiu só a metade ✅ de `commands/team.md:70`. `02-status.md` já tinha dono declarado sem linha de alcance; `deliverables/README.md` **não tinha dono em lugar nenhum** (a 1ª rodada afirmou o contrário, por engano) — mesma lacuna, não notada, em `deliverables/implementation/README.md` e `deliverables/team-project/README.md` (este último já tratado como "do SM" desde a `v3.13`, sem nunca entrar na matriz). Resíduo do find-replace `item`→`Task`: 13 ocorrências já corrigidas antes (`process-changelog-archive.md:724`), estas cinco sobreviveram — a de `standards/` deixava a frase sem verbo, standard ilegível é standard não seguido (achado do Arquiteto).

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| SM | orienta `/sm close <ID>` direto no ✅ sem citar `/po accept`; devolução em ⚠️/❌ não sugere mais aceite; cura os três índices transversais, agora também na matriz de propriedade |
| PO | sem mudança de prática — só sai a instrução divergente dos dois comandos |
| Arquiteto | corrige a própria frase normativa em `standards/`, sem mudança de prática |
| dev, QA | leem `standards/implementation-quality.md:194` completo |

### Conflitos com o processo vigente
Nenhum de conteúdo. O único conflito é de forma (numeração), resolvido dentro do alcance do SM — ver acima.

### Como saberemos que funcionou
`/qa <ID>`/`/team cycle` com ✅ recomenda `/sm close`; com ⚠️/❌ não sugere aceite em nenhuma das duas metades. Achado de processo em qualquer um dos três índices chega ao SM pela tabela de alcance **e** encontra dono na matriz. Próxima entrada nova deste changelog nasce `vX.Y`, nunca três partes.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | `Grep "permTask" path=agents/` e `path=standards/` | 0 ocorrências | ✅ |
| Substituição de padrão | `Grep "/po accept <ID>" path=commands/` | 0 — demais usos são `<H-ID>` ou citam a forma antiga como exemplo (`CHANGELOG.md:230` — **2ª rodada:** ponteiro corrigido de `:210`, deslocado pela inserção desta entrada) | ✅ |
| Substituição de padrão — **2ª rodada, comando reescrito** | `Select-String "Task é fechado\|Task está pronto\|permTask"` em `*.md` de RAIZ **excluindo changelogs** (`*changelog*.md`, `CHANGELOG.md` — convenção de "arquivos vivos" de `working-rules.md` §5c) | 0 ocorrências | ✅ *(a 1ª rodada rodou sem excluir changelogs; deixa de ser reproduzível assim que a própria entrada cita as strings como exemplo — 9 ocorrências sem exclusão, não é regressão)* |
| Leitura em contexto — **2ª rodada, ampliada** | `commands/qa.md:24`, `commands/team.md:70` (as duas metades), `review-contract.md:17-23`, `artifact-ownership.md` (linha nova) | nenhuma metade sugere aceite antes do fechamento; sem sobreposição com PO/QA/Arquiteto/UX; linha nova da matriz não contradiz dono existente de nenhum documento interno | ✅ |
| Substituição — leitura em contexto *(Arquiteto)* | linhas 190-195 de `standards/implementation-quality.md` | antecedente plural explícito, concordância correta, referência a nível 1 §5.4 intacta | ✅ |
| Escopo *(Arquiteto)* | `git --no-pager diff -- standards/implementation-quality.md` | 1 linha, 1 arquivo | ✅ |
| **Arquivamento de entrada — 2ª rodada, ausente na 1ª** | `Compare-Object` do bloco `## v3.12` pré-sessão (`git show HEAD:...`, 55 linhas) × relocado em `process-changelog-archive.md` (58 linhas) | 0 diferenças de conteúdo — as 3 linhas a mais são o separador (branco + `---` + branco), padrão das linhas 9/67 do arquivo; `## v3.12` sumiu do changelog vivo | ✅ *(números do achado — 55/57/dif. 2 — eram estimativa; real é 55/58/dif. 3, íntegra em separador)* |
| Tríade do R18 | `plugin.json`, topo `CHANGELOG.md`, banner `README.md` | os três `3.15.0` (**2ª rodada**, renumerado de `3.14.2`) | ✅ |
| Coerência de referência cruzada *(2ª rodada)* | `Select-String "v3\.14\.2"` em `*.md`, fora de `*changelog*` | 2, ambas narrativas (explicam o número antigo, não apontam para ele): `CHANGELOG.md:20`, esta entrada | ✅ |
| Fronteira não ultrapassada — **2ª rodada, contagem corrigida** | `git --no-pager diff --stat` | **14 arquivos** (13 nossos + `note.md`, do stakeholder, não tocado): os 9 de "O que mudou" + tríade de versão + este bloco | ✅ *(1ª rodada registrou 11, omitindo `process-changelog-archive.md`)* |

### Pendente do stakeholder
Nada novo. Renumeração (achado 6): reconciliação de referência cruzada, não escalada — ver "Conflito" acima. Índices do achado 4 (`implementation/README.md`, `team-project/README.md`): fechados nesta entrada, não deixados pendentes — propriedade dedutível dos normativos (índices transversais sem outro papel reivindicando; o segundo já tinha precedente textual na `v3.13`).

