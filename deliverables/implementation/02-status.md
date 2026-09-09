# Modelo — `02-status.md`

> **Dono:** SM · **Muda quando:** uma Task é fechado ou um ciclo termina · **Revisa:** QA (na auditoria cruzada)

É a **memória viva de progresso e decisões**. O documento que permite alguém retomar o projeto meses depois e entender não só o que foi feito, mas por quê foi feito assim.

## Estrutura

```markdown
# STATUS — Progresso de Implementação

**Última atualização:** <data>
**Especificação de referência:** <versão do SDD>
**Ciclo atual:** <nome> — <situação, em 1-3 frases, com a evidência principal>

## Resumo executivo

| Métrica | Valor |
|---|---|
| Ciclos concluídos | <n> de <m> |
| Requisitos implementados | <n> de <m> — **confirmados ponta a ponta** |
| Critérios de sucesso atingidos | <n> de <m> — com evidência registrada |
| Decisões formalizadas | <n> de <m> |

## Progresso por ciclo

| Ciclo | Escopo | Status | Observações |
|---|---|---|---|
| <n> | <o que entrega> | ⬜/🟨/✅/🔴 | <evidência + desvios relevantes> |

Legenda: ⬜ Não iniciado · 🟨 Em andamento · ✅ Concluído · 🔴 Bloqueado

## Decisões tomadas (fora da especificação)

- **<data> — <ID> (<título>) concluído.** <o que passou a funcionar>
  - **Evidência:** <comando → saída real>
  - **Decisões:** <cada uma, com justificativa — ou "nenhuma">
  - **Pendência conscientemente adiada:** <o que ficou de fora e por quê>
  - **Não exercitado:** <o que não pôde ser validado e o motivo>

## Pendências / Bloqueios conhecidos
<O que trava, quem destrava, desde quando. Aponta para `pending.md` quando for GAP catalogado.>

## Como atualizar
1. Ao fechar uma Task (`/sm close <ID>`), adicionar a entrada de decisão correspondente.
2. Ao concluir um ciclo, atualizar a tabela de progresso e o resumo executivo.
3. Decisão fora da especificação é registrada **antes** de codificar, não depois.
```

O formato de cada entrada individual está em [`../../roles/scrum-master/templates/status-entry.md`](../../roles/scrum-master/templates/status-entry.md).

## Regras

- **Evidência antes de narrativa.** "Concluído" sem saída de comando não vale (R7).
- **Nunca reescrever entrada antiga.** É histórico; correção vira entrada nova com a data de hoje.
- **"Confirmado ponta a ponta" ≠ "implementado".** O resumo executivo deve distinguir os dois — é onde o status infla sem que ninguém perceba.
- **Decisão fora da especificação é registrada antes de codificar** (R6). Registrada depois, já perdeu a alternativa que foi descartada.
- **"Não exercitado" é obrigatório** em toda entrada onde algo não pôde ser validado. A ausência sistemática dessa linha é como um projeto acumula funcionalidade "pronta" que nunca rodou.
- **Se crescer demais**, resuma os ciclos antigos em uma linha e mantenha o detalhe só nos recentes — o documento é para ser lido.

## Falhas comuns

| Falha | Consequência |
|---|---|
| Narrativa otimista sem evidência | O documento passa a descrever a intenção, não o sistema |
| Decisão registrada só no código | Redescoberta e rediscutida meses depois |
| Resumo executivo contando "implementado" como "funcionando" | Todo o planejamento seguinte parte de uma base falsa |
| Entrada escrita em lote, dias depois | A justificativa já se perdeu; sobra o "o quê" sem o "porquê" |
