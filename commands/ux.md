---
description: Aciona o UX Designer — mapa de jornada, fluxo de navegação, especificação de tela, protótipo e revisão de usabilidade/acessibilidade.
argument-hint: "[journey <fluxo> | screen <ID ou nome> | prototype <tela> | review-ui <tela ou ID> | review <instrução>] ou descrição livre"
---

Aciona o **UX Designer** do time.

Pedido do stakeholder: **$ARGUMENTS**

Use a ferramenta Agent com `subagent_type: "user-experience"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. A instrução de ler antes de desenhar: `.team-project/README.md`, `.team-project/user-experience/context.md` (inventário de telas e rotas, material de design, convenções, limitações do frontend), o **requisito e o critério de aceite** do item, e as telas existentes que ele toca.
3. O modo de operação, conforme o primeiro termo do pedido:
   - **journey `<fluxo>`** → mapear o caminho do usuário do gatilho ao resultado: telas, decisões, esperas, saídas de erro e retomada, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/journey-map.md`. Salvar em `.team-project/user-experience/journeys/<slug>.md`.
   - **screen `<ID ou nome>`** → especificar a tela no formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/screen-spec.md`, com **os seis estados** (vazio, carregando, sucesso, erro, sem permissão, volume extremo) e os critérios de acessibilidade verificáveis. Salvar em `.team-project/user-experience/screens/<slug>.md`.
   - **prototype `<tela>`** → produzir a tela navegável no ambiente de protótipo declarado no contexto do projeto; se não houver ambiente, entregar a especificação e dizer isso explicitamente. Protótipo é exploração — **não** é código de produção.
   - **review-ui `<tela ou ID>`** → revisão de usabilidade e acessibilidade do que existe, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/usability-review.md`, com achados verificáveis e severidade.
   - **descrição livre** → identificar se o pedido é jornada, tela ou revisão, dizer qual escolheu e por quê.
   - **review `<instrução>`** → aperfeiçoar os próprios documentos de processo. Ver o contrato abaixo.
4. Lembrete de fronteiras: não decide requisito (é do PO — mudança de regra vira escalação), não decide estrutura de código (é do Arquiteto — contrato ou endpoint novo vira levantamento), não implementa produção (é do dev). Nada de "melhorar" telas fora do item: achado em outra tela vira registro para o backlog.

## Modo `review` — evolução dos documentos deste papel

**Leia `${CLAUDE_PLUGIN_ROOT}/review-contract.md` e siga-o** — quatro passos, reavaliação do conjunto e limites comuns. Só neste modo.

**Alcance do UX:** `roles/user-experience/README.md` (roteiro e fronteiras), `skills.md` (competências) e `templates/*` (mapa de jornada, especificação de tela, revisão de usabilidade) — incluindo os **seis estados** obrigatórios e a lista de critérios de acessibilidade verificáveis, que vivem nesses modelos e entram na reavaliação.

Ao receber a resposta, repasse ao stakeholder o caminho do artefato gerado, os pontos que exigem decisão dele e o que precisa ir ao PO (regra) ou ao Arquiteto (contrato). Se o item já estiver no quadro, indique `/arc plan <ID>` como próxima etapa — o Plano de Execução deve citar a especificação de tela.