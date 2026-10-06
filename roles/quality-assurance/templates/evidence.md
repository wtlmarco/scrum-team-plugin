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
*(espelha a do veredito — o índice dos jobs; "nenhuma" quando não houve chamada ao `operator`; os números o hook G16 mede)*

| Operator job | Task/História |
|---|---|
| `.team-project/operator/<sprint\|pre-sprint>/<T-ID>[-<slug>]/` | <T-ID / H-ID> |

### Achados

| # | Gravidade | O quê | Onde | Volta para |
|---|---|---|---|---|

### Não exercitado
- <o que e por quê>

### Documentos vivos (R12)
**Estado:** atualizados | pendentes
**Documentos:** <quais foram atualizados — ou, em "pendentes", o que falta e o dono de cada um>

### Escopo
**Fora do plano:** nada | <lista de arquivos alterados pela Task fora da lista do Plano>
**Desvio aceito:** <aaaa-mm-dd — quem decidiu — onde está a decisão> *(só quando "Fora do plano" lista arquivo e o desvio foi aceito; senão, omitir a linha)*
```

---

## Como manter

- **Um arquivo por Task**, nomeado exatamente `<T-ID>.md`. Nomeação previsível não é estilo: é o que faz o ponteiro da coluna Evidência do Sprint Backlog resolver sem ambiguidade.
- **Um bloco por execução** do `/qa <ID>` sobre esta Task, em ordem cronológica inversa (mais recente no topo). Reprovação seguida de nova tentativa soma bloco novo — **nunca editar bloco antigo**. **Toda rodada é um bloco `##` completo**, com a própria linha `**Veredito:**` — revisão que só acrescenta o delta, sem veredito, deixa o C1 sem o que ler. Na linha, **o primeiro marcador é o veredito da rodada** (o C1 lê só ele); o histórico pode vir depois, em texto (`✅ na 3ª rodada — antes ⚠️ e ❌`). É por isso que o ponteiro do `report` importa mais aqui do que em qualquer outro documento: cada tentativa reprovada acrescenta comandos pesados novos, e sem `operator` cada um inflaria o contexto de uma verificação inteira por Task.
- **O ponteiro é o `report` do job** (`report.md`, ou `report-<log>.md`) em `.team-project/operator/<sprint>/<job>/`; sobrevive à poda (R28). `report` ausente é ausência de evidência (rejeição no aceite, R7); acima de 200 linhas ou 20 KB é achado de processo. O log bruto (`*.log`) é disco local e pode ter sido podado: não é achado. Com gatilho de R28 disparado e o log podado, re-rodo o job pelo `operator` ou registro "não verificado — log podado" (R7) — nunca "ok" por inferência do trecho.
- **Task retomada num sprint seguinte** ganha arquivo novo em `sprints/<n_novo>/evidence/<T-ID>.md`; o de `sprints/<n_antigo>/evidence/` fica como está, registro fechado — mesmo padrão do plano do Arquiteto em `plan/` (`artifact-ownership.md` §1e).
- **As duas últimas seções de cada bloco são lidas por script (C1, `scripts/checks/close.ps1`)** — cabeçalhos e rótulos **exatamente** como no modelo (`### Documentos vivos (R12)` + `**Estado:**`; `### Escopo` + `**Fora do plano:**`), sem variar grafia. `**Estado:** atualizados` só quando a R12 está cumprida (todas as linhas da tabela "Documentos vivos" do veredito em "sim"/"n/a"); qualquer pendência é `pendentes`, com o que falta e o dono em `**Documentos:**`. `**Fora do plano:** nada` só depois de conferir o diff da Task contra a lista de arquivos do Plano (frente 2); arquivo fora da lista entra listado. Seção ausente ou `pendentes` bloqueia o close (exit 1); arquivo listado em "Fora do plano" marca falha **até haver `**Desvio aceito:**` com data**: quem aceita é o **Arquiteto** quando o desvio é técnico e cabe no plano (ele o acrescenta ao plano), ou o **stakeholder** pelo formulário de R22 quando muda escopo — a linha cita a data, quem decidiu e onde a decisão está (plano, quadro, §7). Desvio sem decisão continua falha, sem exceção. Valem os dois campos do bloco **mais recente** — por isso cada bloco novo os traz completos.
- **A linha de base do projeto não é por Task nem por sprint** — fica fora desta pasta, em `.team-project/quality-assurance/baseline.md`; formato e roteiro em [`../README.md`](../README.md), seção `/qa baseline`.
- **A tabela de cenários espelha a do veredito (`verdict.md`), nunca diverge dela.** Cada execução some no Histórico do próprio `SC-nnn` ([`scenario.md`](scenario.md)) e no índice ([`scenarios-index.md`](scenarios-index.md)) — os três (evidência, cenário, índice) sempre com o mesmo resultado para a mesma data.
