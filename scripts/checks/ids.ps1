# Ids de teste (v3.55.0, C5 e D1): o mapa de ids gerado do CÓDIGO e a auditoria da instalação. A convenção está em
# standards/test-ids.md; o atributo vem de guards.json → testIds.attribute (depois targets.web.testIdAttribute e data-testid).
# Uso (a partir da raiz do projeto):
#   powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/ids.ps1" -Map [-Root <projeto>]
#   powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/ids.ps1" -Audit [-Root <projeto>]
# -Map    varre quality.sourceRoots (ou sourceRoots; sem eles, o código fora de .team-project/ e docs/) e grava
#         .team-project/architect/ids-map.md ("gerado por ids.ps1 — não editar"): por arquivo, os ids do atributo configurado —
#         literais e prefixos dinâmicos ('x.linha.' + id, x.linha.{{ id }}, `x.linha.${id}`, "x.linha.$id" → x.linha.<…>).
#         Nunca se escreve à mão: um documento escrito à mão desatualiza.
# -Audit  SÓ LEITURA do código; grava .team-project/architect/ids-audit.md com seis seções: (1) atributo detectado pela stack ×
#         configurado · (2) telas e controles sem id, no código todo · (3) ids fora da gramática · (4) ids dos .scn que não
#         existem no código · (5) seletores por texto onde há id (a conferir) · (6) planos do sprint aberto que citam id fora do
#         mapa. Sai SEMPRE com exit 0 (é informativo): o /team update (passo 7l) resume e pergunta; nunca corrige.
# Exit 0 = gravou · 2 = erro de uso (sem -Map nem -Audit).

