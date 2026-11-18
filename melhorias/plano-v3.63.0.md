# Plano de Implementação — v3.63.0: portão do QA por marcos, causa com dono, controle e prova guardada

> **Escrito para:** você (autor do plugin), para aprovar, e para a sessão de desenvolvimento do plugin que vai construir a versão. Nada aqui é commitado nem vira PR sem pedido seu.

**Origem:** sprint 6 do projeto piloto (garden), 15 a 17/11/2026 — o portão reprovou em 3 rodadas seguidas (`sprints/6/validation.md`) e abriu 4 Tasks de correção (Q-S6 a Q-S6d), quase todas por ambiente; o relatório do QA cita prova que já não existe; o quadro mostrou como "trabalhando" agentes encerrados havia 37 min.

**Branch:** `feat/v3.63.0` a partir de `develop` com a v3.62.3 mesclada (ou empilhada sobre `fix/v3.62.3`, se ela ainda não tiver PR mesclado).

**Decisões do stakeholder (17/11/2026, formulários):**
- **Uma entrega só, a 3.63.0**, com todos os itens abaixo (não dividir em 3.62.4).
- **Nomes em inglês** para os identificadores novos: as causas (`code`, `design`, `scenario`, `screen`, `requirement`, `environment`), as frentes, os estados e as pastas. O texto para pessoas continua em português.
- **O portão vira item controlado** no quadro e no consumo, com rodada e achados com dono.
- **A prova fica guardada no sprint:** o resultado e as capturas de cada rodada e de cada Task, **sem** os logs brutos (que seguem a poda de hoje).
- **A correção é genérica** (memória `feedback-plugin-generico`): nada de app id, caminho ou ferramenta do garden fixo no plugin; o que é do projeto vira configuração.

> **Construído (17/11) — o que mudou em relação a este plano** (detalhe no bloco `## v3.63.0` do `CHANGELOG.md`):
> - **O passo do portão ficou num arquivo próprio**, `scripts/checks/gate.ps1`, carregado pelo `run.ps1` (a §3 previa só o `run.ps1`).
> - **Sem a tabela de frentes, o script calcula a base de cada frente sozinho** (árvore de produção e conjunto de cenários, guardados no `gate.json` quando o QA é disparado); a tabela `## Frentes` do QA é lida para o quadro.
> - **O aviso de prova citada que não existe** (§2.7, no `close.ps1`) ficou de fora: a cópia para `proof/` antes de cada rodada tira a causa.
> - **Identidade do app ilegível** (`web:?`, `apk:?`) não é reaproveitada pelo `-Resume`: roda todos.
> - **Dono disparado 2 vezes sem gravar a resolução** vai ao stakeholder (não estava no plano).
---

## 1. Objetivo e fora de escopo

Depois desta versão:
1. Uma falha no portão refaz **só o que ela invalidou**. Ambiente nunca vira veredito; o aceite retoma de onde parou; a rodada nova mede e julga só as frentes vencidas e os achados abertos.
2. Cada achado do portão (e cada GAP do dev) tem uma **causa** de uma lista fechada, e a causa decide o **dono** e a rota: dev, Arquiteto, QA, UX, PO ou ambiente.
3. O portão aparece **no quadro e no consumo** com nome próprio: rodada, veredito, frentes, achados por dono, custo por rodada e retrabalho.
4. A prova que cada rodada e cada Task citaram **continua existindo** depois da rodada seguinte.
5. O quadro **não mostra como ativo** quem saiu sem aviso, e o `next` diz quando descarta um registro velho.

**Fora do escopo:**
- O aceite do sprint inteiro pelo executor do projeto (`targets.<alvo>.command` no `guards.json`) — fica registrado como item da fila; a 3.62.3 cobre a Task.
- Mudar a política de `.team-project/` fora do git (R31). A prova guardada é local, como o resto.
- Rodar o portão em paralelo (a série R1 continua: um agente por vez).

---

## 2. Desenho

