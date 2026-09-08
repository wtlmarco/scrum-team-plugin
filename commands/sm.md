---
description: Aciona o Scrum Master — status do projeto, Planning Meeting, Sprint Backlog, Sprint Review, retrospectiva, riscos, análise de impacto e fechamento de Task.
argument-hint: "[onboarding | status | sprint plan | sprint close | review | board | impact <mudança> | close <T-ID>] ou pergunta livre"
---

Aciona o **Scrum Master** do time.

Pedido do stakeholder: **$ARGUMENTS**

Use a ferramenta Agent com `subagent_type: "scrum-master"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. A instrução de ler antes de responder: `.team-project/README.md`, `.team-project/scrum-master/context.md` e `.team-project/scrum-master/sprint-backlog.md` — e, se o pedido envolver escopo aberto, o registro de GAPs indicado no contexto.
3. O modo de operação, conforme o primeiro termo do pedido:
   - **onboarding** → ritual único de alinhamento do time num projeto novo ou retomado, antes da primeira Planning Meeting (R14). Conduza os seis passos de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/workflow.md` §5a: (1) inventário das fontes de documentação do projeto — existe? última atualização? dono?; (2) lacunas contra a documentação, que é a **primeira fonte** — o stakeholder responde só o que ela não cobre; (3) bifurcação: doc funcional essencial ausente → `/team brainstorm` e pausa o onboarding · doc desatualizada ou contraditória → risco no quadro + `/qa audit`; (4) leitura de entrada de ≤10 linhas dos outros cinco papéis — PO, Arquiteto, UX, dev, QA (mandato entendido, o que falta, um risco); (5) consolidação numa lista única de perguntas ao stakeholder — estratégicas + lacunas pequenas — cada uma com opções e recomendação do time (R9) — inclua aqui a **duração do sprint** e a **unidade de estimativa**, se ainda não estiverem no contexto; (6) registro do entendimento alinhado em `.team-project/README.md` e nos `context.md`, e abertura do quadro. Entrega: a tabela de inventário, as cinco leituras, a lista de decisões pendentes do stakeholder e a checklist de saída preenchida. Sem onboarding concluído, `/sm sprint plan` não roda.
   - **status** (ou pedido vazio) → status curto no formato de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/status.md`; sem propor trabalho novo.
   - **sprint plan** → a **Planning Meeting**, que abre o sprint. Seis passos de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/workflow.md` §5e: (1) fechar o sprint anterior — Review feita, retrospectiva registrada, Tasks não concluídas devolvidas ao Product Backlog **com a História**; (2) selecionar as Histórias candidatas na ordem do PO, **só as aprovadas no portão ③** — História sem aprovação do stakeholder é devolvida, não negociada; (3) o time quebra cada História em Tasks, toda Task sob a sua História (R20); (4) o time estima cada Task na unidade declarada em `.team-project/README.md`; (5) somar e cortar na **capacidade observada** (média entregue nos 3 sprints anteriores) — soma acima disso exige justificativa escrita; (6) o PO declara o objetivo do sprint em uma frase. Entrega: o Sprint Backlog fechado, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/sprint-backlog.md`.
   - **sprint close** → encerra o sprint, **depois** da Sprint Review. Conduzir a retrospectiva no formato de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/retrospective.md`; conferir que toda ressalva virou entrada com dono no Product Backlog e que toda Task inacabada voltou com a História. Nada mais entra no sprint depois disto.
   - **review** → a **Sprint Review**, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/sprint-review.md`. Conduzir e **registrar**; o **PO demonstra** cada História contra os critérios aprovados no portão ③ e **é quem aceita** (R21) — o SM não aceita. História rejeitada volta inteira ao Product Backlog, com as Tasks aprovadas anotadas. Gaps, débitos e ressalvas entram no Product Backlog na mesma sessão, com dono.
   - **board** → atualizar/apresentar o Sprint Backlog vivo, por História, sem replanejar. **O escopo não cresce** (R4): trabalho novo vai ao Product Backlog; exceção única é o GAP que bloqueia História já no sprint, registrado com "o que saiu para caber".
   - **impact** → análise no formato de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/impact-analysis.md`, com recomendação; **não** aplicar a mudança.
   - **close `<T-ID>`** → **fechamento técnico da Task**: só depois de veredito ✅ do QA com evidência e dos documentos vivos atualizados pelos donos (R12). Mover no quadro e registrar no documento de status, usando `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/status-entry.md`. **Não confira aceite do PO aqui** — o aceite é da História, na Sprint Review (R21).
4. Lembrete de limites: não escreve código, especificação funcional, especificação técnica, ADRs, mapa de código nem registro de GAPs; dúvida funcional vai ao PO, técnica ao Arquiteto, estratégica ao stakeholder.

## `/sm review` × `/review` — dois comandos, objetos opostos

| | `/sm review` | `/review` |
|---|---|---|
| **O que é** | Sprint Review | Evolução do processo do time |
| **Roda em** | qualquer projeto onde o time está instalado | **só no repositório-fonte do plugin** |
| **Olha** | o produto entregue no sprint | os documentos de `${CLAUDE_PLUGIN_ROOT}/` |
| **Produz** | aceite das Histórias pelo PO + gaps e débitos | mudança de normativo + entrada no changelog do processo |

Pedido `/sm review` **sem** argumento, ou com um número de sprint, é Sprint Review — trate como o modo `review` acima. Pedido que claramente fala de mudar o processo do time (regra, cerimônia, modelo, comportamento de papel) responda que o caminho é `/review …`.

Ao receber a resposta, repasse ao stakeholder o status/plano na íntegra (é a entrega) e destaque em uma linha o que exige decisão dele.