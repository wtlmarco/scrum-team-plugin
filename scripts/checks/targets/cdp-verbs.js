// Verbos de TELA do executor de cenários (v3.62.0) — UMA implementação para todo alvo que fala o DevTools Protocol:
//   android, locator "cdp": a WebView do app, pelo android-cdp.js (CDP cru por adb forward), toque por dedo;
//   web: a página do Playwright, pelo CDPSession dele (web-runner.js), clique por mouse.
// tap, type, select, slider, assert-* e a espera de prontidão. A semântica está em standards/scenario-language.md; a leitura
// do DOM, em dom-probe.js. Nada de produto, de framework ou de app: o que é de um projeto vem em cfg.
//
// Sessão: { cfg, call(method, params) → Promise } — quem a abre (android-cdp.js, web-runner.js) põe o prazo em cada chamada.
// cfg: attr, hiddenScopes, pointer ("touch" | "mouse"), scrollVia ("adb" | "cdp"), adb, serial, readyExpr, readyTimeoutSec,
//      failExpr, selectConfirm.
// Erro com kind "config" | "environment" é do alvo; os demais são FALHOU (o app ou o cenário).
'use strict';
const cp = require('child_process');
const { probeSource } = require('./dom-probe');

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const err = (kind, msg) => { const e = new Error(msg); e.kind = kind; return e; };
const split = (rest) => { const i = rest.indexOf('='); return i < 0 ? [rest.trim(), ''] : [rest.slice(0, i).trim(), rest.slice(i + 1).trim()]; };
const SCREEN_VERBS = ['tap', 'type', 'select', 'slider', 'assert-text', 'assert-contains', 'assert-exists', 'assert-absent', 'assert-checked', 'assert-count', 'assert-order'];

async function probe(s, op, args) {
  const pc = { attr: s.cfg.attr || 'data-testid', hiddenScopes: s.cfg.hiddenScopes || [] };
  const r = await s.call('Runtime.evaluate', { expression: `(${probeSource})(${JSON.stringify(op)}, ${JSON.stringify(args || {})}, ${JSON.stringify(pc)})`, returnByValue: true });
  if (r.exceptionDetails) throw new Error(`leitura da página falhou (${op}): ${((r.exceptionDetails.exception && r.exceptionDetails.exception.description) || r.exceptionDetails.text || '').split('\n')[0]}`);
  return r.result.value;
}

