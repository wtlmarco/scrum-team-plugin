# Template — Sprint Review (`/sm review`)

> **Dono do registro:** SM · **Dono do aceite:** PO (R21) · **Decide:** o stakeholder, sobre o que viu.
> Fecha o trabalho do sprint, **antes** da retrospectiva. É o único momento em que uma História é aceita.

O SM conduz e registra; o **PO demonstra cada História contra os critérios de aceite que o stakeholder aprovou no portão ③**; o QA fornece a evidência por Task. O SM **não aceita** — registra o aceite do PO.

```markdown
## Sprint Review — Sprint <n> — <data>

**Objetivo do sprint:** <a frase declarada na Planning>
**Participantes:** stakeholder · PO (demonstra) · SM (conduz e registra) · QA (evidência) · <demais>

### Histórias do sprint

| História | Tasks | Todas fechadas? | Decisão | Motivo em uma frase |
|---|---|---|---|---|
| H-<nnn> <título> | T-<nnn>, T-<nnn> | sim / não: <quais faltam> | ✅ aceita · ⚠️ com ressalva · ❌ rejeitada | <por quê> |

O aceite detalhado de cada História — critério a critério, com a Task e a evidência — segue [`../../product-owner/templates/acceptance.md`](../../product-owner/templates/acceptance.md) e é escrito pelo PO.

### História não terminada no sprint
| História | O que ficou pronto | O que falta | Destino |
|---|---|---|---|
| H-<nnn> | T-<nnn> ✅ | T-<nnn> em construção | volta ao Product Backlog inteira, com as Tasks feitas anotadas |

### Gaps e débitos levantados na demonstração
> Registrados no Product Backlog **nesta sessão** (R12). Débito sem dono não sai daqui.

| # | O que apareceu | Origem | Vira | Dono |
|---|---|---|---|---|
| 1 | <o que o stakeholder ou o time notou> | H-<nnn> / demonstração | História nova / Task na próxima Planning | <papel> |

### Ressalvas dos aceites ⚠️
| História | Ressalva | Vira | Dono | Prazo |
|---|---|---|---|---|

### Balanço
- **Objetivo do sprint atingido?** <sim | parcial — o quê ficou | não — por quê>
- **Histórias entregues:** <n> de <n> planejadas
- **Volta ao Product Backlog:** <IDs das Histórias rejeitadas ou não terminadas>
```

## Regras

- **É o único portão de aceite** (R21 · portão ④). História aceita fora daqui é violação, e o SM a registra como achado de processo.
- **O alvo é sempre a História, nunca a Task.** Task já foi fechada tecnicamente pelo veredito do QA e pelo `/sm close`.
- **Sem os vereditos do QA das Tasks, não há demonstração** (R7). História cujas Tasks não fecharam não é aceita: é reportada como não terminada e volta ao backlog.
- **Rejeição devolve a História inteira**, com as Tasks aprovadas anotadas como já feitas — para que a Planning seguinte não replaneje do zero o que passou no QA.
- **Ressalva e débito saem daqui com dono e destino**, escritos no Product Backlog na mesma sessão. Ressalva verbal desaparece.
- **A demonstração é contra os critérios do portão ③**, não contra o que o time construiu. Critério que ninguém consegue conferir é defeito de detalhamento — volta ao PO e a História é reaprovada antes de voltar ao sprint.
- **Roda antes da retrospectiva.** A retrospectiva precisa do resultado do aceite para discutir processo com fato à vista.
