# Funções comuns às conferências C1 (close.ps1), C2 (project.ps1) e C3 (release.ps1).
# Requisito: Windows PowerShell 5.1 (powershell.exe, o do Windows), sem recurso exclusivo do PowerShell 7.
# Lê tudo em UTF-8 explícito; os .ps1 são gravados em UTF-8 com BOM, que o 5.1 exige para ler acentos e emojis.

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$script:E = @{
    Done    = [char]::ConvertFromUtf32(0x2705)    # ✅
    Fail    = [char]::ConvertFromUtf32(0x274C)    # ❌
    Warn    = [char]::ConvertFromUtf32(0x26A0)    # ⚠
    Build   = [char]::ConvertFromUtf32(0x1F7E8)   # 🟨
    Plan    = [char]::ConvertFromUtf32(0x1F7E6)   # 🟦
    QA      = [char]::ConvertFromUtf32(0x1F7EA)   # 🟪
}

$script:Results = New-Object System.Collections.ArrayList

function Read-Text([string]$Path) {
    return [System.IO.File]::ReadAllText($Path, (New-Object System.Text.UTF8Encoding($false)))
}

function Add-Result([string]$Rule, [string]$Status, [string]$Line) {
    [void]$script:Results.Add([pscustomobject]@{ Regra = $Rule; Resultado = $Status; Linha = ($Line -replace '\|', '/' -replace '\s+', ' ').Trim() })
}

function Write-Results([string]$Title) {
    $out = New-Object System.Text.StringBuilder
    [void]$out.AppendLine("### $Title")
    [void]$out.AppendLine('')
    [void]$out.AppendLine('| Regra | Resultado | Linha decisiva |')
    [void]$out.AppendLine('|---|---|---|')
    foreach ($r in $script:Results) { [void]$out.AppendLine("| $($r.Regra) | $($r.Resultado) | $($r.Linha) |") }
    [Console]::Out.Write($out.ToString())
}

# Seção: da linha que casa $HeadingRegex até a próxima de nível igual ou maior. $null se não existir.
function Get-Section([string]$Text, [string]$HeadingRegex) {
    $lines = $Text -split "`r?`n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match $HeadingRegex) {
            $level = ([regex]::Match($lines[$i], '^#+')).Length
            $buf = New-Object System.Collections.ArrayList
            for ($j = $i + 1; $j -lt $lines.Count; $j++) {
                $m = [regex]::Match($lines[$j], '^(#+)\s')
                if ($m.Success -and $m.Groups[1].Length -le $level) { break }
                [void]$buf.Add($lines[$j])
            }
            return ($buf -join "`n")
        }
    }
    return $null
}

function Split-Row([string]$Line) {
    $t = $Line.Trim()
    if ($t.StartsWith('|')) { $t = $t.Substring(1) }
    if ($t.EndsWith('|')) { $t = $t.Substring(0, $t.Length - 1) }
    return @($t -split '(?<!\\)\|' | ForEach-Object { $_.Trim() })
}

function Clean-Cell([string]$Cell) { return ($Cell -replace '\*\*', '' -replace '`', '').Trim() }

# Tabelas Markdown do texto: cada uma com Header (células limpas) e Rows (células cruas), sem a linha |---|.
function Get-Tables([string]$Text) {
    $tables = New-Object System.Collections.ArrayList
    $cur = $null
    foreach ($line in ($Text -split "`r?`n")) {
        if ($line.TrimStart().StartsWith('|')) {
            $cells = Split-Row $line
            if ($null -eq $cur) {
                $cur = @{ Header = @($cells | ForEach-Object { Clean-Cell $_ }); Rows = (New-Object System.Collections.ArrayList) }
            } elseif ($line -match '^\s*\|[\s:\-|]+\|\s*$') {
                continue
            } else {
                [void]$cur.Rows.Add($cells)
            }
        } elseif ($null -ne $cur) {
            [void]$tables.Add($cur); $cur = $null
        }
    }
    if ($null -ne $cur) { [void]$tables.Add($cur) }
    return ,$tables
}

function Find-Col($Table, [string]$Name) {
    for ($i = 0; $i -lt $Table.Header.Count; $i++) { if ($Table.Header[$i] -like "*$Name*") { return $i } }
    return -1
}

function Get-Cell($Row, [int]$Index) {
    if ($Index -lt 0 -or $Index -ge $Row.Count) { return '' }
    return [string]$Row[$Index]
}

function Test-Placeholder([string]$Cell) {
    $c = Clean-Cell $Cell
    return ([string]::IsNullOrWhiteSpace($c) -or $c -match '<[^>]+>')
}

# Veredito de uma linha **Veredito:** — o PRIMEIRO marcador (✅ ⚠ ❌); o histórico que vem depois não conta. $null se nenhum.
function Get-VerdictMark([string]$Line) {
    $first = $null; $at = [int]::MaxValue
    foreach ($mk in $E.Done, $E.Warn, $E.Fail) { $ix = $Line.IndexOf($mk); if ($ix -ge 0 -and $ix -lt $at) { $at = $ix; $first = $mk } }
    return $first
}

