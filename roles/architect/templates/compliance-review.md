# Template — Revisão de Aderência (`/arc comply <ID>`)

Revisão de aderência **sob demanda** — **não é etapa do ciclo** ([`workflow.md`](../../scrum-master/process/workflow.md) §4a). Roda em um de dois momentos: **(a)** por iniciativa do Arquiteto, antes de entregar ao QA, quando a entrega é grande ou tocou muitos passos; **(b)** como rota de volta de achado de aderência de execução ⚠️/❌ do veredito, antes do `/dev resume`. Aponta desvio; **não corrige o código**.

**Objeto: o Plano de Implementação vigente** — cada passo foi executado como escrito, e a seção de standard **que o passo citou** está aplicada no código. O comply **não julga se o plano citou o conjunto certo e completo de seções**: isso é a frente 2 do `/qa <ID>` (§4a) — o autor não audita a própria omissão.

```markdown
## Revisão de Aderência — <ID> <título> — <data>

**Plano:** `.team-project/architect/plans/<ID>-<slug>.md` · **Relatório do dev:** <passos concluídos, n de m>

### 1. Plano × entrega
| Passo | Situação | Observação |
|---|---|---|
| <n> | ✅ conforme / ⚠️ divergente / ❌ não feito | <o que difere, com `arquivo:linha`> |

### 2. Padrão arquitetural
*(Escopo desta seção: o padrão aplicado ao que o plano mandou fazer. A última linha afere **a aplicação da seção
que o passo citou** — não se a citação estava completa ou correta para a Task; isso é da frente 2 do QA, §4a.)*

| Verificação | Resultado | Evidência |
|---|---|---|
| Regra de dependência entre anéis — domínio sem dependência externa | ok / falha | teste de arquitetura + <arquivo:linha> |
| Cada arquivo no anel que o plano declarou | ok / falha | <arquivo:linha> |
| Separação escrita/leitura: consulta não escreve, handler não chama handler | ok / falha / n/a | <arquivo:linha> |
| Nomenclatura idêntica ao SDD | ok / falha | <arquivo:linha> |
| Registro no ponto único de composição de dependências | ok / falha / n/a | <arquivo:linha> |
| Migration presente e com o nome previsto | ok / falha / n/a | <arquivo> |
| Erro/exceção nova mapeada para o status previsto | ok / falha / n/a | <arquivo:linha> |
| Isolamento de escopo (tenant/sub-recurso) preservado | ok / falha / n/a | <arquivo:linha ou teste> |
| Limites de código limpo: §4.4, sem código comentado, sem `TODO` sem ID, sem captura vazia | ok / falha | <arquivo:linha> |
| Testes do plano presentes e significativos | ok / falha | <arquivo:teste> |
| Gate de cobertura ≥ 80% com **saída real** no relatório | ok / falha | <trecho da saída> |
| **Seção de standard citada pelo passo aplicada de fato** no código entregue (R16) — *só a aplicação do que o plano citou* | ok / falha | <§ citada no passo × `arquivo:linha`> |

> Nomes de arquivo concretos (onde fica a composição de dependências, onde erros são mapeados) são do
> projeto — estão em `.team-project/architect/context.md`. Referência normativa das linhas acima:
> `${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §2, §3, §4, §5.

### 3. Escopo
**Fora do plano:** <o que foi tocado além do previsto — R4> (ou "nada")
**Não feito do plano:** <passos pendentes e por quê>

### 4. Veredito arquitetural
**<Liberado para o QA | Ajustar antes do QA>** — *na rota de volta (b), o veredito é
`<Desvio do veredito resolvido, seguir para /dev resume | Ajustes abaixo antes do /dev resume>`.*

| # | Ajuste necessário | Onde | Por quê |
|---|---|---|---|

### 5. Aprendizado para o próximo plano
<Se o dev levantou gaps, o que faltou no plano — R8/métrica de "gaps por plano".>

**Defeito de standard levantado nesta Task:** <🔺 GAP apontando contradição, lacuna ou regra inverificável em
`${CLAUDE_PLUGIN_ROOT}/standards/` — entra na fila do próximo `/review` (R16); ou "nenhum">
```

## Regras

- **Aplicação, não completude da citação.** Este modelo afere se a seção que o passo **citou** está no código. Plano que **omitiu** uma seção exigida pela Task, ou que **citou a errada**, é defeito que o autor do plano estruturalmente não vê — quem pega é a frente 2 do `/qa <ID>` ([`workflow.md`](../../scrum-master/process/workflow.md) §4a). Se eu mesmo perceber a omissão aqui, ela vai para a seção 5 como 🔺 GAP do próximo `/review`, nunca como linha da tabela da §2.
- Cada achado precisa de `arquivo:linha`. Sem isso é suspeita — e deve ser marcada como tal.
- **Não corrigir o código.** Ajuste volta ao dev com instrução concreta.
- Desvio de nomenclatura conta como falha, não como detalhe (R10).
- A seção 5 é o que faz o time melhorar: gap recorrente significa formato de plano a ajustar, não dev a corrigir.
