# Plano de Implementação — Papel Security Engineer (`/sec`)

> **Escrito para:** você (autor do plugin), como insumo de aprovação, e para quem for construir o papel depois (eu ou o Arquiteto via `/review`). Nada aqui é commitado ou aberto em PR sem seu pedido.

**Decisões do stakeholder (2026-11-12, `AskUserQuestion`):**
- **Nome:** Security Engineer · comando `/sec` · agente `security-engineer`.
- **Natureza:** papel do time (como QA/Arquiteto), **acionado sob demanda** — fora da cadência do sprint, nunca auto-disparado no `sprint run`. Não é um dos seis papéis dos rituais (onboarding/sdd/planning/run/review).
- **Escopo:** playbooks **genéricos**, parametrizados pelo projeto-alvo em `.team-project/security-engineer/context.md`. Sem esse arquivo, o papel para e pede ao stakeholder.

**Origem:** os três documentos `melhorias/PromptPenTest{BlackBox,GrayBox,WhiteBox}.md`, hoje cravados no projeto `marcador-next`.

---

## 1. Objetivo e fora de escopo

Depois desta entrega, o time passa a ter um **engajamento de segurança profundo acionável sob demanda** — pentest (black/gray-box) e secure code review (white-box) —, dono do escopo autorizado, das fases e do relatório, que **reporta e não corrige** (achados voltam ao time pelos canais existentes). O papel reusa toda a mecânica do time: execução pesada pelo `operator` (R28), navegador para teste dinâmico, relatório no projeto (nunca em `${CLAUDE_PLUGIN_ROOT}`, G2).

A entrega inclui ainda o **laço shift-left** (§8): a prática de segurança não vive só no teste que acha a falha — ela desce para os **standards do Arquiteto**, para que plano de código e arquitetura já nasçam atendendo aos princípios que o pentest validaria. Este plano traz a **análise de lacuna** dos documentos atuais e a recomendação de complemento.

**Fora do escopo:**
- **Não** altera o QA: a frente 3 e `/qa security <ID>` continuam como checagem leve por Task, no portão. O Security Engineer é o engajamento profundo; os dois não se sobrepõem (§7).
- **Não** renumera os "seis papéis" dos rituais nem entra em `onboarding/sdd/sprint`. É papel à parte, sob demanda.
- **Não** executa correção de vulnerabilidade — isso é Task futura do dev/Arquiteto, por fora deste plano.
- **Não** cria scripts de verificação novos em `scripts/checks/` (o papel produz relatório em Markdown; sem gate automatizado nesta entrega).

---

## 2. Fronteira com o QA (resolvida antes dos passos)

| | QA — frente 3 / `/qa security <ID>` | Security Engineer — `/sec` |
|---|---|---|
| Quando | A cada Task, no portão de qualidade | Sob demanda, fora da cadência |
| Profundidade | Checklist do `context.md`, por diff da Task | Pentest completo / secure code review do sistema |
| Saída | Linha no veredito da Task | Diretório de relatório (`.team-project/security/<data>/`) |
| Dados | Checklist de 8 itens (skills.md §7) | OWASP Top 10, API Top 10, CVSS 4.0, fases 1–11 |

**Roteamento de achado (decisão a confirmar — §7):** o Security Engineer **reporta**; não escreve `pending.md` (é do QA). Proposta: **crítico/alto** → o papel sinaliza ao PO, que classifica como defeito e aciona `/qa bug` (entra em `pending.md` com evidência confirmada, fluxo existente); **médio/baixo/informativo** → item do Product Backlog do PO. Achado que é defeito de **standard** do plugin → `/review`. O relatório é a fonte; a entrada no quadro segue os canais do time.

---

## 3. Arquivos — lista fechada

### A criar
| Caminho | O quê |
|---|---|
| `agents/security-engineer.md` | Definição do agente (frontmatter + roteiro curto) |
| `commands/sec.md` | Comando `/sec`, roteia os três modos |
| `roles/security-engineer/README.md` | Roteiro de Atuação do papel |
| `roles/security-engineer/skills.md` | Competências transferíveis |
| `roles/security-engineer/playbooks/black-box.md` | `PromptPenTestBlackBox.md` generalizado |
| `roles/security-engineer/playbooks/gray-box.md` | `PromptPenTestGrayBox.md` generalizado |
| `roles/security-engineer/playbooks/white-box.md` | `PromptPenTestWhiteBox.md` generalizado |
| `roles/security-engineer/templates/security-report.md` | Formato do relatório e de cada achado |
| `roles/security-engineer/templates/context.md` | Modelo do `.team-project/security-engineer/context.md` (parametrização do projeto-alvo) |

