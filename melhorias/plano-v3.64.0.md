# Plano de Implementação — v3.64.0: a evidência que o script já sabe, o cartão que não contradiz o plano, a árvore e a máquina com dono, e o portão que não duplica correção

> **Escrito para:** você (autor do plugin), para aprovar, e para a sessão de desenvolvimento do plugin que vai construir a versão. Nada aqui é commitado nem vira PR sem pedido seu.

**Origem:** análise do sprint 6 do projeto piloto (garden), 11 a 18/11/2026, pedida pelo stakeholder em 18/11: "tudo que gerou retrabalho". Três fontes de retrabalho são **criadas pelo próprio processo** e não têm solução consistente na 3.63.2. Outras duas apareceram na mesma noite: o item 7, na parada da Q-S6e, e o item 8, na revisão final.

> **Numeração:** os "itens" seguem a numeração da análise de 18/11 (os itens 1, 3 e 4 ficaram fora, ver §1). Cada seção de §2 a §6 trata um item.

| Item da análise | O que acontece | Quanto custou no sprint 6 |
|---|---|---|
| **2 · Evidência incompleta** | o `done` reprova e dispara um dev novo "só para completar a evidência, sem mudar código", qualquer que seja a falha | **58 instâncias novas do dev**, 17 delas repetindo a mesma reprovação da anterior |
| **5 · Cartão × plano** | o cartão da Task diz uma coisa e o plano outra; o dev para e abre 🔺 GAP | T-083, T-090, T-093 (5 GAPs de processo), mais as instâncias "não mude código" que precisavam mudar código |
| **6 · Árvore compartilhada sem commit** | o código de uma Task parada fica no disco e reprova o fechamento de outra | T-093 parada até um commit manual decidido pelo stakeholder (`6e84fcf`, README §7 item 124); 10 reprovações de "teste fora da lista"; 5 de "a árvore mudou depois do verify"; o portão mediu árvore sem commit (achado S6-F4-2) |
| **7 · Máquina dividida entre projetos** *(acrescentado em 18/11, depois da parada da Q-S6e)* | outro projeto da máquina sobe emulador e adb no meio da suíte; o diagnóstico culpa a configuração do Karma e manda abrir Task com o Arquiteto; a suíte roda de novo sem que nada do que ela lê tenha mudado | Q-S6e parada; 2 rodadas da suíte (~40 min) perdidas; emulador do projeto derrubado; proposta de Task errada |
| **8 · Portão preso no formato antigo** *(acrescentado em 18/11)* | o `next` manda abrir a Q-S6f para os mesmos 21 cenários da Q-S6e, que já está aberta, e ignora o diagnóstico APP/PLANO do operator | sprint parado esperando o stakeholder; correção que sairia em duplicata |

**Branch:** `feat/v3.64.0` a partir de `develop` com a v3.63.2 mesclada (`74a03a9`).

> **Construído (18/11) — o que mudou em relação a este plano** (detalhe no bloco `## v3.64.0` do `CHANGELOG.md`):
> - **Sobra sem dono no `start`** (§4.2 B): aviso e linha no run-log, sem a parada ao SM — o checkpoint e o `treeIgnore` resolvem o que travou o piloto, e a parada reprovaria o início de qualquer Task com um arquivo solto.
> - **Árvore pendente no portão** (§4.2 C): checkpoint das Tasks abertas e aviso, sem recusar a medição.
> - **Trava pesada** (§5.2 B): vale para o alvo android; o servidor web local não pesa como emulador.
> - **Correção substituída** (§6.2 B): lida do `**Corrige:**` do plano a cada `next`, com uma nota na saída, sem gravar no quadro pelo `mark.ps1`.
> - **Diagnóstico da queda** (§5.2 A): duas amostras de CPU no momento da queda (não três ao longo da suíte).

**Princípio (memória `feedback-plugin-generico`):** nada do garden fica fixo no plugin. O que é do projeto vira configuração do `guards.json`; os exemplos abaixo são só a prova do defeito.

---

## 1. Objetivo e fora de escopo

Depois desta versão:
1. **O script escreve o que ele já sabe.** A saída do verify e do accept, o estado dos documentos vivos e o formato das linhas vêm do `result.json` e do plano. Nenhuma instância de dev é disparada para colar texto.
2. **A reprovação do `done` vai a quem resolve:** falta mecânica → o próprio script; prova não rodada → operator; prova vermelha → dev em instância normal (pode mudar código); repetição idêntica → escalonamento, nunca um 3º dev igual.
3. **O cartão só diz o que o plano diz.** Toda linha de instrução do cartão sai do cabeçalho do plano; o estado (o que já rodou) tem etiqueta própria, que não se confunde com ordem.
4. **Toda alteração no disco tem dono.** Task que sai da construção sem fechar deixa um checkpoint; o `start` não começa sobre sobra sem dono; o portão não mede árvore pendente.
5. **A máquina é um recurso com dono.** O diagnóstico de queda mede processador e emuladores de outros projetos antes de culpar a configuração; o trabalho pesado de projetos diferentes não roda junto; e um comando do verify não roda de novo quando nada do que ele lê mudou.
6. **O portão do sprint chega ao caminho por causa e não abre correção em duplicata**, mesmo num sprint que começou antes da v3.63.0.

**Fora do escopo:**
- O teto de contexto (G23, item 3 da análise) e a premissa errada no plano (item 4). Têm causa e conserto diferentes; ficam para a fila.
- A prova no aparelho (item 1): a 3.62.0 → 3.63.2 cobre; falta campo.
- Mudar o que o QA confere no portão. Só muda **quem escreve** a parte mecânica da evidência do dev.

---

## 2. Item 2 — evidência incompleta

### 2.1 Diagnóstico (run-log do sprint 6: 58 reprovações, com 89 regras reprovadas)

Uma reprovação costuma falhar em mais de uma regra. A tabela conta as regras (as principais); a §2.3 conta as reprovações.

