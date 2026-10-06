# Time Scrum — Plugin do Claude Code

> **Versão atual: v3.44.1** · o que entrou em cada entrega está em [`CHANGELOG.md`](CHANGELOG.md).
> Versionamento de **entrega** no padrão `vMAJOR.MINOR.PATCH`; cada entrega sai numa branch `fix/vX.Y.Z` ou `feat/vX.Y.Z` a partir de `develop` (ou empilhada sobre a entrega anterior), via PR para `develop` e aprovação. `main` recebe `develop` quando o stakeholder consolida a linha estável. O [changelog do processo](roles/scrum-master/process/process-changelog.md) (`vX.Y`) é outra coisa: registra a evolução interna das regras.

Este repositório **é o plugin**: um time Scrum completo — Scrum Master, Product Owner, Arquiteto, UX, Desenvolvedor e QA — que se instala em qualquer projeto para conduzir concepção, construção e manutenção.

É **genérico e reutilizável**: define **quem faz o quê**, **como cada papel trabalha**, **quais regras governam o time** e **quais modelos de documento cada papel usa** — sem uma linha sobre um produto específico.

O que é de um projeto concreto — produto, stack, comandos, quadro, backlog, planos, evidências — vive em **`.team-project/`**, **dentro do projeto onde o plugin foi instalado** — **local, fora do git** (o repositório do projeto recebe só o produto: código e `docs/`, R31) —, e é lido pelos agentes em tempo de execução.

```
este repositório   processo   → genérico, um só, serve todos os projetos
.team-project/     contexto   → um por projeto, LOCAL — fora do git do projeto (R31)
```

**Começando:** [`how-to.md`](how-to.md) — o que você quer fazer → qual comando, os cenários de uso (projeto novo · retomada · evolução · correção · pedido no meio do sprint · trabalho interrompido · consultoria externa · avaliar se o time compensa), os quatro portões, instalar e atualizar. Para levar o time a um projeto: `claude plugin marketplace add` + `claude plugin install`, e depois **`/team init`**.

## Estrutura

