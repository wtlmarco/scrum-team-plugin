# Protótipos navegáveis — Modelos dos entregáveis do UX

> **Dono:** UX · **Dois entregáveis, dois portões.** O **protótipo funcional** (raiz de `.team-project/user-experience/prototype/`) é pré-condição de **①**; o **protótipo do sprint** (`prototype/sprint-<n>/`, uma pasta por sprint) é peça do pacote de abertura, o **③ em lote** (R25). São **homônimos com propósitos diferentes** ([`artifact-ownership.md` §1b](../../roles/scrum-master/process/artifact-ownership.md)) — a tabela de §*Os protótipos do processo* diz qual é qual antes de qualquer critério.

O protótipo funcional é um **artefato navegável em HTML** que materializa o entendimento funcional do produto **antes de o stakeholder aprová-lo**. É entregável, não rascunho: tem dono, critérios de qualidade e um portão que ele bloqueia.

## Por que ele vem antes do portão ①

Aprovar `00-overview`, `01-requirements` e `02-flows-and-roles` **lendo texto** é aprovar uma descrição do produto. Nenhum stakeholder consegue prever, lendo uma tabela de requisitos, como será atravessar o fluxo. A divergência entre o que ele imaginou e o que o time entendeu aparece — sempre — na primeira vez que ele **vê a coisa funcionando**; a única pergunta é quanto já foi construído até lá.

O protótipo antecipa esse momento para o ponto mais barato do processo: antes do SDD técnico, antes das Histórias, antes de qualquer Task. O que se joga fora quando o entendimento muda é **HTML descartável**, não arquitetura, contrato de API e código.

**Consequência prática:** o stakeholder não aprova o SDD funcional lendo — ele **navega o protótipo** e aprova o que navegou.

## Os protótipos do processo — três coisas com o mesmo nome

| | **Protótipo funcional** | **Protótipo do sprint** | **Protótipo de tela** |
|---|---|---|---|
| **Escopo** | O produto, ou a fatia inteira: os fluxos principais ponta a ponta | As telas das Histórias de **um** sprint, costuradas num caminho | Uma tela da História que está sendo detalhada |
| **Pergunta que responde** | "É *isto* que você quer que o produto faça?" | "É *isto* que você quer receber **neste sprint**?" | "É *assim* que esta tela se comporta?" |
| **Portão** | pré-condição de **①** (SDD funcional) | peça do **pacote de abertura — ③ em lote** (R25) | nenhum: é exploração do detalhamento |
| **Fidelidade** | Suficiente para navegar o fluxo; visual é secundário | Suficiente para atravessar o caminho; reusa o que já existe | A que o gatilho pedir — a especificação é que é obrigatória |
| **Quando** | Antes do ①, junto com `00`/`01`/`02` | Na Planning, **depois do corte de capacidade** | No detalhamento da História, antes da Planning |
| **Onde** | `.team-project/user-experience/prototype/` (raiz) | `.team-project/user-experience/prototype/sprint-<n>/` | ambiente declarado no contexto; a especificação vive em `screens/` |
| **Modelo** | [`functional-prototype.md`](../../roles/user-experience/templates/functional-prototype.md) | [`sprint-prototype.md`](../../roles/user-experience/templates/sprint-prototype.md) | [`screen-spec.md`](../../roles/user-experience/templates/screen-spec.md) |

**Nenhum substitui outro, e os dois entregáveis não se fundem.** O funcional prova que o **entendimento do produto** está certo, e é vivo enquanto a fatia não fecha; o do sprint prova que **o que vai ser construído agora** é o que o stakeholder quer receber, e fecha na aprovação do pacote; o de tela prova que a **construção** tem instrução suficiente. Protótipo funcional recente **não dispensa** o do sprint: um aprova o produto, o outro aprova o lote.

**Erro de leitura mais caro:** entregar o protótipo funcional como peça do pacote de abertura. Ele cobre fluxos que o sprint não vai construir e não mostra o recorte que o stakeholder está aprovando — o pacote passa, e a deriva do lote aparece só na Review.

## O que o protótipo funcional precisa ter

| # | Exigência | Por quê |
|---|---|---|
| 1 | **HTML navegável**, aberto no navegador sem build nem servidor | Se o stakeholder precisa de ajuda técnica para abrir, ele não vai abrir |
| 2 | **Todo fluxo principal de `02-flows-and-roles` atravessável ponta a ponta** | É o que o portão ① aprova; fluxo sem caminho no protótipo é fluxo não validado |
| 3 | **Dados de exemplo plausíveis**, não `lorem ipsum` nem `campo1` | Dado falso esconde o problema que o dado real revelaria (nome longo, valor negativo, lista vazia) |
| 4 | **Um ponto de entrada só** (`index.html`), com índice dos fluxos | Protótipo que exige instrução de navegação não foi navegado |
| 5 | **Estados de exceção dos fluxos principais**: vazio, erro, sem permissão | São onde o entendimento funcional costuma divergir |
| 6 | **O que está fora, declarado na própria página** | Evita a aprovação de algo que o stakeholder achou que estava incluído |
| 7 | **Sem back-end, sem banco, sem build** | Protótipo é descartável por definição; o que precisa de infraestrutura já é produto |

