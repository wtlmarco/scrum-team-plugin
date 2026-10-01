# Template — Sprint Retrospective (`/sm sprint close`)

Roda **depois da Sprint Review**, com o resultado dela à vista, e encerra o sprint. Curta e acionável: uma retrospectiva que não gera **uma** ação concreta foi tempo perdido.

> **Persistido em** `.team-project/sprints/<n>/retrospective.md`. No mesmo `/sm sprint close`, o SM **fecha** `sprint-backlog.md` e `burndown.md` — sem cópia nem snapshot. Com `planning.md`, `stories/`, `plan/`, `evidence/`, `consumption.md`, `review.md` e — se houve "investigar" — `plugin-report.md`, a pasta forma o registro completo e imutável do sprint ([`../process/artifact-ownership.md` §1e](../process/artifact-ownership.md)).

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

> Lê [`consumption.md`](consumption.md) da **mesma pasta do sprint**, e só existe quando o projeto registra consumo — sem o arquivo, escreva `n/a` e siga. **Não é footprint** e **não se soma** às duas linhas de KB acima: aquelas medem a pegada estática do processo, esta mede o gasto real do trabalho dos papéis ([`../process/workflow-processo.md` §5c](../process/workflow-processo.md)).

| Papel | Modelo | Σ tokens | Nº de invocações | Duração total | Leitura em uma linha |
|---|---|---|---|---|---|
| SM · PO · Arquiteto · UX · dev · QA | <modelo do registro> | <n> | <n> | <mm:ss> | <o que explica o número — sprint de spike, retrabalho, harness completo> |
| operator ← <arc\|qa\|dev\|ux> *(uma linha por chamador)* | <modelo do `operator`> | <n> | <n chamadas> | <mm:ss> | <o que o chamador delegou — build, suíte, réplica> |
| **Total do sprint** (papéis + `operator`) | — | **<n>** | **<n>** | **<mm:ss>** | — |

- **Delegação ao `operator` — economia a investigar** (R28; lida das linhas `operator` e da seção "Execução delegada" dos relatórios). Por Task/História que delegou: consumo do **papel chamador** × consumo do **`operator`** que ele chamou, cada um com o seu modelo — <ID · papel · Σ · modelo × operator · Σ · modelo> \| nenhuma delegação. **Candidato a investigar, nunca economia afirmada:** sem a linha do papel *sem* delegar para comparar, o registro não mede a economia absoluta.
- **Contagem (R28):** chamadas em `.team-project/operator/<sprint>/` (um `report.md` ou `report-<log>.md` por chamada) = <n> × linhas `operator` do registro do sprint = <n> **·** `operator/pre-sprint/` nascidas desde o fechamento anterior = <n \| 0> × linhas `operator` de `.team-project/consumption.md` na mesma janela = <n \| 0> (exponha à parte as linhas `pre-sprint;`/`entre-sprints;` da janela) · divergência: <nenhuma \| jobs sem linha — o papel chamador não retratou>.

- **Contra o sprint anterior:** <Δ% e a causa, ou "primeiro sprint com registro">
- **Divergência contra a carga fixa** (§5c fase Act): <papel com carga fixa pequena e consumo alto, ou o oposto — candidato a investigar, nunca a cortar às cegas | nenhuma>
- **Ineficiência de consumo** (lida em `consumption.md`; as colunas de fonte são **Task/História** e **Nota**). Cada verificação é contagem sobre o registro, não impressão — sem linha que a sustente, escreva "nenhuma":

| Verificação | Como se mede | Achado | Regra ligada |
|---|---|---|---|
| **Papel repetido na mesma Task/História** | linhas com o mesmo papel **e** o mesmo ID; alerta a partir de **3** | <ID · papel · n · tokens · causa: plano raso, GAP, reprovação, bloqueio, comando refeito à mão> \| nenhuma | R2 · R7 · R8 |
| **Task ou História cara** | Σ tokens por ID contra a média das Tasks do sprint; alerta > **2×** | <ID · Σ · × a média · estimativa × entregue> \| nenhuma | R2 |
| **Papel desproporcional** | fatia do papel no total contra a **carga fixa** dele (§5c) e contra o trabalho que o quadro mostra | <papel · % do total · leitura> \| nenhum | §5c Act |
| **Modelo × trabalho** | Σ tokens por **modelo** do registro; o modelo mais caro concentra trabalho mecânico (leitura, repetição, formatação) ou o mais barato concentra retrabalho | <modelo · Σ · achado> \| nenhum — **candidato a investigar, nunca a trocar às cegas** | R3 |
| **Consumo × falha** | Tasks que também aparecem em "Reprovações no QA", "Tasks reabertas", "Gaps por plano" ou como bloqueio | <ID · indicador · Σ tokens> \| nenhuma | R7 · R8 · R25 |

- **O que este número não mede:** o custo da sessão principal, que não enxerga o próprio consumo. O total (papéis + `operator`) é um **piso**, não o gasto completo do projeto. **Premissa:** o número devolvido pelo papel não inclui o do `operator` aninhado; medição em contrário volta ao `/review`.

### O que funcionou (3)
1. <fato observável, não sensação>

### O que corrigir (3)
1. <problema> → <regra violada ou ausente>

### Ação única do próximo sprint
**<a mudança concreta>** — dono: <papel> — verificação: <como saberemos que pegou>

### Regras revisadas
- <nenhuma | R<n> ajustada porque ...>

