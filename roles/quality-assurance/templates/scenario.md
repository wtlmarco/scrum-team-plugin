# Template — Cenário de Teste Funcional e Regressivo (`SC-nnn`)

> **Dono:** QA · **Nasce:** na Planning Meeting, ao quebrar a História em Tasks (`workflow.md` §5e passo 4 · R30) · **Vive em:** `.team-project/quality-assurance/scenarios/SC-nnn-<slug>.md`, indexado por [`scenarios-index.md`](scenarios-index.md) (`scenarios/README.md` no projeto)
>
> O cenário **opera** o critério de aceite como caso executável — **não é requisito novo**. O QA não decide nem reescreve regra funcional; dúvida sobre a regra escala ao PO pela escada já existente (R9 · `workflow.md` §6b), sem redeclará-la aqui. Um arquivo por cenário; o Sprint Backlog e a Task carregam só a **referência** (lista de IDs), nunca uma cópia do conteúdo (`artifact-ownership.md` §1e).

## Estrutura

```markdown
# SC-<nnn> — <título afirmativo do que o cenário prova>

**Tipo:** novo | regressivo · **Origem:** H-<nnn>, critério #<n> · **Mapeado em:** <data> · **Task de origem:** T-<nnn>
**Telas do protótipo:** `.team-project/user-experience/screens/<arquivo>.md` <ou "não se aplica — sem interface">
**Fluxos que toca:** <lista curta — o(s) fluxo(s) funcional(is) de `02-flows-and-roles` ou a jornada do UX que este cenário exercita; é a chave que outra Task usa para saber que este cenário é regressivo aplicável a ela>
**Forma de execução:** manual | navegador (MCP Chrome) | script/CLI

## Pré-condição
<Estado do sistema/dado necessário antes do primeiro passo — usuário, permissão, registro existente.>

## Passos
| # | Ação | Dado usado |
|---|---|---|
| 1 | <o que fazer> | <valor concreto, não "um valor qualquer"> |

## Resultado esperado
<O que precisa ser verdade ao final — na mesma linguagem verificável do critério de aceite de origem (R7). Nunca "funciona corretamente".>

## Critério de aceite de origem
> `H-<nnn>` — critério #<n>: <cole o texto exato do critério, não parafraseie — nomenclatura é contrato (R10)>

## Histórico de execuções
| Data | Task/Sprint | Resultado | Forma | Evidência |
|---|---|---|---|---|
| <data> | T-<nnn> / sprint <n> | ✅ passou / ❌ falhou / ⚠️ não executado — <motivo> | manual / navegador / script | <trecho decisivo + ponteiro do log, ou o que faltou> |
```

## Tipo — novo × regressivo

| | **Novo** | **Regressivo** |
|---|---|---|
| Nasce de | O(s) critério(s) de aceite da própria Task, na Planning | Um cenário **já existente** na suíte, cujo "Fluxos que toca" a Task impacta |
| Como escolher | Direto — um cenário por critério de aceite verificável da Task (ou mais, se o critério tiver mais de um caminho relevante) | Ver seção "Como escolher regressivos" abaixo |
| Primeira execução | No veredito da própria Task | Pode já ter histórico de execuções de Tasks anteriores — a Task atual só acrescenta uma linha |

**Um cenário nunca nasce dono de duas Tasks.** "Origem" e "Task de origem" ficam com quem o criou; Tasks seguintes que o reutilizam como regressivo não reescrevem essas linhas — só acrescentam ao Histórico de execuções.

## Como escolher regressivos — pelo impacto da Task no fluxo funcional

1. **Nomear o(s) fluxo(s) que a Task toca**, a partir do critério de aceite e do diff esperado (camada, tela, endpoint, regra) — a mesma lista que a frente 2 do veredito já produz para achar a seção de `standards/` aplicável (`skills.md` §10, passo 1), aqui aplicada ao fluxo funcional em vez de à área de engenharia.
2. **Buscar na suíte acumulada** (índice de `scenarios-index.md`) todo cenário cujo campo "Fluxos que toca" cruza com essa lista — é por isso que o campo existe e é obrigatório em todo cenário, novo ou regressivo.
3. **Cenário que toca o mesmo fluxo mas cujo passo específico a Task não altera** ainda entra como regressivo se o fluxo passa pelo código que a Task modifica — a pergunta é "esta mudança pode quebrar este caminho?", não "esta Task reescreve este passo?".
4. **Nenhum regressivo aplicável é um resultado válido**, nunca implícito: registrar "nenhum aplicável — <motivo>" na referência da Task no Sprint Backlog (R30, DoR).
5. **Task pequena e isolada** (ex.: ajuste de texto sem tocar lógica ou dado) tende a ter poucos ou nenhum regressivo; Task que altera camada compartilhada (autenticação, persistência, contrato de API consumido por mais de um fluxo) tende a puxar vários — o volume é sinal, não ruído: se a lista de regressivos de uma Task pequena está vazia, é esperado; se uma Task que toca camada compartilhada não puxou nenhum, vale reconferir o campo "Fluxos que toca" da suíte antes de aceitar "nenhum aplicável".

