# Plano de mudanças do plugin — P+ (Etapa 6)

> **Para:** stakeholder, para aprovar **antes** de qualquer mudança. Escrito em 2026-10-21, a partir do ensaio do plugin no Mente Ativa (P-r6, v3.50.1), do N-forte (Mente Ativa e SunScape) e do protótipo Coordenador–Operador (CO-r1, SunScape).
> **Medido** = transcripts lidos com `scripts/metrics/transcript-metrics.js` (preço de API da tabela do script) e contagens em disco. **Estimado** = está marcado como tal.
> **Aplicado na v3.51.0** (branch `feat/v3.51.0`, 21/10/2026), com a autorização do stakeholder. API e Windows desktop no executor de cenários ficam para o próximo incremento (decisão do §8).

## 1. O que os dados mostram (a surpresa)

A hipótese era "o plano do Arquiteto em Opus e a execução pelo dev em Haiku não compensam". Os números do P-r6 dizem outra coisa:

| Quem (P-r6, Mente Ativa) | Custo | % | Relógio dos agentes | Observação |
|---|---|---|---|---|
| **Arquiteto** (Sonnet 28 % + Opus 13 %) | US$ 24,6 | **41 %** | **632 min** em 15 instâncias | 9 planos com **média de 42 KB** cada (383 KB no total) |
| **Sessão principal** (orquestração, Sonnet) | US$ 20,6 | **35 %** | — | **274 mil tokens de contexto por chamada**, em 247 chamadas |
| QA (Sonnet) | US$ 4,5 | 8 % | 27 min | uma instância por Task |
| PO + UX + SM (Sonnet) | US$ 8,0 | 13 % | — | preparação e fechamento |
| **Dev** (Haiku) | **US$ 1,8** | **3 %** | 581 min | 42 % de todo o volume de tokens |
| **Total** | **US$ 59,4** | | | N-forte no mesmo projeto: **US$ 6,5** |

- **O dev em Haiku é praticamente de graça.** Construir não é o problema.
- **O dinheiro e o tempo estão no Arquiteto e na sessão principal (76 %).** O Arquiteto também é o maior tempo de relógio.
- **O plugin escreve mais documento do que código.** Os planos (383 KB) e os relatórios de entrega (156 KB) somam mais que todo o código Kotlin (310 KB). O N-forte escreveu 92 KB de código e 12 KB de documento (plano curto + README).
- **O plugin escreveu 6× mais código de teste** que o N-forte (221 KB contra 36 KB; 44 arquivos contra 8), por regras como mutação e render real.
- **Perda de cache:** P-r6 US$ 9,1 (15 % da entrada); CO US$ 8,0 (30 %); **N-forte zero**. O N-forte nunca para mais que o prazo do cache; o plugin para entre papéis.

O CO confirmou o resto: com a orquestração quase toda em script, o Coordenador custou só 6 %; o custo foi do construtor com contexto grande (231 mil tokens por chamada) e das chamadas que só diagnosticaram ambiente quebrado.

**Conclusão:** manter o Haiku construindo é certo. O que precisa mudar é **como o plano é escrito, como a sessão orquestra, onde a verificação acontece e como o contexto passa de um papel a outro**.

## 2. O que não muda

- Preparação (ideia, PO, UX, SDD, Planning) e fechamento (Review, retrospectiva) continuam: são o diferencial do plugin. Ficam **mais baratos**, não menores em conteúdo.
- Plano detalhado por Task continua, porque é o que deixa um modelo barato construir (e é a base do uso gratuito, Etapa 8). Muda o formato, não a utilidade.
- Guardas, marcadores, `close.ps1` e o quadro continuam.

## 3. As mudanças

Cada item: **sintoma (evidência) → mudança → o que melhora → onde mexe**.

### A. Fluxo da Sprint (construção)

**A1. Plano e cenários prontos antes do dev, dentro da Sprint** *(decisão do stakeholder, 2026-10-21: o plano é parte da construção)*.
- *Sintoma:* o Arquiteto planeja Task a Task, intercalado com o dev: 632 min de relógio e 41 % do custo. Cada instância relê SDD, código e o template de 26 KB.
- *Mudança:* a Sprint abre com a **etapa de preparo da construção**: para cada História, **uma instância do Arquiteto** escreve os planos de todas as Tasks dela (lê o SDD e o código uma vez), **ao lado dos cenários de teste** da Task (do QA, em formato executável pelo F1), e o `plan.ps1` confere plano e cenários juntos. Só então o dev começa. O plano continua contando como **construção**.
- *Melhora:* corta as releituras (uma instância por História em vez de uma por Task) e garante que o dev nunca começa sem plano e cenários. *Estimado:* −40 a −60 % do custo do Arquiteto.
- *Onde:* `sprint-run.md` passos 1 a 3, `commands/sm.md`, `plan.ps1` (conferir os cenários citados).

**A2. Plano enxuto (formato para o construtor, não para o leitor).**
- *Sintoma:* planos de 27 a 59 KB; o template tem 26 KB e 21 regras; o plano é lido inteiro pelo dev a cada bloco (nota 2: "plano 27 KB lido 117×").
- *Mudança:* teto de **~12 KB por Task**. O plano traz só o que o construtor executa: arquivos, passos por bloco, nomes de teste, comandos e o "pronto" de cada bloco. Contexto do SDD é **citado** (seção e linha), não copiado. O template ganha um **esqueleto curto** (o que o Arquiteto preenche) separado das regras (o que o `plan.ps1` confere). O dev lê o **cabeçalho e o bloco dele**, não o plano inteiro.
- *Melhora:* menos escrita do Arquiteto, menos leitura do dev, menos contexto em todos. Resolve a nota 2.
- *Onde:* `roles/architect/templates/implementation-plan.md`, `scripts/checks/plan.ps1` (teto de tamanho), prompt do dev.

