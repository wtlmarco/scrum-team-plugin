# Guia de Implementação — Perfil de Stack .NET

**Versão:** 3.3
**Data:** 06/09/2026
**Status:** Draft normativo
**Nível:** 2 — perfil de stack
**Stack alvo:** .NET 10 · Clean Architecture · CQRS

> **Este documento é a vinculação .NET do normativo de nível 1**, [`implementation-principles.md`](implementation-principles.md) — Clean Architecture, Clean Code, CQRS e o gate de cobertura de 80%. Aquele documento diz **o que** precisa ser verdade em qualquer linguagem; este diz **como isso se escreve em .NET**.
>
> **Precedência:** onde este perfil divergir do nível 1, o nível 1 vence e a divergência é defeito de documento. Este perfil pode acrescentar obrigação; nunca afrouxar uma de lá.
>
> Guia normativo, **agnóstico de produto**, para desenvolvimento de código em **.NET 10**, aplicando **Clean Architecture** e **CQRS**. Todas as regras aqui são obrigatórias salvo decisão explícita em ADR.
>
> Este documento define **padrões, estrutura e convenções reutilizáveis** por qualquer solution .NET desta organização. Ele **não contém** nomes de entidades, capacidades, integrações ou regras de negócio de nenhum produto específico — onde usa `{Produto}`, `{Feature}`, `{Entity}`, `{Integração}` etc., leia-se placeholders a preencher por cada solution.
>
> **A aplicação concreta destes padrões a um produto específico é responsabilidade do documento de arquitetura daquele produto** — o caminho de cada projeto está em `.team-project/README.md` §4 (fontes da verdade). É lá que se define a estrutura de pastas real, os nomes reais de entidades/capacidades/integrações, os enums reais e os exemplos de código com nomes de negócio. Este guia nunca deve ser editado para acomodar uma decisão de um produto específico — a decisão vai no documento de arquitetura daquele produto, que referencia a seção correspondente aqui.

---

## Documentos relacionados

| Documento | Conteúdo |
|---|---|
| [`implementation-principles.md`](implementation-principles.md) | **Nível 1** — os princípios que este perfil vincula: Clean Architecture, Clean Code, CQRS, testes e gate de 80% |
| [`implementation-quality.md`](implementation-quality.md) | Code Analysis, Coverage, Metrics e pipeline de CI — perfil da mesma stack |

---

## Decisões Pendentes

| Referência | Assunto | Status |
|---|---|---|
| ~~PERF-TEST~~ | **Resolvida** — 06/09/2026, Arquiteto: **k6** para carga sobre a borda HTTP, **NBomber** só para alvo não-HTTP. Cenários, gate de orçamento e gate de regressão em §9.6; pipeline em [`implementation-quality.md`](implementation-quality.md) §4.2. Obrigação e forma de verificação no nível 1, [`implementation-principles.md`](implementation-principles.md) §5.6 | Fechada |
| OUTBOX-PATTERN | Formalizar o Transactional Outbox para handlers de dual-write DB↔broker | Definição Futura |

---

## Sumário

1. Estrutura de Pastas por Camada (Clean Architecture)
2. Regras de Nomenclatura
3. Padrão CQRS — Commands, Queries, Handlers
4. Isolamento por Escopo (Tenant e Sub-recurso)
5. Adaptadores de Integrações Externas Multi-Provedor
6. Portas e Adaptadores de Infraestrutura — Configuração
7. Observabilidade e Logging
8. Configuração — `.env` vs `appsettings`
9. Estratégia de Testes
10. Versionamento de API
11. Formato de Resposta de Erro

---

## 1. Estrutura de Pastas por Camada (Clean Architecture)

> **Regra normativa:** [`implementation-principles.md`](implementation-principles.md) §2 — os quatro anéis, a regra de dependência e a exigência de **teste automatizado de arquitetura**. Abaixo, como esses anéis se materializam em uma solution .NET.

Cada bounded context é uma **solution independente**. A estrutura de pastas segue as quatro camadas da Clean Architecture.

```text
src/
├── {Produto}.Domain/                    # Núcleo — zero dependências externas
│   ├── Entities/
│   ├── ValueObjects/
│   ├── Events/                          # Domain events
│   ├── Enums/
│   └── Interfaces/
│       └── Repositories/                # Contratos de repositório (interfaces)
│
├── {Produto}.Application/               # Casos de uso — depende apenas de Domain
│   ├── Commands/
│   │   ├── ICommand.cs
│   │   ├── ICommandHandler.cs
│   │   ├── CommandDispatcher.cs
│   │   └── {Feature}/
│   │       ├── {Feature}Command.cs
│   │       ├── {Feature}CommandHandler.cs
│   │       └── {Feature}CommandValidator.cs   # opcional, só quando há input a validar
│   ├── Queries/
│   │   ├── IQuery.cs
│   │   ├── IQueryHandler.cs
│   │   ├── QueryDispatcher.cs
│   │   └── {Feature}/
│   │       ├── {Feature}Query.cs
│   │       └── {Feature}QueryHandler.cs
│   ├── DTOs/
│   │   └── {Domain}/
│   │       ├── {Domain}Request.cs
│   │       ├── {Domain}Response.cs
│   │       └── {Domain}Message.cs       # só quando o DTO é payload de fila/broker
│   ├── Interfaces/                      # Portas: IMessageBroker, IDistributedCache, I{Integração}
│   ├── Logging/                         # Log.cs (LoggerMessage source-generated) desta camada — ver §7
│   └── Behaviors/
│       ├── IPipelineBehavior.cs
│       ├── LoggingBehavior.cs
│       ├── ValidationBehavior.cs
│       └── AuditBehavior.cs
│
├── {Produto}.Infrastructure/             # Adaptadores — depende de Application e Domain
│   ├── ServiceCollectionExtensions.cs    # Composição de DI — na RAIZ do projeto
│   ├── Persistence/
│   │   ├── Repositories/
│   │   ├── Configurations/               # IEntityTypeConfiguration
│   │   └── Migrations/
│   ├── {Integração}/                     # Uma pasta por integração externa (ver §5) — método DI: Add{Integração}
│   │   └── {Provedor}/
│   ├── MessageBroker/                    # Fila (porta: IMessageBroker) — método DI: AddMessageBroker
│   │   ├── InMemory/                     # default, standalone
│   │   └── {ProvedorAvancado}/           # avançado, opt-in (ex.: RabbitMq, Kafka, SQS)
│   ├── Cache/                            # método DI: AddCache
│   │   ├── InMemory/                     # default, standalone
│   │   └── {ProvedorAvancado}/           # avançado, opt-in (ex.: Redis)
│   ├── ObjectStorage/                    # Arquivos/mídia (porta: IObjectStorage) — método DI: AddObjectStorage
│   │   ├── Local/                        # default, standalone (filesystem)
│   │   └── {ProvedorAvancado}/           # avançado, opt-in (ex.: S3, Azure Blob, MinIO)
│   ├── Observability/                    # Logging/OTel — ver §7
│   │   ├── File/                         # default, standalone
│   │   └── {ProvedorAvancado}/           # avançado, opt-in (ex.: Seq, Datadog)
│   └── Scheduling/                       # Orquestração de jobs (porta: IJobScheduler)
│       └── {Provedor}/                   # ex.: Quartz, Hangfire
│
└── {Produto}.Api/                        # Ponto de entrada (ou .Worker)
    ├── ServiceCollectionExtensions.cs    # Composição de DI ESPECÍFICA deste entry-point
    ├── Controllers/
    ├── Middlewares/                      # ex.: contexto de escopo (tenant/sub-recurso) — ver §4.1
    ├── Filters/
    └── Program.cs                        # Enxuto: só chama AddInfrastructure/Add{Integração}/AddHealthChecks
```

