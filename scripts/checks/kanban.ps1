# Kanban em Markdown do sprint e do bloco de fix (v3.51.2 — pedido do stakeholder, 22/10/2026; substitui o kanban-html.ps1).
# Sprint: regrava em sprints/<n>/kanban.md a tabela "## Kanban" (do quadro) e a seção "## Rodadas" (do usage.jsonl).
# Bloco (-Block B-<nnn>): regrava fixes/B-<nnn>/kanban.md inteiro — Kanban das F-IDs com as colunas do sprint, Registro de
# transições e Rodadas, derivados do plan.md, do verdict.md e do usage.jsonl. -Init cria a pasta e o consumption.md do bloco.
# Rodadas: uma linha por rodada de subagente (quando, item, papel, modelo, tokens, tempo), a mais nova primeiro, e o total
# por papel e modelo. Custo = tokens processados e tempo; o consolidado continua no consumption.md.
# Bloco: -Fid F-n -To plan|build|qa marca a F-ID na ENTRADA da fase (antes de acionar o papel) e regrava na hora; as rodadas
# depois só confirmam o estado e somam custo.
# Chamado pelo hook G16 ao fim de cada rodada, pelo mark.ps1 e pelo close.ps1 -Apply. É script: não custa token.
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/kanban.ps1" [-Block B-<nnn> [-Init] [-Fid F-<n> -To plan|build|qa]] [-Root <projeto>]
# Saída: uma linha. Exit 0 · 2 = erro de uso ou de leitura. Nunca falha quem o chamou.

param([string]$Block = '', [switch]$Init, [string]$Fid = '', [string]$To = '', [string]$Root = (Get-Location).Path)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)
$pt = [System.Globalization.CultureInfo]::GetCultureInfo('pt-BR')
$short = @{ 'scrum-master' = 'sm'; 'product-owner' = 'po'; 'architect' = 'arc'; 'user-experience' = 'ux'; 'quality-assurance' = 'qa'; 'developer' = 'dev'; 'operator' = 'operator' }
$todo = [char]::ConvertFromUtf32(0x2B1C); $red = [char]::ConvertFromUtf32(0x1F534)
$cols = @(@{ mk = $todo; t = 'A fazer' }, @{ mk = $E.Plan; t = 'Plano' }, @{ mk = $E.Build; t = 'Construção' }, @{ mk = $E.QA; t = 'Verificação' }, @{ mk = $E.Done; t = 'Fechada' }, @{ mk = $red; t = 'Bloqueada' })

# Modelo servido com a versão, como no consumption.ps1: "claude-haiku-4-5-20251001" → "haiku 4.5".
function Get-ShortModel([string]$Model) {
    $out = @()
    foreach ($m in ($Model -split ',')) {
        $mm = [regex]::Match($m, '(?i)(opus|sonnet|haiku|fable|mythos)-(\d+)(?:-(\d{1,2}))?(?!\d)')
        if ($mm.Success) { $out += ($mm.Groups[1].Value.ToLowerInvariant() + ' ' + $mm.Groups[2].Value + $(if ($mm.Groups[3].Success) { '.' + $mm.Groups[3].Value } else { '' })); continue }
        if ($m) { $out += $m }
    }
    if ($out.Count) { return ($out | Select-Object -Unique) -join '+' }
    return 'n/d'
}
function Format-Duration([int]$Seconds) { return ('{0:00}:{1:00}' -f [Math]::Floor($Seconds / 60), ($Seconds % 60)) }
function Format-Tokens([double]$N) { return $N.ToString('N0', $pt) }
function Get-Role($Row) { $r = [string]$Row.role; if ($short.ContainsKey($r)) { $short[$r] } else { $r } }

