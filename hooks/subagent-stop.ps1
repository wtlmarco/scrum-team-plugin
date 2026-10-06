# SubagentStop — G16 (v3.45): o consumo de cada rodada de subagente vira uma linha em .team-project/usage.jsonl,
# medida no transcript do próprio subagente — a sessão deixa de transcrever números da notificação à mão.
# Por quê: o número da notificação ("subagent_tokens") é o tamanho do contexto na ÚLTIMA chamada ao modelo, não a soma
# do que o subagente processou (medido em 06/10/2026: 49 004 notificados × 273 190 processados; 53 245 × 322 194).
# Uma linha por rodada: a retomada por SendMessage acrescenta chamadas ao mesmo transcript, e a linha seguinte traz só o delta.
# Só registra; nunca bloqueia. Qualquer exceção → exit 1 (falha aberta, D5). Cobertura e limites: hooks/COVERAGE.md.

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

# Transcript do subagente: o campo do evento, se vier; senão <dir do transcript da sessão>/<sessão>/subagents/agent-<id>.jsonl.
function Get-AgentTranscript([object]$HookInput) {
    foreach ($name in 'agent_transcript_path', 'subagent_transcript_path') {
        $p = $HookInput.PSObject.Properties[$name]
        if ($p -and $p.Value -and (Test-Path -LiteralPath ([string]$p.Value))) { return [string]$p.Value }
    }
    $parent = [string]$HookInput.transcript_path
    $id = [string]$HookInput.agent_id
    if (-not $parent -or -not $id) { return $null }
    $dir = Join-Path (Split-Path $parent) ([System.IO.Path]::GetFileNameWithoutExtension($parent))
    $cand = Join-Path $dir "subagents/agent-$id.jsonl"
    if (Test-Path -LiteralPath $cand) { return $cand }
    return $null
}

# ID de trabalho no texto: Task, Correção, bloco ou História — o primeiro que aparece.
function Get-WorkId([string]$Text) {
    $m = [regex]::Match($Text, '(?<![\w-])(T-\d+[a-z]?|F-\d+|B-\d+|H-\d+)(?![\w])')
    if ($m.Success) { return $m.Value }
    return $null
}

# Destino do registro (templates/consumption.md §Como gravar, regra 1): bloco fix aberto citado → fixes/B-nnn/;
# sprint aberto → sprints/<n>/; senão o registro fora de sprint. Calculado na hora — sprint ou bloco fechado nunca recebe linha.
function Get-Destination([string]$ProjectDir, [string]$WorkId, [object]$Run) {
    $tp = Join-Path $ProjectDir '.team-project'
    $block = $null
    if ($WorkId -match '^B-\d+$') { $block = $WorkId }
    elseif ($null -ne $Run -and [string]$Run.trilha -eq 'fix') { $block = [string]$Run.id }
    if ($block) {
        $bdir = Join-Path $tp "fixes/$block"
        $verdict = Join-Path $bdir 'verdict.md'
        $closed = (Test-Path -LiteralPath $verdict) -and ([System.IO.File]::ReadAllText($verdict) -match '(?m)^##\s+Fechamento')
        if ((Test-Path -LiteralPath $bdir) -and -not $closed) { return @{ dest = ".team-project/fixes/$block/consumption.md"; sprint = $null } }
    }
    $readme = Join-Path $tp 'README.md'
    if (Test-Path -LiteralPath $readme) {
        $m = [regex]::Match([System.IO.File]::ReadAllText($readme), '(?m)^\|\s*\*\*Sprint corrente\*\*\s*\|\s*\*\*(\d+)\*\*')
        if ($m.Success) {
            $n = $m.Groups[1].Value
            $sd = Join-Path $tp "sprints/$n"
            if ((Test-Path -LiteralPath (Join-Path $sd 'consumption.md')) -and -not (Test-Path -LiteralPath (Join-Path $sd 'retrospective.md'))) {
                return @{ dest = ".team-project/sprints/$n/consumption.md"; sprint = $n }
            }
            return @{ dest = '.team-project/consumption.md'; sprint = $null; note = 'entre-sprints' }
        }
    }
    return @{ dest = '.team-project/consumption.md'; sprint = $null; note = 'pre-sprint' }
}

