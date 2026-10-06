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
- instalada < corrente → busque `https://raw.githubusercontent.com/wtlmarco/scrum-team-plugin/main/CHANGELOG.md` e mostre as entradas entre as duas versões. Peça confirmação para aplicar.

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

Só após confirmação, na raiz do projeto:

```powershell
claude plugin marketplace update team
claude plugin update team@team
```

## 7a. Migração estrutural da v3.20 — o registro de execução passa a ser por sprint

> Passo **único desta versão**. Roda depois de aplicar (passo 7) e **antes** da reconciliação de modelos (passo 8), e só quando a versão instalada for anterior à `v3.20.0`.

A v3.20 **move artefatos que o projeto já tem em disco**. Projeto que atualiza sem migrar fica com o time procurando arquivos onde eles não estão mais.

**O que move, de onde para onde:**

| De | Para | Dono |
|---|---|---|
| `.team-project/scrum-master/sprints/<n>/` | `.team-project/sprints/<n>/` | SM |
| `.team-project/scrum-master/sprint-backlog.md` | `.team-project/sprints/<corrente>/sprint-backlog.md` | SM |
| `.team-project/scrum-master/consumption-log.md` | `.team-project/sprints/<corrente>/consumption.md` | SM |
| `consumption-log-archive.md`, seções `## Sprint <n>` | `.team-project/sprints/<n>/consumption.md`, uma por sprint | SM |
| `.team-project/architect/plans/<T-ID>-*.md` | `.team-project/sprints/<n>/plan/` — o sprint em que a Task foi executada | Arquiteto |
| Histórias detalhadas, por sprint | `.team-project/sprints/<n>/stories/H-nnn.md` (cópia congelada; o Product Backlog **continua** a fonte viva) | PO |
| `.team-project/quality-assurance/evidence.md` | fatiado em `.team-project/sprints/<n>/evidence/<T-ID>.md` | QA |
| a parte de linha de base de `evidence.md` | `.team-project/quality-assurance/baseline.md` — **fora** da pasta do sprint | QA |

**O que NÃO move, e por quê:** `pending.md` (registro de GAPs), `03-code-map.md`, o Product Backlog, o SDD, as ADRs e o protótipo funcional do ① — todos somam ou evoluem através dos sprints, e fatiá-los quebraria a leitura que o time faz deles.

**Sprints já fechados — migra o caminho, preserva o conteúdo.** São registros imutáveis: mova o diretório **sem uma vírgula alterada** dentro dos arquivos, e **não** reconcilie a estrutura deles contra os modelos novos — o `review.md` de um sprint antigo não ganha a seção de bloqueios por degrau, porque aquele sprint não os teve. Reescrever destruiria o histórico que eles existem para provar. Sprint fechado que tem `sprint-backlog-snapshot.md`: renomeie para `sprint-backlog.md` — o snapshot **era** o backlog fechado.

**Sprint em andamento — conclui no formato antigo.** Mover o chão sob um sprint vivo quebra os ponteiros que o time está usando naquele instante: o dev tem o caminho do plano, o QA tem o caminho da evidência. **Regra:** o sprint corrente termina onde começou; a migração dele acontece no `/sm sprint close`, junto com o fechamento da pasta. O primeiro sprint a nascer no formato novo é o seguinte.

**O que o `update` PROPÕE em vez de aplicar** — contém conteúdo local, e a regra de nunca apagar sem aprovação vale igual:

- o **fatiamento de `evidence.md`** por Task, e a separação da linha de base — a divisão depende de como o projeto escreveu o arquivo;
- a **atribuição de cada plano** de `architect/plans/` ao sprint certo — exige cruzar Task × sprint;
- a **criação de `sprints/<n>/stories/`** a partir do Product Backlog — o congelamento retroativo é uma decisão, não uma cópia mecânica.

Para os três, apresente o mapeamento proposto, arquivo por arquivo, e espere aprovação.

**Depois de migrar, obrigatoriamente:** declare a linha **"Sprint corrente"** em `.team-project/README.md` §2, com o número e o caminho do `sprint-backlog.md`. Com o quadro dentro da pasta numerada, essa linha é o **único índice** — sem ela, nenhum papel acha o quadro vivo.

