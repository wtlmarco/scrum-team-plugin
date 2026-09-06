# Template — Análise Funcional (`/po analyze <ideia>`)

Resposta do PO a uma ideia do stakeholder, antes de virar requisito.

```markdown
## Análise Funcional — <ideia em uma frase> — <data>

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

### 6. Escalação ao stakeholder
<Só quando há lacuna real de especificação. Até 3 opções, com recomendação e custo funcional de cada uma. Caso contrário: "nenhuma".>
```

## Regras

- Sempre separar **o pedido** do **problema por trás**. É onde nascem as soluções melhores e mais baratas.
- Negar sem alternativa é abdicar do papel: toda negativa vem com o caminho que atende ao mesmo problema.
- Não entrar em solução técnica — nem para elogiar, nem para descartar. Isso é `/arc`.
- Lacuna da especificação **nunca** é preenchida por conta própria (R9): vira escalação com opções.

## Exemplo

> **Pedido:** "quero que a plataforma gere também um formato de saída novo."
> **Problema por trás:** o usuário quer uma forma mais barata e rápida de testar o resultado antes de investir na produção completa.
> **Já existe:** a cadeia já produz os elementos visuais e o texto estruturado — a maior parte do insumo está pronta.
> **Menor forma útil:** montar os elementos já aprovados em um documento sequencial, sem geração de mídia nova. Um tipo de entrega novo, sem provedor novo.
> **Decisão:** Aprovado com ajuste — o formato simples agora; a versão animada fica fora, depende de uma frente de mídia nova.
> **Escalação:** nenhuma.
