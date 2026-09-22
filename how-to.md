# Como usar o time

Guia do **stakeholder**. Vive no plugin — uma cópia serve todos os projetos e chega atualizada por `claude plugin update team@team`. O `.team-project/README.md` de cada projeto carrega só a versão operacional compacta, porque aquele arquivo é lido pelos agentes em toda invocação e precisa ser barato.

## Instalar em um projeto

O projeto-alvo **não precisa ser repositório git** — só o `/review` e o `/team update` dependem de `.git`, e ambos rodam no repositório-fonte do plugin, não aqui.

**1. Adicione o marketplace** — sempre com a **URL `.git` completa**, nunca `owner/repo`:

```powershell
claude plugin marketplace add https://github.com/wtlmarco/scrum-team-plugin.git --scope project
```

A forma do identificador importa: `{"source":"github","repo":"owner/nome"}` e `{"source":"git","url":"…​.git"}` são **dois identificadores para o mesmo marketplace**, e o resolvedor não casa o plugin habilitado com o cache já baixado quando as duas formas se misturam. Um caminho local também serve (útil para desenvolver o próprio plugin), desde que seja o mesmo em todos os registros.

**2. Confirme que o registro caiu no projeto**, não no perfil do usuário:

```powershell
claude plugin marketplace list
```

O `team` tem de aparecer como declarado nas **settings do projeto**. Se caiu em user settings, remova e refaça com `--scope project` — instalar sem escopo registra fora do projeto e o plugin "some" na sessão. O `.claude/settings.json` do projeto deve ficar assim:

```json
{
  "extraKnownMarketplaces": {
    "team": { "source": { "source": "git", "url": "https://github.com/wtlmarco/scrum-team-plugin.git" } }
  },
  "enabledPlugins": { "team@team": true }
}
```

**3. Instale:**

```powershell
claude plugin install team@team --scope project -y
```

**4. Reinicie a sessão.** Não é detalhe: plugin só carrega na inicialização do Claude Code. Depois de reiniciar, verifique — `/plugin` mostra `team@team` como **enabled**, e `/help` lista os **8 comandos** (`/sm /po /arc /ux /dev /qa /team /review`) e os **7 agentes**. Se não listar, a instalação não pegou; volte ao passo 2.

**5. `/team init`** — cria o `.team-project/` padrão e conduz o preenchimento. **Sem `.team-project/`, todo papel para e pede que ele seja criado** — é a fonte de contexto de projeto do time.

### Windows e múltiplos perfis

- **Um `CLAUDE_CONFIG_DIR` por vez.** Numa máquina com mais de um perfil de config (ex.: `~/.claude` de trabalho e `~/.claude-pessoal`), rode **todos** os `claude plugin …` no mesmo ambiente com que você abre o Claude Code. Fora dele, o marketplace, o cache e o registro vão para o perfil errado, e o plugin nunca aparece na sessão.
- **Caixa da letra do drive.** Abra o projeto sempre pelo mesmo caminho. Se o plugin não habilitar apesar de instalado, confira em `plugins/installed_plugins.json` se o `projectPath` do `team@team` bate **exatamente** com o caminho que o Claude Code mostra, inclusive `C:` × `c:` — chave que não bate não associa a instalação ao projeto. *(Contorno de comportamento do Claude Code; some quando ele normalizar a caixa.)*
- **`git clone` "vermelho" no PowerShell 5.1.** O progresso do clone sai em stderr e o PS 5.1 o embrulha como `NativeCommandError`, às vezes com exit 128, mesmo quando o clone deu certo. Confira `$LASTEXITCODE` e os arquivos gerados, não o texto vermelho. Caminho longo: `git -c core.longpaths=true clone …`.
- **`claude plugin list` mostrando `team@team` duas vezes** é ruído de exibição, não instalação duplicada.

Manter atualizado — **`/team update`** faz a checagem e a aplicação: compara a versão instalada com a do `main` da origem canônica (`https://github.com/wtlmarco/scrum-team-plugin`), mostra o que mudou e, após confirmação, aplica. Roda **na cópia instalada**, nunca no repositório-fonte.

Os comandos nativos que ele orquestra, se preferir rodar à mão:

```powershell
claude plugin marketplace update team    # sincroniza com a origem registrada
claude plugin update team@team           # aplica (exige reiniciar a sessão)
```

## Os comandos

