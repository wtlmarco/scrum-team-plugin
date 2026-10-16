#!/usr/bin/env node
// Medição de custo pelos transcripts do Claude Code (v3.49). Ferramenta do mantenedor do plugin e do benchmark:
// lê a pasta de um projeto em ~/.claude*/projects/<projeto>/ — sessões principais (*.jsonl) e subagentes
// (<sessão>/subagents/agent-*.jsonl + .meta.json) — e mede o que o usage.jsonl (G16) não vê: a sessão principal,
// o custo em US$ pelo modelo servido, as quebras de cache e o que enche o contexto.
//
// Uso:  node scripts/metrics/transcript-metrics.js <comando> <pasta do projeto> [--since <ISO>] [--json <arquivo>]
//   cost     volume × custo por quem (sessão/papel) e modelo; custo sem cache; maiores instâncias
//   breaks   quebras de cache (leu < 90 % do contexto anterior) e o que estava pendente na pausa
//   growth   de onde vem o crescimento do contexto (estimado); --session mede a sessão principal
//   session  chamadas da sessão principal por tipo de trabalho
//   waits    tempo da sessão parada à espera do stakeholder × à espera de agente
// Requisito: Node.js 18+. Só lê; não grava nada fora do --json.
'use strict';
const fs = require('fs'), path = require('path');

// US$ por milhão de tokens: [entrada, leitura de cache, saída] — preço de API (lista de 2026-10-06). Escrita de cache:
// 1,25× a entrada (TTL 5 min) ou 2× (TTL 1 h), pelo campo usage.cache_creation de cada chamada. Leitura de cache do
// Haiku 5.5 suposta em 0,1× da entrada. Modelo fora da tabela: a chamada conta no volume e fica fora do custo.
const PRICES = {
  'claude-fable-5-1': [10, 0.25, 50], 'claude-fable-5': [10, 1.0, 50],
  'claude-opus-5-5': [4, 0.20, 20], 'claude-opus-5': [5, 0.50, 25], 'claude-opus-4-8': [5, 0.50, 25],
  'claude-sonnet-5-5': [2, 0.20, 10], 'claude-sonnet-5': [2, 0.20, 10], 'claude-sonnet-4-6': [3, 0.30, 15],
  'claude-haiku-5-5': [0.10, 0.01, 0.50], 'claude-haiku-4-5': [1, 0.10, 5], 'claude-haiku-4-5-20251001': [1, 0.10, 5],
};
const M = 1e6;

// ---------- argumentos ----------
const argv = process.argv.slice(2);
const cmd = argv[0], root = argv[1];
const opt = (k) => { const i = argv.indexOf(k); return i > 0 ? argv[i + 1] : undefined; };
const SINCE = opt('--since') ? Date.parse(opt('--since')) : 0;
const JSON_OUT = opt('--json');
if (!cmd || !root || !fs.existsSync(root)) {
  console.error('uso: node transcript-metrics.js <cost|breaks|growth|session|waits> <pasta do projeto> [--since <ISO>] [--json <arquivo>] [--session]');
  process.exit(2);
}

