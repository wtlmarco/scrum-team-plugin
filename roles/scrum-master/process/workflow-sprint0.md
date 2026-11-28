# Fluxo de Trabalho — Sprint 0, a fundação (R35)

> **Dono:** SM · Parte do fluxo — o núcleo está em [`workflow.md`](workflow.md). **Lido só** em `/sm sprint0 plan|run|review|area`. Instrumento: [`scripts/checks/foundation.ps1`](../../../scripts/checks/foundation.ps1) (v3.61.0).

O sprint 0 acontece **uma vez por projeto**, entre o onboarding (R14 · [`workflow-ritos.md` §5a](workflow-ritos.md)) e o primeiro `/sm sprint prepare`. Entrega duas coisas, com um aceite do stakeholder no fim:

1. **Documentação conforme** — os sete documentos do SDD (`00`–`06`) nos modelos de [`deliverables/sdd/`](../../../deliverables/sdd/README.md), descrevendo o sistema **como ele é hoje**. Documento que já existe é **revisado contra o código**, não aceito por existir.
2. **Ambiente de testes provado** — comandos de verificação no `guards.json` (`verify`, `run.prereqs`), a baseline do QA refeita e um cenário ponta a ponta rodado no alvo.

**O sprint 0 não refatora.** Má prática achada no código vira **dívida**: o Arquiteto a registra em `03` §0.1 (Pendentes de formalização) e o PO a leva ao backlog na review. Divergência entre documento antigo e código vira **achado** no retorno do papel — o documento novo descreve o código, e o QA confere.

**Não é o `sprint run`.** O quadro é `sprints/0/foundation.md`, não um `sprint-backlog.md`; a linha "Sprint corrente" do `README.md` §2 não muda; não há pacote ③, executor de Task, `close` por Task nem burndown. O estado vive na linha **`Sprint 0 (fundação)`** do `README.md` §2 — gravada só pelo script.

| Modo | Quem despacha | O que faz |
|---|---|---|
| `/sm sprint0 plan` | **sessão** | `foundation.ps1 assess` → `init` → **formulário do escopo** → `approve` |
| `/sm sprint0 run` | **sessão**, guiada por `foundation.ps1 next` | um item por vez: dono escreve → régua → QA confere → ✅; ambiente: Arquiteto planeja → dev executa → sessão grava o `guards.json` → QA prova |
| `/sm sprint0 review` | **sessão** | PO apresenta (documentos, achados, dívida); **formulário único** de aceite → `foundation.ps1 close` |
| `/sm sprint0 area <área>` | **sessão** | `foundation.ps1 area -Add "<área>"` e o mesmo `run` → `review`, só para a área |

**Sessão nova por modo (R29):** `/clear` entre `plan`, `run` e `review`. **Abertura em sessão limpa — leitura fixa:** `.team-project/README.md` §1, §2 e §4 · `.team-project/sprints/0/foundation.md` (se existir). O script diz o resto.

## `/sm sprint0 plan`

1. `powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/foundation.ps1" assess` — tabela fonte → **ausente · fora do padrão · conforme**, com o tipo do projeto (**retomada**: há código; **novo**: o SDD veio do `/sm sdd`).
2. `foundation.ps1 init` — grava o quadro com um item por documento (criar ou revisar) e por frente de ambiente que não passa, e muda a linha `Sprint 0 (fundação)` para **exigido**.
3. **Formulário do escopo — um só `AskUserQuestion` (R22)**, até 4 perguntas:
   - **Áreas da 1ª onda** — as que o backlog vai tocar primeiro (recomendação do PO a partir do onboarding). O resto é documentado quando o backlog chegar nelas (`/sm sprint0 area`). Documentar o sistema inteiro antes do primeiro sprint funcional só se o stakeholder escolher.
   - **Os itens do quadro** — aprovar · aprovar com ajuste · pedir mais contexto.
   - **Autorização para a sessão gravar no `guards.json`** os comandos que o plano de ambiente medir (`verify`, `run.prereqs`) — sem ela, cada bloco vira um formulário no `run`.
4. `foundation.ps1 approve -Areas "<áreas>" -By "<quem>" -Decision "<aprovar | aprovar com ajuste — …>"`. **Dispensa** (o stakeholder escolheu não fazer o sprint 0, risco aceito): `foundation.ps1 dispense -By "<quem>" -Because "<motivo>"`.
5. Fecho: `/clear` e `/sm sprint0 run`.

## `/sm sprint0 run`

Laço: `foundation.ps1 next` → faça **exatamente** o que a `PRÓXIMA AÇÃO` diz (o disparo vem com `Agent` e `prompt` prontos) → **encerre o turno**; o aviso do agente traz a volta → `next` de novo. **Um agente por vez.** A fala ao stakeholder é a linha `PARA O STAKEHOLDER:`, copiada.

**Itens de documentação** (frentes `funcional` e `técnica`):

| Marcador | Quem | Sai quando |
|---|---|---|
| ⬜ → 🟨 | o dono (PO: `00`, `01`, `02`, `06`; Arquiteto: `03`, `04`, `05`) escreve ou revisa, a partir do código e do que já existe, e roda a régua do item antes de devolver | a régua do item passa (`foundation.ps1 check -Item S0-nn`) |
| 🟨 → 🟪 | o QA confere: régua, **fidelidade ao código por amostra** (`arquivo:linha`) e verificabilidade do critério de aceite; grava a linha do arquivo em `sprints/0/evidence/conformance.md` ([modelo](../../quality-assurance/templates/conformance.md)) | Veredito ✅ na linha do arquivo, mais novo que o arquivo |
| ⚠️/❌ do QA ou régua que cai | volta ao dono, com os achados | — |

