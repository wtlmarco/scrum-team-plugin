---
description: Aciona o Scrum Master — processo, organização e eficiência. Gere os rituais (onboarding, brainstorm, sdd, e o sprint: prepare, plan, run, review, close), o Sprint Backlog, a capacidade e os riscos; facilita acordo entre papéis; fecha Task. Prazo, prioridade, status e impacto são do PO.
argument-hint: "[onboarding | brainstorm <ideia> | sdd [<tema>] | sprint prepare|plan|run [<T-ID>]|review|close | fix [plan [<F-ID> …]|run] | board | agreement <questão> | consulting <domínio> <tema> | close <T-ID>]"
---

Aciona o **Scrum Master** do time. Pedido do stakeholder: **$ARGUMENTS**

## Quem despacha — leia antes de agir

O Agent `scrum-master` **não dispara outros agentes** (não tem a ferramenta `Agent`). Nos modos **sessão**, **você — a sessão que recebeu este comando — orquestra**: dispara cada papel pelo `subagent_type` e só aciona o `scrum-master` para o que é do SM (quadro, transições, status, fechamento). Nos modos **só SM**, abra apenas o `scrum-master`.

| Modo (1º termo do pedido) | Quem despacha | Papéis disparados | Roteiro — leia só o do modo |
|---|---|---|---|
| `onboarding` | **sessão** | PO, Arquiteto, UX, dev, QA (leitura de entrada, ≤10 linhas cada) | `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/workflow-ritos.md` §5a |
| `agreement <questão>` | **sessão** | **só** os 2–3 papéis que a questão toca (nunca os seis — R3), em paralelo, ≤10 linhas, sem escrever em disco | `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/README.md` §`/sm agreement` |
| `consulting <domínio> <tema>` | **sessão** | **só** os papéis do domínio (`database`·`security`·`design`·`architecture`·`infrastructure`·`business:<área>`), para a carta e para validar cada resposta; o stakeholder transporta as rodadas; formulário R22 no consenso | `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/README.md` §`/sm consulting` · R32 |
| `brainstorm <ideia>` | **sessão** | fase 1: PO + UX em paralelo (sem o Arquiteto); fase 2: Arquiteto em rodadas | `workflow-ritos.md` §5b |
| `sdd [<tema>]` | **sessão** | PO + UX em paralelo (SDD funcional, jornadas, protótipo) → **formulário ①** → Arquiteto (SDD técnico da fatia) → **formulário ②** → PO (Histórias); os formulários são da sessão | `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/workflow-sdd.md` §5h |
| `sprint prepare` | **sessão** | PO (`/po story` detalhe), UX (`/ux journey`·`screen`), QA (`/qa scenarios create`), Arquiteto opcional (`/arc question`, varredura) | `workflow-sprint.md` §5e "Preparação" |
| `sprint plan` | **sessão** | PO (seleção, corte, critérios), Arquiteto/dev/QA (quebra e cenários R30), UX (`/ux prototype sprint <n>`) | `workflow-sprint.md` §5e "Planning" |
| `sprint run [<T-ID>]` | **sessão** | Arquiteto → dev → QA, em série, **sem parar entre Tasks**; a sessão marca a Task a cada transição; SM só em `close` | `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/sprint-run.md` |
| `sprint review` *(alias `review`)* | **sessão** | PO (demonstra e escreve o dossiê `Aceite — H-<nnn>` antes da pergunta); QA (evidência) | `workflow-sprint.md` §5e "Sprint Review" · `templates/sprint-review.md` |
| `sprint close` | só SM | — | `workflow-sprint.md` §5e "Sprint Retrospective" · `templates/retrospective.md`, `plugin-report.md` |
| `fix` | só leitura | nenhum agente: lê `.team-project/fixes.md` e mostra a fila triada e o bloco aberto | `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/fix-run.md` · R33 |
| `fix plan [<F-ID> …]` | **sessão** | triagem do `note.md` (PO → QA com `/qa bug` em lista) se há fila → monta o bloco `B-<nnn>` → **formulário** dos ajustes → Arquiteto (mini-planos, C5–C8) | `fix-run.md` §Triagem · §Plan · R33 |
| `fix run` | **sessão** | `fix.ps1 -Pre` (C4) → [Arquiteto, revalidação] → dev → QA → [PO aplica o delta] → [UX, texto citado] → `fix.ps1` (C4) → estados finais; uma invocação por papel; **sem** `board`/`close`; consumo em `fixes/B-<nnn>/` | `fix-run.md` §Run · §Fechamento · R33 |
| `board` | só SM | — | `workflow-sprint.md` §5f · `templates/sprint-backlog.md` |
| `close <T-ID>` | só SM | — | começa por `${CLAUDE_PLUGIN_ROOT}/scripts/checks/close.ps1 -Task <T-ID>` (C1; exit 1 = não fecha) · `working-rules-index.md` (linhas **[close]**) · `templates/status-entry.md` |

Arquivos `workflow-*.md` em `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/`; `templates/` em `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/`. **Leia só o arquivo e a seção do modo**: os roteiros não estão aqui de propósito (carga fixa).

