# Linguagem de acompanhamento (v3.59.0, pedido do stakeholder em 14/11/2026: "frases simples e diretas, que alguém de
# negócio entenda sem termo técnico; o técnico, só quando pedir"). Fonte única das frases que quem acompanha o sprint lê:
# o "## Resumo" e o quadro do kanban.md (kanban.ps1), o "## Agora" (hooks/common.ps1), o /team-status (team-view.ps1) e a
# linha PARA O STAKEHOLDER: do run.ps1 next. O detalhe técnico continua onde estava (/team-status detalhe, run-log.md, o
# fim do kanban.md).
# Carregado pelo hooks/common.ps1 (as funções de nome, papel e ação não dependem do lib.ps1) e pelos scripts do quadro.
# Get-PlainSummary e Get-PlainPending usam o lib.ps1 (Get-SprintTasks, Get-Section, Get-Tables) — só quem o carregou as chama.

$script:PlainTodo = [char]::ConvertFromUtf32(0x2B1C); $script:PlainPlan = [char]::ConvertFromUtf32(0x1F7E6)
$script:PlainBuild = [char]::ConvertFromUtf32(0x1F7E8); $script:PlainQA = [char]::ConvertFromUtf32(0x1F7EA)
$script:PlainDone = [char]::ConvertFromUtf32(0x2705); $script:PlainRed = [char]::ConvertFromUtf32(0x1F534)
$script:PlainIdRe = '(?:Q-S\d+[a-z]?|[A-Z]+-\d+[a-z]?)'

# As etapas do quadro, na ordem de leitura de quem acompanha (o que anda primeiro, o que está pronto por último).
# Plural: o título do grupo no quadro; Singular: a etapa de uma parte numa frase ("Vendas — em construção").
$script:PlainStages = @(
    @{ Mark = $script:PlainBuild; Plural = 'Em construção'; Singular = 'em construção' },
    @{ Mark = $script:PlainQA; Plural = 'Em teste'; Singular = 'em teste' },
    @{ Mark = $script:PlainRed; Plural = 'Paradas'; Singular = 'parada' },
    @{ Mark = $script:PlainPlan; Plural = 'Sendo planejadas'; Singular = 'sendo planejada' },
    @{ Mark = $script:PlainTodo; Plural = 'Na fila'; Singular = 'na fila' },
    @{ Mark = $script:PlainDone; Plural = 'Prontas'; Singular = 'pronta' })
function Get-PlainStage([string]$Mark) {
    foreach ($s in $script:PlainStages) { if ($Mark -and $Mark.Contains($s.Mark)) { return $s.Singular } }
    return 'na fila'
}

# Papel com nome de gente, sem sigla solta (v3.57.1: "Dev", "Executor da Task"; v3.59.0: o nome que alguém de negócio reconhece).
function Get-PlainRole([string]$Type) {
    $r = $Type -replace '^.*:', ''
    switch ($r) {
        'developer' { 'Desenvolvedor' } 'task-runner' { 'Coordenador da tarefa' } 'architect' { 'Arquiteto' }
        'quality-assurance' { 'Qualidade (QA)' } 'operator' { 'Operador de testes' } 'product-owner' { 'Dono do produto (PO)' }
        'scrum-master' { 'Scrum Master' } 'user-experience' { 'Designer (UX)' } 'security-engineer' { 'Segurança' }
        'watcher' { 'Vigia (só acompanha a espera)' } default { $r }
    }
}

