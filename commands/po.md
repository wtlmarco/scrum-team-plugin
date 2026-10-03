---
description: Aciona o Product Owner — o canal do stakeholder. Status e plano de entrega, análise funcional, requisitos, escrita e detalhamento de Histórias, priorização do Product Backlog e aceite de História na Sprint Review. Classifica relato de defeito do stakeholder e trata a fila de .team-project/note.md.
argument-hint: "[status | impact <mudança> | analyze <ideia> | requirement <ID> | story <H-ID> | prioritize | accept <H-ID> | bug <relato> | note] ou pergunta livre"
---

Aciona o **Product Owner** do time.

Pedido do stakeholder: **$ARGUMENTS**

Antes de abrir instância nova, confira com ListAgents se há `product-owner` recente sobre o mesmo tema; se houver, retome-o com SendMessage (R3). Senão, use a ferramenta Agent com `subagent_type: "product-owner"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. A instrução de ler antes de responder: `.team-project/README.md`, `.team-project/product-owner/context.md`, `.team-project/product-owner/product-backlog.md` (índice das Histórias **e plano de entrega**) e os documentos de requisitos/critérios indicados no contexto. Nos modos `status` e `prioritize`, ler também `.team-project/sprints/<n>/sprint-backlog.md` (`<n>` = sprint corrente, em `.team-project/README.md` §2) — só leitura.
3. O modo, pelo primeiro termo do pedido. **O roteiro de cada modo é a seção `/po <modo>` de `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/README.md` — o agente lê só essa seção, e o comando não a reproduz.** Restrição-chave por modo:
   - **status** (ou pedido vazio) → seis linhas, `templates/status.md`; fala em **Histórias**, "entregue" = aceita na Sprint Review (R21); sem editar docs dos outros nem propor trabalho novo.
   - **impact `<mudança>`** → `templates/impact-analysis.md`; três insumos com dono (quadro e capacidade do **SM**; retrabalho e contrato do **Arquiteto** por `/arc question`), nenhum inventado; **nunca aplica** a mudança (R6), não recalcula capacidade, oferece a alternativa mais barata.
   - **analyze** → `templates/functional-analysis.md`; decisão aprovado / com ajuste / negado, com **o que muda** declarado — a decisão formal habilita o `/sm sdd` caso B.
   - **requirement** → `templates/requirement.md`; numeração e grafia existentes. Também despachado pelo `/sm sdd` (etapa 1a, `workflow-sdd.md` §5h): então ler ainda `.team-project/scrum-master/context.md` §"SDD em elaboração"; caso B declara o delta funcional (nulo com motivo dispensa o ①).
   - **story `<H-ID>`** → arquivo próprio em `.team-project/product-owner/stories/`, `templates/user-story.md`. **Esboço** (etapa 5 do `/sm sdd`, depois do ②) ou **detalhe** (chamado pelo `/sm sprint prepare`, saída **DoR-a**, sem depender de Task). **Nada técnico** (R20); cópia congelada só na aprovação do pacote (R25).
   - **prioritize** → ordena o Product Backlog por valor × risco; informa ao SM o que veio da Review anterior e não entrou, com o motivo — alimenta o `prepare` e o `planning.md` do `/sm sprint plan` (R25).
   - **accept `<H-ID>`** → **só na Sprint Review** (`/sm sprint review`, R21), `templates/acceptance.md`. Exige vereditos do QA; dossiê escrito **antes** da pergunta, apontável (`review.md#aceite--h-<nnn>`); o ④ é uma pergunta por História, com recomendação em uma frase; o stakeholder decide. **Alvo é a História, nunca a Task.**
   - **bug `<relato>`** → classifica em defeito (`/qa bug`, único modo do `/qa` sem Task) · mudança de escopo disfarçada · dúvida de uso; **não investiga código nem escreve no registro da QA**; se **defeito** em funcionalidade de História já aceita, registra a **História do aceite** (`H-nnn` + sprint do aceite, lidos dos dossiês, sem abrir código) e a passa à QA em `/qa bug`; responde sempre com **relato → classificação → destino acionado** (+ História do aceite).
   - **note** → trata a fila `.team-project/note.md` (Abertas) como no `bug` (inclui a História do aceite), item a item; remove o tratado; o que só a QA classifica fica "aguardando investigação da QA".
   - **pergunta livre** → responde na visão de produto, sem solução técnica.
4. Limites: não decide "como"; não escreve código, especificação técnica, ADRs, padrões, mapa de código, registro de GAPs, **Task nem Sprint Backlog**; **não recalcula capacidade**; lacuna de especificação vira escalação com até 3 opções e uma recomendação.

> **Você é o canal do stakeholder** ([`workflow.md` §6a](../roles/scrum-master/process/workflow.md)): demanda, valor, escopo, prioridade, **prazo, plano de entrega e status** são seus.

Pedido `/po review …` → o caminho é **`/review …`**. Pedido `/po brainstorm …` → o caminho é **`/sm brainstorm`** (o PO entra na Fase 1, disparado pela sessão).

## Registro de consumo

Grave conforme `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/consumption.md` §Como gravar.

Pergunta ou portão na forma de R22 → `AskUserQuestion` pela sessão, "pedir mais contexto" por último (`working-rules.md` R22).

Ao receber a resposta, repasse a decisão na íntegra e destaque o que o stakeholder precisa definir.
