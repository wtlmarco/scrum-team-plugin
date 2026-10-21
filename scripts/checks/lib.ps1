# Funções comuns às conferências C1 (close.ps1), C2 (project.ps1) e C3 (release.ps1).
# Requisito: Windows PowerShell 5.1 (powershell.exe, o do Windows), sem recurso exclusivo do PowerShell 7.
# Lê tudo em UTF-8 explícito; os .ps1 são gravados em UTF-8 com BOM, que o 5.1 exige para ler acentos e emojis.

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$script:E = @{
    Done    = [char]::ConvertFromUtf32(0x2705)    # ✅
    Fail    = [char]::ConvertFromUtf32(0x274C)    # ❌
    Warn    = [char]::ConvertFromUtf32(0x26A0)    # ⚠
    Build   = [char]::ConvertFromUtf32(0x1F7E8)   # 🟨
    Plan    = [char]::ConvertFromUtf32(0x1F7E6)   # 🟦
    QA      = [char]::ConvertFromUtf32(0x1F7EA)   # 🟪
}

$script:Results = New-Object System.Collections.ArrayList

function Read-Text([string]$Path) {
    return [System.IO.File]::ReadAllText($Path, (New-Object System.Text.UTF8Encoding($false)))
}

function Add-Result([string]$Rule, [string]$Status, [string]$Line) {
    [void]$script:Results.Add([pscustomobject]@{ Regra = $Rule; Resultado = $Status; Linha = ($Line -replace '\|', '/' -replace '\s+', ' ').Trim() })
}

function Write-Results([string]$Title) {
    $out = New-Object System.Text.StringBuilder
    [void]$out.AppendLine("### $Title")
    [void]$out.AppendLine('')
    [void]$out.AppendLine('| Regra | Resultado | Linha decisiva |')
    [void]$out.AppendLine('|---|---|---|')
    foreach ($r in $script:Results) { [void]$out.AppendLine("| $($r.Regra) | $($r.Resultado) | $($r.Linha) |") }
    [Console]::Out.Write($out.ToString())
}

# Seção: da linha que casa $HeadingRegex até a próxima de nível igual ou maior. $null se não existir.
function Get-Section([string]$Text, [string]$HeadingRegex) {
    $lines = $Text -split "`r?`n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match $HeadingRegex) {
            $level = ([regex]::Match($lines[$i], '^#+')).Length
            $buf = New-Object System.Collections.ArrayList
            for ($j = $i + 1; $j -lt $lines.Count; $j++) {
                $m = [regex]::Match($lines[$j], '^(#+)\s')
                if ($m.Success -and $m.Groups[1].Length -le $level) { break }
                [void]$buf.Add($lines[$j])
            }
            return ($buf -join "`n")
        }
    }
    return $null
}

function Split-Row([string]$Line) {
    $t = $Line.Trim()
    if ($t.StartsWith('|')) { $t = $t.Substring(1) }
    if ($t.EndsWith('|')) { $t = $t.Substring(0, $t.Length - 1) }
    return @($t -split '(?<!\\)\|' | ForEach-Object { $_.Trim() })
}

function Clean-Cell([string]$Cell) { return ($Cell -replace '\*\*', '' -replace '`', '').Trim() }

# Tabelas Markdown do texto: cada uma com Header (células limpas) e Rows (células cruas), sem a linha |---|.
function Get-Tables([string]$Text) {
    $tables = New-Object System.Collections.ArrayList
    $cur = $null
    foreach ($line in ($Text -split "`r?`n")) {
        if ($line.TrimStart().StartsWith('|')) {
            $cells = Split-Row $line
            if ($null -eq $cur) {
                $cur = @{ Header = @($cells | ForEach-Object { Clean-Cell $_ }); Rows = (New-Object System.Collections.ArrayList) }
            } elseif ($line -match '^\s*\|[\s:\-|]+\|\s*$') {
                continue
            } else {
                [void]$cur.Rows.Add($cells)
            }
        } elseif ($null -ne $cur) {
            [void]$tables.Add($cur); $cur = $null
        }
    }
    if ($null -ne $cur) { [void]$tables.Add($cur) }
    return ,$tables
}

