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
// Prontidão padrão (v3.65.6): o DOM lido. 'complete' esperava todo recurso da página — fonte, imagem, endereço de fora — e um
// pedido que não termina (garden S6: fonts.gstatic.com no emulador) segurava a abertura com o app já na tela. Quem diz que o app
// está pronto é o sinal do próprio app, no readyExpr do projeto.
const DEFAULT_READY = "document.readyState !== 'loading'";

// As partes de um readyExpr ligadas por && no nível de fora (fora de parênteses, colchetes, chaves e textos). Uma parte só = [].
function splitAnd(expr) {
  const parts = []; let depth = 0, q = '', start = 0;
  for (let i = 0; i < expr.length; i++) {
    const c = expr[i];
    if (q) { if (c === '\\') i++; else if (c === q) q = ''; continue; }
    if (c === "'" || c === '"' || c === '`') q = c;
    else if ('([{'.includes(c)) depth++;
    else if (')]}'.includes(c)) depth--;
    else if (c === '&' && expr[i + 1] === '&' && depth === 0) { parts.push(expr.slice(start, i).trim()); start = i + 2; i++; }
  }
  parts.push(expr.slice(start).trim());
  return parts.length > 1 && parts.every(Boolean) ? parts : [];
}

// Retrato da página quando a prontidão estoura o prazo: a parte do readyExpr que ficou falsa, o readyState, as fontes ainda
// carregando e os endereços de outra origem que não terminaram. Diz se a espera é do app ou de um recurso que não chega.
async function readyDiag(s, ex) {
  const parts = splitAnd(ex);
  const src = `(() => {
    const o = { href: location.href, title: document.title, rs: document.readyState, fonts: document.fonts ? document.fonts.status : '', parts: [], families: [], hosts: [] };
    for (const p of ${JSON.stringify(parts)}) { let v; try { v = !!(0, eval)(p); } catch (e) { v = 'erro: ' + String(e && e.message || e).split('\\n')[0]; } o.parts.push(v); }
    const urls = [];
    if (document.fonts) {
      const loading = new Set(); document.fonts.forEach((f) => { if (f.status === 'loading') loading.add(f.family.replace(/["']/g, '')); });
      o.families = [...loading];
      for (const sh of document.styleSheets) { let rules; try { rules = sh.cssRules; } catch (e) { continue; }
        for (const r of rules || []) if (r.type === 5 && loading.has(String(r.style.getPropertyValue('font-family')).replace(/["']/g, '').trim()))
          for (const m of String(r.style.getPropertyValue('src')).matchAll(/url\\(["']?([^"')]+)/g)) urls.push(m[1]); }
    }
    for (const i of document.images) if (!i.complete && i.currentSrc) urls.push(i.currentSrc);
    for (const l of document.querySelectorAll('link[rel~=stylesheet]')) if (!l.sheet && l.href) urls.push(l.href);
    for (const u of urls) { try { const x = new URL(u, location.href); if (x.origin !== location.origin && !o.hosts.includes(x.host)) o.hosts.push(x.host); } catch (e) { /* */ } }
    return o;
  })()`;
  let d = null;
  try { const r = await s.call('Runtime.evaluate', { expression: src, returnByValue: true }); d = r.result && r.result.value; } catch (e) { /* a página não responde: fica só o prazo */ }
  if (!d) return '';
  const bits = [`página ${d.href} · ${d.title}`];
  const falsas = parts.map((p, i) => [p, d.parts[i]]).filter(([, v]) => v !== true).map(([p, v]) => (typeof v === 'string' ? `${p} (${v})` : p));
  if (falsas.length) bits.push(`falsa: ${falsas.join(' · ')}`);
  bits.push(`readyState ${d.rs}${d.fonts ? ` · fontes ${d.fonts}` : ''}${d.families.length ? ` (${d.families.join(', ')})` : ''}`);
  if (d.hosts.length) bits.push(`a página espera recurso de fora que não terminou: ${d.hosts.join(', ')}`);
  return bits.join(' — ');
}

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
  if (plan.none) return false;   // v3.65.13: nenhum rolador na tela com para onde ir (dom-probe scroll-plan)
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
  // v3.65.13: um meio que o navegador recusa (ponto do gesto fora da janela: "Position out of bounds") não derruba o passo —
  // vai ao meio seguinte; o erro do adb (ambiente) continua parando.
  for (const w of ways) {
    try { await w(); } catch (e) { if (e.kind === 'environment') throw e; continue; }
    await sleep(300);
    if ((await probe(s, 'scroll-pos', { id, axis: plan.axis })) !== plan.pos) return true;
  }
  return false;
}
async function intoView(s, id, f) {
  // v3.65.13: rola até o centro ter folga da borda (comfy); se a rolagem não anda mais, basta o centro dentro (inView).
  for (let i = 0; i < 25 && f.found && !(f.comfy === undefined ? f.inView : f.comfy); i++) {
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
// v3.65.1 (garden S6-F5, D-30): o elemento parado na tela — a caixa igual em duas leituras seguidas (até 2 s). Rolagem com
// inércia ou tela entrando com animação movem o alvo depois da medida; o toque num conteúdo que ainda desliza só o para (não
// vira clique) ou cai no vizinho. Se a espera o tirou da janela, rola de novo.
async function settle(s, id, f) {
  for (let i = 0; i < 20; i++) {
    await sleep(100);
    const g = await probe(s, 'find', { id });
    if (!g.found) return f;
    const still = Math.abs(g.box.x - f.box.x) < 0.5 && Math.abs(g.box.y - f.box.y) < 0.5;
    f = g; if (still) break;
  }
  return f.inView ? f : intoView(s, id, f);
}
// v3.65.3 (garden SC-204): a tela sem rolagem — nenhum evento de scroll há QUIET_MS (até 2 s). A caixa do alvo para antes da
// rolagem quando o rolador bate na borda (a inércia continua sem mover nada), e o toque nesse meio-tempo só para a rolagem.
const QUIET_MS = 250;
async function quiet(s) {
  const t0 = Date.now();
  for (;;) { const q = await probe(s, 'quiet'); if (q >= QUIET_MS || Date.now() - t0 > 2000) return; await sleep(Math.max(50, QUIET_MS - q)); }
}
async function pressId(s, id) {
  await quiet(s);
  let f = await reach(s, id, 6, true);
  if (!f) throw new Error(`tag não encontrada: ${id}`);
  if (f.inView) f = await settle(s, id, f);
  if (!f.inView) {
    // v3.65.13: o porquê da rolagem e o contorno do cenário (o estado da tela vem dos passos anteriores; o launch volta ao inicial).
    const p = await probe(s, 'scroll-plan', { id });
    throw new Error(`${id} existe, mas a rolagem não o trouxe à tela${p.none ? ` (${p.why})` : ''} — se um passo anterior deixou a tela num estado em que ele não aparece, volte ao estado inicial da tela antes (restart, back ou outra aba e volta)`);
  }
  await quiet(s);
  // v3.65.13: a caixa de novo depois da espera — a faixa que ainda deslizava durante o quiet levava o toque ao vizinho ("coberto").
  { const g = await probe(s, 'find', { id }); if (g.found) { f = g.comfy ? g : await intoView(s, id, g); if (!f.inView) throw new Error(`${id} saiu da tela enquanto a rolagem parava`); } }
  const x = f.box.x + f.box.w / 2, y = f.box.y + f.box.h / 2;
  const h = await probe(s, 'hit', { id, x, y });
  if (!h.ok) throw new Error(`toque em ${id} cairia em ${h.by} (coberto)`);
  await probe(s, 'arm', { id }); await press(s, x, y); await sleep(250);
  const a = await probe(s, 'armed', { id });
  if (!a.ok) throw new Error(`o toque em ${id} não chegou a ele (pointerdown ${a.got ? 'em ' + a.by : 'não disparou'})`);
  return a;
}
// Toque real com prova: o centro tem de cair no elemento (senão FALHOU "coberto") e o pointerdown tem de chegar a ele.
// v3.65.3: e tem de virar clique. Toque que chegou, terminou sem o app cancelar e não virou clique, com o elemento ainda na
// página, foi engolido pelo navegador (rolagem em curso): espera a tela parar e toca de novo, uma vez. Se o app cancelou o
// clique (defaultPrevented no fim do toque) ou o elemento saiu da página no toque, o toque conta como antes.
async function tapId(s, id) {
  let a = await pressId(s, id);
  const swallowed = (r) => !r.clicked && r.up && !r.upPrevented && r.connected;
  if (swallowed(a)) {
    a = await pressId(s, id);
    if (swallowed(a)) throw new Error(`o toque em ${id} chegou (pointerdown), mas não virou clique em 2 toques — a tela ainda rolava ou outro gesto o consumiu`);
  }
  await sleep(200);
}
async function pressBox(s, b) { await press(s, b.x + b.w / 2, b.y + b.h / 2); await sleep(350); }

// v3.65.2 (garden, portão do S6): o assert relê até o valor bater ou ASSERT_WAIT_MS — o app atualiza a tela depois do toque
// (gravação, animação, lista que recarrega), e o cenário compensava com "wait 2" fixo depois de cada toque. A falha sai com
// a última leitura. A 2ª tentativa do cenário não repete o valor diferente: a espera já está aqui (accept.ps1).
const ASSERT_WAIT_MS = 5000;
async function until(check, gapMs = 300) {
  const t0 = Date.now();
  for (;;) { const r = await check(); if (r.ok || Date.now() - t0 >= ASSERT_WAIT_MS) return r; await sleep(gapMs); }
}
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
      const lim = (s.cfg.readyTimeoutSec || 30) * 1000, t0 = Date.now(); const ex = s.cfg.readyExpr || DEFAULT_READY;
      for (;;) {
        await checkFail(s);
        if (await evalBool(s, ex)) return;
        if (Date.now() - t0 > lim) { const d = await readyDiag(s, ex); throw new Error(`o app não ficou pronto em ${lim / 1000} s (readyExpr: ${ex})${d ? ` — ${d}` : ''}`); }
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
      const r = await until(async () => { const x = await probe(s, 'read', { id: k }); const a = x.found ? x.text : ''; return { ok: x.found && (verb === 'assert-text' ? a === v : a.includes(v)), a }; });
      if (!r.ok) throw new Error(verb === 'assert-text' ? `esperado '${v}', obtido '${r.a}' em ${k}` : `'${r.a}' não contém '${v}' em ${k}`);
      return;
    }
    case 'assert-exists': if (!(await reach(s, rest, 8, false))) throw new Error(`tag ausente: ${rest}`); return;
    case 'assert-absent': if (!(await until(async () => ({ ok: !(await probe(s, 'find', { id: rest })).found }))).ok) throw new Error(`tag presente (esperada ausente): ${rest}`); return;
    case 'assert-checked': {
      const [k, v] = split(rest); if (!(await reach(s, k, 4, false))) throw new Error(`tag ausente: ${k}`);
      const want = /^(true|sim|1)$/.test(v);
      const r = await until(async () => { const c = (await probe(s, 'checked', { id: k })).checked; return { ok: c === want, c }; });
      if (!r.ok) throw new Error(`${k} marcado = ${r.c}, esperado ${v}`);
      return;
    }
    // A lista inteira custa rolar do topo ao fim: relê com intervalo maior.
    case 'assert-count': {
      const [k, v] = split(rest);
      const r = await until(async () => { const got = await collectIds(s, k); return { ok: got.length === Number(v), got }; }, 800);
      if (!r.ok) throw new Error(`esperado ${v} itens '${k}*' na lista inteira, obtido ${r.got.length}: [${r.got.join(',')}]`);
      return;
    }
    case 'assert-order': {
      const [k, v] = split(rest); const want = v.split(/\s*,\s*/);
      const r = await until(async () => { const got = await collectIds(s, k); const idx = want.map((w) => got.indexOf(w)); return { ok: !(idx.includes(-1) || idx.some((x, i) => i && x < idx[i - 1])), got }; }, 800);
      if (!r.ok) throw new Error(`ordem diferente: esperado [${v}], lista [${r.got.join(',')}]`);
      return;
    }
    default: throw new Error(`passo '${verb}' não é verbo de tela`);
  }
}

module.exports = { runStep, probe, SCREEN_VERBS, sleep, err, splitAnd, DEFAULT_READY };
