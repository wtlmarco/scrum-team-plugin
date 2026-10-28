# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
| [`v3.50`](process-changelog-archive.md) | Mudança de layout se prova em render real: navegador headless, 3 fontes × telas, mutação que quebra a medição; addendum: as paradas do `run` fecham no texto (SM + Arquiteto + Dev + QA) — 16/10/2026 |
| [`v3.49`](process-changelog-archive.md) | Custo medido nos transcripts: retorno curto à sessão com o relatório do dev em arquivo, Arquiteto novo quando o cache venceu, toque de cache da sessão, gravação por etapa e dev por F-ID no `fix` (SM + Arquiteto + Dev + QA) — 16/10/2026 |
| [`v3.48`](process-changelog-archive.md) | O que o primeiro sprint do piloto mostrou: relatório do `operator` gravado pelo hook, guardas sem falha aberta nem falso negado, C1 que fecha o que é legítimo; addendum v3.48.1: `verify.testItem` (SM + Arquiteto + Dev + QA) — 14/10/2026 |
| [`v3.47`](process-changelog-archive.md) | Modelo por papel (G17), perfil Arquiteto executor, modo benchmark (G18) e ritual "modo projeto": o plugin pronto para o experimento sem intervenção (SM + Arquiteto + QA + Dev) — 10/10/2026 · *com addendum v3.47.1 de 12/10/2026* |
| [`v3.46`](process-changelog-archive.md) | Plano em contrato conferido antes do dev, prova de falha por mutação, trilha leve por Task, Arquiteto um passo à frente e fechamento pela sessão (SM + Arquiteto + Dev + QA) — 06/10/2026 |
| [`v3.45`](process-changelog-archive.md) | Consumo medido no transcript (G16), R28 por Task e plano em blocos de até 8 arquivos com uma instância de dev por bloco; addendum v3.45.1: verificação uma vez só, amarrada à árvore (SM + Arquiteto + Dev + QA + UX) — 06/10/2026 |
| [`v3.44`](process-changelog-archive.md) | Run sem trava: o Arquiteto decide e não escreve no código (G8 nega), a G14 libera o operacional do run, a G15 registra pedido de permissão; addendum v3.44.1/v3.44.2 (SM + Arquiteto) — 06/10/2026 |
| [`v3.43`](process-changelog-archive.md) | `sprint run` sem paradas fora do contrato: lista fechada de paradas, rota do gate protegido, negação ao dev vira 🔺 GAP, interrupção pelo stakeholder e marcador acompanhando a Task; addendum: veredito pelo primeiro marcador, desvio aceito no R4, código de saída do `operator` (SM + Arquiteto + QA) — 05/10/2026 |
| [`v3.42`](process-changelog-archive.md) | Guardas por papel (fase 2): gate protegido, teste ignorado, `Agent` só ao `operator`, matriz de propriedade, escopo do dev e pasta do job — G5 · G6 · G7 · G8 · G9 · G11 (SM + Arquiteto) — 04/10/2026 |
| [`v3.41`](process-changelog-archive.md) | R34: contato remoto por Remote Control — identidade do projeto, pendência em disco, fim do `sprint run` em formulário de autorização da Review e protótipo publicável como artifact (SM + UX) — 03/10/2026 |
| [`v3.40`](process-changelog-archive.md) | R33: trilha `fix` para defeito e ajuste pequeno — critério verificável na entrada, plano e execução em bloco, consumo próprio, piso de evidência por Correção e conferência C4 (SM + PO + Arquiteto + QA + UX) — 03/10/2026 |
| [`v3.39`](process-changelog-archive.md) | Guardas e conferências mecânicas: hooks de plugin (G1 · G2 · G3 · G4 · G13) e três scripts (C1 · C2 · C3) tiram do julgamento o que é mecânico (SM + QA) — 02/10/2026 |
| [`v3.38`](process-changelog-archive.md) | Medir custo e resultado: Categoria e Unidade no registro de consumo, bloco "Custo × resultado" na retrospectiva, modelo de benchmark A/B/C e "História de origem" no defeito (SM + PO + QA) — 02/10/2026 |
| [`v3.37`](process-changelog-archive.md) | R32: consultoria externa especializada pelo `/sm consulting` — técnica e de negócio, carta sanitizada, até 3 réplicas, validação do time antes do formulário (SM + PO + Arquiteto + QA + UX) — 02/10/2026 |
| [`v3.36`](process-changelog-archive.md) | R27 confere a energia e retoma o mesmo agente; Task pesada em segundo plano; ocorrência de plugin só se registra no `run` e se pergunta na Review; `replicate-in-new-project.md` fundido no `how-to.md` (SM) — 01/10/2026 |
| [`v3.35`](process-changelog-archive.md) | `.team-project/` sai do git (R31); R28 enxuta: relatório do job com teto, `report-<log>.md` por chamada, dev isento, log podado não é achado; consumo fora de sprint em `.team-project/consumption.md` (SM) — 30/09/2026 |
| [`v3.34 (parte 3)`](process-changelog-archive.md) | Novo modo `/sm sdd`: do brief ao SDD aprovado e às Histórias, com os portões ① e ② disparados pelo próprio modo (SM + PO + UX + Arquiteto) — 30/09/2026 |
| [`v3.34 (parte 2)`](process-changelog-archive.md) | Split do `workflow.md`, índice das regras, roteiro do `run` como fonte única e correções da auditoria (SM) — 29/09/2026 |
| [`v3.34`](process-changelog-archive.md) | Cadência do sprint em cinco modos do `/sm` (prepare · plan · run · review · close); `/team cycle\|plan\|build\|qa` removidos; decisão de portão em formulário (R22) (SM + PO + Arquiteto + QA + UX) — 29/09/2026 |
| [`v3.33.1`](process-changelog-archive.md) | O papel chamador retrata o consumo do `operator`; o registro o soma em linhas por chamador (SM) — 29/09/2026 |
| [`v3.33`](process-changelog-archive.md) | Retrospectiva analisa consumo por papel e por modelo, procura ineficiência e gera o relatório ao dono do plugin (SM) — 29/09/2026 |
| [`v3.32`](process-changelog-archive.md) | R30: QA mapeia cenário de teste funcional/regressivo na Planning e o executa no veredito; GAP não-bloqueante ganha caminho ao Product Backlog (SM) — 23/09/2026 |
| [`v3.31`](process-changelog-archive.md) | QA cobre aderência de execução e de standard na mesma frente 2; `/arc comply` sai do ciclo; `cycle sprint` deixa de ser "proposta" (SM) — 23/09/2026 |
| [`v3.30`](process-changelog-archive.md) | R29 nova: checkpoint de sessão entre fases heterogêneas; item de build em background fechado por já coberto (R28); sequenciamento de branch do projeto-cliente fora do alcance (SM) — 22/09/2026 |
| [`v3.29`](process-changelog-archive.md) | R28 troca o mecanismo impossível pelo implementável (arquivo na origem + agente `operator`); R26 aceita medição do `operator`; agente conta sobe a 7 (SM + PO + Arquiteto + QA + UX) — 21/09/2026 |
| [`v3.28`](process-changelog-archive.md) | R26(i) passa a cobrir o plano inteiro, não só o primeiro passo; R28 nova poda o log de build do contexto do subagente (SM) — 21/09/2026 |
| [`v3.27`](process-changelog-archive.md) | Os três pontos abertos de `note.md` resolvidos em formulário: teto da R17 escala, R27 nova, R5 ganha o lado de quem orquestra (SM) — 20/09/2026 |
| [`v3.26`](process-changelog-archive.md) | UX desce de Opus para Sonnet, por medição de custo (stakeholder) — 20/09/2026 |
| [`v3.25`](process-changelog-archive.md) | R26 (plano mede o ambiente); gate desligado/não exercitado é 🔺 GAP; consumo cobre notificação parcial; R9 decide-e-documenta (item 2a) (SM + Arquiteto) — 20/09/2026 |
| [`v3.24`](process-changelog-archive.md) | O ciclo do sprint: ③ em lote sobre pacote navegável, bloqueio em dois degraus, registro por sprint (5 papéis) — 20/09/2026 · *com addendum de 20/09/2026 sobre o teto da R17* |
| [`v3.23`](process-changelog-archive.md) | Segundo giro Act: a tabela de indicadores parava de dizer algo novo em 13 das 23 linhas (SM) — 18/09/2026 |
| [`v3.22`](process-changelog-archive.md) | Giro Act do ciclo de eficiência: footprint remedido e a arqueologia do `consult` sai de §5c (SM) — 18/09/2026 |
| [`v3.21`](process-changelog-archive.md) | Product Backlog deixa de conter a História: índice com ponteiro, conteúdo em arquivo próprio do PO (§1d) |
| [`v3.20`](process-changelog-archive.md) | Pendência do stakeholder resolvida em formulário: R22 ganha o meio de apresentação, restrito a quem orquestra (SM) — 18/09/2026 |
| [`v3.19`](process-changelog-archive.md) | Pasta `sprints/<n>/` para Review/Retrospectiva/snapshot, burndown desenhado (R24), tríade R18, duas contagens e uma contradição entre normativos (SM) — 16/09/2026 |
| [`v3.18`](process-changelog-archive.md) | As três decisões escaladas em v3.17 fechadas: arquivamento por sprint, granularidade definitiva, e as duas propostas aplicadas sob a restrição de escopo `.team-project/` (SM) — 15/09/2026 |
| [`v3.17`](process-changelog-archive.md) | Registro de consumo do time: propriedade, modelo e gancho no ciclo de eficiência; gravação e exibição propostas ao stakeholder (SM) — 15/09/2026 |
| [`v3.16`](process-changelog-archive.md) | Tabela de custo remedida (v3.4 → v3.16) e R18 realinhada ao modelo de branch em uso (`develop`, empilhamento) (SM) — 14/09/2026 |
| [`v3.15`](process-changelog-archive.md) | `/po accept` alinhado a R21, vão de alcance do `/review` fechado, resíduo de find-replace e numeração da própria entrada corrigidos (SM + Arquiteto) — 14/09/2026 |
| [`v3.14`](process-changelog-archive.md) | Nascimento dos documentos de implementação declarado, rastreio de pendências no onboarding, bug do stakeholder no fluxo e em `.team-project/note.md`, e curadoria da rodada (SM) — 12/09/2026 |
| [`v3.13`](process-changelog-archive.md) | O bug entra pelo PO: classificação do relato do stakeholder, e a fila `.team-project/note.md` tratada em lote (PO) — 12/09/2026 |
| [`v3.12`](process-changelog-archive.md) | Pendências e bugs num só registro: campo `origem`, leitura filtrada do stakeholder e estado de escalação em `pending.md` (QA) — 12/09/2026 |
| [`v3.11`](process-changelog-archive.md) | Delegar tarefa simples de PO/SM/UX/QA ao dev (Haiku): proposta avaliada e descartada — 12/09/2026 |
| [`v3.10`](process-changelog-archive.md) | Pendentes de v3.8/v3.9 aplicados a pedido do stakeholder: timeout do Arquiteto, verificação do protótipo no comando e retomada nativa entre invocações — 12/09/2026 |
| [`v3.9`](process-changelog-archive.md) | Spike do Arquiteto para de travar: timeout/backoff na borda externa, checkpoint por etapa e modo leve de verificação — 12/09/2026 |
| [`v3.8`](process-changelog-archive.md) | Harness do protótipo grava enquanto roda e mede o próprio escopo: checkpoint por tela e modo leve (UX) — 12/09/2026 |
| [`v3.7`](process-changelog-archive.md) | Consumo de sessão em uso intensivo: leitura incremental, checkpoint de verificação pesada, limite de paralelismo e modo leve de verificação (parte geral, SM) — 12/09/2026 |
| [`v3.6`](process-changelog-archive.md) | Pergunta ao stakeholder ganha forma fixa: opções descritas, recomendação e a via de pedir mais contexto (R22) — 10/09/2026 |
| [`v3.5`](process-changelog-archive.md) | Três reforços de coerência: banner do README no gate de fechamento, mensagem de bloqueio do `/review` e avaliação de impacto no `/team update` — 10/09/2026 |
| [`v3.4`](process-changelog-archive.md) | Substantivo homônimo em lista de proibição: a régua, as cinco correções e o fecho do `/review note` — 09/09/2026 |
| [`v3.3`](process-changelog-archive.md) | O canal do stakeholder é o PO; o broadcast acaba; prazo, plano e status mudam de dono — 08/09/2026 |
| [`v3.2`](process-changelog-archive.md) | A métrica de eficiência para de medir história fria; o `/review` sai do caminho quente — 08/09/2026 |
| [`v3.1`](process-changelog-archive.md) | Protótipo funcional em HTML vira entregável e pré-condição do portão ①; o Sprint Backlog ganha o próprio nome — 08/09/2026 |
| [`v3.0`](process-changelog-archive.md) | Redesenho do modelo de trabalho: História e Task, sprint como caixa de tempo, aceite na Sprint Review — 08/09/2026 |
| [`v2.11`](process-changelog-archive.md) | Guias de raiz ganham dono; roteiro de instalação endurecido; R19 passa a exigir checagem semântica — 07/09/2026 |
| [`v2.10`](process-changelog-archive.md) | Reavaliação do conjunto: caminho de escrita do `/review`, contagem de regras e modo `note` reconciliados — 07/09/2026 |
| [`v2.9`](process-changelog-archive.md) | Processo de atualização e lançamento do plugin ganha documento e dono — 06/09/2026 |
| [`v2.8`](process-changelog-archive.md) | Evolução do processo num comando só: `/review`, guardado ao repositório-fonte, com `note.md` como fila — 06/09/2026 |
| [`v2.7`](process-changelog-archive.md) | Faxina pós-isolamento em plugin: resíduo de caminho, contagens do UX e extração dos modos frios — 06/09/2026 |
| [`v2.6`](process-changelog-archive.md) | QA frente 2 ganha a redação final: objeto próprio e o terceiro achado de processo — 06/09/2026 |
| [`v2.5`](process-changelog-archive.md) | Obsolescência corrigida nos documentos do Arquiteto: comply sob demanda e Ficha até V21 — 06/09/2026 |
| [`v2.4`](process-changelog-archive.md) | Aderência ao plano × aderência ao standard: `/arc comply` e a frente 2 do QA verificam objetos diferentes — 06/09/2026 |
| [`v2.3`](process-changelog-archive.md) | PO ganha a forma completa do RNF de performance e a cadeia RNF → V18 → veredito — 06/09/2026 |
| [`v2.2`](process-changelog-archive.md) | QA alinhado a R16 e ganha a frente de desempenho; veredito endereçado ao stakeholder — 06/09/2026 |
| [`v2.1`](process-changelog-archive.md) | PERF-TEST fechada: desempenho vira obrigação verificável nos dois níveis do `standards/` — 06/09/2026 |
| [`v2.0`](process-changelog-archive.md) | Changelog arquivado, contrato do `review` extraído, ciclo de eficiência PDCA e teto por entrada (R17) — 06/09/2026 |
| [`v1.9`](process-changelog-archive.md) | Arquiteto e dev revistos à luz de `.team/standards/` como base compartilhada; GAP de tipo `standard` ganha forma — 05/09/2026 |
| [`v1.8`](process-changelog-archive.md) | `standards/` promovido a diretório de primeiro nível e reclassificado como base de qualidade compartilhada (R16) — 05/09/2026 |
| [`v1.7`](process-changelog-archive.md) | Onboarding do projeto (R14) e brainstorm de descoberta funcional (R15) — 05/09/2026 |
| [`v1.6`](process-changelog-archive.md) | UX com repertório de padrões consolidados e método de pesquisa acionável por gatilho — 02/09/2026 |
| [`v1.5`](process-changelog-archive.md) | SM com repertório de PMBOK e APF acionável por gatilho, sobre a base Scrum — 02/09/2026 |
| [`v1.4`](process-changelog-archive.md) | Standards em dois níveis: princípios agnósticos de linguagem (Clean Architecture · Clean Code · CQRS · cobertura 80%) — 02/09/2026 |
| [`v1.3`](process-changelog-archive.md) | Reavaliação obrigatória no `review`, e os documentos do dev passam ao Arquiteto — 02/09/2026 |
| [`v1.2`](process-changelog-archive.md) | Evolução do processo distribuída por papel — 02/09/2026 |
| [`v1.1`](process-changelog-archive.md) | Comando de evolução do processo — 02/09/2026 · *(substituída pela v1.2)* |
| [`v1.0`](process-changelog-archive.md) | Linha de base do time — 01–02/09/2026 |

