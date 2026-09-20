# Template — Registro de Consumo do Sprint

> **Dono:** SM · Vive em `.team-project/sprints/<n>/consumption.md` · Alimentado pela **sessão que orquestra**, não pelo papel

Registra o que a sessão que dispara cada subagente de papel recebe quando ele termina: tokens e duração. Existe porque "quanto o time custou neste sprint" não tinha resposta sem somar na mão.

**Retenção — uma forma só (R25 · [`../process/artifact-ownership.md` §1c](../process/artifact-ownership.md)).** O registro **nasce dentro do sprint a que pertence** e **fecha com a pasta**, no `/sm sprint close`. Não há vivo+archive, não há relocação de linhas, não há tabela de totais a conciliar: o acumulado do projeto é **derivado sob demanda**, somando `sprints/*/consumption.md`.

**Escopo — onde este registro existe, e onde não existe.** Só em projeto que **instala** o time — onde `.team-project/` existe. O **clone-fonte do plugin** (o repositório onde o `/review` roda) não tem `.team-project/` e não grava consumo: não há projeto ali, só o processo que o time segue em qualquer projeto. Comando de papel (`/sm`, `/po`, `/arc`, `/ux`, `/qa`, `/dev`, `/team`) só grava quando este arquivo existe; `/review` nunca grava.

```markdown
# Consumo — Sprint <n>

> **DOCUMENTO VIVO durante o sprint** → **fechado** no `/sm sprint close` · **Dono:** SM
> Uma linha por invocação de papel, escrita por quem orquestrou.

## O que este número mede — e o que não mede
Toda vez que um subagente (`/sm`, `/po`, `/arc`, `/ux`, `/qa`, `/dev`, ou um dos disparados por `/team`) termina, a sessão que o disparou recebe o total de **tokens** e a **duração** daquela invocação — é isso que vira uma linha aqui. **A sessão principal não enxerga o próprio consumo**: leitura, triagem e consolidação feitas fora de uma invocação de papel não entram nesta tabela. Este registro mede **o trabalho dos papéis**, não **o custo total da sessão** — leia o total como um piso, nunca como o gasto completo.

## Registro
| Data | Papel | Comando | Task/História | Tokens | Duração | Nota |
|---|---|---|---|---|---|---|
| <aaaa-mm-dd> | <sm\|po\|arc\|ux\|qa\|dev> | `/<comando>` | <ID ou "n/a"> | <n> | <mm:ss> | <observação, ou "não disponível — <motivo>"> |

## Totais do sprint (derivado)
> Lido pela retrospectiva **antes** do fechamento da pasta, na seção "Consumo real do sprint" de `sprints/<n>/retrospective.md`.

| Papel | Σ tokens | Nº de invocações | Duração total |
|---|---|---|---|
| sm · po · arc · ux · qa · dev | <n> | <n> | <mm:ss> |
| **Total do sprint** | **<n>** | **<n>** | **<mm:ss>** |

## Relação com `/review metrics`
`/review metrics` mede a **pegada estática** do processo — bytes de `agents/`+`commands/`+`roles/`, fixa por versão do plugin, igual em qualquer projeto que instale o time. Este registro mede o **gasto real**, variável por projeto e por sprint. **Os dois não se somam nem se substituem**: a pegada estática diz quanto cada invocação paga de carga fixa antes de qualquer trabalho; este registro diz quanto se gastou de fato fazendo o trabalho. Ver `workflow.md` §5c do processo do time.
```

## Regras

- **Uma linha por invocação.** É a única unidade que a sessão orquestradora observa diretamente — ela recebe tokens e duração quando o subagente termina, nunca o próprio consumo.
- **Notificação parcial não é linha nova.** Numa retomada por `SendMessage`, a mesma invocação pode gerar mais de uma notificação de uso antes do relatório final — cada notificação reporta o total **daquela invocação até aquele instante**, nunca um acumulado à parte que se soma às demais. Registre uma única linha por invocação, com o número da notificação **final**; descarte os números de notificações parciais ao chegar a próxima, não os some a ela.
- **Número indisponível vira nota, nunca estimativa** — mesma régua de R7 ("sem evidência, não aconteceu"): escreva "não disponível — <motivo>".
- **Toda invocação vira linha.** Qualquer subagente de papel que termina é uma linha — com Task/História quando houver, `"n/a"` quando não. Não filtra por relevância nem por tamanho: filtrar depois é mais barato que reconstruir o que não foi gravado.
- **Quem escreve** é sempre a sessão que orquestrou aquela invocação — o próprio papel não vê o número, então nunca é ele quem grava a própria linha.
- **Nasce e morre no sprint.** Arquivo novo a cada `/sm sprint plan`, fechado a cada `/sm sprint close`. Nada é movido, nada é zerado: a pasta do sprint já é a unidade de retenção (§1c).
- **O acumulado é derivado, não mantido.** "Quanto o time custou até aqui" se responde somando os `sprints/*/consumption.md`, na hora da pergunta — em vez de uma tabela viva que precisa ser conciliada a cada fechamento e que deriva em silêncio quando alguém esquece.
