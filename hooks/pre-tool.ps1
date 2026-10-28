# Despachante PreToolUse — fase 1 (v3.39): G1 (R31) · G2 (cópia instalada) · G3 (R22);
# fase 2 (v3.42), por papel (sufixo de agent_type): G5 gate protegido · G6 teste ignorado · G7 Agent só ao operator (R28)
# · G8 matriz de propriedade (hooks/ownership.json) · G9 escopo do dev (R4 · R8) · G11 pasta do job do operator;
# v3.44: G14 permissão operacional do run (.team-project/.active-run) — nenhum pedido de permissão do harness trava um papel;
# v3.47: G17 modelo do papel (.team-project/models.json) — a ferramenta Agent obedece ao modelo configurado;
# G18 modo benchmark (guards.json → bench) — o dossiê responde o AskUserQuestion (bench.foreground ficou sem efeito na v3.52.2:
# o Agent não tem mais run_in_background); perfil Arquiteto executor (M2): com .active-executor e models.json "executor",
# a G8/G9/G6 tratam o Arquiteto como o dev.
# v3.51: G3 exige o exemplo prático (H1); G19 nega SendMessage a papel caro parado há mais de 5 min (C1); o Agent é
# registrado em .active-agents para o hook Stop (G20). v3.52.2: todo Agent (sessão e papel), com session e parent; a G7
# deixa o executor de Task (task-runner) disparar dev, Arquiteto, operator e QA.
# v3.48 (primeiro sprint do piloto): .active-task ilegível nega (antes derrubava o hook); texto entre aspas não é destino;
# destino em variável do mesmo comando se resolve; G14 sem os falsos negados medidos; G11 só no segmento canônico.
# Devolve a PRIMEIRA negação: exit 2 com o motivo no stderr; "allow" (G14) sai em JSON com exit 0. Nenhuma guarda pergunta.
# Qualquer exceção → exit 1 (erro não bloqueante — falha aberta, D5). Cobertura e limites: hooks/COVERAGE.md.

$ErrorActionPreference = 'Stop'
$sw = [System.Diagnostics.Stopwatch]::StartNew()
. (Join-Path $PSScriptRoot 'common.ps1')

function Deny([string]$Guard, [string]$Target, [string]$Reason) {
    Write-GuardLog $script:projectDir $Guard $script:hookInput $Target "deny: $Reason"
    [Console]::Error.WriteLine("[$Guard] $Reason")
    exit 2
}

function Write-Allow([string]$Reason) {
    $out = @{ hookSpecificOutput = @{ hookEventName = 'PreToolUse'; permissionDecision = 'allow'; permissionDecisionReason = "[G14] $Reason" } } | ConvertTo-Json -Depth 4 -Compress
    [Console]::Out.Write($out)
}

# G1 — R31: o git recebe só o produto; .team-project/ nunca entra num commit.
function Test-G1([object]$ToolInput) {
    $cmd = [string]$ToolInput.command
    if ([string]::IsNullOrWhiteSpace($cmd)) { return }
    if ($cmd -match '\bgit\b[^;|&\r\n]*\badd\b[^;|&\r\n]*(\s-f\b|\s--force\b)[^;|&\r\n]*\.team-project') {
        Deny 'G1' '.team-project' "git add forçado de .team-project/ — R31: o processo é local e fica fora do git do projeto. Tire o arquivo do comando."
    }
    if ($cmd -match '\bgit\b[^;|&\r\n]*\bcommit\b') {
        $staged = & git -C $script:projectDir diff --cached --name-only 2>$null
        $hit = @($staged | Where-Object { $_ -like '.team-project/*' })
        if ($hit.Count -gt 0) {
            Deny 'G1' ($hit -join ', ') ("commit com arquivo de .team-project/ no stage (" + ($hit -join ', ') + ") — R31: o processo é local e fica fora do git. Rode: git restore --staged .team-project. Se este é o commit da migração R31 do /team update (git rm --cached .team-project), siga o passo 7b: G1 desligado em .team-project/guards.json só durante o passo.")
        }
    }
}

# G2 — a cópia instalada do plugin é sobrescrita no próximo update; o caminho é o /review no repositório-fonte.
function Test-G2([object]$ToolInput) {
    $root = $env:CLAUDE_PLUGIN_ROOT
    if ([string]::IsNullOrWhiteSpace($root)) { return }
    if (Test-Path -LiteralPath (Join-Path $root '.git')) { return }   # repositório-fonte: liberado
    $file = Normalize-PathText ([string]$ToolInput.file_path)
    $base = Normalize-PathText $root
    if ($file -and ($file -eq $base -or $file.StartsWith($base + '/'))) {
        Deny 'G2' $ToolInput.file_path "escrita na cópia instalada do plugin ($root): ela é sobrescrita no próximo claude plugin update. Mudança de processo vai pelo /review, no clone do repositório-fonte."
    }
}

# G3 — R22: toda pergunta ao stakeholder tem alternativas descritas e "Pedir mais contexto" por último.
# R34 (projeto com "Identificador remoto" no README §1): a pergunta começa com [<ID> · <onde> · <ponto>]
# e esse prefixo já está gravado como pendência em §7 — a pendência sai de §7 ao ser decidida, então só
# o instante do formulário mostra que ela veio antes.
function Test-G3([object]$ToolInput) {
    $remoteId = $null; $pending = ''
    $readme = Join-Path $script:projectDir '.team-project/README.md'
    if (Test-Path -LiteralPath $readme) {
        $rt = [System.IO.File]::ReadAllText($readme, (New-Object System.Text.UTF8Encoding($false)))
        $im = [regex]::Match($rt, '(?m)^\*\*Identificador remoto:\*\*\s*([A-Z]{3,8})\b')
        if ($im.Success) { $remoteId = $im.Groups[1].Value }
        $sm = [regex]::Match($rt, '(?ms)^##\s+7\.\s.*?(?=^##\s|\z)')
        if ($sm.Success) { $pending = $sm.Value }
    }
    foreach ($q in @($ToolInput.questions)) {
        $opts = @($q.options)
        $text = [string]$q.question
        if ($opts.Count -lt 2) {
            Deny 'G3' $text "pergunta com menos de 2 alternativas — R22: cada alternativa viável descrita, e 'Pedir mais contexto' como a última."
        }
        $last = ([string]$opts[-1].label).Trim()
        if ($last -notmatch '^(?i)pedir mais contexto') {
            Deny 'G3' $text "a última opção de '$text' é '$last' — R22: toda pergunta ao stakeholder, até a simples, termina com 'Pedir mais contexto' (descrita como resposta válida, que reabre o time para aprofundar). Refaça o formulário."
        }
        # v3.51 (H1): o stakeholder decide com um exemplo prático na frente — o problema em linguagem simples e um caso
        # concreto do produto, na pergunta ou na descrição de uma opção.
        $all = $text + ' ' + ((@($opts) | ForEach-Object { [string]$_.description }) -join ' ')
        if ($all -notmatch '(?i)\b(exemplo|por exemplo|ex\.:|ex:|e\.g\.|for example|example)') {
            Deny 'G3' $text "H1 (v3.51): a pergunta '$text' não traz um exemplo prático. Diga o problema em uma ou duas frases, sem sigla nem nome de regra, e um exemplo concreto do produto ('Exemplo: hoje, se o usuário …'), o que muda em cada opção (na descrição) e a recomendação primeiro (roles/scrum-master/templates/stakeholder-question.md). Refaça o formulário."
        }
        if ($remoteId) {
            $pm = [regex]::Match($text, '^\s*(\[' + [regex]::Escape($remoteId) + ' · [^\]]+\])')
            if (-not $pm.Success) {
                Deny 'G3' $text "R34: neste projeto (Identificador remoto $remoteId) toda pergunta começa com [$remoteId · <onde> · <ponto>] — ex.: [$remoteId · S4 · ③ pacote]. Refaça o formulário."
            }
            if (-not $pending.Contains($pm.Groups[1].Value)) {
                Deny 'G3' $text ("R34: grave antes a pendência em .team-project/README.md §7 — 'N. " + $pm.Groups[1].Value + " <pergunta> — material: <ponteiro> — aaaa-mm-dd hh:mm' — e só então chame o formulário (R5).")
            }
        }
    }
}