> A lista de pastas dentro de `{Integração}/`, `MessageBroker/`, `Cache/`, `ObjectStorage/`, `Observability/` e `Scheduling/` acima é ilustrativa — **cada produto documenta, no seu próprio documento de arquitetura, a estrutura real com os nomes reais de integrações e provedores usados**.

### Regras

- **Domain** não referencia Application, Infrastructure ou Presentation — zero dependências externas à solution. **Domain não registra logs** (ver §7.1) — é código puro, sem I/O.
- **Application** referencia Domain; nunca referencia Infrastructure diretamente — toda dependência de infra é declarada como interface na própria camada Application.
- **Infrastructure** referencia Application e Domain — implementa as interfaces declaradas nessas camadas.
- **Api/Worker (Presentation)** referencia Infrastructure exclusivamente via DI container em `Program.cs`.
- **Um projeto de entry-point por serviço/worker**, compartilhando Domain/Application/Infrastructure da solution — a lista real de entry-points de cada produto vive no seu documento de arquitetura.
- **Toda composição de DI passa por uma classe `ServiceCollectionExtensions` — nunca registro solto em `Program.cs`.** Duas instâncias, papéis diferentes:
  - **`{Produto}.Infrastructure/ServiceCollectionExtensions.cs`** (raiz do projeto): um método público `Add{NomeDaPasta}` por integração/pasta. `AddPersistence` é a única exceção universal (todo entry-point precisa de banco); os demais são **opt-in**. A lista real de métodos (`Add{Integração}` por integração específica do produto) vive no documento de arquitetura de cada produto.
  - **`{Produto}.{EntryPoint}/ServiceCollectionExtensions.cs`**: registro de negócio específico daquele Api/Worker — handlers de CQRS, orquestradores. Expõe `AddInfrastructure` e `AddHealthChecks`.
  - `Program.cs` nunca chama `.AddScoped`/`.AddSingleton`/`.AddHttpClient`/`.AddDbContext`/`.Configure<T>` diretamente — só métodos de `ServiceCollectionExtensions`. Única exceção aceita: ferramentas de linha de comando one-shot (ex.: `Migrator`).
  - Convenção de assinatura: `public static IServiceCollection Add{X}(this IServiceCollection services, IConfiguration configuration)` — **sempre com `IConfiguration configuration`**, mesmo quando o corpo não a usa diretamente, para evitar colisão de assinatura com métodos nativos do ASP.NET Core que causaria recursão infinita silenciosa.

---

## 2. Regras de Nomenclatura

### Classes e arquivos

| Artefato | Convenção | Exemplo (placeholder) |
|---|---|---|
| Entidade de domínio | `PascalCase`, sem sufixo | `{Entity}.cs` |
| Value Object | `PascalCase` + descritivo | `{ConceitoDeNegocio}.cs` |
| Command | verbo + substantivo + `Command` | `Create{Entity}Command.cs` |
| Query | `Get`/`List` + substantivo + `Query` | `Get{Entity}Query.cs` |
| Handler | mesmo nome do Command/Query + `Handler` | `Create{Entity}CommandHandler.cs` |
| Validator | mesmo nome do Command + `Validator` | `Create{Entity}CommandValidator.cs` |
| Repository interface | `I` + entidade + `Repository` | `I{Entity}Repository.cs` |
| Repository impl | entidade + `Repository` | `{Entity}Repository.cs` |
| Porta de integração externa multi-provedor | `I` + capacidade + `Provider` | `I{Capacidade}Provider.cs` |
| Adaptador de integração externa | nome do provedor + capacidade + `Adapter` | `{Provedor}{Capacidade}Adapter.cs` |
| DTO de entrada — CQRS ou porta de integração | substantivo + `Request` | `{Entity}Request.cs` |
| DTO de saída — CQRS ou porta de integração | substantivo + `Response` | `{Entity}Response.cs` |
| DTO de mensagem de fila/broker (`IMessageBroker`) | substantivo + `Message` | `{Evento}RequestedMessage.cs` |
| Middleware | função + `Middleware` | `{Função}Middleware.cs` |
| Pipeline Behavior | função + `Behavior` | `ValidationBehavior.cs` |
| Exceção de domínio | substantivo + `Exception` | `{Entity}NotFoundException.cs` |
| Classe de logs (LoggerMessage) | `Log` (uma por projeto/camada) | `Log.cs` |

### Namespaces

Padrão: `{Empresa}.{Produto}.{Camada}.{Feature}`

```csharp
namespace {Empresa}.{Produto}.Application.Commands.{Feature};
namespace {Empresa}.{Produto}.Domain.Entities;
namespace {Empresa}.{Produto}.Infrastructure.Persistence.Repositories;
namespace {Empresa}.{Produto}.Infrastructure.{Integração}.{Capacidade};
```

### Métodos e variáveis

- Métodos públicos: `PascalCase`
- Variáveis locais e parâmetros: `camelCase`
- Constantes: `UPPER_SNAKE_CASE`
- Campos privados: `_camelCase` (prefixo underscore)
- Propriedades: `PascalCase`

### Enums