| Comando | Modos | Papel |
|---|---|---|
| `/sm` | `onboarding` · `sprint plan` · `sprint close` · `review` · `board` · `agreement <questão>` · `close <T-ID>` | Scrum Master — rituais, Sprint Backlog, capacidade, riscos, processo |
| `/po` | `status` · `impact <mudança>` · `analyze <ideia>` · `requirement <ID>` · `story <H-ID>` · `prioritize` · `accept <H-ID>` · `bug <relato>` · `note` | Product Owner — **o seu canal**: status, prazo, requisitos, Histórias, backlog, aceite, e o defeito que você reporta |
| `/arc` | `plan <ID>` · `comply <ID>` · `adr <tema>` · `question <dúvida>` | Arquiteto — desenho, Plano de Implementação, ADR, standards |
| `/ux` | `prototype` · `prototype sprint <n>` · `prototype screen <tela>` · `journey <fluxo>` · `screen <nome>` · `review-ui <tela>` | UX — **protótipo funcional (portão ①)**, **protótipo do sprint (portão ③)**, jornada, tela, usabilidade, acessibilidade |
| `/dev` | `<ID>` · `resume <ID>` · `gap <resposta>` | Desenvolvedor — executa o plano, não improvisa |
| `/qa` | `<ID>` · `baseline` · `audit` · `security <ID>` · `bug <descrição>` *(acionado pelo PO)* | QA — o veredito de qualidade que responde ao stakeholder |
| `/team` | `init` · `update` · `version` · `brainstorm <ideia>` · `cycle <T-ID>` · **`cycle sprint`** · `plan <T-ID>` · `build <T-ID>` · `qa <T-ID>` | Orquestra o time trabalhando — **não é broadcast** |
| `/review` | `<instrução>` · `note` · `metrics` · `audit` · `history` | Evolução do processo do time — **só no repositório-fonte do plugin** |

**Os três últimos modos do `/team` são fatias do `cycle`**, para quando você não quer o ciclo inteiro: `plan <T-ID>` só planeja, `build <T-ID>` só constrói (exige plano existente) e `qa <T-ID>` só valida.

**Os três `prototype` são artefatos diferentes**, e o segundo termo diz qual: sem argumento é o **protótipo funcional do produto** (portão ①); `sprint <n>` é o **protótipo costurado do sprint** (portão ③); `screen <tela>` é uma **tela isolada**, exploração no detalhamento, sem portão próprio.

**Duas unidades, dois donos, dois momentos.** A **História** é a unidade de valor: escrita e detalhada pelo PO, e aprovada por você **no pacote de abertura do sprint**, junto com as demais (portão ③, em lote). A **Task** é a unidade de trabalho: nasce da quebra da História na Planning Meeting e carrega o Plano de Implementação do Arquiteto. Comando que recebe `<H-ID>` opera sobre valor; comando que recebe `<T-ID>` opera sobre trabalho.

**`/sm review` não é `/review`.** O primeiro é a Sprint Review, roda no projeto e é onde você aceita as Histórias. O segundo evolui o processo do time e roda só no repositório-fonte do plugin.

**Se um comando não resolver, tente com o prefixo do plugin.** `/dev`, `/sm`, `/arc`… são os nomes curtos. Quando a sua instalação tem mais de um plugin declarando o mesmo nome de comando, o Claude Code exige o prefixo para desambiguar: **`/team:dev`, `/team:sm`, `/team:review`**. Os dois nomes apontam para o mesmo comando; este guia usa o curto. O nome curto volta a funcionar sozinho quando não há colisão.

**O `/review` é diferente de todos os outros:** ele não trabalha no projeto — evolui os **documentos do plugin** (o processo do time). Roda só num clone do repositório do plugin; contra a cópia instalada num projeto, a mudança é sobrescrita no próximo `claude plugin update`. Melhoria de operação percebida trabalhando num projeto é anotada como sintoma e levada ao `note.md` do repositório do plugin, que é a fila do `/review`. Todo o resto opera no produto e registra em `.team-project/` ou nos documentos do projeto.

