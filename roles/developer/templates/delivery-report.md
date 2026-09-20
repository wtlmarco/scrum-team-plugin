# Template — Relatório de Entrega

Fecha toda execução de `/dev <ID>`. É o que o Arquiteto revisa e o QA usa como ponto de partida.

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
```
> <comando de build>
<saída real>

> <comando de teste>
<saída real: X passed, Y failed, Z skipped, N warnings>

> <comando do gate de cobertura da unidade tocada — back-end, worker ou front-end>
<saída real: percentual por módulo e resultado do gate>
```

### Gaps levantados
<🔺 GAP … ou "nenhum". Marcar o tipo de cada um — `plano` ou `standard`>

### Não fiz (fora do plano)
<o que percebi mas não toquei — R4>

### Parei no passo
<n> — estado do repositório: <compila? testes passam?>
```

## Regras

- **Saída real, sempre** (R7). "Build ok" sem saída não conta; se falhou, mostrar a falha.
- **Gate de qualidade não some do relatório.** Gate desligado, afrouxado, removido do build, trocado por outro comando, contornado por configuração ou **não exercitado** aparece aqui como 🔺 GAP **e** na seção Verificação, com o motivo — e a entrega não se declara concluída nessa condição (R7 · R23). Nenhum dos dois estados se resolve no relatório: os dois sobem ao Arquiteto.
- **Cobertura é saída, não alegação.** Toda Task que altera código de produção — **inclusive front-end** — traz a saída do gate de 80% da unidade que tocou. Sem ela, o QA trata como não verificado (`${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §5.4/§5.5).
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
```
> <build>
Build succeeded. 0 Warning(s) 0 Error(s)

> <teste>
Passed! - Failed: 0, Passed: 311, Skipped: 0
```

### Gaps levantados
nenhum

### Não fiz (fora do plano)
A configuração ainda aponta para uma rota de download que não existe — é a Task seguinte (ABC-01), não toquei.

### Parei no passo
4 de 4 — repositório compila, todos os testes passam.
```
