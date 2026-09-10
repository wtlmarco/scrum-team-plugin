# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v3.6 — Pergunta ao stakeholder ganha forma fixa: opções descritas, recomendação e a via de pedir mais contexto (R22) — 10/09/2026

**Instrução:** *(stakeholder, via `/review note` — item único de `note.md`)* "Ao apresentar uma questão que necessita de resposta pelo stakeholder deve ser apresentada no modelo de questionamento com a interface de opções para escolha com a descrição o mais clara possível para entendimento e ao final adicionar uma opção do stakeholder pedir mais detalhes para a tomada de decisão."

**Classificação:** regra nova (**R22**, Bloco C — Método, ligada a R9). O item chegou como solução pronta (formato de interface), não como sintoma; traduzido: R9 diz **para quem** escalar, mas nenhum normativo dizia **como** a pergunta chega ao stakeholder — "opções + recomendação" já vivia espalhada e informal em `workflow.md` (§5a, §6), sem forma verificável nem a via de pedir mais contexto.

**Por que regra nova, e não extensão de R9.** R9 governa a **escalação em si** (quem escala para quem, e que quem recebe decide) — dev → Arquiteto, funcional → PO, estratégico → stakeholder. A instrução do item cobre só a **apresentação** do ramo que pousa no stakeholder, e esse ramo também nasce fora de R9 (onboarding R14 §5a, brainstorm R15 §5b, lacuna de especificação e exceção de padrão em §6). Sobrecarregar R9 misturaria "escalar" com "como formular" e não cobriria as origens que não são gap de dev. R22, **ligada a R9** (cita-a como parte da forma), cobre a fração comum a todas as origens: toda vez que a pergunta pousa no stakeholder.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `process/working-rules.md` | **R22 nova**, Bloco C | Pergunta em uma frase + por que bloqueia; alternativas **descritas**, não só nomeadas; recomendação do time (R9); alternativa fixa de **pedir mais contexto** — escolhê-la não é "não decidiu", é resposta válida |
| | Resumo em uma tela · indicadores de retrospectiva | Linha R22 nas duas tabelas |
| `process/workflow.md` | §5a passo 5 · §5a "O que o SM escala" | "opções · recomendação" → forma fixa de R22, com a via de mais contexto citada |
| | §6, diagrama de escalação | `(3 opções + recomendação)` → `(opções descritas + recomendação + pedir mais contexto — R22)` — o "3" caía porque R22 não fixa quantidade, só forma |
| | §6, texto após o diagrama | "vem com opções e recomendação" → "vem na forma fixa de R22" |
| `roles/scrum-master/skills.md` §10 · `roles/scrum-master/README.md` (`/sm onboarding`) | onboarding | Mesma reescrita — as duas cópias do papel do SM citavam a convenção antiga e ficariam em forma divergente do normativo que acabaram de referenciar |

### Por quê
Sintoma por trás do pedido: R9 diz para quem escalar, não como a pergunta chega. "Opções + recomendação" já era prática registrada em quatro pontos de `workflow.md`, mas nenhum obrigava **descrever** cada alternativa nem previa a via de o stakeholder **pedir mais contexto** — a pergunta podia chegar como lista de rótulos, forçando-o a adivinhar a implicação de cada opção, ou a decidir sem munição e sem saída formal para pedir mais.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| **Todos os papéis** | Pergunta que escalam ao stakeholder (R9, onboarding, brainstorm, §6) traz alternativas descritas, recomendação e a via de pedir mais contexto — não mais texto livre |
| **SM** | Verifica a forma na curadoria; devolve pergunta incompleta antes que chegue ao stakeholder |
| **stakeholder** | Ganha via explícita e sem custo de pedir mais contexto antes de decidir |

### Conflitos com o processo vigente
Nenhum. Aditiva sobre uma convenção que já existia informalmente em `workflow.md` (§5a, §6); não contradiz regra vigente, formaliza o que já era prática e fecha a lacuna que ela deixava (descrição da alternativa + via de mais contexto).

