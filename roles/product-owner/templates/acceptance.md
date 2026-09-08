# Template — Aceite de História (`/po accept <H-ID>`, na Sprint Review)

> O aceite é **funcional, agregado e por História** (R21). Acontece **na Sprint Review**, ante o stakeholder, nunca isolado e nunca mirando uma Task. **Exige os vereditos do QA das Tasks da História anexados.**

```markdown
## Aceite — H-<nnn> <título> — Sprint <n> — <data>

**Tasks da História:** <T-nnn ✅ · T-nnn ✅ · T-nnn ⚠️> — todas fechadas? <sim | não: quais faltam>
**Vereditos do QA:** <lista com data de cada um>

### Critérios de aceite conferidos
| # | Critério da História | Situação | Task que cumpre | Evidência |
|---|---|---|---|---|
| 1 | <critério aprovado no portão ③> | ✅ / ❌ | T-<nnn> | <linha do registro do QA que li, ou passo que executei> |

### Fluxo do usuário
<O caminho real ficou utilizável ponta a ponta? Uma frase sobre a experiência, não sobre o código.>

### Decisão
**<Aceita | Aceita com ressalva | Rejeitada>**

**Motivo:** <uma frase>
**Ressalvas viram entrada no Product Backlog:** <ID — título — dono> (ou "nenhuma")
**Se rejeitada — Tasks que voltam:** <todas as da História, marcando as que já passaram no QA para não refazer>
**Critério de sucesso afetado:** <qual — passa a atendido? com que evidência?> (ou "nenhum")
```

## Regras

- **Sem veredito do QA, não há aceite** (R7). Nem "aceito condicional à validação".
- **O alvo é a História, nunca a Task** (R21). Task não se aceita: ela fecha tecnicamente com o veredito do QA e o `/sm close`.
- **Fora da Sprint Review não há aceite.** História aceita em conversa avulsa é violação registrada pelo SM.
- Critério é conferido **um a um**, apontando a Task que o cumpre e a evidência. Critério não conferível é critério mal escrito — corrigir a História e reaprová-la no portão ③.
- **Ressalva vira entrada no Product Backlog** com dono, imediatamente, na mesma sessão (R12). Ressalva verbal desaparece.
- **Rejeição devolve a História inteira**, com todas as Tasks, inclusive as aprovadas pelo QA — anotadas como já feitas, para que a Planning seguinte não as replaneje do zero.
- Marcar critério de sucesso como atendido exige apontar a linha de evidência em `.team-project/quality-assurance/evidence.md`.
- Rejeição diz **o que falta**, não "não está bom".
- **História que toca operação sob orçamento de desempenho** (Ficha V18): o aceite confere o **estado registrado pelo QA** — dentro do orçamento · fora · não exercitado — e a **saída real** do comando de carga (V19). "Fora" é rejeição; "não exercitado" sem motivo declarado é rejeição.

## Exemplo

```markdown
## Aceite — H-014 (exportar o resultado da análise) — Sprint 7 — 08/09/2026

**Tasks da História:** T-041 ✅ · T-042 ✅ · T-043 ✅ — todas fechadas? sim
**Vereditos do QA:** T-041 ✅ 05/09 · T-042 ✅ 06/09 · T-043 ✅ 08/09

### Critérios de aceite conferidos
| # | Critério | Situação | Task | Evidência |
|---|---|---|---|---|
| 1 | Exportar com filtro traz só as linhas filtradas | ✅ | T-041 | suíte de exportação + conferência manual: 214 linhas na tela, 214 no arquivo |
| 2 | Link com mais de 24h não baixa e explica o motivo | ✅ | T-042 | teste `Download_ComAssinaturaExpirada_DeveRetornar410` + smoke com relógio adiantado |
| 3 | Usuário sem permissão de custo recebe arquivo sem a coluna | ✅ | T-043 | teste de isolamento por perfil + exportação real com "analista júnior" |

**Fluxo do usuário:** o analista sai da tela com o arquivo pronto para a reunião — o caminho que hoje é print de tela deixou de ser necessário.

**Decisão: Aceita.**
**Motivo:** os três critérios aprovados no portão ③ têm evidência executável e o fluxo ficou utilizável ponta a ponta.
**Ressalvas:** nenhuma.
**Critério de sucesso afetado:** "exportar o resultado final" passa a atendido — evidência no registro do QA, blocos T-041 a T-043.
```
