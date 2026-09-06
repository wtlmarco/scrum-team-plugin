# Regras de Trabalho — Máxima Eficiência e Qualidade

> **Dono:** SM · **Alcance:** todos os papéis, inclusive o stakeholder · **Natureza:** normativa
> Estas regras não são conselhos. São o contrato de trabalho do time. O SM verifica o cumprimento a cada ciclo e registra a violação como achado de processo — do mesmo jeito que o QA registra um achado de código.

Cada regra existe porque um **modo de falha recorrente** a produziu. A coluna "evita" nomeia esse modo de falha.

---

## Bloco A — Eficiência

### R1. Um item por vez, do plano ao aceite
Respeite a capacidade declarada no contexto do projeto. Com um único desenvolvedor, a construção é uma **fila**: nada de abrir o segundo item porque o primeiro "está quase". O paralelismo permitido é **entre papéis** — dev constrói o item *n*, Arquiteto planeja o *n+1*, PO refina o *n+2*.

**Evita:** dois itens 90% prontos e nenhum entregável.
**SM verifica:** no máximo um item em construção por dev disponível.

### R2. Item cabe em uma unidade de trabalho
Plano com mais de ~10 passos, ou tocando duas áreas do sistema ao mesmo tempo, é quebrado em `<ID>a`/`<ID>b` encadeados antes de entrar em construção.

**Evita:** item que atravessa sessões, perde contexto e volta com metade da intenção original.
**SM verifica:** estimativa dentro da unidade para todo item planejado ou em construção; item que estourar 2× a estimativa vira alerta.

### R3. Contexto mínimo suficiente
Ninguém carrega documentação inteira "por precaução". Cada papel lê a seção que a tarefa exige, listada no plano ou na tabela de fontes da verdade do contexto do projeto. Um inventário de código existe justamente para saber **qual arquivo pedir** sem abrir o repositório todo.

**Evita:** desperdício de contexto e diluição do que importa.
**SM verifica:** plano lista "contexto de código a ler" com caminhos exatos e o porquê de cada um.

### R4. Não antecipar escopo
Implementa-se o item, não o "enquanto isso". Sem refatoração oportunista, sem TODO especulativo, sem abstração para caso futuro, sem dependência nova fora do plano.

**Evita:** scope creep silencioso — trabalho que ninguém pediu, ninguém revisou e ninguém sabe justificar depois.
**SM verifica:** relatório do dev traz a seção "Não fiz (fora do plano)" preenchida; QA confere o diff contra a lista de arquivos do plano.

### R5. Interrupção é estado, não perda
Quem para no meio registra **em que passo parou e como o repositório ficou** (compila? testes passam?). Os passos do plano são ordenados para o repositório ficar íntegro no maior número possível de pontos intermediários.

**Evita:** retomada que refaz trabalho já feito ou que herda base quebrada.
**SM verifica:** relatório de entrega tem a linha "Parei no passo".

### R6. Decisão tomada é decisão registrada
Toda decisão fora do que a especificação já dizia vira registro — entrada no documento de status (via SM) ou ADR quando for estrutural e recorrente. Nunca embutida silenciosamente no código.

**Evita:** arqueologia. Um projeto só é retomável meses depois se as decisões foram escritas.
**SM verifica:** todo item fechado com desvio tem entrada correspondente.

---

## Bloco B — Qualidade

### R7. Sem evidência, não aconteceu
"Funciona", "build ok", "testes passando" não são afirmações válidas sem a **saída real do comando**. O que não pôde ser executado é declarado **não exercitado**, com o motivo.

**Evita:** o modo de falha mais caro que existe — funcionalidade declarada como concluída sem que nenhum caminho de sucesso jamais tenha sido exercitado.
**SM verifica:** todo item fechado tem bloco no registro de evidências, com comando e saída.

### R8. Sem plano, sem código
O dev não escreve uma linha sem Plano de Execução do Arquiteto. Plano que não cobre o que apareceu no código vira 🔺 GAP, não improviso.

