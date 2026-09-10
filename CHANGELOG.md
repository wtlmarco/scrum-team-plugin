# Changelog de Entregas

> Versionamento de **entrega** do plugin, no padrão `vMAJOR.MINOR.PATCH` (`v2.x.y`).
> **Não confundir** com o [changelog do processo](roles/scrum-master/process/process-changelog.md) (`vX.Y`), que registra a evolução interna das regras de trabalho do time — esse é alimentado pelo `/review`.
>
> **Como funciona uma entrega:**
> 1. Branch `fix/vX.Y.Z` ou `feat/vX.Y.Z` a partir de `main`.
> 2. As correções/mudanças da entrega vão nessa branch.
> 3. PR para `main` para aprovação.
> 4. Uma entrada aqui, mais recente no topo, com **o que foi entregue** e **a branch**.
>
> `MAJOR.MINOR` acompanham a versão do changelog do processo quando a entrega inclui mudança de processo; `PATCH` (`vX.Y.1`, `vX.Y.2`…) é correção sobre a mesma linha.

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
