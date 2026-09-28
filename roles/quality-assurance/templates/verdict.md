# Template — Veredito de QA (`/qa <ID>`)

```markdown
## QA — <ID> <título> — <data>

**Veredito:** ✅ Aprovado | ⚠️ Aprovado com ressalva | ❌ Reprovado

| Frente | Resultado | Evidência |
|---|---|---|
| Requisito | ok / falha | <critério + como verifiquei> |
| Especificação técnica | ok / falha | **Duas tabelas** abaixo, sempre as duas: **"passo do plano × conforme"** (objeto 1, aderência de execução) e **"seção exigida pela Task × seção citada"** (objeto 2, 4 estados) |
| Segurança | ok / falha / n/a | <arquivo:linha ou teste> |
| Testes / métricas | ok / falha | <trecho decisivo do comando de teste **e** do gate de cobertura — ponteiro do log em "Comandos executados"> |
| Documentação | ok / falha | <arquivo atualizado> |
| Desempenho | dentro do orçamento / fora / não exercitado | <trecho decisivo do comando V19 — ponteiro do log em "Comandos executados" · ou o motivo do "não exercitado"> |

### Frente 2 — os dois objetos, sempre os dois (`workflow.md` §4a)
*(Task não fecha sem as duas tabelas abaixo preenchidas — DoD §4a-i)*

**Objeto 1 — passo do plano × conforme** *(aderência de execução; critério = o campo **Conferência** de cada passo do plano — [`implementation-plan.md`](../../architect/templates/implementation-plan.md) R13 — não julgamento próprio do QA)*

| # do passo do plano | Campo Conferência do plano | Conforme? | Evidência |
|---|---|---|---|
| <n> | <literal do campo **Conferência** do passo> | conforme / divergente / **inconferível sem decidir** | `arquivo:linha` quando divergente |

Divergência volta **direto** a `/dev resume`, sem Arquiteto. **Passo sem Conferência decidível** (o critério não basta para marcar conforme/divergente sem julgamento de desenho) é defeito do **plano**, não achado de execução: 🔺 **GAP** → `/arc question` (R13).

**Objeto 2 — seção exigida pela Task × seção citada no plano** *(completude/correção do standard citado; objeto = normativo `${CLAUDE_PLUGIN_ROOT}/standards/` + completude do plano ante a Task)*

| Área de engenharia | Seção que a Task exigia | Seção citada no plano | Estado | Volta para |
|---|---|---|---|---|
| <ex.: atomicidade de transação> | `<arquivo> §<n>` | `<arquivo> §<n>` ou "nenhuma" | citada e aplicada (ok) / citada e divergente (❌ R16) / exigida e ausente do plano / citada errada | — / dev (`/dev resume`) / `/arc question` (`/review`) / `/arc question` (`/review`) |

**Reverificação independente da interseção:** cada linha "citada e aplicada" teve a aplicação conferida neste veredito (`arquivo:linha` nos Achados quando divergente) — verificação própria, não a alegação do relatório do dev nem de qualquer auditoria anterior.

### Cenários de teste — resultado por cenário mapeado (R30)
*(Task não fecha sem esta tabela preenchida para todo cenário referenciado na Task do Sprint Backlog — DoD §4a-i. "Nenhum mapeado" só é válido quando a própria referência da Task já dizia isso, com o motivo.)*

| SC-nnn | Tipo | Resultado | Forma | Evidência |
|---|---|---|---|---|
| SC-<nnn> — `.team-project/quality-assurance/scenarios/SC-<nnn>-<slug>.md` | novo / regressivo | ✅ passou / ❌ falhou / ⚠️ não executado — <motivo> | manual / navegador / script | <trecho decisivo + ponteiro do log (execução pesada/lote via `operator`, R28), ou o que faltou> |

Cada linha desta tabela é também gravada no **Histórico de execuções** do próprio arquivo `SC-<nnn>` ([`templates/scenario.md`](../../quality-assurance/templates/scenario.md)) e reflete o "Último resultado" do índice ([`templates/scenarios-index.md`](../../quality-assurance/templates/scenarios-index.md)) — os três nunca divergem sobre a mesma execução.

**Cenário falhou (❌) — roteamento pelo bloqueio, não pela criticidade (R30):**

| GAP compromete a História em voo? | Caminho | Onde registro |
|---|---|---|
| **Sim, bloqueia** | Vira Task da mesma História, no sprint corrente (R25 · `workflow.md` §5e "Durante o sprint") | Entrada nos Achados abaixo, `Volta para: /team` (SM registra a entrada fora da Planning) |
| **Não bloqueia** | Ganha entrada no Product Backlog, escrita pelo **PO**, no mesmo ciclo (R12) | GAP em `pending.md` com **ID: <MÓDULO-NN>** → **roteado ao PO** nesta linha; o PO abre a linha do Product Backlog citando este ID |

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
- [ ] Suíte de cenários — Histórico de execuções de cada `SC-nnn` mapeado, e o índice (`scenarios/README.md`) com "Última execução"/"Último resultado" sincronizados
```