## Forma de execução

| Forma | Quando usar | Registro |
|---|---|---|
| **Manual** | Passo a passo conduzido por uma pessoa, quando não há script nem ferramenta de navegador disponível | Quem executou, data, resultado — sem trecho de comando, porque não houve um |
| **Navegador (`mcp__claude-in-chrome`)** | Cenário de interface, **condicional à extensão estar conectada na sessão que executa** — o card do QA (isolado) e o do `operator` (grupo/suíte, R28) já carregam a ferramenta | Trecho decisivo da interação (URL, elemento, resposta observada) + ponteiro, quando a extensão estiver conectada |
| **Script/CLI** | Cenário automatizável por comando (chamada de API, seed + asserção, teste E2E já existente que cobre o mesmo caminho) | Comando + saída real (R7); pesado ou em lote segue R28 (`operator`) |

**Sem a extensão conectada, cenário de interface não é fingido como executado.** Duas saídas honestas: **(a)** roda por script/CLI quando o caminho puder ser exercitado por chamada direta (API por trás da tela, seed de dado + asserção de estado); **(b)** fica registrado como **⚠️ "não executado — sem ferramenta"** no Histórico de execuções e no veredito — verificável (a extensão não estava conectada naquela sessão), nunca uma alegação de que "a tela foi conferida".

## Regras

- **ID `SC-nnn`, nunca reaproveitado** (`artifact-ownership.md` §4).
- **Um arquivo por cenário.** Nada de agrupar vários cenários num arquivo só — quebra a referência por ID que a Task carrega.
- **"Fluxos que toca" é obrigatório e é a chave de busca do regressivo** — cenário sem esse campo preenchido não pode ser encontrado por Task nenhuma no futuro, e a suíte perde a razão de existir.
- **Resultado esperado na linguagem do critério de aceite**, verificável — nunca "funciona", "ok", "sem erro visível".
- **Histórico de execuções acumula, nunca substitui** — cada execução (mesmo que repita o mesmo resultado) é uma linha nova; é o que permite ver se um cenário regressivo começou a falhar depois de sempre ter passado.
- **Cenário não é requisito.** Divergência entre o cenário e o critério de aceite de origem não se resolve editando o critério aqui — volta ao PO (R9).

## Exemplo

```markdown
# SC-014 — Exportação com filtro aplicado traz só as linhas filtradas

**Tipo:** novo · **Origem:** H-014, critério #1 · **Mapeado em:** 02/09/2026 · **Task de origem:** T-041
**Telas do protótipo:** `.team-project/user-experience/screens/export-modal.md`
**Fluxos que toca:** exportação de análise · filtro de região
**Forma de execução:** script/CLI

## Pré-condição
Usuário "analista.norte" autenticado, com ao menos 3 registros na região "sul" e 2 na região "norte".

## Passos
| # | Ação | Dado usado |
|---|---|---|
| 1 | Aplicar filtro região = "sul" na tela de análise | região: sul |
| 2 | Acionar exportação | — |
| 3 | Abrir o arquivo exportado | — |

## Resultado esperado
O arquivo contém exatamente as 3 linhas da região "sul", nenhuma da região "norte".

## Critério de aceite de origem
> H-014 — critério #1: Exportar com filtro aplicado traz só as linhas filtradas — verificar filtrando por "região sul", exportando, e conferindo a contagem contra a tela.

## Histórico de execuções
| Data | Task/Sprint | Resultado | Forma | Evidência |
|---|---|---|---|---|
| 03/09/2026 | T-041 / sprint 7 | ✅ passou | script/CLI | `pytest tests/export/test_filter.py -k regiao_sul` → `1 passed` |
```
