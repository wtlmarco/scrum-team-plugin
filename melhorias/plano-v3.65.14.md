# Plano da v3.65.14 — o relatório do sprint 6 do garden, conferido

**Branch:** `fix/v3.65.14`, a partir de `develop` com a v3.65.13 mesclada (o PR da v3.65.13 vem antes). Os itens aprovados vão juntos.
**Origem:** `garden-management/.team-project/sprints/6/plugin-report.md`, de 22/11, com o plugin 3.65.12 instalado. Conferido contra o `run-log.md`, o `lessons.md`, o `consumption.md`, as decisões do S6 e o código atual do plugin.
**Status:** aprovado pelo stakeholder em 23/11, **todos os itens** de A a J, mais o I e o K (aviso do lint no plano). Na última pergunta ele marcou "Nenhum" junto com o I e o K; vale a escolha explícita dos dois. Ficam fora só a Q9 e a prova no aparelho, já tratadas.

## 0. O que a conferência mudou no relatório

| Item do relatório | Validade | O que a conferência achou |
|---|---|---|
| §3-1 "o `next` manda construir com o verify vivo" (3) | **causa errada** | O verify em processo próprio sem agente segue assim por desenho (v3.62.2, `run.ps1:1844`). No run-log, a Task A (Q-S6e, de 18 a 20/11) tem outro padrão: **6 "quedas de ambiente" seguidas**, cada uma com reparo do alvo e um dev novo, porque a queda não conta para o escalonamento (R27) e **não tem limite** (`run.ps1:1311`). Parte das quedas era o verify full que não terminava pelo prazo do Karma (D-26, "no message in 120000 ms"), um problema de teste dado como ambiente. → **item A** |
| §3-4 e lição 1, "cartão × plano" (5) | **quase todo já tratado** | D-4, D-8, D-12 e D-22 são de 14 a 17/11, antes da v3.64.0 (18/11), que separou o "o que já rodou" do "o que o plano manda" e trocou o "só completar a evidência" com a prova vermelha pelo modo dev. A regra 34 (v3.65.3) recusa a linha **Aceite:** fora das três formas. Fica um resíduo pequeno. → **item C** |
| §3-7 e §4-6, "o Vale para não casa" (5) | **válido** | 2 das 5 repetições são de casamento. A D-27 diz "toda Task de triagem de falhas do alvo no S6" e a K-17 diz "(Task com `npm run alvo:capturar` ou `prova-cdp.mjs` no passo de alvo)". As duas são condições em texto, que o casamento por ID ou glob não lê. As outras 3 chegaram ao cartão e não foram seguidas: é obediência do agente, fora do alcance desta entrega. → **item B** |
| §3-5 e lições 2 e 7, "falha do executor reprova a Task de correção" (2) | **válido em parte** | O `close.ps1` (R7-aceite, `close.ps1:593`) exige PASSOU em todos os cenários da linha **Cenários:** do plano. A Q-S6e listava 17 cenários, a maioria fora dos achados que ela corrigia. A saída que existe (o Arquiteto passar cenários a `(teste)`) só foi usada na 4ª rodada (03:55 de 20/11). A v3.65.13 já criou a causa `executor` no portão. → **item D** |
| §3-2 "Task superada sem destino" (1) | **válido, raro** | O `mark.ps1` só tem `-Reopen resume\|replan`, e o ✅ exige evidência. → **item E** |
| §3-6 "a G5 impede corrigir o lint" (1) | **não procede** | O caminho existe e funcionou: o GAP vai ao Arquiteto, o diff vai em **Arquivos protegidos:** e a sessão aplica (mensagem da G5). O `plan.ps1` já confere o arquivo protegido em **Arquivos tocados** (`plan.ps1:62`). O aviso só apareceu na construção. **Não tratar.** |
| §3-3 Q9 "TODO" em português | **já resolvido** | v3.65.1. Q1, Q6, Q8 e Q11 ficam com o projeto (`coveragePattern`). **Não tratar.** |
| §3-8 prova no aparelho (17 rodadas) | **já tratado, falta o campo** | v3.65.1, .2, .3, .6 e .13. Vale no S7. **Não tratar.** |
| §2-3 sessão principal com 47,6% | **válido, causa a medir** | São 64 sessões de 61 a 113 chamadas, com **contexto médio de 113 a 157 mil tokens por chamada**. O custo vem do contexto relido a cada chamada, não do número de rodadas. → **item G** (investigação com meta) |
| §2-4 a contagem do operator não fecha | **válido, só medição** | Não muda o trabalho do time. → **item I** (opcional) |
| (novo) ruído no formulário do fechamento | **válido** | No `lessons.md` §Propostas de configuração, todo GAP de origem "ambiente" recebe o mesmo sufixo "rever a chave de targets ou verify (ex.: seedTimeoutSec…)" (`knowledge.ps1:230`), até a Q9 e o executor. Os mesmos itens já estão em §Ocorrências de plugin, e a proposta de `runCommands` traz um caminho do cache do plugin 3.64.0. → **item F** |
| (novo) duração em "11508:59" | **válido, cosmético** | `Format-Duration` escreve minutos e segundos (`consumption.ps1:58`). São 191 h e 48 min, que o relatório leu como horas. → **item H** |

