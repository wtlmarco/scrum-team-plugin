# Kanban visual do sprint (v3.51, G1 e G2 — pedido do stakeholder): regrava sprints/<n>/kanban.html e a tabela "## Kanban"
# do kanban.md a partir do quadro (sprint-backlog.md), da Série e do controle (kanban.md ou burndown.md) e do consumo
# (usage.jsonl). Página que se atualiza sozinha no navegador (a cada 30 s): colunas do Kanban, gráfico do burndown,
# bloqueios e decisões pendentes, consumo por papel. É script — não custa token. Chamado pelo mark.ps1 e pelo close.ps1 -Apply;
# avulso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/kanban-html.ps1" [-Root <projeto>]
# Saída: uma linha. Exit 0 · 2 = erro de uso. Nunca falha a transição que o chamou.

param([string]$Root = (Get-Location).Path, [switch]$NoMarkdown)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)
function Enc([string]$s) { [System.Net.WebUtility]::HtmlEncode($s) }   # "H" seria Get-History: no PowerShell o alias vence a função

try {
    $tp = Join-Path $Root '.team-project'
    $readme = Join-Path $tp 'README.md'
    if (-not (Test-Path -LiteralPath $readme)) { [Console]::Error.WriteLine('kanban: .team-project/README.md não existe.'); exit 2 }
    $m = [regex]::Match((Read-Text $readme), '(?m)^\|\s*\*\*Sprint corrente\*\*\s*\|\s*\*\*(\d+)\*\*(.*)$')
    if (-not $m.Success) { [Console]::Error.WriteLine('kanban: README §2 sem "Sprint corrente".'); exit 2 }
    $n = $m.Groups[1].Value; $S = Join-Path $tp "sprints/$n"
    if (-not (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md'))) { [Console]::Error.WriteLine("kanban: sprints/$n/sprint-backlog.md não existe."); exit 2 }
    $tasks = @(Get-SprintTasks $S)
    $chart = Get-ChartPath $S; $chartText = if (Test-Path -LiteralPath $chart) { Read-Text $chart } else { '' }
    $board = Read-Text (Join-Path $S 'sprint-backlog.md')

    $todo = [char]::ConvertFromUtf32(0x2B1C); $red = [char]::ConvertFromUtf32(0x1F534)
    $cols = @(@{ mk = $todo; t = 'A fazer' }, @{ mk = $E.Plan; t = 'Plano' }, @{ mk = $E.Build; t = 'Construção' }, @{ mk = $E.QA; t = 'Verificação' }, @{ mk = $E.Done; t = 'Fechada' }, @{ mk = $red; t = 'Bloqueada' })

    # ---------- tabela "## Kanban" do kanban.md ----------
    if (-not $NoMarkdown -and (Split-Path $chart -Leaf) -eq 'kanban.md' -and $chartText -match '(?m)^##\s+Kanban\s*$') {
        $rows = [Math]::Max(1, (@($cols | ForEach-Object { $c = $_; @($tasks | Where-Object { $_.Mark -eq $c.mk }).Count } | Measure-Object -Maximum).Maximum))
        $tbl = @(('| ' + (($cols | ForEach-Object { "$($_.mk) $($_.t)" }) -join ' | ') + ' |'), ('|' + ('---|' * $cols.Count)))
        for ($r = 0; $r -lt $rows; $r++) { $tbl += '| ' + (($cols | ForEach-Object { $c = $_; $l = @($tasks | Where-Object { $_.Mark -eq $c.mk }); if ($r -lt $l.Count) { $l[$r].Id } else { '' } }) -join ' | ') + ' |' }
        $nl = if ($chartText.Contains("`r`n")) { "`r`n" } else { "`n" }
        $sec = [regex]::Match($chartText, '(?ms)^##\s+Kanban\s*\r?\n.*?(?=^##\s)')
        if ($sec.Success) {
            $new = "## Kanban$nl*(Regravado pelo ``kanban-html.ps1`` a cada transição — não editar à mão. Visual: ``kanban.html``.)*$nl$nl" + ($tbl -join $nl) + "$nl$nl"
            [System.IO.File]::WriteAllText($chart, $chartText.Substring(0, $sec.Index) + $new + $chartText.Substring($sec.Index + $sec.Length), $utf8)
        }
    }

    # ---------- burndown: a Série ----------
    $pts = @()
    $serie = Get-Section $chartText '^##\s+S[ée]rie'
    if ($serie) {
        $t = (Get-Tables $serie)[0]
        if ($t) {
            $di = Find-Col $t 'Data'; $ei = Find-Col $t 'Est. restante'; $vi = Find-Col $t 'Evento'
            foreach ($row in $t.Rows) { $v = [regex]::Match((Get-Cell $row $ei), '\d+([.,]\d+)?'); if ($v.Success) { $pts += [pscustomobject]@{ when = (Clean-Cell (Get-Cell $row $di)); est = [double]($v.Value -replace ',', '.'); ev = (Clean-Cell (Get-Cell $row $vi)) } } }
        }
    }
    $svg = '<p class="muted">Sem Série ainda.</p>'
    if ($pts.Count) {
        $w = 640; $h = 200; $max = [Math]::Max(1, ($pts | Measure-Object est -Maximum).Maximum); $k = [Math]::Max(1, $pts.Count - 1)
        $poly = (@(for ($i = 0; $i -lt $pts.Count; $i++) { "{0},{1}" -f [int](30 + ($w - 50) * $i / $k), [int](10 + ($h - 40) * (1 - $pts[$i].est / $max)) }) -join ' ')
        $ideal = "30,10 $($w - 20),$($h - 30)"
        $svg = "<svg viewBox='0 0 $w $h' role='img' aria-label='Burndown'><polyline points='$ideal' class='ideal'/><polyline points='$poly' class='real'/><text x='4' y='16'>$max</text><text x='4' y='$($h - 30)'>0</text><text x='30' y='$($h - 8)'>$(Enc $pts[0].when)</text><text x='$($w - 160)' y='$($h - 8)'>$(Enc $pts[-1].when)</text></svg><p class='muted'>Restante agora: <b>$($pts[-1].est)</b> · último evento: $(Enc $pts[-1].ev)</p>"
    }

    # ---------- controle e consumo ----------
    function Section-Html([string]$Title, [string]$Regex) {
        $s = Get-ControlSection $S $board $Regex; if (-not $s) { return '' }
        $tb = (Get-Tables $s)[0]; if (-not $tb -or -not $tb.Rows.Count) { return "<h3>$(Enc $Title)</h3><p class='muted'>nenhum</p>" }
        $o = "<h3>$(Enc $Title)</h3><table><tr>" + (($tb.Header | ForEach-Object { "<th>$(Enc $_)</th>" }) -join '') + '</tr>'
        foreach ($r in $tb.Rows) { $o += '<tr>' + (($r | ForEach-Object { "<td>$(Enc (Clean-Cell $_))</td>" }) -join '') + '</tr>' }
        return $o + '</table>'
    }
    $ctrl = (Section-Html 'Bloqueios e riscos abertos' '^#{2,3}\s+Bloqueios e riscos') + (Section-Html 'Decisões pendentes do stakeholder' '^#{2,3}\s+Decis[õo]es pendentes') + (Section-Html 'Entradas fora da Planning' '^#{2,3}\s+Entradas fora da Planning')
    $use = @{}; $up = Join-Path $tp 'usage.jsonl'
    if (Test-Path -LiteralPath $up) { foreach ($line in [System.IO.File]::ReadAllLines($up, $utf8)) { try { $o = $line | ConvertFrom-Json; if ([string]$o.dest -like "*sprints/$n/*" -or [string]$o.dest_note -eq "sprint $n") { $k2 = [string]$o.role; if (-not $use[$k2]) { $use[$k2] = @{ r = 0; t = 0 } }; $use[$k2].r++; $use[$k2].t += [double]$o.processed } } catch { } } }
    $cons = if ($use.Count) { '<table><tr><th>Papel</th><th>Rodadas</th><th>Tokens processados</th></tr>' + (($use.GetEnumerator() | Sort-Object { $_.Value.t } -Descending | ForEach-Object { "<tr><td>$(Enc $_.Key)</td><td>$($_.Value.r)</td><td>$('{0:N0}' -f $_.Value.t)</td></tr>" }) -join '') + '</table>' } else { '<p class="muted">Sem consumo registrado neste sprint.</p>' }

    $colsHtml = ($cols | ForEach-Object { $c = $_; $l = @($tasks | Where-Object { $_.Mark -eq $c.mk })
        "<section class='col'><h3>$($c.mk) $(Enc $c.t) <span class='n'>$($l.Count)</span></h3>" + (($l | ForEach-Object { "<div class='card'><b>$(Enc $_.Id)</b> $(Enc $_.Title)<div class='muted'>$(Enc $_.Story)$(if ($_.Deps.Count) { ' · depende de ' + (Enc ($_.Deps -join ', ')) })</div></div>" }) -join '') + '</section>' }) -join ''
    $title = "Kanban · Sprint $n"
    $html = @"
<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta http-equiv="refresh" content="30"><title>$title</title>
<style>
:root{--bg:#f7f7f5;--fg:#1d1d1b;--muted:#6b6b66;--card:#fff;--line:#e2e2dc;--accent:#2f6fde;--ideal:#b9b9b3}
@media (prefers-color-scheme:dark){:root{--bg:#161615;--fg:#ececea;--muted:#9a9a94;--card:#21211f;--line:#34342f;--accent:#7aa7ff;--ideal:#55554f}}
body{background:var(--bg);color:var(--fg);font:14px/1.45 system-ui,-apple-system,Segoe UI,sans-serif;margin:0;padding:16px}
h1{font-size:20px;margin:0 0 4px}h2{font-size:16px;margin:24px 0 8px}h3{font-size:14px;margin:12px 0 6px}
.muted{color:var(--muted);font-size:12px}.board{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:10px}
.col{background:transparent;border:1px solid var(--line);border-radius:8px;padding:8px;min-height:80px}.n{color:var(--muted);font-weight:400}
.card{background:var(--card);border:1px solid var(--line);border-radius:6px;padding:6px 8px;margin:6px 0}
svg{width:100%;max-width:680px;height:auto}polyline{fill:none;stroke-width:2}.real{stroke:var(--accent)}.ideal{stroke:var(--ideal);stroke-dasharray:4 4}svg text{fill:var(--muted);font-size:11px}
table{border-collapse:collapse;width:100%;max-width:100%;display:block;overflow-x:auto}td,th{border:1px solid var(--line);padding:4px 6px;text-align:left;vertical-align:top;font-size:13px}
</style></head><body>
<h1>$title</h1><p class="muted">Atualizado em $(Get-Date -Format 'yyyy-MM-dd HH:mm') · regravado a cada transição (kanban-html.ps1) · a página recarrega a cada 30 s</p>
<h2>Kanban</h2><div class="board">$colsHtml</div>
<h2>Burndown</h2>$svg
<h2>Controle</h2>$ctrl
<h2>Consumo por papel</h2>$cons
</body></html>
"@
    [System.IO.File]::WriteAllText((Join-Path $S 'kanban.html'), $html, $utf8)
    [Console]::Out.WriteLine("kanban: sprints/$n/kanban.html · $($tasks.Count) Task(s) · $($pts.Count) ponto(s) na Série")
    exit 0
} catch {
    [Console]::Error.WriteLine("kanban: erro — $($_.Exception.Message)")
    exit 2
}
