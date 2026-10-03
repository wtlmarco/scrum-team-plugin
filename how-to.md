# Como usar o time

Guia do **stakeholder**. Vive no plugin — uma cópia serve todos os projetos e chega atualizada por `claude plugin update team@team`; o `/team update` a copia para `.team-project/how-to.md`. O `.team-project/README.md` de cada projeto carrega só a versão operacional compacta, porque é lido pelos agentes em toda invocação e precisa ser barato.

## Em um minuto

O time trabalha numa cadência fixa, toda conduzida pelo `/sm`:

```
/sm brainstorm ─► /sm sdd ─► /sm sprint prepare ─► /sm sprint plan ─► /sm sprint run ─► /sm sprint review ─► /sm sprint close
   (ideia)        ① ②        (sem te acionar)         ③                (sem te acionar)        ④
```

- **Você decide em quatro momentos — os portões ① ② ③ ④ —, sempre por formulário:** aprovar · aprovar com ajuste · reprovar · pedir mais contexto (no ④: aceita · aceita com ressalva · rejeitada · pedir mais contexto).
- **Fora dos portões, o time não te chama**, salvo bloqueio que PO e Arquiteto não fecharam entre si, ou decisão estratégica (stack, provedor, custo, risco aceito).
- **A qualquer momento:** `/po status` diz onde o time está e quando entrega. O PO é o **seu canal** — demanda, prioridade, prazo e status passam por ele.

## O que você quer fazer → qual comando

| Quero… | Comando |
|---|---|
| Instalar o time num projeto | instalação (abaixo) e depois `/team init` |
| Começar de uma ideia sem documentação | `/sm brainstorm <ideia>` → cenário A |
| Assumir um projeto que já existe | `/sm onboarding` → cenário B |
| Evoluir uma área que já está documentada | `/po analyze <ideia>` → `/sm sdd` → cenário C |
| Transformar o brief ou a decisão em SDD e Histórias | `/sm sdd` |
| Abrir um sprint | `/sm sprint prepare` e depois `/sm sprint plan` |
| Mandar o time construir | `/sm sprint run` (a fila) ou `/sm sprint run <T-ID>` (uma Task) |
| Saber onde estamos, prazo, andamento | `/po status` |
| Ver o quadro do sprint | `/sm board` |
| Saber o custo de uma mudança antes de pedir | `/po impact <mudança>` |
| Saber se o time compensa (custo × qualidade) | `/usage` no fim de cada sessão, colado ao time · retrospectiva "Custo × resultado" · experimento em `rituals/benchmark.md` → cenário H |
| Relatar um problema | anote em `.team-project/note.md` e rode `/po note`, ou `/po bug <relato>` → cenário D |
| Tirar uma dúvida técnica | `/arc question <dúvida>` |
| Resolver uma questão que envolve vários papéis | `/sm agreement <questão>` |
| Ouvir um consultor externo antes de decidir (técnico ou de negócio) | `/sm consulting <domínio> <tema>` — **fora do `sprint run`** → cenário G |
| Aceitar o que o sprint entregou | `/sm sprint review` |
| Encerrar o sprint | `/sm sprint close` |
| Atualizar o plugin / ver a versão | `/team update` · `/team version` |
| Mudar como o time trabalha (regra, cerimônia, modelo) | `/review` — **só no repositório-fonte do plugin** |

## Os cenários

### A · Projeto novo, a partir de uma ideia

