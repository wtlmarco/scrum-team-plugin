# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
| [`v3.55`](process-changelog-archive.md) | Fechamento da margem, verificador por caminho e padrão de ids de teste (SM + Arquiteto + Dev + QA) — 05/11/2026 |
| [`v3.54`](process-changelog-archive.md) | Mutação pela regra e margem do dev: o Arquiteto diz o que provar, o dev escreve o trecho e corrige o defeito do próprio teste, com travas no fechamento (SM + Arquiteto + Dev + QA) — 04/11/2026 · *com addenda v3.54.1 e v3.54.2* |
| [`v3.53`](process-changelog-archive.md) | Plano pela ficha: a quebra em Tasks traz a ficha de cada Task, um Arquiteto por Task e o template do plano só com o operativo (SM + Arquiteto + Dev + QA) — 28/10/2026 · *com addenda v3.53.1 a v3.53.7* |
| [`v3.52`](process-changelog-archive.md) | Orquestrador enxuto: sessão nova por ritual, `run` em sessões curtas, espera sem sondagem, registro de decisões e commit por Task (SM) — 23/10/2026 |
| [`v3.51`](process-changelog-archive.md) | O sprint do benchmark: dev constrói e verifica sozinho, plano por História ao lado dos cenários, portão do QA no fim, orquestração por script, contexto e cache, ambiente em qualquer tecnologia (SM + Arquiteto + Dev + QA + PO) — 21/10/2026 |
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

## v3.58 — Security Engineer: pentest e secure code review sob demanda, com o laço que leva o achado ao standard do Arquiteto (SM + Arquiteto + Security Engineer) — 2026-11-12

**Instrução:** (stakeholder, 11–12/11/2026) "criaremos uma nova role como analista de segurança … para avaliar o sistema"; e "uma revisão de práticas de segurança que direcione aos standards do Arquiteto a base para escrita de planos de código e arquitetura que já atenda aos princípios de segurança que esses testes irão validar".
**Classificação:** escopo de papel · comportamento de agente · propriedade · formato de documento

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `agents/security-engineer.md`, `commands/sec.md` | novos | Papel **sob demanda** (fora dos seis dos rituais), Sonnet, três modos: `blackbox`, `graybox`, `whitebox` |
| `roles/security-engineer/` | novo | README, skills, `playbooks/{black,gray,white}-box.md` (generalizados do marcador-next), `templates/{context,security-report}.md` |
| `standards/implementation-appsec-web-api.md` | novo (transversal) | Superfície web/API: validação, injeção, saída/XSS, mass assignment, token na borda, CORS, cabeçalhos/HSTS, rate limiting, SSRF, erros, SCA — o eixo que o `security-lgpd` não cobre |
| `standards/README.md` | índice | linha do appsec |
| `hooks/common.ps1` | CallerByRole, Get-CallerToken, Get-PlainRole, ModelRoles/Aliases | `sec` / `security-engineer` |
| `hooks/pre-tool.ps1` | G7 | o papel dispara o `operator` (R28) |
| `hooks/ownership.json` + `artifact-ownership.md` §1 | G8 | `roles`; `.team-project/security-engineer/context.md`, `security/**`, `roles/security-engineer/**`, process-changelog; linha nova em §1 (relatórios de segurança) |
| `deliverables/team-project/{README.md,models.json}`, `rituals/review-contract.md`, `README.md`, `how-to.md`, `.claude-plugin/*` | registros | seeds sob demanda, chave de modelo, alcance do `/review`, tabelas e contagens de comando/agente |

### Por quê
A checagem de segurança do QA (frente 3) é **por Task, no portão** — rasa para um pentest ou uma revisão de segurança de código do **sistema**. Faltava um papel dono de um engajamento profundo, sob demanda, com relatório. E faltava o **laço**: o que o pentest acha no fim, o standard deve exigir no começo — por isso o achado cuja causa-raiz é standard ausente/fraco vai ao Arquiteto complementar `standards/`, como o QA já faz com defeito de standard (R16). A análise de lacuna mostrou identidade/autorização/LGPD já cobertas; a superfície web/API dinâmica (injeção, CORS, cabeçalhos, rate limiting, token na borda, SCA) não — virou o `implementation-appsec-web-api.md`.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Security Engineer (novo) | Dono do engajamento sob demanda; reporta, não corrige; roteia achado de código ao PO/QA e de causa sistêmica ao `/review` |
| Arquiteto | Dono editorial do novo standard appsec; recebe o achado de causa sistêmica pelo `/review` |
| QA | Mantém a frente 3 (checagem por Task); não se sobrepõe ao `/sec` |
| SM | Matriz §1 e manifesto ganham o papel; mantém a coerência do `context.md` |