### Como saberemos que funcionou
Nas próximas três perguntas escaladas ao stakeholder por qualquer via (R9, onboarding, brainstorm, §6): **zero** em texto corrido ou lista de rótulos sem descrição; **100%** com a via de pedir mais contexto presente. Uso real dessa via numa das três é o teste de que não é decorativa.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | leitura de cada ocorrência de "opções"/"recomendação" em `workflow.md`, `skills.md`, `roles/scrum-master/README.md` (checagem semântica, não só `grep`) | 6 ocorrências normativas do SM reescritas citando R22 (`workflow.md` §5a×2, §6×2; `skills.md` §10; `roles/scrum-master/README.md`) | ✅ |
| Extração/relocação (pré-condição de R17 — teto de 3 quentes) | leitura do bloco `## v3.3` + addendum movido para `process-changelog-archive.md` linha a linha contra o texto removido de `process-changelog.md` | idêntico, 66 linhas de conteúdo (11–76 no arquivo); changelog vivo caiu a 2 entradas (v3.5, v3.4) antes de `v3.6` entrar | ✅ |
| Checagem semântica | contagem de `^\| R\d+ \|` no "Resumo em uma tela" | **22** — R1–R22, sem buraco nem duplicata | ✅ |

### Pendente do stakeholder
- **Roteamento aberto (fora do meu alcance nesta sessão):** `roles/product-owner/README.md:16,89`, `roles/product-owner/templates/functional-analysis.md:38,46` e `roles/architect/README.md:48` seguem com "até 3 opções e recomendação" / "com recomendação", sem citar R22 nem a via de pedir mais contexto. São do PO e do Arquiteto — roteados a eles no `/review` seguinte.
- **Fecho da entrega:** carrega a entrada `v3.6` — sai como `vX.6.0` (R18).
- **Reiniciar a sessão** — não é necessária: nenhum `agents/`/`commands/` mudou nesta entrada; R22 é normativo lido sob demanda, não carga fixa de agente.
- `note.md`: item único da fila **consumido**.

---

## v3.5 — Três reforços de coerência: o banner do README no gate de fechamento, a mensagem de bloqueio do `/review` e a avaliação de impacto de processo no `/team update` — 10/09/2026

**Instrução (Item 1):** *(stakeholder, via `/review note` — Item 1 de `note.md`)* "Depois de uma entrega (`v3.4.0`), o README continuou anunciando a versão anterior (`v3.3.0`) — só o `CHANGELOG.md` e o `plugin.json` tinham sido atualizados. Nenhuma rotina de revisão/QA confere se o número de versão anunciado no README bate com o do `CHANGELOG.md`/`plugin.json` antes de fechar a entrega."

**Instrução (Item 2):** *(stakeholder, via `/review note` — Item 2 de `note.md`)* aprovada e aplicada **no texto exato proposto pelo SM**: `/team update` passa a avaliar, antes de aplicar, se a entrada nova do changelog do processo desacorda de algo que os deliverables já escritos seguiram de outro jeito; decisão de ficar numa versão antiga vai para `.team-project/README.md` §7.

**Classificação:** regra (R18 ganha uma terceira checagem, no mesmo padrão que já aplica às outras duas) + fluxo (o ciclo de uma entrega de `workflow.md` §5d ganha um passo, a curadoria do SM em §5d/§8 ganha a mesma checagem, e `team-update.md` ganha um passo novo antes de aplicar a atualização, com renumeração dos passos seguintes).

### O que mudou

| Documento | Seção | Mudança |
|---|---|---|
| `process/working-rules.md` | R18, corpo | O trio de requisitos de uma entrega ganha o banner "Versão atual" do `README.md`; **evita** passa de dois para três modos de falha, nomeando o defeito de campo da `v3.4.0`; **SM verifica** ganha a igualdade `plugin.json` == topo do `CHANGELOG.md` == banner do `README.md` |
| | indicador de retrospectiva (R18) | A linha de violação ganha a condição "banner ≠ `plugin.json`/`CHANGELOG.md`", e a fonte ganha `README.md` |
| `process/workflow.md` | §5d, "Ciclo de uma entrega" | **Passo 5 novo** — atualizar o banner do `README.md` — inserido entre o bump de `version` (4) e a entrada do `CHANGELOG.md` (6, era 5); passo 7 (era 6) renumerado |
| | §5d, "O que o SM reconcilia" | Bullet novo: banner do `README.md` == `plugin.json` == topo do `CHANGELOG.md` |
| | §8, gate de entrega | A linha do gate de merge em `main` passa a nomear os três artefatos, não dois |
| `process/artifact-ownership.md` | matriz, linha `CHANGELOG.md` | A mesma igualdade de três pontas, para a linha ficar coerente com `workflow.md` §5d (reavaliação do conjunto — coerência interna) |
| `commands/review.md` | Pré-condição — só no clone do repositório-fonte | *(Item 3 de `note.md`, aplicado pelo stakeholder — `commands/` é domínio dele, não do SM, `review-contract.md`)* A mensagem de bloqueio (clone errado ou marcador ausente) perde a explicação de onde rodar `/review` e o que fazer; vira só *"Comando não permitido nesse contexto. Entre em contato com o fornecedor do plugin."* — texto mais curto que a proposta original do SM |
| `team-update.md` | **passo 6 novo** — "Avalie o impacto de mudança de processo sobre os deliverables já escritos" | *(Item 2, aplicado no texto exato do SM)* Entre "Compare (semver)" (5) e "Aplique" (era 6); cruza a entrada nova do changelog do processo contra `.team-project/**`/SDD/ADRs, avisa sem corrigir sozinho; decisão de ficar em versão antiga vai a `.team-project/README.md` §7. Renumerado: 6→7 "Aplique", 7→8 "Reconcilie", 8→9 "Feche" |
| `commands/team.md` · `process/workflow.md` §5d | ponteiro de contagem | `workflow.md:295` dizia "os oito passos" — **corrigido pelo SM (curadoria)** para "os nove passos"; `commands/team.md:22` já dizia "nove… passo 8", coerente |

