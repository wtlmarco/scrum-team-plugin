---
description: Aciona o UX Designer — protótipo funcional em HTML (pré-condição do portão ①), mapa de jornada, fluxo de navegação, especificação de tela, protótipo de tela e revisão de usabilidade/acessibilidade.
argument-hint: "[prototype | prototype sprint <n> | prototype screen <tela> | journey <fluxo> | screen <H-ID ou nome> | review-ui <tela ou ID>] ou descrição livre"
---

Aciona o **UX Designer** do time.

Pedido do stakeholder: **$ARGUMENTS**

Antes de abrir uma instância nova, confira com ListAgents se já existe, nesta sessão, um agente `user-experience` invocado há pouco sobre a mesma Task/tema; se existir, retome-o com SendMessage em vez de acionar o Agent de novo — evita reler documentos-fonte já lidos (R3). Só na ausência de um agente para retomar, use a ferramenta Agent com `subagent_type: "user-experience"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. A instrução de ler antes de desenhar: `.team-project/README.md`, `.team-project/user-experience/context.md` (inventário de telas e rotas, material de design, convenções, limitações do frontend), o **requisito e o critério de aceite** da Task, e as telas existentes que ele toca.
3. O modo de operação, conforme o primeiro termo do pedido:
   - **journey `<fluxo>`** → mapear o caminho do usuário do gatilho ao resultado: telas, decisões, esperas, saídas de erro e retomada, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/journey-map.md`. Salvar em `.team-project/user-experience/journeys/<slug>.md`.
   - **screen `<ID ou nome>`** → especificar a tela no formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/screen-spec.md`, com **os seis estados** (vazio, carregando, sucesso, erro, sem permissão, volume extremo) e os critérios de acessibilidade verificáveis. Salvar em `.team-project/user-experience/screens/<slug>.md`.
   - **prototype** *(sem argumento — o protótipo funcional do produto)* → **entregável e pré-condição do portão ①**. Produzir **HTML navegável** em `.team-project/user-experience/prototype/`, com um `index.html` só, **sem build, sem servidor, sem back-end**, cobrindo **todo fluxo principal de `02-flows-and-roles`** ponta a ponta, com os estados de exceção (vazio, erro, sem permissão), dados de exemplo plausíveis e o "fora do escopo" escrito **na própria página**. Preencher a ficha de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/functional-prototype.md`; critérios completos em `${CLAUDE_PLUGIN_ROOT}/deliverables/prototype/README.md`. **Conduzir a navegação com o stakeholder e registrar data e divergências** — print, gravação e apresentação não abrem o portão ①. Exercitar o protótipo com a verificação executável no escopo que a mudança pede (completo na primeira entrega ou em mudança transversal; leve no ajuste pontual — R23), gravando o parcial em `prototype/verification-log.md` a cada tela concluída (R5). Nada de decisão técnica (R20); nada daqui vira produção sem Plano de Implementação.
   - **prototype sprint `<n>`** *(o protótipo costurado do sprint — peça do pacote de abertura, portão ③ em lote)* → costurar num caminho navegável as telas das Histórias que entraram no sprint, a partir das especificações **já escritas** — **costurar não é reespecificar**. Sai em `.team-project/user-experience/prototype/sprint-<n>/`, cobrindo **ao menos um fluxo ponta a ponta**; é ele que prova que o sprint entrega fatia usável, e sem ele o sprint não arranca (R25 · `workflow.md` §5e passo 10 · §8). Ficha em `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/sprint-prototype.md`; critérios em `${CLAUDE_PLUGIN_ROOT}/deliverables/prototype/README.md`. Verificação **leve** permitida sobre telas já verificadas (R23) — o fluxo ponta a ponta é exercitado de verdade em toda rodada, e a ficha declara o que **não** foi reexecutado.
   - **prototype screen `<tela>`** *(com argumento — protótipo de tela, exploração no detalhamento funcional, antes da Planning)* → produzir a tela navegável no ambiente de protótipo declarado no contexto do projeto; se não houver ambiente, entregar a especificação e dizer isso explicitamente. É exploração — **não** é código de produção, **não** tem portão próprio, e **não substitui** nem o protótipo funcional do ① nem o do sprint.
   - **review-ui `<tela ou ID>`** → revisão de usabilidade e acessibilidade do que existe, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/usability-review.md`, com achados verificáveis e severidade.
   - **descrição livre** → identificar se o pedido é jornada, tela ou revisão, dizer qual escolheu e por quê.
4. Lembrete de fronteiras: não decide requisito (é do PO — mudança de regra vira escalação), não decide estrutura de código (é do Arquiteto — contrato ou endpoint novo vira levantamento), não implementa produção (é do dev). Nada de "melhorar" telas fora da Task: achado em outra tela vira registro para o backlog.

Pedido `/ux review …` → responda que o caminho é **`/review …`**: nenhum papel tem modo `review` próprio. **`/ux review-ui`** — usabilidade de uma tela do projeto — continua existindo e não se confunde com ele.

## Registro de consumo — só onde o registro existe

Se `.team-project/sprints/<n>/consumption.md` existir — `<n>` é o **sprint corrente**, em `.team-project/README.md` §2 —, acrescente uma linha quando o agente retornar, com os números que ele devolve: data, papel `ux`, comando, Task/História (ou `n/a`), tokens, duração. Número indisponível: "não disponível — <motivo>", nunca estime (R7). Sem o arquivo, nada a fazer.

Ao receber a resposta, repasse ao stakeholder o caminho do artefato gerado, os pontos que exigem decisão dele e o que precisa ir ao PO (regra) ou ao Arquiteto (contrato). Se a Task já estiver no quadro, indique `/arc plan <ID>` como próxima etapa — o Plano de Implementação deve citar a especificação de tela.