```
<raiz do repositório>            ← este repositório É um plugin do Claude Code
├── .claude-plugin/
│   ├── plugin.json                  manifesto do plugin
│   └── marketplace.json             manifesto do marketplace (permite instalar por caminho)
├── agents/      scrum-master · product-owner · architect · user-experience · developer · quality-assurance
├── commands/    sm · po · arc · ux · dev · qa · team · review   definições dos 8 comandos
├── hooks/                           guardas do harness (fase 1: G1 R31 · G2 cópia instalada · G3 R22 · G4 R28 · G13 autoteste; fase 2, por papel: G5 gate · G6 teste ignorado · G7 R28 · G8 matriz de propriedade · G9 R4/R8 · G11 operator; v3.44: G14 run sem trava · G15 pedido de permissão no log) — hooks.json, despachantes PowerShell, ownership.json (derivado da matriz) e COVERAGE.md (o que cada uma NÃO cobre)
├── scripts/checks/                  conferências: close.ps1 (C1, /sm close) · project.ps1 (C2, retrospectiva e onboarding) · release.ps1 (C3, antes do PR) · fix.ps1 (C4, /sm fix run) · tests/
├── deliverables/                    estrutura dos documentos que o time entrega
│   ├── README.md                    os conjuntos: donos, ordem de elaboração, critérios de qualidade
│   ├── prototype/                   protótipo funcional em HTML — pré-condição do portão ①
│   ├── sdd/                         o que o sistema é — 8 documentos
│   ├── implementation/              como a construção está indo — 4 documentos
│   └── team-project/                manifesto do .team-project/ criado pelo /team init
├── standards/                       padrões de engenharia — normativo agnóstico de produto, base de qualidade comum de Arquiteto, dev e QA (R16)
│   ├── README.md                       índice e os dois níveis
│   ├── implementation-principles.md    nível 1 — princípios agnósticos de linguagem (não mudam entre projetos)
│   ├── implementation-guide.md         nível 2 — perfil de stack (.NET)
│   ├── implementation-quality.md       nível 2 — perfil de stack (.NET/GitLab)
│   └── implementation-security-lgpd-copyright.md   transversal
├── README.md                        ← este índice
├── CHANGELOG.md                     changelog de entregas (vX.Y.Z) — o que saiu em cada versão e a branch
├── how-to.md                        guia do stakeholder — o que fazer → qual comando, cenários de uso A–H, os quatro portões, instalar, atualizar e calibrar a instalação
├── rituals/                         guias lidos só sob demanda (nunca na carga fixa)
│   ├── benchmark.md                 experimento "o time compensa?" (A/B/C) — lido só quando o stakeholder o abre
│   ├── review-contract.md           contrato do `/review` — lido só quando o `/review` aciona o agente de um papel
│   ├── team-init.md                 ritual do `/team init` — lido só nesse modo, uma vez por projeto
│   ├── team-remote.md               ritual do `/team remote` — lido só nesse modo, uma vez por projeto (Remote Control, R34)
│   ├── team-update.md               ritual do `/team update` — lido só nesse modo, uma vez por bump de versão
│   └── team-version.md              ritual do `/team version` — lido só nesse modo
├── note.md                          fila de melhorias do próprio plugin, entrada do `/review` (dono: stakeholder)
└── roles/                           documentação dos papéis
    ├── scrum-master/       processo, Sprint Backlog, rituais, regras que governam todos
    │   ├── README.md · skills.md
    │   ├── process/     working-rules · working-rules-index · workflow · workflow-ritos · workflow-sdd · workflow-sprint · workflow-processo · sprint-run · fix-run · artifact-ownership · process-changelog
    │   └── templates/   planning · sprint-backlog · burndown · consumption · sprint-review · retrospective · plugin-report · status-entry · project-context · process-change · benchmark · fix-log
    ├── product-owner/      requisitos, Histórias, backlog, aceite
    │   └── templates/   user-story · product-backlog · status · requirement · functional-analysis · acceptance · impact-analysis · note · fix-card
    ├── architect/          especificação técnica, Planos de Implementação, ADRs
    │   └── templates/   implementation-plan · adr · technical-decision · spike-checkpoint · fix-plan
    ├── user-experience/   jornadas, telas, protótipos, usabilidade e acessibilidade
    │   └── templates/   functional-prototype · sprint-prototype · journey-map · screen-spec · usability-review
    ├── developer/          execução do plano, entrega, gaps
    │   └── templates/   delivery-report · gap
    └── quality-assurance/  validação, evidências, registro de GAPs
        └── templates/   evidence · verdict · gap-record · cross-audit · scenario · scenarios-index
```

Cada pasta em `roles/`:

| Arquivo / pasta | Conteúdo |
|---|---|
| `README.md` | **Roteiro de atuação** — o que o papel faz, como decide, o que entrega, o que nunca faz. Traz a tabela **documento → tipo → modelo** |
| `skills.md` | Competências transferíveis do papel — o que vale em qualquer projeto |
| `templates/` | Modelos dos documentos e das saídas que o papel produz |
| `process/` | *(só no SM)* Os normativos que governam todos os papéis |

**Fora de `roles/`:** [`standards/`](standards/README.md) — os padrões de engenharia, em dois níveis (princípios agnósticos de linguagem, que não mudam entre projetos, e perfis de stack substituíveis). Era `roles/architect/standards/`; foi promovido a diretório de primeiro nível, irmão de `deliverables/`. **Dono editorial: o Arquiteto** — única caneta, muda só por `/review` (que roteia ao Agent `architect`). É **base de qualidade de consumo obrigatório** para o Desenvolvedor e o QA, que levantam defeito mas não editam (R16 · [`artifact-ownership.md`](roles/scrum-master/process/artifact-ownership.md)).

### Quatro tipos de documento

| Tipo | O que é | Onde está o modelo |
|---|---|---|
| **Processo / guia** | Normativo: regras de trabalho, fluxo, propriedade de artefatos, padrões de engenharia. Vive aqui e muda a pedido do stakeholder. | — *(o documento já é o normativo)* |
| **Entregável** | Documento de projeto que o time elabora e mantém: o SDD e as ADRs. Tem dono, critérios de qualidade e é validado pelo QA a cada entrega. | [`deliverables/`](deliverables/README.md) |
| **Vivo** | Arquivo atualizado a cada ciclo em `.team-project/` — quadro, backlog, planos, evidências. | `roles/<papel>/templates/` |
| **Saída** | Produzido na resposta de um comando, não vira arquivo — status, análise de impacto, veredito, relatório de entrega, 🔺 GAP. | `roles/<papel>/templates/` |

