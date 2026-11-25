# Conversa enxuta (v3.66.2, item F) — tira das conversas do Claude Code NESTE projeto o que o time não usa: ferramentas
# (Artifact, ScheduleWakeup, ReportFindings, Workflow, ShareOnboardingGuide), os conectores da conta (claude.ai) e as
# habilidades que não são do time (Word, PowerPoint, Excel, gráficos…). Medido em 25/11/2026 (Claude Code 2.1.331): a primeira
# chamada de uma conversa vazia caiu de 49.561 para 21.706 tokens. A lista e a medição estão em lean-session.json.
# Vale para TODAS as conversas do projeto, não só as do sprint (o Claude Code não separa): por isso é oferta do /team init e
# do /team update, aplicada só com a aprovação do stakeholder, e desfeita pelo -Off.
# Onde grava: .claude/settings.local.json do projeto (pessoal, fora do git), juntando ao que já existe — permissions.deny
# recebe só os itens que faltam, skillOverrides só as chaves ausentes; nada do projeto é apagado. O que ESTE script
# acrescentou fica em .team-project/lean-session.json, e o -Off tira só isso.
# Uso (raiz do projeto):
#   powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/lean-session.ps1" -Check   (o que está ligado; não grava)
#   … -Apply  (grava) · … -Off  (desfaz o que ele gravou)
# Exit: 0 = feito (ou -Check com tudo aplicado) · 3 = -Check com algo a aplicar · 2 = uso ou arquivo ilegível.
param(
    [switch]$Check,
    [switch]$Apply,
    [switch]$Off,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
$u8 = New-Object System.Text.UTF8Encoding($false)
$out = { param([string]$s) [Console]::Out.WriteLine($s) }
function Read-JsonFile([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    $t = [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
    if (-not $t.Trim()) { return [pscustomobject]@{} }
    return ($t | ConvertFrom-Json)
}
function Set-Prop($Obj, [string]$Name, $Value) {
    if ($Obj.PSObject.Properties[$Name]) { $Obj.$Name = $Value } else { $Obj | Add-Member -NotePropertyName $Name -NotePropertyValue $Value }
}

try {
    if (@($Check, $Apply, $Off | Where-Object { $_ }).Count -ne 1) { [Console]::Error.WriteLine('lean-session: use um de -Check, -Apply ou -Off.'); exit 2 }
    $spec = Read-JsonFile (Join-Path $PSScriptRoot 'lean-session.json')
    $setP = Join-Path $Root '.claude/settings.local.json'
    $markP = Join-Path $Root '.team-project/lean-session.json'
    $set = $null
    try { $set = Read-JsonFile $setP } catch { [Console]::Error.WriteLine("lean-session: $setP ilegível ($($_.Exception.Message)) — corrija o JSON antes."); exit 2 }
    if ($null -eq $set) { $set = [pscustomobject]@{} }

    $deny = @(); if ($set.PSObject.Properties['permissions'] -and $set.permissions -and $set.permissions.PSObject.Properties['deny']) { $deny = @($set.permissions.deny | ForEach-Object { [string]$_ }) }
    $ov = if ($set.PSObject.Properties['skillOverrides'] -and $set.skillOverrides) { $set.skillOverrides } else { $null }
    $hasOv = { param([string]$k) [bool]($ov -and $ov.PSObject.Properties[$k]) }
    $conn = [bool]($set.PSObject.Properties['disableClaudeAiConnectors'] -and $set.disableClaudeAiConnectors -eq $true)

    $missDeny = @($spec.deny | Where-Object { $deny -notcontains [string]$_ })
    $missSkill = @($spec.skillsOff | Where-Object { -not (& $hasOv ([string]$_)) })
    $missConn = [bool]($spec.disableClaudeAiConnectors -and -not $conn)

    if ($Check) {
        $saving = [int][Math]::Round(([int]$spec.measured.before - [int]$spec.measured.after) / 1000)
        if (-not $missDeny.Count -and -not $missSkill.Count -and -not $missConn) { & $out "lean-session: conversa enxuta já aplicada neste projeto ($setP)."; exit 0 }
        & $out "lean-session: falta aplicar — ferramentas: $(if ($missDeny.Count) { $missDeny -join ', ' } else { 'nenhuma' }) · conectores da conta: $(if ($missConn) { 'ligados' } else { 'já desligados' }) · habilidades fora do time: $($missSkill.Count) de $(@($spec.skillsOff).Count)."
        & $out "  ganho medido ($([string]$spec.measured.date), Claude Code $([string]$spec.measured.claudeCode)): ~$saving mil tokens a menos na abertura de cada conversa ($([int]$spec.measured.before) → $([int]$spec.measured.after) numa pasta vazia)."
        & $out "  vale para todas as conversas deste projeto; desfaz com -Off. Aplicar: -Apply (só com a aprovação do stakeholder)."
        exit 3
    }

    if ($Apply) {
        if (-not $set.PSObject.Properties['permissions'] -or -not $set.permissions) { Set-Prop $set 'permissions' ([pscustomobject]@{}) }
        Set-Prop $set.permissions 'deny' @($deny + $missDeny)
        if ($missSkill.Count) {
            if (-not $ov) { $ov = [pscustomobject]@{}; Set-Prop $set 'skillOverrides' $ov }
            foreach ($k in $missSkill) { Set-Prop $ov ([string]$k) 'off' }
        }
        if ($missConn) { Set-Prop $set 'disableClaudeAiConnectors' $true }
        New-Item -ItemType Directory -Force (Split-Path -Parent $setP) | Out-Null
        [System.IO.File]::WriteAllText($setP, ($set | ConvertTo-Json -Depth 20), $u8)
        # O que este script acrescentou — somado ao de um -Apply anterior, para o -Off desfazer tudo de uma vez.
        $prev = $null; try { $prev = Read-JsonFile $markP } catch { }
        $mark = [ordered]@{
            at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); file = '.claude/settings.local.json'
            deny = @(@($(if ($prev) { $prev.deny }) ) + $missDeny | Where-Object { $_ } | Select-Object -Unique)
            skills = @(@($(if ($prev) { $prev.skills }) ) + $missSkill | Where-Object { $_ } | Select-Object -Unique)
            connectors = [bool](($prev -and $prev.connectors) -or $missConn)
        }
        if (Test-Path -LiteralPath (Join-Path $Root '.team-project')) { [System.IO.File]::WriteAllText($markP, ($mark | ConvertTo-Json -Depth 5), $u8) }
        & $out "lean-session: aplicado em $setP — ferramentas +$($missDeny.Count), habilidades +$($missSkill.Count), conectores da conta $(if ($missConn) { 'desligados' } else { 'já estavam desligados' }). Vale na próxima conversa aberta neste projeto; desfaz com -Off."
        exit 0
    }

    # -Off: tira só o que o -Apply gravou (e que ainda está como ele deixou).
    $mk = $null; try { $mk = Read-JsonFile $markP } catch { }
    if (-not $mk) { & $out "lean-session: nada a desfazer — este projeto não tem o registro do -Apply ($markP)."; exit 0 }
    $myDeny = @($mk.deny | ForEach-Object { [string]$_ })
    if ($set.PSObject.Properties['permissions'] -and $set.permissions -and $set.permissions.PSObject.Properties['deny']) { $set.permissions.deny = @($deny | Where-Object { $myDeny -notcontains $_ }) }
    $nSk = 0
    if ($ov) { foreach ($k in @($mk.skills)) { if ($ov.PSObject.Properties[[string]$k] -and [string]$ov.([string]$k) -eq 'off') { $ov.PSObject.Properties.Remove([string]$k); $nSk++ } } }
    if ($mk.connectors -and $set.PSObject.Properties['disableClaudeAiConnectors']) { $set.PSObject.Properties.Remove('disableClaudeAiConnectors') }
    [System.IO.File]::WriteAllText($setP, ($set | ConvertTo-Json -Depth 20), $u8)
    Remove-Item -LiteralPath $markP -Force
    & $out "lean-session: desfeito em $setP — ferramentas -$($myDeny.Count), habilidades -$nSk$(if ($mk.connectors) { ', conectores da conta religados' }). Vale na próxima conversa."
    exit 0
} catch {
    [Console]::Error.WriteLine("lean-session: falhou — $($_.Exception.Message)")
    exit 2
}
