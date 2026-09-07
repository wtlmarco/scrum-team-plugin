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

Se o `git rev-parse` falhar (diretório atual não está num repositório) ou faltar qualquer um desses, **pare** e diga: `/review` evolui o processo e precisa rodar com o diretório atual **dentro do teu clone do repositório do plugin** (`scrum-team-plugin`). De lá a mudança é commitada e chega aos demais projetos por `claude plugin marketplace update` + `claude plugin update`. Num projeto que só consome o plugin não há o que editar — a cópia instalada é sobrescrita no próximo update, e a mudança se perde.

Daqui em diante, todo caminho `RAIZ/…` é dentro desse clone. Ao disparar um agente de papel, passe o caminho absoluto de **RAIZ** — o agente herda o diretório atual, mas não deve depender disso.

## Modos

Identifique pelo primeiro termo. Sem termo, o modo é **reavaliação**.

| Modo | O que faz | Edita? |
|---|---|---|
| `/review` *(vazio)* | Reavaliação do conjunto de `RAIZ/` (coerência interna, aderência à prática, verificabilidade, cobertura de modelos, fronteiras, vazamento de contexto de projeto, obsolescência, excesso) **+** triagem de `RAIZ/note.md`: tabela `item → classificação → documento-alvo → papel dono` | não |
| `/review <instrução>` | Trata a instrução como um item de melhoria: classifica, roteia ao dono, aplica, registra no changelog | sim |
| `/review note` | Processa a fila **Abertas** de `RAIZ/note.md`, um item por vez, roteando cada um como acima | sim |
| `/review audit` | Coerência interna de `RAIZ/`: regra contraditória, regra sem verificação, papel com fronteira ambígua, documento sem dono, modelo órfão, vazamento de contexto de projeto, link quebrado | não |
| `/review metrics` | Revisão por evidência a partir dos indicadores do período, com **uma** proposta de mudança; inclui o giro **Act** do ciclo de eficiência (`workflow.md` §5c) | sim (uma mudança) |
| `/review history` | Apresenta o changelog do processo | não |

## Como conduzir (`/review <instrução>` e `/review note`)

Este comando é **seu** — a sessão principal orquestra. A triagem e a curadoria são do **Agent `scrum-master`**; a edição de cada documento é do **agente do papel dono**.

1. **Triagem (Agent `scrum-master`).** Para cada item, classifique — regra de trabalho · etapa de fluxo · cerimônia · propriedade de artefato · formato de documento · escopo de papel · comportamento de agente — e mapeie ao documento-alvo e ao papel dono:

   | Classificação | Documento-alvo | Quem aplica |
   |---|---|---|
   | regra / fluxo / propriedade de artefato / cerimônia | `RAIZ/roles/scrum-master/process/*` | Agent `scrum-master` |
   | roteiro, skills, templates de um papel, e os entregáveis que ele possui | `RAIZ/roles/<papel>/*`, `RAIZ/deliverables/*` do papel | agente daquele papel |
   | `RAIZ/standards/*` **e** os documentos do papel dev (`RAIZ/roles/developer/*`) | esses arquivos | Agent `architect` |
   | `RAIZ/agents/*`, `RAIZ/commands/*`, `RAIZ/.claude-plugin/*` | — | **proposta ao stakeholder**, não aplicada |

   Conflito com regra vigente **não se resolve sozinho**: apresente as duas posições e **pare** para decisão do stakeholder.

2. **Aplicação (agente do papel dono).** Dispare o agente dono com: a instrução literal; o caminho absoluto de **RAIZ**; a ordem de **ler `RAIZ/review-contract.md` e seguir os cinco passos** (classificar · analisar conflito · aplicar no documento certo · registrar no changelog); e a reavaliação obrigatória do conjunto do alcance daquele papel. O alcance de cada papel está em `RAIZ/review-contract.md`.

3. **Curadoria (Agent `scrum-master`).** Ao final, o SM consolida o changelog, aponta contradição entre mudanças de papéis diferentes e escala ao stakeholder o que ficou inconsistente. `/review metrics` sempre considera **remover** algo.

4. **Fecho.** Item aplicado sai de `RAIZ/note.md` — passa a viver no changelog do processo. Mudança em `RAIZ/agents/`, `RAIZ/commands/` ou `RAIZ/.claude-plugin/` fica só como **proposta** com o texto pronto. Diga ao stakeholder o que mudou e onde, quais papéis passam a ser cobrados de forma diferente, que a mudança só chega aos outros projetos após `git commit` + `git push` + `claude plugin marketplace update team` + `claude plugin update team@team`, e que mudança de comportamento de agente **só entra em vigor após reiniciar a sessão**.

## Limites

- **Só os documentos de `RAIZ/`.** `/review` não toca `.team-project/`, o código, o quadro nem o backlog.
- **Normativo que governa todos** (regras de trabalho, fluxo, propriedade de artefatos) é do **Agent `scrum-master`** — nenhum outro papel edita.
- **`RAIZ/agents/` e `RAIZ/commands/` são do stakeholder** — propor com o texto pronto, não aplicar.
- **O dev não edita os próprios normativos** — o Agent `architect` aplica as mudanças em `RAIZ/roles/developer/*`, usando os 🔺 GAPs e as seções "Não fiz" dos relatórios como evidência.