// ---------- leitura ----------
// Evento repetido (mesmo uuid) é cópia: o harness regrava linhas antigas antes de uma compactação, com o timestamp original —
// sem descartar, uma resposta de dias atrás parece uma pausa longa (medido no piloto: uma "parada de 68 h" que não existiu).
const readJsonl = (fp) => {
  const seen = new Set();
  return fs.readFileSync(fp, 'utf8').split('\n').filter(Boolean).map(l => { try { return JSON.parse(l); } catch { return null; } })
    .filter(o => { if (!o) return false; if (o.uuid) { if (seen.has(o.uuid)) return false; seen.add(o.uuid); } return true; });
};
function transcripts() {
  const out = [];
  for (const e of fs.readdirSync(root, { withFileTypes: true })) {
    const p = path.join(root, e.name);
    if (e.isFile() && e.name.endsWith('.jsonl')) out.push({ fp: p, kind: 'sessão', role: 'sessão' });
    if (e.isDirectory() && fs.existsSync(path.join(p, 'subagents'))) {
      for (const f of fs.readdirSync(path.join(p, 'subagents')).filter(f => /^agent-.*\.jsonl$/.test(f))) {
        const fp = path.join(p, 'subagents', f);
        let role = 'subagente';
        try { role = (JSON.parse(fs.readFileSync(fp.replace(/\.jsonl$/, '.meta.json'), 'utf8')).agentType || role).replace(/^team:/, ''); } catch { /* sem meta */ }
        out.push({ fp, kind: 'subagente', role });
      }
    }
  }
  return out;
}
// Chamadas ao modelo: uma por message.id (as linhas do mesmo id são blocos da mesma resposta; vale o último usage).
function calls(events) {
  const list = [], byId = new Map();
  events.forEach((o, idx) => {
    const m = o.message;
    if (o.type !== 'assistant' || !m || !m.usage || m.model === '<synthetic>') return;
    let c = byId.get(m.id);
    if (!c) { c = { id: m.id, idx, ts: Date.parse(o.timestamp), model: m.model, tools: [] }; byId.set(m.id, c); list.push(c); }
    c.u = m.usage; c.last = idx;
    for (const b of m.content || []) if (b.type === 'tool_use') c.tools.push(b);
  });
  for (const c of list) c.ctx = (c.u.input_tokens || 0) + (c.u.cache_creation_input_tokens || 0) + (c.u.cache_read_input_tokens || 0);
  return list;
}
function usd(c) {
  const p = PRICES[c.model]; if (!p) return null;
  const u = c.u, cc = u.cache_creation || {};
  const w5 = cc.ephemeral_5m_input_tokens, w1 = cc.ephemeral_1h_input_tokens;
  const w = u.cache_creation_input_tokens || 0;
  const write = (w5 != null || w1 != null) ? ((w5 || 0) * 1.25 + (w1 || 0) * 2) : w * 1.25;
  return ((u.input_tokens || 0) * p[0] + write * p[0] + (u.cache_read_input_tokens || 0) * p[1] + (u.output_tokens || 0) * p[2]) / M;
}
const ttlMin = (c) => ((c.u.cache_creation || {}).ephemeral_1h_input_tokens > 0 ? 60 : 5);
const inWindow = (c) => !SINCE || c.ts >= SINCE;
const pct = (a, b) => (b ? (100 * a / b).toFixed(0) : '0').padStart(3) + ' %';
const money = (x) => 'US$ ' + x.toFixed(1).padStart(7);
const out = {};
// Raiz do projeto = o cwd mais frequente da sessão principal (o cwd de um subagente muda com Set-Location).
let projectRoot = null;
function findProjectRoot() {
  const count = {};
  for (const t of transcripts().filter(t => t.kind === 'sessão'))
    for (const o of readJsonl(t.fp)) if (o.cwd) { const k = String(o.cwd).replace(/\\/g, '/').toLowerCase().replace(/\/?$/, '/'); count[k] = (count[k] || 0) + 1; }
  projectRoot = Object.entries(count).sort((a, b) => b[1] - a[1]).map(e => e[0])[0] || '';
}
const relPath = (p) => { const s = String(p || '').replace(/\\/g, '/'); return projectRoot && s.toLowerCase().startsWith(projectRoot) ? s.slice(projectRoot.length) : s; };
const pendingCause = (t) => !t ? 'fim de turno' : t.name === 'SubagentHandback' ? 'devolveu e foi retomado depois'
  : t.name === 'Agent' ? 'esperando subagente' : t.name === 'AskUserQuestion' ? 'esperando o stakeholder (formulário)'
  : (t.name === 'PowerShell' || t.name === 'Bash') ? 'comando longo' : 'ferramenta: ' + t.name;