### A alterar (pontos de registro)
| Caminho | Mudança |
|---|---|
| `.claude-plugin/plugin.json` | Acrescentar `/sec` à lista de comandos da `description` |
| `.claude-plugin/marketplace.json` | Idem na `description` do plugin |
| `README.md` | Linha do papel na tabela "O time" (§94–103) + linha `/sec` no bloco "Comandos" (§107–116) + o conector do `commands/` (§27) |
| `how-to.md` | Entrada do `/sec` onde os comandos são listados (ver `/qa`, §458) |
| `standards/implementation-security-lgpd-copyright.md` | Ponteiro cruzado: o normativo cita o papel como consumidor (confirmar na escrita) |

### A criar/complementar — standards do Arquiteto (shift-left, detalhe em §8)
| Caminho | Mudança |
|---|---|
| `standards/implementation-appsec-web-api.md` *(novo, transversal)* | Controles de superfície web/API que hoje faltam: validação de entrada e injeção, token na borda, CORS, cabeçalhos/HSTS, rate limiting e anti-enumeração, mass assignment, exposição excessiva, SSRF, open redirect, desserialização, erros sem vazamento, SCA/plataforma |
| `standards/stacks/dotnet/guide.md` | Pipeline de segurança no `Startup`/`Program`: config de validação JWT, CORS, HSTS/cabeçalhos, rate limiting; consulta parametrizada/EF (sem `FromSqlRaw` interpolado); erro sem stack trace em produção |
| `standards/stacks/react/{guide,quality,pitfalls}.md` | Proibir `dangerouslySetInnerHTML` sem sanitização; `GENERATE_SOURCEMAP=false` em produção; linha de verificação de SCA (`npm audit`) na `quality.md` |
| `roles/architect/templates/implementation-plan.md` §10 | Estender o checklist de segurança do plano com os controles novos |
| `roles/quality-assurance/skills.md` §7 + modelo de `context.md` do QA | Estender o checklist de segurança do portão para casar com o §10 |

### A mover/arquivar
| Caminho | Mudança |
|---|---|
| `melhorias/PromptPenTest{BlackBox,GrayBox,WhiteBox}.md` | Movidos e generalizados para `roles/security-engineer/playbooks/`. Os originais saem de `melhorias/` (pasta de ideias) — este plano fica no lugar deles como registro. |

---

## 4. Passos, em ordem

### Passo 1 — `agents/security-engineer.md`
Espelhar `agents/quality-assurance.md`. Frontmatter:
```yaml
---
name: security-engineer
description: Security Engineer. Engajamento de segurança profundo acionado sob demanda — pentest black/gray-box e secure code review white-box do sistema. Dono do escopo autorizado, das fases e do relatório; reporta e não corrige. Lê o alvo, a stack, as contas e a autorização de .team-project/security-engineer/context.md. Use para auditoria de segurança, pentest ou revisão de segurança de código — a checagem leve por Task continua no QA (frente 3).
tools: Read, Grep, Glob, Write, Edit, PowerShell, ToolSearch, Agent, mcp__claude-in-chrome
model: sonnet
---
```
**Corpo** (curto, no padrão do agente QA):
- Missão e os três modos (black/gray/white), cada um apontando o playbook em `${CLAUDE_PLUGIN_ROOT}/roles/security-engineer/playbooks/`.
- **Pré-condição dura:** lê `.team-project/security-engineer/context.md`; ausente → para e pede ao stakeholder (como o QA sem `.team-project/`). A **autorização por escrito** (escopo, quem autorizou, data) é pré-requisito — sem ela, não executa.
- Execução pesada (ZAP/Nuclei/nmap/`npm audit`/SAST) → `operator` (R28), linha `Chamador: sec <modo>`; disparo assíncrono, encerra o turno.
- Dinâmico (black/gray) → navegador (`mcp__claude-in-chrome`); sem a extensão → ⚠️ "não executado — sem ferramenta".
- **Reporta, não corrige.** Achado com evidência (`arquivo:linha` no white-box; requisição/resposta no black/gray). Relatório em `.team-project/security/<data>/`; nunca em `${CLAUDE_PLUGIN_ROOT}` (G2).
- Modelo por `.team-project/models.json` se definido (G17).

