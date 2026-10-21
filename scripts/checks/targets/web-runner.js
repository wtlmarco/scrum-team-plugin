#!/usr/bin/env node
// Adaptador Web do executor de cenários (v3.51, F1): roda cenários da linguagem comum num navegador headless (Playwright).
// Chamado pelo accept.ps1: node web-runner.js <entrada.json> <saida.json>. A entrada traz url, atributo de teste
// (padrão data-testid), viewport, pasta de capturas e os cenários já lidos ({ id, title, steps: ["tap x", …] }).
// O Playwright vem do node_modules do projeto (ou do global). Sem ele, ou sem o navegador, a saída é FALHA DE AMBIENTE.
'use strict';
const fs = require('fs'), path = require('path');
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
const sel = (id) => `[${attr}="${id}"]`;
const selPrefix = (p) => `[${attr}^="${p}"]`;
const split = (rest) => { const i = rest.indexOf('='); return i < 0 ? [rest.trim(), ''] : [rest.slice(0, i).trim(), rest.slice(i + 1).trim()]; };

async function textOf(page, id) {
  const loc = page.locator(sel(id)).first();
  await loc.waitFor({ state: 'attached', timeout: 4000 }).catch(() => { throw new Error(`tag não encontrada: ${id}`); });
  const tag = await loc.evaluate((e) => e.tagName.toLowerCase());
  return (['input', 'textarea', 'select'].includes(tag) ? await loc.inputValue() : await loc.innerText()).trim();
}
async function ids(page, prefix) {
  return page.locator(selPrefix(prefix)).evaluateAll((els, a) => els.map((e) => e.getAttribute(a)), attr).then((v) => v.map((s) => s.slice(prefix.length)));
}

async function step(ctx, verb, rest, shotBase) {
  const { page } = ctx;
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
    case 'tap': {
      const loc = page.locator(sel(rest)).first();
      await loc.waitFor({ state: 'visible', timeout: 6000 }).catch(() => { throw new Error(`tag não encontrada: ${rest}`); });
      await loc.click(); await page.waitForLoadState('networkidle').catch(() => {}); break;
    }
    case 'type': { const [k, v] = split(rest); await page.locator(sel(k)).first().fill(v); break; }
    case 'slider': {
      const [id, v] = rest.split(/\s+/);
      await page.locator(sel(id)).first().evaluate((e, val) => { e.value = val; e.dispatchEvent(new Event('input', { bubbles: true })); e.dispatchEvent(new Event('change', { bubbles: true })); }, v);
      break;
    }
    case 'shot': await page.screenshot({ path: `${shotBase}-${rest}.png`, fullPage: true }); break;
    case 'assert-text': { const [k, v] = split(rest); const a = await textOf(page, k); if (a !== v) throw new Error(`esperado '${v}', obtido '${a}' em ${k}`); break; }
    case 'assert-contains': { const [k, v] = split(rest); const a = await textOf(page, k); if (!a.includes(v)) throw new Error(`'${a}' não contém '${v}' em ${k}`); break; }
    case 'assert-exists': await page.locator(sel(rest)).first().waitFor({ state: 'visible', timeout: 4000 }).catch(() => { throw new Error(`tag ausente: ${rest}`); }); break;
    case 'assert-absent': if (await page.locator(sel(rest)).count()) throw new Error(`tag presente (esperada ausente): ${rest}`); break;
    case 'assert-checked': { const [k, v] = split(rest); const c = await page.locator(sel(k)).first().isChecked(); if (c !== /^(true|sim|1)$/.test(v)) throw new Error(`${k} marcado = ${c}, esperado ${v}`); break; }
    case 'assert-count': { const [k, v] = split(rest); const got = await ids(page, k); if (got.length !== Number(v)) throw new Error(`esperado ${v} itens '${k}*', obtido ${got.length}: [${got.join(',')}]`); break; }
    case 'assert-order': {
      const [k, v] = split(rest); const got = await ids(page, k); const want = v.split(/\s*,\s*/);
      const idx = want.map((w) => got.indexOf(w));
      if (idx.includes(-1) || idx.some((x, i) => i && x < idx[i - 1])) throw new Error(`ordem diferente: esperado [${v}], lista [${got.join(',')}]`);
      break;
    }
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
  const results = [];
  for (const sc of input.scenarios) {
    const ctx = { context: null, page: null };
    ctx.fresh = async () => { if (ctx.context) await ctx.context.close(); ctx.context = await browser.newContext({ viewport: vp }); ctx.page = await ctx.context.newPage(); };
    await ctx.fresh();
    const shotBase = path.join(input.shotDir, sc.id);
    let status = 'PASSOU', detail = '';
    for (const s of sc.steps) {
      const i = s.indexOf(' '); const verb = i < 0 ? s : s.slice(0, i); const rest = i < 0 ? '' : s.slice(i + 1).trim();
      try { await step(ctx, verb, rest, shotBase); }
      catch (e) { status = 'FALHOU'; detail = `passo '${s}': ${String(e.message).split('\n')[0]}`; break; }
    }
    const shot = `${shotBase}-${status === 'PASSOU' ? 'final' : 'falha'}.png`;
    await ctx.page.screenshot({ path: shot, fullPage: true }).catch(() => {});
    results.push({ id: sc.id, title: sc.title, status, detail, shot });
    await ctx.context.close();
  }
  await browser.close();
  write({ results });
})().catch((e) => { write({ environment: `executor web caiu: ${String(e.message).split('\n')[0]}` }); process.exit(4); });
