# Propriedade de Artefatos — Quem escreve o quê

> **Dono:** SM · Cada arquivo tem **um único dono**. Quem não é dono lê, cita e pede alteração — nunca edita. É o que impede dois papéis de escreverem a mesma verdade em direções diferentes.

## 1. Matriz

Os caminhos concretos dos documentos do projeto estão em `.team-project/README.md` §4.

| Artefato | Dono | Regra |
|---|---|---|
| Código-fonte | dev | Só os arquivos listados no Plano de Implementação vigente |
| **Histórias** (`.team-project/product-owner/stories/`) | **PO** | Unidade de valor. **Um arquivo por História**, nome `<H-ID>-<slug>.md` (§4) — deixou de ser opcional (v3.21, §1d). Conteúdo **só funcional** — regras, protótipos, critérios de aceite, registro do portão ③; decisão técnica ali é achado de processo (R20). Modelo em [`../../product-owner/templates/user-story.md`](../../product-owner/templates/user-story.md) |
| **Tasks** (linhas do Sprint Backlog) | **SM** (a linha) · **Arquiteto** (o plano dentro dela) | Unidade de trabalho. Toda Task pertence a exatamente uma História (R20); a Task carrega estimativa, dependências, evidência esperada, o Plano de Implementação e a **referência aos cenários de teste mapeados pela QA** (lista de IDs, novos e regressivos — R30); o conteúdo do cenário fica na área da QA, nunca copiado aqui |
| **Pasta do sprint** (`.team-project/sprints/<n>/`) | **SM** (o contêiner) · **dono declarado por subpasta** — ver §1e | O registro de execução é organizado **por sprint**, não por papel (R25): a pasta contém Histórias (PO), planos (Arquiteto), evidências (QA) e os documentos do SM. Nasce no `/sm sprint plan`, fecha no `/sm sprint close`. **Pasta com dono ambíguo é achado de auditoria** — a atribuição está em §1e |
| Planos de Implementação (`.team-project/sprints/<n>/plan/`) | Arquiteto | Um plano por Task, nome `<Task-ID>-<slug>.md`. É o conteúdo técnico da Task, não um artefato irmão dela. **Plano feito fora de sprint** — só **calibração** da instalação (`how-to.md` § "Calibrar a instalação"), via comandos de papel; **Task de entrega não existe antes da 1ª Planning** (R20 · R25: nenhuma Task fora do quadro; projeto com menos de três sprints só entra em sprint planejado, [`workflow-sprint.md` §5g](workflow-sprint.md) "Manutenção"), então veredito e relatório da calibração ficam na conversa, sem `evidence/` nem `close` — vive em **`.team-project/architect/calibration/<Task-ID>-<slug>.md`** — pasta nascida sob demanda, não semeada no `init`, que não cria "sprint 0"; quando existe sprint corrente, o plano vai sempre para `sprints/<n>/plan/`. A Task que depois entra no Sprint Backlog **mantém** o plano onde está: a coluna Plano é ponteiro. **Task retomada num sprint seguinte tem o plano reescrito no sprint novo, referenciando o anterior** — retomar depois de um sprint exige revisar o plano de qualquer forma (R3 · R5) |
| Arquitetura, modelo de dados, modelo de API (SDD) | Arquiteto | Grafia de entidades e endpoints é contrato — modelos em [`../../../deliverables/sdd/README.md`](../../../deliverables/sdd/README.md) |
| ADRs | Arquiteto | Decisão estrutural recorrente. Decisão que passou por consultoria externa nasce como **proposta de ADR** no caso (`consulting/<caso>/adr-proposal.md`, modelo [`../../architect/templates/adr-proposal.md`](../../architect/templates/adr-proposal.md)) e vira ADR Accepted depois do formulário do stakeholder — sem citar `consulting/` (R31 · R32) |
| **Casos de consultoria externa** (`.team-project/consulting/C-<nnn>-<slug>/`) | **SM** (o contêiner, `case.md`, carta e réplicas consolidadas) · **dono declarado por arquivo** | Um caso por pasta (R32 · [`../README.md` §`/sm consulting`](../README.md)): `case.md` e `01-service-letter.md`/`NN-reply.md` do **SM** (seções da carta e conteúdo da réplica pelos papéis do domínio); `NN-response.md` colado pelo **stakeholder**, sem edição; `adr-proposal.md` do **Arquiteto** (domínios técnicos); `business-proposal.md` do **PO** (`business:<área>`). **Fica fora de `sprints/<n>/` de propósito**, como os spikes: o caso atravessa sprints e é consultado depois (§1c). Não semeada no `init` — nasce sob demanda. A sanitização de cada rodada que sai é assinada pelo **QA** no `case.md` (+ PO no `business`) |
| **Checkpoints de spike** (`.team-project/architect/spikes/<ID>-<slug>.md`) | Arquiteto | Resultado parcial de verificação pesada, no formato de [`roles/architect/templates/spike-checkpoint.md`](../../architect/templates/spike-checkpoint.md), salvo a cada etapa concluída (R5 · v3.9). **Fica fora de `sprints/<n>/` de propósito:** um spike responde a uma dúvida técnica que atravessa sprints e costuma ser consultado depois que o sprint fechou — fatiá-lo por sprint esconderia a resposta de quem a procura (§1c) |
| `${CLAUDE_PLUGIN_ROOT}/standards/**` | **Arquiteto (dono editorial)** · dev e QA consumidores obrigatórios | Base de qualidade comum dos três (R16). Única caneta é do Arquiteto — muda só por `/review`. Agnóstico de produto — nunca ajustar para acomodar caso específico. Dev roteia defeito por 🔺 GAP, QA por achado de processo; os dois ao Arquiteto. Divergência de engenharia entre os três decide o Arquiteto; o que ultrapassa engenharia sobe ao stakeholder pelo SM |
| Mapas de jornada (`.team-project/user-experience/journeys/`) | UX | Um por objetivo do usuário |
| Especificações de tela (`.team-project/user-experience/screens/`) | UX | Os seis estados e os critérios de acessibilidade são obrigatórios |
| **Protótipo funcional** (`.team-project/user-experience/prototype/`) | **UX** | **Entregável** e **pré-condição do portão ①**: HTML navegável cobrindo os fluxos principais de `02-flows-and-roles`. O stakeholder **navega** antes de aprovar o SDD funcional — aprovação por leitura não vale (R15). Modelo em [`../../user-experience/templates/functional-prototype.md`](../../user-experience/templates/functional-prototype.md); critérios em [`../../../deliverables/prototype/README.md`](../../../deliverables/prototype/README.md) |
| **Protótipo do sprint** (`.team-project/user-experience/prototype/sprint-<n>/`) | **UX** | **Entregável** e **pré-condição do portão ③**: as telas das Histórias que entraram, **costuradas num fluxo que se atravessa ponta a ponta**. Montado depois do corte de capacidade ([`workflow-sprint.md` §5e](workflow-sprint.md) Planning, passo 10), é peça obrigatória do **pacote de abertura** e a verificação do **valor real** do sprint (R25). Uma pasta por sprint, preservada — o Sprint Backlog guarda só o **ponteiro**, nunca uma cópia. Costurar **não é reespecificar**: a especificação de tela já saiu antes da Planning. Modelo em [`../../user-experience/templates/sprint-prototype.md`](../../user-experience/templates/sprint-prototype.md) |
| Protótipos de tela e explorações | UX | Exploração da tela de uma História, no **detalhamento funcional** (antes da Planning, DoR da História — §3a). Não é código de produção, e **não substitui** nem o protótipo funcional do ① nem o protótipo do sprint |
| Objetivos, requisitos, fluxos, changelog funcional (SDD) | PO | Modelos e critérios em [`../../../deliverables/README.md`](../../../deliverables/README.md). Regra de negócio que passou por consultoria externa (`business:<área>`) nasce como **proposta de negócio** no caso (`consulting/<caso>/business-proposal.md`, modelo [`../../product-owner/templates/business-proposal.md`](../../product-owner/templates/business-proposal.md)) e entra aqui depois do formulário do stakeholder — sem citar `consulting/` (R31) e sem solução técnica (R20 · R32) |
| **Escopo por sprint** — Histórias (H-nnn) e critérios de sucesso | PO | `[x]` só com o **aceite da História na Review** (R21) e evidência do QA; o sprint aprovado não cresce (R4 · R25) — modelo em [`../../../deliverables/implementation/01-scope-and-criteria.md`](../../../deliverables/implementation/01-scope-and-criteria.md) |
| Product Backlog (`.team-project/product-owner/`) | PO | **O índice ordenado das Histórias**, não o conteúdo delas — cada linha aponta para o arquivo próprio da História (v3.21, §1d). Priorizado por valor e risco funcional; recebe também os gaps, débitos e ressalvas levantados na Sprint Review, **e o GAP não-bloqueante que a QA registra em `pending.md` fora da Review** — o PO abre a linha citando o ID de `pending.md`, no mesmo ciclo da confirmação (R30 · [`workflow-sprint.md` §5e](workflow-sprint.md)) |
| **Plano de entrega** — que Histórias saem em que sprint | **PO** | Ele recebe do time as estimativas e do SM a capacidade, e **decide o que entra e quando sai**. Seção do Product Backlog, não documento novo |
| **Status executivo ao stakeholder** | **PO** | "Onde estamos, o que está bloqueado, o que vem" — em nível de **História**, não de Task. Lê o Sprint Backlog do SM e o registro de evidências do QA; não os edita. Saída de `/po status` |
| **Análise de impacto** | **PO** | O objeto é o **plano de entrega**. Consolida três insumos com dono declarado: quadro e capacidade do **SM**, retrabalho e contrato do **Arquiteto**, risco e recomendação seus. **Não é arbitragem** — não há disputa, é análise de mudança a um plano que é dele. Saída de `/po impact` |
| **Relatos do stakeholder** (`.team-project/note.md`) | **stakeholder** | Ele escreve os itens, ao longo do uso, como sintoma bruto. O **PO** lê e trata (`/po bug`/`/po note`), removendo o item tratado da fila — mesma exceção de dono único do changelog do processo (linha `process-changelog.md`, adiante nesta tabela): quem trata edita só para fechar o item, nunca para escrever conteúdo novo. Modelo em [`../../product-owner/templates/note.md`](../../product-owner/templates/note.md) |
| Documento de status/progresso | SM | Memória de progresso e decisões — modelo em [`../../../deliverables/implementation/02-status.md`](../../../deliverables/implementation/02-status.md). **Homônimo** do "status executivo ao stakeholder" duas linhas acima, que é do PO: a forma de escrever essa fronteira sem derrubar o modo de ninguém está em **§1b** |
| **Registro de consumo do sprint** (`.team-project/sprints/<n>/consumption.md`) | **SM** | **Toda invocação de papel vira linha** — e toda chamada ao `operator`, retratada pelo papel chamador na seção "Execução delegada" do relatório e gravada pela mesma sessão, na mesma passada (com **modelo configurado do papel** — ou "não disponível — motivo" — e Task/História quando houver, `n/a` quando não), escrita por **quem orquestra** (a sessão que disparou o subagente), nunca pelo papel — ele não vê o próprio consumo. Modelo em [`../templates/consumption.md`](../templates/consumption.md). Mede o trabalho dos papéis, não o custo total da sessão; não se soma nem substitui a pegada estática de `/review metrics` ([`workflow-processo.md` §5c](workflow-processo.md)). **Existe só onde `.team-project/` existe** — nunca no clone-fonte do plugin, onde o `/review` roda. **Retenção:** nasce dentro do sprint a que pertence e **fecha com a pasta** — não há arquivamento a fazer. O acumulado do projeto é **derivado** (somar `sprints/*/consumption.md`), não mantido vivo — ver §1c (**somando também o registro fora de sprint, linha seguinte**) |
| **Registro de consumo fora de sprint** (`.team-project/consumption.md`) | **SM** | O consumo do que acontece **sem sprint aberto** — onboarding, brainstorm, `prepare`, `sdd`, portão ①, jobs `operator/pre-sprint/`, invocações entre sprints. **Mesmo modelo** do registro do sprint ([`../templates/consumption.md`](../templates/consumption.md)), Nota `pre-sprint;` (antes do sprint 1) ou `entre-sprints;`; mesmo escritor (a sessão que orquestrou, na hora — **sem transcrição depois**, o que evita contar em dobro). Um arquivo só na raiz de `.team-project/`, **sem rotação**: as linhas nunca se movem nem se arquivam; não tem sprint a que ancorar a retenção (§1c). Substitui a subseção "Consumo pré-sprint (prepare · sdd)" de `scrum-master/context.md`. Criado pelo `/team init`; `/team update` o cria nos projetos que não o têm. Não existe no clone-fonte do plugin |
| **Trilha `fix` — índice das Correções** (`.team-project/fixes.md`) | **SM** · escritor: **a sessão** que orquestra o `/sm fix plan`, o `/sm fix run` e a triagem | Documento vivo, sem rotação, no modelo [`../templates/fix-log.md`](../templates/fix-log.md): uma linha por Correção (`F-<nnn>`) e por bloco (`B-<nnn>`), com estado, veredito e promoção (R33). Mesmo precedente do registro de consumo (dono SM, escritor a sessão). **Não semeado**: nasce na primeira Correção. Fica fora de `sprints/<n>/` porque atravessa sprints (§1c) |
| **Trilha `fix` — ficha da Correção** (`.team-project/fixes/F-<nnn>.md`) | **PO** | Elegibilidade funcional (C1–C4), ponteiro da reprodução, delta do ajuste, confirmação do stakeholder e destino (R33). Modelo em [`../../product-owner/templates/fix-card.md`](../../product-owner/templates/fix-card.md). A ficha **aponta** para a entrada do `pending.md` (História do aceite incluída); não a copia |
| **Trilha `fix` — pasta do bloco** (`.team-project/fixes/B-<nnn>/`) | **SM** (o contêiner e o `consumption.md`) · **Arquiteto** (`plan.md`, modelo [`../../architect/templates/fix-plan.md`](../../architect/templates/fix-plan.md)) · **QA** (`verdict.md`, variante "trilha fix" de [`../../quality-assurance/templates/verdict.md`](../../quality-assurance/templates/verdict.md)) | Nasce quando o `fix plan` monta o bloco; o `consumption.md` do bloco (variante "bloco" de [`../templates/consumption.md`](../templates/consumption.md)) recebe toda invocação do bloco, **inclusive com sprint aberto**. **Fecha** com a linha `## Fechamento` do `verdict.md`: depois dela **nada mais é gravado na pasta** (retenção igual à do sprint, §1c). Pasta com dono ambíguo é achado de auditoria — a atribuição é esta |
| **Jobs do `operator`** (`.team-project/operator/<sprint>/<job>/`, `operator/pre-sprint/<job>/` e, na trilha `fix`, `operator/B-<nnn>/<F-ID\|bloco>/`) | **SM** (verifica e poda) · **papel chamador** (cita) | O `report.md` (ou `report-<log>.md` por chamada) e o log bruto. O `operator` é **instrumento, não papel**: grava o job por conta de quem o chamou. **O SM verifica** (R28: teto do `report`, contagem de chamadas × linhas `operator`) **e poda** o log bruto (após o aceite do PO; o de `pre-sprint/`, no fechamento da cerimônia; o de `B-<nnn>/`, depois do fechamento do bloco — `## Fechamento` do `verdict.md` —, e o `report` sobrevive) — gestão de disco local; o `report` sobrevive. **O papel chamador cita** o `report` no artefato dele (relatório de entrega, veredito, plano, ficha). Local, fora do git (R31) |
| **Benchmark do plugin** (`.team-project/benchmark/`) | **SM** (`protocol.md`, `result.md`, `orientation-<versão>.md`) · **stakeholder** (executa os braços em `<item>/<braço>/`) · SM registra | Experimento sob demanda A/B/C — o plugin × o Claude sem ele — com a regra de decisão **datada antes da 1ª execução**. **Não semeada**: nasce quando o stakeholder abre o experimento. Modelo em [`templates/benchmark.md`](../templates/benchmark.md); roteiro em [`rituals/benchmark.md`](../../../rituals/benchmark.md). Local, fora do git (R31) |
| **Configuração e registro das guardas** (`.team-project/guards.json`, `.team-project/guards.log`) | **SM** (modelo `deliverables/team-project/guards.json` e a coluna "Instrumento" do índice de regras) · **stakeholder** (valores do projeto: `disabled`, `maxInlineLines`, `probe`) · as guardas gravam o `guards.log` | `guards.json` é estrutura + conteúdo local (o `update` completa chaves ausentes e **preserva `disabled`**); `guards.log` é conteúdo do projeto, nunca reconciliado. O SM **lê** o log na retrospectiva (linha "Guardas") e não o edita. Local, fora do git (R31) |
| **`hooks/` e `scripts/checks/`** (guardas G1–G4/G13 da fase 1, G5–G9/G11 da fase 2 — por papel —, G14/G15 da v3.44 e conferências C1 `close.ps1` · C2 `project.ps1` · C3 `release.ps1` · C4 `fix.ps1`) | **stakeholder** | Composição e comportamento do plugin, irmãos de `agents/` e `commands/`: o `/review` **propõe**, não aplica. O SM define **o que cada conferência verifica** (linhas "SM verifica" das regras) e **usa a saída** como evidência; o script não decide por ele. Cobertura em `hooks/COVERAGE.md`. **`hooks/ownership.json` é derivado desta matriz** (a G8 o lê): cada regra cita a linha e o dono daqui, e o C3 confere que os dois batem — **linha nova ou dono mudado nesta tabela muda o `ownership.json` no mesmo ciclo** (R12) |
| **Escopo ativo do dev** (`.team-project/.active-task`) | **SM** · escritor: **a sessão** que dispara o dev | JSON de uma linha — `{ "trilha": "sprint\|fix", "id": "T-<nnn>\|F-<nnn>\|B-<nnn>", "plano": "<caminho do plano relativo ao projeto>" }` —, lido pela guarda **G9**: o dev só escreve no produto os arquivos que o plano lista. Gravado **antes de todo disparo do dev** (`sprint run` passos 3, 4 e 6; `fix run` passo 2; `/dev` avulso e calibração) e **apagado** quando a Task sai do dev (fechada, bloqueada ou pulada) ou no fechamento do bloco. Ausente → a G9 nega todo arquivo de produto ao dev. Local, fora do git (R31) |
| **Run ativo e spike ativo** (`.team-project/.active-run`, `.team-project/.active-spike`) | **SM** · escritor: **a sessão** | Marcadores da v3.44, JSON de uma linha. `.active-run` — `{ "trilha": "sprint\|fix", "id": "<n>\|B-<nnn>", "desde": "<aaaa-mm-dd hh:mm>" }` —, lido pela guarda **G14**: gravado antes do primeiro agente do `sprint run` / `fix run` e **apagado em toda parada legítima**; com ele, o operacional dos papéis sai liberado e o resto é negado com a rota, sem pedido de permissão parado. `.active-spike` — `{ "id": "<S-…\|pedido>", "motivo": "<spike … \| pedido do stakeholder em aaaa-mm-dd>", "desde": "…" }` —, lido pela **G8**: o único caso em que o Arquiteto escreve código-fonte; apagado quando o spike fecha. A G13 avisa na abertura da sessão se um dos dois sobrou. Local, fora do git (R31) |
| **Índices transversais de entregáveis** — `deliverables/README.md`, `deliverables/implementation/README.md`, `deliverables/team-project/README.md` | **SM** | Curadoria, não conteúdo funcional/técnico. Os três atravessam mais de um dono (SDD é do PO/Arquiteto, implementação soma PO+SM+QA, `.team-project/` é de todos) e nenhum outro papel os reivindica sozinho. Cada documento listado neles **continua com o dono próprio** desta matriz — o índice só organiza a navegação. Decisão do stakeholder (`/review` de 14/09/2026, fechando o vão do achado 1/4 na tabela de alcance de `rituals/review-contract.md`); `deliverables/team-project/README.md` já era tratado como do SM na prática desde a v3.13 (ver `process-changelog.md`), só sem linha nesta matriz |
| Sprint Backlog / quadro de trabalho (`.team-project/sprints/<n>/sprint-backlog.md`) | SM · no `sprint run`, **a sessão** troca o marcador da Task e acrescenta a linha de transição ([`sprint-run.md`](sprint-run.md) §Marcador) | As Tasks do sprint corrente, com objetivo do sprint, estimativa, capacidade, o **pacote de abertura aprovado** (data · quem aprovou · ponteiro do protótipo navegado — R25) e o **Registro de transições** (R24 — dado bruto do burndown). Fechado na Planning Meeting; **não cresce durante o sprint** (R4 · [`workflow-sprint.md` §5e](workflow-sprint.md)). **Vive dentro da pasta do sprint e simplesmente fecha no `/sm sprint close`** — não há snapshot, não há cópia. O SM responde por **quanto cabe, em que ordem e o que está bloqueado** — não por prazo nem por prioridade de valor, que são do PO (§6a) |
| **Decisões da Planning e pacote aprovado** (`.team-project/sprints/<n>/planning.md`) | SM (escreve) · PO (fornece a priorização) | O que foi decidido na Planning — candidatas, varredura de bloqueios, corte na capacidade, objetivo — e **o que veio da Review anterior e não entrou, com o motivo** (R25). É peça obrigatória do pacote de abertura: no pacote o stakeholder vê o que **entrou**; sem esta lista, pendência despriorizada passa despercebida. Modelo em [`templates/planning.md`](../templates/planning.md) |
| **Registro de sprint** — Review e retrospectiva | SM | `review.md` ([`templates/sprint-review.md`](../templates/sprint-review.md)) entra no `/sm sprint review`; `retrospective.md` ([`templates/retrospective.md`](../templates/retrospective.md)) entra no `/sm sprint close`. O aceite registrado ali é conduzido pelo PO e **decidido pelo stakeholder**, por História (R21); o SM registra, não aceita. **Exceção de escrita, declarada (v3.34):** as seções `Aceite — H-<nnn>` (o dossiê critério a critério) de `review.md` são **escritas pelo PO** — um escritor por seção — e precedem a pergunta do ④; o SM garante que existem e registra a decisão na tabela do arquivo |
| Burndown do sprint (`.team-project/sprints/<n>/burndown.md`) | SM · no `sprint run`, **a sessão** acrescenta a linha de composição a cada transição | Estimativa restante (unidade do projeto) das Tasks ainda não fechadas, em série datada — não o estado de cada Task, que já está no Sprint Backlog. Derivado do Registro de transições (R24); aberto na aprovação do pacote (dia 0), atualizado a cada transição do `sprint run`, a cada `/sm board` e a cada `/sm close <T-ID>`, fechado (sem mais edição) no `/sm sprint close`. Modelo em [`templates/burndown.md`](../templates/burndown.md) |
| **Histórias congeladas do sprint** (`.team-project/sprints/<n>/stories/`) | **PO** | Uma História por arquivo, `H-nnn.md`, **congelada na aprovação do pacote**: é a História **como foi aprovada para aquele sprint**. O Product Backlog continua a fonte **viva** — mesmo ID, objetos diferentes. Alterar aqui durante o sprint é violação de escopo (R4 · R25). Formato: [`../../product-owner/templates/user-story.md`](../../product-owner/templates/user-story.md) |
| **Evidências de execução do sprint** (`.team-project/sprints/<n>/evidence/`) | **QA** | Comando, saída e veredito, **por Task**, do sprint corrente. O que **soma através dos sprints** fica fora da pasta e não se fatia: registro de GAPs (`pending.md`) e mapa de código (`03-code-map.md`) continuam onde estão |
| Registro de onboarding · brief de `brainstorm` | SM (**facilitação**) | Saída de `/sm onboarding` e `/sm brainstorm` — registro do entendimento alinhado e do brief funcional. **Não substitui** a propriedade do PO sobre o requisito nem a divisão de autoria do SDD (PO: visão/requisitos/fluxos; Arquiteto: arquitetura/dados/API). Não vira arquivo permanente sem lugar declarado em `.team-project/` |
| **SDD em elaboração** (seção de `.team-project/scrum-master/context.md`) | SM | Aberta pelo `/sm sdd` ([`workflow-sdd.md`](workflow-sdd.md) §5h): tema, caso (A ideia nova / B evolução), origem, **brief funcional ≤15 linhas — o lugar declarado do brief (R15)**, estado das etapas e a decisão do ②. O SM só **registra**; o conteúdo do SDD segue dos donos (PO: `00`/`01`/`02`/`06`; Arquiteto: `03`/`04`/`05`). A decisão do ① fica na ficha do protótipo funcional (UX) |
| `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/**` | SM | Processo — muda só a pedido do stakeholder, via `/review` (Agent `scrum-master`) |
| `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/process-changelog.md` | SM (**curador**) | **Exceção à regra de dono único:** todo papel acrescenta a entrada da sua própria mudança de processo; o SM cura — consolida, aponta contradição e escala o que ficou inconsistente. Entrada nunca é reescrita |
| `${CLAUDE_PLUGIN_ROOT}/roles/<papel>/README.md`, `skills.md`, `templates/` | o próprio papel | Roteiro e modelos do papel — evoluem por `/review`, que roteia ao agente do papel dono, com registro no changelog do processo |
| `${CLAUDE_PLUGIN_ROOT}/roles/developer/**` | **Arquiteto** | **Exceção:** o dev não revisa os próprios normativos — roda no modelo mais simples do time, calibrado para executar plano, não para reescrever a regra que o governa. O Arquiteto revisa por `/review`, usando os 🔺 GAPs e as seções "Não fiz" dos relatórios como evidência |
| Contexto do projeto (`.team-project/**/context.md`) | SM, com aporte de cada papel | O papel dono do assunto propõe; o SM mantém a coerência |
| Mapa/inventário de código | QA | Uma linha por arquivo — modelo em [`../../../deliverables/implementation/03-code-map.md`](../../../deliverables/implementation/03-code-map.md) |
| Registro de GAPs abertos | QA | Levantado sobre código; vence a narrativa de status — modelo em [`../../../deliverables/implementation/pending.md`](../../../deliverables/implementation/pending.md). **GAP não-bloqueante ganha par de linha no Product Backlog**, escrito pelo PO, no mesmo ciclo (R30 · [`workflow-sprint.md` §5e](workflow-sprint.md)) |
| Registro de evidências | QA | Comando, saída, veredito — **por Task, em `.team-project/sprints/<n>/evidence/`** (linha "Evidências de execução do sprint", acima) |
| **Baseline de verificação** (`.team-project/quality-assurance/baseline.md`) | **QA** | A foto do estado verificável do projeto antes de o time começar a construir — saída de `/qa baseline`. **Fica fora de `sprints/<n>/` por impossibilidade, não por preferência:** `/qa baseline` roda no onboarding de projeto retomado (§5a · `project-context.md` §8), **antes de o sprint 1 existir**, e a baseline é a régua contra a qual toda regressão futura é medida — ela atravessa todos os sprints por definição (§1c) |
| **Suíte de cenários de teste funcional e regressivo** (`.team-project/quality-assurance/scenarios/`) | **QA** | Mapeada na Planning, por Task (novos + regressivos, R30), a partir do critério de aceite aprovado da História (PO) e do protótipo funcional (UX) — o QA **opera** o critério como caso executável, nunca reescreve requisito. **Acumula através dos sprints**, pelo mesmo motivo do registro de GAPs e da baseline (§1c): é a base de toda regressão futura, e fatiá-la por sprint apagaria exatamente o que o regressivo precisa enxergar. Um arquivo por cenário, `SC-nnn-<slug>.md` (convenção de ID em §4), indexado por `scenarios/README.md`; o Sprint Backlog carrega só a **referência** (lista de IDs por Task), nunca uma cópia do cenário. Modelos de índice e de entrada: QA os aplica em `roles/quality-assurance/templates/`, por `/review` |
| `${CLAUDE_PLUGIN_ROOT}/agents/*`, `commands/*`, `.claude-plugin/*` | stakeholder | Composição e comportamento do time |
| **Guias e rituais de raiz** — `README.md`, `how-to.md` e `rituals/` (`review-contract.md`, `team-init.md`, `team-update.md`, `team-version.md`) | stakeholder | Face de instalação e operação do plugin — irmãos de `agents/`+`commands/` na propriedade. O `/review` **propõe com o texto pronto**, não aplica. O **SM mantém a coerência de referência cruzada** (contagens, ponteiros, nomes de modo, índice de estrutura) e reporta a deriva como achado — manter o ponteiro certo não é reescrever o guia |
| `CHANGELOG.md` (raiz) — changelog de entregas | stakeholder | Registro das entregas versionadas do plugin (`vMAJOR.MINOR.PATCH`). O SM **reconcilia** no `/review`: toda entrada de `process-changelog.md` tem par aqui na mesma linha `vX.Y`; `version` de `.claude-plugin/plugin.json` == topo do `CHANGELOG.md` == o banner "Versão atual" no topo do `README.md` (R18 · [`workflow-processo.md` §5d](workflow-processo.md)) |
| Processo de lançamento — branch, PR, bump de `version`, `/team update` | stakeholder | Fecha a versão e corta a entrega. Roteiro em [`workflow-processo.md` §5d](workflow-processo.md); regra em R18. O SM verifica a rastreabilidade da entrega, não corta a release |