# G19 (v3.51, C1) — a sessão não retoma por SendMessage um papel caro parado há mais de 5 min: o cache do subagente dura
# 5 min, e a retomada regrava todo o contexto dele (P-r6: Arquiteto 7×, US$ 3,4; PO, UX e SM, US$ 1,5). Instância nova
# com o cartão de passagem (run.ps1 handoff) custa menos. Haiku (dev, operator) segue retomável: a regravação é barata.
function Test-G19([object]$ToolInput) {
    if ($script:role) { return }                                   # só a sessão principal retoma agentes
    $to = [string]$ToolInput.to; if (-not $to) { return }
    # v3.52 (R27/R29): no run (sprint ou fix) não há retomada por SendMessage, nem de Haiku — ele volta na hora e a sessão
    # passava a sondar o disco (sunscape-P-r1: as esperas da sessão). Retomada = instância nova com o cartão (v3.52.2: dispare
    # e encerre o turno; o aviso reabre a sessão).
    if ($null -ne (Get-Marker $script:projectDir '.active-run')) {
        Deny 'G19' $to "retomada por SendMessage durante o run: o SendMessage volta na hora, o agente segue sozinho e a sessão ficaria sondando o disco. Abra uma instância NOVA com o cartão de passagem (run.ps1 start -Task <ID> regera o cartão e o prompt do dev; GAP: run.ps1 done -Result gap), dispare e encerre o turno; o aviso reabre a sessão — sprint-run.md §Retomada."
    }
    $u = Join-Path $script:projectDir '.team-project/usage.jsonl'
    if (-not (Test-Path -LiteralPath $u)) { return }
    $last = $null
    foreach ($line in [System.IO.File]::ReadLines($u)) { if ($line.Contains($to)) { try { $o = $line | ConvertFrom-Json; if ([string]$o.agent_id -eq $to) { $last = $o } } catch { } } }
    if ($null -eq $last) { return }
    if ([string]$last.model -match '(?i)haiku' -or [string]$last.role -in @('developer', 'operator')) { return }
    $ts = $null; try { $ts = [datetime]::Parse([string]$last.ts) } catch { return }
    $idle = ((Get-Date) - $ts).TotalMinutes
    if ($idle -gt 5) {
        Deny 'G19' $to ("o $([string]$last.role) ($to) está parado há $([int]$idle) min e o cache dele (5 min) já venceu: retomar regravaria todo o contexto no modelo $([string]$last.model). Abra uma instância NOVA com os caminhos do cartão de passagem (run.ps1 handoff -Task <ID>) e do artefato que motivou a volta (sprint-run.md §Retomada).")
    }
}

# ---------------- Fase 2 — guardas por papel ----------------

# Variáveis atribuídas no próprio comando a um caminho literal (v3.48): $d = "x" · $d = Join-Path (Get-Location) "x" ·
# $d = Join-Path $raiz "x" (com $raiz já resolvida). Outra forma não se resolve — o destino fica de fora, como antes.
# v3.51.4: texto entre aspas duplas com $outra (já resolvida no mesmo comando) se resolve — $job = "$root\.team-project\…"
# (o operator do SunScape teve Add-Content $log negado porque $log saía de $job, que saía de $root).
function Get-CommandVars([string]$Cmd) {
    $vars = @{}
    $q = '(?:''([^'']*)''|"([^"`]*)")'
    $expand = { param($s) $r = [regex]::Replace((Expand-TempVar $s), '\$\{?(\w+)\}?', { param($mm) $k = $mm.Groups[1].Value.ToLowerInvariant(); if ($vars.ContainsKey($k)) { [string]$vars[$k] } else { $mm.Value } }); $r }
    foreach ($m in [regex]::Matches($Cmd, '\$(\w+)\s*=\s*(?:Join-Path\s+(\(Get-Location\)(?:\.Path)?|\$PWD|\$\w+)\s+' + $q + '|' + $q + ')\s*(?=;|\r?\n|$)')) {
        $name = $m.Groups[1].Value.ToLowerInvariant()
        if ($m.Groups[2].Success) {
            $lit = $m.Groups[3].Value + $(if ($m.Groups[4].Success) { & $expand $m.Groups[4].Value } else { '' })
            $base = $m.Groups[2].Value
            if ($base -match '^\$(\w+)$' -and $base -notmatch '^\$PWD$') {
                $bn = $Matches[1].ToLowerInvariant()
                if (-not $vars.ContainsKey($bn)) { continue }
                try { $vars[$name] = (Join-Path $vars[$bn] $lit) } catch { }
            } else { $vars[$name] = $lit }                     # (Get-Location) / $PWD: relativo à pasta corrente
        } elseif ($m.Groups[6].Success) { $vars[$name] = & $expand $m.Groups[6].Value }   # aspas duplas: interpola o que já se conhece
        else { $vars[$name] = $m.Groups[5].Value }
    }
    foreach ($k in @($vars.Keys)) { $vars[$k] = Expand-TempVar ([string]$vars[$k]); if ([string]$vars[$k] -match '\$') { $vars.Remove($k) } }
    return $vars
}

