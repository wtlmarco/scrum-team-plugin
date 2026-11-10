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
# v3.52.2 (note.md item 13): sem os documentos de desenho (docs/, o SDD) — o SDD editado depois do full (hoje pela
# consolidação do Arquiteto) reprovava o R7-verify. Pasta de guards.json → sourceRoots dentro de docs/ continua na impressão. Ficam fora só os documentos:
# build, testes e configuração fora de sourceRoots seguem na impressão (sem eles, a evidência ficaria velha sem aviso).
function Get-WorkTree([string]$Root) {
    $ErrorActionPreference = 'Continue'   # no 5.1, stderr do git (aviso de CRLF) viraria exceção com 'Stop'
    $top = & git -C $Root rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $top) { return $null }
    $keep = @()
    $gp = Join-Path $Root '.team-project/guards.json'
    if (Test-Path -LiteralPath $gp) { try { $keep = @(@((Read-Text $gp | ConvertFrom-Json).sourceRoots) | Where-Object { $_ } | ForEach-Object { ([string]$_ -replace '\\', '/').Trim('/') } | Where-Object { $_ -match '^docs(/|$)' -and $_ -ne 'docs' -and $_ -ne 'docs/**' }) } catch { } }
    $idx = [System.IO.Path]::GetTempFileName()
    $old = $env:GIT_INDEX_FILE
    try {
        Remove-Item -LiteralPath $idx -Force
        $env:GIT_INDEX_FILE = $idx
        & git -C $top rev-parse --verify -q HEAD *> $null
        if ($LASTEXITCODE -eq 0) { & git -C $top read-tree HEAD 2>$null } else { & git -C $top read-tree --empty 2>$null }
        & git -C $top add -A -- . ':(exclude).team-project' ':(exclude)docs' 2>$null
        & git -C $top rm -r -q --cached --ignore-unmatch -- docs 2>$null | Out-Null   # o docs/ do HEAD também sai
        foreach ($k in $keep) { & git -C $top add -A -- $(if ($k -match '[*?]') { ":(glob)$k" } else { $k }) 2>$null }
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
        if (Test-Path -LiteralPath $readme) { $n = Get-CurrentSprint (Read-Text $readme); if ($n) { $seg = $n } }
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
# v3.51.4 (-KeepDescendants, verify.daemon): os descendentes que sobram (o daemon) ficam vivos e voltam em "kept" — o
# verify.ps1 os reaproveita no comando seguinte e os encerra no fim da chamada (Stop-ProcessTree), antes de devolver o controle.
function Invoke-ProjectCommand([string]$Root, [string]$Key, [string]$Cmd, [string]$Log, [double]$TimeoutMinutes, $EnvExtra, [switch]$KeepDescendants, [double]$ClockSkewMin = 0) {
    $u8 = New-Object System.Text.UTF8Encoding($false)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $t0 = Get-Date   # v3.57.0 (item 8): relógio de parede, para perceber a suspensão do sistema (o WaitForExit não conta o tempo dormindo)
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
    $kept = @()
    if ($timedOut) { $null = Stop-ProcessTree $p.Id; $p.WaitForExit(5000) | Out-Null; $code = 124 }
    elseif ($KeepDescendants) { $p.WaitForExit(); $code = $p.ExitCode; $kept = @(Get-DescendantIds $p.Id) }
    else { $p.WaitForExit(); $code = $p.ExitCode; $null = Stop-ProcessTree $p.Id -ChildrenOnly }
    Start-Sleep -Milliseconds 200   # o arquivo de saída fica livre depois que os descendentes saem
    # v3.57.0 (plugin-report do sprint 5 do garden, item 8): o notebook suspendeu ~9 h no meio da suíte; o relógio de parede
    # andou horas contra um prazo de minutos, o Karma perdeu a conexão e a rodada reprovou sem defeito no código. Relógio muito
    # além do prazo = suspensão do sistema: o resultado não vale como prova e quem chama repete a rodada (uma vez).
    $wallMin = ((Get-Date) - $t0).TotalMinutes + $ClockSkewMin
    $suspended = $wallMin -gt ($limit * 1.5 + 1)
    if (Test-Path -LiteralPath "$Log.err") { $err = [System.IO.File]::ReadAllText("$Log.err", $u8); if ($err) { [System.IO.File]::AppendAllText($Log, $err, $u8) }; Remove-Item -LiteralPath "$Log.err" -Force }
    if ($timedOut) { [System.IO.File]::AppendAllText($Log, "`nTEMPO ESGOTADO: $limit min — árvore do processo encerrada`n", $u8) }
    [System.IO.File]::AppendAllText($Log, "`nEXIT=$code`n", $u8)
    $d = Get-Decisive $Log
    $envFail = if ($suspended) { "suspensão do sistema detectada: o relógio andou $([int]$wallMin) min contra o prazo de $limit min — a rodada não vale como prova (o runner pode ter perdido a conexão); repita" }
               elseif ($timedOut) { "tempo esgotado ($limit min): o comando não devolveu o controle — confira modo de observação ou processo que não termina (tool-hygiene.json)" }
               elseif ($code -ne 0) { Get-EnvFailure ([System.IO.File]::ReadAllText($Log, $u8)) } else { $null }
    $r = [ordered]@{ key = $Key; command = $Cmd; exit = $code; seconds = [int]$sw.Elapsed.TotalSeconds; log = ($Log.Substring($Root.Length + 1) -replace '\\', '/'); lines = $d.Lines; decisive = $d.Decisive; environment = $envFail; hygiene = @($hy.Tools); warnings = @($hy.Warnings); suspended = $suspended }
    if ($KeepDescendants) { $r.kept = $kept }
    return $r
}
# Descendentes vivos de um processo (filhos primeiro na ordem inversa), sem encerrar nenhum.
function Get-DescendantIds([int]$RootPid) {
    $all = @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Select-Object ProcessId, ParentProcessId, CreationDate)
    $root = $all | Where-Object { $_.ProcessId -eq $RootPid } | Select-Object -First 1
    $ids = New-Object System.Collections.ArrayList
    $queue = New-Object System.Collections.Queue; $queue.Enqueue($RootPid)
    while ($queue.Count) {
        $cur = $queue.Dequeue()
        foreach ($c in @($all | Where-Object { $_.ParentProcessId -eq $cur -and $_.ProcessId -ne $cur })) {
            if ($root -and $c.CreationDate -and $root.CreationDate -and $c.CreationDate -lt $root.CreationDate) { continue }
            if (-not $ids.Contains($c.ProcessId)) { [void]$ids.Add($c.ProcessId); $queue.Enqueue($c.ProcessId) }
        }
    }
    return @($ids)
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

# Executor único com prazo (v3.57.0, protocolo de espera): TODO comando de terceiros (do projeto ou do guards.json) passa por aqui.
# Saída em ARQUIVO, nunca em pipe: um filho de longa duração que herda a saída não prende a leitura (o reparo do alvo ficou ~2 h
# assim). Espera pelo processo (WaitForExit com prazo), nunca pelo fim do pipe. Prazo é obrigatório (>= 1 s; sem padrão infinito).
# Estourou: exit 124 e timedOut. Morte: a árvore inteira — ou, com -KeepDescendants (o comando deixa de propósito um filho vivo,
# como o emulador), só o processo raiz, e os sobreviventes voltam em kept. Devolve exit, timedOut, seconds, out (saída, UTF-8)
# e kept; quem chama decide se vira falha de ambiente (exit 4).
function Invoke-Bounded([string]$Root, [string]$Cmd, [int]$TimeoutSec, [hashtable]$Env = @{}, [string]$InputText = '', [switch]$KeepDescendants, [string]$Log = '') {
    $u8 = New-Object System.Text.UTF8Encoding($false)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $tmp = if ($Log) { $Log } else { Join-Path ([System.IO.Path]::GetTempPath()) ('bounded-' + [guid]::NewGuid().ToString('N') + '.log') }
    $pre = "`$ProgressPreference = 'SilentlyContinue'; " + ((@($Env.Keys) | ForEach-Object { "`$env:$_ = '$(([string]$Env[$_]) -replace "'", "''")'; " }) -join '')
    $wrapped = $pre + '$global:LASTEXITCODE = 0; ' + $Cmd + '; if (-not $?) { if ($LASTEXITCODE) { exit $LASTEXITCODE } else { exit 1 } }; exit $LASTEXITCODE'
    $enc = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($wrapped))
    $sp = @{ FilePath = 'powershell'; ArgumentList = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-EncodedCommand', $enc); RedirectStandardOutput = $tmp; RedirectStandardError = "$tmp.err"; NoNewWindow = $true; PassThru = $true }
    if ($Root) { $sp.WorkingDirectory = $Root }
    if ($InputText) { [System.IO.File]::WriteAllText("$tmp.in", $InputText, $u8); $sp.RedirectStandardInput = "$tmp.in" }
    $p = Start-Process @sp
    $null = $p.Handle   # sem o handle aberto, o ExitCode volta vazio no 5.1
    $timedOut = -not $p.WaitForExit([int]([Math]::Max(1, $TimeoutSec) * 1000))
    $kept = @()
    if ($timedOut) {
        if ($KeepDescendants) { $kept = @(Get-DescendantIds $p.Id); Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue } else { $null = Stop-ProcessTree $p.Id }
        $p.WaitForExit(5000) | Out-Null; $code = 124
    } else {
        $code = $p.ExitCode
        if ($KeepDescendants) { $kept = @(Get-DescendantIds $p.Id) } else { $null = Stop-ProcessTree $p.Id -ChildrenOnly }
    }
    Start-Sleep -Milliseconds 200   # o arquivo de saída fica livre depois que os descendentes saem
    $txt = ''
    # FileShare.ReadWrite: o filho que sobrevive (kept) segue com o arquivo aberto para escrita e o ReadAllText falharia.
    foreach ($f in @($tmp, "$tmp.err")) {
        if (-not (Test-Path -LiteralPath $f)) { continue }
        try {
            $fs = New-Object System.IO.FileStream($f, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
            try { $t = (New-Object System.IO.StreamReader($fs, $u8)).ReadToEnd() } finally { $fs.Dispose() }
            if ($t -match '^#< CLIXML') {   # erro do PowerShell em CLIXML: guarda só o texto das mensagens de erro
                $t = (([regex]::Matches($t, '<S S="Error">(.*?)</S>') | ForEach-Object { $_.Groups[1].Value }) -join '') -replace '_x000D__x000A_', "`n" -replace '_x000D_', '' -replace '&lt;', '<' -replace '&gt;', '>' -replace '&amp;', '&'
            }
            if ($t) { $txt += $t + "`n" }
        } catch { }
    }
    if (-not $Log) { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }
    foreach ($f in @("$tmp.err", "$tmp.in")) { Remove-Item -LiteralPath $f -Force -ErrorAction SilentlyContinue }
    $p.Dispose()
    return [pscustomobject]@{ exit = $code; timedOut = $timedOut; seconds = [int]$sw.Elapsed.TotalSeconds; out = $txt.Trim(); kept = $kept }
}

# Modo desprendido (v3.57.0, protocolo de espera): o processo que DEVE sobreviver ao script (emulador, servidor web, filho que o
# reparo declarado deixa vivo) é registrado em .team-project/.target-<alvo>.json — pid, procs[{pid, created}], start, desde.
# "created" é a hora de criação do processo: PID reaproveitado pelo Windows não é confundido com o nosso. É o único registro
# que o target.ps1 -Kill encerra: processo que o run não iniciou nunca é tocado. Sem a pasta .team-project (fora de projeto,
# ou teste), não grava nada e não cria a pasta.
function Get-ProcessCreated([int]$ProcId) {
    try { $c = Get-CimInstance Win32_Process -Filter "ProcessId=$ProcId" -ErrorAction Stop; if ($c -and $c.CreationDate) { return $c.CreationDate.ToString('o') } } catch { }
    return ''
}
function Register-Detached([string]$Root, [string]$Target, [int[]]$ProcIds, [string]$Cmd) {
    $ids = @($ProcIds | Where-Object { $_ -gt 0 })
    $dir = Join-Path $Root '.team-project'
    if (-not $ids.Count -or -not (Test-Path -LiteralPath $dir -PathType Container)) { return $false }
    $procs = @($ids | ForEach-Object { [ordered]@{ pid = [int]$_; created = (Get-ProcessCreated $_) } })
    $j = [ordered]@{ pid = $ids[0]; procs = $procs; start = $Cmd; desde = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
    [System.IO.File]::WriteAllText((Join-Path $dir ".target-$Target.json"), ($j | ConvertTo-Json -Depth 4 -Compress), (New-Object System.Text.UTF8Encoding($false)))
    return $true
}
# Encerra (árvore inteira) só o que o registro do alvo guarda e apaga o registro. Devolve stopped (encerrados), gone (já tinham
# saído) e reused (o PID agora é de outro processo — não tocado).
function Stop-Detached([string]$Root, [string]$Target) {
    $res = [ordered]@{ stopped = 0; gone = 0; reused = 0; registered = $false }
    $f = Join-Path $Root ".team-project/.target-$Target.json"
    if (-not (Test-Path -LiteralPath $f)) { return [pscustomobject]$res }
    $res.registered = $true
    try {
        $j = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF) | ConvertFrom-Json
        $list = if ($j.PSObject.Properties['procs'] -and $j.procs) { @($j.procs) } else { @([pscustomobject]@{ pid = $j.pid; created = '' }) }   # web da v3.57.0 anterior: só pid
        foreach ($pr in $list) {
            $cur = Get-ProcessCreated ([int]$pr.pid)
            if (-not $cur) { $res.gone++ }
            elseif ($pr.created -and [string]$pr.created -ne $cur) { $res.reused++ }
            else { $null = Stop-ProcessTree ([int]$pr.pid); $res.stopped++ }
        }
    } catch { }
    Remove-Item -LiteralPath $f -Force -ErrorAction SilentlyContinue
    return [pscustomobject]$res
}

# APK mais recente de <projeto>/**/build/outputs/apk/{release,debug}/ (v3.57.0: no lib.ps1; era a busca do Resolve-AndroidApk).
function Get-LatestApk([string]$Root) {
    $c = Get-ChildItem -Path $Root -Recurse -Filter '*.apk' -File -ErrorAction SilentlyContinue |
         Where-Object { $_.FullName -match '[\\/]build[\\/]outputs[\\/]apk[\\/](release|debug)[\\/]' -and $_.FullName -notmatch '[\\/](\.team-project|node_modules)[\\/]' -and $_.Name -notmatch 'androidTest' } |
         Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($c) { return $c.FullName }
    return ''
}
# v3.57.1 (note.md item 4, sprint 5 do garden): o APK do projeto — targets.android.apk (caminho relativo à raiz; aceita máscara
# no NOME do arquivo, e vale o mais novo que casa) e, sem ele ou sem arquivo que case, o mais novo de build/outputs/apk/. No
# garden o build roda num container com android/app/build em volume do Docker: build/outputs não existe no Windows e o APK vai
# a source/dist/garden-management-<T-ID>-debug.apk — a conferência de APK velho nunca rodou.
function Find-ConfiguredApk([string]$Root, [string]$Pattern) {
    if (-not $Pattern) { return '' }
    $full = Join-Path $Root $Pattern
    if ($Pattern -notmatch '[*?]') { if (Test-Path -LiteralPath $full -PathType Leaf) { return (Resolve-Path -LiteralPath $full).Path }; return '' }
    $dir = Split-Path $full -Parent; $leaf = Split-Path $full -Leaf
    if ($dir -match '[*?]' -or -not (Test-Path -LiteralPath $dir -PathType Container)) { return '' }
    $c = Get-ChildItem -LiteralPath $dir -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like $leaf } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($c) { return $c.FullName }
    return ''
}
function Get-AndroidTargetValue([string]$Root, [string]$Key) {
    $tc = Get-TargetsConfig $Root
    if ($tc -and $tc.PSObject.Properties['android'] -and $tc.android -and $tc.android.PSObject.Properties[$Key]) { return $tc.android.$Key }
    return $null
}
function Get-ProjectApk([string]$Root) {
    $cfg = [string](Get-AndroidTargetValue $Root 'apk')
    if ($cfg) { $f = Find-ConfiguredApk $Root $cfg; if ($f) { return $f } }
    return (Get-LatestApk $Root)
}
# (movido do targets/android.ps1 na v3.57.0: o verify full também confere o APK ao fim do build)
# v3.53.6 (sprint 5 do garden, item 7): o accept reinstala o APK mais novo do disco, mas o APK do disco estava MAIS VELHO que
# o código (os ids de teste novos não tinham sido construídos) → "tag não encontrada" e um GAP perdido ao Arquiteto. Compara
# o APK com o arquivo-fonte mais novo do módulo (<módulo>/build/outputs/apk/… → <módulo>/src/** .kt/.java, res/**,
# AndroidManifest.xml, build.gradle(.kts); sem src/test e src/androidTest). @{ Stale; File; FileTime; ApkTime; Task; Note }.
# v3.57.1 (note.md item 4): com targets.android.apkSources (pastas e arquivos relativos à raiz — no app híbrido, o código web:
# "source/src", "source/capacitor.config.ts"), a comparação é com essas fontes, sem inferir o módulo; teste (*.spec.*, *.test.*,
# pastas test/__tests__/e2e) e node_modules não entram. Sem a chave, o APK fora de build/outputs dá Note pedindo a declaração.
function Get-ApkStaleness([string]$Apk, [string]$Root = '') {
    $r = @{ Stale = $false; Note = '' }
    if (-not $Apk -or -not (Test-Path -LiteralPath $Apk -PathType Leaf)) { return $r }
    $full = (Resolve-Path -LiteralPath $Apk).Path
    $apkTime = (Get-Item -LiteralPath $full).LastWriteTime
    $srcCfg = if ($Root) { @(Get-AndroidTargetValue $Root 'apkSources' | Where-Object { $_ }) } else { @() }
    if ($srcCfg.Count) {
        $cands = @()
        foreach ($s in $srcCfg) {
            $sp = Join-Path $Root ([string]$s)
            if (Test-Path -LiteralPath $sp -PathType Leaf) { $cands += Get-Item -LiteralPath $sp; continue }
            if (-not (Test-Path -LiteralPath $sp -PathType Container)) { continue }
            $cands += @(Get-ChildItem -LiteralPath $sp -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
                $rel = $_.FullName.Substring($sp.Length) -replace '\\', '/'
                $rel -notmatch '/(node_modules|test|tests|__tests__|e2e)/' -and $_.Name -notmatch '\.(spec|test)\.[^.]+$'
            })
        }
        if (-not $cands.Count) { $r.Note = "idade do APK não conferida: nenhum arquivo em targets.android.apkSources ($($srcCfg -join ', '))"; return $r }
        $newest = $cands | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($newest.LastWriteTime -gt $apkTime.AddSeconds(2)) {
            $r.Stale = $true; $r.File = $newest.FullName; $r.FileTime = $newest.LastWriteTime; $r.ApkTime = $apkTime; $r.Module = $Root; $r.ApkFull = $full
            $r.Task = 'o build que gera o APK'
        }
        return $r
    }
    $m = [regex]::Match($full, '^(.*)[\\/]build[\\/]outputs[\\/]apk[\\/]')
    if (-not $m.Success) { $r.Note = "idade do APK não conferida: o módulo não se infere de $Apk (esperado <módulo>/build/outputs/apk/…) — declare em targets.android.apkSources as fontes que entram no APK (no app híbrido, o código web)"; return $r }
    $mod = $m.Groups[1].Value
    $cands = @()
    foreach ($g in 'build.gradle', 'build.gradle.kts') { $p = Join-Path $mod $g; if (Test-Path -LiteralPath $p) { $cands += Get-Item -LiteralPath $p } }
    $src = Join-Path $mod 'src'
    if (Test-Path -LiteralPath $src) {
        $cands += @(Get-ChildItem -LiteralPath $src -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
            $rel = $_.FullName.Substring($src.Length) -replace '\\', '/'
            $rel -notmatch '^/(test|androidTest|testDebug\w*|testRelease\w*|sharedTest|testFixtures)/' -and ($_.Extension -in '.kt', '.java' -or $_.Name -eq 'AndroidManifest.xml' -or $rel -match '^/[^/]+/res/')
        })
    }
    if (-not $cands.Count) { $r.Note = "idade do APK não conferida: nenhum código-fonte em $mod"; return $r }
    $newest = $cands | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($newest.LastWriteTime -gt $apkTime.AddSeconds(2)) {
        $r.Stale = $true; $r.File = $newest.FullName; $r.FileTime = $newest.LastWriteTime; $r.ApkTime = $apkTime; $r.Module = $mod; $r.ApkFull = $full
        $r.Task = if ($full -match '[\\/]release[\\/]') { 'assembleRelease' } else { 'assembleDebug' }
    }
    return $r
}

# Alvos de execução (v3.51, D3): guards.json → targets ({ "android": {…}, "web": {…} }). $null sem a chave.
# v3.52.2 (note.md item 8): "targets": {} (o modelo do guards.json) também é $null — o objeto vazio é verdadeiro no
# PowerShell, e o next pedia .scn em laço, o plan.ps1 reprovava o cabeçalho de cenário e o close.ps1 o R7-aceite.
function Get-TargetsConfig([string]$Root) {
    $g = Join-Path $Root '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $g)) { return $null }
    try { $j = Read-Text $g | ConvertFrom-Json } catch { return $null }
    if ($j.PSObject.Properties['targets'] -and $null -ne $j.targets -and @($j.targets.PSObject.Properties).Count) { return $j.targets }
    return $null
}

# Atributo que carrega o id de teste (v3.55.0, C2): guards.json → testIds.attribute ("id" | "data-testid" | "testTag" | outro),
# depois targets.web.testIdAttribute (compatibilidade) e, sem nenhum, "data-testid".
function Get-TestIdAttribute([string]$Root) {
    $g = Join-Path $Root '.team-project/guards.json'
    if (Test-Path -LiteralPath $g) {
        try {
            $j = Read-Text $g | ConvertFrom-Json
            if ($j.PSObject.Properties['testIds'] -and $j.testIds -and $j.testIds.PSObject.Properties['attribute'] -and ([string]$j.testIds.attribute).Trim()) { return ([string]$j.testIds.attribute).Trim() }
        } catch { }
    }
    $tc = Get-TargetsConfig $Root
    if ($tc -and $tc.PSObject.Properties['web'] -and $tc.web -and $tc.web.PSObject.Properties['testIdAttribute'] -and $tc.web.testIdAttribute) { return [string]$tc.web.testIdAttribute }
    return 'data-testid'
}

# v3.57.0 (plugin-report do sprint 5 do garden, item 7): o gate de ids de teste assume data-testid sem avisar e reprova id que
# só existe em tempo de execução (montado por função, template ou componente). Duas peças, as duas do stakeholder:
# (1) o atributo foi declarado? (guards.json testIds.attribute ou targets.web.testIdAttribute) — sem declaração, vale o padrão
#     data-testid, e o gate agora diz quando os controles têm outro atributo (id);
# (2) ids dinâmicos declarados: guards.json → testIds.dynamic ["lista.item.*", …] ou, no código, "// testid-dinamico: lista.item.*
#     — <motivo>". O gate não reprova esses ids (o verificador estático não os enxerga): lista-os como "não conferidos".
function Test-TestIdAttributeDeclared([string]$Root) {
    $g = Join-Path $Root '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $g)) { return $false }
    try {
        $j = Read-Text $g | ConvertFrom-Json
        if ($j.PSObject.Properties['testIds'] -and $j.testIds -and $j.testIds.PSObject.Properties['attribute'] -and ([string]$j.testIds.attribute).Trim()) { return $true }
        if ($j.PSObject.Properties['targets'] -and $j.targets -and $j.targets.PSObject.Properties['web'] -and $j.targets.web -and $j.targets.web.PSObject.Properties['testIdAttribute'] -and $j.targets.web.testIdAttribute) { return $true }
    } catch { }
    return $false
}
function Get-TestIdDynamicPatterns([string]$Root, [string]$Blob) {
    $pats = @()
    $g = Join-Path $Root '.team-project/guards.json'
    if (Test-Path -LiteralPath $g) { try { $j = Read-Text $g | ConvertFrom-Json; if ($j.PSObject.Properties['testIds'] -and $j.testIds -and $j.testIds.PSObject.Properties['dynamic']) { $pats += @($j.testIds.dynamic | ForEach-Object { ([string]$_).Trim() } | Where-Object { $_ }) } } catch { } }
    foreach ($m in [regex]::Matches([string]$Blob, '(?i)testid-din[aâ]mico\s*:\s*([A-Za-z0-9_.:/*-]+)')) { $pats += $m.Groups[1].Value }
    return @($pats | Select-Object -Unique)
}
# O padrão (com * como curinga) que cobre o id, ou '' — "lista.item.*" cobre "lista.item.7" e o prefixo "lista.item.".
function Find-TestIdDynamicMatch([string[]]$Patterns, [string]$Id) {
    foreach ($p in @($Patterns)) { if ($Id -like $p -or ($p.EndsWith('*') -and $Id -like ($p.TrimEnd('*') + '*'))) { return $p } }
    return ''
}

# Massa de dados do cenário (v3.53.7, encadeamento do sprint 5 do garden: o reset zera a base e o cenário rodava sem os
# dados de que o critério precisa). guards.json → targets.<alvo>.seeds: { "<nome>": "<comando PowerShell>" }; o .scn pede
# com "seed <nome>". Devolve @{ nome = comando } do alvo (vazio sem a chave).
function Get-TargetSeeds($Cfg) {
    $h = [ordered]@{}
    if (-not $Cfg -or -not $Cfg.PSObject.Properties['seeds'] -or $null -eq $Cfg.seeds) { return $h }
    foreach ($p in $Cfg.seeds.PSObject.Properties) { if ([string]$p.Value) { $h[$p.Name] = [string]$p.Value } }
    return $h
}
# Roda o comando da massa num PowerShell filho, na raiz do projeto, com prazo (targets.<alvo>.seedTimeoutSec, padrão 300)
# e as variáveis ACCEPT_TARGET, ACCEPT_SEED e as de $Env (ACCEPT_SERIAL, ACCEPT_PACKAGE, ACCEPT_URL). $null quando carregou
# (exit 0); senão o motivo — quem chama trata como FALHA DE AMBIENTE: a pré-condição não existe, o app nem foi exercitado.
function Invoke-TargetSeed([string]$Root, [string]$Target, $Cfg, [string]$Name, [hashtable]$Env = @{}) {
    $seeds = Get-TargetSeeds $Cfg
    if (-not $seeds.Contains($Name)) { return "massa de dados '$Name' não declarada em guards.json → targets.$Target.seeds" }
    $sec = if ($Cfg.PSObject.Properties['seedTimeoutSec'] -and $Cfg.seedTimeoutSec) { [int]$Cfg.seedTimeoutSec } else { 300 }
    # Protocolo de espera (v3.57.0): Invoke-Bounded — saída em arquivo e espera pelo processo. Antes, o WaitForExit() sem prazo
    # depois do prazo esperava o fim do pipe, e um filho que herdasse a saída prendia a massa de dados para sempre.
    $envAll = @{ ACCEPT_TARGET = $Target; ACCEPT_SEED = $Name }
    foreach ($k in $Env.Keys) { $envAll[[string]$k] = [string]$Env[$k] }
    $r = Invoke-Bounded $Root $seeds[$Name] $sec -Env $envAll
    if ($r.timedOut) { return "massa de dados '$Name' sem resposta em $sec s (targets.$Target.seedTimeoutSec)" }
    if ($r.exit -eq 0) { return $null }
    $tail = @($r.out -split "`r?`n" | Where-Object { $_.Trim() -and $_ -notmatch '^#< CLIXML|^<Objs\b' } | Select-Object -Last 2) -join ' / '
    return "massa de dados '$Name' não carregou (exit $($r.exit))$(if ($tail) { ": $tail" })"
}

# Plano externo (v3.53.4): guards.json → "run": { "planner": "external", "tasks": [] }. $null sem a chave ou com outro
# planner (o padrão é "claude": o Arquiteto Opus planeja); senão o objeto com Tasks = a lista do piloto (vazia = todas).
function Get-RunPlanner([string]$Root) {
    $g = Join-Path $Root '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $g)) { return $null }
    try { $j = Read-Text $g | ConvertFrom-Json } catch { return $null }
    if (-not $j.PSObject.Properties['run'] -or $null -eq $j.run -or -not $j.run.PSObject.Properties['planner']) { return $null }
    if ([string]$j.run.planner -ne 'external') { return $null }
    $ids = @(); if ($j.run.PSObject.Properties['tasks'] -and $null -ne $j.run.tasks) { $ids = @($j.run.tasks | ForEach-Object { ([string]$_).Trim() } | Where-Object { $_ }) }
    return [pscustomobject]@{ Tasks = $ids }
}
# A Task vai ao plano externo? Com a lista do piloto, só as dela; sem lista, todas (as com ficha — quem chama confere).
function Test-ExternalTask($Planner, [string]$Id) {
    if (-not $Planner) { return $false }
    return (-not @($Planner.Tasks).Count) -or (@($Planner.Tasks) -contains $Id)
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
            if ($alive -and $age -lt $StaleHours) {
                # v3.53.5: com o sinal de vida — parado, diz como sair em vez de "espere" por até 3 h.
                $pu = Get-WaitPulse ([int]$l.pid) ([string]$l.desde)
                return "o alvo $([string]$l.target) está em uso por '$([string]$l.owner)' (PID $([int]$l.pid), desde $([string]$l.desde); $($pu.Text)): " + $(if ($pu.Stalled) { "o processo parece travado — encerre o PID $([int]$l.pid) (decisão do stakeholder) e rode target.ps1 -Target $([string]$l.target) -Unlock" } else { 'espere terminar — dois automatizadores no mesmo alvo quebram os dois' })
            }
        }
    }
    New-Item -ItemType Directory -Force (Split-Path $lp) | Out-Null
    [System.IO.File]::WriteAllText($lp, ([ordered]@{ target = $Target; owner = $Owner; pid = $PID; desde = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') } | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false)))
    return $null
}
# v3.53.3 (sprint 5 do garden): comando da Task que ainda roda — verify (verify.lock da pasta da Task, processo vivo) ou
# accept (trava do alvo com dono "accept <ID>", processo vivo). Comando que passa de ~3 min vai para segundo plano e o dev
# encerra o turno esperando o aviso dele; para quem o disparou, o dev "voltou". O executor rodava done/start e punha outro
# dev ao lado do primeiro (T-058: 3 devs; T-059: o accept da instância anterior prendeu o alvo e o run pausou). Texto ou $null.
#
# v3.53.5 (sprint 5 do garden): também o reparo do alvo (target.ps1 -Repair, ou qualquer dono que não seja o accept de OUTRA
# Task) — o dev da T-061 rodou o reparo em segundo plano e encerrou o turno; a trava tinha dono "target.ps1 android", o next
# não a via e mandava disparar outro executor, cujo accept ficaria até 3 h barrado pela trava. E cada espera traz o sinal de
# vida (Get-WaitPulse): há quanto tempo, CPU, em que comando espera, último arquivo — e POSSÍVEL TRAVAMENTO.
# Get-TaskWait devolve @{ Text; Pulse } ou $null; Get-TaskBusy, só o texto (com o sinal de vida).
function Get-TaskWait([string]$Root, [string]$Id) {
    $vd = Get-VerifyDir $Root $Id
    $lp = Join-Path $vd 'verify.lock'
    if (Test-Path -LiteralPath $lp) {
        $l = $null; try { $l = Read-Text $lp | ConvertFrom-Json } catch { }
        if ($l -and $l.pid -and [int]$l.pid -ne $PID) {
            $p = Get-Process -Id ([int]$l.pid) -ErrorAction SilentlyContinue
            if ($p -and (-not $l.started -or $p.StartTime.ToString('o') -eq [string]$l.started)) {
                $pu = Get-WaitPulse ([int]$l.pid) ([string]$l.at) $vd
                return [pscustomobject]@{ Text = "verify $([string]$l.mode) (pid $([int]$l.pid), desde $([string]$l.at)) — $($pu.Text)"; Pulse = $pu }
            }
        }
    }
    $tl = Join-Path $Root '.team-project/.target-lock'
    if (Test-Path -LiteralPath $tl) {
        $t = $null; try { $t = Read-Text $tl | ConvertFrom-Json } catch { }
        $own = if ($t) { [string]$t.owner } else { '' }
        if ($t -and ($own -eq "accept $Id" -or $own -notmatch '^accept ') -and [int]$t.pid -ne $PID -and (Get-Process -Id ([int]$t.pid) -ErrorAction SilentlyContinue)) {
            $age = try { ((Get-Date) - [datetime]::ParseExact([string]$t.desde, 'yyyy-MM-dd HH:mm:ss', $null)).TotalHours } catch { 999 }
            if ($age -lt 3) {
                $isAcc = $own -eq "accept $Id"
                $pu = Get-WaitPulse ([int]$t.pid) ([string]$t.desde) $(if ($isAcc) { $vd -replace '([\\/]\.team-project[\\/])verify([\\/])', '$1accept$2' } else { '' })
                $what = if ($isAcc) { "accept no alvo $([string]$t.target)" } else { "reparo/conferência do alvo $([string]$t.target) ($own)" }
                # v3.54.2 (item 3): no accept, o avanço — cenários passados e falhados desta rodada (progress.json do mesmo
                # processo). Nenhum passou em 15 min ou mais, com 2 ou mais falhas: SEM AVANÇO (a captura de falha gravada
                # contava como sinal de vida e o next mandava esperar 50 min).
                $prog = ''; $noProg = ''
                if ($isAcc) {
                    $g = Get-AcceptProgress $Root $Id
                    if ($g -and $g.Pid -eq [int]$t.pid) {
                        $prog = " · cenários: $($g.Passed) passaram, $($g.Failed) falharam de $($g.Total)$(if ($g.Streak -ge 2) { " ($($g.Streak) seguidos)" })$(if ($g.LastText) { "; último: $($g.LastText)" })"
                        if ($pu.Min -ge 15 -and $g.Passed -eq 0 -and $g.Failed -ge 2) { $noProg = "$($g.Failed) cenário(s) falharam e nenhum passou em $([int]$pu.Min) min$(if ($g.LastText) { " — último: $($g.LastText)" })" }
                    }
                }
                return [pscustomobject]@{ Text = "$what (pid $([int]$t.pid), desde $([string]$t.desde)) — $($pu.Text)$prog"; Pulse = $pu; NoProgress = $noProg }
            }
        }
    }
    return $null
}
function Get-TaskBusy([string]$Root, [string]$Id) { $w = Get-TaskWait $Root $Id; if ($w) { return $w.Text }; return $null }

# v3.54.2 (carta do sprint 5 do garden, item 3): progresso do accept da Task (progress.json, gravado a cada cenário; sem
# ele, o result.json do fim). @{ Pid; Total; Passed; Failed; Streak; Last; LastText } ou $null. LastText = "SC-117 — <detalhe>
# (captura <caminho>)": a tela em texto, para a sessão não abrir a imagem.
function Get-AcceptProgress([string]$Root, [string]$Id) {
    $ad = (Get-VerifyDir $Root $Id) -replace '([\\/]\.team-project[\\/])verify([\\/])', '$1accept$2'
    $p = $null
    foreach ($f in 'progress.json', 'result.json') { $fp = Join-Path $ad $f; if (Test-Path -LiteralPath $fp) { try { $p = Read-Text $fp | ConvertFrom-Json; $src = $f; break } catch { } } }
    if (-not $p) { return $null }
    $last = $null
    if ($src -eq 'progress.json') { $last = $p.last } else { $last = @($p.results | Where-Object { $_.status -ne 'PASSOU' }) | Select-Object -Last 1 }
    $lt = ''
    if ($last -and $last.status -ne 'PASSOU') {
        $d = (([string]$last.detail) -replace '\s+', ' ').Trim(); if ($d.Length -gt 160) { $d = $d.Substring(0, 160) + '…' }
        $lt = "$($last.id) — $d$(if ($last.shot) { " (captura $($last.shot))" })"
    }
    $passed = [int]$p.passed; $total = [int]$p.total
    $failed = if ($p.PSObject.Properties['failed']) { [int]$p.failed } else { @($p.results).Count - $passed }
    $streak = if ($p.PSObject.Properties['streak']) { [int]$p.streak } else { 0 }
    return [pscustomobject]@{ Pid = $(if ($p.PSObject.Properties['pid']) { [int]$p.pid } else { 0 }); Total = $total; Passed = $passed; Failed = $failed; Streak = $streak; LastText = $lt }
}
function Get-AcceptLastFailure([string]$Root, [string]$Id) { $g = Get-AcceptProgress $Root $Id; if ($g -and $g.LastText) { return $g.LastText }; return '' }

# v3.53.5: sinal de vida de um comando em espera (só lê): há quanto tempo roda, a CPU da árvore de processos (ele e os
# filhos — a suíte roda em node/chrome filhos), o processo mais fundo da árvore (onde de fato espera) e a última gravação na
# pasta do job. Parado = 10 min ou mais, nenhum arquivo novo há 10 min e CPU abaixo de 0,5 % de um núcleo no período todo
# (o reparo do garden: 81 min, 1 s de CPU, à espera de "adb emu kill"). @{ Min; CpuS; Leaf; WriteMin; Stalled; Text }.
function Get-WaitPulse([int]$ProcId, [string]$Desde = '', [string]$Dir = '') {
    $now = Get-Date
    $all = @(); try { $all = @(Get-CimInstance Win32_Process -ErrorAction Stop | Select-Object ProcessId, ParentProcessId, Name, CommandLine, CreationDate) } catch { }
    $root = @($all | Where-Object { $_.ProcessId -eq $ProcId }) | Select-Object -First 1
    $tree = @(); if ($root) { $tree = @($root) }
    $front = @($ProcId)
    for ($d = 0; $d -lt 8 -and $front.Count; $d++) {
        $kids = @($all | Where-Object { $front -contains $_.ParentProcessId -and $_.ProcessId -ne $ProcId -and (-not $root -or -not $root.CreationDate -or $_.CreationDate -ge $root.CreationDate) })
        $tree += $kids; $front = @($kids | ForEach-Object { $_.ProcessId })
    }
    $cpu = 0.0; foreach ($x in $tree) { $gp = Get-Process -Id ([int]$x.ProcessId) -ErrorAction SilentlyContinue; if ($gp) { try { $cpu += $gp.TotalProcessorTime.TotalSeconds } catch { } } }
    $start = $null; try { if ($Desde) { $start = [datetime]::Parse($Desde) } } catch { }
    if (-not $start -and $root -and $root.CreationDate) { $start = $root.CreationDate }
    $min = if ($start) { [Math]::Max(0, ($now - $start).TotalMinutes) } else { 0 }
    $leafP = @($tree | Where-Object { $_.Name -notmatch '^(?i)conhost\.exe$' } | Sort-Object CreationDate) | Select-Object -Last 1
    $leaf = ''
    if ($leafP -and $leafP.ProcessId -ne $ProcId) {
        $cl = [string]$leafP.CommandLine
        $argsOnly = ($cl -replace '^\s*("[^"]+"|\S+)\s*', '').Trim()
        $leaf = ("$($leafP.Name) $argsOnly").Trim(); if ($leaf.Length -gt 70) { $leaf = $leaf.Substring(0, 70) + '…' }
    }
    $wmin = $null
    if ($Dir -and (Test-Path -LiteralPath $Dir)) {
        $lw = @(Get-ChildItem -LiteralPath $Dir -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'verify.lock' } | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
        if ($lw.Count) { $wmin = [Math]::Max(0, ($now - $lw[0].LastWriteTime).TotalMinutes) }
    }
    $stalled = ($min -ge 10) -and ($null -eq $wmin -or $wmin -ge 10) -and ($cpu -lt [Math]::Max(5, $min * 60 * 0.005))
    $fmt = { param($m) if ($m -lt 60) { "$([int][Math]::Floor($m)) min" } else { '{0}h{1:00}' -f [int][Math]::Floor($m / 60), [int][Math]::Floor($m % 60) } }
    $txt = "há $(& $fmt $min) · CPU $([int][Math]::Round($cpu)) s" + $(if ($leaf) { " · esperando: $leaf" } else { '' }) + $(if ($null -ne $wmin) { " · último arquivo há $(& $fmt $wmin)" } elseif ($Dir) { ' · nenhum arquivo gravado' } else { '' })
    if ($stalled) { $txt += " · $([char]0x26A0) POSSÍVEL TRAVAMENTO (sem CPU nem arquivo novo há 10 min ou mais)" }
    return [pscustomobject]@{ Min = $min; CpuS = $cpu; Leaf = $leaf; WriteMin = $wmin; Stalled = $stalled; Text = $txt }
}

# v3.57.1 (note.md item 1, sprint 5 do garden): sinal de vida DECLARADO PELO PROJETO para a espera que o plugin não mede. O
# Get-WaitPulse vê o verify e o accept (as travas deles); o build do APK do garden (npm run alvo:apk → docker compose run builder
# → gradlew no container, com android/app/build em volume do Docker) roda como comando do dev: o wait só via "developer vivo há
# N min", sem saber se o build anda — a CPU é do container e as gravações caem num volume que o Windows não enxerga. O projeto
# declara em guards.json → "waitSignals": [{ "when": "<trecho do comando>", "paths": [pastas ou arquivos que o trabalho grava],
# "alive": "<comando que imprime algo enquanto o trabalho roda>" }]. Casou com a última ação do agente: o texto diz o último
# arquivo e o alive; parado = 10 min ou mais sem ação do agente, sem arquivo novo nas pastas e alive sem saída. Só lê; o alive
# roda pelo Invoke-Bounded com 20 s. @{ Text; Stalled } ou $null.
function Get-ProjectWaitSignal([string]$Root, [string]$Last, [double]$IdleMin) {
    if (-not $Last) { return $null }
    $g = Join-Path $Root '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $g)) { return $null }
    $cfg = $null; try { $cfg = Read-Text $g | ConvertFrom-Json } catch { return $null }
    if (-not $cfg -or -not $cfg.PSObject.Properties['waitSignals']) { return $null }
    foreach ($s in @($cfg.waitSignals)) {
        if (-not $s -or -not $s.PSObject.Properties['when'] -or -not [string]$s.when) { continue }
        if ($Last.IndexOf([string]$s.when, [StringComparison]::OrdinalIgnoreCase) -lt 0) { continue }
        $now = Get-Date; $wmin = $null; $wpath = ''
        foreach ($p in @($s.paths | Where-Object { $_ })) {
            $fp = Join-Path $Root ([string]$p)
            if (-not (Test-Path -LiteralPath $fp)) { continue }
            $it = if (Test-Path -LiteralPath $fp -PathType Leaf) { Get-Item -LiteralPath $fp } else { Get-ChildItem -LiteralPath $fp -Recurse -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1 }
            if ($it) { $m = [Math]::Max(0, ($now - $it.LastWriteTime).TotalMinutes); if ($null -eq $wmin -or $m -lt $wmin) { $wmin = $m; $wpath = [string]$p } }
        }
        $alive = $null
        if ($s.PSObject.Properties['alive'] -and [string]$s.alive) {
            $r = Invoke-Bounded $Root ([string]$s.alive) 20
            $alive = ([int]$r.exit -eq 0) -and ([string]$r.out).Trim().Length -gt 0
        }
        $parts = @("sinal do projeto ($([string]$s.when))")
        if ($null -ne $wmin) { $parts += "último arquivo em $wpath há $([int][Math]::Floor($wmin)) min" } elseif (@($s.paths).Count) { $parts += 'nenhum arquivo nas pastas declaradas' }
        if ($null -ne $alive) { $parts += $(if ($alive) { 'alive: rodando' } else { 'alive: sem saída' }) }
        $stalled = ($IdleMin -ge 10) -and ($null -eq $wmin -or $wmin -ge 10) -and ($alive -ne $true)
        return [pscustomobject]@{ Text = ($parts -join ' · '); Stalled = $stalled }
    }
    return $null
}

# v3.53.5 (sprint 5 do garden: 43 bloqueios da G20 num dia, todos na T-042, enquanto o next mandava esperar a T-061): o
# run.ps1 next grava aqui a decisão de esperar e a G20 (hooks/stop.ps1) segue a mesma decisão por 30 min. Acao '' apaga.
function Set-NextVerdict([string]$Root, [string]$Acao, [string]$Task = '', [string]$Motivo = '') {
    $p = Join-Path $Root '.team-project/.next-verdict'
    if (-not $Acao) { Remove-Item -LiteralPath $p -Force -ErrorAction SilentlyContinue; return }
    if ($Motivo.Length -gt 300) { $Motivo = $Motivo.Substring(0, 300) + '…' }
    [System.IO.File]::WriteAllText($p, ([ordered]@{ acao = $Acao; task = $Task; motivo = $Motivo; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') } | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false)))
}
function Exit-TargetLock([string]$Root) {
    $lp = Join-Path $Root '.team-project/.target-lock'
    if (Test-Path -LiteralPath $lp) { try { $l = Read-Text $lp | ConvertFrom-Json; if ([int]$l.pid -eq $PID) { Remove-Item -LiteralPath $lp -Force } } catch { Remove-Item -LiteralPath $lp -Force -ErrorAction SilentlyContinue } }
}

# Sprint corrente (v3.51.4): a linha "Sprint corrente" do README §2. O modelo grava "| **Sprint corrente** | **<n>** — …";
# aceita também o número sem negrito e com "sprint" antes ("| **Sprint corrente** | sprint **2** …") — no garden o SM
# escreveu assim e o run.ps1 next saiu com exit 2. $null se a linha não existe.
$script:SprintLineRe = '(?im)^\|\s*\*{0,2}Sprint corrente\*{0,2}\s*\|\s*(?:\*\*)?\s*(?:sprint\s*)?(?:\*\*)?\s*(\d+)'
function Get-CurrentSprint([string]$Readme) {
    $m = [regex]::Match($Readme, $script:SprintLineRe)
    if ($m.Success) { return $m.Groups[1].Value }
    return $null
}
$script:SprintLineHelp = 'a linha "Sprint corrente" de .team-project/README.md §2 no formato "| **Sprint corrente** | **<n>** — <objetivo> · quadro vivo: ..." (templates/project-context.md)'

# Trava curta de arquivo (v3.51.4): mark.ps1, close.ps1 -Apply e kanban.ps1 leem, mudam e regravam o kanban.md; o
# kanban.ps1 roda também pelo hook G16 no fim de cada rodada, ao mesmo tempo que a sessão marca uma Task — a escrita que
# chegava por último apagava a linha da Série gravada no meio (garden item 23). Executa $Body com <arquivo>.lock aberto em
# modo exclusivo; espera até $WaitMs e, sem a trava, roda assim mesmo (nunca trava o chamador).
function Invoke-WithFileLock([string]$Path, [scriptblock]$Body, [int]$WaitMs = 8000) {
    $fs = Enter-FileLock $Path $WaitMs
    try { return (& $Body) }
    finally { Exit-FileLock $fs $Path }
}
# A mesma trava em dois passos, para quem precisa das variáveis do trecho depois dele (close.ps1 -Apply).
function Enter-FileLock([string]$Path, [int]$WaitMs = 8000) {
    $lp = "$Path.lock"; $fs = $null; $sw = [System.Diagnostics.Stopwatch]::StartNew()
    while ($null -eq $fs -and $sw.ElapsedMilliseconds -lt $WaitMs) {
        try { $fs = [System.IO.File]::Open($lp, [System.IO.FileMode]::OpenOrCreate, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None) }
        catch { Start-Sleep -Milliseconds 100 }
    }
    return $fs
}
function Exit-FileLock($Stream, [string]$Path) {
    if ($Stream) { $Stream.Dispose(); Remove-Item -LiteralPath "$Path.lock" -Force -ErrorAction SilentlyContinue }
}

# Cenários de uma célula (v3.53.2, sprint 5 do garden): "SC-145 (teste)" é provado por teste do plano (serviço, render,
# processo, gate, ação irreversível) — não vai ao .scn nem ao accept no alvo. -TargetOnly devolve só os provados na tela.
# Antes, todo cenário mapeado exigia .scn: 9 formulários ao stakeholder para "tirar do mapeamento" no meio do run.
function Get-ScenarioIds([string]$Cell, [switch]$TargetOnly) {
    $re = if ($TargetOnly) { '\b[A-Z]{2,}-\d+\b(?!\s*\((?i:teste)\))' } else { '\b[A-Z]{2,}-\d+\b' }
    return @([regex]::Matches($Cell, $re) | ForEach-Object { $_.Value } | Where-Object { $_ -match '^SC-' } | Select-Object -Unique)
}
# v3.56.0 (H2): os cenários que o plano declara na linha **Cenários:** — @{ None; Target; Test } ou $null sem a linha legível
# (aí vale o backlog). "nenhum — <motivo>" = nenhum cenário (o cartão não manda rodar o accept).
function Get-PlanScenarios([string]$PlanText) {
    $cm = [regex]::Match([string]$PlanText, '(?m)^\*\*Cen[áa]rios:\*\*\s*(.+)$')
    if (-not $cm.Success) { return $null }
    $v = $cm.Groups[1].Value
    # v3.57.2 (note.md item 15, ocorrência 7): "nenhum aplicável — motivo" vale como "nenhum — motivo" (a forma da coluna do quadro;
    # o close.ps1 já a aceitava ali e a T-046 do garden reprovou no R7-aceite até trocar o texto do plano).
    if ($v -match '^\s*nenhum(?:\s+aplic[áa]vel)?\s*[—–-]\s*(\S.*)$') { return @{ None = $true; Target = @(); Test = @(); Reason = $Matches[1].Trim() } }
    $tg = @(Get-ScenarioIds $v -TargetOnly); $all = @(Get-ScenarioIds $v)
    if (-not $all.Count) { return $null }
    # v3.57.0 (plugin-report do sprint 5 do garden, item 5): o plano que DECLARA que o aceite não roda — "**Aceite:** não roda —
    # <motivo>" ou uma linha de Aceite/Decisão que diga "o aceite não roda" — vale mais que a lista de cenários no alvo: o
    # cartão, o start e o next mandavam rodar o accept numa Task cujo plano dizia o contrário, e o dev abria GAP de processo.
    # Os cenários passam a ser provados pelos testes do plano (lista Test); o motivo vai ao cartão.
    $wv = [regex]::Match([string]$PlanText, '(?im)^[ \t]*(?:[-*][ \t]+)?(?:\*\*)?(?:Aceite|Accept)\b[^\r\n:]*:[^\r\n]*?n[ãa]o[ \t]+roda\b[^\r\n]*$')
    if (-not $wv.Success) { $wv = [regex]::Match([string]$PlanText, '(?im)^[ \t]*(?:[-*][ \t]+)?(?:\*\*)?Decis[ãa]o\b[^\r\n]*\b(?:accept|aceite)\b[^\r\n]*n[ãa]o[ \t]+roda\b[^\r\n]*$') }
    if ($wv.Success) {
        $why = ($wv.Value.Trim() -replace '\*\*', '' -replace '\s+', ' '); if ($why.Length -gt 160) { $why = $why.Substring(0, 160) + '…' }
        return @{ None = $false; Target = @(); Test = $all; Waived = $true; Reason = $why }
    }
    return @{ None = $false; Target = $tg; Test = @($all | Where-Object { $tg -notcontains $_ }) }
}
# v3.56.0 (H2): os arquivos .scn que definem os cenários pedidos (caminho relativo à raiz, '/'), para o -Scenarios do accept
# em vez da máscara de todos os arquivos — um cenário inválido de outra História não entra na leitura.
function Get-ScenarioFiles([string]$Root, [string[]]$Ids) {
    $d = Join-Path $Root '.team-project/quality-assurance/scenarios'; $out = @()
    foreach ($f in @(Get-ChildItem -Path $d -Filter '*.scn' -File -ErrorAction SilentlyContinue | Sort-Object Name)) {
        $def = @([regex]::Matches((Read-Text $f.FullName), '(?m)^\s*scenario\s+(\S+)') | ForEach-Object { $_.Groups[1].Value })
        if (@($Ids | Where-Object { $def -contains $_ }).Count) { $out += ".team-project/quality-assurance/scenarios/$($f.Name)" }
    }
    return $out
}
# Cenário que aguarda uma Task (v3.53.2): o QA declara no .scn "# aguarda T-071: SC-143, SC-144" quando os nomes de teste
# que o cenário usa nascem numa Task do sprint. Até ela fechar, o next não pede o cenário nem constrói a Task que o cita;
# depois, pede. Antes, o next exigia o .scn antes da Task que criava os nomes (o run do garden travou e a sessão pulou a ordem).
function Get-DeferredScenarios([string]$Root) {
    $map = @{}
    $d = Join-Path $Root '.team-project/quality-assurance/scenarios'
    foreach ($f in @(Get-ChildItem -Path $d -Filter '*.scn' -File -ErrorAction SilentlyContinue)) {
        foreach ($m in [regex]::Matches((Read-Text $f.FullName), '(?m)^\s*#\s*aguarda\s+(' + $script:TaskIdRe + ')\s*:\s*(.+)$')) {
            foreach ($s in [regex]::Matches($m.Groups[2].Value, 'SC-\d+')) { $map[$s.Value] = $m.Groups[1].Value }
        }
    }
    return $map
}

# Ciclo na fila de espera (v3.57.0, plugin-report do sprint 5 do garden, item 6): Edges = @{ 'T-a' = @('T-b', …) } — quem espera
# quem (dependência do quadro ou "# aguarda" do .scn). Devolve o primeiro ciclo achado como lista fechada (T-a, T-b, T-a) ou
# @() sem ciclo. A fila ficava "sem Task elegível" e só o Arquiteto, relendo o .scn e os planos, via que duas Tasks se esperavam.
function Find-WaitCycle([hashtable]$Edges) {
    $state = @{}; $stack = New-Object System.Collections.ArrayList; $script:wcFound = @()
    $visit = $null
    $visit = {
        param($id)
        if ($script:wcFound.Count) { return }
        $state[$id] = 1; [void]$stack.Add($id)
        foreach ($b in @($Edges[$id])) {
            if ($script:wcFound.Count) { break }
            if (-not $Edges.ContainsKey($b)) { continue }
            if ($state[$b] -eq 1) { $i = $stack.IndexOf($b); $script:wcFound = @($stack.GetRange($i, $stack.Count - $i)) + @($b); break }
            if (-not $state.ContainsKey($b)) { & $visit $b }
        }
        $stack.RemoveAt($stack.Count - 1); $state[$id] = 2
    }
    foreach ($k in @($Edges.Keys | Sort-Object)) { if (-not $state.ContainsKey($k)) { & $visit $k } }
    return @($script:wcFound)
}

# ---------- ids de teste como padrão de código (v3.53.6, sprint 5 do garden, item 4) ----------
# Pedido do stakeholder: "nunca mais termos problema durante as rotinas de QA". No sprint 5 o QA escreveu .scn com ids que o
# código não tinha e o dev não criou: "tag não encontrada" no accept, GAP ao Arquiteto e rodadas perdidas. O verify -Mode full
# agora REPROVA (a) id citado nos cenários da Task que não existe literalmente no código de produção e (b) controle
# interativo sem id de teste nos arquivos da Task. Exceção explícita: "// sem-testid: <motivo>" (ou {/* sem-testid: … */},
# <!-- sem-testid: … -->) na mesma linha ou na anterior, com motivo.
$script:ScnIdVerbs = @('tap', 'type', 'slider', 'assert-text', 'assert-contains', 'assert-exists', 'assert-absent', 'assert-checked', 'assert-count', 'assert-order')
# Ids citados nos cenários pedidos, com cenário, arquivo e linha. assert-count/assert-order citam um PREFIXO.
function Get-ScnTestIdRefs([string]$Root, [string[]]$Scenarios) {
    $out = @()
    $d = Join-Path $Root '.team-project/quality-assurance/scenarios'
    foreach ($f in @(Get-ChildItem -Path $d -Filter '*.scn' -File -ErrorAction SilentlyContinue | Sort-Object FullName)) {
        $rel = ($f.FullName.Substring($Root.Length).TrimStart('\', '/') -replace '\\', '/'); $n = 0; $cur = $null
        foreach ($raw in ((Read-Text $f.FullName) -split "`r?`n")) {
            $n++; $l = $raw.Trim(); if (-not $l -or $l.StartsWith('#')) { continue }
            if ($l -match '^scenario\s+(\S+)') { $cur = $Matches[1]; continue }
            if (-not $cur -or $Scenarios -notcontains $cur) { continue }
            $parts = $l -split '\s+', 2; if ($parts.Count -lt 2 -or $script:ScnIdVerbs -notcontains $parts[0]) { continue }
            $id = @((($parts[1] -split '=', 2)[0]).Trim() -split '\s+')[0]
            if ($id) { $out += [pscustomobject]@{ Id = $id; Prefix = ($parts[0] -eq 'assert-count' -or $parts[0] -eq 'assert-order'); Scenario = $cur; File = $rel; Line = $n } }
        }
    }
    return $out
}
# Caminho fora do código de produção: testes, build, gerados, dependências, processo.
function Test-TestIdExcluded([string]$Rel) {
    $r = '/' + ($Rel -replace '\\', '/').TrimStart('/')
    return [bool]($r -match '/(\.team-project|docs|build|dist|generated|node_modules|\.gradle|coverage|e2e|__tests__|__mocks__|test|tests|androidTest|testDebug\w*|testRelease\w*|sharedTest|testFixtures)/' -or
                   $r -match '\.(spec|test|stories)\.[jt]sx?$' -or $r -match '(Test|Tests|Spec)\.(kt|java)$')
}
# Arquivos de produção do projeto (git ls-files com os não rastreados, sem o .gitignore) onde um id pode morar.
function Get-TestIdSourceFiles([string]$Root) {
    $ErrorActionPreference = 'Continue'
    $list = @(& git -C $Root ls-files -co --exclude-standard 2>$null)
    if ($LASTEXITCODE -ne 0) { return @() }
    return @($list | Where-Object { $_ -match '\.(kt|java|tsx?|jsx?|html?|vue)$' -and -not (Test-TestIdExcluded $_) })
}
# O id existe no código: literal entre aspas (constante vale) ou, para id dinâmico, o prefixo até um separador seguido de
# interpolação ("lista.item.$id", `lista.item.${id}`, 'lista.item.' + id, "lista.item.{{ id }}"). Prefixo (assert-count) =
# um literal que começa com ele.
function Test-TestIdInSource([string]$Blob, [string]$Id, [bool]$Prefix) {
    $q = '["''`]'
    if ($Prefix) { if ([regex]::IsMatch($Blob, $q + [regex]::Escape($Id))) { return $true } }
    elseif ([regex]::IsMatch($Blob, $q + [regex]::Escape($Id) + $q)) { return $true }
    for ($k = $Id.Length - 1; $k -gt 0; $k--) {
        if ('.-_:/'.IndexOf($Id[$k - 1]) -lt 0) { continue }
        if ([regex]::IsMatch($Blob, $q + [regex]::Escape($Id.Substring(0, $k)) + '(\$|\{\{|' + $q + '\s*\+)')) { return $true }
    }
    return $false
}
# Fim do trecho balanceado que abre em $Open ('(' ou '{'), pulando strings e comentários; -1 sem fechamento.
function Get-BalancedEnd([string]$T, [int]$Open) {
    $o = $T[$Open]; $c = if ($o -eq '(') { [char]')' } else { [char]'}' }
    $depth = 0; $i = $Open; $n = $T.Length
    while ($i -lt $n) {
        $ch = $T[$i]
        if ($ch -eq [char]'"' -or $ch -eq [char]"'") { $qc = $ch; $i++; while ($i -lt $n -and $T[$i] -ne $qc) { if ($T[$i] -eq [char]'\') { $i++ }; $i++ } }
        elseif ($ch -eq [char]'/' -and $i + 1 -lt $n -and $T[$i + 1] -eq [char]'/') { $nl = $T.IndexOf("`n", $i); if ($nl -lt 0) { return -1 }; $i = $nl }
        elseif ($ch -eq [char]'/' -and $i + 1 -lt $n -and $T[$i + 1] -eq [char]'*') { $e = $T.IndexOf('*/', $i + 2); if ($e -lt 0) { return -1 }; $i = $e + 1 }
        elseif ($ch -eq $o) { $depth++ }
        elseif ($ch -eq $c) { $depth--; if ($depth -eq 0) { return $i } }
        $i++
    }
    return -1
}
# Exceção declarada na linha ou na anterior: 'ok' (com motivo), 'vazia' (sem motivo) ou ''.
function Get-NoTestIdException([string[]]$Lines, [int]$Line) {
    foreach ($k in @($Line, ($Line - 1))) {
        if ($k -lt 1 -or $k -gt $Lines.Count) { continue }
        $m = [regex]::Match($Lines[$k - 1], 'sem-testid:(.*)$')
        if ($m.Success) { $why = ($m.Groups[1].Value -replace '(\*/\s*\}?|-->)\s*$', '').Trim(); if ($why) { return 'ok' } else { return 'vazia' } }
    }
    return ''
}
# Controles interativos sem id de teste num arquivo (heurística por stack): "<arquivo>:<linha> — <o que falta>".
# Kotlin/Compose: Button(, IconButton(, TextField(, Checkbox(, Switch(… precisam de testTag( nos argumentos da chamada;
# .clickable/.toggleable/.selectable precisam de testTag( na mesma chamada que recebe o modifier; items( de LazyColumn/
# LazyRow precisa de testTag( no item. Web (html, tsx, jsx, vue): <button, <input, <select, <textarea e <a com
# href/onClick/(click)/routerLink precisam do atributo ($Attr, padrão data-testid).
function Find-UntaggedUi([string]$Rel, [string]$Text, [string]$Attr = 'data-testid') {
    $out = @(); if (-not $Text) { return $out }
    $lines = $Text -split "`n"
    $nl = @([regex]::Matches($Text, "`n") | ForEach-Object { $_.Index }); [int[]]$nla = $nl
    $lineOf = { param($ix) $k = [Array]::BinarySearch($nla, [int]$ix); if ($k -lt 0) { $k = -bnot $k }; $k + 1 }
    $flag = { param($ix, $what)
        $ln = & $lineOf $ix; $ex = Get-NoTestIdException $lines $ln
        if ($ex -eq 'ok') { return $null }
        if ($ex -eq 'vazia') { return "${Rel}:$ln — $what (a exceção 'sem-testid:' está sem motivo)" }
        return "${Rel}:$ln — $what" }
    $inComment = { param($ix) $ls = $Text.LastIndexOf("`n", [Math]::Max(0, $ix - 1)) + 1; $pre = $Text.Substring($ls, $ix - $ls); return ($pre -match '//' -or $pre.TrimStart().StartsWith('*') -or $pre -match '^\s*import\s') }
    if ($Rel -match '\.kt$') {
        $wre = '(?<![\w.])(Button|IconButton|TextButton|OutlinedButton|ElevatedButton|FilledTonalButton|FilledIconButton|OutlinedIconButton|IconToggleButton|FloatingActionButton|SmallFloatingActionButton|LargeFloatingActionButton|ExtendedFloatingActionButton|TextField|OutlinedTextField|BasicTextField|Checkbox|TriStateCheckbox|Switch|RadioButton|Slider|RangeSlider|FilterChip|AssistChip|InputChip|SuggestionChip|NavigationBarItem|NavigationRailItem|Tab|DropdownMenuItem)\s*\('
        foreach ($m in [regex]::Matches($Text, $wre)) {
            if (& $inComment $m.Index) { continue }
            $ls = $Text.LastIndexOf("`n", [Math]::Max(0, $m.Index - 1)) + 1
            if ($Text.Substring($ls, $m.Index - $ls) -match '\bfun\s') { continue }   # declaração, não chamada
            $open = $m.Index + $m.Length - 1; $end = Get-BalancedEnd $Text $open
            $span = if ($end -gt $open) { $Text.Substring($open, $end - $open + 1) } else { $Text.Substring($open) }
            if ($span -notmatch 'testTag\s*\(') { $f = & $flag $m.Index "$($m.Groups[1].Value)( sem testTag( no modifier"; if ($f) { $out += $f } }
        }
        foreach ($m in [regex]::Matches($Text, '\.(clickable|toggleable|selectable|combinedClickable)\b')) {
            if (& $inComment $m.Index) { continue }
            # A chamada que recebe a cadeia: o primeiro '(' sem par para trás; '{' sem par ou o começo = a cadeia solta (linhas com '.').
            $depth = 0; $i = $m.Index - 1; $open = -1
            while ($i -ge 0) {
                $ch = $Text[$i]
                if ($ch -eq [char]')' -or $ch -eq [char]'}') { $depth++ }
                elseif ($ch -eq [char]'(') { if ($depth -eq 0) { $open = $i; break }; $depth-- }
                elseif ($ch -eq [char]'{') { if ($depth -eq 0) { break }; $depth-- }
                $i--
            }
            $span = ''
            if ($open -ge 0) { $end = Get-BalancedEnd $Text $open; $span = if ($end -gt $open) { $Text.Substring($open, $end - $open + 1) } else { $Text.Substring($open) } }
            else {
                $ln = & $lineOf $m.Index; $a = $ln; $b = $ln
                while ($a -gt 1 -and $lines[$a - 1].TrimStart().StartsWith('.')) { $a-- }
                while ($b -lt $lines.Count -and $lines[$b].TrimStart().StartsWith('.')) { $b++ }
                $span = ($lines[($a - 1)..($b - 1)] -join "`n")
            }
            if ($span -notmatch 'testTag\s*\(') { $f = & $flag $m.Index ".$($m.Groups[1].Value) sem testTag( na mesma cadeia de modifier"; if ($f) { $out += $f } }
        }
        if ($Text -match '\bLazy(Column|Row|VerticalGrid|HorizontalGrid|VerticalStaggeredGrid)\b') {
            foreach ($m in [regex]::Matches($Text, '(?<![\w.])(items|itemsIndexed)\s*\(')) {
                if (& $inComment $m.Index) { continue }
                $ls = $Text.LastIndexOf("`n", [Math]::Max(0, $m.Index - 1)) + 1
                if ($Text.Substring($ls, $m.Index - $ls) -match '\bfun\s') { continue }
                $open = $m.Index + $m.Length - 1; $end = Get-BalancedEnd $Text $open; if ($end -lt 0) { continue }
                $j = $end + 1; while ($j -lt $Text.Length -and [char]::IsWhiteSpace($Text[$j])) { $j++ }
                if ($j -lt $Text.Length -and $Text[$j] -eq [char]'{') { $e2 = Get-BalancedEnd $Text $j; if ($e2 -gt $j) { $end = $e2 } }
                if ($Text.Substring($open, $end - $open + 1) -notmatch 'testTag\s*\(') { $f = & $flag $m.Index "$($m.Groups[1].Value)( da lista sem testTag( no item"; if ($f) { $out += $f } }
            }
        }
    } elseif ($Rel -match '\.(html?|tsx|jsx|vue)$') {
        # v3.55.0 (C3): o texto da tag de abertura que começa em $ix (aspas e chaves de binding respeitadas).
        $tagAt = { param($ix, $len)
            $i = $ix + $len; $depth = 0; $qc = $null
            while ($i -lt $Text.Length) {
                $ch = $Text[$i]
                if ($qc) { if ($ch -eq $qc) { $qc = $null } }
                elseif ($ch -eq [char]'"' -or $ch -eq [char]"'" -or $ch -eq [char]'`') { $qc = $ch }
                elseif ($ch -eq [char]'{') { $depth++ }
                elseif ($ch -eq [char]'}') { $depth-- }
                elseif ($ch -eq [char]'>' -and $depth -le 0) { break }
                $i++
            }
            return $Text.Substring($ix, [Math]::Min($Text.Length, $i + 1) - $ix) }
        # O atributo do id aparece na tag: id=, [id]=, [attr.id]=, :id= (vue), data-testid=, [attr.data-testid]=… Para "id", o
        # nome precisa estar sozinho (não "data-id", "hidden", "width"); para os outros (data-testid, testTag) basta o nome.
        $hasAttr = { param($tag)
            if ($Attr -eq 'id') { return ($tag -match '(?<![\w.\-])(?:\[attr\.|\[|:|v-bind:)?id\]?\s*=') }
            return $tag.Contains($Attr) }
        # Controles do Ionic (v3.55.0): cada um pede id; ion-tab-button fica isento (o Ionic gera tab-button-<tab>).
        $ionCtl = 'ion-button|ion-input|ion-textarea|ion-select|ion-checkbox|ion-toggle|ion-radio|ion-segment-button|ion-searchbar|ion-datetime|ion-range|ion-fab-button|ion-menu-button|ion-back-button'
        $flagged = @{}
        foreach ($m in [regex]::Matches($Text, "<(button|input|select|textarea|a|$ionCtl|ion-item)(?=[\s/>])")) {
            $tag = & $tagAt $m.Index $m.Length
            $name = $m.Groups[1].Value
            if ($name -eq 'a' -and $tag -notmatch '\b(href|onClick|routerLink)\b|\(click\)') { continue }
            if ($name -eq 'ion-item' -and $tag -notmatch '\bbutton\b|\(click\)|\bonClick\b|\brouterLink\b') { continue }
            if ($name -eq 'input' -and $tag -match 'type\s*=\s*["'']hidden["'']') { continue }
            if (& $hasAttr $tag) { continue }
            $flagged[$m.Index] = $true
            $f = & $flag $m.Index "<$name sem $Attr"; if ($f) { $out += $f }
        }
        # Item de lista (v3.55.0): ion-item/li/tr repetido por *ngFor ou @for pede id no item (a chave da entidade, nunca o
        # índice). Limite: só esses três elementos; lista de outro elemento (div, card) fica ao QA.
        foreach ($m in [regex]::Matches($Text, '<(ion-item|li|tr)(?=[\s/>])')) {
            if ($flagged.ContainsKey($m.Index)) { continue }
            $tag = & $tagAt $m.Index $m.Length
            $before = $Text.Substring(0, $m.Index)
            $inFor = ($tag -match '\*ngFor\b') -or ($before -match '@for\s*\([^)]*\)\s*\{\s*$')
            if (-not $inFor) { continue }
            if (& $hasAttr $tag) { continue }
            $f = & $flag $m.Index "<$($m.Groups[1].Value) de lista sem $Attr"; if ($f) { $out += $f }
        }
        # Raiz da tela (v3.55.0): template de página do Ionic/Angular (*.page.html) leva id no elemento raiz ou no ion-content.
        # React e Compose não são conferidos por heurística: ficam ao QA.
        if ($Rel -match '\.page\.html$') {
            $clean = [regex]::Replace($Text, '(?s)<!--.*?-->', [System.Text.RegularExpressions.MatchEvaluator]{ param($mm) $mm.Value -replace '[^\r\n]', ' ' })
            $rm = [regex]::Match($clean, '<([a-zA-Z][\w-]*)(?=[\s/>])')
            if ($rm.Success) {
                $okRoot = $false
                # $clean tem o mesmo tamanho de $Text (comentário vira espaço): os índices valem para o $tagAt.
                if (& $hasAttr (& $tagAt $rm.Index $rm.Length)) { $okRoot = $true }
                else {
                    foreach ($cm in [regex]::Matches($clean, '<ion-content(?=[\s/>])')) { if (& $hasAttr (& $tagAt $cm.Index $cm.Length)) { $okRoot = $true; break } }
                }
                if (-not $okRoot) { $f = & $flag $rm.Index "raiz da tela (<$($rm.Groups[1].Value)>) sem $Attr no elemento raiz nem no ion-content"; if ($f) { $out += $f } }
            }
        }
    }
    return @($out | Select-Object -Unique)
}
# A conferência inteira de uma Task: (a) ids dos cenários de tela da Task (sem os que aguardam outra Task) presentes no
# código; (b) controles sem id nos arquivos da Task (**Arquivos tocados:** do plano; sem plano, os mudados no git).
# @{ Applies; Missing = "id — SC (arquivo.scn:linha)"; Untagged = "arquivo:linha — …"; Notes; Files }.
function Get-TestIdFindings([string]$Root, [string]$Task) {
    $res = [pscustomobject]@{ Applies = $false; Missing = @(); Untagged = @(); Notes = @(); Files = 0; Ids = 0 }
    $tp = Join-Path $Root '.team-project'
    $t = $null; $S = $null
    $readme = Join-Path $tp 'README.md'
    if ($Task -notmatch '^[FB]-\d+' -and (Test-Path -LiteralPath $readme)) {
        $n = Get-CurrentSprint (Read-Text $readme)
        if ($n) { $S = Join-Path $tp "sprints/$n"; if (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md')) { try { $t = @(Get-SprintTasks $S | Where-Object { $_.Id -eq $Task }) | Select-Object -First 1 } catch { } } }
    }
    $texts = @{}
    # (a) ids dos cenários
    if ($t -and @($t.Scenarios).Count) {
        $defer = Get-DeferredScenarios $Root
        $scs = @($t.Scenarios | Where-Object { -not $defer.ContainsKey($_) -or $defer[$_] -eq $Task })
        $refs = @(Get-ScnTestIdRefs $Root $scs)
        if ($refs.Count) {
            $res.Applies = $true; $res.Ids = @($refs | ForEach-Object { $_.Id } | Select-Object -Unique).Count
            $srcFiles = @(Get-TestIdSourceFiles $Root)
            $blob = (@($srcFiles | ForEach-Object { $p = Join-Path $Root $_; if (Test-Path -LiteralPath $p -PathType Leaf) { $x = Read-Text $p; $texts[$_] = $x; $x } }) -join "`n")
            $dynPats = @(Get-TestIdDynamicPatterns $Root $blob)
            foreach ($g in @($refs | Group-Object Id)) {
                $isPre = @($g.Group | Where-Object { $_.Prefix }).Count -gt 0
                if (Test-TestIdInSource $blob $g.Name $isPre) { continue }
                $where = @($g.Group | ForEach-Object { "$($_.Scenario) ($($_.File):$($_.Line))" } | Select-Object -Unique) -join ', '
                # v3.57.0 (item 7): id declarado dinâmico — não reprova; fica listado como não conferido estaticamente.
                $dm = Find-TestIdDynamicMatch $dynPats $g.Name
                if ($dm) { $res.Notes += "id dinâmico declarado ($dm), não conferido estaticamente: $($g.Name) — $where"; continue }
                $res.Missing += "$($g.Name)$(if ($isPre) { ' (prefixo)' } else { '' }) — $where"
            }
        }
    }
    # (b) controles sem id nos arquivos da Task
    $files = @()
    $planPath = if ($t -and $t.Plan -and $t.Plan -notmatch '^plan/?$') { Join-Path $S $t.Plan } else { '' }
    if ($planPath -and (Test-Path -LiteralPath $planPath -PathType Leaf)) { $files = @(Get-PlanScope (Read-Text $planPath)) }
    if (-not $files.Count) {
        $ErrorActionPreference = 'Continue'
        $files = @(& git -C $Root status --porcelain -uall 2>$null | ForEach-Object { $s = ([string]$_).Substring([Math]::Min(3, ([string]$_).Length)); if ($s -match ' -> ') { $s = ($s -split ' -> ')[-1] }; $s.Trim('"') })
        if ($files.Count) { $res.Notes += 'arquivos da Task pelo git (sem **Arquivos tocados:** de plano no quadro)' }
    }
    $attr = Get-TestIdAttribute $Root   # v3.55.0 (C2): testIds.attribute → targets.web.testIdAttribute → data-testid
    $altCount = 0; $altChecked = $false
    foreach ($f in @($files | Where-Object { $_ -match '\.(kt|html?|tsx|jsx|vue)$' -and -not (Test-TestIdExcluded $_) } | Select-Object -Unique)) {
        $p = Join-Path $Root $f; if (-not (Test-Path -LiteralPath $p -PathType Leaf)) { continue }
        $res.Applies = $true; $res.Files++
        $x = if ($texts.ContainsKey($f)) { $texts[$f] } else { Read-Text $p }
        $xc = ($x -replace "`r", '')
        $found = @(Find-UntaggedUi ($f -replace '\\', '/') $xc $attr)
        $res.Untagged += $found
        # v3.57.0 (item 7): atributo não declarado (vale o padrão data-testid) e os controles têm "id": o gate reprovava sem dizer.
        if ($found.Count -and $attr -eq 'data-testid') { $altChecked = $true; $altCount += @(Find-UntaggedUi ($f -replace '\\', '/') $xc 'id').Count }
    }
    if ($altChecked -and $res.Untagged.Count -and $altCount -lt $res.Untagged.Count -and -not (Test-TestIdAttributeDeclared $Root)) {
        $res.Notes += "atributo de teste não declarado: o gate assumiu data-testid, mas $($res.Untagged.Count - $altCount) dos $($res.Untagged.Count) controle(s) sem data-testid têm id — se o projeto usa id, o stakeholder declara em guards.json → testIds.attribute: ""id"" (standards/test-ids.md); o dev não troca o atributo por conta própria"
    }
    return $res
}

# Quadro do sprint (v3.51; run.ps1 e kanban.ps1): Histórias e Tasks (marcador, depende de, plano, cenários).
# v3.51.4 (garden item 20): o cabeçalho "ID" vale só para a própria tabela (zera fora dela) e qualquer título "## " que não
# é de História encerra a História — as tabelas de rastreabilidade e de trilha depois da última História viravam Tasks-
# fantasma ("18 Task(s)" num sprint de 9) e repetiam IDs no pedido de planos. "## Habilitadora …" vira grupo próprio,
# Story = 'habilitadora' (antes herdava a História de cima; a R20 continua reprovando Task sem História no close.ps1).
# Task marcada como retirada (~~T-…~~ ou "retirada" na 1ª célula) fica fora.
# v3.52.2 (note.md item 15, C5): a correção pedida pelo portão é Task Q-S<n> (Q-S<n>b…) sob "## Correção do portão —
# sprint <n>", Story = 'correção do portão' — todo parser de ID e de seção do quadro usa $TaskIdRe e Get-BoardGroup.
$script:TaskIdRe = '(?:Q-S\d+[a-z]?|[A-Z]+-\d+[a-z]?)'
$script:GateStory = 'correção do portão'
# Grupo do quadro aberto por um título "## ": a História (H-nnn), 'habilitadora', 'correção do portão'; $null encerra o grupo.
function Get-BoardGroup([string]$Line) {
    $hm = [regex]::Match($Line, '^##\s+Hist[oó]ria\s+(H-[\w]+)'); if ($hm.Success) { return $hm.Groups[1].Value }
    if ($Line -match '^##\s+(?i)habilitadora') { return 'habilitadora' }
    if ($Line -match '^##\s+(?i)corre[çc][ãa]o do port[ãa]o') { return $script:GateStory }
    return $null
}
function Get-SprintTasks([string]$S) {
    $board = Read-Text (Join-Path $S 'sprint-backlog.md')
    $tdMk = [char]::ConvertFromUtf32(0x2B1C); $rdMk = [char]::ConvertFromUtf32(0x1F534)
    $tasks = @(); $story = $null; $header = $null; $seen = @{}
    foreach ($line in ($board -split "`r?`n")) {
        if ($line -match '^##\s') { $story = Get-BoardGroup $line; $header = $null; continue }
        if (-not $line.TrimStart().StartsWith('|')) { $header = $null; continue }
        if (-not $story) { continue }
        $cells = Split-Row $line
        if ((Clean-Cell $cells[0]) -eq 'ID') { $header = @($cells | ForEach-Object { Clean-Cell $_ }); continue }
        if (-not $header -or $line -match '^\s*\|[\s:\-|]+\|\s*$') { continue }
        $idm = [regex]::Match($cells[0], $script:TaskIdRe); if (-not $idm.Success) { continue }
        if ($cells[0] -match '~~' -or $cells[0] -match '(?i)\bretirada\b' -or $seen.ContainsKey($idm.Value)) { continue }
        $seen[$idm.Value] = $true
        $col = { param($n) $i = -1; for ($k = 0; $k -lt $header.Count; $k++) { if ($header[$k] -like "*$n*") { $i = $k; break } }; if ($i -ge 0 -and $i -lt $cells.Count) { [string]$cells[$i] } else { '' } }
        $mk = $null; foreach ($m in @($tdMk, $E.Plan, $E.Build, $E.QA, $E.Done, $rdMk)) { if ($cells[0].Contains($m)) { $mk = $m; break } }
        $planCell = & $col 'Plano'
        $pm = [regex]::Match($planCell, '\]\(([^)]+)\)'); $pp = if ($pm.Success) { $pm.Groups[1].Value } else { ([regex]::Match($planCell, '`([^`]+)`')).Groups[1].Value }
        $deps = @([regex]::Matches((& $col 'Depende'), $script:TaskIdRe) | ForEach-Object { $_.Value })
        $cenCell = & $col 'Cenários'
        $scn = @(Get-ScenarioIds $cenCell -TargetOnly)
        $tst = @(Get-ScenarioIds $cenCell | Where-Object { $scn -notcontains $_ })
        # v3.56.0 (H2, sprint 5 do garden #28, #33, #38, #41, #44, #50, #54): com plano legível, os cenários da Task são os do
        # plano (**Cenários:**, que o plan.ps1 confere — regra 23); o backlog vale só antes de haver plano. O cartão, o start e
        # o next mandavam rodar o accept com a lista antiga do backlog depois que o GAP tirou um cenário do plano.
        $bScn = $scn; $bTst = $tst; $from = 'backlog'; $waiver = ''
        if ($pp -and $pp -notmatch '^plan/?$') {
            $pf = Join-Path $S $pp
            if (Test-Path -LiteralPath $pf -PathType Leaf) {
                $ps = Get-PlanScenarios (Read-Text $pf)
                if ($ps) { $scn = @($ps.Target); $tst = @($ps.Test); $from = 'plano'; if ($ps.Waived) { $waiver = [string]$ps.Reason } }
            }
        }
        $div = ($from -eq 'plano') -and ((@($bScn | Sort-Object) -join ',') -ne (@($scn | Sort-Object) -join ',') -or (@($bTst | Sort-Object) -join ',') -ne (@($tst | Sort-Object) -join ','))
        $tasks += [pscustomobject]@{ Id = $idm.Value; Title = (Clean-Cell (& $col 'Task')); Story = $story; Mark = $mk; Deps = $deps; Plan = $pp; Scenarios = $scn; TestScenarios = $tst; ScenariosFrom = $from; BacklogScenarios = @($bScn + $bTst); ScenariosDiverge = [bool]$div; AcceptWaiver = $waiver }
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

# Mutações do plano (v3.46): "- M<k> · teste `<arquivo de teste>` · `<arquivo de produção>` · `<trecho exato>` → `<trecho mutante>`".
# v3.51.2: todos os blocos **Mutações:** do arquivo — o mini-plano do fix tem um por F-ID.
# v3.52.2 (note.md item 7): um leitor só, no lib.ps1, para o plan.ps1, o verify.ps1 e o close.ps1. O bloco vai até o próximo
# rótulo "**…:**" no começo da linha ou título "#"; linha em branco no meio NÃO encerra — o plano passava com 4 mutações
# (o plan.ps1 contava o arquivo todo) e a 4ª, depois de uma linha em branco, nunca rodava no verify.
function Get-Mutations([string]$PlanText) {
    $list = @(); $in = $false
    foreach ($line in ($PlanText -split "`r?`n")) {
        if ($line -match '^\*\*Muta[çc][õo]es:\*\*') { $in = $true; continue }
        if (-not $in) { continue }
        if ($line -match '^\s*#' -or $line -match '^\*\*[^*]+:\*\*') { $in = $false; continue }
        # v3.54 (mutação escrita pelo dev): "- M<k> · teste `<t>` · `<produção>` · regra: <o que a mutação quebra>" — o plano
        # diz o QUE quebrar; o trecho exato o dev escreve sobre o código real, no relatório de entrega (Get-TaskMutations).
        # Vem antes da forma literal: a regra pode citar código entre crases.
        $r = [regex]::Match($line, '^\s*-\s*(M\d+)\b[^`]*`([^`]+)`[^`]*`([^`]+)`\s*·\s*regra:\s*(.*)$')
        if ($r.Success) { $list += @{ Id = $r.Groups[1].Value; Test = $r.Groups[2].Value.Trim(); File = $r.Groups[3].Value.Trim(); Find = $null; Replace = $null; Rule = $r.Groups[4].Value.Trim(); Source = 'plano'; Problem = '' }; continue }
        $m = [regex]::Match($line, '^\s*-\s*(M\d+)\b.*?`([^`]+)`.*?`([^`]+)`.*?`([^`]*)`\s*→\s*`([^`]*)`')
        if ($m.Success) { $list += @{ Id = $m.Groups[1].Value; Test = $m.Groups[2].Value.Trim(); File = $m.Groups[3].Value.Trim(); Find = $m.Groups[4].Value; Replace = $m.Groups[5].Value; Rule = ''; Source = 'plano'; Problem = '' } }
    }
    return $list
}

# Relatório de entrega da Task (v3.54): sprint → sprints/<n>/delivery/<T-ID>.md; trilha fix → fixes/B-<nnn>/delivery.md,
# só a seção "## F-<nnn>" da Correção. '' sem o arquivo. Deduz pelo caminho do plano (relativo à raiz ou absoluto).
function Get-DeliveryText([string]$Root, [string]$PlanPath, [string]$Task) {
    $pp = $PlanPath -replace '\\', '/'
    $sm = [regex]::Match($pp, '(?:^|/)\.team-project/sprints/(\d+)/'); $fm = [regex]::Match($pp, '(?:^|/)\.team-project/fixes/(B-\d+)/')
    $dp = if ($sm.Success) { Join-Path $Root ".team-project/sprints/$($sm.Groups[1].Value)/delivery/$Task.md" } elseif ($fm.Success) { Join-Path $Root ".team-project/fixes/$($fm.Groups[1].Value)/delivery.md" } else { $null }
    if (-not $dp -or -not (Test-Path -LiteralPath $dp)) { return '' }
    $t = Read-Text $dp
    if ($fm.Success -and $Task -match '^F-\d+') { $s = [regex]::Match($t, '(?ms)^##\s+' + [regex]::Escape($Task) + '\b.*?(?=^##\s+F-\d|\z)'); return $(if ($s.Success) { $s.Value } else { '' }) }
    return $t
}
# Mutações da Task (v3.54): as do plano; a declarada pela regra recebe o trecho e o mutante que o dev escreveu no bloco
# **Mutações:** do relatório (a última linha com o mesmo M<k> vale — o relatório cresce por seção). Sem a linha do dev, ou
# com outro teste/arquivo, a mutação fica com Problem (o verify a marca inconclusiva e o close não fecha).
function Get-TaskMutations([string]$Root, [string]$PlanPath, [string]$PlanText, [string]$Task) {
    $pm = @(Get-Mutations $PlanText)
    if (-not @($pm | Where-Object { $null -eq $_.Find }).Count) { return $pm }
    $dev = @(Get-Mutations (Get-DeliveryText $Root $PlanPath $Task) | Where-Object { $null -ne $_.Find })
    $norm = { param($p) ($p -replace '\\', '/') -replace '^\./', '' }
    return @($pm | ForEach-Object {
        if ($null -ne $_.Find) { return $_ }
        $id = $_.Id; $d = @($dev | Where-Object { $_.Id -eq $id }) | Select-Object -Last 1
        $o = @{ Id = $_.Id; Test = $_.Test; File = $_.File; Find = ''; Replace = ''; Rule = $_.Rule; Source = 'dev'; Problem = '' }
        if (-not $d) { $o.Problem = "declarada pela regra ($($_.Rule)) e sem o trecho do dev — o dev escreve '- $id · teste ``…`` · ``…`` · ``<trecho>`` → ``<mutante>``' no bloco **Mutações:** do relatório de entrega" }
        elseif ((& $norm $d.Test) -ne (& $norm $_.Test) -or (& $norm $d.File) -ne (& $norm $_.File)) { $o.Problem = "a linha do dev usa outro teste ou arquivo que o plano ($($_.Test) · $($_.File))" }
        else { $o.Find = $d.Find; $o.Replace = $d.Replace }
        $o })
}
# Ajustes na margem do dev (v3.54): "### Ajustes na margem" do relatório, uma linha por ajuste —
#   "- A<k> · teste · `<arquivo de teste>` · <o que mudou>"  (defeito mecânico do próprio teste: espera, referência de medida)
#   "- A<k> · css · `<arquivo>` · <o que mudou> · regra: <onde a regra do projeto já diz o valor>"
#   "- A<k> · stub · `<teste que já existia>` · <a dependência nova que o stub ganhou>" (v3.54.1: teste fora da lista que
#   monta um arquivo do plano — Test-MountingSpec, hooks/common.ps1)
#   "- A<k> · fixture · `<arquivo de teste>` · <o que mudou> · regra: <standards/… § do padrão de ids | caminho de dump real .xml>"
#   (v3.55.0: a fixture do teste passa a seguir o que a regra ou o dump dizem; o "Deve falhar se…" do plano não muda)
# Devolve @{ Id; Kind; File; What; Rule; Bad } por linha; Bad = a linha fora do formato.
function Get-MarginAdjustments([string]$DeliveryText) {
    $out = @()
    foreach ($sec in [regex]::Matches($DeliveryText, '(?ms)^###\s+Ajustes na margem[^\r\n]*\r?\n(.*?)(?=^#{2,3}\s|\z)')) {
        foreach ($l in ($sec.Groups[1].Value -split "`r?`n")) {
            if ($l -notmatch '^\s*-\s*\S') { continue }
            if ($l -match '^\s*-\s*(nenhum|nada)\b') { continue }
            $m = [regex]::Match($l, '^\s*-\s*(A\d+)\s*·\s*(teste|css|stub|fixture)\s*·\s*`([^`]+)`\s*·\s*(.+?)(?:\s*·\s*regra:\s*(.*))?$')
            if (-not $m.Success) {
                # v3.55.0 (A1): leitura tolerante (sem crases, espaços variados) — devolve o item com Bad E os campos lidos, para o
                # close seguir com as travas daquele ajuste e juntar tudo numa única saída.
                $t = [regex]::Match($l, '^\s*-\s*(A\d+)\s*·\s*(teste|css|stub|fixture)\s*·\s*`?([^`·\s][^`·]*?)`?\s*·\s*(.+?)(?:\s*·\s*regra:\s*(.*))?$')
                if ($t.Success) { $out += @{ Id = $t.Groups[1].Value; Kind = $t.Groups[2].Value; File = (($t.Groups[3].Value.Trim() -replace '\\', '/') -replace '^\./', ''); What = $t.Groups[4].Value.Trim(); Rule = $t.Groups[5].Value.Trim(); Bad = $l.Trim() } }
                else { $out += @{ Id = ''; Kind = ''; File = ''; What = ''; Rule = ''; Bad = $l.Trim() } }
                continue
            }
            $out += @{ Id = $m.Groups[1].Value; Kind = $m.Groups[2].Value; File = (($m.Groups[3].Value -replace '\\', '/') -replace '^\./', ''); What = $m.Groups[4].Value.Trim(); Rule = $m.Groups[5].Value.Trim(); Bad = '' }
        }
    }
    return $out
}

# ---------- Comandos da Task (v3.55.0, F1 — regra 32) ----------
# O plano declara em "### Comandos da Task" os comandos de build, teste, lint ou leitura que a construção e a verificação vão
# rodar, além dos da lista base da G14 — "- `<comando>` · <para quê>" ou "- nenhum além da lista base". O plan.ps1 e o
# run.ps1 conferem cada comando contra a MESMA lista da G14 (hooks/common.ps1: $script:runBase + guards.json → runCommands +
# o reparo declarado, e o mesmo Test-CommandPrefix). Quem chama carrega o common.ps1.
function Get-PlanCommandList([string]$PlanText) {
    $m = [regex]::Match($PlanText, '(?ms)^###\s+Comandos da Task[^\r\n]*\r?\n(.*?)(?=^#{1,3}\s|\z)')
    if (-not $m.Success) { return $null }
    $cmds = @(); $none = $false; $lines = 0
    foreach ($l in ($m.Groups[1].Value -split "`r?`n")) {
        if ($l -notmatch '^\s*-\s*\S') { continue }
        $lines++
        if ($l -match '^\s*-\s*nenhum\s+al[ée]m\s+da\s+lista\s+base') { $none = $true; continue }
        $c = [regex]::Match($l, '`([^`]+)`'); if ($c.Success) { $cmds += $c.Groups[1].Value.Trim() }
    }
    return [pscustomobject]@{ Commands = $cmds; None = $none; Lines = $lines }
}
# Trechos do comando como a G14 os parte (; && || | e quebra de linha).
function Split-CommandSegments([string]$Cmd) {
    return @($Cmd -split ';|&&|\|\||\||\r?\n' | ForEach-Object { ($_.Trim() -replace '\s+', ' ') } | Where-Object { $_ })
}
# Instalação, rede, push e destrutivo não entram no run (G14): '' quando o trecho não é nenhum deles.
function Get-ForbiddenCommandReason([string]$Seg) {
    $low = (($Seg.ToLowerInvariant() -replace '^(npm|npx)\s+--prefix(?:\s+|=)\S+\s+', '$1 ') -replace '^git\s+(-c\s+\S+\s+)+', 'git ')
    if ($low -match '^(npm|pnpm|yarn)\s+(install|i|ci|add)\b|^pip3?\s+install\b|^dotnet\s+(add|tool\s+install)\b|^(choco|winget|scoop|apt|apt-get|brew)\b|^gem\s+install\b|^install-(module|package)\b') { return 'instalação' }
    if ($low -match '^(curl|wget|iwr|irm|invoke-webrequest|invoke-restmethod|ssh|scp|sftp|ftp|telnet)\b') { return 'rede' }
    if ($low -match '^git\s+push\b') { return 'push' }
    if ($low -match '^rm\s+-\w*r|^remove-item\b.*-recurse|^git\s+(reset\s+--hard|clean\b|checkout\s+--)|^(del|rd|rmdir)\s+/s|^docker\s+(system\s+prune|volume\s+(rm|prune))') { return 'destrutivo' }
    return ''
}
# O prefixo que se grava em runCommands para um trecho: o comando e até duas palavras seguintes que parecem subcomando
# (docker compose run · npm run test:alvo · aapt dump badging), parando em opção, caminho ou arquivo.
function Get-CommandPrefixSuggestion([string]$Seg) {
    $tok = @($Seg.Trim() -split '\s+'); $out = @($tok[0])
    foreach ($t in @($tok | Select-Object -Skip 1)) {
        if ($out.Count -ge 3 -or $t -notmatch '^[A-Za-z][\w:]*$') { break }
        $out += $t
    }
    return ($out -join ' ')
}
# @{ Has; None; Missing (prefixos a liberar); Forbidden ("comando (motivo)") } — Missing e Forbidden vazios = o plano cabe na G14.
function Get-PlanCommandGaps([string]$Root, [string]$PlanText) {
    $r = [pscustomobject]@{ Has = $false; None = $false; Missing = @(); Forbidden = @() }
    $list = Get-PlanCommandList $PlanText
    if ($null -eq $list) { return $r }
    $r.Has = $true; $r.None = $list.None
    $allowed = @($script:runBase) + @((Get-GuardConfig $Root).runCommands) + @(Get-RepairCommands $Root)
    foreach ($c in $list.Commands) {
        foreach ($seg in (Split-CommandSegments $c)) {
            $why = Get-ForbiddenCommandReason $seg
            if ($why) { $r.Forbidden += "$c ($why)"; break }
            $low = (($seg.ToLowerInvariant() -replace '^(npm|npx)\s+--prefix(?:\s+|=)\S+\s+', '$1 ') -replace '^git\s+(-C\s+\S+\s+|--no-pager\s+)+', 'git ')
            $hit = @($allowed | Where-Object { Test-CommandPrefix $low $low $_ }).Count
            if (-not $hit) { $sg = Get-CommandPrefixSuggestion $seg; if ($r.Missing -notcontains $sg) { $r.Missing += $sg } }
        }
    }
    return $r
}

# Escopo do plano: **Arquivos tocados:**; no mini-plano do fix (v3.51.2), os caminhos de "- produção:" e "- teste:" de
# todas as F-IDs — a mesma regra da G9 na trilha fix. v3.52.2 (note.md item 10): no lib.ps1, para o commit da Task.
function Get-PlanScope([string]$PlanText) {
    $norm = { param($p) ($p.Trim() -replace '\\', '/') -replace '^\./', '' }
    $m = [regex]::Match($PlanText, '(?s)\*\*Arquivos tocados:\*\*(.*?)(?:\r?\n[ \t]*\r?\n|\r?\n#|\z)')
    if ($m.Success) { return @([regex]::Matches($m.Groups[1].Value, '`([^`]+)`') | ForEach-Object { & $norm $_.Groups[1].Value }) }
    $out = @()
    foreach ($l in [regex]::Matches($PlanText, '(?m)^\s*-\s*(?:produ[çc][ãa]o|teste):(.*)$')) { $out += @([regex]::Matches($l.Groups[1].Value, '`([^`]+)`') | ForEach-Object { & $norm $_.Groups[1].Value }) }
    return $out
}

# Ficha da Task (v3.53, note.md item 8): a seção "### Ficha <ID>" de .team-project/architect/breakdown/S<n>.md, que o
# Arquiteto escreve na quebra da Planning, mais a "### Decisões comuns" da mesma História (o "## " que contém a ficha). O
# run.ps1 next grava o recorte para o Arquiteto do plano abrir só ele; o plan.ps1 confere o plano contra ela. Read são os
# caminhos de **Código a ler:** (o primeiro entre crases de cada linha, sem ":linha"), Sources os de **Fontes:** e Names os
# de **Nomes comuns:**. $null sem o arquivo ou sem a ficha — a História segue no preparo por História (regra 25).
function Get-Ficha([string]$Root, [string]$Sprint, [string]$Id) {
    $bp = Join-Path $Root ".team-project/architect/breakdown/S$Sprint.md"
    if (-not (Test-Path -LiteralPath $bp)) { return $null }
    $txt = Read-Text $bp
    foreach ($h in [regex]::Matches($txt, '(?ms)^##\s[^\r\n]*\r?\n.*?(?=^##\s|\z)')) {
        $fm = [regex]::Match($h.Value, '(?ms)^###\s+Ficha\s+' + [regex]::Escape($Id) + '(?![\w-])[^\r\n]*\r?\n.*?(?=^#{1,3}\s|\z)')
        if (-not $fm.Success) { continue }
        $dm = [regex]::Match($h.Value, '(?ms)^###\s+Decis[õo]es comuns[^\r\n]*\r?\n.*?(?=^#{1,3}\s|\z)')
        $label = { param($l) $m = [regex]::Match($fm.Value, '(?s)\*\*' + $l + ':\*\*(.*?)(?:\r?\n[ \t]*\r?\n|\r?\n#|\r?\n\*\*[^*\r\n]+:\*\*|\z)'); if ($m.Success) { $m.Groups[1].Value } else { '' } }
        $norm = { param($p) (($p.Trim() -replace '\\', '/') -replace '^\./', '') -replace '#.*$', '' -replace ':\d+(-\d+)?$', '' }
        $read = @((& $label 'C[óo]digo a ler') -split "`r?`n" | ForEach-Object { [regex]::Match($_, '`([^`]+)`') } | Where-Object { $_.Success } | ForEach-Object { & $norm $_.Groups[1].Value })
        # v3.53.2: em **Fontes:** só é caminho o termo com pasta ou extensão — nome de classe entre crases não é arquivo.
        $src = @([regex]::Matches((& $label 'Fontes'), '`([^`]+)`') | ForEach-Object { & $norm $_.Groups[1].Value } | Where-Object { $_ -match '/|\.[A-Za-z0-9]{1,6}$' })
        $names = @([regex]::Matches((& $label 'Nomes comuns'), '`([^`]+)`') | ForEach-Object { $_.Groups[1].Value })
        # v3.53.2: **Arquivos previstos:** <n> — quantos arquivos (produção e teste) a Task deve mudar; $null sem a linha.
        $pm = [regex]::Match($fm.Value, '\*\*Arquivos previstos:\*\*\s*(\d+)')
        $planned = if ($pm.Success) { [int]$pm.Groups[1].Value } else { $null }
        return [pscustomobject]@{ Path = $bp; Common = $(if ($dm.Success) { $dm.Value.TrimEnd() } else { '' }); Body = $fm.Value.TrimEnd(); Read = $read; Sources = $src; Names = $names; Planned = $planned }
    }
    return $null
}
# Caminho citado na ficha: standards/ e ${CLAUDE_PLUGIN_ROOT}/ resolvem no plugin; o resto, na raiz do projeto.
function Resolve-FichaPath([string]$Root, [string]$Rel) {
    $plug = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
    if ($Rel -match '^\$\{CLAUDE_PLUGIN_ROOT\}/(.+)$') { return (Join-Path $plug $Matches[1]) }
    if ($Rel -match '^standards/') { return (Join-Path $plug $Rel) }
    return (Join-Path $Root $Rel)
}
# Caminhos da ficha que não existem (Código a ler + Fontes). v3.53.2: o run.ps1 next confere antes de disparar o Arquiteto.
function Get-FichaMissing([string]$Root, $Ficha) {
    return @(@($Ficha.Read) + @($Ficha.Sources) | Where-Object { $_ -and -not (Test-Path -LiteralPath (Resolve-FichaPath $Root $_)) })
}
# Teto de arquivos previstos por Task com ficha (v3.53.2, plugin-report prévio do sprint 5 do garden): acima dele, o custo
# do plano cresce mais rápido que a Task (6 arquivos ≈ US$ 2,5; 9 ≈ US$ 4,7; 12 ≈ US$ 8,7) — a Task se divide antes do Opus.
$script:FichaMaxFiles = 6
# Teto do plano (v3.53.6, sprint 5 do garden, item 1): acima dele o plan.ps1 reprova (regra 22) e o run.ps1 next divide a
# Task com os blocos do plano como base — nunca se corta o plano (v3.53.2: cortar custou metade do plano da T-042). Em KB
# arredondados a 0,1, como o plan.ps1 imprime.
$script:PlanMaxKb = 30
function Get-PlanKb([string]$Text) { return [Math]::Round(([System.Text.Encoding]::UTF8.GetByteCount($Text)) / 1024, 1) }

# Prova no alvo pendente (v3.53.6, sprint 5 do garden, item 9): a Task cujo accept parou por ambiente e cujo reparo falhou vai
# a 🔴 com esta etiqueta na linha de "Bloqueios e riscos abertos" (mark.ps1 -Reason) — antes ela fechava ✅ com "nenhum
# aplicável — emulador fora do ar" na coluna Cenários, sem prova. O run.ps1 next lê as linhas e, com o alvo de volta, reabre.
$script:TargetPendingTag = 'prova no alvo pendente'
# IDs citados nas linhas de Bloqueios (kanban.md, burndown.md ou sprint-backlog.md) que levam a etiqueta; quem chama cruza
# com o marcador 🔴 do quadro (linha antiga, de Task já reaberta, o mark.ps1 troca por "prova no alvo retomada").
function Get-TargetPendingIds([string]$SprintDir) {
    $ids = @()
    foreach ($f in @('kanban.md', 'burndown.md', 'sprint-backlog.md')) {
        $fp = Join-Path $SprintDir $f; if (-not (Test-Path -LiteralPath $fp)) { continue }
        $sec = Get-Section (Read-Text $fp) '^#{2,3}\s+Bloqueios e riscos abertos'; if (-not $sec) { continue }
        foreach ($l in ($sec -split "`r?`n")) {
            if (-not $l.TrimStart().StartsWith('|') -or $l.IndexOf($script:TargetPendingTag, [StringComparison]::OrdinalIgnoreCase) -lt 0) { continue }
            $c = @(Split-Row $l)
            foreach ($m in [regex]::Matches((@($c | Select-Object -First 2) -join ' '), $script:TaskIdRe)) { $ids += $m.Value }
        }
    }
    return @($ids | Select-Object -Unique)
}
# v3.54.2 (carta do sprint 5 do garden, item 4): linhas de "Bloqueios e riscos abertos" por Task, na ordem do arquivo —
# @{ <ID> = @(natureza, …) }. O kanban.ps1 mostra a última ao lado da Task na coluna 🔴; o run.ps1 next conta as "prova no
# alvo retomada" (a Task já foi reaberta uma vez pelo alvo de volta) para não reabrir de novo em vaivém.
function Get-BlockLines([string]$SprintDir) {
    $out = @{}
    foreach ($f in @('kanban.md', 'burndown.md', 'sprint-backlog.md')) {
        $fp = Join-Path $SprintDir $f; if (-not (Test-Path -LiteralPath $fp)) { continue }
        $sec = Get-Section (Read-Text $fp) '^#{2,3}\s+Bloqueios e riscos abertos'; if (-not $sec) { continue }
        foreach ($t in @(Get-Tables $sec)) {
            $ci = Find-Col $t 'Task'; $ni = Find-Col $t 'Natureza'
            foreach ($r in $t.Rows) {
                $key = if ($ci -ge 0) { Get-Cell $r $ci } else { (@($r | Select-Object -First 2) -join ' ') }
                $why = Clean-Cell $(if ($ni -ge 0) { Get-Cell $r $ni } else { (@($r) -join ' ') })
                foreach ($m in [regex]::Matches($key, $script:TaskIdRe)) { if (-not $out.ContainsKey($m.Value)) { $out[$m.Value] = @() }; $out[$m.Value] += $why }
            }
        }
    }
    return $out
}
function Get-TargetRetakeCount($BlockLines, [string]$Id) {
    if (-not $BlockLines.ContainsKey($Id)) { return 0 }
    return @($BlockLines[$Id] | Where-Object { $_ -match '(?i)prova no alvo retomada' }).Count
}

# Resumo do plano de uma dependência (v3.53.2): o cabeçalho (até o primeiro "## ") e os títulos dos passos/blocos — o
# Arquiteto da Task seguinte lê arquivos, nomes e convenções sem abrir o plano inteiro (no garden, 3 planos = ~60 mil
# caracteres levados por todas as chamadas).
function Get-PlanSummary([string]$PlanPath) {
    if (-not (Test-Path -LiteralPath $PlanPath)) { return '' }
    $t = Read-Text $PlanPath
    $h = [regex]::Match($t, '(?m)^## ')
    $head = if ($h.Success) { $t.Substring(0, $h.Index) } else { $t }
    $s4 = [regex]::Match($t, '(?ms)^## 4\b[^\r\n]*\r?\n(.*?)(?=^## |\z)')
    $scope = if ($s4.Success) { $s4.Groups[1].Value } else { $t }
    $steps = @([regex]::Matches($scope, '(?m)^### [^\r\n]+') | ForEach-Object { '- ' + $_.Value.Substring(4).Trim() })
    $out = $head.TrimEnd()
    if ($steps.Count) { $out += "`n`n**Passos/blocos:**`n" + ($steps -join "`n") }
    return $out
}

# Decisões do sprint (v3.53.7, encadeamento do sprint 5 do garden: a mesma decisão de 🔺 GAP — emulador fora, teste instável,
# APK antes do accept — foi colada em 8 planos, e cada instância nova do dev relia o acúmulo). Ficha comum do sprint:
# .team-project/architect/decisions/S<n>.md, uma "## D-<k> — <título>" por decisão, com "**Vale para:** todas | T-…, T-…"
# e a regra em poucas linhas. O plano cita em **Decisões do sprint:** D-<k>; o cartão do dev e o recorte da ficha a trazem.
$script:DecisionIdRe = 'D-\d+'
function Get-SprintDecisionsPath([string]$Root, [string]$Sprint) { return (Join-Path $Root ".team-project/architect/decisions/S$Sprint.md") }
function Get-SprintDecisions([string]$Root, [string]$Sprint) {
    $fp = Get-SprintDecisionsPath $Root $Sprint
    if (-not (Test-Path -LiteralPath $fp)) { return @() }
    $out = @()
    foreach ($m in [regex]::Matches((Read-Text $fp), '(?ms)^##\s+(' + $script:DecisionIdRe + ')\s*[—–-]\s*([^\r\n]*)\r?\n(.*?)(?=^##\s|\z)')) {
        $body = $m.Groups[3].Value
        $vm = [regex]::Match($body, '(?m)^\*\*Vale para:\*\*\s*([^\r\n]*)$')
        $scope = if ($vm.Success) { ($vm.Groups[1].Value -split '\s+·\s+')[0] } else { '' }
        $all = $scope -match '(?i)^\s*todas'
        $ids = @([regex]::Matches($scope, $script:TaskIdRe) | ForEach-Object { $_.Value })
        $rule = (@($body -split "`r?`n" | Where-Object { $_.Trim() -and $_ -notmatch $script:EntryMetaRe } | ForEach-Object { $_.Trim() }) -join ' ').Trim()
        $out += [pscustomobject]@{ Id = $m.Groups[1].Value; Title = $m.Groups[2].Value.Trim(); All = $all; Ids = $ids; Rule = $rule; Body = $body; Class = (Get-LessonClass $body) }
    }
    return $out
}
# Recorte das decisões do sprint para o Arquiteto do plano (ficha da Task, pacote externo): título, a quem vale e a regra
# curta — ele cita em **Decisões do sprint:** em vez de decidir de novo ou copiar. '' sem decisões.
function Get-DecisionsDigest([string]$Root, [string]$Sprint) {
    $ds = @(Get-SprintDecisions $Root $Sprint)
    if (-not $ds.Count) { return '' }
    $ls = @($ds | ForEach-Object { $r = if ($_.Rule.Length -gt 200) { $_.Rule.Substring(0, 200).TrimEnd() + '…' } else { $_.Rule }; "- $($_.Id) — $($_.Title) · vale para $(if ($_.All) { 'todas' } elseif ($_.Ids.Count) { $_.Ids -join ', ' } else { '?' })$(if ($r) { ": $r" })" })
    return "`n## Decisões do sprint — ``architect/decisions/S$Sprint.md```n`n> Já decididas: a que valer para esta Task vai em **Decisões do sprint:** D-<k> no cabeçalho do plano — cite, não copie o texto (regra 29).`n`n" + ($ls -join "`n") + "`n"
}
# IDs citados na linha **Decisões do sprint:** do plano.
# v3.56.0 (B): a linha passa a **Decisões:** D-<k>, K-<n> (o rótulo antigo continua aceito); aqui só as D.
function Get-PlanDecisionLine([string]$PlanText) {
    $m = [regex]::Match([string]$PlanText, '(?m)^\*\*Decis[õo]es(?: do sprint)?:\*\*\s*([^\r\n]*)$')
    if ($m.Success) { return $m.Groups[1].Value }
    return ''
}
function Get-PlanDecisionRefs([string]$PlanText) {
    return @([regex]::Matches((Get-PlanDecisionLine $PlanText), $script:DecisionIdRe) | ForEach-Object { $_.Value } | Select-Object -Unique)
}
# v3.56.0 (B): as K do conhecimento do projeto citadas na mesma linha.
function Get-PlanKnowledgeRefs([string]$PlanText) {
    return @([regex]::Matches((Get-PlanDecisionLine $PlanText), $script:KnowledgeIdRe) | ForEach-Object { $_.Value } | Select-Object -Unique)
}

# ---------- v3.56.0 (A) · a lição de cada GAP: origem e destino ----------
# Classificação dos 117 GAPs do garden (sprints 1–5): 40 eram do plugin, 40 do projeto, 7 da stack e 30 só apareciam
# executando — e o plugin não separava os destinos. A decisão de GAP (no plano e em cada ## D-<k>) declara:
#   **Origem:** previsão | conhecimento | requisito | ambiente | processo
#   **Lição:** projeto | stack:<nome> | plugin | nenhuma
# A entrada é "classificada" quando tem a linha **Lição:** (a linha **Origem:** no começo da linha; o "· **Origem:** 🔺 GAP da
# T-…" antigo, no meio da linha do Vale para, não conta). Sem **Lição:**, é "sem classificação".
$script:GapOrigins = @('previsão', 'conhecimento', 'requisito', 'ambiente', 'processo')
$script:LessonRe = '^(projeto|plugin|nenhuma|stack:[a-z0-9][a-z0-9.-]*)$'
function Get-LessonClass([string]$Text) {
    $o = [regex]::Match([string]$Text, '(?m)^\*\*Origem:\*\*\s*([^\s·|,;]+)')
    $l = [regex]::Match([string]$Text, '(?m)^\*\*Li[çc][ãa]o:\*\*\s*([^\s·|,;]+)')
    $ov = if ($o.Success) { ($o.Groups[1].Value.ToLowerInvariant() -replace '^previsao$', 'previsão') } else { '' }
    $lv = if ($l.Success) { $l.Groups[1].Value.ToLowerInvariant() } else { '' }
    $iss = @()
    if ($l.Success) {
        if (-not $o.Success) { $iss += 'sem a linha **Origem:**' }
        elseif ($script:GapOrigins -notcontains $ov) { $iss += "**Origem:** '$ov' fora da lista (previsão | conhecimento | requisito | ambiente | processo)" }
        if ($lv -notmatch $script:LessonRe) { $iss += "**Lição:** '$lv' fora da lista (projeto | stack:<nome> | plugin | nenhuma)" }
    }
    return [pscustomobject]@{ Classified = $l.Success; Origin = $ov; Lesson = $lv; Stack = $(if ($lv -like 'stack:*') { $lv.Substring(6) } else { '' }); Issues = $iss }
}
# Desde qual sprint a classificação é obrigatória: "**Classificação desde:** S<n>" no architect/knowledge.md (o /team update
# grava o sprint seguinte ao aberto; o /team init, S1). 0 = sem o arquivo ou sem a linha — projeto ainda não atualizado: a
# decisão sem classificação só avisa. Sprint anterior ao "desde" (o aberto no update): só avisa, para não reprovar as D
# escritas antes da 3.56.0.
function Get-KnowledgeSince([string]$Root) {
    $kp = Get-KnowledgePath $Root
    if (-not (Test-Path -LiteralPath $kp)) { return 0 }
    $m = [regex]::Match((Read-Text $kp), '(?m)^\*\*Classifica[çc][ãa]o desde:\*\*\s*S?(\d+)')
    if ($m.Success) { return [int]$m.Groups[1].Value }
    return 0
}
function Test-LessonStrict([string]$Root, [string]$Sprint) {
    $since = Get-KnowledgeSince $Root
    if (-not $since -or -not ($Sprint -match '^\d+$')) { return $false }
    return ([int]$Sprint -ge $since)
}
# Decisões de GAP gravadas no plano: o bloco que começa em "**Decisão do GAP …:**" (ou "**Decisão do 🔺 GAP …:**") e vai até a
# linha em branco, o próximo título ou a próxima decisão. Text = o bloco; Head = a primeira linha.
function Get-PlanGapDecisions([string]$PlanText) {
    $out = @(); $cur = $null
    foreach ($line in ([string]$PlanText -split "`r?`n")) {
        if ($line -match '^\*\*Decis[ãa]o do (?:🔺\s*)?GAP\b[^*]*:\*\*') { if ($cur) { $out += $cur }; $cur = [pscustomobject]@{ Head = $line.Trim(); Text = $line }; continue }
        if (-not $cur) { continue }
        if (-not $line.Trim() -or $line -match '^#') { $out += $cur; $cur = $null; continue }
        $cur.Text += "`n" + $line
    }
    if ($cur) { $out += $cur }
    return $out
}

# ---------- v3.56.0 (B) · conhecimento do projeto que atravessa sprints ----------
# .team-project/architect/knowledge.md, uma "## K-<n> — <título>" por entrada, a primeira linha
#   **Vale para:** todas | <glob>, <glob> | T-… · **Origem:** 🔺 GAP <id> da T-… (S<n>) · **Desde:** S<n>
# e a regra em até 5 linhas. **Até:** <correção no plugin> marca o remédio temporário (o /team update o retira). O limiar de
# 160 px reprovou na T-052 do S4 e de novo na T-063 do S5: o que o sprint aprendeu sobre o sistema não chegava ao seguinte.
$script:KnowledgeIdRe = 'K-\d+'
$script:KnowledgeMaxKb = 15
function Get-KnowledgePath([string]$Root) { return (Join-Path $Root '.team-project/architect/knowledge.md') }
# "Vale para" de K, D e armadilha de stack: todas, T-IDs e globs de caminho, separados por vírgula (crases opcionais).
function Read-AppliesTo([string]$Body) {
    $vm = [regex]::Match([string]$Body, '(?m)^\*\*Vale para:\*\*\s*([^\r\n]*)$')
    $scope = if ($vm.Success) { ($vm.Groups[1].Value -split '\s+·\s+')[0] } else { '' }
    $all = $scope -match '(?i)^\s*todas\b'
    $ids = @(); $globs = @()
    foreach ($it in @($scope -split '[,;]' | ForEach-Object { ($_ -replace '`', '').Trim() } | Where-Object { $_ })) {
        if ($it -match '(?i)^todas$') { continue }
        if ($it -match ('^' + $script:TaskIdRe + '$')) { $ids += $it } else { $globs += ($it -replace '\\', '/') }
    }
    return [pscustomobject]@{ All = [bool]$all; Ids = $ids; Globs = $globs }
}
$script:EntryMetaRe = '^\*\*(Vale para|Origem|Li[çc][ãa]o|Desde|At[ée]|Promovida|Sintoma|Fato|Como testar):\*\*'
function Get-ProjectKnowledge([string]$Root) {
    $kp = Get-KnowledgePath $Root
    if (-not (Test-Path -LiteralPath $kp)) { return @() }
    $out = @()
    foreach ($m in [regex]::Matches((Read-Text $kp), '(?ms)^##\s+(' + $script:KnowledgeIdRe + ')\s*[—–-]\s*([^\r\n]*)\r?\n(.*?)(?=^##\s|\z)')) {
        $body = $m.Groups[3].Value; $ap = Read-AppliesTo $body
        $um = [regex]::Match($body, '\*\*At[ée]:\*\*\s*([^\r\n·]*)')
        $sm = [regex]::Match($body, '\*\*Desde:\*\*\s*S?(\d+)')
        $rule = (@($body -split "`r?`n" | Where-Object { $_.Trim() -and $_ -notmatch $script:EntryMetaRe } | ForEach-Object { $_.Trim() }) -join ' ').Trim()
        $out += [pscustomobject]@{ Id = $m.Groups[1].Value; Title = $m.Groups[2].Value.Trim(); All = $ap.All; Ids = $ap.Ids; Globs = $ap.Globs; Rule = $rule; Body = $body
                                   Until = $(if ($um.Success) { $um.Groups[1].Value.Trim() } else { '' }); Since = $(if ($sm.Success) { [int]$sm.Groups[1].Value } else { 0 }) }
    }
    return $out
}
# Os arquivos da Task para o casamento por glob: os de **Código a ler:**/**Fontes:** da ficha (o **Arquivos previstos:** da
# ficha é uma contagem) e os de **Arquivos tocados:** do plano. Relativos à raiz, com '/'.
function Get-TaskFiles([string]$Root, [string]$Sprint, [string]$TaskId, [string]$PlanText = '') {
    $fs = @()
    $fc = Get-Ficha $Root $Sprint $TaskId
    if ($fc) { $fs += @($fc.Read) + @($fc.Sources) }
    if ($PlanText) {
        $am = [regex]::Match($PlanText, '(?s)\*\*Arquivos tocados:\*\*(.*?)(?:\r?\n[ \t]*\r?\n|\r?\n#|\z)')
        if ($am.Success) { $fs += @([regex]::Matches($am.Groups[1].Value, '`([^`]+)`') | ForEach-Object { ($_.Groups[1].Value.Trim() -replace '\\', '/') -replace '^\./', '' }) }
    }
    return @($fs | Where-Object { $_ } | Select-Object -Unique)
}
function Test-EntryApplies($Entry, [string]$TaskId, [string[]]$Files, [string[]]$Refs) {
    if ($Entry.All -or (@($Entry.Ids) -contains $TaskId) -or (@($Refs) -contains $Entry.Id)) { return $true }
    if (-not @($Entry.Globs).Count -or -not @($Files).Count) { return $false }
    foreach ($f in @($Files)) { if (Test-GlobMatch (Normalize-PathText $f) @($Entry.Globs)) { return $true } }
    return $false
}
# As K que valem para a Task (todas, as que a citam, as que o plano cita e as cujo glob casa com um arquivo dela). Uma linha
# cada, até $MaxChars. O cartão do dev traz estas linhas — ninguém abre o knowledge.md inteiro.
function Get-TaskKnowledgeLines([string]$Root, [string]$Sprint, [string]$TaskId, [string]$PlanText = '', [int]$MaxChars = 300) {
    $ks = @(Get-ProjectKnowledge $Root); if (-not $ks.Count) { return @() }
    $files = @(Get-TaskFiles $Root $Sprint $TaskId $PlanText); $refs = @(Get-PlanKnowledgeRefs $PlanText)
    return @($ks | Where-Object { Test-EntryApplies $_ $TaskId $files $refs } | ForEach-Object {
        $r = if ($_.Rule.Length -gt $MaxChars) { $_.Rule.Substring(0, $MaxChars).TrimEnd() + '…' } else { $_.Rule }
        "- $($_.Id) — $($_.Title)$(if ($r) { ": $r" })$(if ($_.Until) { " (até: $($_.Until))" })" })
}
# Recorte para o Arquiteto do plano (ficha, pacote externo): as K com a quem valem e a regra curta. '' sem conhecimento.
function Get-KnowledgeDigest([string]$Root) {
    $ks = @(Get-ProjectKnowledge $Root)
    if (-not $ks.Count) { return '' }
    $ls = @($ks | ForEach-Object {
        $r = if ($_.Rule.Length -gt 200) { $_.Rule.Substring(0, 200).TrimEnd() + '…' } else { $_.Rule }
        $who = @($(if ($_.All) { 'todas' }) + @($_.Ids) + @($_.Globs) | Where-Object { $_ }) -join ', '
        "- $($_.Id) — $($_.Title) · vale para $(if ($who) { $who } else { '?' })$(if ($r) { ": $r" })" })
    return "`n## Conhecimento do projeto — ``architect/knowledge.md```n`n> O que sprints anteriores ensinaram sobre este sistema. A que valer para esta Task vai em **Decisões:** K-<n> no cabeçalho do plano — cite, não copie (regra 29).`n`n" + ($ls -join "`n") + "`n"
}

# ---------- v3.56.0 (C) · armadilhas da stack: plugin + camada local do projeto ----------
# ${CLAUDE_PLUGIN_ROOT}/standards/stacks/<stack>/pitfalls.md (## <STACK>-P<n>, só o /review grava) e
# .team-project/standards/stacks/<stack>/pitfalls.md (## <STACK>-L<n>, Arquiteto e SM no fechamento). A local soma à do
# plugin; local com **Promovida:** <ID do plugin> deixa de ser lida. As stacks: guards.json → "stacks", ou a inferência.
function Get-PluginRoot { return (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path }
# Get-InferredStacks mora no hooks/common.ps1 (v3.56.0): o SessionStart (G13) avisa com a mesma inferência.
# @{ Stacks; Declared } — Declared = a chave "stacks" do guards.json (a inferência só vale sem ela).
function Get-Stacks([string]$Root) {
    $gp = Join-Path $Root '.team-project/guards.json'
    if (Test-Path -LiteralPath $gp) {
        try { $gj = Read-Text $gp | ConvertFrom-Json; if ($gj.PSObject.Properties['stacks'] -and $null -ne $gj.stacks) { return [pscustomobject]@{ Stacks = @($gj.stacks | ForEach-Object { ([string]$_).Trim().ToLowerInvariant() } | Where-Object { $_ }); Declared = $true } } } catch { }
    }
    return [pscustomobject]@{ Stacks = @(Get-InferredStacks $Root); Declared = $false }
}
function Read-PitfallFile([string]$Path, [string]$Layer) {
    if (-not (Test-Path -LiteralPath $Path)) { return @() }
    $out = @()
    foreach ($m in [regex]::Matches((Read-Text $Path), '(?ms)^##\s+([A-Z][A-Z0-9-]*-[PL]\d+)\s*[—–-]\s*([^\r\n]*)\r?\n(.*?)(?=^##\s|\z)')) {
        $body = $m.Groups[3].Value; $ap = Read-AppliesTo $body
        $fact = [regex]::Match($body, '(?m)^\*\*Fato:\*\*\s*([^\r\n]*)'); $test = [regex]::Match($body, '(?m)^\*\*Como testar:\*\*\s*([^\r\n]*)')
        $prom = [regex]::Match($body, '(?m)^\*\*Promovida:\*\*\s*(\S+)')
        $rule = (@($(if ($fact.Success) { $fact.Groups[1].Value.Trim() }), $(if ($test.Success) { 'teste: ' + $test.Groups[1].Value.Trim() })) | Where-Object { $_ }) -join ' · '
        $out += [pscustomobject]@{ Id = $m.Groups[1].Value; Title = $m.Groups[2].Value.Trim(); All = $ap.All; Ids = $ap.Ids; Globs = $ap.Globs; Rule = $rule; Body = $body; Layer = $Layer; Promoted = $(if ($prom.Success) { $prom.Groups[1].Value } else { '' }) }
    }
    return $out
}
# Todas as armadilhas das stacks do projeto: as do plugin e as locais ainda não promovidas.
function Get-StackPitfalls([string]$Root) {
    $plug = Get-PluginRoot; $out = @()
    foreach ($s in @((Get-Stacks $Root).Stacks)) {
        $out += @(Read-PitfallFile (Join-Path $plug "standards/stacks/$s/pitfalls.md") 'plugin')
        $out += @(Read-PitfallFile (Join-Path $Root ".team-project/standards/stacks/$s/pitfalls.md") 'local' | Where-Object { -not $_.Promoted })
    }
    return $out
}
# Recorte para o Arquiteto do plano: as armadilhas que casam com a Task (pela ficha). '' sem nenhuma.
function Get-StackPitfallDigest([string]$Root, [string]$Sprint, [string]$TaskId) {
    $ls = @(Get-StackPitfallLines $Root $Sprint $TaskId '')
    if (-not $ls.Count) { return '' }
    return "`n## Armadilhas da stack que casam com esta Task`n`n> Comportamento do framework já conhecido (plugin e camada local do projeto). O plano evita ou testa — não redescubra.`n`n" + ($ls -join "`n") + "`n"
}
# As que casam com a Task (glob dos arquivos dela, T-ID ou "todas"), até $Max linhas.
function Get-StackPitfallLines([string]$Root, [string]$Sprint, [string]$TaskId, [string]$PlanText = '', [int]$Max = 6, [int]$MaxChars = 240) {
    $ps = @(Get-StackPitfalls $Root); if (-not $ps.Count) { return @() }
    $files = @(Get-TaskFiles $Root $Sprint $TaskId $PlanText)
    return @($ps | Where-Object { Test-EntryApplies $_ $TaskId $files @() } | Select-Object -First $Max | ForEach-Object {
        $r = if ($_.Rule.Length -gt $MaxChars) { $_.Rule.Substring(0, $MaxChars).TrimEnd() + '…' } else { $_.Rule }
        "- $($_.Id) — $($_.Title)$(if ($r) { ": $r" })" })
}
# As decisões que valem para a Task: "todas", as que a citam em **Vale para:** e as que o plano cita. Uma linha cada.
function Get-TaskDecisionLines([string]$Root, [string]$Sprint, [string]$TaskId, [string]$PlanText = '', [int]$MaxChars = 300) {
    $refs = Get-PlanDecisionRefs $PlanText
    return @(Get-SprintDecisions $Root $Sprint | Where-Object { $_.All -or ($_.Ids -contains $TaskId) -or ($refs -contains $_.Id) } | ForEach-Object {
        $r = if ($_.Rule.Length -gt $MaxChars) { $_.Rule.Substring(0, $MaxChars).TrimEnd() + '…' } else { $_.Rule }
        "- $($_.Id) — $($_.Title)$(if ($r) { ": $r" })" })
}

# Medida curta da sessão principal (v3.52.2, note.md item 17): chamadas distintas (message.id, sem <synthetic>) e o contexto
# da última (entrada + cache criado + cache lido). Lê só texto, sem ConvertFrom-Json por linha (o transcript tem dezenas
# de MB e o run.ps1 next roda a cada Task). $null sem o arquivo ou sem chamada.
function Get-SessionGauge([string]$Path) {
    if (-not $Path -or -not (Test-Path -LiteralPath $Path)) { return $null }
    $ids = @{}; $lastLine = $null
    foreach ($line in [System.IO.File]::ReadLines($Path)) {
        if ($line.IndexOf('"usage"') -lt 0 -or $line.IndexOf('"type":"assistant"') -lt 0 -or $line.IndexOf('<synthetic>') -ge 0) { continue }
        $im = [regex]::Match($line, '"id"\s*:\s*"(msg_[^"]+)"'); if (-not $im.Success) { continue }
        $ids[$im.Groups[1].Value] = $true; $lastLine = $line
    }
    if (-not $ids.Count) { return $null }
    $ctx = 0L
    foreach ($k in 'input_tokens', 'cache_creation_input_tokens', 'cache_read_input_tokens') { $vm = [regex]::Match($lastLine, '"' + $k + '"\s*:\s*(\d+)'); if ($vm.Success) { $ctx += [int64]$vm.Groups[1].Value } }
    return @{ Calls = $ids.Count; LastContext = $ctx }
}