### Por quê

R18 já obrigava `plugin.json` e `CHANGELOG.md` a baterem entre si no fechamento de uma entrega, e o SM verificava essa igualdade. O `README.md` carrega o mesmo número, no mesmo tipo de banner, e **não estava na lista** — nada no gate de fechamento olhava para ele. Na `v3.4.0`, só `plugin.json` e `CHANGELOG.md` foram tocados no fechamento; o README ficou anunciando `v3.3.0`, e nenhuma rotina pegou. A régua nova fecha o mesmo buraco que R18 já fechava para os outros dois, sem criar checagem nova de espécie — só estende a existente a um terceiro arquivo com o mesmo número.

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda para ele |
|---|---|
| **SM** | Ao fechar/verificar uma entrega, cruza três arquivos, não dois: `plugin.json`, `CHANGELOG.md` e o banner do `README.md` |
| **stakeholder** | O ciclo de uma entrega (§5d) ganha um passo explícito (5) entre o bump de `version` e a entrada do `CHANGELOG.md` |
| **quem opera `/review` fora do clone-fonte** | Recebe uma mensagem de bloqueio mais curta — sem indicação de onde rodar o comando nem do que fazer, só que não é permitido e para contatar o fornecedor do plugin |
| **quem roda `/team update`** | Ganha um passo a mais antes de "Aplique": conferir se a entrega desacorda de algo que o projeto já escreveu |

### Conflitos com o processo vigente

Para a checagem do banner (Item 1): nenhum. A checagem é aditiva — estende o mesmo padrão de igualdade que R18 já aplicava a `plugin.json`/`CHANGELOG.md` a um terceiro arquivo, sem alterar o que já existia nem introduzir uma regra nova de espécie diferente.

Para a mensagem curta em `commands/review.md` (Item 3): **ressalva, não bloqueio.** O SM havia proposto um texto mais longo, dizendo onde rodar `/review` e o que fazer; o stakeholder escolheu a frase curta acima, que não diz nenhuma das duas coisas. Não há, em `working-rules.md`/`workflow.md`, um padrão vigente de UX de erro que essa escolha contradiga — não é uma regra de trabalho do time, é o teor de uma mensagem num arquivo que é do stakeholder (`commands/`). Fica registrado como decisão editorial dele, no domínio dele, sem correção do SM.

Para o passo novo em `team-update.md` (Item 2): nenhum — só lê e avisa, não decide nem corrige sozinho; renumeração conferida em `commands/team.md` e `workflow.md` §5d.

### Como saberemos que funcionou

