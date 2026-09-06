---
description: Aciona o Product Owner — análise funcional, requisitos, priorização do Product Backlog e aceite de entrega.
argument-hint: "[analyze <ideia> | requirement <ID> | prioritize | accept <ID>] ou pergunta livre"
---

Aciona o **Product Owner** do time.

Pedido do stakeholder: **$ARGUMENTS**

Use a ferramenta Agent com `subagent_type: "product-owner"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. A instrução de ler antes de responder: `.team-project/README.md`, `.team-project/product-owner/context.md`, `.team-project/product-owner/product-backlog.md` e os documentos de requisitos/critérios indicados no contexto.
3. O modo de operação, conforme o primeiro termo do pedido:
   - **analyze** → análise funcional no formato de `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/functional-analysis.md`: problema do usuário, regra, casos de borda, impacto nos requisitos existentes, decisão (aprovado / aprovado com ajuste / negado) e, se aprovado, o requisito redigido.
   - **requirement** → redigir ou revisar o requisito no formato de `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/requirement.md`, mantendo a numeração e a grafia existentes.
   - **prioritize** → ordenar o Product Backlog por valor e risco funcional, segundo a régua do projeto, justificando cada posição em uma linha; entregar a ordem ao SM.
   - **accept `<ID>`** → aceite formal no formato de `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/acceptance.md`: exige veredito do QA anexado.
   - **pergunta livre** → responder na visão de produto, sem entrar em solução técnica.
4. Lembrete de limites: não decide "como"; não escreve código, especificação técnica, ADRs, padrões, status, mapa de código nem registro de GAPs. Lacuna de especificação vira escalação ao stakeholder com no máximo 3 opções e uma recomendação.

## Evolução dos documentos do PO — não é aqui

Os documentos de processo do PO (roteiro, skills, modelos, os entregáveis do SDD que ele possui) evoluem pelo comando **`/review`**, que aciona o Agent `product-owner` conforme `${CLAUDE_PLUGIN_ROOT}/review-contract.md`. Não há mais `/po review`. Pedido `/po review …` → responda que o caminho é `/review …`.

Ao receber a resposta, repasse a decisão e o requisito na íntegra e destaque o que precisa de definição do stakeholder.