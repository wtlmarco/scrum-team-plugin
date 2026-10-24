# SubagentStop — G16 (v3.45): o consumo de cada rodada de subagente vira uma linha em .team-project/usage.jsonl,
# medida no transcript do próprio subagente — a sessão deixa de transcrever números da notificação à mão.
# Por quê: o número da notificação ("subagent_tokens") é o tamanho do contexto na ÚLTIMA chamada ao modelo, não a soma
# do que o subagente processou (medido em 06/10/2026: 49 004 notificados × 273 190 processados; 53 245 × 322 194).
# Uma linha por rodada: a retomada por SendMessage acrescenta chamadas ao mesmo transcript, e a linha seguinte traz só o delta.
# v3.48: rodada do operator também grava o relatório dele (a resposta em texto) na pasta do job — o harness recusa ao subagente.
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
    $n = Get-SprintNumber $ProjectDir
    if ($n) {
        $sd = Join-Path $tp "sprints/$n"
        $open = -not (Test-Path -LiteralPath (Join-Path $sd 'retrospective.md'))
        # v3.51.4 (garden item 1): com o sprint run da trilha sprint ativo e o quadro do sprint no disco, o consumption.md do
        # sprint nasce aqui se a Planning não o criou — antes as rodadas do run caíam no registro geral e o kanban.md mostrava 0 rodada.
        if ($open -and (Test-Path -LiteralPath (Join-Path $sd 'sprint-backlog.md')) -and -not (Test-Path -LiteralPath (Join-Path $sd 'consumption.md')) -and $null -ne $Run -and [string]$Run.trilha -eq 'sprint') {
            $null = Invoke-Quiet 'kanban.ps1' @{ Root = $ProjectDir; Init = $true }
        }
        if ($open -and (Test-Path -LiteralPath (Join-Path $sd 'consumption.md'))) {
            return @{ dest = ".team-project/sprints/$n/consumption.md"; sprint = $n }
        }
        return @{ dest = '.team-project/consumption.md'; sprint = $null; note = 'entre-sprints' }
    }
    return @{ dest = '.team-project/consumption.md'; sprint = $null; note = 'pre-sprint' }
}

# Roda um script de conferência no mesmo processo, com a saída fora do harness; devolve o código de saída.
$checks = Join-Path $PSScriptRoot '..\scripts\checks'
function Invoke-Quiet([string]$Script, [hashtable]$ScriptArgs) {
    $prevOut = [Console]::Out; $prevErr = [Console]::Error; $rc = 0
    try {
        [Console]::SetOut([System.IO.TextWriter]::Null); [Console]::SetError([System.IO.TextWriter]::Null)
        $global:LASTEXITCODE = 0
        & (Join-Path $checks $Script) @ScriptArgs *> $null
        $rc = $LASTEXITCODE
    } catch { $rc = 2 } finally { [Console]::SetOut($prevOut); [Console]::SetError($prevErr) }
    return $rc
}

