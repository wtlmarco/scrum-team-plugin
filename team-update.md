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

## 7. Feche

Diga que a nova versão **só entra em vigor após reiniciar a sessão**, e que depois `claude plugin details team@team` deve mostrar a versão nova. Resuma em uma linha o que mudou (do CHANGELOG).
