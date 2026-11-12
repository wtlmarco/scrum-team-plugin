# Guia de Implementação — Segurança de Superfície Web/API (AppSec)

**Versão:** 1.0
**Data:** 2026-11-12
**Status:** Vigente
**Nível:** transversal — vale para qualquer stack
**Escopo:** Agnóstico de produto

> Guia normativo, **agnóstico de produto**, para a **superfície de ataque dinâmica** de aplicações web e APIs: validação de entrada, injeção, saída, limites, transporte, cabeçalhos e dependências. É o eixo que o [`implementation-security-lgpd-copyright.md`](implementation-security-lgpd-copyright.md) (identidade, autorização, privacidade, direitos) não cobre. Todas as regras aqui são obrigatórias salvo decisão explícita em ADR.
>
> **O que este guia exige na origem, o pentest valida no fim** — é a base para plano e arquitetura nascerem atendendo aos controles que o Security Engineer (`/sec`) testaria. Onde cita um controle, o **mecanismo concreto por stack** fica no perfil de stack (`stacks/<stack>/guide.md`); este guia diz **o que** precisa ser verdade, não a sintaxe.
>
> **Precedência:** onde o perfil de stack divergir deste guia, o guia (transversal) vale; o perfil pode acrescentar obrigação, nunca afrouxar. Este guia **complementa** `implementation-security-lgpd-copyright.md` — não repete autenticação, autorização, segredos, auditoria nem LGPD.

---

## Documentos relacionados

| Documento | Conteúdo |
|---|---|
| [`implementation-security-lgpd-copyright.md`](implementation-security-lgpd-copyright.md) | Identidade, autorização (RBAC + ownership + 404), segredos, auditoria, LGPD, direitos autorais — o outro eixo |
| [`implementation-principles.md`](implementation-principles.md) | Nível 1: Clean Architecture, DTOs (comando/consulta não retornam entidade), gate de 80% |
| `stacks/<stack>/guide.md` · `quality.md` | O mecanismo concreto por stack e a ferramenta de verificação (SCA, lint de segurança) |

---

## Sumário

1. Entrada hostil e validação
2. Injeção
3. Codificação de saída e XSS
4. Mass assignment e exposição excessiva
5. Validação do token na borda
6. CORS
7. Cabeçalhos de segurança e transporte
8. Rate limiting e anti-enumeração
9. SSRF e saída controlada
10. Desserialização e open redirect
11. Erros sem vazamento
12. Dependências e plataforma
13. Checklist de aceitação

---

## 1. Entrada hostil e validação

Toda entrada externa é hostil até ser validada: corpo, query string, rota, cabeçalho, cookie, upload. Validação é **allow-list** (o que é aceito), nunca block-list (o que é recusado):

- **tipo, tamanho e faixa** declarados por campo, na borda, antes de qualquer uso;
- rejeição de entrada inválida com **4xx** (ver §11), nunca correção silenciosa;
- validação **do lado do servidor** — a do cliente é usabilidade, não controle;
- o DTO de entrada é **explícito** (§4): campo não declarado é ignorado, não vinculado.

## 2. Injeção

Nenhuma entrada do usuário entra numa linguagem interpretada por concatenação:

- **SQL/NoSQL:** consulta parametrizada ou ORM com parâmetros; nunca string montada com entrada. Filtro NoSQL construído a partir de objeto do usuário é validado campo a campo.
- **Comando de SO:** evitar; quando inevitável, API que recebe argumentos como lista (sem shell), com allow-list.
- **Path traversal:** caminho derivado de entrada é canonizado e confinado a um diretório base; `..` e caminho absoluto são rejeitados.
- **SSTI / XXE:** template não recebe entrada como código; parser de XML desabilita entidades externas e DTD.

## 3. Codificação de saída e XSS

Saída é codificada para o contexto em que entra (HTML, atributo, JS, URL):

- o framework de template escapa por padrão — **não desabilitar**;
- inserção de HTML bruto (`dangerouslySetInnerHTML`, `innerHTML`, `v-html` e equivalentes) é **proibida sem sanitização** por biblioteca dedicada, e cada uso leva justificativa;
- resposta de API declara `Content-Type` correto; dado do usuário nunca é refletido sem codificação.

## 4. Mass assignment e exposição excessiva

- **Mass assignment:** o DTO de entrada lista **só** os campos que o caso de uso aceita. Campo sensível — `isAdmin`, `role`, `tenantId`, `status`, preço, identificador de dono — **nunca** é vinculável pela borda; vem do contexto autenticado (`security-lgpd` §5/§7), não do request.
- **Exposição excessiva:** a resposta expõe **só** o que a tela ou o consumidor usa. Entidade de domínio não vai crua na resposta — comando e consulta retornam DTO ([`implementation-principles.md`](implementation-principles.md) §2). Campo interno (hash, segredo, flag de sistema, PII desnecessária) nunca entra no DTO de saída.

## 5. Validação do token na borda

