# `/sm sprint run` — cartão da sessão que orquestra

> **Dono:** SM · v3.66.2. É o que a sessão lê ao abrir o `sprint run`, **no lugar do roteiro inteiro**. O [`sprint-run.md`](sprint-run.md) (≈70 mil caracteres) é a fonte única e a consulta: leia **só a seção** que o `run.ps1 next` ou uma guarda citar, pelo título (Grep) e com `offset`/`limit`. Na sessão de 24/11 do garden, ler o roteiro inteiro na abertura levou a conversa de 55 para 80 mil tokens antes do primeiro passo.

## O laço
1. **Abertura, nada além dela:** `.team-project/scrum-master/context.md` e `sprints/<n>/sprint-backlog.md`; o `README.md` do projeto só se faltar algo. O `run-log.md` só em retomada, bloqueio e Review.
2. **`powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/run.ps1" next`** e faça a **PRÓXIMA AÇÃO** que ele imprimir — o disparo vem pronto (papel, `model`, prompt). Não decida o próximo passo relendo roteiro: pergunte ao script.
3. **Disparou um agente: encerre o turno.** O aviso de conclusão reabre a sessão; aí, `run.ps1 next` de novo. Um agente por vez (R1). A construção de cada Task é do **executor de Task** (`team:task-runner`), que devolve **uma linha**; siga o que ela pede pelo `next`.
4. **Espera:** quando o `next` manda esperar, ele imprime `quem avisa:` e a linha do **watcher** — dispare o watcher e encerre o turno. Sem agente desta sessão em voo, a G20 barra o fim de turno. O watcher só volta quando a espera muda (`terminou`, `travado` ou `teto`): rode `run.ps1 next`. Se o agente esperado voltar antes, encerre o watcher (`TaskStop`) e rode o `next`.
5. **Nunca:** `Start-Sleep`, sondagem do disco, comando em segundo plano (G22), comando longo na sessão (vai ao `operator`, R28), `SendMessage` (G19; retomada é instância nova com o cartão).

## Fala ao stakeholder
A fala de cada turno é a linha **`PARA O STAKEHOLDER:`** do `next`, copiada, uma por turno, sem termo técnico (nem script, regra, "GAP", caminho). Se ele pedir detalhe, responda o técnico curto e volte às frases simples. Turno sem `next` novo: nenhuma fala.

## Formulário
Só quando o `run.ps1` manda levar ao stakeholder — ele grava a rota (`.ask-route`), e a G24 nega o `AskUserQuestion` sem ela. Formato do H1 ([`templates/stakeholder-question.md`](../templates/stakeholder-question.md)): uma ou duas frases sem jargão, um exemplo do produto, recomendação primeiro e "Pedir mais contexto" por último. Decisão técnica, de desenho, de produto ou de prova fica no time.

## Paradas legítimas (lista fechada)
(a) fim da fila → formulário de autorização da Review (§Ao fim da fila); (b) bloqueio que o degrau 1 não fechou e nenhuma Task elegível → formulário; (c) pré-condição falha; (d) interrupção pelo stakeholder e (e) pausa pedida por ele → `run.ps1 pause -Because "<o pedido>"`; (f) ponto seguro (`.safe-point`, gravado pelo `done` que fechou a Task). Fim de Task fora do ponto seguro, "sigo?", tamanho da fila e consumo **não** são parada.

## Reinício e queda
- **Reinício por teto:** o `next` responde `reiniciar a sessão` acima de `run.sessionContextCap` (padrão 100 mil): diga ao stakeholder, em uma linha, para digitar `/clear` e `/sm sprint run`, e encerre o turno. Nada se perde: o estado está no disco.
- **Queda (sessão, energia, limite de uso):** o mesmo comando retoma (`/sm sprint run`); o `next` mostra `RETOMADA:` e segue.
- **Invocação interrompida sem ação do stakeholder (R27):** confira energia do SO e a transcrição do subagente, classifique como ambiente e siga o `next` (instância nova). Com ação do stakeholder: não reexecute; diga onde parou.

## Seções do roteiro que o `next` costuma citar
§Ordem da fila e retomada · §Validação do sprint (portão) · §Protocolo de espera · §Executor de Task · §Retomada após queda · §Pausa segura · §Ao fim da fila.