# O que o agente faz, traduzido do último comando (v3.57.1). Arquivo e disparo antes dos padrões de comando:
# "Edit karma.conf.js" não é "rodando os testes".
function Get-PlainAction([string]$Last) {
    $l = [string]$Last
    switch -Regex ($l) {
        '^\s*$|^disparado$'                                   { return 'começando' }
        '^(Edit|Write)\s+(.+)$'                               { return "alterando o arquivo $($Matches[2])" }
        '^Agent$'                                             { return 'chamando outro membro do time' }
        '^aguardando filho$'                                  { return 'esperando o membro do time que ele chamou terminar' }
        'verify\.ps1.*-Mode\s+full'                           { return 'conferindo tudo: compilação, testes e cobertura' }
        'verify\.ps1.*(-Mode\s+mutation|-Precheck)'           { return 'provando que os testes pegam erros' }
        'verify\.ps1'                                         { return 'rodando os testes do que mudou' }
        'accept\.ps1'                                         { return 'testando no app rodando (emulador ou navegador)' }
        'target\.ps1.*-Repair'                                { return 'religando o ambiente de teste' }
        'target\.ps1.*-Kill'                                  { return 'encerrando um processo travado do ambiente de teste' }
        'target\.ps1'                                         { return 'conferindo se o ambiente de teste está pronto' }
        'run\.ps1"?\s+wait'                                   { return 'conferindo se a espera terminou' }
        'run\.ps1'                                            { return 'passando a tarefa para a próxima etapa' }
        'close\.ps1'                                          { return 'fechando a tarefa e conferindo a entrega' }
        'plan\.ps1'                                           { return 'conferindo o plano da tarefa' }
        '(mark|kanban)\.ps1'                                  { return 'atualizando o quadro' }
        '\bgit\s+commit\b'                                    { return 'guardando o trabalho no histórico do código' }
        '\bgit\s'                                             { return 'consultando o histórico do código' }
        'alvo:apk|assemble(Debug|Release)|\bcap\s+sync\b'     { return 'gerando o aplicativo para o celular' }
        'cobertura|coverage'                                  { return 'rodando os testes com cobertura' }
        '\b(test|tests|jest|vitest|karma|pytest)\b'           { return 'rodando os testes' }
        '\bbuild\b|\btsc\b'                                   { return 'compilando o app' }
        '\blint\b'                                            { return 'conferindo o padrão do código' }
        '\badb\b'                                             { return 'operando o emulador' }
        default                                               { return 'trabalhando' }
    }
}

function Get-PlainClean([string]$Text, [int]$Max = 0) {
    $x = (([string]$Text -replace '\*\*|`|~~', '') -replace '\s+', ' ').Trim()
    if ($Max -gt 0 -and $x.Length -gt $Max) { $x = $x.Substring(0, $Max).TrimEnd(' ', ',', ';', ':', '—', '-') + '…' }
    return $x
}

# Nome de cada parte do sprint para quem acompanha: Id → nome. Ordem de preferência:
# 1. a coluna "Para o stakeholder" do quadro (v3.59.0, escrita na Planning: o que a pessoa reconhece no app);
# 2. o título da História (já em linguagem de produto) com "parte k de m" quando ela tem mais de uma Task;
# 3. a correção do portão: "ajustes pedidos na revisão final";
# 4. o título da Task (a frase em negrito, se houver; até o primeiro " (" e 60 caracteres) — v3.57.1.
function Get-PlainNames([string]$ProjectDir, [string]$Sprint) {
    $out = @{}
    try {
        $bp = Join-Path $ProjectDir ".team-project/sprints/$Sprint/sprint-backlog.md"
        if (-not (Test-Path -LiteralPath $bp)) { return $out }
        $rows = @(); $group = $null; $gkey = ''; $gtitle = ''; $header = $null
        foreach ($line in ([System.IO.File]::ReadAllText($bp, (New-Object System.Text.UTF8Encoding($false))) -split "`r?`n")) {
            if ($line -match '^##\s') {
                $header = $null; $gtitle = ''; $gkey = ''
                $hm = [regex]::Match($line, '^##\s+Hist[oó]ria\s+(H-[\w]+)\s*(?:[—–:-]+\s*(.*))?$')
                if ($hm.Success) {
                    $group = 'story'; $gkey = $hm.Groups[1].Value
                    $gtitle = Get-PlainClean (($hm.Groups[2].Value -replace '\s*\([^()]*\)\s*$', ''))
                } elseif ($line -match '^##\s+(?i)corre[çc][ãa]o do port[ãa]o') { $group = 'gate'; $gkey = 'gate' }
                else { $group = 'other' }
                continue
            }
            if (-not $line.TrimStart().StartsWith('|')) { $header = $null; continue }
            $cells = @(($line.Trim().Trim('|')) -split '\|' | ForEach-Object { $_.Trim() })
            if ((Get-PlainClean $cells[0]) -eq 'ID') { $header = @($cells | ForEach-Object { Get-PlainClean $_ }); continue }
            if (-not $header -or $line -match '^\s*\|[\s:\-|]+\|\s*$') { continue }
            $idm = [regex]::Match($cells[0], $script:PlainIdRe); if (-not $idm.Success) { continue }
            if ($cells[0] -match '~~' -or $cells[0] -match '(?i)\bretirada\b' -or $out.ContainsKey($idm.Value) -or @($rows | Where-Object { $_.Id -eq $idm.Value }).Count) { continue }
            $pi = -1; $ti = 1
            for ($k = 0; $k -lt $header.Count; $k++) { if ($header[$k] -match '(?i)^para o stakeholder') { $pi = $k }; if ($header[$k] -eq 'Task') { $ti = $k } }
            $plain = if ($pi -ge 0 -and $pi -lt $cells.Count) { Get-PlainClean $cells[$pi] } else { '' }
            if ($plain -match '^(<.*>|[—–-]+|n/?a)$') { $plain = '' }
            $title = if ($ti -lt $cells.Count) { [string]$cells[$ti] } else { '' }
            $rows += [pscustomobject]@{ Id = $idm.Value; Group = $group; Key = $gkey; GroupTitle = $gtitle; Plain = $plain; Title = $title }
        }
        foreach ($g in @($rows | Group-Object Key)) {
            $list = @($g.Group); $i = 0
            foreach ($r in $list) {
                $i++
                $part = if ($list.Count -gt 1 -and $r.Key) { " — parte $i de $($list.Count)" } else { '' }
                $name = if ($r.Plain) { $r.Plain }
                        elseif ($r.Group -eq 'story' -and $r.GroupTitle) { $r.GroupTitle + $part }
                        elseif ($r.Group -eq 'gate') { 'ajustes pedidos na revisão final' + $part }
                        else {
                            $bold = [regex]::Match($r.Title, '^\s*\*\*([^*]{3,60}?):?\*\*')
                            $x = if ($bold.Success) { $bold.Groups[1].Value.Trim() } else { Get-PlainClean $r.Title }
                            $cut = $x.IndexOf(' ('); if ($cut -gt 10) { $x = $x.Substring(0, $cut) }
                            Get-PlainClean $x 60
                        }
                if (-not $name) { $name = $r.Id }
                $out[$r.Id] = Get-PlainClean $name 80
            }
        }
    } catch { }
    return $out
}
# "<nome> (T-081)" — o código no fim, para quem quiser pedir o detalhe técnico.
function Get-PlainLabel($Names, [string]$Id) {
    if (-not $Id) { return 'tarefa sem identificação' }
    if ($Names -and $Names.ContainsKey($Id) -and $Names[$Id] -ne $Id) { return "$($Names[$Id]) ($Id)" }
    return $Id
}

