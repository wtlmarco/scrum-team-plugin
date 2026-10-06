# Template — Registro de Consumo do Sprint

> **Dono:** SM · Vive em `.team-project/sprints/<n>/consumption.md`, **em** `.team-project/consumption.md` para o que acontece sem sprint aberto (mesmo modelo — ver "Fora de sprint") **e em** `.team-project/fixes/B-<nnn>/consumption.md` para o bloco da trilha `fix` (variante "bloco" — ver abaixo) · Alimentado **pelo medido** (v3.45): o hook **G16** grava cada rodada de subagente em `.team-project/usage.jsonl` e a sessão roda `scripts/checks/consumption.ps1`, que escreve as linhas aqui — ninguém transcreve número

Registra o que cada subagente consumiu — papel, `operator` incluído — **medido no transcript do próprio subagente**: tokens processados, contexto final, modelo servido e duração. Existe porque "quanto o time custou neste sprint" não tinha resposta sem somar na mão.

**Tokens processados × número da notificação (medido em 06/10/2026).** O número que a notificação de fim de subagente mostra (`subagent_tokens`) é o **tamanho do contexto na última chamada** ao modelo, não a soma do que o subagente processou: 49 004 notificados × 273 190 processados; 53 245 × 322 194. A coluna **Tokens** é a soma de todas as chamadas (entrada + gravação de cache + leitura de cache + saída); a Nota traz o da notificação (`notificação ≈`), a leitura de cache, a saída, o nº de chamadas e o contexto da 1ª chamada (a carga fixa do papel). **Linhas anteriores à v3.45 trazem o número da notificação** — não se comparam com as medidas, e os Totais os somam só na coluna "Σ notificação".

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
| Papel | Modelo | Σ tokens processados | Nº de invocações | Duração total | Σ notificação |
|---|---|---|---|---|---|
| sm · po · arc · ux · qa · dev | <modelo> | <n> | <n> | <mm:ss> | <n> |
| operator ← <arc\|qa\|dev\|ux> | <modelo do `operator`> | <n> | <n chamadas> | <mm:ss> | <n> |
| **Total do bloco** | — | **<n>** | **<n>** | **<mm:ss>** | **<n>** |

*(A tabela acima é reescrita pelo `consumption.ps1`; as duas linhas abaixo ficam fora dela e a sessão as preenche no fechamento.)*

| | |
|---|---|
| **Custo por Correção fechada** | **Σ ÷ nº de F-IDs fechadas** |
| Custo de promoção *(à parte, nunca diluído)* | <Σ das linhas das F-IDs promovidas> |

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
Toda vez que um subagente (papel ou `operator`) para, o hook **G16** soma, no transcript dele, o `usage` de cada chamada ao modelo daquela rodada — é isso que vira uma linha aqui, pelo `scripts/checks/consumption.ps1`. **Tokens** = soma processada (entrada + cache gravado + cache lido + saída); a Nota traz o número da notificação (contexto final), que é o que a sessão via antes da v3.45. **A sessão principal não é medida**: leitura, triagem e consolidação feitas fora de um subagente não entram nesta tabela. O `operator` aparece em linha própria, com o chamador na Nota (o hook liga o filho ao pai pelo `agentId`). Este registro mede **o trabalho dos papéis e do `operator`**, não **o custo total da sessão** — leia o total como um piso. A **linha de sessão** (`/usage` colado pelo stakeholder) é a única fonte observada do custo da sessão inteira, mas **é lida à parte** até a verificação da premissa dela (§Regras).

