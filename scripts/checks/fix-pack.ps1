# Plano externo na trilha fix (v3.53.4): com guards.json → "run": { "planner": "external" }, o mini-plano do bloco sai do
# Claude, como o plano da Task no sprint run (external-plan.ps1, de onde vêm o estado, o zip e a cópia dos arquivos).
# Uso (raiz do projeto): powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/fix-pack.ps1" -Block B-007 [-Gap F-012] [-Fids F-012,F-015]
#   sem -Gap  /sm fix plan, passo 4 (e de novo depois do retorno): lê fixes/B-<nnn>/pack/in/, confere o que voltou com
#             o fix.ps1 -PlanOnly e: plano aceito → exit 0 (o passo 5 segue) · ainda fora ou reprovado → monta o pacote
#             (ou o de correção) em pack/out/ e sai com exit 3. No fix run, o mesmo comando lê a decisão de um 🔺 GAP.
#   -Gap      /sm fix run: o 🔺 GAP da F-ID vai num pacote (F-<nnn>-gap.zip); a F-ID espera, as outras seguem. Exit 0.
#   -Fids     as F-IDs do bloco, se o fixes.md ainda não as tem na coluna Bloco.
# Exit 2 = erro de uso (inclusive planner que não é external: o passo segue com o Arquiteto).

param(
    [Parameter(Mandatory = $true)][string]$Block,
    [string]$Gap = '',
    [string[]]$Fids = @(),
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
. (Join-Path $PSScriptRoot 'external-plan.ps1')
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8 = New-Object System.Text.UTF8Encoding($false)
function Out([string]$s) { [Console]::Out.WriteLine($s) }
function Invoke-Child([string]$Script, [string[]]$ArgList) {
    $ErrorActionPreference = 'Continue'
    $o = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot $Script) @ArgList 2>&1 | Out-String
    return @{ Code = $LASTEXITCODE; Out = $o }
}
function Add-FixLog([string]$Item, [string]$Decision, [string]$Why, [string]$Evidence) {
    $p = Join-Path $S 'run-log.md'
    if (-not (Test-Path -LiteralPath $p)) { [System.IO.File]::WriteAllText($p, "# Registro de decisões do run — $Block`n> DOCUMENTO VIVO até o fechamento do bloco · Dono: SM · Escritores: a sessão que orquestra e o executor de Task (só as linhas da F-ID dele)`n`n| Quando | Item | Decisão | Porquê | Evidência |`n|---|---|---|---|---|`n", $utf8) }
    $cell = { param($x) $t = (([string]$x -replace '\|', '/') -replace '\s+', ' ').Trim(); if ($t.Length -gt 160) { $t.Substring(0, 160) + '…' } else { $t } }
    [System.IO.File]::AppendAllText($p, "| $(Get-Date -Format 'yyyy-MM-dd HH:mm') | $Item | $(& $cell $Decision) | $(& $cell $Why) | $(& $cell $Evidence) |`n", $utf8)
}
# Seção "## F-<nnn>" de um texto (até o próximo "## "), ou $null.
function Get-FSec([string]$Text, [string]$F) {
    if (-not $Text) { return $null }
    $m = [regex]::Match($Text, '(?ms)^##\s+' + [regex]::Escape($F) + '\b.*?(?=^##\s|\z)')
    if ($m.Success) { return $m } else { return $null }
}
function Get-Pending {
    $readme = Read-Text (Join-Path $tp 'README.md')
    $pm = [regex]::Match($readme, '\*\*Diretório de produto:\*\*\s*`?([^`\s]+)`?')
    $productDir = Join-Path $Root $(if ($pm.Success -and $pm.Groups[1].Value -notmatch '<') { $pm.Groups[1].Value } else { 'docs/' })
    return @(@($productDir, $tp) | Where-Object { Test-Path -LiteralPath $_ } | ForEach-Object { Get-ChildItem -LiteralPath $_ -Recurse -Filter 'pending.md' -File -ErrorAction SilentlyContinue } | Select-Object -First 1)
}