### Conflitos com o processo vigente
Nenhum: o papel é sob demanda, fora dos seis dos rituais; não entra em onboarding/sdd/sprint. O homônimo `/qa security` × `/sec` é distinguido no README e no `how-to` (§1b).

### Como saberemos que funcionou
Um engajamento `/sec` produz relatório em `.team-project/security/<data>/` com achados roteados; um achado de causa sistêmica vira entrada de `/review` que complementa `standards/`. Indicador: planos de Task que tocam borda HTTP passam a citar `implementation-appsec-web-api.md`.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| substituição de padrão (playbooks sem marcador-next) | `Select-String roles/security-engineer/playbooks/*.md -Pattern 'marcador-next\|eyeclinic\|X-Authorization\|localhost:3000'` | 0 ocorrências | ✅ |
| Entrega | `release.ps1` (C3) · `run-guard-tests.ps1` · `run-check-tests.ps1` | ver CHANGELOG v3.58.0 | ✅ |

### Pendente do stakeholder
`agents/security-engineer.md`, `commands/sec.md` e `.claude-plugin/*` são do stakeholder — propostos nesta entrega, aplicados com a aprovação do PR.

---

## v3.57 — O sprint real: protocolo de espera, sessão medida e reiniciada pelo teto, suíte só pelo verify, Arquiteto com contexto enxuto e o que o sprint 5 do garden não tinha onde pôr (SM + Arquiteto + Dev + QA) — 07/11/2026 · *com addenda v3.57.1 a v3.57.3*

**Instrução** (stakeholder, 07/11 a 10/11/2026: relatório intermediário do sprint 5 do garden e `decisoes-plugin-report.md` → v3.57.0; `note.md` itens 1 a 13 → v3.57.1; ocorrências do sprint 5, itens 14 a 24, com as decisões de 09/11 por formulário → v3.57.2; o `plugin-report.md` final do sprint 5 conferido contra a 3.57.2, com as decisões de 10/11 por formulário → v3.57.3, "podemos já fazer todos").
**Medido (sprint 5 do garden, plugin 3.57.0):** sessão principal 364 M tokens (46,7 % do total, 8,5× o sprint anterior), 56 mil → 409 mil de contexto numa sessão; executor de Task com 83 % das rodadas em ≤ 3 chamadas; Arquiteto em Opus 37,6 % de papéis + `operator`, planos refeitos inteiros; 3 suítes completas ao mesmo tempo numa Task; 11 entradas fora da Planning (+35 % da capacidade); 6 das 11 lições de GAP de plugin eram Tasks sem caminho no `verify`/`close`; `operator` sem chamador em 27 %.
**Classificação:** regra (G14 da suíte; G7 do chamador; regras 33, 34 e 35 do plano; teto da sessão) · formato (`**Aceite:**`, `**Verificação:**`, `Chamador:`) · instrumento (`run.ps1`, `verify.ps1`, `quality.ps1`, `kanban.ps1`, `close.ps1`, `plan.ps1`, `accept.ps1`, hooks) · ritual (o formulário da entrada fora da Planning traz a conta).