### 2.1 Causas — uma lista só, com dono e rota

| Causa | Quando | Dono | Rota no `run.ps1 next` |
|---|---|---|---|
| `code` | o app não faz o que a especificação diz | dev | Task `Q-S<n>` (como hoje) |
| `design` | o plano está errado, incompleto ou inexequível | Arquiteto | `/arc question`, depois `Q-S<n>` se houver código |
| `scenario` | o `.scn` está errado ou desatualizado (id mudou, passo que o critério não pede) | QA | QA em instância nova corrige o `.scn`; nova medição **só desse cenário**; sem Task de dev |
| `screen` | estado, layout ou fluxo sem especificação, ou problema de usabilidade | UX | `/ux` revisa a especificação da tela; com `**Precisa de código:** sim`, depois `Q-S<n>` |
| `requirement` | critério ambíguo, regras em conflito, mudança de escopo | PO | `/po` decide (leva ao stakeholder o que é dele, R22); depois `Q-S<n>`, dívida ou nada |
| `environment` | alvo, massa de dados, configuração, prazo de comando | operator ou stakeholder | reparo e nova medição (§2.2); **nunca** veredito |
| `appearance` | (só no GAP do dev) medida ou marcação simples | Arquiteto | parecer curto (como hoje) |
| `process` | regra do time ou do plugin em conflito | Arquiteto + `/review` | como hoje |

- **No GAP do dev** (`roles/developer/templates/gap.md`), a linha `**Natureza:**` passa a `**Cause:**`, com `appearance`, `design`, `scenario`, `screen`, `requirement`, `process` e `environment`. Muda a rota: `produto` ia **direto ao stakeholder**; agora `screen` vai ao UX e `requirement` ao PO, que é o canal do stakeholder.
- **Compatibilidade:** o `run.ps1 done -Result gap` e a leitura do relatório aceitam os valores antigos como sinônimos — `aparência`→`appearance`, `desenho`→`design`, `produto`→`requirement`, `processo`→`process`, `ambiente`→`environment` — e o parâmetro `-Nature` continua aceito ao lado do novo `-Cause`. Projetos com relatório antigo não quebram.
- **Ordem das rotas** quando há várias causas abertas (série R1): `requirement` → `screen` → `design` → `scenario` → `code`. Decisão de produto e de tela vem antes, porque muda o que o dev vai corrigir.

### 2.2 O portão como máquina de estados — `sprints/<n>/gate.json`

Arquivo de estado do portão, escrito **só pelo `run.ps1`** (o QA continua dono do `validation.md`):

```json
{ "sprint": 6, "round": 3,
  "fronts": {
    "functional": { "state": "fail", "base": "app:3f9c…", "round": 3, "proof": "proof/S6/round-3/accept" },
    "measured":   { "state": "pass", "base": "prod:8fd3…", "round": 1, "proof": "proof/S6/round-1/quality" },
    "review":     { "state": "pass", "base": "prod:8fd3…", "round": 1 },
    "security":   { "state": "pass", "base": "prod:8fd3…", "round": 1 } },
  "environment": { "attempts": 1, "last": "massa base não carregou (exit 7)" } }
```

- **Frentes:** `functional` (cenários no alvo), `measured` (`quality.ps1`), `review` (julgamento de código e aderência aos planos), `security`.
- **Estados:** `pass`, `fail`, `stale` (a base mudou desde o julgamento), `pending` (ainda não julgada).
- **Ambiente não é medição (item A).** O `accept` com `environment` ou `configuration` no `result.json` **não** conta como medição fresca:
  - 1ª vez: `PRÓXIMA AÇÃO: reparar o alvo e repetir o aceite` — operator com `target.ps1 -Repair` e `accept.ps1 -Task S<n> -Resume`; `environment.attempts` sobe;
  - 2ª vez seguida, ou `configuration`: formulário ao stakeholder (`Set-AskRoute 'ambiente'`), sem QA, sem `Q-S<n>`, sem Arquiteto.
