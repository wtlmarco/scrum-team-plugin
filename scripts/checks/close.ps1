# C1 — conferência mecânica do /sm close <T-ID> (proposta guards, v3.39).
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/close.ps1" -Task T-041 [-Post] [-Root <projeto>]
#   sem -Post: antes de o SM gravar o fechamento (R24 fica n-a); com -Post: depois da linha → ✅.
# Saída: tabela regra · resultado (ok / falhou / n-a) · linha decisiva — é a evidência da conferência (R7).
# Exit 1 só se R7 ou R12 falharem (o close não acontece) · exit 2 = erro de uso ou de leitura · senão 0.

param(
    [Parameter(Mandatory = $true)][string]$Task,
    [switch]$Post,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')

try {
    $tp = Join-Path $Root '.team-project'
    $readmePath = Join-Path $tp 'README.md'
    if (-not (Test-Path -LiteralPath $readmePath)) { [Console]::Error.WriteLine("C1: $readmePath não existe — rode na raiz do projeto ou passe -Root."); exit 2 }
    $readme = Read-Text $readmePath
    $m = [regex]::Match($readme, '(?m)^\|\s*\*\*Sprint corrente\*\*\s*\|\s*\*\*(\d+)\*\*')
    if (-not $m.Success) { [Console]::Error.WriteLine('C1: .team-project/README.md §2 sem a linha "Sprint corrente".'); exit 2 }
    $n = $m.Groups[1].Value
    $S = Join-Path $tp "sprints/$n"
    $idPat = Get-IdPattern $Task

    $boardPath = Join-Path $S 'sprint-backlog.md'
    if (-not (Test-Path -LiteralPath $boardPath)) { [Console]::Error.WriteLine("C1: $boardPath não existe."); exit 2 }
    $board = Read-Text $boardPath
    $boardTables = Get-Tables $board

    # Linha da Task no quadro e a História acima dela.
    $taskRow = $null; $taskTable = $null; $story = $null; $curStory = $null
    foreach ($line in ($board -split "`r?`n")) {
        $hm = [regex]::Match($line, '^##\s+Hist[oó]ria\s+(H-[\w]+)')
        if ($hm.Success) { $curStory = $hm.Groups[1].Value }
        if ($line.TrimStart().StartsWith('|')) {
            $cells = Split-Row $line
            if ($cells.Count -gt 1 -and $cells[0] -match $idPat -and $cells[0] -notmatch '^\s*Task\s*$') {
                if ($null -eq $taskRow -and $curStory) { $taskRow = $cells; $story = $curStory }
            }
        }
    }
    foreach ($t in $boardTables) { if ((Find-Col $t 'Plano') -ge 0 -and (Find-Col $t 'Cenários') -ge 0) { $taskTable = $t; break } }

    # Evidência: bloco mais recente (o primeiro "## " do arquivo).
    $evPath = Join-Path $S "evidence/$Task.md"
    $ev = $null; $evBlock = $null
    if (Test-Path -LiteralPath $evPath) {
        $ev = Read-Text $evPath
        $bm = [regex]::Match($ev, '(?ms)^## .*?(?=^## |\z)')
        $evBlock = if ($bm.Success) { $bm.Value } else { $ev }
    }

    # ---------- R7 · evidência com veredito ✅ e comando + saída ----------
    if ($null -eq $ev -or [string]::IsNullOrWhiteSpace($ev)) {
        Add-Result 'R7' 'falhou' "sprints/$n/evidence/$Task.md ausente ou vazio"
    } else {
        $vm = [regex]::Match($evBlock, '(?m)^\*\*Veredito:\*\*(.*)$')
        $v = if ($vm.Success) { $vm.Groups[1].Value } else { '' }
        $okV = (Get-VerdictMark $v) -eq $E.Done   # o primeiro marcador decide; o histórico depois dele não conta
        $blocks = [regex]::Matches($evBlock, '(?ms)^```[^\n]*\n(.*?)^```')
        $okCmd = $false
        foreach ($b in $blocks) {
            $bl = @($b.Groups[1].Value -split "`r?`n" | Where-Object { $_.Trim() -ne '' })
            if ($bl.Count -ge 2 -and $bl[0].TrimStart().StartsWith('> ') -and $bl[0] -notmatch '<comando>') { $okCmd = $true; break }
        }
        if (-not $vm.Success)   { Add-Result 'R7' 'falhou' 'bloco mais recente sem linha **Veredito:** — cada rodada do QA é um bloco ## completo, com o próprio veredito' }
        elseif (-not $okV)      { Add-Result 'R7' 'falhou' ("Veredito:" + $v + " — fecha só com ✅ como primeiro marcador da linha") }
        elseif (-not $okCmd)    { Add-Result 'R7' 'falhou' 'nenhum bloco de comando (> comando + saída) no bloco mais recente' }
        else                    { Add-Result 'R7' 'ok' ("Veredito:" + $v.Trim() + "; " + $blocks.Count + " bloco(s) de comando") }
    }

    # ---------- R12 · documentos vivos ----------
    $r12 = if ($evBlock) { Get-Section $evBlock '^###\s+Documentos vivos \(R12\)' } else { $null }
    if ($null -eq $r12) {
        Add-Result 'R12' 'falhou' 'evidência sem "### Documentos vivos (R12)" no bloco mais recente'
    } else {
        $sm = [regex]::Match($r12, '(?m)^\*\*Estado:\*\*\s*(.+)$')
        $st = if ($sm.Success) { $sm.Groups[1].Value.Trim() } else { '' }
        if ($st -match 'atualizados' -and $st -notmatch 'pendentes') { Add-Result 'R12' 'ok' "Estado: $st" }
        else { Add-Result 'R12' 'falhou' ("Estado: " + $(if ($st) { $st } else { '(vazio)' })) }
    }

    # ---------- R1 · uma Task em construção por dev ----------
    $limit = 1
    $cap = Get-LabelValue $readme 'Capacidade de dev'
    if ($cap) { $cm = [regex]::Match($cap, '\d+'); if ($cm.Success) { $limit = [int]$cm.Value } }
    $building = New-Object System.Collections.ArrayList
    foreach ($t in $boardTables) {
        if ((Clean-Cell $t.Header[0]) -ne 'ID') { continue }
        foreach ($row in $t.Rows) { if ($row[0].Contains($E.Build)) { [void]$building.Add((($row[0] -replace '[^\w-]', ' ').Trim())) } }
    }
    if ($building.Count -le $limit) { Add-Result 'R1' 'ok' ("$($building.Count) Task(s) em construção; limite $limit" + $(if ($building.Count) { ': ' + ($building -join ', ') } else { '' })) }
    else { Add-Result 'R1' 'falhou' ("$($building.Count) em construção (limite $limit): " + ($building -join ', ')) }

    # ---------- R4 · escopo ----------
    $r4 = @()
    $outside = Get-Section $board '^##\s+Entradas fora da Planning'
    if ($outside) {
        foreach ($t in (Get-Tables $outside)) {
            $ci = Find-Col $t 'O que saiu para caber'
            foreach ($row in $t.Rows) {
                if ($row[0] -match $idPat) {
                    if (Test-Placeholder (Get-Cell $row $ci)) { $r4 += 'falhou: entrada fora da Planning sem "o que saiu para caber"' }
                    else { $r4 += 'entrada fora da Planning declarada' }
                }
            }
        }
    }
    $esc = if ($evBlock) { Get-Section $evBlock '^###\s+Escopo' } else { $null }
    if ($null -eq $esc) { $r4 += 'falhou: evidência sem "### Escopo"' }
    else {
        $fm = [regex]::Match($esc, '(?m)^\*\*Fora do plano:\*\*\s*(.+)$')
        $fv = if ($fm.Success) { $fm.Groups[1].Value.Trim() } else { '' }
        if ($fv -match '^(?i)nada\.?$') { $r4 += 'fora do plano: nada' }
        elseif ([string]::IsNullOrWhiteSpace($fv) -or $fv -match '\|') { $r4 += 'falhou: "Fora do plano" não preenchido' }
        else {
            # Desvio que alguém com autoridade aceitou: **Desvio aceito:** aaaa-mm-dd — <quem decidiu> — <onde está a decisão>.
            $am = [regex]::Match($esc, '(?m)^\*\*Desvio aceito:\*\*\s*(.+)$')
            $ad = if ($am.Success -and -not (Test-Placeholder $am.Groups[1].Value)) { Get-FirstDate $am.Groups[1].Value } else { $null }
            if ($ad) { $r4 += ("fora do plano: $fv — desvio aceito em " + $ad.ToString('yyyy-MM-dd')) }
            else { $r4 += "falhou: fora do plano: $fv (sem **Desvio aceito:** com data)" }
        }
    }
    if ($r4 | Where-Object { $_ -like 'falhou*' }) { Add-Result 'R4' 'falhou' (($r4 | ForEach-Object { $_ -replace '^falhou: ', '' }) -join '; ') }
    else { Add-Result 'R4' 'ok' (($r4 -join '; ') + ' (o diff × plano é conferido pelo QA na frente 2)') }

    Add-Result 'R5' 'n-a' 'formato não mecânico: "Parei no passo" vive no relatório do dev, na conversa'

    # ---------- R8 · plano existe ----------
    $planPath = $null
    if ($taskRow -and $taskTable) {
        $pc = Get-Cell $taskRow (Find-Col $taskTable 'Plano')
        $lm = [regex]::Match($pc, '\]\(([^)]+)\)'); if (-not $lm.Success) { $lm = [regex]::Match($pc, '`([^`]+\.md)`') }
        if ($lm.Success -and $lm.Groups[1].Value -notmatch '<') {
            $cand = Join-Path $S $lm.Groups[1].Value
            if (Test-Path -LiteralPath $cand -PathType Leaf) { $planPath = $cand }
        }
    }
    if (-not $planPath) {
        $g = @(Get-ChildItem -LiteralPath (Join-Path $S 'plan') -Filter "$Task-*.md" -ErrorAction SilentlyContinue)
        if ($g.Count -ge 1) { $planPath = $g[0].FullName }
    }
    $plan = $null
    if ($planPath -and (Get-Item -LiteralPath $planPath).Length -gt 0) {
        $plan = Read-Text $planPath
        Add-Result 'R8' 'ok' ("plano: plan/" + (Split-Path $planPath -Leaf))
    } else { Add-Result 'R8' 'falhou' "nenhum plano para $Task em sprints/$n/plan/ (nem pela coluna Plano)" }

    # ---------- R16 · standards citados com seção (informativo) ----------
    if ($null -eq $plan) { Add-Result 'R16' 'n-a' 'sem plano' }
    else {
        $sc = [regex]::Matches($plan, 'standards/[\w.-]+\.md`?\s*§\s*\d')
        if ($sc.Count -ge 1) { Add-Result 'R16' 'ok' "$($sc.Count) citação(ões) de standards/ com seção" }
        else { Add-Result 'R16' 'falhou' 'nenhuma citação de standards/ com § numerado — conferir se todo passo é "Standard aplicável: n/a" com motivo' }
    }

    # ---------- R20 · Task com História; aprovação do pacote antes da construção ----------
    if (-not $story) { Add-Result 'R20' 'falhou' "$Task não está sob um cabeçalho '## História H-nnn' no quadro" }
    else {
        $approvedCell = Get-LabelValue $board 'Aprovado em'
        $frozenCell = Get-LabelValue $board 'stories/'
        $approved = if ($approvedCell) { Get-FirstDate $approvedCell } else { $null }
        $src = 'Aprovado em'
        if (-not $approved -and $frozenCell) { $approved = Get-FirstDate $frozenCell; $src = 'stories/ congelado em' }
        $toBuild = @()
        $trans = Get-Section $board '^##\s+Registro de transi'
        if ($trans) {
            foreach ($t in (Get-Tables $trans)) {
                foreach ($row in $t.Rows) {
                    if ($row[0] -match $idPat -and (Get-Cell $row 1).TrimEnd().EndsWith($E.Build)) {
                        $d = Get-FirstDate (Get-Cell $row 2); if ($d) { $toBuild += $d }
                    }
                }
            }
        }
        $frozenStory = @(Get-ChildItem -LiteralPath (Join-Path $S 'stories') -Filter "$story*.md" -ErrorAction SilentlyContinue)
        if ($frozenStory.Count -eq 0) { Add-Result 'R20' 'falhou' "$story sem cópia congelada em sprints/$n/stories/" }
        elseif (-not $approved -or $toBuild.Count -eq 0) { Add-Result 'R20' 'ok' "$story; ordem pacote × construção n-a (sem data de aprovação ou sem linha → 🟨)" }
        else {
            $first = ($toBuild | Sort-Object)[0]
            if ($approved -le $first) { Add-Result 'R20' 'ok' ("$story; pacote ($src) " + $approved.ToString('yyyy-MM-dd') + " ≤ 1ª entrada em construção " + $first.ToString('yyyy-MM-dd')) }
            else { Add-Result 'R20' 'falhou' ("construção em " + $first.ToString('yyyy-MM-dd') + " antes do pacote ($src) " + $approved.ToString('yyyy-MM-dd')) }
        }
    }

    # ---------- R24 · transição de fechamento e burndown ----------
    if (-not $Post) { Add-Result 'R24' 'n-a' 'a linha → ✅ nasce no close; rode de novo com -Post depois de gravá-la' }
    else {
        $closed = $null
        $trans = Get-Section $board '^##\s+Registro de transi'
        if ($trans) { foreach ($t in (Get-Tables $trans)) { foreach ($row in $t.Rows) { if ($row[0] -match $idPat -and (Get-Cell $row 1).Contains($E.Done)) { $closed = Get-FirstDate (Get-Cell $row 2) } } } }
        $bdIssues = @()
        $bdPath = Join-Path $S 'burndown.md'
        if (Test-Path -LiteralPath $bdPath) {
            $serie = Get-Section (Read-Text $bdPath) '^##\s+S[ée]rie'
            if ($serie) {
                foreach ($t in (Get-Tables $serie)) {
                    $ie = Find-Col $t 'Est. restante'; $iv = Find-Col $t 'Evento'
                    if ($ie -lt 0 -or $iv -lt 0) { continue }
                    $prev = $null
                    foreach ($row in $t.Rows) {
                        $nm = [regex]::Match((Get-Cell $row $ie), '\d+([.,]\d+)?')
                        if (-not $nm.Success) { continue }
                        $val = [double]($nm.Value -replace ',', '.')
                        if ($null -ne $prev -and $val -lt $prev) {
                            $evt = Get-Cell $row $iv
                            if (-not ($evt.Contains($E.Done) -or $evt -match 'T-\d+')) { $bdIssues += "queda sem fechamento em '" + (Get-Cell $row 1) + "'" }
                        }
                        $prev = $val
                    }
                }
            }
        }
        if (-not $closed) { Add-Result 'R24' 'falhou' "Registro de transições sem linha $Task → ✅ com data" }
        elseif ($bdIssues.Count) { Add-Result 'R24' 'falhou' ("burndown: " + ($bdIssues -join '; ')) }
        else { Add-Result 'R24' 'ok' ("→ ✅ em " + $closed.ToString('yyyy-MM-dd') + "; burndown sem queda inexplicada") }
    }

    # ---------- R25 · pacote de abertura e planning ----------
    $r25 = @()
    $pkg = Get-Section $board '^###\s+Pacote de abertura'
    if ($null -eq $pkg) { $r25 += 'seção "Pacote de abertura" ausente' }
    else {
        $dec = Get-LabelValue $pkg 'Decisão do stakeholder'
        if (Test-Placeholder $dec) { $r25 += 'Decisão não preenchida' }
        elseif ((Clean-Cell $dec) -notmatch '(?i)^\s*aprova' -or (Clean-Cell $dec) -match '(?i)reprova') { $r25 += "Decisão: $(Clean-Cell $dec)" }
        if (Test-Placeholder (Get-LabelValue $pkg 'Aprovado por')) { $r25 += 'Aprovado por não preenchido' }
        $proto = Get-LabelValue $pkg 'Protótipo navegável'
        if ((Test-Placeholder $proto) -or ($proto -notmatch 'fluxo ponta a ponta coberto:\**\s*\S')) { $r25 += 'Protótipo sem caminho, data de navegação ou fluxo ponta a ponta' }
        if (Test-Placeholder (Get-LabelValue $pkg 'stories/')) { $r25 += 'stories/ congelado em não preenchido' }
    }
    $planningPath = Join-Path $S 'planning.md'
    if (-not (Test-Path -LiteralPath $planningPath)) { $r25 += 'planning.md ausente' }
    else {
        $notIn = Get-Section (Read-Text $planningPath) '^##\s+5\.\s+O que N[ÃA]O entrou'
        $hasData = $false
        if ($notIn) {
            if ($notIn -match '(?im)^\s*[-*]?\s*nenhum') { $hasData = $true }
            foreach ($t in (Get-Tables $notIn)) { foreach ($row in $t.Rows) { if (-not (Test-Placeholder $row[0])) { $hasData = $true } } }
        }
        if (-not $hasData) { $r25 += 'planning.md §5 "O que NÃO entrou" vazio' }
    }
    $blk = Get-Section $board '^##\s+Bloqueios e riscos abertos'
    if ($blk) {
        foreach ($t in (Get-Tables $blk)) {
            $id = Find-Col $t 'Degrau'
            foreach ($row in $t.Rows) {
                if ((Clean-Cell $row[0]) -match '^\d+$' -and -not ($row -join '' -match '<')) {
                    if ((Get-Cell $row $id) -notmatch '(?i)par PO\s*\+\s*Arquiteto|escalado ao stakeholder|estrat[ée]gico') { $r25 += "bloqueio $($row[0]) sem degrau nomeado" }
                }
            }
        }
    }
    if ($r25.Count) { Add-Result 'R25' 'falhou' ($r25 -join '; ') } else { Add-Result 'R25' 'ok' 'pacote completo, aprovado; planning §5 preenchido; bloqueios com degrau' }

    # ---------- R26 · ambiente medido no plano (informativo) ----------
    if ($null -eq $plan) { Add-Result 'R26' 'n-a' 'sem plano' }
    else {
        $s3 = Get-Section $plan '^##\s+3\.'
        $p3 = $plan.IndexOf("`n## 3."); $p4 = $plan.IndexOf("`n## 4.")
        $rowsOk = $false
        if ($s3) {
            foreach ($t in (Get-Tables $s3)) {
                $iq = Find-Col $t 'Pré-requisito'; $io = Find-Col $t 'Saída real'
                if ($iq -lt 0 -or $io -lt 0) { continue }
                foreach ($row in $t.Rows) { if (-not ($row -join '' -match '<[^>]+>') -and -not [string]::IsNullOrWhiteSpace((Get-Cell $row $io))) { $rowsOk = $true } }
            }
        }
        $s9 = Get-Section $plan '^##\s+9\.'
        $iss = @()
        if (-not $s3 -or ($p4 -ge 0 -and $p3 -gt $p4)) { $iss += 'seção 3 (ambiente medido) ausente ou depois dos passos' }
        elseif (-not $rowsOk) { $iss += 'seção 3 sem linha de pré-requisito com saída real' }
        if (-not $s9 -or $s9 -notmatch 'Pré-requisito ausente') { $iss += 'seção 9 sem "Pré-requisito ausente"' }
        if ($iss.Count) { Add-Result 'R26' 'falhou' ($iss -join '; ') } else { Add-Result 'R26' 'ok' 'ambiente medido antes dos passos; parada por pré-requisito ausente declarada' }
    }

    # ---------- R28 · report do operator e consumo ----------
    $r28 = @()
    if ($evBlock) {
        foreach ($pm in [regex]::Matches($evBlock, '(?m)^\*\*Relat[óo]rio do `operator`:\*\*(.*)$')) {
            foreach ($pp in [regex]::Matches($pm.Groups[1].Value, '`([^`]*report(-[^`/]*)?\.md)`')) {
                $rel = $pp.Groups[1].Value
                if ($rel -match '<') { continue }
                $full = Join-Path $Root $rel
                if (-not (Test-Path -LiteralPath $full)) { $r28 += "report ausente: $rel"; continue }
                $fi = Get-Item -LiteralPath $full
                $lc = @(Get-Content -LiteralPath $full -Encoding UTF8).Count
                if ($lc -gt 200 -or $fi.Length -gt 20480) { $r28 += "report acima do teto ($lc linhas, $($fi.Length) bytes): $rel" }
            }
        }
    }
    $reports = @(Get-ChildItem -LiteralPath (Join-Path $tp "operator/$n") -Recurse -Filter 'report*.md' -ErrorAction SilentlyContinue).Count
    # Segmento do sprint é o número, como em sprints/<n>/ — job gravado em outro nome some da contagem sem aviso.
    foreach ($alt in @(Get-ChildItem -LiteralPath (Join-Path $tp 'operator') -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^(?i)(sprint|s)[-_ ]?0*$n$" })) {
        $r28 += "pasta fora do padrão: operator/$($alt.Name)/ (o segmento é o número do sprint: operator/$n/)"
    }
    $opLines = 0
    $consPath = Join-Path $S 'consumption.md'
    if (Test-Path -LiteralPath $consPath) {
        $reg = Get-Section (Read-Text $consPath) '^##\s+Registro'
        if ($reg) { foreach ($t in (Get-Tables $reg)) { $ip = Find-Col $t 'Papel'; foreach ($row in $t.Rows) { if ((Clean-Cell (Get-Cell $row $ip)) -eq 'operator') { $opLines++ } } } }
    }
    if ($reports -ne $opLines) { $r28 += "operator: $reports report(s) em operator/$n × $opLines linha(s) operator no consumo" }
    if ($r28.Count) { Add-Result 'R28' 'falhou' ($r28 -join '; ') } else { Add-Result 'R28' 'ok' "$reports report(s) = $opLines linha(s) operator; ponteiros da evidência dentro do teto" }

    # ---------- R30 · cenários mapeados e executados ----------
    if (-not ($taskRow -and $taskTable)) { Add-Result 'R30' 'falhou' "$Task não encontrada numa tabela de Tasks do quadro" }
    else {
        $cen = Clean-Cell (Get-Cell $taskRow (Find-Col $taskTable 'Cenários'))
        $ids = @([regex]::Matches($cen, 'SC-\d+') | ForEach-Object { $_.Value } | Select-Object -Unique)
        if ($cen -match '(?i)^nenhum aplic[áa]vel\s*[—-]\s*\S') { Add-Result 'R30' 'ok' "nenhum aplicável: $cen" }
        elseif ($ids.Count -eq 0) { Add-Result 'R30' 'falhou' 'coluna Cenários vazia ou sem SC-nnn nem "nenhum aplicável — motivo"' }
        else {
            $done = @{}
            $sec = if ($evBlock) { Get-Section $evBlock '^###\s+Cen[áa]rios de teste' } else { $null }
            if ($sec) {
                foreach ($t in (Get-Tables $sec)) {
                    $ir = Find-Col $t 'Resultado'
                    foreach ($row in $t.Rows) {
                        $sm2 = [regex]::Match($row[0], 'SC-\d+')
                        $res = Get-Cell $row $ir
                        if ($sm2.Success -and ($res.Contains($E.Done) -or $res.Contains($E.Fail) -or $res.Contains($E.Warn))) { $done[$sm2.Value] = $true }
                    }
                }
            }
            $missing = @($ids | Where-Object { -not $done.ContainsKey($_) })
            if ($missing.Count) { Add-Result 'R30' 'falhou' ("sem resultado na evidência: " + ($missing -join ', ')) }
            else { Add-Result 'R30' 'ok' ("resultado para " + ($ids -join ', ')) }
        }
    }

    foreach ($r in 'R2', 'R6', 'R9', 'R21', 'R32') { Add-Result $r 'n-a' $(if ($r -eq 'R21') { 'aceite é da Review — conferido por C2' } else { 'julgamento' }) }

    Write-Results "C1 · close $Task · sprint $n$(if ($Post) { ' · -Post' })"
    $blocking = @($script:Results | Where-Object { $_.Regra -in 'R7', 'R12' -and $_.Resultado -eq 'falhou' })
    if ($blocking.Count) { [Console]::Out.WriteLine(''); [Console]::Out.WriteLine('**Não fecha:** ' + (($blocking | ForEach-Object { $_.Regra }) -join ' e ') + ' falhou.'); exit 1 }
    exit 0
} catch {
    [Console]::Error.WriteLine("C1: erro — $($_.Exception.Message)")
    exit 2
}
