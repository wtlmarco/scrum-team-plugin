# Changelog do Processo — Arquivo

> **Dono:** SM · Continuação de [`process-changelog.md`](process-changelog.md), que mantém as três entradas mais recentes.

Entradas anteriores, **íntegras e inalteradas**. Arquivar é relocar para tirar do caminho de leitura quente — nunca reescrever nem resumir. Mais recente no topo.

> **Nota de leitura (v3.0):** as entradas abaixo foram escritas quando a unidade de trabalho se chamava **item** e o plano do Arquiteto, **Plano de Execução**. A v3.0 renomeou os dois — item → **Task**, com a **História** acima dela como unidade de valor; Plano de Execução → **Plano de Implementação**, agora conteúdo da Task. O texto arquivado **não foi ajustado**, porque entrada de changelog não se reescreve (R17): leia "item" como "Task" e "Plano de Execução" como "Plano de Implementação".

---

## v3.24 — O sprint vira a unidade de aprovação e de entrega (R25): ③ em lote sobre pacote navegável, bloqueio em dois degraus, registro por sprint (5 papéis) — 20/09/2026

**Instrução do stakeholder** (fila `Abertas` de `note.md`, cinco itens fechados em oito rodadas de análise): *"um automode onde após o stakeholder aprovar o protótipo o time pode seguir o desenvolvimento até a sua conclusão sem necessitar dos gates de aprovação"*, com a exceção de escalar o problema em que *"a construção poderia falhar"*; mais os dois modos de trabalho no `how-to`, e o automode de manutenção pela fila `note.md` do produto.

**O desenho entregue não é o pedido literal, e o stakeholder decidiu assim.** Sumir do ① até o MVP reintroduzia os dois modos de falha mais caros do processo — R15 (aprovar por escrito o que só se vê construído) e R21 (somar aprovações técnicas e descobrir no fim que o valor não chegou) — com o dano multiplicado pelo número de sprints. A saída foi **agregar os gates na fronteira do sprint**, não removê-los: o ciclo de detecção de deriva volta a ser de **um** sprint. O termo "automode" não existe.

**Classificação:** regra de trabalho (**R25** nova, **R20** reescrita, **R21** restaurada) + etapa de fluxo (§2, §5e, §5g, §8) + propriedade de artefato (§1e nova, §1c) + formato de documento (9 modelos) + comportamento de comando (`commands/`, `agents/`, guias de raiz — aplicados com autorização nominal do stakeholder no fecho).

### O que mudou

| Documento | Mudança |
|---|---|
| `working-rules.md` | **R25 nova** — o sprint é a unidade de aprovação e de entrega: pacote navegável na abertura, execução contínua, bloqueio em dois degraus, registro por sprint. **R20 reescrita** — o ③ passa a ser aprovado **em lote, depois da Planning**; guarda-corpo deslocado para "nenhuma Task em construção antes do pacote". **R21 restaurada** ao original, com nota que separa *conduzir* (PO) de *decidir* (stakeholder). R25 entra na linha colapsada de verificação binária (v3.23), sem linha própria |
| `workflow.md` | **§5g nova** — o ciclo do sprint: pacote de 4 peças · execução contínua · bloqueio em 2 degraus · manutenção pela fila `note.md`. **§5e** — Planning de 6 → **11 passos** (valor real no 2, varredura de bloqueios no 3, pasta e `planning.md` no 9, pacote no 10, congelamento e índice no 11). §2, §2a, §3a/§3b, §4a-ii, §5, §5f, §6a, §6b e **§8 com 21 gates** (2 novos) |
| `artifact-ownership.md` | **§1e nova** — `sprints/<n>/` com **dono por subpasta** (SM o contêiner · `stories/` PO · `plan/` Arquiteto · `evidence/` QA). **§1c** — um padrão de retenção só: o par vivo+archive do consumo deixa de existir, e a pendência que a v3.19 devolveu ao stakeholder fica **resolvida**. Linhas novas: protótipo do sprint, `architect/spikes/` (existia desde a v3.9 **sem linha de matriz**), `quality-assurance/baseline.md` |
| Modelos do SM | `sprint-backlog.md` (vive e **fecha** na pasta — `sprint-backlog-snapshot.md` deixa de existir; relaciona História ↔ Task ↔ plano ↔ evidência), `sprint-review.md` (veredito do stakeholder por História), `retrospective.md` (consumo em seção própria + **sintomas para o `note.md` do plugin**), `project-context.md`, `burndown.md`. **Novos:** `planning.md`, `consumption.md`. **Removido:** `consumption-log.md` |
| Os quatro papéis roteados | **PO** — detalha sem ③ prévio, **congela** a cópia em `stories/`, alimenta o `planning.md`. **Arquiteto** — planos em `plan/`; **Task retomada tem plano reescrito** (`Retomada de:`); spike fora da pasta. **QA** — evidência por Task; **baseline separada**, porque roda antes do sprint 1. **UX** — entregável novo, o **protótipo costurado do sprint**, com régua própria de verificação leve. Caminho, dono e regra de cada um: matriz §1e |
| `commands/`, `agents/`, guias de raiz | `cycle sprint` e `prototype sprint <n>` novos; `team-init.md` deixa de semear a estrutura antiga e declara **o que não cria**; `team-update.md` ganha o **passo 7a** de migração estrutural com a classe "histórico imutável"; `how-to.md` ganha a seção do ciclo do sprint **e a estrutura de `.team-project/`** (é a cópia que o cliente recebe); 31 ponteiros corrigidos. **`prototype <tela>` → `prototype screen <tela>`** — os três sentidos passam a se distinguir por palavra reservada, não por nome livre |

### O modo de falha que isto evita

Dois opostos: o time parar a cada História para pedir aprovação, pagando latência em trabalho que deriva de um SDD já aprovado; e o stakeholder sumir até o fim, descobrindo a deriva quando o retrabalho já é código de N sprints. O pacote navegável resolve os dois — e prova, de quebra, que o sprint entrega fatia usável: protótipo que não atravessa um fluxo ponta a ponta denuncia o corte errado **antes** de o sprint arrancar.

### Conflitos

| O que conflitou | Com | Resolução |
|---|---|---|
| ③ em lote × R20 ("aprovado antes da Planning") e §8 ("gates não negociáveis") | R20 · §8 | Stakeholder decidiu: agregar, não remover. R20 reescrita; §8 mantém os 21 gates, o ③ muda de **momento e granularidade**, não de dono |
| ④ sem o stakeholder (desenho inicial) × R21 | R21 | Descartado. O ④ sempre foi dele — `sprint-review.md` já dizia "Decide: o stakeholder". R21 **restaurada**, não emendada |
| `§1d` do ciclo do sprint × `§1d` da v3.21 (Product Backlog índice) | v3.21 | A da v3.21 já estava publicada e mantém `§1d`; a do sprint vira **`§1e`**, e 21 ponteiros foram reclassificados um a um |
| `stories/` do sprint × `stories/` do PO (v3.21) | v3.21 | Convivem com papéis distintos: `product-owner/stories/` é a **fonte viva**; `sprints/<n>/stories/` é a **cópia congelada** do que foi aprovado. Mesmo ID, objetos diferentes |
| Bloco "Registro de consumo" e tabela "Como o SM aplica" | v3.22 · v3.23 | A base desta entrega era `develop` em v3.19 — quatro entregas atrás. Resolvido tomando a versão **enxugada** dos dois giros Act e reaplicando só a mudança semântica: **nenhum corte das v3.22/v3.23 foi revertido** |

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda |
|---|---|
| **stakeholder** | Deixa de aprovar História por História antes da Planning. Passa a **navegar e aprovar o pacote** na abertura e **decidir por História** na Review, e recebe no pacote o que **não** entrou, com o motivo. Fora disso só é acionado pelo degrau 2 — e por decisão estratégica, que vem direto |
| **SM** | Planning de 11 passos; varre bloqueios, confere fatia vertical, cria a pasta com as subpastas, escreve `planning.md`, **segura a construção** até a aprovação, congela, abre o burndown no dia 0 e mantém o índice do sprint corrente. Registra o **degrau** de cada bloqueio. Fecha o Sprint Backlog **sem snapshot** |
| **PO** e **Arquiteto** | São o **degrau 1**: conversam antes de qualquer bloqueio subir ao stakeholder |
| **UX** | Entra na Planning com um entregável que **bloqueia o arranque do sprint** |
| **QA** · **dev** | Caminhos novos; nenhum critério de veredito nem prática de construção muda |

### Como saberemos que funcionou

Primeira Planning sob R25 fecha com `planning.md` completo e data de aprovação no Sprint Backlog, e nenhuma Task em 🟨 antes dela. Primeiro sprint sem acionar o stakeholder fora dos dois pontos, com todo bloqueio trazendo o degrau nomeado. Primeira Review com a coluna Decisão preenchida por ele. **Fracasso:** pacote aprovado sem protótipo navegado, ou bloqueio escalado sem o degrau 1 registrado.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | vocabulário extinto (`automode`, `aceite único do MVP`, `fronteira do MVP`) **e** caminhos antigos (`scrum-master/sprints`, `architect/plans`, `scrum-master/sprint-backlog`, `quality-assurance/evidence.md`, `consumption-log`), em todos os `.md`/`.json` da RAIZ | **0** no processo vigente; sobrevivem só a tabela "de → para" do passo 7a de `team-update.md` e as declarações de que cada padrão foi extinto — todas lidas no contexto | ✅ |
| Auditoria de fecho | varredura de coerência do conjunto (órfão · modo morto · regra sem verificação · etapa sem comando · nome ambíguo) | **0** em todas; **4 gaps corrigidos** — ponteiro `/ux prototype` da etapa 3b resolvia para o artefato do ①; `/qa bug` fora do `how-to`; o comando com que o PO aciona a QA não era nomeado; `/qa audit` × `/review audit` sem desambiguação | ✅ |
| Substituição de padrão | `§1d` × `§1e` em todo o repositório, lidas **uma a uma** no contexto | 21 reclassificadas para `§1e` (pasta do sprint); 7 mantidas em `§1d` (Product Backlog, v3.21) | ✅ |
| Contagem | `^### R\d+\.` · `^\| R\d+ \|` · card do SM | **25 · 25 · 25** | ✅ |
| Contagem | linhas de gate da tabela do §8 | **21** (eram 19; 2 novos: `planning.md` e degrau 1) | ✅ |
| Extração/remoção | `wc -l` antes/depois | `planning.md` 0→54 · `consumption.md` 0→31 · `sprint-prototype.md` 0→97 · `consumption-log.md` 26→0 · `sprint-backlog-snapshot.md` deixa de existir | ✅ |
| Arquivamento | `v3.21` relocada para `process-changelog-archive.md` (teto de 3 entradas, R17) | 83 linhas movidas íntegras; vivo 326→240 linhas | ✅ |
| Links | validador de links `.md` relativos em toda a RAIZ | **0 quebrados** (1 falso positivo conhecido: `project-context.md → how-to.md`, que resolve no `.team-project/` gerado) | ✅ |
| Encoding | `U+FFFD` em todos os `.md`/`.json` | **0** (148 reparados em `usability-review.md` pelo UX) | ✅ |
| Tríade R18 | `plugin.json` × banner do `README.md` × topo do `CHANGELOG.md` | `3.24.0` nos três | ✅ |

**Desvio declarado (R19).** Aplicado sobre `develop` em **v3.19** sem conferir `git branch -a` — havia quatro entregas não mescladas. Detectado pelo stakeholder antes do PR e corrigido por rebase sobre `origin/develop`, com 31 blocos de conflito resolvidos um a um; os dois giros Act (v3.22, v3.23) foram preservados integralmente. **Lição de método:** `/review` que abre branch confere as branches remotas antes, não só `develop` local.

**Pendente do stakeholder:** nenhum. As quatro propostas (`commands/team.md`, `commands/sm.md`, `how-to.md`, `team-update.md`) e os 31 ponteiros foram autorizados nominalmente e aplicados no fecho.

> **Addendum — 20/09/2026 (R17).** Esta entrada foi registrada com **10.453 B**, acima da barreira de 10.240 B da R17; o estouro passou sem ser medido no fecho da v3.24. O texto **não foi reescrito**, porque a R17 é explícita: correção de entrada antiga é addendum datado, nunca reescrita — o invariante do changelog vale inclusive contra a própria R17.
>
> **Por que o excedente não foi movido.** A R17 manda "mover o excedente" antes de registrar, presumindo que o excedente seja deliberação — derivação de conflito, reavaliação do conjunto, exemplo trabalhado. Medida seção a seção, esta entrada **não tem deliberação para mover**: os 10.453 B são só campos obrigatórios (O que mudou 2.930 B · modo de falha 444 B · Conflitos 1.232 B · quem é cobrado 982 B · indicador 407 B · Evidência R19 2.778 B, mais o preâmbulo de instrução e classificação). Foi uma rodada que moveu **cinco papéis** de uma vez (R25), e cinco papéis produzem mais registro de decisão do que a barreira comporta.
>
> **O que isso expõe na R17, e fica em aberto.** A barreira é um número fixo por entrada, mas o volume legítimo de registro cresce com o número de papéis que a rodada move. Nas rodadas de um ou dois papéis ela funciona (v3.25 fechou em 9,4 KB com dois papéis e quatro itens); numa de cinco, ela obriga a escolher entre estourar e apagar decisão — e apagar decisão é pior. **Não foi resolvido nesta rodada:** mudar a barreira é alterar a R17, e a decisão é do stakeholder. Enquanto não for decidido, vale a R17 como está.

---

## v3.23 — Segundo giro Act: a tabela de indicadores parava de dizer algo novo em 13 das 23 linhas (SM) — 18/09/2026

**Instrução:** *(stakeholder)* "Vale um olho nisso no próximo giro, refaça o giro encontrando como melhorar novamente" — segundo `/review metrics` consecutivo, pedido depois de ler o saldo do primeiro.

**Classificação:** formato de documento — remoção por redundância no normativo do SM. Nenhuma regra nova, nenhuma regra alterada; a contagem segue em **24**.

### Onde procurei, e por que não foi na carga fixa

O primeiro lugar da lista de §5c é a carga fixa. Varri `agents/` + `commands/` procurando linha idêntica em 3 ou mais arquivos e sobraram **duas**, ambas legítimas de duplicar (cada arquivo é lido isolado, sem o outro):

| Bloco | Arquivos | Peso |
|---|---:|---:|
| Ponteiro do `review-contract.md` | 5 `agents/*` | 2,06 KB |
| Gancho do formulário de R22 (v3.20) | 4 `commands/*` | 1,57 KB |

A duplicação barata já tinha saído na v3.22. Como corte na carga fixa é **proposta, não aplicação** (§5c), as duas ficam como pendência abaixo, e o giro foi procurar no conjunto sob demanda — onde está o maior volume do time: `roles/scrum-master/` com 198,6 KB, 3,7× o segundo colocado.

### O achado

`working-rules.md` (40,2 KB, o segundo maior arquivo do SM) dizia a **mesma verificação duas vezes**. Cada regra já traz a própria linha `**SM verifica:**`, nomeando o artefato a conferir. A tabela "Como o SM aplica", da retrospectiva, repetia essa verificação regra a regra — e em **13 das 23 linhas** a coluna "Alerta" era tautológica: *"qualquer ocorrência → Rnn ignorada"*, que não é limiar, é a definição de violar a regra.

As outras 10 linhas **ganham** o lugar: têm limiar de verdade (`> 2 → plano raso`, `> 30%`, `> 2×`, `recorrente`, `> 25% dois sprints seguidos`), que é o que transforma uma medida contínua em sinal — exatamente o que uma tabela de retrospectiva deve fazer.

### O que mudou

| Arquivo | Onde | O quê |
|---|---|---|
| `working-rules.md` | "Como o SM aplica", 13 linhas | **Colapsadas numa só**, que nomeia as regras cobertas (R13·R14·R15·R16·R18·R19·R20·R21·R22·R23·R24) e aponta para a linha "SM verifica" de cada uma como fonte |
| | as outras 10 linhas | **Intocadas** — têm limiar próprio |

**Verificado antes de cortar, uma a uma:** cada uma das 13 linhas está integralmente coberta pela linha "SM verifica" da sua regra — inclusive a cláusula que a v3.21 acabara de acrescentar a R20 (índice do Product Backlog que volta a carregar conteúdo de História). Nenhuma verificação foi perdida; o que saiu foi a segunda cópia dela.

### Quem passa a ser cobrado de forma diferente

Ninguém. A varredura da retrospectiva continua cobrindo as 24 regras — agora numa linha que manda ler a verificação onde ela é escrita, em vez de repeti-la.

### Como saberemos que funcionou

| Medida | Antes | Depois | Δ |
|---|---:|---:|---:|
| `working-rules.md` | 40,20 KB | **37,74 KB** | **−2,46 KB (−6,1%)** |
| Tabela "Como o SM aplica" | 5,90 KB | **3,31 KB** | −2,59 KB (−44%) |
| Linhas de indicador | 23 | **12** | −11 |
| `roles/scrum-master/` (sem changelogs) | 198,6 KB | **196,1 KB** | −2,5 KB |

