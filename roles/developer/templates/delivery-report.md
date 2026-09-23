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

| Comando | Código de saída | Trecho decisivo (literal, recortado) | Log bruto |
|---|---|---|---|
| `<comando de build>` | <n> | `<linha de resumo: erros e avisos>` | `.team-project/operator/<sprint>/<T-ID>/build.log` — <n> linhas |
| `<comando de teste>` | <n> | `<X passed, Y failed, Z skipped>` | `<caminho>.log` — <n> linhas |
| `<comando do gate de cobertura da unidade tocada — back-end, worker ou front-end>` | <n> | `<percentual do pior módulo × limiar e resultado do gate>` | `<caminho>.log` — <n> linhas |

**Falhou algum comando** — o trecho do log que localiza a causa, literal:
```
<primeira linha de erro por arquivo; ou nome do teste que falhou + a asserção que falhou>
```

### Gaps levantados
<🔺 GAP … ou "nenhum". Marcar o tipo de cada um — `plano` ou `standard`>

### Não fiz (fora do plano)
<o que percebi mas não toquei — R4>

### Parei no passo
<n> — estado do repositório: <compila? testes passam?>
```

## Regras

- **Saída real, sempre — em trecho e ponteiro** (R7 · R28). "Build ok" sem saída não conta; log inteiro colado também não, e só o caminho do arquivo muito menos. Cada comando entra com **código de saída**, **trecho decisivo literal** e **caminho do log bruto** — que precisa existir: ponteiro que não resolve é achado de processo, e trecho sem ponteiro impede o QA de auditar e o PO de conferir na Review. Se falhou, mostrar a falha. O que recortar de cada tipo de comando está em [`../skills.md`](../skills.md) §6. O log em `.team-project/operator/<sprint>/<T-ID>/` é **registro de execução, não entrega**: não entra em CRIADOS/ALTERADOS/REMOVIDOS.
- **Gate de qualidade não some do relatório.** Gate desligado, afrouxado, removido do build, trocado por outro comando, contornado por configuração ou **não exercitado** aparece aqui como 🔺 GAP **e** na seção Verificação, com o motivo — e a entrega não se declara concluída nessa condição (R7 · R23). Nenhum dos dois estados se resolve no relatório: os dois sobem ao Arquiteto.
- **Cobertura é saída, não alegação.** Toda Task que altera código de produção — **inclusive front-end** — traz a saída do gate de 80% da unidade que tocou, na mesma forma das demais: trecho (pior módulo × limiar) **e** ponteiro. Sem ela, o QA trata como não verificado (`${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §5.4/§5.5).
- **Grupo vazio é declarado**, não omitido — evita ambiguidade na hora do QA.
- **GAP de tipo `standard` fica no relatório mesmo depois de respondido** (R16). A decisão do Arquiteto desbloqueia a Task; o defeito no documento só se fecha no `/review` seguinte, e o relatório é a trilha que garante que ele chegue lá. Citar `<arquivo do standard> §<n>`.
- **Nenhum arquivo de `${CLAUDE_PLUGIN_ROOT}/standards/` aparece em CRIADOS/ALTERADOS/REMOVIDOS.** O dev consome o normativo, não o edita — a caneta é do Arquiteto (R16).
- **"Não fiz (fora do plano)"** é obrigatório: é onde o time descobre gap de escopo sem que ninguém tenha antecipado nada.
- **"Parei no passo"** é obrigatório mesmo quando terminou tudo (`<m> de <m>` — repositório íntegro). Quando **não** terminou, esta linha é o insumo do Arquiteto para **reescrever o plano no sprint seguinte** se a Task for retomada — diga o passo **e** o estado do repositório, não só o número.
- **Nenhum arquivo de `.team-project/sprints/<n>/` aparece em CRIADOS/ALTERADOS/REMOVIDOS.** A pasta do sprint é registro do time — `plan/` é do Arquiteto, `stories/` do PO, `evidence/` do QA, o resto do SM. Eu leio o plano; a minha entrega é código, testes e este relatório.

Os comandos de verificação do projeto estão em `.team-project/developer/context.md`.

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
| Comando | Código de saída | Trecho decisivo | Log bruto |
|---|---|---|---|
| `<build>` | 0 | `Build succeeded. 0 Warning(s) 0 Error(s)` | `.team-project/operator/3/ABC-02/build.log` — 412 linhas |
| `<teste>` | 0 | `Passed! - Failed: 0, Passed: 311, Skipped: 0` | `.team-project/operator/3/ABC-02/test.log` — 1.184 linhas |
| `<gate de cobertura>` | 0 | `pior módulo 84,2% ≥ 80% — gate ok` | `.team-project/operator/3/ABC-02/coverage.log` — 96 linhas |

### Gaps levantados
nenhum

### Não fiz (fora do plano)
A configuração ainda aponta para uma rota de download que não existe — é a Task seguinte (ABC-01), não toquei.

### Parei no passo
4 de 4 — repositório compila, todos os testes passam.
```
