# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v3.19 — Pasta `sprints/<n>/` para Review/Retrospectiva/snapshot, burndown desenhado (R24), tríade R18, duas contagens e uma contradição entre normativos (SM) — 16/09/2026

> Fecho de `note.md`: onde vivem os documentos de execução do sprint. Diagnóstico prévio: Histórias/Tasks já têm lugar; Planning não precisa de artefato próprio; Review/Retro tinham modelo sem caminho persistido; burndown não existia (nem artefato nem dado).

**Instrução:** *(stakeholder, via coordenador)* Decisão 1 — pasta física por sprint (não arquivo único): `.team-project/scrum-master/sprints/<n>/review.md`, `retrospective.md`, `sprint-backlog-snapshot.md`; Histórias/Tasks ficam de fora; convivência com `consumption-log.md` (vivo+archive) declarada, não uniformizada por conta própria. Decisão 2 — desenhar o burndown de ponta a ponta (o quê mede, de onde sai o dado, onde persiste, modelo, verificação), realista sobre custo. Num segundo turno, o coordenador apontou 3 furos na 1ª aplicação — tríade do R18 ausente, as duas contagens de regras (que eu tinha deixado como pendência por bloqueio da rodada anterior) autorizadas a aplicar, e uma contradição entre `review-contract.md` e `commands/review.md` sobre o alcance da exceção de coerência de referência cruzada, com direção de resolução já dada pelo stakeholder.

**Classificação:** propriedade de artefato (pasta `sprints/<n>/`, Registro de transições, burndown) + regra de trabalho (**R24** nova) + coerência de referência cruzada (contagem de regras, `review-contract.md`×`commands/review.md`) + entrega (R18).

### O que mudou
| Documento | Mudança |
|---|---|
| `working-rules.md` | **R24 nova** (Bloco C): transição de Task vira linha no Registro de transições; granularidade exata na abertura/fechamento, por rodada de `/sm board` nos estados intermediários. Indicador nas duas tabelas de aplicação |
| `artifact-ownership.md` | Sprint Backlog ganha Registro de transições; Registro de sprint (Review/Retro/snapshot) migra para `sprints/<n>/`; burndown com dono/caminho/regra; **§1c nova** — critério vivo+archive × pasta numerada, e tensão residual com `consumption-log` devolvida ao stakeholder |
| `templates/burndown.md` (novo) | Linha de base, série por evento, fechamento, custo declarado (reaproveita `/sm board`) |
| `templates/sprint-backlog.md` | Seção "Registro de transições" + regra de preenchimento + nota de snapshot no fechamento |
| `templates/sprint-review.md`, `templates/retrospective.md` | Persistência em `sprints/<n>/`; retro ganha indicador R24, linhas de encerramento (snapshot + burndown fechado) e regra de ordem |
| `workflow.md` | §2a passo 8, §5e (abertura da pasta na Planning, persistência Review/Retro, checklist), **§5f nova** (mecânica do burndown) |
| `roles/scrum-master/README.md`, `skills.md`, `project-context.md`, `deliverables/team-project/README.md` | Roteiro/tabelas/manifesto/árvore atualizados para `sprints/<n>/` e o burndown; `consumption-log.md` somado à árvore (já existia sem constar — corrigido de passagem) |
| `.claude-plugin/plugin.json`, `CHANGELOG.md`, `README.md` (raiz) | Tríade do R18: `3.18.0`→`3.19.0`; entrada nova em `CHANGELOG.md` |
| `README.md:181`, `agents/scrum-master.md:45` | Contagem "23/R13-R23"→"24/R13-R24" — **autorizado nesta rodada pelo stakeholder** |
| `review-contract.md`, `commands/review.md` | Exceção de coerência de referência cruzada do SM explicitada como válida para os **quatro grupos** igualmente (não só guias de raiz), nunca para comportamento/roteiro/regra — **autorizado nesta rodada**, resolve contradição entre os dois documentos |

