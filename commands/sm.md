---
description: Aciona o Scrum Master — status do projeto, planejamento do ciclo, quadro de tarefas, riscos, análise de impacto e evolução do processo de trabalho do time.
argument-hint: "[onboarding | status | plan | board | impact <mudança> | close <ID>] ou pergunta livre"
---

Aciona o **Scrum Master** do time.

Pedido do stakeholder: **$ARGUMENTS**

Use a ferramenta Agent com `subagent_type: "scrum-master"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. A instrução de ler antes de responder: `.team-project/README.md`, `.team-project/scrum-master/context.md` e `.team-project/scrum-master/work-board.md` — e, se o pedido envolver escopo aberto, o registro de GAPs indicado no contexto.
3. O modo de operação, conforme o primeiro termo do pedido:
   - **onboarding** → ritual único de alinhamento do time num projeto novo ou retomado, antes do primeiro `/sm plan` (R14). Conduza os seis passos de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/workflow.md` §5a: (1) inventário das fontes de documentação do projeto — existe? última atualização? dono?; (2) lacunas contra a documentação, que é a **primeira fonte** — o stakeholder responde só o que ela não cobre; (3) bifurcação: doc funcional essencial ausente → `/team brainstorm` e pausa o onboarding · doc desatualizada ou contraditória → risco no quadro + `/qa audit`; (4) leitura de entrada de ≤10 linhas dos outros cinco papéis — PO, Arquiteto, UX, dev, QA (mandato entendido, o que falta, um risco); (5) consolidação numa lista única de perguntas ao stakeholder — estratégicas + lacunas pequenas — cada uma com opções e recomendação do time (R9); (6) registro do entendimento alinhado em `.team-project/README.md` e nos `context.md`, e abertura do quadro. Entrega: a tabela de inventário, as cinco leituras, a lista de decisões pendentes do stakeholder e a checklist de saída preenchida. Sem onboarding concluído, `/sm plan` não roda.
   - **status** (ou pedido vazio) → status curto no formato de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/status.md`; sem propor trabalho novo.
   - **plan** → propor o próximo ciclo: itens na ordem, dono sugerido, dependências, critério de pronto e evidência esperada, respeitando a capacidade declarada no contexto do projeto. Atualizar o quadro.
   - **board** → atualizar/apresentar o quadro vivo, sem replanejar.
   - **impact** → análise no formato de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/impact-analysis.md`, com recomendação; **não** aplicar a mudança.
   - **close `<ID>`** → só depois de veredito ✅ do QA e aceite do PO: mover no quadro e registrar no documento de status, usando `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/status-entry.md`.
4. Lembrete de limites: não escreve código, especificação funcional, especificação técnica, ADRs, mapa de código nem registro de GAPs; dúvida funcional vai ao PO, técnica ao Arquiteto, estratégica ao stakeholder.

## Evolução do processo — não é aqui

A curadoria e a evolução do processo de trabalho do time são pelo comando **`/review`** (que aciona o Agent `scrum-master` para os normativos e para a curadoria). Não há mais `/sm review`. Se o pedido chegar como `/sm review …`, responda que o caminho é `/review …`.

Ao receber a resposta, repasse ao stakeholder o status/plano na íntegra (é a entrega) e destaque em uma linha o que exige decisão dele.