# `.team-project/` — Manifesto do contexto instalado no projeto

> **Dono:** SM · **É o índice único do que o `/team init` cria e do que o `/team update` reconcilia.**

Os outros dois conjuntos de `deliverables/` descrevem **documentos do produto** (o [SDD](sdd/README.md) e a [implementação](implementation/README.md)). Este descreve o **contexto de operação do time** — o `.team-project/` que nasce no `/team init` e sem o qual nenhum papel opera.

## Por que aqui é um índice, e não uma cópia dos modelos

Cada modelo pertence ao **papel que o usa** (`roles/<papel>/templates/`), por [`artifact-ownership.md`](../../roles/scrum-master/process/artifact-ownership.md): o papel é quem o evolui, por `/review`. Copiar os modelos para cá criaria **duas verdades para manter** — exatamente o que a regra de referência cruzada proíbe. O que faltava não era um lugar para os arquivos: era **um lugar que declarasse, num documento só, o que o `.team-project/` é feito**. É este manifesto.

## Manifesto — o que o `/team init` cria

| Caminho no projeto | Nasce de | Dono do modelo | Reconciliar no `update`? |
|---|---|---|---|
| `.team-project/README.md` | [`roles/scrum-master/templates/project-context.md`](../../roles/scrum-master/templates/project-context.md) | SM | **Sim — §8 é bloco fixo**, o resto é do projeto |
| `.team-project/how-to.md` | [`how-to.md`](../../how-to.md) da raiz | stakeholder | **Sim — cópia literal**, sempre substituível |
| `.team-project/scrum-master/context.md` | seção "O que vai em cada `context.md`" do modelo de contexto | SM | Não — conteúdo do projeto |
| `.team-project/scrum-master/work-board.md` | [`roles/scrum-master/templates/work-board.md`](../../roles/scrum-master/templates/work-board.md) | SM | **Sim — estrutura**; as linhas são do projeto |
| `.team-project/product-owner/context.md` | idem | PO | Não |
| `.team-project/product-owner/product-backlog.md` | [`roles/product-owner/templates/product-backlog.md`](../../roles/product-owner/templates/product-backlog.md) | PO | **Sim — estrutura**; as Histórias são do projeto |
| `.team-project/architect/context.md` | idem | Arquiteto | Não |
| `.team-project/architect/plans/` | vazia; os planos nascem de [`implementation-plan.md`](../../roles/architect/templates/implementation-plan.md) | Arquiteto | **Sim — o modelo**, não os planos escritos |
| `.team-project/user-experience/context.md` | idem | UX | Não |
| `.team-project/user-experience/journeys/` · `screens/` | vazias; nascem de [`journey-map.md`](../../roles/user-experience/templates/journey-map.md) e [`screen-spec.md`](../../roles/user-experience/templates/screen-spec.md) | UX | **Sim — os modelos** |
| `.team-project/developer/context.md` | idem | dev | Não |
| `.team-project/quality-assurance/context.md` | idem | QA | Não |
| `.team-project/quality-assurance/evidence.md` | [`roles/quality-assurance/templates/evidence.md`](../../roles/quality-assurance/templates/evidence.md) | QA | **Sim — estrutura**; as evidências são do projeto |

**Histórias:** vivem em `.team-project/product-owner/`, no formato de [`user-story.md`](../../roles/product-owner/templates/user-story.md) — em arquivo por História ou em seção do backlog, à escolha do projeto, declarada no `context.md` do PO.

## As três classes de reconciliação

O `/team update` compara a versão instalada com a da origem e, quando há versão nova, **também confere o que foi instanciado a partir destes modelos** ([`team-update.md`](../../team-update.md) §8). Cada linha do manifesto cai numa das três:

| Classe | O que é | O que o `update` faz |
|---|---|---|
| **Cópia literal** | O arquivo no projeto **é** o modelo, sem conteúdo local (`how-to.md`) | Substitui, avisando |
| **Estrutura + conteúdo local** | Cabeçalho, colunas e seções vêm do modelo; as linhas são do projeto (`work-board`, `product-backlog`, `evidence`, `README` §8) | **Mostra o delta da estrutura e pede aprovação** — nunca sobrescreve conteúdo do projeto |
| **Só conteúdo local** | O modelo só disse o que escrever, uma vez (os seis `context.md`) | Não toca; lista como "conferir manualmente" se o modelo mudou muito |

**Regra que sustenta as três:** o `update` **nunca apaga conteúdo escrito pelo time** sem o stakeholder aprovar. Delta de estrutura é proposta, não aplicação.

## Como manter este manifesto

- **Modelo novo que o `init` passe a semear entra aqui na mesma mudança** — modelo semeado e não listado é o defeito que este documento existe para evitar.
- A classe de reconciliação é declarada **quando o modelo entra**, não descoberta no `update`.
- Este manifesto é do SM porque é ele quem conduz o `init` e responde pela coerência do contexto; os **modelos** continuam sendo de seus papéis.
