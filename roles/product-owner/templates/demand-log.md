# Template — Índice dos pedidos do stakeholder (`.team-project/product-owner/demand-log.md`)

Criado pelo `/team init` (e pelo `/team update`, item 7s) e mantido pelo PO no `/po analyze` (v3.67.0). **Dono:** PO.

```markdown
# Pedidos do stakeholder — índice do `/po analyze`

> **DOCUMENTO VIVO** · **Dono:** PO · Uma linha por pedido tratado. **Só ponteiros:** o conteúdo vive no destino (análise, ficha da Correção, registro da QA, História). Negado e dúvida de uso vivem só aqui.

| A-ID | Data | Pedido (uma frase) | Classificação | Destino | Estado |
|---|---|---|---|---|---|
```

## Exemplo

```markdown
| A-007 | 2026-11-27 | exportar o relatório em PDF | evolução | [análise](analysis/A-007-exportar-pdf.md) · H-031, H-032 | em backlog |
| A-008 | 2026-11-27 | tela trava ao salvar duas vezes | defeito | [F-012](../fixes/F-012.md) | trilha fix |
| A-009 | 2026-11-27 | onde vejo o histórico? | dúvida de uso | respondido: menu Conta → Histórico | fechado |
| A-010 | 2026-11-27 | login por rede social | negado | sem base legal para o dado agora; alternativa: e-mail sem senha | fechado |
```

## Regras

- **A-ID** segue a sequência deste arquivo; nunca se reaproveita número. Um item do `note.md` com dois pedidos vira **duas linhas**.
- **Classificação:** evolução · capacidade nova · defeito · ajuste · mudança em História do sprint · dúvida de uso · negado (`roles/product-owner/README.md` §`/po analyze`).
- **Destino:** o link do que a classificação mandou — a análise e as Histórias, a ficha `F-<nnn>`, o ID do `pending.md`, a análise de impacto, ou a resposta em uma frase.
- **Estado:** `em backlog` · `em sprint <n>` · `entregue` (História aceita na Review) · `trilha fix` · `aguardando QA` · `fora da primeira fatia` (o que o brief do brainstorm deixou para depois) · `fechado`. O PO atualiza **no mesmo ciclo** em que o destino muda (R12).
- **Pedido repetido:** o analyze procura aqui antes de dar A-ID novo; o pedido já negado é citado na nova linha, com a decisão de novo e o motivo.
- O índice **não copia** conteúdo do destino — mesma regra de dono único do `fixes.md`.
