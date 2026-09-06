# Guia de Implementação — Segurança, Privacidade (LGPD) e Direitos Autorais

**Versão:** 1.1
**Data:** 05/09/2026
**Status:** Draft normativo
**Nível:** transversal — vale para qualquer stack
**Escopo:** Agnóstico de produto

> Guia normativo, **agnóstico de produto**, para autenticação, autorização, multi-tenancy aplicada à identidade, proteção de dados pessoais (LGPD) e direitos autorais sobre conteúdo de terceiros, em qualquer solution desta organização. Todas as regras aqui são obrigatórias salvo decisão explícita em ADR.
>
> Este documento define **padrões, princípios e contratos reutilizáveis**. Ele **não contém** nomes de entidades de negócio, perfis reais, permissões reais ou o modelo de direitos autorais real de nenhum produto específico — onde usa `{Produto}`, `{Recurso}`, `{Papel}` etc., leia-se placeholders a preencher por cada solution.
>
> **A aplicação concreta destes padrões a um produto específico é responsabilidade do documento de arquitetura daquele produto** — o caminho está em `.team-project/README.md` §4, nas seções de autenticação e autorização aplicadas, direitos autorais aplicados e segurança de infraestrutura. É lá que se definem os perfis reais, as permissões reais e o modelo de direitos autorais real. Este guia nunca deve ser editado para acomodar uma decisão de um produto específico.
>
> Este guia **complementa** `implementation-guide.md` — não repete o que já está lá. Isolamento multi-tenant no banco (§4), portas de infraestrutura (§6), logging (§7), configuração/segredos (§8), testes (§9) e formato de erro (§11) daquele guia aplicam-se integralmente aqui; este documento cobre apenas o que é específico de identidade, autorização, privacidade e direitos autorais.

---

## Documentos relacionados

| Documento | Conteúdo |
|---|---|
| [`implementation-principles.md`](implementation-principles.md) | **Nível 1, agnóstico de linguagem** — Clean Architecture, Clean Code, CQRS, testes e gate de 80%. Os exemplos em C# **deste** guia são ilustração do perfil .NET; a obrigação é a porta/abstração, não a sintaxe |
| [`implementation-guide.md`](implementation-guide.md) | Perfil .NET: estrutura, CQRS, isolamento multi-tenant, adaptadores, logging, configuração, testes — pré-requisito de leitura para este guia |
| [`implementation-quality.md`](implementation-quality.md) | Perfil .NET/GitLab: Code Analysis, Coverage, Metrics e pipeline de CI |

---

## Decisões Pendentes

| Referência | Assunto | Status |
|---|---|---|
| AI-DATA-GOVERNANCE | Política de governança de dados para provedores externos de IA — quais dados podem ser enviados a cada provedor, com qual finalidade, por quanto tempo, sob quais condições contratuais (DPA) | Definição Futura, por produto |
| LGPD-LEGAL-REVIEW | Este guia define requisitos técnicos de suporte à LGPD; controlador/operador, bases legais, política de privacidade e gestão de consentimento exigem validação jurídica própria de cada produto | Definição Futura, por produto |

---

## Sumário

1. Modelo Conceitual de Identidade e Acesso
2. Autenticação — JWT/Bearer e Adaptadores de Identidade
3. Access Token, Refresh Token e Gestão de Sessão
4. Cadastro Local e Confirmação de E-mail
5. Autorização — RBAC e Permissões Granulares
6. Perfis de Referência
7. Multi-Tenancy Aplicado à Identidade
8. Proteção de Dados Pessoais (PII) e Minimização
9. Criptografia e Hashing
10. Auditoria
11. Direitos dos Titulares e Retenção (LGPD)
12. Direitos Autorais sobre Conteúdo de Terceiros
13. Proteção de Conteúdo e Entregas
14. Interfaces de Infraestrutura de Referência
15. Checklist de Aceitação

---

## 1. Modelo Conceitual de Identidade e Acesso

```text
Authentication
        │
        ▼
Identity
        │
        ▼
Tenant
        │
        ▼
User
        │
        ▼
Roles
        │
        ▼
Permissions
        │
        ▼
Authorization
        │
        ▼
Audit
```

Toda requisição só é atendida depois de passar por essa cadeia, nessa ordem. Nenhuma etapa pode ser pulada — em especial, `Authorization` nunca decide apenas com base em `Roles`, sem checar `Permissions` e a titularidade do recurso (ver §5).

---

## 2. Autenticação — JWT/Bearer e Adaptadores de Identidade

A API usa autenticação **stateless**:

```http
Authorization: Bearer <JWT>
```

O JWT contém apenas o necessário para identificação e autorização — nunca PII além do indispensável:

```json
{
  "sub": "user-id",
  "tenant": "tenant-id",
  "roles": ["{Papel}"],
  "permissions": ["{recurso}.{ação}"],
  "iss": "{produto}",
  "aud": "{produto}-api",
  "exp": 1780000000
}
```

A autenticação é **desacoplada do domínio via adaptadores** (mesmo padrão de portas e adaptadores de `implementation-guide.md` §5/§6), permitindo múltiplos provedores de identidade sem que a aplicação dependa diretamente de nenhum deles:

```csharp
// Application/Interfaces/IAuthenticationProvider.cs
public interface IAuthenticationProvider
{
    string ProviderName { get; }

    Task<AuthenticationResult> AuthenticateAsync(
        AuthenticationRequest request,
        CancellationToken cancellationToken);
}
```

```text
Infrastructure/Authentication/
├── Local/
│   └── LocalAuthenticationProvider.cs
├── {ProvedorExterno1}/          # ex.: Google
│   └── {ProvedorExterno1}AuthenticationProvider.cs
└── {ProvedorExterno2}/          # ex.: Microsoft
    └── {ProvedorExterno2}AuthenticationProvider.cs
```

Regras:

- vínculo de identidade externa deve ser **explícito e autenticado** — nunca inferido apenas por coincidência de e-mail;
- a entidade de vínculo (`ExternalIdentity` ou equivalente) armazena apenas `UserId`, `Provider`, `ProviderSubject`, `CreatedAt`, `LastLoginAt` — nada além disso (ver §8, minimização);
- cada produto define, no seu documento de arquitetura, **quais** provedores externos suporta; este guia define **como** qualquer provedor deve ser integrado — seguindo o mesmo padrão de registro `AddKeyedScoped` de `implementation-guide.md` §5.2 quando mais de um provedor de identidade externo coexistir.

---

## 3. Access Token, Refresh Token e Gestão de Sessão

```text
Access Token   → vida curta, stateless, validado sem round-trip ao banco
Refresh Token  → rotação a cada uso, revogação, armazenamento seguro (hash, nunca texto puro), rastreável por sessão
```

```csharp
// Application/Interfaces/ITokenService.cs
public interface ITokenService
{
    string GenerateAccessToken(UserIdentity identity);
    string GenerateRefreshToken();
    Task<bool> ValidateRefreshTokenAsync(string refreshToken, CancellationToken cancellationToken);
}
```

O usuário deve poder revogar uma sessão específica ou todas as sessões:

```text
User
  │
  ├── Session 1  (RefreshToken 1)
  ├── Session 2  (RefreshToken 2)
  └── Session 3  (RefreshToken 3)
```

Regra: revogar uma sessão invalida imediatamente o `RefreshToken` correspondente; o `AccessToken` já emitido permanece válido apenas até sua expiração natural (vida curta) — não há revogação de `AccessToken` individual, por ser stateless.

---

## 4. Cadastro Local e Confirmação de E-mail

```text
Cadastro → Conta Pendente → E-mail de Confirmação → Código de Verificação → Conta Confirmada → Ativação
```

Quando o produto exigir cadastro local, o usuário não deve obter acesso completo antes da confirmação de e-mail.

O código de confirmação deve possuir:

- expiração;
- uso único (`UsedAt` não nulo bloqueia reuso);
- limite de tentativas;
- armazenamento **hasheado** (`VerificationCodeHash`), nunca em texto puro.

```csharp
// Domain/Entities/EmailVerification.cs (forma conceitual)
public class {Entity}
{
    public Guid Id { get; }
    public Guid UserId { get; }
    public string CodeHash { get; }
    public DateTime ExpiresAt { get; }
    public int Attempts { get; }
    public DateTime? UsedAt { get; }
}
```

---

## 5. Autorização — RBAC e Permissões Granulares

Modelo padrão: **RBAC** (Role-Based Access Control), com possibilidade de evolução para regras baseadas em atributo/contexto quando o produto exigir.

A autorização **nunca** depende só do nome do Role — existe sempre uma camada de permissões granulares:

```text
{recurso}.read
{recurso}.write
{recurso}.delete
{recurso}.approve
{recurso}.execute
user.manage
role.manage
audit.read
```

Decisão de acesso completa:

```text
User → Tenant Membership → Role → Permission → Resource → Resource Ownership → Allow / Deny
```

