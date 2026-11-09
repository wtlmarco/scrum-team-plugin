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
#   -QuotaLog (v3.53.6): o registro da cota (padrão: $env:TEAM_QUOTA_LOG, senão %USERPROFILE%\.claude\quota-log.jsonl).
# v3.53.6 (decisão do stakeholder: medir pela cota da assinatura Pro, não por US$ da API): sai a coluna US$; entra a parte da
# cota de 5 h e da semanal de cada rodada, papel, modelo e Task — a subida que a status line do plugin
# (scripts/statusline/quota-statusline.ps1) registra entre duas leituras, rateada entre o que estava ativo no intervalo.
# Exit 0 · 2 = erro de uso ou de leitura.

param(
    [string]$Root = (Get-Location).Path,
    [string]$File = '',
    [switch]$Session,
    [switch]$Print,
    [string]$QuotaLog = ''
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)
$inv = [Globalization.CultureInfo]::InvariantCulture
$ptBR = [Globalization.CultureInfo]::GetCultureInfo('pt-BR')
if (-not $QuotaLog) { $QuotaLog = if ($env:TEAM_QUOTA_LOG) { $env:TEAM_QUOTA_LOG } else { Join-Path $env:USERPROFILE '.claude\quota-log.jsonl' } }

# v3.53.6: peso de cada tipo de token e de cada modelo na cota. A Anthropic NÃO publica o peso por modelo; o padrão é a razão
# dos preços da API (entrada 1, cache gravado 1,25, cache lido 0,1, saída 5; Opus 1, Sonnet 0,5, Haiku 0,025) como
# aproximação inicial — NÃO é dinheiro. Só decide o rateio de um intervalo com mais de uma coisa ativa; a seção
# "Calibração" mostra o % por milhão de tokens medido nos intervalos com um modelo só, para trocar estes números.
# Troca por projeto: .team-project/quota-weights.json com as mesmas chaves ({"output":5,"models":{"haiku 4.5":0.25}});
# o modelo vale pelo nome curto com versão ("haiku 4.5") ou pela família ("haiku"); fora da tabela pesa 1.
$script:QuotaWeights = @{ input = 1.0; cache_write = 1.25; cache_read = 0.1; output = 5.0; models = @{ opus = 1.0; sonnet = 0.5; haiku = 0.025 } }

$short = @{ 'scrum-master' = 'sm'; 'product-owner' = 'po'; 'architect' = 'arc'; 'user-experience' = 'ux'; 'quality-assurance' = 'qa'; 'developer' = 'dev'; 'operator' = 'operator' }
# v3.52.2 (C3): o executor de Task (task-runner) é papel próprio nas tabelas — conduz a Task, não a produz: cerimônia.
# v3.57.1: o watcher da espera (antes "vigia", nome que fica nas linhas antigas) também conduz, não produz: cerimônia.
$baseCat = @{ arc = 'produção'; dev = 'produção'; qa = 'verificação'; operator = 'verificação'; sm = 'cerimônia'; po = 'especificação'; ux = 'especificação'; 'task-runner' = 'cerimônia'; watcher = 'cerimônia'; vigia = 'cerimônia' }

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
    # v3.52.2 (C5): Q-S<n> sob "## Correção do portão" tem a unidade 'correção do portão'; Habilitadora, a sua.
    $map = @{}; $cur = $null
    foreach ($line in ($Board -split "`r?`n")) {
        if ($line -match '^##\s') { $cur = Get-BoardGroup $line; continue }
        if ($cur -and $line.TrimStart().StartsWith('|')) {
            $tm = [regex]::Match((Split-Row $line)[0], "($($script:TaskIdRe))"); if ($tm.Success -and -not $map.ContainsKey($tm.Groups[1].Value)) { $map[$tm.Groups[1].Value] = $cur }
        }
    }
    return $map
}

# Sessão principal (v3.49): soma o usage das chamadas dela desde $Since, deduplicado por message.id (vale o último) e por
# uuid (o harness regrava linhas antigas antes de uma compactação). O transcript da sessão não tem os subagentes: cada um
# tem o seu, medido pela G16 — as duas somas se acrescentam, não se sobrepõem.
# v3.53.6: Points = uma chamada por ponto (hora, modelo, tokens ponderados por tipo) — o rateio da cota usa a hora de cada
# chamada da sessão, não o intervalo inteiro.
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
    $r = @{ Calls = $order.Count; Processed = 0L; CacheRead = 0L; Output = 0L; Models = @{}; First = $calls[$order[0]].ts; Last = $calls[$order[$order.Count - 1]].ts; Points = New-Object System.Collections.ArrayList }
    foreach ($id in $order) {
        $u = $calls[$id].u
        [void]$r.Points.Add(@{ At = (ConvertTo-Epoch $calls[$id].ts); Model = $calls[$id].model; T = (Get-TypeTokens $u.input_tokens $u.cache_creation_input_tokens $u.cache_read_input_tokens $u.output_tokens) })
        $r.Processed += [int64]$u.input_tokens + [int64]$u.cache_creation_input_tokens + [int64]$u.cache_read_input_tokens + [int64]$u.output_tokens
        $r.CacheRead += [int64]$u.cache_read_input_tokens; $r.Output += [int64]$u.output_tokens
        if ($calls[$id].model) { $r.Models[$calls[$id].model] = $true }
    }
    return $r
}

