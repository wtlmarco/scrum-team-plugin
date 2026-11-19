# `/team update` — atualizar o plugin do time neste projeto

> Lido **apenas quando `/team` entra no modo `update`**. Roda **uma vez por bump de versão**, e por isso não fica em `commands/team.md`: aquele arquivo é injetado no prompt em *toda* invocação de `/team`, inclusive nas milhares que nunca usam `update`.

Roda **na cópia instalada** — o oposto do `/review`, que só roda no repositório-fonte. Compara a versão instalada com a do `main` da origem e, havendo versão nova, aplica. **Não dispare agente nenhum:** este modo é do comando, e é conversa com o stakeholder.

**Origem canônica:** `https://github.com/wtlmarco/scrum-team-plugin` (`main`).

## 1. Guarda de contexto

Se `${CLAUDE_PLUGIN_ROOT}/.git/` existir, este é o **repositório-fonte**, não uma instalação: pare e diga que aqui a atualização é `git pull`, e que `/team update` é para os projetos onde o time está **instalado**.

## 2. Versão instalada

Leia `version` de `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`.

## 3. Origem registrada

Leia `extraKnownMarketplaces.team.source` de `.claude/settings.json` do projeto. Informe se a origem é o repositório git ou um caminho local — `claude plugin marketplace update` sincroniza a partir **dela**; a consulta de versão abaixo usa o GitHub como referência canônica.

## 4. Versão corrente

Busque `https://raw.githubusercontent.com/wtlmarco/scrum-team-plugin/main/.claude-plugin/plugin.json` e leia `version`. Sem rede ou com a busca bloqueada: declare "não foi possível consultar a origem" e pare — não presuma que está atualizado (R7).

## 5. Compare (semver)

- instalada ≥ corrente → "já está na versão mais recente (`vX.Y.Z`)"; pare.
- instalada < v3.50 → veja §Versão mínima suportada, antes do passo 7; pare.
- instalada < corrente → busque `https://raw.githubusercontent.com/wtlmarco/scrum-team-plugin/main/CHANGELOG.md` e mostre as entradas entre as duas versões. Peça confirmação para aplicar — **exceto (v3.58.3)** quando as duas condições valem: o stakeholder **digitou** o `/team update` nesta sessão (o comando é o pedido) **e** todas as entradas entre as duas versões são correção da mesma linha (mesmo `MAJOR.MINOR`) com `**Processo:** nenhum`. Aí aplique direto (passo 7), diga em três linhas o que mudou e registre na §7 como resolvido. Qualquer entrada com processo, migração ou `MINOR` novo mantém a confirmação. No sprint 6 do projeto piloto, seis formulários de atualização (3.57.4 a 3.58.2) foram respondidos em segundos, sempre na opção recomendada.

## 6. Avalie o impacto de mudança de processo sobre os deliverables já escritos

Antes de aplicar, se o delta do `CHANGELOG.md` (passo 5) citar uma entrada nova do
changelog do processo (`process-changelog.md`, no formato `vX.Y` dentro da entrega),
abra essa entrada e leia "O que mudou": ela nomeia os documentos normativos alterados.
Cruze contra os deliverables já escritos neste projeto (`.team-project/**`, o SDD, ADRs,
os documentos de implementação):

- **Mudança de regra ou fluxo que este projeto já seguiu de outro jeito** (ex.: unidade
  de trabalho renomeada, portão novo, DoR/DoD reformulada) — avise o stakeholder, citando
  a entrada e o(s) deliverable(s) que podem estar em desacordo com a versão nova. Não
  corrija sozinho: a decisão é dele.
- **Mudança que não toca nada que este projeto já produziu** — diga isso em uma linha e
  siga.

Se o stakeholder decidir **não atualizar agora**, ou atualizar o plugin mas **manter o
time trabalhando pelas regras da versão antiga** por um tempo, registre a decisão em
`.team-project/README.md` §7 ("Decisões pendentes do stakeholder"), com: a versão em que
o time fica, o que motivou ficar, e o que dispara a revisão dessa decisão (prazo, marco,
ou "decisão permanente"). Sem esse registro, o próximo `/team update` — ou o próximo
papel que ler o changelog do processo — não tem como saber que o projeto está
deliberadamente atrás.

## 7. Aplique

Só após confirmação (ou na exceção do passo 5: correção da mesma linha, sem processo, pedida pelo próprio stakeholder), na raiz do projeto:

