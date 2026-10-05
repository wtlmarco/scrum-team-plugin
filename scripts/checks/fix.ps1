# C4 — conferência do bloco da trilha fix (R33, v3.40).
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/fix.ps1" -Block B-007 [-Pre] [-Root <projeto>]
#   -Pre: passo 0 do /sm fix run — bloco planejado, nenhuma Task em construção, teto. Exit 1 = o run não começa.
#   sem -Pre: antes de a sessão gravar os estados finais. Exit 1 = as F-IDs listadas em "Não fecham" não vão a
#   "fechada" (as outras fecham — D6). Avisos (consumo, sobreposição com Task, revalidação) não bloqueiam.
# Exit 2 = erro de uso ou de leitura. Formatos lidos: fix-run.md, fix-card.md, fix-plan.md, verdict.md (variante fix).

param(
    [Parameter(Mandatory = $true)][string]$Block,
    [switch]$Pre,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')

$Check = [char]::ConvertFromUtf32(0x2714)   # ✔
$Cross = [char]::ConvertFromUtf32(0x2718)   # ✘

function Get-FSection([string]$Text, [string]$HeadingRegex) { if ($null -eq $Text) { return $null }; return Get-Section $Text $HeadingRegex }

function Get-Criteria([string]$Section, [int[]]$Numbers) {
    $got = @{}
    if ($Section) {
        foreach ($m in [regex]::Matches($Section, '(?m)^\s*-\s*C(\d)\s+(' + $Check + '|' + $Cross + ')\s*·\s*\S')) { $got[[int]$m.Groups[1].Value] = $m.Groups[2].Value }
    }
    $bad = @()
    foreach ($n in $Numbers) { if (-not $got.ContainsKey($n)) { $bad += "C$n ausente" } elseif ($got[$n] -eq $Cross) { $bad += "C$n $Cross" } }
    return $bad   # quem chama envolve em @()
}

# Caminho entre crases pode ter espaço; sem crases, vai até o primeiro espaço.
$PathRx = '(?:`([^`]+)`|([^\s`]+))'
function Get-PathsOf([string]$PlanSection, [string]$KindRx) {
    $arq = Get-FSection $PlanSection '^###\s+Arquivos'
    if (-not $arq) { return @() }
    return @([regex]::Matches($arq, '(?m)^\s*-\s*' + $KindRx + ':\s*' + $PathRx) | ForEach-Object { if ($_.Groups[1].Success) { $_.Groups[1].Value } else { $_.Groups[2].Value } } | Where-Object { $_ -notmatch '<' -and $_ -notmatch '^n/a' })
}
function Get-ProductionPaths([string]$PlanSection) { return Get-PathsOf $PlanSection 'produ[cç][aã]o' }
function Get-AllPaths([string]$PlanSection) { return Get-PathsOf $PlanSection '(?:produ[cç][aã]o|teste)' }
function Test-Promoted([string]$PlanSection) { return [bool]($PlanSection -match '\*\*Crit[ée]rio que caiu:\*\*\s*C[1-8]\s*[—-]\s*\S') }

# Commits da Correção: o citado em **Commit:** e todos cujo assunto começa com "F-<nnn>:" (retrabalho incluído).
function Get-OwnCommits([string]$F, [string]$VerdictSection) {
    $own = @()
    $cm = [regex]::Match([string]$VerdictSection, '\*\*Commit:\*\*\s*`?([0-9a-f]{7,40})\b')
    if ($cm.Success) { $own += $cm.Groups[1].Value }
    $own += @(& git -C $Root log --all --format=%H --grep="^$([regex]::Escape($F)):" 2>$null | Where-Object { $_ })
    return @($own | Select-Object -Unique)
}

function Norm([string]$p) { return ($p -replace '\\', '/').TrimStart('./').ToLowerInvariant() }

try {
    if ($Block -notmatch '^B-\d+$') { [Console]::Error.WriteLine("C4: -Block deve ser B-<nnn> (recebido: $Block)."); exit 2 }
    $tp = Join-Path $Root '.team-project'
    $readmePath = Join-Path $tp 'README.md'
    if (-not (Test-Path -LiteralPath $readmePath)) { [Console]::Error.WriteLine("C4: $readmePath não existe — rode na raiz do projeto ou passe -Root."); exit 2 }
    $readme = Read-Text $readmePath
    $N = 5; $cap = 5
    $nv = Get-LabelValue $readme 'Limite de arquivos por Correção'; if ($nv) { $m = [regex]::Match($nv, '\d+'); if ($m.Success) { $N = [int]$m.Value } }
    $tv = Get-LabelValue $readme 'Teto de Correções por bloco';     if ($tv) { $m = [regex]::Match($tv, '\d+'); if ($m.Success) { $cap = [int]$m.Value } }

    $sm = [regex]::Match($readme, '(?m)^\|\s*\*\*Sprint corrente\*\*\s*\|\s*\*\*(\d+)\*\*')
    $sprintDir = if ($sm.Success) { Join-Path $tp ("sprints/" + $sm.Groups[1].Value) } else { $null }
    $board = $null
    if ($sprintDir -and (Test-Path -LiteralPath (Join-Path $sprintDir 'sprint-backlog.md')) -and -not (Test-Path -LiteralPath (Join-Path $sprintDir 'retrospective.md'))) {
        $board = Read-Text (Join-Path $sprintDir 'sprint-backlog.md')
    }

    $bDir = Join-Path $tp "fixes/$Block"
    $planPath = Join-Path $bDir 'plan.md'
    $verdictPath = Join-Path $bDir 'verdict.md'
    $plan = if (Test-Path -LiteralPath $planPath) { Read-Text $planPath } else { $null }
    $verdict = if (Test-Path -LiteralPath $verdictPath) { Read-Text $verdictPath } else { $null }

    # F-IDs do bloco: o índice manda; sem índice, os cabeçalhos do plano.
    $rows = @{}
    $idxPath = Join-Path $tp 'fixes.md'
    $idx = if (Test-Path -LiteralPath $idxPath) { Read-Text $idxPath } else { $null }
    $allRows = @()
    if ($idx) {
        $cor = Get-Section $idx '^##\s+Corre[çc][õo]es'
        if ($cor) {
            foreach ($t in (Get-Tables $cor)) {
                $ib = Find-Col $t 'Bloco'; $ie = Find-Col $t 'Estado'; $ip = Find-Col $t 'Promovida para'; $ir = Find-Col $t 'Reaberta em'
                foreach ($row in $t.Rows) {
                    $fid = ([regex]::Match($row[0], 'F-\d+')).Value
                    if (-not $fid) { continue }
                    $rec = [pscustomobject]@{ Id = $fid; Bloco = (Clean-Cell (Get-Cell $row $ib)); Estado = (Clean-Cell (Get-Cell $row $ie)); Promovida = (Get-Cell $row $ip); Reaberta = (Get-Cell $row $ir) }
                    $allRows += $rec
                    if ($rec.Bloco -eq $Block) { $rows[$fid] = $rec }
                }
            }
        }
    }
    if ($rows.Count -eq 0 -and $plan) {
        foreach ($m in [regex]::Matches($plan, '(?m)^##\s+(F-\d+)')) { $rows[$m.Groups[1].Value] = [pscustomobject]@{ Id = $m.Groups[1].Value; Bloco = $Block; Estado = ''; Promovida = ''; Reaberta = '' } }
    }
    $fids = @($rows.Keys | Sort-Object)

    # ---------- teto e limite (comuns aos dois modos) ----------
    $tetoIss = @()
    if ($plan) {
        $active = @([regex]::Matches($plan, '(?m)^##\s+(F-\d+)') | Where-Object { -not (Test-Promoted (Get-FSection $plan ('^##\s+' + $_.Groups[1].Value + '\b'))) })
        $nF = $active.Count   # promovidas não contam no teto
        if ($nF -gt $cap) { $tetoIss += "$nF Correções no plano (teto $cap)" }
        $sum = 0
        foreach ($m in $active) {
            $fs = Get-FSection $plan ('^##\s+' + $m.Groups[1].Value + '\b')
            $pp = @(Get-ProductionPaths $fs)
            $sum += $pp.Count
            if ($pp.Count -gt $N) { $tetoIss += "$($m.Groups[1].Value) com $($pp.Count) arquivos de produção (N=$N)" }
        }
        if ($sum -gt 2 * $N) { $tetoIss += "$sum arquivos de produção no bloco (2N=$(2 * $N))" }
    }

    if ($Pre) {
        if (-not $plan) { Add-Result 'R33/pre-plano' 'falhou' "fixes/$Block/plan.md ausente — rode /sm fix plan" }
        elseif ($verdict -and $verdict -match '(?m)^##\s+Fechamento') { Add-Result 'R33/pre-plano' 'falhou' "bloco $Block já fechado" }
        else { Add-Result 'R33/pre-plano' 'ok' "bloco $Block planejado: $($fids.Count) Correção(ões)" }
        if (-not $board) { Add-Result 'R33/pre-R1' 'n-a' 'sem sprint aberto' }
        else {
            $building = @()
            foreach ($t in (Get-Tables $board)) { if ((Clean-Cell $t.Header[0]) -ne 'ID') { continue }; foreach ($row in $t.Rows) { if ($row[0].Contains($E.Build)) { $building += (($row[0] -replace '[^\w-]', ' ').Trim()) } } }
            if ($building.Count) { Add-Result 'R33/pre-R1' 'falhou' ("Task em construção: " + ($building -join ', ') + " — o fix run espera (R1)") } else { Add-Result 'R33/pre-R1' 'ok' 'nenhuma Task em construção' }
        }
        if ($tetoIss.Count) { Add-Result 'R33/pre-teto' 'falhou' ($tetoIss -join '; ') } else { Add-Result 'R33/pre-teto' 'ok' "dentro do teto ($cap Correções, N=$N, 2N=$(2 * $N))" }
        Write-Results "C4 · $Block · -Pre"
        if (@($script:Results | Where-Object { $_.Resultado -eq 'falhou' }).Count) { [Console]::Out.WriteLine(''); [Console]::Out.WriteLine('**O fix run não começa.**'); exit 1 }
        exit 0
    }

    if (-not $plan -or -not $verdict) { [Console]::Error.WriteLine("C4: fixes/$Block/plan.md e verdict.md são necessários."); exit 2 }

    # pending.md do QA (reprodução): no diretório de produto (README §4) ou, se não houver, em .team-project/
    $pm = [regex]::Match($readme, '\*\*Diretório de produto:\*\*\s*`?([^`\s]+)`?')
    $productDir = Join-Path $Root $(if ($pm.Success -and $pm.Groups[1].Value -notmatch '<') { $pm.Groups[1].Value } else { 'docs/' })
    $pendingFile = @(@($productDir, $tp) | Where-Object { Test-Path -LiteralPath $_ } | ForEach-Object { Get-ChildItem -LiteralPath $_ -Recurse -Filter 'pending.md' -File -ErrorAction SilentlyContinue } | Select-Object -First 1)
    $pending = if ($pendingFile.Count) { Read-Text $pendingFile[0].FullName } else { $null }
    $isGit = $false
    try { $null = & git -C $Root rev-parse --is-inside-work-tree 2>$null; $isGit = ($LASTEXITCODE -eq 0) } catch { }

    $noClose = @{}   # F-ID -> motivos
    function Block-F([string]$F, [string]$Why) { if (-not $noClose.ContainsKey($F)) { $noClose[$F] = @() }; $noClose[$F] += $Why }
    $it = @{ 1 = @(); 2 = @(); 3 = @(); 4 = @(); 5 = @(); 10 = @() }
    $candidates = @()

    foreach ($F in $fids) {
        $rec = $rows[$F]
        $cardPath = Join-Path $tp "fixes/$F.md"
        $card = if (Test-Path -LiteralPath $cardPath) { Read-Text $cardPath } else { $null }
        $ps = Get-FSection $plan ('^##\s+' + $F + '\b')
        $vs = Get-FSection $verdict ('^##\s+QA\s+[—-]\s+' + $F + '\b')

        if ($rec.Estado -match '(?i)devolvida') { continue }   # voltou à fila: não fecha neste bloco nem o trava
        if ($rec.Estado -match '(?i)promovida') {
            $why = @()
            if (Test-Placeholder $rec.Promovida) { $why += '"Promovida para" vazio' }
            if (-not ($ps -match '\*\*Crit[ée]rio que caiu:\*\*\s*C[1-8]\s*[—-]\s*\S')) { $why += 'plano sem "Critério que caiu"' }
            $dest = Get-FSection $card '^##\s+Destino'
            if (-not ($dest -match '\*\*Crit[ée]rio que caiu:\*\*\s*C[1-8]\s*[—-]\s*\S')) { $why += 'ficha sem "Critério que caiu"' }
            if ($why.Count) { $it[10] += "$F (" + ($why -join ', ') + ')'; Block-F $F 'item 10' }
            continue
        }

        # 4 · veredito
        $vm = if ($vs) { [regex]::Match($vs, '(?m)^\*\*Veredito:\*\*(.*)$') } else { $null }
        $v = if ($vm -and $vm.Success) { $vm.Groups[1].Value } else { '' }
        if ((Get-VerdictMark $v) -ne $E.Done) {
            $it[4] += "$F (" + $(if ($vs) { 'veredito:' + $v.Trim() } else { 'sem seção no verdict.md' }) + ')'
            Block-F $F 'item 4'
            continue
        }
        $candidates += $F

        # 1 · C1–C8
        $b1 = @(Get-Criteria (Get-FSection $card '^##\s+Elegibilidade funcional') @(1, 2, 3, 4)) + @(Get-Criteria (Get-FSection $ps '^###\s+Elegibilidade t[ée]cnica') @(5, 6, 7, 8))
        if (-not $card) { $b1 = @('ficha ausente') + $b1 }
        if ($b1.Count) { $it[1] += "$F (" + ($b1 -join ', ') + ')'; Block-F $F 'item 1' }

        # 2 · reprodução (defeito)
        if ($card -and $card -match '(?m)^\*\*Tipo:\*\*\s*defeito') {
            $em = [regex]::Match($card, '\*\*Entrada no pending\.md:\*\*\s*`?([^\s`·]+)')
            $cm = [regex]::Match($card, '\*\*Causa:\*\*\s*`?(\S+:\d+)')
            $why = @()
            if (-not $em.Success -or $em.Groups[1].Value -match '<') { $why += 'sem entrada no pending.md' }
            elseif (-not $pending -or $pending -notmatch (Get-IdPattern $em.Groups[1].Value)) { $why += "$($em.Groups[1].Value) não está no pending.md" }
            if (-not $cm.Success) { $why += 'sem Causa arquivo:linha' }
            if ($why.Count) { $it[2] += "$F (" + ($why -join ', ') + ')'; Block-F $F 'item 2' }
        }

        # 3 · teste falhou antes e passou depois
        $ts = Get-FSection $vs '^###\s+Teste de regress[ãa]o'
        $why = @()
        $am = if ($ts) { [regex]::Match($ts, '\*\*Antes:\*\*\s*exit\s+(-?\d+)') } else { $null }
        $dm = if ($ts) { [regex]::Match($ts, '\*\*Depois:\*\*\s*exit\s+(-?\d+)') } else { $null }
        if (-not ($am -and $am.Success) -or [int]$am.Groups[1].Value -eq 0) { $why += 'Antes sem exit ≠ 0' }
        if (-not ($dm -and $dm.Success) -or [int]$dm.Groups[1].Value -ne 0) { $why += 'Depois sem exit 0' }
        $cmds = if ($ts) { ([regex]::Matches($ts, '(?m)^\s*>\s+(?!<)\S')).Count } else { 0 }
        if ($cmds -lt 2) { $why += "$cmds comando(s) colado(s), esperados 2" }
        if ($why.Count) { $it[3] += "$F (" + ($why -join ', ') + ')'; Block-F $F 'item 3' }

        # 5 · arquivos, escopo e documentos vivos
        $why = @()
        $prod = @(Get-ProductionPaths $ps)
        if ($prod.Count -eq 0) { $why += 'plano sem "- produção:"' }
        if ($prod.Count -gt $N) { $why += "$($prod.Count) arquivos de produção (N=$N)" }
        $esc = Get-FSection $vs '^###\s+Escopo'
        $fo = if ($esc) { [regex]::Match($esc, '(?m)^\*\*Fora do plano:\*\*\s*(.+)$') } else { $null }
        if (-not ($fo -and $fo.Success -and $fo.Groups[1].Value.Trim() -match '^(?i)nada\.?$')) { $why += 'Fora do plano ≠ nada' }
        $dv = Get-FSection $vs '^###\s+Documentos vivos \(R12\)'
        $st = if ($dv) { [regex]::Match($dv, '(?m)^\*\*Estado:\*\*\s*(.+)$') } else { $null }
        if (-not ($st -and $st.Success -and $st.Groups[1].Value -match 'atualizados' -and $st.Groups[1].Value -notmatch 'pendentes')) { $why += 'Documentos vivos ≠ atualizados' }
        if ($isGit) {
            $allowed = @(Get-AllPaths $ps | ForEach-Object { Norm $_ })
            $changed = @()
            foreach ($sha in (Get-OwnCommits $F $vs)) { $changed += @(& git -C $Root show --name-only --format= $sha 2>$null | Where-Object { $_ } | ForEach-Object { Norm $_ }) }
            $extra = @($changed | Select-Object -Unique | Where-Object { $allowed -notcontains $_ })
            if ($extra.Count) { $why += 'commit(s) da Correção tocam fora do plano: ' + ($extra -join ', ') }
        }
        if ($why.Count) { $it[5] += "$F (" + ($why -join ', ') + ')'; Block-F $F 'item 5' }
    }

    $labels = @{ 1 = 'R33/1 C1–C8'; 2 = 'R33/2 reprodução'; 3 = 'R33/3 antes/depois'; 4 = 'R33/4 veredito'; 5 = 'R33/5 arquivos'; 10 = 'R33/10 promoção' }
    foreach ($k in 4, 1, 2, 3, 5) {
        if ($it[$k].Count) { Add-Result $labels[$k] 'falhou' ($it[$k] -join '; ') }
        elseif ($candidates.Count) { Add-Result $labels[$k] 'ok' ($candidates -join ', ') }
        else { Add-Result $labels[$k] 'n-a' 'nenhuma F-ID com veredito ✅' }
    }
    if ($tetoIss.Count) { Add-Result 'R33/6 teto' 'falhou' ($tetoIss -join '; ') } else { Add-Result 'R33/6 teto' 'ok' "dentro do teto ($cap Correções, N=$N)" }

    # 7 · consumo de bloco fora de fixes/ (aviso)
    $c7 = @()
    $regs = @(Join-Path $tp 'consumption.md') + @(Get-ChildItem -LiteralPath (Join-Path $tp 'sprints') -Recurse -Filter 'consumption.md' -File -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName })
    foreach ($rp in $regs) {
        if (-not (Test-Path -LiteralPath $rp)) { continue }
        $reg = Get-Section (Read-Text $rp) '^##\s+Registro'
        if (-not $reg) { continue }
        foreach ($t in (Get-Tables $reg)) {
            $iu = Find-Col $t 'Task/Hist'; $iun = Find-Col $t 'Unidade'; $in = Find-Col $t 'Nota'
            foreach ($row in $t.Rows) {
                $ids = (Clean-Cell (Get-Cell $row $iu)) + ' ' + (Clean-Cell (Get-Cell $row $iun))
                $nota = Clean-Cell (Get-Cell $row $in)
                if ($ids -match '(^|\s)B-\d+') { $c7 += "linha de bloco em $($rp.Substring($tp.Length + 1))" }
                elseif ($ids -match '(^|\s)F-\d+' -and -not $nota.StartsWith('triagem;')) { $c7 += "F-ID sem 'triagem;' em $($rp.Substring($tp.Length + 1))" }
            }
        }
    }
    if ($c7.Count) { Add-Result 'R33/7 consumo' 'aviso' (($c7 | Select-Object -Unique) -join '; ') } else { Add-Result 'R33/7 consumo' 'ok' 'nenhuma linha do bloco fora de fixes/' }

    # 8 · fix run × Task em construção (aviso; granularidade de dia)
    $runStart = Get-FirstDate ([string](Get-LabelValue $verdict 'Executado em'))
    $em2 = [regex]::Match($verdict, '\*\*Executado em:\*\*\s*([^\s·]+)'); if ($em2.Success) { $runStart = Get-FirstDate $em2.Groups[1].Value }
    $fm2 = [regex]::Match($verdict, '\*\*Fechado em:\*\*\s*([^\s·]+)')
    $runEnd = if ($fm2.Success) { Get-FirstDate $fm2.Groups[1].Value } else { (Get-Date).Date }
    if (-not $board -or -not $runStart) { Add-Result 'R33/8 Task em construção' 'n-a' $(if (-not $board) { 'sem sprint aberto' } else { 'verdict.md sem "Executado em"' }) }
    else {
        $starts = @{}; $ends = @{}
        $trans = Get-Section $board '^##\s+Registro de transi'
        if ($trans) {
            foreach ($t in (Get-Tables $trans)) {
                foreach ($row in $t.Rows) {
                    $tid = ([regex]::Match($row[0], 'T-[\w]+')).Value; if (-not $tid) { continue }
                    $d = Get-FirstDate (Get-Cell $row 2); if (-not $d) { continue }
                    $to = (Get-Cell $row 1)
                    if ($to.TrimEnd().EndsWith($E.Build) -and -not $starts.ContainsKey($tid)) { $starts[$tid] = $d }
                    if ($to.TrimStart().StartsWith($E.Build)) { $ends[$tid] = $d }   # saída de 🟨 encerra a construção
                }
            }
        }
        $over = @()
        foreach ($tid in $starts.Keys) {
            $ts0 = $starts[$tid]; $te0 = if ($ends.ContainsKey($tid)) { $ends[$tid] } else { (Get-Date).Date.AddDays(1) }
            if ($runStart -lt $te0 -and $runEnd -gt $ts0) { $over += $tid }
        }
        if ($over.Count) { Add-Result 'R33/8 Task em construção' 'aviso' ("o run cruza a construção de " + ($over -join ', ') + " (granularidade de dia; a garantia é o -Pre)") }
        else { Add-Result 'R33/8 Task em construção' 'ok' 'nenhuma Task em construção no intervalo do run' }
    }

    # 9 · revalidação (aviso)
    $pd = [regex]::Match($plan, '\*\*Data:\*\*\s*(\d{4}-\d{2}-\d{2})')
    if (-not $pd.Success) { Add-Result 'R33/9 revalidação' 'n-a' 'plan.md sem **Data:**' }
    else {
        $need = @()
        foreach ($F in $candidates) {
            $ps = Get-FSection $plan ('^##\s+' + $F + '\b')
            $paths = @(Get-AllPaths $ps)
            if ($paths.Count -eq 0) { continue }
            $changed = $false
            if ($isGit) {
                $log = @(& git -C $Root log --since="$($pd.Groups[1].Value)" --format=%H -- @paths 2>$null | Where-Object { $_ })
                # commits da própria Correção (inclusive retrabalho "F-<nnn>:") não contam
                $own = @(Get-OwnCommits $F (Get-FSection $verdict ('^##\s+QA\s+[—-]\s+' + $F + '\b')))
                $log = @($log | Where-Object { $sha = $_; -not ($own | Where-Object { $_.StartsWith($sha) -or $sha.StartsWith($_) }) })
                $changed = $log.Count -gt 0
            } elseif ($sprintDir -and (Test-Path -LiteralPath (Join-Path $sprintDir 'plan'))) {
                foreach ($pf in (Get-ChildItem -LiteralPath (Join-Path $sprintDir 'plan') -Filter '*.md' -File)) {
                    if ($pf.LastWriteTime.Date -lt (Get-FirstDate $pd.Groups[1].Value)) { continue }
                    $pt = Read-Text $pf.FullName
                    foreach ($p in $paths) { if ($pt.Contains($p)) { $changed = $true } }
                }
            }
            if ($changed) {
                $rv = Get-FSection $ps '^###\s+Revalida[çc][ãa]o'
                if (-not $rv -or (Test-Placeholder (($rv -split "`n" | Where-Object { $_.Trim() }) -join ' ')) -or $rv.Trim() -match '^(?i)n/a') { $need += $F }
            }
        }
        if ($need.Count) { Add-Result 'R33/9 revalidação' 'aviso' ("arquivo mudou depois do plano sem revalidação registrada: " + ($need -join ', ')) }
        else { Add-Result 'R33/9 revalidação' 'ok' $(if ($isGit) { 'git: nenhuma mudança sem revalidação' } else { 'sem git: planos de Task conferidos' }) }
    }

    if ($it[10].Count) { Add-Result $labels[10] 'falhou' ($it[10] -join '; ') }
    else {
        $pr = @($fids | Where-Object { $rows[$_].Estado -match '(?i)promovida' })
        Add-Result $labels[10] $(if ($pr.Count) { 'ok' } else { 'n-a' }) $(if ($pr.Count) { 'com motivo: ' + ($pr -join ', ') } else { 'nenhuma promovida' })
    }

    # Indicadores (informativos, para a retrospectiva)
    $closed = @($allRows | Where-Object { $_.Estado -match '(?i)fechada' }).Count
    $promo = @($allRows | Where-Object { $_.Estado -match '(?i)promovida' }).Count
    $reop = @($allRows | Where-Object { $_.Estado -match '(?i)reaberta' -or -not (Test-Placeholder $_.Reaberta) }).Count
    $blocks = @($allRows | Where-Object { $_.Bloco -match '^B-\d+$' } | Group-Object Bloco)
    $avg = if ($blocks.Count) { [Math]::Round((($blocks | ForEach-Object { $_.Count }) | Measure-Object -Average).Average, 1) } else { 0 }
    $rate = { param($a, $b) if ($b -gt 0) { [Math]::Round(100.0 * $a / $b) } else { 0 } }
    Add-Result 'indicadores' 'info' ("promoção $(& $rate $promo ($closed + $promo))% · reabertura $(& $rate $reop $closed)% · tamanho médio do bloco $avg")

    Write-Results "C4 · $Block"
    $bad = @($noClose.Keys | Sort-Object)
    if ($bad.Count -or $tetoIss.Count) {
        [Console]::Out.WriteLine('')
        if ($bad.Count) { [Console]::Out.WriteLine('**Não fecham:** ' + (($bad | ForEach-Object { "$_ (" + (($noClose[$_] | Select-Object -Unique) -join ', ') + ')' }) -join ', ')) }
        if ($tetoIss.Count) { [Console]::Out.WriteLine('**Bloco acima do teto.**') }
        exit 1
    }
    exit 0
} catch {
    [Console]::Error.WriteLine("C4: erro — $($_.Exception.Message)")
    exit 2
}
