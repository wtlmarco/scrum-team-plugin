# Despachante PreToolUse — fase 1 (v3.39): G1 (R31) · G2 (cópia instalada) · G3 (R22);
# fase 2 (v3.42), por papel (sufixo de agent_type): G5 gate protegido · G6 teste ignorado · G7 Agent só ao operator (R28)
# · G8 matriz de propriedade (hooks/ownership.json) · G9 escopo do dev (R4 · R8) · G11 pasta do job do operator;
# v3.44: G14 permissão operacional do run (.team-project/.active-run) — nenhum pedido de permissão do harness trava um papel;
# v3.47: G17 modelo do papel (.team-project/models.json) — a ferramenta Agent obedece ao modelo configurado;
# G18 modo benchmark (guards.json → bench) — o dossiê responde o AskUserQuestion e o agente roda em primeiro plano;
# perfil Arquiteto executor (M2): com .active-executor e models.json "executor", a G8/G9/G6 tratam o Arquiteto como o dev.
# v3.51: G3 exige o exemplo prático (H1); G19 nega SendMessage a papel caro parado há mais de 5 min (C1); o Agent em
# segundo plano durante o run é registrado em .active-agents para o hook Stop (G20).
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
function Get-CommandVars([string]$Cmd) {
    $vars = @{}
    $q = '(?:''([^'']*)''|"([^"$`]*)")'
    foreach ($m in [regex]::Matches($Cmd, '\$(\w+)\s*=\s*(?:Join-Path\s+(\(Get-Location\)(?:\.Path)?|\$PWD|\$\w+)\s+' + $q + '|' + $q + ')\s*(?=;|\r?\n|$)')) {
        $name = $m.Groups[1].Value.ToLowerInvariant()
        if ($m.Groups[2].Success) {
            $lit = $m.Groups[3].Value + $m.Groups[4].Value
            $base = $m.Groups[2].Value
            if ($base -match '^\$(\w+)$' -and $base -notmatch '^\$PWD$') {
                $bn = $Matches[1].ToLowerInvariant()
                if (-not $vars.ContainsKey($bn)) { continue }
                try { $vars[$name] = (Join-Path $vars[$bn] $lit) } catch { }
            } else { $vars[$name] = $lit }                     # (Get-Location) / $PWD: relativo à pasta corrente
        } else { $vars[$name] = $m.Groups[5].Value + $m.Groups[6].Value }
    }
    return $vars
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
    # Variável do mesmo comando ($dir, "$dir\x.log"): troca pelo literal; o que sobrar com $ não se resolve.
    $targets = @($targets | ForEach-Object {
        $t = [string]$_
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

# G7 — R28: a ferramenta Agent serve só ao operator.
function Test-G7([object]$ToolInput) {
    if ($script:role -notin 'architect', 'developer', 'quality-assurance', 'user-experience') { return }
    $target = (([string]$ToolInput.subagent_type) -replace '^.*:', '').ToLowerInvariant()
    if ($target -ne 'operator') {
        $shown = if ($ToolInput.subagent_type) { [string]$ToolInput.subagent_type } else { '(sem subagent_type)' }
        Deny 'G7' $shown "a ferramenta Agent serve só ao operator (R28) — disparar outro papel ($shown) atropela a propriedade dos artefatos. Delegue a execução pesada ao operator; o resto, reporte a quem orquestra."
    }
}

# G18 — v3.47 (M3), modo benchmark: guards.json "bench". O experimento roda sem o stakeholder.
#   bench.answers  → JSON { "respostas": [ { "tema", "match" (regex na pergunta+título), "pick" (regex no rótulo da opção) } ] }.
#                    O AskUserQuestion é NEGADO e a resposta volta no motivo: "[bench] resposta do stakeholder: <opção>".
#                    Sem regra que case, vale a opção marcada como recomendada (nunca "Pedir mais contexto"). Tudo vai a
#                    .team-project/benchmark/<bench.arm>/questions.log (tema · origem da resposta · pergunta · resposta).
#   bench.foreground (true) → agente em segundo plano é negado: o claude -p encerra antes da notificação.
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
    'get-member', 'get-winevent', 'get-process',
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
    $base = if ($script:hookInput.cwd) { [string]$script:hookInput.cwd } else { $script:projectDir }
    foreach ($t in $targets) {
        if (Test-ProviderDrive $t) { if (Test-SessionDrive $t) { continue } else { return $false } }
        $full = if ([System.IO.Path]::IsPathRooted($t)) { $t } else { Join-Path $base $t }
        if (-not (Get-RelativePath $script:projectDir $full) -and -not (Test-UnderTemp $full)) { return $false }
    }
    return $true
}

function Test-RunSegment([string]$Seg, [string[]]$Allowed) {
    $s = $Seg.Trim()
    $s = $s -replace '^(?i)(if|elseif|else|foreach|for|while|switch|try|catch|finally|return|do)\b\s*', ''
    $s = $s -replace '^\$[\w:.]+\s*[-+]?=\s*', ''
    # v3.48: método estático de leitura do .NET — [Math]::Min, [regex]::Replace, [IO.File]::ReadAllText (escrita por .NET
    # já foi negada antes, em Test-G14).
    if ($s -match '^(?i)\[(System\.)?(Math|String|Char|Convert|Int32|Int64|Double|Decimal|DateTime|TimeSpan|Guid|Text\.RegularExpressions\.Regex|Regex|IO\.Path|Linq\.Enumerable)\]::\w+\s*$') { return $true }
    if ($s -match '^(?i)\[(System\.)?IO\.File\]::(ReadAllText|ReadAllLines|ReadAllBytes|ReadLines|Exists)\s*$') { return $true }
    $s = $s -replace '^(\[[^\]]+\]\s*)+', '' -replace '^\$[\w:.]+\s*[-+]?=\s*', '' -replace '^&\s*', ''
    $s = $s.Trim()
    if (-not $s -or $s -match '^[\$@''"\-\d\[,!=+*/%<>]' -or $s -match '^\w+\s*=\s') { return $true }   # expressão, não comando
    # Propriedade do resultado entre parênteses — (Get-Content f).Count — é leitura; método chega aqui como __metodo_<nome>.
    if ($s -match '^\.[A-Za-z_]\w*(\.[A-Za-z_]\w*)*(\s*\[[^\]]*\])?$') { return $true }
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
    $verb = ($low -split '\s+')[0]
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
    if ($cmd -match '^\s*(?i)(powershell|pwsh)(\.exe)?\s+(-\w+\s+)*-File\s+"?[^";|&]*[\\/]scripts[\\/]checks[\\/][\w-]+\.ps1"?([^;|&]|[*\d]?>&1)*(\|\s*Out-String\s*)?$') { return $true }
    $why = 'fora da lista operacional do run'
    if ($cmd -match '(?i)--no-verify|\bInvoke-Expression\b|\biex\b|-EncodedCommand|\bStart-Process\b|\[(System\.)?IO\.(File|Directory)\]::(Write|Append|Delete|Move|Copy|Replace|Create)') { $why = 'construção que a G14 não libera (--no-verify, Invoke-Expression, Start-Process, escrita por .NET)' }
    else {
        $script:cmdVars = Get-CommandVars $cmd
        $script:qmap = New-Object System.Collections.ArrayList
        $flat = [regex]::Replace($cmd, '"([^"]*)"|''[^'']*''', { param($m)
            if ($m.Value.StartsWith('"') -and $m.Groups[1].Value.Contains('$(')) { return ' ' + $m.Groups[1].Value + ' ' }
            [void]$script:qmap.Add($m.Value); return '"__q' + ($script:qmap.Count - 1) + '__"' })
        # Chamada de método sobre o resultado — (Get-Item f).Delete() — vira um segmento próprio, que nenhuma lista libera.
        $flat = [regex]::Replace($flat, '\)\s*\.\s*([A-Za-z_]\w*)\s*\(', { param($m) ') ; __metodo_' + $m.Groups[1].Value + ' (' })
        $allowed = @($script:runBase) + @($cfg.runCommands)
        $ok = $true; $badSeg = ''
        foreach ($seg in ($flat -split '\$\(|;|&&|\|\||\||\r?\n|[{}()]')) { if (-not (Test-RunSegment $seg $allowed)) { $ok = $false; $badSeg = (Restore-Quoted $seg).Trim(); break } }
        if ($ok) { return $true }
        if (@($cfg.runCommands).Count -eq 0) { return $false }        # projeto sem runCommands: o harness decide, como antes
        if ($badSeg.Length -gt 80) { $badSeg = $badSeg.Substring(0, 80) + '…' }
        if ($badSeg -match '^(?i)start-sleep\b') { $why = "espera com Start-Sleep durante o run (``$badSeg``) — o papel fica parado consumindo contexto. Não espere processo: rode o comando em primeiro plano, com timeout; execução longa (build, suíte, cobertura) vai ao operator, em primeiro plano (R28)" }
        elseif ($badSeg -match '^(?i)(robocopy|xcopy)\b') { $why = "cópia em massa (``$badSeg``) — réplica do projeto para medir ou provar é trabalho do operator, na pasta do job (R28)" }
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
            # v3.51 (G20): agente em segundo plano disparado pela sessão durante o run fica registrado até voltar.
            if ($script:teamProject -and -not $script:role -and $ti.run_in_background -eq $true -and (Test-Path -LiteralPath (Join-Path $script:projectDir '.team-project/.active-run'))) {
                Add-ActiveAgent $script:projectDir ([string]$ti.subagent_type) ([string]$ti.description)
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
    if ($allow) { Write-Allow 'operação do run, já conferida pelas guardas (.team-project/.active-run)' }
    exit 0
} catch {
    try { Write-GuardLog $script:projectDir 'erro' $script:hookInput 'pre-tool.ps1' $_.Exception.Message } catch { }
    exit 1
}
