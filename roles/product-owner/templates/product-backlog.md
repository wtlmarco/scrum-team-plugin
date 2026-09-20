# Product Backlog

> **DOCUMENTO VIVO** · **Dono:** PO · **Atualizado em:** <data>
> **O Product Backlog é o índice ordenado das Histórias** (R20 · [`artifact-ownership.md` §1d](../../scrum-master/process/artifact-ownership.md)). Cada História vive em arquivo próprio, `.team-project/product-owner/stories/<H-ID>-<slug>.md`; aqui entra só a linha de índice, com o ID linkando para esse arquivo. Ordenado por **valor de produto × risco funcional**. A tradução disto em Tasks, com estimativa e dependência técnica, acontece na Planning Meeting e vive no Sprint Backlog do SM.

## Régua de priorização

1. Impede o produto de funcionar ponta a ponta
2. Expõe risco jurídico ou de segurança
3. Impede saber se funciona (validação)
4. Degrada a experiência sem impedir o fluxo
5. Dívida técnica e documentação

## Histórias

| # | ID | História | Valor para o usuário | Origem | Tamanho | Estado |
|---:|---|---|---|---|---|---|
| 1 | [H-<nnn>](stories/H-<nnn>-<slug>.md) | <título na voz do usuário> | <o que ele passa a conseguir fazer> | RF-<nnn> / GAP <ID> / Review <n> | P/M/G | esboço · detalhada · **aprovada** · em sprint · entregue |

**Estados.** `esboço` — nasceu do SDD, tem valor declarado. `detalhada` — tem regras, protótipos e critérios de aceite, pronta para o pacote de abertura de um sprint; **o ③ ainda não aconteceu** — ele é em lote, depois da Planning (R20 · R25). `em sprint` — entrou na Planning e foi **congelada** em `sprints/<n>/stories/H-nnn.md` na aprovação do pacote — é ali que o ③ desta História aconteceu. `entregue` — aceita na Sprint Review.

**Este documento é a fonte viva.** `sprints/<n>/stories/H-nnn.md` é uma **cópia congelada**, gravada na aprovação do pacote de abertura — mesmo ID, objeto diferente (R4 · R25). Editar a História aqui durante o sprint **não** altera o congelado; o ajuste concorre no Product Backlog e entra no sprint seguinte.

O conteúdo de cada História — regras funcionais, protótipos, critérios de aceite, aprovação do portão ③ — segue [`user-story.md`](user-story.md) e vive **sempre** em arquivo próprio, `.team-project/product-owner/stories/<H-ID>-<slug>.md`. Este documento nunca carrega esse conteúdo: só a linha de índice acima, com o ID linkando para o arquivo.

## Plano de entrega

> **Dono: PO.** É aqui que se responde *quando o valor chega*. O time dá as **estimativas** e o SM dá a **capacidade observada**; a decisão de o que entra em que sprint é sua ([`workflow.md` §6a](../../scrum-master/process/workflow.md)). Não é documento novo — é seção desta lista, para não haver duas verdades sobre prazo.

| Sprint | Histórias previstas | Soma estimada | Capacidade (SM) | Compromisso externo |
|---|---|---|---|---|
| <n> *(corrente)* | H-<nnn>, H-<nnn> | <n> | <n> | <data prometida a alguém de fora, ou "nenhum"> |
| <n+1> | H-<nnn> | <n> | <n> | |
| adiante | H-<nnn>, H-<nnn> | — | — | |

**Como manter.** Reordenar junto com o backlog, a cada `/po prioritize`. Revisar na Planning (o que entrou) e na Review (o que deslocou). **Estimativa que ainda não existe fica em branco** — não invente número para preencher a tabela: História só é estimada quando o time a quebra em Tasks, na Planning.

**Quando uma História desloca**, registre o motivo em uma linha. Deslocamento sem motivo escrito é o que faz o plano perder credibilidade antes de perder a data.

## Requisitos em elaboração

| RF | Título | Situação | Bloqueio |
|---|---|---|---|
| RF-<nnn> | <título> | rascunho / em análise / aprovado | <o que falta decidir> |

## Ressalvas e débitos vindos da Sprint Review

> Toda ressalva de aceite e todo débito levantado na Review entra aqui **na mesma sessão** (R12 · R21), com dono. Ressalva verbal desaparece.

| Origem | Sprint | O que ficou devendo | Vira | Dono |
|---|---|---|---|---|
| H-<nnn> | <n> | <o que o stakeholder ressalvou> | H-<nnn> nova / Task na próxima Planning | <papel> |

## O que não entrou na priorização mais recente

> **Peça obrigatória do pacote de abertura do sprint seguinte** (R25 · [`workflow.md` §5e](../../scrum-master/process/workflow.md) passo 9). No pacote o stakeholder vê o que **entrou** — sem esta lista, uma pendência crítica que despriorizei passa despercebida. Eu forneço esta lista ao SM, que a grava em `planning.md`; eu **proponho** a priorização, o stakeholder **aprova o pacote** e pode devolver.

| Item (Review de origem, sprint) | Motivo de não entrar agora | Reavaliar quando |
|---|---|---|
| <ID — título> | <valor × risco, capacidade, dependência…> | <próxima Planning / condição específica> |

## Decisões funcionais pendentes do stakeholder

| # | Questão | Opções | Recomendação do PO |
|---:|---|---|---|
| 1 | <pergunta> | A) … B) … C) … | <qual e por quê> |

## Fora de escopo (registrado para não voltar toda semana)

| O que | Por que está fora | Reavaliar quando |
|---|---|---|

---

## Como manter

- Reordenar a cada `/po prioritize`; a ordem daqui alimenta a seleção de candidatas na Planning Meeting.
- **História só sai do backlog quando aceita na Sprint Review** — não quando construída, e não quando todas as suas Tasks fecharam (R21).
- **História rejeitada na Review volta ao índice** no estado `detalhada`; o arquivo da História mantém as Tasks já feitas anotadas, para não se refazer o que passou no QA.
- Detalhar **só o que candidata ao próximo sprint** — o detalhamento é lá no arquivo da História, não aqui. Conjunto de Histórias detalhadas por inteiro envelhece antes de ser construído.
- "Fora de escopo" existe para poupar a discussão recorrente: registre o motivo e o gatilho de reavaliação.
- **A cada Planning, atualizar "O que não entrou na priorização mais recente"** antes de o SM montar o pacote de abertura — é a peça que garante que despriorização não vira pendência invisível (R25).
- **`sprints/<n>/stories/` não é editado por aqui.** Uma vez congelado na aprovação do pacote, é registro fechado do sprint; a fonte viva continua sendo este backlog (R4 · R25).