```
/team init                  cria .team-project/ e o contexto
/sm onboarding              o time lê o que existe e lista o que falta decidir — você responde em formulário
/sm brainstorm <ideia>      fase 1: você + PO + UX moldam a ideia (funcional)
                            fase 2: entra o Arquiteto (viabilidade), em rodadas, até não haver objeção bloqueante
/sm sdd                     o time escreve o SDD e as Histórias:
                              PO escreve o SDD funcional · UX faz jornadas e o protótipo em HTML
                              ① você NAVEGA o protótipo e decide
                              Arquiteto escreve o SDD técnico da primeira fatia
                              ② você decide o SDD técnico
                              PO cria as Histórias no Product Backlog
/sm sprint prepare          o time detalha as candidatas (regras, critérios, telas, cenários de teste) — sem te acionar
/sm sprint plan             Planning: quebra em Tasks, estima, corta pela capacidade, costura o protótipo do sprint
                              ③ você navega o protótipo do sprint e decide o PACOTE
/sm sprint run              o time constrói a fila inteira — sem te acionar
/sm sprint review           ④ você decide, uma pergunta por História
/sm sprint close            retrospectiva; o sprint seguinte começa no prepare
```

O `brainstorm` existe porque ideia sem documentação não deve virar requisito pela mão de um papel só: a inviabilidade técnica só apareceria na construção.

### B · Projeto que já existe (retomada)

Há código, e a documentação pode não corresponder a ele.

```
/team init                  cria .team-project/
/sm onboarding              inventário das fontes; o que a documentação não cobre vira pergunta a você
/qa audit                   cruza os documentos com o código real
/qa baseline                reproduz os números declarados (build, testes, cobertura) — a régua de regressão
```

Depois, conforme o que o onboarding encontrou:

- **Há SDD aproveitável** → ele vale como aprovado; o PO escreve as Histórias do que a auditoria achou (`/po story <ID>`) e segue para `/sm sprint prepare`.
- **Não há SDD, ou ele não corresponde ao código** → `/sm sdd`, como no cenário A.

**Comece pela auditoria, não pelo plano.** O status de um projeto retomado costuma declarar mais pronto do que o código sustenta; o levantamento sobre o código vence a narrativa, e a divergência vira risco no quadro.

### C · Evoluir o produto

| A ideia é… | Caminho |
|---|---|
| Em **área já documentada** | `/po analyze <ideia>` → o PO decide e declara o que muda → `/sm sdd` atualiza só as seções afetadas, com portões só no que mudou → `/sm sprint prepare` → `plan` → … |
| **Capacidade nova**, sem cobertura no SDD | `/sm brainstorm <ideia>` → segue o cenário A a partir do `/sm sdd` |

Se a mudança mexe em algo já planejado ou em construção, rode antes **`/po impact <mudança>`**: o PO diz o que ela custa, o que quebra e o que sai para caber.

### D · Corrigir um problema

**Você relata** — de dois jeitos:
- **Em lote (recomendado):** anote cada problema em `.team-project/note.md`, seção **Abertas**, um por linha, como **sintoma** ("depois de salvar duas vezes seguidas em X, a tela trava" — não "corrigir o timeout de X"). Quando quiser, `/po note`.
- **Avulso:** `/po bug <relato>`.

O PO classifica cada item — **defeito** · **mudança de escopo disfarçada** · **dúvida de uso** —, aciona o QA no que é defeito, responde a você item a item e decide a forma de atendimento:

| Situação | Caminho |
|---|---|
| Cabe na folga do sprint corrente, não bloqueia História em voo, e o projeto já tem 3 sprints de histórico | **correção pontual:** `/sm board` registra a entrada fora da Planning (e o que saiu para caber) → `/sm sprint run <T-ID>` |
| Excede a folga, toca várias áreas, ou o projeto tem menos de 3 sprints | vai ao Product Backlog e entra num sprint: `/sm sprint prepare` → `plan` → … |

Item tratado **sai da fila** e passa a viver só no destino (registro do QA, Product Backlog ou a resposta dada).

**O time também acha defeito sozinho** — QA numa validação, dev implementando, Arquiteto revisando. Isso vai direto ao registro do QA, sem passar por você. Se bloqueia uma História do sprint, vira Task no próprio sprint; se não, o PO o leva ao Product Backlog.

