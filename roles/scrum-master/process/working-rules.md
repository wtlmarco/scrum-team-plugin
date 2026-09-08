# Regras de Trabalho — Máxima Eficiência e Qualidade

> **Dono:** SM · **Alcance:** todos os papéis, inclusive o stakeholder · **Natureza:** normativa
> Estas regras não são conselhos. São o contrato de trabalho do time. O SM verifica o cumprimento a cada sprint e registra a violação como achado de processo — do mesmo jeito que o QA registra um achado de código.

Cada regra existe porque um **modo de falha recorrente** a produziu. A coluna "evita" nomeia esse modo de falha.

---

## Bloco A — Eficiência

### R1. Uma Task por vez, do plano ao veredito
Respeite a capacidade declarada no contexto do projeto. Com um único desenvolvedor, a construção é uma **fila**: nada de abrir a segunda Task porque a primeira "está quase". O paralelismo permitido é **entre papéis** — dev constrói a Task *n*, Arquiteto planeja a *n+1*, PO detalha a História do sprint seguinte.

**Evita:** duas Tasks 90% prontas e nenhuma História entregável.
**SM verifica:** no máximo uma Task em construção por dev disponível.

### R2. Task cabe em uma unidade de trabalho
Plano com mais de ~10 passos, ou tocando duas áreas do sistema ao mesmo tempo, é quebrado em `<ID>a`/`<ID>b` encadeados antes de entrar em construção — sempre dentro da mesma História.

**Evita:** trabalho que atravessa sprints, perde contexto e volta com metade da intenção original.
**SM verifica:** estimativa dentro da unidade para toda Task do Sprint Backlog; Task que estourar 2× a estimativa vira alerta na retrospectiva.

### R3. Contexto mínimo suficiente
Ninguém carrega documentação inteira "por precaução". Cada papel lê a seção que a tarefa exige, listada no plano ou na tabela de fontes da verdade do contexto do projeto. Um inventário de código existe justamente para saber **qual arquivo pedir** sem abrir o repositório todo.

**Evita:** desperdício de contexto e diluição do que importa.
**SM verifica:** plano lista "contexto de código a ler" com caminhos exatos e o porquê de cada um.

### R4. Não antecipar escopo
Implementa-se a Task, não o "enquanto isso". Sem refatoração oportunista, sem TODO especulativo, sem abstração para caso futuro, sem dependência nova fora do plano. No nível do lote, o Sprint Backlog fechado na Planning não cresce durante o sprint (§5e).

**Evita:** scope creep silencioso — trabalho que ninguém pediu, ninguém revisou e ninguém sabe justificar depois.
**SM verifica:** relatório do dev traz a seção "Não fiz (fora do plano)" preenchida; QA confere o diff contra a lista de arquivos do plano; entrada de escopo fora da Planning tem a linha "o que saiu para caber".

### R5. Interrupção é estado, não perda
Quem para no meio registra **em que passo parou e como o repositório ficou** (compila? testes passam?). Os passos do plano são ordenados para o repositório ficar íntegro no maior número possível de pontos intermediários.

**Evita:** retomada que refaz trabalho já feito ou que herda base quebrada.
**SM verifica:** relatório de entrega tem a linha "Parei no passo"; Task inacabada no fim do sprint volta ao Product Backlog junto com a História, não some.

### R6. Decisão tomada é decisão registrada
Toda decisão fora do que a especificação já dizia vira registro — entrada no documento de status (via SM) ou ADR quando for estrutural e recorrente. Nunca embutida silenciosamente no código.

**Evita:** arqueologia. Um projeto só é retomável meses depois se as decisões foram escritas.
**SM verifica:** toda Task fechada com desvio tem entrada correspondente.

---

## Bloco B — Qualidade

### R7. Sem evidência, não aconteceu
"Funciona", "build ok", "testes passando" não são afirmações válidas sem a **saída real do comando**. O que não pôde ser executado é declarado **não exercitado**, com o motivo.

**Evita:** o modo de falha mais caro que existe — funcionalidade declarada como concluída sem que nenhum caminho de sucesso jamais tenha sido exercitado.
**SM verifica:** toda Task fechada tem bloco no registro de evidências, com comando e saída; todo critério de aceite de História demonstrado na Review aponta a evidência da Task que o cumpre.

