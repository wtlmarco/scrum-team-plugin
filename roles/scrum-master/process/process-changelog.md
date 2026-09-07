# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v2.10 — Reavaliação do conjunto: caminho de escrita do `/review`, contagem de regras e modo `note` reconciliados — 07/09/2026

**Instrução:** *(stakeholder, direta)* "faça a correção dos itens encontrados na review" — e, na segunda rodada, a decisão de aplicar a R19, extrair o modo `update` e manter a numeração da entrega em `v2.9.0`.
**Classificação:** formato de documento (contagens e listas de modo obsoletas) + comportamento de agente (`agents/*`, `commands/team.md`) + **regra nova (R19)** — as mudanças em `agents/` e `commands/` foram **aplicadas com autorização direta do stakeholder**, dono desses diretórios, em vez de ficarem como proposta.
**Registrada por:** SM (curador), acionado pelo `/review` em modo reavaliação — **duas rodadas**: a primeira aplicou as correções, a segunda pegou dois defeitos da primeira e produziu a R19.
**Escopo:** correção de coerência + uma regra de método. Nenhum fluxo, cerimônia ou propriedade de artefato novo.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `review-contract.md` | cabeçalho | **Caminho de escrita corrigido:** todo caminho do contrato passa a ser relativo à **RAIZ** — o clone, cujo caminho absoluto o `/review` passa ao agente — e não a `${CLAUDE_PLUGIN_ROOT}`. Nota explícita: nunca escrever na cópia instalada; sem RAIZ, parar e pedir. Justificativa histórica da extração ("ocupava 53–63% de cada comando de papel") enxugada |
| `review-contract.md` | §"O que o `/review` é" · passo 4 · "Reavaliação" · "Modos auxiliares" | Quatro ocorrências de `${CLAUDE_PLUGIN_ROOT}/` → `RAIZ/`, inclusive o **destino do `process-changelog.md`** no passo 4 |
| `review-contract.md` | modos auxiliares | **`/review note` acrescentado** à lista, que só citava `audit · metrics · history` |
| `agents/scrum-master.md` | "Regras de trabalho" | "As **17** regras … método **R13-R17**" → "**18** … **R13-R18**" (R18 entrou na v2.9) |
| `agents/scrum-master.md` | "Evolução do processo" | Lê o `review-contract.md` **da RAIZ recebida**, não de `${CLAUDE_PLUGIN_ROOT}`; `/review note` acrescentado aos modos auxiliares |
| `agents/{architect,product-owner,user-experience,quality-assurance}.md` | "Evolução do processo" | Mesma correção de RAIZ, replicada nos outros quatro agentes que rodam `/review`. **Achada na segunda reavaliação**: a primeira passada corrigiu só o do SM, deixando quatro papéis lendo o contrato da cópia instalada — o modo de falha que esta entrada existe para fechar, aberto em 4 de 5 papéis. (`agents/developer.md` não referencia o contrato: o dev não roda `/review`) |
| `roles/scrum-master/templates/retrospective.md` | Métricas do período | **Linha de R18** ("entrega sem bump / `plugin.json` ≠ topo do `CHANGELOG.md` / entrada de `process-changelog.md` sem par") — o indicador existia em `working-rules.md` §"Como o SM aplica" desde a v2.9, mas não no instrumento que o coleta. Marcada **`n/a` quando a retro roda num projeto consumidor**, que não tem `plugin.json` para versionar |
| `roles/scrum-master/templates/project-context.md` | §8 (bloco fixo) | Linha `/team` ganha `update`; a seção é copiada literalmente em todo `.team-project/` novo, que nascia sem a referência |
| `commands/team.md` | frontmatter | `argument-hint` ganha `plan <ID> \| build <ID> \| qa <ID>`, modos parciais que o corpo documentava e o hint omitia |
| `deliverables/README.md` · `deliverables/sdd/README.md` | "Ordem de elaboração" · título §5 | "os sete" → "os sete documentos **de conteúdo** (`00`–`06`)", com o `README` nomeado como oitavo arquivo; o título do índice do SDD ganha o mesmo qualificador. Desambigua o "sete" (documentos de conteúdo) do "oito" (com o índice) que `agents/{product-owner,architect}.md` usam. **Não reconciliado:** `deliverables/sdd/README.md:54`, `06-changelog.md:35` e `workflow.md:145` seguem dizendo "os sete documentos" — corretos em contexto, mas sem o qualificador |
| `process/process-changelog.md` · `-archive.md` | — | v2.7 arquivada em `process-changelog-archive.md` (teto de 3 — R17); linha acrescentada ao índice. **A primeira tentativa truncou a entrada em ~40%** (12 das 48 linhas), deixando o resto órfão no arquivo vivo colado à v2.8 — detectado na segunda reavaliação e refeito; a v2.7 no arquivo foi conferida **linha a linha contra o `HEAD`** e está íntegra |
| `process/working-rules.md` | **nova R19** · resumo · "Como o SM aplica" | "O `/review` produz evidência do que aplicou": bloco de evidência obrigatório na entrada, com a evidência mínima das três classes (arquivamento · substituição de padrão · extração/remoção). Linha nova na tabela de indicadores. **19 regras** (método R13-R19) |
| `review-contract.md` | §"Cinco passos" | Quinto passo — **verificar e anexar o bloco de evidência**. O título e as 9 referências a "quatro passos" no plugin viraram "cinco" |
| `roles/scrum-master/templates/process-change.md` | modelo · regras | Seção `### Evidência (R19)` no modelo da entrada, e a regra correspondente |
| `commands/team.md` · **`team-update.md`** | `## Modo update` | **E1 aplicado:** os sete passos (~18 linhas) extraídos para `team-update.md`, lido só nesse modo; no comando fica ponteiro + "não dispare agente". Mesmo movimento que a v2.7 fez com `Modo init` → `team-init.md` |
| `roles/scrum-master/templates/project-context.md` | §8 | Linha `/team` também ganha `plan/build/qa <ID>` |
| `note.md` | `## Abertas` | Bullet órfão → `_(vazia)_`. A fila foi esvaziada pelo stakeholder |

