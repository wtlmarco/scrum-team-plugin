---
description: Ciclo de vida do time no projeto — instala (`init`), atualiza (`update`) ou informa a versão (`version`). Não dispara agente. A descoberta é `/sm brainstorm`, a construção do sprint é `/sm sprint run`; mensagem solta é roteada ao papel dono.
argument-hint: "init | update | version"
---

Cuida **do time no projeto**: instala, atualiza e informa a versão. **Não dispara agente nenhum.** Mensagem do stakeholder: **$ARGUMENTS**

> **Este comando não é um canal de conversa.** O canal do stakeholder é o **PO** ([`workflow.md` §6a](../roles/scrum-master/process/workflow.md)). Aqui só se **instala** (`init`), **atualiza** (`update`) ou **informa a versão** (`version`). O resto migrou para o `/sm`: descoberta de ideia é `/sm brainstorm <ideia>`; a cadência do sprint é `/sm sprint prepare` → `plan` → `run` → `review` → `close`.

Identifique o modo pelo primeiro termo. **Sem termo reconhecido, não dispare agente nenhum** — roteie, conforme a tabela ao final.

## Modos — leia só o arquivo do modo

- **`init`** — instalar o time neste projeto: **leia `${CLAUDE_PLUGIN_ROOT}/rituals/team-init.md` e siga-o** (cinco passos; conversa com o stakeholder; roda uma vez por projeto).
- **`update`** — atualizar o plugin neste projeto: **leia `${CLAUDE_PLUGIN_ROOT}/rituals/team-update.md` e siga-o** (nove passos, incluindo a reconciliação do `.team-project/` no passo 8; uma vez por bump de versão).
- **`version`** — que versão está rodando: **leia `${CLAUDE_PLUGIN_ROOT}/rituals/team-version.md` e siga-o**. Não usa rede; quem verifica versão nova é o `update`.

## Sem modo reconhecido — roteie, não dispare

**Não existe broadcast:** `/team` não fala com os seis papéis. Responda com a rota, em uma linha, sem pedir permissão:

| O que o stakeholder trouxe | Rota |
|---|---|
| demanda, valor, escopo, prioridade, **prazo**, **status**, plano de entrega | **`/po`** |
| dúvida técnica, desenho, contrato, dívida | `/arc question <dúvida>` |
| jornada, tela, usabilidade, acessibilidade | `/ux` |
| questão que atravessa papéis e precisa de **uma** posição | `/sm agreement <questão>` |
| preparar, planejar, construir, revisar ou encerrar um sprint | `/sm sprint prepare \| plan \| run \| review \| close` |
| ideia sem cobertura em visão geral / requisitos / fluxos | `/sm brainstorm <ideia>` (R15) |

## Regras

- **Nenhum modo dispara agente**; por isso não há linha de consumo nem retentativa aqui (R27 e o registro vivem nos modos do `/sm`). Consulta e roteamento **não escrevem em disco**.
- Nenhuma afirmação de "funciona" sem saída real de comando; o que não foi exercitado é declarado como tal.
- Pergunta ao stakeholder em `init`/`update` → `AskUserQuestion` pela sessão, "pedir mais contexto" por último (`working-rules.md` R22).

Ao final, repasse a consolidação, o que exige decisão do stakeholder e a próxima ação recomendada.
