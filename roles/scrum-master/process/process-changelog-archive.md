# Changelog do Processo — Arquivo

> **Dono:** SM · Continuação de [`process-changelog.md`](process-changelog.md), que mantém as três entradas mais recentes.

Entradas anteriores, **íntegras e inalteradas**. Arquivar é relocar para tirar do caminho de leitura quente — nunca reescrever nem resumir. Mais recente no topo.

> **Nota de leitura (v3.0):** as entradas abaixo foram escritas quando a unidade de trabalho se chamava **item** e o plano do Arquiteto, **Plano de Execução**. A v3.0 renomeou os dois — item → **Task**, com a **História** acima dela como unidade de valor; Plano de Execução → **Plano de Implementação**, agora conteúdo da Task. O texto arquivado **não foi ajustado**, porque entrada de changelog não se reescreve (R17): leia "item" como "Task" e "Plano de Execução" como "Plano de Implementação".

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

---

## v2.7 — Faxina pós-isolamento em plugin: resíduo de caminho, contagens do UX e extração dos modos frios — 06/09/2026

**Instrução:** *(stakeholder, direta)* "agora que isolamos em um plugin, revise tudo para remover redundância, validar links e relações entre os arquivos e otimizar o processo para menor consumo de tokens."
**Classificação:** formato de documento (caminhos e contagens obsoletos) + comportamento de agente (`agents/*` e `commands/*` compactados) — aplicada pelo **stakeholder**, não por um `review` de papel.
**Registrada por:** stakeholder. **Escopo fechado — uma faxina, sem mudança de regra, fluxo ou propriedade.**

### O que mudou
| Documento | Mudança |
|---|---|
| `.claude-plugin/plugin.json` · `marketplace.json` | Descrições listavam 5 papéis — **UX ausente**. Corrigido nos dois manifestos |
| `process/artifact-ownership.md` | §1 — **linha duplicada removida** (`roles/<papel>/README.md, skills.md, templates/` aparecia 2×, com regras diferentes); prefixos `team/roles/…` → `${CLAUDE_PLUGIN_ROOT}/roles/…` e `team-project/` → `.team-project/` (6 linhas) |
| `standards/README.md` · `deliverables/README.md` · `roles/{architect,developer,quality-assurance,scrum-master}/README.md` | Resíduo `.team/standards/` → `standards/` e "diretório de primeiro nível de `.team/`" → "do plugin" (25 ocorrências). O repositório **é** o plugin desde a v2.0; o prefixo `.team/` descrevia a estrutura anterior |
| `agents/{product-owner,architect,user-experience,quality-assurance,scrum-master}.md` | Bloco "Evolução dos seus documentos (`review`)" — 3–4 parágrafos reproduzindo `review-contract.md` — **colapsado em ponteiro + alcance do papel**. O mesmo movimento que a v2.0 fez nos `commands/`, agora nos `agents/` |
| `agents/developer.md` · `commands/dev.md` | A justificativa de por que o dev não tem `review` estava **inteira nos dois**; fica o essencial em cada um, com o racional em `artifact-ownership.md` §1 |
| `commands/team.md` | Modo `init` (32 linhas) extraído para **`team-init.md`** — roda uma vez por projeto e pagava contexto em toda invocação de `/team`. Modo `brainstorm` colapsado em despacho + ponteiro para `workflow.md` §5b, que já continha o ritual completo |
| `team-init.md` | **Novo** — ritual do `/team init`, lido só nesse modo |
| `commands/team.md` · `commands/sm.md` · `process/workflow.md` · `scrum-master/{README,skills}.md` | Contagens obsoletas da entrada do UX: "cinco agentes/respondem" → **seis** no broadcast; e o onboarding §5a se contradizia — passo 4 dizia "os outros cinco papéis / Cinco leituras", a checklist de saída e três outros documentos diziam "seis". Unificado em **cinco leituras** (PO · Arquiteto · UX · dev · QA); o SM coordena e consolida, não escreve uma sobre si |
| `README.md` | Índice de estrutura não listava `how-to.md`, `review-contract.md`, `note.md` — nem o novo `team-init.md` |
| `process/process-changelog.md` | v2.4 arquivada (teto de 3 entradas, R17) — pendência aberta desde a v2.5 |

### Por quê (modo de falha evitado)
Dois modos, ambos já observados neste changelog. **Obsolescência silenciosa:** a v2.0 isolou o time num plugin, mas os caminhos `.team/` e `team/roles/` continuaram escritos em 6 roteiros — um agente que os siga procura um diretório que não existe, e o `review audit` os lê como se fossem verdade. Os manifestos omitindo o UX são a mesma falha na porta de entrada: quem instala o plugin lê que o time tem cinco papéis. **Custo fixo por invocação:** o contrato do `review` foi extraído dos `commands/` na v2.0 exatamente porque era injetado em toda invocação — mas ficou intacto nos `agents/`, onde tem o mesmo custo e a mesma raridade de uso; e o `init`, que roda **uma vez na vida do projeto**, era carregado em todo `/team`.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Todos com `review` | O contrato não está mais no corpo do agente: **ler `review-contract.md` ao entrar no modo** deixa de ser redundância e passa a ser obrigatório. O alcance do papel continua declarado no agente e no comando |
| SM (onboarding) | A entrega são **cinco** leituras de entrada, não seis. O SM coordena e consolida |
| `/team init` | Lê `team-init.md` antes de criar o `.team-project/` |
| Nenhum | Nenhuma regra (R1–R17), gate, DoR/DoD ou matriz de propriedade mudou de conteúdo |

### Conflitos com o processo vigente
Nenhum. Nenhuma regra nova, nenhuma removida. A contradição interna do onboarding (cinco × seis leituras) foi **resolvida em favor do passo 4 de `workflow.md` §5a**, que já nomeava os cinco papéis explicitamente — a checklist e os três documentos derivados é que estavam errados.

### Como saberemos que funcionou
- **Footprint (§5c) — carga fixa por invocação (`agents/<papel>.md` + `commands/<cmd>.md`), antes → depois:** `/sm` 11,5 → 10,7 KB · `/po` 8,7 → 7,6 · `/arc` 12,8 → 11,7 · `/ux` 9,4 → 8,5 · `/dev` 7,6 → 6,6 · `/qa` 11,6 → 10,7 · `/team` 13,1 → 8,7. **Total 74,7 → 64,5 KB (−10,2 KB, −14%);** `/team` sozinho −33%. Movido para leitura sob demanda: `team-init.md` 3,2 KB. Primeira redução líquida registrada desde a v2.0.
- `grep -r '\.team/' --exclude='*changelog*'` retorna **zero** — e volta a zero em toda `review audit`.
- Validação mecânica de links: **0 links relativos quebrados, 0 refs `${CLAUDE_PLUGIN_ROOT}` quebradas** (era 1 e 0). Repetir a cada `review audit`.
- `claude plugin details team@team` continua listando **7 comandos e 6 agents**.
- Se em 3 ciclos algum papel executar `review` sem os quatro passos, o ponteiro para `review-contract.md` não bastou e o contrato volta, resumido, ao corpo do agente.

### Pendente do stakeholder
- **Reiniciar a sessão** — mudança em `agents/` e `commands/` só entra em vigor no próximo carregamento.
- `note.md` continua com o item aberto "revise"; esta faxina o consome parcialmente. O que sobra e não foi tocado: a duplicação dos "Princípios inegociáveis" entre `agents/architect.md` e `roles/architect/README.md` — mantida de propósito (o agente é caminho quente, o roteiro é referência), mas é candidata a remoção numa `review metrics`.
- **Pendências herdadas, não tocadas aqui** (continuam roteadas): `agents/architect.md:33` "antes do QA" → `/arc review` (v2.5); `compliance-review.md:29` e `deliverables/sdd/03-architecture.md` §2b "V1–V17" → `/arc review` (v2.3/v2.4).

---

## v2.6 — QA frente 2 ganha a redação final: objeto próprio e o terceiro achado de processo — 06/09/2026

**Instrução:** *(roteada pelo SM ao QA, `/qa review` da v2.4)* substituir a nota provisória da frente 2 (`quality-assurance/README.md:23`) pela redação final da Opção C — objeto = normativo `.team/standards/` + completude do plano ante o item, quatro estados por área de engenharia, interseção reverificada; dar ao `verdict.md` a coluna "seção exigida × citada"; acrescentar a `skills.md` §9 o terceiro caso (plano que omitiu/errou a seção exigida = achado de processo) com o método de reconhecimento.
**Classificação:** formato de documento (roteiro do QA + template de veredito + skills), sob a decisão de fluxo da v2.4 (`workflow.md` §4a).
**Registrada por:** QA, via `/qa review`. **Escopo fechado — um assunto.** *(Deliberação na resposta do `review` — R17.)*

### O que mudou
| Documento | Mudança |
|---|---|
| `roles/quality-assurance/README.md` | Frente 2: nota provisória → parágrafo **"Objeto desta frente"** (normativo + completude do plano, não reexecução do `/arc comply`); lista dos **quatro estados** (citada e aplicada · citada e divergente = reprovação R16 · exigida e ausente / citada errada = processo → `/arc review`); parágrafo da **reverificação independente da interseção**, analogia da frente 3 — não depende de o comply ter rodado |
| `templates/verdict.md` | Linha "Especificação técnica" remete à nova sub-tabela **"Frente 2 — seção exigida pelo item × seção citada no plano"** (área de engenharia · seção exigida · seção citada · estado · volta para) + nota da reverificação. Regra estendida: **dois** achados tipo `processo` a `/arc review` sem virar GAP — defeito de standard **e** omissão/citação errada |
| `skills.md` §9 | **Terceiro caso**: método de reconhecimento em 4 passos (áreas de engenharia do item pelo aceite+diff → seção que governa cada uma → confronto com o citado → sinal de alerta), distinção dos outros dois casos, rota `/arc review` sem GAP |

### Por quê (modo de falha evitado)
A nota provisória deixava a frente 2 sem objeto próprio desde a v2.2: o QA ou repetia a tabela passo × conforme do `/arc comply` (o teste da v2.4 marca isso como achado de processo contra o veredito), ou abandonava a frente por redundância aparente. Nos dois casos ninguém pega o defeito que o autor do plano **estruturalmente não vê** — a seção que o item exigia e o plano omitiu, ou a que citou errada. O terceiro caso do §9 faltava por ser o mais difícil (exige a régua do item, não a leitura do plano); sem método escrito, não seria aplicado.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| QA | Frente 2 sempre com a sub-tabela "seção exigida × citada" e os quatro estados; interseção reverificada, não delegada ao comply; omissão/citação errada = achado de processo, não de código |
| SM | Verifica a presença da sub-tabela; veredito de frente 2 que só replica a tabela do comply = achado de processo (teste da v2.4, agora com o modelo que o torna natural de cumprir) |

### Conflitos com o processo vigente
Nenhum. A v2.4 decidiu a Opção C e o posicionamento do comply; a v2.5 escreveu a contraparte do Arquiteto. Esta entrada materializa o lado do QA. `.team/standards/` não tocado (R16). A tabela de README "Eu valido contra `.team/standards/`" e a Regra do `verdict.md` já roteavam "seção não citada → achado de processo"; ficaram coerentes.

### Como saberemos que funcionou
- Todo veredito de frente 2 traz a sub-tabela "seção exigida × citada" com um dos quatro estados por linha; ausência = achado de processo do SM.
- Nenhum veredito de frente 2 que só reproduz a tabela passo × conforme do `/arc comply`.
- Ao menos um achado "seção exigida e ausente do plano" ou "citada errada" ao `/arc review` em até 3 ciclos de engenharia (indicador da v2.4). Zero em 6 → a frente 2 encolhe para nota e volta a confiar no comply.
- **Footprint (§5c):** `/qa` carga fixa = 11,5 KB (`agents/quality-assurance.md` 7,7 + `commands/qa.md` 3,8), **inalterado**. `roles/quality-assurance/` = 28,4 → 32,1 KB (+3,7 / +13,0%, dentro do teto de 20%): README 10,2→11,0, skills 6,6→8,4, verdict 2,8→3,8. Primeira medição do conjunto do QA pós-v2.0 — sem Δ anterior. **Remoção candidata (mantida da v2.2):** `skills.md` §7 (auditoria cruzada em dois passes, ~0,9 KB — repete `templates/cross-audit.md` + README `/qa audit`) e §8 (linha de base, ~0,5 KB — repete README `/qa baseline`). Seguem válidas; não removidas — escopo fechado.

### Pendente do stakeholder
- Nada novo em `agents/` ou `commands/`. `commands/qa.md:30` (comply "como remediação pós-QA") já tem ajuste proposto na v2.4 — não reaberto aqui.
- Changelog vivo agora com 5 entradas (teto 3): arquivamento de v2.1 e v2.2 segue pendente do stakeholder (v2.4/v2.5). Não toquei no arquivamento (R17).

---

## v2.5 — Obsolescência corrigida nos documentos do Arquiteto: comply sob demanda e Ficha até V21 — 06/09/2026

**Instrução:** *(stakeholder, escopo fechado — quatro itens)* posicionar o comply como revisão **sob demanda**, fora do ciclo, em `compliance-review.md:1` e no título `architect/README.md:51`; **delimitar** (linha 29, cabeçalho da §2 e Regras) que ele afere só a **aplicação** do que o plano citou, não a completude da citação — esta é da frente 2 do QA (`workflow.md` §4a); e atualizar `deliverables/sdd/03-architecture.md` §2b de "V1–V17" para **V1–V21**, registrando que a Ficha **transcreve, não origina** o número *(item roteado pelo PO, v2.3)*.
**Classificação:** formato de documento (modelo de saída do comply + modelo de entregável SDD-03) + fluxo (posicionamento do comply refletido onde ele é lido).
**Registrada por:** Arquiteto, via `/arc review`. **Escopo fechado — rodada de correção de obsolescência.** *(Deliberação na resposta do `review`, não aqui — R17.)*

