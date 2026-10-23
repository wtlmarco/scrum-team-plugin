# Orquestração do sprint run guiada por script (v3.51, B1 · B2 · C2). A sessão principal não decide o próximo passo
# relendo o roteiro: pergunta a este script, que lê o quadro e o disco e devolve a PRÓXIMA AÇÃO pronta — o papel, o modelo,
# o prompt curto com os caminhos e o comando de volta. No piloto, a sessão principal foi 35 % do custo, a 274 mil tokens
# de contexto por chamada; no protótipo do benchmark com a orquestração em script, o coordenador custou 6 %.
# Uso (raiz do projeto): powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/run.ps1" <next|start|done|handoff> [-Task T-041] [-Result ok|gap|env] [-Block k]
#   next      a próxima ação do sprint corrente (preparo → construção → validação → consolidação → Review)
#   start     dispara a construção da Task: escopo e marcador (dispatch.ps1), cartão de passagem e o prompt do dev
#   done      o dev voltou: ok → close.ps1 -Apply (fecha pela evidência do dev) · gap → rota ao Arquiteto · env → reparo
#   handoff   (re)gera o cartão de passagem da Task: sprints/<n>/handoff/<T-ID>.md, até ~2 KB (C2)
# Ordem do sprint (sprint-run.md): 1 preparo da construção por História (QA escreve os .scn; o Arquiteto planeja as Tasks
# da História numa instância) · 2 construção, Task a Task (o dev constrói, verifica, roda os cenários e corrige; o close
# fecha pela evidência) · 3 validação do sprint (o operator mede: quality + todos os cenários; o QA julga e escreve
# validation.md) · 4 achados voltam ao dev (dúvida → Arquiteto) · 5 consolidação dos documentos vivos (Arquiteto, uma vez)
# · 6 formulário de autorização da Review. Exit 0 · 2 = erro de uso · 3 = nada a fazer (fila vazia ou bloqueada).