### Por quê
**Caminho de escrita (o achado que motiva a entrada).** A v2.9 e o commit `6bf8f7c` moveram a pré-condição do `/review` para `git rev-parse --show-toplevel` (→ RAIZ), porque a cópia instalada é descartável e, no Windows, não há como apontá-la para o working tree. Mas `review-contract.md` — o documento que o **agente de papel** obedece — continuou em `${CLAUDE_PLUGIN_ROOT}`, inclusive no passo "registrar o changelog": o agente era mandado escrever a evolução do processo na árvore que o próximo `claude plugin update` sobrescreve. **Evita:** mudança aplicada, reportada como feita, e perdida sem sinal.

**R19.** Os passos do `/review` terminavam em "registrar", sem verificação — e nesta rodada isso produziu dois defeitos declarados como feitos (v2.7 truncada em 60%; RAIZ corrigida em 1 de 5 agentes), pegos só porque o stakeholder rodou o comando uma segunda vez. É a R7/R12 ("não afirme progresso sem evidência") que o `/review` cobrava do projeto e não de si.

**O resto** são derivas de contagem e de lista de entregas anteriores, todas com o mesmo efeito: o agente carrega no prompt uma descrição do processo que já não é o processo.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| **Todos os papéis** | Escrevem na **RAIZ recebida**; sem RAIZ, param e pedem. E **fecham com bloco de evidência** — sem ele o `/review` não fecha (R19) |
| **SM** | A retrospectiva coleta o indicador de R18; a curadoria reexecuta por amostragem um comando do bloco de evidência |
| **SM** | Todo `.team-project/` novo nasce com `/team update` na tabela de comandos |

### Conflitos com o processo vigente
Dois, ambos decididos pelo stakeholder. **(1)** `agents/` e `commands/` são dele e o `/review` só **propõe** — a instrução "faça a correção dos itens encontrados" valeu como aprovação das propostas em aberto, aplicadas aqui; sem instrução explícita a regra permanece. **(2)** `workflow.md` §5d manda a entrega pareada com a entrada nova do processo sair como `v2.10.0`; o stakeholder **decidiu manter `v2.9.0`**, o nome da branch. A divergência tem de ser declarada na entrada do `CHANGELOG.md` no fecho, como foi na v2.8.0 — senão a reconciliação do SM a acusa (§5d).