Os **entregáveis** são a diferença entre um time que escreve código e um time que entrega um sistema mantenível: são a memória que permite retomar o projeto meses depois, e a referência contra a qual o QA valida cada Task. Cada um tem um dono explícito — 5 documentos do SDD são do PO, 3 são do Arquiteto — e documento desatualizado é tratado como defeito, não como pendência de organização.

## O time

| Papel | Pasta | Agente | Modelo | Comando |
|---|---|---|---|---|
| Scrum Master | [`roles/scrum-master/`](roles/scrum-master/README.md) | `scrum-master` | Sonnet | `/sm` |
| Product Owner | [`roles/product-owner/`](roles/product-owner/README.md) | `product-owner` | Sonnet | `/po` |
| Arquiteto de Software Sênior | [`roles/architect/`](roles/architect/README.md) | `architect` | Opus | `/arc` |
| UX Designer | [`roles/user-experience/`](roles/user-experience/README.md) | `user-experience` | Sonnet | `/ux` |
| Desenvolvedor(a) júnior | [`roles/developer/`](roles/developer/README.md) | `developer` | Haiku | `/dev` |
| QA | [`roles/quality-assurance/`](roles/quality-assurance/README.md) | `quality-assurance` | Sonnet | `/qa` |
| **O time inteiro** | — | os seis, orquestrados pela sessão nos modos do `/sm` que reúnem papéis (`onboarding`, `brainstorm`, `sdd`, `sprint prepare`, `plan`, `run`, `review`) | — | `/team` só instala e atualiza (`init` · `update` · `version`) |
| Stakeholder | você | — | — | conversa direta com qualquer papel |

## Comandos

```
/sm     onboarding | brainstorm <ideia> | sdd [<tema>] | sprint prepare | sprint plan | sprint run [<T-ID>] | sprint review | sprint close | board | agreement <questão> | consulting <domínio> <tema> | close <T-ID>    (review = alias de sprint review)
/po     status | impact <mudança> | analyze <ideia> | requirement <ID> | story <H-ID> | prioritize | accept <H-ID> | bug <relato> | note
/arc    plan <T-ID> | adr <tema> | question <dúvida>
/ux     prototype | prototype sprint <n> | prototype screen <tela> | journey <fluxo> | screen <nome> | review-ui <tela>
/dev    <T-ID> | resume <T-ID> | gap <resposta do arquiteto>
/qa     <T-ID> | baseline | audit | security <T-ID> | bug <relato> | scenarios create | scenarios run <SC-nnn|grupo|all>
/team   init | update | version
/review <instrução> | note | metrics | audit | history            (só no repositório-fonte do plugin)
```

**`<H-ID>` opera sobre valor, `<T-ID>` sobre trabalho.** A História é a unidade de valor (dona: PO, conteúdo só funcional); a Task é a unidade de trabalho (no Sprint Backlog do SM, com o Plano de Implementação do Arquiteto dentro). Toda Task pertence a exatamente uma História (R20).

Os nomes dos seis primeiros comandos são a abreviação do papel; os **modos são em inglês**, como o resto do plugin. Três nomes se parecem e não são a mesma coisa: **`/ux review-ui`** (usabilidade de uma tela) é trabalho no produto — e a aderência do código ao plano é da frente 2 do `/qa`, em toda Task, sem modo próprio; **`/sm sprint review`** (antes `/sm review`, ainda alias) é a **Sprint Review**, também no produto; e **`/review`** evolui o processo do time e roda só no repositório-fonte do plugin.

### Com quem o stakeholder fala

**O canal é o PO** ([`workflow.md` §6a](roles/scrum-master/process/workflow.md)): demanda, valor, escopo, prioridade, **prazo, plano de entrega e status**. Questão técnica vai direto ao **Arquiteto**; de tela, ao **UX**.

