# Template — Mini-planos do bloco (trilha `fix`, R33)

Salvo em `.team-project/fixes/B-<nnn>/plan.md` — **um arquivo por bloco, um mini-plano por Correção** (`F-<nnn>`). Escrito por mim numa **única invocação por bloco**, dentro do `/sm fix plan`; tocado de novo só no `/sm fix run`, para **revalidação** (D9), resposta a 🔺 GAP ou promoção. Roteiro: [`../README.md`](../README.md) §"Trilha `fix`" · fluxo: `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/fix-run.md` §Plan · §Run.

É o **contrato entre mim e o dev** para cada Correção, como o [Plano de Implementação](implementation-plan.md) é para a Task: o que não estiver aqui vira 🔺 GAP, nunca improviso. **Não substitui o plano completo** — Correção que não cabe neste formato não é Correção.

> **`- produção:` / `- teste:` também são lidos pela guarda G9** (`hooks/pre-tool.ps1`): no `fix run`, o dev só escreve no produto os caminhos entre crases dessas linhas, da F-ID em execução (ou do bloco). Arquivo que um 🔺 GAP acrescentar entra em `### Arquivos` — senão o dev é barrado.
>
> **Os rótulos abaixo são lidos pelo script C4** (`scripts/checks/fix.ps1`) — **não varie a grafia**, não traduza, não acrescente rótulo em negrito novo nas linhas que ele lê: `**Data:**` com `aaaa-mm-dd` (a revalidação usa a data); `## F-<nnn>` (conta as Correções do teto); `- C5 ✔ · …` a `- C8` (assinatura técnica); `- produção:` / `- teste:` sob `### Arquivos` (limite N e teto 2N); `**Critério que caiu:** C<n> — <motivo>` (promoção); `### Revalidação`.

```markdown
# B-<nnn> · mini-planos
**Data:** aaaa-mm-dd hh:mm · **Correções:** F-<nnn>, F-<nnn> · **Área:** <módulo(s)>

## F-<nnn> · <título>
**Tipo:** defeito | ajuste · **Ficha:** fixes/F-<nnn>.md
### Elegibilidade técnica
- C5 ✔ · <evidência>
- C6 ✔ · <evidência>
- C7 ✔ · <evidência>
- C8 ✔ · <evidência>
### Causa
<arquivo:linha + por que diverge>
### Arquivos
- produção: <caminho>
- teste: <caminho>
### Teste de regressão
**Nome:** <nome do teste> · **Afirma:** <o comportamento do SDD/requisito, uma frase>
**Comando (só este teste):** `<comando de .team-project/developer/context.md, filtrado a este teste>`
**Antes da correção, falha com:** <a asserção que deve falhar — nunca erro de compilação ou símbolo ausente>
### Passos
1. **CRIAR | ALTERAR** `<caminho do teste>` — <o teste acima, literal no essencial>; rodar o comando → exit ≠ 0 com a asserção acima
   **Conferência:** <o teste existe no arquivo, com o nome literal; a saída "antes" do relatório mostra a asserção esperada>
2. **ALTERAR** `<caminho de produção>` — <trecho atual → trecho novo, ou a assinatura literal>
   **Conferência:** <o que o QA observa no diff da F-ID, sem julgar desenho>
3. Rodar o comando do teste → exit 0; build do módulo (comando de "Verificação do bloco") sem aviso novo
   **Conferência:** saída "depois" exit 0 no relatório; diff da F-ID só com os arquivos de `### Arquivos`
### Standard aplicável
`${CLAUDE_PLUGIN_ROOT}/standards/<arquivo>.md` §<n> — <a obrigação em uma linha> | nenhuma — <por quê>
### Onde parar e perguntar
- <ponto específico desta Correção>
- *(fixo)* Precisar de arquivo fora de `### Arquivos`, de arquivo novo além do teste, de dependência, de mudança de contrato/schema/autorização ou de configuração de gate: 🔺 GAP — é C5–C8 caindo, e a resposta pode ser a promoção desta F-ID
- *(fixo)* O teste de regressão **passa** antes da correção, ou falha por outro motivo que não a asserção declarada: 🔺 GAP — a causa não é a desta seção (C8)
**Critério que caiu:** C<n> — <motivo>      (só em promoção)
### Revalidação
n/a — sem mudança