**Verificação do passo:** nenhuma ocorrência de `scrum-master/sprints`, `architect/plans`, `quality-assurance/evidence.md` ou `consumption-log` sobra em `.team-project/` fora de sprints fechados; e `.team-project/README.md` §2 aponta um `sprint-backlog.md` que existe.

## 7b. Migração da v3.35 — o processo sai do git e o consumo fora de sprint ganha registro próprio

> Roda depois de aplicar (passo 7), antes da reconciliação (passo 8), e só quando a versão instalada for anterior à `v3.35.0`. A v3.35 (R31) tira o **`.team-project/` inteiro** do git do projeto: o repositório passa a receber só o produto (código e `docs/`), e o estado da gestão fica **local**.
>
> **Os passos 1 a 4 só valem em repositório git — projeto que não é repositório git: pule-os e vá ao 5.** **Cada passo destrutivo (2, 3 e o push do 3) exige confirmação explícita do stakeholder NO MOMENTO da execução, neste projeto.** Aprovação antecipada, genérica ou "de quando rodar o update" não vale: **uma pergunta por passo destrutivo**, em `AskUserQuestion` pela sessão (R22: opções descritas, recomendação, "pedir mais contexto" por último), mostrando o comando e o efeito; execute só depois do "sim" e então passe ao próximo. Sem o "sim", registre o passo como pendente e siga.

1. **`.gitignore` (a).** Se o `.gitignore` da raiz não tem a linha `.team-project/`, **acrescente-a** — só acrescente, nunca reescreva o arquivo.
2. **Desrastrear (b).** Se `git ls-files .team-project` não está vazio: **confirme**, rode `git rm -r --cached .team-project` (tira do índice e **mantém os arquivos locais**) e faça o commit (por exemplo, `chore: tira .team-project do git (R31)`). **A guarda G1 bloqueia esse commit** — ela nega todo commit com arquivo de `.team-project/` no stage, inclusive remoção: antes do commit, acrescente `"G1"` a `disabled` em `.team-project/guards.json` (crie-o a partir do modelo se não existir — passo 7c); depois do commit, **tire `"G1"` de `disabled`** e confira. Conferida a saída, siga.
3. **Limpar o histórico (c).** Só se `git log --all -- .team-project` não está vazio. **Confirme o passo inteiro antes de começar** e, de novo, **antes do push**.
   1. **Backup obrigatório, antes de qualquer coisa:** (i) copie a pasta `.team-project/` local para fora do repositório; (ii) faça o clone espelho `git clone --mirror <origem> <destino>.git`. Confira que os dois existem; sem eles, **não prossiga**.
   2. **Meça:** `git count-objects -vH` (antes).
   3. **Ferramenta:** `git filter-repo --path .team-project --invert-paths`, num clone novo do repositório (o `filter-repo` recusa clone com trabalho em andamento; só use `--force` depois do backup). Se `git filter-repo --version` falhar, **diga como instalar** — `python -m pip install git-filter-repo` (ou `pipx install git-filter-repo`) — ou ofereça a alternativa: BFG Repo-Cleaner (`bfg --delete-folders .team-project`, exige Java). `git filter-branch` não é recomendado (lento, frágil). O `filter-repo` remove o remote `origin`: reponha-o.
   4. **Push (confirmação própria):** `git push --force --all` e `git push --force --tags`. Avise antes: **quem colaborou precisa re-clonar ou rebasear**; o **GitHub pode manter objetos em cache e em PRs antigas** (`refs/pull/*`) e forks, e a remoção completa pode exigir o suporte do GitHub.
4. **Verificação (d).** `git log --all -- .team-project` vazio; `git ls-files .team-project` vazio; `git check-ignore -v .team-project/README.md` devolve a regra; `git count-objects -vH` (depois) comparado com o (antes) do passo 3.2. Registre os números no resumo do passo 9.
5. **`.team-project/consumption.md`** (qualquer projeto): se não existir, crie a partir de `roles/scrum-master/templates/consumption.md` (cabeçalho "Consumo — fora de sprint", tabela vazia, sem "Totais do sprint").
6. **Subseção antiga** (qualquer projeto): se `.team-project/scrum-master/context.md` tem "Consumo pré-sprint (prepare · sdd)" com linhas, **proponha** movê-las (conteúdo e Nota `pre-sprint;` preservados) para o arquivo novo e remover a subseção; espere aprovação — é conteúdo local.

