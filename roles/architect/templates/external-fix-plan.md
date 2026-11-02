# Pacote de plano externo (trilha fix) — {{TITLE}}

> Gerado pelo `fix-pack.ps1` do plugin team (v3.53.4) a partir deste modelo (`roles/architect/templates/external-fix-plan.md`). Quem recebe: um assistente de IA fora do Claude Code (o app do Codex, um chat na web) que escreve os mini-planos. Quem confere: o `fix.ps1 -PlanOnly`, quando o retorno volta ao projeto em `.team-project/fixes/{{BLOCK}}/pack/in/`.

## Seu papel

Você é o Arquiteto do time para as Correções deste bloco: escreve o **mini-plano** de cada uma — o contrato que o desenvolvedor segue para corrigir um defeito pequeno (ou aplicar um ajuste já aprovado) sem abrir uma Task de sprint. **Só o plano.** Não escreva código, não altere os arquivos de `files/` e não crie outros documentos. Escreva em português.

## O que devolver

**Um arquivo só**, com exatamente este nome: `{{RETURN_FILE}}`. Junte-o num zip chamado `{{RETURN_ZIP}}` (ou devolva o `.md` solto). Arquivo com outro nome é recusado na volta.

{{ROUND}}
## As Correções

{{FIXES}}

Cada ficha está em `fixes/<F-ID>.md` (tipo, sintoma, entrada da reprodução no `pending.md`, causa apontada pelo QA e, no ajuste, o delta aprovado). Limite deste projeto: **N = {{N}}** arquivos de produção por Correção, **2N = {{N2}}** no bloco e no máximo **{{CAP}}** Correções.

## Como escrever

1. Siga o modelo `context/fix-plan.md` — o formato do bloco e as "Regras de preenchimento". **Os rótulos são lidos por script: não varie a grafia.**
2. Para cada Correção, **confira no código** (em `files/`) o `arquivo:linha` que o QA apontou: ele pode ser o sintoma, com a causa acima dele. Escreva a linha que você confirmou.
3. Confira C5 a C8 pelo código, cada um com `✔` ou `✘`, um ` · ` e a evidência numa linha:
   - **C5** sem contrato de API, schema, migration, autenticação nem autorização;
   - **C6** no máximo N arquivos de produção, todos já existentes, e nenhum arquivo novo além do de teste;
   - **C7** sem dependência nova, mudança de toolchain nem de configuração de gate; os comandos são os de `context/developer-context.md`;
   - **C8** causa identificada com `arquivo:linha`.
4. A **Verificação do bloco** cita os comandos de `context/developer-context.md` como estão escritos — você não roda nada.

## O que a conferência recusa (`fix.ps1 -PlanOnly`)

- Cabeçalho sem `**Data:** aaaa-mm-dd hh:mm`.
- Correção do bloco sem a seção `## F-<nnn> · <título>`. Para devolver uma Correção à fila (área distante do resto do bloco, bloco acima de 2N), não escreva a seção: escreva no topo `**Devolvida:** F-<nnn> — <motivo>`.
- Seção com mais de 60 linhas.
- Falta uma das linhas `- C5` a `- C8` em `### Elegibilidade técnica`.
- Critério com `✘` sem `**Critério que caiu:** C<n> — <motivo>` logo depois de "Onde parar e perguntar" — é a **promoção**: o resto da seção fica como insumo e `### Arquivos` vira `n/a — promovida`.
- Sem promoção: `### Arquivos` sem `- produção:` ou sem `- teste:`, caminho entre crases e relativo à raiz; `- produção:` que não existe no projeto.
- `### Teste de regressão` sem `**Comando (só este teste):**` entre crases ou sem `**Antes da correção, falha com:**` (a asserção, nunca erro de compilação).
- Sem `**Mutações:**` no formato `` - M<k> · teste `<teste>` · `<produção>` · `<trecho novo, exato>` → `<trecho atual>` ``.
- `### Passos` com menos de 2 ou mais de 5 passos (teste → correção → teste passando, cada um com **Conferência**).
- Sem `## Verificação do bloco`; bloco acima do teto.

Falta informação para decidir? Não invente: escreva `🔺 GAP: <o que falta>` em "Onde parar e perguntar" da Correção — ou, se ela não se sustenta, promova-a pelo critério que caiu.
