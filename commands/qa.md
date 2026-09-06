---
description: Aciona o QA — validação de requisito, aderência técnica, segurança, testes e documentação, com execução real de build/test/smoke.
argument-hint: "[<ID> | baseline | audit | security <ID>]"
---

Aciona o **QA** do time — o último portão antes do PO.

Pedido do stakeholder: **$ARGUMENTS**

Use a ferramenta Agent com `subagent_type: "quality-assurance"` e `run_in_background: false`, passando ao agente:

1. O pedido acima, literal.
2. A instrução de ler antes de validar: `.team-project/README.md`, `.team-project/quality-assurance/context.md` (comandos, limiares, checklist de segurança, limitações do ambiente), o plano em `.team-project/architect/plans/<ID>-*.md` (se existir), o relatório de entrega do dev, o critério de aceite do PO e o item no quadro do SM.
3. O modo de operação, conforme o pedido:
   - **`<ID>`** → validação completa nas seis frentes (requisito, especificação técnica, segurança, testes/métricas, documentação, desempenho), com **execução real** dos comandos e veredito no formato de `${CLAUDE_PLUGIN_ROOT}/roles/quality-assurance/templates/verdict.md`. Atualizar os documentos de qualidade indicados no contexto e `.team-project/quality-assurance/evidence.md`.
   - **baseline** → reproduzir no ambiente atual os números declarados na documentação do projeto (build, testes, cobertura, lint) e substituir os "⏳ a reproduzir" de `evidence.md` pela saída real. Divergência vira GAP novo, e o SM é avisado para corrigir o documento de status.
   - **audit** → auditoria cruzada em dois passes, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/quality-assurance/templates/cross-audit.md`: mapeamento (documentos entre si, só texto) e, nos pontos suspeitos, conteúdo contra o código. Só listar achados, sem corrigir.
   - **security `<ID>`** → foco na frente 3, percorrendo o checklist de segurança do `context.md` do projeto.
4. Lembrete de limites: o QA **reprova, não corrige** — não edita código, nem o documento de status (é do SM), nem a especificação. Todo achado precisa de `arquivo:linha` ou saída de comando; sem isso, é suspeita e deve ser marcada como tal. O que não pôde ser executado no ambiente é declarado como **não exercitado**, nunca omitido.

## Evolução dos documentos do QA — não é aqui

Os documentos de processo do QA (roteiro, as seis frentes, skills, modelos, os entregáveis que possui, o checklist de segurança e os limiares) evoluem pelo comando **`/review`**, que aciona o Agent `quality-assurance` conforme `${CLAUDE_PLUGIN_ROOT}/review-contract.md`. Não há mais `/qa review`. Pedido `/qa review …` → responda que o caminho é `/review …`.

Ao receber o veredito, repasse-o na íntegra ao stakeholder. Se for ✅, indique `/po accept <ID>` e depois `/sm close <ID>`. Se for ⚠️ ou ❌, indique para quem cada achado volta conforme a **escada de falha**: achado de aderência de execução → `/arc comply <ID>` (revisão sob demanda) ou `/dev resume <ID>`; achado de processo (seção de standard omitida ou errada no plano, defeito no próprio standard) → fila do **`/review`** (roteado ao Arquiteto). Nada disso antes do aceite.