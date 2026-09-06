# Como usar o time

Guia do **stakeholder**. Vive no plugin — uma cópia serve todos os projetos e chega atualizada por `claude plugin update team@team`. O `.team-project/README.md` de cada projeto carrega só a versão operacional compacta, porque aquele arquivo é lido pelos agentes em toda invocação e precisa ser barato.

## Instalar em um projeto

```powershell
claude plugin marketplace add <caminho-ou-repo-do-time> --scope project
claude plugin install team@team --scope project -y
# reinicie a sessão — comandos e agentes só aparecem no próximo carregamento
/team init
```

`/team init` cria o `.team-project/` padrão e conduz o preenchimento. **Sem `.team-project/`, todo papel para e pede que ele seja criado** — é a fonte de contexto de projeto do time.

Manter atualizado:

```powershell
claude plugin marketplace update team    # sincroniza com a origem
claude plugin update team@team           # aplica (exige reiniciar a sessão)
```

## Os comandos

| Comando | Modos | Papel |
|---|---|---|
| `/sm` | `onboarding` · `status` · `plan` · `board` · `impact <mudança>` · `close <ID>` | Scrum Master — quadro, status, riscos, processo |
| `/po` | `analyze <ideia>` · `requirement <ID>` · `prioritize` · `accept <ID>` | Product Owner — requisitos, backlog, aceite de valor |
| `/arc` | `plan <ID>` · `comply <ID>` · `adr <tema>` · `question <dúvida>` | Arquiteto — desenho, plano de execução, ADR, standards |
| `/ux` | `journey <fluxo>` · `screen <nome>` · `prototype <tela>` · `review-ui <tela>` | UX — jornada, tela, usabilidade, acessibilidade |
| `/dev` | `<ID>` · `resume <ID>` · `gap <resposta>` | Desenvolvedor — executa o plano, não improvisa |
| `/qa` | `<ID>` · `baseline` · `audit` · `security <ID>` | QA — o veredito de qualidade que responde ao stakeholder |
| `/team` | `init` · `<mensagem>` · `brainstorm <ideia>` · `agreement <questão>` · `cycle <ID>` | O time inteiro |
| `/review` | `<instrução>` · `note` · `metrics` · `audit` · `history` | Evolução do processo do time — **só no repositório-fonte do plugin** |

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
/arc plan <ID>                  plano de execução da primeira fatia
/sm plan                        itens no quadro
/team cycle <ID>                UX → Arquiteto → dev → QA
```

O `brainstorm` existe porque ideia sem documentação não deve virar requisito por um papel só: a inviabilidade técnica apareceria só na construção. Ideia em área **já documentada** pula o brainstorm e vai direto a `/po analyze`.

### B · Projeto que já existe (retomada)

Há código, e a documentação pode não corresponder a ele.

```
/sm onboarding                  o time lê tudo e diz o que falta
/qa audit                       cruza documentos com o código real
/qa baseline                    reproduz os números declarados (build, testes, cobertura)
/sm plan                        backlog a partir do que a auditoria achou
```

**Comece pela auditoria, não pelo plano.** O `status` de um projeto retomado costuma declarar mais pronto do que o código sustenta; o levantamento sobre código vence a narrativa, e a divergência vira risco no quadro.

### C · Corrigir um bug

```
/qa <ID>                        se já há item: valida e produz o achado com arquivo:linha
/arc question <dúvida>          se a causa não é óbvia: diagnóstico com evidência
/arc plan <ID>                  correção desenhada, não improvisada
/dev <ID>                       executa o plano
/qa <ID>                        veredito ✅/⚠️/❌
/po accept <ID>  →  /sm close <ID>
```

**Achado não volta sempre para o mesmo lugar.** A escada:

| Degrau | Quando | Para onde |
|---|---|---|
| **1 · Construção** | Correção local que cabe no plano aprovado, sem redesenho | `/dev resume <ID>` |
| **2 · Time** | O achado atravessa mais de um papel, ou pode ser requisito mal formulado *ou* implementação errada | `/team <questão>` |
| **3 · Especialista** | O desenho não sustenta o requisito — o passo não existia ou estava errado | `/arc question` ou `/arc plan` |
| **Paralelo · PO** | A dúvida é se o **critério** estava certo | `/po` |

### D · Melhoria em projeto existente

```
/po analyze <ideia>             se a área já é documentada
/team brainstorm <ideia>        se é capacidade nova, sem cobertura
/sm impact <mudança>            o que essa mudança custa e quebra
/arc plan <ID>  →  /team cycle <ID>
```

`/sm impact` antes de planejar: mudança de escopo passa por análise de impacto antes de virar item.

## Regras que valem em qualquer caminho

- **Sem plano, sem código.** O dev executa o Plano de Execução do Arquiteto; lacuna vira 🔺 GAP, não improviso.
- **Nada é "pronto" sem saída real de comando.** O que não foi exercitado é declarado como não exercitado, nunca omitido.
- **O QA reprova, não corrige.** O veredito responde ao stakeholder sobre qualidade, segurança, desempenho, consistência e funcionalidade; o **aceite de valor** é do PO.
- **Cada papel escreve só o que lhe pertence.** Requisito é do PO; desenho, ADR e standards são do Arquiteto; quadro e status são do SM; evidências e mapa de código são do QA; código é do dev.
- **Dúvida funcional vai ao PO, técnica ao Arquiteto, estratégica ao stakeholder.**

## Onde cada coisa mora

| Camada | Diretório | Muda por |
|---|---|---|
| Processo do time | o plugin (`${CLAUDE_PLUGIN_ROOT}`) | só o `/review`, no repositório-fonte do plugin |
| Contexto e controles do projeto | `.team-project/` | o trabalho normal do time |
| Entregáveis do produto | `docs/` do projeto (SDD, ADR, implementação) | os donos declarados em `deliverables/README.md` |
| Código | o diretório de código do projeto | só o dev, e só os arquivos do plano vigente |