Declarados em `Domain/Enums/`. Valores em `PascalCase`. Os valores reais de cada enum de negócio (ex.: um enum de formato, de status, de tipo) são definidos no modelo de dados de cada produto — este guia não prescreve valores de negócio, apenas a convenção de escrita.

---

## 3. Padrão CQRS — Commands, Queries, Handlers

> **Regra normativa:** [`implementation-principles.md`](implementation-principles.md) §3 — separação escrita/leitura, consulta que nunca escreve, handler que não chama handler, e o que o CQRS **não** obriga (banco separado, projeção, event sourcing). Abaixo, os contratos concretos em .NET.

Clean Architecture e CQRS resolvem problemas diferentes e se encaixam naturalmente: a Clean Architecture define **onde** cada coisa vive (Domain, Application, Infrastructure, Presentation); o CQRS define **como** os dados fluem pela camada Application — separando escrita (`Command`) de leitura (`Query`).

As entidades de domínio continuam sendo o coração do sistema: têm propriedades, executam validações de negócio e guardam invariantes. O CQRS apenas organiza o fluxo ao redor delas — os Commands chegam, os Handlers usam as entidades para executar a lógica de negócio, e as Queries lêem o estado já persistido e retornam DTOs otimizados para apresentação, sem repassar pelas entidades de domínio.

O CQRS é implementado por **chamada direta**, sem dependência do MediatR. O pipeline de behaviors é montado pelos dispatchers a partir dos `IPipelineBehavior<TRequest, TResponse>` registrados no DI.

### Contratos base

```csharp
// Application/Commands/ICommand.cs
public interface ICommand { }
public interface ICommand<TResponse> { }

public interface ICommandHandler<TCommand>
    where TCommand : ICommand
{
    Task Handle(TCommand command, CancellationToken ct = default);
}

public interface ICommandHandler<TCommand, TResponse>
    where TCommand : ICommand<TResponse>
{
    Task<TResponse> Handle(TCommand command, CancellationToken ct = default);
}

// Application/Queries/IQuery.cs
public interface IQuery<TResponse> { }

public interface IQueryHandler<TQuery, TResponse>
    where TQuery : IQuery<TResponse>
{
    Task<TResponse> Handle(TQuery query, CancellationToken ct = default);
}
```

### IPipelineBehavior

```csharp
public delegate Task<TResponse> HandlerDelegate<TResponse>();

public interface IPipelineBehavior<TRequest, TResponse>
{
    Task<TResponse> Handle(
        TRequest request,
        HandlerDelegate<TResponse> next,
        CancellationToken ct = default);
}
```

### Dispatchers

```csharp
public class CommandDispatcher(IServiceProvider sp)
{
    public Task Dispatch<TCommand>(TCommand command, CancellationToken ct = default)
        where TCommand : ICommand
        => DispatchInternal<TCommand, Unit>(
            command,
            async () => { await sp.GetRequiredService<ICommandHandler<TCommand>>().Handle(command, ct); return Unit.Value; },
            ct);

    public Task<TResponse> Dispatch<TCommand, TResponse>(TCommand command, CancellationToken ct = default)
        where TCommand : ICommand<TResponse>
        => DispatchInternal<TCommand, TResponse>(
            command,
            () => sp.GetRequiredService<ICommandHandler<TCommand, TResponse>>().Handle(command, ct),
            ct);

    private Task<TResponse> DispatchInternal<TRequest, TResponse>(
        TRequest request, HandlerDelegate<TResponse> handlerCall, CancellationToken ct)
    {
        var pipeline = sp.GetServices<IPipelineBehavior<TRequest, TResponse>>()
            .Reverse()
            .Aggregate(handlerCall, (next, b) => () => b.Handle(request, next, ct));
        return pipeline();
    }
}

public readonly struct Unit { public static readonly Unit Value = new(); }
```

```csharp
public class QueryDispatcher(IServiceProvider sp)
{
    public Task<TResponse> Dispatch<TQuery, TResponse>(TQuery query, CancellationToken ct = default)
        where TQuery : IQuery<TResponse>
    {
        var pipeline = sp.GetServices<IPipelineBehavior<TQuery, TResponse>>()
            .Reverse()
            .Aggregate(
                (HandlerDelegate<TResponse>)(() => sp.GetRequiredService<IQueryHandler<TQuery, TResponse>>().Handle(query, ct)),
                (next, b) => () => b.Handle(query, next, ct));
        return pipeline();
    }
}
```

### Forma de um Command (escrita)

```csharp
public record Create{Entity}Command(
    /* campos de entrada, específicos de cada produto */
) : ICommand<Create{Entity}Result>;

public class Create{Entity}CommandHandler(
    I{Entity}Repository repository,
    IUnitOfWork unitOfWork
) : ICommandHandler<Create{Entity}Command, Create{Entity}Result>
{
    public async Task<Create{Entity}Result> Handle(
        Create{Entity}Command request, CancellationToken ct = default)
    {
        // lógica de domínio aqui
    }
}
```

> Cada produto documenta seus Commands/Queries reais (nomes, campos, handlers) no seu próprio documento de arquitetura — este guia define apenas a forma do contrato.

### Validators (FluentValidation)

Cada Command que requer validação de entrada tem um `CommandValidator` correspondente na mesma pasta do feature — só quando há input a validar. Queries também podem ter um `QueryValidator` pelo mesmo critério (ex.: paginação/filtro) — é a exceção, não a regra.

### Pipeline Behaviors (ordem de execução)

```text
Request → LoggingBehavior → ValidationBehavior → AuditBehavior → Handler → Response
```

| Behavior | Responsabilidade |
|---|---|
| `LoggingBehavior` | Loga entrada/saída de cada request com o contexto de escopo (ver §4) e duração — via `[LoggerMessage]` (§7) |
| `ValidationBehavior` | Executa FluentValidation; lança `ValidationException` se inválido |
| `AuditBehavior` | Para commands auditáveis (`IAuditableCommand`), registra a operação em `AuditLog` via `IAuditLogWriter`, na **mesma transação (Unit of Work)** do handler — se a auditoria falhar, a operação é revertida (fail-closed) |

> **Dual-write DB ↔ broker (Outbox):** handlers que gravam estado no banco **e** publicam mensagem na mesma operação não podem fazer os dois fora de uma transação. Padrão recomendado: **Transactional Outbox** — ver pendência `OUTBOX-PATTERN`.

### Registro no DI

