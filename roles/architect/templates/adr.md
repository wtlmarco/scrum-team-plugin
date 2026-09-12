# Template — ADR (Architecture Decision Record)

Vai para o diretório de ADRs do projeto (caminho em `.team-project/README.md` §4) e **precisa ser registrada no índice daquele diretório**, com status.

Use ADR quando a decisão é **estrutural e recorrente**: muda como o sistema é construído dali em diante e será consultada por quem chegar depois. Decisão pontual vira entrada no documento de status, via SM.

```markdown
# ADR-<nnn> — <título da decisão>

**Status:** Proposed | Accepted | Superseded by ADR-<nnn>
**Data:** <data> · **Autor:** Arquiteto · **Aprovação:** <stakeholder, quando a decisão for estratégica>

## 1. Contexto
<O problema real, com evidência: `arquivo:linha`, requisito, incidente, limitação observada.
Sem contexto verificável a ADR vira preferência documentada.>

## 2. Forças em jogo
| Força | Peso |
|---|---|
| <restrição técnica, custo, prazo, segurança, privacidade, reversibilidade> | <por que pesa> |

## 3. Decisão
<A decisão em uma frase afirmativa, no presente: "O sistema usa X para Y".>

### Como se aplica
- <regra concreta que passa a valer para todo código novo>
- <o que muda no código existente, e se há migração>

## 4. Alternativas consideradas
| Alternativa | Por que foi descartada |
|---|---|

## 5. Consequências
**Positivas:** <o que fica mais fácil>
**Negativas:** <o que fica mais caro ou mais rígido — seja honesto>
**Reversibilidade:** <barata | cara — e o que seria preciso para voltar atrás>

## 6. Checklist de aceitação
Verificável em código, para revalidação em auditoria futura:
- [ ] <afirmação testável>
- [ ] <teste que sustenta a afirmação>

## 7. Relacionadas
- ADR-<nnn> — <relação>
- <documento do projeto> §<n> — <o que passa a refletir>
```

## Regras

- **Contexto com evidência.** ADR nasce de um fato observado no código ou de um requisito, não de uma preferência.
- **Checklist de aceitação é obrigatório** — é o que permite ao QA revalidar a ADR contra o código meses depois. ADR sem checklist envelhece sem que ninguém perceba.
- **Consequência negativa explícita.** ADR que só tem vantagem não foi pensada.
- **Etapa de spike inconclusiva por causa externa não sustenta decisão.** Se a evidência do contexto depende de uma chamada a serviço externo que não fechou (limite de taxa, indisponibilidade), a ADR fica em `Proposed` com a pendência nomeada e o que falta para fechá-la — nunca `Accepted` sobre etapa não exercitada (R7; [`../skills.md`](../skills.md) §11).
- Ao aceitar, atualizar o índice de ADRs do projeto.

## Sinais de que falta uma ADR

- Funcionalidade central implementada "direto da especificação", sem decisão formalizada.
- Algoritmo de julgamento (score, ranking, seleção de fornecedor) sem critério documentado.
- ADR marcada como implementada e nunca revalidada contra o código.
- Regra estrutural que já foi explicada duas vezes em conversa e não está escrita em lugar nenhum.

A dívida de ADR deste projeto está em `.team-project/architect/context.md`.
