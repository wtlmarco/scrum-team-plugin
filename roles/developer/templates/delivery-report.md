# Template — Relatório de Entrega

Fecha toda execução de `/dev <ID>`. É o ponto de partida do QA, que confere cada passo contra o plano (frente 2 — `workflow.md` §4a).

```markdown
## Entrega — <ID> <título>

**Plano:** `.team-project/sprints/<n>/plan/<T-ID>-<slug>.md`
**Passos concluídos:** <n> de <m>

### Arquivos
**CRIADOS**
- <caminho completo> — <o que é>

**ALTERADOS**
- <caminho completo> — <o que mudou, em uma frase>

**REMOVIDOS**
- <caminho completo> — <por quê>

*(grupo vazio: escrever "nenhum arquivo nesta categoria" — não omitir)*

### Testes adicionados
| Arquivo | Nome | Caso coberto |
|---|---|---|

### Verificação
*(Trecho **e** ponteiro, sempre os dois — R28. O log bruto inteiro fica no arquivo, não aqui.)*

| Comando | Código de saída | Trecho decisivo (literal, recortado) | Ponteiro |
|---|---|---|---|
| `<comando de build>` | <n> | `<linha de resumo: erros e avisos>` | `.team-project/operator/<sprint>/<T-ID>/build.log` — <n> linhas *(build de fim de passo: isento de `report`)* |
| `<comando de teste>` | <n> | `<X passed, Y failed, Z skipped>` | `.team-project/operator/<sprint>/<T-ID>/report.md` *(ou `report-<log>.md`)* |
| `<comando do gate de cobertura da unidade tocada — back-end, worker ou front-end>` | <n> | `<percentual do pior módulo × limiar e resultado do gate>` | `.team-project/operator/<sprint>/<T-ID>/report.md` *(ou `report-<log>.md`)* |

**Falhou algum comando** — o trecho do log que localiza a causa, literal:
```
<primeira linha de erro por arquivo; ou nome do teste que falhou + a asserção que falhou>
```

### Execução delegada
*(uma linha por chamada ao `operator`, com os números que a chamada devolveu ao terminar. Sem número: "não disponível — <motivo>", nunca estimado (R7). Sem chamada: "nenhuma". Não gravo em `consumption.md` — a sessão que disparou o `/dev` transcreve.)*

| Operator job | Task/História | Modelo | Tokens | Duração |
|---|---|---|---|---|
| `.team-project/operator/<sprint\|pre-sprint>/<job>/` — `<log>` | <T-ID / H-ID> | <`model:` de `agents/operator.md`> | <n ou "não disponível — motivo"> | <tempo ou "não disponível — motivo"> |

### Gaps levantados
<🔺 GAP … ou "nenhum". Marcar o tipo de cada um — `plano` ou `standard`>

### Não fiz (fora do plano)
<o que percebi mas não toquei — R4>

### Parei no passo
<n> — estado do repositório: <compila? testes passam?>
```

## Regras

