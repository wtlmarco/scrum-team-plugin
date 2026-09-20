# Changelog de Entregas

> Versionamento de **entrega** do plugin, no padrão `vMAJOR.MINOR.PATCH` (`v2.x.y`).
> **Não confundir** com o [changelog do processo](roles/scrum-master/process/process-changelog.md) (`vX.Y`), que registra a evolução interna das regras de trabalho do time — esse é alimentado pelo `/review`.
>
> **Como funciona uma entrega:**
> 1. Branch `fix/vX.Y.Z` ou `feat/vX.Y.Z` a partir de `develop` — ou empilhada sobre a branch de uma entrega anterior ainda não mesclada, quando há dependência entre elas.
> 2. As correções/mudanças da entrega vão nessa branch.
> 3. PR para `develop` para aprovação. `main` recebe `develop` quando o stakeholder decide consolidar a linha estável, fora do ciclo por-entrega.
> 4. Uma entrada aqui, mais recente no topo, com **o que foi entregue**, **a branch** (e a base, se empilhada).
>
> `MAJOR.MINOR` acompanham a versão do changelog do processo quando a entrega inclui mudança de processo; `PATCH` (`vX.Y.1`, `vX.Y.2`…) é correção sobre a mesma linha.

---

## v3.24.0 — 2026-09-20