**Verificação do passo:** os itens do passo 4 (repositório git), mais `.team-project/consumption.md` existente e `context.md` sem a subseção antiga.

## 7c. Guardas da v3.39 — `guards.json`

> Roda quando a versão instalada for anterior à `v3.39.0`, em qualquer projeto.

1. **`.team-project/guards.json`:** se não existir, crie a partir de `${CLAUDE_PLUGIN_ROOT}/deliverables/team-project/guards.json`. Se existir, é **estrutura + conteúdo local**: chave nova do modelo entra; `disabled` e os valores do projeto nunca são sobrescritos (passo 8).
2. **Diga ao stakeholder**, em três linhas: as guardas (G1 commit com `.team-project/`, G2 escrita na cópia instalada, G3 formulário sem "Pedir mais contexto" por último, G4 aviso de saída grande) **só valem depois de reiniciar a sessão**; uma guarda com falso positivo é desligada em `disabled`, na hora; cada disparo custa de 0,6 a 0,8 s (`hooks/COVERAGE.md`).
3. **Sonda da fase 2 (opcional, uma sessão):** com `"probe": true`, o `guards.log` registra o `agent_type` recebido e o tempo de cada disparo; rode um `/po status` e um `/dev` de calibração e leve o log ao `/review`. Depois, `"probe": false`.

**Verificação do passo:** `.team-project/guards.json` existe e é JSON válido (`Get-Content .team-project/guards.json -Raw | ConvertFrom-Json`); depois de reiniciar, `/hooks` lista `SessionStart`, `PreToolUse` e `PostToolUse` do plugin, e a sessão abre com a linha "Guardas do time: ativas …".

## 7d. Contato remoto da v3.41 — campos da §1 e protótipo num arquivo só

> Roda quando a versão instalada for anterior à `v3.41.0`, em qualquer projeto.

1. **`.team-project/README.md` §1:** se faltarem, acrescente as três linhas **vazias** — `**Identificador remoto:**`, `**Conta remota:**`, `**Verificação remota:**`. **Nunca invente o identificador**: ele é escolhido pelo stakeholder no `/team remote`. Com o campo vazio, nada muda no projeto (a guarda G3 só exige o prefixo `[<ID> · …]` quando há identificador).
2. **Diga ao stakeholder**, em duas linhas: para responder pelo celular, rode `/team remote` uma vez neste projeto; sem ele, tudo segue como antes, no terminal.
3. **Protótipo funcional e do sprint num `index.html` único** (para publicar como artifact privado): se `.team-project/user-experience/prototype/` tiver `flows/` ou `assets/`, **não mexa** — avise que o UX consolida num arquivo só no próximo ciclo do protótipo (`/ux prototype`). Não é decisão do stakeholder: não vai para a §7.

**Verificação do passo:** `Select-String -Path .team-project/README.md -Pattern '^\*\*Identificador remoto:\*\*'` devolve uma linha.

## 7e. Guardas por papel da v3.42 — chaves novas do `guards.json`

> Roda quando a versão instalada for anterior à `v3.42.0`, em qualquer projeto.

1. **`.team-project/guards.json`:** acrescente as chaves que faltarem com o valor do modelo (`${CLAUDE_PLUGIN_ROOT}/deliverables/team-project/guards.json`) — `protectedPaths`, `sourceRoots`, `testSkipPatterns`. **Nunca sobrescreva** `disabled` nem valor já escolhido pelo projeto (passo 8).
2. **Pergunte ao stakeholder** (`AskUserQuestion`, R22) **só se** o código-fonte do projeto não é "tudo fora de `.team-project/` e `docs/`" (por exemplo, `docs/` com código, ou documentação de produto em outra pasta): ofereça preencher `sourceRoots` com os globs do código. Caso comum: nada a perguntar.
3. **Diga ao stakeholder**, em três linhas: as guardas por papel (G5 gate, G6 teste ignorado, G7 `Agent` só ao `operator`, G8 dono do arquivo, G9 escopo do dev, G11 pasta do job) **só valem depois de reiniciar a sessão** e não se aplicam à sessão principal dele; a G8 **nega** código ao Arquiteto fora de spike declarado em `.active-spike` (v3.44 — até a v3.43 ela perguntava); o `/dev` à mão passa a gravar `.team-project/.active-task` antes de disparar o dev (`hooks/COVERAGE.md`).