```powershell
claude plugin marketplace update team
claude plugin update team@team
```

## Versão mínima suportada: v3.50

Os passos de migração das versões v3.20 a v3.49 (antigas §7a a §7j) saíram na v3.65.0 (decisão do stakeholder, 19/11/2026). **Instalada abaixo de v3.50:** não aplique o update sobre ela — diga ao stakeholder que o projeto precisa de `/team init` de novo (o `.team-project/` existente é reconciliado pelo §8 depois) e pare. O texto antigo está no histórico do git do plugin.

## 7k. Medição configurada — seção `quality` e `verify.compile` (v3.52.2)

> Roda quando a versão instalada for anterior à `v3.52.2`, em qualquer projeto; o `/team init` também o executa (passo 4a). Nada a migrar em disco. As duas chaves **não se inferem** (cada projeto tem o comando dele), por isso o ritual **propõe** e o stakeholder decide.

1. **Seção `quality` no `.team-project/guards.json`:** se falta, **proponha** acrescentá-la, com os comandos que `.team-project/developer/context.md` e o `README.md` §ambiente já declaram — cada chave um comando (ou lista, para mais de uma unidade) que **sai ≠ 0 quando a regra quebra**: `coverage` (Q11, o gate de cobertura por módulo) com `coverageThreshold` (80) e, se a saída não traz o percentual no formato comum, `coveragePattern` (regex com o `%` no grupo 1) · `lint` e `format` (Q7) · `architecture` (Q1, o teste da regra de dependência entre anéis) · `metrics` (Q6, limites numéricos) · `duplication` (Q8) · `sourceRoots` (pastas de produção de Q9 e Q17; padrão: o `sourceRoots` do `guards.json` ou `src/`) · `timeoutMinutes` (padrão 9). Exemplo, para um projeto Node:
   ```json
   "quality": { "coverage": "npm run test:cov", "coverageThreshold": 80, "lint": "npm run lint", "format": "npx prettier --check .", "architecture": "npx depcruise src --config", "duplication": "npx jscpd src", "sourceRoots": ["src"] }
   ```
   Chave que o projeto não tem fica de fora (ou `""`). **Sem a seção, o `quality.ps1` mede só Q9 (TODO com ID) e Q17 (supressão justificada), por busca de padrão — 2 das 8 regras do portão do sprint; as outras seis ficam `não configurado` e passam ao julgamento do QA, sem medição.** Os comandos de `quality` entram também em `runCommands` (7f), se faltarem.
2. **`verify.compile` no `.team-project/guards.json`:** se `verify` existe (7h) e a chave falta, **proponha** acrescentá-la — o comando que **só compila** o projeto (sem rodar teste), sai ≠ 0 se não compila: `npx tsc --noEmit`, `dotnet build --no-restore`, `./gradlew compileDebugKotlin`… Exemplo: `"verify": { …, "compile": "npx tsc --noEmit" }`. **Sem ela, o `verify.ps1 -Mode mutation -Precheck` confere só que o trecho da mutação aparece uma vez no arquivo; que o mutante compila só se vê quando a mutação roda, e mutante que não compila volta `inconclusivo` — uma rodada de teste perdida por mutação.** Projeto sem `verify` (sem git, ou deixado vazio em 7h): nada a propor.
3. **Um formulário só** (`AskUserQuestion`, R22), junto com o de 7f/7h quando rodam juntos: mostre as chaves propostas, cada uma com o comando — *aplicar · ajustar · pedir mais contexto*. Sem resposta, não aplique: o portão segue com Q9/Q17 medidas e o `-Precheck` sem compilação; registre a pendência em `.team-project/README.md` §7.
4. **Diga ao stakeholder**, em duas linhas: com `quality`, o `operator` mede as regras do nível 1 antes do `/qa sprint <n>` e o QA lê números em vez de julgar de olho; com `verify.compile`, o `-Precheck` acusa antes do `full` a mutação que não compila. A forma de cada chave está no cabeçalho de `scripts/checks/quality.ps1` e de `scripts/checks/verify.ps1`; o modelo `${CLAUDE_PLUGIN_ROOT}/deliverables/team-project/guards.json` traz os exemplos.

**Verificação do passo:** `(Get-Content .team-project/guards.json -Raw | ConvertFrom-Json).quality` e `.verify.compile` devolvem os comandos aprovados; `powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/quality.ps1" -Id S0` mostra as regras configuradas como `ok`/`falhou` em vez de `não configurado` (apague `.team-project/quality/` depois).