### 1a. `${CLAUDE_PLUGIN_ROOT}/standards/` — dono editorial único, consumo compartilhado (R16)

"Base compartilhada entre Arquiteto, dev e QA" **não afrouxa o invariante de dono único** — o dono *editorial* continua sendo um só, o Arquiteto, e a caneta muda só por `/review`. O que é compartilhado é a **obrigação de consumo** e o **direito de levantar defeito**:

| Papel | Sobre `${CLAUDE_PLUGIN_ROOT}/standards/` | Como propõe mudança |
|---|---|---|
| **Arquiteto** | Dono editorial. Escreve, versiona, mantém a coerência entre nível 1 e perfis de nível 2 | `/review` |
| **dev** | Consumidor obrigatório: aplica a regra ao executar o plano | 🔺 GAP apontando contradição / lacuna / regra inverificável → Arquiteto decide → `/review` roteia a correção do texto ao Arquiteto (o dev não edita os próprios normativos — v1.3) |
| **QA** | Consumidor obrigatório: valida a entrega contra os standards | Achado de processo (não achado de código) → `/review` roteia ao Arquiteto |

**Desempate:** quando os três discordam sobre uma regra de engenharia, decide o **Arquiteto** — é o dono do desenho técnico. A divergência que ultrapassa engenharia (custo, prazo, escopo, política) sobe ao **stakeholder pelo SM**, com as posições lado a lado (consolidação de acordo). Defeito num standard **não se corrige de passagem** — vale a mesma regra do QA que acha defeito fora da Task (abrir registro, não corrigir).