**Conferência:** o arquivo existe, frontmatter com os 5 campos, `tools` inclui `mcp__claude-in-chrome` e `Agent`, corpo cita os três playbooks por caminho `${CLAUDE_PLUGIN_ROOT}/...`.

### Passo 2 — `commands/sec.md`
Espelhar `commands/qa.md`. Frontmatter:
```yaml
---
description: Aciona o Security Engineer — pentest black/gray-box e secure code review white-box do sistema, sob demanda, com relatório de vulnerabilidades e plano de correção. Reporta, não corrige.
argument-hint: "[blackbox [escopo] | graybox [escopo] | whitebox [escopo]]"
---
```
**Corpo:** aciona o agente `security-engineer` passando (1) o pedido literal, (2) o modo escolhido → o playbook correspondente, (3) o lembrete de limites (autorização obrigatória, LGPD, reporta-não-corrige). Checagem `ListAgents`/R3 antes de abrir instância nova. `model` de `models.json` se definido (G17). Disparo assíncrono (encerra o turno, v3.52.2). Ao receber o relatório, repassa ao stakeholder e indica o roteamento de cada achado (§2).

**Conferência:** frontmatter com `description` e `argument-hint`; corpo roteia os três modos e cita o agente por `subagent_type: "security-engineer"`.

### Passo 3 — `roles/security-engineer/templates/context.md`
Modelo do arquivo de projeto `.team-project/security-engineer/context.md`, com os campos que generalizam os playbooks:
```markdown
# Security Engineer — Contexto do projeto <nome>

## 1. Autorização (pré-requisito — sem isto o papel não executa)
- **Escopo autorizado por escrito:** <domínios/URLs/repos> · **Autorizado por:** <nome/papel> · **Data:** <AAAA-MM-DD>
- **Fora de escopo:** <terceiros, infra de hospedagem, CDN, hosts não listados>

## 2. Alvo e superfície
- **Front-end:** <URL(s) e ambientes>
- **API:** <URL(s) autorizadas; porta dev>
- **Repositórios (white-box):** <caminhos; read-only>

## 3. Stack
- **Back-end:** <linguagem/framework/versão> · **Front-end:** <idem>

## 4. Autenticação
- **Esquema do token:** <ex.: header X-Authorization, JWT> · **Fluxos:** <login, recuperação, confirmação>

## 5. Contas de teste (ao menos duas, papéis diferentes)
- <usuário A — papel> · <usuário B — papel> · **Credenciais:** <ponteiro para cofre; nunca em claro aqui>

## 6. Dados sensíveis e conformidade
- **Natureza:** <saúde, financeiro, pessoal> · **Regime:** <LGPD/outro> · **Proibições:** só dados fictícios; nunca acessar/copiar dado real

## 7. Ferramentas disponíveis no ambiente
- <ZAP, Burp, Nmap, Nuclei, testssl.sh, WhatWeb, npm audit, dotnet analyzers — as que existem>

## 8. Saída
- **Relatório em:** .team-project/security/<data>/
```
**Conferência:** cobre cada parâmetro que os playbooks deixam de cravar (§4, passo 5).

### Passo 4 — `roles/security-engineer/templates/security-report.md`
Consolidar o formato de relatório dos três playbooks (hoje divergem: `external-pentest-report/`, `graybox-pentest-report/`, `whitebox-review-report/`). Um template com: índice de arquivos por modo, e o **formato por achado** unificado — `SEC-NNN — Nome`, Severidade (CVSS 4.0), Alvo/Localização, Descrição, Descoberta, **Evidência** (requisição/resposta sanitizada **ou** `arquivo:linha` + trecho), Exploração (não destrutiva), Impacto, Correção, Referências (OWASP/CWE), **Confiança** (confirmada/provável/indício/falso positivo). Plano de correção P0–P3.

**Conferência:** o formato por achado serve aos três modos; campos de evidência cobrem dinâmica e estática.