// ---------- gestos ----------
const touch = (s) => (s.cfg.pointer || 'touch') === 'touch';
async function press(s, x, y) {
  if (touch(s)) {
    await s.call('Input.dispatchTouchEvent', { type: 'touchStart', touchPoints: [{ x, y }] }); await sleep(60);
    await s.call('Input.dispatchTouchEvent', { type: 'touchEnd', touchPoints: [] });
    return;
  }
  await s.call('Input.dispatchMouseEvent', { type: 'mouseMoved', x, y });
  await s.call('Input.dispatchMouseEvent', { type: 'mousePressed', x, y, button: 'left', clickCount: 1 }); await sleep(40);
  await s.call('Input.dispatchMouseEvent', { type: 'mouseReleased', x, y, button: 'left', clickCount: 1 });
}
async function drag(s, x1, y1, x2, y2) {
  await s.call('Input.dispatchTouchEvent', { type: 'touchStart', touchPoints: [{ x: x1, y: y1 }] });
  for (let i = 1; i <= 8; i++) { await sleep(25); await s.call('Input.dispatchTouchEvent', { type: 'touchMove', touchPoints: [{ x: x1 + (x2 - x1) * i / 8, y: y1 + (y2 - y1) * i / 8 }] }); }
  await s.call('Input.dispatchTouchEvent', { type: 'touchEnd', touchPoints: [] });
}
function adbSwipe(s, x1, y1, x2, y2, dpr) {
  const a = []; if (s.cfg.serial) a.push('-s', s.cfg.serial);
  a.push('shell', 'input', 'swipe', ...[x1, y1, x2, y2].map((v) => String(Math.round(v * dpr))), '400');
  const r = cp.spawnSync(s.cfg.adb || 'adb', a, { timeout: 20000, windowsHide: true });
  if (r.error) throw err('environment', `adb input swipe falhou (${r.error.message})`);
}
// Um gesto no rolador do plano (dir 1 = o conteúdo avança). Ordem dos meios: no aparelho, o gesto do sistema (adb, px físicos =
// CSS × devicePixelRatio) na vertical; o arrasto por toque (ou a roda do mouse, no web); o gesto sintetizado do DevTools. Confere
// que a posição mudou e tenta o meio seguinte se não mudou.
async function scrollOnce(s, plan, id) {
  // Ponto do gesto: o que o dom-probe achou dentro do rolador sem outro rolador por cima; a distância cabe na área dele.
  const b = plan.box, cx = plan.at ? plan.at.x : b.x + b.w / 2, cy = plan.at ? plan.at.y : b.y + b.h / 2;
  const room = plan.axis === 'x' ? Math.min(cx - b.x, b.x + b.w - cx) : Math.min(cy - b.y, b.y + b.h - cy);
  const d = Math.max(20, Math.min((plan.axis === 'x' ? b.w : b.h) * 0.3, room - 4));
  const ways = [];
  if (plan.axis === 'y' && s.cfg.scrollVia === 'adb') ways.push(async () => { const v = await probe(s, 'viewport'); adbSwipe(s, cx, cy + plan.dir * d, cx, cy - plan.dir * d, v.dpr); });
  if (touch(s)) ways.push(async () => (plan.axis === 'x' ? drag(s, cx + plan.dir * d, cy, cx - plan.dir * d, cy) : drag(s, cx, cy + plan.dir * d, cx, cy - plan.dir * d)));
  else ways.push(async () => s.call('Input.dispatchMouseEvent', { type: 'mouseWheel', x: cx, y: cy, deltaX: plan.axis === 'x' ? plan.dir * d * 2 : 0, deltaY: plan.axis === 'y' ? plan.dir * d * 2 : 0 }));
  ways.push(async () => s.call('Input.synthesizeScrollGesture', { x: cx, y: cy, xDistance: plan.axis === 'x' ? -plan.dir * d * 2 : 0, yDistance: plan.axis === 'y' ? -plan.dir * d * 2 : 0, gestureSourceType: touch(s) ? 'touch' : 'mouse', speed: 1600 }));
  // Último recurso, também no modo toque: a roda do mouse (medido: no Chromium headless o gesto de toque não rola a página na
  // vertical; a roda rola).
  if (touch(s)) ways.push(async () => s.call('Input.dispatchMouseEvent', { type: 'mouseWheel', x: cx, y: cy, deltaX: plan.axis === 'x' ? plan.dir * d * 2 : 0, deltaY: plan.axis === 'y' ? plan.dir * d * 2 : 0 }));
  for (const w of ways) {
    await w(); await sleep(300);
    if ((await probe(s, 'scroll-pos', { id, axis: plan.axis })) !== plan.pos) return true;
  }
  return false;
}
async function intoView(s, id, f) {
  for (let i = 0; i < 25 && f.found && !f.inView; i++) {
    const plan = await probe(s, 'scroll-plan', { id });
    if (!(await scrollOnce(s, plan, id))) break;
    f = await probe(s, 'find', { id });
  }
  return f;
}
// O elemento renderizado: espera até waitSec; ainda fora do DOM (lista virtualizada), percorre o rolador principal do topo ao
// fim. needView: rola até ele ficar na janela. null = não achou.
async function reach(s, id, waitSec, needView) {
  const t0 = Date.now(); let f;
  do { f = await probe(s, 'find', { id }); if (f.found) break; await sleep(300); } while (Date.now() - t0 < waitSec * 1000);
  if (!f.found) {
    for (let i = 0; i < 12; i++) { const p = await probe(s, 'scroll-plan', { dir: -1 }); if (p.atTop || !(await scrollOnce(s, p))) break; f = await probe(s, 'find', { id }); if (f.found) break; }
    for (let i = 0; i < 30 && !f.found; i++) { const p = await probe(s, 'scroll-plan', { dir: 1 }); if (p.atEnd || !(await scrollOnce(s, p))) break; f = await probe(s, 'find', { id }); }
  }
  if (!f.found) return null;
  return needView ? intoView(s, id, f) : f;
}
// Toque real com prova: o centro tem de cair no elemento (senão FALHOU "coberto") e o pointerdown tem de chegar a ele.
async function tapId(s, id) {
  const f = await reach(s, id, 6, true);
  if (!f) throw new Error(`tag não encontrada: ${id}`);
  if (!f.inView) throw new Error(`${id} existe, mas a rolagem não o trouxe à tela`);
  const x = f.box.x + f.box.w / 2, y = f.box.y + f.box.h / 2;
  const h = await probe(s, 'hit', { id, x, y });
  if (!h.ok) throw new Error(`toque em ${id} cairia em ${h.by} (coberto)`);
  await probe(s, 'arm'); await press(s, x, y); await sleep(250);
  const a = await probe(s, 'armed', { id });
  if (!a.ok) throw new Error(`o toque em ${id} não chegou a ele (pointerdown ${a.got ? 'em ' + a.by : 'não disparou'})`);
  await sleep(200);
}
async function pressBox(s, b) { await press(s, b.x + b.w / 2, b.y + b.h / 2); await sleep(350); }

