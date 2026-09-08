# Qualidade de Código — Analysis, Coverage e Metrics · Perfil de Stack .NET

**Versão:** 1.4
**Data:** 06/09/2026
**Status:** Draft normativo
**Nível:** 2 — perfil de stack
**Stack alvo:** .NET 10 · xUnit · GitLab CI

> **Este documento é a vinculação .NET/GitLab dos gates definidos no nível 1**, [`implementation-principles.md`](implementation-principles.md) §4 (limites de Clean Code), §5 (testes e cobertura de 80%) e §7 (quadro de verificação). Aquele documento diz **qual** gate precisa existir e **o que ele bloqueia**; este diz **com qual ferramenta e em qual estágio**.
>
> **Precedência:** onde este perfil divergir do nível 1, o nível 1 vence. Divergência conhecida e ainda não resolvida fica registrada em "Decisões Pendentes", nunca em silêncio.
>
> **Decisão do stakeholder em 02/09/2026, já refletida neste documento:** o gate de 80% é **mínimo por módulo** (`ThresholdStat=minimum`), e cobre **toda unidade implantável e todos os anéis — front-end incluído**, não apenas `Domain`/`Application`.
>
> Guia normativo de qualidade, **agnóstico de produto**, complementar ao [`implementation-guide.md`](implementation-guide.md), com configuração detalhada de ferramentas e pipeline de qualidade. Assim como o guia de implementação, este documento não contém nomes de entidades, integrações ou regras de negócio de nenhum produto específico — a aplicação real (thresholds ajustados, exceções aprovadas, stages adicionais) é decidida e documentada no documento de arquitetura de cada produto.

---

## Documentos relacionados

| Documento | Conteúdo |
|---|---|
| [`implementation-principles.md`](implementation-principles.md) | **Nível 1** — limites de Clean Code (§4.4), gate de cobertura de 80% (§5.4), **desempenho: RNF verificável, orçamento e regressão (§5.6)** e quadro de verificação (§7) |
| [`implementation-guide.md`](implementation-guide.md) | Estrutura de código, CQRS, isolamento multi-tenant/projeto, adaptadores de IA, logging, configuração, testes |

---

## Decisões Pendentes

| Referência | Assunto | Status |
|---|---|---|
| ~~COVERAGE-STAT~~ | **Resolvida** — 02/09/2026, stakeholder: mínimo por módulo (`ThresholdStat=minimum`). Aplicada em §2 e §4 | Fechada |
| ~~COVERAGE-SCOPE~~ | **Resolvida** — 02/09/2026, stakeholder: o gate cobre todos os anéis e todas as unidades implantáveis, front-end incluído. Aplicada em §2 e §4.1 | Fechada |
| COVERAGE-DIFF | Ferramenta de cobertura **do diff** (código novo/alterado ≥ 80%, nível 1 §5.4) ainda não escolhida para este perfil | Definição Futura |
| DUPLICATION | Detector de duplicação e limite de bloco (nível 1 §4.3) ainda não escolhido para este perfil | Definição Futura |
| ~~PERF-TEST~~ | **Resolvida** — 06/09/2026, Arquiteto: **k6** (borda HTTP) / **NBomber** (não-HTTP); forma do cenário em [`implementation-guide.md`](implementation-guide.md) §9.6; gate de orçamento e gate de regressão em §4.2 abaixo; obrigação e verificação no nível 1 §5.6. **Os números (limiar, carga, ambiente) são de cada projeto**, na Ficha V18–V21 — não deste perfil | Fechada |

---

## Visão Geral — Quatro Ferramentas, Quatro Propósitos

| Ferramenta | Propósito | Quando executa | Bloqueia merge? |
|---|---|---|---|
| **Code Analysis** (Roslyn Analyzers) | Detecta problemas no código-fonte em tempo de compilação: bugs potenciais, violações de estilo, más práticas | Build (todo commit) | Sim — warnings tratados como errors |
| **Code Coverage** (Coverlet + ReportGenerator) | Mede quais linhas/branches são exercitadas pelos testes | Após execução dos testes unitários | Sim — abaixo do threshold definido |
| **Code Metrics** (Microsoft.CodeAnalysis.Metrics) | Mede complexidade ciclomática, Maintainability Index, acoplamento | Build (target `Metrics`) | Sim — abaixo dos limites definidos |
| **Load Testing** (k6 · NBomber) | Mede a latência das operações sob orçamento de desempenho (nível 1 §5.6, Ficha V18) sob a carga declarada | Merge para `main` e toda Task que toca operação de V18 | Sim — limiar violado, ou regressão acima da margem medida |

