# Template — Contexto do Projeto (`.team-project/`)

Este é o modelo do **diretório de contexto** que o time lê para trabalhar num projeto concreto. O plugin `team` é agnóstico; sem este diretório, nenhum papel opera.

## Estrutura a criar

```
.team-project/
├── README.md                 ← este modelo · declara o SPRINT CORRENTE (§2)
├── how-to.md                 cópia de `${CLAUDE_PLUGIN_ROOT}/how-to.md` — guia de uso, não editar aqui
├── note.md                   fila de relatos do stakeholder — escrita por ele, tratada pelo PO via `/po note`
├── sprints/                  registro de execução, um subdiretório por sprint
│   └── <n>/                  planning.md · sprint-backlog.md · stories/ · plan/ · evidence/
│                             consumption.md · burndown.md · review.md · retrospective.md
├── scrum-master/             context.md
├── product-owner/            context.md · product-backlog.md
├── architect/                context.md · spikes/
├── user-experience/          context.md · prototype/ (+ prototype/sprint-<n>/) · journeys/ · screens/
├── developer/                context.md
└── quality-assurance/        context.md · baseline.md
```

> As pastas de papel usam o **nome completo do papel**, igual a `${CLAUDE_PLUGIN_ROOT}/roles/`. **`sprints/` não é pasta de papel:** o registro de execução é organizado **por sprint**, porque contém artefatos de quatro donos — Histórias (PO), planos (Arquiteto), evidências (QA) e os documentos do SM. O **dono de cada subpasta** está declarado em [`artifact-ownership.md` §1e](../process/artifact-ownership.md); pasta com dono ambíguo é achado de auditoria.

**O que fica FORA de `sprints/<n>/`, e por quê:** registro de GAPs, mapa de código, **baseline de verificação** (nasce antes do sprint 1), Product Backlog, SDD, ADRs, protótipo funcional do ①, **protótipo do sprint** (é do UX; o quadro guarda o ponteiro) e **checkpoints de spike** — todos **somam, evoluem ou nascem fora** do recorte de um sprint, e fatiá-los quebraria a leitura que o time faz deles (§1c · §1e).

| Arquivo | Modelo de origem |
|---|---|
| `README.md` | este documento |
| `how-to.md` | cópia literal de `${CLAUDE_PLUGIN_ROOT}/how-to.md` |
| `note.md` | `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/note.md` *(fila de relatos do stakeholder, tratada por `/po note`/`/po bug`)* |
| `sprints/<n>/planning.md` | `templates/planning.md` — **SM** *(decisões da Planning + o que não entrou, com o motivo — R25)* |
| `sprints/<n>/sprint-backlog.md` | `templates/sprint-backlog.md` — **SM** *(vivo no sprint, com o pacote de abertura e o Registro de transições — R24; fecha no `/sm sprint close`, sem cópia)* |
| `sprints/<n>/stories/` | `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/user-story.md` — **PO** *(uma História por arquivo, congelada na aprovação do pacote)* |
| `sprints/<n>/plan/` | `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/implementation-plan.md` — **Arquiteto** *(um plano por Task)* |
| `sprints/<n>/evidence/` | `${CLAUDE_PLUGIN_ROOT}/roles/quality-assurance/templates/evidence.md` — **QA** *(evidência por Task do sprint)* |
| `sprints/<n>/consumption.md` | `templates/consumption.md` — **SM** *(uma linha por invocação; nasce e fecha no sprint — §1c)* |
| `sprints/<n>/burndown.md` | `templates/burndown.md` — **SM** *(dia 0 = aprovação do pacote)* |
| `sprints/<n>/review.md` · `retrospective.md` | `templates/sprint-review.md` · `templates/retrospective.md` — **SM** |
| `product-owner/product-backlog.md` | `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/product-backlog.md` *(o índice ordenado das Histórias, com ponteiro para o arquivo de cada uma — v3.21)* |
| `product-owner/stories/` | pasta vazia; cada História nasce de `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/user-story.md`, um arquivo por História (`<H-ID>-<slug>.md`) — a fonte **viva**; `sprints/<n>/stories/` é a cópia congelada do que foi aprovado |
| `quality-assurance/baseline.md` | `${CLAUDE_PLUGIN_ROOT}/roles/quality-assurance/templates/evidence.md` *(linha de base do `/qa baseline`; nasce no onboarding, antes do sprint 1)* |
| `architect/spikes/` | pasta vazia; os checkpoints de spike nascem fora do recorte do sprint (§1c) |
| `user-experience/prototype/` | pasta vazia; o **protótipo funcional em HTML** nasce de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/functional-prototype.md` — entregável e pré-condição do portão ①. O **protótipo navegável de cada sprint** (R25) também vive aqui, em `prototype/sprint-<n>/`, preservado por sprint; o Sprint Backlog carrega só o ponteiro |
| `user-experience/journeys/` · `screens/` | pastas vazias; nascem dos modelos de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/` |
| `<papel>/context.md` | ver "O que vai em cada context.md", abaixo |