# Rodadas medidas pela G16 cujo destino é o registro dado, em ordem de início.
function Get-Rounds([string]$Tp, [string]$Dest) {
    $up = Join-Path $Tp 'usage.jsonl'
    if (-not (Test-Path -LiteralPath $up)) { return @() }
    $rows = @()
    foreach ($line in [System.IO.File]::ReadAllLines($up, $utf8)) {
        if ($line.IndexOf($Dest) -lt 0) { continue }
        try { $o = $line | ConvertFrom-Json } catch { continue }
        if ([string]$o.dest -eq $Dest) { $rows += $o }
    }
    return @($rows | Sort-Object { [string]$_.start })
}

# Marcador de cada Task ao longo do tempo, pelo Registro de transições do kanban.md: Task → lista ordenada de (quando, para).
function Get-MarkHistory([string]$Text) {
    $h = @{}
    $sec = Get-Section $Text '^##\s+Registro de transi'
    if (-not $sec) { return $h }
    foreach ($t in (Get-Tables $sec)) {
        foreach ($row in $t.Rows) {
            $id = ([regex]::Match((Get-Cell $row 0), '[A-Z]+-\d+[a-z]?')).Value; if (-not $id) { continue }
            $to = ((Get-Cell $row 1) -split '→')[-1].Trim()
            $ds = ([regex]::Match((Get-Cell $row 2), '\d{4}-\d{2}-\d{2}( \d{2}:\d{2})?')).Value
            $when = $null; try { $when = [datetime]::ParseExact($ds, [string[]]@('yyyy-MM-dd HH:mm', 'yyyy-MM-dd'), $null, 'None') } catch { }
            if (-not $when) { continue }
            if (-not $h.ContainsKey($id)) { $h[$id] = @() }
            $h[$id] += [pscustomobject]@{ At = $when; To = $to }
        }
    }
    foreach ($k in @($h.Keys)) { $h[$k] = @($h[$k] | Sort-Object At) }
    return $h
}

# v3.51.4 (garden itens 8 e 9; note.md item 13): uma parcela por Task citada na rodada (works; rateio igual do custo e do
# tempo) e a fase pelo MARCADOR da Task no início da rodada (⬜/🟦 → Plano e preparo · 🟨 → Construção · 🟪/✅ → Verificação);
# sem Registro para a Task, vale o papel (arc → Plano · dev → Construção · qa/operator → Verificação). A pausa medida pela
# G16 (paused_s, lacuna acima de 20 min) já está fora da duração e aparece numa coluna própria.
function Split-Rounds($Rows, $History) {
    $out = @()
    $byRole = @{ arc = 'Plano'; dev = 'Construção'; qa = 'Verificação'; operator = 'Verificação' }
    foreach ($r in $Rows) {
        $ws = @(@($r.works) | Where-Object { $_ }); if (-not $ws.Count) { $ws = @([string]$r.work) }
        $k = [Math]::Max(1, $ws.Count)
        $start = $null; try { $start = [datetime][string]$r.start } catch { }
        $role = Get-Role $r
        foreach ($w in $ws) {
            $phase = $null
            if ($role -in 'po', 'sm', 'ux') { $phase = 'Outros' }
            elseif ($start -and $History.ContainsKey($w)) {
                $mk = $null; foreach ($ev in $History[$w]) { if ($ev.At -le $start) { $mk = $ev.To } }   # $e seria o $E dos marcadores
                if ($mk) { $phase = if ($mk.Contains($E.Build)) { 'Construção' } elseif ($mk.Contains($E.QA) -or $mk.Contains($E.Done)) { 'Verificação' } else { 'Plano' } }
            }
            if (-not $phase) { $phase = if ($byRole.ContainsKey($role)) { $byRole[$role] } else { 'Outros' } }
            $out += [pscustomobject]@{ work = $w; phase = $phase; processed = [double]$r.processed / $k; duration_s = [double]$r.duration_s / $k; paused_s = [double]$r.paused_s / $k }
        }
    }
    return $out
}

