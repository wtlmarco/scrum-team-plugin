# Template — Protótipo do Sprint (`/ux prototype sprint <n>`)

> **Dono:** UX · **Entregável** — critérios completos em [`deliverables/prototype/README.md`](../../../deliverables/prototype/README.md) §protótipo do sprint
> **Peça obrigatória do pacote de abertura**: o stakeholder navega antes de aprovar o sprint (③ em lote — R25); a navegação é dele e "aprovar" a declara (D2 · R34). Sem o protótipo pronto, o pacote não sobe.
> **Não é o protótipo funcional do ①** ([`functional-prototype.md`](functional-prototype.md)) — aquele cobre os fluxos principais do SDD; este cobre as Histórias de **um** sprint.

## Onde vive — uma pasta por sprint, nunca sobrescrita

```
.team-project/user-experience/prototype/
├── index.html          ← o protótipo FUNCIONAL do ① — raiz da pasta, não se mistura
├── README.md · verification-log.md
├── sprint-3/           ← registro FECHADO do que o stakeholder aprovou no sprint 3
└── sprint-4/           ← o sprint corrente
    ├── index.html          ← AUTOCONTIDO: o caminho costurado + o que está fora; CSS e JS inline (reúso do estilo do funcional = copiado para dentro, declarado na ficha)
    ├── README.md           ← esta ficha, preenchida
    └── verification-log.md ← checkpoint da verificação desta costura (append-only)
```

**Autocontido, pronto para publicar (R34 · D5).** O `index.html` do sprint é **o arquivo que a sessão que orquestra publica** como artifact privado, para o stakeholder navegar no celular; o UX não publica. Mesmo contrato do funcional ([`functional-prototype.md`](functional-prototype.md) §Autocontido): scripts externos só de cdnjs, jsdelivr, unpkg, tailwind ou jquery · fontes só do Google Fonts · o resto inline · ≤ 16 MB · só dados fictícios (R11) · identidade visual do próprio produto · layout mobile verificado. **Uma URL por protótipo, um rótulo por versão** (ex.: `③ S4 v2`): a recostura de uma devolução recebe rótulo novo, porque republicar substitui o conteúdo da mesma URL.

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
de valor real do sprint (R25 (b)) — sem ela, o pacote não sobe.>

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

## Publicável como artifact (R34 · D5)
**Pronto para publicar:** ✅ <data> · ❌ <o que falta>
**Conferido:** scripts/fontes só das origens permitidas · resto inline · tamanho <n> MB (≤ 16) · dados só fictícios · identidade visual do próprio produto · layout mobile exercitado (<largura>)
**Rótulo da versão a publicar:** `<③ S<n> v<m>>` — publica a sessão que orquestra, na conta remota do projeto.

## Registro de verificação (harness)
**Modo desta rodada:** <completo | leve> · **Por quê:** <primeiro protótipo de sprint |
telas reaproveitadas já verificadas | tela nova: <nomes> | recostura de devolução>
**Fluxo ponta a ponta executado:** ✅ <data/hora> — **sempre**, em toda rodada
**Telas/saltos executados nesta rodada:** <lista>
**O que NÃO foi reexecutado, e o que o cobre:** <telas> — verificação completa de <data>, protótipo v<n>
**Rodadas leves consecutivas nesta pasta:** <n de 3>
**Checkpoint:** `verification-log.md` — <n> linhas · última em <data/hora>
**Relatório do job (R28):** <caminho do `report` devolvido pelo `operator`>

## Execução delegada
| Operator job | Task/História | Modelo | Tokens | Duração |
|---|---|---|---|---|
| `.team-project/operator/<sprint\|pre-sprint>/<job>/` | <Task/História> | <`model:` de `agents/operator.md`> | <n, ou "não disponível — <motivo>"> | <t, ou "não disponível — <motivo>"> |

Uma linha por chamada, com o que ela devolveu ao terminar; nunca estimado (R7). Sem chamada: "nenhuma". Não grava em `consumption.md` — a sessão que disparou transcreve ([`../skills.md` §10](../skills.md)).

## Registro do portão ③ (append — devolução não se apaga)
| Data | Evento | Quem | Canal | Artifact (URL · rótulo) | O que foi pedido |
|---|---|---|---|---|---|
| <data> | submetido / devolvido / aprovado | <stakeholder> | celular \| terminal | <URL · `③ S<n> v<m>`, ou "—"> | <ajustes, ou "—"> |

**A decisão (aprovar · aprovar com ajuste · reprovar) tem registro único** na linha "Decisão do stakeholder" do Sprint Backlog ([`sprint-backlog.md`](../../scrum-master/templates/sprint-backlog.md)); esta tabela só **aponta** para ela e guarda o que foi pedido, o canal e a versão publicada que ele viu. **A navegação é do stakeholder e "aprovar" a declara** (D2 · R34): a linha de aprovação anota "declarada" e o canal. O formulário é do pacote inteiro (③ em lote).

**Ponteiro registrado pelo SM no Sprint Backlog:** `user-experience/prototype/sprint-<n>/index.html`
```

O `verification-log.md` usa a mesma tabela append-only de [`functional-prototype.md`](functional-prototype.md) §checkpoint — **inclusive as colunas de trecho e de ponteiro (`report`)** (R28).

## Regras

Critérios, ciclo de vida e verificação de valor (R25 (b)) vivem em [`deliverables/prototype/README.md`](../../../deliverables/prototype/README.md) §protótipo do sprint — fonte única, não repetidos aqui; a verificação, em [`../skills.md` §10](../skills.md). Específico desta ficha:

- **Costura, não especificação nova.** A ficha diz quais telas vieram prontas e quais nasceram na costura.
- **Trecho e ponteiro, nunca um sozinho (R28).** Salto que não resolveu volta como par origem → destino; relatório `inconclusivo` deixa a tela **não exercitada** (R7).
