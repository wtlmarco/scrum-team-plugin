# Modelo — Conformidade da documentação no sprint 0 (`.team-project/sprints/0/evidence/conformance.md`)

> **Dono:** QA · Uma linha por documento do SDD, reescrita a cada conferência do mesmo documento · Lido pelo `foundation.ps1` (o ✅ precisa ser mais novo que o documento) · Roteiro: `roles/scrum-master/process/workflow-sprint0.md` · Regra: R35

O QA confere três coisas, nesta ordem, e **reprova, não corrige** (o dono reescreve):

1. **Régua** — `foundation.ps1 check -Item <S0-nn>` ok. É a forma: o documento está no modelo.
2. **Fidelidade ao código, por amostra** — ao menos 3 afirmações verificáveis por documento (e ao menos 1 por área do escopo), cada uma conferida com `arquivo:linha`: um requisito que o código realmente cumpre, uma entidade com os campos reais, um endpoint ou serviço que existe com esse nome, um diretório da árvore do `03`. Afirmação que o código não sustenta é ❌.
3. **Verificabilidade** — o "Como verificar" de cada critério de aceite amostrado dá um passo executável (comando ou passo de tela com resultado esperado). Se não dá, o QA não conseguiria escrever o cenário: ⚠️.

```markdown
# Conformidade — sprint 0

| Documento | Régua | Fidelidade ao código (amostra) | Verificabilidade | Veredito | Achados |
|---|---|---|---|---|---|
| 01-requirements.md | ok (S0-02) | RF-003 → src/app/canteiros/canteiro.service.ts:42 ✅ · RF-007 → sem código ❌ | RF-003 ok · RF-005 "funciona" ⚠️ | ❌ | RF-007 descreve exportação que o código não tem — tirar ou marcar como não implementado; RF-005 sem passo verificável |
| 03-architecture.md | ok (S0-04) | árvore §2 = `git ls-files` ✅ · P-002 → src/core/http:0 ocorrências ✅ · V10 `npx ng test` roda ✅ | — | ✅ | — |
```

- **Documento** — o nome do arquivo (o script casa pela célula). Uma linha por arquivo; reconferência **substitui** a linha.
- **Veredito** — ✅ (conforme), ⚠️ (pontos a melhorar que impedem o cenário) ou ❌ (diverge do código). Só ✅ fecha o item.
- **Achados** — com `arquivo:linha`; má prática do código não é achado de documento: cite como dívida para o `03` §0.1.