### Como saberemos que funcionou
Nos próximos três `/review` que roteiem item a agente de papel: **zero** entradas escritas fora do clone, **zero** achados de "contagem divergente" (hoje foram cinco) e **zero** entradas sem bloco de evidência. Se a contagem divergente reaparecer, o problema não é o número: é que a informação está duplicada em N lugares e a correção deve virar ponteiro.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento | `Compare-Object` v2.7 do archive × `HEAD` | 0 linhas fora do separador | ✅ |
| Substituição | `grep '[Qq]uatro passos'` em todo o plugin | 0 antigo / 10 novo | ✅ |
| Substituição | `grep 'leia ${CLAUDE_PLUGIN_ROOT}/review-contract'` em `agents/*` | 0 antigo / 5 em RAIZ | ✅ |
| Substituição | `grep '18 regras\|R13-R18'` | 1 restante — `CHANGELOG.md:65`, registro histórico da v2.8.0, imutável por R17 | ✅ |
| Extração | `wc -l` `commands/team.md` antes/depois | 125 → 111; `team-update.md` 41 linhas; ponteiro resolve | ✅ |
| Teto R17 | tamanho do bloco `## v2.10` | **10280 bytes na 1ª medição — acima da barreira de 10240; entrada enxugada antes de registrar** | ✅ após corte |
| Manifesto | `claude plugin validate . --strict` | passou | ✅ |

### Pendente do stakeholder
- **Fecho da entrega:** bump de `plugin.json` e entrada `v2.9.0` no `CHANGELOG.md` (R18), com a nota da divergência §5d acima e o registro de que as propostas de "Proposto ao stakeholder" da v2.8.0 foram consumidas aqui.
- **Reiniciar a sessão** — as mudanças em `agents/` e `commands/` só entram em vigor no próximo carregamento.

---

## v2.9 — Processo de atualização e lançamento do plugin ganha documento e dono — 06/09/2026

**Instrução:** *(stakeholder, direta)* "Esse último processo que fechamos passe pelo processo de review para organizar o processo de atualização do plugin."
**Classificação:** fluxo (nova seção `workflow.md` §5d) + propriedade de artefato (`CHANGELOG.md` e o processo de lançamento ganham dono na matriz) + regra (R18, com verificação).
**Registrada por:** SM (curador), acionado pelo `/review`. **Escopo:** formaliza um processo que já operava disperso — não altera como as entregas são feitas hoje; dá a elas documento, dono e verificação.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `process/workflow.md` | **nova §5d** | "Atualização e lançamento do plugin": os dois registros (`process-changelog.md` `vX.Y` × `CHANGELOG.md` `vMAJOR.MINOR.PATCH`), o ciclo de entrega (branch → PR → bump de `version` → entrada no `CHANGELOG.md` → `/team update` no cliente), a regra de numeração (`vX.Y.0` quando a entrega carrega mudança de processo) e o que o SM reconcilia |
| `process/workflow.md` | §5 · §8 | Nova cerimônia "Lançamento de entrega" e novo gate "bump + entrada no `CHANGELOG.md` no merge do PR"; linha "Retrospectiva" — comando `/sm impact retro` (inexistente) → `/sm close` (3º item) |
| `process/workflow.md` | §4a | "(o ciclo é 0→1→2→3→4→5; ver commands/team.md)" — numeração que colidia com a da §2 — → "etapas de construção 3→4→5→6 na numeração da §2; `commands/team.md` modo `cycle` usa índice local próprio 0–6" |
| `process/working-rules.md` | **nova R18** | "Entrega do plugin é ramificada, versionada e registrada": branch/PR/bump/entrada, numeração acompanha o changelog do processo, verificação via `git log main` + `CHANGELOG.md` + `plugin.json`. Adicionada ao resumo e à tabela de indicadores de "Como o SM aplica" |
| `process/artifact-ownership.md` | §1 · §3 | Duas linhas novas na matriz: `CHANGELOG.md` (dono: stakeholder; SM reconcilia no `/review`) e "Processo de lançamento" (dono: stakeholder; SM verifica rastreabilidade). §3 ganha a linha "mudança de `/review` aplicada mas não lançada" |
| `roles/scrum-master/templates/process-change.md` | classificação | "cerimônia" acrescentada à lista (alinha com `review-contract.md` passo 1) |
| `roles/scrum-master/README.md` | triagem · modos aux. · tabela | "cerimônia" no vocabulário de classificação; `/review note` na lista de modos auxiliares; retro anotada como emitida no `/sm close` do 3º item |
| `README.md` (raiz) | "Regras que governam todos" | "as 17 regras … R13-R17" → "as 18 regras … R13-R18" |
| `replicate-in-new-project.md` | checklist | "os 7 comandos" → "os 8 comandos" (+`review`) |
| `process/process-changelog.md` | — | v2.6 arquivada em `process-changelog-archive.md`, íntegra (teto de 3 — R17); linha acrescentada ao índice "Versões arquivadas" |