| Regra que reprovou | Vezes | Natureza | Quem resolveria sem um dev |
|---|---:|---|---|
| R7 · "sem a saída colada do verify ou do accept" | 13 | **mecânica**: o `result.json` já tem a saída | o script |
| R12 · seção `### Documentos vivos (R12)` ausente ou estado vazio | 17 | **mecânica**: no modo dev, `a consolidar` já é aceito (`close.ps1:148`) | o script |
| R7-margem · linha de ajuste fora do formato | 5 | **mecânica**: a leitura tolerante já entende a linha (`close.ps1:264`), mas ainda reprova | o script (aviso) |
| R7-verify · sem verify full / árvore mudou depois do verify | 13 | **prova não rodada**: rodar um comando, sem decidir nada | operator |
| R7-mutação · mutação não rodada | 3 | prova não rodada | operator |
| R7-verify · verify full com falha | 12 | **prova vermelha**: exige mudar código ou teste | dev (instância normal) |
| R7-mutação · mutante não pego | 3 | prova vermelha | dev |
| R7-margem · teste fora da lista / ajuste "sem prova" | 14 | escopo: ver §4 (item 6) e GAP | dev ou Arquiteto |
| R7-aceite · accept parou no ambiente | 4 | ambiente | rota de ambiente (já existe, v3.60.1) |

Três defeitos do desenho atual (`run.ps1:1182-1210`):
- **Toda reprovação vira "dev novo, só a evidência, não mude código"**, mesmo quando a falha é a suíte vermelha. A T-087 e a T-090 receberam "não mude código" com `suite exit 1`, e o dev abriu GAP de processo por isso.
- **Reprovação idêntica repete sem limite.** A Q-S6d recebeu 4 vezes seguidas "a árvore mudou depois do verify full de 17/11 13:50 (4791640 → 8fd37f)", e a suíte dela leva 14 a 25 min.
- **A conferência cobra do modelo uma cópia do que ela mesma lê.** O R7 (modo dev) procura um bloco de código com `verify` colado; o R7-verify, logo abaixo, já confere o `result.json` da mesma rodada.

### 2.2 Desenho

**A · O script preenche a evidência mecânica (`close.ps1`, `run.ps1 done`).**
- **R7 no modo dev:** passa com o R7-verify `ok` (ou `n-a` por dispensa) **e**, quando o plano roda o accept, o R7-aceite `ok`. Nesse caso o `done` acrescenta ao fim da seção mais recente do `delivery/<T-ID>.md`:
  ```
  ### Prova registrada (gerada pelo run.ps1 — não editar)
  > verify full · árvore <12> · <at>
  build 0 · lint 0 · suite 0 (<linhas de resumo do log>) · coverage 0
  > accept · <passed> de <total> · <at>
  ```
  O texto sai do `result.json` do verify e do accept, com as mesmas linhas que o `verify.ps1` imprime hoje. O bloco colado pelo dev continua valendo; só deixa de ser obrigatório.
- **R12 no modo dev:** sem a seção, o `done` escreve `### Documentos vivos (R12)` com `**Estado:** a consolidar` e a lista do `**Documentos vivos:**` do cabeçalho do plano (ou "nenhum declarado no plano"). A seção escrita pelo dev, quando existe, prevalece. No modo QA (evidência do QA), nada muda.
- **R7-margem, só formato:** a linha que a leitura tolerante entendeu (`$a.Id` preenchido) vira `aviso` no resultado, não `falhou`; as travas do ajuste (mutação pega, regra citada, dump existente) continuam bloqueantes. A linha que não se lê continua reprovando.
- **Escrita:** só o `run.ps1 done` grava no `delivery/` (o `close.ps1` sem `-Apply` só confere, como hoje), e o run-log registra "evidência mecânica preenchida pelo script: R7, R12".

**B · A rota da reprovação depende da natureza (`run.ps1 done`).**
O `close.ps1` passa a devolver, em cada linha `falhou`, uma coluna `natureza` com `mecânica`, `prova-faltando`, `prova-vermelha`, `escopo` ou `ambiente`. A ordem da rota:

| Reprovou | Próxima ação |
|---|---|
| só `mecânica` | o `done` preenche (A) e roda o `close` de novo **no mesmo processo**. Nenhum agente é disparado. |
| `ambiente` | a rota de ambiente que já existe (v3.60.1, `run.ps1:1189-1198`) |
| `prova-faltando` (verify full ausente ou de outra árvore; mutação não rodada) | operator roda `verify.ps1 -Mode full` / `-Mode mutation` (R28), em processo próprio (v3.62.2); depois `done` de novo. **Sem dev.** Não conta como falha de papel (`Update-DevCounter`). |
| `prova-vermelha` ou `escopo` | dev em instância **normal** pelo cartão, com o que reprovou. O cartão **não** traz "não mude código". Conta como falha de papel, como hoje. |

- O `handoff/<T-ID>-evidencia.md` e a linha "Só completar a evidência" do cartão ficam **só** para o caso `prova-faltando` em projeto sem operator configurado. Nesse caso o texto diz "rode os comandos de prova que faltam"; "não mude código" sai.

**C · Repetição idêntica para (`run.ps1 done`).**
- O `done` grava em `handoff/<T-ID>-evidencia.json` a assinatura da reprovação: as regras que falharam, o texto normalizado sem horário, e a árvore.
- Se a assinatura nova for **igual à anterior e a árvore também**, não há nova instância. A Task vai ao degrau seguinte do escalonamento (Arquiteto, `/arc question`, com as duas reprovações). Se a natureza for `ambiente`, vai ao formulário do stakeholder pela G24.
- O registro some no fechamento (como o `-evidencia.md` hoje, `run.ps1:1216`).

### 2.3 O que esperar no campo
Reaplicando a rota da §2.2 B às 58 reprovações do sprint 6, cada uma pela natureza mais grave que tinha:

| Destino | Reprovações | O que muda |
|---|---:|---|
| só o script (puramente mecânica) | 9 | nenhum agente |
| operator (prova não rodada, nada vermelho) | 18 | um comando, sem dev |
| rota de ambiente | 3 | como hoje |
| dev (prova vermelha ou escopo) | 28 | dev em instância normal, que pode mudar código; a parte mecânica já vem preenchida e não reprova de novo na volta |

Os relançamentos de dev caem de 58 para cerca de 28, e cada um deles passa a ter motivo de código ou de escopo. As 17 repetições idênticas param na 2ª vez (§2.2 C), o que reduz também parte dos 28.

---

## 3. Item 5 — o cartão contradiz o plano

### 3.1 Diagnóstico

| Caso | O cartão dizia | O plano dizia | Causa no código |
|---|---|---|---|
| T-083, T-093 | `**Verificação:** sem verify` | §7 do plano da Task: `verify full e mutation` | `Write-Handoff` (`run.ps1:655, 683`) escreve na linha **Verificação:** o **estado** do `result.json` ("sem verify" = ainda não rodou). No cabeçalho do plano, a mesma etiqueta é a **ordem** (`**Verificação:** comando — …`, `Get-PlanVerification`). O dev leu como ordem. |
| T-093 | "cole a saída do accept" | `Aceite: não roda` | a mensagem do R7 é fixa: "sem a saída colada do verify **ou do accept**" (`close.ps1:85`) |
| T-090, T-087 | "Só completar a evidência… não mude código" | passo 6a (M11) não executado / suíte vermelha | a ordem "não mude código" vale para toda reprovação (§2.1) |

A causa comum é que **o cartão tem frases próprias**, escritas pelo `run.ps1`, em vez de copiar o cabeçalho do plano, e mistura "o que já aconteceu" com "o que fazer".

### 3.2 Desenho

**A · Duas seções separadas no cartão (`Write-Handoff`).**
- **"O que o plano manda"**: só cópia das linhas do cabeçalho do plano, `**Verificação:**`, `**Aceite:**` e `**Cenários:**`, pelos leitores que já existem (`Get-PlanVerification`, `Get-PlanAccept`, `Get-PlanScenarios`). Nenhuma frase própria.
- **"O que já rodou"**: as etiquetas novas `**Verify registrado:**` (`nenhum ainda` | `full em <at>: verde` | `… suite exit 1`) e `**Accept registrado:**` (`nenhum ainda` | `<p> de <t> em <at>` | `falha de ambiente: …`). A palavra "Verificação" não aparece nesta seção.
- O texto do accept dispensado (`$T.AcceptWaiver`) passa a ser a cópia literal do `**Aceite:**` do plano.

**B · Mensagens do `close.ps1` que dependem do plano.**
- R7 (modo dev): com `Get-PlanAccept` em `não roda`, a mensagem fala só do verify; com o plano dispensando o verify, só do accept.
- Toda mensagem de reprovação que dá uma ordem cita a linha do plano de onde ela vem, por exemplo "(plano: `**Verificação:** comando — …`)".

**C · A ordem de "não mudar código" sai do cartão** (fica como em §2.2 B: só para `prova-faltando`, e com outro texto).

**D · Teste de não-contradição (`run-check-tests.ps1`).**
Uma matriz com os 4 modos de verificação (`comando`, `dispensada`, sem linha, inválida) × os 4 de aceite (`roda`, `não roda`, `comando`, sem linha) × os 3 estados (`sem result.json`, verde, vermelho): 48 combinações. Para cada uma, gera o cartão e confere:
- a seção "O que o plano manda" é igual, byte a byte, às linhas do plano;
- nenhuma linha fora dela contém as palavras de ordem (`rode`, `não rode`, `cole`, `não mude`) contradizendo o modo do plano;
- a etiqueta `**Verificação:**` só aparece na seção do plano.

---

## 4. Item 6 — árvore compartilhada sem commit

### 4.1 Diagnóstico

O fechamento já faz o commit da Task (`Save-TaskCommit`, `run.ps1:273`), e a v3.60.1 já ignora os "alheios" que seguem iguais (`Save-ForeignSnapshot`, `lib.ps1:2293`). Mesmo assim:

1. **Task que sai da construção sem fechar deixa o código no disco.** A T-090 foi a 🔴 (accept parado no estado de partida) com 6 arquivos alterados; a T-093 rodou por cima e não fechava. O commit `6e84fcf` ("salvaguarda… sem fechar Task") foi decidido pelo stakeholder para destravar. O mesmo aconteceu nas correções do portão: a Q-S6c dependia da "Q-S6b com commit", e a árvore ainda trazia os arquivos dela; a Q-S6d começou com os da Q-S6c (`Q-S6d-alheios.json`).
2. **O "alheio" protege só o fechamento, não a árvore.** Ele tira o arquivo da cobrança do R7-margem, mas o arquivo continua no hash da árvore (`Get-WorkTree` faz `add -A` de tudo fora de `.team-project` e `docs`). Se a outra Task mexer nele, o verify da atual fica velho ("a árvore mudou depois do verify", 5 vezes) e o accept mede código que não é da Task.
3. **Sobra sem dono nenhum:** `docker/emulator-repair.ps1`, `source/.eslintrc.json`, um `.zip` não rastreado na raiz (presente nos alheios da Q-S6e). Ninguém os commita e ninguém os apaga.
4. **O portão mediu árvore pendente** (achado S6-F4-2: as ferramentas da Q-S6d sem commit durante a rodada 4).
5. **A mensagem "a árvore mudou" não diz o quê.** Não há como saber se mudou um arquivo da Task ou uma sobra, e a única saída é rodar de novo a suíte de 14 a 25 min.

### 4.2 Desenho