> Os modelos sem caminho completo acima vivem em `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/`.

## Modelo do `README.md`

```markdown
# Contexto do Projeto — <nome>

> **O que é este diretório:** tudo que o time precisa saber sobre este projeto específico.
> O processo de trabalho é genérico e vive em `${CLAUDE_PLUGIN_ROOT}/`.
> **Contrato:** cada papel lê este README e o `context.md` da sua pasta antes de agir.

## 1. O produto
<O que é, para quem, e as propriedades transversais que valem para toda decisão.>

## 2. Situação atual
| | |
|---|---|
| **Estado** | <em construção / em manutenção / retomado após interrupção> |
| **Sprint corrente** | **<n>** — <objetivo em uma frase> · quadro vivo: `.team-project/sprints/<n>/sprint-backlog.md` |
| **Critérios de sucesso** | <n de m confirmados> |
| **Pendências abertas** | <contagem por criticidade> |
| **Leitura de uma frase** | <onde estão os buracos> |

## 2a. Cadência — respondida pelo stakeholder no onboarding (R14)
| | |
|---|---|
| **Duração do sprint** | <n dias / semanas — fixa; não muda dentro do sprint> |
| **Unidade de estimativa** | <sessões de trabalho / pontos / dias — usada pelo time na Planning> |
| **Capacidade do sprint** | <n na unidade acima — média entregue nos 3 sprints anteriores, não o desejo> |
| **Capacidade de dev** | <quantos desenvolvedores; com um só, o Sprint Backlog é fila (R1)> |

> **A linha "Sprint corrente" é obrigatória e é o único caminho para o quadro vivo.** Com o Sprint Backlog dentro de `sprints/<n>/`, o caminho deixa de ser fixo; todo agente já lê este README, então o custo é ~zero — mas sem esta linha ninguém acha o backlog. Atualizada pelo SM no `/sm sprint plan` (R25).

## 3. Stack
<Tecnologias e a árvore de diretórios do código.>

## 4. Fontes da verdade
| Documento | O que contém | Dono |
|---|---|---|
<Um por documento do projeto, com o papel responsável.>

**Regra de confiança:** <qual fonte vence quando duas divergem.>

**Regra de nascimento.** `01-scope-and-criteria`, `02-status`, `03-code-map` e `pending` não são semeados pelo `/team init` ([`deliverables/team-project/README.md`](../../../deliverables/team-project/README.md)) — nascem quando o projeto os exige (retomada, primeiro fechamento de Task, primeira auditoria). Documento que nasce entra nesta tabela na mesma sessão (R12), com o dono — nunca fica implícito.

## 5. Ambiente de verificação
<Shell, comandos de build/teste/lint/execução.>

### Limitações conhecidas — declarar sempre que impedirem a verificação
| Limitação | Efeito |
|---|---|

## 6. O que cada papel lê aqui
| Papel | Contexto | Artefatos vivos |
|---|---|---|

## 7. Decisões pendentes do stakeholder
1. <decisão> — destrava <o quê>.

## 8. Como usar o time neste projeto

| Comando | Modos |
|---|---|
| `/sm` | `onboarding` · `sprint plan` · `sprint close` · `review` · `board` · `agreement <questão>` · `close <T-ID>` |
| `/po` | `status` · `impact <mudança>` · `analyze <ideia>` · `requirement <ID>` · `story <H-ID>` · `prioritize` · `accept <H-ID>` · `bug <relato>` · `note` |
| `/arc` | `plan <T-ID>` · `comply <T-ID>` *(exceção pedida pelo stakeholder)* · `adr <tema>` · `question <dúvida>` |
| `/ux` | `prototype` · `journey <fluxo>` · `screen <nome>` · `prototype screen <tela>` · `review-ui <tela>` |
| `/dev` | `<T-ID>` · `resume <T-ID>` · `gap <resposta>` |
| `/qa` | `<T-ID>` · `baseline` · `audit` · `security <T-ID>` · `bug <descrição>` *(acionado pelo PO)* · `scenarios create` · `scenarios run <SC-nnn\|grupo\|all>` |
| `/team` | `init` · `update` · `brainstorm <ideia>` · `cycle <T-ID>` · `plan <T-ID>` · `build <T-ID>` · `qa <T-ID>` |

**O canal do stakeholder é o PO** — demanda, valor, escopo, prioridade, **prazo, plano de entrega e status**. Questão técnica vai ao **Arquiteto**, de tela ao **UX**, diretamente. O **SM não é canal de demanda**: é processo, organização e eficiência, gere os rituais e facilita acordo. **Não há broadcast** — `/team` orquestra o time trabalhando, não fala com os seis.

**`<H-ID>` é História (valor, dona: PO); `<T-ID>` é Task (trabalho, no Sprint Backlog).** Toda Task pertence a uma História (R20). O aceite é da História, na Sprint Review — `/sm close` fecha a Task tecnicamente e não aceita nada (R21).

**`/sm review` é a Sprint Review, neste projeto.** A evolução do processo do time é pelo comando **`/review`**, executado num clone do repositório-fonte do plugin — **não neste projeto**.

**Por onde começar**

| Situação | Sequência |
|---|---|
| **Projeto novo** | `/team brainstorm <ideia>` → `/po requirement <ID>` → `/ux prototype` → ① → ② → `/po story <H-ID>` → `/sm sprint plan` → ③ (pacote aprovado) → `/team cycle <T-ID>` → `/sm review` |
| **Projeto retomado** | `/sm onboarding` → `/qa audit` → `/qa baseline` → `/po story <H-ID>` → `/sm sprint plan` |
| **Bug** | Relatado pelo stakeholder: `/po bug <relato>` ou `.team-project/note.md` via `/po note` (PO classifica, aciona a QA se for defeito). Achado pelo time: direto no registro da QA (🔺 GAP do dev · achado próprio da QA · §6b para Arquiteto/UX), sem passar pelo PO. Dos dois: `/arc question <dúvida>` (diagnóstico, se a causa não é óbvia) → `/arc plan <T-ID>` → `/dev <T-ID>` → `/qa <T-ID>` → `/sm close <T-ID>` → aceite na `/sm review` |
| **Melhoria** | `/po analyze` (área já documentada) ou `/team brainstorm` (capacidade nova) → `/po impact` → `/po story` → `/sm sprint plan` → `/team cycle` |
| **Fim de sprint** | `/sm review` (PO conduz o aceite, o stakeholder decide por História) → `/sm sprint close` (retrospectiva) → `/sm sprint plan` (abre o próximo, e o ③ do próximo pacote) |

Achado do QA volta pelo **degrau certo**: correção local → `/dev resume <ID>` · atravessa papéis → o QA roteia pelo dono, ou `/sm agreement` · o desenho não sustenta o requisito → `/arc question` · a dúvida é o critério → `/po`.

Guia completo — instalação, atualização, os quatro caminhos em detalhe e as regras que valem sempre: [`how-to.md`](how-to.md), neste mesmo diretório (cópia do guia do plugin, atualizada pelo `/team init`). Para levar o time a outro projeto: `/team init`.
```

