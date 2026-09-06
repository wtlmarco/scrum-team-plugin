# Time Scrum — Plugin do Claude Code

> **Versão atual: v2.8.0** · o que entrou em cada entrega está em [`CHANGELOG.md`](CHANGELOG.md).
> Versionamento de **entrega** no padrão `vMAJOR.MINOR.PATCH`; cada entrega sai numa branch `fix/vX.Y.Z` ou `feat/vX.Y.Z` a partir de `main`, via PR para aprovação. O [changelog do processo](roles/scrum-master/process/process-changelog.md) (`vX.Y`) é outra coisa: registra a evolução interna das regras.

Este repositório **é o plugin**: um time Scrum completo — Scrum Master, Product Owner, Arquiteto, UX, Desenvolvedor e QA — que se instala em qualquer projeto para conduzir concepção, construção e manutenção.

É **genérico e reutilizável**: define **quem faz o quê**, **como cada papel trabalha**, **quais regras governam o time** e **quais modelos de documento cada papel usa** — sem uma linha sobre um produto específico.

O que é de um projeto concreto — produto, stack, comandos, quadro, backlog, planos, evidências — vive em **`.team-project/`**, **dentro do projeto onde o plugin foi instalado**, e é lido pelos agentes em tempo de execução.

```
este repositório   processo   → genérico, um só, serve todos os projetos
.team-project/     contexto   → um por projeto, no repositório daquele projeto
```

**Começando:** [`how-to.md`](how-to.md) — instalar, atualizar, e os quatro caminhos de entrada (projeto novo · retomada · bug · melhoria). Para levar o time a um projeto: `claude plugin marketplace add` + `claude plugin install`, e depois **`/team init`**.

## Estrutura

```
<raiz do repositório>            ← este repositório É um plugin do Claude Code
├── .claude-plugin/
│   ├── plugin.json                  manifesto do plugin
│   └── marketplace.json             manifesto do marketplace (permite instalar por caminho)
├── agents/      scrum-master · product-owner · architect · user-experience · developer · quality-assurance
├── commands/    sm · po · arc · ux · dev · qa · team · review   definições dos 8 comandos
├── deliverables/                    estrutura dos documentos que o time entrega
│   ├── README.md                    os conjuntos: donos, ordem de elaboração, critérios de qualidade
│   ├── sdd/                         o que o sistema é — 8 documentos
│   └── implementation/              como a construção está indo — 4 documentos
├── standards/                       padrões de engenharia — normativo agnóstico de produto, base de qualidade comum de Arquiteto, dev e QA (R16)
│   ├── README.md                       índice e os dois níveis
│   ├── implementation-principles.md    nível 1 — princípios agnósticos de linguagem (não mudam entre projetos)
│   ├── implementation-guide.md         nível 2 — perfil de stack (.NET)
│   ├── implementation-quality.md       nível 2 — perfil de stack (.NET/GitLab)
│   └── implementation-security-lgpd-copyright.md   transversal
├── README.md                        ← este índice
├── CHANGELOG.md                     changelog de entregas (vX.Y.Z) — o que saiu em cada versão e a branch
├── how-to.md                        guia do stakeholder — instalar, atualizar, os 4 caminhos de entrada
├── replicate-in-new-project.md      como levar este time para outro projeto
├── review-contract.md               contrato do `/review` — lido só quando o `/review` aciona o agente de um papel
├── team-init.md                     ritual do `/team init` — lido só nesse modo, uma vez por projeto
├── note.md                          fila de melhorias do próprio plugin, entrada do `/review` (dono: stakeholder)
└── roles/                           documentação dos papéis
    ├── scrum-master/       processo, quadro, status, regras que governam todos
    │   ├── README.md · skills.md
    │   ├── process/     working-rules · workflow · artifact-ownership · process-changelog
    │   └── templates/   work-board · status · status-entry · impact-analysis · retrospective · project-context · process-change
    ├── product-owner/      requisitos, backlog, aceite
    │   └── templates/   product-backlog · requirement · functional-analysis · acceptance
    ├── architect/          especificação técnica, planos de execução, ADRs
    │   └── templates/   execution-plan · adr · compliance-review · technical-decision
    ├── user-experience/   jornadas, telas, protótipos, usabilidade e acessibilidade
    │   └── templates/   journey-map · screen-spec · usability-review
    ├── developer/          execução do plano, entrega, gaps
    │   └── templates/   delivery-report · gap
    └── quality-assurance/  validação, evidências, registro de GAPs
        └── templates/   evidence · verdict · gap-record · cross-audit
```