Indicador de que não quebrou: o `grep` de `^### R\d+\.`, de `^\| R\d+ \|` e de `^\*\*SM verifica` continua dando **24, 24, 24**. O corte deste giro é **4,6× o do anterior** (−2,46 contra −0,54 KB), e veio de procurar redundância estrutural em vez de texto obsoleto.

### Conflitos com o processo vigente

Nenhum. §5c manda que todo giro considere remover, e nomeia "seção que repete outra" como candidata de primeira linha.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Busca de duplicação | linhas >80 chars de `agents/`+`commands/` agrupadas por conteúdo idêntico, filtradas por ocorrência em 3+ arquivos | 2 blocos (2,06 e 1,57 KB), ambos legítimos — viraram proposta, não corte | ✅ |
| Cobertura antes de cortar | linha `**SM verifica:**` de R13·R14·R15·R16·R18·R19·R20·R21·R22·R23·R24, lida integralmente | as 11 presentes e completas; R20 inclui a cláusula da v3.21 | ✅ |
| Extração/remoção | `(Get-Item working-rules.md).Length` e recorte da seção, antes/depois | 40,20 → 37,74 KB; seção 5,90 → 3,31 KB; 241 → 229 linhas | ✅ |
| Integridade estrutural | `^### R\d+\.` · `^\| R\d+ \|` · `^\*\*SM verifica` | **24 · 24 · 24** — nenhuma regra, linha de resumo ou verificação perdida | ✅ |
| Encoding | primeiros 3 bytes de todo `.md` de `process/`, `commands/`, `agents/` | zero BOM — ver desvio abaixo | ✅ |

**Desvio corrigido no fecho (R19).** As edições por script deste giro e do anterior usaram `Set-Content -Encoding utf8`, que no Windows PowerShell 5.1 **grava BOM**. Três arquivos (`working-rules.md`, `process-changelog.md`, `process-changelog-archive.md`) ficaram com BOM enquanto os outros 16 de `process/`+`commands/`+`agents/` não tinham nenhum. Removido no fecho, conteúdo conferido intacto depois. **Lição para o próximo giro:** cirurgia de linha em arquivo do repositório usa `UTF8Encoding($false)`, nunca `Set-Content -Encoding utf8`.

### Pendente do stakeholder

Os dois blocos de duplicação da carga fixa, que §5c manda propor e não aplicar. **Nenhum é corte óbvio** — em ambos os casos cada arquivo é lido isolado, então "duplicação" aqui não é desperdício no mesmo contexto, e sim texto repetido que cresce junto quando muda:

1. **Ponteiro do `review-contract.md`** — 421 chars × 5 `agents/*.md`. Só é lido quando o `/review` aciona aquele papel; nas outras invocações é carga morta. Comprimível para ~150 chars sem perder a instrução.
2. **Gancho do formulário de R22** — 403 chars × 4 `commands/*.md`, acrescentado na v3.20 desta mesma rodada. Comprimível para ~180 chars.

Juntos, ~1,3 KB de carga fixa. Decisão tua, item a item, como na v3.22.

---

## v3.22 — Giro Act do ciclo de eficiência: footprint remedido e a arqueologia do `consult` sai de §5c (SM) — 18/09/2026

**Instrução:** *(stakeholder)* `/review metrics` — giro completo do ciclo de eficiência (`workflow.md` §5c), com **uma** mudança.

**Classificação:** regra de trabalho / formato de documento — remoção por excesso e obsolescência no normativo do SM. Nenhuma regra nova; a contagem segue em **24**.

### Footprint remedido — 18/09/2026

**Carga fixa** (`agents/<papel>.md` + `commands/<papel>.md`, paga em toda invocação), contra a remedição anterior da v3.16 (14/09/2026):

| Papel | v3.4 | v3.16 | v3.22 | Δ desde v3.16 |
|---|---:|---:|---:|---:|
| Product Owner | 13,0 | 16,7 | **17,7** | +6,0% |
| Scrum Master | — | 15,4 | **16,4** | +6,5% |
| UX | — | 11,2 | **11,8** | +5,4% |
| QA | — | 11,1 | **11,7** | +5,4% |
| Arquiteto | — | 10,4 | **11,4** | +9,6% |
| dev | — | 7,1 | **7,7** | +8,5% |
| **Total do grupo** | **66,0** | **71,9** | **76,7** | **+6,7%** |

**Conjunto sob demanda** (`roles/<papel>/`, sem os changelogs) — primeira medição por papel; vira a linha de base:

| Papel | KB |
|---|---:|
| Scrum Master | 198,3 |
| Product Owner | 54,2 |
| UX | 47,1 |
| Arquiteto | 44,1 |
| QA | 39,1 |
| dev | 22,0 |

### Por quê

O gatilho de Act fora de cadência de §5c disparou: **o footprint total cresceu dois giros seguidos sem nenhuma remoção registrada**. Em quatro dias e cinco versões de processo (v3.17→v3.21), a carga fixa subiu **+6,7%** e nenhum papel registrou corte. Nenhum papel isolado cruzou o limiar de 20%, então o gatilho que valeu foi o do crescimento sem remoção — o menos visível dos três, e o que mede exatamente o modo de falha que §5c existe para conter.

A remoção escolhida é a mais defensável por evidência: **§5c era a maior seção de `workflow.md`** (9,2 KB de 59,4 — 15,5% do arquivo), e carregava **três parágrafos de arqueologia do modo `consult`**, um comando que não existe mais em lugar nenhum do repositório (`grep` de `\bconsult\b` em `roles/`, `commands/`, `agents/`: zero). A seção que existe para impedir inchaço era a mais inchada do documento, e parte do peso era história de um comando extinto.

### O que mudou

| Arquivo | Onde | O quê |
|---|---|---|
| `workflow.md` | §5c, parágrafo "Não existe mais broadcast dos seis" | Reescrito como **regra viva** ("Chame só quem a questão toca"), absorvendo o ganho nos dois eixos que o parágrafo separado de "A lição de R3" explicava |
| `workflow.md` | §5c, parágrafo "A lição de R3 sobreviveu ao comando que a originou" | **Removido** — narrava a migração do passo 1 do `consult` extinto para o `/sm agreement`; o que governa hoje ficou no parágrafo acima |
| `workflow.md` | §5c, parágrafo "Sem número fechado, de propósito" | **Comprimido** de 5 linhas para 2, preservando a única norma que ele carregava: a tabela sustenta ordem de grandeza, não delta exato |
| `workflow.md` | §5c, item 3 de "Três coisas que a carga fixa não mostra" | "No broadcast, **as seis saídas** retornam" → cada saída de subagente retorna, uma por papel disparado — o broadcast dos seis não existe mais |

**O que foi preservado de propósito:** a definição dos dois números, a tabela de custo por comando, o comando de remedição, os gatilhos e o bloco de pegada estática × consumo real. Nada normativo saiu.

### Quem passa a ser cobrado de forma diferente

Ninguém. É remoção de texto morto: nenhuma regra, gate ou verificação mudou. O SM ganha um §5c 6% menor para ler a cada giro.

### Como saberemos que funcionou

**Saldo final do giro inteiro** (as três mudanças somadas, medido no fecho):

| Medida | Início do giro | Fecho | Δ |
|---|---:|---:|---:|
| Carga fixa do grupo | 76,7 KB | **75,3 KB** | **−1,4 KB** |
| `workflow.md` §5c | 9,20 KB | **9,00 KB** | −0,20 KB |
| `workflow.md` | 59,4 KB | **59,25 KB** | −0,15 KB |
| `roles/scrum-master/` (sem changelogs) | 198,8 KB | **198,6 KB** | −0,2 KB |

**O corte em §5c foi quase anulado pela própria mudança que o giro produziu.** A remoção da arqueologia do `consult` tirou 0,54 KB; o parágrafo novo que fechou a contradição de propriedade devolveu 0,86 KB, e §5c chegou a ficar **maior** que no início (9,52 KB) — a seção que existe para impedir inchaço, inchada pelo giro que a governa. Corrigido no fecho: o parágrafo foi comprimido de 0,86 para 0,34 KB, movendo o racional para esta entrada (R17 — a análise vive no changelog, a norma no normativo), e §5c fechou em 9,00. Fica registrado porque é o modo de falha que §5c nomeia, acontecendo dentro dela.

O indicador do próximo giro é que a linha "Total do grupo" pare de subir sem remoção — hoje ela subiu 6,7% com zero cortes registrados, e este giro devolveu 1,4 KB.

### Conflitos com o processo vigente

Nenhum. §5c manda que todo giro considere remover; esta entrada é o giro cumprindo a própria regra.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento (teto de 3) | bloco `## v3.19` capturado antes da remoção (57 linhas) × relocado em `process-changelog-archive.md:11-70` | 60 linhas = 57 do bloco + linha em branco + `---` + linha em branco; zero linhas de conteúdo fora do separador. `## v3.19` no vivo: 0 ocorrências | ✅ |
| Extração/remoção | `(Get-Item workflow.md).Length` e recorte de §5c, antes/depois | §5c 9,20 → 8,66 KB após a remoção isolada; **9,00 KB no fecho**, depois do parágrafo novo da terceira mudança e da compressão dele. Arquivo: 59,4 → 59,25 KB | ✅ |
| Substituição de padrão | `Select-String "\bconsult\b"` em `roles/**/*.md`, `commands/*.md`, `agents/*.md` | **0** ocorrências antes e depois — o termo já estava extinto no código; o que saiu foi a narrativa sobre ele | ✅ |
| Medição de footprint | `Get-ChildItem agents,commands -File | Select Name,Length`, somado por papel; `roles/<papel>/` recursivo excluindo `process-changelog*` | tabelas acima | ✅ |

### Segunda remoção — autorizada pelo stakeholder, em `commands/` (addendum do mesmo giro, 18/09/2026)

O stakeholder autorizou, no formulário de fecho, comprimir o parágrafo **"Registro de consumo"**, duplicado quase palavra por palavra nos **7 arquivos** de `commands/`. Aplicado nos sete: a instrução inteira foi preservada (quando gravar, quais campos, R7 para número indisponível, o no-op quando o arquivo não existe, e em `team.md` a linha por subagente mais os três modos que não disparam agente); saiu a explicação repetida.

| Medida | Antes | Depois | Δ |
|---|---:|---:|---:|
| Parágrafo, por arquivo | ~516 chars | ~316 chars | −39% |
| Carga fixa por papel | PO 17,7 · SM 16,4 · UX 11,8 · QA 11,7 · Arq 11,4 · dev 7,7 | 17,4 · 16,1 · 11,6 · 11,5 · 11,2 · 7,5 | −0,2 a −0,3 KB |
| **Total do grupo** | **76,7 KB** | **75,3 KB** | **−1,4 KB (−1,8%)** |

**Desvio de medição registrado (R19).** A proposta levada ao stakeholder dizia "~1,1 KB por arquivo, 6–10% da carga fixa, −70%". **Estava errada, e por um erro de método:** o recorte automático do bloco ia do título `## Registro de consumo` até o **fim do arquivo** — como é a última seção de cada comando, arrastava junto o gancho de R22 (v3.20) e a linha de fecho. O parágrafo de consumo sozinho era ~0,5 KB, não ~1,1 KB. O ganho real é **−1,4 KB no grupo (−1,8%)**, não os ~5 KB projetados. A decisão do stakeholder não muda com o número certo — é remoção de duplicação literal, sem perda normativa —, mas o número que a sustentou estava inflado em ~2×, e fica registrado. **Lição para o próximo giro:** recorte de seção por "até o próximo `##`" mede errado na última seção do arquivo; medir o parágrafo, não o resto do arquivo.

### Terceira mudança — a contradição de §5c fechada por decisão do stakeholder (18/09/2026)

**A tensão:** §5c mandava cortar prioritariamente na carga fixa (`agents/` + `commands/`), e esses são justamente os dois grupos que o `/review` não edita. O normativo apontava para um lugar que o comando não alcança.

**Escalado ao stakeholder com três saídas** — estender a exceção de curadoria do SM para cobrir remoção de duplicação literal; manter como está, com autorização caso a caso; ou tirar a carga fixa do ciclo. **Decisão: manter como está**, tornando-o explícito no texto.

| Arquivo | Onde | O quê |
|---|---|---|
| `workflow.md` | §5c, após "Onde o corte rende mais" | Parágrafo novo: **"O corte de maior valor é proposta, nunca aplicação direta."** Os dois primeiros lugares da lista são do stakeholder; o Act mede, encontra e propõe com texto pronto, e ele autoriza item a item no fecho. A exceção de curadoria do SM **não** cobre remoção nesses arquivos — só coerência de referência cruzada. Só o item (3), o conjunto sob demanda, o `/review` aplica sozinho |

**Nenhum poder foi alargado.** A mudança é de redação: o que já era prática (e foi o que aconteceu neste giro) passa a estar escrito, e a contradição entre "corte aqui" e "não edite aqui" desaparece. O racional ficou no próprio §5c, com o caso da v3.22 como evidência: a projeção de −5 KB que virou −1,4 KB real só não virou edição às cegas porque passou pelo stakeholder.

**Como saberemos que funcionou:** nenhum giro futuro aplica corte em `agents/`/`commands/` sem autorização registrada no fecho, e nenhum giro volta a escalar esta mesma pergunta como se estivesse aberta.

## v3.21 — Product Backlog deixa de conter a História: índice com ponteiro, conteúdo em arquivo próprio do PO (SM, parte normativa) — 18/09/2026

**Instrução:** *(stakeholder, via `/review note`, item 2)* "As histórias que o po desenvolve devem ficar em outro arquivo que não o ProductBacklog pois está ficando um arquivo muito grande."

**Classificação:** propriedade de artefato + formato de documento. O item se divide em duas Tasks: esta (normativa — matriz de propriedade e R20, SM) e uma seguinte, do PO, sobre os próprios modelos (`product-backlog.md`, `user-story.md`, `README.md`, `skills.md`).

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `artifact-ownership.md` | matriz §1, linhas "Histórias" e "Product Backlog" | Histórias passam a `.team-project/product-owner/stories/`, um arquivo por História (`<H-ID>-<slug>.md`); o Product Backlog é redefinido como **índice ordenado**, não o conteúdo |
| `artifact-ownership.md` | **§1d nova** | Critério explícito: o que fica no Product Backlog (índice, régua, plano de entrega, requisitos em elaboração, ressalvas, decisões pendentes, fora de escopo) × o que sai (só o conteúdo por História — regras, protótipos, critérios de aceite, portão ③); e a forma de verificação |
| `artifact-ownership.md` | §4 Convenções | Linha nova: nome de arquivo de História, `<H-ID>-<slug>.md`, mesmo padrão dos Planos de Implementação |
| `working-rules.md` | R20 — corpo | "A História vive no Product Backlog" → vive em arquivo próprio, indexada pelo Product Backlog |
| `working-rules.md` | R20 — "SM verifica" | Ganha a forma de verificar que o índice não voltou a inchar com conteúdo de História |
| `working-rules.md` | tabela de indicadores da retrospectiva, duas linhas de R20 | Coluna "Fonte" corrigida para "arquivo da História" onde antes dizia "Product Backlog"; a segunda linha passa a cobrir também a recaída (conteúdo de volta ao índice) |
| `workflow.md` | §1 (tabela "Duas unidades" + frase), §2 (diagrama), §2a (etapa 1) | Coerência: "Vive em" da História, a frase "conjunto das Histórias = Product Backlog", o diagrama e a saída da etapa 1 — todos ajustados à nova estrutura (achado na reavaliação do conjunto, não pedido pelo item) |
| `deliverables/README.md` | linha sobre "Depois do portão ②..." | Mesma coerência — a História vive em arquivo, o Backlog é índice |
| `deliverables/team-project/README.md` | manifesto (linha `product-backlog.md`, linha nova `stories/`) + nota "Histórias:" | Manifesto ganha linha para a pasta nova; nota final perde a opcionalidade ("à escolha do projeto") |
| `roles/scrum-master/templates/project-context.md` | linha `product-owner/product-backlog.md` + linha nova `product-owner/stories/` | Mesma coerência no modelo que gera o `.team-project/README.md` §4 |

### Por quê
O Product Backlog crescia sem limite porque acumulava o **texto de cada História**, não só a lista delas — o mesmo modo de falha que R17 já corrigiu no changelog do processo (v1.0→v1.8, 12× em nove versões), agora no artefato do PO. `user-story.md` já previa a extração como opção ("no arquivo da História ou em seção própria deste documento — a escolha é do projeto"); esta entrada fecha a opção, não inventa a estrutura.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| PO | escreve cada História em arquivo próprio, sempre — deixa de valer a opção "seção do backlog"; mantém os dois documentos (índice e arquivo), ambos seus |
| SM | ao verificar R20, confere também que a tabela de Histórias do Product Backlog não carrega conteúdo — só índice com ponteiro |
| Demais papéis | nenhuma — leem a História onde sempre leram (o PO aponta o caminho) |
| stakeholder | recebe a Task seguinte (PO) para aplicar nos próprios modelos, e duas propostas de texto pronto para `commands/po.md` (abaixo) |

