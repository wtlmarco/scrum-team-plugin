# Fluxo de Trabalho — Eficiência e lançamento (§5c PDCA · §5d atualização e lançamento do plugin)

> **Dono:** SM · Parte do fluxo — o núcleo está em [`workflow.md`](workflow.md). **Lido só** em /review metrics, /review sem instrução, retrospectiva (medição) e no lançamento de versão. A numeração (§5c, §5d) é a de sempre; só o arquivo mudou (v3.34).

## 5c. Ciclo de eficiência dos documentos do processo (PDCA)

O custo dos documentos de `${CLAUDE_PLUGIN_ROOT}/` não pode depender de uma faxina eventual do stakeholder. Cada papel verifica periodicamente o peso dos **próprios** documentos e propõe corte. O ciclo usa gatilhos que **já existem** — nenhuma cerimônia nova.

| Fase | Onde já acontece | O que a eficiência acrescenta |
|---|---|---|
| **Plan** | `/review metrics` (a cada 3 retrospectivas, ou métrica estourada) | Reafirma o teto de footprint por papel e o alvo do período: ao menos **uma** remoção candidata nomeada |
| **Do** | operação normal + cada `/review` | Papéis editam seus documentos; toda entrada de changelog respeita R17 |
| **Check** | `/review` sem instrução (reavaliação do conjunto, linha "Excesso") + retrospectiva | Passa a ser quantitativo: o papel mede seu footprint e compara com o valor anterior registrado; a retrospectiva registra total e Δ |
| **Act** | `/review metrics` + `/review <instrução>` | O SM consolida os footprints numa tabela por papel, escolhe **uma** mudança, roteia o corte ao dono; entrada no changelog com o indicador (KB antes/depois) |

**Métrica por papel — dois números, nunca somados num só:**

| Número | O que mede | Como | Por que separado |
|---|---|---|---|
| **Carga fixa** | o que entra no prompt em **toda** invocação daquele papel | `agents/<papel>.md` + `commands/<papel>.md` | é o único custo que se paga sempre; **é aqui que corte vale mais** |
| **Conjunto sob demanda** | o que o papel **pode** ler, conforme a tarefa | `roles/<papel>/` — README, skills, templates; para o SM, também `process/`, **exceto `process-changelog.md` e `process-changelog-archive.md`** | é pago por leitura, não por invocação (R3) |

**Por que o changelog fica fora da conta.** O arquivo de changelog é **frio por construção** — só é lido em `/review history` — e **cresce de forma monotônica por decisão do próprio processo**: R17 manda arquivar, não apagar. Contá-lo faz o SM aparecer com ~320 KB contra ~30 KB dos outros papéis, dos quais metade é história arquivada; o giro **Act** então aponta sempre para o SM e nunca para o desperdício real, que está na carga fixa. **Medida errada não corrige nada — dirige o corte para o lugar errado.**

**Onde o corte rende mais, em ordem:** (1) a **carga fixa** dos 12 arquivos de `agents/` + `commands/`, porque é multiplicada por toda invocação; (2) o **bloco fixo §8 do `.team-project/README.md`**, lido por todo papel em toda invocação; (3) o conjunto sob demanda, que já é protegido por R3.

**Os dois primeiros são proposta, nunca aplicação direta** — `agents/` e `commands/` são do stakeholder (§1), e `.team-project/` é do projeto. O Act mede, encontra e propõe com o texto pronto; ele autoriza item a item no fecho. A exceção de curadoria do SM não cobre remoção aí. Só o item (3) o `/review` aplica sozinho (v3.22).

**Onde cada arquivo é carregado — e por que isso muda a conta.** `commands/<x>.md` entra no **contexto principal** quando o stakeholder digita `/x`; `agents/<papel>.md` entra no contexto do **subagente** que aquele comando dispara. Os dois nunca se somam no mesmo contexto para o mesmo papel: um comando de papel só custa `commands/<x>.md` + `agents/<papel>.md`, mas um modo que orquestra vários papéis (`/sm onboarding`, `/sm agreement`, `/sm brainstorm`, `/sm sprint prepare`, `/sm sprint plan`, `/sm sprint run`, `/sm sprint review` — a sessão dispara, o Agent `scrum-master` não tem a ferramenta `Agent`) custa **`commands/sm.md` uma vez, mais um `agents/<papel>.md` por subagente disparado** — nunca os seis arquivos de comando.

