# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v3.0 — Redesenho do modelo de trabalho: História e Task, sprint como caixa de tempo, aceite na Sprint Review — 08/09/2026

**Instrução:** *(stakeholder, via questionário)* o bloco "Revisão do Processo" de `note.md` (15 linhas descrevendo uma cadeia Scrum completa) mais as respostas a seis decisões: sprint como caixa de tempo · SDD funcional/técnico como **portão**, não documento · hierarquia História → Task, com o plano dentro da Task · **aceite só na Sprint Review** · estimativa da Task pelo time na Planning · comandos novos `/po story`, `/sm sprint`, `/sm review`.

**Classificação:** fluxo (§2, §2a, §3, §4, §5, §5e nova) + regra (R1–R2, R4–R8, R11–R17 reescritas; **R20 e R21 novas**) + propriedade de artefato (História, Task, Sprint Backlog, registro de sprint) + formato de documento (modelos de História, Sprint Review, quadro, backlog, aceite, retrospectiva, plano) + comportamento de agente (6 agents, 8 commands) + escopo de papel (PO ganha a História; SM ganha a cadência; QA deixa de ser "o último passo antes do PO").

### O que mudou

| Documento | Onde | O quê |
|---|---|---|
| `process/workflow.md` | §1, §2, §2a | Duas unidades declaradas: **História** (valor, PO, só funcional) e **Task** (trabalho, SM + Arquiteto). Cadeia SDD → História → Sprint → Task com **quatro portões**. Ciclo da Task em 11 etapas |
| | §3, §4 | DoR e DoD **desdobradas em duas**: da História (§3a, §4a-ii) e da Task (§3b, §4a-i). "Aceite do PO" sai da DoD da Task |
| | §5, **§5e nova** | Planning Meeting, Sprint Review e Sprint Retrospective entram nas cerimônias; §5e descreve o sprint como caixa de tempo — Planning em 6 passos com estimativa e **capacidade observada**, escopo congelado, Review, retrospectiva, e como o SM verifica |
| | §5b, §8 | Transição para o SDD ganha os portões ① (funcional) e ② (técnico); a tabela de gates ganha os quatro |
| | §5d | `/team update` passa a **reconciliar o `.team-project/`** (item 29 de `note.md`) |
| `process/working-rules.md` | R1–R17 | Reescritas sobre Task/História/sprint. R14 passa a bloquear a **primeira Planning**; R15 ganha os dois portões do SDD |
| | **R20 nova** | *História é a unidade de valor; Task é a unidade de trabalho.* Toda Task pertence a uma História; detalhamento é **só funcional**; trabalho técnico precisa de História que declare o valor |
| | **R21 nova** | *Aceite funcional é por História, na Sprint Review.* Fechar Task é técnico. **História rejeitada devolve todas as Tasks, inclusive as aprovadas pelo QA** — preço aceito conscientemente |
| | indicadores | Passam a rodar por sprint; linhas novas de R20, R21 e estimado × entregue. **19 → 21 regras** |
| `process/artifact-ownership.md` | matriz, §2, §3, §4 | História (PO), Task (SM + Arquiteto), registro de sprint; Product Backlog = conjunto das Histórias; fluxo com os quatro portões; 5 conflitos novos; IDs `H-nnn`/`T-nnn` |
| `roles/product-owner/` | **`templates/user-story.md` novo** | A História em dois estados (esboço · detalhada), com o portão ③ |
| | `product-backlog.md`, `acceptance.md`, README | Backlog vira o conjunto das Histórias, com estados; aceite muda de alvo (História) e de lugar (Review); modo `/po story` |
| `roles/scrum-master/` | **`templates/sprint-review.md` novo** | Registro da Review: o SM conduz e registra, o PO aceita |
| | `work-board.md`, `retrospective.md`, `status-entry.md`, README | Quadro vira Sprint Backlog com cabeçalho de sprint e Tasks sob a História; retro roda por sprint, depois da Review; status-entry registra fechamento técnico; modos `sprint plan`, `sprint close`, `review` |
| `roles/architect/` | `execution-plan.md` → **`implementation-plan.md`** | Renomeado e reposicionado: **é o conteúdo técnico da Task**, não um artefato irmão. É o primeiro e único lugar onde entra decisão técnica |
| `deliverables/` | `README.md`, `sdd/README.md` | Os dois portões do SDD documentados, com o porquê de cada um. O conjunto continua **um só, com versão única** |
| | **`team-project/README.md` novo** | Manifesto do `.team-project/` (itens 27–28 de `note.md`): o que o `init` cria, de onde cada arquivo nasce e **a classe de reconciliação** de cada um. É índice, não cópia |
| `team-update.md` | **passo 7 novo** | Reconciliação do `.team-project/` em três classes, **sem apagar conteúdo do projeto sem aprovação**. 7 → 8 passos |
| `team-init.md` | passos 2, 3, 5 | Aponta o manifesto; coleta **duração do sprint** e **unidade de estimativa** |
| raiz | `README.md`, `how-to.md` | Superfície de comandos com `<H-ID>` × `<T-ID>`; caminho padrão redesenhado com os portões; desambiguação `/sm review` × `/review` |
| `agents/*`, `commands/*` | 6 + 8 arquivos | Superfície, contagens e limites atualizados *(propriedade do stakeholder — aplicado por instrução direta dele, não por proposta do `/review`)* |

