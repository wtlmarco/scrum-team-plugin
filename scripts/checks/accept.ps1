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
# v3.62.0 (app híbrido): targets.android.locator = "cdp" — os verbos de tela (tap, type, select, slider, assert-*) vão ao
# android-cdp.js pelo DevTools da WebView, e o resto do ciclo continua no android.ps1; o result.json desse modo é prova de
# primeira classe. CONFIGURAÇÃO DO ALVO (exit 4, campo configuration no result.json, sem reparo — o run.ps1 done leva ao
# stakeholder): o APK sem a depuração da WebView, Node < 22, mais de uma página sem cdp.pageUrl, cdp.pageUrl que não casa
# nenhuma página carregada (a mensagem lista as URLs vistas; o pageUrl é a regex da origem do app, não da rota de uma tela —
# v3.65.0), ou — com o uiautomator — a tela do app ser uma WebView sem nenhum id do app (antes do 1º cenário; substitui o IDS
# NÃO PUBLICADOS da v3.57.1).
# A semântica de cada verbo, igual em todo alvo: standards/scenario-language.md.
# v3.62.3 (sprint 6 do projeto piloto, Q-S6d): EXECUTOR DO PROJETO — o plano da Task declara ``**Aceite:** comando — `<cmd>` ``
# (ou -Command, fora do run). O accept faz tudo o que faz sempre (trava do alvo, pré-voo e reparo, APK velho, instalação,
# targets.<alvo>.baseline) e, no lugar do executor interno, roda o comando um .scn por vez: {scn} o arquivo, {out} a pasta da
# prova (accept/<seg>/<ID>/cmd/<arquivo>), {only} os cenários da Task nele, {task} o ID (cada um vira um argumento entre
# aspas). O resultado vem das linhas "<SC-ID> PASSOU|FALHOU|NÃO EXERCITADO [detalhe]" da saída; exit 2 do comando = uso
# (exit 2), exit 4 ou tempo esgotado = ambiente (exit 4). Cenário da Task sem linha conta como FALHOU. progress.json a cada
# arquivo, result.json/result.md de sempre (executor "comando"). Sem o localizador do plugin: a tela é do executor.
# v3.63.1 (sprint 6 do projeto piloto, 18/11): a PROVA DA FALHA no android — o registro do aparelho de cada falha
# (logs/<ID>-<tentativa>-logcat.txt, com o buffer de crash) e o SINAL do app em cada linha (signal: crash · anr · closed ·
# restarted · webview-recreated · system-window · no-focus). O app que fechou com erro ou não respondeu ao abrir é FALHOU
# do cenário, não ambiente; a interrupção por ambiente grava environmentSignal no result.json, e o run.ps1 manda ao
# diagnóstico do operator antes do reparo. A identidade do -Resume é a do app instalado no aparelho (o hash do base.apk).
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
    [string]$Command = '',
    [switch]$Resume,   # v3.63.0: retoma — reaproveita o PASSOU da rodada anterior com o mesmo app instalado e o mesmo cenário
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)
$verbs = 'reset', 'launch', 'open', 'restart', 'back', 'clock', 'wait', 'tap', 'type', 'select', 'seed', 'slider', 'font-scale', 'shot',
         'assert-text', 'assert-contains', 'assert-exists', 'assert-absent', 'assert-checked', 'assert-count', 'assert-order'
