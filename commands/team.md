---
description: Fala com o time inteiro — envia uma mensagem, comando ou dúvida a todos os papéis e devolve as respostas individuais, um acordo coletivo, ou executa um ciclo completo de construção.
argument-hint: "init | <mensagem ou pergunta> | brainstorm <ideia> | agreement <questão> | cycle <ID>"
---

Aciona **o time inteiro**: Scrum Master (`scrum-master`), Product Owner (`product-owner`), Arquiteto (`architect`), UX (`user-experience`), Desenvolvedor (`developer`) e QA (`quality-assurance`).

Mensagem do stakeholder: **$ARGUMENTS**

> Para falar com **um** papel, use o comando dedicado: `/sm`, `/po`, `/arc`, `/ux`, `/dev`, `/qa`. Este comando é para quando a mensagem interessa a mais de um papel — ou quando você quer as várias leituras antes de decidir.

Identifique o modo pelo primeiro termo. Sem termo reconhecido, o modo é **consulta**.

## Modo `init` — instalar o time neste projeto

Cria o `.team-project/`, que é a fonte de contexto do time. **Sem ele, todo papel para e pede que seja criado.** Não dispare agente nenhum: este modo é seu, e é conversa com o stakeholder.

1. **Se `.team-project/` já existir, pare** e diga o que já está lá. Nunca sobrescreva contexto existente — para revisar um contexto que já existe, o caminho é `/sm onboarding`.

2. **Crie a estrutura**, a partir de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/project-context.md`:

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

Os arquivos-semente saem dos modelos do plugin: `work-board.md`, `product-backlog.md` e `evidence.md` dos `templates/` dos respectivos papéis; os seis `context.md` da seção "O que vai em cada `context.md`" do modelo de contexto. `plans/`, `journeys/` e `screens/` nascem vazios — são preenchidos por `/arc plan` e `/ux`. O `how-to.md` é **cópia literal** de `${CLAUDE_PLUGIN_ROOT}/how-to.md`, com um comentário no topo dizendo que não deve ser editado ali — é o guia de uso à mão de quem trabalha no projeto.

3. **Pergunte ao stakeholder**, numa lista só, o que nenhum arquivo do repositório responde: o que é o produto e para quem · a stack e onde cada parte vive · os comandos reais de build/teste/lint e o que o ambiente **não** consegue rodar · a capacidade do time (quantos devs, unidade de estimativa) · se é projeto novo ou retomada. Antes de perguntar, **leia o repositório** — README, arquivos de projeto, CI, compose — e traga preenchido tudo o que já der para inferir, com o que inferiu marcado como tal. Perguntar o que está escrito no repo é desperdício (R9).

4. **Escreva o `README.md`** com as respostas, incluindo a seção compacta "Como usar o time neste projeto" prevista no modelo. O guia completo **não** entra no `README.md`: ele é lido pelos agentes em toda invocação, e documentação de uso ali é custo permanente. O guia fica ao lado, em `.team-project/how-to.md`, copiado no passo 2.

5. **Aponte o próximo passo**, conforme a resposta do item 3:
   - **projeto retomado** → `/sm onboarding`, depois `/qa audit` e `/qa baseline` — o levantamento sobre código vira o backlog inicial;
   - **projeto novo com ideia ainda aberta** → `/team brainstorm <ideia>`;
   - **projeto novo com requisitos já claros** → `/po analyze <visão do produto>`.

Ao final, liste os arquivos criados e as decisões que ficaram pendentes do stakeholder.

## Modo `consult` (padrão) — `/team <mensagem ou pergunta>`

Broadcast: todos os papéis recebem a mesma mensagem e respondem **do seu ângulo**.

1. **Antes de disparar**, avalie se a mensagem pertence claramente a um único papel. Se pertencer, diga isso e sugira o comando individual — acionar cinco agentes para uma pergunta de um só é desperdício de contexto (regra R3). Só siga se o stakeholder insistir.
2. Dispare os seis agentes **em paralelo** (`run_in_background: true`), cada um recebendo:
   - a mensagem literal do stakeholder;
   - a instrução de ler `.team-project/README.md` e o `context.md` do seu papel antes de responder;
   - a regra de responder **só do seu papel**, em no máximo 10 linhas, e de dizer *"nada a acrescentar do meu papel"* quando for o caso — resposta curta e honesta vale mais que texto de preenchimento;
   - a regra de **não escrever em disco**: consulta é conversa, não execução. Nenhum documento é alterado a menos que a mensagem peça explicitamente.
3. Consolide as respostas para o stakeholder:

```
## Time — <mensagem> — <data>

