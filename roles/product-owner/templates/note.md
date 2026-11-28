# Relatos do stakeholder — fila do `/po analyze`

> **DOCUMENTO VIVO** · **Dono:** stakeholder — é ele quem escreve, ao longo do uso · **Tratado por:** PO, via `/po analyze` (sem texto: a fila inteira)
> Vive em `.team-project/note.md`, **deste projeto**. **Não confundir** com o `note.md` da raiz do repositório-fonte do plugin: aquele é a fila do `/review`, que evolui o processo do time, tratada pelo Agent `scrum-master`. Este é a fila do que você pede sobre este produto — mesmo nome, dois arquivos, dois donos (`artifact-ownership.md` §1b).

## O que escrever aqui

Escreva cada item como **relato bruto** — o que você observou usando o produto, ou o que você gostaria que ele fizesse. Não escreva o requisito, a Task nem a classificação.

```
❌ "Corrigir o timeout da tela de X."          → já é solução
❌ "Bug: endpoint de Y retorna 500."           → já é diagnóstico técnico
✅ "Depois de salvar duas vezes seguidas em X, a tela trava."   → sintoma
✅ "Queria exportar o relatório de X para mandar ao contador."  → pedido, com o motivo
```

Quem decide se é **evolução**, **capacidade nova**, **defeito**, **ajuste**, **dúvida de uso** ou se não será feito é o PO, em `/po analyze` (ou na triagem do `/sm fix plan`) — não escreva a classificação aqui.

**Voltou um problema já corrigido?** Cite a correção no item (`F-<nnn>`): a triagem a marca **reaberta** — é assim que se reabre uma Correção, que não passa pela Sprint Review.

**História do aceite (opcional):** se você sabe em que funcionalidade/História aceita isso aparece, anote no fim do item — `(História do aceite: H-nnn)` ou o nome da funcionalidade. Não sabe? Deixe em branco: o PO identifica pelos dossiês de aceite. Serve ao indicador "defeito que escapou" (relatos até 2 sprints depois do aceite).

**`[plugin]` no início do item** é ocorrência do próprio plugin (registrada pelo time quando a ferramenta falha), não do produto: o PO não a trata, e ela fica aqui para o `/review`.

## Abertas

- <relato, uma linha ou um parágrafo curto, por item> *(História do aceite: <H-nnn ou funcionalidade — opcional>)*

## Como este arquivo é fechado

`/po analyze` (ou a triagem do `/sm fix plan`) lê esta seção item a item, dá a cada pedido um **A-ID** e aplica a classificação. **Item tratado sai desta lista** — não fica arquivado aqui — e passa a viver só no destino que a classificação mandou; o índice de todos os pedidos é `.team-project/product-owner/demand-log.md`:

| Classificação | Destino |
|---|---|
| Evolução · capacidade nova | Análise em `product-owner/analysis/A-<nnn>-<slug>.md` e Histórias em esboço no Product Backlog (Origem `A-<nnn>`) |
| Defeito | Registro de GAPs da QA (`pending.md`), com o campo `origem: stakeholder` e a **História do aceite** passada pelo PO ao acionar `/qa bug` (por item, em lista) — se **elegível à trilha `fix`**, também a ficha `fixes/F-<nnn>.md` triada, e o destino informado é `/sm fix plan` |
| Ajuste pequeno | Elegível: ficha `fixes/F-<nnn>.md` com o delta, confirmado por você em formulário no `/sm fix plan`. Não elegível: evolução |
| Mudança em História do sprint em andamento | `/po impact` |
| Dúvida de uso · negado | A resposta, na linha do `demand-log.md` |

Item que só a QA consegue classificar depois de investigar **permanece na fila**, marcado como "aguardando investigação da QA" — não é removido antes da hora. Item `[plugin]` também permanece.

Este arquivo **não** guarda histórico de itens tratados — duplicar o registro aqui e no destino é a mesma divergência que `pending.md` existe para evitar (dono único, R12). O histórico vive no destino e no `demand-log.md`.