# v3.62.0: os verbos de tela — com targets.android.locator = "cdp", vão ao android-cdp.js; os demais são do ciclo de vida.
$screenVerbs = 'tap', 'type', 'select', 'slider', 'assert-text', 'assert-contains', 'assert-exists', 'assert-absent', 'assert-checked', 'assert-count', 'assert-order'
$script:Locator = 'uiautomator'
$script:ExtCmd = ''; $script:ExtFrom = ''   # v3.62.3: o executor do projeto (o **Aceite:** comando do plano ou -Command)
$script:AppId = ''; $script:ScnFiles = @()   # v3.63.0: identidade do app provado e os .scn lidos (retomada e portão)
$script:Attempt = @{}   # v3.63.1: tentativa de cada cenário (nome do registro do aparelho de cada falha)

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
# v3.62.0: CONFIGURAÇÃO DO ALVO — o alvo, como está declarado, não consegue provar nada (APK sem a depuração da WebView, Node
# antigo, app híbrido com o uiautomator). Não é o app, o estado de partida nem queda: o reparo não resolve. Exit 4 (o caminho
# do "done -Result env"), com o campo configuration no result.json, que o run.ps1 done lê e leva ao stakeholder sem reparo.
function Write-AcceptConfig([string]$Dir, [string]$Msg, $Results) {
    New-Item -ItemType Directory -Force $Dir | Out-Null
    $rs = @($Results | Where-Object { $_ })
    [System.IO.File]::WriteAllText((Join-Path $Dir 'result.md'), "# Aceite $Task · alvo $script:Tgt · $(Get-Date -Format 'yyyy-MM-dd HH:mm')`n`n**Interrompido na CONFIGURAÇÃO DO ALVO:** $Msg`n", $utf8)
    [System.IO.File]::WriteAllText((Join-Path $Dir 'result.json'), ([ordered]@{ task = $Task; target = $script:Tgt; locator = $script:Locator; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); tree = (Get-WorkTree $Root); environment = "CONFIGURAÇÃO DO ALVO: $Msg"; configuration = $Msg; startState = $null; passed = @($rs | Where-Object { $_.status -eq 'PASSOU' }).Count; total = $rs.Count; results = $rs } | ConvertTo-Json -Depth 6), $utf8)
    $rel = ($Dir.Substring($Root.Length + 1) -replace '\\', '/')
    [Console]::Out.WriteLine("accept $Task · CONFIGURAÇÃO DO ALVO ($script:Tgt): $Msg · não é defeito do app nem queda do alvo — o reparo não resolve; vai ao stakeholder (guards.json e build são dele) · $rel/result.md")
    return 4
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
    # v3.63.0: todas as linhas da rodada e a identidade do app — o -Resume retoma de uma rodada que caiu sem result.json.
    $o = [ordered]@{ task = $Task; pid = $PID; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); app = $script:AppId; total = $Total; passed = $pass; failed = $rs.Count - $pass; streak = $streak; last = $(if ($rs.Count) { $rs[-1] } else { $null }); results = @($rs) }
    try { [System.IO.File]::WriteAllText((Join-Path $Dir 'progress.json'), ($o | ConvertTo-Json -Depth 5), $utf8) } catch { }
}
# v3.63.0: impressão de um cenário (id + passos) — o PASSOU só é reaproveitado com o mesmo texto do cenário.
function Get-ScenarioHash($Block) { return (Get-TextHash ([string]$Block.id + "`n" + (@($Block.steps) -join "`n"))) }
# v3.63.0 (item B do plano): o que o -Resume reaproveita — as linhas PASSOU da rodada anterior (progress.json ou result.json,
# o mais novo) com a MESMA identidade do app instalado e o mesmo texto do cenário. Antes, a queda no cenário 30 de 49 fazia a
# rodada seguinte começar do 1. @{ id → linha anterior } (vazio sem -Resume, sem rodada anterior ou com outro app).
function Get-AcceptReuse([string]$Dir, $Blocks) {
    $out = @{}
    if (-not $Resume) { return $out }
    $prev = $null
    foreach ($f in @('progress.json', 'result.json' | ForEach-Object { Join-Path $Dir $_ } | Where-Object { Test-Path -LiteralPath $_ } | Sort-Object { (Get-Item -LiteralPath $_).LastWriteTime } -Descending)) {
        try { $j = Read-Text $f | ConvertFrom-Json; if (@($j.results).Count) { $prev = $j; break } } catch { }
    }
    if (-not $prev) { [Console]::Out.WriteLine('accept -Resume: nenhuma rodada anterior com resultado — roda todos'); return $out }
    $pa = if ($prev.PSObject.Properties['app']) { [string]$prev.app } else { '' }
    if ([string]$script:AppId -match ':\?$') { [Console]::Out.WriteLine("accept -Resume: a identidade do app instalado não pôde ser lida ($($script:AppId)) — sem ela não há como provar que é o mesmo app; roda todos"); return $out }
    if (-not $pa -or $pa -ne [string]$script:AppId) { [Console]::Out.WriteLine("accept -Resume: o app instalado mudou ($(if ($pa) { $pa } else { 'rodada anterior sem identidade' }) → $($script:AppId)) — roda todos"); return $out }
    $byId = @{}; foreach ($b in @($Blocks)) { $byId[[string]$b.id] = $b }
    foreach ($r in @($prev.results)) {
        $id = [string]$r.id
        if ([string]$r.status -ne 'PASSOU' -or -not $byId.ContainsKey($id)) { continue }
        if (-not $r.PSObject.Properties['hash'] -or [string]$r.hash -ne (Get-ScenarioHash $byId[$id])) { continue }
        # A hora da prova original: a do PASSOU que já era reaproveitado, senão a da rodada anterior.
        $r | Add-Member -NotePropertyName provedAt -NotePropertyValue $(if ($r.PSObject.Properties['provedAt'] -and $r.provedAt) { [string]$r.provedAt } else { [string]$prev.at }) -Force
        $out[$id] = $r
    }
    [Console]::Out.WriteLine("accept -Resume: $($out.Count) cenário(s) PASSOU reaproveitado(s) da rodada de $([string]$prev.at) (mesmo app $($script:AppId)); $(@($Blocks).Count - $out.Count) a rodar")
    return $out
}
# v3.63.0: a linha reaproveitada, no formato da rodada (o detalhe diz de quando é a prova).
function New-ReusedRow($Prev, $Block) {
    return [ordered]@{ id = [string]$Block.id; title = $Block.title; status = 'PASSOU'; detail = ''; note = "reaproveitado: passou em $([string]$Prev.provedAt) com o mesmo app e o mesmo cenário"; shot = [string]$Prev.shot; hash = (Get-ScenarioHash $Block); reused = $true; provedAt = [string]$Prev.provedAt }
}
# v3.63.0: identidade do app que o accept prova — android: o APK instalado (hash do arquivo); web: targets.web.appSources
# (máscaras) ou a árvore de produção.
# v3.63.1 (sprint 6 do projeto piloto, pedido 4): android — o app INSTALADO no aparelho (Get-AndroidInstalledIdentity: o hash do
# base.apk, igual ao do arquivo quando foi ele o instalado); o arquivo local só quando o aparelho não responde. Antes só o
# arquivo local contava, e o APK instalado pelo comando do projeto (sem arquivo no disco do Windows) dava "apk:?".
function Get-AppIdentity([string]$Apk, $Cfg) {
    if ($script:Tgt -eq 'android') {
        $h = ''; if (Get-Command Get-AndroidInstalledIdentity -ErrorAction SilentlyContinue) { try { $h = Get-AndroidInstalledIdentity } catch { $h = '' } }
        if (-not $h) { $h = Get-FileHash12 $Apk }
        return $(if ($h) { "apk:$h" } else { 'apk:?' })
    }
    $src = @(if ($Cfg -and $Cfg.PSObject.Properties['appSources']) { @($Cfg.appSources) | Where-Object { $_ } | ForEach-Object { [string]$_ } })
    $t = Get-ProductionTree $Root $src
    return $(if ($t) { "web:$t" } else { 'web:?' })
}