---

## v3.53 — Plano pela ficha: a quebra em Tasks traz a ficha de cada Task, um Arquiteto por Task e o template do plano só com o operativo (SM + Arquiteto) — 28/10/2026

**Instrução** (stakeholder, 28/10/2026, `note.md` itens 7 e 8, "pode então fazer" depois da explicação de como um item pesa no outro). **Decisão:** a primeira opção do piloto do item 8, ficha por Task na Planning + um Arquiteto por Task; os itens 7 e 8 numa entrega só, porque um sem o outro rende pouco. Os lotes por dependência ficam como segunda opção.
**Medido (sprint 4 do garden, plugin 3.52.2, transcripts da sessão `3af98c37…`):** a instância "Planos da H-K1" (8 planos, 100 chamadas, contexto de 19 → 434 mil) custou ≈ US$ 16,3, 63 % dos subagentes, 97 % disso em cache lido. A abertura chegava a ~117 mil antes da pesquisa: README 10,6 mil, `breakdown/S4.md` 19,1 mil, `sprint-backlog.md` 9,0 mil, template 15,6 mil, `plan.ps1` 11,9 mil; a listagem de `sprints/3/plan` (8,9 mil) não foi usada. A seção "Regras do formato" era 16,5 KB dos 34,9 KB do template.
**Causa:** cada chamada do modelo reenvia a conversa inteira acumulada, então o custo é a abertura somada à pesquisa e aos planos já escritos, reprocessados a cada passo. **Estimativa (não medição):** por Task com a abertura de hoje, −14 %; só o item 7, −9 %; com a abertura enxuta, −34 %; com a ficha, abertura ~35 mil e ≈ US$ 6 a 7 na H-K1 (≈ −55 %).
**Classificação:** fluxo (preparo do `sprint run`) · formato (template do plano: regras só operativas e regra 28; modelo novo `breakdown.md`) · comportamento de agente (abertura do Arquiteto pela ficha; não abrir o `plan.ps1`). **Sem regra nova** (34): a regra 25 do template muda de "uma instância por História" para "por Task com ficha; por História sem ela". **Papéis movidos (R17):** 2 — SM, Arquiteto.