**Possuir a permissão `{recurso}.write` não é suficiente** — é sempre necessário validar também se a identidade tem acesso ao recurso específico (ownership/escopo — mesmo mecanismo de `ITenantContext`/`I{SubRecurso}Context` de `implementation-guide.md` §4.1), não apenas à classe de recurso.

Cada Tenant deve poder criar **perfis personalizados**, compostos livremente a partir do catálogo de permissões:

```text
Role
    Name
    Description
    Permissions
```

```csharp
// Application/Interfaces/IAuthorizationService.cs
public interface IAuthorizationService
{
    Task<bool> HasPermissionAsync(
        Guid userId, Guid tenantId, string permissionKey,
        CancellationToken cancellationToken);

    Task<bool> HasResourceAccessAsync<TResource>(
        Guid userId, TResource resource,
        CancellationToken cancellationToken);
}
```

Aplicado como `IPipelineBehavior` (ver `implementation-guide.md` §3), executado depois de `ValidationBehavior` e antes do Handler — commands/queries anotados como `IAuthorizableRequest` declaram a permissão exigida.

---

## 6. Perfis de Referência

Como ponto de partida (a ser adaptado por produto), recomenda-se distinguir ao menos dois perfis de escopo diferente:

```text
SystemAdmin   — escopo global; SEM acesso automático ao conteúdo privado dos Tenants
TenantAdmin   — escopo dentro do Tenant; gerencia usuários, perfis, permissões
```

Além de perfis de negócio próprios de cada produto, e de um perfil típico de "usuário final" (equivalente a `Consumer`):

```text
Consumer      — acessa apenas entregas/artefatos finais autorizados
```

Regras válidas para qualquer produto:

- `SystemAdmin` **não** tem acesso automático a conteúdo privado de Tenant — acesso a conteúdo é sempre explicitamente autorizado e auditado, mesmo para administradores globais. Recomenda-se modelar esse escopo global como um atributo separado do RBAC por Tenant (ex.: `User.IsSystemAdmin`), já que `SystemAdmin` não "pertence" a um Tenant específico;
- `Consumer`/"usuário final" não tem acesso a artefatos intermediários de produção/processamento, configuração de integrações, ou revisões internas, salvo autorização explícita — apenas ao resultado final entregue;
- perfis de negócio específicos do domínio de cada produto são definidos e documentados no documento de arquitetura daquele produto — este guia não prescreve nomes de perfis de negócio.

---

## 7. Multi-Tenancy Aplicado à Identidade

O isolamento multi-tenant em si (filtro por `TenantId`, `ITenantContext`, testes de isolamento cruzado) é definido em `implementation-guide.md` §4 e se aplica sem alteração. Este guia acrescenta apenas o que é específico da identidade:

- o **contexto de Tenant nunca é confiado a partir de um valor enviado pelo cliente** — é resolvido a partir do claim `tenant` do JWT autenticado, e validado contra a relação `User ↔ Tenant` armazenada no banco (não apenas assumido);
- um `User` pode pertencer a múltiplos Tenants (relação N:N via uma entidade de vínculo, ex.: `TenantUser`), com um `Role` potencialmente diferente em cada Tenant;
- o fluxo completo de autorização de uma requisição:

```text
Request → JWT Validation → User Identity → Tenant Context → Permission Check → Resource Ownership → Allow / Deny
```

- consequência prática de API: buscar um recurso de outro Tenant responde `404`, nunca `403` — para não confirmar a existência do recurso a quem não tem acesso a ele (mesma regra de `implementation-guide.md` §4.3 e §11.2).

---

## 8. Proteção de Dados Pessoais (PII) e Minimização

Classificar explicitamente o que é PII no domínio do produto (nome, e-mail, telefone, identificadores externos, endereço, dados de perfil, logs associados ao usuário) e tratá-lo segundo os princípios:

```text
finalidade · adequação · necessidade · livre acesso · qualidade dos dados ·
transparência · segurança · prevenção · não discriminação · responsabilização
```

Minimização na prática:

```text
Dados necessários
Dados opcionais
Dados temporários
Dados de auditoria
```

Ex.: login via provedor externo não deve armazenar mais atributos de perfil do que os estritamente necessários ao funcionamento do produto.

---

## 9. Criptografia e Hashing

Abstração obrigatória, nunca uso direto de biblioteca de criptografia espalhado pelo código:

```csharp
// Application/Interfaces/IEncryptionService.cs
public interface IEncryptionService
{
    string Encrypt(string plaintext);
    string Decrypt(string ciphertext);
}
```

```text
Infrastructure/Encryption/
├── EncryptionService.cs
└── KeyManagement.cs
```

