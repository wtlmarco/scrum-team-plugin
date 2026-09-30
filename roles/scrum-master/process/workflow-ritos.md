# Fluxo de Trabalho — Rituais de entrada (§5a onboarding · §5b brainstorm)

> **Dono:** SM · Parte do fluxo — o núcleo está em [`workflow.md`](workflow.md). **Lido só** em /sm onboarding e /sm brainstorm. A numeração das seções (§5a, §5b) é a de sempre; só o arquivo mudou (v3.34).

## 5a. Ritual de onboarding do projeto (R14)

Acontece **uma vez**, quando o time recebe um projeto novo ou retoma um abandonado, antes da primeira Planning Meeting. O SM coordena; os seis papéis participam. **A documentação existente do projeto é a primeira fonte — o stakeholder é consultado só sobre o que ela não responde.**

| # | Passo | Quem | O que produz |
|---|---|---|---|
| 1 | **Inventário das fontes** — listar o que existe: `.team-project/README.md`, o SDD, ADRs, os documentos de implementação, mapa de código, registro de GAPs | SM, sozinho | Tabela documento → existe? → última atualização → dono |
| 2 | **Lista de lacunas contra a documentação** — para cada coisa que o time precisa saber para planejar (objetivo do produto, fase, stack, ambiente, fontes da verdade, capacidade, duração do sprint, unidade de estimativa, restrições, riscos abertos), marcar: respondido pelo doc X / parcial / ausente | SM, sozinho | Lista de lacunas com origem |
| 3 | **Bifurcação** — (a) documentação funcional essencial **ausente** (sem visão geral, sem requisitos, sem fluxos) → abrir `/sm brainstorm` (§5b) e **pausar** o onboarding até ele fechar; (b) documentação **desatualizada ou contraditória** (ex.: status diz "concluído", GAPs dizem o contrário) → registrar a divergência como risco no quadro e acionar `/qa audit`; o onboarding segue com a divergência declarada, não arredondada | SM | Decisão de rota registrada |
| 4 | **Leitura de entrada do time** — cada um dos outros cinco papéis lê `.team-project/README.md` + o seu `context.md` e reporta, em ≤10 linhas: o que entendeu como seu mandato neste projeto, o que precisa e não está documentado, um risco que enxerga do seu ângulo | PO · Arquiteto · UX · dev · QA | Cinco leituras de entrada |
| 5 | **Consolidação + perguntas ao stakeholder** — o SM funde as leituras num quadro único e produz **uma** lista de perguntas que só o stakeholder responde: estratégicas (provedor, alvo da retomada, ordem de prioridade), a **duração do sprint** e a **unidade de estimativa** se ainda não estiverem no contexto, e lacunas funcionais pequenas que a documentação não cobriu e que não justificam um brainstorm. Cada pergunta segue a forma fixa de R22: por que bloqueia · alternativas descritas · recomendação do time (R9 — o time tentou responder antes) · a via de pedir mais contexto **sempre como última opção**, resolvida em formulário pela sessão que orquestra o onboarding, não em texto corrido | SM | Lista de decisões pendentes do stakeholder |
| 6 | **Registro do alinhamento** — o SM escreve o entendimento comum no contexto do projeto (`.team-project/README.md` e os `context.md` recebem aporte de cada papel) e abre o quadro de trabalho | SM | Contexto do projeto preenchido e datado, quadro aberto |

**O que o SM pergunta primeiro à documentação:** propósito e fase do produto (`00-overview`), requisitos e seus critérios de aceite (`01-requirements`), atores e fluxos (`02-flows`), princípios de arquitetura e vinculação de stack (`03-architecture`), contratos de dados e API (`04`/`05`), o que está construído e com que evidência (`02-status`, `03-code-map`, `pending`), ambiente e comandos de verificação, capacidade declarada, limitações conhecidas, riscos e bloqueios abertos.

**Os quatro documentos de implementação nascem quando o projeto os exige, não no `/team init`.** `01-scope-and-criteria`, `02-status`, `03-code-map` e `pending` não fazem parte do que o `init` semeia ([`deliverables/team-project/README.md`](../../../deliverables/team-project/README.md)) — nascem na primeira vez que o projeto precisa deles (retomada, primeiro fechamento de Task, primeira auditoria). O que faltava não era o manifesto listá-los antecipadamente: era **algo lembrar o SM de declará-los** quando nascem. Regra: todo documento de implementação, no instante em que nasce, entra na mesma sessão em `.team-project/README.md` §4 "Fontes da verdade" ([`templates/project-context.md`](../templates/project-context.md)), com o dono — nunca fica implícito só porque o caminho já é convenção. **Como o SM verifica:** todo caminho citado em `pending`/`02-status`/`03-code-map`/`01-scope-and-criteria` que já tem conteúdo real aparece como linha em `.team-project/README.md` §4; documento com conteúdo e sem linha em §4 é achado de processo contra o próprio SM.