# v3.62.3: uma chamada do executor do projeto para um .scn ($Ids = os cenários da Task nele). Devolve @{ Code; Lines; Log;
# Seconds; Environment; Out }. O tempo limite é por arquivo: targets.<alvo>.commandTimeoutMin, ou 5 min por cenário (mín. 10).
function Invoke-AcceptCommandRun([string]$Dir, [string]$File, [string[]]$Ids, [string]$Name, $Cfg) {
    $out = Join-Path $Dir "cmd/$Name"; New-Item -ItemType Directory -Force $out | Out-Null
    $cmd = Expand-AcceptCommand $script:ExtCmd @{ scn = $File; out = $out; only = ($Ids -join ','); task = $Task }
    $log = Join-Path $Dir "cmd/$Name.log"
    $tmo = if ($Cfg -and $Cfg.PSObject.Properties['commandTimeoutMin'] -and [double]$Cfg.commandTimeoutMin -gt 0) { [double]$Cfg.commandTimeoutMin } else { [Math]::Max(10, 5 * @($Ids).Count) }
    $envX = [pscustomobject]@{ ACCEPT_TASK = $Task; ACCEPT_TARGET = $script:Tgt; ACCEPT_SERIAL = [string]$script:Serial; ACCEPT_PACKAGE = [string]$script:Pkg; ACCEPT_SCENARIOS = $File; ACCEPT_ONLY = ($Ids -join ','); ACCEPT_OUT = $out }
    $x = Invoke-ProjectCommand $Root "accept-$Name" $cmd $log $tmo $envX
    $text = if (Test-Path -LiteralPath $log) { Read-LogText $log } else { '' }
    $envFail = $null
    if ([int]$x.exit -eq 124) { $envFail = "o executor do projeto passou de $tmo min em $Name (targets.$($script:Tgt).commandTimeoutMin) — árvore encerrada" }
    elseif ($x.suspended) { $envFail = [string]$x.environment }
    elseif ([int]$x.exit -eq 4) { $last = @(($text -split "`r?`n") | Where-Object { $_.Trim() -and $_ -notmatch '^EXIT=' }) | Select-Object -Last 1; $envFail = "o executor do projeto saiu 4 (ambiente) em $Name$(if ($last) { ": $($last.Trim())" })" }
    return @{ Code = [int]$x.exit; Lines = (Read-AcceptCommandLines $text); Log = ($log.Substring($Root.Length + 1) -replace '\\', '/'); Seconds = [int]$x.seconds; Environment = $envFail; Out = $out }
}
# v3.62.3: a captura do cenário na pasta da prova do executor (a primeira <ID>*.png, a de falha antes) — '' sem ela.
function Find-AcceptShot([string]$Out, [string]$Id) {
    $fs = @(Get-ChildItem -LiteralPath $Out -Recurse -File -Filter "$Id*.png" -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^$([regex]::Escape($Id))(\D|$)" } | Sort-Object @{ e = { if ($_.Name -match 'falha') { 0 } else { 1 } } }, FullName)
    if (-not $fs.Count) { return '' }
    return ($fs[0].FullName.Replace($Root, '').TrimStart('\', '/') -replace '\\', '/')
}
# v3.62.3: o aceite pelo executor do projeto — um .scn por vez, na ordem dos blocos. Mesmo contrato de saída do executor
# interno (result.json, result.md, progress.json; exit 0/1/2/4), com executor "comando", o comando e cada chamada (runs).
function Invoke-AcceptCommand([string]$Dir, $Blocks, $Cfg) {
    $files = @(); foreach ($b in $Blocks) { if ($files -notcontains [string]$b.file) { $files += [string]$b.file } }
    $results = @(); $runs = @(); $envFail = $null; $usage = ''
    $reuse = Get-AcceptReuse $Dir $Blocks   # v3.63.0: antes do progress.json, que a rodada nova regrava
    $cd = Join-Path $Dir 'cmd'; if (-not $reuse.Count -and (Test-Path -LiteralPath $cd)) { Remove-Item -LiteralPath $cd -Recurse -Force -ErrorAction SilentlyContinue }   # captura de rodada anterior não vira prova desta (na retomada, a dos reaproveitados fica)
    Write-AcceptProgress $Dir $results $Blocks.Count
    $canRetry = (-not $NoRetry) -and $script:ExtCmd.Contains('{only}')
    foreach ($f in $files) {
        $fileBlocks = @($Blocks | Where-Object { [string]$_.file -eq $f })
        # v3.63.0: com -Resume e {only}, só os que não foram reaproveitados; sem {only} o executor roda o arquivo inteiro.
        $canOnly = $script:ExtCmd.Contains('{only}')
        $reusedHere = @($fileBlocks | Where-Object { $canOnly -and $reuse.ContainsKey([string]$_.id) })
        foreach ($b in $reusedHere) { $row = New-ReusedRow $reuse[[string]$b.id] $b; $results += $row; [Console]::Out.WriteLine(("[{0}] PASSOU  {1}  ({2})" -f $b.id, $b.title, $row.note)) }
        $ids = @($fileBlocks | Where-Object { $reusedHere -notcontains $_ } | ForEach-Object { [string]$_.id })
        $name = [System.IO.Path]::GetFileNameWithoutExtension($f)
        if (-not $ids.Count) { Write-AcceptProgress $Dir $results $Blocks.Count; continue }
        [Console]::Out.WriteLine("accept: executor do projeto — $name ($($ids.Count) cenário(s))")
        # v3.63.1: o registro do aparelho da chamada (android) — gravado quando algum cenário falha ou o executor sai por ambiente.
        $andr = $script:Tgt -eq 'android' -and (Get-Command Save-AndroidLog -ErrorAction SilentlyContinue)
        $logOf = @{}
        if ($andr) { try { Clear-AndroidLog } catch { } }
        $r1 = Invoke-AcceptCommandRun $Dir $f $ids $name $Cfg
        if ($andr -and ($r1.Environment -or @($ids | Where-Object { -not $r1.Lines.Contains($_) -or $r1.Lines[$_].status -eq 'FALHOU' }).Count)) {
            $lp1 = Join-Path $Dir "logs/$name-logcat.txt"; try { $null = Save-AndroidLog $lp1 } catch { }
            if (Test-Path -LiteralPath $lp1) { foreach ($i in $ids) { $logOf[$i] = ($lp1.Replace($Root, '').TrimStart('\', '/') -replace '\\', '/') } }
        }
        $runs += [ordered]@{ file = ($f.Replace($Root, '').TrimStart('\', '/') -replace '\\', '/'); only = ($ids -join ','); exit = $r1.Code; seconds = $r1.Seconds; log = $r1.Log }
        if ($r1.Code -eq 2 -and -not $r1.Lines.Count) { $usage = "o executor do projeto saiu 2 (uso ou cenário malformado) em $name — confira o comando do **Aceite:** e o log $($r1.Log)"; break }
        $r2 = $null
        $bad = @($ids | Where-Object { $r1.Lines.Contains($_) -and $r1.Lines[$_].status -eq 'FALHOU' })
        if (-not $r1.Environment -and $canRetry -and $bad.Count) {
            # Repete uma vez os que falharam (o alvo oscila), como o executor interno; o relatório guarda as duas tentativas.
            $r2 = Invoke-AcceptCommandRun $Dir $f $bad "$name-r2" $Cfg
            $runs += [ordered]@{ file = ($f.Replace($Root, '').TrimStart('\', '/') -replace '\\', '/'); only = ($bad -join ','); exit = $r2.Code; seconds = $r2.Seconds; log = $r2.Log }
        }
        foreach ($b in @($fileBlocks | Where-Object { $ids -contains [string]$_.id })) {
            $id = [string]$b.id; $note = ''
            if ($r1.Lines.Contains($id)) { $st = $r1.Lines[$id].status; $det = $r1.Lines[$id].detail; $shotDir = $r1.Out }
            elseif ($r1.Environment) { continue }   # não rodou: a interrupção por ambiente diz quantos ficaram de fora
            else { $st = 'FALHOU'; $det = "o executor do projeto não devolveu linha para este cenário (exit $($r1.Code); log $($r1.Log))"; $shotDir = $r1.Out }
            if ($r2 -and $bad -contains $id) {
                if ($r2.Lines.Contains($id)) {
                    $note = if ($r2.Lines[$id].status -eq 'PASSOU') { "passou na 2ª tentativa; 1ª: $det" } else { 'falhou nas 2 tentativas' }
                    $st = $r2.Lines[$id].status; $det = $(if ($st -eq 'PASSOU') { '' } else { $r2.Lines[$id].detail }); $shotDir = $r2.Out
                } elseif (-not $r2.Environment) { $note = "2ª tentativa sem linha para este cenário (exit $($r2.Code))" }
            }
            $row = [ordered]@{ id = $id; title = $b.title; status = $st; detail = $det; note = $note; shot = (Find-AcceptShot $shotDir $id); hash = (Get-ScenarioHash $b) }
            if ($st -ne 'PASSOU' -and $logOf.ContainsKey($id)) { $row.log = $logOf[$id] }   # v3.63.1
            $results += $row
            [Console]::Out.WriteLine(("[{0}] {1}  {2}{3}{4}" -f $id, $st, $b.title, $(if ($det) { "  -> $det" } else { '' }), $(if ($note) { "  ($note)" } else { '' })))
        }
        Write-AcceptProgress $Dir $results $Blocks.Count
        if ($r1.Environment) { $envFail = $r1.Environment; break }
        if ($r2 -and $r2.Environment) { $envFail = $r2.Environment; break }
    }
    if ($script:Tgt -eq 'web') { Stop-WebServer }
    $ok = @($results | Where-Object { $_.status -eq 'PASSOU' }).Count
    $miss = $Blocks.Count - $results.Count
    $md = "# Aceite $Task · alvo $script:Tgt · executor do projeto · $(Get-Date -Format 'yyyy-MM-dd HH:mm')`n`n**Comando** ($script:ExtFrom): ``$script:ExtCmd```n`n$ok de $($results.Count) cenário(s) passaram" + $(if ($usage) { "; **interrompido:** $usage" } elseif ($envFail) { "; **interrompido por falha de ambiente:** $envFail ($miss cenário(s) não rodaram)" } else { '' }) + ".`n`n| Cenário | Resultado | Detalhe | Prova (captura) |`n|---|---|---|---|`n"
    foreach ($r in $results) { $lg = if ($r.Contains('log') -and $r.log) { " · registro $($r.log)" } else { '' }; $md += "| $($r.id) $($r.title) | $($r.status) | $((@($r.detail, $r.note) | Where-Object { $_ }) -join ' · ' -replace '\|', '/')$lg | $($r.shot) |`n" }
    $md += "`n| Arquivo | Cenários | Exit | Segundos | Log |`n|---|---|---|---|---|`n"
    foreach ($u in $runs) { $md += "| $($u.file) | $($u.only) | $($u.exit) | $($u.seconds) | $($u.log) |`n" }
    [System.IO.File]::WriteAllText((Join-Path $Dir 'result.md'), $md, $utf8)
    $envAll = if ($usage) { $null } else { $envFail }
    [System.IO.File]::WriteAllText((Join-Path $Dir 'result.json'), ([ordered]@{ task = $Task; target = $script:Tgt; locator = $null; executor = 'comando'; command = $script:ExtCmd; commandFrom = $script:ExtFrom; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); tree = (Get-WorkTree $Root); prod = (Get-ProductionTree $Root); app = $script:AppId; scenariosHash = (Get-ScenarioSetHash $script:ScnFiles); environment = $envAll; startState = $null; passed = $ok; total = $results.Count; results = $results; runs = $runs } | ConvertTo-Json -Depth 6), $utf8)
    $rel = ($Dir.Substring($Root.Length + 1) -replace '\\', '/')
    if ($usage) { [Console]::Out.WriteLine("accept $Task · $usage · $rel/result.md"); return 2 }
    if ($envFail) { [Console]::Out.WriteLine("accept $Task · FALHA DE AMBIENTE ($script:Tgt): $envFail · $ok de $($results.Count) antes da interrupção, $miss não rodaram · $rel/result.md"); return 4 }
    [Console]::Out.WriteLine("accept $Task · alvo $script:Tgt · executor do projeto · $ok de $($results.Count) cenário(s) passaram · $rel/result.md")
    if ($ok -lt $results.Count) { return 1 }
    return 0
}

# Um cenário, do zero, no alvo. Devolve status/detalhe/captura, ou environment quando o alvo quebrou.
function Invoke-Once($Block) {
    if ($script:Tgt -eq 'web') {
        $o = Invoke-WebScenarios @($Block) $script:Shots
        if ($o.environment) { return @{ environment = [string]$o.environment } }
        $r = @($o.results)[0]; return @{ status = [string]$r.status; detail = [string]$r.detail; shot = [string]$r.shot }
    }
    $base = Join-Path $script:Shots $Block.id; $status = 'PASSOU'; $detail = ''
    $cdp = $script:Locator -eq 'cdp'
    # v3.63.1 (pedidos 2 e 3): o registro do aparelho deste cenário começa limpo, e o pid do app é anotado a cada passo de ciclo
    # de vida — na falha, o sinal diz se o app fechou com erro, foi reiniciado, teve a WebView recriada ou perdeu o foco.
    $script:Attempt[[string]$Block.id] = 1 + [int]$script:Attempt[[string]$Block.id]
    try { Clear-AndroidLog } catch { }
    $pidRef = 0; $sig = $null
    foreach ($s in $Block.steps) {
        $verb, $rest = ($s -split '\s+', 2); if ($null -eq $rest) { $rest = '' }
        try {
            # v3.62.0: com o locator "cdp", o passo de tela vai pela WebView; abrir o app (e a fonte nova, que recria a WebView)
            # espera a prontidão declarada (targets.android.cdp.readyExpr) e confere a tela de falha do app (failExpr).
            if ($cdp -and $screenVerbs -contains $verb) { Invoke-AndroidCdpStep $verb $rest }
            else {
                Invoke-AndroidStep $verb $rest $base | Out-Null
                if ($cdp -and $verb -in 'launch', 'open', 'restart', 'font-scale') { Invoke-AndroidCdpStep 'ready' '' }
            }
            if ($verb -in 'launch', 'open', 'restart', 'reset', 'font-scale') { try { $pidRef = Get-AndroidAppPid } catch { } }
            if ($verb -eq 'reset') { $be = Invoke-AcceptBaseline; if ($be) { return @{ environment = $be } } }   # v3.54.2
        }
        catch {
            $m = $_.Exception.Message
            if ($m -like 'CONFIGURAÇÃO:*') { return @{ config = ($m -replace '^CONFIGURAÇÃO:\s*', '').Trim() } }
            if ($m -like 'AMBIENTE:*') {
                $em = $m.Substring(9).Trim()
                # O alvo que não responde (adb sem resposta, tela em branco) não tem registro a ler: só somaria prazos.
                if ($script:AdbTimeout -or $em -match 'sem resposta|em branco|não devolveu') { return @{ environment = $em } }
                $sig = Get-AcceptFailEvidence ([string]$Block.id) $pidRef $em
                # v3.63.1: o app que fechou com erro (ou parou de responder) ao abrir não é o alvo — é falha do cenário, com a prova.
                if ($sig.kind -notin 'crash', 'anr') { Save-AndroidShot "$base-falha.png"; return @{ environment = $em; signal = $sig; shot = "$base-falha.png" } }
                $status = 'FALHOU'; $detail = "passo '$s': $($sig.text) — $em"; break
            }
            $status = 'FALHOU'; $detail = "passo '$s': $m"; break
        }
    }
    if ($status -ne 'PASSOU' -and -not $sig) { $sig = Get-AcceptFailEvidence ([string]$Block.id) $pidRef $detail }
    if ($sig -and $sig.kind -and $detail -notmatch [regex]::Escape([string]$sig.text)) { $detail += " · sinal: $($sig.text)" }
    $shot = "$base-$(if ($status -eq 'PASSOU') { 'final' } else { 'falha' }).png"; Save-AndroidShot $shot
    return @{ status = $status; detail = $detail; shot = $shot; signal = $sig }
}
# v3.63.1: a prova da falha no aparelho — o registro (logs/<ID>-<tentativa>-logcat.txt na pasta do accept) e o sinal do app.
# @{ kind; text; log } (kind '' quando nada se pôde dizer; o log fica mesmo assim).
function Get-AcceptFailEvidence([string]$Id, [int]$PidRef, [string]$Detail) {
    $n = [int]$script:Attempt[$Id]; if ($n -lt 1) { $n = 1 }
    $lp = Join-Path (Split-Path $script:Shots) "logs/$Id-$n-logcat.txt"
    $sg = $null; $lg = $null
    try { $lg = Save-AndroidLog $lp } catch { }
    try { $sg = Get-AndroidFailSignal $PidRef $Detail $(if ($lg) { $lg } else { @{ Main = @(); Crash = @() } }) } catch { }
    $rel = if (Test-Path -LiteralPath $lp) { ($lp.Replace($Root, '').TrimStart('\', '/') -replace '\\', '/') } else { '' }
    return [pscustomobject]@{ kind = $(if ($sg) { [string]$sg.kind } else { '' }); text = $(if ($sg) { [string]$sg.text } else { '' }); log = $rel }
}

# Corpo com a trava já tomada. Devolve o código de saída.
function Invoke-Accept($Blocks, $Cfg, $Health, $Repair) {
    $dir = (Get-VerifyDir $Root $Task) -replace '[\\/]verify[\\/]', '/accept/'
    $fresh = $false; $freshOk = $false; $script:BaseCfg = $Cfg
    if ($script:Tgt -eq 'android') {
        # v3.51.1: sem targets.android.package/apk, o executor descobre o APK construído e o applicationId dele.
        $appApk = Resolve-AndroidApk $Root $Apk
        # v3.53.6 (sprint 5 do garden, item 7): APK mais velho que o código do módulo não é instalado — rodaria o app de antes
        # da mudança ("tag não encontrada" para o id recém-criado). Nem ambiente nem defeito do app: exit 2, reconstruir.
        $st = Get-ApkStaleness $appApk $Root   # v3.57.1: com $Root, vale targets.android.apkSources (app híbrido)
        if ($st.Stale) {
            $fr = ([string]$st.File).Replace($Root, '').TrimStart('\', '/') -replace '\\', '/'
            $ar = ([string]$st.ApkFull).Replace($Root, '').TrimStart('\', '/') -replace '\\', '/'
            [Console]::Out.WriteLine("accept: APK mais velho que o código ($fr alterado em $($st.FileTime.ToString('yyyy-MM-dd HH:mm:ss')); $ar de $($st.ApkTime.ToString('yyyy-MM-dd HH:mm:ss'))): reconstrua ($($st.Task)) antes do accept. Não é falha de ambiente nem defeito do app — o APK do disco não tem a mudança.")
            return 2
        }
        if ($st.Note) { [Console]::Out.WriteLine("accept: $($st.Note)") }
        $fresh = Test-AndroidFreshStartDue $Cfg $dir ([bool]$NoRepair)
    }
    # v3.58.4: o emulador desligado entre Tasks (run.ps1 start → target.ps1 -Release) volta pelo -Repair do dev, para o comando
    # do projeto instalar o APK antes do accept; ligado há menos de targets.android.freshStartMinutes (padrão 30), ele já começa
    # limpo — reiniciar de novo seria um segundo boot sem ganho de memória.
    if ($fresh) {
        $hPre = & $Health
        $upm = if (-not $hPre) { Get-AndroidUptimeMin } else { $null }
        $lim = Get-AndroidFreshMinutes $Cfg
        if ($null -ne $upm -and $upm -lt $lim) {
            Set-AndroidFreshStartDone $dir $Task "primeiro accept da Task: emulador ligado há $upm min (< $lim min, targets.android.freshStartMinutes) — já começa limpo, sem novo reinício"
            [Console]::Out.WriteLine("accept: primeiro accept da $Task — o emulador está ligado há $upm min (limite $lim min): já começa limpo, sem novo reinício")
            $fresh = $false; $freshOk = $true
        }
    }
    if ($fresh) {
        # v3.53.6 (item 5, decisão do stakeholder): o primeiro accept de cada Task reinicia o emulador em container (repair).
        [Console]::Out.WriteLine("accept: primeiro accept da $Task — reiniciando o emulador pelo reparo declarado (targets.android.repair) para começar com memória limpa; as repetições desta Task reaproveitam o emulador (targets.android.freshStart: false desliga)")
        $fsw = [System.Diagnostics.Stopwatch]::StartNew()
        $h = & $Repair
        if (-not $h) { Set-AndroidFreshStartDone $dir $Task; [Console]::Out.WriteLine("accept: emulador reiniciado e pronto em $([int]$fsw.Elapsed.TotalSeconds) s") }
    } elseif ($freshOk) { $h = $null   # o pré-voo acabou de passar (v3.58.4, acima)
    } else {
        # Pré-voo; com falha, o reparo é tentado UMA vez (D4) antes de desistir.
        $h = & $Health
        if ($h -and -not $NoRepair) { [Console]::Out.WriteLine("accept: pré-voo falhou ($h) — tentando o reparo uma vez"); $h = & $Repair }
    }
    if ($h) { [Console]::Out.WriteLine("accept: FALHA DE AMBIENTE ($script:Tgt) — $h. Não é defeito do app: reinicie o alvo e rode de novo."); return 4 }
    if ($script:Tgt -eq 'android') {
        if (-not ($Cfg -and $Cfg.package)) { Set-AndroidPackage (Get-ApkPackage $appApk) }
        if (-not $script:Pkg) { [Console]::Out.WriteLine('accept: sem o pacote do app — nenhum APK em <projeto>/**/build/outputs/apk/ e nada em targets.android.package; construa o app (assembleDebug ou assembleRelease) antes'); return 2 }
        if ($appApk) { $ie = Install-AndroidApk $appApk; if ($ie) { [Console]::Out.WriteLine("accept: $ie"); return 2 }; [Console]::Out.WriteLine("accept: $($script:Pkg) instalado de $($appApk.Replace($Root, '').TrimStart('\', '/'))" + $(if ($script:InstallNote) { " — atenção: $($script:InstallNote)" } else { ' (por cima: dados do app mantidos)' })) }
        # v3.54.2: o estado de partida declarado, depois da instalação.
        $be = Invoke-AcceptBaseline
        if ($be) { [Console]::Out.WriteLine("accept: FALHA DE AMBIENTE ($script:Tgt) — $be. Não é defeito do app."); return 4 }
        if ($Cfg -and $Cfg.PSObject.Properties['baseline'] -and $Cfg.baseline) { [Console]::Out.WriteLine("accept: estado de partida aplicado (targets.android.baseline '$([string]$Cfg.baseline)')") }
        # v3.62.0: pré-voo do localizador. v3.62.3: com o executor do projeto, a tela é dele — sem o pré-voo do localizador.
        if ($script:ExtCmd) { }
        elseif ($script:Locator -eq 'cdp') {
            $nm = Test-AndroidCdpNode; if ($nm) { return (Write-AcceptConfig $dir $nm @()) }
            $cl = Clear-AndroidCdpForwards; if ($cl) { [Console]::Out.WriteLine("accept: $cl forward(s) da WebView de uma execução anterior removido(s)") }
        } else {
            # Com o uiautomator: o app aberto, a tela é uma WebView e nenhum id do app chegou à árvore → nenhum cenário acharia
            # id nenhum. Para ANTES do 1º cenário (a v3.57.1 só via isso depois de 2 cenários falharem).
            $hy = $false
            try { Invoke-AndroidStep 'launch' '' '' | Out-Null; $hy = Test-HybridWithoutIds (Dump) } catch { }
            if ($hy) { return (Write-AcceptConfig $dir 'app híbrido: a tela do app é uma WebView e o uiautomator não recebe nenhum id do app (a WebView não publica o id HTML) — declare guards.json → targets.android.locator = "cdp" (standards/test-ids.md §6)' @()) }
        }
    }
    $script:AppId = Get-AppIdentity $(if ($script:Tgt -eq 'android') { $appApk } else { '' }) $Cfg   # v3.63.0
    if ($script:ExtCmd) { New-Item -ItemType Directory -Force $dir | Out-Null; return (Invoke-AcceptCommand $dir $Blocks $Cfg) }   # v3.62.3

    $script:Shots = Join-Path $dir 'shots'; New-Item -ItemType Directory -Force $script:Shots | Out-Null
    $results = @(); $envFail = $null; $startState = $null; $envSig = $null
    $reuse = Get-AcceptReuse $dir $Blocks   # v3.63.0: antes do progress.json, que a rodada nova regrava
    Write-AcceptProgress $dir $results $Blocks.Count
    # v3.63.1: a interrupção por ambiente leva o sinal do app (e o cenário, o registro e a captura) ao result.json — o next
    # manda ao diagnóstico antes de tratar como ambiente.
    $takeEnv = { param($r, $b) $script:envSigTmp = if ($r.signal -and $r.signal.kind) { [ordered]@{ kind = [string]$r.signal.kind; text = [string]$r.signal.text; scenario = [string]$b.id; log = [string]$r.signal.log; shot = $(if ($r.shot) { ([string]$r.shot).Replace($Root, '').TrimStart('\', '/') -replace '\\', '/' } else { '' }) } } else { $null } }
    foreach ($b in $Blocks) {
        if ($reuse.ContainsKey([string]$b.id)) {
            $row = New-ReusedRow $reuse[[string]$b.id] $b; $results += $row
            [Console]::Out.WriteLine(("[{0}] PASSOU  {1}  ({2})" -f $b.id, $b.title, $row.note)); Write-AcceptProgress $dir $results $Blocks.Count; continue
        }
        $r1 = Invoke-Once $b
        if ($r1.config) { return (Write-AcceptConfig $dir ([string]$r1.config) $results) }   # v3.62.0
        if ($r1.environment) { $envFail = $r1.environment; & $takeEnv $r1 $b; $envSig = $script:envSigTmp; break }
        $final = $r1; $note = ''
        # Repete uma vez do zero (o alvo oscila); o relatório guarda as duas tentativas.
        if ($r1.status -ne 'PASSOU' -and -not $NoRetry) {
            $r2 = Invoke-Once $b
            if ($r2.config) { return (Write-AcceptConfig $dir ([string]$r2.config) $results) }
            if ($r2.environment) { $envFail = $r2.environment; & $takeEnv $r2 $b; $envSig = $script:envSigTmp; break }
            $final = $r2; $note = if ($r2.status -eq 'PASSOU') { "passou na 2ª tentativa; 1ª: $($r1.detail)" } else { 'falhou nas 2 tentativas' }
        }
        $shotRel = if ($final.shot) { ([string]$final.shot).Replace($Root, '').TrimStart('\', '/') -replace '\\', '/' } else { '' }
        $row = [ordered]@{ id = $b.id; title = $b.title; status = $final.status; detail = $final.detail; note = $note; shot = $shotRel; hash = (Get-ScenarioHash $b) }
        if ($final.signal -and $final.status -ne 'PASSOU') { $row.signal = [string]$final.signal.kind; $row.signalText = [string]$final.signal.text; $row.log = [string]$final.signal.log }   # v3.63.1
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
                # v3.62.0: o app híbrido com o uiautomator para antes do 1º cenário (CONFIGURAÇÃO DO ALVO, acima) — o "IDS NÃO
                # PUBLICADOS" da v3.57.1 saiu daqui.
                $envFail = "ESTADO DE PARTIDA: os 2 primeiros cenários ($($results[0].id), $($results[1].id)) pararam na mesma tela — $sc1 — e nenhum chegou ao critério; $($Blocks.Count - 2) cenário(s) não rodaram. Não é defeito do código nem queda do emulador: o app não está na tela de partida dos cenários (declare targets.android.baseline ou ajuste o cenário). Captura: $($results[1].shot)"
                break
            }
        }
    }
    if ($script:Tgt -eq 'web') { Stop-WebServer }

    $ok = @($results | Where-Object { $_.status -eq 'PASSOU' }).Count
    $sigMd = if ($envSig) { " **Sinal do app** ($($envSig.scenario)): $($envSig.text)$(if ($envSig.log) { " · registro $($envSig.log)" })$(if ($envSig.shot) { " · captura $($envSig.shot)" }) — vai ao diagnóstico antes de ser tratado como ambiente." } else { '' }
    $md = "# Aceite $Task · alvo $script:Tgt · $(Get-Date -Format 'yyyy-MM-dd HH:mm')`n`n$ok de $($results.Count) cenário(s) passaram" + $(if ($startState) { "; **interrompido no estado de partida:** $envFail" } elseif ($envFail) { "; **interrompido por falha de ambiente:** $envFail" } else { '' }) + ".$sigMd`n`n| Cenário | Resultado | Detalhe | Prova (captura) |`n|---|---|---|---|`n"
    foreach ($r in $results) { $lg = if ($r.Contains('log') -and $r.log) { " · registro $($r.log)" } else { '' }; $md += "| $($r.id) $($r.title) | $($r.status) | $((@($r.detail, $r.note) | Where-Object { $_ }) -join ' · ' -replace '\|', '/')$lg | $($r.shot) |`n" }
    [System.IO.File]::WriteAllText((Join-Path $dir 'result.md'), $md, $utf8)
    [System.IO.File]::WriteAllText((Join-Path $dir 'result.json'), ([ordered]@{ task = $Task; target = $script:Tgt; locator = $(if ($script:Tgt -eq 'android') { $script:Locator } else { $null }); at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); tree = (Get-WorkTree $Root); prod = (Get-ProductionTree $Root); app = $script:AppId; scenariosHash = (Get-ScenarioSetHash $script:ScnFiles); environment = $envFail; environmentSignal = $envSig; startState = $startState; passed = $ok; total = $results.Count; results = $results } | ConvertTo-Json -Depth 6), $utf8)
    $rel = ($dir.Substring($Root.Length + 1) -replace '\\', '/')
    if ($startState) { [Console]::Out.WriteLine("accept $Task · $envFail · $rel/result.md"); return 4 }
    if ($envFail) { [Console]::Out.WriteLine("accept $Task · FALHA DE AMBIENTE ($script:Tgt): $envFail$(if ($envSig) { " · sinal do app: $($envSig.text) (vai ao diagnóstico)" }) · $ok de $($results.Count) antes da interrupção · $rel/result.md"); return 4 }
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
    $script:ScnFiles = @($files)   # v3.63.0
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
    # v3.62.3: o executor do projeto — -Command, ou a linha **Aceite:** comando do plano da Task.
    if ($Command) { $script:ExtCmd = $Command.Trim(); $script:ExtFrom = '-Command' }
    elseif ($Task -and $Task -ne 'avulso') {
        $pp = Get-TaskPlanPath $Root $Task
        if ($pp) { $pa = Get-PlanAccept (Read-Text $pp); if ($pa -and $pa.Mode -eq 'comando') { $script:ExtCmd = $pa.Command; $script:ExtFrom = "plano $(($pp.Replace($Root, '').TrimStart('\', '/')) -replace '\\', '/')" } }
    }
    if ($script:ExtCmd) {
        $bad = @(Split-CommandSegments $script:ExtCmd | ForEach-Object { $w = Get-ForbiddenCommandReason $_; if ($w) { "$_ ($w)" } })
        if ($bad.Count) { [Console]::Out.WriteLine("accept: o executor do projeto ($script:ExtFrom) tem trecho que o run nunca roda: $($bad -join '; ') — instalação, rede, push e destrutivo ficam fora"); exit 2 }
        if (-not $script:ExtCmd.Contains('{scn}')) { [Console]::Out.WriteLine("accept: o executor do projeto ($script:ExtFrom) não recebe o arquivo de cenários — o comando leva {scn} (e {out} para a pasta da prova): ``$script:ExtCmd``"); exit 2 }
    }
    if ($ParseOnly) { [Console]::Out.WriteLine("accept: $($blocks.Count) cenário(s) válidos em $($files.Count) arquivo(s): $(($blocks | ForEach-Object { $_.id }) -join ', ')" + $(if ($script:ExtCmd) { " · executor do projeto ($script:ExtFrom): ``$script:ExtCmd``" } else { '' })); exit 0 }

    # ---------- alvo ----------
    $targets = Get-TargetsConfig $Root
    if (-not $Target) {
        $names = @(if ($targets) { $targets.PSObject.Properties | ForEach-Object { $_.Name } | Where-Object { $_ -in 'android', 'web' } })
        if ($names.Count -ne 1) { [Console]::Error.WriteLine('accept: diga o alvo (-Target android|web) ou configure um só em guards.json → targets'); exit 2 }
        $Target = [string]$names[0]
    }
    $script:Tgt = $Target
    $cfg = if ($targets -and $targets.PSObject.Properties[$Target]) { $targets.$Target } else { $null }
    if ($Target -eq 'android') {
        . (Join-Path $PSScriptRoot 'targets/android.ps1'); $init = Initialize-Android $cfg; $health = { Test-AndroidHealth }; $repair = { Repair-Android }
        # v3.62.0: o localizador declarado (uiautomator | cdp).
        $script:Locator = Get-AndroidLocator
        if ($script:Locator -notin 'uiautomator', 'cdp') { [Console]::Out.WriteLine("accept: guards.json → targets.android.locator '$($script:Locator)' não existe — use ""uiautomator"" (app nativo, o padrão) ou ""cdp"" (app híbrido: WebView)"); exit 2 }
    }
    else { . (Join-Path $PSScriptRoot 'targets/web.ps1'); $init = Initialize-Web $cfg $Root; $health = { Test-WebHealth }; $repair = { Repair-Web } }
    if ($init) { [Console]::Out.WriteLine("accept: FALHA DE AMBIENTE ($Target) — $init"); exit 4 }

    # v3.63.1: com a pasta do accept — o sinal de vida do alvo preso lê o progress.json dela, e o -Kill reconhece o processo.
    $lock = Enter-TargetLock $Root $Target "accept $Task" 3 ((Get-VerifyDir $Root $Task) -replace '[\\/]verify[\\/]', '/accept/')
    if ($lock) { [Console]::Out.WriteLine("accept: FALHA DE AMBIENTE — $lock"); exit 4 }
    try { $code = Invoke-Accept $blocks $cfg $health $repair | Select-Object -Last 1 }
    finally {
        if ($Target -eq 'android' -and $script:Locator -eq 'cdp') { try { $null = Clear-AndroidCdpForwards } catch { } }   # v3.62.0
        Exit-TargetLock $Root
    }
} catch {
    [Console]::Error.WriteLine("accept: erro — $($_.Exception.Message)")
    exit 2
}
exit $code