## 7l. Padrão de ids de teste — auditoria e atributo (v3.55.0)

> Roda quando a versão instalada for anterior à `v3.55.0`, em qualquer projeto; o `/team init` também escolhe o atributo (passo 4a). A convenção está em `${CLAUDE_PLUGIN_ROOT}/standards/test-ids.md`. **O passo audita e propõe; nunca corrige** código, plano aprovado nem cenário `.scn`: a decisão é do stakeholder, e a correção passa pelo processo (Habilitadora).

1. **Rode** `powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/ids.ps1" -Map` e depois `… ids.ps1 -Audit`. O primeiro grava `.team-project/architect/ids-map.md` (o mapa de ids **gerado do código**, o que o Arquiteto cita nos planos); o segundo, só leitura, grava `.team-project/architect/ids-audit.md` com seis seções: atributo detectado pela stack × configurado · telas e controles sem id (o código todo) · ids fora da gramática · ids dos `.scn` que não existem no código · seletores por texto onde há id ("a conferir") · planos do sprint aberto que citam id fora do mapa. Sai sempre com exit 0.
2. **Resuma em até 6 linhas** (a linha de resumo do script e o que mais pesa: o atributo divergente, o total sem id, os `.scn` órfãos, os seletores por texto).
3. **Formulário 1 — o atributo** (`AskUserQuestion`, R22, "pedir mais contexto" por último), para `testIds.attribute` no `guards.json`: *aplicar o detectado · ajustar · pedir mais contexto*. Aplicado, grave a chave (`"testIds": { "attribute": "id" }`); sem resposta, não aplique e registre a pendência em `.team-project/README.md` §7. App híbrido (Capacitor/Cordova/Ionic) é `id`; Compose, `testTag`; web pura, `data-testid`.
4. **Formulário 2 — o retrofit** (`AskUserQuestion`, R22, "pedir mais contexto" por último): *abrir a Habilitadora "ids aderentes ao modelo" na próxima Planning, com a auditoria como insumo do Arquiteto · registrar pendência na §7 do README · adiar · pedir mais contexto*. Nada é renomeado ou criado agora.
5. **Não edite** código, plano aprovado nem `.scn`: se a auditoria aponta seletor por texto ou id órfão, o ritual só os lista.

**Verificação do passo:** `Test-Path .team-project/architect/ids-map.md` e `Test-Path .team-project/architect/ids-audit.md` devolvem `True`; `(Get-Content .team-project/guards.json -Raw | ConvertFrom-Json).testIds.attribute` devolve o atributo aprovado (ou o formulário 1 ficou sem resposta e a pendência está no README).

## 7m. A lição de cada GAP no lugar certo — conhecimento do projeto e stacks (v3.56.0)

> Roda quando a versão instalada for anterior à `v3.56.0`, em qualquer projeto; o `/team init` cria o `knowledge.md` com `**Classificação desde:** S1` e grava `stacks` (passo 4a). **O passo não dispara agente** e **não promove** decisão do sprint aberto — isso é do `/sm sprint close` dele (`knowledge.ps1 -Apply`). O que é código do plugin (a rota do GAP, o cartão com conhecimento e armadilhas, a frente H) passa a valer na hora, nas Tasks que faltam do sprint aberto.

1. **Rode** `powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/knowledge.ps1" -Migrate` (só leitura). Ele diz: se cria o `architect/knowledge.md` (com `**Classificação desde:**` = o sprint **seguinte** ao aberto — as decisões do sprint aberto, escritas antes da 3.56.0, só avisam), se cria a pasta local `.team-project/standards/stacks/`, as **stacks inferidas** quando o `guards.json` não tem `stacks`, cada `D-<k>` sem classificação do `architect/decisions/` e as K com `**Até:**` (remédio temporário de defeito do plugin).
2. **Formulário 1 — as stacks** (`AskUserQuestion`, R22, "pedir mais contexto" por último), para `"stacks"` no `guards.json`: *gravar as inferidas (<lista>) · ajustar · pedir mais contexto*. Aprovado, grave a chave (`"stacks": ["angular", "ionic-capacitor"]`); sem resposta, a inferência segue valendo e o SessionStart (G13) avisa.
3. **Formulário 2 — as decisões do sprint aberto sem classificação** (uma pergunta por `D-<k>`, até 4 por chamada): *projeto (padrão — vira K no close) · projeto até a correção no plugin (remédio: K com `**Até:**`) · nenhuma · pedir mais contexto*. A resposta vira `-Classify` no passo 4 (`D-<k>=<origem>:<lição>[@<até>]` — origem pela leitura da decisão: `processo` para remédio de defeito do plugin, `conhecimento` para fato do app). Sem resposta, a D fica como está e o close a promove como projeto.
   - **Projeto piloto S5 (a decisão do stakeholder de 06/11):** `D-1=conhecimento:projeto` (limiar relativo à caixa; a parte de stack já é `IONIC-P10`), `D-2=previsão:projeto` (injetar o caminho do artefato; com a H3 deixa de ser remendo), `D-3=processo:plugin@a mutação rodar node:test`.
