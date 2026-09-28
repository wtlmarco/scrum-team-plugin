# `.team-project/` — Manifesto do contexto instalado no projeto

> **Dono:** SM · **É o índice único do que o `/team init` cria e do que o `/team update` reconcilia.**

Os outros conjuntos de `deliverables/` descrevem **o produto** — o [protótipo funcional](../prototype/README.md), o [SDD](../sdd/README.md) e a [implementação](../implementation/README.md). Este descreve o **contexto de operação do time** — o `.team-project/` que nasce no `/team init` e sem o qual nenhum papel opera.

## Por que aqui é um índice, e não uma cópia dos modelos

Cada modelo pertence ao **papel que o usa** (`roles/<papel>/templates/`), por [`artifact-ownership.md`](../../roles/scrum-master/process/artifact-ownership.md): o papel é quem o evolui, por `/review`. Copiar os modelos para cá criaria **duas verdades para manter** — exatamente o que a regra de referência cruzada proíbe. O que faltava não era um lugar para os arquivos: era **um lugar que declarasse, num documento só, o que o `.team-project/` é feito**. É este manifesto.

## Manifesto — o que o `/team init` cria

| Caminho no projeto | Nasce de | Dono do modelo | Reconciliar no `update`? |
|---|---|---|---|
| `.team-project/README.md` | [`roles/scrum-master/templates/project-context.md`](../../roles/scrum-master/templates/project-context.md) | SM | **Sim — §8 é bloco fixo**, o resto é do projeto |
| `.team-project/how-to.md` | [`how-to.md`](../../how-to.md) da raiz | stakeholder | **Sim — cópia literal**, sempre substituível |
| `.team-project/note.md` | [`roles/product-owner/templates/note.md`](../../roles/product-owner/templates/note.md) | PO | **Sim — estrutura**; os itens de "Abertas" são do stakeholder |
| `.team-project/sprints/` | vazia no `init`; um subdiretório por sprint, criado em `/sm sprint plan` — ver "A pasta do sprint", abaixo | **SM** (contêiner) · dono por subpasta | **Sim — os modelos**, nunca o conteúdo escrito nem sprint já fechado |
| `.team-project/scrum-master/context.md` | seção "O que vai em cada `context.md`" do modelo de contexto | SM | Não — conteúdo do projeto |
| `.team-project/product-owner/context.md` | idem | PO | Não |
| `.team-project/product-owner/product-backlog.md` | [`roles/product-owner/templates/product-backlog.md`](../../roles/product-owner/templates/product-backlog.md) | PO | **Sim — estrutura**; as linhas do índice são do projeto |
| `.team-project/product-owner/stories/` | vazia; cada História nasce de [`user-story.md`](../../roles/product-owner/templates/user-story.md), um arquivo por História (v3.21) | PO | **Sim — o modelo**, não as Histórias escritas |
| `.team-project/architect/context.md` | idem | Arquiteto | Não |
| `.team-project/architect/spikes/` | vazia; um checkpoint por spike, `<ID>-<slug>.md`, salvo a cada etapa concluída (R5) | Arquiteto | Não — conteúdo do projeto. **Fora da pasta do sprint de propósito:** o spike é consultado depois que o sprint fechou |
| `.team-project/user-experience/context.md` | idem | UX | Não |
| `.team-project/user-experience/prototype/` | vazia; o **protótipo funcional em HTML** nasce de [`functional-prototype.md`](../../roles/user-experience/templates/functional-prototype.md) — entregável e pré-condição do portão ① | UX | **Sim — a ficha e os critérios**, nunca o HTML escrito |
| `.team-project/user-experience/prototype/sprint-<n>/` | uma pasta por sprint; o **protótipo do sprint** nasce de [`sprint-prototype.md`](../../roles/user-experience/templates/sprint-prototype.md) — entregável e pré-condição do portão ③ (R25). O Sprint Backlog guarda só o **ponteiro** | UX | **Sim — a ficha e os critérios**; sprint fechado é **histórico imutável** |
| `.team-project/user-experience/journeys/` · `screens/` | vazias; nascem de [`journey-map.md`](../../roles/user-experience/templates/journey-map.md) e [`screen-spec.md`](../../roles/user-experience/templates/screen-spec.md) | UX | **Sim — os modelos** |
| `.team-project/developer/context.md` | idem | dev | Não |
| `.team-project/quality-assurance/context.md` | idem | QA | Não |
| `.team-project/quality-assurance/baseline.md` | saída de `/qa baseline`, no onboarding de projeto retomado (§5a) | QA | **Sim — estrutura**. **Fora da pasta do sprint por impossibilidade:** nasce **antes de o sprint 1 existir**, e é a régua de toda regressão futura |
| `.team-project/quality-assurance/scenarios/` | vazia; um arquivo por cenário nasce de [`scenario.md`](../../roles/quality-assurance/templates/scenario.md), indexado por [`scenarios-index.md`](../../roles/quality-assurance/templates/scenarios-index.md) (`scenarios/README.md` no projeto) — mapeado por Task na Planning, novo e regressivo (R30) | QA | **Sim — os modelos**, nunca o conteúdo escrito. **Fora da pasta do sprint de propósito:** acumula através dos sprints, é a base de todo regressivo futuro (`artifact-ownership.md` §1c) |

