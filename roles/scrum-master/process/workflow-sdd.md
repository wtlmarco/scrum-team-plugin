# Fluxo de Trabalho — Transição para o SDD (§5h · `/sm sdd`)

> **Dono:** SM · Parte do fluxo — o núcleo está em [`workflow.md`](workflow.md). **Lido só** em `/sm sdd`. Sequência de [`workflow-ritos.md` §5b](workflow-ritos.md) (brainstorm) e antecede [`workflow-sprint.md` §5e](workflow-sprint.md) "Preparação". Regras: R14, R15, R12, R22 (v3.34).

## §5h. `/sm sdd [<tema>]` — do brief ao SDD aprovado e às Histórias

Cadência completa: `brainstorm → sdd → sprint prepare → plan → run → review → close`. O `sdd` **substitui a sequência manual** (`/po requirement` → `/ux prototype` → ① → `/arc` → ② → `/po story`): uma invocação conduz a transição inteira, e **os formulários dos portões ① e ② são disparados por ela mesma** — não por "a sessão que orquestrou o comando anterior".

**Quem executa.** A **sessão** orquestra: dispara PO, UX e Arquiteto diretamente e só aciona o Agent `scrum-master` para registrar o estado (`context.md`). O SM **não escreve conteúdo** de nenhum documento do SDD.

### Alcance — dois casos, mesmo modo

| Caso | Entrada (pré-condição) | O que o modo faz |
|---|---|---|
| **A · ideia nova** | **brief do brainstorm fechado** (critério de convergência de [`workflow-ritos.md` §5b](workflow-ritos.md) cumprido, fronteira da primeira fatia escrita) | elabora o SDD da **primeira fatia**, inteiro |
| **B · evolução de área já documentada** | **`/po analyze <ideia>` com decisão formal** (o PO declarou o que muda) | atualiza **só as seções afetadas** do SDD e passa pelos portões **só no que mudou** |

Ambos exigem **onboarding concluído** (R14). Sem A nem B, **pare e reporte** — a rota é `/sm brainstorm` (ideia sem cobertura) ou `/po analyze` (área documentada). O `sdd` **não decide** qual dos dois é: o SM lê o registro (abaixo) e o pedido; dúvida vira pergunta em formulário (R22).

### Estado e retomada — `.team-project/scrum-master/context.md` §"SDD em elaboração"

O brief do brainstorm é conversa (R15); **para o `sdd` poder ser retomado em outra sessão**, o SM registra ali, na abertura: tema · caso (A/B) · origem (brainstorm fechado em <data> / `/po analyze` <ponteiro>) · o **brief funcional em até 15 linhas** (é o único lugar declarado onde ele vive — R15) · e uma linha por etapa (1–5) com estado (⬜ · 🟨 · ✅ · dispensada) e data. **Retomada:** o `sdd` entra na **primeira etapa não concluída**; parou no ① (protótipo pronto, decisão pendente), retoma **no ①** — reabre a navegação e o formulário, não refaz o protótipo. Etapa ✅ **nunca é reescrita**; se um documento aprovado mudou depois (ex.: `03` alterado depois do ②), o portão afetado **reabre**.

### Etapas, quem é despachado

