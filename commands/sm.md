---
description: "Aciona o Scrum Master — processo, organização e eficiência. Gere os rituais (onboarding, sprint 0, brainstorm, sdd, e o sprint: prepare, plan, run, review, close), o Sprint Backlog, a capacidade e os riscos; facilita acordo entre papéis; fecha Task. Prazo, prioridade, status e impacto são do PO."
argument-hint: "[onboarding | sprint0 plan|run|review|area <área> | brainstorm <ideia> | sdd [<tema>] | sprint prepare|plan|run [<T-ID>]|review|close | fix [plan [<F-ID> …]|run] | board | agreement <questão> | consulting <domínio> <tema> | close <T-ID>]"
---

Aciona o **Scrum Master** do time. Pedido do stakeholder: **$ARGUMENTS**

Este texto vai inteiro a cada `/sm`, por isso é curto (v3.66.2): o que cada modo pede está nos arquivos abaixo, e você lê **só o do seu modo**.

- **`sprint run [<T-ID>]`:** leia o cartão `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/sprint-run-session.md` e siga o laço dele — `run.ps1 next` e a PRÓXIMA AÇÃO que ele imprimir. **Não leia o `sprint-run.md` inteiro** (≈70 mil caracteres): só a seção que o `next` ou uma guarda citar.
- **Qualquer outro modo:** leia em `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/sm-modes.md` a linha do seu modo na tabela "Quem despacha", as pré-condições dele e "Como disparar", e siga o roteiro que a linha aponta.

Em todo modo: o Agent `scrum-master` não dispara outros agentes — nos modos de sessão, **você** orquestra; decisão que só o stakeholder toma vai em `AskUserQuestion` (R22), com a rota do `impasse.ps1 raise` antes (R36; sem ela, a G24 nega); pré-condição que falha: pare e reporte.