**A · Checkpoint de Task que sai da construção sem fechar (`run.ps1`, `mark.ps1`).**
- Quando uma Task em 🟨 vai a 🔴 (`mark.ps1 -To blocked`), a pausa (`run.ps1 pause`) ou espera de GAP com o código alterado, o script faz o commit **só do escopo do plano**. É a mesma função `Save-TaskCommit`, com o assunto `<T-ID> (checkpoint, sem fechar): <título>` e o trailer `Task-State: parcial`.
- O marcador **não** muda por isso, e o fechamento depois faz o commit final normal. O `close` R7 não conta o checkpoint como entrega.
- No `start`, o run-log e a saída dizem "retomando sobre o checkpoint `<sha>`".
- **Decidido (§8, D1):** checkpoint por commit.

**B · O `start` não começa sobre sobra sem dono (`run.ps1 start`).**
Antes do `Save-ForeignSnapshot`, cada arquivo pendente é classificado:

| Pendente | Ação do `start` |
|---|---|
| no escopo de outra Task não fechada | checkpoint dessa Task (A), sem pergunta |
| em `docs/` declarado como documento vivo | segue a rota da consolidação R12 (v3.59.2) |
| casado por `guards.json → treeIgnore` (novo, lista de globs do projeto, vazia por padrão) | fora do hash da árvore e da cobrança |
| nenhum dos anteriores | **uma** parada ao SM (não ao stakeholder): commitar como `chore`, apagar ou declarar em `treeIgnore`. Fica registrada no run-log. A G24 já impede repetir a pergunta. |

- Com isso o "alheio" da v3.60.1 deixa de ser comum. Ele fica como rede de segurança.

**C · O portão não mede árvore pendente (`gate.ps1`).**
Antes de disparar operator ou QA, o portão roda o checkpoint (A) das Tasks não fechadas e a classificação (B). Se ainda sobrar pendente no escopo de produção, não dispara: devolve "árvore pendente: …" com a mesma rota de B.

**D · "A árvore mudou" diz o quê (`verify.ps1`, `close.ps1`).**
- O `verify.ps1` já grava o hash da árvore (`write-tree`). O objeto fica no repositório, então o `close` pode listar `git diff --name-only <árvore do verify> <árvore de agora>`.
- A mensagem do R7-verify passa a "a árvore mudou depois do verify full: `<arq1>`, `<arq2>`".
- Se todos os arquivos que mudaram estiverem em `treeIgnore` ou forem alheios sem mudança desde o retrato, a árvore do `close` é recalculada sem eles e o verify vale.
- **Conferir no código antes de construir:** se o objeto de árvore do `Get-WorkTree` (índice temporário) sobrevive ao `git gc` até o `close`. Se não sobreviver, o `verify.ps1` grava também a lista de arquivos com hash (como o `-alheios.json`).

---

## 5. Item 7 — a máquina dividida entre projetos

### 5.1 Diagnóstico (Q-S6e, 18/11/2026)

| Hora | Evento | Fonte |
|---|---|---|
| ~19:00–19:17 | 1ª rodada da suíte; o navegador cai depois do teste 1077 de 3138 | `verify/6/Q-S6e/result.json` |
| 19:18 | o projeto repara o alvo e sobe o seu emulador (porta 5554) | `android-avd/run/horta-*.log` |
| **19:21** | **outro projeto da máquina (o benchmark) sobe um servidor do adb próprio** (`ANDROID_ADB_SERVER_PORT` diferente) **e o seu emulador** (porta 5556, GPU por software) | `android-avd/run/bench-*.log`, `scrum-team-benchmark/env/setup-android.ps1:48` |
| 19:22 | o emulador do projeto registra `adb protocol fault (couldn't read status length)` e é desligado | `horta-emulador.out.log` |
| 19:38–19:57 | 2ª rodada da suíte: **~28 s por teste no fim** (a última suíte verde fez 3138 em 14 min, ~0,25 s por teste); um teste de tela estoura os 5 s do Jasmine e o navegador fica 120 s mudo depois do teste 1257 | `full-suite.log` |
| 19:57 | o `verify.ps1` classifica como ambiente e escreve: "o prazo do runner (Karma…) e as flags do navegador são configuração do projeto: **vão por Task, com o Arquiteto**". O executor repassa ao stakeholder que "corrigir exige ajustar a configuração do Karma". | `verify.ps1:165` |

Três defeitos do plugin:
1. **O diagnóstico só olha a memória** (15 GB livres, que não eram o limite), e a única saída que ele sugere é mudar configuração. Ele não mede o processador, não compara o ritmo com a última suíte verde e não vê emulador, adb ou suíte de outro projeto. A configuração do Karma era a mesma da suíte verde de 17/11.
2. **A trava da máquina (v3.63.2) é por aparelho.** Ela não cobre o que os projetos realmente disputam: o servidor do adb (dois servidores na mesma máquina se conectam aos mesmos emuladores e um derruba o outro) e o processador (emulador com GPU por software durante uma suíte de navegador). Script de projeto que sobe emulador por fora do `target.ps1` não toma trava nenhuma.
3. **O verify reaproveita só na mesma árvore** (`verify.ps1:902`). Entre a última suíte verde (árvore `4791640`, 17/11) e a de agora (`8fd37f`) mudaram **só** `source/scripts/alvo/alvo.test.mjs` e `capturar.mjs`, ferramentas Node que o Karma não carrega. Mesmo assim os 3138 testes rodaram duas vezes. E o "último verde" nem existe mais: o `result.json` guarda só o último `full`, e o vermelho de 17/11 à tarde apagou o verde da manhã.

### 5.2 Desenho

**A · O diagnóstico mede a máquina antes de culpar a configuração (`verify.ps1`, `lib.ps1`).**
- **Ritmo:** o `verify.ps1` guarda, por comando, o ritmo da última rodada verde (`lastGreen.<key>.secondsPerTest`, lido do "Executed N of M (x secs)" do runner ou, sem isso, dos segundos do comando). Na queda, calcula o ritmo da rodada que caiu até o ponto da queda.
- **Processador:** três amostras de `LoadPercentage` ao longo da suíte (início, meio, queda) e os 5 maiores consumidores por **tempo de CPU** no intervalo, somados por nome como já se faz com a memória (`Get-TopMemoryText`).
- **Outros projetos:** os processos de emulador (`qemu-system*`, `emulator*`), com o nome do AVD da linha de comando; os servidores do adb (`adb.exe` com porta diferente da padrão); e as travas vivas de **outros** projetos na pasta da máquina (`Get-DeviceLockDir`).
- **A regra da mensagem:**