### Por quê
Review/Retro sem caminho persistido se perdiam a cada sprint (o próprio sintoma de `note.md`); burndown sem dado datado seria reconstituído de memória no fechamento (modo de falha de R7, agora em processo). Pasta numerada evita fragmentar Histórias/Tasks, que têm dono em outro lugar. Tríade do R18 é par obrigatório do changelog do processo. As duas contagens e a contradição `review-contract`×`commands/review` são achado de coerência de referência cruzada — a contagem manual já falhou 9 vezes (`process-changelog-archive.md`); candidata a virar derivada, não corrigida agora (fora do escopo).

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| SM | abre/fecha `sprints/<n>/` na Planning/close; grava o Registro de transições em `/sm board` e `/sm close`; a exceção de referência cruzada agora cobre os quatro grupos igualmente, mas contradição de sentido entre normativos continua exigindo autorização nomeada |
| PO, Arquiteto, dev, QA | nenhuma — granularidade do burndown limitada à cadência de `/sm board`, de propósito |
| stakeholder | ponto de curadoria devolvido (convivência `consumption-log`×`sprints/<n>/`, §1c); as duas contagens e a contradição deixaram de ser pendência |

### Conflitos com o processo vigente
Não resolvido por mim: convivência de dois padrões de retenção em `.team-project/scrum-master/` — critério em §1c, decisão de uniformizar é do stakeholder. Resolvido sob autorização nomeada: contradição entre `review-contract.md:69` (exceção valia para os quatro grupos) e `commands/review.md` (só aplicava aos guias de raiz) — alinhados à leitura ampla; não é o SM decidindo o próprio alcance.

### Como saberemos que funcionou
Próximo `/sm sprint plan`/`/sm review`/`/sm close`/`/sm sprint close` populam e fecham `sprints/<n>/` sem achado. Próxima regra nova (R25) chega com as contagens já corrigidas no mesmo commit, não como pendência.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento (teto de 3, `process-changelog.md:10`) | `Compare-Object` do bloco `## v3.16` (50 linhas) pré-sessão × relocado | 0 diferenças | ✅ |
| Extração/criação | `(Get-Content templates\burndown.md).Count` | 0→33 linhas | ✅ |
| Substituição/extensão | `Select-String -Pattern "sprints/<n>/"` em `roles\scrum-master\**\*.md` + manifesto | ocorrências em 8 arquivos, cada uma lida no contexto, coerentes com criação (Planning)/fechamento (`sprint close`) | ✅ |
| Checagem semântica | contagem `^\| R\d+ \|` e `^### R\d+\.` em `working-rules.md` | 24/24, R1–R24 sem buraco | ✅ |
| Tríade do R18 | `plugin.json`, topo `CHANGELOG.md`, banner `README.md` | os três `3.19.0` | ✅ |
| Substituição de padrão | `Select-String -Pattern "23 regras\|R13-R23"` em `*.md` fora de changelogs | 0 ocorrências (varredura completa da RAIZ) | ✅ |
| Substituição de padrão | `Select-String -Pattern "24 regras\|R13-R24"` em `README.md`, `agents\scrum-master.md` | 2, uma por arquivo, lidas no contexto | ✅ |
| Substituição de padrão | texto antigo de `commands\review.md` (exceção só nos guias de raiz) | 0 ocorrências restantes | ✅ |
| Substituição de padrão | `"válida para os quatro grupos"` em `review-contract.md` + `commands\review.md` | 2, uma por arquivo, coerentes entre si | ✅ |
| Fronteira, com autorização nomeada | `git status --porcelain` | `agents/scrum-master.md` e `commands/review.md` entram na lista nesta rodada, ambos citados em "O que mudou" com a autorização; nenhum outro arquivo desses grupos tocado | ✅ |
| Autocorreção de integridade (achada nesta sessão) | edição que reabria `## v3.18` perdeu o cabeçalho sem perder o corpo; corrigido e verificado por `Compare-Object` do corpo `## v3.18`→`## v3.17` (55 linhas) contra `git show HEAD` | 0 diferenças | ✅ |

### Pendente do stakeholder
Convivência `consumption-log` (vivo+archive) × `sprints/<n>/` (pasta numerada) em `.team-project/scrum-master/` — critério em §1c, decisão de uniformizar é do stakeholder. Achado de processo sem correção nesta rodada: contagem de regras deveria ser derivada, não copiada à mão (candidata a `/review metrics`/`/review audit`).