## O que o protótipo funcional **não** é

- **Não é código de produção.** Nada daqui é reaproveitado sem passar por Plano de Implementação. Protótipo reaproveitado é dívida técnica com origem nobre.
- **Não é especificação de tela.** Não substitui os seis estados nem os critérios de acessibilidade que a especificação declara.
- **Não é o protótipo do sprint.** Ele cobre os fluxos principais do SDD; o do sprint cobre as Histórias que entraram naquele lote. Um não vale pelo outro — ver a tabela acima.
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

## Protótipo do sprint — critérios de verificação do ③ em lote

> **Vive em:** `.team-project/user-experience/prototype/sprint-<n>/` — **uma pasta por sprint, nunca sobrescrita**; a raiz de `prototype/` continua sendo do protótipo funcional do ① · **Modelo:** [`sprint-prototype.md`](../../roles/user-experience/templates/sprint-prototype.md) · **Portão:** peça do pacote de abertura (R25 · [`workflow.md` §5e passo 10 e §5g](../../roles/scrum-master/process/workflow.md))

**Por que ele existe.** O pacote de abertura entrega ao stakeholder o Sprint Backlog, os critérios de aceite, o `planning.md` — e um protótipo. Sem ele o ③ seria aprovar **uma descrição do sprint**, que é exatamente o modo de falha que o ① já resolveu para o produto (R15). E ele é a **verificação de valor real do sprint** (R25b): protótipo que não atravessa um fluxo ponta a ponta denuncia um corte que não entrega fatia usável, e o corte é refeito **antes** de o sprint arrancar — não descoberto na Review.

**O que é trabalho novo, e o que não é.** A especificação de tela de cada História candidata continua sendo produzida **antes** da Planning — é pré-condição da DoR da História, e não muda. O novo é a **costura** das telas já especificadas num caminho navegável, depois do corte de capacidade. Quem lê "protótipo por sprint" como "especificar tudo de novo" dobra o custo estimado do item.

| # | Exigência | Por quê |
|---|---|---|
| 1 | **Toda História que entrou no sprint tem tela representada**, ou a ficha declara por que não tem (História sem interface) | É o recorte que o stakeholder está aprovando; História invisível no protótipo é História aprovada no escuro |
| 2 | **Ao menos um fluxo ponta a ponta atravessável**, do gatilho ao resultado | É a verificação de valor real (R25b). Sem ele o pacote **não sobe** — o achado volta ao PO na Planning |
| 3 | **Costurado, não indexado** — as telas se ligam por navegação real, não por uma lista de links soltos | Índice de telas não é caminho; ninguém atravessa fluxo clicando em itens de menu |
| 4 | **Produzido depois do corte de capacidade**, com as Histórias que sobraram | Antes do corte não se sabe quais entraram — costurar antes é retrabalho garantido |
| 5 | **Mesma régua técnica do funcional:** um ponto de entrada, sem build/servidor/back-end, dados plausíveis, estados de exceção dos caminhos cobertos, "o que está fora" na própria página | O stakeholder que precisa de ajuda para abrir não navega — e o que ele não navegou, ele não aprovou |
| 6 | **Exercitado**, com o registro de verificação preenchido: modo, alcance, o que **não** foi reexecutado e o que o cobre | R7 · R23 — leve reduz o escopo executado, nunca a evidência ([`skills.md` §10](../../roles/user-experience/skills.md)) |
| 7 | **Pasta numerada, nunca sobrescrita**, e o ponteiro registrado no Sprint Backlog resolve | O ponteiro é o registro do que foi aprovado naquele sprint; sobrescrever apodrece o histórico do ③ |
| 8 | **O stakeholder navegou** — e a ficha traz data, quem, e o que foi pedido em cada devolução | Print, gravação e apresentação não abrem o ③, pelo mesmo motivo que não abrem o ① |

**Sem estes itens, o sprint não arranca.** Pacote reprovado ou aprovado com ajuste volta à Planning: o PO reordena, o corte é refeito, o protótipo é recosturado, o pacote é resubmetido — e nenhuma Task entra em construção antes da data de aprovação registrada (R20 · R25).

**Como ele evolui.** Vivo enquanto o pacote não é aprovado; **fechado na aprovação** — é o que o stakeholder viu, e alterá-lo depois é violação de escopo (R4). Correção de tela que apareça durante o sprint vai para a especificação viva em `screens/`, nunca para o protótipo aprovado. Encerrado o sprint, ele é **registro histórico**: responde "o que foi aprovado no sprint 3" sem depender da memória de ninguém.

## Como o protótipo funcional evolui

O protótipo é **documento vivo enquanto a fatia não fecha** (R12): mudança funcional aprovada que altere um fluxo principal atualiza o protótipo no mesmo ciclo. Depois que as Histórias daquela fatia foram entregues e aceitas, ele vira **registro histórico** — a fonte da verdade passa a ser o produto, e o QA valida contra o SDD, não contra o protótipo.

Divergência entre protótipo e produto **depois** do aceite não é defeito do produto: é protótipo vencido, e o UX o marca como tal.