**A régua** (mecânica — `foundation.ps1 check`): `00` com `OBJ-nnn` e "Como saberemos"; `01` com critério de aceite e "Como verificar" em todo `RF`, e "Como verificar" em todo `RNF`; `02` com papel (`**Responsabilidade:**`), fluxo e "Pontos de falha"; `03` com índice, princípio `P-nnn` com "Consequência observável" e a **Ficha de Vinculação de Stack** V1–V22 com valor em toda linha ("não aplicável" + o que substitui também é valor); `04` com entidades e relacionamentos; `05` com contrato de erro, ou "não se aplica — <motivo>" em sistema sem API; `06` com uma entrada de versão e o índice `README.md` do SDD; `01` e `02` citam cada área do escopo; nenhum documento guarda marcador do modelo (`<…>`). **A régua prova a forma; a fidelidade é do QA** — documento no modelo que descreve outro sistema reprova na amostra.

**Itens de ambiente** (frente `ambiente`, régua `AMB-verify`):

1. ⬜ → 🟦 — o **Arquiteto** escreve `sprints/0/plan/S0-nn-ambiente.md` ([modelo](../../architect/templates/foundation-env-plan.md)): mede o ambiente (saída real — R26), lista em **Arquivos tocados:** o que o dev cria ou altera e escreve o bloco `## guards.json proposto`.
2. 🟦 → 🟨 — o `next` grava o escopo do dev (`dispatch.ps1`, `.active-task` — a G9 vale como no sprint) e imprime o disparo; o dev executa o plano e grava `sprints/0/delivery/S0-nn.md`.
3. Com a entrega, a **sessão grava o bloco proposto no `.team-project/guards.json`** (autorizado no formulário do escopo; o arquivo é da sessão) e roda o `next`: a régua passa → ✅ (e o escopo do dev é apagado); não passa → o plano volta ao Arquiteto.

**Itens de prova** (frente `prova`, dono QA): `AMB-baseline` — `/qa baseline` refeito no sprint 0 com os comandos do `guards.json`; `AMB-cenário` — `/qa scenarios create` das áreas do escopo e **um** cenário ponta a ponta rodado no alvo, com `S0-nn / sprint 0` na coluna Task/Sprint do Histórico (grupo e `all` vão ao `operator` — R28). Sem a ferramenta do alvo, o QA não finge: ⚠️ não executado, e o retorno diz o que falta — vira item 🔴.

**Devolução e bloqueio.** Cada volta ao dono é uma linha `devolvido` no Registro do quadro; na 3ª, o item vai a 🔴 e o degrau 1 é PO + Arquiteto (`/sm agreement`); o que eles não fecharem vai ao stakeholder em formulário (R25). Os outros itens seguem.

Fecho: com todos ✅, o `next` manda `/clear` e `/sm sprint0 review`.

## `/sm sprint0 review`

1. `foundation.ps1 check` — a régua completa (documentos, ambiente, conformidade do QA, itens). Falhou: volte ao `run`.
2. **PO apresenta** em `sprints/0/review.md`: o que cada documento passou a dizer (uma linha por documento), os achados (documento antigo × código) e a **dívida** encontrada (`03` §0.1 e retornos), cada uma já como item do Product Backlog com a criticidade proposta. Áreas documentadas e o que ficou para depois.
3. **Formulário único de aceite (R22):** aprovar · aprovar com ajuste (o ajuste vira item e volta ao `run`) · reprovar com o motivo · pedir mais contexto.
4. Aprovado: `foundation.ps1 close -By "<quem>" -Decision "<decisão>"` — grava o aceite, move as áreas para **documentadas** e muda a linha `Sprint 0 (fundação)` para **concluído**. O PO registra a versão do SDD no `06-changelog` (já feito no item `06`) e a data no índice.
5. Fecho: `/clear` e `/sm sprint prepare` (projeto retomado: o PO escreve as Histórias sobre o SDD aceito; melhoria nova segue `/po analyze` → `/sm sprint prepare`).

## `/sm sprint0 area <área>`

Acionado no `sprint prepare` quando uma História candidata cai numa área fora de **Áreas documentadas** do quadro — o SM devolve a História e propõe o comando. `foundation.ps1 area -Add "<área>" -By "<quem>"` reabre o quadro com os itens `01`, `02`, `04` e `05` da área (régua e conformidade do documento inteiro, com a área citada); o `run` e a `review` são os mesmos, menores. O sprint funcional **segue aberto** para as áreas já documentadas — a G25 só bloqueia antes do primeiro aceite.

## O que o sprint 0 não faz

- Não cria História nem Task de entrega (R20): o quadro dele é de itens `S0-nn`, fora do Sprint Backlog.
- Não passa pelos portões ① e ②: o sistema existe — o "protótipo" é o próprio sistema, e o aceite da review vale pelos dois. A R15 do C2 não cobra o ① dos documentos que o sprint 0 aceitou.
- Não corrige código nem documento de outro dono: quem não é dono lê, cita e pede (G8).
- Não roda sem escopo aprovado: o `next` só dispara papel depois do `approve`.
