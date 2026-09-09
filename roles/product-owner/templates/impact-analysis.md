# Template — Análise de Impacto (`/po impact <mudança>`)

Usado antes de aceitar qualquer mudança de escopo, prioridade ou direção. **É do PO porque o objeto é o plano de entrega** ([`workflow.md` §6a](../../scrum-master/process/workflow.md)). O PO **analisa e recomenda**; quem decide é o stakeholder.

> **Por que isto não contradiz o `/sm agreement`.** Ali o SM facilita porque há **disputa** e o PO seria **parte** (*"o requisito está errado ou a implementação está?"*). Aqui não há disputa: é a análise de uma mudança a um plano que **é do PO**. Reunir insumo técnico para informar a própria decisão não é arbitrar — é fazer o dever de casa antes de recomendar.

**Três insumos, com dono declarado.** O PO consolida; não inventa nenhum dos três:

| Seção | Insumo de | Por quê |
|---|---|---|
| 1. O que isso toca · 4. Prazo | **SM** — Sprint Backlog, capacidade, fila | Ele sabe o que está em voo e quanto cabe |
| 2. Retrabalho · 3. Contrato | **Arquiteto** | Contrato, migration e retrabalho são desenho técnico — o PO não decide "como" |
| 5. Risco · 6. Recomendação | **PO** | Valor, escopo e plano são dele |

```markdown
## Análise de Impacto — <mudança em uma frase> — <data>

**Pedido:** <o que foi pedido, literal>
**Origem:** <stakeholder | Arquiteto | UX | achado do QA>

### 1. O que isso toca *(insumo: SM)*
| Task em voo | História | Estado | Efeito |
|---|---|---|---|
| <T-ID> | <H-ID> | <estado no quadro> | <continua / precisa replanejar / é invalidado> |

### 2. Retrabalho *(insumo: Arquiteto)*
- **Perdido:** <o que já feito deixa de valer, e quanto custou>
- **Aproveitável:** <o que se salva>

### 3. Contrato *(insumo: Arquiteto)*
- **API:** <endpoint/DTO afetado ou "nenhum">
- **Schema/migration:** <migration já aplicada é afetada? precisa de nova?>
- **Documentação:** <quais documentos e de quem são>

### 4. Plano de entrega *(conta do SM, decisão do PO)*
| História | Sprint antes | Sprint depois | O que sai para caber |
|---|---|---|---|

**Compromisso externo afetado:** <data prometida a alguém de fora, ou "nenhum">

### 5. Risco
| Risco | Probabilidade | Impacto | Mitigação |
|---|---|---|---|

### 6. Recomendação do PO
**<Aceitar agora | Aceitar depois de X | Não aceitar>** — <motivo em uma frase>

**Alternativa mais barata:** <se existir uma forma menor de atender ao mesmo objetivo>
**O que acontece se não decidir:** <custo de adiar a decisão>
```

## Regras

- **Nunca aplicar a mudança nesta análise** (R6: decisão de escopo é do stakeholder, e precisa ficar registrada).
- **Não invente insumo técnico.** Contrato, migration e retrabalho vêm do Arquiteto (`/arc question`); Tasks em voo e capacidade, do SM. Análise que estima retrabalho sem o Arquiteto é opinião com aparência de número.
- **Não recalcule capacidade.** A conta é do SM; você decide o que entra e o que sai dela.
- Sempre oferecer a **alternativa mais barata** que atende ao mesmo objetivo — é a informação que mais muda decisão.
- **Impacto sem número** (Tasks, arquivos, unidades de trabalho, sprints deslocados) é opinião. Contar.
- **Controle integrado de mudanças:** quando a mudança toca contrato já implantado, a **baseline de escopo acordada** ou mais de 3 Tasks em voo, o **SM sinaliza o gatilho** — método é dele (R13 · [`../../scrum-master/skills.md` §9](../../scrum-master/skills.md)) — e **você conduz**: solicitação numerada, aprovação registrada, **baseline atualizada no plano de entrega**. Não como ajuste informal.
- **Toda História que desloca ganha motivo escrito** no plano de entrega. Deslocamento sem motivo é o que faz o plano perder credibilidade antes de perder a data.

## Exemplo

> **Pedido:** "antes de arrumar o download, quero ver a tela nova funcionando com dado real."
>
> **Toca** *(SM)*: as duas Tasks da História H-014 (ainda sem plano) e a História H-017 inteira.
> **Retrabalho** *(Arquiteto)*: nenhum — nada foi construído ainda.
> **Contrato** *(Arquiteto)*: exige a Task de proxy e a de autenticação antes, senão a tela recebe 401 em toda chamada.
> **Plano de entrega:** H-014 sai do sprint 7 para o 8; H-021 entra no 7 no lugar. Total do release não muda. Compromisso externo: nenhum.
> **Risco:** ver dado real na tela sem o download funcionando dá sensação de progresso maior do que o real — o produto continua sem entregar arquivo.
> **Recomendação:** aceitar, **desde que** proxy e autenticação entrem juntos; H-014 volta no sprint 8. Alternativa mais barata: rodar a tela contra o mock, sem custo, e manter a ordem original.