## Verificação do bloco
**Fonte (R26 por citação):** `.team-project/developer/context.md` §<seção> — comandos como estão escritos lá; nenhuma medição nova
| Comando | Para quê | Quando |
|---|---|---|
| `<build do módulo>` | build sem aviso novo | dev, ao fim de cada F-ID (log redirecionado, isento de `report`) |
| `<suíte do módulo>` | suíte do módulo verde | dev pelo `operator`, uma vez, depois da última F-ID |
| `<gate de cobertura do módulo>` | 80% no módulo tocado | dev pelo `operator`, uma vez, junto da suíte |
```

## Regras de preenchimento

1. **Teto de 60 linhas por F-ID**, contadas do `## F-<nnn>` até o próximo `## `. Mini-plano que não cabe — inclusive depois de revalidação ou de resposta a 🔺 GAP — **não é Correção**: promovo pelo critério que o excesso revela (em regra C6 — escopo — ou C8 — causa difusa).
2. **`**Data:**` é data e hora do fechamento do mini-plano**, no formato `aaaa-mm-dd hh:mm`. É a partir dela que a sessão confere, no `fix run`, se algum arquivo da F-ID mudou (D9). Não a atualizo na revalidação — a revalidação tem a própria data, na seção dela.
3. **C5–C8 conferidos com o código real**, não com a ficha nem com a reprodução: cada linha leva `✔` ou `✘`, um ` · ` e a evidência em uma linha (`arquivo:linha`, a contagem de arquivos × N, o comando já validado). Critérios (R33 · `fix-run.md` §Elegibilidade): **C5** sem contrato de API, schema, migration, autenticação nem autorização; **C6** no máximo N arquivos de produção (N em `.team-project/README.md`, "Limite de arquivos por Correção (N)"; padrão 5) e nenhum arquivo novo além do teste; **C7** sem dependência nova, mudança de toolchain nem configuração de gate; **C8** causa identificada com `arquivo:linha`.
4. **Causa (C8):** no **defeito**, parto do `arquivo:linha` que o QA registrou no `pending.md` na reprodução (a ficha aponta a entrada) e **confiro no código** que ele explica o sintoma — o ponto do QA pode ser o sintoma, e a causa estar acima dele; escrevo a linha que eu confirmei. No **ajuste**, a causa é o ponto do código que implementa o requisito **antes** do delta da ficha (já confirmado em formulário). Sem causa confirmada, é investigação, não Correção: `C8 ✘` e promoção.
5. **`### Arquivos` é lista fechada**, um caminho por linha, entre crases, **relativo à raiz do repositório e com `/`** — é a forma que o C4 compara com o commit da F-ID. `- produção:` só para arquivo que **já existe** (C6); `- teste:` para o arquivo do teste de regressão (pode ser novo). Nada de diretório, curinga nem "e afins". Caminho com espaço não é lido pelo C4: declaro o caso em "Onde parar e perguntar" e aviso a sessão.
6. **Teste de regressão é o primeiro passo**, e tem de **falhar pela asserção declarada** antes da correção — falha de compilação, de import ou de símbolo ausente não prova o defeito. O comando é o de teste do `context.md` do dev **filtrado a este teste**; se o `context.md` não diz como filtrar, isso é configuração faltando e a Correção cai em C7.
7. **Passos: de 2 a 5**, na ordem teste → correção → teste passando; cada passo com **CRIAR** (só o teste) ou **ALTERAR**, o arquivo, a mudança literal e a linha **Conferência** — a mesma régua da regra 13 do [plano completo](implementation-plan.md): o QA marca conforme/divergente sem julgar desenho.
8. **Standard aplicável:** só a seção que a mudança toca, com número; "nenhuma" com o motivo. Trecho que lê escopo do usuário ou dado pessoal (não sensível — o sensível já caiu no C4 do PO) cita a seção de `implementation-security-lgpd-copyright.md` aplicável.
9. **R26 se cumpre por citação:** "Verificação do bloco" cita os comandos de `.team-project/developer/context.md` como estão escritos — já validados no projeto —, sem seção de ambiente medido e **sem chamada ao `operator`** no `fix plan`. Correção que exigiria medir ambiente, mudar toolchain ou escrever comando que o `context.md` não tem **não é elegível** (C7 ✘). Por isso este modelo não tem seção "Execução delegada".
10. **Promoção** (qualquer etapa): a linha do critério vira `✘`, `**Critério que caiu:** C<n> — <motivo>` entra **logo depois** de "Onde parar e perguntar", e o resto do mini-plano fica como insumo do Plano de Implementação. Na promoção **no `fix plan`**, `### Arquivos` fica com `n/a — promovida` (os caminhos que identifiquei vão na Causa): o C4 soma `- produção:` de toda seção `## F-` para o teto 2N. **Nunca** acrescento linha `- produção:` para registrar o arquivo que faria a F-ID estourar C6 — ele vai no motivo. Sem promoção, a linha `**Critério que caiu:**` **não existe** (não deixar o modelo em branco).
11. **Devolvida à fila** (área distante do resto do bloco, ou bloco acima de 2N arquivos de produção): a F-ID **sai do arquivo** — sem seção `## F-`, fora de `**Correções:**` — e o motivo vai na minha resposta, para a sessão devolvê-la a **triada** em `fixes.md`. Devolver não é promover: os critérios dela continuam valendo.
12. **Revalidação** (só no `fix run`, D9): `n/a — sem mudança` até lá. Revalidada, a seção traz `aaaa-mm-dd hh:mm`, o que mudou no código (`arquivo:linha`, commit ou Task que o tocou) e o que o mini-plano passou a dizer; Causa, Arquivos e Passos são corrigidos **no lugar**, e C5–C8 reconferidos. "n/a" depois de arquivo alterado é aviso do C4.
13. **Resposta a 🔺 GAP no `fix run`** entra no mini-plano da F-ID — no passo que ela altera, com `(GAP <data>: <decisão>)` —, como no plano completo (R9). Decisão que quebra C5–C8 é promoção (regra 10), não passo novo.
14. **Uma F-ID, um mini-plano.** Nada de passo compartilhado entre F-IDs nem "mesma mudança da F-<nnn>": cada uma é desfeita sozinha pelo diff isolado dela (R33).

