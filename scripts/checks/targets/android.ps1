# Adaptador Android do executor de cenários (v3.51, F1) e do pré-voo do alvo (D3). Dot-source: . targets\android.ps1
# Lê a árvore de acessibilidade (testTag exposto como resource-id) por uiautomator e age por adb. Sem nada de produto.
# v3.55.0 (C2): em app híbrido (WebView) o atributo HTML `id` chega como resource-id puro (sem "pacote:id/") — o -replace do
# Id abaixo o deixa como está, e o cenário localiza pelo mesmo id do Compose (testIds.attribute = "id"; standards/test-ids.md).
# Lições incorporadas do avaliador do benchmark: rolagem lenta e curta, esperar a animação parar antes de ler, coletar
# listas virtualizadas rolando até não aparecer item novo, tela em branco = falha de ambiente (não do app).
# Config (guards.json → targets.android): package, apk (opcional), avd (para o reparo), maxUptimeHours (padrão 24),
# repair (v3.53.2, opcional: comando PowerShell de reparo do projeto — emulador em container; vence o avd),
# serial (v3.53.5, opcional: o aparelho de trabalho, ex. "emulator-5554" — com ele todo adb vai a esse aparelho; v3.54.1:
# serial de rede "host:porta" é religado com adb connect no pré-voo e no reparo),
# memoryCmd + maxMemoryMB (v3.53.6, opcionais: memória do emulador acima do limite reprova o pré-voo e chama o reparo),
# freshStart (v3.53.6, padrão true com repair: o primeiro accept de cada Task reinicia o emulador pelo repair),
# seeds + seedTimeoutSec (v3.53.7: massa de dados por nome, passo "seed"), selectConfirm (v3.53.7: botão de confirmação
# do seletor no passo "select", expressão regular).

# v3.57.0 (protocolo de espera): todo comando de terceiros (reparo, memoryCmd) passa pelo Invoke-Bounded do lib.ps1. O adaptador
# declara a dependência em vez de supor que quem o carrega já carregou o lib.ps1.
if (-not (Get-Command Invoke-Bounded -ErrorAction SilentlyContinue)) { . (Join-Path $PSScriptRoot '..\lib.ps1') }

$script:AdCfg = $null; $script:Adb = $null; $script:Pkg = ''; $script:Nodes = @(); $script:IdCache = @{}; $script:EmptyDumps = 0
$script:Serial = ''; $script:AdbTimeout = ''

function Initialize-Android($Cfg) {
    $script:AdCfg = $Cfg
    $sdk = if ($env:ANDROID_HOME) { $env:ANDROID_HOME } elseif ($env:ANDROID_SDK_ROOT) { $env:ANDROID_SDK_ROOT } else { Join-Path $env:LOCALAPPDATA 'Android\Sdk' }
    $script:Sdk = $sdk
    $script:Adb = Join-Path $sdk 'platform-tools\adb.exe'
    if (-not (Test-Path -LiteralPath $script:Adb)) { $c = Get-Command adb -ErrorAction SilentlyContinue; if ($c) { $script:Adb = $c.Source } else { return "adb não encontrado (ANDROID_HOME ou PATH)" } }
    $script:Pkg = if ($Cfg -and $Cfg.package) { [string]$Cfg.package } else { '' }
    $script:Serial = if ($Cfg -and $Cfg.PSObject.Properties['serial'] -and $Cfg.serial) { [string]$Cfg.serial } else { '' }
    return $null
}
# v3.53.5 (sprint 5 do garden): toda chamada ao adb tem prazo. O "adb emu kill" do reparo ficou 81 min parado — dois
# emuladores (o AVD local e o do container) disputavam as portas 5554/5555 e o console não respondia — segurando a trava do
# alvo, e o run.ps1 next só mandava esperar. Estourou o prazo: o adb é encerrado, a saída parcial volta e $script:AdbTimeout
# guarda o comando ('' quando respondeu). Saída em UTF-8 (a árvore do uiautomator tem acento).
function Format-AdbArg([string]$A) { if ($A -eq '') { return '""' }; if ($A -notmatch '[\s"]') { return $A }; return '"' + ($A -replace '(\\*)"', '$1$1\"') + '"' }
function AdbT([int]$Sec, [string[]]$A) {
    $all = @(); if ($script:Serial) { $all += @('-s', $script:Serial) }; $all += @($A)
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $script:Adb; $psi.Arguments = (@($all | ForEach-Object { Format-AdbArg ([string]$_) }) -join ' ')
    $psi.UseShellExecute = $false; $psi.CreateNoWindow = $true; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true
    $psi.StandardOutputEncoding = [System.Text.Encoding]::UTF8; $psi.StandardErrorEncoding = [System.Text.Encoding]::UTF8
    $script:AdbTimeout = ''
    # protocolo: adb — prazo próprio (WaitForExit com limite), UTF-8, e só o processo do adb morre: o servidor do adb sobrevive.
    $p = [System.Diagnostics.Process]::Start($psi)
    $o = $p.StandardOutput.ReadToEndAsync(); $e = $p.StandardError.ReadToEndAsync()
    if (-not $p.WaitForExit($Sec * 1000)) {
        try { $p.Kill() } catch { }
        $script:AdbTimeout = "adb $(@($A) -join ' ') sem resposta em $Sec s"
        [Console]::Error.WriteLine("android: $($script:AdbTimeout) — encerrado")
    }
    [void]$p.WaitForExit(2000)
    $txt = ''
    try { if ($o.Wait(2000)) { $txt += $o.Result } } catch { }
    try { if ($e.Wait(2000)) { $txt += $e.Result } } catch { }
    $p.Dispose()
    return @($txt -split "`r?`n" | Where-Object { $_ -ne '' })
}
function Adb { AdbT 90 @($args | ForEach-Object { [string]$_ }) }
function Sh { Adb shell @args }
# Quem escuta nas portas do emulador (5554 console, 5555 adb) sem ser emulador do SDK local: "com.docker.backend (pid 24048)".
function Get-EmulatorPortOwner {
    try {
        $own = @(Get-NetTCPConnection -State Listen -LocalPort 5554, 5555 -ErrorAction Stop | Select-Object -ExpandProperty OwningProcess -Unique)
        $ext = @($own | ForEach-Object { Get-Process -Id $_ -ErrorAction SilentlyContinue } | Where-Object { $_ -and $_.ProcessName -notmatch '^(qemu-system|emulator)' })
        if ($ext.Count) { return (@($ext | ForEach-Object { "$($_.ProcessName) (pid $($_.Id))" }) -join ', ') }
    } catch { }
    return ''
}