### O que mudou
- **Planning, passo 4** (`workflow-sprint.md`, `roles/architect/README.md` §Quebra em Tasks, `templates/breakdown.md` novo): na seção de cada História do `breakdown/S<n>.md`, as **decisões comuns** (nomes que mais de uma Task usa, com a grafia final) e uma **ficha por Task** — `**Código a ler:**` (caminho, linha e porquê), `**Fontes:**` (SDD, standards, tela) e `**Nomes comuns:**`. A ficha só aponta; até ~25 linhas.
- **`sprint-run.md` etapa 1, "Por que assim" e §Como o SM verifica; `commands/sm.md`:** Task com ficha → um Arquiteto por Task, que abre o recorte da ficha, o template, o plano da dependência e o `architect/context.md`; primeiro a Task cujas dependências já têm plano, uma por vez (R1). Task sem ficha → a História numa instância, como na v3.51. Indicador do piloto no "Como o SM verifica".
- **Template do plano:** regras só com o operativo, numeração mantida (1–27), ✓ nas que o `plan.ps1` confere e "não abra o script"; o texto até a v3.52.3, íntegro, foi **relocado** para `roles/architect/plan-rules-why.md` (não é leitura do plano). Cabeçalho com `**Li além da ficha:**`; **regra 28** (plano pela ficha). 33,6 → 22,7 KB.
- **`agents/architect.md`:** leitura de abertura do plano pela ficha; o código do `plan.ps1` não é leitura. **`roles/architect/README.md`** §Preparo e a tabela de documentos; `deliverables/team-project/README.md` (linha do `breakdown/`).

