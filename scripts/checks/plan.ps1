# Conferência do plano (v3.46): o Plano de Implementação é contrato, e o que dele é mecânico se confere ANTES de disparar
# o dev — plano reprovado volta ao Arquiteto na mesma instância, sem custo de dev nem ciclo de 🔺 GAP.
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/plan.ps1" -Plan <caminho do plano> [-Root <projeto>]
# Regras: implementation-plan.md "Regras do formato" 2 (blocos), 15 (lista legível, teste por arquivo), 16 (protegidos),
# 17 (trecho literal ≤ 15 linhas ou validado), 18 (mutações) e a variante leve.
# Saída: tabela regra · resultado · linha decisiva. Exit 1 se alguma falhou · 2 = erro de uso.

param(
    [Parameter(Mandatory = $true)][string]$Plan,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')

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
    $muts = @([regex]::Matches($text, '(?m)^\s*-\s*(M\d+)\s*·.*?`([^`]+)`.*?`([^`]+)`.*?`([^`]*)`\s*→\s*`([^`]*)`'))
    $hasMutBlock = $text -match '(?m)^\*\*Muta[çc][õo]es:\*\*'
    $noProof = $text -match '(?m)sem prova:\s*\S'
    if ($muts.Count) {
        $iss = @()
        foreach ($m in $muts) {
            $t = ($m.Groups[2].Value.Trim() -replace '\\', '/'); $f = ($m.Groups[3].Value.Trim() -replace '\\', '/')
            if ($files -and $files -notcontains $f) { $iss += "$($m.Groups[1].Value): $f fora de **Arquivos tocados:**" }
            if ($files -and $files -notcontains $t) { $iss += "$($m.Groups[1].Value): teste $t fora de **Arquivos tocados:**" }
            if ($m.Groups[4].Value -eq $m.Groups[5].Value) { $iss += "$($m.Groups[1].Value): trecho e mutante iguais" }
        }
        if ($iss.Count) { Add-Result 'mutação' 'falhou' ($iss -join '; ') } else { Add-Result 'mutação' 'ok' "$($muts.Count) mutação(ões) declaradas" }
    } elseif ($noProof) { Add-Result 'mutação' 'ok' "sem mutação, com 'sem prova: <motivo>'" }
    elseif ($hasMutBlock) { Add-Result 'mutação' 'falhou' '**Mutações:** sem linha no formato "- M<k> · teste `…` · `<produção>` · `<trecho>` → `<mutante>`"' }
    else { Add-Result 'mutação' 'falhou' "nenhuma **Mutações:** nem 'sem prova: <motivo>' na §6 (regra 18)" }

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
