# Template — Pergunta ao stakeholder (H1, v3.51)

Vale para **todo** ponto que vai ao stakeholder: o bloqueio que o degrau 1 não fechou (R22), os ajustes do `fix plan` (R33), a autorização da Review, o escopo da triagem, a ocorrência de plugin e as propostas de melhoria. O stakeholder decide rápido quando entende o problema na primeira leitura; no benchmark, decisões escritas na linguagem do processo precisaram de várias voltas até ficarem claras.

A guarda G3 confere duas coisas no formulário: a última opção é **"Pedir mais contexto"** e há um **exemplo** (na pergunta ou na descrição de uma opção). O resto é do SM, na retrospectiva.

## O formato

1. **O problema em uma ou duas frases**, sem sigla, sem nome de regra, sem nome de arquivo.
2. **Um exemplo prático e concreto**, tirado do próprio produto, começando por "Exemplo:".
3. **O que muda em cada opção**, na descrição da opção (custo, prazo, risco, o que o usuário vê).
4. **A recomendação primeiro**, com "(Recomendado)" no rótulo.
5. **"Pedir mais contexto" sempre por último**: detalha e repete a pergunta.

Texto de apoio (antes do formulário): no máximo um parágrafo curto. O detalhe técnico fica no material citado, nunca na pergunta.

## Exemplo

> **Pergunta:** O raio inicial da busca pode mudar de 200 km para 150 km? Exemplo: hoje, ao abrir o app em São Paulo, aparecem 17 destinos; com 150 km aparecem 12, e Paraty, Cunha e Ubatuba saem da primeira tela.
>
> | Opção | Descrição |
> |---|---|
> | **Aprovar 150 km (Recomendado)** | a lista inicial fica menor e mais perto; muda uma regra do documento funcional; entra no próximo bloco de correções |
> | **Manter 200 km** | nada muda; o pedido sai da fila |
> | **Tratar como História** | vira item do backlog, com análise de impacto antes de entrar num sprint |
> | **Pedir mais contexto** | o time mostra as duas listas lado a lado e repete a pergunta |

## Como não escrever

- "Aprova o ajuste F-012 (C1 ✔, delta em 01-requirements §R7)?" — sigla e regra, sem o que muda para o usuário.
- "Sigo?" — não é decisão do stakeholder (paradas legítimas, `sprint-run.md`).
- Uma pergunta que exige abrir três arquivos para responder.