## 1. Itens propostos

### A · A queda de ambiente ganha limite (prioridade alta)
**Problema:** cada queda de ambiente repara o alvo e abre um dev novo, sem limite, porque não conta para o escalonamento. Na Task A foram 6 seguidas, com 14 rodadas e 20,3 M de tokens, e parte delas era um teste que estourava o prazo, não o ambiente.
**Proposta:** (`run.ps1 done -Result env`, `Update-DevCounter`)
- A 1ª e a 2ª queda do bloco seguem como hoje: reparo e dev novo.
- Na **3ª queda do bloco**, sem dev: o operator diagnostica se é ambiente ou é o comando da prova (teste que estoura o prazo, suíte que não termina). O diagnóstico vai a `operator/<n>/<ID>-ambiente.md`, com a linha `Veredito: AMBIENTE|PROVA`.
- Veredito PROVA: vai ao Arquiteto (`/arc question`, degrau 1), que decide o teste ou o prazo no plano.
- Veredito AMBIENTE pela 2ª vez: vai ao formulário (rota `ambiente`), com a escolha em palavras simples.
- O limite (3) fica em `guards.json → run.envDropsBeforeDiagnosis`.
**Testes:** 1ª e 2ª queda (reparo e dev), 3ª (operator sem dev), PROVA (Arquiteto), AMBIENTE duas vezes (formulário), o contador que zera com a Task fechada.

### B · O "Vale para" que o script lê (prioridade alta)
**Problema:** a decisão e o conhecimento escritos com condição em texto ("toda Task de triagem…", "Task que roda a captura") não chegam à Task. O script só casa ID, glob e "todas".
**Proposta:** (`lib.ps1` `Test-EntryApplies`, `knowledge.ps1`, `plan.ps1`, modelos de decisão e de conhecimento)
- Uma forma nova no **Vale para**: `plano: <palavra>`. Ela casa quando a palavra aparece no plano da Task, como `plano: alvo:capturar` ou `plano: prova-cdp.mjs`.
- Ao gravar a decisão ou o conhecimento, o **Vale para** sem nenhuma forma legível (ID, glob, `todas`, `plano:`) é avisado: o `knowledge.ps1` escreve o aviso em §Achados de processo, e o modelo traz o exemplo.
- Na repetição "não chegou à Task", a linha do `lessons.md` traz a proposta pronta, com o glob dos arquivos da Task que repetiu ou o `plano:` do termo em comum, para o formulário do fechamento.
**Testes:** `plano:` casa e não casa, o aviso do texto livre, a proposta pronta na repetição; medir nas decisões do S6 do garden (só leitura) quantas passariam a chegar.