### Conflitos com o processo vigente
Um, já analisado antes de aplicar (não é conflito de intenção): parecia contradizer R20 ("A História vive no Product Backlog") e a linha da matriz ("Product Backlog = o conjunto das Histórias"), mas R20 fixa **propriedade e locus lógico** (a História é do PO, em contraste com a Task, do SM) — não layout físico de arquivo; e `user-story.md:22` já previa a extração como opção do projeto, então a instrução remove a opcionalidade, não inverte a regra. Resolvido sem escalar ao stakeholder, registrado em uma linha na §1d nova.

### Como saberemos que funcionou
A próxima História escrita (`/po story <ID>`) nasce em `.team-project/product-owner/stories/<H-ID>-<slug>.md`, e o Product Backlog ganha só a linha de índice com o link. Nenhuma seção "Regras funcionais"/"Protótipos"/"Critérios de aceite"/"Aprovação — portão ③" aparece dentro do Product Backlog a partir de agora.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento (teto de 3, `process-changelog.md:10`) | `git show HEAD` não serve de baseline aqui — o HEAD do repositório está muitas versões atrás do estado da sessão (drift pré-existente, não desta Task); verificação feita por leitura direta: bloco `## v3.18` capturado por `Read` antes da remoção (52 linhas de conteúdo) × bloco relocado em `process-changelog-archive.md:11-62` (52 linhas), conferido título a título e linha de tabela a linha de tabela | 0 diferenças de conteúdo — só o separador `---` que a archive acrescenta depois, fora das 52 linhas contadas | ✅ |
| Substituição de padrão | `Select-String -Path artifact-ownership.md,working-rules.md,workflow.md,deliverables\README.md,deliverables\team-project\README.md,templates\project-context.md -Pattern "A História vive no Product Backlog","conjunto das Históri","à escolha do projeto"` | 0 ocorrências nos seis arquivos do meu alcance | ✅ |
| Substituição de padrão | mesmos seis arquivos, `-Pattern "stories/","§1d"` | 14 ocorrências — `artifact-ownership.md:12,24,109,124,179`; `working-rules.md:139,142,194`; `workflow.md:9,12`; `deliverables/README.md:83`; `deliverables/team-project/README.md:24,34`; `project-context.md:31` — cada uma lida no contexto: todas coerentes com a estrutura nova (matriz, §1d, R20, indicadores, workflow, os dois READMEs de entregável, o modelo de contexto) | ✅ |
| Extração/remoção | linhas de `artifact-ownership.md` antes/depois (`(Get-Content ...).Count`) | 164 → 183 linhas (nova §1d + linha de §4) | ✅ — o crescimento é a regra nova, não inchaço; §1d é a mesma forma de §1c |
| Fronteira não ultrapassada | `git status --porcelain` + `git diff HEAD` por arquivo | 11 arquivos modificados no total; 8 são desta entrada (os de "O que mudou" + `process-changelog*.md`); os outros 3 (`note.md`, `roles/scrum-master/README.md`, `roles/scrum-master/skills.md`) são resíduo não commitado da v3.20 anterior, confirmado por `git diff` (conteúdo de R22, não desta instrução). Nenhum `roles/product-owner/`, `commands/`, `agents/` tocado por mim | ✅ |

### Pendente do stakeholder
**Roteamento à Task seguinte (PO), fora do meu alcance — não aplicado:**
- `roles/product-owner/templates/product-backlog.md:4` — "O Product Backlog é o conjunto das Histórias" → "é o índice ordenado das Histórias"; `:22` — remover a opcionalidade ("no arquivo da História ou em seção própria... a escolha é do projeto") e fixar `.team-project/product-owner/stories/<H-ID>-<slug>.md`; a tabela de Histórias ganha o link por linha.
- `roles/product-owner/templates/user-story.md:3` — "vive no Product Backlog" → "vive em arquivo próprio (`.team-project/product-owner/stories/`), indexada pelo Product Backlog".
- `roles/product-owner/README.md:129,132` — mesma coerência: "o conjunto das Histórias" → "o índice das Histórias"; "`.team-project/product-owner/` (arquivo ou seção do backlog)" → "`.team-project/product-owner/stories/` (arquivo próprio, obrigatório)".
- `roles/product-owner/skills.md` — sem menção direta encontrada; conferir na Task do PO se algo depende da estrutura antiga.

**Duas propostas de texto pronto para `commands/po.md`** (`commands/*` é do stakeholder — não aplicado):
```
Linha 13, trecho "(o conjunto das Histórias **e o plano de entrega**)" →
"(o **índice** das Histórias, com o plano de entrega — cada História vive em arquivo próprio sob `.team-project/product-owner/stories/`)"

Linha 20, trecho "ordenar o Product Backlog — que é o **conjunto das Histórias** —" →
"ordenar o Product Backlog — que é o **índice das Histórias** —"
```
**Mudança de comportamento de agente/comando não se aplica ainda** — `commands/po.md` não foi tocado; as duas propostas só valem, se aprovadas, após reiniciar a sessão e depois de `git push` + `claude plugin marketplace update` + `claude plugin update`.

### PO — parte funcional aplicada

Itens roteados acima: **aplicados**.

| Documento | Mudança |
|---|---|
| `product-backlog.md:4,16-22,69-70` | Cabeçalho vira índice; tabela linka ID→`stories/<H-ID>-<slug>.md`; opcionalidade sai |
| `user-story.md:3` | vive em arquivo próprio, indexada pelo Backlog; **decisão** — arquivo nasce no **Esboço** (senão o índice linkaria vazio) |
| `README.md:52-67,129-133` | `/po story`: Esboço cria arquivo+linha; Detalhe só edita o arquivo; índice atualiza o Estado |
| `skills.md` | conferido — sem ocorrência |

**Evidência (R19)** — `Select-String` nos 3 arquivos: "seção própria\|escolha é do projeto\|conjunto das Histórias" → 0; "stories/" → 7 (`product-backlog.md:4,18,22`; `user-story.md:3,7`; `README.md:57,133`), lidas no contexto — coerentes. ✅

— PO, 18/09/2026

### Addendum — 18/09/2026: as duas propostas de `commands/po.md` foram aprovadas e aplicadas

O stakeholder aprovou no formulário de fecho do `/review`. `commands/po.md:13` e `:20` passaram de "o **conjunto** das Histórias" para "o **índice** das Histórias" — a contradição entre o comando e o normativo desta entrada está fechada.

**Achado novo, não aplicado** (surgiu ao abrir o arquivo, fora do que foi aprovado): `commands/po.md:19`, no modo `story`, ainda diz que o esboço *"entra no Product Backlog sem detalhar"*. Pela decisão do PO nesta entrada, o esboço passa a criar **o arquivo da História e a linha de índice**, na mesma sessão. É mudança de comportamento de comando, não coerência de referência cruzada — proposta ao stakeholder, na fila do `/review` seguinte. Texto pronto: *"valor em uma frase, origem rastreada, tamanho grosseiro; nasce em `.team-project/product-owner/stories/<H-ID>-<slug>.md` e ganha a linha correspondente no índice do Product Backlog, na mesma sessão, sem detalhar"*.
---


## v3.20 — Pendência do stakeholder resolvida em formulário: R22 ganha o meio de apresentação, restrito a quem orquestra (SM) — 18/09/2026

**Instrução:** *(stakeholder, via `/review note`, item 1)* "As pendências do Stackholder devem ser sempre apresentadas modo formulário para resolução com a última opção abrindo para mais esclarecimentos."

**Classificação:** regra de trabalho — R22 (v3.6) evolui; não nasce R25. A forma da pergunta já existia (pergunta + por que bloqueia, alternativas descritas, recomendação, via de mais contexto); faltava o **meio de apresentação**.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `working-rules.md` | R22 — título, corpo, Evita, SM verifica | Título ganha "e a resolução é em formulário". Corpo acrescenta dois parágrafos: **quem** apresenta (a sessão que orquestra a invocação — única com `AskUserQuestion`; nenhum `agents/*.md` a lista) e **quando** (no momento da resolução, não no do registro em tabela). Papel entrega a estrutura fixa; a orquestração a renderiza em formulário, com a via de mais contexto sempre a última opção |
| `working-rules.md` | "Resumo em uma tela" + indicador da retrospectiva | Título e linha de indicador acompanham o enunciado novo — inclui "resolvida em texto corrido" como ocorrência de R22 ignorada |
| `workflow.md` | §5a passo 5 · "O que o SM escala" · §6 diagrama de escalação · §6 texto pós-diagrama | As quatro citações que hoje enumeram a forma de R22 passam a citar também o formulário e a última opção fixa |
| `roles/scrum-master/skills.md` §10, `roles/scrum-master/README.md` (`/sm onboarding`) | Onboarding | Mesma coerência nas duas citações que enumeram a forma de R22 por extenso |

### Por quê
R22 já fixava **o quê** perguntar (as quatro peças) mas nunca fixava **o meio**: nada impedia — nem hoje impede, sem esta entrada — um papel de devolver a estrutura em texto corrido, e nada dizia quem a transforma em formulário de fato. O gatilho que obriga a forma exata: nenhum `agents/<papel>.md` carrega `AskUserQuestion` (confirmado nos seis frontmatters antes de escrever a regra) — só a sessão que orquestra a invocação a tem. Uma regra que exigisse do papel "apresente em formulário" nasceria inaplicável, cobrando de quem não tem a ferramenta; a solução é dividir a responsabilidade — o papel entrega a estrutura pronta, a orquestração a renderiza — e é isso que o texto novo fixa.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Os seis papéis (`agents/*`) | Nenhuma mudança de ferramenta — continuam sem `AskUserQuestion`, de propósito. A cobrança nova é entregar a **estrutura fixa** de R22, nunca a pergunta em prosa; devolver em prosa é achado de processo contra o papel |
| Sessão que orquestra (`/sm`, `/po`, `/arc`, `/team`, `/review` e os demais comandos que repassam decisão ao stakeholder) | Passa a **renderizar em `AskUserQuestion`** toda pergunta que o papel devolveu na forma de R22, via de mais contexto como última opção — nunca repassar "na íntegra" em texto corrido. Essa parte só produz efeito prático depois que `commands/*.md` incorporar a proposta abaixo (não aplicada — é do stakeholder) |
| stakeholder | Recebe cinco propostas de texto pronto (abaixo) e um roteamento aberto ao PO/Arquiteto |

### Conflitos com o processo vigente
Nenhum de conteúdo — as quatro peças de R22 continuam as mesmas; esta entrada fixa o meio e o momento, sem contradizer nenhuma linha existente. Ponto de atenção, não conflito: `roles/product-owner/README.md:16,115`, `roles/product-owner/templates/functional-analysis.md:38,46` e `roles/architect/README.md:48` seguem descrevendo a escalação como "até 3 opções e recomendação" / "com recomendação", sem citar R22 nem a via de mais contexto — já era roteamento aberto desde a v3.6 (`process-changelog-archive.md` v3.6, "Roteamento aberto") e segue aberto, agora também sem o formulário; fora do meu alcance (PO, Arquiteto), listado abaixo.

### Como saberemos que funcionou
Toda citação de R22 dentro do alcance do SM (`working-rules.md`, `workflow.md`, `skills.md`, `README.md`) menciona o formulário e a última opção — checável por `grep` (feito nesta entrada). Efeito de comportamento — a próxima pergunta de R22 chegando como cartões de `AskUserQuestion` em vez de texto corrido — só é verificável depois que o stakeholder aprovar e aplicar a proposta em `commands/*.md`, e a sessão reiniciar.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento (teto de 3, `process-changelog.md:10`) | `Compare-Object` do bloco `## v3.17` pré-sessão (`git show HEAD:...`, 78 linhas) × relocado em `process-changelog-archive.md` (79 linhas) | 1 diferença, a linha separadora `---` que a archive acrescenta entre entradas (mesmo padrão das demais); 0 diferenças de conteúdo | ✅ |
| Checagem semântica (premissa da regra) | leitura do frontmatter `tools:` dos seis `agents/*.md` | nenhum lista `AskUserQuestion` — confirma que a regra não pode cobrar a renderização do papel, só da orquestração | ✅ |
| Substituição de padrão | `Select-String -Path roles\scrum-master\process\working-rules.md,roles\scrum-master\process\workflow.md,roles\scrum-master\skills.md,roles\scrum-master\README.md -Pattern "R22"` | 9 ocorrências: `working-rules.md:150,202,239` (título/corpo, indicador, Resumo); `workflow.md:150,162,385,421` (§5a passo 5, "O que o SM escala", diagrama §6, pós-diagrama §6); `skills.md:138`; `README.md:38` — cada uma lida no contexto: todas as que enumeram a estrutura por extenso agora citam formulário/última opção. Fora desta busca (fora do alcance do SM ou citação por pointer, não por enumeração): `pending.md`, `gap-record.md`, QA — deixadas intactas de propósito | ✅ |
| Checagem semântica | contagem `^\| R\d+ \|` e `^### R\d+\.` em `working-rules.md` | 24/24, R1–R24 sem buraco — confirmando que R22 evoluiu, não numerou R25 | ✅ |
| Fronteira não ultrapassada | `git status --porcelain` | só `working-rules.md`, `workflow.md`, `skills.md`, `README.md` (de `roles/scrum-master/`) e `process-changelog*.md` no diff; nenhum `commands/`, `agents/`, `roles/product-owner/`, `roles/architect/` tocado | ✅ |

### Pendente do stakeholder
**Cinco propostas de texto pronto**, não aplicadas (`commands/*` é do stakeholder) — inserir antes da linha "Ao receber a resposta…"/"Ao final…" de cada arquivo:

`commands/sm.md`, `commands/po.md`, `commands/arc.md`, `commands/team.md`:
```
Se a saída do agente traz uma pergunta na forma de R22 (pergunta + por que bloqueia, alternativas descritas, recomendação, via de pedir mais contexto), não a repasse em texto corrido: chame `AskUserQuestion`, uma opção por alternativa descrita, com a via de pedir mais contexto sempre como a última opção. É você — a sessão que orquestrou — quem tem essa ferramenta; o agente não a tem.
```
`commands/review.md`, na seção "Como conduzir", passo 1, onde hoje diz *"Conflito com regra vigente **não se resolve sozinho**: apresente as duas posições e **pare** para decisão do stakeholder"*:
```
Apresente as duas posições em `AskUserQuestion`, com a via de pedir mais contexto como última opção — não em texto corrido.
```

**Roteamento aberto** (fora do alcance do SM, para o `/review` seguinte): `roles/product-owner/README.md:16,115`, `roles/product-owner/templates/functional-analysis.md:38,46` (PO) e `roles/architect/README.md:48` (Arquiteto) — descrevem escalação ao stakeholder sem citar R22 nem a via de mais contexto; pendente desde a v3.6, agora também sem o formulário.

**Mudança de comportamento de agente/comando não se aplica ainda** — nenhum `agents/`/`commands/` foi tocado nesta entrada; as cinco propostas só valem, se aprovadas, após reiniciar a sessão e depois de `git push` + `claude plugin marketplace update` + `claude plugin update`.

### Addendum — 18/09/2026: as cinco propostas foram aprovadas e aplicadas

O stakeholder aprovou as cinco no formulário de fecho do `/review` (a própria R22 desta entrada, exercida pela sessão que orquestra). Aplicadas por ele, via `/review`, nos arquivos que são dele:

| Arquivo | O que entrou |
|---|---|
| `commands/sm.md:33` · `commands/po.md:37` · `commands/arc.md:28` · `commands/team.md:87` | O parágrafo do gancho, imediatamente **antes** da linha "Ao receber a resposta…"/"Ao final…" |
| `commands/review.md:54` | "apresente as duas posições" → "apresente as duas posições em `AskUserQuestion`, com a via de pedir mais contexto como última opção — não em texto corrido" |

**Em vigor só após reiniciar a sessão**, e nos demais projetos só depois de `git push` + `claude plugin marketplace update team` + `claude plugin update team@team`.

**Achado novo, não aplicado** (surgiu ao abrir `commands/po.md`, fora do que foi aprovado): `commands/po.md:25` ainda diz *"escalação ao stakeholder com no máximo 3 opções e uma recomendação"* — contradiz R22, que não fixa quantidade e exige a via de pedir mais contexto. É irmão do roteamento aberto desde a v3.6. Fica na fila do `/review` seguinte.

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

---

## v3.13 — O bug entra pelo PO: classificação do relato do stakeholder, e a fila `.team-project/note.md` tratada em lote (PO) — 12/09/2026