function Find-Col($Table, [string]$Name) {
    for ($i = 0; $i -lt $Table.Header.Count; $i++) { if ($Table.Header[$i] -like "*$Name*") { return $i } }
    return -1
}

function Get-Cell($Row, [int]$Index) {
    if ($Index -lt 0 -or $Index -ge $Row.Count) { return '' }
    return [string]$Row[$Index]
}

function Test-Placeholder([string]$Cell) {
    $c = Clean-Cell $Cell
    return ([string]::IsNullOrWhiteSpace($c) -or $c -match '<[^>]+>')
}

# Veredito de uma linha **Veredito:** — o PRIMEIRO marcador (✅ ⚠ ❌); o histórico que vem depois não conta. $null se nenhum.
function Get-VerdictMark([string]$Line) {
    $first = $null; $at = [int]::MaxValue
    foreach ($mk in $E.Done, $E.Warn, $E.Fail) { $ix = $Line.IndexOf($mk); if ($ix -ge 0 -and $ix -lt $at) { $at = $ix; $first = $mk } }
    return $first
}

# Primeira data do texto: aaaa-mm-dd ou dd/mm/aaaa. $null se nenhuma.
function Get-FirstDate([string]$Text) {
    $m = [regex]::Match($Text, '(\d{4})-(\d{2})-(\d{2})')
    if ($m.Success) { return Get-Date -Year $m.Groups[1].Value -Month $m.Groups[2].Value -Day $m.Groups[3].Value -Hour 0 -Minute 0 -Second 0 -Millisecond 0 }
    $m = [regex]::Match($Text, '(\d{2})/(\d{2})/(\d{4})')
    if ($m.Success) { return Get-Date -Year $m.Groups[3].Value -Month $m.Groups[2].Value -Day $m.Groups[1].Value -Hour 0 -Minute 0 -Second 0 -Millisecond 0 }
    return $null
}

# Rótulo de tabela de duas colunas (| **Rótulo** | valor |): devolve o valor da 1ª linha cujo rótulo começa com $Label.
function Get-LabelValue([string]$Text, [string]$Label) {
    foreach ($t in (Get-Tables $Text)) {
        foreach ($row in (@(, $t.Header) + @($t.Rows))) {
            if ($row.Count -ge 2 -and (Clean-Cell $row[0]).StartsWith($Label)) { return [string]$row[1] }
        }
    }
    return $null
}

function Get-IdPattern([string]$Id) { return '(?<![\w-])' + [regex]::Escape($Id) + '(?![\w])' }

# Impressão digital da árvore de trabalho (v3.45.1): o tree do git com tudo o que está no disco — rastreado, alterado e
# novo não ignorado —, montado num índice temporário (o índice do projeto não é tocado) e sem .team-project/ (R31).
# Mesma impressão = mesmo código: evidência de verify.ps1 com ela vale sem reexecução. $null fora de um repositório git.
function Get-WorkTree([string]$Root) {
    $ErrorActionPreference = 'Continue'   # no 5.1, stderr do git (aviso de CRLF) viraria exceção com 'Stop'
    $top = & git -C $Root rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $top) { return $null }
    $idx = [System.IO.Path]::GetTempFileName()
    $old = $env:GIT_INDEX_FILE
    try {
        Remove-Item -LiteralPath $idx -Force
        $env:GIT_INDEX_FILE = $idx
        & git -C $top rev-parse --verify -q HEAD *> $null
        if ($LASTEXITCODE -eq 0) { & git -C $top read-tree HEAD 2>$null } else { & git -C $top read-tree --empty 2>$null }
        & git -C $top add -A -- . ':(exclude).team-project' 2>$null
        $tree = & git -C $top write-tree 2>$null
        if ($LASTEXITCODE -ne 0) { return $null }
        return ([string]$tree).Trim()
    } finally {
        if ($null -eq $old) { Remove-Item Env:GIT_INDEX_FILE -ErrorAction SilentlyContinue } else { $env:GIT_INDEX_FILE = $old }
        Remove-Item -LiteralPath $idx -Force -ErrorAction SilentlyContinue
    }
}

