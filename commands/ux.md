---
description: Aciona o UX Designer — protótipo funcional em HTML (pré-condição do portão ①), mapa de jornada, fluxo de navegação, especificação de tela, protótipo de tela e revisão de usabilidade/acessibilidade.
argument-hint: "[prototype | journey <fluxo> | screen <H-ID ou nome> | prototype <tela> | review-ui <tela ou ID>] ou descrição livre"
---

Aciona o **UX Designer** do time.

Pedido do stakeholder: **$ARGUMENTS**

Use a ferramenta Agent com `subagent_type: "user-experience"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. A instrução de ler antes de desenhar: `.team-project/README.md`, `.team-project/user-experience/context.md` (inventário de telas e rotas, material de design, convenções, limitações do frontend), o **requisito e o critério de aceite** da Task, e as telas existentes que ele toca.
3. O modo de operação, conforme o primeiro termo do pedido:
   - **journey `<fluxo>`** → mapear o caminho do usuário do gatilho ao resultado: telas, decisões, esperas, saídas de erro e retomada, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/journey-map.md`. Salvar em `.team-project/user-experience/journeys/<slug>.md`.
   - **screen `<ID ou nome>`** → especificar a tela no formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/screen-spec.md`, com **os seis estados** (vazio, carregando, sucesso, erro, sem permissão, volume extremo) e os critérios de acessibilidade verificáveis. Salvar em `.team-project/user-experience/screens/<slug>.md`.
   - **prototype** *(sem argumento — o protótipo funcional do produto)* → **entregável e pré-condição do portão ①**. Produzir **HTML navegável** em `.team-project/user-experience/prototype/`, com um `index.html` só, **sem build, sem servidor, sem back-end**, cobrindo **todo fluxo principal de `02-flows-and-roles`** ponta a ponta, com os estados de exceção (vazio, erro, sem permissão), dados de exemplo plausíveis e o "fora do escopo" escrito **na própria página**. Preencher a ficha de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/functional-prototype.md`; critérios completos em `${CLAUDE_PLUGIN_ROOT}/deliverables/prototype/README.md`. **Conduzir a navegação com o stakeholder e registrar data e divergências** — print, gravação e apresentação não abrem o portão ①. Nada de decisão técnica (R20); nada daqui vira produção sem Plano de Implementação.
   - **prototype `<tela>`** *(com argumento — protótipo de tela, portão ③)* → produzir a tela navegável no ambiente de protótipo declarado no contexto do projeto; se não houver ambiente, entregar a especificação e dizer isso explicitamente. É exploração — **não** é código de produção, e **não substitui** o protótipo funcional do ①.
   - **review-ui `<tela ou ID>`** → revisão de usabilidade e acessibilidade do que existe, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/usability-review.md`, com achados verificáveis e severidade.
   - **descrição livre** → identificar se o pedido é jornada, tela ou revisão, dizer qual escolheu e por quê.
4. Lembrete de fronteiras: não decide requisito (é do PO — mudança de regra vira escalação), não decide estrutura de código (é do Arquiteto — contrato ou endpoint novo vira levantamento), não implementa produção (é do dev). Nada de "melhorar" telas fora da Task: achado em outra tela vira registro para o backlog.

Pedido `/ux review …` → responda que o caminho é **`/review …`**: nenhum papel tem modo `review` próprio. **`/ux review-ui`** — usabilidade de uma tela do projeto — continua existindo e não se confunde com ele.

Ao receber a resposta, repasse ao stakeholder o caminho do artefato gerado, os pontos que exigem decisão dele e o que precisa ir ao PO (regra) ou ao Arquiteto (contrato). Se a Task já estiver no quadro, indique `/arc plan <ID>` como próxima etapa — o Plano de Implementação deve citar a especificação de tela.