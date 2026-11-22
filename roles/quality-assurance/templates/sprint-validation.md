# Template — Validação do sprint (portão do QA, v3.51 · por marcos desde a v3.63.0)

Salvo em `.team-project/sprints/<n>/validation.md`. É o **portão de validação do produto entregue pelo dev**, uma passada só no fim da construção e **premissa da Sprint Review** (`sprint-run.md` §Validação do sprint). Substitui a verificação do QA Task a Task: as Tasks fecharam pela evidência do dev (verify, mutação e os cenários da Task no alvo — `close.ps1`, R7-aceite).

**O QA não roda comando longo** (o cache da instância dele dura 5 min): as medições chegam prontas do `operator` — `scripts/checks/quality.ps1 -Id S<n>` e `scripts/checks/accept.ps1 -Task S<n> -Resume` (todos os cenários do sprint, no alvo real, com captura de cada um). O QA lê, confere e julga.

**A prova da rodada fica guardada (v3.63.0).** Antes de cada rodada, o `run.ps1` copia o resultado e as capturas da medição para `.team-project/sprints/<n>/proof/S<n>/round-<k>/` (`quality/` e `accept/`, sem os logs brutos). **Cite a prova por esses caminhos**: a pasta `accept/<n>/S<n>/` é sobrescrita na rodada seguinte, e a prova citada sumiria.

**O que o script lê deste arquivo (v3.63.0):** a última linha `**Veredito…:**`, a tabela `## Frentes` e a tabela `## Achados` — os nomes das colunas e os valores de **Front**, **State** e **Cause** são fixos, em inglês. O resto é texto para pessoas.

```markdown
# Validação do sprint <n>

**Veredito:** ✅ aprovado | ⚠️ aprovado com ressalva | ❌ reprovado — <aaaa-mm-dd hh:mm>
**Prova:** `.team-project/sprints/<n>/proof/S<n>/round-1/` · **Rodada:** 1
<!-- Só a sessão escreve, copiando a resposta do PO no formulário, e só com veredito ⚠️ (nunca com ❌); ausente por padrão, e com ela o ⚠️ conta como portão passado: `**Decisão do PO:** aceito com dívida — <motivo e onde a dívida está registrada>` -->

## Frentes

| Front | State | Round | Proof |
|---|---|---|---|
| functional | pass · fail | 1 | `proof/S<n>/round-1/accept/result.md` |
| measured | pass · fail | 1 | `proof/S<n>/round-1/quality/result.md` |
| review | pass · fail | 1 | — |
| security | pass · fail | 1 | — |

## 1. Funcional — prova no alvo real

`proof/S<n>/round-1/accept/result.md` — <passaram> de <total> cenários, alvo <android|web>, <data>.

| Cenário | História | Resultado | Prova (captura) | Observação |
|---|---|---|---|---|
| SC-<nnn> | H-<nnn> | ✅ / ❌ | `proof/S<n>/round-1/accept/shots/SC-<nnn>-final.png` | <o que a captura mostra, quando conta> |

*(O aceite que parou no ambiente não chega a você: o `run.ps1` repara o alvo e repete (v3.63.0). Se ainda assim um cenário não foi exercitado, é achado de causa `environment` — nunca aprovação.)*

## 2. Qualidade de código — medida

`proof/S<n>/round-1/quality/result.md`

| Regra (standards nível 1, §7) | Resultado | Número |
|---|---|---|
| Q11 cobertura ≥ limiar em cada módulo | ok / falhou / não configurado | <pior módulo × limiar> |
| Q1 regra de dependência | | |
| Q6 limites numéricos | | |
| Q7 lint e formatação | | |
| Q8 duplicação | | |
| Q9 TODO com ID | | |
| Q17 supressão justificada | | |

## 3. Qualidade de código — julgamento

O que a ferramenta não mede, com `arquivo:linha` e a seção de `standards/` que embasa (o perfil da tecnologia em `standards/stacks/<tecnologia>/`):

| Frente | Resultado | Achados |
|---|---|---|
| SOLID e responsabilidade única | ✅ / ⚠️ / ❌ | |
| Clean code (nomes, funções, corpo — §4.1 a §4.3) | | |
| Aderência à arquitetura do SDD e aos planos (diff × **Arquivos tocados:**) | | |
| Padrões de escrita da tecnologia | | |
| Segurança (`implementation-security-lgpd-copyright.md`, checklist do projeto) | | |
| Testes que protegem algo (§5.2) — amostra | | |

## Achados

| ID | Task | Achado | Onde | Cause | Owner | State |
|---|---|---|---|---|---|---|
| S<n>-F1 | T-<nnn> | <o que está errado e o que o standard, a tela ou o critério pede> | `arquivo:linha` ou a captura | code · design · scenario · screen · requirement · environment | dev · Arquiteto · QA · UX · PO · operator | open |

*(A consolidação dos documentos vivos (R12) é do Arquiteto, depois do veredito ✅, em `.team-project/sprints/<n>/docs-consolidation.md` — A5.)*

---

## Rodada 2

| ID | Task | Achado | Onde | Cause | Owner | State | Evidência |
|---|---|---|---|---|---|---|---|
| S<n>-F1 | <T-ID> | <o achado> | <arquivo:linha ou tela> | code · design · scenario · screen · requirement · environment | <dono> | fixed · open · debt · wontfix | <o que mudou e onde está a prova> |

*(v3.64.0: a tabela da rodada é a mesma dos achados — a causa na coluna Cause, nunca dentro do ID; o `run.ps1 next` só lê achado com `S<n>-F<k>` no ID e a causa na coluna. `validation.md` anterior à v3.63.0, sem a coluna Cause: reescreva aqui cada achado antigo ainda aberto, com ID novo e uma causa.)*

**Veredito (rodada 2):** ✅ | ⚠️ | ❌ — <aaaa-mm-dd hh:mm>
```