### 1b. Substantivo homônimo — como se escreve uma proibição sem derrubar um modo

Alguns substantivos nomeiam **dois artefatos de donos diferentes**. O caso canônico está nesta própria matriz: **status executivo ao stakeholder** (PO, saída de `/po status`) e **documento de status/progresso** (SM) são linhas distintas, com donos distintos, e chamam-se as duas "status". Os outros homônimos vivos do time:

| Substantivo | Artefato A | Artefato B |
|---|---|---|
| **status** | status executivo ao stakeholder — **PO**, `/po status` | documento de status/progresso — **SM** |
| **especificação** | especificação funcional — **PO** · especificação técnica — **Arquiteto** | "Especificação técnica" é também o nome da **frente 2 do QA**, que valida contra ela sem escrevê-la |
| **protótipo** | **três**, todos do **UX**, com escopos e portões diferentes: **funcional** (fluxos principais de `02`, pré-condição do ①) | **do sprint** (telas das Histórias que entraram, costuradas, pré-condição do ③ — R25) · **de tela** (exploração de uma História, no detalhamento, antes da Planning — nenhum portão próprio) |
| **documentação** | entregáveis do projeto — PO, Arquiteto, QA | relatório de entrega e 🔺 GAP — **saídas obrigatórias do dev** |
| **modo** | **modo leve** de verificação (R23) — escopo do que se reexecuta, do Arquiteto e do UX | os **modos de comando** (`/sm sprint plan`, `/po note`…) — seleção de roteiro, não de rigor |
| **note** | `RAIZ/note.md` — fila do `/review`, evolui o **processo do plugin**, dono **stakeholder**, tratada pelo **Agent `scrum-master`**, só no repositório-fonte | `.team-project/note.md` — fila do `/po note`/`/po bug`, relatos de defeito **deste projeto**, dono **stakeholder**, tratada pelo **PO** (v3.13) |

