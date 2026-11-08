# Relatório ao dono do plugin — Sprint 5 (INTERMEDIÁRIO, sprint em andamento) — 2026-11-07

**Versão do plugin instalada:** 3.56.0 · **Unidade de estimativa:** dias · **Sprint de** 19 Tasks (quadro) · 4 Histórias + 1 grupo habilitador
**Registro de consumo:** existe, mas as seções 1 e 2 ficam **n/a neste relatório intermediário**: o consumo do sprint é fechado e conferido no `sprint close`. Este arquivo é a versão antecipada, pedida pelo stakeholder, das **seções 3 e 4**. O relatório completo do sprint substitui este no fechamento.
**Ocorrência que motivou o relatório:** (i) uma espera de ~2 h por um processo travado que ninguém reavaliou; (ii) repetição de GAPs de aparência (medida visual) levados ao Arquiteto para decisões simples. Pedido do stakeholder: incluir **a correção sugerida** para (i) e para (ii).
**Sem nome, domínio, código, caminho ou ID do projeto.** Tasks aparecem como A, B, C…

## 1. Consumo por papel e por modelo
n/a — relatório intermediário (ver cabeçalho).

## 2. Ineficiências observadas
n/a — relatório intermediário. Dado parcial medido pelo `run.ps1 next` no momento da escrita, **sem conferência**: ≈ 248 mi tokens em 594 rodadas de subagente e ≈ 1.030 min no sprint; a Task A (a do item 3.2) já teve 4 GAPs levados ao Arquiteto e 5 instâncias de dev.

## 3. Bloqueios, falhas e gaps de processo

| # | O que aconteceu, sem o contexto do projeto | Regra / cerimônia | Degrau do bloqueio (R25) | Ocorrências |
|---|---|---|---|---|
| 1 | **Processo de reparo do alvo travou e a Task ficou parada ~2 h sem aviso.** O `operator` disparou o reparo do alvo de execução (emulador); passou de 180 s e foi para segundo plano; o `operator` encerrou o turno entregando o relatório com o alvo "não confirmado". A sessão rodou `run.ps1 next` aos 3 min (CPU 0 s, abaixo do limiar de 10 min do POSSÍVEL TRAVAMENTO), recebeu "esperar" e encerrou o turno. Como o processo travado não gera aviso de conclusão, **nada reabriu a sessão**; o travamento só foi visto quando uma mensagem do stakeholder fez a sessão rodar o `next` de novo (2 h 00 min sem CPU). O reparo não tem tempo-limite. | `sprint-run.md` §Disparo e espera (itens 1, 2 e 5); `target.ps1 -Repair`; G20/G22; v3.53.5 (sinal de vida e POSSÍVEL TRAVAMENTO) | stakeholder (decisão de encerrar o processo) | 1 (aqui); o mesmo padrão — espera de processo sem prazo — foi registrado no sprint 5 da versão anterior com o `adb` (81 min) |
| 2 | **O `operator` entrega o relatório antes de o estado final do alvo estar confirmado**: o reparo foi para segundo plano e o relatório saiu com "religação pendente", deixando para a sessão/dev o que era dele. | `operator` (R28), pedido ao `operator` | — | 1 |
| 3 | **Guarda nega o destrutivo legítimo dentro do run**: o `operator` pediu para encerrar os processos-lançador do emulador que sobraram depois de um `emu kill`; a G14 negou o `Stop-Process`. Sem caminho oficial para "encerrar processo do alvo que o próprio run iniciou". | G14; `sprint-run.md` §Disparo e espera (item 5: "encerrar o processo é decisão do stakeholder") | stakeholder | 1 (aqui; o sprint anterior teve 80 negações de G14 a comandos legítimos) |
| 4 | **O cartão de passagem contradiz o plano**: o cartão mandava rodar o aceite automático numa Task cujo plano declara que o aceite não roda (decisão registrada). O dev seguiu o plano e abriu GAP de processo. | `sprint-run.md` passo 5 (v3.56.0 H2 "o plano manda"); `run.ps1 start` (cartão) | Arquiteto | 1 (em 2 instâncias) |
| 5 | **`# aguarda` cria ciclo** quando a própria Task cria e prova os identificadores de teste: a Task esperava por si mesma e pela seguinte; em outra História, a Task esperava a Task-mãe que nunca fecha (dividida em A/B). Fila sem Task elegível até o Arquiteto reescrever o `.scn` e ajustar os planos. | `run.ps1` (junção do dono do `aguarda` às dependências); `.scn` | par PO+Arquiteto | 2 |
| 6 | **Gate de identificadores de teste assume `data-testid` sem avisar** quando o projeto usa o atributo `id`: reprovou um `verify full` verde; precisou de autorização do stakeholder para declarar o atributo em `guards.json`. | `verify.ps1` (passo `testids`); `guards.json → testIds` | stakeholder | 1 |
| 6b | **O mesmo gate reprova ids que existem em tempo de execução** (gerados por template ou componente): 6 linhas "id ausente no código" que o verificador estático não vê; a Task não fecha limpa por falso positivo e o Arquiteto precisou decidir só para aceitar a divergência. | `verify.ps1` (passo `testids`); R7-verify | Arquiteto | 1 |
| 7 | **`verify` conta o tempo de suspensão do sistema como tempo de suíte** (suspensão de ~9 h do SO): a rodada estourou o gate e o Karma desconectou; e, em outra rodada, o passo de cobertura reprovou "módulo não medido" com a suíte verde (suspeita: o gate leu o resumo antes de a suíte gravá-lo — **não verificada**). | `verify.ps1` (tempo, ordem das etapas) | stakeholder | 2 |
| 8 | **`runjob` com `-ExecutionPolicy Bypass` é recusado pela G14**, e a suíte completa morre por memória com o emulador ligado; cada caso é uma parada por ambiente. | G14; `verify.ps1`; R27 | stakeholder | 3 |
| 9 | **GAPs de aparência (medida visual) viram 3 instâncias cada** (dev → Arquiteto opus em instância nova → dev novo pelo cartão) para decisões que o plano já delimitava. Detalhe na seção 4, item A. | `sprint-run.md` passo 4 (Gap); R9; plano com "pior caso de conteúdo" | Arquiteto | 5 na Task A (todos os GAPs da Task) |

