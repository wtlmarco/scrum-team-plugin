# Contrato do `/review` — evolução do processo

> Lido **quando `/review` roteia um item ao agente de um papel**. O comando `/review` está em [`commands/review.md`](commands/review.md); aqui está o que o **agente** faz ao receber o item. Vive fora dos arquivos de comando de papel para não ser injetado nas invocações que nunca evoluem o processo.
>
> **Todo caminho deste contrato é relativo à RAIZ** — o clone do repositório do plugin, cujo caminho absoluto o `/review` te passa ao te acionar ([`commands/review.md`](commands/review.md) §pré-condição). **Nunca escreva em `${CLAUDE_PLUGIN_ROOT}`:** essa é a cópia *instalada*, um snapshot descartável que o próximo `claude plugin update` sobrescreve — mudança feita lá se perde. Se não recebeu a RAIZ, **pare e peça**; não deduza do diretório atual.

## O que o `/review` é

O processo de trabalho do time — os documentos em `RAIZ/` — **não muda por conversa**: muda pelo `/review`. Cada papel aperfeiçoa **os próprios documentos** a partir de uma instrução do stakeholder ou de um item de `note.md` que o SM classificou e roteou.

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

## Cinco passos, na ordem

1. **Classificar** a instrução — regra de trabalho, etapa de fluxo, cerimônia, propriedade de artefato, formato de documento, escopo de papel, ou comportamento de agente. A classificação decide qual documento muda.
2. **Analisar impacto e conflito** — quem passa a ser cobrado de forma diferente, e se a instrução contradiz alguma regra vigente. **Conflito não se resolve sozinho:** apresente as duas posições e pare para decisão do stakeholder.
3. **Aplicar** no documento certo, no formato que ele já usa. Regra nova recebe número na sequência (`R18`, `R19`…) e traz **o que evita** e **como o SM verifica** — regra sem verificação não entra.
4. **Registrar** em `RAIZ/roles/scrum-master/process/process-changelog.md`, no formato de `RAIZ/roles/scrum-master/templates/process-change.md`, com o indicador que provaria que a mudança funcionou.
5. **Verificar** o que você aplicou, e anexar o **bloco de evidência** à entrada (R19). Para cada classe de mudança, o comando e a saída — não a afirmação de que foi feito:

   | Classe | Evidência mínima | Esperado |
   |---|---|---|
   | Arquivamento de entrada | `diff` da entrada movida contra a versão que saiu | zero linhas fora do separador |
   | Substituição de padrão | `grep` do padrão antigo **em todos os arquivos da classe**, não só no primeiro; **mais a leitura de cada ocorrência nova no contexto** | zero do antigo; e cada ocorrência nova coerente com o que está ao lado dela |
   | Extração ou remoção | contagem de linhas antes/depois nos dois arquivos | o ponteiro que substituiu o texto movido resolve |

   **`grep` zerado não é substituição completa.** Ele prova que a string sumiu, não que o sentido fechou: trocar "quatro passos" por "cinco passos" e deixar ao lado a enumeração com quatro itens passa no `grep` e mente para quem lê. Toda substituição de padrão exige **ler cada ocorrência nova no contexto** e conferir o que depende dela — contagem enumerada, lista adjacente, total citado noutro documento.

   Anote o resultado no bloco `### Evidência (R19)` da entrada, no formato de `RAIZ/roles/scrum-master/templates/process-change.md` (`Classe · Comando · Saída · Ok?`). Saída diferente da esperada: **conserte antes de fechar**, e registre o desvio na entrada. Não reporte ao stakeholder como aplicado o que a evidência não confirma.

## Reavaliação do conjunto — sempre

`/review` não é só aplicar a instrução: é **reavaliar os documentos do alcance do papel** à luz dela. Depois de aplicar — ou quando `/review` vier **sem instrução**, caso em que a reavaliação é a entrega inteira — releia o roteiro, as skills, os modelos e o que mais estiver no alcance, e reporte:

| Verificação | O que procurar |
|---|---|
| Coerência interna | Dois documentos do papel que se contradizem |
| Aderência à prática | Roteiro que descreve o que o papel já não faz, ou omite o que ele faz |
| Verificabilidade | Critério, regra ou controle sem forma de verificação |
| Cobertura de modelos | Modelo que ninguém referencia; documento produzido sem modelo |
| Fronteiras | Responsabilidade que se sobrepõe à de outro papel |
| Vazamento de contexto | Nome de produto, stack ou caminho de projeto dentro de `RAIZ/`, que é genérico |
| Obsolescência | Seção que cita comando, papel ou documento que mudou de nome ou deixou de existir |
| Excesso | O que dá para **remover** — processo que só cresce deixa de ser seguido |

Achado dentro do seu alcance: corrija e registre no changelog. Achado no documento de outro papel: **devolva ao SM para rotear**, não corrija.

## Limites — valem para todos

- **Só os documentos do seu alcance.** Instrução que toca outro papel volta ao SM: *"isso é do Arquiteto"*.
- **Normativo que governa todos** (regras de trabalho, fluxo, propriedade de artefatos) é exclusivo do **Agent `scrum-master`**.
- **Não altera `.team-project/`, o código, o quadro nem o backlog** — só o processo.
- **`agents/`, `commands/`, `.claude-plugin/` e os guias de raiz são do stakeholder** (`README.md`, `how-to.md`, `replicate-in-new-project.md`, `review-contract.md`, `team-init.md`, `team-update.md`): **proponha** com o texto pronto, não aplique. Exceção do SM: manter **coerência de referência cruzada** nesses arquivos — contagem, ponteiro, nome de modo, índice de estrutura — é curadoria, não reescrita, e ele aplica.
- **O SM é o curador:** consolida o changelog, remove duplicidade, aponta contradição entre mudanças de papéis diferentes e leva ao stakeholder o que ficou inconsistente.
- **Mudança de comportamento de agente só entra em vigor após reiniciar a sessão** — diga isso ao stakeholder ao reportar.

## Modos auxiliares (conduzidos pelo Agent `scrum-master`)

- **`/review note`** — processa a fila **Abertas** de `RAIZ/note.md`, um item por vez: o SM classifica e roteia cada um ao papel dono, que aplica por este contrato. Item aplicado sai de `note.md` e passa a viver no changelog do processo.
- **`/review audit`** — coerência interna de `RAIZ/`: regras contraditórias, regra sem verificação, papel com fronteira ambígua, documento sem dono, modelo órfão, vazamento de contexto de projeto, links quebrados.
- **`/review metrics`** — revisão por evidência a partir dos indicadores do período, com **uma** proposta de mudança. Inclui o giro **Act** do ciclo de eficiência (`workflow.md` §5c): cada papel reporta o footprint dos próprios documentos (KB da carga fixa do comando + KB de `roles/<papel>/`), o SM consolida na tabela por papel, e a proposta única do período pode ser uma **remoção**.
- **`/review history`** — apresenta o changelog do processo.