**A regra.** Nas listas de **"Não faz"** e **"Proibido"** — as linhas mais curtas e mais obedecidas de cada ficha (`roles/<papel>/README.md`) e de cada card (`agents/<papel>.md`) —, o substantivo homônimo **nunca entra cru**. Toda menção qualifica **qual dos dois** e **nomeia o dono**:

| Forma | Exemplo | Efeito |
|---|---|---|
| ❌ **cru** | `Não faz: …, status, …` | O papel conclui que **nenhum** status é dele e recusa o próprio modo |
| ✅ **qualificado + dono** | `Não responde por … nem status **ao stakeholder** — é do PO (§6a)` — [`../README.md`](../README.md), linha "Não faz" | Nega um artefato e preserva o outro |

A forma certa já existe e é a do **SM**: ele é dono do documento de status e mesmo assim declara o que **não** é dele sem ambiguidade, porque qualifica o destinatário (*ao stakeholder*) e nomeia o dono (*é do PO*). É esta a forma a copiar.

**O verbo é a outra metade.** Quando o papel tem relação **legítima** com o artefato do outro — lê, cita, valida contra —, a proibição também declara **qual verbo** está proibido, senão ela apaga a relação junto com a propriedade. O caso é o QA: *"a especificação"* não diz se o vedado é escrevê-la ou também validar contra ela, e validar contra ela é a **frente 2** do papel. A forma completa é `**escrever ou editar** a especificação técnica (é do Arquiteto) — **validar contra** ela é a sua frente 2`.

