# Plano externo (v3.53.4): funções do run.ps1 (dot-source) para planejar fora do Claude. Com guards.json →
# "run": { "planner": "external", "tasks": [] }, o run.ps1 next não dispara o Arquiteto Opus para a Task com ficha: monta
# um pacote por História em sprints/<n>/pack/out/ (roteiro INSTRUCTIONS.md, fichas, modelo do plano, contexto e os
# arquivos que a ficha aponta), o stakeholder o leva a um assistente de fora (app do Codex, chat na web) e devolve os
# planos em pack/in/. O next seguinte lê o retorno, roda o plan.ps1 em cada plano e só então o aceita (coluna Plano do
# quadro); reprovado volta num pacote de correção. O 🔺 GAP de plano da Task também vai num pacote (run.ps1 done).
# Origem: sprint 5 do garden — o plano do Arquiteto foi ~2/3 do custo do sprint; o pedido do stakeholder era tirar do
# limite da conta o trabalho que mais pesa, mantendo as conferências (plan.ps1, verify, accept, close) iguais.
# Usa as variáveis do run.ps1: $Root, $S, $n, $tasks, $utf8.

Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem

function Get-PackDir { return (Join-Path $S 'pack') }

# Estado do que está fora: packs[História] = { name, round, tasks, rejected, at } · gaps[T-ID] = { name, round, gap, fix, at }.
function Get-PackState {
    $p = Join-Path (Get-PackDir) 'state.json'; $st = @{ packs = @{}; gaps = @{} }
    if (-not (Test-Path -LiteralPath $p)) { return $st }
    try { $j = Read-Text $p | ConvertFrom-Json } catch { return $st }
    if ($j.packs) { foreach ($k in $j.packs.PSObject.Properties) { $v = $k.Value; $st.packs[$k.Name] = @{ name = [string]$v.name; round = [int]$v.round; tasks = @($v.tasks | ForEach-Object { [string]$_ }); rejected = @($v.rejected | ForEach-Object { [string]$_ }); at = [string]$v.at } } }
    if ($j.gaps) { foreach ($k in $j.gaps.PSObject.Properties) { $v = $k.Value; $st.gaps[$k.Name] = @{ name = [string]$v.name; round = [int]$v.round; gap = [string]$v.gap; fix = [bool]$v.fix; at = [string]$v.at } } }
    return $st
}
function Save-PackState($St) {
    $o = [ordered]@{ packs = [ordered]@{}; gaps = [ordered]@{} }
    foreach ($k in @($St.packs.Keys | Sort-Object)) { $v = $St.packs[$k]; $o.packs[$k] = [ordered]@{ name = $v.name; round = $v.round; tasks = @($v.tasks); rejected = @($v.rejected); at = $v.at } }
    foreach ($k in @($St.gaps.Keys | Sort-Object)) { $v = $St.gaps[$k]; $o.gaps[$k] = [ordered]@{ name = $v.name; round = $v.round; gap = $v.gap; fix = [bool]$v.fix; at = $v.at } }
    $d = Get-PackDir; New-Item -ItemType Directory -Force $d | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $d 'state.json'), ($o | ConvertTo-Json -Depth 6), $utf8)
}