# v3.51.2: $env:TEMP / $env:TMP no começo do caminho vira a pasta temporária — o scratchpad da sessão fica lá.
function Expand-TempVar([string]$Text) {
    if ($Text -notmatch '^(?i)\$env:(TEMP|TMP)\b') { return $Text }
    $tmp = [Environment]::GetEnvironmentVariable($Matches[1]); if (-not $tmp) { $tmp = [System.IO.Path]::GetTempPath() }
    return $tmp.TrimEnd('\', '/') + $Text.Substring($Matches[0].Length)
}

# Alvos de escrita num comando PowerShell (heurística: cmdlets de escrita e redirecionamento). v3.48: o texto entre aspas
# vira marcador antes de procurar cmdlet e ">" — 'ion-item > ion-label' num Select-String não é destino (G8/G9 negavam) —
# e volta ao ser lido como argumento; variável atribuída no mesmo comando a um literal se resolve (Get-CommandVars).
function Get-WriteTargets([string]$Cmd, [hashtable]$Vars = $null) {
    if ($null -eq $Vars) { $Vars = Get-CommandVars $Cmd }
    $qs = New-Object System.Collections.ArrayList
    $masked = [regex]::Replace($Cmd, '"[^"]*"|''[^'']*''', { param($m) [void]$qs.Add($m.Value); "$([char]1)$($qs.Count - 1)$([char]1)" })
    $unmask = { param($s) [regex]::Replace($s, "\x01(\d+)\x01", { param($m) $qs[[int]$m.Groups[1].Value] }) }
    $targets = @()
    foreach ($st in ($masked -split '[;\r\n|]')) {
        $m = [regex]::Match($st, '(?i)\b(Set-Content|Add-Content|Out-File|New-Item|Clear-Content|Remove-Item|Copy-Item|Move-Item)\b(.*)$')
        if ($m.Success) {
            $verb = $m.Groups[1].Value.ToLowerInvariant(); $rest = & $unmask $m.Groups[2].Value
            $flag = if ($verb -in 'copy-item', 'move-item') { 'Destination' } else { 'LiteralPath|Path|FilePath' }
            $fm = [regex]::Match($rest, '(?i)-(?:' + $flag + ')\s+(?:''([^'']*)''|"([^"]*)"|(\S+))')
            if ($fm.Success) { $targets += ($fm.Groups[1].Value + $fm.Groups[2].Value + $fm.Groups[3].Value) }
            else {
                $tokens = @([regex]::Matches($rest, '''([^'']*)''|"([^"]*)"|(\S+)') | ForEach-Object { $_.Groups[1].Value + $_.Groups[2].Value + $_.Groups[3].Value })
                $pos = @(); $skip = $false
                foreach ($tk in $tokens) {
                    if ($skip) { $skip = $false; continue }
                    if ($tk -like '-*') { $skip = $tk -match '^(?i)-(ItemType|Type|Value|Encoding|Filter|Include|Exclude|Name|Width|InputObject|Stream|Delimiter)$'; continue }
                    $pos += $tk
                }
                $idx = if ($verb -in 'copy-item', 'move-item') { 1 } else { 0 }
                if ($pos.Count -gt $idx) { $targets += $pos[$idx] }
            }
        }
        foreach ($rm in [regex]::Matches($st, '>{1,2}(?!&)\s*(\x01\d+\x01|[^\s\x01]+)')) {
            $t = & $unmask $rm.Groups[1].Value
            if ($t -match '^"(.*)"$|^''(.*)''$') { $t = $Matches[1] + $Matches[2] }
            $targets += $t
        }
    }
    # v3.51.4: escrita por .NET ([IO.File]::WriteAllText(<caminho>, …)) — o 1º argumento é destino como o de um cmdlet, e passa
    # pelas mesmas guardas (G5/G8/G9). É a forma natural de gravar UTF-8 sem BOM no 5.1 (o .scn do QA, note.md item 10).
    foreach ($nm in [regex]::Matches($masked, '\[(?:System\.)?IO\.File\]::(?:WriteAll\w+|AppendAll\w+)\s*\(\s*(\x01\d+\x01|\$\{?\w+\}?|[^,\s)]+)')) {
        $t = & $unmask $nm.Groups[1].Value
        if ($t -match '^"(.*)"$|^''(.*)''$') { $t = $Matches[1] + $Matches[2] }
        $targets += $t
    }
    # Variável do mesmo comando ($dir, "$dir\x.log"): troca pelo literal; o que sobrar com $ não se resolve.
    $targets = @($targets | ForEach-Object {
        $t = Expand-TempVar ([string]$_)
        if ($t -match '\$') { $t = [regex]::Replace($t, '\$\{?(\w+)\}?', { param($m) $k = $m.Groups[1].Value.ToLowerInvariant(); if ($Vars.ContainsKey($k)) { $Vars[$k] } else { $m.Value } }) }
        $t
    })
    # v3.44.2: texto com caractere inválido em caminho ("List<T>", "<td>" de uma string) não é arquivo — antes derrubava
    # o IsPathRooted do .NET Framework e o hook falhava aberto sem avaliar G5/G8/G9 (linha "erro" no guards.log).
    $bad = [regex]::Escape(-join [System.IO.Path]::GetInvalidPathChars())
    return @($targets | Where-Object { $_ -and $_ -notmatch '\$' -and $_ -notmatch "[$bad]" })
}

# Alvo num drive do PowerShell que não é de arquivo (Env:, Variable:, HKCU:, Cert:…; letra única = disco): não é arquivo do projeto.
function Test-ProviderDrive([string]$Target) { return $Target -match '^[A-Za-z][\w]+:' }
# Drives da própria sessão: escrever neles não sai do processo (G14 libera).
function Test-SessionDrive([string]$Target) { return $Target -match '^(?i)(env|variable|function|alias):' }

# G5 — arquivo de gate (guards.json → protectedPaths): nenhum subagente altera; a sessão segue o pedido de permissão do harness.
function Test-G5([string]$Rel, [string]$Shown) {
    if (-not $script:role -or -not $Rel) { return }
    if (Test-GlobMatch $Rel $cfg.protectedPaths) {
        Deny 'G5' $Shown "$Rel é arquivo de gate protegido (guards.json → protectedPaths): subagente não altera configuração de gate — gate não se desliga, não se afrouxa, não se contorna (R7; plano §9). Pare e levante 🔺 GAP: o Arquiteto põe o diff em **Arquivos protegidos:** (plano §12) e a sessão principal o aplica, com a permissão do stakeholder (sprint-run.md passo 3)."
    }
}

# Quem escreve código de produto na Task: o dev; e, no perfil executor (v3.47, M2), o Arquiteto com .active-executor.
function Test-CodeWriter {
    if ($script:role -eq 'developer') { return $true }
    return ($script:role -eq 'architect' -and (Test-ExecutorActive $script:projectDir))
}

# G6 — o dev não acrescenta teste ignorado (guards.json → testSkipPatterns).
function Test-G6([object]$ToolInput, [string]$Rel, [string]$Shown) {
    if (-not (Test-CodeWriter) -or -not $Rel) { return }
    if ($Rel -notmatch '(^|/)(tests?|specs?|__tests__)/|(^|/)test_[^/]+$|[._-](test|tests|spec|specs)\.[^/]+$|tests?\.[^/.]+$') { return }
    if ($script:tool -eq 'Edit') { $new = [string]$ToolInput.new_string; $old = [string]$ToolInput.old_string }
    else {
        $new = [string]$ToolInput.content; $old = ''
        $full = Join-Path $script:projectDir $Rel
        if (Test-Path -LiteralPath $full) { $old = [System.IO.File]::ReadAllText($full) }
    }
    foreach ($p in @($cfg.testSkipPatterns)) {
        $pat = [regex]::Escape([string]$p)
        if ([regex]::Matches($new, $pat).Count -gt [regex]::Matches($old, $pat).Count) {
            Deny 'G6' $Shown "a edição acrescenta '$p' em ${Rel}: teste ignorado é gate afrouxado. Não pule o teste — pare e levante 🔺 GAP ao Arquiteto (R7; plano §9)."
        }
    }
}

# G7 — R28: a ferramenta Agent serve só ao operator. v3.52.2 (note.md item 4, C3): o executor de Task (task-runner) conduz a
# Task pelo ciclo do run e dispara só developer, architect, operator e quality-assurance; PO, UX, SM e o próprio executor
# ficam com a sessão que orquestra.
function Test-G7([object]$ToolInput) {
    $target = (([string]$ToolInput.subagent_type) -replace '^.*:', '').ToLowerInvariant()
    $shown = if ($ToolInput.subagent_type) { [string]$ToolInput.subagent_type } else { '(sem subagent_type)' }
    if ($script:role -eq 'task-runner') {
        if ($target -in 'developer', 'architect', 'operator', 'quality-assurance') { return }
        Deny 'G7' $shown "o executor de Task dispara só developer, architect, operator e quality-assurance (agents/task-runner.md) — $shown fica com a sessão que orquestra. Pare e devolva a linha à sessão (ex.: T-041 🔴 bloqueada: <motivo>)."
    }
    if ($script:role -notin 'architect', 'developer', 'quality-assurance', 'user-experience') { return }
    if ($target -ne 'operator') {
        Deny 'G7' $shown "a ferramenta Agent serve só ao operator (R28) — disparar outro papel ($shown) atropela a propriedade dos artefatos. Delegue a execução pesada ao operator; o resto, reporte a quem orquestra."
    }
}

# G18 — v3.47 (M3), modo benchmark: guards.json "bench". O experimento roda sem o stakeholder.
#   bench.answers  → JSON { "respostas": [ { "tema", "match" (regex na pergunta+título), "pick" (regex no rótulo da opção) } ] }.
#                    O AskUserQuestion é NEGADO e a resposta volta no motivo: "[bench] resposta do stakeholder: <opção>".
#                    Sem regra que case, vale a opção marcada como recomendada (nunca "Pedir mais contexto"). Tudo vai a
#                    .team-project/benchmark/<bench.arm>/questions.log (tema · origem da resposta · pergunta · resposta).
#   bench.foreground (true) → agente em segundo plano é negado: o claude -p encerra antes da notificação.
#                    v3.52.2: sem efeito — o Agent não tem mais run_in_background (todo agente é assíncrono). O código fica;
#                    o comportamento sob claude -p está a medir (hooks/COVERAGE.md, risco conhecido).
function Test-G18Ask([object]$ToolInput) {
    $answers = Get-BenchAnswers $cfg $script:projectDir $ToolInput              # common.ps1; $null = sem bench ou sem respostas: a G3 segue valendo
    if ($null -eq $answers) { return }
    $reason = Format-BenchAnswers $answers
    Deny 'bench' 'AskUserQuestion' ("$reason. Modo benchmark (guards.json → bench): o stakeholder simulado já respondeu pelo dossiê — trate isto como a decisão dele e siga, sem repetir a pergunta nem pedir mais contexto.")
}
function Test-G18Agent([object]$ToolInput) {
    if ($null -eq $cfg.bench -or $cfg.bench.foreground -ne $true) { return }
    if ($ToolInput.run_in_background -eq $true) {
        $shown = if ($ToolInput.subagent_type) { [string]$ToolInput.subagent_type } else { '(sem subagent_type)' }
        Deny 'bench' $shown 'modo benchmark (guards.json → bench.foreground): dispare o agente em primeiro plano, com run_in_background: false — sob claude -p o processo encerra antes da notificação de agente em segundo plano e a Task fica pela metade. O relógio por Task segue medido pelo burndown.'
    }
}

# G17 — v3.47: o modelo de cada papel é o de .team-project/models.json (stakeholder). Vale para a sessão e para o operator
# disparado por um papel. Sem a chave do papel, nada muda: valem o agente e as exceções do processo (trilha leve, 3ª instância).
function Test-G17([object]$ToolInput) {
    $target = (([string]$ToolInput.subagent_type) -replace '^.*:', '').Trim().ToLowerInvariant()
    if (-not $target) { return }
    $mc = Get-ModelsConfig $script:projectDir
    if ($mc.State -ne 'ok' -or -not $mc.Models.ContainsKey($target)) { return }
    $want = [string]$mc.Models[$target]
    $given = ([string]$ToolInput.model).Trim().ToLowerInvariant()
    $effective = if ($given) { $given } else { Get-AgentDefaultModel $target }
    if ($effective -eq $want) { return }
    $shown = if ($effective) { $effective } else { 'o do agente' }
    Deny 'G17' ([string]$ToolInput.subagent_type) "o modelo de '$target' é '$want' (.team-project/models.json) e o disparo usaria '$shown'. Dispare de novo com model: ""$want"" — a chave vence o modelo do agente e as exceções do processo. Para mudar o modelo, o dono é o stakeholder: edite models.json (ou desligue a G17 em guards.json)."
}

# G8 — matriz de propriedade (hooks/ownership.json, derivado de artifact-ownership.md §1). Primeira regra que casa decide.
function Test-G8([string]$Rel, [string]$Shown) {
    $r = $script:role
    if (-not $r -or $r -eq 'operator' -or -not $Rel) { return }   # operator: G11
    $own = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'ownership.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($null -eq $own.roles.$r) { return }                          # agente fora do time
    $rules = if ($script:pluginSource) { $own.pluginSource } else { $own.project }
    foreach ($rule in @($rules)) {
        if (-not (Test-GlobMatch $Rel @($rule.paths))) { continue }
        if (@($rule.writers) -contains $r) { return }
        $who = if (@($rule.writers).Count) { (@($rule.writers) | ForEach-Object { $own.roles.$_ }) -join ' · ' } else { 'stakeholder / a sessão principal' }
        $row = if ($rule.matriz) { "linha '$($rule.matriz)'" } else { [string]$rule.nota }
        Deny 'G8' $Shown "$Rel não é seu: escreve $who (artifact-ownership.md §1, $row). Quem não é dono lê, cita e pede alteração ao dono — não edita."
    }
    if ($script:pluginSource) { return }
    $isSource = if (@($cfg.sourceRoots).Count) { Test-GlobMatch $Rel $cfg.sourceRoots } else { $Rel -notmatch '^docs/' }
    if (-not $isSource) { return }
    if ($r -eq 'developer') { return }                                # G9 restringe ao plano
    if ($r -eq 'architect') {
        if ($null -ne (Get-Marker $script:projectDir '.active-spike')) { return }   # spike declarado pela sessão
        if (Test-ExecutorActive $script:projectDir) { return }                       # v3.47 (M2): perfil executor — a G9 restringe ao plano
        Deny 'G8' $Shown "$Rel é código-fonte: o Arquiteto decide e devolve a resposta a quem pediu — quem escreve é o dev, pelo plano (artifact-ownership.md §1). Para validar um trecho, use uma cópia no scratchpad da sessão (fora do projeto) ou, no sprint, o operator; provar que o teste de regressão falha é o passo 1 do dev. Spike que precisa tocar o código: a sessão grava .team-project/.active-spike antes (roles/architect/README.md §Validar sem escrever no produto). Perfil executor (models.json ""executor"": ""architect""): a sessão grava .team-project/.active-executor antes de disparar o Arquiteto para implementar o plano (sprint-run.md passo 3)."
    }
    Deny 'G8' $Shown "$Rel é código-fonte: escreve o dev, só nos arquivos do Plano de Implementação (artifact-ownership.md §1). Leve a mudança ao Arquiteto, que planeja."
}

# Escopo ativo do dev: .team-project/.active-task → arquivos do plano (Task) ou do mini-plano (trilha fix).
function Get-ActiveScope {
    $p = Join-Path $script:projectDir '.team-project/.active-task'
    if (-not (Test-Path -LiteralPath $p)) { return $null }
    # v3.48: .active-task ilegível derrubava o hook (exceção → falha aberta) e o dev escrevia sem G6/G8/G9.
    try { $a = Get-Content -LiteralPath $p -Raw -Encoding UTF8 | ConvertFrom-Json } catch { $a = $null }
    if ($null -eq $a -or -not $a.id) { return @{ Invalid = $true; Id = ''; Plano = ''; Files = @() } }
    $scope = @{ Id = [string]$a.id; Plano = [string]$a.plano; Files = @() }
    $plan = Join-Path $script:projectDir $scope.Plano
    if (-not $scope.Plano -or -not (Test-Path -LiteralPath $plan)) { return $scope }
    $text = [System.IO.File]::ReadAllText($plan, (New-Object System.Text.UTF8Encoding($false)))
    $chunks = @()
    if ([string]$a.trilha -eq 'fix') {
        $body = $text
        if ($scope.Id -match '^F-\d+') { $fm = [regex]::Match($text, '(?ms)^## ' + [regex]::Escape($scope.Id) + '\b.*?(?=^## |\z)'); $body = $fm.Value }
        $chunks = @([regex]::Matches($body, '(?m)^\s*-\s*(?:produção|producao|teste):(.*)$') | ForEach-Object { $_.Groups[1].Value })
    } else {
        $m = [regex]::Match($text, '(?s)\*\*Arquivos tocados:\*\*(.*?)(?:\r?\n[ \t]*\r?\n|\r?\n#|\z)')
        if ($m.Success) { $chunks = @($m.Groups[1].Value) }
    }
    foreach ($c in $chunks) {
        foreach ($t in [regex]::Matches($c, '`([^`]+)`')) { $scope.Files += ((Normalize-PathText $t.Groups[1].Value.Trim()) -replace '^\./', '') }
    }
    return $scope
}

# G9 — R4 · R8: o dev só escreve no produto o que o escopo ativo lista. Sem escopo ativo, nenhum arquivo de produto.
function Test-G9([string]$Rel, [string]$Shown) {
    if (-not (Test-CodeWriter) -or -not $Rel -or -not $script:teamProject) { return }
    if ($Rel.StartsWith('.team-project/')) { return }                # processo: G8
    $gap = if ($script:role -eq 'architect') { 'Perfil executor: acrescente o arquivo a **Arquivos tocados:** do plano e registre em **Plano corrigido durante a execução:**, depois siga — não escreva fora do plano' } else { 'Pare e levante 🔺 GAP ao Arquiteto' }
    $scope = Get-ActiveScope
    if ($null -eq $scope) {
        Deny 'G9' $Shown "nenhum escopo ativo (.team-project/.active-task ausente): sem plano, sem código (R8). Pare e reporte — quem orquestra grava o escopo antes de disparar o dev."
    }
    if ($scope.Invalid) {
        Deny 'G9' $Shown "escopo ativo ilegível: .team-project/.active-task não é o JSON { ""trilha"": ""sprint"", ""id"": ""<T-ID>"", ""plano"": ""<caminho do plano>"" } (sprint-run.md passo 3; fix-run.md na trilha fix). Pare e reporte — quem orquestra regrava o marcador; sem escopo legível, nenhum arquivo de produto (R8)."
    }
    if ($scope.Files.Count -eq 0) {
        Deny 'G9' $Shown "o plano de $($scope.Id) ($($scope.Plano)) não tem lista de arquivos legível (caminhos entre crases em **Arquivos tocados:** ou em - produção:/- teste:). $gap (R8)."
    }
    if ($scope.Files -contains $Rel) { return }
    Deny 'G9' $Shown "arquivo fora do plano: $Rel não está na lista de $($scope.Id) ($($scope.Plano)). $gap antes de editar (R4 · R8) — quem orquestra resolve com o Arquiteto, não com o stakeholder (R25)."
}

# G11 — contrato do operator, item 6: escreve só na pasta do próprio job.
function Test-G11([string]$Rel, [string]$Shown) {
    if ($script:role -ne 'operator') { return }
    # v3.48: só o segmento canônico — operator/sprint-1/ escrevia sem aviso e o C1 não achava o job da Task.
    if ($Rel -and $Rel -match '^\.team-project/operator/(\d+|pre-sprint|b-\d+)/[^/]+/.+') { return }
    $hint = if ($Rel -match '^\.team-project/operator/(?:sprint|s)[-_ ]?0*(\d+)/') { " O segmento do sprint é o número: operator/$($Matches[1])/, nunca operator/sprint-$($Matches[1])/." } else { '' }
    Deny 'G11' $Shown "o operator escreve só na pasta do próprio job — .team-project/operator/<n do sprint|pre-sprint|B-nnn>/<job>/ (contrato, item 6).$hint Réplica e rascunho ficam lá dentro; o código do projeto não se toca."
}

# G14 — run sem trava: com .team-project/.active-run (gravado pela sessão no sprint run e no fix run), o que já passou
# pelas guardas e é operacional sai liberado — o harness não pergunta ao stakeholder no meio do run. Comando fora da
# lista é negado com a rota (como a G9: pergunta no meio do run contraria R25), nunca deixado numa pergunta sem resposta.
$script:runBase = @(
    'git status', 'git diff', 'git log', 'git show', 'git grep', 'git blame', 'git add', 'git commit', 'git restore --staged',
    'git rev-parse', 'git ls-files', 'git branch --show-current', 'git check-ignore', 'git stash list',
    'get-childitem', 'gci', 'ls', 'dir', 'get-content', 'gc', 'cat', 'type', 'get-item', 'gi', 'get-itemproperty', 'test-path',
    'resolve-path', 'split-path', 'join-path', 'select-string', 'sls', 'select-object', 'select', 'where-object', 'where', '?',
    'foreach-object', '%', 'sort-object', 'sort', 'group-object', 'measure-object', 'measure', 'compare-object', 'format-table',
    'ft', 'format-list', 'fl', 'out-string', 'out-null', 'write-output', 'echo', 'write-host', 'get-date', 'get-location', 'pwd',
    'set-location', 'cd', 'push-location', 'pop-location', 'convertfrom-json', 'convertto-json', 'get-command', 'get-filehash',
    'get-member', 'get-winevent', 'get-process', 'get-ciminstance', 'get-wmiobject',
    'head', 'tail', 'wc', 'grep', 'rg', 'find', 'uniq', 'diff', 'which', 'stat', 'tree', 'true')
$script:runWriteVerbs = 'set-content', 'add-content', 'out-file', 'new-item', 'clear-content', 'remove-item', 'copy-item', 'move-item'

function Test-UnderTemp([string]$Path) {
    $n = Normalize-PathText $Path
    return $n.StartsWith((Normalize-PathText ([System.IO.Path]::GetTempPath())) + '/') -or $n -match '/appdata/local/temp/'
}

# v3.48: a G14 troca o texto entre aspas por "__q<k>__" antes de partir o comando (separador dentro de aspas não parte);
# o destino de escrita se lê com o texto devolvido — antes o caminho entre aspas virava "" e todo cmdlet de escrita com
# caminho entre aspas era negado.
function Restore-Quoted([string]$Seg) {
    if ($null -eq $script:qmap) { return $Seg }
    return [regex]::Replace($Seg, '"__q(\d+)__"', { param($m) $script:qmap[[int]$m.Groups[1].Value] })
}

# Alvo de escrita resolvido: no projeto (as guardas de escrita já o conferiram) ou no temporário (scratchpad).
function Test-RunTargets([string]$Seg) {
    $targets = @(Get-WriteTargets (Restore-Quoted $Seg) $script:cmdVars)
    if ($targets.Count -eq 0) { return $false }                       # destino em variável: não se resolve
    foreach ($t in $targets) { if (-not (Test-RunPath $t)) { return $false } }
    return $true
}
function Test-RunPath([string]$Target) {
    if (Test-ProviderDrive $Target) { return (Test-SessionDrive $Target) }
    $base = if ($script:hookInput.cwd) { [string]$script:hookInput.cwd } else { $script:projectDir }
    $full = if ([System.IO.Path]::IsPathRooted($Target)) { $Target } else { Join-Path $base $Target }
    return [bool]((Get-RelativePath $script:projectDir $full) -or (Test-UnderTemp $full))
}

# v3.51.4: escrita por .NET ([IO.File]::WriteAllText/AppendAllText…) passa quando TODO destino dela se resolve no projeto
# ou no temporário — o destino já passou pela G5/G8/G9 (Get-WriteTargets o lê). Destino em variável que não se resolve: não.
function Test-NetWrites([string]$Cmd) {
    $calls = [regex]::Matches($Cmd, '\[(?:System\.)?IO\.File\]::(?:WriteAll|AppendAll)\w*\s*\(').Count
    if (-not $calls) { return $true }
    $qs = New-Object System.Collections.ArrayList
    $masked = [regex]::Replace($Cmd, '"[^"]*"|''[^'']*''', { param($m) [void]$qs.Add($m.Value); "$([char]1)$($qs.Count - 1)$([char]1)" })
    $got = 0
    foreach ($nm in [regex]::Matches($masked, '\[(?:System\.)?IO\.File\]::(?:WriteAll\w+|AppendAll\w+)\s*\(\s*(\x01\d+\x01|\$\{?\w+\}?|[^,\s)]+)')) {
        $t = [regex]::Replace($nm.Groups[1].Value, "\x01(\d+)\x01", { param($m) $qs[[int]$m.Groups[1].Value] })
        if ($t -match '^"(.*)"$|^''(.*)''$') { $t = $Matches[1] + $Matches[2] }
        $t = Expand-TempVar $t
        if ($t -match '\$') { $t = [regex]::Replace($t, '\$\{?(\w+)\}?', { param($m) $k = $m.Groups[1].Value.ToLowerInvariant(); if ($script:cmdVars.ContainsKey($k)) { $script:cmdVars[$k] } else { $m.Value } }) }
        if ($t -match '\$' -or -not (Test-RunPath $t)) { return $false }
        $got++
    }
    return ($got -eq $calls)
}

# v3.51.4: script .ps1 que o papel escreveu — no scratchpad (temporário) ou em .team-project/ — roda quando o CONTEÚDO dele
# passaria pela G14 linha a linha e cada destino de escrita dele passa pela G5/G8/G9 (a tabela-ouro do QA e a medição de
# cobertura do operator, note.md item 10). Um nível só: script que chama outro script fica de fora.
function Test-ScriptRun([string]$Seg) {
    if ($script:g14Depth -gt 0) { return $false }
    $s = (Restore-Quoted $Seg).Trim()
    $m = [regex]::Match($s, '^(?i)(?:&\s*)?(?:(?:powershell|pwsh)(?:\.exe)?\s+(?:-(?!file\b)\w+(?:\s+(?!-)[\w.]+)?\s+)*-File\s+)?(?:"([^"]+\.ps1)"|''([^'']+\.ps1)''|([^\s"'']+\.ps1))(\s.*)?$')
    if (-not $m.Success) { return $false }
    if ($s -notmatch '^(?i)(&|powershell|pwsh)' -and $s -notmatch '^(?i)\.{0,2}[\\/]|^[a-z]:[\\/]') { return $false }
    $p = Expand-TempVar ($m.Groups[1].Value + $m.Groups[2].Value + $m.Groups[3].Value)
    if ($p -match '\$') { $p = [regex]::Replace($p, '\$\{?(\w+)\}?', { param($x) $k = $x.Groups[1].Value.ToLowerInvariant(); if ($script:cmdVars.ContainsKey($k)) { $script:cmdVars[$k] } else { $x.Value } }) }
    if ($p -match '\$') { return $false }
    $base = if ($script:hookInput.cwd) { [string]$script:hookInput.cwd } else { $script:projectDir }
    $full = if ([System.IO.Path]::IsPathRooted($p)) { $p } else { Join-Path $base $p }
    $rel = Get-RelativePath $script:projectDir $full
    if (-not ((Test-UnderTemp $full) -or ($rel -and $rel.StartsWith('.team-project/')))) { return $false }
    if (-not (Test-Path -LiteralPath $full -PathType Leaf) -or (Get-Item -LiteralPath $full).Length -gt 65536) { return $false }
    $body = [System.IO.File]::ReadAllText($full, (New-Object System.Text.UTF8Encoding($false)))
    if ($body -match $script:g14Forbidden) { return $false }
    foreach ($t in (Get-WriteTargets $body)) {
        if (Test-ProviderDrive $t) { continue }
        $tf = if ([System.IO.Path]::IsPathRooted($t)) { $t } else { Join-Path $base $t }
        $tr = Get-RelativePath $script:projectDir $tf
        if (Test-GuardEnabled $cfg 'G5') { Test-G5 $tr $t }
        if ($t -notmatch '(?i)\.log$') { if (Test-GuardEnabled $cfg 'G8') { Test-G8 $tr $t }; if (Test-GuardEnabled $cfg 'G9') { Test-G9 $tr $t } }
    }
    return (Test-CommandText $body 1)
}

# v3.51.4: cmd /c "<comando>" — a G14 lê o que está dentro (antes negava sempre): cada trecho passa pela lista, e o destino
# de ">" passa pela G5/G8/G9 (log não é produto) e tem de ficar no projeto ou no temporário.
function Test-CmdWrapper([string]$Seg) {
    $m = [regex]::Match($Seg.Trim(), '^(?i)cmd(?:\.exe)?\s+/[ck]\s+"__q(\d+)__"\s*$')
    if (-not $m.Success) { return $null }
    $inner = ([string]$script:qmap[[int]$m.Groups[1].Value]).Trim('"')
    $base = if ($script:hookInput.cwd) { [string]$script:hookInput.cwd } else { $script:projectDir }
    foreach ($t in (Get-WriteTargets $inner)) {
        if (Test-ProviderDrive $t) { return $false }
        $tf = if ([System.IO.Path]::IsPathRooted($t)) { $t } else { Join-Path $base $t }
        $tr = Get-RelativePath $script:projectDir $tf
        if (Test-GuardEnabled $cfg 'G5') { Test-G5 $tr $t }
        if ($t -notmatch '(?i)\.log$') { if (Test-GuardEnabled $cfg 'G8') { Test-G8 $tr $t }; if (Test-GuardEnabled $cfg 'G9') { Test-G9 $tr $t } }
    }
    $saved = $script:qmap
    try {
        $script:qmap = $null
        foreach ($piece in ($inner -split '&&|\|\||&|\|')) { if ($piece.Trim() -and -not (Test-RunSegment $piece $script:g14Allowed)) { return $false } }
        return $true
    } finally { $script:qmap = $saved }
}

# v3.51.2: conferência do próprio plugin (scripts/checks/*.ps1) — sozinha ou como trecho de comando composto
# (Set-Location …; $log = …; powershell -File …), com opção que leva valor (-ExecutionPolicy Bypass). Só vale o script
# dentro da pasta do plugin: antes, qualquer caminho terminado em scripts/checks/*.ps1 passava, inclusive um do projeto.
function Test-PluginCheck([string]$Seg) {
    $m = [regex]::Match($Seg.Trim(), '^(?i)(?:&\s*)?(?:powershell|pwsh)(?:\.exe)?\s+(?:-(?!file\b)\w+(?:\s+(?!-)[\w.]+)?\s+)*-File\s+(?:"([^"]+)"|''([^'']+)''|(\S+))')
    if (-not $m.Success) { return $false }
    $p = Expand-TempVar ($m.Groups[1].Value + $m.Groups[2].Value + $m.Groups[3].Value)
    # v3.51.4: caminho numa variável do mesmo comando ($acc = '…/scripts/checks/accept.ps1'; powershell -File $acc …).
    if ($p -match '\$' -and $script:cmdVars) { $p = [regex]::Replace($p, '\$\{?(\w+)\}?', { param($x) $k = $x.Groups[1].Value.ToLowerInvariant(); if ($script:cmdVars.ContainsKey($k)) { $script:cmdVars[$k] } else { $x.Value } }) }
    if ($p -match '\$' -or $p -notmatch '(?i)\.ps1$') { return $false }
    try { $full = Normalize-PathText ([System.IO.Path]::GetFullPath($p)) } catch { return $false }
    foreach ($r in @($env:CLAUDE_PLUGIN_ROOT, (Split-Path $PSScriptRoot -Parent))) {
        if ([string]::IsNullOrWhiteSpace($r)) { continue }
        $base = (Normalize-PathText ([System.IO.Path]::GetFullPath($r))).TrimEnd('/') + '/scripts/checks/'
        if ($full.StartsWith($base) -and $full.Substring($base.Length) -notmatch '/') { return $true }
    }
    return $false
}

function Test-RunSegment([string]$Seg, [string[]]$Allowed) {
    if (Test-PluginCheck (Restore-Quoted $Seg)) {
        if ($Seg -match '(^|\s)[\d*]?>{1,2}(?!&)\s*[^\s$]') { return (Test-RunTargets $Seg) }   # saída para arquivo
        return $true
    }
    $cw = Test-CmdWrapper $Seg; if ($null -ne $cw) { return $cw }
    if (Test-ScriptRun $Seg) { return $true }
    $s = $Seg.Trim()
    # v3.51.4: palavra-chave, atribuição e conversão em cadeia ($pct = if …, [xml]$x = Get-Content …, else) — antes só a
    # primeira de cada saía, e "$pct = if" ou "if" sozinho virava trecho recusado.
    do {
        $prev = $s
        $s = $s -replace '^(?i)(if|elseif|else|foreach|for|while|switch|try|catch|finally|return|do|until|begin|process|end|param)\b\s*', ''
        $s = $s -replace '^(\[[^\]]+\]\s*)+(?=\$)', ''
        $s = $s -replace '^\$[\w:.]+\s*[-+*/]?=\s*', ''
        $s = $s.Trim()
    } while ($s -ne $prev)
    # v3.48: método estático de leitura do .NET — [Math]::Min, [regex]::Replace, [IO.File]::ReadAllText; v3.51.4: [array],
    # [Text.Encoding], [xml], leitura de pasta e escrita por .NET com destino resolvido (Test-NetWrites).
    if ($s -match '^(?i)\[(System\.)?(Math|String|Char|Convert|Int32|Int64|Double|Decimal|DateTime|TimeSpan|Guid|Text\.RegularExpressions\.Regex|Regex|IO\.Path|Linq\.Enumerable|Array|Text\.Encoding|Xml|Xml\.XmlDocument)\]::\w+\s*$') { return $true }
    if ($s -match '^(?i)\[(System\.)?IO\.File\]::(ReadAllText|ReadAllLines|ReadAllBytes|ReadLines|Exists)\s*$') { return $true }
    if ($s -match '^(?i)\[(System\.)?IO\.Directory\]::(Exists|GetFiles|GetDirectories|EnumerateFiles|EnumerateDirectories)\s*$') { return $true }
    if ($s -match '^(?i)\[(System\.)?IO\.File\]::(WriteAll|AppendAll)\w*\s*$') { return [bool]$script:netWriteOk }
    if ($s -match '^(?i)\[(System\.)?Environment\]::(GetEnvironmentVariable|NewLine|CurrentDirectory)\s*$') { return $true }
    $s = $s -replace '^(\[[^\]]+\]\s*)+', '' -replace '^\$[\w:.]+\s*[-+]?=\s*', '' -replace '^&\s*', ''
    $s = $s.Trim()
    if (-not $s -or $s -match '^[\$@''"\-\d\[,!=+*/%<>]' -or $s -match '^\w+\s*=\s') { return $true }   # expressão, não comando
    # Propriedade do resultado entre parênteses — (Get-Content f).Count — é leitura; método chega aqui como __metodo_<nome>.
    # v3.51.4: com o resto dos argumentos do comando de fora — Get-Content (Get-ChildItem x).FullName -Encoding UTF8.
    if ($s -match '^\.[A-Za-z_]\w*(\.[A-Za-z_]\w*)*(\s*\[[^\]]*\])?(\s.*)?$') {
        if ($s -match '(^|\s)[\d*]?>{1,2}(?!&)\s*[^\s$]') { return (Test-RunTargets $s) }
        return $true
    }
    $s = $s -replace '^(?i)git\s+(-C\s+\S+\s+|--no-pager\s+)+', 'git '
    $s = $s -replace '^(?i)(npm|npx)\s+--prefix(?:\s+|=)\S+\s+', '$1 '    # v3.48: npm --prefix source run x = npm run x na pasta

    $low = $s.ToLowerInvariant()
    if ($low -match '^git branch(\s|$)') {                               # listar sim; criar, apagar, renomear, copiar não
        $tok = @($low -split '\s+' | Select-Object -Skip 2)
        if ($tok | Where-Object { $_ -match '^(-[dmcfu]|--(delete|move|copy|force|set-upstream-to|unset-upstream|edit-description|track|no-track|create-reflog)\b)' }) { return $false }
        if ($tok.Count -eq 0 -or ($tok | Where-Object { $_ -match '^(-[arlv]+|--(all|remotes|list|verbose|contains|no-contains|merged|no-merged|show-current|points-at|sort|format)\b)' })) { return $true }
        return $false
    }
    if ($low -match '^[\w.-]+\s+(--version|-version)$') { return $true }   # versão de ferramenta (R26)
    # v3.51.4: função definida no próprio comando — a definição e a chamada passam; o corpo é conferido trecho a trecho.
    if ($low -match '^function\s+[\w-]+$') { return $true }
    # v3.51.4: objeto .NET para ler ou codificar (New-Object Text.UTF8Encoding($false)); COM fica de fora.
    if ($low -match '^new-object\s+(-typename\s+)?(system\.)?(text\.|io\.(stringreader|memorystream)|collections\.|xml\.)' -and $low -notmatch '-comobject') { return $true }
    $verb = ($low -split '\s+')[0]
    if ($script:fnNames -and $script:fnNames -contains $verb) {
        if ($low -match '(^|\s)[\d*]?>{1,2}(?!&)\s*[^\s$]') { return (Test-RunTargets $s) }
        return $true
    }
    # v3.51.4: o operator encerra o processo que ele mesmo deixou preso (accept.ps1 parado) — só pelo número do processo.
    if ($script:role -eq 'operator' -and $low -match '^stop-process\s+(-id\s+)?\d+(\s*,\s*\d+)*(\s+-force)?(\s+-erroraction\s+\w+)?$') { return $true }
    if ($script:runWriteVerbs -contains $verb) { return (Test-RunTargets $s) }
    foreach ($p in $Allowed) {
        $pl = ([string]$p).Trim().ToLowerInvariant()
        if ($pl -and ($low -eq $pl -or $low.StartsWith($pl + ' ') -or $low.StartsWith($pl + "`t"))) {
            if ($low -match '(^|\s)[\d*]?>{1,2}(?!&)\s*[^\s$]') { return (Test-RunTargets $s) }   # redirecionamento para arquivo
            return $true
        }
    }
    return $false
}

# Confere um texto de comando (o da ferramenta ou o de um script do papel) trecho a trecho. Devolve $true/$false e deixa o
# trecho recusado em $script:badSeg. v3.51.4: texto entre aspas duplas com $( … ) vira "__q<k>__" e cada subexpressão um
# trecho próprio — antes o texto inteiro voltava ao comando e "tests=", ":", "brotas" ou "node:" viravam trechos recusados.
function Test-CommandText([string]$Cmd, [int]$Depth = 0) {
    $saved = @{ vars = $script:cmdVars; qmap = $script:qmap; fn = $script:fnNames; net = $script:netWriteOk; depth = $script:g14Depth }
    try {
        $script:g14Depth = $Depth
        $script:cmdVars = Get-CommandVars $Cmd
        $script:fnNames = @([regex]::Matches($Cmd, '(?im)\bfunction\s+([\w-]+)') | ForEach-Object { $_.Groups[1].Value.ToLowerInvariant() })
        $script:netWriteOk = Test-NetWrites $Cmd
        $script:qmap = New-Object System.Collections.ArrayList
        $flat = [regex]::Replace($Cmd, '"([^"]*)"|''[^'']*''', { param($m)
            [void]$script:qmap.Add($m.Value); $tok = '"__q' + ($script:qmap.Count - 1) + '__"'
            if (-not ($m.Value.StartsWith('"') -and $m.Groups[1].Value.Contains('$('))) { return $tok }
            $inner = $m.Groups[1].Value; $subs = @(); $i = 0
            while (($i = $inner.IndexOf('$(', $i)) -ge 0) {
                $depthP = 0; $j = $i + 1
                for (; $j -lt $inner.Length; $j++) { if ($inner[$j] -eq '(') { $depthP++ } elseif ($inner[$j] -eq ')') { $depthP--; if ($depthP -eq 0) { break } } }
                $sub = $inner.Substring($i + 2, [Math]::Max(0, $j - $i - 2))
                $sub = [regex]::Replace($sub, '''[^'']*''', { param($q) [void]$script:qmap.Add($q.Value); '"__q' + ($script:qmap.Count - 1) + '__"' })
                $subs += $sub; $i = $j + 1
            }
            return $tok + ' ; ' + ($subs -join ' ; ') + ' ; ' })
        # Chamada de método sobre o resultado — (Get-Item f).Delete() — vira um segmento próprio, que nenhuma lista libera.
        $flat = [regex]::Replace($flat, '\)\s*\.\s*([A-Za-z_]\w*)\s*\(', { param($m) ') ; __metodo_' + $m.Groups[1].Value + ' (' })
        foreach ($seg in ($flat -split '\$\(|;|&&|\|\||\||\r?\n|[{}()]')) {
            if (-not (Test-RunSegment $seg $script:g14Allowed)) { $script:badSeg = (Restore-Quoted $seg).Trim(); return $false }
        }
        return $true
    } finally {
        $script:cmdVars = $saved.vars; $script:qmap = $saved.qmap; $script:fnNames = $saved.fn; $script:netWriteOk = $saved.net; $script:g14Depth = $saved.depth
    }
}

# v3.51.4: o que a G14 nunca libera, no comando e no conteúdo de script do papel. A escrita por .NET (WriteAll/AppendAll)
# saiu daqui: passa quando o destino se resolve (Test-NetWrites) e a G5/G8/G9 o conferiram.
$script:g14Forbidden = '(?i)--no-verify|\bInvoke-Expression\b|\biex\b|-EncodedCommand|\bStart-Process\b|\[(System\.)?IO\.(File|Directory)\]::(Delete|Move|Copy|Replace|Create\w*)'

# G22 (v3.52, note.md itens 3 e 7) — a sessão que orquestra não espera pagando: com run ativo (sprint ou fix), a sessão
# principal não roda comando em segundo plano nem Start-Sleep. Medido no sunscape-P-r1: 48 esperas da sessão (US$ 3,68), cada
# uma relendo ~300 mil tokens — sondando o delivery/ depois de retomar o dev por SendMessage, ou a saída de um aceite que ela
# mesma rodou em segundo plano. Agente (v3.52.2, note.md item 2): dispare e encerre o turno; o aviso reabre a sessão.
# Comando longo: operator (R28).
function Test-G22([object]$ToolInput) {
    if ($null -eq (Get-Marker $script:projectDir '.active-run')) { return }
    $cmd = [string]$ToolInput.command
    $short = if ($cmd.Length -gt 100) { $cmd.Substring(0, 100) + '…' } else { $cmd }
    if ($ToolInput.run_in_background -eq $true) {
        Deny 'G22' $short "comando em segundo plano pela sessão durante o run ($short): a sessão passaria a sondar a saída, e cada sondagem relê o contexto inteiro dela. Comando longo (aceite, lote, build, verificação) vai ao operator (R28) — dispare e encerre o turno; o aviso reabre a sessão. Conferência curta, em primeiro plano."
    }
    if ($cmd -match '(?i)\bStart-Sleep\b|\bsleep\s+\d|\btimeout\s+/t\b') {
        Deny 'G22' $short "espera da sessão durante o run ($short): cada espera relê o contexto inteiro da sessão. Agente: dispare e encerre o turno; o aviso reabre a sessão (retomada: instância nova com o cartão de passagem) — não retome por SendMessage para depois sondar o disco. Alvo: target.ps1 -Target <alvo> -Repair espera sozinho. Comando longo: operator (R28)."
    }
}

function Test-G14([object]$ToolInput) {
    if ($null -eq (Get-Marker $script:projectDir '.active-run')) { return $false }
    if ($script:tool -match '^(Edit|Write)$') {
        $path = [string]$ToolInput.file_path
        if ((Get-RelativePath $script:projectDir $path) -or (Test-UnderTemp $path)) { return $true }
        Deny 'G14' $path "escrita fora do projeto durante o run ($path). Rascunho vai no scratchpad da sessão; o resto, reporte a quem orquestra."
    }
    $cmd = [string]$ToolInput.command
    if ([string]::IsNullOrWhiteSpace($cmd)) { return $false }
    # Comando em segundo plano deixa o papel parado esperando a notificação — execução longa é do operator (R28).
    if ($ToolInput.run_in_background -eq $true -and $script:role -ne 'operator') {
        Deny 'G14' 'run_in_background' "comando em segundo plano durante o run: o papel fica parado esperando a notificação, e a chamada que o disparou pode voltar 'interrupted'. Rode em primeiro plano com timeout; execução longa (build, suíte, cobertura) vai ao operator (R28)."
    }
    # Conferências C1–C4 (scripts/checks/*.ps1); v3.48: com 2>&1, *> arquivo ou | Out-String no fim (a regex excluía "&").
    # v3.51.2: só o script dentro da pasta do plugin (Test-PluginCheck); composto com ele passa pelos trechos, abaixo.
    if ($cmd -match '^\s*(?i)(powershell|pwsh)(\.exe)?\s+(-\w+\s+)*-File\s+"?[^";|&]*[\\/]scripts[\\/]checks[\\/][\w-]+\.ps1"?([^;|&]|[*\d]?>&1)*(\|\s*Out-String\s*)?$' -and (Test-PluginCheck $cmd)) { return $true }
    $why = 'fora da lista operacional do run'
    $fm = [regex]::Match($cmd, $script:g14Forbidden)
    if ($fm.Success) {
        $hint = if ($fm.Value -match '(?i)IO\.(File|Directory)') { ' — para gravar arquivo use o Edit/Write ou [IO.File]::WriteAllText(<caminho resolvido>, …); apagar, mover e copiar vão pelo cmdlet (Remove-Item, Move-Item, Copy-Item) com o caminho literal' } else { '' }
        $why = "construção que a G14 não libera (``$($fm.Value)``)$hint"
    }
    else {
        $script:g14Allowed = @($script:runBase) + @($cfg.runCommands)
        $script:badSeg = ''
        if (Test-CommandText $cmd 0) { return $true }
        if (@($cfg.runCommands).Count -eq 0) { return $false }        # projeto sem runCommands: o harness decide, como antes
        $badSeg = [string]$script:badSeg
        $plugCheck = $badSeg -match '^(?i)(&\s*)?(powershell|pwsh)(\.exe)?\s.*-File\s.*[\\/]scripts[\\/]checks[\\/]'   # antes do corte
        if ($badSeg.Length -gt 80) { $badSeg = $badSeg.Substring(0, 80) + '…' }
        # v3.52.3 (note.md item 3): a ferramenta move para segundo plano o comando que passa de 600 s, e o aviso de conclusão
        # CHEGA ao papel — negado o sono, o dev do garden passou a sondar o log (Get-Date + Get-Content a cada ~5 s, 51 chamadas).
        if ($badSeg -match '^(?i)(start-sleep|wait-process)\b') { $why = "espera com $(($badSeg -split '\s')[0]) durante o run (``$badSeg``) — o papel fica parado consumindo contexto. Comando que a ferramenta moveu para segundo plano ('moved to the background'): ENCERRE O TURNO — o aviso de conclusão traz o resultado; não sonde o log nem rode o comando de novo. Esperar o alvo (emulador, servidor): ``target.ps1 -Target <alvo> -Repair``, que espera ele ficar pronto. O verify.ps1 e o accept.ps1 voltam com exit 3 (parcial) e continuam do ponto na chamada seguinte; execução longa vai ao operator (R28) — dispare e encerre o turno; o aviso traz a volta" }
        elseif ($badSeg -match '^(?i)(\S*[\\/])?adb(\.exe)?\b') { $why = "``adb`` direto (``$badSeg``) — o alvo se confere e se repara pelo ``target.ps1 -Target android`` (com ``-Repair`` reinicia e espera o emulador), e os cenários rodam pelo ``accept.ps1``; inspeção da tela é do operator pela pasta do job" }
        elseif ($badSeg -match '^(?i)(robocopy|xcopy)\b') { $why = "cópia em massa (``$badSeg``) — réplica do projeto para medir ou provar é trabalho do operator, na pasta do job (R28)" }
        elseif ($badSeg -match '^(?i)cmd(\.exe)?\s+/[ck]\b') { $why = "``cmd /c`` (``$badSeg``) — a G14 lê o comando de dentro quando ele vem entre aspas duplas (cmd /c ""<comando> > <log>""); o trecho de dentro não está na lista ou o destino não se resolve no projeto" }
        elseif ($plugCheck) { $why = "script de conferência fora da pasta do plugin (``$badSeg``) — só os de `${CLAUDE_PLUGIN_ROOT}/scripts/checks/ passam; use o caminho que o roteiro cita" }
        elseif ($badSeg -match '(?i)\.ps1\b') { $why = "script (``$badSeg``) — passa o script que o próprio papel gravou no scratchpad ou em .team-project/, quando cada linha dele passaria pela G14 e cada destino de escrita é dele; o trecho do script que não passaria é o motivo — rode-o sozinho para ver" }
        elseif ($badSeg -match '^__metodo_(\w+)') { $why = "fora da lista operacional do run — chamada de método .$($Matches[1])() sobre o resultado de um comando; a G14 só libera propriedade (.Count, .Length, .Lines) — para escrever ou apagar, use o cmdlet" }
        else { $why = "fora da lista operacional do run — o trecho recusado é ``$badSeg``" + $(if ($badSeg -ne $cmd.Trim()) { ' (os outros trechos do comando composto passaram; rode esse trecho sozinho ou troque a forma)' } else { '' }) }
    }
    $short = if ($cmd.Length -gt 120) { $cmd.Substring(0, 120) + '…' } else { $cmd }
    Deny 'G14' $short "comando $why ($short). Durante o run, o harness não pode parar para perguntar ao stakeholder: rode comandos simples, um por chamada, da lista (hooks/COVERAGE.md G14 + guards.json → runCommands). Comando de build/teste/lint do projeto que falta na lista: reporte a quem orquestra, que o acrescenta em runCommands; dev → 🔺 GAP. Instalação, rede, push ou destrutivo não entram no run: bloqueio da Task (degrau 1)."
}

try {
    $script:hookInput = Read-HookInput
    if ($null -eq $script:hookInput) { exit 0 }
    $script:projectDir = Get-ProjectDir $script:hookInput
    $cfg = Get-GuardConfig $script:projectDir
    $tool = [string]$script:hookInput.tool_name
    $script:tool = $tool
    $ti = $script:hookInput.tool_input
    $script:role = Get-AgentRole $script:hookInput
    $script:teamProject = Test-Path -LiteralPath (Join-Path $script:projectDir '.team-project')
    $script:pluginSource = Test-PluginSource $script:projectDir
    $phase2 = $script:role -and ($script:teamProject -or $script:pluginSource)   # sessão principal e projeto sem o time: fora
    $allow = $false

    switch -Regex ($tool) {
        '^(PowerShell|Bash)$'   {
            if (Test-GuardEnabled $cfg 'G1') { Test-G1 $ti }   # G1 vale sem guards.json (D5)
            if (-not $script:role -and $script:teamProject -and (Test-GuardEnabled $cfg 'G22')) { Test-G22 $ti }   # só a sessão principal
            if ($phase2) {
                $base = if ($script:hookInput.cwd) { [string]$script:hookInput.cwd } else { $script:projectDir }
                foreach ($t in (Get-WriteTargets ([string]$ti.command))) {
                    if (Test-ProviderDrive $t) { continue }                        # Env:X, HKCU:… — não é arquivo (G9 negava Env:)
                    $full = if ([System.IO.Path]::IsPathRooted($t)) { $t } else { Join-Path $base $t }
                    $rel = Get-RelativePath $script:projectDir $full
                    $isLog = $t -match '(?i)\.log$'                                # log redirecionado (R28) não é produto
                    if (Test-GuardEnabled $cfg 'G5') { Test-G5 $rel $t }
                    if ((Test-GuardEnabled $cfg 'G8') -and -not $isLog) { Test-G8 $rel $t }
                    if ((Test-GuardEnabled $cfg 'G9') -and -not $isLog) { Test-G9 $rel $t }
                }
            }
        }
        '^(Edit|Write)$'        {
            if (Test-GuardEnabled $cfg 'G2') { Test-G2 $ti }
            if ($phase2) {
                $path = [string]$ti.file_path
                $rel = Get-RelativePath $script:projectDir $path
                if (Test-GuardEnabled $cfg 'G11') { Test-G11 $rel $path }
                if (Test-GuardEnabled $cfg 'G5')  { Test-G5 $rel $path }
                if (Test-GuardEnabled $cfg 'G6')  { Test-G6 $ti $rel $path }
                if (Test-GuardEnabled $cfg 'G8')  { Test-G8 $rel $path }
                if (Test-GuardEnabled $cfg 'G9')  { Test-G9 $rel $path }
            }
        }
        '^AskUserQuestion$'     {
            if ($script:teamProject -and (Test-GuardEnabled $cfg 'G18')) { Test-G18Ask $ti }   # modo benchmark responde antes da G3
            if (Test-GuardEnabled $cfg 'G3') { Test-G3 $ti }
        }
        '^Agent$'               {
            if ($script:teamProject -and (Test-GuardEnabled $cfg 'G18')) { Test-G18Agent $ti }
            if ($phase2 -and (Test-GuardEnabled $cfg 'G7')) { Test-G7 $ti }
            if ($script:teamProject -and (Test-GuardEnabled $cfg 'G17')) { Test-G17 $ti }   # vale também para a sessão principal
            # v3.51 (G20): agente disparado fica registrado até voltar, sem depender do .active-run (gravado na mesma resposta,
            # chegava depois — garden item 5). O kanban.md mostra todos em "## Agora". v3.52.2 (note.md itens 2-4): TODO Agent em
            # projeto com o time — da sessão e de papel (o executor de Task e os filhos dele, para a retomada) —, com a sessão
            # (session_id) e quem disparou (parent = agent_id do papel; '' = sessão principal). Sem "bg": todo agente é assíncrono.
            if ($script:teamProject -and $ti.subagent_type) {
                $desc = ([string]$ti.description + ' ' + $(if ($ti.prompt) { ([string]$ti.prompt).Substring(0, [Math]::Min(400, ([string]$ti.prompt).Length)) } else { '' })).Trim()
                $parent = if ($script:role) { [string]$script:hookInput.agent_id } else { '' }
                Add-ActiveAgent $script:projectDir ([string]$ti.subagent_type) $desc ([string]$script:hookInput.session_id) $parent
            }
        }
        '^SendMessage$'         {
            if ($script:teamProject -and (Test-GuardEnabled $cfg 'G19')) { Test-G19 $ti }
        }
    }

    # G14 — depois de todas as negações: só papel do time, em projeto com o time, com run ativo.
    if ($phase2 -and $script:teamProject -and $tool -match '^(PowerShell|Bash|Edit|Write)$' -and (Test-GuardEnabled $cfg 'G14')) {
        $allow = Test-G14 $ti
    }

    # Sonda (guards.json "probe": true): agent_type recebido e tempo do script — verifica a fase 2 e mede o custo do hook.
    if ($cfg.probe) {
        $agent = if ($script:hookInput.agent_type) { [string]$script:hookInput.agent_type } else { '(ausente)' }
        Write-GuardLog $script:projectDir 'probe' $script:hookInput '' ("agent_type=$agent; agent_id=" + [string]$script:hookInput.agent_id + "; script_ms=" + $sw.ElapsedMilliseconds + $(if ($allow) { '; G14 allow' } else { '' }))
    }
    # v3.51.4: a última ação do subagente vai ao .active-agents e ao "## Agora" do kanban.md (sinal de vida, note.md item 15).
    if ($script:role -and $script:teamProject) {
        $act = switch -Regex ($tool) { '^(PowerShell|Bash)$' { [string]$ti.command } '^(Edit|Write)$' { "$tool $(Split-Path ([string]$ti.file_path) -Leaf)" } default { $tool } }
        try { Update-ActiveAgent $script:projectDir ([string]$script:hookInput.agent_id) ([string]$script:hookInput.agent_type) $act } catch { }
    }
    if ($allow) { Write-Allow 'operação do run, já conferida pelas guardas (.team-project/.active-run)' }
    exit 0
} catch {
    try { Write-GuardLog $script:projectDir 'erro' $script:hookInput 'pre-tool.ps1' $_.Exception.Message } catch { }
    exit 1
}
