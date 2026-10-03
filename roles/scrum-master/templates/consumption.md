# Template — Registro de Consumo do Sprint

> **Dono:** SM · Vive em `.team-project/sprints/<n>/consumption.md`, **em** `.team-project/consumption.md` para o que acontece sem sprint aberto (mesmo modelo — ver "Fora de sprint") **e em** `.team-project/fixes/B-<nnn>/consumption.md` para o bloco da trilha `fix` (variante "bloco" — ver abaixo) · Alimentado pela **sessão que orquestra**, não pelo papel

Registra o que a sessão que dispara cada subagente de papel recebe quando ele termina: tokens e duração — **e**, por retratação do papel chamador, o consumo do `operator` que ele chamou. Existe porque "quanto o time custou neste sprint" não tinha resposta sem somar na mão.

**Retenção — uma forma só (R25 · [`../process/artifact-ownership.md` §1c](../process/artifact-ownership.md)).** O registro **nasce dentro do sprint a que pertence** e **fecha com a pasta**, no `/sm sprint close`. Não há vivo+archive, não há relocação de linhas, não há tabela de totais a conciliar: o acumulado do projeto é **derivado sob demanda**, somando `sprints/*/consumption.md` **e** `.team-project/consumption.md` — ver "Fora de sprint".

**Fora de sprint — `.team-project/consumption.md`.** O que acontece sem sprint aberto (onboarding, brainstorm, `prepare`, `sdd`, portão ①, jobs `operator/pre-sprint/`, invocações entre sprints) não tem pasta a que pertencer. Vai para **um arquivo só na raiz de `.team-project/`**, **no mesmo modelo abaixo**, na variante "fora de sprint" (bloco logo a seguir: sem "Totais do sprint" — o total é derivado), com a Nota iniciando em `pre-sprint;` (antes do sprint 1) ou `entre-sprints;` (com o sprint anterior fechado). **Substitui** a subseção "Consumo pré-sprint (prepare · sdd)" de `scrum-master/context.md` e a transcrição no passo 9 da Planning: a linha é gravada **na hora, num registro só**, e nunca repetida no do sprint (contaria em dobro). **Retenção: sem rotação** — as linhas nunca se movem nem se arquivam; não há sprint a que ancorar, e o volume é pequeno (só o que roda fora de sprint). A retrospectiva expõe à parte as linhas dele nascidas desde o fechamento anterior.

**Variante "fora de sprint"** — o que `/team init` e o passo 7b do `/team update` criam em `.team-project/consumption.md`:

```markdown
# Consumo — fora de sprint

> **DOCUMENTO VIVO, sem rotação** · **Dono:** SM
> Uma linha por invocação de papel sem sprint aberto — mais uma por chamada ao `operator` —, escrita por quem orquestrou. Nota iniciando em `pre-sprint;` ou `entre-sprints;`.

## Registro
| Data | Papel | Modelo | Comando | Task/História | Categoria | Unidade | Tokens | Duração | Nota |
|---|---|---|---|---|---|---|---|---|---|
```

**Variante "bloco" — `.team-project/fixes/B-<nnn>/consumption.md` (R33).** A pasta nasce quando o `/sm fix plan` monta o bloco; dali até o `## Fechamento` do `verdict.md`, **toda** invocação do bloco grava aqui (inclusive as do `operator`, e inclusive com sprint aberto). **Retenção igual à do sprint:** fecha com a pasta, nada se move, e o acumulado da trilha é **derivado** somando `fixes/*/consumption.md`. Mesmo modelo e mesmas regras; muda o cabeçalho e os totais:

```markdown
# Consumo — Bloco B-<nnn>

> **DOCUMENTO VIVO até o fechamento do bloco** · **Dono:** SM
> Uma linha por invocação de papel do bloco (`fix plan` a partir da montagem, `fix run` até o fechamento) — mais uma por chamada ao `operator`. Task/História recebe `B-<nnn>`, ou `F-<nnn>` quando a invocação serve a uma só. A **triagem não entra** aqui (vai aos destinos de sempre, Nota `triagem;`).

## Registro
| Data | Papel | Modelo | Comando | Task/História | Categoria | Unidade | Tokens | Duração | Nota |
|---|---|---|---|---|---|---|---|---|---|

## Totais do bloco (derivado)
| Papel | Modelo | Σ tokens | Nº de invocações | Duração total |
|---|---|---|---|---|
| sm · po · arc · ux · qa · dev | <modelo> | <n> | <n> | <mm:ss> |
| operator ← <arc\|qa\|dev\|ux> | <modelo do `operator`> | <n> | <n chamadas> | <mm:ss> |
| **Total do bloco** | — | **<n>** | **<n>** | **<mm:ss>** |
| **Custo por Correção fechada** | — | **Σ ÷ nº de F-IDs fechadas** | — | — |
| Custo de promoção *(à parte, nunca diluído)* | — | <Σ das linhas das F-IDs promovidas> | — | — |

**Fechado em:** <aaaa-mm-dd>
```

