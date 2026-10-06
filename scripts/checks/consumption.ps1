# Registro de consumo a partir do medido (v3.45): lê .team-project/usage.jsonl (gravado pela G16, hooks/subagent-stop.ps1)
# e reescreve, em cada consumption.md aberto, as linhas medidas do "## Registro" e a tabela de "## Totais".
# Linha que não veio do hook (sem "medido:" na Nota — a de sessão do /usage, as anteriores à v3.45) fica como está.
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/consumption.ps1" [-Root <projeto>] [-File <consumption.md relativo>] [-Print]
#   -Print: só mostra o que gravaria. Sprint ou bloco fechado nunca recebe linha (templates/consumption.md).
# Exit 0 · 2 = erro de uso ou de leitura.

param(
    [string]$Root = (Get-Location).Path,
    [string]$File = '',
    [switch]$Print
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)

$short = @{ 'scrum-master' = 'sm'; 'product-owner' = 'po'; 'architect' = 'arc'; 'user-experience' = 'ux'; 'quality-assurance' = 'qa'; 'developer' = 'dev'; 'operator' = 'operator' }
$baseCat = @{ arc = 'produção'; dev = 'produção'; qa = 'verificação'; operator = 'verificação'; sm = 'cerimônia'; po = 'especificação'; ux = 'especificação' }

function Get-ShortModel([string]$Model) {
    $out = @()
    foreach ($m in ($Model -split ',')) { $mm = [regex]::Match($m, '(?i)(opus|sonnet|haiku|fable)'); if ($mm.Success) { $out += $mm.Value.ToLowerInvariant() } elseif ($m) { $out += $m } }
    if ($out.Count) { return ($out | Select-Object -Unique) -join '+' }
    return 'não disponível — o transcript não trouxe o modelo'
}

function Format-Duration([int]$Seconds) { return ('{0:00}:{1:00}' -f [Math]::Floor($Seconds / 60), ($Seconds % 60)) }

function Get-Number([string]$Cell) {
    $d = (Clean-Cell $Cell) -replace '[^\d]', ''
    if ($d) { return [int64]$d } else { return $null }
}

function Get-Seconds([string]$Cell) {
    $m = [regex]::Match((Clean-Cell $Cell), '^(\d+):(\d{2})$')
    if ($m.Success) { return [int]$m.Groups[1].Value * 60 + [int]$m.Groups[2].Value }
    return 0
}

# Task → História, pelo quadro do sprint (a História é o cabeçalho "## História H-nnn" acima da linha da Task).
function Get-StoryMap([string]$Board) {
    $map = @{}; $cur = $null
    foreach ($line in ($Board -split "`r?`n")) {
        $hm = [regex]::Match($line, '^##\s+Hist[oó]ria\s+(H-[\w]+)'); if ($hm.Success) { $cur = $hm.Groups[1].Value; continue }
        if ($cur -and $line.TrimStart().StartsWith('|')) {
            $tm = [regex]::Match((Split-Row $line)[0], '(T-\d+[a-z]?)'); if ($tm.Success -and -not $map.ContainsKey($tm.Groups[1].Value)) { $map[$tm.Groups[1].Value] = $cur }
        }
    }
    return $map
}

# Destino fechado: sprint com retrospectiva, bloco com "## Fechamento" no verdict.md.
function Test-Closed([string]$Dest) {
    $dir = Split-Path (Join-Path $Root $Dest)
    if ($Dest -match '/sprints/\d+/') { return Test-Path -LiteralPath (Join-Path $dir 'retrospective.md') }
    if ($Dest -match '/fixes/B-\d+/') { $v = Join-Path $dir 'verdict.md'; return (Test-Path -LiteralPath $v) -and ((Read-Text $v) -match '(?m)^##\s+Fechamento') }
    return $false
}

