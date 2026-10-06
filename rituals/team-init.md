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
├── consumption.md            consumo fora de sprint (Nota pre-sprint;/entre-sprints;) — nasce com o cabeçalho e a tabela vazia, sem rotação
├── guards.json               configuração das guardas (hooks/COVERAGE.md) — cópia de deliverables/team-project/guards.json
├── sprints/                  registro de execução — um subdiretório por sprint; nasce vazio
│   └── <n>/                  planning.md · sprint-backlog.md · stories/ · plan/ · evidence/
│                             consumption.md · burndown.md · review.md · retrospective.md · plugin-report.md
├── scrum-master/             context.md
├── product-owner/            context.md · product-backlog.md
├── architect/                context.md · spikes/
├── user-experience/          context.md · prototype/ · journeys/ · screens/
├── developer/                context.md
└── quality-assurance/        context.md · baseline.md
```

**O manifesto do que criar, com a origem de cada arquivo e a classe de reconciliação, está em `${CLAUDE_PLUGIN_ROOT}/deliverables/team-project/README.md`** — é a lista única, e é ela que o `/team update` relê depois para reconciliar o que aqui foi instanciado. Em resumo: `product-backlog.md` sai do `templates/` do PO; os seis `context.md`, da seção "O que vai em cada `context.md`" do modelo de contexto. `sprints/`, `spikes/`, `prototype/`, `journeys/` e `screens/` nascem **vazios**. O `how-to.md` é **cópia literal** de `${CLAUDE_PLUGIN_ROOT}/how-to.md`, com um comentário no topo dizendo que não deve ser editado ali — é o guia de uso à mão de quem trabalha no projeto.

**`.gitignore` — o processo fica fora do git (R31).** Se o projeto é repositório git, acrescente (crie o arquivo se não existir) a linha `.team-project/` ao `.gitignore` da raiz. **Só acrescente**: nunca reescreva um `.gitignore` existente. O repositório recebe só o produto (código e `docs/`); o estado da gestão é local e sem histórico. Se `.team-project/` já estiver rastreado (`git ls-files .team-project` não vazio), não o altere aqui: aponte o passo 7b do `/team update`, que desrastreia e limpa o histórico com confirmação explícita do stakeholder em cada passo destrutivo.

**O que o `init` NÃO cria, e por quê.** `sprints/<n>/` e tudo dentro dela nascem na **Planning Meeting** (`/sm sprint plan`, `workflow-sprint.md` §5e Planning, passo 9) — o registro de execução pertence a um sprint, e sprint nenhum existe ainda. `baseline.md` nasce no `/qa baseline`, durante o onboarding. Semear esses arquivos vazios aqui produziria exatamente o defeito que R14 combate: estrutura que afirma um estado que o projeto não tem.

## 3. Pergunte ao stakeholder, numa lista só

O que nenhum arquivo do repositório responde: o que é o produto e para quem · a stack e onde cada parte vive · os comandos reais de build/teste/lint e o que o ambiente **não** consegue rodar · **a duração do sprint** e **a unidade de estimativa** (as duas vão para a §2a do `README.md` e são usadas na Planning Meeting) · a capacidade do time (quantos devs) · se é projeto novo ou retomada.

Antes de perguntar, **leia o repositório** — README, arquivos de projeto, CI, compose — e traga preenchido tudo o que já der para inferir, com o que inferiu marcado como tal. Perguntar o que está escrito no repo é desperdício (R9).

## 4. Escreva o `README.md`

Com as respostas, incluindo a seção compacta "Como usar o time neste projeto" prevista no modelo. O guia completo **não** entra no `README.md`: ele é lido pelos agentes em toda invocação, e documentação de uso ali é custo permanente. O guia fica ao lado, em `.team-project/how-to.md`, copiado no passo 2.

## 4a. Comandos do run (v3.44)

Com os comandos reais de build/teste/lint do passo 3, siga o **passo 7f de `${CLAUDE_PLUGIN_ROOT}/rituals/team-update.md`**: `runCommands` no `.team-project/guards.json`, um formulário só. Sem isso, o `sprint run` volta a depender de pedido de permissão do harness no meio da fila.

## 5. Aponte o próximo passo

Conforme a resposta do passo 3:

- **projeto retomado** → `/sm onboarding`, depois `/qa audit` e `/qa baseline` — o levantamento sobre código vira as primeiras Histórias;
- **projeto novo com ideia ainda aberta** → `/sm brainstorm <ideia>` e depois `/sm sdd`;
- **projeto novo com requisitos já claros** → `/po analyze <visão do produto>` e depois `/sm sdd`.

Em qualquer um dos três, o caminho depois é o mesmo: `/sm sdd` (SDD funcional → **①** → SDD técnico → **②** → Histórias) → `/sm sprint prepare` → `/sm sprint plan` → **③** (pacote de abertura).

Ao final, liste os arquivos criados e as decisões que ficaram pendentes do stakeholder.
