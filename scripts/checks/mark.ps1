# Marcador da Task no sprint run (v3.49): a transição numa chamada só. Troca o marcador no quadro e acrescenta a linha no
# Registro de transições e a da Série no burndown, com a estimativa inalterada (sprint-run.md §Marcador). Antes eram três
# edições da sessão principal, cada uma relendo ~400 mil tokens de contexto. O ✅ é do close.ps1 -Apply, que confere o
# fechamento e baixa a estimativa.
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/mark.ps1" -Task T-041 -To build [-By <quem>] [-Root <projeto>]
#   -To: todo (⬜) · plan (🟦) · build (🟨) · qa (🟪) · blocked (🔴), ou o próprio emoji.
#   -By: a coluna "Por quem" do Registro (padrão: o papel que assume — plan e build → dev, qa → QA, todo e blocked → SM);
#        v3.51.4 (garden item 15): vai também ao Evento da Série ("T-041 🟦 → 🟨 · dev"), para ler quem produziu o ponto.
#        v3.52.1: e a última rodada medida da Task (usage.jsonl): "T-041 🟦 → 🟨 · dev ← architect a1b2c3d4 14:05".
#   -Reason (v3.53.6, sprint 5 do garden, item 9; só com -To blocked): grava a linha em "Bloqueios e riscos abertos" (kanban.md,
#        ou o quadro antigo) com o motivo na Natureza e o degrau nomeado. "prova no alvo pendente — <motivo>" é a etiqueta que o
#        run.ps1 next lê para reabrir a Task quando o alvo voltar; ao sair de 🔴, a linha vira "prova no alvo retomada em <data>".
#   -Reopen (v3.64.2, sprint 6 do projeto piloto, Q-S6e): obrigatório para tirar a Task de 🔴, salvo as duas reaberturas
#        que já têm dono ("prova no alvo pendente", que o run.ps1 next reabre, e "estado de partida", que volta a 🟪):
#        · resume — retoma como está: o stakeholder reparou fora do repositório (máquina, emulador, configuração dele) ou o
#          script já aplicou o ajuste; nada no plano muda.
#        · replan -Decision "<a decisão>" — a decisão muda o que o plano manda (configuração de teste, guards.json, arquivo
#          fora de **Arquivos tocados:**, algo que o plano proíbe): a Task vai a 🟦, a decisão fica em
#          sprints/<n>/handoff/<ID>-replan.md e o run.ps1 next manda o Arquiteto emendar o plano antes de qualquer dev.
#        No piloto, "Ajustar a espera — o Arquiteto ajusta" virou -To build: o dev novo repetiu o verify que já tinha caído três
#        vezes, com o plano ainda proibindo mexer no karma.conf.js.
#   -To superseded -Decision "<decisão>" (v3.65.14): a Task que uma decisão do stakeholder dispensou (prova substituída por
#        correções posteriores, escopo que saiu) sai do quadro riscada — "~~T-…~~ retirada — substituída" —, a estimativa sai
#        do restante e o Registro e o run-log guardam a decisão. Nunca vira ✅ e não pede evidência; sem -Decision, recusa.
# Saída: uma linha. Exit 0 · 2 = erro de uso ou de leitura (nada é gravado).
param(
    [Parameter(Mandatory = $true)][string]$Task,
    [Parameter(Mandatory = $true)][string]$To,
    [string]$By = '',
    [string]$Reason = '',
    [ValidateSet('', 'resume', 'replan')][string]$Reopen = '',
    [string]$Decision = '',
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
    # v3.65.14 (E · garden S6: uma prova substituída por correções posteriores não tinha como sair de 🔴 sem um fechamento falso).
    # -To superseded -Decision "<a decisão do stakeholder>": a Task fica riscada no quadro ("~~T-…~~ retirada", que a fila, o
    # portão e a Review já tratam à parte), a estimativa sai do restante e o Registro guarda a decisão. Nunca vira ✅.
    $supersede = $t -ieq 'superseded' -or $t -ieq 'substituida' -or $t -ieq 'substituída'
    if ($supersede) {
        if (-not $Decision.Trim()) { [Console]::Error.WriteLine('mark: -To superseded pede -Decision "<a decisão do stakeholder que dispensou a Task>" — sem ela, nada gravado.'); exit 2 }
        if (-not $PSBoundParameters.ContainsKey('By')) { $By = 'stakeholder' }
        $t = 'blocked'   # só para passar a validação abaixo; o destino real é a linha riscada
    }
    if ($t -eq $E.Done -or $t -ieq 'done') { [Console]::Error.WriteLine('mark: o ✅ é do close.ps1 -Apply (confere o fechamento e baixa a estimativa).'); exit 2 }
    $target = if ($byName.ContainsKey($t.ToLowerInvariant())) { $byName[$t.ToLowerInvariant()] } elseif ($marks -contains $t) { $t } else { $null }
    if (-not $target) { [Console]::Error.WriteLine("mark: -To '$To' desconhecido — use todo, plan, build, qa ou blocked."); exit 2 }
    if ($Reason -and $target -ne $red) { [Console]::Error.WriteLine('mark: -Reason só vale com -To blocked (é a linha de Bloqueios da Task).'); exit 2 }
    if (-not $By) { $By = if ($target -in $E.Plan, $E.Build) { 'dev' } elseif ($target -eq $E.QA) { 'QA' } else { 'SM' } }

    $tp = Join-Path $Root '.team-project'
    $readmePath = Join-Path $tp 'README.md'
    if (-not (Test-Path -LiteralPath $readmePath)) { [Console]::Error.WriteLine("mark: $readmePath não existe — rode na raiz do projeto ou passe -Root."); exit 2 }
    $m = [regex]::Match((Read-Text $readmePath), $script:SprintLineRe)
    if (-not $m.Success) { [Console]::Error.WriteLine('mark: .team-project/README.md §2 sem a linha "Sprint corrente" — esperado: ' + $script:SprintLineHelp); exit 2 }
    $S = Join-Path $tp "sprints/$($m.Groups[1].Value)"
    $boardPath = Join-Path $S 'sprint-backlog.md'; $chartPath = Get-ChartPath $S   # kanban.md (v3.51) ou burndown.md: controle e trava
    # v3.60.0: a Série e o Registro de transições no consumption.md quando já estão lá (Get-RecordPath); o controle (Bloqueios)
    # continua no kanban.md.
    $bdPath = Get-RecordPath $S
    foreach ($p in $boardPath, $bdPath) { if (-not (Test-Path -LiteralPath $p)) { [Console]::Error.WriteLine("mark: $p não existe."); exit 2 } }
    $idPat = Get-IdPattern $Task
    $now = Get-Date -Format 'yyyy-MM-dd HH:mm'
    # v3.52.1 (garden item 15): a transição aponta a última rodada de agente medida para esta Task (papel · agente · hora do
    # fim), lida do usage.jsonl que a G16 grava — o stakeholder não cruza mais o Registro com as Rodadas do kanban.md.
    $roundRef = ''
    $usagePath = Join-Path $tp 'usage.jsonl'
    if (Test-Path -LiteralPath $usagePath) {
        $lastRow = $null
        foreach ($ul in [System.IO.File]::ReadLines($usagePath)) {
            if ($ul.IndexOf($Task) -lt 0) { continue }
            try { $uo = $ul | ConvertFrom-Json } catch { continue }
            $uw = @($uo.work) + @($uo.works) | Where-Object { $_ }
            if ($uw -contains $Task -and $uo.agent_id) { $lastRow = $uo }
        }
        if ($lastRow) {
            $hh = ''; try { $hh = ([datetime]::Parse([string]$lastRow.ts)).ToString('HH:mm') } catch { }
            $aid = [string]$lastRow.agent_id; if ($aid.Length -gt 8) { $aid = $aid.Substring(0, 8) }
            $roundRef = "$([string]$lastRow.role) $aid$(if ($hh) { " $hh" })"
        }
    }

    # v3.51.4 (garden item 23): a leitura e a gravação do quadro e do kanban.md sob a trava do kanban.md — o kanban.ps1 da
    # G16 regravava o arquivo no meio e a linha da Série desta transição sumia.
    $null = Invoke-WithFileLock $chartPath {
    $recFs = if ($bdPath -ne $chartPath) { Enter-FileLock $bdPath } else { $null }   # v3.60.0: o consumption.ps1 também o regrava
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
    if ($supersede) {
        $dec = (($Decision -replace '\|', '/') -replace '\s+', ' ').Trim()
        $cellsB = @(Split-Row $bl[$row]); $c0 = $cellsB[0]
        $ix0 = $bl[$row].IndexOf($c0.Trim())
        $bl[$row] = $bl[$row].Substring(0, $ix0) + "~~$($c0.Trim())~~ retirada — substituída" + $bl[$row].Substring($ix0 + $c0.Trim().Length)
        # A estimativa da Task (coluna Est. do quadro) sai do restante; a Task sai das restantes e da coluna do marcador.
        $est = 0.0; $hdrI = -1
        for ($i = $row - 1; $i -ge 0; $i--) { if ($bl[$i].TrimStart().StartsWith('|') -and (Clean-Cell (Split-Row $bl[$i])[0]) -eq 'ID') { $hdrI = $i; break } }
        if ($hdrI -ge 0) { $hc = @(Split-Row $bl[$hdrI] | ForEach-Object { Clean-Cell $_ }); for ($k = 0; $k -lt $hc.Count; $k++) { if ($hc[$k] -match '^Est') { $em = [regex]::Match([string]$cellsB[$k], '\d+(?:[.,]\d+)?'); if ($em.Success) { $est = [double]($em.Value -replace ',', '.') }; break } } }
        $bdText = Read-Text $bdPath; $bnl = if ($bdText.Contains("`r`n")) { "`r`n" } else { "`n" }
        $lines = ConvertTo-Lines $bdText
        $se = Get-TableEnd $lines '^##\s+S[ée]rie'
        if ($se -ge 0) {
            $sTable = (Get-Tables (Get-Section $bdText '^##\s+S[ée]rie'))[0]
            $last = Split-Row $lines[$se]; $first = if ($sTable.Rows.Count) { $sTable.Rows[0] } else { $last }
            $d0 = Get-FirstDate (Get-Cell $first (Find-Col $sTable 'Data'))
            $day = if ($d0) { [int]((Get-Date).Date - $d0).TotalDays } else { Clean-Cell (Get-Cell $last 0) }
            $num = { param($s) $mm = [regex]::Match([string]$s, '\d+(?:[.,]\d+)?'); if ($mm.Success) { [double]($mm.Value -replace ',', '.') } else { 0 } }
            $er = [Math]::Max(0, (& $num (Get-Cell $last (Find-Col $sTable 'Est. restante'))) - $est); $tr = [Math]::Max(0, (& $num (Get-Cell $last (Find-Col $sTable 'Tasks restantes'))) - 1)
            $cells = @("$day", $now, "$Task $from → retirada (substituída) · $By", ("{0:0.##}" -f $er).Replace(',', '.'), "$([int]$tr)")
            foreach ($mk in @($todo, $E.Plan, $E.Build, $E.QA, $E.Done, $red)) { $ci = Find-Col $sTable $mk; if ($ci -lt 0) { continue }; $v = [int](& $num (Get-Cell $last $ci)); if ($mk -eq $from) { $v = [Math]::Max(0, $v - 1) }; $cells += "$v" }
            $lines.Insert($se + 1, '| ' + ($cells -join ' | ') + ' |')
        }
        $regRow = "| $Task | $from → retirada (substituída) | $now | $By · sessão (``mark.ps1``) — $dec |"
        $re = Get-TableEnd $lines '^##\s+Registro de transi'
        if ($re -ge 0) { $lines.Insert($re + 1, $regRow) } else { $rb = Get-TableEnd $bl '^##\s+Registro de transi'; if ($rb -ge 0) { $bl.Insert($rb + 1, $regRow) } }
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($boardPath, ($bl -join $nl), $utf8)
        [System.IO.File]::WriteAllText($bdPath, ($lines -join $bnl), $utf8)
        if ($recFs) { Exit-FileLock $recFs $bdPath }
        $rl = Join-Path $S 'run-log.md'
        if (Test-Path -LiteralPath $rl) { [System.IO.File]::AppendAllText($rl, "| $now | $Task | retirada: substituída por decisão do stakeholder | $dec | sprint-backlog.md |`n", $utf8) }
        [Console]::Out.WriteLine("mark: $Task $from → retirada (substituída: $dec) · a estimativa ($est) saiu do restante; a Review a lista à parte (nem ✅ nem pendente)")
        return
    }
    if ($from -eq $target) { [Console]::Error.WriteLine("mark: $Task já está $target."); exit 2 }
    # v3.64.2: sair de 🔴 diz como — retomar como está ou replanejar com o Arquiteto antes do dev.
    $replanWhy = ''
    if ($from -eq $red -and $target -ne $red) {
        $bk = Get-BlockLines $S
        $lastWhy = if ($bk.ContainsKey($Task)) { [string]@($bk[$Task])[-1] } else { '' }
        $owned = ($lastWhy.IndexOf($script:TargetPendingTag, [StringComparison]::OrdinalIgnoreCase) -ge 0) -or ($lastWhy -match '(?i)estado de partida')
        if (-not $owned -and -not $Reopen) {
            [Console]::Error.WriteLine("mark: $Task sai de 🔴 ($(if ($lastWhy) { "Bloqueios: $lastWhy" } else { 'sem linha em Bloqueios' })) — diga como: -Reopen resume (o reparo foi fora do repositório, ou o ajuste já está feito; nada no plano muda) ou -Reopen replan -Decision `"<a decisão do stakeholder>`" (a decisão muda o que o plano manda — configuração de teste, guards.json, arquivo fora de **Arquivos tocados:**, algo que o plano proíbe —: a Task vai a 🟦 e o run.ps1 next manda o Arquiteto emendar o plano antes do dev). Nada gravado.")
            exit 2
        }
        if ($Reopen -eq 'replan') {
            if (-not $Decision.Trim()) { [Console]::Error.WriteLine('mark: -Reopen replan pede -Decision "<a decisão do stakeholder>" — é o que o Arquiteto lê para emendar o plano. Nada gravado.'); exit 2 }
            $target = $E.Plan; $replanWhy = $lastWhy
            if (-not $PSBoundParameters.ContainsKey('By')) { $By = 'Arquiteto · replanejar' }
        }
    }
    $ix = $bl[$row].IndexOf($from)
    $bl[$row] = $bl[$row].Substring(0, $ix) + $target + $bl[$row].Substring($ix + $from.Length)

    # 2 · Série do burndown: a composição recontada, a estimativa e as Tasks restantes como estavam (R24 — só o ✅ baixa)
    $bdText = Read-Text $bdPath; $bnl = if ($bdText.Contains("`r`n")) { "`r`n" } else { "`n" }
    $lines = ConvertTo-Lines $bdText
    $sepChart = ($bdPath -ne $chartPath)
    if ($sepChart -and (Test-Path -LiteralPath $chartPath)) { $kText = Read-Text $chartPath; $knl = if ($kText.Contains("`r`n")) { "`r`n" } else { "`n" }; $kLines = ConvertTo-Lines $kText } else { $sepChart = $false; $kLines = $lines }
    $se = Get-TableEnd $lines '^##\s+S[ée]rie'
    if ($se -lt 0) { [Console]::Error.WriteLine('mark: burndown sem tabela na "## Série".'); exit 2 }
    $sTable = (Get-Tables (Get-Section $bdText '^##\s+S[ée]rie'))[0]
    $last = Split-Row $lines[$se]; $first = if ($sTable.Rows.Count) { $sTable.Rows[0] } else { $last }
    $d0 = Get-FirstDate (Get-Cell $first (Find-Col $sTable 'Data'))
    $day = if ($d0) { [int]((Get-Date).Date - $d0).TotalDays } else { Clean-Cell (Get-Cell $last 0) }
    $cells = @("$day", $now, "$Task $from → $target · $By$(if ($roundRef) { " ← $roundRef" })",(Clean-Cell (Get-Cell $last (Find-Col $sTable 'Est. restante'))), (Clean-Cell (Get-Cell $last (Find-Col $sTable 'Tasks restantes'))))
    foreach ($mk in @($todo, $E.Plan, $E.Build, $E.QA, $E.Done, $red)) {
        $ci = Find-Col $sTable $mk
        if ($ci -lt 0) { continue }
        $v = 0; $vm = [regex]::Match((Get-Cell $last $ci), '\d+'); if ($vm.Success) { $v = [int]$vm.Value }
        if ($mk -eq $from) { $v = [Math]::Max(0, $v - 1) } elseif ($mk -eq $target) { $v++ }
        $cells += "$v"
    }
    $lines.Insert($se + 1, '| ' + ($cells -join ' | ') + ' |')

    # 3 · Registro de transições: no burndown; quadro anterior à v3.44.1 o tem no sprint-backlog.md
    $regRow = "| $Task | $from → $target | $now | $By · sessão (``mark.ps1``)$(if ($roundRef) { " · após a rodada $roundRef" }) |"
    $where = Split-Path $bdPath -Leaf
    $re = Get-TableEnd $lines '^##\s+Registro de transi'
    if ($re -ge 0) { $lines.Insert($re + 1, $regRow) }
    else {
        $rb = Get-TableEnd $bl '^##\s+Registro de transi'
        if ($rb -lt 0) { [Console]::Error.WriteLine('mark: nem o burndown nem o Sprint Backlog têm tabela no "## Registro de transições".'); exit 2 }
        $bl.Insert($rb + 1, $regRow); $where = 'sprint-backlog.md (quadro anterior à v3.44.1)'
    }

    # 4 · v3.53.6 (item 9): a linha de Bloqueios com o motivo (-Reason) e, ao sair de 🔴, a prova no alvo pendente retomada.
    $blkTxt = ''
    if ($Reason) {
        $hdr = '^#{2,3}\s+Bloqueios e riscos abertos'
        $tl = $null; $be = Get-TableEnd $kLines $hdr; $bw = Split-Path $chartPath -Leaf
        if ($be -ge 0) { $tl = $kLines } else { $be = Get-TableEnd $bl $hdr; if ($be -ge 0) { $tl = $bl; $bw = 'sprint-backlog.md' } }
        if ($tl) {
            $hs = $be; while ($hs - 1 -ge 0 -and $tl[$hs - 1].TrimStart().StartsWith('|')) { $hs-- }
            $hd = @(Split-Row $tl[$hs] | ForEach-Object { Clean-Cell $_ })
            $k = 0; for ($i = $hs + 1; $i -le $be; $i++) { $c0 = Clean-Cell (Split-Row $tl[$i])[0]; if ($c0 -match '^\d+$' -and [int]$c0 -gt $k) { $k = [int]$c0 } }
            $day = Get-Date -Format 'yyyy-MM-dd'; $why = (($Reason -replace '\|', '/') -replace '\s+', ' ').Trim()
            $envy = $why -match '(?i)alvo|ambiente|emulador|aparelho|estado de partida'
            $startSt = $why -match '(?i)estado de partida'   # v3.54.2: o next não reabre; o stakeholder decide
            # v3.64.1 (sprint 6 do projeto piloto, Q-S6e): o next só reabre sozinho a linha com a etiqueta da prova no alvo
            # pendente (Get-TargetPendingIds). "ambiente: suíte Karma…" levava a promessa e ficava em 🔴 para sempre — e o alvo
            # responder não prova que o Karma roda.
            $tpTag = $why.IndexOf($script:TargetPendingTag, [StringComparison]::OrdinalIgnoreCase) -ge 0
            $cells = @(foreach ($h in $hd) {
                if ($h -eq '#') { "$($k + 1)" } elseif ($h -match '(?i)^Task') { $Task } elseif ($h -match '(?i)Natureza') { $why }
                elseif ($h -match '(?i)Degrau') { if ($envy) { "escalado ao stakeholder em $day" } else { "par PO+Arquiteto desde $day" } }
                elseif ($h -match '(?i)Quem') { if ($startSt) { 'stakeholder (estado de partida do app: baseline ou cenário) — reabre com mark.ps1 -To qa' } elseif ($tpTag) { 'stakeholder (ambiente) — o run.ps1 next reabre quando o alvo responder' } elseif ($envy) { 'stakeholder (ambiente) — reparo fora do repositório: mark.ps1 -To build -Reopen resume; decisão que muda o plano: -Reopen replan -Decision "…" (Arquiteto antes do dev)' } else { 'PO + Arquiteto' } }
                elseif ($h -match '(?i)Desde') { $day } else { '' } })
            $tl.Insert($be + 1, '| ' + ($cells -join ' | ') + ' |')
            $blkTxt = "; Bloqueios: linha $($k + 1) em $bw"
        } else { $blkTxt = '; sem tabela "Bloqueios e riscos abertos" no kanban.md nem no quadro — grave a linha à mão' }
    }
    if ($from -eq $red -and $target -ne $red) {
        $nr = 0
        $lsAll = New-Object System.Collections.ArrayList; [void]$lsAll.Add($lines); [void]$lsAll.Add($bl); if ($sepChart) { [void]$lsAll.Add($kLines) }
        foreach ($ls in $lsAll) {
            for ($i = 0; $i -lt $ls.Count; $i++) {
                if ($ls[$i].TrimStart().StartsWith('|') -and $ls[$i] -match $idPat -and $ls[$i] -match ('(?i)' + [regex]::Escape($script:TargetPendingTag))) {
                    $ls[$i] = [regex]::Replace($ls[$i], '(?i)' + [regex]::Escape($script:TargetPendingTag), "prova no alvo retomada em $now"); $nr++
                }
            }
        }
        if ($nr) { $blkTxt = "; Bloqueios: $nr linha(s) da prova no alvo marcada(s) retomada(s)" }
    }

    # Tudo calculado: só agora grava, para não deixar o quadro trocado sem a linha no burndown.
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($boardPath, ($bl -join $nl), $utf8)
    [System.IO.File]::WriteAllText($bdPath, ($lines -join $bnl), $utf8)
    if ($sepChart) { [System.IO.File]::WriteAllText($chartPath, ($kLines -join $knl), $utf8) }
    if ($recFs) { Exit-FileLock $recFs $bdPath }
    [Console]::Out.WriteLine("mark: $Task $from → $target · quadro, Série e Registro gravados (Registro em $where; por quem: $By)$blkTxt")
    if ($Reopen -eq 'replan') {
        $rpf = Join-Path $S "handoff/$Task-replan.md"
        New-Item -ItemType Directory -Force (Split-Path $rpf) | Out-Null
        $rpt = @("# Replanejar a $Task — decisão do stakeholder ($now)", '', "**Bloqueio:** $(if ($replanWhy) { $replanWhy } else { 'sem linha em Bloqueios' })", "**Decisão:** $($Decision.Trim())", "**Por quem:** $By", '',
            'O run.ps1 next manda o Arquiteto emendar o plano com esta decisão antes de qualquer dev. Com o plano regravado depois deste arquivo e o plan.ps1 verde, a Task vai a 🟨 e o executor retoma pelo cartão.') -join "`n"
        [System.IO.File]::WriteAllText($rpf, $rpt + "`n", $utf8)
        [Console]::Out.WriteLine("mark: decisão gravada em sprints/$($m.Groups[1].Value)/handoff/$Task-replan.md — run.ps1 next dispara o Arquiteto para emendar o plano")
    }
    # v3.64.0 (item 6 A): a Task parou (🔴) com código no disco → checkpoint só do escopo do plano, para não travar a próxima.
    if ($target -eq $red -and $from -ne $red) {
        try {
            $tk = @(Get-SprintTasks $S | Where-Object { $_.Id -eq $Task })[0]
            if ($tk) { $ck = Save-TaskCheckpoint $Root $S $tk "parada em 🔴$(if ($Reason) { ": $Reason" })"; if ($ck) { [Console]::Out.WriteLine("mark: $ck") } }
        } catch { [Console]::Out.WriteLine("mark: checkpoint não gravado ($($_.Exception.Message)) — o código segue no disco") }
    }
    }
    try { $null = & (Join-Path $PSScriptRoot 'kanban.ps1') -Root $Root 2>&1 } catch { }   # v3.51.2: o Kanban (Markdown) acompanha a transição
    exit 0
} catch {
    [Console]::Error.WriteLine("mark: erro — $($_.Exception.Message)")
    exit 2
}
