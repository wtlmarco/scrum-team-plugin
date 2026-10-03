# Despachante PreToolUse — guardas da fase 1 (proposta guards, v3.39).
# G1 (R31) · G2 (cópia instalada) · G3 (R22). Devolve a PRIMEIRA negação: exit 2 com o motivo no stderr.
# Qualquer exceção → exit 1 (erro não bloqueante — falha aberta, D5). Cobertura e limites: hooks/COVERAGE.md.

$ErrorActionPreference = 'Stop'
$sw = [System.Diagnostics.Stopwatch]::StartNew()
. (Join-Path $PSScriptRoot 'common.ps1')

function Deny([string]$Guard, [string]$Target, [string]$Reason) {
    Write-GuardLog $script:projectDir $Guard $script:hookInput $Target "deny: $Reason"
    [Console]::Error.WriteLine("[$Guard] $Reason")
    exit 2
}

# G1 — R31: o git recebe só o produto; .team-project/ nunca entra num commit.
function Test-G1([object]$ToolInput) {
    $cmd = [string]$ToolInput.command
    if ([string]::IsNullOrWhiteSpace($cmd)) { return }
    if ($cmd -match '\bgit\b[^;|&\r\n]*\badd\b[^;|&\r\n]*(\s-f\b|\s--force\b)[^;|&\r\n]*\.team-project') {
        Deny 'G1' '.team-project' "git add forçado de .team-project/ — R31: o processo é local e fica fora do git do projeto. Tire o arquivo do comando."
    }
    if ($cmd -match '\bgit\b[^;|&\r\n]*\bcommit\b') {
        $staged = & git -C $script:projectDir diff --cached --name-only 2>$null
        $hit = @($staged | Where-Object { $_ -like '.team-project/*' })
        if ($hit.Count -gt 0) {
            Deny 'G1' ($hit -join ', ') ("commit com arquivo de .team-project/ no stage (" + ($hit -join ', ') + ") — R31: o processo é local e fica fora do git. Rode: git restore --staged .team-project. Se este é o commit da migração R31 do /team update (git rm --cached .team-project), siga o passo 7b: G1 desligado em .team-project/guards.json só durante o passo.")
        }
    }
}

# G2 — a cópia instalada do plugin é sobrescrita no próximo update; o caminho é o /review no repositório-fonte.
function Test-G2([object]$ToolInput) {
    $root = $env:CLAUDE_PLUGIN_ROOT
    if ([string]::IsNullOrWhiteSpace($root)) { return }
    if (Test-Path -LiteralPath (Join-Path $root '.git')) { return }   # repositório-fonte: liberado
    $file = Normalize-PathText ([string]$ToolInput.file_path)
    $base = Normalize-PathText $root
    if ($file -and ($file -eq $base -or $file.StartsWith($base + '/'))) {
        Deny 'G2' $ToolInput.file_path "escrita na cópia instalada do plugin ($root): ela é sobrescrita no próximo claude plugin update. Mudança de processo vai pelo /review, no clone do repositório-fonte."
    }
}

# G3 — R22: toda pergunta ao stakeholder tem alternativas descritas e "Pedir mais contexto" por último.
function Test-G3([object]$ToolInput) {
    foreach ($q in @($ToolInput.questions)) {
        $opts = @($q.options)
        $text = [string]$q.question
        if ($opts.Count -lt 2) {
            Deny 'G3' $text "pergunta com menos de 2 alternativas — R22: cada alternativa viável descrita, e 'Pedir mais contexto' como a última."
        }
        $last = ([string]$opts[-1].label).Trim()
        if ($last -notmatch '^(?i)pedir mais contexto') {
            Deny 'G3' $text "a última opção de '$text' é '$last' — R22: toda pergunta ao stakeholder, até a simples, termina com 'Pedir mais contexto' (descrita como resposta válida, que reabre o time para aprofundar). Refaça o formulário."
        }
    }
}

try {
    $script:hookInput = Read-HookInput
    if ($null -eq $script:hookInput) { exit 0 }
    $script:projectDir = Get-ProjectDir $script:hookInput
    $cfg = Get-GuardConfig $script:projectDir
    $tool = [string]$script:hookInput.tool_name
    $ti = $script:hookInput.tool_input

    switch -Regex ($tool) {
        '^(PowerShell|Bash)$'   { if (Test-GuardEnabled $cfg 'G1') { Test-G1 $ti } }   # G1 vale sem guards.json (D5)
        '^(Edit|Write)$'        { if (Test-GuardEnabled $cfg 'G2') { Test-G2 $ti } }
        '^AskUserQuestion$'     { if (Test-GuardEnabled $cfg 'G3') { Test-G3 $ti } }
    }

    # Sonda (guards.json "probe": true): agent_type recebido e tempo do script — verifica a fase 2 e mede o custo do hook.
    if ($cfg.probe) {
        $agent = if ($script:hookInput.agent_type) { [string]$script:hookInput.agent_type } else { '(ausente)' }
        Write-GuardLog $script:projectDir 'probe' $script:hookInput '' ("agent_type=$agent; agent_id=" + [string]$script:hookInput.agent_id + "; script_ms=" + $sw.ElapsedMilliseconds)
    }
    exit 0
} catch {
    try { Write-GuardLog $script:projectDir 'erro' $script:hookInput 'pre-tool.ps1' $_.Exception.Message } catch { }
    exit 1
}
