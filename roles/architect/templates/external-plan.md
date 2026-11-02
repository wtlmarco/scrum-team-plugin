# Pacote de plano externo — {{TITLE}}

> Gerado pelo `run.ps1 next` do plugin team (v3.53.4) a partir deste modelo (`roles/architect/templates/external-plan.md`). Quem recebe: um assistente de IA fora do Claude Code (o app do Codex, um chat na web) que escreve os planos. Quem confere: o `plan.ps1`, quando o retorno volta ao projeto em `.team-project/sprints/{{SPRINT}}/pack/in/`.

## Seu papel

Você é o Arquiteto do time para as Tasks deste pacote: escreve o **Plano de Implementação** de cada uma — o contrato que o desenvolvedor segue, passo a passo. **Só planos.** Não escreva código, não altere os arquivos de `files/` e não crie outros documentos. Escreva em português.

## O que devolver

Um arquivo por Task, com **exatamente** este nome, e nada além deles:

{{RETURN_FILES}}

Junte-os num zip chamado `{{RETURN_ZIP}}` (ou devolva os `.md` soltos). Arquivo com outro nome é recusado na volta.

{{ROUND}}
## Ordem e dependências

Planeje na ordem da tabela. Quando uma Task depende de outra deste pacote, use o plano que você acabou de escrever para ela: os mesmos nomes, arquivos e convenções. Dependência de fora do pacote já tem plano: o resumo dele está no fim da ficha.

{{TASKS}}

## Para cada Task

1. Leia a ficha `tasks/<T-ID>-ficha.md` — as decisões comuns da História, **Código a ler**, **Fontes**, **Nomes comuns** e **Arquivos previstos**, escritos pelo Arquiteto na Planning.
2. Do código e das fontes, leia em `files/` o trecho que a ficha aponta (`caminho:linha`, `§seção`), não o arquivo inteiro. Os caminhos em `files/` são os do projeto; `files/plugin/` são arquivos do plugin (como `standards/`).
3. Escreva o plano no modelo `context/implementation-plan.md` (o template enxuto e as "Regras do formato").
4. Contexto, quando existir: `context/architect-context.md` (arquitetura do projeto), `context/environment.md` (ambiente medido neste sprint), `context/scenarios/` (cenários executáveis da QA) e `context/stories/` (a História e os critérios de aceite).

## O que a conferência recusa (`plan.ps1`)

Confira cada item antes de devolver: plano recusado volta num pacote de correção, com a tabela do que faltou.

- **Cabeçalho:** `**Li além da ficha:** nenhum` (ou `` `<arquivo>` — <porquê> `` para cada arquivo lido fora da ficha); `**Cenários:**` com os cenários da Task (coluna da tabela acima) ou `nenhum — <motivo>`; `**Risco:** regra de negócio | integração | interface simples | infraestrutura`; Task com interface, `**Layout novo:** sim | não`.
- Os **nomes comuns** da ficha aparecem literalmente no plano.
- `**Arquivos tocados:**` com cada caminho entre crases, um por linha, terminando numa linha em branco; todo arquivo de produção tem teste na lista (ou `sem teste: <arquivo> — <motivo>` na §6). Fora da lista: `.team-project/`, documento de desenho (`docs/sdd/` — vai em `**Documentos vivos:**`) e arquivo de gate (`.editorconfig`, CI, hooks de git).
- `**Arquivos protegidos:** nenhum` (ou `ver §12`).
- Mais de 8 arquivos: um `### Bloco <k>` por grupo, cada um com `**Arquivos do bloco:**`, `**Depende de:**` e `**Pronto do bloco:**` com o comando e `exit 0`.
- A §3 (ambiente medido) vem **antes** da §4, com a tabela `| Pré-requisito | Comando de medição | Saída real | … |`: copie as linhas que valem de `context/environment.md`, com a fonte. **Nunca invente uma saída**: pré-requisito que não está lá vira premissa `- P<k> · não exercitada: <motivo> · verifica: dev no passo 1`.
- A §9 tem a parada `Pré-requisito ausente`.
- Trecho literal de código na §4: até 15 linhas por passo (é contrato; o dev escreve o corpo).
- A §6 tem `**Mutações:**` com linhas `` - M<k> · teste `<teste>` · `<produção>` · `<trecho exato>` → `<mutante>` `` (num arquivo que já existe, o trecho aparece uma vez só) — ou `sem prova: <motivo>`. Risco `regra de negócio` ou `integração` exige mutação.
- Sem linhas `- Contagem:` (a conferência reconta no repositório inteiro, que você não tem); use premissa.
- Premissa só como `- P<k> · medido: <comando> → <resultado>` ou `- P<k> · não exercitada: <motivo> · verifica: <papel> em <passo>`; nada de "não validado" solto.

Falta informação para decidir? Não invente: escreva `🔺 GAP: <o que falta>` na §9 do plano e siga com o resto.