Zero ocorrências, nas próximas entregas, de `README.md` anunciando versão diferente de `plugin.json`/topo do `CHANGELOG.md` no fechamento. A `v3.4.0` é o defeito de campo que abriu esta entrada; a entrega que carrega esta mudança de processo (`vX.5.0`) é a primeira em que o SM confere as três pontas antes de considerar o fechamento válido.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição/extensão de padrão | `Select-String -Pattern 'Versão atual'` em `working-rules.md`, `workflow.md`, `artifact-ownership.md` | 7 ocorrências: 3 em `working-rules.md` (R18 corpo, "SM verifica", indicador), 3 em `workflow.md` (§5d passo 5, "O que o SM reconcilia", gate §8), 1 em `artifact-ownership.md` (matriz) — todas lidas no contexto, coerentes com o que está ao lado | ✅ |
| **Checagem semântica — o gate hoje** | leitura de `README.md` linha 3, `.claude-plugin/plugin.json` campo `version`, topo de `CHANGELOG.md` | `v3.4.0` nos três — a régua nova, aplicada ao estado atual do repositório, **passaria** | ✅ |
| Arquivamento (pré-condição de R17 — teto de 3 entradas quentes) | `Compare-Object` do bloco `## v3.2` movido para `process-changelog-archive.md` × `git show HEAD:` do original | **76 × 76 linhas, 0 diferenças** fora do separador; índice de arquivadas ganhou a linha `v3.2` | ✅ |
| Teto de leitura | `Select-String -Pattern '^## v'` no changelog quente, após a mudança | 3 entradas: v3.5, v3.4, v3.3 | ✅ |
| Checagem semântica — Item 3 aplicado | leitura de `commands/review.md`, seção "Pré-condição", linhas 22-24 | Texto confere com o aplicado pelo stakeholder: *"pare. Ao usuário, diga apenas: Comando não permitido nesse contexto. Entre em contato com o fornecedor do plugin."* — sem instrução de onde rodar `/review` nem do que fazer, ao contrário da proposta original do SM | ✅ |
| Checagem semântica + numeração — Item 2 | leitura de `team-update.md` linha a linha; contagem dos cabeçalhos `## N.` | Passo 6 idêntico à proposta do SM; **1–9 sem buraco nem duplicata** | ✅ |
| Substituição/extensão de padrão | `Select-String 'oito passos\|nove passos'` em `commands/team.md`, `workflow.md` | `commands/team.md:22` já "nove… passo 8"; `workflow.md:295` "oito"→"nove", corrigido nesta entrada | ✅ |

### Pendente do stakeholder

- **Fecho da entrega:** carrega a entrada `v3.5` do changelog do processo — sai como `vX.5.0` (R18).
- **Reiniciar a sessão** — passa a ser **necessária**: `commands/review.md` mudou nesta entrada (Item 3, aplicado pelo stakeholder). Mudança de comportamento de comando só entra em vigor depois de reiniciar (fecho do `/review`, `review.md` §4).
- **Item 2 de `note.md`** — **aplicado** pelo stakeholder em `team-update.md`, no texto exato proposto pelo SM, sem ressalva de conteúdo (ao contrário do Item 3). Sai de pendente.
- **Item 3 de `note.md`** — **aplicado** pelo stakeholder em `commands/review.md`, com texto mais curto do que a proposta original do SM. Ver a linha nova na tabela "O que mudou" e a ressalva em "Conflitos com o processo vigente".

---

## v3.4 — Substantivo homônimo em lista de proibição: a régua, as cinco correções e o fecho do `/review note` — 09/09/2026

**Instrução (1):** *(stakeholder, após triagem de `note.md` — Tasks 2, 3 e 4 fundidos)* "Escreva em `artifact-ownership.md` a nota de nomenclatura que fecha o círculo: quando um substantivo nomeia **dois artefatos de donos diferentes** (o caso `status`: executivo ao stakeholder = PO, documento de progresso = SM), toda menção em lista de proibição precisa **qualificar qual** e **nomear o dono** — porque proibição curta num papel cujo modo tem o mesmo nome derruba o modo. Cite o padrão que já funciona como forma a copiar. Deixe a nota utilizável como critério de verificação."

**Instrução (2), fecho do `/review note`:** curadoria das cinco correções · registrar `team-version.md` na matriz · corrigir a sobra da v3.3 no §5c, onde a mesma seção declara o `consult` extinto e sete linhas abaixo instrui a partir dele.

**Classificação:** propriedade de artefato (nomenclatura da fronteira entre artefatos homônimos; dono de guia de raiz) + escopo de papel (as cinco linhas de fronteira corrigidas) + obsolescência (§5c).

**Como esta mudança entrou — desvio de roteamento.** A triagem roteou as três fichas aos agentes donos (PO, QA e Arquiteto-pelo-dev); **os três caíram por limite de sessão e a sessão principal aplicou as três**, seguindo §1b, mais os dois cards autorizados pelo stakeholder. As fichas mudaram **sem passar pelo dono e sem entrada de changelog própria** — esta entrada as absorve, depois de o SM conferi-las por leitura. **Não vira precedente:** o atalho existiu porque o sintoma estava aberto em campo e a régua já estava escrita. Fica registrado porque quem ler o diff daqui a seis meses veria três papéis "concordando" com uma correção que nenhum deles escreveu.