```csharp
services.AddScoped<CommandDispatcher>();
services.AddScoped<QueryDispatcher>();

services.AddScoped<
    ICommandHandler<Create{Entity}Command, Create{Entity}Result>,
    Create{Entity}CommandHandler>();

services.AddValidatorsFromAssemblyContaining<Create{Entity}Command>();

services.AddTransient(typeof(IPipelineBehavior<,>), typeof(LoggingBehavior<,>));
services.AddTransient(typeof(IPipelineBehavior<,>), typeof(ValidationBehavior<,>));
services.AddTransient(typeof(IPipelineBehavior<,>), typeof(AuditBehavior<,>));
```

### Regras

- Um arquivo por Command/Query/Handler — nunca agrupar em um único arquivo.
- Handlers não chamam outros Handlers — se houver reuso, extrair para um Domain Service.
- Commands retornam apenas `Result` ou `Unit` — nunca entidades de domínio.
- Queries retornam DTOs — nunca entidades de domínio.

---

## 4. Isolamento por Escopo (Tenant e Sub-recurso)

Sistemas multi-tenant frequentemente possuem uma segunda dimensão de escopo abaixo do tenant (ex.: workspace, organização, projeto) — as duas dimensões são independentes e não devem ser tratadas como sinônimas.

> **Tenant e sub-recurso são dimensões diferentes de isolamento.** Um `Tenant` (cliente/empresa contratante) possui **muitos** recursos de segundo nível (ex.: workspaces, projetos, organizações — o nome exato é definido por cada produto). O isolamento precisa acontecer nas duas dimensões, e a hierarquia é sempre `Tenant → Sub-recurso` (todo sub-recurso pertence a exatamente um `Tenant`; nunca o contrário). **O mapeamento concreto dessas dimensões para o domínio de negócio de cada produto vive no respectivo documento de arquitetura.**

```text
Tenant (cliente/empresa)
  │
  ├── {Sub-recurso} 1
  ├── {Sub-recurso} 2
  └── {Sub-recurso} N
```

Consequência direta no modelo de dados: o sub-recurso de segundo nível deve carregar um campo `TenantId` (FK obrigatória) — toda entidade filha desse sub-recurso já está transitivamente isolada por tenant através da FK para ele, e **não precisa repetir `TenantId` na própria linha**. Apenas entidades que fazem consulta direta por tenant (ex.: "listar todos os sub-recursos de um tenant", faturamento, configuração de tenant) precisam do filtro `TenantId` explícito.

### 4.1 Extração do escopo — contextos por request

Dois serviços `Scoped` distintos, populados por middlewares diferentes:

```csharp
// Application/Interfaces/ITenantContext.cs
public interface ITenantContext
{
    Guid TenantId { get; }
}

// Application/Interfaces/I{SubRecurso}Context.cs
public interface I{SubRecurso}Context
{
    int {SubRecurso}Id { get; }
}
```

```csharp
// Api/Middlewares/TenantMiddleware.cs — extrai TenantId do JWT/API Key (nível de autenticação)
public class TenantMiddleware(RequestDelegate next)
{
    public async Task InvokeAsync(HttpContext context, ITenantContext tenantContext)
    {
        // extrai TenantId do claim/token e popula ITenantContext
        await next(context);
    }
}

// Api/Middlewares/{SubRecurso}ContextMiddleware.cs — extrai o Id do sub-recurso da rota (nível de recurso)
public class {SubRecurso}ContextMiddleware(RequestDelegate next)
{
    public async Task InvokeAsync(HttpContext context, I{SubRecurso}Context subRecursoContext, I{SubRecurso}Repository repository)
    {
        // extrai o Id do sub-recurso da rota (ex.: /api/{sub-recursos}/{id}/...) e valida que
        // {SubRecurso}.TenantId == ITenantContext.TenantId antes de popular I{SubRecurso}Context
        // (nunca confiar apenas no Id da URL sem validar o tenant dono)
        await next(context);
    }
}
```

Workers de fila populam ambos os contextos a partir dos metadados do envelope da mensagem (`TenantId` e o Id do sub-recurso), nunca só um dos dois.

### 4.2 Repositórios — filtro obrigatório no WHERE

- Repositórios do **sub-recurso de segundo nível** (e consultas que atravessam múltiplos sub-recursos, ex. listagens/faturamento) filtram por `TenantId`.
- Repositórios de entidades **filhas do sub-recurso** filtram pelo Id desse sub-recurso — o isolamento de tenant já é garantido transitivamente.

```csharp
public class {SubRecurso}Repository(AppDbContext db, ITenantContext tenant) : I{SubRecurso}Repository
{
    public async Task<IReadOnlyList<{SubRecurso}>> GetAllAsync(CancellationToken ct)
        => await db.{SubRecursos}
            .Where(p => p.TenantId == tenant.TenantId)   // OBRIGATÓRIO
            .ToListAsync(ct);
}

public class {Entity}Repository(AppDbContext db, I{SubRecurso}Context subRecursoContext) : I{Entity}Repository
{
    public async Task<IReadOnlyList<{Entity}>> GetPendingAsync(CancellationToken ct)
        => await db.{Entities}
            .Where(a => a.{SubRecurso}Id == subRecursoContext.{SubRecurso}Id)   // OBRIGATÓRIO
            .ToListAsync(ct);
}
```

**Regra:** Pull Requests com queries ao banco sem o filtro de escopo apropriado (`TenantId` para consultas de nível de tenant, o Id do sub-recurso para o restante) são bloqueados no code review e, idealmente, por um analisador estático customizado (ver `implementation-quality.md`).

### 4.3 Testes de isolamento

Todo teste de integração que acessa o banco deve:
1. Criar dados para dois tenants distintos, cada um com pelo menos um sub-recurso.
2. Executar a operação no contexto do primeiro tenant/sub-recurso.
3. Verificar que o resultado não contém dados do outro tenant nem de outro sub-recurso.
4. Verificar explicitamente que o Id de um sub-recurso de um tenant não é acessível a partir do contexto de outro tenant (tentativa de acesso cruzado deve retornar `404`, nunca `403` — não revelar a existência do recurso a quem não é dono).

---

## 5. Adaptadores de Integrações Externas Multi-Provedor

Alguns tipos de integração externa não têm **um** provedor fixo — o produto pode precisar suportar vários provedores concorrentes para a mesma capacidade, escolhidos **em tempo de execução**, por chamada (não uma vez no boot). Esse é um padrão distinto do padrão `X:Provider` de §6 (onde só um adaptador fica ativo por vez).

Cada **capacidade** é uma porta própria em `Application/Interfaces/`, com **um adaptador por provedor real** em `Infrastructure/{Integração}/{Capacidade}/`.