**Quando o QA reprova uma Task**, o achado volta para quem é dono do problema:

| O achado é… | Vai para |
|---|---|
| Correção local, dentro do plano aprovado | o dev (`/dev resume <ID>`) — o `run` já faz isso |
| Do domínio de outro papel | o dono: `/po` · `/arc question` · `/ux` |
| De dois donos, sem dar para dizer qual | `/sm agreement <questão>` |
| O desenho não sustenta o requisito | o Arquiteto (`/arc question`) |
| Dúvida se o **critério** estava certo | o PO (`/po`) |

### E · Pedido novo no meio do sprint

**O sprint não cresce depois da Planning.** O pedido vai ao Product Backlog e concorre no próximo `prepare`. Rode `/po impact <mudança>` se precisar saber o custo antes. Única exceção: um problema que **bloqueia** uma História já no sprint — entra como Task, registrado com o que saiu para caber.

### F · O trabalho parou no meio

- **O `run` foi interrompido** (sessão fechada, erro de ambiente): rode `/sm sprint run` de novo. Ele retoma cada Task de onde parou, sem replanejar o que já tem plano.
- **O `sdd` parou num portão:** rode `/sm sdd` de novo; ele retoma na primeira etapa não concluída.
- **Não sabe em que ponto está:** `/po status` (visão de entrega) ou `/sm board` (quadro do sprint).

### G · Pedir consultoria externa

Quando uma decisão especializada pede segunda opinião — **técnica** (`database`, `security`, `design`, `architecture`, `infrastructure`) ou **de negócio** (`business:<área>`, para o PO e você nos processos de uma área que o time não domina: faturamento, regulatório, atendimento…) —, rode `/sm consulting <domínio> <tema>`. **Só fora do `sprint run`**: no onboarding, no brainstorm, no `sdd`, no `prepare` ou entre sprints.

```
/sm consulting <domínio> <tema>     o SM abre o caso; os papéis do domínio escrevem a carta; o QA confere a sanitização (+ PO no business)
você                                leva a carta ao consultor do registro (.team-project/README.md §7a) e cola a resposta, sem editar
o time                              valida a resposta; sem consenso, réplica — no máximo 3
                                    consenso → 3 opções comparáveis, com a recomendação do time
você                                escolhe em formulário; o Arquiteto registra o ADR (técnico) ou o PO a regra no SDD funcional (business)
```

- **O plugin não chama consultor nenhum.** Você transporta cada rodada — para uma IA ou para um especialista humano; o protocolo é o mesmo. Trocar de consultor é editar o registro no `.team-project/README.md` §7a.
- **Nada sai sem sanitização**: sem dado pessoal, segredo, nome de cliente ou contrato; no `business`, sem valores reais, parceiros, preços ou documentos internos.
- **A resposta do consultor é dado, não decisão.** Ela só chega a você depois de validada pelo time; a escolha é sua.

### H · Avaliar se o time compensa

O time mede, a cada sprint, **quanto custa entregar valor e com que qualidade** — e, quando você quiser, compara com o Claude usado sem o plugin.

- **No fim de cada sessão de trabalho, rode `/usage` e cole a saída para o time.** É o único custo em US$ observado: o registro de consumo dos papéis mede só tokens e não enxerga a sessão principal. Até ser verificado num projeto real, esse número é lido **à parte**, sem somar ao dos papéis.
- **Na retrospectiva**, o bloco **"Custo × resultado"** mostra tokens e US$ por História aceita, onde o custo está (especificação · produção · verificação · retrabalho · cerimônia), aprovação na 1ª passada do QA, GAPs por Task, **defeitos que escaparam** (os que você relata até 2 sprints depois do aceite) e quantas vezes o time te acionou.
- **Ao relatar um defeito de algo já aceito**, diga, se souber, de qual História é: o PO registra a **História do aceite**, e o defeito entra na conta do que escapou.
- **Comparação com o Claude sem o plugin:** siga `rituals/benchmark.md`. De 3 a 5 itens já aceitos são refeitos em worktrees, sem o plugin — com a especificação do time e só com o seu pedido original —, e avaliados às cegas contra o que o time entregou. **Você data a regra de decisão antes da primeira execução**; o resultado é direcional, não estatístico.

