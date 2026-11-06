# Executor de cenários de aceite (v3.51, F1): roda cenários escritos numa linguagem comum (um passo por linha) contra o
# app RODANDO no alvo real — emulador ou aparelho (android) ou site no navegador headless (web). Prova funcional do
# portão do QA (A4) e o que o dev roda para fechar a Task (A3). API e Windows desktop entram no próximo incremento.
# Uso (raiz do projeto): powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/accept.ps1" -Task T-041
#   [-Target android|web] [-Scenarios <arquivos ou máscaras .scn>] [-Only SC-001,SC-007] [-Apk <apk>] [-NoRetry] [-NoRepair] [-ParseOnly]
# Padrão de -Scenarios: .team-project/quality-assurance/scenarios/*.scn · -Target: o único alvo de guards.json → targets.
# Saída: uma linha por cenário; .team-project/accept/<sprint|B-nnn>/<ID>/result.md e result.json; capturas do estado
# final (e da falha) de cada cenário em shots/ — a prova anexada ao veredito.
# Exit 0 = todos passaram · 1 = algum falhou (o app) · 2 = erro de uso ou cenário malformado (v3.53.1: também o cenário
# sem nenhum assert-*, que só provaria que o app abriu) · 4 = FALHA DE AMBIENTE
# (alvo fora do ar, tela em branco, outro automatizador): não é defeito do app; o reparo já foi tentado uma vez.
# v3.53.6 (sprint 5 do garden): android — APK mais velho que o código do módulo sai com exit 2 antes de instalar
# ("reconstrua (assembleDebug) antes do accept"); com targets.android.repair (emulador em container), o PRIMEIRO accept
# de cada Task reinicia o emulador pelo repair (marca fresh-start.json na pasta do accept; freshStart: false ou -NoRepair
# desligam); a memória do emulador acima de targets.android.maxMemoryMB (medida por memoryCmd) reprova o pré-voo.
# v3.54.2 (carta do sprint 5 do garden, item 3): targets.android.baseline (nome de uma massa de seeds) põe o app na tela de
# partida depois de instalar e de cada reset; os 2 primeiros cenários falhando na MESMA tela, sem nenhum passar, param o
# accept (exit 4, startState no result.json — o done -Result env não repara nem reabre: vai ao stakeholder); progress.json
# a cada cenário (o run.ps1 next mostra quantos passaram e SEM AVANÇO).
#
# Linguagem (uma instrução por linha; '#' comenta; texto com espaço vai depois do '='):
#   scenario <ID> <título>             começa um cenário          reset                  apaga os dados do app (web: sessão nova)
#   launch | open [/caminho]           abre o app ou a página      restart | back         reabre | volta
#   (android, v3.53.3: launch/open/restart fecham e abrem o app do zero, na tela inicial — os dados ficam; o app que não
#    fica na frente em 3 aberturas é FALHA DE AMBIENTE, exit 4; a falha de passo traz [tela · ids · textos] visíveis)
#   clock <aaaa-mm-dd hh:mm>           fixa o relógio              wait <segundos>        espera
#   tap <id>                           toca ou clica               type <id> = <texto>    digita
#   select <id> = <opção>              escolhe a opção (pelo texto visível) num combo, lista suspensa ou seletor (v3.53.7)
#   seed <nome>                        carrega a massa de dados: o comando de guards.json → targets.<alvo>.seeds.<nome>
#                                      (v3.53.7; depois do reset, antes do launch; falhou = FALHA DE AMBIENTE, exit 4)
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
$verbs = 'reset', 'launch', 'open', 'restart', 'back', 'clock', 'wait', 'tap', 'type', 'select', 'seed', 'slider', 'font-scale', 'shot',
         'assert-text', 'assert-contains', 'assert-exists', 'assert-absent', 'assert-checked', 'assert-count', 'assert-order'