**`.team-project/note.md` é a fila equivalente, mas do produto, não do processo.** Ao longo do uso, anote ali cada problema que encontrar — um item por linha, na seção **Abertas**. Escreva **sintoma, não solução**: "depois de salvar duas vezes seguidas em X, a tela trava", nunca "corrigir o timeout de X" (isso já é diagnóstico, que é do time) nem "bug: endpoint Y retorna 500" (isso já é solução técnica). Quando quiser, rode **`/po note`**: o PO lê a fila inteira, classifica cada item (defeito · mudança de escopo disfarçada de bug · dúvida de uso) contra o que foi aprovado e aceito, aciona quem resolve, e devolve a você, item a item, o que fez com cada um. **Item tratado sai da fila** — passa a viver só no destino (registro da QA, Product Backlog, ou a resposta já dada), nunca duplicado nos dois lugares. Para um relato avulso, sem esperar o lote, use `/po bug <relato>` na conversa. Não confunda com `RAIZ/note.md`: aquele é a fila do `/review`, que evolui como o **time** trabalha; este é a fila do `/po note`, que evolui o **produto** que o time constrói para você.

## O ciclo do sprint — você é chamado duas vezes, e sabe quando

O time não para a cada História para pedir aprovação, e também não some até o fim. O **sprint** é a unidade de aprovação e de entrega, e você tem **dois compromissos por sprint**.

**1 · A abertura — você navega e aprova o pacote.** Depois de o time planejar (`/sm sprint plan`), você recebe quatro coisas juntas:

- o **Sprint Backlog fechado** — que Histórias entraram, quebradas em Tasks, com estimativa e objetivo;
- os **critérios de aceite** dessas Histórias — é contra eles que a Review vai medir;
- o **protótipo navegável do sprint** — as telas dessas Histórias costuradas num caminho que você atravessa;
- o **`planning.md`** — inclusive **o que veio da Review anterior e não entrou, com o motivo**.

Você navega e aprova. **Essa aprovação é o portão ③ de todas as Histórias do sprint, de uma vez**, e é o que faz o sprint arrancar — nenhuma Task entra em construção antes dela. Pode devolver: o PO reordena, o corte é refeito, o pacote volta.

**Por que o protótipo, e não só a lista.** Aprovar critérios lendo é aprovar uma descrição — o mesmo motivo que sustenta o portão ①. E ele prova que o sprint entrega **valor real**: se você não consegue atravessar um fluxo ponta a ponta, o sprint entrega meio caminho, e o time refaz o corte antes de começar.

**2 · A Review — você decide, por História.** O PO demonstra cada História contra os critérios que você aprovou e escreve o dossiê critério a critério; o QA fornece a evidência por Task; **você decide**: aceita · aceita com ressalva · rejeitada. Ressalva, gap e erro viram entrada no Product Backlog na mesma sessão, com dono — e a priorização deles volta a você no pacote do sprint seguinte, sem gate novo.

**Entre os dois, o time roda sozinho** (`/team cycle sprint`). Não é silêncio: `/po status` responde a qualquer momento onde o time está. O que some é a fila de aprovações, não a informação.

**Quando o time te chama fora disso.** Bloqueio não sobe direto: **PO e Arquiteto conversam primeiro** — a pergunta quase sempre é "o requisito está errado ou o desenho está?", e eles são donos das duas respostas. Só o que eles não fecham chega a você, com opções descritas e recomendação. **Exceção:** decisão estratégica — stack, provedor, custo, risco aceito — vem direto, porque é sua por definição e ninguém mais pode tomá-la.

**Onde fica o registro.** Tudo o que um sprint produz vive em `.team-project/sprints/<n>/`: o planejamento, o quadro, as Histórias como foram aprovadas, os planos, as evidências, o consumo, o burndown, a Review e a retrospectiva. Qual é o sprint corrente está em `.team-project/README.md` §2.

## Quatro caminhos de entrada

### A · Projeto novo, do zero

Ideia sua, sem documentação nenhuma.

```
/team init                      cria .team-project/ e o contexto
/team brainstorm <ideia>        fase 1: você + PO + UX (funcional)
                                fase 2: entra o Arquiteto (viabilidade)
                                fecha quando não há objeção bloqueante
/po requirement <ID>            o brief vira requisito com critério verificável
/ux prototype                   protótipo funcional em HTML dos fluxos principais
                                ① você NAVEGA o protótipo e aprova o SDD funcional
                                ② o Arquiteto escreve o SDD técnico e você aprova
/po story <H-ID>                o requisito vira História; depois, detalhada
/ux screen <H-ID>               especificação de tela, se a História tem interface
/sm sprint plan                 Planning: o time quebra em Tasks, estima e varre bloqueios
/ux prototype sprint <n>        as telas do sprint costuradas num caminho navegável
                                ③ você navega e aprova o PACOTE do sprint
/team cycle sprint              o time roda a fila inteira, sem te acionar
/sm review                      Sprint Review: ④ você decide, por História
/sm sprint close                retrospectiva e fim do sprint
```

