---
description: Evolui o processo de trabalho do time — levanta as melhorias de note.md, classifica cada uma e roteia ao papel dono para aplicar. Só roda no repositório-fonte do plugin.
argument-hint: "[<instrução> | note | audit | metrics | history] ou vazio para reavaliar o conjunto"
---

Evolui **o processo de trabalho do time** — os documentos em `${CLAUDE_PLUGIN_ROOT}/`. Substitui os antigos modos `review` de papel (`/sm review`, `/arc review`, …): agora há **um caminho só**.

Instrução do stakeholder: **$ARGUMENTS**

## Pré-condição — só no repositório-fonte

Antes de qualquer coisa, confirme que `${CLAUDE_PLUGIN_ROOT}` é um **clone do repositório do plugin**, não a cópia instalada: têm de existir `${CLAUDE_PLUGIN_ROOT}/.git/` **e** `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/marketplace.json`.

Se faltar qualquer um, **pare** e diga: `/review` evolui o processo e precisa rodar contra o clone do repositório do plugin, onde a mudança é commitada e chega aos demais projetos por `claude plugin marketplace update` + `claude plugin update`. A cópia instalada num projeto é descartável — o próximo `claude plugin update` a sobrescreve, e a mudança se perde.

## Modos

Identifique pelo primeiro termo. Sem termo, o modo é **reavaliação**.

| Modo | O que faz | Edita? |
|---|---|---|
| `/review` *(vazio)* | Reavaliação do conjunto de `${CLAUDE_PLUGIN_ROOT}/` (coerência interna, aderência à prática, verificabilidade, cobertura de modelos, fronteiras, vazamento de contexto de projeto, obsolescência, excesso) **+** triagem de `${CLAUDE_PLUGIN_ROOT}/note.md`: tabela `item → classificação → documento-alvo → papel dono` | não |
| `/review <instrução>` | Trata a instrução como um item de melhoria: classifica, roteia ao dono, aplica, registra no changelog | sim |
| `/review note` | Processa a fila **Abertas** de `note.md`, um item por vez, roteando cada um como acima | sim |
| `/review audit` | Coerência interna de `${CLAUDE_PLUGIN_ROOT}/`: regra contraditória, regra sem verificação, papel com fronteira ambígua, documento sem dono, modelo órfão, vazamento de contexto de projeto, link quebrado | não |
| `/review metrics` | Revisão por evidência a partir dos indicadores do período, com **uma** proposta de mudança; inclui o giro **Act** do ciclo de eficiência (`workflow.md` §5c) | sim (uma mudança) |
| `/review history` | Apresenta o changelog do processo | não |

## Como conduzir (`/review <instrução>` e `/review note`)

Este comando é **seu** — a sessão principal orquestra. A triagem e a curadoria são do **Agent `scrum-master`**; a edição de cada documento é do **agente do papel dono**.

1. **Triagem (Agent `scrum-master`).** Para cada item, classifique — regra de trabalho · etapa de fluxo · cerimônia · propriedade de artefato · formato de documento · escopo de papel · comportamento de agente — e mapeie ao documento-alvo e ao papel dono:

   | Classificação | Documento-alvo | Quem aplica |
   |---|---|---|
   | regra / fluxo / propriedade de artefato / cerimônia | `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/*` | Agent `scrum-master` |
   | roteiro, skills, templates de um papel, e os entregáveis que ele possui | `roles/<papel>/*`, `deliverables/*` do papel | agente daquele papel |
   | `standards/*` **e** os documentos do papel dev (`roles/developer/*`) | esses arquivos | Agent `architect` |
   | `agents/*`, `commands/*`, `.claude-plugin/*` | — | **proposta ao stakeholder**, não aplicada |

   Conflito com regra vigente **não se resolve sozinho**: apresente as duas posições e **pare** para decisão do stakeholder.

2. **Aplicação (agente do papel dono).** Dispare o agente dono com: a instrução literal; a ordem de **ler `${CLAUDE_PLUGIN_ROOT}/review-contract.md` e seguir os quatro passos** (classificar · analisar conflito · aplicar no documento certo · registrar no changelog); e a reavaliação obrigatória do conjunto do alcance daquele papel. O alcance de cada papel está em `review-contract.md`.

3. **Curadoria (Agent `scrum-master`).** Ao final, o SM consolida o changelog, aponta contradição entre mudanças de papéis diferentes e escala ao stakeholder o que ficou inconsistente. `/review metrics` sempre considera **remover** algo.

4. **Fecho.** Item aplicado sai de `note.md` — passa a viver no changelog do processo. Mudança em `agents/`, `commands/` ou `.claude-plugin/` fica só como **proposta** com o texto pronto. Diga ao stakeholder o que mudou e onde, quais papéis passam a ser cobrados de forma diferente, e que mudança de comportamento de agente **só entra em vigor após reiniciar a sessão**.

## Limites

- **Só os documentos de `${CLAUDE_PLUGIN_ROOT}/`.** `/review` não toca `.team-project/`, o código, o quadro nem o backlog.
- **Normativo que governa todos** (regras de trabalho, fluxo, propriedade de artefatos) é do **Agent `scrum-master`** — nenhum outro papel edita.
- **`agents/` e `commands/` são do stakeholder** — propor com o texto pronto, não aplicar.
- **O dev não edita os próprios normativos** — o Agent `architect` aplica as mudanças em `roles/developer/*`, usando os 🔺 GAPs e as seções "Não fiz" dos relatórios como evidência.
