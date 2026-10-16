# Registro de consumo a partir do medido (v3.45): lê .team-project/usage.jsonl (gravado pela G16, hooks/subagent-stop.ps1)
# e reescreve, em cada consumption.md aberto, as linhas medidas do "## Registro" e a tabela de "## Totais".
# v3.49: a própria G16 roda este script ao fim de cada rodada (-File com o destino); a sessão só o roda antes de uma
# conferência que leia o consumo (C1, C4, retrospectiva).
# Linha que não veio do hook (sem "medido:" na Nota — a de sessão do /usage, as anteriores à v3.45) fica como está.
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/consumption.ps1" [-Root <projeto>] [-File <consumption.md relativo>] [-Session] [-Print]
#   -Session (v3.49): mede também a sessão principal, pelo transcript que a G16 grava em cada linha (session_transcript),
#     desde a primeira rodada medida do destino; uma linha "sessão" medida por sessão. Lê o transcript inteiro (dezenas de
#     MB): roda no close e na retrospectiva, nunca dentro do hook. Sem -Session, as linhas de sessão já medidas ficam.
#   -Print: só mostra o que gravaria. Sprint ou bloco fechado nunca recebe linha (templates/consumption.md).
# Exit 0 · 2 = erro de uso ou de leitura.

param(
    [string]$Root = (Get-Location).Path,
    [string]$File = '',
    [switch]$Session,
    [switch]$Print
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)

$short = @{ 'scrum-master' = 'sm'; 'product-owner' = 'po'; 'architect' = 'arc'; 'user-experience' = 'ux'; 'quality-assurance' = 'qa'; 'developer' = 'dev'; 'operator' = 'operator' }
$baseCat = @{ arc = 'produção'; dev = 'produção'; qa = 'verificação'; operator = 'verificação'; sm = 'cerimônia'; po = 'especificação'; ux = 'especificação' }