**A3. Dev constrói, verifica e corrige sozinho (como o N-forte).**
- *Sintoma:* hoje o dev já roda `verify` focado, completo e mutação, e o QA ainda roda build, testes e smoke de novo a cada Task (duplicação, como o executor do CO, que nunca achou defeito real: 13 portões passaram de primeira e 5 chamadas de "aceite" terminaram em "não mudei código").
- *Mudança:* o dev fecha a Task com a evidência dele: `verify full` verde, prova de mutação e **os cenários da Task rodados pelo executor de cenários** (item F3). O `close.ps1` confere a evidência por script (exit codes e árvore), **sem rodar de novo**. Falha → o próprio dev corrige na mesma instância. Dúvida de desenho → 🔺 GAP ao Arquiteto (só então).
- *Melhora:* some a verificação duplicada por Task; a Task fecha sem esperar outro papel.
- *Onde:* `sprint-run.md` passos 3 a 7, `close.ps1` (aceitar evidência do dev em vez do veredito do QA por Task), `roles/developer/README.md`.

**A4. QA como portão de validação do produto, uma vez no fim da Sprint, antes da Review** *(decisão do stakeholder, 2026-10-21)*.
- *Sintoma:* 13 instâncias de QA (uma por Task), cada uma relendo plano, código e padrões.
- *Mudança:* **uma passada de QA** sobre o incremento inteiro, em duas frentes:
  - **Qualidade de código:** princípios SOLID, clean code, aderência à arquitetura do SDD e aos planos, padrões de escrita, segurança e **cobertura de testes**. A parte mensurável sai de ferramenta, rodada por script numa instância barata (cobertura com Kover ou JaCoCo, análise estática com detekt e o lint do Android, complexidade), num relatório que o QA lê. O julgamento (SOLID, clean code, aderência) é do QA, com `arquivo:linha`.
  - **Funcional, com prova no alvo real:** todos os cenários do sprint pelo executor de cenários (F1), com o **app rodando de verdade**: no emulador ou aparelho (Android), no navegador com o site no ar (web), no serviço no ar (API) ou com a janela aberta (Windows desktop). A prova é a **captura do estado final de cada cenário** (e da falha, quando falha) ou, na API, a requisição e a resposta gravadas, anexadas ao veredito. Teste unitário e de integração não substituem essa prova. Sem o alvo disponível, o cenário é **"não exercitado"** e o portão **não passa**: vira bloqueio de ambiente (D4), nunca aprovação.
  - Achados viram uma lista; cada grupo vai ao dev (Haiku) para corrigir; só dúvida sobe ao Arquiteto. Depois, uma reexecução focada nos achados. O veredito do QA é a **premissa da Review** e o PO aceita sobre ele.
- *Por tecnologia (a régua é a mesma; muda só a ferramenta):* os limiares e as regras vêm do **nível 1** de `standards/` (`implementation-principles.md`: Clean Architecture com teste de arquitetura, limites numéricos de Clean Code, cobertura de 80 % por unidade implantável). A ferramenta de cada stack vem do perfil de nível 2 ou da Ficha de Vinculação do projeto, e o comando fica no `guards.json`:

| Frente | .NET (perfil existe) | React e Angular (perfil novo, G4) | Android/Kotlin (perfil novo, G4) |
|---|---|---|---|
| Análise estática e estilo | Roslyn analyzers + StyleCop, avisos como erro | ESLint (regras do framework) + Prettier | detekt + ktlint + lint do Android |
| Cobertura com limiar | Coverlet + ReportGenerator (`Threshold=80`) | Jest ou Vitest (React), Karma ou Jest (Angular), com `coverageThreshold` | Kover ou JaCoCo com regra de limite |
| Arquitetura (regra de dependência) | teste de arquitetura sobre os assemblies | regra de fronteira de import (eslint-plugin-boundaries ou dependency-cruiser) | teste de arquitetura sobre os pacotes (Konsist ou ArchUnit) |
| Complexidade | métricas do compilador (`/t:Metrics`) | regra de complexidade do ESLint | regras de complexidade do detekt |
| Prova funcional (F1) | API: requisições; desktop: UI Automation | navegador headless com o site no ar | emulador ou aparelho |

  O `quality.ps1` roda essas ferramentas e devolve **uma tabela por regra do nível 1** (passou, falhou, com o número). O QA julga o que ferramenta não mede (SOLID, nomes, responsabilidade, aderência ao plano) com `arquivo:linha`, citando a seção do `standards/` que embasa cada achado.
- *Onde (além dos abaixo):* `scripts/checks/quality.ps1` (novo: roda as métricas pelo comando do `guards.json`, chave nova `quality`) e o modelo de veredito do QA (métricas com limiar).
- *Melhora:* uma leitura do contexto em vez de 9 a 13; a visão do QA fica de fato independente (olha o todo, não Task a Task).
- *Risco:* defeito de entendimento aparece mais tarde. *Mitigação:* o portão mecânico por Task (A3) segura o que é verificável; o QA pega o que exige julgamento.
- *Onde:* `sprint-run.md` (passo novo "Validação do sprint"), `commands/qa.md`, `roles/quality-assurance/README.md`, `workflow-sprint.md` §Review.