**Modo de falha que evita:** o time entregar Tasks tecnicamente corretas que, somadas, não entregam nada que o stakeholder reconheça como valor — e não haver momento formal em que isso apareça. Antes, "entregue" era a soma de aprovações técnicas por item; agora é o aceite de uma História, ante o stakeholder, contra critérios que ele mesmo aprovou.

**Quem passa a ser cobrado de forma diferente:** o **PO** (escreve e detalha Histórias, e só aceita na Review); o **SM** (conduz a cadência do sprint e **não aceita nada**); o **QA** (valida por Task e fornece evidência na Review, em vez de ser "o último passo antes do PO"); o **UX** (protótipo migra para o detalhamento da História, antes da Planning); o **stakeholder** (passa a ter quatro portões de aprovação).

**Indicador de sucesso:** nenhuma Task sem História de origem no Sprint Backlog; nenhuma História na Planning sem o portão ③ registrado; nenhum aceite fora da Review; desvio estimado × entregue abaixo de 25% a partir do terceiro sprint.

### Conflitos resolvidos

| Conflito | Com que regra | Resolução |
|---|---|---|
| "Sprint Backlog" era apelido do quadro do SM; `note.md` dava o artefato ao PO | dono único (`artifact-ownership.md`) | O Sprint Backlog **continua do SM**; o que é do PO é a História e o Product Backlog |
| "Task" e "Plano de Execução" seriam dois artefatos | referência cruzada em vez de repetição | O plano vira **conteúdo da Task**; um nome só, `Plano de Implementação` |
| SDD funcional/técnico como dois documentos | "versão única para o conjunto" (`sdd/README.md`) | Viraram **portões de aprovação**; a estrutura de 8 arquivos fica intacta |
| Sprint como 2º relógio ao lado de "a cada 3 itens" | gatilhos de §5, §5c | Todos os gatilhos passam a contar **sprints**; o relógio por item foi removido |
| `/sm review` colidia com o `/review` do processo | `commands/sm.md` dizia "não há mais `/sm review`" | Mantido o nome escolhido pelo stakeholder, com **tabela de desambiguação** em `commands/sm.md`, `roles/scrum-master/README.md`, `README.md`, `how-to.md` e no `project-context.md` |
| Item 27 pedia mover todos os modelos para `deliverables/` | `roles/<papel>/templates/` é do papel | `deliverables/team-project/` é **manifesto/índice**, não cópia — resolve o sintoma sem criar duas verdades |

### Evidência (R19)