## A pasta do sprint — `.team-project/sprints/<n>/`

O registro de execução é organizado **por sprint**, não por papel (R25): a pasta contém Histórias, planos, evidências e os documentos do SM. **O dono é declarado por subpasta** — pasta com dono ambíguo é achado de auditoria. A matriz normativa está em [`artifact-ownership.md` §1e](../../roles/scrum-master/process/artifact-ownership.md); aqui fica o que o `init`/`update` precisa saber.

| Caminho | Nasce de | Dono | Quando nasce · quando fecha | Reconciliar no `update`? |
|---|---|---|---|---|
| `planning.md` | [`planning.md`](../../roles/scrum-master/templates/planning.md) | **SM** | passo 9 da Planning · fecha com a pasta | **Sim — o modelo** |
| `sprint-backlog.md` | [`sprint-backlog.md`](../../roles/scrum-master/templates/sprint-backlog.md) | **SM** | Planning · **fechado** no `/sm sprint close`, sem cópia | **Sim — estrutura**; as linhas e o Registro de transições (R24) são do projeto |
| `stories/` | [`user-story.md`](../../roles/product-owner/templates/user-story.md) | **PO** | **congelado** na aprovação do pacote | **Sim — o modelo**, nunca o conteúdo congelado |
| `plan/` | [`implementation-plan.md`](../../roles/architect/templates/implementation-plan.md) | **Arquiteto** | um por Task, antes da construção | **Sim — o modelo**, não os planos escritos |
| `evidence/` | [`evidence.md`](../../roles/quality-assurance/templates/evidence.md) | **QA** | um por Task, no veredito | **Sim — estrutura**; as evidências são do projeto |
| `consumption.md` | [`consumption.md`](../../roles/scrum-master/templates/consumption.md) | **SM** | uma linha por invocação · fecha com a pasta | **Sim — estrutura**; as linhas são do projeto |
| `burndown.md` | [`burndown.md`](../../roles/scrum-master/templates/burndown.md) | **SM** | dia 0 = aprovação do pacote · fecha no `/sm sprint close` | **Sim — o modelo** |
| `review.md` | [`sprint-review.md`](../../roles/scrum-master/templates/sprint-review.md) | **SM** registra | `/sm review` | **Sim — o modelo** |
| `retrospective.md` | [`retrospective.md`](../../roles/scrum-master/templates/retrospective.md) | **SM** | `/sm sprint close` | **Sim — o modelo** |