Regras:

- chaves **nunca** no código-fonte — seguem `implementation-guide.md` §8 (gestão de segredos);
- dados sensíveis em repouso (banco, object storage, backup, arquivos temporários) usam criptografia nativa do serviço quando disponível, com camada adicional da aplicação para dados particularmente sensíveis;
- **senhas nunca são criptografadas de forma reversível** — usam algoritmo de hash com salt e custo configurável, dedicado a senhas:

```csharp
// Application/Interfaces/IPasswordHasher.cs
public interface IPasswordHasher
{
    string Hash(string password);
    bool Verify(string password, string hash);
}
```

---

## 10. Auditoria

Estrutura central de auditoria, append-only:

```text
AuditLog
    Id
    TenantId          (nullable — nulo para ações de escopo global/SystemAdmin)
    UserId            (nullable — nulo quando a ação é automatizada/sistema)
    Action
    ResourceType
    ResourceId
    Timestamp
    IpAddress
    UserAgent
    Result
    Metadata
```

```csharp
// Application/Interfaces/IAuditService.cs
public interface IAuditService
{
    Task RecordAsync(AuditEvent auditEvent, CancellationToken cancellationToken);
}
```

Categorias mínimas de eventos auditáveis, adaptadas ao domínio do produto:

- **Autenticação** — login, logout, falha de login, refresh, revogação de sessão, troca de senha, confirmação de e-mail, vínculo com provedor externo;
- **Autorização** — acesso negado, alteração de permissões, criação/remoção de perfil;
- **Conteúdo** — criação, alteração, exclusão, aprovação, rejeição de recursos de negócio;
- **Processamento** — início, execução, reprocessamento, aprovação, rejeição, publicação;
- **Entrega** — criação, publicação, acesso, download, revogação.

Regras invioláveis:

- registros de auditoria são **append-only**; o próprio usuário nunca apaga os registros gerados por suas ações — remoção segue apenas política de retenção (ver §11);
- implementado como `IPipelineBehavior` (`AuditBehavior`, ver `implementation-guide.md` §3), **na mesma transação** do handler — se a auditoria falhar, a operação é revertida (fail-closed);
- logs e auditoria **nunca** armazenam: senhas, tokens, refresh tokens, códigos de confirmação, chaves criptográficas, conteúdo integral de documentos privados, ou PII desnecessária à finalidade do log.

---

## 11. Direitos dos Titulares e Retenção (LGPD)

A arquitetura deve suportar, quando aplicável ao produto:

```text
acesso aos dados · correção · anonimização · eliminação · portabilidade · informação sobre tratamento
```

Ao excluir uma identidade, separar o que é excluído do que é preservado por obrigação legal/contratual ou por pertencer ao Tenant (não à pessoa):

```text
User Identity
User PII
User Contributions
Audit Records
Business Records (do Tenant)
```

Anonimização (quando aplicável) deve ser **irreversível**:

```text
"Nome Real" → "User_Deleted_{id}"
```

Cada categoria de dado (PII, dados de autenticação, logs de auditoria, conteúdo de origem/terceiros, artefatos intermediários, entregas finais) deve ter **política de retenção própria**. Backups seguem proteção equivalente ao ambiente principal.

> **Este guia define requisitos técnicos/arquiteturais de suporte à LGPD, não constitui análise jurídica de conformidade** (ver "Decisões Pendentes" — LGPD-LEGAL-REVIEW). Especial atenção quando dados/conteúdo são enviados a provedores externos de IA: cada produto deve definir uma **política de governança de dados para IA** (ver "Decisões Pendentes" — AI-DATA-GOVERNANCE).

---

## 12. Direitos Autorais sobre Conteúdo de Terceiros

Aplica-se a qualquer produto que receba, processe ou gere conteúdo derivado de material de terceiros.

Princípio central:

> **O processamento de um conteúdo por IA ou por qualquer pipeline automatizado não altera, por si só, os direitos autorais existentes sobre o conteúdo original.**

```text
Conteúdo Original
       │
       ▼
Direitos de Uso
       │
       ▼
Derivação / Adaptação
       │
       ▼
Conteúdo Gerado
```

Modelo de referência para a entidade de origem do conteúdo (chamada `Work` neste guia — cada produto decide se modela como entidade própria ou como campos adicionados a uma entidade de negócio já existente que já representa "o conteúdo de terceiros", conforme o caso):

```text
Id
Title
Author
CopyrightHolder
SourceType             # Original | Licensed | PublicDomain | Authorized | Unknown
OwnershipDeclaration
LicenseType
CreatedBy
CreatedAt
```