**Categoria e Unidade das invocações da trilha `fix`** (classificação pela tabela, nunca estimativa):

| Invocação | Categoria | Unidade |
|---|---|---|
| Arquiteto — mini-planos (`fix plan`) | `produção` | `B-<nnn>` |
| dev (`fix run`) | `produção` | `F-<nnn>` — uma linha por F-ID quando houver número por F-ID; senão `B-<nnn>` |
| QA (`fix run`) | `verificação` | `B-<nnn>` |
| `operator` | `verificação` | a do chamador |
| PO — delta do ajuste / aplicação do delta | `especificação` | `F-<nnn>` |
| UX — texto de tela (P4) | `especificação` | `B-<nnn>` |
| Arquiteto — revalidação (D9) | `produção`, Nota `revalidação; …` | `F-<nnn>` |
| Retomada por GAP · nova rodada depois de ⚠️/❌ | `retrabalho` | `F-<nnn>` |
| `/po note` · `/po bug` (triagem) | `cerimônia`, Nota `triagem;` | `F-<nnn>` ou `n/a` |
| `/qa bug` (triagem) | `verificação`, Nota `triagem;` | `F-<nnn>` ou `n/a` |

A revalidação **não** é `retrabalho` (a definição de `retrabalho` exige veredito ⚠️/❌ ou GAP anterior); fica visível pela Nota.

**Fonte única.** Onde e como gravar o consumo fora de sprint (destino, Nota, linha do `operator`, piso) está **só aqui** — §Como gravar e as regras abaixo. `working-rules.md` R28, `workflow-sprint.md` e `workflow-sdd.md` apontam para cá e não o repetem.
**Escopo — onde este registro existe, e onde não existe.** Só em projeto que **instala** o time — onde `.team-project/` existe. O **clone-fonte do plugin** (o repositório onde o `/review` roda) não tem `.team-project/` e não grava consumo: não há projeto ali, só o processo que o time segue em qualquer projeto. Comando de papel (`/sm`, `/po`, `/arc`, `/ux`, `/qa`, `/dev`) só grava quando o registro de destino existe; `/review` nunca grava.

