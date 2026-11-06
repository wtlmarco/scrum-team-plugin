# Conferência do plano (v3.46): o Plano de Implementação é contrato, e o que dele é mecânico se confere ANTES de disparar
# o dev — plano reprovado volta ao Arquiteto na mesma instância, sem custo de dev nem ciclo de 🔺 GAP.
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/plan.ps1" -Plan <caminho do plano> [-Root <projeto>]
# Regras: implementation-plan.md "Regras do formato" 2 (blocos), 15 (lista legível, teste por arquivo), 16 (protegidos),
# 17 (trecho literal ≤ 15 linhas ou validado), 18 (mutações), a variante leve e, desde a v3.51, 21 (render só com layout
# novo), 22 (tamanho: desde a v3.53.2 sem corte; desde a v3.53.6 acima de 30 KB reprova e a Task vai à divisão), 23 (cenários citados existem nos .scn do QA) e 24 (risco);
# desde a v3.52.2, 26 (linhas "- Contagem:" recontadas e premissas "- P<k> ·" medidas ou com quem verifica) e 27 (layout
# novo com a linha **Documentos vivos:**; documento de desenho fora de **Arquivos tocados:** — o Arquiteto o consolida);
# desde a v3.53, 28 (Task com ficha no breakdown: **Li além da ficha:**, nomes comuns no plano, caminhos da ficha existem);
# desde a v3.53.7, 26 também barra premissa de layout medida por leitura e 29 (decisões do sprint citadas, não copiadas);
# desde a v3.55.0, 31 (plano com **Corrige:** T-<nnn> traz "### Testes herdados" na §6) e 32 ("### Comandos da Task" na §7:
# os comandos da Task conferidos contra a lista da G14 + runCommands; instalação, rede, push e destrutivo reprovam).
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
            # v3.54: declarada pela regra — o dev escreve o trecho sobre o código real; aqui só a regra tem de dizer o que quebra.
            if ($null -eq $m.Find) { if ($m.Rule.Length -lt 12) { $iss += "$($m.Id): 'regra:' vazia ou curta demais — diga o que a mutação quebra (ex.: 'aceitar valor igual ao limite')" }; continue }
            if ($m.Find -eq $m.Replace) { $iss += "$($m.Id): trecho e mutante iguais" }
            if ($m.Find -eq '') { $iss += "$($m.Id): trecho vazio (crase dupla ou trecho com crase — escolha um trecho sem crase)" }
            # v3.51.4 (garden item 27): o arquivo de produção já existe → o trecho tem de aparecer no máximo uma vez nele (a
            # mutação troca a ÚNICA ocorrência; duplicado vira inconclusivo depois de ~10 min de construção). Arquivo novo
            # ou trecho que a Task vai escrever: confere-se depois da construção, com verify.ps1 -Mode mutation -Precheck.
            # v3.54 (mutação escrita pelo dev): trecho literal no plano só se ele JÁ existe no código, uma vez. O trecho que a
            # Task vai escrever o Arquiteto adivinhava (19 no maior plano do sprint 5 do garden) e, escrito de outro jeito pelo
            # dev, virava "inconclusivo" e 🔺 GAP ao Opus — esse se declara pela regra.
            $pf = Join-Path $Root $f
            $guess = "o trecho ainda não existe em $f — declare pela regra: '- $($m.Id) · teste ``$t`` · ``$f`` · regra: <o que a mutação quebra>' (o dev escreve o trecho sobre o código real)"
            if ($m.Find -ne '' -and (Test-Path -LiteralPath $pf -PathType Leaf)) {
                $src = Read-Text $pf; $hits = 0; $ix = $src.IndexOf($m.Find, [StringComparison]::Ordinal)
                while ($ix -ge 0) { $hits++; $ix = $src.IndexOf($m.Find, $ix + [Math]::Max(1, $m.Find.Length), [StringComparison]::Ordinal) }
                if ($hits -gt 1) { $iss += "$($m.Id): o trecho aparece $hits vezes em $f (a mutação precisa de uma ocorrência só — alongue o trecho)" }
                elseif ($hits -eq 0) { $iss += "$($m.Id): $guess" }
            } elseif ($m.Find -ne '') { $iss += "$($m.Id): $guess" }
        }
        $byRule = @($muts | Where-Object { $null -eq $_.Find }).Count
        if ($iss.Count) { Add-Result 'mutação' 'falhou' ($iss -join '; ') } else { Add-Result 'mutação' 'ok' ("$($muts.Count) mutação(ões) declaradas" + $(if ($byRule) { " ($byRule pela regra — o trecho é do dev)" } else { '' })) }
    } elseif ($noProof) { Add-Result 'mutação' 'ok' "sem mutação, com 'sem prova: <motivo>'" }
    elseif ($hasMutBlock) { Add-Result 'mutação' 'falhou' '**Mutações:** sem linha no formato "- M<k> · teste `…` · `<produção>` · regra: <o que quebra>" (ou, com trecho que já existe no código, "· `<trecho>` → `<mutante>`")' }
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

    # ---------- 31 · testes herdados (v3.55.0, A4) ----------
    # Task que corrige outra (campo **Corrige:** T-<nnn> no cabeçalho) lista os testes da Task original cuja fixture ou premissa
    # depende do que se corrige, e o que muda em cada um — ou "- nenhum — <motivo>". No sprint 5 do garden, a T-072b mudou a
    # entrada de uma regra testada e o teste herdado só apareceu no fechamento, como GAP. Plano comum não é afetado.
    $corrige = [regex]::Match($text, '(?m)^\*\*Corrige:\*\*\s*(\S.*)$')
    if (-not $corrige.Success) { Add-Result 'herdados' 'n-a' 'a Task não corrige outra (sem **Corrige:** no cabeçalho)' }
    else {
        $hm = [regex]::Match($text, '(?ms)^###\s+Testes herdados[^\r\n]*\r?\n(.*?)(?=^#{1,3}\s|\z)')
        $hl = if ($hm.Success) { @($hm.Groups[1].Value -split "`r?`n" | Where-Object { $_ -match '^\s*-\s*\S' } | ForEach-Object { $_.Trim() }) } else { @() }
        if (-not $hm.Success) { Add-Result 'herdados' 'falhou' "o plano corrige $($corrige.Groups[1].Value.Trim()) e não tem '### Testes herdados' na §6 — liste cada teste da Task original cuja fixture ou premissa depende do que se corrige e o que muda nele, ou '- nenhum — <motivo>' (regra 31)" }
        elseif (-not $hl.Count) { Add-Result 'herdados' 'falhou' "'### Testes herdados' sem linha — '- `<teste>` · <o que muda>' ou '- nenhum — <motivo>' (regra 31)" }
        elseif (@($hl | Where-Object { $_ -match '^-\s*nenhum\b' -and $_ -notmatch '^-\s*nenhum\s*[—–-]\s*\S' }).Count) { Add-Result 'herdados' 'falhou' "'- nenhum' sem motivo — escreva '- nenhum — <por que nenhum teste da Task original depende do que se corrige>' (regra 31)" }
        else { Add-Result 'herdados' 'ok' "$($hl.Count) linha(s) em ### Testes herdados ($($corrige.Groups[1].Value.Trim()))" }
    }

    # ---------- 32 · comandos da Task (v3.55.0, F1) ----------
    # Comando legítimo do projeto (docker compose run, node, aapt) só era descoberto quando a G14 o negava no meio do run: cada
    # um virava parada e formulário (≈ 25 para 4 Histórias no sprint 5 do garden). O plano declara os comandos da Task; o que
    # falta em runCommands o run.ps1 pede UMA vez ao stakeholder antes da construção (F2). Instalação, rede, push e destrutivo
    # não entram no run: reprovam aqui (bloqueio da Task, degrau 1).
    $cg = Get-PlanCommandGaps $Root $text
    if (-not $cg.Has) { Add-Result 'comandos' 'falhou' "plano sem '### Comandos da Task' (regra 32) — liste os comandos de build, teste, lint ou leitura que a construção e a verificação vão rodar além da lista base da G14 (hooks/common.ps1), ou '- nenhum além da lista base'" }
    elseif ($cg.Forbidden.Count) { Add-Result 'comandos' 'falhou' ("comando que o run nunca libera (G14): " + ($cg.Forbidden -join '; ') + " — instalação, rede, push e destrutivo não entram no run: a Task vai a bloqueio (degrau 1); tire do plano ou divida a Task") }
    elseif ($cg.Missing.Count) { Add-Result 'comandos' 'ok' ("faltam em guards.json → runCommands: " + ($cg.Missing -join '; ') + " — o run.ps1 pede a liberação ao stakeholder uma vez, antes da construção (F2)") }
    else { Add-Result 'comandos' 'ok' $(if ($cg.None) { 'nenhum além da lista base' } else { 'todos os comandos da Task já estão na lista base ou em runCommands' }) }

    # ---------- 22 · plano enxuto (v3.51; sem corte por tamanho desde a v3.53.2) ----------
    # v3.53.2 (plugin-report prévio do sprint 5 do garden, decisão do stakeholder): o teto de 20 KB fazia o Arquiteto escrever
    # e depois cortar em dezenas de edições, cada uma relendo a conversa toda — metade do custo do plano da T-042 (US$ 4,39 de
    # 8,70) e ~US$ 9 do sprint. Cortar não traz informação nova e pode tirar detalhe: o plano fica como saiu. O tamanho só
    # informa; acima de 30 KB o sinal é de Task grande (divida na quebra), nunca de cortar.
    # v3.53.6 (sprint 5 do garden, item 1): acima do teto ($PlanMaxKb, lib.ps1) o plano REPROVA — o aviso deixava a Task grande
    # ir ao dev. O remédio continua não sendo cortar: o run.ps1 next leva a Task à divisão, com os blocos deste plano como base,
    # e cada Task nova ganha plano próprio.
    $kb = Get-PlanKb $text
    if ($kb -gt $script:PlanMaxKb) { Add-Result 'tamanho' 'falhou' "$kb KB, acima de $($script:PlanMaxKb) KB: Task grande — NÃO corte nem encurte o plano (cortar relê a conversa a cada edição e não traz informação nova). A Task vai à divisão: o run.ps1 next a divide com os blocos deste plano como base e cada Task nova ganha plano próprio (regra 22). Exceção (v3.54.1): Task já em construção que passou do teto com a decisão de um 🔺 GAP não se divide — a decisão substitui o texto que derrubou, não fica ao lado" }
    else { Add-Result 'tamanho' 'ok' "$kb KB" }

    # ---------- 23 · cenários ao lado do plano (v3.51) ----------
    $cm = [regex]::Match($text, '(?m)^\*\*Cen[áa]rios:\*\*\s*(.+)$')
    if (-not $cm.Success) { Add-Result 'cenários' 'falhou' "cabeçalho sem **Cenários:** SC-… | nenhum — <motivo> (regra 23)" }
    elseif ($cm.Groups[1].Value -match '^\s*nenhum\s*[—-]\s*\S') { Add-Result 'cenários' 'ok' ($cm.Groups[1].Value.Trim()) }
    else {
        # v3.53.2: "SC-nnn (teste)" se prova pelos testes do plano, sem .scn; "# aguarda <T-ID>: SC-…" no .scn vale como declarado.
        $allIds = @([regex]::Matches($cm.Groups[1].Value, '\b[A-Z]{2,}-\d+\b') | ForEach-Object { $_.Value } | Select-Object -Unique)
        $ids = @([regex]::Matches($cm.Groups[1].Value, '\b[A-Z]{2,}-\d+\b(?!\s*\((?i:teste)\))') | ForEach-Object { $_.Value } | Select-Object -Unique)
        $scnDir = Join-Path $Root '.team-project/quality-assurance/scenarios'
        $scn = @(Get-ChildItem -Path $scnDir -Filter '*.scn' -File -ErrorAction SilentlyContinue)
        if (-not $allIds.Count) { Add-Result 'cenários' 'falhou' '**Cenários:** sem identificador (SC-nnn) nem "nenhum — <motivo>"' }
        elseif (-not $ids.Count) { Add-Result 'cenários' 'ok' "todos provados por teste do plano, sem .scn: $($allIds -join ', ')" }
        elseif (-not $scn.Count -and -not (Get-TargetsConfig $Root)) { Add-Result 'cenários' 'n-a' "sem alvo de execução (guards.json sem ""targets""): $($ids -join ', ') rastreados no plano e provados por teste, sem .scn (v3.51.4)" }
        elseif (-not $scn.Count) { Add-Result 'cenários' 'falhou' "nenhum arquivo .scn em .team-project/quality-assurance/scenarios/ — o QA escreve os cenários executáveis antes do dev (regra 23)" }
        else {
            $defined = @($scn | ForEach-Object { [regex]::Matches((Read-Text $_.FullName), '(?m)^\s*scenario\s+(\S+)') } | ForEach-Object { $_.Groups[1].Value })
            $defer = Get-DeferredScenarios $Root
            $miss = @($ids | Where-Object { $defined -notcontains $_ -and -not $defer.ContainsKey($_) })
            $wait = @($ids | Where-Object { $defined -notcontains $_ -and $defer.ContainsKey($_) } | ForEach-Object { "$_ (aguarda $($defer[$_]))" })
            $tst = @($allIds | Where-Object { $ids -notcontains $_ })
            $tail = $(if ($wait.Count) { "; " + ($wait -join ', ') } else { '' }) + $(if ($tst.Count) { "; por teste: " + ($tst -join ', ') } else { '' })
            if ($miss.Count) { Add-Result 'cenários' 'falhou' ("cenário(s) citado(s) sem definição nos .scn: " + ($miss -join ', ')) }
            else { Add-Result 'cenários' 'ok' "$($ids.Count) cenário(s) da Task nos arquivos .scn: $($ids -join ', ')$tail" }
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
        $okN = 0; $okHead = 0; $changed = $null
        foreach ($c in $cnt) {
            $re = $c.Groups[1].Value; $globs = @($c.Groups[2].Value -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ }); $want = [int]$c.Groups[3].Value
            try { $rx = New-Object System.Text.RegularExpressions.Regex($re) } catch { $iss += "regex inválida ``$re``"; continue }
            $got = 0
            foreach ($f in @($tracked | Where-Object { Test-GlobMatch (Normalize-PathText $_) $globs })) {
                $fp = Join-Path $Root $f; if (-not (Test-Path -LiteralPath $fp -PathType Leaf)) { continue }
                foreach ($ln in [System.IO.File]::ReadAllLines($fp)) { if ($rx.IsMatch($ln)) { $got++ } }
            }
            if ($got -eq $want) { $okN++; continue }
            # v3.54.1 (carta do sprint 5 do garden, item 2): plano reconferido com a construção no meio (decisão de 🔺 GAP) —
            # o dev já mexeu na árvore e a contagem escrita antes dela divergia sempre. Vale também a do último commit (HEAD):
            # a árvore de trabalho menos o que mudou nos arquivos alterados, mais o que eles tinham no HEAD.
            if ($isGit) {
                $ErrorActionPreference = 'Continue'
                if ($null -eq $changed) { $changed = @(& git -C $Root -c core.quotepath=off diff --name-only HEAD 2>$null | Where-Object { $_ }); if ($LASTEXITCODE -ne 0) { $changed = @() } }
                $hd = $got; $hdOk = $true
                $prevEnc = [Console]::OutputEncoding
                try {
                    try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }
                    foreach ($f in @($changed | Where-Object { Test-GlobMatch (Normalize-PathText $_) $globs })) {
                        $fp = Join-Path $Root $f
                        if (Test-Path -LiteralPath $fp -PathType Leaf) { foreach ($ln in [System.IO.File]::ReadAllLines($fp)) { if ($rx.IsMatch($ln)) { $hd-- } } }
                        $old = @(& git -C $Root show "HEAD:$f" 2>$null)
                        if ($LASTEXITCODE -eq 0) { foreach ($ln in $old) { if ($rx.IsMatch([string]$ln)) { $hd++ } } }
                    }
                } catch { $hdOk = $false } finally { try { [Console]::OutputEncoding = $prevEnc } catch { } }
                $ErrorActionPreference = 'Stop'
                if ($hdOk -and $changed.Count -and $hd -eq $want) { $okN++; $okHead++; continue }
            }
            $iss += "``$re`` em ``$($globs -join ';')``: o plano diz $want, a recontagem dá $got"
        }
        if ($iss.Count) { Add-Result 'contagem' 'falhou' (($iss -join '; ') + ' (regra 26)') } else { Add-Result 'contagem' 'ok' "$okN contagem(ns) recontada(s) e iguais$(if ($okHead) { " ($okHead pelo último commit: a árvore de trabalho já tem a construção)" })$(if (-not $isGit) { ' (sem git: arquivos do disco)' })" }
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
    # v3.53.7 (encadeamento do sprint 5 do garden): no maior plano, 9 premissas de layout saíram da leitura do código do
    # framework (node_modules) e as 4 decisões de 🔺 GAP da Task vieram do render real. Geometria não se lê no código: com
    # **Layout novo:** sim, premissa sobre posição, tamanho, sobreposição ou rolagem é medida EXECUTANDO (sonda de render do
    # operator, teste de render, verify) ou fica "não exercitada" com quem verifica no render.
    if ($layNew) {
        $geoRe = '(?i)\b(px|dp|rem|vh|vw|largura|altura|posi[çc][ãa]o|sobrep\w*|transbord\w*|margem|margin|padding|overlay|popover|modal|viewport|z-index|flexbox|grid|alinhad\w*|rolagem|scroll\w*|layout|geometria|font-size|quebra de linha)\b'
        $rtNames = @([regex]::Matches($text, '(?ms)^\*\*Render real\*\*.*?(?=^\*\*Cobertura|^##\s|\z)') | ForEach-Object { [regex]::Matches($_.Value, '(?m)^\|\s*`([^`]+)`') } | ForEach-Object { [regex]::Escape((Split-Path ($_.Groups[1].Value -replace '\\', '/') -Leaf)) })
        $runRe = '(?i)operator/|verify\.ps1|accept\.ps1|playwright|\bnpx\b|\bnpm\s+(run\s+)?test|\bng\s+test|vitest|jest|karma|gradlew' + $(if ($rtNames.Count) { '|' + ($rtNames -join '|') } else { '' })
        foreach ($pp in $pl) {
            $mm = [regex]::Match($pp, '^\s*-\s*(P\d+)\s*·\s*(.*?)\s*·\s*medido:\s*(.*)$')
            if (-not $mm.Success -or $mm.Groups[2].Value -notmatch $geoRe -or $mm.Groups[3].Value -match $runRe) { continue }
            $iss += "$($mm.Groups[1].Value) é premissa de layout medida por leitura (medido: $(($mm.Groups[3].Value -split '→')[0].Trim() -replace '`', '')): o código, inclusive o do framework, não diz a geometria — meça numa sonda de render pelo operator (job operator/<n>/<T-ID>-plano/, linha na §11) ou declare 'não exercitada: <motivo> · verifica: dev em <passo do teste de render>'"
        }
    }
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
        $gone = Get-FichaMissing $Root $ficha
        if ($gone.Count) { $iss += "a ficha aponta caminho que não existe (corrija em architect/breakdown/S$($sm.Groups[1].Value).md): " + ($gone -join ', ') }
        if ($iss.Count) { Add-Result 'ficha' 'falhou' (($iss -join '; ') + ' (regra 28)') }
        else {
            $extra = if ($lm.Groups[1].Value -match '^\s*nenhum') { 0 } else { @([regex]::Matches($lm.Groups[1].Value, '`[^`]+`')).Count }
            # v3.53.2: previsto na quebra × arquivos do plano — mede a estimativa que decide a divisão da Task (só informa).
            $prev = if ($null -ne $ficha.Planned) { "; arquivos previstos $($ficha.Planned), no plano $(@($files).Count)" } else { '' }
            Add-Result 'ficha' 'ok' "$($ficha.Names.Count) nome(s) comum(ns) no plano; $(@($ficha.Read).Count + @($ficha.Sources).Count) caminho(s) da ficha existem; li além da ficha: $extra$prev"
        }
    }

    # ---------- 29 · decisões do sprint citadas, não copiadas (v3.53.7, encadeamento do sprint 5 do garden) ----------
    # A mesma decisão de 🔺 GAP (emulador fora, teste instável) foi colada em 8 planos; os acréscimos chegaram a 57 % de um
    # plano, relidos por cada instância nova do dev. A decisão que vale para mais de uma Task fica uma vez na ficha comum do
    # sprint (architect/decisions/S<n>.md); o plano a cita em **Decisões do sprint:** e o cartão do dev a traz em uma linha.
    # v3.56.0 (A e B): a mesma regra, ampliada — (1) a linha passa a **Decisões:** D-<k>, K-<n> (o rótulo antigo vale) e cita
    # também o conhecimento do projeto (architect/knowledge.md): K que não existe reprova, texto de K copiado reprova; (2) toda
    # decisão de 🔺 GAP — no plano ("**Decisão do GAP …:**") e cada D-<k> que vale para esta Task — declara **Origem:** e
    # **Lição:**; valor fora da lista reprova. Sprint anterior ao "**Classificação desde:**" do knowledge.md (as D escritas
    # antes da 3.56.0) ou projeto sem knowledge.md: a decisão sem as linhas só avisa.
    $dsn = if ($sm.Success) { $sm.Groups[1].Value } else { '' }
    $decs = @(if ($dsn) { Get-SprintDecisions $Root $dsn })
    $refs = @(Get-PlanDecisionRefs $text)
    $kns = @(Get-ProjectKnowledge $Root)
    $krefs = @(Get-PlanKnowledgeRefs $text)
    $pgd = @(Get-PlanGapDecisions $text)
    if (-not $decs.Count -and -not $refs.Count -and -not $krefs.Count -and -not $pgd.Count) { Add-Result 'decisões' 'n-a' 'sem decisões do sprint (architect/decisions/S<n>.md), sem K citada e sem decisão de GAP no plano' }
    else {
        $iss = @(); $warn = @()
        $strict = Test-LessonStrict $Root $dsn
        $unk = @($refs | Where-Object { @($decs | ForEach-Object { $_.Id }) -notcontains $_ })
        if ($unk.Count) { $iss += "cita $($unk -join ', ') que não existe(m) em architect/decisions/S$dsn.md" }
        $kunk = @($krefs | Where-Object { @($kns | ForEach-Object { $_.Id }) -notcontains $_ })
        if ($kunk.Count) { $iss += "cita $($kunk -join ', ') que não existe(m) em architect/knowledge.md" }
        foreach ($d in @(@($decs) + @($kns))) {
            $cp = @($d.Body -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_.Length -ge 40 -and $_ -notmatch $script:EntryMetaRe -and $text.Contains($_) })
            if ($cp.Count) { $iss += "copia o texto da $($d.Id) ('$(if ($cp[0].Length -gt 60) { $cp[0].Substring(0, 60) + '…' } else { $cp[0] })') — cite ``$($d.Id)`` em **Decisões:**; o cartão do dev a traz" }
        }
        # Origem e Lição: as D que chegam a esta Task (todas, as que a citam e as citadas) e as decisões de GAP do plano.
        $tid = $fid   # o T-ID do nome do arquivo (plan/<T-ID>-<slug>.md)
        $mine = @($decs | Where-Object { $_.All -or ($tid -and @($_.Ids) -contains $tid) -or ($refs -contains $_.Id) })
        $cls = @(@($mine | ForEach-Object { [pscustomobject]@{ Who = $_.Id; C = $_.Class } }) + @($pgd | ForEach-Object { $h = $_.Head; [pscustomobject]@{ Who = "'$(if ($h.Length -gt 40) { $h.Substring(0, 40) + '…' } else { $h })'"; C = (Get-LessonClass $_.Text) } }))
        foreach ($c in $cls) {
            if ($c.C.Issues.Count) { $iss += "$($c.Who): $($c.C.Issues -join ', ')" }
            elseif (-not $c.C.Classified) {
                $msg = "$($c.Who) sem **Origem:** e **Lição:** (decisão de GAP declara a origem — previsão | conhecimento | requisito | ambiente | processo — e o destino da lição — projeto | stack:<nome> | plugin | nenhuma)"
                if ($strict) { $iss += $msg } else { $warn += "$($c.Who) sem classificação (anterior à 3.56.0: só aviso)" }
            }
        }
        $cites = @(@($refs) + @($krefs))
        if ($iss.Count) { Add-Result 'decisões' 'falhou' (($iss -join '; ') + ' (regra 29)') }
        else { Add-Result 'decisões' 'ok' ("$(if ($cites.Count) { "cita $($cites -join ', ')" } else { 'nenhuma citada' }); $($decs.Count) decisão(ões) no sprint, $($kns.Count) K no projeto, nenhuma copiada" + $(if ($warn.Count) { '; ' + ($warn -join '; ') } else { '' })) }
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
    # v3.53.6 (item 1): reprovado por tamanho, o plano não volta para correção (nem das outras linhas): a Task se divide.
    if (@($script:Results | Where-Object { $_.Regra -eq 'tamanho' -and $_.Resultado -eq 'falhou' }).Count) { [Console]::Out.WriteLine(''); [Console]::Out.WriteLine("**Plano não vai ao dev — Task grande ($kb KB):** não corte, não encurte nem corrija as outras linhas; deixe o plano como está e volte dizendo 'tamanho'. O run.ps1 next divide a Task com os blocos deste plano como base."); exit 1 }
    if (@($script:Results | Where-Object { $_.Resultado -eq 'falhou' }).Count) { [Console]::Out.WriteLine(''); [Console]::Out.WriteLine('**Plano não vai ao dev:** volta ao Arquiteto com esta tabela.'); exit 1 }
    exit 0
} catch {
    [Console]::Error.WriteLine("plano: erro — $($_.Exception.Message)")
    exit 2
}
