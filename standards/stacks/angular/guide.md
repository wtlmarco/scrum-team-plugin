# Guia de Implementação — Perfil de Stack Angular (NG)

> **Nível 2** de [`../../implementation-principles.md`](../../implementation-principles.md): **como** os anéis, o Clean Code e os testes se escrevem num front-end Angular. Onde divergirem, o nível 1 vence. Ferramentas, comandos e a Ficha pré-preenchida: [`quality.md`](quality.md).
> **Stack alvo:** Angular 17+ (componentes standalone, signals) · TypeScript `strict` · RxJS · Jest ou Karma/Jasmine · Playwright.
> **Identificadores:** cada seção tem um ID estável (`NG-<n>`), citado pelo plano e pelo veredito.

## NG-1 Os anéis no projeto

| Anel (nível 1 §2.1) | Pasta | O que pode importar |
|---|---|---|
| Domínio | `src/app/domain/` | só TypeScript — **nunca** `@angular/*`, `HttpClient`, RxJS de tela |
| Aplicação | `src/app/application/` (casos de uso; portas como `InjectionToken` + interface em `application/ports/`) | domínio; RxJS para fluxo assíncrono |
| Adaptadores | `src/app/infrastructure/` (serviços com `HttpClient`, armazenamento, relógio) | aplicação e domínio |
| Borda | `src/app/ui/` (componentes standalone por funcionalidade, rotas, pipes de tela) | aplicação e domínio, nunca `infrastructure` direto |

- **Porta = `InjectionToken<Interface>`**; o adaptador é registrado no ponto de composição (NG-4). Componente injeta a porta, não o serviço HTTP.
- **Relógio e geração de id são portas** — o teste e o cenário controlam a data.

## NG-2 Regra de dependência verificada

Regra de lint que falha o build (Q1): `@nx/enforce-module-boundaries` em workspace Nx, ou `eslint-plugin-boundaries`/`dependency-cruiser` com a matriz de NG-1. Restrito: `no-restricted-imports` por pasta.

## NG-3 Estado e efeitos

- **Estado de tela em `signal`/`computed`**; fluxo assíncrono (requisição, debounce) em RxJS na aplicação ou no adaptador, convertido para signal na borda (`toSignal`). Uma assinatura manual sem `takeUntilDestroyed` é vazamento.
- **Regra de negócio não fica no componente nem no template**: o componente chama o caso de uso. `ChangeDetectionStrategy.OnPush` por padrão.
- **Carregamento, erro e vazio são estados da tela** (os seis estados da especificação de tela).

## NG-4 Ponto de composição

`app.config.ts` (`provideHttpClient`, `provideRouter` e os `{ provide: PORTA, useClass: Adaptador }`) — um lugar só (V16). Interceptadores HTTP fazem o pipeline transversal (token, erro, log — V17).

## NG-5 Interface, acessibilidade e identificadores de teste

- **Todo controle interativo e todo item de lista tem `data-testid="<área>.<elemento>[.<id>]"`** (`[attr.data-testid]="'destino.card.' + d.id"` em lista) — usado pelo executor de cenários (`accept.ps1`, alvo web) e pelos testes. O contrato de teste do pedido manda nos nomes.
- **Acessibilidade:** Angular CDK a11y para foco e diálogos; rótulo em todo campo do formulário reativo; navegação por teclado; a tela não quebra com a fonte a 200 %.
- **Texto da interface** em i18n (`$localize`/arquivos de tradução) ou num arquivo de mensagens.

## NG-6 Testes por nível

| Nível | Onde | Ferramenta | Roda em |
|---|---|---|---|
| Unidade (domínio, aplicação, serviços) | `*.spec.ts` | Jest (ou Karma/Jasmine) | `verify` |
| Componente | `*.spec.ts` com `TestBed` (ou Angular Testing Library) | Jest/Karma | `verify` |
| Arquitetura | regra de lint (NG-2) | ESLint | `verify` (lint) |
| Cenários de aceite e E2E | `.team-project/quality-assurance/scenarios/*.scn` · `e2e/` | `accept.ps1` (Playwright) | navegador headless, site no ar |
| Render (layout novo) | `e2e/render/*.spec.ts` | Playwright medindo `boundingBox()` | navegador headless |

- **`ng test` sempre com `--watch=false --browsers=ChromeHeadless`** no comando de verificação — sem isso o Karma observa os arquivos e nunca termina (o `verify` avisa e corta no tempo limite).
- **Teste pelo risco** (plano, regra 24).

## NG-7 Desempenho e entrega

- **Orçamento** no `angular.json` (`budgets`: tamanho inicial e por componente) e Web Vitals p75 num cenário Playwright.
- **O artefato entregue é o `ng build --configuration production`** servido estático: o portão do QA roda os cenários contra ele.