> **Entrada irmã da mesma rodada de `/review note`.** A triagem do Agent `scrum-master` apontou que `workflow.md` §6a fecha de forma exaustiva os canais diretos do stakeholder (PO, Arquiteto, UX) e que a QA não é canal de entrada — o stakeholder decidiu, antes desta aplicação, que **o bug entra pelo PO**: ele reporta o defeito ao PO, que classifica e aciona a QA, sem abrir canal direto stakeholder→QA. Esta é a parte do **PO**; o Agent `quality-assurance` aplica `roles/quality-assurance/*` e `deliverables/implementation/pending.md` em paralelo (`v3.12`, já registrada acima) e o Agent `scrum-master` fecha a curadoria (`v3.14`). No meio da aplicação, o stakeholder acrescentou um pedido complementar — replicar, no nível do projeto, o mesmo padrão de fila que o próprio plugin usa (`RAIZ/note.md` + `/review note`) — e pediu para manter tudo nesta mesma entrada.

**Instrução:** *(stakeholder, via `/review note`, decisão já fechada na triagem, mais o acréscimo em conversa)* "O stakeholder pediu... um caminho para reportar bugs que ele identifica no sistema, e um comando para a QA tratar" (item de `note.md`) — decidido: "o bug entra por você [PO]... nenhum canal direto stakeholder→QA é criado"; e, na sequência: "quer um arquivo `.team-project/note.md` onde ele anota, ao longo do uso, os problemas que encontra — e um modo `/po note` que lê esse arquivo e faz a tratativa de **todos** os itens reportados de uma vez... o mesmo padrão que o próprio plugin já usa para si."

