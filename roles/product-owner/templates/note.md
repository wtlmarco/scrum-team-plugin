# Relatos do stakeholder — fila do `/po note`

> **DOCUMENTO VIVO** · **Dono:** stakeholder — é ele quem escreve, ao longo do uso · **Tratado por:** PO, via `/po note` ou `/po bug <relato>`
> Vive em `.team-project/note.md`, **deste projeto**. **Não confundir** com o `note.md` da raiz do repositório-fonte do plugin: aquele é a fila do `/review`, que evolui o processo do time, tratada pelo Agent `scrum-master`. Este é a fila de relatos de uso deste produto — mesmo nome, dois arquivos, dois donos (`artifact-ownership.md` §1b).

## O que escrever aqui

Escreva cada item como **relato bruto** — o que você observou usando o produto, não o requisito, não a Task, não a classificação.

```
❌ "Corrigir o timeout da tela de X."          → já é solução
❌ "Bug: endpoint de Y retorna 500."           → já é diagnóstico técnico
✅ "Depois de salvar duas vezes seguidas em X, a tela trava."   → sintoma
```

Quem decide se é **defeito**, **mudança de escopo** ou **dúvida de uso** é o PO, em `/po note` — não escreva a classificação aqui.

## Abertas

- <relato, uma linha ou um parágrafo curto, por item>

## Como este arquivo é fechado

`/po note` lê esta seção item a item e aplica a classificação (defeito · mudança de escopo disfarçada de bug · dúvida de uso). **Item tratado sai desta lista** — não fica arquivado aqui — e passa a viver só no destino que a classificação mandou:

| Classificação | Destino |
|---|---|
| Defeito | Registro de GAPs da QA (`pending.md`), com o campo `origem: stakeholder` |
| Mudança de escopo disfarçada de bug | Product Backlog (`.team-project/product-owner/product-backlog.md`) |
| Dúvida de uso | A resposta dada ao stakeholder, e — se for o caso — melhoria de UX ou de documentação |

Item que só a QA consegue classificar depois de investigar **permanece na fila**, marcado como "aguardando investigação da QA" — não é removido antes da hora.

Este arquivo **não** guarda histórico de itens tratados — duplicar o registro aqui e no destino é a mesma divergência que `pending.md` existe para evitar (dono único, R12). O histórico vive no destino.