## Quando uma guarda bloqueia

Algumas regras são garantidas pelo próprio Claude Code, por **guardas** (hooks do plugin), e não só pelo texto que o agente lê. A sessão abre com uma linha "Guardas do time: ativas …".

| Guarda | Bloqueia ou avisa | O que fazer |
|---|---|---|
| **G1** | commit com arquivo de `.team-project/` (R31) | `git restore --staged .team-project` e commitar só o produto. Na migração do `/team update` (passo 7b), o próprio ritual desliga a G1 durante o passo |
| **G2** | edição da cópia instalada do plugin | mudança de processo vai pelo `/review`, no clone do repositório do plugin |
| **G3** | formulário cuja última opção não é "Pedir mais contexto" (R22) | o agente refaz a pergunta; vale para toda pergunta, até a simples |
| **G4** | aviso: saída de comando com mais de 300 linhas no contexto (R28) | delegar a execução pesada ao `operator` |

- **O agente recebe o motivo e corrige o rumo** — você normalmente nem vê o bloqueio.
- **Falso positivo:** acrescente a guarda a `"disabled"` em `.team-project/guards.json`; vale na hora. Leve o caso ao `/review`, para a guarda ser corrigida.
- **Cada disparo custa de 0,6 a 0,8 s.** O que cada guarda **não** cobre está em `hooks/COVERAGE.md`; as decisões ficam em `.team-project/guards.log`, contadas na retrospectiva.
- **O `/sm close` começa por uma conferência automática** (`close.ps1`): sem evidência com veredito ✅ (R7) ou com documento vivo pendente (R12), a Task não fecha.

## Os seus quatro portões

| Portão | Onde | O que você recebe | Como decide |
|---|---|---|---|
| **① SDD funcional** | `/sm sdd` | o protótipo funcional em HTML, com todos os fluxos principais | **navega** o protótipo, depois responde o formulário |
| **② SDD técnico** | `/sm sdd` | arquitetura, dados e API da primeira fatia, resumidos pelo Arquiteto | formulário |
| **③ Pacote do sprint** | `/sm sprint plan` | Sprint Backlog fechado · critérios de aceite · protótipo do sprint · `planning.md` (inclusive o que **não** entrou e por quê) | **navega** o protótipo do sprint, depois um formulário só para o pacote inteiro |
| **④ Aceite** | `/sm sprint review` | o dossiê de cada História, critério a critério, com a evidência do QA | uma pergunta por História |

- **Por que navegar, e não ler.** Aprovar texto é aprovar uma descrição; a divergência entre o que você imaginou e o que o time entendeu só aparece quando você atravessa o fluxo. No ① o que se joga fora é HTML; depois, é arquitetura e código.
- **O ③ aprova todas as Histórias do sprint de uma vez** e é o que faz o sprint arrancar: nenhuma Task entra em construção antes dele. Se reprovar, o PO reordena, o corte é refeito e o pacote volta.
- **No ④, ressalva, gap e erro** viram entrada no Product Backlog na mesma sessão, com dono, e a priorização deles volta a você no pacote do sprint seguinte.
- **Na evolução de área documentada (cenário C)**, um portão sem nada a decidir é dispensado — só com o dono declarando, com motivo, que aquela parte não muda.
- **Um `/ux prototype` ou `/arc` rodado avulso não abre nem fecha portão**: a decisão fica pendente até o `/sm sdd`.

## Regras que valem em qualquer cenário

