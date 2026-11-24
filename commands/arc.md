---
description: Aciona o Arquiteto — diagnóstico técnico, desenho de solução, Plano de Implementação, SDD técnico, ADR e decisão sobre gap de implementação.
argument-hint: "[plan <ID> | adr <tema> | question <dúvida>] ou descrição livre"
---

Aciona o **Arquiteto de Software Sênior** do time.

Pedido do stakeholder: **$ARGUMENTS**

Antes de abrir uma instância nova, confira com ListAgents se já existe, nesta sessão, um agente `architect` sobre a mesma Task/tema; se existir, retome-o com SendMessage (R3) — **exceto com run ativo** (`.active-run`): a G19 nega o SendMessage e a retomada é por instância nova. Senão, use a ferramenta Agent com `subagent_type: "architect"` — o agente é **sempre assíncrono**: a chamada volta "lançado", você **encerra o turno** e o aviso traz a resposta (sem `Start-Sleep`, sem sondar o disco; no `sprint run` e no `fix run`, `sprint-run.md` §Disparo e espera) — e, **se `.team-project/models.json` define o papel, `model: "<valor>"`** (`sprint-run.md` §Modelo por papel; a G17 nega outro), passando o pedido acima, literal, e o modo, conforme o primeiro termo:

- **plan `<ID>`** → Plano de Implementação de **uma Task do Sprint Backlog aprovado, só depois do ③** — no fluxo normal, disparado pelo `/sm sprint run` (`roles/scrum-master/process/sprint-run.md`); avulso, só para retomada manual. **Sem sprint corrente** (calibração da instalação — `how-to.md` § "Calibrar a instalação" — ou antes da 1ª Planning) o plano é só de calibração e vai para `.team-project/architect/calibration/<ID>-<slug>.md`. Com sprint corrente, Task fora do Sprint Backlog aprovado: o agente não escreve o plano e responde o que falta.
- **adr `<tema>`** → ADR no formato de `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/adr.md`.
- **question `<dúvida>`** → decidir no formato de `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/technical-decision.md`; chamado pelo `/sm sprint prepare`, responde por História na variante "Varredura técnica" do mesmo modelo. Dúvida funcional → `/po`; estratégica → stakeholder, com recomendação.
- **descrição livre** → tratar como `question`, e propor `plan` se exigir construção. É também o modo da **rodada de Fase 2 do brainstorm** e do **SDD técnico** (`03`/`04`/`05`), que o `/sm sdd` despacha na etapa 3; avulso, só conversa — roteiros em `${CLAUDE_PLUGIN_ROOT}/roles/architect/README.md`.

Leitura, limites e formato de resposta estão no próprio agente (`agents/architect.md`) e não se repetem aqui. Pedido `/arc review …` → o caminho é **`/review …`**.

O consumo é medido pelo hook G16; não há linha a gravar à mão.

O formulário do **portão ②** é disparado pelo **`/sm sdd`** (`workflow-sdd.md` §5h), não por este comando.

Ao receber a resposta, repasse ao stakeholder o diagnóstico e o caminho do artefato gerado, e leve o que exige decisão dele em `AskUserQuestion` (R22), com a recomendação do Arquiteto marcada — não em prosa. **Antes do formulário (v3.66.0, R36):** o impasse vai ao `powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/impasse.ps1" raise -Type <tipo> -Part <parte> -Subject <chave> -Origin <modo> -Consulted "<§7 N | none>" -Text "<o impasse>"`, que diz o dono pela [matriz de impasses](../roles/scrum-master/process/impasse-matrix.md), recusa o que já foi decidido e só grava a rota para o tipo que sobe (escopo, dado gravado, prazo, contradição com aceite, portão, estratégico, risco, ação externa, configuração, autorização, atualização, pedido dele). Sem a rota, a G24 nega o formulário. Decisão técnica, de desenho, de produto ou de prova, a ordem do trabalho, o passo do roteiro e o registro ficam no time: execute e informe. Respondida, `impasse.ps1 close -Id <id> -Summary "<a decisão>" -Ref "<onde ficou>"`.