Cada pasta em `roles/`:

| Item | Conteúdo |
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

Os **entregáveis** são a diferença entre um time que escreve código e um time que entrega um sistema mantenível: são a memória que permite retomar o projeto meses depois, e a referência contra a qual o QA valida cada item. Cada um tem um dono explícito — 5 documentos do SDD são do PO, 3 são do Arquiteto — e documento desatualizado é tratado como defeito, não como pendência de organização.

## O time

| Papel | Pasta | Agente | Modelo | Comando |
|---|---|---|---|---|
| Scrum Master | [`roles/scrum-master/`](roles/scrum-master/README.md) | `scrum-master` | Sonnet | `/sm` |
| Product Owner | [`roles/product-owner/`](roles/product-owner/README.md) | `product-owner` | Sonnet | `/po` |
| Arquiteto de Software Sênior | [`roles/architect/`](roles/architect/README.md) | `architect` | Opus | `/arc` |
| UX Designer | [`roles/user-experience/`](roles/user-experience/README.md) | `user-experience` | Opus | `/ux` |
| Desenvolvedor(a) júnior | [`roles/developer/`](roles/developer/README.md) | `developer` | Haiku | `/dev` |
| QA | [`roles/quality-assurance/`](roles/quality-assurance/README.md) | `quality-assurance` | Sonnet | `/qa` |
| **O time inteiro** | — | os seis, em paralelo ou encadeados | — | `/team` |
| Stakeholder | você | — | — | conversa direta com qualquer papel |

## Comandos

```
/sm     onboarding | status | plan | board | impact <mudança> | close <ID>
/po     analyze <ideia> | requirement <ID> | prioritize | accept <ID>
/arc    plan <ID> | comply <ID> | adr <tema> | question <dúvida>
/ux     journey <fluxo> | screen <ID> | prototype | review-ui <tela>
/dev    <ID> | resume <ID> | gap <resposta do arquiteto>
/qa     <ID> | baseline | audit | security <ID>
/team   init | update | <mensagem ou pergunta> | brainstorm <ideia> | agreement <questão> | cycle <ID>
/review <instrução> | note | metrics | audit | history            (só no repositório-fonte do plugin)
```

Os nomes dos seis primeiros comandos são a abreviação do papel; os **modos são em inglês**, como o resto do plugin. **`/ux review-ui`** (revisão de usabilidade de uma tela do projeto) e **`/arc comply`** (revisão de aderência do código ao plano) são trabalho no produto — não confundir com **`/review`**, que evolui o processo do time.

Os seis primeiros falam com **um** papel. `/team` fala com **todos**; `/review` evolui os documentos do plugin:

| Modo | O que faz | Quando usar |
|---|---|---|
| `/team <mensagem>` | Broadcast: os seis respondem do seu ângulo, em paralelo; a resposta consolida posições, convergências e divergências | Uma ideia, um problema ou uma dúvida que atravessa papéis |
| `/team brainstorm <ideia>` | Descoberta funcional de ideia sem documentação, facilitada pelo SM: fase 1 stakeholder + PO + UX; fase 2 entra o Arquiteto, em rodadas até fechar para o SDD (R15, [`workflow.md` §5b](roles/scrum-master/process/workflow.md)) | Ideia greenfield que ainda não tem visão, requisitos nem fluxos |
| `/team agreement <questão>` | Mesma rodada + consolidação do SM em **uma recomendação única**, com a divergência registrada | Quando você quer uma posição do time, não seis opiniões |
| `/team cycle <ID>` | Encadeia UX → Arquiteto → dev → QA num item, parando no primeiro problema | Levar um item do plano ao veredito |

**Acordo coletivo não é votação.** A propriedade dos papéis sobrevive à consulta: requisito é do PO, desenho é do Arquiteto, prazo é do SM, evidência é do QA — os outros aconselham. Maioria não sobrepõe dono; divergência que sobra vira decisão sua.

Consulta e acordo **não escrevem em disco** — são conversa. O que virar ação é atribuído ao dono e executado pelo comando individual.

## Caminho padrão de um item