# Primeira data do texto: aaaa-mm-dd ou dd/mm/aaaa. $null se nenhuma.
function Get-FirstDate([string]$Text) {
    $m = [regex]::Match($Text, '(\d{4})-(\d{2})-(\d{2})')
    if ($m.Success) { return Get-Date -Year $m.Groups[1].Value -Month $m.Groups[2].Value -Day $m.Groups[3].Value -Hour 0 -Minute 0 -Second 0 -Millisecond 0 }
    $m = [regex]::Match($Text, '(\d{2})/(\d{2})/(\d{4})')
    if ($m.Success) { return Get-Date -Year $m.Groups[3].Value -Month $m.Groups[2].Value -Day $m.Groups[1].Value -Hour 0 -Minute 0 -Second 0 -Millisecond 0 }
    return $null
}

# Rótulo de tabela de duas colunas (| **Rótulo** | valor |): devolve o valor da 1ª linha cujo rótulo começa com $Label.
function Get-LabelValue([string]$Text, [string]$Label) {
    foreach ($t in (Get-Tables $Text)) {
        foreach ($row in (@(, $t.Header) + @($t.Rows))) {
            if ($row.Count -ge 2 -and (Clean-Cell $row[0]).StartsWith($Label)) { return [string]$row[1] }
        }
    }
    return $null
}

function Get-IdPattern([string]$Id) { return '(?<![\w-])' + [regex]::Escape($Id) + '(?![\w])' }

# Impressão digital da árvore de trabalho (v3.45.1): o tree do git com tudo o que está no disco — rastreado, alterado e
# novo não ignorado —, montado num índice temporário (o índice do projeto não é tocado) e sem .team-project/ (R31).
# Mesma impressão = mesmo código: evidência de verify.ps1 com ela vale sem reexecução. $null fora de um repositório git.
function Get-WorkTree([string]$Root) {
    $ErrorActionPreference = 'Continue'   # no 5.1, stderr do git (aviso de CRLF) viraria exceção com 'Stop'
    $top = & git -C $Root rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $top) { return $null }
    $idx = [System.IO.Path]::GetTempFileName()
    $old = $env:GIT_INDEX_FILE
    try {
        Remove-Item -LiteralPath $idx -Force
        $env:GIT_INDEX_FILE = $idx
        & git -C $top rev-parse --verify -q HEAD *> $null
        if ($LASTEXITCODE -eq 0) { & git -C $top read-tree HEAD 2>$null } else { & git -C $top read-tree --empty 2>$null }
        & git -C $top add -A -- . ':(exclude).team-project' 2>$null
        $tree = & git -C $top write-tree 2>$null
        if ($LASTEXITCODE -ne 0) { return $null }
        return ([string]$tree).Trim()
    } finally {
        if ($null -eq $old) { Remove-Item Env:GIT_INDEX_FILE -ErrorAction SilentlyContinue } else { $env:GIT_INDEX_FILE = $old }
        Remove-Item -LiteralPath $idx -Force -ErrorAction SilentlyContinue
    }
}

# Pasta da evidência mecânica de um trabalho: .team-project/verify/<sprint|B-nnn|pre-sprint>/<ID>/.
function Get-VerifyDir([string]$Root, [string]$Id) {
    $tp = Join-Path $Root '.team-project'
    $seg = 'pre-sprint'
    if ($Id -match '^[FB]-\d+') {
        $run = Join-Path $tp '.active-run'
        if ($Id -match '^B-\d+$') { $seg = $Id }
        elseif (Test-Path -LiteralPath $run) { try { $r = Get-Content -LiteralPath $run -Raw -Encoding UTF8 | ConvertFrom-Json; if ([string]$r.trilha -eq 'fix') { $seg = [string]$r.id } } catch { } }
    } else {
        $readme = Join-Path $tp 'README.md'
        if (Test-Path -LiteralPath $readme) {
            $m = [regex]::Match((Read-Text $readme), '(?m)^\|\s*\*\*Sprint corrente\*\*\s*\|\s*\*\*(\d+)\*\*')
            if ($m.Success) { $seg = $m.Groups[1].Value }
        }
    }
    return (Join-Path $tp "verify/$seg/$Id")
}

# Registro de transições (R24): vive no burndown.md do sprint (v3.44.1); sprint aberto antes disso o tem no sprint-backlog.md. $null se nenhum.
function Get-TransitionLog([string]$SprintDir, [string]$Board) {
    $bd = Join-Path $SprintDir 'burndown.md'
    if (Test-Path -LiteralPath $bd) { $s = Get-Section (Read-Text $bd) '^##\s+Registro de transi'; if ($s) { return $s } }
    if ($Board) { return Get-Section $Board '^##\s+Registro de transi' }
    return $null
}