## 4. Sintomas para o `note.md` do plugin

> Formato da fila do `/review`: sintoma, não regra reescrita. Onde o stakeholder pediu **correção**, ela vem marcada como *Correção sugerida pelo stakeholder* — é entrada para o `/review` avaliar contra as regras vigentes, não decisão.

| # | Sintoma observado neste sprint | Onde doeu | Quantas vezes |
|---|---|---|---|
| 1 | Processo em segundo plano que trava **não reabre a sessão**: o `run.ps1 next` só é rodado quando chega um aviso de conclusão, e o processo travado nunca gera aviso. O POSSÍVEL TRAVAMENTO (10 min sem CPU nem arquivo) existe, mas depende de alguém rodar o `next` depois dos 10 min; no caso, ninguém rodou por ~2 h. | `sprint-run.md` §Disparo e espera; `run.ps1 next`; hooks G20/G22 | 1 (2 h); 1 no sprint 5 da versão anterior (81 min) |
| 1b | **Causa provável do travamento do item 1, para o dono do plugin avaliar** (2 ocorrências em ~3 h, 2 h e 41 min, ambas com o emulador já com boot completo e o `adb` em `device`): `Repair-Android` (`scripts/checks/targets/android.ps1`, linha do `& powershell -NoProfile -ExecutionPolicy Bypass -Command $cmd 2>&1 \| ForEach-Object`) lê a saída do comando de reparo declarado pelo projeto por **pipeline** e só segue quando o pipe fecha. O comando declarado iniciou o emulador (processo de longa duração) e o `adb start-server` com `Start-Process` sem redirecionar as saídas; esses processos herdaram a ponta do pipe e o pipeline não terminou enquanto eles viveram. O tempo-limite de 240 s do laço de boot, dentro do comando, não protege: o bloqueio é na leitura do pipe, depois dele. **Status da evidência:** inferência lida no código; consistente com os dois casos (processo do reparo vivo com CPU ~0 s, filho do shell do `run`, emulador independente e pronto); **não reproduzido em teste isolado**. | `target.ps1 -Repair` / `Repair-Android`; `guards.json → targets.android.repair` | 2 |
| 2 | O reparo do alvo (`target.ps1 -Repair`) **não tem tempo-limite**; o `operator` o manda para segundo plano depois de 180 s e devolve o relatório sem o resultado final. | `target.ps1`; pedido ao `operator` | 1 |
| 3 | O `operator` devolve relatório com o estado final do alvo "não confirmado", em vez de bloquear até o resultado ou de entregar "ambiente: pendente" com o comando que a sessão deve rodar. | `operator`, R28 | 1 |
| 4 | Não há caminho oficial para o stakeholder/sessão encerrar com segurança um processo do alvo que o próprio run iniciou: a G14 nega o `Stop-Process`, e o roteiro manda "levar ao stakeholder", que não tem como fazer isso de dentro do run. | G14; `sprint-run.md` item 5 | 2 (processos-lançador do emulador e o PID do reparo) |
| 5 | O cartão de passagem contradiz o plano quanto a rodar o aceite automático (comando do cartão × "o aceite não roda" no plano). | `run.ps1 start` (cartão); passo 5 | 1 (2 instâncias) |
| 6 | `# aguarda` gera ciclo quando a Task cria e prova os próprios identificadores; a fila fica sem Task elegível. | `run.ps1`; `.scn` | 2 |
| 7 | Gate de identificadores assume `data-testid` e reprova sem dizer que o projeto usa `id`. | `verify.ps1` passo `testids` | 1 |
| 8 | Tempo de suspensão do sistema entra na duração do `verify`; o passo de cobertura reprovou "não medido" com a suíte verde numa rodada (causa não verificada). | `verify.ps1` | 2 |

