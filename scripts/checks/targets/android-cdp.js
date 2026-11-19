#!/usr/bin/env node
// Transporte CDP do alvo android (v3.62.0, targets.android.locator = "cdp"): liga os verbos de tela (cdp-verbs.js) à WebView do
// app pelo DevTools Protocol — em app híbrido o id HTML não chega ao uiautomator, mas está no DOM. O ciclo de vida do aparelho
// (instalar, abrir, reset, seed, back, clock, font-scale, captura) continua no android.ps1, que faz o adb forward e chama este
// executor UM passo por vez (a reconexão depois de launch/restart/reset/font-scale sai de graça: cada passo resolve a página).
//
//   node android-cdp.js <entrada.json> <saida.json>
//   entrada: { port, verb, rest, attr, hiddenScopes, pageUrl, readyExpr, readyTimeoutSec, failExpr, callTimeoutMs, selectConfirm,
//              scrollVia ("adb"|"cdp"), pointer ("touch"), adb, serial }
//   saída:   { ok: true } | { fail: "<motivo>" } (o app) | { environment: "<motivo>" } | { config: "<motivo>" }
//
// CDP cru (Node ≥ 22: fetch e WebSocket globais), sem dependência. Nunca chama Page.navigate (recarrega a WebView e derruba o app).
// Também é módulo (openSession/closeSession): o teste de paridade abre uma sessão por cenário num Chromium de desktop.
'use strict';
const fs = require('fs');
const { runStep, sleep, err } = require('./cdp-verbs');

