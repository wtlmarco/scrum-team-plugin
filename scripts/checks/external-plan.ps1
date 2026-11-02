# Plano externo (v3.53.4): funções do run.ps1 (dot-source) para planejar fora do Claude. Com guards.json →
# "run": { "planner": "external", "tasks": [] }, o run.ps1 next não dispara o Arquiteto Opus para a Task com ficha: monta
# um pacote por História em sprints/<n>/pack/out/ (roteiro INSTRUCTIONS.md, fichas, modelo do plano, contexto e os
# arquivos que a ficha aponta), o stakeholder o leva a um assistente de fora (app do Codex, chat na web) e devolve os
# planos em pack/in/. O next seguinte lê o retorno, roda o plan.ps1 em cada plano e só então o aceita (coluna Plano do
# quadro); reprovado volta num pacote de correção. O 🔺 GAP de plano da Task também vai num pacote (run.ps1 done).
# Origem: sprint 5 do garden — o plano do Arquiteto foi ~2/3 do custo do sprint; o pedido do stakeholder era tirar do
# limite da conta o trabalho que mais pesa, mantendo as conferências (plan.ps1, verify, accept, close) iguais.
# Usa as variáveis do run.ps1: $Root, $S, $n, $tasks, $utf8.

Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem

function Get-PackDir { return (Join-Path $S 'pack') }

# Estado do que está fora: packs[História] = { name, round, tasks, rejected, at } · gaps[T-ID] = { name, round, gap, fix, at }.
function Get-PackState {
    $p = Join-Path (Get-PackDir) 'state.json'; $st = @{ packs = @{}; gaps = @{} }
    if (-not (Test-Path -LiteralPath $p)) { return $st }
    try { $j = Read-Text $p | ConvertFrom-Json } catch { return $st }
    if ($j.packs) { foreach ($k in $j.packs.PSObject.Properties) { $v = $k.Value; $st.packs[$k.Name] = @{ name = [string]$v.name; round = [int]$v.round; tasks = @($v.tasks | ForEach-Object { [string]$_ }); rejected = @($v.rejected | ForEach-Object { [string]$_ }); at = [string]$v.at } } }
    if ($j.gaps) { foreach ($k in $j.gaps.PSObject.Properties) { $v = $k.Value; $st.gaps[$k.Name] = @{ name = [string]$v.name; round = [int]$v.round; gap = [string]$v.gap; fix = [bool]$v.fix; at = [string]$v.at } } }
    return $st
}
function Save-PackState($St) {
    $o = [ordered]@{ packs = [ordered]@{}; gaps = [ordered]@{} }
    foreach ($k in @($St.packs.Keys | Sort-Object)) { $v = $St.packs[$k]; $o.packs[$k] = [ordered]@{ name = $v.name; round = $v.round; tasks = @($v.tasks); rejected = @($v.rejected); at = $v.at } }
    foreach ($k in @($St.gaps.Keys | Sort-Object)) { $v = $St.gaps[$k]; $o.gaps[$k] = [ordered]@{ name = $v.name; round = $v.round; gap = $v.gap; fix = [bool]$v.fix; at = $v.at } }
    $d = Get-PackDir; New-Item -ItemType Directory -Force $d | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $d 'state.json'), ($o | ConvertTo-Json -Depth 6), $utf8)
}

