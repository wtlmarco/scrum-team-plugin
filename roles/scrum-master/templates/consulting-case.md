# Template — Ficha do caso de consultoria externa (`/sm consulting`)

> **Dono:** SM · Vive em `.team-project/consulting/C-<nnn>-<slug>/case.md` · Nasce no passo 1 de [`../README.md` §`/sm consulting`](../README.md) (R32).
> **Por que existe:** é o único lugar onde o caso inteiro se lê de uma vez — de onde veio, quem consultou, o que saiu em cada rodada e com que sanitização, quando houve consenso e o que o stakeholder decidiu. Sem a ficha, a resposta externa vira decisão sem dono.

```markdown
# Caso C-<nnn> — <tema>

| | |
|---|---|
| **Domínio** | database · security · design · architecture · infrastructure · business:<área> |
| **Tema** | <uma frase> |
| **Aberto em** | <data> · por pedido de <papel / stakeholder> |
| **Consultor** | titular: <do registro, `.team-project/README.md` §7a> · alternativo: <do registro> · em uso: <titular \| alternativo, desde a rodada nn> |
| **Escrevem a carta** | <papéis do domínio> |
| **Validam a resposta** | <papéis do domínio> |
| **Estado** | aberto · **suspenso — sprint em `run`** (desde <data>) · consenso · decidido · encerrado sem decisão |

## Rodadas
| Nº | Arquivo | Data | Sanitização QA | Sanitização PO *(só business)* | Resultado |
|---|---|---|---|---|---|
| 01 | `01-service-letter.md` | <data> | ✔ <data> | ✔ <data> \| n/a | enviada |
| 02 | `02-response.md` | <data> | — *(entra, não sai)* | — | consenso \| sem consenso: <o que faltou> |
| 03 | `03-reply.md` | <data> | ✔ <data> | ✔ <data> \| n/a | réplica 1 de 3 |

> Rodada nenhuma com data entre a aprovação do pacote de abertura e o `sprint close` do mesmo sprint (R32 · R25).

## Checklist de consenso *(preenchido pelos validadores — nomeie quem marcou)*
- [ ] a resposta segue o contrato (todas as seções presentes)
- [ ] as 3 opções são **distintas**, não variações de uma
- [ ] cada opção traz custo, risco, esforço e reversibilidade — no `business`, também impacto no processo e esforço de adoção
- [ ] toda opção segue os `standards/` vigentes **ou declara a exceção** — no `business`, declara a aderência à regulação da área
- [ ] nenhuma pergunta aberta dos dois lados
- [ ] recomendação do consultor justificada
- [ ] (`business`) nenhuma opção traz solução técnica embutida (R20)

**Atestado por:** <papel(is)> em <data> — consenso atesta que as opções estão maduras, **não** escolhe.

## Decisão do stakeholder *(formulário R22)*
| | |
|---|---|
| **Data** | <data> |
| **Opção escolhida** | A · B · C \| sem consenso: seguir com a divergência · mais uma rodada · trocar para o alternativo · encerrar |
| **Ajuste pedido** | <texto \| nenhum> |

## Destino
<ADR em `docs/…` \| requisito / História / seção do SDD funcional — ponteiro> · fechado em <data>
```

## Regras

- **Uma assinatura de sanitização por rodada que sai** — carta e cada réplica. Resposta que **entra** não se sanitiza. No `business`, sem a coassinatura do PO a rodada não sai.
- **Mais de 3 réplicas só com a decisão do stakeholder registrada** na seção Decisão ("mais uma rodada").
- **O SM registra, não atesta.** O checklist de consenso é dos validadores do domínio (R21 · R32).
- **Suspensão é estado, não abandono.** Sprint arrancou com o caso aberto: estado "suspenso", nenhuma rodada até o `sprint close`; retoma de onde parou (R5).