### C · O cartão diz quem manda (prioridade baixa, barato)
**Problema (resíduo):** o cartão copia o que o plano manda, mas não diz que, em conflito com o texto padrão, vale o plano.
**Proposta:** uma frase no cartão (`run.ps1` `Write-Handoff`, linha "O que o plano manda") e no `agents/developer.md` item 12: "em conflito com este cartão, vale o plano; não abra GAP só por isso".
**Testes:** o cartão com a frase.

### D · A Task de correção prova só o que corrige (prioridade média)
**Problema:** a Task de correção do portão lista cenários que ela não corrige. Quando um deles falha pelo executor do plugin ou pelo cenário, a Task não fecha, e dev e Arquiteto rodam de novo.
**Proposta:** (`gate.ps1`, o prompt que cria a Q-S; `plan.ps1`; mensagem do `close.ps1`)
- O plano da Q-S lista em **Cenários:** só os cenários citados nos achados que ela cobre. O `plan.ps1` avisa sobre o cenário a mais e pede a passagem a `(teste)` ou a saída da linha.
- O cenário que falha no R7-aceite e está em achado com causa `executor` ou `scenario` no `gate/<ID>.md`: o `close.ps1` reprova como hoje, sem afrouxar. A mensagem e o `done` mandam ao Arquiteto tirar o cenário da linha (ele fica no portão), e não ao dev.
**Testes:** Q-S com cenário a mais (aviso), falha de cenário com causa `executor` (Arquiteto, sem dev), falha de cenário de achado `code` (dev, como hoje).

### E · Saída oficial para a Task superada (prioridade baixa)
**Problema:** a Task que uma decisão do stakeholder tornou desnecessária não tem como sair de 🔴 sem uma rodada de fechamento falsa.
**Proposta:** `mark.ps1 -Task <ID> -Supersede -By "<decisão>"`. Exige uma decisão do stakeholder gravada (rota ou `**Decisão do stakeholder**` no plano). Grava o estado "substituída" no quadro e uma linha no run-log. A Review conta à parte (nem ✅ nem pendente), e a R24 ganha a linha.
**Testes:** com a decisão (ok), sem a decisão (recusa), contagem na Review.

### F · O formulário do fechamento sem ruído (prioridade média, barato)
**Proposta:** (`knowledge.ps1`)
- O GAP de ambiente que já está em §Ocorrências de plugin sai de §Propostas de configuração.
- O sufixo "rever a chave…" só aparece quando a decisão cita uma chave de `targets` ou de `verify`. Sem isso, a linha diz "nada a configurar".
- Entrada de `runCommands` com caminho do cache do plugin vira "caminho de versão antiga do plugin: tirar".
**Testes:** os três casos com o `lessons.md` do S6 como entrada.

### G · O custo da sessão principal (investigação com meta)
**Problema:** a sessão que conduz o run releu de 113 a 157 mil tokens de contexto em cada chamada, e isso deu 47,6% do sprint.
**Proposta:** medir antes de mudar. Pelo `usage.jsonl` e pelos transcritos do S6, separar o que ocupa o contexto: o texto de partida, as saídas do `run.ps1 next` e os arquivos lidos. Duas mudanças só se a medição confirmar:
- a saída do `next` enxuta (sem repetir o que não mudou);
- o `next` sugerir `/clear` quando o contexto passar de um teto, já que o run retoma pelo estado em disco.
**Meta:** −30% de tokens por chamada da sessão no S7. Se a medição não mostrar uma causa dominante, o item vira relatório e não mexe em nada.

### H · Duração legível (cosmético)
`Format-Duration` escreve `191h48` acima de 60 min, no consumo e no relatório ao dono.

### I · A contagem do operator (opcional)
O C1 conta também a chamada da sessão sem pasta de job, e o relatório diz de onde vem a diferença.