- **Toda Task pertence a uma História**, e nenhuma entra em construção antes do ③. Trabalho técnico sem valor declarado não entra.
- **Sem plano, sem código.** O dev executa o Plano de Implementação do Arquiteto; lacuna vira 🔺 GAP, não improviso.
- **Nada é "pronto" sem saída real de comando.** O que não foi exercitado é declarado como não exercitado.
- **O QA reprova, não corrige.** O aceite de valor é seu, por História, na Sprint Review.
- **Fechar uma Task não é aceitar a História.** Se a História for rejeitada na Review, todas as Tasks dela voltam — inclusive as que passaram no QA.
- **Cada papel escreve só o que lhe pertence.** Requisito e História são do PO; desenho, ADR e standards, do Arquiteto; telas e protótipos, do UX; quadro e status do sprint, do SM; evidência e mapa de código, do QA; código, do dev.
- **Dúvida funcional vai ao PO, técnica ao Arquiteto, estratégica a você.**

## Referência dos comandos

| Comando | Modos | Papel |
|---|---|---|
| `/sm` | `onboarding` · `brainstorm <ideia>` · `sdd [<tema>]` · `sprint prepare` · `sprint plan` · `sprint run [<T-ID>]` · `sprint review` *(alias: `review`)* · `sprint close` · `board` · `agreement <questão>` · `consulting <domínio> <tema>` · `close <T-ID>` | Scrum Master — cadência, rituais, quadro, capacidade, riscos |
| `/po` | `status` · `impact <mudança>` · `analyze <ideia>` · `requirement <ID>` · `story <H-ID>` · `prioritize` · `accept <H-ID>` · `bug <relato>` · `note` | Product Owner — **o seu canal**: status, prazo, requisitos, Histórias, backlog, aceite, defeitos que você relata |
| `/arc` | `plan <ID>` · `adr <tema>` · `question <dúvida>` | Arquiteto — desenho, SDD técnico, Plano de Implementação, ADR, standards |
| `/ux` | `prototype` · `prototype sprint <n>` · `prototype screen <tela>` · `journey <fluxo>` · `screen <nome>` · `review-ui <tela>` | UX — protótipos, jornadas, telas, usabilidade, acessibilidade |
| `/dev` | `<ID>` · `resume <ID>` · `gap <resposta>` | Desenvolvedor — executa o plano, não improvisa |
| `/qa` | `<ID>` · `baseline` · `audit` · `security <ID>` · `bug <descrição>` *(acionado pelo PO)* · `scenarios create` · `scenarios run <SC-nnn\|grupo\|all>` | QA — o veredito de qualidade que responde a você |
| `/team` | `init` · `update` · `version` | Instala, atualiza e informa a versão — não dispara agente |
| `/review` | `<instrução>` · `note` · `metrics` · `audit` · `history` | Evolução do processo do time — **só no repositório-fonte do plugin** |

**No dia a dia você usa quase só `/sm`, `/po` e, às vezes, `/arc question`.** Os `/sm` de ritual chamam os outros papéis por você.

**Comandos de papel avulsos** (`/arc plan`, `/dev`, `/qa <ID>`, `/sm close`) existem para acompanhar uma Task etapa por etapa, ou para **calibrar** a instalação antes da primeira Planning (o plano vai para `.team-project/architect/calibration/`, sem fechamento). No fluxo normal, o `/sm sprint run` faz essa sequência por você.

**Os três `prototype` são artefatos diferentes:** sem argumento é o **protótipo funcional do produto** (portão ①); `sprint <n>` é o **protótipo costurado do sprint** (portão ③); `screen <tela>` é uma **tela isolada**, para explorar, sem portão.

**História × Task.** A **História** é a unidade de valor — do PO, aprovada por você no ③ e aceita no ④. A **Task** é a unidade de trabalho — nasce da quebra da História na Planning e carrega o plano do Arquiteto. Comando com `<H-ID>` opera sobre valor; com `<T-ID>`, sobre trabalho.

