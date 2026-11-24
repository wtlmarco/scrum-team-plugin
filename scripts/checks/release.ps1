# C3 — conferência de entrega no REPOSITÓRIO-FONTE do plugin: R18 (versão igual nos três lugares e par com o
# changelog do processo), R17 (tamanho do bloco da versão que sai e no máximo 3 entradas vivas), .ps1 com BOM,
# hooks/ownership.json × artifact-ownership.md §1 (G8) e modelos órfãos.
# Uso, na raiz do clone, antes do PR e no /review audit: powershell -NoProfile -File scripts/checks/release.ps1
# Exit 1 se R17, R18, ps1-5.1 ou ownership falharem · 2 = erro de uso (não é o repositório-fonte) · senão 0 (órfão é aviso).

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

    # ---------- hooks/ownership.json × artifact-ownership.md §1 (G8: a matriz é a fonte única) ----------
    $ownPath = Join-Path $Root 'hooks/ownership.json'
    $aoPath = Join-Path $Root 'roles/scrum-master/process/artifact-ownership.md'
    if (Test-Path -LiteralPath $ownPath) {
        $own = Read-Text $ownPath | ConvertFrom-Json
        $sec = [regex]::Match((Read-Text $aoPath), '(?ms)^## 1\. Matriz.*?(?=^### 1a\.)').Value
        $rows = @(($sec -split "`r?`n") | Where-Object { $_ -match '^\|' } | ForEach-Object {
            $cells = @(($_ -split '(?<!\\)\|') | ForEach-Object { $_.Trim() })
            [pscustomobject]@{ Artefato = $cells[1] + ' ¦ ' + ($cells[1] -replace '\*\*', ''); Dono = $cells[2] + ' ¦ ' + ($cells[2] -replace '\*\*', '') } })   # crua e sem negrito: glob entre crases tem "**"
        $bad = @(); $n = 0; $noRow = 0
        foreach ($set in 'project', 'pluginSource') {
            foreach ($rule in @($own.$set)) {
                foreach ($w in @($rule.writers)) { if ($null -eq $own.roles.$w) { $bad += "papel '$w' sem nome em roles ($($rule.paths -join ', '))" } }
                if (-not $rule.matriz) { if (-not $rule.nota) { $bad += "regra sem 'matriz' nem 'nota' ($($rule.paths -join ', '))" }; $noRow++; continue }
                $n++
                $hit = @($rows | Where-Object { $_.Artefato.Contains([string]$rule.matriz) })
                if (-not $hit.Count) { $bad += "linha '$($rule.matriz)' não existe em §1" }
                elseif (-not @($hit | Where-Object { $_.Dono.Contains([string]$rule.dono) }).Count) { $bad += "linha '$($rule.matriz)': dono '$($rule.dono)' não está na coluna Dono" }
            }
        }
        if ($bad.Count) { Add-Result 'ownership' 'falhou' ($bad -join '; ') }
        else { Add-Result 'ownership' 'ok' "$n regra(s) batem com a linha e o dono de §1; $noRow com nota (pasta do papel ou sem linha)" }
    } else { Add-Result 'ownership' 'falhou' 'hooks/ownership.json ausente (G8)' }

    # ---------- hooks/impasses.json × impasse-matrix.md §1 (v3.66.0, R36: a matriz é a fonte única) ----------
    # Os dois arquivos com os mesmos tipos, donos, subida, evidência, "só por script" e rotas antigas; e toda rota que o
    # run.ps1 e o gate.ps1 gravam (Set-AskRoute) existe na matriz — a regra não volta a se espalhar.
    $imJ = Join-Path $Root 'hooks/impasses.json'; $imM = Join-Path $Root 'roles/scrum-master/process/impasse-matrix.md'
    if ((Test-Path -LiteralPath $imJ) -and (Test-Path -LiteralPath $imM)) {
        $ij = Read-Text $imJ | ConvertFrom-Json
        $imText = Read-Text $imM
        $isec = [regex]::Match($imText, '(?ms)^## 1\. Matriz.*?(?=^### 1a\.|^## 2\.)').Value
        $mrows = @{}
        foreach ($ln in ($isec -split "`r?`n")) {
            if ($ln -notmatch '^\|\s*`([a-z-]+)`') { continue }
            $cl = @(($ln -split '\|') | ForEach-Object { $_.Trim() })
            $lr = @([regex]::Matches($cl[6], '`([a-z-]+)`') | ForEach-Object { $_.Groups[1].Value })
            $mrows[$cl[1].Trim('`')] = [pscustomobject]@{ Owner = $cl[2].Trim('`'); Reach = $cl[3].Trim('`'); Ev = $cl[4].Trim('`'); Script = ($cl[5] -eq 'sim'); Legacy = (@($lr | Sort-Object) -join ',') }
        }
        $ibad = @()
        $jtypes = @{}; foreach ($t in @($ij.types)) { $jtypes[[string]$t.type] = $t }
        foreach ($k in $jtypes.Keys) {
            if (-not $mrows.ContainsKey($k)) { $ibad += "tipo '$k' no JSON e não na matriz"; continue }
            $t = $jtypes[$k]; $r = $mrows[$k]
            if ([string]$t.owner -ne $r.Owner) { $ibad += "${k}: dono '$($t.owner)' no JSON × '$($r.Owner)' na matriz" }
            if ([string]$t.reachesStakeholder -ne $r.Reach) { $ibad += "${k}: subida '$($t.reachesStakeholder)' × '$($r.Reach)'" }
            if ([string]$t.evidence -ne $r.Ev) { $ibad += "${k}: evidência '$($t.evidence)' × '$($r.Ev)'" }
            if ([bool]$t.scriptOnly -ne $r.Script) { $ibad += "${k}: só por script $([bool]$t.scriptOnly) × $($r.Script)" }
            if (((@($t.legacyRoutes) | Sort-Object) -join ',') -ne $r.Legacy) { $ibad += "${k}: rotas antigas '$(@($t.legacyRoutes) -join ',')' × '$($r.Legacy)'" }
        }
        foreach ($k in $mrows.Keys) { if (-not $jtypes.ContainsKey($k)) { $ibad += "tipo '$k' na matriz e não no JSON" } }
        # §1a causas e §1b papéis (etapa 2): iguais no JSON; o tipo de cada causa existe e o dono dele tem papel em §1b.
        $cSec = [regex]::Match($imText, '(?ms)^### 1a\..*?(?=^### 1b\.|^## 2\.)').Value
        $rSec = [regex]::Match($imText, '(?ms)^### 1b\..*?(?=^## 2\.)').Value
        $mCauses = @{}; foreach ($ln in ($cSec -split "`r?`n")) { $cm = [regex]::Match($ln, '^\|\s*`([a-z-]+)`\s*\|\s*`([a-z-]+)`\s*\|\s*([^|]+?)\s*\|'); if ($cm.Success) { $mCauses[$cm.Groups[1].Value] = "$($cm.Groups[2].Value)|$($cm.Groups[3].Value)" } }
        $mRoles = @{}; foreach ($ln in ($rSec -split "`r?`n")) { $rm = [regex]::Match($ln, '^\|\s*`([a-z-]+)`\s*\|\s*`([^`]+)`\s*\|\s*([^|]+?)\s*\|'); if ($rm.Success) { $mRoles[$rm.Groups[1].Value] = "$($rm.Groups[2].Value)|$($rm.Groups[3].Value)" } }
        $jCauses = @{}; if ($ij.causes) { foreach ($pp in $ij.causes.PSObject.Properties) { $jCauses[$pp.Name] = "$([string]$pp.Value.type)|$([string]$pp.Value.label)" } }
        $jRoles = @{}; if ($ij.roles) { foreach ($pp in $ij.roles.PSObject.Properties) { $jRoles[$pp.Name] = "$([string]$pp.Value.command)|$([string]$pp.Value.short)" } }
        foreach ($pair in @(@{ M = $mCauses; J = $jCauses; N = 'causa' }, @{ M = $mRoles; J = $jRoles; N = 'papel' })) {
            foreach ($k in $pair.J.Keys) { if (-not $pair.M.ContainsKey($k)) { $ibad += "$($pair.N) '$k' no JSON e não na matriz" } elseif ($pair.M[$k] -ne $pair.J[$k]) { $ibad += "$($pair.N) '${k}': '$($pair.J[$k])' no JSON × '$($pair.M[$k])' na matriz" } }
            foreach ($k in $pair.M.Keys) { if (-not $pair.J.ContainsKey($k)) { $ibad += "$($pair.N) '$k' na matriz e não no JSON" } }
        }
        foreach ($k in $jCauses.Keys) {
            $ct = ($jCauses[$k] -split '\|')[0]
            if (-not $jtypes.ContainsKey($ct)) { $ibad += "causa '$k' aponta o tipo '$ct', que não existe" }
            elseif (-not $jRoles.ContainsKey([string]$jtypes[$ct].owner)) { $ibad += "causa '$k': o dono '$($jtypes[$ct].owner)' do tipo '$ct' sem papel em §1b" }
        }
        $known = @{}; foreach ($t in @($ij.types)) { $known[[string]$t.type] = 1; foreach ($l in @($t.legacyRoutes)) { $known[[string]$l] = 1 } }
        $routes = @{}
        $scDir = Join-Path $Root 'scripts/checks'
        foreach ($sf in @(if (Test-Path -LiteralPath $scDir) { Get-ChildItem -LiteralPath $scDir -Filter '*.ps1' -File })) {
            foreach ($mm in [regex]::Matches((Read-Text $sf.FullName), 'Set-AskRoute\s+\$Root\s+(\$\(if[^\r\n]*?\}\s*\)|''[^'']*'')')) {
                foreach ($q in [regex]::Matches($mm.Groups[1].Value, "'([a-z-]*)'")) { $v = $q.Groups[1].Value; if ($v) { $routes[$v] = $sf.Name } }
            }
        }
        foreach ($rt in $routes.Keys) { if (-not $known.ContainsKey($rt)) { $ibad += "rota '$rt' ($($routes[$rt])) sem tipo na matriz" } }
        if (@($ij.offerPhrases).Count) { foreach ($p in @($ij.offerPhrases)) { try { $null = [regex]::new([string]$p) } catch { $ibad += "offerPhrases: regex inválida '$p'" } } }
        if ($ibad.Count) { Add-Result 'impasses' 'falhou' ($ibad -join '; ') }
        else { Add-Result 'impasses' 'ok' "$($jtypes.Count) tipo(s) iguais na matriz e no JSON; $($routes.Count) rota(s) dos scripts com tipo" }
    } else { Add-Result 'impasses' 'falhou' 'hooks/impasses.json ou roles/scrum-master/process/impasse-matrix.md ausente (R36)' }

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
    if (@($script:Results | Where-Object { $_.Regra -in 'R17', 'R18', 'ps1-5.1', 'ownership', 'impasses' -and $_.Resultado -eq 'falhou' }).Count) { exit 1 }
    exit 0
} catch {
    [Console]::Error.WriteLine("C3: erro — $($_.Exception.Message)")
    exit 2
}
