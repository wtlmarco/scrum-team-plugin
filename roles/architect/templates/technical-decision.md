# Template — Decisão Técnica (resposta a 🔺 GAP)

Resposta do Arquiteto quando o dev para e pergunta. Precisa ser **executável**: o dev retoma sem mais nenhuma escolha a fazer.

```markdown
## Decisão — <ID> · GAP do passo <n>

**Gap:** <o que o dev relatou, em uma linha>
**Verifiquei em:** <arquivo:linha — o código real, não a interpretação do relato>

### Decisão
<Uma frase afirmativa: o que fazer, com o nome e a assinatura concretos.>

```
<assinatura / trecho literal que o dev deve seguir>
```

### Por quê
<Uma ou duas frases. Se decorre de um padrão existente, cite o arquivo que serve de modelo.>

### Classificação
- [ ] **Erro do plano** → corrigir o passo <n> antes de o dev retomar
- [ ] **Lacuna da especificação** → registrar no documento de status, via SM
- [ ] **Decisão estrutural e recorrente** → vira ADR
- [ ] **Defeito no standard** (contradição, lacuna, regra inverificável em `${CLAUDE_PLUGIN_ROOT}/standards/`) → decidir agora para destravar o item **e** entrar na fila do próximo `/arc review` — R16
- [ ] **Dúvida funcional** → escalar ao PO, o dev fica parado neste passo

### O que o dev faz agora
1. <ação concreta>
2. <retomar do passo n>
```

## Regras

- **Decidir, não devolver a pergunta** (R9). "Depende" não é resposta a um júnior parado.
- Ler o código citado antes de responder — o relato do dev pode estar certo pelo motivo errado.
- Classificar sempre: gap sem classificação vira decisão perdida (R6).
- Gap do mesmo tipo pela segunda vez = ajustar o **formato** do plano, não só responder de novo.
- **Gap que aponta defeito num standard destrava o item primeiro e corrige o normativo depois**, por `/arc review` — nunca editar `${CLAUDE_PLUGIN_ROOT}/standards/` no meio de um item, e nunca mandar o dev "ignorar a regra por enquanto" sem registro (R16).

## Exemplo

> **Gap:** o plano manda espelhar um componente que não declara autorização — devo adicionar?
> **Verifiquei em:** `GetOrderQuery.cs:12` — ele **declara** sim; o que não declara é `ListItemsQuery`, citado por engano no passo 4.
>
> **Decisão:** espelhar `GetOrderQuery` (que está correto). `ListItemsQuery` é um defeito já catalogado e **não** entra neste item.
>
> ```
> public sealed record GetXQuery(Guid Id) : IQuery<XDto>, IAuthorizableRequest
> {
>     public string PermissionKey => "recurso.ler";
> }
> ```
>
> **Por quê:** `recurso.ler` já existe no catálogo e já é usada pelo componente-modelo — não precisa de migration nova.
>
> **Classificação:** erro do plano — o passo 4 citava o arquivo errado como modelo. Plano corrigido.
> **O dev faz agora:** aplicar a assinatura acima e retomar do passo 4.