**Retenção — uma forma só.** Pasta numerada, e nada de vivo+archive: o registro de consumo passou a viver em `sprints/<n>/consumption.md`, e o acumulado do projeto é **derivado** somando as pastas (critério e racional em [`artifact-ownership.md` §1c](../../roles/scrum-master/process/artifact-ownership.md)).

**Sprint fechado é imutável.** O `update` **não** reconcilia estrutura dentro de `sprints/<n>/` de sprint já encerrado: são registros históricos, e reescrevê-los destruiria o que eles existem para provar. Modelo novo vale do próximo sprint em diante.

**O que fica FORA da pasta, e por quê:** registro de GAPs (`pending.md`), mapa de código (`03-code-map.md`), **baseline de verificação** (nasce antes do sprint 1), **suíte de cenários de teste** (`scenarios/`, R30), Product Backlog, SDD, ADRs, protótipo funcional do ①, **protótipo do sprint** e **checkpoints de spike** — todos somam, evoluem ou nascem fora do recorte de um sprint, e fatiá-los quebraria a leitura que o time faz deles. O Sprint Backlog carrega apenas o **ponteiro** do protótipo do sprint e a **referência** (lista de IDs) da suíte de cenários; os artefatos são do UX e do QA, respectivamente.

**Histórias:** a fonte **viva** é `.team-project/product-owner/`, no formato de [`user-story.md`](../../roles/product-owner/templates/user-story.md). `sprints/<n>/stories/H-nnn.md` é a mesma História **como foi aprovada para aquele sprint** — mesmo ID, objetos diferentes (R25). O `update` nunca funde os dois.

**Onde o time acha o quadro vivo:** `.team-project/README.md` §2 declara o **sprint corrente**. Com o Sprint Backlog dentro da pasta numerada, o caminho deixa de ser fixo — e essa linha é o único índice.

## As três classes de reconciliação

O `/team update` compara a versão instalada com a da origem e, quando há versão nova, **também confere o que foi instanciado a partir destes modelos** ([`team-update.md`](../../team-update.md) §8). Cada linha do manifesto cai numa das três:

| Classe | O que é | O que o `update` faz |
|---|---|---|
| **Cópia literal** | O arquivo no projeto **é** o modelo, sem conteúdo local (`how-to.md`) | Substitui, avisando |
| **Estrutura + conteúdo local** | Cabeçalho, colunas e seções vêm do modelo; as linhas são do projeto (`sprint-backlog`, `product-backlog`, `evidence`, `consumption`, `README` §8) | **Mostra o delta da estrutura e pede aprovação** — nunca sobrescreve conteúdo do projeto |
| **Só conteúdo local** | O modelo só disse o que escrever, uma vez (os seis `context.md`) | Não toca; lista como "conferir manualmente" se o modelo mudou muito |
| **Histórico imutável** | Registro de um sprint **já fechado** (`sprints/<n>/` encerrado) | **Não toca, nunca** — nem estrutura. Modelo novo vale do próximo sprint em diante |

**Regra que sustenta as quatro:** o `update` **nunca apaga conteúdo escrito pelo time** sem o stakeholder aprovar. Delta de estrutura é proposta, não aplicação — e sobre sprint fechado nem proposta existe.

## Como manter este manifesto

- **Modelo novo que o `init` passe a semear entra aqui na mesma mudança** — modelo semeado e não listado é o defeito que este documento existe para evitar.
- A classe de reconciliação é declarada **quando o modelo entra**, não descoberta no `update`.
- **Toda subpasta nova de `sprints/<n>/` entra com dono declarado**, aqui e em [`artifact-ownership.md` §1e](../../roles/scrum-master/process/artifact-ownership.md). Subpasta sem dono é achado de auditoria, não detalhe de arrumação.
- Este manifesto é do SM porque é ele quem conduz o `init` e responde pela coerência do contexto; os **modelos** continuam sendo de seus papéis.
