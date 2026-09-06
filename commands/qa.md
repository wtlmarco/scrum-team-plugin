---
description: Aciona o QA — validação de requisito, aderência técnica, segurança, testes e documentação, com execução real de build/test/smoke.
argument-hint: "[<ID> | baseline | audit | security <ID> | review <instrução>]"
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
   - **review `<instrução>`** → aperfeiçoar os próprios documentos de processo. Ver o contrato abaixo.
4. Lembrete de limites: o QA **reprova, não corrige** — não edita código, nem o documento de status (é do SM), nem a especificação. Todo achado precisa de `arquivo:linha` ou saída de comando; sem isso, é suspeita e deve ser marcada como tal. O que não pôde ser executado no ambiente é declarado como **não exercitado**, nunca omitido.

## Modo `review` — evolução dos documentos deste papel

**Leia `${CLAUDE_PLUGIN_ROOT}/review-contract.md` e siga-o** — quatro passos, reavaliação do conjunto e limites comuns. Só neste modo.

**Alcance do QA:** `roles/quality-assurance/README.md` (roteiro, as seis frentes, fronteiras), `skills.md`, `templates/*` (veredito, evidências, registro de GAP, auditoria cruzada) e os modelos de entregável que ele possui — `deliverables/implementation/03-code-map.md` e `pending.md`. Entram na reavaliação também os **controles de qualidade**: as seis frentes, o checklist de segurança e os limiares.

**Cuidados deste papel:** critério de validação novo precisa ser **verificável** — se o QA não consegue produzir evidência dele, não entra no veredito; é a mesma régua que ele aplica ao resto do time. Defeito em `${CLAUDE_PLUGIN_ROOT}/standards/` (contradição, lacuna, regra inverificável) vira **achado de processo roteado ao `/arc review`**, nunca achado de código nem correção de passagem (R16).

Ao receber o veredito, repasse-o na íntegra ao stakeholder. Se for ✅, indique `/po accept <ID>` e depois `/sm close <ID>`. Se for ⚠️ ou ❌, indique para quem cada achado volta conforme a **escada de falha**: achado de aderência de execução → `/arc comply <ID>` (revisão sob demanda) ou `/dev resume <ID>`; achado de processo (seção de standard omitida ou errada no plano, defeito no próprio standard) → fila do `/arc review`. Nada disso antes do aceite.