| Classe | Comando | Resultado |
|---|---|---|
| Arquivamento | `Compare-Object` do bloco `## v2.9` movido × `git show HEAD:…/process-changelog.md` linhas 159–205 | **47 linhas × 47 linhas, diff = 0.** Relocado íntegro; índice de arquivadas ganhou a linha `v2.9` |
| Substituição de padrão | `Plano de Execução` → `Plano de Implementação` e `execution-plan.md` → `implementation-plan.md`, em todo `*.md` menos changelogs e `note.md` | 19 arquivos alterados; `grep` do padrão antigo = 0 |
| Substituição de padrão | `item` → `Task` com concordância de gênero, idiom `item a item` protegido | 56 arquivos alterados |
| **Checagem semântica** da substituição acima | varredura de concordância + **leitura de cada ocorrência no contexto** | **13 erros de concordância** corrigidos (`um Task aberta`, `a Task inteiro`, `Task concluído`…) e **4 falsos positivos** revertidos, onde `Item` era rótulo genérico de linha de tabela: `README.md` → "Arquivo / pasta"; `compliance-review.md` → "Verificação"; `cross-audit.md` → "Especificação"; `product-backlog.md` → "O que". O `grep` zerado teria mentido nos quatro |
| Substituição de padrão | `19 regras` → `21 regras`, `R13-R19` → `R13-R21`, `/sm plan` → `/sm sprint plan` | 6 arquivos; residual dos três padrões e de `sprint sprint` = 0 |
| Extração / criação | `deliverables/team-project/README.md`, `templates/user-story.md`, `templates/sprint-review.md` | 3 novos, referenciados de `deliverables/README.md`, dos READMEs dos papéis e da matriz |
| Renomeação | `git mv execution-plan.md → implementation-plan.md` | rename detectado pelo git (77%); nenhum ponteiro órfão |

### Pendente do stakeholder

- **Fecho da entrega:** bump para `3.0.0` e entrada `v3.0.0` no `CHANGELOG.md` (R18), na branch `feat/v3.0.0`.
- **Reiniciar a sessão** — `agents/` e `commands/` só entram em vigor no próximo carregamento.
- **Projetos instalados** precisam de `/team update`; o vocabulário mudou, então quadro e backlog existentes pedem leitura antes de aplicar.
- **`note.md`:** o bloco "Revisão do Processo" e os itens 27–29 saem da fila, consumidos aqui.

---

## v2.11 — Guias de raiz ganham dono; roteiro de instalação endurecido; R19 passa a exigir checagem semântica — 07/09/2026

**Instrução:** *(stakeholder)* "por corrigir" — sobre a triagem do relato de instalação em `note.md` e os achados da reavaliação.
**Classificação:** **propriedade de artefato** (guias de raiz sem dono na matriz) + formato de documento (roteiro de instalação; resíduo da v2.10) + regra (R19 ganha a checagem semântica).
**Registrada por:** SM (curador), acionado pelo `/review`. **Escopo:** fecha o buraco de titularidade que impedia o roteamento de 5 dos 6 sub-itens do relato, e aplica o relato.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `process/artifact-ownership.md` | §1 matriz | **Linha nova:** guias e rituais de raiz (`README.md`, `how-to.md`, `replicate-in-new-project.md`, `review-contract.md`, `team-init.md`, `team-update.md`) → dono **stakeholder**; o SM mantém a **coerência de referência cruzada** (contagem, ponteiro, nome de modo, índice) como curadoria. Eram os únicos arquivos do plugin sem dono declarado |
| `review-contract.md` · `commands/review.md` | §Limites · tabela de triagem | Os guias de raiz entram como classe própria: proposta ao stakeholder, com a exceção de curadoria do SM |
| `how-to.md` | §"Instalar em um projeto" | Reescrito em **5 passos numerados**, do relato de campo: URL `.git` completa obrigatória (nunca `owner/repo` — duas formas do mesmo marketplace não casam no resolvedor); bloco esperado do `.claude/settings.json`; passo de verificação `marketplace list` (project × user settings); **reinício como passo numerado e verificável** (`/plugin` enabled, `/help` com 8 comandos e 6 agentes); e a afirmação positiva de que o projeto-alvo **não precisa ser repo git**. Nova subseção **"Windows e múltiplos perfis"**: um `CLAUDE_CONFIG_DIR` por vez, caixa da letra do drive em `installed_plugins.json`, `git clone` "vermelho" no PS 5.1, exibição duplicada em `plugin list` — os três últimos **marcados como contorno de bug externo**, que envelhecem quando a ferramenta corrigir |
| `replicate-in-new-project.md` | passo 1 · checklist | Mesma forma de identificador em todos os registros; projeto-alvo não precisa ser repo git; checklist ganha a verificação de **escopo** (project × user) e o reinício verificável |
| `process/working-rules.md` · `review-contract.md` | R19 · passo 5 | **`grep` zerado não é substituição completa.** A classe "substituição de padrão" passa a exigir **ler cada ocorrência nova no contexto** e conferir o que depende dela — contagem enumerada, lista adjacente, total citado noutro documento |
| `README.md` · `commands/review.md` · `roles/architect/README.md` | resumos do `/review` | "cinco passos" com enumeração de **quatro** → os cinco, com `verificar com evidência`. Resíduo da v2.10 |
| `roles/scrum-master/templates/retrospective.md` | Métricas | **Linha de R19** — o mesmo gap que a v2.10 fechou para R18 ficara aberto para a regra que ela própria criou |
| `README.md` · `process/workflow.md` | índice · §5d | `team-update.md` no índice de estrutura; o ponteiro de §5d passa a citar `team-update.md`, não `commands/team.md` (os passos saíram de lá em `450adce`) |
| `process/process-changelog.md` | — | v2.8 arquivada íntegra (teto de 3 — R17); linha no índice |

