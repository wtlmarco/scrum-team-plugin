# Template — Contexto do Projeto (`.team-project/`)

Este é o modelo do **diretório de contexto** que o time lê para trabalhar num projeto concreto. O plugin `team` é agnóstico; sem este diretório, nenhum papel opera.

## Estrutura a criar

```
.team-project/
├── README.md                 ← este modelo
├── how-to.md                 cópia de `${CLAUDE_PLUGIN_ROOT}/how-to.md` — guia de uso, não editar aqui
├── scrum-master/             context.md · sprint-backlog.md
├── product-owner/            context.md · product-backlog.md
├── architect/                context.md · plans/
├── user-experience/          context.md · prototype/ · journeys/ · screens/
├── developer/                context.md
└── quality-assurance/        context.md · evidence.md
```

> As pastas usam o **nome completo do papel**, igual a `${CLAUDE_PLUGIN_ROOT}/roles/`.

| Arquivo | Modelo de origem |
|---|---|
| `README.md` | este documento |
| `how-to.md` | cópia literal de `${CLAUDE_PLUGIN_ROOT}/how-to.md` |
| `scrum-master/sprint-backlog.md` | `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/sprint-backlog.md` *(o Sprint Backlog)* |
| `product-owner/product-backlog.md` | `${CLAUDE_PLUGIN_ROOT}/roles/product-owner/templates/product-backlog.md` *(o conjunto das Histórias; cada uma segue `templates/user-story.md`)* |
| `quality-assurance/evidence.md` | `${CLAUDE_PLUGIN_ROOT}/roles/quality-assurance/templates/evidence.md` |
| `architect/plans/` | pasta vazia; os planos nascem de `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/implementation-plan.md` |
| `user-experience/prototype/` | pasta vazia; o **protótipo funcional em HTML** nasce de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/functional-prototype.md` — entregável e pré-condição do portão ① |
| `user-experience/journeys/` · `screens/` | pastas vazias; nascem dos modelos de `${CLAUDE_PLUGIN_ROOT}/roles/user-experience/templates/` |
| `<papel>/context.md` | ver "O que vai em cada context.md", abaixo |

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
| **Sprint corrente** | <n> — <objetivo em uma frase> |
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

## 3. Stack
<Tecnologias e a árvore de diretórios do código.>

## 4. Fontes da verdade
| Documento | O que contém | Dono |
|---|---|---|
<Um por documento do projeto, com o papel responsável.>

**Regra de confiança:** <qual fonte vence quando duas divergem.>

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
| `/sm` | `onboarding` · `status` · `sprint plan` · `sprint close` · `review` · `board` · `impact <mudança>` · `close <T-ID>` |
| `/po` | `analyze <ideia>` · `requirement <ID>` · `story <H-ID>` · `prioritize` · `accept <H-ID>` |
| `/arc` | `plan <T-ID>` · `comply <T-ID>` · `adr <tema>` · `question <dúvida>` |
| `/ux` | `prototype` · `journey <fluxo>` · `screen <nome>` · `prototype <tela>` · `review-ui <tela>` |
| `/dev` | `<T-ID>` · `resume <T-ID>` · `gap <resposta>` |
| `/qa` | `<T-ID>` · `baseline` · `audit` · `security <T-ID>` |
| `/team` | `init` · `update` · `<mensagem>` · `brainstorm <ideia>` · `agreement <questão>` · `cycle <T-ID>` · `plan <T-ID>` · `build <T-ID>` · `qa <T-ID>` |

**`<H-ID>` é História (valor, dona: PO); `<T-ID>` é Task (trabalho, no Sprint Backlog).** Toda Task pertence a uma História (R20). O aceite é da História, na Sprint Review — `/sm close` fecha a Task tecnicamente e não aceita nada (R21).

**`/sm review` é a Sprint Review, neste projeto.** A evolução do processo do time é pelo comando **`/review`**, executado num clone do repositório-fonte do plugin — **não neste projeto**.

**Por onde começar**

| Situação | Sequência |
|---|---|
| **Projeto novo** | `/team brainstorm <ideia>` → `/po requirement <ID>` → `/ux prototype` → ① → ② → `/po story <H-ID>` → ③ → `/sm sprint plan` → `/team cycle <T-ID>` → `/sm review` |
| **Projeto retomado** | `/sm onboarding` → `/qa audit` → `/qa baseline` → `/po story <H-ID>` → `/sm sprint plan` |
| **Bug** | `/arc question <dúvida>` (diagnóstico) → `/arc plan <T-ID>` → `/dev <T-ID>` → `/qa <T-ID>` → `/sm close <T-ID>` → aceite na `/sm review` |
| **Melhoria** | `/po analyze` (área já documentada) ou `/team brainstorm` (capacidade nova) → `/sm impact` → `/po story` → `/sm sprint plan` → `/team cycle` |
| **Fim de sprint** | `/sm review` (PO aceita as Histórias) → `/sm sprint close` (retrospectiva) → `/sm sprint plan` (abre o próximo) |

Achado do QA volta pelo **degrau certo**: correção local → `/dev resume <ID>` · atravessa papéis → `/team <questão>` · o desenho não sustenta o requisito → `/arc question` · a dúvida é o critério → `/po`.

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