## Registro
| Data | Papel | Modelo | Comando | Task/História | Categoria | Unidade | Tokens | Duração | Nota |
|---|---|---|---|---|---|---|---|---|---|
| <aaaa-mm-dd hh:mm> | <sm\|po\|arc\|ux\|qa\|dev\|operator> | <modelo servido: opus\|sonnet\|haiku> | `Agent` · <descrição do disparo> | <ID do prompt ou "n/a"> | <especificação\|produção\|verificação\|retrabalho\|cerimônia> | <H-nnn\|F-nnn\|B-nnn\|sprint-<n>> | <tokens processados> | <mm:ss> | medido: <agent_id>#<rodada>; notificação ≈ <n>; cache lido <n>; saída <n>; <n> chamada(s); contexto 1ª/pico <n>/<n> |
| <aaaa-mm-dd hh:mm> | operator | haiku | `Agent` · <descrição> | <ID do chamador> | verificação *(ou `retrabalho`)* | <a do chamador> | <n> | <mm:ss> | chamado por <papel>; medido: … *(pré-sprint: Nota inicia em `pre-sprint;`)* |
| <aaaa-mm-dd> | sessão | vários | `/usage` | n/a | cerimônia *(ou a da sessão)* | sprint-<n> | <entrada · saída · cache, por modelo — do `/usage` colado> | <duração da sessão> | **linha de sessão** — custo **observado** em US$: <valor do `/usage`>; **lida à parte, não soma às linhas por invocação** (Premissa da linha de sessão, abaixo) |

## Totais do sprint (derivado)
> Lido pela retrospectiva **antes** do fechamento da pasta, na seção "Consumo real do sprint" de `sprints/<n>/retrospective.md`. **As linhas de sessão (`/usage`) ficam fora destes totais** — são lidas à parte (Premissa da linha de sessão, em §Regras). **O `operator` entra no Total do sprint**, mas em **linhas próprias por chamador** — o total do `operator` fica exposto como o de "operator chamado pelo papel X", nunca diluído na linha do papel.

*(Tabela reescrita pelo `consumption.ps1` a cada execução — não se edita à mão.)*

| Papel | Modelo | Σ tokens processados | Nº de invocações | Duração total | Σ notificação |
|---|---|---|---|---|---|
| sm · po · arc · ux · qa · dev | <modelo> | <n> | <n> | <mm:ss> | <n> |
| operator ← <arc\|qa\|dev\|ux> *(uma linha por chamador)* | <modelo do `operator`> | <n> | <n chamadas> | <mm:ss> | <n> |
| **Total do sprint** (papéis + `operator`) | — | **<n>** | **<n>** | **<mm:ss>** | **<n>** |