### Passo 5 — Playbooks generalizados (`playbooks/{black,gray,white}-box.md`)
Mover os três `melhorias/PromptPenTest*.md` e **substituir o que é do `marcador-next` por referência ao `context.md`**. Regra de generalização, item a item:

| Hoje cravado no playbook | Vira |
|---|---|
| `http://localhost:3000`, `:5333`, `:53511`, `marcador-next-api/app` | "o alvo do `context.md` §2" |
| `C:\app\marcador-next-api`, `C:\app\marcador-next-app` | "os repositórios do `context.md` §2 (white-box)" |
| header `X-Authorization`, `JwtBearer` | "o esquema de auth do `context.md` §4" |
| ASP.NET Core 2.0, React/Redux-Saga, webpack 4 | "a stack do `context.md` §3" |
| LGPD / dados de saúde | "os dados sensíveis e o regime do `context.md` §6" |
| rotas de exemplo (`/professional/{id}`, `/user/main-profile`, `995`) | manter como **exemplo ilustrativo** ("por exemplo, …"), não como alvo real |
| `*.eyeclinic.com.br` | "qualquer API de terceiro fora do escopo autorizado" |

Mantém-se **íntegra** a metodologia (fases, OWASP, CVSS, regras operacionais, LGPD como princípio, "nunca declare seguro", "reporta não corrige"). Cada playbook abre com: "Leia `.team-project/security-engineer/context.md`; se não existir ou a autorização (§1) estiver vazia, pare e peça ao stakeholder."

**Conferência:** `grep` por `marcador|eyeclinic|5333|53511|localhost:3000|C:\\app\\` nos três playbooks → 0 ocorrências como alvo (exemplos ilustrativos explícitos permitidos); cada playbook cita o `context.md`.

### Passo 6 — `roles/security-engineer/README.md` e `skills.md`
README no padrão do `roles/quality-assurance/README.md`: tabela "O que respondo" (Responde por / Entradas / Saídas / Escreve / Não faz / Escala para), os três modos, a fronteira com o QA (§2 deste plano), o roteamento de achados. `skills.md`: competências transferíveis (executar-não-acreditar reusado do QA §1; autorização e LGPD como porta; distinção confirmada×provável; delegação ao `operator`).

**Conferência:** README cita o agente, o comando e o `context.md`; "Não faz" lista corrigir código e escrever `pending.md`.

### Passo 7 — Registros (§3 "a alterar")
- `plugin.json` e `marketplace.json`: acrescentar `/sec` à lista de comandos nas `description`.
- `README.md`: linha na tabela "O time" (`Security Engineer | roles/security-engineer/ | security-engineer | Sonnet | /sec`), com nota de que é **sob demanda, fora dos rituais**; linha no bloco "Comandos"; atualizar o conector `commands/` (§27) e a contagem de comandos.
- `how-to.md`: entrada do `/sec` análoga à do `/qa`.

**Conferência:** `grep /sec` acha o comando nos quatro arquivos; a nota "sob demanda" deixa claro que não entra na contagem dos seis papéis dos rituais.

---

## 5. Fora de escopo reforçado (o que NÃO fazer)
- Não mexer na numeração "os seis" dos rituais nem em `models.json` como obrigatório (opcional por projeto).
- Não criar gate automatizado em `scripts/checks/` nesta entrega.
- Não implementar correção de nenhuma vulnerabilidade.

---

## 6. Verificação
- **Leitura:** os 9 arquivos novos existem; os playbooks passam no `grep` de generalização (passo 5); `/sec` aparece nos quatro pontos de registro (passo 7).
- **Estrutura do plugin:** `claude plugin validate` (ou o que o repo usar) sem erro após os novos agente/comando — **execução pelo `operator`** se gerar log grande (R28).
- **Fumaça manual:** `/sec` lista os três modos; acionar `/sec blackbox` num projeto **sem** `context.md` → o papel para e pede o arquivo (pré-condição dura).

---