# ---- Cota da assinatura (v3.53.6) ----
function ConvertTo-Epoch([datetime]$D) { return [double]([DateTimeOffset]$D).ToUnixTimeSeconds() }   # hora sem fuso = hora local
function ConvertFrom-Epoch([double]$E) { return [DateTimeOffset]::FromUnixTimeSeconds([int64]$E).LocalDateTime }

# Tokens ponderados por tipo ("equivalente de entrada"), sem o fator do modelo.
function Get-TypeTokens($In, $Cw, $Cr, $Out) {
    $w = $script:QuotaWeights
    return [double]$In * $w.input + [double]$Cw * $w.cache_write + [double]$Cr * $w.cache_read + [double]$Out * $w.output
}

# Fator do modelo na cota; rodada com mais de um modelo ("a,b") usa a média — o usage.jsonl não separa os tokens por modelo.
function Get-ModelFactor([string]$Model) {
    $fs = @()
    foreach ($m in ($Model -split ',')) {
        if (-not $m.Trim()) { continue }
        $s = Get-ShortModel $m; $fam = ($s -split ' ')[0]
        if ($script:QuotaWeights.models.ContainsKey($s)) { $fs += [double]$script:QuotaWeights.models[$s] }
        elseif ($script:QuotaWeights.models.ContainsKey($fam)) { $fs += [double]$script:QuotaWeights.models[$fam] }
        else { $fs += 1.0 }
    }
    if (-not $fs.Count) { return 1.0 }
    return ($fs | Measure-Object -Average).Average
}

# .team-project/quota-weights.json troca as chaves que trouxer; ilegível → valem os padrões (avisa no fim).
function Import-QuotaWeights([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return '' }
    try {
        $j = (Read-Text $Path) | ConvertFrom-Json
        foreach ($k in 'input', 'cache_write', 'cache_read', 'output') { if ($null -ne $j.$k) { $script:QuotaWeights[$k] = [double]$j.$k } }
        if ($j.models) { foreach ($p in $j.models.PSObject.Properties) { $script:QuotaWeights.models[[string]$p.Name] = [double]$p.Value } }
        return 'quota-weights.json'
    } catch { return 'quota-weights.json ilegível — valem os pesos padrão' }
}

# Leituras do registro da cota (o rodado .1.jsonl primeiro) entre $From e $To (epoch), com folga de 8 dias para trás — a
# leitura anterior ao período é a base do primeiro intervalo. Lido por regex (o formato é o da status line do plugin).
function Read-QuotaLog([string]$Path, [double]$From, [double]$To) {
    $snaps = New-Object System.Collections.ArrayList
    $lo = (ConvertFrom-Epoch ($From - 8 * 86400)).ToString('yyyy-MM-ddTHH:mm:ss'); $hi = (ConvertFrom-Epoch ($To + 86400)).ToString('yyyy-MM-ddTHH:mm:ss')
    $rot = [System.IO.Path]::Combine((Split-Path -Parent $Path), [System.IO.Path]::GetFileNameWithoutExtension($Path) + '.1.jsonl')
    $num = { param($L, $K) $m = [regex]::Match($L, '"' + $K + '":(-?[\d.]+)'); if ($m.Success) { [double]::Parse($m.Groups[1].Value, $inv) } else { $null } }
    foreach ($f in @($rot, $Path)) {
        if (-not (Test-Path -LiteralPath $f)) { continue }
        foreach ($line in [System.IO.File]::ReadLines($f)) {
            $am = [regex]::Match($line, '"at":"([^"]+)"'); if (-not $am.Success) { continue }
            $at = $am.Groups[1].Value
            if ([string]::CompareOrdinal($at, $lo) -lt 0 -or [string]::CompareOrdinal($at, $hi) -gt 0) { continue }
            try { $t = ConvertTo-Epoch ([datetime]::ParseExact($at, 'yyyy-MM-ddTHH:mm:ss', $inv)) } catch { continue }
            [void]$snaps.Add(@{ T = $t; Five = (& $num $line 'five'); FiveR = (& $num $line 'fiveReset'); Week = (& $num $line 'week'); WeekR = (& $num $line 'weekReset') })
        }
    }
    return @($snaps | Sort-Object { $_.T })
}