**Classificação:** escopo de papel (roteiro/skills do PO para tratar relato de defeito) + formato de documento novo (modelo de `.team-project/note.md`, análogo a `RAIZ/note.md`). Não é regra de trabalho nova — `workflow.md` §6a (canal do stakeholder) e R4 (não antecipar escopo) já cobriam a fronteira; o que faltava era o **roteiro do PO instruir** o que fazer quando o relato não é "demanda de valor", e sim "isto está quebrado".

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/product-owner/README.md` | "O que respondo" (Entradas · Saídas · Escreve · Não faz) | **Entradas** ganha relato de defeito do stakeholder (avulso ou pela fila); **Saídas** ganha a classificação com destino acionado; **Escreve** ganha `.team-project/note.md`, só para remover item já tratado; **Não faz** ganha a fronteira explícita — não investiga código, não confirma defeito com evidência, não escreve no registro da QA (é dela) |
| `roles/product-owner/README.md` | "Roteiro por modo" | Dois modos novos, após `/po accept`: **`/po bug <relato>`** (classifica um relato avulso em defeito · mudança de escopo disfarçada de bug · dúvida de uso, com a régua do portão ③/R21, a fronteira e a rastreabilidade relato→classificação→destino) e **`/po note`** (lê `.team-project/note.md` inteiro, trata todos os itens da fila com a mesma classificação, devolve item a item ao stakeholder e fecha a fila) |
| `roles/product-owner/README.md` | "Como sei que estou funcionando" | Bullet novo: todo relato de defeito tem linha rastreável relato → classificação → destino, nunca fica só numa conversa |
| `roles/product-owner/README.md` | "Documentos que administro" | Linha nova: **Relatos do stakeholder (fila)** — vivo, `.team-project/note.md`, modelo `templates/note.md` |
| `roles/product-owner/skills.md` | **Skill 8 nova** — *Classificar relato de defeito antes de agir* | Tabela de três casos (defeito / mudança de escopo disfarçada de bug / dúvida de uso) com a régua e o destino de cada um; o caso "não dá para decidir sem investigar" (aciona a QA para investigar antes de classificar, o que é legítimo); a fronteira (não investigo, não confirmo, não escrevo no registro da QA) |
| `roles/product-owner/templates/note.md` | **arquivo novo** | Modelo de `.team-project/note.md` — fila de relatos do stakeholder **deste projeto**: cabeçalho com dono (stakeholder escreve) e quem trata (PO), seção "O que escrever aqui" (relato bruto, com exemplo do que não escrever), seção "Abertas", e "Como este arquivo é fechado" (tabela classificação → destino; item tratado sai da fila e não duplica registro) — mesma mecânica de `RAIZ/note.md` + `/review note`, no nível do projeto |

### Por quê
Sem um modo explícito, um relato de "isto está quebrado" tinha três destinos plausíveis e nenhuma régua escrita para escolher entre eles: virar bug automático mesmo quando é mudança de escopo disfarçada (inflando indevidamente `pending.md` da QA com o campo `origem: stakeholder` que a v3.12 acabou de criar), ou ser resolvido em conversa sem nunca chegar a um registro (violando o espírito de R6 — decisão registrada). A régua explícita — critério de aceite aprovado no portão ③ e o que foi aceito na Sprint Review (R21) — é o que já existe para julgar se o sistema faz o que devia; faltava só apontá-la para este uso. O `/po note` replica, no nível do projeto, um padrão já comprovado (`RAIZ/note.md` + `/review note`): fila só de sintomas, tratada em lote, sem virar segundo registro que diverge do destino real de cada item.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| **PO** | Passa a classificar todo relato de defeito do stakeholder — avulso (`/po bug`) ou pela fila (`/po note`) — contra a régua do critério de aceite aprovado, antes de acionar qualquer destino; não pode mais tratar "está quebrado" como bug automático nem resolver em conversa sem registrar a linha relato→classificação→destino |
| **QA** | (Aplicado por ela em `v3.12`) passa a receber o defeito **já classificado** pelo PO, nunca diretamente do stakeholder |
| **stakeholder** | Reporta defeito ao PO, não à QA; ganha um canal de anotação contínua (`.team-project/note.md`), tratado em lote por `/po note` sem precisar reportar item a item em conversa |

### Conflitos com o processo vigente
Nenhum novo — o único conflito (canal direto stakeholder→QA romperia o fechamento exaustivo de `workflow.md` §6a) já foi decidido pelo stakeholder antes desta aplicação: o bug entra pelo PO. Esta entrada só aplica a decisão já fechada.

### Como saberemos que funcionou
Todo relato de defeito recebido pelo PO — avulso ou pela fila — aparece na resposta como uma linha relato → classificação → destino (Task/investigação da QA, ID novo no Product Backlog, ou a resposta dada); nenhum relato "some" numa conversa sem essa linha. Depois de um `/po note`, `.team-project/note.md` só mantém os itens ainda não classificáveis (aguardando investigação da QA), nunca um item já tratado.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição/extensão de padrão | `Select-String -Path roles\product-owner\README.md, roles\product-owner\skills.md, roles\product-owner\templates\note.md -Pattern '/po bug\|/po note\|templates/note\.md'` | 11 ocorrências nos 3 arquivos (`README.md`: 6, linhas 12/85/99/101/104/133 · `skills.md`: 1, linha 88 · `note.md`: 4, linhas 1/3/16/24) — cada uma lida no contexto: `README.md` (Entradas, os dois modos completos, referência cruzada `/po bug`↔`/po note`, linha da tabela de documentos), `skills.md` (ponteiro da skill 8 para os dois modos), `note.md` (título, cabeçalho, corpo) — nenhuma ocorrência órfã ou contraditória | ✅ |
| Checagem semântica | leitura de `roles/product-owner/README.md` completo após a edição | os dois modos novos ficam entre `/po accept` e "Como sei que estou funcionando" (mesma posição de todo modo no roteiro); a tabela "O que respondo" e a tabela "Documentos que administro" foram atualizadas nas quatro linhas certas; nenhuma seção antiga ficou contradizendo o texto novo | ✅ |
| Extração/criação de arquivo | `(Get-Content roles\product-owner\templates\note.md).Count` antes/depois | antes: arquivo não existia (0); depois: 34 linhas — modelo referenciado por `README.md` linha 133 e pelo próprio corpo do modo `/po note` resolve para um arquivo existente | ✅ |
| Fronteira não ultrapassada | `git status --porcelain` | dez arquivos modificados/novos no total; os deste agente são exatamente `roles/product-owner/README.md`, `roles/product-owner/skills.md`, `roles/product-owner/templates/note.md` (novo, `??`) e este bloco em `roles/scrum-master/process/process-changelog.md`; os demais (`deliverables/implementation/README.md`, `deliverables/implementation/pending.md`, `roles/quality-assurance/README.md`, `roles/quality-assurance/skills.md`, `roles/quality-assurance/templates/cross-audit.md`, `roles/quality-assurance/templates/gap-record.md`) são do Agent `quality-assurance` em paralelo (`v3.12`), e `note.md` da raiz é da triagem do Agent `scrum-master` — nenhum deles editado por mim; `commands/*`, `agents/*` e `artifact-ownership.md` seguem intocados | ✅ |

### Pendente do stakeholder
Duas propostas de **texto pronto**, não aplicadas (`commands/po.md` e `agents/product-owner.md` são do stakeholder):

**1. `commands/po.md`** — `argument-hint` (linha 3), acrescentar antes do fecho de aspas:
```
| bug <relato> | note
```
Descrição (linha 2), acrescentar ao final: `Classifica relato de defeito do stakeholder e trata a fila de .team-project/note.md.`

Novo bullet no passo 3 (lista de modos), após o bullet de **accept**:
```
   - **bug `<relato>`** → classificar o relato do stakeholder em **defeito** (aciona a QA para investigar, confirmar com evidência e registrar em `pending.md` com `Origem: stakeholder`) · **mudança de escopo disfarçada de bug** (trata por `/po analyze`/`/po impact`, vai ao Product Backlog) · **dúvida de uso** (responde; o achado pode virar melhoria de UX ou de documentação). Régua: o critério de aceite aprovado no portão ③ e o que foi aceito na Sprint Review (R21). Quando não dá para decidir sem investigar, aciona a QA para investigar **antes** de classificar — legítimo, não é fugir da classificação. Nunca investiga código, nunca confirma com evidência, nunca escreve no registro da QA — isso é dela. Responde sempre com a linha relato → classificação → destino acionado.
   - **note** → ler `.team-project/note.md` inteiro (modelo em `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/note.md`), seção **Abertas**, e tratar **todos** os itens com a mesma classificação do modo `bug`, um a um. Devolver ao stakeholder, item a item: relato → classificação → destino → o que foi feito. Remover da fila todo item tratado — ele passa a viver só no destino (registro da QA, Product Backlog, ou a resposta já dada); item que só a QA consegue classificar depois de investigar permanece na fila, marcado como "aguardando investigação da QA".
```

**2. `agents/product-owner.md`** — no card `description` (linha 3), acrescentar: `classifica relato de defeito do stakeholder (bug · mudança de escopo · dúvida de uso) e trata a fila .team-project/note.md`. Na lista de leitura obrigatória (item 2), acrescentar: `Nos modos bug e note, ler também .team-project/note.md, se existir.` No modo (item 3), acrescentar os dois bullets do mesmo texto proposto para `commands/po.md`, acima. Nos "Arquivos que você pode escrever" e na lista de limites (item 4), acrescentar: `.team-project/note.md — só para remover item já tratado; nunca escreve no registro de GAPs da QA`.

**3. Homônimo `note`** — pedido ao Agent `scrum-master` (não aplicado por mim): acrescentar a linha `note` à tabela de homônimos de `artifact-ownership.md` §1b (`RAIZ/note.md` — fila do `/review`, SM · `.team-project/note.md` — fila do `/po note`, PO).

**4. `deliverables/team-project/README.md` e `roles/scrum-master/templates/project-context.md`** — pedido ao Agent `scrum-master` (não aplicado por mim, ambos são dele): semear `.team-project/note.md` a partir de `roles/product-owner/templates/note.md` no `/team init`, e acrescentar `bug <relato> | note` à linha `/po` da seção 8 fixa do `README.md` do projeto.

**Mudança de comportamento de agente/comando só entra em vigor após reiniciar a sessão.**

---

## v3.12 — Pendências e bugs num só registro: campo `origem`, leitura filtrada do stakeholder e estado de escalação em `pending.md` (QA) — 12/09/2026

> **Entrada irmã da mesma rodada de `/review note`** (item de `note.md` sobre concentrar pendências e bugs em quatro documentos geridos por QA). A triagem do Agent `scrum-master` identificou três conflitos com regra vigente e o stakeholder decidiu todos **antes** desta aplicação — nenhuma reabertura aqui. Esta é a parte do **QA**; o Agent `product-owner` aplica `roles/product-owner/*` em paralelo (`v3.13`) e o Agent `scrum-master` fecha a curadoria (`v3.14`).

**Instrução:** *(stakeholder, via `/review note`, decisão já fechada na triagem)* Um registro só — `pending.md`, sem `pendings.md`/`bugs.md`/`pendings-resolved.md`/`bugs-resolved.md` — distinguindo "bug" (relatado pelo stakeholder) de "pendência" (achado do time) por um campo `origem`, não por arquivo; resolvido continua saindo do registro da QA para `02-status.md` do SM (R12 preservada); só o QA escreve em `pending.md` — os demais papéis reportam pelos canais que já existem e o QA transcreve com evidência; bug do stakeholder entra **pelo PO**, nunca direto na QA.

**Classificação:** formato de documento (entregáveis do QA: `pending.md` e a entrada individual `gap-record.md`) + escopo de papel (roteiro/skills do QA para tratar defeito acionado pelo PO). Não é regra de trabalho nova — R9, R22 e `workflow.md` §6b já cobriam a escalação; o que faltava era o **registro mostrar** esse estado.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `deliverables/implementation/pending.md` | Cabeçalho (Natureza), §2 Resumo executivo, §4 (entrada-modelo), Regras, Falhas comuns | **Natureza** passa a nomear "pendências e bugs abertos" como um só registro, dono único QA; **§2** ganha as linhas "Por origem" e "Aguardando decisão do stakeholder"; **§2.1 nova** — visão filtrada: só as entradas com `Origem: stakeholder`, sem atravessar a lista técnica (resolve o pedido de leitura separada sem criar arquivo); entrada-modelo ganha `**Origem:** time \| stakeholder` e `**Aguarda decisão do stakeholder:** não \| sim — <pergunta/ponteiro>`; duas regras novas (campos sempre preenchidos, §2.1 é leitura e não escrita separada) e duas falhas comuns novas |
| `roles/quality-assurance/templates/gap-record.md` | "Abrir um GAP", seções novas `Origem` e `Aguarda decisão do stakeholder`, Regras, Exemplo | Linha de cabeçalho da entrada ganha `**Origem:** time \| stakeholder`; linha nova `**Aguarda decisão do stakeholder:**`; duas seções explicam os campos com verificação própria; Regras ganha "dono único do registro é o QA" (transcrição com evidência, nunca narrativa de terceiro) e "campos sempre preenchidos"; Exemplo atualizado com os dois campos |
| `roles/quality-assurance/templates/cross-audit.md` | "GAPs a abrir" | Coluna `Origem` acrescentada à tabela, com nota de que é quase sempre `time` (achado de auditoria) — coerência com o campo agora obrigatório em `gap-record.md` |
| `roles/quality-assurance/README.md` | Nova subseção "Defeito reportado pelo stakeholder (acionado pelo PO)", após `/qa security` | Roteiro de 5 passos: investigar/reproduzir, abrir com `Origem: stakeholder` só se confirmado (senão suspeita), rotear pela escada de falha de sempre, marcar `Aguarda decisão do stakeholder` quando aplicável, e reafirmar a fronteira — reprova e registra, não corrige |
| `roles/quality-assurance/skills.md` | **§11 nova** — *Bug do stakeholder chega pelo PO, nunca direto — e só entra confirmado* | Competência transferível espelhando a subseção do README: sem canal direto, investigação antes de registro, dono único da escrita, escada de falha inalterada pela origem, estado de espera explícito |
| `deliverables/implementation/README.md` | Tabela dos quatro documentos; tabela "Critérios de qualidade" | Descrição de `pending.md` passa a citar a origem (`time` \| `stakeholder`); critério "todo GAP tem `arquivo:linha`, impacto e criticidade" ganha "e origem" — descrição ficaria incompleta sem o campo novo |

### Por quê
O pedido original criava quatro cargas fixas de leitura para separar dois bits (origem e estado), e um canal de escrita paralelo que quebraria a garantia central do registro: **toda entrada tem evidência verificada** porque só um papel escreve nela. Um campo na ficha resolve a mesma necessidade de leitura filtrada sem multiplicar arquivo, e manter o QA como dono único preserva a regra que faz `pending.md` "vencer a narrativa de status" (`deliverables/implementation/README.md`). O estado de escalação já existia em regra (R9/R22/§6b); sem aparecer no registro, uma entrada parada por decisão do stakeholder era indistinguível de uma simplesmente não priorizada — o que gerava cobrança errada no quadro do SM.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| **QA** | Toda entrada nova ou existente em `pending.md` declara `Origem` e `Aguarda decisão do stakeholder`; ganha um roteiro explícito para quando o PO aciona com um defeito relatado pelo stakeholder; segue sem escrever `pending.md` para ninguém além de si mesmo |
| **PO** | (Aplicado por ele em `v3.13`, referenciado aqui) passa a ser o único canal de entrada de bug do stakeholder rumo à QA |
| **stakeholder** | Ganha uma leitura filtrada (§2.1 de `pending.md`) só do que ele relatou, sem precisar abrir um arquivo novo nem atravessar a lista técnica completa |
| **SM** | No resumo executivo de `pending.md`, agora vê quantas entradas aguardam decisão do stakeholder e quais IDs — informação que antes só existia implícita numa thread |

### Conflitos com o processo vigente
Nenhum novo — os três conflitos identificados na triagem já foram decididos pelo stakeholder antes desta aplicação (registrados na origem do item em `note.md`, agora consumido). Esta entrada só aplica as decisões já fechadas: um registro só, resolvido fora do QA (R12 preservada), dono único de escrita.

### Como saberemos que funcionou
Na próxima vez que o PO acionar a QA com um defeito relatado pelo stakeholder: a entrada resultante em `pending.md` tem `Origem: stakeholder`, evidência `arquivo:linha` (ou aparece como suspeita, nunca como entrada sem confirmação), e aparece em §2.1 sem precisar de outro arquivo. Zero entradas com `Origem` ausente na próxima `/qa audit`. Primeira entrada que ficar de fato esperando decisão do stakeholder carrega `Aguarda decisão do stakeholder: sim` com a pergunta no formato de R22, visível no resumo executivo sem precisar reconstituir a thread.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | `Select-String -Path roles\quality-assurance\templates\gap-record.md, deliverables\implementation\pending.md, roles\quality-assurance\templates\cross-audit.md, deliverables\implementation\README.md -Pattern 'Origem'` | 19 ocorrências nos 4 arquivos (`gap-record.md`: 7 · `pending.md`: 8 · `cross-audit.md`: 2 · `README.md`: 2) — cada uma lida no contexto: `gap-record.md` (campo na entrada, seção explicativa, verificação, regra, exemplo), `pending.md` (Natureza, resumo por origem, §2.1, entrada-modelo, regras, falhas comuns), `cross-audit.md` (coluna nova da tabela "GAPs a abrir"), `README.md` (descrição do documento e critério de qualidade) | ✅ |
| Checagem de fato — decisão 1 não reintroduzida | `Select-String -Path roles\quality-assurance\*.md, roles\quality-assurance\templates\*.md, deliverables\implementation\*.md -Pattern 'pendings\.md\|bugs\.md\|bugs-resolved\|pendings-resolved'` | zero ocorrências — nenhum dos quatro arquivos proibidos pela decisão do stakeholder foi criado ou citado como caminho real | ✅ |
| Checagem semântica | leitura de `deliverables/implementation/pending.md` completo após a edição | `§2.1` está posicionada logo após o resumo executivo (leitura de topo, antes da lista técnica das seções 4–7); a entrada-modelo da §4 tem os dois campos novos na ordem certa (`Origem` na linha do cabeçalho, `Aguarda decisão…` na linha seguinte); nenhuma seção antiga (1, 3, 8, 9, 10) ficou inconsistente com os campos novos | ✅ |
| Fronteira não ultrapassada | `git status --porcelain` | únicos arquivos tocados por este agente: `deliverables/implementation/README.md`, `deliverables/implementation/pending.md`, `roles/quality-assurance/README.md`, `roles/quality-assurance/skills.md`, `roles/quality-assurance/templates/cross-audit.md`, `roles/quality-assurance/templates/gap-record.md` — nenhum arquivo de `roles/product-owner/*` (Agent `product-owner`, em paralelo), `roles/scrum-master/*` (exceto esta entrada) ou `commands/*` foi editado | ✅ |

### Pendente do stakeholder
Proposta de **texto pronto**, não aplicada (`commands/qa.md` é do stakeholder) — modo novo em vez de comando novo, para não somar carga fixa, acionado sempre **pelo PO**:

`argument-hint` (linha 3), acrescentar ao final antes do fecho de aspas:
```
| bug <descrição>
```
Novo bullet no passo 3 (lista de modos), após o bullet de `security <ID>`:
```
   - **bug `<descrição>`** → acionado pelo **PO**, nunca diretamente pelo stakeholder, com a descrição do defeito já classificado por ele. Investigar e tentar reproduzir; confirmado com `arquivo:linha`, registrar/atualizar a entrada em `pending.md` com `Origem: stakeholder` (e `Aguarda decisão do stakeholder` quando for o caso), no formato de `${CLAUDE_PLUGIN_ROOT}/roles/quality-assurance/templates/gap-record.md`; não reproduzido, reportar como suspeita — nenhuma entrada nova sem evidência. Roteia pela escada de falha de sempre; o QA reprova e registra, não corrige.
```
**Mudança de comportamento de agente/comando só entra em vigor após reiniciar a sessão.**

---

## v3.11 — Delegar tarefa simples de PO/SM/UX/QA ao dev (Haiku): proposta avaliada e descartada — 12/09/2026

> Nenhum documento de processo mudou nesta entrada — é o registro de uma **decisão negativa**, para que a ideia não seja reproposta sem que quem a leia veja por que já foi avaliada e recusada.

**Instrução:** *(stakeholder, via `/review note` — item único de `note.md`)* "Revisar o modelo para avaliar a adoção do seguinte padrão: quando os membros do time PO, SM, UX e QA (que usam modelos de maior custo) precisam realizar tarefas simples e repetitivas eles podem acionar o DEV que trabalha sobre o Modelo HAIKU desde que esteja bem instruído e, é claro que eles precisam revisar, e assim otimizar o custo da IA. É uma boa proposta?"

**Classificação:** mecanismo operativo de `commands/dev.md`/`agents/developer.md` (**proposta ao stakeholder**, `review-contract.md`) mais possível exceção a **R8** e à matriz de propriedade de artefatos (normativo exclusivo do SM) — mista, e por isso triada e não aplicada por nenhum papel sozinho.

### Análise (Agent scrum-master, triagem)

1. **Conflito com o contrato vigente do dev.** `commands/dev.md`: "sem plano, o dev não codifica"; `agents/developer.md`, contrato item 1: "nunca preencha a lacuna por conta própria"; **R8**: "o dev não escreve uma linha sem Plano de Implementação do Arquiteto". Não existe hoje canal PO/SM/UX/QA → dev; o único fluxo é Arquiteto planeja → dev constrói.
2. **O que seria "simples e repetitivo" nesses quatro papéis quase sempre é edição do próprio deliverable** (SDD, backlog, protótipo, registro de QA) — cada um com dono explícito na matriz de propriedade de artefatos (`artifact-ownership.md`), não código. Delegar ali ao dev romperia essa matriz, não só R8.
3. **Revisão prevista não resolve a fronteira**: o dev estaria produzindo conteúdo dentro do domínio de decisão de outro papel; revisão sob a mesma pressão de custo que motivou a delegação tende a virar aprovação rasa, sem checklist de verificação nomeado.
4. **O ganho de custo alegado já tem endereço**: R23 (modo leve de verificação, `v3.7`) e R3 (releitura incremental, `v3.7`) atacam o mesmo problema — trabalho repetitivo caro — sem abrir canal novo entre papéis; o ciclo de eficiência (`workflow.md` §5c, `/review metrics`) já busca uma remoção a cada 3 sprints.

### Decisão do stakeholder

Apresentadas duas posições — **(1)** não adotar, seguir pelos mecanismos já existentes (R23/R3/`/review metrics`); **(2)** adotar em versão restrita (lista fechada de subtarefas mecânicas, formato de instrução obrigatório escrito pelo papel dono, checklist de revisão nomeado — mudança coordenada em `commands/dev.md`, `agents/developer.md`, exceção a R8 e recorte na matriz de propriedade) — o stakeholder escolheu **(1): descartar a ideia**. Nenhum arquivo de processo foi alterado.

### Por quê

O custo de reabrir a fronteira do dev (mudar `agents/*`, abrir exceção em R8, recortar a matriz de propriedade) supera o ganho, dado que R23/R3/`/review metrics` já perseguem o mesmo objetivo sem tocar em quem decide o quê no time.

### Conflitos com o processo vigente

Identificado e não resolvido por nenhum papel sozinho — escalado ao stakeholder por tocar `agents/*`/`commands/*` e uma possível exceção a R8; decisão tomada acima.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Checagem de fato | leitura de `commands/dev.md`, `agents/developer.md`, `working-rules.md` R8, `workflow.md` (diagrama de escalação) | confirma: dev só recebe instrução via Plano de Implementação do Arquiteto; nenhum canal PO/SM/UX/QA → dev existe hoje | ✅ |
| Checagem de fato | `agents/*.md` — campo `model:` | `developer.md: haiku`; `architect.md`/`user-experience.md`: `opus`; `product-owner.md`/`scrum-master.md`/`quality-assurance.md`: `sonnet` | ✅ (confirma a premissa de custo da proposta, sem validar o mecanismo) |
| Remoção do item da fila | `note.md`, seção "Abertas" | item removido; decisão vive só aqui | ✅ |

### Pendente do stakeholder

Nenhum. Decisão fechada; nada a propagar aos outros projetos (nenhum documento de processo, `agents/` ou `commands/` mudou).

---

## v3.10 — Pendentes de v3.8/v3.9 aplicados a pedido do stakeholder: timeout do Arquiteto, verificação do protótipo no comando e retomada nativa entre invocações — 12/09/2026

> Fecho do `/review note` de `feedback-plugin-team-consumo-sessao.md`. Depois do resumo da rodada (v3.7 SM · v3.8 UX · v3.9 Arquiteto), o stakeholder respondeu **"Pode aplicar os pendentes"** — autorização explícita para tocar `agents/*` e `commands/*`, que normalmente ficam como proposta sem aplicar (`review-contract.md`). Quem aplicou foi o orquestrador do `/review note` (sessão principal), não um agente de papel — são arquivos de ninguém no `review-contract.md`.

**Instrução:** aplicar as duas propostas de texto pronto deixadas em `v3.8` (`commands/ux.md`) e `v3.9` (`agents/architect.md`, `commands/arc.md`), e desenhar e aplicar o **Item 2** do relato original (`feedback-plugin-team-consumo-sessao.md`) — retomada nativa entre invocações do mesmo papel — que a triagem tinha deixado como proposta **sem texto pronto**, por não ter localização/mecanismo óbvio até este fecho.

**Classificação:** comportamento de agente/comando (`agents/architect.md`, `commands/{arc,ux,po,qa,sm}.md`) — aplicada por exceção, com autorização direta do stakeholder.

### O que mudou

| Documento | Seção | Mudança |
|---|---|---|
| `agents/architect.md` | "Arquivos que você pode escrever", proibição | Texto de `v3.9` aplicado verbatim: exceção de spike agora cita timeout curto, backoff limitado, checkpoint por etapa e relato de causa externa (skills §11–§13) |
| `commands/arc.md` | item 4, lembrete de limites | Texto de `v3.9` aplicado verbatim: frase nova sobre timeout/tentativas explícitos e etapa inconclusiva por causa externa em spike |
| `commands/ux.md` | modo `prototype` | Texto de `v3.8` aplicado verbatim: frase sobre exercitar com verificação executável no escopo (R23) e gravar o parcial em `verification-log.md` (R5) |
| `commands/po.md` · `commands/arc.md` · `commands/ux.md` · `commands/qa.md` · `commands/sm.md` | abertura da invocação do Agent | Passo novo: antes de abrir instância nova, checar com **ListAgents** se já existe, nesta sessão, um agente do mesmo papel invocado há pouco sobre a mesma Task/tema; se existir, retomar com **SendMessage** em vez de acionar o Agent de novo — implementa o Item 2 do relato (retomada nativa), citando R3 como motivo |

`commands/dev.md` **não** foi tocado: seu modo `gap` já tinha o mecanismo equivalente ("se o agente anterior ainda estiver ativo, prefira continuar por SendMessage") desde antes desta rodada — não havia lacuna a fechar.

### Por quê

Duas das três pendências eram só texto esperando autorização (`v3.8`/`v3.9` já tinham a redação pronta). A terceira — retomada nativa — era o item do relato original com o maior potencial de economia (threads retomadas do Arquiteto somaram ~1,2M tokens no relato) e não tinha dono nem texto: nenhum papel tem alcance sobre `commands/`/`agents/` (`review-contract.md`), e a triagem corretamente não inventou um mecanismo sem esse alcance. Com a autorização do stakeholder, o mecanismo concreto é o que a própria orquestração desta sessão já usa: `ListAgents` para achar a thread, `SendMessage` para retomá-la.

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda |
|---|---|
| **PO · Arquiteto · UX · QA · SM** | Reinvocado sobre a mesma Task pouco depois, é retomado por `SendMessage` em vez de reaberto do zero — quando há uma thread para retomar |
| **Arquiteto** | A obrigação de timeout/checkpoint/modo leve em spike (skills §11–§13, de `v3.9`) agora também aparece na instrução do comando e no roteiro do agente, não só no `skills.md` |
| **UX** | A obrigação de verificação executável no escopo (skills §10, de `v3.8`) agora também aparece na instrução do comando `/ux prototype` |

### Conflitos com o processo vigente

Nenhum. Duas partes são aplicação de proposta já registrada e sem objeção. A terceira (retomada nativa) é aditiva: não muda quando um papel é acionado, só evita reabrir do zero quando já existe thread recente do mesmo papel sobre o mesmo tema — o comportamento sem thread prévia (o caso comum) não muda.

### Como saberemos que funcionou

Na próxima Task com mais de uma invocação do mesmo papel em sequência próxima (ex.: `/arc question` seguido de `/arc plan` sobre a mesma dúvida): a segunda chamada cita a primeira em vez de reler tudo do zero. Próximo spike do Arquiteto acionado por `/arc`: reporta timeout/checkpoint desde a primeira etapa, sem precisar que o agente "lembre" disso sozinho.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Extração/inserção | `git diff --stat -- agents/architect.md commands/arc.md commands/ux.md commands/po.md commands/qa.md commands/sm.md` | 7 arquivos alterados, cada um com 1–2 linhas adicionadas, nenhuma removida além da linha substituída pela versão estendida | ✅ |
| Substituição de padrão | `Select-String -Path commands\{po,arc,ux,qa,sm}.md -Pattern 'ListAgents'` | 5 ocorrências, uma por arquivo, cada uma seguida do nome do `subagent_type` correto daquele comando | ✅ |
| Checagem semântica | leitura de `agents/architect.md` e `commands/arc.md` após a edição, comparada ao texto proposto em `v3.9` | frase aplicada verbatim, sem edição no meio | ✅ |
| Checagem semântica | leitura de `commands/ux.md` após a edição, comparada ao texto proposto em `v3.8` | frase aplicada verbatim, sem edição no meio | ✅ |
| Verificação de ferramenta real | `ListAgents` e `SendMessage` conferidas como ferramentas disponíveis nesta sessão (não hipotéticas) | ambas presentes na lista de ferramentas | ✅ |

### Pendente do stakeholder

- **Reiniciar a sessão** para as mudanças de `agents/architect.md` e `commands/{arc,ux,po,qa,sm}.md` entrarem em vigor — mudança de comportamento de agente/comando, R-padrão já citado em `v3.7`/`v3.8`/`v3.9`.
- Propagar aos demais projetos: `git commit` + `git push` + `claude plugin marketplace update team` + `claude plugin update team@team`.

---

## v3.9 — Spike do Arquiteto para de travar: timeout/backoff na borda externa, checkpoint por etapa e modo leve de verificação — 12/09/2026

> **Entrada irmã da mesma rodada de `/review note`** (consumo de sessão em uso intensivo, `feedback-plugin-team-consumo-sessao.md`). A parte geral — extensão de R3/R5 e a **R23** nova (modo leve) — está em `working-rules.md`, registrada em **v3.7** (SM); a parte do **UX** está em **v3.8**. Esta é a parte do **Arquiteto**. Renumerada pela curadoria do SM (de `v3.7-arc`, sufixo usado para evitar colisão entre agentes concorrentes, para `v3.9`) — mesma curadoria que arquivou `v3.6` e `v3.5` para respeitar o teto de três entradas quentes (R17).

**Instrução:** *(stakeholder, via `/review note`)* Item de `note.md` sobre estouro de limite de taxa da conta em sessão intensiva, detalhado em `feedback-plugin-team-consumo-sessao.md`. Três pontos roteados ao Arquiteto: **(A)** chamada externa de spike sem timeout/backoff explícito — um spike travou 600 s sem progresso e sem relatar; **(B)** verificação pesada sem checkpoint — duas chamadas cortadas por limite de sessão perderam 150–300 mil tokens de trabalho; **(C)** ausência de um modo mais barato para follow-up pequeno sobre entrega já validada.

**Classificação:** competência de papel (skills do Arquiteto) + formato de documento (dois modelos). Não é regra de trabalho nova: a obrigação geral é do SM em `working-rules.md`; aqui fica a **tradução verificável** dela no papel que produz spike, ADR e revisão de aderência. Causa confirmada pelo stakeholder: **código do spike sem timeout/retry explícito**, não ambiente.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/architect/skills.md` | **§11 nova** — *Conduzir spike técnico com chamada a serviço externo* | Timeout por tentativa, máximo de tentativas com backoff e teto (retry indefinido proibido) e teto de tempo da etapa, todos no código do spike; esgotadas as tentativas, a etapa fecha como **inconclusiva por causa externa** com o erro literal e o spike segue ou encerra; etapa não exercitada não vira ADR nem passo de plano (R7). Verificação: os três números e o desfecho por etapa no relato. Fronteira declarada: governa o código do spike, não a resiliência do produto |
| | **§12 nova** — *Salvar checkpoint em verificação pesada* | Resultado parcial em disco ao fim de **cada** etapa (`.team-project/architect/spikes/<ID>-<slug>.md`), com comando, saída real, decisão parcial e **próxima etapa**; retomada parte do checkpoint. Contraparte de R5 no papel. Verificação: trabalho multietapa sem arquivo de checkpoint é entrega incompleta |
| | **§13 nova** — *Modo leve: a segunda passada não paga o preço da primeira* | Tabela completa × leve para spike, ADR, plano e `/arc comply`; quatro limites — leve reduz escopo de execução e **nunca** a exigência de evidência (R7), o não reexecutado vem com ponteiro para a evidência original, portão e limiar de `standards/` não mudam de altura, e na dúvida é completa. Verificação: linha obrigatória *"modo leve: reexecutado X; reaproveitado Y, evidência em `<caminho>`"* |
| `roles/architect/README.md` | **"Spike técnico e verificação pesada"** (nova, após `/arc adr`) · "Como sei que estou funcionando" | O roteiro passa a descrever o que o papel já fazia na prática (spike aparecia só em `agents/architect.md` e `commands/arc.md`); três obrigações em ponteiro para skills §11–§13, mais o indicador "spike não trava" |
| `roles/architect/templates/adr.md` | Regras | Etapa de spike **inconclusiva por causa externa não sustenta decisão**: ADR fica em `Proposed` com a pendência nomeada, nunca `Accepted` sobre etapa não exercitada |
| `roles/architect/templates/compliance-review.md` | Regras | Rota (b) — reabertura por achado ⚠️/❌ — roda em modo leve declarado: só os passos reabertos; os demais carregam o resultado anterior **com ponteiro**, nunca ✅ de memória, e o gate de cobertura continua exigindo saída real |

### Por quê
Três modos de falha observados na sessão relatada. **(A)** Chamada externa sem limite no código do spike consome a janela inteira e devolve **nada** — nem resultado nem negativa; um "inconclusivo por causa externa" relatado em 45 s vale mais que 600 s de silêncio. **(B)** Sem checkpoint, corte de sessão transforma trabalho já produzido em zero, e a retomada paga tudo de novo — o custo que mais se repetiu no relato. **(C)** Sem modo leve declarado, todo follow-up pontual paga o preço da primeira entrega; sem os limites escritos, "leve" vira desculpa para aprovar sem evidência — que é o oposto do que o time é.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| **Arquiteto** | Spike com os três números declarados no relato; checkpoint por etapa em trabalho multietapa; follow-up leve com a linha de declaração — sem ela, é cobrado como verificação completa |
| **QA** | Ganha o que checar num spike/ADR: etapa inconclusiva por causa externa não pode aparecer sustentando decisão `Accepted`; resposta em modo leve sem a linha de declaração é achado |
| **SM** | Vê no relato do Arquiteto se a etapa fechou ou ficou inconclusiva, e leva a pendência ao quadro em vez de perdê-la na thread |
| **stakeholder** | Deixa de pagar janela inteira por chamada externa travada, e recebe a negativa explícita quando o provedor limita |

### Conflitos com o processo vigente
Nenhum. Aditiva e alinhada a R5 (interrupção é estado) e R7 (sem evidência, não aconteceu) — §13 reafirma R7 explicitamente em vez de abrir exceção a ela. Nada em `process/` foi tocado: a parte normativa geral é da entrada irmã do SM nesta mesma rodada.

### Como saberemos que funcionou
Nos próximos três spikes ou verificações pesadas do Arquiteto: **zero** travamentos sem relato (toda etapa termina concluída com saída real ou inconclusiva por causa externa nomeada); **100%** com arquivo de checkpoint citado na resposta; e pelo menos **uma** retomada que parte do checkpoint em vez do zero. Para §13, a queda no tamanho médio da segunda chamada sobre a mesma entrega — sem nenhum veredito de QA apontando aprovação sem evidência.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Extração/inserção — numeração de seção | `Select-String -Path roles\architect\skills.md -Pattern '^## \d+\.'` | §1–§13 em sequência contínua, sem número repetido; §11, §12 e §13 são as novas | ✅ |
| Substituição de padrão — alvo dos ponteiros novos | `Test-Path standards\README.md` · `Test-Path roles\architect\skills.md` | `True` · `True` — os destinos de `../../standards/README.md` (skills §11, §13) e `../skills.md` (adr.md, compliance-review.md) resolvem | ✅ |
| Substituição de padrão — leitura no contexto | `Select-String -Path roles\architect\*.md, roles\architect\templates\*.md -Pattern 'skills.md\) §1[123]\|modo leve\|inconclusiv\|checkpoint'` | 18 ocorrências: `README.md` 70/72/73/74/93, `skills.md` 125–162, `adr.md` 53, `compliance-review.md` 61 — cada uma lida no contexto: o ponteiro do README §11–§13 bate com a numeração real; o "checkpoint" de `README.md:93` é a linha nova de "Como sei que estou funcionando"; `adr.md:53` e `compliance-review.md:61` estão dentro das respectivas seções "Regras" | ✅ |
| Cobertura da instrução | leitura das três seções novas contra os itens A, B e C do roteamento | A → §11 (timeout, tentativas, teto, relato de causa externa); B → §12 (checkpoint por etapa, retomada); C → §13 (tabela completa × leve + quatro limites) — nenhum item sem seção, nenhuma seção sem verificação declarada | ✅ |
| Fronteira não aspiracional | `Select-String -Path standards\*.md -Pattern 'timeout\|resiliên\|retry\|circuit\|backoff' -i` | 3 ocorrências, nenhuma sobre a **borda de saída** (fila com retry interno, nível de log, semântica de `429` recebido) — a frase de fronteira de §11 apontava para um normativo inexistente e foi corrigida: aponta o documento de arquitetura do projeto e registra que ampliar `standards/` é mudança própria, por `/review` | ✅ após correção |

### Pendente do stakeholder
Duas propostas, **não aplicadas** (arquivos do stakeholder):

1. `agents/architect.md`, linha 65 — a única menção a spike fora de `roles/` diz só "spike de investigação que você desfaz depois". Proposta de redação: *"…ou (b) for um spike de investigação que você desfaz depois — com timeout curto e backoff limitado em toda chamada externa, checkpoint por etapa e relato de etapa inconclusiva por causa externa (skills §11–§13); nos dois casos, diga que fez."*
2. `commands/arc.md`, linha 4 do lembrete de limites — acrescentar ao fim: *"Spike com chamada externa: timeout e tentativas explícitos, checkpoint por etapa, e etapa que estourar as tentativas é relatada como inconclusiva por causa externa, nunca deixada travando."*

**Mudança de comportamento de agente só entra em vigor após reiniciar a sessão.**

---

## v3.8 — Harness do protótipo grava enquanto roda e mede o próprio escopo: checkpoint por tela e modo leve (R5 · R23) — 12/09/2026

> **Entrada irmã da mesma rodada de `/review note`** (consumo de sessão em uso intensivo, `feedback-plugin-team-consumo-sessao.md`). A parte geral — extensão de R3/R5 e a **R23** nova — está em `working-rules.md`, registrada em **v3.7** (SM); a parte do **Arquiteto** está em **v3.9**. Esta é a parte do **UX**. Renumerada pela curadoria do SM (de `v3.7-ux`, sufixo usado para evitar colisão entre agentes concorrentes, para `v3.8`) — a mesma curadoria arquivou `v3.6` e `v3.5` para respeitar o teto de três entradas quentes (R17) com as três aplicações desta rodada ocupando as posições mais recentes.

**Instrução:** *(stakeholder, via `/review note`)* Item de `note.md` sobre estouro de limite de taxa da conta em sessão intensiva, detalhado em `feedback-plugin-team-consumo-sessao.md`. Dois pontos roteados ao UX: **(B)** durante o harness headless completo do protótipo (todas as telas, todos os cliques, todos os critérios de aceite), salvar resultado parcial em disco a cada etapa concluída, para que um corte de sessão não descarte a verificação já produzida; **(C)** definir, para o UX, o que conta como modo "leve" de verificação em follow-up pequeno sobre protótipo já validado por harness completo — reduzindo só o escopo executado, sem abrir mão de evidência real nem de portão.

**Classificação:** comportamento de papel (roteiro + skill + formato de documento). A regra geral é do SM (R5 estendida e R23); aqui entra a **definição específica do UX** que a própria R23 delega a cada papel que faz verificação pesada.

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `roles/user-experience/skills.md` | **§10 nova** — "Verificar o protótipo sem pagar a verificação duas vezes" | Nomeia o *harness* como a evidência de R7 no papel; **checkpoint** append-only a cada tela/fluxo concluído, com as duas invalidações (versão do protótipo mudou · linha sem critério nomeado) e a retomada que só roda o que não tem linha; **modo leve** com tabela de escopo (primeira entrega e mudança transversal → completo; ajuste pontual → telas alteradas + vizinhança de um salto; alcance que não se consegue nomear → completo) e os quatro guarda-corpos (roda de verdade · o que não rodou é declarado · portão nenhum muda · três leves seguidas esgotam o modo) |
| `roles/user-experience/README.md` | `/ux prototype` | Passo **6 novo** (exercitar com harness no escopo declarado, gravando parcial a cada tela — R5/R23); antigos 6 e 7 passam a **7** e **8**; passo 7 agora exige o registro de verificação na ficha; parágrafo "modo leve não é atalho de aprovação" |
| | "O que respondo" | Saídas incluem o registro da verificação; Repertório aponta `skills.md` §10 |
| | "Como sei que estou funcionando" | Dois indicadores novos: verificação interrompida que não custou a verificação inteira; rodada leve que nomeia o que rodou e aponta a completa que cobre o resto |
| | "Documentos que administro" | Linha nova: registro de verificação do protótipo (vivo, `prototype/verification-log.md`) |
| `roles/user-experience/templates/functional-prototype.md` | Estrutura de arquivos · ficha · regras · falhas comuns | `verification-log.md` na árvore; bloco **"Registro de verificação (harness)"** na ficha (modo, por quê, rodadas leves consecutivas, telas executadas, qual completa cobre o resto, estado do checkpoint); formato do log append-only; duas regras novas; três falhas comuns novas |

### Por quê
O harness completo é a coisa mais cara que o papel executa — e, do jeito que estava, ele era **tudo ou nada duas vezes**: gravava só no fim (um corte de sessão descartava a verificação inteira) e rodava sempre inteiro (corrigir uma paleta de uma tela custava o protótipo todo). Nenhum documento do UX sequer nomeava a verificação executável, então as duas disciplinas não tinham onde morar. O risco simétrico — "leve" virando aprovação sem execução — é o que os quatro guarda-corpos e a regra das três rodadas cobrem: deriva que entra por soma de mudanças pequenas não aparece em nenhuma delas isolada.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| **UX** | Grava o parcial a cada tela/fluxo, não no fim; declara na ficha o modo, o alcance e o que **não** reexecutou; não usa leve em primeira entrega nem em mudança transversal |
| **SM** | Ganha objeto verificável para R5 e R23 no UX: o `verification-log.md` e o bloco da ficha |
| **QA / stakeholder** | Sabem, ao ler a ficha, o que foi exercitado nesta rodada e qual verificação completa cobre o restante — em vez de supor "tudo verificado" |

### Conflitos com o processo vigente
Nenhum. Aditiva e alinhada às regras gerais da mesma rodada (R5 estendida e R23, aplicadas pelo SM em `working-rules.md`). Não toca portão: o ① continua exigindo o stakeholder **navegando** o protótipo, e o modo leve é explicitamente proibido de justificar pulo de gate.

### Como saberemos que funcionou
Nas próximas três rodadas de verificação de protótipo: **zero** verificações interrompidas que precisem recomeçar da primeira tela (o log tem linhas anteriores ao corte); **100%** das rodadas leves declarando telas executadas + a completa que cobre o resto; e **nenhuma** rodada leve sobre mudança transversal. Indicador de custo: tempo/tokens de uma rodada de follow-up cai para a fração das telas tocadas, sem aumento de divergência encontrada na navegação do stakeholder no ①.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Extração/adição — contagem antes/depois | `git diff --numstat -- roles/user-experience` | `10/4` README · `37/0` skills · `27/0` functional-prototype | ✅ nada removido de conteúdo vigente; as 4 linhas trocadas no README são a renumeração dos passos e as duas linhas de tabela reescritas |
| Substituição de padrão — coerência do ponteiro novo | `Select-String -Path roles\user-experience\*.md,roles\user-experience\templates\*.md -Pattern 'verification-log'` | 8 ocorrências (README roteiro e tabela de documentos · skills §10 · template: árvore, ficha, formato do log, regras) | ✅ cada ocorrência lida no contexto: mesmo caminho `prototype/verification-log.md` nos três documentos |
| Substituição de padrão — citação da regra geral | `Select-String ... -Pattern 'R23'` | 5 ocorrências (README passo 6 e parágrafo do modo leve · skills §10 abertura e guarda-corpo 3 · template regra) | ✅ todas coerentes com o texto de R23 recém-aplicado pelo SM (*"cada papel define no próprio `skills.md`"*) |
| Checagem semântica da renumeração | `Get-Content roles\user-experience\README.md | Select-String '^\d\.'` na seção `/ux prototype` | passos **1–8**, sem repetição nem salto; nenhum outro documento cita "7 passos" do modo | ✅ |
| Checagem semântica da sequência de seções | `Select-String -Path roles\user-experience\skills.md -Pattern '^## '` | §1 a §10, sequenciais; README cita §8, §9 e §10 e as três existem | ✅ |

### Pendente do stakeholder
`commands/ux.md` (modo **prototype**) não cita a verificação executável nem o modo leve — o agente chega nisso pelo roteiro de `roles/user-experience/README.md`. **Proposta, não aplicada** (é arquivo do stakeholder, e cada palavra ali é carga fixa paga em toda invocação): acrescentar ao fim do item **prototype** do §3 a frase — *"Exercitar o protótipo com a verificação executável no escopo que a mudança pede (completo na primeira entrega ou em mudança transversal; leve no ajuste pontual — R23), gravando o parcial em `prototype/verification-log.md` a cada tela concluída (R5)."* Recomendação do papel: **aplicar**, por ser o único ponto onde a instrução chega sem depender de o agente abrir o roteiro — ou **não aplicar**, se a prioridade do período for encolher a carga fixa. Se faltar contexto para decidir, o SM traz a medida de footprint de `commands/ux.md` no próximo `/review metrics`.

**Resolvido em `v3.10`:** proposta aplicada em `commands/ux.md`, a pedido explícito do stakeholder.

---

## v3.7 — Consumo de sessão em uso intensivo: leitura incremental, checkpoint de verificação pesada, limite de paralelismo e modo leve de verificação — 12/09/2026

> **Parte geral desta rodada de `/review note`** (`feedback-plugin-team-consumo-sessao.md`). As aplicações de papel estão em **v3.8** (UX) e **v3.9** (Arquiteto) — cada papel acrescenta a própria entrada (`artifact-ownership.md`). **Curadoria:** renumerei as irmãs de `v3.7-ux`/`v3.7-arc` (sufixos anti-colisão) para `v3.8`/`v3.9`, e arquivei `v3.6`/`v3.5` para caber no teto de três entradas quentes (R17). De passagem, corrigi uma contagem de regras já defasada desde a v3.6.

**Instrução:** *(stakeholder, via `/review note` — item único de `note.md`, a partir de `feedback-plugin-team-consumo-sessao.md`)* relato de sessão de ~2 dias corridos que bateu o limite de taxa da conta Anthropic repetidas vezes. Quatro pontos couberam ao SM: **(1)** leitura incremental de documentos grandes em invocações consecutivas do mesmo papel; **(3, parte normativa)** checkpoint de progresso em verificação pesada de qualquer papel, não só construção; **(5, parte não conflitante)** orientação contra disparar 3+ papéis pesados em paralelo fora de fluxo que já prevê isso; **(6, parte normativa)** regra geral de modo "leve" de verificação. O conflito do Item 5 (paralelismo do `brainstorm`) já vinha **decidido pelo stakeholder**: mantido como está.

**Classificação:** regra (extensão de R3, extensão de R5, **R23 nova**) + fluxo (`workflow.md` §7, item novo).

### O que mudou

| Documento | Seção | Mudança |
|---|---|---|
| `process/working-rules.md` | R3 | Parágrafo **"Releitura incremental, quando aplicável"**: invocação consecutiva do mesmo papel sobre o mesmo tópico relê só o delta desde a última leitura (changelog curto, diff de seção, nota do que já foi visto); releitura plena só sem registro anterior ou após mudança extensa. "Evita" e "SM verifica" estendidos |
| | R5 | Parágrafo novo: a mesma regra cobre verificação pesada de **qualquer papel** (spike do Arquiteto, harness completo do UX) — resultado parcial salvo em disco a cada etapa concluída, não só ao final. "Evita" e "SM verifica" estendidos |
| | **R23 nova**, Bloco C | *Verificação plena na primeira entrega; modo leve em follow-up, nunca abaixo do piso de evidência.* Modo leve reduz **escopo**, nunca evidência (R7) nem gate do §8; cada papel que verifica (Arquiteto, UX) define "leve" no próprio `skills.md` — feito em `v3.8`/`v3.9`. Linha nova no "Resumo em uma tela" e nos indicadores de retrospectiva |
| `process/workflow.md` | §7, item **2a novo** | Quem orquestra evita disparar 3+ papéis pesados (Arquiteto, UX, verificação custosa) simultaneamente, fora de fluxo que já prevê isso por desenho (`brainstorm`, §5b) — **não revoga** o paralelismo do brainstorm, decisão já tomada pelo stakeholder |
| `README.md` (raiz) · `agents/scrum-master.md` | contagem de regras | Coerência de referência cruzada (exceção do `review-contract.md` — o SM aplica direto): "21 regras … R13-R21" → "23 regras … R13-R23". Já estava defasado desde a v3.6 (R22 existia e não tinha sido refletido); achado durante a reavaliação do conjunto desta entrada, não parte da instrução |
| `review-contract.md` | linha **UX** | Coerência de referência cruzada: PO e QA já listavam "os entregáveis que possui"; a linha do UX não citava `deliverables/prototype/`, embora o roteiro do UX o aponte como entregável próprio (confirmado: o caminho existe). Acrescentado, no mesmo padrão de PO/QA. Achado pelo Agent UX na reavaliação do próprio alcance em `v3.8`; aplicado pelo orquestrador do `/review note` na curadoria final por ser a exceção de referência cruzada |

### Por quê

Sintoma: sessão real de ~2 dias, ≈4,43M tokens de subagente, bateu o limite de taxa da conta repetidas vezes. Três causas no meu alcance: cada chamada relia documentos inteiros mesmo minutos depois da anterior sobre o mesmo tópico (R3 não cobria isso); verificação pesada perdia tudo num corte de sessão por falta de checkpoint (R5 só falava de construção); e nada impedia "leve" de virar desculpa para pular evidência num follow-up (R23 fecha essa fresta desde a origem). O paralelismo é orientação de orquestração, não regra de Task — por isso vai em `workflow.md`, não em `working-rules.md`.

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda |
|---|---|
| **Todos os papéis** | Ao serem reinvocados sobre o mesmo tópico, citam o delta desde a última leitura em vez de renarrar o documento inteiro (R3) |
| **Arquiteto · UX** | Verificação pesada salva resultado parcial em disco a cada etapa (R5); definem no próprio `skills.md` o que conta como "leve" (R23) — feito nesta mesma rodada, em `v3.8`/`v3.9` |
| **Quem orquestra** (`/team`, stakeholder) | Evita empilhar 3+ papéis pesados na mesma leva fora do `brainstorm` |
| **SM** | Verifica as três coisas na curadoria: nota de delta na releitura, artefato em disco de verificação pesada interrompida, e ausência de "leve" na primeira entrega de uma Task |

### Conflitos com o processo vigente

O Item 5 chegou com um conflito identificado pela triagem — o paralelismo do `brainstorm` (fase 1 PO+UX, fase 2 +Arquiteto) parecia contradizer a orientação pedida. **Já decidido pelo stakeholder antes desta aplicação:** o paralelismo do `brainstorm` fica como está; a orientação nova vale **fora** dele, e o texto de `workflow.md` §7 2a diz isso explicitamente. Os demais três pontos são aditivos, sem conflito com regra vigente.

### Como saberemos que funcionou

Nas próximas três invocações repetidas do mesmo papel sobre o mesmo tópico dentro de uma Task/sprint: a saída cita o delta, não o documento inteiro. Nenhuma verificação pesada perdida por corte de sessão sem artefato parcial em disco (ver indicador equivalente em `v3.8`/`v3.9`). Nenhuma leva de orquestração com 3+ papéis pesados fora do brainstorm, nas próximas 3 sessões de uso intensivo. Indicador indireto: queda no volume médio de tokens por subagente nas chamadas de retomada do mesmo papel, comparável ao ~507K/3-retomadas da thread de ADR relatado no feedback.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Extração/inserção — checagem semântica | leitura de R3, R5 e R23 em `working-rules.md` após a edição | os três parágrafos novos presentes, com "Evita"/"SM verifica" coerentes ao lado | ✅ |
| Checagem semântica | contagem de `^\| R\d+ \|` no "Resumo em uma tela" e de `^### R\d+\.` no corpo | **23 em ambos**, R1–R23, sem buraco nem duplicata | ✅ |
| Checagem semântica | leitura de `workflow.md` §7 após a edição | item 2a presente, cita §5b e a exceção do brainstorm explicitamente | ✅ |
| Substituição de padrão (coerência de referência cruzada, `review-contract.md`) | `Select-String 'R13-R21\|21 regras'` em `README.md`, `agents/scrum-master.md` | 2 ocorrências, ambas corrigidas para `R13-R23`/`23 regras`; zero restante | ✅ |
| Arquivamento (pré-condição de R17 — teto de 3 quentes) | `Compare-Object` dos blocos `## v3.4`, `## v3.5`, `## v3.6` movidos para `process-changelog-archive.md` × o texto original | idêntico nos três, fora do separador; índice de arquivadas ganhou as três linhas | ✅ |
| Teto de leitura | `^## v` no changelog quente após a mudança | 3 entradas: v3.7, v3.8, v3.9 | ✅ |

### Pendente do stakeholder

- **Ordem de exibição:** as três entradas (v3.7 SM, v3.8 UX, v3.9 Arquiteto) ficam em ordem crescente, não decrescente — concorrentes, sem "mais recente" real entre si; não movi os blocos grandes de UX/Arquiteto só por estética, para não arriscar erro de transcrição em conteúdo alheio. Reordenar é mecânico, se preferido.
- **Fecho da entrega:** carrega `v3.7`+`v3.8`+`v3.9` — sai como `vX.9.0` (R18), a mais alta das três.
- **Reiniciar a sessão** — não necessária para `working-rules.md`/`workflow.md`/`README.md` (sob demanda); **necessária** se `agents/scrum-master.md` for recarregado (contagem de regras mudou), e pelas propostas em `agents/architect.md`/`agents/developer.md` das entradas irmãs, quando aplicadas.
- `note.md`: item segue na fila até as três partes fecharem; remoção é do orquestrador do `/review note`, não minha.

**Resolvido em `v3.10`:** as propostas de `v3.8`/`v3.9` para `agents/architect.md`, `commands/arc.md` e `commands/ux.md` foram aplicadas pelo orquestrador do `/review note`, a pedido explícito do stakeholder.

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

---

## v3.3 — O canal do stakeholder é o PO; o broadcast acaba; prazo, plano e status mudam de dono — 08/09/2026

**Instrução:** *(stakeholder, direta)* "podemos remover o comando `/team <mensagem>` pois eu como stakeholder devo me relacionar com o PO prioritariamente pois ele controla as minhas demandas, mas posso levar questões ao Arquiteto ou UX diretamente. O SM como mantenedor do processo tem como responsabilidade o PDCA do processo… Um acerto é o prazo, ele também é definido pelo PO e não o SM, o PO recebe as estimativas das tarefas do time mas como o representante do Produto ele detém o plano de entrega. O SM é processo, organização e eficiência. No caso do `/team agreement` podemos direcionar o comando ao PO que deverá orquestrar os envolvidos." Mais três decisões por questionário: **árbitro pelo tipo do achado** para o degrau 2 do QA · **SM mantém os rituais**, e prazo/status/planejamento vão ao PO · o acordo vira **`/sm agreement`**, não broadcast.

**Classificação:** escopo de papel (governança: quem fala com quem, e quem detém prazo, plano e status) + comportamento de agente (dois modos removidos, dois criados) + fluxo (§6 escalação, §6a e §6b novas, §5e Planning) + propriedade de artefato (plano de entrega e status executivo ganham dono) + formato de documento (modelo de status muda de papel e de unidade).

**Uma proposta foi aceita com correção.** O stakeholder propôs que o **PO orquestrasse o acordo**. Isso foi apontado como conflito e a proposta virou **`/sm agreement`**: o achado que atravessa papéis é, com frequência, *"o requisito está errado ou a implementação está?"* — e nessa pergunta **o PO é parte**. Fazê-lo conduzir o julgamento do próprio artefato contraria o princípio que já sustenta a frente 2 do QA (§4a: *um autor não audita a própria omissão*) e a regra de que o dev não revisa os próprios normativos. **Quem facilita é o SM, porque não é dono de requisito, desenho nem evidência.** O stakeholder acatou.

### O que mudou

| Documento | Onde | O quê |
|---|---|---|
| `commands/team.md` | modos | **`consult` removido** — não há mais broadcast. Sem termo reconhecido, `/team` **roteia sem disparar agente**: demanda ao PO, técnica ao Arquiteto, tela ao UX, questão que atravessa a `/sm agreement`, ideia sem cobertura a `brainstorm`. **`agreement` removido** daqui |
| `commands/sm.md` · `agents/scrum-master.md` · `roles/scrum-master/README.md` | modos, mandato | **`agreement` criado** — facilitação, não broadcast: o SM identifica **quais papéis a questão toca** (2–3, nunca os seis), consolida uma recomendação e registra a divergência. **`status` removido** |
| `commands/po.md` · `agents/product-owner.md` · `roles/product-owner/README.md` | modos, mandato | **`status` criado.** O PO passa a ser declarado **o canal do stakeholder** e dono de **prazo, plano de entrega e status** |
| `templates/status.md` | `roles/scrum-master/` → **`roles/product-owner/`** | Muda de dono **e de unidade**: fala em **Histórias**, não em Tasks. "Entregue" é História **aceita na Review** (R21) — não Task fechada nem soma delas. Lê o Sprint Backlog do SM, não o edita |
| `templates/product-backlog.md` | **seção nova** | **Plano de entrega** — que Histórias saem em que sprint, com soma estimada, capacidade do SM e compromisso externo. Seção do backlog, **não documento novo**, para não haver duas verdades sobre prazo |
| `process/workflow.md` | **§6a nova** | *O canal do stakeholder é o PO.* Declara o que mudou de dono e por quê: **quem ordena o backlog por valor e é dono das Histórias é quem pode dizer quando o valor chega**. Ao SM fica a pergunta vizinha — **quanto cabe** |
| | **§6b nova** | *Achado que atravessa papéis — o QA roteia pelo objeto.* Tabela de objeto → dono, a regra de que **quem recebe e não é dono devolve**, e o porquê de não haver orquestrador |
| | §6 escalação | "dúvida de prioridade → SM" **vira** "prioridade, prazo, plano → PO" e "capacidade, fila, bloqueio → SM" |
| | §5e Planning | **O SM facilita, o PO decide o conteúdo**: passa a 7 passos — o PO seleciona (2) e o PO corta no limite (6); o SM confere a DoR e **apresenta a conta** da capacidade (5). *"O SM não veta escopo por valor e o PO não altera a conta de capacidade"* |
| | §5, §5c | Daily passa a `/po status`; "Consulta ao time" e "Acordo" viram uma linha só, `/sm agreement`; a tabela de custo por comando perde os dois broadcasts |
| `process/artifact-ownership.md` | matriz, §3 | **Plano de entrega** e **status executivo** entram com dono PO; o Sprint Backlog ganha a fronteira explícita (*quanto cabe, não quando sai*); **4 conflitos novos**, entre eles "stakeholder quer saber prazo → é do PO" e "SM quer tirar História por baixo valor → valor é do PO" |
| `roles/quality-assurance/README.md` | escada de falha | Degrau 2 **vira dois**: `2 · Outro dono` (o QA classifica pelo objeto e entrega) e `2b · Não consigo classificar` (raro — vai a `/sm agreement`) |
| raiz e `.team-project/` | `README.md`, `how-to.md`, `project-context.md`, `replicate-in-new-project.md` | Superfície de comandos, seção "com quem o stakeholder fala", escada de falha e o bloco fixo §8 |

**Modo de falha que evita:** duas cabeças respondendo *quando o valor chega*. O SM detinha "prazos" enquanto o PO ordenava o backlog por valor e era dono das Histórias — e o stakeholder tinha seis interlocutores para uma pergunta que tem um dono. Também mata a via mais cara do time: o broadcast que reunia seis papéis para uma pergunta que quase sempre tinha um só.

**Quem passa a ser cobrado de forma diferente:** o **PO** (ganha prazo, plano de entrega e status, e passa a ser o canal); o **SM** (perde prazo e status, ganha a facilitação de acordo e a ênfase em rituais); o **QA** (roteia pelo objeto em vez de convocar o time); o **stakeholder** (fala com o PO, e com Arquiteto/UX quando quiser).

**Indicador de sucesso:** nenhum pedido de prazo ou status respondido pelo SM; nenhum acordo facilitado que tenha chamado papel que a questão não tocava; nenhuma História no Sprint Backlog escolhida por outro que não o PO.

### Evidência (R19)

| Classe | Comando | Resultado |
|---|---|---|
| Arquivamento | `Compare-Object` do bloco `## v3.0` movido × `git show HEAD` | **67 × 67 linhas, diff = 0.** Índice de arquivadas ganhou a linha `v3.0` |
| Renomeação | `git mv roles/scrum-master/templates/status.md → roles/product-owner/templates/status.md` | rename detectado pelo git; conteúdo reescrito para a unidade História |
| Substituição de padrão | `/team <mensagem>` · `/team <questão>` · `/team agreement` · `/sm status` · `prazo é do SM` | **0 ocorrências** de cada, fora dos changelogs |
| **Checagem semântica** | leitura de cada tabela de comando e de cada escada de falha | a tabela do `/team` em `how-to.md` usava `<ID>` e **não casou** com a substituição automática — pego na leitura, corrigido à mão. Idem a linha de estrutura `scrum-master/ processo, quadro, status` no `README.md` |
| Ponteiros | varredura de todo `](….md)` relativo | **0 quebrados** *(1 falso positivo conhecido: link dentro do bloco gerado de `project-context.md`)* |
| Encoding | decodificação UTF-8 estrita de todo `*.md` | **0 arquivos inválidos** |

### Pendente do stakeholder

- **Fecho da entrega:** passa a **`v3.3.0`** — carrega quatro entradas de processo (v3.0, v3.1, v3.2, v3.3).
- **Reiniciar a sessão** — `agents/` e `commands/` mudaram.
- ~~**`impact-analysis.md` continua no SM**~~ — **resolvida no addendum abaixo.**

### Addendum — 08/09/2026 · a análise de impacto migra ao PO

*(Anexado, não reescrito — R17. Resolve a pendência que esta mesma entrada declarou; não corrige nada acima.)*

**Instrução:** *(stakeholder, direta)* "sim, migra também."

**O que mudou:** `templates/impact-analysis.md` sai de `roles/scrum-master/` e vai para `roles/product-owner/` (`git mv`); **`/sm impact` vira `/po impact <mudança>`**. O objeto da análise é o **plano de entrega** — manter a análise no SM deixaria o dono do plano sem o instrumento que o altera.

**A fronteira que não migrou.** O template passa a declarar **três insumos com dono explícito**, e o PO **consolida sem inventar nenhum**: quadro, capacidade e "o que sai para caber" vêm do **SM**; retrabalho, contrato e migration vêm do **Arquiteto**, porque **o PO não decide "como"**; risco e recomendação são dele. Regras novas: *"não invente insumo técnico — estimar retrabalho sem o Arquiteto é opinião com aparência de número"* e *"não recalcule capacidade — a conta é do SM"*.

**Por que isto não contradiz o `/sm agreement` desta mesma entrada.** Lá o SM facilita porque há **disputa** e o PO seria **parte** (*"o requisito está errado ou a implementação está?"*). Aqui **não há disputa**: é a análise de uma mudança a um plano que é do PO. **Reunir insumo para informar a própria decisão não é arbitrar** — arbitrar é decidir entre duas partes, e o PO não está julgando ninguém. A distinção está escrita nos dois documentos, para que a próxima leitura não os veja como contraditórios.

**R13 se divide, e continua coerente:** **nomear o instrumento é do SM** — método é o domínio dele, e ele **sinaliza o gatilho** de controle integrado de mudanças; **conduzir a mudança de baseline é do PO**, porque a baseline vive no plano de entrega. Refletido em `skills.md` §9, `working-rules.md` R13, `commands/{sm,po}.md` e nos dois roteiros.

**Evidência (R19):** `git mv` detectado como rename; **`grep '/sm impact'` fora dos changelogs = 0**; a **leitura no contexto** pegou três ocorrências que a substituição de padrão não casaria — o título da seção no roteiro do SM, a linha da tabela de documentos dele e o texto de `skills.md` §9, todos reescritos à mão para a divisão insumo/instrumento. **Sem bump de versão:** a entrega segue `v3.3.0`, porque isto completa uma decisão já registrada, não abre uma nova.

---

## v3.2 — A métrica de eficiência para de medir história fria; o `/review` sai do caminho quente — 08/09/2026

**Instrução:** *(stakeholder, direta)* "faça uma revisão de processo geral e otimização sempre com o objetivo de otimizar o gasto com tokens e garantia de qualidade do processo e do produto desenvolvido pelo time."

**Classificação:** formato de documento (extração de conteúdo frio do caminho quente) + regra (a métrica de §5c e os indicadores de retrospectiva mudam de definição). Nenhum fluxo, cerimônia, portão ou propriedade de artefato alterado — **a garantia de qualidade não foi tocada**, e a auditoria abaixo confirma que continua íntegra.

### Medição — a fase Check do PDCA (§5c)

| Papel | Carga fixa antes | Carga fixa depois | Δ |
|---|---|---|---|
| scrum-master | 13,5 KB | 12,7 KB | −6% |
| product-owner | 10,4 KB | 10,0 KB | −4% |
| architect | 10,9 KB | 9,8 KB | −10% |
| user-experience | 11,2 KB | 10,7 KB | −4% |
| developer | 7,4 KB | 6,9 KB | −7% |
| quality-assurance | 10,2 KB | 9,6 KB | −6% |
| **Total** | **63,6 KB** | **59,7 KB** | **−6%** |

Custo de um broadcast `/team <mensagem>`: **69 KB** (os seis fixos + `commands/team.md`), antes de qualquer leitura de `.team-project/`. É a operação mais cara do time por uma ordem de grandeza.

### O que mudou

| Documento | Onde | O quê |
|---|---|---|
| `agents/{scrum-master,product-owner,architect,user-experience,quality-assurance}.md` | seção final | A seção "Evolução dos seus documentos" **era duplicação literal** de `review-contract.md` §"Alcance por papel" — inclusive os "cuidados do Arquiteto sobre `standards/`", quase palavra por palavra. Reduzida a **um parágrafo** que aponta para o contrato e preserva a única regra que precisa ser lida antes dele: *escreva na RAIZ, nunca em `${CLAUDE_PLUGIN_ROOT}`*. **−1,9 KB de caminho quente, zero informação perdida** |
| `commands/{po,arc,qa,ux,dev,sm}.md` | seção final | O parágrafo "Evolução dos documentos do X — não é aqui" repetia o que o `review-contract.md` já diz. Comprimido a **uma linha de roteamento** (`/X review …` → `/review …`), que é a única parte usada em tempo de invocação. As instruções operacionais ("ao receber o veredito/relatório…") foram **preservadas na íntegra** |
| `process/workflow.md` | §5c, "Métrica por papel" | **Passa a ser dois números, nunca somados:** *carga fixa* (`agents/` + `commands/`, paga em toda invocação) e *conjunto sob demanda* (`roles/<papel>/`, **sem os changelogs**). Seção nova ordenando onde o corte rende mais, e o custo do broadcast declarado |
| `process/working-rules.md` | indicadores | A linha única de footprint vira **duas**, alinhadas à métrica nova |
| `templates/retrospective.md` | métricas | Idem: carga fixa e conjunto separados; o teto de entrada de changelog (R17) vira linha própria |
| `review-contract.md` | `/review metrics` | O giro **Act** passa a exigir os dois números separados, e a preferir a remoção na carga fixa |

**O defeito que a métrica tinha.** `roles/scrum-master/` mede **320,9 KB**, dos quais **159,4 KB (50%) são o changelog arquivado** — frio por construção (só lido em `/review history`) e **monotonicamente crescente por decisão do próprio processo**, já que R17 manda arquivar em vez de apagar. Contra ~30 KB dos outros papéis, o SM aparecia dez vezes mais pesado por causa de história que ninguém carrega. O giro **Act** apontaria sempre para o SM e nunca para o desperdício real, que estava nos 63,6 KB de carga fixa. **Métrica errada não deixa de corrigir — dirige o corte para o lugar errado**, e teria custado ao time um giro inteiro de PDCA cortando o documento errado.

**Modo de falha que evita:** o ciclo de eficiência otimizar o que não custa e ignorar o que custa. É o análogo, para o processo, do que R7 evita no produto: decidir sem medir o que importa.

**Quem passa a ser cobrado de forma diferente:** o **SM** (reporta dois números na retrospectiva, não um) e **todo papel** no `/review metrics`.

**Indicador de sucesso:** a carga fixa total não volta a subir sem regra ou cerimônia nova que a justifique; o próximo `/review metrics` propõe remoção na carga fixa, não no conjunto sob demanda.

### Auditoria de qualidade — o que foi verificado e está íntegro

| Verificação | Resultado |
|---|---|
| Toda regra tem forma de verificação ("SM verifica") | **21/21** |
| Contagem declarada × real de regras | 21 × 21, e 21 linhas no resumo |
| Modelo órfão (template que ninguém referencia) | **0** |
| Links `.md` quebrados | **0** *(1 falso positivo: link dentro do bloco markdown gerado de `project-context.md`)* |
| Portões, gates, DoR/DoD, escada de falha, seis frentes do QA | **inalterados** — nenhum controle de qualidade foi removido nesta entrada |

### Evidência (R19)

| Classe | Comando | Resultado |
|---|---|---|
| Arquivamento | `Compare-Object` do bloco `## v2.11` movido × `git show HEAD` | **53 × 53 linhas, diff = 0.** Índice de arquivadas ganhou a linha `v2.11` |
| Extração | tamanho de `agents/` + `commands/` antes e depois | 63,6 KB → 59,7 KB (−6%); por papel, na tabela acima |
| **Integridade da extração** | `grep` de "Alcance por papel" e dos 5 papéis em `review-contract.md`; `grep` do roteamento `/X review` nos 6 comandos | contrato cobre **5/5** papéis e os cuidados de `standards/`; roteamento preservado em **6/6** comandos |
| **Encoding** | contagem de mojibake (`Ã`, `â€`, `Â`) em `agents/` e `commands/` | **0.** Uma primeira tentativa da extração usou `Get-Content` (ANSI no PS 5.1) com `WriteAllLines` (UTF-8) e **corrompeu 5 arquivos por dupla codificação** — detectado porque os *bytes subiram enquanto as linhas caíam*; revertido com `git checkout` e refeito com `ReadAllText`/`WriteAllText` |
| Auditoria | varredura de regras sem verificação, modelos órfãos, contagens e links | tabela acima |

### Pendente do stakeholder

- **Fecho da entrega:** a entrega passa a **`v3.2.0`** — carrega três entradas de processo (v3.0, v3.1, v3.2).
- **Reiniciar a sessão** — `agents/*` e `commands/*` mudaram.
- **Não aplicado, proposto:** o bloco fixo §8 do `.team-project/README.md` custa **2,6 KB lidos por todo papel em toda invocação**. Cortá-lo exige decidir o que o agente precisa saber de cor sobre a superfície de comandos — é a maior economia restante, e é sua a caneta sobre esse bloco.

### Addendum — 08/09/2026 · correção do custo de broadcast

*(Anexado, não reescrito — R17. A entrada acima fica como foi registrada.)*

O número **"69 KB por broadcast"** registrado acima **está errado**. Ele somava os seis arquivos de `commands/` à carga do broadcast, e eles **não são carregados ali**: `commands/<x>.md` entra no **contexto principal** quando o stakeholder digita `/x`; `agents/<papel>.md` entra no contexto do **subagente**. Um broadcast carrega `commands/team.md` **uma vez** mais um `agents/<papel>.md` por subagente — nunca os seis arquivos de comando.

**Valores corretos:** `/team <mensagem>` = **47,9 KB** · `/team agreement` = 55,1 KB · `/team brainstorm` = 36,6 KB · `/team cycle` = 27,6 KB. A ordem de grandeza e a conclusão não mudam — o broadcast continua sendo a operação mais cara —, mas o número estava 44% acima do real.

**O que a correção acrescentou ao normativo:** `workflow.md` §5c passou a declarar **onde cada arquivo é carregado** (principal × subagente), a tabela de custo por comando, e as **três coisas que a carga fixa não mostra** e costumam dominar o custo real — o **modelo** de cada agente (`/arc` e `/ux` em Opus, `/dev` em Haiku: `/arc` carrega menos que `/sm` e custa mais), a **leitura em tempo de execução** (que costuma superar a carga fixa e é multiplicada pelo número de subagentes) e o **retorno das respostas** ao contexto principal na consolidação.

**Como foi detectado:** o stakeholder perguntou quais são os comandos mais caros do time; a conta refeita papel a papel não fechou com o registrado. **Modo de falha que isto expõe:** medir sem declarar *onde* cada arquivo é carregado produz número plausível e errado — e a v3.2 é exatamente uma entrada sobre não confiar em métrica mal definida.

---

## v3.1 — Protótipo funcional em HTML vira entregável e pré-condição do portão ①; o Sprint Backlog ganha o próprio nome — 08/09/2026

**Instrução:** *(stakeholder, direta)* "nos documentos do team-project está faltando o SprintBacklog; a elaboração do protótipo funcional em html também é entregável e requisito antes de aprovar a sdd funcional."

**Classificação:** entregável novo (protótipo funcional) + regra (R15 ganha a pré-condição do ①) + fluxo (§5b, §5, §8) + propriedade de artefato (o protótipo deixa de ser "exploração" e vira entregável do UX) + formato de documento (modelo novo, renomeação do quadro) + escopo de papel (o UX passa a ter entregável que **bloqueia um portão**).

**Complementa a [`v3.0`](#), não a corrige.** A v3.0 fica como está (R17: entrada nunca é reescrita); o que ela descreveu como "portão ① — o stakeholder aprova o SDD funcional" passa a exigir, a partir daqui, **protótipo navegado**.

### O que mudou

| Documento | Onde | O quê |
|---|---|---|
| **`deliverables/prototype/README.md` novo** | — | O **protótipo funcional** como entregável: por que vem antes do ①, a tabela que o distingue do protótipo de tela do ③, as 7 exigências, o que ele **não** é, os critérios verificados no portão e como ele vence quando a fatia fecha |
| **`roles/user-experience/templates/functional-prototype.md` novo** | — | Estrutura de arquivos (`index.html` + `flows/` + `assets/`, sem build) e a **ficha** com a tabela fluxo × caminho completo, os requisitos representados, o "fora", as premissas e o **registro datado da navegação do stakeholder** |
| `process/working-rules.md` | **R15** | Título e corpo ganham "o ① com protótipo navegado". O modo de falha evitado passa de três para quatro: *o stakeholder aprovar por escrito um produto que só vai **ver** depois de construído* — o mais caro dos quatro, porque o retrabalho já é código. "SM verifica" ganha a exigência do registro de navegação |
| | indicadores | Linha nova: portão ① sem protótipo, sem registro datado de navegação, ou com fluxo principal de `02-flows` sem caminho no protótipo → **o ① foi aprovado por leitura** |
| `process/workflow.md` | §2, §5, §5b, §8 | O diagrama da cadeia mostra o protótipo antes do ①; cerimônia nova na tabela de §5; a transição do brainstorm ganha a linha do protótipo e o ① passa a ler "o stakeholder **NAVEGA** o protótipo e aprova"; §8 ganha **duas** linhas de gate (o protótipo existe · o ① com protótipo navegado); "como o SM verifica" do §5b exige o registro |
| `process/artifact-ownership.md` | matriz, §2 | A linha "Protótipos \| UX \| Exploração, não código de produção" **vira duas**: o **protótipo funcional** (entregável, pré-condição do ①) e os **protótipos de tela e explorações** (portão ③, que **não substituem** o primeiro). O fluxo de §2 mostra o UX no ramo do ① |
| `roles/user-experience/` | README, `/ux prototype` | O modo se desdobra: **`/ux prototype` sem argumento** é o protótipo funcional (7 passos, incluindo conduzir a navegação e registrar); **`/ux prototype <tela>`** continua sendo exploração de tela. Tabela de documentos ganha o entregável |
| `agents/user-experience.md` · `commands/ux.md` | descrição, responsabilidades, modos | O protótipo funcional vira a **responsabilidade 1** do papel; `argument-hint` e a descrição do agente passam a nomeá-lo *(propriedade do stakeholder — aplicado por instrução direta dele)* |
| `deliverables/README.md` | conjuntos, ordem, propriedade | Conjunto novo na tabela; o ① passa a ler "NAVEGA o protótipo e aprova"; linha nova em "por que o portão ① existe"; o protótipo entra na matriz de propriedade (dono UX, revisa stakeholder) |
| **Sprint Backlog** | `templates/work-board.md` → **`sprint-backlog.md`** | O achado do stakeholder: a v3.0 renomeou o **título** do quadro para "Sprint Backlog" e deixou o **arquivo** como `work-board.md`, de modo que em `.team-project/scrum-master/` o artefato central do sprint continuava com o nome antigo. `git mv` + 9 arquivos reapontados, incluindo o manifesto e o passo 7 do `team-update.md` |
| `.team-project/` | estrutura | `user-experience/` ganha `prototype/`; `scrum-master/` passa a listar `sprint-backlog.md`. Refletido em `team-init.md`, `project-context.md`, no manifesto `deliverables/team-project/` e no `README.md` da raiz |

**Modo de falha que evita:** o stakeholder aprovar `00`/`01`/`02` **lendo** e descobrir a divergência só quando o produto existe. A divergência entre o que ele imaginou e o que o time entendeu aparece sempre na primeira vez que ele atravessa o fluxo; a única variável é quanto já foi construído até lá. O protótipo antecipa esse momento para o ponto em que o descarte custa HTML, não arquitetura e código.

**Quem passa a ser cobrado de forma diferente:** o **UX** (ganha um entregável que **bloqueia** um portão, e a obrigação de conduzir a navegação, não de apresentar); o **stakeholder** (não aprova o SDD funcional sem navegar); o **Arquiteto** (não começa o SDD técnico sem o registro de navegação); o **SM** (passa a verificar o registro datado como parte de R15).

**Indicador de sucesso:** todo portão ① com registro datado de navegação e com 100% dos fluxos principais de `02-flows-and-roles` cobertos; nenhuma ocorrência de "aprovado sem navegar" nas retrospectivas.

### Conflitos resolvidos

| Conflito | Com que regra | Resolução |
|---|---|---|
| `artifact-ownership.md` dizia "Protótipos — exploração, **não** entregável" | a instrução do stakeholder diz que é entregável | A linha virou **duas**: o funcional é entregável; o de tela segue exploração. Nenhuma das duas verdades foi apagada |
| O detalhamento da História (③) já exigia protótipo | R20 · DoR da História | São **dois protótipos com escopos diferentes** — produto × tela —, e a tabela de `deliverables/prototype/README.md` declara a distinção para que um não seja usado como desculpa para não fazer o outro |
| "Protótipo é descartável" × "protótipo é entregável" | — | Convivem: é entregável **e** descartável. A ficha marca **vencido** quando a fatia fecha, e a verdade passa a ser o produto |

### Evidência (R19)

| Classe | Comando | Resultado |
|---|---|---|
| Arquivamento | `Compare-Object` do bloco `## v2.10` movido × `git show HEAD:…/process-changelog.md` | **62 × 63 linhas, diferença = 1 linha em branco final**; conteúdo idêntico. Índice de arquivadas ganhou a linha `v2.10` |
| Substituição de padrão | `work-board.md` → `sprint-backlog.md` (+ `git mv` do modelo) | 9 arquivos alterados; **`grep 'work-board'` fora dos changelogs = 0** |
| **Checagem semântica** | leitura das linhas de estrutura do `.team-project/` e das tabelas de comando em cada arquivo | `README.md` da raiz tinha a árvore de `roles/` com `work-board`, fora do padrão de caminho — pego na leitura, não pelo `grep` de caminho |
| Extração / criação | `deliverables/prototype/README.md`, `templates/functional-prototype.md` | 2 novos, referenciados de `deliverables/README.md`, da matriz de propriedade, do README e do agent do UX |
| Ponteiros | varredura de todo `](…​.md)` relativo contra o disco | **1 link quebrado real encontrado e corrigido**: o manifesto `deliverables/team-project/README.md` apontava `sdd/README.md` e `implementation/README.md` como se estivesse em `deliverables/` — corrigidos para `../sdd/` e `../implementation/`. Restante: 0 |
| Manifesto | `claude plugin validate . --strict` | passou |

### Pendente do stakeholder

- **Fecho da entrega:** a entrega passa de `v3.0.0` para **`v3.1.0`** — carrega **duas** entradas de processo (v3.0 e v3.1), como a v2.9.0 carregou três. Bump e entrada única no `CHANGELOG.md` (R18), na branch `feat/v3.0.0`.
- **Reiniciar a sessão** — `agents/user-experience.md` e `commands/ux.md` mudaram.
- **Nome da branch:** continua `feat/v3.0.0` embora a entrega saia como `v3.1.0`. Renomear ou aceitar a divergência é decisão sua; a entrada do `CHANGELOG.md` nomeia a branch real.

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