**A5. Documentos vivos (R12) consolidados uma vez.**
- *Sintoma:* instâncias extras do Arquiteto só para atualizar o SDD após cada Task ("Arquiteto: R12 da T-002/T-003").
- *Mudança:* o plano lista o que muda nos documentos; o dev anota no relatório; **uma** consolidação no fim do sprint (Arquiteto), junto da passada do QA.
- *Onde:* `sprint-run.md` passo 7, regra R12.

**A6. Testes proporcionais ao risco.**
- *Sintoma:* 221 KB de teste para 88 KB de produção; mutação e render em toda Task.
- *Mudança:* a regra do plano escolhe o nível de teste pelo risco da Task (domínio e regra de negócio: teste completo + mutação; tela simples: teste de UI do contrato + render só quando há layout novo). Sem cortar o contrato de teste do pedido.
- *Melhora:* menos código de teste para escrever, rodar e manter; o dev termina antes.
- *Risco:* é a mudança que mais mexe em qualidade. *Condição (confirmada pelo stakeholder em 2026-10-21):* o freio é o portão do QA (A4): a cobertura medida tem limiar, e Task abaixo dele volta ao dev. Mais a mesma avaliação cega.
- *Onde:* template do plano (regras de mutação e render), `standards/`.

### B. Sessão principal (orquestração)

**B1. Orquestração guiada por script.**
- *Sintoma:* 35 % do custo; cada chamada carrega 274 mil tokens; 24 % do crescimento do contexto é a leitura do próprio processo do plugin (`sprint-run.md` 34 KB, `project-context.md` 22 KB, README do time 19 KB).
- *Mudança:* um script `run.ps1 next` lê o quadro e devolve **a próxima ação pronta** (papel, modelo, prompt curto com os caminhos, o que marcar). A sessão executa e chama `run.ps1 done <resultado>`. O roteiro de 34 KB vira um **cartão do run de ~5 KB** com as paradas legítimas e o que fazer em cada caso; o resto fica como referência, lido só quando um caso pede.
- *Melhora:* menos raciocínio e menos leitura por passo, como o Coordenador do CO (6 % do custo). *Estimado:* −50 % da sessão principal.
- *Onde:* `scripts/checks/run.ps1` (novo, junta `dispatch`, `mark`, `consumption` e `close` numa chamada por transição), `sprint-run.md`, `commands/sm.md`.

**B2. Menos idas e voltas por Task.**
- *Sintoma:* 44 `SendMessage`, 46 `Agent`, 12 `consumption.ps1`, 8 marcadores, cada um a 274 mil tokens.
- *Mudança:* com A1 a A4, a Task vira dev → `close`; uma transição por script.
- *Onde:* o mesmo de B1.

### C. Contexto e cache (o ponto crítico)

O N-forte não tem esse problema porque é uma conversa só, sem pausa maior que o prazo do cache. O plugin tem várias instâncias e pausas entre elas. A estratégia:

**C1. Regra das 5 minutas para todo papel caro.**
- *Sintoma:* subagentes têm cache de **5 min**. Retomar Arquiteto, QA, PO ou UX depois disso regrava o contexto todo (P-r6: Arquiteto 7×, US$ 3,4; UX, PO e SM, US$ 1,5).
- *Mudança:* a regra que hoje vale só para o Arquiteto vale para **todo papel em Sonnet ou Opus**: parado há mais de 5 min → **instância nova** com o cartão de passagem (C2), nunca `SendMessage`. Só o dev (Haiku, regravação barata) continua sendo retomado.
- *Onde:* `sprint-run.md` §Retomada; a proposta G19 (já escrita no changelog v3.49) vira guarda.

**C2. Cartão de passagem por Task (≤ 2 KB, gerado por script).**
- *Sintoma:* toda instância nova relê o plano inteiro, o README do time (11 KB, lido 21×) e o SDD (03-architecture 15 KB, 11×).
- *Mudança:* o script gera `sprints/<n>/handoff/<T-ID>.md` com o estado atual: o que foi decidido, arquivos tocados, comandos e resultado do último `verify`, pendências. Instância nova lê o cartão + o bloco do plano; o resto só sob demanda.
- *Melhora:* passagem de contexto barata e sem perda: o que importa está escrito, e escrito curto.
- *Onde:* `scripts/checks/run.ps1`, prompts de todos os papéis.

**C3. Comando longo só em instância barata ou em script.**
- *Sintoma:* build Gradle e testes no emulador passam de 5 min; dentro de um papel caro, o cache vence durante a espera (nota 3; CO: as chamadas mais caras foram depois de esperas longas).
- *Mudança:* Arquiteto e QA **não** rodam comando longo. Execução fica com o dev (Haiku) ou com o `operator` (Haiku), que devolve só o resultado. O QA lê a evidência.
- *Onde:* READMEs do QA e do Arquiteto, `commands/qa.md` (o `scenarios run` já manda grupos ao `operator`).

**C4. Sessão principal sem pausa longa.**
- *Sintoma:* a sessão principal regravou o contexto após pausas > 1 h (P-r6, US$ 4,1).
- *Mudança:* manter o toque de cache (v3.49, em avaliação) e, com B1, um contexto menor faz a regravação custar menos. No benchmark, o driver encadeia os passos sem pausa.
- *Onde:* `sprint-run.md` §Toque; driver do benchmark.

