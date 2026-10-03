# `/team remote` — responder ao time pelo celular, um projeto por sessão

> Lido **apenas quando `/team` entra no modo `remote`**. Fica fora de `commands/team.md` pelo mesmo motivo de `init`, `update` e `version`: aquele arquivo é carga fixa de toda invocação de `/team`, e este roteiro roda uma vez por projeto. **Nenhum agente é disparado.** Regra: **R34** (`roles/scrum-master/process/working-rules.md`).

**O que este modo faz:** deixa o projeto pronto para o stakeholder **responder e retomar pelo Claude Code no celular**, por **Remote Control**: a sessão continua rodando nesta máquina, com o `.team-project/` local (R31), e o app do Claude conecta-se a ela. Sessão na nuvem não serve ao processo, porque não tem `.team-project/`.

**O que ele não faz:** ligar o Remote Control sozinho. `remoteControlAtStartup` no `settings` **do projeto** é ignorado (medido: só vale no nível do usuário, "for all sessions"), e o *push* é configuração do app. Isso é do stakeholder; o modo diz o comando certo e confere o que dá para medir.

## 1. Identificador e conta

Leia a §1 do `.team-project/README.md`:

```markdown
**Identificador remoto:** <ID>        <!-- 3–8 letras maiúsculas, único entre os projetos do stakeholder -->
**Conta remota:** pessoal | organização
**Verificação remota:** <aaaa-mm-dd>   <!-- data da verificação de ponta a ponta (passo 6); vazio = configurado, não verificado -->
```

- **Sem identificador:** proponha um a partir do nome do produto (3–8 letras, maiúsculas) e pergunte em formulário (R22), com a via de pedir mais contexto por último. **Único entre os projetos** do stakeholder: pergunte se já usa esse ID em outro projeto.
- **Conta remota** (decisão do stakeholder, por projeto): **pessoal** ou **organização**. A mesma conta vale para o Remote Control e para o artifact do protótipo (D5 — um artifact só abre para a conta que o publicou). **LGPD:** projeto com dado de cliente só na conta que o contrato permite; diga isso na pergunta.
- Grave as três linhas na §1 (a terceira vazia). **A partir daqui, a guarda G3 exige em todo formulário deste projeto o prefixo `[<ID> · <onde> · <ponto>]` e a pendência gravada antes em §7** (R34) — inclusive o formulário de teste do passo 6.

## 1a. Ambiente

Remote Control só roda no **`claude` pelo terminal**. Na extensão do VS Code a resposta é `/remote-control isn't available in this environment.` — diga isso antes de imprimir o comando de abertura.

## 2. Pré-requisitos que dá para medir (saída real — R7)

| Item | Comando | Atende |
|---|---|---|
| Versão do Claude Code | `claude --version` | ≥ `2.1.224` |
| Login por conta claude.ai, não chave de API | `/status` (ou a linha de conta do banner) | conta Pro, Max, Team ou Enterprise |
| Suspensão da máquina | `powercfg /query SCHEME_CURRENT SUB_SLEEP STANDBYIDLE` | **só reporte**: a suspensão derruba a sessão remota (R27). Mudar é decisão do stakeholder |
| Política da organização | `claude --remote-control "<ID> · teste"` (ou `/remote-control`) | se a resposta for `Remote Control is disabled by your organization's policy…`, reporte **literal**, como **bloqueio a resolver com o *owner*** (*claude.ai → Admin settings → Claude Code*). É observação do harness, não falha do plugin nem do stakeholder |

Item que falhar: reporte e pare no ponto em que ele bloqueia; os demais passos que não dependem dele seguem.

## 3. Pré-requisitos que o plugin não mede — lista para o stakeholder conferir

- App do Claude instalado no celular, **na mesma conta** da sessão (aba **Code**).
- Em Team/Enterprise, Remote Control habilitado pelo *owner*.
- **Não conte com notificação.** Medido no Android: o formulário **não gera push**, nem com o push ligado no Claude Code e a bateria do app sem restrição. Para ver o que espera, abra **App → Code**: o prefixo de cada pergunta diz de que projeto ela é.

## 4. Configuração local do projeto (só com confirmação)

Proponha acrescentar a `.claude/settings.local.json` **do projeto**:

```json
{ "env": { "CLAUDE_REMOTE_CONTROL_SESSION_NAME_PREFIX": "<ID>" } }
```

É só uma rede: sessão aberta **sem nome** aparece no app como `<id>-<palavra>-<palavra>`, em minúsculas. O nome legível vem do comando de abertura (passo 5). **Só acrescente**, nunca reescreva o arquivo; confira que `.claude/settings.local.json` está fora do git (`git check-ignore -q .claude/settings.local.json`; se não estiver, proponha a linha no `.gitignore` — R31). **Não** grave `remoteControlAtStartup`: no projeto ele é ignorado; ligar para todas as sessões é opção do usuário em `/config`, decisão do stakeholder, e você só a menciona.

## 5. Comando de abertura

Imprima, para colar num terminal **próprio deste projeto** (um projeto, uma sessão — duas sessões no mesmo `.team-project/` brigam pelo Sprint Backlog):

```powershell
claude --remote-control "<ID> · <produto>"
```

O nome passado chega ao app **como está** (maiúsculas, `·` e espaços preservados).

## 6. Verificação de ponta a ponta

Feita **na sessão aberta pelo comando do passo 5**, com o stakeholder no celular:

1. Grave em `README.md` §7 a pendência: `N. [<ID> · teste] O formulário chegou ao celular? — material: /team remote — <aaaa-mm-dd hh:mm>`.
2. Chame `AskUserQuestion` com a pergunta `[<ID> · teste] O formulário chegou ao celular?` e as opções **Chegou pelo celular** · **Respondi no terminal** · **Pedir mais contexto** (por último).
3. Resposta **"Chegou pelo celular"** → grave a data em `**Verificação remota:**`, tire a linha da §7 (vazia, fica `nenhuma`) e diga que o projeto está remoto. Outra resposta, `[No preference]` (o **Pular** do app) ou texto livre que não confirme → **não** grave a data: sem ela o projeto está configurado, não remoto; registre o que voltou, literal.

## 7. Feche

Em até seis linhas: identificador e conta; o que foi medido (versão, conta, suspensão, política); o comando de abertura; a data da verificação, ou por que ela não foi gravada; e três lembretes —

- **Não espere notificação**: abra **App → Code** para ver o que espera; o prefixo diz o projeto.
- **"Pular" não decide**: volta como `[No preference]`, e a pergunta continua pendente em §7.
- **Se a máquina suspender, a sessão cai**; nada se perde — a pendência está em §7 e volta ao reabrir o projeto.
