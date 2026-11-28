# Template — Delta técnico (`.team-project/architect/deltas/A-<nnn>.md`)

O que muda em `03-architecture`, `04-data-model` e `05-api-model` por causa de um pedido de **evolução** ou **capacidade nova** (v3.67.0). Escrito pelo Arquiteto na **varredura técnica do `/sm sprint prepare`** (passo 5), quando a História é **estrutural**, e aprovado pelo stakeholder no **portão ②** (passo 7). É o par técnico da análise do PO (`product-owner/analysis/A-<nnn>-<slug>.md`). **Dono:** Arquiteto.

**Não é ADR.** O ADR continua para decisão de tecnologia, de estratégia ou estrutural e recorrente ([`adr.md`](adr.md)). Se o delta exigir uma decisão dessas, abra o ADR a partir dele e cite-o aqui.

```markdown
# Delta técnico — A-<nnn> · <título>

**Origem:** [análise A-<nnn>](../../product-owner/analysis/A-<nnn>-<slug>.md) · Histórias: H-<nnn>, H-<nnn>
**Estrutural:** sim — <o que toca: 03 / 04 / 05>
**ADR:** <ADR-<nnn> | nenhum>

## 04-data-model
| Entidade / campo | Antes | Depois | Migration | Dado existente |
|---|---|---|---|---|
| <entidade.campo> | <...> | <...> | <sim — o que faz / não> | <o que acontece com o que já está gravado> |

## 05-api-model
| Endpoint / contrato | Antes | Depois | Quem já chama | Compatível? |
|---|---|---|---|---|
| <verbo /caminho> | <...> | <...> | <cliente, tela, integração> | <sim / não — o que quebra> |

## 03-architecture
<Componente afetado e o que muda nele, ou "sem mudança".>

## O que não muda
<O limite do delta: o que alguém suporia mudar e não muda.>

## Risco
<O que pode quebrar e o custo.>

## Portão ②
| História | Decisão | Data | Canal | Ajuste pedido |
|---|---|---|---|---|
| H-<nnn> | aprovado · aprovado com ajuste · reprovado | <aaaa-mm-dd> | celular · terminal | <— ou o ajuste> |
```

## Regras

- **Um delta por A-ID.** Uma capacidade nova em vários sprints mantém o mesmo arquivo: a parte nova ganha seção própria (`## Sprint <n> — <parte>`) e uma linha nova na tabela do ② **só para a parte nova** — o que já foi aprovado não volta ao stakeholder.
- **A tabela "Portão ②" é o registro único do ② da evolução.** A sessão do `prepare` grava a decisão nela; `context.md` §"Candidatas do próximo sprint" só aponta para ela. Sem a linha `aprovado` da História, a DoR-a da História estrutural não está cumprida.
- **Duas Histórias que mexem na mesma entidade ou no mesmo contrato ficam no mesmo delta**, ou um delta cita o outro em **Origem** como dependência. A consolidação aplica os dois de uma vez.
- **Estrutural** é quando o delta toca `03`, `04` ou `05`: entidade, campo, migration, endpoint, contrato, componente. Mudança só de tela ou de regra funcional não é estrutural e não pede delta — a varredura registra "não — <motivo>".
- **Nada disto entra na História** (R20). A ficha da quebra (`breakdown/S<n>.md`) e o Plano de Implementação citam o delta em **Fontes**; a História cita só o A-ID.
- **O delta não altera o SDD.** Ele é aplicado a `03`/`04`/`05` pelo Arquiteto na **consolidação dos documentos vivos** do sprint (a Task do SDD, Trilha `sdd` — [`docs-consolidation.md`](docs-consolidation.md)), depois do ✅ do QA.
- O `plan.ps1` (regra 37) reprova o plano da História com Origem `A-<nnn>` que prevê migration (ou caminho de `guards.json → structural.paths`) sem a linha `aprovado` da História nesta tabela.