# Subida de uma janela entre duas leituras. Reinício (o resets_at andou mais de 10 min, a leitura nova é posterior ao
# reinício anterior, ou o percentual caiu): conta do zero — o que se gastou na janela velha depois da última leitura se perde.
# Janela que não vinha no JSON e passou a vir: começou agora, conta do zero.
function Get-QuotaDelta($P, $PR, $C, $CR, [double]$At) {
    if ($null -eq $C) { return 0.0 }
    if ($null -eq $P) { return [double]$C }
    if (($null -ne $PR -and $null -ne $CR -and ([double]$CR - [double]$PR) -gt 600) -or ($null -ne $PR -and $At -ge [double]$PR) -or ([double]$C -lt [double]$P - 0.05)) { return [double]$C }
    return [Math]::Max(0.0, [double]$C - [double]$P)
}

# Rateio: cada intervalo (leitura i-1, leitura i] reparte a subida entre as atividades ativas nele, pelo peso (tokens
# ponderados por tipo × fator do modelo) que cada uma tem no intervalo — rodada espalhada por igual do início ao fim
# (start + duração + pausa), chamada da sessão num ponto. Intervalo sem atividade: "sem rodada medida".
# $Acts: @{ Key; S; E (epoch); T (tokens ponderados por tipo); F (fator do modelo); Model (nome curto) }.
function Measure-Quota($Snaps, $Acts) {
    $res = @{ Five = @{}; Week = @{}; Free =New-Object System.Collections.ArrayList; Cal = @{}; Times = @() }
    $n = @($Snaps).Count
    if ($n -lt 2) { return $res }
    $times = [double[]]@($Snaps | ForEach-Object { $_.T }); $res.Times = $times
    $d5 = New-Object 'double[]' $n; $dW = New-Object 'double[]' $n; $tot = New-Object 'double[]' $n
    for ($i = 1; $i -lt $n; $i++) {
        $a = $Snaps[$i - 1]; $b = $Snaps[$i]
        $d5[$i] = Get-QuotaDelta $a.Five $a.FiveR $b.Five $b.FiveR $b.T
        $dW[$i] = Get-QuotaDelta $a.Week $a.WeekR $b.Week $b.WeekR $b.T
    }
    $contrib = New-Object System.Collections.ArrayList; $mods = @{}
    foreach ($act in $Acts) {
        $S = [double]$act.S; $E = [double]$act.E
        $w0 = [double]$act.T * [double]$act.F
        if ($w0 -le 0) { continue }
        # Primeiro intervalo cujo fim alcança o início da atividade (busca binária).
        $lo = 1; $hi = $n - 1
        while ($lo -lt $hi) { $mid = [int][Math]::Floor(($lo + $hi) / 2); if ($times[$mid] -ge $S) { $hi = $mid } else { $lo = $mid + 1 } }
        for ($i = $lo; $i -lt $n; $i++) {
            if ($E -gt $S) {
                if ($times[$i - 1] -ge $E) { break }
                $ov = [Math]::Min($E, $times[$i]) - [Math]::Max($S, $times[$i - 1]); if ($ov -le 0) { continue }
                $frac = $ov / ($E - $S)
            } else {
                if ($times[$i - 1] -ge $S) { break }
                if ($S -gt $times[$i]) { continue }
                $frac = 1.0
            }
            $w = $w0 * $frac; $tot[$i] += $w
            [void]$contrib.Add(@{ Key = $act.Key; I = $i; W = $w })
            if (-not $mods.ContainsKey($i)) { $mods[$i] = @{} }
            $mods[$i][[string]$act.Model] = [double]$mods[$i][[string]$act.Model] + [double]$act.T * $frac
        }
    }
    foreach ($c in $contrib) {
        $i = $c.I; $sh = $c.W / $tot[$i]
        $res.Five[$c.Key] = [double]$res.Five[$c.Key] + $d5[$i] * $sh
        $res.Week[$c.Key] = [double]$res.Week[$c.Key] + $dW[$i] * $sh
    }
    for ($i = 1; $i -lt $n; $i++) {
        if ($tot[$i] -le 0) {
            if ($d5[$i] -gt 0 -or $dW[$i] -gt 0) { [void]$res.Free.Add(@{ A = $times[$i - 1]; B = $times[$i]; Five = $d5[$i]; Week = $dW[$i] }) }
        } elseif ($mods[$i].Count -eq 1) {
            # Calibração: um modelo só ativo no intervalo → % por milhão de tokens (equivalente de entrada) daquele modelo.
            $m = @($mods[$i].Keys)[0]
            if (-not $res.Cal.ContainsKey($m)) { $res.Cal[$m] = @{ N = 0; Tok = 0.0; Five = 0.0; Week = 0.0 } }
            $k = $res.Cal[$m]; $k.N++; $k.Tok += $mods[$i][$m]; $k.Five += $d5[$i]; $k.Week += $dW[$i]
        }
    }
    return $res
}