## A causa decide o dono (v3.63.0)

Cada achado tem **uma** causa. É ela que decide quem resolve, e o `run.ps1 next` encaminha nesta ordem (decisão de produto e de tela antes, porque muda o que o dev vai corrigir):

| Cause | Quando | Quem resolve | O que acontece |
|---|---|---|---|
| `requirement` | critério ambíguo, regras em conflito, mudança de escopo | PO | decide; o que for do stakeholder ele leva em formulário; depois pode virar `code` |
| `screen` | estado, layout ou fluxo que a especificação da tela não previa; usabilidade | UX | acrescenta o caso na especificação; com código a mudar, vira `code` |
| `design` | o plano está errado, incompleto ou inexequível | Arquiteto | decide (`architect/decisions/S<n>.md`); o código vai na `Q-S<n>` |
| `scenario` | o `.scn` está errado ou desatualizado | QA (instância nova) | corrige só o cenário; o operator mede de novo só ele; **sem Task de dev** |
| `code` | o app não faz o que a especificação diz | dev | Task `Q-S<n>` que cita os IDs dos achados |
| `environment` | alvo, massa de dados, configuração; e a **prova que não vale** (v3.65.11): o app do aceite não é o que a correção provou, ou a medição é de antes da correção — escreva "prova velha" no Achado | operator ou stakeholder | reparo e nova medição; **nunca** `Q-S<n>` |

Exemplo: o título de um canteiro corta na fonte grande porque a tela não previa esse caso → `screen`. O UX acrescenta o caso na especificação da tela e responde `code`; aí a `Q-S<n>` corrige o app. Antes, o achado ia direto ao dev, e a especificação continuava sem o caso.

**Resolução do dono:** cada dono grava `.team-project/sprints/<n>/gate/<ID>.md` com a linha `**Resolution:** done | code | debt — <o que decidiu ou mudou>` (`debt` só o PO). É por ela que o `run.ps1` sabe que pode seguir para a próxima causa.

- **A resolução vale até a rodada seguinte (v3.65.5).** Se a rodada nova mantém o achado `open`, a resolução gravada antes dela não se sustentou, e o achado volta ao dono com ela no prompt, para corrigir de outro jeito. Duas tentativas sem resolver levam ao stakeholder.
- **Correção em duas partes.** Quando o app muda (`code`) e o `.scn` precisa mudar depois, o dono acrescenta `**Scenario:** <os SC e o que muda em cada um>`. Fechada a `Q-S<n>`, o `run.ps1` manda o QA aplicar essa parte **antes** da rodada nova. O QA edita só os cenários citados, roda `accept.ps1 -ParseOnly` e acrescenta `**Scenario applied:** <data> — <o que mudou>`, sem apagar a `**Resolution:**`. Sem a linha `**Scenario:**`, conta o texto da resolução que manda o QA mexer num `SC-<n>` ou num `.scn`.
- **Sem mudança, sem rodada.** A `Q-S<n>` fechada só pede rodada nova uma vez. Achado `code` que segue aberto depois da rodada que já a julgou pede correção nova, e o QA não julga de novo o mesmo app com o mesmo `.scn`.

## Regras

- **Uma passada, o incremento inteiro, na rodada 1.** O QA olha o todo, não Task a Task; o diff do sprint e os planos são a base da aderência.
- **Rodada nova é focada (v3.63.0).** O prompt diz quais frentes julgar e quais ficam como estavam (a base delas — a árvore de produção ou o conjunto de cenários — não mudou). **Não reabra a frente que o prompt manda manter**; julgue as frentes vencidas e os achados abertos e acrescente a seção `## Rodada <k>`.
- **Achado tem endereço:** `arquivo:linha`, captura ou saída de comando, a regra (`Q<n>`, a seção ou o critério) e **uma causa da lista**. Causa fora da lista volta para você só classificar.
- **ID do achado:** `S<n>-F<k>`, numerado em ordem e **nunca reaproveitado** entre rodadas (o achado novo da rodada 2 ganha o próximo número). O consumo do sprint e o quadro usam o ID.
- **Linha do veredito:** o `run.ps1` lê o marcador `**Veredito…:**` — `**Veredito:**` na primeira rodada, `**Veredito (rodada 2):**` nas seguintes — e **vale a última ocorrência do arquivo**; a marca ✅/⚠️/❌ vem logo depois dos dois-pontos.
- **⚠️ aprovado com ressalva** só com o achado aceito pelo PO como dívida, com Task no backlog. A aceitação fica na linha `**Decisão do PO:** aceito com dívida — <motivo e onde a dívida está registrada>`, **escrita pela sessão** com a resposta do PO no formulário (o QA não a escreve nem a presume); com ela, o ⚠️ passa o portão. **❌ nunca passa por essa linha:** reprovado volta pelas rotas da causa.
- **Formato anterior à v3.63.0** (tabela com "Volta para", sem `Cause`): o `run.ps1` segue o caminho de antes — `Q-S<n>` pelos achados "Volta para: dev". Use o formato novo nos sprints novos.
- **A Review só abre com ✅ ou ⚠️** e com a consolidação dos documentos vivos feita (`docs-consolidation.md`, **Estado:** feita).