**`/sm sprint review` não é `/review`.** O primeiro é a Sprint Review, no projeto, onde você aceita as Histórias. O segundo muda o processo do time e roda só no repositório-fonte do plugin.

**Duas filas de anotação, dois alvos.** `.team-project/note.md` é a fila do **produto** — problemas que você encontra usando o que o time construiu; o PO a trata com `/po note`. O `note.md` do repositório do plugin é a fila do **processo** — como o time trabalha; o `/review` a trata. Melhoria de processo percebida num projeto é anotada como sintoma lá, não aqui.

**Se um comando não for reconhecido, use o prefixo do plugin:** `/team:sm`, `/team:po`, `/team:review`… Isso acontece quando outro plugin instalado declara o mesmo nome curto.

## Onde cada coisa mora

| Camada | Diretório | Muda por |
|---|---|---|
| Processo do time | o plugin (`${CLAUDE_PLUGIN_ROOT}`) | só o `/review`, no repositório-fonte do plugin |
| Contexto e controles do projeto | `.team-project/` — **local, fora do git** | o trabalho normal do time |
| Entregáveis do produto | `docs/` do projeto (SDD, ADR, implementação) — **no git, sem referência a `.team-project/`** | os donos declarados em `deliverables/README.md` |
| Código | o diretório de código do projeto | só o dev, e só os arquivos do plano vigente |

### O que o `/team init` cria no seu projeto

Uma pasta só, `.team-project/`, na raiz. **Nada fora dela é tocado** — a não ser uma linha `.team-project/` acrescentada ao `.gitignore`, se o projeto é repositório git: o processo é **local**, e o git recebe só o produto (código e `docs/`).

```
.team-project/
├── README.md              contexto do projeto · declara o SPRINT CORRENTE (§2)
├── how-to.md              cópia deste guia, atualizada a cada /team update
├── note.md                sua fila de relatos — escreva o sintoma, o PO trata em /po note
│
├── consumption.md         consumo fora de sprint (onboarding, brainstorm, prepare, sdd, entre sprints) — mesmo modelo do de dentro do sprint
├── consulting/            casos de consultoria externa (/sm consulting) — nasce só quando você pede um
├── benchmark/             o experimento "o time compensa?" (rituals/benchmark.md) — nasce só quando você o abre
├── guards.json            liga e desliga as guardas deste projeto ("disabled") · guards.log: o que elas barraram
│
├── sprints/               O REGISTRO DE EXECUÇÃO, um subdiretório por sprint
│   └── 1/ 2/ 3/ …
│       ├── planning.md              o que foi decidido na Planning, e o que NÃO entrou
│       ├── sprint-backlog.md        o quadro vivo do sprint, com a sua decisão do ③
│       ├── stories/                 as Histórias como você as aprovou (congeladas)
│       ├── plan/                    um Plano de Implementação por Task
│       ├── evidence/                a evidência de cada Task: comando e saída real
│       ├── consumption.md           tokens e duração por invocação (inclui o operator)
│       ├── burndown.md              estimativa restante, em série datada
│       ├── review.md                a Sprint Review e a sua decisão por História
│       ├── retrospective.md         o que o time corrige no sprint seguinte
│       └── plugin-report.md         só se você escolher "investigar" uma ocorrência de plugin na Review: relatório de processo, sem contexto do projeto, que você encaminha ao dono do plugin
│
├── product-owner/         context.md · product-backlog.md (índice) · stories/ (fonte viva)
├── scrum-master/          context.md (inclui o SDD em elaboração e as candidatas do próximo sprint)
├── architect/             context.md · spikes/ · calibration/ (planos antes da 1ª Planning)
├── user-experience/       context.md · prototype/ (+ prototype/sprint-<n>/) · journeys/ · screens/
├── developer/             context.md
└── quality-assurance/     context.md · baseline.md (a régua de regressão do projeto)
```