### R8. Sem plano, sem código
O dev não escreve uma linha sem **Plano de Implementação** do Arquiteto — o conteúdo técnico da Task. Plano que não cobre o que apareceu no código vira 🔺 GAP, não improviso. No nível funcional, a mesma regra vale antes: História sem detalhamento aprovado não é quebrada em Tasks (R20).

**Evita:** deriva de especificação e de código — decisão de desenho tomada por quem tem menos contexto, no meio da implementação.
**SM verifica:** existe plano para toda Task em construção.

### R9. Gap vira pergunta, nunca palpite
Quem não sabe, escala: dev → Arquiteto; funcional → PO; estratégico → stakeholder. E quem recebe **decide**, não devolve a pergunta.

**Evita:** improviso que passa despercebido na revisão e vira padrão por repetição.
**SM verifica:** gaps registrados e respondidos; gap sem resposta há mais de um sprint vira bloqueio no quadro.

### R10. Nomenclatura existente é contrato
Classe, campo, enum, rota, nome de migration saem **exatamente** como na especificação. Renomear é mudança (passa pelo PO/Arquiteto), não melhoria.

**Evita:** divergência entre documento e código que só aparece meses depois, em auditoria.
**SM verifica:** achado de nomenclatura no veredito do QA conta como reprovação, não como ressalva.

### R11. Segurança entra no plano, não na revisão
Task que toca autenticação, autorização, escopo/tenant, dado pessoal ou conteúdo de terceiro traz, **no Plano de Implementação**, a regra aplicável dos padrões de engenharia: identidade do contexto autenticado, autorização explícita com permissão real, isolamento coberto por teste, auditoria da ação sensível, segredo validado no start.

**Evita:** furos que atravessam sprints inteiros porque segurança era etapa final — fluxo sensível sem verificação de permissão, chave de assinatura vazia, ação crítica sem registro de auditoria.
**SM verifica:** Task marcada como sensível sem seção de segurança no plano não entra em construção.

### R12. Documento vivo se atualiza no mesmo ciclo
Product Backlog, Sprint Backlog, evidências, inventário de código, registro de GAPs e documento de status são atualizados **no ciclo em que o fato aconteceu**, por seus donos. Nunca "depois". Gaps e débitos levantados na Sprint Review entram no Product Backlog na mesma sessão.

**Evita:** documentação que descreve um projeto que não existe mais.
**SM verifica:** fechamento de Task exige as atualizações; sem elas, a Task não fecha. Review sem os gaps registrados não encerra o sprint.

---

## Bloco C — Método

### R13. O instrumento de dimensionamento e de controle é escolhido pelo gatilho, não por hábito
Scrum é o padrão do time — estimativa na unidade do projeto feita pelo time na Planning, quadro como registro de risco, `/sm impact` para mudança, fila por dependência. O SM aciona um instrumento de **APF** (contagem de pontos de função) ou de **PMBOK** (registro formal de riscos, controle integrado de mudanças, EAP, baseline de escopo) quando um gatilho objetivo de [`../skills.md` §9](../skills.md) ocorre — e **nomeia o gatilho na saída** (plano, análise de impacto, status). Resultado de APF é convertido para a unidade de estimativa declarada no contexto do projeto; instrumento formal criado ganha entrada no [changelog do processo](process-changelog.md).

**Evita:** dois modos de falha opostos — dimensionar "no olho" um escopo grande porque a única ferramenta à mão era estimativa relativa, e o projeto ser declarado concluído com metade do trabalho ainda aberto; e afogar um projeto pequeno em artefato de PMBOK que ninguém mantém.
**SM verifica:** em toda História acima de 3× a unidade de trabalho, em todo status com mais de 5 riscos abertos e em toda mudança que toca baseline acordada ou contrato já implantado, a saída traz **ou** o instrumento formal **ou** a justificativa explícita de por que a abordagem Scrum ainda basta.

