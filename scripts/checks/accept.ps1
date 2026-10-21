# Executor de cenários de aceite (v3.51, F1): roda cenários escritos numa linguagem comum (um passo por linha) contra o
# app RODANDO no alvo real — emulador ou aparelho (android) ou site no navegador headless (web). Prova funcional do
# portão do QA (A4) e o que o dev roda para fechar a Task (A3). API e Windows desktop entram no próximo incremento.
# Uso (raiz do projeto): powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/accept.ps1" -Task T-041
#   [-Target android|web] [-Scenarios <arquivos ou máscaras .scn>] [-Only SC-001,SC-007] [-Apk <apk>] [-NoRetry] [-NoRepair] [-ParseOnly]
# Padrão de -Scenarios: .team-project/quality-assurance/scenarios/*.scn · -Target: o único alvo de guards.json → targets.
# Saída: uma linha por cenário; .team-project/accept/<sprint|B-nnn>/<ID>/result.md e result.json; capturas do estado
# final (e da falha) de cada cenário em shots/ — a prova anexada ao veredito.
# Exit 0 = todos passaram · 1 = algum falhou (o app) · 2 = erro de uso ou cenário malformado · 4 = FALHA DE AMBIENTE
# (alvo fora do ar, tela em branco, outro automatizador): não é defeito do app; o reparo já foi tentado uma vez.
#
# Linguagem (uma instrução por linha; '#' comenta; texto com espaço vai depois do '='):
#   scenario <ID> <título>             começa um cenário          reset                  apaga os dados do app (web: sessão nova)
#   launch | open [/caminho]           abre o app ou a página      restart | back         reabre | volta
#   clock <aaaa-mm-dd hh:mm>           fixa o relógio              wait <segundos>        espera
#   tap <id>                           toca ou clica               type <id> = <texto>    digita
#   slider <id> <valor> <min> <max>    posiciona o deslizante      font-scale <fator>     escala da fonte
#   assert-text <id> = <texto>         texto igual                 assert-contains <id> = <trecho>
#   assert-exists <id> | assert-absent <id>                        assert-checked <id> = true|false
#   assert-count <prefixo> = <n>       itens da lista inteira      assert-order <prefixo> = a,b,c
#   shot <nome>                        captura extra
# <id> = o identificador de teste do contrato: testTag (Android), data-testid (web).

param(
    [string]$Task = 'avulso',
    [ValidateSet('', 'android', 'web')][string]$Target = '',
    [string[]]$Scenarios = @(),
    [string]$Only = '',
    [string]$Apk = '',
    [switch]$NoRetry,
    [switch]$NoRepair,
    [switch]$ParseOnly,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)
$verbs = 'reset', 'launch', 'open', 'restart', 'back', 'clock', 'wait', 'tap', 'type', 'slider', 'font-scale', 'shot',
         'assert-text', 'assert-contains', 'assert-exists', 'assert-absent', 'assert-checked', 'assert-count', 'assert-order'

# Lê os cenários dos arquivos; erro de sintaxe vem com arquivo:linha.
function Read-Scenarios([string[]]$Files) {
    $blocks = @(); $errors = @()
    foreach ($f in $Files) {
        $n = 0
        foreach ($raw in [System.IO.File]::ReadAllLines($f, $utf8)) {
            $n++; $l = $raw.Trim(); if (-not $l -or $l.StartsWith('#')) { continue }
            if ($l -match '^scenario\s+(\S+)\s*(.*)$') { $blocks += , @{ id = $Matches[1]; title = $Matches[2]; steps = @(); file = $f }; continue }
            if (-not $blocks.Count) { $errors += "${f}:$n passo antes do primeiro 'scenario'"; continue }
            $verb = ($l -split '\s+', 2)[0]
            if ($verbs -notcontains $verb) { $errors += "${f}:$n passo desconhecido '$verb'" }
            elseif ($verb -match '^(type|assert-text|assert-contains|assert-count|assert-order|assert-checked)$' -and $l -notmatch '=') { $errors += "${f}:$n '$verb' pede '<id> = <valor>'" }
            $blocks[-1].steps += $l
        }
    }
    foreach ($d in @($blocks | Group-Object { $_.id } | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Name })) { $errors += "cenário $d definido mais de uma vez" }
    foreach ($b in $blocks) { if (-not $b.steps.Count) { $errors += "cenário $($b.id) sem passos" } }
    return @{ Blocks = $blocks; Errors = $errors }
}

