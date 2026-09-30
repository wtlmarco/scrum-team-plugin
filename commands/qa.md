---
description: Aciona o QA — validação de requisito, aderência técnica, segurança, testes e documentação, com execução real de build/test/smoke.
argument-hint: "[<ID> | baseline | audit | security <ID> | bug <descrição> | scenarios create | scenarios run <SC-nnn|grupo|all>]"
---

Aciona o **QA** do time — o último portão antes do PO.

Pedido do stakeholder: **$ARGUMENTS**

Antes de abrir uma instância nova, confira com ListAgents se já existe, nesta sessão, um agente `quality-assurance` invocado há pouco sobre a mesma Task/tema; se existir, retome-o com SendMessage em vez de acionar o Agent de novo (R3). Só na ausência de um agente para retomar, use a ferramenta Agent com `subagent_type: "quality-assurance"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. O modo de operação. Roteiro de cada modo em `${CLAUDE_PLUGIN_ROOT}/roles/quality-assurance/README.md` ("Roteiro por modo") — não repetido aqui:
   - **`<ID>`** → validação completa nas seis frentes, com **execução real** dos comandos e veredito no formato de `${CLAUDE_PLUGIN_ROOT}/roles/quality-assurance/templates/verdict.md` (inclui as duas tabelas da frente 2 — `workflow.md` §4a — e o campo "Documentos vivos (R12)"). **Insumos que o QA recebe** (a sessão os passa; o `sprint run` chega aqui por este modo e não os repete): o caminho do plano `.team-project/sprints/<n>/plan/<ID>-*.md`; a especificação de tela (`.team-project/user-experience/screens/`, se a Task tem interface); o relatório de entrega do dev; o critério de aceite do PO; os **cenários mapeados** na Task (R30); a Task no quadro do SM; o **sprint corrente** `<n>` (`.team-project/README.md` §2), para gravar a evidência em `.team-project/sprints/<n>/evidence/<T-ID>.md` — nome previsível é parte do gate, ponteiro que não resolve é achado de processo. O agente lê por conta própria `.team-project/README.md` e `.team-project/quality-assurance/context.md`.
   - **baseline** → reproduzir no ambiente atual os números declarados (build, testes, cobertura, lint) e gravar em `.team-project/quality-assurance/baseline.md`, fora da pasta do sprint (`artifact-ownership.md` §1). Divergência vira GAP novo e aviso ao SM.
   - **audit** → auditoria cruzada em dois passes, formato de `templates/cross-audit.md`. Só listar achados.
   - **security `<ID>`** → foco na frente 3, com o checklist do `context.md`.
   - **bug `<descrição>`** → acionado pelo **PO**, nunca direto pelo stakeholder; único modo sem Task. Reproduzir; confirmado com `arquivo:linha`, registrar em `pending.md` com `Origem: stakeholder` (`templates/gap-record.md`); não reproduzido, suspeita, sem entrada nova. Defeito que o próprio time acha não usa este modo.
   - **scenarios create** → povoa a suíte (`.team-project/quality-assurance/scenarios/`, R30) a partir do SDD e do protótipo funcional: um `SC-nnn` (`templates/scenario.md`) por critério de aceite sem cenário, com "Fluxos que toca", e o índice atualizado. Roda no `/sm sprint prepare` (candidatas, sem aprovação do stakeholder), em projeto retomado e depois de requisitos novos; **não substitui** o mapeamento por Task na Planning. Critério ambíguo vira dúvida ao PO. Lote grande vai ao `operator` (R28).
   - **scenarios run `<SC-nnn | grupo | all>`** → um cenário roda no próprio QA; grupo e `all` vão **sempre** ao `operator` (R28). Sem a extensão de navegador, ⚠️ **não executado — sem ferramenta**. Atualiza o Histórico do `SC-nnn` e o índice; falha confirmada segue R30.
3. Lembrete de limites: o QA **reprova, não corrige**. Todo achado precisa de `arquivo:linha` ou saída de comando; sem isso, é suspeita. O que não pôde ser executado é declarado **não exercitado**, nunca omitido.

Pedido `/qa review …` → responda que o caminho é **`/review …`**. `/qa audit` roda **no projeto** (documentos do produto × código); `/review audit` roda no repositório do plugin (documentos de processo).

Registro de consumo: grave conforme `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/consumption.md` §Como gravar (papel `qa`; a seção "Execução delegada" do retorno vira uma linha `operator` por chamada).

Pergunta ou portão na forma de R22 → `AskUserQuestion` pela sessão, "pedir mais contexto" por último (`working-rules.md` R22). O agente não tem a ferramenta: é a sessão que orquestrou quem a chama (por exemplo, item de `pending.md` com `Aguarda decisão do stakeholder`).

Ao receber o veredito, repasse-o na íntegra ao stakeholder. Se for ✅, indique `/sm close <ID>` — dentro do `/sm sprint run` o SM fecha sozinho quando "Documentos vivos (R12)" está "atualizados" (`sprint-run.md` passo 7); fechar a Task é técnico, o aceite é da História, na Sprint Review (R21). Se for ⚠️ ou ❌, indique para quem cada achado volta pela coluna "Volta para" do veredito e pela escada de falha do README do QA. Nada disso antes do fechamento.
