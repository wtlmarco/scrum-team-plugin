# Template — Sprint Review (`/sm sprint review`)

> **Dono do registro:** SM · **Conduz o aceite:** PO (R21) · **Decide:** o stakeholder, sobre o que viu.
> Fecha o trabalho do sprint, **antes** da retrospectiva. É o único momento em que uma História é aceita, e o **segundo ponto de contato** do sprint (R25 · [`../process/workflow-sprint.md` §5g](../process/workflow-sprint.md)).
> **Persistido em** `.team-project/sprints/<n>/review.md` — a pasta já existe desde o `/sm sprint plan`; este arquivo entra nela no `/sm sprint review`. Duas formas: a Review feita (abaixo) e a **Review adiada** (variante no fim).

O SM conduz o ritual e registra; o **PO demonstra cada História contra os critérios de aceite que o stakeholder aprovou no pacote de abertura** (portão ③) e escreve o dossiê de aceite critério a critério; o QA fornece a evidência por Task; **o stakeholder decide, por História**. O SM **não aceita** — registra.

```markdown
## Sprint Review — Sprint <n> — <data>

**Objetivo do sprint:** <a frase declarada na Planning>
**Pacote de abertura aprovado em:** <data> — os critérios contra os quais esta Review mede são os que ele aprovou ali
**Participantes:** stakeholder (**decide**) · PO (demonstra e conduz o aceite) · SM (conduz e registra) · QA (evidência) · <demais>

### Histórias do sprint

> A coluna **Decisão** é o **veredito do stakeholder**, por História, sobre o que ele viu demonstrado. Decisão preenchida sem o stakeholder presente é registro falso — achado de processo.

| História | Tasks | Todas fechadas? | Decisão (stakeholder) | Motivo em uma frase |
|---|---|---|---|---|
| H-<nnn> <título> | T-<nnn>, T-<nnn> | sim / não: <quais faltam> | ✅ aceita · ⚠️ com ressalva · ❌ rejeitada | <por quê> |

O aceite detalhado de cada História — critério a critério, com a Task e a evidência — segue [`../../product-owner/templates/acceptance.md`](../../product-owner/templates/acceptance.md) e é escrito pelo PO.

> **A decisão é tomada em formulário, uma pergunta por História (R22).** Cada pergunta cita o **ponteiro do dossiê** (`review.md#aceite--h-<nnn>`, a seção abaixo), traz o **resumo do dossiê** (critério a critério, em poucas linhas — para decidir sem abrir arquivo local, inclusive no celular) e a recomendação do PO em uma frase; em projeto com Identificador remoto, o prefixo `[<ID> · S<n> · ④ H-<nnn>]` e a pendência em §7 vêm antes (R34), e pergunta pulada ou sem resposta não é decisão — a coluna Decisão fica vazia (R34); as opções são **aceita · aceita com ressalva · rejeitada · pedir mais contexto**. O dossiê é escrito **antes** da pergunta — sem seção apontável, a pergunta não sai.

### Aceite — H-<nnn>
> Uma seção por História do sprint; **âncora `#aceite--h-<nnn>`** (o heading acima é literal, sem texto extra, para a âncora resolver). Escrita pelo **PO** no formato de `acceptance.md`; o SM só garante que a seção existe antes da pergunta e registra a decisão na tabela acima.

| Critério (do pacote aprovado) | Task que o cumpre | Evidência (`evidence/<T-ID>.md`) | Conferido |
|---|---|---|---|
| <critério> | T-<nnn> | <ponteiro> | ✅ · ❌ |

**Recomendação do PO:** <aceita · com ressalva · rejeitada — uma frase> · **Ressalvas propostas:** <quais, ou "nenhuma">

### Histórias herdadas do sprint <n-1>
> *Só quando a Review do sprint anterior foi **adiada*** (variante abaixo). Cada História herdada entra na tabela "Histórias do sprint" acima e ganha a sua seção `Aceite — H-<nnn>`, como as deste sprint; aqui fica só a origem.

| História | Sprint de origem | `review.md` adiada em | Motivo do adiamento | Evidência (portão do sprint de origem) |
|---|---|---|---|---|
| H-<nnn> | <n-1> | <data> | <o motivo da linha **Estado:**> | `sprints/<n-1>/validation.md` |

### História não terminada no sprint
| História | O que ficou pronto | O que falta | Destino |
|---|---|---|---|
| H-<nnn> | T-<nnn> ✅ | T-<nnn> em construção | volta ao Product Backlog inteira, com as Tasks feitas anotadas |