| O que foi medido | Causa gravada no `environment` | Próxima ação |
|---|---|---|
| ritmo ≥ 2× o da última verde, **ou** CPU ≥ 85% em 2 amostras, **ou** emulador, adb ou trava de outro projeto viva | **máquina ocupada**, com a lista do que ocupava ("emulador bench-a01-api29 de C:\…\scrum-team-benchmark, adb na porta 5557, CPU 91%, ritmo 2,6× o da verde") | esperar a máquina ficar livre (B) e repetir; **não** abre Task, **não** sugere configuração |
| máquina livre (nenhum dos acima) e queda em pontos diferentes | runner instável na máquina livre | aí sim: configuração do projeto, Task com o Arquiteto, com as medidas anexadas |
| queda no mesmo ponto | um teste trava o navegador (como hoje, `verify.ps1:161`) | dev |

**B · Trava de trabalho pesado, comum aos projetos da máquina (`lib.ps1`, `verify.ps1`, `accept.ps1`, `target.ps1`).**
- Uma trava nova na mesma pasta da v3.63.2, `device-locks/machine-heavy.json`, com o mesmo `Enter-LockFile` (atômica, dono vivo, sinal de vida).
- Quem toma: a suíte do `verify full` (comandos `suite*`), o `accept` inteiro e o boot ou reparo de emulador do `target.ps1`. O build fica de fora: é curto e não fica sensível a ficar sem resposta.
- **Dentro do mesmo projeto** a trava é reentrante (o accept que chama o reparo não se bloqueia).
- **Com outro projeto segurando a trava:** espera até `guards.json → machine.heavyWaitMin` (padrão 30), reconferindo a cada 30 s pelo protocolo de espera (watcher), e diz quem segura. Passou o prazo, sai com `ambiente` e o texto "máquina ocupada por <projeto>, desde <hora>" (rota da G24, sem Task).
- **adb — porta por projeto, servidor único (decisão D8).** Cada servidor do adb varre as portas 5554–5585 e se conecta a todo emulador que acha, e o adb não tem opção que limite um servidor a uma faixa. A porta própria do emulador já existia (5554 na horta, 5556 no benchmark); o conflito vem do segundo servidor. O desenho:
  - **um servidor do adb na máquina** (porta padrão), compartilhado; cada projeto fala só com o seu emulador pelo serial (`-s emulator-<porta>`);
  - **porta por projeto** em `guards.json → targets.android.serial` (existe desde a v3.63.2). Antes de ligar o emulador, o `target.ps1 -Repair` e o boot do `accept` conferem que a porta está livre ou é do próprio projeto, que nenhuma trava de aparelho de outro projeto a usa, e que ela é par entre 5554 e 5584 (o par de console e adb). Sem porta declarada, o script **propõe** a primeira par livre que nenhuma trava use, e o `/team update` a grava com o aval do stakeholder; o plugin não escolhe em silêncio;
  - **segundo servidor do adb encontrado:** o plugin para com a causa (`environment`: "dois servidores do adb: porta X de <projeto ou processo>, porta Y") e não desliga nada de outro projeto.
  - O `how-to.md` passa a dizer "um servidor do adb por máquina; uma porta de emulador por projeto".
- **Para scripts fora do plugin** (o `setup-android.ps1` do benchmark, o `emulator-repair.ps1` de um projeto): um comando público, `scripts/checks/machine-lock.ps1 -Take -Owner <nome> [-WaitMin N]` / `-Release`, com saída e código de saída documentados. O projeto chama esse comando no seu script. O plugin não conhece os scripts dos projetos.

**C · Reaproveitar o comando quando o que ele lê não mudou (`verify.ps1`, `close.ps1`, `guards.json`).**
- **Declaração do projeto:** `guards.json → verify` aceita, além do texto do comando, um objeto `{ "command": "…", "inputs": ["source/src/**", "source/karma.conf.js", "source/package.json", "source/angular.json", "source/tsconfig*.json"] }`. Sem `inputs`, o comportamento é o de hoje: a árvore inteira.
- **O último verde de cada comando** passa a ficar em `result.json → lastGreen.<key>`: árvore, hora, comando, linhas decisivas, ritmo e, para a suíte, o resumo de cobertura. Uma rodada vermelha não o apaga.
- **No `verify full`:** para cada comando com `inputs`, se `lastGreen` existe, o comando é o mesmo e `git diff --name-only <árvore do verde> <árvore de agora>` não casa nenhum glob de `inputs`, o comando é **reaproveitado**. O registro diz `reused: inputs` e traz a árvore de origem e a lista dos arquivos que mudaram, todos fora das entradas. A cobertura vai junto com a suíte.
- Se a árvore do verde não puder ser lida (objeto apagado pelo `gc`), o comando roda. Isso usa a mesma lista de arquivos com hash do §4.2 D.
- **`close.ps1` R7-verify:** aceita um comando reaproveitado por entradas e mostra isso na linha `ok` ("suite: verde de 17/11 13:50, entradas sem mudança: 2 arquivos fora delas"). O QA vê no portão.
- **A revisão final não aceita verde reaproveitado.** O portão não roda o verify: a Q11 do `quality.ps1` reaproveita a cobertura do último verify full da mesma árvore (v3.57.3, `quality.ps1:50-66`). Ela passa a aceitar só uma suíte **rodada de fato** na árvore atual; um registro `reused: inputs` não vale. Sem suíte rodada, o comando de medição do portão (`gate.ps1`, passo C/D) roda antes `verify.ps1 -Mode full -Fresh`. Assim um `inputs` declarado errado não leva um verde velho até a Review.
- **No caso da Q-S6e:** com `inputs` da suíte em `source/src/**` e nos arquivos de configuração, a suíte e a cobertura seriam reaproveitadas do verde de 17/11. O `verify full` teria levado ~1 min em vez de ~40, e a queda de ambiente não teria acontecido.