# Motivo de parada (a natureza da linha em "Bloqueios e riscos abertos", ou o -Reason do mark.ps1) em frase simples.
function Get-PlainReason([string]$Why) {
    $w = [string]$Why
    switch -Regex ($w) {
        '(?i)prova no alvo retomada'                    { return 'voltou a ser testada no app' }
        '(?i)prova no alvo pendente'                    { return 'falta testar no app rodando: o ambiente de teste caiu' }
        '(?i)estado de partida'                         { return 'o teste no app não encontra a tela por onde começa; precisa de uma decisão' }
        '(?i)ids? n[ãa]o publicados'                    { return 'o teste no app não enxerga os elementos da tela; precisa de uma decisão' }
        '(?i)docker|emulador|ambiente|alvo|aparelho'    { return 'problema no ambiente de teste (emulador ou Docker)' }
        '(?i)teto de contexto|G23|grande demais|dividir' { return 'ficou grande demais para uma rodada; vai ser dividida' }
        '(?i)capacidade'                                { return 'risco de não caber no sprint' }
        '(?i)depend'                                    { return 'espera outra parte ficar pronta' }
        '(?i)lacuna funcional|produto|requisito'        { return 'dúvida sobre como o produto deve funcionar' }
        '(?i)risco t[ée]cnico|desenho|arquitet'         { return 'dúvida técnica com o arquiteto' }
        '(?i)qualidade|vermelho|falh'                   { return 'um teste está falhando' }
        '(?i)comando'                                   { return 'precisa de autorização para um comando de compilação ou teste' }
    }
    $x = Get-PlainClean (($w -split '[;:(]')[0]) 60
    if ($x) { return $x }
    return 'parada; o motivo técnico está no fim do quadro (Bloqueios)'
}

