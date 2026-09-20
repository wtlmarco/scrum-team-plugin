# Template — Sprint Retrospective (`/sm sprint close`)

Roda **depois da Sprint Review**, com o resultado dela à vista, e encerra o sprint. Curta e acionável: uma retrospectiva que não gera **uma** ação concreta foi tempo perdido.

> **Persistido em** `.team-project/sprints/<n>/retrospective.md`. No mesmo `/sm sprint close`, o SM **fecha** `sprint-backlog.md` e `burndown.md` — sem cópia nem snapshot. Com `planning.md`, `stories/`, `plan/`, `evidence/`, `consumption.md` e `review.md`, a pasta forma o registro completo e imutável do sprint ([`../process/artifact-ownership.md` §1e](../process/artifact-ownership.md)).

```markdown
## Retrospectiva — Sprint <n> — <data>

**Objetivo do sprint:** <a frase declarada na Planning> — **atingido?** <sim | parcial | não>
**Histórias:** <n aceitas · n com ressalva · n rejeitadas · n não terminadas>
**Tasks:** <n fechadas de n planejadas> · **Estimado × entregue:** <n> / <n> (<Δ%>)
**Pacote de abertura:** aprovado em <data> · <sem ajustes | ajustes pedidos: quais> · **bloqueios que chegaram ao stakeholder:** <n | nenhum>

### Métricas do sprint
| Indicador | Valor | Alerta | Regra |
|---|---|---|---|
| Gaps por plano | <n> | > 2 | R8 |
| Reprovações no QA | <n>/<total> | > 30% | R2/R8 |
| Tasks reabertas | <n> | > 1 | R7 |
| Lead time × estimativa | <n>× | > 2× | R2 |
| Tasks fechadas sem evidência | <n> | qualquer | R7/R12 |
| Violações de escopo (inclui entradas fora da Planning) | <n> | recorrente | R4 |
| Soma estimada × entregue no sprint | <Δ%> | > 25% dois sprints seguidos | §5e |
| História > 3× a unidade sem dimensionamento formal nem justificativa | <n> | qualquer | R13 |
| Projeto planejado sem registro de onboarding | <n> | qualquer | R14 |
| Requisito do SDD sem `brainstorm` nem `/po analyze`; `03`/`04`/`05` antes do portão ①; História antes do portão ② | <n> | qualquer | R15 |
| Task sem História de origem, ou Task em construção antes da data do pacote de abertura aprovado | <n> | qualquer | R20 |
| Detalhamento de História com decisão técnica (arquivo, classe, endpoint, dados) | <n> | qualquer | R20 |
| História aceita fora da Sprint Review, ou aceite mirando uma Task | <n> | qualquer | R21 |
| Plano/veredito de engenharia sem citar a seção de `${CLAUDE_PLUGIN_ROOT}/standards/` aplicável | <n> | recorrente | R16 |
| Defeito em `${CLAUDE_PLUGIN_ROOT}/standards/` sem chegar ao `/review` seguinte | <n> | qualquer | R16 |
| **Carga fixa** por invocação (KB) — `agents/` + `commands/` — fase Check do PDCA (workflow §5c) | <atual> / <retro anterior> / <Δ> · causa se cresceu · ação: nenhuma \| corte candidato para `/review metrics` | crescimento sem regra ou cerimônia nova | §5c |
| **Conjunto sob demanda** (KB) — `roles/<papel>/` **sem os changelogs** | <atual> / <retro anterior> / <Δ> | idem | §5c |
| Entrada de changelog acima do teto | maior bloco `## vX.Y` de `process-changelog.md` | > 10 KB | R17 |
| Entrega sem bump: merge em `develop` sem `version` + entrada no `CHANGELOG.md`, ou `plugin.json` ≠ topo do `CHANGELOG.md`, ou entrada de `process-changelog.md` sem par — *só quando a retro roda sobre o repositório-fonte do plugin; num projeto consumidor, `n/a`* | <n> \| n/a | qualquer | R18 |
| Entrada de `process-changelog.md` sem bloco de evidência, ou com comando cuja reexecução dá saída diferente da registrada — *idem: só no repositório-fonte* | <n> \| n/a | qualquer | R19 |
| `/sm close` sem linha correspondente no Registro de transições do Sprint Backlog, ou `burndown.md` com estimativa restante caindo sem fechamento que explique | <n> | qualquer | R24 |
| Sprint sem pacote de abertura aprovado antes da primeira Task em construção; ou `planning.md` sem a lista do que não entrou, com o motivo; ou protótipo do sprint sem fluxo ponta a ponta; ou bloqueio sem degrau nomeado; ou arquivo de `stories/` alterado depois da aprovação | <n> | qualquer | R25 |

### Consumo real do sprint (tokens e duração)

> Lê [`consumption.md`](consumption.md) da **mesma pasta do sprint**, e só existe quando o projeto registra consumo — sem o arquivo, escreva `n/a` e siga. **Não é footprint** e **não se soma** às duas linhas de KB acima: aquelas medem a pegada estática do processo, esta mede o gasto real do trabalho dos papéis ([`../process/workflow.md` §5c](../process/workflow.md)).

| Papel | Σ tokens | Nº de invocações | Duração total | Leitura em uma linha |
|---|---|---|---|---|
| SM · PO · Arquiteto · UX · dev · QA | <n> | <n> | <mm:ss> | <o que explica o número — sprint de spike, retrabalho, harness completo> |
| **Total do sprint** | **<n>** | **<n>** | **<mm:ss>** | — |