```
[projeto novo/retomado] ──▶ /sm onboarding ──▶ entendimento alinhado + contexto do projeto  (uma vez, R14)
[ideia sem documentação] ──▶ /team brainstorm ──▶ fase 1 (PO+UX) ─▶ fase 2 (+Arquiteto) ─▶ brief para o SDD  (R15)
                                   │
stakeholder ──▶ /po analyze ──▶ requisito + critério de aceite
                     │
                     ▼
              /sm plan ──▶ item no quadro (ID, dono, dependência, evidência esperada)
                     │
                     ▼
              /team cycle <ID>   (ou /ux → /arc plan → /dev → /qa, passo a passo)
                     ├─ user-experience ──▶ jornada e especificação de tela  (só se o item tem interface)
                     ├─ architect ──▶ Plano de Execução (citando a especificação de tela)
                     ├─ developer ──▶ código + testes, na ordem dos passos
                     │     └─ 🔺 GAP ──▶ architect decide ──▶ /dev gap ──▶ developer retoma
                     └─ quality-assurance ──▶ veredito com evidência real (inclui acessibilidade)
                     │
                     ▼
              /po accept <ID> ──▶ /sm close <ID> ──▶ status atualizado
```

Nenhum atalho: item com interface não é planejado sem especificação de tela, dev sem plano não codifica, QA sem saída de comando não aprova, PO sem QA não aceita, SM sem aceite não fecha.

## Regras que governam todos

Geridas pelo SM, válidas para todos os papéis e para o stakeholder:

- [`roles/scrum-master/process/working-rules.md`](roles/scrum-master/process/working-rules.md) — as 18 regras (eficiência R1-R6, qualidade R7-R12, método R13-R18), o que cada uma evita e como o SM verifica
- [`roles/scrum-master/process/workflow.md`](roles/scrum-master/process/workflow.md) — ciclo, cerimônias, DoR/DoD, gates, escalação
- [`roles/scrum-master/process/artifact-ownership.md`](roles/scrum-master/process/artifact-ownership.md) — quem escreve o quê
- [`roles/scrum-master/process/process-changelog.md`](roles/scrum-master/process/process-changelog.md) — como o processo chegou até aqui

### Como o processo evolui — `/review`

O processo não muda por conversa: muda pelo comando **`/review`**, e **só no repositório-fonte do plugin** — rodá-lo contra a cópia instalada num projeto edita algo que o próximo `claude plugin update` sobrescreve. A fila de melhorias é [`note.md`](note.md): o item é escrito como **sintoma**, e o `/review` (Agent `scrum-master`) o **classifica e roteia** ao papel dono, que aplica seguindo [`review-contract.md`](review-contract.md) — quatro passos (classificar · analisar conflito · aplicar · registrar) e, no mesmo passe, **reavaliação do conjunto** (coerência interna, aderência à prática, verificabilidade, cobertura de modelos, fronteiras, vazamento de contexto de projeto, obsolescência, excesso). `/review` sem instrução faz só a reavaliação + a triagem de `note.md`.

**O invariante de dono único não muda** — `/review` roteia, o dono aplica:

| Classificação do item | Quem aplica |
|---|---|
| regra / fluxo / propriedade de artefato / cerimônia | Agent `scrum-master` (normativos que governam todos + curadoria) |
| roteiro, skills, templates de um papel, entregáveis que ele possui | agente daquele papel (PO · UX · QA · Arquiteto) |
| `standards/` **e** os documentos do papel dev | Agent `architect` — o dev roda no modelo mais simples do time e não reescreve o normativo que o governa |
| `agents/` · `commands/` · `.claude-plugin/` | **proposta ao stakeholder**, nunca aplicada pelos papéis |

Limites que mantêm a evolução saudável:

- **Cada papel só mexe nos próprios documentos.** Item que toca outro o SM roteia; normativo que governa todos é exclusivo do Agent `scrum-master`.
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

> ⚠️ **`agents/` e `commands/` têm de ficar na raiz do plugin — nunca dentro de `.claude-plugin/`.** Só os manifestos vivem lá. Testado na versão 2.1.257: movendo as duas pastas para dentro de `.claude-plugin/`, o inventário cai para **Skills (0), Agents (0)** — e apontar os arquivos explicitamente pelos campos `agents`/`commands` do manifesto **também não resgata**. Pior: `claude plugin validate --strict` **continua passando**, então a falha é silenciosa. Depois de mexer na estrutura, o teste que vale é `claude plugin details team@team` — ele tem de listar os **8 comandos** (`sm` `po` `arc` `ux` `dev` `qa` `team` `review`) e os **6 agents**.

## Convenções

- **Nomes de arquivo:** inglês, kebab-case, sem acento. Conteúdo no idioma do time.
- **Nada de produto aqui.** Nome de entidade, comando de build, caminho de código e ID de pendência pertencem a `.team-project/`. Se aparecer neste diretório, é bug de fronteira.
- **Documento vivo e modelo compartilham o nome** — o modelo fica em `templates/`.