**Evita:** deriva de especificação e de código — decisão de desenho tomada por quem tem menos contexto, no meio da implementação.
**SM verifica:** existe plano para todo item em construção.

### R9. Gap vira pergunta, nunca palpite
Quem não sabe, escala: dev → Arquiteto; funcional → PO; estratégico → stakeholder. E quem recebe **decide**, não devolve a pergunta.

**Evita:** improviso que passa despercebido na revisão e vira padrão por repetição.
**SM verifica:** gaps registrados e respondidos; gap sem resposta há mais de um ciclo vira bloqueio no quadro.

### R10. Nomenclatura existente é contrato
Classe, campo, enum, rota, nome de migration saem **exatamente** como na especificação. Renomear é mudança (passa pelo PO/Arquiteto), não melhoria.

**Evita:** divergência entre documento e código que só aparece meses depois, em auditoria.
**SM verifica:** achado de nomenclatura no veredito do QA conta como reprovação, não como ressalva.

### R11. Segurança entra no plano, não na revisão
Item que toca autenticação, autorização, escopo/tenant, dado pessoal ou conteúdo de terceiro traz, **no plano**, a regra aplicável dos padrões de engenharia: identidade do contexto autenticado, autorização explícita com permissão real, isolamento coberto por teste, auditoria da ação sensível, segredo validado no start.

**Evita:** furos que atravessam sprints inteiras porque segurança era etapa final — fluxo sensível sem verificação de permissão, chave de assinatura vazia, ação crítica sem registro de auditoria.
**SM verifica:** item marcado como sensível sem seção de segurança no plano não entra em construção.

### R12. Documento vivo se atualiza no mesmo ciclo
Quadro, evidências, inventário de código, registro de GAPs e documento de status são atualizados **no ciclo em que o fato aconteceu**, por seus donos. Nunca "depois".

**Evita:** documentação que descreve um projeto que não existe mais.
**SM verifica:** fechamento de item exige as atualizações; sem elas, o item não fecha.

---

## Bloco C — Método

### R13. O instrumento de dimensionamento e de controle é escolhido pelo gatilho, não por hábito
Scrum é o padrão do time — estimativa relativa na unidade do projeto, quadro como registro de risco, `/sm impact` para mudança, fila por dependência. O SM aciona um instrumento de **APF** (contagem de pontos de função) ou de **PMBOK** (registro formal de riscos, controle integrado de mudanças, EAP, baseline de escopo) quando um gatilho objetivo de [`../skills.md` §9](../skills.md) ocorre — e **nomeia o gatilho na saída** (plano, análise de impacto, status). Resultado de APF é convertido para a unidade de estimativa declarada no contexto do projeto; instrumento formal criado ganha entrada no [changelog do processo](process-changelog.md).

**Evita:** dois modos de falha opostos — dimensionar "no olho" um escopo grande porque a única ferramenta à mão era estimativa relativa, e o projeto ser declarado concluído com metade do trabalho ainda aberto; e afogar um projeto pequeno em artefato de PMBOK que ninguém mantém.
**SM verifica:** em todo lote ou épico acima de 3× a unidade de trabalho, em todo status com mais de 5 riscos abertos e em toda mudança que toca baseline acordada ou contrato já implantado, a saída traz **ou** o instrumento formal **ou** a justificativa explícita de por que a abordagem Scrum ainda basta.

### R14. Projeto novo ou retomado passa por onboarding antes do primeiro planejamento
Nenhum `/sm plan` roda num projeto — recém-recebido ou retomado após interrupção — sem um **onboarding** concluído: inventário das fontes de documentação do projeto, leitura de entrada dos seis papéis, lista única de perguntas ao stakeholder (só o que a documentação não respondeu) e registro do entendimento alinhado no contexto do projeto. **A documentação existente é interrogada primeiro; o stakeholder é a segunda fonte, não a primeira.** Documentação funcional essencial ausente — sem visão geral, sem requisitos, sem fluxos — aciona o `brainstorm` (R15), e o onboarding fica pausado até ele fechar. O roteiro está em [`workflow.md` §5a](workflow.md) e [`../skills.md` §10](../skills.md).

