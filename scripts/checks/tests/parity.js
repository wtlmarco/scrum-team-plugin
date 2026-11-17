#!/usr/bin/env node
// Teste de paridade dos executores de cenário (v3.62.0). Roda os cenários de fixtures/parity/parity.scn sobre a página neutra
// fixtures/parity/index.html por dois transportes e confere que cada cenário dá o veredito esperado nos dois:
//   cdp — os verbos de tela de targets/cdp-verbs.js por uma sessão CDP crua (a mesma do android-cdp.js) num Chromium de desktop
//         (Edge ou Chrome, headless) com toque emulado e tela de celular: é o caminho do alvo android com locator "cdp", sem
//         emulador;
//   web — o targets/web-runner.js (Playwright). Sem o Playwright resolvível, sai NÃO EXECUTADO com o motivo — nunca verde.
// Uso: node parity.js [--bench N]   (PARITY_BROWSER = caminho do navegador; PARITY_PLAYWRIGHT_ROOT = pasta com o playwright)
// Saída: uma linha por cenário e o resumo; exit 0 = todos os executados batem com o esperado · 1 = algum diverge · 4 = sem navegador.
'use strict';
const fs = require('fs'), os = require('os'), path = require('path'), cp = require('child_process'), url = require('url');
const { openSession, closeSession } = require('../targets/android-cdp');
const { runStep, SCREEN_VERBS, sleep } = require('../targets/cdp-verbs');

const here = __dirname, fx = path.join(here, 'fixtures', 'parity');
const page = url.pathToFileURL(path.join(fx, 'index.html')).href;
const hiddenScopes = ['.p-cache'];
const bench = (() => { const i = process.argv.indexOf('--bench'); return i > 0 ? Number(process.argv[i + 1]) || 20 : 0; })();

function readScenarios(file) {
  const out = [];
  for (const raw of fs.readFileSync(file, 'utf8').split(/\r?\n/)) {
    const l = raw.trim(); if (!l || l.startsWith('#')) continue;
    const m = /^scenario\s+(\S+)\s*(.*)$/.exec(l);
    if (m) { out.push({ id: m[1], title: m[2], steps: [], expect: /^\[FALHOU\]/.test(m[2]) ? 'FALHOU' : 'PASSOU' }); continue; }
    out[out.length - 1].steps.push(l);
  }
  return out;
}
function findBrowser() {
  const c = [process.env.PARITY_BROWSER, path.join(process.env['ProgramFiles(x86)'] || '', 'Microsoft/Edge/Application/msedge.exe'), path.join(process.env.ProgramFiles || '', 'Microsoft/Edge/Application/msedge.exe'),
    path.join(process.env.ProgramFiles || '', 'Google/Chrome/Application/chrome.exe'), '/usr/bin/google-chrome', '/usr/bin/chromium', '/usr/bin/microsoft-edge'];
  return c.find((p) => p && fs.existsSync(p)) || null;
}
async function startBrowser(exe) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'parity-'));
  const p = cp.spawn(exe, ['--headless=new', '--remote-debugging-port=0', `--user-data-dir=${dir}`, '--no-first-run', '--no-default-browser-check', '--disable-extensions', 'about:blank'], { stdio: 'ignore', windowsHide: true });
  const f = path.join(dir, 'DevToolsActivePort'); const t0 = Date.now();
  while (Date.now() - t0 < 20000) { if (fs.existsSync(f)) { const port = Number(fs.readFileSync(f, 'utf8').split(/\r?\n/)[0]); if (port) return { p, port, dir }; } await sleep(200); }
  try { p.kill(); } catch (e) { /* */ }
  throw new Error(`o navegador não abriu a porta de depuração em 20 s (${exe})`);
}
async function newTarget(port) {
  const r = await fetch(`http://127.0.0.1:${port}/json/new?about:blank`, { method: 'PUT' });
  return (await r.json()).id;
}
async function closeTarget(port, id) { try { await fetch(`http://127.0.0.1:${port}/json/close/${id}`); } catch (e) { /* */ } }

