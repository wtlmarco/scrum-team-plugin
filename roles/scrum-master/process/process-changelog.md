# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

---

## v3.14 — Nascimento dos documentos de implementação declarado, rastreio de pendências no onboarding, bug do stakeholder no fluxo e em `.team-project/note.md`, e curadoria da rodada (SM) — 12/09/2026

> **Fecho da rodada de `/review note`** que também produziu `v3.12` (QA) e `v3.13` (PO). Cobre os itens 1 (reformulado pela própria triagem), 5 e 6 de `note.md`, a fatia de fluxo do item 4, e a curadoria do conjunto (consolidação, checagem de contradição, arquivamento por R17).

**Instrução:** *(stakeholder, decisões já fechadas na triagem)* **(A)** o manifesto não erra por omitir os 4 documentos de implementação — falta algo lembrar o SM de declará-los quando nascem. **(B)** rastrear no onboarding bugs/pendências existentes, sem duplicar `/qa audit`/`/qa baseline`. **(C)** refletir no fluxo que o bug do stakeholder entra pelo PO (já decidido em `v3.12`/`v3.13`). **(D)** `.team-project/note.md` (criado por `v3.13`) precisa nascer no `/team init`. **(E)** o homônimo `note` (agora três artefatos) entra em `artifact-ownership.md` §1b, com a régua aplicada às listas "Não faz"/"Proibido". **(F)** ordem explícita para atualizar `RAIZ/how-to.md` com o uso de `.team-project/note.md`.

**Classificação:** fluxo (`workflow.md` §5a/§6a/§6b) + propriedade de artefato (`artifact-ownership.md` §1/§1b) + formato de documento (manifesto, `project-context.md`) + guia de raiz por ordem explícita (`how-to.md`) + coerência de referência cruzada, exceção já declarada (`README.md`). Nenhum R novo — é tradução verificável de decisões já tomadas em `v3.12`/`v3.13`.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `workflow.md` | §5a | Documento de implementação nasce sob demanda e entra em `.team-project/README.md` §4 na mesma sessão; três fontes de pendência/bug a rastrear no onboarding (código retomado, doc herdada — já cobertas; defeito já conhecido do stakeholder → `/po bug` — nova); bullets na Condição de saída |
| | §6a | Canal do PO ganha "defeito que ele reporta"; bug não abre canal novo |
| | §6 (diagrama) · §6b | Linha nova de escalação do bug; nota — origem stakeholder não muda o degrau da escada de falha |
| `artifact-ownership.md` | §1 | Linha nova `.team-project/note.md`: dono stakeholder, tratado pelo PO |
| | §1b | Linha nova do homônimo **note** |
| `deliverables/team-project/README.md` | Manifesto | Linha nova `.team-project/note.md`, modelo do PO, classe estrutura + conteúdo local |
| `project-context.md` | árvore, tabela, §4, §8 | `note.md` na árvore/tabela; "Regra de nascimento" em §4; `/po` ganha `bug`/`note` em §8; caminho "Bug" reescrito para entrar por `/po bug` |
| `how-to.md` | comandos, novo parágrafo, caminho C | Linha `/po` com `bug`/`note`; parágrafo explicando `.team-project/note.md`; caminho C com o passo `/po bug` |
| `README.md` (raiz) | bloco de comandos | Linha `/po` com `bug`/`note` (referência cruzada) |
| *(addendum — decisão do "Pendente" abaixo)* | | |
| `workflow.md` | §6a/§6b | Bifurcação por **origem**: bug do stakeholder pelo PO (já estava) × bug do time direto na QA; parágrafo sobre a visão do PO via Product/Sprint Backlog quando o defeito interno vira Task; linha nova no diagrama §6 |
| `how-to.md` | caminho C | Duas entradas: a do stakeholder detalhada; a do time, uma frase de contexto |
| `project-context.md` | §8, linha "Bug" | Reescrita numa linha só, cobrindo as duas entradas |

### Por quê
**(A)** sem lembrete, cada projeto reinventa quando declarar os quatro documentos em §4. **(B)** pendência/bug pré-existente não capturado no primeiro contato se perde; faltava só a terceira fonte (o que o stakeholder já sabe quebrado), sem lugar formal antes desta rodada. **(C)** `§6a` fechava os canais do stakeholder sem citar bug — depois de `v3.12`/`v3.13`, o normativo geral precisava dizer isso, ou `/review audit` acharia a lacuna depois. **(D)** modelo que o `init` semeia e não entra no manifesto é o defeito que o manifesto existe para evitar (pendência que a própria `v3.13` já apontava a mim). **(E)** homônimo sem entrada em §1b é o mesmo modo de falha da `v3.4`. **(F)** pedido explícito — sem o guia, o arquivo novo da `v3.13` fica sem instrução de uso para quem não lê `roles/`.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| **SM** | Pergunta por defeito conhecido no onboarding; confirma documento novo em §4 na mesma sessão; `.team-project/note.md` nasce por manifesto no `init` |
| **PO** | `§6a`/diagrama registram formalmente o que já era prática desde `v3.13` |
| **QA** | Sem mudança de prática — `§6b` só declara em texto o que já valia |
| **stakeholder** | Lê em `how-to.md` para que serve `.team-project/note.md`; `/po bug`/`/po note` documentados sem divergência em três lugares |