**Branch:** `feat/v3.24.0` a partir de `develop` (v3.23.0 já mesclada — PR #21). **PR** para `develop`.

**MINOR de processo.** Carrega a entrada nova [`v3.24`](roles/scrum-master/process/process-changelog.md) — `vX.Y.0` (R18). Fecha os **cinco** itens de `RAIZ/note.md` sobre modos de trabalho, num desenho diferente do pedido literal e decidido assim pelo stakeholder: em vez de o time sumir do portão ① até o MVP, os gates são **agregados na fronteira do sprint**. O termo "automode" não existe — há um jeito só de trabalhar.

### O que entrou

- **R25 (nova):** o sprint é a unidade de aprovação e de entrega. O stakeholder tem **dois compromissos por sprint** e nenhum acionamento entre eles.
- **Portão ③ em lote, depois da Planning**, sobre um **pacote navegável**: Sprint Backlog + critérios de aceite + **protótipo costurado do sprint** + `planning.md` (que declara o que veio da Review anterior e **não** entrou, com o motivo). **R20 reescrita**; o guarda-corpo passa a ser "nenhuma Task em construção antes do pacote aprovado".
- **R21 restaurada.** O portão ④ sempre foi do stakeholder: o PO **conduz** o aceite e escreve o dossiê, ele **decide**, por História.
- **Bloqueio em dois degraus:** varredura na Planning; no sprint, **PO e Arquiteto conversam**; só o que eles não fecham sobe ao stakeholder (R22). Decisão estratégica escala direto.
- **Valor real por sprint:** critério de seleção do PO, verificado pelo protótipo — se nenhum fluxo se atravessa, o corte é refeito antes de o sprint arrancar.
- **Registro de execução por sprint:** `.team-project/sprints/<n>/` com **dono declarado por subpasta** (§1e) — `stories/` PO, `plan/` Arquiteto, `evidence/` QA, o resto SM. `sprint-backlog-snapshot.md` e o par vivo+archive do consumo deixam de existir.
- **Retrospectiva** ganha o consumo por papel em seção própria e os **sintomas de processo** para o `note.md` do plugin.
- **Comandos:** `/team cycle sprint` e `/ux prototype sprint <n>` novos; `team-init.md` deixa de semear a estrutura antiga; `team-update.md` ganha o **passo 7a** de migração estrutural; `how-to.md` ganha a seção do ciclo do sprint; 31 ponteiros de caminho corrigidos.

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.24.0`. Contagem de regras **24 → 25** nos três lugares (`working-rules.md`, resumo, `agents/scrum-master.md`); gates do §8 **19 → 21**. Arquivamento de `v3.21` (teto de 3 entradas, R17). Bloco de evidência R19 completo na entrada `v3.24`, incluindo o **desvio declarado**: o trabalho foi aplicado sobre `develop` em v3.19 sem conferir as branches remotas, e o rebase sobre `origin/develop` preservou integralmente os dois giros Act das `v3.22`/`v3.23`.

**Mudança de comportamento de agente/comando se aplica** — `agents/` e `commands/` foram tocados: só valem depois de reiniciar a sessão, e só chegam aos projetos depois de `git push` + `claude plugin marketplace update` + `claude plugin update`.

**Migração obrigatória nos projetos que já usam o time:** o passo **7a** de `team-update.md` move o registro de execução para `.team-project/sprints/<n>/`. Sprint fechado migra o caminho sem alterar conteúdo; sprint em andamento termina no formato antigo.

---

## v3.23.0 — 2026-09-18

**Branch:** `fix/v3.23.0` — a mesma branch das entradas `v3.22.0`, `v3.21.0` e `v3.20.0` abaixo, renomeada a cada giro absorvido. **PR** para `develop`. A entrega carrega **quatro** entradas de processo; a `version` acompanha a mais recente (R18).

**MINOR de processo.** Carrega a entrada nova [`v3.23`](roles/scrum-master/process/process-changelog.md) — **segundo giro Act** consecutivo, pedido pelo stakeholder depois de ler o saldo do primeiro.

### O que entrou

- **A tabela de indicadores da retrospectiva parava de dizer algo novo em 13 das 23 linhas.** Cada regra de `working-rules.md` já traz a própria linha `**SM verifica:**`; a tabela "Como o SM aplica" repetia essa verificação regra a regra, e em 13 linhas a coluna "Alerta" era tautológica — *"qualquer ocorrência → Rnn ignorada"*, que não é limiar, é a definição de violar a regra. As 13 foram **colapsadas numa linha** que nomeia as regras cobertas e aponta para a verificação onde ela é escrita. As outras 10, que têm limiar de verdade (`> 2`, `> 30%`, `> 2×`, `recorrente`), ficaram intocadas.
- **Verificado antes de cortar, uma a uma:** cada uma das 13 está integralmente coberta pela linha "SM verifica" da sua regra — inclusive a cláusula que a `v3.21` acabara de acrescentar a R20. Nenhuma verificação perdida; saiu a segunda cópia.
- **A carga fixa foi varrida primeiro** (é o primeiro lugar da lista de §5c) e sobraram só dois blocos duplicados em 3+ arquivos, ambos legítimos — viraram proposta ao stakeholder, não corte, conforme §5c.

### Saldo do giro

| Medida | Antes | Depois | Δ |
|---|---:|---:|---:|
| `working-rules.md` | 40,20 KB | **37,74 KB** | **−2,46 KB (−6,1%)** |
| Tabela "Como o SM aplica" | 5,90 KB | **3,31 KB** | −2,59 KB (−44%) |
| `roles/scrum-master/` (sem changelogs) | 198,6 KB | **196,2 KB** | −2,4 KB |

O corte é **4,6× o do giro anterior** (−2,46 contra −0,54 KB), e veio de procurar redundância estrutural em vez de texto obsoleto.

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.23.0`. Integridade estrutural conferida: `^### R\d+\.`, `^\| R\d+ \|` e `^\*\*SM verifica` continuam dando **24, 24, 24**. Arquivamento de `v3.20` para `process-changelog-archive.md` (teto de 3 entradas). Bloco de evidência R19 completo na entrada `v3.23`.

**Desvio corrigido no fecho:** as edições por script deste giro e do anterior usaram `Set-Content -Encoding utf8`, que no PowerShell 5.1 grava BOM — três arquivos de `process/` ficaram com BOM enquanto os outros 16 não tinham. Removido, conteúdo conferido intacto. Registrado na entrada `v3.23` com a lição de método.

**Mudança de comportamento de agente/comando não se aplica** — nenhum `agents/`/`commands/` foi tocado nesta entrada.

**Pendente, registrado e não aplicado:** dois blocos duplicados na carga fixa — o ponteiro do `review-contract.md` (421 chars × 5 `agents/*`) e o gancho do formulário de R22 (403 chars × 4 `commands/*`, criado na `v3.20`). ~1,3 KB somados. §5c manda propor, não aplicar; texto na entrada `v3.23`.

---

## v3.22.0 — 2026-09-18

**Branch:** `fix/v3.23.0` (aberta como `fix/v3.21.0`, renomeada) — a mesma branch das entradas `v3.21.0` e `v3.20.0` abaixo. **PR** para `develop`. **Esta entrega carrega três entradas de processo** — `v3.20`, `v3.21` e `v3.22` —, cada uma com entrada própria aqui; a `version` acompanha a mais recente (R18).

**MINOR de processo.** Carrega a entrada nova [`v3.22`](roles/scrum-master/process/process-changelog.md) — o **giro Act do ciclo de eficiência** (`workflow.md` §5c), disparado por `/review metrics`.

### O que entrou

- **Footprint remedido.** Primeira remedição desde a `v3.16` (14/09/2026). Carga fixa do grupo: **71,9 → 76,7 KB (+6,7%)** em quatro dias e cinco versões de processo, **sem nenhuma remoção registrada** — foi esse o gatilho de Act fora de cadência, não o limiar de 20% por papel (que ninguém cruzou). Por papel: PO 17,7 · SM 16,4 · UX 11,8 · QA 11,7 · Arquiteto 11,4 · dev 7,7. O **conjunto sob demanda** ganhou a primeira medição por papel, que vira linha de base: SM 198,3 · PO 54,2 · UX 47,1 · Arquiteto 44,1 · QA 39,1 · dev 22,0 KB.
- **A remoção do giro: a arqueologia do `consult` sai de `workflow.md` §5c.** §5c era a maior seção do arquivo (9,2 de 59,4 KB) e carregava três parágrafos sobre um comando que não existe mais em lugar nenhum do repositório — a seção que existe para impedir inchaço era a mais inchada dele. A regra viva que essa história produziu ("chame só quem a questão toca", passo 1 do `/sm agreement`) foi preservada e reescrita como norma; o resto saiu.
- Arquivamento de `v3.19` para `process-changelog-archive.md` (teto de 3 entradas), verificado: 57 linhas relocadas, zero fora do separador.

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.22.0`. Nenhuma regra nova — a contagem segue em **24**. Nenhum comportamento mudou: a entrada é remoção de texto morto, sem regra, gate ou verificação alterados. Bloco de evidência R19 completo na entrada `v3.22` do changelog do processo.

- **Segunda remoção, autorizada pelo stakeholder: o parágrafo "Registro de consumo" comprimido nos 7 arquivos de `commands/`.** Estava duplicado quase palavra por palavra; a instrução inteira foi preservada e saiu a explicação repetida. Por arquivo: ~516 → ~316 chars (−39%). **Carga fixa do grupo: 76,7 → 75,3 KB (−1,4 KB, −1,8%).**

### Saldo do giro

| Medida | Início | Fecho | Δ |
|---|---:|---:|---:|
| Carga fixa do grupo | 76,7 KB | **75,3 KB** | **−1,4 KB** |
| `workflow.md` §5c | 9,20 KB | **9,00 KB** | −0,20 KB |
| `roles/scrum-master/` (sem changelogs) | 198,8 KB | **198,6 KB** | −0,2 KB |

### Verificação adicional

A proposta levada ao stakeholder projetava "~1,1 KB por arquivo, −70%, ~5 KB no total". **O número estava inflado em ~2×** — o recorte automático do bloco ia até o fim do arquivo e arrastava o gancho de R22 e a linha de fecho junto. O ganho real é −1,4 KB. O desvio está registrado na entrada `v3.22` conforme R19, com a lição de método; a decisão não muda com o número certo, mas o número que a sustentou estava errado.

**Mudança de comportamento de agente/comando se aplica** — os 7 arquivos de `commands/` foram tocados: só valem depois de reiniciar a sessão, e só chegam aos projetos depois de `git push` + `claude plugin marketplace update` + `claude plugin update`. Nenhuma instrução mudou de sentido; o que saiu foi texto explicativo repetido.

**Contradição de §5c fechada, por decisão do stakeholder.** §5c mandava cortar prioritariamente na carga fixa (`agents/`+`commands/`) e esses são justamente os grupos que o `/review` não edita. Das três saídas escaladas, o stakeholder escolheu **manter como está e tornar explícito**: §5c ganha o parágrafo *"O corte de maior valor é proposta, nunca aplicação direta"* — o Act mede, encontra e propõe com texto pronto; o stakeholder autoriza item a item no fecho; a exceção de curadoria do SM não cobre remoção nesses arquivos. **Nenhum poder foi alargado** — o que já era prática passou a estar escrito.

---

## v3.21.0 — 2026-09-18

**Branch:** `fix/v3.22.0` (aberta como `fix/v3.21.0`) a partir de `develop` (`fix/v3.19.0` já foi mesclado — PR #19 — antes desta entrega abrir; sem empilhamento). **PR** para `develop`. **Esta entrega carrega duas entradas de processo** — `v3.20` e `v3.21` —, aplicadas na mesma rodada de `/review note`; cada uma tem entrada própria aqui, e a `version` acompanha a mais recente (R18).

**MINOR de processo.** Carrega a entrada nova [`v3.21`](roles/scrum-master/process/process-changelog.md) do changelog do processo — `vX.Y.0` (R18). Fecha o segundo item de `RAIZ/note.md`: o **Product Backlog deixa de conter as Histórias e passa a ser o índice ordenado delas**, com o conteúdo de cada uma em arquivo próprio. Sintoma que originou: o backlog crescia sem limite porque acumulava o texto de todas as Histórias, não só a lista.

### O que entrou

- **Product Backlog = índice (SM, normativo).** Matriz de propriedade (`artifact-ownership.md` §1, linhas "Histórias" e "Product Backlog"), **§1d nova** com o critério explícito do que fica × do que sai e a forma de verificação, e §4 com a convenção de nome `<H-ID>-<slug>.md`. **R20** reescrita: "A História vive no Product Backlog" → vive em arquivo próprio, indexada pelo backlog. O dono não muda — índice e arquivos são os dois do PO.
- **Conteúdo da História em `.team-project/product-owner/stories/<H-ID>-<slug>.md`.** Regras funcionais, protótipos, critérios de aceite e o registro do portão ③ saem do backlog. Nenhuma outra seção foi extraída — só as Histórias foram nomeadas pelo stakeholder.
- **Modelos e roteiro do PO alinhados.** `templates/product-backlog.md` (cabeçalho, tabela linkando por ID, fim da opcionalidade, "Como manter"), `templates/user-story.md` e `roles/product-owner/README.md` (o modo `/po story`). O PO decidiu, e escreveu, que **o arquivo nasce já no esboço** — ID sem arquivo por trás seria link morto no índice, e "linkar quando detalhar" reabriria a opcionalidade recém-fechada.
- **Coerência nos índices transversais do SM** — `deliverables/README.md`, `deliverables/team-project/README.md`, `templates/project-context.md`, `workflow.md` (§"Duas unidades", diagrama, saída da etapa 1).
- **`commands/po.md:13,20`** — "o **conjunto** das Histórias" → "o **índice** das Histórias", aprovado pelo stakeholder no fecho do `/review` (addendum datado na entrada `v3.21`).
- Arquivamento de `v3.18` para `process-changelog-archive.md` (pré-condição do teto de 3 entradas).

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.21.0`. Padrão antigo (`conjunto das Histórias`, `escolha é do projeto`, `seção própria`) zerado nos arquivos do PO; as ocorrências remanescentes no repositório foram lidas no contexto e são legítimas — `artifact-ownership.md` §1d cita o texto antigo para explicar o que mudou, e as entradas históricas deste changelog não se reescrevem. Bloco de evidência R19 completo na entrada `v3.21` do changelog do processo.

**Mudança de comportamento de agente/comando se aplica** — `commands/po.md` foi tocado: só vale depois de reiniciar a sessão, e só chega aos projetos depois de `git push` + `claude plugin marketplace update` + `claude plugin update`.

**Pendente, registrado e não aplicado:** `commands/po.md:19` ainda diz que o esboço "entra no Product Backlog sem detalhar" — pela decisão do PO, ele passa a criar o arquivo **e** a linha de índice. É mudança de comportamento de comando, não coerência de referência cruzada; texto pronto no addendum da entrada `v3.21`, para o `/review` seguinte.

---

## v3.20.0 — 2026-09-18

**Branch:** `fix/v3.21.0` — entregue junto com a `v3.21.0` (mesma rodada de `/review note`, mesmo PR para `develop`).

**MINOR de processo.** Carrega a entrada nova [`v3.20`](roles/scrum-master/process/process-changelog.md) do changelog do processo — `vX.Y.0` (R18). Fecha o primeiro item de `RAIZ/note.md`: **pendência do stakeholder resolve-se em formulário**, com a via de pedir mais contexto sempre como última opção.

### O que entrou

- **R22 ganha o meio de apresentação.** A regra já exigia forma fixa (pergunta + por que bloqueia, alternativas descritas, recomendação, via de mais contexto); faltava dizer **como** a pergunta chega ao stakeholder. Agora chega como formulário de escolha, nunca em texto corrido.
- **A responsabilidade é dividida, porque a restrição técnica obriga.** Os seis `agents/*.md` declaram `tools: Read, Grep, Glob, Write, Edit, PowerShell, ToolSearch` — **nenhum tem `AskUserQuestion`**. O **papel** entrega a estrutura fixa; a **sessão que orquestra** a renderiza. Papel que devolve prosa é achado contra ele; orquestração que despeja a estrutura como texto corrido é achado contra ela — nunca contra o papel, que já entregou o que devia.
- **Fronteira registro × resolução.** Pendência ainda aberta continua registrada em tabela — "Decisões funcionais pendentes" do Product Backlog, `.team-project/README.md` §7, campo `Aguarda decisão do stakeholder` de `pending.md` — e nada nisso muda. O formulário entra quando, e só quando, a pergunta é de fato levada ao stakeholder para decidir.
- **Pontos de escalação alinhados** — `workflow.md` (§5a passo 5 e "O que o SM escala", §6 diagrama e texto pós-diagrama), `roles/scrum-master/skills.md` e `roles/scrum-master/README.md`.
- **Gancho nos comandos que orquestram**, aprovado pelo stakeholder no fecho do `/review` (addendum datado na entrada `v3.20`): `commands/sm.md`, `commands/po.md`, `commands/arc.md`, `commands/team.md` ganham a instrução de chamar o formulário; `commands/review.md:54` passa a resolver conflito de regra em formulário, não em texto corrido.
- Arquivamento de `v3.17` para `process-changelog-archive.md` (teto de 3 entradas).

### Verificação

Nenhuma regra nova nasceu — R22 evoluiu, e a contagem segue em **24** em `working-rules.md`, `README.md` e `agents/scrum-master.md`. Ausência de `AskUserQuestion` no frontmatter dos seis agentes reexecutada na curadoria. Bloco de evidência R19 completo na entrada `v3.20` do changelog do processo.

**Mudança de comportamento de agente/comando se aplica** — cinco arquivos de `commands/` foram tocados: só valem depois de reiniciar a sessão, e só chegam aos projetos depois de `git push` + `claude plugin marketplace update` + `claude plugin update`.

**Roteamento aberto** (fora do alcance do SM, para o `/review` seguinte): `roles/product-owner/README.md:16,115`, `roles/product-owner/templates/functional-analysis.md:38,46`, `roles/architect/README.md:48` e `commands/po.md:25` descrevem a escalação ao stakeholder sem citar R22 nem a via de mais contexto — pendente desde a `v3.6`.

---

## v3.19.0 — 2026-09-16

**Branch:** `fix/v3.19.0` a partir de `develop` (`fix/v3.18.0` já foi mesclado — PR #17 — antes desta entrega abrir; sem empilhamento). **PR** para `develop`.

**MINOR de processo.** Carrega a entrada nova [`v3.19`](roles/scrum-master/process/process-changelog.md) do changelog do processo — `vX.Y.0` (R18). Fecha o item de `RAIZ/note.md` sobre onde vivem os documentos de execução do sprint: **(1)** Review, Retrospectiva e o snapshot fechado do Sprint Backlog ganham lugar persistido em `.team-project/scrum-master/sprints/<n>/`; **(2)** o burndown do sprint é desenhado de ponta a ponta — o que mede, de onde sai o dado (Registro de transições novo no Sprint Backlog), onde persiste, modelo (`templates/burndown.md`) e regra de verificação nova (**R24**); **(3)** duas contagens de regras desatualizadas (`README.md`, `agents/scrum-master.md`) corrigidas de 23 para 24, com varredura completa da RAIZ; **(4)** contradição entre `review-contract.md` e `commands/review.md` sobre o alcance da exceção de coerência de referência cruzada do SM, resolvida a favor da leitura ampla, autorizada explicitamente pelo stakeholder nesta rodada. Ver [`v3.19` do changelog do processo](roles/scrum-master/process/process-changelog.md).

### O que entrou

- **Pasta por sprint (SM).** `.team-project/scrum-master/sprints/<n>/` — `review.md`, `retrospective.md`, `sprint-backlog-snapshot.md`, `burndown.md` — aberta no `/sm sprint plan`, fechada no `/sm sprint close`. Critério de quando usar pasta numerada em vez do padrão vivo+archive do `consumption-log` documentado em `artifact-ownership.md` §1c.
- **Burndown do sprint (R24).** Sprint Backlog ganha o "Registro de transições" (dado bruto); `sprints/<n>/burndown.md` é a série derivada; granularidade declarada (exata na abertura/fechamento, por rodada de `/sm board` nos estados intermediários).
- **Duas contagens de regras corrigidas**, com varredura completa da RAIZ por outras ocorrências.
- **`commands/review.md` alinhado a `review-contract.md`**, sob autorização explícita do stakeholder: a exceção de coerência de referência cruzada do SM vale para os quatro grupos (`agents/`, `commands/`, `.claude-plugin/`, guias de raiz), nunca para mudança de comportamento, roteiro ou regra nova.
- Arquivamento de `v3.16` para `process-changelog-archive.md` (pré-condição do teto de 3 entradas), verificado por `Compare-Object`: zero diferenças.

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.19.0`. Detalhe completo (triagem, o que mudou, bloco de evidência R19, a autorização do stakeholder sobre `agents/`/`commands/`) na entrada `v3.19` do changelog do processo.

**Mudança de comportamento de agente/comando se aplica** — `agents/scrum-master.md` e `commands/review.md` foram tocados nesta entrega: só valem depois de reiniciar a sessão, e só chegam aos projetos depois de `git push` + `claude plugin marketplace update` + `claude plugin update`.

---

## v3.18.0 — 2026-09-15

**Branch:** `fix/v3.18.0` · **Base:** `fix/v3.17.0` (empilhada) · **PR** para `develop`.

**MINOR de processo, sem defeito de produto.** Carrega a entrada nova [`v3.18`](roles/scrum-master/process/process-changelog.md) do changelog do processo — `vX.Y.0` (R18). Fecha as três decisões que ficaram escaladas na `v3.17` sobre o **registro de consumo do time**: **(1)** retenção — arquivar por sprint no `/sm sprint close`, mesmo padrão de R17; **(2)** granularidade — toda invocação vira linha, deixa de ser provisório; **(3)** as duas propostas de texto pronto (gravação em `commands/*`, exibição em `team-version.md`) **aplicadas**, com a restrição explícita de que a gravação só ocorre onde `.team-project/` existe — nunca no clone-fonte do plugin, onde `/review` roda. Ver [`v3.18` do changelog do processo](roles/scrum-master/process/process-changelog.md).

### O que entrou

- **Retenção do registro de consumo (SM).** `consumption-log.md` passa a arquivar por sprint fechado (`consumption-log-archive.md`, sob `## Sprint <n>`) no `/sm sprint close` — passo amarrado à cerimônia já existente, sem cerimônia nova (`workflow.md` §5e, `roles/scrum-master/README.md`, `templates/retrospective.md`). O vivo guarda o sprint corrente mais os totais acumulados.
- **Granularidade decidida.** Toda invocação de subagente de papel vira linha — com Task/História quando houver, `n/a` quando não. As duas marcações de "pendente de decisão" saem de `consumption-log.md` e `artifact-ownership.md`.
- **Gravação aplicada em `commands/sm.md`, `commands/po.md`, `commands/arc.md`, `commands/ux.md`, `commands/qa.md`, `commands/dev.md`, `commands/team.md`.** Ao subagente retornar, a sessão que orquestrou grava uma linha — só se `.team-project/scrum-master/consumption-log.md` existir. `commands/review.md` ganha nota explícita de que **nunca** grava — roda no clone-fonte, sem `.team-project/`.
- **Exibição aplicada em `team-version.md`.** Item novo `e) O que o time gastou de fato`, condicionado à existência do registro.
- Item 3 de `.team-project/note.md`/`note.md` resolvido por esta entrega — sai da fila.
- Arquivamento de `v3.15` para `process-changelog-archive.md` (pré-condição do teto de 3 entradas), verificado por `Compare-Object`: zero diferenças.

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.18.0`. Detalhe completo (triagem, o que mudou, bloco de evidência R19, o texto exato aplicado) na entrada `v3.18` do changelog do processo.

**Mudança de comportamento de agente/comando se aplica** — `commands/*` e `team-version.md` foram tocados nesta entrega: só valem depois de reiniciar a sessão, e só chegam aos projetos depois de `git push` + `claude plugin marketplace update` + `claude plugin update`.

---

## v3.17.0 — 2026-09-15

**Branch:** `fix/v3.17.0` · **Base:** `fix/v3.16.0` (empilhada) · **PR** para `develop`.

**MINOR de processo, sem defeito de produto.** Carrega a entrada nova [`v3.17`](roles/scrum-master/process/process-changelog.md) do changelog do processo — `vX.Y.0` (R18). Fecha os três itens de `note.md` sobre "não há contabilidade de custo do time": propriedade e modelo de um **registro de consumo** (`.team-project/scrum-master/consumption-log.md`, SM) e o gancho desse número real no ciclo de eficiência (`workflow.md` §5c, `templates/retrospective.md`) foram **aplicados**; a gravação da linha (`commands/*`) e a consulta agregada (`team-version.md`) ficam como **propostas com texto pronto**, pendentes de aprovação — os dois são do stakeholder. Duas decisões de desenho (retenção e granularidade do registro) foram **escaladas**, não decididas em silêncio. Ver [`v3.17` do changelog do processo](roles/scrum-master/process/process-changelog.md).

### O que entrou

- **Registro de consumo do time (SM).** Novo artefato de projeto — `artifact-ownership.md`, modelo em `roles/scrum-master/templates/consumption-log.md`, linha no manifesto de `/team init` (`deliverables/team-project/README.md` + `team-init.md`). Uma linha por invocação de papel, escrita por **quem orquestra** (a sessão que disparou o subagente) — nunca pelo papel, que não vê o próprio consumo.
- **Gancho no ciclo de eficiência (`workflow.md` §5c, `templates/retrospective.md`).** A pegada estática de `/review metrics` (proxy de custo do processo) e o consumo real do registro novo passam a conviver lado a lado nas fases Check/Act, **sem se somar nem se substituir** — evitando duas verdades sobre "custo".
- **Duas propostas de texto pronto, não aplicadas:** gravação da linha em `commands/*` (após cada subagente retornar) e um item novo "O que o time gastou de fato" em `team-version.md`. O item 3 de `note.md` (consulta agregada) permanece na fila — sua resolução inteira é esta segunda proposta.
- **Duas decisões escaladas ao stakeholder, não fechadas:** retenção/arquivamento do registro (cresce sem fim, sem política) e granularidade do que entra (toda invocação, ou só as ligadas a Task/História).
- Arquivamento de `v3.14` para `process-changelog-archive.md` (pré-condição do teto de 3 entradas), verificado por `Compare-Object`: zero diferenças fora do separador.

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.17.0`. Detalhe completo (triagem, o que mudou, decisões escaladas, texto das propostas, bloco de evidência R19) na entrada `v3.17` do changelog do processo.

**Mudança de comportamento de agente/comando não se aplica** — nenhum `agents/`/`commands/` foi tocado; as duas propostas só valem, se aprovadas, após reiniciar a sessão.

---

## v3.16.0 — 2026-09-14

**Branch:** `fix/v3.16.0` · **Base:** `fix/v3.15.0` (empilhada) · **PR** para `develop`.

**MINOR de processo, sem defeito de produto.** Carrega a entrada nova [`v3.16`](roles/scrum-master/process/process-changelog.md) do changelog do processo — por isso a numeração é `vX.Y.0` (R18), não um PATCH sobre a linha `3.15`. Duas mudanças, ambas do alcance do SM (normativos que governam todos): a tabela de custo de `workflow.md` §5c, que trazia números medidos na v3.4 e nunca remedidos, foi remedida; e R18, que descrevia um modelo de branch (`fix/`/`feat/` a partir de `main`, PR para `main`) que **nenhuma entrega real segue** desde a v3.6.0, foi realinhado à prática (`develop` como linha de integração das entregas, `main` como linha estável que a recebe por decisão do stakeholder, e o caso de branch empilhada — já com dois precedentes — passa a ter forma escrita). Ver [`v3.16` do changelog do processo](roles/scrum-master/process/process-changelog.md).

### O que entrou

- **Tabela de custo por comando remedida (`workflow.md` §5c).** Os números da v3.4 viraram folclore, como o próprio `workflow.md:251` avisava. Remedição real: SM 15,4 KB (+3%), **PO 16,7 KB (+28%, o maior salto do grupo)**, UX 11,2 KB (+2%), Arquiteto 10,4 KB (+4%), QA 11,1 KB (+11%), dev 7,1 KB (+1%) — total do grupo 66 → 71,9 KB (+9%). `/team brainstorm` (~37 → ~39 KB) e `/team cycle` (~26 → ~27 KB) remedidos junto, por derivarem dos mesmos arquivos; `/review` corrigido de ~15 para ~14 KB de base (a soma real de `commands/review.md` + `agents/scrum-master.md`). A tabela agora anexa o comando de medição e a data, para a próxima remedição ser mecânica.
- **R18 realinhada à prática de branch (SM, `working-rules.md` + `workflow.md` §5d).** O normativo dizia "a partir de `main`, PR para `main`"; toda entrega desde a `v3.6.0` (evidência: esta própria série de `CHANGELOG.md`) sai de `develop`, com PR para `develop` — e o stakeholder confirmou a prática explicitamente ao abrir esta mesma entrega. R18 passa a descrever `develop` como a linha de integração das entregas e `main` como a linha estável que a recebe por decisão do stakeholder, fora do ciclo por-entrega; cobre também o caso de **branch empilhada** (base numa entrega anterior ainda não mesclada — precedentes `v3.14.0` e esta `v3.16.0`), sem forma escrita até agora. `workflow.md` §5d (roteiro do ciclo de entrega) e o cabeçalho do ritual em `CHANGELOG.md:6-10` corrigidos junto, por coerência de referência cruzada; mesma correção em três outros pontos achados na reavaliação do conjunto — `workflow.md` §8 (linha do gate de entrega), `working-rules.md` ("Como o SM aplica"), `templates/retrospective.md` e o banner de branch do próprio `README.md`.

### Divergência registrada

A proposta de remover a seção "Evolução dos seus documentos — `/review`" dos 5 `agents/*.md` (economia de ~2,4 KB de carga fixa por papel) foi **recusada na condução do `/review`** — não pelo stakeholder, que autorizou a entrega com a recusa já dentro dela. Motivo: aquele bloco é o resultado da compressão já feita na v2.7 (`process-changelog-archive.md:1031`) e carrega duas salvaguardas ausentes de `commands/review.md:57` — "nunca escreva em `${CLAUDE_PLUGIN_ROOT}`" e "sem a RAIZ, pare e peça" — que corrigem um defeito observado em campo (`process-changelog-archive.md:869`: quatro papéis lendo o contrato da cópia instalada). Cortar reabriria esse modo de falha. Não aplicada.

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.16.0`. Arquivamento de `v3.13` para `process-changelog-archive.md` (pré-condição do teto de 3 entradas — `process-changelog.md:10`) verificado por `Compare-Object` do bloco extraído contra o relocado: zero diferenças fora do separador. Detalhe completo de diffs e o bloco de evidência (R19) na entrada `v3.16` do changelog do processo.

**Mudança de comportamento de agente/comando não se aplica** — nenhum `agents/`/`commands/` foi tocado.

---

## v3.15.0 — 2026-09-14

**Branch:** `fix/v3.15.0` · **Base:** `develop` (v3.14.1) · **PR** para `develop`.

**MINOR de processo, sem defeito de produto.** Carrega a entrada nova [`v3.15`](roles/scrum-master/process/process-changelog.md) do changelog do processo — por isso a numeração é `vX.Y.0` (R18), não um PATCH sobre a linha `3.14`. Aplica os achados do `/review audit` desta sessão: `/po accept` mirando Task contra R21 em dois comandos, um vão de roteamento no `review-contract.md` que não cobria por inteiro os índices transversais do SM, e resíduo de find-replace (`item`→`Task`) espalhado em quatro documentos, dos papéis SM e Arquiteto. Uma segunda rodada, a partir de um code review independente sobre o trabalho ainda não commitado, corrigiu 9 achados na própria aplicação (afirmação falsa sobre dono declarado, contagem de arquivos, evidência de arquivamento ausente, evidência de R19 não reproduzível, ponteiro de linha obsoleto, escopo subdeclarado nesta seção, dois índices transversais que não tinham fechado por inteiro, uma metade de frase residual em `commands/team.md`, e a numeração desta própria entrega — inicialmente `v3.14.2`, três partes, quando o par no changelog do processo usa `vX.Y`). Ver [`v3.15` do changelog do processo](roles/scrum-master/process/process-changelog.md).

### O que entrou

- **`/po accept` alinhado a R21 (SM, `commands/qa.md` e `commands/team.md`).** Os dois comandos indicavam `/po accept <ID>` mirando a Task, na ordem errada (antes do fechamento técnico). Corrigido para `/sm close <ID>` no veredito ✅, com o aceite da História explicado como posterior, na Sprint Review — a regra já valia desde a v3.3, só não tinha chegado aos dois comandos. `commands/team.md:70` tinha ainda a metade ⚠️/❌ da mesma frase preservando o modelo antigo ("não siga para o aceite", que sugere o aceite logo após o fechamento) — alinhada para "não siga para o fechamento".
- **Vão de alcance do `/review` fechado por inteiro (SM, `review-contract.md` + `artifact-ownership.md`).** `deliverables/implementation/02-status.md` já tinha dono (SM) declarado na matriz de propriedade, mas não aparecia na tabela de alcance do `/review`; `deliverables/README.md`, `deliverables/implementation/README.md` e `deliverables/team-project/README.md` não tinham dono declarado **em nenhum dos dois documentos**. Os quatro entraram: os três índices transversais ganharam linha própria na matriz de propriedade (`artifact-ownership.md`), e a linha do Scrum Master na tabela de alcance do `/review` passou a citá-los.
- **Resíduo de find-replace corrigido (SM + Arquiteto).** "permTask"/"é fechado" sobreviveram à varredura da v-anterior em `agents/developer.md`, `deliverables/README.md`, `deliverables/implementation/02-status.md` (SM) e `standards/implementation-quality.md` (Arquiteto, R16).

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.15.0`. `git --no-pager diff --stat` confirma **14 arquivos** no total: os 13 nossos — os citados acima, a tríade de versão (`plugin.json`, `CHANGELOG.md`, `README.md`), `roles/scrum-master/process/process-changelog.md` (este bloco) e `roles/scrum-master/process/process-changelog-archive.md` (arquivamento da entrada `v3.12`, pré-condição do teto de 3 entradas quentes — `process-changelog.md:10` — para a entrada `v3.15` caber) — mais `note.md`, modificado pelo stakeholder desde antes desta sessão e **não tocado** por nenhuma das duas rodadas desta entrega.

**Mudança de comportamento de agente/comando só entra em vigor após reiniciar a sessão.**

---

## v3.14.1 — 2026-09-12

**Branch:** `fix/v3.14.1` · **Base:** `develop` (v3.14.0) · **PR** para `develop`.

**PATCH sobre a mesma linha — sem mudança de processo.** Não carrega entrada nova de `process-changelog.md`: aplica as duas propostas de texto pronto que as entradas [`v3.12`](roles/scrum-master/process/process-changelog.md) e [`v3.13`](roles/scrum-master/process/process-changelog.md) deixaram para o stakeholder, em arquivos que são dele (`commands/` e `agents/`). O comportamento já estava desenhado e registrado na entrega anterior; o que faltava era ligá-lo aos arquivos que o Claude Code lê.

### O que entrou

- **Modo `bug <descrição>` no `/qa`.** Acionado pelo **PO**, nunca direto pelo stakeholder, com o defeito já classificado. É o **único modo do `/qa` que entra sem Task** — `<ID>` e `security <ID>` exigem uma Task, `baseline` e `audit` varrem o projeto inteiro, e nenhum deles aceitava "investigue este defeito descrito, que ainda não é Task". Era a lacuna no handoff PO→QA. Investiga e tenta reproduzir; confirmado, registra em `pending.md` com `Origem: stakeholder`; não reproduzido, reporta como suspeita — nenhuma entrada sem evidência.
- **Card do PO (`agents/product-owner.md`) alinhado ao roteiro.** `description`, lista de leitura obrigatória (inclui `.team-project/note.md` nos modos `bug` e `note`), responsabilidade nova com a classificação em três casos e a fronteira explícita (não investiga código, não confirma com evidência, não escreve no registro da QA), e `.team-project/note.md` nos arquivos que ele pode escrever — **só para remover item já tratado**.

### Decisão registrada

A `v3.14.0` deixou em aberto se o modo `/qa bug` teria ficado **redundante** depois da decisão de bifurcar o caminho do bug por origem do achado. Verificado contra os modos existentes: **não ficou**. A bifurcação manda o defeito achado pelo time seguir pelos canais que já existem — mas esses nascem dentro de uma Task (dev construindo abre 🔺 GAP; QA validando abre achado próprio). O relato do stakeholder é justamente o que chega **sem Task**, e nenhum modo o aceitava. O texto aplicado diz isso explicitamente, para os dois caminhos não se confundirem.

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.14.1`. Nenhum arquivo de `roles/`, `deliverables/` ou `standards/` foi tocado — a entrega é só `commands/qa.md` e `agents/product-owner.md`, mais os três arquivos de versão.

**Mudança de comportamento de agente/comando só entra em vigor após reiniciar a sessão.**

---

## v3.14.0 — 2026-09-12

**Branch:** `fix/v3.14.0` · **Base:** `fix/v3.10.0` (branch empilhada — esta entrega depende das entradas de processo da anterior) · **PR** para `develop`.

**MINOR de processo, sem defeito de produto.** Carrega as entradas [`v3.12`](roles/scrum-master/process/process-changelog.md), [`v3.13`](roles/scrum-master/process/process-changelog.md) e [`v3.14`](roles/scrum-master/process/process-changelog.md) do changelog do processo, fechadas numa sessão de `/review note` com seis itens sobre o mesmo tema: onde o projeto registra pendências e bugs, e por onde um defeito entra. A triagem levantou quatro conflitos com regra vigente e **todos foram decididos pelo stakeholder antes da aplicação** — nenhum resolvido por conta própria.

### O que entrou

- **Um registro só para pendências e bugs, distinguidos por campo.** `pending.md` continua sendo o único registro de itens abertos; a entrada ganha `Origem: time | stakeholder` e `Aguarda decisão do stakeholder: não | sim`. O pedido original era de quatro arquivos (`pendings.md`, `bugs.md` e os dois `-resolved`); a decisão foi resolver por campo, porque origem e estado são dois bits e quatro arquivos seriam quatro cargas fixas de leitura.
- **Leitura filtrada do stakeholder (§2.1 de `pending.md`).** Só as entradas que ele reportou, com a coluna "aguarda decisão dele?" — sem atravessar a lista técnica, e sem sair do mesmo arquivo.
- **Dono único da escrita preservado.** Só o QA escreve em `pending.md`; os demais papéis reportam pelos canais que já existem (🔺 GAP, achado, relato pelo PO) e o QA transcreve com evidência `arquivo:linha`. Era um dos conflitos: o pedido original abria escrita a todos os papéis.
- **Resolvido continua no `02-status.md` do SM** (R12 preservada) — o outro conflito decidido: não há arquivo de resolvidos da QA.
- **O bug entra pelo PO, com bifurcação por origem do achado.** Defeito que o **stakeholder** reporta entra pelo PO (`/po bug <relato>`), que classifica em defeito · mudança de escopo disfarçada · dúvida de uso e aciona a QA quando é defeito. Defeito que o **time** acha durante o trabalho vai direto ao registro da QA pelos canais próprios — o PO não é gargalo de achado técnico interno.
- **Fila de relatos do projeto: `.team-project/note.md`.** O stakeholder anota problemas ao longo do uso, como sintoma; **`/po note`** trata a fila inteira em lote, item a item, e remove da fila o que foi tratado — que passa a viver só no destino. Semeado pelo `/team init` e explicado no `how-to.md`, que é copiado para dentro do projeto.
- **O homônimo `note` foi tratado antes de virar defeito.** Agora há três coisas com esse nome (a fila do `/review` na raiz do plugin, a fila do projeto, e o modelo dela). Entraram na tabela de homônimos e na matriz de propriedade de `artifact-ownership.md`; as listas "Não faz" dos seis papéis e "Proibido" dos seis agentes foram lidas uma a uma procurando a palavra crua — nenhuma ocorrência, nada a corrigir. É a régua nascida da `v3.4`, quando um papel recusou o próprio modo por causa disso.
- **Nascimento dos documentos de implementação declarado.** `01-scope-and-criteria`, `02-status`, `03-code-map` e `pending` não são semeados pelo `init` — nascem quando o projeto precisa. O onboarding agora exige declará-los em `.team-project/README.md` §4 na mesma sessão em que nascem, e rastreia pendências e bugs já conhecidos.

### Pendências abertas por esta entrega

- `commands/qa.md` — o modo `/qa bug <descrição>` foi proposto pela QA **antes** da decisão de bifurcar o caminho do bug. Com achado interno indo direto ao registro por canais que já existem, o modo pode ter ficado redundante. Fica como proposta no changelog do processo (`v3.12`), para reavaliação.
- `agents/product-owner.md` — proposta de texto pronto em `v3.13`, não aplicada.

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.14.0`. Detalhe completo de diffs e evidência (R19) nas entradas `v3.12`–`v3.14` do changelog do processo.

---

## v3.10.0 — 2026-09-12

**Branch:** `fix/v3.10.0` · **Base:** `main` (v3.6.0) · **PR** para `develop`.

**MINOR de processo, sem defeito de produto.** Carrega as entradas [`v3.7`](roles/scrum-master/process/process-changelog-archive.md), [`v3.8`](roles/scrum-master/process/process-changelog-archive.md), [`v3.9`](roles/scrum-master/process/process-changelog.md) e [`v3.10`](roles/scrum-master/process/process-changelog.md) do changelog do processo, fechadas na mesma sessão de `/review note` a partir de um relato de campo: sessão real de uso intensivo do plugin que bateu o limite de taxa da conta Anthropic repetidas vezes (`feedback-plugin-team-consumo-sessao.md`, não versionado). A entrada [`v3.11`](roles/scrum-master/process/process-changelog.md) da mesma sessão **não** tem par aqui — é o registro de uma proposta avaliada e descartada (delegar tarefa simples de PO/SM/UX/QA ao dev em Haiku), sem mudança de nenhum documento de processo; divergência registrada conforme R18.

### O que entrou

- **Releitura incremental entre invocações do mesmo papel (R3 estendida).** Reinvocar o mesmo papel sobre o mesmo tópico agora relê só o delta desde a última leitura, não o documento inteiro.
- **Checkpoint de progresso em verificação pesada (R5 estendida).** Spike do Arquiteto e harness completo do UX salvam resultado parcial em disco a cada etapa — um corte de sessão não descarta mais o trabalho já produzido.
- **Modo "leve" de verificação (R23, nova).** Primeira entrega de uma Task paga verificação plena; follow-up pequeno pode reduzir o **escopo** verificado, nunca a evidência real nem os portões de qualidade. Arquiteto e UX definem, cada um no próprio `skills.md`, o que conta como "leve".
- **Limite de paralelismo pesado na orquestração** (`workflow.md` §7): evitar disparar 3+ papéis pesados simultâneos fora de fluxo que já prevê isso por desenho — o paralelismo intencional do `/team brainstorm` foi mantido como está.
- **Spike do Arquiteto para de travar sem relatar.** Chamada externa de spike agora exige timeout curto e backoff limitado no código; etapa que esgota tentativas fecha como "inconclusiva por causa externa" em vez de travar 600s em silêncio (`agents/architect.md`, `commands/arc.md`, `roles/architect/skills.md` §11–§13).
- **Verificação do protótipo citada no comando `/ux prototype`**, não só no roteiro do UX — exercitar com o escopo certo (R23) e gravar o parcial a cada tela (R5).
- **Retomada nativa entre invocações do mesmo papel.** `/po`, `/arc`, `/ux`, `/qa` e `/sm` agora checam, antes de abrir uma instância nova do Agent, se já existe uma thread recente do mesmo papel na sessão sobre a mesma Task/tema — e a retomam em vez de reconstruir o contexto do zero.
- **Duas correções de coerência de referência cruzada**: contagem de regras do README/`agents/scrum-master.md` (21→23) e a linha do UX em `review-contract.md`, que não citava `deliverables/prototype/` como PO e QA já citam os próprios entregáveis.

### Pendências abertas por esta entrega

Nenhuma — as duas propostas que ficaram pendentes ao fechar `v3.8`/`v3.9` (texto para `commands/ux.md` e para `agents/architect.md`/`commands/arc.md`) foram aplicadas nesta mesma entrega, a pedido explícito do stakeholder (`v3.10` do changelog do processo).

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.10.0`. Detalhe completo de diffs e evidência (R19) nas entradas `v3.7`–`v3.11` do changelog do processo (as duas primeiras já arquivadas, por teto de leitura — R17).

---

## v3.6.0 — 2026-09-10

**Branch:** `fix/v3.6.0` · **Base:** `main` (v3.4.0) · **PR** para `develop`.

**MINOR de processo, sem defeito de produto.** Carrega as entradas [`v3.5`](roles/scrum-master/process/process-changelog.md) e [`v3.6`](roles/scrum-master/process/process-changelog.md) do changelog do processo, fechadas na mesma sessão de `/review note`. Nasceu de um sintoma de campo (README desatualizado após a `v3.4.0`) e, a partir dele, endereçou mais dois itens da fila.

### O que entrou

- **Gate de fechamento de entrega ganha uma terceira checagem.** R18 já conferia `plugin.json` == topo do `CHANGELOG.md`; agora também confere o banner "Versão atual" do `README.md`. É a régua que teria pego o próprio defeito que abriu esta entrega.
- **Mensagem de bloqueio do `/review` fora do clone-fonte, simplificada.** Deixou de expor `git rev-parse`/`.claude-plugin/marketplace.json`; agora diz só "Comando não permitido nesse contexto. Entre em contato com o fornecedor do plugin." — decisão editorial do stakeholder, registrada com ressalva no changelog do processo (perde a indicação de onde rodar e o que fazer).
- **`/team update` ganha um passo novo (6 de 9)** para avaliar se uma mudança de processo do plugin invalida deliverables já escritos num projeto, e onde registrar a decisão de manter uma versão antiga (`.team-project/README.md` §7).
- **R22 — pergunta ao stakeholder ganha forma fixa.** Toda pergunta que qualquer papel escala ao stakeholder passa a trazer: por que bloqueia, cada alternativa descrita, recomendação do time (R9) e uma via fixa de pedir mais contexto antes de decidir.

### Pendências abertas por esta entrega

- Roteamento ao PO e ao Arquiteto: a convenção antiga ("até 3 opções e recomendação") ainda aparece em `roles/product-owner/README.md`, `roles/product-owner/templates/functional-analysis.md` e `roles/architect/README.md` — fora do alcance do SM, fica para o próximo `/review` de cada papel.

### Verificação

`README.md`, `.claude-plugin/plugin.json` e o topo deste changelog nomeiam `v3.6.0`; o gate novo de R18, aplicado ao estado desta entrega, passa. Detalhe completo de diffs e evidência (R19) nas entradas `v3.5`/`v3.6` do changelog do processo.

---

## v3.4.0 — 2026-09-09

**Branch:** `fix/v3.4.0` · **Base:** `main` (v3.3.0) · **PR** para `develop`.

**PATCH de comportamento com uma regra de redação nova.** Carrega a entrada `v3.4` do [changelog do processo](roles/scrum-master/process/process-changelog.md). Nasceu de um defeito visto em campo, não de planejamento.

### O defeito

`/po status` numa instalação v3.3.0 entregava a leitura de produto e **em seguida se desautorizava**: dizia que status "é tipicamente papel do Scrum Master" e oferecia ao stakeholder um `/sm status` **extinto na própria v3.3**. O papel recusava o seu modo mais usado.

A causa não era a instalação — plugin na versão certa, `.team-project/` correto. Era uma palavra: a célula "Não faz" da ficha do PO listava `status` **cru**, sem dizer qual status nem de quem era, contradizendo a célula "Responde por" da **mesma tabela**. Entre a linha que concede e a linha que proíbe, venceu a que proíbe.

### A regra que saiu disso — `artifact-ownership.md` §1b

Substantivo que nomeia **dois artefatos de donos diferentes** nunca entra cru numa lista de "Não faz" / "Proibido". Toda menção traz **qualificador + dono + verbo**. O verbo entrou depois, quando o caso do QA mostrou que dizer *qual* artefato ainda não basta: era preciso dizer se o vedado é **escrever** ou também **validar contra** — e validar contra é a frente 2 do papel.

Por que essas listas e não qualquer menção: elas são lidas como a fronteira do papel e, na prática, **vencem a linha que concede o modo** — são mais curtas, estão mais perto do fim e costumam ser a última coisa que o agente lê antes de agir. Quando o prior do domínio empurra na mesma direção (*"status é do Scrum Master"*), a palavra crua não precisa convencer: basta não contradizer.

### As cinco correções

| Arquivo | Palavra crua | Modo que ela derrubava |
|---|---|---|
| `roles/product-owner/README.md` · `agents/product-owner.md` | `status` | `/po status` — **defeito confirmado em campo** |
| `roles/quality-assurance/README.md` · `agents/quality-assurance.md` | `especificação` | frente 2 do QA, chamada "Especificação técnica" |
| `roles/developer/README.md` · `agents/developer.md` | `documentação` | relatório de entrega e 🔺 GAP, as saídas obrigatórias do dev |

Varredura completa das seis fichas e dos seis cards: SM, Arquiteto e UX estão limpos — o SM é o **controle positivo**, e é dele a forma que as outras copiaram.

### Comando novo — `/team version`

Versão instalada, o que ela trouxe, guia rápido de comandos e o que o time custa em contexto. Fica na família **meta** de `init` e `update` — fala da instalação, não do produto — e por isso não colide com a regra de que `/team` não é canal de conversa. **Não usa rede:** quem verifica se há versão nova continua sendo o `update`, e assim o `version` nunca afirma que a instalação está atualizada sem ter olhado a origem.

### Tabela de custo do §5c remedida

A remedição achou drift que ninguém tinha visto: `/sm` declarava 13 KB e pesa **15,1**; `/po` declarava 10 e pesa **13,0** — é o mandato que a v3.3 moveu entre os dois papéis e que ninguém remediu depois. Também `/team cycle` 28 → 26 e `/review` 14 → 15. Onde o delta não era derivável da própria tabela, ficou escrito que **não é** em vez de estimado.

### Ressalva de processo, registrada e não normalizada

O limite de sessão derrubou os três agentes de papel no meio da aplicação, e as fichas de PO, QA e dev foram corrigidas pela sessão principal, não pelos donos. O texto passa no critério do §1b, mas **não passou pelo papel dono**. Está escrito na entrada `v3.4` do changelog do processo, com o motivo: sem esse registro, quem lesse o diff veria três papéis "concordando" com uma correção que nenhum escreveu.

---

## v3.3.0 — 2026-09-08

**Branch:** `feat/v3.0.0` · **Base:** `main` (v2.9.0) · **PR** para `main`.

**MAJOR — redesenho do modelo de trabalho e da governança.** Carrega **quatro** entradas do [changelog do processo](roles/scrum-master/process/process-changelog.md): `v3.0` (o redesenho), `v3.1` (protótipo funcional e o nome do Sprint Backlog), `v3.2` (otimização de custo de contexto) e `v3.3` (o canal do stakeholder) — daí a entrega sair como `v3.3.0`. É a primeira entrega que **quebra vocabulário e superfície de comandos**: projetos instalados precisam de leitura antes de aplicar.

### Governança — com quem você fala

- **O canal do stakeholder é o PO.** Demanda, valor, escopo, prioridade, **prazo, plano de entrega e status** são dele. Questão técnica vai direto ao **Arquiteto**; de tela, ao **UX**. O **SM não é canal de demanda**: é **processo, organização e eficiência**, gere os **rituais do Scrum** e o `/review`, e você o encontra nos rituais, no `/sm agreement` e quando ele cobra um portão que depende de você.
- **Prazo mudou de dono — e isso corrigia uma contradição.** O processo dizia em três lugares que prazo era do SM, enquanto o PO ordenava o backlog por valor × risco e era dono das Histórias: **duas cabeças respondendo quando o valor chega**. Agora o **PO diz o que entra e quando sai** (plano de entrega, seção nova do Product Backlog); o **SM diz quanto cabe** (capacidade observada, fila, dependência, bloqueio). Na Planning: o SM facilita e apresenta a conta, o PO seleciona e corta.
- **Não existe mais broadcast.** `/team <mensagem>` e `/team agreement` — os dois comandos mais caros do time, 48 e 55 KB — **foram removidos**. `/team` passa a orquestrar o time trabalhando; mensagem solta é **roteada sem disparar agente**.
- **`/sm agreement <questão>` no lugar do acordo por broadcast**: o SM chama **só os papéis que a questão toca** (2–3, não 6), consolida uma recomendação e registra a divergência. Ele facilita **porque não é dono de requisito, desenho nem evidência** — o mesmo princípio da frente 2 do QA.
- **`/po status` no lugar de `/sm status`**, e ele **fala em Histórias**: "entregue" é História **aceita na Sprint Review**, não Task fechada nem soma de Tasks fechadas.
- **O QA roteia o achado pelo objeto da dúvida**, sem orquestrador: regra e critério ao PO, desenho e standard ao Arquiteto, tela ao UX. Quem recebe e não é dono devolve. Só o achado que ele **não consegue classificar** vai a `/sm agreement`.

### Renomeações que quebram compatibilidade *(além das da v3.0)*

| Antes | Agora |
|---|---|
| `/team <mensagem>` (broadcast dos seis) | **removido** — roteie ao dono |
| `/team agreement <questão>` | `/sm agreement <questão>`, sem broadcast |
| `/sm status` | `/po status`, em Histórias |
| `roles/scrum-master/templates/status.md` | `roles/product-owner/templates/status.md` |
| "prazo é do SM" | prazo, plano de entrega e status são do **PO** |

### Custo de contexto — o que ficou mais barato

- **Carga fixa por invocação: 63,6 KB → 59,7 KB (−6%)**, sem perder uma linha de informação. A seção "Evolução dos seus documentos" dos 5 agents era **duplicação literal** de `review-contract.md`, e o parágrafo equivalente dos 6 comandos repetia o mesmo — os dois foram reduzidos a um ponteiro e a uma linha de roteamento. O conteúdo continua inteiro no `review-contract.md`, que só é lido quando o `/review` roda.
- **A métrica de eficiência (§5c) parou de medir história fria.** Ela somava `roles/<papel>/` inteiro, e no caso do SM **50% disso é changelog arquivado** — frio por construção e crescente por decisão de R17. O SM aparecia dez vezes mais pesado que os outros por causa de história que ninguém carrega, e o ciclo PDCA apontaria sempre para o documento errado. Agora são **dois números separados**: carga fixa (paga sempre) e conjunto sob demanda (pago por leitura, sem os changelogs).
- **Custo por comando declarado em §5c**, com a distinção que faltava: `commands/<x>.md` carrega no **contexto principal**, `agents/<papel>.md` no do **subagente**. `/team <mensagem>` custa **47,9 KB** de carga fixa; `/team agreement`, 55,1 KB; um comando de papel só, 7–13 KB. E as três coisas que a carga fixa **não** mostra: o **modelo** de cada agente (`/arc` e `/ux` em Opus, `/dev` em Haiku), a **leitura em tempo de execução** (que costuma superar a carga fixa) e o **retorno das respostas** ao contexto principal num broadcast.

**Nenhum controle de qualidade foi removido.** Auditoria da entrega: 21/21 regras com forma de verificação · 0 modelos órfãos · 0 links quebrados · portões, gates, DoR/DoD, escada de falha e as seis frentes do QA inalterados.

### O que muda para quem usa o time

- **Duas unidades onde havia uma.** A **História** é a unidade de valor (dona: PO, conteúdo **só funcional** — regra, protótipo, critério de aceite); a **Task** é a unidade de trabalho, no Sprint Backlog do SM, com o **Plano de Implementação** do Arquiteto dentro dela. Toda Task pertence a exatamente uma História (**R20**). O que se chamava `item` **deixou de existir**.
- **O sprint virou caixa de tempo.** Duração e unidade de estimativa são declaradas por projeto no `.team-project/README.md` §2a e respondidas no onboarding. A Planning Meeting (`/sm sprint plan`) quebra as Histórias aprovadas em Tasks, o time estima, e a soma é cortada na **capacidade observada** — a média entregue, não o desejo. O Sprint Backlog **não cresce** depois disso.
- **O aceite mudou de alvo e de lugar** (**R21**). O `/sm close <T-ID>` passa a ser **fechamento técnico** (veredito ✅ do QA); quem diz que o valor chegou é o PO, **por História, na Sprint Review**. Consequência aceita conscientemente: **História rejeitada devolve todas as Tasks, inclusive as aprovadas pelo QA**.
- **Quatro portões de aprovação do stakeholder**, onde antes havia zero: ① SDD funcional (`00`,`01`,`02`) antes do técnico · ② SDD técnico (`03`,`04`,`05`) antes da primeira História · ③ detalhamento da História antes da Planning · ④ aceite na Sprint Review.
- **O portão ① exige protótipo funcional em HTML, navegado.** Entregável novo, do UX: HTML navegável cobrindo **todo fluxo principal de `02-flows-and-roles`**, sem build, sem servidor, sem back-end, com estados de exceção, dados plausíveis e o "fora do escopo" escrito na própria página. **Você não aprova o SDD funcional lendo — você navega**; print, gravação e apresentação não abrem o portão. Critérios em `deliverables/prototype/README.md`, modelo em `roles/user-experience/templates/functional-prototype.md`, comando `/ux prototype`.
- **O Sprint Backlog passou a se chamar Sprint Backlog no disco.** O arquivo em `.team-project/scrum-master/` era `work-board.md`; agora é `sprint-backlog.md`.
- **Três comandos novos:** `/po story <H-ID>` (escrever e detalhar História) · `/sm sprint plan|close` (abrir e encerrar sprint) · `/sm review` (Sprint Review). **`/sm review` não é `/review`** — o primeiro roda no projeto e aceita Histórias; o segundo evolui o processo do time e roda só no repositório-fonte.
- **O `/team update` passou a reconciliar o `.team-project/`** (passo 7 novo, 7 → 8 passos). Antes ele atualizava só `${CLAUDE_PLUGIN_ROOT}` e **tudo que o `init` havia instanciado derivava em silêncio** — `.team-project/how-to.md` incluído. Agora compara contra o manifesto de `deliverables/team-project/README.md` e **propõe** o delta, sem nunca apagar conteúdo do projeto sem aprovação.

### Renomeações que quebram compatibilidade

| Antes | Agora |
|---|---|
| `item` / `<ID>` | `Task` / `<T-ID>` — e `<H-ID>` para História |
| `Plano de Execução` · `templates/execution-plan.md` | `Plano de Implementação` · `templates/implementation-plan.md` |
| `/sm plan` | `/sm sprint plan` |
| `/po accept <ID>` (por item, após o QA) | `/po accept <H-ID>` (por História, na Sprint Review) |
| Quadro de trabalho · `work-board.md` | Sprint Backlog · `sprint-backlog.md` |
| Product Backlog = lista de itens | Product Backlog = **conjunto das Histórias** |

### Arquivos novos

- `roles/product-owner/templates/user-story.md` — a História em dois estados, com o portão ③
- `roles/scrum-master/templates/sprint-review.md` — registro da Review
- `roles/user-experience/templates/functional-prototype.md` — estrutura e ficha do protótipo funcional
- `deliverables/prototype/README.md` — o protótipo funcional como entregável e pré-condição do ①
- `deliverables/team-project/README.md` — manifesto do `.team-project/` e as três classes de reconciliação

### Regras

**19 → 21.** R20 (História é valor, Task é trabalho) e R21 (aceite por História, na Review) são novas; R1–R2, R4–R8 e R11–R17 foram reescritas sobre o novo modelo. R14 passa a bloquear a **primeira Planning Meeting**; R15 ganha os portões ① e ② **e a exigência de protótipo navegado no ①**.

### Como verificar

- `claude plugin details team@team` mostra **v3.3.0** e continua listando **8 comandos** (`sm po arc ux dev qa team review`) e 6 agents — após reiniciar a sessão.
- `/help` mostra os modos novos no `argument-hint` de `/sm` e `/po`.
- `grep -r "Plano de Execução" --include=*.md .` → só nos changelogs, que por R17 não se reescrevem.
- A entrada `v3.0` do changelog do processo traz o bloco de evidência exigido por R19, incluindo a checagem semântica que pegou 4 falsos positivos da substituição `item` → `Task`.

### Migração de um projeto já instalado

1. `/team update` — ele agora mostra o delta dos modelos e pede aprovação por arquivo.
2. Reiniciar a sessão.
3. `/sm onboarding` para registrar **duração do sprint** e **unidade de estimativa** no `.team-project/README.md` §2a.
4. Renomear `.team-project/scrum-master/work-board.md` para `sprint-backlog.md`.
4b. Acrescentar a seção **Plano de entrega** ao `product-backlog.md` do projeto, e parar de pedir prazo ao SM.
5. O backlog existente precisa virar Histórias (`/po story`) antes da primeira `/sm sprint plan` — Task sem História não entra no quadro (R20).
6. Se a fatia em andamento ainda não passou pelo ①, `/ux prototype` antes de o Arquiteto tocar em `03`/`04`/`05`.

---

## v2.9.0 — 2026-09-07

**Branch:** `fix/v2.9.0` · **Base:** `main` (v1.0.0) · **PR** para `main`.

Primeira entrega a chegar em `main` desde a v1.0.0. O lote **v2.8.0 nunca foi mergeado** (ver a entrada abaixo — "ainda não estava em `main`"), então este PR entrega o conteúdo das duas: v2.8.0 (comando `/review` único, `/team update`, normativo de lançamento) **e** v2.9.0 (o que vem a seguir).

> **Numeração.** O lote carrega mudança de processo até [`process-changelog.md` v2.11](roles/scrum-master/process/process-changelog.md). Por [`workflow.md` §5d](roles/scrum-master/process/workflow.md) uma entrega assim sairia como `v2.11.0`; **por decisão do stakeholder o lote permanece `v2.9.0`** — é a continuação direta da v2.8.0 (que também não seguiu a regra, pelo mesmo motivo) e ainda não havia entrega em `main` pareando com o changelog do processo. A regra §5d passa a valer para a **próxima** entrega, que já parte de um `main` versionado.

### Entregue

**1 · Pré-condição do `/review` pelo diretório atual** *(commit `6bf8f7c`)*

- `/review` descobre o repositório-fonte por `git rev-parse --show-toplevel` (→ **RAIZ**), não por `${CLAUDE_PLUGIN_ROOT}` — que no Windows nunca aponta para o working tree e é sempre a cópia instalada descartável.

**2 · Modelo RAIZ + R19 + extração do modo `update`** *(process-changelog v2.10 · commit `450adce`)*

- **`review-contract.md` e os 5 agents que rodam `/review`** passam a escrever na **RAIZ recebida**, nunca em `${CLAUDE_PLUGIN_ROOT}`. O contrato mandava registrar o changelog do processo na cópia instalada, que o próximo `claude plugin update` sobrescreve.
- **Nova regra R18 → R19** ("O `/review` produz evidência do que aplicou"): quinto passo no contrato, bloco `### Evidência` no template `process-change.md`, indicador em `working-rules.md`. Entrada de changelog sem bloco de evidência não fecha o `/review`.
- **`## Modo update` extraído** de `commands/team.md` para `team-update.md` (lido só nesse modo) — mesmo movimento que a v2.7 fez com `team-init.md`. `commands/team.md` 125 → 111 linhas.
- Correções de coerência: `agents/scrum-master.md` "17 regras" → 18 → 19; `argument-hint` do `/team` com `plan/build/qa`; linha de R18 na `retrospective.md`; `/team update` no template de contexto; "sete documentos de conteúdo" no índice do SDD. `process-changelog.md` v2.7 rearquivada.

**3 · Guias de raiz ganham dono; roteiro de instalação endurecido** *(process-changelog v2.11 · commit `033dddb`)*

- **`artifact-ownership.md`** ganha linha para os guias e rituais de raiz (`README.md`, `how-to.md`, `replicate-in-new-project.md`, `review-contract.md`, `team-init.md`, `team-update.md`): dono **stakeholder**, com curadoria de referência cruzada pelo SM. Eram os únicos arquivos do plugin sem dono declarado.
- **`how-to.md` §"Instalar em um projeto" reescrito em 5 passos** a partir de um relato de campo (instalação Windows que falhou em silêncio): URL `.git` completa obrigatória, bloco esperado do `.claude/settings.json`, verificação de escopo *project* × *user*, reinício como passo verificável, e a afirmação de que o projeto-alvo não precisa ser repo git. Nova subseção **"Windows e múltiplos perfis"** (um `CLAUDE_CONFIG_DIR` por vez, caixa da letra do drive, `git clone` no PS 5.1, `plugin list` duplicado — os três últimos marcados como contorno de bug externo).
- **R19 ganha checagem semântica**: `grep` zerado prova que a string sumiu, não que o sentido fechou — a classe "substituição de padrão" passa a exigir ler cada ocorrência nova no contexto (contagem enumerada, lista adjacente, total citado noutro documento). A própria v2.10 seria pega hoje.
- Resíduo da v2.10 fechado: "cinco passos" com enumeração de quatro em três resumos; linha de R19 na retrospectiva; `team-update.md` no índice do `README`; ponteiro de `workflow.md` §5d.

**Changelog do processo:** entradas `v2.9`, `v2.10` e `v2.11` no arquivo vivo; `v2.7` e `v2.8` arquivadas (teto de 3 — R17).

### Verificação

- `claude plugin validate . --strict` deve passar.
- `.claude-plugin/plugin.json` `version` == a versão da entrada do topo deste arquivo (`2.9.0`) — R18.
- `claude plugin details team@team` continua listando **8 comandos** (`sm po arc ux dev qa team review`) e 6 agents — após reiniciar a sessão.
- `git grep -n 'CLAUDE_PLUGIN_ROOT.*review-contract'` em `agents/` retorna **zero** — os 5 agents leem o contrato da RAIZ.
- Toda entrada nova de `process-changelog.md` (v2.9, v2.10, v2.11) tem par nesta entrada; a divergência de numeração está declarada acima — R18.
- `/team update` numa instalação `v1.0.0`: o bump `1.0.0` → `2.9.0` dispara a atualização.

### Proposto ao stakeholder (não aplicado — `commands/` e os guias de raiz são seus)

- `commands/team.md` modo `cycle`: nota de que a numeração 0–6 é índice local, para não colidir com a numeração global de `workflow.md` §2 *(herdado da v2.8.0, ainda aberto)*.
- Extrair `## Modo update` … **feito** nesta entrega; extrair blocos frios análogos de outros `commands/*` fica para uma `/review metrics` futura.

---

## v2.8.0 — 2026-09-06

**Branch:** `fix/v2.8.0` · **Base:** `main` (v1.0.0) · **PR** para `main`.

Primeira entrega versionada. Introduz o versionamento de entregas, consolida a centralização da evolução do processo, e traz o modo `/team update` com o normativo do processo de lançamento. Usuários com o plugin já instalado atualizam por `claude plugin marketplace update team` + `claude plugin update team@team` (o bump `1.0.0` → `2.8.0` dispara a atualização); da v2.8.0 em diante, **`/team update`** faz isso.

> Esta entrega carrega mudança de processo até [`process-changelog.md` v2.9](roles/scrum-master/process/process-changelog.md). Pela regra de numeração de [`workflow.md` §5d](roles/scrum-master/process/workflow.md) uma entrega assim sairia como `v2.9.0`; por decisão do stakeholder o lote permanece **v2.8.0** (a v2.8.0 é a primeira entrega e ainda não estava em `main`) — a regra §5d passa a valer a partir da próxima entrega.

### Entregue

**1 · Comando `/review` único + versionamento de entregas** *(process-changelog v2.7–v2.8)*

- **Comando `/review` único** para evolução do processo do time — substitui os cinco modos `review` de papel (`/sm review`, `/arc review`, `/po review`, `/ux review`, `/qa review`). Triagem e curadoria no Scrum Master; a edição de cada documento continua sendo do papel dono (invariante de dono único preservado).
- **Guarda de repositório-fonte** — `/review` recusa rodar contra a cópia instalada num projeto, que o `claude plugin update` sobrescreve.
- **`note.md`** vira a fila de entrada do `/review` (sintoma → triagem → roteamento pelo SM).
- **`review-contract.md`** passa a ser o contrato do `/review`, com a tabela de alcance por papel centralizada.
- Modo `review` removido de `commands/{sm,po,arc,ux,qa,dev}.md` e `agents/*.md`; referências a `/<papel> review` reapontadas em todo o plugin. Contagem de comandos **7 → 8**.
- **`replicate-in-new-project.md`:** deduplicação do bloco de instalação (fonte única: `how-to.md`) e da árvore `.team-project/` (fonte única: `roles/scrum-master/templates/project-context.md`).
- **Versionamento de entregas** — este `CHANGELOG.md`, a linha de versão no `README.md` e `.claude-plugin/plugin.json` em `2.8.0`.

**2 · Modo `/team update` — autoatualização do plugin**

- Novo modo de `/team`, rodado a partir de um projeto onde o time está **instalado** (o oposto do `/review`, que só roda no repositório-fonte). Compara a `version` instalada com a do `main` da origem canônica (`https://github.com/wtlmarco/scrum-team-plugin`), mostra o CHANGELOG do delta e, após confirmação, aplica `claude plugin marketplace update team` + `claude plugin update team@team`. Guarda: recusa se `${CLAUDE_PLUGIN_ROOT}/.git/` existir. Reiniciar a sessão continua manual.
- `commands/team.md`: `argument-hint` ganha `update`; nova seção `## Modo update` (sete passos: guarda · versão instalada · origem registrada · versão corrente · comparação semver · aplicação · fecho).
- `how-to.md`: bloco "Manter atualizado" reescrito em torno de `/team update`, com os comandos nativos mantidos como alternativa manual; linha `/team` da tabela de comandos ganha `update`.
- `README.md`: assinatura de `/team` e seção "Como o time é carregado" atualizadas.
- Origem: item da fila **Abertas** de [`note.md`](note.md), triado pelo `/review` — consumido.

**3 · Processo de atualização e lançamento ganha normativo** *(process-changelog v2.9)*

- **Nova `workflow.md` §5d "Atualização e lançamento do plugin"** — distingue os dois registros (`process-changelog.md` `vX.Y` × este `CHANGELOG.md` `vMAJOR.MINOR.PATCH`), descreve o ciclo de entrega (branch → PR → bump → entrada → `/team update`) e a regra de numeração.
- **Nova regra R18** ("Entrega do plugin é ramificada, versionada e registrada") em `working-rules.md`, com verificação por `git log main` + `CHANGELOG.md` + `plugin.json`.
- **`artifact-ownership.md`**: `CHANGELOG.md` (raiz) e o processo de lançamento passam a ter dono declarado — **stakeholder**; o SM reconcilia na curadoria do `/review`.
- Nova cerimônia "Lançamento de entrega" (`workflow.md` §5) e novo gate no merge do PR (`workflow.md` §8).
- Correções de coerência arrastadas junto: comando fantasma da retrospectiva (`/sm impact retro` → `/sm close`), numeração de ciclo colidente em `workflow.md` §4a, "7 comandos" → "8" em `replicate-in-new-project.md`, "cerimônia" e `/review note` no roteiro do SM, "17 regras" → "18" no `README.md`.

**Changelog do processo:** entradas `v2.7`, `v2.8` e `v2.9`; `v2.4`, `v2.5` e `v2.6` arquivadas (teto de 3 — R17).

### Verificação

- `claude plugin validate . --strict` deve passar.
- `claude plugin details team@team` deve listar **8 comandos** (`sm po arc ux dev qa team review`) e 6 agents — `update` é modo de `/team`, não comando novo — após reiniciar a sessão.
- `/team update` numa instalação desatualizada: detecta o delta, mostra o CHANGELOG, aplica após confirmação. Numa instalação em dia: responde "já está na versão mais recente". No repositório-fonte: recusa com a mensagem de `git pull`.
- `.claude-plugin/plugin.json` `version` == a versão da entrada do topo deste arquivo (`2.8.0`) — R18.

### Proposto ao stakeholder (não aplicado — `commands/` e `agents/` são seus)

- `commands/team.md` modo `cycle`: nota de que a numeração 0–6 é índice local, para não colidir com a numeração global de `workflow.md` §2.
- `commands/sm.md`: o resumo dos modos de `/review` passa a incluir `note`.
- `agents/scrum-master.md`: "17 regras / R13-R17" → "18 / R13-R18"; a lista de modos auxiliares de `/review` inclui `note`.
- Para um `/review note` futuro: os modos parciais `plan`/`build`/`qa` de `/team` estão fora do `argument-hint` do comando.