O **SM não é canal de demanda** — é **processo, organização e eficiência**, e facilitador de todos os envolvidos. Você o encontra nos **rituais do Scrum**, que ele gere; no **`/sm agreement`**, quando uma questão atravessa papéis; e na cobrança dos portões que dependem de você.

**Não existe broadcast.** `/team` não fala com os seis: ele só instala, atualiza e informa a versão; **a descoberta é o `/sm brainstorm`, a elaboração do SDD é o `/sm sdd` e o time construindo é o `/sm sprint run`**.

| Modo | O que faz | Quando usar |
|---|---|---|
| `/po status` | Onde estamos, em **Histórias** — entregue, em andamento, bloqueado, próximo, risco ao plano | O seu "como está o projeto?" |
| `/sm agreement <questão>` | O SM chama **só os papéis que a questão toca**, consolida **uma** recomendação e registra a divergência que sobrou | Questão que atravessa papéis e precisa de uma posição |
| `/sm consulting <domínio> <tema>` | Segunda opinião **externa** (humano ou IA, do registro do projeto): os papéis do domínio escrevem a carta sanitizada, você a transporta, o time valida a resposta (até 3 réplicas) e você escolhe entre 3 opções em formulário (R32) | Decisão técnica especializada ou processo de uma área de negócio que o time não domina — **fora do `sprint run`** |
| `/sm brainstorm <ideia>` | Descoberta funcional de ideia sem documentação, facilitada pelo SM: fase 1 stakeholder + PO + UX; fase 2 entra o Arquiteto, em rodadas até fechar para o SDD (R15, [`workflow-ritos.md` §5b](roles/scrum-master/process/workflow-ritos.md)) | Ideia greenfield que ainda não tem visão, requisitos nem fluxos |
| `/sm sdd [<tema>]` | Transição inteira para o SDD, depois do brainstorm (ideia nova) ou do `/po analyze` (área documentada): SDD funcional + protótipo → **① formulário** → SDD técnico da fatia → **② formulário** → Histórias no Product Backlog (R15, [`workflow-sdd.md` §5h](roles/scrum-master/process/workflow-sdd.md)) | Levar o brief até Histórias prontas para o `prepare`, com dois portões seus | UX (se há interface) → Arquiteto → dev → QA e fecha a Task no ✅, a fila inteira do sprint ou uma Task, parando no primeiro problema | Levar a fila (ou uma Task) do plano ao veredito, sem te acionar |

**Acordo não é votação.** A propriedade dos papéis sobrevive à facilitação: requisito, valor, escopo e **prazo** são do PO; desenho é do Arquiteto; tela é do UX; evidência é do QA — os outros aconselham. Maioria não sobrepõe dono; divergência que sobra vira decisão sua. O SM facilita **porque não é dono de nenhum desses assuntos**.

Acordo e status **não escrevem em disco** — são conversa e leitura. O que virar ação é atribuído ao dono e executado pelo comando dele.

## Caminho padrão — do SDD à entrega

```
[projeto novo/retomado] ──▶ /sm onboarding ──▶ entendimento alinhado + contexto do projeto  (uma vez, R14)
[ideia sem documentação] ──▶ /sm brainstorm ──▶ fase 1 (PO+UX) ─▶ fase 2 (+Arquiteto) ─▶ brief  (R15)  ──▶ /sm sdd
                                   │
stakeholder ──▶ /po analyze ──▶ decisão + requisito  ──▶ /sm sdd  (área já documentada: só o delta)
                     │
                     ▼
              /sm sdd ──▶ SDD funcional (PO: 00,01,02)
                     │  + protótipo funcional em HTML (UX)
                     │  ──① stakeholder NAVEGA o protótipo e aprova
                     ▼
              SDD técnico (Arquiteto: 03,04,05)   ──② aprovado
                     │
                     ▼
              (dentro do /sm sdd) /po story ──▶ História no Product Backlog (valor declarado)
                     │            └─ /ux screen ──▶ protótipo, se tem interface
                     │            └─ detalhamento: regras + critérios de aceite
                     ▼
              /sm sprint prepare ──▶ candidatas até a DoR (História · tela · cenários); não aciona o stakeholder
                     │
                     ▼
              /sm sprint plan ──▶ Planning: o time quebra em Tasks e estima; Sprint Backlog fechado
                     │            └─ pacote de abertura (+ protótipo do sprint)  ──③ stakeholder aprova, em lote
                     ▼
              /sm sprint run   (ou /arc plan → /dev → /qa → /sm close, passo a passo)
                     ├─ architect ──▶ Plano de Implementação (dentro da Task, citando o protótipo)
                     ├─ developer ──▶ código + testes, na ordem dos passos
                     │     └─ 🔺 GAP ──▶ architect decide ──▶ /dev gap ──▶ developer retoma
                     └─ quality-assurance ──▶ veredito com evidência real (inclui acessibilidade)
                     │
                     ▼
              /sm close <T-ID> ──▶ Task fechada (técnico) + status atualizado
                     │
                     ▼
              /sm sprint review ──▶ Sprint Review: ④ decisão por História, em formulário (dossiê do PO) ──▶ História aceita
                     │
                     ▼
              /sm sprint close ──▶ retrospectiva ──▶ fim do sprint
```

