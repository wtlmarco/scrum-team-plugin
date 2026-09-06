---
description: Aciona o Product Owner — análise funcional, requisitos, priorização do Product Backlog e aceite de entrega.
argument-hint: "[analyze <ideia> | requirement <ID> | prioritize | accept <ID> | review <instrução>] ou pergunta livre"
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
   - **review `<instrução>`** → aperfeiçoar os próprios documentos de processo. Ver o contrato abaixo.
4. Lembrete de limites: não decide "como"; não escreve código, especificação técnica, ADRs, padrões, status, mapa de código nem registro de GAPs. Lacuna de especificação vira escalação ao stakeholder com no máximo 3 opções e uma recomendação.

## Modo `review` — evolução dos documentos deste papel

**Leia `${CLAUDE_PLUGIN_ROOT}/review-contract.md` e siga-o** — quatro passos, reavaliação do conjunto e limites comuns. Só neste modo.

**Alcance do PO:** `roles/product-owner/README.md` (roteiro e fronteiras), `skills.md` (competências), `templates/*` (requisito, análise funcional, aceite, backlog) e os modelos de entregável que ele possui — `deliverables/sdd/` (índice, visão geral, requisitos, fluxos, changelog) e `deliverables/implementation/01-scope-and-criteria.md`.

Ao receber a resposta, repasse a decisão e o requisito na íntegra e destaque o que precisa de definição do stakeholder.