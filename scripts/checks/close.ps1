# C1 — conferência mecânica do /sm close <T-ID> (proposta guards, v3.39).
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/close.ps1" -Task T-041 [-Post] [-Root <projeto>]
#   sem -Post: antes de o SM gravar o fechamento (R24 fica n-a); com -Post: depois da linha → ✅.
# Saída: tabela regra · resultado (ok / falhou / n-a) · linha decisiva — é a evidência da conferência (R7).
# Exit 1 só se R7, R7-verify (com guards.json → verify) ou R12 falharem (o close não acontece) · exit 2 = erro de uso ou de leitura · senão 0.

#   -Apply (v3.46, D6): sem falha bloqueante, a sessão fecha a Task sem o Agent scrum-master — marcador → ✅ no quadro,
#   linha no Registro e ponto na Série do burndown (estimativa baixada), roda o -Post e imprime a entrada de status
#   pré-preenchida para a sessão completar a frase do produto e colar no documento de status.
param(
    [Parameter(Mandatory = $true)][string]$Task,
    [switch]$Post,
    [switch]$Apply,
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

    # ---------- R7 · evidência mecânica (v3.45.1): verify full verde e da árvore que está no disco ----------
    $gj = $null; $gp = Join-Path $tp 'guards.json'
    if (Test-Path -LiteralPath $gp) { try { $gj = Read-Text $gp | ConvertFrom-Json } catch { } }
    $hasVerify = $null -ne $gj -and $null -ne $gj.verify -and @($gj.verify.PSObject.Properties | Where-Object { $_.Value }).Count -gt 0
    if (-not $hasVerify) { Add-Result 'R7-verify' 'n-a' 'guards.json sem comandos em "verify" — evidência só pelo veredito e pelo operator' }
    else {
        $vr = Join-Path (Get-VerifyDir $Root $Task) 'result.json'
        $vfull = $null; if (Test-Path -LiteralPath $vr) { try { $vfull = (Read-Text $vr | ConvertFrom-Json).full } catch { } }
        $now = Get-WorkTree $Root
        $vrel = $vr.Substring($Root.Length + 1) -replace '\\', '/'
        if ($null -eq $vfull) { Add-Result 'R7-verify' 'falhou' "sem verify full em $vrel — o dev roda verify.ps1 -Mode full no fim da Task" }
        elseif (@($vfull.commands | Where-Object { [int]$_.exit -ne 0 }).Count) { Add-Result 'R7-verify' 'falhou' ("verify full com falha: " + ((@($vfull.commands | Where-Object { [int]$_.exit -ne 0 }) | ForEach-Object { "$($_.key) exit $($_.exit)" }) -join ', ')) }
        elseif (-not $now) { Add-Result 'R7-verify' 'n-a' 'sem git: a árvore não se compara' }
        elseif ([string]$vfull.tree -ne $now) { Add-Result 'R7-verify' 'falhou' ("a árvore mudou depois do verify full de $($vfull.at) (" + ([string]$vfull.tree).Substring(0, 12) + " → " + $now.Substring(0, 12) + ") — rode -Mode full de novo e o QA confere") }
        else { Add-Result 'R7-verify' 'ok' ("verify full de $($vfull.at): " + (@($vfull.commands | ForEach-Object { "$($_.key) 0" }) -join ', ') + "; árvore igual (" + $now.Substring(0, 12) + ")") }
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

    # ---------- R7 · prova de falha (v3.46): toda mutação do plano pega pelo teste, na árvore do verify full ----------
    $planMuts = if ($plan) { @([regex]::Matches($plan, '(?m)^\s*-\s*(M\d+)\s*·') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique) } else { @() }
    if (-not $hasVerify) { Add-Result 'R7-mutação' 'n-a' 'guards.json sem "verify" — a prova de falha segue no relatório do dev e no veredito' }
    elseif ($planMuts.Count -eq 0) { Add-Result 'R7-mutação' 'n-a' 'plano sem **Mutações:** (plano anterior à v3.46, ou "sem prova: <motivo>" na §6)' }
    else {
        $vm2 = $null; if (Test-Path -LiteralPath $vr) { try { $vm2 = (Read-Text $vr | ConvertFrom-Json).mutation } catch { } }
        if ($null -eq $vm2) { Add-Result 'R7-mutação' 'falhou' ("plano com " + ($planMuts -join ', ') + " e nenhuma execução de verify.ps1 -Mode mutation") }
        elseif ($vfull -and [string]$vm2.tree -ne [string]$vfull.tree) { Add-Result 'R7-mutação' 'falhou' "mutação rodada sobre outra árvore que a do verify full — rode -Mode mutation de novo" }
        else {
            $got = @{}; foreach ($it in @($vm2.items)) { $got[[string]$it.id] = [string]$it.result }
            $miss = @($planMuts | Where-Object { -not $got.ContainsKey($_) })
            $notOk = @($planMuts | Where-Object { $got.ContainsKey($_) -and -not $got[$_].StartsWith('ok') } | ForEach-Object { "$_ " + ($got[$_] -split ' — ')[0] })
            if ($miss.Count -or $notOk.Count) { Add-Result 'R7-mutação' 'falhou' ((@($(if ($miss.Count) { 'sem execução: ' + ($miss -join ', ') }), $(if ($notOk.Count) { 'não pegas: ' + ($notOk -join ', ') })) | Where-Object { $_ }) -join '; ') }
            else { Add-Result 'R7-mutação' 'ok' ("$($planMuts.Count) mutação(ões) pegas pelo teste (" + ($planMuts -join ', ') + ") em $($vm2.at)") }
        }
    }

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
        $trans = Get-TransitionLog $S $board
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

    # ---------- R24 · transições e burndown (Registro e Série no burndown.md) ----------
    if (-not $Post) { Add-Result 'R24' 'n-a' 'a linha → ✅ nasce no close; rode de novo com -Post depois de gravá-la' }
    else {
        $closed = $null; $taskTrans = 0; $reached = @{}
        $trans = Get-TransitionLog $S $board
        if ($trans) {
            foreach ($t in (Get-Tables $trans)) {
                foreach ($row in $t.Rows) {
                    if ($row[0] -notmatch $idPat) { continue }
                    $taskTrans++
                    $dest = ((Get-Cell $row 1) -split '→')[-1]
                    foreach ($mk in $E.Plan, $E.Build, $E.QA) { if ($dest.Contains($mk)) { $reached[$mk] = $true } }
                    if ($dest.Contains($E.Done)) { $closed = Get-FirstDate (Get-Cell $row 2) }
                }
            }
        }
        $bdIssues = @()
        # Marcador acompanhado (sprint-run.md §Marcador): a Task fechada passou por 🟦, 🟨 e 🟪 no Registro.
        $skipped = @($E.Plan, $E.Build, $E.QA | Where-Object { -not $reached.ContainsKey($_) })
        if ($closed -and $skipped.Count) { $bdIssues += "Registro sem a linha → " + ($skipped -join ', → ') + " de $Task (marcador não acompanhado)" }
        $bdPath = Join-Path $S 'burndown.md'
        if (Test-Path -LiteralPath $bdPath) {
            $serie = Get-Section (Read-Text $bdPath) '^##\s+S[ée]rie'
            if ($serie) {
                foreach ($t in (Get-Tables $serie)) {
                    $ie = Find-Col $t 'Est. restante'; $iv = Find-Col $t 'Evento'
                    if ($ie -lt 0 -or $iv -lt 0) { continue }
                    # Cada transição da Task no Registro tem a sua linha na Série, que a cita no Evento — senão o gráfico fica parado até o close.
                    $serieRows = @($t.Rows | Where-Object { (Get-Cell $_ $iv) -match $idPat }).Count
                    if ($serieRows -lt $taskTrans) { $bdIssues += "Série com $serieRows linha(s) de $Task para $taskTrans transição(ões) no Registro (burndown parado entre as transições)" }
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
        if (-not $closed) { Add-Result 'R24' 'falhou' "Registro de transições (burndown.md) sem linha $Task → ✅ com data" }
        elseif ($bdIssues.Count) { Add-Result 'R24' 'falhou' ("burndown: " + ($bdIssues -join '; ')) }
        else { Add-Result 'R24' 'ok' ("→ ✅ em " + $closed.ToString('yyyy-MM-dd') + "; $taskTrans transição(ões), cada uma com linha na Série; burndown sem queda inexplicada") }
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

    # ---------- R28 · report do operator e consumo — desta Task (v3.45: antes era o sprint inteiro, e uma divergência
    # reprovava todo fechamento seguinte, inclusive de Task sem operator) ----------
    $r28 = @()
    $taskReports = @{}
    # Jobs desta Task: pasta operator/<n>/<T-ID>[-…]/ (operator.md §Onde grava) e todo report citado no plano ou na evidência.
    foreach ($jd in @(Get-ChildItem -LiteralPath (Join-Path $tp "operator/$n") -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match ('^' + [regex]::Escape($Task) + '(?![\w])') })) {
        foreach ($rf in @(Get-ChildItem -LiteralPath $jd.FullName -Recurse -Filter 'report*.md' -ErrorAction SilentlyContinue)) { $taskReports[$rf.FullName.ToLowerInvariant()] = $true }
    }
    $cited = @()
    if ($evBlock) {
        foreach ($pm in [regex]::Matches($evBlock, '(?m)^\*\*Relat[óo]rio do `operator`:\*\*(.*)$')) {
            foreach ($pp in [regex]::Matches($pm.Groups[1].Value, '`([^`]*report(-[^`/]*)?\.md)`')) { $cited += $pp.Groups[1].Value }
        }
    }
    if ($plan) {
        $s11 = Get-Section $plan '^##\s+11\.'
        if ($s11) { foreach ($pp in [regex]::Matches($s11, '`(\.team-project/operator/[^`]+?/)`(?:\s*—\s*`?([\w.-]+)`?)?')) {
            $dir = $pp.Groups[1].Value; $log = $pp.Groups[2].Value
            $cited += $(if ($log) { $dir + 'report-' + [System.IO.Path]::GetFileNameWithoutExtension($log) + '.md' } else { $dir + 'report.md' })
        } }
    }
    foreach ($rel in ($cited | Select-Object -Unique)) {
        if ($rel -match '<') { continue }
        $full = Join-Path $Root $rel
        if (-not (Test-Path -LiteralPath $full)) {
            $alt = Join-Path (Split-Path $full) 'report.md'   # job com uma chamada só grava report.md, mesmo citado por log
            if ($rel -match 'report-' -and (Test-Path -LiteralPath $alt)) { $full = $alt } else { $r28 += "report ausente: $rel"; continue }
        }
        $full = (Get-Item -LiteralPath $full).FullName
        $taskReports[$full.ToLowerInvariant()] = $true
        $fi = Get-Item -LiteralPath $full
        $lc = @(Get-Content -LiteralPath $full -Encoding UTF8).Count
        if ($lc -gt 200 -or $fi.Length -gt 20480) { $r28 += "report acima do teto ($lc linhas, $($fi.Length) bytes): $rel" }
    }
    $reports = $taskReports.Count
    # Segmento do sprint é o número, como em sprints/<n>/ — job gravado em outro nome some da contagem sem aviso.
    foreach ($alt in @(Get-ChildItem -LiteralPath (Join-Path $tp 'operator') -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^(?i)(sprint|s)[-_ ]?0*$n$" })) {
        $r28 += "pasta fora do padrão: operator/$($alt.Name)/ (o segmento é o número do sprint: operator/$n/)"
    }
    $opLines = 0
    $consPath = Join-Path $S 'consumption.md'
    if (Test-Path -LiteralPath $consPath) {
        $reg = Get-Section (Read-Text $consPath) '^##\s+Registro'
        if ($reg) { foreach ($t in (Get-Tables $reg)) {
            $ip = Find-Col $t 'Papel'; $it = Find-Col $t 'Task'
            foreach ($row in $t.Rows) { if ((Clean-Cell (Get-Cell $row $ip)) -eq 'operator' -and (Get-Cell $row $it) -match $idPat) { $opLines++ } }
        } }
    }
    if ($reports -ne $opLines) { $r28 += "operator de ${Task}: $reports report(s) (pasta operator/$n/$Task… e citados no plano/evidência) × $opLines linha(s) operator de $Task no consumo" }
    if ($r28.Count) { Add-Result 'R28' 'falhou' ($r28 -join '; ') }
    elseif ($reports -eq 0) { Add-Result 'R28' 'ok' "$Task sem job do operator e sem linha operator no consumo" }
    else { Add-Result 'R28' 'ok' "$Task`: $reports report(s) = $opLines linha(s) operator; ponteiros dentro do teto" }

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
    $blocking = @($script:Results | Where-Object { $_.Regra -in 'R7', 'R7-verify', 'R7-mutação', 'R12' -and $_.Resultado -eq 'falhou' })
    if ($blocking.Count) { [Console]::Out.WriteLine(''); [Console]::Out.WriteLine('**Não fecha:** ' + (($blocking | ForEach-Object { $_.Regra }) -join ' e ') + ' falhou.'); exit 1 }
    if ($Apply) {
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        $marks = @([char]::ConvertFromUtf32(0x2B1C), $E.Plan, $E.Build, $E.QA, [char]::ConvertFromUtf32(0x1F534))   # ⬜ 🟦 🟨 🟪 🔴
        if (-not ($taskRow -and $taskTable)) { [Console]::Error.WriteLine("C1 -Apply: $Task não está numa tabela de Tasks do quadro."); exit 2 }
        $from = $null; foreach ($mk in $marks) { if ($taskRow[0].Contains($mk)) { $from = $mk; break } }
        if ($taskRow[0].Contains($E.Done)) { [Console]::Error.WriteLine("C1 -Apply: $Task já está ✅ no quadro."); exit 2 }
        if (-not $from) { [Console]::Error.WriteLine("C1 -Apply: $Task sem marcador no quadro."); exit 2 }
        $est = 0.0; $em = [regex]::Match((Get-Cell $taskRow (Find-Col $taskTable 'Est')), '\d+([.,]\d+)?'); if ($em.Success) { $est = [double]($em.Value -replace ',', '.') }
        $now = Get-Date -Format 'yyyy-MM-dd HH:mm'

        # 1 · marcador no quadro (só a 1ª célula da linha da Task)
        $bl = $board -split "`r?`n"; $nl = if ($board.Contains("`r`n")) { "`r`n" } else { "`n" }
        for ($i = 0; $i -lt $bl.Count; $i++) {
            if (-not $bl[$i].TrimStart().StartsWith('|')) { continue }
            $c0 = (Split-Row $bl[$i])[0]
            if ($c0 -match $idPat -and $c0.Contains($from)) { $ix = $bl[$i].IndexOf($from); $bl[$i] = $bl[$i].Substring(0, $ix) + $E.Done + $bl[$i].Substring($ix + $from.Length); break }
        }
        [System.IO.File]::WriteAllText($boardPath, ($bl -join $nl), $utf8)

        # 2 · Registro e Série no burndown (R24): uma transição = uma linha em cada
        $bdPath = Join-Path $S 'burndown.md'
        if (-not (Test-Path -LiteralPath $bdPath)) { [Console]::Error.WriteLine("C1 -Apply: $bdPath não existe."); exit 2 }
        $bdText = Read-Text $bdPath; $bnl = if ($bdText.Contains("`r`n")) { "`r`n" } else { "`n" }
        $lines = New-Object System.Collections.ArrayList; foreach ($l in ($bdText -split "`r?`n")) { [void]$lines.Add($l) }
        function Get-TableEnd($Lines, [string]$Heading) {
            $h = -1; for ($i = 0; $i -lt $Lines.Count; $i++) { if ($Lines[$i] -match $Heading) { $h = $i; break } }
            if ($h -lt 0) { return -1 }
            $s = -1; for ($i = $h + 1; $i -lt $Lines.Count; $i++) { if ($Lines[$i].TrimStart().StartsWith('|')) { $s = $i; break }; if ($Lines[$i] -match '^#') { break } }
            if ($s -lt 0) { return -1 }
            $e = $s; while ($e + 1 -lt $Lines.Count -and $Lines[$e + 1].TrimStart().StartsWith('|')) { $e++ }
            return $e
        }
        $se = Get-TableEnd $lines '^##\s+S[ée]rie'
        if ($se -lt 0) { [Console]::Error.WriteLine('C1 -Apply: burndown sem tabela na "## Série".'); exit 2 }
        $sTable = (Get-Tables (Get-Section $bdText '^##\s+S[ée]rie'))[0]
        $last = Split-Row $lines[$se]; $first = if ($sTable.Rows.Count) { $sTable.Rows[0] } else { $last }
        $d0 = Get-FirstDate (Get-Cell $first (Find-Col $sTable 'Data'))
        $day = if ($d0) { [int]((Get-Date).Date - $d0).TotalDays } else { Clean-Cell (Get-Cell $last 0) }
        $num = { param($v) $m = [regex]::Match([string]$v, '\d+([.,]\d+)?'); if ($m.Success) { [double]($m.Value -replace ',', '.') } else { 0 } }
        $restante = [Math]::Max(0, (& $num (Get-Cell $last (Find-Col $sTable 'Est. restante'))) - $est)
        $tasksLeft = [Math]::Max(0, (& $num (Get-Cell $last (Find-Col $sTable 'Tasks restantes'))) - 1)
        $cells = @("$day", $now, "$Task $from → $($E.Done)", ('{0:0.##}' -f $restante), "$tasksLeft")
        foreach ($mk in @($marks[0], $marks[1], $marks[2], $marks[3], $E.Done, $marks[4])) {
            $ci = Find-Col $sTable $mk
            $v = [int](& $num (Get-Cell $last $ci))
            if ($mk -eq $from) { $v = [Math]::Max(0, $v - 1) } elseif ($mk -eq $E.Done) { $v++ }
            if ($ci -ge 0) { $cells += "$v" }
        }
        $lines.Insert($se + 1, '| ' + ($cells -join ' | ') + ' |')
        $re = Get-TableEnd $lines '^##\s+Registro de transi'
        if ($re -lt 0) { [Console]::Error.WriteLine('C1 -Apply: burndown sem tabela no "## Registro de transições".'); exit 2 }
        $lines.Insert($re + 1, "| $Task | $from → $($E.Done) | $now | sessão (``close.ps1 -Apply``) |")
        [System.IO.File]::WriteAllText($bdPath, ($lines -join $bnl), $utf8)

        # 3 · o -Post confere o que acabou de ser gravado
        [Console]::Out.WriteLine('')
        $ErrorActionPreference = 'Continue'
        $postOut = & powershell -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath -Task $Task -Post -Root $Root 2>&1 | Out-String
        $postCode = $LASTEXITCODE
        $r24 = ([regex]::Match($postOut, '(?m)^\| R24 \|[^\n]*')).Value
        [Console]::Out.WriteLine("**-Apply:** quadro $from → $($E.Done) · Registro e Série gravados (estimativa $('{0:0.##}' -f $est) baixada; restante $('{0:0.##}' -f $restante)) · -Post: $r24")

        # 4 · entrada de status pré-preenchida (templates/status-entry.md) — a frase do produto é da sessão
        $title = Clean-Cell (Get-Cell $taskRow (Find-Col $taskTable 'Task'))
        $sib = @(); $cur = $null
        foreach ($l in ((Read-Text $boardPath) -split "`r?`n")) {
            $hm = [regex]::Match($l, '^##\s+Hist[oó]ria\s+(H-[\w]+)'); if ($hm.Success) { $cur = $hm.Groups[1].Value; continue }
            if ($cur -eq $story -and $l.TrimStart().StartsWith('|')) { $c0 = (Split-Row $l)[0]; if ($c0 -match 'T-\d+') { $sib += $c0 } }
        }
        $done = @($sib | Where-Object { $_.Contains($E.Done) }).Count
        $okN = @($script:Results | Where-Object { $_.Resultado -eq 'ok' }).Count; $naN = @($script:Results | Where-Object { $_.Resultado -eq 'n-a' }).Count
        $failR = @($script:Results | Where-Object { $_.Resultado -eq 'falhou' } | ForEach-Object { $_.Regra })
        $evid = 'ver `sprints/' + $n + '/evidence/' + $Task + '.md`'
        if ($hasVerify -and $vfull) { $evid = 'verify full ' + $vfull.at + ' — ' + ((@($vfull.commands) | ForEach-Object { "$($_.key) exit $($_.exit) (" + (@($_.decisive) | Select-Object -Last 1) + ')' }) -join '; ') }
        $nex = if ($evBlock) { $s = Get-Section $evBlock '^###\s+N[ãa]o exercitado'; if ($s) { (($s -split "`r?`n") | Where-Object { $_.Trim() } | Select-Object -First 1) } else { $null } } else { $null }
        $nfiles = if ($plan) { $pl = [regex]::Match($plan, '(?s)\*\*Arquivos tocados:\*\*(.*?)(?:\r?\n[ \t]*\r?\n|\r?\n#|\z)'); if ($pl.Success) { [regex]::Matches($pl.Groups[1].Value, '`[^`]+`').Count } else { '?' } } else { '?' }
        [Console]::Out.WriteLine('')
        [Console]::Out.WriteLine('**Entrada de status** (cole no documento de status, `.team-project/README.md` §4; troque a frase entre <> pela do produto):')
        [Console]::Out.WriteLine('```markdown')
        [Console]::Out.WriteLine("- **$((Get-Date).ToString('dd/MM/yyyy')) — $Task ($title) concluída.** <o que passou a funcionar, em uma frase, na linguagem do produto>")
        [Console]::Out.WriteLine("  - **História:** $story — $done de $($sib.Count) Tasks da História fechadas")
        [Console]::Out.WriteLine("  - **Conferência (``close.ps1 -Apply``):** $okN ok, $naN n-a" + $(if ($failR.Count) { ', falhou (não bloqueante): ' + ($failR -join ', ') } else { ', nenhuma falhou' }) + " · ``-Post`` (R24): " + $(if ($r24 -match '\| ok \|') { 'ok' } else { 'falhou' }))
        [Console]::Out.WriteLine("  - **Evidência:** $evid")
        [Console]::Out.WriteLine("  - **Arquivos:** $nfiles no plano — detalhe no inventário de código.")
        [Console]::Out.WriteLine('  - **Decisões fora da especificação:** <do veredito e das respostas de GAP — ou "nenhuma">')
        [Console]::Out.WriteLine("  - **Não exercitado:** " + $(if ($nex) { $nex.Trim() } else { '<do veredito — ou "nada">' }))
        [Console]::Out.WriteLine('```')
        if ($postCode -ne 0 -or $r24 -notmatch '\| ok \|') { exit 1 }
    }
    exit 0
} catch {
    [Console]::Error.WriteLine("C1: erro — $($_.Exception.Message)")
    exit 2
}
