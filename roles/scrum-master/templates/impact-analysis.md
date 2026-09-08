# Template — Análise de Impacto (`/sm impact <mudança>`)

Usado antes de aceitar qualquer mudança de escopo, prioridade ou direção técnica. O SM **analisa e recomenda**; quem decide é o stakeholder.

```markdown
## Análise de Impacto — <mudança em uma frase> — <data>

**Pedido:** <o que foi pedido, literal>
**Origem:** <stakeholder | PO | Arquiteto | achado do QA>

### 1. O que isso toca
| Task em voo | Estado | Efeito |
|---|---|---|
| <ID> | <estado no quadro> | <continua / precisa replanejar / é invalidado> |

### 2. Retrabalho
- **Perdido:** <o que já feito deixa de valer, e quanto custou>
- **Aproveitável:** <o que se salva>

### 3. Contrato
- **API:** <endpoint/DTO afetado ou "nenhum">
- **Schema/migration:** <migration já aplicada é afetada? precisa de nova?>
- **Documentação:** <quais documentos e de quem são>

### 4. Prazo
| Bloco | Antes | Depois | Delta |
|---|---|---|---|

### 5. Risco
| Risco | Probabilidade | Impacto | Mitigação |
|---|---|---|---|

### 6. Recomendação
**<Aceitar agora | Aceitar depois de X | Não aceitar>** — <motivo em uma frase>

**Alternativa mais barata:** <se existir uma forma menor de atender ao mesmo objetivo>
**O que acontece se não decidir:** <custo de adiar a decisão>
```

## Regras

- Nunca aplicar a mudança nesta análise (R6: decisão de escopo é do stakeholder, e precisa ficar registrada).
- Sempre oferecer a alternativa mais barata que atende ao mesmo objetivo — é a informação que mais muda decisão.
- Impacto sem número (Tasks, arquivos, unidades de trabalho) é opinião. Contar.
- Mudança que toca contrato já implantado, baseline de escopo acordada ou mais de 3 Tasks em voo é conduzida como controle integrado de mudanças (R13 / [`../skills.md` §9](../skills.md)): solicitação numerada, aprovação registrada, baseline atualizada — não como ajuste informal.

## Exemplo

> **Pedido:** "antes de arrumar o download, quero ver a tela nova funcionando com dado real."
>
> **Toca:** os dois Tasks da frente de download (ainda sem plano) e o bloco seguinte inteiro.
> **Retrabalho:** nenhum — nada foi construído ainda.
> **Contrato:** exige a Task de proxy e o de autenticação antes, senão a tela recebe 401 em toda chamada.
> **Prazo:** a frente de download sai do 1º para o 2º lugar; o bloco de integração (5 unidades) passa à frente, sem alterar o total.
> **Risco:** ver dado real na tela sem o download funcionando dá sensação de progresso maior do que o real — o produto continua sem entregar arquivo.
> **Recomendação:** aceitar, **desde que** proxy e autenticação entrem juntos; a frente de download volta logo em seguida. Alternativa mais barata: rodar a tela contra o mock, sem custo, e manter a ordem original.