# Lê os cenários dos arquivos; erro de sintaxe vem com arquivo:linha.
# v3.56.0 (H1, sprint 5 do garden #32): cada erro leva o id do cenário (Sc; '' = erro do arquivo) — com -Only, só contam
# os erros dos cenários pedidos e os do arquivo; um cenário de outra Task sem assert não reprova mais esta.
function Read-Scenarios([string[]]$Files) {
    $blocks = @(); $errors = @()
    foreach ($f in $Files) {
        $n = 0; $first = $blocks.Count   # v3.56.0: o "antes do primeiro scenario" é por arquivo (não cai no último cenário do anterior)
        foreach ($raw in [System.IO.File]::ReadAllLines($f, $utf8)) {
            $n++; $l = $raw.Trim(); if (-not $l -or $l.StartsWith('#')) { continue }
            if ($l -match '^scenario\s+(\S+)\s*(.*)$') { $blocks += , @{ id = $Matches[1]; title = $Matches[2]; steps = @(); file = $f }; continue }
            if ($blocks.Count -eq $first) { $errors += , @{ Sc = ''; Msg = "${f}:$n passo antes do primeiro 'scenario'" }; continue }
            $verb = ($l -split '\s+', 2)[0]; $sid = [string]$blocks[-1].id
            if ($verbs -notcontains $verb) { $errors += , @{ Sc = $sid; Msg = "${f}:$n passo desconhecido '$verb'" } }
            elseif ($verb -match '^(type|select|assert-text|assert-contains|assert-count|assert-order|assert-checked)$' -and $l -notmatch '=') { $errors += , @{ Sc = $sid; Msg = "${f}:$n '$verb' pede '<id> = <valor>'" } }
            elseif ($verb -eq 'seed' -and $l -notmatch '^seed\s+\S+\s*$') { $errors += , @{ Sc = $sid; Msg = "${f}:$n 'seed' pede um nome só: seed <nome> (o comando fica em guards.json → targets.<alvo>.seeds)" } }
            $blocks[-1].steps += $l
        }
    }
    foreach ($d in @($blocks | Group-Object { $_.id } | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Name })) { $errors += , @{ Sc = [string]$d; Msg = "cenário $d definido mais de uma vez" } }
    foreach ($b in $blocks) { if (-not $b.steps.Count) { $errors += , @{ Sc = [string]$b.id; Msg = "cenário $($b.id) sem passos" } } }
    # v3.53.1 (plugin-report do sprint 4 do garden, item 1): cenário sem nenhum assert passa só por instalar e abrir o app — o
    # accept saiu "18 de 18" numa aplicação híbrida (WebView) opaca ao automatizador, sem provar critério nenhum.
    foreach ($b in @($blocks | Where-Object { $_.steps.Count -and -not @($_.steps | Where-Object { $_ -match '^assert-' }).Count })) {
        $errors += , @{ Sc = [string]$b.id; Msg = "cenário $($b.id) sem nenhum assert-* — não prova o critério, só que o app abriu; sem identificador de teste no alvo, o cenário não serve: 🔺 GAP ao Arquiteto (outro modo de prova)" }
    }
    return @{ Blocks = $blocks; Errors = $errors }
}

# v3.56.0 (H1): os erros que contam — sem -Only, todos; com -Only, os dos cenários pedidos e os do arquivo (Sc ''). Devolve
# Count (fora do -Only, só aviso) e as mensagens que reprovam.
function Select-ScenarioErrors($Errors, [string[]]$OnlyList) {
    $all = @($Errors | Where-Object { $_ })
    if (-not @($OnlyList).Count) { return @{ Msgs = @($all | ForEach-Object { [string]$_.Msg }); Outside = 0 } }
    $keep = @($all | Where-Object { -not $_.Sc -or $OnlyList -contains $_.Sc })
    return @{ Msgs = @($keep | ForEach-Object { [string]$_.Msg }); Outside = $all.Count - $keep.Count }
}