### Por quê
O plano por História (v3.51) tirou a releitura por Task do P-r6, mas a instância longa passou a reprocessar a própria pesquisa e os planos já escritos a cada chamada. Dividir por Task só rende com a abertura pequena, e a abertura só fica pequena se alguém já tiver separado o que cada Task precisa ler: é o Arquiteto da Planning, que já tem a História e o código abertos para quebrar em Tasks. O template enxuto vale nas duas formas, mas pesa mais por Task: cada instância paga a abertura e grava o cache dela de novo.

### Conflitos com o processo vigente
A regra 25 e o "Por que assim" da v3.51 (plano por História) passam a valer só para Task sem ficha. O P-r6 mostrou o plano por Task custando 41 % — aquele era por Task **sem ficha**, relendo o projeto inteiro; o risco é medido no piloto.

### Quem passa a ser cobrado de forma diferente
**Arquiteto:** escreve a ficha e as decisões comuns na Planning; no plano pela ficha, declara o que leu além dela e usa os nomes comuns literalmente; não abre o `plan.ps1`. **SM/sessão:** confere no "Como o SM verifica" um Arquiteto por Task com ficha e o indicador do piloto. **Demais papéis:** sem mudança.

### Como saberemos que funcionou
Próximo sprint, contra o sprint 4: US$ do plano por Task construída (`consumption.md`) ao menos 40 % menor; 🔺 GAPs de plano por Task construída sem subir (sprint 4: um por Task); arquivos em `**Li além da ficha:**` por plano — ficha com muitos é ficha incompleta. Custo que não cai, ou GAP que sobe, devolve ao `/review` com os lotes por dependência como segunda opção.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.50 que saiu do vivo × arquivo (`.Contains`) | True; o vivo fica com v3.53, v3.52, v3.51 | ✅ |
| Extração/remoção | "Regras do formato" do template no HEAD (regras 1 a 27) × `plan-rules-why.md` (`.Contains`); `Length` do template | True; 33 628 → 22 693 B | ✅ |
| Substituição de padrão | `Grep` de "regra 25"/"planos de todas as Tasks"/"uma instância do Arquiteto" fora dos changelogs | só o fallback sem ficha (`run.ps1`, testes, comentário do G16), lido no contexto | ✅ |
| Entrega | `release.ps1` (C3); `run-check-tests.ps1`; `run-guard-tests.ps1` | C3 exit 0 (R18 3.53.0 nos três; R17 bloco v3.53 ≤ 10 240, 2 papéis, 3 entradas; ownership 63; órfãos 49 ok); conferências 206/0 (+6); guardas 253/0 (+1) | ✅ |

### Parte mecânica (implementada pela sessão principal, citada aqui)
`lib.ps1` `Get-Ficha`/`Resolve-FichaPath`; `run.ps1 next` grava `sprints/<n>/handoff/<T-ID>-ficha.md` e dispara o Arquiteto da Task; `plan.ps1` regra 28 (`**Li além da ficha:**`, nomes comuns no plano, caminhos da ficha existem); G16 (`subagent-stop.ps1`) não conta como trabalho da rodada o ID dentro de caminho (o plano da dependência citado no prompt rateava a rodada entre as duas Tasks).

---

## v3.52 — Orquestrador enxuto: sessão nova por ritual, `run` em sessões curtas, espera sem sondagem, registro de decisões e commit por Task (SM) — 23/10/2026

**Instrução** (stakeholder, 23/10/2026, `note.md` itens 1 a 9 e decisões em formulário): reduzir o custo da sessão que orquestra, medido no benchmark `sunscape-P-r1` (plugin v3.51.3). Decisões: (1) o fim de cada Task é **parada permitida** (`.team-project/.safe-point`); (2) **ampliar a R29**, sem regra nova; (3) o brief do brainstorm é gravado ao **fechar**, em `scrum-master/context.md` §"SDD em elaboração"; (4) hooks e scripts a sessão principal implementa.
**Medido (itens 1 a 4):** passo `run` de 504 min, US$ 14,20; a sessão que orquestra gastou 67 % (US$ 10,76 em 113 chamadas, mediana de 376 mil tokens, máximo de 438 mil), quase tudo releitura do próprio contexto; leitura de documentos pesou ~6 %, a construção ~US$ 6,3 e o dev em Haiku menos de US$ 1. O contexto já chegava a ~200 mil quando o `run` começava (init a plan na mesma sessão). **48 chamadas de `Start-Sleep`** (60 a 598 s) custaram US$ 3,68. A trilha `fix` começaria com ~440 mil tokens.
**Causa confirmada da espera (item 3):** o disparo em primeiro plano bloqueia normalmente (62 disparos, até 3.824 s) — a hipótese do vigia de 600 s caiu. Vem de **(a)** retomada por `SendMessage`, assíncrona, com a sessão sondando o disco, e **(b)** a sessão rodando ela mesma comando longo em segundo plano (aceite, lotes com `adb`) e sondando por horas — trabalho do `operator` (R28).
**Classificação:** fluxo (`run`, `fix`, rituais) · regra ampliada (R29; R15 e R27 com exceção) · formato (modelo novo `run-log.md`) · propriedade (`run-log.md`, `.safe-point`). **Sem regra nova** (34). **Papéis movidos (R17):** 1 — SM.

### O que mudou
- **R29 ampliada** (`working-rules.md`, índice): troca de ritual, fronteira sprint → fix e cada Task do `run`; tudo o que o ritual decide fica em disco antes de fechar. **R15:** o brainstorm não escreve durante as fases, mas **ao fechar** grava o brief (≤ 15 linhas, fronteira de escopo, confirmação) em `context.md` §"SDD em elaboração". **R27:** no `run` a retomada é sempre instância nova em primeiro plano.
- **Cada ritual** (`workflow-ritos.md` onboarding e brainstorm, `workflow-sdd.md`, `workflow-sprint.md` prepare/plan/review/close, `sprint-run.md`, `fix-run.md` note → fix plan → fix run): lista fixa de leitura na abertura e fecho "em sessão nova (`/clear` e o comando)".
- **`sprint-run.md`:** sessão curta, uma Task por sessão; commit `T-<nnn>: <título>` no fechamento (nunca `.team-project/`, R31; sem git, cópia como o `fix run`); parada **(f)** e `.safe-point`; §Disparo e espera (primeiro plano, sem `Start-Sleep`, comando longo só pelo `operator`); §Retomada sem `SendMessage` — **inclusive Haiku** (assíncrono, e o ganho de reaproveitar o contexto dele é de centavos); **toque de cache retirado** (não dispara durante a chamada bloqueante, e a sessão curta regrava barato); preparo de História independente vira passo sequencial do `next` (exceção da R1 retirada); §Registro de decisões.
- **`templates/run-log.md`** (novo): quando · item · decisão · porquê · evidência; `sprints/<n>/` e `fixes/B-<nnn>/`; lido só em retomada, bloqueio e Review; diz o que fica no `kanban.md`, `handoff/`, `guards.log`, `.usage-limit` e `.safe-point`. `artifact-ownership.md`: linhas do `run-log.md` e do `.safe-point`.

