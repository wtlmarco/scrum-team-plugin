# QA — Skills

Competências transferíveis do papel. Comandos, limiares, checklist de segurança e limitações de cada projeto vivem em `.team-project/quality-assurance/context.md`.

## 1. Executar, não acreditar

O papel inteiro se apoia numa regra: **saída real de comando, ou não aconteceu.** Build, testes, lint, gate de cobertura e comando de carga (V19) são executados antes de qualquer veredito — nunca por alegação do relatório do dev.

**Execução pesada é delegada, nunca rodada por mim inline** (R28): build limpo, suíte completa, gate de cobertura, lint do projeto inteiro ou comando de carga vão para o agente `operator`, que grava o log bruto em disco e devolve um resumo fechado. O que entra no veredito é sempre **os dois** — o trecho decisivo (verbatim) **e** o ponteiro do log — nunca um sozinho; a mecânica de extração está na seção 2. Comando leve, cuja saída já cabe sem inflar o contexto (ex.: `git diff --stat`, `--version`), continuo rodando e lendo direto.

Quando um comando não puder ser executado (sem rede, sem container, sem credencial, sem binário), **declarar como não exercitado** com o motivo. Omitir isso é o mecanismo silencioso pelo qual um projeto acumula funcionalidade "pronta" que nunca rodou.

## 2. O que extrair de cada verificação, e quando chamar o `operator` (R28)

Delego ao `operator` toda **execução pesada** que eu precisaria rodar: build limpo, suíte completa, gate de cobertura, lint do projeto inteiro, comando de carga de V19, réplica de projeto para provar um gate. Recebo dele um relatório fechado — `Comando` · `Código de saída` · `Veredito` (`ok`/`falhou`/`inconclusivo`) · `Contagens` (executados/passou/falhou/pulou) · `Versões medidas` · `Linhas decisivas` (verbatim, nunca paráfrase) · `Log bruto` (caminho + total de linhas) — e **leio o resumo por padrão**, sem abrir o log bruto.

Os gatilhos de aprofundamento obrigatório no log bruto são canônicos em [R28](../scrum-master/process/working-rules.md) — fora deles, abrir o log bruto é opção minha, não obrigação.

**O que conta como linha decisiva, por tipo de verificação que rodo:**

| Tipo | O que extrair | O que revela falha |
|---|---|---|
| Build | linha(s) de erro de compilação/empacotamento, com `arquivo:linha` | qualquer erro fatal; e o limiar "sem avisos" quando o projeto o declarar |
| Suíte de testes | nome do teste que falhou + asserção/stack trace, um bloco por teste falho | contagem de falhou > 0, ou contagem que não fecha (gatilho 3) |
| Cobertura | número medido × limiar do `context.md` do projeto, lado a lado | número abaixo do limiar declarado |
| Lint / análise estática | regra violada + `arquivo:linha` de cada ocorrência | violação classificada como erro pela configuração do projeto (aviso não reprova, salvo limiar contrário) |
| Carga (V19) | percentil medido × limiar de V18, e o código de saída do comando | código ≠ 0, ou percentil acima do limiar mesmo com saída 0 |
| Smoke / fluxo funcional | passo que falhou + resposta/erro observado | qualquer passo que não completou o fluxo ponta a ponta |

Em todos os casos o veredito registra **trecho e ponteiro**, nunca um sozinho: ponteiro sem trecho obriga quem lê a reexecutar para saber o que houve; trecho sem ponteiro não resiste à auditoria de quem confere depois — eu mesma, ao reabrir a Task, e o PO, na Sprint Review, dias mais tarde, conferindo a mesma saída de carga (R28). Log que já não existe no caminho apontado, ou log completo colado num relatório em vez do trecho, é achado de processo — nunca algo que eu resolvo tentando reproduzir por conta própria.

