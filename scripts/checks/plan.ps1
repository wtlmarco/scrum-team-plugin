# Conferência do plano (v3.46): o Plano de Implementação é contrato, e o que dele é mecânico se confere ANTES de disparar
# o dev — plano reprovado volta ao Arquiteto na mesma instância, sem custo de dev nem ciclo de 🔺 GAP.
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/plan.ps1" -Plan <caminho do plano> [-Root <projeto>]
# Regras: implementation-plan.md "Regras do formato" 2 (blocos), 15 (lista legível, teste por arquivo), 16 (protegidos),
# 17 (trecho literal ≤ 15 linhas ou validado), 18 (mutações), a variante leve e, desde a v3.51, 21 (render só com layout
# novo), 22 (tamanho: aviso acima de 12 KB, falha acima de 20 KB), 23 (cenários citados existem nos .scn do QA) e 24 (risco);
# desde a v3.52.2, 26 (linhas "- Contagem:" recontadas e premissas "- P<k> ·" medidas ou com quem verifica) e 27 (layout
# novo com a linha **Documentos vivos:**; documento de desenho fora de **Arquivos tocados:** — o Arquiteto o consolida);
# desde a v3.53, 28 (Task com ficha no breakdown: **Li além da ficha:**, nomes comuns no plano, caminhos da ficha existem).
# As mensagens dizem o que corrigir: o Arquiteto não precisa abrir este script (note.md item 7).
# Saída: tabela regra · resultado · linha decisiva. Exit 1 se alguma falhou · 2 = erro de uso.