---

## 1. Code Analysis — Roslyn Analyzers

### O que é

O Roslyn é o compilador do .NET e expõe uma API de análise estática. Pacotes de analyzers se plugam a ele e reportam diagnósticos durante o `dotnet build` — não é uma ferramenta separada, roda embutido no build.

### Pacotes recomendados

```xml
<!-- Em cada .csproj de produção (não em projetos de teste) -->
<TaskGroup>
  <!-- Analyzers oficiais Microsoft — habilitados por padrão no .NET 10 -->
  <PackageReference Include="Microsoft.CodeAnalysis.NetAnalyzers"
                    Version="*" PrivateAssets="all" />

  <!-- Análise de estilo e nomenclatura -->
  <PackageReference Include="StyleCop.Analyzers"
                    Version="*" PrivateAssets="all" />

  <!-- Análise de segurança -->
  <PackageReference Include="SecurityCodeScan.VS2019"
                    Version="*" PrivateAssets="all" />
</TaskGroup>
```

### Configuração no `Directory.Build.props` (raiz da solution)

Aplica a todos os projetos automaticamente:

```xml
<Project>
  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>

    <!-- Trata warnings de analyzer como erro — bloqueia build sujo -->
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <EnforceCodeStyleInBuild>true</EnforceCodeStyleInBuild>

    <!-- Nível de análise: latest-recommended traz as regras mais atuais -->
    <AnalysisLevel>latest-recommended</AnalysisLevel>
    <RunAnalyzersDuringBuild>true</RunAnalyzersDuringBuild>
  </PropertyGroup>
</Project>
```

### Regras obrigatoriamente habilitadas