# Um cenário, do zero, no alvo. Devolve status/detalhe/captura, ou environment quando o alvo quebrou.
function Invoke-Once($Block) {
    if ($script:Tgt -eq 'web') {
        $o = Invoke-WebScenarios @($Block) $script:Shots
        if ($o.environment) { return @{ environment = [string]$o.environment } }
        $r = @($o.results)[0]; return @{ status = [string]$r.status; detail = [string]$r.detail; shot = [string]$r.shot }
    }
    $base = Join-Path $script:Shots $Block.id; $status = 'PASSOU'; $detail = ''
    foreach ($s in $Block.steps) {
        $verb, $rest = ($s -split '\s+', 2); if ($null -eq $rest) { $rest = '' }
        try { Invoke-AndroidStep $verb $rest $base | Out-Null }
        catch {
            $m = $_.Exception.Message
            if ($m -like 'AMBIENTE:*') { return @{ environment = $m.Substring(9).Trim() } }
            $status = 'FALHOU'; $detail = "passo '$s': $m"; break
        }
    }
    $shot = "$base-$(if ($status -eq 'PASSOU') { 'final' } else { 'falha' }).png"; Save-AndroidShot $shot
    return @{ status = $status; detail = $detail; shot = $shot }
}

# Corpo com a trava já tomada. Devolve o código de saída.
function Invoke-Accept($Blocks, $Cfg, $Health, $Repair) {
    # Pré-voo; com falha, o reparo é tentado UMA vez (D4) antes de desistir.
    $h = & $Health
    if ($h -and -not $NoRepair) { [Console]::Out.WriteLine("accept: pré-voo falhou ($h) — tentando o reparo uma vez"); $h = & $Repair }
    if ($h) { [Console]::Out.WriteLine("accept: FALHA DE AMBIENTE ($script:Tgt) — $h. Não é defeito do app: reinicie o alvo e rode de novo."); return 4 }
    $appApk = if ($Apk) { $Apk } elseif ($Cfg -and $Cfg.apk) { Join-Path $Root ([string]$Cfg.apk) } else { '' }
    if ($script:Tgt -eq 'android' -and $appApk) { $ie = Install-AndroidApk $appApk; if ($ie) { [Console]::Out.WriteLine("accept: $ie"); return 2 } }

    $dir = (Get-VerifyDir $Root $Task) -replace '[\\/]verify[\\/]', '/accept/'
    $script:Shots = Join-Path $dir 'shots'; New-Item -ItemType Directory -Force $script:Shots | Out-Null
    $results = @(); $envFail = $null
    foreach ($b in $Blocks) {
        $r1 = Invoke-Once $b
        if ($r1.environment) { $envFail = $r1.environment; break }
        $final = $r1; $note = ''
        # Repete uma vez do zero (o alvo oscila); o relatório guarda as duas tentativas.
        if ($r1.status -ne 'PASSOU' -and -not $NoRetry) {
            $r2 = Invoke-Once $b
            if ($r2.environment) { $envFail = $r2.environment; break }
            $final = $r2; $note = if ($r2.status -eq 'PASSOU') { "passou na 2ª tentativa; 1ª: $($r1.detail)" } else { 'falhou nas 2 tentativas' }
        }
        $shotRel = if ($final.shot) { ([string]$final.shot).Replace($Root, '').TrimStart('\', '/') -replace '\\', '/' } else { '' }
        $row = [ordered]@{ id = $b.id; title = $b.title; status = $final.status; detail = $final.detail; note = $note; shot = $shotRel }
        $results += $row
        [Console]::Out.WriteLine(("[{0}] {1}  {2}{3}{4}" -f $b.id, $row.status, $b.title, $(if ($row.detail) { "  -> $($row.detail)" } else { '' }), $(if ($note) { "  ($note)" } else { '' })))
    }
    if ($script:Tgt -eq 'web') { Stop-WebServer }

    $ok = @($results | Where-Object { $_.status -eq 'PASSOU' }).Count
    $md = "# Aceite $Task · alvo $script:Tgt · $(Get-Date -Format 'yyyy-MM-dd HH:mm')`n`n$ok de $($results.Count) cenário(s) passaram" + $(if ($envFail) { "; **interrompido por falha de ambiente:** $envFail" } else { '' }) + ".`n`n| Cenário | Resultado | Detalhe | Prova (captura) |`n|---|---|---|---|`n"
    foreach ($r in $results) { $md += "| $($r.id) $($r.title) | $($r.status) | $((@($r.detail, $r.note) | Where-Object { $_ }) -join ' · ' -replace '\|', '/') | $($r.shot) |`n" }
    [System.IO.File]::WriteAllText((Join-Path $dir 'result.md'), $md, $utf8)
    [System.IO.File]::WriteAllText((Join-Path $dir 'result.json'), ([ordered]@{ task = $Task; target = $script:Tgt; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); tree = (Get-WorkTree $Root); environment = $envFail; passed = $ok; total = $results.Count; results = $results } | ConvertTo-Json -Depth 6), $utf8)
    $rel = ($dir.Substring($Root.Length + 1) -replace '\\', '/')
    if ($envFail) { [Console]::Out.WriteLine("accept $Task · FALHA DE AMBIENTE ($script:Tgt): $envFail · $ok de $($results.Count) antes da interrupção · $rel/result.md"); return 4 }
    [Console]::Out.WriteLine("accept $Task · alvo $script:Tgt · $ok de $($results.Count) cenário(s) passaram · $rel/result.md")
    if ($ok -lt $results.Count) { return 1 }
    return 0
}

$code = 2
try {
    # ---------- cenários ----------
    $pats = if ($Scenarios.Count) { @($Scenarios | ForEach-Object { [string]$_ -split ',' } | Where-Object { $_ }) } else { @('.team-project/quality-assurance/scenarios/*.scn') }
    $files = @($pats | ForEach-Object { $pp = if ([System.IO.Path]::IsPathRooted($_)) { $_ } else { Join-Path $Root $_ }; Get-ChildItem -Path $pp -File -ErrorAction SilentlyContinue } | Sort-Object FullName -Unique | ForEach-Object { $_.FullName })
    if (-not $files.Count) { [Console]::Error.WriteLine("accept: nenhum arquivo de cenário em $($pats -join ', ')"); exit 2 }
    $parsed = Read-Scenarios $files
    $onlyList = @($Only -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
    $blocks = @($parsed.Blocks | Where-Object { -not $onlyList.Count -or $onlyList -contains $_.id })
    foreach ($o in $onlyList) { if (-not ($parsed.Blocks | Where-Object { $_.id -eq $o })) { $parsed.Errors += "cenário $o pedido em -Only não existe" } }
    if ($parsed.Errors.Count) { [Console]::Out.WriteLine("accept: $($parsed.Errors.Count) erro(s) nos cenários"); foreach ($e in $parsed.Errors) { [Console]::Out.WriteLine("  $e") }; exit 2 }
    if ($ParseOnly) { [Console]::Out.WriteLine("accept: $($blocks.Count) cenário(s) válidos em $($files.Count) arquivo(s): $(($blocks | ForEach-Object { $_.id }) -join ', ')"); exit 0 }

    # ---------- alvo ----------
    $targets = Get-TargetsConfig $Root
    if (-not $Target) {
        $names = @(if ($targets) { $targets.PSObject.Properties | ForEach-Object { $_.Name } | Where-Object { $_ -in 'android', 'web' } })
        if ($names.Count -ne 1) { [Console]::Error.WriteLine('accept: diga o alvo (-Target android|web) ou configure um só em guards.json → targets'); exit 2 }
        $Target = [string]$names[0]
    }
    $script:Tgt = $Target
    $cfg = if ($targets -and $targets.PSObject.Properties[$Target]) { $targets.$Target } else { $null }
    if ($Target -eq 'android') { . (Join-Path $PSScriptRoot 'targets/android.ps1'); $init = Initialize-Android $cfg; $health = { Test-AndroidHealth }; $repair = { Repair-Android } }
    else { . (Join-Path $PSScriptRoot 'targets/web.ps1'); $init = Initialize-Web $cfg $Root; $health = { Test-WebHealth }; $repair = { Repair-Web } }
    if ($init) { [Console]::Out.WriteLine("accept: FALHA DE AMBIENTE ($Target) — $init"); exit 4 }

    $lock = Enter-TargetLock $Root $Target "accept $Task"
    if ($lock) { [Console]::Out.WriteLine("accept: FALHA DE AMBIENTE — $lock"); exit 4 }
    try { $code = Invoke-Accept $blocks $cfg $health $repair | Select-Object -Last 1 } finally { Exit-TargetLock $Root }
} catch {
    [Console]::Error.WriteLine("accept: erro — $($_.Exception.Message)")
    exit 2
}
exit $code
