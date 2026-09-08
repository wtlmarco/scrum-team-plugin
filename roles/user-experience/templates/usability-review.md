# Template � Revis�o de Usabilidade e Acessibilidade

> **Dono:** UX � Sa�da de `/ux review-ui` � Achado fora da Task vira registro para o backlog, nunca corre��o de passagem.

```markdown
## Revis�o de UX � <tela ou fluxo> � <data>

**Escopo:** <o que foi revisado, e contra qual especifica��o/requisito>
**M�todo:** inspe��o heur�stica da especifica��o � navega��o no prot�tipo � uso da tela real � **teste de usabilidade com <N> participantes em <data>** � diga qual. *Sem participante real, � inspe��o.*

### Veredito
**? Adequado | ?? Adequado com ressalva | ? Inadequado**

### Achados
| # | Severidade | Achado | Onde | Crit�rio violado | Corre��o sugerida |
|---|---|---|---|---|---|
| 1 | ??/??/??/?? | <o que o usu�rio sofre> | <tela/componente> | <heur�stica � crit�rio de acessibilidade � conven��o do produto> | <dire��o, n�o implementa��o> |

### Estados da tela verificados
| Estado | Situa��o | Como verifiquei |
|---|---|---|
| Vazio | ok / falha / n�o verific�vel | |
| Carregando | ok / falha / n�o verific�vel | |
| Sucesso | ok / falha / n�o verific�vel | |
| Erro | ok / falha / n�o verific�vel | |
| Sem permiss�o | ok / falha / n�o verific�vel | |
| Volume extremo | ok / falha / n�o verific�vel | |

### Estados de intera��o dos controles
| Controle | Repouso | Foco | Pressionado | Desabilitado |
|---|---|---|---|---|
| <controle> | ok / falha | ok / falha | ok / falha | ok / falha / n/a |

### Acessibilidade
| Crit�rio | Resultado | Como verifiquei |
|---|---|---|
| Navega��o por teclado e foco vis�vel | ok / falha | |
| R�tulo acess�vel em todo controle | ok / falha | |
| Contraste | ok / falha | |
| Alvo de toque | ok / falha | |
| Hierarquia sem�ntica | ok / falha | |
| Informa��o n�o dependente s� de cor | ok / falha | |
| Zoom 200% e viewport de 320 px sem rolagem horizontal | ok / falha | |
| Sem fun��o presa a gesto complexo ou a movimento | ok / falha | |
| Condi��o de uso limitante declarada e atendida | ok / falha | |

### Resultado do teste com participantes
*(S� quando houve teste. Sem teste, escreva "n�o houve � revis�o por inspe��o".)*

| Tarefa | Participantes que conclu�ram | Onde travaram | O que mudou por causa disso |
|---|---|---|---|

### Fora da Task
<Achados em outras telas � viram registro no backlog, com severidade. N�o corrigidos aqui.>

### N�o verificado
<O que n�o p�de ser checado e por qu� � prot�tipo indispon�vel, tela n�o implementada, dado insuficiente.>
```

## Severidade

| N�vel | Significado |
|---|---|
| ?? **Cr�tica** | O usu�rio n�o consegue completar a tarefa, ou a tela � inacess�vel por teclado/leitor de tela |
| ?? **Alta** | O usu�rio completa, mas com erro prov�vel, retrabalho ou confus�o consistente |
| ?? **M�dia** | Atrito percept�vel; inconsist�ncia com o padr�o do produto |
| ?? **Baixa** | Polimento, microc�pia, alinhamento |

## Regras

- **Achado descreve o que o usu�rio sofre**, n�o a prefer�ncia est�tica de quem revisa.
- **Todo achado cita o crit�rio violado** � heur�stica de usabilidade, crit�rio de acessibilidade ou conven��o do produto (`../skills.md` �8). Sem isso � opini�o, e opini�o n�o se prioriza.
- **Corre��o sugerida � dire��o, n�o implementa��o.**
- **M�todo declarado, e declarado com honestidade.** Sem participante real n�o existe "os usu�rios acharam": o que houve foi inspe��o. Alega��o de comportamento de usu�rio sem participante, data e n�mero invalida o achado inteiro.
- **"N�o verificado" � obrigat�rio** � mesma disciplina do QA: o que n�o foi exercitado se declara.
- **Barreira de acessibilidade � ?? por padr�o**; rebaixe s� com justificativa expl�cita.
- **Um estado por linha.** Veredito �nico para os seis estados esconde exatamente o estado que falhou.
