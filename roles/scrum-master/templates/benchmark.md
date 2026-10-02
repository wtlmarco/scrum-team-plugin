# Template — Benchmark (`.team-project/benchmark/protocol.md` + `result.md`)

> **Dono:** SM (registro) · stakeholder (execução dos braços) · Vive em `.team-project/benchmark/` — **não semeada**; nasce quando o stakeholder abre o experimento. Local, fora do git (R31). Sob demanda: não faz parte de nenhum fluxo de sprint. Roteiro do experimento (passos, prompts fixos dos braços): [`rituals/benchmark.md`](../../../rituals/benchmark.md).

Responde uma pergunta só: **quanto da qualidade vem do plugin e quanto vem da especificação que ele produz?** A amostra é pequena — o resultado é **direcional, não estatístico**, e o relatório diz isso. A unidade de comparação é a **História aceita** ou a Correção fechada, nunca o sprint nem a Task.

**Braços** (mesmos itens, entradas diferentes):

| Braço | Como roda | O que isola |
|---|---|---|
| **A · Plugin** | o que já foi entregue pelo `sprint run` (custo do `consumption.md`; linhas de sessão lidas à parte) | — |
| **B · Claude direto, com a especificação** | sessão nova, **plugin desabilitado**, em worktree a partir do commit **anterior** à entrega; entrada = História detalhada, critérios de aceite, protótipo e trecho do SDD | **A × B** = valor do **pipeline** |
| **C · Claude direto, só com o pedido** | igual ao B, com **o pedido original** do stakeholder como ele o escreveu | **B × C** = valor da **especificação** |
| **B′ · B + guarda-corpos** *(opcional)* | igual ao B, com `CLAUDE.md` dos standards, hooks de build/teste e revisor independente no fim. **Habilitado quando a proposta `guards` estiver aplicada** — até lá, não roda | se B′ ≈ A, o mesmo resultado sai mais barato sem o pipeline |

**Avaliação cega, igual para todos os braços:** (1) cenários `SC-nnn` da História, novos e regressivos, executados pelo `operator` em cada worktree; (2) revisão independente do diff por agente que **não sabe** o braço (diffs renomeados X, Y, Z), pelo mesmo prompt; (3) métricas mecânicas — linhas alteradas, testes adicionados, avisos de build, cobertura do módulo. **Defeito** = cenário falho + achado da revisão cega.

```markdown
# Benchmark — <projeto> · <data>

## Pergunta
<a pergunta, uma frase>

## Itens (3–5)
<!-- ID · tamanho (Correção · pequena · média · grande) · por que foi escolhido · commit-base -->

## Braços
<!-- A · B · C · (B′, só se `guards` aplicada) — entrada exata de cada um -->

## Regra de decisão — **DATADA <aaaa-mm-dd>, antes da 1ª execução**
<!-- Os valores abaixo são o padrão do modelo. O stakeholder os confirma ou troca AQUI, e a data fecha o campo: limiar alterado depois de qualquer resultado invalida a leitura. -->

| Resultado | Leitura | Ação |
|---|---|---|
| A tem **≥ 50% menos** defeitos que B **e** custo **≤ 3×** o de B | o pipeline compensa | manter; seguir cortando cerimônia pelos dados da Camada 1 (Categoria × Unidade) |
| A ≈ B em defeitos (diferença **< 25%**) | o valor está na **especificação**, não no pipeline | simplificar o pipeline de execução; testar B′ como trilha |
| B ≈ C | nem a especificação muda o resultado **nesse tipo de item** | rever o custo de brainstorm/SDD para itens desse tamanho |
| A **pior** que B em qualquer item | achado de processo | `/review` com o caso concreto |
| **Inconclusivo → ampliar a amostra** — diferença de defeitos entre 25% e 50%, **ou** ganho ≥ 50% com custo acima de 3× (faixas que nenhuma linha acima cobre) | sem leitura | mais itens; não decidir |

**Diferença mínima:** só se lê "compensa" ou "pior" com **pelo menos 3 defeitos de diferença no total** entre os braços comparados. Abaixo disso, **inconclusivo → ampliar a amostra**, qualquer que seja o percentual.
**Limiares:** 50% · 3× · 25% · 3 defeitos — <padrão mantido | trocados por: …>, confirmados em <aaaa-mm-dd>.

## Resultados por item
<!-- braço · custo US$ (/usage do fim da sessão) · tokens · duração de relógio · cenários ok/falhou · achados da revisão cega · toques no stakeholder (cada pergunta respondida conta) -->

## Leitura
<!-- pela regra de decisão acima, sem reinterpretar os limiares -->

## Limites
<!-- amostra, viés de ordem, o que não foi exercitado, custo do próprio experimento (gravado como `cerimônia` / Unidade `benchmark`) -->
```

## Regras

- **Regra de decisão antes de medir.** `protocol.md` leva a data da regra **antes** da primeira execução; `result.md` lê por ela, sem alterar limiar depois. Sem isso, qualquer resultado parece confirmar o que já se acreditava.
- **Número indisponível:** "não disponível — <motivo>" (R7). Custo em US$ é o do `/usage` (observado); derivado só com fórmula e preço ao lado.
- **Amostra:** 3 a 5 itens já aceitos e com evidência, de tamanhos diferentes. Resultado direcional.
- **Pasta:** `protocol.md` e `result.md` (SM) · `orientation-<versão>.md` (SM, sonda de orientação por papel) · `<item>/<braço>/` (stakeholder executa, SM registra: `/usage` colado, saída dos cenários, revisão cega, métricas).
