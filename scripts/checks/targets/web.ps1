# Adaptador Web do executor de cenários (v3.51, F1) e do pré-voo do alvo (D3). Dot-source: . targets\web.ps1
# Pré-voo: o site responde na URL de saúde e o Node existe; reparo: sobe o servidor pelo comando configurado e espera.
# Os cenários rodam no web-runner.js (Playwright, navegador headless) — Angular, React ou qualquer front-end com data-testid.
# Config (guards.json → targets.web): url, health (padrão = url), start (ex.: "npm run start"), startTimeoutSec (120),
# testIdAttribute ("data-testid"), viewport ({ "width": 1280, "height": 800 }).

$script:WebCfg = $null; $script:WebRoot = $null

function Initialize-Web($Cfg, [string]$Root) {
    $script:WebCfg = $Cfg; $script:WebRoot = $Root
    if (-not $Cfg -or -not $Cfg.url) { return 'guards.json → targets.web sem "url"' }
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) { return 'o Node.js não está instalado (o executor web roda em Node com Playwright)' }
    return $null
}
function Test-WebHealth {
    $u = if ($script:WebCfg.health) { [string]$script:WebCfg.health } else { [string]$script:WebCfg.url }
    try {
        $r = Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
        if ([int]$r.StatusCode -ge 500) { return "o site responde com erro $($r.StatusCode) em $u" }
        return $null
    } catch {
        $code = try { [int]$_.Exception.Response.StatusCode } catch { 0 }
        if ($code -gt 0 -and $code -lt 500) { return $null }   # 404 na raiz ainda é servidor no ar
        return "o site não responde em $u (servidor fora do ar)"
    }
}
function Repair-Web {
    $start = [string]$script:WebCfg.start
    if (-not $start) { return 'sem targets.web.start no guards.json: suba o servidor à mão' }
    $enc = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes("`$env:CI = 'true'; $start"))
    $p = Start-Process -FilePath 'powershell' -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-EncodedCommand', $enc) -WorkingDirectory $script:WebRoot -WindowStyle Hidden -PassThru
    [System.IO.File]::WriteAllText((Join-Path $script:WebRoot '.team-project/.target-web.json'), (@{ pid = $p.Id; start = $start; desde = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') } | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false)))
    $limit = if ($script:WebCfg.startTimeoutSec) { [int]$script:WebCfg.startTimeoutSec } else { 120 }
    $t = Get-Date
    do { Start-Sleep -Seconds 3; $h = Test-WebHealth } while ($h -and ((Get-Date) - $t).TotalSeconds -lt $limit)
    if ($h) { return "o servidor não subiu em $limit s com '$start': $h" }
    return $null
}
# Encerra o servidor que o próprio executor subiu (e só ele).
function Stop-WebServer {
    $f = Join-Path $script:WebRoot '.team-project/.target-web.json'
    if (-not (Test-Path -LiteralPath $f)) { return }
    try { $j = Get-Content -LiteralPath $f -Raw -Encoding UTF8 | ConvertFrom-Json; $null = Stop-ProcessTree ([int]$j.pid) } catch { }
    Remove-Item -LiteralPath $f -Force -ErrorAction SilentlyContinue
}
function Invoke-WebScenarios($Scenarios, [string]$ShotDir) {
    $tmpIn = [System.IO.Path]::GetTempFileName(); $tmpOut = [System.IO.Path]::GetTempFileName()
    $in = [ordered]@{ url = [string]$script:WebCfg.url; root = $script:WebRoot; testIdAttribute = $(if ($script:WebCfg.testIdAttribute) { [string]$script:WebCfg.testIdAttribute } else { 'data-testid' })
                      viewport = $script:WebCfg.viewport; shotDir = $ShotDir; scenarios = @($Scenarios | ForEach-Object { [ordered]@{ id = $_.id; title = $_.title; steps = @($_.steps) } }) }
    [System.IO.File]::WriteAllText($tmpIn, ($in | ConvertTo-Json -Depth 6), (New-Object System.Text.UTF8Encoding($false)))
    Push-Location $script:WebRoot
    try { $ErrorActionPreference = 'Continue'; & node (Join-Path $PSScriptRoot 'web-runner.js') $tmpIn $tmpOut 2>&1 | Out-Null } finally { Pop-Location }
    $o = try { Get-Content -LiteralPath $tmpOut -Raw -Encoding UTF8 | ConvertFrom-Json } catch { $null }
    Remove-Item -LiteralPath $tmpIn, $tmpOut -Force -ErrorAction SilentlyContinue
    if (-not $o) { return @{ environment = 'o executor web não devolveu resultado (node web-runner.js)' } }
    return $o
}
