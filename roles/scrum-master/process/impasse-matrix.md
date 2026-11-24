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

### 1a. As causas do 🔺 GAP e do achado do portão
O `run.ps1 done -Result gap -Cause <causa>` e o `gate.ps1` (o achado do `validation.md`) acham o dono **por aqui**: a causa diz o tipo, e o tipo diz o dono (§1). Antes, cada script tinha um mapa próprio. A causa `code` não está aqui: no portão ela vira a Task de correção, e no GAP do dev vale como `design`. A `environment` também não: segue a escada de ambiente do `run.ps1`.

| Causa (`causes`) | Tipo (`type`) | Rótulo (`label`) |
|---|---|---|
| `requirement` | `product-rule` | requisito |
| `screen` | `design` | tela |
| `design` | `technical` | desenho |
| `appearance` | `technical` | aparência |
| `process` | `technical` | processo |
| `scenario` | `proof` | cenário |
| `executor` | `proof` | executor do plugin |

### 1b. Os papéis: o comando e o nome curto
| Papel (`roles`) | Comando (`command`) | Nome curto (`short`) |
|---|---|---|
| `product-owner` | `/po` | o PO |
| `user-experience` | `/ux` | o UX |
| `architect` | `/arc question` | o Arquiteto |
| `quality-assurance` | `/qa` | o QA |
| `scrum-master` | `/sm` | o SM |

## 2. Declarar o impasse — `impasse.ps1`

```
powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/impasse.ps1" raise -Type <type> -Part <H-Z|T-098|F-010|S7|projeto> -Subject <chave-curta> -Origin <papel ou modo> -Consulted "<§7 N | D-k | S7-I3 | none>" -Text "<o impasse numa frase>" [-Detail "<…>"] [-NewFact "<o que mudou>"] [-From <id>] [-Distinct "<por que é outro assunto>"] [-Quote "<a frase do stakeholder>"] [-Gate <①|③|review|sprint0|fix-adjust|debt>] [-Path <arquivo, no tipo record>]
```

**O que o `raise` faz:**
- **Já decidido:** procura decisão para a mesma parte e o mesmo assunto, no registro de qualquer trilha e na §7 do README (linha `[RESOLVIDO …]` com `{subject: <chave>}`). Achou e não há `-NewFact`: **recusa** (exit 3), mostra a decisão e registra a recusa. O kanban a mostra como "não perguntou de novo".
- **Assunto novo numa parte que já tem decisões:** mostra os assuntos dela e exige `-Distinct`. Trocar a palavra não escapa do "já decidido".
- **Evidência:** confere a do tipo (§1).
- **Tipo do time:** imprime o dono e a linha `Agent` pronta. Não grava rota.
- **Tipo que sobe:** grava a rota (`.team-project/.ask-route`) com o texto simples, de onde o formulário parte (R22, H1). Em projeto com Identificador remoto, grava também a pendência **dentro** da §7 do README, com o prefixo R34 e o `{subject:}`, e diz com que prefixo a pergunta começa; o `close` a marca como resolvida.
- **As rotas do `run.ps1` e do `gate.ps1`:** entram no mesmo registro pelo `Set-AskRoute` (`lib.ps1`), com o tipo pela rota antiga, sem recusar nada (a escada deles continua a deles); a rota apagada fecha os impasses que o run abriu.
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

## 6. Exemplos do roteiro — quem decide o caso que já aconteceu

Os casos medidos nos projetos piloto, que até a v3.65 viviam na tabela "a decisão é dele?" do [`stakeholder-question.md`](../templates/stakeholder-question.md), cada um com o tipo da matriz (§1). Um caso novo entra aqui, com o tipo, e não no modelo da pergunta.

