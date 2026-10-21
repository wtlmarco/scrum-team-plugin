# Métricas do portão do QA (v3.51, A4): roda as ferramentas de qualidade do projeto (guards.json → quality) e devolve UMA
# LINHA POR REGRA do nível 1 de standards/ (o Quadro de Verificação, §7: Q1, Q6, Q7, Q8, Q9, Q11, Q17), passou ou falhou,
# com o número. O QA lê o resultado e julga o que ferramenta não mede (SOLID, nomes, responsabilidade, aderência ao plano).
# Comando longo: rode por aqui (ou pelo operator), nunca dentro da instância do QA (o cache dela vence em 5 min).
# Uso (raiz do projeto): powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/quality.ps1" -Id <S1|B-003|T-041> [-Files <arquivos tocados>]
#   -Files: só esses arquivos nas buscas por padrão (Q9, Q17) — o fix usa os arquivos tocados pela Correção.
# Config (guards.json → quality), cada chave um comando (ou lista) que sai ≠ 0 quando a regra quebra:
#   "coverage" (Q11, gate de 80 % por unidade) · "coverageThreshold" (80) · "coveragePattern" (regex com o % no grupo 1)
#   "lint" e "format" (Q7) · "architecture" (Q1, teste da regra de dependência) · "metrics" (Q6, limites de §4.4)
#   "duplication" (Q8) · "sourceRoots" (pastas de produção para Q9 e Q17; padrão: guards.json → sourceRoots ou src/)
# Saída: tabela regra · resultado · número/linha decisiva; .team-project/quality/<sprint|B-nnn>/<Id>/result.md e .json.
# Exit 0 = todas as regras configuradas passaram · 1 = alguma falhou · 2 = erro de uso · 4 = falha de ambiente.

param(
    [Parameter(Mandatory = $true)][string]$Id,
    [string[]]$Files = @(),
    [double]$TimeoutMinutes = 0,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)

$rules = [ordered]@{
    coverage     = @{ Q = 'Q11'; Name = 'cobertura ≥ limiar em cada módulo (§5.4)' }
    lint         = @{ Q = 'Q7'; Name = 'lint sem erro (§4.3)' }
    format       = @{ Q = 'Q7'; Name = 'formatação conferida (§4.3)' }
    architecture = @{ Q = 'Q1'; Name = 'regra de dependência entre anéis (§2.2)' }
    metrics      = @{ Q = 'Q6'; Name = 'limites numéricos (§4.4)' }
    duplication  = @{ Q = 'Q8'; Name = 'duplicação abaixo do limite (§4.3)' }
}