**C5. Contexto que não cresce sem limite.**
- *Sintoma:* no CO, a sessão do Operador cresceu Task após Task (231 mil tokens por chamada; 2,6× a leitura de cache do N-forte).
- *Mudança:* uma instância de dev **por bloco** (já é a regra v3.45) e o cartão de passagem entre elas. Não reaproveitar uma instância por mais de uma Task.

### D. Ambiente e esperas (qualquer tecnologia)

O plugin já é neutro de tecnologia na parte de comandos: o `guards.json` → `verify` guarda os comandos do projeto (`focused`, `lint`, `build`, `suite`, `coverage`), seja Gradle, `dotnet`, `npm` ou outro. As mudanças abaixo seguem esse desenho: **um contrato comum nos scripts e um adaptador por tipo de alvo**. Nada fica preso ao emulador.

**D1. Comando que não devolve o controle: tempo limite e processos-filho (nota 4, generalizada).**
- *Sintoma:* o daemon do Gradle prende o canal de saída; um build de 2 min virou 45 min de espera, e outro 3 h, no benchmark. O mesmo padrão existe em outras ferramentas: servidores de build do `dotnet`/MSBuild que ficam vivos, testes de `npm` em modo de observação (`ng test`, `vitest`, `jest --watch`) que nunca terminam.
- *Mudança:* o `verify.ps1` ganha **tempo limite próprio** e encerra a **árvore de processos** ao fim ou ao estourar, devolvendo "falha de ambiente: tempo esgotado" em vez de esperar. E aplica a higiene conhecida de cada ferramenta quando ela aparece no comando: Gradle `--no-daemon` (e o compilador Kotlin em processo); `dotnet` com `--disable-build-servers` e `MSBUILDDISABLENODEREUSE=1`; `npm`/`npx` com `CI=true` e os executores de teste em modo de execução única (`--watch=false`, `vitest run`, `jest --ci`). A tabela de higiene fica num arquivo de dados, para acrescentar ferramenta sem mexer no script.
- *Onde:* `scripts/checks/verify.ps1`, `scripts/checks/lib.ps1`, `guards.json` (modelo), `how-to.md`. Teste com Gradle com daemon vivo, `dotnet test` e um `ng test` sem `--watch=false`.

**D2. Caminho com acento no perfil do Windows (nota 5, generalizada).**
- *Sintoma:* testes Gradle falham com `ClassNotFoundException` do worker e parecem defeito do código. É o caso medido; outras ferramentas que guardam cache no perfil do usuário podem ter o mesmo problema e **não foram testadas**.
- *Mudança:* a abertura da sessão (`session-start.ps1`) detecta perfil com caractere fora do ASCII e avisa uma vez, com o contorno por ferramenta: Gradle (`GRADLE_USER_HOME` numa junção ASCII, medido) e, como ponto de atenção a conferir, NuGet (`NUGET_PACKAGES`) e npm (`npm_config_cache`). O `verify.ps1` reconhece a assinatura conhecida (a do Gradle) como **falha de ambiente**.
- *Onde:* `hooks/session-start.ps1`, `scripts/checks/verify.ps1`, `how-to.md`.

**D3. Pré-voo do alvo de execução e dono único.**
- *Sintoma:* emulador com tela em branco (ligado há mais de 1 dia) e dois automatizadores no mesmo emulador causaram 38 % do custo do CO e 3 h de espera na avaliação. Em web, API e desktop o equivalente é o servidor que não subiu, a porta ocupada por outro processo, o navegador que não abre ou a janela do app que não aparece.
- *Mudança:* um script `target.ps1` com **uma checagem por tipo de alvo**, configurada no `guards.json` (chave nova `targets`):

| Alvo | Checagem antes de executar | Reparo que o script tenta uma vez |
|---|---|---|
| **Android** (emulador ou aparelho) | tela renderiza (captura com tamanho real), `uiautomator` responde, tempo ligado | reiniciar o emulador |
| **Web** (Angular, React…) | servidor no ar (URL de saúde responde), porta livre ou do próprio projeto, navegador headless instalado | subir o servidor pelo comando configurado (`npm run start`/`preview`) |
| **API** (.NET, Node, Java…) | serviço responde no endpoint de saúde; dependências (banco, contêiner) no ar | subir o serviço pelo comando configurado |
| **Windows desktop** (.NET WPF, WinForms, WinUI) | o executável sobe e a janela principal aparece na árvore de automação | fechar instâncias antigas e abrir de novo |

  Em todos: **trava de dono único** (`.team-project/.target-lock`): só um automatizador por alvo. Falha que o reparo não resolve → **falha de ambiente**, com a ação para o stakeholder, e **não** vai ao papel como defeito.
- *Onde:* `scripts/checks/target.ps1` (novo), chamado pelo executor de cenários (F1) e pelo `verify`.

**D4. Falha de ambiente nunca vira trabalho de papel caro.**
- *Sintoma:* no CO, 5 chamadas ao construtor só para dizer "o ambiente está quebrado".
- *Mudança:* os scripts classificam a saída (ambiente × código) e devolvem um código de saída próprio (ex.: 4 = ambiente). Com 4, o `run` tenta o reparo do D3 uma vez e, sem sucesso, marca bloqueio de ambiente, sem chamar o papel. Vale para todas as tecnologias.

### F. Ferramentas que o CO deixou (reaproveitar)

**F1. Executor de cenários de aceite, com adaptador por tecnologia.**
- *Sintoma:* no plugin, o QA executa os cenários à mão no aparelho, em Sonnet. No CO, os cenários `.scn` rodaram por script (zero token).
- *Mudança:* `scripts/checks/accept.ps1` com **uma linguagem de cenário comum** e **um adaptador por alvo**:

| Passo do cenário | Android | Web | API | Windows desktop |
|---|---|---|---|---|
| abrir | instalar e abrir o app | abrir a URL | — | abrir o executável |
| tocar / clicar | `uiautomator` + `adb input` | Playwright | — | UI Automation (FlaUI) |
| digitar | `adb input text` | Playwright | — | UI Automation |
| conferir texto / contar itens | árvore de acessibilidade (`testTag`) | DOM (`data-testid`) | — | árvore de automação (`AutomationId`) |
| requisição | — | — | HTTP com conferência de status e campo JSON | — |
| capturar | captura de tela | captura de página | requisição e resposta gravadas | captura de janela |

  Uma instalação ou abertura para todos os cenários; relatório em Markdown por cenário; as lições do avaliador (rolagem lenta, esperar a animação acabar, repetir uma vez do zero e registrar as duas tentativas). Os identificadores de teste já são exigidos pelo contrato de teste (`testTag`, `data-testid`, `AutomationId`).
- *Ordem de entrega:* Android e Web primeiro (Android é o que o benchmark mede; Web reaproveita o navegador headless que a regra 21 já pede); API em seguida (é o mais simples); Windows desktop por último, com um projeto de teste próprio, porque nenhum dos nossos projetos o exercita hoje.
- *Melhora:* o dev (Haiku) roda os cenários da Task sozinho; o QA lê o resultado e as capturas; navegação vira script.
- *Onde:* `scripts/checks/accept.ps1` e um adaptador por alvo em `scripts/checks/targets/`, template de cenário do QA (gera também o arquivo executável), testes com um projeto mínimo de cada tecnologia em `scripts/checks/tests/`.

**F2. Registros gerados por script.**
- O quadro, as transições e o burndown já são do `mark.ps1` e do `close.ps1`. Ampliar para o HTML do Kanban (G2).
### G. Organização e documentação

**G1. Kanban no lugar do burndown (pedido do stakeholder, `note.md` "Outros").**
- *Mudança:* `burndown.md` vira `kanban.md`: primeiro o Kanban das Tasks (colunas pelo marcador), depois o Burndown (Série e Registro de transições). As **questões de controle** que hoje ficam no `sprint-backlog.md` (bloqueios e riscos, decisões pendentes, entradas fora da Planning) passam a uma seção abaixo do Burndown no `kanban.md`. O `sprint-backlog.md` fica só com Histórias e Tasks.
- *Onde:* templates do SM, `mark.ps1`, `close.ps1` (R24), `artifact-ownership.md`, testes das conferências.

**G2. Kanban em HTML que se atualiza sozinho (pedido do stakeholder).**
- *Mudança:* `kanban.html` gerado por script a cada transição (`mark.ps1` e `close.ps1`), no mesmo estilo do `progress.html` do benchmark: colunas do Kanban, burndown em gráfico, bloqueios, consumo por papel. **Zero token**: é script, não agente.
- *Onde:* `scripts/checks/kanban-html.ps1` (novo).

**G3. Documento do time mais curto.**
- *Sintoma:* `.team-project/README.md` (11 KB) lido 21×; `how-to.md` do projeto 39 KB.
- *Mudança:* separar o que todo papel lê (1 a 2 KB: onde está cada coisa, sprint corrente) do resto (consulta).

**G4. `standards/` mantido como referência das boas práticas, com um perfil de nível 2 por tecnologia.**
- *Sintoma:* o nível 1 (princípios, agnóstico) vale para qualquer linguagem, mas o nível 2 (como se escreve e com qual ferramenta) só existe para **.NET**, e com nome genérico (`implementation-guide.md`, `implementation-quality.md`) que não diz a tecnologia. React, Angular e Android/Kotlin dependem da Ficha de Vinculação escrita do zero em cada projeto. No Mente Ativa (P-r6), a Ficha saiu completa (V1 a V22), mas o Arquiteto teve de decidir sozinho formatter, duplicação e métricas, e marcou os três como "não aplicável" por falta de ferramenta no ecossistema permitido. Além disso, os documentos são lidos inteiros: no P-r6, `implementation-principles.md` sozinho carregou 2,6 M tokens em 7 leituras.
- *Mudança:*
  - **Manter `standards/` como a fonte das boas práticas** (dono editorial: Arquiteto, R16). Nada sai, e o nível 1 continua valendo acima de qualquer perfil.
  - **Um diretório por tecnologia**, cada um com o mesmo par de arquivos (como o .NET já faz):