try {
    $hookInput = Read-HookInput
    if ($null -eq $hookInput) { exit 0 }
    $projectDir = Get-ProjectDir $hookInput
    $tp = Join-Path $projectDir '.team-project'
    if (-not (Test-Path -LiteralPath $tp)) { exit 0 }                       # projeto sem o time: silêncio
    $cfg = Get-GuardConfig $projectDir
    if ($cfg.probe) { Write-GuardLog $projectDir 'probe' $hookInput '' ("subagent-stop campos=" + ($hookInput.PSObject.Properties.Name -join ',')) }
    Remove-ActiveAgent $projectDir ([string]$hookInput.agent_type) ([string]$hookInput.agent_id)   # v3.51 (G20): o agente voltou
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
    $firstPrompt = $null; $roundPrompt = $null; $children = @{}; $lastText = $null; $lastSynthetic = $false
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
        # Texto da resposta desta rodada (o relatório do operator é o último texto).
        $txt = (@($o.message.content) | Where-Object { $_.type -eq 'text' } | ForEach-Object { [string]$_.text }) -join "`n"
        if ($txt.Trim() -and $index[$id] -ge $seen) { $lastText = $txt; $lastSynthetic = ([string]$o.message.model -eq '<synthetic>') }
    }
    if ($calls.Count -le $seen) { exit 0 }                                   # nenhuma chamada nova nesta parada

    # v3.51.4: a resposta sintética do harness (limite de uso, erro de API) não é chamada ao modelo — fora do modelo e da soma.
    $in = 0L; $cw = 0L; $cr = 0L; $out = 0L; $peak = 0L; $first = $null; $last = 0L; $models = @{}
    for ($i = $seen; $i -lt $calls.Count; $i++) {
        if ([string]$calls[$i].model -eq '<synthetic>') { continue }
        $u = $calls[$i].u
        $ctx = [int64]$u.input_tokens + [int64]$u.cache_creation_input_tokens + [int64]$u.cache_read_input_tokens
        if ($null -eq $first) { $first = $ctx }
        if ($ctx -gt $peak) { $peak = $ctx }
        $last = $ctx + [int64]$u.output_tokens
        $in += [int64]$u.input_tokens; $cw += [int64]$u.cache_creation_input_tokens; $cr += [int64]$u.cache_read_input_tokens; $out += [int64]$u.output_tokens
        if ($calls[$i].model) { $models[$calls[$i].model] = $true }
    }
    # v3.51.4 (note.md item 13): lacuna acima de 20 min entre duas chamadas é pausa (limite de conta, máquina parada), não
    # trabalho — sai da duração e vai a paused_s. Comando de build/teste cabe no limite de 10 min da ferramenta.
    $start = [datetime]$calls[$seen].ts; $end = [datetime]$calls[$calls.Count - 1].ts
    $paused = 0
    for ($i = $seen + 1; $i -lt $calls.Count; $i++) { try { $gap = ([datetime]$calls[$i].ts - [datetime]$calls[$i - 1].ts).TotalSeconds; if ($gap -gt 1200) { $paused += [int]$gap } } catch { } }
    $duration = [int]([Math]::Max(0, ($end - $start).TotalSeconds - $paused))

    # Trabalho: o ID do prompt da rodada (retomada) ou do primeiro prompt; senão o escopo ativo do dev; senão n/a.
    $work = $null
    if ($roundPrompt) { $work = Get-WorkId $roundPrompt }
    if (-not $work -and $firstPrompt) { $work = Get-WorkId $firstPrompt }
    if (-not $work) { $at = Get-Marker $projectDir '.active-task'; if ($null -ne $at -and $at.id) { $work = [string]$at.id } }
    # v3.51.4 (garden item 8): todas as Tasks citadas no prompt da rodada — o plano por História (regra 25) cobre várias, e o
    # kanban.ps1 rateia a rodada entre elas em vez de pôr tudo na primeira.
    $src = if ($roundPrompt) { $roundPrompt } else { [string]$firstPrompt }
    $works = @([regex]::Matches($src, '(?<![\w-])T-\d+[a-z]?(?![\w])') | ForEach-Object { $_.Value } | Select-Object -Unique | Select-Object -First 12)
    $run = Get-Marker $projectDir '.active-run'
    $dst = Get-Destination $projectDir $work $run
    # v3.51.4 (note.md itens 2 e 11, garden item 26): o subagente parou no limite de uso da conta — sinal legível para a retomada.
    $limitText = if ($lastSynthetic -and $lastText -match $script:LimitRe) { $lastText } else { Get-LimitFromTranscript $transcript }
    if ($limitText) { Set-LimitMarker $projectDir $limitText $role $(if ($work) { $work } else { '' }); Write-GuardLog $projectDir 'G16' $hookInput 'limite' "rodada do $role parou no limite de uso da conta: $(($limitText -replace '\s+', ' ').Trim())" }

    # v3.48 (R28): o harness recusa ao subagente gravar relatório ("Subagents should return findings as text"). O operator
    # devolve o relatório como texto, e este hook o grava na pasta do job citada na resposta (ou no pedido) — report.md, ou
    # report-<agent>-r<rodada>.md se já houver um. Resposta que já cita um report*.md existente: o operator gravou, nada a fazer.
    $reportRel = ''
    if ($role -eq 'operator' -and $lastText) {
        $jobRe = '\.team-project[\\/]operator[\\/](\d+|pre-sprint|B-\d+)[\\/]([\w.-]+)'
        $own = [regex]::Match($lastText, '(\.team-project[\\/]operator[\\/][^\s`''"()]+?[\\/]report[\w.-]*\.md)')
        if (-not ($own.Success -and (Test-Path -LiteralPath (Join-Path $projectDir $own.Groups[1].Value)))) {
            $jm = $null
            foreach ($src in @($lastText, $roundPrompt, $firstPrompt)) { if ($src) { $mm = [regex]::Match($src, $jobRe); if ($mm.Success) { $jm = $mm; break } } }
            # v3.51.4 (garden item 24): sem pasta citada (o dev chamou o operator para o verify full), o relatório vai a uma
            # pasta da própria Task — operator/<n>/<T-ID>-<agente>/ — e o R28 do close.ps1 o acha pela pasta da Task.
            if (-not $jm -and $work -match '^T-\d+' -and $dst.sprint) {
                $jm = [regex]::Match(".team-project/operator/$($dst.sprint)/$work-$($agentId.Substring(0, [Math]::Min(8, $agentId.Length)))", $jobRe)
            }
            # v3.52.1 (garden item 24): o mesmo no bloco de fix — operator/B-<nnn>/<F-ID>-<agente>/ (a pasta que o C4 e o R28 olham).
            if (-not $jm -and $work -match '^F-\d+' -and [string]$dst.dest -match 'fixes/(B-\d+)/') {
                $jm = [regex]::Match(".team-project/operator/$($Matches[1])/$work-$($agentId.Substring(0, [Math]::Min(8, $agentId.Length)))", $jobRe)
            }
            if ($jm -and $jm.Success) {
                $jobRel = ".team-project/operator/$($jm.Groups[1].Value)/$($jm.Groups[2].Value)"
                $jobDir = Join-Path $projectDir $jobRel
                New-Item -ItemType Directory -Force $jobDir | Out-Null
                $name = if (Test-Path -LiteralPath (Join-Path $jobDir 'report.md')) { "report-$($agentId.Substring(0, [Math]::Min(8, $agentId.Length)))-r$($round + 1).md" } else { 'report.md' }
                $head = "<!-- G16: resposta do operator (agent_id $agentId, rodada $($round + 1), $(Get-Date -Format 'yyyy-MM-dd HH:mm')) — gravada pelo hook; o operator devolve o relatório como texto (R28) -->"
                [System.IO.File]::WriteAllText((Join-Path $jobDir $name), $head + "`n`n" + $lastText.Trim() + "`n", (New-Object System.Text.UTF8Encoding($false)))
                $reportRel = "$jobRel/$name"
            } else {
                Write-GuardLog $projectDir 'G16' $hookInput 'report' "resposta do operator sem pasta de job citada (agent_id=$agentId) — relatório não gravado; quem chamou cola o texto em Execução delegada"
            }
        }
    }

    $row = [ordered]@{
        ts            = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')
        agent_id      = $agentId
        role          = $role
        agent_type    = $agentType
        description   = $description
        round         = $round + 1
        work          = if ($work) { $work } else { 'n/a' }
        works         = $works
        model         = (@($models.Keys) -join ',')
        start         = $start.ToString('yyyy-MM-ddTHH:mm:ss')
        duration_s    = $duration
        paused_s      = $paused
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
        report        = $reportRel
        # v3.49: o transcript da sessão que disparou — o consumption.ps1 -Session mede a sessão principal por ele, no close.
        session_transcript = [string]$hookInput.transcript_path
    }
    $json = $row | ConvertTo-Json -Compress
    [System.IO.File]::AppendAllText($usagePath, $json + [Environment]::NewLine, (New-Object System.Text.UTF8Encoding($false)))

    # v3.51.4 (garden item 10): a rodada de um filho (o operator chamado por este papel) fica no registro do PAI — o filho
    # termina antes e era gravado com o destino daquele instante (o arquivo do sprint ainda não existia). Linha do filho com
    # outro destino é regravada com o destino do pai, e os dois registros se refazem.
    $kids = @($row.children)
    $redo = @()
    if ($kids.Count) {
        $lines = [System.IO.File]::ReadAllLines($usagePath, (New-Object System.Text.UTF8Encoding($false)))
        $changed = $false
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if (-not $lines[$i].Trim()) { continue }
            try { $r = $lines[$i] | ConvertFrom-Json } catch { continue }
            if ($kids -notcontains [string]$r.agent_id -or [string]$r.dest -eq $dst.dest) { continue }
            $redo += [string]$r.dest; $r.dest = $dst.dest
            if ($r.PSObject.Properties['dest_note']) { $r.dest_note = [string]$dst.note }
            $lines[$i] = $r | ConvertTo-Json -Compress; $changed = $true
        }
        if ($changed) { [System.IO.File]::WriteAllLines($usagePath, $lines, (New-Object System.Text.UTF8Encoding($false))) }
    }

    # v3.49: o registro do destino se atualiza aqui, sem depender de a sessão lembrar de rodar o consumption.ps1 (no piloto,
    # 33 chamadas da sessão a ~400 mil tokens cada). Roda no mesmo processo, com a saída fora do harness; falha vira linha G16.
    foreach ($old in @($redo | Select-Object -Unique)) { if (Test-Path -LiteralPath (Join-Path $projectDir $old)) { $null = Invoke-Quiet 'consumption.ps1' @{ Root = $projectDir; File = $old } } }
    # v3.51.2: o consumption.md do bloco de fix nasce aqui, na primeira rodada do bloco — antes dependia de a sessão lembrar.
    $blk = [regex]::Match($dst.dest, 'fixes/(B-\d+)/')
    if ($blk.Success -and -not (Test-Path -LiteralPath (Join-Path $projectDir $dst.dest))) { $null = Invoke-Quiet 'kanban.ps1' @{ Root = $projectDir; Block = $blk.Groups[1].Value; Init = $true } }

    if ((Test-Path -LiteralPath (Join-Path $checks 'consumption.ps1')) -and (Test-Path -LiteralPath (Join-Path $projectDir $dst.dest))) {
        $rc = Invoke-Quiet 'consumption.ps1' @{ Root = $projectDir; File = $dst.dest }
        if ($rc -ne 0) { Write-GuardLog $projectDir 'G16' $hookInput 'consumo' "consumption.ps1 saiu com $rc ao gravar $($dst.dest) — rode-o à mão antes do close" }
    }
    # v3.51.2: o kanban.md (sprint ou bloco) mostra a rodada na hora — papel, modelo, tokens e tempo.
    if ($blk.Success) { $kargs = @{ Root = $projectDir; Block = $blk.Groups[1].Value } } elseif ($dst.sprint) { $kargs = @{ Root = $projectDir } } else { $kargs = $null }
    if ($kargs) {
        $rc = Invoke-Quiet 'kanban.ps1' $kargs
        if ($rc -ne 0) { Write-GuardLog $projectDir 'G16' $hookInput 'kanban' "kanban.ps1 saiu com $rc — rode-o à mão: scripts/checks/kanban.ps1 $(if ($kargs.Block) { '-Block ' + $kargs.Block })" }
    }
    exit 0
} catch {
    try { Write-GuardLog $projectDir 'erro' $hookInput 'subagent-stop.ps1' $_.Exception.Message } catch { }
    exit 1
}