try {
    $gp = Join-Path $Root '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $gp)) { [Console]::Error.WriteLine('quality: .team-project/guards.json não existe — rode na raiz do projeto ou passe -Root.'); exit 2 }
    $g = Read-Text $gp | ConvertFrom-Json
    $q = if ($g.PSObject.Properties['quality']) { $g.quality } else { $null }
    $limitMin = if ($TimeoutMinutes -gt 0) { $TimeoutMinutes } elseif ($q -and $q.timeoutMinutes) { [double]$q.timeoutMinutes } else { 9 }
    $envExtra = if ($g.verify -and $g.verify.PSObject.Properties['env']) { $g.verify.env } else { $null }
    $dir = (Get-VerifyDir $Root $Id) -replace '[\\/]verify[\\/]', '/quality/'
    New-Item -ItemType Directory -Force $dir | Out-Null
    $rows = @(); $envFail = @()

    foreach ($k in $rules.Keys) {
        $cmds = if ($q -and $q.PSObject.Properties[$k] -and $q.$k) { @(@($q.$k) | Where-Object { $_ }) } else { @() }
        if (-not $cmds.Count) { $rows += [ordered]@{ regra = $rules[$k].Q; nome = $rules[$k].Name; resultado = 'não configurado'; linha = "guards.json → quality.$k vazio: a regra fica com o julgamento do QA (Ficha de Vinculação)"; log = '' }; continue }
        $i = 0
        foreach ($c in $cmds) {
            $i++; $key = if ($i -gt 1) { "$k$i" } else { $k }
            $r = Invoke-ProjectCommand $Root $key ([string]$c) (Join-Path $dir "$key.log") $limitMin $envExtra
            $res = if ($r.environment) { 'ambiente' } elseif ([int]$r.exit -eq 0) { 'ok' } else { 'falhou' }
            $line = "exit $($r.exit) · $(@($r.decisive) | Select-Object -Last 1)"
            if ($k -eq 'coverage') {
                $pat = if ($q.coveragePattern) { [string]$q.coveragePattern } else { '(?i)(?:total|all files|line(?:s)?\s*coverage|cobertura|coverage)[^\d%\r\n]{0,40}?(\d+(?:[.,]\d+)?)\s*%' }
                $txt = [System.IO.File]::ReadAllText((Join-Path $Root $r.log), $utf8)
                $m = [regex]::Match($txt, $pat)
                $thr = if ($q.coverageThreshold) { [double]$q.coverageThreshold } else { 80 }
                if ($m.Success) {
                    $pct = [double]($m.Groups[1].Value -replace ',', '.')
                    $line = "$pct % medido × limiar $thr % · exit $($r.exit)"
                    if ($res -eq 'ok' -and $pct -lt $thr) { $res = 'falhou'; $line += ' (abaixo do limiar)' }
                } elseif ($res -eq 'ok') { $line += ' · percentual não lido da saída (ajuste quality.coveragePattern); vale o exit do gate' }
            }
            if ($r.environment) { $envFail += "$key`: $($r.environment)"; $line = $r.environment }
            $rows += [ordered]@{ regra = $rules[$k].Q; nome = $rules[$k].Name; resultado = $res; linha = $line; log = $r.log }
        }
    }

    # Buscas por padrão, sem ferramenta: Q9 (TODO/FIXME sem ID de Task) e Q17 (supressão sem justificativa na linha).
    $roots = if ($q -and $q.sourceRoots) { @($q.sourceRoots) } elseif ($g.sourceRoots -and @($g.sourceRoots).Count) { @($g.sourceRoots) } else { @('src') }
    $srcFiles = if ($Files.Count) { @($Files | ForEach-Object { [string]$_ -split ',' } | Where-Object { $_ } | ForEach-Object { Join-Path $Root $_.Trim() } | Where-Object { Test-Path -LiteralPath $_ }) }
                else { @($roots | ForEach-Object { $d = Join-Path $Root $_; if (Test-Path -LiteralPath $d) { Get-ChildItem -LiteralPath $d -Recurse -File -Include *.kt, *.kts, *.java, *.cs, *.ts, *.tsx, *.js, *.jsx, *.py, *.go -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch '[\\/](build|bin|obj|node_modules|dist|generated)[\\/]' } | ForEach-Object { $_.FullName } } }) }
    $todo = @(); $supp = @()
    foreach ($f in $srcFiles) {
        $n = 0; $rel = $f.Substring($Root.Length + 1) -replace '\\', '/'
        foreach ($ln in [System.IO.File]::ReadAllLines($f, $utf8)) {
            $n++
            if ($ln -match '\b(TODO|FIXME)\b' -and $ln -notmatch '\b(TODO|FIXME)\b[^\r\n]*\b([A-Z]-\d+|[A-Z]{2,}-\d+)\b') { $todo += "${rel}:$n" }
            if ($ln -match '(@Suppress(Warnings)?\(|eslint-disable|#pragma warning disable|// ?NOSONAR|@SuppressLint\(|noqa)' -and $ln -notmatch '(--|—|:|porque|motivo|because|reason)\s*\S{3,}') { $supp += "${rel}:$n" }
        }
    }
    $rows += [ordered]@{ regra = 'Q9'; nome = 'TODO/FIXME com ID de Task (§4.3)'; resultado = $(if ($todo.Count) { 'falhou' } else { 'ok' }); linha = $(if ($todo.Count) { "$($todo.Count) sem ID: " + (($todo | Select-Object -First 5) -join ', ') } else { "$($srcFiles.Count) arquivo(s) de produção lidos" }); log = '' }
    $rows += [ordered]@{ regra = 'Q17'; nome = 'supressão com justificativa (§4.4)'; resultado = $(if ($supp.Count) { 'falhou' } else { 'ok' }); linha = $(if ($supp.Count) { "$($supp.Count) sem justificativa na linha: " + (($supp | Select-Object -First 5) -join ', ') } else { 'nenhuma supressão sem justificativa' }); log = '' }

    $md = "# Qualidade · $Id · $(Get-Date -Format 'yyyy-MM-dd HH:mm')`n`n| Regra | O que | Resultado | Número / linha decisiva | Log |`n|---|---|---|---|---|`n"
    foreach ($r in $rows) { $md += "| $($r.regra) | $($r.nome) | $($r.resultado) | $(([string]$r.linha) -replace '\|', '/') | $($r.log) |`n" }
    [System.IO.File]::WriteAllText((Join-Path $dir 'result.md'), $md, $utf8)
    [System.IO.File]::WriteAllText((Join-Path $dir 'result.json'), ([ordered]@{ id = $Id; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); tree = (Get-WorkTree $Root); rows = $rows } | ConvertTo-Json -Depth 5), $utf8)
    $rel = $dir.Substring($Root.Length + 1) -replace '\\', '/'
    $bad = @($rows | Where-Object { $_.resultado -eq 'falhou' })
    [Console]::Out.WriteLine("quality $Id · " + $(if ($envFail.Count) { 'FALHA DE AMBIENTE' } elseif ($bad.Count) { "$($bad.Count) regra(s) falharam" } else { 'regras configuradas ok' }) + " · $rel/result.md")
    foreach ($r in $rows) { [Console]::Out.WriteLine("  $($r.regra) $($r.resultado): $($r.nome) — $($r.linha)") }
    if ($envFail.Count) { exit 4 }
    if ($bad.Count) { exit 1 }
    exit 0
} catch {
    [Console]::Error.WriteLine("quality: erro — $($_.Exception.Message)")
    exit 2
}