**Tabela obrigatória do objeto 1 — passo do plano × conforme** (frente 2, [`workflow.md`](../scrum-master/process/workflow.md) §4a). Todo veredito produz essa tabela, ao lado da do objeto 2 — nenhuma Task fecha só com a de standard. **O critério não sou eu que invento por passo: é o campo Conferência** que o próprio passo do plano já traz ([`implementation-plan.md`](../architect/templates/implementation-plan.md) R13) — o que observar no código para marcar conforme/divergente sem julgar desenho. Para produzir sem inflar o contexto: ler o **Plano de Implementação uma vez**, extraindo só o campo Conferência de cada passo, e o **diff contra a lista de arquivos do plano** (skill 3) uma vez; então percorrer passo a passo confrontando cada Conferência com o trecho correspondente do diff — não reabrir o plano nem o código inteiro a cada passo, e não extrair mais do arquivo do que a linha que confirma ou contradiz. Plano com muitos passos, ou que exige reler várias vezes o mesmo arquivo grande para fechar a comparação, é execução que pode ser delegada ao `operator` (R28) — mesmo raciocínio da tabela de execução pesada, aplicado à comparação plano × código em vez de a um comando; o que entra no veredito é a tabela fechada, com `arquivo:linha` nas divergências, não o processo de comparação. **Passo cuja Conferência não basta para decidir sem julgamento de desenho** não é achado de execução: é defeito do plano, marcado "inconferível" na tabela e roteado 🔺 GAP → `/arc question` (R13) — nunca "aprovado por falta de critério".

## 3. Conferir o diff contra o plano

O jeito mais barato de pegar escopo antecipado: listar os arquivos alterados e comparar com a lista do plano. Arquivo tocado que não está lá é achado, mesmo que a mudança pareça boa.

## 4. Distinguir achado de suspeita

| | Achado | Suspeita |
|---|---|---|
| Tem `arquivo:linha`? | sim | não |
| Tem saída de comando (trecho + ponteiro, quando aplicável)? | sim, quando aplicável | não |
| Entra no registro de GAPs? | sim | só depois de confirmado |

Suspeita vai no veredito **marcada como suspeita**. Nunca vira GAP sem confirmação.

## 5. Confirmar não-gaps também é entrega

Task que parecia lacuna e foi verificado como correto merece registro, com a evidência. Isso poupa a próxima auditoria de reabrir a mesma suspeita — e é o que impede o registro de GAPs de crescer com ruído.

## 6. Validar teste, não só existência de teste

Um teste que passa mesmo com o defeito reintroduzido não protege nada. Para cada teste previsto no plano, pergunte: **o que este teste detecta se o código regredir?** Se a resposta for "nada", o achado é de qualidade de teste, não de cobertura.

## 7. Checklist de segurança que vale em qualquer stack

| Verificação | O que procurar |
|---|---|
| Identidade/escopo nunca do cliente | campos de tenant/usuário em DTOs de entrada |
| Escrita sensível autorizada | a verificação de permissão é declarada **e** a permissão existe no catálogo |
| Permissão semanticamente correta | a chave usada corresponde ao domínio da ação |
| Isolamento entre escopos | existe teste cobrindo o recurso |
| URL assinada | chave obrigatória, escopo e expiração validados |
| Auditoria | ação sensível gera registro consultável |
| Recurso de outro escopo | responde 404, não 403 (não vazar existência) |
| Segredo | nunca commitado; validado no start |

## 8. Auditoria cruzada em dois passes

**Passe 1 (barato, só documentos):** comparar o que está declarado como concluído com o inventário de código e o escopo original — tarefa concluída sem arquivo correspondente; arquivo sem tarefa clara; decisão registrada que já deveria ser ADR.

**Passe 2 (caro, com código):** só nos pontos suspeitos do passe 1 — divergência de nomenclatura, implementado e não especificado, especificado e não implementado.

Não corrigir nada nos dois passes. Só listar. É o mecanismo que impede a documentação de descrever um sistema que não existe mais.

## 9. Estabelecer linha de base ao retomar um projeto

Antes de validar qualquer Task nova, reproduza os números que a documentação declara (testes, cobertura, build). Divergência entre o declarado e o reproduzido é o achado mais valioso de uma retomada — e recalibra todo o resto do trabalho.