**Curadoria:** as cinco linhas passaram nos três passos de §1b — qualificador **e** dono em 5/5, artefato próprio preservado na mesma linha em 3/5 (nos dois cards, em outra seção). Detalhe por arquivo no bloco de evidência. **O que a curadoria devolveu à régua:** o caso do QA mostrou que o substantivo cru é só metade do defeito — *"a especificação"* não diz se o vedado é **escrever** ou também **validar contra**, e validar contra é a frente 2 do papel. §1b ganhou o **verbo** como terceiro elemento da forma completa.

### O que mudou

| Documento | Seção | Mudança |
|---|---|---|
| `process/artifact-ownership.md` | **§1b nova** | *Substantivo homônimo — como se escreve uma proibição sem derrubar um modo.* Os 4 homônimos vivos (`status`, `especificação`, `protótipo`, `documentação`), a forma obrigatória (**qualificador + dono + verbo**, nunca o substantivo cru), por que a lista de proibição vence a linha que concede, e os **3 passos de verificação** do SM |
| | §3 · matriz | Conflito novo (*papel recusa o próprio modo citando "Não faz"*); a linha do documento de status passa a apontar o homônimo do PO e §1b; **`team-version.md` registrado** entre os guias de raiz, ao lado de `team-init`/`team-update`, que já estavam — dono stakeholder |
| 3 fichas + 2 cards | "Não faz" / "Proibido" | `status` (PO), `especificação` (QA) e `documentação` (dev) deixam de aparecer cruas, nas fichas e nos dois cards que carregam no subagente. **Aplicadas pela sessão principal, não pelos donos** — ver o desvio acima |
| `process/workflow.md` | §5c | **Sobra da v3.3 removida:** a seção declarava o `consult` extinto e, 7 linhas abaixo, instruía a partir dele com uma economia de "~38 KB" medida contra o broadcast que já não existe. A lição de R3 foi reancorada no **passo 1 do `/sm agreement`**, e ficou **sem número fechado** porque a tabela não sustenta o delta — ela soma `commands/` + `agents/`, e o `agreement` só acrescenta `agents/` |
| | §5c, custo | **Remedido:** `/sm` 13 → **15**, `/po` 10 → **13**, `/team cycle` 28 → **26**, `/review` 14 → **15**. Nota nova: os números somam `commands/` + `agents/`, e remedir é fase **Check** |

**Modo de falha que evita:** um papel recusar o modo que a própria ficha lhe dá, e devolver ao stakeholder um comando extinto. Em campo: `/po status` numa instalação v3.3.0 entregou a leitura de produto e **em seguida se desautorizou**, dizendo que status "é tipicamente papel do Scrum Master" e oferecendo um `/sm status` que a v3.3 havia removido. Instalação e contexto do projeto foram descartados como causa; era a palavra `status` **crua** na lista "Não faz" do PO, quatro linhas abaixo da que lhe dá "prazo, plano de entrega e status". A lista curta venceu a tabela, com o prior de Scrum empurrando junto.

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda para ele |
|---|---|
| **SM** | Passo de verificação novo na reavaliação do `/review`: cruzar "Não faz" × modos declarados, papel a papel, **por leitura** — `grep` não distingue uso qualificado de uso cru |
| **PO · QA · dev** | Nenhuma conduta muda **exceto deixar de recusar o próprio modo**: o PO responde `/po status` sem se desautorizar, o QA mantém a frente 2, o dev entrega relatório e GAP |
| **Arquiteto · stakeholder** | Herdam o roteamento do §7 do dev (abaixo), cada um no seu arquivo |

### Roteamentos abertos

`Documentação não é minha/sua` continua cru no **Contrato §7** do dev — `roles/developer/README.md:28` (dono: **Arquiteto**) e `agents/developer.md:32` (dono: **stakeholder**). Está **fora** da superfície que §1b verifica e a frase seguinte preserva a exceção (*"Minha entrega é código, testes e o relatório"*), mas ficou em forma inconsistente com a linha 15, agora qualificada. É conteúdo do papel, não coerência de referência: **o SM roteia, não reescreve**.

### Conflitos com o processo vigente

**A régua poderia virar R22** em `working-rules.md` — R1–R21 governam como o time trabalha **num projeto**, e esta governa como os normativos do plugin são redigidos. **Escalado e decidido pelo stakeholder:** fica em `artifact-ownership.md`; regra que não se verifica numa Task não entra na lista percorrida a cada Task fechada. Precedente de forma: §1a, que R17 já nomeia como o lugar da "nota de racional no próprio documento normativo que ela governa".

