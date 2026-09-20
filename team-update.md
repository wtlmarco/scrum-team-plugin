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