**Por que a lista de proibição, e não qualquer menção.** Ela é lida como a fronteira do papel e, na prática, **vence a linha que concede** o modo: é mais curta, está mais perto do fim do documento e costuma ser a última coisa que o agente lê antes de agir. Quando o prior do domínio empurra na mesma direção — *"status é do Scrum Master"* —, a palavra crua não precisa convencer ninguém: basta não contradizer. Uma linha de tabela concedendo o modo, quatro linhas acima, não segura.

**Como o SM verifica** — critério de aceitação, citável nas entradas de changelog dos papéis:

1. Para cada papel, cruzar a linha **"Não faz"** de `roles/<papel>/README.md` e a linha **"Proibido"** de `agents/<papel>.md` contra os **modos** e as **responsabilidades declaradas** do mesmo papel (a linha "Responde por", a lista de responsabilidades do card, os títulos de seção do roteiro).
2. **Todo substantivo que aparecer dos dois lados é achado.** Ou ganha qualificador **e** dono na proibição — mais o **verbo**, se o papel tem relação legítima com o artefato —, ou sai dela.
3. A verificação é **de leitura, não de `grep`** — a palavra ocorre nas duas formas, e o `grep` não distingue o uso qualificado do cru. Contar ocorrências aqui não prova nada (R19).

