# Template — Veredito de QA (`/qa <ID>`)

```markdown
## QA — <ID> <título> — <data>

**Veredito:** ✅ Aprovado | ⚠️ Aprovado com ressalva | ❌ Reprovado

| Frente | Resultado | Evidência |
|---|---|---|
| Requisito | ok / falha | <critério + como verifiquei> |
| Especificação técnica | ok / falha | Plano seguido + tabela **"seção exigida pelo item × seção citada"** abaixo (4 estados) |
| Segurança | ok / falha / n/a | <arquivo:linha ou teste> |
| Testes / métricas | ok / falha | <saída real do comando de teste **e** do gate de cobertura> |
| Documentação | ok / falha | <arquivo atualizado> |
| Desempenho | dentro do orçamento / fora / não exercitado | <saída real do comando V19 · ou o motivo do "não exercitado"> |

### Frente 2 — seção exigida pelo item × seção citada no plano
*(uma linha por área de engenharia que o item toca; objeto = normativo `${CLAUDE_PLUGIN_ROOT}/standards/` + completude do plano, **não** a reexecução do `/arc comply` — `workflow.md` §4a)*

| Área de engenharia | Seção que o item exigia | Seção citada no plano | Estado | Volta para |
|---|---|---|---|---|
| <ex.: atomicidade de transação> | `<arquivo> §<n>` | `<arquivo> §<n>` ou "nenhuma" | citada e aplicada (ok) / citada e divergente (❌ R16) / exigida e ausente do plano / citada errada | — / dev / `/review` / `/review` |

**Reverificação independente da interseção:** cada linha "citada e aplicada" teve a aplicação conferida neste veredito (`arquivo:linha` nos Achados quando divergente) — não se assume o resultado do `/arc comply`, que pode nem ter rodado.

### Comandos executados
```
> <comando>
<saída real>
```

### Achados
| # | Gravidade | Tipo | O quê | Onde | Impacto | Volta para |
|---|---|---|---|---|---|---|
| 1 | 🔴/🟠/🟡/🟢 | código / processo | <defeito> | <arquivo:linha> (+ `<standard> §n` se `processo`) | <consequência> | dev / `/team` / arquiteto / po / `/review` |

### Suspeitas (sem evidência conclusiva)
- <o que parece errado e o que falta para confirmar>

### Escopo
**Fora do plano:** <arquivo tocado além do previsto — R4> (ou "nada")

### Não exercitado
- <o que ficou sem validação e por quê>

### Documentação atualizada
- [ ] Inventário de código
- [ ] Registro de GAPs (fechado / aberto)
- [ ] `.team-project/quality-assurance/evidence.md`
```

## Regras

- **Executar antes de opinar** (R7). Veredito sem saída de comando não é veredito.
- **Achado precisa de `arquivo:linha`**; sem isso vai para "Suspeitas".
- **Desvio de nomenclatura é falha**, não detalhe (R10).
- **Desvio de seção de standard citada no plano é reprovação, não ressalva** (R16). Dois achados de **Tipo `processo`** vão para `/review` e **não** viram GAP de projeto: defeito no próprio standard (contradição, lacuna, regra inverificável) **e** plano que **omitiu** a seção que o item exigia ou **citou a errada** (tabela da frente 2, estados 3 e 4).
- **Desempenho registra sempre um dos três estados.** "Fora" (comando de V19 sai ≠ 0) é reprovação; "não exercitado" exige o motivo. Item que toca operação de V18 sem a saída do comando é achado bloqueante, não "ok" (`implementation-principles.md` §5.6 P6).
- **Cobertura ou desempenho sem a saída real no relatório de entrega** não vai a "ok": cobertura ausente é falha, desempenho ausente em item de V18 é achado bloqueante (espelha `${CLAUDE_PLUGIN_ROOT}/roles/developer/templates/delivery-report.md`).
- **"Não exercitado" é obrigatório**, mesmo que seja "nada — todo o fluxo foi exercitado".
- Reprovar com precisão vale mais do que aprovar rápido: cada achado diz **para quem volta**.
- ⚠️ (ressalva) só quando o item é utilizável e a pendência tem ID próprio no backlog.

Os comandos, limiares e limitações do ambiente estão em `.team-project/quality-assurance/context.md`.