**Nada mais pendente sobre `agents/`/`commands/`.** As duas contagens e o alinhamento de `commands/review.md` foram aplicados sob autorização explícita do stakeholder nesta rodada. **Mudança de comportamento de agente/comando se aplica** — `agents/scrum-master.md` e `commands/review.md` tocados: só valem após reiniciar a sessão, e só chegam aos projetos após `git push` + `claude plugin marketplace update` + `claude plugin update`.

---

## v3.18 — As três decisões escaladas em v3.17 fechadas: arquivamento por sprint, granularidade definitiva, e as duas propostas aplicadas sob a restrição de escopo `.team-project/` (SM) — 15/09/2026

> **Fecho da v3.17.** As duas decisões que ficaram escaladas (retenção, granularidade) e as duas propostas de texto pronto (gravação em `commands/*`, exibição em `team-version.md`) — todas pendentes na entrada anterior — voltam decididas/autorizadas pelo stakeholder, com uma restrição nova sobre a proposta de gravação.

**Instrução:** *(stakeholder)* (1) Retenção: **arquivar por sprint** — "no fechamento do sprint, as linhas do período vão para um arquivo histórico; o registro vivo guarda o sprint corrente mais os totais acumulados", espelhando o padrão de R17. (2) Granularidade: **toda invocação** — qualquer subagente de papel que termina vira linha, com Task/História quando houver e `n/a` quando não; deixa de ser provisório. (3) Aplicar as duas propostas (`commands/*` e `team-version.md`), **com uma condição**: *"esse registro é somente aplicado na versão instalada do plugin, ou seja, nessa em que estamos não há necessidade de registro"* — a gravação só ocorre onde `.team-project/` existe; o clone-fonte do plugin, onde o `/review` roda, não grava.

**Classificação:** propriedade de artefato (retenção e escopo do registro) + cerimônia (arquivamento amarrado ao `/sm sprint close` já existente) + comportamento de agente (gravação em `commands/*`, exibição em `team-version.md`).

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/scrum-master/templates/consumption-log.md` | Regras + corpo do modelo | Retenção: arquivar por sprint no `/sm sprint close`, para `consumption-log-archive.md` (`## Sprint <n>`, íntegro); `## Registro` fica só com o sprint corrente, `## Totais por papel` acumula sem reset; granularidade: "pendente" removido, toda invocação vira linha; linha nova de **escopo** — só existe onde `.team-project/` existe |
| `roles/scrum-master/process/workflow.md` | §5e (Sprint Retrospective) + "Como o SM verifica que o sprint aconteceu" | Passo de arquivamento do registro de consumo amarrado à cerimônia existente, sem inventar cerimônia nova; item novo na lista de verificação |
| `roles/scrum-master/README.md` | `/sm sprint close` | Frase do passo de arquivamento |
| `roles/scrum-master/templates/retrospective.md` | Encerramento + Regras | Linha "Registro de consumo arquivado" na Encerramento; regra nova sobre a ordem (medir o consumo real do sprint antes de arquivar) |
| `roles/scrum-master/process/artifact-ownership.md` | §1, linha do registro de consumo | "Pendentes do stakeholder" → retenção e escopo decididos, citando esta entrada |
| `commands/sm.md`, `commands/po.md`, `commands/arc.md`, `commands/ux.md`, `commands/qa.md`, `commands/dev.md` | seção nova, antes do parágrafo de repasse ao stakeholder | "Registro de consumo — só onde o registro existe": grava uma linha se `.team-project/scrum-master/consumption-log.md` existir; nunca no clone-fonte |
| `commands/team.md` | idem, antes de "Ao final" | Mesmo texto no plural — uma linha por subagente disparado; nota explícita de que `init`/`update`/`version` não disparam agente e não gravam |
| `commands/review.md` | `## Limites`, linha nova | `/review` nunca grava — roda no clone-fonte, que não tem `.team-project/`, e dispara o Agent do papel direto, não os comandos `/sm`/`/po`/… |
| `team-version.md` | `## 2.` renumerada para "As cinco respostas" + item `e)` novo | Exibição do consumo real acumulado/por período, condicionada à existência do arquivo, com a mesma ressalva de que mede o trabalho dos papéis, não a sessão |
| `.team-project/note.md` | `## Abertas` | Item 3 ("Não há onde consultar o consumo acumulado…") removido — resolvido pelo item `e)` de `team-version.md` |

