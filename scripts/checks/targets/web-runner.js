#!/usr/bin/env node
// Adaptador Web do executor de cenários (v3.51, F1): roda cenários da linguagem comum num navegador headless (Playwright).
// Chamado pelo accept.ps1: node web-runner.js <entrada.json> <saida.json>. A entrada traz url, atributo de teste
// (padrão data-testid), viewport, pasta de capturas e os cenários já lidos ({ id, title, steps: ["tap x", …] }).
// O Playwright vem do node_modules do projeto (ou do global). Sem ele, ou sem o navegador, a saída é FALHA DE AMBIENTE.
// v3.62.0: os verbos de TELA (tap, type, select, slider, assert-*) são os do cdp-verbs.js — a mesma implementação do alvo android
// com locator "cdp" —, pela sessão CDP do Playwright e com clique de mouse. Aqui fica o ciclo de vida da página (reset, open,
// restart, back, clock, wait, font-scale, seed, shot). Semântica: standards/scenario-language.md. hiddenScopes: entrada opcional.
'use strict';
const fs = require('fs'), path = require('path'), cp = require('child_process');
const { runStep, SCREEN_VERBS } = require('./cdp-verbs');
const [, , inFile, outFile] = process.argv;
const input = JSON.parse(fs.readFileSync(inFile, 'utf8'));
const write = (o) => fs.writeFileSync(outFile, JSON.stringify(o, null, 1));

let pw = null;
for (const base of [process.cwd(), input.root || process.cwd()]) {
  try { pw = require(require.resolve('playwright', { paths: [base] })); break; } catch { /* tenta o próximo */ }
}
if (!pw) { try { pw = require('playwright'); } catch { /* sem playwright */ } }
if (!pw) { write({ environment: 'o Playwright não está instalado no projeto: npm i -D playwright && npx playwright install chromium' }); process.exit(4); }

const attr = input.testIdAttribute || 'data-testid';
const callMs = input.callTimeoutMs || 10000;
const verbCfg = { attr, hiddenScopes: input.hiddenScopes || [], pointer: 'mouse', scrollVia: 'cdp', selectConfirm: input.selectConfirm, callTimeoutMs: callMs };
// Sessão CDP do Playwright no formato do cdp-verbs.js (call com prazo por chamada).
async function cdpOf(ctx) {
  if (ctx.cdp && ctx.cdpPage === ctx.page) return ctx.cdp;
  const cs = await ctx.context.newCDPSession(ctx.page);
  const call = (m, p) => Promise.race([cs.send(m, p || {}), new Promise((_, rej) => setTimeout(() => { const e = new Error(`${m} sem resposta do DevTools em ${callMs} ms`); e.kind = 'environment'; rej(e); }, callMs))]);
  ctx.cdp = { cfg: verbCfg, call }; ctx.cdpPage = ctx.page;
  return ctx.cdp;
}

async function step(ctx, verb, rest, shotBase) {
  const { page } = ctx;
  if (SCREEN_VERBS.includes(verb)) { await runStep(await cdpOf(ctx), verb, rest); await page.waitForLoadState('networkidle').catch(() => {}); return; }
  switch (verb) {
    case 'reset': await ctx.fresh(); break;
    case 'launch': case 'open': await page.goto(input.url.replace(/\/$/, '') + (rest && rest.startsWith('/') ? rest : ''), { waitUntil: 'networkidle' }); break;
    case 'restart': await page.reload({ waitUntil: 'networkidle' }); break;
    case 'back': await page.goBack({ waitUntil: 'networkidle' }); break;
    case 'clock': {
      if (!page.clock) throw new Error('relógio controlável pede Playwright 1.45 ou mais novo');
      await page.clock.setFixedTime(new Date(rest.replace(' ', 'T') + ':00')); break;
    }
    case 'wait': await page.waitForTimeout(Number(rest) * 1000); break;
    case 'font-scale': await page.addStyleTag({ content: `html{font-size:${Number(rest) * 100}% !important}` }); break;
    // v3.53.7: massa de dados — o comando do projeto (targets.web.seeds.<nome>) num PowerShell filho; falhou = ambiente.
    case 'seed': {
      const cmd = (input.seeds || {})[rest];
      const envErr = (m) => { const e = new Error(m); e.environment = true; return e; };
      if (!cmd) throw envErr(`massa de dados '${rest}' não declarada em guards.json → targets.web.seeds`);
      const sec = input.seedTimeoutSec || 300;
      const r = cp.spawnSync('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-EncodedCommand', Buffer.from(cmd, 'utf16le').toString('base64')],
        { cwd: input.root || process.cwd(), env: { ...process.env, ACCEPT_TARGET: 'web', ACCEPT_SEED: rest, ACCEPT_URL: input.url }, encoding: 'utf8', timeout: sec * 1000, windowsHide: true });
      if (r.error || r.status !== 0) {
        const tail = `${r.stdout || ''}${r.stderr || ''}`.split(/\r?\n/).filter((l) => l.trim()).slice(-2).join(' / ');
        throw envErr(r.error ? `massa de dados '${rest}' sem resposta em ${sec} s (targets.web.seedTimeoutSec)` : `massa de dados '${rest}' não carregou (exit ${r.status})${tail ? ': ' + tail : ''}`);
      }
      break;
    }
    case 'shot': await page.screenshot({ path: `${shotBase}-${rest}.png`, fullPage: true }); break;
    default: throw new Error(`passo '${verb}' não existe no alvo web`);
  }
}

(async () => {
  // O navegador do Playwright primeiro; sem ele, o Edge ou o Chrome já instalados (o Edge vem com todo Windows).
  let browser, firstErr = null;
  for (const opt of [{}, { channel: 'msedge' }, { channel: 'chrome' }]) {
    try { browser = await pw.chromium.launch({ headless: true, ...opt }); break; }
    catch (e) { firstErr = firstErr || e; }
  }
  if (!browser) { write({ environment: `o navegador headless não abriu (${String(firstErr.message).split('\n')[0]}): npx playwright install chromium` }); process.exit(4); }
  const vp = input.viewport || { width: 1280, height: 800 };
  const results = []; let envFail = null;
  for (const sc of input.scenarios) {
    const ctx = { context: null, page: null };
    ctx.fresh = async () => { if (ctx.context) await ctx.context.close(); ctx.context = await browser.newContext({ viewport: vp }); ctx.page = await ctx.context.newPage(); };
    await ctx.fresh();
    const shotBase = path.join(input.shotDir, sc.id);
    let status = 'PASSOU', detail = '';
    for (const s of sc.steps) {
      const i = s.indexOf(' '); const verb = i < 0 ? s : s.slice(0, i); const rest = i < 0 ? '' : s.slice(i + 1).trim();
      try { await step(ctx, verb, rest, shotBase); }
      catch (e) {
        if (e.environment || e.kind === 'environment' || e.kind === 'config') { envFail = String(e.message).split('\n')[0]; break; }
        status = 'FALHOU'; detail = `passo '${s}': ${String(e.message).split('\n')[0]}`; break;
      }
    }
    if (envFail) { await ctx.context.close().catch(() => {}); break; }
    const shot = `${shotBase}-${status === 'PASSOU' ? 'final' : 'falha'}.png`;
    await ctx.page.screenshot({ path: shot, fullPage: true }).catch(() => {});
    results.push({ id: sc.id, title: sc.title, status, detail, shot });
    await ctx.context.close();
  }
  await browser.close();
  if (envFail) { write({ environment: envFail }); process.exit(4); }
  write({ results });
})().catch((e) => { write({ environment: `executor web caiu: ${String(e.message).split('\n')[0]}` }); process.exit(4); });
