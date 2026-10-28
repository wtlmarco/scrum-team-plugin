# Template — Quebra em Tasks e fichas (`breakdown/S<n>.md`)

Salvo em `.team-project/architect/breakdown/S<n>.md` — um arquivo por sprint, uma seção por História, **gravada a cada História concluída** no passo 4 da Planning (v3.49 · R5). Dono: Arquiteto. A sessão transcreve as Tasks para o Sprint Backlog a partir daqui.

**A ficha (v3.53, `note.md` item 8)** é a seção de cada Task que o Arquiteto já escreve aqui ao quebrar a História: o que o plano vai precisar ler. No `sprint run`, o `run.ps1 next` recorta a ficha da Task (mais as decisões comuns da História) em `sprints/<n>/handoff/<T-ID>-ficha.md`, e um Arquiteto novo, só daquela Task, escreve o plano abrindo o recorte, o template do plano e o plano da Task de que ela depende ([`implementation-plan.md`](implementation-plan.md) regras 25 e 28). Sem ficha, a História é planejada numa instância só, como antes.

```markdown
# Quebra em Tasks — Sprint <n>

## H-<nnn> <título da História>

| Task | Título | Depende de | Critério de pronto | Cenários |
|---|---|---|---|---|
| T-<nnn> | <título> | — \| T-<nnn> | <o que fecha a Task> | SC-<nnn> |

### Decisões comuns — H-<nnn>
- `<nome literal>` — <o que é: tabela, campo, rota, evento, chave> · T-<nnn>, T-<nnn>

### Ficha T-<nnn> — <título>
**Código a ler:**
- `<caminho>:<linha>` — <por que: assinatura a usar, padrão a espelhar, invariante>

**Fontes:** `docs/sdd/<documento>.md` §<n> · `standards/<arquivo>.md` §<n> · `.team-project/user-experience/screens/<tela>.md`
**Nomes comuns:** `<nome literal>`, `<nome literal>`
```

## Regras da ficha

1. **Aponta, nunca reescreve.** Caminho e seção; nada de parafrasear regra do SDD ou do `standards/` — a ficha que reescreve vira uma terceira fonte da verdade.
2. **Código a ler:** só arquivo que **já existe**, um por linha, `caminho:linha` entre crases e o porquê. O plano lê esses e o que mais precisar — o que for além vai na linha `**Li além da ficha:**` do plano (é como se mede a ficha).
3. **Fontes:** as seções do SDD, dos standards e a especificação de tela que valem para a Task. `standards/…` resolve no plugin; o resto, na raiz do projeto.
4. **Decisões comuns, uma vez por História:** todo nome que mais de uma Task usa (tabela, campo, rota, evento) nasce aqui, com a grafia final. Cada ficha lista em `**Nomes comuns:**` os que a Task usa; o `plan.ps1` confere que o plano os usa literalmente e que todo caminho da ficha existe.
5. **Dependência é a do quadro** (coluna "Depende de"): o Arquiteto da Task recebe o plano já gravado da Task de que ela depende, e o `run.ps1 next` planeja primeiro a Task cujas dependências já têm plano.
6. **Curta:** até ~25 linhas por ficha. Ficha que cresce está fazendo o plano — o desenho é do plano.
