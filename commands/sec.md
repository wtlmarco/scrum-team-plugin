---
description: Aciona o Security Engineer — pentest black/gray-box e secure code review white-box do sistema, sob demanda, com relatório de vulnerabilidades e plano de correção. Reporta, não corrige.
argument-hint: "[blackbox [escopo] | graybox [escopo] | whitebox [escopo]]"
---

Aciona o **Security Engineer** do time — engajamento de segurança profundo, **sob demanda** (fora da cadência do sprint).

Pedido do stakeholder: **$ARGUMENTS**

Antes de abrir uma instância nova, confira com ListAgents se já existe, nesta sessão, um agente `security-engineer` invocado há pouco sobre o mesmo engajamento; se existir, retome-o com SendMessage em vez de acionar o Agent de novo (R3). Só na ausência de um agente para retomar, use a ferramenta Agent com `subagent_type: "security-engineer"` (a chamada volta "lançado" e o resultado chega por aviso — dispare e encerre o turno, sem `Start-Sleep`) e, **se `.team-project/models.json` define o papel, `model: "<valor>"`** (`scripts/checks/models.ps1 -Role security-engineer` imprime o valor; a G17 nega outro), passando ao agente:

1. O pedido acima, literal.
2. O **modo** e o playbook correspondente em `${CLAUDE_PLUGIN_ROOT}/roles/security-engineer/playbooks/`:
   - **`blackbox [escopo]`** → `black-box.md` — atacante externo, só a superfície pública, sem código.
   - **`graybox [escopo]`** → `gray-box.md` — ataque dinâmico com contas de teste; toda falha confirmada com requisição/resposta reais.
   - **`whitebox [escopo]`** → `white-box.md` — revisão de segurança de código (source → sink), só leitura.
   - **sem modo** → peça ao stakeholder qual (os três cobrem superfícies diferentes).
3. Lembrete de limites: **a §1 (autorização por escrito) do `context.md` é pré-condição dura** — sem ela, o papel para e pede ao stakeholder; **só dados fictícios** (LGPD); **reporta, não corrige**; execução pesada vai ao `operator` (R28); teste dinâmico sem navegador é **não executado — sem ferramenta**.

O agente lê por conta própria `.team-project/README.md`, `.team-project/security-engineer/context.md` e os standards de segurança.

Registro de consumo: grave conforme `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/consumption.md` §Como gravar (o hook G16 mede o Security Engineer e o `operator` que ele chamou; a sessão roda o script).

Pergunta ou portão na forma de R22 → `AskUserQuestion` pela sessão (o agente não tem a ferramenta).

Ao receber o relatório, repasse ao stakeholder o sumário e o ponteiro do diretório (`.team-project/security/<data>/`). Para cada achado, indique o canal de volta pela seção "Roteamento" do relatório: achado de código → PO (`/qa bug` para crítico/alto, Product Backlog para o resto); achado de causa sistêmica (standard ausente/fraco) → `/review` (Arquiteto). O Security Engineer **não** fecha Task nem corrige.