# ---------- conexão de rede (v3.54.1) ----------
# Carta do sprint 5 do garden, item 1: serial de rede (host:porta, emulador em container) só existe enquanto o servidor do
# adb mantém a conexão — reiniciar o adb, suspender a máquina ou recriar o container a derruba sem aviso. O emulador segue no
# ar, o "adb devices" fica vazio e o pré-voo dizia "nenhum emulador"; o "wait-for-device" do reparo não religa serial de rede
# (180 s e "o aparelho não voltou"). A T-063 foi a 🔴 assim, com o container no ar havia 9 h. Agora o adaptador religa
# (adb connect) antes de reprovar e separa: porta recusada (emulador ou container fora) · conexão aceita com o aparelho
# offline (iniciando ou travado) · conexão perdida e religada (segue a conferência: tempo ligado, memória…).
function Test-NetworkSerial { return [bool]($script:Serial -match '^[^\s:]+:\d+$') }
function Connect-AndroidSerial {
    $keep = $script:Serial; $script:Serial = ''   # "adb connect" é do servidor: sem -s
    try { $o = ((@(AdbT 20 @('connect', $keep)) -join ' ') -replace '\s+', ' ').Trim() } finally { $script:Serial = $keep }
    if ($script:AdbTimeout) { return @{ Ok = $false; Out = $script:AdbTimeout } }
    return @{ Ok = ($o -match '(?i)\bconnected to\b' -and $o -notmatch '(?i)fail|cannot|unable|refused'); Out = $o }
}
# Estado do serial no "adb devices" ('device', 'offline', 'unauthorized'…; '' = ausente) e a lista dos que estão em 'device'.
function Get-SerialState {
    $all = @(AdbT 30 @('devices'))
    $st = @($all | Where-Object { ($_ -split '\t')[0] -eq $script:Serial } | ForEach-Object { ([string]($_ -split '\t')[1]).Trim() })
    return @{ All = $all; Dev = @($all | Where-Object { $_ -match '\tdevice$' }); State = $(if ($st.Count) { $st[0] } else { '' }) }
}
# Religa o serial de rede até ele ficar em 'device' ou o prazo acabar; $null = pronto, senão o último motivo.
function Wait-AndroidSerial([int]$Sec) {
    $t = Get-Date; $why = ''
    do {
        $c = Connect-AndroidSerial
        if ($c.Ok) { $s = Get-SerialState; if ($s.State -eq 'device') { return $null }; $why = "conexão aceita, aparelho '$(if ($s.State) { $s.State } else { 'ausente' })'" } else { $why = "adb connect: $($c.Out)" }
        Start-Sleep -Seconds 5
    } while (((Get-Date) - $t).TotalSeconds -lt $Sec)
    return $why
}

