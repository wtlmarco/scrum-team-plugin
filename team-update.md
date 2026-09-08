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

## 6. Aplique

Só após confirmação, na raiz do projeto:

```powershell
claude plugin marketplace update team
claude plugin update team@team
```

## 7. Reconcilie o `.team-project/` com os modelos novos

Atualizar o plugin atualiza `${CLAUDE_PLUGIN_ROOT}` — e **só isso**. Tudo que o `/team init` instanciou a partir de um modelo (`.team-project/how-to.md`, o quadro, o Product Backlog, o registro de evidências, o `README.md`) continua como estava no dia da instalação, e **deriva em silêncio a cada versão nova**. Este passo fecha esse buraco.

O manifesto do que foi instanciado, com a classe de reconciliação de cada arquivo, está em `${CLAUDE_PLUGIN_ROOT}/deliverables/team-project/README.md`. Para cada linha marcada como reconciliável:

1. **Compare** o arquivo no projeto com o modelo da versão nova.
2. **Classifique** a diferença conforme o manifesto:
   - **cópia literal** (`how-to.md`) → substitua, avisando em uma linha o que mudou;
   - **estrutura + conteúdo local** (`work-board.md`, `product-backlog.md`, `evidence.md`, §8 do `README.md`) → **mostre o delta da estrutura** — seção nova, coluna nova, cabeçalho renomeado — e **peça aprovação por arquivo**. Nunca sobrescreva conteúdo escrito pelo time;
   - **só conteúdo local** (os seis `context.md`) → não toque; liste como "conferir manualmente" se o modelo mudou de forma relevante.
3. **Apresente um resumo antes de aplicar qualquer coisa:** arquivo · classe · o que muda · o que se perde se aplicar. Sem confirmação, não aplique.
4. **Conflito** — o time editou a mesma seção que o modelo mudou — não se resolve sozinho: mostre os dois lados e deixe o stakeholder escolher, ou registre como pendência no quadro.

> **Regra que não se negocia:** o `update` **nunca apaga conteúdo do projeto** sem aprovação explícita. Na dúvida, proponha e registre — não aplique.

Se nada mudou nos modelos entre as duas versões, diga isso em uma linha e siga.

## 8. Feche

Diga que a nova versão **só entra em vigor após reiniciar a sessão**, e que depois `claude plugin details team@team` deve mostrar a versão nova. Resuma em uma linha o que mudou (do CHANGELOG) e liste, se houve, o que foi reconciliado no `.team-project/` e o que ficou pendente de decisão.