### Por quê
Quase todo o custo da sessão era reler contexto longo; sessão curta (50 a 80 mil), espera dentro da chamada bloqueante e passagem pelo disco o tiram sem retirar verificação alguma. Estimativa (não medição): a releitura do `run` do P-r1 (US$ 14,5) cairia para ~US$ 3 e a espera (US$ 3,7) para perto de zero; cada sessão nova regrava ~US$ 0,15 a 0,20.

### Conflitos com o processo vigente
O "Fim de Task não é parada" do `sprint-run.md` e a G20 ganham a exceção do `.safe-point`. A v3.49 mandava retomar Haiku por `SendMessage` e criar o toque de cache: esta entrada reverte as duas. A G19 hoje só nega papel caro depois de 5 min.

### Quem passa a ser cobrado de forma diferente
**Sessão/SM:** abre cada ritual lendo só a lista fixa, para em sessão nova, não sonda o disco nem roda comando longo, anota o `run-log.md`. **Dev:** o commit da Task é do script. **Demais papéis:** sem mudança de roteiro.

### Como saberemos que funcionou
P-r2 (SunScape, mesma regra de comparação): contexto mediano da sessão ≤ 80 mil tokens e máximo ≤ 150 mil; zero chamada de `Start-Sleep` da sessão no `run`; releitura da sessão ≤ US$ 4; cada Task ✅ com um commit `T-<nnn>:`; nenhum ritual iniciado na sessão que já rodou outro sem aviso.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.49 que saiu do vivo × arquivo (`.Contains`) | True; vivo termina em `---`, arquivo tem v3.49 antes da v3.48 | ✅ |
| Substituição de padrão | `Grep` de `SendMessage`/`segundo plano`/`CronCreate`/toque em `roles/scrum-master/` | restam só `consumption.md` (histórico de rodada) e `artifact-ownership.md` (`.active-agents`), lidos no contexto; o resto reescrito e lido | ✅ |
| Entrega | `release.ps1` (C3); `run-check-tests.ps1`; `run-guard-tests.ps1` | C3 exit 1 só por R18 (v3.52 ainda sem CHANGELOG/bump, a sessão escreve); R17 ok (bloco 5,8 KB, 1 papel), ownership 62 ok, órfãos ok; conferências 161/0; guardas 227/0 | ✅ (R18 esperado) |

### Parte mecânica (implementada pela sessão principal, citada aqui)
`run.ps1 done` grava `.team-project/.safe-point` (JSON `task`, `sprint`, `desde`; só no `sprint run`) e faz o commit `T-<nnn>: <título>` (sem `.team-project/`; sem git, checkpoint por cópia); `next` mostra RETOMADA e apaga o marcador (o `start` também). **G20** libera com `.safe-point`; **G21** (`hooks/prompt-submit.ps1`) avisa ritual aberto em sessão que já rodou outro; **G22** (`pre-tool`) nega à sessão principal `Start-Sleep` e comando em segundo plano durante o `run`. **Ainda proposta ao stakeholder:** G19 negar `SendMessage` a qualquer papel com `.active-run`; retirar o `CronCreate` do toque de cache onde `SessionStart`/`commands` o mencionem; `ownership.json` para o `run-log.md`; driver do benchmark sem `--resume`.

### Addendum v3.52.2 — executor de Task, agente assíncrono, retomada após queda, plano que prova, Q-S<n> e Review adiada (SM + Arquiteto + Dev + QA + UX) — 26/10/2026

**Instrução** (stakeholder, 26/10/2026, `note.md` itens 1–17, avaliação do sprint 3 do piloto em v3.52.0; tudo numa entrega). **Decisões:** opção A — executor de Task (spike aprovado: subagente espera o filho encerrando o turno, três níveis, um aviso só à sessão); correção do portão = Task `Q-S<n>`; Review adiável por caminho formal; o SDD de mudança visível o Arquiteto consolida (o dev não edita).
**Medido:** sessão por `message.id` 207 → 228 mi (+10 %; a análise somava por linha, ~1,8×); 87/87 rodadas assíncronas; 195 bloqueios G20 (~230 respostas "aguardando", ~100 mi); 27 de 29 GAPs nascidos no plano.
**Classificação:** fluxo (`run`, `fix run`, Review) · regra ampliada (R21, R25, R27, R28, R29, R33) · formato (plano: Contagem, Premissas, Documentos vivos; `sprint-validation`; `sprint-review` adiada; seção Q-S) · propriedade (`run-log.md` com o executor; `.interrupted`) · agente novo (`task-runner`). **Sem regra nova** (34). Este bloco é a reversão parcial da v3.52 no que supunha agente em primeiro plano e `/clear` por Task.

- **SM:** `sprint-run.md` (§Disparo e espera, §Executor de Task, §Retomada após queda, §Validação com Q-S<n> e Decisão do PO, escalonamento por falha de papel); `fix-run.md` (executor por F-ID); `working-rules(-index).md`; `artifact-ownership.md`; `workflow-sprint.md` §5e; modelos `sprint-review`, `sprint-backlog`, `kanban`, `run-log`, `consumption` (sessão por `message.id`), `retrospective`, `plugin-report`; `commands/sm.md`, `dev.md`, `po.md`; `agents/task-runner.md`.
- **Arquiteto:** "decida, documente e prove — não construa"; regras 26 (Premissas) e 27 (Documentos vivos) do plano; mutante que compila; contagem pelo próprio Arquiteto, execução pelo `operator`. **Dev:** volta ao executor; cita `report.md` e o chamador do `operator` (R28).
- **QA:** veredito `**Veredito (rodada N):**` e `**Decisão do PO:**` (só ⚠️); achado do portão vira Q-S<n>. **UX:** `/ux prototype` com abertura e fecho (R29). **Rituais:** init/update §7k propõem `quality` e `verify.compile`.
- **Instrumentos (stakeholder, aplicados nesta entrega):** G20 sem filtro `bg`; `.active-agents` com `session`/`parent`; SessionStart → `.interrupted`; G7/G8 do executor; `run.ps1` (executor, retomada, commit `-F`, veredito, Q-S, `SESSÃO:`), `plan.ps1` (Contagem, Premissas, Documentos vivos), `lib.ps1` (`Get-Mutations`, `Get-PlanScope`, `targets: {}`, árvore sem `docs/`), `close`/`kanban`/`project`/`consumption`.
- **Indicador:** próximo sprint com zero G20 por espera, linha `SESSÃO:` ≤ 150 mil, orquestração por Task ≤ 5 mi, GAPs de origem no plano ≤ 10 de cada 29, toda correção do portão como Q-S<n>.
- **Evidência (R19):** guardas 249/0 (+20), conferências 190/0 (+27), C3 ok; `grep` de `run_in_background`/"primeiro plano"/"2º plano" nos documentos de processo: só histórico, lido no contexto.

