# Pacote de plano externo — {{TITLE}}

> Gerado pelo `run.ps1 next` do plugin team (v3.57.7) a partir deste modelo (`roles/architect/templates/external-plan.md`). Quem recebe: um assistente de IA fora do Claude Code (o app do Codex, um chat na web) que escreve os planos. Quem confere: o `plan.ps1`, quando o retorno volta ao projeto em `.team-project/sprints/{{SPRINT}}/pack/in/`.

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

Confira cada item antes de devolver: plano recusado volta num pacote de correção, com a tabela do que faltou. O nome entre colchetes é o da coluna **Regra** dessa tabela (`review/<T-ID>-check.txt`): a linha `falhou` aponta o item a corrigir.

- **Cabeçalho** `[ficha]` `[cenários]` `[risco]` `[render]`: `**Li além da ficha:** nenhum` (ou `` `<arquivo>` — <porquê> `` para cada arquivo lido fora da ficha); `**Cenários:**` com a coluna Cenários da tabela acima **copiada literalmente, inclusive o sufixo `(teste)`** (`SC-224 (teste), SC-225 (teste)`), ou `nenhum — <motivo>`. Sem o `(teste)`, o ID tem de estar definido como `scenario SC-…` num `.scn` de `context/scenarios/`. Depois, `**Risco:** regra de negócio | integração | interface simples | infraestrutura` e, em Task com interface, `**Layout novo:** sim | não`.
- `[ficha]` Os **nomes comuns** da ficha aparecem literalmente no plano.
- `[lista]` `[dono]` `**Arquivos tocados:**` com cada caminho entre crases, um por linha, terminando numa linha em branco; todo arquivo de produção tem teste na lista (ou `sem teste: <arquivo> — <motivo>` na §6). Fora da lista: `.team-project/`, documento de desenho (`docs/sdd/` — vai em `**Documentos vivos:**`) e arquivo de gate (`.editorconfig`, CI, hooks de git).
- `[protegidos]` `**Arquivos protegidos:** nenhum` (ou `ver §12`).
- `[blocos]` Mais de 8 arquivos: um `### Bloco <k>` por grupo, cada um com `**Arquivos do bloco:**`, `**Depende de:**` e `**Pronto do bloco:**` com o comando e `exit 0`.
- `[tamanho]` Até 30 KB por plano. Acima disso a Task se divide: não corte o plano para caber.
- `[ambiente]` A §3 (ambiente medido) vem **antes** da §4, com a tabela `| Pré-requisito | Comando de medição | Saída real | … |`. O `context/environment.md` foi **medido pelo run ao montar este pacote**: copie as linhas que valem para a Task **como estão**, com a fonte. **Nunca invente uma saída**: pré-requisito que não está lá vira premissa `- P<k> · não exercitada: <motivo> · verifica: dev no passo 1`.
- `[ambiente]` A §9 tem a parada `Pré-requisito ausente`.
- `[comandos]` A §9 tem `### Comandos da Task` com os comandos de build, teste ou lint que a Task roda além da lista base, ou `- nenhum além da lista base`. Instalação, rede, push e comando destrutivo não entram.
- `[trecho]` Trecho literal de código na §4: até 15 linhas por passo (é contrato; o dev escreve o corpo).
- `[mutação]` `[risco]` A §6 tem `**Mutações:**` com linhas `` - M<k> · teste `<caminho do arquivo de teste>` · `<produção>` · regra: <o que a mutação quebra> `` (v3.54: o dev escreve o trecho sobre o código real). Depois de "teste" vai **só o caminho do arquivo**, igual ao de `**Arquivos tocados:**` — nunca `` `<arquivo>::<NomeDoTeste>` ``; o nome do teste, se quiser citá-lo, vai no texto da regra — ou, só com trecho que **já existe uma vez** num arquivo do projeto, `` · `<trecho exato>` → `<mutante>` `` (trecho que ainda não existe reprova) — ou `sem prova: <motivo>`. Risco `regra de negócio` ou `integração` exige mutação.
- `[contagem]` Sem linhas `- Contagem:` (a conferência reconta no repositório inteiro, que você não tem); use premissa.
- `[premissa]` Premissa só como `- P<k> · <afirmação> · medido: <comando> → <resultado>` ou `- P<k> · <afirmação> · não exercitada: <motivo> · verifica: <papel> em <passo>`; nada de "não validado" solto. `medido:` só com a saída que está em `context/environment.md` (a seção **Premissas prontas** traz as linhas já no formato).
- **Com `**Layout novo:** sim`**, além do resto:
  - `[render]` A §3 tem a linha do **navegador headless** copiada de `context/environment.md`. Se lá ela diz **não**, a Task não entra em construção: escreva `🔺 GAP: navegador headless ausente` na §9.
  - `[render]` A §6 tem a tabela `**Render real**` com ao menos um teste: `` | `<arquivo do teste de render>` | <tela> | <fontes> | <caixas medidas> | <deve falhar se…> | ``. Uma das `**Mutações:**` usa esse mesmo arquivo depois de "teste", e o mutante quebra a medição.
  - `[premissa]` Ao menos uma premissa `medido:`. Use uma das **Premissas prontas** de `context/environment.md`. Premissa de geometria (posição, tamanho, sobreposição, rolagem, px) **não** se mede lendo código, nem o do framework: fica `não exercitada: <motivo> · verifica: dev em <passo do teste de render>`.
  - `[envelope]` A §6 tem `**Envelope de medidas**:` com uma linha por medida visual que o dev vai decidir, neste formato: `` - E<k> · <a medida e o elemento> · sonda: `<o que mede>` · (a) se <medida X> → <aplique Y> · (b) se <medida Z> → <aplique W> · fora disso → 🔺 GAP `aparência` ``. A `sonda:` vai entre crases; `(a) se` e `(b) se` são obrigatórios. Sem medida visual a decidir: `**Envelope de medidas:** nenhum — <motivo>`.
  - `[desenho]` A linha `**Documentos vivos:** `docs/sdd/<documento>` §<seção> — <o que muda>` no cabeçalho.
