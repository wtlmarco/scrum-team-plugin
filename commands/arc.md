---
description: Aciona o Arquiteto — diagnóstico técnico, desenho de solução, Plano de Implementação, SDD técnico, ADR e decisão sobre gap de implementação.
argument-hint: "[plan <ID> | comply <ID> | adr <tema> | question <dúvida>] ou descrição livre"
---

Aciona o **Arquiteto de Software Sênior** do time.

Pedido do stakeholder: **$ARGUMENTS**

Antes de abrir uma instância nova, confira com ListAgents se já existe, nesta sessão, um agente `architect` sobre a mesma Task/tema; se existir, retome-o com SendMessage (R3). Senão, use a ferramenta Agent com `subagent_type: "architect"` e `run_in_background: false`, passando o pedido acima, literal, e o modo, conforme o primeiro termo:

- **plan `<ID>`** → Plano de Implementação de **uma Task do Sprint Backlog aprovado, só depois do ③** — no fluxo normal, disparado pelo `/sm sprint run` (`roles/scrum-master/process/sprint-run.md`); avulso, só para retomada manual. **Sem sprint corrente** (calibração da instalação — `replicate-in-new-project.md` passo 6 — ou antes da 1ª Planning) o plano é só de calibração e vai para `.team-project/architect/calibration/<ID>-<slug>.md`. Com sprint corrente, Task fora do Sprint Backlog aprovado: o agente não escreve o plano e responde o que falta.
- **comply `<ID>`** → revisão de aderência no formato de `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/compliance-review.md`. **Só a pedido nomeado do stakeholder** — não é etapa do `sprint run` nem rota de volta (`workflow.md` §4a).
- **adr `<tema>`** → ADR no formato de `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/adr.md`.
- **question `<dúvida>`** → decidir no formato de `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/technical-decision.md`; chamado pelo `/sm sprint prepare`, responde por História na variante "Varredura técnica" do mesmo modelo. Dúvida funcional → `/po`; estratégica → stakeholder, com recomendação.
- **descrição livre** → tratar como `question`, e propor `plan` se exigir construção. É também o modo da **rodada de Fase 2 do brainstorm** e do **SDD técnico** (`03`/`04`/`05`), que o `/sm sdd` despacha na etapa 3; avulso, só conversa — roteiros em `${CLAUDE_PLUGIN_ROOT}/roles/architect/README.md`.

Leitura, limites e formato de resposta estão no próprio agente (`agents/architect.md`) e não se repetem aqui. Pedido `/arc review …` → o caminho é **`/review …`**.

Registro de consumo: se `.team-project/sprints/<n>/consumption.md` existir, grave conforme `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/consumption.md` §Como gravar.

Pergunta ou portão na forma de R22 → `AskUserQuestion` pela sessão, 'pedir mais contexto' por último (`working-rules.md` R22). O formulário do **portão ②** é disparado pelo **`/sm sdd`** (`workflow-sdd.md` §5h), não por este comando.

Ao receber a resposta, repasse ao stakeholder o diagnóstico e o caminho do artefato gerado, e destaque em uma linha o que exige decisão dele.
