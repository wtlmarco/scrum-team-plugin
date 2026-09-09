---
description: Orquestra o time trabalhando — instala, atualiza ou informa a versão do time no projeto, conduz o brainstorm de descoberta, ou executa um ciclo de construção de uma Task. Não é broadcast: mensagem solta é roteada ao papel dono.
argument-hint: "init | update | version | brainstorm <ideia> | cycle <T-ID> | plan <T-ID> | build <T-ID> | qa <T-ID>"
---

Orquestra **o time trabalhando**: Scrum Master (`scrum-master`), Product Owner (`product-owner`), Arquiteto (`architect`), UX (`user-experience`), Desenvolvedor (`developer`) e QA (`quality-assurance`).

Mensagem do stakeholder: **$ARGUMENTS**

> **Este comando não é um canal de conversa.** O canal do stakeholder é o **PO** ([`workflow.md` §6a](../roles/scrum-master/process/workflow.md)) — demanda, valor, escopo, prioridade, prazo, status e plano de entrega. Questão técnica vai ao Arquiteto e de tela ao UX, diretamente. Questão que atravessa papéis vai por `/sm agreement`. Aqui só se **instala** (`init`), **atualiza** (`update`), **descobre** (`brainstorm`) ou **constrói** (`cycle` e suas fatias).

Identifique o modo pelo primeiro termo. **Sem termo reconhecido, não dispare agente nenhum** — roteie, conforme a tabela abaixo.

## Modo `init` — instalar o time neste projeto

**Leia `${CLAUDE_PLUGIN_ROOT}/team-init.md` e siga-o** — os cinco passos do ritual estão lá. Só neste modo: `init` roda uma vez por projeto e não paga contexto nas demais invocações.

Não dispare agente nenhum: este modo é seu, e é conversa com o stakeholder.

## Modo `update` — atualizar o plugin do time neste projeto

**Leia `${CLAUDE_PLUGIN_ROOT}/team-update.md` e siga-o** — os oito passos estão lá, incluindo a **reconciliação do `.team-project/`** com os modelos da versão nova (passo 7). Só neste modo: `update` roda uma vez por bump de versão e não paga contexto nas demais invocações.

Não dispare agente nenhum: este modo é do comando, e é conversa com o stakeholder.

## Modo `version` — que versão está rodando aqui

**Leia `${CLAUDE_PLUGIN_ROOT}/team-version.md` e siga-o.** Versão instalada, o que ela trouxe, guia rápido de comandos e o que o time custa em contexto. **Não usa rede** — quem verifica se há versão nova é o `update`.

Não dispare agente nenhum.

## Sem modo reconhecido — roteie, não dispare

**Não existe broadcast.** `/team` não fala com os seis papéis: ele **orquestra o time trabalhando**. Mensagem solta ou pergunta livre não dispara agente nenhum — responda com a rota certa:

| O que o stakeholder trouxe | Rota |
|---|---|
| demanda, valor, escopo, prioridade, **prazo**, **status**, plano de entrega | **`/po`** — o PO é o canal do stakeholder ([`workflow.md` §6a](../roles/scrum-master/process/workflow.md)) |
| dúvida técnica, desenho, contrato, dívida | `/arc question <dúvida>` |
| jornada, tela, usabilidade, acessibilidade | `/ux` |
| questão que atravessa papéis e precisa de **uma** posição | `/sm agreement <questão>` — o SM chama só quem a questão toca |
| ideia sem cobertura em visão geral / requisitos / fluxos | `/team brainstorm <ideia>` (R15) |

Diga qual é a rota e por quê, em uma linha. **Não peça permissão para rotear** e não dispare os seis "por garantia": reunir seis papéis para uma pergunta de um é desperdício de contexto (R3), e era o modo mais caro do time.

## Modo `brainstorm <ideia>` — descoberta funcional de ideia sem documentação

Acionado quando a ideia não tem cobertura em visão geral / requisitos / fluxos (R15). Ideia em área já documentada não entra aqui: vai por `/po analyze`.

**O ritual completo — as duas fases, o critério de convergência e a transição para o SDD — está em `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/workflow.md` §5b. Leia-o antes de conduzir**, e não o reproduza aqui.

