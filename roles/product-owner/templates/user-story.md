# Template — História (`/po story <ID>`)

> **Dono:** PO · A **unidade de valor** do time (R20). Nasce do SDD funcional aprovado; vive no Product Backlog; é quebrada em Tasks pelo time na Planning Meeting.

A História tem **dois estados**, e o modelo cobre os dois. Escrever tudo de uma vez é desperdício: a maioria das Histórias do backlog nunca chega ao sprint na forma em que foi escrita.

| Estado | Quando | O que existe | Portão |
|---|---|---|---|
| **Esboço** | quando a História nasce do SDD | valor, enunciado, origem, tamanho grosseiro | — |
| **Detalhada** | quando ela candidata a um sprint | \+ regras, protótipos, critérios de aceite | ③ stakeholder aprova |

**Regra que não se negocia: o conteúdo é só funcional.** Nome de arquivo, classe, endpoint, tabela ou estrutura de dados não entram aqui — nascem no Plano de Implementação, dentro da Task. Detalhamento com decisão técnica é devolvido ao PO como achado de processo (R20).

## Estado 1 — esboço

```markdown
## H-<nnn> — <título curto, na voz do usuário>

**Estado:** esboço · **Criada em:** <data>

**Valor:** <uma frase — o que o stakeholder ou o usuário passa a conseguir fazer que hoje não consegue.>

**Origem:** RF-<nnn> / GAP <ID> / ressalva da Review do sprint <n>
**Tamanho grosseiro:** P / M / G  *(indicativo para ordenar o backlog, não é a estimativa — essa é por Task, na Planning)*
```

## Estado 2 — detalhada (antes da Planning Meeting)

```markdown
## H-<nnn> — <título curto, na voz do usuário>

**Estado:** detalhada · **Detalhada em:** <data> · **Aprovada pelo stakeholder em:** <data>

**Valor:** <a mesma frase do esboço, revista se o entendimento mudou.>

**Origem:** RF-<nnn> / GAP <ID> / ressalva da Review do sprint <n>

### Regras funcionais
<O que o sistema passa a fazer, em linguagem de negócio. Uma regra por linha.
Casos de borda que o stakeholder precisa reconhecer. Nada de "como".>

| # | Regra | Caso de borda |
|---|---|---|
| 1 | <regra> | <o que acontece quando…> |

### Protótipos *(História com interface — obrigatório, R8)*
| Tela / fluxo | Onde | Seis estados | Acessibilidade |
|---|---|---|---|
| <nome> | `.team-project/user-experience/screens/<arquivo>.md` | ✅ / pendente | ✅ / pendente |

*(História sem interface: escrever "não se aplica — sem interface" e seguir.)*

### Critérios de aceite
<Verificáveis. Cada um vira, na Review, uma linha com a evidência da Task que o cumpre.>

| # | Critério | Como verificar |
|---|---|---|
| 1 | <o que precisa ser verdade> | <chamada e resposta esperada, ou passo de UI e resultado> |

### Fora desta História
<O que alguém poderia razoavelmente supor que está incluído e não está. Evita a discussão na Review.>

### Aprovação do stakeholder — portão ③
**Situação:** aprovada | aprovada com ajuste | devolvida
**Data:** <data> · **Apresentada por:** PO
**Ajuste pedido:** <qual, ou "nenhum">
```

## Regras

- **Uma História entrega valor sozinha.** Se ela só faz sentido junto com outra, ou são a mesma História, ou falta declarar o valor de cada uma.
- **Todo critério de aceite tem "como verificar"** — mesma exigência do requisito (R7). Critério sem verificação não passa no portão ③.
- **História com interface não é detalhada sem o protótipo do UX**, com os seis estados e os critérios de acessibilidade (R8 · gate de `workflow.md` §8).
- **Sem aprovação do stakeholder, a História não entra na Planning Meeting** (portão ③). Não existe "entra e a gente aprova depois".
- **Trabalho técnico também precisa de História.** Refatoração, débito e infraestrutura entram como História cujo beneficiário é o time — com o valor escrito ("deixa de quebrar quando X", "reduz de N para M o tempo de Y"). O que não consegue declarar valor não entra no sprint (R20).
- **História grande demais para um sprint é quebrada em Histórias**, não em Tasks soltas. A quebra preserva o valor: cada metade precisa entregar algo sozinha.
- **A História é aceita ou rejeitada inteira**, na Sprint Review (R21). Escrever História grande é aceitar que uma reprovação devolve muito trabalho.

## Exemplo

```markdown
## H-014 — Exportar o resultado da análise para levar a uma reunião

**Estado:** detalhada · **Detalhada em:** 02/09/2026 · **Aprovada pelo stakeholder em:** 03/09/2026

**Valor:** o analista consegue sair da plataforma com o resultado em mãos, sem
tirar print de tela — hoje ele refaz o quadro manualmente no slide.

**Origem:** RF-031

### Regras funcionais
| # | Regra | Caso de borda |
|---|---|---|
| 1 | A exportação inclui só as linhas do filtro aplicado na tela | Filtro que não devolve nada: exporta o cabeçalho com aviso de zero linhas |
| 2 | O arquivo expira e deixa de ser baixável depois de 24h | Link aberto depois disso mostra "expirado", não erro genérico |
| 3 | Quem não enxerga um dado na tela não o recebe no arquivo | Usuário sem permissão de custo recebe o arquivo sem a coluna de custo |

### Protótipos
| Tela / fluxo | Onde | Seis estados | Acessibilidade |
|---|---|---|---|
| Botão e modal de exportação | `.team-project/user-experience/screens/export-modal.md` | ✅ | ✅ |

### Critérios de aceite
| # | Critério | Como verificar |
|---|---|---|
| 1 | Exportar com filtro aplicado traz só as linhas filtradas | filtrar por "região sul", exportar, conferir a contagem contra a tela |
| 2 | Link com mais de 24h não baixa e explica o motivo | gerar, avançar o relógio, abrir o link |
| 3 | Usuário sem permissão de custo recebe arquivo sem a coluna | exportar com o perfil "analista júnior" |

### Fora desta História
Agendar exportação recorrente; exportar de outras telas que não a de análise.

### Aprovação do stakeholder — portão ③
**Situação:** aprovada · **Data:** 03/09/2026 · **Apresentada por:** PO
**Ajuste pedido:** nenhum
```