O `brainstorm` existe porque ideia sem documentação não deve virar requisito por um papel só: a inviabilidade técnica apareceria só na construção. Ideia em área **já documentada** pula o brainstorm e vai direto a `/po analyze`.

### B · Projeto que já existe (retomada)

Há código, e a documentação pode não corresponder a ele.

```
/sm onboarding                  o time lê tudo e diz o que falta
/qa audit                       cruza documentos com o código real
/qa baseline                    reproduz os números declarados (build, testes, cobertura)
/po story <H-ID>                o que a auditoria achou vira História, com valor declarado
/sm sprint plan                 Planning: as Histórias aprovadas viram Tasks estimadas
```

**Comece pela auditoria, não pelo plano.** O `status` de um projeto retomado costuma declarar mais pronto do que o código sustenta; o levantamento sobre código vence a narrativa, e a divergência vira risco no quadro.

### C · Corrigir um bug

Duas entradas, conforme **quem acha** o defeito.

```
/po bug <relato>                você relata, o PO classifica (defeito · escopo · dúvida de uso)
                                 defeito confirmado pela QA vira o achado com arquivo:linha
/arc question <dúvida>          se a causa não é óbvia: diagnóstico com evidência
/arc plan <ID>                  correção desenhada, não improvisada
/dev <ID>                       executa o plano
/qa <T-ID>                      veredito ✅/⚠️/❌
/sm close <T-ID>                fecha a Task; o aceite vem na Sprint Review
```

O time também abre defeito direto quando **acha durante o próprio trabalho** — QA numa validação, dev implementando, Arquiteto numa revisão —, sem passar por você nem pelo PO: vai direto ao registro da QA, pelos canais que já existem, e segue a mesma escada de correção a partir de `/arc plan`. `/po bug` é a porta de entrada só para o que **você** relata.

**Achado não volta sempre para o mesmo lugar.** A escada:

| Degrau | Quando | Para onde |
|---|---|---|
| **1 · Construção** | Correção local que cabe no plano aprovado, sem redesenho | `/dev resume <ID>` |
| **2 · Outro dono** | O achado é do domínio de outro papel — o QA classifica pelo objeto e entrega | `/po` · `/arc question` · `/ux` |
| **2b · Não dá para classificar** | O achado toca dois donos e o QA não sabe qual é o objeto (ex.: requisito errado *ou* implementação errada) | `/sm agreement <questão>` |
| **3 · Especialista** | O desenho não sustenta o requisito — o passo não existia ou estava errado | `/arc question` ou `/arc plan` |
| **Paralelo · PO** | A dúvida é se o **critério** estava certo | `/po` |

### D · Melhoria em projeto existente

```
/po analyze <ideia>             se a área já é documentada
/team brainstorm <ideia>        se é capacidade nova, sem cobertura
/po impact <mudança>            o que essa mudança custa e quebra
/arc plan <ID>  →  /team cycle <ID>
```

`/po impact` antes de planejar: mudança de escopo passa por análise de impacto antes de virar Task.

## Regras que valem em qualquer caminho

- **Você não aprova o SDD funcional lendo — você navega o protótipo** (portão ①). Ler texto é aprovar uma descrição; a divergência entre o que você imaginou e o que o time entendeu só aparece quando você atravessa o fluxo. Ali o que se joga fora é HTML; depois, é arquitetura e código.
- **Toda Task pertence a uma História, e nenhuma Task entra em construção antes de o pacote do sprint ser aprovado** (portão ③, agora em lote). Trabalho técnico sem valor declarado não entra.
- **Sem plano, sem código.** O dev executa o Plano de Implementação do Arquiteto; lacuna vira 🔺 GAP, não improviso.
- **Nada é "pronto" sem saída real de comando.** O que não foi exercitado é declarado como não exercitado, nunca omitido.
- **O QA reprova, não corrige.** O veredito responde ao stakeholder sobre qualidade, segurança, desempenho, consistência e funcionalidade; o **aceite de valor** é do PO, por História, na Sprint Review.
- **Fechar uma Task não é aceitar a História.** O `/sm close` é técnico. Se a História for rejeitada na Review, todas as Tasks dela voltam — inclusive as que passaram no QA.
- **O sprint não cresce depois da Planning.** Pedido novo no meio do sprint vai ao Product Backlog e concorre na Planning seguinte.
- **Cada papel escreve só o que lhe pertence.** Requisito e História são do PO; desenho, ADR e standards são do Arquiteto; Sprint Backlog e status são do SM; evidências e mapa de código são do QA; código é do dev.
- **Dúvida funcional vai ao PO, técnica ao Arquiteto, estratégica ao stakeholder.**

