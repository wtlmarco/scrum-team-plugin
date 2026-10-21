# Marcador da Task no sprint run (v3.49): a transição numa chamada só. Troca o marcador no quadro e acrescenta a linha no
# Registro de transições e a da Série no burndown, com a estimativa inalterada (sprint-run.md §Marcador). Antes eram três
# edições da sessão principal, cada uma relendo ~400 mil tokens de contexto. O ✅ é do close.ps1 -Apply, que confere o
# fechamento e baixa a estimativa.
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/mark.ps1" -Task T-041 -To build [-By <quem>] [-Root <projeto>]
#   -To: todo (⬜) · plan (🟦) · build (🟨) · qa (🟪) · blocked (🔴), ou o próprio emoji.
#   -By: a coluna "Por quem" do Registro (padrão: o papel que assume — plan e build → dev, qa → QA, todo e blocked → SM).
# Saída: uma linha. Exit 0 · 2 = erro de uso ou de leitura (nada é gravado).
param(
    [Parameter(Mandatory = $true)][string]$Task,
    [Parameter(Mandatory = $true)][string]$To,
    [string]$By = '',
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')

function Get-TableEnd($Lines, [string]$Heading) {
    $h = -1; for ($i = 0; $i -lt $Lines.Count; $i++) { if ($Lines[$i] -match $Heading) { $h = $i; break } }
    if ($h -lt 0) { return -1 }
    $s = -1; for ($i = $h + 1; $i -lt $Lines.Count; $i++) { if ($Lines[$i].TrimStart().StartsWith('|')) { $s = $i; break }; if ($Lines[$i] -match '^#') { break } }
    if ($s -lt 0) { return -1 }
    $e = $s; while ($e + 1 -lt $Lines.Count -and $Lines[$e + 1].TrimStart().StartsWith('|')) { $e++ }
    return $e
}
function ConvertTo-Lines([string]$Text) { $l = New-Object System.Collections.ArrayList; foreach ($x in ($Text -split "`r?`n")) { [void]$l.Add($x) }; return , $l }

try {
    $todo = [char]::ConvertFromUtf32(0x2B1C); $red = [char]::ConvertFromUtf32(0x1F534)
    $marks = @($todo, $E.Plan, $E.Build, $E.QA, $red)
    $byName = @{ todo = $todo; plan = $E.Plan; build = $E.Build; qa = $E.QA; blocked = $red }
    $t = $To.Trim()
    if ($t -eq $E.Done -or $t -ieq 'done') { [Console]::Error.WriteLine('mark: o ✅ é do close.ps1 -Apply (confere o fechamento e baixa a estimativa).'); exit 2 }
    $target = if ($byName.ContainsKey($t.ToLowerInvariant())) { $byName[$t.ToLowerInvariant()] } elseif ($marks -contains $t) { $t } else { $null }
    if (-not $target) { [Console]::Error.WriteLine("mark: -To '$To' desconhecido — use todo, plan, build, qa ou blocked."); exit 2 }
    if (-not $By) { $By = if ($target -in $E.Plan, $E.Build) { 'dev' } elseif ($target -eq $E.QA) { 'QA' } else { 'SM' } }

    $tp = Join-Path $Root '.team-project'
    $readmePath = Join-Path $tp 'README.md'
    if (-not (Test-Path -LiteralPath $readmePath)) { [Console]::Error.WriteLine("mark: $readmePath não existe — rode na raiz do projeto ou passe -Root."); exit 2 }
    $m = [regex]::Match((Read-Text $readmePath), '(?m)^\|\s*\*\*Sprint corrente\*\*\s*\|\s*\*\*(\d+)\*\*')
    if (-not $m.Success) { [Console]::Error.WriteLine('mark: .team-project/README.md §2 sem a linha "Sprint corrente".'); exit 2 }
    $S = Join-Path $tp "sprints/$($m.Groups[1].Value)"
    $boardPath = Join-Path $S 'sprint-backlog.md'; $bdPath = Get-ChartPath $S   # kanban.md (v3.51) ou burndown.md
    foreach ($p in $boardPath, $bdPath) { if (-not (Test-Path -LiteralPath $p)) { [Console]::Error.WriteLine("mark: $p não existe."); exit 2 } }
    $idPat = Get-IdPattern $Task
    $now = Get-Date -Format 'yyyy-MM-dd HH:mm'

    # 1 · marcador no quadro (só a 1ª célula da linha da Task)
    $board = Read-Text $boardPath; $nl = if ($board.Contains("`r`n")) { "`r`n" } else { "`n" }
    $bl = ConvertTo-Lines $board
    $row = -1; $from = $null
    for ($i = 0; $i -lt $bl.Count; $i++) {
        if (-not $bl[$i].TrimStart().StartsWith('|')) { continue }
        $c0 = (Split-Row $bl[$i])[0]
        if ($c0 -notmatch $idPat) { continue }
        if ($c0.Contains($E.Done)) { [Console]::Error.WriteLine("mark: $Task já está ✅ — Task fechada não volta pelo marcador (retomada é Task nova, R25)."); exit 2 }
        foreach ($mk in $marks) { if ($c0.Contains($mk)) { $from = $mk; break } }
        if ($from) { $row = $i; break }
    }
    if ($row -lt 0) { [Console]::Error.WriteLine("mark: $Task sem linha com marcador no quadro ($boardPath)."); exit 2 }
    if ($from -eq $target) { [Console]::Error.WriteLine("mark: $Task já está $target."); exit 2 }
    $ix = $bl[$row].IndexOf($from)
    $bl[$row] = $bl[$row].Substring(0, $ix) + $target + $bl[$row].Substring($ix + $from.Length)

    # 2 · Série do burndown: a composição recontada, a estimativa e as Tasks restantes como estavam (R24 — só o ✅ baixa)
    $bdText = Read-Text $bdPath; $bnl = if ($bdText.Contains("`r`n")) { "`r`n" } else { "`n" }
    $lines = ConvertTo-Lines $bdText
    $se = Get-TableEnd $lines '^##\s+S[ée]rie'
    if ($se -lt 0) { [Console]::Error.WriteLine('mark: burndown sem tabela na "## Série".'); exit 2 }
    $sTable = (Get-Tables (Get-Section $bdText '^##\s+S[ée]rie'))[0]
    $last = Split-Row $lines[$se]; $first = if ($sTable.Rows.Count) { $sTable.Rows[0] } else { $last }
    $d0 = Get-FirstDate (Get-Cell $first (Find-Col $sTable 'Data'))
    $day = if ($d0) { [int]((Get-Date).Date - $d0).TotalDays } else { Clean-Cell (Get-Cell $last 0) }
    $cells = @("$day", $now, "$Task $from → $target", (Clean-Cell (Get-Cell $last (Find-Col $sTable 'Est. restante'))), (Clean-Cell (Get-Cell $last (Find-Col $sTable 'Tasks restantes'))))
    foreach ($mk in @($todo, $E.Plan, $E.Build, $E.QA, $E.Done, $red)) {
        $ci = Find-Col $sTable $mk
        if ($ci -lt 0) { continue }
        $v = 0; $vm = [regex]::Match((Get-Cell $last $ci), '\d+'); if ($vm.Success) { $v = [int]$vm.Value }
        if ($mk -eq $from) { $v = [Math]::Max(0, $v - 1) } elseif ($mk -eq $target) { $v++ }
        $cells += "$v"
    }
    $lines.Insert($se + 1, '| ' + ($cells -join ' | ') + ' |')

    # 3 · Registro de transições: no burndown; quadro anterior à v3.44.1 o tem no sprint-backlog.md
    $regRow = "| $Task | $from → $target | $now | $By · sessão (``mark.ps1``) |"
    $where = Split-Path $bdPath -Leaf
    $re = Get-TableEnd $lines '^##\s+Registro de transi'
    if ($re -ge 0) { $lines.Insert($re + 1, $regRow) }
    else {
        $rb = Get-TableEnd $bl '^##\s+Registro de transi'
        if ($rb -lt 0) { [Console]::Error.WriteLine('mark: nem o burndown nem o Sprint Backlog têm tabela no "## Registro de transições".'); exit 2 }
        $bl.Insert($rb + 1, $regRow); $where = 'sprint-backlog.md (quadro anterior à v3.44.1)'
    }

    # Tudo calculado: só agora grava, para não deixar o quadro trocado sem a linha no burndown.
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($boardPath, ($bl -join $nl), $utf8)
    [System.IO.File]::WriteAllText($bdPath, ($lines -join $bnl), $utf8)
    [Console]::Out.WriteLine("mark: $Task $from → $target · quadro, Série e Registro gravados (Registro em $where; por quem: $By)")
    try { $null = & (Join-Path $PSScriptRoot 'kanban-html.ps1') -Root $Root 2>&1 } catch { }   # v3.51 (G2): o Kanban visual acompanha a transição
    exit 0
} catch {
    [Console]::Error.WriteLine("mark: erro — $($_.Exception.Message)")
    exit 2
}