# Pasta da evidência mecânica de um trabalho: .team-project/verify/<sprint|B-nnn|pre-sprint>/<ID>/.
function Get-VerifyDir([string]$Root, [string]$Id) {
    $tp = Join-Path $Root '.team-project'
    $seg = 'pre-sprint'
    if ($Id -match '^[FB]-\d+') {
        $run = Join-Path $tp '.active-run'
        if ($Id -match '^B-\d+$') { $seg = $Id }
        elseif (Test-Path -LiteralPath $run) { try { $r = Get-Content -LiteralPath $run -Raw -Encoding UTF8 | ConvertFrom-Json; if ([string]$r.trilha -eq 'fix') { $seg = [string]$r.id } } catch { } }
    } else {
        $readme = Join-Path $tp 'README.md'
        if (Test-Path -LiteralPath $readme) {
            $m = [regex]::Match((Read-Text $readme), '(?m)^\|\s*\*\*Sprint corrente\*\*\s*\|\s*\*\*(\d+)\*\*')
            if ($m.Success) { $seg = $m.Groups[1].Value }
        }
    }
    return (Join-Path $tp "verify/$seg/$Id")
}

# Higiene por ferramenta (v3.51, D1): variáveis de ambiente e avisos para o comando, lidos de tool-hygiene.json.
# Devolve @{ Env = [ordered] nome → valor final; Warnings = textos; Tools = nomes }. $Extra (guards.json → verify.env) vence.
function Get-ToolHygiene([string]$Cmd, $Extra) {
    $res = @{ Env = [ordered]@{}; Warnings = @(); Tools = @() }
    $path = Join-Path $PSScriptRoot 'tool-hygiene.json'
    if (Test-Path -LiteralPath $path) {
        $h = Read-Text $path | ConvertFrom-Json
        foreach ($t in @($h.tools)) {
            if (-not [regex]::IsMatch($Cmd, [string]$t.match, 'IgnoreCase')) { continue }
            $res.Tools += [string]$t.tool
            if ($t.env) {
                foreach ($p in $t.env.PSObject.Properties) {
                    $v = [string]$p.Value.value
                    $cur = [Environment]::GetEnvironmentVariable($p.Name)
                    if ($p.Value.append -and $cur -and $cur -notlike "*$v*") { $v = "$cur $v" }
                    $res.Env[$p.Name] = $v
                }
            }
            foreach ($w in @($t.warn)) { if ($w -and [regex]::IsMatch($Cmd, [string]$w.pattern, 'IgnoreCase')) { $res.Warnings += [string]$w.text } }
        }
    }
    if ($Extra) { foreach ($p in $Extra.PSObject.Properties) { $res.Env[$p.Name] = [string]$p.Value } }
    return $res
}

# Falha de ambiente (v3.51, D4): a saída casa uma assinatura conhecida de tool-hygiene.json → a mensagem com a ação; senão $null.
function Get-EnvFailure([string]$Text) {
    $path = Join-Path $PSScriptRoot 'tool-hygiene.json'
    if (-not (Test-Path -LiteralPath $path) -or -not $Text) { return $null }
    foreach ($s in @((Read-Text $path | ConvertFrom-Json).envSignatures)) {
        if ([regex]::IsMatch($Text, [string]$s.pattern)) { return [string]$s.message }
    }
    return $null
}

# Linhas decisivas de um log: as últimas que falam de teste, falha, cobertura ou porcentagem.
function Get-Decisive([string]$Log) {
    $u8 = New-Object System.Text.UTF8Encoding($false)
    $lines = @([System.IO.File]::ReadAllLines($Log, $u8))
    $hit = @($lines | Where-Object { $_ -match '(?i)\b(pass(ed|ing)?|fail(ed|ures?)?|errors?|warnings?|tests?|total|coverage|cobertura|threshold)\b|\d+(\.\d+)?\s*%' } | Select-Object -Last 4)
    if ($hit.Count -eq 0) { $hit = @($lines | Where-Object { $_.Trim() } | Select-Object -Last 2) }
    return @{ Lines = $lines.Count; Decisive = @($hit | ForEach-Object { $t = $_.Trim(); if ($t.Length -gt 200) { $t.Substring(0, 200) + '…' } else { $t } }) }
}

