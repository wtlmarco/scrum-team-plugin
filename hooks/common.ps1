# Funcoes comuns aos despachantes de guarda (hooks/*.ps1).
# Requisito: Windows PowerShell 5.1 (powershell.exe, o do Windows) - os hooks chamam "powershell", nao "pwsh".
# Sem recurso exclusivo do PowerShell 7. Falha aberta (D5): quem chama
# trata excecao com exit 1, que o harness le como erro nao bloqueante.

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Read-HookInput {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { return $null }
    return $raw | ConvertFrom-Json
}

function Get-ProjectDir([object]$HookInput) {
    if ($env:CLAUDE_PROJECT_DIR) { return $env:CLAUDE_PROJECT_DIR }
    if ($HookInput -and $HookInput.cwd) { return [string]$HookInput.cwd }
    return (Get-Location).Path
}

# Configuracao por projeto: .team-project/guards.json. Ausente ou invalida -> padrao.
function Get-GuardConfig([string]$ProjectDir) {
    $cfg = [ordered]@{
        disabled       = @()
        maxInlineLines = 300
        probe          = $false
        state          = 'ausente'
    }
    $path = Join-Path $ProjectDir '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $path)) { return $cfg }
    try {
        $json = Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($null -ne $json.disabled)       { $cfg.disabled       = @($json.disabled) }
        if ($null -ne $json.maxInlineLines) { $cfg.maxInlineLines = [int]$json.maxInlineLines }
        if ($null -ne $json.probe)          { $cfg.probe          = [bool]$json.probe }
        $cfg.state = 'ok'
    } catch {
        $cfg.state = 'invalido'
    }
    return $cfg
}

function Test-GuardEnabled($Config, [string]$Id) {
    return -not ($Config.disabled -contains $Id)
}

# Uma linha por decisao em .team-project/guards.log; so existe em projeto com o time instalado.
function Write-GuardLog([string]$ProjectDir, [string]$Guard, [object]$HookInput, [string]$Target, [string]$Message) {
    $dir = Join-Path $ProjectDir '.team-project'
    if (-not (Test-Path -LiteralPath $dir)) { return }
    $role = 'sessao'
    if ($HookInput -and $HookInput.agent_type) { $role = [string]$HookInput.agent_type }
    $tool = ''
    if ($HookInput -and $HookInput.tool_name) { $tool = [string]$HookInput.tool_name }
    $clean = ($Message -replace '\s+', ' ').Trim()
    $line = '{0} | {1} | {2} | {3} | {4} | {5}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Guard, $role, $tool, $Target, $clean
    try {
        [System.IO.File]::AppendAllText((Join-Path $dir 'guards.log'), $line + [Environment]::NewLine, (New-Object System.Text.UTF8Encoding($false)))
    } catch { }
}

function Normalize-PathText([string]$Path) {
    if ([string]::IsNullOrEmpty($Path)) { return '' }
    return ($Path -replace '\\', '/').TrimEnd('/').ToLowerInvariant()
}
