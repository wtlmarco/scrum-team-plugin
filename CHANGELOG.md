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

## v3.66.0 — 2026-11-23
**Branch:** `feat/v3.66.0` a partir de `develop` (`8e20d86`, com a v3.65.15 mesclada pelo PR #223) · **Plano:** `melhorias/plano-v3.66.0.md` (etapa 1, itens A a F; etapa 2, itens G a J; e o item K)
Origem: a conferência da preparação do sprint 7 do garden (23/11, plugin 3.65.14). O stakeholder foi chamado 22 vezes, e 15 eram do time:
- licença para o próprio trabalho;
- o que ele mesmo tinha relatado ou decidido;
- decisão técnica e de desenho;
- falha do próprio plugin.

A regra "quem resolve" morava em nove lugares. A G24 só olhava a sessão do `sprint run`, e as perguntas saíram do `prepare` e do `plan`. Pedido dele: um módulo central que decida para onde vai o impasse, em todo o plugin, com o registro por sprint ou fix à vista no kanban.

**A · A matriz de impasses** (`roles/scrum-master/process/impasse-matrix.md`, fonte; `hooks/impasses.json`, derivado). Trinta tipos, cada um com dono, subida (`never` · `direct` · `afterLadder`, que é a R25), evidência, "só por script" e as rotas antigas da `.ask-route`.
- **Sobem:** escopo, dado gravado, prazo, contradição com aceite, portão, estratégico, risco aceito, ação externa, configuração, autorização, atualização do plugin, pedido do stakeholder, e o bloqueio e a lacuna de produto depois do par PO + Arquiteto.
- **Ficam no time:** técnica, desenho, regra de produto, prova, ordem do trabalho, passo do roteiro, registro em documento e falha do plugin.
- **Projeto:** acrescenta tipos em `guards.json → impasses.extra`, sem mudar os do plugin.
- **C3 (`release.ps1`, linha `impasses`):** confere os dois arquivos e que toda rota gravada pelo `run.ps1` e pelo `gate.ps1` tem tipo.

**B · `impasse.ps1`** (`raise` · `close` · `owner` · `list`; núcleo em `impasse-lib.ps1`, carregado pelo `plain.ps1` e por isso disponível aos hooks, ao kanban e ao run).
- **Já decidido:** recusa (exit 3) o que já foi decidido para a mesma parte e o mesmo assunto, no registro de qualquer trilha ou na §7 do README com `{subject: …}`, e mostra a decisão. Assunto novo numa parte com decisões pede `-Distinct`.
- **Evidência do tipo:** confere `-Detail`, `-Consulted` apontando o aceite, `-Quote`, `-Gate` e a categoria do estratégico.
- **Tipo do time:** dá a linha `Agent` do dono.
- **Tipo que sobe:** grava a rota com o texto simples.
- **No `sprint run`:** tipo que sobe é recusado (R25 c), salvo `stakeholder-request`.
- **`close -Allow`:** leva os comandos aprovados ao `run.ps1 allow`; instalação, rede e push ficam com a sessão, em nome da decisão.
- **Fonte única:** a linha `Agent` (`Get-AgentDispatchText`, `common.ps1`) e a regra de propriedade (`Find-OwnershipRule`) agora valem para o `run.ps1`, a G8 e o `impasse.ps1`.

**C · A G24 em toda sessão principal.** Fora do run, o formulário só sai com a rota do `raise`, e a recusa traz o comando e os tipos que sobem. O `stakeholder-request` só passa com a frase citada presente numa fala do stakeholder no transcrito. Ficam fora o papel, o clone-fonte do plugin e o modo benchmark.

**D · G26 (nova, `stop.ps1`).** Fora da sessão do run, o fim de turno que oferece ação do roteiro ("Quer que eu…?", "Posso…?"; frases em `impasses.json → offerPhrases`) sem rota. `warn` é o padrão (`guards.json → impasses.offerGuard`, só registra) e `enforce` barra; a 3ª vez em 10 min passa.

**E · As falhas do plugin não viram pergunta:**
- `kanban.ps1 -Sprint <n> -Init` gera o quadro da abertura, com a Série, o Registro e as Decisões do time, ou acrescenta a Série que falta. O `run.ps1 next` recusa partir sem a Série e dá o comando.
- `Invoke-GitBegin` troca de branch levando as alterações pendentes, e o git recusa quando não é seguro; o aviso vai ao SM uma vez por run.
- `knowledge.ps1 -Consolidated` apaga o `architect/consolidation.md`.
- A falha do plugin declarada vai a `note.md` como ocorrência.

**F · O registro por trilha, no kanban.**
- **Onde:** `sprints/<n>/team-decisions.jsonl`, ou `fixes/B-<nnn>/` no fix; fora dos dois, o sprint em preparação, que a Planning herda. Uma linha por evento, só acrescentada.
- **Kanban:** a subseção "Decisões do time" no Controle (e no kanban do bloco), mais a linha do Resumo e do `/team-status`.
- **Review:** a seção "Decidido pelo time sem você" (`impasse.ps1 list -Format review`), revertível.

**Regra:** R36 (`working-rules.md` e índice, R1–R36).
**Documentos:** `artifact-ownership.md` e `ownership.json`, o manifesto do `.team-project/`, os modelos do kanban, da Review e da pergunta, o `workflow-sprint.md` (passo 11, consolidação), o `fix-run.md`, os `commands/{sm,po,arc,ux,team}.md`, o `how-to.md`, o `hooks/COVERAGE.md` e o modelo do `guards.json`.

**Testes:**
- `run-check-tests.ps1`, casos v3.66.0: o `raise` em cada saída (dono, já decidido pelo registro e pela §7, `-Distinct`, evidência, só por script, R25 c), o `close` com `-Ref` e `-Allow`, o `list -Format review`, o `owner`, a trilha n+1, o `kanban -Sprint -Init` (novo e reparo), o `-Consolidated`, o `next` sem Série e a branch que leva a alteração ou é recusada pelo git.
- `run-guard-tests.ps1`: a G24 fora do run (com e sem rota, rota usada), o `stakeholder-request` (frase presente e ausente) e a G26 (`warn`, `enforce`, oferta "Posso…?", resposta sem oferta, rota recente, desligada). Os casos de forma da G3 gravam a rota antes; três casos antigos da G24 mudaram de sentido (outra sessão, trilha fix, sem `.active-run`: agora pedem rota).

**Etapa 2 — o run, o portão, o executor e a triagem na mesma matriz:**
- **G · O dono da causa vem da matriz.** A matriz ganha a §1a, causas do 🔺 GAP e do achado do portão (causa → tipo → dono, com o rótulo), e a §1b, papéis (comando e nome curto). Sai o mapa `$ownG` do `run.ps1 done -Result gap` e sai o `$owners` do `gate.ps1`: os dois leem `Resolve-ImpasseOwner`. O `$docOwnerRoles` da consolidação lê o papel pelo nome do dono no `hooks/ownership.json` (`Get-RoleByOwnerName`). A saída do run e do portão não muda (a suíte deles passa igual). O C3 confere a §1a e a §1b contra o JSON e que o dono de cada causa tem papel.
- **G · A rota do script entra no registro.** O `Set-AskRoute` (`lib.ps1`) registra cada rota do `run.ps1` e do `gate.ps1` no `team-decisions.jsonl` da trilha, com o tipo pela rota antiga, e põe o id do impasse na `.ask-route`. O `next` repetido não duplica, e a rota apagada (start, construir, pausa) fecha os impasses que o run abriu. Não recusa nada: a escada do run e do portão continua a dela.
- **H · A tabela "a decisão é dele?" vira exemplos da matriz.** As 25 linhas do `stakeholder-question.md` passam à §6 da matriz, cada uma com o tipo; o modelo fica só com a forma da pergunta. O §6b do `workflow.md`, a escada R25 do `workflow-sprint.md`, o `agents/task-runner.md` (o dono do GAP é o que o `done` imprime, pela matriz) e a triagem do `agents/product-owner.md` (defeito = `proof`, com o relato do stakeholder como evidência; escopo = `scope`; dúvida = `product-rule`) apontam para ela. A G20 aponta a matriz no lugar da tabela.
- **I · O dono antes do bloqueio da G8.** Já entrou na etapa 1 (a mensagem da G8 traz a linha `Agent` do dono, pelo `Find-OwnershipRule`).
- **J · O formulário passa na G3 de primeira.** Em projeto com Identificador remoto, o `raise` de tipo que sobe grava a pendência **dentro** da §7 do README, com o prefixo R34 e o `{subject:}`, e diz com que prefixo a pergunta começa. O `close` marca a pendência `[RESOLVIDO em … — <a decisão>]`.

**Testes (etapa 2):**
- `run-check-tests.ps1`: o dono de cada causa pela matriz e o papel pelo nome do dono; a rota do run registrada uma vez e fechada ao apagar; a pendência R34 gravada na §7 e resolvida pelo `close`, com a pergunta repetida recusada; o C3 com a causa só no JSON.
- `run-guard-tests.ps1`: o `raise` grava a pendência e o formulário com o prefixo passa na G3 e na G24.

**Item K — reuso, centralização e design patterns como standard do Arquiteto (aprovado em 23/11):**
- **Standard:** `standards/implementation-principles.md` ganha o **§4.6** (*Reuse, componentization and centralization*: procurar antes de criar, estender antes de duplicar, uma regra num lugar só, peça usada duas vezes vira compartilhada, o que varia é configuração) e o **§4.7** (*Design patterns*: o padrão vem do problema, com o catálogo Strategy · Adapter/Port · Factory · Observer/Mediator · Template Method · Repository e o que não se faz). O §4.5 ganha "abstração especulativa não é reuso", e o Quadro de Verificação (§7) ganha a linha 24.
- **Perfis de stack:** cada um ganha o exemplo na tecnologia, sem ser normativo: angular NG-8, ionic-capacitor IONIC-4, react RE-8, kotlin-android KA-9, dotnet §12.
- **Plano:** a **§2a. Reuse and patterns** entra no plano pleno (regra 36), com as linhas `reuses:` · `extends:` · `new:` com motivo · `pattern: <Name> — <problem> — <simpler alternative rejected>` · `none:` com motivo.
  - O `plan.ps1` reprova o plano sem a seção ou com uma linha incompleta.
  - Ficam de fora a variante leve e o plano de sprint com o ③ aprovado antes da v3.66.0, inclusive o sprint 7 em curso do projeto piloto.
- **Plano externo:** o roteiro do pacote (`external-plan.md`) ganha a instrução `[reuso]`.
- **Quebra:** `breakdown.md` ganha **Shared parts** (a peça comum nasce numa Task; as outras a citam em `reuses:`).
- **Arquiteto e QA:** `roles/architect/README.md` e `skills.md` §2a apontam para o §4.6 e o §4.7. A frente 2 da QA confere o `reuses:` e o `extends:` contra o diff.

**Pendências da etapa 1, fechadas:**
- **Comandos implicados:** a linha **Comandos implicados:** entra na ficha (`breakdown.md`, regra 10). O comando que a Task exige e o run não libera sozinho vai ao ③, e a aprovação vira `impasse.ps1 close -Allow`.
- **`/team-usage`:** ganha a seção "Impasses (matriz, R36)". Ela traz o registro do sprint (resolvidos, em andamento, subidos, recusados, por tipo) e as recusas da G3 e da G24 e as ofertas vistas pela G26, contadas no `guards.log`. É a medida da meta.
- **Inventário dos formulários:** um caso de guarda por modo que abre formulário legítimo (update, onboarding, brainstorm, ①, sprint 0, prepare, ③, Review, propostas de configuração do close, ajustes do fix plan, `/sec` e decisão estratégica). Cada um declara o impasse do tipo dele e passa na G24 de primeira.
- **G7 com a sequência do GAP (item H):** a matriz ganha, na §1a, a sequência de cada causa: requisito PO → Arquiteto → dev; tela UX → Arquiteto → dev; cenário QA → dev; desenho, aparência e processo Arquiteto → dev. O `run.ps1 done -Result gap` a grava em `.team-project/.gap-route` e a imprime. Com o GAP aberto, a G7 deixa o executor disparar, para aquela Task, só os papéis da sequência e o `operator`. Isso libera o PO e o UX, que eram negados ao executor desde a v3.63, e barra o que sai da sequência. A rota sai quando a Task fecha; o C3 confere a coluna.

**Testes (item K e pendências):**
- `run-check-tests.ps1`: a regra 36 em sprint antigo (n-a), sem a §2a, com `new:` e `pattern:` incompletos, completa, com `none:` e na trilha leve; o `/team-usage` com os impasses.
- `run-guard-tests.ps1`: o inventário, com doze modos; a G7 com a sequência (PO liberado no GAP de requisito, QA fora dela negada, `operator` sempre, outra Task pela regra de antes, GAP técnico ao PO negado, rota vencida).
- `run-check-tests.ps1`: a sequência pela matriz e a rota que sai com a Task.
## v3.65.15 — 2026-11-23
**Branch:** `fix/v3.65.15` a partir de `develop` (`94323fc`, com a v3.65.14 mesclada pelo PR #221)
Origem: o ensaio do kit do benchmark da virada (23/11), antes de qualquer braço. Num app Android nativo, um `.kt` mexido e desfeito (`git checkout`) deixou o `accept` recusando "APK mais velho que o código" a cada rodada. O `assembleDebug` viu as fontes iguais e não regravou o APK, cuja data não mudou. Só saiu apagando o APK. É o laço que a v3.65.12 (item A) queria fechar.

**A · A idade do APK pelo conteúdo vale para caminho com maiúscula** (`lib.ps1` `Get-ContentChangedSince`). As chaves dos arquivos são minúsculas, e iam assim ao `git ls-files`, ao `git status` e ao `git log`. O pathspec do git diferencia maiúsculas mesmo com `core.ignorecase = true`, no Windows. Todo caminho com maiúscula (quase todo `.kt`, `MainActivity.kt`, `Conteiner.kt`) saía como "fora do git", e a data voltava a valer. O caso do garden passou na v3.65.12 porque o arquivo era todo minúsculo (`lista-insumos.component.html`). Agora o pathspec vai como `:(literal,icase)<caminho>`: casa sem distinção de caixa, também com uma pasta que só mudou de grafia, e sem glob (`[`, `*` e `?` no nome).

**Testes:** `run-check-tests.ps1`, caso v3.65.15 (módulo nativo inferido de `build/outputs/apk`, `br/X/Tela.kt` e `Str[1].xml`): fonte com a data nova e o conteúdo do commit → não é app velho; `.kt` mudado → app velho. Suítes: `run-all-tests.ps1` 1223/0; `release.ps1` ok.
## v3.65.14 — 2026-11-23
**Branch:** `fix/v3.65.14` a partir de `develop` (`aa05e6f`, com a v3.65.13 mesclada pelo PR #219) · **Plano:** `melhorias/plano-v3.65.14.md` (itens A a K, aprovados pelo stakeholder em 23/11)
Origem: o `plugin-report.md` do sprint 6 do garden (22/11, plugin 3.65.12), conferido contra o `run-log.md`, o `lessons.md`, o `consumption.md`, as decisões do S6 e o código. A conferência mudou três itens do relatório:
- o "`next` manda construir com o verify vivo" era, na Task mais cara (Q-S6e, 20 M de tokens), uma série de **6 quedas de ambiente seguidas, sem limite**;
- o "cartão × plano" já estava quase todo resolvido na v3.64.0;
- a G5 tinha caminho de exceção e ele funcionou.

Mais o pedido do stakeholder sobre o git do sprint e do fix (J).

**A · A queda de ambiente ganha limite** (`run.ps1 done -Result env`; `Get-EnvDropLimit`, `Read-EnvDiag`, `handoff/<ID>-env.json`):
- Da 3ª queda no bloco em diante (`guards.json → run.envDropsBeforeDiagnosis`, padrão 3), sem reparo e sem dev, o operator diagnostica AMBIENTE × PROVA em `operator/<n>/<ID>-ambiente.md`. PROVA é o teste que estoura o prazo, como o `no message in 120000 ms` do Karma na Q-S6e.
- PROVA vai ao Arquiteto (`/arc question`), que decide o teste ou o prazo no plano.
- O 1º AMBIENTE segue o reparo e zera a contagem.
- O 2º AMBIENTE leva a Task a 🔴 sem reabertura automática, com a rota `ambiente-repetido` e a escolha em texto simples.
- O `done` que volta com o diagnóstico pedido não conta como queda nova, e o diagnóstico de antes do pedido não decide.

**B · O "Vale para" que o script lê** (`lib.ps1` `Read-AppliesTo`, `Get-ScopeTerms`, `Test-PlanTerms`, `Get-ScopeProse`, `Test-EntryApplies`, `Get-SprintDecisions`, `Get-TaskDecisionLines`; `knowledge.ps1`):
- Forma nova `plano: <termo>`: a decisão, o conhecimento ou a armadilha chega à Task cujo plano traz o termo (`plano: prova-cdp.mjs`).
- No fechamento, uma linha em §Achados de processo lista os registros com condição em texto, que não chegam a Task nenhuma. Medido no garden: **26 das 31 decisões do S6** ("toda Task de triagem…", "todo .scn que navega…").
- A repetição "não chegou à Task" traz a proposta pronta: o ID da Task, a pasta comum dos arquivos dela ou `plano:`.
- "portão do S<n>", `todas (…)` e caminhos contam como legíveis.

**C · Em conflito, vale o plano** (cartão do dev, `agents/developer.md` item 12): o cartão e o contrato dizem que, quando o texto padrão e o plano discordam, vale o plano, sem 🔺 GAP só por isso.

**D · A correção do portão prova o que corrige** (`close.ps1` R7-aceite, `run.ps1 done`, `gate.ps1`):
- O cenário que falhou e não é citado em nenhum achado que a Q-S cobre continua reprovando, sem afrouxar nada, com a linha "falharam fora dos achados da <Q-S>".
- O `done` que reprova só por esses cenários vai ao Arquiteto, para tirá-los da **Cenários:** do plano (ficam no portão), e não a outro dev.
- O portão, ao abrir ou emendar a Q-S, diz os cenários citados nos achados.

**E · Task dispensada sai riscada** (`mark.ps1 -To superseded -Decision "<decisão>"`): a linha fica "~~T-…~~ retirada — substituída", que a fila e o portão já pulavam. A estimativa sai do restante e o Registro e o run-log guardam a decisão. Nunca ✅, sem evidência; sem `-Decision`, recusa.

**F · O formulário do fechamento sem ruído** (`knowledge.ps1`):
- O GAP de ambiente que já é ocorrência de plugin não se repete nas propostas de configuração.
- A proposta só aparece quando a decisão cita uma chave de configuração, e traz a chave. Antes eram 12 linhas com o mesmo "rever … (ex.: seedTimeoutSec, timeoutMinutes)".
- O caminho de uma versão do plugin em `runCommands` vira proposta de tirar.

**G · O custo da sessão principal: medido, sem mudança de código.**
- Nas 4 maiores sessões do S6, o contexto parte de cerca de 48 mil e chega a 235 mil em 113 chamadas.
- As saídas de ferramenta somam cerca de 50 mil (`sprint-run.md` 13 mil, as 21 saídas do `next` 8 mil). O custo vem do comprimento da conversa.
- O reinício por teto já existe (`run.sessionContextCap`, 150 mil) e foi usado: 60 sessões no sprint. Ele só age sem agente em voo.
- 380 M dos 398 M da sessão rodaram em haiku 5.5, quase tudo leitura de cache. Os 47,6% em tokens exageram o custo.
- A alavanca que sobra é o teto do projeto, escolha do stakeholder.

**H · Duração legível** (`consumption.ps1` `Format-DurationTotal`): nos totais, de 1 h para cima, `191h48`, e não `11508:59`. As linhas do registro seguem em mm:ss, que os scripts leem.

**I · A contagem R28 por chamador** (`consumption.ps1`): abaixo dos Totais, os reports em `operator/<n>/` × as rodadas do operator chamadas por papel, com a diferença, mais as rodadas chamadas pela sessão (portão, diagnóstico, reconstrução), que gravam na pasta do portão e contam à parte.

**J · O git do sprint e do fix** (pedido do stakeholder; `scripts/checks/git-flow.ps1` novo; `lib.ps1` `Invoke-GitBegin`, `Invoke-GitFinish`, `Get-GitCompareUrl`; `run.ps1 next` e `Save-TaskCommit`; `guards.json → git`):
- O primeiro `next` do run cria `feat/sprint-<n>` a partir da base (`develop`; sem ela, `main`) ou volta a ela. O fix usa `git-flow.ps1 begin` e cria `fix/<id>`.
- Com alteração pendente fora de `.team-project/`, ele não troca e avisa.
- O commit de cada Task traz no corpo o "Feito" do relatório.
- No fechamento, `git-flow.ps1 finish`, rodado pela sessão: commit `docs: …` dos `docsPaths`, `git push -u origin <branch>` e o título e a descrição do PR para a base na tela, com o link de abertura no GitHub e uma cópia em `.team-project/pr/`.
- `git.push: false` só imprime o comando. Projeto sem git: nada muda.

**K · Aviso do arquivo protegido no plano** (`plan.ps1`, linha `protegidos-lint`): o plano que cita lint ou formatação, com "Arquivos protegidos: nenhum" e a configuração da ferramenta em `protectedPaths`, recebe o aviso antes da construção, sem reprovar.

**Fora:** a Q9 (resolvida na v3.65.1) e a prova no aparelho (v3.65.1 a v3.65.13, falta o campo no S7). Também fica de fora o "chegou ao cartão e não foi seguido" (3 repetições), que é obediência do agente.
**Textos:** `workflow-sprint.md` (Git do sprint), `fix-run.md` (Git do bloco), `guards.json` modelo (`git`, `run.envDropsBeforeDiagnosis`), `agents/developer.md`.
**Testes** (`run-check-tests.ps1`, marcados v3.65.14):
- A: 8 casos
- D: 4 casos
- B e F: 4 casos
- J: 8 casos, com repositório e remoto locais
- E: 2 casos
- K: 2 casos
- H: 1 caso
- I: a linha da contagem no caso do consumo existente

---

## v3.65.13 — 2026-11-22
**Branch:** `fix/v3.65.13` a partir de `develop` (`6304464`, com a v3.65.12 mesclada pelo PR #217)
Origem: o sprint 6 do garden, em 22/11, das 15:33 às 16:31. No portão, o SC-142 falhou em `tap estufa.filtro-estado.PERDIDO` com "Position out of bounds" em várias rodadas. O QA trocou o passo duas vezes, uma delas tocando em "TODOS", que caía na mesma falha. O Arquiteto não resolveu. O stakeholder recebeu "o teste não consegue voltar ao topo da lista: como seguir?". A sessão disse que a linguagem de cenário não tinha como voltar, mas os verbos para isso já existiam (sair da aba e voltar). A causa real era o executor: com a lista rolada, a faixa de filtros ficava acima da tela e o "Perdido" à direita dentro dela. O executor rolava a faixa **na horizontal, fora da tela**, e o Chromium recusava o gesto.
**A · O toque rola na ordem certa** (`dom-probe.js` `scroll-plan`, `scroll-pos`, `clipOf`, `find`; `cdp-verbs.js` `scrollOnce`, `intoView`, `pressId`). Com o elemento fora na vertical, a rolagem vertical vem primeiro e a faixa de lado vem depois. O rolador é o mais próximo que aparece na tela e ainda tem para onde ir: a faixa mais alta que ela mesma "rolava" alguns pixels na vertical e não trazia nada. O `scroll-pos` mede o mesmo rolador que o plano escolheu. O recorte usa a área de conteúdo, sem borda nem barra. O toque busca o centro a 12 px da borda: a 3 px, ele caía na barra sobreposta e ia à faixa ("coberto"). A caixa é medida de novo depois de a tela parar de rolar. O meio de gesto que o navegador recusa passa ao seguinte, em vez de derrubar o passo. Quando a rolagem não traz o elemento, a mensagem diz o porquê e o contorno.
**A2 · O mesmo no `uiautomator`** (`android.ps1` `Reach`, `ReachSideways`, `OnScreen`, `Get-ScreenWH`, `Tap`). Antes, o elemento na árvore com o centro fora da tela contava como alcançado, e o toque ia para fora. Agora "alcançado" é o centro dentro da tela (`wm size`); fora só na horizontal, rola a faixa na altura dele. O elemento na árvore que a rolagem não traz falha com "existe, mas a rolagem não o trouxe à tela" e o contorno, sem tocar.
**B · Cada cenário parte da tela inicial** (`accept.ps1` `Invoke-Once`). No Android, o cenário que chega ao primeiro passo de tela sem `launch`, `open` nem `restart` ganha um `launch` antes, como o web, que já abre página nova por cenário. "Voltar ao estado inicial" passa a ter sempre o mesmo sentido.
**C · Causa `executor`** (`lib.ps1` `Causes`, `CauseOrder`, `ConvertTo-Cause`, `CausePlain`; `gate.ps1`). A falha da ferramenta de prova do plugin deixa de ser `scenario`. Vai ao QA, que registra a ocorrência em `.team-project/note.md` (o `/review` leva ao plugin) e contorna no `.scn`.
**D · A escada do portão passa pelo PO** (`gate.ps1`; `lib.ps1` `Get-FindingEscalation`, `Get-FindingResolution`). Do dono da causa vai ao Arquiteto (degrau 1), depois ao **PO (degrau 2)** e só então ao stakeholder (R9). O PO aceita como dívida, manda fazer de outro jeito ou sobe só o que muda o produto, com `**Stakeholder:** <pergunta> — **Muda para o usuário:** <o que muda>` no `gate/<ID>.md`. Sem o que muda para o usuário, não há formulário. O Arquiteto e o dono não perguntam ao stakeholder: a decisão de produto vai em `**Para o PO:**`. O `Get-FindingResolution` passa a ler a última linha `**Resolution:**` (quem resolve depois acrescenta), e a pergunta do PO sem resposta faz a resolução anterior deixar de valer. Com a falha nova, o degrau 2 também recomeça.
**E · Contornos antes de "não há como"** (`gate.ps1`, prompts do QA e do Arquiteto). Em ordem: a captura; voltar a tela ao estado inicial (`restart`, `back`, outra aba e volta); reordenar ou dividir o cenário; `seed`. Quem disser que a linguagem não permite cita os verbos de `scenario-language.md` que conferiu.
**Regras e guias:** `scenario-language.md` (o `tap`, "na tela", cada cenário parte da tela inicial, falha do executor), `stakeholder-question.md` (o degrau 2 e a linha do passo de teste), R9 em `working-rules.md`, `sprint-run.md` (a escada do portão), `agents/quality-assurance.md`, `agents/product-owner.md`, `roles/quality-assurance/README.md` e `templates/sprint-validation.md` (a causa `executor`).
**Testes:** paridade (`parity.js`) com a tela que rola e a faixa de filtros no topo: PAR-25 (o último filtro com a faixa acima da tela) e PAR-26 (o primeiro filtro). Antes da correção, os dois e o PAR-08 davam "Position out of bounds"; depois, 26/26 em 4 rodadas seguidas (o lado web, sem Playwright nesta máquina, NÃO EXECUTADO). `run-check-tests.ps1`: o toque do `uiautomator` (rola a tela e depois a faixa, falha sem tocar, sem `wm size` vale a árvore); a escada (PO depois do Arquiteto, pergunta sem "Muda para o usuário" barrada, pergunta com ele vira formulário, respondida não volta, depois do PO o formulário, a falha nova zera o degrau 2); a causa `executor`.
## v3.65.12 — 2026-11-22
**Branch:** `fix/v3.65.12` a partir de `develop` (`3ba569a`, com a v3.65.11 mesclada pelo PR #215)
Origem: o sprint 6 do garden, em 22/11, das 08:18 às 08:35. O aceite do portão recusou o APK da Q-S6k como mais velho que o código, porque o `lista-insumos.component.html` tinha a data de 02:18. O conteúdo desse arquivo era o do commit `d713885` (21/11 00:14), anterior ao APK. O build estava certo: duas reconstruções deram os mesmos bytes, porque as fontes eram as mesmas. O operator devolveu "mesmo hash" sem repetir o aceite. Com o `result.json` igual, o portão pediu a mesma reconstrução de novo. Então a sessão pausou o run por conta própria, e o run-log registrou isso como "pedido do stakeholder". Ela levou ao stakeholder um relatório de cache, volume do Docker e SHA256 sem escolha. Mais tarde, descobriu sozinha que o app estava certo e ainda perguntou se seguia.
**A · A idade do APK pelo conteúdo** (`lib.ps1` `Get-ContentChangedSince`, `Get-ApkStaleness`). Das fontes com data posterior ao APK, contam só as que o git diz que mudaram depois dele: alterada na cópia de trabalho, não rastreada, ou num commit posterior. A fonte ignorada pelo git e o projeto sem git seguem pela data. No garden, o APK da Q-S6k passa, e o da Q-S6f (de antes do commit de 21/11) continua recusado.
**B · Fim do laço de reconstrução** (`gate.ps1`, `gate.json → staleApp.asked/arc`). O portão guarda o aceite cuja reconstrução já pediu. O mesmo aceite no `next` seguinte, ou uma nova recusa depois do pedido, vai ao **Arquiteto** (`/arc question`), e não ao operator de novo nem ao stakeholder. Ele acha a causa no caminho da fonte ao APK, conserta o ambiente do build, gera, instala e repete o aceite. O stakeholder só entra se o aceite continuar recusado depois dele, com uma escolha em palavras simples. O prompt do operator passa a mandar repetir o aceite mesmo com o hash igual, porque quem decide se o app é velho é o accept.
**B2 · O Arquiteto confere primeiro se a recusa procede** (`gate.ps1`; `lib.ps1` `Get-ApkAttest`; `accept.ps1`). O prompt traz o APK local e o hash dele. Antes de procurar defeito no build, o Arquiteto vê pelo git se o conteúdo que entra no app mudou depois do APK. Se não mudou, a recusa é alarme falso da conferência do plugin. Ele grava `.team-project/apk-attest.json` (hash, by, why, at), acrescenta o defeito do plugin a `.team-project/note.md` (o `/review` o leva ao plugin) e repete o aceite. O accept segue com o app atestado e o mostra como "conferido pelo Arquiteto" no `result.md`. A atestação vale só para aqueles bytes (build novo, conferência normal) e só com a prova (`why`). Nos dois casos, nada vai ao stakeholder.
**C · Pausa só do stakeholder** (`run.ps1 pause`). Sem `-Because` (o pedido dele), a pausa é recusada (exit 2) e o `.active-run` fica. A mensagem manda o problema técnico ao `run.ps1 next`. O run-log não grava mais "pedido do stakeholder" por padrão.
**D · Quem decide** (`stakeholder-question.md`). Ganhou a linha do build com o mesmo APK ("o app está certo, sigo?", "investigar a geração"): operator, depois Arquiteto, sem pausa nem pergunta.
**Testes** (`run-check-tests.ps1`): idade pelo conteúdo (só a data, conteúdo mudado, arquivo novo); as duas sequências do portão (o mesmo aceite e o aceite novo: operator → Arquiteto → stakeholder em texto simples); `pause` sem `-Because` recusado.

## v3.65.11 — 2026-11-22
**Branch:** `fix/v3.65.11` a partir de `develop` (`35caac7`, com a v3.65.10 mesclada pelo PR #213)
Origem: o sprint 6 do garden, de 21/11 21:13 a 22/11 02:21. O aceite do portão rodou com o app `apk:731dfab5b3fd`, de antes da correção da Q-S6h. As correções Q-S6i, j e k não mudaram a produção (`prod:f564a31bd676` nas quatro rodadas) e cada uma provou o SC-161 com o app novo (`apk:eb971aea13b1`). Mesmo assim, o QA julgou a mesma rodada das 21:13 três vezes (rodadas 13 a 15), e o script pediu uma quarta correção. A sessão discordou e perguntou ao stakeholder em texto, com hash, `exit 4` e nome de arquivo. Ele respondeu "não entendi nada". Nada daquilo era decisão dele.
**A · O portão mede de novo quando o app mudou** (`gate.ps1`). Com a mesma produção, uma correção fechada que passou um cenário que falhou no aceite do portão:
- com outro app, e a correção mais nova: a medição é velha, e o operator repete o aceite (`-Resume`), sem correção nova, sem QA e sem formulário;
- com outro app, e o portão mais novo: o aparelho não tem o app provado, e vale o caminho do app velho (v3.65.10: reconstruir e reinstalar, e o stakeholder só na 2ª vez);
- com o mesmo app (**B**): é contradição, não código. O Arquiteto decide a causa uma vez (`/arc question`, degrau 1), antes de uma rodada do QA sobre a mesma prova e antes de outra Q-S.
**C · O APK declarado, inferido do disco** (`lib.ps1` `Find-ApkCandidate`, `Get-ApkCandidateText`; `run.ps1`, `gate.ps1`, `team-update.md` passo 7q). Sem `targets.android.apk` e com uma pasta só de APKs fora de `node_modules`, o plugin dá a declaração: a máscara do nome e, no app híbrido, a pasta `src/` e o `capacitor.config`. Antes de medir o aceite, o portão manda a sessão gravá-la, sem formulário e dizendo como desfazer. O `next` faz o mesmo antes de construir uma Task com cenários, e o `/team update` também (7q). O formulário fica só para APKs em várias pastas. No garden, a inferência dá `"apk": "source/dist/garden-management-*.apk", "apkSources": ["source/src", "source/capacitor.config.ts"]`.
**D · Pergunta escrita barrada** (`hooks/stop.ps1`, G20). Durante o run, o fim de turno da sessão que o conduz fica barrado quando a última fala termina em pergunta ou pede a escolha, sem rota ao stakeholder nos últimos 15 min. A mensagem manda conferir "a decisão é dele?": discordar do `next`, reinstalar o app ou repetir o aceite vão ao Arquiteto ou ao operator.
**E · Linguagem do processo recusada no formulário** (`hooks/pre-tool.ps1`, G3). A G3 recusa, na pergunta e nas opções, código de versão, ID interno, nome de arquivo, comando, código de saída, nome de regra ou guarda e papel interno. O prefixo R34 fica de fora.
**F · O texto simples pronto** (`lib.ps1` `Add-AskRoutePlain`, `run.ps1` `Say`). A rota ao stakeholder leva a linha PARA O STAKEHOLDER (`.ask-route → plain`), e o `next` diz que o formulário parte dela.
**G · Prova velha na tabela do QA** (`roles/quality-assurance/README.md`, `sprint-validation.md`, prompts do portão). Antes de julgar, o QA confere se o app do aceite é o que a correção provou. Se não for, o achado é `environment` com "prova velha", e o portão mede de novo. Nas rodadas 14 e 15, o QA escreveu isso só no texto do veredito, que o script não lê, e manteve `code`.
**H · Revisão do processo de QA — rodadas que repetiam a mesma prova** (`gate.ps1`, `gate.json → noop`, `roles/quality-assurance/README.md`):
- **Correção que fechou sem mudar nada.** Se a árvore é a mesma da medição do portão e uma Q-S fechou depois dela, a falha pode não se reproduzir. O operator mede de novo uma vez por Q-S: com o mesmo app, o `-Resume` só repete o que falhou. A Q-S6i fechou assim, com a árvore `e20d96b` da medição das 21:13.
- **Correção que não mudou a produção nem os cenários.** Se a única novidade é essa Q-S fechada e a prova é a mesma da última rodada, o achado de cenário (que cita `SC-<n>`) vai ao Arquiteto uma vez (`/arc question`, chave `<ID>/semprova`), e não a uma rodada do QA que julgaria a mesma captura. É o caso da rodada 14, sobre a Q-S6j, que só acrescentou um teste de spec.
- **A rodada focada lê o resumo.** O portão grava `proof/S<n>/round-<k>/abertos.md`, com os achados abertos, as resoluções dos donos e o último veredito, e o QA lê esse arquivo, não o `validation.md` inteiro. No garden, cada uma das 15 rodadas abriu uma instância nova sobre as 324 linhas do arquivo.
**Documentos:** `stakeholder-question.md` (quatro linhas novas em "a decisão é dele?": aparelho e app são do operator, repetir o aceite é do roteiro, discordar do `next` é do Arquiteto, o APK declarado é do roteiro; e o ponto de partida do texto), `hooks/COVERAGE.md`, `team-update.md` 7q.
Casos em `run-check-tests.ps1` e `run-guard-tests.ps1` (marcados v3.65.11).

## v3.65.10 — 2026-11-21
**Branch:** `fix/v3.65.10` a partir de `develop` (`e5fedf7`)
Origem: relato do sprint 6 do garden sobre o SC-161 ("tag não encontrada: manejo-semeio.insumos.unidade"). O operator classificou como APP e abriu a Q-S6i. O Arquiteto achou outra causa: o app no aparelho era o APK da Q-S6f (`apk:731dfab5b3fd` em todas as rodadas de 6 a 12), e o id entrou no código depois dele (`9a2c2e2`). O `guards.json` não declara `targets.android.apk`. Sem APK local, o accept não instalava nem conferia nada e também não avisava. Assim, várias rodadas de correção rodaram sobre o app antigo, e a Q-S6h passou a ✅ sem a mudança no aparelho.
**A · App velho reconhecido sem depender de declaração** (`lib.ps1` `Get-InstalledAppStaleness`, `accept.ps1` `Test-AcceptFresh`).
- O accept olha as rodadas anteriores (`.team-project/accept/**/result.json`) e pega a mais antiga com a mesma identidade do app instalado (o hash do `base.apk`). Se o código do app mudou desde a árvore dessa rodada (`git diff-tree`), o accept recusa com exit 2 e grava `staleApp` no `result.json`, sem rodar cenários.
- Contam os arquivos de produção (sem teste e sem `quality.toolingPaths`). Com `apkSources` declarado, contam só eles. Com o APK em `<módulo>/build/outputs`, conta só o módulo.
- Um APK local mais novo que todas essas mudanças foi reconstruído e deu os mesmos bytes, então não é tratado como app velho.
**B · Aviso no lugar do silêncio** (`Get-ApkDeclarationNote`). Com `targets.android` e sem APK local, o aviso pede `targets.android.apk` e `apkSources`. Se a máscara de `apk` não casa nenhum arquivo, o aviso diz isso. Ele aparece no accept, no `verify full`, no `next` ao construir uma Task com cenários e no portão antes de medir o aceite.
**C · Elemento ausente só vira APP com o app conferido** (`result.json → fresh`, `Read-AcceptDiagnosis`, `run.ps1 done`, `operator.md` regra 9).
- O `result.json` e o `result.md` passam a levar o app instalado, o APK local (caminho, hash, data) e se o frescor foi conferido. Conferido quer dizer que o APK local foi comparado com as fontes e que é ele que está no aparelho.
- Um APP sem frescor conferido vale como PLANO, com o Arquiteto e o motivo "build não conferido". Isso vale no portão e no `done -Result gap|env`. O prompt do diagnóstico pede a linha `App: · build: · frescor:`.
**D · Cópia de sobra não conta como build novo** (`Get-ApkTwin`). O APK igual byte a byte a uma cópia mais velha na mesma pasta é tratado como sobra de um build anterior: a idade dele passa a ser a da cópia, e o accept e o `verify full` avisam.
**Portão** (`gate.ps1`, `gate.json → staleApp`). Com a rodada recusada, o operator reconstrói pelo build que o projeto declara, confere se o hash mudou, instala e repete o aceite. Se o mesmo app for recusado de novo depois desse pedido, o caso vai ao stakeholder.
Casos em `run-check-tests.ps1` (marcados v3.65.10).

## v3.65.9 — 2026-11-21
**Branch:** `fix/v3.65.9` a partir de `fix/v3.65.8` (`d9183d3`, ainda sem merge)
Origem: revisão das 8 interrupções do stakeholder no garden em 21/11. Só 2 eram decisões dele (atualizar o plugin; o zip com dados fora do git). As outras vinham de quatro lacunas do processo. A quinta (a medição viva) foi resolvida na v3.65.8.
**L1 · O contador do dono no portão** (`gate.ps1`, `gate.json`). Às 19:44, o S6-F10 e o S6-F15 foram ao stakeholder com `routed` 4, mas o QA tinha sido disparado de verdade duas vezes. Cada rodada tinha caído num ponto diferente (a abertura do app, depois um passo que faltava). O mesmo tinha acontecido às 03:54.
- O contador conta **disparos**: a mesma rodada do `validation.md` com a mesma resolução é o mesmo disparo, e o `next` repetido (pela G20, pelo `wait` ou pelo `/clear`) não soma (`gate.json → routedAt`). Vale também para a parte do `.scn` (`<ID>/scn`).
- Ele conta **repetição**, não progresso: a falha dos cenários citados no achado (status e detalhe do passo, no `result.json` do aceite) que mudou desde o disparo anterior zera a conta para 1 (`routedFail`).
- Esgotado o dono, vai ao **Arquiteto (degrau 1)**, uma vez por achado e com o histórico das resoluções e o diagnóstico (`escalated`). O formulário só abre se o achado voltar na mesma falha depois da decisão dele. Achado de desenho ou de requisito vai direto, como antes: o dono já é o degrau 1.
**L3 · O `quality.ps1` pelo `detach`** (`hooks/pre-tool.ps1`, `gate.ps1`). Às 19:18, a G14 negou ao operator o `detach.ps1` com o `quality.ps1` entre aspas escapadas por crase. Ele rodou o `quality.ps1` direto e a medição ficou órfã.
- A G14 entende o escape por crase dentro de aspas duplas.
- O comando de dentro do `detach` herda as variáveis do de fora e continua conferido trecho a trecho.
- O prompt do portão manda rodar o `quality.ps1` pelo `detach.ps1`, com exit 3 = chamar o mesmo comando de novo.
**L4 · Defeito do plugin não vira pergunta** (`stakeholder-question.md`, "a decisão é dele?"). Três casos novos: a medição que ainda roda (esperar é o padrão); a causa que é um padrão do próprio plugin, como o `readyExpr` das 08:50 às 17:30 (vai ao `note.md` e segue com o padrão novo); e o achado de cenário que voltou (QA, depois o Arquiteto).
**L5 · O update não pergunta sobre o que o plugin escreveu** (`team-update.md` 7p e §8, manifesto em `deliverables/team-project/README.md`).
- O trecho `readyState === 'complete'`, que o plugin sugeriu na v3.62.0, é trocado sem formulário, só ele, com aviso e o modo de desfazer.
- A §8 do README ("Como usar o time") é substituída sem formulário quando está igual à do modelo da versão instalada. Editada pelo time, é conflito.
- O manifesto ganha a classe "texto do plugin".

Testes:
- `run-check-tests.ps1`, 5 casos da L1: o `next` repetido conta um disparo; mesma falha → 2º disparo; 3ª vez → Arquiteto (o `next` repetido reimprime o Arquiteto); voltou depois dele → formulário; a falha mudou de passo → a conta volta a 1.
- `run-check-tests.ps1`: o caso do portão que mede passa a exigir o `detach` no prompt.
- `run-guard-tests.ps1`, 3 casos da G14: o comando do garden passa; `git push` escapado é negado; script fora do plugin escapado é negado.
- O caso `v3.53.2: OCUPADO com -WaitBusySeconds` falhava nas rodadas completas: a rodada viva durava 7 s e, com 8 blocos em paralelo, o `verify` subia depois dela. Ela passa a durar 20 s.

Suíte completa: 1147/1148 antes do ajuste (a falha era só esse caso); depois dele, o caso, os da v3.65.9 e a suíte de guardas inteira: 460/0.

## v3.65.8 — 2026-11-21
**Branch:** `fix/v3.65.8` a partir de `develop` (`fc33307`, PR #207)
Origem: portão do sprint 6 do garden, 19:18 → 19:32. O `quality.ps1` do portão rodava, e o `run.ps1 next` mandou o operator medir de novo, porque só olhava o `result.json`. A sonda `wait` respondeu "terminou" porque a espera não tinha Task, e a G20 barrou o fim do turno. Sem saída que a G20 aceitasse, a sessão perguntou ao stakeholder se esperava a medição terminar. Ela terminou sozinha. Estado de processo (rodando, terminou, travou) tem resposta do `next`, e o stakeholder só entra na segunda vez em que a medição trava.
**A trava da qualidade** (`quality.ps1`): uma medição por ID de cada vez, em `quality/<seg>/<ID>/quality.lock` (PID, hora de criação, início). A segunda chamada sai com exit 5 e a linha "em uso por", que o prompt do operator já manda devolver sem repetir. `-Kill` encerra a medição viva e a árvore dela e apaga a trava. A trava sai em toda saída do script.
**O portão espera a medição viva** (`gate.ps1`): antes de mandar medir, o portão lê o `Get-TaskWait` do `S<n>`: `verify.lock`, `quality.lock` e o `.target-lock` do accept. Medição viva e andando → `PRÓXIMA AÇÃO: esperar`, com a linha do watcher e a decisão `esperar` gravada, que a G20 aceita. POSSÍVEL TRAVAMENTO na 1ª vez → encerrar só a medição (`-Kill`) e rodar o `next`, sem formulário (regra 5; contador em `gate.json → stall`). Na 2ª vez → formulário, pela rota `travamento`.
**A sonda enxerga o portão** (`lib.ps1` `Get-TaskWait`, `run.ps1 wait`): com a espera gravada no `S<n>`, o `wait` acha a trava da qualidade e responde `vivo` ou `POSSÍVEL TRAVAMENTO`. Sem espera e com ação `agir` pendente, a linha diz "o último next mandou agir, não esperar", em vez de só "terminou".
Textos: `sprint-run.md` §Protocolo de espera ("Estado de processo não vai ao stakeholder") e `hooks/COVERAGE.md` (§v3.65.8).
Testes (`run-check-tests.ps1`, marcados v3.65.8): 7 casos da medição:
- qualidade viva: esperar, a sonda diz vivo e não há operator nem formulário;
- segunda chamada do `quality.ps1`: exit 5, e a trava fica;
- 1º travamento: encerrar e retomar, sem formulário;
- 2º travamento: formulário, pela rota `travamento`;
- `-Kill`: encerra a medição e apaga a trava;
- sem medição viva: o portão volta a medir;
- a medição que termina solta a própria trava.

Mais 3 casos de contrato: verify, accept e quality do sprint em voo, cada um → esperar, sem operator por cima e sem formulário.

## v3.65.7 — 2026-11-21
**Branch:** `fix/v3.65.7` a partir de `fix/v3.65.6` (`2aec342`, mesclada em `develop` pelo PR #205)
Origem: portão do sprint 6 do garden. Às 7:56, o `run.ps1 next` mandou o operator medir de novo o aceite com `-Resume`. A sessão escreveu o aviso ao stakeholder ("Revisão final: medindo de novo…") e encerrou o turno sem disparar o agente. O time ficou parado até 8:34, quando o stakeholder perguntou "como estamos". A G20 existe para barrar esse fim de turno, mas só olhava a fila de Tasks. No portão, todas estavam ✅: sem Task elegível, ela liberava calada, sem linha no `guards.log`.
**A ação pendente do `next`** (`run.ps1`, `Get-AgentLine`): o `next` que imprime a linha `Agent:` grava `.team-project/.next-verdict` com a ação `agir` e o motivo `disparar team:<papel> — <PRÓXIMA AÇÃO>`. O ponto é único e cobre todos os disparos do `next`: fila, portão, consolidação e Review. Uma decisão "esperar" ou "reiniciar" gravada depois, no mesmo `next`, a substitui. O `next` seguinte apaga a decisão no começo, como antes.
**A G20 lê a ação** (`hooks/stop.ps1`): com `agir` e nenhum agente desta sessão em voo, ela barra o fim do turno, com ou sem Task elegível. A mensagem traz a ação: dispare o agente que o `next` imprimiu ou, se ele já voltou, rode o `next`. A rota ao stakeholder (`.ask-route`) gravada no mesmo instante da ação ou depois dela libera. O alívio de 3 bloqueios em 10 min continua valendo. A liberação por "nenhuma Task elegível" passa a deixar linha no `guards.log`.
Textos: `sprint-run.md` §Disparo ("escrever o aviso não é disparar") e `hooks/COVERAGE.md` (G20, §v3.65.7).
Testes: 6 casos da G20:
- sem Task elegível e sem ação pendente: libera, com a linha no log;
- ação pendente do portão sem agente: barra, com a ação;
- com o agente em voo: libera;
- com o agente de volta: barra até o `next`;
- com a rota ao stakeholder mais nova que a ação: libera;
- com a rota ao stakeholder mais velha que a ação: barra.

Mais 1 caso do `next`: a medição do portão grava `agir` com o operator e a `PRÓXIMA AÇÃO`.

---

## v3.65.6 — 2026-11-21
**Branch:** `fix/v3.65.6` a partir de `develop` (`3273e6a`, v3.65.5 mesclada)
Origem: portão do sprint 6 do garden. Três cenários do aparelho (SC-161 e mais dois) pararam na abertura com "o app não ficou pronto em 30 s", e as capturas mostravam a tela pronta. As rodadas 10 e 11 terminaram sem diagnóstico, e a primeira pergunta ao stakeholder recomendou dar mais tempo. Medido no emulador, numa sonda pelo DevTools da WebView: a abertura normal falhou 6 de 6 vezes, com `readyState: interactive`, as fontes em `loading`, o `ion-app` hidratado e o splash fora. Com as fontes do Google bloqueadas, ficou pronta 3 de 3 vezes em 2,5 a 3 s. O pedido a `fonts.gstatic.com` ficava pendente, sem terminar nem dar erro, e o `readyState` nunca chegava a `complete`.
**A prontidão padrão é o DOM lido** (`cdp-verbs.js`, `android.ps1`): o padrão do `readyExpr` passa de `document.readyState === 'complete'` a `document.readyState !== 'loading'`. O `complete` só é verdadeiro quando todo recurso da página terminou, e isso inclui fonte, imagem e endereço de fora. Era uma condição de rede, e não do app. Quem diz que o app está pronto é o sinal dele, no `readyExpr` do projeto. O exemplo do guia do Ionic, que o garden copiou, e o modelo do `guards.json` saem do `complete`.
**O retrato da página quando a prontidão estoura** (`cdp-verbs.js`, `readyDiag` e `splitAnd`): a falha traz:
- a parte do `readyExpr` que ficou falsa, das partes ligadas por `&&` no nível de fora;
- o `readyState`;
- o estado das fontes e as famílias que ainda carregam;
- os endereços de outra origem que não terminaram (o `src` das `@font-face` que carregam, imagem incompleta, folha de estilo sem regra).

Antes, a mensagem só trazia a expressão inteira e a URL.
**`/team update` propõe a troca** (`team-update.md`, passo 7p): o projeto com `readyState === 'complete'` no `readyExpr` recebe a proposta por formulário, e nada é gravado sem aprovação. Projeto sem `readyExpr` declarado ganha o padrão novo sozinho.
Fica para o garden, decisão do Arquiteto do projeto: o `index.html` carrega as fontes do Google, e a regra do projeto é funcionar offline.
Fica para depois: o executor `web` (`web-runner.js`) abre a página com `waitUntil: 'networkidle'`, e um pedido de fora que não termina o seguraria do mesmo jeito.
Textos: `scenario-language.md` §3 (a prontidão é sinal do app, não da rede, e o retrato da falha), guia do Ionic/Capacitor (IONIC-3), `guards.json` modelo.
Testes: `parity.js --ready`, sobre a página `fixtures/parity/pendente.html`, com uma fonte de outra origem que o teste segura pelo `Fetch` e nunca entrega. O padrão passa; o `complete` estoura e a mensagem aponta só a parte do `readyState`, as fontes `loading` e o host. Também as partes por `&&` respeitando parênteses, colchetes e textos. O CD5 passa a esperar o padrão novo.

---

## v3.65.5 — 2026-11-21
**Branch:** `fix/v3.65.5` a partir de `develop` (`55970c1`, v3.65.4 mesclada)
Origem: portão do sprint 6 do garden. Três rodadas focadas (8, 9 e 10) julgaram os mesmos três achados (S6-F7, S6-F10, S6-F15) sem que nenhum `.scn` mudasse, e a sessão só parou na terceira, para perguntar ao stakeholder. Os ajustes dos cenários estavam descritos nas resoluções e no `validation.md`, mas nenhuma rota do portão os mandava aplicar.
**A resolução vale até a rodada seguinte** (`gate.ps1`): o achado que segue `open` num `validation.md` mais novo que o `gate/<ID>.md` volta ao dono. A resolução anterior vai no prompt ("não se sustentou… corrija de outro jeito"), e o disparo conta para o limite de 2, que leva ao stakeholder. Antes, o `done` do S6-F7 (o `open` da rota repetido com `wait 3`), desmentido pela rodada 9, segurava o achado para sempre.
**A metade do teste depois da `Q-S`** (`gate.ps1`; `lib.ps1`, `Get-FindingScenarioPart`): a resolução `code` que também muda o `.scn` passa a ter a linha `**Scenario:** <SC e o que muda>`. Sem ela, conta o texto que manda o QA mexer num `SC-<n>` ou num `.scn`, como no S6-F10 ("o QA troca nos SC-264 e SC-265…") e no S6-F15 ("depois o QA acrescenta ao SC-161…"). Com as `Q-S` que cobrem o achado fechadas, o QA aplica essa parte antes da rodada nova e grava `**Scenario applied:**`. Enquanto ela falta, a resolução não conta como desmentida: a rodada testou só a metade da correção.
**Sem mudança, sem rodada** (`gate.ps1`): "Q-S fechada" só pede rodada focada uma vez. O `gate.json` guarda em `judged.qs` as `Q-S` que cada rodada já julgou; sem a lista (o `gate.json` de antes desta versão), vale o `delivery/<Q-S>.md` mais velho que o `validation.md`. Antes, toda `Q-S` ✅ que cobria um achado aberto contava como novidade em toda chamada do `next`, e foi isso que abriu as rodadas 9 e 10. O achado `code` que segue aberto depois da rodada que já julgou a `Q-S` vai a uma correção nova.
Medido no garden (só leitura): o S6-F7 volta ao QA com a resolução desmentida; o S6-F10 (`Q-S6f`) e o S6-F15 (`Q-S6h`) vão à rota da metade do teste.
Textos: `sprint-validation.md` (resolução do dono) e `sprint-run.md` (passos 5 e 6 do portão).
Testes: 7 casos. Cobrem o `done` desmentido que volta ao QA, a metade do `.scn` pendente que vai ao QA antes da rodada, o `code` puro com a `Q-S` já julgada que pede correção nova, o `code` com o `.scn` aplicado e desmentido que volta ao Arquiteto, a `Q-S` fora e dentro de `judged.qs`, e o `gate.json` sem `judged.qs` com o `delivery` antigo.

---

## v3.65.4 — 2026-11-20
**Branch:** `fix/v3.65.4` a partir de `develop` (`fb9aa45`, v3.65.3 mesclada)
Origem: a brecha que a v3.65.3 deixou na regra 34. Ela confere a própria linha `**Aceite:**`. Um plano **sem** a linha, com cenários, que cita uma decisão do sprint mandando provar por script do projeto ficava calado, e o `close.ps1` exigiria o `accept.ps1` padrão. A Q-S6g do garden só não caiu aqui porque tinha a linha.
**A decisão do sprint que muda o aceite precisa da linha no plano** (`plan.ps1`, regra 34; `lib.ps1`, `Get-AcceptDecisionHits`): o plano sem `**Aceite:**`, com cenários e sem frase de dispensa no próprio texto, agora é conferido contra as decisões do sprint que chegam a ele. Chegam as citadas em **Decisões:** e as que têm a Task no **Vale para**; um "todas" sozinho não basta, porque é regra condicional. A decisão conta quando prova os cenários por um script que não é do plugin, com frase de prova no título ou no corpo ("se provam pelo", "provado pelo", "prova pelo", "prova cruzada", "executor do projeto"), ou quando dispensa o aceite. Nesse caso o plano reprova e aponta as três formas da linha. Medido no garden: nas decisões dos sprints 5 e 6, o critério pega a D-5 e a D-24 do S5 e a D-31 do S6, todas de prova por script do projeto, e nenhuma decisão que só cita o `capturar.mjs`, o `karma.conf.js` ou um script do plugin. Nos 46 planos sem a linha e com cenários, reprova só a T-042 do sprint 5, que cita a D-5 e a D-24 e é o mesmo caso da Q-S6g, um sprint antes.
Textos: `implementation-plan.md` (regra 34) e `technical-decision.md`.
Testes: 3 casos da regra 34 (decisão citada de prova por script e decisão com a Task no Vale para que dispensa o aceite: reprova; com `**Aceite:** comando`: ok; decisão "todas" não citada e decisão que só cita o `accept.ps1`: n-a).

---

## v3.65.3 — 2026-11-20
**Branch:** `fix/v3.65.3` a partir de `develop` (`c79d91c`, v3.65.2 mesclada)
Origem: SC-161, SC-122 e SC-147 do aceite do sprint 6 do garden. As três falhas foram dadas como defeito do app ("sem campo editável" e "a rolagem não o trouxe à tela"), com o elemento visível na captura. O portão travou a Task porque a decisão de provar por outro caminho não estava no plano.
**Ancestral pela árvore composta** (`dom-probe.js`, `up`): o executor subia pelo pai de luz. Num conteúdo projetado por `<slot>`, ele pulava o rolador e os recortes que ficam no shadow root do host (no Ionic, `ion-content` → `slot` → `.inner-scroll`). Com isso, o plano de rolagem escolhia o documento, que não rola, e media a posição dele: o gesto rolava a tela, a posição medida não mudava, e o executor desistia com a tela já rolada. Agora o pai é o `assignedSlot`, depois o pai, depois o host. Medido no aparelho do garden, a tela Novo Manejo: `upChain` ia de `form` direto a `ion-content`, e a cadeia composta passa por `slot > div.inner-scroll`.
**Filhos pelo acessor nativo** (`dom-probe.js`, `kidsOf`): o Stencil "scoped" (o `ion-input` do Ionic) troca `children` e `childNodes` no protótipo do componente para devolver só o conteúdo projetado. O `<input>` desenhado pelo componente sumia da leitura: `children` dava 0, e o acessor de `Element.prototype` dava 1. A busca do editável, a caixa por filhos, a leitura do valor e o `find-text` passam a usar o acessor de `Element.prototype`.
**Prova no aparelho** (emulador do garden, com o `cdp-verbs.js` desta entrega): o `type manejo-semeio.insumos.qtde = 2` com o campo fora da tela rola, digita e confere (SC-161 até a linha do insumo com "2"), o `tap semeio.registrar-manejo` passa (SC-122) e o `type semeio.obs` passa (SC-147). Com o executor antigo, o mesmo `type` dava "a rolagem não o trouxe à tela".
**O toque espera a rolagem parar e confere o clique** (`cdp-verbs.js`, `dom-probe.js`; garden SC-204, S6-F5): reproduzido no aparelho com uma sonda de eventos. Um toque em DESCANSANDO teve `pointerdown` e `touchend` no alvo, sem cancelamento, e nenhum `click`. A faixa ainda rolava: o último `scroll` veio 27 ms depois do `touchend`. O passo dava ok pelo `pointerdown`, e o `assert` seguinte falhava. A caixa do alvo para antes da rolagem quando o rolador bate na borda, e por isso a espera da v3.65.1 (caixa igual em duas leituras) não bastava. Agora o toque espera 250 ms sem nenhum evento de `scroll` (até 2 s) e confere o `click`. Toque que chegou, terminou sem o app cancelar e não virou clique, com o elemento ainda na página, é repetido uma vez; o segundo sem clique é FALHOU com o motivo. O app que cancela o clique (`preventDefault` no fim do toque) e o elemento que sai da página no toque contam como antes, sem repetir: assim não se repete uma ação que o app já fez. Prova no aparelho: o SC-204 inteiro três vezes, com as três fontes, deu 45 toques com clique e os asserts certos.
**`font-scale` espera a página nova** (`android.ps1`, `Set-AndroidFontScale`): no app que não trata a troca de fonte, o Android recria a tela e a WebView carrega outra página. Medido no garden: a página velha ainda respondia o `readyExpr` como pronta por 1,1 a 1,3 s depois do comando, e o passo esperava 0,8 s. O `ready` do accept podia passar na página velha, e o toque seguinte caía no splash ("coberto por div#boot-splash"). O SC-243 se defendia com `wait 3`; o SC-204 não tinha esse `wait`. Agora, com o valor mudado e o DevTools ligado, o passo espera até 3 s a lista de páginas do `/json` mudar. Valor igual ao atual, ou sem DevTools (`uiautomator`), segue como antes. O valor vai com ponto decimal em qualquer cultura.
**O aceite por outro executor não passa como `roda`** (`plan.ps1`, regra 34; garden Q-S6g): a Task travou no portão porque a D-31 mandou provar o SC-122, o SC-147 e o SC-161 pelo `prova-cdp.mjs` e o plano escreveu `**Aceite:** roda — … pelo executor do projeto (\`prova-cdp.mjs …\`)`. O `close.ps1` leu "roda" e exigiu o resultado do `accept.ps1` padrão. Agora o `roda` que cita script do projeto reprova como o `não roda` já reprovava, e aponta `**Aceite:** comando — \`<cmd com {scn} e {out}>\``. A linha fora das três formas (`roda`, `não roda`, `comando`) também reprova, com as formas. Medido nos 36 planos do garden com a linha: a regra nova pega só a Q-S6g (`prova-cdp.mjs`) e a T-069a ("pendente para o QA (D-4)"), as duas que o portão não sabia ler. O modelo de decisão técnica passa a dizer que a decisão que muda como o aceite se prova só vale na linha `**Aceite:**` de cada plano.
Fica para o QA do garden: no SC-122, o `assert-contains manejo-semeio.semeios = semeado em` lê o `value` do `ion-select` (o id do lote), como a norma manda para web component com `value`. O texto "semeado em" só aparece no rótulo exibido.
Textos: `scenario-language.md` (§1: ancestral pela árvore composta e filhos pelo acessor nativo; §2: o `tap` espera a rolagem parar e confere o clique; `font-scale` espera a página nova), `implementation-plan.md` e `external-plan.md` (regra 34), `technical-decision.md` (a decisão de aceite vai na linha `**Aceite:**`).
Testes: paridade PAR-21 (rolador no shadow root com conteúdo por slot e campo de slot emulado), PAR-22 (faixa de pílulas ida e volta), PAR-23 (toque que chega e não vira clique: repete uma vez) e PAR-24 (o app cancela o clique no fim do toque: não repete). Com o executor da v3.65.2, o PAR-21 falha com "coberto" e o PAR-23 com "esperado 'engole 1', obtido '—'", a mesma forma da falha do garden. O PAR-22 passa nas duas versões: no desktop o clique não é descartado, e fica como guarda. Com este executor, cdp 24/24. Mais 4 casos do `font-scale` (valor novo que muda a página, valor novo sem página nova, valor igual, sem DevTools) e 3 da regra 34 (`roda` com script do projeto, `roda` com o `accept.ps1`, linha fora das formas).

---

## v3.65.2 — 2026-11-20

**Branch:** `fix/v3.65.2` a partir de `develop` (`80621a9`, v3.65.1 mesclada)

Origem: o tempo do aceite no portão do sprint 6 do garden. A rodada 5 levou 80 min (49 cenários e 25 repetições) e a das 06:22 levou 50 min (23 cenários e 13 repetições). Cada execução de cenário levou de 65 a 85 s.

**A segunda tentativa só para a falha que pode ser oscilação** (`accept.ps1`): nas duas rodadas, 38 repetições salvaram 3, todas de toque não reconhecido (corrigido na v3.65.1). As 22 de id ausente, rolagem que não traz o elemento e valor diferente não salvaram nenhuma: cerca de 25 a 30 min. Essas falhas não se repetem mais, e a linha sai com "não repetido: <classe>". Toque, conexão e toda falha com sinal do app continuam repetindo. A regra vale para o executor interno e para o executor do projeto (`{only}`).

**Asserts que releem** (`cdp-verbs.js`, `android.ps1`): `assert-text`, `assert-contains`, `assert-absent`, `assert-checked`, `assert-count` e `assert-order` releem até o valor bater, por até 5 s, e a falha traz a última leitura. O cenário não precisa mais de `wait` fixo depois do toque (289 s deles nos 23 cenários da segunda rodada). A norma passa a dizer que `wait` é para o tempo do próprio app.

**Tempo no resultado** (`accept.ps1`, `web-runner.js`): cada linha traz `seconds` e `stepMs`. O `timing` da rodada traz o total, as execuções e cada verbo (vezes, soma e média, do mais caro ao mais barato). O `result.md` mostra o resumo e os segundos de cada cenário. Com esse dado, dá para medir no aparelho o custo de um processo do Node por passo antes de mudar o executor.

**S6-F4 (SC-123) é do executor e já estava corrigido na v3.65.1**: marcar "Todos" redesenha a lista e troca o nó tocado por outro com o mesmo id. O `armed` antigo achava o nó novo e dava "não chegou a ele (pointerdown em slot)", de forma intermitente. O PAR-20 reproduz a mensagem com o `dom-probe` da v3.65.0 e passa com o atual.

Textos: `scenario-language.md` (o `tap` da v3.65.1, os asserts que releem, a regra do `wait`, a segunda tentativa e o tempo).

Testes: paridade PAR-18 (a tela muda depois do toque, o assert espera), PAR-19 (o assert desiste no prazo) e PAR-20 (o toque redesenha a lista): cdp 20/20. Mais 3 casos do `accept.ps1`: a regra com as mensagens reais do garden, a repetição seletiva no laço e o tempo no resultado.

---

## v3.65.1 — 2026-11-20

**Branch:** `fix/v3.65.1` a partir de `develop` (`5c3965f`, v3.65.0 mesclada)

Origem: ocorrências de plugin do portão do sprint 6 do garden (`architect/decisions/S6.md`: D-19, D-20, D-29, D-30).

**O toque que fecha o alerta conta** (`dom-probe.js`, `cdp-verbs.js`; S6-F2, S6-F3, D-30): o `armed` procurava o elemento de novo 250 ms depois do toque. Quando o toque fecha o alerta ou troca a página, ele já saiu da tela e o passo FALHAVA com "não chegou a ele", com o toque certo (SC-128 gravou os 33 semeios). Agora o `arm` guarda o elemento e o ouvinte guarda o caminho do pointerdown no próprio evento, e o `armed` confere por eles.

**O toque espera o alvo parar** (`cdp-verbs.js`; S6-F5, D-30): o `tap` media a caixa assim que o elemento entrava na janela. Com rolagem que ainda desliza (inércia) ou tela entrando com animação, o toque parava o deslize sem virar clique, ou caía no vizinho. Agora espera a caixa ficar igual em duas leituras seguidas (até 2 s) e rola de novo se a espera o tirou da janela.

**Q9 conta o marcador, não a palavra** (`quality.ps1`; S6-F11, D-19): `\b(TODO|FIXME)\b` casava "cobre TODO o app" e "ANO TODO". Agora conta `TODO`/`FIXME` logo depois da abertura do comentário (`//`, `/*`, `#`, `*`, `<!--`, `--`) ou seguido de `:`, `(` ou `[`. `quality.todoPattern` troca a regra.

**Q11 lê cada módulo** (`quality.ps1`; S6-F12, D-20): com o `coveragePattern` do projeto, toda ocorrência conta e vale a menor, e a linha diz qual ("o menor de 4 ('módulo raiz: 85.00%')"). O padrão do plugin segue lendo só a primeira. O D-20 não precisa mais do padrão com `\A` e lookahead: basta `m.dulo\s+\S+:\s+(\d+(?:\.\d+)?)%`.

Textos: `guards.json` modelo (`todoPattern` e as duas chaves em `_exemplos`), `team-update.md` 7k.

Testes: paridade com PAR-16 (botão que fecha o próprio alerta) e PAR-17 (alvo ainda deslizando), os dois FALHOU no executor anterior; 4 casos novos do `quality.ps1`.

**Fica com o projeto** (S6-F12): gravar o `coveragePattern` e dar ferramenta a Q1, Q6, Q8 e à formatação do Q7.

---

## v3.65.0 — 2026-11-19

**Branch:** `feat/v3.65.0` a partir de `develop` (`4d6d7d4`, v3.64.5 mesclada) · **Processo:** v3.65 (`process-changelog.md`) · **Plano:** `melhorias/plano-v3.65.0.md` (decisões Q1–Q4 do stakeholder, 19/11)

Origem: revisão geral do plugin pedida pelo stakeholder em 19/11 (`/review audit` em quatro frentes — regras e guardas × código e teste, decisões v3.60–v3.64.5, regras que se encadeiam, excesso — mais o C3). 80 achados; o stakeholder escolheu corrigir todos nesta entrega, antes do benchmark da virada. Causa comum: a mesma regra morava em 4 a 5 lugares e cada correção atingia só os que o incidente tocou. Regra da entrega: cada regra tocada fica com uma fonte única, e o texto que o agente lê primeiro (contrato em `agents/*`, mensagem de reprovação) muda junto com o prompt.

**A métrica do benchmark** (`run.ps1`, `gate.ps1`, `lib.ps1`, `knowledge.ps1`): a decisão do stakeholder ou da Q-S que emenda o plano ia para `**Plano corrigido durante a execução:**` — o campo da métrica "precisão do plano", só para erro do próprio plano. Agora vai no bloco `**Decisão do stakeholder (<data> · replan|portão):**`, com **Origem** e **Lição** como a decisão de GAP: fora do teto de 30 KB, conferido pela regra 29 do `plan.ps1` e colhido como lição.

**Plano emendado acima de 30 KB — uma regra, com a precedência** (`plan.ps1`, `run.ps1`, `agents/architect.md`, `sprint-run.md`, `roles/architect/*`): antes da construção, não se corta e o `next` divide a Task; com a construção começada, a Task não se divide e o Arquiteto substitui o texto que a decisão derrubou. O contrato do Arquiteto e a mensagem do `plan.ps1` mandavam o contrário do prompt do `next` (a causa do laço da v3.64.2–v3.64.4). A reprovação do plano emendado não some mais do prompt depois da primeira vez.

**ESPERANDO com accept ou reparo vivo** (`run.ps1 done`, `agents/task-runner.md`, `sprint-run.md`): sobrava a regra da v3.53.3, revogada na v3.62.2 ("encerre o turno; o aviso te acorda"). O executor devolve `<ID> ⏸ esperando: <comando>` e a sessão segue o protocolo de espera.

**Redes que o texto prometia:**
- **C1 × arquivos mudados (decisão Q1):** linha `R4-arquivos` no `close.ps1` — arquivo alterado fora de `**Arquivos tocados:**`, sem margem declarada, alheio, `treeIgnore` ou desvio aceito, reprova o R4 com o caminho. Como o R4, não trava o close: o QA decide no portão.
- **Falha aberta com rastro:** `stop.ps1`, `session-start.ps1`, `prompt-submit.ps1` e `notification.ps1` gravam a linha `erro` no `guards.log`, como os outros três despachantes.
- **G14 com `runCommands` vazio** nega com a rota `Start-Sleep`, `Wait-Process`, `adb` direto, `robocopy`/`xcopy` (antes caía no pedido de permissão do harness).
- **C3 na suíte:** a rodada completa do `run-all-tests.ps1` roda o `release.ps1`; da v3.64.0 à v3.64.5 seis entregas saíram com o C3 vermelho (README na v3.63.2).

**D8 (adb):** o adb atual sobe o servidor como `adb -L tcp:<porta> fork-server server`; só o `-P` era lido e todo servidor contava como 5037 — dois servidores (5037 e 5038) passavam como um e a D8 não recusava. `Get-AdbServerPortFromCommandLine` lê as duas formas. A mensagem deixa de dizer "a porta padrão, 5037" (o plugin não fixa a porta do servidor) e o comentário de `Test-AndroidSerialPort` diz o que o código faz sem `serial`.

**Textos × código e donos:** `COVERAGE.md` em dia com as guardas (G4, G7, G9, G14, G19, G20, G21, G24, G3; 7 despachantes; sai a G12 nunca aplicada); `how-to.md`; G25 na linha de guardas do SessionStart; R4, R5, R14, R15, R28, R29 e a fronteira prazo SM × PO; `stakeholder-question.md` com `-Reopen`; donos de `gate/`, `proof/`, `lessons.md`, `breakdown/`, marcadores do run e `scripts/**` na matriz e no `ownership.json`; contagem R1–R35.

**Excesso:** `working-rules.md` 115 → 100 KB (sem o "Resumo em uma tela"; "Evita:", racionais e notas de versão no changelog; R17–R19 em `rituals/review-contract.md`); `sprint-run.md` 72 → 65 KB (história e versões fora; regra de sessão e lista "quem decide" com fonte única); `rituals/team-update.md` 41 → 20 KB (decisão Q2: migrações v3.20–v3.49 saem, versão mínima suportada v3.50 — abaixo dela, `/team init` de novo); `roles/architect/plan-rules-why.md` removido (25 KB, só história, links quebrados); linhas genéricas de R22 e de consumo fora dos comandos; siglas de plano fora dos agentes; o ramo morto do "toque de cache" fora do `stop.ps1`.

**Fora desta entrega** (`note.md` 27–30): critério de "emendado" pelo conteúdo, tabela de precedência do portão, a G14 por padrão de texto, e o empacotamento sem o histórico (decisão Q4: entrega própria — exige o plugin em `./plugin`).

**Testes:** casos `v3.65.0` em `run-check-tests.ps1` (D8 sem serial, leitura da porta do adb, `R4-arquivos`, lacunas de cobertura da auditoria) e a expectativa da linha de guardas do SessionStart (G25) em `run-guard-tests.ps1`. Dois casos antigos do `plan.ps1` mudaram de expectativa (a mensagem do tamanho diz os dois casos; as decisões fora da conta incluem as do stakeholder). O rodapé do `plan.ps1` ("Plano não vai ao dev") também dizia só o caso "antes da construção" — corrigido junto.

**Suítes** (`run-all-tests.ps1`, 8 processos, com o C3): 1.098 casos, 5 falharam na 1ª rodada — 3 de expectativa desta entrega (corrigidas) e 2 de tempo sob carga (`v3.53.2` OCUPADO e `item 5` perto do teto), que passam com a máquina sem a carga; os blocos dos 5 de novo: 47 casos, 0 falharam.

---

## v3.64.5 — 2026-11-19

**Branch:** `fix/v3.64.5` a partir de `develop` (`963e2ab`, v3.64.4 mesclada)

Origem: projeto piloto, 19/11. Os 13 cenários do `accept` com `locator: "cdp"` caíram em "a página do app não está no /json do DevTools", com o app aberto no emulador. O `pageUrl` do projeto era `^https://localhost/$`, escolhido na tela inicial. Ao abrir uma aba, o app troca a rota (`/tabs/...`), e nenhuma página casava mais. A mensagem dizia "o app fechou", e a causa ficou como hipótese.

**A página se identifica pela origem; a tela, pelo id da raiz** (`android-cdp.js`):
- **Escolha da página:** o `pageUrl` casa a URL inteira e, sem nenhuma assim, a URL sem a rota: origem + `/` em `http(s)`; sem `?` e `#` em `file://` (Cordova; a origem de `file://` é `"null"`). O `pageUrl` escrito na tela inicial continua achando o app em outra tela, sem mudar o `guards.json`.
- **Nenhuma página que case:** com página carregada na WebView e nenhuma casando o `pageUrl`, sai CONFIGURAÇÃO DO ALVO com as URLs vistas no `/json`. A prova vem na mensagem. Sem página nenhuma, continua "o app fechou ou não carregou a WebView".
- **Por que no plugin:** todo app de página única em WebView (Ionic, Angular, React, Vue; Capacitor ou Cordova) muda a URL ao navegar. A rota é o estado da tela, e quem diz a tela é o id da raiz (`test-ids.md` §3), o mesmo que a arquitetura, o plano, o código e o QA citam pelo `ids-map.md`.

**Textos:** `test-ids.md` §6 (a regra e o novo caso de CONFIGURAÇÃO), o `guards.json` modelo, o guia `ionic-capacitor` (`pageUrl: "^https://localhost(/|$)"`), o `team-init.md` (o `pageUrl` vem do guia, sem perguntar por uma tela), `scenario-language.md`, `stakeholder-question.md` e `sprint-run.md`.

**Testes:** 2 casos novos em `run-check-tests.ps1` (Capacitor `https` e `http`, rota por `#`, Cordova `file://`, precedência da URL inteira, CONFIGURAÇÃO com as URLs vistas, sem página).
## v3.64.4 — 2026-11-19

**Branch:** `fix/v3.64.4` a partir de `develop` (`2a3c1ca`, v3.64.3 mesclada)

Origem: sprint 6 do projeto piloto, 19/11, 11:14. A Q-S6e foi a 🟨 com o plano emendado (decisão 147: render spec, espera do Karma, emulador desligado). O disparo do executor dizia "se o dev voltou com a entrega, comece por `run.ps1 done`", e havia relatório no `delivery/`, só que de antes da emenda. O executor começou pelo `done`, que leu a prova antiga: a suíte reprovada como "ambiente" e o accept como "não rodado". Pela regra D3 da v3.64.0, mandou o operator rodar o `verify full`. Às 11:16, o operator media o código que a emenda mandava mudar, com o render spec e o `karma.conf.js` intactos no disco.

**Depois da emenda, o dev vem primeiro** (`run.ps1`):
- **`next`:** ao levar a Task replanejada a 🟨, deixa `handoff/<ID>-replanned.md`, com a decisão e a hora da emenda.
- **Disparo do executor:** com essa marca mais nova que o `delivery/<ID>.md`, manda começar pelo `run.ps1 start` (dev em instância nova pelo cartão), e não pelo `done`.
- **`done`:** com a marca mais nova que o último relatório, recusa fechar ou medir, sem operator. Manda `run.ps1 start` e registra no run-log. O relatório novo do dev libera o `done` e apaga a marca.

**O tamanho do plano emendado segue a regra do `start`** (`run.ps1 next`, corrige a v3.64.3):
- **Antes:** a v3.64.3 deixava o plano emendado só acima do teto "seguir como a Task em construção". O `run.ps1 start` recusa esse plano com a construção começada (v3.54.1), e no piloto o resultado foi um aviso de "segue" seguido da recusa.
- **Agora:** a reprovação por tamanho vai ao Arquiteto com o prompt de substituição da v3.54.1: trocar o texto que a decisão derrubou pela decisão, sem acrescentar ao lado e sem cortar o que vale. Foi esse prompt que destravou o piloto (31.840 → 30.928 bytes, `plan.ps1` ok).
- **Por que o laço da v3.64.2:** o prompt genérico ("corrija até passar") fazia o Arquiteto ler "cortar", e ele recusava.
- **Reprovação repetida:** continua saindo para o degrau 1, como na v3.64.3.

**Textos:** `agents/task-runner.md` e `sprint-run.md`.

**Testes:** 4 casos novos em `run-check-tests.ps1`, e 1 caso da v3.64.3 com a expectativa nova (Arquiteto com o prompt de substituição, e não 🟨):
- a marca ao levar a 🟨;
- o `done` recusado com o relatório de antes da emenda;
- o disparo mandando começar pelo `start`;
- o relatório novo liberando o `done` e apagando a marca.

**Suítes** (`run-all-tests.ps1`, 8 processos): 1.072 casos, 0 falharam, em 689 s.

## v3.64.3 — 2026-11-19

**Branch:** `fix/v3.64.3` a partir de `develop` (`78b88f5`, v3.64.2 mesclada)

Origem: sprint 6 do projeto piloto, 19/11. O Arquiteto emendou o plano da Q-S6e com a decisão 147, e o `plan.ps1` reprovou só pelo tamanho (31,8 KB contra o teto de 30 KB). O passo de replanejar da v3.64.2 tratava qualquer reprovação como "Arquiteto corrige até passar", e o `next` repetiu a mesma ação três vezes. Não havia saída:
- o `plan.ps1` manda não cortar plano grande;
- a divisão automática só vale para a Task no preparo ("a que está em construção segue", v3.53.6) e nunca roda para as correções do portão (Q-S), cujo ramo no preparo vem antes dela.

A sessão do piloto pausou o run e propôs dividir a Q-S6e à mão. Isso desfaria a amarração da Q-S com o portão: o nome `Q-S<n>` + letra, os IDs dos achados e a cadeia `**Corrige:**`.

**O plano emendado que não passa** (`run.ps1 next`, passo de replanejar):
- **Só o tamanho:** a Task segue para 🟨 com aviso, como a Task em construção. O dev lê o cartão e o bloco, não o plano inteiro. O run-log registra o motivo.
- **Outra reprovação:** as linhas reprovadas ficam no fim do `handoff/<ID>-replan.md`, e o Arquiteto, em instância nova, corrige só o que reprova, sem desfazer a decisão nem cortar o tamanho, e regrava o plano.
- **A mesma reprovação de novo** (assinatura sem datas): rota de bloqueio, degrau 1 (PO + Arquiteto) e, sem solução, formulário (R22). Sem outro Arquiteto igual nem dev.

**Testes:** 3 casos novos em `run-check-tests.ps1`:
- o plano emendado só acima do teto vai a 🟨 sem pedir o Arquiteto;
- a reprovação por outra regra vai ao handoff e ao Arquiteto;
- a mesma reprovação pela 2ª vez vai ao degrau 1.

**Suítes** (`run-all-tests.ps1`, 8 processos): 1.068 casos, 1 falhou, em 582 s. A falha foi a paridade do CDP da v3.62.0 ("paridade: erro — fetch failed", com o Chrome headless sob carga), fora desta entrega. Rodado sozinho, o trecho passou (5 casos, 0 falharam). É a 3ª intermitência sob carga em três rodadas, depois do `verify` A6 e do garden 28 na v3.64.2.

## v3.64.2 — 2026-11-19

**Branch:** `fix/v3.64.2` a partir de `develop` (`cc437f9`, v3.64.1 mesclada)

Origem: sprint 6 do projeto piloto, 19/11. A Q-S6e estava em 🔴 pela queda do Karma no `verify full`, e o stakeholder respondeu ao formulário "Ajustar a espera — o Arquiteto ajusta a espera e a forma de reconhecer o navegador pronto". A sessão fez `mark.ps1 -To build`, e o executor disparou um dev novo. O plano ainda dizia "NÃO mexer no `karma.conf.js`", e o dev repetiu os ~11 min do mesmo `verify full` que já tinha caído três vezes. O texto que mandava fazer isso era da própria v3.64.1: "o stakeholder repara → `mark.ps1 -To build` → o executor retoma".

**Sair de 🔴 diz como** (`mark.ps1 -Reopen`):
- **`resume`:** o reparo foi fora do repositório (máquina, emulador, configuração do stakeholder) ou o ajuste já está feito. A Task retoma como está.
- **`replan -Decision "<a resposta>"`:** a decisão muda o que o plano manda (configuração de teste, `guards.json`, arquivo fora de **Arquivos tocados:**, algo que o plano proíbe). A Task vai a 🟦, e a decisão fica em `sprints/<n>/handoff/<ID>-replan.md` com a linha de Bloqueios.
- **Sem `-Reopen`:** o `mark.ps1` recusa e nada é gravado.
- **Ficam de fora** as reaberturas que já têm dono: a "prova no alvo pendente", que o `next` reabre sozinho, e o "estado de partida", que volta a 🟪.
- **Chamadas do próprio `run.ps1`:** a "provar por teste" e o `done` que fecha pela evidência passam `resume`.

**O Arquiteto antes do dev** (`run.ps1`):
- **`next`:** com `handoff/<ID>-replan.md` e o plano ainda não regravado depois dele, dispara o Arquiteto (`/arc question`, instância nova) para emendar o plano com a decisão e rodar o `plan.ps1`. Emendado e verde, o `next` leva a Task a 🟨, apaga o handoff, registra no run-log e segue a fila. Emendado, mas com o `plan.ps1` reprovando, o Arquiteto corrige antes de qualquer dev.
- **`start`:** recusa o dev enquanto a emenda não vem. O executor devolve `<ID> ⏸ replanejar` (`agents/task-runner.md`).

**Textos:** a rota do bloqueio do portão (`gate.ps1`), a linha de Bloqueios (`mark.ps1`), a configuração do alvo e o vaivém do alvo (`run.ps1`) e o roteiro (`sprint-run.md`) citam as duas formas.

**Testes:** 8 casos novos em `run-check-tests.ps1`:
- a recusa sem `-Reopen`;
- `replan` sem `-Decision`;
- a reabertura que já tem dono;
- `replan` levando a 🟦 com o handoff;
- o `start` recusando;
- o `next` disparando o Arquiteto e não o dev;
- o plano emendado levando a 🟨.

Um caso da v3.64.1 passou a conferir o texto novo da linha de Bloqueios.

**Suítes** (`run-all-tests.ps1`, 8 processos): 1.065 casos, 0 falharam, em 631 s de parede.

A rodada completa anterior teve 2 falhas fora desta entrega, ambas em mutação do `verify`:
- `v3.57.0 A6`: "sem repositório git na raiz", num projeto que faz `git init` no mesmo trecho.
- `garden 28`: "rode -Mode full antes", logo depois de um `verify full` cujo resultado o caso descarta.

Sozinhos, os dois trechos passaram, e passaram também na rodada seguinte. Ficam como intermitência sob carga, com a causa exata não provada.

## v3.64.1 — 2026-11-19

**Branch:** `fix/v3.64.1` a partir de `develop` (`c42b301`, v3.64.0 mesclada)

Origem: sprint 6 do projeto piloto, 18–19/11. A Q-S6e (correção da rodada 4) parou em 🔴 porque a suíte do Karma caiu no `verify full` (Chrome Headless desconectado), e o accept dos 21 cenários nunca rodou. Na retomada, o `run.ps1 next` mandou o operator medir o portão de novo (`quality.ps1` e `accept.ps1 -Resume`) sobre o código parcial da correção, em vez de levar ao destravamento dela. O stakeholder perguntou: "se o problema está nas evidências faltantes, por que não se recomeça o trabalho nesse ponto?"

**Task em 🔴 segura a medição** (`gate.ps1`):
- O `$open` do `run.ps1` não conta as Tasks em 🔴, então a fila parecia vazia e o portão começava. A medição dependia só de a árvore de produção ter mudado.
- Agora, com algo a medir e uma Task em 🔴 que nenhuma outra substitui (`**Corrige:**`), o portão vai à rota do bloqueio dela, sem operator. Vale para a correção do portão e para a Task original.
- A rota grava `.ask-route`: `ambiente` quando o motivo é de ambiente (formulário ao stakeholder), `bloqueio` nos outros casos (degrau 1). A saída traz o motivo de Bloqueios e o caminho de volta (`mark.ps1 -Task <ID> -To build` e `run.ps1 next`).

**A rota do bloqueio vem antes da rodada focada** (`gate.ps1` §F):
- A medição ou a resolução mais nova que o veredito mandava o QA julgar de novo, e a regra "Q-S em 🔴 vai à rota do bloqueio" (v3.64.0) nunca era alcançada. A ordem agora é: a rota do bloqueio, depois a rodada focada.

**A linha de Bloqueios só promete o que o next faz** (`mark.ps1`):
- "o run.ps1 next reabre quando o alvo responder" só aparece com a etiqueta "prova no alvo pendente", a única que o `next` reabre sozinho.
- Os outros motivos de ambiente (ex.: "ambiente: suíte Karma…") recebem "reabre com mark.ps1 -To build depois do reparo". O alvo responder não prova que o Karma roda.

**A G14 diz o caminho certo do script do plugin** (`hooks/pre-tool.ps1`, `run.ps1 allow`). Em 19/11, o operator chamou `& '<plugin>\3.64.0\accept.ps1' -Task S6 -Resume`, sem o `scripts\checks\`, e esse arquivo não existe. A G14 negou com a mensagem genérica "fora da lista operacional", porque o trecho era cortado em 80 caracteres antes do teste de `.ps1`. A sessão concluiu que faltava autorização e gravou o caminho do cache, com a versão, em `runCommands`. Isso não destravou nada: a mesma chamada foi negada de novo.
- **Script do plugin no caminho errado:** quando o nome existe em `<plugin>/scripts/checks/` e o caminho é a pasta do plugin, o cache de plugins ou o nome solto, a recusa traz o caminho certo e diz para não pedir `run allow`. O script homônimo do projeto não é confundido com o do plugin.
- **Mensagem de `.ps1`:** o teste de `.ps1` da mensagem é feito antes do corte.
- **`run.ps1 allow`:** recusa script do plugin (pelo caminho do cache, por `${CLAUDE_PLUGIN_ROOT}`, por `scripts/checks` ou pelo nome solto) e não grava nada.
- **O que não muda:** a regra de liberação. Só passa `${CLAUDE_PLUGIN_ROOT}/scripts/checks/<script>.ps1`. Casar pelo nome base liberaria qualquer `accept.ps1` do projeto.

**As suítes em paralelo, com prazo por caso** (`scripts/checks/tests/`). Pedido do stakeholder em 19/11: a rodada de base levou mais de uma hora (692 casos em sequência; soma dos casos 3.579 s). Dois casos do `verify full` desprendido seguraram 1.369 s e 389 s sozinhos, e a suíte de guardas só começava depois da de conferências.
- **`run-all-tests.ps1` (novo):** roda as duas suítes ao mesmo tempo.
  - A de conferências é dividida em blocos independentes, cada um num processo com o próprio `$tmp`.
  - A de guardas roda inteira ao lado, porque os casos dela dividem o mesmo projeto falso.
  - O pool tem `-Workers` processos (padrão: núcleos − 1, de 2 a 8), e o bloco mais pesado entra primeiro.
  - A saída traz as falhas, com a saída do caso, os casos mais lentos, o tempo de cada bloco, o tempo de parede e "N casos · F falharam".
- **`suite-blocks.ps1` (novo):** acha os cortes pela árvore sintática da suíte. Nenhum valor atravessa um corte: variável, função definida no corpo, variável de ambiente e pasta do `$tmp` citada pelo nome. Os cortes são recalculados a cada rodada, então caso novo não precisa de marca. As constantes e os ajudantes que vários trechos usavam (`$warn`, `$ck`, `$bdText`, `New-FixBlock`, `$e0` e o harness do portão `$gh63`/`$g63`/`$lib63`) foram para o preâmbulo. O caso 8 (C2 no projeto feliz) ganhou um projeto próprio, no mesmo estado do caso 1.
- **`-Only '<regex>'`:** roda só os blocos com algum caso cujo nome casa. A suíte de guardas entra inteira, e só se algum caso dela casar. Serve para a rodada focada durante o desenvolvimento. Sem `-Only`, roda tudo: é a conferência antes do commit.
- **Prazo por caso:** a `check-watchdog.ps1` (nova) sobe no preâmbulo das duas suítes, também quando rodam sozinhas. A cada 3 s, encerra a árvore do processo filho que passou de `TEAM_TEST_CHECK_TIMEOUT_S` (padrão 240 s; `-CheckTimeoutSec` no `run-all-tests.ps1`), e o caso falha com "TEMPO ESGOTADO".
- **Equilíbrio dos blocos:** os tempos de cada caso ficam em `%LOCALAPPDATA%\team-plugin\test-times.json` e equilibram os blocos da rodada seguinte.
- Os dois arquivos de suíte seguem rodando sozinhos, como antes.

**Testes:**
- 5 checagens novas em `run-check-tests.ps1`:
  - a medição segurada com a Q-S em 🔴 e com a Task original em 🔴;
  - a rota do bloqueio antes da rodada focada;
  - o texto de Bloqueios com e sem a etiqueta;
  - o `allow` que recusa script do plugin.
- 4 checagens novas em `run-guard-tests.ps1`:
  - o caminho errado com `&` e com `powershell -File`;
  - o homônimo do projeto;
  - o caminho certo, que segue liberado.
- Um caso antigo mudou de expectativa: a Task com "prova no alvo pendente" fica fora da trava da medição, porque o `next` a reabre sozinho (v3.53.6 item 9c, inalterado).

**Suítes** (`run-all-tests.ps1`, 8 processos): 1.058 casos, 0 falharam (`run-check-tests.ps1` 692 e `run-guard-tests.ps1` 366), em 548 s de parede, contra mais de 1 h em sequência. Agora o caminho crítico é a suíte de guardas (540 s).

Problemas que a 1ª rodada em paralelo achou e foram corrigidos antes do commit:
- A sentinela encerrava o `conhost.exe` da própria suíte, que é filho dela e vive o tempo todo, e o bloco morria sem log. Agora ela o ignora.
- O `Add-Type` do `ZipFile` ficava num bloco e o uso dele em outro. A carga foi para o preâmbulo, e o `suite-blocks.ps1` recusa `Add-Type` no corpo.
- A suíte de guardas, com a saída redirecionada, escrevia na página OEM. Agora roda com UTF-8.

Na rodada de base em sequência, 3 casos do `verify full` desprendido falharam por demora (1.369 s e 389 s). Rodados de novo sozinhos, e depois na suíte completa, passaram.

## v3.64.0 — 2026-11-18

**Branch:** `feat/v3.64.0` a partir de `develop` (`74a03a9`, v3.63.2 mesclada) · **Processo:** v3.64 (`process-changelog.md`) · **Plano:** `melhorias/plano-v3.64.0.md` (decisões D1–D8 do stakeholder, 18/11)

Origem: análise do sprint 6 do projeto piloto pedida pelo stakeholder em 18/11 ("tudo que gerou retrabalho") e duas paradas do mesmo dia — a Q-S6e no Karma e o portão que mandava abrir a Q-S6f. O retrabalho que o próprio processo criava: 58 instâncias de dev só para a evidência (17 repetindo a anterior igual), cartões que contradiziam o plano, código de Task parada travando a seguinte, a máquina dividida com outro projeto sem trava nenhuma e o portão preso no formato antigo do `validation.md`.

**Item 2 · a evidência que o script já sabe** (`close.ps1`, `run.ps1 done`):
- O R7 do dev vale pela **prova registrada**: com o verify full verde na árvore de agora (ou o plano dispensando o full e o accept registrado), a saída não precisa ser colada; o `done` copia `### Prova registrada` para o relatório.
- Sem a seção `### Documentos vivos (R12)`, o `done` a escreve ("a consolidar", com o `**Documentos vivos:**` do plano) e confere de novo no mesmo processo. No modo dev, "n/a" e "nenhum" valem como "a consolidar".
- R7-margem: a linha fora do formato que a leitura tolerante entende vira **aviso** (D2); as travas seguem bloqueantes.
- **A rota da reprovação segue a natureza** de cada linha: prova não rodada → **operator** roda o comando, sem dev e sem contar como falha de papel (D3) · prova vermelha ou escopo → dev em instância normal, que pode mudar código · sem verify configurado → dev só para a evidência · só ambiente → rota de ambiente.
- **Repetição idêntica para** na 2ª vez (D4): a mesma assinatura na mesma árvore vai ao Arquiteto (ou ao stakeholder, se for ambiente), sem outro dev nem operator (`handoff/<T-ID>-evidencia.json`).

**Item 5 · o cartão que não contradiz o plano** (`run.ps1` `Write-Handoff`, `close.ps1`):
- O cartão separa **"O que o plano manda"** (as linhas `**Verificação:**`, `**Aceite:**` e `**Cenários:**` copiadas do plano) de **"O que já rodou"** (`**Verify registrado:**`, `**Accept registrado:**`). Antes, a linha **Verificação:** do cartão dizia o estado ("sem verify") com a etiqueta da ordem do plano.
- "Não mude código" saiu do cartão; o "Só completar a evidência" fica para a saída que só o dev tem.
- A mensagem do R7 fala só do que o plano manda rodar (com `**Aceite:** não roda`, só do verify) e cita a linha do plano.

**Item 6 · a árvore com dono** (`lib.ps1`, `mark.ps1`, `run.ps1`, `gate.ps1`, `close.ps1`):
- **Checkpoint** (D1): a Task que sai da construção sem fechar — 🔴 pelo `mark.ps1`, a pausa do run, a espera de um GAP — vai num commit só do escopo do plano, `<T-ID> (checkpoint, sem fechar): …` com `Task-State: parcial`. O marcador não muda.
- No `start`, o pendente do escopo de **outra** Task aberta vai num checkpoint dela; o que não tem dono aparece como aviso e no run-log.
- `guards.json → treeIgnore`: sobras que não são código saem da impressão da árvore e dos pendentes.
- "A árvore mudou depois do verify" passa a dizer os arquivos que mudaram (`Get-TreeDiff`).
- Antes de medir, o portão faz o checkpoint das Tasks abertas e mostra o pendente que sobra.

**Item 7 · a máquina dividida entre projetos** (`verify.ps1`, `lib.ps1`, `quality.ps1`, `gate.ps1`, `machine-lock.ps1` novo):
- **Diagnóstico da queda da suíte**: em pontos diferentes, o `verify` mede a CPU, o ritmo contra a última suíte verde e os emuladores, servidores do adb e travas de outros projetos. Máquina ocupada → "máquina ocupada", esperar e repetir, sem Task; só com a máquina livre ele aponta a configuração do projeto.
- **Trava de trabalho pesado** (D6), comum aos projetos da máquina (`device-locks/machine-heavy.json`): a suíte do verify full espera até `machine.heavyWaitMin` (padrão 30) e sai como ambiente; o accept e o reparo do android a tomam pelo `Enter-TargetLock` (reentrante no mesmo projeto); o portão espera. Scripts de fora do plugin: `machine-lock.ps1 -Take/-Release/-Who`.
- **Porta por projeto, adb único** (D8): com dois servidores do adb na máquina ou a porta do emulador fora do padrão (par, 5554–5584), a trava do alvo recusa com a causa e a proposta da primeira porta livre; o plugin não desliga nada de outro projeto.
- **Reaproveitar pelo que o comando lê** (D7): `guards.json → verify.<chave>` aceita `{ "command", "inputs" }`; o último verde de cada comando fica em `result.json → lastGreen` (uma rodada vermelha não o apaga) e é reaproveitado quando nada dos `inputs` mudou; a cobertura acompanha a suíte. A Q11 da revisão final não aceita a cobertura reaproveitada por inputs, e o portão roda `verify -Mode full -Fresh` antes da qualidade quando só ela existe.

**Item 8 · o portão preso no formato antigo** (`gate.ps1`):
- A rodada focada pede a tabela `| ID | Task | Achado | Onde | Cause | Owner | State | Evidência |` e, no formato anterior à v3.63.0, a conversão dos achados antigos abertos.
- Nenhuma `Q-S<n>` nova com outra aberta: os achados vão à aberta e o Arquiteto emenda o plano dela (`/arc question`, `plan.ps1`). `**Corrige:** <Q-S>` no plano faz a antiga contar como substituída.
- A correção que cobre os achados em 🔴 vai à rota do bloqueio dela, nunca a "esperar".
- O `diagnostico.md` do operator mais novo que o `validation.md` pede a rodada focada.

**O que mudou em relação ao plano:**
- **Sobra sem dono no `start`** é aviso e linha no run-log, sem parada ao SM: o checkpoint e o `treeIgnore` já resolvem o que travou o piloto, e a parada reprovaria o início de Tasks em projetos com qualquer arquivo solto.
- **Árvore pendente no portão** é checkpoint e aviso, sem recusar a medição.
- A trava pesada vale para o alvo **android** (o servidor web local de um projeto não pesa como emulador).
- A "correção substituída" é lida do plano a cada `next` (nota na saída), sem gravar no quadro.

**Arquivos:** `scripts/checks/lib.ps1`, `run.ps1`, `gate.ps1`, `close.ps1`, `verify.ps1`, `quality.ps1`, `mark.ps1`, `machine-lock.ps1` (novo); `agents/task-runner.md`; `roles/developer/templates/delivery-report.md`; `roles/quality-assurance/templates/sprint-validation.md`; `roles/scrum-master/process/sprint-run.md`, `process-changelog.md` e `process-changelog-archive.md`; `deliverables/team-project/guards.json`; `how-to.md`; testes em `scripts/checks/tests/run-check-tests.ps1` (casos v3.64.0).

**Testes novos** (`run-check-tests.ps1`, marcados v3.64.0): 5 do portão (item 8), 8 da evidência e do cartão (itens 2 e 5), 3 da árvore (item 6), 11 da máquina (item 7, com a D8). Dois casos antigos mudaram de expectativa pela decisão: o cartão do v3.57.2 não traz mais "não mude código", e a linha de margem lida do v3.55.0 vira aviso (D2). A suíte fixa a medida da máquina (`TEAM_TEST_MACHINE_LOAD`, `TEAM_TEST_ADB_PORTS`): nenhum caso depende do que roda de verdade nela.

**Suítes:** `run-check-tests.ps1` 687 casos, 0 falharam · `run-guard-tests.ps1` 362 casos, 0 falharam. A primeira rodada completa teve 1 falha (C5: o portão abria Q-S em vez da rodada focada — no PowerShell 5.1 um `PSCustomObject` sozinho não tem `.Count`); corrigida em `gate.ps1` antes do commit.

---

## v3.63.2 — 2026-11-18

**Branch:** `fix/v3.63.2` a partir de `develop` (`6c8edb6`, v3.63.1 mesclada) · **Processo:** addendum v3.63.1, item "dois projetos, um emulador" (`process-changelog.md`)

Origem: pergunta do stakeholder no mesmo dia, depois da v3.63.1: como impedir que dois projetos da mesma máquina usem o mesmo emulador ao mesmo tempo.

**Sintoma.**
- A trava do alvo é por projeto (`.team-project/.target-lock`): um projeto não via a trava do outro.
- Dois projetos apontando para o mesmo emulador entravam os dois, e os testes dos dois quebravam.
- O reparo de um (reiniciar o emulador) derrubava no meio o teste do outro.
- O `-Who` da v3.63.1 só avisava do accept de outro projeto.

**Correção** (`lib.ps1`, `target.ps1`, `gate.ps1`):
- **A trava do aparelho.** Fica em `%LOCALAPPDATA%\team-plugin\device-locks\<serial>.json`, comum a todos os projetos da máquina.
  - É tomada no mesmo ponto da trava do projeto (`Enter-TargetLock`), então cobre o accept, o reparo, a conferência e o `-Release`.
  - Usa as mesmas regras: criação atômica, dono vivo que anda não perde a trava, dono morto ou PID reaproveitado é assumido.
  - Com o aparelho ocupado, a trava do projeto é devolvida e a mensagem diz o projeto dono, o processo, desde quando e o sinal de vida.
- **Qual é o aparelho.** É o `guards.json → targets.android.serial`. Sem ele, o único aparelho conectado (`adb devices`). Sem aparelho único, o aparelho padrão da máquina. O alvo web não tem trava de aparelho: cada projeto sobe o seu site.
- **O portão** (`Get-TargetBusy`) também vê o aparelho com outro projeto: espera o que anda; parado, leva ao stakeholder com o `-Kill -Root` daquele projeto.
- O `target.ps1 -Who` mostra o aparelho e quem o segura.
- **Rodar os dois ao mesmo tempo:** cada projeto declara o seu aparelho em `targets.android.serial` (`how-to.md`).
- A suíte de testes usa uma pasta de travas própria e um serial fixo (`TEAM_DEVICE_LOCK_DIR`, `TEAM_TEST_DEVICE_SERIAL`): nenhum teste toca a trava real da máquina.

**Arquivos:** `scripts/checks/lib.ps1`, `target.ps1`, `gate.ps1`; `how-to.md`; `roles/scrum-master/process/sprint-run.md` e `process-changelog.md`; testes em `scripts/checks/tests/run-check-tests.ps1` (casos v3.63.2).

**Suítes:** `run-check-tests.ps1` 660 casos, 0 falharam · `run-guard-tests.ps1` 362 casos, 0 falharam.

---

## v3.63.1 — 2026-11-18

**Branch:** `fix/v3.63.1` a partir de `develop` (`0626656`, v3.63.0 mesclada) · **Processo:** addendum v3.63.1 (`process-changelog.md`)

Origem: pedidos do stakeholder do projeto piloto no sprint 6 (18/11, sessão `/sm sprint run`). A pergunta central foi: "Esse erro não era previsto tratar pelo plugin retornando ao dev, ao UX ou ao PO para indicar qual botão acionar e onde ele está?" Era previsto. A v3.63.0 levava o achado ao dono, mas a falha de cenário que saía como ambiente nunca chegava a ser achado.

**Sintoma.**
- Um operator travou 600 s e foi encerrado pelo watchdog. O `accept.ps1 -Task S6 -Resume` que ele disparou ficou órfão segurando o alvo.
- O reparo recusou com "em uso por accept S6", e o `target.ps1 -Kill` disse "nada registrado".
- O `next` repetiu "reparar e repetir o aceite" sem fim: o accept recusado pela trava não grava `result.json`, então a contagem do portão nunca subia.
- O SC-118 falhou duas vezes ("a conexão com a página caiu"; a captura mostrava a aba Geral, não a Estufa). O cenário seguinte parou em "app não ficou na frente, foco: nenhum".
- O `next` tratou como ambiente, sem diagnóstico. O diagnóstico pedido à mão saiu AMBIENTE sem registro do aparelho, e a revisão parou à espera do stakeholder.
- O `-Resume` leu "apk:?" (o APK foi instalado pelo comando do projeto, sem arquivo local) e rodou todos os cenários.

**Correção** (os números são os dos pedidos):
- **1 · Diagnóstico automático** (`gate.ps1`, `run.ps1 done -Result env`). Toda falha de cenário do aceite passa pelo operator antes de virar ambiente ou de ir ao QA: um FALHOU, ou a interrupção com sinal do app.
  - O prompt é um só (`Get-AcceptDiagPrompt`). Pede as capturas, o registro do aparelho e o sinal, e as linhas `Veredito`, `Cenário`, `Motivo`, `Elemento`, `Onde` e `Dono`. AMBIENTE só vale com prova.
  - No portão: AMBIENTE → reparo e retomada · APP → o QA registra o achado `code` · PLANO → `scenario` (Dono QA) ou `design` (Dono Arquiteto). O elemento e o onde vão para o prompt do QA.
  - Na Task: APP → dev novo com o diagnóstico · PLANO → `/qa` corrige o `.scn` ou `/arc question` · AMBIENTE → a rota de ambiente de sempre. O `done -Result gap` usa o mesmo prompt.
- **2 e 3 · Prova e sinal no android** (`accept.ps1`, `targets/android.ps1`).
  - O registro do aparelho começa limpo em cada cenário. Na falha, vai a `logs/<ID>-<tentativa>-logcat.txt`, com o buffer de crash; com o executor do projeto, um por arquivo.
  - O sinal é separado do foco: `crash`, `anr`, `closed`, `restarted`, `webview-recreated`, `system-window` ou `no-focus`.
  - O app que fecha com erro ou não responde ao abrir é FALHOU do cenário, não ambiente.
  - A interrupção grava `environmentSignal`. O registro entra na prova da rodada (`Copy-Proof`).
- **4 · Identidade do app instalado.** O `-Resume` lê o hash do `base.apk` no aparelho (`pm path` + `sha1sum`), igual ao do arquivo quando foi ele o instalado. Sem `sha1sum`: versão e hora da última instalação. Sem resposta do aparelho: o arquivo local.
- **5 · O órfão.** A trava do alvo grava a hora de criação e a pasta do dono. O `target.ps1 -Kill` encerra o dono da trava, com a árvore dele, quando é o `accept.ps1` ou o `target.ps1` do plugin (reconhecido pela hora de criação e pela linha de comando). PID reaproveitado ou processo de fora não é tocado.
- **6 · Sonda de travamento.** O sinal de vida do alvo preso lê a pasta do dono (o `progress.json` do accept), além da CPU e dos descendentes recentes. O "parece travado" de antes vinha só da CPU.
- **7 · O laço de reparo.** Com o alvo em uso, o portão espera (pelo watcher) o accept do plugin que ainda anda. Se o dono está parado, ou não é um processo do plugin, vai ao stakeholder na primeira vez. O mesmo `result.json` pedindo reparo pela 3ª vez também vai ao stakeholder.
- **8 · O navegador da suíte que cai no meio** (`lib.ps1` `Get-RunnerDisconnect`, `verify.ps1`). Caso: o Karma com "Disconnected … because no message in 120000 ms", ou o Chrome que fecha ou não é capturado (Q-S6d: duas quedas seguidas no `verify full`, reprovadas como suíte vermelha).
  - Agora a queda é reconhecida como "não é teste reprovado", com o ponto em que caiu (o último "Executed N of M").
  - O verify repete a rodada uma vez, conferindo a memória antes: abaixo de `verify.minFreeMB`, desliga o emulador que a suíte não usa.
  - Caiu de novo **no mesmo teste**: um teste trava o navegador. É falha do código (exit 1), com o suspeito apontado.
  - Caiu **em pontos diferentes**: é carga ou memória da máquina. Fica como ambiente (exit 4), com a memória livre e os maiores consumidores. O prazo do runner (`browserNoActivityTimeout`, `browserDisconnectTolerance`) e as flags do navegador são configuração do projeto e vão por Task, com o Arquiteto.

- **Quem usa o aparelho, e a trava que não deixa dois entrarem** (`lib.ps1`, `target.ps1`). Pedido do stakeholder no mesmo dia, depois de a sessão do piloto e o próprio plugin contarem "três accepts no aparelho". Eram um accept, o invólucro da rodada desacoplada e cópias do `detach.ps1` que só acompanhavam a mesma rodada; dois observadores foram encerrados como duplicados.
  - `target.ps1 -Who` (só leitura) separa o dono da trava (com o sinal de vida e os cenários), cada accept que usa o aparelho, os invólucros e quem só acompanha. O accept de outro projeto na máquina aparece como tal e nunca é tocado.
  - `-KillDuplicates` encerra só o accept deste projeto que não é o dono da trava. O projeto de cada accept vem do `-Root`, da pasta da rodada que o lançou ou do `progress.json` deste projeto.
  - A trava é criada de forma atômica (`CreateNew`): dois accepts que partem juntos não entram os dois.
  - A trava de um dono vivo que ainda grava progresso não é tomada nem depois de 3 h. Parado há mais de 3 h, sim.
  - O `-Unlock` recusa (exit 4) quando o dono está vivo.
  - O accept dentro do invólucro codificado (`-EncodedCommand`) é reconhecido pelo `-Kill`.
  - O `detach.ps1` confere o alvo antes de abrir uma rodada nova de accept. Com outro accept vivo segurando o alvo, não abre (exit 5, `OCUPADO`) e diz a pasta da rodada dele, que o mesmo comando volta a acompanhar. O operator que cai e é disparado de novo não empilha rodadas.

**Arquivos:** `scripts/checks/accept.ps1`, `targets/android.ps1`, `gate.ps1`, `run.ps1`, `lib.ps1`, `target.ps1`, `verify.ps1`; `agents/operator.md`; `roles/scrum-master/process/sprint-run.md` e `process-changelog.md`; `standards/scenario-language.md`; testes em `scripts/checks/tests/run-check-tests.ps1` (casos v3.63.1).

**Suítes:** `run-check-tests.ps1` 654 casos, 0 falharam · `run-guard-tests.ps1` 362 casos, 0 falharam. A suíte de checks deixou de tocar o adb real da máquina: o teste do `-Kill` da v3.57.0 removia o `adb forward` da WebView de um accept de projeto rodando no emulador.

---

## v3.63.0 — 2026-11-17

**Branch:** `feat/v3.63.0` a partir de `develop` (`a613c4f`, v3.62.3 mesclada) · **Processo:** v3.63 (o portão do QA por marcos) · **Plano:** `melhorias/plano-v3.63.0.md`

Origem: sprint 6 do garden (15–17/11). O stakeholder pediu marcos no portão do QA, para que a falha de uma validação não reinicie tudo; um motivo em cada falha de cenário, que leve a correção ao UX, ao PO, ao Arquiteto ou ao dev; o portão controlado no quadro e no consumo; e a prova de cada entrega guardada no sprint.

**Sintoma.**
- O portão reprovou em 3 rodadas seguidas, quase todas por ambiente, e abriu 4 Tasks de correção (Q-S6 a Q-S6d).
- Cada rodada refez a qualidade inteira e os 49 cenários, também depois de correções só na ferramenta de prova.
- O `validation.md` citava a prova das rodadas 1 e 2, e só existia a da última.
- O achado só podia voltar ao dev ou ao Arquiteto, em texto livre.
- A medição e o julgamento do portão caíram em `n/a · sprint-6` no consumo, e o "## Agora" mostrou como trabalhando agentes encerrados havia 37 min.

**Correção:**
- **Portão por marcos** (`scripts/checks/gate.ps1`, novo; chamado pelo `run.ps1 next`; estado em `sprints/<n>/gate.json`).
  - **A · ambiente não é veredito:** o `accept` com `environment` não conta como medição; o `next` manda `target.ps1 -Repair` e `accept.ps1 -Task S<n> -Resume`; na 2ª vez seguida, ou com `configuration`, formulário ao stakeholder — sem QA, `Q-S<n>` nem Arquiteto.
  - **C · base por frente:** a **árvore de produção** (`Get-ProductionTree`: os arquivos versionados menos os de teste e menos o novo `guards.json → quality.toolingPaths`) e o **conjunto de cenários** (`Get-ScenarioSetHash`). O `quality.ps1` e o `accept.ps1` gravam `prod`; o `accept`, também `app` e `scenariosHash`. O `result.json` antigo, sem `prod`, compara a árvore inteira, como antes.
  - **D · rodada focada:** o operator recebe só o comando vencido; o QA recebe as frentes a julgar, as que ficam como estavam e os achados abertos.
  - **E/F · causa com dono:** o `validation.md` traz `## Frentes` e `## Achados` (ID `S<n>-F<k>`, `Cause`, `State`; `Read-ValidationFindings`). Rota em série: `requirement` → PO · `screen` → UX · `design` → Arquiteto · `scenario` → QA · `code` → `Q-S<n>` (que cita os IDs) · `environment` → reparo. Cada dono grava `sprints/<n>/gate/<ID>.md` com `**Resolution:** done | code | debt`. Causa fora da lista volta ao QA só para classificar; dono disparado 2 vezes sem resolução vai ao stakeholder. Sem a tabela nova, o caminho de antes.
  - **H · prova da rodada:** antes de cada rodada, `Copy-Proof` leva o resultado e as capturas para `sprints/<n>/proof/S<n>/round-<k>/`, sem os logs brutos; o QA lê e cita de lá.
- **B · `accept.ps1 -Resume`:** reaproveita o PASSOU da rodada anterior com a mesma identidade do app (android: hash do APK; web: `targets.web.appSources` ou a árvore de produção) e o mesmo texto do cenário; roda o resto. O `progress.json` guarda todas as linhas, para retomar depois de uma queda. Vale no executor do projeto (com `{only}`). Identidade ilegível roda todos.
- **Causa no GAP do dev** (`run.ps1 done -Result gap`): a linha `**Cause:**` (a mesma lista, mais `appearance` e `process`); `-Cause` ao lado do `-Nature`, e os nomes antigos são sinônimos. `requirement` vai ao PO (antes, `produto` ia direto ao formulário), `screen` ao UX e `scenario` ao QA.
- **Prova da Task** (`close.ps1 -Apply` com ✅): `sprints/<n>/proof/<ID>/{verify,accept}/`, sem logs.
- **Quadro e consumo:**
  - `kanban.md` com a seção `## Validação do sprint` (`Format-GateSection`, em palavras simples), e o `/team-status` com a linha "Revisão final".
  - A G16 reconhece `S<n>` e `S<n>-F<k>` e grava `gate_round`; o `consumption.ps1` dá as unidades "validação do sprint" e "correção do portão", trata a 2ª rodada como retrabalho e escreve a tabela "Por rodada do portão".
- **Registro de agentes** (`hooks/common.ps1` `Test-AgentStale`, `Remove-StaleAgents`): o registro sem ação há 20 min ou mais, e sem filho vivo, aparece como "sem sinal desde HH:mm — provavelmente encerrado" no "## Agora" e no `/team-status`. O `next` e o `start` o tiram do `.active-agents` para o `.interrupted`, com uma linha e o `run-log.md`.
- **Papéis e documentos:** `sprint-run.md`, `sprint-validation.md`, README e agentes do QA, PO, UX, dev e executor, `gap.md`, `sprint-backlog.md`, `scenario-language.md` §6, `how-to.md`, `hooks/COVERAGE.md`; o bloco v3.63 no changelog do processo (v3.60 relocada para o arquivo).

**Testes novos** (`run-check-tests.ps1`, marcados v3.63.0): 20 casos do portão, do `-Resume`, do quadro, do consumo, do `Get-WorkId` e do registro de agentes, mais 2 de GAP (`screen` → UX, `scenario` → QA). Os casos de GAP da v3.57 passaram aos nomes novos, com os antigos como sinônimos.

**Suítes:** check 625 casos — 617 verdes na rodada completa; os 8 restantes eram os roteiros antigos do `accept` (v3.54.2, v3.62.0, v3.62.3), que extraem uma lista fixa de funções e não carregavam as do `-Resume`: com as funções na lista, os blocos deles rodaram de novo em 13/13 · guard 362/0 · release C3 ok.

**Fica de fora:**
- O aviso no `close.ps1` de prova citada que não existe (plano §2.7): a cópia para `proof/` tira a causa; fica para quando o campo mostrar um caso.
- O aceite do sprint pelo executor do projeto (`targets.<alvo>.command`), como na v3.62.3.

---
## v3.62.3 — 2026-11-17

**Branch:** `fix/v3.62.3` a partir de `develop` (`ce69149`, v3.62.2 mesclada) · **Processo:** addendum v3.62.3 (o executor de cenários do projeto roda pelo `accept.ps1`)

Origem: sprint 6 do garden, Q-S6d (17/11). O stakeholder estranhou não conseguir acompanhar o aceite.

**Sintoma.** O plano da Q-S6d declarou `**Aceite:** não roda` e mandou provar os 49 cenários por um script do projeto (`prova-cdp.mjs`, que lê os mesmos `.scn`), rodado pelo operator numa pasta de job. A prova ficou fora da trava do alvo e sem `progress.json`. Ninguém sabia qual APK estava no emulador, e as capturas e o resultado ficaram fora de `.team-project/accept/`, onde o `close.ps1`, o `/team-status` e o QA procuram. A sessão chegou a dizer que "a QA precisa aceitar esse formato".

**Causa.** O plano só sabia dizer `não roda`, e esse modo leva os cenários aos testes do plano: o `close.ps1` deu `R7-aceite n-a` e nada conferiu o alvo. O motivo citado (D-16, "o `accept.ps1` no android não acha id do app") era do `uiautomator`. Desde a v3.62.0 o `accept` tem `locator: cdp`, e o `guards.json` do garden já o declarava.

**Correção:**
- **``**Aceite:** comando — `<cmd>` ``** (`lib.ps1` `Get-PlanAccept`, `Expand-AcceptCommand`, `Read-AcceptCommandLines`; `accept.ps1` `Invoke-AcceptCommand`, `Invoke-AcceptCommandRun`, `Find-AcceptShot`, `-Command`).
  - O `accept.ps1 -Task <ID>` lê a linha do plano e faz o de sempre: trava, pré-voo e reparo, APK velho, instalação e `targets.<alvo>.baseline` depois de instalar (decisão do stakeholder: o preparo é do plugin).
  - No lugar do executor interno, chama o comando um `.scn` por vez. `{scn}` é o arquivo, `{out}` a pasta da prova (`accept/<seg>/<ID>/cmd/<arquivo>`), `{only}` os cenários da Task nele e `{task}` o ID. Cada um vira um argumento entre aspas.
  - O resultado vem das linhas `<SC-ID> PASSOU|FALHOU|NÃO EXERCITADO [detalhe]` da saída (decisão do stakeholder: pelas linhas — o executor do garden já imprime assim). Cenário da Task sem linha conta como FALHOU.
  - Exit 2 sem linha = uso (exit 2). Exit 4 ou tempo esgotado por arquivo (`targets.<alvo>.commandTimeoutMin`, padrão 5 min por cenário, mínimo 10) = FALHA DE AMBIENTE (exit 4).
  - O que falhou é repetido uma vez, sozinho, quando há `{only}`.
  - `progress.json` a cada arquivo; `result.json`/`result.md` de sempre, com `executor: "comando"`, o comando e `runs` (arquivo, cenários, exit, segundos, log). O `close.ps1` e o `/team-status` o leem sem mudança.
  - O comando passa pelo filtro da regra 35: instalação, rede, push e destrutivo saem com exit 2. Sem `{scn}`, exit 2.
- **Cenários no alvo** (`Get-PlanScenarios`, `Get-SprintTasks` `AcceptCommand`): com `comando`, os cenários ficam no alvo. O cartão e o `start` mandam o `accept.ps1` e dizem que ele roda o executor do plano — e que o executor direto não vale.
- **Regra 34** (`plan.ps1`): `**Aceite:** comando` sem `{scn}`, com comando proibido ou com `**Cenários:** nenhum` reprova; sem `{out}`, avisa. `**Aceite:** não roda` que cita um script do projeto (`*.mjs`, `*.js`, `*.ps1`, `*.py`…; os scripts do plugin não contam) reprova e aponta o `comando`.
- **CRLF** (`Get-PlanVerification`, `Get-PlanAccept`): a linha do cabeçalho seguida de `\r\n` não era lida (o `$` do .NET não casa antes do `\r`). Achado nos testes desta entrega; a **Verificação:** tinha a mesma falha.
- **Papéis e contrato:** `standards/scenario-language.md` §5 (executor do projeto), modelo de plano e `external-plan.md`, `plan-rules-why.md` (34), `developer.md`, `operator.md`, `quality-assurance.md` (cenário provado fora do `accept` não é evidência de aceite).

**Testes novos** (`run-check-tests.ps1`, marcados v3.62.3):
- regra 34: `comando` ok; `não roda` com `prova-cdp.mjs` reprova (com `accept.ps1` não); sem `{scn}` reprova; com `npm install` reprova; com `comando` os cenários ficam no alvo;
- `accept -ParseOnly` mostra o executor do plano; `-Command` sem `{scn}` ou com `git push` sai 2 antes do alvo;
- ponta a ponta no alvo web: o reparo sobe o servidor, um `.scn` por vez, cenário sem linha = FALHOU (exit 1), `result.json` com `executor`, `commandFrom` e `runs`, `progress.json`, trava devolvida;
- repetição só do que falhou (passou na 2ª, falhou nas 2), exit 4 do executor com a última linha e quantos ficaram de fora, exit 2 sem linha.

**Teste corrigido:** o caso da v3.62.2 "rodada terminada sem ninguém recolher" esperava 12 s fixos por uma rodada que leva ~15 s (build, suíte de 9 s e o processo próprio) e falhava sempre, também na `develop`. Agora espera o `job.exit` da rodada (até 60 s).

**Suítes:** check 603 casos (602 na rodada completa; o 603º é o caso acima, verde depois do ajuste, com o bloco da v3.62.2 inteiro em 10/10) · guard 362/0 · release C3 ok.

`melhorias/`: cinco planos e relatórios antigos saem da pasta (limpeza do stakeholder).

**Fica de fora:**
- O aceite do sprint inteiro pela sessão (`run.ps1`, portão do QA) não lê plano de Task e continua no executor interno. Um projeto cujo executor interno não serve ainda não tem `targets.<alvo>.command` no `guards.json`.
- O garden: trocar o `não roda` da Q-S6d por ``**Aceite:** comando — `Set-Location source; node scripts/alvo/prova-cdp.mjs --task {task} --cenarios {scn} --only {only} --saida {out}` `` (ou rodar o `accept` com o `locator: cdp` que ele já declara) é decisão do projeto.

---
## v3.62.2 — 2026-11-17

**Branch:** `fix/v3.62.2` a partir de `develop` (`5ae0188`, v3.62.1 mesclada) · **Processo:** addendum v3.62.2 (comando longo em processo próprio; ninguém encerra o turno para esperar um comando)

Origem: sprint 6 do garden, Q-S6d (16–17/11). O stakeholder pediu "uma solução definitiva para esse ponto pq travou o processo por diversas vezes".

**Sintoma.** A suíte completa do projeto (17–25 min, `verify.timeoutMinutes` 25) morria no meio, e o run parava até alguém digitar. Foram 7 instâncias de dev numa Task, e uma suíte rodada à mão (`manual-suite.log`) para escapar.

**Causa.** A chamada do `verify` passava dos 600 s da ferramenta, que a movia para segundo plano. O dev seguia a regra da v3.53.3 e encerrava o turno com `ESPERANDO`, contando com o aviso de conclusão. O Claude Code responde assim nesse caso: "it is terminated when you give your final response and no notification can follow that — so do not end your turn to wait for it". O aviso não vinha, e o executor e a sessão esperavam por ele. O registro de agentes mantinha o dev "vivo, aguardando", e o watcher respondia "vivo".

Medido nas transcrições de 30 dias desta máquina: a mesma chamada (subagente, `timeout` 600000, estourou os 600 s) recebe ora "You will be notified when it completes", ora o encerramento. O encerramento aparece nas versões 2.1.308, 2.1.310, 2.1.325 e 2.1.326; na 2.1.326, também na sessão principal e no `run_in_background` explícito.

Medido em ensaio: o encerramento leva a árvore inteira, e o filho de `Start-Process` morre junto. O processo criado pelo WMI sobrevive, na mesma sessão do Windows e com o mesmo PATH. A regra do plugin dependia de um comportamento que o Claude Code não garante.

**Correção:**
- **Rodada desacoplada** (`scripts/checks/lib.ps1`: `Start-DetachedJob`, `Get-DetachedJob`, `Wait-DetachedJob`, `Stop-DetachedJob`; executor novo `scripts/checks/detached-run.ps1`).
  - O comando roda num processo criado por `Win32_Process.Create`, fora da árvore do Claude Code.
  - O ambiente de quem chamou vai num arquivo do TEMP, que o executor lê e apaga na partida.
  - A saída fica em `job.out`/`job.err` e o código de saída em `job.exit`.
- **`verify.ps1`** (focused, full e mutation; o `check` não muda). A chamada só acompanha a rodada, por até 480 s.
  - Terminou: a saída e o exit code são os da rodada, como antes.
  - Não terminou: **exit 3 "RODANDO"**, com o passo em curso.
  - O mesmo pedido de novo volta a acompanhar a mesma rodada, sem abrir outra.
  - Outro pedido da Task enquanto ela roda: exit 5 (OCUPADO), ou espera com `-WaitBusySeconds`.
  - Rodada que caiu sem resultado: a chamada diz e abre outra; caindo de novo na mesma chamada, exit 4.
  - Rodada terminada que ninguém recolheu: entregue se a árvore é a mesma, senão roda de novo.
  - O `-Kill` encerra a rodada desacoplada e a árvore dela.
  - Sem `-MaxMinutes` explícito, a rodada roda tudo de uma vez. O orçamento por chamada existia por causa dos 600 s, que não valem mais para ela.
  - `TEAM_VERIFY_INLINE=1` roda como antes.
- **`detach.ps1`** (novo): o mesmo contrato para qualquer comando longo do operator, com a pasta do job, `output.log` e `-Kill`.
- **`run.ps1`:**
  - O `done`, com o verify da Task em processo próprio, não fecha nem espera o aviso: manda `run.ps1 start`.
  - O `start` e o `next` seguem com a rodada viva, e o dev novo a reencontra pelo mesmo comando. Rodada travada continua indo ao POSSÍVEL TRAVAMENTO.
  - Agente vivo só por ter encerrado com `ESPERANDO`, sem comando acompanhável da Task, não conta como vivo para o `next`, o `start` e o watcher (`Select-LiveAgents`; `Test-AgentOnlyWaiting` em `hooks/common.ps1`).
  - O prompt do dev não manda mais encerrar o turno.
- **G14** (`hooks/pre-tool.ps1`):
  - `run_in_background` negado a todo papel durante o run, o operator incluído, com a rota do `detach.ps1`.
  - O comando de dentro do `detach.ps1 -Command "<…>"` passa pela mesma conferência dos trechos, e a negação cita o trecho de dentro.
  - Dev e executor rodando a suíte por dentro do `detach.ps1` são negados como a suíte direta.
  - As rotas do `Start-Sleep`/`Wait-Process` e da suíte direta apontam o processo próprio.
- **Papéis:** `developer.md`, `roles/developer/README.md`, `operator.md`, `task-runner.md`, `sprint-run.md`, `hooks/COVERAGE.md` e o addendum v3.62.2 no changelog do processo.

**Testes novos:**
- **`run-check-tests.ps1`:**
  - full mais longo que a espera sai com exit 3;
  - outro pedido com a rodada viva sai com exit 5;
  - o mesmo comando entrega o resultado;
  - **a árvore de quem chamou encerrada no meio da suíte, e a rodada sobrevive**;
  - rodada caída é refeita;
  - rodada não recolhida é entregue na mesma árvore;
  - o `-Kill` não deixa processo vivo;
  - `detach.ps1` sai com exit 3, depois exit 5, e por fim com o exit do comando e o log;
  - o `done` e o `start` com o verify em processo próprio;
  - o `next` com `ESPERANDO` sem comando vivo segue, e com o verify vivo espera.
- **`run-guard-tests.ps1`:**
  - operator com `run_in_background` negado;
  - `detach.ps1` com o comando de dentro liberado ou negado, e sem aspas;
  - `-Kill`;
  - suíte por dentro do `detach.ps1`: negada ao dev, liberada ao operator.

**Não testado em sessão real:** o sprint do garden com a suíte de 17–25 min do começo ao fim, sob o Claude Code 2.1.326. A prova de campo é retomar a Q-S6d.

## v3.62.1 — 2026-11-17

**Branch:** `fix/v3.62.1` a partir de `develop` (`4d35ae4`, v3.62.0 mesclada) · **Processo:** sem mudança

Origem: ensaio do braço NT do benchmark (`melhorias/plano-virada.md`, passo 3), antes de qualquer braço rodar. Decisão do stakeholder em 17/11 (formulário): corrigir antes de congelar.

**Sintoma.** Em projeto Android, o `verify` caía com exit 2 ("o processo não pode acessar o arquivo `…full-build.log`") logo depois de um build **verde**. Medido 3 de 3 vezes no código do N-forte-r1 do SunScape.

**Causa.** Com `org.gradle.jvmargs` diferente da JVM cliente (o padrão de projeto Android), o Gradle sobe um daemon de uso único mesmo com `org.gradle.daemon=false`. O daemon herda a saída redirecionada e fica órfão: o `gradlew` sai antes, e o `Stop-ProcessTree` não o alcança pela árvore. Ele segura o log e o `.err` por alguns segundos. O `Invoke-ProjectCommand` (`lib.ps1`) esperava 200 ms fixos e então lia o `.err` e acrescentava ao log com `ReadAllText`/`AppendAllText`, que não compartilham o arquivo. O código é o mesmo desde a v3.51.0: o P-r1 (v3.51.3) passou porque ganhou a corrida.

**Correção** (`scripts/checks/lib.ps1`):
- `Read-LogText`: lê com `FileShare.ReadWrite`, sem brigar com quem ainda escreve. Usada no `.err` e no `Get-Decisive`.
- `Add-LogText`: espera o log ficar livre (até 30 s), depois grava compartilhando a escrita e, se ainda assim não der, devolve `$false`. Nunca derruba a rodada nem escreve no stderr: um aviso ali derrubaria quem chama o `verify` com `2>&1` e erro fatal, como a própria suíte caiu na primeira versão desta correção.
- A remoção do `.err` não lança mais.

Medido: com um órfão de ~4 s, a chamada termina em 5 s (antes: exit 2). Com um órfão que não solta o arquivo, ela grava pelo caminho de reserva aos 30 s e segue.

**Testes novos:** caso `v3.62.1 log preso por órfão` na suíte de conferências, com quatro situações: órfão real de ~4 s; arquivo preso por quem escreve compartilhando; arquivo exclusivo (devolve `$false`, não lança, stderr vazio); `Get-Decisive` com o arquivo aberto.

**Não testado em sessão real:** o `verify full` de um braço do benchmark do começo ao fim (é o ensaio do passo 3 do plano da virada, que roda em seguida).

## v3.62.0 — 2026-11-16

**Branch:** `feat/v3.62.0` a partir de `develop` (`432680e`, v3.61.0 mesclada) · **Processo:** v3.62 (a prova do app híbrido no aparelho é de primeira classe; a CONFIGURAÇÃO DO ALVO vai ao stakeholder) · **Plano:** `melhorias/plano-v3.62.0.md`

Origem: item 25 de `note.md`, que absorveu o antigo item 2 e o sub-item do `content-desc` do item 8. Em app híbrido (WebView), o `accept` no alvo `android` não achava nenhum id. As WebViews atuais não publicam o id HTML no `uiautomator`, e o `aria-label` chega como `text`, não como `content-desc`, como medido em campo (Android 15, WebView 124). Por isso, cada Task com cenário no alvo virava decisão do Arquiteto e "prova por outro executor, com desvio registrado".

Decisões do stakeholder em 16/11:
- versão com plano;
- `assert-count` e `assert-order` valem para a **lista inteira**;
- revogada a espera pelo espelho do id no `aria-label`;
- **correção genérica**, para qualquer app híbrido, com o que é de um projeto vindo por configuração.

1. **`targets.android.locator = "cdp"`.** Os verbos de tela (`tap`, `type`, `select`, `slider` e `assert-*`) vão pelo DevTools Protocol da WebView. O ciclo de vida (instalar, `reset`, `seed`, `baseline`, `launch`, `back`, `clock`, `font-scale`, captura) continua no `android.ps1`.
   - **Conexão:** pid do app → socket `webview_devtools_remote_<pid>` → `adb forward tcp:0`. A porta é livre e escolhida pelo `adb`, nunca a 9222, que é também a do Chrome headless do Karma.
   - **Forward:** é refeito quando o pid muda e removido no fim do `accept` e pelo `target.ps1 -Kill`.
   - **Chamadas:** uma chamada do Node por passo, com prazo (`targets.android.cdp.stepTimeoutSec`, e `callTimeoutMs` em cada chamada CDP). Medido: **368 ms por passo** (30 passos, Chromium de desktop), dentro do orçamento de 0,5 s do plano. O modo "cenário inteiro" não foi construído.
   - **Configuração por projeto** (`targets.android.cdp`): `pageUrl` (regex da página do app no `/json`), `readyExpr` (app pronto depois de abrir), `failExpr` (tela de falha do próprio app → FALHOU), `hiddenScopes` (áreas do DOM fora da tela, como páginas em cache), `readyTimeoutSec`, `stepTimeoutSec`, `callTimeoutMs`. Nenhum app id, rota, seletor nem framework fixo no plugin.
   - **Node 22+** (`fetch` e `WebSocket` globais), CDP cru, sem dependência. O executor nunca chama `Page.navigate`.
2. **Uma implementação dos verbos de tela para todo alvo que fala CDP** (`targets/cdp-verbs.js`) e uma leitura do DOM (`targets/dom-probe.js`):
   - o `web-runner.js` usa os mesmos verbos pela sessão CDP do Playwright, com clique de mouse;
   - o `android-cdp.js` usa a WebView, com toque por dedo;
   - a semântica está escrita uma vez em `standards/scenario-language.md` (novo).
3. **CONFIGURAÇÃO DO ALVO** (`accept` exit 4, campo `configuration` no `result.json`, mensagem que diz o que corrigir):
   - APK sem a depuração da WebView (nomeia o `android.webContentsDebuggingEnabled` do Capacitor e o `WebView.setWebContentsDebuggingEnabled` dos demais);
   - Node < 22;
   - mais de uma página sem `cdp.pageUrl`;
   - com o `uiautomator`, a tela do app ser uma WebView sem nenhum id do app. Isso é conferido **antes do 1º cenário** e substitui o `Test-IdsHidden` / IDS NÃO PUBLICADOS da v3.57.1, que só disparava depois de 2 cenários falharem.

   O `run.ps1 done -Result env` leva a configuração ao stakeholder: 🔴 "configuração do alvo", rota `configuracao-do-alvo`, sem reparo, sem dev, sem Arquiteto e sem reabertura automática. O `run.deviceProofFallback` não se aplica a ela. Um `result.json` antigo com IDS NÃO PUBLICADOS é lido como configuração.
4. **Remendos retirados:**
   - o comentário C2 do `android.ps1` (o id HTML "chega como resource-id puro"), que é falso;
   - o recurso ao `content-desc` no `Find` (v3.57.1);
   - o texto "outro executor, com desvio registrado" do `accept`;
   - o ramo IDS NÃO PUBLICADOS do `run.ps1`;
   - no modelo `guards.json`, o nome de container de um projeto, que virou `meu-emulador`.
5. **Mudança visível para projetos existentes**, que é correção de semântica (§4 do plano):
   - no `web`, `assert-absent` não conta elemento não renderizado; id repetido vale pelo primeiro renderizado; `type` em web component acha o campo interno; `tap` faz hit-test e reprova toque coberto;
   - no `android/uiautomator`, `type` **substitui** o valor (`MOVE_END` + `DEL` × tamanho + texto, antes inseria no cursor) e recusa texto fora do ASCII com o motivo, em vez de corrompê-lo calado.

6. **Decisões do stakeholder no fecho (formulário de 16/11):**
   - **Guia e rituais:** o `how-to.md` ensina o `locator: "cdp"` e a CONFIGURAÇÃO DO ALVO. O `rituals/team-init.md` o propõe para stack híbrida. O `rituals/team-update.md` ganhou o passo **7o**, que propõe o `locator` ao projeto híbrido existente sem gravar sem o formulário.
   - **Tela do próprio Android com `cdp`:** é provada por teste (`standards/scenario-language.md` §3). O modo misto é o item 26 de `note.md`.
   - **Nome de projeto como procedência:** neutralizado para "projeto piloto" nos documentos do plugin (97 menções). Os changelogs e os comentários de script ficam como histórico.

**Testes novos:**
- `tests/parity.js`, com a página neutra `tests/fixtures/parity/index.html` e 15 cenários em `parity.scn`. Cobre: `type` em campo com texto, web component com `textarea` em shadow root, página em cache com id repetido, `display: contents`, camada cobrindo o toque, lista de 40 itens fora da janela, faixa horizontal, `select` nativo e de botões, `slider`, texto fora do ASCII, `display: none`, `checkbox` e id inexistente. Roda pelo CDP num Edge/Chrome headless com toque emulado (o caminho do `locator: cdp`, sem emulador) e pelo `web-runner.js` quando `PARITY_PLAYWRIGHT_ROOT` resolve o Playwright. Medido em 3 rodadas seguidas: **cdp 15/15 · web 15/15**. Na suíte, sem Playwright, o web sai NÃO EXECUTADO, nunca verde.
- No `run-check-tests.ps1`:
  - localizador CDP (pid, socket, forward `tcp:0`, mesmo pid não refaz, pid novo refaz, limpeza só deste aparelho);
  - configuração com os padrões;
  - socket ausente = CONFIGURAÇÃO;
  - app fechado = falha do passo;
  - `Test-HybridWithoutIds`;
  - `type` do `uiautomator`;
  - `Find` sem `content-desc`;
  - `accept` parado na configuração (exit 4 e `configuration`);
  - `done -Result env` com `configuration` e com o IDS NÃO PUBLICADOS antigo;
  - `deviceProofFallback` sem efeito sobre a configuração;
  - o caso `ocultos` agora é ESTADO DE PARTIDA.

**Medido no desktop:** Edge headless não rola a página na vertical por gesto de toque (`dispatchTouchEvent` nem `synthesizeScrollGesture`), mas rola pela roda do mouse. A rolagem tenta, em ordem, gesto do sistema (`adb`, no aparelho) → arrasto → gesto sintetizado → roda, e confere a posição.

**Não testado em sessão real:** o `locator: cdp` num emulador com um app híbrido de verdade. O critério de campo está no plano, §7: `accept -Target android` com `type` que substitui e `assert-contains` lido do campo, `run.ps1 done` fechando pelo `result.json` sem decisão do Arquiteto, nenhum `NÃO EXERCITADA (ambiente)` por id e um id dinâmico confirmado em execução (o antigo item 2).

## v3.61.0 — 2026-11-16

**Branch:** `feat/v3.61.0` a partir de `develop` (`586731b`, v3.60.1 mesclada) · **Processo:** v3.61 (sprint 0: o backlog funcional abre sobre documentação conforme e ambiente de testes provado)

Origem: o stakeholder perguntou, em 16/11/2026, como usar QA, Sec, Arquiteto e PO em tarefas avulsas e propôs: "o processo de onboarding [é] o questionamento da onde está a documentação; se não existir, propor criá-la disparando uma atividade de sprint 0 … com a criação da documentação e do ambiente de testes; se existir, o sprint 0 irá revisá-la e adequá-la aos pontos de boas práticas … e somente assim iniciar um backlog funcional". A avaliação trouxe cinco ajustes, que ele aceitou: liberar por área, régua verificável, documentar como é (sem refatorar), ambiente com condição de pronto objetiva e mecânica própria.

1. **O onboarding decide o sprint 0** (`workflow-ritos.md` §5a, passo 3). `foundation.ps1 assess` classifica cada documento do SDD (`00`–`06`) e cada frente do ambiente como **ausente · fora do padrão · conforme**, e o projeto como **retomada** (há código) ou **novo**. Com código, o caminho é o sprint 0; sem código e sem documentação, o brainstorm. Dispensar é decisão do stakeholder, com o risco registrado.
2. **`/sm sprint0 plan · run · review · area <área>`** (`workflow-sprint0.md`, novo), guiado por `scripts/checks/foundation.ps1`:
   - `plan`: o quadro `sprints/0/foundation.md` com um item por documento (criar ou revisar contra o código) e por frente de ambiente, e **um formulário de escopo**: as áreas da 1ª onda e a autorização para a sessão gravar o `guards.json`;
   - `run`: laço `foundation.ps1 next`. PO (`00`–`02`, `06`) e Arquiteto (`03`–`05`) escrevem o sistema **como ele é**. Cada documento fecha com a **régua** e com o ✅ do QA em `evidence/conformance.md` (régua + amostra `arquivo:linha` + verificabilidade). Ambiente: plano do Arquiteto, o dev pelo escopo da G9, a sessão grava o `guards.json` proposto, depois baseline refeita e um cenário ponta a ponta rodado no alvo. Três devoluções levam o item a 🔴;
   - `review`: o PO apresenta o que mudou, os achados e a dívida (já como itens do backlog); **um formulário de aceite**; `foundation.ps1 close` só grava com a régua completa ok;
   - `area`: reabre só a área que o backlog vai tocar (`01`, `02`, `04`, `05`), sem fechar o backlog das áreas já documentadas.
3. **A régua** (`foundation.ps1 check [-Item]`):
   - `00` com `OBJ-nnn` e "Como saberemos";
   - todo `RF` com critério de aceite e "Como verificar", e todo `RNF` com "Como verificar";
   - `02` com papel, fluxo e "Pontos de falha";
   - `03` com índice, `P-nnn` com consequência observável e a Ficha de Vinculação de Stack V1–V22 com valor em toda linha;
   - `04` com entidades e relacionamentos;
   - `05` com contrato de erro, ou "não se aplica — <motivo>";
   - `06` com uma versão e o índice do SDD;
   - `01` e `02` citam as áreas do escopo, e nenhum documento guarda marcador do modelo;
   - ambiente: `verify.suite`, `run.prereqs` no ar, baseline do sprint 0 e cenário ✅ com `sprint 0` no Histórico;
   - o documento com o nome do projeto (`requirements.md`, `architecture.md`, `api-spec.md`) é achado e revisado onde está, sem renomear, e a linha diz o nome do modelo; ID com área (`RF-CAN-01`) vale.
4. **G25** (`hooks/prompt-submit.ps1`): bloqueia `/sm sprint prepare` e `plan` quando a linha `Sprint 0 (fundação)` do `README.md` §2 existe e não diz **concluído** nem **dispensado**. O motivo e o caminho vão ao stakeholder, e o prompt não chega ao modelo. Projeto sem a linha (anterior à v3.61.0, como o garden) fica como está. A G21 passa a conhecer `sm sprint0 <modo>`.
5. **C2 (`project.ps1`)**: a linha R35 reprova sprint funcional com pacote aprovado e o sprint 0 exigido. A R15 deixa de cobrar o ① dos `03`–`05` aceitos no sprint 0.
6. **R35 nova e R14 ajustada** (`working-rules.md`, índice). No `prepare`, passo 1, a candidata precisa cair numa área documentada, e o requisito aceito no sprint 0 vale como ① e ②.

- Modelos novos: `templates/foundation.md` (SM), `quality-assurance/templates/conformance.md`, `architect/templates/foundation-env-plan.md`.
- Documentos: `commands/sm.md` (modo e pré-condições), `project-context.md` (§2, §8 e "Por onde começar"), `artifact-ownership.md` §1e, `deliverables/team-project/README.md` (a pasta do sprint 0), `workflow-sprint.md`, `team-update.md` (7n: projeto em andamento não ganha a linha; adotar é `/sm sprint0 plan`), `how-to.md` (cenários A e B), `README.md`, `hooks/COVERAGE.md`.
- Testes de conferência (+24): o `assess`; o `init` com a linha no README; o portão antes e depois; o formulário do escopo sem disparo; o dono disparado com o modelo e a régua; devolução pela régua e pelo QA; a Ficha com marcador; os 7 documentos em laço; o plano de ambiente, o escopo do dev gravado e apagado; o `guards.json` pela sessão; baseline e cenário; o `close` sem `-By` e com a régua ok; a `area`; o documento com o nome do projeto e os requisitos em lista; e o C2 R35 (concluído, sprint aberto sem o sprint 0, dispensado).
- Testes de guarda (+9): a G25 com o sprint 0 exigido, com o marcador do modelo, concluído, dispensado, desligada, sem a linha, e o `sprint run` fora dela.
- Suítes: 568 conferências (com 23 dos casos novos) e 356 guardas, nenhuma falha; o 24º caso (nomes do projeto e README em CRLF) rodou no bloco do sprint 0, 24 de 24; `release.ps1` (C3) ok.
- Correções durante a entrega:
  - "Não se aplica — o app é offline" não passava no `05`, porque a regex pedia três letras seguidas depois do travessão. O teste de fumaça pegou.
  - O `assess` rodado no garden (só leitura) dava os sete documentos como ausentes: o SDD dele existe, com nomes sem número. Agora o script acha o documento pelo assunto. A V12 da Ficha saía "sem valor" por causa de `<commit-base>` dentro de crases; código entre crases deixou de contar como marcador. Os "84 requisitos em lista sem seção própria" do `requirements.md` e a falta da V22, do índice e dos princípios `P-nnn` no `architecture.md` são achados reais.
  - As regex de fim de linha ([^\r\n]*$) não casavam numa linha terminada em CRLF, e o README de projeto no Windows teria a linha do sprint 0 duplicada em vez de atualizada. Agora a linha é trocada no lugar, com o fim de linha do arquivo; o teste usa README em CRLF.

---

## v3.60.1 — 2026-11-15

**Branch:** `fix/v3.60.1` a partir de `develop` (`6341ae3`, v3.60.0 mesclada) · **Processo:** addendum v3.60.1 (o time decide o que o stakeholder já respondeu)

Origem: análise pedida pelo stakeholder em 15/11/2026 das paradas do sprint 6 do garden que esperaram por ele ("quais ainda podem ser tratadas para o próprio PO, SM ou Arquiteto tomarem as decisões"), e depois "pode aplicar as propostas". Depois da v3.58.3, ainda subiram ao stakeholder:
- a prova no aparelho que não roda, 4 vezes com a mesma resposta;
- a mesma decisão duas vezes na T-090, porque ela não chegou ao plano;
- "arquivos soltos" de outra Task (T-093), em 3 formulários;
- o Docker desligado, em 4 formulários;
- "encurtar ou dividir" um plano que passou de 30 KB por causa das decisões de GAP;
- a pausa, que acabou com o `.active-run` apagado pelo Explorador.

1. **`run.ps1 prove -Task <T> -By <quem> -Because <motivo>`: a decisão "provar por teste" é aplicada inteira pelo script.**
   - Os cenários de tela viram `(teste)` na linha **Cenários:** do plano (que manda desde a v3.56.0) e na coluna do quadro.
   - O plano ganha a linha **Prova no aparelho pendente:**, e a Task entra em `sprints/<n>/device-pending.md`. O prompt do QA na validação do sprint passa a citar essa lista.
   - A Task em 🔴 volta a 🟨 e a rota ao stakeholder é apagada. A saída manda fechar com `run.ps1 done -Result ok`.
2. **Política do projeto: `guards.json` → `run.deviceProofFallback: "teste"`.** Quando o accept para em IDS NÃO PUBLICADOS ou no ESTADO DE PARTIDA, o `done -Result env` aplica o `prove` sozinho, sem formulário e sem 🔴. Sem a chave, a decisão continua com o stakeholder, e a saída manda oferecer, no mesmo formulário, gravar a política.
3. **Fim do laço "evidência incompleta" da T-090.** Quando o único reprovado do close é o R7-aceite, com o accept parado no estado de partida na árvore de agora, o `done -Result ok` vai à rota de ambiente (item 2), em vez de mandar outro dev rodar o mesmo accept.
4. **As decisões de 🔺 GAP não contam para o teto de 30 KB do plano** (`Get-PlanCoreKb`), no `plan.ps1` (regra 22) e no `run.ps1 start`/`next`. A linha do tamanho diz quantos KB ficaram fora. A Task já construída não vai à divisão nem ao stakeholder por crescer com as decisões.
5. **Arquivos alheios.** Na primeira vez da Task, antes do relatório do dev, o `run.ps1 start` grava em `handoff/<T-ID>-alheios.json` o hash de cada arquivo pendente no git.
   - O R7-margem do `close.ps1` ignora o arquivo que segue com o mesmo hash. Se a Task mexer nele depois, a cobrança volta.
   - A saída do start lista os alheios.
6. **Pré-requisitos do ambiente: `guards.json` → `run.prereqs`** (`name`, `check`, `start`, `waitSec`).
   - O `run.ps1 start` confere cada um antes do dev. O que não responde, ele sobe pelo `start` e espera o `check` passar.
   - Só o que não sobe vai ao stakeholder, pela rota de ambiente.
   - O modelo do `guards.json` traz o exemplo do Docker Desktop.
7. **`run.ps1 pause -Because <motivo>`.** Apaga o `.active-run`, o `.ask-route` e o `.safe-point`, registra a pausa no run-log e diz como retomar. A parada (d)/(e) do `sprint-run.md` passa a usar o comando.
8. **G24: uma pergunta por rota.**
   - O primeiro formulário marca a rota como `usado`. As refações nos 10 minutos seguintes passam (a G3 recusou a forma).
   - Outra pergunta é negada com o caminho: aplicar a resposta (`prove`, `mark`, `next`) ou `pause`.
   - A mensagem de negação ganha os caminhos novos: `prove`, arquivos alheios e id dinâmico declarado no código pelo Arquiteto.
9. **O `/team update` não retoma o run** (`team-update.md`, passo 9). Termina dizendo para reiniciar e digitar `/sm sprint run`, sem perguntar "retomar agora?".
10. **O reinício por teto de contexto avisa que é ponto seguro para atualizar o plugin** (linha PARA O STAKEHOLDER).

- Documentos: `stakeholder-question.md` (oito linhas novas em "a decisão é dele?"), `sprint-run.md` (paradas legítimas, pausa segura, G24), `team-update.md`, `deliverables/team-project/guards.json` (`run.deviceProofFallback`, `run.prereqs`).
- Fica com o stakeholder: liberar comando novo em `runCommands`. É fronteira de segurança, porque o comando roda sem pedido de permissão. O id dinâmico deixa de precisar do `guards.json`: o Arquiteto o declara no código (`// testid-dinamico:`), que o `ids` já aceitava.
- Testes de conferência (+9):
  - o teto sem as decisões (passa com 27 + 4 KB; reprova com 31 + 4);
  - o `prove`: plano, quadro, lista da validação, 🔴 → 🟨 e rota apagada; rodar de novo não duplica nada;
  - a política no `done -Result env`, sem formulário nem 🔴;
  - o `pause`;
  - os arquivos alheios: ignorado quando segue igual, cobrado de novo quando muda;
  - o `run.prereqs`, que sobe pelo `start` e falha com o motivo quando não há `start`.
- Testes de guarda (+2): a rota marcada como usada no primeiro formulário; outra pergunta com a rota já usada é negada.
- Suítes: 545 conferências e 347 guardas, nenhuma falha; `release.ps1` (C3) ok.
- Correção durante a entrega: o parâmetro do motivo se chama `-Because`. Como `-Why`, ele colidia com a variável `$why` do `next`, e o PowerShell não diferencia maiúsculas: o motivo do "alvo ainda fora" saía como uma letra só. O caso 9c da suíte pegou.

---

## v3.60.0 — 2026-11-15

**Branch:** `feat/v3.60.0` a partir de `develop` (`119077f`, v3.59.2 mesclada) · **Processo:** v3.60 (a ficha leva os trechos; o Arquiteto do plano lê uma vez e escreve · o kanban acompanha o prazo, com o registro técnico no consumo)

Origem: pergunta do stakeholder em 14/11/2026 sobre a H-M do garden, dividida em 3 Tasks, e o pedido seguinte: manter a divisão para o dev em Haiku e otimizar o Arquiteto. Medido nas conversas dos 3 Arquitetos do plano (sprint 6, US$ 9,02): 84 % do custo e 111 de 125 chamadas foram exploração antes do primeiro `Write`. A simulação calibrada nessas conversas apontou um Arquiteto por Task com os trechos prontos (≈ US$ 5,7, entre 4,4 e 6,9). Um Arquiteto para a História inteira saiu mais caro em todos os cenários (até US$ 13,6 explorando; 25 a 35 % acima com os trechos).

1. **A ficha leva os trechos.** O `run.ps1 next` copia para o recorte da ficha (`sprints/<n>/handoff/<T-ID>-ficha.md`) os trechos que ela aponta, com o número da linha:
   - **Código a ler:** aceita `caminho:a-b`, com faixas extras do mesmo arquivo na linha (`:c-d`, `:e`). `caminho:linha` copia 40 linhas a partir de 5 antes; `caminho` sozinho copia o arquivo inteiro só até 150 linhas.
   - **Fontes:** aceita `§2.5`, `§2–§7` e `§"título"`. O script copia a seção pelo título do markdown, ignorando os títulos que estão dentro de bloco de código.
   - Faixas sobrepostas se juntam num bloco por arquivo. O teto dos trechos é de 60 KB; o que passar vira nota "não copiado", com o motivo.
2. **Guia de escrita gerado do template.** O recorte traz a introdução, o esqueleto inteiro e a primeira frase de cada regra, com a linha dela no `implementation-plan.md`, mais a variante leve. São 19,5 mil caracteres, contra 34,8 mil do template. Não existe segunda cópia: se o template perder as marcas de forma, o guia sai vazio e o prompt volta ao de antes.
3. **Prompt do Arquiteto do plano.** Ele abre a ficha e o `context.md` na mesma chamada e escreve a partir deles. Não abre o template inteiro nem relê arquivo já copiado; o que faltar pede numa chamada só, em paralelo e no trecho, e registra em `**Li além da ficha:**`.
4. **Faixa fora do arquivo se corrige antes do plano**, como o caminho que não existe: o Arquiteto, numa instância curta, acha o trecho com Grep e escreve a faixa nova.
5. **As linhas da ficha andam com o código** (pergunta do stakeholder em 15/11: "uma tarefa pode modificar o código e assim as referências irão quebrar"). A ficha é escrita na Planning, e as Tasks das Histórias anteriores mudam o código antes do plano. No garden, S6, 6 de 60 faixas tinham andado: `migracoes.ts:1131` desceu 80 linhas com a T-089, e `plantio-form.page.ts` desceu 24 com a T-087.
   - O `run.ps1 next` traduz cada faixa pelo `git diff -U0` contra o disco. A base é o último commit antes da 1ª linha do `run-log.md`; para a ficha corrigida no run, é o commit da correção, gravado em `sprints/<n>/.ficha-base.json`.
   - O trecho é copiado no lugar novo, e o cabeçalho diz quanto andou e por qual Task (pela mensagem do commit).
   - Se o próprio trecho mudou, o script copia o de hoje e marca ⚠ para o plano conferir.
   - Seção (`§`) se acha pelo título, sem depender de linha. Sem git, as linhas valem como estão.
   - Conferido no garden: as 17 linhas da H-M que não mudaram caem no mesmo código hoje (deslocamentos de até 80); as 2 que a T-092 alterou saem com ⚠.

- Documentos: `breakdown.md` (abertura e regras 2, 3 e 6), `implementation-plan.md` (regra 28), `agents/architect.md`, `roles/architect/README.md`, `workflow-sprint.md` (Planning, passo 4), `sprint-run.md` (indicador). A entrada v3.57 do changelog do processo foi arquivada sem alteração.
- Testes: as conferências do recorte (5d2) passam a cobrir a faixa fora do arquivo, os trechos numerados, a seção do SDD com a subseção, o standard do plugin, a faixa exata com a faixa extra na linha e o guia, que é menor que o template e não traz o exemplo. Num projeto com git, cobrem ainda: a faixa deslocada por um commit de outra Task, o trecho alterado (⚠), a correção que grava a base e a ficha corrigida, que não é deslocada de novo. Nos quatro cenários do pacote externo, o `src/a.ts` de 1 linha passou a ter 3, porque a ficha aponta a linha 3. Pacote externo: +2 testes (os trechos na ficha do pacote; a faixa fora do arquivo antes do pacote).
- Testes do acompanhamento (+7): as quatro seções vão ao `consumption.md`; a previsão de cada parte (74 h por dia estimado no caso de teste); o farol Adiantado e o Atrasado, com o "agora" fixo (`TEAM_SCHEDULE_NOW`); o Mermaid e a tabela; o `mark.ps1` e a R24 do `close.ps1 -Post` no `consumption.md`. Três testes antigos passam a ler o `consumption.md`. O do `-Init` tira o arquivo do caminho em vez de apagá-lo. Suítes: 536 conferências e 345 guardas, nenhuma falha; `release.ps1` (C3) ok.

6. **Plano externo também** (pergunta do stakeholder em 15/11: "essa mudança não afeta o planejador externo?"). O pacote levava a ficha com as linhas da Planning e os arquivos de hoje em `files/`, e o roteiro mandava ler "o trecho que a ficha aponta". No caso da T-092, isso abriria `migracoes.ts` 80 linhas acima do código certo.
   - A ficha do pacote ganha os mesmos trechos, nas linhas de hoje, com o deslocamento e o ⚠.
   - O roteiro (`external-plan.md`, passo 2) manda citar as linhas dos trechos e ler em `files/` só o que faltar.
   - A faixa fora do arquivo volta à correção da ficha antes de o pacote ser montado.
   - O modelo do plano continua indo inteiro, porque o planejador externo não gasta a cota da conta.

**Acompanhamento do sprint (pedido do stakeholder em 15/11, na mesma entrega):**

7. **O kanban.md fica para acompanhar.** A **Série**, o **Registro de transições**, a **Rodada a rodada** e a **Espera de comando** passam ao `consumption.md` do sprint. No garden, S6, o `kanban.md` caiu de 85 KB para 12 KB.
   - A Série e o Registro continuam nascendo na Planning (linha 0) e vão para lá na primeira regravação do `kanban.ps1` no `sprint run`. Isso vale também para sprint já aberto, uma vez e sob as duas travas.
   - Todo script que lê ou grava esses dados (`mark`, `close`, `kanban`, `plain`, `team-view`, `run`, R24) os acha onde estiverem (`Get-RecordPath`).
   - O `consumption.ps1` passa a regravar sob a trava do arquivo, e o `## Registro` dele não confunde mais o Registro de transições.
   - Os Bloqueios continuam no `kanban.md`.
   - **Atenção:** a partir daqui, o `consumption.md` de um sprint aberto guarda o histórico do burndown. Apagá-lo (para recriar o consumo, por exemplo) apaga a Série e o Registro. O `kanban.ps1 -Init` só o cria quando falta e nunca o sobrescreve.
8. **Previsão de cada parte e do sprint, com farol.** O ritmo é medido no próprio sprint: horas de relógio desde a abertura ÷ unidades estimadas prontas.
   - Cada parte aberta no Kanban mostra "falta ~3,8 h · termina por volta de 15/11 às 15:50", na ordem da fila. A que está em construção desconta o tempo que já correu.
   - O Resumo (e o `/team-status`) ganha a linha **Prazo**: 🟢 No prazo · 🔴 Atrasado · 🔵 Adiantado, com a previsão de término.
   - O prazo vem, nesta ordem, do fim da Janela, da duração do sprint no README ou, com a estimativa em dias, da própria estimativa (o garden não tem data fixa).
   - Previsão depois do prazo é atraso. Folga acima de 15 % da janela é adiantamento. Sem parte pronta não há ritmo (⚪).
9. **Burndown visual.** Nova seção `## Burndown` no `kanban.md`, logo depois do Kanban, com o farol e o ritmo.
   - O gráfico é um Mermaid xychart: a linha real em azul (`#2a78d6`, primeira cor da paleta validada) e a ideal em cinza, do planejado a zero no prazo. Como o xychart não tem legenda própria, ela vai em texto acima.
   - Uma tabela traz a mesma conta (restante, ideal e uma barra por dia), que se lê no terminal e serve de versão acessível.
   - O ponto de hoje usa o restante do quadro. No garden, a Série marcava 0 com 2 partes abertas.
   - Conferido numa cópia do garden: 🔵 Adiantado, previsão 15/11 às 21:30 contra o prazo de 25/11 pela estimativa; o `consumption.ps1` e o `mark.ps1` gravaram no lugar novo.

Não muda: o dev recebe uma Task por vez, com até 6 arquivos; a Task sem ficha segue planejada numa instância por História.

---

## v3.59.2 — 2026-11-14

**Branch:** `fix/v3.59.2` a partir de `develop` (`b63e828`, v3.59.1 mesclada) · **Processo:** addendum v3.59.2 (R12: a consolidação dos documentos vivos é conferida, chega aos donos e é versionada)

Origem: pergunta do stakeholder em 14/11/2026, "toda tarefa gera a atualização do SDD? Quem faz? Sempre a documentação está atualizada?", e depois "faça as três correções no plugin". Medido no garden:
- a consolidação do sprint 5 está "feita" desde 09/11, mas `architecture.md`, `data-model.md` e os ADRs 0001 e 0011 continuam sem commit;
- a parte do `api-spec.md` entrou no commit da T-079;
- os 4 pedidos ao PO nunca foram aplicados. O `requirements.md` não muda desde 31/10, e o RF-MAN-02 ainda diz "um canteiro por vez", com o manejo em vários canteiros construído no sprint 5.

A Review conferia só a linha `**Estado:** feita`.

1. **"Feita" conferida no git.** O `run.ps1 next` lê a tabela `## Aplicado pelo Arquiteto`, no modelo novo `roles/architect/templates/docs-consolidation.md`. Cada documento citado precisa ter alteração pendente ou commit desde a 1ª linha do `run-log.md`. Sem mudança, o Arquiteto volta uma vez para aplicar ou mover para `## Sem mudança`; depois disso, vira pendência da Review. Um registro fora do modelo também leva o Arquiteto a reescrevê-lo, uma vez.
2. **Pedidos aos donos disparados.** A tabela `## Pedidos aos donos` leva cada dono (PO, UX, SM, QA) a ser disparado uma vez, com os documentos dele. "Aplicado" quer dizer que a impressão do documento (`git hash-object`) mudou desde que o pedido apareceu. O pedido não aplicado vai ao formulário da Review e ao `run-log.md`.
3. **Commit próprio da consolidação.** O script versiona só os documentos das duas tabelas, nunca `.team-project/`, em `docs(sdd): consolidação dos documentos vivos do sprint <n>`, separado dos commits das Tasks. O Arquiteto e os donos não fazem commit.
- O estado mecânico fica em `sprints/<n>/.docs-check.json` (do script), e cada passo acontece uma vez só.
- Testes: conferências +7 (fora do modelo, documento sem mudança, PO, SM, commit com a pendência na Review, sem repetição).

Não muda: a consolidação continua uma vez por sprint, no fim do `sprint run` (o SDD fica até um sprint atrás do código durante o sprint), e a trilha `fix` segue o ciclo de antes.

---

## v3.59.1 — 2026-11-14

**Branch:** `fix/v3.59.1` a partir de `develop` (`dc583d0`, v3.59.0 mesclada) · **Processo:** sem mudança de regra (correção do registro de agentes e do `verify` full)

Origem: análise do stakeholder em 14/11/2026 sobre "a Task demora muito para fechar", medida no sprint 6 do garden. A T-069b levou 77 min para 3 arquivos. Dois defeitos do registro de agentes custaram 32 min nela, e o `verify` full repetia a suíte de 10 a 25 min sem necessidade.

- **Executor "aguardando filho" de um dev que já tinha parado** (T-069b, 19:27–19:47: 20 min parados, 4 watchers seguidos). O `.active-agents` era lido, alterado e regravado por vários hooks ao mesmo tempo, sem trava. Às 19:25:26, a SubagentStop do dev e a PreToolUse do executor rodaram no mesmo segundo, e o dev voltou ao registro. O executor, ao parar de vez, ficou "aguardando filho", e o `run.ps1 next` esperou os 20 min do prazo. Depois, às 19:56, a parada de outro executor casou o velho pelo tipo e o remarcou com hora nova. Correção em `hooks/common.ps1`:
  - mutex nomeado por projeto em toda leitura-e-gravação do registro;
  - a remoção pelo tipo só toca registro ainda sem `agent_id`;
  - filho cuja última linha do `usage.jsonl` é posterior ao último sinal dele já parou: não segura o pai e sai junto;
  - no `Get-LiveAgents`, "aguardando filho" sem filho de rodada aberta vale só nos 3 min depois do fim do último filho. A exceção é o filho que parou com `ESPERANDO <comando>`: a SubagentStop grava `waiting: true` na linha dele, e o pai segue vivo como antes, porque o comando em segundo plano ainda acorda o filho.
- **Dois executores na mesma Task** (T-069b, 19:15–19:27). O dev encerrou o turno esperando o verify em segundo plano e saiu do registro. Acordado pelo fim do comando, voltou a agir fora do registro. O executor parou sem filho, o `run.ps1 next` não viu ninguém e mandou um segundo executor; os dois abriram GAPs em paralelo. Agora a primeira ação de um `agent_id` que já tem rodada no `usage.jsonl` o devolve ao registro, com a descrição, o item e o pai (`Update-ActiveAgent`, a PreToolUse passa o `session_id`).
- **`verify -Mode full` sem repetir a suíte à toa.** No garden, a suíte executa 2.935 testes em ~10 min (execução, não compilação). O sprint 6 teve 35 rodadas em 13 Tasks, ~950 min de verify. Mudanças em `scripts/checks/verify.ps1`:
  - build, lint, comando do plano e **ids de teste** rodam antes da suíte. Um deles reprovado, a suíte e a cobertura não rodam ("não rodou: …"). Na T-081, a suíte de 620 s rodou e o full reprovou só pelo testids;
  - full de novo na **mesma árvore e com o mesmo comando** reaproveita os comandos que saíram verdes e roda só os que falharam; a suíte que roda de novo leva a cobertura junto. Isso cobre o dev em instância nova só para a evidência e a segunda rodada do K-12, que antes refazia build e lint;
  - `-Fresh` roda tudo; o `result.json` grava `reused`, `reused_from` e `skipped`.
- Testes: guardas +5 (registro), conferências +9 (next com o filho parado há 6 min, há 1 min e com `ESPERANDO`; full com falha curta, reaproveitamento, check, `-Fresh`, árvore nova).
- Medido no sprint 6, o que a entrega teria poupado:
  - reaproveitamento na mesma árvore: a T-069a rodou 5 suítes sobre a mesma árvore (69 min), a T-079 3 verdes (41 min), e a T-081, a T-089, a T-092 e a T-067 também repetiram full verde. Estimativa de 130 a 150 min dos ~950 de verify;
  - registro de agentes: 20 a 40 min de espera parada (T-069b, T-089) e o único executor duplicado do sprint.

Não muda: o tempo de cada rodada da suíte (é do projeto) nem a instabilidade dos specs de Manejo que reprovavam em rodadas diferentes (K-12).

---

## v3.59.0 — 2026-11-14

**Branch:** `feat/v3.59.0` a partir de `develop` (`3d84ae5`, v3.58.4 mesclada) · **Processo:** v3.59 (a fala da sessão no `sprint run`, a ordem do `kanban.md`, a coluna **Para o stakeholder** na Planning)

Origem: pedido do stakeholder em 14/11/2026: "frases de conversação e posicionamento na sessão do orquestrador e no kanban … simples e mais diretas, que deem clareza do que está acontecendo para alguém de negócio entender, sem termos técnicos, que podem ser solicitados caso necessário". A avaliação foi aprovada por inteiro. Medido no sprint 6 do garden:
- o quadro do `kanban.md` mostrava só códigos (`T-069b`, `T-070a`);
- os bloqueios e as decisões ficavam no fim de 58 KB, depois das tabelas de tokens;
- o "## Agora" chegou a mostrar `QA | — | trabalhando`;
- o `/team-status` mostrava a T-069a "em execução" e PARADA, e na mesma tela "Fechada". Também contava "131 decisões" esperando o stakeholder, 98 delas já resolvidas;
- a sessão repetia o vocabulário do `run.ps1 next` (PRÓXIMA AÇÃO, R12, `.scn`, executor de Task, GAP).

Mudanças:
- **`scripts/checks/plain.ps1` (novo):** fonte única das frases para quem acompanha. Dá o nome de cada parte do sprint pela ordem: a coluna **Para o stakeholder** do quadro; sem ela, o título da História, com "parte k de m" quando há mais de uma Task; na correção do portão, "ajustes pedidos na revisão final". O código vai sempre no fim (`Geral: filtro Estado responde ao toque (T-081)`). Também traduz o papel (Desenvolvedor, Coordenador da tarefa, Qualidade (QA)…), a ação, a etapa e o motivo de parada em frase simples. As pendências do README §7 que ainda esperam o stakeholder saem sem as resolvidas, as guardadas, as em andamento e as repetidas.
- **`kanban.md` (`kanban.ps1`):**
  - abre pelo **`## Resumo`**, em palavras simples: objetivo, andamento ("12 de 22 partes prontas, cerca de 51% do trabalho estimado"), o que está em andamento, o que parou e por quê, o que precisa do stakeholder e o que vem a seguir;
  - o quadro passa a ser uma lista por etapa (em construção · em teste · paradas · sendo planejadas · na fila · prontas), com o nome de cada parte;
  - a ordem fica Resumo · Agora · Kanban · Controle · Fechamento. O registro técnico vai para o fim, sob **`## Detalhe técnico`** (Linha de base, Série, Registro de transições, Rodadas). Só se movem seções inteiras: os scripts acham cada uma pelo título, e o conteúdo fica igual (conferido na cópia do sprint 6 do garden: Controle, Série e Registro byte a byte, e a segunda gravação não muda nada).
- **"## Agora" (`hooks/common.ps1`):** coluna "Em quê" com o nome da parte e o papel com nome de gente.
- **`/team-status`:**
  - abre em palavras simples: andamento, quem do time trabalha agora e fazendo o quê, em andamento, parado, o que precisa de você e a seguir, e o quadro com os nomes;
  - `/team-status detalhe` (ou `técnico`, em qualquer ordem com o número do sprint) mostra a visão técnica de antes, respondida pelo hook sem token;
  - corrigido: a Task do registro (`.active-task`) que já está ✅ ou 🔴 não aparece mais "em execução" nem PARADA;
  - corrigido: "Esperando você" não conta mais as pendências resolvidas, guardadas, em andamento ou repetidas.
- **`run.ps1 next`:**
  - cada `PRÓXIMA AÇÃO` vem com a linha **`PARA O STAKEHOLDER:`**, por exemplo "Construindo …", "Planejando …", "Revisão final: …" e "Um teste de … travou; o time vai encerrá-lo e recomeçar sozinho";
  - o que ficou pronto ou parou desde o `next` anterior abre a linha ("Pronto: …", "Parou: … — <motivo>"), uma vez cada, pelo `.team-project/.stakeholder-seen`;
  - a sessão do `sprint run` passa a falar por essa linha, copiada (`sprint-run.md` §Fala ao stakeholder). O técnico só aparece quando o stakeholder pede.
- **`run.ps1 done`:** a Task fechada roda o `dispatch.ps1 -Clear` (passo 8). Antes, dependia de o executor de Task rodá-lo, e foi assim que o registro da T-069a sobrou.
- **Planning (`workflow-sprint.md` §5e passo 4, `templates/sprint-backlog.md`):** o PO escreve, na última coluna do Sprint Backlog (**Para o stakeholder**), o nome de cada Task como quem é de negócio a reconhece no app. A coluna é a última para os scripts que leem o quadro por posição não mudarem. Quadro sem ela: vale o título da História.
- **Textos:** `templates/kanban.md` (estrutura nova), `sprint-run.md` (§Fala ao stakeholder, verificação do SM, passo 8, §Marcador), `commands/sm.md`, `commands/team-status.md`, `how-to.md` (as duas visões do `/team-status` e a fala da sessão), `hooks/COVERAGE.md`.
- **Testes:**
  - `run-check-tests.ps1`: casos novos para a visão simples e o `-Detail`, a Task já ✅ fora de "em execução", as pendências resolvidas e repetidas, a ordem e o Resumo do `kanban.md`, o nome das partes pela coluna, pela História e pela correção do portão, e o `PARA O STAKEHOLDER:` com o "Parou" dito uma vez. Os casos que fixavam os textos antigos foram atualizados;
  - `run-guard-tests.ps1`: `/team-status 7 detalhe` e `/team-status técnico`.

**Não coberto:** o `fix run` segue sem a linha `PARA O STAKEHOLDER:`, porque não passa pelo `run.ps1 next`. O "Precisa de você" mostra as pendências do README §7 como estão escritas: pendência resolvida e não marcada como `[RESOLVIDO …]` continua contando (no garden, 22 abertas, várias já superadas — é a R34 do lado do projeto).

---

## v3.58.4 — 2026-11-14

**Branch:** `fix/v3.58.4` a partir de `develop` (`0519303`, v3.58.3 mesclada) · **Processo:** nenhum (a prova no alvo e o verify seguem os mesmos; muda quando o emulador fica ligado e o que o verify faz com pouca memória)

Origem: sprint 6 do projeto, pedida pelo stakeholder ("o motivo do problema de falta de memória, quais processos estão gerando essa situação"). Às 14:01 de 14/11, o Claude Code encerrou o `verify` full da T-081 em segundo plano, com a sessão ociosa ("stopped because the system is running low on memory"). A suíte do Karma estava no teste **2925 de 2926**, com 9 min 53 s: 10 min perdidos e a Task parada, e o dev não repetiu porque o aviso pede para não repetir. O Windows estava longe do limite de alocação: nenhum evento de falta de memória em 10 dias, e o arquivo de paginação de 22 GB com pico de uso de 179 MB. O que acabou foi a memória física livre.

Medido na máquina, cada etapa isolada: teste focado com pico de 2,0 GB em 24 s · lint 1,6 GB · build 2,3 GB · **suíte com cobertura: 12,8 min, média de 4,4 GB e pico de 6,6 GB** (o Node fica em 1,5 GB e o Chrome cresce de 1,3 para 5,0 GB) · build do APK: a VM do Docker foi de 1,4 para 4,8 GB e só devolveu a memória ~10 min depois · **emulador: 4,1 GB reservados o dia todo**. O `verify` já roda um comando por vez e encerra a árvore de processos de cada um. O que se somava à suíte era o que não é dela: o emulador ligado desde o accept das 11:55, que o primeiro accept da Task seguinte reiniciaria de qualquer jeito (`freshStart`), e a VM do Docker depois do build do APK.

Mudanças:
- **`target.ps1 -Release` (`targets/android.ps1` → `Get-AndroidReleaseBlock`, `Get-LocalEmulatorProcs`, `Stop-AndroidEmulator`):** desliga o emulador local do serial, achado pelo dono da porta do console (`emulator-5554` → 5554), porque o reparo do garden sobe o emulador pelo WMI, fora do registro do `-Kill`. Primeiro tenta `adb emu kill` (20 s); se não sair, encerra a árvore. Também encerra o que o próprio run registrou. Respeita a trava do alvo, então nunca roda no meio de um accept ou de um reparo. Não desliga emulador em container (serial de rede) nem emulador sem `repair`/`avd` declarado, porque o plugin não saberia religá-lo. Nesses casos sai com exit 4 e quem chama segue.
- **`run.ps1 start`:** desliga o emulador que sobrou da Task anterior quando o primeiro accept da Task ainda vai reiniciá-lo, ou quando a Task não tem cenário. Ele fica ligado na retomada de uma Task que já fez o primeiro accept. `targets.android.releaseBetweenTasks: false` desliga o comportamento. O prompt do dev diz para subir o emulador com `target.ps1 -Repair` só quando um comando do projeto precisar do aparelho (instalar o APK).
- **`accept.ps1` (`freshStartMinutes`, padrão 30):** no primeiro accept da Task, um emulador ligado há menos que esse tempo (o `-Repair` do dev, antes do `alvo:apk`) já conta como reiniciado. Sem isso, seriam dois boots (~2 min cada) por Task.
- **`verify.ps1` full, antes da suíte:** com memória física livre abaixo de `verify.minFreeMB` (padrão 6144; `0` desliga), desliga o emulador (`-Release`). Se ainda faltar memória, a suíte roda com uma linha `atenção:` que lista os maiores consumidores, no console e no parcial.
- **Encerramento por memória baixa:** o prompt do dev (`run.ps1 start`) e o `agents/developer.md` autorizam rodar o mesmo comando uma vez de novo. O `verify` full desliga o emulador e continua do parcial. Encerrado de novo, o dev para como exit 4 (ambiente: memória).
- **Textos:** `how-to.md` (emulador desligado durante a construção; memória antes da suíte, com a VM do Docker e o `.wslconfig` como responsabilidade do stakeholder); `deliverables/team-project/guards.json` (`verify.minFreeMB`, `releaseBetweenTasks`, `freshStartMinutes`).
- **Testes (`run-check-tests`):** pré-voo de memória com `TEAM_TEST_FREE_MB` (tenta liberar e avisa; `minFreeMB: 0` desliga; sem alvo android, só o aviso); `target.ps1 -Release` recusando sem reparo, com serial de rede e no alvo web; adaptador (bloqueios, porta do console, `freshStartMinutes`, uptime pelo `/proc/uptime`, porta vazia). Nenhum teste desliga emulador de verdade.

Fica no projeto, fora do plugin: o relatório `html` da cobertura no `karma.conf.js` (o gate só lê `coverage-summary.json` e `lcov.info`) e o crescimento do Chrome ao longo da suíte (H2 da investigação do sprint 5: sobras do Ionic entre os testes).

## v3.58.3 — 2026-11-14

**Branch:** `fix/v3.58.3` a partir de `develop` (`b629732`, v3.58.2 mesclada) · **Processo:** addendum v3.58.3 (R25 c ganha instrumento, a G24; o travamento segue a regra 5 do protocolo de espera; correção do plugin pedida pelo próprio stakeholder sai sem formulário)

Origem: avaliação do sprint 6 do projeto, pedida pelo stakeholder — "questões que poderiam ter sido decididas sozinhas subiram para minha decisão, parando o processo". Nos transcripts de 11/11 a 14/11, **22 formulários** chegaram a ele (sem contar as repetições que a G3 barrou). **12 contrariavam a regra vigente:** o cenário que só se prova por teste, que o `run.ps1` manda marcar "sem formulário"; o nome de teste que falta, que é 🔺 GAP do Arquiteto; a Task bloqueada com a fila andando, que vai ao par PO + Arquiteto (R25 c) — sozinha, a T-089 gerou 6 formulários e ~2h30 de espera por uma linha de teste, duas delas nascidas de uma premissa errada da sessão; "tento de novo?"; "retomo o sprint?" perguntado duas vezes dentro do `/team version`; dois planos para a mesma Task, que a conferência já recusava. **3 seguiam a regra, mas a regra perguntava cedo demais:** o POSSÍVEL TRAVAMENTO da T-067, 3 formulários em 15 min e 2 h parada à espera da resposta. **6 eram atualizações do plugin** (3.57.4 a 3.58.2), todas pedidas pelo próprio stakeholder e respondidas em segundos na opção recomendada. A G3 conferia a forma de cada pergunta; nenhuma guarda conferia se ela cabia na janela de R25 (c).

Mudanças:
- **G24 (nova, `hooks/pre-tool.ps1`):** na sessão que conduz o `sprint run` (a última que rodou `run.ps1 next`, registrada em `.team-project/.run-session` pela própria PreToolUse), o `AskUserQuestion` só passa com `.team-project/.ask-route` gravado há menos de 24 h. A negação diz o caminho do roteiro para cada caso do sprint 6, e a saída para a interrupção do stakeholder: a parada (d) apaga o `.active-run`. Outra sessão no mesmo projeto, a trilha `fix`, os papéis e o projeto com `G24` em `disabled` não passam por ela.
- **`run.ps1` → `.ask-route` (`Set-AskRoute`, `lib.ps1`):** gravada em cada saída que já mandava levar a decisão ao stakeholder — fim da fila (Review), nenhuma Task elegível (bloqueio, depois do degrau 1), GAP de produto, estado de partida e ids não publicados, ambiente sem reparo, vaivém do alvo, SEM AVANÇO, travamento repetido, comandos dos planos (no `next` e no `start`), portão ⚠️. Apagada no `start` e no `construir` do `next`.
- **POSSÍVEL TRAVAMENTO (`run.ps1 next`, regra 5 do protocolo de espera — uma tentativa automática por causa):** na primeira vez da Task, `PRÓXIMA AÇÃO: encerrar e retomar`, com o comando de encerrar só o que o run iniciou (`verify.ps1 -Task <ID> -Kill` ou `target.ps1 -Target <alvo> -Kill`, de `Get-TaskWait → Kill`), linha no `run-log.md` e contador `stall` no `handoff/<ID>.json`, sem formulário. Na segunda, a rota `travamento` e o formulário. Vale também com o agente da Task vivo (antes só o watcher acusava esse caso).
- **SessionStart:** a retomada do run vale quando o pedido da sessão é o comando do run; outro comando faz só o pedido e diz em uma linha que o run segue parado. A linha da conversa ganha: decidida, a pendência sai da §7 na mesma resposta (R34) — no sprint 6, os itens 18 a 23 ficaram lá respondidos, e a sessão seguinte os deu como abertos.
- **`rituals/team-update.md` passo 5:** com o `/team update` digitado pelo stakeholder e todas as entradas da mesma linha com `**Processo:** nenhum`, aplica sem formulário e diz em três linhas o que mudou; processo, migração ou `MINOR` novo mantêm a confirmação.
- **Textos:** `stakeholder-question.md` ganha "Antes de perguntar — a decisão é dele?" (a tabela dos casos do sprint 6); `sprint-run.md` (paradas, item 5 da espera, contrato do watcher); `agents/watcher.md`; R25 e R34 citam a G24 como instrumento; `external-plan.ps1` diz que a devolução recusada não é decisão do stakeholder; `how-to.md` e `hooks/COVERAGE.md` com a G24.
- **Testes:** `run-guard-tests` com 10 casos (a sessão do run registrada, negado sem rota, passa com rota, rota vencida, outra sessão, papel, trilha `fix`, sem `.active-run`, desligada, SessionStart). `run-check-tests`: o travamento da primeira vez encerra sem formulário, o da segunda grava a rota e espera, o "nenhuma Task elegível" grava `bloqueio` e o `construir` apaga a rota.

`agents/watcher.md` e o ritual são do stakeholder: propostos aqui, aplicados com a aprovação do PR.

## v3.58.2 — 2026-11-13

**Branch:** `fix/v3.58.2` a partir de `develop` (`b919e6f`, v3.58.1 mesclada) · **Processo:** nenhum (a prova de falha continua a mesma — linha de base, mutante, restauração byte a byte, árvore igual; muda onde o teste roda)

Origem: sprint 6 do projeto. A mutação da T-086 (6 mutantes, um spec de 9 testes) levou **1029 s** para **~3 s de teste**: o precheck automático rodou o `verify.compile` do projeto (`npx ng build`, ~90 s) uma vez por mutante (~9 min), e a linha de base e cada mutante foram um `ng test --include` **a frio** (~62 s de CLI, bundle webpack e Chrome para 0,3–0,7 s de teste; ~7 min). Medido numa cópia do projeto: com UM Karma em observação (`ng test --watch=true`), trocar o arquivo custa **3–9 s** por mutante e 2–4 s por restauração, com os mesmos veredictos (todo mutante reprovou, toda restauração voltou verde); o mutante que não compila aparece em menos de 1 s (`error TS2304` no webpack, `✘ [ERROR] TS2304:` no esbuild), sem rodada de teste.

Ponta a ponta, com o `verify.ps1` novo numa cópia do projeto: as 6 mutações da T-086 mais uma que não compila em **147 s de parede** (precheck só do trecho, partida do Karma, ~10 s por mutante com a restauração), contra 1029 s para as 6 no sprint. Mesmos veredictos (M1–M6 pegas), o mutante que não compila inconclusivo pelo `TS2304`, a árvore igual, nenhum processo sobrando.

Fora desta entrega: o Karma com o builder esbuild (`builderMode: "application"`) parte a frio em ~19 s contra ~62–86 s, mas não é troca direta no projeto: na suíte inteira, 25 testes caem em `JSZip is not a constructor` (`import * as JSZip` + `new JSZip()`, interop CommonJS mais estrito que o do webpack). Fica como recomendação ao projeto, com a correção do import e uma suíte completa comparando a cobertura com a baseline.

Mudanças:
- **`verify.ps1` → `verify.watch`** (ou `"watch"` num objeto de `verify.focused`): o comando do teste focado em modo de observação, com `{tests}` — string, ou objeto com `command`, `runStart`, `runEnd`, `failed` (regex; os padrões são os do Karma: `Executed N of N` fecha a rodada, `(k FAILED)` ou `ERROR` reprova). Na mutação, as mutações do mesmo teste rodam numa sessão: a 1ª rodada é a linha de base; cada mutante é uma rodada; a restauração dispara outra, que **tem de voltar verde** antes do próximo mutante (senão o "pegou" vira inconclusivo e o resto daquele teste roda a frio). Mutante que não compila: a rodada para no erro e sai inconclusiva, sem esperar o prazo. A observação que não chega à 1ª rodada, estoura o prazo ou perde o runner cai para a frio, com a nota na saída. A sessão nasce pelo `lib.ps1` (`Start-ProjectWatch`, ao lado do `Invoke-ProjectCommand`: a mesma higiene de ambiente, saída em arquivo, o guarda de processo solto do protocolo de espera continua valendo), é registrada em `running.json` (o `-Kill` e a rodada seguinte a encerram se o verify cair) e sai no fim, com a árvore de processos (Node, Chrome). O `result.json` marca `watch: true` nas mutações que rodaram em observação; o log da sessão fica em `mutation-watch-<n>.log`.
- **Precheck automático com tudo em observação:** confere só o trecho único, sem o build de `verify.compile` por mutante — o mutante que não compila aparece na própria rodada, em segundos. O `-Precheck` pedido de propósito segue compilando.
- **Tempo esgotado na mutação a frio é inconclusivo:** o exit 124 do comando que estourou o prazo contava como "o teste reprovou com a regra removida" (`ok`). Os padrões de inconclusivo ganham `TEMPO ESGOTADO:`, `OBSERVAÇÃO ENCERRADA:` e `bundle generation failed`.
- **Documentação:** modelo `deliverables/team-project/guards.json` (`verify.watch` vazio e o exemplo do Karma; `verify.compile` do Angular com `ngc --noEmit`), `standards/stacks/angular/quality.md` e `roles/developer/README.md`.
- **Testes:** `run-check-tests` caso 5d3c — sessão em observação com runner falso (base, mutante pego, mutante que não compila, decorativo, uma sessão, precheck só do trecho, nenhum processo sobrando, `watch` no `result.json`), restauração vermelha (inconclusivo e o resto a frio), observação que não sobe (a frio) e tempo esgotado a frio (inconclusivo).

---

## v3.58.1 — 2026-11-12

**Branch:** `fix/v3.58.1` a partir de `develop` (`e3d3528`, v3.58.0 mesclada) · **Processo:** nenhum (as seis regras do protocolo de espera continuam as mesmas; mudam a constante medida errada, o comando do watcher e o sinal de vida da sonda)

Origem: sprint 6 do projeto. A espera do watcher não esperava. O `run.ps1 wait -For 150` conferia a cada 30 s até 150 s, mais ~0,5–1 s por conferência (`Get-CimInstance`) e a partida do `powershell`: cada chamada durava ~155–170 s. A ferramenta de comando corta em **120 s** sem `timeout` explícito e move a chamada para segundo plano. O roteiro dizia **180 s** ("medido no teste do watcher, 07/11"), e o `-For 150` foi escolhido para caber nesse limite que não existia. Toda chamada estourou, nas três rodadas (`aa041…`, `ab6d…`, `af84…`), e em duas a notificação voltou com `exit code 3` e a saída vazia. O exit 3 só sai da última linha do `wait` (vivo), então o estado era conhecido e só o texto se perdeu; mas o watcher não tinha regra para saída vazia, e a sessão redisparou o watcher em vez de parar.

Junto, a CPU "inconsistente para o mesmo pid" foi medida: o `Get-WaitPulse` soma a CPU dos processos **vivos** da árvore, e o filho que termina leva a dele. No experimento (pai com 6 filhos de ~3 s de CPU cada), a soma oscilou 0,7 → 3,5 → 2,3 → 0,9 → 3,2 → 4,0 s e nunca passou de 4 s dos ~18 s gastos. Um build de filhos curtos (node, gradle, tsc) com 15 min e sem arquivo novo caía em POSSÍVEL TRAVAMENTO falso.

Mudanças:
- **`run.ps1 wait`:** `-For` acima de 90 é cortado para 90 (`$script:waitMaxFor`), e a saída é descarregada antes do `exit`. O exit code é o veredito (0 · 3 · 5).
- **`agents/watcher.md`:** `wait -For 90` com `timeout: 300000`, até 6 chamadas (~9 min, como antes), regra para saída vazia (o exit code decide; outro código = `falha da sonda`), e nunca uma segunda chamada enquanto a anterior está em segundo plano.
- **`sprint-run.md` §Protocolo de espera:** a constante passa a 120 s (e 90 s, o teto do `-For`), o contrato do watcher ganha a linha `falha da sonda` (a sessão redispara uma vez; na segunda seguida, leva ao stakeholder), e o item 5 e o `operator.md` passam de "~3 min" para "~2 min".
- **`lib.ps1` → `Get-WaitPulse`:** um descendente criado há menos de 10 min é sinal de vida (o texto mostra `processo filho novo há N min`). Sem estado: a sonda continua só de leitura. O travamento real do garden (um `adb emu kill` parado 81 min, sem filho novo) segue acusado. Limite: um laço que recria o mesmo filho para sempre nunca cai em travamento, mas ele gasta CPU e anda, e por isso não é a espera parada que a regra caça.
- **Testes:** `run-check-tests` com o caso 12 do `wait` (filho recém-criado, 15 min, CPU baixa = vivo) e uma checagem que amarra o `-For` do watcher ao teto do script, o `timeout` e o roteiro. O `run-guard-tests` libera o comando novo pela G14.

Os `agents/*` são do stakeholder: propostos aqui, aplicados com a aprovação do PR.

## v3.58.0 — 2026-11-12

**Branch:** `feat/v3.58.0` a partir de `develop` (`4ca7a1a`, v3.57.7 mesclada) · **Processo:** v3.58 (SM + Arquiteto + Security Engineer)

Papel novo **Security Engineer** (`/sec`), **sob demanda** — fora da cadência do sprint, não é um dos seis dos rituais. Três modos de engajamento, cada um com seu playbook em `roles/security-engineer/playbooks/`: `blackbox` (pentest externo), `graybox` (pentest dinâmico com contas de teste) e `whitebox` (secure code review). Dono do escopo autorizado, das fases e do relatório; **reporta, não corrige**. A checagem leve de segurança por Task continua no QA (frente 3); os dois não se sobrepõem.

Os playbooks saíram de `melhorias/PromptPenTest*.md`, **generalizados**: o que era cravado no `marcador-next` (URLs, header de auth, stack, LGPD-saúde) virou referência a `.team-project/security-engineer/context.md`, que o papel lê antes de tudo — **sem a autorização por escrito (§1), o papel para e pede ao stakeholder**.

**Laço shift-left.** O que o pentest valida no fim, o standard passa a exigir no começo: achado cujo causa-raiz é standard ausente/fraco vira achado de processo ao `/review` → Arquiteto complementa `standards/`, como o QA já faz (R16). A análise de lacuna mostrou identidade/autorização/LGPD já cobertas pelo `implementation-security-lgpd-copyright.md`; a superfície web/API dinâmica não — virou o novo standard transversal **`implementation-appsec-web-api.md`** (validação, injeção, saída/XSS, mass assignment, token na borda, CORS, cabeçalhos/HSTS, rate limiting, SSRF, erros, SCA).

Mudanças:
- **Agente e comando:** `agents/security-engineer.md` (Sonnet), `commands/sec.md`.
- **Papel:** `roles/security-engineer/` — README, skills, 3 playbooks, templates de `context.md` e de relatório.
- **Standard:** `standards/implementation-appsec-web-api.md` (novo) + linha no `standards/README.md`.
- **Hooks:** `common.ps1` (chamador, modelo, nome do papel), `pre-tool.ps1` (G7 — o papel dispara o `operator`), `ownership.json` (G8 — propriedade dos relatórios e da pasta do papel).
- **Matriz e manifesto:** `artifact-ownership.md` §1 (linha dos relatórios de segurança), `deliverables/team-project/README.md` e `models.json`, `rituals/review-contract.md`, `README.md`, `how-to.md`, `.claude-plugin/*`.

Os `agents/*`, `commands/*` e `.claude-plugin/*` são do stakeholder: propostos aqui, aplicados com a aprovação do PR.

## v3.57.7 — 2026-11-12

**Branch:** `fix/v3.57.7` a partir de `develop` (`72ab30c`, v3.57.6 mesclada) · **Processo:** nenhum (as regras 21, 23, 26 e 33 continuam as mesmas; muda quem mede o ambiente do pacote, o texto do roteiro e duas leituras da conferência)
Origem: sprint 6 do projeto. O plano externo da T-067 (História H-Y, layout novo) voltou reprovado em cenários, render, premissa e envelope. Dessas, render e premissa não tinham como passar. O `environment.md` do pacote era a §3 do plano mais recente, e esse plano também tinha vindo de fora, sem medição: T-080 → T-081 → T-067, todas as linhas "sem medição no pacote". Com **Layout novo:** sim, a conferência exige o navegador headless medido e ao menos uma premissa `medido:`. O assistente de fora não roda comando e, corretamente, não inventou saída. O pacote de correção H-Y-fix1 voltaria reprovado nas mesmas duas linhas. As outras duas falhas vieram do roteiro: a lista "O que a conferência recusa" não falava das regras 21, 26 (com layout novo) e 33, e não dizia para manter o sufixo `(teste)` dos cenários. É a terceira entrega seguida em que essa lista fica atrás do `plan.ps1` (v3.57.5, v3.57.6).

Mudanças:
- **O run mede o ambiente ao montar o pacote** (`scripts/checks/external-plan.ps1`, `Write-PackEnv`). Sondas curtas com prazo (`Invoke-Bounded`), sem instalar nada:
  - Node, npm, as dependências e o Angular, pela pasta do `package.json` (a raiz ou a primeira subpasta);
  - o navegador headless, aberto de verdade (`--headless=new --dump-dom about:blank`), com esta ordem: `CHROME_BIN`, senão o Chrome instalado, senão o Chromium do Playwright;
  - `adb version` e `adb devices`, com alvo android;
  - `dotnet` e `python`, pelo arquivo de projeto.

  O `environment.md` traz a tabela no formato da §3 (**sim**/**não**) e as **Premissas prontas** (`- P<k> · ambiente: … · medido: `…` → …`), e a saída bruta vai a `pack/environment.log`. No garden, as 7 sondas levam ~14 s. Vale também para o pacote da decisão de 🔺 GAP.
- **A referência não vem mais de plano externo** (`Get-SprintEnv`). A §3 de plano de Task que está no `state.json` do pacote é ignorada. O que sobra, a §3 do último plano escrito no Claude, entra como referência, abaixo da medição.
- **O roteiro cobre todas as regras** (`roles/architect/templates/external-plan.md`). Cada item leva o nome da linha da tabela do `plan.ps1` entre colchetes (`[cenários]`, `[render]`, `[envelope]` …), para o assistente casar o `falhou` do `check.txt` com a instrução. Entraram:
  - o bloco **Com Layout novo: sim**: headless na §3, tabela **Render real** com mutação sobre o teste de render, uma premissa `medido:` das prontas, geometria não se mede lendo código, formato do envelope e **Documentos vivos:**;
  - o `(teste)` copiado literalmente;
  - `[tamanho]`, `[comandos]`, `[aceite]`, `[herdados]` e `[leve]`.
- **Cenários** (`plan.ps1`, regra 23). O ID citado sem `(teste)` vale como provado por teste quando o `.scn` o declara num comentário `# SC-224 (teste) …`, que é a declaração do QA. A linha diz isso. O ID sem definição e sem a declaração continua reprovando. O modelo do plano (regra 23) diz o mesmo.
- **Envelope** (`plan.ps1`, regra 33). `(a) se …` e `(b) se …` valem sem a palavra "medir": "(a) se `scrollWidth ≤ clientWidth` …" é a mesma árvore. Continua exigindo a `sonda:` entre crases, e por isso E3 e E4 da T-067 seguem reprovando: a sonda delas é prosa.
- **Testes** (`run-check-tests.ps1`):
  - toda regra que o `plan.ps1` pode reprovar (`Add-Result '<regra>' 'falhou'`) tem `[<regra>]` no roteiro externo: regra nova sem instrução quebra o teste, não o sprint;
  - o `environment.md` medido, com headless **sim**, Angular lido do `node_modules`, premissa pronta e log;
  - `CHROME_BIN` inexistente dá **não**;
  - a referência vem do plano do Claude, não do externo;
  - o ID sem `(teste)` declarado no `.scn` passa, e o ID sem nada reprova;
  - o envelope com `(a) se` passa.
- **Não muda:** o pacote já gerado, como o `H-Y-fix1` do sprint 6. Ele só recebe a medição e o roteiro novos quando o pacote for gerado de novo.

---

## v3.57.6 — 2026-11-12

**Branch:** `fix/v3.57.6` a partir de `develop` (`7792f59`, v3.57.5 mesclada) · **Processo:** nenhum (a regra 18 já pedia o caminho; muda a mensagem da conferência e o texto dos modelos)
Origem: sprint 6 do projeto. O plano externo da T-081 voltou duas vezes pelo mesmo motivo. As linhas M1 e M2 traziam `` teste `…/filtro-pilulas.component.spec.ts::FiltroEstado_…` ``, com o nome do teste grudado no caminho. O `plan.ps1` compara esse campo inteiro com **Arquivos tocados:**, que só tem o caminho, e respondia apenas "teste … fora de **Arquivos tocados:**". Os dois arquivos estavam na lista. O pacote de correção só repassa a tabela, então o chat externo não tinha como ver o motivo. O modelo, que dizia `` teste `<teste>` ``, deixava entender que o nome do teste também servia.

Mudanças:
- **A conferência diz o motivo** (`scripts/checks/plan.ps1`, §18). Quando o campo teste traz `::`, a linha diz que ali vai só o caminho do arquivo, que o nome do teste vai no texto da regra e se o caminho está em **Arquivos tocados:**. Ela continua recusando: o `verify.ps1` usa esse campo como caminho para casar com `verify.focused` e para passar ao runner, e com o `::` a mutação não roda. Depois disso, a comparação com a lista segue só com o caminho, e a mensagem vaga não aparece mais.
- **O mini-plano do fix também confere** (`scripts/checks/fix.ps1 -PlanOnly`). A mesma recusa, com o mesmo motivo, vale para as linhas `**Mutações:**` de cada F-ID.
- **Os modelos dizem o formato** (`roles/architect/templates/external-plan.md`, `external-fix-plan.md`, `implementation-plan.md`, `fix-plan.md`). Depois de "teste" vai só o caminho do arquivo, igual ao de **Arquivos tocados:**, nunca `<arquivo>::<NomeDoTeste>`. O nome do teste vai no texto da regra. Os cabeçalhos dos dois modelos externos passam a citar a v3.57.6.
- **Testes:** dois casos em `run-check-tests.ps1`, um para o `plan.ps1` e um para o `fix.ps1 -PlanOnly`.
- **Não muda:** o pacote já gerado, como o `H-W2-fix2` do sprint 6, que só recebe o texto novo quando o pacote for gerado de novo.

---

## v3.57.5 — 2026-11-11

**Branch:** `fix/v3.57.5` a partir de `develop` (`fdef17f`, v3.57.4 mesclada) · **Processo:** nenhum (as regras 29 e 35 já existiam; muda só o texto do pacote)
Origem: sprint 6 do projeto. O plano externo da T-079 voltou reprovado pela regra 29 porque a decisão do 🔺 GAP veio sem as linhas `**Origem:**` e `**Lição:**`. O assistente de fora seguiu a lista "O que a conferência recusa" do `INSTRUCTIONS.md`, e essa lista não citava a exigência.

Mudanças:
- **A lista do pacote externo cobre as regras 29 e 35** (`roles/architect/templates/external-plan.md`). A lista passa a dizer três coisas. As decisões D-<k> e K-<n> se citam em `**Decisões:**` e não se copiam. Toda `**Decisão do GAP …:**` traz, logo abaixo e sem linha em branco no meio, `**Origem:**` e `**Lição:**` com os valores da lista, porque o `Get-PlanGapDecisions` encerra o bloco na primeira linha em branco. A linha `**Verificação:**` da regra 35 é opcional e tem formato fixo. O cabeçalho do modelo passa a citar a v3.57.5.
- **Não muda:** o pacote já gerado com o modelo antigo, como o `T-079-gap2` do sprint 6. Ele só recebe a lista nova quando o `run.ps1 next` gerar o pacote de novo.

---

## v3.57.4 — 2026-11-11

**Branch:** `fix/v3.57.4` a partir de `develop` (`5ca1b30`, v3.57.3 mesclada) · **Processo:** nenhum
Origem: relato do stakeholder em 11/11. Depois de `/clear` e `/sm sprint run`, o `run.ps1 next` respondia sempre "A sessão está com 151 mil de contexto, acima do teto de 150 mil", e o laço não saía.

Mudanças:
- **A linha `SESSÃO:` e o teto da v3.57.2 medem a sessão em curso** (`hooks/prompt-submit.ps1`, `run.ps1`). Antes, o transcript medido vinha da última linha do `usage.jsonl`, que aponta para a sessão que disparou o último agente terminado. Depois do `/clear` ainda era a sessão antiga. A sessão nova recebia "reiniciar" antes de disparar qualquer agente, então o registro nunca mudava. Agora o `UserPromptSubmit` grava a cada prompt o `transcript_path` da sessão em `.team-project/.session-transcript`, antes da G21 e mesmo que o arquivo ainda não exista. O `next` mede esse caminho, e a sessão nova sem transcript em disco fica sem a linha `SESSÃO:`, sem cair no registro antigo. O `usage.jsonl` só vale sem o marcador (hook anterior à 3.57.4).
- **Testes:** `run-check-tests.ps1` 12g cobre o `usage.jsonl` antigo com 170 mil e o `.session-transcript` com 50 mil (mede 50 e não reinicia), e o transcript novo ainda sem arquivo (cala). `run-guard-tests.ps1` cobre o primeiro prompt da sessão nova, que grava o marcador.

---

## v3.57.3 — 2026-11-10

**Branch:** `feat/v3.57.3` a partir de `develop` (`6284017`, v3.57.2 mesclada) · **Processo:** regra 35 do plano (`**Verificação:**`); a G7 cobra a linha `Chamador:` no pedido ao `operator`; o formulário da entrada fora da Planning traz a conta da capacidade; bloco `## v3.57` no `process-changelog.md` (a v3.54 foi para o arquivo)
Origem: o `melhorias/plugin-report.md` final do sprint 5 do garden (plugin 3.57.0), conferido contra a v3.57.2 em 10/11. Os itens que nenhuma versão tinha tratado foram ao stakeholder em dois formulários (10/11), com explicação e solução sugerida; ele escolheu as oito decisões e mandou fazer todas na mesma entrega.

Mudanças:
- **Suíte, node e navegador que sobram saem pelo `verify.ps1 -Kill`** (§3 item 10 e §4 item 16; `verify.ps1`, `lib.ps1` `Invoke-ProjectCommand -PidFile`): no sprint 5 sobraram 3 suítes ao mesmo tempo e o classificador de permissões negou o `taskkill` mesmo com o stakeholder pedindo — só passou na segunda ordem. Cada comando do `verify` agora roda registrado em `verify/<seg>/<ID>/running.json` (pid e hora de criação) e o registro sai quando o comando termina. `verify.ps1 -Task <ID> -Kill` encerra a rodada viva da trava (o `verify` e os filhos dele) e o órfão registrado de uma rodada que morreu, restaura a mutação interrompida e tira a trava — só processo que o `verify` iniciou; PID reaproveitado não é tocado. A rodada nova da mesma Task encerra sozinha o órfão da anterior (o Chrome órfão do "Failed to create a temp dir"; a mensagem do `tool-hygiene.json` agora aponta o `-Kill`). `operator.md` e `sprint-run.md` trazem a rota.
- **Q11 reaproveita o verify e não reprova por medida vazia** (§3 item 8 e §4 item 10; `quality.ps1`): a cobertura do portão vem do `verify full` mais recente feito sobre a **mesma árvore** (chaves `coverage…`), sem rodar a suíte outra vez; sem ele, roda o `quality.coverage`, e a saída que não mediu nada ("Unknown%", "( 0/0 )" — o comando apontava para outro gate) vira **não medido**, com a causa, em vez de reprovar o portão. O QA julga, como na regra não configurada. Medida abaixo do limiar segue reprovando.
- **Regra 35 — como a Task se verifica quando o verify full não serve** (lições de GAP 1, 5, 7, 8/9 e 11; `plan.ps1`, `lib.ps1` `Get-PlanVerification`/`Get-TaskPlanPath`, `verify.ps1`, `close.ps1`, `run.ps1`, `implementation-plan.md`, `plan-rules-why.md`): a linha `**Verificação:**` do cabeçalho do plano. `dispensada — <motivo>` (laudo sem código, Task que só mexe em configuração de teste): o `close.ps1` dá R7-verify n-a e o QA revisa a dispensa no portão; não combina com `**Mutações:**`. ``comando — `<comando>` `` (runner fora do framework principal, como o `node --test`): o `verify.ps1` o roda como o passo `plano` — no focused sem `-Tests` só ele e o lint, no full depois da cobertura —, com a trava, a árvore e o `result.json` de sempre. O cartão do dev diz qual vale. Fora dos formatos, dispensa com mutação ou comando de instalação, rede, push ou destrutivo reprovam no `plan.ps1`.
- **A conta da capacidade na frente de quem decide** (§3 item 13; `kanban.ps1 -Capacity [-Add <est>]`, `lib.ps1` `Get-SprintCapacity`, `close.ps1` R4, `workflow-sprint.md` §5e, `templates/kanban.md`): no sprint 5 entraram 11 Tasks fora da Planning, todas com "nada saiu para caber", e o quadro fechou em 16,0 d contra 11,83 d (+35 %). O formulário da entrada traz a linha do `kanban.ps1 -Capacity -Add <estimativa>` (capacidade, planejado na Planning, soma do quadro e com a entrada, em %) e, acima da capacidade, pede o que sai ou a confirmação do estouro. O R4 do `close.ps1` repete a conta quando o quadro passa da capacidade (informa, não reprova).
- **O pedido ao `operator` diz quem chama** (§4 item 15; `hooks/pre-tool.ps1` G7, `hooks/subagent-stop.ps1`, `consumption.ps1`, `dispatch.ps1`, `run.ps1`, agentes): 27 % das instâncias do `operator` saíam com chamador "?" pelo 5º sprint. Todo pedido ao `operator` começa por `Chamador: <papel> <ID>`; a G7 nega sem a linha ou quando o papel não é o de quem dispara (a sessão inclusive, como `sessão`; o executor vale como `task-runner` ou `executor`), a G16 grava o `caller` no `usage.jsonl` e o `consumption.ps1` o usa antes da descoberta pelo horário. Os prompts que o `run.ps1` imprime já trazem a linha.
- **G14: `Set-Location` dentro do projeto** (§3 item 9; `hooks/pre-tool.ps1`): `Set-Location source; node scripts/alvo/prova-cdp.mjs` era negado mesmo com `node source/scripts/alvo/prova-cdp.mjs` no `runCommands` — o diretório não persiste entre chamadas e o script do projeto só rodava escrito a partir da raiz. Depois de um `Set-Location`/`cd`/`Push-Location` para uma pasta **dentro** do projeto, o caminho relativo do trecho é lido a partir dela; nada novo é liberado (fora do projeto ou sem resolver, vale a regra de antes).
- **R17 volta a passar** (`process-changelog.md`): bloco `## v3.57` (v3.57.0 a v3.57.3) e a v3.54 relocada para o arquivo, com a linha no índice.

Decidido não mexer agora: o cenário de tela provado fora do `accept` (lição 6) espera o garden espelhar o id no `aria-label` (decisão de 09/11 mantida). Fora do plugin, como antes: o preço do Haiku (faixa por tamanho de prompt, não é defeito) e o rótulo `S<n>` do `prova-cdp.mjs` (script do projeto).

Testes novos: a regra 35 (leitor, `plan.ps1`, focused e full com o passo `plano`, `close` com e sem a dispensa); o `verify -Kill` (rodada viva, órfão, processo de fora intocado, de novo = nada) e o órfão encerrado pela rodada nova; a Q11 reaproveitada, "não medido" e abaixo do limiar; a conta da capacidade (acima, dentro, R4); a G7 do chamador (sem a linha, papel errado, sessão, executor, Agent a outro papel) e o `caller` no `usage.jsonl`; a G14 com `Set-Location` (dentro, sem, fora, com `-Path` e aspas). Os 4 casos antigos de Agent ao `operator` ganharam a linha `Chamador:`. Conferências 468/0, guardas 322/0. C3: R18, R17 (de volta ao verde: bloco v3.57 com 4,2 KB), ps1-5.1, ownership e órfãos ok. **Não testado em sessão real:** o `-Kill` numa suíte do Karma de verdade; a G7 do chamador no fluxo do run (quantas negações até os papéis escreverem a linha de primeira); a dispensa e o passo `plano` num plano real; a conta da capacidade num formulário de entrada.
## v3.57.2 — 2026-11-09

**Branch:** `feat/v3.57.2` a partir de `develop` (`251b097`, v3.57.1 mesclada) · **Processo:** a G14 passa a barrar a suíte fora do `verify.ps1` para o dev e o executor; a sessão reinicia por teto de contexto (`sprint-run.md` §Sessão enxuta)
Origem: o relatório de ocorrências do sprint 5 do garden (`melhorias/plugin-ocorrencias.md`, gravado pela sessão do garden em 09/11 a pedido do stakeholder), analisado contra a v3.57.1 — `note.md` itens 14 a 23, e as decisões do stakeholder de 09/11 (formulário) para os itens 23 (contexto enxuto) e 24 (`aria-label` no app — trabalho do garden; o plugin já lê o `content-desc` desde a v3.57.1).

Mudanças:
- **A Task em curso respeita o "Depende de"** (item 14, `run.ps1 next`): com duas Tasks em 🟨, o `next` mandava construir a primeira do quadro mesmo dependendo da outra (quatro "construir Q-S5" com a Q-S5b em construção). Agora a dependência é a Task em curso.
- **"nenhum aplicável — motivo" na linha `**Cenários:**`** (item 15, `lib.ps1` `Get-PlanScenarios`, `plan.ps1`): vale como "nenhum — motivo", a forma que o `close.ps1` já aceitava na coluna do quadro (a T-046 reprovou no R7-aceite até trocar o texto).
- **Q9 sem falso positivo em português** (item 16, `quality.ps1`): TODO/FIXME só em maiúsculas — a busca ignorava a caixa e casava "todo o card" (59 achados falsos no portão do sprint 5).
- **Armadilha do Karma** (item 17, `standards/stacks/angular/pitfalls.md` NG-P1): o `browserNoActivityTimeout` padrão de 30 s derruba a suíte completa em ~1 de cada 2 rodadas com specs de render; `120000` e `browserDisconnectTolerance: 1`.
- **Chrome órfão não é "navegador não instalado"** (item 18, `tool-hygiene.json`): "Failed to create a temp dir" / perfil em uso ganha assinatura própria, antes da genérica.
- **O `accept` instala por cima** (item 19, `targets/android.ps1` `Install-AndroidApk`, `accept.ps1`): desinstalava o app antes de instalar e cada accept apagava a base (o garden proibiu o accept nas Tasks por isso — D-5). Agora `install -r` mantém os dados; só desinstala quando o Android recusa a atualização (assinatura diferente, versão menor) e avisa que a base foi apagada.
- **A suíte e a cobertura só pelo `verify.ps1`** (item 20, `hooks/pre-tool.ps1` G14): o dev e o executor de Task não rodam direto o comando de `verify.suite`, `verify.coverage` ou `quality.coverage` do `guards.json` — no sprint 5 do garden, a suíte rodada direto (liberada pelo `runCommands`) não deixou `verify.lock`, o `next`/`start`/`done` não viram a espera e dispararam 3 devs e 3 suítes completas na Q-S5b (Chrome órfão, resumo de cobertura sobrescrito, 391 rodadas vazias do executor). O `verify` tem trava única por Task, retoma do ponto e é o que a espera enxerga. Fica de fora o núcleo igual ao do `verify.focused` e o `operator`.
- **Sessão principal: medida a cada Task e reiniciada pelo teto** (item 21, `run.ps1`, `stop.ps1`): o `consumption.ps1 -Session` existia, mas nenhum script o chamava — agora o `done` o roda a cada Task fechada (a sessão do sprint 5, ≈ 1/3 do custo, ficou fora da conta). Acima de `guards.json → run.sessionContextCap` (padrão 150 mil; 0 desliga) e sem agente em voo, o `next` responde **reiniciar a sessão** (`/clear` e `/sm sprint run`, que retoma do quadro) e a G20 aceita o veredito "reiniciar". A maior sessão do sprint foi de 56 mil a 409 mil de contexto; a simulação do relatório dá −35 % a −60 %.
- **Evidência que falta vai ao cartão** (item 22, `run.ps1 done`): reprovado por evidência, o `done` grava `handoff/<T>-evidencia.md`, registra a rota no run-log e o cartão do dev novo traz **Só completar a evidência** (sem mudar código); o arquivo sai quando a Task fecha.
- **Arquiteto com contexto enxuto** (item 23, decisão do stakeholder; `run.ps1 done -Result gap` `Write-GapCut`, `hooks/pre-tool.ps1` G14, `architect.md`): o GAP é decidido pelo recorte `handoff/<T>-gap.md` — o bloco do GAP, o cabeçalho do plano e os passos que ele cita (2,7 KB contra 19,6 KB do plano da T-043 do garden) — e o plano inteiro só se o recorte não bastar; a decisão entra por delta (`Edit`): regravar inteiro um plano que já existe (acima de 2 KB) é negado ao Arquiteto durante o run. No sprint 5 o Arquiteto em Opus foi 69 % do custo dos subagentes, com planos refeitos inteiros (T-071 ×5).

Conferências 451/0, guardas 312/0 (testes novos para cada item; a G14 da suíte e o recorte do GAP também conferidos sobre o `guards.json` e os planos reais do garden). C3: R17 segue falhando desde a v3.57.0 (sem bloco `## v3.57` no `process-changelog.md`). **Não testado em sessão real:** o reinício da sessão pelo teto num run de verdade; a G14 da suíte sem atrapalhar o fluxo normal do dev; o Arquiteto decidindo pelo recorte (quantas vezes abre o plano inteiro); a sessão principal no `consumption.md` a cada Task fechada.
## v3.57.1 — 2026-11-09

**Branch:** `feat/v3.57.1` a partir de `develop` (`bdac907`, v3.57.0 mesclada) · **Processo:** sem regra nova; o contrato do watcher em `sprint-run.md` §Protocolo de espera muda de comando e de nome
Origem: análise do sprint 5 do garden (09/11, plugin 3.57.0 em uso desde 07/11), `note.md` itens 1, 3, 4, 5, 6, 7, 9, 10, 11, 12 e 13.

Mudanças:
- **O watcher da espera passa a conferir de verdade** (`note.md` item 12): os 5 disparos reais do sprint 5 do garden (08/11) tiveram a primeira chamada negada pela G14 — o roteiro mandava um laço com `Start-Sleep` no texto do comando — e voltaram em ~8 s sem conferir nada. A espera foi para dentro do script: `run.ps1 wait -For <s> [-Every <s>]` confere, dorme e confere de novo, e para no primeiro "terminou" ou "travado" ou quando a próxima espera passaria do prazo (`-For 0`, o padrão, é a conferência única de antes). O roteiro roda só `run.ps1 wait -For 150`, que a G14 já libera como conferência do plugin; nenhuma exceção nova na guarda.
- **`vigia` → `watcher`** (`note.md` item 9): `agents/watcher.md`, `team:watcher`, a linha de volta `watcher: terminou|vivo|travado` e a linha de disparo do `next` (`Get-WatcherLine`), no padrão em inglês dos outros agentes. O "vigia de ~600 s do harness" (o limite de tempo da ferramenta, em `working-rules.md`, `how-to.md`, `COVERAGE.md` e `verify.ps1`) é outra coisa e não mudou.
- **Categoria do watcher no consumo** (`note.md` item 10): `cerimônia`, como o executor de Task (`consumption.ps1`; as linhas antigas com o papel `vigia` também); o modelo `consumption.md` lista o papel.
- **Cobertura depois da suíte** (`note.md` item 3, `verify.ps1`): no `verify full`, a suíte que não cabia na chamada ficava para a seguinte, mas a cobertura rodava antes dela e lia o resumo da rodada anterior — "não medido" sem resumo, ou verde com o dado velho. No garden era todo full (suíte de 540–820 s; `verify/5/T-066a/time.jsonl`: build, lint, suite2, **coverage**, e só então **suite**). Agora a cobertura espera a suíte pendente, e a cobertura curta pela história (≤ 60 s) roda logo depois dela mesmo fora do orçamento, sem custar outra chamada. Reproduzido com o `verify.ps1` do `develop` antes da correção.
- **APK fora de `build/outputs` e app híbrido** (`note.md` item 4, `lib.ps1` `Find-ConfiguredApk`/`Get-ProjectApk`/`Get-ApkStaleness`, `targets/android.ps1`, `accept.ps1`, `verify.ps1`): `targets.android.apk` aceita máscara no nome (vale o mais novo — o garden gera `source/dist/garden-management-<T-ID>-debug.apk` com o build num container e `android/app/build` em volume do Docker, e a conferência de APK velho nunca rodou); `targets.android.apkSources` declara as fontes que entram no APK (no híbrido, o código web; `*.spec.*`, `*.test.*` e `node_modules` não contam); sem a chave e com o APK fora de `build/outputs`, o `verify full` e o `accept` avisam que a idade não foi conferida. O `verify full` passa a usar o mesmo APK que o `accept` instala.
- **"## Agora" em linguagem de funcionalidade** (`note.md` item 11, `hooks/common.ps1`): quem (Dev, Executor da Task, Arquiteto…), a Task com o título do backlog, o que faz numa frase simples traduzida do comando ("rodando os testes com cobertura", "gerando o APK do app", "alterando o arquivo x") e horários fixos — o "Há N min" era calculado ao gravar e ficava "0 min" até a próxima ação. O comando cru segue no `.active-agents` e no `/team-status`.
- **Regra 33 reprova** (`note.md` item 7, `plan.ps1`): plano com `**Layout novo:** sim` sem `**Envelope de medidas**` (ou com linha sem sonda e casos) reprova — com o aviso, nenhum dos 7 planos de layout novo do sprint 5 do garden trouxe o envelope. Saída declarada: `**Envelope de medidas:** nenhum — <motivo>`, para a tela sem medida a decidir e o plano antigo que volta num GAP.
- **Regra 34 — a dispensa do aceite num lugar só** (`note.md` item 5, `plan.ps1`): plano que diz em qualquer frase que o aceite não roda, sem a linha `**Aceite:**` do cabeçalho, reprova (16 planos do garden dispensaram o aceite e a leitura da v3.57.0 reconheceu 7 — o cartão contradizia o plano). `**Cenários:** nenhum` = n-a; `**Aceite:** roda — <quem>` quando a frase fala de outra coisa. Rodado sobre os planos do sprint 5: reprova T-041, T-042, T-060, T-061, T-062, T-066, T-066b; os com a linha passam.
- **Natureza do GAP obrigatória** (`note.md` item 6, `run.ps1 done -Result gap`, `gap.md`, `developer.md`, `task-runner.md`): no sprint 5 do garden a linha `**Natureza:**` veio em 2 de 22 GAPs — a lista (aparência | desenho | produto) não tinha o que a maioria era — e sem ela não se mede quantos GAPs de aparência poderiam ir a um modelo mais barato. Entram `processo` e `ambiente` (ciclo completo, como antes); vale a linha `**Natureza:**`, senão a palavra na linha do 🔺 (como os devs escreviam: "🔺 GAP (ambiente / massa)"); sem nenhuma, o `done` recusa (exit 2) antes de qualquer efeito e o executor classifica com `-Nature` (sem acento). O run-log grava `🔺 GAP [<natureza> · <quem deu>]` — a contagem para a decisão do modelo, que é do stakeholder (`models.json`).
- **O accept acha o id pelo nome acessível e não confunde "ids não publicados" com estado de partida** (`note.md` item 13, `targets/android.ps1` `Find`, `accept.ps1` `Test-IdsHidden`, `run.ps1 done -Result env`): no emulador do garden (Android 15, WebView 124) o `uiautomator` não publica o id HTML como `resource-id` e o `accept` não chegou a nenhum critério no sprint 5 — a captura mostra o app na tela certa, mas o diagnóstico dizia "ESTADO DE PARTIDA" e mandava declarar `baseline` (o projeto já tinha `reset`/`seed base`). Agora o `Find` aceita o `content-desc` igual ao id (o `aria-label` da WebView; o `resource-id` vale primeiro) — é a condição que o stakeholder pôs em 08/11 para baixar o desvio da prova pelo CDP —, e com "tag ausente" e o dump só com ids do Android o `accept` diz **IDS NÃO PUBLICADOS** e o `done` bloqueia com esse motivo, sem reparo. Falta o lado do app: espelhar o id no `aria-label` só no build de prova (Task do garden).
- **Sinal de vida declarado pelo projeto** (`note.md` item 1, `lib.ps1` `Get-ProjectWaitSignal`, `run.ps1 wait`): `guards.json → waitSignals` — `when` (trecho do comando do agente), `paths` (o que o trabalho grava) e `alive` (comando que imprime algo enquanto ele roda, com prazo de 20 s). O `wait` mostra o último arquivo e o alive; 10 min sem ação do agente, sem arquivo novo e sem alive = POSSÍVEL TRAVAMENTO. Para o build do APK no container, que o plugin não mede.

Testes novos: a G14 libera o comando exato do roteiro do watcher e continua negando o laço da v3.57.0; `run.ps1 wait -For` (vivo o prazo todo, terminou no meio) e o `waitSignals` (alive rodando, sem sinal há 15 min, arquivo novo); a cobertura que espera a suíte pendente (reproduzido com o `verify.ps1` do `develop`: "módulo não medido" com a suíte verde); o APK por máscara e a idade pelo `apkSources`; o "## Agora" novo; as regras 33 e 34 do `plan.ps1` (rodadas também sobre os planos reais do sprint 5 do garden); a natureza do GAP (recusa, `-Nature`, palavra na linha do 🔺); o `Find` pelo `content-desc` e o IDS NÃO PUBLICADOS. Conferências 442/0, guardas 306/0. C3: R18, ps1-5.1, ownership e órfãos ok; **R17 falha desde a v3.57.0** (sem bloco `## v3.57` no `process-changelog.md` — o `develop` já reprova; a entrada da v3.57.0 diz "C3 ok"). **Não testado em sessão real:** o watcher numa espera do garden; o `waitSignals` com o build no container; o `apkSources` no garden (pede `apk` e `apkSources` no `guards.json`, do stakeholder); o "## Agora" lido por quem acompanha; a natureza em todos os GAPs de um sprint; o `content-desc` no `horta-api35` (depende de o app espelhar o id no `aria-label` do build de prova).

---
## v3.57.0 — 2026-11-07

**Branch:** `feat/v3.57.0` a partir de `develop` (`d88cb45`, v3.56.0 mesclada) · **Processo:** sem regra nova de trabalho dos papéis; o protocolo de espera é a fonte única em `sprint-run.md` §Protocolo de espera
Origem: `melhorias/plugin-report.md` (relatório intermediário do sprint 5 do garden, 07/11) e `melhorias/decisoes-plugin-report.md` (as escolhas do stakeholder, item a item). A causa comum de 11 dos sintomas: o plugin foi escrito e testado para o caminho em que tudo dá certo; o sprint real é feito de emulador lento, processo que não termina, notebook que dorme e plano que muda no meio.

Mudanças:
- **Protocolo de espera — as seis regras de todo ponto que espera** (`sprint-run.md` §Protocolo de espera; `fix-run.md`, `task-runner.md` e `operator.md` apontam para ele): verificar, prazo, morte, retomada, reinício, espera da sessão. Constantes medidas: 180 s (o ambiente move para segundo plano o comando que passa disso), 600 s (reparo do alvo), 10 min (POSSÍVEL TRAVAMENTO).
  - **`Invoke-Bounded`** (`lib.ps1`): saída em arquivo, nunca em pipe; prazo obrigatório; exit 124 no estouro; `-KeepDescendants` para o filho que deve sobreviver. Migrados para ele os três pontos com o mesmo defeito: `Repair-Android` (prazo `targets.android.repairTimeoutSec`, padrão 600 s — o reparo ficou ~2 h preso a um pipe herdado por um filho de longa duração; reproduzido: 26 s no caminho antigo, 4 s no novo), `Invoke-TargetSeed` (`WaitForExit()` sem prazo) e `Measure-CutAgent` (`ReadToEnd()` antes do `WaitForExit(60000)`, prazo decorativo).
  - **Guarda de processo solto** (`run-check-tests.ps1`): `Start-Process`, `Process::Start` e `ReadToEnd` de pipe fora do `lib.ps1` só com a marca `# protocolo: adb` ou `# protocolo: desprendido`. Provada nos dois sentidos, com injeção numa cópia.
  - **Modo desprendido e `target.ps1 -Kill`**: o processo que o run inicia e que deve sobreviver (emulador pelo AVD, filhos que o reparo declarado deixa vivos, servidor web) grava PID e hora de criação em `.team-project/.target-<alvo>.json`; `-Kill` encerra só o registrado, sem pedir ao stakeholder, e reconhece PID reaproveitado pelo Windows. `ownership.json` e `artifact-ownership.md` ganharam `.target-android.json`.
  - **O vigia** (`agents/vigia.md`, `run.ps1 wait`): agente barato (Haiku, só PowerShell, prompt fixo sem ID de Task) que confere a espera por até 10 min e devolve uma linha; só a sessão o dispara (G7); entra em `.active-agents`, e é isso que deixa a G20 liberar o fim do turno. `run.ps1 wait` é a sonda só de leitura (0 terminou · 3 vivo · 5 POSSÍVEL TRAVAMENTO); o `next` imprime a linha de disparo nos dois ramos "esperar". Teste real do desenho: o aviso do agente reabriu a sessão ~68 s depois; o ambiente move comando que passa de 180 s para segundo plano e o agente avisa de novo ao terminar.
  - `operator` bloqueia até o resultado do reparo e nunca deixa processo sem prazo. A G14 ganhou mensagem própria para `-ExecutionPolicy` (a negação não mudou).
- **O cartão obedece ao plano** (`lib.ps1` `Get-PlanScenarios`, `run.ps1`): a linha `**Aceite:** não roda — <motivo>` (ou uma linha de Aceite/Decisão que diga que o aceite não roda) esvazia os cenários no alvo e os passa a prova por teste; o cartão, o `start` e o `next` deixam de mandar o `accept.ps1`. Linha `**Aceite:**` no modelo de plano.
- **`# aguarda` em ciclo** (`run.ps1`, `lib.ps1` `Find-WaitCycle`): a Task que cria os nomes de teste do próprio cenário não espera por si mesma; sem Task elegível, o `next` mostra o ciclo e a espera por Task fora do quadro (mãe dividida em A/B).
- **`verify`**: suspensão do sistema detectada por salto de relógio — a rodada é repetida uma vez e registrada (`atenção: … rodada repetida e válida`); `verify.buildTimeoutMinutes` (teto próprio do build); `full` verde com alvo android e APK mais velho que o código avisa "o comando 'build' não regerou o APK" (antes só o accept recusava); `Get-ApkStaleness` e `Get-LatestApk` foram para o `lib.ps1`.
- **Mutação**: com `verify.compile` declarado, a mutação roda o Precheck sozinha antes (quando não há um verde registrado para a árvore, `precheck.json`) e para cedo com a lista; sem `verify.compile`, aviso alto de que a compilação dos mutantes não foi conferida. O Precheck "obrigatório na entrega do plano" não é possível (antes do código não há o que compilar).
- **Gate de ids de teste**: `testIds.dynamic` (ou `// testid-dinamico: <padrão> — <motivo>`) declara ids que só existem em tempo de execução — não reprovam, ficam listados como não conferidos; o aviso de atributo divergente (os controles têm `id`, o gate assumiu `data-testid`) diz que quem declara `testIds.attribute` é o stakeholder.
- **GAPs de aparência** (`implementation-plan.md` regra 33, `plan.ps1`, `gap.md`, `run.ps1`): `**Envelope de medidas**` no plano (o `plan.ps1` avisa, não reprova, nesta versão); o cartão traz o envelope; o dev marca `**Natureza:** aparência | desenho | produto` e o `done -Result gap` roteia (produto → stakeholder, aparência → parecer curto, desenho → ciclo completo); um GAP de aparência por Task.
- **Suíte**: o tempo de cada caso entra na linha e os 12 mais lentos saem no fim.

Fora desta versão (decisão do stakeholder ou dependência): a sonda de progresso do build para o vigia (depende do comando de build do projeto, ainda não informado); o accept confirmar o id dinâmico em tempo de execução (liga o `verify` ao aceite; só se prova em sessão real); o item "cobertura 'não medido' com suíte verde" (causa não verificada); a troca do modelo do Arquiteto para GAP de aparência (é `models.json`, do stakeholder — o parecer curto é por tamanho de resposta).

Conferências 429/0, guardas 304/0, C3 ok. **Não testado em sessão real:** o `SubagentStop` real do vigia, a linha `vigia` na tabela do `consumption.md` e o `next` completo com um vigia em voo (só simulados nos hooks e no `run.ps1 wait`); o `target.ps1 -Kill` e o registro do emulador num emulador real; o `Repair-Android` pelo `Invoke-Bounded` com o `repair` do container Docker (o filho do emulador sobrevivendo); o aceite declarado "não roda" com a redação do plano real do garden (cobertas a forma estruturada e duas frases); o ciclo de espera numa fila real; a suspensão do sistema de verdade (só o salto de relógio simulado); o Precheck automático com o `verify.compile` de um projeto real; o aviso de APK velho em app híbrido (o código web copiado para `src/main/assets/public` não entra na conferência); `testIds.dynamic` num projeto real; a natureza do GAP e o envelope com Arquiteto e dev reais.

---

## v3.56.0 — 2026-11-06

**Branch:** `feat/v3.56.0` a partir de `develop` (`b4d8f8d`, v3.55.0 mesclada) · **Processo:** v3.56 (a lição de cada GAP no lugar certo; o SM atualiza o lado do projeto no fechamento)
Origem: `melhorias/plano-v3.56.0.md`, aprovado pelo stakeholder em 06/11 com as recomendações do §9. Base: a classificação dos 117 GAPs do garden, sprints 1 a 5 (`melhorias/gaps-garden-s1-s5.md`).

Mudanças:
- **H · os três defeitos do plugin ainda abertos (10 dos 31 GAPs de defeito):**
  - **H1** (`accept.ps1`): cada erro do `Read-Scenarios` leva o id do cenário. Com `-Only`, contam só os erros dos cenários pedidos e os do arquivo; os outros saem num aviso de uma linha. De quebra: o "passo antes do primeiro `scenario`" passou a valer por arquivo; antes, caía no último cenário do arquivo anterior.
  - **H2** (`lib.ps1` `Get-SprintTasks`/`Get-PlanScenarios`/`Get-ScenarioFiles`, `run.ps1`, `close.ps1`): com plano legível, os cenários da Task são os da linha `**Cenários:**` do plano, ou nenhum com "nenhum — motivo". O backlog só vale antes do plano. O cartão, o `start` e o `next` dão `accept.ps1 -Scenarios <.scn da História> -Only <os do plano>`. A divergência com o backlog vira uma linha `cenários: o plano manda` no `run-log.md`, uma vez, sem formulário. O prompt do dev diz que ordem do cartão contra o plano é GAP de processo. O `close.ps1` (R30) também confere a lista do plano.
  - **H3** (`hooks/pre-tool.ps1` G9): um caminho que o `git check-ignore -q` diz estar ignorado (saída de build) é liberado, com a linha `G9 liberado (ignorado pelo git)` no `guards.log`. A G5 roda antes, então um segredo ignorado e protegido continua negado. Sem git, nada muda.
- **A · o GAP declara origem e destino** (`gap.md`, `technical-decision.md` §Origem e Lição, `implementation-plan.md` e `plan-rules-why.md` regra 29, prompt do GAP no `run.ps1`, `plan.ps1`):
  - toda decisão de 🔺 GAP tem as linhas `**Origem:**` (previsão · conhecimento · requisito · ambiente · processo) e `**Lição:**` (projeto · stack:<nome> · plugin · nenhuma). No plano, a decisão é escrita como `**Decisão do GAP <T-ID> (<data>):**`;
  - a regra 29 foi ampliada: reprova a decisão sem as duas linhas e o valor fora da lista. Num sprint anterior ao `**Classificação desde:**` do `knowledge.md`, ou sem o arquivo, a falta das linhas só gera aviso. Assim, as D antigas do garden S5 não travam o fim do sprint;
  - a D passa a ser gravada quando vale para mais de uma Task **ou** quando a lição é de projeto ou de stack.
- **B · conhecimento do projeto que atravessa sprints** (`roles/architect/templates/knowledge.md` novo, `lib.ps1`, `run.ps1`, `external-plan.ps1`, `plan.ps1`, `ownership.json`, `artifact-ownership.md` §1, manifesto do `.team-project`, `agents/developer.md`, `agents/architect.md`):
  - `architect/knowledge.md` guarda entradas `## K-<n>`. O **Vale para** aceita `todas`, T-ID ou glob de caminho. A entrada traz **Origem**, **Desde** e, quando é remédio temporário, **Até**. O teto é 15 KB;
  - o cartão do dev traz o bloco **Conhecimento do projeto**. O recorte da ficha e o pacote externo trazem o resumo das entradas (`Get-KnowledgeDigest`);
  - a linha do plano passou a `**Decisões:** D-<k>, K-<n>`. Citar uma K que não existe, ou copiar o texto de uma K, reprova;
  - o casamento usa os arquivos de `**Código a ler:**`/`**Fontes:**` da ficha e os de `**Arquivos tocados:**` do plano. O `**Arquivos previstos:**` da ficha é uma contagem, não uma lista;
  - dono: Arquiteto. O SM também escreve, mas só pela promoção do fechamento (G8).
- **C · camada de stack extensível** (`standards/stacks/ionic-capacitor/{guide,pitfalls}.md` novos, com 18 armadilhas do garden marcadas "confirmar em segundo projeto"; `pitfalls.md` vazio, com o formato, nas outras quatro stacks; `standards/README.md`; `lib.ps1` `Get-Stacks`/`Get-StackPitfallLines`; `common.ps1` `Get-InferredStacks`; G13):
  - o projeto declara as stacks em `guards.json` → `"stacks"`. Sem a chave, o plugin infere pelos arquivos da raiz e do primeiro nível, e o SessionStart avisa;
  - a camada local `.team-project/standards/stacks/<stack>/pitfalls.md` (`<STACK>-L<n>`) soma à do plugin. Uma entrada com `**Promovida:**` deixa de ser lida;
  - o cartão traz até 6 armadilhas que casam com a Task.
- **E · o SM atualiza o lado do projeto no fechamento** (`scripts/checks/knowledge.ps1` novo, `sm.md`, `workflow-sprint.md`, `retrospective.md` §Lições do sprint, `agents/scrum-master.md`, R6 e R16 com o índice):
  - `knowledge.ps1 -Sprint <n> -Check|-Apply` monta a tabela origem × destino em `sprints/<n>/lessons.md` e faz a promoção por cópia: D → K e D → `<STACK>-L`. Rodar de novo não duplica;
  - a lição de plugin vira ocorrência (iii). Um remédio com `**Até:**` também vira K;
  - o script aponta a **repetição com registro**: um GAP de conhecimento cuja decisão cita uma K, D ou armadilha que já existia, e diz se o registro chegou à Task ou não;
  - o script aponta como achado a decisão sem Lição (exit 1) e o teto estourado (`architect/consolidation.md`, primeiro item do próximo `prepare`);
  - o script levanta propostas de configuração: `stacks`, comandos liberados, reparos e GAPs de ambiente.
- **D · lição de plugin** (`workflow-sprint.md` critério iii, `plugin-report.md` §GAPs de processo, R25): entra no mesmo formulário investigar × ignorar e vai ao relatório sem o contexto do projeto.
- **F · migração** (`team-update.md` 7m, `team-init.md` 4a, `knowledge.ps1 -Migrate [-Apply] [-Classify] [-Retire]`):
  - o update cria o `knowledge.md` com `**Classificação desde:**` igual ao sprint seguinte ao aberto e cria a pasta local de stacks;
  - pergunta as stacks e o destino de cada D sem classificação. Para o garden S5, as respostas de 06/11 ficam escritas no ritual;
  - grava as linhas nas D e retira uma K quando a correção prevista no **Até** chegou;
  - não promove nada do sprint aberto: isso acontece no close dele. A semente das 25 lições do garden fica para o primeiro `prepare`.
- **Documentos:** `how-to.md` (seção Conhecimento do projeto), `sprint-run.md`, README do QA, `hooks/COVERAGE.md` (G9), entrada v3.56 no process-changelog (a v3.53 foi arquivada, R17).

Conferências 404/0 (+24), guardas 297/0 (+10), C3 ok.

**Não testado:**
- a escolha da Lição por um Arquiteto real;
- o casamento por glob em Tasks reais do garden (os testes usam árvores pequenas);
- o formulário do fechamento numa sessão real (lições de plugin e propostas de configuração no formulário único);
- a H2 numa Task do garden com o plano diferente do backlog;
- o `-Migrate` no `decisions/S5.md` real (o teste usa um arquivo com a mesma forma);
- a G9 com o `.gitignore` de uma subpasta (`source/.gitignore`) num repositório real.

**Riscos:**
- a repetição com registro só aparece quando a decisão cita o ID que já existia (K-, D-, `<STACK>-P/L`). Se o Arquiteto não citar, a repetição passa sem aviso;
- a inferência de stacks só olha a raiz e o primeiro nível;
- a G9 chama o `git` uma vez por escrita fora do plano;
- as 18 armadilhas do Ionic vêm de um projeto só.

## v3.55.0 — 2026-11-05

**Branch:** `feat/v3.55.0` a partir de `develop` · **Processo:** v3.55 (fechamento da margem, verificador por caminho, padrão de ids de teste, comandos do run declarados antes da construção)
Origem: carta 2 da sessão do sprint 5 do garden (fechamento R7-margem) e padrão de ids decidido pelo stakeholder em 05/11; itens 10 e 11 da fila do `/review`.

Mudanças:
- **A · fechamento e margem do dev** (`lib.ps1` `Get-MarginAdjustments`, `close.ps1`, `agents/developer.md`, `delivery-report.md`):
  - **A1:** linha de ajuste fora do formato (sem crases, espaços diferentes) tem leitura tolerante; o `close` registra o formato **e segue** com as travas do ajuste, numa única saída `R7-margem falhou`. O `run.ps1 done` já repassava todas as linhas `R7*`.
  - **A2:** plano com `sem prova:` + ajuste de teste → mensagem "abra 🔺 GAP com esta linha, sem nova rodada de `done`".
  - **A3:** margem `- A<k> · fixture · <arquivo de teste> · … · regra: <standards/… § do padrão de ids | dump .xml>`: arquivo em **Arquivos tocados:**, regra obrigatória, dump citado existente; vale com o plano em `sem prova`.
  - **A4:** campo `**Corrige:** T-nnn` e `### Testes herdados` na §6 (regra 31 do plano); o `plan.ps1` reprova plano de correção sem a seção, aceita `nenhum — <motivo>`; plano comum não é afetado.
- **B · verificador** (`verify.ps1`, `guards.json` modelo, `team-update.md` 7h):
  - **B1:** `verify.focused` aceita lista de objetos `{ command, paths, testRoot, testItem }`; o comando sai do caminho do teste (casamento de glob dos hooks), no focused e na mutação (linha de base e mutantes). `guards.json` antigo (texto ou lista de textos) se comporta como antes.
  - **B2:** `tests 0` do `node:test` (TAP e `ℹ`) e `Could not find '…'` são inconclusivo.
- **C · padrão de ids** (`standards/test-ids.md` novo, perfis Angular, React e Kotlin/Android, `lib.ps1`, `web.ps1`, `android.ps1`, `ids.ps1` novo):
  - **C1:** gramática única (kebab-case com `.`, `primeiro`/chave, nunca índice, nenhum id de linha prefixo de outro), tabela de padrões, quais elementos levam id; o atributo muda por alvo (`id` no híbrido, `data-testid` na web, `testTag` no Compose).
  - **C2:** `guards.json → testIds.attribute` (precedência: ele, `targets.web.testIdAttribute`, `data-testid`); o alvo web o usa; o android já localiza pelo `resource-id` puro do WebView.
  - **C3:** `Find-UntaggedUi` enxerga os controles do Ionic (`ion-tab-button` isento), `ion-item`/`li`/`tr` de lista (`*ngFor`/`@for`) e a raiz de `*.page.html`; reconhece `id=`, `[id]=`, `[attr.id]=`. React e Compose: raiz fica ao QA.
  - **C4:** plano (P3 `medido: dump`, ids pelo mapa) e README do QA (cenário por id, texto só em tela de fora).
  - **C5:** `ids.ps1 -Map` grava `.team-project/architect/ids-map.md` (gerado do código; dono Arquiteto em `ownership.json` e `artifact-ownership.md` §1).
- **D · cliente:** `ids.ps1 -Audit` (só leitura, sempre exit 0; seis seções) e `team-update.md` 7l (resume em até 6 linhas, dois formulários: atributo e retrofit como Habilitadora; não edita código, plano aprovado nem `.scn`); `team-init.md` 4a escolhe o atributo.
- **F · comandos do run** (`plan.ps1`, `run.ps1`, `lib.ps1`, `hooks/common.ps1`, `pre-tool.ps1`):
  - **F1:** `### Comandos da Task` na §7 (regra 32); `plan.ps1` confere cada trecho contra a lista base da G14 + `runCommands` + reparo (o mesmo casamento por prefixo, que passou do `pre-tool.ps1` para o `common.ps1`); instalação, rede, push e destrutivo reprovam.
  - **F2:** `run.ps1 next`/`start` param **uma vez** com os faltantes de todos os planos da História; `run.ps1 allow -Commands … [-Deny …] -By …` grava em `runCommands` (resto do arquivo intacto) e no `run-log.md`; o decidido não é perguntado de novo; negado volta ao Arquiteto.
  - **F3:** a mensagem da G14 aponta o formulário único (`<ID> 🔺 comando: <prefixo>`). A lista da G14 não muda.
- **G · app híbrido em emulador de container:** caminho documentado (serial de rede, `id`, `baseline`) em `standards/test-ids.md` §6, README do QA e `how-to.md`; limite: WebView sem `id` no dump fica `[PARCIAL]`, sem `adb input` livre. Sem driver por CDP.
- **Documentos:** `working-rules.md` R4, `sprint-run.md`, `fix-run.md`, `task-runner.md`, `how-to.md`, `hooks/COVERAGE.md`, `implementation-plan.md` (regras 31 e 32, P3), `plan-rules-why.md`, entrada v3.55 no process-changelog (a v3.52 foi arquivada, R17).
- **Recusados (decisão do stakeholder):** mutação manual do dev como evidência de R7-margem; dispensar a trava para teste da própria Task. A ida da T-072b ao Arquiteto foi correta pelo processo.

Conferências 380/0 (+33), guardas 287/0 (+1), C3 ok. **Não testado:** o `accept` num emulador real com `testIds.attribute = "id"` (o item G só fecha na fila quando essa prova rodar); o `ids.ps1 -Audit` no garden real (os testes usam uma árvore de teste); o formulário único do `run.ps1` numa sessão real (os testes cobrem `start` e `allow`). **Riscos:** a heurística de lista web limita-se a `ion-item`/`li`/`tr` com `*ngFor`/`@for` (card em `div` fica ao QA); a raiz da tela só é conferida em `*.page.html`; o prefixo que o `run.ps1` sugere para `runCommands` (até 3 palavras) pode ser mais largo que o desejado (`node`) e o stakeholder o ajusta no formulário; o `marketplace.json` não traz versão, então só `plugin.json`, CHANGELOG e README foram atualizados.
## v3.54.2 — 2026-11-05

**Branch:** `fix/v3.54.2` empilhada sobre `fix/v3.54.1` (ainda não mesclada) · **Processo:** addendum v3.54.2 (accept que para no estado de partida, progresso visível, quadro em dia)
Origem: pontos 3 e 4 da carta da sessão do sprint 5 do garden (T-063 e o quadro, 05/11); o stakeholder aprovou D, E, F e G em 05/11.

Mudanças:
- **D · accept para no estado de partida** (`accept.ps1`, `run.ps1 done`, `mark.ps1`):
  - os 2 primeiros cenários falham na mesma tela (tela e textos do `[tela: …]`) e nenhum passa: o accept para com exit 4, "ESTADO DE PARTIDA" e `startState` no `result.json`; o resto não roda. Na T-063, 7 cenários × ~7 min falharam na introdução;
  - o `done -Result env` lê o `startState`: sem reparo do emulador e com bloqueio "estado de partida — <tela>", sem a etiqueta da prova pendente, então o `next` não o reabre; o formulário ao stakeholder traz a captura e oferece o `baseline` ou o ajuste do cenário.
- **E · progresso durante o accept** (`accept.ps1` `progress.json`, `lib.ps1` `Get-AcceptProgress`/`Get-TaskWait`, `run.ps1 next`):
  - a cada cenário, o accept grava quantos passaram, quantos falharam seguidos e o último (detalhe com a tela em texto e a captura);
  - a espera no `next` e no `/team-status` mostra isso. Nenhum passou em 15 min, com 2 falhas ou mais: **SEM AVANÇO**, com o mesmo tratamento do POSSÍVEL TRAVAMENTO. Antes, a captura de falha contava como sinal de vida.
- **F · estado de partida declarável** (`targets.android.baseline`): o nome de uma massa de `seeds`, aplicada depois de instalar o APK e depois de cada `reset`; o `-ParseOnly` reprova baseline que não é massa declarada.
- **G · quadro em dia** (`kanban.ps1`, `lib.ps1` `Get-BlockLines`/`Get-TargetRetakeCount`, `run.ps1 next`):
  - Task sem marcador (entrada fora da Planning, divisão) aparece em ⬜ A fazer; antes, sumia até a primeira transição;
  - a 🔴 mostra o motivo curto ao lado (a última linha dela em Bloqueios);
  - reabertura automática pelo alvo de volta **uma vez**: a Task já reaberta (linha "prova no alvo retomada") que cai de novo fica 🔴 e vai ao stakeholder com a última falha do accept. A T-063 foi e voltou duas vezes, um operator em cada.
- **Documentos:** `how-to.md` (serial de rede, baseline, accept que para cedo, reabertura uma vez), `sprint-run.md`, `agents/task-runner.md`, README do QA, addendum no process-changelog.
- **Recusados:** tipos de bloqueio (a dependência vai na coluna "Depende de") e a sessão abrir a captura (a tela vai em texto no `next`).

Conferências 347/0 (+10), guardas 286/0, C3 ok. **Não testado:** o accept num emulador real. O teste extrai as funções do `accept.ps1` e simula os cenários; o `baseline` aplicado de fato e o `progress.json` foram vistos só por esse teste. **Riscos:** um defeito real do app que deixe a tela inicial sem o id esperado também cai em "estado de partida", e vai ao stakeholder com a captura em vez de ir ao dev. A tela em texto (`[tela: …]`) só existe nas falhas do Android que procuram um id: `assert-text` e o alvo web não acionam a parada cedo.

## v3.54.1 — 2026-11-05

**Branch:** `fix/v3.54.1` a partir de `develop` (com a v3.54.0 mesclada pelo PR #119) · **Processo:** addendum v3.54.1 (alvo que se religa, margem stub, plano reconferido no meio da construção)
Origem: carta da sessão do sprint 5 do garden ao dono do plugin (T-063, 04–05/11); o stakeholder aprovou os itens A, B e C em 05/11.

Mudanças:
- **A · emulador de rede se religa** (`targets/android.ps1`; `sprint-run.md`):
  - serial `host:porta` fora do `adb devices`: o pré-voo roda `adb connect` antes de reprovar. Porta recusada → "o emulador (ou o container dele) está fora"; conexão aceita com o aparelho `offline` → "iniciando ou travado"; religado → segue a conferência (tempo ligado, memória). Na T-063, o container estava no ar havia 9 h e só a conexão do `adb` tinha caído;
  - o reparo declarado espera com um laço de `adb connect`, porque o `wait-for-device` não religa serial de rede (era o "não voltou em 180 s"); a espera do boot religa se a conexão cair;
  - antes do formulário de bloqueio de ambiente, a sessão roda `target.ps1 -Target <alvo>` e cita a linha dele.
- **B · plano reconferido no meio da construção** (`plan.ps1`, `run.ps1`):
  - a `- Contagem:` vale pela árvore de trabalho **ou** pelo último commit (HEAD). Antes, reconferir o plano com o código no meio reprovava sempre;
  - `run.ps1 start` recusa plano acima de 30 KB. Com a construção começada, o Arquiteto substitui o trecho que a decisão derrubou e a Task não se divide; antes dela, divisão pelo `next`. O prompt do GAP manda substituir, não acrescentar, e rodar o `plan.ps1`.
- **C · margem stub** (`hooks/test-files.ps1` `Test-MountingSpec`, G9, `close.ps1` R7-margem, `lib.ps1` `Get-MarginAdjustments`, commit da Task):
  - teste que já existe, fora da lista, que cita um arquivo de produção do plano: a G9 libera a edição; o dev acrescenta o stub da dependência nova e registra `- A<k> · stub · `<teste>` · <a dependência>`;
  - o `close` reprova teste assim alterado sem a linha e o stub em teste que não monta nada do plano; o commit da Task inclui os testes da margem stub; o QA confere que só o stub mudou. Na T-063, 29 casos em dois specs foram ao Arquiteto por isso.
- **Documentos:** `implementation-plan.md` (regras 22 e 30: substituir no GAP; `- Contagem:` dos testes que montam o componente com dependência nova), `agents/developer.md` (regra 1), `delivery-report.md`, `working-rules.md` R4, README do QA, `sprint-run.md`, addendum no process-changelog.

Conferências 337/0 (+13), guardas 286/0 (+4), C3 ok. **Não testado:** `adb connect` contra um emulador real em container (o teste usa adb falso), o fluxo de stub numa sessão real. **Riscos:** a G9 reconhece "teste que monta" pelo nome do arquivo de produção citado no teste; import por barril (`'../pages'`) não é reconhecido e continua indo a 🔺 GAP. O teste do garden que passava sozinho e falhava na suíte (152 × 160 px) sugere estado vazando entre testes; isso é do projeto, não do plugin.

## v3.54.0 — 2026-11-04

**Branch:** `fix/v3.54.0` a partir de `develop` (com a v3.53.7 mesclada pelo PR #117) · **Processo:** v3.54 (mutação pela regra e margem do dev; R4 ganha a margem; bloco v3.51 arquivado)
Origem: os dois pontos do relatório de encadeamento do sprint 5 do garden que ficaram para decisão na v3.53.7; o stakeholder decidiu em 04/11 seguir com os dois.

Mudanças:
- **Mutação pela regra, trecho do dev** (`lib.ps1` `Get-Mutations`/`Get-DeliveryText`/`Get-TaskMutations`, `verify.ps1`, `plan.ps1`, `fix.ps1`):
  - o plano declara `- M<k> · teste `<t>` · `<produção>` · regra: <o que a mutação quebra>`; o dev escreve `- M<k> · … · `<trecho>` → `<mutante>`` no bloco `**Mutações:**` do relatório de entrega (sprint: `delivery/<T-ID>.md`; fix: a seção `## F-<nnn>`), e a última linha com o mesmo M<k> vale;
  - `verify -Mode mutation` (e `-Precheck`) roda a linha do dev; sem ela, ou com outro teste/arquivo, a mutação sai `inconclusivo` dizendo o que escrever; trocado o trecho na mesma árvore, a mutação roda de novo; o registro guarda `rule`, `find` e `replace` para o QA;
  - o `plan.ps1` reprova o trecho literal que ainda não existe no código (arquivo novo ou trecho que a Task vai escrever) — no maior plano do sprint 5 eram 19, adivinhados — e a `regra:` vazia; literal com trecho que já existe uma vez continua valendo.
- **Margem do dev** (`close.ps1` R7-margem, bloqueante; `lib.ps1` `Get-MarginAdjustments`):
  - o dev corrige sem 🔺 GAP o defeito mecânico do próprio teste e o CSS cujo valor uma regra do projeto já define, e registra em `### Ajustes na margem` (`- A<k> · teste · `<arquivo>` · <o que mudou>` / `- A<k> · css · `<arquivo>` · <o que mudou> · regra: <onde>`);
  - o `close` só fecha com as travas: arquivo em **Arquivos tocados:**; teste ajustado com mutação no plano, pega na árvore do verify full; CSS com a regra citada; linha fora do formato reprova. Na maior Task do sprint 5, 3 das 4 decisões de GAP eram desses dois tipos.
- **Documentos:** `implementation-plan.md` (§6, regras 18 e 30, exemplo), `plan-rules-why.md`, `fix-plan.md`, `external-plan.md`, `external-fix-plan.md`, `delivery-report.md`, `agents/developer.md` (regras 1 e 6), `working-rules.md` R4 e o índice, README do QA (frente 2), process-changelog v3.54 (v3.51 arquivada).

Conferências 324/0 (+7), guardas 282/0, C3 ok. **Não testado:** o fluxo numa sessão real (dev escrevendo a linha da mutação e o ajuste na margem). **Riscos:** o QA é quem julga se a mutação do dev ataca a regra declarada — uma mutação "pega" que muda outra coisa passa pelo script; a margem de teste vale só em teste com mutação, então teste de `interface simples` sem mutação continua indo a 🔺 GAP.

## v3.53.7 — 2026-11-04

**Branch:** `fix/v3.53.7` a partir de `develop` (com a v3.53.6 mesclada pelo PR #115) · **Processo:** addendum v3.53.7 (prova pela camada certa, premissa de layout medida, decisão do sprint num lugar só)
Origem: relatório "Encadeamento plano, construção e QA — sprint 5" do garden, 04/11, e as decisões do stakeholder de 04/11 (resolver: matriz de prova, premissa de layout lida, decisão colada em vários planos, checagem do alvo antes do accept; manter: teto do plano em 30 KB e a QA do fim como está). O contrato de ids "feito uma vez" já não tem voltas desde a v3.53.6 (o id do `.scn` é o pedido ao dev, e o `verify` reprova o que falta); a checagem do alvo já tinha memória, idade do APK, reinício no 1º accept e launch do zero — faltava a massa de dados.

Mudanças:
- **Escolher opção e carregar massa no cenário** (`accept.ps1`, `targets/android.ps1`, `targets/web.ps1`, `web-runner.js`, `lib.ps1` `Get-TargetSeeds`/`Invoke-TargetSeed`):
  - `select <id> = <opção>`: toca o combo, a lista suspensa ou o seletor, escolhe pelo texto visível (fora do próprio controle; rola a lista aberta se preciso) e confirma se o seletor abriu um diálogo com botão (`targets.<alvo>.selectConfirm`, padrão `^(OK|Ok|Confirmar|Concluir|Pronto|Aplicar|Done)$`); na web, `<select>` nativo pelo rótulo. No sprint 5, o caso central da Task de canteiros ficou sem cenário porque a linguagem não escolhia opção;
  - `seed <nome>`: roda o comando de `targets.<alvo>.seeds.<nome>` (PowerShell, na raiz, prazo `seedTimeoutSec` 300 s, com `ACCEPT_TARGET`, `ACCEPT_SEED` e `ACCEPT_SERIAL`/`ACCEPT_PACKAGE` ou `ACCEPT_URL`); falhou = FALHA DE AMBIENTE (exit 4), não defeito do app. O `reset` zerava a base e o cenário rodava sem os dados;
  - pré-avaliação: o `accept -ParseOnly` do QA reprova `select` sem `=`, `seed` sem nome e **massa não declarada** no alvo — antes de qualquer aparelho.
- **Prova pela camada mais barata** (README do QA): antes do cenário de aparelho, o QA decide a camada que prova o critério (unidade, serviço ou render vão `(teste)`); o que fica no aparelho diz o estado de partida e a massa (`reset`, `seed`, `launch`); gesto que a linguagem não tem desce para `(teste)` na hora.
- **Premissa de layout medida executando** (`plan.ps1` regra 26, `implementation-plan.md`, `plan-rules-why.md`): com `**Layout novo:** sim`, premissa de geometria (posição, tamanho, sobreposição, margem, rolagem, popover…) cujo `medido:` não executou nada — `Grep`/leitura, inclusive de `node_modules` — reprova; a saída é a sonda de render do operator (`operator/<n>/<T-ID>-plano/`) ou `não exercitada … · verifica: dev em <passo do render>`. No maior plano do sprint 5, 9 premissas saíram da leitura do código do Ionic e as 4 decisões de GAP da Task vieram do render real.
- **Decisão do sprint num lugar só** (`plan.ps1` regra 29, `lib.ps1` `Get-SprintDecisions`/`Get-TaskDecisionLines`/`Get-DecisionsDigest`, `run.ps1`, `external-plan.ps1`, `implementation-plan.md`, `technical-decision.md`, `architect.md`, `developer.md`):
  - decisão de 🔺 GAP que vale para mais de uma Task vai **uma vez** em `.team-project/architect/decisions/S<n>.md` (`## D-<k> — <título>`, `**Vale para:** todas | T-…`); o plano a cita em `**Decisões do sprint:**`;
  - o `plan.ps1` reprova citação de D inexistente e a linha da decisão copiada no plano;
  - o cartão do dev traz as que valem para a Task (todas, as que a citam e as que o plano cita), uma linha cada; o recorte da ficha e o pacote do plano externo trazem todas ao Arquiteto, para citar;
  - o prompt do GAP no `run.ps1 done` deixou de mandar "registrar também no plano" de cada Task afetada — era a origem das cópias: a mesma regra sobre emulador fora e teste instável estava em 8 planos.

Conferências 317/0 (+10), guardas 282/0, C3 ok. **Não testado:** `select` e `seed` num emulador ou navegador real (só o -ParseOnly e a função da massa); a sonda de render do operator numa sessão real. **Riscos:** a premissa de layout é reconhecida por vocabulário (px, margem, sobreposição, popover…) — afirmação de geometria com outras palavras passa; o botão de confirmação do `select` é achado pelo texto, e um "OK" de outra parte da tela só é tocado se o seletor ainda estiver aberto.

## v3.53.6 — 2026-11-04

**Branch:** `fix/v3.53.6` a partir de `develop` (com a v3.53.5 mesclada pelo PR #113) · **Processo:** addendum v3.53.6 (Task grande se divide, prova pendente bloqueia, cota em vez de US$)
Origem: relatório do sprint 5 (parcial) do garden ao dono do plugin, 03/11, e as decisões do stakeholder de 04/11 sobre cada item. Do relatório, três itens não viraram mudança: o item 8 (executor devolvendo antes do dev) já estava corrigido na v3.53.3; o item 7 tinha a causa errada (o `accept` já reinstala o APK mais novo do disco — o APK em disco é que era mais velho que o código); o item 10 usou preços de outros modelos (Opus 5, Sonnet 4.6, Haiku 4.5) e o `consumption.ps1 -Session` já mede a sessão principal.

Mudanças:
- **Plano acima de 30 KB reprova e a Task se divide** (item 1; `plan.ps1`, `lib.ps1` `$PlanMaxKb`/`Get-PlanKb`, `run.ps1`, `external-plan.ps1`):
  - desde a v3.53.2 o tamanho só avisava, e os 4 planos acima de 30 KB do sprint (60, 46, 34 e 33 KB) foram inteiros ao dev — os dois maiores tiveram 6 cortes da G23 e 3 GAPs;
  - a regra 22 agora reprova acima de 30 KB, com a mensagem de **não cortar, não encurtar nem corrigir as outras linhas** (o corte da v3.53.2 custou metade do plano da T-042);
  - o `run.ps1 next` leva a Task à mesma divisão da ficha grande (instância curta do Arquiteto, IDs com sufixo), com os blocos do plano grande como base: cada ficha nova leva `**Base:** \`<plano>\` — <blocos/passos>` e o Arquiteto da Task nova reaproveita esse trecho;
  - no plano externo, o plano grande devolvido vai à divisão, não a um pacote de correção, e o plano de origem vai junto no pacote seguinte.
- **Cartão da G23 com os passos que faltam** (item 2; `run.ps1` `Get-RemainingSteps`/`Write-Handoff`, `developer.md`, `task-runner.md`): com `### Parei no passo`, o cartão da instância nova traz o que já está provado (até 2 KB) e os passos do plano do ponto de parada até o fim do bloco (até 8 KB; acima, o ponteiro para o resto). O prompt manda seguir pelo cartão e não reabrir o plano.
- **Ids de teste são padrão de código** (item 4; `verify.ps1`, `lib.ps1` `Get-TestIdFindings`, `standards/stacks/*/guide.md` e `quality.md`, README do QA). Pedido do stakeholder: "nunca mais termos problema durante as rotinas de QA". No fim do `verify -Mode full`, a chave `testids` reprova (exit 1) quando:
  - (a) um id citado pelos cenários de tela da Task (sem `(teste)` e sem `# aguarda` de outra Task) não existe no código de produção — constante e prefixo de id dinâmico valem; a saída traz o id, o cenário e o `.scn:linha`;
  - (b) um controle interativo dos arquivos da Task não tem id — Compose (`Button(`, `TextField(`, `Checkbox(`, `.clickable`, `items(` de lista…) sem `testTag(`, web (`<button`, `<input`, `<select`, `<textarea`, `<a` com ação) sem `data-testid`; a saída traz `arquivo:linha`;
  - exceção explícita na linha ou na anterior: `// sem-testid: <motivo>` (ou `{/* … */}`, `<!-- … -->`), com motivo obrigatório.
- **Emulador em container mais limpo** (item 5; `targets/android.ps1`, `accept.ps1`):
  - `targets.android.memoryCmd` + `maxMemoryMB`: o pré-voo lê a memória do emulador por um comando do projeto (ex.: `docker stats`) e, acima do limite, o reparo roda — no sprint 5, o qemu chegou a 13,5 GB de RSS após 5h20;
  - **reinício no primeiro `accept` de cada Task** (decisão do stakeholder): com `targets.android.repair` declarado, o primeiro `accept` da Task roda o reparo antes da rotina (marca `fresh-start.json` na pasta do accept da Task); `freshStart: false` ou `-NoRepair` desligam.
- **G14 libera o alvo** (item 6; `hooks/pre-tool.ps1`): os scripts de conferência do plugin passam também nas formas `& <caminho>\x.ps1` e `<caminho>\x.ps1` (e com `$env:CLAUDE_PLUGIN_ROOT`), e cada trecho do comando declarado em `targets.<alvo>.repair` entra na lista operacional do run — no sprint 5, o operator fez o reparo à mão e a Task voltou sem prova.
- **APK mais velho que o código reprova o `accept`** (item 7; `Get-ApkStaleness`): antes de instalar, o `accept` compara o APK com o fonte mais recente do módulo (`src/`, `res/`, manifesto, `build.gradle`); fonte mais novo → exit 2 "reconstrua (assembleDebug) antes do accept". Módulo que não se infere: só a nota.
- **Prova no alvo pendente bloqueia a Task** (item 9; `close.ps1`, `mark.ps1 -Reason`, `lib.ps1` `Get-TargetPendingIds`, `run.ps1`): "nenhum aplicável" por alvo fora do ar reprova a R30 e a R7-aceite no `close`; o `done -Result env` com o accept parado por ambiente imprime `mark.ps1 -To blocked -Reason "prova no alvo pendente — <motivo>"`, que grava a linha em Bloqueios; a cada `next` sem Task em construção, o alvo é conferido e, de volta, a Task sai de 🔴 para 🟪 e o operator roda o accept pendente (a linha vira "prova no alvo retomada"). No sprint 5, 3 Tasks fecharam ✅ sem prova no aparelho.
- **Consumo pela cota da assinatura, sem US$** (item 10; `scripts/statusline/quota-statusline.ps1`, `consumption.ps1`, `team-view.ps1`, `templates/consumption.md`):
  - a status line do plugin mostra `<modelo> · 5h 37% (reinicia 14:20) · semana 12%` e grava cada mudança da cota em `%USERPROFILE%\.claude\quota-log.jsonl` (global: a cota é da conta). É o único lugar documentado do Claude Code que expõe a cota (`rate_limits` do JSON da status line); hooks, OTEL e CLI não a expõem;
  - o `consumption.ps1` tira o US$ e rateia a subida da cota (5h e semanal) entre as rodadas ativas em cada intervalo, pelos tokens ponderados por modelo (pesos iniciais = razão de preço da API, só como aproximação; `.team-project/quota-weights.json` troca); saem a coluna Cota 5h / Cota semana nos Totais, a nota `cota 5h +x% · semana +y%` por rodada e a seção **Cota da assinatura** (por modelo, por Task, total da semana no sprint e a calibração % por milhão de tokens nos intervalos com um modelo só);
  - o `/team-usage` mostra tokens, tempo, % dos tokens por papel e a cota atual com a subida da semanal desde a 1ª rodada do sprint.

Conferências 307/0, guardas 282/0, C3 ok. **Não testado:** divisão por plano grande e cartão de retomada numa sessão real; reinício do container, memória e idade do APK num emulador real (só as funções puras); a status line numa sessão real (os campos de `rate_limits` vêm da documentação). **Riscos:** a detecção de controle sem id é por padrão de texto (componente que repassa o `modifier` do chamador e `@Preview` pedem a exceção; template inline do Angular não é lido); a cota rateada fora do close/retro inclui a sessão principal nas rodadas; uso da conta fora do plugin cai nos mesmos intervalos.

## v3.53.5 — 2026-11-02

**Branch:** `fix/v3.53.5` a partir de `develop` (com a v3.53.4 mesclada pelo PR #111) · **Processo:** addendum v3.53.5 (espera com sinal de vida)
Pedido do stakeholder, no sprint 5 do garden: acompanhar as paradas longas para saber se são travamentos, e mostrar no `/team-status` a Task em execução e há quanto tempo ela roda. O que estava acontecendo, medido no projeto:
- o reparo do alvo (`target.ps1 -Repair`, pid 2032) ficou **81 min parado, com 1 s de CPU**, à espera de `adb emu kill`;
- a causa eram **dois emuladores nas mesmas portas 5554/5555**: o AVD local `horta-api35`, aberto por um reparo anterior, e o container `horta-emulador`;
- a trava do alvo tinha dono `target.ps1 android`, que o `Get-TaskBusy` não via, então o `next` mandava disparar outro executor, cujo `accept` ficaria até 3 h barrado;
- a G20 barrou **43 fins de turno num dia, todos na T-042** (a primeira elegível do quadro), enquanto o `next` mandava esperar a T-061.

Mudanças:
- **`adb` com prazo** (`targets/android.ps1`):
  - toda chamada passa por `AdbT` com tempo máximo: 90 s por padrão, 30 s no `devices`, 20 s no `emu kill`, 600 s no `install`, 180 s para o aparelho voltar depois do reparo e 15 s por consulta do boot;
  - ao estourar, o `adb` é encerrado e o comando fica em `$script:AdbTimeout`;
  - a saída vem em UTF-8;
  - no pré-voo, um `adb` que não responde vira "servidor do adb travado".
- **Um emulador só:**
  - no reparo pelo AVD local, se as portas 5554/5555 estão com outro processo (Docker), o plugin recusa abrir um segundo emulador e manda declarar `targets.android.repair` sem o `avd`;
  - `targets.android.serial` (opcional) fixa o aparelho de trabalho;
  - sem `serial` e com mais de um aparelho no `adb devices`, o pré-voo pede o `serial` em vez de falhar com "more than one device".
- **Sinal de vida da espera** (`lib.ps1`):
  - `Get-WaitPulse` lê, sem gravar nada, há quanto tempo o comando roda, a CPU da árvore de processos, o processo mais fundo (onde de fato espera) e a última gravação na pasta do job;
  - 10 min ou mais sem CPU nem arquivo novo = `POSSÍVEL TRAVAMENTO`.
- **`Get-TaskWait` / `Get-TaskBusy`:**
  - além do `verify` e do `accept` da Task, o reparo do alvo também segura a Task: vale qualquer dono da trava, menos o `accept` de outra Task;
  - o texto traz o sinal de vida;
  - o `Enter-TargetLock` também traz o sinal de vida e, se o dono parece travado, diz como sair em vez de "espere" por até 3 h.
- **`run.ps1`:**
  - o `next` mostra o sinal de vida em cada espera e, com `POSSÍVEL TRAVAMENTO`, manda levar ao stakeholder: encerrar o processo (decisão dele) e retomar por dev novo, ou seguir esperando;
  - a decisão de esperar vai em `.team-project/.next-verdict`, que cada `next` apaga ao começar;
  - o `done` com `ESPERANDO` também grava a decisão.
- **G20** (`hooks/stop.ps1`): segue a decisão "esperar" do `next` por 30 min. Mais velha que isso, barra de novo e a sessão roda o `next`. A Task citada é a do `.active-task` quando ela está elegível.
- **`/team-status`** (`team-view.ps1`) ganhou a seção **Em execução**:
  - a Task do `.active-task` e há quanto tempo roda desde o último `start`;
  - o último sinal de vida (agente, `verify`, `accept`, relatório);
  - o comando em espera, com o sinal de vida;
  - `⚠ PARADA` quando o run está em andamento e nada roda para a Task há 20 min, ou `run pausado`;
  - sem Task em construção, a última Task trabalhada.
- **Documentos:**
  - `how-to.md`: exemplo e leitura do "Em execução", um emulador só, `serial`, prazo do `adb`, e um exemplo de `repair` que não duplica o aparelho (o `adb connect localhost:5555` do exemplo anterior punha o mesmo emulador duas vezes no `adb devices`);
  - `sprint-run.md` passo 5 da construção;
  - `COVERAGE.md` (G20);
  - addendum v3.53.5 no `process-changelog.md`.
- **Testes:** conferências (blocos 16e e 16f: reparo do alvo segura a Task, `POSSÍVEL TRAVAMENTO` com 25 min e sem ele com 1 min, `.next-verdict` gravado e apagado, "Em execução", `PARADA` e run pausado, `adb` encerrado no prazo) e guardas (G20 com a decisão de 2 min e de 45 min, Task em construção citada).
- **No garden, fora do plugin** (pedido do stakeholder):
  - o AVD local `horta-api35` foi removido e o container `horta-emulador` ficou como o único emulador;
  - `docker/emulator-repair.ps1` e `docker/emulator-fix.sh` corrigem três defeitos da imagem `budtmo/docker-android` que impediam o emulador de subir depois de um `docker restart`: o `sed '1d' /etc/passwd` que apaga o root, a trava `/tmp/.X0-lock` do Xvfb e as travas do AVD;
  - medido: três partidas seguidas em 52 a 69 s.
- **Não testado:** o `POSSÍVEL TRAVAMENTO` de um `verify` que trava depois de muita CPU, porque a média da CPU no período inteiro o esconde (o último arquivo gravado ainda aparece); e a sessão real levando o formulário ao stakeholder.

## v3.53.4 — 2026-11-02

**Branch:** `fix/v3.53.4` a partir de `develop` (com a v3.53.3 mesclada pelo PR #109) · **Processo:** addendum v3.53.4 (plano externo)
Pedido do stakeholder: tirar do limite da conta Claude o trabalho que mais pesa, aproveitando os controles, as guardas e os scripts que o time já tem. No sprint 5 do garden, o Arquiteto (Opus) custou US$ 66,77 de ~US$ 100 (planos 38,2 · retrabalho 28,6), contra US$ 3,13 do dev. O plano é o trabalho que mais pesa e o que mais fácil se separa: entra um recorte pequeno (a ficha), sai um arquivo, e o `plan.ps1` o confere sem saber quem o escreveu.
- **Opção do projeto:** `guards.json` → `"run": { "planner": "external", "tasks": [] }`, desligada por padrão (`"claude"`, também no modelo do `guards.json`). `tasks` vazio = todas as Tasks com ficha; com IDs = só elas, para o piloto (`Get-RunPlanner`, `Test-ExternalTask` no `lib.ps1`).
- **Pacote por História** (`run.ps1 next`, funções em `scripts/checks/external-plan.ps1`): no preparo, a Task com ficha não vai ao Arquiteto Opus. A ficha se confere antes, como antes do Opus (Task grande se divide, caminho que não existe se corrige). O `next` monta `sprints/<n>/pack/out/<H-ID>/` e o `<H-ID>.zip` (nomes com `/`):
  - `INSTRUCTIONS.md`, do modelo novo `roles/architect/templates/external-plan.md`: o papel, o nome exato de cada retorno, a ordem pelas dependências e o que o `plan.ps1` recusa;
  - as fichas, com o resumo do plano das dependências de fora do pacote;
  - o modelo do plano, o contexto do Arquiteto, a §3 do plano mais recente do sprint como ambiente medido (quem está de fora não roda comando: o que não foi medido vira premissa, nunca saída inventada), os `.scn` e a História;
  - os arquivos que a ficha aponta (`files/`, `files/plugin/`).
- **Espera sem custo:** a Task que já estava em construção segue. Sem ela, o `next` sai com exit 3 `PRÓXIMA AÇÃO: external plan`, dizendo onde pegar (`out/`) e onde devolver (`in/`), e grava `.team-project/.external-plan`, que libera a G20 (`hooks/stop.ps1`). O próximo `next` apaga a marca.
- **Retorno conferido:** o `next` lê `pack/in/` (zip ou `<T-ID>-plan.md` solto, também `T-ID-plan (1).md` do navegador):
  - cada plano passa pelo `plan.ps1` no lugar dele (`plan/`, com o nome que a Planning pôs na coluna Plano);
  - aprovado: o link vai à coluna Plano do quadro e a Task segue à construção;
  - reprovado: sai de `plan/`, vai a `pack/review/` com a tabela, e o pacote de correção (`<H-ID>-fix1.zip`) leva só as Tasks recusadas;
  - qualquer outro arquivo é ignorado, e nada entra no projeto além do plano;
  - o arquivo lido vai a `pack/done/`, e o run-log registra o pacote, a recusa e o aceite.
- **🔺 GAP da Task do plano externo:** o `run.ps1 done -Result gap` monta `<T-ID>-gap.zip` (plano atual, relatório do dev, diagnóstico do alvo) em vez de chamar o Arquiteto. A Task não se constrói nem se retoma até a decisão voltar no plano e passar pelo `plan.ps1`. O executor devolve `<T-ID> 🔺 GAP → external plan <pacote>` (`agents/task-runner.md`).
- **Trilha fix, sem mudar a estrutura** (pedido do stakeholder; refazer o fix como o sprint, com o plano dentro do run, foi descartado: no modo `claude` ele dobraria o uso do Opus por Correção e levaria as promoções de C5–C8 para o meio do run):
  - `scripts/checks/fix-pack.ps1`: no passo 4 do `/sm fix plan`, monta `fixes/B-<nnn>/pack/out/B-<nnn>.zip`. Leva o roteiro novo `roles/architect/templates/external-fix-plan.md`, as fichas, os arquivos que a reprodução aponta, o `pending.md`, o modelo `fix-plan.md` e os comandos do `developer/context.md`;
  - o retorno (`B-<nnn>-plan.md`) passa pelo `fix.ps1 -PlanOnly`, um modo novo do C4 que confere o mini-plano pelas regras do `fix-plan.md`: data, seção por F-ID ou `**Devolvida:**`, 60 linhas, C5–C8, promoção com o critério, arquivos existentes, teste de regressão, mutação, 2 a 5 passos, Verificação do bloco e teto;
  - o `/sm fix plan` de novo retoma no passo 4. O 🔺 GAP no `fix run` vai em `F-<nnn>-gap.zip` e volta como `F-<nnn>-plan.md`: só a seção da F-ID muda, e as outras Correções seguem;
  - `run.tasks` aceita `B-<nnn>` e `F-<nnn>`. Atualizados: `fix-run.md` §Plan passo 4 e §Run passo 2, `commands/sm.md`, `fix-plan.md` (cabeçalho e regra 11), `agents/task-runner.md`, `how-to.md`, a matriz de donos (`fixes/B-<nnn>/pack/`) e o modelo do `guards.json`.
- **Documentos:**
  - `how-to.md` §Plano externo (ligar, o ciclo, o GAP, a trilha fix; o Claude na web na mesma conta usa o mesmo limite);
  - `sprint-run.md` §Disparo e espera, item 6;
  - `artifact-ownership.md` e `hooks/ownership.json`, com a pasta `pack/` (dono SM, gerada pelo script);
  - `hooks/COVERAGE.md`, com a G20 liberando a espera;
  - `note.md` item 14, para medir o piloto.
- **Testes:** guardas 270/0 (+1, G20 com `.external-plan`). C3 ok (R17 12.488 de 15.360 B). Conferências 268 casos (+22, seção 17):
  - **sprint:** o pacote e o conteúdo do zip; a espera com a marca; o retorno reprovado com arquivo estranho; a correção; o retorno aprovado no nome da Planning, com o link no quadro; o run-log; o GAP em pacote com a Task esperando; a decisão aceita; o piloto por lista; `planner: claude`.
  - **fix:** a recusa sem a chave; o pacote só com as F-IDs em bloco; a espera; o plano do bloco reprovado, com o código de fora ignorado; o aprovado; o GAP em pacote; a espera da F-ID; a decisão que troca só a seção dela; o `-PlanOnly` com promoção válida e com ✘ sem critério.
- **Não testado:** o pacote num assistente real (app do Codex ou chat na web) e o retorno dele. Os testes montam o retorno à mão.

---

## v3.53.3 — 2026-11-02

**Branch:** `fix/v3.53.3` a partir de `fix/v3.53.2` (mesclada em `develop` pelo PR #107) · **Processo:** addendum v3.53.3 (construção e prova sem retrabalho; o título do bloco v3.53 passa a declarar Dev e QA)
Avaliação do meio do sprint 5 do garden, em 02/11/2026, com 4 de 16 Tasks fechadas. Até ali o sprint custou ~US$ 100: US$ 79,81 nos subagentes e US$ 20,34 na sessão. O Arquiteto ficou com 84 % do gasto dos subagentes (US$ 38,2 em planos e US$ 28,6 em retrabalho). O stakeholder via um conflito contínuo entre construção e QA. A QA custou só US$ 5,14; o custo veio de três ciclos de retrabalho em volta da prova. Os itens 1 a 5 foram aceitos:

- **1. O aceite no Android abre o app do zero:** as capturas de falha do sprint mostravam a **tela inicial do Android** (SC-146) e a **página Alertas** deixada pelo cenário anterior (SC-127). O `launch` usava o `monkey`, que só traz o app à frente na tela em que ele ficou; sem o app na frente, ele apertava HOME e saía sem erro. Todo passo dava "tag não encontrada", e o time leu isso como "APK sem os ids". Foram 3 GAPs ao Opus e 8 rodadas da QA na T-041, a T-059 parou no mesmo ponto e o SC-146 saiu da prova.
  - `launch`, `open` e `restart` agora fecham o app (`am force-stop`) e o abrem do zero. Os dados ficam, porque quem apaga é o `reset`.
  - O passo espera até 15 s o app ficar na frente, em 3 tentativas, sem apertar HOME. Se não ficar, o cenário para com **AMBIENTE** (exit 4). Uma janela de erro do próprio app ao abrir é falha do app.
  - "Tag não encontrada" e "tag ausente" trazem `[tela · ids · textos]` visíveis (`targets/android.ps1`, cabeçalho do `accept.ps1`).
- **2. GAP da prova no alvo vai ao operator antes do Arquiteto:**
  - O `run.ps1 done -Result gap` com GAP de aceite, alvo ou tag imprime o **operator** (Haiku). Ele abre o `result.md` e as capturas `*-falha.png` e grava `operator/<n>/<T-ID>-alvo/diagnostico.md` com `Veredito: AMBIENTE | APP | PLANO`.
  - O `done -Result gap` de novo segue o veredito: AMBIENTE vai à rota de queda de ambiente (reparo e dev novo); APP vai a um dev novo, com o diagnóstico no cartão; PLANO vai ao Arquiteto, com o diagnóstico no prompt.
  - GAP de desenho segue direto ao Arquiteto (`run.ps1`, `agents/operator.md` item 9, `agents/task-runner.md`).
- **3. Preparo de uma História por vez:** antes, o `next` só construía depois de preparar todas as Histórias, e as 15 Tasks estavam em 🟦 antes da primeira construção normal. A QA escreveu os `.scn` de quatro Histórias antes de existir a Task que cria os nomes de teste. O contrato dela cresceu 3× (~US$ 19 de Opus), e os planos já escritos ficaram velhos.
  - Agora a História preparada que tem Task a construir é construída antes de preparar a seguinte. A construção só pega Task de História já preparada.
  - A História com Task que depende de Task aberta de **outra** História vem depois dela. A ficha continua dando a sequência, e o plano de quem depende lê o resumo do plano da dependência e o código já construído (`run.ps1 next`, `sprint-run.md` passo 1).
- **4. Dev que espera um comando não ganha um segundo dev ao lado:** um comando que passa de ~180 s vai para segundo plano, e o dev encerra o turno esperando por ele. Para o executor, isso parecia a volta do dev, e ele rodava `done`/`start`. Na T-058 houve 3 devs; na T-059, o `accept` de uma instância anterior prendeu o emulador e o run pausou.
  - O dev volta com `ESPERANDO <comando>` na primeira linha, e o executor só encerra o turno.
  - `Get-TaskBusy` (lib) vê o `verify.lock` e a trava do alvo `accept <T-ID>` com processo vivo. Enquanto um deles existir, o `done` sai com exit 3 `ESPERANDO`, o `start` recusa com exit 2 e o `next` manda esperar (`agents/developer.md` regra 6, `agents/task-runner.md`, `sprint-run.md`).
- **5. Medir no sprint 6:** `note.md` item 13. Fica com os números de referência do sprint 5 (formulários de nomes de teste, ampliações do contrato, cenários tirados da prova, GAPs ao Arquiteto e devs duplicados), a fonte de cada um e o alvo. Nenhum agente novo.
- **Testes:** conferências 246 casos (+16), guardas 269/0, C3 ok.
- **Não testado:** o `launch` novo num emulador real (testado com `adb` falso, porque nenhum aparelho estava conectado) e o operator abrindo as capturas num run real.

---

## v3.53.2 — 2026-11-01

**Branch:** `fix/v3.53.2` a partir de `develop` · **Processo:** addendum v3.53.2 (R22: toda pergunta ao stakeholder em formulário; plano do Arquiteto sem corte por tamanho)
Três pedidos do stakeholder:
- Acompanhar o sprint pelo console ou pelo celular (Remote Control) sem gastar token. Até aqui, olhar o andamento passava pelo modelo (`/sm board`, `/po status`).
- Toda pergunta do time chega como formulário simples.
- Baixar o custo do Arquiteto, a partir do relatório prévio do sprint 5 do garden.

- **Plano do Arquiteto mais barato (relatório prévio do sprint 5 do garden):** até o início da construção, o Arquiteto já tinha gastado US$ 34,7 de US$ 41,3 do sprint (84%). Foram medidas as conversas de cada plano. As quatro respostas do stakeholder viraram estas mudanças:
  - **Sem corte por tamanho:** o teto de 20 KB virou alvo. Quatro planos saíram acima dele e foram cortados em dezenas de edições, cada uma relendo até 290 mil tokens. Isso custou ~US$ 9 do sprint e metade do plano da T-042 (US$ 4,39 de 8,70). O `plan.ps1` (regra 22) agora só informa o tamanho. Acima de 30 KB ele avisa **Task grande**, a dividir na quebra, e nunca pede corte. A correção que ele pedir sai numa reescrita só.
  - **Task grande se divide antes do Opus:** a ficha ganha `**Arquivos previstos:**`, com até 6 por Task (`breakdown.md` regra 7, `workflow-sprint.md` passo 4). Acima disso, o `run.ps1 next` não dispara o plano: ele pede a divisão a um Arquiteto curto, com IDs livres do quadro, e a sessão troca a linha do Sprint Backlog. O `plan.ps1` mostra o número previsto ao lado do número que está no plano.
  - **Ficha conferida antes:** o `run.ps1 next` confere os caminhos da ficha antes de chamar o Arquiteto do plano e pede a correção numa instância curta. Em **Fontes:**, um nome de classe entre crases deixou de contar como caminho (`Get-Ficha`). Rodada sobre o garden, a conferência já acha a ficha da T-062 com um arquivo citado sem a pasta.
  - **Ler o trecho, não o arquivo:** o resumo do plano da dependência (cabeçalho, arquivos e passos; ~1,5 KB contra ~20 KB, `Get-PlanSummary`) vai no fim do recorte da ficha. O prompt e a regra 28 mandam ler só o trecho apontado. Na T-042, três planos inteiros (~60 mil caracteres) eram relidos em todas as 69 chamadas.
  - **Estimativa:** o Arquiteto deve gastar 35–40% menos num sprint como o 5. A medição fica para o próximo sprint, junto com os GAPs de plano.

- **O que travou o run do sprint 5 do garden:** em ~8 h, 1 de 16 Tasks fechou, e era só a habilitadora. Das 19 decisões pedidas ao stakeholder, 11 vieram dos nomes de teste (D-S4-02 combinado e não feito). A T-071 entrou fora da Planning, subiu de 1,0 para 2,0 dias e foi planejada duas vezes. Mudanças:
  - **Modo de prova do cenário:** `SC-nnn (teste)` na coluna Cenários é provado pelos testes do plano (serviço, render, processo, gate). Ele não pede `.scn` ao `run.ps1 next`, nem `accept` ao `close.ps1` (R30 ok, R7-aceite n-a), e o `plan.ps1` (regra 23) não o procura no `.scn`. O cartão de passagem lista esses cenários à parte. O QA aponta o caso e a sessão marca, sem formulário (`Get-ScenarioIds`).
  - **Cenário que aguarda uma Task:** a linha `# aguarda <T-ID>: SC-…` no `.scn` faz o `next` adiar o cenário até a Task que cria os nomes de teste fechar, e segura só a Task que cita esse cenário (`Get-DeferredScenarios`). O `plan.ps1` conta esse cenário como declarado. Antes, o `next` exigia o `.scn` antes da Task que cria os nomes, e a sessão teve de pular a ordem à mão.
  - **Nomes de teste na Planning:** no `prepare` (passo 4), o QA marca o modo de prova e confere no código os nomes de teste dos cenários de tela. Na quebra da Planning, os nomes que faltam viram Task estimada, da qual dependem as Tasks que os usam (`workflow-sprint.md`, `sprint-backlog.md`, README do QA, `sprint-run.md`).
  - **`verify.ps1 -WaitBusySeconds <n>`:** com "OCUPADO" (uma rodada da Task ainda viva, de um dev que caiu), a mesma chamada espera a rodada acabar e segue. Antes, o executor pausava o run e o stakeholder tinha de retomar à mão (duas vezes no sprint 5). Atualizados `agents/developer.md` e o README do dev.
  - **`targets.android.repair`:** comando de reparo declarado pelo projeto, para emulador em container. O `target.ps1 -Repair` o roda, espera o aparelho e confere de novo. Antes, o reparo só conhecia o AVD local, e recriar o container pediu autorização (`how-to.md`).
  - **Não testado:** o `repair` com um container Docker real.

- **Toda pergunta em formulário (R22):** dado, confirmação e próximo passo agora também saem como formulário, na mesma resposta, e não só a decisão. Na pergunta aberta, as respostas prováveis viram opções e o campo "Outro" serve para digitar. "Pedir mais contexto" traz a explicação curta junto com o mesmo formulário. A linguagem é simples (termo técnico só quando é indispensável). A forma entra no contexto de toda sessão pelo `hooks/session-start.ps1`, mesmo com a G13 desligada. Assim a pergunta nasce certa, sem a volta a mais que uma guarda no fim do turno custaria. Mudaram `working-rules.md` R22, `templates/stakeholder-question.md` (exemplo de pergunta aberta) e `how-to.md`.

- **`/team-status [<n>]`:** mostra o placar do sprint por marcador, a estimativa restante (Série), o estado do run, o limite de conta e os agentes em voo, com o tempo desde a última ação. Também traz as Tasks por coluna (as em andamento primeiro), a última transição do Registro e as decisões pendentes do stakeholder (README §7, até 3).
- **`/team-usage [<n>]`:** mostra tokens, US$ e tempo das rodadas medidas pela G16 no sprint, com o total, por Task (com o mesmo rateio do `kanban.ps1`) e por papel e modelo, com a fatia do custo. A rodada sem preço aparece como "sem preço", nunca como US$ 0. Só agentes: a sessão principal continua medida no close e na retrospectiva.
- **Sem token:** o hook `prompt-submit.ps1` reconhece os dois comandos (também na forma `/team:`), roda o `scripts/checks/team-view.ps1` e devolve o texto com `decision: block`. O prompt não chega ao modelo nem entra no contexto. Medido com `claude -p "/team-status"`: `num_turns` 0, tokens 0, `total_cost_usd` 0, em cerca de 2,5 s. O texto sai em linhas curtas, sem tabela, para caber na tela do celular. Se o hook falhar (falha aberta), o `commands/team-status.md` (ou `team-usage.md`) roda o mesmo script pelo modelo e diz que passou por ele.
- **`how-to.md`:** os dois comandos ganham a seção própria "Acompanhar o sprint sem gastar token", com um exemplo de cada tela e como ler cada linha. Eles também entram na tabela "o que você quer fazer" e em "Responder pelo celular". Entra também a seção "Quando a extensão do VS Code usa uma conta e o terminal usa outra" (`CLAUDE_CONFIG_DIR`).
- **Ainda não medido:** a resposta pelo app do celular (Remote Control) e o comando digitado no meio de um `sprint run`.
- **Testes:** conferências 230 casos (+16), guardas 269 casos (+5), 0 falhas.

## v3.53.1 — 2026-11-01

**Branch:** `fix/v3.53.1` a partir de `develop` · **Processo:** addendum v3.53.1 (`process-changelog.md`, `plugin-report.md` do sprint 4 do garden, itens 1, 3, 7, 8, 14, 15, 16 e 17)
Avaliação do relatório de fim do sprint 4 do garden (3.52.2 → 3.53.0 em 30/10). Os itens 4, 9 e o grosso do 8 repetiam ocorrências da janela 3.52.2 já tratadas na 3.52.3; o item 10 (Task fechada sem o QA) é o desenho da v3.51 A3. Esta entrega trata os defeitos que seguiam abertos e a medição que o piloto da ficha (v3.53.0) precisa. Seis instâncias de dev com 61 a 159 chamadas somaram 34 % do US$ dos subagentes.

- **Agente vivo de outra sessão (item 3):** o registro do `Agent` leva o processo do Claude Code que o hospeda (`host_pid`, `host_start`). O `SessionStart` só manda ao `.interrupted` o agente de processo encerrado; o vivo fica, e a sessão é avisada ("AGENTE VIVO EM OUTRA SESSÃO … não redispare"). O `run.ps1 next` responde "esperar" (exit 3) para a Task com executor ou dev vivo, o `run.ps1 start` recusa outro dev para ela (exit 2) e a G20 libera o fim de turno. Antes, uma segunda sessão aberta no mesmo projeto punha dois devs no mesmo emulador.
- **Teto de contexto do dev (item 15, G23 nova):** com o run ativo, o dev cuja última chamada passou de `guards.json → devContextCap` (padrão 100 mil; 0 desliga) não roda mais comando nem edita código. Ele grava `### Parei no passo` no relatório e volta com `TETO`; `run.ps1 done -Result teto` registra no `run-log.md` e abre instância nova pelo cartão, sem Arquiteto e sem contar para o escalonamento. A leitura do contexto vem só do fim do transcript (256 KB). `agents/developer.md` regra 11 e `agents/task-runner.md`.
- **Aceite honesto (item 1, parte):** no `accept.ps1`, cenário sem nenhum `assert-*` é malformado (exit 2), em vez de passar só por instalar e abrir o app (eram "18 de 18" numa WebView opaca). Isso também vale no README do QA e no prompt dos `.scn`. O modo de prova por CDP e o emulador em container ficam no `note.md`.
- **Git de leitura no run (item 7, parte):** a G14 libera `git cat-file`, `ls-tree`, `rev-list`, `show-ref`, `merge-base`, `describe`, `name-rev`, `worktree list`, `remote -v`, `tag -l`, `config --get/--list` e `stash show`.
- **Medição:** `works` do dev e do executor só com a Task do disparo (item 17: a Task citada como referência recebia metade do custo). No `kanban.ps1`, o empate de minuto no Registro passa a valer pela ordem do arquivo (item 16: 17,1 mi de construção tinham caído em Plano). Cada rodada do `usage.jsonl` grava a versão do plugin (`plugin`), que vai à Nota do `consumption.md` (item 14). O agente parado no limite de uso é medido pelo `run.ps1 next` também quando a mesma sessão segue depois do reset (item 8).
- **Troca de sessão com o run em andamento (item 2, orientação):** `rituals/team-remote.md` §1a e `sprint-run.md` §Retomada após queda. A ordem é pausa no ponto seguro, fechar a sessão da extensão e abrir a do terminal com `/sm sprint run`.
- **Testes:** conferências 214 casos (+8), guardas 264 casos (+11), 0 falhas.

## v3.53.0 — 2026-10-28

**Branch:** `fix/v3.53.0` a partir de `develop` · **Processo:** v3.53 (`process-changelog.md`, `note.md` itens 7 e 8)
O plano do Arquiteto foi o maior custo do sprint 4 do garden: a instância que planejava a H-K1 custou ≈ US$ 16,3 (63 % dos subagentes), porque cada chamada reenvia a conversa acumulada. Esta entrega é o piloto da primeira opção do item 8: a ficha por Task na Planning + um Arquiteto por Task, com o template enxuto do item 7 (um sem o outro rende pouco). Estimativa, não medição: ≈ −55 % no plano.

- **Ficha por Task (item 8):** modelo novo `roles/architect/templates/breakdown.md` — no `breakdown/S<n>.md`, as decisões comuns da História e uma ficha por Task (código a ler, fontes, nomes comuns), escritas na quebra da Planning. Passo 4 da Planning, roteiro do Arquiteto e `deliverables/team-project/README.md`.
- **Um Arquiteto por Task (`run.ps1 next`):** Task com ficha → recorte em `sprints/<n>/handoff/<T-ID>-ficha.md` e o prompt de um plano só, que abre a ficha, o template, o plano da dependência e o `architect/context.md`; primeiro a Task cujas dependências já têm plano. Sem ficha, a História segue numa instância. `sprint-run.md`, `commands/sm.md` e `agents/architect.md`.
- **Conferência da ficha (`plan.ps1`, regra 28):** plano com ficha precisa de `**Li além da ficha:**` e dos nomes comuns literais, e a ficha só pode apontar caminho que existe. Função `Get-Ficha` no `lib.ps1`.
- **Template enxuto (item 7):** "Regras do formato" só com o operativo, numeração mantida, ✓ nas que o `plan.ps1` confere e "não abra o script"; o texto antigo, íntegro, em `roles/architect/plan-rules-why.md`. Template de 33,6 → 22,7 KB.
- **Consumo (G16, `hooks/subagent-stop.ps1`):** ID dentro de caminho não entra em `works` — o plano da dependência citado no prompt rateava a rodada entre duas Tasks e falseava a medida do piloto.
- **Processo:** v3.53 no `process-changelog.md`; a v3.50 foi para o arquivo (três entradas vivas).
- **Testes:** conferências 206 casos (+6), guardas 253 casos (+1), 0 falhas.

## v3.52.3 — 2026-10-27

**Branch:** `fix/v3.52.3` a partir de `develop` · **Processo:** addendum v3.52.3 (`process-changelog.md`, `/review note`, itens 1 a 5, 9 e 10)
Avaliação do sprint 4 do garden (3.52.2), conferida nos transcripts e revista com as respostas do cliente. Em US$ (preço por modelo), os subagentes custaram ≈ US$ 25,9: o plano da H-K1 ≈ US$ 16,3 (63 %), os devs Haiku ≈ US$ 3,3. Esta entrega trata as correções diretas e a espera da verificação; o plano do Arquiteto (itens 7 e 8) e o contexto do dev Haiku (item 6) seguem no `note.md`.

- **Cartão sem aceite quando não há alvo (item 1, `run.ps1`):** a linha **Cenários:** só traz o `accept.ps1` com `guards.json → targets` — 4 de 5 Tasks pararam no mesmo 🔺 GAP "accept sem .scn". De quebra, o cartão não abre mais linha em branco (a vírgula prende antes do `+` no PowerShell).
- **Verificação que cabe nos 600 s (item 2, `verify.ps1`):** o orçamento do `-Mode full` estima cada comando pela história da chave (o maior tempo das últimas 5 rodadas em `verify/**/result.json`), não pela duração do comando anterior (lint de 20 s → suíte de 500 s → 630–709 s).
- **Espera pelo aviso (item 3):** prompt do dev no `run.ps1 start`, `agents/developer.md` e `roles/developer/README.md`: comando movido para segundo plano → encerre o turno, o aviso traz a saída, não sonde o log. G14 nega também `Wait-Process`, com essa rota.
- **Uma rodada por Task (item 4, `verify.ps1`):** `verify.lock` na pasta da Task; outra rodada viva → **exit 5** (OCUPADO); trava de processo morto sai sozinha.
- **Suíte perto do teto (item 5, `verify.ps1`):** comando acima de 80 % do teto por comando sai com `atenção:` e a ação (dividir `verify.suite`).
- **Consumo (item 9):** G16 grava `usd` por rodada (`scripts/checks/prices.ps1`, tabela 2026-10, Haiku 5.5 com a faixa acima de 100 mil); `consumption.ps1` põe a coluna **US$** nos Totais e na Nota; agente cortado pelo limite (sem SubagentStop) é medido pelo `run.ps1 next` a partir do transcript que o SessionStart guarda no `.interrupted`.
- **GAP no registro (item 10, `run.ps1`):** `done -Result gap|env` grava a rota no `run-log.md`; o prompt do Arquiteto pede estender a decisão aos planos das Tasks abertas. `agents/task-runner.md` e o modelo `run-log.md` dizem o que fica para o executor.
- **Testes:** guardas 252 casos (+3), conferências 200 casos (+10), 0 falhas.

## v3.52.2 — 2026-10-26

**Branch:** `fix/v3.52.2` a partir de `develop` · **Processo:** addendum v3.52.2 (`process-changelog.md`, `/review note`, itens 1 a 17)
Avaliação do sprint 3 do piloto (v3.52.0). A sessão do `run` medida por `message.id` (a análise somava por linha do transcript, ~1,8× a mais): orquestração 207 → 228 mi (+10 %), total ~412 → ~408 mi, respostas sem ferramenta 27 → 259. Causa: o `Agent` não tem mais `run_in_background` — todo subagente é assíncrono — e a G20 só aceitava espera de agente marcado em segundo plano. Spike de 2026-10-26 aprovou o executor de Task (subagente espera o filho encerrando o turno; três níveis; a sessão recebe um aviso só no fim).

- **Executor de Task (`agents/task-runner.md`, novo, sonnet):** a sessão dispara um executor por Task (`sprint run`) ou por F-ID (`fix run`), que conduz dev → GAP → Arquiteto → dev → fechamento pelos scripts e devolve uma linha. É a sessão curta por Task, sem `/clear` manual (R29). G7: dispara só dev, Arquiteto, operator e QA; G8/`ownership.json`: escreve só as linhas dele no `run-log.md`.
- **Agente assíncrono (G20, `run.ps1`, `dispatch.ps1`, roteiros, `commands/*`):** espera legítima é qualquer agente da sessão em voo (sem o filtro `bg`); "dispare e encerre o turno; o aviso traz a volta"; `run_in_background` sai dos disparos.
- **Retomada após queda:** `.active-agents` com `session` e `parent`, registro de todo `Agent` (sessão e papel), SubagentStop preserva quem tem filho vivo; SessionStart `startup`/`resume` move o registro para `.interrupted` e avisa; `run.ps1 next` diz de onde retomar. Mesmo comando inicia e retoma (`/sm sprint run`, `/sm fix run`).
- **Plano que prova (`plan.ps1`, template e roteiro do Arquiteto):** `- Contagem: `regex` em `glob` → n` recontada pelo script; `### Premissas` (medida ou "não exercitada · verifica"); "não validado" solto reprova; `Layout novo: sim` exige premissa medida e a linha `**Documentos vivos:**` — o SDD fica fora de **Arquivos tocados** (o Arquiteto consolida, decisão do stakeholder); medição em execução pelo `operator`.
- **Scripts:** `Get-Mutations` único (o bloco não acaba em linha em branco) e `Get-PlanScope` no `lib.ps1`; `"targets": {}` não é alvo; `run.ps1 start` com Task em 🟨; commit por `git commit -F` só com o escopo do plano; veredito `**Veredito (rodada N):**` (vale o último) e `**Decisão do PO:** aceito com dívida`; R24 ignora a linha de abertura; árvore do `verify` sem `docs/`; escalonamento do dev conta só falha de papel (`handoff/<ID>.json`); linha `SESSÃO:` no `next` (aviso acima de 150 mil).
- **Correção do portão = Task `Q-S<n>`** (seção do quadro "Correção do portão", R25 mantida) e **Review adiada** (`**Estado:** adiada para o sprint <n>`, R21 no `project.ps1`; ocorrência de plugin no `close`) — decisões do stakeholder.
- **`/team init` e `/team update` §7k** propõem `quality` e `verify.compile`; `guards.json` modelo com as chaves vazias e `_exemplos`. `/ux prototype` com abertura e fecho de sessão (R29).
- **Testes:** guardas 249 casos (+20), conferências 190 casos (+27), 0 falhas; C3 ok.

## v3.52.1 — 2026-10-24

**Branch:** `fix/v3.52.1` a partir de `develop` · **Processo:** sem mudança
Itens do relatório do garden (sprint 2, `plugin-report.md`) que a v3.51.4 não fechou: o 28 (novo no relatório), o 15 e o 24 (parciais). Os outros 25 itens do relatório já estavam atendidos na v3.51.4.

- **`verify.ps1` (item 28):** mutante que não compila no TypeScript não conta mais como "pego pelo teste". Entram nos sinais de "o teste não rodou de verdade" o código `TS####:` **sem** a palavra "error" na frente (ts-jest, Karma, Angular), `Test suite failed to run`, `Module build failed`, `Failed to compile`, `Transform failed`, `Build failed with N errors`, `Tests: 0 total` e o erro de `javac`. A mutação vira "inconclusivo" e o R7-mutação não fecha.
- **`mark.ps1` (item 15):** o Evento da Série e a linha do Registro de transições apontam a **última rodada medida da Task** (papel, agente, hora do fim), lida do `usage.jsonl`: `T-041 🟨 → 🟪 · QA ← developer dev98765 10:40`. O stakeholder não cruza mais o Registro com as Rodadas do `kanban.md`.
- **G16 (`subagent-stop.ps1`, item 24):** o relatório do `operator` chamado sem pasta de job citada também é gravado no **bloco de fix**: `operator/B-<nnn>/<F-ID>-<agente>/report.md` (antes só em sprint, por Task).
- **Testes:** guardas 229 casos (+1), conferências 163 casos (+2), 0 falhas.

## v3.52.0 — 2026-10-24

**Branch:** `feat/v3.52.0` a partir de `develop` · **Processo:** v3.52 (`process-changelog.md`, `/review note`, itens 1 a 9)
Orquestrador enxuto. No braço `sunscape-P-r1` (v3.51.3), 67 % do custo do `run` foi a sessão que orquestra relendo o próprio contexto: mediana de 376 mil tokens por chamada, ~200 mil herdados das etapas anteriores, que correram na mesma sessão. Mais 48 chamadas só de espera (US$ 3,68). A construção custou o mesmo que no N-forte.

- **R29 ampliada:** cada ritual começa em sessão nova e lê só o disco. Vale também na passagem do sprint para o fix e em cada Task do `run`. Os roteiros ganham uma lista curta de leitura na abertura e o fecho "`/clear` e o comando". O brainstorm grava o brief ao fechar (exceção da R15), e o `sdd` o retoma.
- **Ponto seguro (parada (f)):** o `run.ps1 done` que fecha a Task grava `.team-project/.safe-point` e a **G20** libera o fim de turno sem apagar o `.active-run`. O `next` e o `start` seguintes apagam o marcador.
- **Commit por Task:** o `run.ps1 done` versiona o código da Task fechada (`T-<nnn>: <título>`, sem `.team-project/`, R31). Sem git, o checkpoint é por cópia.
- **Espera sem custo:**
  - Todo agente vai em primeiro plano (`run.ps1`, `dispatch.ps1`), e a retomada no run é sempre instância nova com o cartão.
  - **G19** nega `SendMessage` com run ativo, inclusive ao Haiku.
  - **G22 (nova)** nega à sessão `Start-Sleep` e comando em segundo plano durante o run.
  - O toque de cache saiu.
- **G21 (nova, `hooks/prompt-submit.ps1`, `UserPromptSubmit`):** avisa sem bloquear quando um ritual abre numa sessão que já rodou outro. Lê o transcript interativo e o do `claude -p`.
- **Registro de decisões:** novo modelo `templates/run-log.md` (`sprints/<n>/run-log.md`, `fixes/B-<nnn>/run-log.md`), com o que não está no quadro nem no cartão.
- **Comandos (`commands/sm.md`, `dev.md`):** sessão nova por ritual, primeiro plano em todo modo, `SendMessage` só fora do run.
- **`hooks/COVERAGE.md`:** seção v3.52.
- **Testes:** guardas 228 casos, conferências 161, 0 falhas.
- **Pendente:** a regra de sessão nova no roteiro do `/ux prototype` (do UX). O driver do benchmark, no repositório do experimento, já roda cada passo em sessão nova para braços com plugin ≥ 3.52.

## v3.51.5 — 2026-10-23

**Branch:** `fix/v3.51.5` a partir de `develop` · **Processo:** addendum v3.51.5 do changelog do processo (decisão do stakeholder)
Decisão pendente da v3.51.4 (garden item 20): Task habilitadora sem História. O stakeholder manteve a R20.

- **Planning (`workflow-sprint.md` §5e, passo 4) e modelo do Sprint Backlog:** a Task habilitadora (scaffold, ambiente, base comum) entra sob a **primeira História que depende dela**; as Tasks das outras Histórias a citam em "Depende de". Não há seção `## Habilitadora`.
- **`close.ps1` (R20):** a mensagem de Task sob `## Habilitadora` diz como corrigir o quadro.
- **Testes:** conferências e guardas sem caso novo (a reprovação da R20 já era testada); C3 ok.

## v3.51.4 — 2026-10-23

**Branch:** `fix/v3.51.4` a partir de `develop` · **Processo:** addendum v3.51.4 do changelog do processo (`/review note`)
Relato do braço P+ no SunScape (`note.md`, itens 1–16; v3.51.3 — o 16, terceiro corte por limite de conta no mesmo run, reforça o 11) e do sprint 2 do garden (`plugin-report-garden.md`, itens 1–27; v3.51.2): 30 negações da G14 em ~3 h de run, o run cortado duas vezes pelo limite de uso da conta sem sinal legível, rodadas e transições registradas no lugar errado ou sumindo, e fechamentos que reprovavam por formato.

- **G14 (`hooks/pre-tool.ps1`):** texto entre aspas com `$( … )` não vira mais trecho recusado (cada subexpressão é conferida); `if`/`param`/atribuição/`[xml]` em cadeia; propriedade com os argumentos do comando de fora; leitura por `[array]`, `[Text.Encoding]`, `[xml]`, `[IO.Directory]`; escrita por .NET com destino resolvido (passa pela G5/G8/G9); `"$root\…"` resolvido; caminho do script do plugin em variável; função do próprio comando; `cmd /c "<comando>"` lido por dentro; **script que o papel gravou** (scratchpad ou `.team-project/`) roda quando o conteúdo passaria pela G14; `Get-CimInstance`; `Stop-Process -Id` só ao operator; `adb` e `Start-Sleep` negados com a rota do `target.ps1` e do exit 3.
- **G8:** `pasta/**` casa a própria pasta — `stories/` (PO) e `delivery/` (dev) não caem mais em "dono ambíguo".
- **Limite de uso da conta:** a G16 e o `Stop` gravam `.team-project/.usage-limit`; a G20 não barra o turno cortado; o `run.ps1 next` diz que o run parou por limite e apaga o sinal; roteiro §Retomada após limite de uso. A G16 tira da duração as lacunas acima de 20 min (`paused_s`) e ignora a resposta `<synthetic>`.
- **Ponto seguro e estimativa:** o `run.ps1 next` imprime o consumo medido do sprint e a estimativa das Tasks abertas; parada **(e)** "pausa pedida pelo stakeholder" no ponto seguro (logo depois de uma Task fechada).
- **Sinal de vida:** seção **"## Agora"** no `kanban.md` — papel, item, última ação e há quanto tempo de cada agente, regravada pelos hooks a cada disparo e ação. A G20 só conta agente em segundo plano; o registro não depende mais do `.active-run`.
- **Quadro e Kanban:** parser do Sprint Backlog só lê tabelas sob "## História" (sem Tasks-fantasma nem IDs repetidos; "## Habilitadora" vira grupo próprio, R20 segue valendo); "Sprint corrente" aceita `sprint **2**`; `run.ps1 next` marca 🟦 no preparo e não pede `.scn` sem `targets`; `run.ps1 done` confere antes, marca 🟪 e só então fecha (R24 ok), e devolve a 🟨 num GAP; quadro, Registro e Série sob a trava do `kanban.md` (a G16 apagava uma linha da Série); Evento da Série com "por quem"; tipo do agente com `team:`.
- **Rodadas:** `consumption.md` do sprint criado pelo `kanban.ps1 -Init` (G16/`run.ps1 next`) quando a Planning não o criou; rodada de plano por História rateada entre as Tasks citadas; fase pelo marcador no início da rodada; o `operator` filho no destino do pai; coluna Pausa; "Espera de comando" por Task (`verify/<n>/<T-ID>/time.jsonl`).
- **Fechamento (`close.ps1`):** R7 do dev aceita o comando em qualquer linha do bloco; R28 não cobra de uma Task a medição de outra Task/História reaproveitada; relatório do `operator` sem pasta citada vai a `operator/<n>/<T-ID>-<agente>/`.
- **Plano (`plan.ps1`):** §3 em tabela e §9 com "Pré-requisito ausente" cobradas no plano (antes só no fechamento); trecho de mutação duplicado no arquivo existente reprova; cenários sem `.scn` e sem alvo = n-a.
- **`verify.ps1`:** `-Mode full` em fatias (exit 3, o mesmo comando continua); `verify.daemon: true` liga o daemon do Gradle só durante a chamada e o encerra no fim (opcional); `-Mode mutation -Precheck` (trecho único e, com `verify.compile`, mutante que compila).
- **Roteiros:** `sprint-run.md`, dev, Arquiteto, UX (a linha do protótipo no pacote é do SM), modelos `kanban.md` e `sprint-backlog.md`, `standards/stacks/kotlin-android/quality.md`, `hooks/COVERAGE.md`.
- **Testes:** guardas 217 casos (+28), conferências 159 casos (+19), 0 falhas.

## v3.51.3 — 2026-10-22

**Branch:** `fix/v3.51.3` a partir de `develop` · **Processo:** addendum v3.51.3 do changelog do processo (`/review note`)
O kanban do bloco de fix só mudava o estado da F-ID depois que a rodada terminava; durante a rodada do dev a F-ID seguia em ⬜.

- **`kanban.ps1 -Block B-<nnn> -Fid F-<n> -To plan|build|qa`:** marca a F-ID na entrada da fase (`fixes/B-<nnn>/.marks`) e regrava o `kanban.md` na hora; as rodadas (G16) só confirmam o estado e somam custo.
- **Roteiro (`fix-run.md`) e modelo (`templates/kanban.md`):** a sessão marca a fase antes de acionar dev, Arquiteto ou QA numa F-ID.
- **Testes:** guardas 189 casos, conferências 140 casos, 0 falhas. Sem caso novo para o `-Fid`/`-To` (verificado à mão).

## v3.51.2 — 2026-10-22

**Branch:** `fix/v3.51.2` a partir de `develop` · **Processo:** entrada v3.51.2 do changelog do processo (`/review note`, itens 1–10)
Relato de uso da trilha `fix` na v3.51.1: oito comandos barrados por guardas do próprio plugin e uma conferência que reprovou por formato. Mais dois pedidos de acompanhamento (Kanban só em Markdown, com o gasto por rodada; Kanban do bloco de fix).

- **G14 (`hooks/pre-tool.ps1`):** a conferência do plugin (`verify.ps1` e as demais de `scripts/checks/`) passa também dentro de comando composto e com `-ExecutionPolicy Bypass`, mas **só dentro da pasta do plugin** (antes passava qualquer caminho terminado em `scripts/checks/*.ps1`, inclusive do projeto). `$env:TEMP` no destino se resolve (criar pasta no scratchpad). A negação de `cmd /c` diz para rodar o comando direto. Executar arquivo do scratchpad continua negado: contornaria a G8 e a G9.
- **Kanban em Markdown (`scripts/checks/kanban.ps1`, novo; sai o `kanban-html.ps1` e o `kanban.html`):** o `kanban.md` do sprint ganha a seção `## Rodadas`, regravada ao fim de cada rodada de agente (hook G16): por tarefa e fase (Plano · Construção · Verificação · Outros, em tokens e tempo, com o consolidado), por papel e modelo, e rodada a rodada. O bloco de fix ganha `fixes/B-<nnn>/kanban.md`, com as colunas do sprint, o Registro de transições e as mesmas Rodadas. Script: não custa token.
- **`consumption.md` do bloco:** nasce com `kanban.ps1 -Block B-<nnn> -Init` no fix plan e, como rede, na primeira rodada do bloco (G16).
- **`verify.ps1 -Mode mutation`:** lê os blocos **Mutações:** de todas as F-IDs do mini-plano e usa `- produção:`/`- teste:` como escopo. O `fix-plan.md` ganha o campo.
- **Roteiros:** dev com o comando completo do `verify.ps1`; o Arquiteto não executa nada no run (valida lendo, ou "não validado — o dev confirma"); promoção sem escrita na ficha fora do PO; modelo do veredito com o formato que o C4 lê. Detalhe no changelog do processo.
- **Testes:** guardas 189 casos, conferências 140 casos, 0 falhas.

## v3.51.1 — 2026-10-21

**Branch:** `fix/v3.51.1` a partir de `develop` · **Processo:** sem mudança
Achado no preparo do P+ do benchmark (SunScape): o pedido não fixa o `applicationId` e o `guards.json` é do stakeholder — nenhum papel o preenche durante o run. Sem `targets.android.package`, o executor de cenários não abria o app e a Task não fechava (R7-aceite).

- **`accept.ps1` e `targets/android.ps1`:** sem `targets.android.package`/`apk`, o executor acha o APK mais recente do projeto (`**/build/outputs/apk/{release,debug}/`) e lê o `applicationId` dele (`aapt2 dump packagename`, ou `aapt dump badging`). Validado no emulador com o APK do SunScape, sem nada configurado além do AVD.
- **Primeira abertura depois de instalar:** `assert-exists` e o alcance de elemento esperam o tempo inteiro antes de rolar a tela (a primeira tentativa falhava com o app ainda abrindo).
- **Reparo do emulador:** espera 25 s depois do boot (launcher e serviços) e sobe o emulador na pasta do SDK, sem prender a pasta do projeto.
## v3.51.0 — 2026-10-21

**Branch:** `feat/v3.51.0` a partir de `develop` · **Processo:** v3.51 (`process-changelog.md`)
O plugin otimizado com o que o benchmark mostrou (P × N-forte × protótipo Coordenador–Operador; plano em `plano-plugin-p-plus.md`, aprovado pelo stakeholder em 21/10/2026). Mantém o processo e a documentação antes e depois da Sprint e aproxima a construção do N-forte: o dev constrói, verifica e corrige sozinho; o plano e os cenários ficam prontos antes; o QA é o portão do sprint, com prova no alvo real; a sessão orquestra por script; o contexto passa por um cartão curto.

- **Sprint (A1–A6):** preparo por História (QA escreve `.scn`, Arquiteto planeja a História numa instância); plano enxuto (regras 22–25 do template; `plan.ps1` confere tamanho, cenários, risco e render); Task fecha pela evidência do dev (`close.ps1`: R7-aceite, R12 "a consolidar"); portão do QA no fim (`/qa sprint`, `templates/sprint-validation.md`); consolidação R12 única (`docs-consolidation.md`); teste pelo risco com a cobertura medida como freio.
- **Scripts novos:** `run.ps1` (próxima ação, `start`, `done`, `handoff` com o cartão de passagem), `accept.ps1` + `targets/android.ps1`, `targets/web.ps1`, `targets/web-runner.js` (cenários no alvo real com captura; Edge/Chrome de reserva no web), `target.ps1` (pré-voo e reparo), `quality.ps1` (as regras Q do nível 1), `kanban-html.ps1` (Kanban visual, sem token), `tool-hygiene.json` (higiene e assinaturas de ambiente por ferramenta).
- **Scripts alterados:** `verify.ps1` (tempo limite próprio, árvore de processos encerrada — o daemon do Gradle não prende mais —, higiene por ferramenta, `verify.env`, exit 4 = ambiente); `lib.ps1` (executor de comando comum, trava do alvo, leitura do quadro, `kanban.md`); `mark.ps1` e `close.ps1` (`kanban.md`, Kanban regravado; R16 com `stacks/` e identificadores); `transcript-metrics.js activity` (custo por atividade).
- **Guardas:** G19 (sem retomar papel caro parado há mais de 5 min), G20 (hook `Stop`: sem fim de turno com Task elegível no run; `.active-agents`), G3 com o exemplo prático (H1); `SessionStart` retoma o run e avisa perfil com acento.
- **Fix (§3a):** cenário `FX-<nnn>` antes e depois, métricas só dos arquivos tocados, formulário H1.
- **Organização:** `kanban.md` no lugar do `burndown.md` (controle das Tasks embaixo) e `kanban.html`; `standards/stacks/<tecnologia>/` (.NET + `desktop.md`, Kotlin/Android, React, Angular) com Ficha pré-preenchida e identificadores; agentes leem só o que usam.
- **`note.md`:** itens 1 a 5 e os três pedidos de "Outros" aplicados. **`proposals-pending.md`:** propostas a, b, c e d aplicadas; arquivo apagado.
## v3.50.1 — 2026-10-16

**Branch:** `fix/v3.50.1` a partir de `develop` · **Processo:** sem mudança
Defeito achado no ensaio do braço P do benchmark (`mente-ativa-P-r3`): sob `claude -p` a ferramenta `AskUserQuestion` não é oferecida à sessão (testado com `--tools`, `--allowedTools`, `--permission-prompts host` e `stream-json`; o ambiente limpo também não a expõe), então a G18, que nega a ferramenta e devolve a resposta do dossiê, nunca disparava. O brainstorm tratou as recomendações como premissas e o `sdd` recusou-se a rodar.

- **`scripts/checks/bench-answer.ps1`:** a sessão informa pergunta, cabeçalho e rótulos (`-Options "A|B"`) e recebe `[bench] resposta do stakeholder: <rótulo>`, pela mesma lógica da G18 e com a mesma linha em `questions.log`. Sem bench ou sem dossiê, exit 2 (a pergunta é do stakeholder).
- **`hooks/common.ps1`:** a resolução do dossiê (`Get-BenchAnswers`, `Write-BenchLog`, `Format-BenchAnswers`) saiu do `pre-tool.ps1` para ser comum à G18 e ao script; o comportamento da G18 não muda.
- **G13 (`session-start.ps1`):** com `bench` ligado, a abertura manda usar o `bench-answer.ps1` quando o `AskUserQuestion` não existir, em vez de parar ou assumir premissa.
- **`/team init` com configuração semeada (`rituals/team-init.md` §1):** pasta `.team-project/` com **só** `guards.json`, `models.json` e/ou `usage.jsonl` não é contexto existente. O `init` segue e preserva esses arquivos (o driver do benchmark os semeia para ligar o `bench` antes da primeira pergunta; antes o `init` parava e o `sdd` recusava-se a rodar).
- Suítes: 168 guardas e 108 conferências.

---

## v3.50.0 — 2026-10-16

**Branch:** `feat/v3.50.0` empilhada sobre `feat/v3.49.0` (não mesclada) · **Processo:** [`v3.50`](roles/scrum-master/process/process-changelog.md)
Dois itens de `note.md` vindos do primeiro sprint do piloto: a regressão de UI que passou por todos os portões e as paradas do `run` fora do contrato. A entrega abre a v3.50 porque o bloco v3.49 do changelog do processo chegou à barreira R17.

- **Mudança de layout se prova em render real:** o plano de Task com interface traz a tabela **Render real** (medição de caixas em navegador headless, 3 tamanhos de fonte × telas), o navegador na §3 e uma mutação que quebra a medição. Prova só por estrutura (CSSOM, seletor) não basta, e Task com interface nunca vai para a trilha leve (`implementation-plan.md` regra 21, `fix-plan.md` regra 15). Sem headless no projeto, a falta vira GAP.
- **`standards/implementation-principles.md`:** nível Render, V22 (navegador ou driver e comando) e linha 23 do quadro; a Ficha do SDD passa a V1–V22. O relatório de entrega do dev traz a saída do render.
- **QA:** decide se a Task tem interface, executa ou reexecuta a medição e reprova, ou abre GAP, sem ela. Veredito, evidência e cenário ganham a tabela e a regra.
- **Paradas do `run` (`sprint-run.md`, R25(c)):** "sigo?", "parei num marco natural", pergunta sobre defeito do plugin e formulário com Task elegível não são paradas. O formulário de bloqueio só abre com a Task 🔴 e a fila esgotada, e a sessão que reabre com `.active-run` retoma a fila.
- **Propostas pendentes** em `roles/scrum-master/process/proposals-pending.md`: hook `Stop` (G20), `session-start` com retomada, orientação de energia no `how-to.md` e conferência `render` no `plan.ps1`.
- v3.47 do changelog do processo arquivada. Itens 1, 3 e 5 de `note.md` esperam o benchmark.

---

## v3.49.0 — 2026-10-16

**Branch:** `feat/v3.49.0` a partir de `develop` (v3.48.1 mesclada) · **Processo:** [`v3.49`](roles/scrum-master/process/process-changelog.md)
Os itens de `note.md` medidos nos transcripts do primeiro sprint do piloto, aplicados antes do benchmark. O sprint custou ~US$ 282 em preço de API: a sessão principal 40 %, o Arquiteto 38 %, as quebras de cache 34 %.

- **Retorno curto à sessão (R28):** no `sprint run` e no `fix run`, cada papel grava o artefato e devolve até 15 linhas (estado, arquivo, próximo passo, execução delegada); a sessão passa caminhos, não conteúdo. O **relatório de entrega do dev passa a ser arquivo**: `sprints/<n>/delivery/<T-ID>.md` e, no `fix`, `fixes/B-<nnn>/delivery.md`.
- **Arquiteto novo quando o cache venceu (R27, `sprint-run.md` §Retomada):** parado há mais de 5 min, o Arquiteto que vai responder um GAP ou corrigir o plano é uma instância nova, que lê o plano e o GAP. O cache de 1 h para subagentes foi simulado e descartado: sairia mais caro.
- **Toque de cache da sessão** (em avaliação): `CronCreate` a cada 30 min enquanto o `.active-run` existe, fora do modo benchmark.
- **Nada se perde numa interrupção:** o Arquiteto grava o plano seção a seção e a quebra em Tasks em `architect/breakdown/S<n>.md`; o QA grava a evidência frente a frente.
- **`fix run`:** uma instância do dev por F-ID.
- **`scripts/metrics/transcript-metrics.js`** (novo): `cost`, `breaks`, `growth`, `session`, `waits`, medidos nos transcripts, para o sprint real e para todos os braços do benchmark.
- Matriz de propriedade e `hooks/ownership.json` com os caminhos novos (5 casos novos da G8); `agents/*`, `commands/dev.md`, `team-update.md` 7j. Suítes: guardas **167**, conferências **105**.
- **Registro de consumo que fecha:** o `consumption.ps1` grava o modelo servido com a versão (`haiku 4.5`), os Totais têm uma linha por papel e modelo, com **Instâncias** e **Rodadas** em colunas separadas e `não medido` onde só há notificação, e o `operator` sem chamador ganha o chamador pelo horário. A **G16 roda o script** ao fim de cada rodada; a sessão só o roda antes de uma conferência.
- **Escritas mecânicas da sessão em script:** `mark.ps1` (marcador, Registro e Série numa chamada), `dispatch.ps1` (`.active-task` em JSON, marcador, parâmetros do `Agent`, `-Clear`) e `consumption.ps1 -Session`, que mede a sessão principal no `close` pelo transcript cujo caminho a G16 grava em cada linha.
- **`scripts/metrics`** descarta evento repetido do transcript (a "parada de 68 h" do piloto não existiu). As paradas do `run` foram reclassificadas em `note.md`: ~24,5 h fora do contrato, ~122 h de máquina suspensa, ~6,8 h de decisão do stakeholder.
- **`commands/sm.md`:** a `description:` passa a ir entre aspas. O `sprint: prepare` dentro do texto quebrava o YAML do cabeçalho, e o `/sm` carregava sem descrição nem `argument-hint`, desde a v3.47.0 ou antes. Agora `claude plugin validate . --strict` passa.

---

## v3.48.1 — 2026-10-14

**Branch:** `fix/v3.48.1` a partir de `develop` (v3.48.0 mesclada) · **Processo:** [`v3.48` — addendum v3.48.1](roles/scrum-master/process/process-changelog.md)
Preparação do ensaio do benchmark (modo projeto): os três projetos-padrão são Android/Gradle, e o `verify` só sabia entregar **caminho de arquivo** no `{tests}`.

- **`verify.testItem`** no `guards.json`: o molde de cada teste no `{tests}` — `{path}` (padrão, comportamento de antes) ou `{class}`, o nome qualificado da classe (`src/<conjunto>/java|kotlin/a/b/FooTest.kt` → `a.b.FooTest`). Gradle: `"focused": "./gradlew testDebugUnitTest {tests}"` + `"testItem": "--tests {class}"` → um `--tests` por classe. Vale para o `focused`, a linha de base e cada mutação. Sem isso, `--tests <caminho>` dava "No tests found" e toda prova de falha saía `inconclusivo`.
- Modelo do `guards.json` e `team-update.md` 7h com a chave. Suíte de conferências **91** (2 novos); guardas **161**.

---

## v3.48.0 — 2026-10-14

**Branch:** `feat/v3.48.0` a partir de `develop` (v3.47.1 mesclada) · **Processo:** [`v3.48`](roles/scrum-master/process/process-changelog.md)
Grupos A e B de `avaliacao-first-result.md` — o primeiro sprint completo do projeto-piloto (04 a 13/10/2026, plugin 3.46.0), com o `guards.log` reexecutado contra o hook da v3.47.1.

- **Sem falha aberta silenciosa:** `.active-task` ilegível faz a G9 negar com o formato certo — antes o hook caía e 9 edições do dev passaram sem G6/G8/G9.
- **Texto entre aspas não é destino:** `Select-String -Pattern 'ion-item > ion-label'` deixa de dar G8/G9; variável atribuída a literal no mesmo comando (`$d = "…"`, `Join-Path (Get-Location) "…"`) se resolve para G5/G8/G9/G14.
- **G14 sem os falsos negados medidos:** escrita com caminho entre aspas, conferência com `2>&1`, `Get-Process`, `npm --prefix`, `[Math]::…`/`[IO.File]::Read*`; `*>` confere o destino; `Start-Sleep` e `robocopy` negados com a rota do `operator`. G11 só no segmento canônico (`operator/sprint-1/` negado com o nome certo). G15 ignora o `AskUserQuestion`. `guards.log` com alvo numa linha.
- **Relatório do `operator` gravado pelo hook G16** a partir da resposta (o harness recusa relatório de subagente); C1 conta todo `report*.md` das pastas citadas.
- **C1:** R7/R12/R4/R30 leem a última rodada com veredito; R4 aceita "Decisão do stakeholder" datada (coluna nova no Sprint Backlog); `-Apply` grava o Registro no `sprint-backlog.md` do quadro antigo. **`plan.ps1`:** arquivo de outro papel ou de gate na lista reprova (linha `dono`).
- `agents/operator.md`, R28, modelos do consumo, do Sprint Backlog e do plano, `sprint-run.md`, `team-update.md` 7i, `COVERAGE.md`; v3.45 arquivada no changelog do processo. Suítes: guardas **161** (21 novos), conferências **89** (8 novos).

---

## v3.47.1 — 2026-10-12

**Branch:** `fix/v3.47.1` a partir de `develop` (v3.47.0 mesclada) · **Processo:** [`v3.47` — addendum v3.47.1](roles/scrum-master/process/process-changelog.md)
Itens 1 a 3 da avaliação de `relatorio-processo-sprint-1-parte-2.md` (projeto-piloto, 07 a 12/10/2026), antes do ensaio do benchmark.

- **Prova de falha só conta com o teste rodando** (`verify.ps1 -Mode mutation`): linha de base por teste (sem mutação, passa e executa teste); exit ≠ 0 com mutante que não compila, zero teste ou runner caído vira `inconclusivo` (padrões embutidos + `guards.json` → `verify.inconclusive`; `verify.caught` opcional). Trecho vazio não estoura mais (`plan.ps1` o reprova).
- **Mutação em fatias:** `-MaxMinutes` (padrão 8) para antes do vigia de 600 s com exit 3; o mesmo comando, na mesma árvore, continua de onde parou.
- **`-Tests` e `-Only` em lista por vírgula** (como chegam pelo `powershell -File`) e `verify.testRoot` (comando focado que roda numa subpasta).
- **G14:** `(Get-Content f).Count` e afins liberados (método sobre o resultado continua negado); `git branch` de listagem; `<ferramenta> --version`; a negação cita o trecho recusado do comando composto.
- Dev, QA, `sprint-run.md`, modelo do plano, `team-update.md` 7h, modelo do `guards.json`, `COVERAGE.md`. Suítes: conferências **81** (7 novos), guardas **140** (8 novos).
- **Não entrou:** o `report.md` do `operator` — o harness recusa relatório gravado por subagente; muda o contrato da R28 em entrega própria.

---

## v3.47.0 — 2026-10-10

**Branch:** `feat/v3.47.0` a partir de `develop` (v3.46.0 mesclada) · **Processo:** [`v3.47`](roles/scrum-master/process/process-changelog.md)
M1 a M4 de `proposta-benchmark-projeto.md`: o modelo de cada papel configurável e o plugin pronto para o experimento de benchmark em modo projeto, sem intervenção. Dois commits: **M1** (modelo por papel) e **M2–M4**.

- **M1 — `.team-project/models.json`** (opcional, do stakeholder): `{ "developer": "sonnet", "architect": "opus" }`. Chaves = os 7 agentes (ou o apelido do comando: `arc dev po qa sm ux`); valores `opus` · `sonnet` · `haiku` · `fable`. **Chave ligada vence** o `model:` do agente **e** as exceções do processo (trilha leve, 3ª instância do bloco); sem a chave, nada muda. **G17** nega o disparo com outro modelo (sessão e `operator` disparado por papel); `scripts/checks/models.ps1` resolve e valida; o `SessionStart` mostra os modelos em vigor. Modelo em `deliverables/team-project/models.json`.
- **M2 — perfil Arquiteto executor:** `models.json` → `"executor": "architect"` + o marcador `.team-project/.active-executor` (gravado pela sessão no passo 3 do `sprint run`, junto do `.active-task`) fazem o **Arquiteto implementar o próprio plano**, sem dev. A **G8** libera o código ao Arquiteto, a **G9** o limita aos arquivos de `**Arquivos tocados:**` e a **G6** proíbe teste ignorado; G5 e G7 valem como sempre. Não há 🔺 GAP a si mesmo: **plano errado se corrige** e a correção vira linha em `**Plano corrigido durante a execução:**` (indicador de precisão do plano). Modo `/arc execute <ID>` no cartão e no README do Arquiteto; o Arquiteto não planeja a próxima Task durante a construção. O marcador sem o perfil é ignorado.
- **M3 — modo benchmark (G18):** `guards.json` → `"bench": { "arm", "answers", "foreground" }`. O **`AskUserQuestion` é respondido pelo dossiê** (`[bench] resposta do stakeholder: <opção>`, por regra no `answers.json`; sem regra, a opção recomendada, nunca "Pedir mais contexto") e cada pergunta vai para `.team-project/benchmark/<arm>/questions.log`; `foreground` nega agente em segundo plano (o `claude -p` encerra antes da notificação). O **C2** aceita `n/a — navegação simulada (benchmark)` **só com `bench` ligado**; fora dele, R15 falha. O `SessionStart` avisa o modo ligado.
- **M4 — ritual "modo projeto":** `rituals/benchmark.md` §7 (projeto-padrão, braços P · N · N-forte, escopo de 1 sprint com cauda de `fix`, oráculo oculto, avaliação cega com rubrica de documentação e sonda de manutenibilidade, regra datada, laço de melhoria) e o modelo do `result.md` do modo projeto em `templates/benchmark.md`. O driver e o avaliador (M5) ficam no repositório do experimento.
- Matriz de propriedade (`models.json`; `.active-executor` junto de `.active-run`/`.active-spike`), manifesto, `how-to.md`, `COVERAGE.md` (G17, G18, perfil executor), `sprint-run.md` (§Modelo por papel, §Modo benchmark, passos 3, 4 e 8, pré-condição 1). v3.44 arquivada. Suítes: guardas **132 casos**, conferências **74**.
- **Não exercitado:** um `sprint run` real com `models.json`, com o perfil executor ou com `bench` ligado sob `claude -p`; o modelo **servido** pelo harness (conferido pelo `usage.jsonl`, G16); se o harness honra a negação do `AskUserQuestion` como resposta (o ensaio do P0 é o primeiro teste real).
---
## v3.46.0 — 2026-10-06

**Branch:** `feat/v3.46.0` empilhada sobre `feat/v3.45.1` · **Processo:** [`v3.46`](roles/scrum-master/process/process-changelog.md)
Terceiro e último pacote de `proposta-custo-run.md` (M2, M3, M5, M6, M7; decisões D2, D3, D5, D6, D7).

- **Plano em contrato**: regra 7 qualificada (o dev escolhe o corpo; o plano fecha comportamento, contrato, camada e standard); trecho literal até 15 linhas ou `**Validado em:**`; `**Mutações:**` por teste. **`scripts/checks/plan.ps1`** confere o plano antes do dev (lista, protegidos, blocos, trecho, mutações, trilha leve) — reprovado volta ao Arquiteto sem custo de dev.
- **Prova de falha por script**: `verify.ps1 -Mode mutation -Plan` troca o trecho declarado, roda o teste focado, espera exit ≠ 0 e restaura byte a byte; a árvore tem de voltar igual. C1 `R7-mutação` não fecha com mutação não pega. O QA amostra uma (`-Only`).
- **Trilha leve por Task** (R23): coluna `Trilha` no Sprint Backlog, critério mecânico, plano curto em Sonnet, QA nas frentes que a Task toca, mesma evidência.
- **Fechamento pela sessão**: `close.ps1 -Apply` marca ✅, grava Registro e Série, roda o `-Post` e imprime a entrada de status; o Agent `scrum-master` só quando o fechamento pede julgamento.
- **Arquiteto um passo à frente** (R1): planeja a Task independente seguinte durante a construção; lê o índice de `standards/` e só as seções da Task.
- v3.43 arquivada. Suítes: conferências 52 casos (11 novos), guardas 85.

---
## v3.45.1 — 2026-10-06

**Branch:** `feat/v3.45.1` empilhada sobre `feat/v3.45.0` · **Processo:** [`v3.45` — addendum v3.45.1](roles/scrum-master/process/process-changelog.md)
Segundo pacote de `proposta-custo-run.md` (M1): a verificação roda uma vez e quem confere não a repete.

- **`scripts/checks/verify.ps1`**: `focused` (teste do bloco) · `full` (build, lint, suíte, cobertura de `guards.json` → `verify`) · `check` (só compara). Log por comando e `result.json` em `.team-project/verify/<n>/<ID>/`, com código de saída real e a **impressão digital da árvore** (tree do git num índice temporário — arquivo novo não rastreado muda a impressão; o índice do projeto não é tocado).
- **QA** começa por `-Mode check`: árvore igual e verde → cita sem reexecutar; diferente → roda `full` uma vez. **Sessão** não reexecuta verificação de papel.
- **C1 `R7-verify`** (com `verify` configurado): não fecha com o `full` vermelho, ausente ou de uma árvore que mudou depois dele.
- R7 e R28 alinhadas; `team-update.md` 7h e `team-init.md` 4a preenchem `verify`; modelo do `guards.json`. Suítes: conferências 41 casos (8 novos), guardas 85 (1 novo).

---
## v3.45.0 — 2026-10-06

**Branch:** `feat/v3.45.0` a partir de `develop` (v3.44.2 mesclada) · **Processo:** [`v3.45`](roles/scrum-master/process/process-changelog.md)
Primeiro pacote de `proposta-custo-run.md` (relatório do primeiro `sprint run` do projeto-piloto: ~620 mil tokens por Task fechada, ~34 h corridas): medir certo antes de mudar o resto.

- **G16 — consumo medido** (`hooks/subagent-stop.ps1`, evento `SubagentStop`): cada rodada de subagente vira uma linha em `.team-project/usage.jsonl`, somada no transcript dele — tokens processados, contexto da 1ª chamada (carga fixa), pico e final, modelo servido, duração, Task, subagentes disparados. **Medido:** o número da notificação é o contexto da última chamada, não o processado (49 004 × 273 190; 53 245 × 322 194).
- **`scripts/checks/consumption.ps1`**: escreve as linhas medidas e os Totais do `consumption.md` aberto; a sessão não transcreve mais número. Coluna Tokens = processado; "Σ notificação" ao lado.
- **C1 R28 por Task**: jobs `operator/<n>/<T-ID>…/` e os citados no plano e na evidência × linhas `operator` daquela Task (antes: o sprint inteiro, e uma divergência reprovava todo fechamento seguinte).
- **Plano em blocos** acima de 8 arquivos (`### Bloco <k>` com Pronto objetivo), **uma instância de dev por bloco**, terceira instância do mesmo bloco em Sonnet.
- "Execução delegada" vira índice dos jobs nos relatórios e modelos; `team-update.md` 7g; `COVERAGE.md` (G16 e o que não cobre). Suítes: guardas 84 casos (3 novos), conferências 33 (5 novos).

---
## v3.44.2 — 2026-10-06

**Branch:** `feat/v3.44.2` a partir de `develop` (v3.44.1 mesclada) · **Processo:** [`v3.44` — addendum v3.44.2](roles/scrum-master/process/process-changelog.md)
Dois defeitos da heurística de escrita pelo `PowerShell`, achados no `guards.log` do primeiro `sprint run` de um projeto-piloto (04 a 06/10/2026).

- **Linha `erro` "IsPathRooted … Caracteres inválidos no caminho"** (7× no run: QA, `operator`, Arquiteto): um texto de string (`"List<T>"`, `"<td>"`) era lido como destino de redirecionamento e derrubava o hook — falha aberta, **sem G5/G8/G9 avaliadas no comando**. `Get-WriteTargets` descarta alvo com caractere inválido em caminho.
- **Falso positivo da G9** em `Env:MIG02_PROVA` (2×): drive do PowerShell que não é de arquivo (`Env:`, `Variable:`, `HKCU:`, `Cert:`…) era juntado à raiz do projeto. Sai da checagem de G5/G8/G9; na G14, drive da sessão (`Env:`, `Variable:`, `Function:`, `Alias:`) é liberado e outro drive (registro, certificados) é negado.
- `hooks/COVERAGE.md` (heurística do `PowerShell`, G14, `team:developer`/`team:operator` confirmados, custo do disparo em `Agent`, sonda desligada) · `proposta-guards-fase2.md` reduzida ao que fica pendente. Suíte de guardas: 81 casos (6 novos, todos reprovados pelo código anterior).

---

## v3.44.1 — 2026-10-06

**Branch:** `feat/v3.44.1` a partir de `develop` (v3.44.0 mesclada) · **Processo:** [`v3.44` — addendum v3.44.1](roles/scrum-master/process/process-changelog.md)
Burndown parado até o fim da Task (item do `note.md`): o Registro de transições sai do Sprint Backlog e passa a viver no `burndown.md`, ao lado da Série.

- **`templates/burndown.md`** ganha o **Registro de transições**; cada transição = uma linha no Registro + uma na Série, com o Evento citando a passagem (`T-041 🟦 → 🟨`). Saem os trechos anteriores ao `run` (granularidade só do `/sm board`, "fino fora do escopo", exemplo sem as passagens). **`templates/sprint-backlog.md`** fica só com o marcador vigente.
- **C1 (`close.ps1 -Post`) — R24** passa a exigir, além da linha → ✅, as passagens → 🟦/🟨/🟪 da Task no Registro e uma linha da Série por transição dela: Série com menos linhas é o burndown parado. O Registro é lido do `burndown.md`, e do `sprint-backlog.md` em sprint aberto antes desta versão (`Get-TransitionLog`, `lib.ps1`); o R20 do C1 e o R33/8 do C4 leem pelo mesmo caminho.
- R24, `workflow-sprint.md` §5f (reescrito com o `run`), `sprint-run.md` §Marcador, `artifact-ownership.md` §1, `workflow.md`, índice das regras, README do SM, `retrospective.md`, `project-context.md`, `deliverables/team-project/README.md`. Suíte de conferências: 28 casos (3 novos).

---

## v3.44.0 — 2026-10-06

**Branch:** `feat/v3.44.0` a partir de `develop` · **Processo:** [`v3.44`](roles/scrum-master/process/process-changelog.md)
`sprint run` e `fix run` sem trava: nenhuma guarda pergunta, e o pedido de permissão do harness deixa de parar um papel no meio da fila. Aplica `proposta-run-sem-travas.md`, com as decisões D1–D3 do stakeholder.

- **G8 nega código-fonte ao Arquiteto** fora de spike declarado em `.team-project/.active-spike`, com a rota na mensagem (scratchpad · `operator` no sprint · prova do teste com o dev); passa a valer também para escrita pelo shell. O Arquiteto decide a questão técnica e devolve a resposta; ao stakeholder sobem só mudança funcional, impacto significativo ou arquitetura fora do SDD (Arquiteto e PO).
- **G14 — run sem trava:** com `.team-project/.active-run` (gravado pela sessão no `sprint run` e no `fix run`), o operacional dos papéis já conferido pelas guardas sai liberado (`allow`) e o que está fora da lista é negado com a rota. Nova chave `runCommands` no `guards.json`.
- **G15:** todo pedido de permissão do harness vai ao `guards.log` (hook `Notification`, novo `hooks/notification.ps1`). A R27 ganha a segunda conferência: o transcript do subagente.
- **`/team init` e `/team update` (7f):** `runCommands` no `.team-project/guards.json` a partir do `developer/context.md`, só acrescentando. O plugin não escreve permissão nas configurações do Claude Code: a lista vive no `.team-project` e a G14 a aplica.
- G13 avisa marcador sobrando. Suíte de guardas: 75 casos (21 novos).
- **Addendum (segundo relato, mesmo dia):** todo agente do `sprint run` e do `fix run` em segundo plano, com a sessão aguardando a notificação (antes, só a Task pesada); os seis `commands/` deixam de fixar `run_in_background: false` no run; a G14 nega comando em segundo plano aos papéis (fora o `operator`); a R27 lê o transcript pelas três assinaturas do "interrupted" (permissão fechada, vigia de ~600 s, notificação coincidente).

---

## v3.43.0 — 2026-10-05

**Branch:** `feat/v3.43.0` a partir de `develop` · **Processo:** [`v3.43`](roles/scrum-master/process/process-changelog.md)
`sprint run` e `fix run` rodam a fila inteira sem parar fora do contrato — pré-requisito do benchmark de projeto sem intervenção. Aplica `proposta-run-interrupcoes.md` (P1–P5).

- **Paradas legítimas em lista fechada** (`sprint-run.md`): fim da fila, bloqueio de R22 sem Task elegível, pré-condição, interrupção do stakeholder. Fim de Task não é parada; "sigo?" e "parar na fronteira de História" são achado. Task 🔴 não para o `run`. O `fix run` segue as mesmas regras.
- **Gate protegido com rota:** o plano ganha `**Arquivos protegidos:**` e a §12 com o diff exato; a sessão principal aplica antes do dev (pedido de permissão do harness). A mensagem da G5 cita a rota.
- **Negação de guarda ao dev é 🔺 GAP**, nunca pergunta ao stakeholder; o plano lista o teste de cada arquivo de produção (regra 15). Timeout não é "limpo" (card do dev).
- **Interrupção pelo stakeholder:** sem reexecução, disco consistente, uma linha dizendo onde parou.
- **Marcador acompanha a Task:** no `run`, a sessão marca ⬜→🟦→🟨→🟪 (e →🔴) na hora — quadro, Registro de transições e burndown com data e hora; o `run` não aciona mais `board`.
- Suíte de guardas: 54 casos (3 novos, `ExpectErr`).

### Addendum (`/review note`, mesmo dia)
- **C1 e C4 leem o primeiro marcador** da linha `**Veredito:**` (`Get-VerdictMark` em `lib.ps1`): "✅ na 3ª rodada — antes ⚠️ e ❌" fecha; toda rodada do QA é um bloco `##` completo.
- **`**Desvio aceito:**`** na evidência e no veredito: arquivo fora do plano com decisão datada (Arquiteto ou stakeholder) deixa de reprovar o R4 no C1.
- **`operator`**: código de saída do próprio comando (`$LASTEXITCODE` → `EXIT=<n>` no log), prova que deve reprovar comparada ao esperado, `report` conferido em disco antes de responder; pasta do job com o número do sprint (`operator/1/`) — o C1 aponta `operator/sprint-<n>/`.
- Suíte de conferências: 25 casos (5 novos).

---

## v3.42.0 — 2026-10-04

**Branch:** `feat/v3.42.0` a partir de `develop` · **Processo:** [`v3.42`](roles/scrum-master/process/process-changelog.md) e o addendum da [`v3.41`](roles/scrum-master/process/process-changelog.md) (antes previsto como v3.41.1, entregue aqui)
Fase 2 das guardas: as regras de papel deixam de depender só do texto que o agente lê. A sonda num `/sm sprint plan` real confirmou que o hook recebe `agent_type` = `team:<papel>` dentro do subagente e nada na sessão principal.

- **Seis guardas por papel** em `hooks/pre-tool.ps1`: **G5** nenhum subagente edita arquivo de gate (`guards.json` → `protectedPaths`) · **G6** o dev não acrescenta teste ignorado (`testSkipPatterns`) · **G7** Arquiteto, QA, dev e UX só disparam o `operator` (R28; `Agent` entra no matcher) · **G8** matriz de propriedade — `hooks/ownership.json`, derivado de `artifact-ownership.md` §1, nega escrita no arquivo de outro dono; **pergunta** ao stakeholder quando o Arquiteto vai escrever código · **G9** o dev só escreve no produto os arquivos do plano ativo (R4 · R8) · **G11** o `operator` só escreve na pasta do job.
- **`.team-project/.active-task`** (novo, SM, escrito pela sessão): Task ou bloco `fix` em execução e o caminho do plano — gravado antes de todo disparo do dev (`sprint run`, `fix run`, `/dev`) e apagado quando ele sai.
- **Plano de Implementação:** `**Arquivos tocados:**` vira lista fechada, um caminho por linha entre crases (regra 15 do modelo) — é o que a G9 lê. O `fix-plan.md` já usava `- produção:`/`- teste:`.
- **`guards.json`** ganha `protectedPaths`, `sourceRoots`, `testSkipPatterns` (o `/team update`, passo 7e, acrescenta sem sobrescrever).
- **C3** confere `hooks/ownership.json` × matriz (linha e dono de cada regra). Suítes: 51 casos de guarda (30 novos), 20 de conferência.
- **Cards** (`developer`, `architect`, `quality-assurance`, `user-experience`, `operator`) citam a guarda que garante a frase; `hooks/COVERAGE.md` declara o que cada uma não cobre. Custo medido: ~0,8–1,2 s por disparo.

### Antes previsto como v3.41.1 — decisão em formulário no fim de qualquer modo (R22)
Decisões do stakeholder no fim de um modo chegavam em prosa, não em formulário (R22) — achado no `/sm sprint prepare`.

- **`prepare` ganha o passo 7:** a sessão consolida as decisões que só o stakeholder toma e chama `AskUserQuestion` (até 4 por chamada, várias chamadas) antes de encerrar. "Não sobe ao stakeholder" passou a "não cria portão nem aprovação".
- **R22 estendida a qualquer modo** (`plan`, `run`, `fix plan`…): resumo com "responda ou aceite as recomendações" é achado contra a orquestração.
- **`commands/`** `sm`, `po`, `arc`, `ux`, `team`: "destaque a decisão" virou "leve em `AskUserQuestion`".
- **Guia rápido do `/team version`:** `fix` agrupado com pipe como o `sprint` (`fix [plan \| run]`) na tabela do `how-to.md` e no `argument-hint` do `sm.md`; `team.md` ganha a rota do `fix`.

**Como verificar:** `Select-String 'destaque' commands/*.md` sem resíduo sobre decisão; `scripts/checks/release.ps1` ok. Vale após atualizar o plugin e reiniciar a sessão.

---

## v3.41.0 — 2026-10-03

**Branch:** `feat/v3.41.0` a partir de `develop` · **Processo:** [`v3.41`](roles/scrum-master/process/process-changelog.md)
Contato remoto pelo celular — proposta `remote`, com o spike concluído (M1–M21) (SM + UX). Regra nova **R34** (34 regras); emendas em R15, R22, R25 e R27.

- **Novo modo `/team remote`** (`rituals/team-remote.md`): identificador do projeto (3–8 letras) e conta remota (pessoal ou organização, por projeto), pré-requisitos medidos (versão, conta, suspensão da máquina, política da organização), comando de abertura `claude --remote-control "<ID> · <produto>"` e verificação de ponta a ponta pelo celular. A sessão roda na máquina, por **Remote Control**; o app do Claude conecta-se a ela.
- **Identidade e pendência:** em projeto remoto, toda pergunta começa com `[<ID> · <onde> · <ponto>]` e a pendência é gravada na §7 do `README.md` antes do formulário. "Pular" (`[No preference]`) ou expirar nunca é decisão. A **guarda G3** passa a conferir prefixo e pendência; o **C2** ganha a linha R34.
- **① e ③ pelo celular:** "aprovar" declara a navegação do protótipo (a responsabilidade é do stakeholder); a pergunta leva o link do protótipo publicado como **artifact privado** pela conta remota, e o registro anota canal, URL e rótulo da versão. O protótipo passa a ser um **`index.html` único** e autocontido.
- **Fim do `sprint run`** termina em formulário de autorização da Review — iniciar agora · depois · resolver bloqueio antes · pedir mais contexto —, nos dois canais. O fim do `fix run` continua sem formulário (R33).
- **Limitações medidas:** sem notificação *push* no Android (abrir **App → Code**); Remote Control não roda na extensão do VS Code; a suspensão da máquina derruba a sessão (a pendência fica em disco).
- **Aplicado em** `commands/team.md` (modo `remote`), `sm.md`, `po.md`, `ux.md`, `agents/user-experience.md`, `how-to.md` (seção "Responder pelo celular"), `rituals/team-update.md` (passo 7d), `hooks/COVERAGE.md`.

**Como verificar:** `Select-String '^### R\d+\.' roles/scrum-master/process/working-rules.md` → 34; `run-guard-tests.ps1` (21 casos) e `run-check-tests.ps1` (19 casos) verdes; `scripts/checks/release.ps1` ok.

**Pendente (stakeholder):** reiniciar a sessão; `/team update` nos projetos (passo 7d: campos remotos vazios); `/team remote` em cada projeto que for responder pelo celular; consolidar protótipos antigos com `flows/`/`assets/` num `index.html` no próximo ciclo do UX.

---

## v3.40.0 — 2026-10-03

**Branch:** `feat/v3.40.0` empilhada sobre `feat/v3.39.0` · **Processo:** [`v3.40`](roles/scrum-master/process/process-changelog.md)
Trilha **Correção** (`fix`) ao lado da trilha Sprint — proposta `fix`, terceira da rodada evaluation → guards → fix (SM + PO + Arquiteto + QA + UX). Regra nova **R33** (33 regras); emendas em R15, R20 e R25; R23 mantida.

- **Novos modos `/sm fix` · `fix plan [<F-ID> …]` · `fix run`:** o stakeholder anota o sintoma em `note.md`; o `fix plan` faz a triagem (PO classifica; QA reproduz os defeitos em lista), monta o **bloco** `B-<nnn>` (até 5 Correções e 2N arquivos), leva os **ajustes** a um formulário e o Arquiteto escreve um mini-plano por Correção (C5–C8). O `fix run` corrige uma Correção por vez, com teste que **falha antes e passa depois**, e o QA dá veredito **por Correção**. Uma invocação por papel para o bloco inteiro.
- **Elegibilidade C1–C8:** nada de requisito, tela ou contrato novos, dado sensível, mais de N=5 arquivos, dependência ou causa desconhecida. Critério que cai **promove** aquela Correção à trilha Sprint; o resto do bloco segue. O ✅ do QA encerra a Correção — sem aceite na Review; reabrir é anotar no `note.md` citando a F-ID.
- **Consumo próprio:** o bloco tem `fixes/B-<nnn>/consumption.md` — terceiro destino do registro, com prioridade, fora do sprint e do burndown; a triagem fica nos destinos de hoje (Nota `triagem;`).
- **C4 `scripts/checks/fix.ps1`:** `-Pre` no início do `fix run` (bloco planejado, nenhuma Task em construção, teto); no fechamento, critérios assinados, reprodução, teste antes/depois, veredito, arquivos, promoção com motivo — exit 1 impede só as Correções que falharam de fechar.
- **Modelos novos:** `fix-run.md` e `fix-log.md` (SM), `fix-card.md` (PO), `fix-plan.md` (Arquiteto), variante trilha fix do `verdict.md` (QA); modo "texto de tela" do UX (só com citação literal). Aplicado em `commands/sm.md`, `po.md`, `qa.md`, `how-to.md` (cenário D reescrito) e `README.md`.

**Como verificar:** `Select-String '^### R\d+\.' roles/scrum-master/process/working-rules.md` → 33; `run-check-tests.ps1` com os casos do C4 verdes; `scripts/checks/release.ps1` com R17 e R18 ok.

**Pendente (stakeholder):** reiniciar a sessão (comandos novos); `/team update` nos projetos (rótulos N e teto no `README.md` do projeto); primeiro bloco real para calibrar N, teto e o indicador de custo por Correção.

---

## v3.39.0 — 2026-10-02

**Branch:** `feat/v3.39.0` empilhada sobre `feat/v3.38.0` · **Processo:** [`v3.39`](roles/scrum-master/process/process-changelog.md)
Regra mecânica vira guarda ou conferência; o LLM fica com o julgamento — proposta `guards`, **fase 1**, segunda da rodada evaluation → guards → fix (SM + QA). Sem regra nova.

- **Guardas (hooks do plugin, `hooks/`):** **G1** nega commit com arquivo de `.team-project/` no stage, inclusive remoção (R31); **G2** nega escrita na cópia instalada do plugin; **G3** nega formulário cuja última opção não é "Pedir mais contexto" (R22, toda pergunta); **G4** avisa saída de comando acima de 300 linhas, exceto dentro do `operator` (R28); **G13** abre a sessão com as guardas ativas. Falha aberta: erro de script nunca bloqueia. Custo medido: 0,6–0,8 s por disparo. Limites de cada uma em `hooks/COVERAGE.md`.
- **Conferências (`scripts/checks/`):** **C1** `close.ps1` abre o `/sm close` e confere R1, R4, R7, R8, R12, R16, R20, R24 (`-Post`), R25, R26, R28 e R30 — **exit 1 (não fecha) se R7 ou R12 falharem**; **C2** `project.ps1` (R14, R15, R21, R31) na retrospectiva e no onboarding; **C3** `release.ps1` (R17, R18, modelos órfãos) antes do PR e no `/review audit`.
- **Formatos que os scripts leem:** a evidência do QA ganha `### Documentos vivos (R12)` e `### Escopo` (`**Fora do plano:**`); o pacote de abertura ganha `**Aprovado em**`. `working-rules-index.md` ganha a coluna "Instrumento"; as linhas "SM verifica" citam G/C.
- **`.team-project/guards.json`** (liga/desliga por projeto, sonda da fase 2) e **`guards.log`**; criados pelo `/team init` e pelo `/team update` (passo 7c). O passo 7b desliga a G1 durante a migração do R31.
- **Critério de entrada no `/review`:** regra de verificação mecânica só entra com a guarda ou a conferência junto. `hooks/` e `scripts/` são do stakeholder.
- **Fora desta versão:** fase 2 (guardas por papel, G5–G11) depende do `agent_type` de agente de plugin, não documentado — a sonda (`"probe": true`) registra o valor real; fase 3 (`close` bloqueado pelo hook) só depois de 2 sprints de C1 sem divergência.

**Como verificar:** `powershell -NoProfile -File scripts/checks/tests/run-guard-tests.ps1` (17 casos) e `run-check-tests.ps1` (12 casos) verdes; `scripts/checks/release.ps1` com R17 e R18 ok; depois de reiniciar, `/hooks` lista os três eventos do plugin.

**Pendente (stakeholder):** reiniciar a sessão (hooks e comandos); `/team update` nos projetos (passo 7c cria o `guards.json`); disparo real de G1–G4 numa sessão de teste; uma sessão com a sonda ligada (`/po status` + `/dev` de calibração) e o `guards.log` levado ao `/review` da fase 2; rodar o C1 contra uma Task já fechada de um projeto real e comparar com o fechamento manual.

---

## v3.38.0 — 2026-10-02

**Branch:** `feat/v3.38.0` a partir de `develop` · **Processo:** [`v3.38`](roles/scrum-master/process/process-changelog.md)
Medir custo **e** resultado do time, e comparar com o Claude sem o plugin — proposta `evaluation`, primeira da rodada evaluation → guards → fix (SM + PO + QA). Sem regra nova; carga fixa só nas linhas de `commands/po.md` e `qa.md`.

- **Registro de consumo com Categoria e Unidade:** cada invocação é classificada em `especificação · produção · verificação · retrabalho · cerimônia` (retrabalho = depois do primeiro ⚠️/❌ ou de 🔺 GAP) e ligada a uma unidade (`H-nnn`, `F-nnn`, `sprint-<n>`). **Linha de sessão** a partir do `/usage` colado pelo stakeholder — o único custo em US$ observado —, lida **à parte** até a verificação no projeto-piloto.
- **Retrospectiva com "Custo × resultado":** tokens e US$ por História aceita, % por Categoria, aprovação na 1ª passada do QA, GAPs por Task, defeitos que escaparam (janela de 2 sprints) e toques no stakeholder.
- **Defeito que escapou:** `/po bug` e `/po note` registram a **História do aceite** (`H-nnn + sprint do aceite` · `H-nnn · fora da janela` · `não identificada` · `não aplicável`); o QA a grava em `pending.md` sem reinterpretar.
- **Experimento A/B/C (`rituals/benchmark.md`, sob demanda):** plugin × Claude direto com a especificação × Claude direto só com o pedido (+ B′ com guarda-corpos, quando `guards` existir), avaliação cega, regra de decisão **datada antes da 1ª execução** — padrão 50% · 3× · 25%, mínimo de 3 defeitos de diferença, faixa "inconclusivo → ampliar a amostra". Modelo `benchmark.md` (SM); pasta `.team-project/benchmark/`, não semeada.
- **Aplicado em `commands/po.md`, `commands/qa.md`, `how-to.md` (cenário H), `README.md` (estrutura, banner).**

**Como verificar:** `Select-String 'Categoria \| Unidade' roles/scrum-master/templates/consumption.md` → 2 linhas (variante fora de sprint e modelo do sprint); `grep "História do aceite"` em `roles/` e `deliverables/` com os mesmos quatro valores; `rituals/benchmark.md` apontado por `how-to.md`, `README.md`, `artifact-ownership.md`, `deliverables/team-project/README.md` e `templates/benchmark.md`.

**Pendente (stakeholder):** reiniciar a sessão (comandos `po` e `qa` mudaram); `/team update` nos projetos — o passo 8 mostra as colunas novas do `consumption.md` e pede aprovação (sprint fechado não muda); verificar no projeto-piloto se o `/usage` inclui os subagentes (um `/po status` com `/usage` antes e depois) e levar o resultado ao `/review`.

---

## v3.37.0 — 2026-10-02

**Branch:** `feat/v3.37.0` a partir de `develop` · **Processo:** [`v3.37`](roles/scrum-master/process/process-changelog.md)
Consultoria externa especializada (R32), conduzida pelo SM, aplicada a partir da proposta do stakeholder (SM + PO + Arquiteto + QA + UX).

- **Novo modo `/sm consulting <domínio> <tema>`:** segunda opinião **externa** — técnica (`database`, `security`, `design`, `architecture`, `infrastructure`) ou de negócio (`business:<área>`). O plugin não chama consultor: produz e consome Markdown, e o stakeholder transporta cada rodada a um consultor (humano ou IA) do **registro do projeto** (`.team-project/README.md` §7a, lista de áreas livre).
- **Fluxo:** SM abre o caso em `.team-project/consulting/C-<nnn>-<slug>/` · papéis do domínio escrevem a carta · **QA assina a sanitização de toda rodada que sai** (+ PO no `business`) · validadores conferem o contrato e o critério de consenso · **até 3 réplicas** · Arquiteto escreve `adr-proposal.md` (técnico) ou PO `business-proposal.md` (negócio) · stakeholder escolhe em formulário R22 · ADR em `docs/` ou regra no SDD funcional, **sem citar `consulting/`** (R31) e, no negócio, sem solução técnica (R20).
- **Só fora do `sprint run`** (R25 intacta): caso aberto quando o sprint arranca fica suspenso até o `sprint close`.
- **Modelos novos:** `consulting-case`, `service-letter`, `consultant-response`, `reply` (SM) · `adr-proposal` (Arquiteto) · `business-proposal` (PO). `project-context.md` ganha o §7a com uma lista de exemplo comentada, não vinculante.
- **Aplicado em `commands/sm.md`** (modo na tabela, `argument-hint` e pré-condição), `how-to.md` (cenário G), `README.md` (modo, banner) e contagem de regras (31 → 32).

**Como verificar:** `Select-String '^### R\d+\.' roles/scrum-master/process/working-rules.md` → 32; `/sm consulting security <tema>` num projeto com sprint em `run` → para e reporta; fora dele, abre `consulting/C-001-…/case.md`.

**Pendente (stakeholder):** reiniciar a sessão (comando novo); `/team update` nos projetos para trazer o §7a e os modelos.

---

## v3.36.0 — 2026-10-01

**Branch:** `feat/v3.36.0` a partir de `develop` · **Processo:** [`v3.36`](roles/scrum-master/process/process-changelog.md)
Rodada de `/review note` sobre falha de ambiente, execução em segundo plano e relatório ao dono do plugin (SM), com a fusão de um guia de raiz e a mudança dos guias de ritual para `rituals/`.

- **R27 confere a energia e retoma o mesmo agente:** antes de retentar uma invocação interrompida sem ação do stakeholder, a orquestração confere os eventos de energia/suspensão do SO na janela da falha e classifica **falha de ambiente com causa e horário** (suspender o PC é decisão do stakeholder, não defeito do plugin). A retentativa é **retomada por `SendMessage`**; instância nova só se o agente não existe mais, depois de ler o disco (R5).
- **Task pesada em segundo plano:** no `/sm sprint run`, Task com estimativa ≥ 2× a mediana do sprint (ou que já acionou o `operator`) dispara `architect` e `quality-assurance` com `run_in_background: true`; a série (R1) se mantém.
- **Ocorrência de plugin:** ≥ 2 falhas R27 persistentes ou consumo de um papel > 2× a média dos últimos sprints. O `run` **só registra**; a **Review** abre, uma vez no sprint, o formulário **investigar · ignorar e seguir · pedir mais contexto**. `plugin-report.md` passa a existir **só com "investigar"**.
- **`replicate-in-new-project.md` removido**, fundido no `how-to.md` (nova seção "Calibrar a instalação", com composição de modelos, validação inicial e checklist). Ponteiros repontados; índice do `README.md` ganha `team-version.md`.
- **Guias de ritual em `rituals/`:** `review-contract.md`, `team-init.md`, `team-update.md` e `team-version.md` saem da raiz. Ponteiros repontados em `commands/team.md`, `commands/review.md`, nos quatro `agents/` que citam o contrato, `README.md`, `artifact-ownership.md`, `workflow-processo.md`, `working-rules.md` e `deliverables/team-project/README.md`. **Migração:** projeto instalado em versão anterior lê esses guias pela raiz do plugin; o `/team update` traz as duas mudanças juntas e elas só valem **depois do reinício da sessão**.
- **Descartado:** aviso para impedir a suspensão do PC (decisão do stakeholder: é dele, não do plugin).

- **Propostas de `commands/` aprovadas e aplicadas:** `commands/sm.md` (R27 com energia e retomada por `SendMessage`) e `commands/arc.md`/`commands/qa.md` (`run_in_background: false` salvo no `sprint run` de Task pesada).

**Pendente (stakeholder):**
- **Verificar:** reinício da sessão (comportamento de agente) e, na primeira falha de invocação, o relato com energia e forma de retomada.

---

## v3.35.0 — 2026-09-30

**Branch:** `feat/v3.35.0` a partir de `develop` · **Processo:** [`v3.35`](roles/scrum-master/process/process-changelog.md)

Rodada de `/review note` sobre o log do `operator` no git e o consumo fora de sprint (SM + PO + Arquiteto/Dev + QA + UX), com as mudanças de `agents/`, `commands/` e dos guias de raiz autorizadas pelo stakeholder. **Quebras de compatibilidade:** o `.team-project/` deixa de ser versionado e o modo `/arc comply` deixa de existir.

- **`.team-project/` inteiro fora do git (R31, nova):** `.gitignore` com `.team-project/` na raiz. O repositório do projeto recebe só o produto — código e `docs/` —, e o estado da gestão (backlog, sprints, evidências, consumo, logs do `operator`, protótipos) fica local. **Documento de produto nunca referencia `.team-project/`**: os modelos de SDD, ADR e implementação foram ajustados pelos donos.
- **R28 enxuta:** cada chamada ao `operator` deixa um `report.md` (trecho decisivo, contagens, ponteiro) com **teto de 200 linhas e 20 KB**; várias chamadas na mesma pasta de job → um `report-<log>.md` por chamada; o build de fim de passo do dev continua dele, isento de `report`. No aceite, `report` ausente é rejeição e acima do teto é achado de processo. A poda do log bruto é gestão de disco local; log podado não é achado. Em documento de produto, só o trecho — o ponteiro fica no artefato de processo que o cita.
- **Consumo fora de sprint:** `.team-project/consumption.md` na raiz, no mesmo modelo do do sprint, Nota `pre-sprint;`/`entre-sprints;`, sem rotação e sem transcrição. Substitui a subseção "Consumo pré-sprint" de `context.md` e o passo 9 da Planning. Os comandos de papel gravam no do sprint quando há sprint aberto, senão no da raiz.
- **`operator`:** `report` com teto conferido antes de devolver; `report-<log>.md` por chamada na mesma pasta; `pre-sprint/` vale para "sem sprint aberto". O dono de `.team-project/operator/**` é declarado: o SM verifica e poda, o papel chamador cita.
- **`/team init`:** acrescenta `.team-project/` ao `.gitignore` (só acrescenta) e cria o `consumption.md` vazio.
- **`/team update` — passo 7b (migração, com passos destrutivos):** (a) `.gitignore`; (b) `git rm -r --cached .team-project` + commit; (c) limpeza do histórico com backup obrigatório (cópia local e `git clone --mirror`), `git filter-repo --path .team-project --invert-paths` e `git push --force` de branches e tags; (d) verificação por `git log --all -- .team-project` vazio e `git count-objects -vH`. **Cada passo destrutivo exige a confirmação explícita do stakeholder no momento da execução.** Projeto que não é repositório git pula o bloco.
- **Reavaliação do conjunto (rodada 4):**
  - **`/arc comply` removido** (**quebra**): o modo e o modelo `compliance-review.md` deixam de existir. A aderência de execução ao plano e a de standard ficam só na frente 2 do `/qa`, em toda Task. Pedido `/arc comply` agora cai no roteamento normal.
  - **`standards/` passam a "Vigente".**
  - **`01-scope-and-criteria.md` migra para Sprint/História:** Histórias (H-nnn) por sprint, `[x]` só com o aceite na Review (R21) e congelamento por R4/R25.
  - **Carga fixa restaurada a 61,8 KB** (agente + comando dos seis papéis; `/sm` em 13,4 KB, dentro da meta de 13,5 KB). R28 enxuta (8,9 → 6,1 KB); o consumo fora de sprint tem fonte única em `templates/consumption.md`.
  - **Fontes únicas e limpeza nos documentos dos papéis** (PO, QA, UX, Arquiteto/Dev): critérios do protótipo, gatilhos de GAP, R16, checklist de segurança e ADR; citações de passo nomeadas ("prepare, passo N" · "Planning, passo N"); "ponteiro do `report`" em todo o alcance.
- **R31 no índice das regras:** 31 regras (R1–R31).

**Verificar:** depois de atualizar, reinicie a sessão, porque as mudanças de `agents/` e `commands/` só valem depois disso. Em cada projeto: rode o passo 7b do `/team update` e confira `git ls-files .team-project` vazio e `git log --all -- .team-project` vazio. Colaboradores precisam re-clonar ou rebasear depois do `push --force`; o GitHub pode manter objetos em cache e em PRs antigas. No primeiro sprint após a atualização: nenhum `report` acima de 20 KB, nenhum `report` sobrescrito por segunda chamada na mesma pasta, e `.team-project/consumption.md` com uma linha por invocação fora de sprint.

---

## v3.34.0 — 2026-09-29

**Branch:** `feat/v3.34.0` a partir de `develop` · **Processo:** [`v3.34` e `v3.34 (parte 2)`](roles/scrum-master/process/process-changelog.md)

Rodada de `/review note` sobre a cadência do sprint e os comandos de execução (SM + PO + Arquiteto/Dev + QA + UX), seguida de verificação de gaps, inconsistências, redundâncias e tokens. As mudanças de `agents/` e `commands/` foram autorizadas pelo stakeholder.

- **Cadência do sprint no `/sm`:** `sprint prepare → sprint plan → sprint run → sprint review → sprint close`. O `prepare` (novo) leva as candidatas até a DoR antes da Planning, sem aprovação do stakeholder. O `/sm review` continua como alias de `sprint review`.
- **`/sm sprint run`** substitui o `/team cycle`. O roteiro fica em `roles/scrum-master/process/sprint-run.md`. O run retoma pelo marcador da Task, sem replanejar, e fecha a Task quando o veredito é ✅ e marca "Documentos vivos (R12): atualizados". Não aciona o stakeholder por Task.
- **`/sm brainstorm`** substitui o `/team brainstorm`. PO, UX e Arquiteto ganham roteiro próprio para as fases 1 e 2.
- **`/team`** fica só com `init · update · version`. Saem `cycle`, `plan`, `build`, `qa` e `brainstorm`, sem alias.
- **Formulário nos portões ①②③④ (R22):** aprovar · aprovar com ajuste · reprovar · pedir mais contexto. O ③ é um formulário único, registrado na linha "Decisão do stakeholder" do Sprint Backlog. O ④ é uma pergunta por História, com ponteiro para o dossiê `review.md#aceite--h-<nnn>`. O SDD técnico é escrito pelo `/arc`, e a sessão que o chamou abre o formulário do ②.
- **DoR dividida:** a DoR-a é verificada no `prepare`, e a DoR-b é a varredura de bloqueios na Planning. As candidatas ficam gravadas em `context.md`.
- **Plano fora de sprint** (calibração antes da 1ª Planning): `.team-project/architect/plans/`.
- **Normativos divididos:** `workflow.md` (94 KB) vira um núcleo de 39 KB mais `workflow-ritos.md`, `workflow-sprint.md` e `workflow-processo.md`, com a numeração de seção mantida. `working-rules-index.md` indexa R1–R30 para o `/sm close`.
- **Carga fixa (agente + comando):** cai de 95,0 KB para 61,8 KB nos seis papéis (−35%) e de 12,4 KB para 2,9 KB no `/team`. Consumo e formulário R22 passam a ter fonte única (`templates/consumption.md` §Como gravar e `working-rules.md` R22).
- **`/sm sdd`** (novo): depois do `brainstorm` (ideia nova) ou do `/po analyze` com decisão (evolução de área documentada), orquestra SDD funcional + jornadas + protótipo → ① → SDD técnico da fatia → ② → Histórias no backlog. Os formulários de ① e ② são do próprio `sdd` (avulso não decide portão); no caso B, só as seções afetadas, com dispensa de portão por delta nulo declarado com motivo. Retoma na etapa em que parou. O `prepare` só aceita Histórias de SDD aprovado. Roteiro em `roles/scrum-master/process/workflow-sdd.md`.
- **Plano de calibração** (antes da 1ª Planning) em `.team-project/architect/calibration/` — não colide com o caminho legado `architect/plans/` que o `/team update` migra.
- **`how-to.md` reescrito por uso:** mapa "o que você quer → comando", seis cenários (projeto novo · retomada · evolução · correção · pedido no meio do sprint · trabalho interrompido), os quatro portões numa tabela e a solução de problemas de instalação no fim. O caminho de correção pontual passa a ser `/sm board` → `/sm sprint run <T-ID>`.

**Verificar:** depois de atualizar, reinicie a sessão, porque as mudanças de `agents/` e `commands/` só valem depois disso. Na primeira elaboração de SDD, ① e ② saem em formulário do `/sm sdd` e ficam registrados em `.team-project/scrum-master/context.md`. No primeiro sprint:
- o `prepare` grava as candidatas;
- nenhum plano tem data anterior ao ③;
- todo portão sai em formulário;
- nenhuma Task fecha sem "Documentos vivos: atualizados".

Remedir a tabela de custo em `workflow-processo.md` §5c (meta: `/sm` ≤ 13,5 KB).

---

## v3.33.1 — 2026-09-29

**Branch:** `feat/v3.33.1` a partir de `develop` · **Processo:** [`v3.33.1`](roles/scrum-master/process/process-changelog.md)

Rodada de `/review` sobre o consumo do `operator` (SM + Arquiteto/Dev + QA + UX), com as mudanças de `agents/`/`commands/` autorizadas pelo stakeholder.

- **O chamador retrata o `operator`:** Arquiteto, Dev, QA e UX fecham o relatório com a seção **"Execução delegada"**, com uma linha por chamada ao `operator` (job · Task/História · Modelo · Tokens · Duração). Sem número: "não disponível — motivo", nunca estimado. O `operator` não relata o próprio consumo.
- **A sessão grava:** `/arc` `/qa` `/ux` `/dev` `/team` transcrevem cada linha da seção para `consumption.md` como papel `operator`, com a Nota `chamado por <papel>; job <caminho>`. Continua um escritor só por registro.
- **Totais com o `operator`:** o total do sprint soma os papéis e o `operator`, exposto em linhas `operator ← <chamador>` com o modelo dele. A premissa é que o número do papel não inclui o do `operator` aninhado; se uma medição mostrar o contrário, a regra volta ao `/review`.
- **Retro e `plugin-report.md`:** por Task/História, consumo do chamador × consumo do `operator` que ele chamou, como candidato a investigar, sem afirmar economia não medida.
- **R28:** o SM passa a verificar as chamadas ao `operator` × linhas `operator` no registro. Chamada sem linha é achado contra o chamador.
- **Jobs pré-sprint:** jobs em `.team-project/operator/pre-sprint/` (onboarding, brainstorm, portão ①) entram no primeiro `consumption.md` do projeto, lançados pelo SM no `/sm sprint plan`, com a Nota `pre-sprint;`, e são contados uma vez.
- **Arquiteto com modelo verificável:** a seção "Execução delegada" do Arquiteto vai para a seção 11 do Plano de Implementação ou para o novo modelo `roles/architect/templates/spike-checkpoint.md`, e é repetida na resposta.
- **Evidência do QA:** as seções de `evidence.md` viram títulos `###`, iguais aos do veredito.

**Verificar:** no primeiro sprint após a atualização, todo relatório de papel que delegou traz "Execução delegada", e o número de linhas `operator` em `consumption.md` bate com o de jobs do sprint. Mudança em `agents/`/`commands/` só vale após reiniciar a sessão.

---

## v3.33.0 — 2026-09-29

**Branch:** `feat/v3.33.0` a partir de `develop` · **Processo:** [`v3.33`](roles/scrum-master/process/process-changelog.md)

Rodada de `/review note` sobre consumo e melhoria de processo na retrospectiva (SM), com as propostas de `commands/` aprovadas pelo stakeholder.

- **Modelo no registro de consumo:** coluna **Modelo** por invocação — o configurado no cartão do agente (ou o override passado ao disparar), não o servido; sem leitura, "não disponível — motivo". Os comandos `/sm` `/po` `/arc` `/ux` `/qa` `/dev` `/team` passam a gravá-lo.
- **Retro analisa ineficiência:** repetição do mesmo papel na mesma Task, Task cara, papel desproporcional à carga fixa, modelo × trabalho, consumo × falha.
- **`plugin-report.md`:** relatório ao dono do plugin, sem contexto do projeto, escrito pelo SM no `/sm sprint close`; o stakeholder lê e encaminha, e o `/review` no clone-fonte transforma em mudança.

## v3.32.0 — 2026-09-25

**Branch:** `fix/v3.32.0` a partir de `develop` · **Processo:** [`v3.32`](roles/scrum-master/process/process-changelog.md)

Rodada de `/review note` sobre teste funcional do QA (SM + QA + PO), com as propostas de `agents/`/`commands/` aprovadas pelo stakeholder.

- **R30 — cenário de teste funcional e regressivo:** na Planning, o QA mapeia por Task os cenários novos e os regressivos afetados, a partir do critério de aceite do PO e do protótipo funcional; Task não constrói sem cenários mapeados (DoR) e o veredito não fecha sem executá-los (DoD).
- **Suíte de cenários** em `.team-project/quality-assurance/scenarios/` (`SC-nnn`), dono QA, acumulada fora da pasta do sprint; a Task do Sprint Backlog só referencia os IDs (coluna nova **Cenários**). Modelos novos: `scenario.md` e `scenarios-index.md`.
- **GAP de cenário:** bloqueante vira Task no sprint corrente (R25); não bloqueante vai de `pending.md` ao PO, que abre a linha no Product Backlog citando o ID. Isso fecha a lacuna geral de GAP fora da Sprint Review.
- **Navegador:** `agents/quality-assurance.md` e `agents/operator.md` ganham `mcp__claude-in-chrome`. Cenário isolado roda no QA; grupo e suíte, no `operator` (R28). Sem a extensão conectada, o cenário fica ⚠️ não executado — sem ferramenta.
- **`/qa scenarios create`** e **`/qa scenarios run <SC-nnn|grupo|all>`** em `commands/qa.md`.
- `v3.29` arquivada no `process-changelog-archive.md` (R17).

**Verificar:** a Planning produz a coluna Cenários preenchida; `/qa <Task>` traz a tabela de resultado por cenário; `/qa scenarios run all` delega ao `operator`. Mudança em `agents/`/`commands/` só vale após reiniciar a sessão, e o navegador exige a extensão Claude in Chrome conectada.

---

## v3.31.0 — 2026-09-23

**Branch:** `feat/v3.31.0` a partir de `develop` · **Processo:** [`v3.31`](roles/scrum-master/process/process-changelog.md)

Rodada de `/review` sobre a reavaliação do conjunto: decisão do stakeholder de que **o QA confere a aderência do código ao Plano de Implementação**, e não o Arquiteto — a conferência é mecânica contra um plano escrito, e o Arquiteto é o papel mais caro.

- **Frente 2 do QA cobre os dois objetos, sempre, em todo `/qa <Task>` ao fim de cada Task do dev:** aderência de execução (tabela passo do plano × conforme, pelo novo campo **Conferência** de cada passo do plano) e completude/correção do standard citado (tabela seção exigida × citada). Task não fecha sem as duas (`workflow.md` §2a, §4a, §4a-i, §8).
- **Rota de volta:** código ≠ plano volta direto ao dev (`/dev resume`); defeito do plano vai ao Arquiteto (🔺 GAP/`/arc question`) e à fila do `/review`; defeito do standard, só ao `/review`.
- **`/arc comply` sai do ciclo e da rota de volta** — só roda como exceção pedida nomeadamente pelo stakeholder (`commands/arc.md`, `commands/team.md`, `commands/qa.md`, `roles/architect/*`).
- **Template do plano** ganha o campo **Conferência** por passo (regra 13) — critério objetivo para o QA; passo inconferível sem decidir é 🔺 GAP.
- `workflow.md:53` corrigido: `cycle sprint` já está implementado em `commands/team.md`.

**Verificar:** `/qa <Task>` produz as duas tabelas da frente 2; `/team cycle` devolve achado de execução direto ao dev, sem acionar o Arquiteto. Mudança em `agents/`/`commands/` só vale após reiniciar a sessão.

---

## v3.30.0 — 2026-09-22

**Branch:** `feat/v3.30.0` a partir de `develop` · **Processo:** [`v3.30`](roles/scrum-master/process/process-changelog.md)

Rodada de `/review note` sobre o relatório da sessão garden-management (21/09): 911 linhas / 360 turnos / 86M tokens numa única sessão sem `/clear` entre fases de natureza diferente — triagem, implementação, build nativo travado e resolução de conflito de merge —, com `cache_read` crescendo de 25K a 363K tokens turno a turno só pelo reenvio do histórico acumulado.

- **R29 nova — fase heterogênea começa em sessão nova.** Quando uma fase de trabalho chega a um estado verde (lint/build/teste passando) e a próxima etapa muda de natureza — por exemplo, entrar no build nativo/release —, a sessão que orquestra fecha ou `/clear` antes de abrir a etapa seguinte: ela não precisa herdar o histórico de diagnóstico de uma fase que já fechou. Cross-reference em `workflow.md` §2a (fecho da cadeia de Task) e na abertura do "Ciclo de uma entrega" (§5d).
- **Item sobre build em background fechado sem mudança normativa** — já coberto, de forma mais forte que a sugestão, pela R28/`agents/operator.md` (v3.29): a execução pesada já é delegada inteiramente ao `operator`, sem polling em primeiro plano.
- **Item sobre sequenciamento de branch do projeto-cliente fechado fora do alcance** — `/review` não prescreve convenção de git para o código do projeto-cliente, só para a entrega do próprio plugin (`review-contract.md` §Limites).
- **Curadoria de coerência de referência cruzada:** contagem de regras desatualizada ("25 regras… R13-R25") corrigida em `agents/scrum-master.md` e neste `README.md` para "29 regras… R13-R27".
- **`note.md` volta à fila vazia** — os três itens saem, tratados.

**Como verificar:** `Select-String '^### R\d+\.' roles/scrum-master/process/working-rules.md` devolve **29**. `Select-String '25 regras|R13-R25' -Path README.md,agents/scrum-master.md` devolve **zero**. `note.md` tem a seção **Abertas** vazia.

## v3.29.0 — 2026-09-22

**Branch:** `fix/v3.29.0` a partir de `develop` · **Processo:** [`v3.28`](roles/scrum-master/process/process-changelog.md) e [`v3.29`](roles/scrum-master/process/process-changelog.md)

Rodada de `/review note` sobre um incidente de custo: uma sessão consumiu **~303M tokens** em 20 subagentes, com o Arquiteto respondendo pela maior fatia. O mecanismo não era "muitas chamadas" — era a integral do contexto ao longo dos turnos: um log de build que entra na chamada 50 de 200 é relido nas 150 seguintes.

- **R28 troca um mecanismo impossível pelo implementável.** A regra mandava "descartar o log **do próprio contexto**" depois de extrair a falha — nenhum agente consegue, porque o histórico da conversa já recebeu os tokens. Agora a saída é **redirecionada para arquivo na origem** e só o trecho decisivo volta ao contexto. Era por isso que o incidente aconteceu **apesar** da regra: a metade verificável vinha sendo cumprida, e o custo queimava igual.
- **`agents/operator.md` novo — instrumento, não papel.** Agente descartável em `haiku` que roda a execução cara (build limpo, suíte completa, medição de toolchain, prova de gate), grava o log em disco e devolve só o relatório: comando · código de saída · veredito · contagens · versões · linhas decisivas verbatim · caminho e total de linhas do log. Uma invocação, um trabalho, um relatório. Não entra em cerimônia, não possui artefato, não aparece no quadro — as enumerações de "os seis papéis" seguem corretas.
- **Arquiteto, Dev, QA e UX ganham a ferramenta `Agent`**, restrita por contrato a **um único destino: o `operator`**. Sem a restrição, um papel poderia disparar outro e atropelar o fluxo plano→dev→QA e a propriedade de artefatos.
- **R26 aceita medição do `operator`** como a medição que exige — com comando, código de saída, versões e caminho do log —, caducando quando a toolchain muda ou o log some. Veredito `inconclusivo` nunca vale. Sem essa emenda, delegar seria ilegal pelo próprio processo.
- **A delegação que R28 fazia desde a v3.28 e ninguém cumpriu** foi escrita nos quatro papéis: tabela do que extrair por tipo de verificação, específica de cada um. O plugin estava em violação da própria regra.
- **Os quatro gatilhos de aprofundamento viram lista canônica dentro de R28**, e os `skills.md` passam a apontar em vez de redeclarar — redeclarar virou achado de processo. A duplicação já tinha divergido na prática: a redação do UX trazia uma glosa que nenhum outro papel tinha, e o Dev ficou sem a lista até uma segunda passada.
- **Trecho *e* ponteiro, nunca um sozinho**, em todo registro de evidência — definido uma vez em `standards/implementation-principles.md` §5.4 e referenciado pelos demais. Os modelos de entrega, veredito, evidência e aceite ganharam campo para o caminho do log, que antes não existia em nenhum.
- **O log vive em `.team-project/operator/<sprint>/<job>/`**, ou em `pre-sprint/<job>/` para o que roda antes do sprint 1 (onboarding, brainstorm, portão ①, linha de base). Retenção até o aceite do PO — ele é o último a precisar que o ponteiro resolva.
- **R26(i) alinhada nos ecos**: `agents/architect.md` e `roles/architect/README.md` ainda diziam "o primeiro passo exige"; a regra cobre o plano inteiro desde a v3.28.
- **R17 ganha a régua de contagem**: papel "movido" conta pelo **documento que mudou**, não por quem segurou a caneta — esta rodada moveu 6.

**Como verificar:** `Select-String '^### R\d+\.' roles/scrum-master/process/working-rules.md` devolve **28** (nenhuma regra nova — R28 foi reescrita, não duplicada). `Select-String -Pattern 'contagens não fecham' -Path roles/**/skills.md` devolve **zero** — a lista só existe em R28. `agents/` tem **7** arquivos. `note.md` tem a seção **Abertas vazia**.

## v3.27.0 — 2026-09-20

**Branch:** `feat/v3.27.0`, empilhada sobre `feat/v3.26.0` · **Processo:** [`v3.27`](roles/scrum-master/process/process-changelog.md)

Os três pontos que sobraram em `note.md` foram levados ao stakeholder em formulário (R22) e fechados. A fila fica vazia.

- **R17 — o teto por entrada passa a escalar com a rodada**: 10 KB para até dois papéis, **+2,5 KB por papel adicional**, teto absoluto de 20 KB. O que a regra combate é deliberação repetida, que não cresce com o número de papéis; registro de decisão cresce. A entrada passa a declarar quantos papéis moveu.
- **R17 — a medição ganha método**: bytes UTF‑8 com **decodificação explícita**. `Get-Content` sem `-Encoding utf8` infla ~7,5% e acusa estouro inexistente; a conferência é o total bater com o tamanho em disco.
- **R27 nova — falha de invocação não vira culpa do stakeholder**: chamada que volta interrompida/cancelada/recusada sem ação dele é retentada uma vez; persistindo, reporta-se **falha de ambiente** com o texto literal do harness, nunca "o usuário interrompeu".
- **R5 ganha o lado de quem orquestra**: relatório final que não chega obriga a **ler o estado em disco antes** de reinvocar o papel ou declarar perda.
- **`commands/team.md`** — seção "Quando uma invocação falha", com as duas obrigações onde quem orquestra as lê.
- **`v3.24` do changelog do processo arquivada**, íntegra, com o addendum datado que registra seu estouro da barreira antiga.

**Como verificar:** `Select-String '^### R\d+\.' roles/scrum-master/process/working-rules.md` devolve **27**. `/review history` mostra `v3.27`, `v3.26` e `v3.25`. `note.md` tem a seção **Abertas vazia** e nenhuma pendência parada.

## v3.26.0 — 2026-09-20

**Branch:** `feat/v3.26.0` a partir de `develop` · **Processo:** [`v3.25`](roles/scrum-master/process/process-changelog.md) e [`v3.26`](roles/scrum-master/process/process-changelog.md)

Rodada de `/review note` sobre o incidente T‑001, mais a descida do UX para Sonnet.

- **R26 nova** — o Plano de Implementação **mede o ambiente** antes de sair: comando e saída dos pré-requisitos, cada comando citado validado na versão medida, e parada incondicional para **pré-requisito ausente**, não só versão errada. Gate correspondente em `workflow.md` §8; seção **§3** nova no modelo de plano (§4–§10 renumeradas).
- **R9 ampliada** — quem recebe um 🔺 GAP **decide e registra a decisão no documento que governa a execução**, e devolve a execução a quem a tinha. Não reproduz na máquina, não roda a verificação do outro, não replaneja. Conferir afirmação verificável segue do QA, no veredito (R7). Reflexos em `/arc question`, na linha "Escala para" do dev, em `technical-decision.md`, nos dois `agents/` e nos dois `commands/`.
- **Gate não se mexe** — desligar, afrouxar, remover do build, trocar ou contornar um gate de qualidade é 🔺 GAP, nunca entrega; gate não exercitado **não conta como verificado**. No contrato do dev (item 6 endurecido, segue com 8 itens), no relatório de entrega e no `/arc comply`.
- **UX passa de Opus para Sonnet** — o papel mais caro por invocação do time (carga fixa ponderada 67 → 26,8; **2,5× mais barato por invocação**), mantendo a janela de 1M que o protótipo navegável exige. Haiku foi avaliado e descartado: 200K não sustenta o `index.html` ponta a ponta, e truncar quebra um portão. Indicador: o registro de verificação do próximo protótipo de sprint.
- **`consumption.md`** — notificação parcial de `SendMessage` na mesma invocação não abre linha nova.
- **`how-to.md`** — nota de troubleshooting do prefixo `/team:<comando>` quando há colisão de nome entre plugins instalados.
- **Addendum na `v3.24` do changelog do processo** — a entrada foi registrada acima da barreira de 10 KB da R17; registrada como addendum datado, sem reescrita, com o que isso expõe na regra em aberto para decisão.

**Como verificar:** `/review history` mostra as entradas `v3.26` e `v3.25`. `Select-String '^### R\d+\.' roles/scrum-master/process/working-rules.md` devolve **26**. `Select-String '^model:' agents/*.md` devolve opus 1 (architect), sonnet 4, haiku 1. A mudança de modelo do UX **só vale depois de reiniciar a sessão**.

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
