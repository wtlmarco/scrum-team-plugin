// Leitura do DOM do executor de cenários (v3.62.0): UMA implementação de "achar, ler, contar" para todos os transportes que
// enxergam o DOM — o web-runner.js (Playwright, page.evaluate) e o android-cdp.js (CDP cru, Runtime.evaluate na WebView).
// A semântica está em standards/scenario-language.md. Nada de produto, de framework ou de app: o que é de um projeto chega
// por configuração (atributo do id de teste, hiddenScopes).
//
// Só LÊ o documento. As duas exceções da norma (selecionar o conteúdo do campo antes de digitar; escolher a opção de um
// <select> nativo, que abre fora da página) e a marca do pointerdown (um ouvinte em window, não um nó) estão nomeadas abaixo.
//
// Uso: const { probeSource } = require('./dom-probe'); avaliar `(${probeSource})(op, args, cfg)` na página.
'use strict';

/* eslint-disable no-undef */
function probe(op, args, cfg) {
  const attr = (cfg && cfg.attr) || 'data-testid';
  const scopes = (cfg && cfg.hiddenScopes) || [];

  // Pai "composto": o <slot> em que o nó é projetado, senão o pai, senão o host do shadow root aberto.
  // v3.65.3 (garden SC-161, SC-122, SC-147): pelo pai de luz, o conteúdo projetado num web component pulava o rolador e os
  // recortes que ficam no shadow root do host (no Ionic, ion-content → slot → .inner-scroll): a rolagem media a posição do
  // documento, que não rola, e desistia com a tela já rolada ("a rolagem não o trouxe à tela").
  const up = (n) => n.assignedSlot || n.parentElement || (n.parentNode && n.parentNode.host) || null;
  // Filhos pelo acessor nativo de Element: componentes com slot emulado (Stencil "scoped", como o ion-input) trocam children e
  // childNodes para devolver só o conteúdo projetado — o <input> que o próprio componente desenhou some da leitura (v3.65.3,
  // garden SC-161: "sem campo editável" num campo na tela).
  const nativeChildren = Object.getOwnPropertyDescriptor(Element.prototype, 'children').get;
  const kidsOf = (n) => Array.from(n.nodeType === 1 ? nativeChildren.call(n) : n.children);
  const roots = () => {
    const out = [document];
    const walk = (root) => { for (const el of root.querySelectorAll('*')) if (el.shadowRoot) { out.push(el.shadowRoot); walk(el.shadowRoot); } };
    walk(document); return out;
  };
  // Todos os elementos com o atributo; primeiro o documento, e os shadow roots abertos só se o documento não tiver nenhum.
  const withAttr = (pred) => {
    let all = Array.from(document.querySelectorAll(`[${attr}]`)).filter((e) => pred(e.getAttribute(attr)));
    if (!all.length) for (const r of roots().slice(1)) all = all.concat(Array.from(r.querySelectorAll(`[${attr}]`)).filter((e) => pred(e.getAttribute(attr))));
    return all;
  };
  const inScope = (el) => {
    if (!scopes.length) return false;
    for (let n = el; n; n = up(n)) { if (n.nodeType === 1) for (const s of scopes) { try { if (n.matches(s)) return true; } catch (e) { /* seletor inválido: ignorado */ } } }
    return false;
  };
  // Caixa do elemento; com display: contents (ou caixa vazia de um host), a união das caixas dos filhos.
  const box = (el) => {
    const cs = getComputedStyle(el);
    let r = cs.display === 'contents' ? null : el.getBoundingClientRect();
    if (r && r.width > 0 && r.height > 0) return { x: r.left, y: r.top, w: r.width, h: r.height };
    const kids = kidsOf(el).concat(el.shadowRoot ? kidsOf(el.shadowRoot) : []);
    let x1 = Infinity, y1 = Infinity, x2 = -Infinity, y2 = -Infinity;
    for (const k of kids) { if (getComputedStyle(k).display === 'none') continue; const b = box(k); if (b) { x1 = Math.min(x1, b.x); y1 = Math.min(y1, b.y); x2 = Math.max(x2, b.x + b.w); y2 = Math.max(y2, b.y + b.h); } }
    if (x2 > x1 && y2 > y1) return { x: x1, y: y1, w: x2 - x1, h: y2 - y1 };
    return null;
  };
  // Renderizado: nenhum ancestral com display: none, o próprio sem visibility: hidden, fora de hiddenScopes e com caixa.
  const rendered = (el) => {
    for (let n = el; n; n = up(n)) { if (n.nodeType === 1 && getComputedStyle(n).display === 'none') return false; }
    if (getComputedStyle(el).visibility === 'hidden') return false;
    if (inScope(el)) return false;
    return !!box(el);
  };
  const vw = () => window.innerWidth, vh = () => window.innerHeight;
  // A área em que o elemento aparece: a janela recortada por todo ancestral que corta o conteúdo (overflow diferente de visible).
  const clipOf = (el) => {
    let x1 = 0, y1 = 0, x2 = vw(), y2 = vh();
    for (let n = up(el); n; n = up(n)) {
      if (n.nodeType !== 1 || n === document.documentElement || n === document.body) continue;
      const cs = getComputedStyle(n); if (cs.overflowX === 'visible' && cs.overflowY === 'visible') continue;
      // v3.65.13: a área de conteúdo (sem borda nem barra de rolagem): o centro em cima da barra contava como "na tela", e o
      // hit-test dava "coberto" pelo próprio rolador.
      const r = n.getBoundingClientRect(), l = r.left + n.clientLeft, t = r.top + n.clientTop;
      const w = n.clientWidth || r.width, h = n.clientHeight || r.height;
      x1 = Math.max(x1, l); y1 = Math.max(y1, t); x2 = Math.min(x2, l + w); y2 = Math.min(y2, t + h);
    }
    return { x1, y1, x2, y2 };
  };
  // v3.65.13: folga da borda — o centro a 3 px da borda de uma faixa caía na barra de rolagem sobreposta, e o toque ia à faixa.
  // A rolagem busca o centro a 12 px da borda (ou a metade do elemento, se ele é menor); sem para onde rolar, vale o centro dentro.
  const marginOf = (b) => Math.min(12, b.w / 2, b.h / 2);
  const inClip = (el, b, m) => { if (!b) return false; const c = clipOf(el), cx = b.x + b.w / 2, cy = b.y + b.h / 2, k = m || 0; return cx >= c.x1 + k && cx <= c.x2 - k && cy >= c.y1 + k && cy <= c.y2 - k; };
  const find = (id) => withAttr((v) => v === id).find(rendered) || null;
  const describe = (el) => el ? `${el.tagName.toLowerCase()}${el.id ? '#' + el.id : ''}${el.getAttribute && el.getAttribute(attr) && attr !== 'id' ? `[${attr}=${el.getAttribute(attr)}]` : ''}${typeof el.className === 'string' && el.className.trim() ? '.' + el.className.trim().split(/\s+/).slice(0, 2).join('.') : ''}` : 'nada';
  const isField = (el) => ['input', 'textarea', 'select'].includes(el.tagName.toLowerCase());
  const descendantsDeep = (el) => { const out = []; const walk = (n) => { for (const c of kidsOf(n)) { out.push(c); if (c.shadowRoot) walk(c.shadowRoot); walk(c); } }; if (el.shadowRoot) walk(el.shadowRoot); walk(el); return out; };
  // O editável do elemento: ele mesmo (campo ou contenteditable) ou o primeiro input/textarea descendente, inclusive em shadow root.
  const editableOf = (el) => {
    if (['input', 'textarea'].includes(el.tagName.toLowerCase()) || el.isContentEditable) return el;
    return descendantsDeep(el).find((d) => ['input', 'textarea'].includes(d.tagName.toLowerCase())) || null;
  };
  // Valor lido: campo → .value; web component com value de texto ou número → esse valor; elemento sem texto próprio com um
  // único editável dentro → o valor dele; senão o texto renderizado.
  const valueOf = (el) => {
    if (isField(el)) return String(el.value);
    if (el.tagName.includes('-') && (typeof el.value === 'string' || typeof el.value === 'number')) return String(el.value);
    const text = (el.innerText || '').trim();
    if (!text) { const eds = descendantsDeep(el).filter((d) => isField(d)); if (eds.length === 1) return String(eds[0].value); }
    return text;
  };
  const deepActive = () => { let a = document.activeElement; while (a && a.shadowRoot && a.shadowRoot.activeElement) a = a.shadowRoot.activeElement; return a; };
  const within = (el, n) => { for (let x = n; x; x = up(x)) if (x === el) return true; return false; };
  const hitAt = (x, y) => { let h = document.elementFromPoint(x, y); while (h && h.shadowRoot) { const d = h.shadowRoot.elementFromPoint(x, y); if (!d || d === h) break; h = d; } return h; };
  // Rolador mais próximo na direção pedida ('y' ou 'x'); sem nenhum, o do documento.
  const scroller = (el, axis) => {
    for (let n = el ? up(el) : null; n; n = up(n)) {
      if (n.nodeType !== 1) continue;
      const cs = getComputedStyle(n), ov = axis === 'x' ? cs.overflowX : cs.overflowY;
      const can = axis === 'x' ? n.scrollWidth > n.clientWidth + 1 : n.scrollHeight > n.clientHeight + 1;
      if (can && /(auto|scroll)/.test(ov)) return n;
    }
    return document.scrollingElement || document.documentElement;
  };
  // Um ponto do rolador em que o gesto chega a ELE, e não a um rolador de dentro (lista dentro da página): amostra a área.
  const canScroll = (n, axis) => { if (n === document.scrollingElement || n === document.documentElement) return true; const cs = getComputedStyle(n); return /(auto|scroll)/.test(axis === 'x' ? cs.overflowX : cs.overflowY) && (axis === 'x' ? n.scrollWidth > n.clientWidth + 1 : n.scrollHeight > n.clientHeight + 1); };
  const ownScroller = (n, axis) => { for (let x = n; x; x = up(x)) if (x.nodeType === 1 && x !== document.body && canScroll(x, axis)) return x; return document.scrollingElement || document.documentElement; };
  const pointFor = (s, sb, axis) => {
    for (const fy of [0.5, 0.3, 0.7, 0.15, 0.85]) for (const fx of [0.5, 0.2, 0.8, 0.05, 0.95]) {
      const x = sb.x + sb.w * fx, y = sb.y + sb.h * fy, h = hitAt(x, y);
      if (h && ownScroller(h, axis) === s) return { x, y };
    }
    return { x: sb.x + sb.w / 2, y: sb.y + sb.h / 2 };
  };
  const scrollBox = (s) => { if (s === document.scrollingElement || s === document.documentElement) return { x: 0, y: 0, w: vw(), h: vh() }; const r = s.getBoundingClientRect(); return { x: Math.max(0, r.left), y: Math.max(0, r.top), w: Math.min(vw(), r.right) - Math.max(0, r.left), h: Math.min(vh(), r.bottom) - Math.max(0, r.top) }; };
  // Ionic e outros guardam o rolador dentro do shadow root do host (ion-content → .inner-scroll): o maior rolador vertical
  // renderizado da página, para a busca de quem ainda não está no DOM (lista virtualizada).
  const mainScroller = () => {
    let best = null, area = 0;
    for (const r of roots()) for (const n of r.querySelectorAll('*')) {
      if (n.scrollHeight <= n.clientHeight + 1) continue;
      const cs = getComputedStyle(n); if (!/(auto|scroll)/.test(cs.overflowY) || !rendered(n)) continue;
      const b = n.getBoundingClientRect(), a = b.width * b.height; if (a > area) { area = a; best = n; }
    }
    return best || document.scrollingElement || document.documentElement;
  };

  switch (op) {
    case 'viewport': return { w: vw(), h: vh(), dpr: window.devicePixelRatio || 1 };
    case 'find': {
      const all = withAttr((v) => v === args.id); const el = all.find(rendered) || null;
      if (!el) return { found: false, count: all.length };
      const b = box(el); return { found: true, box: b, inView: inClip(el, b), comfy: inClip(el, b, b ? marginOf(b) : 0), count: all.length };
    }
    case 'read': { const el = find(args.id); return el ? { found: true, text: valueOf(el) } : { found: false }; }
    case 'checked': {
      const el = find(args.id); if (!el) return { found: false };
      if (typeof el.checked === 'boolean') return { found: true, checked: el.checked };
      const ac = el.getAttribute('aria-checked'); if (ac !== null) return { found: true, checked: ac === 'true' };
      const inner = descendantsDeep(el).find((d) => typeof d.checked === 'boolean'); return { found: true, checked: !!(inner && inner.checked) };
    }
    case 'ids': return withAttr((v) => v.startsWith(args.prefix)).filter(rendered).map((e) => e.getAttribute(attr).slice(args.prefix.length));
    case 'hit': {
      const el = find(args.id); if (!el) return { ok: false, by: 'nada (o elemento sumiu)' };
      const h = hitAt(args.x, args.y); return { ok: !!h && within(el, h), by: describe(h) };
    }
    // Marca do pointerdown: um ouvinte em window (captura) guarda o alvo e o caminho do próximo pointerdown — prova que o toque
    // chegou. v3.65.1 (garden S6, D-30): o elemento do toque é guardado no arm e o caminho no próprio evento, e o armed confere
    // por eles — o toque que fecha o alerta ou troca a página tira o elemento da tela antes da conferência, e procurá-lo de
    // novo dava "não chegou a ele" com o toque certo.
    // v3.65.3 (garden SC-204): o arm também guarda o click e o fim do toque (touchend/mouseup, na fase de bolha em window, depois
    // dos ouvintes do app: defaultPrevented diz se o app cancelou o clique de propósito). Medido no aparelho: o toque numa faixa
    // que ainda rolava teve pointerdown e touchend no alvo, sem cancelamento, e nenhum click — o navegador usou o toque para
    // parar a rolagem.
    case 'arm': {
      window.__teamPd = null; window.__teamPdPath = null; window.__teamArmEl = args.id ? find(args.id) : null;
      window.__teamClickPath = null; window.__teamUp = null;
      if (!window.__teamPdOn) { window.addEventListener('pointerdown', (e) => { const p = e.composedPath(); window.__teamPd = p[0] || e.target; window.__teamPdPath = p; }, true); window.__teamPdOn = true; }
      if (!window.__teamClickOn) {
        window.addEventListener('click', (e) => { window.__teamClickPath = e.composedPath(); }, true);
        const up = (e) => { window.__teamUp = { prevented: !!(e.defaultPrevented || (window.__teamUp && window.__teamUp.prevented)) }; };
        window.addEventListener('touchend', up, false); window.addEventListener('mouseup', up, false);
        window.__teamClickOn = true;
      }
      return true;
    }
    case 'armed': {
      const el = window.__teamArmEl || find(args.id); const t = window.__teamPd; const p = window.__teamPdPath || [];
      const cp = window.__teamClickPath; const u = window.__teamUp;
      return { got: !!t, ok: !!(el && t && (p.includes(el) || within(el, t))), by: describe(t), clicked: !!(el && cp && (cp.includes(el) || (cp[0] && within(el, cp[0])))),
        up: !!u, upPrevented: !!(u && u.prevented), connected: !!(el && el.isConnected) };
    }
    // Rolagem em curso (v3.65.3): ms desde o último evento de scroll em qualquer rolador (captura em window). Na 1ª chamada o
    // ouvinte nasce e a resposta é 0 — quem espera observa pelo menos uma janela antes de dar a tela por parada.
    case 'quiet': {
      if (!window.__teamScrollOn) { window.__teamLastScroll = performance.now(); window.addEventListener('scroll', () => { window.__teamLastScroll = performance.now(); }, { capture: true, passive: true }); window.__teamScrollOn = true; return 0; }
      return Math.round(performance.now() - window.__teamLastScroll);
    }
    case 'focused': { const el = find(args.id); const ed = el && editableOf(el); const a = deepActive(); return { ok: !!(ed && a === ed), editable: !!ed }; }
    // Exceção 1 da norma: seleciona TODO o conteúdo do editável (não grava valor) para o texto inserido substituí-lo.
    case 'select-all': {
      const el = find(args.id); const ed = el && editableOf(el); if (!ed) return { ok: false, why: 'sem campo editável' };
      if (deepActive() !== ed) ed.focus();
      if (ed.isContentEditable) { const s = getSelection(); s.selectAllChildren(ed); return { ok: true }; }
      try { ed.setSelectionRange(0, String(ed.value).length); } catch (e) { ed.select(); }
      return { ok: true };
    }
    // Exceção 2 da norma: <select> nativo abre fora da página; a opção é escolhida pelo rótulo e o evento disparado.
    case 'native-select': {
      const el = find(args.id); if (!el) return { found: false };
      if (el.tagName.toLowerCase() !== 'select') return { found: true, native: false };
      const o = Array.from(el.options).find((x) => x.label.trim() === args.label || x.text.trim() === args.label);
      if (!o) return { found: true, native: true, ok: false, options: Array.from(el.options).map((x) => x.text.trim()) };
      el.value = o.value; el.dispatchEvent(new Event('input', { bubbles: true })); el.dispatchEvent(new Event('change', { bubbles: true }));
      return { found: true, native: true, ok: true };
    }
    // Opção pelo texto visível, fora do controle (que pode mostrar o valor atual): a mais interna e, entre iguais, a última.
    case 'find-text': {
      const ctl = args.outside ? find(args.outside) : null; let hit = null;
      for (const r of roots()) for (const n of r.querySelectorAll('*')) {
        if ((n.innerText || n.textContent || '').trim() !== args.text) continue;
        if (ctl && within(ctl, n)) continue;
        if (!rendered(n)) continue;
        if (kidsOf(n).some((c) => (c.innerText || '').trim() === args.text && rendered(c))) continue;
        hit = n;
      }
      return hit ? { found: true, box: box(hit), inView: inClip(hit, box(hit)) } : { found: false };
    }
    case 'find-button': {
      let re; try { re = new RegExp(args.re); } catch (e) { return { found: false }; }
      for (const r of roots()) for (const n of r.querySelectorAll('button, [role="button"]')) {
        const t = (n.innerText || n.getAttribute('aria-label') || '').trim(); if (re.test(t) && rendered(n)) return { found: true, box: box(n) };
      }
      return { found: false };
    }
    case 'value-num': { const el = find(args.id); if (!el) return { found: false }; const v = Number(isField(el) || el.tagName.includes('-') ? el.value : NaN); const st = Number(el.step || (el.getAttribute && el.getAttribute('step')) || 1); return { found: true, value: v, step: Number.isFinite(st) && st > 0 ? st : 1 }; }
    // Onde rolar para trazer o elemento à janela: o rolador do eixo, a caixa dele e para que lado.
    // v3.65.13 (garden SC-142): o eixo e o rolador vêm da posição do elemento E da do rolador. Antes, o elemento fora da janela
    // na horizontal escolhia o eixo x, mesmo com a faixa que o contém fora da tela pelo alto (lista rolada para baixo): o gesto
    // ia para um ponto fora da janela e o navegador o recusava ("Position out of bounds"). Agora: fora na vertical, rola a
    // vertical primeiro (a faixa volta à vista; a horizontal vem no passo seguinte). O rolador é o mais próximo que aparece na
    // janela (área visível dentro dos recortes de cima) e ainda tem para onde ir naquele lado — a faixa de pílulas mais alta
    // que ela mesma também "rola" na vertical, alguns pixels, e não traz nada. O rolador escolhido fica em
    // window.__teamPlanS (marca, como a do pointerdown) para o scroll-pos medir o mesmo.
    case 'scroll-plan': {
      const el = args.id ? find(args.id) : null;
      if (el) {
        const b = box(el), c = clipOf(el), cx = b.x + b.w / 2, cy = b.y + b.h / 2, m = marginOf(b);
        const outY = cy < c.y1 + m || cy > c.y2 - m, outX = cx < c.x1 + m || cx > c.x2 - m;
        const pick = (axis) => {
          for (let n = up(el); n; n = up(n)) {
            if (n.nodeType !== 1 || n === document.body) continue;
            const doc = n === document.documentElement || n === document.scrollingElement;
            if (!canScroll(n, axis)) continue;
            const t = doc ? (document.scrollingElement || document.documentElement) : n;
            let sb = scrollBox(t);
            if (!doc) { const k = clipOf(t), x1 = Math.max(sb.x, k.x1), y1 = Math.max(sb.y, k.y1), x2 = Math.min(sb.x + sb.w, k.x2), y2 = Math.min(sb.y + sb.h, k.y2); sb = { x: x1, y: y1, w: x2 - x1, h: y2 - y1 }; }
            if (sb.w <= 1 || sb.h <= 1) continue;
            const dir = axis === 'x' ? (cx > sb.x + sb.w / 2 ? 1 : -1) : (cy > sb.y + sb.h / 2 ? 1 : -1);
            const pos = axis === 'x' ? t.scrollLeft : t.scrollTop, max = axis === 'x' ? t.scrollWidth - t.clientWidth : t.scrollHeight - t.clientHeight;
            if (dir > 0 ? pos >= max - 1 : pos <= 0) continue;
            return { t, sb, dir, pos };
          }
          return null;
        };
        const order = outY ? ['y', 'x'] : outX ? ['x', 'y'] : ['y'];
        for (const axis of order) {
          if (axis === 'x' && !outX) continue;
          const p = pick(axis); if (!p) continue;
          window.__teamPlanS = p.t;
          return { axis, dir: p.dir, box: p.sb, at: pointFor(p.t, p.sb, axis), pos: p.pos };
        }
        window.__teamPlanS = null;
        return { none: true, axis: outY ? 'y' : 'x', why: 'nenhum rolador na tela com para onde ir' };
      }
      const s = mainScroller(); const sb = scrollBox(s); window.__teamPlanS = s;
      return { axis: 'y', dir: args.dir || 1, box: sb, at: pointFor(s, sb, 'y'), pos: s.scrollTop, atEnd: s.scrollTop + s.clientHeight >= s.scrollHeight - 2, atTop: s.scrollTop <= 0 };
    }
    case 'scroll-pos': {
      const ps = window.__teamPlanS;
      const el = args.id ? find(args.id) : null; const s = ps && ps.isConnected ? ps : el ? scroller(el, args.axis) : mainScroller();
      return args.axis === 'x' ? s.scrollLeft : s.scrollTop;
    }
    case 'eval': { try { return { ok: true, value: !!(0, eval)(args.expr) }; } catch (e) { return { ok: false, error: String(e && e.message || e) }; } }
    default: throw new Error(`dom-probe: operação desconhecida ${op}`);
  }
}

module.exports = { probe, probeSource: probe.toString() };