try {
    $hookInput = Read-HookInput
    if ($null -eq $hookInput) { exit 0 }
    $projectDir = Get-ProjectDir $hookInput
    $tp = Join-Path $projectDir '.team-project'
    if (-not (Test-Path -LiteralPath $tp)) { exit 0 }                       # projeto sem o time: silêncio
    $cfg = Get-GuardConfig $projectDir
    if ($cfg.probe) { Write-GuardLog $projectDir 'probe' $hookInput '' ("subagent-stop campos=" + ($hookInput.PSObject.Properties.Name -join ',')) }
    if (-not (Test-GuardEnabled $cfg 'G16')) { exit 0 }

    $agentId = [string]$hookInput.agent_id
    $transcript = Get-AgentTranscript $hookInput
    if (-not $transcript) { Write-GuardLog $projectDir 'G16' $hookInput 'consumo' "transcript do subagente não encontrado (agent_id=$agentId) — rodada sem linha em usage.jsonl"; exit 0 }
    if (-not $agentId) { $agentId = ([System.IO.Path]::GetFileNameWithoutExtension($transcript)) -replace '^agent-', '' }

    # Tipo e descrição: do evento, ou do .meta.json gravado pelo harness ao lado do transcript.
    $agentType = [string]$hookInput.agent_type
    $description = ''
    $meta = [System.IO.Path]::ChangeExtension($transcript, '.meta.json')
    if (Test-Path -LiteralPath $meta) {
        try {
            $mj = Get-Content -LiteralPath $meta -Raw -Encoding UTF8 | ConvertFrom-Json
            if (-not $agentType -and $mj.agentType) { $agentType = [string]$mj.agentType }
            if ($mj.description) { $description = [string]$mj.description }
        } catch { }
    }
    $role = if ($agentType) { ($agentType -replace '^.*:', '').ToLowerInvariant() } else { 'n/a' }

    # Rodadas anteriores deste agente: quantas chamadas ao modelo já foram contadas.
    $usagePath = Join-Path $tp 'usage.jsonl'
    $seen = 0; $round = 0
    if (Test-Path -LiteralPath $usagePath) {
        foreach ($line in [System.IO.File]::ReadLines($usagePath)) {
            if ($line.IndexOf($agentId) -lt 0) { continue }
            try { $r = $line | ConvertFrom-Json } catch { continue }
            if ([string]$r.agent_id -eq $agentId) { $seen = [int]$r.calls_total; $round = [int]$r.round }
        }
    }

    # Chamadas ao modelo, deduplicadas por message.id (uma resposta pode ocupar várias linhas do transcript).
    $calls = New-Object System.Collections.ArrayList
    $index = @{}
    $firstPrompt = $null; $roundPrompt = $null; $children = @{}
    foreach ($line in [System.IO.File]::ReadLines($transcript)) {
        # Subagente que este disparou (o operator de um papel): o resultado do Agent cita o agentId — liga a linha dele ao chamador.
        if ($line.IndexOf('"tool_result"') -ge 0 -and $line.IndexOf('agentId') -ge 0) {
            foreach ($cm in [regex]::Matches($line, 'agentId:?\\?"?:?\s*\\?"?([a-f0-9]{8,})')) { $children[$cm.Groups[1].Value] = $true }
            continue
        }
        if ($line.IndexOf('"type":"user"') -ge 0 -and $line.IndexOf('"tool_result"') -lt 0) {
            try {
                $u = $line | ConvertFrom-Json
                $c = $u.message.content
                $text = if ($c -is [string]) { $c } else { (@($c) | Where-Object { $_.type -eq 'text' } | ForEach-Object { [string]$_.text }) -join "`n" }
                if ($text) {
                    if ($null -eq $firstPrompt) { $firstPrompt = $text }
                    if ($calls.Count -ge $seen -and $null -eq $roundPrompt) { $roundPrompt = $text }
                }
            } catch { }
            continue
        }
        if ($line.IndexOf('"usage"') -lt 0 -or $line.IndexOf('"type":"assistant"') -lt 0) { continue }
        try { $o = $line | ConvertFrom-Json } catch { continue }
        $id = [string]$o.message.id
        if (-not $id -or -not $o.message.usage) { continue }
        $rec = [pscustomobject]@{ model = [string]$o.message.model; u = $o.message.usage; ts = [string]$o.timestamp }
        if ($index.ContainsKey($id)) { $calls[$index[$id]] = $rec } else { $index[$id] = $calls.Count; [void]$calls.Add($rec) }
    }
    if ($calls.Count -le $seen) { exit 0 }                                   # nenhuma chamada nova nesta parada

    $in = 0L; $cw = 0L; $cr = 0L; $out = 0L; $peak = 0L; $first = $null; $last = 0L; $models = @{}
    for ($i = $seen; $i -lt $calls.Count; $i++) {
        $u = $calls[$i].u
        $ctx = [int64]$u.input_tokens + [int64]$u.cache_creation_input_tokens + [int64]$u.cache_read_input_tokens
        if ($null -eq $first) { $first = $ctx }
        if ($ctx -gt $peak) { $peak = $ctx }
        $last = $ctx + [int64]$u.output_tokens
        $in += [int64]$u.input_tokens; $cw += [int64]$u.cache_creation_input_tokens; $cr += [int64]$u.cache_read_input_tokens; $out += [int64]$u.output_tokens
        if ($calls[$i].model) { $models[$calls[$i].model] = $true }
    }
    $start = [datetime]$calls[$seen].ts; $end = [datetime]$calls[$calls.Count - 1].ts
    $duration = [int]([Math]::Max(0, ($end - $start).TotalSeconds))

    # Trabalho: o ID do prompt da rodada (retomada) ou do primeiro prompt; senão o escopo ativo do dev; senão n/a.
    $work = $null
    if ($roundPrompt) { $work = Get-WorkId $roundPrompt }
    if (-not $work -and $firstPrompt) { $work = Get-WorkId $firstPrompt }
    if (-not $work) { $at = Get-Marker $projectDir '.active-task'; if ($null -ne $at -and $at.id) { $work = [string]$at.id } }
    $run = Get-Marker $projectDir '.active-run'
    $dst = Get-Destination $projectDir $work $run

    $row = [ordered]@{
        ts            = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')
        agent_id      = $agentId
        role          = $role
        agent_type    = $agentType
        description   = $description
        round         = $round + 1
        work          = if ($work) { $work } else { 'n/a' }
        model         = (@($models.Keys) -join ',')
        start         = $start.ToString('yyyy-MM-ddTHH:mm:ss')
        duration_s    = $duration
        calls         = $calls.Count - $seen
        calls_total   = $calls.Count
        input         = $in
        cache_write   = $cw
        cache_read    = $cr
        output        = $out
        processed     = $in + $cw + $cr + $out
        first_context = $first
        peak_context  = $peak
        final_context = $last
        children      = @($children.Keys | Where-Object { $_ -ne $agentId })
        run           = if ($null -ne $run) { "$([string]$run.trilha) $([string]$run.id)" } else { '' }
        dest          = $dst.dest
        dest_note     = [string]$dst.note
    }
    $json = $row | ConvertTo-Json -Compress
    [System.IO.File]::AppendAllText($usagePath, $json + [Environment]::NewLine, (New-Object System.Text.UTF8Encoding($false)))
    exit 0
} catch {
    try { Write-GuardLog $projectDir 'erro' $hookInput 'subagent-stop.ps1' $_.Exception.Message } catch { }
    exit 1
}
