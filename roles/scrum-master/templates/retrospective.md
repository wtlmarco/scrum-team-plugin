# Template — Sprint Retrospective (`/sm sprint close`)

Roda **depois da Sprint Review**, com o resultado dela à vista, e encerra o sprint. Curta e acionável: uma retrospectiva que não gera **uma** ação concreta foi tempo perdido.

```markdown
## Retrospectiva — Sprint <n> — <data>

**Objetivo do sprint:** <a frase declarada na Planning> — **atingido?** <sim | parcial | não>
**Histórias:** <n aceitas · n com ressalva · n rejeitadas · n não terminadas>
**Tasks:** <n fechadas de n planejadas> · **Estimado × entregue:** <n> / <n> (<Δ%>)

### Métricas do sprint
| Indicador | Valor | Alerta | Regra |
|---|---|---|---|
| Gaps por plano | <n> | > 2 | R8 |
| Reprovações no QA | <n>/<total> | > 30% | R2/R8 |
| Tasks reabertas | <n> | > 1 | R7 |
| Lead time × estimativa | <n>× | > 2× | R2 |
| Tasks fechadas sem evidência | <n> | qualquer | R7/R12 |
| Violações de escopo (inclui entradas fora da Planning) | <n> | recorrente | R4 |
| Soma estimada × entregue no sprint | <Δ%> | > 25% dois sprints seguidos | §5e |
| História > 3× a unidade sem dimensionamento formal nem justificativa | <n> | qualquer | R13 |
| Projeto planejado sem registro de onboarding | <n> | qualquer | R14 |
| Requisito do SDD sem `brainstorm` nem `/po analyze`; `03`/`04`/`05` antes do portão ①; História antes do portão ② | <n> | qualquer | R15 |
| Task sem História de origem, ou História na Planning sem o portão ③ | <n> | qualquer | R20 |
| Detalhamento de História com decisão técnica (arquivo, classe, endpoint, dados) | <n> | qualquer | R20 |
| História aceita fora da Sprint Review, ou aceite mirando uma Task | <n> | qualquer | R21 |
| Plano/veredito de engenharia sem citar a seção de `${CLAUDE_PLUGIN_ROOT}/standards/` aplicável | <n> | recorrente | R16 |
| Defeito em `${CLAUDE_PLUGIN_ROOT}/standards/` sem chegar ao `/review` seguinte | <n> | qualquer | R16 |
| **Carga fixa** por invocação (KB) — `agents/` + `commands/` — fase Check do PDCA (workflow §5c) | <atual> / <retro anterior> / <Δ> · causa se cresceu · ação: nenhuma \| corte candidato para `/review metrics` | crescimento sem regra ou cerimônia nova | §5c |
| **Conjunto sob demanda** (KB) — `roles/<papel>/` **sem os changelogs** | <atual> / <retro anterior> / <Δ> | idem | §5c |
| Entrada de changelog acima do teto | maior bloco `## vX.Y` de `process-changelog.md` | > 10 KB | R17 |
| Entrega sem bump: merge em `main` sem `version` + entrada no `CHANGELOG.md`, ou `plugin.json` ≠ topo do `CHANGELOG.md`, ou entrada de `process-changelog.md` sem par — *só quando a retro roda sobre o repositório-fonte do plugin; num projeto consumidor, `n/a`* | <n> \| n/a | qualquer | R18 |
| Entrada de `process-changelog.md` sem bloco de evidência, ou com comando cuja reexecução dá saída diferente da registrada — *idem: só no repositório-fonte* | <n> \| n/a | qualquer | R19 |

### O que funcionou (3)
1. <fato observável, não sensação>

### O que corrigir (3)
1. <problema> → <regra violada ou ausente>

### Ação única do próximo sprint
**<a mudança concreta>** — dono: <papel> — verificação: <como saberemos que pegou>

### Regras revisadas
- <nenhuma | R<n> ajustada porque ...>

### Encerramento
- **Tasks não concluídas devolvidas ao Product Backlog, com a História:** <IDs, ou "nenhuma">
- **Ressalvas e débitos da Review registrados no Product Backlog:** <sim — com dono | nenhum>
```

## Regras

- **Roda depois da Sprint Review, nunca antes.** A retrospectiva olha o resultado do aceite; invertida, ela discute processo sem saber se o valor chegou.
- No máximo **uma** ação por retrospectiva. Três ações = nenhuma ação.
- Todo "o que corrigir" aponta para uma regra de [`../process/working-rules.md`](../process/working-rules.md) — violada ou faltante. Se não aponta para nenhuma, ou é ruído, ou é regra nova a escrever.
- Métrica sem fonte não entra. As fontes são: relatórios do dev, `.team-project/quality-assurance/evidence.md`, o Sprint Backlog e o registro de aceites da Review.
- **O sprint não encerra com pendência sem destino.** Task inacabada volta ao Product Backlog com a História (R5); ressalva da Review vira entrada com dono (R12 · R21).
- A linha de footprint (KB) é a fase **Check** do ciclo de eficiência ([`../process/workflow.md` §5c](../process/workflow.md)): mede `agents/` + `commands/` + `roles/<papel>/` do processo, compara com a retrospectiva anterior e alimenta o giro de `/review metrics`, que roda a cada 3 sprints. Crescimento sem regra ou cerimônia nova é candidato a corte, não a nota.

## Exemplo de leitura

> Gaps por plano em 4 (alerta > 2): o Plano de Implementação está raso — nas duas vezes o dev parou por assinatura de método que o plano assumia e não existia no código.
> **Ação:** o passo 2 do Plano de Implementação ("contexto de código a ler") passa a exigir que o Arquiteto cole a assinatura real do método, não só o caminho do arquivo. Verificação: gaps por plano ≤ 1 no próximo sprint.