# ---------- pré-voo e reparo ----------
function Get-ScreenBytes { $n = ((Sh 'screencap -p | wc -c') -join '') -replace '\D', ''; if ($n) { [int64]$n } else { 0 } }
function Test-AndroidHealth {
    $all = @(AdbT 30 @('devices'))
    if ($script:AdbTimeout) { return "o adb não respondeu ($($script:AdbTimeout)): servidor do adb travado — adb kill-server e repita" }
    $dev = @($all | Where-Object { $_ -match '\tdevice$' })
    if ((Test-NetworkSerial) -and -not @($dev | Where-Object { ($_ -split '\t')[0] -eq $script:Serial }).Count) {
        $c = Connect-AndroidSerial
        if (-not $c.Ok) { return "o emulador (ou o container dele) está fora: a porta $($script:Serial) recusou o adb connect ($($c.Out))" }
        $s = Get-SerialState; $dev = $s.Dev
        if ($s.State -ne 'device') { return "a conexão do adb com $($script:Serial) foi aceita, mas o aparelho está '$(if ($s.State) { $s.State } else { 'ausente' })' no adb devices: emulador ainda iniciando ou travado" }
        [Console]::Out.WriteLine("android: a conexão do adb com $($script:Serial) tinha caído (emulador no ar, adb devices sem ele) — religada com adb connect")
    }
    if (-not $dev.Count) { return 'nenhum emulador ou aparelho conectado (adb devices)' }
    # v3.53.5: o mesmo emulador aparece duas vezes (emulator-5554 e localhost:5555 depois de um adb connect) — sem serial,
    # todo "adb shell" falha com "more than one device".
    if (-not $script:Serial -and $dev.Count -gt 1) { return "há $($dev.Count) aparelhos no adb ($(@($dev | ForEach-Object { ($_ -split '\t')[0] }) -join ', ')): declare o de trabalho em targets.android.serial no guards.json" }
    if ($script:Serial -and -not @($dev | Where-Object { ($_ -split '\t')[0] -eq $script:Serial }).Count) { return "o aparelho $($script:Serial) (targets.android.serial) não está no adb devices ($(@($dev | ForEach-Object { ($_ -split '\t')[0] }) -join ', '))" }
    if (((Sh getprop sys.boot_completed) -join '').Trim() -ne '1') { return 'o aparelho ainda não terminou de iniciar' }
    $bytes = Get-ScreenBytes
    if ($bytes -gt 0 -and $bytes -lt 12000) { return "a tela do aparelho está em branco (captura de $bytes bytes): o emulador não está desenhando" }
    $null = Adb shell uiautomator dump /sdcard/ui.xml
    if (((Adb exec-out cat /sdcard/ui.xml) -join '') -notmatch '<hierarchy') { return 'o uiautomator não devolve a árvore da tela (outro automatizador no aparelho ou emulador travado)' }
    $max = if ($script:AdCfg -and $script:AdCfg.maxUptimeHours) { [double]$script:AdCfg.maxUptimeHours } else { 24 }
    $up = (((Sh cat /proc/uptime) -join ' ') -split '\s+')[0] -as [double]
    if ($up -and $up / 3600 -gt $max) { return "o emulador está ligado há $([int]($up / 3600)) h (limite $max h): emulador ligado por muito tempo para de desenhar a tela" }
    $mem = Test-AndroidMemory
    if ($mem) { return $mem }
    return $null
}
# v3.53.6 (sprint 5 do garden, item 5): memória do emulador. O projeto declara em targets.android.memoryCmd um comando
# PowerShell que imprime a memória do processo do emulador (ex.: docker stats --no-stream --format "{{.MemUsage}}"
# horta-emulador → "2.31GiB / 7.6GiB") e em targets.android.maxMemoryMB o limite; acima dele o pré-voo reprova e o reparo
# declarado roda. O primeiro número da saída vale, com a unidade (KiB/MiB/GiB, KB/MB/GB; sem unidade = MB).
function ConvertTo-MemoryMB([string]$Text) {
    $m = [regex]::Match([string]$Text, '(?i)(\d+(?:[.,]\d+)?)(?![\d.,])\s*(kib|mib|gib|tib|kb|mb|gb|tb|b)?(?![a-z])')
    if (-not $m.Success) { return $null }
    $v = [double]::Parse(($m.Groups[1].Value -replace ',', '.'), [Globalization.CultureInfo]::InvariantCulture)
    switch ($m.Groups[2].Value.ToLower()) {
        { $_ -in 'kib', 'kb' } { return $v / 1024 }
        { $_ -in 'gib', 'gb' } { return $v * 1024 }
        { $_ -in 'tib', 'tb' } { return $v * 1024 * 1024 }
        'b' { return $v / 1048576 }
        default { return $v }
    }
}
# Comando do projeto num PowerShell filho com prazo (Invoke-Bounded, lib.ps1: saída em arquivo, prazo obrigatório); devolve a saída
# ('' quando estourou, com aviso). O memoryCmd é de terceiros: nunca por pipe.
function Invoke-CmdT([int]$Sec, [string]$Cmd) {
    $r = Invoke-Bounded '' $Cmd $Sec
    if ($r.timedOut) { [Console]::Error.WriteLine("android: '$Cmd' sem resposta em $Sec s — encerrado"); return '' }
    return $r.out
}
function Test-AndroidMemory {
    $c = $script:AdCfg
    $cmd = if ($c -and $c.PSObject.Properties['memoryCmd'] -and $c.memoryCmd) { [string]$c.memoryCmd } else { '' }
    $max = if ($c -and $c.PSObject.Properties['maxMemoryMB'] -and $c.maxMemoryMB) { [double]$c.maxMemoryMB } else { 0 }
    if (-not $cmd -or $max -le 0) { return $null }
    $out = Invoke-CmdT 60 $cmd
    $mb = ConvertTo-MemoryMB $out
    if ($null -eq $mb) { [Console]::Error.WriteLine("android: targets.android.memoryCmd não devolveu a memória ('$out') — conferência de memória pulada"); return $null }
    if ($mb -gt $max) { return "o emulador está com $([int]$mb) MB de memória (limite $max MB em targets.android.maxMemoryMB; saída '$out'): emulador inchado fica lento e perde a tela — reinício pedido" }
    return $null
}
# v3.53.6 (sprint 5 do garden, item 5, decisão do stakeholder): o emulador em container (targets.android.repair) é
# reiniciado SÓ no primeiro accept de cada Task — as repetições da mesma Task reaproveitam o emulador. A marca é
# fresh-start.json na pasta do accept da Task. targets.android.freshStart: false desliga; -NoRepair também.
function Test-AndroidFreshStartDue($Cfg, [string]$Dir, [bool]$NoRepair) {
    if ($NoRepair -or -not $Cfg) { return $false }
    if (-not ($Cfg.PSObject.Properties['repair'] -and $Cfg.repair)) { return $false }
    if ($Cfg.PSObject.Properties['freshStart'] -and $Cfg.freshStart -eq $false) { return $false }
    return -not (Test-Path -LiteralPath (Join-Path $Dir 'fresh-start.json'))
}
function Set-AndroidFreshStartDone([string]$Dir, [string]$Task) {
    New-Item -ItemType Directory -Force $Dir | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $Dir 'fresh-start.json'), ([ordered]@{ task = $Task; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); motivo = 'primeiro accept da Task: emulador reiniciado pelo reparo declarado' } | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false)))
}
function Repair-Android {
    # v3.53.2 (sprint 5 do garden): emulador fora do SDK local (em container Docker, por exemplo) — o reparo é o comando que
    # o projeto declara em targets.android.repair (ex.: "docker restart horta-emulador; adb connect localhost:5555"); o
    # guards.json é do stakeholder, então declarar o comando já é a autorização. Depois, a mesma espera do boot.
    $cmd = if ($script:AdCfg -and $script:AdCfg.PSObject.Properties['repair'] -and $script:AdCfg.repair) { [string]$script:AdCfg.repair } else { '' }
    if ($cmd) {
        $ErrorActionPreference = 'Continue'
        # Protocolo de espera (v3.57.0): o comando declarado é de terceiros, então passa pelo Invoke-Bounded (lib.ps1) — saída em
        # arquivo, prazo (targets.android.repairTimeoutSec, padrão 600 s) e espera pelo processo, não pelo pipe. -KeepDescendants:
        # o emulador e o daemon do adb que o comando deixa vivos de propósito não morrem com ele.
        $rt = if ($script:AdCfg.PSObject.Properties['repairTimeoutSec'] -and [int]$script:AdCfg.repairTimeoutSec -gt 0) { [int]$script:AdCfg.repairTimeoutSec } else { 600 }
        $r = Invoke-Bounded '' $cmd $rt -KeepDescendants
        if ($r.timedOut) { return "o reparo declarado (targets.android.repair) passou de $rt s e o shell dele foi encerrado (ambiente; ajuste targets.android.repairTimeoutSec ou confira se o comando termina)" }
        # Os filhos que o comando deixou vivos (emulador, adb) entram no registro: o -Kill os encerra, e só eles.
        if (@($r.kept).Count) { $null = Register-Detached (Get-Location).Path 'android' @($r.kept) $cmd }
        if ($r.exit -ne 0) { return "o reparo declarado (targets.android.repair) saiu com $($r.exit)`: $($r.out.Substring(0, [Math]::Min(200, $r.out.Length)))" }
        # v3.54.1: serial de rede — o wait-for-device não religa; o laço de adb connect, sim.
        if (Test-NetworkSerial) {
            $w = Wait-AndroidSerial 180
            if ($w) { return "o aparelho $($script:Serial) não voltou ao adb em 180 s depois do reparo declarado (targets.android.repair; último estado: $w)" }
        } else {
            AdbT 180 @('wait-for-device') | Out-Null
            if ($script:AdbTimeout) { return "o aparelho não voltou ao adb em 180 s depois do reparo declarado (targets.android.repair)" }
        }
    } else {
    $avd = if ($script:AdCfg -and $script:AdCfg.avd) { [string]$script:AdCfg.avd } else { '' }
    if (-not $avd) { return 'sem targets.android.avd nem targets.android.repair no guards.json: reinicie o emulador à mão' }
    $emu = Join-Path $script:Sdk 'emulator\emulator.exe'
    if (-not (Test-Path -LiteralPath $emu)) { return "emulador não encontrado em $emu (emulador em container? declare o comando em targets.android.repair)" }
    AdbT 20 @('emu', 'kill') | Out-Null; Start-Sleep -Seconds 3
    Get-Process qemu-system-* -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    # v3.53.5 (sprint 5 do garden): porta do emulador ocupada por outro processo (container Docker) — abrir o AVD local
    # punha dois emuladores nas mesmas portas: adb "offline" e o "emu kill" seguinte parado por 81 min.
    Start-Sleep -Seconds 2
    $other = Get-EmulatorPortOwner
    if ($other) { return "as portas do emulador (5554/5555) estão com $other — há um emulador fora do SDK local (container Docker?). O plugin não abre um segundo emulador: declare o reparo dele em targets.android.repair e tire targets.android.avd do guards.json" }
    # Na pasta do SDK: o emulador vive mais que o executor e não pode prender a pasta do projeto (v3.51.1).
    # protocolo: desprendido — o emulador deve sobreviver ao script; a prontidão é esperada logo abaixo, com prazo (240 s).
    $ep = Start-Process -FilePath $emu -ArgumentList @('-avd', $avd, '-no-snapshot', '-no-boot-anim', '-no-audio') -WorkingDirectory (Split-Path $emu) -WindowStyle Hidden -PassThru
    $null = Register-Detached (Get-Location).Path 'android' @($ep.Id) "emulator -avd $avd"   # o target.ps1 -Kill encerra só este
    }
    $t = Get-Date
    do { Start-Sleep -Seconds 5; $ok = ((AdbT 15 @('shell', 'getprop', 'sys.boot_completed')) -join '').Trim() -eq '1'; if (-not $ok -and (Test-NetworkSerial)) { $null = Connect-AndroidSerial } } while (-not $ok -and ((Get-Date) - $t).TotalSeconds -lt 240)
    if (-not $ok) { return "o emulador $(if ($cmd) { '(reparo declarado)' } else { $avd }) não terminou de iniciar em 240 s" }
    Start-Sleep -Seconds 25   # o launcher e os serviços do sistema ainda estão subindo depois do boot_completed
    return Test-AndroidHealth
}
# APK a instalar (v3.51.1): -Apk, senão targets.android.apk, senão o mais recente de <projeto>/**/build/outputs/apk/{release,debug}/.
# O pedido nem sempre fixa o applicationId e o guards.json é do stakeholder: o executor descobre o que o time construiu.
function Resolve-AndroidApk([string]$Root, [string]$Explicit) {
    if ($Explicit) { return $Explicit }
    if ($script:AdCfg -and $script:AdCfg.apk) { $p = Join-Path $Root ([string]$script:AdCfg.apk); if (Test-Path -LiteralPath $p) { return $p } }
    return (Get-LatestApk $Root)   # v3.57.0: a busca vive no lib.ps1 (o verify confere o APK sem carregar o adaptador)
}
# applicationId do APK (v3.51.1): aapt2 (build-tools mais novo) ou, sem ele, aapt dump badging.
function Get-ApkPackage([string]$Apk) {
    if (-not $Apk -or -not (Test-Path -LiteralPath $Apk)) { return '' }
    $bt = Join-Path $script:Sdk 'build-tools'
    $a2 = Get-ChildItem -Path $bt -Recurse -Filter 'aapt2.exe' -ErrorAction SilentlyContinue | Sort-Object FullName -Descending | Select-Object -First 1
    $ErrorActionPreference = 'Continue'
    if ($a2) { $p = ((& $a2.FullName dump packagename $Apk 2>$null) -join '').Trim(); if ($p -match '^[\w.]+$') { return $p } }
    $a1 = Get-ChildItem -Path $bt -Recurse -Filter 'aapt.exe' -ErrorAction SilentlyContinue | Sort-Object FullName -Descending | Select-Object -First 1
    if ($a1) { $m = [regex]::Match(((& $a1.FullName dump badging $Apk 2>$null) -join "`n"), "package: name='([^']+)'"); if ($m.Success) { return $m.Groups[1].Value } }
    return ''
}
function Set-AndroidPackage([string]$Pkg) { if ($Pkg) { $script:Pkg = $Pkg } }
function Install-AndroidApk([string]$Apk) {
    if (-not $Apk) { return $null }
    if (-not (Test-Path -LiteralPath $Apk)) { return "APK não existe: $Apk" }
    if ($script:Pkg) { Adb uninstall $script:Pkg | Out-Null }
    $r = (AdbT 600 @('install', '-r', $Apk)) -join ' '
    if ($r -notmatch 'Success') { return "instalação do APK falhou: $r" }
    return $null
}

