# Template — Protótipo do Sprint (`/ux prototype sprint <n>`)

> **Dono:** UX · **Entregável** — critérios completos em [`deliverables/prototype/README.md`](../../../deliverables/prototype/README.md) §protótipo do sprint
> **Peça obrigatória do pacote de abertura**: o stakeholder navega antes de aprovar o sprint (③ em lote — R25). Sem ele, o sprint não arranca.
> **Não é o protótipo funcional do ①** ([`functional-prototype.md`](functional-prototype.md)) — aquele cobre os fluxos principais do SDD; este cobre as Histórias de **um** sprint.

## Onde vive — uma pasta por sprint, nunca sobrescrita

```
.team-project/user-experience/prototype/
├── index.html          ← o protótipo FUNCIONAL do ① — raiz da pasta, não se mistura
├── flows/ · assets/ · README.md · verification-log.md
├── sprint-3/           ← registro FECHADO do que o stakeholder aprovou no sprint 3
└── sprint-4/           ← o sprint corrente
    ├── index.html          ← ponto de entrada único: o caminho costurado + o que está fora
    ├── README.md           ← esta ficha, preenchida
    ├── verification-log.md ← checkpoint da verificação desta costura (append-only)
    └── assets/style.css    ← ou o reúso declarado do estilo do protótipo funcional
```

**Por que numerada, e por que não em `sprints/<n>/`.** O Sprint Backlog guarda só o **ponteiro** para cá — o protótipo **não** é copiado para dentro da pasta do sprint, porque duplicar HTML navegável criaria duas verdades ([`artifact-ownership.md` §1e](../../scrum-master/process/artifact-ownership.md)). E o ponteiro do sprint 3 tem de continuar resolvendo depois do sprint 4: se a pasta fosse uma só, sobrescrever o protótipo apagaria o registro do que o stakeholder aprovou lá atrás — apagaria o próprio ③. A numeração espelha `sprints/<n>/`, então o par ponteiro ↔ pasta se confere de olho.

**A raiz de `prototype/` continua sendo do protótipo funcional do ①.** Mesma pasta-mãe, artefatos diferentes: cada `sprint-<n>/` é autocontido, com ficha e log próprios, e **um não vale pelo outro**.

**Ciclo de vida:** vivo enquanto o pacote não é aprovado (devolução → recostura) · **fechado na aprovação** — é o que o stakeholder viu (R4 · R25) · **registro histórico** depois do sprint, lido quando alguém pergunta o que foi aprovado lá atrás.

## Ficha (`prototype/sprint-<n>/README.md`)

```markdown
# Protótipo do Sprint <n> — v<n.m> *(ficha de `prototype/sprint-<n>/README.md`)*

**Dono:** UX · **Atualizado em:** <data> · **Estado:** <em costura | submetido | aprovado no ③ | devolvido>
**Objetivo do sprint:** <a frase do PO, copiada do Sprint Backlog>

## Como abrir
Abrir `index.html` no navegador. Nada mais.

## O fluxo ponta a ponta deste sprint
<Uma frase: do gatilho ao resultado que o usuário leva embora. É a verificação
de valor real do sprint (R25b) — sem ela, o pacote não sobe.>

| Passo | Tela | História | Vem de |
|---|---|---|---|
| 1 | <tela> | H-<nnn> | especificação de <data> · protótipo funcional v<n> / nova nesta costura |

## Histórias que entraram × cobertura
| História | Telas | Caminho no protótipo? | Observação |
|---|---|---|---|
| H-<nnn> | <telas> | ✅ / ❌ (declarar por quê) | <ou "—"> |

## O que está FORA deste protótipo
<Escrito também na própria `index.html`.>
- <o que não está representado, e por quê>

## Registro de verificação (harness)
**Modo desta rodada:** <completo | leve> · **Por quê:** <primeiro protótipo de sprint |
telas reaproveitadas já verificadas | tela nova: <nomes> | recostura de devolução>
**Fluxo ponta a ponta executado:** ✅ <data/hora> — **sempre**, em toda rodada
**Telas/saltos executados nesta rodada:** <lista>
**O que NÃO foi reexecutado, e o que o cobre:** <telas> — verificação completa de <data>, protótipo v<n>
**Rodadas leves consecutivas nesta pasta:** <n de 3>
**Checkpoint:** `verification-log.md` — <n> linhas · última em <data/hora>

## Registro do portão ③ (append — devolução não se apaga)
| Data | Evento | Quem | O que foi pedido |
|---|---|---|---|
| <data> | submetido / devolvido / aprovado | <stakeholder> | <ajustes, ou "—"> |

**Ponteiro registrado pelo SM no Sprint Backlog:** `user-experience/prototype/sprint-<n>/index.html`
```