### Addendum v3.52.3 — espera da verificação, aceite sem alvo, GAP no registro, consumo em US$ (SM + Dev) — 27/10/2026

**Instrução:** stakeholder, 27/10/2026, `/review` dos itens 1–5, 9 e 10 do `note.md` (sprint 4 do garden). Sem regra nova (34), sem conflito. **Mudou:** dev — comando movido para segundo plano: encerre o turno e espere o aviso; exit 5 (`agents/developer.md` regra 6, `roles/developer/README.md`); modelos `run-log.md` (o `done` grava GAP e ambiente) e `consumption.md` (coluna US$). Instrumentos: CHANGELOG v3.52.3. **Indicador:** zero "moved to the background" e zero espera por sondagem no próximo sprint. **Evidência:** conferências 200/0, guardas 252/0, C3 ok.

---
## v3.51 — O sprint do benchmark: dev constrói e verifica sozinho, plano por História ao lado dos cenários, portão do QA no fim, orquestração por script, contexto e cache, ambiente em qualquer tecnologia (SM + Arquiteto + Dev + QA + PO) — 21/10/2026

**Instrução** (stakeholder, 21/10/2026, a partir do benchmark P × N-forte × protótipo Coordenador–Operador; plano aprovado em `plano-plugin-p-plus.md`, decisões no §8 e em formulário): manter o processo e a documentação antes e depois da Sprint, mas chegar o mais perto possível do N-forte na construção — o plano e os cenários prontos antes do dev, o dev (Haiku) construindo, verificando e corrigindo sozinho, o QA como portão de validação do produto (qualidade de código e funcional, com prova no alvo real) uma vez no fim, a dúvida subindo ao Arquiteto só quando é dúvida; atacar a transferência de contexto e a perda de cache; scripts para qualquer tecnologia (Android e Web nesta versão; API e Windows desktop depois); toda decisão ao stakeholder com o problema simples, um exemplo e formulário; os itens do `note.md` e as propostas pendentes.
**Classificação:** fluxo da Sprint e da trilha `fix` · formato de documento (plano, relatório de entrega, validação do sprint, Kanban) · comportamento de agente (os seis papéis) · guardas novas (G19, G20) e guarda alterada (G3) · scripts novos e alterados · standard (perfis de nível 2 por tecnologia). **Sem regra nova** (34): R7, R12, R22 e R30 ganham o parágrafo v3.51.

### O que mudou

- **Construção (A1–A6).** A Sprint abre com o **preparo da construção** por História: o QA escreve os cenários executáveis (`.scn`, linguagem do `accept.ps1`), depois **uma instância do Arquiteto** escreve os planos de todas as Tasks da História. O plano fica enxuto (regras 22 a 25: ~12 KB, cenários, risco, layout novo) e o `plan.ps1` confere tamanho, cenários, risco e render. O **dev** constrói, roda `verify` e os cenários da Task no alvo, e corrige sozinho; a Task fecha pela **evidência do dev** (`close.ps1`, R7-aceite). O **QA** é o portão do sprint (`/qa sprint <n>`, `validation.md`): mede pelo `operator` (`quality.ps1`, `accept.ps1`) e julga SOLID, clean code, aderência e segurança. Documentos vivos (R12) consolidados **uma vez** pelo Arquiteto (`docs-consolidation.md`). Teste pelo risco, freado pela cobertura medida no portão.
- **Orquestração (B1, B2).** `scripts/checks/run.ps1` (`next`, `start`, `done`, `handoff`) devolve a próxima ação pronta; o `sprint-run.md` foi reescrito para esse fluxo (34 KB → ~14 KB).
- **Contexto e cache (C1–C5).** Papel em Sonnet ou Opus parado há mais de 5 min abre **instância nova** com o **cartão de passagem** (~2 KB, `handoff/<T-ID>.md`); a **G19** nega o `SendMessage` fora disso. Comando longo só no dev, no `operator` ou em script. Os agentes leem só as seções do README do time que usam; o dev lê cabeçalho, §6, §9 e o próprio bloco do plano.
- **Ambiente (D1–D4) em qualquer tecnologia.** `verify.ps1` com tempo limite próprio, árvore de processos encerrada e higiene por ferramenta (`tool-hygiene.json`: Gradle sem daemon, `dotnet` sem reúso de nó, `CI=true` no Node); **exit 4 = falha de ambiente**. `target.ps1` (pré-voo e reparo: emulador desenhando a tela, site no ar) e `accept.ps1` (cenários no alvo, Android por uiautomator, Web por Playwright com Edge/Chrome de reserva, captura por cenário), com a trava de dono único. `SessionStart` avisa perfil do Windows com acento.
- **Trilha `fix` (§3a).** Defeito vira cenário `FX-<nnn>` (falha antes, passa depois, com captura); métricas só dos arquivos tocados; formulário dos ajustes no formato H1.
- **Organização (G1–G4).** `kanban.md` no lugar do `burndown.md` (Kanban, Burndown e o controle das Tasks embaixo); `kanban.html` regravado a cada transição, sem token. `standards/stacks/<tecnologia>/` (.NET com `desktop.md`, Kotlin/Android, React, Angular) com ferramenta por regra Q, coluna "ecossistema restrito" e Ficha pré-preenchida; índice com identificadores.
- **Comunicação (H1).** Modelo `templates/stakeholder-question.md`; a G3 nega formulário sem exemplo prático.
- **Paradas (propostas a e b).** Hook `Stop` (**G20**): barra o fim de turno com Task elegível e `.active-run`; o `SessionStart` **retoma** o run em vez de só avisar. Proposta c (energia) no `how-to.md`; proposta d (render no `plan.ps1`) entrou ajustada pelo A6. O `proposals-pending.md` foi apagado (todas aplicadas).
- **Medição (M1).** `transcript-metrics.js activity`: custo por atividade, igual para qualquer braço do benchmark.

### Por quê

Medido no P-r6 (Mente Ativa, v3.50.1, transcripts): Arquiteto 41 % do custo e 632 min de relógio; sessão principal 35 %, a 274 mil tokens por chamada; dev em Haiku 3 %. O plugin escreveu mais documento (planos de 42 KB em média) que código e 6× mais teste que o N-forte. Perda de cache: 15 % no P-r6, 30 % no protótipo, zero no N-forte. No protótipo, a vistoria repetida depois do construtor nunca achou defeito real, e 38 % do custo foram chamadas que só diagnosticaram ambiente quebrado.

### Quem passa a ser cobrado de forma diferente

- **Dev:** fecha a Task com a própria evidência, inclusive os cenários no alvo; corrige sem esperar o QA; exit 4 é parar e dizer.
- **QA:** sai da verificação por Task; entra no portão do sprint e na escrita dos cenários executáveis; não roda comando longo.
- **Arquiteto:** planeja por História, sem instância por Task; consolida R12 uma vez; não roda comando longo.
- **Sessão / SM:** orquestra por `run.ps1`; não retoma papel caro depois de 5 min; formulários no formato H1.