O token é **validado**, não só decodificado (complementa `security-lgpd` §2, que define o formato):

- **assinatura** verificada; algoritmo **fixado** por allow-list — `alg: none` e algoritmo trocado pelo cliente são rejeitados;
- **`issuer`, `audience` e `lifetime`** validados; tolerância de relógio (clock skew) pequena e explícita;
- token expirado, revogado ou de audiência errada → **401**, sem exceção.

## 6. CORS

Política **explícita**, nunca permissiva por conveniência:

- origens permitidas são uma **allow-list**; refletir a origem do request ou usar coringa é proibido quando há credencial;
- `Access-Control-Allow-Credentials: true` **nunca** junto de origem coringa;
- métodos e cabeçalhos permitidos são os mínimos necessários.

## 7. Cabeçalhos de segurança e transporte

Toda resposta carrega os cabeçalhos de defesa, e o transporte é cifrado:

- **HSTS** em produção; HTTP redireciona para HTTPS;
- `X-Content-Type-Options: nosniff`, `X-Frame-Options`/CSP `frame-ancestors`, `Referrer-Policy`;
- **CSP** declarada para conteúdo servido como HTML;
- cookie de sessão com `Secure`, `HttpOnly` e `SameSite`.

## 8. Rate limiting e anti-enumeração

- **Rate limiting** nos endpoints sensíveis a abuso — login, recuperação de senha, confirmação por e-mail/SMS, verificação de e-mail em uso, qualquer envio que custe —, com **429** e `Retry-After` (ver §11);
- **anti-enumeração:** login, recuperação e verificação de existência respondem de forma **uniforme** para entrada existente e inexistente (mesma mensagem, mesmo status, tempo comparável) — não confirmam a existência de uma conta;
- sem brute force como design: bloqueio progressivo após falhas repetidas.

## 9. SSRF e saída controlada

Requisição que o servidor faz a partir de entrada do usuário (URL, webhook, importação por link, busca de imagem) é a superfície de SSRF:

- destino por **allow-list** de host/esquema; IP interno, metadados de nuvem e `localhost` são bloqueados;
- redirecionamento seguido também é validado contra a allow-list;
- a resposta externa é tratada como hostil (tamanho, tipo, tempo).

## 10. Desserialização e open redirect

- **Desserialização:** não desserializar formato que instancia tipos arbitrários a partir de entrada do usuário; preferir formato de dados (JSON) com tipo-alvo fixo.
- **Open redirect:** destino de redirecionamento derivado de entrada é validado contra allow-list de rotas/hosts internos; nunca redireciona para URL arbitrária do request.

## 11. Erros sem vazamento

- **produção não expõe stack trace, SQL, caminho de arquivo nem versão de framework** — página de erro detalhada é só de desenvolvimento;
- resposta de erro é um corpo padrão (código, mensagem legível, `traceId`), sem detalhe interno — alinhada ao formato de erro do perfil de stack;
- erro de validação de negócio usa **4xx** (400/409/422), nunca 500.

## 12. Dependências e plataforma

- **SCA** no pipeline: auditoria de dependências (ex.: `npm audit`, analisadores do SDK) com limiar que **falha o build** em vulnerabilidade conhecida de severidade alta;
- **plataforma em suporte:** framework/runtime fora de suporte (sem patch de segurança) é dívida de segurança registrada, não estado aceitável silencioso;
- **sem artefato de build que vaze o código em produção** — source map de produção desligado quando revela o fonte.

## 13. Checklist de aceitação

- [ ] Entrada validada no servidor por allow-list (tipo, tamanho, faixa); inválida → 4xx.
- [ ] Consulta parametrizada/ORM; nenhuma string de consulta montada com entrada do usuário.
- [ ] Caminho derivado de entrada é confinado a diretório base (sem path traversal).
- [ ] Saída codificada para o contexto; HTML bruto só com sanitização justificada.
- [ ] DTO de entrada explícito; campo sensível vem do contexto autenticado, não do request.
- [ ] Resposta expõe só o necessário; entidade de domínio nunca vai crua.
- [ ] Token: assinatura verificada, algoritmo fixado (sem `alg:none`), issuer/audience/lifetime validados.
- [ ] CORS por allow-list; sem coringa com credenciais.
- [ ] HSTS, nosniff, frame-ancestors/CSP, cookie `Secure`/`HttpOnly`/`SameSite`.
- [ ] Rate limiting em login/recuperação/confirmação; 429 com `Retry-After`.
- [ ] Login/recuperação/verificação de existência com resposta uniforme (anti-enumeração).
- [ ] Requisição de saída por allow-list de destino (anti-SSRF); IP interno/metadados bloqueados.
- [ ] Sem desserialização de tipo arbitrário; redirecionamento por allow-list.
- [ ] Produção não vaza stack trace/SQL/caminho; erro de negócio em 4xx.
- [ ] SCA no build com limiar que reprova; plataforma em suporte; source map de produção controlado.