### Por quê
O modelo de lançamento existia só no cabeçalho do `CHANGELOG.md`, no `how-to.md` e no `README.md` — nenhum deles normativo, nenhum com dono declarado. Uma entrega podia ser cortada sem bump, ou `plugin.json` / `CHANGELOG.md` / `process-changelog.md` derivarem entre si, sem nada que o SM pudesse verificar. Dar ao processo uma seção em `workflow.md`, uma regra com verificação e um dono na matriz fecha o buraco entre "o `/review` mudou o processo" e "a instalação do cliente recebeu a mudança".

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| SM | Na curadoria do `/review`, reconcilia os três registros: entrada de `process-changelog.md` ⇒ entrada em `CHANGELOG.md` na mesma linha `vX.Y`; `version` de `plugin.json` == topo do `CHANGELOG.md`. Verifica R18 a cada merge em `main` |
| stakeholder | Dono declarado do `CHANGELOG.md` e do processo de lançamento — corta a versão, abre a branch, faz o PR, dá o bump |
| Nenhum outro | R1–R17, gates de item, DoR/DoD, matriz de propriedade dos artefatos de projeto — inalterados |

### Conflitos com o processo vigente
- **Regra de numeração §5d × entrega em curso.** §5d/R18 dizem que uma entrega que carrega entrada nova de `process-changelog.md` (aqui, `v2.9`) sai como `vX.Y.0` — seria `v2.9.0`. A entrega em curso é a `v2.8.0`, que **ainda não foi ao ar** e continua acumulando nesta mesma branch. **Resolução (stakeholder):** o lote permanece **v2.8.0**; a entrada `CHANGELOG.md` `## v2.8.0` passa a listar as mudanças de processo `v2.7`–`v2.9`. A regra de numeração §5d **vale a partir da próxima entrega** — desvio pontual, registrado.
- **R17 — teto de 3 entradas.** Resolvido: `v2.6` movida íntegra para `process-changelog-archive.md`, linha acrescentada ao índice "Versões arquivadas". Changelog vivo com `v2.9`, `v2.8`, `v2.7`.

### Como saberemos que funcionou
- `git show main:.claude-plugin/plugin.json` → `version` igual à da entrada do topo de `CHANGELOG.md`, em todo commit de `main`.
- Toda entrada futura de `process-changelog.md` tem par em `CHANGELOG.md` na mesma linha `vX.Y` — verificado em cada `/review`.
- Nenhuma entrada de `CHANGELOG.md` volta a afirmar "sem entrada no changelog do processo" quando carrega uma.
- Em 3 entregas, nenhuma chega a `main` sem branch nomeada + bump + entrada no `CHANGELOG.md`. Se acontecer, R18 não pegou e a verificação vira gate de PR.
- **Footprint (§5c):** medição na próxima `/review metrics`. Esperado: `process/` +~2,7 KB (§5d + R18 + linhas de matriz e indicador); `roles/scrum-master/` +~0,3 KB. v2.6 (~3,4 KB) sai do caminho quente para o arquivo — líquido do changelog vivo próximo de neutro.

