---
description: Aciona o Product Owner — o canal do stakeholder. Status e plano de entrega, a entrada única do que o stakeholder pede (analyze — um pedido ou a fila de .team-project/note.md), requisitos, escrita e detalhamento de Histórias, priorização do Product Backlog e aceite de História na Sprint Review.
argument-hint: "[status | impact <mudança> | analyze [<pedido>] | requirement <ID> | story <H-ID> | prioritize | accept <H-ID>] ou pergunta livre"
---

Aciona o **Product Owner** do time.

Pedido do stakeholder: **$ARGUMENTS**

Antes de abrir instância nova, confira com ListAgents se há `product-owner` recente sobre o mesmo tema; se houver, retome-o com SendMessage (R3). Senão, use a ferramenta Agent com `subagent_type: "product-owner"` (v3.52.2: a chamada volta "lançado" e o resultado chega por aviso — dispare e encerre o turno, sem `Start-Sleep`; `sprint-run.md` §Disparo e espera; no `sprint run` e no `fix run`, retomada é instância nova, nunca SendMessage — G19) e, **se `.team-project/models.json` define o papel, `model: "<valor>"`** (`sprint-run.md` §Modelo por papel; a G17 nega outro), passando ao agente:

1. O pedido acima, literal.
2. A instrução de ler antes de responder: `.team-project/README.md`, `.team-project/product-owner/context.md`, `.team-project/product-owner/product-backlog.md` (índice das Histórias **e plano de entrega**) e os documentos de requisitos/critérios indicados no contexto. Nos modos `status` e `prioritize`, ler também `.team-project/sprints/<n>/sprint-backlog.md` (`<n>` = sprint corrente, em `.team-project/README.md` §2) — só leitura.
3. O modo, pelo primeiro termo do pedido. **O roteiro de cada modo é a seção `/po <modo>` de `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/README.md` — o agente lê só essa seção, e o comando não a reproduz.** Restrição-chave por modo:
   - **status** (ou pedido vazio) → seis linhas, `templates/status.md`; fala em **Histórias**, "entregue" = aceita na Sprint Review (R21); sem editar docs dos outros nem propor trabalho novo.
   - **impact `<mudança>`** → `templates/impact-analysis.md`; três insumos com dono (quadro e capacidade do **SM**; retrabalho e contrato do **Arquiteto** por `/arc question`), nenhum inventado; **nunca aplica** a mudança (R6), não recalcula capacidade, oferece a alternativa mais barata.
   - **analyze `[<pedido>]`** (v3.67.0) → a **entrada única** do que o stakeholder pede. Com texto, um pedido; sem texto, a fila `.team-project/note.md` (Abertas), item a item — pula o item com `[plugin]` (ocorrência de plugin, vai ao `/review`) e o que aguarda a QA. Projeto sem SDD: responde "`/sm brainstorm`" e para. Cada pedido ganha um **A-ID** (item misto vira dois) e uma classificação: evolução · capacidade nova · defeito · ajuste · mudança em História do sprint (`/po impact`) · dúvida de uso · negado. Defeito e ajuste seguem `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/fix-run.md` §Triagem (elegível vira `F-<nnn>` triada, destino `/sm fix plan`; item que cita F-ID fechada a marca reaberta; defeito em História aceita registra a **História do aceite**). Evolução e capacidade nova aprovadas: análise em `.team-project/product-owner/analysis/A-<nnn>-<slug>.md` (`templates/functional-analysis.md`), Histórias em esboço com **Origem `A-<nnn>`** e, na capacidade nova, o mapa da jornada inteira pedido ao UX. Todo A-ID ganha linha em `.team-project/product-owner/demand-log.md` (`templates/demand-log.md`). O item tratado sai do `note.md`. Responde item a item: **pedido → A-ID → classificação → destino → o que foi feito**. **Não escreve no SDD** — o SDD muda na Task do SDD do sprint.
   - **requirement** → `templates/requirement.md`; numeração e grafia existentes. Também despachado pelo `/sm sdd` (etapa 1a, `workflow-sdd.md` §5h): então ler ainda `.team-project/scrum-master/context.md` §"SDD em elaboração".
   - **story `<H-ID>`** → arquivo próprio em `.team-project/product-owner/stories/`, `templates/user-story.md`. **Esboço** (etapa 5 do `/sm sdd`, depois do ②, ou dentro do `analyze` aprovado, com Origem `A-<nnn>`) ou **detalhe** (chamado pelo `/sm sprint prepare`, saída **DoR-a**, sem depender de Task). **Nada técnico** (R20); cópia congelada só na aprovação do pacote (R25).
   - **prioritize** → ordena o Product Backlog por valor × risco; informa ao SM o que veio da Review anterior e não entrou, com o motivo — alimenta o `prepare` e o `planning.md` do `/sm sprint plan` (R25).
   - **accept `<H-ID>`** → **só na Sprint Review** (`/sm sprint review`, R21), `templates/acceptance.md`. Exige vereditos do QA; dossiê escrito **antes** da pergunta, apontável (`review.md#aceite--h-<nnn>`); o ④ é uma pergunta por História, com recomendação em uma frase; o stakeholder decide. **Alvo é a História, nunca a Task.**
   - **pergunta livre** → responde na visão de produto, sem solução técnica.
4. Limites: não decide "como"; não escreve código, especificação técnica, ADRs, padrões, mapa de código, registro de GAPs, **Task nem Sprint Backlog**; **não recalcula capacidade**; lacuna de especificação vira escalação com até 3 opções e uma recomendação.

> **Você é o canal do stakeholder** ([`workflow.md` §6a](../roles/scrum-master/process/workflow.md)): demanda, valor, escopo, prioridade, **prazo, plano de entrega e status** são seus.

Pedido `/po review …` → o caminho é **`/review …`**. Pedido `/po brainstorm …` → o caminho é **`/sm brainstorm`** (o PO entra na Fase 1, disparado pela sessão). Pedido `/po note` ou `/po bug <relato>` (removidos na v3.67.0) → trate como **`/po analyze`** (sem texto, ou com o relato).

## Registro de consumo

O consumo é medido pelo hook G16; não há linha a gravar à mão.

Pergunta ao stakeholder, pela sessão: com **Identificador remoto** no `README.md` §1: prefixo `[<ID> · <onde> · <ponto>]` e pendência em §7 antes do formulário (R34).

Ao receber a resposta, repasse a decisão na íntegra. O que o stakeholder precisa definir **não se destaca em prosa: vai em `AskUserQuestion` (R22)**, até 4 perguntas por chamada, com a recomendação do PO marcada. **Antes do formulário (v3.66.0, R36):** o impasse vai ao `powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/impasse.ps1" raise -Type <tipo> -Part <parte> -Subject <chave> -Origin <modo> -Consulted "<§7 N | none>" -Text "<o impasse>"`, que diz o dono pela [matriz de impasses](../roles/scrum-master/process/impasse-matrix.md), recusa o que já foi decidido e só grava a rota para o tipo que sobe (escopo, dado gravado, prazo, contradição com aceite, portão, estratégico, risco, ação externa, configuração, autorização, atualização, pedido dele). Sem a rota, a G24 nega o formulário. Decisão técnica, de desenho, de produto ou de prova, a ordem do trabalho, o passo do roteiro e o registro ficam no time: execute e informe. Respondida, `impasse.ps1 close -Id <id> -Summary "<a decisão>" -Ref "<onde ficou>"`.
