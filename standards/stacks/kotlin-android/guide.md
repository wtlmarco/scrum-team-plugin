# Guia de Implementação — Perfil de Stack Kotlin/Android (KA)

> **Nível 2** de [`../../implementation-principles.md`](../../implementation-principles.md) (Clean Architecture · Clean Code · testes com gate de 80 %): aquele documento diz **o que** precisa ser verdade em qualquer linguagem; este diz **como se escreve num app Android em Kotlin**. Onde divergirem, o nível 1 vence. Ferramentas, comandos e a Ficha pré-preenchida: [`quality.md`](quality.md).
> **Stack alvo:** Kotlin 2.x · Android SDK 34+ · Jetpack Compose · Coroutines/Flow · Room/DataStore · Gradle (Kotlin DSL).
> **Identificadores:** cada seção tem um ID estável (`KA-<n>`). O plano e o veredito citam o ID; o dev e o QA leem só a seção citada.

## KA-1 Os anéis no projeto

| Anel (nível 1 §2.1) | Pacote | O que pode importar |
|---|---|---|
| Domínio | `<app>.dominio` (ou `domain`) | só Kotlin padrão — **nunca** `android.*`, `androidx.*`, Room, rede |
| Aplicação | `<app>.aplicacao` (portas em `aplicacao.portas`) | domínio; corrotinas (`kotlinx.coroutines`) |
| Adaptadores | `<app>.dados` (Room, DataStore, rede, relógio do sistema) | aplicação e domínio; bibliotecas de infraestrutura |
| Borda | `<app>.ui` (Activity, Compose, ViewModel) | aplicação e domínio, nunca `dados` direto |

- **Um módulo Gradle (`:app`) com os quatro pacotes** basta para app pequeno; módulos separados (`:domain`, `:data`) quando o build ou a equipe pedirem. A regra de dependência vale nos dois casos (KA-2).
- **Relógio, aleatoriedade e identificadores são portas** (`Relogio`, `GeradorDeId`): o domínio nunca chama `System.currentTimeMillis()` nem `LocalDate.now()`. É o que deixa os cenários com data controlada passarem no emulador e nos testes.

## KA-2 Regra de dependência verificada

Um **teste de arquitetura** roda junto com os testes de unidade e falha com import proibido (nível 1 §2.3, Q1):
- Com ferramenta: Konsist ou ArchUnit (`kotlin`), uma regra por fronteira.
- **Ecossistema restrito** (projeto que só permite AndroidX): um teste JUnit que lê os `.kt` de `src/main` e falha quando um arquivo de `dominio` importa `android.`, `androidx.` ou `<app>.dados`, e quando `ui` importa `<app>.dados`. Foi o que o benchmark usou e funciona.

## KA-3 Estado e efeitos

- **ViewModel com `StateFlow` de um estado imutável** (`data class` com os campos da tela); a tela só lê o estado e envia eventos. Regra de negócio **não** fica no Composable nem no ViewModel: o ViewModel chama um caso de uso.
- **Corrotinas com dispatcher injetado** (`CoroutineDispatcher` no construtor), para o teste usar `StandardTestDispatcher`.
- **Efeito de uma vez** (navegar, mostrar mensagem) por `Channel`/`SharedFlow`, nunca por um campo do estado que precisa ser "limpo".
- **Processo morto e recriado** (o sistema mata o app em segundo plano): o estado que o usuário espera ver volta do `SavedStateHandle` ou do armazenamento — nunca só da memória.

## KA-4 Ponto de composição

Um lugar só monta as dependências (nível 1, V16): um `Conteiner` criado em `Application.onCreate` (injeção manual) ou o grafo do Hilt. Composable e ViewModel recebem dependências prontas; ninguém instancia adaptador no meio do código.

## KA-5 Persistência

- **Room** para dados estruturados, com **migration escrita e testada** a cada mudança de esquema (teste instrumentado `MigrationTestHelper`); **DataStore** para preferências. Uma migration por Task (plano, regra 4).
- Repositório (adaptador) implementa a porta da aplicação e devolve tipos do domínio — a entidade do Room nunca sai do pacote `dados`.

## KA-6 Interface, acessibilidade e identificadores de teste

- **Todo controle interativo e todo item de lista tem `Modifier.testTag("<área>.<elemento>[.<id>]")`** (ex.: `destino.card.paraty`), e a raiz liga `Modifier.semantics { testTagsAsResourceId = true }` — é assim que o executor de cenários (`scripts/checks/accept.ps1`, alvo android) e o uiautomator acham os elementos. O contrato de teste do pedido manda nos nomes.
- **Acessibilidade:** `contentDescription` em ícone que age; alvo de toque ≥ 48 dp; a tela funciona com a fonte do sistema a 200 % (teste de UI com `fontScale = 2f`); contraste conforme a especificação de tela.
- **Texto da interface em `strings.xml`** (o lint `HardcodedText` como erro): mensagem é contrato, tem um lugar só.

## KA-7 Testes por nível

| Nível (nível 1 §5.1) | Onde | Ferramenta | Roda em |
|---|---|---|---|
| Unidade (domínio, aplicação, ViewModel) | `src/test` | JUnit 4/5 + `kotlinx-coroutines-test` | JVM, todo `verify` |
| Arquitetura | `src/test/.../arquitetura` | KA-2 | JVM |
| Integração (Room, DataStore) | `src/androidTest` | AndroidX Test | emulador |
| UI (Compose) | `src/androidTest` | Compose UI Test (`createAndroidComposeRule`) | emulador |
| Cenários de aceite | `.team-project/quality-assurance/scenarios/*.scn` | `accept.ps1` (uiautomator) | emulador, com captura |
| Render (layout novo) | `src/androidTest` | Compose UI Test medindo `getBoundsInRoot()` em 3 escalas de fonte | emulador |

- **Teste pelo risco** (plano, regra 24): regra de negócio com teste completo e mutação; tela simples com o teste de UI do contrato e os cenários.
- **Nome:** `cenario_condicao_resultado` ou crase (`` `abre em Sao Paulo com raio 150` ``).

## KA-8 Desempenho e entrega

- **Arranque a frio** medido por `adb shell am start -W` (mediana de 3, emulador limpo) ou Macrobenchmark; **tamanho do APK** de release pelo `apkanalyzer` ou pelo tamanho do arquivo. São as linhas de V18/V19 quando o pedido traz RNF.
- **O artefato entregue é o `assembleRelease` do código final** — o executor de cenários instala o release, não o debug, no portão do QA.
