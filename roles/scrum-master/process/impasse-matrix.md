# Matriz de impasses — quem resolve cada impasse (R36)

> **Dono:** SM · **Fonte única** da regra "a decisão é de quem?" (v3.66.0). O [`hooks/impasses.json`](../../../hooks/impasses.json) é o derivado que os scripts e as guardas leem; o C3 (`scripts/checks/release.ps1`) confere os dois e confere que toda rota gravada pelo `run.ps1` e pelo `gate.ps1` existe aqui. Mudou a matriz, muda o JSON no mesmo ciclo.

**Por que existe.** Até a v3.65 a mesma regra morava em nove lugares — o `run.ps1`, o `gate.ps1`, as guardas G3, G20 e G24, a tabela "a decisão é dele?" do [`stakeholder-question.md`](../templates/stakeholder-question.md), a escada da R25 ([`workflow-sprint.md`](workflow-sprint.md) §Bloqueio), o §6b do [`workflow.md`](workflow.md) e os prompts do executor de Task e do PO — e cada correção tapava um deles. Na preparação do sprint 7 do projeto piloto (23/11), 15 de 22 chamadas ao stakeholder eram do time.

**Como se usa.** Quem trava (papel ou sessão) não pergunta direto ao stakeholder: declara o impasse no `impasse.ps1 raise` (§2), que diz o dono e grava o caso no registro da trilha (§3). Só os tipos que sobem gravam a rota ao stakeholder — e a G24 só deixa sair formulário com ela.

## 1. Matriz

| Tipo (`type`) | Dono (`owner`) | Sobe ao stakeholder (`reachesStakeholder`) | Evidência (`evidence`) | Só por script (`scriptOnly`) | Rotas antigas (`legacyRoutes`) | Exemplos |
|---|---|---|---|---|---|---|
| `scope` | `stakeholder` | `direct` | `detail` | não | — | entra, sai ou muda o que a História entrega; a reversão de um corte |
| `stored-data` | `stakeholder` | `direct` | `detail` | não | — | arredondar valores já gravados; migração que apaga ou reescreve dados |
| `schedule` | `stakeholder` | `direct` | `detail` | não | — | entrada fora da Planning acima da capacidade; prazo do sprint |
| `contradicts-acceptance` | `stakeholder` | `direct` | `consulted` | não | — | o relato pede outro formato para uma tela já aceita na Review |
| `gate` | `stakeholder` | `direct` | `gate` | não | `portao`, `review` | ① SDD, ③ pacote, aceite da Review, aceite do sprint 0, ajustes do `fix plan` (R33), ⚠️ aceito como dívida |
| `strategic` | `stakeholder` | `direct` | `detail` | não | — | trocar de stack ou de provedor, serviço pago, licença, ADR |
| `accepted-risk` | `stakeholder` | `direct` | `detail` | não | — | conviver com um gap conhecido sem corrigir |
| `external-action` | `stakeholder` | `direct` | `detail` | não | — | push, publicação, rede, dependência nova que nenhuma decisão cobre; comando que o classificador negou (uma vez por sessão) |
| `configuration` | `stakeholder` | `direct` | `detail` | não | — | chave do `guards.json` ou do `models.json` (arquivos dele no `ownership.json`) |
| `authorization` | `stakeholder` | `direct` | `detail` | não | — | escopo do engajamento de segurança, credencial de teste |
| `plugin-update` | `stakeholder` | `direct` | `detail` | não | — | o `/team update` com mudança de processo |
| `stakeholder-request` | `stakeholder` | `direct` | `quote` | não | — | "apresente em formulário e eu escolho" — a frase dele, citada |
| `blocked` | `stakeholder` | `afterLadder` | `ladder` | não | `bloqueio` | bloqueio que o par PO + Arquiteto não fechou (R25, degrau 2) |
| `product-gap` | `stakeholder` | `afterLadder` | `ladder` | não | `gap-produto` | o PO subiu o que muda para o usuário |
| `environment` | `stakeholder` | `direct` | `none` | sim | `ambiente` | o reparo do ambiente não resolveu |
| `environment-repeated` | `stakeholder` | `direct` | `none` | sim | `ambiente-repetido` | ambiente diagnosticado pela 2ª vez |
| `stalled` | `stakeholder` | `direct` | `none` | sim | `travamento` | a mesma etapa travou de novo |
| `no-progress` | `stakeholder` | `direct` | `none` | sim | `sem-avanco` | o portão não avança |
| `target-flapping` | `stakeholder` | `direct` | `none` | sim | `vaivem-alvo` | o aparelho cai e volta sem parar |
| `starting-state` | `stakeholder` | `direct` | `none` | sim | `estado-de-partida` | a prova no aparelho não tem como começar e não há política |
| `target-configuration` | `stakeholder` | `direct` | `none` | sim | `configuracao-do-alvo` | APK sem depuração, `cdp.pageUrl` que não casa |
| `commands` | `stakeholder` | `direct` | `none` | sim | `comandos` | comando do plano que a G14 não libera (formulário único) |
| `technical` | `architect` | `never` | `none` | não | — | biblioteca da stack, padrão de projeto, estimativa, plugin oficial da plataforma; vira `strategic` só se mudar stack, provedor, custo ou licença |
| `design` | `user-experience` | `never` | `none` | não | — | mínimo legível, altura de card vizinho, comportamento em letra grande |
| `product-rule` | `product-owner` | `never` | `none` | não | — | texto de alerta, regra dentro do escopo aprovado, o que fazer fora da cobertura de dados |
| `proof` | `quality-assurance` | `never` | `none` | não | — | conferir um defeito no código; o relato do stakeholder **vale como evidência observada** — não se pede que ele confira de novo |
| `board` | `scrum-master` | `never` | `none` | não | — | qual passo vem primeiro, conversa nova ou não, a ordem da fila |
| `routine` | `routine` | `never` | `none` | não | — | "aciono a QA?", "anoto no documento?", "sigo?", "rodo a triagem antes?", ler estado ou log — quem perguntou executa |
| `record` | `file-owner` | `never` | `none` | não | — | anotar no `gaps.md`, no backlog, numa ficha — o dono vem do `hooks/ownership.json` |
| `plugin-failure` | `operator` | `never` | `detail` | não | — | permissão negada a passo do roteiro, script ou modelo do plugin com defeito — vai a `note.md` como ocorrência de plugin |