async function listPages(port, ms) {
  const r = await fetch(`http://127.0.0.1:${port}/json/list`, { signal: AbortSignal.timeout(ms) });
  return (await r.json()).filter((p) => p.type === 'page');
}
// A URL da página sem a rota (v3.64.5): o app de página única muda a URL a cada navegação (/tabs/geral, #/pedido/42), e a rota
// é o estado da TELA — quem diz a tela é o id da raiz (test-ids.md §3). http(s): a origem + "/"; file:// e outros: sem ?query e
// #hash (no Cordova, file:///android_asset/www/index.html#/rota → …/index.html; a origem de file:// é "null" e não serve).
function pageKey(url) {
  const u = String(url || '');
  try { const o = new URL(u); if (o.protocol === 'http:' || o.protocol === 'https:') return `${o.origin}/`; } catch (e) { /* */ }
  return u.replace(/[?#].*$/, '');
}
// A página do app: a que casa pageUrl pela URL inteira e, sem nenhuma assim, pela URL sem a rota (v3.64.5: o pageUrl escrito na
// tela inicial, como ^https://localhost/$, continua achando o app depois que ele troca de rota). Sem pageUrl, a única que não é
// about:blank. Mais de uma sem pageUrl = configuração.
function choosePage(pages, pageUrl, targetId) {
  if (targetId) return pages.find((p) => p.id === targetId) || null;
  if (pageUrl) {
    let re; try { re = new RegExp(pageUrl); } catch (e) { throw err('config', `targets.android.cdp.pageUrl não é uma expressão regular válida (${pageUrl})`); }
    return pages.find((p) => re.test(p.url)) || pages.find((p) => re.test(pageKey(p.url))) || null;
  }
  const c = pages.filter((p) => p.url && p.url !== 'about:blank');
  if (c.length > 1) throw err('config', `a WebView tem ${c.length} páginas (${c.map((p) => p.url).join(' · ')}) — declare qual é a do app em guards.json → targets.android.cdp.pageUrl (expressão regular)`);
  return c[0] || null;
}
function connect(url, ms) {
  return new Promise((resolve, reject) => {
    const ws = new WebSocket(url);
    const t = setTimeout(() => { try { ws.close(); } catch (e) { /* */ } reject(err('environment', `o WebSocket do DevTools não abriu em ${ms} ms (${url})`)); }, ms);
    ws.onopen = () => { clearTimeout(t); resolve(ws); };
    ws.onerror = () => { clearTimeout(t); reject(err('environment', `o WebSocket do DevTools recusou a conexão (${url})`)); };
  });
}
// Sessão sobre o WebSocket da página, com prazo em cada chamada (cfg.callTimeoutMs, padrão 10 s).
async function openSession(cfg) {
  const ms = cfg.callTimeoutMs || 10000, wait = cfg.pageWaitMs != null ? cfg.pageWaitMs : ms, t0 = Date.now();
  let page = null, last = '', seen = [];
  do {
    try { const pages = await listPages(cfg.port, ms); seen = pages.map((p) => p.url).filter((u) => u && u !== 'about:blank'); page = choosePage(pages, cfg.pageUrl, cfg.targetId); last = ''; } catch (e) { if (e.kind === 'config') throw e; last = String(e.message); }
    if (page) break; await sleep(400);
  } while (Date.now() - t0 < wait);
  if (!page) {
    if (last) throw err('environment', `o DevTools da WebView não respondeu na porta ${cfg.port} (${last})`);
    // v3.64.5: a WebView tem página carregada e nenhuma casa o pageUrl → é a configuração, com as URLs vistas (a prova vem junto).
    if (cfg.pageUrl && !cfg.targetId && seen.length) throw err('config', `nenhuma página do /json casa targets.android.cdp.pageUrl (${cfg.pageUrl}): ${[...new Set(seen)].join(' · ')} — o pageUrl é a regex da origem do app (ex.: ^https://localhost(/|$)), não da rota de uma tela`);
    throw new Error('a página do app não está no /json do DevTools (o app fechou ou não carregou a WebView)');
  }
  const ws = await connect(`ws://127.0.0.1:${cfg.port}/devtools/page/${page.id}`, ms);
  let seq = 0; const pend = new Map();
  ws.onmessage = (m) => { const o = JSON.parse(m.data); const p = o.id && pend.get(o.id); if (p) { pend.delete(o.id); if (o.error) p.reject(new Error(o.error.message)); else p.resolve(o.result); } };
  ws.onclose = () => { for (const p of pend.values()) p.reject(new Error('a conexão com a página caiu (a WebView foi recriada ou o app fechou)')); pend.clear(); };
  const call = (method, params) => new Promise((resolve, reject) => {
    const id = ++seq; const t = setTimeout(() => { pend.delete(id); reject(err('environment', `${method} sem resposta do DevTools em ${ms} ms`)); }, ms);
    pend.set(id, { resolve: (v) => { clearTimeout(t); resolve(v); }, reject: (e) => { clearTimeout(t); reject(e); } });
    ws.send(JSON.stringify({ id, method, params: params || {} }));
  });
  return { cfg: { pointer: 'touch', ...cfg }, call, ws, page };
}
function closeSession(s) { try { s.ws.close(); } catch (e) { /* */ } }

module.exports = { openSession, closeSession, choosePage, pageKey };

if (require.main === module) {
  const [, , inFile, outFile] = process.argv;
  const write = (o) => fs.writeFileSync(outFile, JSON.stringify(o));
  (async () => {
    const cfg = JSON.parse(fs.readFileSync(inFile, 'utf8')); const t0 = Date.now(); let s = null;
    try {
      // A prontidão espera a página aparecer no /json (o app acabou de abrir); os outros passos, o prazo de uma chamada.
      s = await openSession({ ...cfg, pageWaitMs: cfg.verb === 'ready' ? (cfg.readyTimeoutSec || 30) * 1000 : (cfg.callTimeoutMs || 10000) });
      await runStep(s, cfg.verb, cfg.rest || '');
      write({ ok: true, ms: Date.now() - t0 });
    } catch (e) {
      const m = String((e && e.message) || e).split('\n')[0];
      write(e && e.kind === 'config' ? { config: m } : e && e.kind === 'environment' ? { environment: m } : { fail: m, ms: Date.now() - t0 });
    } finally { if (s) closeSession(s); }
    process.exit(0);
  })();
}