### O que mudou
- **Espera** (v3.57.0–v3.57.1): seis regras em `sprint-run.md` §Protocolo de espera; comando de terceiros com prazo (`Invoke-Bounded`); o watcher confere por `run.ps1 wait -For`.
- **Sessão** (v3.57.2): medida a cada Task fechada (`consumption.ps1 -Session`); acima de `run.sessionContextCap` sem agente em voo, o `next` manda reiniciar e a G20 aceita o veredito.
- **Dev e executor** (v3.57.2): suíte e cobertura só pelo `verify.ps1` (G14); evidência que falta vai ao cartão. **v3.57.3:** `verify.ps1 -Kill` encerra o que o verify da Task iniciou; a rodada nova encerra o órfão da anterior.
- **Arquiteto** (v3.57.1–v3.57.3): envelope de medidas (33) e linha `**Aceite:**` (34) reprovam; GAP decidido pelo recorte e plano mudado por delta; **regra 35** — `**Verificação:** dispensada — <motivo>` (o `close` não exige o full; o QA revisa no portão) ou ``comando — `<comando>` `` (o `verify` o roda como o passo `plano`).
- **QA** (v3.57.3): a Q11 reaproveita a cobertura do verify full da mesma árvore; "Unknown% / 0 de 0" é "não medido", não reprovação.
- **SM** (v3.57.3): a entrada fora da Planning leva ao formulário a linha de `kanban.ps1 -Capacity -Add <est>`; o R4 repete a conta. Todo pedido ao `operator` começa por `Chamador: <papel> <ID>` (G7), gravado no consumo.

### Por quê
O plugin foi escrito para o caminho em que tudo dá certo; o sprint real teve emulador lento, processo que não termina, notebook que dorme, plano que muda no meio e Tasks que não cabiam em nenhum caminho oficial. Cada mudança dá um caminho declarado ao que antes virava GAP de processo, parada ou custo escondido.

### Conflitos com o processo vigente
A regra 18 continua: com `**Verificação:** dispensada`, a mutação sai por `sem prova: <motivo>`. A G14 não libera comando novo com o `Set-Location`: só lê o caminho a partir da pasta. O estouro de capacidade continua decisão do stakeholder; a conta só fica visível.

### Como saberemos que funcionou
Sprint 6 do garden (`validacoes-sprint-6.md`): sessão principal abaixo de 1/3 do total; nenhuma suíte duplicada nem `taskkill` à mão; Arquiteto abaixo de 25 % de papéis + `operator`; nenhum GAP de processo por Task sem caminho no `verify`; `operator` com chamador em 100 %; entradas fora da Planning com a conta no formulário.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.54 que saiu do vivo × arquivo (`.Contains`) | True; o vivo fica com v3.57, v3.56, v3.55 | ✅ |
| Entrega | `release.ps1` (C3); `run-check-tests.ps1`; `run-guard-tests.ps1` | ver CHANGELOG v3.57.0 a v3.57.3 | ✅ |

---

## v3.56 — A lição de cada GAP no lugar certo: origem e destino na decisão, conhecimento do projeto que atravessa sprints, armadilhas da stack e o SM atualizando o lado do projeto no fechamento (SM + Arquiteto + Dev + QA) — 06/11/2026

**Instrução** (stakeholder, 06/11/2026, `melhorias/plano-v3.56.0.md` aprovado com as recomendações do §9: SM mecânico no fechamento, teto de 15 KB, P-r2 do benchmark com a 3.56.0, os três defeitos abertos do plugin nesta versão). Implementar antes de retomar o garden no sprint 6.
**Medido (garden, sprints 1 a 5, 117 GAPs classificados):** 40 lições ficam no plugin (31 defeitos, 9 com conferência mecânica que já existia), 40 vão ao projeto (25 conhecimento do app, 10 ambiente, 5 requisito), 7 à stack, 30 só aparecem executando. O template do GAP só distinguia `plano` de `standard`; o `decisions/S<n>.md` morria com o sprint e misturava níveis (no S5, a D-1 era lição de stack, a D-2 e a D-3 remendavam o plugin). O limiar de 160 px reprovou na T-052 do S4 e de novo na T-063 do S5. Dos 31 defeitos do plugin, 21 já estavam tratados e 10 abertos em 3 defeitos (o `-Only` do accept, os cenários do backlog contra os do plano, a G9 com saída de build).
**Classificação:** formato (`**Origem:**` e `**Lição:**` na decisão; `**Decisões:** D-<k>, K-<n>`; `knowledge.md`; `pitfalls.md`) · regra (R6 a decisão tem destino; R16 a camada local de stack; R25 o formulário segue único; regra 29 ampliada) · instrumento (`knowledge.ps1` novo; `plan.ps1`, `run.ps1`, `accept.ps1`, `close.ps1`, G9, G13) · ritual (`/sm sprint close` e `prepare`; `/team update` 7m; `/team init` 4a).