**Origem:** v3.4, a partir de um `/po status` em campo que entregou a leitura de produto e **em seguida se desautorizou**, oferecendo ao stakeholder um `/sm status` extinto na v3.3.

### 1c. Uma forma de retenção por sprint — a pasta numerada, e o que fica fora dela

**A tensão que a v3.19 registrou como devolvida ao stakeholder está resolvida** (decisão do stakeholder, 19/09/2026): não há mais dois padrões de retenção convivendo. **O padrão é um — a pasta numerada `.team-project/sprints/<n>/`.** O par vivo+archive (`consumption-log.md` + `consumption-log-archive.md`) deixa de existir: o registro de consumo passa a nascer dentro do sprint a que pertence, como `sprints/<n>/consumption.md`, e fecha com a pasta.

O que sustentava o vivo+archive era a **tabela de totais acumulados desde o início do projeto**, que uma pasta por sprint não serve bem. A resolução é que esse total passa a ser **derivado sob demanda** — somar `sprints/*/consumption.md` quando alguém pergunta — em vez de mantido vivo. O custo é uma soma na hora da pergunta; o ganho é um arquivo, uma operação de arquivamento e um padrão a menos para o time manter em sincronia.

**Critério para o próximo artefato que precisar de retenção por sprint:**

| O artefato… | Onde vive |
|---|---|
| é **produzido dentro de um sprint** e se lê isolado, pelo número do sprint (Review, Retrospectiva, Planning, burndown, Sprint Backlog, Histórias congeladas, planos, evidências, consumo) | `sprints/<n>/`, com dono declarado em §1e |
| **soma ou evolui através dos sprints** — ou **nasce sem sprint aberto** — e seria quebrado se fatiado (registro de GAPs, mapa de código, **consumo fora de sprint**, **baseline de verificação**, **suíte de cenários de teste**, Product Backlog, SDD, ADRs, protótipo funcional do ①, **checkpoints de spike**, **casos de consultoria externa**, os `context.md`) | fora da pasta do sprint, no lugar que a matriz §1 já declara |
| é **produzido por bloco da trilha `fix`** (R33) e se lê isolado, pelo número do bloco (`plan.md`, `verdict.md`, `consumption.md` do bloco) | `fixes/B-<nnn>/` — **a pasta do bloco é a unidade de retenção**, como a do sprint: nada se move, e o acumulado da trilha é **derivado** somando `fixes/*/consumption.md`. O índice (`fixes.md`) e as fichas (`F-<nnn>.md`) somam através dos blocos e ficam na raiz de `fixes/` |

**A pergunta que decide:** *fatiar isto por sprint destrói alguma leitura que o time faz?* Se sim, fica fora. Se não, entra na pasta numerada.

### 1d. Product Backlog deixa de conter a História — índice com ponteiro, não texto (v3.21)

Até a v3.20, `user-story.md` deixava a `seção própria deste documento` (dentro do Product Backlog) como alternativa válida ao arquivo por História — "a escolha é do projeto". A partir da v3.21 a opção fecha: **o conteúdo de toda História vive em arquivo próprio**, `.team-project/product-owner/stories/<H-ID>-<slug>.md` (convenção de nome em §4). O Product Backlog guarda só a linha de índice, com um link para o arquivo. Gatilho: o Product Backlog estava crescendo sem limite porque acumulava o texto de todas as Histórias, não só a lista delas — o mesmo modo de falha que R17 já corrigiu no changelog do processo, agora no artefato do PO.

**O dono não muda** — índice e arquivos de História são os dois do PO (matriz acima); só o *onde* o conteúdo mora se move. Isto não inverte R20 ([`working-rules.md`](working-rules.md)): R20 fixa que a História é a unidade de valor e é do PO, em contraste com a Task, que é do SM — é regra de **propriedade e locus lógico**, não de layout físico de arquivo.

**O que fica no Product Backlog** (índice e o que pertence ao backlog como um todo, não a uma História isolada):
- a tabela de Histórias — `#, ID, História, Valor, Origem, Tamanho, Estado` — com o ID linkando para o arquivo da História
- a régua de priorização
- o Plano de entrega
- Requisitos em elaboração
- Ressalvas e débitos vindos da Sprint Review
- Decisões funcionais pendentes do stakeholder
- Fora de escopo

**O que sai** — só isto, é o que o stakeholder nomeou (nenhuma outra seção do Product Backlog é tocada por conta própria): o **conteúdo por História** — regras funcionais, protótipos, critérios de aceite, registro do portão ③ — hoje descrito em `user-story.md` (Estado 2, "detalhada").