| Papel | Posição | Impacto no seu domínio |
|---|---|---|
| Scrum Master | <uma linha> | <prazo, fila, risco> |
| Product Owner | <uma linha> | <requisito, escopo, aceite> |
| Arquiteto | <uma linha> | <desenho, contrato, dívida> |
| UX | <uma linha> | <jornada, tela, usabilidade, acessibilidade> |
| Desenvolvedor | <uma linha> | <execução, esforço, armadilha> |
| QA | <uma linha> | <verificabilidade, evidência, risco> |

**Convergências:** <no que todos concordam>
**Divergências:** <quem discorda de quem, e sobre o quê>
**Precisa da sua decisão:** <o que só o stakeholder resolve — ou "nada">
**Próxima ação sugerida:** <comando individual, item no quadro, ou nada>
```

## Modo `brainstorm <ideia>` — descoberta funcional de ideia sem documentação

Acionado quando a ideia não tem cobertura em visão geral / requisitos / fluxos (R15, `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/workflow.md` §5b). Facilitado pelo Agent `scrum-master`, que mantém as fases, registra o delta de cada rodada e declara o fechamento — **não decide conteúdo funcional**. Ideia em área já documentada não entra aqui: vai por `/po analyze`.

### Fase 1 — funcional · só `product-owner` e `user-experience` (o stakeholder participa pela conversa)

1. Dispare os dois em paralelo (`run_in_background: true`) com a ideia literal e a instrução de ler `.team-project/README.md` + o `context.md` do papel. O PO conduz problema, regra e fronteira de escopo; o UX traz jornada, contexto de uso e implicações de usabilidade/acessibilidade.
2. O SM consolida um **brief funcional** — problema, usuários, jornada central, valor, o que entra / o que fica explicitamente fora, regras, casos de borda óbvios. **Não é um requisito.**
3. Se PO e UX convergem e o stakeholder confirma que corresponde à intenção, passe à fase 2. Senão, registre a divergência e itere a fase 1.

### Fase 2 — viabilidade e proposta · entra o `architect`

4. O Arquiteto avalia o brief: encaixe arquitetural, implicações de contrato/dados, risco de integração, dimensionamento grosseiro, alternativas, o que é barato × caro.
5. Rodada de análise e proposta: Arquiteto levanta restrições/opções → PO/UX ajustam o brief → Arquiteto reavalia. O SM registra o delta de cada rodada. O Arquiteto **aconselha, não reescreve requisito**; mudança funcional forçada por viabilidade é feita pelo PO; troca de escopo/custo além do mandato sobe ao stakeholder.

### Fechamento

Fecha quando: uma rodada de fase 2 sem nova objeção bloqueante (ponto fixo); o stakeholder confirma a intenção; a fronteira de escopo está escrita; premissas abertas têm dono; o Arquiteto declara, em um parágrafo, a ideia construível dentro da capacidade declarada — ou nomeia a restrição a aceitar.

### Transição para o SDD (conforme `${CLAUDE_PLUGIN_ROOT}/deliverables/README.md` — sem escrever os sete de uma vez)

- **PO** — `/po requirement <ID>` por requisito: `00-overview-objectives`, `01-requirements` (critério de aceite + como verificar), `02-flows-and-roles`, início do `06-changelog`, índice do SDD.
- **UX** — `/ux journey <fluxo>`: mapas de jornada das jornadas moldadas.
- **Arquiteto** — `/arc plan <ID>`: `03-architecture` (com Ficha de Vinculação de Stack §2b), `04-data-model`, `05-api-model`, só a fatia que a primeira entrega exige.
- **SM** — `/sm plan`: itens no quadro a partir dos requisitos.

**Não escreve em disco durante as fases** — o brief é conversa até o fechamento e não vira arquivo permanente sem lugar declarado em `.team-project/`.

## Modo `agreement <questão>` — quando você quer uma recomendação única

Duas rodadas:

1. **Posições** — igual à consulta: os cinco respondem em paralelo, cada um do seu ângulo.
2. **Consolidação** — envie todas as posições ao Agent `scrum-master`, que produz **uma recomendação única**, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/impact-analysis.md` quando houver impacto de escopo ou prazo. O SM registra a divergência que sobrou, com nome e motivo — não a apaga.