```markdown
# Consumo — Sprint <n>

> **DOCUMENTO VIVO durante o sprint** → **fechado** no `/sm sprint close` · **Dono:** SM
> Uma linha por invocação de papel, escrita por quem orquestrou — mais uma linha por chamada ao `operator`, a partir da seção "Execução delegada" do relatório do papel chamador.

## O que este número mede — e o que não mede
Toda vez que um subagente (`/sm`, `/po`, `/arc`, `/ux`, `/qa`, `/dev`, incluindo os disparados pelos modos `/sm brainstorm`, `/sm sprint prepare` e `/sm sprint run`; o `/team` não dispara agente) termina, a sessão que o disparou recebe o total de **tokens** e a **duração** daquela invocação — é isso que vira uma linha aqui. **A sessão principal não enxerga o próprio consumo**: leitura, triagem e consolidação feitas fora de uma invocação de papel não entram nesta tabela. **O `operator` chamado por um papel** (R28) também não é visto pela sessão — o papel chamador o vê, e o **retrata** na seção "Execução delegada" do relatório final (tokens · duração · modelo · job · Task/História, ou "não disponível — <motivo>"); a sessão grava essas linhas na mesma passada da linha do papel. Este registro mede **o trabalho dos papéis e do `operator` que eles chamaram**, não **o custo total da sessão** — leia o total como um piso, nunca como o gasto completo. A **linha de sessão** (`/usage` colado pelo stakeholder) é a única fonte observada do custo da sessão inteira, mas **é lida à parte** até a verificação da premissa dela (§Regras).

## Registro
| Data | Papel | Modelo | Comando | Task/História | Categoria | Unidade | Tokens | Duração | Nota |
|---|---|---|---|---|---|---|---|---|---|
| <aaaa-mm-dd> | <sm\|po\|arc\|ux\|qa\|dev\|operator> | <opus\|sonnet\|haiku\|"não disponível — <motivo>"> | `/<comando>` | <ID ou "n/a"> | <especificação\|produção\|verificação\|retrabalho\|cerimônia> | <H-nnn\|F-nnn\|B-nnn\|sprint-<n>> | <n> | <mm:ss> | <observação, ou "não disponível — <motivo>"> |
| <aaaa-mm-dd> | operator | <o `model:` de `agents/operator.md`> | `/<comando do chamador>` | <ID do chamador> | verificação *(ou `retrabalho`, pela regra de Categoria)* | <a do chamador> | <n> | <mm:ss> | chamado por <papel>; job `.team-project/operator/<sprint>/<job>/` *(job pré-sprint: Nota inicia em `pre-sprint;` e o caminho é `operator/pre-sprint/<job>/`)* |
| <aaaa-mm-dd> | sessão | vários | `/usage` | n/a | cerimônia *(ou a da sessão)* | sprint-<n> | <entrada · saída · cache, por modelo — do `/usage` colado> | <duração da sessão> | **linha de sessão** — custo **observado** em US$: <valor do `/usage`>; **lida à parte, não soma às linhas por invocação** (Premissa da linha de sessão, abaixo) |

## Totais do sprint (derivado)
> Lido pela retrospectiva **antes** do fechamento da pasta, na seção "Consumo real do sprint" de `sprints/<n>/retrospective.md`. **As linhas de sessão (`/usage`) ficam fora destes totais** — são lidas à parte (Premissa da linha de sessão, em §Regras). **O `operator` entra no Total do sprint**, mas em **linhas próprias por chamador** — o total do `operator` fica exposto como o de "operator chamado pelo papel X", nunca diluído na linha do papel.

| Papel | Modelo | Σ tokens | Nº de invocações | Duração total |
|---|---|---|---|---|
| sm · po · arc · ux · qa · dev | <modelo> | <n> | <n> | <mm:ss> |
| operator ← <arc\|qa\|dev\|ux> *(uma linha por chamador)* | <modelo do `operator`> | <n> | <n chamadas> | <mm:ss> |
| **Total do sprint** (papéis + `operator`) | — | **<n>** | **<n>** | **<mm:ss>** |

## Relação com `/review metrics`
`/review metrics` mede a **pegada estática** do processo — bytes de `agents/`+`commands/`+`roles/`, fixa por versão do plugin, igual em qualquer projeto que instale o time. Este registro mede o **gasto real**, variável por projeto e por sprint. **Os dois não se somam nem se substituem**: a pegada estática diz quanto cada invocação paga de carga fixa antes de qualquer trabalho; este registro diz quanto se gastou de fato fazendo o trabalho. Ver `workflow-processo.md` §5c do processo do time.
```

## Como gravar

**É esta seção que todo `commands/*.md` cita** ("Registro de consumo: se `.team-project/sprints/<n>/consumption.md` existir, grave conforme `templates/consumption.md` §Como gravar"). Quem grava é **a sessão que orquestrou** a invocação — nunca o papel.

