# Qualidade de Código — Perfil de Stack Kotlin/Android (KA-Q)

> **Nível 2** das regras verificáveis de [`../../implementation-principles.md`](../../implementation-principles.md) §7 (Q1–Q23): **com qual ferramenta e com qual comando** num app Android em Kotlin. O comando vai no `.team-project/guards.json` (`verify`, `quality`, `targets`) e é o que `scripts/checks/verify.ps1`, `quality.ps1` e `accept.ps1` rodam. Guia de escrita: [`guide.md`](guide.md).

## KA-Q1 Ferramenta por regra

| Regra (nível 1) | Ferramenta | Comando (Gradle) | **Ecossistema restrito** (só AndroidX, sem plugin de terceiros) |
|---|---|---|---|
| Q11 cobertura ≥ 80 % por módulo | Kover ou JaCoCo com regra de limite | `./gradlew koverVerify` · `./gradlew jacocoTestCoverageVerification` | JaCoCo (vem com o Android Gradle Plugin): `JacocoCoverageVerification` com `element = "PACKAGE"` e `LINE` ≥ 0.80 |
| Q1 regra de dependência | Konsist ou ArchUnit | `./gradlew testDebugUnitTest --tests *Arquitetura*` | o teste JUnit de imports do [`guide.md`](guide.md) KA-2 |
| Q7 lint e formatação | detekt + ktlint (ou `ktlintCheck`) + Android Lint | `./gradlew detekt ktlintCheck lintDebug` | Android Lint com `abortOnError = true` + `.editorconfig` com o estilo oficial do Kotlin |
| Q6 limites numéricos (§4.4) | detekt (`complexity`: `CyclomaticComplexMethod` 10, `LongMethod` 50, `LongParameterList` 4) | `./gradlew detekt` | sem ferramenta: o QA confere na revisão (declarar "não aplicável" e o substituto na Ficha, V13) |
| Q8 duplicação | detekt (regras de duplicação) ou CPD | `./gradlew detekt` | revisão de aderência do QA (V9 "não aplicável" + substituto) |
| Q9 TODO com ID · Q17 supressão justificada | `quality.ps1` (busca por padrão) | — | igual |
| Q23 render (layout novo) | Compose UI Test medindo caixas em 3 escalas de fonte | `./gradlew connectedDebugAndroidTest` | igual |

## KA-Q2 `guards.json` de referência

```json
"verify": {
  "focused": "./gradlew testDebugUnitTest {tests}", "testItem": "--tests {class}", "testRoot": "",
  "build": "./gradlew assembleDebug", "lint": "./gradlew lintDebug", "suite": "./gradlew testDebugUnitTest",
  "coverage": "./gradlew jacocoTestCoverageVerification",
  "timeoutMinutes": 9, "env": { "GRADLE_USER_HOME": "C:\\gradle-home" },
  "daemon": true, "compile": "./gradlew compileDebugUnitTestKotlin"
},
"quality": {
  "coverage": "./gradlew jacocoTestReport jacocoTestCoverageVerification", "coverageThreshold": 80,
  "lint": "./gradlew lintDebug", "architecture": "./gradlew testDebugUnitTest --tests *Arquitetura*",
  "metrics": "./gradlew detekt", "sourceRoots": ["app/src/main"]
},
"targets": { "android": { "package": "<applicationId>", "apk": "app/build/outputs/apk/release/app-release.apk", "avd": "<nome do AVD>", "maxUptimeHours": 24 } }
```

Emulador em container (v3.53.2 · v3.53.6): no lugar de `avd`, `"repair": "docker restart <container>; adb connect localhost:5555"`, `"serial": "localhost:5555"` e, opcionais, `"memoryCmd": "docker stats --no-stream --format '{{.MemUsage}}' <container>"` com `"maxMemoryMB": 3072` (acima do limite o pré-voo reprova e o repair roda) e `"freshStart": false` para não reiniciar o emulador no primeiro `accept` de cada Task (o padrão, com `repair`, é reiniciar).

- O `verify.ps1` acrescenta sozinho a higiene do Gradle (sem daemon, compilador Kotlin em processo) e encerra a árvore de processos no fim (`scripts/checks/tool-hygiene.json`).
- **`"daemon": true`** (v3.51.4, opcional): o daemon do Gradle **ligado só durante a chamada do `verify.ps1`** — o build, a suíte e cada mutação da mesma chamada o reaproveitam (sem a partida a frio de cada comando, a maior parte dos 7–10 min por chamada medidos no SunScape) e o script o encerra antes de devolver o controle. Sem a chave, vale o padrão de antes (sem daemon). Ligue num projeto e compare o tempo em `verify/<n>/<T-ID>/time.jsonl` (o `kanban.md` mostra a "Espera de comando").
- **`"compile"`** (v3.51.4, opcional): o comando que só compila (código e testes); o `verify.ps1 -Mode mutation -Precheck` aplica cada mutante e confere que ele compila, antes da mutação de verdade.
- **`-Mode full` em fatias** (v3.51.4): build + suíte passam dos 10 min da ferramenta; o `verify.ps1` para em `-MaxMinutes` (padrão 8) com exit 3 e o mesmo comando continua de onde parou.
- **Perfil do Windows com acento:** `GRADLE_USER_HOME` numa junção ASCII em `verify.env` (`how-to.md` §Ambiente de execução).