**Leitura das colunas.**
- **`reachesStakeholder`:** `never` = fica no time; `direct` = vai ao stakeholder; `afterLadder` = só depois do degrau 1 da R25 (o par PO + Arquiteto).
- **`evidence`:** o que o `raise` exige além do básico (§2):
  - `detail`: o `-Detail`, com o rótulo do JSON;
  - `consulted`: o `-Consulted` aponta a decisão aceita (§7 N, D-k ou o impasse);
  - `quote`: o `-Quote` com a frase do stakeholder, que a G24 confere no transcrito da sessão;
  - `gate`: o `-Gate` (① · ③ · review · sprint0 · fix-adjust · debt);
  - `ladder`: o `-Detail` com o que o degrau 1 concluiu.
- **`scriptOnly`:** a rota só é gravada pelo `run.ps1` ou pelo `gate.ps1`, e o `raise` recusa.
- **`legacyRoutes`:** o identificador que a `.team-project/.ask-route` já usava. Continua valendo, e a G24 e o `plain.ps1` o leem.
- **Encadeamento:** o dono de um tipo do time que conclui que a decisão muda escopo, dado, prazo ou aceite abre outro impasse, do tipo que sobe, com `-From <id do primeiro>`. O kanban mostra a cadeia.
- **Projeto:** `guards.json → impasses.extra` acrescenta tipos. Não muda dono nem subida de tipo que já está aqui.

## 2. Declarar o impasse — `impasse.ps1`

```
powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/impasse.ps1" raise -Type <type> -Part <H-Z|T-098|F-010|S7|projeto> -Subject <chave-curta> -Origin <papel ou modo> -Consulted "<§7 N | D-k | S7-I3 | none>" -Text "<o impasse numa frase>" [-Detail "<…>"] [-NewFact "<o que mudou>"] [-From <id>] [-Distinct "<por que é outro assunto>"] [-Quote "<a frase do stakeholder>"] [-Gate <①|③|review|sprint0|fix-adjust|debt>] [-Path <arquivo, no tipo record>]
```