```
standards/
  README.md                          índice + identificadores das regras (1 a 2 KB)
  implementation-principles.md       nível 1 (nome mantido: 54 referências no plugin)
  implementation-security-lgpd-copyright.md   transversal (nome mantido)
  stacks/
    dotnet/       guide.md · quality.md · desktop.md   ← move dos atuais implementation-guide.md e implementation-quality.md; desktop.md novo (WPF, WinForms, WinUI)
    react/        guide.md · quality.md                ← novo
    angular/      guide.md · quality.md                ← novo
    kotlin-android/ guide.md · quality.md              ← novo
```

  - **O que cada perfil novo traz** (o mesmo roteiro do perfil .NET):
    - `guide.md`: os anéis do nível 1 na estrutura de pastas da tecnologia, nomenclatura, estado e efeitos, ponto de composição, acessibilidade, identificadores de teste (`data-testid`, `testTag`, `AutomationId`), desempenho (V18 a V21).
    - `quality.md`: ferramenta por frente (análise estática, formatter, cobertura com limiar, regra de dependência, complexidade, duplicação), o comando que vai no `guards.json` e os limiares.
    - **Coluna "ecossistema restrito":** o substituto aceito quando o projeto proíbe ferramenta de terceiros (o caso do benchmark, que só permite AndroidX), para o Arquiteto não precisar inventar.
    - **Ficha de Vinculação pré-preenchida** da tecnologia: o Arquiteto do projeto copia e ajusta, em vez de escrever as 22 linhas do zero (economia direta no item que mais custa, A1).
  - **.NET desktop (`desktop.md`):** MVVM, separação da UI dos anéis, `AutomationId` em todo controle interativo, empacotamento e o adaptador de automação do F1.
  - **Leitura por seção:** cada regra verificável ganha um identificador estável (ex.: `P-CC-03` para um limite de Clean Code do nível 1, `RE-COV-01` para a cobertura no React). O plano e o veredito citam o identificador; o dev e o QA leem **só a seção citada**, pelo índice.
  - **Referências:** mover os dois arquivos do .NET troca 43 referências no plugin (30 do guia, 13 do de qualidade), mais `hooks/ownership.json` e os testes; tudo no mesmo PR.
- *Melhora:* o QA cobra a mesma régua em React, Angular, .NET (API e desktop) e Android; o Arquiteto parte de uma Ficha pronta; o custo de leitura cai sem perder conteúdo.
- *Onde:* `standards/` (estrutura nova, quatro perfis novos, índice), `standards/README.md`, `implementation-principles.md` §6 (aponta para as Fichas pré-preenchidas), templates do plano e do veredito, `hooks/ownership.json`.
### H. Comunicação com o stakeholder

**H1. Toda decisão ao stakeholder: problema simples, exemplo prático e formulário.**
- *Sintoma:* hoje o formulário (R22) já existe e já tem a última opção "Pedir mais contexto", mas o texto que o acompanha é escrito na linguagem do processo (códigos de regra, marcadores, nomes de arquivo). Nesta própria análise, decisões precisaram de várias voltas até ficarem claras ("quem é o executor?", "o que faz a chamada de aceite?").
- *Mudança:* todo ponto que vai ao stakeholder (bloqueio da R22, ajustes do `fix plan`, autorização da Review, escopo da triagem, ocorrência de plugin, propostas de melhoria) segue o mesmo formato:
  1. **O problema em uma ou duas frases**, sem sigla nem nome de regra.
  2. **Um exemplo prático e concreto**, tirado do próprio produto ("hoje, se o usuário escolhe Santos com raio de 50 km, a lista aparece vazia e sem mensagem").
  3. **O que muda em cada opção**, na descrição da opção.
  4. **A recomendação**, marcada como primeira opção.
  5. **Formulário** com as opções e, sempre por último, **"Pedir mais contexto"**, que detalha e repete a pergunta.
- *Instrumento:* modelo de pergunta no SM; a guarda que já intercepta o `AskUserQuestion` (G18) passa a conferir que a última opção é a de mais contexto e que há um exemplo no texto; o SM confere a clareza na retrospectiva.
- *Onde:* `roles/scrum-master/templates/` (modelo novo de pergunta), R22, `hooks/pre-tool.ps1`, `bench-answer.ps1` (o modo benchmark responde igual).

## 3a. As mesmas melhorias no fluxo do `fix`

A trilha `fix` já é mais enxuta que a Sprint (no P-r6 custou US$ 3,84): mini-plano de até 60 linhas por Correção, uma instância de dev por Correção, um QA por bloco e só defeito reproduzido vira Correção. O que muda nela:

| Melhoria | No `fix` hoje | No `fix` com o P+ |
|---|---|---|
| **Reprodução do defeito** (A4, F1) | o QA reproduz à mão, em Sonnet | o QA escreve o defeito como **cenário executável** e o executor o roda: o mesmo cenário falha antes e passa depois (vira o regressivo) |
| **Prova funcional** (A4) | saída de comando | captura no alvo real **antes** (defeito) e **depois** (corrigido), anexada ao veredito da Correção |
| **Portão do QA** (A4) | um QA por bloco com as seis frentes | igual (o bloco já é a unidade), com as métricas por script (cobertura e análise estática **só dos arquivos tocados**) e a prova no alvo |
| **Correção pelo dev** (A3) | o QA reprova e devolve | igual; o dev corrige na mesma instância quando a falha é dele e a dúvida sobe ao Arquiteto |
| **Comando longo** (C3, nota 3) | o QA roda a suíte do módulo dentro da instância dele | a suíte e os cenários rodam por script ou no `operator`; o QA lê o resultado |
| **Retomada e cache** (C1, C2) | Arquiteto do `fix plan` retomado em instância nova | todo papel caro parado há mais de 5 min abre instância nova com o cartão da Correção |
| **Ambiente** (D1 a D4) | falha de ambiente parece defeito | classificada como ambiente, com reparo uma vez, sem gastar papel caro |
| **Defeito não reproduzido** | volta ao PO como suspeita | igual (o CO confirmou o valor: caçar defeito sem reprodução custou a T-005 inteira) |
| **Formulário dos ajustes** (H1) | uma pergunta por ajuste | no formato do H1: problema, exemplo, opções, mais contexto |

*Onde:* `roles/scrum-master/process/fix-run.md` (§Triagem passo 2, §Run passos 2 e 3, frentes do QA), `roles/architect/templates/fix-plan.md`, `scripts/checks/fix.ps1` (conferir a prova antes e depois).
## 4. Itens do `note.md`

