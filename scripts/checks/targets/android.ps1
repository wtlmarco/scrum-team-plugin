# Adaptador Android do executor de cenários (v3.51, F1) e do pré-voo do alvo (D3). Dot-source: . targets\android.ps1
# Lê a árvore de acessibilidade (testTag exposto como resource-id) por uiautomator e age por adb. Sem nada de produto.
# v3.62.0: em app híbrido (WebView) o id HTML NÃO chega ao uiautomator nas WebViews atuais (medido: Android 15, WebView 124 —
# resource-id vazio, o aria-label vira text). Com targets.android.locator = "cdp", os verbos de tela vão ao android-cdp.js
# pelo DevTools da WebView (adb forward de porta livre) e o ciclo de vida continua aqui; com "uiautomator" (padrão), um app
# cuja tela é uma WebView sem nenhum id do app é CONFIGURAÇÃO DO ALVO antes do 1º cenário (accept.ps1). Semântica dos verbos:
# standards/scenario-language.md. Config: locator, cdp { pageUrl, readyExpr, readyTimeoutSec, failExpr, hiddenScopes,
# stepTimeoutSec, callTimeoutMs } — abaixo, "localizador CDP".
# Lições incorporadas do avaliador do benchmark: rolagem lenta e curta, esperar a animação parar antes de ler, coletar
# listas virtualizadas rolando até não aparecer item novo, tela em branco = falha de ambiente (não do app).
# Config (guards.json → targets.android): package, apk (opcional; v3.57.1: máscara no nome, vale o mais novo), apkSources
# (opcional, v3.57.1: fontes que entram no APK — no app híbrido, o código web — para a idade do APK), avd (para o reparo), maxUptimeHours (padrão 24),
# repair (v3.53.2, opcional: comando PowerShell de reparo do projeto — emulador em container; vence o avd),
# serial (v3.53.5, opcional: o aparelho de trabalho, ex. "emulator-5554" — com ele todo adb vai a esse aparelho; v3.54.1:
# serial de rede "host:porta" é religado com adb connect no pré-voo e no reparo),
# memoryCmd + maxMemoryMB (v3.53.6, opcionais: memória do emulador acima do limite reprova o pré-voo e chama o reparo),
# freshStart (v3.53.6, padrão true com repair: o primeiro accept de cada Task reinicia o emulador pelo repair),
# freshStartMinutes (v3.58.4, padrão 30: emulador ligado há menos que isso já conta como reiniciado — sem segundo boot),
# releaseBetweenTasks (v3.58.4, padrão true: o run.ps1 start desliga o emulador local que sobrou da Task anterior),
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
# v3.58.4 (sprint 6 do garden, falta de memória da T-081): emulador religado há pouco já começa limpo. Com a liberação entre
# Tasks (Stop-AndroidEmulator), o dev sobe o emulador (target.ps1 -Repair) para instalar o APK pelo comando do projeto antes do
# primeiro accept; reiniciá-lo de novo ali seria um segundo boot (~2 min) sem ganho de memória. Minutos ligado, ou $null.
function Get-AndroidUptimeMin {
    $up = (((Sh cat /proc/uptime) -join ' ') -split '\s+')[0] -as [double]
    if ($script:AdbTimeout -or -not $up) { return $null }
    return [int][Math]::Floor($up / 60)
}
function Get-AndroidFreshMinutes($Cfg) {
    if ($Cfg -and $Cfg.PSObject.Properties['freshStartMinutes'] -and $null -ne $Cfg.freshStartMinutes) { return [int]$Cfg.freshStartMinutes }
    return 30
}
# v3.58.4: liberar o emulador quando a construção não precisa dele. No sprint 6 do garden, o emulador ficou ligado das 11:55
# às 14:01 sem accept nenhum (4,1 GB reservados), ao lado da suíte do Karma (pico medido de 6,6 GB) e da VM do Docker do
# build do APK; o Claude Code encerrou o verify full da T-081 por memória baixa no teste 2925 de 2926. O primeiro accept de
# cada Task já reinicia o emulador (freshStart): o que fica ligado entre uma Task e outra é jogado fora sem ter servido.
# Só o emulador LOCAL do serial (o dono da porta do console: emulator-5554 → 5554), e só com reparo declarado (repair ou avd):
# o plugin precisa saber religá-lo. Serial de rede (container) não se libera daqui — o container é do projeto.
function Get-AndroidReleaseBlock($Cfg) {
    if (Test-NetworkSerial) { return "emulador em container (serial de rede $($script:Serial)): o plugin não o desliga — o container é do projeto" }
    $hasRepair = $Cfg -and $Cfg.PSObject.Properties['repair'] -and $Cfg.repair
    $hasAvd = $Cfg -and $Cfg.PSObject.Properties['avd'] -and $Cfg.avd
    if (-not ($hasRepair -or $hasAvd)) { return 'sem targets.android.repair nem avd no guards.json: o plugin não saberia religar o emulador, então não o desliga' }
    return $null
}
function Get-AndroidConsolePort { if ($script:Serial -match '^emulator-(\d+)$') { return [int]$Matches[1] }; return 5554 }
# Processos do emulador local: o dono da porta do console (qemu-system ou emulator) e o emulator.exe pai dele.
function Get-LocalEmulatorProcs {
    $port = Get-AndroidConsolePort
    $ids = @()
    try { $ids = @(Get-NetTCPConnection -State Listen -LocalPort $port -ErrorAction Stop | Select-Object -ExpandProperty OwningProcess -Unique) } catch { }
    $out = @()
    foreach ($id in $ids) {
        $c = Get-CimInstance Win32_Process -Filter "ProcessId=$id" -ErrorAction SilentlyContinue
        if (-not $c -or $c.Name -notmatch '^(qemu-system|emulator)') { continue }
        $out += $c
        $par = Get-CimInstance Win32_Process -Filter "ProcessId=$([int]$c.ParentProcessId)" -ErrorAction SilentlyContinue
        if ($par -and $par.Name -match '^emulator') { $out += $par }
    }
    return @($out | Sort-Object ProcessId -Unique)
}
# Desliga o emulador local: "adb emu kill" (20 s) e, se ele não sair em 20 s, encerra a árvore. @{ Stopped; MB; Text }.
function Stop-AndroidEmulator {
    $procs = @(Get-LocalEmulatorProcs)
    if (-not $procs.Count) { return @{ Stopped = $false; MB = 0; Text = "nenhum emulador local na porta $(Get-AndroidConsolePort)" } }
    $mb = [int]((($procs | Measure-Object PrivatePageCount -Sum).Sum) / 1MB)
    $null = AdbT 20 @('emu', 'kill')
    $t = Get-Date
    do { Start-Sleep -Seconds 2; $alive = @($procs | Where-Object { Get-Process -Id ([int]$_.ProcessId) -ErrorAction SilentlyContinue }) } while ($alive.Count -and ((Get-Date) - $t).TotalSeconds -lt 20)
    foreach ($a in $alive) { $null = Stop-ProcessTree ([int]$a.ProcessId) }
    return @{ Stopped = $true; MB = $mb; Text = "emulador da porta $(Get-AndroidConsolePort) desligado ($mb MB)$(if ($alive.Count) { ' — não saiu pelo adb emu kill em 20 s, encerrado' })" }
}
function Set-AndroidFreshStartDone([string]$Dir, [string]$Task, [string]$Why = 'primeiro accept da Task: emulador reiniciado pelo reparo declarado') {
    New-Item -ItemType Directory -Force $Dir | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $Dir 'fresh-start.json'), ([ordered]@{ task = $Task; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); motivo = $Why } | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false)))
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
    # v3.57.1 (note.md item 4): targets.android.apk aceita máscara no nome (o mais novo que casa) — Find-ConfiguredApk no lib.ps1.
    if ($script:AdCfg -and $script:AdCfg.apk) { $p = Find-ConfiguredApk $Root ([string]$script:AdCfg.apk); if ($p) { return $p } }
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
    # v3.57.2 (note.md item 19, ocorrência 3 do sprint 5 do garden — D-5): o accept desinstalava o app antes de instalar, e cada
    # accept apagava a base do app; o projeto proibiu o accept nas Tasks por isso. Agora instala POR CIMA (install -r mantém os
    # dados) e só desinstala quando o Android recusa a atualização — assinatura diferente ou versão menor —, avisando que a
    # base foi apagada. Os cenários que precisam de base limpa já têm o verbo reset (pm clear).
    $script:InstallNote = ''
    $r = (AdbT 600 @('install', '-r', $Apk)) -join ' '
    if ($r -match 'Success') { return $null }
    if ($script:Pkg -and $r -match 'INSTALL_FAILED_UPDATE_INCOMPATIBLE|INSTALL_FAILED_VERSION_DOWNGRADE|signatures do not match') {
        $why = ([regex]::Match($r, 'INSTALL_FAILED_\w+|signatures do not match')).Value
        Adb uninstall $script:Pkg | Out-Null
        $r = (AdbT 600 @('install', '-r', $Apk)) -join ' '
        if ($r -match 'Success') { $script:InstallNote = "o APK não instalava por cima ($why): o app foi desinstalado e reinstalado — a base do app no aparelho foi apagada"; return $null }
    }
    return "instalação do APK falhou: $r"
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
                    [pscustomobject]@{ Id = $_.GetAttribute('resource-id') -replace '^.*:id/', ''; Text = $_.GetAttribute('text'); Desc = $_.GetAttribute('content-desc'); Class = $_.GetAttribute('class')
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
# O id é o resource-id (standards/test-ids.md §4: texto, content-desc e aria-label não são seletor). v3.62.0: saiu o recurso
# ao content-desc da v3.57.1 — o aria-label da WebView chega como text, não como content-desc, e espelhar o id nele trocava o
# texto visível (medido em campo); app híbrido localiza pelo locator "cdp".
function Find([string]$Id) { $script:Nodes | Where-Object { $_.Id -eq $Id } | Select-Object -First 1 }
# v3.62.0: a tela do app é uma WebView e nenhum id do app chegou à árvore — só os do próprio Android. Com o uiautomator, nenhum
# cenário vai achar id nenhum: é a configuração do alvo (locator "cdp"), não o app, o estado de partida nem o ambiente.
$script:FrameworkIds = 'action_bar_root', 'content', 'statusBarBackground', 'navigationBarBackground', 'decor_content_parent', 'action_bar_container', 'action_bar', 'action_context_bar', 'parentPanel', 'action_mode_bar_stub'
function Test-HybridWithoutIds($Nodes) {
    $n = @($Nodes)
    if (-not @($n | Where-Object { $_.Class -eq 'android.webkit.WebView' }).Count) { return $false }
    return -not @($n | Where-Object { $_.Id -and $script:FrameworkIds -notcontains $_.Id }).Count
}
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
# v3.65.2: relê a condição até ela valer ou 5 s (o app atualiza a tela depois do toque). $true = valeu.
function Wait-Assert([scriptblock]$Check, [int]$GapMs = 400) {
    $t = Get-Date
    do { if (& $Check) { return $true }; Start-Sleep -Milliseconds $GapMs } while (((Get-Date) - $t).TotalSeconds -lt 5)
    return [bool](& $Check)
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
# v3.62.0 (standards/scenario-language.md): "type" SUBSTITUI o valor. O adb input text insere no cursor — no campo que já tinha
# texto, o valor final misturava os dois (medido em campo: "semeio N" + digitado + "OVA"). Agora: toca, vai ao fim do campo
# (MOVE_END), apaga o texto atual (DEL × tamanho lido na árvore) e digita. O adb input text não envia caractere fora do ASCII:
# FALHOU com o motivo, nunca o texto corrompido calado.
function TypeText([string]$Id, [string]$Value) {
    if ($Value -match '[^\x20-\x7E]') { throw "o uiautomator não digita fora do ASCII ('$Value' em $Id) — app híbrido: targets.android.locator = ""cdp"" digita qualquer texto" }
    Tap $Id
    [void](Dump); $cur = [string](NodeText (Find $Id)); $n = $cur.Length
    if ($n -gt 0) { Sh input keyevent 123 | Out-Null; Sh ('input keyevent ' + ((1..$n | ForEach-Object { '67' }) -join ' ')) | Out-Null }
    if ($Value) { Sh input text ($Value -replace ' ', '%s') | Out-Null }
    Start-Sleep -Milliseconds 400; Sh input keyevent 111 | Out-Null
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
# v3.65.3 (garden SC-204): o app que não trata a troca de fonte tem a tela recriada pelo Android, e a WebView carrega uma página
# nova. Medido no aparelho do garden: a página velha ainda respondia o readyExpr como pronta até 1,1–1,3 s depois do comando, e o
# passo esperava 0,8 s — o "ready" seguinte passava na página velha, e o toque seguinte caía no splash ("coberto"). Agora, com
# o valor mudado e o DevTools ligado, espera até 3 s a lista de páginas do /json mudar; o ready do accept espera a nova. Valor
# igual ao atual não recria nada e não espera.
function Get-AndroidCdpPageIds {
    if (-not $script:CdpPort) { return $null }
    try { return @((Invoke-RestMethod -Uri "http://127.0.0.1:$($script:CdpPort)/json/list" -TimeoutSec 2) | Where-Object { $_.type -eq 'page' } | ForEach-Object { [string]$_.id } | Sort-Object) -join ',' } catch { return $null }
}
function Set-AndroidFontScale([double]$Scale) {
    $cur = ((Sh settings get system font_scale) -join '').Trim()
    $same = $false; $c = 0.0
    if ([double]::TryParse($cur, [Globalization.NumberStyles]::Float, [Globalization.CultureInfo]::InvariantCulture, [ref]$c)) { $same = [math]::Abs($c - $Scale) -lt 0.001 }
    $before = if ($same) { $null } else { Get-AndroidCdpPageIds }
    Sh settings put system font_scale $Scale.ToString([Globalization.CultureInfo]::InvariantCulture) | Out-Null
    Start-Sleep -Milliseconds 800
    if ($same -or $null -eq $before) { return }
    $t = [datetime]::UtcNow
    while (([datetime]::UtcNow - $t).TotalMilliseconds -lt 2200) {
        $now = Get-AndroidCdpPageIds
        if ($null -ne $now -and $now -ne $before) { return }
        Start-Sleep -Milliseconds 200
    }
}
function Save-AndroidShot([string]$Path) { Sh screencap -p /sdcard/s.png | Out-Null; Adb pull /sdcard/s.png $Path | Out-Null }

# ---------- v3.63.1 · identidade do app instalado, registro do aparelho e sinal da falha ----------
# Sprint 6 do projeto piloto (18/11): o -Resume leu "apk:?" — o APK foi instalado pelo comando do projeto (build num volume do
# Docker), sem arquivo local para o hash — e rodou todos os cenários. A identidade agora é a do app INSTALADO no aparelho: o
# SHA-1 do base.apk (pm path → sha1sum; igual ao hash do arquivo local quando foi ele o instalado). Sem sha1sum no aparelho,
# a versão e a hora da última instalação (mudam a cada install). '' = não deu para ler.
function Get-AndroidInstalledIdentity {
    if (-not $script:Pkg) { return '' }
    $paths = @(Sh pm path $script:Pkg | ForEach-Object { [string]$_ } | Where-Object { $_ -match '^package:\S+\.apk\s*$' } | ForEach-Object { ($_ -replace '^package:', '').Trim() })
    $base = @(@($paths | Where-Object { $_ -match '/base\.apk$' }) + $paths) | Select-Object -First 1
    if ($base) {
        foreach ($tool in 'sha1sum', 'toybox sha1sum') {
            $o = ((Sh "$tool $base") -join ' ').Trim()
            if ($o -match '^([0-9a-f]{40})\b') { return $Matches[1].Substring(0, 12) }
        }
    }
    $d = (@(Sh dumpsys package $script:Pkg) -join "`n")
    $vc = [regex]::Match($d, 'versionCode=(\d+)'); $lu = [regex]::Match($d, 'lastUpdateTime=([\d\- :]+)')
    if ($vc.Success -and $lu.Success) { return "v$($vc.Groups[1].Value)@$(($lu.Groups[1].Value.Trim()) -replace '\D', '')" }
    return ''
}
# O registro do aparelho de UM cenário: limpo no começo (main, system e crash), gravado na falha — o veredito do diagnóstico
# tem prova (crash, ANR, WebView que caiu) em vez de só a captura.
function Clear-AndroidLog { $null = AdbT 15 @('logcat', '-c') }
function Save-AndroidLog([string]$Path) {
    $main = @(AdbT 30 @('logcat', '-d', '-v', 'threadtime', '-t', '3000'))
    $crash = @(AdbT 15 @('logcat', '-d', '-b', 'crash', '-v', 'threadtime'))
    try {
        New-Item -ItemType Directory -Force (Split-Path $Path) | Out-Null
        [System.IO.File]::WriteAllText($Path, ("# logcat -d (até 3000 linhas, desde o começo do cenário)`n" + ($main -join "`n") + "`n`n# logcat -b crash`n" + ($crash -join "`n") + "`n"), (New-Object System.Text.UTF8Encoding($false)))
    } catch { }
    return @{ Main = $main; Crash = $crash }
}
# O que aconteceu com o APP quando o passo falhou — sinal separado do foco: o app reiniciado também fica sem foco por
# instantes, e "foco: nenhum" sozinho não prova ambiente. Kind: crash · anr · closed (o processo sumiu) · restarted (pid novo,
# sem crash) · webview-recreated (mesmo pid, a página caiu) · system-window (outra janela em foco) · '' (nada a dizer).
function Get-AndroidFailSignal([int]$PidBefore, [string]$Detail, $Log) {
    $pkg = [string]$script:Pkg; $q = [regex]::Escape($pkg)
    $all = @(@($Log.Main) + @($Log.Crash) | ForEach-Object { [string]$_ })
    $now = Get-AndroidAppPid
    $crashL = @($all | Where-Object { $_ -match "Process: $q\b" -or ($_ -match 'FATAL EXCEPTION' -and $_ -match $q) })
    if (-not $crashL.Count -and @($Log.Crash | Where-Object { [string]$_ -match $q }).Count) { $crashL = @($Log.Crash | Where-Object { [string]$_ -match $q }) }
    if ($crashL.Count) {
        $ex = @($all | Where-Object { $_ -match '(?:Exception|Error)(?::|\s*$)' -and $_ -match 'AndroidRuntime' -and $_ -notmatch 'FATAL EXCEPTION|Process:' }) | Select-Object -First 1
        return [pscustomobject]@{ kind = 'crash'; text = "o app fechou com erro (crash no registro)$(if ($ex) { ': ' + (([string]$ex -replace '^.*AndroidRuntime:\s*', '').Trim()) })" }
    }
    if (@($all | Where-Object { $_ -match "ANR in $q\b" }).Count) { return [pscustomobject]@{ kind = 'anr'; text = 'o app parou de responder (ANR no registro)' } }
    if (-not $now) { return [pscustomobject]@{ kind = 'closed'; text = "o processo do app não está rodando$(if ($PidBefore) { " (era o pid $PidBefore)" }), sem crash no registro" } }
    if ($PidBefore -and $now -ne $PidBefore) { return [pscustomobject]@{ kind = 'restarted'; text = "o app foi reiniciado (pid $PidBefore → $now), sem crash no registro" } }
    $wv = @($all | Where-Object { $_ -match '(?i)render(er)? process (crash|gone|kill)|onRenderProcessGone|webview.*(crash|died)' }) | Select-Object -First 1
    if ($wv -or $Detail -match 'conexão com a página caiu') { return [pscustomobject]@{ kind = 'webview-recreated'; text = "a WebView foi recriada no mesmo processo (pid $now)$(if ($wv) { ': ' + ([string]$wv).Trim() } else { ' — a página do DevTools fechou' })" } }
    $f = [string](Get-FocusLine)
    if ($f -and $f -notmatch 'mCurrentFocus=null' -and $pkg -and $f -notmatch [regex]::Escape("$pkg/")) { return [pscustomobject]@{ kind = 'system-window'; text = "outra janela em foco: $(($f -replace '^.*mCurrentFocus=', '').Trim())" } }
    # O app roda e nenhuma janela tem o foco: ambíguo (app reabrindo, atividade recriada, tela sem janela) — vai ao diagnóstico.
    if ($Detail -match 'não ficou na frente') { return [pscustomobject]@{ kind = 'no-focus'; text = "o app está rodando (pid $now) e nenhuma janela dele ficou em foco — sem crash, ANR nem janela do sistema no registro" } }
    return [pscustomobject]@{ kind = ''; text = '' }
}

# ---------- localizador CDP (v3.62.0) ----------
# targets.android.locator = "cdp": os verbos de tela vão ao android-cdp.js pela WebView do app. A conexão: o pid do app →
# o socket webview_devtools_remote_<pid> (/proc/net/unix) → adb forward tcp:0 (porta livre escolhida pelo adb, nunca fixa:
# a 9222 é também a do Chrome headless do Karma). O forward é refeito quando o pid muda (launch, restart, reset) e removido no
# fim do accept (Clear-AndroidCdpForwards) e pelo target.ps1 -Kill.
$script:CdpPort = 0; $script:CdpPid = 0; $script:Node = ''; $script:CdpSocketWaitSec = 10
function Get-AndroidLocator {
    if ($script:AdCfg -and $script:AdCfg.PSObject.Properties['locator'] -and $script:AdCfg.locator) { return ([string]$script:AdCfg.locator).Trim().ToLower() }
    return 'uiautomator'
}
function Get-AndroidCdpCfg {
    $c = if ($script:AdCfg -and $script:AdCfg.PSObject.Properties['cdp'] -and $script:AdCfg.cdp) { $script:AdCfg.cdp } else { $null }
    $v = { param($k, $d) if ($c -and $c.PSObject.Properties[$k] -and $null -ne $c.$k -and "$($c.$k)" -ne '') { return $c.$k }; return $d }
    return [ordered]@{
        pageUrl = [string](& $v 'pageUrl' ''); readyExpr = [string](& $v 'readyExpr' "document.readyState === 'complete'"); readyTimeoutSec = [int](& $v 'readyTimeoutSec' 30)
        failExpr = [string](& $v 'failExpr' ''); hiddenScopes = @(@(& $v 'hiddenScopes' @()) | ForEach-Object { [string]$_ } | Where-Object { $_ })
        stepTimeoutSec = [int](& $v 'stepTimeoutSec' 60); callTimeoutMs = [int](& $v 'callTimeoutMs' 10000)
    }
}
# O Node do transporte: 22 ou mais novo (fetch e WebSocket globais). $null = pronto; senão o motivo.
function Test-AndroidCdpNode {
    $c = Get-Command node -ErrorAction SilentlyContinue
    if (-not $c) { return 'o targets.android.locator "cdp" precisa do Node.js 22 ou mais novo, e o node não está no PATH' }
    $script:Node = $c.Source
    $ver = ((& $script:Node -p 'process.versions.node' 2>$null) -join '').Trim()
    if (-not ($ver -match '^(\d+)\.') -or [int]$Matches[1] -lt 22) { return "o targets.android.locator ""cdp"" precisa do Node.js 22 ou mais novo (WebSocket global); este é o $ver" }
    return $null
}
function Get-AndroidAppPid {
    if (-not $script:Pkg) { return 0 }
    $o = ((Sh pidof $script:Pkg) -join ' ').Trim()
    if ($o -match '^\d+') { return [int]$Matches[0] }
    return 0
}
function Get-AndroidCdpSocket([int]$AppPid) {
    $l = (@(Sh "cat /proc/net/unix | grep webview_devtools_remote_$AppPid") -join "`n")
    $m = [regex]::Match($l, "@(webview_devtools_remote_$AppPid)(?!\d)")
    if ($m.Success) { return $m.Groups[1].Value }
    return ''
}
function Open-AndroidCdpForward([string]$Sock) {
    $o = ((AdbT 20 @('forward', 'tcp:0', "localabstract:$Sock")) -join '').Trim()
    if ($o -match '^\d+$') { return [int]$o }
    throw "AMBIENTE: adb forward da WebView ($Sock) não devolveu a porta: $(if ($script:AdbTimeout) { $script:AdbTimeout } else { $o })"
}
function Close-AndroidCdpForward {
    if ($script:CdpPort) { $null = AdbT 20 @('forward', '--remove', "tcp:$($script:CdpPort)") }
    $script:CdpPort = 0; $script:CdpPid = 0
}
# Todo forward para a WebView deste aparelho (o que um accept que caiu deixou): o accept segura a trava do alvo, então nenhum
# outro executor está usando. Devolve quantos removeu.
function Clear-AndroidCdpForwards {
    $script:CdpPort = 0; $script:CdpPid = 0; $n = 0
    foreach ($l in @(AdbT 20 @('forward', '--list'))) {
        $p = ([string]$l).Trim() -split '\s+'
        if ($p.Count -lt 3 -or $p[2] -notmatch '^localabstract:webview_devtools_remote_' -or $p[1] -notmatch '^tcp:\d+$') { continue }
        if ($script:Serial -and $p[0] -ne $script:Serial) { continue }
        $null = AdbT 20 @('forward', '--remove', $p[1]); $n++
    }
    return $n
}
function Connect-AndroidCdp {
    $appPid = Get-AndroidAppPid
    if (-not $appPid) { throw "o app $($script:Pkg) não está rodando — o passo de tela pede o app aberto (launch antes)" }
    if ($appPid -eq $script:CdpPid -and $script:CdpPort) { return }
    Close-AndroidCdpForward
    $t = [datetime]::UtcNow; $sock = ''
    do { $sock = Get-AndroidCdpSocket $appPid; if ($sock) { break }; Start-Sleep -Milliseconds 500 } while (([datetime]::UtcNow - $t).TotalSeconds -lt $script:CdpSocketWaitSec)
    if (-not $sock) { throw "CONFIGURAÇÃO: o APK não liga a depuração da WebView — o app $($script:Pkg) (pid $appPid) está aberto e não há o socket webview_devtools_remote_$appPid no aparelho. No Capacitor: android.webContentsDebuggingEnabled = true no capacitor.config, no build de debug; nos demais: WebView.setWebContentsDebuggingEnabled(true) no build de debug. Sem isso o locator cdp não enxerga a tela" }
    $script:CdpPort = Open-AndroidCdpForward $sock; $script:CdpPid = $appPid
}
# Processo com prazo (a saída vai para o arquivo do próprio executor): estourou → encerrado, e o passo é AMBIENTE.
function Invoke-NodeT([int]$Sec, [string[]]$A) {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $script:Node; $psi.Arguments = (@($A | ForEach-Object { Format-AdbArg ([string]$_) }) -join ' ')
    $psi.UseShellExecute = $false; $psi.CreateNoWindow = $true; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true
    # protocolo: node — prazo próprio (WaitForExit com limite); o executor não deixa filho: estourou, morre só ele.
    $p = [System.Diagnostics.Process]::Start($psi)
    $o = $p.StandardOutput.ReadToEndAsync(); $e = $p.StandardError.ReadToEndAsync()
    $ok = $p.WaitForExit($Sec * 1000)
    if (-not $ok) { try { $p.Kill() } catch { } }
    [void]$p.WaitForExit(2000)
    $err = ''; try { if ($e.Wait(1000)) { $err = [string]$e.Result } } catch { }
    $p.Dispose()
    return @{ TimedOut = -not $ok; Err = $err.Trim() }
}
function Invoke-AndroidCdpStep([string]$Verb, [string]$Rest) {
    if (-not $script:Node) { $nm = Test-AndroidCdpNode; if ($nm) { throw "CONFIGURAÇÃO: $nm" } }
    Connect-AndroidCdp
    $c = Get-AndroidCdpCfg
    $root = if ($Root) { $Root } else { (Get-Location).Path }
    $sc = if ($script:AdCfg -and $script:AdCfg.PSObject.Properties['selectConfirm'] -and $script:AdCfg.selectConfirm) { [string]$script:AdCfg.selectConfirm } else { '^(OK|Ok|Confirmar|Concluir|Pronto|Aplicar|Done)$' }
    $in = [ordered]@{ port = $script:CdpPort; verb = $Verb; rest = $Rest; attr = (Get-TestIdAttribute $root); hiddenScopes = @($c.hiddenScopes); pageUrl = $c.pageUrl
                      readyExpr = $c.readyExpr; readyTimeoutSec = $c.readyTimeoutSec; failExpr = $c.failExpr; callTimeoutMs = $c.callTimeoutMs; selectConfirm = $sc
                      scrollVia = 'adb'; pointer = 'touch'; adb = $script:Adb; serial = $script:Serial }
    $tIn = [System.IO.Path]::GetTempFileName(); $tOut = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($tIn, ($in | ConvertTo-Json -Depth 4 -Compress), (New-Object System.Text.UTF8Encoding($false)))
        $sec = $c.stepTimeoutSec + $(if ($Verb -eq 'ready') { $c.readyTimeoutSec } else { 0 })
        $r = Invoke-NodeT $sec @((Join-Path $PSScriptRoot 'android-cdp.js'), $tIn, $tOut)
        if ($r.TimedOut) { throw "AMBIENTE: o executor cdp passou de $sec s no passo '$Verb $Rest' e foi encerrado (targets.android.cdp.stepTimeoutSec)" }
        $o = $null; try { $o = [System.IO.File]::ReadAllText($tOut, [System.Text.Encoding]::UTF8) | ConvertFrom-Json } catch { }
    } finally { Remove-Item -LiteralPath $tIn, $tOut -Force -ErrorAction SilentlyContinue }
    if (-not $o) { throw "AMBIENTE: o executor cdp não devolveu resultado no passo '$Verb $Rest'$(if ($r.Err) { " ($(($r.Err -split "`n")[0]))" })" }
    if ($o.PSObject.Properties['ok'] -and $o.ok) { return }
    if ($o.PSObject.Properties['config'] -and $o.config) { throw "CONFIGURAÇÃO: $($o.config)" }
    if ($o.PSObject.Properties['environment'] -and $o.environment) { throw "AMBIENTE: $($o.environment)" }
    throw [string]$o.fail
}

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
        'font-scale' { Set-AndroidFontScale ([double]$Rest) }
        'tap' { Tap $Rest }
        'type' { $k, $v = $Rest -split '\s*=\s*', 2; TypeText $k.Trim() ([string]$v) }
        'select' { $k, $v = $Rest -split '\s*=\s*', 2; SelectOption $k.Trim() ([string]$v).Trim() }
        # v3.53.7: massa de dados — o comando do projeto em targets.android.seeds.<nome>, com o aparelho e o pacote no ambiente.
        'seed' { $e = Invoke-TargetSeed $(if ($Root) { $Root } else { (Get-Location).Path }) 'android' $script:AdCfg $Rest.Trim() @{ ACCEPT_SERIAL = $script:Serial; ACCEPT_PACKAGE = $script:Pkg }; if ($e) { throw "AMBIENTE: $e" } }
        'slider' { $p = $Rest -split '\s+'; SetSlider $p[0] ([double]$p[1]) ([double]$p[2]) ([double]$p[3]) }
        'shot' { Save-AndroidShot "$ShotBase-$Rest.png" }
        # v3.65.2: o assert relê até o valor bater ou 5 s (Wait-Assert), como o executor cdp — sem "wait" fixo no cenário.
        'assert-text' { $k, $v = $Rest -split '\s*=\s*', 2; if (-not (Wait-Assert { $script:wa = TextOf $k; $script:wa -eq $v })) { throw "esperado '$v', obtido '$($script:wa)' em $k" } }
        'assert-contains' { $k, $v = $Rest -split '\s*=\s*', 2; if (-not (Wait-Assert { $script:wa = TextOf $k; $script:wa -like "*$v*" })) { throw "'$($script:wa)' não contém '$v' em $k" } }
        'assert-exists' { if (-not (Reach $Rest 8)) { throw "tag ausente: $Rest$(Get-ScreenHint)" } }
        'assert-absent' { if (-not (Wait-Assert { -not (Has $Rest) })) { throw "tag presente (esperada ausente): $Rest" } }
        'assert-checked' { $k, $v = $Rest -split '\s*=\s*', 2; if (-not (Reach $k 4)) { throw "tag ausente: $k" }; $want = $v -match '^(true|sim|1)$'; if (-not (Wait-Assert { [void](Dump); $script:wa = [bool](Find $k).Checked; $script:wa -eq $want })) { throw "$k marcado = $($script:wa), esperado $v" } }
        'assert-count' { $k, $v = $Rest -split '\s*=\s*', 2; if (-not (Wait-Assert { $script:IdCache = @{}; $script:wa = @(CollectIds $k); $script:wa.Count -eq [int]$v } 800)) { $ids = @($script:wa); throw "esperado $v itens '$k*' na lista inteira, obtido $($ids.Count): [$($ids -join ',')]" } }
        'assert-order' { $k, $v = $Rest -split '\s*=\s*', 2; $got = @(CollectIds $k); $want = @($v -split '\s*,\s*'); $idx = @($want | ForEach-Object { [array]::IndexOf($got, $_) }); if ($idx -contains -1 -or ($idx -join ',') -ne (($idx | Sort-Object) -join ',')) { throw "ordem diferente: esperado [$v], lista [$($got -join ',')]" } }
        default { throw "passo '$Verb' não existe no alvo android" }
    }
}