param(
    [Parameter(Mandatory = $true)][string]$Plan,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
. (Join-Path $PSScriptRoot '..\..\hooks\common.ps1')   # v3.48: glob e guards.json, como as guardas leem

$testRe = '(^|/)(tests?|specs?|__tests__)/|(^|/)test_[^/]+$|[._-](test|tests|spec|specs)\.[^/]+$|tests?\.[^/.]+$'

function Get-List([string]$Text, [string]$Label) {
    $m = [regex]::Match($Text, '(?s)\*\*' + [regex]::Escape($Label) + ':\*\*(.*?)(?:\r?\n[ \t]*\r?\n|\r?\n#|\z)')
    if (-not $m.Success) { return $null }
    return @([regex]::Matches($m.Groups[1].Value, '`([^`]+)`') | ForEach-Object { ($_.Groups[1].Value.Trim() -replace '\\', '/') -replace '^\./', '' })
}

try {
    $path = if ([System.IO.Path]::IsPathRooted($Plan)) { $Plan } else { Join-Path $Root $Plan }
    if (-not (Test-Path -LiteralPath $path)) { [Console]::Error.WriteLine("plano: $path não existe."); exit 2 }
    $text = Read-Text $path
    $light = $text -match '\*\*Trilha:\*\*\s*leve\b'

    # ---------- 15 · lista legível e teste por arquivo de produção ----------
    $files = Get-List $text 'Arquivos tocados'
    if ($null -eq $files -or $files.Count -eq 0) { Add-Result 'lista' 'falhou' '**Arquivos tocados:** ausente ou sem caminho entre crases — a G9 nega tudo ao dev' }
    else {
        $tests = @($files | Where-Object { $_ -match $testRe }); $prod = @($files | Where-Object { $_ -notmatch $testRe })
        $noTest = @($prod | Where-Object { $text -notmatch ('sem teste:[^\n]*' + [regex]::Escape($_)) })
        if ($prod.Count -and $tests.Count -eq 0 -and $noTest.Count) { Add-Result 'lista' 'falhou' ("$($prod.Count) arquivo(s) de produção e nenhum de teste na lista, sem 'sem teste: <arquivo> — <motivo>' na §6") }
        else { Add-Result 'lista' 'ok' "$($files.Count) arquivo(s): $($prod.Count) de produção, $($tests.Count) de teste" }
    }

    # ---------- v3.48 · todo arquivo da lista é do executor ----------
    # A G8 nega ao dev arquivo de .team-project/ que não é dele e a G5 nega arquivo de gate — no piloto, o plano mandou o dev
    # escrever documento do time e a Task parou no meio. Aqui o plano volta ao Arquiteto antes.
    if ($files -and $files.Count) {
        $own = Get-Content -LiteralPath (Join-Path $PSScriptRoot '..\..\hooks\ownership.json') -Raw -Encoding UTF8 | ConvertFrom-Json
        $gcfg = Get-GuardConfig $Root
        $iss = @()
        foreach ($f in $files) {
            $rel = Normalize-PathText $f
            if (Test-GlobMatch $rel $gcfg.protectedPaths) { $iss += "$f é arquivo de gate (guards.json → protectedPaths): vai em **Arquivos protegidos:** ver §12, aplicado pela sessão"; continue }
            foreach ($rule in @($own.project)) {
                if (-not (Test-GlobMatch $rel @($rule.paths))) { continue }
                if (@($rule.writers) -notcontains 'developer') {
                    $who = if (@($rule.writers).Count) { (@($rule.writers) | ForEach-Object { $own.roles.$_ }) -join ' · ' } else { 'stakeholder / a sessão' }
                    $iss += "$f é de $who (artifact-ownership.md §1): a G8 nega ao dev — tire da lista e peça ao dono"
                }
                break
            }
        }
        if ($iss.Count) { Add-Result 'dono' 'falhou' ($iss -join '; ') } else { Add-Result 'dono' 'ok' 'todo arquivo da lista é escrito pelo executor (nenhum de gate nem de outro papel)' }
    }

    # ---------- 16 · arquivos protegidos declarados ----------
    if ($text -match '(?m)^\*\*Arquivos protegidos:\*\*\s*(nenhum|ver §12)') { Add-Result 'protegidos' 'ok' ($Matches[0].Trim()) }
    else { Add-Result 'protegidos' 'falhou' 'linha **Arquivos protegidos:** nenhum | ver §12 ausente' }

    # ---------- 2 · blocos acima de 8 arquivos ----------
    if ($files -and $files.Count -gt 8) {
        $blocks = [regex]::Matches($text, '(?ms)^###\s+Bloco\s+(\d+)\b(.*?)(?=^###\s+Bloco\s|^##\s|\z)')
        if ($blocks.Count -eq 0) { Add-Result 'blocos' 'falhou' "$($files.Count) arquivos e nenhum '### Bloco <k>' (regra 2: acima de 8, um bloco por instância de dev)" }
        else {
            $iss = @()
            foreach ($b in $blocks) {
                $k = $b.Groups[1].Value; $body = $b.Groups[2].Value
                $bf = Get-List $body 'Arquivos do bloco'
                if ($null -eq $bf -or $bf.Count -eq 0) { $iss += "bloco $k sem **Arquivos do bloco:**" }
                else {
                    if ($bf.Count -gt 8) { $iss += "bloco $k com $($bf.Count) arquivos (máximo 8)" }
                    $out = @($bf | Where-Object { $files -notcontains $_ }); if ($out.Count) { $iss += "bloco $k cita fora de **Arquivos tocados:**: " + ($out -join ', ') }
                }
                if ($body -notmatch '\*\*Depende de:\*\*') { $iss += "bloco $k sem **Depende de:**" }
                if ($body -notmatch '\*\*Pronto do bloco:\*\*[^\n]*exit 0') { $iss += "bloco $k sem **Pronto do bloco:** com comando e exit 0" }
            }
            if ($iss.Count) { Add-Result 'blocos' 'falhou' ($iss -join '; ') } else { Add-Result 'blocos' 'ok' "$($blocks.Count) bloco(s) para $($files.Count) arquivos" }
        }
    } else { Add-Result 'blocos' 'n-a' "$(if ($files) { $files.Count } else { 0 }) arquivo(s) — até 8, passos direto" }

    # ---------- 17 · trecho literal ≤ 15 linhas, ou validado ----------
    $s4 = Get-Section $text '^##\s+4\.'
    if ($null -eq $s4) { Add-Result 'trecho' 'n-a' 'sem §4 (plano leve ou sem passos)' }
    else {
        $long = @()
        foreach ($st in [regex]::Matches($s4, '(?ms)^###\s+(Passo\s+[\w.]+)(.*?)(?=^###\s|\z)')) {
            $name = $st.Groups[1].Value; $body = $st.Groups[2].Value
            $validated = $body -match '\*\*Validado em:\*\*\s*\S'
            foreach ($fence in [regex]::Matches($body, '(?ms)^[ \t]*(```|~~~)[^\n]*\n(.*?)^[ \t]*\1')) {
                $n = @($fence.Groups[2].Value -split "`r?`n" | Where-Object { $_.Trim() }).Count
                if ($n -gt 15 -and -not $validated) { $long += "$name ($n linhas)" }
            }
        }
        if ($long.Count) { Add-Result 'trecho' 'falhou' ("trecho literal acima de 15 linhas sem **Validado em:** — " + ($long -join ', ') + " (regra 17: contrato, não código; o dev escreve o corpo)") }
        else { Add-Result 'trecho' 'ok' 'nenhum trecho literal acima de 15 linhas sem validação' }
    }

    # ---------- 18 · mutações da prova de falha ----------
    # v3.52.2 (note.md item 7): o mesmo leitor do verify.ps1 (Get-Mutations, lib.ps1) — antes o plano contava toda linha
    # "- M<k> ·" do arquivo e o verify parava o bloco na primeira linha em branco; uma mutação passava aqui e nunca rodava lá.
    $muts = @(Get-Mutations $text)
    $hasMutBlock = $text -match '(?m)^\*\*Muta[çc][õo]es:\*\*'
    $noProof = $text -match '(?m)sem prova:\s*\S'
    $stray = @([regex]::Matches($text, '(?m)^\s*-\s*(M\d+)\s*·') | ForEach-Object { $_.Groups[1].Value } | Where-Object { @($muts | ForEach-Object { $_.Id }) -notcontains $_ })
    if ($muts.Count) {
        $iss = @()
        if ($stray.Count) { $iss += "linha(s) $($stray -join ', ') fora do bloco **Mutações:** ou fora do formato — o verify.ps1 não as roda" }
        foreach ($m in $muts) {
            $t = ($m.Test -replace '\\', '/'); $f = ($m.File -replace '\\', '/')
            if ($files -and $files -notcontains $f) { $iss += "$($m.Id): $f fora de **Arquivos tocados:**" }
            if ($files -and $files -notcontains $t) { $iss += "$($m.Id): teste $t fora de **Arquivos tocados:**" }
            if ($m.Find -eq $m.Replace) { $iss += "$($m.Id): trecho e mutante iguais" }
            if ($m.Find -eq '') { $iss += "$($m.Id): trecho vazio (crase dupla ou trecho com crase — escolha um trecho sem crase)" }
            # v3.51.4 (garden item 27): o arquivo de produção já existe → o trecho tem de aparecer no máximo uma vez nele (a
            # mutação troca a ÚNICA ocorrência; duplicado vira inconclusivo depois de ~10 min de construção). Arquivo novo
            # ou trecho que a Task vai escrever: confere-se depois da construção, com verify.ps1 -Mode mutation -Precheck.
            $pf = Join-Path $Root $f
            if ($m.Find -ne '' -and (Test-Path -LiteralPath $pf -PathType Leaf)) {
                $src = Read-Text $pf; $hits = 0; $ix = $src.IndexOf($m.Find, [StringComparison]::Ordinal)
                while ($ix -ge 0) { $hits++; $ix = $src.IndexOf($m.Find, $ix + [Math]::Max(1, $m.Find.Length), [StringComparison]::Ordinal) }
                if ($hits -gt 1) { $iss += "$($m.Id): o trecho aparece $hits vezes em $f (a mutação precisa de uma ocorrência só — alongue o trecho)" }
            }
        }
        if ($iss.Count) { Add-Result 'mutação' 'falhou' ($iss -join '; ') } else { Add-Result 'mutação' 'ok' "$($muts.Count) mutação(ões) declaradas" }
    } elseif ($noProof) { Add-Result 'mutação' 'ok' "sem mutação, com 'sem prova: <motivo>'" }
    elseif ($hasMutBlock) { Add-Result 'mutação' 'falhou' '**Mutações:** sem linha no formato "- M<k> · teste `…` · `<produção>` · `<trecho>` → `<mutante>`"' }
    else { Add-Result 'mutação' 'falhou' "nenhuma **Mutações:** nem 'sem prova: <motivo>' na §6 (regra 18)" }

    # ---------- R26 · ambiente medido (v3.51.4, garden item 16): a mesma regra do close.ps1, cobrada no plano ----------
    # Antes só o fechamento a conferia, e o primeiro close do sprint reprovava todos os planos de uma vez.
    if ($light) { Add-Result 'ambiente' 'n-a' 'trilha leve' }
    else {
        $iss = @()
        $s3 = Get-Section $text '^##\s+3\.'
        $p3 = $text.IndexOf("`n## 3."); $p4 = $text.IndexOf("`n## 4.")
        $rowsOk = $false
        if ($s3) { foreach ($t in (Get-Tables $s3)) { $iq = Find-Col $t 'Pré-requisito'; $io = Find-Col $t 'Saída real'; if ($iq -lt 0 -or $io -lt 0) { continue }; foreach ($row in $t.Rows) { if (-not ($row -join '' -match '<[^>]+>') -and -not [string]::IsNullOrWhiteSpace((Get-Cell $row $io))) { $rowsOk = $true } } } }
        if (-not $s3 -or ($p4 -ge 0 -and $p3 -gt $p4)) { $iss += '§3 (ambiente medido) ausente ou depois dos passos' }
        elseif (-not $rowsOk) { $iss += '§3 sem a tabela | Pré-requisito | … | Saída real | … | com uma linha medida (prosa não vale — o close.ps1 lê a tabela)' }
        $s9 = Get-Section $text '^##\s+9\.'
        if (-not $s9 -or $s9 -notmatch 'Pré-requisito ausente') { $iss += '§9 sem "Pré-requisito ausente"' }
        if ($iss.Count) { Add-Result 'ambiente' 'falhou' (($iss -join '; ') + ' (R26)') } else { Add-Result 'ambiente' 'ok' '§3 com pré-requisito medido; §9 com a parada por pré-requisito ausente' }
    }

    # ---------- 22 · plano enxuto (v3.51) ----------
    $kb = [Math]::Round(([System.Text.Encoding]::UTF8.GetByteCount($text)) / 1024, 1)
    if ($kb -gt 20) { Add-Result 'tamanho' 'falhou' "$kb KB (máximo 20; alvo ~12): cite o SDD e o standards/ em vez de copiar (regra 22)" }
    elseif ($kb -gt 12) { Add-Result 'tamanho' 'aviso' "$kb KB, acima do alvo de ~12 KB (regra 22)" }
    else { Add-Result 'tamanho' 'ok' "$kb KB" }

    # ---------- 23 · cenários ao lado do plano (v3.51) ----------
    $cm = [regex]::Match($text, '(?m)^\*\*Cen[áa]rios:\*\*\s*(.+)$')
    if (-not $cm.Success) { Add-Result 'cenários' 'falhou' "cabeçalho sem **Cenários:** SC-… | nenhum — <motivo> (regra 23)" }
    elseif ($cm.Groups[1].Value -match '^\s*nenhum\s*[—-]\s*\S') { Add-Result 'cenários' 'ok' ($cm.Groups[1].Value.Trim()) }
    else {
        $ids = @([regex]::Matches($cm.Groups[1].Value, '\b[A-Z]{2,}-\d+\b') | ForEach-Object { $_.Value } | Select-Object -Unique)
        $scnDir = Join-Path $Root '.team-project/quality-assurance/scenarios'
        $scn = @(Get-ChildItem -Path $scnDir -Filter '*.scn' -File -ErrorAction SilentlyContinue)
        if (-not $ids.Count) { Add-Result 'cenários' 'falhou' '**Cenários:** sem identificador (SC-nnn) nem "nenhum — <motivo>"' }
        elseif (-not $scn.Count -and -not (Get-TargetsConfig $Root)) { Add-Result 'cenários' 'n-a' "sem alvo de execução (guards.json sem ""targets""): $($ids -join ', ') rastreados no plano e provados por teste, sem .scn (v3.51.4)" }
        elseif (-not $scn.Count) { Add-Result 'cenários' 'falhou' "nenhum arquivo .scn em .team-project/quality-assurance/scenarios/ — o QA escreve os cenários executáveis antes do dev (regra 23)" }
        else {
            $defined = @($scn | ForEach-Object { [regex]::Matches((Read-Text $_.FullName), '(?m)^\s*scenario\s+(\S+)') } | ForEach-Object { $_.Groups[1].Value })
            $miss = @($ids | Where-Object { $defined -notcontains $_ })
            if ($miss.Count) { Add-Result 'cenários' 'falhou' ("cenário(s) citado(s) sem definição nos .scn: " + ($miss -join ', ')) }
            else { Add-Result 'cenários' 'ok' "$($ids.Count) cenário(s) da Task nos arquivos .scn: $($ids -join ', ')" }
        }
    }

    # ---------- 24 · risco e 21 · render só com layout novo (v3.51; conferência de render da proposta d, ajustada) ----------
    $rk = [regex]::Match($text, '(?m)^\*\*Risco:\*\*\s*(regra de neg[óo]cio|integra[çc][ãa]o|interface simples|infraestrutura)\b')
    if (-not $rk.Success) { Add-Result 'risco' 'falhou' 'cabeçalho sem **Risco:** regra de negócio | integração | interface simples | infraestrutura (regra 24)' }
    else {
        $r = $rk.Groups[1].Value
        if ($r -match '^(regra|integra)' -and $muts.Count -eq 0) { Add-Result 'risco' 'falhou' "risco '$r' pede mutação (regra 24)" }
        else { Add-Result 'risco' 'ok' $r }
    }
    $ui = ($text -match '(?i)user-experience/screens/') -or @($files | Where-Object { $_ -match '(?i)\.(css|scss|sass|less|styl|pcss)$' }).Count -or ($rk.Success -and $rk.Groups[1].Value -eq 'interface simples')
    $lay = [regex]::Match($text, '(?m)^\*\*Layout novo:\*\*\s*(sim|n[ãa]o)\b')
    if (-not $ui) { Add-Result 'render' 'n-a' 'sem interface (sem estilo nem especificação de tela citada)' }
    elseif (-not $lay.Success) { Add-Result 'render' 'falhou' 'Task com interface sem **Layout novo:** sim | não (regra 21)' }
    elseif ($lay.Groups[1].Value -notmatch '^sim') { Add-Result 'render' 'n-a' 'interface sem layout novo (regra 24: sem render real)' }
    else {
        $iss = @()
        if ($text -notmatch '(?m)^\*\*Render real\*\*') { $iss += 'sem a tabela **Render real** na §6 (regra 21)' }
        elseif ($text -notmatch '(?ms)^\*\*Render real\*\*.*?^\|\s*`[^`]+`\s*\|') { $iss += 'tabela **Render real** sem teste' }
        $s3 = Get-Section $text '^##\s+3\.'
        if (-not $s3 -or $s3 -notmatch '(?i)headless') { $iss += '§3 sem o navegador headless medido (R26)' }
        elseif ($s3 -match '(?im)headless.*\|\s*\*\*n[ãa]o\b') { $iss += 'navegador headless ausente — 🔺 GAP, a Task não entra em construção' }
        $rt = @([regex]::Matches($text, '(?ms)^\*\*Render real\*\*.*?(?=^\*\*Cobertura|^##\s|\z)') | ForEach-Object { [regex]::Matches($_.Value, '(?m)^\|\s*`([^`]+)`') } | ForEach-Object { ($_.Groups[1].Value -replace '\\', '/') })
        if ($rt.Count -and -not @($muts | Where-Object { $rt -contains ($_.Test -replace '\\', '/') }).Count) { $iss += 'nenhuma mutação com o teste de render (regra 21: o mutante tem de quebrar a medição)' }
        if ($iss.Count) { Add-Result 'render' 'falhou' ($iss -join '; ') } else { Add-Result 'render' 'ok' "$($rt.Count) teste(s) de render com mutação sobre a medição" }
    }

    # ---------- 26 · o plano prova o que afirma (v3.52.2, note.md item 5): contagem recontada e premissa medida ----------
    # Contagem: "- Contagem: `<regex>` em `<glob>[;<glob>]` → <n>" em qualquer lugar do plano. Reconta as linhas que casam a
    # regex (diferencia maiúsculas) nos arquivos versionados que casam o glob (git ls-files; sem git, o disco).
    $cnt = @([regex]::Matches($text, '(?m)^\s*-\s*Contagem:\s*`([^`]+)`\s*em\s*`([^`]+)`\s*→\s*(\d+)'))
    $cntBad = @([regex]::Matches($text, '(?m)^\s*-\s*Contagem:.*$') | Where-Object { $_.Value -notmatch '^\s*-\s*Contagem:\s*`[^`]+`\s*em\s*`[^`]+`\s*→\s*\d+' } | ForEach-Object { $_.Value.Trim() })
    if (-not $cnt.Count -and -not $cntBad.Count) { Add-Result 'contagem' 'n-a' 'nenhuma linha "- Contagem:" no plano' }
    else {
        $iss = @(); foreach ($b in $cntBad) { $iss += "fora do formato '- Contagem: ``<regex>`` em ``<glob>`` → <n>': $b" }
        $ErrorActionPreference = 'Continue'
        $tracked = @(& git -C $Root ls-files 2>$null); $isGit = ($LASTEXITCODE -eq 0)
        $ErrorActionPreference = 'Stop'
        if (-not $isGit) { $base = (Get-Item -LiteralPath $Root).FullName.TrimEnd('\', '/'); $tracked = @(Get-ChildItem -LiteralPath $base -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName.Substring($base.Length + 1) -replace '\\', '/' } | Where-Object { $_ -notmatch '^(\.git|\.team-project|node_modules)/' }) }
        $okN = 0
        foreach ($c in $cnt) {
            $re = $c.Groups[1].Value; $globs = @($c.Groups[2].Value -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ }); $want = [int]$c.Groups[3].Value
            try { $rx = New-Object System.Text.RegularExpressions.Regex($re) } catch { $iss += "regex inválida ``$re``"; continue }
            $got = 0
            foreach ($f in @($tracked | Where-Object { Test-GlobMatch (Normalize-PathText $_) $globs })) {
                $fp = Join-Path $Root $f; if (-not (Test-Path -LiteralPath $fp -PathType Leaf)) { continue }
                foreach ($ln in [System.IO.File]::ReadAllLines($fp)) { if ($rx.IsMatch($ln)) { $got++ } }
            }
            if ($got -ne $want) { $iss += "``$re`` em ``$($globs -join ';')``: o plano diz $want, a recontagem dá $got" } else { $okN++ }
        }
        if ($iss.Count) { Add-Result 'contagem' 'falhou' (($iss -join '; ') + ' (regra 26)') } else { Add-Result 'contagem' 'ok' "$okN contagem(ns) recontada(s) e iguais$(if (-not $isGit) { ' (sem git: arquivos do disco)' })" }
    }
    # Premissas: as linhas "- P<k> · …" do arquivo todo (o modelo as põe em ### Premissas, no fim da §6).
    $pl = @([regex]::Matches($text, '(?m)^\s*-\s*P\d+\s*·.*$') | ForEach-Object { $_.Value.Trim() })
    $pBad = @($pl | Where-Object { $_ -notmatch '·\s*medido:\s*\S.*→\s*\S' -and $_ -notmatch '·\s*n[ãa]o exercitada:\s*\S.*·\s*verifica:\s*\S' })
    $loose = @(($text -split "`r?`n") | Where-Object { $_ -match '[Nn][ãa]o validad[oa]' -and $_ -notmatch '^\s*-\s*P\d+\s*·' } | ForEach-Object { $_.Trim() })
    $measured = @($pl | Where-Object { $_ -match '·\s*medido:\s*\S.*→\s*\S' }).Count
    $layNew = $text -match '(?m)^\*\*Layout novo:\*\*\s*sim\b'
    $iss = @()
    foreach ($b in $pBad) { $iss += "premissa sem 'medido: <comando> → <resultado>' nem 'não exercitada: <motivo> · verifica: <papel> em <passo>': $b" }
    foreach ($b in $loose) { $iss += "'não validado' fora de linha P<k> (vira premissa não exercitada, com quem verifica): $(if ($b.Length -gt 100) { $b.Substring(0, 100) + '…' } else { $b })" }
    if ($layNew -and -not $measured) { $iss += '**Layout novo:** sim sem nenhuma premissa medido:' }
    if ($iss.Count) { Add-Result 'premissa' 'falhou' (($iss -join '; ') + ' (regra 26)') }
    elseif (-not $pl.Count) { Add-Result 'premissa' 'n-a' 'nenhuma linha P<k> (### Premissas)' }
    else { Add-Result 'premissa' 'ok' "$($pl.Count) premissa(s): $measured medida(s), $($pl.Count - $measured) não exercitada(s) com quem verifica" }
    # 27 · mudança visível aponta o documento de desenho (v3.52.2, note.md item 13; decisão do stakeholder): o dev não edita o
    # SDD — a linha **Documentos vivos:** diz o documento e a seção, e o Arquiteto consolida (A5). SDD na lista do dev reprova.
    $sdd = @($files | Where-Object { $_ -match '(?i)(^|/)docs/sdd/|(^|/)sdd/' })
    $dvm = [regex]::Match($text, '(?m)^\*\*Documentos vivos:\*\*[^`\r\n]*`([^`\r\n]+)`')
    $iss = @()
    if ($sdd.Count) { $iss += "documento de desenho em **Arquivos tocados:** ($($sdd -join ', ')): o dev não edita o SDD; vai em **Documentos vivos:**, o Arquiteto consolida" }
    if ($layNew -and -not $dvm.Success) { $iss += '**Layout novo:** sim sem a linha **Documentos vivos:** `<documento>` §<seção> — <o que muda>' }
    if ($iss.Count) { Add-Result 'desenho' 'falhou' (($iss -join '; ') + ' (regra 27)') }
    elseif ($layNew) { Add-Result 'desenho' 'ok' "Documentos vivos: $($dvm.Groups[1].Value) (consolidado pelo Arquiteto)" }
    else { Add-Result 'desenho' 'n-a' 'sem **Layout novo:** sim e sem documento de desenho na lista' }

    # ---------- 28 · plano pela ficha (v3.53, note.md item 8) ----------
    # Task com "### Ficha <ID>" no architect/breakdown/S<n>.md: o plano declara o que leu além dela (é a medida da ficha), usa
    # os nomes comuns literalmente (decisão comum esquecida é divergência entre Tasks) e a ficha só aponta caminho que existe.
    $sm = [regex]::Match(($path -replace '\\', '/'), '/sprints/(\d+)/plan/([^/]+)$')
    $fid = if ($sm.Success) { ([regex]::Match($sm.Groups[2].Value, '^' + $script:TaskIdRe)).Value } else { '' }
    $ficha = if ($fid) { Get-Ficha $Root $sm.Groups[1].Value $fid } else { $null }
    if (-not $ficha) { Add-Result 'ficha' 'n-a' 'Task sem ficha no breakdown (preparo por História)' }
    else {
        $iss = @()
        $lm = [regex]::Match($text, '(?m)^\*\*Li al[ée]m da ficha:\*\*\s*(.*)$')
        if (-not $lm.Success -or -not $lm.Groups[1].Value.Trim()) { $iss += 'cabeçalho sem **Li além da ficha:** nenhum | `<arquivo>` — <porquê>' }
        $miss = @($ficha.Names | Where-Object { -not $text.Contains($_) })
        if ($miss.Count) { $iss += 'nome comum da ficha ausente no plano: ' + ($miss -join ', ') }
        $gone = @(@($ficha.Read) + @($ficha.Sources) | Where-Object { $_ -and -not (Test-Path -LiteralPath (Resolve-FichaPath $Root $_)) })
        if ($gone.Count) { $iss += "a ficha aponta caminho que não existe (corrija em architect/breakdown/S$($sm.Groups[1].Value).md): " + ($gone -join ', ') }
        if ($iss.Count) { Add-Result 'ficha' 'falhou' (($iss -join '; ') + ' (regra 28)') }
        else {
            $extra = if ($lm.Groups[1].Value -match '^\s*nenhum') { 0 } else { @([regex]::Matches($lm.Groups[1].Value, '`[^`]+`')).Count }
            Add-Result 'ficha' 'ok' "$($ficha.Names.Count) nome(s) comum(ns) no plano; $(@($ficha.Read).Count + @($ficha.Sources).Count) caminho(s) da ficha existem; li além da ficha: $extra"
        }
    }

    # ---------- variante leve ----------
    if ($light) {
        $iss = @()
        if ($files -and $files.Count -gt 4) { $iss += "$($files.Count) arquivos (leve: até 4)" }
        if ($text -notmatch '(?m)^\*\*Arquivos protegidos:\*\*\s*nenhum') { $iss += 'arquivo protegido (leve: nenhum)' }
        if ($files -and @($files | Where-Object { $_ -match '(?i)migrat' }).Count) { $iss += 'migration na lista (leve: sem migration)' }
        if ($iss.Count) { Add-Result 'leve' 'falhou' (($iss -join '; ') + ' — a Task volta à trilha plena') } else { Add-Result 'leve' 'ok' 'dentro do critério mecânico da trilha leve' }
    } else { Add-Result 'leve' 'n-a' 'trilha plena' }

    Write-Results ("Plano · " + (Split-Path $path -Leaf))
    if (@($script:Results | Where-Object { $_.Resultado -eq 'falhou' }).Count) { [Console]::Out.WriteLine(''); [Console]::Out.WriteLine('**Plano não vai ao dev:** volta ao Arquiteto com esta tabela.'); exit 1 }
    exit 0
} catch {
    [Console]::Error.WriteLine("plano: erro — $($_.Exception.Message)")
    exit 2
}
