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

**4. Reinicie a sessão.** Não é detalhe: plugin só carrega na inicialização do Claude Code. Depois de reiniciar, verifique — `/plugin` mostra `team@team` como **enabled**, e `/help` lista os **8 comandos** (`/sm /po /arc /ux /dev /qa /team /review`) e os **6 agentes**. Se não listar, a instalação não pegou; volte ao passo 2.

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
| `/po` | `status` · `impact <mudança>` · `analyze <ideia>` · `requirement <ID>` · `story <H-ID>` · `prioritize` · `accept <H-ID>` | Product Owner — **o seu canal**: status, prazo, requisitos, Histórias, backlog, aceite |
| `/arc` | `plan <ID>` · `comply <ID>` · `adr <tema>` · `question <dúvida>` | Arquiteto — desenho, Plano de Implementação, ADR, standards |
| `/ux` | `prototype` · `journey <fluxo>` · `screen <nome>` · `prototype <tela>` · `review-ui <tela>` | UX — **protótipo funcional (portão ①)**, jornada, tela, usabilidade, acessibilidade |
| `/dev` | `<ID>` · `resume <ID>` · `gap <resposta>` | Desenvolvedor — executa o plano, não improvisa |
| `/qa` | `<ID>` · `baseline` · `audit` · `security <ID>` | QA — o veredito de qualidade que responde ao stakeholder |
| `/team` | `init` · `update` · `brainstorm <ideia>` · `cycle <T-ID>` · `plan <T-ID>` · `build <T-ID>` · `qa <T-ID>` | Orquestra o time trabalhando — **não é broadcast** |
| `/review` | `<instrução>` · `note` · `metrics` · `audit` · `history` | Evolução do processo do time — **só no repositório-fonte do plugin** |

**Os três últimos modos do `/team` são fatias do `cycle`**, para quando você não quer o ciclo inteiro: `plan <T-ID>` só planeja, `build <T-ID>` só constrói (exige plano existente) e `qa <T-ID>` só valida.

**Duas unidades, dois donos, dois momentos.** A **História** é a unidade de valor: escrita pelo PO, detalhada e aprovada por você antes de entrar no sprint. A **Task** é a unidade de trabalho: nasce da quebra da História na Planning Meeting e carrega o Plano de Implementação do Arquiteto. Comando que recebe `<H-ID>` opera sobre valor; comando que recebe `<T-ID>` opera sobre trabalho.

**`/sm review` não é `/review`.** O primeiro é a Sprint Review, roda no projeto e é onde você aceita as Histórias. O segundo evolui o processo do time e roda só no repositório-fonte do plugin.

**O `/review` é diferente de todos os outros:** ele não trabalha no projeto — evolui os **documentos do plugin** (o processo do time). Roda só num clone do repositório do plugin; contra a cópia instalada num projeto, a mudança é sobrescrita no próximo `claude plugin update`. Melhoria de operação percebida trabalhando num projeto é anotada como sintoma e levada ao `note.md` do repositório do plugin, que é a fila do `/review`. Todo o resto opera no produto e registra em `.team-project/` ou nos documentos do projeto.

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
/ux screen <H-ID>               protótipo, se a História tem interface
                                ③ você aprova o detalhamento
/sm sprint plan                 Planning: o time quebra em Tasks e estima
/arc plan <T-ID>                Plano de Implementação da Task
/team cycle <T-ID>              Arquiteto → dev → QA
/sm close <T-ID>                fecha a Task (técnico)
/sm review                      Sprint Review: ④ você aceita a História
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

```
/qa <ID>                        se já há Task: valida e produz o achado com arquivo:linha
/arc question <dúvida>          se a causa não é óbvia: diagnóstico com evidência
/arc plan <ID>                  correção desenhada, não improvisada
/dev <ID>                       executa o plano
/qa <T-ID>                      veredito ✅/⚠️/❌
/sm close <T-ID>                fecha a Task; o aceite vem na Sprint Review
```

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
- **Toda Task pertence a uma História, e nenhuma História entra no sprint sem a sua aprovação** (portão ③). Trabalho técnico sem valor declarado não entra.
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