param(
    [Parameter(Position = 0, Mandatory = $true)][ValidateSet('next', 'start', 'done', 'handoff')][string]$Action,
    [string]$Task = '',
    [ValidateSet('', 'ok', 'gap', 'env')][string]$Result = '',
    [string]$Block = '',
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
. (Join-Path $PSScriptRoot '..\..\hooks\common.ps1')
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8 = New-Object System.Text.UTF8Encoding($false)
$todoMk = [char]::ConvertFromUtf32(0x2B1C); $redMk = [char]::ConvertFromUtf32(0x1F534)
$plugin = '${CLAUDE_PLUGIN_ROOT}/scripts/checks'

function Out([string]$s) { [Console]::Out.WriteLine($s) }

function Get-Defined([string]$Root) {
    $d = Join-Path $Root '.team-project/quality-assurance/scenarios'
    return @(Get-ChildItem -Path $d -Filter '*.scn' -File -ErrorAction SilentlyContinue | ForEach-Object { [regex]::Matches((Read-Text $_.FullName), '(?m)^\s*scenario\s+(\S+)') } | ForEach-Object { $_.Groups[1].Value })
}
function Get-PlanFull($T, [string]$S) {
    if (-not $T.Plan -or $T.Plan -match '^plan/?$') { return $null }
    $f = Join-Path $S $T.Plan; if ((Test-Path -LiteralPath $f -PathType Leaf)) { return $f }; return $null
}
function Get-AgentLine([string]$Role) {
    $mc = Get-ModelsConfig $Root
    $model = if ($mc.State -eq 'ok' -and $mc.Models.ContainsKey($Role)) { "model `"$($mc.Models[$Role])`" (models.json)" } else { "model do agente ($(Get-AgentDefaultModel $Role))" }
    $cfg = Get-GuardConfig $Root; $bg = -not ($null -ne $cfg.bench -and $cfg.bench.foreground)
    return "Agent: subagent_type `"team:$Role`" · $model · run_in_background $($bg.ToString().ToLowerInvariant())"
}
# Outro script de conferência num processo filho (v3.51.4): os scripts escrevem com [Console]::Out, que no mesmo processo
# passa por fora do pipeline — o "| Out-String" voltava vazio e a saída do close/dispatch saía solta, sem ser lida.
function Invoke-Child([string]$Script, [string[]]$ArgList) {
    $ErrorActionPreference = 'Continue'
    $o = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot $Script) @ArgList 2>&1 | Out-String
    return @{ Code = $LASTEXITCODE; Out = $o }
}
# Marcador pelo mark.ps1 (v3.51.4): devolve a linha do mark, ou $null se ele recusou (a Task já estava lá).
function Set-Mark([string]$Id, [string]$To, [string]$By) {
    $r = Invoke-Child 'mark.ps1' @('-Task', $Id, '-To', $To, '-By', $By, '-Root', $Root)
    if ($r.Code -eq 0) { return (($r.Out -split "`r?`n") | Where-Object { $_ -match '^mark:' } | Select-Object -First 1) }
    return $null
}
# Estimativa do que falta (v3.51.4, note.md item 11): o consumo medido do sprint (G16) por Task fechada × as Tasks abertas.
# Piso: não inclui a sessão principal. Sem Task fechada, só o gasto até aqui.
function Get-RunEstimate {
    $up = Join-Path $tp 'usage.jsonl'; if (-not (Test-Path -LiteralPath $up)) { return $null }
    $dest = ".team-project/sprints/$n/consumption.md"
    $rows = @(foreach ($l in [System.IO.File]::ReadAllLines($up, $utf8)) { if ($l.IndexOf($dest) -lt 0) { continue }; try { $o = $l | ConvertFrom-Json; if ([string]$o.dest -eq $dest) { $o } } catch { } })
    if (-not $rows.Count) { return $null }
    $tok = ($rows | Measure-Object processed -Sum).Sum; $sec = ($rows | Measure-Object duration_s -Sum).Sum
    $doneIds = @($tasks | Where-Object { $_.Mark -eq $E.Done } | ForEach-Object { $_.Id })
    $openN = @($tasks | Where-Object { $_.Mark -ne $E.Done -and $_.Mark -ne $redMk }).Count
    $fmt = { param($t) '{0:N1} mi' -f ($t / 1e6) }
    $s = "CONSUMO DO SPRINT (medido, sem a sessão): $(& $fmt $tok) tokens · $([int]($sec / 60)) min em $($rows.Count) rodada(s)"
    if ($doneIds.Count -and $openN) {
        $per = $tok / $doneIds.Count; $perS = $sec / $doneIds.Count
        $s += " · por Task fechada ≈ $(& $fmt $per) · $([int]($perS / 60)) min → as $openN aberta(s) ≈ $(& $fmt ($per * $openN)) · $([int]($perS * $openN / 60)) min. Pausa segura: entre Tasks (sprint-run.md §Pausa segura)"
    }
    return $s
}
function Get-VerdictOf([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    $m = [regex]::Match((Read-Text $Path), '(?m)^\*\*Veredito:\*\*(.*)$'); if (-not $m.Success) { return '' }
    $mk = Get-VerdictMark $m.Groups[1].Value; if ($mk) { return $mk } else { return '' }
}

# Cartão de passagem (C2): o estado da Task em ~2 KB, para a instância nova não reler o plano inteiro nem o histórico.
function Write-Handoff($T, [string]$S, [string]$n) {
    $dir = Join-Path $S 'handoff'; New-Item -ItemType Directory -Force $dir | Out-Null
    $pf = Get-PlanFull $T $S; $planRel = if ($pf) { "sprints/$n/$($T.Plan)" } else { '(sem plano)' }
    $blocks = @(); $files = 0
    if ($pf) { $pt = Read-Text $pf; $blocks = @([regex]::Matches($pt, '(?m)^###\s+(Bloco\s+\d+.*)$') | ForEach-Object { $_.Groups[1].Value.Trim() }); $fm = [regex]::Match($pt, '(?s)\*\*Arquivos tocados:\*\*(.*?)(?:\r?\n[ \t]*\r?\n|\z)'); if ($fm.Success) { $files = @([regex]::Matches($fm.Groups[1].Value, '`[^`]+`')).Count } }
    $dv = Join-Path $S "delivery/$($T.Id).md"; $last = '(nenhuma entrega ainda)'; $stop = ''; $gaps = @()
    if (Test-Path -LiteralPath $dv) {
        $dt = Read-Text $dv; $secs = @([regex]::Matches($dt, '(?ms)^## .*?(?=^## |\z)'))
        if ($secs.Count) { $ls = $secs[$secs.Count - 1].Value; $last = ($ls -split "`r?`n")[0].Trim(); $sm = [regex]::Match($ls, '(?ms)^###\s+Parei no passo\s*\r?\n(.+?)(\r?\n\r?\n|\z)'); if ($sm.Success) { $stop = $sm.Groups[1].Value.Trim() } }
        $gaps = @([regex]::Matches($dt, '(?m)^.*🔺.*$') | ForEach-Object { $_.Value.Trim() } | Select-Object -Last 3)
    }
    $vr = Join-Path (Get-VerifyDir $Root $T.Id) 'result.json'; $vtxt = 'sem verify'
    if (Test-Path -LiteralPath $vr) { try { $v = (Read-Text $vr | ConvertFrom-Json).full; if ($v) { $bad = @($v.commands | Where-Object { [int]$_.exit -ne 0 }); $vtxt = "full em $($v.at): " + $(if ($bad.Count) { ($bad | ForEach-Object { "$($_.key) exit $($_.exit)" }) -join ', ' } else { 'verde' }) } } catch { } }
    $ar = Join-Path ((Get-VerifyDir $Root $T.Id) -replace '[\\/]verify[\\/]', '/accept/') 'result.json'; $atxt = 'sem accept'
    if (Test-Path -LiteralPath $ar) { try { $a = Read-Text $ar | ConvertFrom-Json; $atxt = if ($a.environment) { "falha de ambiente: $($a.environment)" } else { "$($a.passed) de $($a.total) em $($a.at)" } } catch { } }
    $md = @("# Cartão de passagem — $($T.Id) $($T.Title)", '', "**História:** $($T.Story) · **Marcador:** $($T.Mark) · **Depende de:** $(if ($T.Deps.Count) { $T.Deps -join ', ' } else { '—' })",
            "**Plano:** ``$planRel`` · $files arquivo(s)" + $(if ($blocks.Count) { " · " + ($blocks -join ' · ') } else { '' }),
            "**Cenários:** $(if ($T.Scenarios.Count) { $T.Scenarios -join ', ' } else { 'nenhum' }) — ``accept.ps1 -Task $($T.Id) -Only $($T.Scenarios -join ',')``",
            "**Última entrega:** $last" + $(if ($stop) { " · parou: $stop" } else { '' }),
            "**Verificação:** $vtxt · **Cenários no alvo:** $atxt",
            "**GAPs:** $(if ($gaps.Count) { $gaps -join ' · ' } else { 'nenhum' })", '',
            'Leia: este cartão, o cabeçalho e a §6 do plano e o seu bloco. O resto só se o passo pedir.')
    $path = Join-Path $dir "$($T.Id).md"; [System.IO.File]::WriteAllText($path, ($md -join "`n") + "`n", $utf8)
    return "sprints/$n/handoff/$($T.Id).md"
}

try {
    $tp = Join-Path $Root '.team-project'
    $readmePath = Join-Path $tp 'README.md'
    if (-not (Test-Path -LiteralPath $readmePath)) { [Console]::Error.WriteLine('run: .team-project/README.md não existe — rode na raiz do projeto ou passe -Root.'); exit 2 }
    $m = [regex]::Match((Read-Text $readmePath), $script:SprintLineRe)
    if (-not $m.Success) { [Console]::Error.WriteLine('run: .team-project/README.md §2 sem a linha "Sprint corrente" — esperado: ' + $script:SprintLineHelp); exit 2 }
    $n = $m.Groups[1].Value; $S = Join-Path $tp "sprints/$n"
    if (-not (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md'))) { [Console]::Error.WriteLine("run: sprints/$n/sprint-backlog.md não existe."); exit 2 }
    $tasks = @(Get-SprintTasks $S)
    $T = if ($Task) { $tasks | Where-Object { $_.Id -eq $Task } | Select-Object -First 1 } else { $null }
    if ($Task -and -not $T) { [Console]::Error.WriteLine("run: $Task não está no quadro do sprint $n."); exit 2 }

    if ($Action -eq 'handoff') { if (-not $T) { [Console]::Error.WriteLine('run handoff pede -Task.'); exit 2 }; Out "run: cartão $(Write-Handoff $T $S $n)"; exit 0 }

    if ($Action -eq 'start') {
        if (-not $T) { [Console]::Error.WriteLine('run start pede -Task.'); exit 2 }
        $pf = Get-PlanFull $T $S; if (-not $pf) { [Console]::Error.WriteLine("run: $($T.Id) sem plano — o preparo da construção vem antes (run.ps1 next)."); exit 2 }
        $planRel = ".team-project/sprints/$n/$($T.Plan)"
        $mark = if ($T.Mark -eq $E.Build) { '' } else { 'build' }
        $dr = Invoke-Child 'dispatch.ps1' @('-Role', 'developer', '-Id', $T.Id, '-Plan', $planRel, '-Mark', $mark, '-Root', $Root); $d = $dr.Out
        if ($dr.Code -ne 0) { [Console]::Error.WriteLine("run start: dispatch falhou — $($d.Trim())"); exit 2 }
        $card = Write-Handoff $T $S $n
        $acc = if ($T.Scenarios.Count -and (Get-TargetsConfig $Root)) { " e accept.ps1 -Task $($T.Id) -Only $($T.Scenarios -join ',') no alvo" } else { '' }
        $blk = if ($Block) { " Bloco $Block." } else { '' }
        Out ($d.Trim())
        Out "  cartão: $card"
        # v3.51.4: o formato que o close.ps1 lê (garden item 17), a retomada do verify parcial (exit 3, garden item 18) e o
        # alvo pelo target.ps1, sem adb nem espera à mão (note.md item 4).
        $tgt = if (Get-TargetsConfig $Root) { " Alvo: confira com target.ps1 -Target <alvo> (com -Repair ele reinicia e espera); não use adb nem Start-Sleep." } else { '' }
        Out "  prompt do dev: `"Construa a $($T.Id) — $($T.Title).$blk Leia o cartão .team-project/$card, o cabeçalho e a §6 do plano $planRel e o seu bloco — não o plano inteiro. Rode verify.ps1 -Mode focused durante, -Mode full no fim, -Mode mutation se o plano tem **Mutações:**$acc. Exit 3 = parcial (o tempo da chamada acabou): rode o MESMO comando de novo, ele continua de onde parou. Falhou, corrija você mesmo; exit 4 é ambiente: pare e diga.$tgt Dúvida de desenho: 🔺 GAP no relatório e pare. Grave a seção nova no fim de .team-project/sprints/$n/delivery/$($T.Id).md com a saída colada do verify e do accept — cada bloco de código começa com a linha do comando ('> verify.ps1 -Mode full …') e traz a saída embaixo — e ### Documentos vivos (R12) **Estado:** a consolidar. Volte em até 15 linhas (R28).`""
        Out "  ao voltar: run.ps1 done -Task $($T.Id) -Result ok|gap|env"
        exit 0
    }

    if ($Action -eq 'done') {
        if (-not $T -or -not $Result) { [Console]::Error.WriteLine('run done pede -Task e -Result ok|gap|env.'); exit 2 }
        if ($Result -eq 'gap') {
            # v3.51.4 (garden item 22): Task que a sessão já marcou 🟪 volta a 🟨 — ela segue na construção até o GAP se resolver.
            if ($T.Mark -eq $E.QA) { $mo = Set-Mark $T.Id 'build' 'sessão (run.ps1 done -Result gap)'; if ($mo) { Out "  $mo" } }
            $card = Write-Handoff $T $S $n
            Out "run: $($T.Id) com 🔺 GAP — Arquiteto em instância NOVA (o cache de 5 min do anterior já venceu; C1), modo /arc question:"
            Out "  $(Get-AgentLine 'architect')"
            Out "  prompt: `"Decida o 🔺 GAP da $($T.Id): cartão .team-project/$card, plano .team-project/sprints/$n/$($T.Plan), relatório .team-project/sprints/$n/delivery/$($T.Id).md. Registre a decisão no plano (R9); não escreva código nem rode build. Volte em até 15 linhas.`""
            Out "  depois: devolva a decisão ao MESMO dev por SendMessage (Haiku: retomar custa pouco) e rode run.ps1 done de novo"
            exit 0
        }
        if ($Result -eq 'env') {
            $tg = Get-TargetsConfig $Root; $names = @(if ($tg) { $tg.PSObject.Properties | ForEach-Object { $_.Name } })
            Out "run: $($T.Id) parou por FALHA DE AMBIENTE (D4) — não é defeito do código; nenhum papel caro é chamado."
            foreach ($nm in $names) { Out "  1. $plugin/target.ps1 -Target $nm -Repair" }
            Out "  2. pronto → retome o MESMO dev por SendMessage: `"o ambiente foi reparado; rode de novo o que falhou`""
            Out "  3. sem reparo → mark.ps1 -Task $($T.Id) -To blocked e linha em Bloqueios (ambiente, com a ação para o stakeholder); a fila segue"
            exit 0
        }
        # v3.51.4 (garden item 19): confere ANTES (close.ps1 sem -Apply); fechando, a Task passa por 🟪 (verificação) e só então
        # o -Apply grava o ✅ — antes o -Post reprovava o R24 ("Registro sem a linha → 🟪") com a Task já ✅ e a estimativa baixada.
        $pr = Invoke-Child 'close.ps1' @('-Task', $T.Id, '-Root', $Root); $pre = $pr.Out
        if ($pr.Code -ne 0) {
            $bad = @($pre -split "`r?`n" | Where-Object { $_ -match '\|\s*(R7[\w-]*|R12)\s*\|\s*falhou' } | ForEach-Object { ($_ -replace '\s+', ' ').Trim() })
            Out "run: $($T.Id) ainda não fecha — volte ao MESMO dev por SendMessage com o que falta (a Task segue em 🟨):"
            foreach ($b in $bad) { Out "  $b" }
            if (-not $bad.Count) { Out "  $(($pre -split "`r?`n" | Where-Object { $_.Trim() } | Select-Object -Last 2) -join ' ')" }
            exit 0
        }
        if ($T.Mark -ne $E.QA) { $mo = Set-Mark $T.Id 'qa' 'sessão (run.ps1 done)'; if ($mo) { Out "  $mo" } }
        $cr = Invoke-Child 'close.ps1' @('-Task', $T.Id, '-Apply', '-Root', $Root); $c = $cr.Out
        $code = $cr.Code
        if ($code -eq 0) { Out "run: $($T.Id) fechada pela evidência do dev (close.ps1 -Apply)."; Out (($c -split "`r?`n" | Where-Object { $_ -match '^\s*-\s|\*\*|Status' } | Select-Object -Last 6) -join "`n"); Out "  dispatch.ps1 -Clear; depois: run.ps1 next"; Out "  ponto seguro de pausa: entre uma Task fechada e o próximo start nada fica pela metade (sprint-run.md §Pausa segura)"; exit 0 }
        Out "run: $($T.Id) — o -Apply gravou o fechamento, mas o -Post não confirmou (R24); não feche de novo (baixaria a estimativa duas vezes):"
        Out "  $((($c -split "`r?`n") | Where-Object { $_ -match '\*\*-Apply:\*\*' } | Select-Object -First 1))"
        Out "  corrija o Registro/Série do kanban.md à mão (sprint-run.md §Marcador) e confira com close.ps1 -Task $($T.Id) -Post"
        exit 0
    }

    # ---------- next ----------
    # v3.51.4: o run parou por limite de uso da conta (.usage-limit, gravado pela G16 ou pelo Stop) — diz o motivo e segue.
    $lim = Join-Path $tp '.usage-limit'
    if (Test-Path -LiteralPath $lim) {
        try { $l = Read-Text $lim | ConvertFrom-Json; Out "RETOMADA: o run parou por LIMITE DE USO DA CONTA em $($l.desde)$(if ($l.reset) { " (reset: $($l.reset))" }) — $($l.quem)$(if ($l.item) { " em $($l.item)" }). Não é falha de processo: o que estava em voo se retoma pelo próprio agente (SendMessage) ou pelo result.json do verify (sprint-run.md §Retomada após limite de uso)." } catch { }
        Remove-Item -LiteralPath $lim -Force -ErrorAction SilentlyContinue
    }
    $null = Invoke-Child 'kanban.ps1' @('-Init', '-Root', $Root)   # consumption.md do sprint, se a Planning não o criou (garden item 1)
    $est = Get-RunEstimate
    if ($est) { Out $est }
    $defined = Get-Defined $Root
    $hasTargets = [bool](Get-TargetsConfig $Root)
    $open = @($tasks | Where-Object { $_.Mark -ne $E.Done -and $_.Mark -ne $redMk })
    # 1 · preparo da construção: por História, cenários executáveis (QA) e depois os planos (Arquiteto), antes de qualquer dev.
    # v3.51.4: sem alvo de execução (guards.json sem "targets") não há .scn a escrever — o accept não roda e os cenários
    # ficam rastreados nos planos e provados por teste (garden item 4). As Tasks da História entram em 🟦 no preparo (item 2).
    foreach ($h in @($open | Group-Object Story)) {
        $missScn = if ($hasTargets) { @($h.Group | ForEach-Object { $_.Scenarios } | Where-Object { $defined -notcontains $_ } | Select-Object -Unique) } else { @() }
        $noPlan = @($h.Group | Where-Object { -not (Get-PlanFull $_ $S) })
        if ($missScn.Count -or $noPlan.Count) {
            foreach ($t in @($h.Group | Where-Object { $_.Mark -eq $todoMk })) { $mo = Set-Mark $t.Id 'plan' 'Arquiteto · preparo (run.ps1 next)'; if ($mo) { Out "  $mo" } }
        }
        if ($missScn.Count) {
            Out "PRÓXIMA AÇÃO: preparo da construção — cenários executáveis da História $($h.Name) (QA)"
            Out "  $(Get-AgentLine 'quality-assurance')"
            Out "  prompt: `"Escreva os cenários executáveis $($missScn -join ', ') em .team-project/quality-assurance/scenarios/$($h.Name).scn, na linguagem do accept.ps1 (cabeçalho do script), a partir dos critérios de aceite da $($h.Name) e das fichas SC-nnn. Use só os identificadores de teste do contrato. Confira com accept.ps1 -ParseOnly; não rode o app. Volte em até 15 linhas.`""
            Out "  depois: run.ps1 next"
            exit 0
        }
        if ($noPlan.Count) {
            Out "PRÓXIMA AÇÃO: preparo da construção — planos da História $($h.Name) numa instância do Arquiteto (regra 25)"
            Out "  $(Get-AgentLine 'architect')"
            Out "  prompt: `"Escreva os Planos de Implementação de $(($noPlan | ForEach-Object { $_.Id }) -join ', ') (História $($h.Name)) em .team-project/sprints/$n/plan/<T-ID>-<slug>.md, no template enxuto (regras 22 a 25: ~12 KB, **Cenários:** com os da Task, **Risco:**, **Layout novo:**). Leia o SDD, os standards citados e o código uma vez para todas. Rode plan.ps1 em cada plano e corrija até passar; atualize a coluna Plano do quadro pela sessão. Volte em até 15 linhas.`""
            Out "  depois: para cada plano, plan.ps1 -Plan <caminho> (exit 1 volta à mesma instância se ela respondeu há menos de 5 min; senão instância nova) e run.ps1 next"
            exit 0
        }
    }
    # 2 · construção: Task em construção primeiro (retomada), depois a primeira elegível com as dependências fechadas.
    $done = @($tasks | Where-Object { $_.Mark -eq $E.Done } | ForEach-Object { $_.Id })
    $cur = @($open | Where-Object { $_.Mark -eq $E.Build -or $_.Mark -eq $E.QA }) | Select-Object -First 1
    $next = if ($cur) { $cur } else { @($open | Where-Object { @($_.Deps | Where-Object { $done -notcontains $_ }).Count -eq 0 }) | Select-Object -First 1 }
    if ($next) {
        $dv = Join-Path $S "delivery/$($next.Id).md"
        if ($cur -and (Test-Path -LiteralPath $dv)) { Out "PRÓXIMA AÇÃO: $($next.Id) está em construção com relatório — se o dev já voltou: run.ps1 done -Task $($next.Id) -Result ok|gap|env; se a sessão caiu no meio, retome o dev: run.ps1 start -Task $($next.Id)"; exit 0 }
        Out "PRÓXIMA AÇÃO: construir $($next.Id) — $($next.Title) (História $($next.Story))"
        Out "  run.ps1 start -Task $($next.Id)   (escopo, marcador, cartão e o prompt do dev)"
        exit 0
    }
    if ($open.Count) { Out "PRÓXIMA AÇÃO: nenhuma Task elegível — $(($open | ForEach-Object { "$($_.Id) espera $($_.Deps -join ',')" }) -join '; '). Bloqueio sobe pelo degrau 1 (R22)."; exit 3 }

    # 3 · validação do sprint: o operator mede (quality + todos os cenários), o QA julga.
    $sid = "S$n"
    $qr = Join-Path ((Get-VerifyDir $Root $sid) -replace '[\\/]verify[\\/]', '/quality/') 'result.json'
    $ar = Join-Path ((Get-VerifyDir $Root $sid) -replace '[\\/]verify[\\/]', '/accept/') 'result.json'
    $tree = Get-WorkTree $Root
    $fresh = { param($p) if (-not (Test-Path -LiteralPath $p)) { return $false }; try { $j = Read-Text $p | ConvertFrom-Json; return (-not $tree -or -not $j.tree -or [string]$j.tree -eq $tree) } catch { return $false } }
    $val = Join-Path $S 'validation.md'; $vv = Get-VerdictOf $val
    if ($vv -ne $E.Done) {
        if (-not (& $fresh $qr) -or ((Get-TargetsConfig $Root) -and -not (& $fresh $ar))) {
            Out "PRÓXIMA AÇÃO: validação do sprint $n — medir (operator, comandos longos fora das instâncias caras; C3)"
            Out "  $(Get-AgentLine 'operator')"
            Out "  prompt: `"Rode na raiz: $plugin/quality.ps1 -Id $sid" + $(if (Get-TargetsConfig $Root) { " e $plugin/accept.ps1 -Task $sid (todos os cenários)" } else { '' }) + ". Exit 4 = ambiente: rode target.ps1 -Repair uma vez e repita. Devolva os caminhos dos result.md e as linhas de resumo.`""
            Out "  depois: run.ps1 next"
            exit 0
        }
        if ($null -eq $vv -or $vv -eq '') {
            Out "PRÓXIMA AÇÃO: validação do sprint $n — julgar (QA, uma passada só; portão da Review)"
            Out "  $(Get-AgentLine 'quality-assurance')"
            Out "  prompt: `"/qa sprint $n — leia .team-project/quality/$n/$sid/result.md" + $(if (Get-TargetsConfig $Root) { " e .team-project/accept/$n/$sid/result.md (com as capturas)" } else { '' }) + ", os planos e o diff do sprint. Julgue SOLID, clean code, aderência à arquitetura e aos planos, padrões e segurança, citando standards/ (Q<n>). Escreva .team-project/sprints/$n/validation.md (template sprint-validation) com o veredito e os achados (Volta para: dev | Arquiteto). Não rode build nem o app. Volte em até 15 linhas.`""
            exit 0
        }
        Out "PRÓXIMA AÇÃO: corrigir os achados do portão (validation.md: veredito $vv)"
        Out "  1. um dev por grupo de achados com 'Volta para: dev' — $(Get-AgentLine 'developer') · prompt: `"Corrija os achados <n> de .team-project/sprints/$n/validation.md; rode verify e os cenários afetados; acrescente a seção no fim do delivery da Task. Dúvida: 🔺 GAP. Volte em até 15 linhas.`""
        Out "  2. achado com 'Volta para: Arquiteto' → instância nova do Arquiteto (/arc question) com o caminho do validation.md"
        Out "  3. depois: operator mede de novo (quality + cenários afetados) e o QA, em instância nova, revisa o veredito no mesmo validation.md"
        exit 0
    }
    # 5 · consolidação dos documentos vivos (A5) e 6 · Review.
    $cons = Join-Path $S 'docs-consolidation.md'
    if (-not (Test-Path -LiteralPath $cons) -or (Read-Text $cons) -notmatch '(?m)^\*\*Estado:\*\*\s*feita') {
        Out "PRÓXIMA AÇÃO: consolidação dos documentos vivos (R12) — Arquiteto, uma vez no sprint (A5)"
        Out "  $(Get-AgentLine 'architect')"
        Out "  prompt: `"Consolide os documentos vivos do sprint ${n}: leia as seções 'Documentos vivos (R12)' de .team-project/sprints/$n/delivery/*.md, atualize o SDD técnico e os ADRs que são seus e peça ao dono o que não é seu. Registre em .team-project/sprints/$n/docs-consolidation.md, com **Estado:** feita na primeira linha e a lista (documento, o que mudou, dono). Volte em até 15 linhas.`""
        exit 0
    }
    Out "PRÓXIMA AÇÃO: fim da fila — formulário de autorização da Review (sprint-run.md §Ao fim da fila), no formato do H1: o problema simples, um exemplo, as opções e 'Pedir mais contexto' por último."
    exit 0
} catch {
    [Console]::Error.WriteLine("run: erro — $($_.Exception.Message)")
    exit 2
}