**Custo por comando, em carga fixa** (antes de qualquer leitura de `.team-project/`):

| Comando | Carga fixa | O que dispara |
|---|---|---|
| `/sm brainstorm <ideia>` | `commands/sm.md` (10,5 KB hoje) + um `agents/<papel>.md` por papel disparado (PO 9,7 · UX 8,3 · depois Arquiteto 9,2). **A remedir depois de aplicar `commands/`** (fase A2 da v3.34) | SM + PO + UX, depois + Arquiteto |
| `/sm sprint run` (`<T-ID>` ou a fila) | `commands/sm.md` (10,5 KB hoje) + [`sprint-run.md`](sprint-run.md) (~7 KB, sob demanda) + um `agents/<papel>.md` por papel disparado (Arquiteto 9,2 · dev 6,4 · QA 8,8 · SM 9,2 no `close`/`board`). **A remedir depois de aplicar `commands/`** | Arquiteto → dev → QA, em série (UX só para reconferência de spec), e `/sm close` + `/sm board` |
| `/sm agreement <questão>` | 10,5 KB (`commands/sm.md`) + um `agents/<papel>.md` por papel chamado (2–3 típicos, ~9 KB cada) | os envolvidos, orquestrados pela sessão |
| `/review <instrução>` | 7,5 KB (`commands/review.md`) + 9,2 KB (`agents/scrum-master.md`, triagem) + ~10,5 KB do contrato por papel roteado | SM (triagem) + o papel dono |
| `/sm` · `/po` · `/ux` · `/arc` · `/qa` · `/dev` · `/team` | **19,7 · 19,4 · 15,0 · 14,1 · 16,8 · 10,1 · 12,4** KB (`/team`: só `commands/team.md`, não dispara agente) | um papel |

> Os números por papel somam `commands/<x>.md` + `agents/<papel>.md`. **Remedidos em v3.34 (29/09/2026), estado anterior à fase A2** (a tabela vinha da v3.16: SM 15,4 → 19,7 KB, PO 16,7 → 19,4, UX 11,2 → 15,0, Arquiteto 10,4 → 14,1, QA 11,1 → 16,8, dev 7,1 → 10,1 — **a carga fixa do time cresceu ~+30% a +45% sem ninguém notar**). Comando de medição, para a próxima remedição ser mecânica:
> ```powershell
> Get-ChildItem agents,commands -File | Select-Object Name,Length
> ```
> — soma manualmente `agents/<papel>.md` + `commands/<papel>.md` por papel; `/sm brainstorm`, `/sm sprint prepare` e `/sm sprint run` somam `commands/sm.md` + um `agents/<papel>.md` por papel disparado; `/review` soma `commands/review.md` + `agents/scrum-master.md` (triagem), mais `review-contract.md` (~10 KB, também remedido, sem variação relevante) por papel roteado. Remedir é parte da fase **Check**; tabela de custo que não se remede vira folclore — a v3.4 avisou isso e a própria tabela virou o exemplo (de novo na v3.16 → v3.34).

**Chame só quem a questão toca — não existe broadcast dos seis.** O canal do stakeholder é o PO (§6a), e questão que atravessa papéis vai por `/sm agreement`, cujo passo 1 identifica **quais papéis a questão toca** — dois ou três, nunca os seis por precaução. É onde a lição de R3 vive hoje, e o ganho é nos dois eixos: menos um `agents/<papel>.md` por papel não chamado e — o que pesa mais — menos uma rodada de leitura de contexto de projeto por subagente não disparado.

**Três coisas que a carga fixa não mostra, e que costumam dominar o custo real:**
1. **O modelo importa mais que os KB.** `/arc` roda em **Opus**; `/sm`, `/po`, `/qa` e `/ux` em **Sonnet**; `/dev` em **Haiku**. `/arc` carrega menos que `/sm` e custa mais. Ranquear a tabela por KB inverte a ordem real — pondere por preço do modelo antes de escolher onde cortar.
2. **A leitura em tempo de execução costuma superar a carga fixa.** Todo agente lê `.team-project/README.md` e o seu `context.md`; o QA lê ainda o plano, o relatório do dev, as seções de `standards/` citadas e o código. Num broadcast isso é multiplicado pelo número de subagentes.
3. **As respostas voltam.** Cada saída de subagente retorna ao contexto principal para consolidação — num `/sm brainstorm` ou `/sm sprint run`, uma por papel disparado.

