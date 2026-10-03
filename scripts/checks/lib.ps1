# Funções comuns às conferências C1 (close.ps1), C2 (project.ps1) e C3 (release.ps1).
# Requisito: Windows PowerShell 5.1 (powershell.exe, o do Windows), sem recurso exclusivo do PowerShell 7.
# Lê tudo em UTF-8 explícito; os .ps1 são gravados em UTF-8 com BOM, que o 5.1 exige para ler acentos e emojis.

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$script:E = @{
    Done    = [char]::ConvertFromUtf32(0x2705)    # ✅
    Fail    = [char]::ConvertFromUtf32(0x274C)    # ❌
    Warn    = [char]::ConvertFromUtf32(0x26A0)    # ⚠
    Build   = [char]::ConvertFromUtf32(0x1F7E8)   # 🟨
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
