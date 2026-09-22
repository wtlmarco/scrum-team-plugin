# Template — Veredito de QA (`/qa <ID>`)

```markdown
## QA — <ID> <título> — <data>

**Veredito:** ✅ Aprovado | ⚠️ Aprovado com ressalva | ❌ Reprovado

| Frente | Resultado | Evidência |
|---|---|---|
| Requisito | ok / falha | <critério + como verifiquei> |
| Especificação técnica | ok / falha | Plano seguido + tabela **"seção exigida pela Task × seção citada"** abaixo (4 estados) |
| Segurança | ok / falha / n/a | <arquivo:linha ou teste> |
| Testes / métricas | ok / falha | <trecho decisivo do comando de teste **e** do gate de cobertura — ponteiro do log em "Comandos executados"> |
| Documentação | ok / falha | <arquivo atualizado> |
| Desempenho | dentro do orçamento / fora / não exercitado | <trecho decisivo do comando V19 — ponteiro do log em "Comandos executados" · ou o motivo do "não exercitado"> |

### Frente 2 — seção exigida pela Task × seção citada no plano
*(uma linha por área de engenharia que a Task toca; objeto = normativo `${CLAUDE_PLUGIN_ROOT}/standards/` + completude do plano, **não** a reexecução do `/arc comply` — `workflow.md` §4a)*

| Área de engenharia | Seção que a Task exigia | Seção citada no plano | Estado | Volta para |
|---|---|---|---|---|
| <ex.: atomicidade de transação> | `<arquivo> §<n>` | `<arquivo> §<n>` ou "nenhuma" | citada e aplicada (ok) / citada e divergente (❌ R16) / exigida e ausente do plano / citada errada | — / dev / `/review` / `/review` |

**Reverificação independente da interseção:** cada linha "citada e aplicada" teve a aplicação conferida neste veredito (`arquivo:linha` nos Achados quando divergente) — não se assume o resultado do `/arc comply`, que pode nem ter rodado.

### Comandos executados
*(um bloco por comando; comando pesado — build, suíte, cobertura, lint do projeto inteiro, carga V19 — é delegado ao `operator`, R28. Comando leve, cuja saída já cabe sem inflar o contexto, roda direto e traz só o comando/saída, sem log próprio.)*
```
> <comando>
<trecho decisivo, verbatim>
```
**Log bruto:** `.team-project/operator/<sprint>/<job>/<arquivo>.log` — <n> linhas *(ou "n/a — comando leve, sem `operator`")*
*(repetir o par comando/trecho + log bruto para cada comando executado)*

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
- [ ] Evidência da Task (`.team-project/sprints/<n>/evidence/<T-ID>.md`)
```

## Regras

- **Executar antes de opinar** (R7). Veredito sem trecho decisivo **e** ponteiro do log (quando a verificação foi delegada ao `operator`, R28) não é veredito — comando leve, sem `operator`, traz o comando e a saída direto. Alegação sem nenhum dos dois não conta, do mesmo jeito que a saída completa colada por inteiro não é o formato certo.
- **Log bruto referenciado precisa resolver.** Ponteiro para `.team-project/operator/<sprint>/<job>/` que não existe mais no caminho declarado é achado de processo — o mesmo defeito que um ponteiro de documentação quebrado, só que aqui quem audita depois é o PO, na Sprint Review, dias mais tarde (R28).
- **Os gatilhos de aprofundamento no log bruto são os de R28** — fora deles, o resumo do `operator` basta e abrir o log é opção minha, não obrigação.
- **Achado precisa de `arquivo:linha`**; sem isso vai para "Suspeitas".
- **Desvio de nomenclatura é falha**, não detalhe (R10).
- **Desvio de seção de standard citada no plano é reprovação, não ressalva** (R16). Dois achados de **Tipo `processo`** vão para `/review` e **não** viram GAP de projeto: defeito no próprio standard (contradição, lacuna, regra inverificável) **e** plano que **omitiu** a seção que a Task exigia ou **citou a errada** (tabela da frente 2, estados 3 e 4).
- **Desempenho registra sempre um dos três estados.** "Fora" (comando de V19 sai ≠ 0) é reprovação; "não exercitado" exige o motivo. Task que toca operação de V18 sem o trecho e o ponteiro do comando é achado bloqueante, não "ok" (`implementation-principles.md` §5.6 P6).
- **Cobertura ou desempenho sem trecho decisivo e ponteiro do log no relatório de entrega** não vai a "ok": cobertura ausente é falha, desempenho ausente em Task de V18 é achado bloqueante (espelha `${CLAUDE_PLUGIN_ROOT}/roles/developer/templates/delivery-report.md`).
- **"Não exercitado" é obrigatório**, mesmo que seja "nada — todo o fluxo foi exercitado".
- Reprovar com precisão vale mais do que aprovar rápido: cada achado diz **para quem volta**.
- ⚠️ (ressalva) só quando a Task é utilizável e a pendência tem ID próprio no backlog.

Os comandos, limiares e limitações do ambiente estão em `.team-project/quality-assurance/context.md`.
