# Product Backlog

> **DOCUMENTO VIVO** · **Dono:** PO · **Atualizado em:** <data>
> **O Product Backlog é o conjunto das Histórias** (R20). Ordenado por **valor de produto × risco funcional**. A tradução disto em Tasks, com estimativa e dependência técnica, acontece na Planning Meeting e vive no Sprint Backlog do SM.

## Régua de priorização

1. Impede o produto de funcionar ponta a ponta
2. Expõe risco jurídico ou de segurança
3. Impede saber se funciona (validação)
4. Degrada a experiência sem impedir o fluxo
5. Dívida técnica e documentação

## Histórias

| # | ID | História | Valor para o usuário | Origem | Tamanho | Estado |
|---:|---|---|---|---|---|---|
| 1 | H-<nnn> | <título na voz do usuário> | <o que ele passa a conseguir fazer> | RF-<nnn> / GAP <ID> / Review <n> | P/M/G | esboço · detalhada · **aprovada** · em sprint · entregue |

**Estados.** `esboço` — nasceu do SDD, tem valor declarado. `detalhada` — tem regras, protótipos e critérios de aceite. `aprovada` — passou no portão ③ e pode entrar na Planning. `em sprint` — está no Sprint Backlog corrente. `entregue` — aceita na Sprint Review.

O conteúdo de cada História segue [`user-story.md`](user-story.md), no arquivo da História ou em seção própria deste documento — a escolha é do projeto, declarada em `.team-project/product-owner/context.md`.

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
- **História rejeitada na Review volta para cá inteira**, com as Tasks já feitas anotadas, para não se refazer o que passou no QA.
- Detalhar **só o que candidata ao próximo sprint**. Backlog detalhado por inteiro envelhece antes de ser construído.
- "Fora de escopo" existe para poupar a discussão recorrente: registre o motivo e o gatilho de reavaliação.
