# UserPromptSubmit — G21 (v3.52, R29 ampliada): cada ritual começa em sessão nova. Quando o stakeholder abre um ritual numa
# sessão que já rodou OUTRO ritual, avisa (não bloqueia): a sessão herdaria o histórico inteiro da etapa anterior e pagaria
# por relê-lo a cada chamada — medido no sunscape-P-r1: o sprint run começou com ~200 mil tokens herdados da abertura e
# chegou a 438 mil. O mesmo ritual de novo (retomada do run) não avisa. Qualquer exceção → exit 1 (falha aberta, D5).
# v3.53.2: também responde /team-status e /team-usage sem passar pelo modelo (ver abaixo).

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

# Ritual = comando + modo: "sm sprint run", "sm fix plan", "po note", "ux prototype". $null se o texto não abre ritual.
function Get-RitualKey([string]$Cmd, [string]$ArgText) {
    $c = ($Cmd -replace '^/', '' -replace '^[\w-]+:', '').ToLowerInvariant()
    $w = @(([string]$ArgText).Trim().ToLowerInvariant() -split '\s+' | Where-Object { $_ })
    $a1 = if ($w.Count) { $w[0] } else { '' }; $a2 = if ($w.Count -gt 1) { $w[1] } else { '' }
    switch ($c) {
        'sm' {
            if ($a1 -in @('onboarding', 'brainstorm', 'sdd')) { return "sm $a1" }
            if ($a1 -eq 'sprint0' -and $a2 -in @('plan', 'run', 'review', 'area')) { return "sm sprint0 $a2" }
            if ($a1 -eq 'sprint' -and $a2 -in @('prepare', 'plan', 'run', 'review', 'close')) { return "sm sprint $a2" }
            if ($a1 -eq 'review') { return 'sm sprint review' }
            if ($a1 -eq 'fix' -and $a2 -in @('plan', 'run')) { return "sm fix $a2" }
        }
        'po' { if ($a1 -eq 'note') { return 'po note' } }
        'ux' { if ($a1 -eq 'prototype') { return 'ux prototype' } }
    }
    return $null
}