# Pendências do stakeholder no README §7 que ainda esperam por ele: numeradas, sem as resolvidas, guardadas ou em andamento
# (v3.59.0: o /team-status contava as 98 resolvidas do garden e dizia "131 decisões"). A mais recente (maior número) primeiro.
function Get-PlainPending([string]$ReadmeText) {
    $sec = Get-Section $ReadmeText '^##\s+7\.'
    if (-not $sec) { return @() }
    $items = @()
    foreach ($l in ($sec -split "`r?`n")) {
        $m = [regex]::Match($l, '^\s*(\d+)\.\s+(\S.*)$'); if (-not $m.Success) { continue }
        $t = $m.Groups[2].Value
        if ($t -match '^\**\s*nenhuma\b' -or $t -match '(?i)RESOLVID|GUARDAD|EM ANDAMENTO|^\s*~~') { continue }
        $raw = Get-PlainClean $t; $num = [int]$m.Groups[1].Value
        # a mesma pendência gravada duas vezes (mesmo texto, ou o mesmo número reescrito — no garden, dois "107.") conta uma
        if (@($items | Where-Object { $_.Raw -eq $raw -or $_.N -eq $num }).Count) { continue }
        $items += [pscustomobject]@{ N = $num; Raw = $raw; Text = (Get-PlainClean ($t -replace '^\s*\**\s*\[[^\]]*\]\s*', '')) }
    }
    return @($items | Sort-Object N -Descending)
}

# As passagens a ✅ no Registro de transições, na ordem do arquivo (para "a última pronta foi …" e "as mais recentes").
function Get-PlainDoneLog([string]$SprintDir) {
    $chart = Get-ChartPath $SprintDir; if (-not (Test-Path -LiteralPath $chart)) { return @() }
    $reg = Get-Section (Read-Text $chart) '^##\s+Registro de transi'; if (-not $reg) { return @() }
    $t = @(Get-Tables $reg)[0]; if (-not $t) { return @() }
    $out = @()
    foreach ($r in $t.Rows) {
        if ((Get-Cell $r 1) -notmatch [regex]::Escape($script:PlainDone) + '\s*$') { continue }
        $id = ([regex]::Match((Get-Cell $r 0), $script:PlainIdRe)).Value; if (-not $id) { continue }
        $ds = ([regex]::Match((Get-Cell $r 2), '\d{4}-\d{2}-\d{2}( \d{2}:\d{2})?')).Value
        $out += [pscustomobject]@{ Id = $id; When = $ds }
    }
    return $out
}
function Get-PlainLastDone([string]$SprintDir) { $l = @(Get-PlainDoneLog $SprintDir); if ($l.Count) { return $l[-1] }; return $null }
function Format-PlainWhen([string]$When) {
    try { $d = [datetime]::ParseExact($When, [string[]]@('yyyy-MM-dd HH:mm', 'yyyy-MM-dd'), $null, 'None') } catch { return $When }
    if ($When.Length -le 10) { return "em $($d.ToString('dd/MM'))" }
    if ($d.Date -eq (Get-Date).Date) { return "às $($d.ToString('HH:mm'))" }
    return "em $($d.ToString('dd/MM')) às $($d.ToString('HH:mm'))"
}

