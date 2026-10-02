# Template — Carta de serviço ao consultor externo (`/sm consulting`)

> **Dono:** SM (consolida) · **seções pelos papéis do domínio** ([`../README.md` §`/sm consulting`](../README.md)) · Vive em `.team-project/consulting/C-<nnn>-<slug>/01-service-letter.md` (R32).
> **Sai do projeto:** o stakeholder a leva a um consultor externo — humano ou IA. Passa pelo **checklist de sanitização** e pela assinatura do QA no `case.md` (+ PO no `business`) antes de sair.

```markdown
# Service Letter — C-<nnn> · <tema>
**Domínio:** <database | security | design | architecture | infrastructure | business:<área>> · **Rodada:** 01 · **Data:** <data>

## 1. Necessidade            <!-- PO -->
## 2. Cenário                <!-- Arquiteto (UX em design; PO + UX em business: processo atual, papéis, volumes em ordem de grandeza) — sem dado sensível -->
## 3. Problema               <!-- uma frase + o que bloqueia -->
## 4. Restrições             <!-- standards vigentes, LGPD, custo, prazo, o que não pode mudar; em business, a regulação e as normas da área -->
## 5. Critérios de decisão   <!-- pesos: custo, risco, reversibilidade, esforço, operação; em business, também impacto no processo e adoção -->
## 6. O que já foi considerado e descartado
## 7. Contrato de resposta   <!-- fixo: copie consultant-response.md inteiro aqui -->
```

## Regras

- **Autocontida.** A carta funciona sozinha, num chat novo ou nas mãos de um especialista que nunca viu o projeto — nada de "ver documento X".
- **Descrever, não anexar.** Nenhum documento interno colado; nenhum caminho `.team-project/`; código só o necessário e anonimizado.
- **A §7 é fixa.** Sem o contrato de resposta, a resposta não é comparável e o checklist de consenso não fecha.
