# Template — Análise Funcional (`/po analyze`)

Análise do PO de um pedido do stakeholder classificado como **evolução** ou **capacidade nova** (v3.67.0). **Gravada** em `.team-project/product-owner/analysis/A-<nnn>-<slug>.md` quando aprovada — é o insumo do `/sm sprint prepare` e da Task do SDD do sprint. Negada, fica só a linha no `demand-log.md` (motivo e alternativa).

```markdown
# A-<nnn> — <pedido em uma frase>

**Data:** <aaaa-mm-dd> · **Classificação:** evolução | capacidade nova
**Origem:** <texto avulso | item do note.md de <data>>
**Pedido:** <literal, como veio>
**Problema do usuário por trás:** <a necessidade real, não o recurso pedido>

### 1. O que já existe
| Já atendido por | Cobre? | Observação |
|---|---|---|
| <requisito / fluxo> | total / parcial / não | <o que falta> |

### 2. Regra funcional proposta
<Como o produto deve se comportar, em prosa curta — sem solução técnica.>

### 3. Casos de borda
- <dado ausente> → <comportamento>
- <conflito com estado existente> → <comportamento>
- <recurso de outro escopo / conteúdo de terceiro> → <comportamento>

### 4. Impacto funcional
| Afeta | Como |
|---|---|
| <requisito> | <altera / estende / conflita> |
| <fluxo> | <onde entra na cadeia> |
| <critério de sucesso> | <muda a definição de atendido?> |

### 5. Decisão
**<Aprovado | Aprovado com ajuste | Negado>** — <motivo em uma frase>

<Se aprovado com ajuste: qual é a menor forma útil e por que ela basta agora.>
<Se negado: qual alternativa atende ao mesmo problema.>

**O que muda no SDD:** <seções e requisitos afetados (`00`/`01`/`02`) | "delta nulo — <motivo>"> — é o que a **Task do SDD** do sprint aplica. A parte técnica (`03`/`04`/`05`) não é sua: o Arquiteto a declara na varredura do `prepare` (Delta técnico, se estrutural).

### 6. Escalação ao stakeholder
<Só quando há lacuna real de especificação. Até 3 opções, com recomendação e custo funcional de cada uma (formulário R22). Caso contrário: "nenhuma".>

### 7. Requisito proposto
<No formato de `requirement.md`, com o RF-ID reservado (seguindo a numeração existente). Entra no `01-requirements` na Task do SDD — não antes.>

### 8. Histórias geradas
| História | Trecho do pedido que cobre |
|---|---|
| H-<nnn> | <...> |

### 9. Jornada (só capacidade nova)
<O mapa da jornada inteira do UX — os passos do usuário, por onde entra e sai, e o trecho que cada História cobre — ou o ponteiro do arquivo dele. Orienta o `prepare` de cada sprint; não tem portão.>
```

## Regras

- Sempre separar **o pedido** do **problema por trás**. É onde nascem as soluções melhores e mais baratas.
- Negar sem alternativa é abdicar do papel: toda negativa vem com o caminho que atende ao mesmo problema.
- Não entrar em solução técnica — nem para elogiar, nem para descartar. Isso é `/arc`.
- Lacuna da especificação **nunca** é preenchida por conta própria (R9): vira escalação com opções.
- **Uma análise por A-ID.** Várias Histórias podem nascer de uma análise; a análise não é copiada nelas — elas citam `A-<nnn>` na Origem.
- **A análise não altera o SDD.** O "O que muda no SDD" é o que a Task do SDD aplica no fim da História, depois do ✅ do QA.

## Exemplo

> **Pedido:** "quero que a plataforma exporte também em um formato novo."
> **Problema por trás:** o usuário quer uma forma mais barata e rápida de conferir o resultado antes de investir na versão completa.
> **Já existe:** a cadeia já produz os dados e o texto estruturado — a maior parte do insumo está pronta.
> **Menor forma útil:** montar os itens já aprovados em um documento simples, sem geração nova. Um tipo de entrega novo, sem dependência nova.
> **Decisão:** Aprovado com ajuste — o formato simples agora; a versão rica fica fora, depende de uma frente nova.
> **Escalação:** nenhuma.