# Modelo servido com a versão (v3.49): "claude-haiku-4-5-20251001" → "haiku 4.5". Sem a versão, Haiku 4.5 e 5.5 viravam
# "haiku" na mesma linha dos Totais, com preço por token ~10× diferente entre eles.
function Get-ShortModel([string]$Model) {
    $out = @()
    foreach ($m in ($Model -split ',')) {
        $mm = [regex]::Match($m, '(?i)(opus|sonnet|haiku|fable|mythos)-(\d+)(?:-(\d{1,2}))?(?!\d)')
        if ($mm.Success) { $out += ($mm.Groups[1].Value.ToLowerInvariant() + ' ' + $mm.Groups[2].Value + $(if ($mm.Groups[3].Success) { '.' + $mm.Groups[3].Value } else { '' })); continue }
        $mf = [regex]::Match($m, '(?i)(opus|sonnet|haiku|fable|mythos)'); if ($mf.Success) { $out += $mf.Value.ToLowerInvariant() } elseif ($m) { $out += $m }
    }
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

# Sessão principal (v3.49): soma o usage das chamadas dela desde $Since, deduplicado por message.id (vale o último) e por
# uuid (o harness regrava linhas antigas antes de uma compactação). O transcript da sessão não tem os subagentes: cada um
# tem o seu, medido pela G16 — as duas somas se acrescentam, não se sobrepõem.
function Measure-SessionTranscript([string]$Path, [datetime]$Since) {
    $calls = @{}; $order = New-Object System.Collections.ArrayList; $seenUuid = @{}
    foreach ($line in [System.IO.File]::ReadLines($Path)) {
        if ($line.IndexOf('"usage"') -lt 0 -or $line.IndexOf('"type":"assistant"') -lt 0) { continue }
        try { $o = $line | ConvertFrom-Json } catch { continue }
        if ($o.uuid) { if ($seenUuid.ContainsKey([string]$o.uuid)) { continue }; $seenUuid[[string]$o.uuid] = $true }
        $id = [string]$o.message.id
        if (-not $id -or -not $o.message.usage -or [string]$o.message.model -eq '<synthetic>') { continue }
        $ts = [datetime][string]$o.timestamp
        if ($ts -lt $Since) { continue }
        if (-not $calls.ContainsKey($id)) { [void]$order.Add($id) }
        $calls[$id] = @{ u = $o.message.usage; model = [string]$o.message.model; ts = $ts }
    }
    if (-not $order.Count) { return $null }
    $r = @{ Calls = $order.Count; Processed = 0L; CacheRead = 0L; Output = 0L; Models = @{}; First = $calls[$order[0]].ts; Last = $calls[$order[$order.Count - 1]].ts }
    foreach ($id in $order) {
        $u = $calls[$id].u
        $r.Processed += [int64]$u.input_tokens + [int64]$u.cache_creation_input_tokens + [int64]$u.cache_read_input_tokens + [int64]$u.output_tokens
        $r.CacheRead += [int64]$u.cache_read_input_tokens; $r.Output += [int64]$u.output_tokens
        if ($calls[$id].model) { $r.Models[$calls[$id].model] = $true }
    }
    return $r
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
    # Sem o filho na linha do pai (pai sem medida, ou o resultado do Agent sem o agentId): o chamador é a rodada de outro
    # papel, na mesma Task, cujo intervalo contém o início do operator (v3.49). A Nota diz que foi pelo horário.
    $inferred = @{}
    $spans = @($usage | Where-Object { [string]$_.role -ne 'operator' -and $_.start } | ForEach-Object {
        $s = [datetime][string]$_.start
        [pscustomobject]@{ Role = $(if ($short.ContainsKey([string]$_.role)) { $short[[string]$_.role] } else { [string]$_.role }); Work = [string]$_.work; Start = $s; End = $s.AddSeconds([int]$_.duration_s + 60) } })
    foreach ($u in $usage) {
        if ([string]$u.role -ne 'operator' -or $caller.ContainsKey([string]$u.agent_id) -or -not $u.start) { continue }
        $os = [datetime][string]$u.start
        $hit = @($spans | Where-Object { $_.Work -eq [string]$u.work -and $_.Start -le $os -and $_.End -ge $os } | Sort-Object Start -Descending)
        if ($hit.Count) { $caller[[string]$u.agent_id] = $hit[0].Role; $inferred[[string]$u.agent_id] = $true }
    }

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
            if ($role -eq 'operator' -and $caller.ContainsKey([string]$u.agent_id)) { $note += "chamado por $($caller[[string]$u.agent_id])$(if ($inferred.ContainsKey([string]$u.agent_id)) { ' (pelo horário)' });" }
            $note += ("medido: {0}#{1}; notificação ≈ {2:N0}; cache lido {3:N0}; saída {4:N0}; {5} chamada(s); contexto 1ª/pico {6:N0}/{7:N0}" -f $u.agent_id, $u.round, [int64]$u.final_context, [int64]$u.cache_read, [int64]$u.output, $u.calls, [int64]$u.first_context, [int64]$u.peak_context)
            $cmd = if ($u.description) { '`Agent` · ' + ([string]$u.description -replace '\|', '/') } else { '`Agent`' }
            $measured += [pscustomobject]@{
                Line = ('| {0} | {1} | {2} | {3} | {4} | {5} | {6} | {7:N0} | {8} | {9} |' -f ([string]$u.start).Replace('T', ' ').Substring(0, 16), $role, (Get-ShortModel ([string]$u.model)), $cmd, $work, $cat, $unit, [int64]$u.processed, (Format-Duration ([int]$u.duration_s)), ($note -join ' '))
                Role = $role; AgentId = [string]$u.agent_id; Caller = $(if ($role -eq 'operator' -and $caller.ContainsKey([string]$u.agent_id)) { $caller[[string]$u.agent_id] } else { '' })
                Model = (Get-ShortModel ([string]$u.model)); Tokens = [int64]$u.processed; Seconds = [int]$u.duration_s; Notified = [int64]$u.final_context
            }
        }

        # Sessão principal (v3.49, -Session): uma linha medida por transcript de sessão citado nas rodadas deste destino.
        $sessionRows = @()
        if ($Session -and $mine.Count) {
            $since = [datetime][string]$mine[0].start
            $unitS = if ($isBlock) { ($dest -replace '^.*/fixes/(B-\d+)/.*$', '$1') } elseif ($sm.Success) { "sprint-$($sm.Groups[1].Value)" } else { 'n/a' }
            foreach ($st in @($mine | ForEach-Object { [string]$_.session_transcript } | Where-Object { $_ } | Select-Object -Unique)) {
                if (-not (Test-Path -LiteralPath $st)) { [Console]::Out.WriteLine("consumo: transcript da sessão não encontrado ($st) — sessão sem linha medida."); continue }
                $ms = Measure-SessionTranscript $st $since
                if ($null -eq $ms) { continue }
                $sid = [System.IO.Path]::GetFileNameWithoutExtension($st); $sid = $sid.Substring(0, [Math]::Min(8, $sid.Length))
                $model = Get-ShortModel ((@($ms.Models.Keys)) -join ',')
                $secs = [int]([Math]::Max(0, ($ms.Last - $ms.First).TotalSeconds))
                $sessionRows += [pscustomobject]@{
                    Line = ('| {0} | sessão | {1} | `sessão principal` | n/a | cerimônia | {2} | {3:N0} | {4} | medido: sessão {5}; {6} chamada(s); contexto médio {7:N0}; cache lido {8:N0}; saída {9:N0} |' -f $ms.First.ToString('yyyy-MM-dd HH:mm'), $model, $unitS, $ms.Processed, (Format-Duration $secs), $sid, $ms.Calls, [int64]($ms.Processed / $ms.Calls), $ms.CacheRead, $ms.Output)
                    Model = $model; Tokens = $ms.Processed; Seconds = $secs; Id = $sid }
            }
        }

        # ## Registro: mantém cabeçalho e as linhas que não vieram do hook; as medidas são reescritas por inteiro.
        $lines = New-Object System.Collections.ArrayList; foreach ($l in ($text -split "`r?`n")) { [void]$lines.Add($l) }
        $hi = -1; for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^##\s+Registro\b') { $hi = $i; break } }
        if ($hi -lt 0) { [Console]::Error.WriteLine("consumo: $dest sem a seção '## Registro'."); continue }
        $ts = -1; for ($i = $hi + 1; $i -lt $lines.Count; $i++) { if ($lines[$i].TrimStart().StartsWith('|')) { $ts = $i; break }; if ($lines[$i] -match '^#') { break } }
        if ($ts -lt 0) { [Console]::Error.WriteLine("consumo: $dest sem a tabela do '## Registro'."); continue }
        $te = $ts; while ($te + 1 -lt $lines.Count -and $lines[$te + 1].TrimStart().StartsWith('|')) { $te++ }
        # A linha de sessão já medida fica quando esta execução não mede a sessão (a G16 roda sem -Session).
        $kept = @(); for ($i = $ts + 2; $i -le $te; $i++) { if ($lines[$i] -notmatch 'medido:' -or (-not $Session -and $lines[$i] -match 'medido: sessão ')) { $kept += $lines[$i] } }
        $newTable = @($lines[$ts], $lines[$ts + 1]) + $kept + @($measured | ForEach-Object { $_.Line }) + @($sessionRows | ForEach-Object { $_.Line })
        $lines.RemoveRange($ts, $te - $ts + 1); $lines.InsertRange($ts, [string[]]$newTable)

        # ## Totais (derivado): uma linha por papel e modelo, e uma por operator ← chamador e modelo, das linhas mantidas +
        # medidas (sessão fica fora). v3.49: "Instâncias" (agentes distintos) e "Rodadas" (linhas do Registro) lado a lado —
        # antes uma coluna só, e o fechamento do piloto corrigiu os Totais à mão (100 instâncias × 137 rodadas).
        $agg = [ordered]@{}
        $newAgg = { param($Papel, $Modelo) @{ Papel = $Papel; Model = $Modelo; Tokens = 0L; Measured = 0; Ids = @{}; Manual = 0; Rounds = 0; Seconds = 0; Notified = 0L } }
        foreach ($k in $kept) {
            $c = Split-Row $k
            if ($c.Count -lt 9 -or ($c -join '') -match '<[^>]+>') { continue }
            $role = Clean-Cell $c[1]; if (-not $role) { continue }
            if ($role -eq 'sessão') {
                # Só a sessão medida pelo transcript entra (v3.49); a linha do /usage continua lida à parte.
                $smm = [regex]::Match($k, 'medido: sessão (\w+)')
                if ($smm.Success) {
                    $model = Clean-Cell $c[2]; $key = "sessão principal|$model"
                    if (-not $agg.Contains($key)) { $agg[$key] = & $newAgg 'sessão principal' $model }
                    $a = $agg[$key]; $t = Get-Number $c[7]; if ($null -ne $t) { $a.Tokens += $t }
                    $a.Measured++; $a.Ids['s:' + $smm.Groups[1].Value] = $true; $a.Rounds++; $a.Seconds += (Get-Seconds $c[8])
                }
                continue
            }
            $papel = if ($role -eq 'operator') { $cm = [regex]::Match($c[-1], 'chamado por (\w+)'); 'operator ← ' + $(if ($cm.Success) { $cm.Groups[1].Value } else { '?' }) } else { $role }
            $model = Clean-Cell $c[2]; $key = "$papel|$model"
            if (-not $agg.Contains($key)) { $agg[$key] = & $newAgg $papel $model }
            # Linha transcrita à mão traz o número da notificação (contexto final), não o processado: soma só na última coluna.
            # Sem agent_id, cada linha à mão conta como uma instância e uma rodada.
            $t = Get-Number $c[7]; if ($null -ne $t) { $agg[$key].Notified += $t }
            $agg[$key].Manual++; $agg[$key].Rounds++; $agg[$key].Seconds += (Get-Seconds $c[8])
        }
        foreach ($m in $measured) {
            $papel = if ($m.Role -eq 'operator') { 'operator ← ' + $(if ($m.Caller) { $m.Caller } else { '?' }) } else { $m.Role }
            $key = "$papel|$($m.Model)"
            if (-not $agg.Contains($key)) { $agg[$key] = & $newAgg $papel $m.Model }
            $a = $agg[$key]; $a.Tokens += $m.Tokens; $a.Measured++; $a.Ids[$m.AgentId] = $true; $a.Rounds++; $a.Seconds += $m.Seconds; $a.Notified += $m.Notified
        }
        foreach ($s in $sessionRows) {
            $key = "sessão principal|$($s.Model)"
            if (-not $agg.Contains($key)) { $agg[$key] = & $newAgg 'sessão principal' $s.Model }
            $a = $agg[$key]; $a.Tokens += $s.Tokens; $a.Measured++; $a.Ids['s:' + $s.Id] = $true; $a.Rounds++; $a.Seconds += $s.Seconds
        }
        $totI = -1; for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^##\s+Totais') { $totI = $i; break } }
        if ($totI -ge 0) {
            $s = -1; for ($i = $totI + 1; $i -lt $lines.Count; $i++) { if ($lines[$i].TrimStart().StartsWith('|')) { $s = $i; break }; if ($lines[$i] -match '^#') { break } }
            if ($s -ge 0) {
                $e2 = $s; while ($e2 + 1 -lt $lines.Count -and $lines[$e2 + 1].TrimStart().StartsWith('|')) { $e2++ }
                $label = if ($isBlock) { 'Total do bloco' } else { 'Total do sprint' }
                $rows = @('| Papel | Modelo | Σ tokens processados | Instâncias | Rodadas | Duração total | Σ notificação |', '|---|---|---|---|---|---|---|')
                $sumT = 0L; $sumI = 0; $sumR = 0; $sumS = 0; $sumNot = 0L
                foreach ($k in $agg.Keys) {
                    $a = $agg[$k]; $inst = $a.Ids.Count + $a.Manual
                    $sumT += $a.Tokens; $sumI += $inst; $sumR += $a.Rounds; $sumS += $a.Seconds; $sumNot += $a.Notified
                    # Grupo só com linhas à mão não tem número processado: "não medido", nunca 0 (R7).
                    $tok = if ($a.Measured) { '{0:N0}' -f $a.Tokens } else { 'não medido — só notificação' }
                    $rows += ('| {0} | {1} | {2} | {3} | {4} | {5} | {6:N0} |' -f $a.Papel, $a.Model, $tok, $inst, $a.Rounds, (Format-Duration $a.Seconds), $a.Notified)
                }
                $rows += ('| **{0}** | — | **{1:N0}** | **{2}** | **{3}** | **{4}** | **{5:N0}** |' -f $label, $sumT, $sumI, $sumR, (Format-Duration $sumS), $sumNot)
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