- **Rodada focada (item D).** Depois de fechada a correção, o `next` recalcula a base de cada frente; só as `stale` e as `fail` vão ao operator e ao QA. O prompt do operator lista só a medição vencida; o do QA, só as frentes e os achados abertos.

### 2.3 Base de cada frente — o que invalida o quê (item C)

| Frente | Base | Vence quando |
|---|---|---|
| `functional` | identidade do app instalado + hash do bloco de cada cenário | o app instalado mudou, ou o `.scn` daquele cenário mudou |
| `measured`, `review`, `security` | árvore **de produção**: os arquivos versionados menos os de teste (`$testRe`, o mesmo do `plan.ps1`) e menos `guards.json → quality.toolingPaths` | um arquivo de produção mudou |

- **Identidade do app:** android = SHA-256 do APK instalado (o que o `Resolve-AndroidApk` escolheu) mais o pacote; web = hash dos arquivos de `targets.web.appSources` (novo, opcional) ou, sem ele, a árvore de produção.
- **`quality.toolingPaths`** (novo, opcional, lista de máscaras): ferramenta de prova e scripts do projeto que não são produto — no garden seria `source/scripts/alvo/**`. Sem a chave, vale só o filtro de teste.
- `Get-WorkTree` ganha `-Scope production` (mesmo cálculo, com o filtro); o `tree` dos `result.json` de hoje continua como está.

### 2.4 Aceite que retoma (item B)

- `accept.ps1 -Resume`: lê o `result.json` (ou o `progress.json`) anterior da mesma pasta. Com a **mesma identidade do app** e o **mesmo hash do cenário**, mantém as linhas `PASSOU` (marcadas `reused: true`, com a hora original) e roda só os que faltaram ou falharam. Identidade diferente: roda tudo, e diz por quê.
- O `progress.json` passa a guardar **todas** as linhas da rodada (hoje guarda só a última), para a retomada depois de uma queda no meio.
- Vale para o executor interno e para o `**Aceite:** comando` da 3.62.3 (o `{only}` recebe só os que faltam).
- O `result.json` ganha `app` (a identidade) e `scenarioHash` por linha.

### 2.5 `validation.md` legível pelo script (item E)

O modelo `roles/quality-assurance/templates/sprint-validation.md` ganha duas tabelas de formato fixo:

```markdown
## Frentes
| Front | State | Round | Proof |
|---|---|---|---|
| functional | fail | 3 | proof/S6/round-3/accept/result.md |

## Achados
| ID | Task | Achado | Onde | Cause | Owner | State |
|---|---|---|---|---|---|---|
| S6-F1 | T-047 | … | `arquivo:linha` | environment | operator | open |
```

- **ID do achado:** `S<n>-F<k>`, numerado pelo QA e nunca reaproveitado entre rodadas. O hook reconhece o ID como item de trabalho (§2.6).
- **Estado do achado:** `open`, `fixed`, `debt` (aceito pelo PO como dívida — a linha `**Decisão do PO:**` continua) ou `wontfix` (só com decisão do PO).
- A rodada nova acrescenta uma tabela `## Rodada <k>` com o estado de cada achado aberto, sem apagar a anterior (como hoje). O `run.ps1` lê a **última** tabela de cada ID.
- O `run.ps1` deixa de depender da coluna em texto livre "Volta para": a rota sai de `Cause`. Sem a coluna ou com causa fora da lista, o `next` devolve ao QA (instância nova) só para classificar, sem rodar nada.

### 2.6 Quadro e consumo (item F)

- **Consumo** (`hooks/subagent-stop.ps1` `Get-WorkId`, `consumption.ps1`):
  - o hook reconhece `S<n>` e `S<n>-F<k>` (com o mesmo cuidado de hoje para não casar `Q-S6`);
  - a linha ganha `gate_round`, lido do `gate.json` na hora;
  - unidade `validação do sprint` para `S<n>`, e `correção do portão` para `S<n>-F<k>` e `Q-S<n>`;
  - rodada ≥ 2 do portão é `retrabalho`;
  - nova tabela `### Por rodada do portão` no `consumption.md` (rodada, papel, tokens, tempo).