# ---------- árvore da tela ----------
function Dump {
    for ($i = 0; $i -lt 4; $i++) {
        try {
            $null = Adb shell uiautomator dump /sdcard/ui.xml
            $xml = (Adb exec-out cat /sdcard/ui.xml) -join "`n"
            if ($xml -match '<hierarchy') {
                $d = New-Object Xml.XmlDocument; $d.LoadXml($xml.Substring($xml.IndexOf('<?xml')))
                $script:Nodes = @($d.SelectNodes('//node') | ForEach-Object {
                    $b = [regex]::Match($_.GetAttribute('bounds'), '\[(\d+),(\d+)\]\[(\d+),(\d+)\]')
                    [pscustomobject]@{ Id = $_.GetAttribute('resource-id') -replace '^.*:id/', ''; Text = $_.GetAttribute('text'); Desc = $_.GetAttribute('content-desc')
                        Checked = ($_.GetAttribute('checked') -eq 'true'); X1 = [int]$b.Groups[1].Value; Y1 = [int]$b.Groups[2].Value; X2 = [int]$b.Groups[3].Value; Y2 = [int]$b.Groups[4].Value } })
                $script:EmptyDumps = 0
                return $script:Nodes
            }
        } catch { }
        Start-Sleep -Milliseconds 700
    }
    $script:Nodes = @(); $script:EmptyDumps++
    if ($script:EmptyDumps -ge 3) { $b = Get-ScreenBytes; if ($b -gt 0 -and $b -lt 12000) { throw 'AMBIENTE: a tela do aparelho está em branco e o uiautomator não devolve a árvore' } }
    return $script:Nodes
}
function Find([string]$Id) { $script:Nodes | Where-Object { $_.Id -eq $Id } | Select-Object -First 1 }
function Has([string]$Id) { [void](Dump); [bool](Find $Id) }
function NodeText($n) {
    if (-not $n) { return $null }; if ($n.Text) { return $n.Text }
    $m = $script:Nodes | Where-Object { $_.Text -and $_.X1 -ge $n.X1 - 2 -and $_.X2 -le $n.X2 + 2 -and $_.Y1 -ge $n.Y1 - 2 -and $_.Y2 -le $n.Y2 + 2 } | Select-Object -First 1
    if ($m) { $m.Text } else { $n.Desc }
}
# Volta ao topo e ESPERA a rolagem parar: ler no meio da animação perde os primeiros itens (medido no avaliador).
function ScrollTop {
    foreach ($i in 1..6) { Sh input swipe 360 600 360 1400 250 | Out-Null; Start-Sleep -Milliseconds 250 }
    Start-Sleep -Milliseconds 1200
}
function WaitFor([string]$Id, [int]$Sec = 20) { $t = Get-Date; do { if (Has $Id) { return $true }; Start-Sleep -Milliseconds 400 } while (((Get-Date) - $t).TotalSeconds -lt $Sec); $false }
function Reach([string]$Id, [int]$Sec = 4) {
    if (WaitFor $Id $Sec) { return $true }   # v3.51.1: a espera inteira antes de rolar (primeira abertura depois de instalar é lenta)
    foreach ($i in 1..12) { Sh input swipe 360 600 360 1250 800 | Out-Null; Start-Sleep -Milliseconds 350; if (Has $Id) { return $true } }
    foreach ($i in 1..40) { Sh input swipe 360 1250 360 750 1100 | Out-Null; Start-Sleep -Milliseconds 350; if (Has $Id) { return $true } }
    $false
}
function TapNode($n) { Sh input tap ([int](($n.X1 + $n.X2) / 2)) ([int](($n.Y1 + $n.Y2) / 2)) | Out-Null; Start-Sleep -Milliseconds 500 }
function Tap([string]$Id) { if (-not (Reach $Id 6)) { throw "tag não encontrada: $Id$(Get-ScreenHint)" }; Start-Sleep -Milliseconds 300; [void](Dump); TapNode (Find $Id) }
function TextOf([string]$Id) { [void](Dump); $n = Find $Id; if (-not $n -and (Reach $Id 1)) { $n = Find $Id }; NodeText $n }
# Lista completa de ids com um prefixo, na ordem: lista rolável só mostra os itens visíveis na árvore.
function CollectIds([string]$Prefix) {
    if ($script:IdCache.ContainsKey($Prefix)) { return @($script:IdCache[$Prefix]) }
    ScrollTop
    $seen = New-Object Collections.Generic.List[string]; $still = 0
    foreach ($i in 1..60) {
        [void](Dump); $vis = @($script:Nodes | Where-Object { $_.Id -like "$Prefix*" } | Sort-Object Y1, X1 | ForEach-Object { $_.Id.Substring($Prefix.Length) }); $new = 0
        foreach ($v in $vis) { if (-not $seen.Contains($v)) { $seen.Add($v); $new++ } }
        if ($new -eq 0) { $still++ } else { $still = 0 }; if ($still -ge 2) { break }
        Sh input swipe 360 1250 360 750 1100 | Out-Null; Start-Sleep -Milliseconds 500
    }
    $script:IdCache[$Prefix] = @($seen)
    @($seen)
}
# v3.53.7 (encadeamento do sprint 5 do garden): o caso central da Task de canteiros não tinha cenário no aparelho porque a
# linguagem não escolhia opção num combo. "select <id> = <opção>": toca o controle, espera a opção pelo texto visível (fora
# do próprio controle, que pode mostrar o valor atual), rola a lista aberta se preciso e toca; se o seletor ficou aberto
# com botão de confirmação (diálogo com OK), confirma. targets.android.selectConfirm troca a expressão do botão.
function SelectOption([string]$Id, [string]$Opt) {
    if (-not (Reach $Id 6)) { throw "tag não encontrada: $Id$(Get-ScreenHint)" }
    Start-Sleep -Milliseconds 300; [void](Dump); $c = Find $Id; TapNode $c; Start-Sleep -Milliseconds 500
    $outside = { param($n) -not ($n.X1 -ge $c.X1 -and $n.X2 -le $c.X2 -and $n.Y1 -ge $c.Y1 -and $n.Y2 -le $c.Y2) }
    $pick = { [void](Dump); $script:Nodes | Where-Object { ($_.Text -eq $Opt -or $_.Desc -eq $Opt) -and (& $outside $_) } | Select-Object -First 1 }
    $o = $null; $t = Get-Date
    do { $o = & $pick; if ($o) { break }; Start-Sleep -Milliseconds 400 } while (((Get-Date) - $t).TotalSeconds -lt 6)
    if (-not $o) { foreach ($i in 1..15) { Sh input swipe 360 1100 360 700 600 | Out-Null; Start-Sleep -Milliseconds 400; $o = & $pick; if ($o) { break } } }
    if (-not $o) { throw "opção '$Opt' não apareceu depois de tocar $Id$(Get-ScreenHint)" }
    TapNode $o
    $cre = if ($script:AdCfg -and $script:AdCfg.PSObject.Properties['selectConfirm'] -and $script:AdCfg.selectConfirm) { [string]$script:AdCfg.selectConfirm } else { '^(OK|Ok|Confirmar|Concluir|Pronto|Aplicar|Done)$' }
    if (& $pick) { $ok = $script:Nodes | Where-Object { $_.Text -match $cre -or $_.Desc -match $cre } | Select-Object -First 1; if ($ok) { TapNode $ok } }
}
function SetSlider([string]$Id, [double]$Value, [double]$Min, [double]$Max) {
    if (-not (Reach $Id 6)) { throw "controle deslizante não encontrado: $Id" }; $n = Find $Id
    # a trilha começa ~30 px para dentro do nó: tocar na borda não muda o valor
    $w = $n.X2 - $n.X1; $x = [int]($n.X1 + 30 + ($w - 60) * (($Value - $Min) / ($Max - $Min))); $y = [int](($n.Y1 + $n.Y2) / 2)
    Sh input tap $x $y | Out-Null; Start-Sleep -Milliseconds 700
}
# v3.53.3 (sprint 5 do garden): o launch só trazia o app à frente NA TELA EM QUE ELE FICOU (monkey) — cada cenário começava
# onde o anterior parou (SC-127 abriu em Administração > Alertas, deixada pelo SC-193) — e, sem o app na frente, apertava
# HOME e saía calado (SC-146 rodou na tela inicial do Android). Todo passo dava "tag não encontrada", lido pelo time como
# "APK sem os ids": 3 GAPs ao Arquiteto, 8 rodadas da QA e cenário tirado da prova. Agora o app fecha e abre do zero (os
# dados ficam — quem apaga é o reset), espera ficar na frente e, se não ficar, o cenário para como AMBIENTE (exit 4).
function Get-FocusLine { @(Sh dumpsys window | Where-Object { $_ -match 'mCurrentFocus=' } | ForEach-Object { $_.Trim() }) | Select-Object -First 1 }
function Test-AppOnTop { $f = [string](Get-FocusLine); return [bool]($script:Pkg -and $f -match [regex]::Escape("$($script:Pkg)/")) }
# Onde a tela estava quando o passo falhou: a janela em foco, os ids e os primeiros textos visíveis — para a falha dizer se
# o app estava em outra tela (ambiente/cenário) ou se a tela certa não tinha o elemento (app).
function Get-ScreenHint {
    $f = [string](Get-FocusLine); $w = if ($f -match 'u0 ([^ }]+)\}') { $Matches[1] } elseif ($f) { ($f -replace '^.*mCurrentFocus=', '') } else { '?' }
    $ids = @($script:Nodes | Where-Object { $_.Id } | ForEach-Object { $_.Id } | Select-Object -Unique -First 8)
    $tx = @($script:Nodes | Where-Object { $_.Text } | ForEach-Object { $t = ([string]$_.Text).Trim(); if ($t.Length -gt 30) { $t.Substring(0, 30) + '…' } else { $t } } | Where-Object { $_ } | Select-Object -Unique -First 4)
    " [tela: $w · ids: $(if ($ids.Count) { $ids -join ', ' } else { 'nenhum' }) · textos: $(if ($tx.Count) { $tx -join ' / ' } else { 'nenhum' })]"
}
function Launch {
    if (-not $script:Pkg) { throw 'AMBIENTE: sem o pacote do app (targets.android.package ou um APK construído)' }
    Sh am force-stop $script:Pkg | Out-Null; Start-Sleep -Milliseconds 700
    foreach ($i in 1..3) {
        Sh monkey -p $script:Pkg -c android.intent.category.LAUNCHER 1 | Out-Null
        $t = Get-Date
        do { Start-Sleep -Milliseconds 800; if (Test-AppOnTop) { Start-Sleep -Milliseconds 1000; return } } while (((Get-Date) - $t).TotalSeconds -lt 15)
    }
    $f = [string](Get-FocusLine)
    # Janela de erro do próprio app (fecha ao abrir, não responde) é defeito do app, não do alvo.
    if ($f -match '(?i)Application (Error|Not Responding)' -and $f -match [regex]::Escape($script:Pkg)) { throw "o app $($script:Pkg) fechou ou travou ao abrir ($f)" }
    throw "AMBIENTE: o app $($script:Pkg) não ficou na frente em 3 aberturas de 15 s (foco: $(if ($f) { $f } else { 'nenhum' })) — alvo travado, diálogo do sistema ou outro automatizador; não é o cenário"
}
function SetClock([string]$At) {
    $when = [datetime]::ParseExact($At, 'yyyy-MM-dd HH:mm', [Globalization.CultureInfo]::InvariantCulture)
    Adb root | Out-Null; Start-Sleep -Milliseconds 800; AdbT 60 @('wait-for-device') | Out-Null
    Sh settings put global auto_time 0 | Out-Null; Sh settings put global auto_time_zone 0 | Out-Null
    Sh ("date " + $when.ToString('MMddHHmmyyyy') + ".00") | Out-Null; Start-Sleep -Milliseconds 500
}
function Save-AndroidShot([string]$Path) { Sh screencap -p /sdcard/s.png | Out-Null; Adb pull /sdcard/s.png $Path | Out-Null }

