---
description: Aciona o UX Designer — protótipo funcional em HTML (pré-condição do portão ①), mapa de jornada, fluxo de navegação, especificação de tela, protótipo de tela e revisão de usabilidade/acessibilidade.
argument-hint: "[prototype | prototype sprint <n> | prototype screen <tela> | journey <fluxo> | screen <H-ID ou nome> | review-ui <tela ou ID>] ou descrição livre"
---

Aciona o **UX Designer** do time.

Pedido do stakeholder: **$ARGUMENTS**

Antes de abrir uma instância nova, confira com ListAgents se já existe, nesta sessão, um agente `user-experience` invocado há pouco sobre a mesma Task/tema; se existir, retome-o com SendMessage em vez de acionar o Agent de novo — evita reler documentos-fonte já lidos (R3). Só na ausência de um agente para retomar, use a ferramenta Agent com `subagent_type: "user-experience"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. O modo de operação, conforme o primeiro termo do pedido (o roteiro de cada um está em `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/README.md` §Roteiro por modo; o agente já sabe o que ler antes de desenhar):
   - **journey `<fluxo>`** → mapa de jornada em `.team-project/user-experience/journeys/<slug>.md`, formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/journey-map.md`.
   - **screen `<ID ou nome>`** → especificação com **os seis estados** e critérios de acessibilidade verificáveis em `.team-project/user-experience/screens/<slug>.md`, formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/screen-spec.md`. `journey` e `screen` também são disparados em lote pelo `/sm sprint prepare` (candidatas, sem aprovação do stakeholder) e pelo `/sm sprint run` (só Task com interface).
   - **prototype** *(sem argumento — protótipo funcional, entregável e pré-condição do portão ①)* → HTML navegável em `.team-project/user-experience/prototype/`, cobrindo todo fluxo principal de `02-flows-and-roles`. Ficha em `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/functional-prototype.md`; critérios em `${CLAUDE_PLUGIN_ROOT}/deliverables/prototype/README.md`. **Entregar o HTML autocontido, pronto para a sessão publicar como artifact privado** (D5 · R34) — um `index.html` único, scripts só de cdnjs/jsdelivr/unpkg/tailwind/jquery, fontes só Google Fonts, resto inline, ≤ 16 MB, só dados fictícios; **não publico**. A navegação é do stakeholder e "aprovar" a declara (D2); print, gravação e apresentação não valem como navegação. Caso B: só os fluxos afetados. Harness completo ou leve conforme R23, gravando o parcial em `prototype/verification-log.md` (R5).
   - **prototype sprint `<n>`** *(protótipo costurado do sprint — peça do pacote de abertura, portão ③ em lote)* → costurar, a partir das especificações **já escritas** (costurar não é reespecificar), as telas das Histórias que entraram, em `.team-project/user-experience/prototype/sprint-<n>/`, com **ao menos um fluxo ponta a ponta**. Sem ele o sprint não arranca (R25 · `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/workflow-sprint.md` §5e Planning, passo 10 · §8). Ficha em `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/sprint-prototype.md`; critérios em `${CLAUDE_PLUGIN_ROOT}/deliverables/prototype/README.md`. O HTML do sprint também é autocontido e publicável (mesmo contrato), com rótulo de versão novo a cada recostura; quem publica é a sessão.
   - **prototype screen `<tela>`** *(com argumento — exploração no detalhamento, antes da Planning)* → tela navegável no ambiente declarado no contexto; sem ambiente, entregar a especificação e dizer isso. Não é código de produção, não tem portão e não substitui o protótipo do ① nem o do sprint.
   - **review-ui `<tela ou ID>`** → revisão de usabilidade e acessibilidade no formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/usability-review.md`.
   - **descrição livre** → identificar se é jornada, tela ou revisão, dizer qual escolheu e por quê.

Pedido `/ux review …` → responda que o caminho é **`/review …`**: nenhum papel tem modo `review` próprio. **`/ux review-ui`** continua existindo e não se confunde com ele.

## Registro de consumo

Grave conforme `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/consumption.md` §Como gravar.

Pergunta ou portão na forma de R22 → `AskUserQuestion` pela sessão, "pedir mais contexto" por último (`working-rules.md` R22). O agente não tem a ferramenta.

**Decisão de portão sobre protótipo.** A **navegação** é do stakeholder e "aprovar" a **declara** (D2 · R34); a decisão sai em `AskUserQuestion` — aprovar · aprovar com ajuste · reprovar · pedir mais contexto. Registre na ficha a declaração, a data, o canal (celular | terminal), URL e rótulo da versão quando houve link, a decisão e o ajuste pedido. O rótulo `**Navegado pelo stakeholder em:**` e a data logo após ficam como estão (o C2 os lê).
- **`prototype` (①):** formulário sobre o SDD funcional + protótipo, só dentro do `/sm sdd` (etapa 2); avulso, a decisão fica pendente. A ficha é o registro único.
- **`prototype sprint <n>` (parte do ③):** **sem formulário próprio** — a decisão é uma só, sobre o pacote inteiro, feita na submissão pelo `/sm sprint plan` e registrada na linha "Decisão do stakeholder" do Sprint Backlog. O UX só aponta para ela na ficha.
- **"Pedir mais contexto"** não aprova nem reprova: registre a pergunta na ficha, responda e refaça o formulário.

Ao receber a resposta, repasse ao stakeholder o caminho do artefato gerado, os pontos que exigem decisão dele (em `AskUserQuestion`, R22 — não em prosa) e o que precisa ir ao PO (regra) ou ao Arquiteto (contrato). Se a Task já estiver no quadro, indique `/arc plan <ID>` como próxima etapa — o Plano de Implementação deve citar a especificação de tela.