- **Quadro** (`kanban.ps1`): seção `## Validação do sprint` depois do `## Kanban`, lida do `gate.json` e do `validation.md` — rodada, veredito, estado de cada frente e os achados abertos agrupados por dono, com o nome de negócio (`plain.ps1`). O `/team-status` ganha uma linha do portão.

### 2.7 Prova guardada no sprint (item G)

- **Pasta:** `sprints/<n>/proof/` (em inglês; não colide com `sprints/<n>/evidence/<ID>.md`, que é o arquivo de evidência do QA por Task).
- **Por rodada do portão:** antes de disparar o QA, o `next` copia o `result.json`, o `result.md` e as capturas (`shots/` e, no executor do projeto, as `.png` de `cmd/`) da medição que o QA vai julgar para `proof/S<n>/round-<k>/{accept,quality}/`. O prompt do QA aponta essas cópias, e o `validation.md` as cita.
- **Por Task:** no `close.ps1 -Apply` com ✅, o mesmo para `proof/<ID>/{verify,accept}/` (do `verify` só o `result.json`, o `result.md` e o resultado da mutação).
- **Sem logs brutos** (decisão do stakeholder). A poda de hoje (R28) não toca em `proof/`.
- O `close.ps1` confere que os caminhos de prova citados no `validation.md` e no relatório do dev existem (aviso, não reprovação, na primeira versão).

### 2.8 Registro de agentes que não mente (item H)

- `Write-NowSection` (`hooks/common.ps1`) usa o mesmo teste do `Get-LiveAgents`: registro sem ação há mais de 20 min e sem rodada aberta aparece como **"sem sinal desde HH:mm — provavelmente encerrado"**, não como "trabalhando".
- O `next` e o `start`, quando o `Get-LiveAgents` descarta um registro da Task, imprimem `registro ignorado: <papel> <agent_id> sem ação desde HH:mm (<n> min)`, tiram o registro do `.active-agents` (sob a trava `Invoke-ActiveAgentsLocked`), o levam ao `.interrupted` e gravam uma linha no `run-log.md`.
- `hooks/COVERAGE.md` documenta que o `host_pid` é o processo do Claude Code que hospeda **a sessão**: vivo, ele prova que a sessão existe, não que aquele agente existe.

---

## 3. Arquivos — lista fechada

### A alterar
| Arquivo | O quê |
|---|---|
| `scripts/checks/run.ps1` | portão: `gate.json`, ambiente fora do veredito, rodada focada, rotas por causa, cópia da prova da rodada; `done -Cause` com sinônimos; registro ignorado no `next`/`start` |
| `scripts/checks/accept.ps1` | `-Resume`, `app` e `scenarioHash` no `result.json`, `progress.json` com todas as linhas |
| `scripts/checks/lib.ps1` | `Get-WorkTree -Scope production`, `Get-AppIdentity`, `Get-ScenarioHash`, `Get-GateState`/`Set-GateState`, `Read-ValidationFindings`, `Copy-Proof`, `ConvertTo-Cause` |
| `scripts/checks/quality.ps1` | grava a base `prod:` no `result.json` |
| `scripts/checks/close.ps1` | `proof/<ID>/` no ✅; aviso de prova citada que não existe |
| `scripts/checks/kanban.ps1` · `plain.ps1` | seção `## Validação do sprint`; nomes simples das causas e frentes |
| `scripts/checks/consumption.ps1` | unidades, retrabalho por rodada, `### Por rodada do portão` |
| `scripts/checks/team-view.ps1` (o `/team-status`) | linha do portão |
| `hooks/subagent-stop.ps1` | `Get-WorkId` com `S<n>` e `S<n>-F<k>`; `gate_round` |
| `hooks/common.ps1` | `Write-NowSection` com o teste de vida; remoção do registro velho |
| `hooks/COVERAGE.md` | `host_pid`; G16 com o portão |