**Como o SM verifica:** toda linha da tabela de Histórias do Product Backlog tem um link que abre um arquivo em `.team-project/product-owner/stories/`; nenhuma seção "Regras funcionais" / "Protótipos" / "Critérios de aceite" / "Aprovação — portão ③" aparece dentro do Product Backlog — só no arquivo da História. Ver também a linha "SM verifica" de R20 (`working-rules.md`).

### 1e. Dono por subpasta de `.team-project/sprints/<n>/` — pasta com dono ambíguo é achado de auditoria

A pasta do sprint é o único lugar de `.team-project/` em que artefatos de **quatro donos diferentes** convivem sob um contêiner só. O invariante de dono único não afrouxa por isso: ele é declarado **por subpasta**, aqui.

```
.team-project/sprints/<n>/
├── planning.md          SM        · decisões da Planning + o que não entrou, com o motivo (R25)
├── sprint-backlog.md    SM        · VIVO durante o sprint → fechado no /sm sprint close
│                                    relaciona História ↔ Task ↔ plano ↔ evidência
│                                    carrega o pacote de abertura aprovado e o ponteiro do protótipo
├── stories/             PO        · uma História por arquivo, CONGELADO na aprovação do pacote
├── plan/                Arquiteto · um Plano de Implementação por Task
├── evidence/            QA        · evidências de execução do sprint, por Task
├── consumption.md       SM        · tokens e duração por invocação (§1c)
├── burndown.md          SM        · vivo → fechado
├── review.md            SM registra · o PO conduz o aceite · o stakeholder decide
├── retrospective.md     SM
└── plugin-report.md     SM        · só se "investigar" · relatório SEM contexto do projeto, encaminhado pelo stakeholder ao dono do plugin
```

| Subpasta / arquivo | Dono | O que o dono pode fazer, e o que não |
|---|---|---|
| o **contêiner** `sprints/<n>/` | **SM** | Cria no `/sm sprint plan`, fecha no `/sm sprint close`. Não escreve dentro das três subpastas de outros donos |
| `stories/` | **PO** | Congela na aprovação do pacote e **não altera depois** (R4 · R25). A fonte viva continua sendo o Product Backlog |
| `plan/` | **Arquiteto** | Um plano por Task (plano fora de sprint: `.team-project/architect/calibration/`, §1). Task retomada no sprint seguinte tem plano **reescrito lá**, referenciando o anterior — o plano antigo não se edita, porque é registro fechado |
| `evidence/` | **QA** | Evidência por Task do sprint corrente. `pending.md` e o mapa de código **não** entram: somam através dos sprints (§1c) |
| `planning.md` · `sprint-backlog.md` · `burndown.md` · `consumption.md` · `review.md` · `retrospective.md` · `plugin-report.md` | **SM** | Escreve e fecha. Registra o aceite, **não aceita** (R21). O `plugin-report.md` sai do projeto pela mão do **stakeholder**, nunca do SM, e traz só processo, papel, modelo e números — o projeto não edita o plugin |

**O protótipo do sprint não mora aqui.** O Sprint Backlog carrega o **ponteiro** para ele; o artefato é do UX e vive em `.team-project/user-experience/prototype/sprint-<n>/`, preservado por sprint (linha própria na matriz §1). Duplicá-lo dentro da pasta criaria duas verdades para um artefato navegável.

**Quatro artefatos ficam fora da pasta por natureza, e a matriz §1 diz onde cada um vive:** o **protótipo do sprint** (acima), os **checkpoints de spike** do Arquiteto, a **baseline de verificação** do QA e a **suíte de cenários de teste** da QA (R30). Os três últimos atravessam sprints — os dois primeiros respondem a dúvida técnica ou medem regressão numérica, um consultado depois do fechamento, a outra nascida **antes do sprint 1**; a suíte de cenários é a base acumulada de todo regressivo futuro, e fatiá-la por sprint apagaria exatamente o que ela existe para enxergar. O Sprint Backlog carrega só a **referência** (lista de IDs por Task), nunca uma cópia do cenário.

**Como o SM verifica:** todo arquivo de `sprints/<n>/` cai numa linha desta tabela; arquivo sem linha é achado de auditoria, e ou ganha dono aqui ou sai da pasta. Arquivo de `stories/` com data de modificação posterior à aprovação do pacote é violação de escopo (R4).

### 1f. Produto × processo — o que o git recebe (R31)

| Camada | Onde vive | No git do projeto? | Pode referenciar |
|---|---|---|---|
| **Produto** | o código e `docs/` (SDD, ADR, implementação — [`deliverables/README.md`](../../../deliverables/README.md)) | **Sim** | só produto — **nunca** `.team-project/` |
| **Processo** | `.team-project/` inteiro (backlog, sprints, evidências, consumo, logs do `operator`, contextos, protótipos) | **Não** — `.gitignore` com `.team-project/` (`/team init` · `/team update`) | processo e produto (`docs/`) |

O estado da gestão é local e sem histórico: decisão do stakeholder, que aceitou a perda de continuidade. **Como o SM verifica:** ver R31 em [`working-rules.md`](working-rules.md) — `git ls-files .team-project` vazio, `docs/` e os modelos que o geram sem caminho `.team-project/`. Modelo que gera documento de produto e cita `.team-project/` é achado contra o **dono do modelo** (a matriz §1 diz quem é), e o SM o roteia.
## 2. Fluxo de um artefato entre papéis

```
[projeto novo/retomado] ─▶ SM conduz onboarding (§5a) ─▶ contexto do projeto alinhado
[ideia sem documentação] ─▶ SM facilita brainstorm (§5b): PO+UX, depois +Arquiteto ─▶ brief funcional ─▶ `/sm sdd` (§5h)
           │
ideia ─────▶ `/sm sdd`: PO escreve o SDD funcional · UX faz o protótipo em HTML
              └─▶ ① stakeholder NAVEGA o protótipo e aprova
              └─▶ Arquiteto escreve o SDD técnico ──② aprovado
                    └─▶ PO escreve a História e a prioriza no Product Backlog
                          └─▶ PO detalha (UX faz a especificação de tela)
                                └─▶ Planning: o time quebra em Tasks, estima e corta
                                      └─▶ SM fecha o Sprint Backlog e grava planning.md
                                            └─▶ pacote: backlog + critérios + protótipo do sprint
                                                  └─▶ ③ stakeholder NAVEGA e aprova — o sprint arranca
                                                        └─▶ Arquiteto escreve o Plano de Implementação
                                                              └─▶ dev escreve código+testes
                                                                    └─▶ QA registra evidência
                                        ┌───────────────────────────────┘
                                        ├─▶ QA atualiza inventário de código e registro de GAPs
                                        ├─▶ SM atualiza o status e fecha a Task
                                        └─▶ Sprint Review: ④ aceite por História
                                              └─▶ SM conduz a retrospectiva e fecha o sprint
```