// ---------- cost ----------
function cmdCost() {
  const by = {}, inst = []; let tok = 0, cost = 0, nocache = 0;
  for (const t of transcripts()) {
    let it = 0, iu = 0, n = 0, model = '';
    for (const c of calls(readJsonl(t.fp)).filter(inWindow)) {
      const k = `${t.role} · ${c.model.replace(/^claude-/, '')}`;
      const b = by[k] = by[k] || { calls: 0, tok: 0, usd: 0 };
      const x = usd(c) || 0, p = PRICES[c.model];
      b.calls++; b.tok += c.ctx; b.usd += x; tok += c.ctx; cost += x; it += c.ctx; iu += x; n++; model = c.model;
      if (p) nocache += (c.ctx * p[0] + (c.u.output_tokens || 0) * p[2]) / M;
    }
    if (t.kind === 'subagente' && n) inst.push({ file: path.basename(t.fp), role: t.role, model, calls: n, tok: it, usd: iu });
  }
  console.log(`Total: ${(tok / M).toFixed(0)} M tokens · ${money(cost).trim()} · sem cache seria ${money(nocache).trim()}\n`);
  console.log('quem · modelo                              chamadas    volume   % vol      custo  % custo');
  for (const [k, b] of Object.entries(by).sort((a, b) => b[1].usd - a[1].usd))
    console.log(`${k.padEnd(40)} ${String(b.calls).padStart(7)} ${(b.tok / M).toFixed(1).padStart(8)} M ${pct(b.tok, tok)}  ${money(b.usd)} ${pct(b.usd, cost)}`);
  console.log('\nMaiores instâncias de subagente (volume × custo):');
  for (const i of inst.sort((a, b) => b.tok - a.tok).slice(0, 8))
    console.log(`  ${i.role.padEnd(18)} ${i.model.replace(/^claude-/, '').padEnd(22)} ${String(i.calls).padStart(4)} cham · ${(i.tok / M).toFixed(1).padStart(5)} M (${pct(i.tok, tok).trim()} vol) · ${money(i.usd).trim()} (${pct(i.usd, cost).trim()} custo)`);
  Object.assign(out, { total_tokens: tok, total_usd: cost, nocache_usd: nocache, by, instances: inst });
}

// ---------- breaks ----------
function cmdBreaks() {
  const res = {}; let lost = 0, base = 0;
  for (const t of transcripts()) {
    const ev = readJsonl(t.fp), cs = calls(ev);
    for (let i = 0; i < cs.length; i++) {
      const c = cs[i]; if (!inWindow(c)) continue;
      base += usd(c) || 0;
      if (!i) continue;
      const p = cs[i - 1], rd = c.u.cache_read_input_tokens || 0;
      if (p.ctx < 20000 || rd >= p.ctx * 0.9) continue;
      const pr = PRICES[c.model]; if (!pr) continue;
      const gap = (c.ts - p.ts) / 60e3, ttl = ttlMin(p);
      const between = ev.slice(p.last + 1, c.idx);
      let cause;
      if (p.model !== c.model) cause = `troca de modelo (${p.model} → ${c.model})`;
      else if (between.some(o => o.isCompactSummary || (o.type === 'system' && /compact/.test(o.subtype || '')))) cause = 'compactação do contexto';
      else if (gap > ttl) cause = `cache expirou (pausa > ${ttl} min) · ${pendingCause(p.tools[p.tools.length - 1])}`;
      else cause = 'prefixo mudou sem pausa';
      const extra = (p.ctx - rd) * (pr[0] * (ttl === 60 ? 2 : 1.25) - pr[1]) / M;
      const k = `${t.kind} · ${t.role} | ${cause}`;
      const r = res[k] = res[k] || { n: 0, tok: 0, usd: 0, gaps: [] };
      r.n++; r.tok += p.ctx - rd; r.usd += extra; r.gaps.push(gap); lost += extra;
    }
  }
  console.log(`Quebras de cache: ${money(lost).trim()} a mais do que ler (${pct(lost, base).trim()} do custo de entrada e cache)\n`);
  for (const [k, r] of Object.entries(res).sort((a, b) => b[1].usd - a[1].usd)) {
    const g = r.gaps.sort((a, b) => a - b);
    console.log(`${String(r.n).padStart(4)}× · ${(r.tok / M).toFixed(1).padStart(5)} M regravados · ${money(r.usd)} · pausa mediana ${g[g.length >> 1].toFixed(0).padStart(4)} min · ${k}`);
  }
  Object.assign(out, { lost_usd: lost, base_usd: base, causes: res });
}