# Um passo da linguagem de cenário. Ação que muda a tela esvazia o cache de listas.
function Invoke-AndroidStep([string]$Verb, [string]$Rest, [string]$ShotBase) {
    if ($Verb -notmatch '^(assert-|shot$)') { $script:IdCache = @{} }
    switch ($Verb) {
        'reset' { if ($script:Pkg) { Sh pm clear $script:Pkg | Out-Null } }
        # v3.53.3: launch, open e restart abrem do zero, na tela inicial do app (Launch fecha antes).
        'launch' { Launch }
        'restart' { Launch }
        'open' { Launch }
        'back' { Sh input keyevent 4 | Out-Null; Start-Sleep -Milliseconds 600 }
        'clock' { SetClock $Rest }
        'wait' { Start-Sleep -Seconds ([int]$Rest) }
        'font-scale' { Sh settings put system font_scale ([double]$Rest) | Out-Null; Start-Sleep -Milliseconds 800 }
        'tap' { Tap $Rest }
        'type' { $k, $v = $Rest -split '\s*=\s*', 2; Tap $k; Sh input text ($v -replace ' ', '%s') | Out-Null; Start-Sleep -Milliseconds 400; Sh input keyevent 111 | Out-Null }
        'select' { $k, $v = $Rest -split '\s*=\s*', 2; SelectOption $k.Trim() ([string]$v).Trim() }
        # v3.53.7: massa de dados — o comando do projeto em targets.android.seeds.<nome>, com o aparelho e o pacote no ambiente.
        'seed' { $e = Invoke-TargetSeed $(if ($Root) { $Root } else { (Get-Location).Path }) 'android' $script:AdCfg $Rest.Trim() @{ ACCEPT_SERIAL = $script:Serial; ACCEPT_PACKAGE = $script:Pkg }; if ($e) { throw "AMBIENTE: $e" } }
        'slider' { $p = $Rest -split '\s+'; SetSlider $p[0] ([double]$p[1]) ([double]$p[2]) ([double]$p[3]) }
        'shot' { Save-AndroidShot "$ShotBase-$Rest.png" }
        'assert-text' { $k, $v = $Rest -split '\s*=\s*', 2; $a = TextOf $k; if ($a -ne $v) { throw "esperado '$v', obtido '$a' em $k" } }
        'assert-contains' { $k, $v = $Rest -split '\s*=\s*', 2; $a = TextOf $k; if (-not ($a -like "*$v*")) { throw "'$a' não contém '$v' em $k" } }
        'assert-exists' { if (-not (Reach $Rest 8)) { throw "tag ausente: $Rest$(Get-ScreenHint)" } }
        'assert-absent' { if (Has $Rest) { throw "tag presente (esperada ausente): $Rest" } }
        'assert-checked' { $k, $v = $Rest -split '\s*=\s*', 2; if (-not (Reach $k 4)) { throw "tag ausente: $k" }; $c = [bool](Find $k).Checked; if ($c -ne ($v -match '^(true|sim|1)$')) { throw "$k marcado = $c, esperado $v" } }
        'assert-count' { $k, $v = $Rest -split '\s*=\s*', 2; $ids = @(CollectIds $k); if ($ids.Count -ne [int]$v) { throw "esperado $v itens '$k*' na lista inteira, obtido $($ids.Count): [$($ids -join ',')]" } }
        'assert-order' { $k, $v = $Rest -split '\s*=\s*', 2; $got = @(CollectIds $k); $want = @($v -split '\s*,\s*'); $idx = @($want | ForEach-Object { [array]::IndexOf($got, $_) }); if ($idx -contains -1 -or ($idx -join ',') -ne (($idx | Sort-Object) -join ',')) { throw "ordem diferente: esperado [$v], lista [$($got -join ',')]" } }
        default { throw "passo '$Verb' não existe no alvo android" }
    }
}