### R14. Projeto novo ou retomado passa por onboarding antes da primeira Planning Meeting
Nenhuma Planning Meeting roda num projeto — recém-recebido ou retomado após interrupção — sem um **onboarding** concluído: inventário das fontes de documentação do projeto, leitura de entrada dos seis papéis, lista única de perguntas ao stakeholder (só o que a documentação não respondeu, incluindo **duração do sprint** e **unidade de estimativa**) e registro do entendimento alinhado no contexto do projeto. **A documentação existente é interrogada primeiro; o stakeholder é a segunda fonte, não a primeira.** Documentação funcional essencial ausente — sem visão geral, sem requisitos, sem fluxos — aciona o `brainstorm` (R15), e o onboarding fica pausado até ele fechar. O roteiro está em [`workflow.md` §5a](workflow.md) e [`../skills.md` §10](../skills.md).

**Evita:** o time planejar e construir sobre um entendimento presumido do projeto — o modo de falha que produziu "14 sprints concluídas" convivendo com 50 GAPs, porque ninguém cruzou o código contra a narrativa antes de comprometer um plano.
**SM verifica:** a primeira Planning Meeting do projeto cita o registro de onboarding; a checklist de saída do onboarding está completa; `.team-project/README.md` §4 (fontes da verdade) e §7 (decisões pendentes do stakeholder) estão preenchidas e datadas, com a duração do sprint e a unidade de estimativa declaradas; toda divergência entre narrativa de status e código encontrada no onboarding é uma linha na tabela de riscos do quadro. Projeto já em andamento quando R14 passou a valer faz um **onboarding retroativo** uma vez, registrado no changelog do processo.

### R15. Ideia sem documentação passa por brainstorm, e o SDD sobe por dois portões — o ① com protótipo navegado
Ideia nova cuja área **não tem cobertura** em visão geral / requisitos / fluxos passa por um `brainstorm` em duas fases antes de qualquer documento do SDD ser escrito: **fase 1** funcional, com stakeholder + PO + UX; **fase 2** de viabilidade e proposta, entrando o Arquiteto, em rodadas de análise até um ponto fixo. Ideia que cai em área **já documentada** vai por `/po analyze`, como sempre. Fechado o brainstorm, o SDD é elaborado em duas etapas com aprovação entre elas: **portão ①** — o UX entrega o **protótipo funcional em HTML** cobrindo os fluxos principais, o stakeholder **navega** e aprova o **SDD funcional** (`00`, `01`, `02`), e só então o Arquiteto escreve o **SDD técnico** (`03`, `04`, `05`); **portão ②** — aprovado o técnico, o PO escreve as Histórias. **O protótipo é pré-condição do ①**, não ornamento: aprovar `00`/`01`/`02` lendo texto é aprovar uma descrição, e a divergência entre o que o stakeholder imaginou e o que o time entendeu só aparece quando ele atravessa o fluxo — resta escolher se isso acontece antes do SDD técnico ou depois do código. O brainstorm é facilitado pelo SM, que **não decide conteúdo funcional**; a divisão de autoria do SDD (PO: visão, requisitos, fluxos; Arquiteto: arquitetura, dados, API) não muda, e o conjunto continua sendo **um só, com versão única** — os portões são de aprovação, não de arquivo. O roteiro está em [`workflow.md` §5b](workflow.md) e [`../skills.md` §10](../skills.md).

**Evita:** quatro modos de falha — uma ideia greenfield virar requisito formal por um único papel, com a inviabilidade técnica descoberta só na construção; toda ideia pequena ser arrastada por uma cerimônia multi-papel de duas fases, inchando o processo; o desenho técnico ser construído sobre um funcional que o stakeholder ainda não referendou, jogando fora arquitetura quando o entendimento funcional muda; e o stakeholder aprovar por escrito um produto que ele só vai **ver** depois de construído — o modo de falha mais caro dos quatro, porque o retrabalho já é código.
**SM verifica:** todo requisito novo do SDD rastreia **ou** a um registro de fechamento de `brainstorm` **ou** a uma decisão de `/po analyze`; a saída do brainstorm mostra a fase 1 (stakeholder + PO + UX, sem o Arquiteto) e a fase 2 (+ Arquiteto) antes do primeiro documento do SDD daquela área; **o protótipo funcional existe, cobre todo fluxo principal de `02-flows-and-roles` e traz o registro de navegação do stakeholder datado — portão ① sem esse registro é aprovação por leitura, e não vale**; **nenhum arquivo `03`/`04`/`05` datado antes do registro do portão ①, e nenhuma História datada antes do portão ②**; o brief de brainstorm não vira arquivo permanente sem lugar declarado em `.team-project/`.