Conteúdo com `SourceType = Unknown` deve poder exigir revisão antes de avançar no pipeline de processamento.

O upload/cadastro de conteúdo de terceiros exige **declaração de responsabilidade explícita e registrada**:

```text
UserId
{Recurso}Id  (Work/Content)
DeclarationVersion
AcceptedAt
IpAddress
```

A declaração **não substitui** análise jurídica ou comprovação documental quando necessária; o sistema deve permitir anexar documentos de suporte (licença, autorização, contrato, evidência de domínio público), protegidos com a mesma política de acesso dos demais arquivos privados (ver §13).

Distinguir explicitamente tipos de direito, pois possuir um não implica possuir os demais:

```text
Direito de acessar
Direito de editar
Direito de adaptar/derivar
Direito de produzir/processar
Direito de distribuir
Direito de comercializar
```

Todo conteúdo gerado a partir de material de terceiros deve manter metadados de rastreabilidade até a origem (`SourceWorkId`, versão da fonte, provedor/modelo usado, timestamp) — sem isso, a cadeia de direitos autorais se perde no pipeline.

Alterações de titularidade/licença/autorização, e a publicação de qualquer derivação, são eventos de auditoria obrigatórios (ver §10).

---

## 13. Proteção de Conteúdo e Entregas

Conteúdo de usuário/Tenant é **privado por padrão**:

```text
Default: PRIVATE
```

Compartilhamento é sempre explícito, com níveis graduais:

```text
Private → TenantOnly → Restricted → Public
```

Links de entrega/download seguem a porta `IObjectStorage` de `implementation-guide.md` §6.2 — nunca expõem o caminho físico do armazenamento diretamente:

```text
Consumer → Delivery URL → Authorization → Signed URL (IObjectStorage.GetDownloadUrlAsync) → Object Storage
```

Links devem suportar expiração, revogação, limite de acesso e controle de download — nunca URL pública permanente para conteúdo privado.

---

## 14. Interfaces de Infraestrutura de Referência

```csharp
IAuthenticationProvider
IAuthorizationService
IEncryptionService
IPasswordHasher
ITokenService
IEmailService
IAuditService
ISecretProvider     // ver implementation-guide.md §8
```

O domínio e a camada de aplicação dependem exclusivamente dessas abstrações — nunca de implementações concretas de provedor específico (biblioteca de OAuth, SDK de nuvem etc.), seguindo o mesmo princípio de portas e adaptadores de `implementation-guide.md` §5/§6.

---

## 15. Checklist de Aceitação

- [ ] API usa JWT Bearer; Access Tokens têm expiração curta; Refresh Tokens têm rotação e revogação.
- [ ] Autenticação é desacoplada via `IAuthenticationProvider`, com pelo menos autenticação local implementada.
- [ ] Vínculo de identidade externa é explícito e autenticado (nunca por e-mail coincidente).
- [ ] Cadastro local exige confirmação de e-mail com código de expiração, uso único e hasheado.
- [ ] Senhas usam hashing dedicado (`IPasswordHasher`), não criptografia reversível.
- [ ] Contexto de Tenant nunca é aceito como campo livre do cliente — sempre resolvido do JWT autenticado e validado contra o banco.
- [ ] Acesso a recurso de outro Tenant retorna `404`.
- [ ] Autorização usa RBAC + permissões granulares, validando também ownership do recurso.
- [ ] Perfis podem ser personalizados por Tenant.
- [ ] `SystemAdmin`/equivalente não tem acesso automático a conteúdo privado de Tenant.
- [ ] PII é minimizada e protegida (criptografia quando sensível).
- [ ] Segredos não estão no código-fonte (ver `implementation-guide.md` §8).
- [ ] Existe estrutura central de auditoria (`AuditLog`), append-only, registrada na mesma transação do handler, sem dados sensíveis nos logs.
- [ ] Processos de direito dos titulares (acesso, correção, anonimização, eliminação, portabilidade) estão previstos.
- [ ] Política de retenção definida por categoria de dado.
- [ ] Conteúdo de terceiros exige declaração de responsabilidade registrada antes do processamento.
- [ ] Entidade de origem do conteúdo registra `CopyrightHolder`, `SourceType`, `LicenseType`.
- [ ] Conteúdo gerado mantém metadados de rastreabilidade até a origem.
- [ ] Conteúdo é privado por padrão; compartilhamento é explícito e gradual.
- [ ] Links de entrega são assinados, com expiração e revogação — nunca URL permanente para conteúdo privado.