try {
    $hookInput = Read-HookInput
    if ($null -eq $hookInput) { exit 0 }
    $projectDir = Get-ProjectDir $hookInput
    # v3.53.2 (pedido do stakeholder, 2026-11-01): /team-status e /team-usage [<n>] — visão do sprint SEM custo de token. O
    # texto sai do scripts/checks/team-view.ps1 e volta com decision=block: o harness mostra o reason ao stakeholder e o
    # prompt não chega ao modelo nem entra no contexto. Vale no console, na extensão e no Remote Control. Falha aqui → exit 1
    # (falha aberta): o prompt segue e o commands/team-status.md (ou team-usage.md) roda o mesmo script pelo modelo.
    # v3.59.0: /team-status abre em palavras simples; "detalhe" (ou "técnico") traz a visão técnica — em qualquer ordem com o número.
    $vm = [regex]::Match([string]$hookInput.prompt, '^\s*/(?:team:)?team-(status|usage)((?:\s+(?:\d+|detalhes?|t[ée]cnico|detail))*)\s*$', 'IgnoreCase')
    if ($vm.Success) {
        $va = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', (Join-Path $PSScriptRoot '..\scripts\checks\team-view.ps1'), '-View', $vm.Groups[1].Value.ToLowerInvariant(), '-Root', $projectDir)
        $vn = [regex]::Match($vm.Groups[2].Value, '\d+'); if ($vn.Success) { $va += @('-Sprint', $vn.Value) }
        if ($vm.Groups[2].Value -match '(?i)detal|t[ée]cnico|detail') { $va += '-Detail' }
        $text = ((& powershell @va 2>&1 | ForEach-Object { [string]$_ }) -join "`n").TrimEnd()
        if (-not $text) { $text = "team-view: sem saída (exit $LASTEXITCODE)." }
        [Console]::Out.Write((@{ decision = 'block'; reason = $text } | ConvertTo-Json -Compress))
        exit 0
    }
    if (-not (Test-Path -LiteralPath (Join-Path $projectDir '.team-project'))) { exit 0 }
    # v3.57.4: o transcript da sessão em curso, para a linha SESSÃO: do run.ps1 next. Antes ele lia o da última linha do
    # usage.jsonl — a sessão que disparou o último agente terminado; depois do /clear a sessão nova recebia "reiniciar" pelo
    # contexto da antiga antes de disparar agente nenhum, e o laço /clear → /sm sprint run → reiniciar não saía. Grava a cada
    # prompt e antes da G21 (desligada ou não), mesmo que o arquivo do transcript ainda não exista (primeiro prompt da sessão).
    if ($hookInput.transcript_path) {
        try { [System.IO.File]::WriteAllText((Join-Path $projectDir '.team-project/.session-transcript'), [string]$hookInput.transcript_path, (New-Object System.Text.UTF8Encoding($false))) } catch { }
    }
    $cfg = Get-GuardConfig $projectDir
    $m = [regex]::Match([string]$hookInput.prompt, '^\s*(/[\w:-]+)\s*(.*)$', 'Singleline')
    if (-not $m.Success) { exit 0 }
    $now = Get-RitualKey $m.Groups[1].Value $m.Groups[2].Value
    if (-not $now) { exit 0 }
    # G25 (v3.61.0 · R35) — o backlog funcional abre depois do sprint 0: com a linha "Sprint 0 (fundação)" do README §2
    # exigida e não concluída (nem dispensada), /sm sprint prepare e plan voltam com o motivo, sem chegar ao modelo. Sem a
    # linha, o projeto é anterior à v3.61.0 e nada se impõe. A mesma decisão do foundation.ps1 gate, sem subir processo.
    if ($now -in @('sm sprint prepare', 'sm sprint plan') -and (Test-GuardEnabled $cfg 'G25')) {
        $rp = Join-Path $projectDir '.team-project/README.md'
        if (Test-Path -LiteralPath $rp) {
            $rm = [regex]::Match([System.IO.File]::ReadAllText($rp, (New-Object System.Text.UTF8Encoding($false))), '(?m)^\|\s*\*{0,2}Sprint 0 \(fundação\)\*{0,2}\s*\|([^\r\n]*)\|\s*$')
            if ($rm.Success) {
                $val = ($rm.Groups[1].Value -replace '\*\*', '' -replace '`', '').Trim()
                if ($val -notmatch '(?i)^(conclu|dispensad)') {
                    $why = if (-not $val -or $val -match '<[^>]+>') { 'a linha "Sprint 0 (fundação)" do README §2 ainda não foi decidida — o /sm onboarding (passo 3) decide se há sprint 0' } else { "sprint 0 $val" }
                    Write-GuardLog $projectDir 'G25' $hookInput $now "negado: $why"
                    $reason = "[G25] /$now espera o sprint 0 (R35): $why. O backlog funcional abre sobre documentação conforme e ambiente de testes provado. Caminho: /sm sprint0 plan (se ainda não há quadro) → /sm sprint0 run → /sm sprint0 review. Dispensar é decisão sua, com o risco aceito: peça ao time o formulário de dispensa (foundation.ps1 dispense)."
                    [Console]::Out.Write((@{ decision = 'block'; reason = $reason } | ConvertTo-Json -Compress))
                    exit 0
                }
            }
        }
    }
    if (-not (Test-GuardEnabled $cfg 'G21')) { exit 0 }
    $tr = [string]$hookInput.transcript_path
    if (-not $tr -or -not (Test-Path -LiteralPath $tr)) { exit 0 }
    $before = @()
    # Dois formatos no transcript: o interativo grava <command-name>/sm</command-name> … <command-args>…</command-args>; o
    # claude -p grava o texto cru na mensagem do usuário ("content":"/sm sprint run\r\n", às vezes com BOM).
    foreach ($l in (Get-Content -LiteralPath $tr -Encoding UTF8)) {
        if ($l.IndexOf('"type":"user"') -lt 0) { continue }
        $hits = @()
        if ($l.IndexOf('<command-name>') -ge 0) { $hits += @([regex]::Matches($l, '<command-name>(/[\w:-]+)</command-name>(?:\\n|\s)*<command-args>([^<]*)</command-args>')) }
        $hits += @([regex]::Matches($l, '"content":"﻿?(/[\w:-]+)[ ]*([^"\\]*)'))
        foreach ($x in $hits) {
            $k = Get-RitualKey $x.Groups[1].Value $x.Groups[2].Value
            if ($k -and $before -notcontains $k) { $before += $k }
        }
    }
    $other = @($before | Where-Object { $_ -ne $now })
    if (-not $other.Count) { exit 0 }
    Write-GuardLog $projectDir 'G21' $hookInput $now ("aviso: ritual aberto em sessão que já rodou " + ($other -join ', '))
    $msg = "[G21] Esta sessão já rodou /$($other[-1]); /$now deveria começar em sessão nova (R29): ela herda o histórico da etapa anterior e paga por relê-lo a cada chamada. O que a etapa seguinte precisa já está em disco. Recomendado: /clear e /$now de novo."
    $ctx = "$msg Diga isso ao stakeholder em uma linha antes de seguir; se ele já decidiu continuar nesta sessão, siga."
    $out = @{ systemMessage = $msg; hookSpecificOutput = @{ hookEventName = 'UserPromptSubmit'; additionalContext = $ctx } } | ConvertTo-Json -Depth 4 -Compress
    [Console]::Out.Write($out)
    exit 0
} catch {
    # v3.65.0 (A1-02): a falha aberta deixa rastro — o COVERAGE promete a linha `erro` no guards.log em todo despachante
    try { Write-GuardLog $projectDir 'erro' $hookInput 'prompt-submit.ps1' $_.Exception.Message } catch { }
    exit 1
}