> **A seção 8 é fixa** — copie-a como está, é a mesma em todo projeto. O que muda de projeto para projeto são as seções 1 a 7. O guia completo não entra aqui: este `README.md` é lido pelos agentes em **toda** invocação, e documentação de uso nele é custo permanente.

## O que vai em cada `context.md`

| Papel | Conteúdo |
|---|---|
| **SM** | Fontes de estado e sua confiabilidade; artefatos que mantém; capacidade do time e unidade de estimativa; convenção de IDs; bloqueios e riscos abertos |
| **PO** | Cadeia funcional do produto; tipos de validação e contrato de erro; diferença entre declarado e real nos critérios; régua de priorização; nomenclatura; fora de escopo já decidido |
| **Arquiteto** | A stack como está montada de fato; as armadilhas do código (o que o compilador não cobra); princípios do produto; padrões aplicáveis e limiares; dívida arquitetural conhecida |
| **UX** | Situação da interface; inventário de rotas e componentes existentes; ambiente de protótipo; convenções visuais e de conteúdo; jornadas principais do produto; limitações para revisão |
| **Dev** | Onde está cada coisa; comandos; as armadilhas do projeto; convenções de teste; particularidades de framework |
| **QA** | Comandos de verificação e limiares; checklist de segurança do produto, com o histórico do que já falhou; documentos de qualidade que mantém; limitações do ambiente |

## Regras

- **O contexto é do projeto, o processo é do time.** Nada de regra de trabalho aqui; nada de nome de entidade do produto no `${CLAUDE_PLUGIN_ROOT}/`.
- **As armadilhas valem mais do que a descrição da stack.** "Handler novo exige registro manual, senão devolve 500" evita mais retrabalho do que três parágrafos de arquitetura.
- **Declare as limitações do ambiente.** É o que permite ao QA dizer "não exercitado" em vez de omitir.
- **Mantenha vivo.** Armadilha nova descoberta em um 🔺 GAP entra aqui no mesmo ciclo (R12).
