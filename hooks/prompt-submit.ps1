# UserPromptSubmit — G21 (v3.52, R29 ampliada): cada ritual começa em sessão nova. Quando o stakeholder abre um ritual numa
# sessão que já rodou OUTRO ritual, avisa (não bloqueia): a sessão herdaria o histórico inteiro da etapa anterior e pagaria
# por relê-lo a cada chamada — medido no sunscape-P-r1: o sprint run começou com ~200 mil tokens herdados da abertura e
# chegou a 438 mil. O mesmo ritual de novo (retomada do run) não avisa. Qualquer exceção → exit 1 (falha aberta, D5).

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
    if (-not (Test-Path -LiteralPath (Join-Path $projectDir '.team-project'))) { exit 0 }
    $cfg = Get-GuardConfig $projectDir
    if (-not (Test-GuardEnabled $cfg 'G21')) { exit 0 }
    $m = [regex]::Match([string]$hookInput.prompt, '^\s*(/[\w:-]+)\s*(.*)$', 'Singleline')
    if (-not $m.Success) { exit 0 }
    $now = Get-RitualKey $m.Groups[1].Value $m.Groups[2].Value
    if (-not $now) { exit 0 }
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
    exit 1
}
