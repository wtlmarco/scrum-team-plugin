# Template — `.team-project/security-engineer/context.md`

Contexto do projeto-alvo que o Security Engineer lê antes de qualquer teste. **É a parametrização dos playbooks** (`${CLAUDE_PLUGIN_ROOT}/roles/security-engineer/playbooks/`): eles são agnósticos de produto e tiram daqui alvo, URLs, stack, esquema de autenticação, contas de teste e regime de dados. **Não é semeado no `init`** — o papel é sob demanda; nasce no primeiro `/sec` (ou o stakeholder o cria deste modelo). O papel dono do assunto (Security Engineer) propõe e o SM mantém a coerência, como todo `context.md` ([`artifact-ownership.md` §1](../../scrum-master/process/artifact-ownership.md)).

> **Sem este arquivo, ou com a §1 vazia, o papel para e pede ao stakeholder.** Não há teste de segurança sem autorização.

```markdown
# Security Engineer — Contexto do projeto <nome>

## 1. Autorização (pré-requisito — sem isto o papel não executa)
- **Escopo autorizado por escrito:** <domínios, URLs, repositórios cobertos>
- **Autorizado por:** <nome / papel> · **Data:** <AAAA-MM-DD>
- **Fora de escopo:** <terceiros, infra de hospedagem, CDN, hosts não listados>

## 2. Alvo e superfície
- **Front-end:** <URL(s) e ambientes autorizados>
- **API:** <URL(s) autorizadas; porta de dev>
- **Repositórios (white-box):** <caminhos; só leitura>

## 3. Stack
- **Back-end:** <linguagem / framework / versão> · **Front-end:** <idem> · **Plataforma fora de suporte?** <sim/não — qual>

## 4. Autenticação
- **Esquema do token:** <ex.: header `Authorization: Bearer`, cookie, header próprio> · **Validação:** <issuer/audience/lifetime esperados>
- **Fluxos:** <login, recuperação de senha, confirmação por e-mail/SMS, refresh>

## 5. Contas de teste (ao menos duas, papéis diferentes)
- <usuário A — papel> · <usuário B — papel> · **Credenciais:** <ponteiro para o cofre; nunca em claro aqui>

## 6. Dados sensíveis e conformidade
- **Natureza:** <saúde, financeiro, pessoal, …> · **Regime:** <LGPD / outro>
- **Proibição absoluta:** só dados fictícios; nunca acessar, copiar ou extrair dado real de titular

## 7. Ferramentas disponíveis no ambiente
- <ZAP, Burp, Nmap, Nuclei, testssl.sh, WhatWeb, npm audit, analisadores do SDK — só as que existem>

## 8. Saída
- **Relatório em:** `.team-project/security/<AAAA-MM-DD>/`
```

## Regras do formato
- **A §1 é dura.** Autorização ausente ou vencida → o papel não roda; registra a limitação e devolve ao stakeholder.
- **Nada de segredo em claro.** Credenciais de teste vão por ponteiro (cofre, variável de ambiente), nunca copiadas aqui — o arquivo é `.team-project/` local (R31), mas a disciplina vale (R16-análogo).
- **O que muda no produto muda aqui.** Endpoint novo, troca de esquema de auth, novo ambiente autorizado: o `context.md` é atualizado antes do próximo engajamento, senão o playbook ataca uma superfície velha.
