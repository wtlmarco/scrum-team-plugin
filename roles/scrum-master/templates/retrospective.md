# Template — Retrospectiva (a cada 3 itens fechados)

Curta e acionável. Uma retrospectiva que não gera **uma** ação concreta foi tempo perdido.

```markdown
## Retrospectiva — itens <IDs> — <data>

### Métricas do período
| Indicador | Valor | Alerta | Regra |
|---|---|---|---|
| Gaps por plano | <n> | > 2 | R8 |
| Reprovações no QA | <n>/<total> | > 30% | R2/R8 |
| Itens reabertos | <n> | > 1 | R7 |
| Lead time × estimativa | <n>× | > 2× | R2 |
| Itens fechados sem evidência | <n> | qualquer | R7/R12 |
| Violações de escopo | <n> | recorrente | R4 |
| Lote/épico > 3× a unidade sem dimensionamento formal nem justificativa | <n> | qualquer | R13 |
| Projeto planejado sem registro de onboarding | <n> | qualquer | R14 |
| Requisito do SDD sem `brainstorm` nem `/po analyze` na origem | <n> | qualquer | R15 |
| Plano/veredito de engenharia sem citar a seção de `${CLAUDE_PLUGIN_ROOT}/standards/` aplicável | <n> | recorrente | R16 |
| Defeito em `${CLAUDE_PLUGIN_ROOT}/standards/` sem chegar ao `/arc review` seguinte | <n> | qualquer | R16 |
| Carga fixa dos documentos do processo (KB) — fase Check do PDCA (workflow §5c) | <atual> / <retro anterior> / <Δ> · causa se cresceu · ação: nenhuma \| corte candidato para `review metrics` | crescimento sem regra ou cerimônia nova; entrada de changelog > 10 KB | R17 |

### O que funcionou (3)
1. <fato observável, não sensação>

### O que corrigir (3)
1. <problema> → <regra violada ou ausente>

### Ação única do próximo ciclo
**<a mudança concreta>** — dono: <papel> — verificação: <como saberemos que pegou>

### Regras revisadas
- <nenhuma | R<n> ajustada porque ...>
```

## Regras

- No máximo **uma** ação por retrospectiva. Três ações = nenhuma ação.
- Todo "o que corrigir" aponta para uma regra de [`../working-rules.md`](../process/working-rules.md) — violada ou faltante. Se não aponta para nenhuma, ou é ruído, ou é regra nova a escrever.
- Métrica sem fonte não entra. As fontes são: relatórios do dev, `.team-project/quality-assurance/evidence.md` e o próprio quadro.
- A linha de footprint (KB) é a fase **Check** do ciclo de eficiência ([`../process/workflow.md` §5c](../process/workflow.md)): mede `agents/` + `commands/` + `roles/<papel>/` do processo, compara com a retrospectiva anterior e alimenta o giro de `/sm review metrics`. Crescimento sem regra ou cerimônia nova é candidato a corte, não a nota. Fonte: tamanho dos arquivos de `${CLAUDE_PLUGIN_ROOT}/`.

## Exemplo de leitura

> Gaps por plano em 4 (alerta > 2): o plano do Arquiteto está raso — nas duas vezes o dev parou por assinatura de método que o plano assumia e não existia no código.
> **Ação:** o passo 2 do Plano de Execução ("contexto de código a ler") passa a exigir que o Arquiteto cole a assinatura real do método, não só o caminho do arquivo. Verificação: gaps por plano ≤ 1 no próximo ciclo.