- **Saída real, sempre — em trecho e ponteiro** (R7 · R28). "Build ok" sem saída não conta; log inteiro colado também não, e só o caminho do arquivo muito menos. Cada comando entra com **código de saída**, **trecho decisivo literal** e **ponteiro do `report` do job** — `report.md`, ou `report-<log>.md` quando há mais de uma chamada na pasta (R28). `report` ausente é entrega sem evidência (R7); o **build de fim de passo**, meu, é **isento de `report`** e entra com o caminho do log. Log podado não é achado. Trecho sem ponteiro impede o QA de auditar e o PO de conferir na Review. Se falhou, mostrar a falha. O que recortar de cada tipo de comando está em [`../skills.md`](../skills.md) §6. O log em `.team-project/operator/<sprint>/<T-ID>/` é **registro de execução, não entrega**: não entra em CRIADOS/ALTERADOS/REMOVIDOS.
- **Gate de qualidade não some do relatório.** Gate desligado, afrouxado, removido do build, trocado por outro comando, contornado por configuração ou **não exercitado** aparece aqui como 🔺 GAP **e** na seção Verificação, com o motivo — e a entrega não se declara concluída nessa condição (R7 · R23). Nenhum dos dois estados se resolve no relatório: os dois sobem ao Arquiteto.
- **Cobertura é saída, não alegação.** Toda Task que altera código de produção — **inclusive front-end** — traz a saída do gate de 80% da unidade que tocou, na mesma forma das demais: trecho (pior módulo × limiar) **e** ponteiro. Sem ela, o QA trata como não verificado (`${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §5.4/§5.5).
- **Execução delegada é retratada, não gravada.** Cada chamada ao `operator` vira uma linha, com os números que a própria chamada devolveu — o que permite ver, por Task, o meu consumo × o do `operator`. Número que não voltou é "não disponível — <motivo>", nunca estimado (R7); o build de fim de passo que rodei eu mesmo (skills §6) não entra, porque não foi chamada ao `operator`. Quem grava em `consumption.md` é a sessão que me disparou, não eu.
- **Grupo vazio é declarado**, não omitido — evita ambiguidade na hora do QA.
- **GAP de tipo `standard` fica no relatório mesmo depois de respondido** (R16). A decisão do Arquiteto desbloqueia a Task; o defeito no documento só se fecha no `/review` seguinte, e o relatório é a trilha que garante que ele chegue lá. Citar `<arquivo do standard> §<n>`.
- **Nenhum arquivo de `${CLAUDE_PLUGIN_ROOT}/standards/` aparece em CRIADOS/ALTERADOS/REMOVIDOS.** O dev consome o normativo, não o edita — a caneta é do Arquiteto (R16).
- **"Não fiz (fora do plano)"** é obrigatório: é onde o time descobre gap de escopo sem que ninguém tenha antecipado nada.
- **"Parei no passo"** é obrigatório mesmo quando terminou tudo (`<m> de <m>` — repositório íntegro). Quando **não** terminou, esta linha é o insumo do Arquiteto para **reescrever o plano no sprint seguinte** se a Task for retomada — diga o passo **e** o estado do repositório, não só o número.
- **Nenhum arquivo de `.team-project/sprints/<n>/` nem de `.team-project/fixes/` aparece em CRIADOS/ALTERADOS/REMOVIDOS.** A pasta do sprint é registro do time — `plan/` é do Arquiteto, `stories/` do PO, `evidence/` do QA, o resto do SM; a do bloco também — `plan.md` do Arquiteto, `verdict.md` do QA, o resto do SM. Eu leio o plano; a minha entrega é código, testes e este relatório.

Os comandos de verificação do projeto estão em `.team-project/developer/context.md`.

## Variante trilha `fix` (R33)

Um relatório **por bloco**, com **uma seção por F-ID**, na ordem do `plan.md` — inclusive a que parou em 🔺 GAP ou foi promovida no meu turno. O QA copia o **Antes** daqui para o veredito da F-ID; por isso a forma é a mesma da variante fix de `verdict.md` (`**Antes:** exit <n>` / `> <comando>` / saída). Roteiro: [`../README.md`](../README.md) §"Trilha `fix`".

```markdown
## Entrega — B-<nnn> · trilha fix

**Mini-planos:** `.team-project/fixes/B-<nnn>/plan.md` · **Correções entregues:** <n> de <m>

### F-<nnn> · <título>
**Estado:** entregue | parada no passo <n> (🔺 GAP) | promovida — diff desfeito (<git restore | git revert <sha> | trechos do checkpoint repostos>)
**Commit:** <sha — `F-<nnn>: <título>`; retrabalho: um sha por linha, o mais recente primeiro> | n/a — sem git · checkpoint: `.team-project/operator/B-<nnn>/F-<nnn>/checkpoint.md`
**ALTERADOS:** <caminho> — <o que mudou, em uma frase> · **CRIADOS:** <só o arquivo de teste, ou "nenhum">

**Teste de regressão: saída antes / saída depois**
**Antes:** exit <n≠0>
> <comando "só este teste", como está no mini-plano>
<nome do teste + a asserção que falhou, literal> · log: `.team-project/operator/B-<nnn>/F-<nnn>/regressao-antes.log`
**Depois:** exit 0
> <o mesmo comando>
<a linha de contagem, literal> · log: `.team-project/operator/B-<nnn>/F-<nnn>/regressao-depois.log`

**Build de fim de F-ID:** exit <n> · `<linha de resumo>` · log: `<caminho>`

### Verificação do bloco
*(a tabela "Verificação" do modelo acima, uma vez, com os comandos da seção de mesmo nome do `plan.md` — suíte e gate do módulo pelo `operator`, ponteiro `.team-project/operator/B-<nnn>/bloco/report-<log>.md`)*

### Execução delegada
*(como no modelo acima; coluna Task/História recebe `B-<nnn>`, ou `F-<nnn>` quando a chamada serviu a uma só)*

### Gaps levantados
### Não fiz (fora do plano)
### Parei em
F-<nnn>, passo <n> — estado do repositório: <compila? testes passam? diff da F-ID commitado, pendente ou desfeito?>
```

Regras da variante, além das de cima:

- **"Teste de regressão: saída antes / saída depois" é obrigatório por F-ID entregue.** `Antes` com exit ≠ 0 **pela asserção que o mini-plano declarou** — falha de compilação, import ou símbolo ausente não conta — e `Depois` com exit 0, os dois com o comando colado e o trecho literal. Faltou um dos dois, a F-ID não está entregue: é 🔺 GAP, não ressalva (R7 · R33).
- **Um diff por F-ID:** o commit dela tem **só** os arquivos de `### Arquivos` do mini-plano — o C4 compara os dois. Sem git, o checkpoint existe **antes** da primeira edição e traz os trechos originais literais.
- **Promoção não some do relatório:** a F-ID promovida no meu turno aparece com o estado, o critério que o Arquiteto declarou e **como** o diff foi desfeito.

## Exemplo

```markdown
## Entrega — ABC-02 Chave de assinatura obrigatória

**Passos concluídos:** 4 de 4

**CRIADOS**
- `<projeto>/Tests/Unit/UrlSignerTests.cs` — 3 casos de assinatura

**ALTERADOS**
- `<projeto>/Infrastructure/Storage/StorageOptions.cs` — chave passa a ser obrigatória e validada
- `<projeto>/Api/Program.cs` — validação das opções no start
- `<infra>/.env.Development` — chave de desenvolvimento adicionada

**REMOVIDOS** — nenhum arquivo nesta categoria

### Testes adicionados
| Arquivo | Nome | Caso coberto |
|---|---|---|
| `UrlSignerTests.cs` | `Assinatura_ComCaminhoAlterado_DeveSerInvalida` | adulteração do caminho assinado |

### Verificação
| Comando | Código de saída | Trecho decisivo | Ponteiro |
|---|---|---|---|
| `<build>` | 0 | `Build succeeded. 0 Warning(s) 0 Error(s)` | `.team-project/operator/3/ABC-02/build.log` — 412 linhas |
| `<teste>` | 0 | `Passed! - Failed: 0, Passed: 311, Skipped: 0` | `.team-project/operator/3/ABC-02/report-test.md` |
| `<gate de cobertura>` | 0 | `pior módulo 84,2% ≥ 80% — gate ok` | `.team-project/operator/3/ABC-02/report-coverage.md` |

### Execução delegada
| Operator job | Task/História | Modelo | Tokens | Duração |
|---|---|---|---|---|
| `.team-project/operator/3/ABC-02/` — `test.log` | ABC-02 | haiku | 21.480 | 3 min 12 s |
| `.team-project/operator/3/ABC-02/` — `coverage.log` | ABC-02 | haiku | 9.905 | não disponível — a chamada terminou sem devolver a duração |

*(o `build.log` não aparece aqui: foi o build de fim de passo, rodado por mim com a saída redirecionada — não foi chamada ao `operator`, e por isso o build é isento de `report`.)*

### Gaps levantados
nenhum

### Não fiz (fora do plano)
A configuração ainda aponta para uma rota de download que não existe — é a Task seguinte (ABC-01), não toquei.

### Parei no passo
4 de 4 — repositório compila, todos os testes passam.
```