**A tabela sustenta ordem de grandeza, não delta exato.** A coluna por papel soma `commands/` + `agents/`, e o que o `/sm agreement` acrescenta é só `agents/` por papel chamado. Ordem de grandeza basta para decidir; estimar o resto repete o erro que a v3.2 corrigiu.

**Gatilhos:**
- *Medição* — em todo `/review` sem instrução (o papel já faz a reavaliação do conjunto ali; passa a anexar os dois números) e na retrospectiva de cada sprint (o SM mede o total do processo).
- *Giro completo* — casado com `/review metrics`: a cada 3 retrospectivas — ou seja, a cada 3 sprints —, ou antecipado por limiar.
- *Limiar que dispara Act fora de cadência* — footprint de um papel cresce > 20% entre dois giros sem regra ou cerimônia nova que o justifique; **ou** qualquer entrada de changelog passa de 10 KB (R17); **ou** o footprint total de `${CLAUDE_PLUGIN_ROOT}/` cresce dois giros seguidos sem nenhuma remoção registrada.

**Onde fica registrado, para ser comparável no tempo:** a tabela de footprint por papel vai na saída de `/review metrics`; quando o giro gera entrada no changelog — o caso normal, um corte por giro —, os números ficam ali, no campo "Como saberemos que funcionou" do modelo [`process-change.md`](../templates/process-change.md). Entre giros, a retrospectiva carrega a linha "carga fixa do processo (KB): atual / retro anterior / Δ" como série contínua.

**Pegada estática × consumo real — os dois convivem, nunca se somam (v3.17).** Tudo acima mede a **pegada estática**: bytes de `agents/`+`commands/`+`roles/`, fixa por versão do plugin e igual em qualquer projeto que instale o time — é proxy de custo do **processo**, não gasto. Quando o projeto mantém [`.team-project/sprints/<n>/consumption.md`](../templates/consumption.md) (SM, modelo em `templates/consumption.md`), existe também o **consumo real**: tokens e duração por invocação, que a sessão que orquestra recebe quando cada subagente termina e registra numa linha — variável por projeto e por sprint, ao contrário da pegada estática. A fase **Check** passa a citar os dois lado a lado quando o registro existe (a retrospectiva soma o real do sprint numa **seção própria**, com total e quebra por papel — ver [`templates/retrospective.md`](../templates/retrospective.md)); a fase **Act** usa a divergência entre eles como achado: papel com carga fixa pequena e consumo real alto (ou o oposto) é candidato a investigar, não a cortar às cegas. **O consumo real mede o trabalho dos papéis — e o do `operator` que eles chamaram, retratado pelo papel chamador (R28) — não o custo da sessão principal, que não enxerga o próprio consumo**; não é o total gasto no projeto, é um piso. **O acumulado do projeto é derivado, não mantido:** somar os `sprints/<n>/consumption.md` **e o `.team-project/consumption.md` (fora de sprint)** responde "quanto o time custou até aqui" sem uma tabela viva que precise ser conciliada a cada fechamento.

**O que a fase Check candidata à remoção:** modelo que ninguém referencia, seção que repete outra, regra sem citação em 3 sprints, entrada de changelog acima do teto. Processo que só cresce deixa de ser seguido — revisar é também remover.

## 5d. Atualização e lançamento do plugin

O **processo do time** (os documentos de `${CLAUDE_PLUGIN_ROOT}/`) evolui por `/review`, no repositório-fonte. Chegar às instalações onde o time está instalado é outro passo: uma **entrega versionada**. Os dois registros não se confundem —

| Registro | Arquivo | Versão | Alimentado por | Dono |
|---|---|---|---|---|
| Evolução das regras de trabalho | `roles/scrum-master/process/process-changelog.md` | `vX.Y` | `/review` (SM cura) | SM |
| Entrega do plugin às instalações | `CHANGELOG.md` (raiz) | `vMAJOR.MINOR.PATCH` | fechamento de entrega | stakeholder |

### Ciclo de uma entrega

