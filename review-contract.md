# Contrato do modo `review` — comum a todos os papéis

> Lido **apenas quando o comando entra no modo `review`**. Cada comando (`/sm`, `/po`, `/arc`, `/ux`, `/qa`) declara no seu próprio arquivo **o alcance daquele papel** e os **cuidados específicos** dele; o que está aqui vale para todos e não se repete lá.
>
> **Por que este arquivo existe:** o contrato do `review` ocupava 53–63% de cada arquivo de comando e era injetado no prompt em *toda* invocação, inclusive nas que nunca usam `review`. Movê-lo para cá troca esse custo fixo por uma leitura pontual no único modo que precisa dele.

## O que o `review` é

Todo papel aperfeiçoa **os próprios documentos** em `${CLAUDE_PLUGIN_ROOT}/` a partir de uma instrução do stakeholder. O processo não muda por conversa: muda pelo `review`.

O `/sm review` tem alcance maior que os demais: além do roteiro, das skills e dos modelos do papel, o SM é o único que altera os **normativos que governam todos** — `process/working-rules.md`, `process/workflow.md`, `process/artifact-ownership.md` — e é o **curador** do processo do time inteiro.

## Quatro passos, na ordem

1. **Classificar** a instrução — regra de trabalho, etapa de fluxo, cerimônia, propriedade de artefato, formato de documento, escopo de papel, ou comportamento de agente. A classificação decide qual documento muda.
2. **Analisar impacto e conflito** — quem passa a ser cobrado de forma diferente, e se a instrução contradiz alguma regra vigente. **Conflito não se resolve sozinho:** apresente as duas posições e pare para decisão do stakeholder.
3. **Aplicar** no documento certo, no formato que ele já usa. Regra nova recebe número na sequência (`R17`, `R18`…) e traz **o que evita** e **como o SM verifica** — regra sem verificação não entra.
4. **Registrar** em `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/process-changelog.md`, no formato de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/process-change.md`, com o indicador que provaria que a mudança funcionou.

## Reavaliação do conjunto — sempre

`review` não é só aplicar a instrução: é **reavaliar os documentos deste papel** à luz dela. Depois de aplicar — ou quando o comando vier **sem instrução**, caso em que a reavaliação é a entrega inteira — releia o roteiro, as skills, os modelos e o que mais estiver no alcance declarado pelo seu comando, e reporte:

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

Achado dentro do seu alcance: corrija e registre no changelog. Achado no documento de outro papel: **roteie**, não corrija.

## Limites — valem para todos

- **Só os documentos do seu alcance.** Instrução que toca outro papel é roteada: *"isso é do Arquiteto — use `/arc review`"*.
- **Normativo que governa todos** (regras de trabalho, fluxo, propriedade de artefatos) é exclusivo do **`/sm review`**.
- **Não altera `.team-project/`, o código, o quadro nem o backlog** — só o processo.
- **`agents/` e `commands/` são do stakeholder:** **proponha** com o texto pronto, não aplique.
- **O SM é o curador:** consolida o changelog, remove duplicidade, aponta contradição entre mudanças de papéis diferentes e leva ao stakeholder o que ficou inconsistente.
- **Mudança de comportamento de agente só entra em vigor após reiniciar a sessão** — diga isso ao stakeholder ao reportar.

## Modos auxiliares (só `/sm review`)

- **`review audit`** — coerência interna de `${CLAUDE_PLUGIN_ROOT}/`: regras contraditórias, regra sem verificação, papel com fronteira ambígua, documento sem dono, modelo órfão, vazamento de contexto de projeto, links quebrados.
- **`review metrics`** — revisão por evidência a partir dos indicadores do período, com **uma** proposta de mudança. Inclui o giro **Act** do ciclo de eficiência (`workflow.md` §5c): cada papel reporta o footprint dos próprios documentos (KB da carga fixa do comando + KB de `roles/<papel>/`), o SM consolida na tabela por papel, e a proposta única do período pode ser uma **remoção**.
- **`review history`** — apresenta o changelog do processo.