Nenhum atalho: o portão ① não abre sem o stakeholder **navegar** o protótipo funcional — aprovar por leitura não vale —, SDD técnico não é escrito antes do ①, História não nasce antes do ②, História com interface não é detalhada sem protótipo, nenhuma Task entra em construção antes de o pacote de abertura do sprint ser aprovado (③, em lote, depois da Planning), Task sem História não existe (R20), dev sem plano não codifica, QA sem saída de comando não aprova, e **fechar Tasks não aceita a História** — o aceite é do PO, na Review (④ · R21).

## Regras que governam todos

Geridas pelo SM, válidas para todos os papéis e para o stakeholder:

- [`roles/scrum-master/process/working-rules.md`](roles/scrum-master/process/working-rules.md) — as 34 regras (eficiência R1-R6 e R28-R29, qualidade R7-R12, método R13-R27 e R30-R34), o que cada uma evita e como o SM verifica; o [`working-rules-index.md`](roles/scrum-master/process/working-rules-index.md) é o índice de uma linha por regra que o `/sm close` lê
- [`roles/scrum-master/process/workflow.md`](roles/scrum-master/process/workflow.md) — ciclo, DoR/DoD, gates, escalação (núcleo); os rituais estão em `workflow-ritos.md` (§5a–5b), `workflow-sdd.md` (§5h), `workflow-sprint.md` (§5e–5g) e `workflow-processo.md` (§5c–5d), e o `/sm sprint run` em `sprint-run.md`
- [`roles/scrum-master/process/artifact-ownership.md`](roles/scrum-master/process/artifact-ownership.md) — quem escreve o quê
- [`roles/scrum-master/process/process-changelog.md`](roles/scrum-master/process/process-changelog.md) — como o processo chegou até aqui

### Como o processo evolui — `/review`

O processo não muda por conversa: muda pelo comando **`/review`**, e **só no repositório-fonte do plugin** — rodá-lo contra a cópia instalada num projeto edita algo que o próximo `claude plugin update` sobrescreve. A fila de melhorias é [`note.md`](note.md): a Task é escrito como **sintoma**, e o `/review` (Agent `scrum-master`) o **classifica e roteia** ao papel dono, que aplica seguindo [`rituals/review-contract.md`](rituals/review-contract.md) — cinco passos (classificar · analisar conflito · aplicar · registrar · verificar com evidência) e, no mesmo passe, **reavaliação do conjunto** (coerência interna, aderência à prática, verificabilidade, cobertura de modelos, fronteiras, vazamento de contexto de projeto, obsolescência, excesso). `/review` sem instrução faz só a reavaliação + a triagem de `note.md`.

**O invariante de dono único não muda** — `/review` roteia, o dono aplica:

| Classificação da Task | Quem aplica |
|---|---|
| regra / fluxo / propriedade de artefato / cerimônia | Agent `scrum-master` (normativos que governam todos + curadoria) |
| roteiro, skills, templates de um papel, entregáveis que ele possui | agente daquele papel (PO · UX · QA · Arquiteto) |
| `standards/` **e** os documentos do papel dev | Agent `architect` — o dev roda no modelo mais simples do time e não reescreve o normativo que o governa |
| `agents/` · `commands/` · `.claude-plugin/` | **proposta ao stakeholder**, nunca aplicada pelos papéis |