**Antes do passo 1: checkpoint de sessão (R29).** Se as correções/melhorias que entram nesta entrega vieram de uma fase de triagem+implementação que acabou de fechar verde, a sessão que orquestra fecha ou `/clear` antes de iniciar o ciclo abaixo — build nativo, release e resolução de conflito de merge não herdam o histórico de diagnóstico da fase anterior, que já não tem utilidade para eles.

1. **Branch** `fix/vX.Y.Z` ou `feat/vX.Y.Z` a partir de `develop` — ou, se a entrega depende de uma entrega anterior ainda não mesclada, **empilhada** a partir da branch dessa entrega (dois precedentes: `v3.14.0` sobre `fix/v3.10.0`, `v3.16.0` sobre `fix/v3.15.0`); a entrada de `CHANGELOG.md` (passo 6) declara a base nos dois casos.
2. As correções e melhorias da entrega — inclusive as aplicadas por `/review` — vão nessa branch, que acumula até o stakeholder sinalizar o fechamento da versão.
3. **PR para `develop`**, para aprovação do stakeholder. `develop` é a linha de integração contínua; `main` recebe `develop` quando o stakeholder decide consolidar a linha estável — esse merge não é parte do ciclo por-entrega.
4. **Bump** de `version` em `.claude-plugin/plugin.json` para `vX.Y.Z`.
5. **Banner** "Versão atual" no topo do `README.md` (raiz) atualizado para `vX.Y.Z` — mesma checagem que os passos 4 e 6 já pedem para `plugin.json` e `CHANGELOG.md`; é o passo que faltou no fechamento da `v3.4.0`, quando só `plugin.json` e `CHANGELOG.md` foram tocados e o README ficou anunciando `v3.3.0`.
6. **Entrada** no topo de `CHANGELOG.md`: o que foi entregue, a branch (com a base, se empilhada) e como verificar.
7. No merge, os clientes são avisados e atualizam com **`/team update`** (ou os comandos nativos `claude plugin marketplace update` + `claude plugin update`).

### Regra de numeração
- `MAJOR.MINOR` acompanham a versão do changelog do processo **quando a entrega inclui mudança de processo**: uma entrega que carrega uma entrada nova de `process-changelog.md` (`vX.Y`) é lançada como `vX.Y.0`. A colisão numérica entre os dois changelogs é intencional e sinaliza o par.
- `PATCH` (`vX.Y.1`, `vX.Y.2`…) é correção sobre a mesma linha, sem mudança de processo.
- Entrega de escopo fechado (nova capacidade de comando, faxina, correção) incrementa `MINOR` ou `PATCH` sem tocar o changelog do processo — e a entrada em `CHANGELOG.md` diz isso explicitamente.

### O que o SM reconcilia (curadoria do `/review`)
- Toda entrada nova de `process-changelog.md` tem entrada correspondente em `CHANGELOG.md` na mesma linha `vX.Y`, ou a divergência é registrada.
- `version` de `.claude-plugin/plugin.json` == a versão da entrada do topo de `CHANGELOG.md`.
- O banner "Versão atual" no topo do `README.md` (raiz) == `version` de `.claude-plugin/plugin.json` == a versão da entrada do topo de `CHANGELOG.md`.
- Nenhuma entrada de `CHANGELOG.md` afirma "sem mudança de processo" quando a entrega, de fato, carrega uma.

### `/team update` — lado da instalação
Roda **na cópia instalada**, nunca no repositório-fonte (guarda: recusa se `${CLAUDE_PLUGIN_ROOT}/.git/` existir). Compara a `version` instalada com a do `main` da origem canônica, mostra o delta do `CHANGELOG.md` e, após confirmação, aplica. **Depois disso, reconcilia o `.team-project/`** com os modelos da versão nova, conforme o manifesto de [`deliverables/team-project/README.md`](../../../deliverables/team-project/README.md) — porque atualizar o plugin atualiza `${CLAUDE_PLUGIN_ROOT}` e nada do que o `init` instanciou, que derivaria em silêncio a cada versão. Reiniciar a sessão continua manual. Os nove passos estão em [`team-update.md`](../../../team-update.md), lido só nesse modo; `commands/team.md` só aponta para lá.

**O `update` nunca apaga conteúdo do projeto sem aprovação.** Cópia literal ele substitui avisando; estrutura com conteúdo local ele **propõe** o delta, arquivo por arquivo; conflito entre o que o time editou e o que o modelo mudou vai ao stakeholder ou vira pendência no quadro.

