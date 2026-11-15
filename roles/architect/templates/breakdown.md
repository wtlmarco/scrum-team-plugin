# Template — Quebra em Tasks e fichas (`breakdown/S<n>.md`)

Salvo em `.team-project/architect/breakdown/S<n>.md` — um arquivo por sprint, uma seção por História, **gravada a cada História concluída** no passo 4 da Planning (v3.49 · R5). Dono: Arquiteto. A sessão transcreve as Tasks para o Sprint Backlog a partir daqui.

**A ficha (v3.53, `note.md` item 8)** é a seção de cada Task que o Arquiteto já escreve aqui ao quebrar a História: o que o plano vai precisar ler. No `sprint run`, o `run.ps1 next` recorta a ficha da Task (mais as decisões comuns da História) em `sprints/<n>/handoff/<T-ID>-ficha.md`, e um Arquiteto novo, só daquela Task, escreve o plano a partir do recorte ([`implementation-plan.md`](implementation-plan.md) regras 25 e 28). Sem ficha, a História é planejada numa instância só, como antes.

**A ficha vira a pasta do plano (v3.60.0).** O `run.ps1 next` **copia para o recorte** os trechos que a ficha aponta — as faixas de **Código a ler:** e as seções de **Fontes:**, com o número da linha — e junta o guia de escrita do plano. O Arquiteto do plano lê esse arquivo uma vez e escreve; antes, ele refazia a busca que eu já tinha feito aqui (no garden, S6: ~40 chamadas por plano antes de escrever, 84 % do custo). Por isso a faixa precisa ser a que o plano usa: **aponto o trecho que eu li para decidir a quebra**, não só o arquivo.

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
- `<caminho>:<a>-<b>` — <por que: assinatura a usar, padrão a espelhar, invariante> *(mais faixas do mesmo arquivo na linha: `:<c>-<d>`)*

**Fontes:** `docs/sdd/<documento>.md` §<n> · `standards/<arquivo>.md` §<n> · `.team-project/user-experience/screens/<tela>.md` §<n>–§<m>
**Nomes comuns:** `<nome literal>`, `<nome literal>`
**Arquivos previstos:** <n>
```

## Regras da ficha

1. **Aponta, nunca reescreve.** Caminho e seção; nada de parafrasear regra do SDD ou do `standards/` — a ficha que reescreve vira uma terceira fonte da verdade.
2. **Código a ler:** só arquivo que **já existe**, um por linha, entre crases e o porquê, **com a faixa que o plano usa** (v3.60.0): `caminho:a-b` — a assinatura, o padrão a espelhar, o teste a estender, o trecho que muda. Mais faixas do mesmo arquivo vão na mesma linha (`:c-d`, `:e`). `caminho:linha` sozinho copia 40 linhas a partir de 5 antes dela; `caminho` sem linha copia o arquivo inteiro só até 150 linhas. Faixa que passa do fim do arquivo é corrigida antes do plano, como caminho que não existe. **A linha é a do código de hoje, na Planning** — as Tasks das Histórias anteriores vão mudar o arquivo antes do plano desta: o `run.ps1 next` traduz a faixa pelo `git diff` desde o último commit antes do início do sprint (ou desde a correção da ficha), copia o trecho no lugar novo e anota o deslocamento; se o próprio trecho mudou, copia o de hoje com ⚠ para o plano conferir. Não reescreva faixas à mão no meio do sprint. O plano lê os trechos e o que mais precisar — o que for além vai na linha `**Li além da ficha:**` do plano (é como se mede a ficha).
3. **Fontes:** as seções do SDD, dos standards e a especificação de tela que valem para a Task, com a seção: `§2.5`, `§2–§7` (da 2 ao fim da 7) ou `§"<texto do título>"`. O `run.ps1 next` copia a seção pelo título do markdown; sem §, o documento inteiro só até 150 linhas. `standards/…` resolve no plugin; o resto, na raiz do projeto.
4. **Decisões comuns, uma vez por História:** todo nome que mais de uma Task usa (tabela, campo, rota, evento) nasce aqui, com a grafia final. Cada ficha lista em `**Nomes comuns:**` os que a Task usa; o `plan.ps1` confere que o plano os usa literalmente e que todo caminho da ficha existe.
5. **Dependência é a do quadro** (coluna "Depende de"): o Arquiteto da Task recebe o plano já gravado da Task de que ela depende, e o `run.ps1 next` planeja primeiro a Task cujas dependências já têm plano.
6. **Curta:** até ~25 linhas por ficha. Ficha que cresce está fazendo o plano — o desenho é do plano. A ficha continua curta mesmo com os trechos: quem copia é o script, a ficha só aponta a faixa. Os trechos de uma Task somam até 60 KB no recorte; o que passa fica como nota, para o plano ler no trecho.
7. **Arquivos previstos (v3.53.2): até 6 por Task.** Quantos arquivos a Task deve mudar, produção e teste somados. Acima de 6, **divido a Task aqui**, na quebra (R2), dentro da mesma História: o custo do plano cresce mais rápido que a Task (no garden, sprint 5: 6 arquivos ≈ US$ 2,5; 9 ≈ US$ 4,7; 12 ≈ US$ 8,7, cada chamada relendo uma conversa maior). Se escapar, o `run.ps1 next` não chama o Arquiteto do plano: pede a divisão primeiro. O `plan.ps1` mostra o previsto × o do plano, para a retrospectiva calibrar a estimativa.
8. **Caminho com pasta, a partir da raiz** (`.team-project/user-experience/screens/x.md`, não `x.md`). O `run.ps1 next` confere os caminhos da ficha **antes** de chamar o Arquiteto do plano e, se algum não existe, pede a correção numa instância curta. Em **Fontes:**, só é caminho o termo com pasta ou extensão — nome de classe entre crases não é conferido.