function Format-Rounds($Rows, [string]$Nl, $History = @{}) {
    $o = @('## Rodadas', '*(Regravado pelo `kanban.ps1` ao fim de cada rodada de agente — não editar à mão. Custo = tokens processados e tempo; o consolidado fica no `consumption.md`.)*', '')
    if (-not $Rows.Count) { return (($o + 'Nenhuma rodada medida ainda.' + '') -join $Nl) + $Nl }
    # Por tarefa e fase: Plano e preparo · Construção · Verificação · Outros (PO, SM, UX); a última linha é o consolidado.
    # Rodada que cita várias Tasks (plano por História) entra rateada em cada uma; sem Task própria, na linha do item citado.
    $names = 'Plano', 'Construção', 'Verificação', 'Outros'
    $parts = @(Split-Rounds $Rows $History)
    $cell = { param($rs) if (-not @($rs).Count) { '—' } else { "$(Format-Tokens ((@($rs) | Measure-Object processed -Sum).Sum)) · $(Format-Duration ([int]((@($rs) | Measure-Object duration_s -Sum).Sum)))" } }
    $pause = { param($rs) $s = [int]((@($rs) | Measure-Object paused_s -Sum).Sum); if ($s -gt 0) { Format-Duration $s } else { '—' } }
    $o += '### Por tarefa e fase *(tokens · tempo; pausa = lacuna de limite de conta ou máquina parada, fora do tempo)*'; $o += ''
    $o += '| Item | ' + ($names -join ' | ') + ' | Total | Pausa |'; $o += '|---|---|---|---|---|---|---|'
    foreach ($g in @($parts | Group-Object { [string]$_.work } | Sort-Object Name)) {
        $o += "| $($g.Name) | " + (($names | ForEach-Object { $n = $_; & $cell @($g.Group | Where-Object { $_.phase -eq $n }) }) -join ' | ') + " | $(& $cell $g.Group) | $(& $pause $g.Group) |"
    }
    $o += '| **Consolidado** | ' + (($names | ForEach-Object { $n = $_; & $cell @($parts | Where-Object { $_.phase -eq $n }) }) -join ' | ') + " | **$(& $cell $Rows)** | $(& $pause $parts) |"
    $o += ''; $o += '### Por papel e modelo'; $o += ''
    $o += '| Papel | Modelo | Rodadas | Tokens | Tempo |'; $o += '|---|---|---|---|---|'
    $groups = @($Rows | Group-Object { (Get-Role $_) + '|' + (Get-ShortModel ([string]$_.model)) } | ForEach-Object {
        [pscustomobject]@{ k = $_.Name; n = $_.Count; t = ($_.Group | Measure-Object processed -Sum).Sum; s = ($_.Group | Measure-Object duration_s -Sum).Sum } } | Sort-Object t -Descending)
    foreach ($g in $groups) { $rm = $g.k -split '\|', 2; $o += "| $($rm[0]) | $($rm[1]) | $($g.n) | $(Format-Tokens $g.t) | $(Format-Duration ([int]$g.s)) |" }
    $o += "| **Total** | — | **$($Rows.Count)** | **$(Format-Tokens (($Rows | Measure-Object processed -Sum).Sum))** | **$(Format-Duration ([int](($Rows | Measure-Object duration_s -Sum).Sum)))** |"
    $o += ''; $o += '### Rodada a rodada *(a mais nova primeiro)*'; $o += ''
    $o += '| Quando | Item | Papel | Modelo | Tokens | Tempo |'; $o += '|---|---|---|---|---|---|'
    for ($i = $Rows.Count - 1; $i -ge 0; $i--) {
        $r = $Rows[$i]; $when = try { ([datetime]$r.start).ToString('yyyy-MM-dd HH:mm') } catch { [string]$r.start }
        $o += "| $when | $([string]$r.work) | $(Get-Role $r) | $(Get-ShortModel ([string]$r.model)) | $(Format-Tokens ([double]$r.processed)) | $(Format-Duration ([int]$r.duration_s)) |"
    }
    return (($o + '') -join $Nl) + $Nl
}