4. **Aplique:** `… knowledge.ps1 -Migrate -Apply -Classify "<o do formulário 2>"` — cria o `knowledge.md` e a pasta local e grava **Origem** e **Lição** nas D escolhidas. K com `**Até:**` cuja correção esta versão traz: confirme no formulário e acrescente `-Retire K-<n>`.
5. **A semente** — as lições de projeto da classificação dos GAPs (no projeto piloto, as 25 de `melhorias/gaps-projeto piloto-s1-s5.md`) — **não** se escreve aqui: vai como primeiro item do próximo `/sm sprint prepare`, numa instância do Arquiteto que lê só os trechos citados. Registre a pendência em `.team-project/scrum-master/context.md` §"Candidatas do próximo sprint" ("consolidação: semear o knowledge.md").
6. O passo 8 reconcilia o `README.md` do `.team-project` e as linhas novas do manifesto (`architect/knowledge.md`, `standards/stacks/`).

**Verificação do passo:** `Test-Path .team-project/architect/knowledge.md` e `Test-Path .team-project/standards/stacks` devolvem `True`; `Select-String -Path .team-project/architect/knowledge.md -Pattern 'Classificação desde'` mostra o sprint seguinte ao aberto; `(Get-Content .team-project/guards.json -Raw | ConvertFrom-Json).stacks` devolve a lista aprovada (ou o formulário 1 ficou sem resposta e o G13 avisa).

## 7n. Sprint 0 — só por escolha, em projeto em andamento (v3.61.0)

> Roda quando a versão instalada for anterior à `v3.61.0`. **O passo não grava nada.** O sprint 0 (R35 · `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/workflow-sprint0.md`) vale para o projeto que faz o onboarding a partir desta versão; projeto em andamento **não ganha** a linha `Sprint 0 (fundação)` no `README.md` §2 — e, sem ela, a G25 e o C2 R35 ficam calados.

1. **Rode** `powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/foundation.ps1" assess` (só leitura) e resuma em até 4 linhas: quantos documentos do SDD estão ausentes ou fora do padrão e se o ambiente de testes passa.
2. **Diga ao stakeholder em uma linha** que adotar o sprint 0 é escolha dele: `/sm sprint0 plan` grava a linha como **exigido** e, a partir daí, o próximo `/sm sprint prepare` espera o aceite do sprint 0 — o sprint aberto segue até o fim. **Não pergunte agora** nem acrescente a linha: a decisão vem quando ele chamar o comando.

**Verificação do passo:** `Select-String -Path .team-project/README.md -Pattern 'Sprint 0 \(fundação\)'` não devolve nada (a menos que o projeto já a tivesse).

## 7o. App híbrido — o id pelo CDP (v3.62.0)

> Roda quando a versão instalada for anterior à `v3.62.0` **e** o projeto tem alvo `android` com app híbrido (WebView: Capacitor, Cordova, Ionic). A pista é `testIds.attribute = "id"` com `targets.android` no `guards.json`, ou a stack em `stacks`. Projeto nativo ou só web: pule, dizendo isso em uma linha. O `guards.json` é do stakeholder: **o passo propõe; nunca grava sem o formulário.**