### Documentos (na mesma branch, depois dos scripts verdes)
| Arquivo | O quê |
|---|---|
| `roles/quality-assurance/templates/sprint-validation.md` · `README.md` · `agents/quality-assurance.md` | tabelas `## Frentes` e `## Achados` com `Cause`/`Owner`/`State`; ID `S<n>-F<k>`; rodada focada; julgar só o que o prompt lista |
| `roles/developer/templates/gap.md` · `agents/developer.md` · `roles/developer/README.md` | `**Cause:**` no lugar de `**Natureza:**`, com sinônimos |
| `roles/user-experience/README.md` · `agents/user-experience.md` | rota `screen`: revisar a especificação da tela a partir do achado; `**Precisa de código:**` |
| `roles/product-owner/README.md` · `agents/product-owner.md` | rota `requirement`: decidir o achado (levar ao stakeholder o que é dele) |
| `roles/scrum-master/process/sprint-run.md` | §Validação do sprint reescrita: marcos, ambiente, rodada focada, rotas por causa, prova guardada |
| `roles/scrum-master/templates/sprint-backlog.md` | a `Q-S<n>` cita os `S<n>-F<k>` que corrige |
| `standards/scenario-language.md` | `-Resume`, identidade do app, hash do cenário |
| `how-to.md` | o que o stakeholder vê no quadro durante o portão |
| `CHANGELOG.md` · `process-changelog.md` (bloco `## v3.63`) · `plugin.json` · `README.md` | versão e registro |

---

## 4. Passos

### A. Ambiente fora do veredito
`run.ps1` portão: `$fresh` do accept exige `environment` e `configuration` vazios; ramo novo de reparo e repetição com `environment.attempts` no `gate.json`; 2ª vez ou `configuration` → formulário. **Pronto:** com um `result.json` de ambiente, o `next` manda reparar e repetir, e não dispara o QA.

### B. Aceite que retoma
`accept.ps1 -Resume`, `Get-AppIdentity`, `Get-ScenarioHash`, `progress.json` com todas as linhas. **Pronto:** queda simulada no cenário 3 de 5; a segunda chamada roda só o 3, o 4 e o 5 e o `result.json` traz 5 linhas, 2 com `reused`.

### C. Base por frente
`Get-WorkTree -Scope production`, `quality.toolingPaths`, `gate.json` com a base de cada frente. **Pronto:** mudar só um arquivo de `quality.toolingPaths` deixa `measured`/`review`/`security` como `pass`; mudar um de produção as deixa `stale`.

### D. Rodada focada
Prompts do operator e do QA montados das frentes `stale`/`fail` e dos achados `open`; o accept vai com `-Resume` e `-Only` com os cenários vencidos. **Pronto:** depois de uma `Q-S<n>` que toca uma História, o prompt do operator pede só os cenários dela e os que falharam.

### E. `validation.md` legível
Modelo novo, `Read-ValidationFindings`; QA sem a tabela ou com causa fora da lista → volta ao QA só para classificar. **Pronto:** o `next` lê o estado de cada `S<n>-F<k>` da última rodada.

### F. Rotas por causa
`requirement` → PO, `screen` → UX, `design` → Arquiteto, `scenario` → QA, `code` → `Q-S<n>`, nessa ordem; `done -Cause` com sinônimos dos valores antigos; GAP `screen`/`requirement` deixa de ir direto ao stakeholder. **Pronto:** um `validation.md` com um achado de cada causa leva o `next` a disparar, em série, PO, UX, Arquiteto, QA e a `Q-S<n>`.

### G. Quadro e consumo
`Get-WorkId`, `gate_round`, unidades e retrabalho, `## Validação do sprint` no `kanban.md`, linha no `/team-status`. **Pronto:** um `usage.jsonl` de teste com duas rodadas do portão dá duas linhas em `### Por rodada do portão`, a segunda como retrabalho.

