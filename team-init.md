# `/team init` — instalar o time neste projeto

> Lido **apenas quando `/team` entra no modo `init`**. Roda **uma vez por projeto**, e por isso não fica em `commands/team.md`: aquele arquivo é injetado no prompt em *toda* invocação de `/team`, inclusive nas milhares que nunca usam `init`.

Cria o `.team-project/`, que é a fonte de contexto do time. **Sem ele, todo papel para e pede que seja criado.** Não dispare agente nenhum: este modo é do comando, e é conversa com o stakeholder.

## 1. Se `.team-project/` já existir, pare

Diga o que já está lá. Nunca sobrescreva contexto existente — para revisar um contexto que já existe, o caminho é `/sm onboarding`.

## 2. Crie a estrutura

A partir de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/project-context.md`:

```
.team-project/
├── README.md                 produto · situação · stack · fontes da verdade · ambiente · limitações
├── how-to.md                 cópia de `${CLAUDE_PLUGIN_ROOT}/how-to.md`
├── scrum-master/             context.md · work-board.md
├── product-owner/            context.md · product-backlog.md
├── architect/                context.md · plans/
├── user-experience/          context.md · journeys/ · screens/
├── developer/                context.md
└── quality-assurance/        context.md · evidence.md
```

**O manifesto do que criar, com a origem de cada arquivo e a classe de reconciliação, está em `${CLAUDE_PLUGIN_ROOT}/deliverables/team-project/README.md`** — é a lista única, e é ela que o `/team update` relê depois para reconciliar o que aqui foi instanciado. Em resumo: `work-board.md`, `product-backlog.md` e `evidence.md` saem dos `templates/` dos respectivos papéis; os seis `context.md`, da seção "O que vai em cada `context.md`" do modelo de contexto. `plans/`, `journeys/` e `screens/` nascem vazios — são preenchidos por `/arc plan` e `/ux`. O `how-to.md` é **cópia literal** de `${CLAUDE_PLUGIN_ROOT}/how-to.md`, com um comentário no topo dizendo que não deve ser editado ali — é o guia de uso à mão de quem trabalha no projeto.

## 3. Pergunte ao stakeholder, numa lista só

O que nenhum arquivo do repositório responde: o que é o produto e para quem · a stack e onde cada parte vive · os comandos reais de build/teste/lint e o que o ambiente **não** consegue rodar · **a duração do sprint** e **a unidade de estimativa** (as duas vão para a §2a do `README.md` e são usadas na Planning Meeting) · a capacidade do time (quantos devs) · se é projeto novo ou retomada.

Antes de perguntar, **leia o repositório** — README, arquivos de projeto, CI, compose — e traga preenchido tudo o que já der para inferir, com o que inferiu marcado como tal. Perguntar o que está escrito no repo é desperdício (R9).

## 4. Escreva o `README.md`

Com as respostas, incluindo a seção compacta "Como usar o time neste projeto" prevista no modelo. O guia completo **não** entra no `README.md`: ele é lido pelos agentes em toda invocação, e documentação de uso ali é custo permanente. O guia fica ao lado, em `.team-project/how-to.md`, copiado no passo 2.

## 5. Aponte o próximo passo

Conforme a resposta do passo 3:

- **projeto retomado** → `/sm onboarding`, depois `/qa audit` e `/qa baseline` — o levantamento sobre código vira as primeiras Histórias;
- **projeto novo com ideia ainda aberta** → `/team brainstorm <ideia>`;
- **projeto novo com requisitos já claros** → `/po analyze <visão do produto>`.

Em qualquer um dos três, o caminho depois é o mesmo: SDD funcional → **①** → SDD técnico → **②** → `/po story` → detalhamento → **③** → `/sm sprint plan`.

Ao final, liste os arquivos criados e as decisões que ficaram pendentes do stakeholder.