**Acordo coletivo não é votação.** A propriedade dos papéis continua valendo:

- questão de **requisito ou valor de produto** → os outros aconselham, **o PO decide**;
- questão de **desenho, contrato ou padrão** → os outros aconselham, **o Arquiteto decide**;
- questão de **jornada, tela, usabilidade ou acessibilidade** → os outros aconselham, **o UX decide**;
- questão de **prazo, fila ou processo** → **o SM decide**;
- questão de **evidência e qualidade** → **o QA decide**;
- questão **estratégica** (stack, provedor, custo, risco aceito, prioridade acima da ordem do SM) → **sobe ao stakeholder** com a recomendação do time e as posições divergentes.

Maioria não sobrepõe dono. Se o acordo contrariar o dono do assunto, isso é uma divergência a registrar — e possivelmente uma decisão sua.

## Modo `cycle <ID>` — o time construindo um item

Encadeia os papéis de construção, parando no primeiro problema:

0. **UX** — Agent `user-experience`, **só se o item tiver interface**: jornada e/ou especificação de tela com os seis estados e os critérios de acessibilidade, salva em `.team-project/user-experience/screens/<slug>.md`. Item sem interface pula esta etapa, e isso é dito explicitamente.
1. **Arquiteto** — Agent `architect`: diagnóstico com evidência, desenho, impacto e Plano de Execução salvo em `.team-project/architect/plans/<ID>-<slug>.md`, respeitando a capacidade declarada em `.team-project/`. Havendo especificação de tela, o plano **cita a especificação** e não a reinterpreta.
2. Resumo de 3 linhas ao stakeholder. Se o Arquiteto escalou algo (decisão estratégica, lacuna funcional), **pare aqui**.
3. **Desenvolvedor** — Agent `developer`, recebendo o caminho do plano e a regra de parar e reportar 🔺 GAP em vez de improvisar.
4. **Gap** — se o dev levantou 🔺 GAP: leve-o ao Agent `architect` (sem replanejar por conta própria) e devolva a decisão ao dev por SendMessage, preservando o contexto dele. Repita quantas vezes for preciso.
5. **QA** — Agent `quality-assurance`, recebendo o plano, a especificação de tela (se houver), o relatório do dev e o critério de aceite do PO: seis frentes (requisito, especificação técnica, segurança, testes/métricas, documentação, desempenho), execução real dos comandos de verificação do projeto, veredito ✅/⚠️/❌ endereçado ao stakeholder. Item com interface é validado também contra os seis estados e os critérios de acessibilidade da especificação.
6. Se o veredito for ⚠️ ou ❌, devolva os achados ao Arquiteto/dev e **não** siga para o aceite — achado de aderência de execução pode passar por `/arc comply <ID>` (sob demanda) antes do `/dev resume`; achado de processo (seção de standard omitida ou errada no plano) vai à fila do `/arc review`. O `/arc comply` **não** é etapa fixa do ciclo (`workflow.md` §4a). Se for ✅, informe que o item está pronto para `/po accept <ID>` e depois `/sm close <ID>`.

Modos parciais do ciclo: `plan <ID>` (só a etapa 1) · `build <ID>` (só a etapa 3, exige plano existente) · `qa <ID>` (só a etapa 5).

## Regras válidas em todos os modos

- **Todos os papéis leem `.team-project/` antes de agir.** Se esse diretório não existir, pare e peça ao stakeholder para criá-lo — nenhum papel opera sem contexto de projeto.
- **Consulta e acordo não escrevem em disco.** Se a resposta do time implicar mudança de documento, ela vira ação atribuída ao dono, executada pelo comando individual.
- **Cada papel responde só do seu domínio.** Papel que opina fora do seu escopo dilui a resposta e confunde a decisão.
- **Respeite a capacidade declarada:** com um único dev, os passos do plano são executados em sequência, sem faixas concorrentes.
- **Nenhuma afirmação de "funciona" sem saída real de comando**; o que não foi exercitado é declarado como não exercitado.
- **Cada papel escreve só o que lhe pertence:** Arquiteto (espec. técnica, ADRs, planos), QA (documentos de qualidade e evidências), SM (quadro e status), PO (requisitos e backlog), dev (só código, dentro do plano).

Ao final, repasse ao stakeholder a consolidação, o que exige decisão dele e a próxima ação recomendada.