# Roda um comando do projeto num PowerShell filho (v3.45.1; comum ao verify e ao quality desde a v3.51): código de saída
# real, saída inteira no log, tempo limite próprio com a árvore de processos encerrada (exit 124), descendentes que sobram
# encerrados ao fim (daemon), higiene da ferramenta e $EnvExtra como variáveis do filho, falha de ambiente por assinatura.
function Invoke-ProjectCommand([string]$Root, [string]$Key, [string]$Cmd, [string]$Log, [double]$TimeoutMinutes, $EnvExtra) {
    $u8 = New-Object System.Text.UTF8Encoding($false)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $hy = Get-ToolHygiene $Cmd $EnvExtra
    $envPrefix = (@($hy.Env.Keys) | ForEach-Object { "[Environment]::SetEnvironmentVariable('$($_ -replace "'", "''")', '$(([string]$hy.Env[$_]) -replace "'", "''")', 'Process'); " }) -join ''
    # Código de saída real: o do último comando nativo; cmdlet que falha sem código = 1 (contrato do operator, item 2).
    $wrapped = $envPrefix + '$global:LASTEXITCODE = 0; ' + $Cmd + '; if (-not $?) { if ($LASTEXITCODE) { exit $LASTEXITCODE } else { exit 1 } }; exit $LASTEXITCODE'
    $enc = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($wrapped))   # aspas do comando passam intactas
    # Sem -Wait: no 5.1 ele espera também os descendentes, e o daemon do build é descendente (nota 4).
    $p = Start-Process -FilePath 'powershell' -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-EncodedCommand', $enc) -WorkingDirectory $Root -RedirectStandardOutput $Log -RedirectStandardError "$Log.err" -NoNewWindow -PassThru
    $null = $p.Handle   # sem o handle aberto, o ExitCode volta vazio no 5.1
    $limit = if ($TimeoutMinutes -gt 0) { [Math]::Max(0.05, $TimeoutMinutes) } else { 9 }
    $timedOut = -not $p.WaitForExit([int]($limit * 60000))
    if ($timedOut) { $null = Stop-ProcessTree $p.Id; $p.WaitForExit(5000) | Out-Null; $code = 124 }
    else { $p.WaitForExit(); $code = $p.ExitCode; $null = Stop-ProcessTree $p.Id -ChildrenOnly }
    Start-Sleep -Milliseconds 200   # o arquivo de saída fica livre depois que os descendentes saem
    if (Test-Path -LiteralPath "$Log.err") { $err = [System.IO.File]::ReadAllText("$Log.err", $u8); if ($err) { [System.IO.File]::AppendAllText($Log, $err, $u8) }; Remove-Item -LiteralPath "$Log.err" -Force }
    if ($timedOut) { [System.IO.File]::AppendAllText($Log, "`nTEMPO ESGOTADO: $limit min — árvore do processo encerrada`n", $u8) }
    [System.IO.File]::AppendAllText($Log, "`nEXIT=$code`n", $u8)
    $d = Get-Decisive $Log
    $envFail = if ($timedOut) { "tempo esgotado ($limit min): o comando não devolveu o controle — confira modo de observação ou processo que não termina (tool-hygiene.json)" }
               elseif ($code -ne 0) { Get-EnvFailure ([System.IO.File]::ReadAllText($Log, $u8)) } else { $null }
    return [ordered]@{ key = $Key; command = $Cmd; exit = $code; seconds = [int]$sw.Elapsed.TotalSeconds; log = ($Log.Substring($Root.Length + 1) -replace '\\', '/'); lines = $d.Lines; decisive = $d.Decisive; environment = $envFail; hygiene = @($hy.Tools); warnings = @($hy.Warnings) }
}
# Encerra um processo e todos os descendentes, filhos primeiro (v3.51, D1). Vale também para órfão cujo pai já saiu:
# o ParentProcessId continua apontando para o PID que o criou (o daemon do Gradle fica assim depois do gradlew).
function Stop-ProcessTree([int]$RootPid, [switch]$ChildrenOnly) {
    $all = @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Select-Object ProcessId, ParentProcessId, CreationDate)
    $root = $all | Where-Object { $_.ProcessId -eq $RootPid } | Select-Object -First 1
    $kill = New-Object System.Collections.ArrayList
    $queue = New-Object System.Collections.Queue; $queue.Enqueue($RootPid)
    while ($queue.Count) {
        $cur = $queue.Dequeue()
        foreach ($c in @($all | Where-Object { $_.ParentProcessId -eq $cur -and $_.ProcessId -ne $cur })) {
            # PID reaproveitado: só é descendente quem nasceu depois do pai (quando o pai ainda existe para comparar).
            if ($root -and $c.CreationDate -and $root.CreationDate -and $c.CreationDate -lt $root.CreationDate) { continue }
            if (-not $kill.Contains($c.ProcessId)) { [void]$kill.Add($c.ProcessId); $queue.Enqueue($c.ProcessId) }
        }
    }
    $ids = @($kill); [array]::Reverse($ids)
    foreach ($id in $ids) { Stop-Process -Id $id -Force -ErrorAction SilentlyContinue }
    if (-not $ChildrenOnly) { Stop-Process -Id $RootPid -Force -ErrorAction SilentlyContinue }
    return $ids.Count
}

