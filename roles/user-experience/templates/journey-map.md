# Template — Mapa de Jornada

> **Dono:** UX · Salvo em `.team-project/user-experience/journeys/<slug>.md`

Descreve **o caminho do usuário**, do gatilho ao resultado. Complementa o fluxo de negócio do PO (`02-flows-and-roles` do SDD): lá está o que o sistema faz; aqui, o que a pessoa vive.

```markdown
# Jornada — <nome do fluxo>

**Ator:** <quem percorre — o ator definido pelo PO no requisito>
**Perfil de uso:** <familiaridade, contexto e restrição desse ator — não cria ator nem permissão nova>
**Gatilho:** <o que faz esta jornada começar>
**Resultado esperado:** <o que o usuário leva embora>
**Requisitos atendidos:** <IDs>
**Base de evidência:** requisito do PO · inspeção das telas existentes · pesquisa com <N> participantes em <data>

## Passos

| # | Onde | O que o usuário faz | O que o sistema responde | Estado crítico |
|---|---|---|---|---|
| 1 | <tela/rota> | <ação> | <resposta> | <vazio? espera? erro?> |

## Pontos de espera
| Onde | Quanto tempo | O que o usuário vê | Ele pode sair e voltar? |
|---|---|---|---|

## Pontos de decisão humana
| Onde | O que se decide | O que acontece com cada escolha |
|---|---|---|

## Saídas de erro
| Onde falha | O que o usuário vê | Para onde ele vai |
|---|---|---|

## Onde a jornada pode se perder
<Os pontos de abandono prováveis e o que os mitiga.>

## Condições de uso que limitam
| Condição | Onde ela dói nesta jornada | O que o desenho faz por ela |
|---|---|---|
| <só teclado · leitor de tela · baixa visão · tela pequena · conexão lenta · primeiro contato · pressa> | <passo> | <providência verificável> |

## Telas envolvidas
| Tela | Situação | Especificação |
|---|---|---|
| <nome> | existente / a criar / a alterar | <link para a screen-spec> |

## Fora desta jornada
<O que não é coberto aqui e onde está coberto.>
```

## Regras

- **Gatilho e resultado são obrigatórios.** Jornada sem os dois é lista de telas.
- **Espera é primeira classe.** Todo processo assíncrono aparece como ponto de espera, com o que se vê e se dá para sair e voltar.
- **Erro tem destino.** Não basta dizer que falha: diga para onde a pessoa vai depois.
- **Decisão humana marcada** — é onde o sistema para e pergunta. Se não estiver explícito aqui, alguém vai decidir sozinho no código.
- **Uma jornada por objetivo do usuário**, não por módulo do sistema.
- **Base de evidência declarada.** Sem participante real, a base é *inspeção* — e se escreve assim. Afirmação sobre o que "o usuário espera", sem participante, data e número, não entra (`../skills.md` §9).
- **Perfil de uso descreve, não inventa.** Ator e permissão são do PO: perfil que exige um ator novo é escalação, não personagem.
- **Ao menos uma condição de uso limitante nomeada**, com providência verificável. Condição sem providência conta como ausente.

## Falhas comuns

| Falha | Consequência |
|---|---|
| Jornada que só descreve o caminho feliz | O comportamento em falha é inventado por quem implementa |
| Espera não mapeada | Usuário abandona sem saber que o processo continua |
| Jornada por módulo, não por objetivo | Ninguém percebe que o usuário atravessa três módulos para fazer uma coisa |
| Sem ponto de decisão humana | Automação decide o que deveria ser escolha da pessoa |
| Comportamento de usuário afirmado sem pesquisa | Suposição vira premissa citada como fato, e todo desenho seguinte herda o erro |
| Jornada desenhada só para quem já sabe usar | O produto exclui quem mais precisava do desenho, e ninguém percebe até a reclamação |
