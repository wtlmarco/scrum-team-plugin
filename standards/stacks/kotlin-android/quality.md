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
  "timeoutMinutes": 9, "env": { "GRADLE_USER_HOME": "C:\\gradle-home" }
},
"quality": {
  "coverage": "./gradlew jacocoTestReport jacocoTestCoverageVerification", "coverageThreshold": 80,
  "lint": "./gradlew lintDebug", "architecture": "./gradlew testDebugUnitTest --tests *Arquitetura*",
  "metrics": "./gradlew detekt", "sourceRoots": ["app/src/main"]
},
"targets": { "android": { "package": "<applicationId>", "apk": "app/build/outputs/apk/release/app-release.apk", "avd": "<nome do AVD>", "maxUptimeHours": 24 } }
```

- O `verify.ps1` acrescenta sozinho a higiene do Gradle (sem daemon, compilador Kotlin em processo) e encerra a árvore de processos no fim (`scripts/checks/tool-hygiene.json`).
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