### R16. Padrões de engenharia são base compartilhada — um editor, consumo obrigatório, defeito roteado
Os documentos de `${CLAUDE_PLUGIN_ROOT}/standards/` são a **base de qualidade comum** do Arquiteto, do Desenvolvedor e do QA. **Dono editorial:** o Arquiteto — única caneta, muda só por `/review`. **Consumidores obrigatórios:** o dev (aplica a regra ao executar o plano) e o QA (valida a entrega contra ela). Defeito num standard — contradição, lacuna, regra sem forma de verificação — **não se corrige de passagem**: o dev abre 🔺 GAP, o QA abre achado de processo, os dois roteados ao Arquiteto, que resolve por `/review`. Divergência entre os três sobre uma regra de engenharia é decidida pelo Arquiteto; o que ultrapassa engenharia (custo, prazo, escopo, política) sobe ao stakeholder pelo SM.

**Evita:** dois modos de falha opostos — o standard tratado como documento privado do Arquiteto, que dev e QA não leem e que deriva do código sem ninguém perceber; e o standard editado ad hoc por três papéis, perdendo a coerência que o torna régua. É o equivalente, para o normativo de engenharia, do que a matriz de propriedade faz para os artefatos de projeto.
**SM verifica:** todo Plano de Implementação cita a seção de standard aplicável ao que toca (já exigido para segurança em R11 e para o anel de arquitetura desde a v1.4); todo veredito de QA que acha desvio de standard no código o classifica como reprovação, não ressalva; todo 🔺 GAP ou achado de QA que aponta defeito no próprio standard aparece como insumo no `/review` seguinte — GAP de standard aberto por mais de um sprint sem decisão do Arquiteto vira bloqueio no quadro; `${CLAUDE_PLUGIN_ROOT}/standards/README.md` nomeia o editor e os dois consumidores com o canal de defeito.

### R17. Entrada de changelog do processo tem teto e forma fixa
Cada entrada de [`process-changelog.md`](process-changelog.md) registra a **decisão**, não a deliberação. Cabe nos campos do modelo [`../templates/process-change.md`](../templates/process-change.md), com **alvo ~150 linhas / ~6 KB** e **barreira de 10 KB** — acima dela a entrada não é registrada sem antes mover o excedente. Fica na entrada o que é **registro permanente**: instrução literal, classificação, tabela do que mudou, o modo de falha que evita, quem passa a ser cobrado de forma diferente, o indicador de sucesso, **uma linha por conflito** (o que conflita, com que regra, resolução ou "escalado — pendente"), roteamentos e pendências do stakeholder. **Não** fica o que é **raciocínio de uma vez**: a derivação de uma resolução de conflito, o passo a passo da reavaliação do conjunto, exemplos trabalhados. A reavaliação vai na resposta do `/review` ao stakeholder (`review-contract.md`), não transcrita aqui. Análise que precise sobreviver como precedente vira **nota de racional no próprio documento normativo que ela governa** (modelo: `artifact-ownership.md` §1a) — a entrada só a referencia. Correção de entrada antiga é **addendum datado anexado**, nunca reescrita (invariante do changelog).

**Evita:** a inflação medida no próprio changelog — v1.0 = 1,4 KB, v1.8 = 17,1 KB, 12× em nove versões — sem custar rastreabilidade: o que se corta é a deliberação repetida e o que já está registrado noutro documento, nunca a decisão nem o porquê dela.
**SM verifica:** tamanho por bloco `## vX.Y` do changelog (`wc -l`, KB); entrada acima de 10 KB volta para edição antes de entrar; a linha de footprint da retrospectiva acusa o estouro no sprint em que aconteceu.