### Relatório ao dono do plugin
Condicional a **ocorrência de plugin** (falha R27 persistente ≥ 2 · consumo de um papel > 2× a média dos últimos sprints — [`workflow-sprint.md` §5e](../process/workflow-sprint.md) "Ocorrência de plugin", fonte única). Com "investigar", os sintomas do processo, os números de consumo por papel e por modelo e as ineficiências acima saem em um **arquivo próprio**, [`plugin-report.md`](plugin-report.md), **sem contexto do projeto** — é ele que o stakeholder encaminha ao dono do plugin. Aqui só o ponteiro:

- **Ocorrência de plugin no sprint?** <nenhuma | <n falhas R27 · papel com consumo > 2× a média> — escolha do stakeholder na Review, em <data>: investigar · ignorar e seguir>
- **`sprints/<n>/plugin-report.md` gerado?** <sim — <n> sintomas · <n> ineficiências | não — sem ocorrência ou "ignorar">
- **Encaminhado ao dono do plugin?** <sim, em <data>, pelo stakeholder | não — fica no arquivo para reincidência>

### Encerramento
- **Tasks não concluídas devolvidas ao Product Backlog, com a História:** <IDs, ou "nenhuma">
- **Ressalvas e débitos da Review registrados no Product Backlog:** <sim — com dono | nenhum>
- **Consumo do sprint lido antes do fechamento:** <sim — seção acima preenchida, com modelo e ineficiências | n/a — o projeto não registra consumo>
- **`plugin-report.md` escrito e relido contra vazamento de contexto do projeto:** <sim | n/a — não houve "investigar">
- **`sprints/<n>/` fechado (R24 · R25):** `sprint-backlog.md` fechado, `burndown.md` fechado (seção "Fechamento" preenchida), `stories/`/`plan/`/`evidence/` com o que seus donos produziram — <sim | não, com o motivo>
```

## Regras

- **Roda depois da Sprint Review, nunca antes.** A retrospectiva olha o resultado do aceite; invertida, ela discute processo sem saber se o valor chegou.
- No máximo **uma** ação por retrospectiva. Três ações = nenhuma ação.
- Todo "o que corrigir" aponta para uma regra de [`../process/working-rules.md`](../process/working-rules.md) — violada ou faltante. Se não aponta para nenhuma, ou é ruído, ou é regra nova a escrever.
- Métrica sem fonte não entra. As fontes são: relatórios do dev, `sprints/<n>/evidence/`, `sprints/<n>/sprint-backlog.md` e o registro de aceites de `sprints/<n>/review.md` — todas na pasta do próprio sprint.
- **O sprint não encerra com pendência sem destino.** Task inacabada volta ao Product Backlog com a História (R5); ressalva da Review vira entrada com dono (R12 · R21).
- A linha de footprint (KB) é a fase **Check** do ciclo de eficiência ([`../process/workflow-processo.md` §5c](../process/workflow-processo.md)): mede `agents/` + `commands/` + `roles/<papel>/` do processo, compara com a retrospectiva anterior e alimenta o giro de `/review metrics`, que roda a cada 3 sprints. Crescimento sem regra ou cerimônia nova é candidato a corte, não a nota.
- **Consumo real ≠ footprint.** A seção de consumo soma o que a sessão que orquestra registrou por invocação de papel (e as linhas `operator` que o papel chamador retratou) — mede **o trabalho dos papéis**, nunca o custo da própria sessão principal, que não se autoobserva. Não some as duas linhas de footprint com o total de consumo: são medidas diferentes, lado a lado, nunca um total único.
- **O consumo é lido antes do fechamento da pasta.** A seção acima lê `sprints/<n>/consumption.md` enquanto o sprint ainda está aberto; depois do `/sm sprint close` a pasta é registro imutável. Não há arquivamento a fazer — o registro já nasceu dentro do sprint a que pertence.
- **Sintoma de processo é sintoma, não proposta.** O `plugin-report.md` descreve **o que doeu**, com quantas vezes; quem transforma sintoma em mudança é o `/review`, no repositório-fonte. Retrospectiva que já traz a regra reescrita pulou o único lugar onde conflito com regra vigente é analisado.
- **A análise de consumo aponta onde olhar, não o que cortar.** Repetição, Task cara e modelo desproporcional são **candidatos a investigar** — a causa vem do registro (Nota, Task/História) e do quadro, e a decisão de mudar é do `/review`. Achado sem linha de `consumption.md` que o sustente não entra (R7). A divisão entrada/saída de tokens **não é observável** ([`consumption.md`](consumption.md)); não se calcula.
- **`sprints/<n>/` fecha por último, depois de tudo o resto estar decidido** (R24 · R25): fechar `sprint-backlog.md` e `burndown.md` antes de a Review decidir aceite/ressalva/rejeição, ou antes de Tasks inacabadas voltarem ao Product Backlog, congela um estado que ainda vai mudar. `review.md` é exceção: entra antes, no `/sm sprint review`, porque é o registro do próprio evento da Review.

## Exemplo de leitura

> Gaps por plano em 4 (alerta > 2): o Plano de Implementação está raso — nas duas vezes o dev parou por assinatura de método que o plano assumia e não existia no código.
> **Ação:** o passo 2 do Plano de Implementação ("contexto de código a ler") passa a exigir que o Arquiteto cole a assinatura real do método, não só o caminho do arquivo. Verificação: gaps por plano ≤ 1 no próximo sprint.