### O que mudou
| Documento | Mudança |
|---|---|
| `roles/architect/templates/compliance-review.md` | Cabeçalho reescrito: sob demanda, **não é etapa do ciclo**, os dois momentos (a) iniciativa antes do QA / (b) rota de volta de achado ⚠️/❌ antes do `/dev resume`; parágrafo **"Objeto: o Plano de Execução vigente"** com a exclusão explícita da completude da citação. Nota de escopo sob o cabeçalho da §2; linha 29 reescrita para "seção **citada pelo passo** aplicada de fato — *só a aplicação do que o plano citou*". Regra nova: omissão ou citação errada é da frente 2 e vira 🔺 GAP na seção 5, nunca linha da §2. Veredito da §4 ganha a forma da rota (b) |
| `roles/architect/README.md` | Título §`/arc comply` de "antes do QA" → **"sob demanda, fora do ciclo"**; corpo ganha os dois momentos e a fronteira com a frente 2 |
| `deliverables/sdd/03-architecture.md` | §2b: **V1–V17 → V1–V21**, com os campos de V18–V21 (operações sob orçamento · comando de carga por unidade · margem de ruído medida · ambiente e baseline) e o parágrafo **"V18 transcreve, não origina, o número"** (origem = RNF de `01-requirements.md`, cinco campos de P1). Regra de pré-requisito ganha "Ficha com V18–V21 ausentes é ficha incompleta" (§7 #22). Falha comum nova: linha de V18 sem RNF de origem |

### Por quê (modo de falha evitado)
Documento obsoleto não é ruído neutro. "Antes do QA" reintroduz o comply como etapa obrigatória — a invocação de agente por item que o stakeholder recusou; a linha 29 sem delimitação faz o QA concluir que a frente 2 é redundante e abandoná-la, deixando sem dono o defeito que o autor do plano não vê. "V1–V17" faz a Ficha ser dada como completa sem V18–V21: o projeto entra em construção com desempenho nem medido nem declarado "não exercitado" — o estado que §5.6 proíbe. E sem "transcreve, não origina", o Arquiteto inventa limiar na Ficha, quebrando a cadeia PO → V18 → veredito da v2.3.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Arquiteto | Roda comply por decisão sua, não por etapa; citação omitida não vira linha de tabela — vira 🔺 GAP. Ao preencher §2b, cobre V18–V21 e aponta o RNF de origem de cada linha de V18 |
| Dev · QA | Nada muda no que executam; o modelo do Arquiteto passa a **confirmar** por escrito que a completude da citação é da frente 2 |

### Conflitos com o processo vigente
Nenhum. `commands/arc.md:16` e `commands/team.md` passo 6 já traziam a delimitação (v2.4) e ficaram coerentes com estes textos. `standards/implementation-principles.md:382` ("Ajuste antes do QA") é coluna de **consequência** do achado, não de momento — sem conflito. `.team/standards/` não foi tocado.

### Como saberemos que funcionou
- Nenhum `/arc comply` do período traz linha de §2 acusando "seção obrigatória omitida do plano" (omissão vai à seção 5 como 🔺 GAP), e toda ocorrência declara qual dos dois momentos a motivou.
- Próximo projeto que preencher a §2b entrega V18–V21 no primeiro passe, cada linha de V18 com o RNF de origem citado. Ficha em V1–V17 de novo em até 2 projetos → o modelo não está sendo lido, e a Ficha vira checklist de gate no `execution-plan.md`.
- **Footprint (§5c):** `/arc` = 12,2 KB (`agents/architect.md` 8,0 + `commands/arc.md` 4,2) · `roles/architect/` = 34,7 KB (+0,3, todo em `compliance-review.md` 4,2 → 4,5). `.team/standards/` (dono editorial) = 135,5 KB, **inalterado**. `deliverables/sdd/03-architecture.md` 4,3 → 5,0 KB. **Remoção candidata:** `architect/README.md` §"Dono editorial de `.team/standards/`" (~1,4 KB), que repete `standards/README.md` — colapsável a ponteiro. Não removido: escopo fechado.

### Pendente do stakeholder
- **`agents/architect.md:33`** — "revisar o que voltou do dev contra o padrão **antes do QA**" é o último texto obsoleto e está fora da minha caneta. Substituição proposta: *"**Aderência** — sob demanda, revisar o que voltou do dev contra o plano e o padrão: cada passo como escrito e a seção de standard que o passo citou aplicada de fato (`workflow.md` §4a)."* Não obrigatória; vigora só após reiniciar a sessão.
- Com a v2.5 o changelog vivo fica com **4 entradas** (teto = 3): arquivar a v2.1 continua pendente da v2.4. Não toquei no arquivamento (R17).

---

## v2.4 — Aderência ao plano × aderência ao standard: `/arc comply` e a frente 2 do QA verificam objetos diferentes — 06/09/2026

**Instrução:** *(roteada pelo QA, `/qa review` v2.2, para decisão de fluxo do SM)* "decidir a divisão de trabalho entre `/arc comply` e `/qa <ID>` na verificação de aderência à seção de standard citada no plano." **Decisão do stakeholder: Opção C — não é duplicação, é sobreposição mal definida.** `/arc comply` afere **plano → código** (o autor conferindo a execução da sua instrução); a frente 2 afere **standard → código** e a **completude do plano ante o item** (o plano omitiu uma seção obrigatória ou citou a errada). A interseção — seção citada aplicada no código — o QA reverifica de forma independente por ser o gate ao stakeholder.
**Classificação:** fluxo (posicionamento do `/arc comply` e objeto de cada verificação de aderência) + formato de documento (linha de gate em `workflow.md`, linha de conflito em `artifact-ownership.md`).
**Registrada por:** SM, via `/sm review`. **Escopo fechado.** *(Deliberação e reavaliação do conjunto na resposta do `review`, não aqui — R17.)*

### O que mudou
| Documento | Mudança |
|---|---|
| `process/workflow.md` | **§4a nova** — "Aderência: `/arc comply` e a frente 2 do QA verificam objetos diferentes": o `/arc comply` **não é etapa do ciclo**, é revisão sob demanda em dois momentos (proativa antes do QA · rota de volta de achado de aderência ⚠️/❌ antes do `/dev resume`); tabela objeto × pergunta; critério verificável de que o veredito da frente 2 traz "seção exigida pelo item × seção citada" com quatro estados. §8 — gate novo: "seção de standard exigida pelo item presente no plano e aplicada no código · veredito · QA · R16 · §4a" |
| `process/artifact-ownership.md` | §3 — linha nova em "Conflitos comuns": frente 2 que parece repetir o `/arc comply` → checar o que o comply não vê (plano omitiu/errou a seção que o item exigia), ponteiro a `workflow.md` §4a |

### Por quê (modo de falha evitado)
A frente 2 do QA (v2.2) e `compliance-review.md:29` checavam ambos "seção de standard citada aplicada de fato" — trabalho e tokens potencialmente duplicados, e a frente 2 carregava nota provisória "pendente do SM". Sem a separação de objeto: ou o QA repete a revisão do Arquiteto (custo sem ganho), ou abandona a frente por parecer redundante — e aí ninguém pega o defeito que o autor do plano **estruturalmente não vê**: a seção obrigatória omitida ou a citada errada. O processo também se contradizia sobre quando o comply roda (`architect/README.md:51` "antes do QA" × `commands/qa.md:30` comply como remediação pós-QA) e `workflow.md` era silencioso.

### Resolução da contradição de fluxo
`/arc comply` **fora do ciclo**, sob demanda, nos dois momentos (antes do QA por iniciativa do Arquiteto · rota de volta de achado de aderência). **Não vira etapa formal** entre dev e QA — isso adicionaria uma invocação de agente por item, e a Opção C torna a frente 2 independente do comply de qualquer forma. `workflow.md` §4a é a fonte; os textos "antes do QA" em `architect/README.md:51` e `compliance-review.md:1` são roteados ao `/arc review`. Sem mudança de custo por item.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| QA | Frente 2 nomeia, por área de engenharia do item, a seção **exigida** × a seção **citada**; omissão ou erro de citação = achado de processo ao `/arc review`, não achado de código; a interseção é reverificada, não delegada ao comply |
| Arquiteto | `/arc comply` declarado sob demanda, não etapa de ciclo; o comply responde só pela **aplicação** do que citou, não pela completude da citação |
| SM | Verifica que o veredito da frente 2 traz a coluna "seção exigida × citada"; veredito que só replica a tabela do comply = achado de processo |

### Conflitos com o processo vigente
- **`architect/README.md:51` / `compliance-review.md:1` "antes do QA" × `commands/qa.md:30` comply como remediação pós-QA.** Resolvido: comply é sob demanda nos dois momentos; `workflow.md` §4a é a fonte; edições de texto roteadas ao `/arc review`.
- Nenhum conflito com R16 — a frente 2 já era consumo obrigatório; §4a só define o objeto. Nenhuma regra nova (R18 avaliada e descartada — ver resposta do `review`).

### Como saberemos que funcionou
- Todo veredito de frente 2 do período traz a coluna "seção exigida pelo item × seção citada"; ausência = achado de processo.
- Nenhum veredito de frente 2 que apenas reproduz a tabela passo × conforme do `/arc comply`.
- Ao menos um achado de "seção obrigatória omitida do plano" ou "seção citada errada" roteado ao `/arc review` em até 3 ciclos que toquem engenharia — sinal de que a frente pega o que o comply não vê. Zero em 6 ciclos com itens de engenharia → §4a encolhe para nota e a frente 2 volta a confiar no comply.
- **Footprint (§5c):** `/sm` (`agents/scrum-master.md` + `commands/sm.md`) = 11,3 KB · `roles/scrum-master/` = 119,3 KB ativo (+ 90,2 KB de `process-changelog-archive.md`, frio). Total do papel = 130,6 KB. Esta rodada: `workflow.md` 20,6 → 23,1 KB (+2,5); `artifact-ownership.md` 8,3 → 8,6 KB (+0,3); `process-changelog.md` +7,8 KB (entrada v2.4). Primeira medição do footprint do SM pós-v2.0 — sem valor anterior para Δ. **Remoção candidata p/ a próxima `review metrics`:** os dois parágrafos finais de `workflow.md` §5a ("O que o SM pergunta primeiro..." / "O que o SM escala...") reafirmam a tabela de passos e a §6 — colapsáveis a ponteiro, ~0,6 KB. Não removido agora — escopo fechado.

### Roteamentos
| Achado | Para quem |
|---|---|
| `compliance-review.md:29` e §2 do template não delimitam que o comply afere só a **aplicação** do que o plano citou; `compliance-review.md:1` e o título `architect/README.md:51` dizem "antes do QA" — refletir o posicionamento sob demanda de `workflow.md` §4a | **`/arc review`** — instrução pronta na resposta do `review` |
| Nota provisória da frente 2 (`quality-assurance/README.md:23`) "pendente de decisão do SM — changelog v2.2" — trocar pela redação final da Opção C (objeto da frente 2, quatro estados, coluna "seção exigida × citada" no `verdict.md`, ajuste em `skills.md` §9) | **`/qa review`** — instrução pronta na resposta do `review` |
| *(carona, roteamento pendente do PO — v2.3)* `deliverables/sdd/03-architecture.md` §2b diz "A tabela **V1–V17**" e não reflete V18–V21 | **`/arc review`** — mesma instrução da v2.3 |
| Com a v2.4, o changelog vivo passa de 3 entradas | **stakeholder** — arquivar a v2.1; não toquei no arquivamento (R17) |

### Pendente do stakeholder
- **`commands/qa.md:30`, `commands/arc.md:16`, `commands/team.md` (passo 6 do `cycle`):** propostas de uma linha cada, texto pronto na resposta do `review`, para alinhar a linguagem do comply ("sob demanda", rota de achado de aderência). Não obrigatórias; vigoram só após reiniciar a sessão.
- **Confirmar** que `/arc comply` permanece **fora do ciclo** (resolução do SM) — ou, se quiser o comply como etapa formal entre dev e QA, isso adiciona uma invocação de agente por item e precisa do seu aval.

---

## v2.3 — PO ganha a forma completa do RNF de performance e a cadeia RNF → V18 → veredito — 06/09/2026

**Instrução:** *(roteada pelo Arquiteto, `/arc review` das v2.1–v2.2)* "P1 cobra do PO uma forma de escrever RNF que os modelos dele não ensinam. Ensinar em `deliverables/sdd/01-requirements.md` a forma completa do RNF de performance — os cinco campos de P1, com exemplo preenchido e contraexemplo, mantendo o princípio que já está lá. Fazer `templates/requirement.md` carregar os cinco campos quando o requisito for de performance. Deixar explícita a cadeia: PO escreve o RNF com os cinco campos → Arquiteto transporta para a Ficha V18–V21 (V18 = lista fechada) → QA valida e registra três estados (dentro · fora · não exercitado); operação fora de um RNF não é medida por ninguém. Decidir se o critério de aceite de item que toca operação sob orçamento menciona desempenho explicitamente ou basta o RNF existir."
**Classificação:** formato de documento (modelo de entregável SDD-01 + template de requisito + template de aceite) + escopo de papel (o PO passa a responder pela completude do RNF de performance e por decidir o que entra em V18).
**Registrada por:** PO, via `/po review`. **Escopo fechado.** *(Deliberação e reavaliação do conjunto na resposta do `review`, não aqui — R17.)*

### O que mudou
| Documento | Mudança |
|---|---|
| `deliverables/sdd/01-requirements.md` | Segundo exemplo no bloco Estrutura (RNF de performance com os 5 campos). Bullet de Regras desdobrado (5 campos obrigatórios; faltando um, volta ao PO — §7 #18). **Seção nova "RNF de performance — a forma completa"**: tabela dos 5 campos com o erro que invalida cada um; exemplo preenchido (RNF-014, números ilustrativos); contraexemplo; subseção **"A cadeia"** (PO → Arquiteto/V18–V21 → QA/três estados) com a consequência "operação fora de um RNF não entra em V18 e não é medida por ninguém — o que entra é decisão do PO"; subseção sobre o critério de aceite de item que toca V18 |
| `roles/product-owner/templates/requirement.md` | Bloco **"Orçamento de desempenho"** (tabela dos 5 campos, obrigatório se o requisito fixa tempo de resposta ou vazão) antes do Critério de aceite; linha de critério condicional apontando o comando de V19. Duas Regras novas (5 campos obrigatórios; requisito que toca V18 menciona desempenho no critério — RNF não substitui). Exemplo novo de requisito de performance |
| `roles/product-owner/templates/acceptance.md` | Regra nova: aceite de item que toca V18 confere o estado do QA (dentro · fora · não exercitado) e a saída real do comando de V19; "fora" = rejeição, "não exercitado" sem motivo = rejeição |
| `roles/product-owner/README.md` | `/po requirement` ganha passo 4: requisito de performance carrega os 5 campos de P1 |
| `roles/product-owner/skills.md` | §3 ganha parágrafo: para RNF de performance "verificável" tem forma fixa — os 5 campos; "responder em 400 ms" sozinho não é RNF |

### Por quê (modo de falha evitado)
P1 (`implementation-principles.md` §5.6) e a Consequência #18 passaram a **devolver ao PO** todo RNF de performance sem cinco campos, e a frente 6 do QA (v2.2) reprova com base nisso — mas o material do PO só ensinava dois dos cinco campos ("500 ms no p95"). Um PO seguindo o modelo escreveria um RNF que o Arquiteto devolve, travando o item antes da construção. Sem a cadeia documentada do lado do PO, ninguém registrava que **V18 é lista fechada alimentada pelo RNF**: operação que o PO não colocasse num RNF ficava sem medição e sem responsável, e o "não exercitado" do QA parecia acidente, não decisão do PO.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| PO | RNF de performance sai com os 5 campos ou não é RNF; decide explicitamente quais operações entram em V18 (via RNF); no aceite de item que toca V18, confere o estado de desempenho e a saída de V19 |
| Arquiteto | Recebe do PO os 5 campos prontos para transcrever em V18–V21 (a cadeia agora está escrita dos dois lados) |

### Decisão — critério de aceite de item que toca operação sob orçamento
**O critério de aceite do item menciona o desempenho explicitamente** (operação, percentil, limiar), com "como verificar" apontando o comando de V19 — o RNF existir no documento **não basta**. Régua do PO: critério de aceite sem verificação não existe; "implementado" ≠ "funcionando". Número que só vive no documento de requisitos não prova que *aquela* entrega foi medida; para o QA tirar o item de "não exercitado" é preciso ter rodado o cenário, e isso só é cobrável se o critério do item declarar o estado e a saída esperados. Aplicado em `01-requirements.md`, `requirement.md` e `acceptance.md`.

### Conflitos com o processo vigente
- Nenhum. O material do PO era **incompleto** ante P1, não contraditório; o princípio "500 ms no p95" foi mantido e estendido, não substituído.

### Como saberemos que funcionou
- Zero RNF de performance sem os cinco campos entrando em Plano de Execução, em até 3 ciclos (mesmo indicador de standards v2.1, agora com o modelo que o sustenta).
- Todo item que toca operação de V18 tem, no critério de aceite, a linha de desempenho com o comando de V19 — verificável nos requisitos e nos aceites do período.
- Nenhum "não exercitado" no veredito do QA sem motivo declarado que o PO tenha aceitado.
- Sinal de excesso contrário: 3 ciclos sem nenhum RNF de performance escrito e sem item tocando V18 → "A forma completa" encolhe para ponteiro ao §5.6 do standard.
- **Footprint (§5c):** `/po` + `roles/product-owner/` = **25,8 → 29,1 KB** (+3,3 / +12,6%, dentro do teto de 20%), quase toda em `requirement.md` (+2,3). O modelo de entregável `deliverables/sdd/01-requirements.md` (fora da métrica de §5c): 2,5 → 6,3 KB. **Remoção candidata p/ a próxima `review metrics`:** o exemplo RF-017a de `requirement.md` e o exemplo ABC-01 de `acceptance.md` ilustram a mesma entrega (download assinado); um dos dois pode virar ponteiro (~0,8 KB). Não removido agora — escopo fechado.

### Roteamentos
| Achado | Para quem |
|---|---|
| `deliverables/sdd/03-architecture.md` (modelo do Arquiteto) diz "A tabela **V1–V17**" e lista campos só até "métricas, estágios de CI" — não reflete V18–V21 (criadas na v2.1) nem registra que os cinco campos de V18 chegam vindos do RNF de performance do `01-requirements` | **`/arc review`** — instrução: *"atualizar `deliverables/sdd/03-architecture.md` §2b: a Ficha vai até V21; acrescentar V18–V21 (operações sob orçamento, comando de carga, margem de ruído, ambiente/baseline) e registrar que os cinco campos de V18 vêm do RNF de performance do `01-requirements` — a Ficha transcreve, não origina o número."* |
| Com a v2.3, o changelog vivo passa de 3 entradas | **SM** — arquivar a mais antiga (v2.0); não toquei no arquivamento (R17) |

### Pendente do stakeholder
- **`agents/product-owner.md`** / **`commands/po.md`**: sem mudança obrigatória. Proposta opcional de uma linha em "Regras de conduta" do agente — texto pronto na resposta do `review`. Vigora só após reiniciar a sessão.

---

## v2.2 — QA alinhado a R16 e ganha a frente de desempenho; veredito endereçado ao stakeholder — 06/09/2026

**Instrução:** *(mandato ao QA, literal)* "Um ponto chave do qa é ser o gate para o stakeholder, ele é quem deve validar para responder ao stakeholder que eu tenho um produto de qualidade, seguro, performático, consistente com os requisitos e funcional. Falhas devem voltar para a construção e, dependendo do problema, resolução do time. Dependendo do problema necessitará de uma visão especialista mais aprofundada com o arquiteto." Derivadas: aplicar R16 ao QA em três camadas (espelhando o `/arc review` da v1.9); criar a frente de desempenho (roteamento da v2.1) — `implementation-principles.md` §5.6 e Ficha V18–V21, três estados (dentro do orçamento · fora · não exercitado), desvio de limiar = reprovação; resolver duas incoerências entre papéis.
**Classificação:** escopo de papel (QA) + formato de documento (veredito, registro de GAP, auditoria cruzada) + controle de qualidade novo (frente de desempenho) + fluxo (fronteira `/arc comply` × frente 2, roteada).
**Registrada por:** QA, via `/qa review`. **Escopo fechado.** *(Deliberação e reavaliação do conjunto ficam na resposta do `review`, não aqui — R17.)*

### O que mudou
| Documento | Mudança |
|---|---|
| `roles/quality-assurance/README.md` | Abertura: veredito **endereçado ao stakeholder** (qualidade, segurança, desempenho, requisitos, funcionalidade); PO segue dono do aceite de valor (matriz inalterada). `.team/standards/` entra em "Entradas" e em "Não faz" (é do Arquiteto). Frente 2 nomeia `<arquivo> §<n>`; desvio = **reprovação, não ressalva**. Frente 4 cita a fonte do limiar (§5.4/§5.5). **Frente 6 — Desempenho** (§5.6 P1–P6, V18–V21, três estados, evidência = saída real de V19). Seção nova "Eu valido contra `.team/standards/`, não escrevo" (tabela errado × certo, simétrica à do dev). Seção nova "Escada de falha": **construção (dev) → time (`/team`) → Arquiteto (`/arc question`/`plan`)**, com o que caracteriza cada degrau; PO como rota paralela |
| `roles/quality-assurance/skills.md` | **§9** distingue desvio de standard no código (achado = reprovação) de defeito no próprio standard (achado de processo → `/arc review`), com os três sinais e o que **não** é defeito. **§10** "Exercitar desempenho como número": lista fechada V18, evidência = saída de V19, três estados, item de V18 sem saída = achado bloqueante |
| `roles/quality-assurance/templates/verdict.md` | Linha **Desempenho** na tabela de frentes; evidência da `§` de standard na linha "Especificação técnica"; achados ganham coluna **Tipo (código/processo)** e "Volta para" cobrindo a escada; três regras novas (desvio de standard = reprovação; desempenho sempre num dos três estados; cobertura/desempenho sem saída no relatório não vai a "ok") |
| `roles/quality-assurance/templates/gap-record.md` | Campo **`Tipo: código | processo`** (espelha `plano | standard` do `gap.md` do dev) + tabela de contraste: achado de processo **não** abre item no registro de GAPs do projeto e não fecha com a decisão técnica |
| `roles/quality-assurance/templates/cross-audit.md` | Bloco novo "Achados de processo em `.team/standards/` — rota `/arc review`" + regra: incoerência de standard é achado de processo roteado, nunca GAP de projeto nem correção na auditoria |

### Por quê (modo de falha evitado)
R16 alcançou Arquiteto e dev (v1.9) mas **não o QA** — zero menções a `standards`/`R16` em `roles/quality-assurance/`. Sem isso: o QA rebaixa desvio de standard a ressalva (item passa com dívida invisível), ou reprova o dev por defeito do próprio normativo (que ele não tinha como cumprir) em vez de rotear ao dono. A frente de desempenho não existia porque desempenho não tinha forma de verificação até a v2.1; agora tem, então **critério verificável precisa entrar no veredito** — senão "performático" vira impressão ou some por omissão.

### Quem é cobrado de forma diferente
| Papel | O que muda |
|---|---|
| QA | Valida contra a `§` de standard citada no plano (desvio = reprovação); roda a frente 6 em todo item que toca V18; classifica cada achado por Tipo e por degrau da escada; nunca edita `.team/standards/` |
| Arquiteto | Recebe do QA **achado de processo** (defeito de standard) como insumo do `/arc review` seguinte, ao lado do 🔺 GAP do dev |
| stakeholder | Recebe veredito que se declara endereçado a ele, com um dos três estados de desempenho sempre presente |

### Conflitos com o processo vigente
- **Frente 2 × `compliance-review.md:29` (`/arc comply`)** — ambos checam "seção de standard citada aplicada de fato"; possível trabalho duplicado. **É questão de fluxo — não resolvido aqui:** roteado ao `/sm review` com duas posições. Frente 2 redigida nomeando o standard (instrução explícita), com nota de que a profundidade ante o `/arc comply` aguarda o SM.
- **`delivery-report.md:52` define conduta do QA** ("o QA trata como não verificado") sem que os documentos do QA a registrassem. **Resolvido registrando a conduta** em `verdict.md` (Regras) e `skills.md` §10 — conduta minha a documentar, sem roteamento.
- Nível 2 afrouxando nível 1: nenhum — QA só consome.

### Como saberemos que funcionou
- Nenhum veredito de item que toca V18 omite a frente 6; cada um traz um dos três estados ("não exercitado" com motivo conta como sucesso).
- Todo desvio de standard sai como reprovação (não ⚠️); todo achado de processo aparece no roteamento do veredito **e** na fila do `/arc review` seguinte.
- Zero commits de `/qa` tocando `.team/standards/**` (violação de R16, verificável no histórico).
- Sinal de excesso contrário: 3 ciclos sem item tocar V18 e sem achado de processo → frente 6 encolhe para nota, §10 vira ponteiro.
- **Footprint (§5c):** `/qa` + `roles/quality-assurance/` = **27,4 → 38,7 KB** (+11,3 / +41%; toda em `README.md` +5,1 e `skills.md` +3,3). Cresce acima do limiar de 20% de §5c, mas com regra nova (R16 no QA) e frente nova (6) que a justificam. **Remoção candidata p/ a próxima `review metrics`:** `skills.md` §7 e §8 reexplicam a auditoria de dois passes e a linha de base que `cross-audit.md` e o roteiro `/qa baseline` já especificam — colapsáveis a ponteiros, ~1,2 KB. Não removidas agora (escopo fechado).

### Roteamentos
| Achado | Para quem |
|---|---|
| Fronteira `/arc comply` × frente 2 na checagem da `§` de standard aplicada de fato — possível duplicação de trabalho e de tokens | **`/sm review`** — instrução: *"decidir a divisão de trabalho entre `/arc comply` e `/qa <ID>` na verificação de aderência à seção de standard citada no plano. Posição A: QA confia no `/arc comply` (pré-checagem do dono editorial, 'antes do QA') e só amostra quando ele foi pulado, houve GAP de standard no item, ou outra frente aflora divergência. Posição B: QA verifica de forma independente por ser consumidor obrigatório (R16) e por o veredito ser o gate ao stakeholder — como já faz a frente 3 de segurança apesar do checklist no plano. Ajustar a nota da frente 2 do QA conforme a decisão."* |
| Com a v2.2, o changelog vivo passa de 3 entradas | **SM** — arquivar a mais antiga (não toquei no arquivamento — R17) |

### Pendente do stakeholder
- **`agents/quality-assurance.md`** e **`commands/qa.md`**: "cinco frentes" → "seis frentes", com a frente 6 (Desempenho) conforme a frente 6 do roteiro. Texto pronto na resposta do `/qa review`. Vigora só após reiniciar a sessão.
- **Decisão de fluxo** roteada acima (fronteira `/arc comply` × frente 2) — o QA não a resolve sozinho.

---

## v2.1 — PERF-TEST fechada: desempenho vira obrigação verificável nos dois níveis do `standards/` — 06/09/2026

**Instrução:** *(mandato ao QA)* "ele é quem deve validar para responder ao stakeholder que eu tenho um produto de qualidade, seguro, **performático**, consistente com os requisitos e funcional" — derivada: "feche PERF-TEST em `.team/standards/` respeitando os dois níveis; cada obrigação nova precisa de como se verifica; não invente threshold numérico universal".
**Classificação:** conteúdo normativo (níveis 1 e 2) + regra nova com gate + formato de documento (Ficha e quadro de verificação).
**Registrada por:** Arquiteto, via `/arc review`. **Escopo fechado** — só PERF-TEST. *(8,1 KB: acima do alvo de 6 de R17, dentro da barreira de 10; cobre cinco documentos e três roteamentos com instrução literal.)*

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `standards/implementation-principles.md` | **§5.6 nova** · §5.1 · §7 · §8 · v1.0→**1.1** | §5.6 "Desempenho — RNF verificável, orçamento e regressão", seis obrigações com verificação: **P1** RNF só existe com cinco campos (operação · percentil · limiar · condição de carga · ambiente); **P2** orçamento é lista fechada, com a fronteira "fora da lista não bloqueia" e o estado válido "não exercitado"; **P3** cenário é código versionado com o limiar dentro dele e saída ≠ 0, sem dado pessoal de produção; **P4** baseline medida, nunca declarada; **P5** regressão = piora acima da **margem medida**, e quando bloqueia; **P6** evidência é a saída real, e quando se exercita. §5.1 ganha o nível **Carga**; §7, as linhas **18–22**; §8, o passo 7 |
| `standards/implementation-principles.md` | §6 — Ficha | **V18–V21 novas**: operações sob orçamento (5 campos) · ferramenta e comando de carga por unidade implantável · **margem de ruído medida** · ambiente e onde vive a baseline. "Nenhuma operação" é resposta válida — **escrita**, não omitida |
| `standards/implementation-guide.md` | Pendências · §9.1 · **§9.6 nova** · v3.2→**3.3** | PERF-TEST **fechada**. Ferramenta **decidida**: k6 na borda HTTP (cenário fora da solution, `thresholds` com exit ≠ 0), NBomber só para alvo não-HTTP. Layout `tests/perf/`, forma obrigatória do cenário, seis regras com verificação, comando local |
| `standards/implementation-quality.md` | Pendências · Visão Geral · §4 · **§4.2 nova** · §5 · v1.3→**1.4** | PERF-TEST **fechada**. Estágio `test-perf` com **dois jobs distintos**: `perf-budget` (limiar de V18) e `perf-regression` (baseline + margem de V20). Quatro linhas novas no "o que bloqueia o merge" |
| `standards/README.md` | Índice · "Por dúvida" | Rota de leitura de desempenho pelos três documentos, com a guarda "os números são do projeto, na Ficha V18–V21" |

### Por quê
Enquanto PERF-TEST era "Definição Futura", **desempenho não tinha forma de verificação** — e critério sem verificação não entra no veredito. Restavam dois modos de falha: o QA declarar "performático" por impressão (aprovação sem evidência, o oposto do mandato) ou performance sumir do veredito por omissão. Agora só há três estados, todos explícitos: **dentro do orçamento**, **fora** (exit ≠ 0) ou **não exercitado** (V18 vazia). O nível 1 fixa a obrigação sem um único número: normativo agnóstico com limiar de latência estaria acomodando um caso de produto, o que a §10 das skills do Arquiteto proíbe.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Arquiteto | Preenche V18–V21 na Ficha de todo projeto (vazia é resposta; ausente não é) e cita §5.6 no passo de plano que toca operação sob orçamento |
| dev | Item que toca operação de V18 traz a **saída real** do comando no relatório; cenário sem `thresholds` não conta como entregue |
| QA | Ganha do normativo o que faltava para julgar desempenho — a frente em si é dele (ver roteamento) |
| PO | RNF de performance sem os cinco campos **volta para ele**; o item não entra em construção (§7 #18) |

### Conflitos com o processo vigente
- **Nível 2 afrouxando o nível 1:** nenhum — §9.6 e §4.2 só traduzem ferramenta, caminho e comando.
- **Ferramenta não-.NET num perfil .NET (k6):** resolvido em §9.6 — o perfil descreve a stack do produto, não obriga o teste de carga à mesma linguagem; cenário fora da solution é o que impede ele referenciar tipo interno.
- **Bloquear regressão relativa × gate que trava o time:** resolvido com válvula visível — a saída é atualizar a baseline no mesmo merge, o que põe a piora no diff, não no log do pipeline.
- **Escopo antecipado (princípio 5) × medir performance:** resolvido pela fronteira de P2 — mede-se só operação declarada em V18.

### Como saberemos que funcionou
- **Toda Ficha de Vinculação tem V18–V21 preenchidas ou declaradas vazias com motivo** — contável nas fichas dos documentos de arquitetura; linha ausente é achado.
- **Nenhum veredito do QA omite desempenho** — cada um traz um dos três estados; "não exercitado" conta como sucesso do normativo, não como falha.
- **Zero RNF de performance sem os cinco campos entrando em Plano de Execução**, em até 3 ciclos.
- **Sinal de excesso na direção contrária:** se em 3 ciclos nenhum projeto declarar uma operação em V18 e nenhum GAP citar §5.6, a seção encolhe para nota — skills do Arquiteto §10, não reforço da regra.
- **Footprint (PDCA, workflow §5c):** `.team/standards/` ≈ 117,4 → **135,5 KB** (≈ +18 KB / +15%), sendo 13,2 KB nas três seções novas. É a maior adição de uma rodada até aqui, e fecha a última pendência que impedia uma frente inteira de validação. **Nenhuma remoção candidata** — escopo fechado; a próxima `review metrics` do Arquiteto deve olhar §9.6 e §4.2 primeiro, por serem os blocos mais novos e menos exercitados.

### Roteamentos desta rodada
| Achado | Onde | Para quem |
|---|---|---|
| A frente de performance do QA não existe: as cinco frentes não a citam | `roles/quality-assurance/*` | **`/qa review`** — instrução: *"crie a frente de desempenho citando `implementation-principles.md` §5.6 e a Ficha V18–V21: o veredito registra um de três estados (dentro do orçamento · fora · não exercitado), a evidência é a saída real do comando de V19, e desvio de limiar é reprovação, não ressalva"* |
| O modelo de RNF do PO não cobra os cinco campos de P1 | `deliverables/sdd/01-requirements.md` · `roles/product-owner/templates/requirement.md` | **`/po review`** — instrução: *"RNF de performance declara operação · percentil · limiar numérico · condição de carga (taxa/usuários e duração) · ambiente; sem os cinco campos, não entra em construção (`implementation-principles.md` §5.6 P1)"* |
| Com a v2.1, o changelog vivo fica com **4** entradas — o teto é 3 | `process-changelog.md` | **SM** — arquivar a v1.8; não toquei no arquivamento |

### Pendente do stakeholder
- **Decisão de ambiente e custo (única, e é dele):** onde a carga roda — ambiente dedicado ou staging compartilhado — e quem paga a janela de execução. O normativo exige que a resposta seja **escrita em V21**; ele não pode escolher por ninguém. Enquanto não houver ambiente, o estado correto é "não exercitado", não "aprovado".
- **`agents/` e `commands/`:** nada a propor nesta rodada.

---

## v2.0 — Changelog arquivado, contrato do `review` extraído, ciclo de eficiência PDCA e teto por entrada (R17) — 06/09/2026

**Instrução:** "o importante é que o time se aperfeiçoe continuamente, então os documentos envolvidos por cada role deve validar essa eficiência em um modelo tipo PDCA"; criar um teto por entrada de changelog que impeça a inflação sem custar rastreabilidade; corrigir o registro da R16 (base de referência comum já decidida).
**Classificação:** fluxo/cerimônia (PDCA sobre gatilhos existentes) + formato de documento (retrospectiva, changelog) + regra nova (R17) + correção de registro (R16) + estrutura de `.team/` já aplicada pelo stakeholder (arquivamento do changelog, extração do contrato do `review`).
**Registrada por:** SM, via `/sm review`. **Aplica R17 a si mesma** — primeira prova do teto: cobre cinco mudanças em ~7 KB (acima do alvo de 6, bem abaixo da barreira de 10), com a deliberação fora da entrada.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `process/process-changelog.md` + `process-changelog-archive.md` | topo · "Teto de leitura" · "Versões arquivadas" | *(mecânico, stakeholder)* mantém as 3 entradas recentes + tabela de arquivadas; v1.6–v1.0 movidas **íntegras** para o arquivo (82 KB → 43,9 KB). Arquivar é relocar, não reescrever — o invariante "entrada antiga nunca muda" segue |
| `commands/review-contract.md` | arquivo novo (4,4 KB) | *(mecânico, stakeholder)* núcleo comum do `review` (4 passos, tabela de reavaliação, limites, modos auxiliares) extraído dos 5 comandos; lido só no modo `review`. Cada comando mantém inline só o **alcance** e os **cuidados** do papel |
| `process/working-rules.md` | Bloco C · **R17 nova** · "Como o SM aplica" (linha + parágrafo PDCA) · "Resumo em uma tela" | R17: entrada de changelog registra a **decisão, não a deliberação** — alvo ~6 KB, barreira 10 KB, campos fixos do modelo; raciocínio de uma vez sai da entrada (vai para a resposta do `review` ou para nota de racional no documento normativo, modelo `artifact-ownership.md` §1a); correção é addendum datado |
| `process/workflow.md` | §5 (2 linhas) · **§5c nova** | §5c: PDCA de eficiência mapeado em gatilhos que já existem — **Plan** em `review metrics`, **Do** na operação + `/<papel> review`, **Check** no `review` sem instrução + retrospectiva, **Act** em `review metrics`. Métrica por papel (KB de `agents/`+`commands/`+`roles/<papel>/`), gatilhos de limiar, onde fica registrado |
| `templates/retrospective.md` | métricas · Regras | Linha "carga fixa dos documentos do processo (KB): atual / retro anterior / Δ · causa · ação" como fase Check, série contínua entre giros; bullet de Regras explicando a medição e o encaminhamento a `review metrics` |
| `roles/scrum-master/skills.md` | §7 | Métrica "footprint dos documentos" por papel |
| `.team/README.md` | "Regras que governam todos" | "16 regras … R13-R16" → "17 regras … R13-R17" |
| `process-changelog.md` v1.8 e v1.9 | "Pendente do stakeholder" | Addendum datado marcando a R16 resolvida — texto original intacto |

### Por quê
1. **A eficiência dependia de faxina do stakeholder.** O arquivamento e a extração do contrato foram feitos à mão porque nenhum gatilho do time media o custo dos próprios documentos. O PDCA de §5c põe a medição (em KB) no `review` sem instrução e na retrospectiva, e o corte no giro de `review metrics` — os gatilhos já existiam; faltavam a métrica e o alvo (uma remoção candidata por giro).
2. **A entrada de changelog inflou 12× em 9 versões** (v1.0 = 1,4 KB → v1.8 = 17,1 KB). A v1.8 é grande por deliberação repetida e por conteúdo que já está em `artifact-ownership.md` §1a e em `deliverables/README.md` — não por decisão que só existe ali. R17 separa registro permanente (fica) de raciocínio de uma vez (sai), preservando a análise de conflito como **uma linha de veredito** por conflito e como nota de racional no documento normativo que ela governa.

### Correção de registro — R16 "base de qualidade compartilhada"
v1.8 e v1.9 deixaram pendente a leitura de "compartilhada". **Stakeholder decidiu: base de referência comum** — Arquiteto dono editorial, dev e QA consumidores. O modelo editor/consumidores já aplicado vale sem alteração; a leitura "caneta compartilhada para o dev" fica descartada e a v1.3 não reabre. Addendum datado anexado às duas entradas, sem tocar o texto original.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Todo papel com `review` | No `review` sem instrução, mede o footprint dos próprios documentos e compara com o valor anterior; footprint que cresce sem regra ou cerimônia nova é candidato a corte, não a nota |
| SM | Na retrospectiva mede o footprint total do processo e registra a série; no giro de `review metrics` consolida a tabela por papel e tira **uma** remoção; toda entrada de changelog que escrever cabe em R17 (10 KB é barreira) |

### Conflitos com o processo vigente
Nenhum. R17 reforça o invariante do changelog ("entrada antiga nunca é reescrita"): arquivar e anexar addendum datado não são reescrita. O PDCA não cria cerimônia — usa `review metrics`, retrospectiva e `review` sem instrução, todos já normativos.

### Como saberemos que funcionou
- **Indicador primário — carga fixa por invocação (KB), antes → depois** *(medido pelo stakeholder nesta rodada)*: `/sm` 14,2→11,3 · `/arc` 14,0→11,9 · `/qa` 12,3→10,3 · `/po` 10,3→8,2 · `/ux` 11,2→9,2 · `/dev` 7,5 (inalterado). Total dos 5 comandos: 28,0→17,0 KB (**−39%**). Zero links quebrados.
- **R17:** nenhuma entrada de changelog acima de 10 KB a partir desta; v2.0 fecha em ~7 KB cobrindo cinco mudanças. As três anteriores — v1.7 (11,7), v1.8 (17,1), v1.9 (11,5) — teriam disparado a barreira.
- **PDCA:** a cada giro de `review metrics`, a tabela de footprint por papel existe e o período produz ao menos uma remoção candidata nomeada; o footprint total de `.team/` não cresce dois giros seguidos sem remoção.
- **Sinal de excesso na direção contrária:** se em 3 giros nenhuma remoção for possível e nenhum footprint crescer, baixar a cadência de medição para cada 6 retrospectivas.

### Pendente do stakeholder
- **`agents/scrum-master.md:45`** — "As 16 regras … método R13-R16" → "As 17 regras … método R13-R17".
- **`commands/review-contract.md`** (bullet `review metrics`) — acrescentar: "inclui o giro **Act** do ciclo de eficiência (workflow §5c) — cada papel reporta o footprint dos próprios documentos, o SM consolida na tabela por papel e a proposta única do período pode ser uma remoção".
- **`commands/sm.md`** (opcional, modo `review`) — uma linha lembrando que `review metrics` é o giro Act do PDCA de eficiência.
- Mudança de comportamento de agente/comando só vigora após **reiniciar a sessão**.

### Roteamentos desta rodada
Nenhum. Todos os documentos tocados estão no alcance do `/sm review` (normativos que governam todos + roteiro/skills/templates do SM + curadoria do `.team/README.md`). Os papéis PO, Arquiteto, UX e QA passam a medir o próprio footprint no `review` sem instrução por força de R17/§5c — é aplicação de regra, não edição dos documentos deles; cada um pode tornar a medição explícita no próprio texto no seu próximo `/<papel> review`.

---

## v1.9 — Arquiteto e dev revistos à luz de `.team/standards/` como base compartilhada; GAP de tipo `standard` ganha forma — 05/09/2026

**Instrução:** "reveja o roteiro e as skills do Arquiteto e do dev à luz de `.team/standards/` como base de qualidade compartilhada (R16 / artifact-ownership §1a): o Arquiteto é dono editorial e responde pela coerência nível 1 × perfis de nível 2; o dev é consumidor obrigatório — aplica a seção citada no plano e levanta 🔺 GAP quando o standard tem contradição, lacuna ou regra inverificável, sem corrigir de passagem; atualize o caminho para `.team/standards/` e a referência ao novo diretório de primeiro nível; e ajuste `.team/standards/README.md` conforme o roteamento acima"
**Classificação:** escopo de papel (Arquiteto e dev) + formato de documento (modelos de plano, GAP, relatório de entrega, revisão de aderência, decisão técnica) + conteúdo normativo (`.team/standards/`)
**Registrada por:** Arquiteto, via `/arc review` — roteamento da v1.8. **Cobre as duas execuções do mesmo `/arc review`**: a primeira foi interrompida por erro de API antes de registrar; esta entrada consolida tudo.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `standards/README.md` | cabeçalho · **tabela R16 nova** · "Como usar" | "Pasta do Arquiteto" → "**normativo de engenharia do time, mantido pelo Arquiteto**", diretório de primeiro nível irmão de `deliverables/`. Tabela quem escreve / quem consome / **canal de defeito por papel** (dev: 🔺 GAP; QA: achado de processo), regra de desempate e subtabela "Como consome" por papel |
| `standards/implementation-security-lgpd-copyright.md` | cabeçalho · nota de agnosticismo | Ponteiro de aplicação concreta passa a `.team-project/README.md` §4 (sem nome de produto). **`Nível: transversal`** acrescentado ao cabeçalho, para casar com a coluna "Nível" do índice de `standards/README.md`. Versão 1.0 → **1.1** |
| `standards/implementation-guide.md` | **linha 17** · cabeçalho | **Vazamento de contexto de produto removido:** o exemplo `../sdd/03-architecture.md` "para a plataforma Ploteon" foi trocado pelo ponteiro genérico `.team-project/README.md` §4. Era a única ocorrência de nome de produto em todo o `.team/` fora deste changelog. Versão 3.1 → **3.2** |
| `roles/architect/README.md` | tabelas de responsabilidade · **"Dono editorial de `.team/standards/` (R16)" nova** · `/arc plan` · `/arc review` · "Como sei que estou funcionando" · "Documentos que administro" | Formaliza o papel de **dono editorial** e as três obrigações que decorrem dele (citar a seção em todo plano de engenharia; responder pela precedência nível 1 × nível 2; tratar 🔺 GAP de standard e achado do QA como insumo obrigatório do `review` seguinte). `/arc plan` passa a exigir citação **com número** e proíbe liberar plano que dependa de standard defeituoso |
| `roles/architect/skills.md` | §6 · §9 · **§10 nova** | §10 "Manter um normativo que outros dois papéis consomem": escrever para quem consome (obrigação + **como se verifica** + fronteira), guardar a precedência nível 1 × nível 2, tratar defeito reportado como defeito (destravar o item primeiro, corrigir no `review`), e o sinal de que o normativo virou enfeite — três ciclos sem citação e sem defeito → **encolher** |
| `roles/architect/templates/execution-plan.md` | §3 (campo novo) · §8 · **regra 10 nova** | Campo **"Standard aplicável: `<arquivo>` §`<n>`"** por passo, obrigatório quando o passo tem regra de engenharia. Item fixo em "onde parar e perguntar": standard contraditório/lacunar/inverificável → 🔺 GAP. Regra 10: "seguir os standards" não é citação |
| `roles/architect/templates/compliance-review.md` | §2 (linha nova) · §5 | Linha de verificação "seção de standard citada em cada passo **aplicada de fato** no código"; §5 passa a registrar o defeito de standard levantado no item, que entra na fila do próximo `/arc review` |
| `roles/architect/templates/technical-decision.md` | Classificação · Regras | Nova classificação **"Defeito no standard"** — decidir agora para destravar **e** enfileirar no `/arc review`; regra explícita de nunca editar `.team/standards/` no meio de um item nem mandar "ignorar a regra por enquanto" sem registro |
| `roles/developer/README.md` | tabelas · **regra 8 nova** · **"`.team/standards/` — eu consumo, não escrevo" nova** · roteiro (passo 2a) · lista de gaps | Standards entram como **entrada** do papel. Tabela de 4 situações errado × certo. Passo 2a do roteiro: ler **só** as seções citadas (R3). Frase fechada: "eu **nunca** edito arquivo em `.team/standards/`" |
| `roles/developer/skills.md` | §8 · **§9 nova** · §9→§10 | §9 "Consumir o normativo de engenharia sem editá-lo": ler só o que o plano citou; **tabela dos três sinais de defeito** (contradição · lacuna · regra inverificável) e o que **não** é defeito (não entendi / dá trabalho / eu faria diferente); rotear, nunca consertar — com as três saídas erradas nomeadas. §8 passa a citar §4.4 e troca "~50 linhas, 10 caminhos" pelos limites exatos da fonte única (50 linhas, **10 de complexidade ciclomática**, 4 parâmetros) |
| `roles/developer/templates/gap.md` | bloco do modelo · "quando levantar" · **seção nova** · "quando não levantar" · regras · exemplo 2 | Campo **`Tipo: plano | standard`** no modelo, com duas linhas próprias (`Standard citado` + `Defeito`). Seção nova caracterizando o defeito de standard, com o que **não** é defeito. Regra nova: **GAP de tipo `standard` não fecha com a resposta** — a decisão destrava o item, o documento se corrige no `/arc review`. Exemplo 2 completo, do tipo `standard` |
| `roles/developer/templates/delivery-report.md` | campo "Gaps levantados" · Regras | Gap passa a declarar o tipo. Duas regras novas: GAP de tipo `standard` **permanece no relatório mesmo depois de respondido** (é a trilha que o leva ao `review`); e **nenhum arquivo de `.team/standards/` aparece em CRIADOS/ALTERADOS/REMOVIDOS** |

### Por quê
R16 (v1.8) criou o modelo **editor / consumidores** mas parou na porta dos papéis: os documentos do Arquiteto ainda tratavam `standards/` como pasta própria, e os do dev não diziam **o que fazer** ao encontrar um standard quebrado. Sem isso, R16 falha de dois jeitos previsíveis. Do lado do dev: ele topa com uma contradição no meio do passo e resolve como sempre se resolveu — improvisando uma leitura e seguindo, ou "arrumando" o texto de passagem. Nos dois casos o normativo deriva sem ninguém notar, que é exatamente o que R16 existe para impedir. Do lado do Arquiteto: sem a citação **com número** no plano, "siga os standards" vira fórmula, o dev não lê nada e o normativo vira enfeite.

A peça que faltava era **operacional, não conceitual**: o dev júnior precisa reconhecer o defeito por sinal objetivo (são três, e só três), saber que isso tem um tipo de GAP próprio, e saber que a resposta do Arquiteto destrava o item mas **não** fecha o defeito do documento. Daí o `Tipo:` no modelo de GAP e a permanência dele no relatório — é a trilha física que faz o defeito chegar ao `/arc review` seguinte, que é o indicador (c) da v1.8.

O vazamento "Ploteon" no `implementation-guide.md:17` é do mesmo problema, pela outra ponta: um guia que se declara agnóstico três linhas acima e cita um produto na quarta ensina, pelo exemplo, que dá para acomodar o caso do projeto atual no normativo. Como `.team/` viaja intacto para o próximo projeto, o nome erraria de dono na primeira replicação.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|
| Arquiteto | Todo passo de plano com regra de engenharia cita `<arquivo> §<n>` — sem número não conta. Responde pela precedência nível 1 × nível 2 como defeito de documento. GAP de standard e achado do QA são **insumo obrigatório** do `/arc review` seguinte, decididos ou adiados com motivo escrito. Não libera plano que dependa de standard sabidamente defeituoso |
| dev | Lê as seções citadas (só elas — R3) e as aplica como se fossem o plano. Defeito de standard vira 🔺 GAP de **tipo `standard`**, com `<arquivo> §<n>`, e a codificação para. O GAP fica no relatório mesmo depois de respondido. Nunca edita `.team/standards/` |
| QA | Nada muda **por esta entrada** — os documentos do QA são de outro papel e foram roteados ao `/qa review` na v1.8. Ver "Roteamentos" abaixo: o roteamento continua **aberto** |
| SM | Ganha duas evidências físicas para verificar os indicadores de R16: o campo "Standard aplicável" nos planos e o `Tipo:` dos GAPs nos relatórios |

### Conflitos com o processo vigente
**Nenhum aplicado, um herdado e ainda aberto.**

1. **Sem conflito novo.** A instrução usa "base de qualidade compartilhada"; o stakeholder confirmou na v1.8 que isso significa **base de referência comum**, não caneta compartilhada. Tudo o que esta entrada aplica ao dev é consumo e roteamento de defeito — nenhuma linha lhe dá escrita em `.team/standards/`. O invariante de dono único e a v1.3 (o dev não revisa o próprio normativo) ficam intactos.
2. **Herdado da v1.8, ainda aberto:** se "compartilhada" significar co-autoria do dev, esta entrada precisaria ser revista junto com a v1.8. Enquanto não houver resposta, vale o modelo editor/consumidores.

### Como saberemos que funcionou
Quatro indicadores, em até três ciclos — os dois primeiros são os que faltavam para fechar os indicadores (a) e (c) da v1.8:

(a) **Todo passo de plano com regra de engenharia traz o campo "Standard aplicável" preenchido com número de seção** — contável nos planos de `.team-project/architect/plans/`. Passo com "n/a" é aceitável; passo sem o campo, ou com "siga os standards", conta como falha de formato.
(b) **Todo 🔺 GAP declara `Tipo:`**, e todo GAP de tipo `standard` aparece na seção "Gaps levantados" do relatório **e** na fila do `/arc review` seguinte — rastreável do relatório ao changelog, sem depender da memória de ninguém.
(c) **Zero edições de `.team/standards/` fora de `/arc review`** — verificável no histórico do repositório: commit que toca `.team/standards/**` sem entrada correspondente aqui é violação de R16.
(d) **Zero nomes de produto em `.team/`** fora deste changelog — verificável por busca textual do nome do produto do projeto corrente; hoje em **zero ocorrências**.

**Sinal de excesso, na direção contrária:** se em três ciclos nenhum GAP de tipo `standard` for levantado **e** nenhum plano precisar citar uma seção, o normativo não está sendo exercitado — e a ação, pela §10 das skills do Arquiteto, é **encolher o normativo**, não reforçar a regra.

### Roteamentos desta rodada
| Achado | Onde | Para quem |
|---|---|---|
| Os documentos do QA (`README.md`, `skills.md`, `templates/*`) **não citam `.team/standards/` uma única vez** — nem o consumo obrigatório, nem a reprovação por desvio de standard, nem o achado de processo como canal. O roteamento da v1.8 ao `/qa review` **segue aberto**: é a única ponta de R16 que nenhum papel documentou ainda | `roles/quality-assurance/*` | **`/qa review`** — instrução da v1.8, inalterada |

### Pendente do stakeholder
- **Herdado da v1.8:** confirmar a leitura de "compartilhada" (base de referência comum — já aplicado — **ou** caneta compartilhada para o dev, que contradiz a v1.3).
  - **↳ Resolvido em v2.0 (2026-09-06):** stakeholder confirmou — **base de referência comum**: Arquiteto dono editorial, dev e QA consumidores. O conflito herdado da v1.8 está fechado; o modelo editor/consumidores aplicado nesta entrada vale sem revisão.
- **`commands/dev.md`** (proposta nova, opcional): no item 5, acrescentar que o 🔺 GAP declara `Tipo: plano | standard`, e que o de tipo `standard` cita `<arquivo do standard> §<n>` além do `arquivo:linha`. O modelo já cobre; é ponteiro de conveniência.
- As propostas de `agents/` e `commands/` da v1.8 **já foram aplicadas** pelo stakeholder (`commands/arc.md`, `commands/qa.md`, `agents/architect.md`, `agents/developer.md`, `agents/quality-assurance.md`, `agents/scrum-master.md`) e estão **coerentes** com o que esta entrada escreveu — conferido em `agents/developer.md:20` e `commands/arc.md:25/31/33/37/51`. Nada a repropor.

---

## v1.8 — `standards/` promovido a diretório de primeiro nível e reclassificado como base de qualidade compartilhada (R16) — 05/09/2026

**Instrução:** "o que está no standards deve ser a base de qualidade de trabalho de revisão compartilhada entre o architect, developer e quality-assurance acho melhor revisar esses papéis considerando esses documentos e colocar a pasta standards no nível do deliverables"
**Classificação:** propriedade de artefato (novo modelo de dono para `.team/standards/`) + regra que governa todos (R16, método) + estrutura de `.team/` (mudança física já aplicada pelo stakeholder) + roteamento aos papéis Arquiteto, dev e QA + comportamento de agente/comando (proposto, não aplicado)
**Registrada por:** SM, via `/sm review`

### Contexto — o que já estava feito quando esta entrada foi escrita
O stakeholder já havia aplicado no disco, com todas as referências reescritas e validadas (zero links quebrados):
1. `docs/team/` → `.team/` e `docs/team-project/` → `.team-project/`, na raiz do repositório.
2. `.team/roles/architect/standards/` → `.team/standards/`, irmã de `deliverables/`.

Esta entrada trata só da **parte normativa**: o modelo de propriedade, a regra, e a atualização dos documentos de processo.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/scrum-master/process/working-rules.md` | **Bloco C · R16 nova** · "Como o SM aplica" (2 indicadores novos) · "Resumo em uma tela" | R16: `.team/standards/` é base de qualidade comum de Arquiteto, dev e QA — **dono editorial único** (Arquiteto, muda só por `/arc review`), **consumo obrigatório** (dev aplica no plano, QA valida contra), **defeito roteado** (dev por 🔺 GAP, QA por achado de processo, os dois ao Arquiteto). Traz o que evita e como o SM verifica |
| `roles/scrum-master/process/artifact-ownership.md` | matriz (linha `standards`) · **§1a nova** | Caminho `team/standards/**` → `.team/standards/**`; dono passa a "Arquiteto (dono editorial) · dev e QA consumidores obrigatórios". §1a explica por que "base compartilhada" **não** afrouxa o invariante de dono único: a caneta continua sendo de um só; o compartilhado é a obrigação de consumo e o direito de levantar defeito. Tabela por papel + regra de desempate |
| `roles/scrum-master/process/workflow.md` | §6 (escalação) · §8 (gates) | Linha de escalação nova: `defeito em .team/standards/ ──▶ Arquiteto ──▶ /arc review`. Gate novo: "Plano cita a seção de `.team/standards/` que a mudança de engenharia toca" bloqueia construção |
| `roles/scrum-master/templates/retrospective.md` | Métricas do período | Duas linhas novas ligadas a R16 |
| `roles/scrum-master/README.md` | "Como sei que estou funcionando" | Bullet sobre R16 |
| `README.md` (raiz de `.team/`) | árvore de estrutura · tabela "Cada pasta em `roles/`" · "Regras que governam todos" · tabela de alcance de `review` | `standards/` sai da subárvore de `roles/architect/` e entra como diretório de primeiro nível, irmão de `deliverables/`, com os 4 arquivos listados. Removida a linha "*(só no Arquiteto)*" da tabela de `roles/` e substituída por um parágrafo "Fora de `roles/`" com o modelo de R16. "15 regras (… R13-R15)" → "16 regras (… R13-R16)". Linhas de `/arc review` e `/qa review` anotadas com o papel de cada um sobre `standards/` |
| `deliverables/README.md` | tabela "Conjuntos" · "Cobertura por papel" | Linha "Padrões de engenharia" marcada *(relacionado — não é entregável)* + nota explicando por que não é um quinto conjunto: é normativo/guia, não é elaborado nem versionado por projeto, o QA valida a entrega *contra* ele e não *ele*. "Cobertura por papel" passa a dizer que o Arquiteto é **dono editorial** dos padrões, que não são entregável |

### Por quê
Dois problemas, e a instrução resolve os dois.

1. **`standards/` estava escondido dentro de um papel.** Vivia em `roles/architect/standards/` e a tabela de `.team/README.md` dizia "*(só no Arquiteto)*" — o que fazia dele um documento privado de um papel, quando na prática o dev executa contra ele e o QA valida contra ele todo ciclo. Promovê-lo a diretório de primeiro nível, irmão de `deliverables/`, alinha a estrutura ao uso real: é normativo do time, não pasta de um papel.
2. **"Base compartilhada" ameaçava o invariante de dono único da matriz de propriedade.** Se três papéis "compartilham" um documento, quem decide quando discordam? E o dev não tem `review` — como propõe mudança? Sem um modelo explícito, "compartilhado" viraria ou terra de ninguém (ninguém mantém) ou edição concorrente (perde coerência e vira o oposto de uma régua). R16 fixa o modelo **editor / consumidores**: uma caneta (Arquiteto), consumo obrigatório dos outros dois, canal de defeito nomeado para cada um, e regra de desempate — engenharia decide o Arquiteto, o que ultrapassa engenharia sobe ao stakeholder pelo SM.

### Modelo de propriedade — como ficou
| Papel | Sobre `.team/standards/` | Como propõe mudança |
|---|---|---|
| **Arquiteto** | Dono editorial. Escreve, versiona, mantém a coerência entre nível 1 e perfis de nível 2 | `/arc review` |
| **dev** | Consumidor obrigatório: aplica a regra ao executar o plano | 🔺 GAP apontando contradição / lacuna / regra inverificável → Arquiteto decide → `/arc review` (o dev não tem `review` — v1.3) |
| **QA** | Consumidor obrigatório: valida a entrega contra os standards | Achado de processo (não achado de código) roteado ao Arquiteto; ou `/qa review` que roteia ao `/arc review` |

**Desempate:** regra de engenharia — decide o Arquiteto. Divergência que ultrapassa engenharia (custo, prazo, escopo, política) — sobe ao stakeholder pelo SM, posições lado a lado.

**`/arc review` continua sendo a única porta de escrita de `standards/`.** O que muda é que agora o dev e o QA têm canal formal e rastreável de alimentar esse `review` — o dev pelo 🔺 GAP, o QA pelo achado de processo — e o SM verifica que o defeito apontado chega ao `/arc review` seguinte.

### `standards/` não vira um quinto conjunto de entregável — e por quê
A instrução pede a pasta "no nível de `deliverables/`" — isto é, **diretório irmão**, o que a mudança física já fez. **Não** deve virar um quinto conjunto dentro de `deliverables/README.md`:

- Pela taxonomia de quatro tipos do próprio time (`.team/README.md`), `standards/` é **"Processo / guia"** — normativo —, não **"Entregável"**.
- Um entregável tem instância preenchida por projeto em `.team-project/`, dono que responde pela atualização a cada ciclo e validação do QA a cada entrega. `standards/` não tem nada disso: é consumido como está, viaja intacto entre projetos, e o QA valida a entrega *contra* ele, não *ele*.
- Tratá-lo como conjunto de entregável implicaria SM/PO governando sua ordem de elaboração e o QA validando-o por item — governança que não faz sentido para um normativo.

Fica registrado na tabela de `deliverables/README.md` **só como relacionado**, para descoberta.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Arquiteto | Formalizado como **dono editorial** de `.team/standards/` (não muda a prática — muda o nome e a responsabilidade explícita pela coerência nível 1 × nível 2); passa a ter dois canais de entrada obrigatórios a tratar no `/arc review` — os 🔺 GAPs de standard do dev e os achados de processo do QA |
| dev | Consumo do standard passa a ser verificado: o plano que ele executa cita a seção aplicável; defeito que ele encontrar num standard vira 🔺 GAP, não improviso nem correção de passagem |
| QA | Defeito num standard deixa de ser achado de código e passa a ser **achado de processo roteado ao Arquiteto**; e o QA reprova (não ressalva) desvio de standard no código |
| SM | Novo gate a verificar (plano cita a seção de standard); novos indicadores de retrospectiva; responde pela ligação defeito-de-standard → `/arc review` seguinte |
| Stakeholder | Decide a superfície de agente/comando (ver pendências); e confirma que "compartilhada" significa base de referência comum, não caneta compartilhada (ver conflito) |

### Conflitos com o processo vigente
**Um, resolvido no documento; um risco de leitura, escalado.**

1. **Resolvido — invariante de dono único (`artifact-ownership.md`) × "compartilhada entre três".** O invariante diz "cada arquivo tem um único dono; quem não é dono lê, cita e pede alteração — nunca edita". "Base compartilhada entre Arquiteto, dev e QA" parece contradizê-lo. Resolvido pelo mesmo desenho das v1.4 (Boy Scout Rule × R4) e v1.5 (leveza × repertório): **escrever a fronteira em vez de deixar duas verdades convivendo.** O dono *editorial* continua único (Arquiteto); o que é compartilhado é o **consumo obrigatório** e o **direito de levantar defeito**. O invariante fica intacto — há exatamente uma caneta.
2. **Escalado (risco de leitura) — se "compartilhada" significa co-autoria do dev, colide com a v1.3.** A v1.3 estabeleceu que o dev **não revisa os próprios normativos** porque roda no modelo mais simples do time, calibrado para executar plano com fidelidade — e que deixá-lo reescrever a regra que o governa é "o caminho mais curto para ela afrouxar sem ninguém notar". Dar ao dev caneta em `.team/standards/` reabriria exatamente esse buraco. **Interpretação adotada:** a palavra "revisão" na instrução ("base de qualidade de trabalho de revisão compartilhada") indica base de referência comum *para* o trabalho de revisão de arc/dev/qa — não permissão de escrita. Sob essa leitura não há conflito e o modelo editor/consumidores vale. **Se o stakeholder quis dizer que o dev deve poder editar `standards/` diretamente, isso contradiz a v1.3 e precisa da decisão dele** — ver pendências.

### Como saberemos que funcionou
Quatro indicadores, em até três ciclos:
(a) **todo Plano de Execução que toca engenharia cita a seção de `.team/standards/` aplicável** — verificável lendo os planos em `.team-project/architect/plans/`; era exigido só para segurança (R11) e para o anel (v1.4), agora é gate geral;
(b) **todo desvio de standard achado no código pelo QA aparece como reprovação, não ressalva** — contável nos vereditos do período;
(c) **todo 🔺 GAP ou achado de QA que aponta defeito no próprio standard chega ao `/arc review` seguinte** — rastreável no registro de GAPs e no changelog; GAP de standard aberto por mais de um ciclo sem decisão do Arquiteto tem de estar como bloqueio no quadro;
(d) **`.team/standards/README.md` nomeia o editor e os dois consumidores com o canal de defeito** — depende do roteamento ao `/arc review` abaixo.
Se em três ciclos nenhum plano precisar citar um standard e nenhum defeito de standard for levantado, R16 não terá sido exercitada — candidata a encolher para nota em `artifact-ownership.md` na próxima `review metrics`.

### Pendente do stakeholder
- **Leitura de "compartilhada" (conflito 2 acima).** Confirmar: base de referência comum (modelo editor/consumidores, já aplicado) **ou** caneta compartilhada para o dev (contradiz a v1.3 — reabrir). Enquanto não houver resposta, vale o modelo editor/consumidores.
  - **↳ Resolvido em v2.0 (2026-09-06):** stakeholder confirmou — **base de referência comum**: Arquiteto dono editorial, dev e QA consumidores. A leitura "caneta compartilhada para o dev" fica descartada; a v1.3 não reabre; nada a revisar nas v1.8/v1.9.
- **Superfície de agente/comando** — `agents/` e `commands/` são do stakeholder; propostas prontas para colar, **não aplicadas**:
  - **`commands/arc.md`** — no modo `review`, registrar que `.team/standards/` tem o Arquiteto como **dono editorial** e o dev e o QA como consumidores obrigatórios (R16), e que os 🔺 GAPs de standard do dev e os achados de processo do QA são insumo obrigatório do `review`.
  - **`commands/qa.md`** — no modo `review`, acrescentar: "defeito em `.team/standards/` (contradição, lacuna, regra inverificável) vira **achado de processo** roteado ao `/arc review`, nunca achado de código nem correção de passagem (R16)".
  - **`agents/architect.md`** — na descrição de `.team/standards/` como "a sua régua", acrescentar "e você é o **dono editorial**: dev e QA consomem e levantam defeito, não editam (R16)".
  - **`agents/developer.md`** e **`agents/quality-assurance.md`** — uma linha cada: o standard é base obrigatória; defeito nele é 🔺 GAP (dev) / achado de processo (QA) roteado ao Arquiteto, não improviso.
  - **`agents/scrum-master.md`** — trocar "As 15 regras … método R13-R15" por "As 16 regras … método R13-R16" (linha 45).
- Mudança de comportamento de agente/comando só vigora após **reiniciar a sessão**.

### Roteamentos desta rodada
| Achado | Onde | Para quem |
|---|---|---|
| A linha 3 do `.team/standards/README.md` ainda declara "**Pasta do Arquiteto.**" — com a promoção a diretório de primeiro nível e o modelo de R16, precisa passar a "normativo do time, dono editorial: Arquiteto; consumo obrigatório: dev e QA", e o `README.md` do diretório precisa nomear o **canal de defeito** de cada consumidor | `.team/standards/README.md` | **`/arc review`** — instrução: *"o `.team/standards/README.md` deve refletir a promoção a diretório de primeiro nível (irmão de `deliverables/`) e o modelo de R16: dono editorial Arquiteto, dev e QA consumidores obrigatórios com canal de defeito (dev: 🔺 GAP; QA: achado de processo); a linha 'Pasta do Arquiteto' passa a 'normativo de engenharia do time, mantido pelo Arquiteto'"* |
| Os três papéis Arquiteto, dev e QA precisam ser revistos "considerando esses documentos" — roteiro, skills e a relação de cada um com `.team/standards/` sob o modelo de R16 | `roles/architect/*`, `roles/developer/*` (via Arquiteto), `roles/quality-assurance/*` | **`/arc review`** (cobre Arquiteto **e** dev) — instrução: *"reveja o roteiro e as skills do Arquiteto e do dev à luz de `.team/standards/` como base de qualidade compartilhada (R16 / artifact-ownership §1a): o Arquiteto é dono editorial e responde pela coerência nível 1 × perfis de nível 2; o dev é consumidor obrigatório — aplica a seção citada no plano e levanta 🔺 GAP quando o standard tem contradição, lacuna ou regra inverificável, sem corrigir de passagem; atualize o caminho para `.team/standards/` e a referência ao novo diretório de primeiro nível; e ajuste `.team/standards/README.md` conforme o roteamento acima"* · **`/qa review`** — instrução: *"reveja o roteiro, as skills e os modelos do QA à luz de `.team/standards/` como base de qualidade compartilhada (R16 / artifact-ownership §1a): o QA valida a entrega contra os standards e reprova (não ressalva) desvio de standard no código; defeito no próprio standard é achado de processo roteado ao `/arc review`, não achado de código; atualize o caminho para `.team/standards/`"* |

### Reavaliação do conjunto — 8 verificações
- **Coerência interna:** OK após esta rodada. `standards/` agora aparece como diretório de primeiro nível na árvore de `.team/README.md`, na matriz de propriedade, no fluxo (§6/§8) e em `deliverables/README.md` com a mesma descrição (dono editorial + consumo obrigatório).
- **Aderência à prática:** o modelo editor/consumidores descreve o que já acontece — o dev já executa contra o standard, o QA já valida contra ele. R16 dá nome e canal ao que era informal.
- **Verificabilidade:** R16 tem gate (plano cita a seção), indicador de reprovação e indicador de rastreio defeito→`/arc review`. Sem verificação nenhum item entrou.
- **Cobertura de modelos:** `retrospective.md` recebeu as duas linhas de R16. Nenhum modelo do SM ficou órfão.
- **Fronteiras entre papéis:** o ponto sensível da rodada. Resolvido escrevendo a fronteira em `artifact-ownership.md` §1a: uma caneta, dois consumidores, desempate nomeado. O risco de leitura (co-autoria do dev × v1.3) foi escalado, não resolvido em silêncio.
- **Vazamento de contexto de projeto:** nenhum. Esta rodada não tocou `.team-project/`. Os exemplos de stack (.NET/GitLab) na árvore de `.team/README.md` são rótulo de perfil de nível 2, não conteúdo de produto.
- **Obsolescência (atenção reforçada — caminhos mudaram em todo o repo):**
  - `.team/README.md` árvore: `roles/architect/standards/` **corrigido** para `standards/` de primeiro nível.
  - `.team/README.md` tabela "Cada pasta em `roles/`": linha "*(só no Arquiteto)*" **removida** — era obsoleta (standards saiu de `roles/`).
  - `artifact-ownership.md`: `team/standards/**` **corrigido** para `.team/standards/**`.
  - `.team/standards/README.md:3` "Pasta do Arquiteto" — obsoleto, **roteado ao `/arc review`** (é do Arquiteto).
  - `commands/arc.md:31`, `agents/architect.md:18/63` citam `.team/standards/` com caminho correto mas sem o modelo de R16 — nas propostas de agente/comando.
  - `replicate-in-new-project.md:88` cita `.team/standards/implementation-principles.md` com caminho correto; texto ainda diz "único ponto de `.team/` que pode precisar de troca" — coerente com nível 2, sem ação.
  - `process-changelog.md` v1.5 §193-195 e v1.4 — entradas antigas, **não se reescrevem** (regra do changelog).
- **O que dá para remover:** nada nesta rodada — R16 é adição com gatilho e verificação. Candidata a encolher se não for exercitada em três ciclos (ver "Como saberemos"). Observação de curadoria: a tabela "Cada pasta em `roles/`" de `.team/README.md` ficou com uma só linha entre parênteses (`process/` "*(só no SM)*") + um parágrafo solto; se numa próxima rodada outra pasta sair de `roles/`, converter as duas num bloco único "normativos fora de `roles/`".

### Curadoria — contradições entre mudanças de papéis diferentes
Nenhuma pendente. Esta rodada cria trabalho roteado para `/arc review` (Arquiteto + dev) e `/qa review`; quando esses `review` rodarem, o SM confere que o caminho `.team/standards/` e o modelo de R16 ficaram idênticos nos três conjuntos de documentos. Enquanto não rodarem, `.team/standards/README.md` segue com a linha "Pasta do Arquiteto" — divergência conhecida e roteada, não arredondada.

---

## v1.7 — Onboarding do projeto (R14) e brainstorm de descoberta funcional (R15) — 05/09/2026

**Instrução:** "review adicione um comando ao sm para tratarmos o ritual de onboarding do projeto. Nessa atividade o SM irá coordendar todo o time no entendimento e alinhamento do projeto de trabalho podendo questionar ao stackholder (que sou eu) para melhor entendimento como padrão ele deverá questionar a documentação existente do projeto para poder entender, mas se não tiver abriremos com um novo comando brainstorm que tem o foco de avaliarmos uma ideia nova que é o desejo do stackholder primeiramente em nível funcional onde participarão somente o stackholder (eu) o PO e UX, quando a ideia estiver melhor formada e tendo um entendimento funcional base levaremos para o ARC avaliar e fica em rodada de análise e proposta com os envolvidos até fecharmos para a elaboração dos documentos do SDD"
**Classificação:** duas cerimônias novas (fluxo) + duas regras que governam todos (R14, R15, método) + roteiro e skills do SM + comportamento de comando (`/sm onboarding`, `/team brainstorm` — propostos, não aplicados)
**Registrada por:** SM, via `/sm review`

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/scrum-master/process/working-rules.md` | **Bloco C · R14 e R15** · "Como o SM aplica" · "Resumo em uma tela" | R14: projeto novo ou retomado passa por onboarding antes do primeiro `/sm plan`; a documentação existente é interrogada antes do stakeholder. R15: ideia sem cobertura em visão/requisitos/fluxos passa por `brainstorm` de duas fases antes de virar requisito ou SDD; ideia em área documentada segue por `/po analyze`. Ambas com o que evitam e como o SM verifica. Dois indicadores novos de retrospectiva |
| `roles/scrum-master/process/workflow.md` | §2 (etapas 0 e 0b) · §5 (cerimônias) · **§5a nova** (ritual de onboarding) · **§5b nova** (ritual de brainstorm) · §6 (escalação) · §8 (gates) | Onboarding e brainstorm entram como etapas anteriores ao ciclo. §5a: seis passos, condição de saída em checklist, o que se pergunta à documentação e o que se escala. §5b: fase 1 (stakeholder + PO + UX), fase 2 (+ Arquiteto) em rodadas até ponto fixo, critério de fechamento, transição para o SDD com dono por documento. Exceção de escalação declarada: no brainstorm/onboarding o stakeholder é participante. Dois gates novos |
| `roles/scrum-master/process/artifact-ownership.md` | matriz · §2 (fluxo) | Registro de onboarding e brief de brainstorm são saída de facilitação do SM — **não** substituem a propriedade do PO sobre o requisito nem a divisão de autoria do SDD. Diagrama de fluxo ganha os dois passos a montante |
| `roles/scrum-master/README.md` | roteiro (`/sm onboarding` novo) · "Como sei que estou funcionando" · "Documentos que administro" | Modo `/sm onboarding` com os seis passos; linha sobre facilitar o brainstorm sem decidir conteúdo funcional |
| `roles/scrum-master/skills.md` | **§10 nova** — "Conduzir onboarding e facilitar brainstorm" | Disciplina de fonte (documentação antes do stakeholder), divergência não se arredonda, participação escalonada do brainstorm, propriedade sobrevive à sessão, o brief não vira entregável permanente |
| `roles/scrum-master/templates/retrospective.md` | Métricas do período | Duas linhas novas ligadas a R14 e R15 |
| `README.md` (raiz de `.team/`) | comandos · modos de `/team` · "Regras que governam todos" · "Caminho padrão de um item" | `/sm onboarding` e `/team brainstorm` na lista; linha do modo `brainstorm`; "13 regras (… método R13)" → "15 regras (… método R13-R15)"; diagrama do caminho padrão ganha onboarding e brainstorm a montante |

### Por quê
Dois buracos no início do fluxo, os dois com modo de falha já vivido neste projeto.

1. **Não havia porta de entrada para um projeto.** O fluxo começava em `/po analyze` — um requisito — pressupondo que o time já entendia o produto, a stack, o ambiente e o que estava construído. Ploteon é a prova do custo disso: o time foi montado sobre um `02-status` que declarava "14/14 sprints" enquanto o código sustentava 50 GAPs, e ninguém cruzou uma coisa contra a outra antes de propor um plano. O onboarding força esse cruzamento **uma vez**, com a documentação como primeira fonte e o stakeholder como segunda — e transforma a divergência status × código em risco no quadro em vez de arredondamento.
2. **Não havia forma de moldar uma ideia greenfield.** Uma ideia sem documentação, hoje, ou virava requisito formal por um único papel (com a inviabilidade técnica aparecendo só na construção), ou era jogada num `/team consult` que responde tudo de uma vez, sem fase nem fechamento. O brainstorm dá as duas fases que a instrução pede: funcional primeiro (stakeholder + PO + UX, sem restrição técnica prematura), viabilidade depois (+ Arquiteto, em rodadas), com um ponto fixo que fecha para a elaboração do SDD.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| SM | Conduz o onboarding antes do primeiro `/sm plan` de qualquer projeto (R14); facilita o brainstorm — mantém as fases, registra o delta de cada rodada, declara o ponto fixo — **sem decidir conteúdo funcional**; responde por projeto planejado sem onboarding e por requisito sem origem rastreável como violação |
| PO | Participa da fase 1 do brainstorm conduzindo o enquadramento funcional; o requisito ainda é escrito por ele, via `/po analyze` / `/po requirement`, **depois** do fechamento. `/po analyze` passa a ser explicitamente para ideia em área já documentada — ver roteamento |
| UX | Participa da fase 1 do brainstorm com jornada e contexto de uso; participa da fase 2 — ver roteamento |
| Arquiteto | Entra na fase 2 do brainstorm para viabilidade, em rodada de análise e proposta; **aconselha, não reescreve requisito**; no fechamento escreve `03`/`04`/`05` só da primeira fatia — ver roteamento |
| dev / QA | Não entram no brainstorm; participam do onboarding com uma leitura de entrada de ≤10 linhas |
| Stakeholder | Ganha uma porta de entrada de projeto e uma de ideia nova; decide a superfície de comando dos dois modos (ver pendências) |

### Conflitos com o processo vigente
Um analisado a fundo, **resolvido no documento** (não escalado); nenhum exigiu parar para decisão.

**Sobreposição entre `brainstorm` e `/po analyze` / `/team consult`, e a fronteira de autoria do SDD.** O brainstorm molda uma ideia funcionalmente com PO **e** UX na sala, e depois com o Arquiteto — o que poderia ler-se como violação de "requisito é do PO" e da divisão de autoria do SDD (PO: visão/requisitos/fluxos; Arquiteto: arquitetura/dados/API). Resolvido escrevendo três fronteiras explícitas, no mesmo espírito com que a v1.4 tratou Boy Scout Rule × R4 e a v1.5/v1.6 trataram leveza × repertório:

1. O brainstorm produz um **brief**, não um requisito. O requisito continua sendo escrito pelo PO, depois do fechamento.
2. O Arquiteto na fase 2 **aconselha**; mudança funcional forçada por viabilidade é feita pelo PO.
3. A divisão de autoria do SDD não muda — o brainstorm precede e alimenta a elaboração, não a executa.

E o roteamento por **gatilho objetivo** (a área da ideia tem ou não cobertura em visão/requisitos/fluxos) impede que o brainstorm engula o `/po analyze` ou vire cerimônia para toda ideia pequena — mesmo desenho opt-in-por-gatilho de R13 e do método de pesquisa do UX (§9).

### Como saberemos que funcionou
Quatro indicadores, em até três ciclos: (a) **todo projeto novo ou retomado tem um registro de onboarding antes do primeiro `/sm plan`**, com a tabela de inventário de fontes preenchida e as seis leituras de entrada — verificável lendo a saída e o `.team-project/README.md` datado; (b) **toda divergência status × código encontrada no onboarding vira linha na tabela de riscos do quadro**, nenhuma arredondada — é o defeito que o onboarding existe para pegar, e havia ocorrência real antes dele; (c) **todo requisito novo do SDD rastreia a um fechamento de `brainstorm` ou a uma decisão de `/po analyze`** — contável no `06-changelog` e nos requisitos; (d) **toda saída de `brainstorm` mostra a fase 1 sem o Arquiteto e a fase 2 com ele**, e nenhum documento do SDD foi escrito antes do fechamento — checável por ordem de data. Se em três ciclos nenhum projeto novo entrar e nenhuma ideia sem documentação aparecer, R14/R15 não terão sido exercitadas — candidatas a encolher para nota de fluxo na próxima `review metrics`.

### Pendente do stakeholder
- **Superfície de comando dos dois modos.** `agents/` e `commands/` são do stakeholder — as propostas abaixo estão prontas para colar, **não foram aplicadas**:
  - **`commands/sm.md`** — novo modo `onboarding` (texto pronto na resposta do `/sm review`).
  - **`brainstorm`** — recomendado como **modo de `/team`** (`commands/team.md`), reusando o orquestrador multi-papel; texto pronto na resposta. Alternativa: arquivo novo `commands/brainstorm.md` (mesmo corpo) — nesse caso o plugin passa a ter **8 comandos**, e `README.md` §"Como o time é carregado" e `replicate-in-new-project.md` precisam do ajuste de contagem.
  - **`agents/scrum-master.md`** — acrescentar onboarding/brainstorm às responsabilidades e trocar "As 12 regras" por "As 15 regras" (a contagem já estava defasada desde a v1.5).
- **Onboarding retroativo de Ploteon.** R14 manda o projeto já em andamento fazer um onboarding retroativo uma vez. Ploteon está nesse caso — o `/sm review` não toca `.team-project/`; isso é um `/sm onboarding` a rodar fora do `review`.
- Mudança de comportamento de agente/comando só vigora após **reiniciar a sessão**.

### Roteamentos desta rodada
| Achado | Onde | Para quem |
|---|---|---|
| O roteiro do PO e o modo `/po analyze` precisam dizer que a ideia pode chegar já moldada pelo brainstorm, que na fase 1 o PO conduz o enquadramento mas o requisito escrito sai por `/po analyze` / `/po requirement` **depois** do fechamento, e que `/po analyze` é para ideia em área já documentada | `roles/product-owner/README.md`, `skills.md`, `commands/po.md` | **`/po review`** — instrução: *"o PO participa da fase 1 do brainstorm (R15 / workflow §5b) conduzindo o enquadramento funcional; o requisito continua sendo escrito por ele depois do fechamento; `/po analyze` passa a ser explicitamente para ideia em área já documentada"* |
| O roteiro do UX precisa registrar a participação na fase 1 (jornada, contexto de uso, usabilidade) e na fase 2 do brainstorm | `roles/user-experience/README.md`, `skills.md` | **`/ux review`** — instrução: *"o UX participa das duas fases do brainstorm (R15 / workflow §5b): fase 1 com jornada e contexto de uso, fase 2 acompanhando a rodada de viabilidade; os mapas de jornada das jornadas moldadas são escritos após o fechamento"* |
| O roteiro do Arquiteto precisa registrar a entrada na fase 2 do brainstorm (viabilidade, rodada de análise e proposta, aconselha sem reescrever requisito) e que no fechamento escreve `03`/`04`/`05` só da primeira fatia | `roles/architect/README.md`, `skills.md` | **`/arc review`** — instrução: *"o Arquiteto entra na fase 2 do brainstorm (R15 / workflow §5b) para avaliar viabilidade em rodada de análise e proposta; aconselha, não reescreve requisito; no fechamento escreve arquitetura/dados/API só da fatia que a primeira entrega exige"* |

### Reavaliação do conjunto — correções de curadoria
- **Sem remoções nesta rodada.** R14 e R15 são adições com gatilho e verificação; as cerimônias §5a/§5b são roteiro que não existia. Candidatas à remoção na próxima `review metrics` se, em três ciclos, nenhum projeto novo entrar e nenhuma ideia sem documentação aparecer.
- **Contagem de regras alinhada:** `README.md` (raiz) passou de "13" para "15"; `agents/scrum-master.md` ainda diz "12" (defasado desde a v1.5) — na lista de pendências do stakeholder acima.
- **Fronteira `/team consult` × `/team brainstorm`:** consult é broadcast de uma rodada sem fechamento; brainstorm é faseado, com participação restrita e ponto fixo. As duas coexistem sem sobreposição — registrado na tabela de modos de `/team` no `README.md`.

---

## v1.6 — UX com repertório de padrões consolidados e método de pesquisa acionável por gatilho — 02/09/2026

**Instrução:** "review UX conhece os padroes de UI/UX do Google o Certificado de Design UX do Google"
**Classificação:** skill do UX + roteiro do UX + formato de documento (os três modelos do papel) + critério verificável novo (acessibilidade e estados de interação)
**Registrada por:** UX, via `/ux review`

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/user-experience/skills.md` | **§8 nova** — "Repertório de padrões consolidados" | Vocabulário de padrão maduro (estados de interação do controle, hierarquia de ação, comunicação transitória, feedback de espera, navegação, ritmo visual, formulário) + as heurísticas de usabilidade como vocabulário do *critério violado*. Regra: **a referência é do padrão, não da biblioteca**, e a convenção do produto vence o repertório. Introduz **os dois eixos de estado** — os seis estados são da tela, os de interação são de cada controle — com forma de verificação |
| `roles/user-experience/skills.md` | **§9 nova** — "Método de pesquisa e prototipação" | As etapas do método (empatizar · definir · idear · prototipar · testar) com **gatilho objetivo** e o default quando o gatilho não ocorre; níveis de fidelidade (baixa · alta · só especificação) e o que cada um fixa; três regras transversais, sendo a central **"pesquisa declarada é pesquisa feita"** |
| `roles/user-experience/skills.md` | §2 · §4 · §7 | §2 aponta o segundo eixo de estados. §4 passa a abrir por **acessibilidade-first**, ganha 4 pares vago→verificável (zoom/reflow, movimento, gesto complexo, linguagem clara), estende a base mínima e ganha a subseção **"Design equitativo: quem fica de fora"** com verificação. §7 ganha quatro fronteiras: **ator é do PO / perfil de uso é do UX**, teste com pessoa é do UX / verificação de critério é do QA |
| `roles/user-experience/README.md` | tabela do papel · `journey` · `screen` · `prototype` · `review-ui` · seis estados · "Como sei que estou funcionando" | Linha **Repertório** apontando §8/§9. `journey` ganha base de evidência e condição limitante; `screen` ganha fidelidade declarada e estados de interação; `prototype` ganha o nível por gatilho; `review-ui` ganha método declarado e critério violado nomeado. Removida a frase sobre "caminho feliz", já dita em `skills.md` §2 e nas falhas comuns de `screen-spec.md` |
| `roles/user-experience/templates/screen-spec.md` | cabeçalho · **§3.1 nova** · §6 · regras · falhas | Campo **Fidelidade do entregável**; tabela de **estados de interação por controle** com repouso obrigatório; 3 critérios de acessibilidade novos (zoom 200%/320 px, gesto e movimento, condição de uso limitante com providência); 4 regras novas (repouso obrigatório, uma régua por critério, repertório antes de criar, fidelidade declarada); 2 falhas comuns novas |
| `roles/user-experience/templates/journey-map.md` | cabeçalho · seção nova · regras · falhas | Campos **Perfil de uso** e **Base de evidência**; seção **Condições de uso que limitam**; 3 regras novas (evidência declarada, perfil não inventa ator, condição com providência); 2 falhas comuns novas |
| `roles/user-experience/templates/usability-review.md` | cabeçalho · estados · acessibilidade · seção nova · regras | "Como revisei" vira **Método** com teste de participantes explícito; os seis estados passam de **uma linha para seis, com "como verifiquei"** (defeito de verificabilidade corrigido); tabela nova de estados de interação; 3 critérios de acessibilidade novos, espelhando a especificação; seção de resultado de teste com participantes; 3 regras novas |

### Por quê
O papel tinha **disciplina sem repertório**. Os seis estados, o "reaproveite antes de criar" e a acessibilidade verificável são regras de rigor — dizem *o que precisa estar escrito*, não *o que se sabe sobre o assunto*. Faltavam três coisas concretas, e cada uma tem modo de falha já observado:

1. **Padrão de interface sem vocabulário.** Sem repertório consolidado, "não inventar" só funcionava quando o produto já tinha a convenção. Quando não tinha, o papel inventava do zero — e o resultado é um produto com dois jeitos de avisar o usuário e três jeitos de mostrar espera.
2. **O eixo de estado que faltava.** Os seis estados são da tela; o defeito mais comum de afordância é do **controle** — o botão que existe e não se vê em repouso. Uma especificação podia estar 100% completa nos seis estados e ainda assim deixar o dev escolher se o botão aparece parado. Esse buraco já produziu correção real neste time.
3. **Método sem gatilho.** Pesquisa, persona, wireframe de baixa fidelidade, teste com participantes e iteração ou eram feitos por hábito, ou não eram feitos nunca — e, pior, o papel não tinha proibição escrita contra **afirmar comportamento de usuário sem participante**. Para um papel operado por IA, essa é a falha mais perigosa do conjunto: uma frase inventada do tipo "os usuários preferem X" vira premissa citada como fato e contamina toda decisão seguinte. A regra "pesquisa declarada é pesquisa feita" é o equivalente do R7 ("sem evidência, não aconteceu") no território do desenho.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| UX | Declara **fidelidade e gatilho** no entregável; especifica o **repouso de todo controle**; nomeia ao menos uma **condição de uso limitante com providência**; não afirma comportamento de usuário sem participante, data e número |
| Dev | Recebe o estado de repouso, foco, pressionado e desabilitado por controle — deixa de escolher aparência de controle parado |
| QA | Ganha 3 critérios de acessibilidade a mais e a tabela de estados de interação; e passa a reprovar **por estado**, não com um veredito único para os seis |
| PO | Fronteira explícita: **ator e permissão continuam sendo dele**; perfil de uso descreve, não cria. Perfil que exige ator novo chega como escalação |
| Stakeholder | Uma decisão em aberto: a régua de alvo de toque (ver abaixo) |

### Conflitos com o processo vigente
Dois. **Um parou para o stakeholder, o outro foi resolvido no documento:**

1. **PARADO — régua de alvo de toque: 44×44 (vigente) × 48×48 (repertório).** Os modelos do papel exigem hoje **alvo de toque ≥ 44×44 px** (`screen-spec.md` §6, `skills.md` §4). O repertório de sistemas de design maduros trabalha com **48×48**. As duas réguas são defensáveis e **mutuamente exclusivas na prática**: um controle de 44 px reprova numa e passa na outra, e a diferença muda espaçamento e densidade de tela inteira. Não foi resolvido por conta própria. **Até a decisão, vale 44×44** — nenhum documento passou a citar as duas, e a pendência está declarada num aviso em `skills.md` §4 apontando para esta entrada. As duas posições: *manter 44×44* preserva o que já foi especificado e evita reabrir telas existentes; *adotar 48×48* alinha ao repertório que o papel passa a usar como referência e dá margem em toque impreciso, ao custo de densidade e de retrabalho nas telas já desenhadas.
2. **Resolvido no documento — método completo × leveza do processo.** Rodar o método inteiro (pesquisa, persona, auditoria, ideação, dois níveis de protótipo, teste, iteração) em todo item afogaria um time de um dev, e contraria o princípio de leveza (v1.3, v1.5). Resolvido pelo mesmo desenho que a v1.5 usou para PMBOK/APF: **cada etapa é opt-in por gatilho objetivo**, o default continua sendo desenhar a partir do requisito do PO, e nenhum artefato de pesquisa vira permanente sem lugar declarado no contexto do projeto.

### Como saberemos que funcionou
Quatro indicadores, em até três ciclos: (a) **toda especificação de tela nova declara fidelidade e traz a §3.1 preenchida com o repouso de cada controle** — verificável lendo as especificações; (b) **zero achados de afordância invisível em repouso** nas revisões do período — é o defeito que a §3.1 existe para matar, e havia ocorrência real antes dela; (c) **nenhuma jornada ou revisão afirma comportamento de usuário sem participante, data e número** — contável por busca das expressões "o usuário espera / os usuários preferem" nos artefatos do papel; (d) **toda revisão de usabilidade traz os seis estados em seis linhas, com "como verifiquei"**, em vez de um veredito único. Se em três ciclos nenhum gatilho de §9 for acionado e nenhuma especificação precisar justificar o nível de fidelidade escolhido, a §9 virou enfeite e é candidata a encolher na próxima `review metrics`.

### Adendo — decisão do stakeholder, 02/09/2026
*(Acrescentado no mesmo dia, fechando a única pendência que a entrada declarou. O texto original acima não foi reescrito.)*

| Pendência | Decisão do stakeholder | Onde foi aplicada |
|---|---|---|
| Régua de alvo de toque — **44×44 × 48×48** | **Manter 44×44.** 48×48 **não** é adotado: fica registrado como repertório de referência, não como régua vigente | `roles/user-experience/skills.md` §4 (aviso reescrito de "pendência declarada" para "decidido") · `templates/screen-spec.md` §6 **sem alteração** — o número já era 44×44 |

Consequência prática: **nenhuma tela existente é reaberta** por causa de alvo de toque, e o caso vira o primeiro exemplo concreto da regra de §8 — *quando a convenção do time contradiz o repertório, a convenção vence, e se escreve por quê*. Alterar 44×44 no futuro exige nova decisão registrada.

### Pendente do stakeholder
- **Nada em aberto sobre a régua de alvo de toque.** Resolvida em 02/09/2026 (adendo acima): **44×44 mantida**.
- **Proposta para `agents/user-experience.md`** (stakeholder aplica; vigora após reiniciar a sessão): na seção "Os estados que ninguém lembra", acrescentar uma linha distinguindo **os seis estados da tela** dos **estados de interação de cada controle** (repouso inclusive); e, em "Regras de conduta", uma linha para **"pesquisa declarada é pesquisa feita — sem participante, é inspeção"**.
- **Proposta para `commands/ux.md`** (opcional, não é necessário para a regra funcionar): nos modos `screen` e `prototype`, um ponteiro para `skills.md` §8/§9 (repertório e nível de fidelidade por gatilho); no modo `review-ui`, a exigência de **declarar o método** da revisão.

### Roteamentos desta rodada
| Achado | Onde | Para quem |
|---|---|---|
| `.team-project/user-experience/context.md` não declara nível de fidelidade do ambiente de protótipo, nem onde ficariam artefatos de pesquisa/perfil de uso — a regra "artefato só vira permanente com lugar declarado" precisa desse lugar | `.team-project/` | **`/sm`** (contexto de projeto é do SM, com aporte do UX) — fora do alcance de `review` |
| Nenhum teste automatizado de frontend deixa a regressão de interface invisível; os critérios de acessibilidade do papel não têm ferramenta de verificação declarada no projeto | contexto de QA | **`/qa review`** — decidir se verificação de acessibilidade entra no registro de evidências como comando ou como inspeção declarada |

### Reavaliação do conjunto — correções de curadoria
- **Corrigido (verificabilidade):** `usability-review.md` julgava os seis estados numa **única linha com um único veredito** — um "falha" ali não dizia qual estado falhou, e um "ok" carimbava seis estados de uma vez. Passou a seis linhas com coluna "como verifiquei".
- **Removido (duplicação):** a frase "especificação que só descreve o caminho feliz devolve a decisão ao dev" saiu do `README.md` do papel — a mesma ideia já está em `skills.md` §2 e na tabela de falhas comuns de `screen-spec.md`. Três cópias da mesma justificativa é o começo do documento que ninguém lê inteiro.
- **Candidatos à remoção na próxima rodada**, se não pegarem: a tabela de níveis de fidelidade de §9 (se toda tela sair como "só especificação" por três ciclos) e a seção de resultado de teste com participantes de `usability-review.md` (se nenhum teste com pessoa acontecer — nesse caso a linha "não houve, foi inspeção" basta).

---

## v1.5 — SM com repertório de PMBOK e APF acionável por gatilho, sobre a base Scrum — 02/09/2026

**Instrução:** "review SM pratica Scrum mas conhece as praticas do PmBok e Ponto de Funcao (APF) que podem ser usados quando necessário nos momentos de estimativas, gestão de riscos, gestão de mudanças, planejamento, gestão de escopo"
**Classificação:** regra de trabalho nova (R13, normativo que governa todos) + skill do SM + roteiro do SM + formato de documento (modelos de impacto e retrospectiva)
**Registrada por:** SM, via `/sm review`

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/scrum-master/skills.md` | **§9 nova** — "Repertório complementar: quando Scrum não basta" | Cinco frentes (estimativa, riscos, mudança, planejamento, escopo), cada uma com o default Scrum e a lista de **gatilhos objetivos** que acionam APF ou instrumento de PMBOK (registro formal de riscos, controle integrado de mudanças, EAP, baseline de escopo). Regra transversal: nomear o gatilho na saída; instrumento formal só vira artefato permanente com entrada no changelog; resultado de APF sempre convertido para a unidade do projeto |
| `roles/scrum-master/process/working-rules.md` | **Bloco C novo · R13** · tabela de indicadores de "Como o SM aplica" · "Resumo em uma tela" | R13: o instrumento de dimensionamento/controle é escolhido pelo gatilho, não por hábito. Traz o que evita e como o SM verifica. Novo indicador de retrospectiva: lote/épico > 3× a unidade sem dimensionamento formal nem justificativa |
| `roles/scrum-master/README.md` | roteiro `/sm plan` (passo 3 novo) · `/sm impact` (passo 2 novo) · "Como sei que estou funcionando" | Planejamento aciona APF/EAP no gatilho; `impact` conduz como controle integrado de mudanças quando toca contrato implantado, baseline acordada ou > 3 itens em voo |
| `roles/scrum-master/templates/impact-analysis.md` | Regras | Regra nova: mudança que toca contrato implantado / baseline acordada / > 3 itens em voo é controle integrado de mudanças, não ajuste informal |
| `roles/scrum-master/templates/retrospective.md` | Métricas do período | Linha nova ligada a R13 |
| `README.md` (raiz de `.team/`) | §"Regras que governam todos" | "12 regras" → "13 regras (… método R13)" |

### Por quê
O time nasceu 100% Scrum, e para o ritmo de um dev e itens pequenos isso basta na maior parte do tempo. Mas há situações em que a estimativa relativa e o quadro como registro de risco **não dão conta** e o SM não tinha, no processo escrito, autorização nem critério para sacar outra ferramenta: dimensionar um escopo grande de retomada para dar um número que o stakeholder possa usar em decisão de orçamento; controlar uma mudança que altera contrato já implantado; enxergar caminho crítico num entregável com dependências não-lineares. O modo de falha concreto é este projeto: "14 sprints concluídas" convivendo com 50 GAPs — escopo grande dimensionado no olho, sem contagem objetiva que teria exposto o buraco antes. A instrução não troca o método; dá repertório com **gatilho objetivo** para cada frente, e a regra transversal impede que o repertório vire papelório por precaução.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| SM | Passa a **nomear o gatilho** quando sai do Scrum; responde por escopo grande dimensionado no olho como violação de R13; instrumento formal que criar tem de entrar no changelog do processo |
| PO / Arquiteto | Consomem estimativa que, em lote grande, pode vir de contagem funcional convertida — e a premissa de conversão fica explícita |
| Stakeholder | Ganha, quando pedir, previsão de conclusão e número de escopo auditável; e uma decisão em aberto: confirmar ou ajustar os limiares numéricos |

### Conflitos com o processo vigente
Um, **resolvido no documento** (não escalado): o repertório de PMBOK/APF tensiona o princípio de leveza do time ("processo que só cresce fica caro", v1.3). Resolvido a favor da leveza pelo desenho: os instrumentos são **opt-in por gatilho objetivo**, o default continua sendo Scrum, e nenhum instrumento vira artefato permanente sem entrada no changelog. Mesma lógica com que a v1.4 resolveu Boy Scout Rule × R4 — escrever a fronteira em vez de deixar duas verdades convivendo.

Nenhum conflito com regra vigente exigiu parar para decisão do stakeholder. O que precisa de confirmação dele é calibragem, não contradição — ver abaixo.

### Como saberemos que funcionou
Três indicadores, em até três ciclos: (a) **todo plano de lote grande ou épico acima de 3× a unidade traz contagem ou a justificativa de por que a estimativa relativa bastou** — verificável lendo os planos e o quadro; (b) **toda análise de impacto que toca contrato implantado ou baseline acordada é conduzida como mudança formal** — solicitação numerada e aprovação registrada, contável nas análises de impacto do período; (c) **nenhum instrumento de PMBOK/APF em uso sem entrada correspondente aqui** — se aparecer um registro formal de riscos ou uma EAP sem changelog, a regra transversal falhou. Se em três ciclos nenhum gatilho for acionado e nenhum plano justificar o não-uso, ou o time nunca precisou (remover R13 na próxima `review metrics`) ou a régua está sendo ignorada.

### Pendente do stakeholder
- **Calibragem dos limiares de R13 / skills §9** — **RESOLVIDO pelo stakeholder em 02/09/2026, sem ajuste.** Confirmados como escritos: 3× a unidade de trabalho para lote/épico, 5 riscos abertos no status, 20% de crescimento de escopo, ~8 itens com dependências não-lineares. Alteração futura desses valores exige nova decisão registrada.
- **Proposta para `agents/scrum-master.md`** (stakeholder aplica; vigora após reiniciar a sessão): trocar "As 12 regras" por "As 13 regras" na seção de regras de trabalho, e acrescentar uma linha em "Como trabalhar" sobre o repertório de APF/PMBOK acionável por gatilho (R13 / skills §9). `commands/sm.md` pode receber, opcionalmente, um ponteiro para `skills.md §9` nos modos `plan` e `impact` — não é necessário para a regra funcionar.

### Roteamentos do `/arc review` v1.4 tratados nesta rodada
Os três itens que a v1.4 roteou para `/sm review` por serem documentos genéricos de `.team/`:

| Item | Onde | Tratamento |
|---|---|---|
| `.team/standards/` descritos como "três arquivos de uma stack" | `README.md` (tree em ~§35) | Reescrito: `implementation-principles` (nível 1) · perfis de stack nível 2 · security-lgpd-copyright transversal · README |
| `.team/standards/` como "agnósticos de produto que guiam a construção" | `README.md` (tabela "Cada pasta em `roles/`", ~§53) | Reescrito para "dois níveis — princípios agnósticos de linguagem (não mudam) e perfis de stack substituíveis" |
| standards "assumem uma stack … único ponto que pode precisar de troca" | `replicate-in-new-project.md` ~§88 | Reescrito: nível 1 não muda; só o perfil de nível 2 é substituído, pelo Arquiteto via `/arc review` |

**Fora do alcance de `review`** (tocam `.team-project/`, que o `review` não altera): `team-project/developer/context.md:25` (front-end sem comando de teste/cobertura — agora gap bloqueante) e `team-project/architect/context.md:47` (diz que os standards "assumem exatamente esta stack"). Encaminhados para um `/sm` fora de `review` (contexto de projeto é do SM com aporte do papel) e para o Arquiteto atualizar o próprio `context.md`.

### Reavaliação do conjunto — correções de curadoria
- **Contagem de componentes do plugin inconsistente** entre dois documentos genéricos: `README.md` §183 dizia "6 skills e 5 agents" e `replicate-in-new-project.md` §113 dizia "8 skills e 6 agents". O repositório tem **7 arquivos de comando** (`sm` `po` `arc` `ux` `dev` `qa` `team`) e **6 de agente**. Ambos padronizados para "7 comandos e 6 agents". O rótulo exato que `claude plugin details` usa ("skills" × "commands") deve ser confirmado em sessão interativa — a contagem, não.
- Sem remoções nesta rodada: R13 é adição com gatilho e verificação; a §9 de skills é repertório que faltava. Candidato à remoção na próxima `review metrics` se, em três ciclos, nenhum gatilho for acionado e nenhum plano precisar justificar o não-uso.

---

## v1.4 — Standards em dois níveis: princípios agnósticos de linguagem (Clean Architecture · Clean Code · CQRS · cobertura 80%) — 02/09/2026

**Instrução:** "Atualizar o standards para ter os padroes que adotaremos em todos os projetos independente da linguagem ou plataforma de desenvolvimento usando Clean Architecture, Clean Code e CQRS e Cobertura de Testes em 80%. Temos que ser capaz de organizar qualquer projeto dentro dessas praticas."
**Classificação:** formato de documento + regra (normativo de engenharia do Arquiteto)
**Registrada por:** Arquiteto, via `/arc review`

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `.team/standards/implementation-principles.md` | **novo** | Normativo de **nível 1**, agnóstico de linguagem e plataforma: Clean Architecture (4 anéis + regra de dependência verificada por teste automatizado), CQRS (e o que ele **não** obriga), Clean Code (regras verificáveis + limites numéricos como fonte única), testes e **gate de 80%**, **Ficha de Vinculação de Stack (V1–V17)**, quadro de verificação de 17 linhas e roteiro de adoção em projeto legado |
| `.team/standards/README.md` | índice | Passa a declarar os **dois níveis**, a regra de precedência (nível 1 vence) e o caminho para stack sem perfil |
| `.team/standards/implementation-guide.md` | cabeçalho · §1 · §3 · §9 | Retitulado **Perfil de Stack .NET** (v3.1); ganha ponteiros para a regra normativa de nível 1 e o projeto de teste de arquitetura |
| `.team/standards/implementation-quality.md` | cabeçalho · §3 · §5 · pendências | Retitulado **Perfil .NET/GitLab** (v1.3); limites numéricos passam a citar o nível 1 como fonte única (+ limite de parâmetros); tabela do que bloqueia ganha teste de arquitetura e `TODO` sem ID; 3 pendências novas registradas |
| `.team/standards/implementation-security-lgpd-copyright.md` | documentos relacionados | Declarado transversal aos dois níveis; C# nele é ilustração de perfil, não obrigação de sintaxe |
| `roles/architect/README.md` | roteiro `plan` · documentos | Passo 2 cita os dois níveis; **sem Ficha de Vinculação preenchida não há Plano de Execução**; todo passo declara o anel |
| `roles/architect/skills.md` | §8 · §9 (nova) | Gate previsto e não configurado vira sinal de dívida; nova skill "Vincular qualquer stack aos princípios" |
| `roles/architect/templates/execution-plan.md` | §3 · §5 · §6 · regras 8–9 | Cada passo declara o **anel**; cobertura entra como verificação obrigatória; proibido passo de refatoração de passagem |
| `roles/architect/templates/compliance-review.md` | §2 | Tabela de padrão arquitetural generalizada (saem nomes de arquivo de uma stack específica) e ampliada com regra de dependência, CQRS, limites de código limpo e gate de cobertura |
| `deliverables/sdd/03-architecture.md` | §2b (nova) · regras · falhas | Ficha de Vinculação de Stack passa a ser **seção obrigatória** do documento de arquitetura de qualquer produto |
| `roles/developer/skills.md` | §8 (nova) | Limites mecânicos de código limpo, e o que vira 🔺 GAP em vez de iniciativa |
| `roles/developer/templates/gap.md` | quando levantar | Dois gatilhos novos: limite de código estourado, constante não definida pelo plano |
| `roles/developer/templates/delivery-report.md` | Verificação · regras | Saída real do gate de cobertura passa a fazer parte da entrega |

### Por quê
Os `.team/standards/` eram bons, mas **casados com uma stack**: os três documentos abriam com "Stack alvo: .NET 10", e `replicate-in-new-project.md` §88 já admitia que eram "o único ponto de `.team/` que pode precisar de troca". Consequência prática de duas formas. Primeira: **um projeto em outra linguagem herdava o time sem normativo de engenharia** — e, sem régua, cada item vira decisão nova. Segunda, visível já no projeto atual: a metade em Angular não tem gate de cobertura nenhum (`.team-project/developer/context.md:25` roda só `lint` e `build`), porque o normativo só sabia falar de `Domain`/`Application` em .NET. Separar princípio de perfil resolve os dois sem quebrar as ~40 referências que os documentos do produto já fazem às seções do perfil .NET.

**Clean Code não existia em lugar nenhum** — a busca por "Clean Code" em `docs/` não retornava uma linha. O que havia eram limites de métrica escondidos num documento de CI, sem nome, sem regra de nomenclatura, sem regra de comentário, sem proibição de código morto. Agora tem nome, verificação e fonte única.

E a razão de a Ficha de Vinculação existir: sem ela, "aplicar Clean Architecture em qualquer linguagem" é conversa. Com ela, o Arquiteto é obrigado a nomear o anel real e **o comando que prova a regra** antes do primeiro plano — que é o que impede o padrão de virar slogan.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Arquiteto | Preenche a Ficha de Vinculação antes do primeiro plano; declara o anel em cada passo; responde por gate previsto e não configurado como dívida arquitetural |
| Dev | Ganha limites mecânicos (nome, magia, código morto, `TODO` com ID, captura vazia, tamanho de função) e dois gatilhos novos de 🔺 GAP; passa a colar a saída do gate de cobertura no relatório |
| QA | Passa a ter um quadro de 17 verificações com estágio e consequência para conferir aderência, em vez de julgar caso a caso |
| Stakeholder | Duas decisões abertas (COVERAGE-STAT e COVERAGE-SCOPE) registradas, não resolvidas por conta do Arquiteto |

### Conflitos com o processo vigente
Três, e **nenhum foi resolvido em silêncio**:

1. **Média × mínimo no gate de cobertura.** O perfil .NET aplicava `ThresholdStat=average` — média entre módulos, que deixa um módulo a 40% passar às custas de outro a 100%. O nível 1 exige mínimo por módulo. Levado ao stakeholder como `COVERAGE-STAT` — **resolvido no mesmo dia, ver adendo abaixo**.
2. **Escopo do gate.** "Cobertura de 80%" na instrução não dizia de quê. Levado ao stakeholder como `COVERAGE-SCOPE` — **resolvido no mesmo dia, ver adendo abaixo**.
3. **Boy Scout Rule × escopo fechado.** Clean Code clássico manda melhorar o código que se encosta; a regra R4 do time proíbe refatoração de passagem. Resolvido **a favor da regra do time**, com a exceção escrita e justificada em §4.5 do novo normativo — em vez de deixar as duas verdades convivendo.

### Adendo — decisão do stakeholder, 02/09/2026
*(Acrescentado no mesmo dia, fechando as duas pendências que a própria entrada declarou. O texto original acima não foi reescrito.)*

| Pendência | Decisão do stakeholder | Onde foi aplicada |
|---|---|---|
| `COVERAGE-STAT` | O gate de 80% é **mínimo por módulo — nunca média**. O gate reprova pelo pior módulo | `implementation-principles.md` §5.4 e §7 (linha 11) · `implementation-quality.md` §2 (`ThresholdStat=minimum`), §4 (`.gitlab-ci.yml`) e §5 |
| `COVERAGE-SCOPE` | O gate cobre **tudo**: núcleo, adaptadores, borda **e front-end**. Nenhum anel isento, nenhuma unidade implantável de fora | `implementation-principles.md` §5.3, §5.4, §5.5, §6 (V5/V10/V11/V12/V15), §7 (linha 14), §8 · `implementation-quality.md` §2 e **§4.1 (novo — um job de cobertura por unidade implantável)** · `templates/execution-plan.md` §5–6 · `templates/delivery-report.md` |

Consequência prática que a decisão assume: `average` e `total` deixam de ser configurações aceitas, e **unidade implantável sem job de cobertura no pipeline passa a ser achado bloqueante** — o item que a toca não é dado como verificado. O front-end deixa de ser exceção tolerada.

### Como saberemos que funcionou
Quatro indicadores, em até três ciclos: (a) **todo Plano de Execução novo declara o anel** em cada passo e traz o comando de cobertura da unidade que toca — verificável lendo os planos em `architect/plans/`; (b) **nenhum item fecha com "cobertura ok" sem a saída real** no relatório do dev; (c) **toda unidade implantável do repositório tem job de cobertura no pipeline, front-end incluído** — contável no arquivo de CI, e é o indicador que prova a decisão do stakeholder; (d) o próximo projeto a receber este time — em qualquer linguagem — sai da instalação com a **Ficha de Vinculação preenchida e os gates de todas as unidades ligados antes do primeiro item de negócio**, medido pela existência da §2b no documento de arquitetura. Se em três ciclos nenhum plano citar o anel, o normativo virou enfeite e a régua está no lugar errado.

### Pendente do stakeholder
- **Nada em aberto sobre o gate.** `COVERAGE-STAT` e `COVERAGE-SCOPE` foram decididos em 02/09/2026 (adendo acima).
- **Roteado ao `/sm review`** (documentos que não são do Arquiteto): `README.md` §35 e §53 e `replicate-in-new-project.md` §88 descrevem os `.team/standards/` como três arquivos de uma stack só — passaram a estar desatualizados com os dois níveis.
- **Roteado ao `/sm review`** (contexto de projeto): `team-project/developer/context.md:25` traz o front-end com `lint` + `build` e **nenhum comando de teste ou cobertura** — com a decisão de escopo, isso passou de lacuna tolerada a **gap bloqueante**; e `team-project/architect/context.md:47` ainda diz que os standards "assumem exatamente esta stack".
- Nada em `agents/` ou `commands/`: o alcance de `/arc review` já cobria `.team/standards/` e `roles/developer/**`.

---

## v1.3 — Reavaliação obrigatória no `review`, e os documentos do dev passam ao Arquiteto — 02/09/2026

**Instrução:** "é importante que cada um no seu review reavalie os documentos dos seus processos, templates, standards e controles; somente os de developer devem ser revisados pelo arquiteto e não pelo próprio developer, por usar uma IA mais simples".
**Classificação:** escopo de papel + comportamento de comando

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `commands/sm.md` · `po.md` · `arc.md` · `ux.md` · `qa.md` | modo `review` | Ganham a seção **Reavaliação do conjunto** — 8 verificações aplicadas sempre; `review` sem instrução faz só a reavaliação |
| `commands/dev.md` | modo `review` | **Removido.** O comando passa a redirecionar para `/arc review` em vez de executar |
| `commands/arc.md` | modo `review` | Alcance estendido a `roles/developer/**`, com os 🔺 GAPs e as seções "Não fiz" como evidência |
| `agents/*` | seção `review` | Reavaliação incorporada; o do dev troca a seção por "os seus documentos são revisados pelo Arquiteto" |
| `process/artifact-ownership.md` | matriz | `team/roles/developer/**` passa a ter o Arquiteto como responsável, com o motivo registrado |
| `roles/developer/README.md` · `roles/architect/README.md` | roteiro | A exceção e o novo alcance ficam visíveis nos dois lados |

### Por quê
Duas coisas, e a segunda é a mais importante. **Reavaliação:** aplicar a instrução sem reler o conjunto faz o documento crescer em camadas — cada mudança correta isoladamente, e o todo cada vez mais incoerente. Forçar a releitura no mesmo passe é o que mantém o normativo enxuto e verificável, e é onde entra a única pergunta que impede o processo de inchar: *o que dá para remover?*

**Documentos do dev:** o papel roda no modelo mais simples do time, calibrado para **executar plano com fidelidade** — exatamente o oposto do julgamento necessário para avaliar e reescrever a regra que o governa. Deixá-lo revisar o próprio normativo é o caminho mais curto para ele afrouxar sem ninguém perceber, e o time perderia justamente a disciplina que o torna produtivo. O Arquiteto é a escolha natural: escreve o plano que o dev consome, revisa a aderência do que ele devolve, e já lê os 🔺 GAPs e as seções "Não fiz" — a evidência real de onde o processo atrapalha.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Todos com `review` | Passam a **reavaliar**, não só aplicar; e a responder pela coerência do conjunto que mantêm |
| Arquiteto | Ganha os documentos do dev sob seu alcance — e a obrigação de usar o retorno real do dev como evidência |
| Dev | Perde o `review`; o seu retorno sobe pelo 🔺 GAP e pela seção "Não fiz", que passam a ter peso de insumo de processo |

### Conflitos com o processo vigente
Um, resolvido: a regra "cada papel só mexe nos próprios documentos" (v1.2) ganha uma exceção nomeada. Registrada na matriz de propriedade com o motivo, para não parecer arbitrária a quem chegar depois.

### Como saberemos que funcionou
Reavaliações produzindo pelo menos uma remoção a cada três rodadas — se o processo só cresce, a reavaliação virou formalidade. E mudanças em `roles/developer/**` sempre citando um 🔺 GAP ou uma seção "Não fiz" como origem.

### Pendente do stakeholder
Nada — as duas mudanças foram pedidas explicitamente.

---

## v1.2 — Evolução do processo distribuída por papel — 02/09/2026

**Instrução:** "gostaria que esse processo de aperfeiçoamento fosse para todos os roles em um comando, por exemplo `/sm review`, e remova esse `/process`".
**Classificação:** comportamento de comando + escopo de papel
**Substitui:** a v1.1, que concentrava a evolução do processo num comando único.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `commands/process.md` | — | **Removido** |
| `commands/sm.md` · `po.md` · `arc.md` · `ux.md` · `dev.md` · `qa.md` | modos | Cada um ganha o modo `review`, com alcance limitado aos documentos do próprio papel |
| `commands/sm.md` | modo `review` | Mantém o alcance ampliado: normativos que governam todos + curadoria + `review audit` / `review metrics` / `review history` |
| `commands/dev.md` | pré-condição | `review` é o único modo do `/dev` que não exige Plano de Execução |
| `process/artifact-ownership.md` | matriz | Changelog do processo vira exceção explícita à regra de dono único: todo papel acrescenta, o SM cura |
| `process/workflow.md` | cerimônias | Melhoria de processo passa a `/<papel> review`; curadoria entra como cerimônia própria do SM |
| `README.md` | Como o processo evolui | Tabela de alcance por papel |

### Por quê
Concentrar a melhoria num comando só criava dois problemas. O primeiro é de **conhecimento**: quem sabe que o formato do relatório de entrega atrapalha é o dev, não o SM — e a instrução chegava filtrada por um papel que não vive o documento. O segundo é de **propriedade**: o `/process` fazia o SM editar documentos de outros papéis, contrariando a matriz que o próprio time usa. Distribuir o `review` alinha quem melhora com quem é dono, e mantém o SM onde ele é insubstituível: nos normativos que governam todos, e na curadoria do conjunto.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Todos | Passam a responder pela **qualidade dos próprios documentos de processo**, não só por usá-los |
| SM | Deixa de ser o único autor e passa a ser **curador**: consolida o changelog, aponta contradição entre mudanças de papéis diferentes e escala o que ficou inconsistente |
| Stakeholder | Direciona a melhoria ao papel que vive o problema, em vez de passar tudo pelo SM |

### Conflitos com o processo vigente
Um, resolvido: o changelog é do SM pela matriz de propriedade, mas agora recebe entradas de todos. Registrado como **exceção explícita** em `artifact-ownership.md`, com o SM na função de curador — em vez de duplicar o documento por papel, que fragmentaria a memória do processo.

### Como saberemos que funcionou
Instruções de melhoria vindas de mais de um papel no changelog — se só o SM registrar, a distribuição não pegou. E nenhuma entrada de um papel alterando documento de outro.

### Pendente do stakeholder
Nada — a remoção do `/process` e os seis modos `review` foram pedidos explicitamente.

---

## v1.1 — Comando de evolução do processo — 02/09/2026 · *(substituída pela v1.2)*

**Instrução:** "o scrum-master recebe um comando cujo enfoque é o aperfeiçoamento do processo de trabalho do time, onde passarei instruções que alimentarão os documentos do /team, registrando melhorias dos métodos de trabalho, documentação e organização do time".
**Classificação:** escopo de papel + comportamento de comando

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `commands/sm.md` | novo | Comando `/sm review` com quatro modos: registrar melhoria, revisar por evidência, auditar coerência, ver histórico |
| `agents/scrum-master.md` | Responsabilidades | Nova responsabilidade: curadoria e evolução do processo |
| `roles/scrum-master/README.md` | Roteiro, documentos | Modo `/sm review` e os dois documentos novos |
| `roles/scrum-master/templates/process-change.md` | novo | Formato da entrada de mudança de processo |
| `roles/scrum-master/process/process-changelog.md` | novo | Este documento |
| `process/workflow.md` | Cerimônias | Revisão de processo entra como cerimônia periódica |
| `process/artifact-ownership.md` | Matriz | Changelog do processo atribuído ao SM |

### Por quê
O processo vinha mudando por conversa: cada ajuste chegava por mensagem, era aplicado e o motivo se perdia. Sem registro, a próxima pessoa desfaz uma regra por achar que é burocracia — e o modo de falha que a regra evitava volta. O comando dá um caminho único para a melhoria entrar, ser classificada, verificada quanto a conflito e registrada.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| SM | Passa a responder pela **coerência** do processo, não só pelo seu cumprimento: classifica a instrução, detecta conflito com regra vigente e registra |
| Todos | Mudança de processo passa a ter origem rastreável; ninguém segue regra que não está escrita |
| Stakeholder | Mudança em `agents/` e `commands/` continua sendo dele — o SM propõe, não aplica |

### Conflitos com o processo vigente
Nenhum. Complementa a regra R6 ("decisão tomada é decisão registrada"), estendendo-a das decisões de produto para as decisões de processo.

### Como saberemos que funcionou
Nenhuma regra de trabalho sem entrada correspondente aqui; e, na próxima retrospectiva, o SM consegue explicar a origem de qualquer regra que o time questione.

### Pendente do stakeholder
Nada — `commands/sm.md` e a responsabilidade nova em `agents/scrum-master.md` foram criados a pedido explícito.

---

## v1.0 — Linha de base do time — 01–02/09/2026

**Instrução:** montagem do time Scrum a pedido do stakeholder, com evolução em várias rodadas.
**Classificação:** estrutura inicial

### O que ficou estabelecido
| Elemento | Decisão |
|---|---|
| Papéis | 6 — Scrum Master, Product Owner, Arquiteto, UX, Desenvolvedor, QA |
| Capacidade | Um único desenvolvedor; a construção é uma fila, o paralelismo é entre papéis |
| Distribuição de modelos | Opus no Arquiteto e no UX (produzem especificação), Sonnet em SM/PO/QA, Haiku no dev |
| Empacotamento | `.team/` é um plugin do Claude Code; comandos `/sm` `/po` `/arc` `/ux` `/dev` `/qa` `/team` `/sm review` |
| Fronteira | `.team/` genérico e reutilizável; `.team-project/` com o contexto do projeto |
| Normativos | 12 regras de trabalho (eficiência R1-R6, qualidade R7-R12), fluxo com DoR/DoD e gates, matriz de propriedade |
| Entregáveis | Modelos do SDD (8 documentos) e do conjunto de implementação (4), com dono por documento |

### Por quê
O projeto foi retomado após abandono, com 50 pendências abertas e um documento de status que declarava concluído o que o código não sustentava. As regras nasceram desses modos de falha concretos — cada uma nomeia o que evita.

### Como saberemos que funcionou
Nenhum item fechado sem evidência; nenhuma regra sem forma de verificação; o time replicável em outro projeto sem editar `.team/`.