## Relação com `/review metrics`
`/review metrics` mede a **pegada estática** do processo — bytes de `agents/`+`commands/`+`roles/`, fixa por versão do plugin, igual em qualquer projeto que instale o time. Este registro mede o **gasto real**, variável por projeto e por sprint. **Os dois não se somam nem se substituem**: a pegada estática diz quanto cada invocação paga de carga fixa antes de qualquer trabalho; este registro diz quanto se gastou de fato fazendo o trabalho. Ver `workflow-processo.md` §5c do processo do time.
```

## Como gravar

**É esta seção que todo `commands/*.md` cita** ("Registro de consumo: … grave conforme `templates/consumption.md` §Como gravar"). Desde a v3.45 **ninguém transcreve número**: o hook **G16** (`hooks/subagent-stop.ps1`) mede cada rodada de subagente e a grava em `.team-project/usage.jsonl`; a sessão que orquestrou roda o script, que escreve as linhas aqui.

1. **Quando:** depois de cada subagente que termina (ou ao fim de um lote, antes de qualquer conferência que leia o consumo — o C1 do `close`, o C4 do bloco, a retrospectiva): `powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/consumption.ps1"`. Rodar de novo não duplica: as linhas medidas (Nota com `medido:`) são reescritas por inteiro; as demais ficam.
2. **Destino — decidido pelo hook na hora da rodada, nesta ordem.** **(1) Bloco da trilha `fix` aberto** (`fixes/B-<nnn>/` existe e o `verdict.md` dele não tem `## Fechamento`), quando o prompt do subagente cita o `B-<nnn>` ou o `.active-run` é da trilha `fix` → **`fixes/B-<nnn>/consumption.md`**, inclusive com sprint aberto (R33). A triagem (`/po note`, `/po bug`, `/qa bug`) que não cita o bloco cai nos destinos seguintes; linha com `F-<nnn>` fora de `fixes/` recebe `triagem;` no começo da Nota pelo próprio script. **(2) Sprint aberto** (`sprints/<n>/consumption.md` existe e `sprints/<n>/retrospective.md` não) → lá. **(3) Sem sprint aberto** → **`.team-project/consumption.md`**, Nota `pre-sprint;` ou `entre-sprints;`. Arquivo de destino inexistente → a linha fica só no `usage.jsonl`. Sprint ou bloco **fechado** nunca recebe linha (o script recusa).
3. **O que o script preenche:** data e hora da rodada, papel, **modelo servido** (do transcript, inclusive override), comando (`Agent` · descrição do disparo), Task/História (o primeiro `T-`/`F-`/`B-`/`H-` do prompt da rodada; senão `.active-task`; senão `n/a`), Categoria e Unidade (§Regras), tokens processados, duração (da 1ª à última chamada da rodada) e a Nota medida. O `operator` sai em linha própria, `chamado por <papel>` (o hook liga o filho ao pai pelo `agentId`).
4. **O que a sessão ainda faz à mão:** só a **linha de sessão** do `/usage` (Papel `sessão`). Linha medida não se edita (o script a reescreve); categoria mecânica que errou (ex.: uma retomada que não é retrabalho) se comenta na retrospectiva, não na linha.
5. **Hook sem dado** (transcript não achado, linha `G16` no `guards.log`) → a rodada não tem linha; grave à mão, com o número da notificação e Nota `não medido — <motivo>`, nunca estimado (R7). **Invocação que falha** segue R27.

Detalhe e justificativa de cada regra: `## Regras`, logo abaixo.
## Regras

- **Uma linha por rodada.** Rodada = do disparo (ou da retomada por `SendMessage`) até a parada do subagente. A retomada acrescenta chamadas ao mesmo transcript; o hook guarda quantas já contou e a linha nova traz **só o delta**, com `#<rodada>` na Nota. Acaba o "número cumulativo" da notificação de uma instância retomada várias vezes.
- **Modelo é o servido.** Vem do `message.model` de cada chamada no transcript — inclusive o override passado ao disparar (escalonamento do dev, plano leve). Rodada com mais de um modelo mostra os dois (`haiku+sonnet`).
- **Número indisponível vira nota, nunca estimativa** — mesma régua de R7: "não disponível — <motivo>".
- **Toda rodada vira linha.** Qualquer subagente que para é uma linha — inclusive agente fora do time (`claude-code-guide`, `Explore`), com o papel como o harness o nomeia. Filtrar depois é mais barato que reconstruir.
- **Quem escreve:** o hook (medido) e o script (a tabela). A sessão roda o script e grava só a linha de sessão. Um escritor por linha; o registro continua do SM.
- **Linha do `operator`.** Papel `operator`; modelo servido; Task/História do prompt dele (o chamador põe o ID no pedido — `agents/operator.md`); Nota `chamado por <papel>`. A seção "Execução delegada" dos relatórios continua como **índice dos jobs** (caminho e Task) — os números dela deixam de ser fonte.
- **Identificação do job (R28).** O job de uma Task vive em `operator/<n>/<T-ID>[-<slug>]/`; mais de uma chamada na mesma pasta grava `report-<log>.md`. O C1 conta, **por Task**, os `report*.md` dessas pastas e os citados no plano e na evidência × as linhas `operator` daquela Task (v3.45 — antes era o sprint inteiro, e uma divergência reprovava todo fechamento seguinte).
- **Jobs `pre-sprint/` (R28).** Job de `.team-project/operator/pre-sprint/<job>/` roda sem sprint aberto: a linha vai para `.team-project/consumption.md` (destino 3), Nota `pre-sprint;`.
- **Invocações do `/sm sprint prepare` e do `/sm sdd`.** Rodam com o sprint anterior já fechado: destino 3, `.team-project/consumption.md`, Nota `entre-sprints;` (ou `pre-sprint;`). O `consumption.md` do sprint novo nasce vazio.- **Premissa (R7) — `operator`.** Cada subagente tem transcript próprio: a linha do papel **não inclui** o do `operator` aninhado, e as duas se somam (o hook mede cada uma no seu transcript).
- **Premissa (R7) — linha de sessão (outra premissa, distinta da do `operator`).** A linha de sessão (Papel `sessão`, Modelo `vários`) vem do `/usage` que o stakeholder cola no fim da sessão de trabalho; a sessão grava **uma** linha: Tokens por modelo (entrada · saída · cache) e, na Nota, o **custo em US$ do `/usage`** — o único custo em US$ **observado**; custo derivado só na retrospectiva, com a fórmula e o preço ao lado, nunca no registro como se medido. **Não se sabe se o `/usage` já inclui os subagentes.** Até a verificação no projeto-piloto, a linha de sessão **não se soma** às linhas por invocação — é lida **à parte**, nunca no Total do sprint. **Verificação pendente:** um `/po status` com `/usage` antes e depois, comparado com a linha do PO; o resultado volta ao `/review`, que fixa a regra (se incluir os subagentes, as linhas por invocação viram detalhamento; se não, as duas se somam).
- **Categoria é classificação pela tabela, nunca estimativa.** Valores: `especificação` (brainstorm, sdd, story, requirement, prototype, screen) · `produção` (arc plan, dev) · `verificação` (qa, operator) · `retrabalho` · `cerimônia` (board, close, prepare, plan, review, retro, agreement, onboarding, `po note`/`po bug`). As invocações da trilha `fix` têm tabela própria na "Variante bloco". Quem preenche é o `consumption.ps1`, pela regra mecânica: **`retrabalho`** = rodada de Arquiteto, dev ou QA sobre uma Task que é **retomada** (`#2` em diante — retomada é resposta de 🔺 GAP ou volta de veredito), **QA depois de outro QA** da mesma Task (nova rodada de veredito), ou **Arquiteto ou dev depois de um QA** da mesma Task, ou **Arquiteto depois do dev** da mesma Task (resposta de GAP em instância nova). O resto recebe a categoria do papel: arc e dev `produção`, qa e operator `verificação`, sm `cerimônia`, po e ux `especificação`. Erro da regra se comenta na retrospectiva. **Unidade** = `H-<nnn>` · `F-<nnn>` (uma Correção da trilha `fix`) · `B-<nnn>` (o bloco inteiro — custo compartilhado entre as Correções dele, não rateado: o custo por Correção fechada é Σ ÷ F-IDs fechadas) · `sprint-<n>` (custo compartilhado; cerimônia de sprint não é de uma História — a retrospectiva a ratea em partes iguais entre as Histórias aceitas, declarando o rateio). Linha antiga sem Categoria/Unidade fica vazia — não se reconstrói o passado (sprint fechado é imutável). Sem Categoria/Unidade, "Custo × resultado" da retrospectiva diz "não disponível — <motivo>".
- **Nasce e morre no sprint.** Arquivo novo a cada `/sm sprint plan`, fechado a cada `/sm sprint close`. Nada é movido, nada é zerado: a pasta do sprint já é a unidade de retenção (§1c).
- **O acumulado é derivado, não mantido.** "Quanto o time custou até aqui" se responde somando os `sprints/*/consumption.md`, na hora da pergunta — em vez de uma tabela viva que precisa ser conciliada a cada fechamento e que deriva em silêncio quando alguém esquece.
