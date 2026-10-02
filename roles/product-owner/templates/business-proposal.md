# Template — Proposta de negócio vinda de consultoria externa (`/sm consulting business:<área>`)

> **Dono:** PO · Vive em `.team-project/consulting/C-<nnn>-<slug>/business-proposal.md` · Só no domínio `business:<área>` · Nasce **depois** do checklist de consenso preenchido pelos validadores no `case.md` (R32).
> **Por que existe:** é a forma em que as 3 opções de **processo futuro** chegam ao stakeholder — comparáveis, com a recomendação **do time** separada da do consultor. Ao decidir, a opção escolhida entra no SDD funcional, no requisito ou na História como regra funcional. **Nunca vira ADR.**

```markdown
# Proposta de negócio — C-<nnn> · <tema>

**Área de negócio:** <área> · **Status:** Proposed · **Origem:** consulting externo (business:<área>)
**Data:** <data> · **Autor:** PO · **Validadores:** PO (+ UX quando a opção muda a jornada)

## 1. Processo atual (as-is, resumo)
## 2. Problema e valor
## 3. Regulação aplicável
<normas da área que restringem as opções>

## 4. Opções *(formato R22 — processo futuro descrito, suficiente para decidir sem abrir outro documento)*

### Opção A — <nome>
<regras, etapas, papéis, exceções, indicadores> · **Impacto no processo:** · **Custo:** · **Risco** (inclusive regulatório): · **Esforço de adoção pela área:** · **Reversibilidade:**

### Opção B — <nome>
(idem)

### Opção C — <nome>
(idem)

## 5. Recomendação do time
<qual opção e por quê — depois da validação>

## 6. Recomendação do consultor *(só se divergente da do time)*

## 7. Parecer dos validadores
| Validador | Parecer | Ressalva |
|---|---|---|

## 8. Destino
| Afeta | Como |
|---|---|
| <requisito / fluxo / História / seção do SDD funcional> | <altera / estende / conflita> |
```

## Regras

- **Sem consenso atestado no `case.md`, não nasce** (R32).
- **Sem solução técnica** (R20) — nem para elogiar, nem para descartar. Opção que só se sustenta com uma decisão técnica abre **caso técnico separado** (outro domínio) ou vira item do Arquiteto no refinamento.
- **A §8 segue o formato do §4 de [`functional-analysis.md`](functional-analysis.md)**: é o que diz onde a opção escolhida vai morar.
- **Ao decidir:** a opção escolhida entra no artefato de destino como regra funcional; as outras duas, numa nota **"alternativas consideradas"** do requisito — **sem citar `consulting/` nem `.team-project/`** (R31).
- **A decisão é do stakeholder**, em formulário (R22): Opção A · Opção B · Opção C · pedir mais contexto. Prioridade de backlog continua sendo minha — o consultor não a entrega.
