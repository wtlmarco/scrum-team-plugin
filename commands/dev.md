---
description: Aciona o desenvolvedor — executa um Plano de Implementação já escrito pelo Arquiteto e devolve código, testes e verificação real.
argument-hint: "<ID da Task> [ | resume <ID> | gap <resposta do arquiteto>]"
---

Aciona o **desenvolvedor** do time.

Pedido do stakeholder: **$ARGUMENTS**

**Avulso é a etapa 3 do `/sm sprint run`** (`roles/scrum-master/process/sprint-run.md`), para retomada manual. **Pré-condição:** leia `.team-project/sprints/<n>/plan/<ID>-*.md` (sprint corrente em `.team-project/README.md` §2) — ou, **sem sprint corrente** (calibração), `.team-project/architect/calibration/<ID>-*.md`. Sem plano, não improvise: ofereça `/arc plan <ID>` — com sprint corrente, o plano só existe depois do ③.

Com o plano em mãos, use a ferramenta Agent com `subagent_type: "developer"` e `run_in_background: false`, passando o caminho do plano, o ID da Task e o modo:
- **`<ID>`** → executar o plano do início ao fim, na ordem dos passos.
- **resume `<ID>`** → continuar de onde parou; conferir no código o que já existe antes de escrever.
- **gap `<resposta>`** → retomar aplicando a decisão do Arquiteto; se o agente anterior ainda estiver ativo, continue por SendMessage.

O contrato de trabalho e o formato do 🔺 GAP estão no próprio agente (`agents/developer.md`) e não se repetem aqui. Pedido `/dev review …` → o caminho é **`/review …`**.

Registro de consumo: se `.team-project/sprints/<n>/consumption.md` existir, grave conforme `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/consumption.md` §Como gravar.

Pergunta ou portão na forma de R22 → `AskUserQuestion` pela sessão, 'pedir mais contexto' por último (`working-rules.md` R22).

Ao receber o relatório de entrega:
- **🔺 GAP** → leve-o ao Arquiteto (`/arc question`) e devolva a decisão ao dev; não resolva você. Peça a decisão **registrada no plano**, não a reprodução do passo (R9); conferir afirmação do dev é do QA (R7).
- **Entrega completa** → repasse o relatório ao stakeholder; próximo passo `/qa <ID>` e, com ✅, `/sm close <T-ID>`.
