# Visão do sprint sem custo de token (v3.53.2, pedido do stakeholder em 2026-11-01): acompanhar o sprint pelo console ou
# pelo celular (Remote Control) sem acionar o modelo. Dois modos, texto curto para tela estreita (sem tabela):
#   -View status : onde cada Task está (do sprint-backlog.md), quem trabalha agora (.active-agents), run, limite de conta,
#                  estimativa restante (Série), última transição (Registro) e pendências do stakeholder (README §7).
#                  v3.53.5: "Em execução" — a Task do .active-task, há quanto tempo, o último sinal de vida, o comando que
#                  ela espera (CPU, arquivo, POSSÍVEL TRAVAMENTO) e PARADA quando nada roda há 20 min.
#   -View usage  : tokens e tempo das rodadas medidas pela G16 (usage.jsonl) do sprint, por Task (rateio igual entre as
#                  Tasks citadas, como no kanban.ps1) e por papel e modelo. Só agentes: a sessão principal entra no close.
#                  v3.53.6: sem US$ — a cota da assinatura (5h e semanal) lida do quota-log.jsonl da status line do plugin.
# Chamado pelo hook prompt-submit.ps1 quando o stakeholder digita /team-status ou /team-usage: o hook devolve este texto
# com decision=block, e o prompt não chega ao modelo. Também roda à mão. Só lê; nunca escreve em disco.
# v3.59.0 (pedido do stakeholder, 14/11/2026): -View status abre em palavras simples, para quem é de negócio — o resumo
#                  (andamento, o que está em andamento, o que parou e por quê, o que precisa dele, o que vem a seguir), quem do
#                  time trabalha agora e o quadro com o nome de cada parte. A visão técnica de antes sai com -Detail
#                  (/team-status detalhe). Corrigidos: a Task do .active-task já ✅ aparecia "em execução" e PARADA ao mesmo
#                  tempo que "Fechada"; "Esperando você" contava as pendências resolvidas do README §7 (131 no garden).
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/team-view.ps1" -View status|usage [-Detail] [-Sprint <n>] [-Root <projeto>]
# Saída: o texto da visão. Exit 0 · 2 = erro de uso ou de leitura (a mensagem diz o quê).

