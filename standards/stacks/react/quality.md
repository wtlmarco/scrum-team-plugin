# Qualidade de Código — Perfil de Stack React (RE-Q)

> **Nível 2** das regras verificáveis de [`../../implementation-principles.md`](../../implementation-principles.md) §7 (Q1–Q23) num front-end React em TypeScript: a ferramenta e o comando que vão no `.team-project/guards.json`. Guia de escrita: [`guide.md`](guide.md).

## RE-Q1 Ferramenta por regra

| Regra (nível 1) | Ferramenta | Comando | **Ecossistema restrito** |
|---|---|---|---|
| Q11 cobertura ≥ 80 % por módulo | Vitest (`coverage.provider: 'v8'`, `thresholds: { lines: 80, perFile: true }`) ou Jest (`coverageThreshold` por pasta) | `npx vitest run --coverage` | o runner do projeto com limiar **por arquivo** — média do conjunto não vale (§5.4) |
| Q1 regra de dependência | `eslint-plugin-boundaries` ou `dependency-cruiser` | `npx eslint .` · `npx depcruise src` | `no-restricted-imports` por pasta |
| Q7 lint e formatação | ESLint (`typescript-eslint`, `react-hooks`, `jsx-a11y`) + Prettier | `npx eslint . --max-warnings 0` · `npx prettier --check .` | ESLint só com as regras nativas + `tsc --noEmit` |
| Q6 limites numéricos (§4.4) | ESLint: `complexity` 10, `max-lines-per-function` 50, `max-params` 4, `max-depth` | `npx eslint .` | igual (são regras nativas) |
| Q8 duplicação | `jscpd` | `npx jscpd src --threshold 3` | revisão de aderência do QA |
| Tipos | TypeScript `strict` | `npx tsc --noEmit` | igual |
| Q9 TODO com ID · Q17 supressão justificada (`eslint-disable` com `-- motivo`) | `quality.ps1` | — | igual |
| Q23 render (layout novo) | Playwright medindo caixas | `npx playwright test e2e/render` | igual (precisa do navegador headless — V22) |

## RE-Q2 `guards.json` de referência

```json
"verify": {
  "focused": "npx vitest run {tests}", "build": "npm run build", "lint": "npx eslint . --max-warnings 0",
  "suite": "npx vitest run", "coverage": "npx vitest run --coverage", "timeoutMinutes": 9
},
"quality": {
  "coverage": "npx vitest run --coverage", "coverageThreshold": 80,
  "lint": "npx eslint . --max-warnings 0", "format": "npx prettier --check .",
  "architecture": "npx depcruise src --config .dependency-cruiser.cjs", "duplication": "npx jscpd src --threshold 3",
  "sourceRoots": ["src"]
},
"targets": { "web": { "url": "http://localhost:4173", "start": "npm run build && npm run preview", "startTimeoutSec": 180 } }
```

- O `verify` põe `CI=true` sozinho (higiene do Node) e avisa comando em modo de observação.
- **Executor de cenários web:** `npm i -D playwright`; sem o navegador do Playwright ele usa o Edge ou o Chrome instalados.

## RE-Q3 Ficha de Vinculação pré-preenchida

| # | Vinculação | React |
|---|---|---|
| V1–V4 | Anéis | `src/domain` · `src/application` (portas em `ports/`) · `src/infrastructure` · `src/ui` |
| V5 | Unidades implantáveis | o site (build estático ou servidor Node do Next.js) — cada uma com o seu V11/V12 |
| V6 | Regra de dependência | RE-Q1, linha Q1 |
| V7 · V8 | Formatter · Linter | Prettier `--check` · ESLint `--max-warnings 0` |
| V9 | Duplicação | jscpd |
| V10 | Runner por nível | Vitest (unidade, componente) · Playwright (cenários, E2E, render) |
| V11–V12 | Cobertura e gate | Vitest v8, `perFile: true`, linhas ≥ 80 |
| V13 | Métricas | regras de complexidade do ESLint (§4.4) |
| V14 | CI | `tsc --noEmit` → lint → testes com cobertura → build → cenários no preview |
| V15 | Exclusões de cobertura | `main.tsx` (composição), tipos gerados, mocks de teste |
| V16 | Ponto de composição | `src/main.tsx` (provedores e adaptadores) |
| V17 | Pipeline transversal | interceptador do cliente HTTP (token, erro, log) |
| V18–V21 | Desempenho | LCP/INP/CLS p75 e tamanho do bundle; ambiente = build de produção no preview |
| V22 | Render | Playwright (Chromium headless, ou Edge/Chrome do sistema) |
