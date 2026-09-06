---
description: Aciona o desenvolvedor — executa um Plano de Execução já escrito pelo Arquiteto e devolve código, testes e verificação real.
argument-hint: "<ID do item> [ | resume <ID> | gap <resposta do arquiteto>]"
---

Aciona o **desenvolvedor** do time.

Pedido do stakeholder: **$ARGUMENTS**

**Pré-condição obrigatória:** leia `.team-project/architect/plans/<ID>-*.md`. Se o plano **não existir**, não invente e não improvise um: informe o stakeholder e ofereça rodar `/arc plan <ID>` antes. Sem plano, o dev não codifica — é a regra que sustenta a qualidade do time.

Com o plano em mãos, use a ferramenta Agent com `subagent_type: "developer"` e `run_in_background: false`, passando ao agente:

1. O caminho do Plano de Execução e o ID do item.
2. A instrução de ler `.team-project/developer/context.md` antes de escrever a primeira linha.
3. O modo de operação, conforme o pedido:
   - **`<ID>`** → executar o plano do início ao fim, na ordem dos passos.
   - **resume `<ID>`** → continuar de onde parou; conferir no código o que já existe antes de escrever qualquer coisa.
   - **gap `<resposta>`** → retomar aplicando a decisão que o Arquiteto acabou de dar; se o agente anterior ainda estiver ativo, prefira continuar por SendMessage para preservar o contexto dele.
4. As regras do contrato de trabalho: só os arquivos listados no plano; nomenclatura literal; sem refatoração oportunista, dependência nova ou escopo antecipado; os testes previstos são obrigatórios; os comandos de verificação executados de verdade, com a saída colada; documentação não é dele.
5. A instrução de **parar e reportar 🔺 GAP** — no formato de `${CLAUDE_PLUGIN_ROOT}/roles/developer/templates/gap.md` — em vez de decidir sozinho.

## `/dev review` não existe — é do Arquiteto

Os documentos do papel dev (`roles/developer/README.md`, `skills.md`, `templates/*`) são **revisados pelo Arquiteto**, por `/arc review`. A razão é deliberada: o dev roda no modelo mais simples do time, calibrado para **executar plano com fidelidade**, não para avaliar e reescrever o próprio normativo. Deixar o papel mais barato editar as regras que o governam é o caminho mais curto para elas afrouxarem sem ninguém perceber.

Se o pedido chegar como `/dev review`, **não execute**: responda que o caminho é `/arc review` e repasse a instrução do stakeholder, literal, para o Arquiteto avaliar.

Isso **não silencia o dev**: ele é quem sente primeiro quando um plano vem raso ou um formato atrapalha — e esse retorno continua chegando pelo 🔺 GAP e pela seção "Não fiz (fora do plano)" do relatório de entrega, que o Arquiteto lê ao revisar.

Ao receber o relatório de entrega:
- Se houver 🔺 GAP, leve-o ao Arquiteto (`/arc question` ou Agent `architect`) e devolva a decisão ao dev — **não resolva o gap você mesmo**.
- Se a entrega estiver completa, repasse ao stakeholder o relatório (arquivos, testes, saída real da verificação, o que ficou fora do plano) e indique o próximo passo: `/qa <ID>`.