## Exemplo abreviado

```markdown
# B-003 · mini-planos
**Data:** 2026-10-03 14:20 · **Correções:** F-011, F-014 · **Área:** cadastro

## F-011 · Data de nascimento aceita data futura
**Tipo:** defeito · **Ficha:** fixes/F-011.md
### Elegibilidade técnica
- C5 ✔ · validação interna; contrato `POST /clientes` inalterado (05-api-model §3)
- C6 ✔ · 1 arquivo de produção (N=5), nenhum novo além do teste
- C7 ✔ · sem dependência; comandos de `developer/context.md` §Comandos
- C8 ✔ · `src/cadastro/validacao.ts:42` — compara com `null`, nunca com a data de hoje (QA apontou :57, que é o sintoma)
### Causa
`src/cadastro/validacao.ts:42` — o requisito RF-07 proíbe data futura; a regra só testa ausência.
### Arquivos
- produção: `src/cadastro/validacao.ts`
- teste: `src/cadastro/validacao.test.ts`
### Teste de regressão
**Nome:** `nascimento_futuro_rejeitado` · **Afirma:** data de nascimento posterior a hoje é rejeitada (RF-07)
**Comando (só este teste):** `<comando de teste> -t nascimento_futuro_rejeitado`
**Antes da correção, falha com:** `expected false, received true`
### Passos
1. **ALTERAR** `src/cadastro/validacao.test.ts` — acrescentar `nascimento_futuro_rejeitado`; rodar → exit ≠ 0
   **Conferência:** teste com o nome literal no arquivo; "antes" mostra `expected false, received true`
2. **ALTERAR** `src/cadastro/validacao.ts:42` — `if (!nascimento)` → `if (!nascimento || nascimento > hoje())`, com `hoje` já importado em `:3`
   **Conferência:** linha 42 com a condição literal; nenhum outro trecho do arquivo no diff
3. Rodar o teste → exit 0; build do módulo
   **Conferência:** "depois" exit 0; diff da F-ID só com os dois arquivos acima
### Standard aplicável
nenhuma — validação de campo existente, sem regra de engenharia nova
### Onde parar e perguntar
- `hoje()` não existir em `:3` como descrito
### Revalidação
n/a — sem mudança

## F-014 · Busca por CPF ignora pontuação
**Tipo:** defeito · **Ficha:** fixes/F-014.md
### Elegibilidade técnica
- C5 ✘ · o filtro vive na consulta do repositório e exige índice novo (`04-data-model` §2)
- C6 ✔ · 2 arquivos de produção
- C7 ✔ · sem dependência
- C8 ✔ · `src/cadastro/repositorio.ts:88`
### Causa
`src/cadastro/repositorio.ts:88` — compara o texto cru; normalizar exige índice sobre a coluna normalizada.
### Arquivos
n/a — promovida
### Onde parar e perguntar
**Critério que caiu:** C5 — corrigir exige mudança de schema (índice)
### Revalidação
n/a — sem mudança

## Verificação do bloco
**Fonte (R26 por citação):** `.team-project/developer/context.md` §Comandos
| Comando | Para quê | Quando |
|---|---|---|
| `<build do módulo>` | build sem aviso novo | dev, ao fim de cada F-ID |
| `<comando de teste> src/cadastro` | suíte do módulo | dev pelo `operator`, uma vez |
| `<cobertura> src/cadastro` | 80% no módulo | dev pelo `operator`, uma vez |
```