## 7. Onde parar e perguntar 🔺
- **Roteamento de achado (§2):** confirmar com você o corte crítico/alto → `/qa bug` vs médio/baixo → Product Backlog, antes de escrever o README do papel.
- **`models.json`:** o Security Engineer entra na lista de papéis com modelo configurável, ou fica fixo em `sonnet`?
- **Rito de construção:** criar papel/comando/playbooks é evolução de **processo do plugin** — terreno do `/review` (que roteia ao Arquiteto). Decidir se construo direto aqui ou abro pelo `/review` para seguir o rito do próprio time.
- **Destino dos originais:** mover (apagando de `melhorias/`) ou copiar (mantendo os dois)?
- **Shift-left (§8):** aprovar o **novo standard transversal** `implementation-appsec-web-api.md` vs. expandir o `implementation-security-lgpd-copyright.md` existente; e aprovar o **laço** achado → `/review` → Arquiteto complementa standard. A escrita dos standards é do Arquiteto (via `/review`), não deste papel.

---

## 8. Prática de segurança na origem (shift-left) — ponte com os standards do Arquiteto

A ideia: o que o pentest valida no fim, o standard já exige no começo. Dois sentidos, um laço:

1. **Standard → plano (origem).** O Arquiteto escreve plano e arquitetura citando seções de `standards/` que já embutem os princípios de segurança. O dev constrói seguro-por-padrão; o QA (frente 3) confere no portão. Quando o Security Engineer roda, encontra pouco — o controle já estava na origem.
2. **Achado → standard (realimentação).** Todo achado do Security Engineer cuja **causa-raiz é standard ausente ou fraco** vira **achado de processo roteado ao `/review`** (mesmo mecanismo que o QA já usa para defeito de standard — R16), que o direciona ao Arquiteto para complementar o normativo. O laço fecha: a lacuna que gerou a falha deixa de existir para a próxima Task.

Este é o motivo de o papel **reportar e não corrigir**: a correção de código é Task do dev; a correção da **causa sistêmica** é do Arquiteto, no standard.

### 8.1 Análise de lacuna — o que os documentos atuais já atendem

Base: `implementation-security-lgpd-copyright.md` (v1.1), `implementation-principles.md`, `stacks/dotnet/*`, `stacks/react/*`, e o checklist §10 do template de plano. Confrontados com a superfície que os três playbooks atacam (OWASP Web/API Top 10).

**✅ Já coberto (plano já pode nascer atendendo):**
| Vetor do pentest | Onde o standard já exige |
|---|---|
| IDOR / BOLA / BFLA / escalada | `security-lgpd` §5 (RBAC + permissão granular + **ownership do recurso**), §7 |
| Isolamento multi-tenant | `security-lgpd` §7 (tenant do JWT, nunca do cliente) + `dotnet/guide` §4 |
| Enumeração por existência de recurso | `security-lgpd` §7 (recurso de outro tenant → **404, não 403**) |
| Autorização só por Role | `security-lgpd` §1/§5 (cadeia obrigatória, nunca só Role) |
| Segredos no código | `security-lgpd` §9 + `dotnet/guide` §8 |
| Senhas / hashing | `security-lgpd` §9 (`IPasswordHasher`, sem cripto reversível) |
| Auditoria de ação sensível | `security-lgpd` §10 (append-only, mesma transação) |
| URL de download exposta | `security-lgpd` §13 (URL assinada, expiração, revogação) |
| Exposição de entidade crua (parte) | `implementation-principles` §149 + `dotnet/guide` §360 (query retorna **DTO**, nunca entidade) |
| LGPD / dados sensíveis | `security-lgpd` §8, §11 |

**🟡 Parcial (existe, mas não como requisito de segurança verificável):**
| Vetor | Hoje | Falta |
|---|---|---|
| Excessive Data Exposure | DTO em query (modelagem) | regra explícita "a resposta expõe só o que a tela usa", conferível pelo QA |
| Mass Assignment / over-posting | §5 fala de ownership; QA §7 cita "tenant/usuário em DTO" | proibir *binding* de campo sensível (`isAdmin`, `role`, `serviceId`) — DTO de entrada com allow-list |
| Validação do token | §2 mostra o **formato** do JWT | config de **validação**: `ValidateIssuer/Audience/Lifetime`, rejeitar `alg:none`, assinatura, `ClockSkew` pequeno |