### 5.3 Fora do plugin (projetos do autor, a pedido)
- **benchmark (`scrum-team-benchmark/env/setup-android.ps1`):** usar o servidor do adb padrão em vez de um próprio (tirar o `ANDROID_ADB_SERVER_PORT` da linha 48), manter a porta 5556 declarada no `guards.json → targets.android.serial` e chamar `machine-lock.ps1 -Take` antes de subir o emulador (decisão D8). Mudança no repositório do benchmark, não neste plugin.
- **garden:** declarar `inputs` dos comandos do verify no `guards.json`. É configuração do projeto, feita pelo `/team update` ou pelo Arquiteto.

---

## 6. Item 8 — o portão preso no formato antigo

### 6.1 Diagnóstico (garden, sprint 6, 18/11 à noite)
O `run.ps1 next` mandou abrir a Q-S6f com os achados "Volta para: dev". A Q-S6e (🔴) já cobria os mesmos 21 cenários, e o diagnóstico do operator (`operator/6/S6-alvo/diagnostico.md`, 20:16) já os separava em APP (3) e PLANO (18). São três defeitos do `gate.ps1`, encadeados:
1. **O caminho por causa (v3.63.0) nunca liga num sprint que começou antes dele.** Ele exige uma tabela com a coluna `Cause` (`Read-ValidationFindings`, `lib.ps1:2818`). O prompt da rodada focada (`gate.ps1:188`) pede ao QA a tabela `| ID | State | Evidência |`, sem `Cause`. O QA escreveu a causa dentro da célula do ID (`S6-F4-1 (novo, Cause: environment)`), e o leitor não lê. O `validation.md` fica no formato antigo para sempre.
2. **O caminho antigo abre uma Q-S<n> nova sem olhar as abertas** (`gate.ps1:194-205`): só calcula a próxima letra.
3. **O diagnóstico não conta como informação nova.** A rodada focada só é pedida quando o `result.json` do aceite ou da qualidade é mais novo que o `validation.md` (`gate.ps1:196`, `:271`). O diagnóstico das 20:16 não pesa, e a separação APP/PLANO não chega ao QA.

### 6.2 Desenho
- **A · A rodada focada sai no formato novo (`gate.ps1`, prompt do `$revise`).** A tabela da rodada passa a ser `| ID | Task | Achado | Onde | Cause | Owner | State | Evidência |`. Quando o `validation.md` ainda não tem tabela com `Cause` (`-not $vf.HasTable`), o prompt manda também **reescrever na tabela nova cada achado antigo ainda aberto**, com ID `S<n>-F<k>` e uma causa. Achado já resolvido fica como está. Depois dessa rodada, o `next` segue pelo caminho por causa.
- **B · Nenhuma Q-S<n> nova com outra aberta (`gate.ps1`, os dois pontos que abrem Q-S).** Antes de propor `abrir Q-S<n><x>`, o script procura Q-S do sprint fora de ✅:
  - **com uma aberta** e no formato antigo: não abre; manda a sessão incluir os achados na correção aberta e segue o marcador dela (🔴 → a rota do bloqueio dela; 🟨/⬜ → `esperar`);
  - no caminho por causa: o achado `code` sem Q-S que o cite vai à Q-S aberta (a linha dela no quadro ganha o ID). Só abre Q-S nova se não houver nenhuma aberta.
  - **Achado novo numa Q-S aberta volta ao Arquiteto.** O plano dela foi escrito para outros achados. Na Q-S6e, ele só permite tocar `source/scripts/alvo/`, e os achados `code` pedem `source/src/`. Por isso, ao receber IDs novos, a Q-S volta ao Arquiteto (`/arc question`, instância nova, com os IDs e o diagnóstico) para emendar o plano. O `plan.ps1` confere o plano emendado antes de o dev retomar.
  - **Sem "esperar" atrás de Q-S em 🔴.** O fim do portão (`gate.ps1:275`, "esperar — a Q-S que os corrige ainda não fechou", exit 3) só vale com a Q-S em 🟨 ou 🟪. Com ela em 🔴, a saída é a rota do bloqueio dela. Sem isso, o watcher esperaria uma Task que só reabre por ação de alguém.
  - **Correção substituída:** Q-S cujo plano declara `**Corrige:** Q-S<n><y>` faz a `Q-S<n><y>` contar como encerrada (`substituída por …`, no Registro e no quadro, por `mark.ps1`). Assim uma correção antiga parada não segura o portão (no garden, a Q-S6d em 🔴, que a Q-S6e corrige).
- **C · Diagnóstico mais novo que o veredito é motivo de rodada focada (`gate.ps1:196` e `:271`).** A lista `$measAt` passa a incluir o `diagnostico.md` do portão. Com ele mais novo, o `next` pede a rodada focada (A), com o `$diagTxt` no prompt, e o QA registra APP como `code` e PLANO como `scenario` ou `design`.

### 6.3 Testes (somar à §9)
- validation antigo + medição ou diagnóstico novo → o prompt da rodada pede a tabela com `Cause` e a conversão dos abertos; com a rodada escrita assim, o `next` segue por causa.
- Q-S do sprint em 🔴 ou 🟨 → nenhum "abrir Q-S" nos dois caminhos; o `code` sem dono vai à aberta e ela volta ao Arquiteto com os IDs novos.
- achados abertos com dono e a Q-S em 🔴 → a rota do bloqueio, nunca `esperar` (exit 3).
- plano com `**Corrige:** Q-S1b` → a Q-S1b conta como substituída e não segura o portão.
- `diagnostico.md` mais novo que o `validation.md`, aceite e qualidade mais velhos → rodada focada.