function ConvertTo-Slug([string]$Text) {
    $d = $Text.Normalize([System.Text.NormalizationForm]::FormD); $sb = New-Object System.Text.StringBuilder
    foreach ($c in $d.ToCharArray()) { if ([System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($c) -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) { [void]$sb.Append($c) } }
    $s = ($sb.ToString().ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
    if ($s.Length -gt 40) { $s = $s.Substring(0, 40).Trim('-') }
    if (-not $s) { $s = 'plano' }
    return $s
}

# Linha da Task no quadro (tabelas com cabeçalho "ID"): índice, células e a coluna Plano. $null se não achar.
function Find-BoardRow([string[]]$Lines, [string]$Id) {
    $header = $null
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $line = $Lines[$i]
        if (-not $line.TrimStart().StartsWith('|')) { $header = $null; continue }
        $cells = @(Split-Row $line)
        if ((Clean-Cell $cells[0]) -eq 'ID') { $header = @($cells | ForEach-Object { Clean-Cell $_ }); continue }
        if (-not $header) { continue }
        $m = [regex]::Match($cells[0], $script:TaskIdRe)
        if ($m.Success -and $m.Value -eq $Id) {
            $pc = -1; for ($k = 0; $k -lt $header.Count; $k++) { if ($header[$k] -like '*Plano*') { $pc = $k; break } }
            return @{ Index = $i; Cells = $cells; PlanCol = $pc }
        }
    }
    return $null
}
# Onde o plano aceito vai: o nome que a Planning já pôs na coluna Plano (`plan/T-045-x.md`), senão plan/<T-ID>-<slug>.md.
function Get-PlanDest($T) {
    $bp = Join-Path $S 'sprint-backlog.md'
    $row = Find-BoardRow @((Read-Text $bp) -split "`r?`n") $T.Id
    if ($row -and $row.PlanCol -ge 0 -and $row.PlanCol -lt $row.Cells.Count) {
        $m = [regex]::Match($row.Cells[$row.PlanCol], '`(plan/' + [regex]::Escape($T.Id) + '(?:[-_.][^`/]*)?\.md)`')
        if ($m.Success) { return $m.Groups[1].Value }
    }
    return "plan/$($T.Id)-$(ConvertTo-Slug $T.Title).md"
}
# Grava o link do plano na coluna Plano da Task (o que a sessão faz à mão depois do Arquiteto).
function Set-BoardPlan([string]$Id, [string]$Rel) {
    $bp = Join-Path $S 'sprint-backlog.md'
    return (Invoke-WithFileLock $bp {
        $txt = Read-Text $bp; $nl = if ($txt -match "`r`n") { "`r`n" } else { "`n" }
        $lines = @($txt -split "`r?`n")
        $row = Find-BoardRow $lines $Id
        if (-not $row -or $row.PlanCol -lt 0) { return $false }
        $c = @($row.Cells); while ($c.Count -le $row.PlanCol) { $c += '' }
        $c[$row.PlanCol] = "[``$Rel``]($Rel)"
        $lines[$row.Index] = '| ' + ($c -join ' | ') + ' |'
        [System.IO.File]::WriteAllText($bp, ($lines -join $nl), $utf8)
        return $true
    })
}

# Zip com "/" nos nomes (o Compress-Archive do 5.1 grava "\" e o zip abre torto fora do Windows).
function New-ZipFromDir([string]$Dir, [string]$Zip) {
    if (Test-Path -LiteralPath $Zip) { Remove-Item -LiteralPath $Zip -Force }
    $base = (Get-Item -LiteralPath $Dir).FullName.TrimEnd('\', '/')
    $fs = [System.IO.File]::Open($Zip, [System.IO.FileMode]::CreateNew)
    try {
        $za = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create)
        try { foreach ($f in @(Get-ChildItem -LiteralPath $base -Recurse -File)) { $null = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($za, $f.FullName, ($f.FullName.Substring($base.Length + 1) -replace '\\', '/')) } }
        finally { $za.Dispose() }
    } finally { $fs.Dispose() }
}

# Arquivo apontado pela ficha → files/<caminho do projeto> ou files/plugin/<caminho no plugin>. Devolve o caminho no pacote.
function Copy-PackFile([string]$Rel, [string]$Dir) {
    $src = Resolve-FichaPath $Root $Rel
    if (-not (Test-Path -LiteralPath $src -PathType Leaf)) { return $null }
    $dst = if ($Rel -match '^\$\{CLAUDE_PLUGIN_ROOT\}/(.+)$') { "files/plugin/$($Matches[1])" } elseif ($Rel -match '^standards/') { "files/plugin/$Rel" } else { "files/$Rel" }
    $to = Join-Path $Dir $dst; New-Item -ItemType Directory -Force (Split-Path $to) | Out-Null
    Copy-Item -LiteralPath $src -Destination $to -Force
    return $dst
}

# Ambiente de referência: a §3 do plano mais recente que a tem com tabela (o assistente de fora não roda comando).
# v3.57.7 (sprint 6 do garden, T-067): só de plano escrito no Claude. O plano que veio de fora não mediu nada — a §3 dele é a
# do pacote anterior, recopiada (T-080 → T-081 → T-067, todas as linhas "sem medição") — e servia de fonte ao pacote seguinte.
function Get-SprintEnv {
    $st = Get-PackState
    $ext = @(@($st.packs.Values | ForEach-Object { @($_.tasks) }) + @($st.gaps.Keys) | Where-Object { $_ } | Select-Object -Unique)
    foreach ($f in @(Get-ChildItem -LiteralPath (Join-Path $S 'plan') -Filter '*.md' -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)) {
        $fid = [regex]::Match($f.Name, '^' + $script:TaskIdRe)
        if ($fid.Success -and $ext -contains $fid.Value) { continue }
        $s3 = Get-Section (Read-Text $f.FullName) '^##\s+3\.'
        if ($s3 -and $s3 -match '(?i)Sa[íi]da real') { return @{ Src = "sprints/$n/plan/$($f.Name)"; Text = $s3.Trim() } }
    }
    return $null
}

# v3.57.7 (sprint 6 do garden, T-067): o run mede o ambiente ao montar o pacote. Com o plano externo, ninguém rodava comando:
# o Arquiteto do Claude, que media a §3, saiu do caminho, e o assistente de fora não executa nada. Com **Layout novo:** sim, a
# conferência exige o navegador headless medido na §3 (regra 21) e ao menos uma premissa medido: (regra 26) — impossível de
# cumprir com o environment.md recopiado, e o pacote de correção voltaria reprovado nas mesmas linhas. Sondas curtas, com
# prazo (Invoke-Bounded), sem instalar nada: runtime pela pasta do front-end (package.json), navegador headless (CHROME_BIN,
# senão o Chrome instalado, senão o Chromium do Playwright) aberto de verdade, adb com alvo android, dotnet e python pelo
# arquivo de projeto. Devolve as linhas da tabela e a saída bruta.
function Find-FrontDir {
    if (Test-Path -LiteralPath (Join-Path $Root 'package.json')) { return '.' }
    foreach ($d in @(Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^(\.|node_modules$)' } | Sort-Object Name)) {
        if (Test-Path -LiteralPath (Join-Path $d.FullName 'package.json')) { return $d.Name }
    }
    return $null
}
function Find-HeadlessBrowser {
    if ($env:CHROME_BIN) { return @{ Path = $env:CHROME_BIN; Src = 'CHROME_BIN'; Exists = (Test-Path -LiteralPath $env:CHROME_BIN -PathType Leaf) } }
    foreach ($p in @("$env:ProgramFiles\Google\Chrome\Application\chrome.exe", "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe", "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe")) {
        if ($p -and (Test-Path -LiteralPath $p -PathType Leaf)) { return @{ Path = $p; Src = 'Chrome instalado'; Exists = $true } }
    }
    $pw = Join-Path ([string]$env:LOCALAPPDATA) 'ms-playwright'
    foreach ($d in @(Get-ChildItem -LiteralPath $pw -Directory -Filter 'chromium-*' -ErrorAction SilentlyContinue | Sort-Object Name -Descending)) {
        $exe = Join-Path $d.FullName 'chrome-win\chrome.exe'
        if (Test-Path -LiteralPath $exe -PathType Leaf) { return @{ Path = $exe; Src = 'Chromium do Playwright (o Karma só o usa com CHROME_BIN)'; Exists = $true } }
    }
    return $null
}
function ConvertTo-EnvCell([string]$Text) {
    $l = @(([string]$Text) -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }) | Select-Object -First 1
    $l = ([string]$l -replace '[<>|`]', ' ' -replace '\s+', ' ').Trim()
    if ($l.Length -gt 120) { $l = $l.Substring(0, 120) + '…' }
    return $l
}
function Measure-PackEnv {
    $rows = @()
    $probe = {
        param([string]$Need, [string]$Show, [string]$Cmd, [int]$Sec, [scriptblock]$Summary)
        $r = Invoke-Bounded $Root $Cmd $Sec
        $rawTxt = "### $Need`n> $Show`n" + [string]$r.out + "`n(exit $($r.exit)$(if ($r.timedOut) { ", sem resposta em $Sec s" }))`n"
        $ok = [bool]((-not $r.timedOut) -and $r.exit -eq 0 -and ([string]$r.out).Trim())
        $out = if ($r.timedOut) { "sem resposta em $Sec s" } elseif ($Summary -and $ok) { & $Summary ([string]$r.out) } elseif ($ok) { ConvertTo-EnvCell $r.out } else { $c = ConvertTo-EnvCell $r.out; if ($c) { "$c (exit $($r.exit))" } else { "sem saída (exit $($r.exit))" } }
        return @{ Need = $Need; Show = $Show; Out = $out; Ok = $ok; Raw = $rawTxt }
    }
    $front = Find-FrontDir
    $tg = Get-TargetsConfig $Root
    if ($front) {
        $fp = if ($front -eq '.') { '' } else { "$front/" }
        $rows += & $probe 'Node.js' 'node --version' 'node --version' 20 $null
        $rows += & $probe 'npm' 'npm --version' 'npm --version' 30 $null
        $nm = "${fp}node_modules"
        $rows += & $probe "Dependências instaladas em $(if ($front -eq '.') { 'a raiz' } else { $front })" "Test-Path $nm" "if (Test-Path -LiteralPath '$nm') { 'True' } else { 'False'; exit 1 }" 10 $null
        if (Test-Path -LiteralPath (Join-Path $Root "${fp}angular.json")) {
            $core = "${fp}node_modules/@angular/core/package.json"
            $rows += & $probe 'Angular (@angular/core instalado)' "(ConvertFrom-Json (Get-Content $core -Raw)).version" "(ConvertFrom-Json (Get-Content -LiteralPath '$core' -Raw)).version" 15 $null
        }
        $webish = (Test-Path -LiteralPath (Join-Path $Root "${fp}angular.json")) -or @(Get-ChildItem -LiteralPath (Join-Path $Root ($(if ($front -eq '.') { '.' } else { $front }))) -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^(karma\.conf|playwright\.config|vitest\.config)' }).Count -or ($tg -and $tg.PSObject.Properties['web'])
        if ($webish) {
            $b = Find-HeadlessBrowser
            if (-not $b) { $rows += @{ Need = 'Navegador headless do teste de render'; Show = 'CHROME_BIN; Chrome instalado; Chromium do Playwright'; Out = 'nenhum encontrado'; Ok = $false } }
            elseif (-not $b.Exists) { $rows += @{ Need = 'Navegador headless do teste de render'; Show = "Test-Path `$env:CHROME_BIN"; Out = "CHROME_BIN aponta para arquivo que não existe: $(ConvertTo-EnvCell $b.Path)"; Ok = $false } }
            else {
                $ud = Join-Path ([System.IO.Path]::GetTempPath()) ('team-headless-' + [guid]::NewGuid().ToString('N'))
                $ver = try { [string](Get-Item -LiteralPath $b.Path).VersionInfo.ProductVersion } catch { '' }
                $sum = [scriptblock]::Create("param(`$o) 'abriu headless e devolveu o DOM (exit 0)$(if ($ver) { " · versão $ver" }) · $($b.Src)'")
                $rows += & $probe 'Navegador headless do teste de render' "& '$($b.Path)' --headless=new --dump-dom about:blank" "& '$($b.Path)' --headless=new --disable-gpu --no-first-run --user-data-dir='$ud' --dump-dom about:blank" 40 $sum
                Remove-Item -LiteralPath $ud -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }
    if ($tg -and $tg.PSObject.Properties['android']) {
        $adb = $null
        $gc = Get-Command adb -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($gc) { $adb = $gc.Source } else { foreach ($h in @($env:ANDROID_HOME, $env:ANDROID_SDK_ROOT)) { if ($h -and (Test-Path -LiteralPath (Join-Path $h 'platform-tools\adb.exe'))) { $adb = Join-Path $h 'platform-tools\adb.exe'; break } } }
        if (-not $adb) { $rows += @{ Need = 'adb (alvo android)'; Show = 'Get-Command adb; ANDROID_HOME'; Out = 'adb não encontrado no PATH nem no ANDROID_HOME'; Ok = $false } }
        else {
            $rows += & $probe 'adb (alvo android)' 'adb version' "& '$adb' version" 15 $null
            $dev = { param($o) $ls = @($o -split "`r?`n" | Where-Object { $_ -match '^\S+\s+device\b' } | ForEach-Object { ($_ -split '\s+')[0] }); if ($ls.Count) { "$($ls.Count) aparelho(s): $($ls -join ', ')" } else { 'nenhum aparelho conectado — o alvo sobe pelo target.ps1 -Repair' } }
            $dr = & $probe 'Aparelho ou emulador android' 'adb devices' "& '$adb' devices" 15 $dev
            if ($dr.Out -match '^nenhum aparelho') { $dr.Ok = $false }
            $rows += $dr
        }
    }
    $top = @(Get-ChildItem -LiteralPath $Root -File -ErrorAction SilentlyContinue) + @(Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^(\.|node_modules$)' } | ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -File -ErrorAction SilentlyContinue })
    if (@($top | Where-Object { $_.Extension -in '.sln', '.csproj' }).Count) { $rows += & $probe '.NET SDK' 'dotnet --version' 'dotnet --version' 30 $null }
    if (@($top | Where-Object { $_.Name -in 'pyproject.toml', 'requirements.txt' }).Count) { $rows += & $probe 'Python' 'python --version' 'python --version' 15 $null }
    return @{ Rows = $rows; Raw = (@($rows | ForEach-Object { $_.Raw } | Where-Object { $_ }) -join "`n") }
}
# O environment.md do pacote: o que o run mediu agora (tabela no formato da §3 e premissas prontas) e, de referência, a §3 do
# último plano escrito no Claude.
function Write-PackEnv([string]$Ctx) {
    $m = Measure-PackEnv; $ref = Get-SprintEnv
    $when = Get-Date -Format 'dd/MM/yyyy HH:mm'
    $logRel = ".team-project/sprints/$n/pack/environment.log"
    if ($m.Raw) { New-Item -ItemType Directory -Force (Get-PackDir) | Out-Null; [System.IO.File]::WriteAllText((Join-Path (Get-PackDir) 'environment.log'), "# Saída bruta das sondas do run.ps1 · $when`n`n" + $m.Raw, $utf8) }
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.Append("# Ambiente medido neste sprint`n`n")
    if ($m.Rows.Count) {
        [void]$sb.Append("> Medido pelo ``run.ps1`` do plugin ao montar este pacote, em $when, na máquina onde o dev vai construir. Copie para a §3 do plano as linhas que valem para a Task, **como estão**, com a fonte ``context/environment.md (run.ps1, $when)``. Pré-requisito que não está aqui: premissa ``- P<k> · não exercitada: <motivo> · verifica: dev no passo 1`` — nunca uma saída inventada.`n`n")
        [void]$sb.Append("| Pré-requisito | Comando de medição | Saída real (recortada) | Log bruto | Atende ao plano? |`n|---|---|---|---|---|`n")
        foreach ($r in $m.Rows) { [void]$sb.Append("| $($r.Need) | ``$($r.Show)`` | $($r.Out) | ``$logRel`` | $(if ($r.Ok) { '**sim**' } else { '**não** — medir de novo antes do passo 1; ausente, é 🔺 GAP (§9)' }) |`n") }
        $okRows = @($m.Rows | Where-Object { $_.Ok })
        if ($okRows.Count) {
            [void]$sb.Append("`n## Premissas prontas`n`nPara a ``### Premissas`` da §6. Com ``**Layout novo:** sim``, a conferência exige ao menos uma ``medido:``; estas valem como estão (renumere o P):`n`n")
            $k = 0; foreach ($r in $okRows) { $k++; [void]$sb.Append("- P$k · ambiente: $($r.Need) · medido: ``$($r.Show)`` → $($r.Out)`n") }
            [void]$sb.Append("`nGeometria (posição, tamanho, sobreposição, rolagem) não é ambiente: não se mede lendo código — vai no envelope de medidas, com a sonda que o dev roda.`n")
        }
    } else {
        [void]$sb.Append("> O ``run.ps1`` não achou o que medir neste projeto (sem ``package.json``, alvo android, ``.sln``/``.csproj`` nem ``pyproject.toml``). Pré-requisito do plano: premissa ``- P<k> · não exercitada: <motivo> · verifica: dev no passo 1`` — nunca uma saída inventada.`n")
    }
    if ($ref) { [void]$sb.Append("`n## Referência: §3 do último plano escrito no Claude`n`n> Fonte: ``$($ref.Src)``. Medido em outra data; quando falar do mesmo pré-requisito que a tabela acima, vale a de cima.`n`n$($ref.Text)`n") }
    [System.IO.File]::WriteAllText((Join-Path $Ctx 'environment.md'), $sb.ToString(), $utf8)
}

# Monta o pacote: Kind 'story' (planos da História; Round > 1 = correção) ou 'gap' (decisão do 🔺 GAP de uma Task).
function New-PlanPack([string]$Story, $Items, [int]$Round, [string]$Kind = 'story', [string]$GapLine = '') {
    $pk = Get-PackDir; $outDir = Join-Path $pk 'out'; New-Item -ItemType Directory -Force $outDir | Out-Null
    $safe = ($Story -replace '[^\w.-]+', '-').Trim('-')
    $name = if ($Kind -eq 'gap') { "$($Items[0].Id)-gap" + $(if ($Round -gt 1) { $Round } else { '' }) } else { $safe + $(if ($Round -gt 1) { "-fix$($Round - 1)" } else { '' }) }
    $dir = Join-Path $outDir $name
    if (Test-Path -LiteralPath $dir) { Remove-Item -LiteralPath $dir -Recurse -Force }
    New-Item -ItemType Directory -Force $dir | Out-Null
    $plug = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
    $ids = @($Items | ForEach-Object { $_.Id })
    # Ordem: quem depende de outra Task do pacote vem depois dela.
    $order = @(); $left = @($Items)
    while ($left.Count) {
        $ok = @($left | Where-Object { $t = $_; -not @($t.Deps | Where-Object { $ids -contains $_ -and @($order | ForEach-Object { $_.Id }) -notcontains $_ }).Count })
        if (-not $ok.Count) { $ok = @($left[0]) }
        $order += $ok[0]; $left = @($left | Where-Object { $_.Id -ne $ok[0].Id })
    }
    $bdRel = ".team-project/architect/breakdown/S$n.md"; $scnIds = @(); $copied = @{}
    foreach ($t in $order) {
        $f = Get-Ficha $Root $n $t.Id
        $depSum = @($t.Deps | Where-Object { $ids -notcontains $_ } | ForEach-Object { $d = $_; $dt = @($tasks | Where-Object { $_.Id -eq $d }) | Select-Object -First 1; if ($dt) { $pf = Get-PlanFull $dt $S; if ($pf) { "## Plano da dependência — resumo de ``sprints/$n/$($dt.Plan)```n`n" + (Get-PlanSummary $pf) } } })
        $card = "# Ficha da $($t.Id) — $($t.Title)`n`n> Recorte de ``$bdRel`` (a quebra da Planning).`n`n" + $(if ($f -and $f.Common) { $f.Common + "`n`n" } else { '' }) + $(if ($f) { $f.Body } else { '(sem ficha)' }) + "`n" + $(if ($depSum.Count) { "`n" + ($depSum -join "`n`n") + "`n" } else { '' }) + (Get-DecisionsDigest $Root $n) + (Get-KnowledgeDigest $Root) + (Get-StackPitfallDigest $Root $n $t.Id)   # v3.53.7: decisões do sprint · v3.56.0: conhecimento do projeto e armadilhas da stack
        $tf = Join-Path $dir "tasks/$($t.Id)-ficha.md"; New-Item -ItemType Directory -Force (Split-Path $tf) | Out-Null
        [System.IO.File]::WriteAllText($tf, $card, $utf8)
        if ($f) { foreach ($r in @(@($f.Read) + @($f.Sources) | Where-Object { $_ } | Select-Object -Unique)) { if (-not $copied.ContainsKey($r)) { $copied[$r] = Copy-PackFile $r $dir } } }
        # v3.53.6 (item 1): Task nascida da divisão de um plano grande — o plano de origem (**Base:**) vai junto, em files/.
        if ($f) { $bm = [regex]::Match($f.Body, '\*\*Base:\*\*\s*`([^`]+)`'); if ($bm.Success -and -not $copied.ContainsKey($bm.Groups[1].Value)) { $copied[$bm.Groups[1].Value] = Copy-PackFile $bm.Groups[1].Value $dir } }
        $scnIds += @($t.Scenarios) + @($t.TestScenarios)
    }
    $ctx = Join-Path $dir 'context'; New-Item -ItemType Directory -Force $ctx | Out-Null
    Copy-Item -LiteralPath (Join-Path $plug 'roles/architect/templates/implementation-plan.md') -Destination (Join-Path $ctx 'implementation-plan.md') -Force
    $ac = Join-Path $Root '.team-project/architect/context.md'; if (Test-Path -LiteralPath $ac) { Copy-Item -LiteralPath $ac -Destination (Join-Path $ctx 'architect-context.md') -Force }
    Write-PackEnv $ctx   # v3.57.7: medido pelo run ao montar o pacote (antes: a §3 do plano mais recente, recopiada)
    $scnDir = Join-Path $Root '.team-project/quality-assurance/scenarios'
    foreach ($sf in @(Get-ChildItem -Path $scnDir -Filter '*.scn' -File -ErrorAction SilentlyContinue)) {
        $scnText = Read-Text $sf.FullName
        if ($sf.BaseName -eq $Story -or @($scnIds | Where-Object { $scnText -match ('(?m)^\s*scenario\s+' + [regex]::Escape($_) + '\b') }).Count) { New-Item -ItemType Directory -Force (Join-Path $ctx 'scenarios') | Out-Null; Copy-Item -LiteralPath $sf.FullName -Destination (Join-Path $ctx "scenarios/$($sf.Name)") -Force }
    }
    foreach ($sf in @(Get-ChildItem -Path (Join-Path $S 'stories') -Filter "$Story*.md" -File -ErrorAction SilentlyContinue)) { New-Item -ItemType Directory -Force (Join-Path $ctx 'stories') | Out-Null; Copy-Item -LiteralPath $sf.FullName -Destination (Join-Path $ctx "stories/$($sf.Name)") -Force }
    # review/: o plano reprovado e a tabela do plan.ps1 (correção) · o plano atual, o relatório e o diagnóstico (GAP).
    $rvSrc = Join-Path $pk 'review'; $rv = Join-Path $dir 'review'
    foreach ($t in $order) {
        $pairs = @()
        if ($Kind -eq 'gap') {
            $rej = Join-Path $rvSrc "$($t.Id)-plan.md"
            $cur = Get-PlanFull $t $S
            $pairs += ,@($(if ($Round -gt 1 -and (Test-Path -LiteralPath $rej)) { $rej } else { $cur }), "$($t.Id)-plan.md")
            if ($Round -gt 1) { $pairs += ,@((Join-Path $rvSrc "$($t.Id)-check.txt"), "$($t.Id)-check.txt") }
            $pairs += ,@((Join-Path $S "delivery/$($t.Id).md"), "$($t.Id)-delivery.md")
            $pairs += ,@((Join-Path $Root ".team-project/operator/$n/$($t.Id)-alvo/diagnostico.md"), "$($t.Id)-diagnostico.md")
        } elseif ($Round -gt 1) {
            $pairs += ,@((Join-Path $rvSrc "$($t.Id)-plan.md"), "$($t.Id)-plan.md")
            $pairs += ,@((Join-Path $rvSrc "$($t.Id)-check.txt"), "$($t.Id)-check.txt")
        }
        foreach ($pr in $pairs) { if ($pr[0] -and (Test-Path -LiteralPath $pr[0] -PathType Leaf)) { New-Item -ItemType Directory -Force $rv | Out-Null; Copy-Item -LiteralPath $pr[0] -Destination (Join-Path $rv $pr[1]) -Force } }
    }
    # INSTRUCTIONS.md pelo modelo do Arquiteto.
    $title = if ($Kind -eq 'gap') { "decisão do 🔺 GAP da $($ids[0]) · sprint $n" + $(if ($Round -gt 1) { " · correção $($Round - 1)" } else { '' }) } else { "História $Story · sprint $n" + $(if ($Round -gt 1) { " · correção $($Round - 1)" } else { '' }) }
    $files = ($order | ForEach-Object { "- ``$($_.Id)-plan.md`` — $($_.Title)" }) -join "`n"
    $rows = @('| Ordem | Task | Título | Depende de | Cenários |', '|---|---|---|---|---|')
    $k = 0; foreach ($t in $order) { $k++; $sc = @(@($t.Scenarios) + @($t.TestScenarios | ForEach-Object { "$_ (teste)" })); $rows += "| $k | $($t.Id) | $($t.Title -replace '\|', '/') | $(if ($t.Deps.Count) { $t.Deps -join ', ' } else { '—' }) | $(if ($sc.Count) { $sc -join ', ' } else { 'nenhum' }) |" }
    $roundTxt = ''
    if ($Kind -eq 'gap') {
        $roundTxt = "## Decisão de 🔺 GAP`n`nO desenvolvedor parou a $($ids[0]) com a dúvida de desenho abaixo. Em ``review/`` estão o plano $(if ($Round -gt 1) { 'que voltou reprovado' } else { 'atual' }) (``$($ids[0])-plan.md``), o relatório do dev (``$($ids[0])-delivery.md``)$(if ($Round -gt 1) { ', a tabela do ``plan.ps1`` (``' + $ids[0] + '-check.txt``)' }) e, se houver, o diagnóstico do alvo (``$($ids[0])-diagnostico.md``). Decida e **registre a decisão no próprio plano**: no passo afetado e numa linha ``**Decisão do GAP ($(Get-Date -Format 'dd/MM/yyyy')):** …`` no cabeçalho; se ela muda arquivos, atualize ``**Arquivos tocados:**``. Devolva o plano inteiro, com o mesmo nome. Não reescreva o que não muda.`n`n> $(if ($GapLine) { $GapLine } else { '(o GAP está no fim do relatório do dev)' })`n"
    } elseif ($Round -gt 1) {
        $roundTxt = "## Correção (rodada $Round)`n`nOs planos abaixo voltaram reprovados pela conferência. Em ``review/`` estão o plano devolvido (``<T-ID>-plan.md``) e a tabela do ``plan.ps1`` (``<T-ID>-check.txt``): corrija só as linhas ``falhou`` e devolva o plano inteiro, com o mesmo nome.`n"
    }
    $tpl = Read-Text (Join-Path $plug 'roles/architect/templates/external-plan.md')
    $ins = $tpl.Replace('{{TITLE}}', $title).Replace('{{SPRINT}}', $n).Replace('{{RETURN_FILES}}', $files).Replace('{{RETURN_ZIP}}', "$name-return.zip").Replace('{{ROUND}}', $roundTxt).Replace('{{TASKS}}', ($rows -join "`n"))
    [System.IO.File]::WriteAllText((Join-Path $dir 'INSTRUCTIONS.md'), $ins, $utf8)
    $zip = Join-Path $outDir "$name.zip"; New-ZipFromDir $dir $zip
    return [pscustomobject]@{ Name = $name; Tasks = @($order | ForEach-Object { $_.Id }); Round = $Round; Kb = [Math]::Round((Get-Item -LiteralPath $zip).Length / 1024) }
}

# Pacote da História no preparo: gera na primeira vez, gera a correção quando o retorno voltou reprovado, senão espera.
# Devolve { New; Name; Tasks; Round; Kb } (New = $false: o pacote já está fora, nada mudou).
function Update-StoryPack([string]$Story, $Items) {
    $st = Get-PackState; $pend = @($Items | ForEach-Object { $_.Id })
    $p = if ($st.packs.ContainsKey($Story)) { $st.packs[$Story] } else { $null }
    $rej = if ($p) { @($p.rejected | Where-Object { $pend -contains $_ }) } else { @() }
    $zipOk = [bool]($p -and $p.name -and (Test-Path -LiteralPath (Join-Path (Get-PackDir) "out/$($p.name).zip")))
    $covered = [bool]($p -and -not @($pend | Where-Object { @($p.tasks) -notcontains $_ }).Count)
    if ($zipOk -and $covered -and -not $rej.Count) { return [pscustomobject]@{ New = $false; Name = $p.name; Tasks = $pend; Round = $p.round; Kb = 0 } }
    $round = if ($p) { $p.round + 1 } else { 1 }
    $sel = if ($covered -and $rej.Count) { @($Items | Where-Object { $rej -contains $_.Id }) } else { @($Items) }
    $pack = New-PlanPack $Story $sel $round 'story'
    $st.packs[$Story] = @{ name = $pack.Name; round = $round; tasks = $pend; rejected = @(); at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
    Save-PackState $st
    Add-RunLog $S $n ($pack.Tasks -join ', ') "external plan: pacote $($pack.Name) gerado ($(if ($round -gt 1) { "correção $($round - 1)" } else { 'primeiro' })) — com o stakeholder" 'guards.json → run.planner external: o plano sai do Claude; o plan.ps1 confere na volta' "sprints/$n/pack/out/$($pack.Name).zip"
    $pack | Add-Member -NotePropertyName New -NotePropertyValue $true
    return $pack
}

# Pacote da decisão do 🔺 GAP (run.ps1 done -Result gap, e a correção dele no next).
function Start-GapPack($T, [string]$GapLine) {
    $st = Get-PackState
    $g = if ($st.gaps.ContainsKey($T.Id)) { $st.gaps[$T.Id] } else { $null }
    $round = if ($g -and $g.fix) { $g.round + 1 } else { 1 }
    if (-not $GapLine -and $g) { $GapLine = $g.gap }
    $pack = New-PlanPack $T.Story @($T) $round 'gap' $GapLine
    $st.gaps[$T.Id] = @{ name = $pack.Name; round = $round; gap = $GapLine; fix = $false; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
    Save-PackState $st
    return $pack
}

# O que está fora esperando o stakeholder: uma linha por pacote (História com Task sem plano, GAP sem decisão).
function Get-ExternalPending {
    $st = Get-PackState; $list = @()
    foreach ($k in @($st.packs.Keys | Sort-Object)) {
        $p = $st.packs[$k]
        $open = @($p.tasks | Where-Object { $id = $_; $t = @($tasks | Where-Object { $_.Id -eq $id }) | Select-Object -First 1; $t -and -not (Get-PlanFull $t $S) })
        if ($open.Count) { $list += [pscustomobject]@{ Label = "planos da História $k ($($open -join ', '))"; Name = $p.name } }
    }
    foreach ($k in @($st.gaps.Keys | Sort-Object)) { $list += [pscustomobject]@{ Label = "decisão do 🔺 GAP da $k"; Name = $st.gaps[$k].name } }
    return $list
}
# Nada a fazer pelo time até o retorno: diz ao stakeholder onde pegar e onde devolver, grava a marca que libera a G20.
function Write-ExternalWait {
    $pend = @(Get-ExternalPending)
    Out "PRÓXIMA AÇÃO: external plan — com o stakeholder; o time não tem o que fazer até o retorno"
    foreach ($p in $pend) {
        Out "  • $($p.Label): pegue .team-project/sprints/$n/pack/out/$($p.Name).zip (chat na web) ou a pasta .team-project/sprints/$n/pack/out/$($p.Name)/ (app do Codex) e peça `"siga o INSTRUCTIONS.md`"; devolva o $($p.Name)-return.zip (ou os <T-ID>-plan.md soltos) em .team-project/sprints/$n/pack/in/"
    }
    Out "  depois: /sm sprint run — o run.ps1 next lê pack/in/, confere cada plano (plan.ps1) e segue"
    Out "  sessão: encerre o turno e passe estas linhas ao stakeholder, sem formulário (não é decisão; a marca .team-project/.external-plan libera a G20)"
    $o = [ordered]@{ sprint = $n; pendente = @($pend | ForEach-Object { $_.Name }); desde = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
    [System.IO.File]::WriteAllText((Join-Path $Root '.team-project/.external-plan'), ($o | ConvertTo-Json -Compress), $utf8)
    exit 3
}

# Lê pack/in/: zip ou .md soltos com o nome <T-ID>-plan.md. Cada plano passa pelo plan.ps1 antes de entrar em plan/;
# reprovado vai a pack/review/ e a Task volta num pacote de correção. O arquivo lido vai a pack/done/. Devolve as linhas.
function Import-PlanReturns($Planner) {
    $pk = Get-PackDir; $in = Join-Path $pk 'in'; $out = @()
    if (-not (Test-Path -LiteralPath $in)) { return $out }
    $files = @(Get-ChildItem -LiteralPath $in -File | Sort-Object LastWriteTime)
    if (-not $files.Count) { return $out }
    $st = Get-PackState
    $re = '^(' + $script:TaskIdRe + ')-(?i:plan)(?:\s*\(\d+\))?\.(?i:md)$'
    $doneDir = Join-Path $pk 'done'; New-Item -ItemType Directory -Force $doneDir | Out-Null
    foreach ($f in $files) {
        $items = @(); $ignored = @()
        if ($f.Extension -ieq '.zip') {
            try {
                $za = [System.IO.Compression.ZipFile]::OpenRead($f.FullName)
                try {
                    foreach ($en in $za.Entries) {
                        if (-not $en.Name -or $en.FullName -match '(^|/)__MACOSX/') { continue }
                        if ([regex]::IsMatch($en.Name, $re)) { $sr = New-Object System.IO.StreamReader($en.Open(), $utf8, $true); try { $items += @{ Name = $en.Name; Text = $sr.ReadToEnd() } } finally { $sr.Dispose() } }
                        else { $ignored += $en.FullName }
                    }
                } finally { $za.Dispose() }
            } catch { $out += "  external plan: $($f.Name) não abriu como zip ($($_.Exception.Message)) — foi para pack/done/ sem efeito" }
        } elseif ([regex]::IsMatch($f.Name, $re)) { $items += @{ Name = $f.Name; Text = (Read-Text $f.FullName) } }
        else { $ignored += $f.Name }
        foreach ($it in $items) { $out += Import-OnePlan $it $st $Planner $re }
        if ($ignored.Count) { $out += "  external plan: ignorado em $($f.Name) (não é <T-ID>-plan.md; nada entra no projeto): $((@($ignored) | Select-Object -First 5) -join ', ')$(if ($ignored.Count -gt 5) { " e mais $($ignored.Count - 5)" })" }
        Move-Item -LiteralPath $f.FullName -Destination (Join-Path $doneDir "$(Get-Date -Format 'yyyyMMdd-HHmmss')-$($f.Name)") -Force
    }
    Save-PackState $st
    return $out
}
function Import-OnePlan($It, $St, $Planner, [string]$Re) {
    $id = [regex]::Match($It.Name, $Re).Groups[1].Value
    $T = @($tasks | Where-Object { $_.Id -eq $id }) | Select-Object -First 1
    if (-not $T) { return "  external plan: $($It.Name) recusado — a $id não está no quadro do sprint $n" }
    $text = ([string]$It.Text).TrimStart([char]0xFEFF)
    if (-not $text.Trim()) { return "  external plan: $($It.Name) recusado — arquivo vazio" }
    $isGap = $St.gaps.ContainsKey($id)
    $inPack = @($St.packs.Values | Where-Object { @($_.tasks) -contains $id }).Count -gt 0
    $cur = Get-PlanFull $T $S
    if ($cur -and -not $isGap) { return "  external plan: $($It.Name) recusado — a $id já tem plano ($($T.Plan)); plano de Task já planejada só muda pela decisão de um 🔺 GAP" }
    if (-not $isGap -and -not $inPack -and -not (Test-ExternalTask $Planner $id)) { return "  external plan: $($It.Name) recusado — a $id não está no plano externo (guards.json → run)" }
    $destRel = if ($cur) { $T.Plan } else { Get-PlanDest $T }
    $dest = Join-Path $S $destRel
    $before = if ($cur) { Read-Text $cur } else { $null }
    New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
    [System.IO.File]::WriteAllText($dest, $text, $utf8)
    $r = Invoke-Child 'plan.ps1' @('-Plan', $dest, '-Root', $Root)
    $rv = Join-Path (Get-PackDir) 'review'; New-Item -ItemType Directory -Force $rv | Out-Null
    if ($r.Code -eq 0) {
        Remove-Item -LiteralPath (Join-Path $rv "$id-plan.md"), (Join-Path $rv "$id-check.txt") -Force -ErrorAction SilentlyContinue
        if ($isGap) {
            $St.gaps.Remove($id)
            Add-RunLog $S $n $id 'external plan: decisão do 🔺 GAP gravada no plano (plan.ps1 ok) → dev em instância nova' 'o GAP da Task foi decidido fora do Claude (guards.json → run.planner external)' "sprints/$n/$destRel"
            return "  external plan: $id — decisão do 🔺 GAP aceita (plan.ps1 ok) em sprints/$n/$destRel; a Task volta à construção (dev em instância nova)"
        }
        if (-not (Set-BoardPlan $id $destRel)) { return "  external plan: $id aceito (plan.ps1 ok) em sprints/$n/$destRel, mas a linha dela no quadro não tem coluna Plano — a sessão grava o link à mão" }
        if ($St.packs.ContainsKey($T.Story)) { $St.packs[$T.Story].rejected = @($St.packs[$T.Story].rejected | Where-Object { $_ -ne $id }) }
        Add-RunLog $S $n $id 'external plan aceito (plan.ps1 ok)' 'plano escrito fora do Claude pelo pacote (guards.json → run.planner external)' "sprints/$n/$destRel"
        return "  external plan: $id aceito (plan.ps1 ok) → sprints/$n/$destRel"
    }
    [System.IO.File]::WriteAllText((Join-Path $rv "$id-plan.md"), $text, $utf8)
    [System.IO.File]::WriteAllText((Join-Path $rv "$id-check.txt"), $r.Out, $utf8)
    if ($null -ne $before) { [System.IO.File]::WriteAllText($dest, $before, $utf8) } else { Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue }
    $bad = @($r.Out -split "`r?`n" | Where-Object { $_ -match '^\|\s*([^|]+?)\s*\|\s*falhou\s*\|' } | ForEach-Object { [regex]::Match($_, '^\|\s*([^|]+?)\s*\|').Groups[1].Value })
    $why = if ($bad.Count) { $bad -join ', ' } elseif ($r.Code -eq 2) { 'erro de uso do plan.ps1' } else { 'plan.ps1 reprovou' }
    # v3.53.6 (sprint 5 do garden, item 1): reprovado por tamanho (acima de 30 KB), o plano não volta num pacote de correção —
    # a correção pediria corte. A cópia em pack/review/ fica como base e o run.ps1 next leva a Task à divisão.
    if (-not $isGap -and $bad -contains 'tamanho') {
        if ($St.packs.ContainsKey($T.Story)) { $St.packs[$T.Story].rejected = @($St.packs[$T.Story].rejected | Where-Object { $_ -ne $id }) }
        $kb = Get-PlanKb $text
        Add-RunLog $S $n $id "external plan de $kb KB (teto $($script:PlanMaxKb)) → divisão da Task, sem pacote de correção" 'regra 22: plano grande não se corta; os blocos dele são a base da divisão' "sprints/$n/pack/review/$id-plan.md"
        return "  external plan: $id reprovado por tamanho ($kb KB, teto $($script:PlanMaxKb) KB) — não volta em pacote de correção: a Task se divide (run.ps1 next), com este plano como base (pack/review/$id-plan.md)"
    }
    if ($isGap) { $St.gaps[$id].fix = $true }
    else {
        if (-not $St.packs.ContainsKey($T.Story)) { $St.packs[$T.Story] = @{ name = ''; round = 1; tasks = @($id); rejected = @(); at = '' } }
        $St.packs[$T.Story].rejected = @(@($St.packs[$T.Story].rejected) + $id | Select-Object -Unique)
    }
    Add-RunLog $S $n $id "external plan reprovado pelo plan.ps1 ($why) → pacote de correção" 'o plano de fora só entra no quadro depois da conferência' "sprints/$n/pack/review/$id-check.txt"
    return "  external plan: $id reprovado pelo plan.ps1 ($why) — volta num pacote de correção, com a tabela"
}
