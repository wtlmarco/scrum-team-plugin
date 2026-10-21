# Qualidade de Código — Perfil de Stack Angular (NG-Q)

> **Nível 2** das regras verificáveis de [`../../implementation-principles.md`](../../implementation-principles.md) §7 (Q1–Q23) num front-end Angular: a ferramenta e o comando que vão no `.team-project/guards.json`. Guia de escrita: [`guide.md`](guide.md).

## NG-Q1 Ferramenta por regra

| Regra (nível 1) | Ferramenta | Comando | **Ecossistema restrito** |
|---|---|---|---|
| Q11 cobertura ≥ 80 % por módulo | Jest (`coverageThreshold` por pasta) ou Karma (`coverageReporter.check.each.lines: 80`) | `npx jest --ci --coverage` · `npx ng test --watch=false --browsers=ChromeHeadless --code-coverage` | o runner do projeto com limiar **por arquivo** (`check.each`) |
| Q1 regra de dependência | `@nx/enforce-module-boundaries` · `eslint-plugin-boundaries` · `dependency-cruiser` | `npx ng lint` · `npx depcruise src` | `no-restricted-imports` por pasta |
| Q7 lint e formatação | `angular-eslint` + Prettier | `npx ng lint` · `npx prettier --check .` | `angular-eslint` só com as regras recomendadas |
| Q6 limites numéricos (§4.4) | ESLint: `complexity` 10, `max-lines-per-function` 50, `max-params` 4 | `npx ng lint` | igual |
| Q8 duplicação | `jscpd` | `npx jscpd src --threshold 3` | revisão de aderência do QA |
| Tipos | TypeScript `strict` + `strictTemplates` | `npx ng build` | igual |
| Q9 TODO com ID · Q17 supressão justificada | `quality.ps1` | — | igual |
| Q23 render (layout novo) | Playwright medindo caixas | `npx playwright test e2e/render` | igual (V22) |

## NG-Q2 `guards.json` de referência

```json
"verify": {
  "focused": "npx jest --ci {tests}", "build": "npx ng build --configuration production", "lint": "npx ng lint",
  "suite": "npx jest --ci", "coverage": "npx jest --ci --coverage", "timeoutMinutes": 9
},
"quality": {
  "coverage": "npx jest --ci --coverage", "coverageThreshold": 80,
  "lint": "npx ng lint", "format": "npx prettier --check .",
  "architecture": "npx depcruise src --config .dependency-cruiser.cjs", "duplication": "npx jscpd src --threshold 3",
  "sourceRoots": ["src/app"]
},
"targets": { "web": { "url": "http://localhost:4200", "start": "npx ng serve --configuration production", "startTimeoutSec": 240 } }
```

Com Karma no lugar do Jest: `"focused": "npx ng test --watch=false --browsers=ChromeHeadless --include {tests}"` — sem `--watch=false` o comando nunca termina.

## NG-Q3 Ficha de Vinculação pré-preenchida

| # | Vinculação | Angular |
|---|---|---|
| V1–V4 | Anéis | `src/app/domain` · `src/app/application` (portas como `InjectionToken`) · `src/app/infrastructure` · `src/app/ui` |
| V5 | Unidades implantáveis | o app Angular (build estático) — com o seu V11/V12 |
| V6 | Regra de dependência | NG-Q1, linha Q1 |
| V7 · V8 | Formatter · Linter | Prettier `--check` · `ng lint` (`angular-eslint`) |
| V9 | Duplicação | jscpd |
| V10 | Runner por nível | Jest ou Karma (unidade, componente) · Playwright (cenários, E2E, render) |
| V11–V12 | Cobertura e gate | Jest `coverageThreshold` por pasta ou Karma `check.each.lines: 80` |
| V13 | Métricas | regras de complexidade do ESLint (§4.4) |
| V14 | CI | `ng lint` → testes com cobertura → `ng build` de produção → cenários contra o build servido |
| V15 | Exclusões de cobertura | `main.ts`, `app.config.ts` (composição), ambientes, mocks |
| V16 | Ponto de composição | `app.config.ts` |
| V17 | Pipeline transversal | interceptadores HTTP |
| V18–V21 | Desempenho | `budgets` do `angular.json` e Web Vitals p75; ambiente = build de produção |
| V22 | Render | Playwright (Chromium headless, ou Edge/Chrome do sistema) |
