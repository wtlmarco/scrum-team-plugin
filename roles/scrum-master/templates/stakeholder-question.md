# Template — Pergunta ao stakeholder (H1, v3.51)

Vale para **todo** ponto que vai ao stakeholder: o bloqueio que o degrau 1 não fechou (R22), os ajustes do `fix plan` (R33), a autorização da Review, o escopo da triagem, a ocorrência de plugin e as propostas de melhoria. O stakeholder decide rápido quando entende o problema na primeira leitura; no benchmark, decisões escritas na linguagem do processo precisaram de várias voltas até ficarem claras.

A guarda G3 confere duas coisas no formulário: a última opção é **"Pedir mais contexto"** e há um **exemplo** (na pergunta ou na descrição de uma opção). O resto é do SM, na retrospectiva.

## Antes de perguntar — a decisão é dele? (v3.58.3)

A forma vem depois da pergunta certa. No sprint 6 do projeto piloto, 12 de 22 formulários eram decisões que o roteiro já tomava ou que eram do par PO + Arquiteto. Antes de abrir o formulário, confira:

| Se a pergunta é… | Quem decide | O que fazer |
|---|---|---|
| cenário que só se prova por teste de código | o roteiro | marcar `(teste)` na coluna Cenários e uma linha no run-log, sem formulário |
| nome de teste (id) que falta na tela | Arquiteto | 🔺 GAP: ele estende o plano ou o contrato de ids |
| teste vermelho fora da Task, premissa da sessão, em que commit entra uma correção, ordem da fila | par PO + Arquiteto (degrau 1) | `mark.ps1 -To blocked`; a fila segue nas independentes |
| dois planos para a mesma Task, ajuste de lint previsto no plano | Arquiteto / o próprio plano | comparar e seguir; avisar em uma linha |
| "sigo?", "tento de novo?", "retomo o sprint?" | o roteiro | `run.ps1 next` (ou, em outro comando, dizer em uma linha como retomar) |
| estado de um processo, de um arquivo, de um log | quem pergunta | ler; nunca pedir ao stakeholder que rode um comando de leitura |
| *(v3.62.0)* o `accept` sai com exit 4 e `configuration` no `result.json` (APK sem depuração da WebView, Node < 22, várias páginas sem `cdp.pageUrl`, app híbrido com `uiautomator`) | **o stakeholder**, dono do `guards.json` e do build — não é GAP, nem ambiente da Task, nem decisão do Arquiteto | formulário com a mensagem do `accept` e o que corrigir; sem reparo, sem dev, sem política de `deviceProofFallback` (não se aplica) |
| *(v3.60.1)* a prova no aparelho não roda (estado de partida; serviço fora do ar) | a política do projeto (`guards.json` → `run.deviceProofFallback`) ou, sem ela, o stakeholder **uma vez** | com a política, o `run.ps1 done` aplica a prova por teste sozinho; sem ela, no formulário ofereça gravar a política, e a resposta se aplica com `run.ps1 prove -Task <T-ID>` — nunca editando plano ou quadro à mão |
| *(v3.60.1)* a decisão já tomada não chegou ao plano ou ao quadro; "posso tirar de 🔴?" | o roteiro | `run.ps1 prove` (prova por teste) ou `mark.ps1`; nunca perguntar de novo o que já foi respondido |
| *(v3.60.1)* plano acima de 30 KB numa Task em construção | Arquiteto | as decisões de 🔺 GAP não contam para o teto; se ainda passa, o `run.ps1 start` dá o prompt dele — nunca "encurtar ou dividir?" ao stakeholder |
| *(v3.60.1)* arquivo alterado por outra Task trava o fechamento | o roteiro | o que já estava alterado quando a Task começou não é dela (`handoff/<T-ID>-alheios.json`); o close o ignora, siga |
| *(v3.60.1)* id dinâmico que falta, comentário no HTML × lista no guards.json | Arquiteto | declara no código (`// testid-dinamico: <padrão>`), sem mexer no `guards.json` e sem formulário |
| *(v3.60.1)* serviço do ambiente desligado (Docker…) | o roteiro | declarado em `guards.json` → `run.prereqs`, o `run.ps1 start` o sobe; formulário só se ele não subir |
| *(v3.60.1)* "pode pausar?" / o stakeholder mandou parar | o stakeholder já decidiu | `run.ps1 pause` (apaga o `.active-run` e registra); nunca pedir que ele apague arquivo |
| *(v3.60.1)* "quando posso atualizar o plugin?" | o roteiro | todo reinício por teto de contexto e todo intervalo entre Tasks é ponto seguro — a linha PARA O STAKEHOLDER já diz |

Durante o `sprint run`, a **G24** nega o formulário sem a rota que o `run.ps1` grava (`.team-project/.ask-route`). Desde a v3.60.1 a rota vale para **um** formulário: as refações nos 10 minutos seguintes (a G3 recusou a forma) passam, e outra pergunta pede rota nova. Decidida a pergunta, a linha dela sai da §7 do README **na mesma resposta** (R34): pendência respondida que fica lá vira pergunta repetida na sessão seguinte.

## O formato

1. **O problema em uma ou duas frases**, sem sigla, sem nome de regra, sem nome de arquivo.
2. **Um exemplo prático e concreto**, tirado do próprio produto, começando por "Exemplo:".
3. **O que muda em cada opção**, na descrição da opção (custo, prazo, risco, o que o usuário vê).
4. **A recomendação primeiro**, com "(Recomendado)" no rótulo.
5. **"Pedir mais contexto" sempre por último.** Escolhido, a sessão explica em texto curto e **repete o formulário na mesma resposta**. Detalhe longo: uma opção "Ver a explicação completa" mostra o texto e repete o formulário.

**Toda pergunta é formulário (v3.53.2)**, não só a decisão: dado, confirmação, escolha ou próximo passo saem como formulário na mesma resposta, nunca como pergunta em texto. Na pergunta aberta, as respostas prováveis viram opções, e o stakeholder escreve outra no campo **"Outro"**, que o formulário já traz.

**Linguagem simples:** rótulo com 1 a 5 palavras e descrição de uma frase, dizendo o que muda para ele. Termo técnico só quando é indispensável, e explicado na hora ("o plano da Task, isto é, o passo a passo que o dev segue").

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