# Pacote do bloco ('block'; Round > 1 = correção) ou da decisão de um 🔺 GAP ('gap').
function New-FixPack([string[]]$Ids, [int]$Round, [string]$Kind, [string]$GapLine = '') {
    $pk = Get-PackDir; $outDir = Join-Path $pk 'out'; New-Item -ItemType Directory -Force $outDir | Out-Null
    $name = if ($Kind -eq 'gap') { "$($Ids[0])-gap" + $(if ($Round -gt 1) { $Round } else { '' }) } else { $Block + $(if ($Round -gt 1) { "-fix$($Round - 1)" } else { '' }) }
    $dir = Join-Path $outDir $name
    if (Test-Path -LiteralPath $dir) { Remove-Item -LiteralPath $dir -Recurse -Force }
    New-Item -ItemType Directory -Force $dir | Out-Null
    $plug = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
    $copied = @{}; $rows = @('| F-ID | Tipo | Título |', '|---|---|---|')
    foreach ($F in $Ids) {
        $cp = Join-Path $tp "fixes/$F.md"; $card = if (Test-Path -LiteralPath $cp) { Read-Text $cp } else { '' }
        if ($card) { New-Item -ItemType Directory -Force (Join-Path $dir 'fixes') | Out-Null; [System.IO.File]::WriteAllText((Join-Path $dir "fixes/$F.md"), $card, $utf8) }
        $tipo = ([regex]::Match($card, '(?m)^\*\*Tipo:\*\*\s*(\S+)')).Groups[1].Value
        $tit = ([regex]::Match($card, '(?m)^#\s+(.+)$')).Groups[1].Value -replace '\|', '/'
        $rows += "| $F | $(if ($tipo) { $tipo } else { '—' }) | $(if ($tit) { $tit.Trim() } else { '—' }) |"
        foreach ($m in [regex]::Matches($card, '`?([\w.\-/\\]+\.[A-Za-z0-9]{1,8}):\d+')) { $r = ($m.Groups[1].Value -replace '\\', '/') -replace '^\./', ''; if (-not $copied.ContainsKey($r)) { $copied[$r] = Copy-PackFile $r $dir } }
    }
    $ctx = Join-Path $dir 'context'; New-Item -ItemType Directory -Force $ctx | Out-Null
    Copy-Item -LiteralPath (Join-Path $plug 'roles/architect/templates/fix-plan.md') -Destination (Join-Path $ctx 'fix-plan.md') -Force
    foreach ($pair in @(@('.team-project/developer/context.md', 'developer-context.md'), @('.team-project/architect/context.md', 'architect-context.md'), @('.team-project/quality-assurance/scenarios/fix.scn', 'scenarios/fix.scn'))) {
        $src = Join-Path $Root $pair[0]; if (Test-Path -LiteralPath $src) { $to = Join-Path $ctx $pair[1]; New-Item -ItemType Directory -Force (Split-Path $to) | Out-Null; Copy-Item -LiteralPath $src -Destination $to -Force }
    }
    $pf = Get-Pending; if ($pf.Count) { Copy-Item -LiteralPath $pf[0].FullName -Destination (Join-Path $ctx 'pending.md') -Force }
    # review/: o plano reprovado e a tabela do fix.ps1 (correção) · a seção atual, o relatório e o veredito da F-ID (GAP).
    $rvSrc = Join-Path $pk 'review'; $rv = Join-Path $dir 'review'
    $put = { param($text, $file) if ($text) { New-Item -ItemType Directory -Force $rv | Out-Null; [System.IO.File]::WriteAllText((Join-Path $rv $file), $text, $utf8) } }
    $planP = Join-Path $S 'plan.md'
    if ($Kind -eq 'gap') {
        $F = $Ids[0]
        $sec = if ($Round -gt 1 -and (Test-Path -LiteralPath (Join-Path $rvSrc "$F-plan.md"))) { Read-Text (Join-Path $rvSrc "$F-plan.md") } else { $m = Get-FSec $(if (Test-Path -LiteralPath $planP) { Read-Text $planP }) $F; if ($m) { $m.Value } }
        & $put $sec "$F-plan.md"
        if ($Round -gt 1 -and (Test-Path -LiteralPath (Join-Path $rvSrc "$F-check.txt"))) { & $put (Read-Text (Join-Path $rvSrc "$F-check.txt")) "$F-check.txt" }
        $dv = Join-Path $S 'delivery.md'; if (Test-Path -LiteralPath $dv) { & $put (@([regex]::Matches((Read-Text $dv), '(?ms)^##\s+' + [regex]::Escape($F) + '\b.*?(?=^##\s|\z)') | ForEach-Object { $_.Value }) -join "`n") "$F-delivery.md" }
        $vd = Join-Path $S 'verdict.md'; if (Test-Path -LiteralPath $vd) { $vm = [regex]::Match((Read-Text $vd), '(?ms)^##\s+QA\s+[—-]\s+' + [regex]::Escape($F) + '\b.*?(?=^##\s|\z)'); if ($vm.Success) { & $put $vm.Value "$F-verdict.md" } }
    } elseif ($Round -gt 1) {
        foreach ($f in "$Block-plan.md", "$Block-check.txt") { if (Test-Path -LiteralPath (Join-Path $rvSrc $f)) { & $put (Read-Text (Join-Path $rvSrc $f)) $f } }
    }
    $readme = Read-Text (Join-Path $tp 'README.md'); $nN = 5; $cap = 5
    $nv = Get-LabelValue $readme 'Limite de arquivos por Correção'; if ($nv) { $mm = [regex]::Match($nv, '\d+'); if ($mm.Success) { $nN = [int]$mm.Value } }
    $tv = Get-LabelValue $readme 'Teto de Correções por bloco'; if ($tv) { $mm = [regex]::Match($tv, '\d+'); if ($mm.Success) { $cap = [int]$mm.Value } }
    $retFile = if ($Kind -eq 'gap') { "$($Ids[0])-plan.md" } else { "$Block-plan.md" }
    $title = if ($Kind -eq 'gap') { "decisão do 🔺 GAP da $($Ids[0]) · bloco $Block" } else { "bloco $Block" }
    if ($Round -gt 1) { $title += " · correção $($Round - 1)" }
    $roundTxt = ''
    if ($Kind -eq 'gap') {
        $roundTxt = "## Decisão de 🔺 GAP`n`nO desenvolvedor parou a $($Ids[0]) com a dúvida abaixo. Em ``review/`` estão o mini-plano $(if ($Round -gt 1) { 'que voltou reprovado' } else { 'atual' }) da Correção (``$($Ids[0])-plan.md``), o relatório do dev (``$($Ids[0])-delivery.md``) e, se houver, o veredito do QA$(if ($Round -gt 1) { ' e a tabela do ``fix.ps1 -PlanOnly`` (``' + $Ids[0] + '-check.txt``)' }). Decida e registre a decisão **no passo que ela altera**, com ``(GAP $(Get-Date -Format 'dd/MM/yyyy'): <decisão>)`` (regra 13 do modelo); arquivo novo entra em ``### Arquivos``. Decisão que quebra C5–C8 é promoção (``**Critério que caiu:**``), não passo novo. **Devolva só a seção ``## $($Ids[0]) · …`` inteira**, no arquivo ``$retFile`` — o resto do bloco não muda.`n`n> $(if ($GapLine) { $GapLine } else { '(o GAP está no fim do relatório do dev)' })`n"
    } elseif ($Round -gt 1) {
        $roundTxt = "## Correção (rodada $Round)`n`nO plano do bloco voltou reprovado. Em ``review/`` estão o plano devolvido (``$Block-plan.md``) e a tabela do ``fix.ps1 -PlanOnly`` (``$Block-check.txt``): corrija só as linhas ``falhou`` e devolva o plano inteiro, com o mesmo nome.`n"
    }
    $tpl = Read-Text (Join-Path $plug 'roles/architect/templates/external-fix-plan.md')
    $ins = $tpl.Replace('{{TITLE}}', $title).Replace('{{BLOCK}}', $Block).Replace('{{RETURN_FILE}}', $retFile).Replace('{{RETURN_ZIP}}', "$name-return.zip").Replace('{{ROUND}}', $roundTxt).Replace('{{FIXES}}', ($rows -join "`n")).Replace('{{N2}}', [string](2 * $nN)).Replace('{{N}}', [string]$nN).Replace('{{CAP}}', [string]$cap)
    [System.IO.File]::WriteAllText((Join-Path $dir 'INSTRUCTIONS.md'), $ins, $utf8)
    $zip = Join-Path $outDir "$name.zip"; New-ZipFromDir $dir $zip
    return [pscustomobject]@{ Name = $name; Kb = [Math]::Round((Get-Item -LiteralPath $zip).Length / 1024) }
}
function Write-FixWait([string[]]$Lines) {
    Out "PRÓXIMA AÇÃO: external plan — com o stakeholder"
    foreach ($l in $Lines) { Out $l }
    Out "  depois: rode de novo o modo em que você está (/sm fix plan ou /sm fix run) — o fix-pack.ps1 lê pack/in/, confere com o fix.ps1 -PlanOnly e segue"
    Out "  sessão: encerre o turno e passe estas linhas ao stakeholder, sem formulário (não é decisão)"
}
function Get-WaitLine([string]$Label, [string]$Name) { return "  • ${Label}: pegue .team-project/fixes/$Block/pack/out/$Name.zip (chat na web) ou a pasta .team-project/fixes/$Block/pack/out/$Name/ (app do Codex) e peça `"siga o INSTRUCTIONS.md`"; devolva o $Name-return.zip (ou o .md solto) em .team-project/fixes/$Block/pack/in/" }

try {
    if ($Block -notmatch '^B-\d+$') { [Console]::Error.WriteLine("fix-pack: -Block deve ser B-<nnn> (recebido: $Block)."); exit 2 }
    $tp = Join-Path $Root '.team-project'; $S = Join-Path $tp "fixes/$Block"
    if (-not (Test-Path -LiteralPath $S)) { [Console]::Error.WriteLine("fix-pack: .team-project/fixes/$Block não existe — o /sm fix plan a cria no passo 2 (kanban.ps1 -Block $Block -Init)."); exit 2 }
    $ids = @($Fids | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^F-\d+$' })
    if (-not $ids.Count) {
        $idxP = Join-Path $tp 'fixes.md'
        if (Test-Path -LiteralPath $idxP) { $cor = Get-Section (Read-Text $idxP) '^##\s+Corre[çc][õo]es'; if ($cor) { foreach ($t in (Get-Tables $cor)) { $ib = Find-Col $t 'Bloco'; $ie = Find-Col $t 'Estado'; foreach ($row in $t.Rows) { $fid = ([regex]::Match($row[0], 'F-\d+')).Value; if ($fid -and (Clean-Cell (Get-Cell $row $ib)) -eq $Block -and (Clean-Cell (Get-Cell $row $ie)) -notmatch '(?i)devolvida|promovida') { $ids += $fid } } } } }
    }
    $ids = @($ids | Select-Object -Unique)
    $planner = Get-RunPlanner $Root
    if (-not $planner -or -not @(@($Block) + $ids | Where-Object { Test-ExternalTask $planner $_ }).Count) { [Console]::Error.WriteLine("fix-pack: o guards.json não manda $Block ao plano externo (run.planner external, com o bloco ou uma F-ID em run.tasks, ou run.tasks vazio) — o passo segue com o Arquiteto."); exit 2 }
    $planP = Join-Path $S 'plan.md'
    $st = Get-PackState

    if ($Gap) {
        if ($Gap -notmatch '^F-\d+$' -or -not (Test-Path -LiteralPath $planP) -or -not (Get-FSec (Read-Text $planP) $Gap)) { [Console]::Error.WriteLine("fix-pack -Gap: $Gap sem seção no fixes/$Block/plan.md."); exit 2 }
        $dv = Join-Path $S 'delivery.md'
        $gl = @(if (Test-Path -LiteralPath $dv) { @([regex]::Matches((Read-Text $dv), '(?ms)^##\s+' + [regex]::Escape($Gap) + '\b.*?(?=^##\s|\z)') | ForEach-Object { [regex]::Matches($_.Value, '(?m)^.*🔺.*$') } | ForEach-Object { $_.Value.Trim() } | Select-Object -Last 1) })
        $gline = if ($gl.Count) { $gl[0] -replace '^[#>*\-\s]+', '' } else { '' }
        $g = if ($st.gaps.ContainsKey($Gap)) { $st.gaps[$Gap] } else { $null }
        $round = if ($g -and $g.fix) { $g.round + 1 } else { 1 }
        $pack = New-FixPack @($Gap) $round 'gap' $gline
        $st.gaps[$Gap] = @{ name = $pack.Name; round = $round; gap = $gline; fix = $false; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
        Save-PackState $st
        Add-FixLog $Gap "🔺 GAP → external plan: pacote $($pack.Name) com o stakeholder; a F-ID espera a decisão, as outras seguem" $(if ($gline) { $gline } else { 'GAP no relatório do dev' }) "fixes/$Block/pack/out/$($pack.Name).zip"
        Out "fix-pack: $Gap com 🔺 GAP — a decisão vai ao plano externo, não ao Arquiteto Opus: pacote .team-project/fixes/$Block/pack/out/$($pack.Name).zip (a pasta ao lado, para o app do Codex)."
        Out "  executor: não dispare Arquiteto nem dev. Devolva à sessão a linha `"$Gap 🔺 GAP → external plan $($pack.Name)`" — a sessão segue as outras F-IDs; a desta volta quando o fix-pack.ps1 -Block $Block aceitar a decisão."
        exit 0
    }

    # Retorno em pack/in/: o plano do bloco (B-<nnn>-plan.md) ou a seção de uma F-ID com GAP (F-<nnn>-plan.md).
    $pk = Get-PackDir; $in = Join-Path $pk 'in'; $rvDir = Join-Path $pk 'review'
    $reB = '^' + [regex]::Escape($Block) + '-(?i:plan)(?:\s*\(\d+\))?\.(?i:md)$'
    $reF = '^(F-\d+)-(?i:plan)(?:\s*\(\d+\))?\.(?i:md)$'
    $files = @(if (Test-Path -LiteralPath $in) { Get-ChildItem -LiteralPath $in -File | Sort-Object LastWriteTime })
    if ($files.Count) { New-Item -ItemType Directory -Force (Join-Path $pk 'done'), $rvDir | Out-Null }
    $check = { $r = Invoke-Child 'fix.ps1' @('-Block', $Block, '-PlanOnly', '-Root', $Root); $bad = @($r.Out -split "`r?`n" | Where-Object { $_ -match '^\|\s*([^|]+?)\s*\|\s*falhou\s*\|' } | ForEach-Object { [regex]::Match($_, '^\|\s*([^|]+?)\s*\|').Groups[1].Value }); @{ Code = $r.Code; Out = $r.Out; Bad = $(if ($bad.Count) { $bad -join ', ' } else { 'fix.ps1 reprovou' }) } }
    foreach ($f in $files) {
        $items = @(); $ignored = @()
        if ($f.Extension -ieq '.zip') {
            try {
                $za = [System.IO.Compression.ZipFile]::OpenRead($f.FullName)
                try { foreach ($en in $za.Entries) { if (-not $en.Name -or $en.FullName -match '(^|/)__MACOSX/') { continue }; if ([regex]::IsMatch($en.Name, $reB) -or [regex]::IsMatch($en.Name, $reF)) { $sr = New-Object System.IO.StreamReader($en.Open(), $utf8, $true); try { $items += @{ Name = $en.Name; Text = $sr.ReadToEnd() } } finally { $sr.Dispose() } } else { $ignored += $en.FullName } } }
                finally { $za.Dispose() }
            } catch { Out "  external plan: $($f.Name) não abriu como zip ($($_.Exception.Message)) — foi para pack/done/ sem efeito" }
        } elseif ([regex]::IsMatch($f.Name, $reB) -or [regex]::IsMatch($f.Name, $reF)) { $items += @{ Name = $f.Name; Text = (Read-Text $f.FullName) } }
        else { $ignored += $f.Name }
        foreach ($it in $items) {
            $text = ([string]$it.Text).TrimStart([char]0xFEFF)
            if ([regex]::IsMatch($it.Name, $reB)) {
                if (Test-Path -LiteralPath $planP) { Out "  external plan: $($it.Name) recusado — o bloco $Block já tem plano; mini-plano de F-ID planejada só muda pela decisão de um 🔺 GAP"; continue }
                [System.IO.File]::WriteAllText($planP, $text, $utf8)
                $c = & $check
                if ($c.Code -eq 0) {
                    Remove-Item -LiteralPath (Join-Path $rvDir "$Block-plan.md"), (Join-Path $rvDir "$Block-check.txt") -Force -ErrorAction SilentlyContinue
                    if ($st.packs.ContainsKey($Block)) { $st.packs[$Block].rejected = @() }
                    Add-FixLog $Block 'external plan aceito (fix.ps1 -PlanOnly ok)' 'mini-planos escritos fora do Claude pelo pacote (guards.json → run.planner external)' "fixes/$Block/plan.md"
                    Out "  external plan: plano do bloco $Block aceito (fix.ps1 -PlanOnly ok) → .team-project/fixes/$Block/plan.md"
                } else {
                    [System.IO.File]::WriteAllText((Join-Path $rvDir "$Block-plan.md"), $text, $utf8); [System.IO.File]::WriteAllText((Join-Path $rvDir "$Block-check.txt"), $c.Out, $utf8)
                    Remove-Item -LiteralPath $planP -Force
                    if (-not $st.packs.ContainsKey($Block)) { $st.packs[$Block] = @{ name = ''; round = 1; tasks = $ids; rejected = @(); at = '' } }
                    $st.packs[$Block].rejected = @($Block)
                    Add-FixLog $Block "external plan reprovado pelo fix.ps1 -PlanOnly ($($c.Bad)) → pacote de correção" 'o plano de fora só entra no bloco depois da conferência' "fixes/$Block/pack/review/$Block-check.txt"
                    Out "  external plan: plano do bloco $Block reprovado pelo fix.ps1 -PlanOnly ($($c.Bad)) — volta num pacote de correção, com a tabela"
                }
                continue
            }
            $fid = [regex]::Match($it.Name, $reF).Groups[1].Value
            if (-not $st.gaps.ContainsKey($fid)) { Out "  external plan: $($it.Name) recusado — a $fid não tem 🔺 GAP no plano externo"; continue }
            $ns = Get-FSec $text $fid
            if (-not $ns) { Out "  external plan: $($it.Name) recusado — sem a seção ## $fid"; continue }
            $before = Read-Text $planP; $os = Get-FSec $before $fid
            $sec = $ns.Value.TrimEnd() + "`n`n"
            [System.IO.File]::WriteAllText($planP, $before.Substring(0, $os.Index) + $sec + $before.Substring($os.Index + $os.Length), $utf8)
            $c = & $check
            if ($c.Code -eq 0) {
                $st.gaps.Remove($fid)
                Remove-Item -LiteralPath (Join-Path $rvDir "$fid-plan.md"), (Join-Path $rvDir "$fid-check.txt") -Force -ErrorAction SilentlyContinue
                Add-FixLog $fid 'external plan: decisão do 🔺 GAP no mini-plano (fix.ps1 -PlanOnly ok) → executor novo da F-ID' 'o GAP foi decidido fora do Claude (guards.json → run.planner external)' "fixes/$Block/plan.md"
                Out "  external plan: $fid — decisão do 🔺 GAP aceita (fix.ps1 -PlanOnly ok); a sessão dispara um executor de Task novo para ela"
            } else {
                [System.IO.File]::WriteAllText($planP, $before, $utf8)
                [System.IO.File]::WriteAllText((Join-Path $rvDir "$fid-plan.md"), $ns.Value, $utf8); [System.IO.File]::WriteAllText((Join-Path $rvDir "$fid-check.txt"), $c.Out, $utf8)
                $st.gaps[$fid].fix = $true
                Add-FixLog $fid "external plan: decisão do 🔺 GAP reprovada pelo fix.ps1 -PlanOnly ($($c.Bad)) → pacote de correção" 'o plano de fora só entra no bloco depois da conferência' "fixes/$Block/pack/review/$fid-check.txt"
                Out "  external plan: $fid — decisão do 🔺 GAP reprovada pelo fix.ps1 -PlanOnly ($($c.Bad)) — volta num pacote de correção"
            }
        }
        if ($ignored.Count) { Out "  external plan: ignorado em $($f.Name) (nada entra no projeto): $((@($ignored) | Select-Object -First 5) -join ', ')$(if ($ignored.Count -gt 5) { " e mais $($ignored.Count - 5)" })" }
        Move-Item -LiteralPath $f.FullName -Destination (Join-Path (Join-Path $pk 'done') "$(Get-Date -Format 'yyyyMMdd-HHmmss')-$($f.Name)") -Force
    }
    Save-PackState $st

    $wait = @()
    foreach ($gid in @($st.gaps.Keys | Sort-Object)) {
        $g = $st.gaps[$gid]
        if ($g.fix) { $round = $g.round + 1; $pack = New-FixPack @($gid) $round 'gap' $g.gap; $st.gaps[$gid] = @{ name = $pack.Name; round = $round; gap = $g.gap; fix = $false; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }; Out "  external plan: pacote de correção da decisão do 🔺 GAP da $gid gerado" }
        $wait += Get-WaitLine "decisão do 🔺 GAP da $gid (as outras F-IDs seguem)" $st.gaps[$gid].name
    }
    if (-not (Test-Path -LiteralPath $planP)) {
        if (-not $ids.Count) { Save-PackState $st; [Console]::Error.WriteLine("fix-pack: nenhuma F-ID do $Block no fixes.md (coluna Bloco) — passe -Fids F-012,F-015."); exit 2 }
        $p = if ($st.packs.ContainsKey($Block)) { $st.packs[$Block] } else { $null }
        $pending = $p -and $p.name -and -not @($p.rejected).Count -and (Test-Path -LiteralPath (Join-Path $pk "out/$($p.name).zip"))
        if ($pending) { Out "  external plan: aguardando o retorno do plano do bloco $Block (pacote $($p.name))" }
        else {
            $round = if ($p -and $p.name) { $p.round + 1 } else { 1 }
            $pack = New-FixPack $ids $round 'block'
            $st.packs[$Block] = @{ name = $pack.Name; round = $round; tasks = $ids; rejected = @(); at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
            Add-FixLog $Block "external plan: pacote $($pack.Name) gerado ($(if ($round -gt 1) { "correção $($round - 1)" } else { 'primeiro' })) — com o stakeholder" 'guards.json → run.planner external: o mini-plano sai do Claude; o fix.ps1 -PlanOnly confere na volta' "fixes/$Block/pack/out/$($pack.Name).zip"
            Out "  external plan: pacote $($pack.Name) gerado ($($ids -join ', '); $($pack.Kb) KB)"
        }
        $wait = @(Get-WaitLine "mini-planos do bloco $Block ($($ids -join ', '))" $st.packs[$Block].name) + $wait
    }
    Save-PackState $st
    if ($wait.Count) { Write-FixWait $wait; exit 3 }
    $plan = Read-Text $planP
    $promo = @([regex]::Matches($plan, '(?ms)^##\s+(F-\d+)\b.*?(?=^##\s|\z)') | ForEach-Object { $cm = [regex]::Match($_.Value, '\*\*Crit[ée]rio que caiu:\*\*\s*(C[1-8]\s*[—-]\s*[^\r\n]+)'); if ($cm.Success) { "$($_.Groups[1].Value) ($($cm.Groups[1].Value.Trim()))" } })
    $devol = @([regex]::Matches($plan, '(?m)^\*\*Devolvida:\*\*\s*(F-\d+\s*[—-]\s*[^\r\n]+)') | ForEach-Object { $_.Groups[1].Value.Trim() })
    Out "fix-pack: o plano do bloco $Block está aceito e nada espera o stakeholder — siga o roteiro (fix plan: passo 5, o resumo; fix run: o executor da F-ID)."
    if ($promo.Count) { Out "  promovida(s) no plano: $($promo -join '; ') — a sessão segue o §Promoção" }
    if ($devol.Count) { Out "  devolvida(s) à fila: $($devol -join '; ') — a sessão as volta a triada no fixes.md" }
    exit 0
} catch {
    [Console]::Error.WriteLine("fix-pack: erro — $($_.Exception.Message) (linha $($_.InvocationInfo.ScriptLineNumber))")
    exit 2
}
