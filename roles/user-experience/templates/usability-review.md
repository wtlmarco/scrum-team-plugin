# Template — Revisão de Usabilidade e Acessibilidade

> **Dono:** UX · Saída de `/ux review-ui` · Achado fora do item vira registro para o backlog, nunca correção de passagem.

```markdown
## Revisão de UX — <tela ou fluxo> — <data>

**Escopo:** <o que foi revisado, e contra qual especificação/requisito>
**Método:** inspeção heurística da especificação · navegação no protótipo · uso da tela real · **teste de usabilidade com <N> participantes em <data>** — diga qual. *Sem participante real, é inspeção.*

### Veredito
**? Adequado | ?? Adequado com ressalva | ? Inadequado**

### Achados
| # | Severidade | Achado | Onde | Critério violado | Correção sugerida |
|---|---|---|---|---|---|
| 1 | ??/??/??/?? | <o que o usuário sofre> | <tela/componente> | <heurística · critério de acessibilidade · convenção do produto> | <direção, não implementação> |

### Estados da tela verificados
| Estado | Situação | Como verifiquei |
|---|---|---|
| Vazio | ok / falha / não verificável | |
| Carregando | ok / falha / não verificável | |
| Sucesso | ok / falha / não verificável | |
| Erro | ok / falha / não verificável | |
| Sem permissão | ok / falha / não verificável | |
| Volume extremo | ok / falha / não verificável | |

### Estados de interação dos controles
| Controle | Repouso | Foco | Pressionado | Desabilitado |
|---|---|---|---|---|
| <controle> | ok / falha | ok / falha | ok / falha | ok / falha / n/a |

### Acessibilidade
| Critério | Resultado | Como verifiquei |
|---|---|---|
| Navegação por teclado e foco visível | ok / falha | |
| Rótulo acessível em todo controle | ok / falha | |
| Contraste | ok / falha | |
| Alvo de toque | ok / falha | |
| Hierarquia semântica | ok / falha | |
| Informação não dependente só de cor | ok / falha | |
| Zoom 200% e viewport de 320 px sem rolagem horizontal | ok / falha | |
| Sem função presa a gesto complexo ou a movimento | ok / falha | |
| Condição de uso limitante declarada e atendida | ok / falha | |

### Resultado do teste com participantes
*(Só quando houve teste. Sem teste, escreva "não houve — revisão por inspeção".)*

| Tarefa | Participantes que concluíram | Onde travaram | O que mudou por causa disso |
|---|---|---|---|

### Fora do item
<Achados em outras telas — viram registro no backlog, com severidade. Não corrigidos aqui.>

### Não verificado
<O que não pôde ser checado e por quê — protótipo indisponível, tela não implementada, dado insuficiente.>
```

## Severidade

| Nível | Significado |
|---|---|
| ?? **Crítica** | O usuário não consegue completar a tarefa, ou a tela é inacessível por teclado/leitor de tela |
| ?? **Alta** | O usuário completa, mas com erro provável, retrabalho ou confusão consistente |
| ?? **Média** | Atrito perceptível; inconsistência com o padrão do produto |
| ?? **Baixa** | Polimento, microcópia, alinhamento |

## Regras

- **Achado descreve o que o usuário sofre**, não a preferência estética de quem revisa.
- **Todo achado cita o critério violado** — heurística de usabilidade, critério de acessibilidade ou convenção do produto (`../skills.md` §8). Sem isso é opinião, e opinião não se prioriza.
- **Correção sugerida é direção, não implementação.**
- **Método declarado, e declarado com honestidade.** Sem participante real não existe "os usuários acharam": o que houve foi inspeção. Alegação de comportamento de usuário sem participante, data e número invalida o achado inteiro.
- **"Não verificado" é obrigatório** — mesma disciplina do QA: o que não foi exercitado se declara.
- **Barreira de acessibilidade é ?? por padrão**; rebaixe só com justificativa explícita.
- **Um estado por linha.** Veredito único para os seis estados esconde exatamente o estado que falhou.