### O que mudou
- **Arquiteto** (`technical-decision.md` §Origem e Lição, `implementation-plan.md` regra 29, `plan-rules-why.md`, `knowledge.md` novo, `agents/architect.md`): toda decisão de 🔺 GAP declara **Origem** (previsão · conhecimento · requisito · ambiente · processo) e **Lição** (projeto · stack:<nome> · plugin · nenhuma); grava D quando vale para mais de uma Task **ou** a lição é de projeto ou de stack. Cita K em `**Decisões:**`. Consolida o `knowledge.md` quando o teto estoura (primeiro item do `prepare`).
- **Dev** (`gap.md`, `agents/developer.md`): sugere a Origem; o cartão traz **Conhecimento do projeto** e **Armadilhas da stack** que casam por glob com os arquivos da Task — não abre os arquivos. O plano manda nos cenários; ordem do cartão que o contradiga é GAP de processo.
- **SM** (`workflow-sprint.md` §Retrospective e §Preparação, `retrospective.md` §Lições do sprint, `plugin-report.md` §GAPs de processo, `working-rules.md` R6/R16/R25, `artifact-ownership.md` §1, `sm.md`, `team-update.md` 7m, `team-init.md`): no `close`, `knowledge.ps1 -Sprint <n> -Apply` antes de fechar a pasta — tabela origem × destino, D → K e D → L por cópia, lição de plugin como ocorrência (iii) no formulário único, repetição com registro, propostas de configuração; escritor do `knowledge.md` e da camada local **só** por essa promoção.
- **QA** (README): o `accept -Only` valida só os cenários pedidos; o `-ParseOnly` sem `-Only` segue sendo a conferência do arquivo.

### Por quê
O que o sprint ensinava sobre o sistema não voltava a nenhum lugar que o seguinte lesse, e lição de plugin virava remendo de projeto. Com o destino declarado na decisão e a promoção mecânica no fechamento, o conhecimento atravessa sprints sem ninguém reler arquivos inteiros: o cartão traz só as entradas que casam com a Task.

### Conflitos com o processo vigente
A regra 29 é ampliada, não substituída: o rótulo `**Decisões do sprint:**` continua aceito. Decisão anterior à 3.56.0 só avisa (sprint antes do `**Classificação desde:**`). A ocorrência de plugin ganha o critério (iii) sem limiar, no mesmo formulário de (i) e (ii). A G9 passa a liberar saída ignorada pelo git; a G5 continua antes.

### Como saberemos que funcionou
Sprint 6 do garden (`validacoes-sprint-6.md` item 20): tabela origem × destino contra a linha de base do S5 (previsão 11, processo 15, conhecimento 2, ambiente 10, requisito 1); **repetição com registro = 0**; conhecimento ≤ 2 e caindo; linhas de K e de stack por cartão (média e máximo); tamanho do `knowledge.md`; propostas de configuração aprovadas.

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento de entrada | bloco v3.53 que saiu do vivo × arquivo (`.Contains`) | True; o vivo fica com v3.56, v3.55, v3.54 | ✅ |
| Entrega | `release.ps1` (C3); `run-check-tests.ps1`; `run-guard-tests.ps1` | ver CHANGELOG v3.56.0 | ✅ |

### Parte mecânica (implementada pela sessão principal, citada aqui)
`lib.ps1` (`Get-LessonClass`, `Get-KnowledgeSince`, `Get-PlanGapDecisions`, `Get-ProjectKnowledge`, `Get-TaskKnowledgeLines`, `Get-KnowledgeDigest`, `Get-Stacks`, `Get-StackPitfallLines`, `Get-PlanScenarios`, `Get-ScenarioFiles`; os cenários da Task pelo plano em `Get-SprintTasks`); `knowledge.ps1` novo; `plan.ps1` (regra 29); `run.ps1` (cartão, recorte, prompts, `Get-AcceptArgs`); `accept.ps1` (`-Only`); `close.ps1` (R30 pelo plano); `hooks/pre-tool.ps1` (G9 × `git check-ignore`), `session-start.ps1` (G13 sem `stacks`), `common.ps1` (`Get-InferredStacks`); `ownership.json`; `standards/stacks/ionic-capacitor/` e `pitfalls.md` das stacks.