---

## 7. Arquivos

| Arquivo | Mudança |
|---|---|
| `scripts/checks/close.ps1` | coluna `natureza` nas linhas `falhou`; R7 (modo dev) pelo `result.json`; R12 com padrão do plano; R7-margem com formato em `aviso`; mensagens que dependem do plano; R7-verify com a lista de arquivos que mudaram |
| `scripts/checks/run.ps1` | `done`: preenchimento mecânico, rota por natureza, assinatura de repetição; `Write-Handoff`: duas seções; `start`: classificação dos pendentes e checkpoint; checkpoint na pausa |
| `scripts/checks/mark.ps1` | checkpoint ao ir a 🔴 com escopo alterado |
| `scripts/checks/verify.ps1` | (se necessário, §4.2 D) lista de arquivos com hash no `result.json`; ritmo, CPU e outros projetos no diagnóstico de queda; `lastGreen` por comando; reaproveitamento por `inputs`; trava pesada na suíte |
| `scripts/checks/lib.ps1` | `Get-WorkTree` lê `treeIgnore`; helper `Get-TreeDiff`; `Save-TaskCommit` com modo checkpoint; `Get-MachineLoad` (CPU, emuladores, servidores do adb, travas de outros projetos); `Enter-HeavyLock`/`Exit-HeavyLock` |
| `scripts/checks/quality.ps1` | item 7 C: a Q11 recusa a cobertura de suíte `reused: inputs` |
| `scripts/checks/machine-lock.ps1` (novo) | a trava pesada da máquina para scripts fora do plugin (`-Take`/`-Release`/`-Who`) |
| `scripts/checks/gate.ps1` | item 6 C: árvore pendente antes da rodada · item 7 C: `verify full -Fresh` na medição quando a suíte foi só reaproveitada · item 8: prompt da rodada com `Cause` e conversão do formato antigo; nenhuma Q-S nova com outra aberta; achado novo volta ao Arquiteto; sem "esperar" atrás de 🔴; diagnóstico como informação nova; correção substituída |
| `scripts/checks/plan.ps1` | item 8 B: conferir o plano emendado da Q-S que recebeu achados novos (o mecanismo de conferência já existe; muda o gatilho) |
| `scripts/checks/accept.ps1`, `scripts/checks/target.ps1`, `scripts/checks/targets/android.ps1` | trava pesada no accept e no boot/reparo; conferência de mais de um servidor do adb |
| `agents/task-runner.md`, `agents/developer.md`, `agents/operator.md` | a evidência mecânica não é mais do dev; a rodada de prova do operator no `done` |
| `roles/developer/templates/delivery.md` | a seção "Prova registrada" é do script; o dev não cola mais por obrigação |
| `roles/scrum-master/process/sprint-run.md` e `process-changelog.md` | addendum v3.64: rotas do `done`, checkpoint, sobra sem dono, trava pesada, Q-S única por vez no portão |
| `roles/quality-assurance/templates/sprint-validation.md` e `agents/quality-assurance.md` | a tabela da rodada focada com `Cause`, igual à do prompt (item 8 A) |
| `templates/guards.json` (e a documentação dele) | `treeIgnore`; `verify.<key>.inputs`; `machine.heavyWaitMin` |
| `how-to.md` | uma linha por mudança visível; "um servidor do adb por máquina"; como um script do projeto usa o `machine-lock.ps1` |
| `CHANGELOG.md` | bloco `## v3.64.0` |
| `scripts/checks/tests/run-check-tests.ps1` | casos v3.64.0 (§9) |

---

## 8. Decisões do stakeholder

> **Respondidas em 18/11/2026 (formulário): as cinco pela recomendação.** D1 commit de checkpoint · D2 formato vira aviso · D3 prova não rodada vai ao operator · D4 escalona na 2ª repetição idêntica · D5 uma entrega só, a 3.64.0.

| # | Decisão | Recomendação | Por quê |
|---|---|---|---|
| D1 | Checkpoint de Task parada: **commit** com trailer `Task-State: parcial`, ou **`git stash`** nomeado | **commit** | o stash some do hash e do histórico, quebra quando duas Tasks tocam o mesmo arquivo (T-089 → T-092, migrações em sequência) e não aparece na Review. O commit é o que o stakeholder já escolheu à mão no `6e84fcf`. |
| D2 | Formato da linha de ajuste da margem: **aviso** quando a leitura tolerante entende a linha | sim | as travas que provam o ajuste continuam bloqueantes; o formato não prova nada |
| D3 | Prova não rodada vai ao **operator** sem passar pelo dev | sim | é rodar um comando (R28); o dev novo relia o plano só para isso |
| D4 | Repetição idêntica: **2ª vez** já escalona | sim | no sprint 6, nenhuma 3ª tentativa igual deu resultado diferente |
| D5 | Uma entrega só (3.64.0) ou três patches (2, 5, 6 separados) | **uma** | o item 5 C depende do item 2 B, e o item 6 D muda a mensagem do item 2 |

> **Item 7, acrescentado em 18/11 depois das respostas acima. Respondidas no mesmo dia: D6 e D7 pela recomendação; D8 refeita a pedido do stakeholder ("cada projeto abre o emulador numa porta que outro não use?") e decidida como "porta por projeto, adb único" (nota abaixo da tabela).**

| # | Decisão | Recomendação | Por quê |
|---|---|---|---|
| D6 | Trabalho pesado de **projetos diferentes** (suíte, aceite, boot de emulador): **um por vez na máquina**, com espera de até 30 min, ou só avisar e deixar rodar junto | **um por vez** | no sprint 6, rodar junto custou ~40 min de suíte e o emulador do projeto; esperar 30 min sai mais barato que repetir |
| D7 | Reaproveitar o verde de um comando quando nada do que ele lê (`inputs` declarado pelo projeto) mudou | sim, **com a revisão final exigindo suíte rodada de fato** | a Q-S6e rodou 3138 testes duas vezes por dois arquivos que o Karma não lê; a exigência na revisão final pega um `inputs` declarado errado antes da Review |
| D8 | Dois projetos com emulador: ~~parar ao achar dois servidores do adb~~ → **porta por projeto, servidor do adb único** (refeita a pedido do stakeholder) | **decidido** | uma porta própria por projeto não basta, porque o servidor do adb se conecta a todo emulador da máquina; o desenho está em §5.2 B |

