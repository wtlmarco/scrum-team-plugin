# Evidência da Task — Modelo

> **Vive em** `.team-project/sprints/<n>/evidence/<T-ID>.md` — **um arquivo por Task** do sprint corrente, nome exatamente `<T-ID>.md`: é o que a coluna Evidência do Sprint Backlog aponta, e ponteiro que não resolve é achado de processo (`artifact-ownership.md` §1e).
> **Dono:** QA · **Sem este arquivo, o SM não fecha a Task.**
> Regra: **saída real de comando, ou não aconteceu** (R7). O que não pôde ser executado é declarado como não exercitado, com o motivo.
> Verificação pesada é delegada ao `operator` (R28): o bloco de comandos traz **trecho e ponteiro**, nunca um sozinho.

## Estrutura

```markdown
## <T-ID> — <título> — <data>

**Veredito:** ✅ | ⚠️ | ❌

| Frente | Resultado | Evidência |
|---|---|---|
| Requisito | ok/falha | |
| Especificação técnica | ok/falha | |
| Segurança | ok/falha/n/a | |
| Testes / métricas | ok/falha | |
| Documentação | ok/falha | |
| Desempenho | dentro do orçamento/fora/não exercitado | |

### Cenários de teste — resultado por cenário mapeado (R30)
*(todo `SC-nnn` referenciado nesta Task no Sprint Backlog, novo e regressivo aplicável; "nenhum mapeado" só quando a referência já dizia isso)*

| SC-nnn | Tipo | Resultado | Forma | Evidência |
|---|---|---|---|---|
| | novo/regressivo | ✅/❌/⚠️ não executado — <motivo> | manual/navegador/script | |

### Comandos executados
*(um bloco por comando; pesado — build, suíte, cobertura, lint do projeto inteiro, carga V19 — delegado ao `operator`, R28)*
```
> <comando>
<trecho decisivo, verbatim>
```
**Relatório do `operator`:** `.team-project/operator/<sprint>/<job>/report.md` (ou `report-<log>.md`) · log bruto, disco local, pode ter sido podado: `<arquivo>.log` — <n> linhas *(ou "n/a — comando leve, sem `operator`")*

### Execução delegada
*(espelha a do veredito; "nenhuma" quando não houve chamada ao `operator`; sem número: "não disponível — <motivo>", nunca estimado)*

| Operator job | Task/História | Modelo | Tokens | Duração |
|---|---|---|---|---|
| `.team-project/operator/<sprint\|pre-sprint>/<job>/` | | | | |

### Achados

| # | Gravidade | O quê | Onde | Volta para |
|---|---|---|---|---|

### Não exercitado
- <o que e por quê>
```

---

## Como manter

- **Um arquivo por Task**, nomeado exatamente `<T-ID>.md`. Nomeação previsível não é estilo: é o que faz o ponteiro da coluna Evidência do Sprint Backlog resolver sem ambiguidade.
- **Um bloco por execução** do `/qa <ID>` sobre esta Task, em ordem cronológica inversa (mais recente no topo). Reprovação seguida de nova tentativa soma bloco novo — **nunca editar bloco antigo**. É por isso que o ponteiro do log importa mais aqui do que em qualquer outro documento: cada tentativa reprovada acrescenta comandos pesados novos, e sem `operator` cada um inflaria o contexto de uma verificação inteira por Task.
- **O ponteiro é o `report` do job** (`report.md`, ou `report-<log>.md`) em `.team-project/operator/<sprint>/<job>/`; sobrevive à poda (R28). `report` ausente é ausência de evidência (rejeição no aceite, R7); acima de 200 linhas ou 20 KB é achado de processo. O log bruto (`*.log`) é disco local e pode ter sido podado: não é achado. Com gatilho de R28 disparado e o log podado, re-rodo o job pelo `operator` ou registro "não verificado — log podado" (R7) — nunca "ok" por inferência do trecho.
- **Task retomada num sprint seguinte** ganha arquivo novo em `sprints/<n_novo>/evidence/<T-ID>.md`; o de `sprints/<n_antigo>/evidence/` fica como está, registro fechado — mesmo padrão do plano do Arquiteto em `plan/` (`artifact-ownership.md` §1e).
- **A linha de base do projeto não é por Task nem por sprint** — fica fora desta pasta, em `.team-project/quality-assurance/baseline.md`; formato e roteiro em [`../README.md`](../README.md), seção `/qa baseline`.
- **A tabela de cenários espelha a do veredito (`verdict.md`), nunca diverge dela.** Cada execução some no Histórico do próprio `SC-nnn` ([`scenario.md`](scenario.md)) e no índice ([`scenarios-index.md`](scenarios-index.md)) — os três (evidência, cenário, índice) sempre com o mesmo resultado para a mesma data.