### Como saberemos que funcionou

Zero ocorrências, nas próximas três versões, de papel recusando modo próprio ou oferecendo comando extinto. Verificável já no `/review` seguinte: o cruzamento "Não faz" × modos fecha **limpo nos seis papéis** — na abertura eram 3 sujos (PO, QA, dev), no fecho são 6 limpos na superfície verificada, com 2 resíduos roteados fora dela. O teste real é o próximo `/po status` em campo: entrega a leitura e **para**.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento | `Compare-Object` bloco `## v3.1` × `git show HEAD:` | 55 linhas, **0 diferenças**; arquivo 1244 → 1301; índice ganhou `v3.1` | ✅ |
| Extração / criação | `git show HEAD:…/artifact-ownership.md` × disco | **112 → 145 linhas**; §1b em 57–87; conflito novo em §3 | ✅ ¹ |
| Checagem semântica | leitura dos 4 homônimos de §1b na origem | os 4 conferem: `status` · `especificação` · `protótipo` · `documentação` | ✅ |
| Forma a copiar | leitura da linha "Não faz" de `roles/scrum-master/README.md` | *"…nem status **ao stakeholder** — é do PO (§6a)"*: qualificador + dono | ✅ |
| Teto de leitura | `^## v` no changelog quente | 3 entradas — v3.4, v3.3, v3.2 | ✅ |
| Curadoria das 5 correções | leitura contra os 3 passos de §1b (**não `grep`**) | 5/5 qualificador + dono; 3/5 preservam o próprio na mesma linha; 1 defeito de **verbo** → virou régua em §1b | ✅ |
| Resíduo do defeito | leitura de `Documentação não é (minha\|sua)` | 2 cruas: `roles/developer/README.md:28`, `agents/developer.md:32` — fora da superfície de §1b | ✅ roteado |
| Obsolescência §5c | `consult` em `workflow.md` | 2 na seção: `:245` declara a remoção, `:252` cita a origem histórica. Nenhuma instrui no presente | ✅ |
| Substituição do número | `38 KB` em `process/*.md` | 1, nesta entrada, citando o número errado como defeito. Zero no normativo | ✅ |
| Remedição do custo | `.Length` de `agents/*` + `commands/*` | sm 15,1 · po 13,0 · ux 10,7 · arc 9,7 · qa 9,8 · dev 6,9 KB — `/sm` e `/po` errados | ✅ |
| Guia sem dono | `team-version` na matriz + `Test-Path` | linha 41, com `team-init`/`team-update` que **já estavam**; arquivo existe | ✅ |
| Links | `](*.md)` nos 5 arquivos tocados | 2 achados, ambos **falsos positivos** (notação em crase). Reais: **0** | ✅ |
| **R17 — teto da entrada** | contagem do bloco `## v3.4` | **13,7 KB na 1ª medição — acima da barreira de 10 KB.** Excedente movido (curadoria detalhada → evidência; análise da régua → §1b); remedido | ✅ ² |

¹ Desvio: escrevi "113 → 148" antes de contar; o real era 112 → 145. Contagem estimada não é evidência.
² A própria R17 reprovou esta entrada, duas vezes. O corte seguiu o critério dela: sai o raciocínio de uma vez, fica o registro permanente, e a análise que precisava sobreviver foi para §1b — o normativo que ela governa.

### Pendente do stakeholder

- **`agents/developer.md:32`** — o último `Documentação não é sua` cru, agora fora de forma com a ficha corrigida. Roteado acima.
- **`/team version`** (Task 1 de `note.md`) — reenquadrado por ele como **modo meta**, ao lado de `init` e `update`, e por isso sem colisão com a linha 10 de `commands/team.md`, que proíbe conversa. `commands/team.md` e `team-version.md` foram aplicados por ele; o que coube a mim foi **registrar o dono na matriz**, feito.
- **Reiniciar a sessão** — `agents/product-owner.md` e `agents/quality-assurance.md` mudaram, e comportamento de agente só entra em vigor depois.
- **Entrega:** esta versão de processo ainda não chegou a instalação nenhuma. `git commit` + `push` + `claude plugin marketplace update team` + `claude plugin update team@team` (R18). O sintoma de campo que abriu a v3.4 **continua vivo na instalação do cliente** até esse passo.