# Alvos de execução (v3.51, D3): guards.json → targets ({ "android": {…}, "web": {…} }). $null sem a chave.
function Get-TargetsConfig([string]$Root) {
    $g = Join-Path $Root '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $g)) { return $null }
    try { $j = Read-Text $g | ConvertFrom-Json } catch { return $null }
    if ($j.PSObject.Properties['targets']) { return $j.targets }
    return $null
}

# Trava de dono único do alvo (v3.51, D3): .team-project/.target-lock. Dois automatizadores no mesmo aparelho quebram os
# dois (medido no benchmark: 33 cenários falharam por isso). Devolve $null se pegou a trava, senão o motivo.
function Enter-TargetLock([string]$Root, [string]$Target, [string]$Owner, [int]$StaleHours = 3) {
    $lp = Join-Path $Root '.team-project/.target-lock'
    if (Test-Path -LiteralPath $lp) {
        try { $l = Read-Text $lp | ConvertFrom-Json } catch { $l = $null }
        if ($l -and [int]$l.pid -ne $PID) {
            $alive = [bool](Get-Process -Id ([int]$l.pid) -ErrorAction SilentlyContinue)
            $age = try { ((Get-Date) - [datetime]::ParseExact([string]$l.desde, 'yyyy-MM-dd HH:mm:ss', $null)).TotalHours } catch { 999 }
            if ($alive -and $age -lt $StaleHours) { return "o alvo $([string]$l.target) está em uso por '$([string]$l.owner)' (PID $([int]$l.pid), desde $([string]$l.desde)): espere terminar — dois automatizadores no mesmo alvo quebram os dois" }
        }
    }
    New-Item -ItemType Directory -Force (Split-Path $lp) | Out-Null
    [System.IO.File]::WriteAllText($lp, ([ordered]@{ target = $Target; owner = $Owner; pid = $PID; desde = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') } | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false)))
    return $null
}
function Exit-TargetLock([string]$Root) {
    $lp = Join-Path $Root '.team-project/.target-lock'
    if (Test-Path -LiteralPath $lp) { try { $l = Read-Text $lp | ConvertFrom-Json; if ([int]$l.pid -eq $PID) { Remove-Item -LiteralPath $lp -Force } } catch { Remove-Item -LiteralPath $lp -Force -ErrorAction SilentlyContinue } }
}

# Quadro do sprint (v3.51; run.ps1 e kanban-html.ps1): Histórias e Tasks (marcador, depende de, plano, cenários).
function Get-SprintTasks([string]$S) {
    $board = Read-Text (Join-Path $S 'sprint-backlog.md')
    $tdMk = [char]::ConvertFromUtf32(0x2B1C); $rdMk = [char]::ConvertFromUtf32(0x1F534)
    $tasks = @(); $story = $null; $header = $null
    foreach ($line in ($board -split "`r?`n")) {
        $hm = [regex]::Match($line, '^##\s+Hist[oó]ria\s+(H-[\w]+)\s*[—-]?\s*(.*)$')
        if ($hm.Success) { $story = $hm.Groups[1].Value; $header = $null; continue }
        if (-not $line.TrimStart().StartsWith('|') -or -not $story) { continue }
        $cells = Split-Row $line
        if ((Clean-Cell $cells[0]) -eq 'ID') { $header = @($cells | ForEach-Object { Clean-Cell $_ }); continue }
        if (-not $header -or $line -match '^\s*\|[\s:\-|]+\|\s*$') { continue }
        $idm = [regex]::Match($cells[0], '[A-Z]+-\d+[a-z]?'); if (-not $idm.Success) { continue }
        $col = { param($n) $i = -1; for ($k = 0; $k -lt $header.Count; $k++) { if ($header[$k] -like "*$n*") { $i = $k; break } }; if ($i -ge 0 -and $i -lt $cells.Count) { [string]$cells[$i] } else { '' } }
        $mk = $null; foreach ($m in @($tdMk, $E.Plan, $E.Build, $E.QA, $E.Done, $rdMk)) { if ($cells[0].Contains($m)) { $mk = $m; break } }
        $planCell = & $col 'Plano'
        $pm = [regex]::Match($planCell, '\]\(([^)]+)\)'); $pp = if ($pm.Success) { $pm.Groups[1].Value } else { ([regex]::Match($planCell, '`([^`]+)`')).Groups[1].Value }
        $deps = @([regex]::Matches((& $col 'Depende'), '[A-Z]+-\d+[a-z]?') | ForEach-Object { $_.Value })
        $scn = @([regex]::Matches((& $col 'Cenários'), 'SC-\d+') | ForEach-Object { $_.Value } | Select-Object -Unique)
        $tasks += [pscustomobject]@{ Id = $idm.Value; Title = (Clean-Cell (& $col 'Task')); Story = $story; Mark = $mk; Deps = $deps; Plan = $pp; Scenarios = $scn }
    }
    return $tasks
}
# Arquivo do sprint com o Kanban, a Série, o Registro de transições e o controle (v3.51, G1): kanban.md; sprint aberto
# antes da v3.51 tem burndown.md (o mesmo conteúdo, sem o Kanban). Devolve o que existe, o kanban.md primeiro.
function Get-ChartPath([string]$SprintDir) {
    $k = Join-Path $SprintDir 'kanban.md'; if (Test-Path -LiteralPath $k) { return $k }
    return (Join-Path $SprintDir 'burndown.md')
}
# Seção de controle das Tasks (Entradas fora da Planning, Bloqueios e riscos, Decisões pendentes): no kanban.md desde a
# v3.51 (G1, pedido do stakeholder); antes, no sprint-backlog.md. Procura nos dois, o kanban.md primeiro.
function Get-ControlSection([string]$SprintDir, [string]$Board, [string]$HeadingRegex) {
    $k = Join-Path $SprintDir 'kanban.md'
    if (Test-Path -LiteralPath $k) { $s = Get-Section (Read-Text $k) $HeadingRegex; if ($s) { return $s } }
    if ($Board) { return Get-Section $Board $HeadingRegex }
    return $null
}

# Registro de transições (R24): vive no kanban.md (v3.51) ou no burndown.md (v3.44.1) do sprint; sprint aberto antes disso o tem no sprint-backlog.md. $null se nenhum.
function Get-TransitionLog([string]$SprintDir, [string]$Board) {
    $bd = Get-ChartPath $SprintDir
    if (Test-Path -LiteralPath $bd) { $s = Get-Section (Read-Text $bd) '^##\s+Registro de transi'; if ($s) { return $s } }
    if ($Board) { return Get-Section $Board '^##\s+Registro de transi' }
    return $null
}