### Gaps, débitos e erros levantados na demonstração
> Registrados no Product Backlog **nesta sessão** (R12 · R21). Débito sem dono não sai daqui. O PO os prioriza para o sprint seguinte, e a priorização volta ao stakeholder embutida no **próximo pacote de abertura** — o que ele priorizou aparece no Sprint Backlog aprovado; o que **não** entrou aparece em `planning.md`, com o motivo (R25).

| # | O que apareceu | Origem | Vira | Dono |
|---|---|---|---|---|
| 1 | <o que o stakeholder ou o time notou> | H-<nnn> / demonstração | História nova / Task na próxima Planning | <papel> |

### Ressalvas dos aceites ⚠️
| História | Ressalva | Vira | Dono | Prazo |
|---|---|---|---|---|

### Bloqueios que chegaram até aqui *(degrau 2 — R25 · §5g)*
> Só o que o **degrau 1** (PO + Arquiteto) não fechou, mais a decisão estratégica, que vem direto. Cada linha na forma fixa de **R22**: opções descritas · recomendação do time · a via de pedir mais contexto.

| # | Bloqueio | Por que o degrau 1 não fechou (ou "estratégica — direto") | Recomendação do time | Resposta do stakeholder |
|---|---|---|---|---|

### Balanço
- **Objetivo do sprint atingido?** <sim | parcial — o quê ficou | não — por quê>
- **Histórias entregues:** <n> de <n> planejadas
- **Volta ao Product Backlog:** <IDs das Histórias rejeitadas ou não terminadas>
```

## Variante — Review adiada (v3.52.2 · R21)

Quando o stakeholder **adia** a Review para o sprint seguinte (decisão dele, em formulário — R22; [`../process/workflow-sprint.md` §5e](../process/workflow-sprint.md) "Review adiada"), o `review.md` sai **curto**, sem dossiê nem tabela de decisões:

```markdown
## Sprint Review — Sprint <n> — <data>
**Estado:** adiada para o sprint <n+1> — <motivo em uma frase: alvo indisponível, prova no alvo pendente, ausência do stakeholder>

**Decisão do stakeholder (formulário — R22):** adiar · <data> · <canal: celular | terminal>
**Histórias sem aceite, herdadas pela Review do sprint <n+1>:** H-<nnn>, H-<nnn>
**Portão do QA:** <✅ | ⚠️ com dívida aceita pelo PO — `validation.md`>
**Ocorrência de plugin:** <nenhuma | registrada — o formulário investigar × ignorar abre no `/sm sprint close` deste sprint>
```

A linha **`**Estado:** adiada para o sprint <n+1> — <motivo>`** vem **logo abaixo do título** e é a que o C2 (`project.ps1`, R21) lê para aceitar o sprint fechado sem dossiê. Nenhuma História é aceita nem rejeitada; o ✅ das Tasks não muda.

## Regras

- **Review adiada não é aceite nem recusa** (v3.52.2). As Histórias seguem sem aceite e entram na Review seguinte, em "Histórias herdadas do sprint <n-1>". O sprint fecha no `/sm sprint close` mesmo assim — com o formulário de ocorrência de plugin lá, porque a Review não aconteceu.
- **É o único portão de aceite** (R21 · portão ④). História aceita fora daqui é violação, e o SM a registra como achado de processo.
- **O alvo é sempre a História, nunca a Task.** Task já foi fechada tecnicamente pelo veredito do QA e pelo `/sm close`.
- **Sem os vereditos do QA das Tasks, não há demonstração** (R7). História cujas Tasks não fecharam não é aceita: é reportada como não terminada e volta ao backlog.
- **Rejeição devolve a História inteira**, com as Tasks aprovadas anotadas como já feitas — para que a Planning seguinte não replaneje do zero o que passou no QA.
- **Ressalva e débito saem daqui com dono e destino**, escritos no Product Backlog na mesma sessão. Ressalva verbal desaparece. **Não há gate novo para a priorização deles:** ela aparece no pacote de abertura seguinte — o que entrou, no Sprint Backlog; o que não entrou, em `planning.md`, com o motivo (R25).
- **Sem seção `Aceite — H-<nnn>` escrita, não há pergunta.** O formulário do ④ aponta para ela; pergunta sem dossiê apontável é achado de processo contra a condução (R22 · R21).
- **Quem conduz e quem decide são papéis diferentes, e os dois estão presentes.** O PO demonstra e escreve o dossiê de aceite; o **stakeholder preenche a Decisão, por História**. Review registrada sem o stakeholder é Review sem o portão ④ — o SM não a encerra.
- **A demonstração é contra os critérios do portão ③** aprovados no pacote de abertura, não contra o que o time construiu. Critério que ninguém consegue conferir é defeito de detalhamento — volta ao PO, e a História volta ao sprint seguinte por um pacote novo.
- **Roda antes da retrospectiva.** A retrospectiva precisa do resultado do aceite para discutir processo com fato à vista.