1. **Destino — três, nesta ordem de prioridade.** **(1) Bloco da trilha `fix` aberto** (planejado ou em execução: `fixes/B-<nnn>/` existe e o `verdict.md` dele não tem `## Fechamento`) → grave em **`fixes/B-<nnn>/consumption.md`**, **inclusive com sprint aberto** (R33; variante "bloco" abaixo). **A triagem não é do bloco:** as invocações dela (`/po note`, `/po bug`, `/qa bug`), mesmo rodando dentro do `fix plan`, seguem os destinos (2) e (3), com Nota iniciando em **`triagem;`**. **(2) e (3), por estado do sprint:** `<n>` é o sprint corrente (`.team-project/README.md` §2). **Sprint aberto** = `sprints/<n>/consumption.md` existe e `sprints/<n>/retrospective.md` não → grave lá. **Sem sprint aberto** (antes do sprint 1, ou `<n>` já fechado: `prepare`, `sdd`, onboarding, brainstorm, `agreement`) → grave em **`.team-project/consumption.md`**, Nota `pre-sprint;` (antes do sprint 1) ou `entre-sprints;`. Nenhum dos três existe → **nada a fazer**. Sprint ou bloco **fechado** nunca recebe linha. Linha com Task/História ou Unidade `B-<nnn>` **fora de** `fixes/` é desvio de R33 (o C4 avisa); `F-<nnn>` fora de `fixes/` só com Nota `triagem;`.
2. **Uma linha por subagente disparado nesta invocação**, com os números que ele devolve ao terminar: data, papel, **modelo** (o `model:` de `agents/<papel>.md` do plugin instalado, ou o override passado ao disparar; sem leitura nem override, "não disponível — <motivo>", nunca deduzir), comando, Task/História (ou `n/a`), **Categoria e Unidade** (classificação pela tabela de §Regras, nunca estimativa), tokens, duração. Modos com vários papéis geram várias linhas.
3. **Número indisponível:** "não disponível — <motivo>". Nunca estime (R7).
4. **`operator`:** se o retorno traz a seção **"Execução delegada"**, acrescente **uma linha por chamada ao `operator`** listada ali — papel `operator`, modelo da seção (sem ele, o `model:` de `agents/operator.md`), mesmo comando e Task/História, tokens e duração da seção, Nota `chamado por <papel>; job <caminho em .team-project/operator/>`. Entram no total do sprint, expostas à parte por chamador (R28).
5. **Notificação parcial** de uma retomada não é linha nova; **invocação que falha** segue R27 (retentativa, texto literal do harness).

Detalhe e justificativa de cada regra: `## Regras`, logo abaixo.
## Regras