| # | Etapa | Despachado | Saída |
|---|---|---|---|
| 0 | Conferir a entrada (A ou B) e abrir a seção "SDD em elaboração" | `scrum-master` (registro) | estado aberto |
| 1a | **SDD funcional** — `00-overview-objectives`, `01-requirements` (critério de aceite + como verificar), `02-flows-and-roles`, início do `06-changelog`, índice do SDD | **PO** (`/po requirement <ID>` por requisito) — **em paralelo** com 1b (jornadas) | SDD funcional (no caso B: só as seções afetadas, delta declarado no `06-changelog`) |
| 1b | **Jornadas** das jornadas moldadas | **UX** (`/ux journey <fluxo>`) | mapas de jornada |
| 1c | **Protótipo funcional em HTML** — todo fluxo principal de `02-flows-and-roles`, estados de exceção e "fora" declarado (depois de o `02` existir) | **UX** (`/ux prototype`) | protótipo funcional + ficha (caso B: só os fluxos afetados) |
| 2 | **Portão ①** — o stakeholder **navega** o protótipo (fora do formulário); depois a **sessão dispara o formulário** (aprovar · aprovar com ajuste · reprovar · pedir mais contexto — R22). Decisão e ajuste ficam **na ficha do protótipo funcional** (registro único do ①); o SM só aponta para ela em `context.md` | sessão · stakeholder | ① aprovado e datado. Reprovado/ajuste: volta à etapa 1 **só no afetado** |
| 3 | **SDD técnico da fatia** — `03-architecture` (incl. Ficha de Vinculação de Stack), `04-data-model`, `05-api-model`, **só as partes da primeira fatia** (caso B: só o delta). **Nada disto é escrito antes do ①** | **Arquiteto** (`/arc` em modo livre) | SDD técnico da fatia, com a declaração de construtibilidade |
| 4 | **Portão ②** — a **sessão dispara o formulário** (o Arquiteto entrega a estrutura pronta; não tem a ferramenta). Decisão, data e ajuste ficam em `context.md` §"SDD em elaboração" (registro único do ②) (a versão aprovada entra no `06-changelog` na etapa 5, pelo PO) | sessão · stakeholder | ② aprovado e datado |
| 5 | **Só começa depois do ② registrado** (ou dispensado, com o delta nulo e o motivo). O PO **primeiro** registra a **versão aprovada no `06-changelog`** (versão, data, dispensa com motivo) e atualiza o índice do SDD (R12); **depois** cria as **Histórias** a partir dos requisitos aprovados — arquivo próprio + linha no índice do Product Backlog, com o **valor declarado** (esboço) | **PO** (`/po story <ID>` modo esboço) | versão aprovada no `06-changelog` e Histórias no Product Backlog, **prontas para o `prepare`** |

**Portões só se decidem dentro do `sdd`.** O estado do SDD (etapas, brief, decisão do ②) vive em `context.md`; por isso `/ux prototype` ou `/arc` **avulsos** (exploração, conversa, calibração) **não abrem nem fecham** o ① ou o ②: a navegação e a ficha podem existir, mas a **decisão fica pendente** até o `sdd` disparar o formulário. Vale igual para UX e Arquiteto.

**Portão sem delta (caso B).** Se o PO declara, na etapa 1a, que **não há mudança funcional** (a evolução é só técnica), o ① é **dispensado com o motivo registrado**; se o Arquiteto declara, na etapa 3, que **não há mudança em `03`/`04`/`05`**, o ② é dispensado idem. **Dispensa exige delta nulo declarado pelo dono — nunca conveniência** (R15: os portões não se negociam; o que se dispensa é aprovar o que não mudou).

### Saída

SDD funcional e técnico da fatia **aprovados (① e ②) e datados**, versão aprovada registrada no `06-changelog` e índice do SDD atualizado (R12), Histórias no Product Backlog, seção "SDD em elaboração" ✅. Próximo passo: `/sm sprint prepare`.

### O que o `sdd` não faz

Não **detalha** História para sprint (regras, critérios, especificação de tela, cenários — é o `prepare`); não faz `screen` nem `prototype sprint`; não estima nem planeja (`plan`); não substitui o `/po analyze` no caso B (a decisão formal vem antes); não escreve conteúdo do SDD (o SM orquestra e registra); não abre `sprints/<n>/`.

### Consumo e operator

Roda **antes** de existir sprint (ou com o anterior fechado): as linhas de consumo dos subagentes vão para `context.md`, subseção **"Consumo pré-sprint (prepare · sdd)"** (a mesma do `prepare`, dentro de §"Candidatas do próximo sprint"), e são transcritas no passo 9 da Planning com Nota `pre-sprint;` ([`templates/consumption.md`](../templates/consumption.md) §Como gravar). Job do `operator` no `sdd` (harness do protótipo do ①, spike do ②) vai para `.team-project/operator/pre-sprint/` (R28).

### Como o SM verifica

- **Nenhum `03`/`04`/`05` datado antes do registro do ①, nenhuma História datada antes do registro do ②** — ou a dispensa do portão, com o delta nulo declarado pelo dono e o motivo (R15).
- O ① tem a ficha do protótipo com navegação datada e a decisão; o ② tem a decisão em `context.md`; nenhum dos dois chegou em texto corrido (R22).
- `00`/`01`/`02` + índice do SDD criados/atualizados pelo PO **no mesmo ciclo** (R12), e a versão aprovada no `06-changelog` **antes** da primeira História (etapa 5); protótipo cobre todo fluxo principal de `02` (caso A) ou todo fluxo afetado (caso B).
- Todo `sprint prepare` cita Histórias **vindas de SDD aprovado (① e ②)** — ver [`workflow-sprint.md` §5e](workflow-sprint.md).
- O brief só vive em `context.md` §"SDD em elaboração" e não vira outro arquivo (R15).
