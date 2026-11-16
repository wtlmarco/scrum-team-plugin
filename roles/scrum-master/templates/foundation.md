# Modelo — Quadro do sprint 0 (`.team-project/sprints/0/foundation.md`)

> **Dono:** SM · **Escrito pelo** `foundation.ps1` (`init` cria; `approve`, `next`, `area`, `close` e `dispense` mudam marcadores, cabeçalho e Registro) — ninguém edita os marcadores à mão · Roteiro: [`../process/workflow-sprint0.md`](../process/workflow-sprint0.md) · Regra: R35

```markdown
# Sprint 0 — Fundação

| | |
|---|---|
| **Estado** | proposta · vigente · vigente — área <área> · concluído em <data> · dispensado em <data> |
| **Tipo** | retomada — documentar o sistema como ele é · novo — o SDD veio do /sm sdd |
| **Aberto em** | <aaaa-mm-dd — a baseline do QA vale só daqui em diante> |
| **Diretório do SDD** | `<docs/sdd/>` |
| **Áreas em documentação** | <as do formulário do escopo, ou a da reabertura> |
| **Áreas documentadas** | <as aceitas na review — o sprint prepare confere a História contra esta linha> |
| **Escopo aprovado** | <data — decisão — por quem> |
| **Aceite** | <data — decisão — por quem> |

## Itens

| ID | Item | Frente | Dono | Est. | Régua | Arquivos | Área |
|---|---|---|---|---|---|---|---|
| ⬜ S0-01 | Visão geral e objetivos (00) — revisar contra o código | funcional | PO | 1 | SDD-00 | `docs/sdd/00-overview-objectives.md` | transversal |
| ⬜ S0-08 | Comandos de verificação (build, testes, lint) e serviços do ambiente | ambiente | dev | 1 | AMB-verify | — | transversal |
| ⬜ S0-09 | Linha de base do QA (/qa baseline) com os comandos do ambiente | prova | QA | 0,5 | AMB-baseline | — | transversal |

## Registro

| Quando | Item | Mudança | Por quê |
|---|---|---|---|
| <aaaa-mm-dd hh:mm> | <S0-nn ou S0> | <⬜ → 🟨 · devolvido · escopo aprovado · aceite> | <uma linha> |
```

## Como ler

- **Frente** — `funcional` (PO) e `técnica` (Arquiteto): documento, fecha com a régua **e** o ✅ do QA em `evidence/conformance.md`. `ambiente`: plano do Arquiteto → dev → a sessão grava o `guards.json`; fecha com a régua. `prova` (QA): baseline e cenário ponta a ponta; fecha com a régua.
- **Régua** — as regras do `foundation.ps1 check` que fecham o item: `SDD-00`…`SDD-06` (forma do documento no modelo) e `AMB-verify`, `AMB-baseline`, `AMB-cenário` (ambiente).
- **Est.** — na unidade do projeto (`README.md` §2a); o `init` propõe 1 para documento a criar ou fora do padrão, 0,5 para documento que já passa na régua (só a revisão contra o código e a conferência do QA).
- **Marcadores** — ⬜ a fazer · 🟦 plano (só ambiente) · 🟨 construção · 🟪 conformidade do QA · ✅ pronto · 🔴 bloqueado (3 devoluções; degrau 1 é PO + Arquiteto).
- **Registro** — só se acrescenta; `devolvido` conta para o 🔴.