**❌ Ausente (o pentest acha; nenhum standard previne):**
| Vetor do pentest | Fase do playbook | Onde deveria morar |
|---|---|---|
| Validação de entrada hostil (tipos, limites, allow-list) | Gray 4 · White 4/5 | `appsec` §Entrada |
| Injeção: SQLi/NoSQLi, Path Traversal, Command, SSTI, XXE | Black 5 · White 4 | `appsec` §Injeção + `dotnet/guide` (parametrizado/EF, sem `FromSqlRaw` interpolado) |
| Codificação de saída / XSS (`dangerouslySetInnerHTML`) | Black 5 · White 5 | `appsec` §Saída + `react/*` (proibir sem sanitização) |
| CORS (`AllowAnyOrigin`) | Gray 5 · White 1 | `appsec` §CORS + `dotnet/guide` (origens explícitas) |
| Cabeçalhos de segurança / HSTS | todas, Fase 1 | `appsec` §Cabeçalhos + `dotnet/guide` |
| Rate limiting (login, recuperação, SMS/e-mail) | Black 3 · Gray 2 | `appsec` §Rate limiting (hoje só o status 429 é mapeado, `dotnet/guide` §900) |
| Anti-enumeração de usuário (`isinuse`, resposta de login/recuperação) | Black 3 · Gray 2 | `appsec` §Rate limiting/Enumeração (respostas uniformes) |
| SSRF (chamada externa com entrada do usuário) | Black 5 · White 4 | `appsec` §SSRF (allow-list de destino) |
| Open redirect | Black 5 | `appsec` §Redirect |
| Desserialização insegura | Black 5 | `appsec` §Desserialização |
| Erro verboso / stack trace em produção | White 1/7 | `appsec` §Erros + `dotnet/guide` (sem `DeveloperExceptionPage` em prod; `ProblemDetails`) |
| SCA / plataforma EOL / sourcemap em produção | White 7 | `appsec` §Dependências + `react/quality` (`npm audit`, `GENERATE_SOURCEMAP=false`) |

**Conclusão:** autenticação, autorização e privacidade estão sólidas na origem; a **superfície web/API dinâmica** (injeção, borda HTTP, transporte, cabeçalhos, limites, dependências) é a lacuna. Ela cabe num **novo standard transversal** — a recomendação, por ser agnóstica de produto como o `security-lgpd` e por ser outro eixo (o `security-lgpd` é identidade/autorização/privacidade/direitos; este é superfície de ataque e borda).

### 8.2 `standards/implementation-appsec-web-api.md` — esqueleto proposto
Transversal, agnóstico de produto, no mesmo formato do `security-lgpd` (princípio → contrato → checklist). Seções: 1. Entrada hostil e validação · 2. Injeção (SQL/NoSQL/path/command/SSTI/XXE) · 3. Codificação de saída e XSS · 4. Mass assignment e exposição excessiva · 5. Validação do token na borda · 6. CORS · 7. Cabeçalhos de segurança e transporte (HSTS) · 8. Rate limiting e anti-enumeração · 9. SSRF e saída controlada · 10. Desserialização e open redirect · 11. Erros sem vazamento · 12. Dependências e plataforma (SCA, EOL, sourcemap) · 13. Checklist de aceitação. O **mecanismo concreto** por stack fica nos guias de stack (`dotnet`, `react`), que este normativo cita — não repete.

### 8.3 Onde o laço aparece no papel
- `agents/security-engineer.md` e o README do papel: a saída lista, além do relatório, os **achados de causa-raiz sistêmica roteados ao `/review`** (achado de standard), separados dos achados de código (que vão ao dev via PO/QA, §2).
- `implementation-plan.md` §10 e o checklist do QA (§3, bloco "A criar/complementar"): passam a cobrir os controles do §8.1 ❌/🟡 — é o que faz o plano **nascer** atendendo ao que o pentest valida.

> A escrita destes standards é trabalho do **Arquiteto, via `/review`** (dono editorial de `standards/`, R16) — este plano entrega a **análise de lacuna e a recomendação**, não o texto dos normativos.

## 9. Sequência sugerida de construção
1. `templates/context.md` + `templates/security-report.md` (definem a parametrização que os playbooks citam).
2. Playbooks generalizados (passo 5).
3. `agents/security-engineer.md` + `commands/sec.md`.
4. `README.md` do papel + `skills.md`.
5. Registros (passo 7) + verificação (§6).
