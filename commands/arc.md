---
description: Aciona o Arquiteto — diagnóstico técnico, desenho de solução, Plano de Implementação, ADR e decisão sobre gap de implementação.
argument-hint: "[plan <ID> | comply <ID> | adr <tema> | question <dúvida>] ou descrição livre"
---

Aciona o **Arquiteto de Software Sênior** do time.

Pedido do stakeholder: **$ARGUMENTS**

Antes de abrir uma instância nova, confira com ListAgents se já existe, nesta sessão, um agente `architect` invocado há pouco sobre a mesma Task/tema; se existir, retome-o com SendMessage em vez de acionar o Agent de novo — evita reler documentos-fonte já lidos (R3). Só na ausência de um agente para retomar, use a ferramenta Agent com `subagent_type: "architect"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. A instrução de ler antes de responder: `.team-project/README.md`, `.team-project/architect/context.md`, os normativos em `${CLAUDE_PLUGIN_ROOT}/standards/`, os documentos de arquitetura/dados/API indicados no contexto, e **o código real** envolvido (com `arquivo:linha` como evidência).
3. O modo de operação, conforme o primeiro termo do pedido:
   - **plan `<ID>`** → diagnóstico com evidência, desenho da solução, alternativas descartadas em uma linha cada, impacto (arquivos, migration, contrato de API, risco de regressão) e o **Plano de Implementação** no formato de `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/implementation-plan.md`, salvo em `.team-project/architect/plans/<ID>-<slug>.md`, respeitando a capacidade declarada no contexto do projeto.
   - **comply `<ID>`** → revisão de aderência do que voltou do dev, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/compliance-review.md`. Aponte desvio com `arquivo:linha`; não corrija o código. É revisão **sob demanda**, não etapa do ciclo (`workflow.md` §4a): roda por iniciativa do Arquiteto antes do QA, ou como rota de volta de achado de aderência ⚠️/❌. Confere a **aplicação** do que o plano citou — não se o plano citou o conjunto certo de seções, o que é a frente 2 do QA.
   - **adr `<tema>`** → escrever/atualizar a ADR no formato de `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/adr.md`, no diretório de ADRs do projeto, com checklist de aceitação verificável.
   - **question `<dúvida>`** → responder e **decidir** no formato de `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/technical-decision.md`, não devolver a pergunta. Se for dúvida funcional, dizer que o caminho é `/po`; se for estratégica (stack, provedor, custo), escalar ao stakeholder com recomendação.
   - **descrição livre** → tratar como `question`, e propor `plan` se a resposta exigir construção.
4. Lembrete de limites: a entrega é o plano, não o commit — só toque no código se o stakeholder pedir ou num spike declarado. Não decide requisito (isso é do PO). Spike com chamada externa: timeout e tentativas explícitos, checkpoint por etapa, e etapa que estourar as tentativas é relatada como inconclusiva por causa externa, nunca deixada travando.

Pedido `/arc review …` → responda que o caminho é **`/review …`**: nenhum papel tem modo `review` próprio.

Ao receber a resposta, repasse ao stakeholder o diagnóstico e o caminho do plano gerado, e destaque em uma linha o que exige decisão dele.