### 5.1 Porta por capacidade

```csharp
// Application/Interfaces/I{Capacidade}Provider.cs
public interface I{Capacidade}Provider
{
    string ProviderName { get; }

    Task<{Capacidade}Result> ExecuteAsync(
        {Capacidade}Request request,
        CancellationToken cancellationToken);
}
```

### 5.2 Registro via Keyed Services

Todos os adaptadores de uma capacidade ficam registrados **simultaneamente** — a escolha de qual usar é resolvida em runtime, não no boot:

```csharp
// Infrastructure/ServiceCollectionExtensions.cs
public static IServiceCollection Add{Integração}(this IServiceCollection services, IConfiguration configuration)
{
    ArgumentNullException.ThrowIfNull(configuration);

    services.AddKeyedScoped<I{Capacidade}Provider, {Provedor1}{Capacidade}Adapter>("{Provedor1}");
    services.AddKeyedScoped<I{Capacidade}Provider, {Provedor2}{Capacidade}Adapter>("{Provedor2}");

    // ... um par AddKeyedScoped por (capacidade × provedor real disponível)

    services.AddScoped<I{Integração}ConfigurationResolver, {Integração}ConfigurationResolver>();
    services.AddScoped<I{Integração}Router, {Integração}Router>();

    return services;
}
```

### 5.3 Separação entre Resolução de Configuração e Roteamento

Duas responsabilidades distintas, que não devem ser misturadas na mesma classe:

| | Pergunta que responde | Natureza |
|---|---|---|
| **`I{Integração}ConfigurationResolver`** | "Qual provedor/configuração foi definida para esta capacidade?" | Declarativa — resolução hierárquica de preferências já cadastradas |
| **`I{Integração}Router`** | "Esse provedor está disponível agora, e se não estiver, o que eu faço?" | Dinâmica — execução em tempo real, incluindo fallback técnico |

```csharp
// Infrastructure/{Integração}/{Integração}Router.cs
public class {Integração}Router(IServiceProvider sp, I{Integração}ConfigurationResolver configResolver)
    : I{Integração}Router
{
    public async Task<{Integração}RouterResult> RouteAsync(
        {Integração}Task task, /* escopo do sub-recurso, se aplicável */ CancellationToken ct)
    {
        var config = await configResolver.ResolveAsync(task.Capability, ct);

        return config.SelectionMode switch
        {
            SelectionMode.Fallback => await RunFallbackAsync(task, config, ct),
            SelectionMode.Compare  => await RunCompareAsync(task, config, ct),
            _ => throw new InvalidOperationException($"Modo de seleção desconhecido: {config.SelectionMode}")
        };
    }

    // RunFallbackAsync: tenta provedores em ordem, retorna no primeiro sucesso
    // RunCompareAsync: chama sp.GetRequiredKeyedService<TProvider>(name) para cada provider a comparar,
    //                  EM PARALELO, registra o resultado de cada tentativa, e delega a um Validator
    //                  a escolha do vencedor
}
```

### 5.4 Regras

- Nenhuma classe fora de `Infrastructure/{Integração}/` pode referenciar um SDK/cliente HTTP de um provedor específico — o resto da aplicação só conhece as portas (`I{Capacidade}Provider`) e o `I{Integração}Router`.
- Um adaptador nunca decide sozinho se deve ou não ser chamado — essa decisão é sempre do `ConfigurationResolver`/`Router`, nunca hardcoded no adaptador.
- Toda chamada a um adaptador deve ser registrada de forma auditável (custo, duração, resultado, seleção) — nenhuma chamada a um provedor externo é "silenciosa".
- Adicionar um novo provedor para uma capacidade existente é **aditivo**: nova classe de adaptador + uma linha de registro `AddKeyedScoped` — nenhum código de negócio muda.

> A lista real de capacidades, provedores e o modelo de dados de rastreamento de execução de cada produto vivem no seu documento de arquitetura.

---

## 6. Portas e Adaptadores de Infraestrutura — Configuração

O sistema deve suportar múltiplos ambientes de deploy (standalone local, cliente isolado, cloud compartilhada) **sem ramificação de código de negócio**. A portabilidade é garantida por interfaces em `Application`, com implementações alternativas em `Infrastructure`, selecionadas exclusivamente por configuração.

### 6.1 Escolha de adaptador — padrão `X:Provider`

Diferente dos adaptadores multi-provedor de §5 (todos registrados simultaneamente), integrações de infraestrutura (cache, fila, storage, log) têm **apenas um adaptador ativo por vez**, escolhido uma única vez no boot:

```csharp
string provider = configuration["X:Provider"] ?? "AdaptadorDefault";
if (string.Equals(provider, "AdaptadorAvancado", StringComparison.OrdinalIgnoreCase))
{
    // registra o adaptador avançado
}
else
{
    // registra o adaptador default
}
```

O `else` implícito (nada registrado) é intencional: um `provider` desconhecido falha no primeiro `GetRequiredService<T>()`, não silenciosamente.

| Adaptador | Chave | Default (standalone) | Avançado (opt-in) |
|---|---|---|---|
| Cache (`IDistributedCache` + lock distribuído) | `Cache:Provider` | `InMemory` | ex.: `Redis` |
| Fila (`IMessageBroker`) | `MessageBroker:Provider` | `InMemory` (retry escalonado + DLQ em processo) | ex.: `RabbitMq`, `Kafka` |
| Arquivos/mídia (`IObjectStorage`) | `ObjectStorage:Provider` | `Local` (filesystem) | ex.: `S3`, `AzureBlob`, `MinIo` |
| Log/Observabilidade | `Observability:Provider` | `File` (Serilog, rolling diário) | ex.: `Seq`, `Datadog` (+ OTel/OTLP) |

> A escolha real de qual provedor avançado usar em cada ambiente (dev/staging/produção) é uma decisão de cada produto, documentada no seu documento de arquitetura.

**Limitação do modo `InMemory` a conhecer antes de produção:** Cache e Fila guardam estado só no processo — não há coordenação entre containers diferentes. Isso só é aceitável enquanto não existir consumo cross-processo real (ex.: um Worker separado do publicador). Quando esse consumo existir, o deployment específico precisa do provider avançado.

### 6.2 Contrato — Object Storage