### J · O git do sprint e do fix (pedido do stakeholder, 23/11)
**Hoje:** cada Task fechada já vira um commit próprio, `T-<nnn>: <título>`, só com o escopo do plano e sem `.team-project/` (`run.ps1` `Save-TaskCommit`, v3.52). A branch é criada à mão: no garden há `feat/sprint-1`, `feat/sprint-3`, `feat/sprint-6` e `fix/b-001`. O commit da documentação revisada também é manual (`4db6f3b docs(sdd): consolidação…`), e não há push nem texto de PR.
**Proposta:**
- **Branch no início, nome em inglês.** O início do run do sprint cria e troca para `feat/sprint-<n>`. O início do fix run faz o mesmo com `fix/<id-em-minúsculas>`, como `fix/b-001`. A base é `develop`, ou `main` quando `develop` não existe, e é atualizada antes. Se a branch já existe, o script só troca para ela. Com alteração pendente fora de `.team-project/`, ele não troca: avisa, com a lista do que está pendente, e o run segue na branch atual. Os commits das Tasks vão para ela. *(Implementado assim: parar o run por isso viraria pergunta ao stakeholder no meio do sprint.)*
- **Um commit por Task**, como hoje, com o descritivo breve do que entrou: o título da Task e, no corpo, as linhas "Entrou:" do relatório de entrega. O checkpoint de Task não fechada continua como está.
- **No fechamento do sprint ou do fix:** um commit `docs: …` com os documentos vivos revisados, ou seja, o que está fora de `.team-project/` e foi revisado no fechamento (SDD, README). Depois o `git push -u origin <branch>`, feito pela sessão e nunca por subagente (a G14 segue negando o push ao subagente). Por fim, a impressão na tela do **título e do corpo do PR para `develop`**: as Histórias e Tasks entregues, as correções, o que ficou pendente e o link de abertura do PR (`…/compare/develop...<branch>?expand=1`) quando o remoto é GitHub. O plugin não abre o PR pela API.
- **Configuração:** `guards.json → git: { "branchPerRun": true, "push": true, "base": "develop" }`. O `/team update` grava os padrões, `false` desliga cada parte e um projeto sem git ignora tudo. O push é ação de fora: vale como autorização do stakeholder gravada uma vez nessa chave, e sem ela o script imprime o comando para ele rodar.
**Testes:** branch nova e existente, base sem `develop`, árvore suja (não troca), commit da Task com o "Entrou:", commit de docs, push desligado (imprime o comando), texto do PR com as Tasks do sprint, projeto sem git.

### K · Aviso do arquivo protegido antes da construção (aprovado em 23/11)
**Problema:** a G5 só aparece quando o dev já tenta editar o arquivo protegido, e isso custa um GAP.
**Proposta:** quando o plano cita na §6 ou num passo uma ferramenta de lint ou de formatação, ou um aviso a corrigir, e a configuração dela está em `protectedPaths`, sem **Arquivos protegidos:** `ver §12`, o `plan.ps1` avisa sem reprovar: "se o passo exigir mudar `<arquivo>`, ponha o diff em §12".
**Testes:** plano com o lint citado e a config protegida (aviso), com a §12 (ok), sem citar o lint (nada).

## 2. Não tratar nesta entrega
- G5: o caminho existe e não muda; entra só o aviso antecipado (K).
- Q9: resolvido na v3.65.1.
- Prova no aparelho: tratada da v3.65.1 à v3.65.13; falta o campo no S7.
- "Chegou ao cartão e não foi seguido" (3 repetições): é obediência do agente; fica no `note.md` se voltar no S7.

## 3. Entrega
- Ordem: A, D, B, J, F, C, E, K, H, I e, por último, G (a medição pode mudar o escopo dele).
- Suítes: `run-all-tests.ps1` completa, com o C3; casos marcados `v3.65.14`.
- CHANGELOG com a origem (o relatório do S6) e a conferência da §0; o `RAIZ/note.md` recebe o que ficar fora.
- Commit e PR só a pedido.