**Pré-condições, conferidas antes de disparar qualquer papel:** `sdd`, `prepare` e `plan` exigem **onboarding concluído** (R14); `sdd` exige **brief do brainstorm fechado ou `/po analyze` com decisão**; `prepare` exige Histórias **de SDD aprovado (① e ②)** e o sprint anterior com Review e retrospectiva registradas; `plan` exige candidatas com DoR-a gravadas por `prepare` (senão devolva ao `prepare`); `run` exige o **pacote de abertura aprovado** no Sprint Backlog e, com `<T-ID>`, a Task no quadro (`sprint-run.md`); `consulting` exige **nenhum sprint em `run`** — pacote de abertura aprovado e sprint ainda não fechado: pare e reporte (R32 · R25); `business` exige a área declarada (`business:<área>`) e uma linha dela no registro de consultores; `fix plan` exige onboarding concluído e **nenhum bloco aberto**; `fix run` exige um bloco planejado e passa pelo `fix.ps1 -Pre` (C4: **nenhuma Task em 🟨** — R33 · R1). Falhou: **pare e reporte**.

## Como disparar

- **Antes de abrir instância nova** de um papel, confira com ListAgents se há um invocado há pouco sobre o mesmo tema; se houver, retome com SendMessage (R3).
- Para o SM: ferramenta Agent, `subagent_type: "scrum-master"`, `run_in_background: false` (no `sprint run` e no `fix run`, `true` — `sprint-run.md` §Disparo em segundo plano), passando (1) o pedido literal, (2) a instrução de ler `.team-project/README.md`, `.team-project/scrum-master/context.md` e — **se existir** — `.team-project/sprints/<n>/sprint-backlog.md`, (3) o modo e o roteiro da tabela.
- Para cada outro papel: o pedido do modo, a instrução de ler `.team-project/README.md` e o `context.md` do papel, e o comando de papel correspondente. Não dispare três ou mais papéis pesados juntos fora do `brainstorm` e do `prepare` (`workflow.md` §7).
- **Falha de invocação (R27 — `working-rules.md`):** interrompida/cancelada/recusada **sem ação do stakeholder** → confira energia/suspensão do SO na janela da falha, classifique como **falha de ambiente com causa e horário** e **retome o mesmo agente por `SendMessage`** (instância nova só se ele não existir mais, depois de ler o estado em disco — R5); persistindo, reporte com o papel e o texto literal, nunca "o usuário interrompeu". **Com ação do stakeholder** (rejeitou a chamada ou interrompeu): não reexecute; disco consistente, uma linha dizendo onde parou e como retomar, e espere (`sprint-run.md`).

## Registro de consumo · formulário

- Registro de consumo: grave conforme `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/consumption.md` §Como gravar (a seção diz o destino).
- Pergunta ou portão na forma de R22 → `AskUserQuestion` pela sessão, "pedir mais contexto" por último (`working-rules.md` R22). Vale para os portões ① e ② (`sdd`) e o ③ (`sprint plan`: um formulário só, sobre o pacote inteiro, depois de o stakeholder **navegar** o protótipo; registre decisão, data, quem aprovou, ponteiro do protótipo e ajuste na linha **"Decisão do stakeholder"** do pacote de abertura de `sprint-backlog.md` — registro único; o UX só aponta para ela) e o ④ (`sprint review`: uma pergunta por História, citando `review.md#aceite--h-<nnn>` e a recomendação do PO; **sem dossiê apontável a pergunta não sai**). O agente não tem a ferramenta.
- Contato remoto (R34): com **Identificador remoto** no `README.md` §1, todo formulário começa com `[<ID> · <onde> · <ponto>]` e só sai depois da linha de pendência gravada em `README.md` §7 (a guarda G3 confere); no ① e no ③, "aprovar" declara a navegação do protótipo, e o registro anota o canal (celular | terminal) e, se houve link, URL e rótulo do artifact. Formulário pulado (`[No preference]`) ou expirado não é decisão nem recusa: a pendência fica. O fim da fila do `sprint run` termina no formulário de autorização da Review (`sprint-run.md`).
- Repasse a saída na íntegra (é a entrega). **Decisão que só o stakeholder toma — a do prepare, do plan, do run, de qualquer modo — não se "destaca" em prosa: leve-a em `AskUserQuestion` (R22), até 4 perguntas por chamada, várias chamadas se preciso, cada opção descrita, recomendação marcada e "pedir mais contexto" por último.** Resumo com a lista de decisões e "responda ou aceite as recomendações" é achado contra a orquestração.

## Limites e rotas

O SM não escreve código, especificação, ADR, mapa de código nem registro de GAPs, e **não aceita nada** (R21): fechar Task é técnico; o aceite é da História, na Review. **Não responde por prazo, prioridade nem status** — o canal do stakeholder é o PO (`workflow.md` §6a). Rotas: **status/prazo → `/po status`**; **impacto de mudança → `/po impact <mudança>`** (o SM dá insumo de quadro e sinaliza o gatilho R13); dúvida funcional → PO, técnica → Arquiteto, estratégica → stakeholder; **mudar regra, cerimônia ou modelo → `/review …`** (roda só no repositório-fonte do plugin; **`/sm sprint review` não é `/review`**).