```csharp
// Application/Interfaces/IObjectStorage.cs
public interface IObjectStorage
{
    Task<StorageObject> UploadAsync(UploadRequest request, CancellationToken cancellationToken);
    Task<Stream> DownloadAsync(string logicalPath, CancellationToken cancellationToken);
    Task DeleteAsync(string logicalPath, CancellationToken cancellationToken);
    Task<Uri> GetDownloadUrlAsync(string logicalPath, TimeSpan expiration, CancellationToken cancellationToken);
}
```

Nenhuma classe fora de `Infrastructure/ObjectStorage/` referencia diretamente um SDK de storage — o resto da aplicação só conhece `IObjectStorage`. Nunca gerar ou persistir uma URL pública permanente para um arquivo privado: toda URL de download é temporária, via `GetDownloadUrlAsync`.

### 6.3 Integrações de Implementação Única — exceção ao padrão `X:Provider`

Nem toda integração externa tem (ou precisa ter) mais de uma implementação concorrente. Quando uma integração usa **uma única ferramenta/biblioteca**, parametrizada por argumentos (não por um segundo "provedor" a escolher), ela **não** precisa seguir o padrão `X:Provider` de §6.1 — não há o que configurar via chave `Provider`.

```text
Infrastructure/
└── {Integração}/
    └── {Ferramenta}/          # única implementação — parametrizada, não escolhida
```

Adicionar suporte a uma nova variação de saída dessa integração (ex.: um novo formato, um novo parâmetro) é uma mudança **aditiva e isolada** dentro dessa pasta — nenhuma outra camada muda. A decisão de quando uma integração se enquadra nesta exceção (em vez do padrão `X:Provider`) é documentada por produto, caso a caso, no respectivo documento de arquitetura.

---

## 7. Observabilidade e Logging

### 7.1 Onde os logs são emitidos — regra por camada

| Camada | Pode logar? | Como |
|---|---|---|
| **Domain** | **Não** | Entidades e Domain Services são código puro — zero I/O, zero `ILogger`. Se uma decisão de domínio precisa ser observável, ela deve ser exposta como um Domain Event, e é a camada que o consome (Application/Infrastructure) quem loga. |
| **Application** | Sim | `LoggingBehavior` (pipeline, todo Command/Query) + logs pontuais de handlers para decisões de negócio relevantes |
| **Infrastructure** | Sim | Adaptadores de integração, repositórios, consumidores de fila — toda chamada a sistema externo é logada (início, fim, sucesso/falha, duração) |
| **Api/Worker (Presentation)** | Sim | Middlewares (ex.: contexto de escopo — ver §4.1), exceptions não tratadas no nível HTTP |

### 7.2 Níveis de log — quando usar cada um

| Nível | `LogLevel` (.NET) | Quando usar | Habilitado em produção? |
|---|---|---|---|
| **TRACE** | `Trace` | Detalhe extremo, passo a passo interno (ex.: payload bruto antes de validação, cada iteração de um loop) — só para depuração pontual, nunca deixado ligado | Não (habilitar temporariamente só durante investigação) |
| **DEBUG** | `Debug` | Informação de diagnóstico para desenvolvedor: valores de variáveis relevantes, ramo de decisão tomado, cache hit/miss, qual adaptador foi escolhido e por quê | Não por padrão (ligar em staging/dev; ligar pontualmente em produção durante investigação) |
| **INFO** | `Information` | Marcos de negócio de alto nível: entidade criada, processo concluído, provedor selecionado para uma capacidade | Sim — volume moderado, é o nível padrão de produção |
| **WARN** | `Warning` | Situação inesperada mas recuperável: fallback de provedor acionado, retry de mensagem, configuração específica ausente caindo para o default | Sim — deve gerar atenção, não necessariamente alarme imediato |
| **ERROR** | `Error` | Falha que impede a conclusão de uma operação: exceção não tratada, integração externa esgotou todos os provedores, falha de persistência | Sim — sempre investigado |

> Além dos 5 níveis acima (os exigidos por este guia), o `LogLevel` do .NET também define `Critical` (falha que derruba o processo, ex.: erro de boot) e `None` (desliga logging) — usar apenas quando genuinamente aplicável; não são o foco deste padrão.

### 7.3 Padrão `[LoggerMessage]` (source-generated) — obrigatório

**Nenhum código novo deve usar `logger.LogInformation("texto {Var}", var)` diretamente.** Todo log é declarado como um método estático parcial anotado com `[LoggerMessage]`, agrupado em uma classe `Log` por projeto/camada. Isso evita alocação/boxing em runtime, garante checagem de template em tempo de compilação, e centraliza os `EventId` para busca/alerta em produção.

```csharp
// Application/Logging/Log.cs
public static partial class Log
{
    [LoggerMessage(
        EventId = 1001,
        Level = LogLevel.Information,
        Message = "{Entity} {EntityId} created in scope {ScopeId}")]
    public static partial void {Entity}Created(
        this ILogger logger, int entityId, int scopeId);

    [LoggerMessage(
        EventId = 1002,
        Level = LogLevel.Warning,
        Message = "Provider {Provider} failed for capability {Capability}, falling back to {NextProvider}")]
    public static partial void ProviderFallback(
        this ILogger logger, string provider, string capability, string nextProvider);
}
```

Uso no código consumidor (nunca chamando `ILogger` diretamente com string interpolada):

```csharp
logger.{Entity}Created(entity.Id, scopeId);
```

### 7.4 Faixas de `EventId` — evitar colisão entre camadas/features

Cada produto reserva faixas de 1000 números por camada/feature e documenta a tabela real de faixas no seu documento de arquitetura — ex.: `1000–1999` para uma feature de `Application`, `2000–2999` para uma integração específica de `Infrastructure`, e assim por diante. Cada nova feature reserva a próxima centena livre dentro da faixa da sua camada e documenta a reserva no topo do respectivo `Log.cs`.

### 7.5 Contexto obrigatório em todo log

Todo log de `Application`/`Infrastructure`/`Api` que ocorre dentro de uma requisição ou processamento de mensagem deve incluir, quando disponível: o identificador de tenant, o identificador do sub-recurso (ver §4), `CorrelationId`/`traceId`. Isso é responsabilidade do `LoggingBehavior` (para Commands/Queries) e do consumidor de fila (para processamento assíncrono) — nunca precisa ser passado manualmente a cada chamada de log downstream, pois o `ILogger` scope (`BeginScope`) já carrega esse contexto.

---

## 8. Configuração — `.env` vs `appsettings`

Regra central: **segredo nunca vai para `appsettings.json` nem para `appsettings.{Environment}.json`, sob nenhuma circunstância.** Segredo é sempre variável de ambiente.