- **Por que o registro é por sprint, e não por papel.** Um sprint produz artefatos de quatro donos. Em `sprints/3/` está tudo: o que foi planejado, o que você aprovou, como foi construído, com que evidência, o que você aceitou e o que o time decidiu corrigir. O dono continua declarado por subpasta.
- **Sprint fechado não se edita.** Depois da retrospectiva, a pasta vira registro histórico; o `/team update` nunca reconcilia estrutura nova dentro dela.
- **Fica fora da pasta do sprint** o que soma ou evolui através dos sprints: Product Backlog e Histórias vivas, SDD, ADRs, registro de GAPs, mapa de código, baseline, protótipo funcional do ① e casos de consultoria externa.
- **Onde está o quadro de hoje:** `.team-project/README.md` §2 declara o sprint corrente.

## Instalar e manter atualizado

O projeto-alvo **não precisa ser repositório git**.

**1. Adicione o marketplace** — sempre com a **URL `.git` completa**, nunca `owner/repo`, e **no escopo do projeto**:

```powershell
claude plugin marketplace add https://github.com/wtlmarco/scrum-team-plugin.git --scope project
claude plugin marketplace list      # o team tem de aparecer nas settings do PROJETO
```

O `.claude/settings.json` do projeto deve ficar assim:

```json
{
  "extraKnownMarketplaces": {
    "team": { "source": { "source": "git", "url": "https://github.com/wtlmarco/scrum-team-plugin.git" } }
  },
  "enabledPlugins": { "team@team": true }
}
```

**2. Instale e reinicie a sessão** — plugin só carrega na inicialização do Claude Code:

```powershell
claude plugin install team@team --scope project -y
```

Depois de reiniciar, `/plugin` mostra `team@team` como **enabled** e `/help` lista os **8 comandos** (`/sm /po /arc /ux /dev /qa /team /review`) e os **7 agentes**. Se não listar, veja *Problemas de instalação*.

**3. `/team init`** — cria o `.team-project/` e conduz o preenchimento. Sem ele, todo papel para e pede que seja criado.

**Atualizar:** `/team update` compara a versão instalada com a do `main` da origem, mostra o que mudou e, com a sua confirmação, aplica e reconcilia o `.team-project/` — substitui o que é cópia literal (este guia) e **propõe** o delta do que tem conteúdo seu, nunca apagando nada sem aprovação. À mão: `claude plugin marketplace update team` e `claude plugin update team@team`, e reinicie a sessão.

**Uma origem, vários projetos.** O plugin é genérico: replicar o time é instalar o plugin e escrever o contexto do projeto (`.team-project/`), nunca copiar a pasta do plugin para dentro de cada projeto — as cópias divergem. Melhorias chegam a todos por `claude plugin marketplace update team` + `claude plugin update team@team`. A origem pode ser a URL `.git` ou um caminho local; use a mesma forma de identificador em todos os registros.

### Calibrar a instalação

**Composição do time.** A distribuição de modelos é escolha de custo/qualidade, não regra:

| Papel | Modelo | Por quê |
|---|---|---|
| Arquiteto | Opus | Concentra o raciocínio de desenho técnico; plano raso custa a Task inteira |
| UX, SM, PO, QA | Sonnet | Leitura, julgamento e verificação; no UX, a janela de 1M comporta o protótipo navegável de um arquivo só |
| Dev | Haiku | Executa plano detalhado; a qualidade vem do plano, não do modelo |

**Haiku não é opção para o UX:** a janela de 200K não sustenta um `index.html` navegável ponta a ponta, e truncá-lo quebra um portão (① e ③). Projeto **sem interface** pode dispensar o UX; projeto sem base de código legada pode dispensar o QA no começo; mais de uma frente independente justifica um segundo dev (faixas em [`roles/scrum-master/process/workflow.md`](roles/scrum-master/process/workflow.md) §7). Os princípios de **nível 1** ([`standards/implementation-principles.md`](standards/implementation-principles.md)) são agnósticos de stack; só o **perfil de nível 2** (`implementation-guide` / `implementation-quality`, hoje .NET/GitLab) se substitui quando a stack é outra — pelo Arquiteto, via `/review`, num clone do repositório-fonte.

