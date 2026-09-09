# Protótipo Funcional — Modelo do entregável

> **Dono:** UX · **Vive em:** `.team-project/user-experience/prototype/` · **Portão:** pré-condição de **①** (aprovação do SDD funcional)

O protótipo funcional é um **artefato navegável em HTML** que materializa o entendimento funcional do produto **antes de o stakeholder aprová-lo**. É entregável, não rascunho: tem dono, critérios de qualidade e um portão que ele bloqueia.

## Por que ele vem antes do portão ①

Aprovar `00-overview`, `01-requirements` e `02-flows-and-roles` **lendo texto** é aprovar uma descrição do produto. Nenhum stakeholder consegue prever, lendo uma tabela de requisitos, como será atravessar o fluxo. A divergência entre o que ele imaginou e o que o time entendeu aparece — sempre — na primeira vez que ele **vê a coisa funcionando**; a única pergunta é quanto já foi construído até lá.

O protótipo antecipa esse momento para o ponto mais barato do processo: antes do SDD técnico, antes das Histórias, antes de qualquer Task. O que se joga fora quando o entendimento muda é **HTML descartável**, não arquitetura, contrato de API e código.

**Consequência prática:** o stakeholder não aprova o SDD funcional lendo — ele **navega o protótipo** e aprova o que navegou.

## Os dois protótipos do processo — não confundir

| | **Protótipo funcional** (este) | **Protótipo de tela** (portão ③) |
|---|---|---|
| **Escopo** | O produto, ou a fatia inteira: os fluxos principais ponta a ponta | Uma tela da História que está entrando no sprint |
| **Pergunta que responde** | "É *isto* que você quer que o produto faça?" | "É *assim* que esta tela se comporta?" |
| **Fidelidade** | Suficiente para navegar o fluxo; visual é secundário | Alta: os seis estados, acessibilidade, detalhe de construção |
| **Quando** | Antes do portão ①, junto com `00`/`01`/`02` | No detalhamento da História, antes da Planning |
| **Onde** | `.team-project/user-experience/prototype/` | `.team-project/user-experience/screens/` |
| **Modelo** | [`functional-prototype.md`](../../roles/user-experience/templates/functional-prototype.md) | [`screen-spec.md`](../../roles/user-experience/templates/screen-spec.md) |

Um não substitui o outro. O funcional prova que o **entendimento** está certo; o de tela prova que a **construção** tem instrução suficiente.

## O que o protótipo precisa ter

| # | Exigência | Por quê |
|---|---|---|
| 1 | **HTML navegável**, aberto no navegador sem build nem servidor | Se o stakeholder precisa de ajuda técnica para abrir, ele não vai abrir |
| 2 | **Todo fluxo principal de `02-flows-and-roles` atravessável ponta a ponta** | É o que o portão ① aprova; fluxo sem caminho no protótipo é fluxo não validado |
| 3 | **Dados de exemplo plausíveis**, não `lorem ipsum` nem `campo1` | Dado falso esconde o problema que o dado real revelaria (nome longo, valor negativo, lista vazia) |
| 4 | **Um ponto de entrada só** (`index.html`), com índice dos fluxos | Protótipo que exige instrução de navegação não foi navegado |
| 5 | **Estados de exceção dos fluxos principais**: vazio, erro, sem permissão | São onde o entendimento funcional costuma divergir |
| 6 | **O que está fora, declarado na própria página** | Evita a aprovação de algo que o stakeholder achou que estava incluído |
| 7 | **Sem back-end, sem banco, sem build** | Protótipo é descartável por definição; o que precisa de infraestrutura já é produto |

## O que ele **não** é

- **Não é código de produção.** Nada daqui é reaproveitado sem passar por Plano de Implementação. Protótipo reaproveitado é dívida técnica com origem nobre.
- **Não é especificação de tela.** Não substitui os seis estados nem os critérios de acessibilidade do portão ③.
- **Não é decisão técnica.** Não escolhe framework, não define contrato, não modela dado. Se o protótipo obrigar a uma decisão técnica para existir, ele está grande demais.
- **Não é design final.** Fidelidade visual é secundária — o portão ① aprova entendimento funcional, não identidade visual.

## Critérios de qualidade — o que se verifica no portão ①

- [ ] Abre no navegador com dois cliques, sem instrução
- [ ] Todo fluxo principal de `02-flows-and-roles` tem caminho navegável, do início ao resultado
- [ ] Todo ator de `02-flows-and-roles` tem ao menos um caminho no protótipo
- [ ] Todo requisito funcional de `01-requirements` marcado como "da primeira fatia" aparece no protótipo, ou está na lista de "fora"
- [ ] Os estados de exceção dos fluxos principais existem
- [ ] Os dados de exemplo são plausíveis
- [ ] A lista do que está fora está escrita na própria página
- [ ] O stakeholder **navegou** — não leu o código, não viu print

**Sem estes itens, o portão ① não abre.** Protótipo ausente ou não navegado bloqueia a escrita do SDD técnico do mesmo jeito que plano ausente bloqueia código (R8).

## Como ele evolui

O protótipo é **documento vivo enquanto a fatia não fecha** (R12): mudança funcional aprovada que altere um fluxo principal atualiza o protótipo no mesmo ciclo. Depois que as Histórias daquela fatia foram entregues e aceitas, ele vira **registro histórico** — a fonte da verdade passa a ser o produto, e o QA valida contra o SDD, não contra o protótipo.

Divergência entre protótipo e produto **depois** do aceite não é defeito do produto: é protótipo vencido, e o UX o marca como tal.
