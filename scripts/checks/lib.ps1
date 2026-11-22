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
# v3.64.0 (item 6 B): os globs de guards.json → treeIgnore (vazio por padrão).
function Get-TreeIgnore([string]$Root) {
    $gp = Join-Path $Root '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $gp)) { return @() }
    try { $j = Read-Text $gp | ConvertFrom-Json } catch { return @() }
    if (-not $j.PSObject.Properties['treeIgnore']) { return @() }
    return @(@($j.treeIgnore) | Where-Object { $_ } | ForEach-Object { ([string]$_ -replace '\\', '/').Trim().TrimStart('/') })
}
function Test-TreeIgnored([string]$Root, [string]$Rel) {
    $p = ($Rel -replace '\\', '/').TrimStart('/')
    foreach ($g in @(Get-TreeIgnore $Root)) { $rx = ConvertTo-GlobRegex $g; if ($rx -and $p -match $rx) { return $true } }
    return $false
}
# v3.64.0 (item 6 D): os arquivos que mudaram entre duas impressões de árvore (os objetos do write-tree ficam no repositório
# até o gc). $null quando uma delas não se lê.
function Get-TreeDiff([string]$Root, [string]$From, [string]$To) {
    if (-not $From -or -not $To) { return $null }
    $ErrorActionPreference = 'Continue'
    $out = @(& git -C $Root -c core.quotePath=false diff --name-only $From $To 2>$null)
    if ($LASTEXITCODE -ne 0) { return $null }
    return @($out | Where-Object { $_ })
}
# v3.64.0 (item 6 A, decisão D1): a Task sai da construção sem fechar (🔴, pausa, espera de GAP) com o código no disco → um
# commit só do escopo do plano, "<T-ID> (checkpoint, sem fechar): <título>" com o trailer "Task-State: parcial". O marcador não
# muda, e o fechamento faz o commit final de sempre. No sprint 6 do piloto, a T-090 parada travou a T-093 até um commit à mão.
# $T: um item do Get-SprintTasks. Devolve uma linha (ou '' quando não havia o que guardar).
function Save-TaskCheckpoint([string]$Root, [string]$S, $T, [string]$Why) {
    $ErrorActionPreference = 'Continue'
    $null = & git -C $Root rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0) { return '' }
    if (-not $T.Plan -or $T.Plan -match '^plan/?$') { return '' }
    $pf = Join-Path $S $T.Plan; if (-not (Test-Path -LiteralPath $pf -PathType Leaf)) { return '' }
    $pt = Read-Text $pf
    $scope = @(Get-PlanScope $pt) + @(Get-Mutations $pt | ForEach-Object { ($_.Test -replace '\\', '/') -replace '^\./', '' })
    $dvp = Join-Path $S "delivery/$($T.Id).md"
    if ($scope.Count -and (Test-Path -LiteralPath $dvp)) { $scope += @(Get-MarginAdjustments (Read-Text $dvp) | Where-Object { $_.Kind -eq 'stub' } | ForEach-Object { $_.File }) }
    $scope = @($scope | Where-Object { $_ -and $_ -notmatch '^\.team-project(/|$)' -and $_ -notmatch '[<>*?]' } | Select-Object -Unique)
    if (-not $scope.Count) { return '' }
    foreach ($f in $scope) { $null = & git -C $Root add -A -- ":(literal)$f" 2>$null }
    $staged = @(& git -C $Root diff --cached --name-only -- @($scope | ForEach-Object { ":(literal)$_" }) 2>$null | Where-Object { $_ })
    if (-not $staged.Count) { return '' }
    $subj = "$($T.Id) (checkpoint, sem fechar): $($T.Title)"
    if ($subj.Length -gt 72) { $cut = $subj.LastIndexOf(' ', 70); if ($cut -lt 20) { $cut = 70 }; $subj = $subj.Substring(0, $cut).TrimEnd(' ', ',', ';', ':', '-', '—') + '…' }
    $mf = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($mf, "$subj`n`n$Why`n`nTask-State: parcial`n", (New-Object System.Text.UTF8Encoding($false)))
        $o = & git -C $Root commit -q -F $mf -- @($staged | ForEach-Object { ":(literal)$_" }) 2>&1 | Out-String
        $code = $LASTEXITCODE
    } finally { Remove-Item -LiteralPath $mf -Force -ErrorAction SilentlyContinue }
    if ($code -ne 0) { return "checkpoint da $($T.Id): o commit falhou ($(($o -replace '\s+', ' ').Trim())) — o código segue no disco" }
    $sha = ([string](& git -C $Root rev-parse --short HEAD 2>$null)).Trim()
    return "checkpoint da $($T.Id): $sha ($($staged.Count) arquivo(s) do plano, sem fechar — $Why)"
}
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
        # v3.64.0 (item 6 B): guards.json → treeIgnore — sobras do projeto que não são código (um .zip na raiz, um script de
        # máquina) saem da impressão da árvore: mexer nelas não deixa o verify velho.
        foreach ($g in @(Get-TreeIgnore $Root)) { & git -C $top rm -r -q --cached --ignore-unmatch -- ":(glob)$g" 2>$null | Out-Null }
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

# v3.63.1 (pedido 8 do sprint 6 do projeto piloto, Q-S6d): o NAVEGADOR da suíte caiu no meio — o Karma imprime "Disconnected
# (0 times) because no message in 120000 ms", o Chrome fecha ("crashed") ou não é capturado. Caiu duas vezes seguidas no
# verify full e reprovou como suíte vermelha, sem teste reprovado. Devolve @{ Text (a linha); At (o último "Executed N"); Total }
# ou $null. O At separa as duas causas na 2ª queda: no MESMO ponto é um teste que trava o navegador; em pontos diferentes,
# carga ou memória da máquina.
$script:RunnerDisconnectRe = @(
    '(?i)\bDisconnected\b[^\r\n]*\bno message in \d+\s*ms',
    '(?i)\bDisconnected reconnect failed',
    '(?i)\b(Chrome(\s?Headless)?|Chromium|Firefox(\s?Headless)?|Edge(\s?Headless)?)\b[^\r\n]*\b(crashed|have not captured in \d+\s*ms)'
)
function Get-RunnerDisconnect([string]$Text) {
    if (-not $Text) { return $null }
    $line = ''
    foreach ($re in $script:RunnerDisconnectRe) { $m = [regex]::Match($Text, "[^\r\n]*(?:$re)[^\r\n]*"); if ($m.Success) { $line = $m.Value.Trim(); break } }
    if (-not $line) { return $null }
    $line = $line -replace '^\S+\s+\S+\s+\S+\s+[\d:.]+:', '' -replace '\s+', ' '   # sem o carimbo de data do Karma
    if ($line.Length -gt 200) { $line = $line.Substring(0, 200) + '…' }
    $ex = @([regex]::Matches($Text, '\bExecuted (\d+) of (\d+)'))
    $at = if ($ex.Count) { [int]$ex[-1].Groups[1].Value } else { 0 }
    $tot = if ($ex.Count) { [int]$ex[-1].Groups[2].Value } else { 0 }
    return [pscustomobject]@{ Text = $line.Trim(); At = $at; Total = $tot }
}

