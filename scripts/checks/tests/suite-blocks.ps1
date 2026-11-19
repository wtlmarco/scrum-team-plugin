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
    for ($i = 0; $i -lt $lines.Length; $i++) { if ($lines[$i].StartsWith('# ==== início dos casos')) { $b = $i + 1 } elseif ($lines[$i].StartsWith('# ==== fim dos casos')) { $z = $i + 1 } }
    if ($b -lt 0 -or $z -lt 0) { throw "suite-blocks: $File sem as marcas '# ==== início dos casos' e '# ==== fim dos casos'" }
    $pre = @{}
    foreach ($s in @($ast.EndBlock.Statements | Where-Object { $_.Extent.EndLineNumber -lt $b })) {
        if ($s -is [System.Management.Automation.Language.AssignmentStatementAst] -and $s.Left -is [System.Management.Automation.Language.VariableExpressionAst]) { $pre[$s.Left.VariablePath.UserPath.ToLowerInvariant()] = $true }
        if ($s -is [System.Management.Automation.Language.PipelineAst]) { foreach ($a in $s.FindAll({ param($n) $n -is [System.Management.Automation.Language.AssignmentStatementAst] -and $n.Left -is [System.Management.Automation.Language.VariableExpressionAst] }, $false)) { $pre[$a.Left.VariablePath.UserPath.ToLowerInvariant()] = $true } }
    }
    # Constantes do preâmbulo que o corpo só restaura (mesmo valor) — atribuir de novo não amarra o que vem depois.
    $preConst = @('e', 'e0', 'utf8', 'checks', 'tmp', 'gh63', 'g63', 'lib63', 'warn', 'x', 'ck', 'bdtext')
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
    return [pscustomobject]@{ Preamble = ($lines[0..($b - 2)] -join "`r`n"); Lines = $lines; Units = $units; Begin = $b; End = $z }
}
