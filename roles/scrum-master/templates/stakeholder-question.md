# Template — Pergunta ao stakeholder (H1)

Vale para **todo** ponto que vai ao stakeholder: o bloqueio que o degrau 1 não fechou (R22), os ajustes do `fix plan` (R33), a autorização da Review, o escopo da triagem, a ocorrência de plugin e as propostas de melhoria. O stakeholder decide rápido quando entende o problema na primeira leitura; no benchmark, decisões escritas na linguagem do processo precisaram de várias voltas até ficarem claras.

A guarda G3 confere duas coisas no formulário: a última opção é **"Pedir mais contexto"** e há um **exemplo** (na pergunta ou na descrição de uma opção). O resto é do SM, na retrospectiva.

## Antes de perguntar — a decisão é dele? (v3.58.3)

**Quem decide é a [matriz de impasses](../process/impasse-matrix.md) (v3.66.0, R36), a fonte única.** Antes de qualquer formulário, declare o impasse no `scripts/checks/impasse.ps1 raise`: ele diz o dono, recusa o que já foi decidido e, só para o tipo que sobe, grava a rota sem a qual a G24 nega o formulário, em qualquer sessão. Os casos já vividos (o cenário que só se prova por teste, o "sigo?", o APK que não muda, o achado de cenário que volta…) estão, com o tipo de cada um, na §6 da [matriz](../process/impasse-matrix.md). Este modelo trata só da **forma** da pergunta que sobe.

Durante o `sprint run`, a **G24** nega o formulário sem a rota que o `run.ps1` grava (`.team-project/.ask-route`). A rota vale para **um** formulário: as refações nos 10 minutos seguintes (a G3 recusou a forma) passam, e outra pergunta pede rota nova. Decidida a pergunta, a linha dela sai da §7 do README **na mesma resposta** (R34): pendência respondida que fica lá vira pergunta repetida na sessão seguinte.

## O formato

1. **O problema em uma ou duas frases**, sem sigla, sem nome de regra, sem nome de arquivo.
2. **Um exemplo prático e concreto**, tirado do próprio produto, começando por "Exemplo:".
3. **O que muda em cada opção**, na descrição da opção (custo, prazo, risco, o que o usuário vê).
4. **A recomendação primeiro**, com "(Recomendado)" no rótulo.
5. **"Pedir mais contexto" sempre por último.** Escolhido, a sessão explica em texto curto e **repete o formulário na mesma resposta**. Detalhe longo: uma opção "Ver a explicação completa" mostra o texto e repete o formulário.

**Toda pergunta é formulário (v3.53.2)**, não só a decisão: dado, confirmação, escolha ou próximo passo saem como formulário na mesma resposta, nunca como pergunta em texto. Na pergunta aberta, as respostas prováveis viram opções, e o stakeholder escreve outra no campo **"Outro"**, que o formulário já traz.

**Linguagem simples:** rótulo com 1 a 5 palavras e descrição de uma frase, dizendo o que muda para ele. Termo técnico só quando é indispensável, e explicado na hora ("o plano da Task, isto é, o passo a passo que o dev segue").

**O ponto de partida é o texto do script (v3.65.11).** A rota ao stakeholder que o `run.ps1` grava leva a linha PARA O STAKEHOLDER (`.team-project/.ask-route` → `plain`). O formulário parte dela e acrescenta o exemplo do produto; escrever do zero fica para o caso que o script não conhece. A G3 recusa, na pergunta e nas opções: código de versão (hash), ID interno (`Q-S6k`, `S6-F15`, `SC-161`), nome de arquivo (`guards.json`, `target.ps1`), comando (`adb`, `run.ps1`), código de saída (`exit 4`), nome de regra ou guarda (`R25`, `G24`) e papel interno (operator, task-runner, watcher). O prefixo R34 fica de fora. No garden (22/11), a pergunta "reinstale o APK eb971aea13b1; o target.ps1 deu exit 4" voltou com "não entendi nada".

Texto de apoio (antes do formulário): no máximo um parágrafo curto. O detalhe técnico fica no material citado, nunca na pergunta.

## Pergunta aberta — exemplo

> **Pergunta:** Qual nome o app deve mostrar na tela inicial? Exemplo: hoje aparece "meu-projeto", o nome da pasta do projeto.
>
> | Opção | Descrição |
> |---|---|
> | **Horta Fácil (Recomendado)** | o nome usado nos documentos do produto |
> | **Minha Horta** | mais curto; cabe inteiro no ícone do celular |
> | **Pedir mais contexto** | o time mostra onde o nome aparece e repete a pergunta |
>
> *(Para outro nome, o stakeholder escreve no campo "Outro".)*

## Exemplo

> **Pergunta:** O raio inicial da busca pode mudar de 200 km para 150 km? Exemplo: hoje, ao abrir o app em São Paulo, aparecem 17 destinos; com 150 km aparecem 12, e Paraty, Cunha e Ubatuba saem da primeira tela.
>
> | Opção | Descrição |
> |---|---|
> | **Aprovar 150 km (Recomendado)** | a lista inicial fica menor e mais perto; muda uma regra do documento funcional; entra no próximo bloco de correções |
> | **Manter 200 km** | nada muda; o pedido sai da fila |
> | **Tratar como História** | vira item do backlog, com análise de impacto antes de entrar num sprint |
> | **Pedir mais contexto** | o time mostra as duas listas lado a lado e repete a pergunta |

## Como não escrever

- "Aprova o ajuste F-012 (C1 ✔, delta em 01-requirements §R7)?" — sigla e regra, sem o que muda para o usuário.
- "Sigo?" — não é decisão do stakeholder (paradas legítimas, `sprint-run.md`).
- Uma pergunta que exige abrir três arquivos para responder.