| Item | Situação no P-r6 / CO | Entra? | Por qual mudança |
|---|---|---|---|
| 1. Invocação única concentrando o sprint; Haiku sem fôlego | Ainda vale: instâncias de dev com 255 a 296 chamadas (T-004, T-006, T-008, T-010) | **Sim** | A2 (plano enxuto e por bloco), C5; revalidar o `plan.ps1` com > 8 arquivos |
| 2. O contexto cresce com os documentos de passagem | Confirmado: leitura de plano é 17 % do crescimento; README 21× | **Sim** | A2, C2, G3 |
| 3. Trilha `fix`: um QA para o bloco inteiro e comando longo vencendo o cache | Confirmado no CO (esperas longas em instância cara) | **Sim** | §3a (QA lê o resultado; suíte e cenários por script), C3 |
| 4. Gradle daemon prende o chamador | Medido no benchmark | **Sim** | D1 (generalizado: tempo limite, árvore de processos e higiene por ferramenta) |
| 5. Perfil com acento quebra os testes | Medido no benchmark | **Sim** | D2 (detecção geral; contorno medido no Gradle) |
| Outros: Kanban no lugar do burndown | Pedido | **Sim** | G1 |
| Outros: controle das Tasks fora do sprint-backlog | Pedido | **Sim** | G1 |
| Outros: Kanban em HTML automático | Pedido | **Sim** | G2 |

As propostas pendentes de `proposals-pending.md`: **(a) hook Stop G20** e **(b) retomada na abertura**: entram (impedem paradas e esperas). **(c) orientação de energia** no `how-to.md`: entra. **(d) conferência de render no `plan.ps1`**: entra **ajustada pelo A6** (render só quando há layout novo).

## 5. Medição justa (os três braços)

**M1. Custo por atividade, lido do transcript, igual para todos.**
- Comando novo `transcript-metrics.js activity`: cada chamada à API é atribuída à atividade das ferramentas que ela usou: **planejamento** (texto antes de escrever código), **documentação** (escrever `.md` e `docs/`), **código** (`src/main`), **teste** (`src/test` e `androidTest`), **verificação** (build, teste e lint), **aparelho** (emulador e cenários), **leitura e busca**, **orquestração** (Agent, SendMessage, scripts do quadro). Chamada com várias ferramentas divide o custo.
- **O N-forte não muda de comportamento** (não ganha passos nem instruções novas); a medição é feita depois, no transcript. Mudar o prompt dele para separar fases mudaria o que medimos.
- Vale para os registros que já existem: N-forte Mente Ativa e SunScape, CO-r1 e P-r6 viram a linha de base antes de rodar o P+.

**Linha de base já medida (2026-10-21, com o comando `activity` preparado e guardado em `git stash`, não aplicado):**

| Atividade (% do custo) | N-forte Mente Ativa (US$ 6,5) | N-forte SunScape (US$ 9,0) | CO SunScape (US$ 26,8) | P-r6 Mente Ativa (US$ 59,4) | **P+ projetado, Mente Ativa (~US$ 28)** |
|---|---|---|---|---|---|
| Código | 29 % | 28 % | 11 % | **1 %** (0,8) | 3 % (0,8 a 1,0) |
| Teste | 18 % | 21 % | 3 % | **1 %** (0,6) | 2 % (0,4 a 0,6) — A6 |
| Verificação (build, teste, lint) | 11 % | 17 % | 5 % | 6 % (3,6) | 7 % (1,5 a 2,5) — A3, sem repetição pelo QA |
| Aparelho e cenários | 15 % | 14 % | **46 %** | 2 % (1,4) | 4 % (0,8 a 1,5) — F1 por script, D3/D4 |
| Leitura e exploração | 16 % | 12 % | 26 % | **33 %** (19,8) | 30 % (7 a 10) — A1, A2, C2 |
| Leitura do processo do plugin | — | — | — | 3 % (1,6) | 3 % (0,6 a 1,0) — B1, G3 |
| Orquestração e registros | 1 % | 0 % | 1 % | **26 %** (15,5) | 18 % (4 a 6) — B1, B2 |
| Plano e registros do processo | — | — | 0 % | 12 % (6,9) | 15 % (3,5 a 5) — A2, G2 |
| Documentação | 5 % | 5 % | 2 % | 3 % (2,1) | 6 % (1,5 a 2) — A5 |
| Raciocínio e relato (sem ferramenta) | 4 % | 2 % | 5 % | 12 % (7,1) | 12 % (3 a 4) — B1, C1 |
| **Total** | 6,5 | 9,0 | 26,8 | **59,4** | **~23 a 34** (meio: ~28) |

