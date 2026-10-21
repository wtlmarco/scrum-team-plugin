# Guia de Implementação — Perfil de Stack React (RE)

> **Nível 2** de [`../../implementation-principles.md`](../../implementation-principles.md): **como** os anéis, o Clean Code e os testes se escrevem num front-end React em TypeScript. Onde divergirem, o nível 1 vence. Ferramentas, comandos e a Ficha pré-preenchida: [`quality.md`](quality.md).
> **Stack alvo:** React 18+ · TypeScript `strict` · Vite (ou Next.js) · Testing Library · Playwright.
> **Identificadores:** cada seção tem um ID estável (`RE-<n>`), citado pelo plano e pelo veredito.

## RE-1 Os anéis no projeto

| Anel (nível 1 §2.1) | Pasta | O que pode importar |
|---|---|---|
| Domínio | `src/domain/` | só TypeScript — **nunca** React, `fetch`, `window`, bibliotecas de UI |
| Aplicação | `src/application/` (casos de uso; portas em `application/ports/`) | domínio |
| Adaptadores | `src/infrastructure/` (clientes HTTP, armazenamento local, relógio) | aplicação e domínio |
| Borda | `src/ui/` (componentes, páginas, hooks de tela, rotas) | aplicação e domínio, nunca `infrastructure` direto |

- Organização por funcionalidade **dentro** de cada anel (`src/ui/checkout/…`, `src/domain/checkout/…`), não um anel por funcionalidade.
- **Relógio e geração de id são portas** — componente e domínio não chamam `Date.now()` direto; o teste e o cenário controlam a data.

## RE-2 Regra de dependência verificada

A fronteira de import é regra de lint que **falha o build** (nível 1 §2.3, Q1): `eslint-plugin-boundaries` (tipos `domain`, `application`, `infrastructure`, `ui` com as permissões de RE-1) ou `dependency-cruiser` com a mesma matriz. Ecossistema restrito: uma regra `no-restricted-imports` por pasta, no próprio ESLint.

## RE-3 Estado e efeitos

- **Estado do servidor** (dados que vêm da API) num cliente de cache (TanStack Query ou o do framework), **estado de tela** em `useState`/`useReducer`, **estado global** só quando duas áreas distantes o compartilham (Context ou um store pequeno). Nada de copiar dado do servidor para estado local "para editar" sem necessidade.
- **Regra de negócio não fica no componente nem no hook de tela**: o hook chama o caso de uso da aplicação. Componente decide **como mostrar**, não **o que vale**.
- **Efeitos** (`useEffect`) só para sincronizar com algo externo; cálculo derivado é variável, não efeito. Toda requisição cancela ao desmontar (`AbortController` ou o cliente de cache).
- **Erro e carregamento são estados da tela** (os seis estados da especificação de tela: vazio, carregando, erro, parcial, cheio, sem permissão), nunca um `console.log`.

## RE-4 Ponto de composição

`src/main.tsx` (ou o layout raiz) monta os provedores e injeta os adaptadores nas portas — um lugar só (V16). Componente recebe o caso de uso por contexto ou parâmetro; não importa o cliente HTTP.

## RE-5 Interface, acessibilidade e identificadores de teste

- **Todo controle interativo e todo item de lista tem `data-testid="<área>.<elemento>[.<id>]"`** — é o que o executor de cenários (`scripts/checks/accept.ps1`, alvo web, Playwright) e os testes usam. O contrato de teste do pedido manda nos nomes. (Testing Library prefere `getByRole`; o `data-testid` é para o cenário de aceite e para itens repetidos.)
- **Acessibilidade:** elemento nativo antes de `div` com `onClick`; rótulo em todo campo; foco visível e navegação por teclado; textos e contraste conforme a especificação; a tela não quebra com a fonte do navegador a 200 %.
- **Texto da interface centralizado** (arquivo de mensagens ou i18n): mensagem é contrato.

## RE-6 Testes por nível

| Nível | Onde | Ferramenta | Roda em |
|---|---|---|---|
| Unidade (domínio, aplicação, hooks) | `*.test.ts` ao lado do arquivo ou `tests/` | Vitest (ou Jest) | `verify`, sem navegador |
| Componente | `*.test.tsx` | Testing Library + Vitest (jsdom) | `verify` |
| Arquitetura | regra de lint (RE-2) | ESLint | `verify` (lint) |
| Cenários de aceite e E2E | `.team-project/quality-assurance/scenarios/*.scn` · `e2e/` | `accept.ps1` (Playwright) | navegador headless, site no ar |
| Render (layout novo) | `e2e/render/*.spec.ts` | Playwright medindo `boundingBox()` em 3 tamanhos de fonte × as larguras da especificação | navegador headless |

- **Teste pelo risco** (plano, regra 24): regra de negócio com teste completo e mutação; tela simples com teste de componente do contrato e os cenários.
- **Modo de execução única:** `vitest run`, `jest --ci` — nunca observação no comando de verificação (o `verify` avisa; `scripts/checks/tool-hygiene.json`).

## RE-7 Desempenho e entrega

- **Orçamento** (V18) em métrica de usuário: LCP, INP e CLS no percentil 75 (Lighthouse CI ou `web-vitals` num cenário Playwright) e tamanho do bundle (`vite build` + limite por arquivo).
- **O artefato entregue é o build de produção** (`npm run build` + `preview`): o portão do QA roda os cenários contra ele, não contra o servidor de desenvolvimento.