**Primeira rodada de validação** — antes da 1ª Planning, nesta ordem, para confirmar que o time está calibrado:

```
/qa baseline          → os números declarados batem com a realidade?
/po status            → o status sai em 6 linhas, em Histórias, com evidência?
/arc plan <T-ID>      → o plano é executável por um júnior sem decidir nada?
/dev <T-ID> · /qa <T-ID> → a Task fecha com veredito e evidência real?
```

Antes da 1ª Planning use os comandos de papel; `/sm sprint run <T-ID>` exige o pacote do sprint aprovado e a Task no quadro. Se o primeiro plano do Arquiteto precisar de mais de dois 🔺 GAPs para ser executado, o problema não é o time — é o `context.md` do Arquiteto, raso: a métrica mais barata de saúde da instalação. O que mais rende ao escrever os `context.md` são as **armadilhas** do projeto ("handler novo exige registro manual, senão devolve 500"). Projeto retomado: comece pelo `pending.md` — `/qa audit` + `/qa baseline` revelam o tamanho verdadeiro do trabalho.

**Checklist da instalação**

- [ ] `claude plugin marketplace list` mostra o `team` nas **settings do projeto**, não nas do usuário
- [ ] `claude plugin list` mostra `team@team` habilitado (exibição duplicada é ruído)
- [ ] Sessão reiniciada; `/plugin` mostra `team@team` **enabled** e `/help` lista os 8 comandos e os 7 agentes
- [ ] `/team init` executado; `.team-project/README.md` escrito (stack, fontes da verdade, comandos, limitações) e os seis `context.md` com as armadilhas do projeto
- [ ] Em repositório git: `.gitignore` com `.team-project/` e `git ls-files .team-project` vazio (R31); `.team-project/consumption.md` existe
- [ ] Projeto retomado: `pending.md` produzido por `/qa audit` antes de qualquer planejamento
- [ ] Backlog inicial semeado com IDs (projeto novo: cenário A; retomada: cenário B)
- [ ] `/qa baseline` registrado em `.team-project/quality-assurance/baseline.md`
- [ ] Primeira Task fechada com veredito ✅ (`/sm sprint run`, depois da 1ª Planning com pacote aprovado)

### Problemas de instalação

- **O plugin "some" na sessão.** O registro caiu em *user settings*, não no projeto: remova e refaça com `--scope project`. A forma do identificador também importa — `{"source":"github","repo":…}` e `{"source":"git","url":"….git"}` são dois identificadores para o mesmo marketplace, e misturá-los impede o resolvedor de casar o plugin com o cache.
- **Mais de um perfil de config (Windows).** Com mais de um `CLAUDE_CONFIG_DIR` (ex.: `~/.claude` e `~/.claude-pessoal`), rode **todos** os `claude plugin …` no mesmo ambiente com que você abre o Claude Code; fora dele, tudo vai para o perfil errado.
- **Instalado mas não habilita.** Confira em `plugins/installed_plugins.json` se o `projectPath` do `team@team` bate **exatamente** com o caminho que o Claude Code mostra, inclusive a caixa do drive (`C:` × `c:`). Abra o projeto sempre pelo mesmo caminho.
- **`git clone` "vermelho" no PowerShell 5.1.** O progresso sai em stderr e o PS 5.1 o mostra como erro, às vezes com exit 128, mesmo com o clone certo. Confira `$LASTEXITCODE` e os arquivos. Caminho longo: `git -c core.longpaths=true clone …`.
- **`team@team` aparece duas vezes em `claude plugin list`** — ruído de exibição, não instalação duplicada.