1. **Leia** `targets.android` do `guards.json` e o guia da stack (`${CLAUDE_PLUGIN_ROOT}/standards/stacks/<stack>/guide.md`), que traz os valores recomendados de `targets.android.cdp`.
2. **Formulário** (`AskUserQuestion`, R22, "pedir mais contexto" por último). Opções: *declarar `"locator": "cdp"` com os valores do guia da stack · manter o `uiautomator` · pedir mais contexto*. Explique o que muda:
   - com o `uiautomator`, o `accept` de um app híbrido para antes do 1º cenário em **CONFIGURAÇÃO DO ALVO**;
   - com o `cdp`, o APK de debug precisa da depuração da WebView ligada (no Capacitor, `android.webContentsDebuggingEnabled: true`) e o Node tem de ser da versão 22 ou mais nova.
3. **Aprovado:** grave `"locator": "cdp"` e o bloco `"cdp"` (`pageUrl`, `readyExpr`, `failExpr`, `hiddenScopes`) em `targets.android`, com os valores que o stakeholder confirmou. Se o build de debug não liga a depuração da WebView, registre em `.team-project/README.md` §7 a Task do projeto que a liga. O passo não edita código.
4. **Avise em uma linha:** a política `run.deviceProofFallback`, se houver, não cobre a CONFIGURAÇÃO DO ALVO; e decisões antigas do Arquiteto sobre "prova por outro executor" deixam de ser necessárias para as Tasks novas.

**Verificação do passo:** `(Get-Content .team-project/guards.json -Raw | ConvertFrom-Json).targets.android.locator` devolve `cdp` (aprovado) ou nada (mantido, com a escolha dita ao stakeholder).

## 8. Reconcilie o `.team-project/` com os modelos novos

Atualizar o plugin atualiza `${CLAUDE_PLUGIN_ROOT}` — e **só isso**. Tudo que o `/team init` instanciou a partir de um modelo (`.team-project/how-to.md`, o quadro, o Product Backlog, o registro de evidências, o `README.md`) continua como estava no dia da instalação, e **deriva em silêncio a cada versão nova**. Este passo fecha esse buraco.

O manifesto do que foi instanciado, com a classe de reconciliação de cada arquivo, está em `${CLAUDE_PLUGIN_ROOT}/deliverables/team-project/README.md`. Para cada linha marcada como reconciliável:

1. **Compare** o arquivo no projeto com o modelo da versão nova.
2. **Classifique** a diferença conforme o manifesto:
   - **cópia literal** (`how-to.md`) → substitua, avisando em uma linha o que mudou;
   - **estrutura + conteúdo local** (`sprints/<corrente>/sprint-backlog.md`, `product-backlog.md`, `baseline.md`, §8 do `README.md`) → **mostre o delta da estrutura** — seção nova, coluna nova, cabeçalho renomeado — e **peça aprovação por arquivo**. Nunca sobrescreva conteúdo escrito pelo time;
   - **histórico imutável** (tudo em `sprints/<n>/` de sprint já fechado) → **não reconcilie**. O registro retrata o sprint como ele foi; estrutura nova não se aplica retroativamente (passo 7a);
   - **só conteúdo local** (os seis `context.md`) → não toque; liste como "conferir manualmente" se o modelo mudou de forma relevante.
3. **Apresente um resumo antes de aplicar qualquer coisa:** arquivo · classe · o que muda · o que se perde se aplicar. Sem confirmação, não aplique.
4. **Conflito** — o time editou a mesma seção que o modelo mudou — não se resolve sozinho: mostre os dois lados e deixe o stakeholder escolher, ou registre como pendência no quadro.

> **Regra que não se negocia:** o `update` **nunca apaga conteúdo do projeto** sem aprovação explícita. Na dúvida, proponha e registre — não aplique.

Se nada mudou nos modelos entre as duas versões, diga isso em uma linha e siga.

## 9. Feche

Diga que a nova versão **só entra em vigor após reiniciar a sessão**, e que depois `claude plugin details team@team` deve mostrar a versão nova. Resuma em uma linha o que mudou (do CHANGELOG) e liste, se houve, o que foi reconciliado no `.team-project/` e o que ficou pendente de decisão.

**O update não retoma o run (v3.60.1).** Com `.team-project/.active-run`, termine com uma linha só, sem formulário: "o sprint segue pausado onde estava; feche esta conversa (ou `/clear`) e digite `/sm sprint run` — a sessão nova já roda a versão nova". Nunca pergunte "retomar agora?" e nunca rode o `run.ps1 next` nesta sessão: ela ainda carrega a versão anterior até reiniciar. No projeto piloto (15/11), a sessão do update perguntou "Retomar agora o sprint 6?" e retomou na versão velha.