# Espera de comando por Task (v3.51.4, note.md item 12): o tempo que o verify.ps1 passou rodando comandos do projeto
# (build, teste, lint, mutação), somado de verify/<n>/<T-ID>/time.jsonl — quanto do relógio da Task foi espera, não raciocínio.
function Format-CommandWait([string]$Tp, [string]$N, [string]$Nl) {
    $vd = Join-Path $Tp "verify/$N"
    $rows = @()
    foreach ($d in @(Get-ChildItem -LiteralPath $vd -Directory -ErrorAction SilentlyContinue | Sort-Object Name)) {
        $tf = Join-Path $d.FullName 'time.jsonl'; if (-not (Test-Path -LiteralPath $tf)) { continue }
        $by = @{}; $calls = 0
        foreach ($l in [System.IO.File]::ReadAllLines($tf, $utf8)) { try { $o = $l | ConvertFrom-Json; $by[[string]$o.mode] = [int]$by[[string]$o.mode] + [int]$o.seconds; $calls++ } catch { } }
        if (-not $calls) { continue }
        $tot = ($by.Values | Measure-Object -Sum).Sum
        $rows += "| $($d.Name) | $calls | " + ((@('focused', 'full', 'mutation') | ForEach-Object { if ($by.ContainsKey($_)) { Format-Duration $by[$_] } else { '—' } }) -join ' | ') + " | **$(Format-Duration $tot)** |"
    }
    if (-not $rows.Count) { return '' }
    return ((@('### Espera de comando *(verify.ps1: tempo rodando build, teste, lint e mutação)*', '', '| Task | Chamadas | focused | full | mutation | Total |', '|---|---|---|---|---|---|') + $rows + '') -join $Nl) + $Nl
}

# Troca a seção "## <título>" (até o próximo "## ") ou a insere antes da seção indicada; sem ela, no fim.
function Set-Section([string]$Text, [string]$Heading, [string]$New, [string]$Before) {
    $sec = [regex]::Match($Text, '(?ms)^##\s+' + $Heading + '\s*\r?\n.*?(?=^##\s|\z)')
    if ($sec.Success) { return $Text.Substring(0, $sec.Index) + $New + $Text.Substring($sec.Index + $sec.Length) }
    $at = [regex]::Match($Text, '(?m)^##\s+' + $Before)
    if ($at.Success) { return $Text.Substring(0, $at.Index) + $New + $Text.Substring($at.Index) }
    return $Text.TrimEnd() + "`n`n" + $New
}

function Format-Board($Items, [string]$Nl) {
    $rows = [Math]::Max(1, (@($cols | ForEach-Object { $c = $_; @($Items | Where-Object { $_.Mark -eq $c.mk }).Count } | Measure-Object -Maximum).Maximum))
    $tbl = @(('| ' + (($cols | ForEach-Object { "$($_.mk) $($_.t)" }) -join ' | ') + ' |'), ('|' + ('---|' * $cols.Count)))
    for ($r = 0; $r -lt $rows; $r++) { $tbl += '| ' + (($cols | ForEach-Object { $c = $_; $l = @($Items | Where-Object { $_.Mark -eq $c.mk }); if ($r -lt $l.Count) { $l[$r].Label } else { '' } }) -join ' | ') + ' |' }
    return $tbl -join $Nl
}