function ConvertTo-Slug([string]$Text) {
    $d = $Text.Normalize([System.Text.NormalizationForm]::FormD); $sb = New-Object System.Text.StringBuilder
    foreach ($c in $d.ToCharArray()) { if ([System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($c) -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) { [void]$sb.Append($c) } }
    $s = ($sb.ToString().ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
    if ($s.Length -gt 40) { $s = $s.Substring(0, 40).Trim('-') }
    if (-not $s) { $s = 'plano' }
    return $s
}

# Linha da Task no quadro (tabelas com cabeçalho "ID"): índice, células e a coluna Plano. $null se não achar.
function Find-BoardRow([string[]]$Lines, [string]$Id) {
    $header = $null
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $line = $Lines[$i]
        if (-not $line.TrimStart().StartsWith('|')) { $header = $null; continue }
        $cells = @(Split-Row $line)
        if ((Clean-Cell $cells[0]) -eq 'ID') { $header = @($cells | ForEach-Object { Clean-Cell $_ }); continue }
        if (-not $header) { continue }
        $m = [regex]::Match($cells[0], $script:TaskIdRe)
        if ($m.Success -and $m.Value -eq $Id) {
            $pc = -1; for ($k = 0; $k -lt $header.Count; $k++) { if ($header[$k] -like '*Plano*') { $pc = $k; break } }
            return @{ Index = $i; Cells = $cells; PlanCol = $pc }
        }
    }
    return $null
}
# Onde o plano aceito vai: o nome que a Planning já pôs na coluna Plano (`plan/T-045-x.md`), senão plan/<T-ID>-<slug>.md.
function Get-PlanDest($T) {
    $bp = Join-Path $S 'sprint-backlog.md'
    $row = Find-BoardRow @((Read-Text $bp) -split "`r?`n") $T.Id
    if ($row -and $row.PlanCol -ge 0 -and $row.PlanCol -lt $row.Cells.Count) {
        $m = [regex]::Match($row.Cells[$row.PlanCol], '`(plan/' + [regex]::Escape($T.Id) + '(?:[-_.][^`/]*)?\.md)`')
        if ($m.Success) { return $m.Groups[1].Value }
    }
    return "plan/$($T.Id)-$(ConvertTo-Slug $T.Title).md"
}
# Grava o link do plano na coluna Plano da Task (o que a sessão faz à mão depois do Arquiteto).
function Set-BoardPlan([string]$Id, [string]$Rel) {
    $bp = Join-Path $S 'sprint-backlog.md'
    return (Invoke-WithFileLock $bp {
        $txt = Read-Text $bp; $nl = if ($txt -match "`r`n") { "`r`n" } else { "`n" }
        $lines = @($txt -split "`r?`n")
        $row = Find-BoardRow $lines $Id
        if (-not $row -or $row.PlanCol -lt 0) { return $false }
        $c = @($row.Cells); while ($c.Count -le $row.PlanCol) { $c += '' }
        $c[$row.PlanCol] = "[``$Rel``]($Rel)"
        $lines[$row.Index] = '| ' + ($c -join ' | ') + ' |'
        [System.IO.File]::WriteAllText($bp, ($lines -join $nl), $utf8)
        return $true
    })
}

# Zip com "/" nos nomes (o Compress-Archive do 5.1 grava "\" e o zip abre torto fora do Windows).
function New-ZipFromDir([string]$Dir, [string]$Zip) {
    if (Test-Path -LiteralPath $Zip) { Remove-Item -LiteralPath $Zip -Force }
    $base = (Get-Item -LiteralPath $Dir).FullName.TrimEnd('\', '/')
    $fs = [System.IO.File]::Open($Zip, [System.IO.FileMode]::CreateNew)
    try {
        $za = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create)
        try { foreach ($f in @(Get-ChildItem -LiteralPath $base -Recurse -File)) { $null = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($za, $f.FullName, ($f.FullName.Substring($base.Length + 1) -replace '\\', '/')) } }
        finally { $za.Dispose() }
    } finally { $fs.Dispose() }
}

# Arquivo apontado pela ficha → files/<caminho do projeto> ou files/plugin/<caminho no plugin>. Devolve o caminho no pacote.
function Copy-PackFile([string]$Rel, [string]$Dir) {
    $src = Resolve-FichaPath $Root $Rel
    if (-not (Test-Path -LiteralPath $src -PathType Leaf)) { return $null }
    $dst = if ($Rel -match '^\$\{CLAUDE_PLUGIN_ROOT\}/(.+)$') { "files/plugin/$($Matches[1])" } elseif ($Rel -match '^standards/') { "files/plugin/$Rel" } else { "files/$Rel" }
    $to = Join-Path $Dir $dst; New-Item -ItemType Directory -Force (Split-Path $to) | Out-Null
    Copy-Item -LiteralPath $src -Destination $to -Force
    return $dst
}

# Ambiente medido neste sprint: a §3 do plano mais recente que a tem com tabela (o assistente de fora não roda comando).
function Get-SprintEnv {
    foreach ($f in @(Get-ChildItem -LiteralPath (Join-Path $S 'plan') -Filter '*.md' -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)) {
        $s3 = Get-Section (Read-Text $f.FullName) '^##\s+3\.'
        if ($s3 -and $s3 -match '(?i)Sa[íi]da real') { return @{ Src = "sprints/$n/plan/$($f.Name)"; Text = $s3.Trim() } }
    }
    return $null
}

# Monta o pacote: Kind 'story' (planos da História; Round > 1 = correção) ou 'gap' (decisão do 🔺 GAP de uma Task).
function New-PlanPack([string]$Story, $Items, [int]$Round, [string]$Kind = 'story', [string]$GapLine = '') {
    $pk = Get-PackDir; $outDir = Join-Path $pk 'out'; New-Item -ItemType Directory -Force $outDir | Out-Null
    $safe = ($Story -replace '[^\w.-]+', '-').Trim('-')
    $name = if ($Kind -eq 'gap') { "$($Items[0].Id)-gap" + $(if ($Round -gt 1) { $Round } else { '' }) } else { $safe + $(if ($Round -gt 1) { "-fix$($Round - 1)" } else { '' }) }
    $dir = Join-Path $outDir $name
    if (Test-Path -LiteralPath $dir) { Remove-Item -LiteralPath $dir -Recurse -Force }
    New-Item -ItemType Directory -Force $dir | Out-Null
    $plug = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
    $ids = @($Items | ForEach-Object { $_.Id })
    # Ordem: quem depende de outra Task do pacote vem depois dela.
    $order = @(); $left = @($Items)
    while ($left.Count) {
        $ok = @($left | Where-Object { $t = $_; -not @($t.Deps | Where-Object { $ids -contains $_ -and @($order | ForEach-Object { $_.Id }) -notcontains $_ }).Count })
        if (-not $ok.Count) { $ok = @($left[0]) }
        $order += $ok[0]; $left = @($left | Where-Object { $_.Id -ne $ok[0].Id })
    }
    $bdRel = ".team-project/architect/breakdown/S$n.md"; $scnIds = @(); $copied = @{}
    foreach ($t in $order) {
        $f = Get-Ficha $Root $n $t.Id
        $depSum = @($t.Deps | Where-Object { $ids -notcontains $_ } | ForEach-Object { $d = $_; $dt = @($tasks | Where-Object { $_.Id -eq $d }) | Select-Object -First 1; if ($dt) { $pf = Get-PlanFull $dt $S; if ($pf) { "## Plano da dependência — resumo de ``sprints/$n/$($dt.Plan)```n`n" + (Get-PlanSummary $pf) } } })
        $card = "# Ficha da $($t.Id) — $($t.Title)`n`n> Recorte de ``$bdRel`` (a quebra da Planning).`n`n" + $(if ($f -and $f.Common) { $f.Common + "`n`n" } else { '' }) + $(if ($f) { $f.Body } else { '(sem ficha)' }) + "`n" + $(if ($depSum.Count) { "`n" + ($depSum -join "`n`n") + "`n" } else { '' })
        $tf = Join-Path $dir "tasks/$($t.Id)-ficha.md"; New-Item -ItemType Directory -Force (Split-Path $tf) | Out-Null
        [System.IO.File]::WriteAllText($tf, $card, $utf8)
        if ($f) { foreach ($r in @(@($f.Read) + @($f.Sources) | Where-Object { $_ } | Select-Object -Unique)) { if (-not $copied.ContainsKey($r)) { $copied[$r] = Copy-PackFile $r $dir } } }
        $scnIds += @($t.Scenarios) + @($t.TestScenarios)
    }
    $ctx = Join-Path $dir 'context'; New-Item -ItemType Directory -Force $ctx | Out-Null
    Copy-Item -LiteralPath (Join-Path $plug 'roles/architect/templates/implementation-plan.md') -Destination (Join-Path $ctx 'implementation-plan.md') -Force
    $ac = Join-Path $Root '.team-project/architect/context.md'; if (Test-Path -LiteralPath $ac) { Copy-Item -LiteralPath $ac -Destination (Join-Path $ctx 'architect-context.md') -Force }
    $envSec = Get-SprintEnv
    if ($envSec) { [System.IO.File]::WriteAllText((Join-Path $ctx 'environment.md'), "# Ambiente medido neste sprint`n`n> Fonte: a §3 de ``$($envSec.Src)``. Copie para a §3 do plano as linhas que valem para a Task, com a fonte. Pré-requisito que não está aqui: premissa ``- P<k> · não exercitada: <motivo> · verifica: dev no passo 1`` — nunca uma saída inventada.`n`n$($envSec.Text)`n", $utf8) }
    $scnDir = Join-Path $Root '.team-project/quality-assurance/scenarios'
    foreach ($sf in @(Get-ChildItem -Path $scnDir -Filter '*.scn' -File -ErrorAction SilentlyContinue)) {
        $scnText = Read-Text $sf.FullName
        if ($sf.BaseName -eq $Story -or @($scnIds | Where-Object { $scnText -match ('(?m)^\s*scenario\s+' + [regex]::Escape($_) + '\b') }).Count) { New-Item -ItemType Directory -Force (Join-Path $ctx 'scenarios') | Out-Null; Copy-Item -LiteralPath $sf.FullName -Destination (Join-Path $ctx "scenarios/$($sf.Name)") -Force }
    }
    foreach ($sf in @(Get-ChildItem -Path (Join-Path $S 'stories') -Filter "$Story*.md" -File -ErrorAction SilentlyContinue)) { New-Item -ItemType Directory -Force (Join-Path $ctx 'stories') | Out-Null; Copy-Item -LiteralPath $sf.FullName -Destination (Join-Path $ctx "stories/$($sf.Name)") -Force }
    # review/: o plano reprovado e a tabela do plan.ps1 (correção) · o plano atual, o relatório e o diagnóstico (GAP).
    $rvSrc = Join-Path $pk 'review'; $rv = Join-Path $dir 'review'
    foreach ($t in $order) {
        $pairs = @()
        if ($Kind -eq 'gap') {
            $rej = Join-Path $rvSrc "$($t.Id)-plan.md"
            $cur = Get-PlanFull $t $S
            $pairs += ,@($(if ($Round -gt 1 -and (Test-Path -LiteralPath $rej)) { $rej } else { $cur }), "$($t.Id)-plan.md")
            if ($Round -gt 1) { $pairs += ,@((Join-Path $rvSrc "$($t.Id)-check.txt"), "$($t.Id)-check.txt") }
            $pairs += ,@((Join-Path $S "delivery/$($t.Id).md"), "$($t.Id)-delivery.md")
            $pairs += ,@((Join-Path $Root ".team-project/operator/$n/$($t.Id)-alvo/diagnostico.md"), "$($t.Id)-diagnostico.md")
        } elseif ($Round -gt 1) {
            $pairs += ,@((Join-Path $rvSrc "$($t.Id)-plan.md"), "$($t.Id)-plan.md")
            $pairs += ,@((Join-Path $rvSrc "$($t.Id)-check.txt"), "$($t.Id)-check.txt")
        }
        foreach ($pr in $pairs) { if ($pr[0] -and (Test-Path -LiteralPath $pr[0] -PathType Leaf)) { New-Item -ItemType Directory -Force $rv | Out-Null; Copy-Item -LiteralPath $pr[0] -Destination (Join-Path $rv $pr[1]) -Force } }
    }
    # INSTRUCTIONS.md pelo modelo do Arquiteto.
    $title = if ($Kind -eq 'gap') { "decisão do 🔺 GAP da $($ids[0]) · sprint $n" + $(if ($Round -gt 1) { " · correção $($Round - 1)" } else { '' }) } else { "História $Story · sprint $n" + $(if ($Round -gt 1) { " · correção $($Round - 1)" } else { '' }) }
    $files = ($order | ForEach-Object { "- ``$($_.Id)-plan.md`` — $($_.Title)" }) -join "`n"
    $rows = @('| Ordem | Task | Título | Depende de | Cenários |', '|---|---|---|---|---|')
    $k = 0; foreach ($t in $order) { $k++; $sc = @(@($t.Scenarios) + @($t.TestScenarios | ForEach-Object { "$_ (teste)" })); $rows += "| $k | $($t.Id) | $($t.Title -replace '\|', '/') | $(if ($t.Deps.Count) { $t.Deps -join ', ' } else { '—' }) | $(if ($sc.Count) { $sc -join ', ' } else { 'nenhum' }) |" }
    $roundTxt = ''
    if ($Kind -eq 'gap') {
        $roundTxt = "## Decisão de 🔺 GAP`n`nO desenvolvedor parou a $($ids[0]) com a dúvida de desenho abaixo. Em ``review/`` estão o plano $(if ($Round -gt 1) { 'que voltou reprovado' } else { 'atual' }) (``$($ids[0])-plan.md``), o relatório do dev (``$($ids[0])-delivery.md``)$(if ($Round -gt 1) { ', a tabela do ``plan.ps1`` (``' + $ids[0] + '-check.txt``)' }) e, se houver, o diagnóstico do alvo (``$($ids[0])-diagnostico.md``). Decida e **registre a decisão no próprio plano**: no passo afetado e numa linha ``**Decisão do GAP ($(Get-Date -Format 'dd/MM/yyyy')):** …`` no cabeçalho; se ela muda arquivos, atualize ``**Arquivos tocados:**``. Devolva o plano inteiro, com o mesmo nome. Não reescreva o que não muda.`n`n> $(if ($GapLine) { $GapLine } else { '(o GAP está no fim do relatório do dev)' })`n"
    } elseif ($Round -gt 1) {
        $roundTxt = "## Correção (rodada $Round)`n`nOs planos abaixo voltaram reprovados pela conferência. Em ``review/`` estão o plano devolvido (``<T-ID>-plan.md``) e a tabela do ``plan.ps1`` (``<T-ID>-check.txt``): corrija só as linhas ``falhou`` e devolva o plano inteiro, com o mesmo nome.`n"
    }
    $tpl = Read-Text (Join-Path $plug 'roles/architect/templates/external-plan.md')
    $ins = $tpl.Replace('{{TITLE}}', $title).Replace('{{SPRINT}}', $n).Replace('{{RETURN_FILES}}', $files).Replace('{{RETURN_ZIP}}', "$name-return.zip").Replace('{{ROUND}}', $roundTxt).Replace('{{TASKS}}', ($rows -join "`n"))
    [System.IO.File]::WriteAllText((Join-Path $dir 'INSTRUCTIONS.md'), $ins, $utf8)
    $zip = Join-Path $outDir "$name.zip"; New-ZipFromDir $dir $zip
    return [pscustomobject]@{ Name = $name; Tasks = @($order | ForEach-Object { $_.Id }); Round = $Round; Kb = [Math]::Round((Get-Item -LiteralPath $zip).Length / 1024) }
}

# Pacote da História no preparo: gera na primeira vez, gera a correção quando o retorno voltou reprovado, senão espera.
# Devolve { New; Name; Tasks; Round; Kb } (New = $false: o pacote já está fora, nada mudou).
function Update-StoryPack([string]$Story, $Items) {
    $st = Get-PackState; $pend = @($Items | ForEach-Object { $_.Id })
    $p = if ($st.packs.ContainsKey($Story)) { $st.packs[$Story] } else { $null }
    $rej = if ($p) { @($p.rejected | Where-Object { $pend -contains $_ }) } else { @() }
    $zipOk = [bool]($p -and $p.name -and (Test-Path -LiteralPath (Join-Path (Get-PackDir) "out/$($p.name).zip")))
    $covered = [bool]($p -and -not @($pend | Where-Object { @($p.tasks) -notcontains $_ }).Count)
    if ($zipOk -and $covered -and -not $rej.Count) { return [pscustomobject]@{ New = $false; Name = $p.name; Tasks = $pend; Round = $p.round; Kb = 0 } }
    $round = if ($p) { $p.round + 1 } else { 1 }
    $sel = if ($covered -and $rej.Count) { @($Items | Where-Object { $rej -contains $_.Id }) } else { @($Items) }
    $pack = New-PlanPack $Story $sel $round 'story'
    $st.packs[$Story] = @{ name = $pack.Name; round = $round; tasks = $pend; rejected = @(); at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
    Save-PackState $st
    Add-RunLog $S $n ($pack.Tasks -join ', ') "external plan: pacote $($pack.Name) gerado ($(if ($round -gt 1) { "correção $($round - 1)" } else { 'primeiro' })) — com o stakeholder" 'guards.json → run.planner external: o plano sai do Claude; o plan.ps1 confere na volta' "sprints/$n/pack/out/$($pack.Name).zip"
    $pack | Add-Member -NotePropertyName New -NotePropertyValue $true
    return $pack
}

# Pacote da decisão do 🔺 GAP (run.ps1 done -Result gap, e a correção dele no next).
function Start-GapPack($T, [string]$GapLine) {
    $st = Get-PackState
    $g = if ($st.gaps.ContainsKey($T.Id)) { $st.gaps[$T.Id] } else { $null }
    $round = if ($g -and $g.fix) { $g.round + 1 } else { 1 }
    if (-not $GapLine -and $g) { $GapLine = $g.gap }
    $pack = New-PlanPack $T.Story @($T) $round 'gap' $GapLine
    $st.gaps[$T.Id] = @{ name = $pack.Name; round = $round; gap = $GapLine; fix = $false; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
    Save-PackState $st
    return $pack
}

# O que está fora esperando o stakeholder: uma linha por pacote (História com Task sem plano, GAP sem decisão).
function Get-ExternalPending {
    $st = Get-PackState; $list = @()
    foreach ($k in @($st.packs.Keys | Sort-Object)) {
        $p = $st.packs[$k]
        $open = @($p.tasks | Where-Object { $id = $_; $t = @($tasks | Where-Object { $_.Id -eq $id }) | Select-Object -First 1; $t -and -not (Get-PlanFull $t $S) })
        if ($open.Count) { $list += [pscustomobject]@{ Label = "planos da História $k ($($open -join ', '))"; Name = $p.name } }
    }
    foreach ($k in @($st.gaps.Keys | Sort-Object)) { $list += [pscustomobject]@{ Label = "decisão do 🔺 GAP da $k"; Name = $st.gaps[$k].name } }
    return $list
}
# Nada a fazer pelo time até o retorno: diz ao stakeholder onde pegar e onde devolver, grava a marca que libera a G20.
function Write-ExternalWait {
    $pend = @(Get-ExternalPending)
    Out "PRÓXIMA AÇÃO: external plan — com o stakeholder; o time não tem o que fazer até o retorno"
    foreach ($p in $pend) {
        Out "  • $($p.Label): pegue .team-project/sprints/$n/pack/out/$($p.Name).zip (chat na web) ou a pasta .team-project/sprints/$n/pack/out/$($p.Name)/ (app do Codex) e peça `"siga o INSTRUCTIONS.md`"; devolva o $($p.Name)-return.zip (ou os <T-ID>-plan.md soltos) em .team-project/sprints/$n/pack/in/"
    }
    Out "  depois: /sm sprint run — o run.ps1 next lê pack/in/, confere cada plano (plan.ps1) e segue"
    Out "  sessão: encerre o turno e passe estas linhas ao stakeholder, sem formulário (não é decisão; a marca .team-project/.external-plan libera a G20)"
    $o = [ordered]@{ sprint = $n; pendente = @($pend | ForEach-Object { $_.Name }); desde = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
    [System.IO.File]::WriteAllText((Join-Path $Root '.team-project/.external-plan'), ($o | ConvertTo-Json -Compress), $utf8)
    exit 3
}

# Lê pack/in/: zip ou .md soltos com o nome <T-ID>-plan.md. Cada plano passa pelo plan.ps1 antes de entrar em plan/;
# reprovado vai a pack/review/ e a Task volta num pacote de correção. O arquivo lido vai a pack/done/. Devolve as linhas.
function Import-PlanReturns($Planner) {
    $pk = Get-PackDir; $in = Join-Path $pk 'in'; $out = @()
    if (-not (Test-Path -LiteralPath $in)) { return $out }
    $files = @(Get-ChildItem -LiteralPath $in -File | Sort-Object LastWriteTime)
    if (-not $files.Count) { return $out }
    $st = Get-PackState
    $re = '^(' + $script:TaskIdRe + ')-(?i:plan)(?:\s*\(\d+\))?\.(?i:md)$'
    $doneDir = Join-Path $pk 'done'; New-Item -ItemType Directory -Force $doneDir | Out-Null
    foreach ($f in $files) {
        $items = @(); $ignored = @()
        if ($f.Extension -ieq '.zip') {
            try {
                $za = [System.IO.Compression.ZipFile]::OpenRead($f.FullName)
                try {
                    foreach ($en in $za.Entries) {
                        if (-not $en.Name -or $en.FullName -match '(^|/)__MACOSX/') { continue }
                        if ([regex]::IsMatch($en.Name, $re)) { $sr = New-Object System.IO.StreamReader($en.Open(), $utf8, $true); try { $items += @{ Name = $en.Name; Text = $sr.ReadToEnd() } } finally { $sr.Dispose() } }
                        else { $ignored += $en.FullName }
                    }
                } finally { $za.Dispose() }
            } catch { $out += "  external plan: $($f.Name) não abriu como zip ($($_.Exception.Message)) — foi para pack/done/ sem efeito" }
        } elseif ([regex]::IsMatch($f.Name, $re)) { $items += @{ Name = $f.Name; Text = (Read-Text $f.FullName) } }
        else { $ignored += $f.Name }
        foreach ($it in $items) { $out += Import-OnePlan $it $st $Planner $re }
        if ($ignored.Count) { $out += "  external plan: ignorado em $($f.Name) (não é <T-ID>-plan.md; nada entra no projeto): $((@($ignored) | Select-Object -First 5) -join ', ')$(if ($ignored.Count -gt 5) { " e mais $($ignored.Count - 5)" })" }
        Move-Item -LiteralPath $f.FullName -Destination (Join-Path $doneDir "$(Get-Date -Format 'yyyyMMdd-HHmmss')-$($f.Name)") -Force
    }
    Save-PackState $st
    return $out
}
function Import-OnePlan($It, $St, $Planner, [string]$Re) {
    $id = [regex]::Match($It.Name, $Re).Groups[1].Value
    $T = @($tasks | Where-Object { $_.Id -eq $id }) | Select-Object -First 1
    if (-not $T) { return "  external plan: $($It.Name) recusado — a $id não está no quadro do sprint $n" }
    $text = ([string]$It.Text).TrimStart([char]0xFEFF)
    if (-not $text.Trim()) { return "  external plan: $($It.Name) recusado — arquivo vazio" }
    $isGap = $St.gaps.ContainsKey($id)
    $inPack = @($St.packs.Values | Where-Object { @($_.tasks) -contains $id }).Count -gt 0
    $cur = Get-PlanFull $T $S
    if ($cur -and -not $isGap) { return "  external plan: $($It.Name) recusado — a $id já tem plano ($($T.Plan)); plano de Task já planejada só muda pela decisão de um 🔺 GAP" }
    if (-not $isGap -and -not $inPack -and -not (Test-ExternalTask $Planner $id)) { return "  external plan: $($It.Name) recusado — a $id não está no plano externo (guards.json → run)" }
    $destRel = if ($cur) { $T.Plan } else { Get-PlanDest $T }
    $dest = Join-Path $S $destRel
    $before = if ($cur) { Read-Text $cur } else { $null }
    New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
    [System.IO.File]::WriteAllText($dest, $text, $utf8)
    $r = Invoke-Child 'plan.ps1' @('-Plan', $dest, '-Root', $Root)
    $rv = Join-Path (Get-PackDir) 'review'; New-Item -ItemType Directory -Force $rv | Out-Null
    if ($r.Code -eq 0) {
        Remove-Item -LiteralPath (Join-Path $rv "$id-plan.md"), (Join-Path $rv "$id-check.txt") -Force -ErrorAction SilentlyContinue
        if ($isGap) {
            $St.gaps.Remove($id)
            Add-RunLog $S $n $id 'external plan: decisão do 🔺 GAP gravada no plano (plan.ps1 ok) → dev em instância nova' 'o GAP da Task foi decidido fora do Claude (guards.json → run.planner external)' "sprints/$n/$destRel"
            return "  external plan: $id — decisão do 🔺 GAP aceita (plan.ps1 ok) em sprints/$n/$destRel; a Task volta à construção (dev em instância nova)"
        }
        if (-not (Set-BoardPlan $id $destRel)) { return "  external plan: $id aceito (plan.ps1 ok) em sprints/$n/$destRel, mas a linha dela no quadro não tem coluna Plano — a sessão grava o link à mão" }
        if ($St.packs.ContainsKey($T.Story)) { $St.packs[$T.Story].rejected = @($St.packs[$T.Story].rejected | Where-Object { $_ -ne $id }) }
        Add-RunLog $S $n $id 'external plan aceito (plan.ps1 ok)' 'plano escrito fora do Claude pelo pacote (guards.json → run.planner external)' "sprints/$n/$destRel"
        return "  external plan: $id aceito (plan.ps1 ok) → sprints/$n/$destRel"
    }
    [System.IO.File]::WriteAllText((Join-Path $rv "$id-plan.md"), $text, $utf8)
    [System.IO.File]::WriteAllText((Join-Path $rv "$id-check.txt"), $r.Out, $utf8)
    if ($null -ne $before) { [System.IO.File]::WriteAllText($dest, $before, $utf8) } else { Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue }
    $bad = @($r.Out -split "`r?`n" | Where-Object { $_ -match '^\|\s*([^|]+?)\s*\|\s*falhou\s*\|' } | ForEach-Object { [regex]::Match($_, '^\|\s*([^|]+?)\s*\|').Groups[1].Value })
    $why = if ($bad.Count) { $bad -join ', ' } elseif ($r.Code -eq 2) { 'erro de uso do plan.ps1' } else { 'plan.ps1 reprovou' }
    if ($isGap) { $St.gaps[$id].fix = $true }
    else {
        if (-not $St.packs.ContainsKey($T.Story)) { $St.packs[$T.Story] = @{ name = ''; round = 1; tasks = @($id); rejected = @(); at = '' } }
        $St.packs[$T.Story].rejected = @(@($St.packs[$T.Story].rejected) + $id | Select-Object -Unique)
    }
    Add-RunLog $S $n $id "external plan reprovado pelo plan.ps1 ($why) → pacote de correção" 'o plano de fora só entra no quadro depois da conferência' "sprints/$n/pack/review/$id-check.txt"
    return "  external plan: $id reprovado pelo plan.ps1 ($why) — volta num pacote de correção, com a tabela"
}