## Onde cada coisa mora

| Camada | Diretório | Muda por |
|---|---|---|
| Processo do time | o plugin (`${CLAUDE_PLUGIN_ROOT}`) | só o `/review`, no repositório-fonte do plugin |
| Contexto e controles do projeto | `.team-project/` | o trabalho normal do time |
| Entregáveis do produto | `docs/` do projeto (SDD, ADR, implementação) | os donos declarados em `deliverables/README.md` |
| Código | o diretório de código do projeto | só o dev, e só os arquivos do plano vigente |

## O que o `/team init` cria no seu projeto

Uma pasta só, `.team-project/`, na raiz. **Nada fora dela é tocado** — o time não mexe na estrutura do seu código.

```
.team-project/
├── README.md              contexto do projeto · declara o SPRINT CORRENTE (§2)
├── how-to.md              cópia deste guia, atualizada a cada /team update
├── note.md                sua fila de relatos — escreva o sintoma, o PO trata em /po note
│
├── sprints/               O REGISTRO DE EXECUÇÃO, um subdiretório por sprint
│   └── 1/ 2/ 3/ …
│       ├── planning.md              o que foi decidido na Planning, e o que NÃO entrou
│       ├── sprint-backlog.md        o quadro vivo do sprint — fecha no encerramento
│       ├── stories/                 as Histórias como você as aprovou (congeladas)
│       ├── plan/                    um Plano de Implementação por Task
│       ├── evidence/                a evidência de cada Task: comando e saída real
│       ├── consumption.md           tokens e duração por invocação
│       ├── burndown.md              estimativa restante, em série datada
│       ├── review.md                a Sprint Review e o seu veredito por História
│       └── retrospective.md         o que o time corrige no sprint seguinte
│
├── product-owner/         context.md · product-backlog.md (índice) · stories/ (fonte viva)
├── scrum-master/          context.md
├── architect/             context.md · spikes/ (investigações técnicas)
├── user-experience/       context.md · prototype/ (+ prototype/sprint-<n>/) · journeys/ · screens/
├── developer/             context.md
└── quality-assurance/     context.md · baseline.md (a régua de regressão do projeto)
```

**Por que o registro de execução é por sprint, e não por papel.** Um sprint produz artefatos de quatro donos — Histórias (PO), planos (Arquiteto), evidências (QA) e os documentos do SM. Guardados por papel, responder *"o que aconteceu no sprint 3?"* exigiria abrir quatro pastas e cruzar datas. Em `sprints/3/` está tudo: o que foi planejado, o que você aprovou, como foi construído, com que evidência, o que você aceitou e o que o time decidiu corrigir. **O dono continua declarado por subpasta** — o SM não escreve em `plan/`, o Arquiteto não escreve em `stories/`.

**Sprint fechado não se edita.** Depois da retrospectiva, a pasta vira registro histórico. O `/team update` nunca reconcilia estrutura nova dentro dela: o `review.md` de um sprint antigo retrata aquele sprint, não o processo de hoje.

**O que fica fora da pasta do sprint, e por quê:** o Product Backlog e as Histórias vivas, o SDD, as ADRs, o registro de GAPs, o mapa de código, a baseline e o protótipo funcional do ① — todos **somam ou evoluem através** dos sprints, e fatiá-los quebraria a leitura contínua que o time faz deles.

**As pastas de papel guardam só o `context.md`** — o que aquele papel precisa saber sobre *este* projeto (stack, convenções, comandos de verificação, limitações) — mais os artefatos vivos que não pertencem a um sprint específico.

**Onde está o quadro de hoje:** `.team-project/README.md` §2 declara o **sprint corrente**. Como o Sprint Backlog vive dentro da pasta numerada, essa linha é o índice — é por ela que todo papel acha o quadro vivo.

**Na atualização do plugin**, o `/team update` reconcilia esta estrutura com a versão nova: substitui o que é cópia literal (este guia), **propõe** o delta do que tem conteúdo seu, e nunca apaga nada sem sua aprovação.
