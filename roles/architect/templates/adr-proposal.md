# Template — Proposta de ADR vinda de consultoria externa (`/sm consulting`)

> **Dono:** Arquiteto · Vive em `.team-project/consulting/C-<nnn>-<slug>/adr-proposal.md` · Só nos domínios técnicos (`database`, `security`, `design`, `architecture`, `infrastructure`) · Nasce **depois** do checklist de consenso preenchido pelos validadores no `case.md` (R32).
> **Por que existe:** é a forma em que as 3 opções chegam ao stakeholder — comparáveis, com a recomendação **do time** separada da do consultor. Ao decidir, vira [`adr.md`](adr.md) Accepted em `docs/`.

```markdown
# ADR-<nnn> (proposta) — <título da decisão>

**Status:** Proposed · **Origem:** consulting externo (<domínio>) · caso C-<nnn>
**Data:** <data> · **Autor:** Arquiteto · **Validadores:** <papéis do domínio>

## 1. Contexto
<O problema real, com evidência do projeto. Sem dado do consultor apresentado como fato do projeto.>

## 2. Forças em jogo
| Força | Peso |
|---|---|

## 3. Opções *(formato R22 — cada uma descrita, suficiente para decidir sem abrir outro documento)*

### Opção A — <nome>
<o que implica> · **Custo:** · **Risco:** · **Esforço:** · **Reversibilidade:** · **Standards:** segue \| exceção declarada: <qual seção, por quê>

### Opção B — <nome>
(idem)

### Opção C — <nome>
(idem)

## 4. Recomendação do time
<qual opção e por quê — depois da validação>

## 5. Recomendação do consultor *(só se divergente da do time)*
<qual e o argumento dele, descrito, separado>

## 6. Parecer dos validadores
| Validador | Parecer | Ressalva |
|---|---|---|

## 7. Checklist de aceitação por opção
| Opção | Afirmação testável que valerá se escolhida |
|---|---|
```

## Regras

- **Sem consenso atestado no `case.md`, não nasce.** Proposta sem checklist de consenso preenchido pelos validadores é achado de processo (R32).
- **Recomendação do time ≠ recomendação do consultor.** A do time é a que R22 pede; a do consultor aparece descrita, separada, só se divergir.
- **Ao decidir:** vira `adr.md` **Accepted** — a opção escolhida na §3 do ADR, as outras duas na §4 com o motivo — **sem citar `consulting/` nem `.team-project/`** (R31). `Select-String '\.team-project'` no ADR resultante sem ocorrência.
- **A decisão é do stakeholder**, em formulário (R22): Opção A · Opção B · Opção C · pedir mais contexto.