**Evita:** o time planejar e construir sobre um entendimento presumido do projeto — o modo de falha que produziu "14 sprints concluídas" convivendo com 50 GAPs, porque ninguém cruzou o código contra a narrativa antes de comprometer um plano.
**SM verifica:** o primeiro `/sm plan` do projeto cita o registro de onboarding; a checklist de saída do onboarding está completa; `.team-project/README.md` §4 (fontes da verdade) e §7 (decisões pendentes do stakeholder) estão preenchidas e datadas; toda divergência entre narrativa de status e código encontrada no onboarding é uma linha na tabela de riscos do quadro. Projeto já em andamento quando R14 passou a valer faz um **onboarding retroativo** uma vez, registrado no changelog do processo.

### R15. Ideia sem documentação passa por brainstorm antes de virar requisito ou SDD
Ideia nova cuja área **não tem cobertura** em visão geral / requisitos / fluxos passa por um `brainstorm` em duas fases antes de qualquer documento do SDD ser escrito: **fase 1** funcional, com stakeholder + PO + UX; **fase 2** de viabilidade e proposta, entrando o Arquiteto, em rodadas de análise até um ponto fixo. Ideia que cai em área **já documentada** vai por `/po analyze`, como sempre. O brainstorm é facilitado pelo SM, que **não decide conteúdo funcional**; o requisito resultante é escrito pelo PO e a divisão de autoria do SDD (PO: visão, requisitos, fluxos; Arquiteto: arquitetura, dados, API) não muda. O roteiro está em [`workflow.md` §5b](workflow.md) e [`../skills.md` §10](../skills.md).

**Evita:** dois modos de falha opostos — uma ideia greenfield virar requisito formal por um único papel, com a inviabilidade técnica descoberta só na construção; e toda ideia pequena ser arrastada por uma cerimônia multi-papel de duas fases, inchando o processo.
**SM verifica:** todo requisito novo do SDD rastreia **ou** a um registro de fechamento de `brainstorm` **ou** a uma decisão de `/po analyze` — nenhum requisito existe sem um dos dois; a saída do brainstorm mostra a fase 1 (stakeholder + PO + UX, sem o Arquiteto) e a fase 2 (+ Arquiteto) antes do primeiro documento do SDD daquela área; o brief de brainstorm não vira arquivo permanente sem lugar declarado em `.team-project/`.

### R16. Padrões de engenharia são base compartilhada — um editor, consumo obrigatório, defeito roteado
Os documentos de `${CLAUDE_PLUGIN_ROOT}/standards/` são a **base de qualidade comum** do Arquiteto, do Desenvolvedor e do QA. **Dono editorial:** o Arquiteto — única caneta, muda só por `/review`. **Consumidores obrigatórios:** o dev (aplica a regra ao executar o plano) e o QA (valida a entrega contra ela). Defeito num standard — contradição, lacuna, regra sem forma de verificação — **não se corrige de passagem**: o dev abre 🔺 GAP, o QA abre achado de processo, os dois roteados ao Arquiteto, que resolve por `/review`. Divergência entre os três sobre uma regra de engenharia é decidida pelo Arquiteto; o que ultrapassa engenharia (custo, prazo, escopo, política) sobe ao stakeholder pelo SM.

**Evita:** dois modos de falha opostos — o standard tratado como documento privado do Arquiteto, que dev e QA não leem e que deriva do código sem ninguém perceber; e o standard editado ad hoc por três papéis, perdendo a coerência que o torna régua. É o equivalente, para o normativo de engenharia, do que a matriz de propriedade faz para os artefatos de projeto.
**SM verifica:** todo Plano de Execução cita a seção de standard aplicável ao que toca (já exigido para segurança em R11 e para o anel de arquitetura desde a v1.4); todo veredito de QA que acha desvio de standard no código o classifica como reprovação, não ressalva; todo 🔺 GAP ou achado de QA que aponta defeito no próprio standard aparece como insumo no `/review` seguinte — GAP de standard aberto por mais de um ciclo sem decisão do Arquiteto vira bloqueio no quadro; `${CLAUDE_PLUGIN_ROOT}/standards/README.md` nomeia o editor e os dois consumidores com o canal de defeito.