param([string]$View = 'status', [string]$Sprint = '', [switch]$Detail, [string]$Root = (Get-Location).Path)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
. (Join-Path $PSScriptRoot 'lib.ps1')
. (Join-Path $PSScriptRoot 'plain.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)
$pt = [System.Globalization.CultureInfo]::GetCultureInfo('pt-BR')
$short = @{ 'scrum-master' = 'sm'; 'product-owner' = 'po'; 'architect' = 'arc'; 'user-experience' = 'ux'; 'quality-assurance' = 'qa'; 'developer' = 'dev'; 'operator' = 'operator'; 'task-runner' = 'executor' }
$todo = [char]::ConvertFromUtf32(0x2B1C); $red = [char]::ConvertFromUtf32(0x1F534)

function Out-View([string[]]$Lines) { [Console]::Out.Write((($Lines | Where-Object { $null -ne $_ }) -join "`n") + "`n") }
function Get-Role([string]$R) { $r = $R -replace '^.*:', ''; if ($short.ContainsKey($r)) { $short[$r] } else { $r } }
function Get-ShortModel([string]$Model) {
    $out = @()
    foreach ($m in ($Model -split ',')) {
        $mm = [regex]::Match($m, '(?i)(opus|sonnet|haiku|fable|mythos)-(\d+)(?:-(\d{1,2}))?(?!\d)')
        if ($mm.Success) { $out += ($mm.Groups[1].Value.ToLowerInvariant() + ' ' + $mm.Groups[2].Value + $(if ($mm.Groups[3].Success) { '.' + $mm.Groups[3].Value } else { '' })) }
    }
    if ($out.Count) { return ($out | Select-Object -Unique) -join '+' }
    return '?'
}
# 1234567 → "1,23 mi"; 45600 → "46 mil"; 800 → "800".
function Format-Tok([double]$N) {
    if ($N -ge 1e6) { return ($N / 1e6).ToString('0.00', $pt) + ' mi' }
    if ($N -ge 1e3) { return ($N / 1e3).ToString('0', $pt) + ' mil' }
    return $N.ToString('0', $pt)
}
# v3.53.6 (decisão do stakeholder, item 10): cota da assinatura pelo registro da status line do plugin (quota-log.jsonl,
# global; TEAM_QUOTA_LOG troca o caminho no teste) — a cota agora e o quanto a semanal subiu desde $Since (a soma das subidas;
# quando o reinício da janela muda, a subida conta do zero). Linha única; sem registro, diz como ativar.
function Get-QuotaView([string]$Since) {
    $log = if ($env:TEAM_QUOTA_LOG) { $env:TEAM_QUOTA_LOG } else { Join-Path $env:USERPROFILE '.claude\quota-log.jsonl' }
    $snaps = @()
    foreach ($f in @(([System.IO.Path]::Combine((Split-Path $log), [System.IO.Path]::GetFileNameWithoutExtension($log) + '.1.jsonl')), $log)) {
        if (-not (Test-Path -LiteralPath $f)) { continue }
        foreach ($line in [System.IO.File]::ReadAllLines($f)) { if ($line.Trim()) { try { $snaps += ($line | ConvertFrom-Json) } catch { } } }
    }
    if (-not $snaps.Count) { return 'Cota: sem registro — ative a status line do plugin (how-to.md, Cota da assinatura).' }
    $snaps = @($snaps | Sort-Object { [string]$_.at })
    $now = $snaps[-1]
    $cur = @(); if ($null -ne $now.five) { $cur += "5h $([Math]::Round([double]$now.five))%" }; if ($null -ne $now.week) { $cur += "semana $([Math]::Round([double]$now.week))%" }
    $from = $null; try { $from = [datetime]$Since } catch { }
    $up = 0.0; $prev = $null
    foreach ($s in $snaps) {
        if ($null -eq $s.week) { continue }
        $at = $null; try { $at = [datetime]$s.at } catch { }
        if ($from -and $at -and $at -lt $from) { $prev = $s; continue }
        if ($prev -and $null -ne $prev.week) {
            if ([string]$prev.weekReset -eq [string]$s.weekReset -and [double]$s.week -ge [double]$prev.week) { $up += [double]$s.week - [double]$prev.week }
            elseif ([string]$prev.weekReset -ne [string]$s.weekReset) { $up += [double]$s.week }
        }
        $prev = $s
    }
    $when = try { ([datetime]$now.at).ToString('dd/MM HH:mm') } catch { [string]$now.at }
    return "Cota agora ($when): $($cur -join ' · ') · a semanal subiu $($up.ToString('0.0', $pt)) ponto(s) desde a 1ª rodada do sprint (agentes, sessão e uso fora do plugin juntos)"
}
# Segundos → "45 s", "12 min", "2h05".
function Format-Time([double]$S) {
    $s = [int]$S
    if ($s -lt 60) { return "$s s" }
    if ($s -lt 3600) { return "$([int][Math]::Floor($s / 60)) min" }
    return ('{0}h{1:00}' -f [int][Math]::Floor($s / 3600), [int][Math]::Floor(($s % 3600) / 60))
}
function Read-Json([string]$Path) { if (-not (Test-Path -LiteralPath $Path)) { return $null }; try { return (Read-Text $Path | ConvertFrom-Json) } catch { return $null } }

try {
    $v = $View.Trim().ToLowerInvariant()
    if ($v -notin 'status', 'usage') { [Console]::Error.WriteLine("team-view: -View '$View' inválido — use status ou usage."); exit 2 }
    $tp = Join-Path $Root '.team-project'
    if (-not (Test-Path -LiteralPath $tp)) { Out-View @('Este projeto não tem o time instalado (.team-project/ não existe). Rode na raiz do projeto.'); exit 0 }
    $readme = Join-Path $tp 'README.md'
    $readmeText = if (Test-Path -LiteralPath $readme) { Read-Text $readme } else { '' }
    $n = if ($Sprint) { $Sprint.Trim() } else { Get-CurrentSprint $readmeText }
    if (-not $n) { Out-View @('Nenhum sprint corrente no README §2 (linha "Sprint corrente"). Antes da Planning não há quadro.'); exit 0 }
    $S = Join-Path $tp "sprints/$n"
    if (-not (Test-Path -LiteralPath $S)) { Out-View @("Sprint $n declarado no README, mas sprints/$n/ não existe."); exit 0 }
    $closed = Test-Path -LiteralPath (Join-Path $S 'retrospective.md')
    $title = "Sprint $n" + $(if ($closed) { ' (fechado)' } else { '' })

    if ($v -eq 'status') {
        $tasks = @(); if (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md')) { $tasks = @(Get-SprintTasks $S) }
        $run = Read-Json (Join-Path $tp '.active-run')
        $agents = @()
        $ap = Join-Path $tp '.active-agents'
        if (Test-Path -LiteralPath $ap) { try { $agents = @((Read-Text $ap | ConvertFrom-Json) | ForEach-Object { $_ }) } catch { } }
        # A Task em execução (.active-task) e o sinal de vida dela — as duas visões usam. v3.59.0: Task do registro que já está
        # ✅ ou 🔴 no quadro não está "em execução" (o registro sobrava quando o executor não rodava o dispatch -Clear; desde a
        # v3.59.0 o run.ps1 done o apaga) — antes a mesma Task saía "em execução", PARADA e "Fechada" na mesma tela.
        $nowR = Get-Date
        $atP = Join-Path $tp '.active-task'; $atk = Read-Json $atP
        $ex = $null
        if ($atk -and $atk.id) {
            $id = [string]$atk.id
            $tk = @($tasks | Where-Object { $_.Id -eq $id }) | Select-Object -First 1
            $since = (Get-Item -LiteralPath $atP).LastWriteTime
            $ex = [pscustomobject]@{ Id = $id; Task = $tk; Since = $since; Over = ($tk -and ($tk.Mark -eq $E.Done -or $tk.Mark -eq $red)); Last = $null; Quiet = 0; Live = @(); Wait = $null; Stopped = $false }
            if (-not $ex.Over) {
                # Último sinal de vida: o mais recente entre o agente da Task, a pasta do verify, a do accept e o relatório.
                $sig = @(@{ t = $since; s = 'start' })
                foreach ($a in @($agents | Where-Object { [string]$_.work -eq $id })) {
                    $at = try { [datetime]::Parse([string]$(if ($a.at) { $a.at } else { $a.desde })) } catch { $null }
                    if ($at) { $sig += @{ t = $at; s = "$(Get-Role ([string]$a.type))" }; if (($nowR - $at).TotalMinutes -lt 20) { $ex.Live += $a } }
                }
                $vd = Get-VerifyDir $Root $id
                foreach ($d in @(@{ p = $vd; s = 'verify' }, @{ p = ($vd -replace '([\\/]\.team-project[\\/])verify([\\/])', '$1accept$2'); s = 'accept' })) {
                    if (Test-Path -LiteralPath $d.p) { $f = @(Get-ChildItem -LiteralPath $d.p -Recurse -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1); if ($f.Count) { $sig += @{ t = $f[0].LastWriteTime; s = $d.s } } }
                }
                $dv = Join-Path $S "delivery/$id.md"; if (Test-Path -LiteralPath $dv) { $sig += @{ t = (Get-Item -LiteralPath $dv).LastWriteTime; s = 'relatório' } }
                $ex.Last = @($sig | Sort-Object { $_.t } -Descending)[0]
                $ex.Quiet = ($nowR - $ex.Last.t).TotalMinutes
                $ex.Wait = Get-TaskWait $Root $id
                $ex.Stopped = (-not $ex.Live.Count -and -not $ex.Wait -and $ex.Quiet -ge 20)
            }
        }

        if (-not $Detail) {
            # ---------- visão para quem acompanha (v3.59.0) ----------
            $pn = Get-PlainNames $Root $n
            $sum = @(Get-PlainSummary $Root $n -Live)
            $o = @("Sprint $n — $(@($sum | Where-Object { $_.K -eq 'Andamento' })[0].V)", '')
            if ($agents.Count) {
                $o += 'Agora:'
                foreach ($a in $agents) {
                    $by = ''
                    if ($a.PSObject.Properties['parent'] -and [string]$a.parent) { $pa = @($agents | Where-Object { [string]$_.agent_id -eq [string]$a.parent } | Select-Object -First 1); if ($pa.Count) { $by = ' (chamado pelo ' + (Get-PlainRole ([string]$pa[0].type)) + ')' } }
                    $ds = try { ([datetime]::Parse([string]$a.desde)).ToString('HH:mm') } catch { '?' }
                    $o += "  - $(Get-PlainRole ([string]$a.type))$by — $(if ($a.work) { Get-PlainLabel $pn ([string]$a.work) } else { 'apoio ao time' }): $(Get-PlainAction ([string]$a.last)) (desde $ds)"
                }
            } else { $o += 'Agora: ninguém do time está trabalhando neste momento.' }
            if ($ex -and $ex.Stopped -and $run) { $o += "Atenção: nada roda para $(Get-PlainLabel $pn $ex.Id) há $(Format-Time ($ex.Quiet * 60)), com o sprint em andamento — para retomar, digite /sm sprint run." }
            foreach ($s in @($sum | Where-Object { $_.K -ne 'Andamento' })) { $o += "$($s.K): $($s.V)" }
            $o += ''; $o += 'Quadro:'
            $doneLog = @(Get-PlainDoneLog $S | ForEach-Object { $_.Id })
            foreach ($st in $script:PlainStages) {
                $l = @($tasks | Where-Object { $(if ($_.Mark) { $_.Mark } else { $todo }) -eq $st.Mark })
                if (-not $l.Count) { continue }
                if ($st.Mark -eq $E.Done -and $l.Count -gt 3) {
                    $rec = @($doneLog | Where-Object { @($l | ForEach-Object { $_.Id }) -contains $_ } | Select-Object -Unique | Select-Object -Last 3)
                    [array]::Reverse($rec)
                    $o += "  $($st.Mark) $($st.Plural) ($($l.Count)) — as mais recentes:"
                    foreach ($id in $(if ($rec.Count) { $rec } else { @($l | Select-Object -Last 3 | ForEach-Object { $_.Id }) })) { $o += "    · $(Get-PlainLabel $pn $id)" }
                    continue
                }
                $o += "  $($st.Mark) $($st.Plural) ($($l.Count))"
                foreach ($t in $l) { $o += "    · $(Get-PlainLabel $pn $t.Id)" }
            }
            if (-not $tasks.Count) { $o += '  nenhuma parte no quadro ainda.' }
            $o += ''; $o += 'Detalhe técnico (comandos, tempos, registro): /team-status detalhe'
            Out-View $o
            exit 0
        }

        # ---------- visão técnica (/team-status detalhe) ----------
        $o = @()
        $cols = @(@{ mk = $E.Build; t = 'Construção' }, @{ mk = $E.QA; t = 'Verificação' }, @{ mk = $E.Plan; t = 'Plano' }, @{ mk = $red; t = 'Bloqueada' }, @{ mk = $todo; t = 'A fazer' }, @{ mk = $E.Done; t = 'Fechada' })
        $count = { param($mk) @($tasks | Where-Object { $_.Mark -eq $mk }).Count }
        $o += "$title · $($tasks.Count) Tasks · $($E.Done) $(& $count $E.Done) · $($E.QA) $(& $count $E.QA) · $($E.Build) $(& $count $E.Build) · $($E.Plan) $(& $count $E.Plan) · $todo $(& $count $todo) · $red $(& $count $red)"

        # Estimativa restante: primeira e última linha da Série.
        $chart = Get-ChartPath $S; $chartText = if (Test-Path -LiteralPath $chart) { Read-Text $chart } else { '' }
        $serie = if ($chartText) { Get-Section $chartText '^##\s+S[ée]rie' } else { $null }
        if ($serie) {
            $t = @(Get-Tables $serie)[0]
            if ($t -and @($t.Rows).Count) {
                $first = Clean-Cell (Get-Cell @($t.Rows)[0] 3); $last = Clean-Cell (Get-Cell @($t.Rows)[-1] 3)
                if ($first -and $last) { $o += "Restante: $last de $first (estimativa)" }
            }
        }

        # Run, limite de conta e agentes em voo (lidos no início do status).
        if ($run) { $o += "Run: $([string]$run.trilha) $([string]$run.id) em andamento desde $([string]$run.desde)" }
        elseif (-not $closed) { $o += 'Run: parado' }
        $lim = Read-Json (Join-Path $tp '.usage-limit')
        if ($lim) { $o += "$($E.Warn) Limite de conta desde $([string]$lim.desde)" + $(if ($lim.reset) { " · volta: $([string]$lim.reset)" } else { '' }) }
        if (-not $agents.Count) { $o += 'Agora: nenhum agente em execução' }
        else {
            $o += "Agora ($($agents.Count)):"
            $now = Get-Date
            foreach ($a in $agents) {
                $at = try { [datetime]::Parse([string]$(if ($a.at) { $a.at } else { $a.desde })) } catch { $now }
                $mins = [int][Math]::Max(0, ($now - $at).TotalMinutes)
                $last = ([string]$a.last -replace '\s+', ' ').Trim(); if (-not $last) { $last = 'disparado' }
                if ($last.Length -gt 60) { $last = $last.Substring(0, 60) + '…' }
                $o += "  $(Get-Role ([string]$a.type)) · $(if ($a.work) { $a.work } else { '—' }) · há $mins min · $last"
            }
        }

        # v3.53.5 (pedido do stakeholder, sprint 5 do garden): a Task em execução, há quanto tempo, o último sinal de vida e o
        # comando que ela espera, com POSSÍVEL TRAVAMENTO ou PARADA — ver uma espera longa sem perguntar ao modelo.
        $o += ''
        if ($ex -and -not $ex.Over) {
            $ttl = if ($ex.Task -and $ex.Task.Title) { $x = ([string]$ex.Task.Title -replace '\*\*|`', '' -replace '\s+', ' ').Trim(); ' · ' + $(if ($x.Length -gt 50) { $x.Substring(0, 50) + '…' } else { $x }) } else { '' }
            $o += "Em execução: $($ex.Id)$ttl · há $(Format-Time ($nowR - $ex.Since).TotalSeconds) (start às $($ex.Since.ToString('dd/MM HH:mm')))"
            $o += "  último sinal de vida há $(Format-Time ($ex.Quiet * 60)) ($($ex.Last.s), $($ex.Last.t.ToString('HH:mm')))"
            if ($ex.Wait) { $o += "  comando: $($ex.Wait.Text)" }
            if ($ex.Stopped) {
                if ($run) { $o += "  $($E.Warn) PARADA: o run está em andamento, mas nenhum agente nem comando vivo para a $($ex.Id) há $(Format-Time ($ex.Quiet * 60)) — retome com /sm sprint run" }
                else { $o += "  run pausado: nada roda para a $($ex.Id); ela retoma com /sm sprint run" }
            }
        } else {
            $dl = @(Get-ChildItem -LiteralPath (Join-Path $S 'delivery') -Filter '*.md' -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
            $o += 'Em execução: nenhuma Task' + $(if ($ex) { " · a $($ex.Id) do registro já está $($ex.Task.Mark) no quadro (o registro ficou para trás)" } elseif ($dl.Count) { " · última trabalhada: $($dl[0].BaseName) (relatório há $(Format-Time ($nowR - $dl[0].LastWriteTime).TotalSeconds))" } else { '' })
        }

        # Quadro, em andamento primeiro; fechadas por último.
        $o += ''
        foreach ($c in $cols) {
            $ids = @($tasks | Where-Object { $_.Mark -eq $c.mk } | ForEach-Object { $_.Id })
            if ($ids.Count) { $o += "$($c.mk) $($c.t): $($ids -join ' ')" }
        }
        $semMarca = @($tasks | Where-Object { -not $_.Mark } | ForEach-Object { $_.Id })
        if ($semMarca.Count) { $o += "? sem marcador: $($semMarca -join ' ')" }
        if (-not $tasks.Count) { $o += 'Quadro sem Tasks (sprint-backlog.md ausente ou vazio).' }

        # Última transição do Registro.
        $reg = if ($chartText) { Get-Section $chartText '^##\s+Registro de transi' } else { $null }
        if ($reg) {
            $t = @(Get-Tables $reg)[0]
            if ($t -and @($t.Rows).Count) { $r = @($t.Rows)[-1]; $o += ''; $o += "Última transição: $(Clean-Cell (Get-Cell $r 0)) $(Clean-Cell (Get-Cell $r 1)) · $(Clean-Cell (Get-Cell $r 2))" }
        }

        # Pendências do stakeholder (README §7) que ainda esperam por ele — v3.59.0: sem as resolvidas, guardadas ou em andamento
        # (no garden, "131 decisões" com 98 resolvidas); as mais recentes primeiro.
        $items = @(Get-PlainPending $readmeText)
        if ($items.Count) {
            $o += ''; $o += "Esperando você: $($items.Count) decisão(ões) em README §7"
            foreach ($i in ($items | Select-Object -First 3)) { $x = "$($i.N). $($i.Raw)"; if ($x.Length -gt 90) { $x = $x.Substring(0, 90) + '…' }; $o += "  $x" }
        }
        Out-View $o
        exit 0
    }

    # ---------- usage ----------
    $dest = ".team-project/sprints/$n/consumption.md"
    $rows = @()
    $up = Join-Path $tp 'usage.jsonl'
    if (Test-Path -LiteralPath $up) {
        foreach ($line in [System.IO.File]::ReadAllLines($up, $utf8)) {
            if ($line.IndexOf($dest) -lt 0) { continue }
            try { $r = $line | ConvertFrom-Json } catch { continue }
            if ([string]$r.dest -eq $dest) { $rows += $r }
        }
    }
    if (-not $rows.Count) { Out-View @("Consumo · $title", 'Nenhuma rodada de agente medida ainda neste sprint.'); exit 0 }
    $rows = @($rows | Sort-Object { [string]$_.start })
    $sum = { param($rs, $f) [double](@($rs) | ForEach-Object { if ($null -ne $_.$f) { [double]$_.$f } else { 0 } } | Measure-Object -Sum).Sum }
    # v3.53.6 (decisão do stakeholder, item 10): sem US$ — a medida é a cota da assinatura (status line → quota-log.jsonl).
    $tok = & $sum $rows 'processed'; $dur = & $sum $rows 'duration_s'
    $o = @("Consumo · $title · $(Format-Tok $tok) tokens · $(Format-Time $dur) de agente · $($rows.Count) rodadas")
    $o += Get-QuotaView ([string]$rows[0].start)
    $o += 'Só agentes; a sessão principal é medida no fechamento da Task e na retrospectiva. Cota por rodada, Task e modelo: consumption.md (seção Cota da assinatura).'

    # Por Task: rateio igual entre as Tasks citadas na rodada (works), como no kanban.ps1.
    $parts = @()
    foreach ($r in $rows) {
        $ws = @(@($r.works) | Where-Object { $_ }); if (-not $ws.Count) { $ws = @([string]$r.work) }
        $k = [double][Math]::Max(1, $ws.Count)
        foreach ($w in $ws) { $parts += [pscustomobject]@{ work = $(if ($w) { $w } else { 'n/a' }); tok = [double]$r.processed / $k; dur = [double]$r.duration_s / $k } }
    }
    $o += ''; $o += 'Por Task (tokens · tempo):'
    foreach ($g in @($parts | Group-Object work | ForEach-Object { [pscustomobject]@{ w = $_.Name; tok = ($_.Group | Measure-Object tok -Sum).Sum; dur = ($_.Group | Measure-Object dur -Sum).Sum } } | Sort-Object tok -Descending)) {
        $o += "  $($g.w)  $(Format-Tok $g.tok) · $(Format-Time $g.dur)"
    }

    # Por papel (modelos entre parênteses), com a fatia dos tokens.
    $o += ''; $o += 'Por papel (tokens · % dos tokens · rodadas):'
    foreach ($g in @($rows | Group-Object { Get-Role ([string]$_.role) } | ForEach-Object {
        [pscustomobject]@{ r = $_.Name; m = ((@($_.Group | ForEach-Object { Get-ShortModel ([string]$_.model) }) | Select-Object -Unique) -join ', '); n = $_.Count; tok = (& $sum $_.Group 'processed') } } | Sort-Object tok -Descending)) {
        $pct = if ($tok -gt 0) { [Math]::Round(100 * $g.tok / $tok) } else { 0 }
        $o += "  $($g.r) ($($g.m))  $(Format-Tok $g.tok) · $pct% · $($g.n)"
    }

    $lr = $rows[-1]
    $when = try { ([datetime]$lr.start).ToString('dd/MM HH:mm') } catch { [string]$lr.start }
    $o += ''; $o += "Última rodada: $when · $(Get-Role ([string]$lr.role)) · $([string]$lr.work) · $(Format-Tok ([double]$lr.processed))"
    Out-View $o
    exit 0
} catch {
    [Console]::Error.WriteLine("team-view: erro — $($_.Exception.Message)")
    exit 2
}