O que este comando faz na prática:

1. **Fase 1** — dispare `product-owner` e `user-experience` em paralelo (`run_in_background: true`) com a ideia literal e a instrução de ler `.team-project/README.md` + o `context.md` do papel. O Arquiteto **não** entra nesta fase.
2. **Fase 2** — entra o `architect`, em rodadas de análise → ajuste → reavaliação até ponto fixo.
3. O Agent `scrum-master` **facilita**: mantém as fases, consolida o brief, registra o delta de cada rodada e declara o fechamento — **não decide conteúdo funcional**.

**Não escreve em disco durante as fases** — o brief é conversa até o fechamento e não vira arquivo permanente sem lugar declarado em `.team-project/`.

## Modo `cycle <ID>` — o time construindo uma Task

Encadeia os papéis de construção, parando no primeiro problema:

0. **UX** — Agent `user-experience`, **só se a Task tiver interface**: jornada e/ou especificação de tela com os seis estados e os critérios de acessibilidade, salva em `.team-project/user-experience/screens/<slug>.md`. Task sem interface pula esta etapa, e isso é dito explicitamente.
1. **Arquiteto** — Agent `architect`: diagnóstico com evidência, desenho, impacto e Plano de Implementação salvo em `.team-project/architect/plans/<ID>-<slug>.md`, respeitando a capacidade declarada em `.team-project/`. Havendo especificação de tela, o plano **cita a especificação** e não a reinterpreta.
2. Resumo de 3 linhas ao stakeholder. Se o Arquiteto escalou algo (decisão estratégica, lacuna funcional), **pare aqui**.
3. **Desenvolvedor** — Agent `developer`, recebendo o caminho do plano e a regra de parar e reportar 🔺 GAP em vez de improvisar.
4. **Gap** — se o dev levantou 🔺 GAP: leve-o ao Agent `architect` (sem replanejar por conta própria) e devolva a decisão ao dev por SendMessage, preservando o contexto dele. Repita quantas vezes for preciso.
5. **QA** — Agent `quality-assurance`, recebendo o plano, a especificação de tela (se houver), o relatório do dev e o critério de aceite do PO: seis frentes (requisito, especificação técnica, segurança, testes/métricas, documentação, desempenho), execução real dos comandos de verificação do projeto, veredito ✅/⚠️/❌ endereçado ao stakeholder. Task com interface é validado também contra os seis estados e os critérios de acessibilidade da especificação.
6. Se o veredito for ⚠️ ou ❌, devolva os achados ao Arquiteto/dev e **não** siga para o aceite — achado de aderência de execução pode passar por `/arc comply <ID>` (sob demanda) antes do `/dev resume`; achado de processo (seção de standard omitida ou errada no plano) vai à fila do `/review`. O `/arc comply` **não** é etapa fixa do ciclo (`workflow.md` §4a). Se for ✅, informe que a Task está pronto para `/po accept <ID>` e depois `/sm close <ID>`.

Modos parciais do ciclo: `plan <ID>` (só a etapa 1) · `build <ID>` (só a etapa 3, exige plano existente) · `qa <ID>` (só a etapa 5).

## Regras válidas em todos os modos

- **Todos os papéis leem `.team-project/` antes de agir.** Se esse diretório não existir, pare e peça ao stakeholder para criá-lo — nenhum papel opera sem contexto de projeto.
- **Consulta e acordo não escrevem em disco.** Se a resposta do time implicar mudança de documento, ela vira ação atribuída ao dono, executada pelo comando individual.
- **Cada papel responde só do seu domínio.** Papel que opina fora do seu escopo dilui a resposta e confunde a decisão.
- **Respeite a capacidade declarada:** com um único dev, os passos do plano são executados em sequência, sem faixas concorrentes.
- **Nenhuma afirmação de "funciona" sem saída real de comando**; o que não foi exercitado é declarado como não exercitado.
- **Cada papel escreve só o que lhe pertence:** Arquiteto (espec. técnica, ADRs, planos), QA (documentos de qualidade e evidências), SM (quadro e status), PO (requisitos e backlog), dev (só código, dentro do plano).

Ao final, repasse ao stakeholder a consolidação, o que exige decisão dele e a próxima ação recomendada.
