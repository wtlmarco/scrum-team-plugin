---
description: Evolui o processo de trabalho do time — levanta as melhorias de note.md, classifica cada uma e roteia ao papel dono para aplicar. Só roda com o diretório atual dentro do clone-fonte do plugin.
argument-hint: "[<instrução> | note | audit | metrics | history] ou vazio para reavaliar o conjunto"
---

Evolui **o processo de trabalho do time** — os documentos versionados no **teu clone do repositório do plugin**. Substitui os antigos modos `review` de papel (`/sm review`, `/arc review`, …): agora há **um caminho só**.

Instrução do stakeholder: **$ARGUMENTS**

## Pré-condição — só no clone do repositório-fonte

`/review` edita os documentos de processo **no teu clone do repositório do plugin** e conta que a mudança seja commitada e propagada aos demais projetos por `claude plugin marketplace update` + `claude plugin update`. Ele **não** roda contra a cópia instalada (`${CLAUDE_PLUGIN_ROOT}`): em toda plataforma essa cópia é um snapshot descartável — sem `.git/`, sobrescrito no próximo `claude plugin update` — e no Windows nem existe forma de a instalação apontar para o working tree (o `mode: "link"` de plugin não é suportado).

Antes de qualquer coisa:

1. Descubra a raiz do clone a partir do diretório atual: `git rev-parse --show-toplevel`. Chame-a de **RAIZ**.
2. Confirme que **RAIZ** é o clone deste plugin — têm de existir todos:
   - `RAIZ/.git/`
   - `RAIZ/.claude-plugin/marketplace.json`, com campo `name` igual a `team`
   - `RAIZ/roles/scrum-master/process/workflow.md`

Se o `git rev-parse` falhar (diretório atual não está num repositório) ou faltar qualquer um desses, **pare**. Ao usuário, diga apenas:

> Comando não permitido nesse contexto. Entre em contato com o fornecedor do plugin.

Daqui em diante, todo caminho `RAIZ/…` é dentro desse clone. Ao disparar um agente de papel, passe o caminho absoluto de **RAIZ** — o agente herda o diretório atual, mas não deve depender disso.

## Modos

Identifique pelo primeiro termo. Sem termo, o modo é **reavaliação**.

| Modo | O que faz | Edita? |
|---|---|---|
| `/review` *(vazio)* | Reavaliação do conjunto de `RAIZ/` (coerência interna, aderência à prática, verificabilidade, cobertura de modelos, fronteiras, vazamento de contexto de projeto, obsolescência, excesso) **+** triagem de `RAIZ/note.md`: tabela `Task → classificação → documento-alvo → papel dono` | não |
| `/review <instrução>` | Trata a instrução como uma Task de melhoria: classifica, roteia ao dono, aplica, registra no changelog | sim |
| `/review note` | Processa a fila **Abertas** de `RAIZ/note.md`, uma Task por vez, roteando cada um como acima | sim |
| `/review audit` | Coerência interna de `RAIZ/`: regra contraditória, regra sem verificação, papel com fronteira ambígua, documento sem dono, modelo órfão, vazamento de contexto de projeto, link quebrado | não |
| `/review metrics` | Revisão por evidência a partir dos indicadores do período, com **uma** proposta de mudança; inclui o giro **Act** do ciclo de eficiência (`workflow.md` §5c) | sim (uma mudança) |
| `/review history` | Apresenta o changelog do processo | não |

## Como conduzir (`/review <instrução>` e `/review note`)

Este comando é **seu** — a sessão principal orquestra. A triagem e a curadoria são do **Agent `scrum-master`**; a edição de cada documento é do **agente do papel dono**.