param(
    [switch]$Map,
    [switch]$Audit,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
. (Join-Path $PSScriptRoot '..\..\hooks\common.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)
if (-not $Map -and -not $Audit) { [Console]::Error.WriteLine('ids: use -Map (grava .team-project/architect/ids-map.md) ou -Audit (grava ids-audit.md).'); exit 2 }
$Root = (Resolve-Path -LiteralPath $Root).Path
$attr = Get-TestIdAttribute $Root
$gram = '^[a-z0-9]+(-[a-z0-9]+)*(\.[a-z0-9]+(-[a-z0-9]+)*)*$'

# Arquivos de produção onde um id mora: os de Get-TestIdSourceFiles, dentro de quality.sourceRoots / sourceRoots, se houver.
function Get-IdFiles {
    $files = @(Get-TestIdSourceFiles $Root)
    $roots = @()
    $gp = Join-Path $Root '.team-project/guards.json'
    if (Test-Path -LiteralPath $gp) { try { $j = Read-Text $gp | ConvertFrom-Json; if ($j.PSObject.Properties['quality'] -and $j.quality -and $j.quality.PSObject.Properties['sourceRoots']) { $roots = @(@($j.quality.sourceRoots) | Where-Object { $_ }) } } catch { } }
    if (-not $roots.Count) { $roots = @(@((Get-GuardConfig $Root).sourceRoots) | Where-Object { $_ }) }
    if ($roots.Count) {
        $pre = @($roots | ForEach-Object { (([string]$_).Trim() -replace '\\', '/').TrimEnd('/') + '/' })
        $files = @($files | Where-Object { $f = ($_ -replace '\\', '/'); @($pre | Where-Object { $f.StartsWith($_, [StringComparison]::OrdinalIgnoreCase) }).Count -gt 0 })
    }
    return $files
}

# O valor de um atributo de id vira @{ Id; Dyn }: literal, ou prefixo de id dinâmico. $null quando não há literal para mapear.
function ConvertTo-IdValue([string]$V, [bool]$Binding) {
    $V = $V.Trim()
    if ($Binding) {
        $m = [regex]::Match($V, "^'([^']*)'\s*(\+|$)")   # [attr.id]="'x.linha.' + id" · [id]="'x.titulo'"
        if (-not $m.Success -or -not $m.Groups[1].Value) { return $null }
        return @{ Id = $m.Groups[1].Value; Dyn = ($m.Groups[2].Value -eq '+') }
    }
    $i = [regex]::Match($V, '\{\{|\$\{|\$')
    if ($i.Success) { if ($i.Index -eq 0) { return $null }; return @{ Id = $V.Substring(0, $i.Index); Dyn = $true } }
    if (-not $V) { return $null }
    return @{ Id = $V; Dyn = $false }
}

# Ids de um arquivo: @{ Id; Dyn; Line }. Kotlin: testTag("…") (literal ou "x.$id"); web: o atributo configurado em todas as formas.
function Get-IdsInText([string]$Rel, [string]$Text) {
    $out = @(); if (-not $Text) { return $out }
    $line = { param($ix) 1 + ([regex]::Matches($Text.Substring(0, $ix), "`n")).Count }
    if ($Rel -match '\.kt$') {
        foreach ($m in [regex]::Matches($Text, 'testTag\s*\(\s*"([^"]*)"')) { $v = ConvertTo-IdValue $m.Groups[1].Value $false; if ($v) { $out += @{ Id = $v.Id; Dyn = $v.Dyn; Line = (& $line $m.Index) } } }
        return $out
    }
    if ($Rel -notmatch '\.(html?|tsx|jsx|vue)$') { return $out }
    $re = '(?<![\w.\-])(\[attr\.|\[|:|v-bind:)?' + [regex]::Escape($attr) + '\]?\s*=\s*(?:"([^"]*)"|''([^'']*)''|\{\s*`([^`]*)`\s*\}|\{\s*"([^"]*)"\s*\}|\{\s*''([^'']*)''\s*\})'
    foreach ($m in [regex]::Matches($Text, $re)) {
        $binding = [bool]$m.Groups[1].Value
        $val = $null; foreach ($g in 2..6) { if ($m.Groups[$g].Success) { $val = $m.Groups[$g].Value; break } }
        if ($null -eq $val) { continue }
        $v = ConvertTo-IdValue $val $binding
        if ($v) { $out += @{ Id = $v.Id; Dyn = $v.Dyn; Line = (& $line $m.Index) } }
    }
    return $out
}

function Get-IdMap {
    $map = [ordered]@{}
    foreach ($f in @(Get-IdFiles | Sort-Object)) {
        $p = Join-Path $Root $f; if (-not (Test-Path -LiteralPath $p -PathType Leaf)) { continue }
        $ids = @(Get-IdsInText ($f -replace '\\', '/') ((Read-Text $p) -replace "`r", ''))
        if ($ids.Count) { $map[($f -replace '\\', '/')] = $ids }
    }
    return $map
}
function Format-Id($I) { if ($I.Dyn) { return $I.Id + '<…>' } else { return $I.Id } }

function Write-Doc([string]$Rel, [string]$Body) {
    $p = Join-Path $Root $Rel
    New-Item -ItemType Directory -Force (Split-Path $p -Parent) | Out-Null
    [System.IO.File]::WriteAllText($p, $Body, $utf8)
}

$idMap = Get-IdMap
$stamp = Get-Date -Format 'yyyy-MM-dd HH:mm'

if ($Map) {
    $sb = New-Object System.Text.StringBuilder
    $total = 0; foreach ($k in $idMap.Keys) { $total += @($idMap[$k] | ForEach-Object { Format-Id $_ } | Select-Object -Unique).Count }
    [void]$sb.AppendLine('<!-- gerado por ids.ps1 — não editar -->')
    [void]$sb.AppendLine('# Mapa de ids de teste')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine("> **gerado por ids.ps1 — não editar.** Refaça com `ids.ps1 -Map`. Atributo: ``$attr`` · $stamp · $($idMap.Count) arquivo(s) · $total id(s). ``<…>`` = o resto do id vem de dado (chave da entidade). Convenção: ``standards/test-ids.md``.")
    foreach ($k in $idMap.Keys) {
        [void]$sb.AppendLine(''); [void]$sb.AppendLine("## $k")
        foreach ($i in @($idMap[$k] | Sort-Object { Format-Id $_ } -Unique)) { [void]$sb.AppendLine("- ``$(Format-Id $i)`` (linha $($i.Line))") }
    }
    Write-Doc '.team-project/architect/ids-map.md' $sb.ToString()
    [Console]::Out.WriteLine("ids -Map: $total id(s) em $($idMap.Count) arquivo(s) (atributo $attr) → .team-project/architect/ids-map.md")
}

if ($Audit) {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine('<!-- gerado por ids.ps1 -Audit — informativo; não corrige nada -->')
    [void]$sb.AppendLine('# Auditoria de ids de teste')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine("> Gerado por ``ids.ps1 -Audit`` em $stamp. **Só leitura:** nada no código, nos planos aprovados nem nos ``.scn`` foi alterado. A decisão é do stakeholder; a correção passa pelo processo (Habilitadora).")

    # 1 · atributo detectado × configurado
    $all = @(& git -C $Root ls-files -co --exclude-standard 2>$null)
    $det = 'data-testid'; $why = 'nenhum sinal de app híbrido nem de Compose'
    $hyb = @($all | Where-Object { $_ -match '(^|/)(capacitor\.config\.(ts|js|json)|ionic\.config\.json)$' } | Select-Object -First 1)
    if ($hyb.Count) { $det = 'id'; $why = "app híbrido ($($hyb[0]))" }
    else {
        foreach ($cx in @($all | Where-Object { $_ -match '(^|/)config\.xml$' } | Select-Object -First 3)) { if ((Read-Text (Join-Path $Root $cx)) -match 'cordova') { $det = 'id'; $why = "app híbrido (Cordova, $cx)"; break } }
        if ($det -ne 'id') { foreach ($kf in @($all | Where-Object { $_ -match '\.kt$' } | Select-Object -First 400)) { if ((Read-Text (Join-Path $Root $kf)) -match 'testTag\s*\(') { $det = 'testTag'; $why = "Compose ($kf)"; break } } }
    }
    $src = 'padrão (sem testIds.attribute nem targets.web.testIdAttribute)'
    $gp = Join-Path $Root '.team-project/guards.json'
    if (Test-Path -LiteralPath $gp) { try { $gj = Read-Text $gp | ConvertFrom-Json
        if ($gj.PSObject.Properties['testIds'] -and $gj.testIds -and $gj.testIds.PSObject.Properties['attribute'] -and ([string]$gj.testIds.attribute).Trim()) { $src = 'testIds.attribute' }
        elseif ($gj.PSObject.Properties['targets'] -and $gj.targets -and $gj.targets.PSObject.Properties['web'] -and $gj.targets.web -and $gj.targets.web.PSObject.Properties['testIdAttribute'] -and $gj.targets.web.testIdAttribute) { $src = 'targets.web.testIdAttribute' } } catch { } }
    [void]$sb.AppendLine(''); [void]$sb.AppendLine('## 1. Atributo do id')
    [void]$sb.AppendLine("- Detectado pela stack: ``$det`` — $why.")
    [void]$sb.AppendLine("- Configurado: ``$attr`` — $src.")
    [void]$sb.AppendLine($(if ($det -eq $attr) { '- Coincidem.' } else { "- **Divergem:** proponha ``testIds.attribute = `"$det`"`` (7l, formulário 1)." }))

    # 2 · telas e controles sem id, no código todo
    $unt = [ordered]@{}; $untTotal = 0
    foreach ($f in @(Get-IdFiles | Where-Object { $_ -match '\.(kt|html?|tsx|jsx|vue)$' } | Sort-Object)) {
        $p = Join-Path $Root $f; if (-not (Test-Path -LiteralPath $p -PathType Leaf)) { continue }
        $r = @(Find-UntaggedUi ($f -replace '\\', '/') ((Read-Text $p) -replace "`r", '') $attr)
        if ($r.Count) { $unt[$f] = $r; $untTotal += $r.Count }
    }
    [void]$sb.AppendLine(''); [void]$sb.AppendLine('## 2. Telas e controles sem id')
    [void]$sb.AppendLine("$untTotal ocorrência(s) em $($unt.Count) arquivo(s) (a conferência vale pelo código todo, não só pelos arquivos de uma Task).")
    $shown = 0
    foreach ($k in @($unt.Keys | Sort-Object { -@($unt[$_]).Count })) {
        if ($shown -ge 40) { [void]$sb.AppendLine("- … e mais $($unt.Count - $shown) arquivo(s)"); break }
        $shown++; [void]$sb.AppendLine("- ``$k`` — $(@($unt[$k]).Count)")
        foreach ($o in @($unt[$k] | Select-Object -First 2)) { [void]$sb.AppendLine("  - $o") }
    }

    # 3 · ids fora da gramática
    $bad = @()
    foreach ($k in $idMap.Keys) { foreach ($i in $idMap[$k]) { $core = $i.Id.TrimEnd('.', '-', '_'); if ($core -notmatch $gram) { $bad += "``$(Format-Id $i)`` em ``$k``:$($i.Line)" } } }
    [void]$sb.AppendLine(''); [void]$sb.AppendLine('## 3. Ids fora da gramática')
    [void]$sb.AppendLine("Gramática: minúsculas em kebab-case separadas por ``.`` (``standards/test-ids.md`` §3). $($bad.Count) fora.")
    foreach ($b in @($bad | Select-Object -First 30)) { [void]$sb.AppendLine("- $b") }

    # 4 · ids dos .scn que não existem no código
    $blobFiles = @(Get-IdFiles); $blob = (@($blobFiles | ForEach-Object { $p = Join-Path $Root $_; if (Test-Path -LiteralPath $p -PathType Leaf) { Read-Text $p } }) -join "`n")
    $scnMiss = @()
    $tp = Join-Path $Root '.team-project'
    foreach ($f in @(Get-ChildItem -Path $tp -Filter '*.scn' -File -Recurse -ErrorAction SilentlyContinue | Sort-Object FullName)) {
        $rel = ($f.FullName.Substring($Root.Length).TrimStart('\', '/') -replace '\\', '/'); $n = 0
        foreach ($raw in ((Read-Text $f.FullName) -split "`r?`n")) {
            $n++; $l = $raw.Trim(); if (-not $l -or $l.StartsWith('#')) { continue }
            $parts = $l -split '\s+', 2; if ($parts.Count -lt 2 -or $script:ScnIdVerbs -notcontains $parts[0]) { continue }
            $id = @((($parts[1] -split '=', 2)[0]).Trim() -split '\s+')[0]
            if ($id -and -not (Test-TestIdInSource $blob $id ($parts[0] -eq 'assert-count' -or $parts[0] -eq 'assert-order'))) { $scnMiss += "``$id`` em ``${rel}:$n``" }
        }
    }
    [void]$sb.AppendLine(''); [void]$sb.AppendLine('## 4. Ids dos cenários (.scn) que não existem no código')
    [void]$sb.AppendLine("$($scnMiss.Count) id(s).")
    foreach ($b in @($scnMiss | Select-Object -First 30)) { [void]$sb.AppendLine("- $b") }

    # 5 · seletor por texto onde há id (a conferir)
    $lastSeg = @{}
    foreach ($k in $idMap.Keys) { foreach ($i in $idMap[$k]) { if (-not $i.Dyn) { $seg = ($i.Id -split '\.')[-1]; if ($seg -and -not $lastSeg.ContainsKey($seg)) { $lastSeg[$seg] = $i.Id } } } }
    $norm = { param($s) $d = $s.Normalize([Text.NormalizationForm]::FormD); (-join ($d.ToCharArray() | Where-Object { [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark' })).ToLowerInvariant().Trim() -replace '\s+', '-' }
    $byText = @()
    $scanFiles = @($all | Where-Object { $_ -match '\.(m?js|cjs|tsx?|py|ps1|java|kt)$' -and $_ -notmatch '(^|/)(node_modules|dist|build|\.team-project|docs)/' -and ((Test-TestIdExcluded $_) -or $_ -match '(^|/)(scripts?|e2e|tools?)/' -or $_ -match '\.(m?js|cjs)$') })
    foreach ($f in $scanFiles) {
        $p = Join-Path $Root $f; if (-not (Test-Path -LiteralPath $p -PathType Leaf)) { continue }
        $n = 0
        foreach ($ln in ((Read-Text $p) -split "`r?`n")) {
            $n++
            $m = [regex]::Match($ln, '(getByText\(|cy\.contains\(|By\.text\(|tocarTexto\(|\btext\s*=\s*)')
            if (-not $m.Success) { continue }
            $q = [regex]::Match($ln.Substring($m.Index + $m.Length - 1), '["''`]([^"''`]{1,60})["''`]')
            $hint = ''
            if ($q.Success) { $seg = & $norm $q.Groups[1].Value; if ($lastSeg.ContainsKey($seg)) { $hint = " — já existe o id ``$($lastSeg[$seg])``" } }
            $byText += "``${f}:$n`` — ``$($ln.Trim().Substring(0, [Math]::Min(80, $ln.Trim().Length)))``$hint"
        }
    }
    [void]$sb.AppendLine(''); [void]$sb.AppendLine('## 5. Seletores por texto onde há id (a conferir)')
    [void]$sb.AppendLine("Heurística: ``getByText(`` · ``cy.contains(`` · ``By.text(`` · ``tocarTexto(`` · ``text=``. $($byText.Count) ocorrência(s); as que já têm id no código vêm marcadas.")
    foreach ($b in @($byText | Sort-Object { if ($_ -match 'já existe o id') { 0 } else { 1 } } | Select-Object -First 40)) { [void]$sb.AppendLine("- $b") }

    # 6 · planos do sprint aberto que citam id fora do mapa
    $planMiss = @()
    $readme = Join-Path $tp 'README.md'
    $sprint = if (Test-Path -LiteralPath $readme) { Get-CurrentSprint (Read-Text $readme) } else { $null }
    $known = @(); foreach ($k in $idMap.Keys) { foreach ($i in $idMap[$k]) { $known += $i } }
    if ($sprint -and (Test-Path -LiteralPath (Join-Path $tp "sprints/$sprint/plan"))) {
        foreach ($pf in @(Get-ChildItem -Path (Join-Path $tp "sprints/$sprint/plan") -Filter '*.md' -File -ErrorAction SilentlyContinue | Sort-Object Name)) {
            $seen = @{}
            foreach ($m in [regex]::Matches((Read-Text $pf.FullName), '`([a-z][a-z0-9-]*(?:\.[a-z0-9-]+)+)`')) {
                $tok = $m.Groups[1].Value
                if ($seen.ContainsKey($tok) -or $tok -match '\.(ts|js|mjs|md|json|html|scss|css|kt|java|ps1|xml|ya?ml|scn|tsx|jsx|py|sh|gradle|lock|txt)$') { continue }
                $seen[$tok] = $true
                $hit = @($known | Where-Object { ($_.Id -eq $tok) -or ($_.Dyn -and $tok.StartsWith($_.Id)) }).Count
                if (-not $hit) { $planMiss += "``$tok`` em ``$($pf.Name)``" }
            }
        }
    }
    $sp6 = if ($sprint) { " ($sprint)" } else { '' }
    [void]$sb.AppendLine(''); [void]$sb.AppendLine("## 6. Planos do sprint aberto$sp6 que citam id fora do mapa")
    [void]$sb.AppendLine("$($planMiss.Count) citação(ões) — pode ser id que a Task cria (esperado) ou nome errado (a conferir pelo Arquiteto).")
    foreach ($b in @($planMiss | Select-Object -First 30)) { [void]$sb.AppendLine("- $b") }

    Write-Doc '.team-project/architect/ids-audit.md' $sb.ToString()
    [Console]::Out.WriteLine("ids -Audit: atributo $attr (detectado $det) · sem id: $untTotal em $($unt.Count) arquivo(s) · fora da gramática: $($bad.Count) · .scn sem id no código: $($scnMiss.Count) · por texto: $($byText.Count) · planos fora do mapa: $($planMiss.Count) → .team-project/architect/ids-audit.md")
}
exit 0