| Tipo de valor | Onde vive | Versionado? | Exemplo |
|---|---|---|---|
| Chave de seleção de adaptador (`X:Provider`) | `appsettings.json` | Sim | `Cache:Provider = InMemory` |
| Threshold/flag numérico não sensível | `appsettings.json` | Sim | `Observability:File:RetainedDays = 90` |
| URL não sensível, específica de ambiente | `appsettings.{Environment}.json` | Sim | `{Integração}:{Provedor}:BaseUrl` (staging) |
| Qualquer segredo (API key, token, connection string, HMAC secret, chave de criptografia) | variável de ambiente (`.env.local` em dev; variável protegida de CI/CD em staging/produção) | **Nunca** | `{Integração}__{Provedor}__ApiKey` |
| Segredo de produção/staging | Vive **no servidor** ou no secret store do pipeline de CI/CD, fora do repositório | Não | `STAGING_DB_CONNECTION` |

### 8.1 Convenção de nome de variável de ambiente

Toda chave hierárquica `Section:SubKey` do `IConfiguration` corresponde à variável de ambiente `Section__SubKey` (duplo underscore) — mapeamento automático do ASP.NET Core, sem código adicional.

```text
appsettings: "{Integração}:{Provedor}:ApiKey"
env var:     {Integração}__{Provedor}__ApiKey
```

### 8.2 Onde cada arquivo vive

| Arquivo | Versionado? | Conteúdo |
|---|---|---|
| `appsettings.json` | Sim | Base — modo standalone, providers default (`InMemory`/`File`), thresholds não sensíveis |
| `appsettings.Development.json` | Sim | Overrides estruturais para dev local com infraestrutura compartilhada rodando (ex.: um provider avançado ligado) — **nenhuma chave de segredo, nem placeholder** |
| `appsettings.*.local.json` / `secrets.json` | Não (`.gitignore`) | Mecanismo de override pessoal, se algum dev preferir arquivo a env var — não é o caminho oficial |
| `infra/.env.Development` | Sim | Template com todo valor sensível marcado como `PREENCHER` — copiar para `.env.local` |
| `infra/.env.local` | Não (`.gitignore`) | Segredo real de desenvolvimento, por desenvolvedor |
| `.env.staging` / `.env.production` | Não — vive **no servidor**, fora do repositório e do pipeline de CI | Mantido manualmente por quem opera o ambiente |

### 8.3 Regra de validação de segredo obrigatório

Toda `Options` que representa um segredo obrigatório (connection string, chave de API de um provedor configurado como ativo) deve ser validada com `ValidateOnStart()` — o processo falha ao subir, não na primeira chamada em produção:

```csharp
services.AddOptions<{Integração}Options>()
    .Bind(configuration.GetSection("{Integração}:{Provedor}"))
    .ValidateDataAnnotations()
    .ValidateOnStart();
```

---

## 9. Estratégia de Testes

> **Regra normativa:** [`implementation-principles.md`](implementation-principles.md) §5 — níveis, o que torna um teste válido, escopo e exclusões de cobertura, e o **gate de 80%** (incluindo cobertura do diff e gate por unidade implantável). Abaixo, as ferramentas e a organização de pastas em .NET.

### 9.1 Visão geral

| Camada | Framework | Ambiente | Cobertura alvo | Execução em CI |
|---|---|---|---|---|
| **Unit** | xUnit + FluentAssertions + NSubstitute | Local / CI | 80% de linhas em `Domain` + `Application` | Todo push |
| **Architecture** | xUnit + biblioteca de teste de arquitetura sobre os assemblies | Local / CI | Sem threshold — cobre as 4 asserções de `implementation-principles.md` §2.3 | Todo push |
| **Integration** | xUnit + EF Core + dependências reais (fila, cache) | Staging | Fluxos críticos por componente | Merge para `develop` e `main` |
| **E2E** | xUnit + HttpClient (API) | Staging | Happy path + principais variantes | Merge para `main` |
| **Contract** | PactNet | Staging | Endpoints entre serviços internos, quando aplicável | Merge para `main` |
| **Load** | k6 (borda HTTP) · NBomber (alvo não-HTTP) | Ambiente de medição declarado em V21 | Só as operações de V18 — sem threshold próprio de cobertura | Merge para `main` **e** todo item que toca operação de V18 |

### 9.2 Unit Tests

**Escopo:** lógica de negócio pura em `Domain` e `Application`. Sem banco, sem fila, sem cache, sem chamada real a integração externa — dependências externas substituídas por `NSubstitute` (incluindo os `I{Capacidade}Provider` de §5).

```text
tests/
├── {Produto}.Unit.Tests/
│   ├── Application/
│   │   ├── Commands/
│   │   └── Queries/
│   └── Domain/
│       └── Entities/
└── {Produto}.Architecture.Tests/     # regra de dependência entre camadas — nível 1 §2.3
```

### 9.3 Integration Tests

**Ambiente:** staging compartilhado, com as dependências reais do produto (banco, fila, cache).

**Isolamento de dados:** cada test run cria tenant(s) e sub-recurso(s) de teste com identificadores próprios e executa cleanup ao final (`IAsyncLifetime.DisposeAsync`).

```text
tests/
└── {Produto}.Integration.Tests/
    ├── Repositories/
    ├── Messaging/
    └── Infrastructure/
```

Cenários genéricos obrigatórios (a lista real e completa, com os fluxos de negócio específicos, vive no documento de arquitetura de cada produto):

| Área | Cenário |
|---|---|
| Repositórios | CRUD com filtro de escopo (§4); isolamento cruzado (§4.3) |
| Fila publish/consume | Mensagem publicada é consumida com envelope correto, incluindo o contexto de escopo |
| Cache/lock distribuído | Lock (acquire, release, expiração) |
| Router multi-provedor (§5) | Modo `Fallback` aciona o próximo provedor após falha simulada; modo `Compare` registra o resultado de cada tentativa e seleciona exatamente um vencedor |

**Regra:** nenhum mock de banco de dados é permitido nos testes de integração.

### 9.4 E2E Tests

**Ambiente:** staging com todos os componentes deployados.

```text
tests/
└── {Produto}.E2E.Tests/
    ├── Flows/
    └── Infrastructure/      # HttpClient configurado para staging
```

### 9.5 Contract Tests

**Ferramenta:** PactNet — usar quando houver múltiplos serviços internos consumindo uns aos outros por API.

### 9.6 Load Tests — cenário de carga, orçamento e regressão