- **Uma linha por invocação.** É a única unidade que a sessão orquestradora observa diretamente — ela recebe tokens e duração quando o subagente termina, nunca o próprio consumo.
- **Notificação parcial não é linha nova.** Numa retomada por `SendMessage`, a mesma invocação pode gerar mais de uma notificação de uso antes do relatório final — cada notificação reporta o total **daquela invocação até aquele instante**, nunca um acumulado à parte que se soma às demais. Registre uma única linha por invocação, com o número da notificação **final**; descarte os números de notificações parciais ao chegar a próxima, não os some a ela.
- **Modelo é o configurado, não o servido.** A notificação de fim de subagente devolve tokens e duração, **não o modelo**. O que a sessão que orquestra observa é o agente que disparou e o `model:` do cartão `agents/<papel>.md` do plugin instalado (ou um override que ela mesma passou ao disparar) — grave esse valor. Se não conseguiu ler o cartão nem há override declarado, escreva "não disponível — <motivo>", nunca deduza. Tokens vêm como **um total** por invocação: a divisão entrada/saída/cache **não é observável** aqui, e a análise do consumo não a presume.
- **Número indisponível vira nota, nunca estimativa** — mesma régua de R7 ("sem evidência, não aconteceu"): escreva "não disponível — <motivo>".
- **Toda invocação vira linha.** Qualquer subagente de papel que termina é uma linha — com Task/História quando houver, `"n/a"` quando não. Não filtra por relevância nem por tamanho: filtrar depois é mais barato que reconstruir o que não foi gravado.
- **Quem escreve** é sempre a sessão que orquestrou aquela invocação — o próprio papel não vê o número, então nunca é ele quem grava a própria linha. **Vale também para o `operator`:** o papel chamador **retrata** cada chamada na seção "Execução delegada" do relatório final (Operator job · Task/História · Modelo · Tokens · Duração), e a **sessão que o disparou** grava as linhas `operator` **na mesma passada** da linha do papel. Um escritor só; o registro continua do SM.
- **Linha do `operator`.** Papel `operator`; Modelo é o `model:` de `agents/operator.md` (configurado, não servido — regra acima); Task/História é a do chamador; Nota diz `chamado por <papel>; job <caminho>`. Número que o papel não trouxe: "não disponível — <motivo>", nunca estimativa, sem piso nem teto.
- **Identificação da chamada.** A célula "Operator job" da seção "Execução delegada" (e o `job` da Nota) é o **caminho do job**; quando houver **mais de uma chamada na mesma pasta** (ex.: duas da mesma Task), acrescenta-se `— <log>` para distinguir (é o mesmo `<log>` de `report-<log>.md`, R28). A contagem de R28 é **chamadas** (um `report.md` ou `report-<log>.md` por chamada) × linhas `operator`.
- **Jobs `pre-sprint/` (R28).** Job de `.team-project/operator/pre-sprint/<job>/` (Arquiteto e UX em onboarding, brainstorm, portão ①, linha de base) roda sem sprint aberto. A sessão que orquestrou o papel chamador grava **na hora**, em `.team-project/consumption.md`, **uma linha `operator` por job**, a partir da seção "Execução delegada" do relatório do chamador (para o Arquiteto, a do checkpoint de spike ou a seção 11 do plano) — nunca estimada; sem a seção, "não disponível — <motivo>". Nota: `pre-sprint; chamado por <papel>; job .team-project/operator/pre-sprint/<job>/`. Cada job é contado **uma vez**, nesse registro, e entra na contagem de R28 do fechamento do sprint em que nasceu. Invocações dos **papéis** anteriores à existência do registro não são reconstruídas — o total segue sendo um piso para o que veio antes.
- **Invocações do `/sm sprint prepare` e do `/sm sdd`.** Rodam com o sprint anterior já **fechado** — seu `consumption.md` é imutável e o do sprint novo ainda não nasceu. A sessão que orquestrou grava **uma linha por subagente disparado** (data, papel, modelo, comando, História ou `n/a`, tokens, duração; indisponível = "não disponível — <motivo>", nunca estimado) **direto em `.team-project/consumption.md`**, Nota iniciando em `entre-sprints;` (ou `pre-sprint;` se ainda não há sprint 1). **Não há transcrição no passo 9 da Planning e não há subseção em `context.md`** — o `consumption.md` do sprint novo nasce vazio.
- **Premissa (R7) — `operator`.** O número que o papel devolve à sessão **não inclui** o do `operator` aninhado; por isso as duas linhas se somam. Se uma medição mostrar o contrário (soma dupla), a regra volta ao `/review`.
- **Premissa (R7) — linha de sessão (outra premissa, distinta da do `operator`).** A linha de sessão (Papel `sessão`, Modelo `vários`) vem do `/usage` que o stakeholder cola no fim da sessão de trabalho; a sessão grava **uma** linha: Tokens por modelo (entrada · saída · cache) e, na Nota, o **custo em US$ do `/usage`** — o único custo em US$ **observado**; custo derivado só na retrospectiva, com a fórmula e o preço ao lado, nunca no registro como se medido. **Não se sabe se o `/usage` já inclui os subagentes.** Até a verificação no projeto-piloto, a linha de sessão **não se soma** às linhas por invocação — é lida **à parte**, nunca no Total do sprint. **Verificação pendente:** um `/po status` com `/usage` antes e depois, comparado com a linha do PO; o resultado volta ao `/review`, que fixa a regra (se incluir os subagentes, as linhas por invocação viram detalhamento; se não, as duas se somam).
- **Categoria é classificação pela tabela, nunca estimativa.** Valores: `especificação` (brainstorm, sdd, story, requirement, prototype, screen) · `produção` (arc plan, dev) · `verificação` (qa, operator) · `retrabalho` · `cerimônia` (board, close, prepare, plan, review, retro, agreement, onboarding, `po note`/`po bug`). As invocações da trilha `fix` têm tabela própria na "Variante bloco". Quem preenche é a sessão que orquestrou. **`retrabalho`** = toda invocação de Arquiteto, dev ou QA sobre uma Task **depois do primeiro veredito ⚠️/❌** ou **depois de um 🔺 GAP** — mecânico: a sessão sabe se já houve veredito ou GAP naquela Task. **Unidade** = `H-<nnn>` · `F-<nnn>` (uma Correção da trilha `fix`) · `B-<nnn>` (o bloco inteiro — custo compartilhado entre as Correções dele, não rateado: o custo por Correção fechada é Σ ÷ F-IDs fechadas) · `sprint-<n>` (custo compartilhado; cerimônia de sprint não é de uma História — a retrospectiva a ratea em partes iguais entre as Histórias aceitas, declarando o rateio). Linha antiga sem Categoria/Unidade fica vazia — não se reconstrói o passado (sprint fechado é imutável). Sem Categoria/Unidade, "Custo × resultado" da retrospectiva diz "não disponível — <motivo>".
- **Nasce e morre no sprint.** Arquivo novo a cada `/sm sprint plan`, fechado a cada `/sm sprint close`. Nada é movido, nada é zerado: a pasta do sprint já é a unidade de retenção (§1c).
- **O acumulado é derivado, não mantido.** "Quanto o time custou até aqui" se responde somando os `sprints/*/consumption.md`, na hora da pergunta — em vez de uma tabela viva que precisa ser conciliada a cada fechamento e que deriva em silêncio quando alguém esquece.