# v3.62.1: o log do comando pode continuar aberto por um descendente ÓRFÃO alguns segundos depois de o comando sair. Caso
# medido: o daemon de uso único do Gradle — sobe quando org.gradle.jvmargs difere da JVM cliente, o padrão de projeto Android —
# herda a saída redirecionada e só a solta depois do gradlew; a espera fixa de 200 ms perdia a corrida e o verify caía com
# exit 2 ("o processo não pode acessar o arquivo") com o build verde (ensaio do braço NT do benchmark, 2026-11-17: 3 de 3).
# Read-LogText lê com FileShare.ReadWrite (não briga com quem ainda escreve). Add-LogText espera o arquivo ficar livre até
# $WaitSec, depois grava compartilhando a escrita, e só então desiste — devolve $false, sem lançar nem escrever no stderr.
function Read-LogText([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return '' }
    $fs = New-Object System.IO.FileStream($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
    try { return (New-Object System.IO.StreamReader($fs, (New-Object System.Text.UTF8Encoding($false)))).ReadToEnd() } finally { $fs.Dispose() }
}
function Add-LogText([string]$Path, [string]$Text, [double]$WaitSec = 30) {
    $bytes = (New-Object System.Text.UTF8Encoding($false)).GetBytes($Text)
    $deadline = (Get-Date).AddSeconds([Math]::Max(0, $WaitSec))
    $write = { param($share) $fs = New-Object System.IO.FileStream($Path, [System.IO.FileMode]::Append, [System.IO.FileAccess]::Write, $share); try { $fs.Write($bytes, 0, $bytes.Length) } finally { $fs.Dispose() } }
    while ($true) {
        try { & $write ([System.IO.FileShare]::Read); return $true } catch { if ((Get-Date) -ge $deadline) { break }; Start-Sleep -Milliseconds 250 }
    }
    try { & $write ([System.IO.FileShare]::ReadWrite); return $true } catch { }
    # sem aviso no stderr: quem chama o verify com 2>&1 e erro fatal cairia pelo aviso (a suíte caiu assim); o $false basta
    return $false
}

# Linhas decisivas de um log: as últimas que falam de teste, falha, cobertura ou porcentagem.
function Get-Decisive([string]$Log) {
    $lines = @((Read-LogText $Log) -split "`r?`n")
    if ($lines.Count -and $lines[-1] -eq '') { $lines = @($lines | Select-Object -First ($lines.Count - 1)) }   # como o ReadAllLines: sem a vazia do fim
    $hit = @($lines | Where-Object { $_ -match '(?i)\b(pass(ed|ing)?|fail(ed|ures?)?|errors?|warnings?|tests?|total|coverage|cobertura|threshold)\b|\d+(\.\d+)?\s*%' } | Select-Object -Last 4)
    if ($hit.Count -eq 0) { $hit = @($lines | Where-Object { $_.Trim() } | Select-Object -Last 2) }
    return @{ Lines = $lines.Count; Decisive = @($hit | ForEach-Object { $t = $_.Trim(); if ($t.Length -gt 200) { $t.Substring(0, 200) + '…' } else { $t } }) }
}

# Roda um comando do projeto num PowerShell filho (v3.45.1; comum ao verify e ao quality desde a v3.51): código de saída
# real, saída inteira no log, tempo limite próprio com a árvore de processos encerrada (exit 124), descendentes que sobram
# encerrados ao fim (daemon), higiene da ferramenta e $EnvExtra como variáveis do filho, falha de ambiente por assinatura.
# v3.51.4 (-KeepDescendants, verify.daemon): os descendentes que sobram (o daemon) ficam vivos e voltam em "kept" — o
# verify.ps1 os reaproveita no comando seguinte e os encerra no fim da chamada (Stop-ProcessTree), antes de devolver o controle.
# v3.57.3 (plugin-report do sprint 5 do garden, §3 item 10 e §4 item 16; decisão do stakeholder de 10/11): -PidFile registra o
# processo do comando (pid, hora de criação, chave, quem o iniciou) enquanto ele roda e apaga o registro no fim. Se quem chamou
# morre no meio (o verify encerrado pela ferramenta, o dev que caiu), o registro fica: é o que o verify.ps1 -Kill e a rodada
# seguinte encerram — só esses processos, nunca um de fora (no sprint 5 sobraram suítes e Chrome que só saíram com taskkill à mão).
function Invoke-ProjectCommand([string]$Root, [string]$Key, [string]$Cmd, [string]$Log, [double]$TimeoutMinutes, $EnvExtra, [switch]$KeepDescendants, [double]$ClockSkewMin = 0, [string]$PidFile = '') {
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
    if ($PidFile) { try { [System.IO.File]::WriteAllText($PidFile, ([ordered]@{ pid = $p.Id; created = (Get-ProcessCreated $p.Id); key = $Key; owner = $PID; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') } | ConvertTo-Json -Compress), $u8) } catch { } }
    $limit = if ($TimeoutMinutes -gt 0) { [Math]::Max(0.05, $TimeoutMinutes) } else { 9 }
    $timedOut = -not $p.WaitForExit([int]($limit * 60000))
    $kept = @()
    if ($timedOut) { $null = Stop-ProcessTree $p.Id; $p.WaitForExit(5000) | Out-Null; $code = 124 }
    elseif ($KeepDescendants) { $p.WaitForExit(); $code = $p.ExitCode; $kept = @(Get-DescendantIds $p.Id) }
    else { $p.WaitForExit(); $code = $p.ExitCode; $null = Stop-ProcessTree $p.Id -ChildrenOnly }
    if ($PidFile) { Remove-Item -LiteralPath $PidFile -Force -ErrorAction SilentlyContinue }
    Start-Sleep -Milliseconds 200   # o arquivo de saída fica livre depois que os descendentes saem (órfão: Add-LogText espera)
    # v3.57.0 (plugin-report do sprint 5 do garden, item 8): o notebook suspendeu ~9 h no meio da suíte; o relógio de parede
    # andou horas contra um prazo de minutos, o Karma perdeu a conexão e a rodada reprovou sem defeito no código. Relógio muito
    # além do prazo = suspensão do sistema: o resultado não vale como prova e quem chama repete a rodada (uma vez).
    $wallMin = ((Get-Date) - $t0).TotalMinutes + $ClockSkewMin
    $suspended = $wallMin -gt ($limit * 1.5 + 1)
    # v3.62.1: leitura compartilhada e gravação com espera (Add-LogText) — o daemon órfão do Gradle ainda segura log e .err
    if (Test-Path -LiteralPath "$Log.err") { $err = Read-LogText "$Log.err"; if ($err) { $null = Add-LogText $Log $err }; Remove-Item -LiteralPath "$Log.err" -Force -ErrorAction SilentlyContinue }
    if ($timedOut) { $null = Add-LogText $Log "`nTEMPO ESGOTADO: $limit min — árvore do processo encerrada`n" }
    $null = Add-LogText $Log "`nEXIT=$code`n"
    $d = Get-Decisive $Log
    $envFail = if ($suspended) { "suspensão do sistema detectada: o relógio andou $([int]$wallMin) min contra o prazo de $limit min — a rodada não vale como prova (o runner pode ter perdido a conexão); repita" }
               elseif ($timedOut) { "tempo esgotado ($limit min): o comando não devolveu o controle — confira modo de observação ou processo que não termina (tool-hygiene.json)" }
               elseif ($code -ne 0) { Get-EnvFailure ([System.IO.File]::ReadAllText($Log, $u8)) } else { $null }
    # v3.63.1 (pedido 8): o navegador da suíte que caiu no meio não é teste reprovado — ambiente, com o ponto em que caiu; o
    # verify.ps1 repete a rodada uma vez e, na 2ª queda, separa o teste que trava o navegador da máquina sem memória.
    $disc = $null
    if (-not $envFail -and $code -ne 0) { $disc = Get-RunnerDisconnect (Read-LogText $Log) }
    if ($disc) { $envFail = "o navegador da suíte caiu no meio ($($disc.Text))$(if ($disc.At) { " depois do teste $($disc.At) de $($disc.Total)" }) — não é teste reprovado" }
    $r = [ordered]@{ key = $Key; command = $Cmd; exit = $code; seconds = [int]$sw.Elapsed.TotalSeconds; log = ($Log.Substring($Root.Length + 1) -replace '\\', '/'); lines = $d.Lines; decisive = $d.Decisive; environment = $envFail; hygiene = @($hy.Tools); warnings = @($hy.Warnings); suspended = $suspended; disconnect = $disc }
    if ($KeepDescendants) { $r.kept = $kept }
    return $r
}
# v3.58.2 (verify.watch): o runner do teste focado em MODO DE OBSERVAÇÃO — um processo que fica vivo de propósito durante a
# mutação. Mesma higiene de ambiente e saída em ARQUIVO do Invoke-ProjectCommand, sem esperar o fim: quem chama lê o arquivo
# (verify.ps1 Wait-WatchRun), encerra a árvore no fim (Stop-ProcessTree) e o registro em -PidFile é o que o -Kill e a rodada
# seguinte encerram se quem chamou cair. Devolve o processo (com o handle aberto).
function Start-ProjectWatch([string]$Root, [string]$Cmd, [string]$Log, $EnvExtra, [string]$PidFile = '') {
    $hy = Get-ToolHygiene $Cmd $EnvExtra   # os avisos de "modo de observação" não valem aqui: é de propósito
    $envPrefix = (@($hy.Env.Keys) | ForEach-Object { "[Environment]::SetEnvironmentVariable('$($_ -replace "'", "''")', '$(([string]$hy.Env[$_]) -replace "'", "''")', 'Process'); " }) -join ''
    $enc = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($envPrefix + $Cmd))
    foreach ($f in $Log, "$Log.err") { if (Test-Path -LiteralPath $f) { Remove-Item -LiteralPath $f -Force } }
    $p = Start-Process -FilePath 'powershell' -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-EncodedCommand', $enc) -WorkingDirectory $Root -RedirectStandardOutput $Log -RedirectStandardError "$Log.err" -NoNewWindow -PassThru
    $null = $p.Handle
    if ($PidFile) { try { [System.IO.File]::WriteAllText($PidFile, ([ordered]@{ pid = $p.Id; created = (Get-ProcessCreated $p.Id); key = 'watch'; owner = $PID; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') } | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false))) } catch { } }
    return $p
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

# v3.62.2 (sprint 6 do garden, Q-S6d: 7 instâncias de dev em 16–17/11) — RODADA DESACOPLADA. O comando que a ferramenta move
# para segundo plano (passou de 600 s) é ENCERRADO pelo Claude Code quando o agente dá a resposta final: "it is terminated when
# you give your final response and no notification can follow that" (2.1.308, 2.1.310, 2.1.325 e 2.1.326; em outras versões o
# aviso chegava — o plugin apostava nele). E encerra a árvore inteira: o filho de Start-Process morre junto (medido em 17/11).
# O processo criado pelo WMI (Win32_Process.Create) tem pai fora da árvore do shell e sobrevive (medido: mesma sessão do
# Windows, mesmo usuário, node e git no PATH). A rodada longa roda num processo assim; quem chama só a ACOMPANHA, com prazo
# abaixo dos 600 s, e o MESMO pedido de novo volta a acompanhá-la — nenhum agente precisa encerrar o turno para esperar.
# Pasta da rodada: job.json (o pedido e o processo: sig, label, tree, pid, created, at), job.run.json (o que o executor lê:
# cwd, comando), job.out / job.err (a saída do script) e job.exit (o código, gravado no fim pelo executor). O ambiente de quem
# chamou vai num arquivo do TEMP (o WMI não o herda) que o executor lê e apaga na partida — não fica na pasta do projeto.
$script:jobFiles = @('job.json', 'job.run.json', 'job.out', 'job.err', 'job.exit', 'job.exit.tmp')
function Clear-DetachedJob([string]$Dir) {
    foreach ($f in $script:jobFiles) { Remove-Item -LiteralPath (Join-Path $Dir $f) -Force -ErrorAction SilentlyContinue }
}
# Estado da rodada da pasta: $null sem rodada; senão State running · done (job.exit gravado; Exit = o código) · dead (o
# executor saiu sem gravar o código: encerrado de fora, máquina reiniciada).
function Get-DetachedJob([string]$Dir) {
    $jf = Join-Path $Dir 'job.json'
    if (-not (Test-Path -LiteralPath $jf)) { return $null }
    $j = $null; try { $j = Read-Text $jf | ConvertFrom-Json } catch { }
    if (-not $j) { return $null }
    $ef = Join-Path $Dir 'job.exit'
    $state = 'running'
    if (Test-Path -LiteralPath $ef) { $state = 'done' }
    else {
        $cur = if ([int]$j.pid -gt 0) { Get-ProcessCreated ([int]$j.pid) } else { '' }
        if (-not $cur -or ($j.created -and $cur -ne [string]$j.created)) { $state = if (Test-Path -LiteralPath $ef) { 'done' } else { 'dead' } }
    }
    $code = $null
    if ($state -eq 'done') { try { $code = [int]((Read-Text $ef).Trim()) } catch { $code = 1 } }
    $min = try { ((Get-Date) - [datetime]::ParseExact([string]$j.at, 'yyyy-MM-dd HH:mm:ss', $null)).TotalMinutes } catch { 0 }
    return [pscustomobject]@{ Dir = $Dir; Sig = [string]$j.sig; Label = [string]$j.label; Tree = [string]$j.tree; Pid = [int]$j.pid; Created = [string]$j.created; At = [string]$j.at; State = $state; Exit = $code; Minutes = $min }
}
# Sobe a rodada: $Command (PowerShell) roda com a saída em job.out/job.err, na pasta $Root, com o ambiente desta chamada.
# $null = subiu; senão o motivo.
function Start-DetachedJob([string]$Dir, [string]$Root, [string]$Command, [string]$Sig, [string]$Label, [string]$Tree = '') {
    $u8 = New-Object System.Text.UTF8Encoding($false)
    New-Item -ItemType Directory -Force $Dir | Out-Null
    Clear-DetachedJob $Dir
    $envFile = Join-Path ([System.IO.Path]::GetTempPath()) ('team-job-' + [guid]::NewGuid().ToString('N') + '.json')
    $envs = [ordered]@{}; foreach ($e in [Environment]::GetEnvironmentVariables('Process').GetEnumerator()) { $envs[[string]$e.Key] = [string]$e.Value }
    [System.IO.File]::WriteAllText($envFile, ($envs | ConvertTo-Json -Compress), $u8)
    # A saída do script em UTF-8 (o console redirecionado do 5.1 escreveria na página OEM e os acentos chegariam trocados).
    $full = '$ProgressPreference = ''SilentlyContinue''; [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false); $OutputEncoding = [Console]::OutputEncoding; ' + $Command
    $run = [ordered]@{ cwd = $Root; encoded = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($full)); env = $envFile }
    [System.IO.File]::WriteAllText((Join-Path $Dir 'job.run.json'), ($run | ConvertTo-Json -Compress), $u8)
    $runner = Join-Path $PSScriptRoot 'detached-run.ps1'
    $cl = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$runner`" -Dir `"$Dir`""
    $r = $null
    # protocolo: desprendido — a rodada deve sobreviver a quem chamou; o PID e a hora de criação vão ao job.json (abaixo).
    try {
        $si = New-CimInstance -ClassName Win32_ProcessStartup -ClientOnly -Property @{ ShowWindow = [uint16]0 }
        $r = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = $cl; CurrentDirectory = $Root; ProcessStartupInformation = $si } -ErrorAction Stop
    } catch { Remove-Item -LiteralPath $envFile -Force -ErrorAction SilentlyContinue; return "o WMI não criou o processo da rodada ($($_.Exception.Message))" }
    if (-not $r -or [int]$r.ReturnValue -ne 0) { Remove-Item -LiteralPath $envFile -Force -ErrorAction SilentlyContinue; return "o WMI não criou o processo da rodada (Win32_Process.Create devolveu $(if ($r) { $r.ReturnValue } else { 'nada' }))" }
    $jp = [int]$r.ProcessId
    $j = [ordered]@{ sig = $Sig; label = $Label; tree = $Tree; pid = $jp; created = (Get-ProcessCreated $jp); at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
    [System.IO.File]::WriteAllText((Join-Path $Dir 'job.json'), ($j | ConvertTo-Json -Compress), $u8)
    return $null
}
# Acompanha a rodada até ela acabar ou até $Seconds: devolve o estado (Get-DetachedJob). Confere o job.exit a cada 0,5 s e se
# o processo segue vivo a cada ~5 s.
function Wait-DetachedJob([string]$Dir, [int]$Seconds) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew(); $ef = Join-Path $Dir 'job.exit'; $lastLive = -10
    while ($true) {
        if (Test-Path -LiteralPath $ef) { return (Get-DetachedJob $Dir) }
        $t = $sw.Elapsed.TotalSeconds
        if ($t - $lastLive -ge 5) { $lastLive = $t; $job = Get-DetachedJob $Dir; if (-not $job -or $job.State -ne 'running') { return $job } }
        if ($t -ge $Seconds) { return (Get-DetachedJob $Dir) }
        Start-Sleep -Milliseconds 500
    }
}
# A saída da rodada (job.out e job.err), lida compartilhando o arquivo.
function Read-DetachedOutput([string]$Dir) {
    $o = ''; $e = ''
    try { $o = Read-LogText (Join-Path $Dir 'job.out') } catch { }
    try { $e = Read-LogText (Join-Path $Dir 'job.err') } catch { }
    # O PowerShell filho com -EncodedCommand escreve o stderr em CLIXML (registros de progresso, erros) MISTURADO com o texto
    # cru do [Console]::Error: guarda as linhas de texto e o texto das mensagens de erro do XML; o resto (progresso) sai.
    if ($e -match '^#< CLIXML') {
        $plain = @(($e -split "`r?`n") | Where-Object { $_ -and $_ -ne '#< CLIXML' -and $_ -notmatch '^<Objs\b' })
        $xmlErr = (([regex]::Matches($e, '<S S="Error">(.*?)</S>') | ForEach-Object { $_.Groups[1].Value }) -join '') -replace '_x000D__x000A_', "`n" -replace '_x000D_', '' -replace '&lt;', '<' -replace '&gt;', '>' -replace '&amp;', '&'
        $e = (@($plain | ForEach-Object { "$_`n" }) -join '') + $xmlErr
    }
    return [pscustomobject]@{ Out = $o; Err = $e }
}
# Encerra a rodada viva (o executor e toda a árvore dele: o script e os comandos do projeto) e apaga os arquivos dela.
# Devolve quantos processos saíram (0 sem rodada viva).
function Stop-DetachedJob([string]$Dir) {
    $job = Get-DetachedJob $Dir
    $n = 0
    if ($job -and $job.State -eq 'running') { $n = 1 + [int](Stop-ProcessTree $job.Pid) }
    Clear-DetachedJob $Dir
    return $n
}

# v3.58.4 (sprint 6 do garden): memória física livre, em MB. O Claude Code encerra o comando em segundo plano quando ela
# acaba (com a sessão ociosa) — no garden, o verify full da T-081 no teste 2925 de 2926, com o Windows longe do limite de
# alocação. TEAM_TEST_FREE_MB substitui a leitura (testes).
function Get-FreeMemoryMB {
    if ($env:TEAM_TEST_FREE_MB) { return [int]$env:TEAM_TEST_FREE_MB }
    try { return [int]((Get-CimInstance Win32_OperatingSystem -Property FreePhysicalMemory -ErrorAction Stop).FreePhysicalMemory / 1KB) } catch { return -1 }
}
# Os maiores consumidores de memória da máquina, somados por nome: "qemu-system-x86_64 4,2 GB · Code (19) 3,1 GB · …".
function Get-TopMemoryText([int]$Top = 5) {
    try {
        return (@(Get-Process -ErrorAction Stop | Group-Object ProcessName | ForEach-Object { [pscustomobject]@{ N = $_.Name; C = $_.Count; B = ($_.Group | Measure-Object WorkingSet64 -Sum).Sum } } |
            Sort-Object B -Descending | Select-Object -First $Top | ForEach-Object { "$($_.N)$(if ($_.C -gt 1) { " ($($_.C))" }) $(([double]$_.B / 1GB).ToString('0.0', [Globalization.CultureInfo]::GetCultureInfo('pt-BR'))) GB" }) -join ' · ')
    } catch { return '' }
}
# Desliga o emulador local que a construção não usa (target.ps1 -Release, num PowerShell filho com prazo: o adaptador android
# não é carregado no processo de quem chama). Só com targets.android declarado. @{ Ran; Freed; Text }.
function Invoke-TargetRelease([string]$Root) {
    $tg = Get-TargetsConfig $Root
    if (-not ($tg -and $tg.PSObject.Properties['android'])) { return @{ Ran = $false; Freed = $false; Text = 'sem alvo android no guards.json' } }
    $ts = Join-Path $PSScriptRoot 'target.ps1'
    $r = Invoke-Bounded $Root "& '$($ts -replace "'", "''")' -Target android -Release -Root '$($Root -replace "'", "''")'" 120
    $txt = (($r.out -split "`r?`n" | Where-Object { $_ -match '^target android:' }) | Select-Object -Last 1)
    if (-not $txt) { $txt = if ($r.timedOut) { 'target.ps1 -Release passou de 120 s' } else { "target.ps1 -Release saiu com $($r.exit)" } }
    return @{ Ran = $true; Freed = ($r.exit -eq 0 -and $txt -match 'liberado —'); Text = ($txt -replace '^target android:\s*', '') }
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
# v3.65.10 (item D): com uma cópia byte a byte igual e mais velha na mesma pasta, a idade é a da cópia — o APK novo é sobra
# de um build anterior, não um build novo (Twin = a cópia).
# v3.65.12 (garden S6, 22/11 08:18): o lista-insumos.component.html tinha a data de 02:18, mas o conteúdo era o do commit de
# 21/11 00:14, anterior ao APK. O accept recusou o APK como velho, e o build, certo, deu os mesmos bytes duas vezes: fonte
# igual, APK igual. Uma data mais nova não é mudança. Dos arquivos com data posterior ao APK, ficam só os que o git diz que
# mudaram depois dele: alterado na cópia de trabalho, não rastreado, ou num commit posterior. Sem git, ficam todos.
function Get-ContentChangedSince([string]$Root, $Files, [datetime]$Since) {
    $Files = @($Files | Where-Object { $_ })
    if (-not $Files.Count -or -not $Root) { return $Files }
    $ErrorActionPreference = 'Continue'
    $top = (& git -C $Root rev-parse --show-toplevel 2>$null)
    if ($LASTEXITCODE -ne 0 -or -not $top) { return $Files }
    $topFull = (([string]$top) -replace '\\', '/').TrimEnd('/')
    $rel = @{}
    foreach ($f in $Files) {
        $p = ($f.FullName -replace '\\', '/')
        if (-not $p.StartsWith($topFull + '/', [StringComparison]::OrdinalIgnoreCase)) { return $Files }
        $rel[$p.Substring($topFull.Length + 1).ToLowerInvariant()] = $f
    }
    $paths = @($rel.Keys)
    $changed = New-Object 'System.Collections.Generic.HashSet[string]'
    $known = New-Object 'System.Collections.Generic.HashSet[string]'
    # Em lotes, para a linha de comando não estourar.
    for ($i = 0; $i -lt $paths.Count; $i += 200) {
        $chunk = @($paths[$i..([Math]::Min($i + 199, $paths.Count - 1))])
        $tracked = @(& git -C $top -c core.quotePath=false ls-files -- @chunk 2>$null)
        if ($LASTEXITCODE -ne 0) { return $Files }
        foreach ($t in $tracked) { [void]$known.Add(([string]$t).ToLowerInvariant()) }
        foreach ($l in @(& git -C $top -c core.quotePath=false status --porcelain --untracked-files=all -- @chunk 2>$null)) {
            $s = [string]$l; if ($s.Length -lt 4) { continue }
            $q = $s.Substring(3); if ($q -match ' -> (.+)$') { $q = $Matches[1] }
            [void]$changed.Add($q.Trim('"').ToLowerInvariant())
        }
        foreach ($l in @(& git -C $top -c core.quotePath=false log --since ($Since.ToString('yyyy-MM-ddTHH:mm:ss')) --format= --name-only -- @chunk 2>$null)) {
            $q = ([string]$l).Trim(); if ($q) { [void]$changed.Add($q.ToLowerInvariant()) }
        }
    }
    # Fora do git (ignorado): sem como saber o conteúdo, vale a data.
    return @($paths | Where-Object { $changed.Contains($_) -or -not $known.Contains($_) } | ForEach-Object { $rel[$_] })
}
# v3.65.12: a palavra do Arquiteto quando a conferência do plugin erra. Se ele confirma que o APK tem o código da árvore (a
# recusa era alarme falso), grava .team-project/apk-attest.json { "hash": "<12 hex do APK>", "by": "architect", "why": "...",
# "at": "..." } e o accept segue com esse APK. A atestação vale só para aqueles bytes: build novo, hash novo, conferência normal.
# $null sem atestação para o hash.
function Get-ApkAttest([string]$Root, [string]$Hash) {
    $Hash = ([string]$Hash) -replace '^apk:', ''
    if (-not $Root -or $Hash -notmatch '^[0-9a-f]{12}$') { return $null }
    $p = Join-Path $Root '.team-project/apk-attest.json'
    if (-not (Test-Path -LiteralPath $p -PathType Leaf)) { return $null }
    try { $j = Read-Text $p | ConvertFrom-Json } catch { return $null }
    if (-not $j -or ([string]$j.hash).ToLowerInvariant() -ne $Hash -or -not ([string]$j.why).Trim()) { return $null }
    return $j
}
function Get-ApkStaleness([string]$Apk, [string]$Root = '') {
    $r = @{ Stale = $false; Note = ''; Twin = '' }
    if (-not $Apk -or -not (Test-Path -LiteralPath $Apk -PathType Leaf)) { return $r }
    $full = (Resolve-Path -LiteralPath $Apk).Path
    $apkTime = (Get-Item -LiteralPath $full).LastWriteTime
    $tw = Get-ApkTwin $full
    if ($tw) { $r.Twin = $tw.FullName; $r.TwinTime = $tw.LastWriteTime; $apkTime = $tw.LastWriteTime }
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
        $newer = @(Get-ContentChangedSince $Root @($cands | Where-Object { $_.LastWriteTime -gt $apkTime.AddSeconds(2) }) $apkTime)   # v3.65.12
        $newest = $newer | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($newest) {
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
    $newer = @(Get-ContentChangedSince $(if ($Root) { $Root } else { $mod }) @($cands | Where-Object { $_.LastWriteTime -gt $apkTime.AddSeconds(2) }) $apkTime)   # v3.65.12
    $newest = $newer | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($newest) {
        $r.Stale = $true; $r.File = $newest.FullName; $r.FileTime = $newest.LastWriteTime; $r.ApkTime = $apkTime; $r.Module = $mod; $r.ApkFull = $full
        $r.Task = if ($full -match '[\\/]release[\\/]') { 'assembleRelease' } else { 'assembleDebug' }
    }
    return $r
}

# ---------- v3.65.10 · o app no aparelho é o código da árvore? ----------
# Sprint 6 do garden (20–21/11): o guards.json não declara targets.android.apk; o build roda num volume do Docker e o APK vai a
# source/dist/. O accept não achava APK local, não instalava nem conferia nada, e não dizia isso: as rodadas 6 a 12 do aceite
# rodaram sobre o mesmo app (apk:731dfab5b3fd, o APK da Q-S6f), e a Q-S6h passou a ✅ sem que o aparelho tivesse a mudança.

# Cópia byte a byte igual e mais velha do APK, na mesma pasta (FileInfo ou $null). No garden, o Q-S6d-debug.apk era o
# Q-S6-debug.apk copiado: o "build novo" era o de antes.
function Get-ApkTwin([string]$Apk) {
    if (-not $Apk -or -not (Test-Path -LiteralPath $Apk -PathType Leaf)) { return $null }
    $me = Get-Item -LiteralPath $Apk; $h = ''
    $twins = foreach ($o in @(Get-ChildItem -LiteralPath $me.DirectoryName -Filter '*.apk' -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName -ne $me.FullName -and $_.Length -eq $me.Length -and $_.LastWriteTime -lt $me.LastWriteTime })) {
        if (-not $h) { $h = Get-FileHash12 $me.FullName }
        if ((Get-FileHash12 $o.FullName) -eq $h) { $o }
    }
    return (@($twins) | Sort-Object LastWriteTime | Select-Object -First 1)
}
# Aviso quando o alvo android não tem APK local a instalar e conferir ('' sem aviso). $Resolved = o APK que o accept usaria
# ($null = procurar como o accept procura: targets.android.apk, depois **/build/outputs/apk/).
function Get-ApkDeclarationNote([string]$Root, $Resolved = $null) {
    $tc = Get-TargetsConfig $Root
    if (-not ($tc -and $tc.PSObject.Properties['android'] -and $tc.android)) { return '' }
    if ($null -eq $Resolved) { $Resolved = Get-ProjectApk $Root }
    if ($Resolved) { return '' }
    $decl = [string](Get-AndroidTargetValue $Root 'apk')
    $how = 'o app que está no aparelho não é reinstalado nem conferido com o build da árvore, e a prova pode rodar sobre um app de antes da mudança'
    if ($decl) { return "targets.android.apk '$decl' não casa nenhum arquivo, e não há APK em **/build/outputs/apk/: $how — confira o caminho (a máscara vale só no nome do arquivo) ou rode o build antes" }
    return "nenhum APK local (targets.android.apk não declarado e nada em **/build/outputs/apk/): $how. Declare no guards.json targets.android.apk (onde o build deixa o APK; aceita máscara no nome, vale o mais novo) e, com o APK fora de <módulo>/build/outputs, targets.android.apkSources (as fontes que entram nele)"
}
# v3.65.11 (garden S6: sem targets.android.apk, o aceite do portão usou o app que estava no aparelho, de antes da correção):
# a declaração que se infere do disco. Procura *.apk fora de node_modules/.git/.team-project e de **/build/outputs (esse o
# accept já acha sozinho). Uma pasta só → apk = a máscara do nome (o trecho que varia entre os arquivos vira *; um arquivo só,
# o nome) e, no app híbrido (capacitor.config.* ou config.xml do Cordova), apkSources = a pasta src/ e o arquivo de
# configuração ao lado dele. @{ Found; Apk; Sources; Dirs; Note } — Found $false com Dirs vazio (nada) ou com várias pastas
# (ambíguo: a escolha é do stakeholder).
function Find-ApkCandidate([string]$Root) {
    $r = @{ Found = $false; Apk = ''; Sources = @(); Dirs = @(); Note = '' }
    $rootFull = (Resolve-Path -LiteralPath $Root).Path.TrimEnd('\', '/')
    $skip = '[\\/](node_modules|\.git|\.team-project|\.gradle|build[\\/]intermediates)[\\/]'
    $skipNames = @('node_modules', '.git', '.team-project', '.gradle', '.angular', '.nx', 'intermediates', 'tmp')
    # Busca sem entrar nas pastas puladas (no garden, node_modules tem centenas de milhares de arquivos), até 8 níveis.
    $files = New-Object System.Collections.Generic.List[System.IO.FileInfo]
    $stack = New-Object System.Collections.Stack; $stack.Push(@((Get-Item -LiteralPath $rootFull), 0))
    while ($stack.Count) {
        $it = $stack.Pop(); $d = $it[0]; $lv = [int]$it[1]
        foreach ($c in @(Get-ChildItem -LiteralPath $d.FullName -Force -ErrorAction SilentlyContinue)) {
            if ($c.PSIsContainer) { if ($lv -lt 8 -and $skipNames -notcontains $c.Name -and -not ($c.Attributes -band [IO.FileAttributes]::ReparsePoint)) { $stack.Push(@($c, ($lv + 1))) } }
            elseif ($c.Extension -eq '.apk' -or $c.Name -match '^capacitor\.config\.(ts|json|js)$' -or $c.Name -eq 'config.xml') { $files.Add($c) }
        }
    }
    $apks = @($files | Where-Object { $_.Extension -eq '.apk' })
    if (-not $apks.Count) { $r.Note = 'nenhum APK no projeto: rode o build do app uma vez e repita'; return $r }
    if (@($apks | Where-Object { $_.FullName -match '[\\/]build[\\/]outputs[\\/]apk[\\/]' }).Count) { $r.Note = 'o APK está em <módulo>/build/outputs/apk/: o accept já o acha sem declaração'; return $r }
    $groups = @($apks | Group-Object DirectoryName)
    $r.Dirs = @($groups | ForEach-Object { ($_.Name.Substring($rootFull.Length).TrimStart('\', '/')) -replace '\\', '/' })
    if ($groups.Count -ne 1) { $r.Note = "APKs em $($groups.Count) pastas ($($r.Dirs -join ', ')): a escolha é do stakeholder"; return $r }
    $names = @($groups[0].Group | ForEach-Object { $_.Name })
    $leaf = $names[0]
    if ($names.Count -gt 1) {
        $pre = $names[0]; $suf = $names[0]
        foreach ($nm in $names) {
            while ($pre -and -not $nm.StartsWith($pre)) { $pre = $pre.Substring(0, $pre.Length - 1) }
            while ($suf -and -not $nm.EndsWith($suf)) { $suf = $suf.Substring(1) }
        }
        if (-not $suf.EndsWith('.apk')) { $suf = '.apk' }
        $leaf = if ($pre.Length + $suf.Length -le ($names | ForEach-Object { $_.Length } | Measure-Object -Minimum).Minimum) { "$pre*$suf" } else { '*.apk' }
    }
    $r.Apk = (@($r.Dirs[0], $leaf) | Where-Object { $_ }) -join '/'
    $cfgF = @($files | Where-Object { $_.Extension -ne '.apk' -and $_.FullName -notmatch $skip -and $_.FullName -notmatch '[\\/](android|ios|platforms|res)[\\/]' } | Sort-Object { $_.FullName.Length } | Select-Object -First 1)
    if ($cfgF.Count) {
        $base = $cfgF[0].DirectoryName
        $rel = { param($x) (($x.Substring($rootFull.Length).TrimStart('\', '/')) -replace '\\', '/') }
        if (Test-Path -LiteralPath (Join-Path $base 'src') -PathType Container) { $r.Sources += (& $rel (Join-Path $base 'src')) }
        $r.Sources += (& $rel $cfgF[0].FullName)
    }
    $r.Found = $true
    return $r
}
# O texto da declaração inferida para os avisos ('' sem inferência única).
function Get-ApkCandidateText([string]$Root) {
    $c = Find-ApkCandidate $Root
    if (-not $c.Found) { return '' }
    $src = if ($c.Sources.Count) { ', "apkSources": [' + (($c.Sources | ForEach-Object { '"' + $_ + '"' }) -join ', ') + ']' } else { '' }
    return "inferido do disco: targets.android ← `"apk`": `"$($c.Apk)`"$src"
}
# O app instalado é o mesmo de uma rodada anterior do aceite, e o código do app mudou desde então? Conferência sem depender de
# declaração: a identidade é o hash do base.apk (accept.ps1 Get-AppIdentity) e cada result.json guarda a árvore (tree). Vale a
# rodada MAIS ANTIGA com a mesma identidade — o app foi construído antes dela, então o que mudou depois não está nele.
# O que conta: os arquivos de produção (sem teste, sem quality.toolingPaths); com targets.android.apkSources, só eles; com o
# APK em <módulo>/build/outputs, só o módulo. O APK local mais novo que todos esses arquivos foi reconstruído depois da mudança
# (build que deu os mesmos bytes): não é app velho. @{ Stale; Since; Dir; Files; Count }.
function Get-InstalledAppStaleness([string]$Root, [string]$AppId, [string]$Apk = '') {
    $r = @{ Stale = $false; Since = ''; Dir = ''; Files = @(); Count = 0 }
    if (-not $AppId -or $AppId -notmatch '^apk:' -or $AppId -match ':\?$') { return $r }
    $now = Get-WorkTree $Root
    if (-not $now) { return $r }
    $first = $null
    foreach ($f in @(Get-ChildItem -LiteralPath (Join-Path $Root '.team-project/accept') -Recurse -Filter 'result.json' -File -ErrorAction SilentlyContinue)) {
        try { $j = Read-Text $f.FullName | ConvertFrom-Json } catch { continue }
        if ([string]$j.target -ne 'android' -or [string]$j.app -ne $AppId -or -not $j.tree) { continue }
        if ($j.PSObject.Properties['staleApp'] -and $j.staleApp) { continue }   # a rodada recusada não provou nada
        if (-not $first -or [string]$j.at -lt [string]$first.J.at) { $first = @{ J = $j; F = $f.FullName } }
    }
    if (-not $first -or [string]$first.J.tree -eq [string]$now) { return $r }
    $ErrorActionPreference = 'Continue'
    $top = (& git -C $Root rev-parse --show-toplevel 2>$null); if (-not $top) { return $r }
    $names = @(& git -C $top -c core.quotePath=false diff-tree -r --name-only ([string]$first.J.tree) $now 2>$null)
    if ($LASTEXITCODE -ne 0) { return $r }   # a árvore antiga saiu do repositório: sem como comparar
    $pre = ''
    $rootFull = ((Resolve-Path -LiteralPath $Root).Path -replace '\\', '/').TrimEnd('/'); $topFull = (([string]$top) -replace '\\', '/').TrimEnd('/')
    if ($rootFull.Length -gt $topFull.Length -and $rootFull.StartsWith($topFull, [StringComparison]::OrdinalIgnoreCase)) { $pre = $rootFull.Substring($topFull.Length + 1) + '/' }
    $src = @(Get-AndroidTargetValue $Root 'apkSources' | Where-Object { $_ } | ForEach-Object { ConvertTo-GlobRegex ([string]$_) } | Where-Object { $_ })
    $modRe = ''
    if (-not $src.Count -and $Apk) {
        $mm = [regex]::Match((([string]$Apk) -replace '\\', '/'), '^(.*)/build/outputs/apk/')
        if ($mm.Success -and $mm.Groups[1].Value.StartsWith($rootFull, [StringComparison]::OrdinalIgnoreCase) -and $mm.Groups[1].Value.Length -gt $rootFull.Length) { $modRe = '^' + [regex]::Escape($mm.Groups[1].Value.Substring($rootFull.Length + 1)) + '/' }
    }
    $toolRe = @(Get-ToolingPaths $Root | ForEach-Object { ConvertTo-GlobRegex $_ } | Where-Object { $_ })
    $hit = foreach ($p0 in $names) {
        $p = ([string]$p0).Trim(); if (-not $p) { continue }
        if ($pre) { if (-not $p.StartsWith($pre, [StringComparison]::OrdinalIgnoreCase)) { continue }; $p = $p.Substring($pre.Length) }
        if ($p -match '^\.team-project/' -or $p -match $script:TestPathRe) { continue }
        if (@($toolRe | Where-Object { $p -match $_ }).Count) { continue }
        if ($src.Count) { if (-not @($src | Where-Object { $p -match $_ }).Count) { continue } }
        elseif ($modRe -and $p -notmatch $modRe) { continue }
        $p
    }
    $hit = @($hit)
    if (-not $hit.Count) { return $r }
    if ($Apk -and (Test-Path -LiteralPath $Apk -PathType Leaf)) {
        $apkT = (Get-Item -LiteralPath $Apk).LastWriteTime; $tw = Get-ApkTwin $Apk; if ($tw) { $apkT = $tw.LastWriteTime }
        $times = @($hit | ForEach-Object { $fp = Join-Path $Root $_; if (Test-Path -LiteralPath $fp -PathType Leaf) { (Get-Item -LiteralPath $fp).LastWriteTime } })
        if ($times.Count -and $apkT -gt (($times | Sort-Object -Descending)[0]).AddSeconds(2)) { return $r }
    }
    $r.Stale = $true; $r.Since = [string]$first.J.at; $r.Count = $hit.Count; $r.Files = @($hit | Select-Object -First 5)
    $r.Dir = ((Split-Path $first.F -Parent).Substring($Root.Length).TrimStart('\', '/') -replace '\\', '/')
    return $r
}
# O frescor do app que o accept prova, no result.json (o diagnóstico lê): conferido = o APK local foi comparado com as fontes e
# é ele que está no aparelho. Sem isso, um elemento ausente pode ser o app de antes da mudança — não é APP (operator, regra 9).
# '' = frescor conferido ou result.json sem o campo (anterior à v3.65.10, ou alvo web); senão, o motivo.
function Get-AcceptFreshGap($Aj) {
    if (-not $Aj -or [string]$Aj.target -ne 'android') { return '' }
    if (-not ($Aj.PSObject.Properties['fresh'] -and $Aj.fresh)) { return '' }
    if ($Aj.fresh.checked) { return '' }
    $why = [string]$Aj.fresh.reason
    return "o app no aparelho ($([string]$Aj.fresh.installed)) não foi conferido com o build da árvore$(if ($why) { ": $why" })"
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
function Enter-TargetLock([string]$Root, [string]$Target, [string]$Owner, [int]$StaleHours = 3, [string]$Dir = '') {
    $lp = Join-Path $Root '.team-project/.target-lock'
    New-Item -ItemType Directory -Force (Split-Path $lp) | Out-Null
    # v3.63.1 (pedido 5): a hora de criação e a pasta do dono — o target.ps1 -Kill reconhece o processo (PID reaproveitado não é
    # tocado) e encerra a árvore do accept que ficou órfão quando o agente que o disparou foi encerrado.
    $lk = [ordered]@{ target = $Target; owner = $Owner; pid = $PID; created = (Get-ProcessCreated $PID); desde = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
    if ($Dir) { $lk.dir = (($Dir.Replace($Root, '').TrimStart('\', '/')) -replace '\\', '/') }
    $bytes = (New-Object System.Text.UTF8Encoding($false)).GetBytes(($lk | ConvertTo-Json -Compress))
    $h = Enter-LockFile $lp $bytes $StaleHours { param($x) Get-TargetLockDir $Root $x }
    if ($h -and $h.Busy) {
        $l = $h.Lock; $pu = $h.Pulse
        return "o alvo $([string]$l.target) está em uso por '$([string]$l.owner)' (PID $([int]$l.pid), desde $([string]$l.desde); $($pu.Text)): " + $(if ($pu.Stalled) { "o processo parece travado — encerre com target.ps1 -Target $([string]$l.target) -Kill (encerra o dono da trava e a árvore dele; decisão do stakeholder)" } else { 'espere terminar — dois automatizadores no mesmo alvo quebram os dois (quem usa o alvo: target.ps1 -Target ' + [string]$l.target + ' -Who)' })
    }
    if ($h) { return "a trava do alvo ($lp) foi tomada por outro executor ao mesmo tempo — rode de novo" }
    # v3.63.2: a trava do APARELHO, comum a todos os projetos da máquina. A do projeto (.team-project/.target-lock) não via outro
    # projeto: dois projetos com o mesmo emulador entravam os dois, e o reparo de um (reiniciar o emulador) derrubava o teste do
    # outro. Tomada aqui, ela cobre o accept, o reparo, a conferência e o -Release de uma vez. Aparelho ocupado: devolve a trava
    # do projeto e diz qual projeto o usa.
    $key = Get-DeviceKey $Root $Target
    if ($key) {
        $dp = Get-DeviceLockPath $key
        $dk = [ordered]@{ device = $key; target = $Target; owner = $Owner; pid = $PID; created = $lk.created; desde = $lk.desde; root = $Root }
        if ($Dir) { $dk.dirAbs = $Dir }
        $hd = Enter-LockFile $dp ((New-Object System.Text.UTF8Encoding($false)).GetBytes(($dk | ConvertTo-Json -Compress))) $StaleHours { param($x) if ($x.PSObject.Properties['dirAbs']) { [string]$x.dirAbs } else { '' } }
        if ($hd) {
            Exit-TargetLock $Root
            if (-not $hd.Busy) { return "a trava do aparelho $key foi tomada por outro executor ao mesmo tempo — rode de novo" }
            $l = $hd.Lock; $pu = $hd.Pulse; $other = [string]$l.root
            $same = $other -and ($other.TrimEnd('\', '/') -ieq ([string]$Root).TrimEnd('\', '/'))
            return "o aparelho $key está em uso por $(if ($same) { 'este mesmo projeto' } else { "OUTRO projeto ($other)" }) — '$([string]$l.owner)' (PID $([int]$l.pid), desde $([string]$l.desde); $($pu.Text)): " + $(if ($same) { 'espere terminar (quem usa o alvo: target.ps1 -Target ' + $Target + ' -Who)' } elseif ($pu.Stalled) { "o processo parece travado — quem o encerra é a sessão daquele projeto (target.ps1 -Target $Target -Kill na pasta dele); decisão do stakeholder" } else { "espere terminar — dois projetos no mesmo aparelho quebram os dois. Para rodar os dois ao mesmo tempo, cada projeto declara o seu aparelho em guards.json → targets.android.serial" })
        }
    }
    # v3.64.0 (item 7 B): o accept, o reparo e o boot do emulador são trabalho pesado — com outro projeto segurando a máquina,
    # a trava do alvo volta e a mensagem diz quem a usa (o portão espera, como o alvo em uso).
    if ($Target -eq 'android') {
        # v3.64.0 (decisão D8): um servidor do adb por máquina e uma porta de emulador por projeto. Dois servidores se conectam
        # aos mesmos emuladores e um derruba o outro ("adb protocol fault", piloto, 18/11 19:22) — o plugin para com a causa e
        # não desliga nada de outro projeto. A porta declarada é par, entre 5554 e 5584 (o par console/adb do emulador).
        $adbP = @(Get-AdbServerPorts)
        if ($adbP.Count -gt 1) { Exit-TargetLock $Root; return "dois servidores do adb na máquina (portas $($adbP -join ', ')): eles disputam os mesmos emuladores e um derruba o outro. Um servidor só por máquina (o plugin não fixa a porta dele: vale o único que estiver no ar); cada projeto fala com o seu emulador pelo serial (guards.json → targets.android.serial). O plugin não desliga o de outro projeto: quem o subiu o encerra" }
        $serialBad = Test-AndroidSerialPort $Root
        if ($serialBad) { Exit-TargetLock $Root; return $serialBad }
        $hv = Enter-HeavyLock $Root $Owner
        if ($hv) { Exit-TargetLock $Root; return $hv }
    }
    return $null
}
# v3.64.0 (D8): as portas dos servidores do adb vivos na máquina (o processo "adb … server", -P <porta> ou a padrão 5037).
# TEAM_TEST_ADB_PORTS ("5037,5557") troca a leitura nos testes; sem processo legível, @().
function Get-AdbServerPorts {
    if ($null -ne $env:TEAM_TEST_ADB_PORTS) { return @(([string]$env:TEAM_TEST_ADB_PORTS -split '[,; ]+') | Where-Object { $_ } | ForEach-Object { [int]$_ }) }
    try { $ps = @(Get-CimInstance Win32_Process -Filter "Name='adb.exe'" -ErrorAction Stop) } catch { return @() }
    return @($ps | Where-Object { [string]$_.CommandLine -match '(?i)\bserver\b' } | ForEach-Object { Get-AdbServerPortFromCommandLine ([string]$_.CommandLine) } | Select-Object -Unique)
}
# v3.65.0: a porta de um servidor do adb pela linha de comando. O adb atual sobe o servidor como "adb -L tcp:<porta> fork-server
# server" (ANDROID_ADB_SERVER_PORT vira -L tcp:<porta>); só o -P era lido, e todo servidor contava como 5037 — dois servidores
# (5037 e 5038) viravam um só e a D8 não recusava. Sem porta na linha, a padrão 5037.
function Get-AdbServerPortFromCommandLine([string]$CommandLine) {
    if ($CommandLine -match '(?i)-L\s+tcp:(?:[^:\s]+:)?(\d+)') { return [int]$Matches[1] }
    if ($CommandLine -match '(?i)-P\s*(\d+)') { return [int]$Matches[1] }
    return 5037
}
# v3.64.0 (D8): a porta do emulador declarada (targets.android.serial = emulator-<porta>) é par e fica entre 5554 e 5584; fora
# disso, a recusa traz a proposta da primeira par livre que nenhuma trava de aparelho usa (não grava: o /team update grava com o
# aval). Sem serial declarado não há o que conferir aqui ($null): com mais de um aparelho no adb, o Initialize-Android já recusa e
# pede o serial (v3.65.0, A2-03: o comentário prometia a proposta também sem declaração).
# Devolve a recusa, ou $null. Serial de aparelho físico (sem "emulator-") não é conferido.
function Test-AndroidSerialPort([string]$Root) {
    $tc = Get-TargetsConfig $Root; $a = if ($tc -and $tc.PSObject.Properties['android']) { $tc.android } else { $null }
    if (-not ($a -and $a.PSObject.Properties['serial'] -and $a.serial)) { return $null }
    $s = ([string]$a.serial).Trim()
    if ($s -notmatch '^emulator-(\d+)$') { return $null }
    $port = [int]$Matches[1]
    if ($port -lt 5554 -or $port -gt 5584 -or ($port % 2)) { return "guards.json → targets.android.serial = ${s}: a porta do emulador é par e fica entre 5554 e 5584 (o par console/adb). Proposta: $(Get-FreeEmulatorSerial $Root) — o /team update grava com o aval do stakeholder" }
    return $null
}
function Get-FreeEmulatorSerial([string]$Root) {
    $used = @()
    $dd = Get-DeviceLockDir
    if (Test-Path -LiteralPath $dd) { foreach ($f in @(Get-ChildItem -LiteralPath $dd -File -Filter 'emulator-*.json' -ErrorAction SilentlyContinue)) { if ($f.BaseName -match '^emulator-(\d+)$') { $used += [int]$Matches[1] } } }
    for ($p = 5554; $p -le 5584; $p += 2) { if ($used -notcontains $p) { return "emulator-$p" } }
    return 'nenhuma porta par livre entre 5554 e 5584'
}
# v3.63.1/v3.63.2: toma um arquivo de trava de forma ATÔMICA (CreateNew) — antes, "existe? não → grava" deixava dois accepts que
# partiam juntos entrarem os dois. A trava de um dono VIVO que ainda anda nunca é tomada (antes, passadas 3 h ela valia como
# abandonada, e um aceite de 49 cenários passa disso); dono morto, PID reaproveitado, trava ilegível, ou parada há mais de
# $StaleHours h sem sinal de vida = trava velha, assumida. $DirOf: a pasta que o dono grava (o sinal de vida lê o progress.json
# dela). $null = tomou · @{ Busy = $true; Lock; Pulse } = ocupada · @{ Busy = $false } = disputa sem vencedor.
function Enter-LockFile([string]$Path, [byte[]]$Bytes, [int]$StaleHours, [scriptblock]$DirOf) {
    New-Item -ItemType Directory -Force (Split-Path $Path) | Out-Null
    for ($try = 0; $try -lt 4; $try++) {
        try {
            $fs = [System.IO.File]::Open($Path, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
            try { $fs.Write($Bytes, 0, $Bytes.Length) } finally { $fs.Dispose() }
            return $null
        } catch [System.IO.IOException] { }
        $l = $null; try { $l = Read-Text $Path | ConvertFrom-Json } catch { }
        if (-not $l) {
            # Recém-criada por outro executor e ainda sem o conteúdo: espera um instante antes de achá-la ilegível.
            $fresh = try { ((Get-Date) - (Get-Item -LiteralPath $Path).LastWriteTime).TotalSeconds -lt 10 } catch { $false }
            if ($fresh -and $try -lt 3) { Start-Sleep -Milliseconds 400; continue }
        } elseif ([int]$l.pid -eq $PID) {
            [System.IO.File]::WriteAllBytes($Path, $Bytes); return $null
        } elseif (Test-TargetLockHolderAlive $l) {
            # v3.53.5: com o sinal de vida; v3.63.1 (pedido 6): lendo também a pasta do dono.
            $pu = Get-WaitPulse ([int]$l.pid) ([string]$l.desde) (& $DirOf $l)
            $age = try { ((Get-Date) - [datetime]::ParseExact([string]$l.desde, 'yyyy-MM-dd HH:mm:ss', $null)).TotalHours } catch { 999 }
            if (-not ($pu.Stalled -and $age -ge $StaleHours)) { return [pscustomobject]@{ Busy = $true; Lock = $l; Pulse = $pu } }
        }
        Remove-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    }
    return [pscustomobject]@{ Busy = $false }
}
# v3.63.2: onde ficam as travas de aparelho — uma pasta da máquina, comum a todos os projetos (TEAM_DEVICE_LOCK_DIR troca: testes).
function Get-DeviceLockDir {
    if ($env:TEAM_DEVICE_LOCK_DIR) { return $env:TEAM_DEVICE_LOCK_DIR }
    $base = if ($env:LOCALAPPDATA) { $env:LOCALAPPDATA } else { [System.IO.Path]::GetTempPath() }
    return (Join-Path $base 'team-plugin\device-locks')
}
function Get-DeviceLockPath([string]$Key) { return (Join-Path (Get-DeviceLockDir) ((($Key -replace '[^\w.\-]', '_')) + '.json')) }
# v3.63.2: o aparelho do alvo — o que dois projetos disputariam. android: guards.json → targets.android.serial; sem ele, o único
# aparelho conectado (adb devices); sem aparelho único, "android" (o aparelho padrão da máquina — os projetos sem serial
# disputam o mesmo). web: nenhum (cada projeto sobe o seu site). TEAM_TEST_DEVICE_SERIAL troca a leitura do adb (testes).
function Get-DeviceKey([string]$Root, [string]$Target) {
    if ($Target -ne 'android') { return '' }
    $tc = Get-TargetsConfig $Root
    $a = if ($tc -and $tc.PSObject.Properties['android']) { $tc.android } else { $null }
    if ($a -and $a.PSObject.Properties['serial'] -and $a.serial) { return ([string]$a.serial).Trim() }
    if ($env:TEAM_TEST_DEVICE_SERIAL) { return $env:TEAM_TEST_DEVICE_SERIAL }
    $sdk = if ($env:ANDROID_HOME) { $env:ANDROID_HOME } elseif ($env:ANDROID_SDK_ROOT) { $env:ANDROID_SDK_ROOT } elseif ($env:LOCALAPPDATA) { Join-Path $env:LOCALAPPDATA 'Android\Sdk' } else { '' }
    $adb = if ($sdk -and (Test-Path -LiteralPath (Join-Path $sdk 'platform-tools\adb.exe'))) { Join-Path $sdk 'platform-tools\adb.exe' } else { $c = Get-Command adb -ErrorAction SilentlyContinue; if ($c) { $c.Source } else { '' } }
    if ($adb) {
        try {
            $r = Invoke-Bounded $Root "& '$($adb -replace "'", "''")' devices" 15
            $on = @(([string]$r.out -split "`r?`n") | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^(\S+)\s+device$' } | ForEach-Object { ($_ -split '\s+')[0] })
            if ($on.Count -eq 1) { return $on[0] }
        } catch { }
    }
    return 'android'
}
# v3.63.2: quem segura a trava do aparelho deste projeto agora (o dono vivo), ou $null.
function Get-DeviceLockHolder([string]$Root, [string]$Target) {
    $key = Get-DeviceKey $Root $Target
    if (-not $key) { return $null }
    $dp = Get-DeviceLockPath $key
    if (-not (Test-Path -LiteralPath $dp)) { return $null }
    $l = $null; try { $l = Read-Text $dp | ConvertFrom-Json } catch { }
    if (-not $l -or [int]$l.pid -eq $PID -or -not (Test-TargetLockHolderAlive $l)) { return $null }
    $other = [string]$l.root
    return [pscustomobject]@{ Key = $key; Lock = $l; Path = $dp; Foreign = -not ($other -and ($other.TrimEnd('\', '/') -ieq ([string]$Root).TrimEnd('\', '/'))) }
}
# v3.63.1: o dono da trava está vivo de verdade — o processo existe e, quando a trava guarda a hora de criação, ela bate (PID
# reaproveitado pelo Windows não conta como vivo).
function Test-TargetLockHolderAlive($Lock) {
    if (-not $Lock -or [int]$Lock.pid -le 0) { return $false }
    if (-not (Get-Process -Id ([int]$Lock.pid) -ErrorAction SilentlyContinue)) { return $false }
    if ($Lock.PSObject.Properties['created'] -and $Lock.created) { $c = Get-ProcessCreated ([int]$Lock.pid); if ($c -and $c -ne [string]$Lock.created) { return $false } }
    return $true
}
# v3.63.1: a pasta que o dono da trava grava (o accept: accept/<seg>/<ID>/, onde fica o progress.json) — '' sem ela.
function Get-TargetLockDir([string]$Root, $Lock) {
    if (-not $Lock) { return '' }
    if ($Lock.PSObject.Properties['dir'] -and $Lock.dir) { return (Join-Path $Root ([string]$Lock.dir)) }
    if ([string]$Lock.owner -match '^accept (\S+)$') { return ((Get-VerifyDir $Root $Matches[1]) -replace '([\\/]\.team-project[\\/])verify([\\/])', '$1accept$2') }
    return ''
}
# v3.63.1 (sprint 6 do projeto piloto, pedidos 5 e 7): quem segura o alvo agora, com o sinal de vida. $null = livre (sem trava,
# dono morto ou a própria sessão). Plugin = o dono é um script do plugin (accept, target.ps1) que o target.ps1 -Kill encerra.
function Get-TargetBusy([string]$Root) {
    $lp = Join-Path $Root '.team-project/.target-lock'
    $l = $null; if (Test-Path -LiteralPath $lp) { try { $l = Read-Text $lp | ConvertFrom-Json } catch { } }
    if ($l -and [int]$l.pid -ne $PID -and (Get-Process -Id ([int]$l.pid) -ErrorAction SilentlyContinue)) {
        $own = Test-TargetLockOwnerProcess $l
        $pu = Get-WaitPulse ([int]$l.pid) ([string]$l.desde) (Get-TargetLockDir $Root $l)
        return [pscustomobject]@{ Owner = [string]$l.owner; Target = [string]$l.target; Pid = [int]$l.pid; Desde = [string]$l.desde; Pulse = $pu; Plugin = $own; Foreign = $false; Project = [string]$Root
            Text = "'$([string]$l.owner)' (PID $([int]$l.pid), desde $([string]$l.desde)) — $($pu.Text)" }
    }
    # v3.63.2: a trava deste projeto está livre, mas o APARELHO pode estar com outro projeto da máquina.
    $tc = Get-TargetsConfig $Root
    if ($tc -and $tc.PSObject.Properties['android']) {
        $dh = Get-DeviceLockHolder $Root 'android'
        if ($dh) {
            $d = $dh.Lock
            $pu = Get-WaitPulse ([int]$d.pid) ([string]$d.desde) $(if ($d.PSObject.Properties['dirAbs']) { [string]$d.dirAbs } else { '' })
            return [pscustomobject]@{ Owner = [string]$d.owner; Target = 'android'; Pid = [int]$d.pid; Desde = [string]$d.desde; Pulse = $pu; Plugin = (Test-TargetLockOwnerProcess $d); Foreign = $dh.Foreign; Project = [string]$d.root
                Text = "'$([string]$d.owner)' $(if ($dh.Foreign) { "do OUTRO projeto $([string]$d.root) " })no aparelho $($dh.Key) (PID $([int]$d.pid), desde $([string]$d.desde)) — $($pu.Text)" }
        }
    }
    # v3.64.0 (item 7 B): a trava de trabalho pesado com OUTRO projeto vivo — o portão espera (Heavy), como o alvo em uso.
    $hp = Get-HeavyLockPath
    if (Test-Path -LiteralPath $hp) {
        $hl = $null; try { $hl = Read-Text $hp | ConvertFrom-Json } catch { }
        if ($hl -and ([string]$hl.root).TrimEnd('\', '/') -ine ([string]$Root).TrimEnd('\', '/') -and (Test-TargetLockHolderAlive $hl)) {
            $pu = Get-WaitPulse ([int]$hl.pid) ([string]$hl.desde) ''
            return [pscustomobject]@{ Owner = [string]$hl.owner; Target = 'máquina'; Pid = [int]$hl.pid; Desde = [string]$hl.desde; Pulse = $pu; Plugin = (Test-TargetLockOwnerProcess $hl); Foreign = $true; Heavy = $true; Project = [string]$hl.root
                Text = "'$([string]$hl.owner)' do OUTRO projeto $([string]$hl.root), trabalho pesado na máquina (PID $([int]$hl.pid), desde $([string]$hl.desde)) — $($pu.Text)" }
        }
    }
    return $null
}
# ---------- v3.64.0 (item 7 B, decisão D6) · a trava de trabalho pesado, comum aos projetos da máquina ----------
# A suíte do verify full, o accept e o boot/reparo do emulador de projetos DIFERENTES não rodam juntos: no sprint 6 do piloto
# (18/11, 19:21) outro projeto subiu um emulador com GPU por software no meio da suíte do Karma, a suíte ficou 2,6× mais lenta
# e o navegador caiu. Dentro do mesmo projeto a trava é reentrante (o accept que chama o reparo não se bloqueia). Mesma pasta
# das travas de aparelho (v3.63.2) — o Exit-TargetLock já solta o que o processo tomou.
function Get-HeavyLockPath { return (Join-Path (Get-DeviceLockDir) 'machine-heavy.json') }
function Enter-HeavyLock([string]$Root, [string]$Owner, [int]$HolderPid = $PID, [int]$StaleHours = 3) {
    $lk = [ordered]@{ kind = 'heavy'; owner = $Owner; pid = $HolderPid; created = (Get-ProcessCreated $HolderPid); desde = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); root = $Root }
    $h = Enter-LockFile (Get-HeavyLockPath) ((New-Object System.Text.UTF8Encoding($false)).GetBytes(($lk | ConvertTo-Json -Compress))) $StaleHours { param($x) '' }
    if (-not $h) { return $null }
    if (-not $h.Busy) { return 'a trava de trabalho pesado da máquina foi tomada por outro processo ao mesmo tempo — rode de novo' }
    $l = $h.Lock
    if (([string]$l.root).TrimEnd('\', '/') -ieq ([string]$Root).TrimEnd('\', '/')) { return $null }   # mesmo projeto: reentrante
    return "a máquina está em uso por OUTRO projeto ($([string]$l.root)) — '$([string]$l.owner)' (PID $([int]$l.pid), desde $([string]$l.desde); $($h.Pulse.Text)): trabalho pesado de projetos diferentes roda um por vez (suíte, aceite, boot de emulador)"
}
function Exit-HeavyLock([int]$HolderPid = $PID) {
    $p = Get-HeavyLockPath
    if (Test-Path -LiteralPath $p) { try { $l = Read-Text $p | ConvertFrom-Json; if ([int]$l.pid -eq $HolderPid) { Remove-Item -LiteralPath $p -Force -ErrorAction SilentlyContinue } } catch { } }
}
# Espera a trava até $WaitMin (guards.json → machine.heavyWaitMin, padrão 30), reconferindo a cada 30 s. $null = tomada.
function Wait-HeavyLock([string]$Root, [string]$Owner, [double]$WaitMin = -1, [int]$HolderPid = $PID) {
    if ($WaitMin -lt 0) {
        $WaitMin = 30
        $gp = Join-Path $Root '.team-project/guards.json'
        if (Test-Path -LiteralPath $gp) { try { $mj = (Read-Text $gp | ConvertFrom-Json).machine; if ($mj -and $null -ne $mj.heavyWaitMin) { $WaitMin = [double]$mj.heavyWaitMin } } catch { } }
    }
    $poll = if ($env:TEAM_TEST_HEAVY_POLL_S) { [int]$env:TEAM_TEST_HEAVY_POLL_S } else { 30 }
    $end = (Get-Date).AddMinutes($WaitMin); $said = $false
    while ($true) {
        $b = Enter-HeavyLock $Root $Owner $HolderPid
        if (-not $b) { return $null }
        if ((Get-Date) -ge $end) { return $b }
        if (-not $said) { [Console]::Out.WriteLine("esperando a máquina (até $WaitMin min): $b"); $said = $true }
        Start-Sleep -Seconds $poll
    }
}
# v3.64.0 (item 7 A): o retrato da máquina na hora de uma queda — CPU (duas amostras), emuladores com o AVD, servidores do adb
# com a porta e as travas vivas de OUTROS projetos. TEAM_TEST_MACHINE_LOAD (JSON) troca a medida nos testes.
function Get-MachineLoad([string]$Root) {
    if ($env:TEAM_TEST_MACHINE_LOAD) { try { $t = $env:TEAM_TEST_MACHINE_LOAD | ConvertFrom-Json; return [pscustomobject]@{ Cpu = [int]$t.cpu; Emulators = @($t.emulators); AdbPorts = @($t.adbPorts); Others = @($t.others) } } catch { } }
    $cpu = -1
    try { $a = @(1..2 | ForEach-Object { if ($_ -gt 1) { Start-Sleep -Milliseconds 800 }; (Get-CimInstance Win32_Processor -ErrorAction Stop | Measure-Object LoadPercentage -Average).Average }); $cpu = [int](($a | Measure-Object -Average).Average) } catch { }
    $procs = @(); try { $procs = @(Get-CimInstance Win32_Process -ErrorAction Stop | Select-Object Name, ProcessId, CommandLine) } catch { }
    $emus = @($procs | Where-Object { $_.Name -match '^(?i)(qemu-system|emulator)' -and $_.CommandLine -match '-avd\s+(\S+)' } | ForEach-Object { if ($_.CommandLine -match '-avd\s+"?([^\s"]+)') { $Matches[1] } } | Select-Object -Unique)
    $adb = @($procs | Where-Object { $_.Name -match '^(?i)adb(\.exe)?$' -and $_.CommandLine -match '(?i)\bserver\b' } | ForEach-Object { if ($_.CommandLine -match '(?i)-P\s*(\d+)') { [int]$Matches[1] } else { 5037 } } | Select-Object -Unique)
    $others = @()
    $dd = Get-DeviceLockDir
    if (Test-Path -LiteralPath $dd) {
        foreach ($f in @(Get-ChildItem -LiteralPath $dd -File -Filter '*.json' -ErrorAction SilentlyContinue)) {
            try { $l = Read-Text $f.FullName | ConvertFrom-Json } catch { continue }
            if (-not $l -or -not $l.root -or ([string]$l.root).TrimEnd('\', '/') -ieq ([string]$Root).TrimEnd('\', '/')) { continue }
            if (Test-TargetLockHolderAlive $l) { $others += "$([string]$l.owner) de $([string]$l.root)" }
        }
    }
    return [pscustomobject]@{ Cpu = $cpu; Emulators = $emus; AdbPorts = $adb; Others = $others }
}
# O processo da trava é mesmo o script do plugin que a tomou: a hora de criação bate (quando gravada) e a linha de comando é
# do accept.ps1 ou do target.ps1. PID reaproveitado pelo Windows ou processo de fora → $false (não é tocado).
function Test-TargetLockOwnerProcess($Lock) {
    if (-not $Lock -or [int]$Lock.pid -le 0) { return $false }
    $c = $null; try { $c = Get-CimInstance Win32_Process -Filter "ProcessId=$([int]$Lock.pid)" -ErrorAction Stop } catch { }
    if (-not $c) { return $false }
    if ($Lock.PSObject.Properties['created'] -and $Lock.created -and $c.CreationDate -and $c.CreationDate.ToString('o') -ne [string]$Lock.created) { return $false }
    return ((Get-ProcessCommandText ([string]$c.CommandLine)) -match '(?i)[\\/](accept|target)\.ps1\b')
}
# v3.63.1: a linha de comando legível — o PowerShell com -EncodedCommand (a rodada desacoplada, o Invoke-ProjectCommand) leva o
# comando em Base64; aqui ele volta a texto, para reconhecer o accept que roda dentro do invólucro.
function Get-ProcessCommandText([string]$CommandLine) {
    $m = [regex]::Match([string]$CommandLine, '(?i)-(?:EncodedCommand|enc|e)\s+([A-Za-z0-9+/=]{8,})')
    if (-not $m.Success) { return [string]$CommandLine }
    try { return ([string]$CommandLine) + ' ' + [System.Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($m.Groups[1].Value)) } catch { return [string]$CommandLine }
}
# v3.63.1 (sprint 6 do projeto piloto, 18/11): QUEM USA O ALVO, sem adivinhar por lista de processos. A sessão e o plugin contaram
# "três accepts no aparelho" pelos processos cuja linha de comando cita accept.ps1 — e eram um accept, o invólucro da rodada
# desacoplada e cópias do detach.ps1 que só ACOMPANHAM a mesma rodada (não tocam o aparelho); a sessão encerrou dois deles
# achando que eram duplicados. Aqui cada processo ganha o papel: accept (roda cenários no aparelho) · invólucro (a rodada
# desacoplada que espera o accept) · acompanhando (detach.ps1 que reencontrou a rodada). Duplicado = accept vivo que NÃO é o
# dono da trava. Só leitura. @{ Lock; Accepts; Wrappers; Watchers; Duplicates }.
function Get-TargetUsers([string]$Root) {
    $lp = Join-Path $Root '.team-project/.target-lock'
    $l = $null; if (Test-Path -LiteralPath $lp) { try { $l = Read-Text $lp | ConvertFrom-Json } catch { } }
    $lockPid = if ($l -and (Test-TargetLockHolderAlive $l)) { [int]$l.pid } else { 0 }
    $all = @(); try { $all = @(Get-CimInstance Win32_Process -ErrorAction Stop | Where-Object { $_.Name -match '^(?i)(powershell|pwsh)(\.exe)?$' -and $_.ProcessId -ne $PID }) } catch { }
    $accepts = @(); $wrappers = @(); $watchers = @()
    foreach ($p in $all) {
        $raw = [string]$p.CommandLine; $txt = Get-ProcessCommandText $raw
        $row = [pscustomobject]@{ Pid = [int]$p.ProcessId; Parent = [int]$p.ParentProcessId; Since = $(if ($p.CreationDate) { $p.CreationDate.ToString('yyyy-MM-dd HH:mm:ss') } else { '' }); Text = $txt; Task = ''; Dir = '' }
        $tm = [regex]::Match($txt, '(?i)accept\.ps1\b[^;\r\n]*?-Task\s+(\S+)'); if ($tm.Success) { $row.Task = $tm.Groups[1].Value.Trim('"', "'") }
        $dm = [regex]::Match($raw, '(?i)-Dir\s+"?([^"]+?)"?(\s+-|$)'); if ($dm.Success) { $row.Dir = $dm.Groups[1].Value }
        if ($raw -match '(?i)[\\/]detach\.ps1\b') { if ($txt -match '(?i)accept\.ps1') { $watchers += $row }; continue }
        if ($raw -match '(?i)[\\/]detached-run\.ps1\b') { $wrappers += $row; continue }
        if ($txt -notmatch '(?i)[\\/]accept\.ps1\b' -or $txt -match '(?i)-ParseOnly\b') { continue }
        # O host codificado cujo filho é o próprio accept (-File accept.ps1) é invólucro; o accept é o processo mais fundo.
        if ($raw -notmatch '(?i)[\\/]accept\.ps1\b') { $wrappers += $row; continue }
        $accepts += $row
    }
    # O host codificado que roda o accept direto (& accept.ps1, sem um filho -File accept.ps1) é ele mesmo o accept.
    foreach ($w in @($wrappers | Where-Object { $_.Text -match '(?i)[\\/]accept\.ps1\b' -and $_.Text -notmatch '(?i)[\\/]detached-run\.ps1\b' })) {
        if (-not @($accepts | Where-Object { $_.Parent -eq $w.Pid }).Count) { $accepts += $w; $wrappers = @($wrappers | Where-Object { $_.Pid -ne $w.Pid }) }
    }
    # Invólucro e observador de OUTRO projeto (a pasta da rodada fora desta raiz) não são deste alvo. O accept fica sempre: o
    # aparelho é da máquina, e o accept de outro projeto no mesmo emulador também quebra este.
    $rootN = ([string]$Root).TrimEnd('\', '/').Replace('/', '\')
    $under = { param([string]$p) $p -and $p.Replace('/', '\').TrimEnd('\').StartsWith($rootN, [StringComparison]::OrdinalIgnoreCase) }
    $mine = { param($r) -not $r.Dir -or (& $under $r.Dir) }
    $wrappers = @($wrappers | Where-Object { & $mine $_ }); $watchers = @($watchers | Where-Object { & $mine $_ })
    # De que projeto é cada accept: o -Root da linha de comando, a pasta da rodada que o lançou (-Dir de um ancestral) ou o
    # progress.json deste projeto com o PID dele. Sem nenhum dos três, "não identificado" — listado, nunca encerrado por aqui.
    $byPid = @{}; foreach ($p in $all) { $byPid[[int]$p.ProcessId] = $p }
    $progPids = @(); $ad = Join-Path $Root '.team-project/accept'
    if (Test-Path -LiteralPath $ad) { foreach ($f in @(Get-ChildItem -LiteralPath $ad -Recurse -File -Filter 'progress.json' -ErrorAction SilentlyContinue)) { try { $progPids += [int](Read-Text $f.FullName | ConvertFrom-Json).pid } catch { } } }
    foreach ($a in $accepts) {
        $own = $null
        if ($a.Pid -eq $lockPid) { $own = $true }
        else {
            $rm = [regex]::Match($a.Text, '(?i)-Root\s+(?:"([^"]+)"|''([^'']+)''|(\S+))')
            if ($rm.Success) { $own = & $under ("$($rm.Groups[1].Value)$($rm.Groups[2].Value)$($rm.Groups[3].Value)") }
            else {
                $cur = $a.Parent
                for ($i = 0; $i -lt 5 -and $null -eq $own -and $byPid.ContainsKey($cur); $i++) {
                    $dm = [regex]::Match([string]$byPid[$cur].CommandLine, '(?i)-Dir\s+"?([^"]+?)"?(\s+-|$)')
                    if ($dm.Success) { $own = & $under $dm.Groups[1].Value }
                    $cur = [int]$byPid[$cur].ParentProcessId
                }
                if ($null -eq $own -and $progPids -contains $a.Pid) { $own = $true }
            }
        }
        $a | Add-Member -NotePropertyName Mine -NotePropertyValue $own -Force
    }
    # O invólucro sem pasta (o host codificado) é do projeto do accept que roda embaixo dele.
    $wrappers = @($wrappers | Where-Object { $w = $_; $w.Dir -or @($accepts | Where-Object { $_.Parent -eq $w.Pid -and $_.Mine -eq $true }).Count })
    $dups = @($accepts | Where-Object { $lockPid -and $_.Pid -ne $lockPid -and $_.Mine -eq $true })
    return [pscustomobject]@{ Lock = $l; LockPid = $lockPid; Accepts = $accepts; Wrappers = $wrappers; Watchers = $watchers; Duplicates = $dups }
}
# v3.63.1: encerra SÓ os duplicados — o accept vivo que não é o dono da trava (com a árvore dele e o invólucro da rodada dele).
# O dono da trava e quem só acompanha ficam. Devolve as linhas do que fez.
function Stop-TargetDuplicates([string]$Root) {
    $u = Get-TargetUsers $Root
    $out = @()
    if (-not $u.LockPid) { return @('nenhum dono vivo da trava — sem referência para dizer qual é o duplicado; nada encerrado (veja target.ps1 -Who)') }
    if (-not $u.Duplicates.Count) { return @("nenhum duplicado: só o dono da trava (PID $($u.LockPid)) roda cenários no aparelho") }
    foreach ($d in $u.Duplicates) {
        $chain = @($u.Wrappers | Where-Object { $_.Pid -eq $d.Parent }); $wrap = @($chain | ForEach-Object { $w = $_; @($u.Wrappers | Where-Object { $_.Pid -eq $w.Parent }) + $w })
        $n = Stop-ProcessTree $d.Pid
        foreach ($w in $wrap) { if ($w) { Stop-Process -Id $w.Pid -Force -ErrorAction SilentlyContinue } }
        $out += "duplicado encerrado: accept $(if ($d.Task) { $d.Task } else { '?' }) PID $($d.Pid) (desde $($d.Since)) e $([int]$n) processo(s) da árvore dele$(if ($wrap.Count) { "; invólucro(s) $((@($wrap | ForEach-Object { $_.Pid })) -join ', ')" })"
    }
    return $out
}
# v3.63.1 (pedido 5): encerra o dono da trava — só o accept.ps1 ou o target.ps1 do plugin, reconhecido pela hora de criação e
# pela linha de comando — com a árvore dele (os adb, node e executores do projeto que ele disparou), e apaga a trava.
# @{ Stopped; Text } (Stopped $false = nada a encerrar ou processo de fora, que não é tocado).
function Stop-TargetLockHolder([string]$Root) {
    $lp = Join-Path $Root '.team-project/.target-lock'
    if (-not (Test-Path -LiteralPath $lp)) { return [pscustomobject]@{ Stopped = $false; Text = '' } }
    $l = $null; try { $l = Read-Text $lp | ConvertFrom-Json } catch { }
    if (-not $l -or [int]$l.pid -eq $PID) { return [pscustomobject]@{ Stopped = $false; Text = '' } }
    if (-not (Get-Process -Id ([int]$l.pid) -ErrorAction SilentlyContinue)) {
        Remove-Item -LiteralPath $lp -Force -ErrorAction SilentlyContinue
        return [pscustomobject]@{ Stopped = $false; Text = "trava de '$([string]$l.owner)' (PID $([int]$l.pid)) sem processo vivo — removida" }
    }
    if (-not (Test-TargetLockOwnerProcess $l)) { return [pscustomobject]@{ Stopped = $false; Text = "a trava é de '$([string]$l.owner)' (PID $([int]$l.pid)), que não é um script do plugin reconhecível (hora de criação ou linha de comando não batem) — não tocado" } }
    $k = Stop-ProcessTree ([int]$l.pid)
    Remove-Item -LiteralPath $lp -Force -ErrorAction SilentlyContinue
    return [pscustomobject]@{ Stopped = $true; Text = "encerrado o dono da trava '$([string]$l.owner)' (PID $([int]$l.pid), desde $([string]$l.desde)) e $([int]$k) processo(s) da árvore dele; trava removida" }
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
            $pStart = if ($p) { try { $p.StartTime } catch { $null } } else { $null }   # v3.62.2: processo saindo = StartTime vazio
            if ($p -and (-not $l.started -or ($pStart -and $pStart.ToString('o') -eq [string]$l.started))) {
                $pu = Get-WaitPulse ([int]$l.pid) ([string]$l.at) $vd
                # v3.62.2: rodada desacoplada — ela não depende de nenhum agente vivo; o MESMO verify de um dev novo a reencontra.
                $jb = Get-DetachedJob (Join-Path $vd 'job')
                $det = [bool]($jb -and $jb.State -eq 'running')
                return [pscustomobject]@{ Text = "verify $([string]$l.mode)$(if ($det) { ' em processo próprio' }) (pid $([int]$l.pid), desde $([string]$l.at)) — $($pu.Text)"; Pulse = $pu; Kill = "verify.ps1 -Task $Id -Kill"; Detached = $det; Mode = [string]$l.mode }
            }
        }
    }
    # v3.65.8 (garden S6, 19:18 → 19:32): a medição de qualidade (quality.lock na pasta dela, processo vivo) — sem a trava, o
    # portão mandava medir de novo por cima da que rodava, e a sonda dizia "terminou".
    $ql = Get-QualityLock $Root $Id
    if ($ql) {
        $pu = Get-WaitPulse ([int]$ql.pid) ([string]$ql.at) $ql.Dir
        return [pscustomobject]@{ Text = "quality (pid $([int]$ql.pid), desde $([string]$ql.at)) — $($pu.Text)"; Pulse = $pu; Kill = "quality.ps1 -Id $Id -Kill"; Mode = 'quality' }
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
                return [pscustomobject]@{ Text = "$what (pid $([int]$t.pid), desde $([string]$t.desde)) — $($pu.Text)$prog"; Pulse = $pu; NoProgress = $noProg; Kill = "target.ps1 -Target $([string]$t.target) -Kill" }
            }
        }
    }
    return $null
}
function Get-TaskBusy([string]$Root, [string]$Id) { $w = Get-TaskWait $Root $Id; if ($w) { return $w.Text }; return $null }

# v3.65.8: a trava da medição de qualidade do <Id> (quality/<seg>/<Id>/quality.lock), só quando o processo dela vive (mesmo
# PID e mesma hora de criação; o processo saindo tem StartTime vazio). @{ pid; started; at; Dir; Path } ou $null.
function Get-QualityDir([string]$Root, [string]$Id) { return ((Get-VerifyDir $Root $Id) -replace '[\\/]verify[\\/]', '/quality/') }
function Get-QualityLock([string]$Root, [string]$Id) {
    $d = Get-QualityDir $Root $Id; $lp = Join-Path $d 'quality.lock'
    if (-not (Test-Path -LiteralPath $lp)) { return $null }
    $l = $null; try { $l = Read-Text $lp | ConvertFrom-Json } catch { }
    if (-not $l -or -not $l.pid -or [int]$l.pid -eq $PID) { return $null }
    $p = Get-Process -Id ([int]$l.pid) -ErrorAction SilentlyContinue
    $pStart = if ($p) { try { $p.StartTime } catch { $null } } else { $null }
    if (-not $p -or ($l.started -and -not ($pStart -and $pStart.ToString('o') -eq [string]$l.started))) { return $null }
    return [pscustomobject]@{ pid = [int]$l.pid; started = [string]$l.started; at = [string]$l.at; Dir = $d; Path = $lp }
}

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
        $lw = @(Get-ChildItem -LiteralPath $Dir -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin 'verify.lock', 'quality.lock' } | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
        if ($lw.Count) { $wmin = [Math]::Max(0, ($now - $lw[0].LastWriteTime).TotalMinutes) }
    }
    # v3.58.1: a CPU acima é a dos processos VIVOS da árvore — não é cumulativa: o filho que termina leva a CPU dele junto
    # (medido: 6 filhos de 3 s de CPU cada, a soma oscilou 0,7 → 3,5 → 0,9 → 4,0 s e nunca passou de 4 s dos ~18 s gastos).
    # Um build feito de filhos curtos (node, gradle, tsc) parecia "sem CPU" e caía em POSSÍVEL TRAVAMENTO falso. Sinal de
    # vida sem estado (a sonda continua só de leitura): descendente criado há menos de 10 min = a árvore anda. O travamento
    # real do garden (um adb emu kill parado 81 min) não tem filho novo e segue acusado.
    $kidsT = @($tree | Where-Object { $_.ProcessId -ne $ProcId -and $_.CreationDate -and $_.Name -notmatch '^(?i)conhost\.exe$' })
    $spawnMin = $null; if ($kidsT.Count) { $spawnMin = [Math]::Max(0, ($now - (@($kidsT | Sort-Object CreationDate)[-1]).CreationDate).TotalMinutes) }
    $stalled = ($min -ge 10) -and ($null -eq $wmin -or $wmin -ge 10) -and ($null -eq $spawnMin -or $spawnMin -ge 10) -and ($cpu -lt [Math]::Max(5, $min * 60 * 0.005))
    $fmt = { param($m) if ($m -lt 60) { "$([int][Math]::Floor($m)) min" } else { '{0}h{1:00}' -f [int][Math]::Floor($m / 60), [int][Math]::Floor($m % 60) } }
    $txt = "há $(& $fmt $min) · CPU $([int][Math]::Round($cpu)) s" + $(if ($leaf) { " · esperando: $leaf" } else { '' }) + $(if ($null -ne $spawnMin -and $spawnMin -lt 10) { " · processo filho novo há $(& $fmt $spawnMin)" } else { '' }) + $(if ($null -ne $wmin) { " · último arquivo há $(& $fmt $wmin)" } elseif ($Dir) { ' · nenhum arquivo gravado' } else { '' })
    if ($stalled) { $txt += " · $([char]0x26A0) POSSÍVEL TRAVAMENTO (sem CPU, processo filho nem arquivo novo há 10 min ou mais)" }
    return [pscustomobject]@{ Min = $min; CpuS = $cpu; Leaf = $leaf; WriteMin = $wmin; SpawnMin = $spawnMin; Stalled = $stalled; Text = $txt }
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
# v3.58.3 (sprint 6 do garden: 12 de 22 formulários subiram ao stakeholder fora da rota, 6 deles por uma linha de teste): o
# run.ps1 grava aqui a rota que manda levar a decisão ao stakeholder — fim da fila, bloqueio sem Task elegível, GAP de
# produto, estado de partida, ambiente sem reparo, travamento repetido, comandos dos planos. A G24 (hooks/pre-tool.ps1) só
# deixa a sessão que conduz o sprint run abrir formulário com ela gravada (R25 c). Vale até o próximo start ou até o next
# mandar construir, e no máximo 24 h. Rota '' apaga.
function Set-AskRoute([string]$Root, [string]$Rota, [string]$Task = '', [string]$Motivo = '') {
    $p = Join-Path $Root '.team-project/.ask-route'
    if (-not $Rota) { Remove-Item -LiteralPath $p -Force -ErrorAction SilentlyContinue; return }
    if ($Motivo.Length -gt 300) { $Motivo = $Motivo.Substring(0, 300) + '…' }
    [System.IO.File]::WriteAllText($p, ([ordered]@{ rota = $Rota; task = $Task; motivo = $Motivo; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') } | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false)))
    $script:AskRouteNew = $p
}
# v3.65.11 (garden S6, 22/11 02:21 e 06:48: a sessão escreveu a pergunta do zero, com hash, exit 4 e nome de arquivo, e o
# stakeholder respondeu "não entendi nada"): a rota gravada nesta chamada leva o texto em linguagem simples do próprio script
# (a linha PARA O STAKEHOLDER), de onde o formulário parte. O run.ps1 Say chama aqui.
function Add-AskRoutePlain([string]$Text) {
    $p = $script:AskRouteNew
    if (-not $p -or -not $Text -or -not (Test-Path -LiteralPath $p)) { return }
    try {
        $ar = Read-Text $p | ConvertFrom-Json
        $ar | Add-Member -NotePropertyName plain -NotePropertyValue $Text -Force
        [System.IO.File]::WriteAllText($p, ($ar | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false)))
    } catch { }
    $script:AskRouteNew = ''
}
function Exit-TargetLock([string]$Root) {
    $lp = Join-Path $Root '.team-project/.target-lock'
    if (Test-Path -LiteralPath $lp) { try { $l = Read-Text $lp | ConvertFrom-Json; if ([int]$l.pid -eq $PID) { Remove-Item -LiteralPath $lp -Force } } catch { Remove-Item -LiteralPath $lp -Force -ErrorAction SilentlyContinue } }
    # v3.63.2: e a trava do aparelho que ESTE processo tomou (só a dele; a de outro processo ou projeto fica).
    $dd = Get-DeviceLockDir
    if (Test-Path -LiteralPath $dd) {
        foreach ($f in @(Get-ChildItem -LiteralPath $dd -File -Filter '*.json' -ErrorAction SilentlyContinue)) {
            try { $d = Read-Text $f.FullName | ConvertFrom-Json; if ($d -and [int]$d.pid -eq $PID) { Remove-Item -LiteralPath $f.FullName -Force -ErrorAction SilentlyContinue } } catch { }
        }
    }
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
    # v3.62.3: "**Aceite:** comando — `<cmd>`" não dispensa — o accept.ps1 roda o executor do projeto; os cenários ficam no alvo.
    $pa = Get-PlanAccept $PlanText
    if ($pa -and $pa.Mode -eq 'comando') { return @{ None = $false; Target = $tg; Test = @($all | Where-Object { $tg -notcontains $_ }); Command = $pa.Command } }
    $wv = [regex]::Match([string]$PlanText, '(?im)^[ \t]*(?:[-*][ \t]+)?(?:\*\*)?(?:Aceite|Accept)\b[^\r\n:]*:[^\r\n]*?n[ãa]o[ \t]+roda\b[^\r\n]*$')
    if (-not $wv.Success) { $wv = [regex]::Match([string]$PlanText, '(?im)^[ \t]*(?:[-*][ \t]+)?(?:\*\*)?Decis[ãa]o\b[^\r\n]*\b(?:accept|aceite)\b[^\r\n]*n[ãa]o[ \t]+roda\b[^\r\n]*$') }
    if ($wv.Success) {
        $why = ($wv.Value.Trim() -replace '\*\*', '' -replace '\s+', ' '); if ($why.Length -gt 160) { $why = $why.Substring(0, 160) + '…' }
        return @{ None = $false; Target = @(); Test = $all; Waived = $true; Reason = $why }
    }
    return @{ None = $false; Target = $tg; Test = @($all | Where-Object { $tg -notcontains $_ }) }
}
# v3.57.3 (plugin-report do sprint 5 do garden, lições de GAP 1, 5, 8/9 e 11; decisão do stakeholder de 10/11): a linha
# **Verificação:** do cabeçalho do plano diz como a Task se verifica quando o verify full padrão não serve.
#   "dispensada — <motivo>"   Task de laudo, Task que só mexe em configuração de teste: o close.ps1 dá R7-verify n-a e o QA
#                             revisa a dispensa no portão.
#   "comando — `<comando>`"   Task cuja prova é um comando fora do framework principal (runner nativo do Node, script): o
#                             verify.ps1 o roda como mais um passo ("plano") no focused e no full — com a trava, a árvore e o
#                             result.json de sempre.
# Sem a linha: $null (verify full padrão). Linha fora dos dois formatos: Mode 'inválida'.
function Get-PlanVerification([string]$PlanText) {
    $m = [regex]::Match([string]$PlanText, '(?im)^\*\*Verifica[çc][ãa]o:\*\*[ \t]*([^\r\n]*)')   # v3.62.3: sem "$" — com CRLF, o "$" não casa antes do \r
    if (-not $m.Success) { return $null }
    $v = $m.Groups[1].Value.Trim()
    if ($v -match '^(?i)dispensad[ao]\s*[—–-]\s*(\S.*)$') { return [pscustomobject]@{ Mode = 'dispensada'; Reason = $Matches[1].Trim(); Command = ''; Raw = $v } }
    if ($v -match '^(?i)comando\s*[—–-]\s*`([^`]+)`(.*)$') { return [pscustomobject]@{ Mode = 'comando'; Command = $Matches[1].Trim(); Reason = ($Matches[2] -replace '^\s*[—–-]\s*', '').Trim(); Raw = $v } }
    return [pscustomobject]@{ Mode = 'inválida'; Reason = ''; Command = ''; Raw = $v }
}
# v3.62.3 (sprint 6 do projeto piloto, Q-S6d): a linha **Aceite:** do cabeçalho do plano, o mesmo desenho da **Verificação:**.
#   "comando — `<cmd>`"   o projeto tem executor de cenários próprio: o accept.ps1 continua sendo o caminho do aceite (trava
#                         do alvo, pré-voo, APK, instalação, estado de partida, progresso, result.json) e chama o executor um
#                         .scn por vez — {scn} o arquivo, {out} a pasta da prova, {only} os cenários da Task nele, {task} o ID.
#   "não roda — <motivo>" os cenários se provam pelos testes do plano (Get-PlanScenarios).
# Antes, o plano só sabia dizer "não roda": a Q-S6d dispensou o aceite e provou os 49 cenários por um script do projeto,
# fora da trava, sem progresso, sem saber qual APK estava no emulador e com a prova fora de .team-project/accept/.
# $null sem a linha; Mode 'comando' | 'não roda' | 'roda' | 'outra'.
function Get-PlanAccept([string]$PlanText) {
    $m = [regex]::Match([string]$PlanText, '(?im)^\*\*(?:Aceite|Accept):\*\*[ \t]*([^\r\n]*)')   # sem "$": o plano com CRLF
    if (-not $m.Success) { return $null }
    $v = $m.Groups[1].Value.Trim()
    if ($v -match '^(?i)comando\s*[—–-]\s*`([^`]+)`(.*)$') { return [pscustomobject]@{ Mode = 'comando'; Command = $Matches[1].Trim(); Reason = ($Matches[2] -replace '^\s*[—–-]\s*', '').Trim(); Raw = $v } }
    $mode = if ($v -match '^(?i)n[ãa]o\s+roda\b') { 'não roda' } elseif ($v -match '^(?i)roda\b') { 'roda' } else { 'outra' }
    return [pscustomobject]@{ Mode = $mode; Command = ''; Reason = ($v -replace '^(?i)(n[ãa]o\s+)?roda\s*[—–-]?\s*', '').Trim(); Raw = $v }
}
# v3.62.3: o comando do **Aceite:** com os marcadores trocados — cada valor entre aspas simples do PowerShell (o comando roda
# num PowerShell filho; caminho com espaço ou acento passa inteiro). Quem escreve o comando NÃO põe aspas em volta do marcador.
function Expand-AcceptCommand([string]$Cmd, [hashtable]$Values) {
    $out = $Cmd
    foreach ($k in $Values.Keys) { $out = $out.Replace("{$k}", "'" + (([string]$Values[$k]) -replace "'", "''") + "'") }
    return $out
}
# v3.62.3: as linhas de resultado que o executor do projeto imprime — "<SC-ID> PASSOU|FALHOU|NÃO EXERCITADO [detalhe]" (com ou
# sem colchetes no ID, como o próprio accept.ps1 imprime). A última linha de cada cenário vale. Tolera o "Ã" que a saída do
# processo filho perde na página de código (NÃƒO, N?O). Devolve [ordered] id → @{ status; detail }.
function Read-AcceptCommandLines([string]$Text) {
    $res = [ordered]@{}
    foreach ($m in [regex]::Matches([string]$Text, '(?m)^[ \t]*\[?(SC-\d+[a-z]?)\]?[ \t]+(PASSOU|FALHOU|N\S{1,3}O[ \t]+EXERCITADO)\b[ \t]*([^\r\n]*)')) {
        $st = [string]$m.Groups[2].Value; if ($st -notin 'PASSOU', 'FALHOU') { $st = 'NÃO EXERCITADO' }
        $d = ([string]$m.Groups[3].Value).Trim() -replace '^->\s*', ''
        $res[[string]$m.Groups[1].Value] = @{ status = $st; detail = $d }
    }
    return $res
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
        $bScn = $scn; $bTst = $tst; $from = 'backlog'; $waiver = ''; $pver = $null; $acmd = ''
        if ($pp -and $pp -notmatch '^plan/?$') {
            $pf = Join-Path $S $pp
            if (Test-Path -LiteralPath $pf -PathType Leaf) {
                $ptx = Read-Text $pf
                $ps = Get-PlanScenarios $ptx
                if ($ps) { $scn = @($ps.Target); $tst = @($ps.Test); $from = 'plano'; if ($ps.Waived) { $waiver = [string]$ps.Reason }; if ($ps.Command) { $acmd = [string]$ps.Command } }
                $pver = Get-PlanVerification $ptx   # v3.57.3: o cartão diz como a Task se verifica
            }
        }
        $div = ($from -eq 'plano') -and ((@($bScn | Sort-Object) -join ',') -ne (@($scn | Sort-Object) -join ',') -or (@($bTst | Sort-Object) -join ',') -ne (@($tst | Sort-Object) -join ','))
        # v3.57.3 (capacidade): a estimativa da coluna Est., em número (vírgula ou ponto); sem número, $null.
        $em = [regex]::Match((Clean-Cell (& $col 'Est')), '\d+(?:[.,]\d+)?'); $est = if ($em.Success) { [double]($em.Value -replace ',', '.') } else { $null }
        $tasks += [pscustomobject]@{ Id = $idm.Value; Title = (Clean-Cell (& $col 'Task')); Story = $story; Mark = $mk; Deps = $deps; Plan = $pp; Scenarios = $scn; TestScenarios = $tst; ScenariosFrom = $from; BacklogScenarios = @($bScn + $bTst); ScenariosDiverge = [bool]$div; AcceptWaiver = $waiver; AcceptCommand = $acmd; Verification = $pver; Est = $est }
    }
    return $tasks
}
# v3.57.3: o plano da Task do sprint corrente — a coluna Plano do quadro; sem ela, sprints/<n>/plan/<T-ID>-*.md. '' sem plano.
function Get-TaskPlanPath([string]$Root, [string]$Task) {
    $tp = Join-Path $Root '.team-project'; $readme = Join-Path $tp 'README.md'
    if (-not $Task -or -not (Test-Path -LiteralPath $readme)) { return '' }
    $n = Get-CurrentSprint (Read-Text $readme); if (-not $n) { return '' }
    $S = Join-Path $tp "sprints/$n"
    if (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md')) {
        $t = @(Get-SprintTasks $S | Where-Object { $_.Id -eq $Task }) | Select-Object -First 1
        if ($t -and $t.Plan -and $t.Plan -notmatch '^plan/?$') { $pf = Join-Path $S $t.Plan; if (Test-Path -LiteralPath $pf -PathType Leaf) { return $pf } }
    }
    $g = @(Get-ChildItem -LiteralPath (Join-Path $S 'plan') -Filter "$Task-*.md" -File -ErrorAction SilentlyContinue)
    if ($g.Count) { return $g[0].FullName }
    return ''
}
# v3.57.3 (plugin-report do sprint 5 do garden, §3 item 13; decisão do stakeholder de 10/11): a conta da capacidade para a
# decisão de uma entrada fora da Planning. No sprint 5 entraram 11 Tasks depois da Planning (16,0 d contra 11,83 d, +35 %),
# todas com "nada saiu para caber" — a conta não estava na frente de quem decidia. Capacidade: a linha **Capacidade** do
# quadro (sprint-backlog.md); sem ela, **Capacidade do sprint** do README. Planejado: **Somatório planejado**. No quadro: a
# soma da coluna Est. das Tasks vivas, sem a correção do portão (Q-S<n>, que não cresce o escopo). $null sem capacidade.
function Get-SprintCapacity([string]$Root, [string]$S, [double]$Add = 0) {
    $num = { param($v) $m = [regex]::Match([string]$v, '\d+(?:[.,]\d+)?'); if ($m.Success) { [double]($m.Value -replace ',', '.') } else { $null } }
    $bp = Join-Path $S 'sprint-backlog.md'
    if (-not (Test-Path -LiteralPath $bp)) { return $null }
    $board = Read-Text $bp
    $readme = Join-Path $Root '.team-project/README.md'; $rt = if (Test-Path -LiteralPath $readme) { Read-Text $readme } else { '' }
    $cap = & $num (Get-LabelValue $board 'Capacidade')
    if ($null -eq $cap -and $rt) { $cap = & $num (Get-LabelValue $rt 'Capacidade do sprint') }
    if ($null -eq $cap -or $cap -le 0) { return $null }
    $planned = & $num (Get-LabelValue $board 'Somatório planejado')
    $unit = if ($rt) { [string](Get-LabelValue $rt 'Unidade de estimativa') } else { '' }
    $unit = if ($unit -match '(?i)\bdias?\b') { 'd' } elseif ($unit -match '(?i)ponto') { 'pt' } elseif ($unit -match '(?i)sess') { 'sessões' } else { '' }
    $live = @(Get-SprintTasks $S | Where-Object { $_.Id -notmatch '^Q-S' -and $null -ne $_.Est })
    $sum = [double](($live | Measure-Object Est -Sum).Sum)
    $with = $sum + $Add
    $pct = { param($x) [int][Math]::Round(100 * ($x - $cap) / $cap) }
    return [pscustomobject]@{ Capacity = $cap; Planned = $planned; Board = $sum; With = $with; Add = $Add; Over = ($with -gt $cap); BoardPct = (& $pct $sum); WithPct = (& $pct $with); Unit = $unit; Tasks = $live.Count }
}
# A linha da conta, para o formulário ao stakeholder e para o R4 do close.ps1.
function Format-SprintCapacity($C) {
    $f = { param($x) $x.ToString('0.##', [System.Globalization.CultureInfo]::GetCultureInfo('pt-BR')) + $(if ($C.Unit) { " $($C.Unit)" } else { '' }) }
    $sg = { param($p) if ($p -gt 0) { "+$p %" } elseif ($p -lt 0) { "$p %" } else { '0 %' } }
    $s = "capacidade $(& $f $C.Capacity)" + $(if ($null -ne $C.Planned) { " · planejado na Planning $(& $f $C.Planned)" } else { '' }) + " · no quadro $(& $f $C.Board) ($(& $sg $C.BoardPct))"
    if ($C.Add -gt 0) { $s += " · com a entrada (+$(& $f $C.Add)): $(& $f $C.With) ($(& $sg $C.WithPct))" }
    return $s
}
# ---------- v3.60.0 · prazo, previsão e burndown (pedido do stakeholder, 15/11/2026) ----------
# "Adicionar no Kanban a estimativa de tempo de cada tarefa para finalizar e a estimativa de tempo do Sprint e um farol No
# Prazo, Atrasado e Adiantado" e "um gráfico Burndown visual". O ritmo é MEDIDO no próprio sprint: horas de relógio desde a
# abertura ÷ unidades estimadas já prontas (✅). Cada parte aberta leva estimativa × ritmo; as em construção descontam o que
# já correram desde que entraram em 🟨; somadas na ordem da fila (R1: uma por vez), dão a previsão de cada uma e a do sprint.
# O prazo, na ordem: a data de fim da Janela (Linha de base) · a "Duração do sprint" do README (N dias ou semanas) · com a
# unidade em dias, a própria estimativa planejada na abertura (o garden não tem data fixa: 13,75 d desde a abertura). Sem
# nenhum, só a previsão, sem farol. Farol: previsão depois do prazo → Atrasado; folga acima de 15 % da janela → Adiantado;
# senão No prazo. Sem parte pronta ainda, não há ritmo: Atrasado só se o prazo passou ou mais de 25 % dele correu.
$script:ScheduleAheadPct = 0.15
$script:ScheduleNoPaceLatePct = 0.25
$script:ScheduleMaxDays = 60
function ConvertTo-ScheduleNumber([string]$V) { $m = [regex]::Match([string]$V, '-?\d+(?:[.,]\d+)?'); if ($m.Success) { return [double]($m.Value -replace ',', '.') }; return $null }
function ConvertTo-ScheduleDate([string]$V) {
    $m = [regex]::Match([string]$V, '(\d{4}-\d{2}-\d{2})(?:[ T](\d{2}:\d{2}))?')
    if ($m.Success) {
        $s = $m.Groups[1].Value + $(if ($m.Groups[2].Success) { ' ' + $m.Groups[2].Value } else { '' })
        try { return [datetime]::ParseExact($s, [string[]]@('yyyy-MM-dd HH:mm', 'yyyy-MM-dd'), [Globalization.CultureInfo]::InvariantCulture, 'None') } catch { }
    }
    $m = [regex]::Match([string]$V, '\b(\d{2})/(\d{2})/(\d{4})\b')
    if ($m.Success) { try { return (New-Object DateTime ([int]$m.Groups[3].Value), ([int]$m.Groups[2].Value), ([int]$m.Groups[1].Value)) } catch { } }
    return $null
}
# Pontos da Série: quando e a estimativa restante, na ordem do arquivo. Timed = a célula tinha hora.
function Get-SeriesPoints([string]$Text) {
    $sec = Get-Section $Text '^##\s+S[ée]rie'; if (-not $sec) { return @() }
    $t = @(Get-Tables $sec)[0]; if (-not $t) { return @() }
    $di = Find-Col $t 'Data'; $ri = Find-Col $t 'Est. restante'
    if ($di -lt 0 -or $ri -lt 0) { return @() }
    $out = @()
    foreach ($r in $t.Rows) {
        $at = ConvertTo-ScheduleDate (Get-Cell $r $di); $rem = ConvertTo-ScheduleNumber (Get-Cell $r $ri)
        if ($at -and $null -ne $rem) { $out += [pscustomobject]@{ At = $at; Rem = $rem; Timed = ((Get-Cell $r $di) -match '\d{2}:\d{2}') } }
    }
    return $out
}
# Quando cada Task entrou em 🟨 pela última vez (Registro de transições) — o que ela já correu na construção.
function Get-BuildStarts([string]$Text) {
    $h = @{}; $sec = Get-Section $Text '^##\s+Registro de transi'; if (-not $sec) { return $h }
    foreach ($t in @(Get-Tables $sec)) { foreach ($r in $t.Rows) {
        $ids = @([regex]::Matches((Get-Cell $r 0), $script:TaskIdRe)); if ($ids.Count -ne 1) { continue }
        if (((Get-Cell $r 1) -split '→')[-1].Trim() -ne $E.Build) { continue }
        $at = ConvertTo-ScheduleDate (Get-Cell $r 2); if ($at) { $h[$ids[0].Value] = $at } } }
    return $h
}
function Get-SprintSchedule([string]$Root, [string]$S, $Now = $null) {
    # TEAM_SCHEDULE_NOW ("aaaa-mm-dd hh:mm"): o "agora" fixo dos testes (run-check-tests.ps1); fora deles, o relógio.
    if (-not $Now) { $Now = if ($env:TEAM_SCHEDULE_NOW) { [datetime]::ParseExact($env:TEAM_SCHEDULE_NOW, 'yyyy-MM-dd HH:mm', [Globalization.CultureInfo]::InvariantCulture) } else { Get-Date } }
    if (-not (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md'))) { return $null }
    $todoMk = [char]::ConvertFromUtf32(0x2B1C); $redMk = [char]::ConvertFromUtf32(0x1F534)
    $tasks = @(Get-SprintTasks $S)
    $rec = Get-RecordPath $S; $recT = if (Test-Path -LiteralPath $rec) { Read-Text $rec } else { '' }
    $ch = Get-ChartPath $S; $chT = if (Test-Path -LiteralPath $ch) { Read-Text $ch } else { '' }
    $pts = @(Get-SeriesPoints $recT)
    $base = Get-Section $chT '^##\s+Linha de base'
    $jan = if ($base) { [string](Get-LabelValue $base 'Janela') } else { '' }
    $jm = [regex]::Match($jan, '^(.*?)(?:→|->)(.*)$')
    $jStart = ConvertTo-ScheduleDate $(if ($jm.Success) { $jm.Groups[1].Value } else { $jan })
    $jEnd = if ($jm.Success) { ConvertTo-ScheduleDate $jm.Groups[2].Value } else { $null }
    # Início: a abertura na Série (a 1ª linha com hora, se a de abertura só tem a data), senão o começo da Janela.
    $start = $null
    if ($pts.Count) { $start = $pts[0].At; if (-not $pts[0].Timed) { $tm = @($pts | Where-Object { $_.Timed -and $_.At.Date -eq $pts[0].At.Date }) | Select-Object -First 1; if ($tm) { $start = $tm.At } } }
    elseif ($jStart) { $start = $jStart }
    if (-not $start) { return $null }
    $est = { param($t) if ($null -ne $t.Est) { [double]$t.Est } else { 0.0 } }
    $open = @($tasks | Where-Object { $_.Mark -ne $E.Done })
    $doneU = [double](@($tasks | Where-Object { $_.Mark -eq $E.Done } | ForEach-Object { & $est $_ }) | Measure-Object -Sum).Sum
    $remU = [double](@($open | ForEach-Object { & $est $_ }) | Measure-Object -Sum).Sum
    $planned = if ($pts.Count) { $pts[0].Rem } else { $doneU + $remU }
    # Prazo
    $rd = Join-Path $Root '.team-project/README.md'; $rt = if (Test-Path -LiteralPath $rd) { Read-Text $rd } else { '' }
    $unit = [string](Get-LabelValue $rt 'Unidade de estimativa')
    $unitName = if ($unit -match '(?i)\bdias?\b') { 'dias' } elseif ($unit -match '(?i)ponto') { 'pontos' } else { 'unidades' }
    $end = $null; $src = ''
    if ($jEnd -and $jEnd -gt $start) { $end = if ($jEnd.TimeOfDay.TotalMinutes -eq 0) { $jEnd.AddDays(1) } else { $jEnd }; $src = 'janela' }
    else {
        $dm = [regex]::Match([string](Get-LabelValue $rt 'Duração do sprint'), '(?i)(\d+)\s*(semana|dia)')
        if ($dm.Success) { $k = [int]$dm.Groups[1].Value; $end = $start.Date.AddDays($(if ($dm.Groups[2].Value -match '(?i)semana') { 7 * $k } else { $k })); $src = 'duração' }
        elseif ($unit -match '(?i)\bdias?\b' -and $planned -gt 0) { $end = $start.AddDays($planned); $src = 'estimativa' }
    }
    # Ritmo e previsão, na ordem da fila: em construção/teste · sendo planejadas · na fila · paradas no fim.
    $elapsedH = [Math]::Max(0.0, ($Now - $start).TotalHours)
    $pace = if ($doneU -gt 0 -and $elapsedH -gt 0) { $elapsedH / $doneU } else { $null }
    $bs = Get-BuildStarts $recT
    $order = @($open | Where-Object { $_.Mark -eq $E.Build -or $_.Mark -eq $E.QA }) + @($open | Where-Object { $_.Mark -eq $E.Plan }) + @($open | Where-Object { -not $_.Mark -or $_.Mark -eq $todoMk }) + @($open | Where-Object { $_.Mark -eq $redMk })
    $eta = @{}; $t = $Now
    foreach ($tk in $order) {
        $red = ($tk.Mark -eq $redMk)
        if ($null -eq $pace) { $eta[$tk.Id] = [pscustomobject]@{ Hours = $null; Finish = $null; Over = $false; Red = $red }; continue }
        $dur = (& $est $tk) * $pace; $left = $dur; $over = $false
        if (($tk.Mark -eq $E.Build -or $tk.Mark -eq $E.QA) -and $bs.ContainsKey($tk.Id)) { $spent = ($Now - $bs[$tk.Id]).TotalHours; $left = [Math]::Max(0.0, $dur - $spent); $over = ($spent -gt $dur) }
        $t = $t.AddHours($left)
        $eta[$tk.Id] = [pscustomobject]@{ Hours = $left; Finish = $t; Over = $over; Red = $red }
    }
    $proj = if ($null -ne $pace) { $t } else { $null }
    $state = if (-not $open.Count) { 'pronto' } elseif (-not $end) { 'sem prazo' } elseif ($null -eq $pace) {
        if ($Now -gt $end -or ($elapsedH / [Math]::Max(0.01, ($end - $start).TotalHours)) -gt $script:ScheduleNoPaceLatePct) { 'atrasado' } else { 'sem ritmo' }
    } elseif ($proj -gt $end) { 'atrasado' } elseif (($end - $proj).TotalHours -gt $script:ScheduleAheadPct * ($end - $start).TotalHours) { 'adiantado' } else { 'no prazo' }
    # Dias do burndown: do dia 0 ao último entre o prazo e hoje (até $ScheduleMaxDays). Real até hoje, com o último valor do
    # dia (o de antes vale nos dias sem evento); ideal do planejado a zero no último dia do prazo.
    $today = [int]($Now.Date - $start.Date).TotalDays
    $endDay = if ($end) { [int]($end.AddSeconds(-1).Date - $start.Date).TotalDays } else { $null }
    $last = [Math]::Min($script:ScheduleMaxDays, [Math]::Max($today, $(if ($null -ne $endDay) { $endDay } else { 0 })))
    $days = @(); $cur = $planned
    for ($d = 0; $d -le $last; $d++) {
        $day = $start.Date.AddDays($d)
        foreach ($p in $pts) { if ($p.At.Date -le $day) { $cur = $p.Rem } }
        $ideal = if ($null -ne $endDay -and $endDay -gt 0) { [Math]::Max(0.0, $planned * (1 - $d / $endDay)) } elseif ($null -ne $endDay) { 0.0 } else { $null }
        # Hoje vale o restante do quadro (a Série pode atrasar em relação ao quadro; no garden S6 ela marcava 0 com 2 abertas).
        $days += [pscustomobject]@{ Day = $d; Date = $day; Real = $(if ($d -lt $today) { $cur } elseif ($d -eq $today) { $remU } else { $null }); Ideal = $ideal }
    }
    return [pscustomobject]@{ Start = $start; End = $end; EndSource = $src; Unit = $unitName; Planned = $planned; Done = $doneU; Remaining = $remU; ElapsedH = $elapsedH
                              PaceH = $pace; Projected = $proj; State = $state; Eta = $eta; Days = $days; Now = $Now }
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

# v3.60.0 (pedido do stakeholder, 15/11/2026: o kanban.md para quem acompanha; o registro técnico no consumption.md): a
# Série e o Registro de transições vivem no consumption.md do sprint quando ele os tem — o kanban.ps1 os leva para lá no
# sprint run. Antes disso (Planning, sprint anterior à v3.60), no kanban.md ou no burndown.md. Quem lê ou grava a Série e o
# Registro usa este caminho; o controle e a linha de base continuam no kanban.md (Get-ChartPath).
function Get-RecordPath([string]$SprintDir) {
    $c = Join-Path $SprintDir 'consumption.md'
    if ((Test-Path -LiteralPath $c) -and ((Read-Text $c) -match '(?m)^##\s+(S[ée]rie|Registro de transi)')) { return $c }
    return (Get-ChartPath $SprintDir)
}
# Registro de transições (R24): vive no consumption.md (v3.60), no kanban.md (v3.51) ou no burndown.md (v3.44.1) do sprint; sprint aberto antes disso o tem no sprint-backlog.md. $null se nenhum.
function Get-TransitionLog([string]$SprintDir, [string]$Board) {
    $bd = Get-RecordPath $SprintDir
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
        # v3.60.0: as mesmas linhas, com as faixas (CodeRefs) e as seções (SourceRefs) — o run.ps1 next copia os trechos.
        return [pscustomobject]@{ Path = $bp; Common = $(if ($dm.Success) { $dm.Value.TrimEnd() } else { '' }); Body = $fm.Value.TrimEnd(); Read = $read; Sources = $src; Names = $names; Planned = $planned
                                  CodeRefs = @(Get-FichaCodeRefs (& $label 'C[óo]digo a ler')); SourceRefs = @(Get-FichaSourceRefs (& $label 'Fontes')) }
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

# ---------- v3.60.0 · a ficha leva os trechos, o plano não explora ----------
# Medido no garden (S6, H-M, 3 planos, US$ 9,02): 111 de 125 chamadas do Arquiteto e 84 % do custo foram exploração antes do
# primeiro Write — ~75 buscas e leituras em pedaços do código que a Planning já tinha medido (o breakdown trazia as linhas).
# Cada chamada reenvia a conversa inteira, então o custo é chamadas × contexto. Agora a Planning aponta faixas e o run.ps1
# next copia os trechos para o recorte: o Arquiteto lê uma vez e escreve. Simulação calibrada nas 3 conversas: ≈ US$ 5,7
# (4,4 a 6,9) contra 9,0; um Arquiteto para a História inteira, mesmo com os trechos, ficou 25 a 35 % acima disso.
$script:FichaLineWindow = 40      # `caminho:linha` sem fim: 40 linhas, a partir de 5 antes da linha citada
$script:FichaWholeMaxLines = 150  # `caminho` sem linha nem §: o arquivo inteiro só até este tamanho
$script:FichaExcerptMaxKb = 60    # teto dos trechos no recorte; o que passa fica como nota, para ler no trecho

# Linhas de **Código a ler:** — `caminho:a-b` (faixa), `caminho:a` (janela de $FichaLineWindow), `caminho` (sem faixa); na
# mesma linha, `:c-d` e `:c` acrescentam faixas ao mesmo arquivo. Spans: @(de, até), até = 0 na janela.
function Get-FichaCodeRefs([string]$Label) {
    $out = @()
    foreach ($line in ($Label -split "`r?`n")) {
        $toks = @([regex]::Matches($line, '`([^`]+)`') | ForEach-Object { $_.Groups[1].Value.Trim() })
        if (-not $toks.Count) { continue }
        $m = [regex]::Match(((($toks[0] -replace '\\', '/') -replace '^\./', '') -replace '#.*$', ''), '^(.+?)(?::(\d+)(?:-(\d+))?)?$')
        if (-not $m.Success -or $m.Groups[1].Value -match '^:') { continue }
        $spans = @()
        if ($m.Groups[2].Success) { $spans += , @([int]$m.Groups[2].Value, $(if ($m.Groups[3].Success) { [int]$m.Groups[3].Value } else { 0 })) }
        foreach ($t in @($toks | Select-Object -Skip 1)) {
            $x = [regex]::Match($t, '^:(\d+)(?:-(\d+))?$')
            if ($x.Success) { $spans += , @([int]$x.Groups[1].Value, $(if ($x.Groups[2].Success) { [int]$x.Groups[2].Value } else { 0 })) }
        }
        $wm = [regex]::Match($line, '\s[—–]\s(.*)$')
        $out += [pscustomobject]@{ Path = $m.Groups[1].Value; Spans = $spans; Sections = @(); Why = $(if ($wm.Success) { $wm.Groups[1].Value.Trim() } else { '' }) }
    }
    return $out
}
# Itens de **Fontes:** (separados por " · " ou linha) com caminho: `doc.md` §2.5, §2–§7, §"Título da seção". Item sem
# caminho (regra da História, nome de classe) fica fora, como no Get-Ficha.
function Get-FichaSourceRefs([string]$Label) {
    $out = @()
    foreach ($item in ($Label -split '\s·\s|\r?\n')) {
        $tm = [regex]::Match($item, '`([^`]+)`')
        if (-not $tm.Success) { continue }
        $p = (((($tm.Groups[1].Value.Trim() -replace '\\', '/') -replace '^\./', '') -replace '#.*$', '') -replace ':\d+(-\d+)?$', '')
        if ($p -notmatch '/|\.[A-Za-z0-9]{1,6}$') { continue }
        $secs = @()
        foreach ($sm in [regex]::Matches($item.Substring($tm.Index + $tm.Length), '§\s*["“]([^"”]+)["”]|§\s*(\d[\w.]*)(?:\s*[–-]\s*§?\s*(\d[\w.]*))?')) {
            if ($sm.Groups[1].Success) { $secs += [pscustomobject]@{ From = $sm.Groups[1].Value.Trim(); To = $null; Title = $true } }
            else { $secs += [pscustomobject]@{ From = $sm.Groups[2].Value.TrimEnd('.'); To = $(if ($sm.Groups[3].Success) { $sm.Groups[3].Value.TrimEnd('.') } else { $null }); Title = $false } }
        }
        $out += [pscustomobject]@{ Path = $p; Spans = @(); Sections = $secs; Why = '' }
    }
    return $out
}
function Read-FileLines([string]$Path) {
    $ls = @((Read-Text $Path) -split "`r?`n")
    if ($ls.Count -gt 1 -and $ls[-1] -eq '') { $ls = @($ls | Select-Object -First ($ls.Count - 1)) }
    return , $ls
}
# Faixa (1-based, inclusiva) da seção de um markdown: o título que começa pelo número (§2 não casa 2.5) ou que contém o texto;
# vai até o próximo título de nível igual ou maior (com To, até o fim da seção To). Títulos dentro de bloco de código não contam.
function Get-MdSectionSpan([string[]]$Lines, $Sec) {
    $heads = @(); $fence = $false
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        if ($Lines[$i] -match '^\s*(```|~~~)') { $fence = -not $fence; continue }
        if (-not $fence -and $Lines[$i] -match '^(#{1,6})\s+(.*)$') { $heads += [pscustomobject]@{ I = $i; Level = $Matches[1].Length; Text = ($Matches[2].Trim() -replace '^§\s*', '') } }
    }
    $find = { param($key, $isTitle, $after)
        foreach ($h in @($heads | Where-Object { $_.I -ge $after })) {
            if ($isTitle) { if ($h.Text.IndexOf($key, [StringComparison]::OrdinalIgnoreCase) -ge 0) { return $h } }
            elseif ($h.Text -match ('^' + [regex]::Escape($key) + '(?!\d|\.\d)')) { return $h }
        }
        return $null }
    $endOf = { param($h) $nx = @($heads | Where-Object { $_.I -gt $h.I -and $_.Level -le $h.Level }) | Select-Object -First 1; if ($nx) { $nx.I } else { $Lines.Count } }
    $h1 = & $find $Sec.From $Sec.Title 0
    if (-not $h1) { return $null }
    $last = $h1
    if ($Sec.To) { $h2 = & $find $Sec.To $false $h1.I; if ($h2) { $last = $h2 } }
    return , @(($h1.I + 1), (& $endOf $last))
}
# As linhas da ficha são as do código na Planning; até o plano da Task, as Tasks de Histórias anteriores já mudaram o código
# (no garden, S6: 6 de 60 faixas tinham andado — `migracoes.ts:1131` 80 linhas, pela T-089; `plantio-form.page.ts` 24, pela
# T-087). O mapa traduz a linha da base (commit do início do sprint, ou o da última correção da ficha) para a de hoje, pelo
# `git diff -U0 <base>` contra o disco. $null sem base, sem git ou sem mudança no arquivo: a linha vale como está.
function Get-LineMap([string]$Root, [string]$Base, [string]$Path) {
    if (-not $Base -or $Path -match '^(standards/|\$\{CLAUDE_PLUGIN_ROOT\})') { return $null }
    $ErrorActionPreference = 'Continue'
    $d = @(& git -C $Root diff -U0 --no-color --no-ext-diff $Base -- ":(literal)$Path" 2>$null)
    if ($LASTEXITCODE -ne 0 -or -not $d.Count) { return $null }
    $hunks = @(foreach ($h in $d) {
        $m = [regex]::Match($h, '^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@')
        if ($m.Success) { [pscustomobject]@{ Os = [int]$m.Groups[1].Value; Oc = $(if ($m.Groups[2].Success) { [int]$m.Groups[2].Value } else { 1 }); Nc = $(if ($m.Groups[4].Success) { [int]$m.Groups[4].Value } else { 1 }) } } })
    if (-not $hunks.Count) { return $null }
    $by = @(& git -C $Root log --format=%s "$Base..HEAD" -- ":(literal)$Path" 2>$null | ForEach-Object { [regex]::Matches($_, $script:TaskIdRe) | Select-Object -First 1 | ForEach-Object { $_.Value } } | Select-Object -Unique)
    return [pscustomobject]@{ Hunks = $hunks; By = $by }
}
# Faixa da base → faixa de hoje. Hunk antes da faixa desloca; hunk que a toca a marca alterada (o trecho copiado é o de hoje,
# com aviso). Inserção pura (-n,0) fica depois da linha n.
function Convert-FichaSpan($Map, [int]$A, [int]$B) {
    if (-not $Map) { return [pscustomobject]@{ From = $A; To = $B; Shift = 0; Changed = $false } }
    $shift = 0; $grow = 0; $hit = $false
    foreach ($h in $Map.Hunks) {
        $before = if ($h.Oc -eq 0) { $h.Os -lt $A } else { ($h.Os + $h.Oc - 1) -lt $A }
        $inside = if ($h.Oc -eq 0) { $h.Os -ge $A -and $h.Os -lt $B } else { $h.Os -le $B -and ($h.Os + $h.Oc - 1) -ge $A }
        if ($before) { $shift += $h.Nc - $h.Oc } elseif ($inside) { $hit = $true; $grow += $h.Nc - $h.Oc }
    }
    $from = $A + $shift
    return [pscustomobject]@{ From = $from; To = [Math]::Max($from, $B + $shift + $grow); Shift = $shift; Changed = $hit }
}
# Faixas de **Código a ler:** que passam do fim do arquivo (ficha velha ou linha errada), já traduzidas para hoje: o run.ps1
# next pede a correção da ficha antes do plano, como para o caminho que não existe.
function Get-FichaBadRanges([string]$Root, $Ficha, [string]$Base = '') {
    $bad = @()
    foreach ($r in @($Ficha.CodeRefs)) {
        $fp = Resolve-FichaPath $Root $r.Path
        if (-not @($r.Spans).Count -or -not (Test-Path -LiteralPath $fp -PathType Leaf)) { continue }
        $n = (Read-FileLines $fp).Count; $map = Get-LineMap $Root $Base $r.Path
        foreach ($s in @($r.Spans)) { $c = Convert-FichaSpan $map $s[0] $(if ($s[1]) { $s[1] } else { $s[0] }); if ($c.From -gt $n) { $bad += "$($r.Path):$($s[0])$(if ($s[1]) { "-$($s[1])" }) ($n linhas)" } }
    }
    return $bad
}
# Os trechos que a ficha aponta, com o número da linha, para o recorte do Arquiteto do plano. Um bloco por arquivo, na
# ordem da ficha, faixas sobrepostas juntas. '' quando a ficha não aponta nada.
function Get-FichaExcerpts([string]$Root, $Ficha, [string]$Base = '') {
    $order = New-Object System.Collections.Generic.List[string]; $by = @{}
    foreach ($r in @($Ficha.CodeRefs) + @($Ficha.SourceRefs)) {
        if (-not $r -or -not $r.Path) { continue }
        if (-not $by.ContainsKey($r.Path)) { $order.Add($r.Path); $by[$r.Path] = [pscustomobject]@{ Spans = @(); Sections = @(); Why = @(); Whole = $false } }
        $e = $by[$r.Path]; $e.Spans += @($r.Spans); $e.Sections += @($r.Sections); if ($r.Why) { $e.Why += $r.Why }
        if (-not @($r.Spans).Count -and -not @($r.Sections).Count) { $e.Whole = $true }
    }
    if (-not $order.Count) { return '' }
    $cap = $script:FichaExcerptMaxKb * 1024; $used = 0; $blocks = @(); $notes = @()
    foreach ($path in $order) {
        $e = $by[$path]; $fp = Resolve-FichaPath $Root $path
        if (-not (Test-Path -LiteralPath $fp -PathType Leaf)) { $notes += "- ``$path`` — não existe"; continue }
        $ls = Read-FileLines $fp; $n = $ls.Count; $spans = @(); $miss = @()
        # v3.60.0: as linhas da ficha são as da base; o mapa as traz para hoje. Seção (§) se acha pelo título, sem mapa.
        $map = if (@($e.Spans).Count) { Get-LineMap $Root $Base $path } else { $null }
        $moved = @(); $changed = @()
        foreach ($s in @($e.Spans)) {
            $c = Convert-FichaSpan $map $s[0] $(if ($s[1]) { $s[1] } else { $s[0] })
            $tag = "$($s[0])$(if ($s[1]) { "-$($s[1])" })"
            if ($c.Changed) { $changed += $tag } elseif ($c.Shift) { $moved += "$tag → $($c.From)$(if ($s[1]) { "-$($c.To)" })" }
            if ($c.From -gt $n) { $miss += "faixa $tag fora do arquivo ($n linhas)"; continue }
            if ($s[1]) { $spans += , @([Math]::Max(1, $c.From), [Math]::Min($n, $c.To)) }
            else { $a = [Math]::Max(1, $c.From - 5); $spans += , @($a, [Math]::Min($n, [Math]::Max($a + $script:FichaLineWindow - 1, $c.To))) }
        }
        $who = if ($map -and @($map.By).Count) { " (por $(@($map.By) -join ', '))" } else { '' }
        if ($moved.Count) { $miss += "linhas da ficha deslocadas desde a Planning$who`: $($moved -join ', ')" }
        if ($changed.Count) { $miss += "⚠ trecho alterado desde a Planning$who`: $($changed -join ', ') — o copiado é o de hoje; confira se ainda é o que a Task precisa" }
        foreach ($sec in @($e.Sections)) {
            $sp = Get-MdSectionSpan $ls $sec
            if ($sp) { $spans += , $sp } else { $miss += "§$(if ($sec.Title) { '"' + $sec.From + '"' } else { $sec.From })$(if ($sec.To) { "–§$($sec.To)" }) não achada" }
        }
        if ($e.Whole -and -not $spans.Count) {
            if ($n -le $script:FichaWholeMaxLines) { $spans += , @(1, $n) }
            else { $notes += "- ``$path`` — sem faixa nem §: $n linhas, não copiado (escreva ``caminho:a-b`` na ficha; leia só o trecho)"; continue }
        }
        if (-not $spans.Count) { $notes += "- ``$path`` — " + ($miss -join '; '); continue }
        $spans = @($spans | Sort-Object { $_[0] }, { $_[1] })
        $merged = @(); foreach ($s in $spans) { if ($merged.Count -and $s[0] -le $merged[-1][1] + 3) { $merged[-1][1] = [Math]::Max($merged[-1][1], $s[1]) } else { $merged += , @($s[0], $s[1]) } }
        $w = ([string]$n).Length
        $body = @($merged | ForEach-Object { $sp = $_; @(($sp[0] - 1)..($sp[1] - 1) | ForEach-Object { ("{0," + $w + "}  {1}") -f ($_ + 1), $ls[$_] }) -join "`n" }) -join "`n   …`n"
        $head = "### ``$path`` — linhas " + (@($merged | ForEach-Object { "$($_[0])–$($_[1])" }) -join ', ') + " de $n" + $(if ($e.Why.Count) { ' · ' + (@($e.Why | Select-Object -Unique) -join ' · ') } else { '' }) + $(if ($miss.Count) { ' · ' + ($miss -join '; ') } else { '' })
        $blk = "$head`n~~~~`n$body`n~~~~`n"
        $sz = [System.Text.Encoding]::UTF8.GetByteCount($blk)
        if ($used + $sz -gt $cap) { $notes += "- ``$path`` — linhas $(@($merged | ForEach-Object { "$($_[0])–$($_[1])" }) -join ', '): não copiado, o recorte passou de $($script:FichaExcerptMaxKb) KB (leia o trecho)"; continue }
        $used += $sz; $blocks += $blk
    }
    $out = "`n## Trechos que a ficha aponta (v3.60.0)`n`n> Copiados pelo ``run.ps1 next`` do código e das fontes da ficha, com o número da linha: cite ``caminho:linha`` por eles e não releia esses arquivos. O que faltar, peça numa chamada só e registre em **Li além da ficha:**.`n`n" + ($blocks -join "`n")
    if ($notes.Count) { $out += "`n**Não copiado:**`n" + ($notes -join "`n") + "`n" }
    return $out
}
# Guia de escrita do plano (v3.60.0): gerado do template a cada recorte — a introdução, o esqueleto inteiro, a primeira frase
# de cada regra com a linha dela no template e a variante leve. Sem segunda cópia: o template continua a única fonte. No
# garden, o template (~35 mil caracteres, ~19,5 mil tokens) era lido inteiro na 1ª chamada e reenviado em todas as outras.
# '' se o template mudou de forma e as marcas sumiram — o prompt volta a mandar abrir o template.
function Get-PlanGuide {
    $rel = 'roles/architect/templates/implementation-plan.md'
    $tp = Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path $rel
    if (-not (Test-Path -LiteralPath $tp)) { return '' }
    $ls = Read-FileLines $tp
    $idx = { param($re, $from) for ($i = $from; $i -lt $ls.Count; $i++) { if ($ls[$i] -match $re) { return $i } }; return -1 }
    $s = & $idx '^```markdown\s*$' 0; $e = if ($s -ge 0) { & $idx '^```\s*$' ($s + 1) } else { -1 }
    $r = & $idx '^## Regras do formato' 0; $v = & $idx '^## Variante leve' 0; $x = & $idx '^## Exemplo abreviado' 0
    if ($s -lt 0 -or $e -lt 0 -or $r -lt 0 -or $v -lt $r -or $x -lt $v) { return '' }
    $intro = (@($ls[1..($s - 1)]) -join "`n").Trim()
    $rules = @()
    for ($i = $r + 1; $i -lt $v; $i++) {
        $m = [regex]::Match($ls[$i], '^(\d+)\.\s+((?:✓\s*)?\*\*.+?\*\*)(.*)$')
        if (-not $m.Success) { continue }
        # Até o primeiro ponto final (o ponto de `plan.ps1` não conta: vem colado na letra); sem ponto, 200 caracteres.
        $rest = $m.Groups[3].Value.TrimEnd()
        $fm = [regex]::Match($rest, '^(.{0,260}?\.)(?=\s|$)')
        $first = if ($fm.Success) { $fm.Groups[1].Value } elseif ($rest.Length -gt 200) { $rest.Substring(0, 200).TrimEnd() + '…' } else { $rest }
        $rules += "$($m.Groups[1].Value). $($m.Groups[2].Value)$first *(l. $($i + 1))*"
    }
    $leve = (@($ls[$v..($x - 1)]) -join "`n").Trim() -replace '^## ', '### '
    return "`n## Guia de escrita do plano (v3.60.0)`n`n> Gerado pelo ``run.ps1 next`` de ``$('${CLAUDE_PLUGIN_ROOT}')/$rel``: o esqueleto inteiro e a primeira frase de cada regra, com a linha dela no template. Escreva por aqui; a regra inteira só quando precisar dela ou quando o ``plan.ps1`` a citar (Read do template com offset na linha indicada e limit 3). ✓ = o ``plan.ps1`` confere. Exemplo de plano: template, linha $($x + 1).`n`n$intro`n`n### Esqueleto`n`n" + (@($ls[$s..$e]) -join "`n") + "`n`n### Regras — a primeira frase de cada uma`n`n" + ($rules -join "`n") + "`n`n$leve`n"
}
# Teto de arquivos previstos por Task com ficha (v3.53.2, plugin-report prévio do sprint 5 do garden): acima dele, o custo
# do plano cresce mais rápido que a Task (6 arquivos ≈ US$ 2,5; 9 ≈ US$ 4,7; 12 ≈ US$ 8,7) — a Task se divide antes do Opus.
$script:FichaMaxFiles = 6
# Teto do plano (v3.53.6, sprint 5 do garden, item 1): acima dele o plan.ps1 reprova (regra 22) e o run.ps1 next divide a
# Task com os blocos do plano como base — nunca se corta o plano (v3.53.2: cortar custou metade do plano da T-042). Em KB
# arredondados a 0,1, como o plan.ps1 imprime.
$script:PlanMaxKb = 30
function Get-PlanKb([string]$Text) { return [Math]::Round(([System.Text.Encoding]::UTF8.GetByteCount($Text)) / 1024, 1) }
# v3.60.1 (sprint 6 do garden, T-090): o teto mede o plano que o Arquiteto escreveu, não as decisões de 🔺 GAP que a
# construção acrescentou. A T-090 passou a 30,2 KB com as decisões do degrau 1 e a sessão levou ao stakeholder "encurtar ou
# dividir" uma Task já construída — a regra 22 (Task grande → divisão) é da Planning. Os blocos "**Decisão do GAP …:**"
# (Get-PlanGapDecisions) ficam fora da conta; a soma deles vai em Gap. @{ Kb = conta; Total = arquivo inteiro; Gap = decisões }.
function Get-PlanCoreKb([string]$Text) {
    $tot = Get-PlanKb $Text
    $gb = 0; foreach ($d in @(Get-PlanGapDecisions $Text)) { $gb += [System.Text.Encoding]::UTF8.GetByteCount([string]$d.Text) + 1 }
    $g = [Math]::Round($gb / 1024, 1)
    return @{ Kb = [Math]::Round([Math]::Max(0, $tot - $g), 1); Total = $tot; Gap = $g }
}

# v3.60.1 (sprint 6 do garden, T-093: 3 formulários "arquivos soltos" e 4 "evidência incompleta" pelo mesmo
# contorno-escuro.render.spec.ts, alterado por outra Task e sem commit): o que já estava alterado no git quando a Task começou
# não é dela. O run.ps1 start grava, na primeira vez da Task, sprints/<n>/handoff/<T-ID>-alheios.json com o hash de cada
# arquivo pendente (fora de .team-project/); o close.ps1 ignora no R7-margem o arquivo que segue com o mesmo hash. Mexeu nele
# depois, a conferência volta a valer — a mudança passou a ser da Task.
function Get-FileStateHash([string]$Root, [string]$Rel) {
    $full = Join-Path $Root $Rel
    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { return 'ausente' }
    try { $sha = [System.Security.Cryptography.SHA1]::Create(); try { return ([BitConverter]::ToString($sha.ComputeHash([System.IO.File]::ReadAllBytes($full))) -replace '-', '').ToLowerInvariant() } finally { $sha.Dispose() } } catch { return '' }
}
function Get-GitPendingFiles([string]$Root) {
    $eap = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    try {
        $null = & git -C $Root rev-parse --is-inside-work-tree 2>$null
        if ($LASTEXITCODE -ne 0) { return @() }
        return @(& git -C $Root status --porcelain -uall 2>$null | ForEach-Object { $gs = ([string]$_).Substring([Math]::Min(3, ([string]$_).Length)); if ($gs -match ' -> ') { $gs = ($gs -split ' -> ')[-1] }; $gs.Trim('"') } | Where-Object { $_ -and $_ -notmatch '^\.team-project/' -and -not (Test-TreeIgnored $Root $_) })   # v3.64.0: treeIgnore não é pendente
    } finally { $ErrorActionPreference = $eap }
}
function Save-ForeignSnapshot([string]$Root, [string]$S, [string]$Id) {
    $p = Join-Path $S "handoff/$Id-alheios.json"
    if (Test-Path -LiteralPath $p) { return $null }
    # Só antes da construção: com relatório em delivery/, o pendente pode já ser do dev desta Task (instância anterior).
    if (Test-Path -LiteralPath (Join-Path $S "delivery/$Id.md")) { return $null }
    $files = [ordered]@{}; foreach ($f in @(Get-GitPendingFiles $Root)) { $files[$f] = Get-FileStateHash $Root $f }
    New-Item -ItemType Directory -Force (Split-Path $p) | Out-Null
    [System.IO.File]::WriteAllText($p, ([ordered]@{ task = $Id; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); files = $files } | ConvertTo-Json -Depth 4 -Compress), (New-Object System.Text.UTF8Encoding($false)))
    return @($files.Keys)
}
function Get-ForeignUnchanged([string]$Root, [string]$S, [string]$Id) {
    $p = Join-Path $S "handoff/$Id-alheios.json"
    if (-not (Test-Path -LiteralPath $p)) { return @() }
    try { $j = Read-Text $p | ConvertFrom-Json } catch { return @() }
    if (-not $j.files) { return @() }
    return @($j.files.PSObject.Properties | Where-Object { $_.Value -and (Get-FileStateHash $Root $_.Name) -eq [string]$_.Value } | ForEach-Object { $_.Name })
}

# v3.60.1: chave de guards.json → run (o objeto do stakeholder). $null sem o arquivo, sem "run" ou sem a chave.
function Get-RunSetting([string]$Root, [string]$Name) {
    $g = Join-Path $Root '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $g)) { return $null }
    try { $j = Read-Text $g | ConvertFrom-Json } catch { return $null }
    if (-not $j.PSObject.Properties['run'] -or $null -eq $j.run -or -not $j.run.PSObject.Properties[$Name]) { return $null }
    return $j.run.$Name
}
# v3.60.1 (sprint 6 do garden: ids não publicados pela WebView na T-081, T-069a e T-090 — 4 formulários com a mesma resposta):
# guards.json → run.deviceProofFallback = "teste" é a decisão do stakeholder gravada como política do projeto. Quando o accept
# para no ESTADO DE PARTIDA, o run.ps1 aplica a prova por teste (run.ps1 prove) sem formulário, e a conferência no aparelho
# fica para a validação do sprint. Sem a chave, a decisão segue com o stakeholder. v3.62.0: o "IDS NÃO PUBLICADOS" virou
# CONFIGURAÇÃO DO ALVO (locator "cdp" para app híbrido), que vai sempre ao stakeholder — a política não se aplica a ela.
function Test-DeviceProofPolicy([string]$Root) {
    $v = Get-RunSetting $Root 'deviceProofFallback'
    return ([string]$v -match '^(?i)(teste|test)$')
}
# v3.60.1 (sprint 6 do garden: Docker Desktop desligado na hora do APK, 4 formulários): guards.json → run.prereqs =
# [{ "name": "Docker Desktop", "check": "docker info", "start": "Start-Process '…\\Docker Desktop.exe'", "waitSec": 120 }].
# Declarar o pré-requisito no guards.json (do stakeholder) já é a autorização para subi-lo. O run.ps1 start confere cada um;
# o que não responde, ele sobe pelo "start" e espera o "check" passar até waitSec (padrão 120 s). @{ Ok; Lines; Fail }.
function Invoke-RunPrereqs([string]$Root) {
    $out = @{ Ok = $true; Lines = @(); Fail = '' }
    $pr = Get-RunSetting $Root 'prereqs'
    foreach ($p in @($pr | Where-Object { $_ -and $_.PSObject.Properties['check'] -and [string]$_.check })) {
        $nm = if ($p.PSObject.Properties['name'] -and $p.name) { [string]$p.name } else { [string]$p.check }
        $chk = Invoke-Bounded $Root ([string]$p.check) 30
        if ($chk.exit -eq 0) { continue }
        $st = if ($p.PSObject.Properties['start'] -and $p.start) { [string]$p.start } else { '' }
        if (-not $st) { $out.Ok = $false; $out.Fail = "$nm não responde ($([string]$p.check) saiu com $($chk.exit)) e guards.json → run.prereqs não declara o 'start'"; return $out }
        $ws = if ($p.PSObject.Properties['waitSec'] -and [int]$p.waitSec -gt 0) { [int]$p.waitSec } else { 120 }
        $null = Invoke-Bounded $Root $st 60 -KeepDescendants
        $fim = (Get-Date).AddSeconds($ws); $ok = $false
        while (-not $ok -and (Get-Date) -lt $fim) { Start-Sleep -Seconds 5; $ok = ((Invoke-Bounded $Root ([string]$p.check) 30).exit -eq 0) }
        if (-not $ok) { $out.Ok = $false; $out.Fail = "$nm não subiu em $ws s pelo 'start' de guards.json → run.prereqs"; return $out }
        $out.Lines += "$nm estava desligado — subiu pelo 'start' de guards.json → run.prereqs"
    }
    return $out
}

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
# v3.65.4 (regra 34 do plan.ps1): as decisões do sprint que chegam ao plano — citadas em **Decisões:** ou com o ID da Task no
# **Vale para** (o "todas" sozinho não basta: é regra condicional) — e mudam como o aceite se prova. Devolve uma frase por
# decisão: "a D-<k> prova os cenários por <script>" (frase de prova — "se provam pelo", "provado pelo", "prova pelo", "prova
# cruzada", "executor do projeto" — e um script que não é do plugin, no título ou no corpo) ou "a D-<k> dispensa o aceite".
# Medido nas decisões dos sprints 5 e 6 do garden: só as que mandam provar por script do projeto ou dispensar o aceite.
function Get-AcceptDecisionHits([string]$Root, [string]$PlanPath, [string]$PlanText) {
    $sm = [regex]::Match(([string]$PlanPath -replace '\\', '/'), '/sprints/(\d+)/plan/([^/]+)$')
    if (-not $sm.Success) { return @() }
    $tid = ([regex]::Match($sm.Groups[2].Value, '^' + $script:TaskIdRe)).Value
    $refs = @(Get-PlanDecisionRefs $PlanText)
    $plug = @(Get-ChildItem -LiteralPath $PSScriptRoot -File -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch '[\\/]tests[\\/]' } | ForEach-Object { $_.Name.ToLowerInvariant() })
    $proofRe = '(?i)(\bse\s+prova[mr]?\s+pel[oa]\b|\bprovad[oa]s?\s+pel[oa]\b|\bprova\s+cruzada\b|\bexecutor\s+do\s+projeto\b|\bprova\s+pel[oa]\b)'
    $acRe = '(?:\baccept(?:\.ps1)?\b|\baceite\b)'
    $out = @()
    foreach ($d in @(Get-SprintDecisions $Root $sm.Groups[1].Value)) {
        if (-not (($refs -contains $d.Id) -or ($tid -and @($d.Ids) -contains $tid))) { continue }
        $all = $d.Title + "`n" + $d.Body
        $sc = @([regex]::Matches($all, '[\w./\\-]+\.(?:mjs|cjs|js|ps1|py|sh|rb)\b') | ForEach-Object { $_.Value } | Where-Object { $plug -notcontains ([System.IO.Path]::GetFileName($_)).ToLowerInvariant() } | Select-Object -Unique)
        if ($sc.Count -and $all -match $proofRe) { $out += "a $($d.Id) prova os cenários por $($sc[0])"; continue }
        $wv = @($all -split "`r?`n" | Where-Object { $_ -match "(?i)$acRe.*\bn[ãa]o\s+rod(a|ar|e)\b" -or $_ -match "(?i)\bn[ãa]o\s+rod(a|ar)\b.*$acRe" -or $_ -match "(?i)$acRe[``*:\s]*dispensad[oa]\b" })
        if ($wv.Count) { $out += "a $($d.Id) dispensa o aceite" }
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
        if ($line -match '^\*\*Decis[ãa]o do (?:(?:🔺\s*)?GAP|stakeholder)\b[^*]*:\*\*') { if ($cur) { $out += $cur }; $cur = [pscustomobject]@{ Head = $line.Trim(); Text = $line }; continue }
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

# ============================ v3.63.0 · portão do QA por marcos ============================
# Origem: sprint 6 do projeto piloto (15–17/11/2026) — 3 rodadas do portão reprovadas, quase todas por ambiente; cada
# rodada refez a qualidade inteira e os 49 cenários; o validation.md citava prova que a rodada seguinte apagou.
# O mesmo filtro de arquivo de teste do plan.ps1 (regra dos arquivos tocados).
$script:TestPathRe = '(^|/)(tests?|specs?|__tests__)/|(^|/)test_[^/]+$|[._-](test|tests|spec|specs)\.[^/]+$|tests?\.[^/.]+$'
# Causa de um achado do portão ou de um 🔺 GAP do dev — uma lista só (nomes em inglês, decisão do stakeholder de 17/11).
# v3.65.13 (garden SC-142): 'executor' — a ferramenta de prova do plugin falhou (o toque que o navegador recusa, "Position out
# of bounds", o elemento que o executor não alcança), nem o app nem o .scn. Antes ela virava 'scenario', e o QA trocava o passo
# duas vezes contra um defeito que não era do passo.
$script:Causes = @('code', 'design', 'scenario', 'screen', 'requirement', 'environment', 'appearance', 'process', 'executor')
$script:CauseOwner = @{ code = 'developer'; design = 'architect'; scenario = 'quality-assurance'; screen = 'user-experience'; requirement = 'product-owner'; environment = 'operator'; appearance = 'architect'; process = 'architect'; executor = 'quality-assurance' }
# Ordem das rotas no portão (série R1): decisão de produto e de tela antes, porque muda o que o dev vai corrigir.
$script:CauseOrder = @('requirement', 'screen', 'design', 'executor', 'scenario', 'code')
# Causa a partir do texto (o valor em inglês ou o nome antigo em português — sinônimos para relatório anterior à v3.63.0).
# '' quando não é nenhuma.
function ConvertTo-Cause([string]$Value) {
    $v = ((([string]$Value) -replace '[`*]', '').Trim().ToLowerInvariant() -split '[\s·—–,;:(]')[0]
    if ($v -match '^(code|c[óo]digo)$') { return 'code' }
    if ($v -match '^(design|desenho)$') { return 'design' }
    if ($v -match '^(scenario|cen[áa]rio)$') { return 'scenario' }
    if ($v -match '^(screen|tela)$') { return 'screen' }
    if ($v -match '^(requirement|requisito|produto)$') { return 'requirement' }
    if ($v -match '^(environment|ambiente)$') { return 'environment' }
    if ($v -match '^(appearance|apar[êe]ncia)$') { return 'appearance' }
    if ($v -match '^(process|processo)$') { return 'process' }
    if ($v -match '^(executor|ferramenta|tool)$') { return 'executor' }
    return ''
}
# Máscara de caminho (src/**, *.mjs, pasta/arquivo) → regex sobre o caminho relativo com '/'. Sem curinga = a pasta ou o arquivo.
function ConvertTo-GlobRegex([string]$Glob) {
    $g = (([string]$Glob -replace '\\', '/').Trim() -replace '^\./', '').TrimEnd('/')
    if (-not $g) { return $null }
    if ($g -notmatch '[*?]') { return '^' + [regex]::Escape($g) + '(/|$)' }
    $sb = New-Object System.Text.StringBuilder
    for ($i = 0; $i -lt $g.Length; $i++) {
        $c = $g[$i]
        if ($c -eq '*' -and $i + 1 -lt $g.Length -and $g[$i + 1] -eq '*') {
            if ($i + 2 -lt $g.Length -and $g[$i + 2] -eq '/') { [void]$sb.Append('(.*/)?'); $i += 2 } else { [void]$sb.Append('.*'); $i++ }
        } elseif ($c -eq '*') { [void]$sb.Append('[^/]*') }
        elseif ($c -eq '?') { [void]$sb.Append('[^/]') }
        else { [void]$sb.Append([regex]::Escape([string]$c)) }
    }
    return '^' + $sb.ToString() + '$'
}
# Ferramenta de prova e scripts do projeto que não são produto (guards.json → quality.toolingPaths): mudar só eles não vence
# o julgamento de código nem a qualidade medida (Q-S6c do piloto mexeu só em source/scripts/alvo/ e o portão refez tudo).
function Get-ToolingPaths([string]$Root) {
    $gp = Join-Path $Root '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $gp)) { return @() }
    try { $q = (Read-Text $gp | ConvertFrom-Json).quality; if ($q -and $q.PSObject.Properties['toolingPaths']) { return @(@($q.toolingPaths) | Where-Object { $_ } | ForEach-Object { [string]$_ }) } } catch { }
    return @()
}
# Impressão da árvore DE PRODUÇÃO: a de Get-WorkTree sem os arquivos de teste e sem quality.toolingPaths — ou, com -Only,
# só os arquivos dessas máscaras (targets.web.appSources). 'prod:<12>' (ou 'only:<12>'); $null fora de um repositório git.
function Get-ProductionTree([string]$Root, [string[]]$Only = @()) {
    $tree = Get-WorkTree $Root
    if (-not $tree) { return $null }
    $ErrorActionPreference = 'Continue'
    $top = & git -C $Root rev-parse --show-toplevel 2>$null
    $lines = @(& git -C $top -c core.quotePath=false ls-tree -r --full-tree $tree 2>$null)
    $onlyRe = @($Only | Where-Object { $_ } | ForEach-Object { ConvertTo-GlobRegex $_ } | Where-Object { $_ })
    $toolRe = @(Get-ToolingPaths $Root | ForEach-Object { ConvertTo-GlobRegex $_ } | Where-Object { $_ })
    $keep = foreach ($ln in $lines) {
        $p = ([string]$ln -split "`t", 2)[1]; if (-not $p) { continue }
        if ($onlyRe.Count) { if (@($onlyRe | Where-Object { $p -match $_ }).Count) { $ln } ; continue }
        if ($p -match $script:TestPathRe) { continue }
        if (@($toolRe | Where-Object { $p -match $_ }).Count) { continue }
        $ln
    }
    return ($(if ($onlyRe.Count) { 'only:' } else { 'prod:' }) + (Get-TextHash (@($keep) -join "`n")))
}
function Get-TextHash([string]$Text) {
    $sha = New-Object System.Security.Cryptography.SHA1Managed
    try { return ([System.BitConverter]::ToString($sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes([string]$Text))) -replace '-', '').Substring(0, 12).ToLowerInvariant() } finally { $sha.Dispose() }
}
function Get-FileHash12([string]$Path) {
    if (-not $Path -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    $sha = New-Object System.Security.Cryptography.SHA1Managed; $fs = [System.IO.File]::OpenRead($Path)
    try { return ([System.BitConverter]::ToString($sha.ComputeHash($fs)) -replace '-', '').Substring(0, 12).ToLowerInvariant() } finally { $fs.Dispose(); $sha.Dispose() }
}
# Impressão do conjunto de arquivos de cenário (nome + conteúdo) — o QA corrigir um .scn vence a frente funcional.
function Get-ScenarioSetHash([string[]]$Files) {
    $parts = foreach ($f in @($Files | Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Leaf) } | Sort-Object)) { [System.IO.Path]::GetFileName($f) + "`n" + (Read-Text $f) }
    return (Get-TextHash (@($parts) -join "`n----`n"))
}
function Get-SprintScenarioFiles([string]$Root) { return @(Get-ChildItem -Path (Join-Path $Root '.team-project/quality-assurance/scenarios') -Filter '*.scn' -File -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }) }
# Estado do portão do sprint (sprints/<n>/gate.json) — escrito só pelo run.ps1; o validation.md continua do QA.
#   round       a rodada do QA em curso (0 = nenhum julgamento disparado)
#   judged      as bases que o QA julgou na última rodada disparada: prod (árvore de produção), scn (cenários), accept/quality (hora do result.json)
#   env         tentativas de reparo do alvo do portão (attempts) e a hora do accept que as contou (at)
#   proof       a última rodada copiada para sprints/<n>/proof/
#   routed      achado → vezes que o dono foi disparado sem gravar a resolução
#   stall       v3.65.8: medições do portão encerradas por POSSÍVEL TRAVAMENTO (regra 5: a 1ª sem formulário, a 2ª ao stakeholder)
#   routedAt    v3.65.9: achado → o disparo contado por último (rodada do validation.md | hora do gate/<ID>.md); o next repetido não soma
#   routedFail  v3.65.9: achado → a falha dos cenários dele naquele disparo; falha que mudou zera a conta (progresso)
#   escalated   v3.65.9: achado → o disparo em que foi ao Arquiteto (degrau 1), antes do stakeholder
#   staleApp    v3.65.10: o app recusado (app, at, times); v3.65.12: asked = o accept cuja reconstrução foi pedida, arc = o
#               accept que foi ao Arquiteto (o impasse do build é do time; o stakeholder só depois dele)
function Get-GateState([string]$S) {
    $st = [ordered]@{ round = 0; judged = $null; env = [ordered]@{ attempts = 0; at = ''; asked = ''; sent = 0; sentAt = '' }; proof = 0; routed = [ordered]@{}; stall = 0; routedAt = [ordered]@{}; routedFail = [ordered]@{}; escalated = [ordered]@{}; staleApp = $null; noop = '' }
    $p = Join-Path $S 'gate.json'
    if (Test-Path -LiteralPath $p) {
        try {
            $j = Read-Text $p | ConvertFrom-Json
            if ($j.PSObject.Properties['round']) { $st.round = [int]$j.round }
            if ($j.PSObject.Properties['judged'] -and $j.judged) { $st.judged = [ordered]@{}; foreach ($pp in $j.judged.PSObject.Properties) { $st.judged[$pp.Name] = [string]$pp.Value } }
            if ($j.PSObject.Properties['env'] -and $j.env) {
                $st.env.attempts = [int]$j.env.attempts; $st.env.at = [string]$j.env.at; if ($j.env.PSObject.Properties['asked']) { $st.env.asked = [string]$j.env.asked }
                if ($j.env.PSObject.Properties['sent']) { $st.env.sent = [int]$j.env.sent; $st.env.sentAt = [string]$j.env.sentAt }   # v3.63.1
            }
            if ($j.PSObject.Properties['proof']) { $st.proof = [int]$j.proof }
            if ($j.PSObject.Properties['routed'] -and $j.routed) { foreach ($pp in $j.routed.PSObject.Properties) { $st.routed[$pp.Name] = [int]$pp.Value } }
            if ($j.PSObject.Properties['stall']) { $st.stall = [int]$j.stall }   # v3.65.8
            if ($j.PSObject.Properties['staleApp'] -and $j.staleApp) { $st.staleApp = [ordered]@{ app = [string]$j.staleApp.app; at = [string]$j.staleApp.at; times = [int]$j.staleApp.times; asked = $(if ($j.staleApp.PSObject.Properties['asked']) { [string]$j.staleApp.asked } else { '' }); arc = $(if ($j.staleApp.PSObject.Properties['arc']) { [string]$j.staleApp.arc } else { '' }) } }   # v3.65.10; v3.65.12: asked/arc
            if ($j.PSObject.Properties['noop'] -and $j.noop) { $st.noop = [string]$j.noop }   # v3.65.11: Q-S sem mudança já medidas de novo
            foreach ($mk in 'routedAt', 'routedFail', 'escalated') { if ($j.PSObject.Properties[$mk] -and $j.$mk) { foreach ($pp in $j.$mk.PSObject.Properties) { $st[$mk][$pp.Name] = [string]$pp.Value } } }   # v3.65.9
        } catch { }
    }
    return $st
}
function Set-GateState([string]$S, $State) {
    [System.IO.File]::WriteAllText((Join-Path $S 'gate.json'), ($State | ConvertTo-Json -Depth 5), (New-Object System.Text.UTF8Encoding($false)))
}

# ---------- v3.63.1 · diagnóstico automático da falha de cenário do aceite ----------
# Sprint 6 do projeto piloto (18/11): o SC-118 falhou duas vezes ("a conexão com a página caiu", a captura na aba errada), o
# cenário seguinte parou em "app não ficou na frente, foco: nenhum" e o accept saiu 4 — o next tratou como ambiente, sem
# diagnóstico, e a revisão parou à espera do stakeholder. Toda falha de cenário passa pelo operator (AMBIENTE · APP · PLANO)
# ANTES de virar ambiente ou veredito: APP vai ao dev como defeito; PLANO volta ao dono do cenário (QA) ou ao Arquiteto com o
# elemento a tocar e onde ele fica na tela. Só a interrupção sem sinal do app (alvo fora do ar, janela do sistema) segue
# direto para o reparo.
# O result.json do accept pede diagnóstico? @{ Need; Failed (ids FALHOU); Signal (o sinal da interrupção, '' sem) }.
function Get-AcceptDiagnosisNeed($Aj) {
    $out = [pscustomobject]@{ Need = $false; Failed = @(); Signal = '' }
    if (-not $Aj) { return $out }
    if ($Aj.PSObject.Properties['configuration'] -and $Aj.configuration) { return $out }   # configuração do alvo: vai ao stakeholder
    if ($Aj.PSObject.Properties['startState'] -and $Aj.startState) { return $out }         # estado de partida: idem
    $out.Failed = @(@($Aj.results) | Where-Object { $_ -and [string]$_.status -eq 'FALHOU' } | ForEach-Object { [string]$_.id })
    $sg = if ($Aj.PSObject.Properties['environmentSignal'] -and $Aj.environmentSignal) { $Aj.environmentSignal } else { $null }
    if ($sg -and [string]$sg.kind -and [string]$sg.kind -ne 'system-window') { $out.Signal = "$([string]$sg.kind): $([string]$sg.text)" }
    $out.Need = [bool]($out.Failed.Count -or $out.Signal)
    return $out
}
# O diagnóstico gravado DEPOIS do result.json do accept (o da rodada): @{ Verdict; Owner (QA|Arquiteto|''); Element; Where;
# Lines } ou $null (sem diagnóstico, ou mais velho que a rodada).
function Read-AcceptDiagnosis([string]$DiagPath, [string]$ResultPath) {
    if (-not (Test-Path -LiteralPath $DiagPath)) { return $null }
    if ($ResultPath -and (Test-Path -LiteralPath $ResultPath) -and (Get-Item -LiteralPath $DiagPath).LastWriteTime -lt (Get-Item -LiteralPath $ResultPath).LastWriteTime) { return $null }
    $t = Read-Text $DiagPath
    $vm = [regex]::Match($t, '(?im)^\W*Veredito\W*\s*(AMBIENTE|APP|PLANO)')
    if (-not $vm.Success) { return $null }
    $line = { param($k) $m = [regex]::Match($t, "(?im)^\W*$k\W*:\s*(.+)$"); if ($m.Success) { $m.Groups[1].Value.Trim().TrimEnd('*').Trim() } else { '' } }
    $own = & $line 'Dono'
    $ownN = if ($own -match '(?i)arquitet|architect') { 'Arquiteto' } elseif ($own -match '(?i)\bQA\b|quality|cen[áa]rio') { 'QA' } else { '' }
    $out = [pscustomobject]@{ Verdict = $vm.Groups[1].Value.ToUpperInvariant(); Owner = $ownN; Element = (& $line 'Elemento'); Where = (& $line 'Onde'); Reason = (& $line 'Motivo'); FreshGap = '' }
    # v3.65.10 (item C): APP só com o app do aparelho conferido com o build da árvore — sem isso, vale PLANO com o Arquiteto.
    if ($out.Verdict -eq 'APP' -and $ResultPath -and (Test-Path -LiteralPath $ResultPath)) {
        $gap = ''; try { $gap = Get-AcceptFreshGap (Read-Text $ResultPath | ConvertFrom-Json) } catch { }
        if ($gap) { $out.Verdict = 'PLANO'; $out.Owner = 'Arquiteto'; $out.FreshGap = $gap; $out.Reason = "build não conferido — $gap (o operator disse APP: $($out.Reason))" }
    }
    return $out
}
# O prompt do operator para o diagnóstico (Task e portão). $Caller = "executor T-041" | "sessão S6".
function Get-AcceptDiagPrompt([string]$Caller, [string]$Id, [string]$AccRel, [string]$DiagRel, [string]$Tn, [string]$Plugin, $Need) {
    $what = @()
    if ($Need -and @($Need.Failed).Count) { $what += "cenário(s) que falharam: $(@($Need.Failed) -join ', ')" }
    if ($Need -and $Need.Signal) { $what += "interrupção com sinal do app: $($Need.Signal)" }
    $foco = if ($what.Count) { " ($($what -join ' · '))" } else { '' }
    return "Chamador: $Caller — Diagnostique a falha da prova no alvo da $Id$foco. Leia $AccRel/result.md e result.json (o campo signal de cada cenário e o environmentSignal), abra com Read as capturas *-falha.png que ele cita e o registro do aparelho de cada falha ($AccRel/logs/*-logcat.txt: FATAL EXCEPTION, ANR, crash da WebView); rode $Plugin/target.ps1 -Target $Tn (só a conferência, sem -Repair). Grave $DiagRel com as linhas: 'Veredito: AMBIENTE | APP | PLANO', 'Cenário: <ID>', 'Motivo: <crash | ANR | app reiniciado | WebView recriada | janela do sistema | tela errada | elemento ausente | valor errado>', e, com APP ou PLANO, 'Elemento: <o id a tocar ou a conferir>', 'Onde: <tela, aba e posição na captura — ex.: aba Estufa, 2º cartão, botão à direita>' e, com PLANO, 'Dono: QA' (o .scn está errado ou não volta à tela depois de recriar a WebView ou reabrir o app) ou 'Dono: Arquiteto' (o contrato de ids ou o plano pede o que nenhuma Task cria), e a linha 'App: <fresh.installed do result.json> · build: <fresh.build.path e fresh.build.hash, ou sem APK local> · frescor: conferido | não conferido'; depois até 5 linhas do que viu. APP só com o campo fresh.checked = true no result.json (alvo android): com fresh.checked = false, o elemento ausente pode ser o app de antes da mudança — grave 'Veredito: PLANO', 'Dono: Arquiteto' e 'Motivo: build não conferido — <fresh.reason>' (v3.65.10; o run trata APP sem frescor como PLANO). APP =a tela certa estava aberta e o elemento, o texto ou o valor faltou, ou o registro mostra crash/ANR do app, ou o app perdeu o estado que devia manter. PLANO = o cenário supõe o que o app legitimamente não faz (estado que a plataforma zera ao recriar a WebView ou reabrir o app) ou pede o que nenhuma Task cria; não deu para ver, PLANO dizendo o que faltou. AMBIENTE SÓ com prova: janela do sistema na captura ou no foco, alvo fora do ar, tela em branco, outro automatizador — app reiniciado ou foco 'nenhum' sozinhos NÃO são prova de ambiente. Não altere código, cenário nem plano; não rode accept nem verify. Volte com a linha do veredito."
}
# Achados e frentes do validation.md no formato da v3.63.0 — tabela com as colunas ID e Cause (ou State) e linhas S<n>-F<k>;
# a ÚLTIMA ocorrência de cada ID vale (a tabela da rodada nova só traz ID e State). Frentes: tabela com Front e State.
# @{ HasTable; Findings = [ordered] id → @{ id; task; text; cause; state }; Fronts = [ordered] front → state }.
function Read-ValidationFindings([string]$Path) {
    $out = @{ HasTable = $false; Findings = [ordered]@{}; Fronts = [ordered]@{} }
    if (-not $Path -or -not (Test-Path -LiteralPath $Path)) { return $out }
    $col = { param($t, $name) for ($i = 0; $i -lt $t.Header.Count; $i++) { if ($t.Header[$i] -ieq $name) { return $i } }; return -1 }
    foreach ($t in (Get-Tables (Read-Text $Path))) {
        $fi = & $col $t 'Front'; $si = & $col $t 'State'
        if ($fi -ge 0 -and $si -ge 0) {
            foreach ($row in $t.Rows) { $fn = (Clean-Cell (Get-Cell $row $fi)).ToLowerInvariant(); if ($fn -match '^[a-z]+$') { $out.Fronts[$fn] = (Clean-Cell (Get-Cell $row $si)).ToLowerInvariant() } }
            continue
        }
        $ii = & $col $t 'ID'; $ci = & $col $t 'Cause'
        if ($ii -lt 0 -or ($ci -lt 0 -and $si -lt 0)) { continue }
        if ($ci -ge 0) { $out.HasTable = $true }
        $ti = & $col $t 'Task'; $ai = & $col $t 'Achado'
        foreach ($row in $t.Rows) {
            $id = Clean-Cell (Get-Cell $row $ii); if ($id -notmatch '^S\d+-F\d+$') { continue }
            if (-not $out.Findings.Contains($id)) { $out.Findings[$id] = @{ id = $id; task = ''; text = ''; cause = ''; state = 'open' } }
            $f = $out.Findings[$id]
            if ($ti -ge 0 -and (Clean-Cell (Get-Cell $row $ti))) { $f.task = Clean-Cell (Get-Cell $row $ti) }
            if ($ai -ge 0 -and (Clean-Cell (Get-Cell $row $ai))) { $f.text = Clean-Cell (Get-Cell $row $ai) }
            if ($ci -ge 0) { $cv = Clean-Cell (Get-Cell $row $ci); if ($cv) { $f.cause = ConvertTo-Cause $cv; if (-not $f.cause) { $f.cause = "?$cv" } } }
            if ($si -ge 0) { $sv = (Clean-Cell (Get-Cell $row $si)).ToLowerInvariant(); if ($sv) { $f.state = ($sv -split '[\s·—–(]')[0] } }
        }
    }
    return $out
}
# A resolução que o dono gravou para um achado (sprints/<n>/gate/<ID>.md, linha **Resolution:** done|code|debt — <texto>).
# @{ value; text; at } ou $null.
function Get-FindingResolution([string]$S, [string]$Id) {
    $p = Join-Path $S "gate/$Id.md"
    if (-not (Test-Path -LiteralPath $p)) { return $null }
    # v3.65.13: a ÚLTIMA linha — quem resolve depois acrescenta sem apagar (Arquiteto, PO, a resposta do stakeholder).
    $ms = [regex]::Matches((Read-Text $p), '(?im)^\*\*Resolution:\*\*\s*(done|code|debt)\b\s*[—–-]?\s*([^\r\n]*)')
    if (-not $ms.Count) { return @{ value = ''; text = ''; at = (Get-Item -LiteralPath $p).LastWriteTime } }
    $m = $ms[$ms.Count - 1]
    return @{ value = $m.Groups[1].Value.ToLowerInvariant(); text = $m.Groups[2].Value.Trim(); at = (Get-Item -LiteralPath $p).LastWriteTime }
}
# v3.65.13 (garden SC-142: a escolha entre dois passos de teste chegou ao stakeholder). A escada do portão passa pelo PO antes do
# stakeholder, e só sobe o que muda o produto. No gate/<ID>.md: **Para o PO:** <a decisão de produto e as opções> (o Arquiteto ou
# o dono, quando nenhuma saída técnica serve) e **Stakeholder:** <a pergunta> — **Muda para o usuário:** <o que muda em cada
# opção> (só o PO). Sem o "Muda para o usuário" preenchido, a pergunta não conta: o que não muda o produto, o time decide.
# pending: a pergunta ainda sem resposta (nenhuma linha **Resolution:** depois dela) — o achado não conta como resolvido pela
# resolução de antes. @{ po; ask; impact; pending } — textos vazios quando não há.
function Get-FindingEscalation([string]$S, [string]$Id) {
    $out = @{ po = ''; ask = ''; impact = ''; pending = $false }
    $p = Join-Path $S "gate/$Id.md"
    if (-not (Test-Path -LiteralPath $p)) { return $out }
    $t = Read-Text $p
    $m = [regex]::Match($t, '(?im)^\*\*Para o PO:\*\*\s*([^\r\n]*)'); if ($m.Success) { $out.po = $m.Groups[1].Value.Trim() }
    $ms = [regex]::Matches($t, '(?im)^\*\*Stakeholder:\*\*\s*([^\r\n]*?)\s*[—–-]?\s*\*\*Muda para o usu[áa]rio:\*\*\s*([^\r\n]*)')
    if ($ms.Count) {
        $m = $ms[$ms.Count - 1]; $imp = $m.Groups[2].Value.Trim()
        if ($imp -and $imp -notmatch '^(?i)(nada|nenhum|nenhuma|none|n/?a|—|-)(\b|\s|$)') {
            $out.ask = $m.Groups[1].Value.Trim(); $out.impact = $imp
            $out.pending = -not [regex]::IsMatch($t.Substring($m.Index + $m.Length), '(?im)^\*\*Resolution:\*\*\s*(done|code|debt)\b')
        }
    }
    return $out
}
# v3.65.5 (sprint 6 do projeto piloto, 21/11): a parte do cenário de uma resolução `code` — o app muda na Q-S<n> e DEPOIS o
# QA ajusta o .scn. No piloto, o S6-F10 e o S6-F15 diziam "o QA troca nos SC-264…" e "depois o QA acrescenta ao SC-161…",
# a Q-S fechou e ninguém aplicou a metade do teste. Fonte: a linha **Scenario:** <SC e o que muda> do gate/<ID>.md; sem ela,
# o texto da resolução que manda o QA mexer num SC-<n> ou num .scn. Aplicada = a linha **Scenario applied:** que o QA grava.
# @{ need; text; applied } — need: há parte do cenário e ela ainda não foi aplicada.
function Get-FindingScenarioPart([string]$S, [string]$Id) {
    $out = @{ need = $false; text = ''; applied = $false }
    $p = Join-Path $S "gate/$Id.md"
    if (-not (Test-Path -LiteralPath $p)) { return $out }
    $t = Read-Text $p
    $r = Get-FindingResolution $S $Id
    if (-not $r -or $r.value -ne 'code') { return $out }
    $out.applied = [regex]::IsMatch($t, '(?im)^\*\*Scenario applied:\*\*')
    $ln = [regex]::Match($t, '(?im)^\*\*Scenario:\*\*\s*([^\r\n]*)')
    if ($ln.Success) {
        $v = $ln.Groups[1].Value.Trim()
        if ($v -and $v -notmatch '^(?i)(nenhum|nenhuma|none|n/?a|—|-)(\b|\s|$)') { $out.text = $v }
    } elseif ($r.text -match '(?i)\bQA\b[^.;]{0,120}?(SC-\d+|\.scn\b)') { $out.text = $r.text }
    $out.need = [bool]$out.text -and -not $out.applied
    return $out
}
# Prova guardada (decisão do stakeholder de 17/11): result.json, result.md, progress.json e as capturas (.png de shots/ e de
# cmd/ do executor do projeto) de uma pasta de medição para a pasta do sprint, sem os logs brutos. Devolve quantos arquivos.
function Copy-Proof([string]$Src, [string]$Dst) {
    if (-not (Test-Path -LiteralPath $Src -PathType Container)) { return 0 }
    $k = 0
    # A base vem do próprio Get-Item: o caminho pedido pode ter "/" misturado ou o nome curto do Windows (MARCOA~1), e o recorte
    # pelo tamanho dele cortava errado (a prova saía em accept/accept/1/S1/).
    $base = (Get-Item -LiteralPath $Src).FullName.TrimEnd('\', '/')
    # v3.63.1: o registro do aparelho de cada falha (logs/*-logcat.txt) é prova do veredito, não log bruto do comando.
    foreach ($f in @(Get-ChildItem -LiteralPath $base -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -in 'result.json', 'result.md', 'progress.json' -or $_.Extension -ieq '.png' -or $_.Name -match '-logcat\.txt$' })) {
        $rel = $f.FullName.Substring($base.Length).TrimStart('\', '/')
        $to = Join-Path $Dst $rel
        New-Item -ItemType Directory -Force (Split-Path $to) | Out-Null
        Copy-Item -LiteralPath $f.FullName -Destination $to -Force; $k++
    }
    return $k
}
# v3.63.0: nomes simples para quem acompanha (kanban.md, /team-status) — causas, donos e frentes.
$script:CausePlain = @{ code = 'código do app'; design = 'desenho técnico'; scenario = 'teste (cenário)'; screen = 'tela'; requirement = 'regra ou critério'; environment = 'aparelho ou ambiente'; appearance = 'medida ou marcação'; process = 'processo do time'; executor = 'ferramenta de teste do time' }
$script:OwnerPlain = @{ developer = 'desenvolvedor'; architect = 'arquiteto'; 'quality-assurance' = 'qualidade'; 'user-experience' = 'UX'; 'product-owner' = 'dono do produto'; operator = 'operador do aparelho' }
$script:FrontPlain = [ordered]@{ functional = 'funcional (testes no aparelho)'; measured = 'qualidade medida'; review = 'revisão do código'; security = 'segurança' }
$script:FindingStatePlain = @{ open = 'aberto'; fixed = 'resolvido'; debt = 'aceito como dívida'; wontfix = 'não será feito' }
# Resumo do portão para quem acompanha: $null antes do portão (sem validation.md nem gate.json).
# @{ Round; Verdict (marca); Fronts = [ordered] nome simples → estado; Findings = lista @{ Id; Text; Cause; Owner; State }; EnvAttempts; Proof }
function Get-GateSummary([string]$S, [string]$n) {
    $val = Join-Path $S 'validation.md'; $gp = Join-Path $S 'gate.json'
    if (-not (Test-Path -LiteralPath $val) -and -not (Test-Path -LiteralPath $gp)) { return $null }
    $g = Get-GateState $S
    $vf = Read-ValidationFindings $val
    $vm = $null; $vr = 0
    if (Test-Path -LiteralPath $val) { $ms = @([regex]::Matches((Read-Text $val), '(?m)^\*\*Veredito[^*\r\n]*:\*\*(.*)$')); $vr = $ms.Count; if ($ms.Count) { $vm = Get-VerdictMark $ms[$ms.Count - 1].Groups[1].Value } }
    $fr = [ordered]@{}; foreach ($k in $script:FrontPlain.Keys) { if ($vf.Fronts.Contains($k)) { $fr[$script:FrontPlain[$k]] = $vf.Fronts[$k] } }
    $fs = @(foreach ($f in $vf.Findings.Values) {
        $c = [string]$f.cause; $o = if ($script:CauseOwner.ContainsKey($c)) { $script:CauseOwner[$c] } else { '' }
        [pscustomobject]@{ Id = $f.id; Text = [string]$f.text; Cause = $(if ($script:CausePlain.ContainsKey($c)) { $script:CausePlain[$c] } else { 'sem causa' }); Owner = $(if ($o -and $script:OwnerPlain.ContainsKey($o)) { $script:OwnerPlain[$o] } else { '—' }); State = $(if ($script:FindingStatePlain.ContainsKey([string]$f.state)) { $script:FindingStatePlain[[string]$f.state] } else { [string]$f.state }) }
    })
    return [pscustomobject]@{ Round = [Math]::Max([int]$g.round, $vr); Judged = $vr; Verdict = $vm; Fronts = $fr; Findings = $fs; EnvAttempts = [int]$g.env.attempts; Proof = $(if ([int]$g.proof) { "sprints/$n/proof/S$n/round-$([int]$g.proof)/" } else { '' }) }
}