// ---------- growth ----------
function readCat(p) {
  const s = relPath(p).toLowerCase();
  if (/(^|\/)(plugins|scrum-team[^/]*)\//.test(s) || s.includes('/.claude') && s.includes('/plugins/')) return 'Read: processo do plugin';
  if (s.includes('.team-project/')) {
    if (/\/plan\/|\/plan\.md$/.test(s)) return 'Read: plano';
    if (/\/delivery\//.test(s) || /delivery\.md$/.test(s)) return 'Read: relatório de entrega';
    if (/\/operator\/|\/verify\/|\.log$/.test(s)) return 'Read: log/relatório de execução';
    return 'Read: outros arquivos de .team-project';
  }
  if (/(^|\/)docs\//.test(s)) return 'Read: docs/ (SDD, specs)';
  if (/(claude|readme)\.md$/.test(s)) return 'Read: README/CLAUDE.md';
  if (/\/temp\/|scratchpad/.test(s)) return 'Read: temporário/scratchpad';
  return 'Read: código-fonte e testes';
}
function cmdCat(c) {
  c = String(c || '').toLowerCase().replace(/\\/g, '/');
  if (c.includes('verify.ps1')) return 'Shell: verify.ps1';
  if (c.includes('scripts/checks')) return 'Shell: conferências do plugin';
  if (/\b(gradle|gradlew|npm|npx|dotnet|jest|vitest|pytest|mvn)\b/.test(c)) return 'Shell: build/teste direto';
  if (/^\s*git\b/.test(c)) return 'Shell: git';
  if (/get-content|select-string|\bcat\b|get-childitem|\bls\b/.test(c)) return 'Shell: leitura/listagem por shell';
  return 'Shell: outros comandos';
}
const size = (x) => x == null ? 0 : typeof x === 'string' ? x.length : Array.isArray(x)
  ? x.reduce((s, i) => s + (i && i.type === 'text' ? (i.text || '').length : i && i.type === 'image' ? 0 : i && 'content' in i ? size(i.content) : JSON.stringify(i).length), 0)
  : JSON.stringify(x).length;
function cmdGrowth() {
  const wantSession = argv.includes('--session');
  const agg = {}, files = {}; let totalP = 0, totalBase = 0, totalG = 0, nAgents = 0;
  findProjectRoot();
  for (const t of transcripts().filter(t => wantSession ? t.kind === 'sessão' : t.kind === 'subagente')) {
    const ev = readJsonl(t.fp);
    const cs = calls(ev).filter(inWindow); if (!cs.length) continue;
    nAgents++;
    const order = new Map(cs.map((c, i) => [c.idx, i + 1]));   // índice do evento → nº da chamada
    const pieces = [], tools = {};
    let pos = 0;
    ev.forEach((o, idx) => {
      if (order.has(idx)) pos = order.get(idx);
      if (o.type === 'assistant' && o.message) {
        for (const b of o.message.content || []) {
          if (b.type === 'text') pieces.push([pos, (b.text || '').length, 'Agente: texto']);
          else if (b.type === 'thinking') pieces.push([pos, (b.thinking || '').length, 'Agente: raciocínio']);
          else if (b.type === 'tool_use') { tools[b.id] = b; pieces.push([pos, size(b.input), 'Chamada: ' + (['Edit', 'Write', 'Agent', 'SendMessage'].includes(b.name) ? b.name : 'outras')]); }
        }
      } else if (o.type === 'user' && o.message) {
        const c = o.message.content;
        if (typeof c === 'string') {
          const cat = pos === 0 ? 'Prompt inicial' : c.includes('<task-notification>') ? 'Mensagens: notificação de agente'
            : /<command-(name|message)>/.test(c) ? 'Mensagens: comando digitado' : o.isMeta ? 'Mensagens: retorno de agente e lembretes' : 'Mensagens: texto do usuário / SendMessage';
          pieces.push([pos, c.length, cat]); return;
        }
        for (const b of c || []) {
          if (b.type !== 'tool_result') continue;
          const tu = tools[b.tool_use_id] || {}, inp = tu.input || {};
          let cat = 'Resultado: ' + (tu.name || '?'), key = null;
          if (tu.name === 'Read') { cat = readCat(inp.file_path); key = relPath(inp.file_path); }
          else if (tu.name === 'PowerShell' || tu.name === 'Bash') cat = cmdCat(inp.command);
          else if (tu.name === 'Grep' || tu.name === 'Glob') cat = 'Busca (Grep/Glob)';
          else if (tu.name === 'Agent' || tu.name === 'SendMessage') cat = 'Resposta de subagente';
          pieces.push([pos, size(b.content), cat, key]);
        }
      } else if (o.type === 'attachment' && o.rendered) pieces.push([pos, size(o.rendered), 'Anexos do harness: ' + ((o.attachment || {}).type || '?')]);
    });
    const N = cs.length, first = cs[0].ctx;
    const growth = cs.reduce((a, c) => a + Math.max(0, c.ctx - first), 0);
    const grow = pieces.filter(p => p[0] >= 1);
    const carried = grow.reduce((a, p) => a + p[1] * Math.max(0, N - p[0]), 0);
    const r = carried ? growth / carried : 0;   // calibra caracteres × chamadas seguintes pelo usage real
    totalP += cs.reduce((a, c) => a + c.ctx, 0); totalBase += first * N;
    for (const [p, ch, cat, key] of grow) {
      const tk = ch * Math.max(0, N - p) * r; totalG += tk;
      const a = agg[cat] = agg[cat] || { n: 0, tok: 0 }; a.n++; a.tok += tk;
      if (key) { const f = files[key] = files[key] || { n: 0, tok: 0, ch: 0 }; f.n++; f.tok += tk; f.ch += ch; }
    }
  }
  console.log(`${wantSession ? 'Sessão principal' : 'Subagentes'}: ${nAgents} transcripts · ${(totalP / M).toFixed(0)} M processados · carga inicial ${pct(totalBase, totalP).trim()} · crescimento ${pct(totalG, totalP).trim()}`);
  console.log('(divisão por fonte ESTIMADA: tamanho do trecho × chamadas seguintes, calibrada pelo usage de cada chamada)\n');
  for (const [k, v] of Object.entries(agg).sort((a, b) => b[1].tok - a[1].tok)) if (v.tok / totalG >= 0.005)
    console.log(`  ${pct(v.tok, totalG)}  ${(v.tok / M).toFixed(1).padStart(6)} M  n=${String(v.n).padStart(5)}  ${k}`);
  console.log('\nArquivos lidos que mais pesam (tokens carregados · leituras · KB por leitura):');
  for (const [k, v] of Object.entries(files).sort((a, b) => b[1].tok - a[1].tok).slice(0, 12))
    console.log(`  ${(v.tok / M).toFixed(1).padStart(5)} M · ${String(v.n).padStart(4)}× · ${(v.ch / v.n / 1024).toFixed(1).padStart(5)} KB  ${k}`);
  Object.assign(out, { processed: totalP, base: totalBase, growth: totalG, sources: agg, files });
}

// ---------- session ----------
function sessionCat(t) {
  const i = t.input || {}, p = String(i.file_path || '').replace(/\\/g, '/').toLowerCase(), c = String(i.command || '').toLowerCase();
  if (t.name === 'Edit' || t.name === 'Write') {
    if (/sprint-backlog\.md$|burndown\.md$/.test(p)) return 'marcador (quadro/burndown)';
    if (/\.active-(task|run|executor|spike)$/.test(p)) return 'marcador .active-*';
    if (/consumption\.md$/.test(p)) return 'consumption.md à mão';
    return 'outra escrita';
  }
  if (t.name === 'PowerShell' || t.name === 'Bash') {
    if (c.includes('consumption.ps1')) return 'consumption.ps1';
    if (c.includes('models.ps1')) return 'models.ps1';
    if (/\.active-(task|run|executor|spike)/.test(c)) return 'marcador .active-*';
    if (/close\.ps1|plan\.ps1|fix\.ps1|verify\.ps1/.test(c)) return 'conferências (close/plan/fix/verify)';
    if (/sprint-backlog|burndown/.test(c)) return 'marcador (quadro/burndown)';
    return 'outro comando';
  }
  return t.name === 'Read' ? 'leitura' : 'ferramenta: ' + t.name;
}
function cmdSession() {
  const agg = {}; let n = 0, tok = 0;
  for (const t of transcripts().filter(t => t.kind === 'sessão')) {
    for (const c of calls(readJsonl(t.fp)).filter(inWindow)) {
      n++; tok += c.ctx;
      const cats = c.tools.length ? [...new Set(c.tools.map(sessionCat))] : ['texto, sem ferramenta (fim de turno)'];
      for (const k of cats) { const a = agg[k] = agg[k] || { n: 0, tok: 0 }; a.n++; a.tok += c.ctx / cats.length; }
    }
  }
  console.log(`Sessão principal: ${n} chamadas · ${(tok / M).toFixed(0)} M tokens · ${n ? (tok / n / 1e3).toFixed(0) : 0} mil por chamada\n`);
  for (const [k, a] of Object.entries(agg).sort((x, y) => y[1].tok - x[1].tok))
    console.log(`  ${String(a.n).padStart(5)} chamadas · ${(a.tok / M).toFixed(1).padStart(6)} M (${pct(a.tok, tok).trim()}) · ${k}`);
  Object.assign(out, { calls: n, tokens: tok, by: agg });
}

// ---------- waits ----------
function cmdWaits() {
  const w = { stakeholder: [], agente: [] }; let forms = 0;
  for (const t of transcripts().filter(t => t.kind === 'sessão')) {
    let lastTs = null, lastTool = null;
    for (const o of readJsonl(t.fp)) {
      const ts = Date.parse(o.timestamp); if (!ts) continue;
      if (o.type === 'assistant' && o.message) {
        for (const b of o.message.content || []) if (b.type === 'tool_use') { lastTool = b.name; if (b.name === 'AskUserQuestion' && ts >= SINCE) forms++; }
        lastTs = ts; continue;
      }
      if (o.type !== 'user' || o.isMeta || !lastTs || ts < SINCE) continue;
      const c = o.message && o.message.content;
      const text = typeof c === 'string' ? c : '';
      const gap = (ts - lastTs) / 60e3;
      if (text.includes('<task-notification>')) w.agente.push(gap);
      else if ((text && !text.startsWith('<system-reminder>') && !text.startsWith('<local-command'))
        || (Array.isArray(c) && lastTool === 'AskUserQuestion' && c.some(b => b.type === 'tool_result'))) w.stakeholder.push(gap);
    }
  }
  const h = (a) => (a.reduce((s, x) => s + x, 0) / 60).toFixed(1);
  const med = (a) => (a.sort((x, y) => x - y)[a.length >> 1] || 0).toFixed(0);
  console.log(`Formulários (AskUserQuestion): ${forms}`);
  console.log(`Sessão parada à espera do stakeholder: ${h(w.stakeholder)} h em ${w.stakeholder.length} esperas · mediana ${med(w.stakeholder)} min`);
  console.log(`Sessão parada à espera de agente:      ${h(w.agente)} h em ${w.agente.length} esperas · mediana ${med(w.agente)} min`);
  console.log('(sessões abertas ao mesmo tempo podem contar a mesma hora duas vezes)');
  Object.assign(out, { forms, waits_min: w });
}

const table = { cost: cmdCost, breaks: cmdBreaks, growth: cmdGrowth, session: cmdSession, waits: cmdWaits };
if (!table[cmd]) { console.error(`comando desconhecido: ${cmd}`); process.exit(2); }
table[cmd]();
if (JSON_OUT) fs.writeFileSync(JSON_OUT, JSON.stringify(out, null, 1));