# v3.54.2 (carta do sprint 5 do garden, item 3): estado de partida do app. targets.android.baseline = o nome de uma massa
# de targets.android.seeds que deixa o app na tela que os cenários esperam (introdução dispensada, login, base mínima). O
# accept a aplica depois de instalar o APK e depois de cada "reset" (o pm clear devolve a introdução). Na T-063, o app
# reinstalado abriu na introdução e os 7 cenários falharam nela, ~7 min cada. $null = aplicada ou sem baseline.
function Invoke-AcceptBaseline {
    $c = $script:BaseCfg
    if ($script:Tgt -ne 'android' -or -not $c -or -not ($c.PSObject.Properties['baseline'] -and $c.baseline)) { return $null }
    $e = Invoke-TargetSeed $Root 'android' $c ([string]$c.baseline) @{ ACCEPT_SERIAL = $script:Serial; ACCEPT_PACKAGE = $script:Pkg }
    if ($e) { return "estado de partida (targets.android.baseline): $e" }
    return $null
}
# A tela em que o passo falhou, do "[tela: … · ids: … · textos: …]" do adaptador android ('' sem ela).
function Get-FailScreen([string]$Detail) {
    $m = [regex]::Match([string]$Detail, '\[tela: ([^\]]*?) · ids: [^\]]*? · textos: ([^\]]*)\]')
    if (-not $m.Success) { return '' }
    return "$($m.Groups[1].Value.Trim()) · textos: $($m.Groups[2].Value.Trim())"
}
# v3.54.2 (item 3): progresso a cada cenário (progress.json na pasta do accept) — o run.ps1 next e o /team-status leem
# quantos passaram, quantos falharam seguidos e onde o último parou; antes só havia "CPU e último arquivo", e cada captura
# de falha contava como sinal de vida.
function Write-AcceptProgress([string]$Dir, $Results, [int]$Total) {
    $rs = @($Results); $pass = @($rs | Where-Object { $_.status -eq 'PASSOU' }).Count
    $streak = 0; for ($i = $rs.Count - 1; $i -ge 0; $i--) { if ($rs[$i].status -eq 'PASSOU') { break }; $streak++ }
    $o = [ordered]@{ task = $Task; pid = $PID; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); total = $Total; passed = $pass; failed = $rs.Count - $pass; streak = $streak; last = $(if ($rs.Count) { $rs[-1] } else { $null }) }
    try { [System.IO.File]::WriteAllText((Join-Path $Dir 'progress.json'), ($o | ConvertTo-Json -Depth 4), $utf8) } catch { }
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
        try {
            Invoke-AndroidStep $verb $rest $base | Out-Null
            if ($verb -eq 'reset') { $be = Invoke-AcceptBaseline; if ($be) { return @{ environment = $be } } }   # v3.54.2
        }
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
    $dir = (Get-VerifyDir $Root $Task) -replace '[\\/]verify[\\/]', '/accept/'
    $fresh = $false; $script:BaseCfg = $Cfg
    if ($script:Tgt -eq 'android') {
        # v3.51.1: sem targets.android.package/apk, o executor descobre o APK construído e o applicationId dele.
        $appApk = Resolve-AndroidApk $Root $Apk
        # v3.53.6 (sprint 5 do garden, item 7): APK mais velho que o código do módulo não é instalado — rodaria o app de antes
        # da mudança ("tag não encontrada" para o id recém-criado). Nem ambiente nem defeito do app: exit 2, reconstruir.
        $st = Get-ApkStaleness $appApk
        if ($st.Stale) {
            $fr = ([string]$st.File).Replace($Root, '').TrimStart('\', '/') -replace '\\', '/'
            [Console]::Out.WriteLine("accept: APK mais velho que o código ($fr alterado em $($st.FileTime.ToString('yyyy-MM-dd HH:mm:ss')); APK de $($st.ApkTime.ToString('yyyy-MM-dd HH:mm:ss'))): reconstrua ($($st.Task)) antes do accept. Não é falha de ambiente nem defeito do app — o APK do disco não tem a mudança.")
            return 2
        }
        if ($st.Note) { [Console]::Out.WriteLine("accept: $($st.Note)") }
        $fresh = Test-AndroidFreshStartDue $Cfg $dir ([bool]$NoRepair)
    }
    if ($fresh) {
        # v3.53.6 (item 5, decisão do stakeholder): o primeiro accept de cada Task reinicia o emulador em container (repair).
        [Console]::Out.WriteLine("accept: primeiro accept da $Task — reiniciando o emulador pelo reparo declarado (targets.android.repair) para começar com memória limpa; as repetições desta Task reaproveitam o emulador (targets.android.freshStart: false desliga)")
        $fsw = [System.Diagnostics.Stopwatch]::StartNew()
        $h = & $Repair
        if (-not $h) { Set-AndroidFreshStartDone $dir $Task; [Console]::Out.WriteLine("accept: emulador reiniciado e pronto em $([int]$fsw.Elapsed.TotalSeconds) s") }
    } else {
        # Pré-voo; com falha, o reparo é tentado UMA vez (D4) antes de desistir.
        $h = & $Health
        if ($h -and -not $NoRepair) { [Console]::Out.WriteLine("accept: pré-voo falhou ($h) — tentando o reparo uma vez"); $h = & $Repair }
    }
    if ($h) { [Console]::Out.WriteLine("accept: FALHA DE AMBIENTE ($script:Tgt) — $h. Não é defeito do app: reinicie o alvo e rode de novo."); return 4 }
    if ($script:Tgt -eq 'android') {
        if (-not ($Cfg -and $Cfg.package)) { Set-AndroidPackage (Get-ApkPackage $appApk) }
        if (-not $script:Pkg) { [Console]::Out.WriteLine('accept: sem o pacote do app — nenhum APK em <projeto>/**/build/outputs/apk/ e nada em targets.android.package; construa o app (assembleDebug ou assembleRelease) antes'); return 2 }
        if ($appApk) { $ie = Install-AndroidApk $appApk; if ($ie) { [Console]::Out.WriteLine("accept: $ie"); return 2 }; [Console]::Out.WriteLine("accept: $($script:Pkg) instalado de $($appApk.Replace($Root, '').TrimStart('\', '/'))") }
        # v3.54.2: o estado de partida declarado, depois da instalação.
        $be = Invoke-AcceptBaseline
        if ($be) { [Console]::Out.WriteLine("accept: FALHA DE AMBIENTE ($script:Tgt) — $be. Não é defeito do app."); return 4 }
        if ($Cfg -and $Cfg.PSObject.Properties['baseline'] -and $Cfg.baseline) { [Console]::Out.WriteLine("accept: estado de partida aplicado (targets.android.baseline '$([string]$Cfg.baseline)')") }
    }

    $script:Shots = Join-Path $dir 'shots'; New-Item -ItemType Directory -Force $script:Shots | Out-Null
    $results = @(); $envFail = $null; $startState = $null
    Write-AcceptProgress $dir $results $Blocks.Count
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
        Write-AcceptProgress $dir $results $Blocks.Count
        # v3.54.2 (carta do sprint 5 do garden, item 3): os 2 primeiros cenários falharam na MESMA tela e nenhum passou — o app
        # não está no estado de partida que eles esperam (introdução, login, base vazia). Rodar o resto só gasta ~7 min por
        # cenário (T-063: 50 min, 7 cenários na introdução). Para aqui, com exit 4, e o run.ps1 done -Result env lê o
        # startState do result.json: sem reparo do emulador (não muda a tela) e sem reabertura automática — vai ao stakeholder.
        if ($results.Count -eq 2 -and -not @($results | Where-Object { $_.status -eq 'PASSOU' }).Count) {
            $sc1 = Get-FailScreen $results[0].detail
            if ($sc1 -and $sc1 -eq (Get-FailScreen $results[1].detail)) {
                $startState = $sc1
                $envFail = "ESTADO DE PARTIDA: os 2 primeiros cenários ($($results[0].id), $($results[1].id)) pararam na mesma tela — $sc1 — e nenhum chegou ao critério; $($Blocks.Count - 2) cenário(s) não rodaram. Não é defeito do código nem queda do emulador: o app não está na tela de partida dos cenários (declare targets.android.baseline ou ajuste o cenário). Captura: $($results[1].shot)"
                break
            }
        }
    }
    if ($script:Tgt -eq 'web') { Stop-WebServer }

    $ok = @($results | Where-Object { $_.status -eq 'PASSOU' }).Count
    $md = "# Aceite $Task · alvo $script:Tgt · $(Get-Date -Format 'yyyy-MM-dd HH:mm')`n`n$ok de $($results.Count) cenário(s) passaram" + $(if ($startState) { "; **interrompido no estado de partida:** $envFail" } elseif ($envFail) { "; **interrompido por falha de ambiente:** $envFail" } else { '' }) + ".`n`n| Cenário | Resultado | Detalhe | Prova (captura) |`n|---|---|---|---|`n"
    foreach ($r in $results) { $md += "| $($r.id) $($r.title) | $($r.status) | $((@($r.detail, $r.note) | Where-Object { $_ }) -join ' · ' -replace '\|', '/') | $($r.shot) |`n" }
    [System.IO.File]::WriteAllText((Join-Path $dir 'result.md'), $md, $utf8)
    [System.IO.File]::WriteAllText((Join-Path $dir 'result.json'), ([ordered]@{ task = $Task; target = $script:Tgt; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); tree = (Get-WorkTree $Root); environment = $envFail; startState = $startState; passed = $ok; total = $results.Count; results = $results } | ConvertTo-Json -Depth 6), $utf8)
    $rel = ($dir.Substring($Root.Length + 1) -replace '\\', '/')
    if ($startState) { [Console]::Out.WriteLine("accept $Task · $envFail · $rel/result.md"); return 4 }
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
    $sel = Select-ScenarioErrors $parsed.Errors $onlyList
    $parsed.Errors = @($sel.Msgs)
    if ($sel.Outside) { [Console]::Out.WriteLine("accept: aviso — $($sel.Outside) erro(s) em cenários fora do -Only (não reprovam esta execução; rode o -ParseOnly sem -Only para vê-los)") }
    foreach ($o in $onlyList) { if (-not ($parsed.Blocks | Where-Object { $_.id -eq $o })) { $parsed.Errors += "cenário $o pedido em -Only não existe" } }
    # v3.53.7 (encadeamento do sprint 5 do garden): a massa que o cenário pede existe ANTES de o alvo ser tocado — o -ParseOnly
    # do QA barra a massa não declarada, em vez de o accept descobrir no aparelho (o reset zerava a base e o cenário falhava).
    $seedUse = @($blocks | ForEach-Object { $b = $_; $b.steps | Where-Object { $_ -match '^seed\s+(\S+)\s*$' } | ForEach-Object { @{ Sc = $b.id; Name = ([regex]::Match($_, '^seed\s+(\S+)')).Groups[1].Value } } })
    if ($seedUse.Count) {
        $tcs = Get-TargetsConfig $Root
        $tn = @(if ($tcs) { $tcs.PSObject.Properties | ForEach-Object { $_.Name } | Where-Object { $_ -in 'android', 'web' -and (-not $Target -or $_ -eq $Target) } })
        foreach ($u in $seedUse) {
            if (-not @($tn | Where-Object { (Get-TargetSeeds $tcs.$_).Contains($u.Name) }).Count) {
                $parsed.Errors += "cenário $($u.Sc): massa de dados '$($u.Name)' não declarada em guards.json → targets.$(if ($tn.Count -eq 1) { $tn[0] } else { '<alvo>' }).seeds — a sessão declara o comando que a carrega (o script é do projeto, criado por uma Task) ou o cenário espera com '# aguarda <T-ID>'"
            }
        }
    }
    # v3.54.2: o estado de partida declarado tem de ser uma massa declarada.
    $tcB = Get-TargetsConfig $Root
    if ($tcB -and $tcB.PSObject.Properties['android'] -and $tcB.android -and $tcB.android.PSObject.Properties['baseline'] -and $tcB.android.baseline -and (-not $Target -or $Target -eq 'android')) {
        if (-not (Get-TargetSeeds $tcB.android).Contains([string]$tcB.android.baseline)) { $parsed.Errors += "targets.android.baseline '$([string]$tcB.android.baseline)' não é uma massa de targets.android.seeds — o estado de partida é o nome de uma massa declarada" }
    }
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