try {
    $tp = Join-Path $Root '.team-project'
    if (-not (Test-Path -LiteralPath $tp)) { [Console]::Error.WriteLine("consumo: $tp não existe — rode na raiz do projeto ou passe -Root."); exit 2 }
    $usagePath = Join-Path $tp 'usage.jsonl'
    $usage = New-Object System.Collections.ArrayList
    if (Test-Path -LiteralPath $usagePath) {
        foreach ($line in [System.IO.File]::ReadAllLines($usagePath, $utf8)) {
            if (-not $line.Trim()) { continue }
            try { [void]$usage.Add(($line | ConvertFrom-Json)) } catch { }
        }
    }
    # Chamador de cada subagente aninhado (o operator do dev, do QA, do Arquiteto): a linha do pai lista os filhos.
    $caller = @{}
    foreach ($u in $usage) { foreach ($c in @($u.children)) { if ($c) { $caller[[string]$c] = $(if ($short.ContainsKey([string]$u.role)) { $short[[string]$u.role] } else { [string]$u.role }) } } }

    $dests = if ($File) { @($File -replace '\\', '/') } else { @($usage | ForEach-Object { [string]$_.dest } | Where-Object { $_ } | Select-Object -Unique) }
    if ($dests.Count -eq 0) { [Console]::Out.WriteLine('consumo: nenhuma linha medida em .team-project/usage.jsonl — nada a gravar.'); exit 0 }

    foreach ($dest in $dests) {
        $path = Join-Path $Root $dest
        if (-not (Test-Path -LiteralPath $path)) { [Console]::Out.WriteLine("consumo: $dest não existe — o registro nasce no sprint plan, no fix plan ou no /team init; linhas medidas ficam no usage.jsonl."); continue }
        if (Test-Closed $dest) { [Console]::Out.WriteLine("consumo: $dest está fechado — nenhuma linha nova (templates/consumption.md)."); continue }
        $text = Read-Text $path
        $storyMap = @{}
        $sm = [regex]::Match($dest, '/sprints/(\d+)/')
        if ($sm.Success) { $bp = Join-Path $tp "sprints/$($sm.Groups[1].Value)/sprint-backlog.md"; if (Test-Path -LiteralPath $bp) { $storyMap = Get-StoryMap (Read-Text $bp) } }
        $isBlock = $dest -match '/fixes/B-\d+/'

        # Linhas medidas deste destino, na ordem em que começaram.
        $mine = @($usage | Where-Object { [string]$_.dest -eq $dest } | Sort-Object { [string]$_.start })
        $measured = @(); $seenQa = @{}; $seenDev = @{}
        foreach ($u in $mine) {
            $role = if ($short.ContainsKey([string]$u.role)) { $short[[string]$u.role] } else { [string]$u.role }
            $work = [string]$u.work
            # Categoria mecânica (templates/consumption.md §Regras): retomada de Arquiteto/dev/QA, QA depois de um veredito
            # e Arquiteto ou dev depois de um QA na mesma Task são retrabalho; o resto é a categoria do papel.
            $cat = if ($baseCat.ContainsKey($role)) { $baseCat[$role] } else { 'n/a' }
            if ($role -in 'arc', 'dev', 'qa' -and $work -ne 'n/a') {
                if ([int]$u.round -gt 1 -or $seenQa.ContainsKey($work) -or ($role -eq 'arc' -and $seenDev.ContainsKey($work))) { $cat = 'retrabalho' }
                if ($role -eq 'qa') { $seenQa[$work] = $true }
                if ($role -eq 'dev') { $seenDev[$work] = $true }
            }
            $unit = if ($isBlock) { if ($work -match '^[FB]-\d+$') { $work } else { ($dest -replace '^.*/fixes/(B-\d+)/.*$', '$1') } }
                    elseif ($storyMap.ContainsKey($work)) { $storyMap[$work] } elseif ($work -match '^H-\d+$') { $work } elseif ($sm.Success) { "sprint-$($sm.Groups[1].Value)" } else { 'n/a' }
            $note = @()
            if (-not $isBlock -and $work -match '^F-\d+$') { $note += 'triagem;' }   # F-ID fora do bloco só na triagem (R33 · C4 item 7)
            if ($u.dest_note) { $note += "$($u.dest_note);" }
            if ($role -eq 'operator' -and $caller.ContainsKey([string]$u.agent_id)) { $note += "chamado por $($caller[[string]$u.agent_id]);" }
            $note += ("medido: {0}#{1}; notificação ≈ {2:N0}; cache lido {3:N0}; saída {4:N0}; {5} chamada(s); contexto 1ª/pico {6:N0}/{7:N0}" -f $u.agent_id, $u.round, [int64]$u.final_context, [int64]$u.cache_read, [int64]$u.output, $u.calls, [int64]$u.first_context, [int64]$u.peak_context)
            $cmd = if ($u.description) { '`Agent` · ' + ([string]$u.description -replace '\|', '/') } else { '`Agent`' }
            $measured += [pscustomobject]@{
                Line = ('| {0} | {1} | {2} | {3} | {4} | {5} | {6} | {7:N0} | {8} | {9} |' -f ([string]$u.start).Replace('T', ' ').Substring(0, 16), $role, (Get-ShortModel ([string]$u.model)), $cmd, $work, $cat, $unit, [int64]$u.processed, (Format-Duration ([int]$u.duration_s)), ($note -join ' '))
                Role = $role; Caller = $(if ($role -eq 'operator' -and $caller.ContainsKey([string]$u.agent_id)) { $caller[[string]$u.agent_id] } else { '' })
                Model = (Get-ShortModel ([string]$u.model)); Tokens = [int64]$u.processed; Seconds = [int]$u.duration_s; Notified = [int64]$u.final_context
            }
        }

        # ## Registro: mantém cabeçalho e as linhas que não vieram do hook; as medidas são reescritas por inteiro.
        $lines = New-Object System.Collections.ArrayList; foreach ($l in ($text -split "`r?`n")) { [void]$lines.Add($l) }
        $hi = -1; for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^##\s+Registro\b') { $hi = $i; break } }
        if ($hi -lt 0) { [Console]::Error.WriteLine("consumo: $dest sem a seção '## Registro'."); continue }
        $ts = -1; for ($i = $hi + 1; $i -lt $lines.Count; $i++) { if ($lines[$i].TrimStart().StartsWith('|')) { $ts = $i; break }; if ($lines[$i] -match '^#') { break } }
        if ($ts -lt 0) { [Console]::Error.WriteLine("consumo: $dest sem a tabela do '## Registro'."); continue }
        $te = $ts; while ($te + 1 -lt $lines.Count -and $lines[$te + 1].TrimStart().StartsWith('|')) { $te++ }
        $kept = @(); for ($i = $ts + 2; $i -le $te; $i++) { if ($lines[$i] -notmatch 'medido:') { $kept += $lines[$i] } }
        $newTable = @($lines[$ts], $lines[$ts + 1]) + $kept + @($measured | ForEach-Object { $_.Line })
        $lines.RemoveRange($ts, $te - $ts + 1); $lines.InsertRange($ts, [string[]]$newTable)

        # ## Totais (derivado): uma linha por papel e uma por operator ← chamador, das linhas mantidas + medidas (sessão fica fora).
        $agg = [ordered]@{}
        foreach ($k in $kept) {
            $c = Split-Row $k
            if ($c.Count -lt 9 -or ($c -join '') -match '<[^>]+>') { continue }
            $role = Clean-Cell $c[1]; if (-not $role -or $role -eq 'sessão') { continue }
            $key = if ($role -eq 'operator') { $cm = [regex]::Match($c[-1], 'chamado por (\w+)'); 'operator ← ' + $(if ($cm.Success) { $cm.Groups[1].Value } else { '?' }) } else { $role }
            if (-not $agg.Contains($key)) { $agg[$key] = @{ Model = (Clean-Cell $c[2]); Tokens = 0L; Count = 0; Seconds = 0; Notified = 0L } }
            # Linha transcrita à mão traz o número da notificação (contexto final), não o processado: soma só na última coluna.
            $t = Get-Number $c[7]; if ($null -ne $t) { $agg[$key].Notified += $t }
            $agg[$key].Count++; $agg[$key].Seconds += (Get-Seconds $c[8])
        }
        foreach ($m in $measured) {
            $key = if ($m.Role -eq 'operator') { 'operator ← ' + $(if ($m.Caller) { $m.Caller } else { '?' }) } else { $m.Role }
            if (-not $agg.Contains($key)) { $agg[$key] = @{ Model = $m.Model; Tokens = 0L; Count = 0; Seconds = 0; Notified = 0L } }
            $agg[$key].Tokens += $m.Tokens; $agg[$key].Count++; $agg[$key].Seconds += $m.Seconds; $agg[$key].Notified += $m.Notified
        }
        $totI = -1; for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^##\s+Totais') { $totI = $i; break } }
        if ($totI -ge 0) {
            $s = -1; for ($i = $totI + 1; $i -lt $lines.Count; $i++) { if ($lines[$i].TrimStart().StartsWith('|')) { $s = $i; break }; if ($lines[$i] -match '^#') { break } }
            if ($s -ge 0) {
                $e2 = $s; while ($e2 + 1 -lt $lines.Count -and $lines[$e2 + 1].TrimStart().StartsWith('|')) { $e2++ }
                $label = if ($isBlock) { 'Total do bloco' } else { 'Total do sprint' }
                $rows = @('| Papel | Modelo | Σ tokens processados | Nº de invocações | Duração total | Σ notificação |', '|---|---|---|---|---|---|')
                $sumT = 0L; $sumN = 0; $sumS = 0; $sumNot = 0L
                foreach ($k in $agg.Keys) {
                    $a = $agg[$k]; $sumT += $a.Tokens; $sumN += $a.Count; $sumS += $a.Seconds; $sumNot += $a.Notified
                    $rows += ('| {0} | {1} | {2:N0} | {3} | {4} | {5:N0} |' -f $k, $a.Model, $a.Tokens, $a.Count, (Format-Duration $a.Seconds), $a.Notified)
                }
                $rows += ('| **{0}** | — | **{1:N0}** | **{2}** | **{3}** | **{4:N0}** |' -f $label, $sumT, $sumN, (Format-Duration $sumS), $sumNot)
                $lines.RemoveRange($s, $e2 - $s + 1); $lines.InsertRange($s, [string[]]$rows)
            }
        }

        $result = ($lines -join "`n")
        if ($Print) { [Console]::Out.WriteLine("---- $dest"); [Console]::Out.WriteLine($result) }
        else { [System.IO.File]::WriteAllText($path, $result, $utf8); [Console]::Out.WriteLine("consumo: $dest — $($measured.Count) linha(s) medida(s), $($kept.Count) mantida(s).") }
    }
    exit 0
} catch {
    [Console]::Error.WriteLine("consumo: erro — $($_.Exception.Message)")
    exit 2
}