async function evalBool(s, expr) { const r = await probe(s, 'eval', { expr }); if (!r.ok) throw err('config', `expressão inválida (${expr}): ${r.error}`); return r.value; }
async function checkFail(s) { if (s.cfg.failExpr && (await evalBool(s, s.cfg.failExpr))) throw new Error(`o app está na tela de falha dele (failExpr: ${s.cfg.failExpr})`); }

// Lista inteira (decisão de 16/11): os ids renderizados do DOM e, se a página rola, os que aparecem do topo ao fim (lista
// virtualizada) — sem os de hiddenScopes.
async function collectIds(s, prefix) {
  const seen = []; const add = (l) => { for (const v of l) if (!seen.includes(v)) seen.push(v); };
  add(await probe(s, 'ids', { prefix }));
  let p = await probe(s, 'scroll-plan', { dir: -1 });
  if (p.atTop && p.atEnd) return seen;
  for (let i = 0; i < 15 && !p.atTop; i++) { if (!(await scrollOnce(s, p))) break; add(await probe(s, 'ids', { prefix })); p = await probe(s, 'scroll-plan', { dir: -1 }); }
  let still = 0;
  for (let i = 0; i < 40; i++) {
    p = await probe(s, 'scroll-plan', { dir: 1 }); if (p.atEnd) break;
    if (!(await scrollOnce(s, p))) break;
    const n = seen.length; add(await probe(s, 'ids', { prefix }));
    still = seen.length === n ? still + 1 : 0; if (still >= 2) break;
  }
  return seen;
}