**Verificação do passo:** `(Get-Content .team-project/guards.json -Raw | ConvertFrom-Json).protectedPaths` devolve a lista; depois de reiniciar, a linha "Guardas do time: ativas …" lista G5–G9 e G11.

## 7f. Run sem trava da v3.44 — `runCommands`

> Roda quando a versão instalada for anterior à `v3.44.0`, em qualquer projeto; o `/team init` também o executa (passo 4a).

1. **`runCommands` no `.team-project/guards.json`:** se a chave falta, acrescente-a com os **prefixos** dos comandos de build, teste, lint e cobertura que `.team-project/developer/context.md` (e o `README.md` §ambiente) declaram — como estão escritos, sem argumento de arquivo: `dotnet build`, `dotnet test`, `npm run lint`, `npx ng test`… Se a chave já existe, só acrescente o que faltar; nunca remova valor do projeto. **Nada de instalação, rede, push ou comando destrutivo** (`npm install`, `git push`, `rm`): esses não entram no run (a G14 os nega, e a falta vira bloqueio da Task). **A lista vive só aqui:** o plugin não escreve permissão nas configurações do Claude Code (`.claude/settings*.json`) — dentro do run quem libera é a G14, lendo esta chave; fora do run vale o pedido de permissão normal, com o stakeholder presente.
2. **Um formulário só** (`AskUserQuestion`, R22): mostre os prefixos propostos para `runCommands` — *aplicar · ajustar a lista · pedir mais contexto*. Sem resposta, não aplique: o run segue funcionando, mas comando do projeto fica com o pedido de permissão do harness.
3. **Diga ao stakeholder**, em três linhas: o `sprint run` e o `fix run` gravam `.team-project/.active-run` e, com ele, a **G14** libera o operacional dos papéis e nega com a rota o que está fora da lista — **nenhum pedido de permissão parado no meio da fila**; a **G8** passa a **negar** código ao Arquiteto fora de spike declarado (`.active-spike`); a **G15** grava no `guards.log` todo pedido de permissão do harness (`hooks/COVERAGE.md`). Valem depois de reiniciar a sessão.

**Verificação do passo:** `(Get-Content .team-project/guards.json -Raw | ConvertFrom-Json).runCommands` devolve a lista; depois de reiniciar, `/hooks` lista `Notification` e a linha "Guardas do time" traz G14 e G15.

## 7g. Consumo medido da v3.45 — `usage.jsonl` e o `consumption.ps1`

> Roda quando a versão instalada for anterior à `v3.45.0`, em qualquer projeto. Nada a migrar em disco: o `usage.jsonl` nasce na primeira parada de subagente depois de reiniciar.

1. **Não reescreva as linhas antigas** do `consumption.md` aberto: elas trazem o número da notificação (contexto final), e o script as mantém; os Totais passam a somá-las só na coluna "Σ notificação" ([`templates/consumption.md`](../roles/scrum-master/templates/consumption.md)). Se o `## Totais` do registro aberto tem o cabeçalho antigo (5 colunas), deixe — o script o reescreve no formato novo na primeira execução.
2. **Diga ao stakeholder**, em três linhas: o hook **G16** mede cada subagente no transcript dele e grava em `.team-project/usage.jsonl`; a sessão **não transcreve mais número** — roda `scripts/checks/consumption.ps1`, que escreve as linhas e os Totais; a coluna Tokens passa a ser o **processado** (o número da notificação, que era o anotado até aqui, é só o contexto final — de 5 a 6 vezes menor, medido). O C1 passa a contar os jobs do `operator` **por Task** (`operator/<n>/<T-ID>…/`). Vale depois de reiniciar a sessão.

**Verificação do passo:** depois de reiniciar, `/hooks` lista `SubagentStop` e a linha "Guardas do time" traz G16; depois do primeiro subagente, `Get-Content .team-project/usage.jsonl -Tail 1` mostra a rodada.

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