### Conflitos com o processo vigente
Nenhum novo — os conflitos da rodada (canal direto stakeholder→QA; registro único) já vinham decididos. Curadoria: conferi três pontos de possível atrito entre `v3.12`/`v3.13`, sem divergência — (1) `/po note`/`/po bug` roteiam à QA para escrita, e `gap-record.md` (v3.12) mantém "dono único da escrita é o QA"; (2) `/po bug` (avulso) e `/po note` (fila) não se sobrepõem — o segundo aplica a **mesma** classificação do primeiro sobre fonte diferente; (3) "PO não confirma com evidência" tem a mesma substância nos dois lados.

### Como saberemos que funcionou
Próximo onboarding cita a pergunta sobre defeito conhecido (mesmo se "nenhum"); documento de implementação novo aparece em §4 na mesma sessão. Próximo `/team init` cria `.team-project/note.md` sem intervenção manual. Próxima leitura de "Não faz"/"Proibido" por qualquer papel: nenhuma recusa por "note" cru — não há ocorrência crua (confirmado nesta entrada). Próxima leitura de `how-to.md`: o stakeholder sabe o que escrever em `.team-project/note.md` e como `/po note` o esvazia, sem abrir `roles/`.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição/extensão de padrão | `Select-String -Path deliverables\team-project\README.md, roles\scrum-master\templates\project-context.md, roles\scrum-master\process\artifact-ownership.md, roles\scrum-master\process\workflow.md, how-to.md, README.md -Pattern 'note\.md\|/po bug\|/po note'` | 16 ocorrências nos 6 arquivos, cada uma lida no contexto (manifesto, árvore/tabela/§4/§8 de `project-context.md`, três parágrafos de `workflow.md`, explicação+tabela+caminho C de `how-to.md`, homônimo de `artifact-ownership.md`) — nenhuma órfã ou contraditória | ✅ |
| Substituição de padrão — coerência da linha `/po` | `Select-String -Path README.md, how-to.md, roles\scrum-master\templates\project-context.md -Pattern 'bug <relato>.*note'` | 5 ocorrências nos 3 arquivos (2 em `how-to.md` e em `project-context.md` — a linha de modos **e** o parágrafo/caminho que também cita os dois na mesma frase — 1 em `README.md`) — lidas no contexto, todas coerentes: `bug <relato>` sempre antes de `note`, nunca um sem o outro | ✅ |
| Verificação de homônimo (leitura, não `grep` — R19) | leitura de "Não faz" nos 6 `roles/*/README.md` e "Proibido" nos 6 `agents/*.md`; `Select-String -Path agents\*.md -Pattern 'note' -i` | zero ocorrências de "note" em `agents/*.md`; as 3 ocorrências fora das listas de proibição (`product-owner`, `architect`, `scrum-master`) já vêm qualificadas — nenhuma correção necessária | ✅ |
| Arquivamento de entrada | diff do bloco extraído (v3.11+v3.10+v3.9, 148 linhas) contra o texto realocado, comparado via `PowerShell -Raw` antes de gravar os dois arquivos | zero linhas de diferença fora do separador `---` inserido | ✅ |
| Fronteira não ultrapassada | `git status --porcelain` | arquivos deste agente: `README.md`, `deliverables/team-project/README.md`, `how-to.md`, `artifact-ownership.md`, `process-changelog.md`, `process-changelog-archive.md`, `workflow.md`, `project-context.md`; os demais são das entradas irmãs (`v3.12`/`v3.13`), não tocados por mim | ✅ |
| Substituição de padrão — addendum bifurcação | `Select-String -Path roles\scrum-master\process\workflow.md, how-to.md, roles\scrum-master\templates\project-context.md -Pattern 'passar pelo PO\|passar por você'` | 3 ocorrências, uma por arquivo, mesma origem-como-critério nas três, lidas no contexto — sem divergência | ✅ |
| Checagem semântica — visão do PO preservada | `workflow.md` §6a (parágrafo novo) vs. `roles/product-owner/README.md` passo 1 de `/po status` | parágrafo cita exatamente o que o PO já lê (Product + Sprint Backlog); nenhum canal novo criado, nenhum documento do PO mudou | ✅ |

### Pendente do stakeholder — resolvido nesta mesma entrada
Tinha ficado um ponto para sua decisão (R22): caminho C de `how-to.md` só com `/po bug` na frente, ou bifurcado por origem do achado. **Decisão: bifurcar**, pela **origem** — nunca por gravidade ou tipo:

- **Bug relatado pelo stakeholder** → PO (`/po bug`/`/po note`) classifica e só aciona a QA se for defeito. Já era assim, não mudou.
- **Bug achado pelo time** (QA numa validação, dev implementando, Arquiteto/UX numa revisão) → direto ao registro da QA, pelos canais que já existem (🔺 GAP, achado próprio, §6b) — **não passa pelo PO**.

**Por quê:** achado interno já chega com `arquivo:linha` e classificação óbvia — repassar pelo PO seria repasse sem agregar nada. O que o PO agrega é julgar se o relato **de fora** do time é de fato defeito; achado interno não tem essa pergunta.

Aplicado em `workflow.md` §6a/§6b (bifurcação + visão do PO preservada via Product/Sprint Backlog), `how-to.md` caminho C e `project-context.md` §8, ver "O que mudou" acima. Propostas de `agents/`/`commands/` de `v3.12`/`v3.13` seguem como propostas, sem mudança.

**Mudança de comportamento de agente/comando** não se aplica — nenhum `agents/`/`commands/` foi tocado.