**O que o `raise` faz:**
- **Já decidido:** procura decisão para a mesma parte e o mesmo assunto, no registro de qualquer trilha e na §7 do README (linha `[RESOLVIDO …]` com `{subject: <chave>}`). Achou e não há `-NewFact`: **recusa** (exit 3), mostra a decisão e registra a recusa. O kanban a mostra como "não perguntou de novo".
- **Assunto novo numa parte que já tem decisões:** mostra os assuntos dela e exige `-Distinct`. Trocar a palavra não escapa do "já decidido".
- **Evidência:** confere a do tipo (§1).
- **Tipo do time:** imprime o dono e a linha `Agent` pronta. Não grava rota.
- **Tipo que sobe:** grava a rota (`.team-project/.ask-route`) com o texto simples, de onde o formulário parte (R22, H1, R34).
- **Durante o `sprint run`:** só o `run.ps1` e o `gate.ps1` levam ao stakeholder (R25 c). O `raise` de tipo que sobe é recusado, com uma exceção: o `stakeholder-request`, quando o stakeholder interrompeu, e nesse caso a parada (d) é `run.ps1 pause` antes. Os tipos do time seguem registrados.

**`close -Id <id> -Summary "<a decisão em frase simples>" -Ref "<arquivo>#<âncora>" [-Allow "<cmd>;<cmd>"]`:** fecha o caso, ligando-o ao lugar onde o dono gravou a decisão. O `-Allow` traz os comandos que a decisão aprovou:
- os que vão a `runCommands` passam pelo `run.ps1 allow`;
- os de instalação, rede ou push, que a G14 nunca libera ao papel, ficam no registro, e a sessão os roda em nome da decisão citada.

**`owner -Path <arquivo>`:** o dono do arquivo pelo `hooks/ownership.json`, com a linha `Agent`.

**`list [-Trail S7|B-002] [-Format plain|review]`:** o registro da trilha. O `review` sai pronto para a seção "Decidido pelo time sem você" da Review.

## 3. Onde fica o caso — o registro da trilha

| Situação | Arquivo |
|---|---|
| sprint aberto | `.team-project/sprints/<n>/team-decisions.jsonl` |
| bloco de fix do run ativo, ou aberto | `.team-project/fixes/B-<nnn>/team-decisions.jsonl` |
| fora dos dois (prepare, plan, triagem do `note.md`) | o sprint em preparação, `.team-project/sprints/<n+1>/team-decisions.jsonl`; a Planning herda |

- **O formato:** uma linha JSON por evento (`raise`, `close`, `refused`), só acrescentada; o estado é a dobra dos eventos do mesmo id. O id tem a trilha na frente: `S7-I3`, `B-002-I1`.
- **A decisão em si** fica no lugar do dono: a resposta técnica do Arquiteto, a spec do UX, a História ou o backlog do PO, o cenário da QA, a §7 do README para a do stakeholder. O registro é o índice.
- **A pasta do sprint em preparação** só com esse arquivo não abre o sprint: o número corrente vem do README §2.

## 4. Onde o stakeholder vê
- **Kanban do sprint e do bloco:** a subseção **"Decisões do time"**, no `## Controle`, é gerada pelo `kanban.ps1` a cada `raise` e `close` e não se edita à mão. Colunas: quando · o que foi decidido · quem decidiu · por que não precisou de você · onde está.
- **Resumo do kanban e `/team-status`:** a linha "o time decidiu N coisas sozinho; M subiram a você".
- **Review e fechamento do fix:** a seção "Decidido pelo time sem você" (`impasse.ps1 list -Format review`). Qualquer linha pode ser revertida, e a reversão volta como `contradicts-acceptance` com `-From`.

## 5. As guardas
- **G24** (`hooks/pre-tool.ps1`): todo formulário da sessão principal só sai com a rota gravada. No `sprint run`, a rota vem do `run.ps1` ou do `gate.ps1`; fora dele, do `impasse.ps1 raise`. Vale um formulário por rota, com refação em 10 min. No `stakeholder-request`, a citação tem de estar numa fala do stakeholder na sessão.
- **G26** (`hooks/stop.ps1`): fora do `sprint run` (dentro dele, a G20), barra o turno que termina oferecendo uma ação do roteiro ("Quer que eu…?", "Posso…?") sem rota gravada.
  - O padrão é `warn` (`guards.json → impasses.offerGuard`): registra no `guards.log` e no `/team-usage` sem barrar.
  - O `enforce` vem depois de medir o falso positivo em campo.
  - As frases ficam em `hooks/impasses.json → offerPhrases`.