Os quatro portões numerados são os gates de [`workflow.md` §8](workflow.md). Repare que o **fechamento da Task é do SM e é técnico**; o **aceite é por História, na Review** — conduzido pelo PO, decidido pelo stakeholder (R21). Os dois nunca são o mesmo ato, e nunca são do mesmo papel.

O **③ acontece depois da Planning, em lote**, sobre o pacote de abertura do sprint (R20 · R25 · [`workflow-sprint.md` §5g](workflow-sprint.md)): o stakeholder tem **dois pontos de contato por sprint** — a abertura e a Review. A propriedade de nenhum artefato muda por causa disso; o que muda é **quando** e **em que granularidade** o ③ é apresentado.

## 3. Conflitos comuns e como resolver

| Situação | Errado | Certo |
|---|---|---|
| Dev percebe requisito ambíguo | Decidir e seguir | 🔺 GAP → Arquiteto → (se funcional) PO |
| Dev não sabe o que mostrar no estado vazio ou de erro | Inventar a tela | 🔺 GAP → UX; a especificação é corrigida |
| UX precisa de um dado que a API não expõe | Supor o contrato | Levantar ao Arquiteto antes de fechar a especificação |
| UX quer mudar uma regra para simplificar a tela | Mudar no desenho | Escalação ao PO — regra é dele |
| Arquiteto quer renomear entidade da especificação | Renomear no plano | Mudança formal: PO aprova, Arquiteto atualiza o modelo, migration explícita |
| QA encontra defeito fora da Task | Corrigir de passagem | Abrir GAP; SM entra na fila |
| Stakeholder quer saber prazo ou andamento | Perguntar ao SM | É do **PO**: ele detém o plano de entrega e o status (§6a). O SM responde quanto cabe, não quando sai |
| Achado do QA atravessa papéis | Reunir os seis, ou empurrar ao PO por ser o canal | O QA roteia pelo **objeto da dúvida** (§6b); só quando não consegue classificar é que o SM facilita por `/sm agreement` |
| PO quer refazer a conta de capacidade para caber mais | Renegociar a média entregue | A capacidade é **observada**. O PO decide o que **sai**, não quanto cabe |
| SM quer tirar uma História do sprint por achá-la de baixo valor | Cortar do Sprint Backlog | Valor é do PO. O SM aponta risco e capacidade; quem corta por valor é o PO |
| PO detalha a História citando arquivo, classe ou endpoint | Deixar passar — "é só contexto" | Devolver ao PO: o detalhamento é só funcional; o técnico nasce no Plano de Implementação (R20) |
| Surge trabalho técnico que nenhuma História cobre | Criar Task solta no sprint | PO escreve a História que declara o valor, ainda que o beneficiário seja o time (R20) |
| Task pronta dentro de uma História rejeitada na Review | Fechar a Task e seguir | Toda a História volta ao Product Backlog, com as Tasks boas junto (R21) |
| Stakeholder pede escopo novo no meio do sprint | Encaixar no Sprint Backlog | Vai ao Product Backlog e concorre na Planning seguinte; exceção só para GAP que bloqueia História já no sprint, com "o que saiu para caber" registrado |
| SM vê status divergente do código | Ajustar o status pela intuição | Acionar `/qa audit`; corrigir com o achado |
| Um papel recusa o **próprio modo** citando a lista de "Não faz" | Aceitar a recusa — "está escrito lá" | O substantivo está cru (§1b). A linha que **concede** o modo vence; a proibição é corrigida no mesmo ciclo, com qualificador e dono |
| Mudança de `/review` aplicada mas não lançada | Assumir que as instalações já a têm | Entra numa entrega: branch, bump de `version`, entrada no `CHANGELOG.md` (R18 · [`workflow-processo.md` §5d](workflow-processo.md)) |
| PO quer marcar critério de sucesso como atendido | Marcar direto | Exige evidência no registro do QA |
| O time começa a construir logo depois de a Planning fechar | Assumir que o Sprint Backlog fechado já autoriza | O ③ é a **aprovação do pacote**, e ela vem depois (R20 · R25). Sem data de aprovação no Sprint Backlog, nenhuma Task entra em construção — e o dia 0 do burndown é o da aprovação, não o do fim da Planning |
| PO ajusta uma História durante o sprint, em `sprints/<n>/stories/` | Editar o arquivo congelado — "é só um detalhe" | `stories/` é a História **como foi aprovada** (R25 §1e). Ajuste vai ao Product Backlog, que é a fonte viva, e entra no sprint seguinte; o que não puder esperar é entrada fora de Planning, com "o que saiu para caber" |
| Task volta ao Product Backlog e é retomada dois sprints depois | Reusar o plano que ficou em `sprints/<n-1>/plan/` | O plano é **reescrito** no sprint novo, referenciando o anterior — retomar depois de um sprint exige revisar o plano de qualquer forma (R3 · R5 · §1e) |
| Dúvida aparece no meio do sprint e alguém leva direto ao stakeholder | Escalar na hora, "para não travar" | **Degrau 1 primeiro:** PO e Arquiteto conversam (R25 · [`workflow-sprint.md` §5g](workflow-sprint.md)). Só o que eles não fecham sobe, na forma de R22 — exceto **decisão estratégica**, que vai direto |
| Task reprova duas vezes no mesmo gate | Tentar a terceira e seguir | Vira bloqueio no quadro, com o degrau nomeado, e a evidência das duas tentativas acompanha a escalação (R22 · R25) |

## 4. Convenções

- **Idioma:** documentação e comunicação no idioma do time; código, identificadores e mensagens de commit seguem o padrão já existente no repositório.
- **IDs:** padrão definido no contexto do projeto; nunca reaproveitados. Convenção padrão: `H-nnn` para História, `T-nnn` para Task, sufixo para quebra (`T-012a`, `T-012b`), `SC-nnn` para Cenário de teste (R30); Task nascida de um GAP reusa o ID do GAP.
- **Nome de arquivo de História:** `<H-ID>-<slug>.md`, em `.team-project/product-owner/stories/` — mesmo padrão de `<Task-ID>-<slug>.md` dos Planos de Implementação, linha acima na matriz (v3.21, §1d).
- **Commits:** uma Task por commit sempre que possível, referenciando o ID da Task.
- **Resolver GAP:** o QA remove a entrada do registro de GAPs e o SM registra a correção no documento de status — nunca os dois no mesmo arquivo.
- **Documento vivo** traz no topo a marcação **DOCUMENTO VIVO**, o dono e a data da última atualização.
- **Nomes de arquivo em `${CLAUDE_PLUGIN_ROOT}/` e `.team-project/`:** inglês, kebab-case, sem acento. Conteúdo no idioma do time. Documento vivo e modelo compartilham o nome — o modelo fica em `templates/`.
