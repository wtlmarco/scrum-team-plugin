# Template — Aceite (`/po accept <ID>`)

Último passo antes do fechamento pelo SM. **Exige veredito do QA anexado.**

```markdown
## Aceite — <ID> <título> — <data>

**Veredito do QA:** ✅ | ⚠️ (ressalvas: <IDs>) — <data do veredito>

### Critérios conferidos
| # | Critério de aceite | Situação | Como conferi |
|---|---|---|---|
| 1 | <critério> | ✅ / ❌ | <evidência que li ou passo que executei> |

### Fluxo do usuário
<O caminho real ficou utilizável? Uma frase sobre a experiência, não sobre o código.>

### Decisão
**<Aceito | Aceito com ressalva | Rejeitado>**

**Motivo:** <uma frase>
**Ressalvas viram itens novos:** <ID novo — título — criticidade> (ou "nenhuma")
**Critério de sucesso afetado:** <qual — passa a atendido? com que evidência?> (ou "nenhum")
```

## Regras

- **Sem veredito do QA, não há aceite** (R7). Nem "aceito condicional à validação".
- Critério é conferido **um a um**, não em bloco. Critério não conferível é critério mal escrito — corrigir o requisito.
- **Ressalva vira item no backlog** com ID próprio, imediatamente. Ressalva verbal desaparece.
- Marcar critério de sucesso como atendido exige apontar a linha de evidência em `.team-project/quality-assurance/evidence.md`.
- Rejeição diz **o que falta**, não "não está bom".
- **Item que toca operação sob orçamento de desempenho** (Ficha V18): o aceite confere o **estado registrado pelo QA** — dentro do orçamento · fora · não exercitado — e a **saída real** do comando de carga (V19). "Fora" é rejeição; "não exercitado" sem motivo declarado é rejeição.

## Exemplo

```markdown
## Aceite — ABC-01 (endpoint de download assinado) — 08/09/2026

**Veredito do QA:** ✅ — 08/09/2026

| # | Critério | Situação | Como conferi |
|---|---|---|---|
| 1 | URL assinada válida devolve 200 + arquivo íntegro | ✅ | suíte de download + smoke manual baixando um arquivo real |
| 2 | URL expirada devolve 410 | ✅ | teste `Download_ComAssinaturaExpirada_DeveRetornar410` |
| 3 | URL adulterada devolve 403 | ✅ | teste `Download_ComCaminhoAlterado_DeveRetornar403` |

**Fluxo do usuário:** o arquivo gerado finalmente sai da plataforma — o link do painel baixa o conteúdo.

**Decisão: Aceito.**
**Motivo:** os três critérios têm evidência executável e o fluxo ficou utilizável ponta a ponta.
**Ressalvas:** nenhuma.
**Critério de sucesso afetado:** "exportar o resultado final" passa a atendido — evidência no registro do QA, bloco ABC-01.
```