### R18. Entrega do plugin é ramificada, versionada e registrada
Toda mudança que chega às instalações do time passa por uma **entrega**: branch (`fix/` ou `feat/`) a partir de `main`, PR para `main`, `version` de `.claude-plugin/plugin.json` em `vMAJOR.MINOR.PATCH`, e uma entrada no topo de `CHANGELOG.md` com o que foi entregue, a branch e como verificar. `MAJOR.MINOR` acompanham o changelog do processo quando a entrega carrega mudança de processo — entrega com entrada nova de [`process-changelog.md`](process-changelog.md) sai como `vX.Y.0`; `PATCH` é correção sobre a mesma linha. O roteiro está em [`workflow.md` §5d](workflow.md).

**Evita:** dois modos de falha — mudança aplicada direto em `main` sem entrega, que nenhuma instalação recebe de forma rastreável e que ninguém consegue reverter por versão; e `CHANGELOG.md`, `plugin.json` e `process-changelog.md` derivando entre si até "qual versão tem o quê" não ter resposta.
**SM verifica:** todo merge em `main` tem bump de `version` em `plugin.json` **e** entrada nova no topo de `CHANGELOG.md` nomeando a branch; a `version` de `plugin.json` é igual à da entrada do topo de `CHANGELOG.md`; toda entrada nova de `process-changelog.md` tem par em `CHANGELOG.md` na mesma linha `vX.Y`, ou a divergência está registrada; nenhuma entrada de `CHANGELOG.md` nega ter mudança de processo quando carrega uma.

### R19. O `/review` produz evidência do que aplicou
Aplicar não é ter aplicado. Todo `/review` que edita fecha com um **bloco de evidência** na entrada do changelog: para cada classe de mudança, o comando mecânico e o resultado. As três classes e a evidência mínima de cada uma — **arquivamento:** `diff` da entrada movida contra a versão que saiu, resultado esperado zero linhas fora do separador; **substituição de padrão:** `grep` do padrão antigo **em todos os arquivos da classe**, resultado esperado zero, **mais a leitura de cada ocorrência nova no contexto** — `grep` zerado prova que a string sumiu, não que o sentido fechou (trocar "quatro passos" por "cinco" e deixar ao lado a enumeração com quatro Tasks passa no `grep` e mente para quem lê); confira o que depende do trecho: contagem enumerada, lista adjacente, total citado noutro documento; **extração ou remoção:** contagem de linhas antes/depois nos dois arquivos, e o link do ponteiro que substituiu o texto movido. Evidência é o comando e a saída, não a afirmação de que foi feito. Ver o quinto passo de [`../../../review-contract.md`](../../../review-contract.md).

**Evita:** o `/review` declarar como concluído o que não fez ou fez pela metade — o modo de falha que a R7 e a R12 cobram do trabalho de projeto ("não afirme progresso sem evidência") e que o comando que governa o processo não cobrava de si. Observado na v2.10: uma entrada arquivada truncada em 60% e uma substituição de padrão aplicada em 1 de 5 arquivos, ambas relatadas como feitas, ambas descobertas só porque o stakeholder rodou o `/review` uma segunda vez.
**SM verifica:** entrada de `process-changelog.md` sem bloco de evidência não fecha o `/review` — o SM devolve ao papel. Na curadoria, reexecuta por amostragem um comando do bloco: saída diferente da registrada é achado de processo.

### R20. História é a unidade de valor; Task é a unidade de trabalho
Toda Task pertence a **exatamente uma História**, e nenhuma História é quebrada em Tasks antes de ter o **detalhamento funcional aprovado pelo stakeholder** (portão ③): regras, protótipos quando há interface, e critérios de aceite verificáveis. O detalhamento é **só funcional** — decisão técnica não entra ali; ela nasce no Plano de Implementação, dentro da Task. A História vive no Product Backlog (dono: PO); a Task vive no Sprint Backlog (dono: SM), e o plano dentro dela é do Arquiteto. Trabalho técnico que não serve a nenhuma História — refatoração, débito, infraestrutura — **precisa de uma História que declare o valor**, ainda que o beneficiário seja o próprio time; o que não consegue declarar valor não entra no sprint. Ver [`workflow.md` §1](workflow.md) e §3a.

