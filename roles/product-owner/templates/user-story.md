# Template — História (`/po story <ID>`)

> **Dono:** PO · A **unidade de valor** do time (R20). Nasce do SDD funcional aprovado; vive em **arquivo próprio**, `.team-project/product-owner/stories/<H-ID>-<slug>.md` ([`artifact-ownership.md` §1d e §4](../../scrum-master/process/artifact-ownership.md)), indexada pelo Product Backlog; é quebrada em Tasks pelo time na Planning Meeting.

A História tem **dois estados no Product Backlog** (fonte viva), mais uma **cópia congelada** que passa a existir quando ela entra num sprint. Escrever tudo de uma vez é desperdício: a maioria das Histórias do backlog nunca chega ao sprint na forma em que foi escrita.

**O arquivo nasce no Esboço, não espera o Detalhe.** A partir do momento em que a História existe — ainda que só com valor, enunciado, origem e tamanho grosseiro —, ela já é a unidade que o Product Backlog indexa; um ID sem arquivo por trás é um link morto na tabela de Histórias, e "linkar quando detalhar" reabriria a mesma opcionalidade que a v3.21 fechou ([`artifact-ownership.md` §1e](../../scrum-master/process/artifact-ownership.md)). Ao rodar `/po story <ID>` pela primeira vez: escrever o Estado 1 no arquivo novo em `stories/` e, na mesma sessão, escrever/atualizar a linha correspondente no índice do Product Backlog — os dois documentos avançam juntos, sempre.

| Estado | Onde | Quando | O que existe | Portão |
|---|---|---|---|---|
| **Esboço** | `product-owner/stories/<H-ID>-<slug>.md` | nasce do SDD | valor, enunciado, origem, tamanho grosseiro | — |
| **Detalhada** | o mesmo arquivo, na fonte viva | candidata a um sprint | \+ regras, especificação de tela, critérios de aceite | **pronta para o pacote** — o ③ não é mais por História: acontece **depois** da Planning, **em lote**, sobre o pacote de abertura do sprint (R20 · R25) |
| **Congelada** | `sprints/<n>/stories/H-nnn.md` | aprovação do pacote de abertura | cópia da Detalhada, como foi aprovada para aquele sprint | ③ já ocorrido, em lote — ver [`workflow.md` §5e](../../scrum-master/process/workflow.md) passo 10 |

**A Detalhada entra na Planning com o ③ ainda pendente** (R20). Nenhuma Task dela entra em construção antes de o pacote de abertura ser aprovado. **Custo aceito, declarado:** se o pacote voltar reprovado ou com ajuste, a História perde a quebra em Tasks e a estimativa já feitas — risco baixo, porque o que se detalha aqui deriva do SDD funcional já aprovado no ①.

**A cópia congelada não substitui a fonte viva.** O arquivo em `product-owner/stories/` continua sendo o documento que evolui; o de `sprints/<n>/stories/` é o retrato do que foi aprovado para aquele sprint, e não se edita depois (R4).

**Regra que não se negocia: o conteúdo é só funcional.** Nome de arquivo, classe, endpoint, tabela ou estrutura de dados não entram aqui — nascem no Plano de Implementação, dentro da Task. Detalhamento com decisão técnica é devolvido ao PO como achado de processo (R20).

## Estado 1 — esboço

```markdown
## H-<nnn> — <título curto, na voz do usuário>

**Estado:** esboço · **Criada em:** <data>

**Valor:** <uma frase — o que o stakeholder ou o usuário passa a conseguir fazer que hoje não consegue.>

**Origem:** RF-<nnn> / GAP <ID> / ressalva da Review do sprint <n>
**Tamanho grosseiro:** P / M / G  *(indicativo para ordenar o backlog, não é a estimativa — essa é por Task, na Planning)*
```

## Estado 2 — detalhada (candidata à Planning Meeting)

```markdown
## H-<nnn> — <título curto, na voz do usuário>

**Estado:** detalhada · **Detalhada em:** <data>

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
```

> **Não há seção de aprovação do stakeholder aqui.** O ③ não é mais registrado por História: a aprovação acontece **uma vez por sprint**, sobre o pacote de abertura inteiro, e é registrada no Sprint Backlog ([`templates/sprint-backlog.md`](../../scrum-master/templates/sprint-backlog.md), dono SM) — data, quem aprovou, ponteiro do protótipo navegado. A prova de que **esta** História passou pelo ③ é ela existir como arquivo **Congelada** (abaixo).

## Estado 3 — congelada (`sprints/<n>/stories/H-nnn.md`, na aprovação do pacote)

Cópia integral do conteúdo da Detalhada, com o cabeçalho trocado para declarar o sprint e a data do congelamento — nada de conteúdo muda entre os dois estados:

```markdown
## H-<nnn> — <título curto, na voz do usuário>

**Estado:** congelada · **Sprint:** <n> · **Congelada em:** <data da aprovação do pacote>
**Detalhada em:** <data> · **Fonte viva:** Product Backlog, mesmo ID

<… o restante é idêntico ao conteúdo aprovado da Detalhada — regras, protótipos, critérios de aceite, fora desta História …>
```

**Este arquivo não é editado durante o sprint** (R4 · R25). É a História **como foi aprovada para aquele sprint** — mesmo ID do Product Backlog, objeto diferente. Ajuste identificado depois do congelamento vai ao Product Backlog, a fonte viva, e concorre na Planning seguinte.

## Regras

- **Uma História entrega valor sozinha.** Se ela só faz sentido junto com outra, ou são a mesma História, ou falta declarar o valor de cada uma.
- **Todo critério de aceite tem "como verificar"** — mesma exigência do requisito (R7). Critério sem verificação não entra no pacote de abertura.
- **História com interface não é detalhada sem o protótipo do UX**, com os seis estados e os critérios de acessibilidade (R8 · gate de `workflow.md` §8).
- **A Detalhada entra na Planning com o ③ ainda pendente** — a aprovação vem depois, em lote, sobre o pacote de abertura (R20 · R25). Nenhuma Task desta História entra em construção antes do pacote aprovado.
- **Trabalho técnico também precisa de História.** Refatoração, débito e infraestrutura entram como História cujo beneficiário é o time — com o valor escrito ("deixa de quebrar quando X", "reduz de N para M o tempo de Y"). O que não consegue declarar valor não entra no sprint (R20).
- **História grande demais para um sprint é quebrada em Histórias**, não em Tasks soltas. A quebra preserva o valor: cada metade precisa entregar algo sozinha.
- **A História é aceita ou rejeitada inteira**, na Sprint Review (R21). Escrever História grande é aceitar que uma reprovação devolve muito trabalho.
- **`sprints/<n>/stories/` é congelado, não editado.** Mudar o arquivo durante o sprint é violação de escopo — a mudança vai ao Product Backlog (R4 · R25).

## Exemplo

```markdown
## H-014 — Exportar o resultado da análise para levar a uma reunião

**Estado:** detalhada · **Detalhada em:** 02/09/2026

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
```

Esta História entrou na Planning do Sprint 7 com o ③ pendente. Aprovado o pacote de abertura do Sprint 7, o PO grava a cópia congelada:

```markdown
## H-014 — Exportar o resultado da análise para levar a uma reunião

**Estado:** congelada · **Sprint:** 7 · **Congelada em:** 03/09/2026
**Detalhada em:** 02/09/2026 · **Fonte viva:** Product Backlog, mesmo ID

<… regras, protótipos, critérios de aceite e "fora desta História" idênticos aos da Detalhada acima …>
```
