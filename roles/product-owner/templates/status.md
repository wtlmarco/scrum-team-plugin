# Template — Status executivo (`/po status`)

Formato de resposta do PO ao stakeholder. **Seis linhas.** Ele lê isso em pé.

> **É do PO porque é sobre valor e prazo**, não sobre tarefa: quem detém o plano de entrega é quem responde onde estamos e quando sai ([`workflow.md` §6a](../../scrum-master/process/workflow.md)). O PO **lê** o Sprint Backlog do SM e o registro de evidências do QA — não os edita.

**Fala em Histórias, não em Tasks.** A Task é a unidade de trabalho do time; o stakeholder acompanha **valor entregue**. Task só aparece aqui quando é ela que está bloqueada.

```markdown
## Status — <data> · Sprint <n>

**Onde estamos:** <1-2 frases: o objetivo do sprint e o que ele destrava.>
**Entregue:** <H-ID> — <o que o usuário passa a conseguir> — aceita em <data da Review>
**Em andamento:** <H-ID> — <n de m Tasks fechadas> — <o que falta para demonstrar>
**Bloqueado:** <H-ID ou T-ID> — <bloqueio> — <quem destrava, desde quando>
**Próximo:** <H-IDs na ordem do plano de entrega> — <por que nesta ordem>
**Riscos ao plano:** <o que pode deslocar a entrega e o gatilho de alerta>
```

## Regras

- Ler, **antes de responder**: o Product Backlog (o plano de entrega), o Sprint Backlog do SM (`.team-project/scrum-master/sprint-backlog.md`) e o registro de evidências do QA. **Nunca recompor o estado de memória.**
- **"Entregue" é História aceita na Sprint Review** (R21) — não é Task fechada, nem soma de Tasks fechadas. Task fechada é trabalho técnico concluído; valor entregue é o que o PO aceitou.
- Sem adjetivo. Com ID e evidência.
- **Não propor trabalho novo neste modo** — isso é a Planning Meeting (`/sm sprint plan`).
- **Prazo é seu, capacidade é do SM.** Ao dizer que uma História desloca, cite a conta do SM; não recalcule capacidade por conta própria.
- Se o Sprint Backlog divergir do que o registro de GAPs mostra, registrar como risco e acionar `/qa audit`. **Não arredondar.**

## Exemplo

```markdown
## Status — 01/09/2026 · Sprint 7

**Onde estamos:** o sprint fecha a saída de dado da plataforma — com H-014 aceita, o analista deixa de refazer o quadro no slide.
**Entregue:** H-014 (exportar o resultado da análise) — aceita na Review de 08/09.
**Em andamento:** H-017 (agendar exportação recorrente) — 2 de 4 Tasks fechadas — falta o disparo agendado e a demonstração.
**Bloqueado:** T-052 — sem credenciais do provedor de e-mail — stakeholder, desde 01/09.
**Próximo:** H-021 → H-019, nesta ordem porque H-019 depende do formato que H-021 define.
**Riscos ao plano:** H-017 depende de T-052; se as credenciais não saírem nesta semana, ela não é demonstrável na Review e desloca para o sprint 8 — a capacidade do sprint não absorve a troca (conta do SM).
```