## Regras

- **Executar antes de opinar** (R7). Veredito sem trecho decisivo **e** ponteiro do log (quando a verificação foi delegada ao `operator`, R28) não é veredito — comando leve, sem `operator`, traz o comando e a saída direto. Alegação sem nenhum dos dois não conta, do mesmo jeito que a saída completa colada por inteiro não é o formato certo.
- **Log bruto referenciado precisa resolver.** Ponteiro para `.team-project/operator/<sprint>/<job>/` que não existe mais no caminho declarado é achado de processo — o mesmo defeito que um ponteiro de documentação quebrado, só que aqui quem audita depois é o PO, na Sprint Review, dias mais tarde (R28).
- **Os gatilhos de aprofundamento no log bruto são os de R28** — fora deles, o resumo do `operator` basta e abrir o log é opção minha, não obrigação.
- **Achado precisa de `arquivo:linha`**; sem isso vai para "Suspeitas".
- **Desvio de nomenclatura é falha**, não detalhe (R10).
- **Desvio de seção de standard citada no plano é reprovação, não ressalva** (R16). Defeito no próprio standard (contradição, lacuna, regra inverificável) é achado de **Tipo `processo`** só para `/review` — **não** vira GAP de projeto. Plano que **omitiu** a seção que a Task exigia ou **citou a errada** (tabela do objeto 2, estados 3 e 4) é **duplo**: 🔺 **GAP** para o Arquiteto via `/arc question` (desbloqueia a Task, `workflow.md` §4a) **e** achado de `processo` para `/review` (corrige o hábito) — os dois, não um no lugar do outro.
- **Frente 2 sem as duas tabelas não cobriu os dois objetos** (`workflow.md` §4a). Veredito com só a tabela do objeto 2 (como antes de v3.31) é achado de processo contra o próprio veredito. Divergência do objeto 1 volta **direto** a `/dev resume`, sem passar pelo Arquiteto — o antigo `/arc comply` saiu do ciclo e só roda como exceção explícita pedida pelo stakeholder. **Passo "inconferível sem decidir"** (Conferência do plano insuficiente, R13 de `implementation-plan.md`) não é "conforme" nem achado de execução: é 🔺 GAP do plano, para `/arc question`.
- **Desempenho registra sempre um dos três estados.** "Fora" (comando de V19 sai ≠ 0) é reprovação; "não exercitado" exige o motivo. Task que toca operação de V18 sem o trecho e o ponteiro do comando é achado bloqueante, não "ok" (`implementation-principles.md` §5.6 P6).
- **Cobertura ou desempenho sem trecho decisivo e ponteiro do log no relatório de entrega** não vai a "ok": cobertura ausente é falha, desempenho ausente em Task de V18 é achado bloqueante (espelha `${CLAUDE_PLUGIN_ROOT}/roles/developer/templates/delivery-report.md`).
- **Cenário mapeado sem linha na tabela de resultado não fecha a Task** (R30, DoD §4a-i) — regressivo aplicável incluído. Cenário ❌ segue o roteamento pelo bloqueio: bloqueia a História em voo → Task no sprint corrente (R25); não bloqueia → **ID de `pending.md` explícito nesta seção, endereçado ao PO** — sem esse ID, o GAP fica preso em `pending.md` e nunca chega ao Product Backlog (R30 · R12).
- **"Não exercitado" é obrigatório**, mesmo que seja "nada — todo o fluxo foi exercitado".
- Reprovar com precisão vale mais do que aprovar rápido: cada achado diz **para quem volta**.
- ⚠️ (ressalva) só quando a Task é utilizável e a pendência tem ID próprio no backlog.

Os comandos, limiares e limitações do ambiente estão em `.team-project/quality-assurance/context.md`.
