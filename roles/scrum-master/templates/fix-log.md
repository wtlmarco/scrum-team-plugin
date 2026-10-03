# Template — Índice das Correções (`.team-project/fixes.md`, trilha fix · R33)

> **Dono:** SM · **Escritor:** a sessão que orquestra o `/sm fix plan`, o `/sm fix run` e a triagem (mesmo precedente do `consumption.md`: dono SM, escritor a sessão) · **Não semeado:** nasce na primeira Correção · Roteiro: [`../process/fix-run.md`](../process/fix-run.md) · Regra: R33

```markdown
# Correções — trilha fix (R33)
> DOCUMENTO VIVO, sem rotação · Dono: SM · Escritor: a sessão que orquestra o /sm fix plan, o /sm fix run e a triagem

## Correções
| F-ID | Data | Tipo | Relato (1 linha) | C1–C4 (PO) | Reproduzido (QA) | C5–C8 (Arq) | Bloco | Estado | Veredito | Promovida para | Reaberta em |
|---|---|---|---|---|---|---|---|---|---|---|---|

## Blocos
| B-ID | Planejado | Executado | Fechado | Correções | Fechadas · promovidas · devolvidas | Σ tokens (derivado de consumption.md) | Durante sprint |
|---|---|---|---|---|---|---|---|
```

## Regras

- **Estados da Correção:** `triada` (reproduzida, se defeito; C1–C4 do PO conferidos; fora de bloco) · `em bloco` (planejada em `B-<nnn>`) · `fechada` (veredito ✅ do QA **na linha dela**; encerra — não passa pela Sprint Review, R33) · `promovida` (um critério C1–C8 caiu: vira item do Product Backlog ou Task da História em voo, **com o motivo**; coluna "Promovida para" preenchida) · `devolvida` (volta à fila como `triada`, sem custo — por exemplo, área distante do bloco ou teto atingido) · `reaberta` (item novo do `note.md` citou a F-ID; coluna "Reaberta em" com a data; a triagem a trata como defeito e a Correção volta a `triada`).
- **Motivo da devolução:** a coluna "Promovida para" **mantém o nome** (o C4 a lê por nome, só quando Estado = `promovida`). F-ID `devolvida` guarda o motivo na **mesma célula**, no formato `devolvida — <motivo em uma linha>` (ex.: `devolvida — área distante do bloco`); a linha da F-ID não fica sem motivo. Promovida: `<item do Product Backlog | Task>` e o critério que caiu na ficha (`## Destino`).
- **Colunas "C1–C4 (PO)", "Reproduzido (QA)" e "C5–C8 (Arq)":** `✔`/`✘` (ou `n/a` — ajuste não é reproduzido) com a data; a evidência vive na ficha ([`fix-card.md`](../../product-owner/templates/fix-card.md)) e no `plan.md` do bloco, não aqui.
- **Coluna "Durante sprint":** o `<n>` do sprint aberto quando o `fix run` rodou, ou `—`. É o que a retrospectiva lê ("Trilha fix no período").
- **"Σ tokens":** **derivado** somando `fixes/B-<nnn>/consumption.md` na hora da leitura — nunca digitado.
- **Escrita:** a sessão atualiza a linha na hora de cada transição de estado, **depois** da saída do C4 (`fix.ps1`) no fechamento do bloco: C4 com exit 1 lista as F-IDs que **não fecham**; as outras fecham (D6). Bloco **fechado** (linha `## Fechamento` do `verdict.md`) nunca recebe linha nova de consumo.
- **Reabertura não é novo escape:** não gera nova entrada de defeito no `pending.md` nem conta de novo no indicador "defeito que escapou".