async function runStep(s, verb, rest) {
  if (verb !== 'ready') await checkFail(s);
  switch (verb) {
    case 'ready': {
      const lim = (s.cfg.readyTimeoutSec || 30) * 1000, t0 = Date.now(); const ex = s.cfg.readyExpr || "document.readyState === 'complete'";
      for (;;) {
        await checkFail(s);
        if (await evalBool(s, ex)) return;
        if (Date.now() - t0 > lim) { const u = await s.call('Runtime.evaluate', { expression: 'location.href + " · " + document.title', returnByValue: true }); throw new Error(`o app não ficou pronto em ${lim / 1000} s (readyExpr: ${ex}) — página ${u.result.value}`); }
        await sleep(400);
      }
    }
    case 'tap': return tapId(s, rest);
    case 'type': {
      const [k, v] = split(rest);
      await tapId(s, k);
      const sel = await probe(s, 'select-all', { id: k });
      if (!sel.ok) throw new Error(`${k} não tem campo editável (${sel.why})`);
      await s.call('Input.insertText', { text: v }); await sleep(150);
      return;
    }
    case 'select': {
      const [k, v] = split(rest);
      if (!(await reach(s, k, 6, true))) throw new Error(`tag não encontrada: ${k}`);
      const n = await probe(s, 'native-select', { id: k, label: v });
      if (n.native) { if (!n.ok) throw new Error(`opção '${v}' não existe em ${k} (opções: ${(n.options || []).join(', ')})`); return; }
      await tapId(s, k);
      const t0 = Date.now(); let o;
      do { o = await probe(s, 'find-text', { text: v, outside: k }); if (o.found) break; await sleep(300); } while (Date.now() - t0 < 6000);
      if (!o.found) throw new Error(`opção '${v}' não apareceu depois de tocar ${k}`);
      await pressBox(s, o.box);
      if ((await probe(s, 'find-text', { text: v, outside: k })).found) { const ok = await probe(s, 'find-button', { re: s.cfg.selectConfirm || '^(OK|Ok|Confirmar|Concluir|Pronto|Aplicar|Done)$' }); if (ok.found) await pressBox(s, ok.box); }
      return;
    }
    case 'slider': {
      const [id, val, mn, mx] = rest.split(/\s+/); const value = Number(val), min = Number(mn), max = Number(mx);
      const f = await reach(s, id, 6, true); if (!f) throw new Error(`controle deslizante não encontrado: ${id}`);
      const x = f.box.x + Math.min(f.box.w - 1, Math.max(1, f.box.w * ((value - min) / (max - min)))), y = f.box.y + f.box.h / 2;
      await press(s, x, y); await sleep(350);
      const r = await probe(s, 'value-num', { id });
      if (Number.isFinite(r.value) && Math.abs(r.value - value) > r.step) throw new Error(`${id} ficou em ${r.value}, esperado ${value}`);
      return;
    }
    case 'assert-text': case 'assert-contains': {
      const [k, v] = split(rest);
      if (!(await reach(s, k, 4, false))) throw new Error(`tag não encontrada: ${k}`);
      const a = (await probe(s, 'read', { id: k })).text;
      if (verb === 'assert-text' ? a !== v : !a.includes(v)) throw new Error(verb === 'assert-text' ? `esperado '${v}', obtido '${a}' em ${k}` : `'${a}' não contém '${v}' em ${k}`);
      return;
    }
    case 'assert-exists': if (!(await reach(s, rest, 8, false))) throw new Error(`tag ausente: ${rest}`); return;
    case 'assert-absent': if ((await probe(s, 'find', { id: rest })).found) throw new Error(`tag presente (esperada ausente): ${rest}`); return;
    case 'assert-checked': {
      const [k, v] = split(rest); if (!(await reach(s, k, 4, false))) throw new Error(`tag ausente: ${k}`);
      const c = (await probe(s, 'checked', { id: k })).checked; if (c !== /^(true|sim|1)$/.test(v)) throw new Error(`${k} marcado = ${c}, esperado ${v}`);
      return;
    }
    case 'assert-count': {
      const [k, v] = split(rest); const got = await collectIds(s, k);
      if (got.length !== Number(v)) throw new Error(`esperado ${v} itens '${k}*' na lista inteira, obtido ${got.length}: [${got.join(',')}]`);
      return;
    }
    case 'assert-order': {
      const [k, v] = split(rest); const got = await collectIds(s, k); const want = v.split(/\s*,\s*/);
      const idx = want.map((w) => got.indexOf(w));
      if (idx.includes(-1) || idx.some((x, i) => i && x < idx[i - 1])) throw new Error(`ordem diferente: esperado [${v}], lista [${got.join(',')}]`);
      return;
    }
    default: throw new Error(`passo '${verb}' não é verbo de tela`);
  }
}

module.exports = { runStep, probe, SCREEN_VERBS, sleep, err };