- **Contra o sprint anterior:** <Δ% e a causa, ou "primeiro sprint com registro">
- **Divergência contra a carga fixa** (§5c fase Act): <papel com carga fixa pequena e consumo alto, ou o oposto — candidato a investigar, nunca a cortar às cegas | nenhuma>
- **O que este número não mede:** o custo da sessão principal, que não enxerga o próprio consumo. O total é um **piso**, não o gasto completo do projeto.

### O que funcionou (3)
1. <fato observável, não sensação>

### O que corrigir (3)
1. <problema> → <regra violada ou ausente>

### Ação única do próximo sprint
**<a mudança concreta>** — dono: <papel> — verificação: <como saberemos que pegou>

### Regras revisadas
- <nenhuma | R<n> ajustada porque ...>

### Sintomas para o `note.md` do plugin
> O que este sprint mostrou sobre **o processo do time**, não sobre o produto. Escreva como **sintoma**, não como solução — é o formato que a fila do `/review` exige. O SM consolida; **o stakeholder decide** se leva ao `RAIZ/note.md` do repositório-fonte do plugin.
>
> **Isto não dá ao projeto poder de editar o plugin.** É relatório. O `/review` continua sendo o único caminho de mudança do processo, e só no clone-fonte — nunca daqui.

| # | Sintoma observado neste sprint | Onde doeu (regra, cerimônia, modelo, comando) | Quantas vezes |
|---|---|---|---|
| 1 | <o que aconteceu, sem propor a correção> | <R<n> · §<x> · `templates/<y>.md` · `/<comando>`> | <n> |

- **Levado ao `RAIZ/note.md`?** <sim, em <data>, pelo stakeholder | não — fica registrado aqui para reincidência>

### Encerramento
- **Tasks não concluídas devolvidas ao Product Backlog, com a História:** <IDs, ou "nenhuma">
- **Ressalvas e débitos da Review registrados no Product Backlog:** <sim — com dono | nenhum>
- **Consumo do sprint lido antes do fechamento:** <sim — seção acima preenchida | n/a — o projeto não registra consumo>
- **`sprints/<n>/` fechado (R24 · R25):** `sprint-backlog.md` fechado, `burndown.md` fechado (seção "Fechamento" preenchida), `stories/`/`plan/`/`evidence/` com o que seus donos produziram — <sim | não, com o motivo>
```

## Regras

- **Roda depois da Sprint Review, nunca antes.** A retrospectiva olha o resultado do aceite; invertida, ela discute processo sem saber se o valor chegou.
- No máximo **uma** ação por retrospectiva. Três ações = nenhuma ação.
- Todo "o que corrigir" aponta para uma regra de [`../process/working-rules.md`](../process/working-rules.md) — violada ou faltante. Se não aponta para nenhuma, ou é ruído, ou é regra nova a escrever.
- Métrica sem fonte não entra. As fontes são: relatórios do dev, `sprints/<n>/evidence/`, `sprints/<n>/sprint-backlog.md` e o registro de aceites de `sprints/<n>/review.md` — todas na pasta do próprio sprint.
- **O sprint não encerra com pendência sem destino.** Task inacabada volta ao Product Backlog com a História (R5); ressalva da Review vira entrada com dono (R12 · R21).
- A linha de footprint (KB) é a fase **Check** do ciclo de eficiência ([`../process/workflow.md` §5c](../process/workflow.md)): mede `agents/` + `commands/` + `roles/<papel>/` do processo, compara com a retrospectiva anterior e alimenta o giro de `/review metrics`, que roda a cada 3 sprints. Crescimento sem regra ou cerimônia nova é candidato a corte, não a nota.
- **Consumo real ≠ footprint.** A seção de consumo soma o que a sessão que orquestra registrou por invocação de papel — mede **o trabalho dos papéis**, nunca o custo da própria sessão principal, que não se autoobserva. Não some as duas linhas de footprint com o total de consumo: são medidas diferentes, lado a lado, nunca um total único.
- **O consumo é lido antes do fechamento da pasta.** A seção acima lê `sprints/<n>/consumption.md` enquanto o sprint ainda está aberto; depois do `/sm sprint close` a pasta é registro imutável. Não há arquivamento a fazer — o registro já nasceu dentro do sprint a que pertence.
- **Sintoma de processo é sintoma, não proposta.** A seção do `note.md` descreve **o que doeu**, com quantas vezes; quem transforma sintoma em mudança é o `/review`, no repositório-fonte. Retrospectiva que já traz a regra reescrita pulou o único lugar onde conflito com regra vigente é analisado.
- **`sprints/<n>/` fecha por último, depois de tudo o resto estar decidido** (R24 · R25): fechar `sprint-backlog.md` e `burndown.md` antes de a Review decidir aceite/ressalva/rejeição, ou antes de Tasks inacabadas voltarem ao Product Backlog, congela um estado que ainda vai mudar. `review.md` é exceção: entra antes, no `/sm review`, porque é o registro do próprio evento da Review.

## Exemplo de leitura

> Gaps por plano em 4 (alerta > 2): o Plano de Implementação está raso — nas duas vezes o dev parou por assinatura de método que o plano assumia e não existia no código.
> **Ação:** o passo 2 do Plano de Implementação ("contexto de código a ler") passa a exigir que o Arquiteto cole a assinatura real do método, não só o caminho do arquivo. Verificação: gaps por plano ≤ 1 no próximo sprint.
