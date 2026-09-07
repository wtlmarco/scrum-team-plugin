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