Limites que mantêm a evolução saudável:

- **Cada papel só mexe nos próprios documentos.** Task que toca outro o SM roteia; normativo que governa todos é exclusivo do Agent `scrum-master`.
- **O dev não edita os próprios normativos.** O retorno dele sobe pelos 🔺 GAPs e pelas seções "Não fiz" dos relatórios, que o Arquiteto lê ao ser acionado pelo `/review` — não por edição direta.
- **Regra sem forma de verificação não entra.**
- **Conflito com regra vigente não se resolve sozinho** — as duas posições vão ao stakeholder.
- **`agents/` e `commands/` são seus** — os papéis propõem, não aplicam.

O **SM é o curador**: consolida o changelog, aponta contradição entre mudanças de papéis diferentes e leva ao stakeholder o que ficou inconsistente. E `/review metrics` sempre considera **remover** algo — processo que só cresce fica caro e deixa de ser seguido.

Modos auxiliares: `/review note` (processa a fila de `note.md`) · `/review audit` (coerência interna do plugin) · `/review metrics` (revisão por evidência) · `/review history` (o changelog).

## Como o time é carregado

O Claude Code só descobre agentes e comandos em `.claude/` **ou em um plugin habilitado**. Este repositório **é** o plugin: `agents/` e `commands/` na raiz, manifesto em `.claude-plugin/`.

Cada projeto que usa o time o registra no seu próprio `.claude/settings.json`. A origem pode ser um caminho local (durante o desenvolvimento do time) ou o repositório git (o caso normal):

```json
{
  "extraKnownMarketplaces": { "team": { "source": { "source": "directory", "path": "../scrum-team-plugin" } } },
  "enabledPlugins": { "team@team": true }
}
```

Instalar usa os comandos nativos do Claude Code; para **atualizar**, o time traz o atalho `/team update`, que checa a versão e orquestra os nativos:

```powershell
claude plugin marketplace add <caminho-ou-repo> --scope project
claude plugin install team@team --scope project -y
claude plugin marketplace update team    # sincroniza com a origem
claude plugin update team@team           # aplica a nova versão (exige reiniciar a sessão)
```

Consequências práticas:

- **`/team update`** (rodado num projeto onde o time está instalado) compara a versão instalada com a do `main` da origem canônica (`https://github.com/wtlmarco/scrum-team-plugin`), mostra o CHANGELOG do delta e aplica `claude plugin marketplace update` + `claude plugin update` após confirmação. Reiniciar a sessão continua manual. No repositório-fonte ele recusa — lá a atualização é `git pull`.
- Os comandos continuam sendo `/sm`, `/po`, `/arc`, `/ux`, `/dev`, `/qa`, `/team`, `/review` — plugin não prefixa comando.
- Editar um arquivo em `agents/` ou `commands/` muda o time; **reinicie a sessão** para o Claude Code recarregar.
- `claude plugin validate .team --strict` checa os manifestos; `claude plugin details team@team` lista os componentes e o custo em tokens.
- `.claude/` guarda só a configuração — nenhuma definição do time.

> ⚠️ **`agents/` e `commands/` têm de ficar na raiz do plugin — nunca dentro de `.claude-plugin/`.** Só os manifestos vivem lá. Testado na versão 2.1.257: movendo as duas pastas para dentro de `.claude-plugin/`, o inventário cai para **Skills (0), Agents (0)** — e apontar os arquivos explicitamente pelos campos `agents`/`commands` do manifesto **também não resgata**. Pior: `claude plugin validate --strict` **continua passando**, então a falha é silenciosa. Depois de mexer na estrutura, o teste que vale é `claude plugin details team@team` — ele tem de listar os **8 comandos** (`sm` `po` `arc` `ux` `dev` `qa` `team` `review`) e os **7 agents**.

## Convenções

- **Nomes de arquivo:** inglês, kebab-case, sem acento. Conteúdo no idioma do time.
- **Nada de produto aqui.** Nome de entidade, comando de build, caminho de código e ID de pendência pertencem a `.team-project/`. Se aparecer neste diretório, é bug de fronteira.
- **Documento vivo e modelo compartilham o nome** — o modelo fica em `templates/`.