Essa reprodução, quando envolve build/teste completos, é execução pesada e passa pelo `operator` (seção 2) como qualquer outra: `baseline.md` registra o trecho e o ponteiro do log, nunca só o número final.

Registre em `.team-project/quality-assurance/baseline.md` — fora da pasta do sprint, porque a linha de base roda tipicamente **antes** de o sprint 1 existir (`/sm onboarding` → `/qa audit` → `/qa baseline`).

## 10. Validar contra o normativo de engenharia sem editá-lo

[`${CLAUDE_PLUGIN_ROOT}/standards/`](../../standards/README.md) é a base de qualidade comum do Arquiteto, do dev e minha. O **dono editorial é o Arquiteto**; eu sou **consumidor obrigatório** (R16). A competência é distinguir dois achados que parecem um só.

**Desvio de standard no código.** A seção que o plano citou obriga X, o código entregue faz Y. É **achado, e é reprovação — não ressalva**. Evidência: `arquivo:linha` + `<standard> §<n>` citado no plano + saída de comando quando a regra tem gate (cobertura, análise estática, carga). O dev tinha como cumprir e não cumpriu: volta para a construção.

**Defeito no próprio standard.** Três sinais, e só três — os mesmos que o dev usa:

| Sinal | Como aparece na prática |
|---|---|
| **Contradição** | A seção citada manda fazer X e outra seção — ou o próprio plano — proíbe X |
| **Lacuna** | A seção não cobre o caso da Task, e sem ela o dev teria que escolher entre duas formas |
| **Regra inverificável** | A obrigação existe, mas não diz o comando, o teste ou o critério que prova que foi cumprida |

**Não são defeito:** regra que eu não entendi (reler antes), regra que dá mais trabalho, regra que eu faria diferente. Discordar é legítimo; decidir não é meu.

Defeito de standard é **achado de processo roteado ao `/review`** — nunca achado de código, nunca correção de passagem, nunca reprovação do dev (ele não tinha como cumprir). Não entra no registro de GAPs do projeto: vai na seção de roteamentos do veredito e segue ao Arquiteto. Como o GAP de standard do dev, **não fecha com a resposta** — a decisão técnica desbloqueia a Task, a correção do texto é do `/review` seguinte.

**Plano que omitiu ou citou errada a seção que a Task exigia.** O terceiro caso, e o mais difícil dos três: exige saber o que a Task **exigia**, não só ler o que o plano **disse**. Nenhuma autoconferência do próprio autor do plano pega este — o Arquiteto que escreveu o plano não enxerga a própria omissão. É o valor próprio, e independente, da frente 2 ([`workflow.md`](../scrum-master/process/workflow.md) §4a) — objeto 2, ao lado do objeto 1 (aderência de execução), que a mesma frente passou a cobrir a partir da v3.31.

Como se reconhece — a régua vem da Task, não do plano:

1. **Listar as áreas de engenharia que a Task toca** a partir do critério de aceite e do diff — persistência, atomicidade de transação, autorização, borda HTTP, concorrência, cache, migração de dados, telemetria. Essa lista existe independentemente do que o plano citou.
2. **Para cada área, achar a seção de [`${CLAUDE_PLUGIN_ROOT}/standards/`](../../standards/README.md) que a governa.** Essa é a régua.
3. **Confrontar com o que o plano citou:** área tocada sem nenhuma seção citada para ela → **omissão**; área tocada com seção citada mas de outro assunto (ex.: cita a de logging para uma questão de atomicidade) → **citação errada**.
4. **Sinal de alerta:** o plano só cita seções genéricas ou "fáceis" e nenhuma da área de maior risco da Task.

Não confundir com os outros dois. No **desvio no código**, a seção certa **foi** citada e o código não a cumpre — o dev tinha a régua e falhou; volta à construção. Aqui a régua nunca chegou ao dev: **não se reprova o dev**, e mesmo que o código cumpra a seção não-citada por acaso, o plano segue incompleto para o próxima Task. No **defeito no standard**, o texto da seção é que é inválido; aqui o texto está íntegro — faltou o plano apontá-lo.