- `[aceite]` O plano que não roda o `accept.ps1` diz isso numa linha só do cabeçalho: `**Aceite:** não roda — <motivo>`. Não escreva "não rodar o accept.ps1" solto em outro lugar.
- `[herdados]` Task com `**Corrige:** T-<nnn>` no cabeçalho tem `### Testes herdados` na §6, com `` - `<teste>` · <o que muda> `` ou `- nenhum — <motivo>`.
- `[leve]` Não escreva `**Trilha:** leve` a menos que o quadro marque a Task como leve: o plano leve com mais de 5 arquivos, ou fora do critério da trilha, volta à plena.
- `[decisões]` **Decisões (regra 29):** decisão do sprint (`D-<k>`) ou do projeto (`K-<n>`) que a ficha traz se **cita** em `**Decisões:** D-<k>, K-<n>`, nunca se copia; citar uma que não existe reprova.
- `[decisões]` **Decisão de 🔺 GAP (regra 29):** toda `**Decisão do GAP <T-ID> (<data>):** <a decisão>` no plano vem seguida, **logo abaixo e sem linha em branco no meio**, de duas linhas no começo da linha:
  `**Origem:** previsão | conhecimento | requisito | ambiente | processo`
  `**Lição:** projeto | stack:<nome> | plugin | nenhuma`
  Sem elas, ou com valor fora da lista, o plano volta.
- `[verificação]` **Verificação (regra 35, opcional):** só quando o verify full padrão não serve — `**Verificação:** dispensada — <motivo>` (sem `**Mutações:**`) ou `` **Verificação:** comando — `<comando>` `` (sem instalação, rede, push ou comando destrutivo).

Falta informação para decidir? Não invente: escreva `🔺 GAP: <o que falta>` na §9 do plano e siga com o resto. Se você mesmo decide um GAP no plano, use o formato `**Decisão do GAP …:**` acima, com **Origem:** e **Lição:**.
