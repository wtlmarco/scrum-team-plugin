# Despachante PreToolUse — fase 1 (v3.39): G1 (R31) · G2 (cópia instalada) · G3 (R22);
# fase 2 (v3.42), por papel (sufixo de agent_type): G5 gate protegido · G6 teste ignorado · G7 Agent só ao operator (R28)
# · G8 matriz de propriedade (hooks/ownership.json) · G9 escopo do dev (R4 · R8) · G11 pasta do job do operator.
# Devolve a PRIMEIRA negação: exit 2 com o motivo no stderr; "ask" (G8, Arquiteto em código) sai em JSON com exit 0.
# Qualquer exceção → exit 1 (erro não bloqueante — falha aberta, D5). Cobertura e limites: hooks/COVERAGE.md.

$ErrorActionPreference = 'Stop'
$sw = [System.Diagnostics.Stopwatch]::StartNew()
. (Join-Path $PSScriptRoot 'common.ps1')

function Deny([string]$Guard, [string]$Target, [string]$Reason) {
    Write-GuardLog $script:projectDir $Guard $script:hookInput $Target "deny: $Reason"
    [Console]::Error.WriteLine("[$Guard] $Reason")
    exit 2
}

function Ask([string]$Guard, [string]$Target, [string]$Reason) {
    Write-GuardLog $script:projectDir $Guard $script:hookInput $Target "ask: $Reason"
    $out = @{ hookSpecificOutput = @{ hookEventName = 'PreToolUse'; permissionDecision = 'ask'; permissionDecisionReason = "[$Guard] $Reason" } } | ConvertTo-Json -Depth 4 -Compress
    [Console]::Out.Write($out)
    exit 0
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

# ---------------- Fase 2 — guardas por papel ----------------

# Alvos de escrita num comando PowerShell (heurística: cmdlets de escrita e redirecionamento; variável não se resolve).
function Get-WriteTargets([string]$Cmd) {
    $targets = @()
    foreach ($st in ($Cmd -split '[;\r\n|]')) {
        $m = [regex]::Match($st, '(?i)\b(Set-Content|Add-Content|Out-File|New-Item|Clear-Content|Remove-Item|Copy-Item|Move-Item)\b(.*)$')
        if ($m.Success) {
            $verb = $m.Groups[1].Value.ToLowerInvariant(); $rest = $m.Groups[2].Value
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
        foreach ($rm in [regex]::Matches($st, '>{1,2}(?!&)\s*(?:''([^'']*)''|"([^"]*)"|([^\s''"]+))')) {
            $targets += ($rm.Groups[1].Value + $rm.Groups[2].Value + $rm.Groups[3].Value)
        }
    }
    return @($targets | Where-Object { $_ -and $_ -notmatch '^\$' -and $_ -notmatch '\$\(' })
}

# G5 — arquivo de gate (guards.json → protectedPaths): nenhum subagente altera; a sessão segue o pedido de permissão do harness.
function Test-G5([string]$Rel, [string]$Shown) {
    if (-not $script:role -or -not $Rel) { return }
    if (Test-GlobMatch $Rel $cfg.protectedPaths) {
        Deny 'G5' $Shown "$Rel é arquivo de gate protegido (guards.json → protectedPaths): subagente não altera configuração de gate — gate não se desliga, não se afrouxa, não se contorna (R7; plano §9). Pare e levante 🔺 GAP: o Arquiteto põe o diff em **Arquivos protegidos:** (plano §12) e a sessão principal o aplica, com a permissão do stakeholder (sprint-run.md passo 3)."
    }
}

# G6 — o dev não acrescenta teste ignorado (guards.json → testSkipPatterns).
function Test-G6([object]$ToolInput, [string]$Rel, [string]$Shown) {
    if ($script:role -ne 'developer' -or -not $Rel) { return }
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
        Ask 'G8' $Shown "o Arquiteto vai escrever código-fonte ($Rel). Código é do dev, pelo Plano de Implementação; só vale em spike ou a pedido explícito do stakeholder. Autorizar?"
    }
    Deny 'G8' $Shown "$Rel é código-fonte: escreve o dev, só nos arquivos do Plano de Implementação (artifact-ownership.md §1). Leve a mudança ao Arquiteto, que planeja."
}

# Escopo ativo do dev: .team-project/.active-task → arquivos do plano (Task) ou do mini-plano (trilha fix).
function Get-ActiveScope {
    $p = Join-Path $script:projectDir '.team-project/.active-task'
    if (-not (Test-Path -LiteralPath $p)) { return $null }
    $a = Get-Content -LiteralPath $p -Raw -Encoding UTF8 | ConvertFrom-Json
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
    if ($script:role -ne 'developer' -or -not $Rel -or -not $script:teamProject) { return }
    if ($Rel.StartsWith('.team-project/')) { return }                # processo: G8
    $scope = Get-ActiveScope
    if ($null -eq $scope) {
        Deny 'G9' $Shown "nenhum escopo ativo (.team-project/.active-task ausente): sem plano, sem código (R8). Pare e reporte — quem orquestra grava o escopo antes de disparar o dev."
    }
    if ($scope.Files.Count -eq 0) {
        Deny 'G9' $Shown "o plano de $($scope.Id) ($($scope.Plano)) não tem lista de arquivos legível (caminhos entre crases em **Arquivos tocados:** ou em - produção:/- teste:). Pare e levante 🔺 GAP ao Arquiteto (R8)."
    }
    if ($scope.Files -contains $Rel) { return }
    Deny 'G9' $Shown "arquivo fora do plano: $Rel não está na lista de $($scope.Id) ($($scope.Plano)). Pare e levante 🔺 GAP ao Arquiteto antes de editar (R4 · R8) — quem orquestra resolve com o Arquiteto, não com o stakeholder (R25)."
}

# G11 — contrato do operator, item 6: escreve só na pasta do próprio job.
function Test-G11([string]$Rel, [string]$Shown) {
    if ($script:role -ne 'operator') { return }
    if ($Rel -and $Rel -match '^\.team-project/operator/[^/]+/[^/]+/.+') { return }
    Deny 'G11' $Shown "o operator escreve só na pasta do próprio job — .team-project/operator/<sprint|pre-sprint|B-nnn>/<job>/ (contrato, item 6). Réplica e rascunho ficam lá dentro; o código do projeto não se toca."
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

    switch -Regex ($tool) {
        '^(PowerShell|Bash)$'   {
            if (Test-GuardEnabled $cfg 'G1') { Test-G1 $ti }   # G1 vale sem guards.json (D5)
            if ($phase2) {
                $base = if ($script:hookInput.cwd) { [string]$script:hookInput.cwd } else { $script:projectDir }
                foreach ($t in (Get-WriteTargets ([string]$ti.command))) {
                    $full = if ([System.IO.Path]::IsPathRooted($t)) { $t } else { Join-Path $base $t }
                    $rel = Get-RelativePath $script:projectDir $full
                    if (Test-GuardEnabled $cfg 'G5') { Test-G5 $rel $t }
                    if ((Test-GuardEnabled $cfg 'G9') -and $t -notmatch '(?i)\.log$') { Test-G9 $rel $t }   # log redirecionado (R28) não é produto
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
        '^AskUserQuestion$'     { if (Test-GuardEnabled $cfg 'G3') { Test-G3 $ti } }
        '^Agent$'               { if ($phase2 -and (Test-GuardEnabled $cfg 'G7')) { Test-G7 $ti } }
    }

    # Sonda (guards.json "probe": true): agent_type recebido e tempo do script — verifica a fase 2 e mede o custo do hook.
    if ($cfg.probe) {
        $agent = if ($script:hookInput.agent_type) { [string]$script:hookInput.agent_type } else { '(ausente)' }
        Write-GuardLog $script:projectDir 'probe' $script:hookInput '' ("agent_type=$agent; agent_id=" + [string]$script:hookInput.agent_id + "; script_ms=" + $sw.ElapsedMilliseconds)
    }
    exit 0
} catch {
    try { Write-GuardLog $script:projectDir 'erro' $script:hookInput 'pre-tool.ps1' $_.Exception.Message } catch { }
    exit 1
}