# Cobertura de [S, E] pelas leituras: 'ok' (leitura antes e depois), 'parcial' (a última leitura é anterior ao fim — a
# G16 roda antes da próxima leitura; a execução seguinte completa), 'sem'.
function Get-QuotaCover($Times, [double]$S, [double]$E) {
    $n = @($Times).Count
    if ($n -lt 2) { return 'sem' }
    if ($Times[0] -le $S -and $Times[$n - 1] -ge $E) { return 'ok' }
    if ($Times[0] -lt [Math]::Max($E, $S + 1) -and $Times[$n - 1] -gt $S) { return 'parcial' }
    return 'sem'
}

function Format-Pct([double]$V) {
    if ($V -gt 0 -and $V -lt 0.05) { return '+<0,1%' }
    return '+' + $V.ToString('N1', $ptBR) + '%'
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

    # v3.53.6: cota da assinatura — atividade de TODAS as rodadas do usage.jsonl (a de outro destino gasta a mesma cota no
    # mesmo intervalo e entra no rateio) e as leituras do registro da cota desde a primeira rodada.
    $weightsNote = Import-QuotaWeights (Join-Path $tp 'quota-weights.json')
    $roundActs = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt $usage.Count; $i++) {
        $u = $usage[$i]; $qk = "r:$i"
        $u | Add-Member -NotePropertyName '_qk' -NotePropertyValue $qk -Force
        if (-not $u.start) { continue }
        try { $s0 = ConvertTo-Epoch ([datetime][string]$u.start) } catch { continue }
        $e0 = $s0 + [double]$u.duration_s + $(if ($u.PSObject.Properties['paused_s']) { [double]$u.paused_s } else { 0 })
        # Linha da G16 traz os tipos (input, cache_write, cache_read, output); linha sem eles (anterior, à mão) pesa o processado como entrada.
        $tt = if ($u.PSObject.Properties['input']) { Get-TypeTokens $u.input $u.cache_write $u.cache_read $u.output } else { [double]$u.processed * $script:QuotaWeights.input }
        [void]$roundActs.Add(@{ Key = $qk; S = $s0; E = $e0; T = $tt; F = (Get-ModelFactor ([string]$u.model)); Model = (Get-ShortModel ([string]$u.model)) })
    }
    $quotaRot = [System.IO.Path]::Combine((Split-Path -Parent $QuotaLog), [System.IO.Path]::GetFileNameWithoutExtension($QuotaLog) + '.1.jsonl')
    $snaps = @()
    if ($roundActs.Count -and ((Test-Path -LiteralPath $QuotaLog) -or (Test-Path -LiteralPath $quotaRot))) {
        $snaps = @(Read-QuotaLog $QuotaLog (($roundActs | ForEach-Object { $_.S }) | Measure-Object -Minimum).Minimum (ConvertTo-Epoch (Get-Date)))
    }

    $dests =if ($File) { @($File -replace '\\', '/') } else { @($usage | ForEach-Object { [string]$_.dest } | Where-Object { $_ } | Select-Object -Unique) }
    if ($dests.Count -eq 0) { [Console]::Out.WriteLine('consumo: nenhuma linha medida em .team-project/usage.jsonl — nada a gravar.'); exit 0 }

    foreach ($dest in $dests) {
        $path = Join-Path $Root $dest
        if (-not (Test-Path -LiteralPath $path)) { [Console]::Out.WriteLine("consumo: $dest não existe — linhas medidas ficam no usage.jsonl. Bloco de fix: a G16 o cria na primeira rodada (kanban.ps1 -Block B-<nnn> -Init); sprint: nasce no sprint plan; fora de sprint: no /team init."); continue }
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
            # v3.52.2 (C3): o filho do executor de Task (dev, Arquiteto, QA) também diz quem o chamou, pelo agentId em children.
            if ($caller.ContainsKey([string]$u.agent_id)) { $note += "chamado por $($caller[[string]$u.agent_id])$(if ($inferred.ContainsKey([string]$u.agent_id)) { ' (pelo horário)' });" }
            # v3.53.6: sem US$ na Nota (decisão do stakeholder) — a parte da cota entra depois do rateio (abaixo).
            $note += ("medido: {0}#{1}; notificação ≈ {2:N0}; cache lido {3:N0}; saída {4:N0}; {5} chamada(s); contexto 1ª/pico {6:N0}/{7:N0}" -f $u.agent_id, $u.round, [int64]$u.final_context, [int64]$u.cache_read, [int64]$u.output, $u.calls, [int64]$u.first_context, [int64]$u.peak_context) + $(if ($u.PSObject.Properties['plugin'] -and $u.plugin) { "; plugin $($u.plugin)" } else { '' })   # v3.53.1: versão na rodada
            $cmd = if ($u.description) { '`Agent` · ' + ([string]$u.description -replace '\|', '/') } else { '`Agent`' }
            $qs = $null; $qe = $null
            if ($u.start) { try { $qs = ConvertTo-Epoch ([datetime][string]$u.start); $qe = $qs + [double]$u.duration_s + $(if ($u.PSObject.Properties['paused_s']) { [double]$u.paused_s } else { 0 }) } catch { } }
            $measured += [pscustomobject]@{
                Head = ('| {0} | {1} | {2} | {3} | {4} | {5} | {6} | {7:N0} | {8} | ' -f ([string]$u.start).Replace('T', ' ').Substring(0, 16), $role, (Get-ShortModel ([string]$u.model)), $cmd, $work, $cat, $unit, [int64]$u.processed, (Format-Duration ([int]$u.duration_s)))
                Note = ($note -join ' '); Line = ''; QKey = [string]$u._qk; QS = $qs; QE = $qe; Work = $work
                Role = $role; AgentId = [string]$u.agent_id; Caller = $(if ($role -eq 'operator' -and $caller.ContainsKey([string]$u.agent_id)) { $caller[[string]$u.agent_id] } else { '' })
                Model = (Get-ShortModel ([string]$u.model)); Tokens = [int64]$u.processed; Seconds = [int]$u.duration_s; Notified = [int64]$u.final_context; Q5 = $null; QW = $null
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
                    Head = ('| {0} | sessão | {1} | `sessão principal` | n/a | cerimônia | {2} | {3:N0} | {4} | ' -f $ms.First.ToString('yyyy-MM-dd HH:mm'), $model, $unitS, $ms.Processed, (Format-Duration $secs))
                    Note = ('medido: sessão {0}; {1} chamada(s); contexto médio {2:N0}; cache lido {3:N0}; saída {4:N0}' -f $sid, $ms.Calls, [int64]($ms.Processed / $ms.Calls), $ms.CacheRead, $ms.Output)
                    Line = ''; QKey = "s:$sid"; QS = (ConvertTo-Epoch $ms.First); QE = (ConvertTo-Epoch $ms.Last); Points = $ms.Points; Work = 'sessão principal'
                    Model = $model; Tokens = $ms.Processed; Seconds = $secs; Id = $sid; Q5 = $null; QW = $null }
            }
        }

        # v3.53.6: rateio da cota — rodadas de todos os destinos + chamadas das sessões medidas aqui; cada linha deste
        # destino ganha "cota 5h +x% · semana +y%" na Nota ("(parcial)" sem leitura depois do fim; "cota sem registro").
        $acts = New-Object System.Collections.ArrayList; foreach ($a in $roundActs) { [void]$acts.Add($a) }
        foreach ($sr in $sessionRows) { foreach ($pt in $sr.Points) { [void]$acts.Add(@{ Key = $sr.QKey; S = $pt.At; E = $pt.At; T = $pt.T; F = (Get-ModelFactor ([string]$pt.Model)); Model = (Get-ShortModel ([string]$pt.Model)) }) } }
        $q = Measure-Quota $snaps $acts
        $pS = $null; $pE = $null
        foreach ($m in @($measured) + @($sessionRows)) {
            if ($null -ne $m.QS) { if ($null -eq $pS -or $m.QS -lt $pS) { $pS = $m.QS }; if ($null -eq $pE -or $m.QE -gt $pE) { $pE = $m.QE } }
        }
        $quotaOn = ($null -ne $pS) -and ((Get-QuotaCover $q.Times $pS $pE) -ne 'sem')
        foreach ($m in @($measured) + @($sessionRows)) {
            $qn = ''
            if ($quotaOn) {
                $cv = if ($null -ne $m.QS) { Get-QuotaCover $q.Times $m.QS $m.QE } else { 'sem' }
                if ($cv -eq 'sem') { $qn = '; cota sem registro' }
                else {
                    $m.Q5 = [double]$q.Five[$m.QKey]; $m.QW = [double]$q.Week[$m.QKey]
                    $qn = '; cota 5h ' + (Format-Pct $m.Q5) + ' · semana ' + (Format-Pct $m.QW) + $(if ($cv -eq 'parcial') { ' (parcial)' } else { '' })
                }
            }
            $m.Line = $m.Head + $m.Note + $qn + ' |'
        }

        # ## Registro: mantém cabeçalho e as linhas que não vieram do hook; as medidas são reescritas por inteiro.
        $lines = New-Object System.Collections.ArrayList; foreach ($l in ($text -split "`r?`n")) { [void]$lines.Add($l) }
        $hi = -1; for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^##\s+Registro\b') { $hi = $i; break } }
        if ($hi -lt 0) { [Console]::Error.WriteLine("consumo: $dest sem a seção '## Registro'."); continue }
        $ts = -1; for ($i = $hi + 1; $i -lt $lines.Count; $i++) { if ($lines[$i].TrimStart().StartsWith('|')) { $ts = $i; break }; if ($lines[$i] -match '^#') { break } }
        if ($ts -lt 0) { [Console]::Error.WriteLine("consumo: $dest sem a tabela do '## Registro'."); continue }
        $te = $ts; while ($te + 1 -lt $lines.Count -and $lines[$te + 1].TrimStart().StartsWith('|')) { $te++ }
        # A linha de sessão já medida fica quando esta execução não mede a sessão (a G16 roda sem -Session).
        # v3.53.6: sem -Session a sessão não entra no rateio (a parte dela cai nas rodadas do intervalo) — a cota antiga da
        # linha de sessão mantida sai da Nota, para não contar duas vezes.
        $kept = @(); for ($i = $ts + 2; $i -le $te; $i++) {
            if ($lines[$i] -notmatch 'medido:') { $kept += $lines[$i] }
            elseif (-not $Session -and $lines[$i] -match 'medido: sessão ') { $kept += ($lines[$i] -replace '; cota (5h|sem registro)[^;|]*', '') }
        }
        $newTable = @($lines[$ts], $lines[$ts + 1]) + $kept + @($measured | ForEach-Object { $_.Line }) + @($sessionRows | ForEach-Object { $_.Line })
        $lines.RemoveRange($ts, $te - $ts + 1); $lines.InsertRange($ts, [string[]]$newTable)

        # ## Totais (derivado): uma linha por papel e modelo, e uma por operator ← chamador e modelo, das linhas mantidas +
        # medidas (sessão fica fora). v3.49: "Instâncias" (agentes distintos) e "Rodadas" (linhas do Registro) lado a lado —
        # antes uma coluna só, e o fechamento do piloto corrigiu os Totais à mão (100 instâncias × 137 rodadas).
        $agg = [ordered]@{}
        # v3.53.6: Q5/QW = parte da cota de 5 h e da semanal ($null = grupo sem cota: linha à mão, sessão sem -Session, sem registro).
        $newAgg = { param($Papel, $Modelo) @{ Papel = $Papel; Model = $Modelo; Tokens = 0L; Measured = 0; Ids = @{}; Manual = 0; Rounds = 0; Seconds = 0; Notified = 0L; Q5 = $null; QW = $null } }
        $addQ = { param($A, $M) if ($null -ne $M.Q5) { $A.Q5 = [double]$A.Q5 + $M.Q5; $A.QW = [double]$A.QW + $M.QW } }
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
            $papel = if ($role -eq 'operator') { $cm = [regex]::Match($c[-1], 'chamado por ([\w-]+)'); 'operator ← ' + $(if ($cm.Success) { $cm.Groups[1].Value } else { '?' }) } else { $role }
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
            & $addQ $a $m
        }
        foreach ($s in $sessionRows) {
            $key = "sessão principal|$($s.Model)"
            if (-not $agg.Contains($key)) { $agg[$key] = & $newAgg 'sessão principal' $s.Model }
            $a = $agg[$key]; $a.Tokens += $s.Tokens; $a.Measured++; $a.Ids['s:' + $s.Id] = $true; $a.Rounds++; $a.Seconds += $s.Seconds
            & $addQ $a $s
        }
        $totI = -1; for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^##\s+Totais') { $totI = $i; break } }
        if ($totI -ge 0) {
            $s = -1; for ($i = $totI + 1; $i -lt $lines.Count; $i++) { if ($lines[$i].TrimStart().StartsWith('|')) { $s = $i; break }; if ($lines[$i] -match '^#') { break } }
            if ($s -ge 0) {
                $e2 = $s; while ($e2 + 1 -lt $lines.Count -and $lines[$e2 + 1].TrimStart().StartsWith('|')) { $e2++ }
                $label = if ($isBlock) { 'Total do bloco' } else { 'Total do sprint' }
                # v3.53.6 (decisão do stakeholder): sai a coluna US$ (preço da API — o stakeholder paga a assinatura Pro, não
                # token); entram "Cota 5h" e "Cota semana", a parte da cota rateada (seção "Cota da assinatura"); "—" = grupo sem
                # cota (linha à mão, sessão sem -Session, sem registro da status line).
                $rows = @('| Papel | Modelo | Σ tokens processados | Instâncias | Rodadas | Duração total | Σ notificação | Cota 5h | Cota semana |', '|---|---|---|---|---|---|---|---|---|')
                $sumT = 0L; $sumI = 0; $sumR = 0; $sumS = 0; $sumNot = 0L; $sum5 = $null; $sumW = $null
                foreach ($k in $agg.Keys) {
                    $a = $agg[$k]; $inst = $a.Ids.Count + $a.Manual
                    $sumT += $a.Tokens; $sumI += $inst; $sumR += $a.Rounds; $sumS += $a.Seconds; $sumNot += $a.Notified
                    if ($null -ne $a.Q5) { $sum5 = [double]$sum5 + $a.Q5; $sumW = [double]$sumW + $a.QW }
                    # Grupo só com linhas à mão não tem número processado: "não medido", nunca 0 (R7).
                    $tok = if ($a.Measured) { '{0:N0}' -f $a.Tokens } else { 'não medido — só notificação' }
                    $rows += ('| {0} | {1} | {2} | {3} | {4} | {5} | {6:N0} | {7} | {8} |' -f $a.Papel, $a.Model, $tok, $inst, $a.Rounds, (Format-Duration $a.Seconds), $a.Notified, $(if ($null -ne $a.Q5) { Format-Pct $a.Q5 } else { '—' }), $(if ($null -ne $a.QW) { Format-Pct $a.QW } else { '—' }))
                }
                $rows += ('| **{0}** | — | **{1:N0}** | **{2}** | **{3}** | **{4}** | **{5:N0}** | **{6}** | **{7}** |' -f $label, $sumT, $sumI, $sumR, (Format-Duration $sumS), $sumNot, $(if ($null -ne $sum5) { Format-Pct $sum5 } else { '—' }), $(if ($null -ne $sumW) { Format-Pct $sumW } else { '—' }))
                $lines.RemoveRange($s, $e2 - $s + 1); $lines.InsertRange($s, [string[]]$rows)
            }
        }

        # ## Cota da assinatura (derivado, v3.53.6): por modelo, total do destino, sem rodada medida, por Task e calibração.
        # Reescrita por inteiro; sem a seção (registro antigo), entra antes de "## Relação com" ou no fim.
        $totLabel = if ($isBlock) { 'Total do bloco' } elseif ($sm.Success) { 'Total do sprint' } else { 'Total' }
        $sec = @('## Cota da assinatura (derivado)', '', '*(Reescrita pelo `consumption.ps1` a cada execução — não se edita à mão. Fonte: o registro da cota que a status line do plugin grava (`scripts/statusline/quota-statusline.ps1`, how-to). A subida da cota entre duas leituras é rateada entre as rodadas ativas no intervalo, pelos tokens ponderados por tipo e modelo — peso aproximado pela razão dos preços da API, **não é dinheiro**.)*', '')
        $quotaSummary = 'sem registro da cota'
        if (-not $quotaOn) {
            $sec += 'sem registro da cota — ative a status line do plugin (how-to). Os tokens acima continuam medidos.'
        } else {
            $withQ = @(@($measured) + @($sessionRows) | Where-Object { $null -ne $_.Q5 })
            $t5 = 0.0; $tW = 0.0; foreach ($m in $withQ) { $t5 += $m.Q5; $tW += $m.QW }
            $f5 = 0.0; $fW = 0.0; foreach ($fr in $q.Free) { if ($fr.A -lt $pE -and $fr.B -gt $pS) { $f5 += $fr.Five; $fW += $fr.Week } }
            $nRead = @($q.Times | Where-Object { $_ -ge $pS -and $_ -le $pE }).Count
            $sec += ('Período: {0} → {1} · {2} leitura(s) da cota no período{3}' -f (ConvertFrom-Epoch $pS).ToString('yyyy-MM-dd HH:mm'), (ConvertFrom-Epoch $pE).ToString('yyyy-MM-dd HH:mm'), $nRead, $(if ($weightsNote) { " · pesos: $weightsNote" } else { '' }))
            if (-not $Session) { $sec += '', '> Sem `-Session` (a G16 roda assim): a sessão principal não entra no rateio e a parte dela cai nas rodadas do mesmo intervalo — leia a cota de cada rodada como teto. O `close` e a retrospectiva rodam com `-Session`.' }
            $sec += '', '| Modelo | Rodadas | Cota 5h | Cota semana |', '|---|---|---|---|'
            foreach ($g in @($withQ | Group-Object Model | Sort-Object Name)) {
                $g5 = 0.0; $gW = 0.0; foreach ($m in $g.Group) { $g5 += $m.Q5; $gW += $m.QW }
                $sec += ('| {0} | {1} | {2} | {3} |' -f $g.Name, $g.Count, (Format-Pct $g5), (Format-Pct $gW))
            }
            $sec += ('| **{0}** (rodadas{1}) | **{2}** | **{3}** | **{4}** |' -f $totLabel, $(if ($Session) { ' + sessão medida' } else { '' }), $withQ.Count, (Format-Pct $t5), (Format-Pct $tW))
            $sec += ('| sem rodada medida no intervalo *(sessão sem `-Session`, outro projeto, uso fora do time)* | — | {0} | {1} |' -f (Format-Pct $f5), (Format-Pct $fW))
            $sec += '', '### Por Task', '', '| Task | Rodadas | Cota 5h | Cota semana |', '|---|---|---|---|'
            foreach ($g in @($withQ | Group-Object Work | Sort-Object Name)) {
                $g5 = 0.0; $gW = 0.0; foreach ($m in $g.Group) { $g5 += $m.Q5; $gW += $m.QW }
                $sec += ('| {0} | {1} | {2} | {3} |' -f $g.Name, $g.Count, (Format-Pct $g5), (Format-Pct $gW))
            }
            # Calibração: o peso oficial por modelo não é publicado; o % por milhão de tokens (equivalente de entrada) medido
            # onde um modelo só estava ativo dá a razão entre os modelos — troque os fatores em quota-weights.json por ela.
            $sec += '', '### Calibração dos pesos (intervalos com um modelo só ativo)', ''
            if ($q.Cal.Count) {
                $sec += '| Modelo | Intervalos | Mi tokens (equivalente de entrada) | % 5h por mi | % semana por mi |', '|---|---|---|---|---|'
                foreach ($m in @($q.Cal.Keys | Sort-Object)) {
                    $k = $q.Cal[$m]; $mt = $k.Tok / 1e6
                    $sec += ('| {0} | {1} | {2} | {3} | {4} |' -f $m, $k.N, $mt.ToString('N2', $ptBR), $(if ($mt -gt 0) { ($k.Five / $mt).ToString('N3', $ptBR) } else { '—' }), $(if ($mt -gt 0) { ($k.Week / $mt).ToString('N3', $ptBR) } else { '—' }))
                }
                if (-not $Session) { $sec += '', '*(Sem `-Session` a sessão principal também gasta nesses intervalos — calibre pelo número do `close`.)*' }
            } else { $sec += 'nenhum intervalo com um modelo só ativo — sem calibração ainda.' }
            $quotaSummary = 'cota 5h ' + (Format-Pct $t5) + ' · semana ' + (Format-Pct $tW)
        }
        $ci = -1; for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^##\s+Cota da assinatura') { $ci = $i; break } }
        if ($ci -ge 0) {
            $ce = $lines.Count; for ($i = $ci + 1; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^##\s') { $ce = $i; break } }
            if ($ce -lt $lines.Count) { $sec += '' }
            $lines.RemoveRange($ci, $ce - $ci); $lines.InsertRange($ci, [string[]]$sec)
        } else {
            $ri = -1; for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^##\s+Relação com') { $ri = $i; break } }
            if ($ri -ge 0) { $lines.InsertRange($ri, [string[]]($sec + @(''))) }
            else {
                while ($lines.Count -and -not $lines[$lines.Count - 1].Trim()) { $lines.RemoveAt($lines.Count - 1) }
                [void]$lines.Add(''); $lines.AddRange([string[]]$sec)
            }
        }

        $result = ($lines -join "`n")
        if ($Print) { [Console]::Out.WriteLine("---- $dest"); [Console]::Out.WriteLine($result) }
        else { [System.IO.File]::WriteAllText($path, $result, $utf8); [Console]::Out.WriteLine("consumo: $dest — $($measured.Count) linha(s) medida(s), $($kept.Count) mantida(s); $quotaSummary.") }
    }
    exit 0
} catch {
    [Console]::Error.WriteLine("consumo: erro — $($_.Exception.Message)")
    exit 2
}