// Um cenário pelo CDP: o ciclo de vida (abrir a página) aqui — no alvo android é o android.ps1 —, os verbos de tela no cdp-verbs.
async function runCdp(port, sc) {
  const id = await newTarget(port);
  const s = await openSession({ port, targetId: id, attr: 'id', hiddenScopes, scrollVia: 'cdp', pointer: 'touch', callTimeoutMs: 10000, readyTimeoutSec: 15 });
  try {
    await s.call('Emulation.setDeviceMetricsOverride', { width: 400, height: 700, deviceScaleFactor: 2, mobile: true });
    await s.call('Emulation.setTouchEmulationEnabled', { enabled: true, maxTouchPoints: 1 });
    for (const st of sc.steps) {
      const i = st.indexOf(' '); const verb = i < 0 ? st : st.slice(0, i); const rest = i < 0 ? '' : st.slice(i + 1).trim();
      try {
        if (['open', 'launch', 'restart'].includes(verb)) { await s.call('Page.navigate', { url: page }); await sleep(200); await runStep(s, 'ready', ''); }
        else if (verb === 'wait') await sleep(Number(rest) * 1000);
        else if (SCREEN_VERBS.includes(verb)) await runStep(s, verb, rest);
        else throw new Error(`passo '${verb}' fora do teste de paridade`);
      } catch (e) { return { status: 'FALHOU', detail: `passo '${st}': ${String(e.message).split('\n')[0]}` }; }
    }
    return { status: 'PASSOU', detail: '' };
  } finally { closeSession(s); await closeTarget(port, id); }
}
function runWeb(scs) {
  const root = process.env.PARITY_PLAYWRIGHT_ROOT || process.cwd();
  try { require.resolve('playwright', { paths: [root] }); } catch (e) { return { skipped: `o Playwright não se resolve a partir de ${root} (PARITY_PLAYWRIGHT_ROOT)` }; }
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'parity-web-')); const inF = path.join(tmp, 'in.json'), outF = path.join(tmp, 'out.json');
  fs.writeFileSync(inF, JSON.stringify({ url: page, root, testIdAttribute: 'id', hiddenScopes, viewport: { width: 400, height: 700 }, shotDir: tmp, scenarios: scs.map((s) => ({ id: s.id, title: s.title, steps: s.steps })) }));
  cp.spawnSync(process.execPath, [path.join(here, '..', 'targets', 'web-runner.js'), inF, outF], { cwd: root, timeout: 600000, windowsHide: true });
  let o = null; try { o = JSON.parse(fs.readFileSync(outF, 'utf8')); } catch (e) { return { skipped: 'o web-runner.js não devolveu resultado' }; } finally { try { fs.rmSync(tmp, { recursive: true, force: true }); } catch (e) { /* */ } }
  if (o.environment) return { skipped: `o web-runner.js parou por ambiente: ${o.environment}` };
  return { results: Object.fromEntries(o.results.map((r) => [r.id, r])) };
}

(async () => {
  const scs = readScenarios(path.join(fx, 'parity.scn'));
  const exe = findBrowser();
  if (!exe) { console.log('paridade: NÃO EXECUTADO — nenhum Edge ou Chrome (PARITY_BROWSER)'); process.exit(4); }
  const b = await startBrowser(exe); let bad = 0;
  try {
    if (bench) {
      // Sobrecarga do passo pelo caminho do alvo android: um processo do Node por passo (abre o /json e o WebSocket e fecha).
      const id = await newTarget(b.port); const s0 = await openSession({ port: b.port, targetId: id }); await s0.call('Page.navigate', { url: page }); await sleep(800); closeSession(s0);
      const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'parity-bench-')); const inF = path.join(tmp, 'in.json'), outF = path.join(tmp, 'out.json');
      fs.writeFileSync(inF, JSON.stringify({ port: b.port, pageUrl: 'index\\.html', verb: 'assert-exists', rest: 'p.titulo', attr: 'id', callTimeoutMs: 10000 }));
      const t0 = Date.now(); let ok = 0;
      for (let i = 0; i < bench; i++) { cp.spawnSync(process.execPath, [path.join(here, '..', 'targets', 'android-cdp.js'), inF, outF], { windowsHide: true }); if (JSON.parse(fs.readFileSync(outF, 'utf8')).ok) ok++; }
      console.log(`bench: ${bench} passos (um processo do Node cada) em ${Date.now() - t0} ms — ${Math.round((Date.now() - t0) / bench)} ms por passo · ${ok} ok`);
      await closeTarget(b.port, id);
      return;
    }
    const cdp = {}; for (const sc of scs) cdp[sc.id] = await runCdp(b.port, sc);
    const web = runWeb(scs);
    for (const sc of scs) {
      const c = cdp[sc.id], w = web.results ? web.results[sc.id] : null;
      const ok = c.status === sc.expect && (!w || w.status === sc.expect);
      if (!ok) bad++;
      console.log(`${sc.id} cdp=${c.status} web=${w ? w.status : 'NÃO EXECUTADO'} esperado=${sc.expect} ${ok ? 'ok' : 'DIVERGE'}${!ok ? `  · cdp: ${c.detail || '-'} · web: ${w ? w.detail || '-' : '-'}` : ''}`);
    }
    const n = scs.length, cOk = scs.filter((sc) => cdp[sc.id].status === sc.expect).length;
    const wTxt = web.results ? `${scs.filter((sc) => web.results[sc.id] && web.results[sc.id].status === sc.expect).length}/${n}` : `NÃO EXECUTADO (${web.skipped})`;
    console.log(`paridade: cdp ${cOk}/${n} · web ${wTxt}`);
  } finally {
    // Encerra o navegador e apaga o perfil temporário dele (a pasta só sai depois que o processo solta os arquivos).
    try { b.p.kill(); } catch (e) { /* */ }
    for (let i = 0; i < 20; i++) { try { fs.rmSync(b.dir, { recursive: true, force: true }); break; } catch (e) { await sleep(250); } }
  }
  process.exit(bad ? 1 : 0);
})().catch((e) => { console.log(`paridade: erro — ${String(e && e.message || e).split('\n')[0]}`); process.exit(1); });