## KA-Q3 Ficha de Vinculação pré-preenchida

Copie para o documento de arquitetura do produto (§2b ou equivalente) e ajuste os nomes; uma linha "não aplicável" sempre traz o substituto.

| # | Vinculação | Kotlin/Android |
|---|---|---|
| V1–V4 | Anéis | `<app>.dominio` · `<app>.aplicacao` (portas em `aplicacao.portas`) · `<app>.dados` · `<app>.ui` |
| V5 | Unidades implantáveis | o APK `:app`; módulos de teste (`:e2e`, `:benchmark`) não são implantáveis |
| V6 | Regra de dependência | KA-Q1, linha Q1 |
| V7 | Formatter | ktlint · restrito: `.editorconfig` (protegido) + Android Lint |
| V8 | Linter | detekt + Android Lint (`abortOnError = true`) |
| V9 | Duplicação | detekt/CPD · restrito: revisão do QA |
| V10 | Runner por nível | unidade e arquitetura JUnit (JVM); integração e UI AndroidX Test (emulador); cenários `accept.ps1` |
| V11–V12 | Cobertura e gate | JaCoCo/Kover, mínimo por pacote, `LINE` ≥ 0.80, comando de KA-Q2 |
| V13 | Métricas | detekt `complexity` · restrito: revisão do QA com os limites de §4.4 |
| V14 | CI | estágios locais: `assembleDebug` → `lintDebug` → `testDebugUnitTest` → cobertura → `connectedDebugAndroidTest` |
| V15 | Exclusões de cobertura | gerados (`*_Impl`, `BuildConfig`, `R`, `ComposableSingletons*`) e o ponto de composição |
| V16 | Ponto de composição | `Conteiner` criado em `Application.onCreate` (ou o grafo do Hilt) |
| V17 | Pipeline transversal | log e validação na aplicação; sem autenticação local, "não aplicável" |
| V18–V21 | Desempenho | arranque a frio (`am start -W`, mediana de 3), tamanho do APK; ambiente = o AVD de referência |
| V22 | Render | Compose UI Test com caixas medidas em 3 escalas de fonte (sem navegador: o próprio emulador é o render real) |

## KA-Q4 Ids de teste (v3.53.6, regra que reprova o verify)

Pedido do stakeholder depois do sprint 5 do garden ("nunca mais termos problema durante as rotinas de QA"): o identificador de teste é padrão de código, conferido pela máquina, não pela revisão.

| O que reprova o `verify.ps1 -Mode full` (chave `testids`, exit 1) | Saída |
|---|---|
| id citado num cenário de tela da Task (`.scn` do QA, sem `(teste)` e sem `# aguarda` de outra Task) que não existe **literalmente** no código de produção — string do `testTag`, constante, ou prefixo de id dinâmico (`"lista.item.$id"`) | o id, o cenário e `arquivo.scn:linha` |
| `Button(`, `IconButton(`, `TextButton(`, `OutlinedButton(`, `ElevatedButton(`, `FloatingActionButton(`, `TextField(`, `OutlinedTextField(`, `Checkbox(`, `Switch(`, `RadioButton(`, `Slider(`, chips, `NavigationBarItem(`, `Tab(`, `DropdownMenuItem(` sem `testTag(` nos argumentos da chamada | `arquivo:linha` |
| `.clickable` / `.toggleable` / `.selectable` / `.combinedClickable` sem `testTag(` na chamada que recebe a cadeia de modifier | `arquivo:linha` |
| `items(` / `itemsIndexed(` de `LazyColumn`/`LazyRow`/grade sem `testTag(` no item | `arquivo:linha` |

- **Onde:** os arquivos `.kt` de **Arquivos tocados:** do plano (sem plano, os mudados no git), fora de `src/test`, `src/androidTest`, `build/` e gerados.
- **Exceção explícita:** `// sem-testid: <motivo>` na linha da chamada ou na anterior — sem motivo, continua reprovando. Uso típico: componente próprio que repassa o `modifier` do chamador (o `testTag` vai na chamada do componente); `@Preview`.
- **Antes do `accept`:** o APK do disco mais velho que o código do módulo sai com exit 2 ("reconstrua (assembleDebug) antes do accept") — o id criado só existe no app depois do build.
