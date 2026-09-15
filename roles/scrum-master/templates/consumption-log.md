# Template — Registro de Consumo do Time

> **Dono:** SM · Vive em `.team-project/scrum-master/consumption-log.md` · Alimentado pela **sessão que orquestra**, não pelo papel

Registra o que a sessão que dispara cada subagente de papel recebe quando ele termina: tokens e duração. Existe porque "quanto o time custou neste projeto" não tinha resposta sem abrir o changelog do processo e somar na mão.

**Escopo — onde este registro existe, e onde não existe.** Só em projeto que **instala** o time — onde `.team-project/` existe. O **clone-fonte do plugin** (o repositório onde o `/review` roda) não tem `.team-project/` e não grava consumo: não há projeto ali, só o processo que o time segue em qualquer projeto. Comando de papel (`/sm`, `/po`, `/arc`, `/ux`, `/qa`, `/dev`, `/team`) só grava quando este arquivo existe; `/review` nunca grava, porque nunca roda com `.team-project/` no caminho.

```markdown
# Registro de Consumo do Time — <projeto>

> **DOCUMENTO VIVO** · **Dono:** SM · Uma linha por invocação de papel, escrita por quem orquestrou

## O que este número mede — e o que não mede
Toda vez que um subagente (`/sm`, `/po`, `/arc`, `/ux`, `/qa`, `/dev`, ou um dos disparados por `/team`) termina, a sessão que o disparou recebe o total de **tokens** e a **duração** daquela invocação — é isso que vira uma linha aqui. **A sessão principal não enxerga o próprio consumo**: leitura, triagem e consolidação feitas fora de uma invocação de papel não entram nesta tabela. Este registro mede **o trabalho dos papéis**, não **o custo total da sessão** — leia o total como um piso, nunca como o gasto completo.

## Registro
| Data | Papel | Comando | Task/História | Tokens | Duração | Nota |
|---|---|---|---|---|---|---|
| <aaaa-mm-dd> | <sm\|po\|arc\|ux\|qa\|dev> | `/<comando>` | <ID ou "n/a"> | <n> | <mm:ss> | <observação, ou "não disponível — <motivo>"> |

## Totais por papel (derivado)
> **Acumulado desde o início do projeto** — nunca reseta no arquivamento por sprint; soma o que está arquivado mais o sprint corrente.

| Papel | Σ tokens | Nº de invocações | Período |
|---|---|---|---|

## Relação com `/review metrics`
`/review metrics` mede a **pegada estática** do processo — bytes de `agents/`+`commands/`+`roles/`, fixa por versão do plugin, igual em qualquer projeto que instale o time. Este registro mede o **gasto real**, variável por projeto e por sprint. **Os dois não se somam nem se substituem**: a pegada estática diz quanto cada invocação paga de carga fixa antes de qualquer trabalho; este registro diz quanto se gastou de fato fazendo o trabalho. Ver [`workflow.md` §5c](../process/workflow.md).
```

## Regras

- **Uma linha por invocação.** É a única unidade que a sessão orquestradora observa diretamente — ela recebe tokens e duração quando o subagente termina, nunca o próprio consumo.
- **Número indisponível vira nota, nunca estimativa** — mesma régua de R7 ("sem evidência, não aconteceu"): escreva "não disponível — <motivo>".
- **Retenção e arquivamento — arquivar por sprint fechado, decidido ([`process-changelog.md` v3.18](../process/process-changelog.md)), mesmo padrão de R17 (teto + arquivamento) que já governa o changelog do processo.** No `/sm sprint close` ([`workflow.md` §5e](../process/workflow.md)), depois de a retrospectiva registrar o consumo real do sprint, o SM move **todas** as linhas da tabela `## Registro` para `.team-project/scrum-master/consumption-log-archive.md` — sob um cabeçalho `## Sprint <n>`, íntegras, sem uma vírgula alterada (arquivar é relocar, não reescrever) — e limpa a tabela `## Registro` (só o cabeçalho) para o sprint seguinte. A tabela `## Totais por papel (derivado)` **não é arquivada**: ela soma desde o início do projeto, arquivado ou não. **O registro vivo guarda o sprint corrente (`## Registro`) mais os totais acumulados (`## Totais por papel`)**; o detalhe de um sprint fechado vive, íntegro, no arquivo.
- **O que entra: toda invocação vira linha, decidido ([`process-changelog.md` v3.18](../process/process-changelog.md)).** Qualquer subagente de papel que termina é uma linha — com Task/História quando houver, `"n/a"` quando não. Não filtra por relevância nem por tamanho da invocação: filtrar depois é mais barato que reconstruir o que não foi gravado.
- **Quem escreve** é sempre a sessão que orquestrou aquela invocação — o próprio papel não vê o número, então nunca é ele quem grava a própria linha.