# O resumo do sprint para quem acompanha (v3.59.0): uma lista de @{ K = rótulo; V = frase }, na ordem de leitura.
# -Live: estado de agora (run pausado, limite de conta, pergunta aberta) — o /team-status calcula na leitura; o kanban.md
# é gravado a cada transição e rodada, e o "agora mesmo" fica com o "## Agora" e o /team-status.
function Get-PlainSummary([string]$Root, [string]$Sprint, [switch]$Live, [switch]$Objective) {
    $tp = Join-Path $Root '.team-project'; $S = Join-Path $tp "sprints/$Sprint"
    $tasks = @(); if (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md')) { $tasks = @(Get-SprintTasks $S) }
    $names = Get-PlainNames $Root $Sprint
    $lab = { param($id) Get-PlainLabel $names $id }
    $closed = Test-Path -LiteralPath (Join-Path $S 'retrospective.md')
    $o = @()
    if ($Objective -and $tasks.Count) {
        $bt = Read-Text (Join-Path $S 'sprint-backlog.md')
        $om = [regex]::Match($bt, '(?m)^\|\s*\*\*Objetivo do sprint\*\*\s*\|\s*([^|\r\n]+)\|')
        if ($om.Success) { $o += @{ K = 'Objetivo'; V = (Get-PlainClean $om.Groups[1].Value 200) } }
    }
    $done = @($tasks | Where-Object { $_.Mark -eq $script:PlainDone })
    $estT = [double](@($tasks | Where-Object { $null -ne $_.Est } | ForEach-Object { $_.Est }) | Measure-Object -Sum).Sum
    $estD = [double](@($done | Where-Object { $null -ne $_.Est } | ForEach-Object { $_.Est }) | Measure-Object -Sum).Sum
    $pct = if ($estT -gt 0) { " (cerca de $([int][Math]::Round(100 * $estD / $estT))% do trabalho estimado)" } else { '' }
    $o += @{ K = 'Andamento'; V = "$($done.Count) de $($tasks.Count) partes prontas$pct$(if ($closed) { ' — sprint encerrado' })" }
    $moving = @($tasks | Where-Object { $_.Mark -eq $script:PlainBuild -or $_.Mark -eq $script:PlainQA })
    $open = @($tasks | Where-Object { $_.Mark -ne $script:PlainDone })
    if ($moving.Count) { $o += @{ K = 'Em andamento'; V = (($moving | ForEach-Object { "$(& $lab $_.Id) — $(Get-PlainStage $_.Mark)" }) -join '; ') } }
    elseif ($tasks.Count -and -not $open.Count) { $o += @{ K = 'Em andamento'; V = 'todas as partes estão prontas.' } }
    else {
        $ld = Get-PlainLastDone $S
        $o += @{ K = 'Em andamento'; V = 'nenhuma parte em construção neste momento' + $(if ($ld) { "; a última pronta foi $(& $lab $ld.Id) $(Format-PlainWhen $ld.When)." } else { '.' }) }
    }
    $red = @($tasks | Where-Object { $_.Mark -eq $script:PlainRed })
    if ($red.Count) {
        $bl = Get-BlockLines $S
        $txt = @($red | Select-Object -First 3 | ForEach-Object { $why = if ($bl.ContainsKey($_.Id)) { Get-PlainReason ([string]@($bl[$_.Id])[-1]) } else { 'parada; o motivo técnico está no fim do quadro (Bloqueios)' }; "$(& $lab $_.Id) — $why" })
        $o += @{ K = 'Parado'; V = ($txt -join '; ') + $(if ($red.Count -gt 3) { "; e mais $($red.Count - 3)" } else { '' }) }
    }
    $need = @()
    if ($Live -and -not $closed) {
        $lim = Join-Path $tp '.usage-limit'
        if (Test-Path -LiteralPath $lim) { $lj = $null; try { $lj = Read-Text $lim | ConvertFrom-Json } catch { }; $need += "nada por enquanto: o limite de uso da conta foi atingido$(if ($lj -and $lj.reset) { " e volta $([string]$lj.reset)" }); depois, digite /sm sprint run" }
        elseif ($open.Count -and -not (Test-Path -LiteralPath (Join-Path $tp '.active-run'))) { $need += 'o sprint está pausado — para continuar, digite /sm sprint run' }
    }
    if (-not $closed -and (Test-Path -LiteralPath (Join-Path $tp '.ask-route'))) { $need += 'responder a pergunta aberta na conversa do sprint' }
    $rdm = Join-Path $tp 'README.md'
    $pend = @(if (Test-Path -LiteralPath $rdm) { Get-PlainPending (Read-Text $rdm) })   # @() fora: uma pendência só não tem .Count no 5.1
    if ($pend.Count) { $need += "$($pend.Count) $(if ($pend.Count -eq 1) { 'decisão' } else { 'decisões' }) na lista de pendências (README §7); a mais recente: `"$(Get-PlainClean $pend[0].Text 90)`"" }
    $o += @{ K = 'Precisa de você'; V = $(if ($need.Count) { $need -join '; ' } else { 'nada agora.' }) }
    if (-not $closed) {
        $nextT = @($open | Where-Object { $_.Mark -eq $script:PlainPlan -or $_.Mark -eq $script:PlainTodo -or -not $_.Mark } | Select-Object -First 2)
        if ($nextT.Count) { $o += @{ K = 'A seguir'; V = (($nextT | ForEach-Object { & $lab $_.Id }) -join '; depois, ') } }
        elseif ($tasks.Count -and -not $open.Count) { $o += @{ K = 'A seguir'; V = 'a revisão final do sprint (todos os testes do app) e, depois, a apresentação do que foi feito (Review).' } }
    }
    return $o
}