try {
    $tp = Join-Path $Root '.team-project'
    if (-not (Test-Path -LiteralPath $tp)) { [Console]::Error.WriteLine("kanban: $tp não existe — rode na raiz do projeto ou passe -Root."); exit 2 }

    if (-not $Block) {
        # ---------- sprint ----------
        $readme = Join-Path $tp 'README.md'
        $m = if (Test-Path -LiteralPath $readme) { [regex]::Match((Read-Text $readme), $script:SprintLineRe) } else { $null }
        if (-not $m -or -not $m.Success) { [Console]::Error.WriteLine('kanban: README §2 sem "Sprint corrente" — esperado: ' + $script:SprintLineHelp); exit 2 }
        $n = $m.Groups[1].Value; $S = Join-Path $tp "sprints/$n"
        # v3.51.4 (garden item 1): -Init cria o consumption.md do sprint se faltar (G16 e run.ps1 next o chamam no sprint run).
        $consS = Join-Path $S 'consumption.md'
        if ($Init -and (Test-Path -LiteralPath $S) -and -not (Test-Path -LiteralPath $consS) -and -not (Test-Path -LiteralPath (Join-Path $S 'retrospective.md'))) {
            $c = "# Consumo — Sprint $n`n`n> **DOCUMENTO VIVO durante o sprint** → **fechado** no ``/sm sprint close`` · **Dono:** SM`n> Criado pelo ``kanban.ps1 -Init`` no sprint run (a Planning não o criou). Uma linha por rodada de papel, gravada pela G16 e pelo ``consumption.ps1``. Modelo: ``templates/consumption.md``.`n`n## Registro`n| Data | Papel | Modelo | Comando | Task/História | Categoria | Unidade | Tokens | Duração | Nota |`n|---|---|---|---|---|---|---|---|---|---|`n`n## Totais do sprint (derivado)`n| Papel | Modelo | Σ tokens processados | Instâncias | Rodadas | Duração total | Σ notificação |`n|---|---|---|---|---|---|---|`n"
            [System.IO.File]::WriteAllText($consS, $c, $utf8)
            [Console]::Out.WriteLine("kanban: sprints/$n/consumption.md criado")
        }
        $kb = Join-Path $S 'kanban.md'
        if (-not (Test-Path -LiteralPath $kb)) { [Console]::Out.WriteLine("kanban: sprints/$n/kanban.md não existe (sprint anterior à v3.51) — nada a regravar."); exit 0 }
        if (Test-Path -LiteralPath (Join-Path $S 'retrospective.md')) { [Console]::Out.WriteLine("kanban: sprint $n fechado — o kanban.md não muda mais."); exit 0 }
        $tasks = @(); if (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md')) { $tasks = @(Get-SprintTasks $S | ForEach-Object { [pscustomobject]@{ Mark = $_.Mark; Label = $_.Id } }) }
        $rounds = @(Get-Rounds $tp ".team-project/sprints/$n/consumption.md")
        # v3.51.4: ler, mudar e regravar sob a trava do kanban.md — a G16 e o mark.ps1 escrevem nele ao mesmo tempo (garden item 23).
        $null = Invoke-WithFileLock $kb {
            $text = Read-Text $kb; $nl = if ($text.Contains("`r`n")) { "`r`n" } else { "`n" }
            if ($text -match '(?m)^##\s+Kanban\s*$') {
                $text = Set-Section $text 'Kanban' ("## Kanban$nl*(Regravado pelo ``kanban.ps1`` a cada transição e ao fim de cada rodada — não editar à mão.)*$nl$nl" + (Format-Board $tasks $nl) + "$nl$nl") 'Linha de base'
            }
            $text = Set-Section $text 'Rodadas' ((Format-Rounds $rounds $nl (Get-MarkHistory $text)) + (Format-CommandWait $tp $n $nl)) 'Linha de base'
            [System.IO.File]::WriteAllText($kb, $text, $utf8)
        }
        [Console]::Out.WriteLine("kanban: sprints/$n/kanban.md · $($tasks.Count) Task(s) · $($rounds.Count) rodada(s)")
        exit 0
    }

    # ---------- bloco de fix ----------
    $B = $Block.Trim().ToUpperInvariant()
    if ($B -notmatch '^B-\d+$') { [Console]::Error.WriteLine("kanban: -Block '$Block' inválido — use B-<nnn>."); exit 2 }
    $bdir = Join-Path $tp "fixes/$B"
    if (-not (Test-Path -LiteralPath $bdir)) {
        if (-not $Init) { [Console]::Error.WriteLine("kanban: fixes/$B não existe — o fix plan cria o bloco com -Init."); exit 2 }
        New-Item -ItemType Directory -Force $bdir | Out-Null
    }
    $kb = Join-Path $bdir 'kanban.md'
    if ((Test-Path -LiteralPath $kb) -and ((Read-Text $kb) -match '(?m)^\*\*Fechado em:\*\*')) { [Console]::Out.WriteLine("kanban: bloco $B fechado — o kanban.md não muda mais."); exit 0 }
    $made = @()
    $cons = Join-Path $bdir 'consumption.md'
    if ($Init -and -not (Test-Path -LiteralPath $cons)) {
        $c = "# Consumo — Bloco $B`n`n> **DOCUMENTO VIVO até o fechamento do bloco** · **Dono:** SM`n> Uma linha por rodada de papel do bloco (``fix plan`` a partir da montagem, ``fix run`` até o fechamento), gravada pela G16 e pelo ``consumption.ps1``. Modelo: ``templates/consumption.md``, variante ""bloco"".`n`n## Registro`n| Data | Papel | Modelo | Comando | Task/História | Categoria | Unidade | Tokens | Duração | Nota |`n|---|---|---|---|---|---|---|---|---|---|`n`n## Totais do bloco (derivado)`n| Papel | Modelo | Σ tokens processados | Instâncias | Rodadas | Duração total | Σ notificação |`n|---|---|---|---|---|---|---|`n"
        [System.IO.File]::WriteAllText($cons, $c, $utf8); $made += 'consumption.md'
    }

    # F-IDs e títulos do plan.md; promoção pendente pelo "**Critério que caiu:**" na seção da F-ID.
    $fids = [ordered]@{}; $fell = @{}
    $planPath = Join-Path $bdir 'plan.md'
    if (Test-Path -LiteralPath $planPath) {
        foreach ($sec in [regex]::Matches((Read-Text $planPath), '(?ms)^##\s+(F-\d+)\b[^\r\n]*\r?\n(.*?)(?=^##\s|\z)')) {
            $id = $sec.Groups[1].Value; $fids[$id] = $todo
            if ($sec.Groups[2].Value -match '(?m)^\*\*Crit[ée]rio que caiu:\*\*\s*\S') { $fell[$id] = $true }
        }
    }
    # Estado final do ## Fechamento do verdict.md.
    $final = @{}; $closedAt = ''
    $vPath = Join-Path $bdir 'verdict.md'
    if (Test-Path -LiteralPath $vPath) {
        $fsec = Get-Section (Read-Text $vPath) '^##\s+Fechamento'
        if ($fsec) {
            $cm = [regex]::Match($fsec, '\*\*Fechado em:\*\*\s*(\d{4}-\d{2}-\d{2})'); if ($cm.Success) { $closedAt = $cm.Groups[1].Value }
            $t = (Get-Tables $fsec)[0]
            if ($t) { foreach ($row in $t.Rows) { $id = Clean-Cell (Get-Cell $row 0); $st = (Clean-Cell (Get-Cell $row 1)).ToLowerInvariant(); if ($id -match '^F-\d+$' -and $st -match '^(fechada|promovida|devolvida)') { $final[$id] = $Matches[1] } } }
        }
    }

    # Estado pelas rodadas: dev → Construção; Arquiteto numa F-ID → Plano (GAP ou revalidação); QA → Verificação
    # (QA do bloco inteiro move as F-IDs que já passaram pelo dev).
    $rounds = @(Get-Rounds $tp ".team-project/fixes/$B/consumption.md")
    $reg = @()
    # Marca na entrada da fase (-Fid F-n -To plan|build|qa): fica em fixes/B-n/.marks, "F-n|fase|aaaa-mm-ddTHH:mm:ss".
    $marksPath = Join-Path $bdir '.marks'
    $phaseTo = @{ plan = $E.Plan; build = $E.Build; qa = $E.QA }
    if ($Fid -or $To) {
        $F = $Fid.Trim().ToUpperInvariant(); $T = $To.Trim().ToLowerInvariant()
        if ($F -notmatch '^F-\d+$' -or -not $phaseTo.ContainsKey($T)) { [Console]::Error.WriteLine("kanban: use -Fid F-<n> -To plan|build|qa."); exit 2 }
        if (-not $fids.Contains($F)) { [Console]::Error.WriteLine("kanban: $F não está no plan.md de $B."); exit 2 }
        [System.IO.File]::AppendAllText($marksPath, "$F|$T|$((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss'))`n", $utf8)
    }
    # Eventos em ordem de tempo: marcas (entrada da fase) e rodadas (confirmam o estado e somam custo).
    $events = @()
    foreach ($r in $rounds) { $events += [pscustomobject]@{ t = [string]$r.start; r = $r; f = $null; to = $null } }
    if (Test-Path -LiteralPath $marksPath) {
        foreach ($ml in [System.IO.File]::ReadAllLines($marksPath, $utf8)) {
            $p = $ml -split '\|'
            if ($p.Count -ge 3 -and $phaseTo.ContainsKey($p[1])) { $events += [pscustomobject]@{ t = $p[2]; r = $null; f = $p[0]; to = $phaseTo[$p[1]] } }
        }
    }
    foreach ($ev in @($events | Sort-Object t)) {
        if ($ev.r) {
            $r = $ev.r; $role = Get-Role $r; $work = [string]$r.work
            $to = switch ($role) { 'dev' { $E.Build } 'arc' { $E.Plan } 'qa' { $E.QA } default { $null } }
            if (-not $to) { continue }
            $targets = @()
            if ($fids.Contains($work)) { $targets = @($work) }
            elseif ($work -eq $B -and $role -eq 'qa') { $targets = @($fids.Keys | Where-Object { $fids[$_] -in $E.Build, $E.Plan }) }
            $by = $role
        } else { $to = $ev.to; $targets = @($ev.f | Where-Object { $fids.Contains($_) }); $by = 'marca na entrada da fase' }
        $when = try { ([datetime]$ev.t).ToString('yyyy-MM-dd HH:mm') } catch { [string]$ev.t }
        foreach ($f in $targets) { if ($fids[$f] -ne $to) { $reg += "| $f | $($fids[$f]) → $to | $when | $by |"; $fids[$f] = $to } }
    }
    $items = @()
    foreach ($f in @($fids.Keys)) {
        $mk = $fids[$f]; $label = $f
        if ($final.ContainsKey($f)) {
            $label = if ($final[$f] -eq 'fechada') { $f } else { "$f ($($final[$f]))" }
            $reg += "| $f | $mk → $($E.Done) | $(if ($closedAt) { $closedAt } else { 'fechamento' }) | sessão — $($final[$f]) |"; $mk = $E.Done
        } elseif ($fell.ContainsKey($f)) { $label = "$f (promoção)"; if ($mk -ne $red) { $reg += "| $f | $mk → $red | — | promoção: Critério que caiu no plan.md |" }; $mk = $red }
        $items += [pscustomobject]@{ Mark = $mk; Label = $label }
    }

    $nl = "`n"
    $doc = @("# Kanban — Bloco $B", '',
        "> Regravado inteiro pelo ``kanban.ps1`` na entrada de cada fase (``-Fid``/``-To``), ao fim de cada rodada de agente e no fechamento do bloco — não editar à mão. Colunas iguais às do sprint; $($E.Done) Fechada = saiu do bloco (fechada, promovida ou devolvida — o Registro diz qual).", '',
        '## Kanban', '', (Format-Board $items $nl), '',
        '## Registro de transições', '', '| F-ID | De → Para | Quando | Por quem |', '|---|---|---|---|') + $reg + @('', (Format-Rounds $rounds $nl).TrimEnd())
    if ($closedAt) { $doc += @('', "**Fechado em:** $closedAt") }
    [System.IO.File]::WriteAllText($kb, (($doc -join $nl) + $nl), $utf8)
    $made += 'kanban.md'
    [Console]::Out.WriteLine("kanban: fixes/$B/ · $($made -join ' e ') · $($fids.Count) F-ID(s) · $($rounds.Count) rodada(s)$(if ($closedAt) { ' · fechado' })")
    exit 0
} catch {
    [Console]::Error.WriteLine("kanban: erro — $($_.Exception.Message)")
    exit 2
}