### Pendente do stakeholder
- **Lote permanece `v2.8.0`** (decisão do stakeholder): a entrada `CHANGELOG.md` `## v2.8.0` foi consolidada para cobrir `/review` único + `/team update` + esta formalização; `plugin.json` fica em `2.8.0`. A regra de numeração §5d vale a partir da próxima entrega.
- **`commands/team.md` modo `cycle`** numera as etapas num índice local 0–6 que colide com a numeração da §2 de `workflow.md`. Proposta de texto pronto na resposta do `/review` — acrescentar uma linha de nota, sem renumerar.
- **`commands/sm.md`** e **`agents/scrum-master.md`** — o resumo dos modos de `/review` omite `note`; `agents/scrum-master.md:41` diz "As 17 regras … R13-R17". Propostas de texto pronto na resposta.
- Reiniciar a sessão não é necessário: nada em `agents/` / `commands/` foi alterado por esta entrada.

---

## v2.8 — Evolução do processo num comando só: `/review`, guardado ao repositório-fonte, com `note.md` como fila — 06/09/2026

**Instrução:** *(stakeholder, direta)* "vamos mudar e criar um comando `review` que somente roda no contexto desse projeto (removendo dos roles o comando) e o SM usa o arquivo `note.md` para levantar e melhor direcionar a melhoria na role ou processo."
**Classificação:** comportamento de agente (`agents/*` e `commands/*` — novo `/review`, removido o modo `review` de cinco comandos) + fluxo (a evolução do processo deixa de ser cinco portas e passa a ser uma, com triagem do SM sobre `note.md`) + formato de documento (todas as referências a `/<papel> review` reapontadas).
**Registrada por:** stakeholder. **Escopo fechado — troca de mecanismo, sem mudança de regra, gate, DoR/DoD ou matriz de propriedade.**

### O que mudou
| Documento | Mudança |
|---|---|
| `commands/review.md` | **Novo.** Comando único de evolução do processo. Pré-condição: recusa se `${CLAUDE_PLUGIN_ROOT}` não tiver `.git/` **e** `.claude-plugin/marketplace.json` (não é o repositório-fonte). Modos: `<instrução>` · `note` (processa a fila de `note.md`) · vazio (reavaliação + triagem) · `metrics` · `audit` · `history`. Triagem e curadoria no Agent `scrum-master`; a edição de cada documento no agente do papel dono |
| `review-contract.md` | Deixa de ser "contrato comum dos papéis" e passa a ser o **contrato do `/review`**. Recebe a **tabela de alcance por papel** que estava espalhada nos cinco `commands/<papel>.md`. Quatro passos, reavaliação do conjunto e limites mantidos |
| `commands/{sm,po,arc,ux,qa}.md` | Modo `review` **removido** do `argument-hint` e da lista de modos; a seção `## Modo review …` vira um parágrafo curto "Evolução dos documentos deste papel — não é aqui: `/review`" |
| `commands/dev.md` | "`/dev review` não existe — é do Arquiteto" → "a evolução é pelo `/review`, que roteia os documentos do dev ao Arquiteto" |
| `agents/{scrum-master,architect,product-owner,user-experience,quality-assurance,developer}.md` | Seção `## Modo review` → `## Evolução dos …documentos — /review`, apontando `review-contract.md`; alcance do papel mantido |
| `process/{workflow,artifact-ownership,working-rules,process-changelog}.md` · `templates/{process-change,retrospective}.md` · `roles/*/README.md` · `roles/*/skills.md` · `standards/README.md` · `replicate-in-new-project.md` · `templates/project-context.md` | Toda referência a `/sm review` · `/arc review` · `/<papel> review` · `review metrics/audit/history` → `/review` (· `/review metrics` etc.). O invariante de dono único é reafirmado: `/review` roteia, o dono aplica |
| `README.md` · `how-to.md` | Bloco de comandos e a seção "Como o processo evolui" reescritos para o comando único e a fila `note.md`; contagem **7 → 8 comandos** (`sm po arc ux dev qa team review`); guarda do repositório-fonte documentada |
| `note.md` | Reescrito como **entrada do `/review`**: o item continua sendo sintoma, mas quem classifica e roteia é o `/review` (SM), não o stakeholder escolhendo a porta. Nota de que melhoria percebida noutro projeto é trazida para cá |
| `.claude-plugin/{plugin.json,marketplace.json}` | Descrições ganham `/review` na lista de comandos |
| `process/process-changelog.md` | v2.5 arquivada (teto de 3 entradas, R17) — pendência aberta desde a v2.4 |