**Evita:** dois modos de falha opostos — o time construir tarefas tecnicamente corretas que, somadas, não entregam nada que o stakeholder reconheça como valor; e a decisão técnica ser tomada cedo demais, dentro do detalhamento funcional, por quem está descrevendo o problema e não a solução.
**SM verifica:** nenhuma Task do Sprint Backlog sem História de origem; nenhuma História na Planning sem o registro de aprovação do portão ③; detalhamento de História que cite arquivo, classe, endpoint ou estrutura de dados é devolvido ao PO como achado de processo.

### R21. Aceite funcional é por História, na Sprint Review
O fechamento da Task é **técnico**: veredito ✅ do QA com evidência, e o `/sm close` atualiza quadro e status. O **aceite é funcional, agregado e do PO**, acontece na Sprint Review, ante o stakeholder, contra os critérios de aceite que ele aprovou no detalhamento. Saída por História: aceita · aceita com ressalva (a ressalva vira Task no Product Backlog, com dono) · rejeitada — e **História rejeitada devolve todas as suas Tasks ao Product Backlog, inclusive as que passaram no QA**. Nenhum `/po accept` mira uma Task. Ver [`workflow.md` §5e](workflow.md).

**Evita:** o modo de falha de declarar valor entregue somando aprovações técnicas — cada Task passa no QA, a História não faz o que o stakeholder esperava, e ninguém tem o momento formal em que isso apareceria. O preço aceito conscientemente é o oposto: uma História rejeitada devolve trabalho bom junto com o ruim, e é por isso que o portão ③ (detalhamento aprovado antes da Planning) não é negociável.
**SM verifica:** nenhuma História aceita fora de uma Sprint Review registrada; todo aceite cita, por critério, a evidência da Task que o cumpre; toda ressalva virou Task com dono no Product Backlog antes do encerramento do sprint; nenhum registro de aceite tem uma Task como alvo.

---

## Como o SM aplica

**A cada Task fechada**, o SM percorre esta lista e registra violações no quadro, na coluna de notas da Task. Violação não bloqueia a entrega já feita — vira ação corretiva no sprint seguinte.

**A cada sprint** (retrospectiva, depois da Review), o SM apresenta:

| Indicador | Fonte | Alerta |
|---|---|---|
| Gaps por plano | relatórios do dev | > 2 → plano raso (R8) |
| Reprovações no QA | registro de evidências | > 30% → DoR da Task fraca (R2, R8) |
| Tasks reabertas | quadro | > 1 → gate frouxo (R7) |
| Lead time × estimativa | quadro | > 2× → dimensionamento ruim (R2) |
| Tasks fechadas sem evidência | registro de evidências | qualquer → falha grave (R7, R12) |
| Violações de escopo | seção "Não fiz" + diff + entradas fora da Planning | recorrente → revisar plano (R4) |
| Soma estimada × entregue no sprint | Sprint Backlog | > 25% de desvio dois sprints seguidos → capacidade irreal (§5e) |
| História acima de 3× a unidade sem dimensionamento formal nem justificativa | plano + análise de impacto | qualquer ocorrência → gatilho de R13 ignorado |
| Projeto planejado sem registro de onboarding | quadro + changelog do processo | qualquer ocorrência → R14 ignorada |
| Requisito do SDD sem `brainstorm` nem `/po analyze` na origem; ou `03`/`04`/`05` datado antes do portão ①; ou História antes do portão ② | SDD + registro dos portões | qualquer ocorrência → R15 ignorada |
| Portão ① sem protótipo funcional, ou sem o registro datado de navegação do stakeholder; ou fluxo principal de `02-flows` sem caminho no protótipo | ficha do protótipo × `02-flows-and-roles` | qualquer ocorrência → o ① foi aprovado por leitura (R15) |
| Task sem História de origem, ou História na Planning sem aprovação do portão ③ | Sprint Backlog × Product Backlog | qualquer ocorrência → R20 ignorada |
| Detalhamento de História com decisão técnica (arquivo, classe, endpoint, estrutura de dados) | Product Backlog | qualquer ocorrência → fronteira funcional/técnica de R20 rompida |
| História aceita fora da Sprint Review, ou aceite mirando uma Task | registro de aceites | qualquer ocorrência → R21 ignorada |
| Plano ou veredito que toca engenharia sem citar a seção de standard aplicável | planos + vereditos do sprint | recorrente → standard virou enfeite (R16) |
| GAP ou achado apontando defeito em `${CLAUDE_PLUGIN_ROOT}/standards/` sem chegar ao `/review` seguinte | registro de GAPs + changelog do processo | qualquer ocorrência → canal de defeito de R16 quebrado |
| Carga fixa dos documentos do processo (KB) por papel | tamanho de `agents/` + `commands/` + `roles/<papel>/` | crescimento sem regra ou cerimônia nova, ou entrada de changelog > 10 KB → R17 / ciclo de eficiência (workflow §5c) |
| Merge em `main` sem bump de `version` + entrada no `CHANGELOG.md`, ou `plugin.json` ≠ topo do `CHANGELOG.md`, ou entrada de `process-changelog.md` sem par em `CHANGELOG.md` | `git log main` + `CHANGELOG.md` + `plugin.json` | qualquer ocorrência → R18 ignorada (workflow §5d) |
| Entrada de `process-changelog.md` sem bloco de evidência, ou com comando cuja reexecução dá saída diferente da registrada | o bloco de evidência da entrada, reexecutado por amostragem | qualquer ocorrência → R19 ignorada; o `/review` está declarando sem verificar |

