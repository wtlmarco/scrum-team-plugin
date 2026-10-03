# Despachante PostToolUse — G4 (R28): saída grande no contexto de quem decide vira aviso. Nunca bloqueia.
# O campo da saída no input do PostToolUse não é documentado: procura stdout/output/content/texto e,
# sem nenhum, não faz nada (a sonda registra os campos recebidos). Exceção → exit 1 (não bloqueante, D5).

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

function Get-OutputText([object]$Response) {
    if ($null -eq $Response) { return $null }
    if ($Response -is [string]) { return $Response }
    foreach ($name in 'stdout', 'output', 'content', 'result') {
        $p = $Response.PSObject.Properties[$name]
        if ($p -and $p.Value -is [string]) { return $p.Value }
    }
    return $null
}

try {
    $hookInput = Read-HookInput
    if ($null -eq $hookInput) { exit 0 }
    $projectDir = Get-ProjectDir $hookInput
    $cfg = Get-GuardConfig $projectDir

    $response = $hookInput.tool_response
    if ($cfg.probe) {
        $fields = if ($null -eq $response) { '(sem tool_response)' } elseif ($response -is [string]) { '(string)' } else { ($response.PSObject.Properties.Name -join ',') }
        Write-GuardLog $projectDir 'probe' $hookInput '' "post tool_response=$fields"
    }
    if (-not (Test-GuardEnabled $cfg 'G4')) { exit 0 }
    if ([string]$hookInput.agent_type -match 'operator$') { exit 0 }   # execução pesada é o trabalho do operator

    $text = Get-OutputText $response
    if ($null -eq $text) { exit 0 }
    $lines = ($text -split "`r?`n").Count
    if ($lines -le $cfg.maxInlineLines) { exit 0 }

    $msg = "[G4] A saída deste comando tem $lines linhas (limite $($cfg.maxInlineLines)) e entrou inteira no contexto de quem decide — R28: build, teste e lint pesados vão para arquivo na origem, e a execução pesada é delegada ao operator."
    Write-GuardLog $projectDir 'G4' $hookInput "$lines linhas" 'aviso'
    $out = @{ hookSpecificOutput = @{ hookEventName = 'PostToolUse'; additionalContext = $msg } } | ConvertTo-Json -Depth 4 -Compress
    [Console]::Out.Write($out)
    exit 0
} catch {
    try { Write-GuardLog $projectDir 'erro' $hookInput 'post-tool.ps1' $_.Exception.Message } catch { }
    exit 1
}