### Conflitos com o processo vigente

O `/qa <ID>` continua para validação avulsa fora do `run`; a evidência do QA por Task (`evidence/`) continua aceita pelo `close.ps1` (regra anterior). Sprint aberto antes da v3.51 segue com o `burndown.md` e o controle no `sprint-backlog.md` — os scripts leem os dois lugares.

### Como saberemos que funcionou

Etapa 6a do benchmark (P+ no SunScape, contra N-forte e protótipo, mesmo oráculo): a construção do dev ≤ 1,5× o custo e ≤ 2× o relógio do N-forte; qualidade 15/15 e lote 4/4; documentação não abaixo do P-r6 na avaliação cega. Projeção registrada no plano: de US$ 59 para ~US$ 28 num projeto como o Mente Ativa.

### Evidência (R19)

Suítes: guardas e conferências (contagem na entrega), C3, `claude plugin validate`. Validação real: `accept.ps1` e `target.ps1 -Repair` no emulador do benchmark (3 cenários do SunScape com captura; reinício do AVD em 88 s) e num site local pelo Edge headless (deslizante, toque, contagem, ordem; servidor subido e encerrado pelo executor).

### Pendente do stakeholder

Autorização de custo da Etapa 6a (P+ no SunScape). API e Windows desktop no executor de cenários: próximo incremento.

### Addendum v3.51.5 — Task habilitadora fica sob uma História (SM) — 23/10/2026

**Decisão** (stakeholder, pendência da v3.51.4): R20 mantida. Planning passo 4 e `sprint-backlog.md`: a Task habilitadora fica sob a 1ª História que depende dela; as outras a citam em "Depende de". **Evidência:** C3 ok.

### Addendum v3.51.4 — o run do SunScape e o sprint 2 do garden: G14 lendo o que os papéis escrevem, limite de uso legível, quadro que não perde linha (SM + Arquiteto + Dev + UX) — 23/10/2026

**Instrução** (stakeholder, 23/10/2026, `note.md` itens 1–16 e `plugin-report-garden.md` itens 1–27, tudo numa entrega só; item 14 decidido em 23/10: reduzir a partida do Gradle sem tirar mutação nem verificação completa).
**Classificação:** guardas (G8, G14, G16, G20) · fluxo do `run` (paradas, retomada, marcador) · formato (Kanban, plano) · instrumentos (`run`, `mark`, `close`, `kanban`, `plan`, `verify`, `dispatch`). **Regra nova: nenhuma.** Paradas legítimas ganham **(e)** pausa pedida pelo stakeholder no ponto seguro (o stakeholder pediu o ponto seguro no item 11).

- `sprint-run.md`: 🟦 no preparo, sem `.scn` sem `targets`; `run.ps1 done` confere, marca 🟪 e fecha (GAP → 🟨); `verify` exit 3 = parcial; §Retomada após limite de uso; §Pausa segura; "## Agora"; marcador sob trava.
- Modelos `kanban.md` e `sprint-backlog.md`; dev (exit 3, `target.ps1`, `-Precheck`, comando no topo do bloco); Arquiteto (`plan.ps1` cobra §3/§9 e trecho único); UX (a linha do protótipo no pacote é do SM); `kotlin-android/quality.md` (`verify.daemon`, `verify.compile`).
- **Fora do plugin:** item 9 (driver do benchmark). **Sem mecanismo novo:** item 8 (custo da T-001 — voltas da G14 e replano; medir com a "Espera de comando"); item 7 (o UX não estava no run: G19 no SDD, G8 na Planning).
- **Pendente do stakeholder:** Task habilitadora sem História (garden 20) contra a R20 — o close segue reprovando até a decisão.
- **Indicador:** próximo braço P+ com ≤ 3 negações da G14 e nenhuma de leitura; zero R7/R24/R28 por formato; `.usage-limit` em toda parada por limite.
- **Evidência (R19):** guardas 217/0 (+28), conferências 159/0 (+19), C3 ok.

### Addendum v3.51.3 — kanban do bloco de fix marcado na entrada de cada fase (SM) — 22/10/2026

**Instrução** (stakeholder, `note.md`): "o kanban do sprint e do fix devem ser atualizado a cada transição de fase de trabalho para verdadeiramente indicar o status da evolução das tarefas". No sprint o quadro já acompanha cada transição (`mark.ps1`, `close.ps1`, G16); no bloco de fix o estado da F-ID era deduzido de rodadas **concluídas**, então ficava em ⬜ durante a rodada do dev.
**Classificação:** fluxo da trilha `fix` (roteiro SM) · formato de documento (`kanban.md`) · script alterado (`kanban.ps1`, aplicado pelo stakeholder). **Sem regra nova** (34).

- `kanban.ps1 -Block B-<nnn> -Fid F-<n> -To plan|build|qa` marca a F-ID na **entrada** da fase (`fixes/B-<nnn>/.marks`) e regrava na hora; as rodadas (G16) só confirmam o estado e somam custo.
- `fix-run.md`: **Marca de fase** no preâmbulo do §Run (antes de acionar dev, Arquiteto ou QA; QA uma chamada por F-ID), `-To plan` no passo 4 do §Plan, fechamento sem `-Fid`.
- `templates/kanban.md`: variante do bloco marca na entrada de cada fase (fechamento e "Critério que caiu" seguem derivados); notas dizem "a cada transição e ao fim de cada rodada"; histórico de versão enxugado do cabeçalho.
- **Indicador:** no próximo `fix run`, cada F-ID tem a marca de entrada (🟦/🟨/🟪) no `kanban.md` antes da primeira rodada da fase.
- **Evidência (R19):** `release.ps1` (C3) ok, conferências 140/0, guardas 189/0; `-Fid F-1 -To build` em bloco de teste moveu a F-ID ⬜ → 🟨 com "marca na entrada da fase", e F-ID fora do plano foi recusada.

### Addendum v3.51.2 — relato de uso do `fix` e um quadro só (SM + Arquiteto + Dev + QA + PO) — 22/10/2026

**Instrução** (stakeholder, 21 e 22/10/2026, `note.md`, itens 1–10 e decisões em formulário): resolver, pela opção que **não aumenta o gasto**, o que a v3.51.1 mostrou na trilha `fix` (negações da G14 ao dev e ao Arquiteto, ficha negada pela G8, veredito reprovado pelo C4 por formato, `consumption.md` do bloco que não nasce, `verify -Mode mutation` que não rodou) e dar ao sprint e ao bloco **um quadro só**, em Markdown, com o gasto de cada rodada. Hooks, scripts, versão e CHANGELOG aplicados direto nesta rodada.
**Classificação:** comportamento de agente (roteiros do dev, do Arquiteto e do QA) · formato de documento (`kanban.md`, `fix-plan.md`, `verdict.md`) · guarda alterada (G14, G16) · script novo (`kanban.ps1`, no lugar do `kanban-html.ps1`) e alterados · fluxo da trilha `fix`. **Sem regra nova** (34).

