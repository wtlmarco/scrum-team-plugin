# Template — Registro de Consumo do Sprint

> **Dono:** SM · Vive em `.team-project/sprints/<n>/consumption.md` · Alimentado pela **sessão que orquestra**, não pelo papel

Registra o que a sessão que dispara cada subagente de papel recebe quando ele termina: tokens e duração — **e**, por retratação do papel chamador, o consumo do `operator` que ele chamou. Existe porque "quanto o time custou neste sprint" não tinha resposta sem somar na mão.

**Retenção — uma forma só (R25 · [`../process/artifact-ownership.md` §1c](../process/artifact-ownership.md)).** O registro **nasce dentro do sprint a que pertence** e **fecha com a pasta**, no `/sm sprint close`. Não há vivo+archive, não há relocação de linhas, não há tabela de totais a conciliar: o acumulado do projeto é **derivado sob demanda**, somando `sprints/*/consumption.md`.

**Escopo — onde este registro existe, e onde não existe.** Só em projeto que **instala** o time — onde `.team-project/` existe. O **clone-fonte do plugin** (o repositório onde o `/review` roda) não tem `.team-project/` e não grava consumo: não há projeto ali, só o processo que o time segue em qualquer projeto. Comando de papel (`/sm`, `/po`, `/arc`, `/ux`, `/qa`, `/dev`) só grava quando este arquivo existe; `/review` nunca grava.