### A. GAPs de aparência que travam a Task e sobem ao Arquiteto para decisões simples

**Sintoma.** Numa Task de interface (Task A, que acrescenta uma janela de confirmação e um botão extra numa linha de lista), o dev parou em 🔺 GAP **cinco vezes**, cada uma levada a um Arquiteto novo (opus) e devolvida a um dev novo com o cartão. **Quatro das cinco eram decisões pequenas, de medida, de marcação ou de identificador, que o plano já delimitava ou podia delimitar:**

| GAP | O que era | Natureza | Tempo entre GAPs (registro do run) |
|---|---|---|---|
| A1 | Texto de ajuda numa janela herdava uma margem negativa pensada para ajuda sob um campo, e encostava no resumo acima | espaçamento (1 regra de CSS) | 08:49 |
| A2 | Espaço de 8 px entre dois botões vizinhos: a sonda do dev mediu margem 0 e `gap` normal, caso (b) que o plano **já previa**; ainda assim o dev abriu GAP | espaçamento (1 regra de CSS) | 08:59 (+10 min) |
| A3 | Dois botões lado a lado não cabem em tela estreita com fonte grande (coluna 110 px contra o mínimo de 114,4; o rótulo de estado passa por cima do botão) | **decisão de produto** (empilhar os botões) — a regra de produto vigente e o plano já mandavam parar e perguntar ao stakeholder | 09:09 (+10 min) |
| A4 | `aria-label` dinâmico num botão de componente de UI lança erro no teste de render | marcação acessível (texto oculto no lugar do atributo) | depois da decisão de A3 |
| A5 | O gate de identificadores de teste reprovou o `verify full`: 6 ids que os cenários leem "fora do código" e a raiz da tela sem id. O plano não previa os ids; o Arquiteto decidiu: o dev acrescenta só o id da raiz; os 6 outros **existem em tempo de execução** (gerados por template/componente) e o verificador estático **não os enxerga** — o `full` fecha com o passo reprovado só por essas 6 linhas | falso positivo do gate + 1 id simples | depois do reparo do alvo |

**Causa aparente (do registro).** O plano traz o critério numérico e os casos (a)/(b)/(c) para a medida, mas **não autoriza o dev a escolher entre eles** nem a aplicar a variante equivalente quando a medida bate; qualquer divergência vira GAP. O dev, correto pela regra "dúvida de desenho → GAP", para; o custo de cada GAP é um Arquiteto opus em instância nova mais um dev novo que relê o cartão. O tempo medido entre GAPs é de ~10 min; o custo em tokens por GAP **não foi medido neste relatório** (fecha com o consumo do sprint).

**Correção sugerida pelo stakeholder (para o `/review` avaliar, não regra aprovada):**
1. **Envelope de decisão no plano**: para Task de interface, o Arquiteto declara, por medida visual (espaçamento, alinhamento, quebra de linha, rótulo acessível), a **árvore de decisão com limites** — "se medir X, aplique Y; se medir Z, aplique W" — e o dev decide **dentro** do envelope, registrando a medida e a escolha no relatório da Task (R9: a decisão fica escrita). **GAP só quando a medida cair fora do envelope** ou quando a decisão mexer em regra de produto.
2. **Classificar o GAP na hora de abri-lo**: "aparência/marcação simples" × "desenho" × "produto". Os dois primeiros podem ser resolvidos por uma instância mais barata ou pelo próprio dev com um parecer curto do Arquiteto; só o terceiro exige o ciclo completo e o stakeholder.
3. **Agrupar GAPs de aparência da mesma Task** em um único acionamento do Arquiteto quando o dev consegue medir todos os casos antes de parar (A1 e A2 foram dois ciclos separados, 10 min um do outro).
4. **Sonda de medida no cartão**: quando o plano tem caso (a)/(b)/(c) para uma medida, o cartão traz o comando da sonda e a instrução de aplicar o caso medido, para o dev não abrir GAP para um caso que o plano já cobre (A2).