**Rastreio de pendências e bugs existentes, sem duplicar `/qa audit`.** O onboarding é o primeiro momento em que o time vê o projeto — pendência e bug preexistentes que não forem capturados agora se perdem misturados ao trabalho novo. Três fontes, sem sobreposição:
- **Código, em projeto retomado:** já é a bifurcação (b) do passo 3 e a sequência declarada em `project-context.md` §8 ("Projeto retomado": `/sm onboarding` → `/qa audit` → `/qa baseline`) — o SM não duplica aqui, só confirma no inventário do passo 1 que o registro de GAPs vai nascer dessa sequência, se ainda não existir.
- **Documentação herdada divergente:** também é a bifurcação (b) do passo 3 — vira risco no quadro e aciona `/qa audit`.
- **O que o stakeholder já sabe estar quebrado, e ainda não está escrito em lugar nenhum:** é o que faltava. No passo 5, o SM pergunta explicitamente por isso, e cada item vira relato roteado ao **PO** (`/po bug <relato>`, §6a) — nunca uma entrada direta em `pending.md`, que continua sendo escrita só pela QA depois de confirmar.

**O que o SM escala ao stakeholder** (só depois de esgotar a documentação e o time): decisões estratégicas (stack, provedor, custo, alvo da retomada, prioridade acima da ordem de dependência do SM), os dois parâmetros de cadência (duração do sprint, unidade de estimativa) e lacunas funcionais pequenas não respondíveis pela documentação — sempre na forma fixa de R22: opções descritas, recomendação e a via de pedir mais contexto, resolvida em formulário, não em texto corrido.

**Condição de saída — o onboarding está pronto quando:**
- [ ] Toda linha do inventário de fontes está preenchida (existe / desatualizada / ausente), e toda "ausência de doc funcional essencial" foi produzida via brainstorm ou aceita como risco pelo stakeholder.
- [ ] Os outros cinco papéis registraram a leitura de entrada (mandato entendido + o que falta + um risco); o SM coordena e consolida, não escreve uma sobre si.
- [ ] A lista de perguntas só-do-stakeholder foi respondida ou explicitamente adiada com o risco aceito.
- [ ] `.team-project/README.md` reflete o entendimento alinhado (objetivo, fase, stack, ambiente, fontes da verdade, capacidade, **duração do sprint**, **unidade de estimativa**, restrições) e toda divergência status × código está no quadro como risco.
- [ ] O quadro existe, com ao menos uma onda de Histórias candidatas, ou uma nota de que o planejamento está bloqueado aguardando brainstorm/decisão do stakeholder.
- [ ] Pendências e bugs preexistentes estão rastreados — por `/qa audit`+`/qa baseline` (projeto retomado) ou por relato do stakeholder roteado ao PO (`/po bug`, projeto novo com defeito conhecido) — nunca perdidos por não caberem em nenhuma pergunta do onboarding.

**Como o SM verifica que aconteceu:** a resposta do onboarding traz a tabela de inventário preenchida e as cinco leituras de entrada; `.team-project/README.md` está datado em/após o onboarding com §4 e §7 populadas; nenhuma Planning Meeting do projeto precede o registro de onboarding; toda divergência narrativa × código é linha na tabela de riscos do quadro; todo documento de implementação com conteúdo real tem linha em §4; e o passo 5 registra a pergunta ao stakeholder sobre defeito conhecido ainda não documentado, mesmo quando a resposta é "nenhum".

## 5b. Ritual de brainstorm de descoberta (R15)

Acionado quando o stakeholder traz uma ideia — um desejo dele — para a qual **não há cobertura** em visão geral / requisitos / fluxos: produto greenfield ou área de capacidade genuinamente nova. Ideia em área já documentada vai por `/po analyze`, não por aqui. O SM **facilita** (abre a sessão, mantém as fases, registra convergência/divergência, declara o fechamento) e **não decide conteúdo funcional**.