**Ciclo de eficiência (PDCA).** A verificação do custo dos documentos não espera faxina do stakeholder: cada `/review` sem instrução mede o footprint do próprio papel, a retrospectiva de cada sprint registra o total, e o giro de `/review metrics` (a cada 3 retrospectivas, ou seja a cada 3 sprints) consolida e tira **uma** remoção candidata. Roteiro em [`workflow.md` §5c](workflow.md).

**Quando o stakeholder pede exceção a uma regra**, o SM registra: qual regra, por quanto tempo, qual risco aceito, e o que dispara a volta ao normal. Exceção sem prazo vira regra nova — e regra nova precisa estar escrita aqui.

**Como estas regras mudam.** Por `/review <instrução>`, nunca por conversa — e só no repositório-fonte do plugin. O SM (acionado pelo `/review`) classifica a instrução, verifica se ela contradiz alguma regra vigente — conflito para para decisão do stakeholder —, aplica e registra em [`process-changelog.md`](process-changelog.md) com o indicador que provaria que funcionou. **Regra sem forma de verificação não entra**, e toda revisão de processo (`/review metrics`) considera também **remover**: processo que só cresce fica caro e deixa de ser seguido.

---

## Resumo em uma tela

| # | Regra | Bloco |
|---|---|---|
| R1 | Uma Task por vez, do plano ao veredito | Eficiência |
| R2 | Task cabe em uma unidade de trabalho | Eficiência |
| R3 | Contexto mínimo suficiente | Eficiência |
| R4 | Não antecipar escopo | Eficiência |
| R5 | Interrupção é estado, não perda | Eficiência |
| R6 | Decisão tomada é decisão registrada | Eficiência |
| R7 | Sem evidência, não aconteceu | Qualidade |
| R8 | Sem plano, sem código | Qualidade |
| R9 | Gap vira pergunta, nunca palpite | Qualidade |
| R10 | Nomenclatura existente é contrato | Qualidade |
| R11 | Segurança entra no plano, não na revisão | Qualidade |
| R12 | Documento vivo se atualiza no mesmo ciclo | Qualidade |
| R13 | Instrumento de dimensionamento e controle escolhido pelo gatilho | Método |
| R14 | Projeto novo ou retomado passa por onboarding antes da primeira Planning | Método |
| R15 | Ideia sem documentação passa por brainstorm; o SDD sobe por dois portões, o ① com protótipo navegado | Método |
| R16 | Padrões de engenharia são base compartilhada — um editor, consumo obrigatório, defeito roteado | Método |
| R17 | Entrada de changelog do processo tem teto e forma fixa | Método |
| R18 | Entrega do plugin é ramificada, versionada e registrada | Método |
| R19 | O `/review` produz evidência do que aplicou | Método |
| R20 | História é a unidade de valor; Task é a unidade de trabalho | Método |
| R21 | Aceite funcional é por História, na Sprint Review | Método |
