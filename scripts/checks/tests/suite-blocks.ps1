# Divide a suíte de conferências (run-check-tests.ps1) em unidades independentes — v3.64.1. Carregado pelo run-all-tests.ps1.
# Os casos ficam entre "# ==== início dos casos ====" e "# ==== fim dos casos ====". O que vem antes é o preâmbulo, que cada
# bloco roda inteiro (funções, constantes, $tmp próprio). Uma unidade é um trecho de comandos de topo em que nada atravessa a
# fronteira:
#   · variável — a leitura liga à última atribuição de topo antes dela; nenhum corte entre as duas;
#   · função definida no corpo e chamada depois;
#   · variável de ambiente ligada ($env:X = …) e lida/desligada depois (Remove-Item Env:\X);
#   · pasta do $tmp citada pelo nome (Join-Path $tmp 'feliz') — o trecho que reaproveita o projeto de outro.
# Dentro de um scriptblock aninhado (função, { }), a escrita é local e a leitura de nome local não conta. As constantes do
# preâmbulo restauradas no meio ($e = $e0) não amarram nada.

function Get-SuiteUnits([string]$File) {
    $tokens = $null; $errs = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($File, [ref]$tokens, [ref]$errs)
    if ($errs -and $errs.Count) { throw "suite-blocks: $File não compila: $($errs[0].Message) (linha $($errs[0].Extent.StartLineNumber))" }
    $lines = [System.IO.File]::ReadAllLines($File, [System.Text.Encoding]::UTF8)
    $b = -1; $z = -1
    # A primeira marca de início e a primeira de fim depois dela (v3.66.1: um caso pode carregar o texto de uma suíte falsa).
    for ($i = 0; $i -lt $lines.Length; $i++) { if ($b -lt 0 -and $lines[$i].StartsWith('# ==== início dos casos')) { $b = $i + 1 } elseif ($b -ge 0 -and $z -lt 0 -and $lines[$i].StartsWith('# ==== fim dos casos')) { $z = $i + 1 } }
    if ($b -lt 0 -or $z -lt 0) { throw "suite-blocks: $File sem as marcas '# ==== início dos casos' e '# ==== fim dos casos'" }
    $pre = @{}
    foreach ($s in @($ast.EndBlock.Statements | Where-Object { $_.Extent.EndLineNumber -lt $b })) {
        if ($s -is [System.Management.Automation.Language.AssignmentStatementAst] -and $s.Left -is [System.Management.Automation.Language.VariableExpressionAst]) { $pre[$s.Left.VariablePath.UserPath.ToLowerInvariant()] = $true }
        if ($s -is [System.Management.Automation.Language.PipelineAst]) { foreach ($a in $s.FindAll({ param($n) $n -is [System.Management.Automation.Language.AssignmentStatementAst] -and $n.Left -is [System.Management.Automation.Language.VariableExpressionAst] }, $false)) { $pre[$a.Left.VariablePath.UserPath.ToLowerInvariant()] = $true } }
    }
    # Constantes do preâmbulo que o corpo só restaura (mesmo valor) — atribuir de novo não amarra o que vem depois.
    $preConst = @('e', 'e0', 'utf8', 'checks', 'tmp', 'gh63', 'g63', 'lib63', 'warn', 'x', 'ck', 'bdtext', 'ok63', 'fail63')
    $auto = @('_', 'true', 'false', 'null', 'pid', 'lastexitcode', 'matches', 'args', 'psscriptroot', 'input', 'this', 'erroractionpreference', 'error', 'host', 'home', 'pwd', 'psitem')
    $stmts = @($ast.EndBlock.Statements | Where-Object { $_.Extent.StartLineNumber -gt $b -and $_.Extent.EndLineNumber -lt $z })
    # O que muda o processo inteiro (assembly carregado) não aparece como variável: fica no preâmbulo, ou o bloco que usa o
    # tipo e não tem a carga quebra ("Não é possível localizar o tipo").
    foreach ($s in $stmts) { if ($s.Extent.Text -match '(?im)^\s*Add-Type\b') { throw "suite-blocks: Add-Type no corpo da suíte (linha $($s.Extent.StartLineNumber)) — mova para o preâmbulo, antes de '# ==== início dos casos'" } }
    $last = @{}; $blocked = New-Object 'bool[]' ($stmts.Count + 1)
    $VE = [System.Management.Automation.Language.VariableExpressionAst]; $SB = [System.Management.Automation.Language.ScriptBlockAst]
    for ($j = 0; $j -lt $stmts.Count; $j++) {
        $s = $stmts[$j]
        $reads = New-Object System.Collections.Generic.HashSet[string]; $writes = New-Object System.Collections.Generic.HashSet[string]
        $fw = @{}; $fr = @{}
        foreach ($v in $s.FindAll({ param($n) $n -is [System.Management.Automation.Language.VariableExpressionAst] }, $true)) {
            $raw = $v.VariablePath.UserPath; $nm = $raw.ToLowerInvariant() -replace '^script:', ''
            if ($auto -contains $nm -or $preConst -contains $nm) { continue }
            $par = $v.Parent
            $isW = ($par -is [System.Management.Automation.Language.AssignmentStatementAst] -and $par.Left -eq $v) -or ($par -is [System.Management.Automation.Language.ForEachStatementAst] -and $par.Variable -eq $v)
            $nest = $null; $q = $v.Parent
            while ($q -and $q -ne $s) { if ($q -is $SB) { $nest = $q; break }; $q = $q.Parent }
            if ($nest -and $nm -notlike 'env:*' -and $raw -notmatch '^(?i)script:') {
                if ($isW) { continue }
                $loc = @($nest.FindAll({ param($n) ($n -is [System.Management.Automation.Language.AssignmentStatementAst] -and $n.Left -is [System.Management.Automation.Language.VariableExpressionAst]) -or $n -is [System.Management.Automation.Language.ParameterAst] -or $n -is [System.Management.Automation.Language.ForEachStatementAst] }, $true) | ForEach-Object {
                    if ($_ -is [System.Management.Automation.Language.ParameterAst]) { $_.Name.VariablePath.UserPath } elseif ($_ -is [System.Management.Automation.Language.ForEachStatementAst]) { $_.Variable.VariablePath.UserPath } else { $_.Left.VariablePath.UserPath } } | ForEach-Object { $_.ToLowerInvariant() })
                if ($loc -contains $nm) { continue }
            }
            $off = $v.Extent.StartOffset
            if ($isW) { [void]$writes.Add($nm); if (-not $fw.ContainsKey($nm) -or $off -lt $fw[$nm]) { $fw[$nm] = $off } }
            else { [void]$reads.Add($nm); if (-not $fr.ContainsKey($nm) -or $off -lt $fr[$nm]) { $fr[$nm] = $off } }
        }
        foreach ($k in @($fw.Keys)) { if ($fr.ContainsKey($k) -and $fw[$k] -lt $fr[$k]) { [void]$reads.Remove($k) } }
        $txt = $s.Extent.Text
        foreach ($m in [regex]::Matches($txt, '(?i)Env:\\(\w+)')) { [void]$writes.Add('env:' + $m.Groups[1].Value.ToLowerInvariant()) }
        foreach ($m in [regex]::Matches($txt, '(?i)Join-Path\s+\$tmp\s+[''"]([^''"/\\]+)')) { $k = 'dir:' + $m.Groups[1].Value.ToLowerInvariant(); [void]$reads.Add($k); [void]$writes.Add($k) }
        foreach ($fd in $s.FindAll({ param($n) $n -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)) { if (-not ($fd.Parent -and $fd.Parent.Parent -is $SB -and $fd.Parent.Parent -ne $ast)) { [void]$writes.Add('fn:' + $fd.Name.ToLowerInvariant()) } }
        foreach ($c in $s.FindAll({ param($n) $n -is [System.Management.Automation.Language.CommandAst] }, $true)) { $cn = $c.GetCommandName(); if ($cn) { [void]$reads.Add('fn:' + $cn.ToLowerInvariant()) } }
        foreach ($r in $reads) { if ($last.ContainsKey($r)) { for ($k = $last[$r] + 1; $k -le $j; $k++) { $blocked[$k] = $true } } }
        foreach ($w in $writes) { $last[$w] = $j }
    }
    # As unidades: de um corte ao seguinte, com os nomes dos casos (o 1º argumento de cada Check).
    $units = @(); $start = 0
    for ($k = 1; $k -le $stmts.Count; $k++) {
        if ($k -lt $stmts.Count -and $blocked[$k]) { continue }
        $from = $stmts[$start].Extent.StartLineNumber; $to = $stmts[$k - 1].Extent.EndLineNumber
        $names = @()
        for ($q = $start; $q -lt $k; $q++) {
            foreach ($c in $stmts[$q].FindAll({ param($n) $n -is [System.Management.Automation.Language.CommandAst] -and $n.GetCommandName() -eq 'Check' }, $true)) {
                $a0 = $c.CommandElements[1]
                $names += $(if ($a0 -is [System.Management.Automation.Language.StringConstantExpressionAst]) { $a0.Value } elseif ($a0 -is [System.Management.Automation.Language.ExpandableStringExpressionAst]) { $a0.Value } else { $a0.Extent.Text })
            }
        }
        $units += [pscustomobject]@{ From = $from; To = $to; Checks = @($names) }
        $start = $k
    }
    $preStmts = @($ast.EndBlock.Statements | Where-Object { $_.Extent.EndLineNumber -lt $b })
    return [pscustomobject]@{ Preamble = ($lines[0..($b - 2)] -join "`r`n"); Lines = $lines; Units = $units; Begin = $b; End = $z; PreStatements = $preStmts }
}

# ---------- v3.66.1 (item A) — o nível do caso pelo último tempo medido ----------
# A unidade com algum caso cujo último tempo no test-times.json passa de $SlowSec é do nível lento; caso sem medição (novo) é
# rápido até ser medido. Não há lista à mão: o caso que ficar mais rápido sai sozinho na rodada seguinte ao -Full que o mediu.
function Get-UnitTier($Unit, [hashtable]$Times, [double]$SlowSec = 20) {
    foreach ($c in @($Unit.Checks)) { if ($Times.ContainsKey([string]$c) -and [double]$Times[[string]$c] -gt $SlowSec) { return 'slow' } }
    return 'fast'
}

# ---------- v3.66.1 (item E) — processos em paralelo pela máquina ----------
# O menor entre núcleos − 1, memória livre ÷ 1,5 GB (cada processo com projeto e suíte falsos chega a ~1,2 GB no pico) e $Cap.
# Memória livre abaixo de 4 GB: no máximo 2, com o aviso (Busy). Nunca menos de 1.
function Get-DefaultWorkers([int]$Cores, [double]$FreeGB, [int]$Cap = 6) {
    $n = [Math]::Min([Math]::Min($Cores - 1, [int][Math]::Floor($FreeGB / 1.5)), $Cap)
    $busy = $FreeGB -lt 4
    if ($busy) { $n = [Math]::Min($n, 2) }
    return [pscustomobject]@{ Workers = [Math]::Max(1, $n); Busy = $busy }
}
function Get-FreeMemoryGB {
    try { return [double](Get-CimInstance Win32_OperatingSystem -ErrorAction Stop).FreePhysicalMemory / 1MB } catch { return 8.0 }
}

# ---------- v3.66.1 (item C) — os grupos da suíte das guardas ----------
# Um grupo por seção do $cases (# ---------- vX.Y — … ----------); os casos antes da primeira seção formam o grupo base, e o
# que o script acrescenta ao $cases depois da lista (o inventário dos formulários) forma o último grupo (Cases = $null: os
# índices de StaticCount em diante). Cada grupo roda num processo com o seu $tmp e o seu projeto falso — o estado que um caso
# precisa é montado no próprio grupo (run-guard-tests.ps1 -CheckGroups acusa o grupo que só passa depois de outro).
function Get-GuardGroups([string]$File) {
    $tokens = $null; $errs = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($File, [ref]$tokens, [ref]$errs)
    if ($errs -and $errs.Count) { throw "suite-blocks: $File não compila: $($errs[0].Message) (linha $($errs[0].Extent.StartLineNumber))" }
    $lines = [System.IO.File]::ReadAllLines($File, [System.Text.Encoding]::UTF8)
    $top = @($ast.EndBlock.Statements)
    $ci = -1
    for ($i = 0; $i -lt $top.Count; $i++) { if ($top[$i] -is [System.Management.Automation.Language.AssignmentStatementAst] -and $top[$i].Left -is [System.Management.Automation.Language.VariableExpressionAst] -and $top[$i].Left.VariablePath.UserPath -eq 'cases') { $ci = $i; break } }
    if ($ci -lt 0) { throw "suite-blocks: $File sem a lista `$cases = @( … )" }
    $elems = @()
    try {
        $x = $top[$ci].Right.Expression.SubExpression.Statements[0].PipelineElements[0].Expression
        $elems = if ($x -is [System.Management.Automation.Language.ArrayLiteralAst]) { @($x.Elements) } else { @($x) }
    } catch { throw "suite-blocks: $File — a lista `$cases não é @( @{…}, @{…} )" }
    $heads = @()
    for ($l = $top[$ci].Extent.StartLineNumber; $l -le $top[$ci].Extent.EndLineNumber; $l++) {
        $m = [regex]::Match($lines[$l - 1], '^\s*#\s*-{6,}\s*(.+?)\s*-{4,}\s*$')
        if ($m.Success) { $heads += [pscustomobject]@{ Line = $l; Title = $m.Groups[1].Value } }
    }
    $nameOf = { param($t) @([regex]::Matches($t, "Name\s*=\s*'((?:[^']|'')*)'") | ForEach-Object { $_.Groups[1].Value -replace "''", "'" }) }
    $raw = @(); $raw += [pscustomobject]@{ Title = 'base (antes da primeira seção)'; Cases = (New-Object System.Collections.ArrayList); From = 0; To = 0 }
    foreach ($h in $heads) { $raw += [pscustomobject]@{ Title = $h.Title; Cases = (New-Object System.Collections.ArrayList); From = $h.Line; To = $h.Line } }
    for ($k = 0; $k -lt $elems.Count; $k++) {
        $ln = $elems[$k].Extent.StartLineNumber
        $gi = @($heads | Where-Object { $_.Line -lt $ln }).Count
        [void]$raw[$gi].Cases.Add($k)
        if (-not $raw[$gi].From) { $raw[$gi].From = $ln }
        $raw[$gi].To = $elems[$k].Extent.EndLineNumber
    }
    $groups = @(); $gn = 0
    foreach ($r in $raw) {
        if (-not $r.Cases.Count) { continue }
        $gn++
        $txt = (@($r.Cases | ForEach-Object { $elems[$_].Extent.Text }) -join "`n")
        $groups += [pscustomobject]@{ Index = $gn; Title = $r.Title; Cases = @($r.Cases); Count = $r.Cases.Count; From = $r.From; To = $r.To; Text = $txt; Names = @(& $nameOf $txt) }
    }
    # O que vem depois da lista e acrescenta casos (… $cases += …) é o último grupo; o resto é o executor (preâmbulo também).
    $last = -1
    for ($i = $ci + 1; $i -lt $top.Count; $i++) { if ($top[$i].Extent.Text -match '\$cases\s*\+=') { $last = $i } }
    $runner = @()
    if ($last -gt $ci) {
        $ex = @($top[($ci + 1)..$last])
        $gn++
        $txt = (@($ex | ForEach-Object { $_.Extent.Text }) -join "`n")
        $groups += [pscustomobject]@{ Index = $gn; Title = 'casos montados depois da lista'; Cases = $null; Count = 0; From = $ex[0].Extent.StartLineNumber; To = $ex[-1].Extent.EndLineNumber; Text = $txt; Names = @(& $nameOf $txt) }
        if ($last + 1 -lt $top.Count) { $runner = @($top[($last + 1)..($top.Count - 1)]) }
    } elseif ($ci + 1 -lt $top.Count) { $runner = @($top[($ci + 1)..($top.Count - 1)]) }
    return [pscustomobject]@{ Groups = $groups; StaticCount = $elems.Count; PreStatements = @($top[0..($ci - 1)] | Where-Object { $_ }); Runner = $runner; CasesFrom = $top[$ci].Extent.StartLineNumber; CasesTo = $top[$ci].Extent.EndLineNumber }
}
# A conferência de independência (run-guard-tests.ps1 -CheckGroups): cada grupo sozinho, num processo próprio
# (<suíte> -Groups <n> -ResultFile <json>), no máximo $Workers ao mesmo tempo. O grupo com caso que falha sozinho é acusado —
# ele supõe o estado que outro grupo montou. @{ Lines; Bad }.
function Invoke-GuardGroupCheck([string]$Suite, $GG, [string]$Dir, [int]$Workers = 4) {
    $u8 = New-Object System.Text.UTF8Encoding($false)
    $queue = New-Object System.Collections.Queue; foreach ($g in $GG.Groups) { $queue.Enqueue($g) }
    $running = @(); $res = @()
    while ($queue.Count -or $running.Count) {
        while ($queue.Count -and $running.Count -lt [Math]::Max(1, $Workers)) {
            $g = $queue.Dequeue(); $rf = Join-Path $Dir "grupo-$($g.Index).json"
            # protocolo: filho da conferência — quem chama espera por ele aqui mesmo.
            $p = Start-Process powershell -WindowStyle Hidden -PassThru -RedirectStandardOutput "$rf.log" -RedirectStandardError "$rf.err" -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', "[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding(`$false); & '$Suite' -Groups $($g.Index) -ResultFile '$rf'; exit `$LASTEXITCODE")
            $null = $p.Handle
            $running += [pscustomobject]@{ G = $g; P = $p; R = $rf }
        }
        Start-Sleep -Milliseconds 300
        foreach ($r in @($running | Where-Object { $_.P.HasExited })) { $running = @($running | Where-Object { $_ -ne $r }); $res += $r }
    }
    $bad = 0; $lines = @()
    foreach ($r in @($res | Sort-Object { $_.G.Index })) {
        $rj = $null; if (Test-Path -LiteralPath $r.R) { try { $rj = [System.IO.File]::ReadAllText($r.R, $u8) | ConvertFrom-Json } catch { } }
        if (-not $rj) { $bad++; $lines += ("grupo {0,2} ({1}): não terminou (exit {2})" -f $r.G.Index, $r.G.Title, $r.P.ExitCode); continue }
        $fl = @($rj.rows | Where-Object { $_.Ok -ne 'ok' })
        if ($fl.Count) { $bad++; $lines += ("grupo {0,2} ({1}): {2} falharam sozinho — o grupo supõe o estado de outro; declare o estado de partida dele (`$GroupBase) ou monte-o no Setup do caso:" -f $r.G.Index, $r.G.Title, $fl.Count); foreach ($f in $fl) { $lines += "    $($f.Caso) — $($f.Mensagem)" } }
        else { $lines += ("grupo {0,2} ({1}): {2} casos ok sozinho" -f $r.G.Index, $r.G.Title, @($rj.rows).Count) }
    }
    $lines += ("{0} grupos · {1} dependem de outro" -f $res.Count, $bad)
    return [pscustomobject]@{ Lines = $lines; Bad = $bad }
}
# Os índices de $cases do grupo $Index (o grupo montado depois da lista vai de StaticCount ao fim).
function Get-GuardGroupCases($GG, [int]$Index, [int]$Total) {
    $g = @($GG.Groups | Where-Object { $_.Index -eq $Index })
    if (-not $g.Count) { return @() }
    if ($null -eq $g[0].Cases) { if ($Total -gt $GG.StaticCount) { return @($GG.StaticCount..($Total - 1)) } else { return @() } }
    return @($g[0].Cases)
}

# ---------- v3.66.1 (item B) — só o que a mudança toca (-Changed) ----------
# O que mudou: os arquivos alterados em relação ao ponto em que a branch saiu de $Base (os commits da branch e o disco, com
# os novos ainda fora do git). Biblioteca comum alterada roda tudo. Os outros nomes alterados — e, por fecho, os scripts do
# plugin que carregam ou chamam um nome alterado — escolhem os blocos e os grupos que os citam. Na própria suíte, a linha
# alterada escolhe a unidade (ou o grupo) dela; a alteração no preâmbulo ou no executor roda a suíte inteira.
$script:SharedLibs = @('scripts/checks/lib.ps1', 'hooks/common.ps1', 'scripts/checks/plain.ps1', 'scripts/checks/impasse-lib.ps1')
function Test-SharedLib([string]$Rel) { $r = ($Rel -replace '\\', '/'); return ($script:SharedLibs -contains $r) -or ($r -match '^hooks/[^/]+\.json$') }
function Get-ChangedFiles([string]$Root, [string]$Base = 'develop') {
    $ErrorActionPreference = 'Continue'
    $mb = ''
    foreach ($b in @($Base, "origin/$Base")) { $o = @(& git -C $Root merge-base $b HEAD 2>$null); if ($LASTEXITCODE -eq 0 -and $o.Count) { $mb = ([string]$o[0]).Trim(); break } }
    if (-not $mb) { return [pscustomobject]@{ MergeBase = ''; Files = @(); Error = "sem ponto comum com '$Base' (git merge-base)" } }
    $f = @(& git -C $Root diff --name-only $mb 2>$null) + @(& git -C $Root ls-files --others --exclude-standard 2>$null)
    $f = @($f | ForEach-Object { ([string]$_).Trim() -replace '\\', '/' } | Where-Object { $_ } | Sort-Object -Unique)
    return [pscustomobject]@{ MergeBase = $mb; Files = $f; Error = '' }
}
# As linhas (do arquivo no disco) alteradas desde $MergeBase; $null = o arquivo inteiro (novo, fora do git).
function Get-ChangedLineSet([string]$Root, [string]$MergeBase, [string]$Rel) {
    $ErrorActionPreference = 'Continue'
    $null = & git -C $Root cat-file -e "${MergeBase}:$Rel" 2>$null
    if ($LASTEXITCODE -ne 0) { return $null }
    $set = New-Object 'System.Collections.Generic.HashSet[int]'
    foreach ($l in @(& git -C $Root diff -U0 $MergeBase -- $Rel 2>$null)) {
        $m = [regex]::Match([string]$l, '^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@')
        if (-not $m.Success) { continue }
        $s = [int]$m.Groups[1].Value; $n = if ($m.Groups[2].Success) { [int]$m.Groups[2].Value } else { 1 }
        if ($n -eq 0) { [void]$set.Add([Math]::Max(1, $s)); [void]$set.Add($s + 1) } else { for ($q = $s; $q -lt $s + $n; $q++) { [void]$set.Add($q) } }
    }
    return , $set
}
function Get-NamePattern([string]$Name) { return '(?i)(?<![\w-])' + [regex]::Escape($Name) + '(?![\w-])' }
# O código que CARREGA ou CHAMA o nome — Join-Path <base> '<…/nome>', -File <…nome>, ". <…nome>" / "& <…nome>",
# $PSScriptRoot\nome. Citar o nome numa mensagem ("rode o kanban.ps1") não é depender dele: sem isto, o lib.ps1, que cita
# quase todos os scripts nas mensagens, levava qualquer mudança a rodar tudo.
function Get-LoadPattern([string]$Name) {
    $e = [regex]::Escape($Name)
    return "(?im)(Join-Path\s+\S+\s+['""](?:[^'""\r\n]*[\\/])?$e['""]|-File\s+(?:""[^""\r\n]*|'[^'\r\n]*|[^\s'""]*)$e(?![\w-])|^\s*[.&]\s+['""]?[^\s'""]*$e(?![\w-])|\`$PSScriptRoot[\\/]$e(?![\w-]))"
}
# Os nomes alterados e, por fecho, os scripts do plugin (scripts/ e hooks/, fora da pasta dos testes) que carregam ou
# chamam um nome alterado: nome → por quê.
function Get-AffectedNames([string]$Root, [string[]]$Files, [string[]]$Skip = @()) {
    $names = [ordered]@{}
    foreach ($f in $Files) { $bn = [System.IO.Path]::GetFileName($f); if ($bn -and $Skip -notcontains $f -and -not $names.Contains($bn)) { $names[$bn] = 'mudou' } }
    $scripts = @()
    foreach ($d in @('scripts', 'hooks')) {
        $p = Join-Path $Root $d
        if (Test-Path -LiteralPath $p) { $scripts += @(Get-ChildItem -LiteralPath $p -Recurse -File -Filter '*.ps1' | Where-Object { $_.FullName -notmatch '[\\/]tests[\\/]' }) }
    }
    $texts = @{}; foreach ($s in $scripts) { $texts[$s.FullName] = [System.IO.File]::ReadAllText($s.FullName, [System.Text.Encoding]::UTF8) }
    $grew = $true
    while ($grew) {
        $grew = $false
        foreach ($s in $scripts) {
            if ($names.Contains($s.Name)) { continue }
            foreach ($n in @($names.Keys)) { if ($texts[$s.FullName] -match (Get-LoadPattern $n)) { $names[$s.Name] = "carrega $n, que $(if ($names[$n] -eq 'mudou') { 'mudou' } else { 'é afetado' })"; $grew = $true; break } }
        }
    }
    return $names
}
# O preâmbulo de uma suíte: as funções e variáveis de topo (símbolos) que citam um nome afetado, por fecho; e se o que roda
# para todos (o resto do preâmbulo e o executor) cita um nome afetado ou um símbolo tocado — aí a suíte roda inteira.
function Get-PreambleTouch($Statements, $Runner, $Names) {
    $syms = @(); $glob = @()
    foreach ($s in @($Statements) + @($Runner)) {
        if (-not $s) { continue }
        if ($s -is [System.Management.Automation.Language.FunctionDefinitionAst]) { $syms += [pscustomobject]@{ Name = $s.Name; Pat = (Get-NamePattern $s.Name); Text = $s.Extent.Text } }
        elseif ($s -is [System.Management.Automation.Language.AssignmentStatementAst] -and $s.Left -is [System.Management.Automation.Language.VariableExpressionAst] -and $s.Left.VariablePath.UserPath -notmatch '^(?i)(script|env|global):') {
            $vn = $s.Left.VariablePath.UserPath
            $syms += [pscustomobject]@{ Name = '$' + $vn; Pat = ('(?i)\$(?:script:)?' + [regex]::Escape($vn) + '(?!\w)'); Text = $s.Right.Extent.Text }
        } else { $glob += $s.Extent.Text }
    }
    $touched = [ordered]@{}
    $grew = $true
    while ($grew) {
        $grew = $false
        foreach ($y in $syms) {
            if ($touched.Contains($y.Name)) { continue }
            $why = Find-Touch $y.Text $Names $touched -Load
            if ($why) { $touched[$y.Name] = $why; $grew = $true }
        }
    }
    $all = $null
    foreach ($g in $glob) { $w = Find-Touch $g $Names $touched -Load; if ($w) { $all = $w; break } }
    return [pscustomobject]@{ Touched = $touched; All = $all; Syms = $syms }
}
# Por que o trecho entra: cita um nome afetado (-Load: carrega ou chama — o código do preâmbulo), ou usa um símbolo do
# preâmbulo tocado. $null = não entra.
function Find-Touch([string]$Text, $Names, $Touched, [switch]$Load) {
    foreach ($n in @($Names.Keys)) { if ($Text -match $(if ($Load) { Get-LoadPattern $n } else { Get-NamePattern $n })) { return "$(if ($Load) { 'carrega' } else { 'cita' }) $n ($($Names[$n]))" } }
    if ($Touched) {
        foreach ($k in @($Touched.Keys)) {
            $pat = if ($k.StartsWith('$')) { '(?i)\$(?:script:)?' + [regex]::Escape($k.Substring(1)) + '(?!\w)' } else { Get-NamePattern $k }
            if ($Text -match $pat) { return "usa $k do preâmbulo, que $($Touched[$k])" }
        }
    }
    return $null
}