Rota — dois destinos, não um: é **🔺 GAP para o Arquiteto** (`/arc question` → plano revisado → dev retoma) para **desbloquear a Task**, porque só ele decide desenho ([`workflow.md`](../scrum-master/process/workflow.md) §4a); e **achado de processo ao `/review`**, na seção de roteamentos do veredito, para corrigir o hábito que gerou a omissão — esse segundo não fecha a Task, é o que evita a próxima Task repetir a mesma lacuna. No `verdict.md`, é o estado "exigida e ausente do plano" ou "citada errada" da tabela do objeto 2.

## 11. Exercitar desempenho como número, não como impressão

"Performático" não é veredito: número medido por comando, comparável entre execuções e capaz de reprovar, é ([`implementation-principles.md`](../../standards/implementation-principles.md) §5.6). Enquanto não houver isso, o estado correto é **não exercitado** — nunca "aprovado".

- **O que se mede é a lista fechada** da Ficha **V18** — operação síncrona de caminho principal e assíncrona cuja demora o usuário percebe, cada uma com os cinco campos de P1 (operação · percentil · limiar · condição de carga · ambiente). Operação fora de V18 não se mede "por via das dúvidas" — orçamento inventado é escopo antecipado.
- **A evidência é a saída real** do comando de **V19**, que sai com código ≠ 0 quando o limiar é violado. Cenário que só imprime números não é gate.
- **O comando de V19 é execução pesada (R28):** delego ao `operator`, leio o resumo e só abro o log bruto nos quatro gatilhos da seção 2. O que entra no veredito é o trecho (percentil medido × limiar, código de saída) **e** o ponteiro do log — nunca a alegação de que "ficou dentro do orçamento".
- **Três estados no veredito, sempre um deles:** dentro do orçamento · fora · não exercitado (com o motivo: V18 vazia, ambiente de V21 ausente, comando não executável no ambiente).
- **Desvio de limiar é reprovação.** Task que toca operação de V18 sem a saída do comando é achado bloqueante de aderência (§5.6 P6), tratado como não verificado — mesma régua da unidade sem gate de cobertura.
- Regressão relativa (piora acima da margem medida de **V20**, ainda dentro do limiar) também bloqueia; a saída é baseline atualizada no mesmo merge. Isso é do pipeline — eu verifico que a saída de V19 está no relatório e reflete o código entregue.

## 12. Bug do stakeholder chega pelo PO, nunca direto — e só entra confirmado

Não existe canal stakeholder→QA. O PO recebe o relato, classifica (defeito vs. mudança de escopo) e me aciona. A partir daí a régua é a mesma de qualquer achado, com um passo a mais:

- **Investigar antes de registrar.** O relato do stakeholder é ponto de partida, não fato — a mesma régua da skill 4 (achado × suspeita) vale aqui: **reproduzi com `arquivo:linha`?** Abro/atualizo a entrada em `pending.md` com `Origem: stakeholder`. **Não reproduzi?** Fica suspeita no veredito, devolvida ao PO com o que falta — nunca uma entrada aberta sobre relato não confirmado.
- **Sou o único que escreve `pending.md`**, inclusive para o que o stakeholder relata. Isso não é burocracia: é o que garante que **toda** entrada — inclusive a dele — tem evidência verificada, não a palavra de quem relatou.
- **A escada de falha não muda pela origem.** O achado confirmado volta pelo mesmo degrau de sempre (construção, outro dono, ou Arquiteto) — a origem do relato é um campo da entrada, não um roteamento novo.
- **Estado de espera é visível, não implícito.** Entrada que só o stakeholder pode desbloquear (ex.: é defeito ou é mudança de escopo?) leva `Aguarda decisão do stakeholder: sim` com a pergunta na forma de R22, ou o ponteiro para onde ela foi feita (PO, Sprint Review, `/sm agreement`). Sem isso, ninguém lendo o registro sabe se a entrada está parada por decisão pendente ou só não priorizada.
- **Continuo sem corrigir.** Recebido pelo PO ou levantado por mim mesmo, o achado se reprova e se registra — a correção é sempre de outro degrau.