**Causa provável do travamento do item 1 (lida no código, não reproduzida em teste; o travamento ocorreu 2 vezes em 3 h, nas duas com o emulador já ligado e com boot completo):** o reparo do alvo (`Repair-Android`) executa o comando de reparo declarado pelo projeto dentro de um pipeline que lê a saída (`& powershell -Command $cmd 2>&1 | ForEach-Object …`) e só devolve quando o pipe fecha. Quando o comando declarado inicia o emulador de longa duração (e o daemon do `adb`) sem redirecionar as saídas, esses processos herdam a ponta do pipe e o pipeline não termina enquanto eles viverem — o reparo "não acaba" mesmo com tudo pronto. O tempo-limite de 240 s do laço de boot do próprio comando não ajuda, porque o travamento é na leitura do pipe, depois dele. **Remédio aplicado no projeto:** o script de reparo passou a iniciar o emulador e o `adb start-server` com saída redirecionada para arquivo. **Sintoma para o plugin:** o `Repair-Android` não tem tempo-limite sobre o comando declarado e não protege contra processo-filho que herda o pipe (por exemplo, executar o comando por arquivo/processo separado com saída em arquivo e esperar pelo código de saída, não pelo fechamento do pipe).

**Correção sugerida pelo stakeholder para o item 1 (processo travado):**
1. **Tempo-limite no reparo do alvo** (`-Repair`), com saída `exit 4 ambiente` e a causa no log ao estourar (por exemplo 10 min), em vez de segundo plano sem prazo.
2. **O `operator` só entrega com o estado final do alvo confirmado** (ou entrega "ambiente: pendente" com o comando de conferência e o PID) e **nunca deixa processo rodando sem prazo**.
3. **Reavaliação por tempo, não por aviso**: quando o `next` responde "esperar" por um processo, o `run` agenda uma conferência de segurança (≈ 15 min) que reabre a sessão; ou o hook `Stop`/o SO acorda a sessão quando o processo ultrapassa o limiar do POSSÍVEL TRAVAMENTO. Sem isso, a detecção depende de um humano falar com a sessão.
4. **Caminho oficial para encerrar processo do alvo** que o próprio run iniciou: `target.ps1 -Target <alvo> -Kill`, permitido à sessão com autorização do stakeholder, em vez de a G14 negar `Stop-Process` e o roteiro mandar "levar ao stakeholder".

### Mais uma ocorrência de GAP simples na mesma Task A (A6)

Na mutação de prova (9 mutantes), o mutante M6 do plano **não compila** (a troca de um literal por outro valor que não pertence ao tipo da comparação gera erro de tipo): o `verify` o marcou "inconclusivo — o teste não rodou de verdade" e a mutação inteira saiu com exit 1 (8 de 9 pegas). O defeito é do trecho do mutante escrito no plano, não do código; vai ao Arquiteto só para trocar o literal por um valor válido do tipo. Sintoma: o `plan.ps1` confere a forma do plano (existência e unicidade do trecho), não que o mutante compile; o erro só aparece depois de ~20 min de mutação. Candidato a conferência barata no preparo (compilar os mutantes antes de entregar o plano ao dev).

### Pedido de avaliação ao dono do plugin (travamento do reparo do alvo)

1. **Confirmar ou refutar a causa** da linha 1b da seção 4 (pipe herdado por processo filho de longa duração). Reprodução sugerida: um comando de reparo declarado que faça `Start-Process` de um processo que dura minutos, sem redirecionar saída; rodar `target.ps1 -Repair` e observar se ele devolve só quando esse processo morre.
2. **Contexto do remédio no projeto:** o script de reparo do projeto passou a iniciar o emulador e o `adb start-server` com saída redirecionada para arquivo (feito em 2026-11-07, depois do 2º travamento). Se o reparo passar a terminar em segundos depois do boot, isso reforça a causa; o resultado fica registrado na Review/`sprint close`.
3. **Pergunta de projeto do plugin (sintoma, não solução):** o plugin deveria proteger o `Repair-Android` contra esse padrão (o comando declarado pelo projeto é de terceiros), em vez de depender de cada projeto lembrar de redirecionar a saída?

## 5. Encaminhamento
- **Relido contra vazamento de contexto pelo SM:** sim (sem nome de tela, arquivo, ID, domínio ou código; os horários são do registro do run).
- **Lido pelo stakeholder antes de encaminhar:** pendente
- **Encaminhado ao dono do plugin:** pendente
- **Sintomas levados ao `RAIZ/note.md`:** nenhum ainda