```markdown
# Consumo — Sprint <n>

> **DOCUMENTO VIVO durante o sprint** → **fechado** no `/sm sprint close` · **Dono:** SM
> Uma linha por invocação de papel, escrita por quem orquestrou — mais uma linha por chamada ao `operator`, a partir da seção "Execução delegada" do relatório do papel chamador.

## O que este número mede — e o que não mede
Toda vez que um subagente (`/sm`, `/po`, `/arc`, `/ux`, `/qa`, `/dev`, incluindo os disparados pelos modos `/sm brainstorm`, `/sm sprint prepare` e `/sm sprint run`; o `/team` não dispara agente) termina, a sessão que o disparou recebe o total de **tokens** e a **duração** daquela invocação — é isso que vira uma linha aqui. **A sessão principal não enxerga o próprio consumo**: leitura, triagem e consolidação feitas fora de uma invocação de papel não entram nesta tabela. **O `operator` chamado por um papel** (R28) também não é visto pela sessão — o papel chamador o vê, e o **retrata** na seção "Execução delegada" do relatório final (tokens · duração · modelo · job · Task/História, ou "não disponível — <motivo>"); a sessão grava essas linhas na mesma passada da linha do papel. Este registro mede **o trabalho dos papéis e do `operator` que eles chamaram**, não **o custo total da sessão** — leia o total como um piso, nunca como o gasto completo.

## Registro
| Data | Papel | Modelo | Comando | Task/História | Tokens | Duração | Nota |
|---|---|---|---|---|---|---|---|
| <aaaa-mm-dd> | <sm\|po\|arc\|ux\|qa\|dev\|operator> | <opus\|sonnet\|haiku\|"não disponível — <motivo>"> | `/<comando>` | <ID ou "n/a"> | <n> | <mm:ss> | <observação, ou "não disponível — <motivo>"> |
| <aaaa-mm-dd> | operator | <o `model:` de `agents/operator.md`> | `/<comando do chamador>` | <ID do chamador> | <n> | <mm:ss> | chamado por <papel>; job `.team-project/operator/<sprint>/<job>/` *(job pré-sprint: Nota inicia em `pre-sprint;` e o caminho é `operator/pre-sprint/<job>/`)* |

## Totais do sprint (derivado)
> Lido pela retrospectiva **antes** do fechamento da pasta, na seção "Consumo real do sprint" de `sprints/<n>/retrospective.md`. **O `operator` entra no Total do sprint**, mas em **linhas próprias por chamador** — o total do `operator` fica exposto como o de "operator chamado pelo papel X", nunca diluído na linha do papel.

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

1. **Só onde o registro existe.** `<n>` é o sprint corrente (`.team-project/README.md` §2). Sem `consumption.md`, **nada a fazer**. Sprint **fechado** não recebe linha (o `sprint prepare` roda depois do fechamento: ver "Invocações do `/sm sprint prepare`" abaixo).
2. **Uma linha por subagente disparado nesta invocação**, com os números que ele devolve ao terminar: data, papel, **modelo** (o `model:` de `agents/<papel>.md` do plugin instalado, ou o override passado ao disparar; sem leitura nem override, "não disponível — <motivo>", nunca deduzir), comando, Task/História (ou `n/a`), tokens, duração. Modos com vários papéis geram várias linhas.
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
- **Identificação da chamada.** A célula "Operator job" da seção "Execução delegada" (e o `job` da Nota) é o **caminho do job**; quando houver **mais de uma chamada na mesma pasta** (ex.: duas da mesma Task), acrescenta-se `— <log>` para distinguir. A contagem de R28 é **chamadas** (pasta de job, mais um por log adicional na mesma pasta) × linhas `operator`.
- **Jobs `pre-sprint/` (R28).** Job de `.team-project/operator/pre-sprint/<job>/` (Arquiteto e UX em onboarding, brainstorm, portão ①, linha de base) roda antes de este arquivo existir, e o comando só grava se ele existir. Ao **criar o primeiro `consumption.md` do projeto** (`/sm sprint plan`), o SM lança **uma linha `operator` por job** de `pre-sprint/`, **transcrita** da seção "Execução delegada" do relatório do papel chamador (para o Arquiteto, a do checkpoint de spike ou a seção 11 do plano) — nunca estimada; sem a seção, "não disponível — <motivo>". Nota: `pre-sprint; chamado por <papel>; job .team-project/operator/pre-sprint/<job>/`; Data é a da chamada, quando o relatório a traz. Cada job é contado **uma vez**, neste sprint, e entra na contagem de R28 do fechamento. As invocações dos **papéis** anteriores ao registro, **exceto as do `sprint prepare` (abaixo)**, não são reconstruídas — o total segue sendo um piso para o que veio antes do `prepare`.
- **Invocações do `/sm sprint prepare` e do `/sm sdd` (v3.34).** O `prepare` e o `sdd` rodam com o sprint anterior já **fechado** — seu `consumption.md` é imutável e o do sprint novo ainda não nasceu. A sessão que orquestrou o `prepare` **não grava no arquivo fechado**: deixa uma linha por subagente disparado (data, papel, modelo, comando, História ou `n/a`, tokens, duração; indisponível = "não disponível — <motivo>", nunca estimado) em `.team-project/scrum-master/context.md` §"Candidatas do próximo sprint", subseção "Consumo pré-sprint (prepare · sdd)". No passo 9 da Planning (criação do `consumption.md`), o SM as **transcreve** com a Nota iniciando em `pre-sprint;` (mesma marca dos jobs do `operator`) e **limpa a subseção**. Assim o total do sprint deixa de ser piso para o `prepare`.
- **Premissa (R7).** O número que o papel devolve à sessão **não inclui** o do `operator` aninhado; por isso as duas linhas se somam. Se uma medição mostrar o contrário (soma dupla), a regra volta ao `/review`.
- **Nasce e morre no sprint.** Arquivo novo a cada `/sm sprint plan`, fechado a cada `/sm sprint close`. Nada é movido, nada é zerado: a pasta do sprint já é a unidade de retenção (§1c).
- **O acumulado é derivado, não mantido.** "Quanto o time custou até aqui" se responde somando os `sprints/*/consumption.md`, na hora da pergunta — em vez de uma tabela viva que precisa ser conciliada a cada fechamento e que deriva em silêncio quando alguém esquece.