### Por quê (modo de falha evitado)
O modo `review` existia em cada comando de papel e, portanto, em **qualquer projeto onde o plugin estivesse instalado**. Rodá-lo lá edita `${CLAUDE_PLUGIN_ROOT}`, que nesse caso é a **cópia instalada no cache do Claude Code** — não versionada, e **sobrescrita no próximo `claude plugin update`**. A melhoria de processo era feita e se perdia, sem chegar à origem nem se replicar. A guarda de repositório-fonte torna o erro impossível de cometer em silêncio. E cinco portas de entrada (`/sm review`, `/arc review`, …) faziam o stakeholder decidir o roteamento que é trabalho do curador: uma porta só, com o SM triando `note.md`, põe a classificação onde ela pertence.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Todos com `review` | Não há mais `/<papel> review`. O papel é **acionado pelo `/review`** para aplicar a mudança nos próprios documentos, seguindo `review-contract.md`. O alcance de cada um é o mesmo, agora listado num só lugar |
| SM | Ganha a **triagem** de `note.md` (classificar + rotear) como parte do `/review`, além da curadoria que já era sua. Continua sendo o único a editar os normativos que governam todos |
| Arquiteto | Continua sendo quem aplica as mudanças em `standards/` e nos documentos do dev — agora acionado pelo `/review`, não por `/arc review` |
| dev | Sem mudança de conduta: o retorno segue subindo por 🔺 GAP e "Não fiz" |
| Nenhum | Nenhuma regra (R1–R17), gate, DoR/DoD ou matriz de propriedade mudou de conteúdo — só o comando que as evolui |

### Conflitos com o processo vigente
Nenhum. O invariante de dono único (`artifact-ownership.md` §1) é preservado — `/review` roteia ao dono, não centraliza a caneta. O invariante do changelog (entrada antiga nunca reescrita) é respeitado: as entradas v2.5–v2.7 e o arquivo **não** foram reapontados de `/arc review` para `/review` — são registro histórico do comando que existia à época.

### Como saberemos que funcionou
- `claude plugin details team@team` lista **8 comandos** (`sm po arc ux dev qa team review`) e 6 agents — após reiniciar a sessão.
- `grep -rn "/sm review\|/arc review\|/po review\|/ux review\|/qa review\|/<papel> review"` retorna **zero fora de `process-changelog.md` e `process-changelog-archive.md`**.
- `/review` invocado fora de um clone do repositório-fonte **recusa** com a mensagem de repositório-fonte; dentro dele, sem argumento, devolve reavaliação + triagem de `note.md` sem editar.
- Em 3 ciclos, toda melhoria de processo entra por `note.md` + `/review` — nenhuma tentativa de `/<papel> review`. Se aparecerem tentativas, o redirecionamento nos comandos não bastou e o modo volta como alias explícito.
- **Footprint (§5c):** medição na próxima `/review metrics`. Esperado: `commands/` −5 seções `review` (~0,5 KB cada) +1 arquivo `review.md`; `agents/` sem mudança líquida (seção renomeada, não removida); `review-contract.md` cresce (recebe a tabela de alcance). Δ do conjunto por papel na próxima retrospectiva.

### Pendente do stakeholder
- **Reiniciar a sessão** — `commands/review.md` novo e as mudanças em `commands/*` e `agents/*` só entram em vigor no próximo carregamento.
- Confirmar em sessão interativa que `claude plugin validate . --strict` passa e que `claude plugin details` lista os 8 comandos.
- `note.md`: item "revise" segue fechado (v2.7). Nenhum item novo aberto por esta entrada.