### R17. Entrada de changelog do processo tem teto e forma fixa
Cada entrada de [`process-changelog.md`](process-changelog.md) registra a **decisão**, não a deliberação. Cabe nos campos do modelo [`../templates/process-change.md`](../templates/process-change.md), com **alvo ~150 linhas / ~6 KB** e **barreira de 10 KB** — acima dela a entrada não é registrada sem antes mover o excedente. Fica na entrada o que é **registro permanente**: instrução literal, classificação, tabela do que mudou, o modo de falha que evita, quem passa a ser cobrado de forma diferente, o indicador de sucesso, **uma linha por conflito** (o que conflita, com que regra, resolução ou "escalado — pendente"), roteamentos e pendências do stakeholder. **Não** fica o que é **raciocínio de uma vez**: a derivação de uma resolução de conflito, o passo a passo da reavaliação do conjunto, exemplos trabalhados. A reavaliação vai na resposta do `/review` ao stakeholder (`review-contract.md`), não transcrita aqui. Análise que precise sobreviver como precedente vira **nota de racional no próprio documento normativo que ela governa** (modelo: `artifact-ownership.md` §1a) — a entrada só a referencia. Correção de entrada antiga é **addendum datado anexado**, nunca reescrita (invariante do changelog).

**Evita:** a inflação medida no próprio changelog — v1.0 = 1,4 KB, v1.8 = 17,1 KB, 12× em nove versões — sem custar rastreabilidade: o que se corta é a deliberação repetida e o que já está registrado noutro documento, nunca a decisão nem o porquê dela.
**SM verifica:** tamanho por bloco `## vX.Y` do changelog (`wc -l`, KB); entrada acima de 10 KB volta para edição antes de entrar; a linha de footprint da retrospectiva acusa o estouro no ciclo em que aconteceu.

### R18. Entrega do plugin é ramificada, versionada e registrada
Toda mudança que chega às instalações do time passa por uma **entrega**: branch (`fix/` ou `feat/`) a partir de `main`, PR para `main`, `version` de `.claude-plugin/plugin.json` em `vMAJOR.MINOR.PATCH`, e uma entrada no topo de `CHANGELOG.md` com o que foi entregue, a branch e como verificar. `MAJOR.MINOR` acompanham o changelog do processo quando a entrega carrega mudança de processo — entrega com entrada nova de [`process-changelog.md`](process-changelog.md) sai como `vX.Y.0`; `PATCH` é correção sobre a mesma linha. O roteiro está em [`workflow.md` §5d](workflow.md).

**Evita:** dois modos de falha — mudança aplicada direto em `main` sem entrega, que nenhuma instalação recebe de forma rastreável e que ninguém consegue reverter por versão; e `CHANGELOG.md`, `plugin.json` e `process-changelog.md` derivando entre si até "qual versão tem o quê" não ter resposta.
**SM verifica:** todo merge em `main` tem bump de `version` em `plugin.json` **e** entrada nova no topo de `CHANGELOG.md` nomeando a branch; a `version` de `plugin.json` é igual à da entrada do topo de `CHANGELOG.md`; toda entrada nova de `process-changelog.md` tem par em `CHANGELOG.md` na mesma linha `vX.Y`, ou a divergência está registrada; nenhuma entrada de `CHANGELOG.md` nega ter mudança de processo quando carrega uma.

---

## Como o SM aplica

**A cada item fechado**, o SM percorre esta lista e registra violações no quadro, na coluna de notas do item. Violação não bloqueia a entrega já feita — vira ação corretiva no ciclo seguinte.

