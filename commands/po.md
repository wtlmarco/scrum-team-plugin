---
description: Aciona o Product Owner — análise funcional, requisitos, escrita e detalhamento de Histórias, priorização do Product Backlog e aceite de História na Sprint Review.
argument-hint: "[analyze <ideia> | requirement <ID> | story <H-ID> | prioritize | accept <H-ID>] ou pergunta livre"
---

Aciona o **Product Owner** do time.

Pedido do stakeholder: **$ARGUMENTS**

Use a ferramenta Agent com `subagent_type: "product-owner"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. A instrução de ler antes de responder: `.team-project/README.md`, `.team-project/product-owner/context.md`, `.team-project/product-owner/product-backlog.md` (o conjunto das Histórias) e os documentos de requisitos/critérios indicados no contexto.
3. O modo de operação, conforme o primeiro termo do pedido:
   - **analyze** → análise funcional no formato de `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/functional-analysis.md`: problema do usuário, regra, casos de borda, impacto nos requisitos existentes, decisão (aprovado / aprovado com ajuste / negado) e, se aprovado, o requisito redigido.
   - **requirement** → redigir ou revisar o requisito no formato de `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/requirement.md`, mantendo a numeração e a grafia existentes.
   - **story `<H-ID>`** → escrever ou detalhar a **História**, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/user-story.md`. **Esboço** (a História nasce de requisito do SDD já aprovado): valor em uma frase, origem rastreada, tamanho grosseiro; entra no Product Backlog sem detalhar. **Detalhe** (a História candidata ao próximo sprint): regras funcionais com casos de borda, protótipo do UX se há interface (`/ux screen` — sem ele o detalhamento não fecha, R8), critérios de aceite cada um com "como verificar", e o "fora desta História". Fechar apresentando ao stakeholder e **registrando a aprovação — portão ③**; sem ela a História não entra na Planning Meeting. **Nada técnico entra aqui** (R20): arquivo, classe, endpoint ou estrutura de dados no detalhamento é achado de processo.
   - **prioritize** → ordenar o Product Backlog — que é o **conjunto das Histórias** — por valor e risco funcional, segundo a régua do projeto, justificando cada posição em uma linha; é dessa ordem que sai a lista de candidatas na Planning Meeting.
   - **accept `<H-ID>`** → aceite formal da **História**, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/acceptance.md`. **Só na Sprint Review** (R21): exige os vereditos do QA das Tasks da História anexados; confere critério a critério apontando a Task que cumpre e a evidência; ressalva vira entrada no Product Backlog com dono, na mesma sessão; rejeição devolve a História inteira, com as Tasks aprovadas anotadas como já feitas. **O alvo é a História, nunca a Task** — Task não se aceita, fecha tecnicamente no `/sm close`.
   - **pergunta livre** → responder na visão de produto, sem entrar em solução técnica.
4. Lembrete de limites: não decide "como"; não escreve código, especificação técnica, ADRs, padrões, status, mapa de código nem registro de GAPs. **Não escreve Task** — quem quebra a História em Tasks é o time, na Planning Meeting. Lacuna de especificação vira escalação ao stakeholder com no máximo 3 opções e uma recomendação.

## Evolução dos documentos do PO — não é aqui

Os documentos de processo do PO (roteiro, skills, modelos, os entregáveis do SDD que ele possui) evoluem pelo comando **`/review`**, que aciona o Agent `product-owner` conforme `${CLAUDE_PLUGIN_ROOT}/review-contract.md`. Não há mais `/po review`. Pedido `/po review …` → responda que o caminho é `/review …`.

Ao receber a resposta, repasse a decisão e o requisito na íntegra e destaque o que precisa de definição do stakeholder.