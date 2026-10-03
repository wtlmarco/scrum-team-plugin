# C2 — conferência do projeto: onboarding (R14), ordem ① → SDD técnico (R15), aceite só na Review (R21) e git só com o produto (R31).
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/project.ps1" [-Root <projeto>] [-Deep]
#   Roda na retrospectiva e no /sm onboarding. -Deep acrescenta o histórico do git (lento) ao R31.
# Saída: tabela regra · resultado · linha decisiva. Exit 0 sempre; 2 só em erro de uso ou de leitura.

param(
    [string]$Root = (Get-Location).Path,
    [switch]$Deep
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')

try {
    $tp = Join-Path $Root '.team-project'
    $readmePath = Join-Path $tp 'README.md'
    if (-not (Test-Path -LiteralPath $readmePath)) { [Console]::Error.WriteLine("C2: $readmePath não existe — rode na raiz do projeto ou passe -Root."); exit 2 }
    $readme = Read-Text $readmePath
    $pm = [regex]::Match($readme, '\*\*Diretório de produto:\*\*\s*`?([^`\s]+)`?')
    $productRel = if ($pm.Success -and $pm.Groups[1].Value -notmatch '<') { $pm.Groups[1].Value } else { 'docs/' }
    $product = Join-Path $Root $productRel

    # ---------- R14 · onboarding ----------
    $r14 = @()
    $s4 = Get-Section $readme '^##\s+4\.'
    $has4 = $false
    if ($s4) { foreach ($t in (Get-Tables $s4)) { foreach ($row in $t.Rows) { if (-not ($row -join '' -match '<[^>]+>') -and -not (Test-Placeholder $row[0])) { $has4 = $true } } } }
    if (-not $has4) { $r14 += '§4 Fontes da verdade sem linha preenchida' }
    $s7 = Get-Section $readme '^##\s+7\.\s'
    if (-not $s7 -or -not ($s7 -match '(?m)^\s*\d+\.\s+[^<\s]' -or $s7 -match '(?i)nenhum')) { $r14 += '§7 Decisões pendentes sem item nem "nenhuma"' }
    foreach ($label in 'Duração do sprint', 'Unidade de estimativa') {
        if (Test-Placeholder (Get-LabelValue $readme $label)) { $r14 += "cadência: '$label' não preenchida" }
    }
    if ($r14.Count) { Add-Result 'R14' 'falhou' ($r14 -join '; ') } else { Add-Result 'R14' 'ok' '§4, §7 e cadência preenchidos (datas: n-a — o modelo não tem campo de data)' }

    # ---------- R15 · ① antes do SDD técnico (03/04/05) ----------
    $navDate = $null
    $protoDir = Join-Path $tp 'user-experience/prototype'
    if (Test-Path -LiteralPath $protoDir) {
        foreach ($f in (Get-ChildItem -LiteralPath $protoDir -Recurse -Filter '*.md' | Where-Object { $_.FullName -notmatch '[\\/]sprint-[^\\/]*[\\/]' })) {
            $nm = [regex]::Match((Read-Text $f.FullName), '\*\*Navegado pelo stakeholder em:\*\*\s*(.+)')
            if ($nm.Success) { $d = Get-FirstDate $nm.Groups[1].Value; if ($d) { $navDate = $d; break } }
        }
    }
    $isGit = $false
    try { $null = & git -C $Root rev-parse --is-inside-work-tree 2>$null; $isGit = ($LASTEXITCODE -eq 0) } catch { }
    if (-not $navDate) { Add-Result 'R15' 'n-a' 'ficha do protótipo funcional sem "Navegado pelo stakeholder em:" com data' }
    elseif (-not $isGit) { Add-Result 'R15' 'n-a' 'fora de repositório git: sem data de criação do SDD técnico' }
    else {
        $early = @(); $seen = 0
        if (Test-Path -LiteralPath $product) {
            foreach ($f in (Get-ChildItem -LiteralPath $product -Recurse -File | Where-Object { $_.Name -match '^0[345]-.*\.md$' })) {
                $dates = @(& git -C $Root log --diff-filter=A --format=%as -- $f.FullName 2>$null)
                if ($dates.Count -eq 0) { continue }
                $seen++
                $added = Get-FirstDate $dates[-1]
                if ($added -and $added -lt $navDate) { $early += "$($f.Name) em $($dates[-1])" }
            }
        }
        if ($seen -eq 0) { Add-Result 'R15' 'n-a' "nenhum 03/04/05 versionado em $productRel" }
        elseif ($early.Count) { Add-Result 'R15' 'falhou' ("SDD técnico antes da navegação do ① (" + $navDate.ToString('yyyy-MM-dd') + "): " + ($early -join '; ')) }
        else { Add-Result 'R15' 'ok' ("$seen documento(s) 03/04/05 criados depois do ① (" + $navDate.ToString('yyyy-MM-dd') + "); ② antes da 1ª História: n-a") }
    }

    # ---------- R21 · aceite só na Sprint Review, e por História ----------
    $r21 = @()
    $done = [char]::ConvertFromUtf32(0x2705); $fail = [char]::ConvertFromUtf32(0x274C); $warn = [char]::ConvertFromUtf32(0x26A0)
    foreach ($f in (Get-ChildItem -LiteralPath $tp -Recurse -Filter '*.md' -File)) {
        $rel = ($f.FullName.Substring($tp.Length + 1)) -replace '\\', '/'
        foreach ($am in [regex]::Matches((Read-Text $f.FullName), '(?m)^#{2,3}\s+Aceite\s+[—-]\s+((H|T)-[\w]+)')) {
            if ($am.Groups[2].Value -eq 'T') { $r21 += "aceite de Task ($($am.Groups[1].Value)) em $rel" }
            elseif ($rel -notmatch '^sprints/[^/]+/review\.md$') { $r21 += "dossiê de aceite $($am.Groups[1].Value) fora da Review: $rel" }
        }
    }
    $sprints = Join-Path $tp 'sprints'
    if (Test-Path -LiteralPath $sprints) {
        foreach ($d in (Get-ChildItem -LiteralPath $sprints -Directory)) {
            if (-not (Test-Path -LiteralPath (Join-Path $d.FullName 'retrospective.md'))) { continue }   # só sprint fechado
            $rv = Join-Path $d.FullName 'review.md'
            if (-not (Test-Path -LiteralPath $rv)) { $r21 += "sprint $($d.Name) fechado sem review.md"; continue }
            $hs = Get-Section (Read-Text $rv) '^###\s+Hist[óo]rias do sprint'
            if ($hs) {
                foreach ($t in (Get-Tables $hs)) {
                    $ic = Find-Col $t 'Decisão'
                    foreach ($row in $t.Rows) {
                        if (Test-Placeholder $row[0]) { continue }
                        $c = Get-Cell $row $ic
                        if (-not ($c.Contains($done) -or $c.Contains($fail) -or $c.Contains($warn))) { $r21 += "sprint $($d.Name): $(Clean-Cell $row[0]) sem decisão do stakeholder" }
                    }
                }
            }
        }
    }
    if ($r21.Count) { Add-Result 'R21' 'falhou' ($r21 -join '; ') } else { Add-Result 'R21' 'ok' 'dossiês de aceite só em sprints/*/review.md, por História; sprints fechados com decisão' }

    # ---------- R31 · git só com o produto ----------
    if (-not $isGit) { Add-Result 'R31' 'n-a' 'projeto fora de repositório git' }
    else {
        $r31 = @()
        $tracked = @(& git -C $Root ls-files .team-project 2>$null)
        if ($tracked.Count) { $r31 += "$($tracked.Count) arquivo(s) de .team-project/ no git (ex.: $($tracked[0]))" }
        & git -C $Root check-ignore -q .team-project/README.md 2>$null
        if ($LASTEXITCODE -ne 0) { $r31 += '.team-project/ não está no .gitignore' }
        if (Test-Path -LiteralPath $product) {
            $refs = @(Get-ChildItem -LiteralPath $product -Recurse -File -Include '*.md', '*.json', '*.yml', '*.yaml', '*.txt' | Select-String -SimpleMatch '.team-project' -List)
            if ($refs.Count) { $r31 += "$productRel cita .team-project em $($refs.Count) arquivo(s) (ex.: $($refs[0].Path.Substring($Root.Length + 1)))" }
        }
        if ($Deep) {
            $hist = @(& git -C $Root log --all --format=%h -- .team-project 2>$null)
            if ($hist.Count) { $r31 += "aviso: $($hist.Count) commit(s) no histórico tocam .team-project/ (limpeza: /team update passo 7b)" }
        }
        if ($r31.Count) { Add-Result 'R31' 'falhou' ($r31 -join '; ') } else { Add-Result 'R31' 'ok' ".team-project/ fora do git e ignorado; $productRel sem referência" }
    }

    Write-Results 'C2 · projeto'
    exit 0
} catch {
    [Console]::Error.WriteLine("C2: erro — $($_.Exception.Message)")
    exit 2
}