---

## 9. Testes

Na suíte `run-check-tests.ps1`, marcados v3.64.0:

**Item 2**
- delivery sem bloco colado + `result.json` verde na árvore atual → R7 ok e bloco "Prova registrada" escrito; sem agente.
- sem a seção R12, plano com `**Documentos vivos:**` → seção escrita com a lista do plano e `a consolidar`; com a seção do dev, ela prevalece.
- linha de margem com Id lido e formato torto → `aviso`; trava de mutação não pega → continua `falhou`.
- verify full ausente → rota operator, contador do dev não sobe; suíte vermelha → dev normal, cartão sem "não mude código".
- mesma assinatura e mesma árvore duas vezes → Arquiteto, sem 3ª instância; árvore diferente → instância normal.
- modo QA (evidência do QA) → nada muda (regressão).

**Item 5**
- a matriz de não-contradição de §3.2 D (48 combinações).
- plano com `Aceite: não roda` → a mensagem do R7 não cita accept.

**Item 6**
- Task A em 🟨 com escopo alterado vai a 🔴 → commit checkpoint só com o escopo, marcador inalterado; Task B começa → nenhum alheio de A.
- pendente fora de qualquer escopo → uma parada ao SM; em `treeIgnore` → fora do hash.
- portão com pendente no escopo de produção → não dispara.
- verify, depois mudança só em arquivo de `treeIgnore` → R7-verify ok; mudança em arquivo do escopo → falhou, com o nome do arquivo.

**Item 7** (processos, CPU, adb e emuladores simulados por variáveis de teste, como o `TEAM_TEST_DEVICE_SERIAL` da v3.63.2 — nenhum toque na máquina real)
- queda em pontos diferentes com ritmo 2,6× o da última verde → `environment` "máquina ocupada" com o ritmo; **sem** "vão por Task, com o Arquiteto".
- queda com emulador de outro projeto vivo → a mensagem cita o AVD e a pasta do projeto.
- queda em pontos diferentes com a máquina livre → a mensagem de configuração do projeto, com as medidas.
- trava pesada de outro projeto viva → a suíte espera e depois sai `ambiente` com o dono; trava do mesmo projeto → reentrante, sem espera.
- `machine-lock.ps1 -Take` de um script de fora → o `verify` do projeto espera por ele; `-Release` → segue.
- dois servidores do adb → o `target.ps1 -Repair` para com a causa e não mata nenhum.
- porta declarada em uso por emulador de outro projeto → recusa com o nome do projeto; sem porta declarada → proposta da primeira par livre, sem gravar; porta ímpar ou fora da faixa → recusa.
- `inputs` da suíte sem mudança desde o `lastGreen` → suíte e cobertura reaproveitadas, com `reused: inputs` e a lista do que mudou; um arquivo de `inputs` mudou → roda; sem `inputs` → como hoje.
- rodada vermelha depois de uma verde → `lastGreen` preservado.
- revisão final com a suíte só reaproveitada por `inputs` → a Q11 não a aceita e a medição roda `verify full -Fresh` antes; com suíte rodada de fato na árvore atual → reaproveita como hoje.

**Item 8:** os cinco casos da §6.3.

**Suítes inteiras:** `run-check-tests.ps1` e `run-guard-tests.ps1` verdes; os testes não tocam o git real do projeto nem o adb (lição da v3.63.1).

---

## 10. Ordem de construção

1. **Item 8 A, B e C.** Vem primeiro porque o sprint 6 do piloto está parado no portão agora. É só o `gate.ps1` (e o gatilho do `plan.ps1`), independente dos outros.
2. **Item 5 A e B.** O cartão em duas seções e as mensagens do `close`. É pequeno, isolado e destrava a leitura dos itens 2 e 6.
3. **Item 2 A e B.** A natureza nas linhas do `close`, o preenchimento mecânico e a rota do `done`.
4. **Item 2 C.** A assinatura de repetição.
5. **Item 6 A e B.** O checkpoint e a classificação no `start`.
6. **Item 6 C e D.** O portão e a lista de arquivos que mudaram.
7. **Item 7 A.** O diagnóstico da máquina. Sozinho, ele já troca a mensagem errada da Q-S6e.
8. **Item 7 C.** O `lastGreen` e o reaproveitamento por `inputs`, que usa a lista de arquivos do passo 6.
9. **Item 7 B.** A trava pesada, o `machine-lock.ps1`, a porta por projeto e a conferência do adb.
10. Papéis, processo, `how-to.md`, `CHANGELOG.md`, suítes.

## 11. Como saber, no campo, que deu certo

No próximo sprint do piloto, contar no `run-log.md`:
- "evidência incompleta → dev": **cerca de metade** do sprint 6 ou menos (eram 58; a reaplicação da §2.3 dá ~28), todas com natureza `prova-vermelha` ou `escopo`; nenhuma só por papel;
- nenhuma reprovação idêntica seguida 3 vezes;
- nenhum 🔺 GAP de processo do tipo "o cartão diz X, o plano diz Y";
- nenhum commit manual de salvaguarda, e nenhum achado do portão de "árvore sem commit";
- nenhuma queda da suíte atribuída à configuração quando havia outro projeto pesado na máquina; o `verify full` de Task que não toca as entradas da suíte termina em minutos, com `reused: inputs`;
- nenhum `adb protocol fault` com dois projetos ativos;
- nenhum "abrir Q-S" com outra Q-S do sprint aberta, e a rodada seguinte do portão já sai com a tabela de `Cause`.
