# C3 — conferência de entrega no REPOSITÓRIO-FONTE do plugin: R18 (versão igual nos três lugares e par com o
# changelog do processo), R17 (tamanho do bloco da versão que sai e no máximo 3 entradas vivas) e modelos órfãos.
# Uso, na raiz do clone, antes do PR e no /review audit: powershell -NoProfile -File scripts/checks/release.ps1
# Exit 1 se R17 ou R18 falharem · 2 = erro de uso (não é o repositório-fonte) · senão 0 (órfão é aviso).

param([string]$Root = (Get-Location).Path)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')

try {
    $pj = Join-Path $Root '.claude-plugin/plugin.json'
    $chPath = Join-Path $Root 'CHANGELOG.md'
    $pcPath = Join-Path $Root 'roles/scrum-master/process/process-changelog.md'
    foreach ($p in $pj, $chPath, $pcPath, (Join-Path $Root 'README.md')) {
        if (-not (Test-Path -LiteralPath $p)) { [Console]::Error.WriteLine("C3: $p não existe — rode na raiz do repositório-fonte do plugin."); exit 2 }
    }

    # ---------- R18 ----------
    $v1 = [string](Read-Text $pj | ConvertFrom-Json).version
    $ch = Read-Text $chPath
    $m2 = [regex]::Match($ch, '(?m)^## v(\d+\.\d+\.\d+)\s')
    $v2 = if ($m2.Success) { $m2.Groups[1].Value } else { '' }
    $readmeLines = (Read-Text (Join-Path $Root 'README.md')) -split "`r?`n"
    $m3 = if ($readmeLines.Count -ge 3) { [regex]::Match($readmeLines[2], '^>\s*\*\*Vers[ãa]o atual:\s*v(\d+\.\d+\.\d+)\*\*') } else { $null }
    $v3 = if ($m3 -and $m3.Success) { $m3.Groups[1].Value } else { '' }
    $pc = Read-Text $pcPath
    $liveProc = @([regex]::Matches($pc, '(?m)^## v(\d+\.\d+)\s') | ForEach-Object { $_.Groups[1].Value })
    $unpaired = @($liveProc | Where-Object { $ch -notmatch ('(?m)^## v' + [regex]::Escape($_) + '\.\d+\s') })
    if ($v1 -eq $v2 -and $v2 -eq $v3 -and $v1 -and $unpaired.Count -eq 0) {
        Add-Result 'R18' 'ok' "plugin.json = CHANGELOG = README L3 = v$v1; processo $($liveProc -join ', ') com entrega"
    } else {
        $iss = @()
        if (-not ($v1 -eq $v2 -and $v2 -eq $v3 -and $v1)) { $iss += "plugin.json v$v1 · CHANGELOG v$v2 · README L3 v$v3" }
        if ($unpaired.Count) { $iss += 'processo sem entrega no CHANGELOG: ' + (($unpaired | ForEach-Object { "v$_" }) -join ', ') }
        Add-Result 'R18' 'falhou' ($iss -join '; ')
    }

    # ---------- R17 ----------
    $r17 = @(); $r17ok = ''
    if ($liveProc.Count -gt 3) { $r17 += "$($liveProc.Count) entradas vivas no process-changelog.md (máximo 3 — arquive a mais antiga)" }
    $xy = if ($v2) { ($v2 -split '\.')[0..1] -join '.' } else { '' }
    $bm = [regex]::Match($pc, '(?ms)^## v' + [regex]::Escape($xy) + '\s.*?(?=^## |\z)')
    if (-not $xy -or -not $bm.Success) { $r17 += "bloco ## v$xy ausente no process-changelog.md" }
    else {
        $bytes = [System.Text.Encoding]::UTF8.GetByteCount($bm.Value)
        $title = ($bm.Value -split "`r?`n")[0]
        $rm = [regex]::Matches($title, '\(([^()]*)\)\s+—\s+\d')
        $roles = 2; $note = ''
        if ($rm.Count) { $roles = @($rm[$rm.Count - 1].Groups[1].Value -split '\+' | Where-Object { $_.Trim() }).Count } else { $note = ' (papéis não declarados no título: usando 2)' }
        $limit = [Math]::Min(20480, 10240 + 2560 * [Math]::Max(0, $roles - 2))
        if ($bytes -gt $limit) { $r17 += "bloco v$xy com $bytes bytes > barreira $limit ($roles papéis)$note" }
        else { $r17ok = "bloco v$xy com $bytes bytes ≤ barreira $limit ($roles papéis)$note; $($liveProc.Count) entradas vivas" }
    }
    $disk = (Get-Item -LiteralPath $pcPath).Length
    $raw = [System.IO.File]::ReadAllBytes($pcPath)
    $bom = if ($raw.Length -ge 3 -and $raw[0] -eq 0xEF -and $raw[1] -eq 0xBB -and $raw[2] -eq 0xBF) { 3 } else { 0 }
    if ([System.Text.Encoding]::UTF8.GetByteCount($pc) + $bom -ne $disk) { $r17 += "leitura UTF-8 ($([System.Text.Encoding]::UTF8.GetByteCount($pc)) B) ≠ disco ($disk B): arquivo com encoding inesperado" }
    if ($r17.Count) { Add-Result 'R17' 'falhou' ($r17 -join '; ') } else { Add-Result 'R17' 'ok' $r17ok }

    # ---------- .ps1 em UTF-8 com BOM (requisito: Windows PowerShell 5.1 lê .ps1 sem BOM como ANSI) ----------
    $ps1 = @(Get-ChildItem -LiteralPath $Root -Recurse -File -Filter '*.ps1' | Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' })
    $noBom = @()
    foreach ($f in $ps1) {
        $b = New-Object byte[] 3
        $fs = [System.IO.File]::OpenRead($f.FullName); try { $n = $fs.Read($b, 0, 3) } finally { $fs.Dispose() }
        if (-not ($n -eq 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF)) { $noBom += ($f.FullName.Substring($Root.Length + 1) -replace '\\', '/') }
    }
    if ($noBom.Count) { Add-Result 'ps1-5.1' 'falhou' ("sem BOM (o Windows PowerShell 5.1 quebra acento e emoji): " + ($noBom -join ', ')) }
    else { Add-Result 'ps1-5.1' 'ok' "$($ps1.Count) script(s) .ps1 em UTF-8 com BOM" }

    # ---------- Modelos órfãos (aviso) ----------
    $templates = @(Get-ChildItem -Path (Join-Path $Root 'roles') -Recurse -File -Filter '*.md' | Where-Object { $_.Directory.Name -eq 'templates' })
    $corpus = @(Get-ChildItem -LiteralPath $Root -Recurse -File -Include '*.md', '*.json' | Where-Object {
        $_.FullName -notmatch '[\\/]\.git[\\/]' -and $_.Name -ne 'CHANGELOG.md' -and $_.Name -notlike 'process-changelog*.md' -and $_.Name -notlike 'proposta-*.md' })
    $texts = @{}; foreach ($f in $corpus) { $texts[$f.FullName] = Read-Text $f.FullName }
    $names = @{}; foreach ($f in (Get-ChildItem -LiteralPath $Root -Recurse -File -Filter '*.md' | Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' })) { $names[$f.Name] = 1 + [int]$names[$f.Name] }
    $orphans = @()
    foreach ($t in $templates) {
        $pat = if ($names[$t.Name] -gt 1) { 'templates/' + [regex]::Escape($t.Name) } else { '(?<![\w-])' + [regex]::Escape($t.Name) + '(?!\w)' }
        $hit = $false
        foreach ($k in $texts.Keys) { if ($k -ne $t.FullName -and $texts[$k] -match $pat) { $hit = $true; break } }
        if (-not $hit) { $orphans += ($t.FullName.Substring($Root.Length + 1) -replace '\\', '/') }
    }
    if ($orphans.Count) { Add-Result 'órfãos' 'aviso' ("$($orphans.Count) modelo(s) sem referência: " + ($orphans -join ', ')) }
    else { Add-Result 'órfãos' 'ok' "$($templates.Count) modelos, todos referenciados" }

    Write-Results "C3 · entrega v$v1"
    if (@($script:Results | Where-Object { $_.Regra -in 'R17', 'R18', 'ps1-5.1' -and $_.Resultado -eq 'falhou' }).Count) { exit 1 }
    exit 0
} catch {
    [Console]::Error.WriteLine("C3: erro — $($_.Exception.Message)")
    exit 2
}