| Tipo | Se a pergunta é… | Quem decide | O que fazer |
|---|---|---|---|
| `routine` | cenário que só se prova por teste de código | o roteiro | marcar `(teste)` na coluna Cenários e uma linha no run-log, sem formulário |
| `technical` | nome de teste (id) que falta na tela | Arquiteto | 🔺 GAP: ele estende o plano ou o contrato de ids |
| `blocked` | teste vermelho fora da Task, premissa da sessão, em que commit entra uma correção, ordem da fila | par PO + Arquiteto (degrau 1) | `mark.ps1 -To blocked`; a fila segue nas independentes |
| `technical` | dois planos para a mesma Task, ajuste de lint previsto no plano | Arquiteto / o próprio plano | comparar e seguir; avisar em uma linha |
| `routine` | "sigo?", "tento de novo?", "retomo o sprint?" | o roteiro | `run.ps1 next` (ou, em outro comando, dizer em uma linha como retomar) |
| `routine` | estado de um processo, de um arquivo, de um log | quem pergunta | ler; nunca pedir ao stakeholder que rode um comando de leitura |
| `target-configuration` | o `accept` sai com exit 4 e `configuration` no `result.json` (APK sem depuração da WebView, Node < 22, várias páginas sem `cdp.pageUrl`, `cdp.pageUrl` que não casa nenhuma página carregada, app híbrido com `uiautomator`) | **o stakeholder**, dono do `guards.json` e do build — não é GAP, nem ambiente da Task, nem decisão do Arquiteto | formulário com a mensagem do `accept` e o que corrigir; sem reparo, sem dev, sem política de `deviceProofFallback` (não se aplica) |
| `starting-state` | a prova no aparelho não roda (estado de partida; serviço fora do ar) | a política do projeto (`guards.json` → `run.deviceProofFallback`) ou, sem ela, o stakeholder **uma vez** | com a política, o `run.ps1 done` aplica a prova por teste sozinho; sem ela, no formulário ofereça gravar a política, e a resposta se aplica com `run.ps1 prove -Task <T-ID>` — nunca editando plano ou quadro à mão |
| `routine` | a decisão já tomada não chegou ao plano ou ao quadro; "posso tirar de 🔴?" | o roteiro | prova por teste com `run.ps1 prove -Task <T-ID>`; a Task sai de 🔴 por `mark.ps1 -Task <ID> -To build -Reopen resume` (o reparo foi fora do repositório) ou `-Reopen replan -Decision "<a resposta>"` (a decisão muda o que o plano manda); nunca perguntar de novo o que já foi respondido |
| `technical` | plano acima de 30 KB numa Task em construção | Arquiteto | substitui o texto que a decisão derrubou, sem dividir a Task ([`sprint-run.md`](../process/sprint-run.md) §Plano acima de 30 KB); o `run.ps1 start` dá o prompt dele — nunca "encurtar ou dividir?" ao stakeholder |
| `routine` | arquivo alterado por outra Task trava o fechamento | o roteiro | o que já estava alterado quando a Task começou não é dela (`handoff/<T-ID>-alheios.json`); o close o ignora, siga |
| `technical` | id dinâmico que falta, comentário no HTML × lista no guards.json | Arquiteto | declara no código (`// testid-dinamico: <padrão>`), sem mexer no `guards.json` e sem formulário |
| `routine` | serviço do ambiente desligado (Docker…) | o roteiro | declarado em `guards.json` → `run.prereqs`, o `run.ps1 start` o sobe; formulário só se ele não subir |
| `routine` | "pode pausar?" / o stakeholder mandou parar | o stakeholder já decidiu | `run.ps1 pause` (apaga o `.active-run` e registra); nunca pedir que ele apague arquivo |
| `routine` | "quando posso atualizar o plugin?" | o roteiro | todo reinício por teto de contexto e todo intervalo entre Tasks é ponto seguro — a linha PARA O STAKEHOLDER já diz |
| `routine` | devolução de plano externo recusada | o roteiro | uma linha, sem formulário |
| `routine` | a medição, o teste ou o build ainda roda: "espero ou recomeço?" (v3.65.9) | o roteiro | esperar é o padrão: o `run.ps1 next` manda esperar com o watcher; travado na 1ª vez, encerrar e retomar sozinho (regra 5). Só a 2ª vez vai ao formulário |
| `plugin-failure` | a causa é um padrão do **próprio plugin** (valor que o plugin sugeriu ou gravou, regra dele) — "o plugin exige X e o app faz Y, como corrigir?" (v3.65.9) | o plugin | não é escolha do stakeholder: registre o defeito em `.team-project/note.md` (o `/review` o leva ao plugin) e siga com o padrão novo, se a versão instalada já o traz; o que o projeto **mudou por conta própria** continua dele. No garden (21/11, 08:50 → 17:30) o `readyExpr` do plugin esperava a rede inteira, e o stakeholder recebeu três formulários sobre como corrigir |
| `proof` | o achado de cenário voltou de novo depois da correção do QA (v3.65.9 · v3.65.13) | QA, depois o Arquiteto (degrau 1), depois o PO (degrau 2) | o portão conta só disparo real e zera quando a falha muda de passo; esgotado o QA, o Arquiteto revê a causa; voltando de novo, o PO decide o que é de produto (aceitar como dívida, mandar fazer de outro jeito). Formulário só com a pergunta que o PO subiu dizendo **o que muda para o usuário** (`**Stakeholder:** … — **Muda para o usuário:** …` no `gate/<ID>.md`), ou se o achado voltar **na mesma falha** depois do PO |
| `proof` | qual passo de teste usar, como o teste volta ao topo da lista, um contorno no cenário, a ferramenta de prova que falhou (v3.65.13) | QA; a ferramenta, o plugin | nenhuma opção muda o produto: o time decide e registra. O QA passa pelos contornos em ordem (a captura; voltar a tela ao estado inicial com `restart`, `back` ou outra aba; reordenar ou dividir o cenário; `seed`) antes de dizer que não há como, citando os verbos de [`scenario-language.md`](../../../standards/scenario-language.md) que conferiu. A falha da ferramenta é causa `executor` e vai como ocorrência em `.team-project/note.md`. No garden (22/11, 16:27) o stakeholder recebeu "o teste não consegue voltar ao topo da lista: como seguir?" — a sessão disse que a linguagem não tinha como, e a resposta (sair da aba e voltar) estava nos verbos que ela já tinha; a causa real era o executor rolando a faixa de filtros fora da tela |
| `routine` | instalar o app novo no aparelho, reiniciar ou reparar o emulador; "o adb foi negado à sessão" (v3.65.11) | o operator | a guarda nega o aparelho à sessão de propósito: é a rota, não um bloqueio. O reparo é `target.ps1 -Repair`; a instalação, o APK declarado em `targets.android.apk` (o accept instala). Formulário só se o app gerado de novo continuar o antigo **depois do Arquiteto** (o portão já diz) |
| `technical` | o build gerou o mesmo APK de antes; "o app está certo, sigo com o teste?"; investigar por que a geração não pega a mudança (v3.65.12) | o operator, depois o Arquiteto | o portão manda o operator gerar, instalar e repetir o aceite (o accept confere o app pelo conteúdo das fontes, não pela data); recusado de novo, o Arquiteto acha a causa e conserta o ambiente do build. A sessão não pausa nem pergunta: `run.ps1 pause` sem o pedido do stakeholder é recusado. No garden (22/11, 08:18 → 08:35) a sessão parou o run por conta própria e levou ao stakeholder cache, volume e hash. Depois, descobriu sozinha que o app estava certo e ainda perguntou se seguia |
| `routine` | "repito o aceite inteiro?" ou "o teste rodou com o app velho, refaço?" (v3.65.11) | o roteiro | o portão mede de novo quando a produção, os cenários **ou o app** mudaram (a correção que provou o cenário com outro app basta) e o `-Resume` reaproveita o que já passou com o mesmo app. Aceite completo por decisão do Arquiteto, só por causa estrutural |
| `technical` | a sessão discorda do `run.ps1 next` ("o script quer corrigir o código, mas o problema é outro") (v3.65.11) | o Arquiteto (degrau 1) | `/arc question` com as duas provas; a resolução dele (`gate/<ID>.md`) muda a rota. Nunca uma pergunta escrita ao stakeholder: a G20 barra o fim de turno que termina em pergunta sem formulário |
| `routine` | o APK do projeto não está declarado no `guards.json` (v3.65.11) | o roteiro | com uma pasta só de APKs no disco, o `next` (e o `/team update`, passo 7q) dá a declaração inferida: a sessão grava e diz em uma linha o que gravou e como desfazer. Formulário só com APKs em várias pastas ou nenhum |