O `verification-log.md` usa a mesma tabela append-only de [`functional-prototype.md`](functional-prototype.md) §checkpoint.

## Regras

- **É peça do pacote, não decoração.** Pacote sem protótipo navegado não vai ao stakeholder, e sem pacote aprovado nenhuma Task entra em construção (R20 · R25).
- **O stakeholder navega — não lê.** Print, gravação e apresentação não abrem o ③, pelo mesmo motivo que não abrem o ① (R15).
- **Costura, não especificação nova.** As telas já foram especificadas antes da Planning (DoR da História). O que nasce aqui é o caminho entre elas — e a ficha diz quais telas vieram prontas e quais nasceram na costura.
- **Depois do corte, nunca antes.** Antes do corte de capacidade não se sabe quais Histórias entraram; costurar antes é retrabalho garantido ([`workflow.md` §5e](../../scrum-master/process/workflow.md) passos 7 → 10).
- **Um fluxo ponta a ponta, no mínimo.** Se não há nenhum, o sprint não entrega fatia usável: o achado volta ao PO **na própria Planning** e o corte é refeito, antes de o pacote subir (R25b). O UX apresenta a evidência; **quem corta por valor é o PO** (§6a).
- **Devolvido volta à Planning.** O PO reordena, o corte é refeito, o protótipo é recosturado, o pacote é resubmetido — nada vai à construção antes. Custo declarado: a História reprovada perde a quebra e a estimativa já feitas (R20).
- **Aprovado, fecha.** Correção de tela durante o sprint vai para `screens/`, que é a fonte viva — nunca para o protótipo já aprovado. Arquivo modificado depois da data de aprovação é violação de escopo (R4).
- **Mesma régua técnica do funcional:** um ponto de entrada, sem build, sem servidor, sem back-end, dados plausíveis, estados de exceção dos caminhos cobertos, "o que está fora" na própria página.
- **Nada de decisão técnica** (R20), e **nada daqui vira produção** sem Plano de Implementação.
- **Escopo da verificação declarado, não presumido (R23).** Leve é o caso comum aqui — critério em [`../skills.md` §10](../skills.md) —, mas o fluxo ponta a ponta roda de verdade em toda rodada, e o que não rodou é nomeado.

## Falhas comuns

| Falha | Consequência |
|---|---|
| Sobrescrever a pasta do sprint anterior | O ponteiro do Sprint Backlog antigo aponta para o protótipo errado; perde-se o registro do que foi aprovado |
| Copiar o protótipo para dentro de `sprints/<n>/` | Duas verdades para um artefato navegável (§1e) — e a cópia envelhece calada |
| Telas ligadas em índice, sem caminho entre elas | O stakeholder clica em telas soltas; ninguém atravessa o fluxo, e a verificação de valor não acontece |
| Reespecificar as telas na costura | Paga-se duas vezes o que a DoR da História já entregou — e a especificação viva passa a divergir |
| Costurar antes do corte de capacidade | Metade do trabalho sai do sprint junto com as Histórias cortadas |
| Nenhum fluxo ponta a ponta, e o pacote sobe assim mesmo | Aprova-se um sprint que soma Tasks corretas sem entregar fatia usável — o modo de falha que R25b existe para pegar |
| Devolução apagada da ficha ao resubmeter | Some o histórico do que o stakeholder recusou, e o mesmo desenho volta no sprint seguinte |