### Por quê
**Titularidade.** A matriz cobria `CHANGELOG.md`, `agents/`, `commands/`, `roles/`, `standards/` — e nenhum dos guias de raiz, que são a **face de instalação** do plugin. Sem dono não há rota: 5 dos 6 sub-itens acionáveis do relato de campo não tinham para onde ser roteados, e um relato bom ficaria parado por falta de linha na tabela. **Evita:** item legítimo que morre na triagem porque o alvo não pertence a ninguém.

**Roteiro de instalação.** O relato documenta uma instalação que falhou em silêncio por três causas independentes — identificador do marketplace em duas formas, registro caindo em user settings apesar do `--scope project`, e caixa da letra do drive. O roteiro anterior tinha 4 linhas e um comentário; não verificava nada. **Evita:** "Successfully installed" seguido de plugin que nunca aparece.

**R19.** A regra nasceu na v2.10 para o `/review` não declarar o que não verificou — e a própria v2.10 passou no `grep` de "quatro passos" (0 antigo / 10 novo) deixando ao lado três enumerações com quatro itens. O `grep` provou que a string sumiu, não que o sentido fechou.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| **SM** | Ganha a curadoria de referência cruzada nos guias de raiz — e a retrospectiva coleta o indicador de R19 |
| **Todos os papéis** | Substituição de padrão não fecha com `grep` zerado: exige ler cada ocorrência nova no contexto |
| **stakeholder** | Passa a ser dono declarado dos guias de raiz; o `/review` propõe o texto, não aplica |

### Conflitos com o processo vigente
Nenhum. A recomendação de `--scope project` do relato **reforça** o que `how-to.md` e `replicate-in-new-project.md` já prescreviam; a remoção do registro global foi limpeza da máquina do relator, fora do escopo do plugin. A linha nova da matriz não retira caneta de ninguém — cobre arquivos que não estavam em linha alguma.

### Como saberemos que funcionou
Nas próximas três instalações em máquina nova: **zero** casos de "instalou e não apareceu" que o roteiro não antecipe. E nos próximos três `/review`: **zero** achados de contagem/enumeração incoerente sobrevivendo ao passo 5 — o teste é a v2.10, que hoje seria pega. Se o `grep` continuar passando defeito semântico, a classe precisa de comando próprio, não de instrução.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento | `Compare-Object` v2.8 do archive × `450adce` | 47/47 linhas, **0 de diferença** | ✅ |
| Substituição **semântica** | contar `·` nas 3 linhas de "cinco passos" | `README.md:162`, `commands/review.md:55`, `roles/architect/README.md:55` → **5/5 itens** cada | ✅ |
| Substituição | R19 nos três lugares (regra · indicador · instrumento) | `working-rules` 3 · `retrospective` 1 · template `Evidência` 2 | ✅ |
| Substituição | guias de raiz na matriz de propriedade | 5/5 (`how-to`, `replicate`, `review-contract`, `team-init`, `team-update`) | ✅ |
| Extração | `team-update.md` referenciado de todos os pontos | índice do `README` 1 · `workflow` §5d 1 · `commands/team.md` 1 | ✅ |
| Manifesto | `claude plugin validate . --strict` | passou | ✅ |

### Pendente do stakeholder
- **Fecho da entrega:** bump de `plugin.json` e entrada `v2.9.0` no `CHANGELOG.md` (R18), com a divergência de numeração §5d declarada — a entrega carrega agora **duas** entradas de processo (v2.10 e v2.11).
- **Reiniciar a sessão** — `commands/review.md` e `agents/*` só valem no próximo carregamento.
- `note.md`: o lote do relato de instalação foi **consumido**; a fila `## Abertas` volta a ficar vazia.

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