**A cada 3 itens fechados** (retrospectiva), o SM apresenta:

| Indicador | Fonte | Alerta |
|---|---|---|
| Gaps por plano | relatórios do dev | > 2 → plano raso (R8) |
| Reprovações no QA | registro de evidências | > 30% → DoR fraca (R2, R8) |
| Itens reabertos | quadro | > 1 → gate frouxo (R7) |
| Lead time × estimativa | quadro | > 2× → dimensionamento ruim (R2) |
| Itens fechados sem evidência | registro de evidências | qualquer → falha grave (R7, R12) |
| Violações de escopo | seção "Não fiz" + diff | recorrente → revisar plano (R4) |
| Lote/épico > 3× a unidade sem dimensionamento formal nem justificativa | plano + análise de impacto | qualquer ocorrência → gatilho de R13 ignorado |
| Projeto planejado sem registro de onboarding | quadro + changelog do processo | qualquer ocorrência → R14 ignorada |
| Requisito do SDD sem `brainstorm` nem `/po analyze` na origem | SDD + changelog do processo | qualquer ocorrência → R15 ignorada |
| Plano ou veredito que toca engenharia sem citar a seção de standard aplicável | planos + vereditos do período | recorrente → standard virou enfeite (R16) |
| GAP ou achado apontando defeito em `${CLAUDE_PLUGIN_ROOT}/standards/` sem chegar ao `/review` seguinte | registro de GAPs + changelog do processo | qualquer ocorrência → canal de defeito de R16 quebrado |
| Carga fixa dos documentos do processo (KB) por papel | tamanho de `agents/` + `commands/` + `roles/<papel>/` | crescimento sem regra ou cerimônia nova, ou entrada de changelog > 10 KB → R17 / ciclo de eficiência (workflow §5c) |
| Merge em `main` sem bump de `version` + entrada no `CHANGELOG.md`, ou `plugin.json` ≠ topo do `CHANGELOG.md`, ou entrada de `process-changelog.md` sem par em `CHANGELOG.md` | `git log main` + `CHANGELOG.md` + `plugin.json` | qualquer ocorrência → R18 ignorada (workflow §5d) |

**Ciclo de eficiência (PDCA).** A verificação do custo dos documentos não espera faxina do stakeholder: cada `/review` sem instrução mede o footprint do próprio papel, a retrospectiva registra o total, e o giro de `/review metrics` (a cada 3 retrospectivas) consolida e tira **uma** remoção candidata. Roteiro em [`workflow.md` §5c](workflow.md).

**Quando o stakeholder pede exceção a uma regra**, o SM registra: qual regra, por quanto tempo, qual risco aceito, e o que dispara a volta ao normal. Exceção sem prazo vira regra nova — e regra nova precisa estar escrita aqui.

**Como estas regras mudam.** Por `/review <instrução>`, nunca por conversa — e só no repositório-fonte do plugin. O SM (acionado pelo `/review`) classifica a instrução, verifica se ela contradiz alguma regra vigente — conflito para para decisão do stakeholder —, aplica e registra em [`process-changelog.md`](process-changelog.md) com o indicador que provaria que funcionou. **Regra sem forma de verificação não entra**, e toda revisão de processo (`/review metrics`) considera também **remover**: processo que só cresce fica caro e deixa de ser seguido.

---

## Resumo em uma tela

| # | Regra | Bloco |
|---|---|---|
| R1 | Um item por vez, do plano ao aceite | Eficiência |
| R2 | Item cabe em uma unidade de trabalho | Eficiência |
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
| R14 | Projeto novo ou retomado passa por onboarding antes do planejamento | Método |
| R15 | Ideia sem documentação passa por brainstorm antes de requisito ou SDD | Método |
| R16 | Padrões de engenharia são base compartilhada — um editor, consumo obrigatório, defeito roteado | Método |
| R17 | Entrada de changelog do processo tem teto e forma fixa | Método |
| R18 | Entrega do plugin é ramificada, versionada e registrada | Método |