### Por quê
Sem retenção, o registro de consumo cresceria sem fim — o mesmo modo de falha que R17 já corrigiu no changelog do processo (v1.0→v1.8, 12× em nove versões), agora à espreita num arquivo por projeto em vez de um por plugin. Sem granularidade fechada, cada projeto inventaria seu próprio critério de "o que vale registrar", e o registro deixaria de ser comparável entre sprints. Sem a restrição de escopo explícita, `commands/*` gravaria — ou tentaria gravar — em toda invocação disparada por `/review`, que roda no clone-fonte sem `.team-project/`: a condição "se o arquivo existir" já bastava tecnicamente, mas o stakeholder pediu a intenção por extenso, não só o efeito colateral de uma condição.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| SM | arquiva o registro de consumo a cada `/sm sprint close`, no mesmo ciclo em que fecha a retrospectiva; verifica que a tabela `## Registro` fica vazia depois |
| PO, Arquiteto, UX, QA, dev | ao terminarem uma invocação, a sessão que os disparou (não eles) grava a linha — sem mudança de prática do próprio papel |
| stakeholder | as três decisões e as duas propostas saem da fila; nenhuma pendência nova |

### Conflitos com o processo vigente
Nenhum. A restrição de escopo não contradiz a proposta de v3.17 — ela já dizia "(se `.team-project/scrum-master/consumption-log.md` existir)"; esta entrada só torna a intenção explícita nos três lugares que o stakeholder pediu (`commands/*`, `consumption-log.md`, `artifact-ownership.md`), e acrescenta a quarta menção que ele não pediu mas que fechava o vão (`commands/review.md`).

### Como saberemos que funcionou
Primeiro `/sm sprint close` de um projeto com `consumption-log.md` deixa a tabela `## Registro` vazia e o sprint fechado íntegro em `consumption-log-archive.md`. Primeira invocação de qualquer comando de papel num projeto com o registro grava uma linha; a mesma invocação disparada por `/review` (clone-fonte) não grava nenhuma. `/team version` responde o item `e)` sem inventar número quando o arquivo não existe.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada (pré-condição do teto de 3 — `process-changelog.md:10`, esta entrada some a 4ª) | `Compare-Object` do bloco `## v3.15` pré-sessão (`git show HEAD:...`, 56 linhas) × relocado em `process-changelog-archive.md` (56 linhas) | 0 diferenças | ✅ |
| Substituição de padrão | `Select-String -Path roles\scrum-master\templates\consumption-log.md,roles\scrum-master\process\artifact-ownership.md -Pattern "pendente de decisão"` | 0 ocorrências (as duas linhas que diziam isso foram substituídas pela decisão) | ✅ |
| Substituição de padrão | `Select-String -Path commands\*.md -Pattern "Registro de consumo"` | 7 ocorrências, uma por arquivo (`sm`, `po`, `arc`, `ux`, `qa`, `dev`, `team`), cada uma lida no contexto: singular nos seis primeiros, plural + nota de `init`/`update`/`version` no `team.md` | ✅ |
| Substituição de padrão | `Select-String -Path commands\review.md -Pattern "nunca grava"` | 1 ocorrência, na seção `## Limites`, coerente com o resto da seção | ✅ |
| Substituição de padrão | `Select-String -Path team-version.md -Pattern "gastou de fato"` | 1 ocorrência, item `e)` novo, título da seção 2 renumerado para "cinco respostas" | ✅ |
| Extração/remoção | `.team-project/note.md`: contagem de itens em `## Abertas` antes (1) × depois (0) | seção continua existindo, vazia — estrutura preservada | ✅ |
| Fronteira não ultrapassada | `git status --porcelain` | arquivos listados em "O que mudou" + tríade de versão + este bloco; nenhum outro documento do plugin tocado | ✅ |
| Tríade do R18 | `plugin.json`, topo `CHANGELOG.md`, banner `README.md` | os três `3.18.0` | ✅ |

### Pendente do stakeholder
Nada. As três decisões escaladas em v3.17 e as duas propostas foram fechadas nesta entrada. **Mudança de comportamento de agente/comando se aplica** — `commands/*` e `team-version.md` foram tocados: só valem após reiniciar a sessão, e só chegam aos projetos depois de `git push` + `claude plugin marketplace update` + `claude plugin update`.

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