### H. Prova guardada
`Copy-Proof` no `next` (antes do QA) e no `close.ps1 -Apply`. **Pronto:** a segunda rodada não apaga a pasta `proof/S<n>/round-1/`, e o `validation.md` da rodada 1 continua apontando para arquivos que existem.

### I. Registro de agentes
`Write-NowSection` com o teste de vida; remoção com log no `next`/`start`. **Pronto:** registro de 37 min sem ação aparece como "sem sinal" no `kanban.md` e some do `.active-agents` no primeiro `next`, com a linha no `run-log.md`.

### J. Documentos, versão e release
Na ordem da §3; `release.ps1` (C3) verde; suítes completas sem a máquina ocupada por outra suíte.

---

## 5. Testes novos (`run-check-tests.ps1` e `run-guard-tests.ps1`, marcados v3.63.0)

- portão com `result.json` de ambiente → reparo e repetição, 2ª vez → formulário, `configuration` → formulário direto; nenhum QA disparado;
- `accept -Resume`: mesma identidade reaproveita, identidade diferente roda tudo, cenário com `.scn` mudado roda de novo; o mesmo com o executor do projeto (`{only}`);
- base por frente: arquivo de teste, de `toolingPaths` e de produção;
- `validation.md` com cada causa → a rota certa e na ordem; causa fora da lista → QA classifica; valores antigos do GAP aceitos;
- `Get-WorkId` reconhece `S6` e `S6-F2` e não casa `Q-S6`; `gate_round` e retrabalho no consumo;
- `kanban.md` com a seção do portão; `/team-status` com a linha;
- `proof/` por rodada e por Task, sobrevive à rodada seguinte e à poda;
- `Write-NowSection` com registro velho; `next` remove e registra.

---

## 6. Critério de pronto

- As suítes completas verdes, rodadas uma de cada vez (o caso de tempo da v3.62.2 falhou sob carga em 17/11).
- `release.ps1` C3 verde, com o bloco `## v3.63` no changelog do processo.
- **Prova de campo no garden:** retomar o portão do sprint 6 com a v3.63.0 instalada. O critério: uma falha de ambiente não abre Task, o aceite retoma e o `validation.md` cita prova que existe.

---

## 7. Riscos

| Risco | Mitigação |
|---|---|
| A árvore de produção erra o filtro e deixa válido um julgamento que devia vencer | `toolingPaths` só por configuração explícita; sem ela, só o filtro de teste (o mesmo do `plan.ps1`); o QA vê a base de cada frente na tabela |
| Retomada aproveita um `PASSOU` de um app diferente | identidade pelo hash do APK instalado, não pela hora; cenário com bloco mudado nunca é reaproveitado |
| Projetos com `validation.md` e GAP no formato antigo | sinônimos e leitura do formato antigo; sem a tabela nova, o `next` devolve ao QA para classificar, sem quebrar |
| `proof/` cresce sem limite | só resultado e capturas finais ou de falha; logs fora; medido no garden antes de fechar a versão |
| Mais rotas significam mais disparos em série | a ordem fixa evita retrabalho; achado `scenario` não dispara dev |

---

## 8. Decisões de desenho tomadas aqui (revisáveis antes de começar)

1. O estado do portão fica num arquivo do script (`gate.json`), separado do `validation.md`, que continua do QA.
2. A pasta de prova chama `proof/`, para não colidir com `evidence/<ID>.md`.
3. `**Natureza:**` vira `**Cause:**` no GAP, com sinônimos dos valores antigos por pelo menos uma versão.
4. A ordem das rotas é fixa: `requirement` → `screen` → `design` → `scenario` → `code`.
5. Achado com causa `environment` escrito pelo QA (apesar do item A) vai ao reparo, nunca a uma `Q-S<n>`.
6. O aviso de prova citada que não existe começa como aviso no `close.ps1`; vira reprovação numa versão seguinte, se o campo mostrar que funciona.