#### O que mudou

- **Item 1 (e 5, consequência).** `fix-run.md` §Run passo 2 cita o comando completo do `verify.ps1` (`-Mode full`, depois `-Mode mutation -Plan …`), um por chamada, sem `cmd /c`, `-ExecutionPolicy` nem `Tee`; o `developer/README.md` diz que teste do projeto é o prefixo de `runCommands` puro. **G14** (`hooks/pre-tool.ps1`): script de conferência liberado também como trecho de comando composto (`Set-Location …; $log = …; powershell -NoProfile -File "<plugin>/scripts/checks/x.ps1" … | Select-Object …`), **só com o caminho dentro de `${CLAUDE_PLUGIN_ROOT}/scripts/checks/` (antes passava qualquer `scripts/checks/*.ps1`, inclusive do projeto). Sem o item 1, o dev não escreveria evidência à mão em `verify/` (item 5).
- **Item 2.** A negação de `cmd /c` diz "rode o comando direto, sem cmd /c".
- **Item 3.** `$env:TEMP`/`$env:TMP` em variável ou no destino se resolve (criar pasta no scratchpad passa); **executar arquivo do scratchpad (`node` etc.) continua negado** — contornaria a G8 e a G9. No run (`sprint run`, `fix plan`, `fix run`) o Arquiteto valida lendo o código e escreve "não validado — o dev confirma no passo <n>"; scratchpad executável e `operator` ficam só no sprint fora do run (`architect/README.md`, `fix-run.md`).
- **Item 4 (sem exceção na matriz).** `fix-run.md` §Promoção: o Arquiteto registra `**Critério que caiu:**` no mini-plano; dev e QA, no próprio relatório, e a sessão copia a linha para o mini-plano (sem invocar o Arquiteto só para isso); a sessão muda o estado e devolve ao PO, que grava `## Destino` na ficha (a linha que o C4 confere) **na invocação que a promoção já dispara**. A ficha continua só do PO.
- **Item 6.** `quality-assurance/templates/verdict.md` (trilha fix): o formato que o C4 lê (R33/3) fica explícito — `> comando` em linha própria, saída em bloco nas linhas seguintes, `exit <n>` na linha do rótulo. O C4 **não foi flexibilizado**.
- **Item 7.** `kanban.ps1 -Block B-<nnn> -Init` cria a pasta, o `consumption.md` e o `kanban.md` do bloco no passo 2 do `fix plan`; o hook G16 (`subagent-stop.ps1`) os cria na primeira rodada se faltarem (rede).
- **Item 8.** `fix-plan.md` ganha `**Mutações:**` por F-ID no formato do `verify.ps1`; o `-Mode mutation` lê todos os blocos e, sem `**Arquivos tocados:**`, usa `- produção:`/`- teste:` como escopo; o dev o roda depois do `full` do bloco.
- **Itens 9 e 10 — um quadro só.** `kanban.html` e `kanban-html.ps1` **saem do plugin**. O `kanban.ps1` regrava, ao fim de cada rodada (G16) e a cada transição (`mark.ps1`, `close.ps1`), o `## Kanban` e a nova `## Rodadas` do `sprints/<n>/kanban.md` — por tarefa e fase (Plano · Construção · Verificação · Outros), por papel e modelo, e rodada a rodada, **custo = tokens e tempo** — e o `fixes/B-<nnn>/kanban.md` **inteiro** (F-IDs nas colunas do sprint; promovida e devolvida como nota no Registro). `fix-run.md` §Fechamento roda `kanban.ps1 -Block` uma vez depois do `## Fechamento`. Documentos: `templates/kanban.md` (seção Rodadas e variante do bloco), `artifact-ownership.md` §1 (bloco), `project-context.md`, `how-to.md`, `rituals/team-init.md` sem o `kanban.html`.
- **Roteiro mais curto.** `fix-run.md` §Run: 7 443 → 6 383 B (arquivo: 21 771 → 21 451 B), com as regras novas dentro.

#### Por quê

Cada negação custou uma invocação extra ou a sessão fazendo o trabalho do papel (o dev sem `verify`, o PO copiando uma linha, o QA reescrevendo um veredito); o quadro em dois formatos repetia a informação e o gasto da rodada só aparecia no `consumption.md`. As correções saem de roteiro, modelo e script — nada de papel novo nem instância a mais.

#### Quem passa a ser cobrado de forma diferente

- **Dev:** roda o `verify` com o comando completo e sem decoração; reporta a promoção no relatório.
- **Arquiteto:** no run não executa nada — lê e marca "não validado"; escreve `**Mutações:**` e a promoção no mini-plano.
- **QA:** escreve `Antes`/`Depois` no formato que o C4 lê. **PO:** grava `## Destino` na invocação da promoção. **SM/sessão:** `-Init` no `fix plan`, `kanban.ps1 -Block` no fechamento, e copia para o mini-plano a promoção que o dev ou o QA reportou.

#### Conflitos com o processo vigente

Nenhum. A G14 ficou **mais estreita** num ponto (só scripts do plugin) e mais larga noutro (trecho composto). A matriz de propriedade não mudou de dono; o `kanban.md` do bloco é do SM, escrito por script. O `kanban.html` da v3.51 (acima) é revertido por esta entrada.

#### Como saberemos que funcionou

No próximo `fix run`: zero negações G14 ao dev em `verify.ps1` e ao Arquiteto por executar arquivo do scratchpad; `verify mutation` com ok em cada F-ID não promovida; nenhuma F-ID reprovada pelo C4 R33/3 por formato; `consumption.md` e `kanban.md` do bloco existindo desde o `fix plan`; nenhum `Edit`/`Write` negado pela G8 na ficha.

#### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Substituição de padrão | `Grep "kanban\.html\|kanban-html"` em `RAIZ/`, fora de `CHANGELOG.md`, `plano-plugin-p-plus.md`, v3.51 arquivada e testes que afirmam a ausência | zero fora de `process-changelog.md` (v3.51 e este adendo, histórico), `kanban.ps1:1` e dos testes que afirmam a ausência (`run-check-tests.ps1`); `note.md` limpo | ✅ |
| Extração/remoção | `Length` de `fix-run.md` e do §Run, antes (HEAD) × depois | 21 771 → 21 451 B; §Run 7 443 → 6 383 B | ✅ |
| Entrega | `release.ps1` (C3) | R18 ok (3.51.2 nos três); R17 ok (bloco v3.51 com 13 658 B ≤ 17 920, 5 papéis, 3 entradas); ps1-5.1 ok; ownership ok (62 regras); órfãos ok (47 modelos) | ✅ |

#### Pendente do stakeholder

Reiniciar a sessão (comportamento de agente e guarda mudam). Versão, `CHANGELOG.md` e `note.md` da sessão.
---