> **Regra normativa:** [`implementation-principles.md`](implementation-principles.md) §5.6 — o RNF de cinco campos (P1), a lista fechada de operações sob orçamento (V18), o cenário com limiar dentro dele (P3), a baseline medida (P4) e a definição de regressão (P5). Abaixo, a ferramenta e a forma do cenário nesta stack. O pipeline está em [`implementation-quality.md`](implementation-quality.md) §4.2.

#### Ferramenta — decidido, não opcional

| Alvo | Ferramenta | Por quê |
|---|---|---|
| **Borda HTTP** (API pública ou interna) — caso padrão | **k6** | Cenário vive **fora** da solution: não referencia tipo interno, não entra na medição de cobertura e não arrasta o teste de carga para dentro dos anéis. `thresholds` nativos com **exit code ≠ 0** e resumo exportável em JSON — que é exatamente o gate exigido por §5.6 P3 |
| **Alvo não-HTTP** — consumidor de fila, gRPC interno, biblioteca | **NBomber** | Precisa falar o protocolo/contrato em .NET. Vive em `tests/{Produto}.Load.Tests/`, referencia **apenas** os contratos públicos da borda — nunca `Domain` nem `Application` |

**Não** é escolha do dev: HTTP é k6; o resto é NBomber. Usar NBomber para carga HTTP porque "já é .NET" é o caminho por onde o teste de carga passa a chamar handler direto e deixa de medir o que o usuário sente.

#### Onde vivem os arquivos

```text
tests/
├── perf/                              # k6 — não é código de produção (§5.6 P3)
│   ├── {operacao}.perf.js             # um arquivo por linha de V18
│   ├── lib/setup.js                   # criação e limpeza do escopo de carga
│   └── baseline.json                  # baseline medida e versionada (V21)
└── {Produto}.Load.Tests/              # NBomber — só para alvo não-HTTP
```

#### Forma obrigatória do cenário

Cada arquivo `{operacao}.perf.js` declara, no mínimo:

```javascript
export const options = {
  // Condição de carga: os valores vêm da linha de V18 — nunca inventados aqui
  stages: [
    { duration: '{rampa}',  target: {usuarios} },
    { duration: '{platô}',  target: {usuarios} },
    { duration: '{rampa}',  target: 0 },
  ],
  // O limiar do orçamento mora AQUI. Violação => k6 sai com código != 0.
  thresholds: {
    'http_req_duration{operacao:{operacao}}': ['p({percentil})<{limiar_ms}'],
    'http_req_failed':                        ['rate<0.01'],
  },
  tags: { operacao: '{operacao}' },   // amarra o cenário à linha de V18
};
```

Regras do cenário — cada uma com o mesmo peso das regras de teste de §9.2–9.4:

| Regra | Verificação |
|---|---|
| **Cenário sem `thresholds` não conta** — é relatório, não gate | Busca por `thresholds` em cada `*.perf.js`; ausência = achado bloqueante (§5.6 P3) |
| Um arquivo por linha de **V18**, com o mesmo nome de operação na tag | Uma linha de V18 ↔ um arquivo ↔ um job (nível 1 §7, #21) |
| O cenário **cria e limpa** o próprio escopo de carga (`lib/setup.js`), com tenant/usuário dedicados | Execução repetida não acumula dado; mesma regra de §9.3 |
| **Nunca** contra dado pessoal de produção nem cópia dele | [`implementation-security-lgpd-copyright.md`](implementation-security-lgpd-copyright.md) §8 |
| Credenciais e URL por variável de ambiente do runner, nunca no arquivo | §8 deste guia |
| `tests/perf/` fora de `src/` — **não** entra na cobertura e **não** é exclusão de cobertura | Nível 1 §5.3 |

#### Execução local

```bash
# Roda um cenário; sai com código != 0 se o threshold do orçamento for violado
k6 run tests/perf/{operacao}.perf.js \
  --env BASE_URL=$STAGING_API_BASE_URL \
  --summary-export=tests/perf/out/{operacao}.summary.json

echo $?   # 0 = dentro do orçamento · != 0 = orçamento violado
```

A saída real deste comando — não a alegação — é o que vai no relatório de entrega do item que toca uma operação de V18 (§5.6 P6).

---

## 10. Versionamento de API

Versionamento obrigatório para qualquer mudança incompatível de contrato. Estratégia adotada: **URL versioning** (ex.: `/v1/`).

| Tipo de mudança | Breaking? | Ação |
|---|---|---|
| Remover campo do response | Sim | Nova versão obrigatória |
| Alterar tipo de um campo existente | Sim | Nova versão obrigatória |
| Tornar campo opcional em obrigatório | Sim | Nova versão obrigatória |
| Remover ou renomear endpoint | Sim | Nova versão obrigatória |
| Adicionar campo opcional ao response | Não | Pode ser lançado na versão atual |
| Adicionar novo endpoint | Não | Pode ser lançado na versão atual |
| Ampliar enum com novo valor | Não | Consumidores devem tratar valores desconhecidos graciosamente |

**Política de suporte:** máximo de 2 versões simultâneas em produção; a mais antiga entra em deprecação e é desativada após **90 dias**, sinalizada pelos headers `Deprecation`, `Sunset` e `Link`.

---

## 11. Formato de Resposta de Erro

### 11.1 Body padrão

```json
{
  "error": "snake_case_code",
  "message": "Descrição legível pelo desenvolvedor",
  "details": [
    { "field": "{campo}", "issue": "descrição da violação" }
  ],
  "traceId": "00-abc123def456-789abc01-00"
}
```

### 11.2 Convenções de HTTP Status Code

| Status | Quando usar |
|---|---|
| `400 Bad Request` | Payload sintaticamente inválido |
| `401 Unauthorized` | Token ou API Key ausente/inválido |
| `403 Forbidden` | Autenticado mas sem permissão sobre o recurso |
| `404 Not Found` | Recurso não encontrado no escopo autenticado (inclusive tentativa de acessar um sub-recurso de outro tenant — ver §4.3) |
| `409 Conflict` | Violação de regra de negócio (duplicata, conflito de estado) |
| `422 Unprocessable Entity` | Payload sintaticamente válido, semanticamente inválido |
| `429 Too Many Requests` | Rate limit atingido — incluir header `Retry-After` |
| `500 Internal Server Error` | Erro inesperado não tratado |
| `503 Service Unavailable` | Dependência indisponível — readiness falhou |

**Regra:** nunca retornar `500` para erros de validação de negócio — usar `400`, `409` ou `422` conforme o caso.