**Comando: `/sm brainstorm <ideia>`** (v3.34; antes `/team brainstorm`, **sem alias** — coerente com a remoção de `cycle|plan|build|qa`). É **descoberta, fora da cadência do sprint** (`prepare → plan → run → review → close`). Como `prepare` e `run`, é **orquestrado pela sessão**: ela dispara PO e UX em paralelo na fase 1 e o Arquiteto em rodadas na fase 2, e aciona o Agent `scrum-master` só para facilitar (manter as fases, consolidar o brief, registrar o delta, declarar o fechamento). Não escreve em disco durante as fases.

### Fase 1 — Formação funcional · participantes: stakeholder + PO + UX

Objetivo: um **entendimento funcional base** — o problema do usuário, quem são os usuários, a jornada central, o valor, a fronteira grosseira de escopo (o que está dentro / explicitamente fora), as regras principais, os casos de borda óbvios.

- O PO conduz o enquadramento funcional (problema, regra, escopo); o UX contribui a jornada, o contexto de uso e as implicações de usabilidade/acessibilidade; o stakeholder fornece intenção e restrições e responde perguntas diretamente — aqui o diálogo direto com o stakeholder é o **mecanismo de co-criação**, não uma falha de escalação (R9).
- Arquiteto, dev e QA **não** entram na fase 1 — de propósito, para a forma funcional se estabelecer sem restrição técnica prematura.
- Saída da fase 1: um **brief funcional** — ainda não um requisito formal, e muito menos uma História. É o insumo que o PO transforma em `01-requirements` / `00-overview` / `02-flows` e o UX em jornadas.
- Fecha quando PO e UX concordam que a ideia tem base funcional estável e o stakeholder confirma que corresponde à intenção.

### Fase 2 — Viabilidade e proposta · participantes: + Arquiteto

- O Arquiteto avalia o brief funcional quanto a viabilidade: encaixe arquitetural, implicações de contrato/dados, risco de integração, dimensionamento grosseiro, alternativas, o que é barato × caro.
- **Rodada de análise e proposta:** Arquiteto levanta restrições/opções → PO/UX ajustam o brief funcional → Arquiteto reavalia. Repete. O SM registra o delta de cada rodada.
- O Arquiteto **aconselha**; não reescreve requisito. Se a viabilidade força mudança funcional, quem muda é o PO (propriedade inalterada). Se força troca de escopo/custo além do mandato do time, sobe ao stakeholder.

### Critério de convergência — o brainstorm está fechado quando:
- [ ] O brief funcional ficou estável numa rodada inteira de fase 2 sem nova objeção bloqueante do Arquiteto (ponto fixo).
- [ ] O stakeholder confirma que a ideia moldada ainda corresponde à intenção.
- [ ] A fronteira de escopo está escrita: o que entra na primeira fatia, o que fica explicitamente adiado.
- [ ] Toda pergunta funcional aberta foi respondida ou está listada como premissa conhecida, com dono.
- [ ] O Arquiteto declarou, em um parágrafo, que a ideia moldada é construível dentro da capacidade declarada — ou nomeou a restrição que precisa ser aceita.

### Transição para o SDD — agora é o `/sm sdd` (§5h)
No fechamento, o SM registra o fechamento do brainstorm e o **próximo passo é `/sm sdd`**, que conduz a transição inteira — SDD funcional, protótipo, portão ①, SDD técnico da primeira fatia, portão ②, Histórias — **na ordem dos portões ① e ② de §8**, sem escrever os sete documentos de uma vez. O roteiro (entradas, etapas, quem é despachado, formulários, retomada, o que não faz) é a **§5h**, em [`workflow-sdd.md`](workflow-sdd.md) — que substitui a antiga tabela desta seção e a sequência manual `/po requirement` → `/ux prototype` → `/arc` → `/po story`. Ideia em **área já documentada** também usa o `sdd`, depois do `/po analyze` (caso B).

O brief de brainstorm **não** é entregável permanente: é absorvido por `00-overview` / `01-requirements` e pelo registro de processo. **Único lugar declarado onde ele vive até o SDD sair: `.team-project/scrum-master/context.md` §"SDD em elaboração"** (até 15 linhas, aberto pelo `/sm sdd` — §5h); não vira outro arquivo.

**Como o SM verifica:** a saída do brainstorm mostra as duas fases com os participantes declarados — fase 1 sem o Arquiteto, fase 2 com ele; cada rodada de fase 2 tem delta registrado ou "sem mudança — ponto fixo"; o critério de convergência está cumprido antes do `/sm sdd`; o brief não virou arquivo fora de `context.md` §"SDD em elaboração". **A verificação dos portões ① e ② e das Histórias mora em [`workflow-sdd.md`](workflow-sdd.md) §5h** (nenhum `03`/`04`/`05` antes do ①, nenhuma História antes do ②).
