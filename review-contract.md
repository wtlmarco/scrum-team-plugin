# Contrato do `/review` — evolução do processo

> Lido **quando `/review` roteia um item ao agente de um papel**. O comando `/review` está em [`commands/review.md`](commands/review.md); aqui está o que o **agente** faz ao receber o item.
>
> **Por que este arquivo existe:** o contrato ocupava 53–63% de cada arquivo de comando de papel e era injetado no prompt em *toda* invocação, inclusive nas que nunca evoluíam o processo. Fica aqui, lido só quando `/review` aciona um papel.

## O que o `/review` é

O processo de trabalho do time — os documentos em `${CLAUDE_PLUGIN_ROOT}/` — **não muda por conversa**: muda pelo `/review`. Cada papel aperfeiçoa **os próprios documentos** a partir de uma instrução do stakeholder ou de um item de `note.md` que o SM classificou e roteou.

O **Agent `scrum-master`** faz a triagem e a curadoria e tem alcance maior: além do roteiro, das skills e dos modelos do SM, é o único que altera os **normativos que governam todos** — `process/working-rules.md`, `process/workflow.md`, `process/artifact-ownership.md`.

## Alcance por papel

O que cada agente pode editar quando `/review` o aciona:

| Papel | Alcance |
|---|---|
| **Scrum Master** | `roles/scrum-master/` (roteiro, skills, modelos); **os normativos que governam todos** (`process/working-rules.md`, `process/workflow.md`, `process/artifact-ownership.md`); a **curadoria** do processo do time inteiro — consolidar o changelog, apontar contradição entre mudanças de papéis diferentes, escalar o inconsistente |
| **Product Owner** | `roles/product-owner/` (roteiro, skills, modelos — requisito, análise funcional, aceite, backlog); os entregáveis que possui — `deliverables/sdd/` (índice, visão geral, requisitos, fluxos, changelog) e `deliverables/implementation/01-scope-and-criteria.md` |
| **Arquiteto** | `roles/architect/` (roteiro, skills, modelos); **`standards/*`** (dono editorial — R16); os entregáveis que possui em `deliverables/sdd/` (arquitetura, dados, API); **e os documentos do papel dev** (`roles/developer/*`) — o dev roda no modelo mais simples do time e não reescreve o normativo que o governa. Evidência ao revisar o dev: os 🔺 GAPs e as seções "Não fiz (fora do plano)" dos relatórios recentes |
| **UX** | `roles/user-experience/` — roteiro, skills e modelos (jornada, tela, revisão de usabilidade), incluindo os **seis estados** e a lista de critérios de acessibilidade verificáveis que vivem nesses modelos |
| **QA** | `roles/quality-assurance/` (roteiro, skills, modelos — veredito, evidências, registro de GAP, auditoria cruzada); os entregáveis que possui — `deliverables/implementation/03-code-map.md` e `pending.md`. Entram também os **controles de qualidade**: as seis frentes, o checklist de segurança, os limiares |

**Cuidados do Arquiteto ao mexer em `standards/`:** são **agnósticos de produto** — instrução que os ajuste para acomodar um caso do projeto atual vai para o documento de arquitetura do projeto, não para cá; e mudança num perfil de nível 2 que afrouxe o nível 1 não entra.

**Cuidado do QA:** critério de validação novo precisa ser **verificável** — se o QA não consegue produzir evidência dele, não entra no veredito. Defeito no próprio `standards/` é achado de processo roteado ao Arquiteto, nunca correção do QA (R16).

## Quatro passos, na ordem

1. **Classificar** a instrução — regra de trabalho, etapa de fluxo, cerimônia, propriedade de artefato, formato de documento, escopo de papel, ou comportamento de agente. A classificação decide qual documento muda.
2. **Analisar impacto e conflito** — quem passa a ser cobrado de forma diferente, e se a instrução contradiz alguma regra vigente. **Conflito não se resolve sozinho:** apresente as duas posições e pare para decisão do stakeholder.
3. **Aplicar** no documento certo, no formato que ele já usa. Regra nova recebe número na sequência (`R18`, `R19`…) e traz **o que evita** e **como o SM verifica** — regra sem verificação não entra.
4. **Registrar** em `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/process-changelog.md`, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/process-change.md`, com o indicador que provaria que a mudança funcionou.

## Reavaliação do conjunto — sempre

`/review` não é só aplicar a instrução: é **reavaliar os documentos do alcance do papel** à luz dela. Depois de aplicar — ou quando `/review` vier **sem instrução**, caso em que a reavaliação é a entrega inteira — releia o roteiro, as skills, os modelos e o que mais estiver no alcance, e reporte:

| Verificação | O que procurar |
|---|---|
| Coerência interna | Dois documentos do papel que se contradizem |
| Aderência à prática | Roteiro que descreve o que o papel já não faz, ou omite o que ele faz |
| Verificabilidade | Critério, regra ou controle sem forma de verificação |
| Cobertura de modelos | Modelo que ninguém referencia; documento produzido sem modelo |
| Fronteiras | Responsabilidade que se sobrepõe à de outro papel |
| Vazamento de contexto | Nome de produto, stack ou caminho de projeto dentro de `${CLAUDE_PLUGIN_ROOT}/`, que é genérico |
| Obsolescência | Seção que cita comando, papel ou documento que mudou de nome ou deixou de existir |
| Excesso | O que dá para **remover** — processo que só cresce deixa de ser seguido |

Achado dentro do seu alcance: corrija e registre no changelog. Achado no documento de outro papel: **devolva ao SM para rotear**, não corrija.

## Limites — valem para todos

- **Só os documentos do seu alcance.** Instrução que toca outro papel volta ao SM: *"isso é do Arquiteto"*.
- **Normativo que governa todos** (regras de trabalho, fluxo, propriedade de artefatos) é exclusivo do **Agent `scrum-master`**.
- **Não altera `.team-project/`, o código, o quadro nem o backlog** — só o processo.
- **`agents/` e `commands/` são do stakeholder:** **proponha** com o texto pronto, não aplique.
- **O SM é o curador:** consolida o changelog, remove duplicidade, aponta contradição entre mudanças de papéis diferentes e leva ao stakeholder o que ficou inconsistente.
- **Mudança de comportamento de agente só entra em vigor após reiniciar a sessão** — diga isso ao stakeholder ao reportar.

## Modos auxiliares (conduzidos pelo Agent `scrum-master`)

- **`/review audit`** — coerência interna de `${CLAUDE_PLUGIN_ROOT}/`: regras contraditórias, regra sem verificação, papel com fronteira ambígua, documento sem dono, modelo órfão, vazamento de contexto de projeto, links quebrados.
- **`/review metrics`** — revisão por evidência a partir dos indicadores do período, com **uma** proposta de mudança. Inclui o giro **Act** do ciclo de eficiência (`workflow.md` §5c): cada papel reporta o footprint dos próprios documentos (KB da carga fixa do comando + KB de `roles/<papel>/`), o SM consolida na tabela por papel, e a proposta única do período pode ser uma **remoção**.
- **`/review history`** — apresenta o changelog do processo.
