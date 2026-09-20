# Evidência da Task — Modelo

> **Vive em** `.team-project/sprints/<n>/evidence/<T-ID>.md` — **um arquivo por Task** do sprint corrente, nome exatamente `<T-ID>.md`: é o que a coluna Evidência do Sprint Backlog aponta, e ponteiro que não resolve é achado de processo (`artifact-ownership.md` §1e).
> **Dono:** QA · **Sem este arquivo, o SM não fecha a Task.**
> Regra: **saída real de comando, ou não aconteceu** (R7). O que não pôde ser executado é declarado como não exercitado, com o motivo.

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

**Comandos executados**
```
> <comando>
<saída real>
```

**Achados**
| # | Gravidade | O quê | Onde | Volta para |
|---|---|---|---|---|

**Não exercitado**
- <o que e por quê>
```

---

## Como manter

- **Um arquivo por Task**, nomeado exatamente `<T-ID>.md`. Nomeação previsível não é estilo: é o que faz o ponteiro da coluna Evidência do Sprint Backlog resolver sem ambiguidade.
- **Um bloco por execução** do `/qa <ID>` sobre esta Task, em ordem cronológica inversa (mais recente no topo). Reprovação seguida de nova tentativa soma bloco novo — **nunca editar bloco antigo**.
- **Task retomada num sprint seguinte** ganha arquivo novo em `sprints/<n_novo>/evidence/<T-ID>.md`; o de `sprints/<n_antigo>/evidence/` fica como está, registro fechado — mesmo padrão do plano do Arquiteto em `plan/` (`artifact-ownership.md` §1e).
- **A linha de base do projeto não é por Task nem por sprint** — fica fora desta pasta, em `.team-project/quality-assurance/baseline.md`; formato e roteiro em [`../README.md`](../README.md), seção `/qa baseline`.