| Regra | Motivo |
|---|---|
| `CA1062` — Validate arguments of public methods | Previne `NullReferenceException` em boundaries públicos |
| `CA2007` — Do not directly await a Task | Evita deadlock em contextos síncronos |
| `CS8600–CS8625` — Nullable reference warnings | Cobertura total de nullabilidade com `<Nullable>enable</Nullable>` |
| Roslyn customizado: query sem filtro de escopo | Analisador personalizado que detecta queries `DbSet<T>` sem filtro de escopo (tenant ou sub-recurso) — ver [`implementation-guide.md` §4.2](implementation-guide.md#42-repositórios--filtro-obrigatório-no-where) |
| Roslyn customizado: log direto sem `[LoggerMessage]` | Detecta chamadas diretas a `ILogger.LogInformation`/`LogWarning`/etc. fora de uma classe `Log` anotada com `[LoggerMessage]` — ver [`implementation-guide.md` §7.3](implementation-guide.md#73-padrão-loggermessage-source-generated--obrigatório) |
| Regra proibida: SDK de integração externa fora do diretório de adaptadores | Nenhum pacote/cliente HTTP de um provedor externo específico pode ser referenciado fora do diretório de adaptadores dedicado a essa integração — ver [`implementation-guide.md` §5.4](implementation-guide.md#54-regras) |

### Supressão pontual (uso controlado)

Suprimir um diagnóstico é permitido apenas com justificativa documentada — na mesma linha do `#pragma warning disable`, ou na linha imediatamente anterior quando o comentário não cabe na linha:

```csharp
// Correto — justificativa obrigatória, mesma linha
#pragma warning disable CA1062 // Validado pelo ProjectContextMiddleware antes de chegar aqui
public void Process(Request request) { ... }
#pragma warning restore CA1062

// Também correto — justificativa na linha anterior, quando mais longa
// Validado pelo ProjectContextMiddleware; DTO só é construído internamente.
#pragma warning disable CA1062
public void Process(Request request) { ... }
#pragma warning restore CA1062
```

> Exceção aceita sem justificativa: supressões em arquivos `*.Designer.cs`/`*ModelSnapshot.cs` gerados automaticamente pelas migrations do EF Core (`// <auto-generated />`) — não são código de produção escrito à mão, a regra de justificativa não se aplica a eles.

---

## 2. Code Coverage — Coverlet + ReportGenerator

### O que é

Coverage mede o percentual do código-fonte exercitado pelos testes. Não garante qualidade dos testes — mas garante que código não testado seja visível e bloqueie o merge.

### Configuração nos projetos de teste

```xml
<!-- Em cada *.Unit.Tests.csproj -->
<TaskGroup>
  <PackageReference Include="coverlet.collector" Version="*" PrivateAssets="all" />
  <PackageReference Include="coverlet.msbuild"   Version="*" PrivateAssets="all" />
</TaskGroup>
```

Instalar o ReportGenerator como dotnet tool (uma vez por runner):

```bash
dotnet tool install -g dotnet-reportgenerator-globaltool
```

### Thresholds por camada

| Camada | Threshold mínimo | Escopo medido |
|---|---|---|
| **Unit** | **80% line coverage, mínimo por módulo** | **Todos** os projetos de produção da solution — `Domain/`, `Application/`, `Infrastructure/`, `Api/`, `Workers/` |
| **Integration** | Sem threshold próprio — soma à cobertura total | Componentes com banco/fila/cache reais |
| **E2E** | Sem threshold — cobertura é efeito colateral | Happy paths + variantes |

> **Escopo firmado em 02/09/2026 (COVERAGE-SCOPE):** o gate não é mais restrito ao núcleo. Todo assembly de produção entra na medição, e **cada unidade implantável do repositório tem o seu próprio gate** — inclusive a unidade de front-end, que não é coberta por este perfil (.NET) e precisa do seu comando declarado na Ficha de Vinculação (nível 1 §6, V11/V12).
>
> **Estatística firmada (COVERAGE-STAT):** `ThresholdStat=minimum`. O gate reprova pelo **pior** módulo; média entre assemblies não é aceita, porque esconde exatamente o módulo que ninguém testou.

### Execução local

```bash
# Rodar testes com coleta de coverage
dotnet test tests/Unit/ \
  --collect:"XPlat Code Coverage" \
  --results-directory ./coverage

# Gerar relatório HTML navegável
reportgenerator \
  -reports:"./coverage/**/coverage.cobertura.xml" \
  -targetdir:"./coverage/report" \
  -reporttypes:"Html;Cobertura;TextSummary"

# Abrir relatório
start ./coverage/report/index.html
```

### Threshold enforcement no CI

```bash
dotnet test tests/Unit/ \
  --collect:"XPlat Code Coverage" \
  /p:Threshold=80 \
  /p:ThresholdType=line \
  /p:ThresholdStat=minimum
```

Exit code ≠ 0 quando **qualquer módulo** fica abaixo do threshold — bloqueia o pipeline automaticamente.

> `ThresholdStat=minimum` é a configuração normativa. `average` e `total` **não** são aceitos: os dois permTask que um assembly sem teste passe às custas de outro bem coberto, que é precisamente o que o gate existe para impedir (nível 1 §5.4).

---

## 3. Code Metrics — Microsoft.CodeAnalysis.Metrics

> **Regra para projetos novos: bloqueante desde o primeiro commit.** Diferente de repositórios legados — onde a métrica pode começar como meta aspiracional até ser efetivamente conectada ao pipeline —, um projeto novo deve nascer já com este gate ativo: nenhum código entra fora do limite desde o começo.

### O que é

Métricas quantificam o quão difícil o código é de manter e testar. Usamos a ferramenta **oficial Microsoft** via MSBuild target `Metrics` do pacote `Microsoft.CodeAnalysis.Metrics`.

### Métricas e limites

> **Fonte única dos limites:** [`implementation-principles.md`](implementation-principles.md) §4.4. A tabela abaixo é a cópia vigente, para leitura junto da configuração da ferramenta — divergência entre as duas é defeito de documento, e o §4.4 vence.

| Métrica | O que mede | Limite |
|---|---|---|
| **Maintainability Index** | Score 0–100: quanto maior, mais fácil de manter | ≥ 20 |
| **Complexidade Ciclomática** | Número de caminhos independentes em um método | ≤ 10 por método |
| **Depth of Inheritance** | Profundidade da hierarquia de herança | ≤ 5 |
| **Class Coupling** | Número de tipos externos referenciados por classe | ≤ 9 |
| **Lines of Code** | Linhas executáveis por método | ≤ 50 |
| **Parâmetros por método** | Assinatura que esconde um conceito não modelado | ≤ 4 |

### Interpretação do Maintainability Index

| Faixa | Cor | Ação |
|---|---|---|
| 0 – 9 | Vermelho | Refatorar imediatamente — bloqueia merge |
| 10 – 19 | Amarelo | Planejar refatoração — bloqueia merge |
| 20 – 100 | Verde | Aceitável |

### Configuração via MSBuild

Adicionar ao `Directory.Build.props`:

```xml
<Project>
  <TaskGroup>
    <!-- Habilita o target Metrics via dotnet build /t:Metrics -->
    <PackageReference Include="Microsoft.CodeAnalysis.Metrics"
                      Version="*" PrivateAssets="all" />
  </TaskGroup>
</Project>
```

### Execução

```bash
# Gera metrics.xml na pasta de output do projeto
dotnet build src/ /t:Metrics

# O arquivo gerado contém Maintainability Index, Cyclomatic Complexity, etc.
# por assembly, namespace, tipo e membro
```

O pipeline CI parseia o `metrics.xml` e falha se qualquer assembly tiver Maintainability Index < 20.

> **Regra geral:** o threshold só aumenta a cada sprint, nunca diminui.

---

## 4. Integração no GitLab CI

### Estrutura de stages

```text
analyze → test-unit → test-integration → deploy-staging → test-e2e → test-perf
   ↑            ↑                                                        ↑
Code Analysis  Coverage + Metrics                              Orçamento + Regressão
(bloqueia)     (bloqueia se abaixo do threshold)               (bloqueia — §4.2)
```

Testes de integração e E2E rodam contra o **ambiente de staging**. As connection strings são injetadas via variáveis protegidas do GitLab CI (`Settings → CI/CD → Variables`), nunca hardcoded.

### 4.1 Um estágio de cobertura por unidade implantável

O pipeline abaixo cobre a unidade .NET. **Repositório com mais de uma unidade implantável tem um job de cobertura por unidade**, todos no estágio `test-unit`, todos bloqueantes:

| Unidade | Job | Comando do gate |
|---|---|---|
| Back-end .NET (API, workers) | `test-unit` | o `dotnet test` com `/p:Threshold=80 /p:ThresholdStat=minimum` de §2 |
| **Front-end / app** | `test-unit-frontend` | o comando declarado em V12 da Ficha de Vinculação — runner e ferramenta de cobertura do próprio ecossistema, mesmo limiar de 80% mínimo por módulo |
| Qualquer outra unidade com código próprio | um job por unidade | idem |

**Unidade implantável sem job de cobertura no pipeline é achado bloqueante de auditoria** (nível 1 §5.5) — não "pendência de configuração". Enquanto o job não existir, a Task que toca aquela unidade não é dado como verificado.

### `.gitlab-ci.yml`

```yaml
variables:
  DOTNET_VERSION: "10.0"
  COVERAGE_THRESHOLD: "80"

stages:
  - analyze
  - test-unit
  - test-integration
  - deploy-staging
  - test-e2e
  - test-perf          # jobs em §4.2

# ─── STAGE 1: Code Analysis ───────────────────────────────────────────────────
code-analysis:
  stage: analyze
  image: mcr.microsoft.com/dotnet/sdk:10.0
  script:
    # TreatWarningsAsErrors=true no Directory.Build.props — analyzer warning = falha
    - dotnet build src/ --configuration Release
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH =~ /^(main|develop)$/'

# ─── STAGE 2: Unit Tests + Coverage ───────────────────────────────────────────
test-unit:
  stage: test-unit
  image: mcr.microsoft.com/dotnet/sdk:10.0
  script:
    - dotnet tool install -g dotnet-reportgenerator-globaltool
    - |
      dotnet test tests/Unit/ \
        --collect:"XPlat Code Coverage" \
        --results-directory ./coverage \
        /p:Threshold=$COVERAGE_THRESHOLD \
        /p:ThresholdType=line \
        /p:ThresholdStat=minimum \
        --logger "junit;LogFilePath=test-results/unit-results.xml"
    - |
      reportgenerator \
        -reports:"./coverage/**/coverage.cobertura.xml" \
        -targetdir:"./coverage/report" \
        -reporttypes:"Html;Cobertura;TextSummary"
    - cat ./coverage/report/Summary.txt
  coverage: '/Line coverage: (\d+\.?\d*)%/'
  artifacts:
    when: always
    reports:
      junit: test-results/unit-results.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage/**/coverage.cobertura.xml
    paths:
      - coverage/report/
    expire_in: 7 days
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH =~ /^(main|develop)$/'

# ─── STAGE 2: Code Metrics (paralelo aos testes unitários) ────────────────────
code-metrics:
  stage: test-unit
  image: mcr.microsoft.com/dotnet/sdk:10.0
  script:
    - dotnet build src/ /t:Metrics
    # Valida Maintainability Index >= 20 em todos os assemblies
    - |
      python3 -c "
      import xml.etree.ElementTree as ET, sys
      tree = ET.parse('src/metrics.xml')
      failed = [
        a.get('Name') for a in tree.findall('.//Assembly')
        if int(a.get('MaintainabilityIndex', 100)) < 20
      ]
      if failed:
        print('FALHA: Maintainability Index < 20 em:', failed)
        sys.exit(1)
      print('OK: todos os assemblies dentro do limite')
      "
  artifacts:
    paths:
      - src/**/metrics.xml
    expire_in: 7 days
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH =~ /^(main|develop)$/'

# ─── STAGE 3: Integration Tests (staging) ─────────────────────────────────────
test-integration:
  stage: test-integration
  image: mcr.microsoft.com/dotnet/sdk:10.0
  variables:
    DB_CONNECTION_STRING: $STAGING_DB_CONNECTION
    CACHE_CONNECTION_STRING: $STAGING_CACHE_CONNECTION
    MESSAGE_BROKER_CONNECTION_STRING: $STAGING_MESSAGE_BROKER_CONNECTION
  script:
    - |
      dotnet test tests/Integration/ \
        --logger "junit;LogFilePath=test-results/integration-results.xml"
  environment:
    name: staging
  artifacts:
    when: always
    reports:
      junit: test-results/integration-results.xml
  rules:
    - if: '$CI_COMMIT_BRANCH =~ /^(main|develop)$/'

# ─── STAGE 5: E2E Tests (staging) ─────────────────────────────────────────────
test-e2e:
  stage: test-e2e
  image: mcr.microsoft.com/dotnet/sdk:10.0
  variables:
    API_BASE_URL: $STAGING_API_BASE_URL
  script:
    - |
      dotnet test tests/E2E/ \
        --logger "junit;LogFilePath=test-results/e2e-results.xml"
  environment:
    name: staging
  artifacts:
    when: always
    reports:
      junit: test-results/e2e-results.xml
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

### 4.2 Estágio `test-perf` — dois gates: orçamento e regressão

> **Regra normativa:** nível 1 [`implementation-principles.md`](implementation-principles.md) §5.6 — P3 (limiar dentro do cenário), P4 (baseline medida), P5 (o que é regressão e quando bloqueia). Forma do cenário em [`implementation-guide.md`](implementation-guide.md) §9.6.

Dois jobs, dois propósitos distintos — **não** se juntam:

| Job | Pergunta que responde | Falha quando |
|---|---|---|
| `perf-budget` | "Está dentro do que o produto prometeu?" | o `thresholds` do cenário (limiar de V18) é violado → k6 sai com código ≠ 0 |
| `perf-regression` | "Piorou em relação à última medição aceita?" | o percentil atual piora acima da **margem medida** (V20) contra `tests/perf/baseline.json` (V21) |

```yaml
# ─── STAGE 6: Performance (staging) ───────────────────────────────────────────
perf-budget:
  stage: test-perf
  image: grafana/k6:latest
  variables:
    BASE_URL: $STAGING_API_BASE_URL
  script:
    # Um k6 run por linha de V18. Threshold violado => exit code != 0 => bloqueia.
    - |
      for scenario in tests/perf/*.perf.js; do
        k6 run "$scenario" \
          --summary-export="tests/perf/out/$(basename "$scenario" .perf.js).summary.json"
      done
  artifacts:
    when: always
    paths:
      - tests/perf/out/
    expire_in: 30 days
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event" && $PERF == "true"'

perf-regression:
  stage: test-perf
  needs: ["perf-budget"]
  image: python:3-slim
  script:
    # Compara o p95 medido com a baseline versionada; margem de ruído vem de V20.
    - python3 scripts/perf-compare.py
        --current tests/perf/out/
        --baseline tests/perf/baseline.json
        --margin "$PERF_NOISE_MARGIN"
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event" && $PERF == "true"'
```

**Como se aceita uma piora legítima:** atualizando `tests/perf/baseline.json` **no mesmo merge**, com a justificativa no corpo da mudança. A piora aparece no diff e é revisada — que é o ponto. Piora aceita em definitivo (mudar o limiar de V18 para pior) exige **ADR**: o limiar só aperta (nível 1 §5.6 P5).

**Variáveis do projeto, nunca deste perfil:** `$STAGING_API_BASE_URL`, `$PERF_NOISE_MARGIN` (valor de V20) e as credenciais de carga vivem em `Settings → CI/CD → Variables`, protegidas.

**Fronteira:** projeto sem linha em V18 **não tem** o estágio `test-perf`, e o veredito do QA registra desempenho como **não exercitado** — explicitamente, nunca por omissão. O que é achado bloqueante é a linha de V18 existir sem cenário e sem job (nível 1 §7, #21).

### Badge de coverage no README

O GitLab exibe automaticamente o percentual de coverage no MR quando o artifact `coverage_report` está configurado. Para o badge no `README.md`:

```markdown
![coverage](https://gitlab.com/{empresa}/{produto}/badges/main/coverage.svg)
```

---

## 5. Resumo — O que bloqueia o merge

| Verificação | Ferramenta | Estágio | Comportamento |
|---|---|---|---|
| Analyzer warning no código | Roslyn + `TreatWarningsAsErrors` | `analyze` | **Bloqueia** — build falha |
| Coverage < 80% em **qualquer módulo** de **qualquer unidade implantável** (front-end incluído) | Coverlet + `ThresholdStat=minimum` (.NET) · ferramenta de V12 (demais unidades) | `test-unit` | **Bloqueia** — exit code ≠ 0 |
| Unidade implantável sem job de cobertura no pipeline | Inspeção do `.gitlab-ci.yml` (§4.1) | auditoria | **Bloqueia** — Task não é dado como verificado |
| Maintainability Index < 20 | Microsoft.CodeAnalysis.Metrics | `test-unit` | **Bloqueia** — desde o primeiro commit |
| Teste unitário falhando | xUnit | `test-unit` | **Bloqueia** — sempre |
| Teste de integração falhando | xUnit | `test-integration` | **Bloqueia** — em `develop` e `main` |
| Teste E2E falhando | xUnit | `test-e2e` | **Bloqueia** — em `main` |
| Query sem filtro de escopo (tenant/sub-recurso) | Roslyn customizado | `analyze` | **Bloqueia** — build falha |
| Log direto sem `[LoggerMessage]` | Roslyn customizado | `analyze` | **Bloqueia** — build falha |
| Violação da regra de dependência entre camadas | Teste de arquitetura (`{Produto}.Architecture.Tests`) | `test-unit` | **Bloqueia** — nível 1 §2.3 |
| `TODO`/`FIXME` sem ID de Task aberta | Busca por padrão no script do estágio | `analyze` | **Bloqueia** — nível 1 §4.3 |
| Limiar de orçamento de desempenho violado | k6 `thresholds` (ou NBomber `assertions`), exit code ≠ 0 | `test-perf` | **Bloqueia** — nível 1 §5.6 P3 |
| Regressão acima da margem medida (V20) | `perf-compare` contra `tests/perf/baseline.json` (§4.2) | `test-perf` | **Bloqueia** — só passa com baseline atualizada no mesmo merge |
| Operação de V18 sem cenário `*.perf.js` e sem job | Inspeção: uma linha de V18 ↔ um cenário ↔ um job | auditoria | **Bloqueia** — Task não é dado como verificado |
| Cenário de carga sem `thresholds` declarado | Busca por padrão em `tests/perf/*.perf.js` | `test-perf` | **Bloqueia** — relatório não é gate |

> A lista completa do que bloqueia, independente de stack, está em [`implementation-principles.md`](implementation-principles.md) §7. Task daquele quadro **sem** linha correspondente aqui é gate não configurado nesta stack — achado de auditoria, não pendência de organização.

> **Regra para projetos novos:** threshold de métricas é bloqueante desde o primeiro commit — nenhum código entra fora do limite.
>
> **Regra para repositórios legados (se/quando este padrão for adotado em código já existente):** medir a baseline atual, definir o threshold nela e ativá-lo como bloqueante imediatamente. O threshold só aumenta a cada sprint, nunca diminui.