1. **Triagem (Agent `scrum-master`).** Para cada Task, classifique — regra de trabalho · etapa de fluxo · cerimônia · propriedade de artefato · formato de documento · escopo de papel · comportamento de agente — e mapeie ao documento-alvo e ao papel dono:

   | Classificação | Documento-alvo | Quem aplica |
   |---|---|---|
   | regra / fluxo / propriedade de artefato / cerimônia | `RAIZ/roles/scrum-master/process/*` | Agent `scrum-master` |
   | roteiro, skills, templates de um papel, e os entregáveis que ele possui | `RAIZ/roles/<papel>/*`, `RAIZ/deliverables/*` do papel | agente daquele papel |
   | `RAIZ/standards/*` **e** os documentos do papel dev (`RAIZ/roles/developer/*`) | esses arquivos | Agent `architect` |
   | `RAIZ/agents/*`, `RAIZ/commands/*`, `RAIZ/.claude-plugin/*` e os guias de raiz — `RAIZ/{README,how-to,replicate-in-new-project,review-contract,team-init,team-update}.md` | — | **proposta ao stakeholder**, não aplicada. **Exceção do Agent `scrum-master`, válida para os quatro grupos igualmente**: coerência de referência cruzada (contagem, ponteiro, nome de modo, índice de estrutura) é curadoria, não reescrita, e ele aplica direto. A exceção **nunca** cobre mudança de comportamento de agente, texto de roteiro ou regra nova — isso continua proposta, nos quatro grupos, sem exceção |

   Conflito com regra vigente **não se resolve sozinho**: apresente as duas posições em `AskUserQuestion`, com a via de pedir mais contexto como última opção — não em texto corrido — e **pare** para decisão do stakeholder.

2. **Aplicação (agente do papel dono).** Dispare o agente dono com: a instrução literal; o caminho absoluto de **RAIZ**; a ordem de **ler `RAIZ/review-contract.md` e seguir os cinco passos** (classificar · analisar conflito · aplicar no documento certo · registrar no changelog · **verificar com evidência**, R19); e a reavaliação obrigatória do conjunto do alcance daquele papel. O alcance de cada papel está em `RAIZ/review-contract.md`.

3. **Curadoria (Agent `scrum-master`).** Ao final, o SM consolida o changelog, aponta contradição entre mudanças de papéis diferentes e escala ao stakeholder o que ficou inconsistente. `/review metrics` sempre considera **remover** algo.

4. **Fecho.** Task aplicado sai de `RAIZ/note.md` — passa a viver no changelog do processo. Mudança em `RAIZ/agents/`, `RAIZ/commands/` ou `RAIZ/.claude-plugin/` fica só como **proposta** com o texto pronto — exceto a coerência de referência cruzada da exceção do passo 1, que o Agent `scrum-master` já aplicou direto. Diga ao stakeholder o que mudou e onde, quais papéis passam a ser cobrados de forma diferente, que a mudança só chega aos outros projetos após `git commit` + `git push` + `claude plugin marketplace update team` + `claude plugin update team@team`, e que mudança de comportamento de agente **só entra em vigor após reiniciar a sessão**.

## Limites

- **Só os documentos de `RAIZ/`.** `/review` não toca `.team-project/`, o código, o quadro nem o backlog.
- **`/review` nunca grava linha no registro de consumo do time.** Esse registro (`sprints/<n>/consumption.md`) só existe em projeto que instala o time, dentro de `.team-project/`; `RAIZ/` — o clone-fonte do plugin, onde `/review` roda — não tem `.team-project/`. Os agentes disparados por `/review` são o Agent `<papel>` direto, não os comandos `/sm`/`/po`/`/arc`/`/ux`/`/qa`/`/dev` — a instrução de gravação vive nesses comandos, não aqui.
- **Normativo que governa todos** (regras de trabalho, fluxo, propriedade de artefatos) é do **Agent `scrum-master`** — nenhum outro papel edita.
- **`RAIZ/agents/` e `RAIZ/commands/` são do stakeholder** — propor com o texto pronto, não aplicar.
- **O dev não edita os próprios normativos** — o Agent `architect` aplica as mudanças em `RAIZ/roles/developer/*`, usando os 🔺 GAPs e as seções "Não fiz" dos relatórios como evidência.
