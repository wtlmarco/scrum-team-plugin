# Template — Decisões da Planning e pacote de abertura (`/sm sprint plan`)

> **Dono:** SM (escreve) · **PO** fornece a priorização · Vive em `.team-project/sprints/<n>/planning.md`
> Nasce no **passo 9** da Planning ([`../process/workflow.md` §5e](../process/workflow.md)), antes de o pacote subir ao stakeholder, e **é peça obrigatória do pacote de abertura** (R25).
> **Por que existe:** no pacote o stakeholder vê o que **entrou**. Sem a lista do que **não** entrou, uma pendência crítica despriorizada passa despercebida — e a decisão de priorização fica invisível, não só o resultado.

```markdown
# Planning — Sprint <n> — <data>

## 1. Objetivo do sprint
<Uma frase, escrita pelo PO, derivada das Histórias que entraram.>

**Fatia vertical (R25):** <qual fluxo o stakeholder consegue atravessar ponta a ponta ao fim deste sprint>

## 2. Capacidade
| | |
|---|---|
| **Capacidade observada** | <n> — média entregue nos sprints <n-3>, <n-2>, <n-1> |
| **Somatório planejado** | <n> |
| **Acima da capacidade?** | <não \| sim — justificativa escrita: ...> |

## 3. Varredura de bloqueios sobre as candidatas *(passo 3 — R25)*
> Sanado aqui, ou a História **não entra**. O pacote aprovado já vem sem bloqueio aberto.

| História | Bloqueio levantado | Natureza | Quem respondeu | Resolução |
|---|---|---|---|---|
| H-<nnn> | <o que faltava> | dependência · lacuna funcional · risco técnico | PO / Arquiteto | <sanado como \| **devolvida ao Product Backlog**> |

## 4. O que entrou
| História | Valor em uma frase | Est. | Tasks | Por que nesta posição |
|---|---|---|---|---|
| H-<nnn> | <o que o stakeholder passa a conseguir fazer> | <n> | <n> | <valor × risco, dependência> |

## 5. O que NÃO entrou — e por quê *(obrigatório · R25)*
> Inclui **tudo o que veio da Review anterior**: gap, débito, ressalva, erro. O PO **propõe** a priorização (é dele, por valor × risco — §6a); o stakeholder **aprova o pacote e pode devolver**.

| Item | Origem | Prioridade do PO | Motivo de não entrar | Quando entra |
|---|---|---|---|---|
| H-<nnn> / ressalva de H-<nnn> / débito | Review do sprint <n-1> · Product Backlog · GAP | alta · média · baixa | <não coube na capacidade \| depende de X \| valor menor que o que entrou> | <sprint <n+1> \| sem data, com o risco aceito> |

**Nada da Review anterior ficou sem linha aqui?** <sim, conferido contra `sprints/<n-1>/review.md` | não — o que falta e por quê>

## 6. Pacote de abertura — o que foi submetido
| Peça | Onde | Quem montou |
|---|---|---|
| Sprint Backlog fechado | [`sprint-backlog.md`](sprint-backlog.md) | SM |
| Critérios de aceite das Histórias que entraram | <onde> | PO |
| Protótipo navegável do sprint | <caminho/URL> — fluxo ponta a ponta: <qual> | UX |
| Este documento | `planning.md` | SM |

**Resultado:** <aprovado em <data> por <stakeholder> \| devolvido em <data> — o que ele pediu, e o que a Planning refez>

## 7. Gatilho de método acionado? *(R13)*
<nenhum | APF / EAP / registro formal de riscos / controle integrado de mudanças — qual gatilho de `skills.md` §9 disparou>
```

## Regras

- **Escrito antes de o pacote subir, nunca depois.** `planning.md` escrito no fechamento do sprint é ata reconstituída de memória — o mesmo modo de falha que R24 nomeia para o burndown.
- **A seção 5 é obrigatória e não aceita "nada a declarar" sem conferência.** Ela se preenche lendo `sprints/<n-1>/review.md`, item a item. Pacote submetido sem ela é devolvido pelo SM antes de chegar ao stakeholder (R25 · [`../process/workflow.md` §8](../process/workflow.md)).
- **O SM escreve, o PO decide o conteúdo das seções 4 e 5.** Valor e prioridade são do PO (§6a); o SM registra e cobra a completude. SM que reordena a lista por conta própria violou a fronteira.
- **A seção 3 não é decorativa.** História com bloqueio aberto não entra — é o **degrau 0** de R25, e é o que faz o pacote aprovado chegar limpo à construção.
- **Fechado com a pasta.** Depois da aprovação, `planning.md` é registro do sprint: não se reescreve. Mudança posterior vira entrada fora de Planning no Sprint Backlog, com "o que saiu para caber" (R4).

## Falhas comuns

| Falha | Consequência |
|---|---|
| Seção 5 vazia porque "não sobrou nada relevante" | Pendência crítica despriorizada em silêncio — exatamente o que a seção existe para impedir |
| Fatia vertical declarada sem o fluxo nomeado | O sprint entrega metade de um caminho e ninguém percebe até a Review (R25) |
| Varredura de bloqueios feita "de cabeça", sem linha por História | O bloqueio reaparece no dia 3 do sprint, quando já custa uma caixa de tempo |
| Capacidade estourada sem justificativa escrita | O desvio some na retrospectiva e a capacidade observada nunca se corrige (R2 · §5e) |