*Coluna P+: **estimativa** por atividade, no mesmo projeto do P-r6 (Mente Ativa), aplicando as mudanças citadas em cada linha; entre parênteses, US$. Não é medição: o P+ no SunScape mede. O total bate com o §6 (US$ 25 a 37).*
Leitura:
- **O N-forte gasta ~65 % construindo e verificando** (código, teste, verificação e aparelho). **O P-r6 gasta ~10 % nisso**; o resto é ler (33 %, o Arquiteto sozinho US$ 12,3 lendo código e SDD antes de planejar), orquestrar (26 %, quase tudo da sessão principal: US$ 13,2) e raciocinar entre passos (12 %).
- **No CO, 46 % foi aparelho e cenários**: as chamadas de aceite que só diagnosticaram o emulador quebrado (D3, D4).
- Isso confirma os alvos do plano: **leitura do Arquiteto** (A1, A2, C2), **orquestração da sessão** (B1, B2) e **ambiente** (D). O dev, que constrói, já é barato.
- **Na projeção, o P+ cai de US$ 59 para ~US$ 28 (−50 %)**, mas ainda fica ~4× o N-forte inteiro (US$ 6,5): o processo (ler, planejar, orquestrar, registrar) continua sendo a maior parte, e é o sobrecusto reconhecido.
- **Construção e verificação** (código, teste, verificação e aparelho) projetadas em **~US$ 3,5 a 5,5 no P+, contra US$ 4,8 do N-forte**: dentro do alvo de ≤ 1,5×. Em porcentagem parece pouco (~16 %) porque o dev em Haiku custa uma fração do Opus do N-forte; o que pesa é o valor absoluto.
- **O que mais pode errar na projeção:** a leitura do Arquiteto (se o plano por História não reduzir as releituras como esperado) e a orquestração (depende do B1 cortar o contexto da sessão pela metade).
**M2. Fases do plugin separadas no relatório:** preparação (ideia a Planning), **Sprint** em três partes (**preparo da construção**: planos e cenários; **construção do dev**: código, teste, verificação; **portão do QA**), fechamento (Review e retrospectiva), `fix`.

**Regra de comparação (o plano conta como construção, decisão de 2026-10-21):**
- **Sprint inteira:** P+ (planos, cenários, dev, portão do QA, orquestração) contra planejamento, código, teste e verificação do N-forte. É o número principal.
- **Cada parte contra a atividade equivalente do N-forte** (pela medição M1): planos e cenários × planejamento do N-forte; construção do dev × código + teste + verificação; portão do QA × a verificação que o N-forte fez de si mesmo. Assim se vê onde a diferença está.
- **Alvo:** **≤ 1,5× em custo e ≤ 2× em relógio** na construção do dev. Para a Sprint inteira, o alvo sai da linha de base da M1 (antes de rodar): com o plano detalhado dentro da Sprint, 1,5× no total é improvável, e prefiro fixar um número realista com dado do que prometer agora.
- **Processo antes e depois da Sprint:** sobrecusto reconhecido, com orçamento próprio.
- **Qualidade:** mesmo oráculo (15/15, lote 4/4), métricas do portão do QA e a mesma avaliação cega com 3 IAs; a documentação do P+ não pode ficar abaixo da do P-r6.

## 6. Quanto se espera ganhar (estimado)

| Parcela (base: P-r6, US$ 59,4) | Hoje | P+ (estimado) | Por quê |
|---|---|---|---|
| Arquiteto | 24,6 | 8 a 12 | A1, A2, A5 |
| Sessão principal | 20,6 | 7 a 10 | B1, B2, contexto menor |
| QA | 4,5 | 2 a 3 | A4 |
| PO, UX, SM | 8,0 | 6 a 8 | G3, C1 |
| Dev | 1,8 | 2 a 4 | faz mais verificação (A3) |
| Perda de cache | (9,1 dentro dos números acima) | 1 a 3 | C1 a C5 |
| **Total** | **59,4** | **~25 a 37** | |

Relógio: o tempo do Arquiteto (632 min) sai do caminho crítico da construção (A1). **Isto é estimativa**; só o P+ no SunScape mede.

## 7. Ordem de execução

1. **Medição primeiro (M1).** Rodar `activity` nos registros que existem: dá a linha de base por atividade do N-forte, do CO e do P-r6, e confirma este diagnóstico com o mesmo instrumento.
2. **Ambiente (D1 a D4) e executor de cenários (F1)**, nas tecnologias pela ordem do F1. São correções sem risco para a qualidade e destravam tudo o resto.
3. **Contexto e cache (C1 a C5) e orquestração (B1, B2).**
4. **Fluxo da Sprint (A1 a A6), fluxo do `fix` (§3a)**, organização (G1 a G3) e comunicação (H1), com as propostas pendentes (a) a (d).
5. Suítes (`run-guard-tests.ps1`, `run-check-tests.ps1`), `claude plugin validate`, changelog do processo, PR para `develop` e `main`, na linha **3.x** (decisão do stakeholder): **v3.51.0**, podendo dividir em incrementos (3.51 ambiente e medição, 3.52 contexto e orquestração, 3.53 fluxo e organização) se você preferir revisar por partes.
6. Etapa 6a: **P+ no SunScape** (depende da sua autorização de custo). Depois, Etapa 6b no price-agent.

## 8. Decisões do stakeholder (2026-10-21)

1. **O plano é construção:** fica na Sprint, escrito ao lado dos cenários de teste, antes de o dev começar (A1 reescrito).
2. **QA é o portão de validação do produto entregue pelo dev:** qualidade de código (SOLID, cobertura, aderência à arquitetura, clean code, padrões de escrita) e funcional (cenários) (A4 reescrito).
3. **Testes proporcionais ao risco (A6):** entra, freado pelo portão do QA com cobertura medida e limiar (confirmado no formulário de 2026-10-21).
4. **Versão:** incremento da linha 3 (v3.51.0), não v4.
5. **Início:** autorizado em 2026-10-21, suspenso para revisão e liberado pelo stakeholder no mesmo dia ("pode aplicar o plano"); aplicado na v3.51.0.
6. **Tecnologias:** Android e Web na v3.51; API e Windows desktop logo depois (formulário de 2026-10-21).
