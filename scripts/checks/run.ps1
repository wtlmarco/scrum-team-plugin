# Orquestração do sprint run guiada por script (v3.51, B1 · B2 · C2). A sessão principal não decide o próximo passo
# relendo o roteiro: pergunta a este script, que lê o quadro e o disco e devolve a PRÓXIMA AÇÃO pronta — o papel, o modelo,
# o prompt curto com os caminhos e o comando de volta. No piloto, a sessão principal foi 35 % do custo, a 274 mil tokens
# de contexto por chamada; no protótipo do benchmark com a orquestração em script, o coordenador custou 6 %.
# Uso (raiz do projeto): powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/run.ps1" <next|start|done|handoff|allow> [-Task T-041] [-Result ok|gap|env|teto] [-Block k] [-Commands "a;b"] [-Deny "c"] [-By quem]
#   next      a próxima ação do sprint corrente (preparo → construção → validação → consolidação → Review)
#   start     dispara a construção da Task: escopo e marcador (dispatch.ps1), cartão de passagem e o prompt do dev
#   done      o dev voltou: ok → close.ps1 -Apply (fecha pela evidência do dev) · gap → rota ao Arquiteto · env → reparo
#             · teto → a G23 parou o dev no teto de contexto: instância nova pelo ponto de retomada (v3.53.1)
#   handoff   (re)gera o cartão de passagem da Task: sprints/<n>/handoff/<T-ID>.md, até ~2 KB (C2)
#   allow     (v3.55.0, F2) grava a decisão do formulário único dos comandos dos planos: -Commands = prefixos liberados (vão para guards.json →
#             runCommands, resto do arquivo intacto), -Deny = negados (a Task volta ao Arquiteto), -By = quem autorizou (run-log.md). O next/start
#             param uma vez com os comandos de '### Comandos da Task' que a G14 ainda não libera, de todos os planos da História.
# Ordem do sprint (sprint-run.md): 1 preparo da construção por História (QA escreve os .scn; o Arquiteto planeja as Tasks
# da História numa instância; v3.53.3: uma História por vez, a próxima a construir) · 2 construção, Task a Task (o dev constrói, verifica, roda os cenários e corrige; o close
# fecha pela evidência) · 3 validação do sprint (o operator mede: quality + todos os cenários; o QA julga e escreve
# validation.md) · 4 achados voltam ao dev (dúvida → Arquiteto) · 5 consolidação dos documentos vivos (Arquiteto, uma vez)
# · 6 formulário de autorização da Review. Exit 0 · 2 = erro de uso · 3 = nada a fazer (fila vazia ou bloqueada).
# v3.52.2: a construção de cada Task é do executor de Task (team:task-runner) — o next o dispara; start e done são dele.
# O next também lê .interrupted (retomada após queda), mede a sessão (SESSÃO:) e abre a correção do portão como Q-S<n>.
# v3.53: Task com ficha no architect/breakdown/S<n>.md é planejada por um Arquiteto só dela, a partir do recorte da ficha
# (sprints/<n>/handoff/<T-ID>-ficha.md); sem ficha, a História segue numa instância.
# v3.53.4: com guards.json → "run": { "planner": "external", "tasks": [] }, o plano da Task com ficha sai do Claude — o
# next monta o pacote da História em sprints/<n>/pack/out/, o stakeholder o leva a um assistente de fora e devolve os
# planos em pack/in/; o next seguinte confere cada um (plan.ps1) antes de aceitar. O 🔺 GAP de plano dela também vai
# num pacote (done -Result gap). Funções em external-plan.ps1.

param(
    [Parameter(Position = 0, Mandatory = $true)][ValidateSet('next', 'start', 'done', 'handoff', 'allow')][string]$Action,
    [string]$Task = '',
    [ValidateSet('', 'ok', 'gap', 'env', 'teto')][string]$Result = '',
    [string]$Block = '',
    [string]$Commands = '',   # v3.55.0 (F2) · allow: prefixos liberados, separados por ;
    [string]$Deny = '',       # v3.55.0 (F2) · allow: prefixos negados (a Task volta ao Arquiteto)
    [string]$By = 'stakeholder',
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
. (Join-Path $PSScriptRoot '..\..\hooks\common.ps1')
. (Join-Path $PSScriptRoot 'external-plan.ps1')
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
# v3.56.0 (H2): os argumentos do accept da Task — os .scn que definem os cenários dela (-Scenarios) e a lista (-Only), que é a
# do plano quando ele existe (Get-SprintTasks). Antes ia a máscara de todos os .scn: um cenário inválido de outra História
# reprovava a Task.
function Get-AcceptArgs($T) {
    $fs = @(Get-ScenarioFiles $Root @($T.Scenarios))
    return "$(if ($fs.Count) { " -Scenarios $($fs -join ',')" }) -Only $(@($T.Scenarios) -join ',')"
}
# v3.56.0 (H2): divergência entre a coluna Cenários do backlog e a linha **Cenários:** do plano — uma linha no run-log.md, uma
# vez por Task e por lista, sem formulário. O plano manda.
function Write-ScenarioDivergence($T, [string]$S, [string]$n) {
    if (-not $T.ScenariosDiverge) { return }
    $now = @(@($T.Scenarios) + @($T.TestScenarios | ForEach-Object { "$_ (teste)" }))
    $nowTxt = if ($now.Count) { $now -join ', ' } else { 'nenhum' }
    $rl = Join-Path $S 'run-log.md'
    $mark = "cenários: o plano manda ($nowTxt)"
    if ((Test-Path -LiteralPath $rl) -and (Read-Text $rl).Contains("| $($T.Id) | $mark")) { return }
    Add-RunLog $S $n $T.Id $mark "backlog: $(if (@($T.BacklogScenarios).Count) { @($T.BacklogScenarios) -join ', ' } else { 'nenhum' }) · o cartão, o start e o accept seguem a linha **Cenários:** do plano" "sprints/$n/$($T.Plan)"
}
function Get-AgentLine([string]$Role) {
    $mc = Get-ModelsConfig $Root
    $dm = Get-AgentDefaultModel $Role; if (-not $dm) { $dm = "agents/$Role.md" }
    $model = if ($mc.State -eq 'ok' -and $mc.Models.ContainsKey($Role)) { "model `"$($mc.Models[$Role])`" (models.json)" } else { "model do agente ($dm)" }
    # v3.52.2 (note.md item 2, C1): o Agent não tem mais run_in_background — toda chamada volta "lançado" e o resultado
    # chega por aviso. Quem dispara encerra o turno e é acordado pelo aviso; ninguém espera com Start-Sleep nem sonda o disco.
    return "Agent: subagent_type `"team:$Role`" · $model — dispare e encerre o turno; o aviso traz a volta"
}
# Contador de instâncias do dev por Task e bloco (v3.52.2, note.md item 14): sprints/<n>/handoff/<ID>.json. "fail" conta só
# a instância encerrada por falha de papel (GAP, evidência reprovada no done); "env" (done -Result env) é queda de ambiente
# e NÃO conta para o escalonamento — 2 quedas de rede subiam o dev para sonnet no piloto.
function Get-DevCounter($T, [string]$S) {
    $p = Join-Path $S "handoff/$($T.Id).json"; $all = @{}
    if (Test-Path -LiteralPath $p) { try { $j = Read-Text $p | ConvertFrom-Json; foreach ($b in $j.blocks.PSObject.Properties) { $all[$b.Name] = @{ starts = [int]$b.Value.starts; fail = [int]$b.Value.fail; env = [int]$b.Value.env } } } catch { } }
    return $all
}
function Update-DevCounter($T, [string]$S, [string]$Field) {
    $all = Get-DevCounter $T $S; $k = if ($Block) { $Block } else { '-' }
    if (-not $all.ContainsKey($k)) { $all[$k] = @{ starts = 0; fail = 0; env = 0 } }
    $all[$k][$Field]++
    $dir = Join-Path $S 'handoff'; New-Item -ItemType Directory -Force $dir | Out-Null
    $o = [ordered]@{ task = $T.Id; blocks = [ordered]@{} }; foreach ($b in ($all.Keys | Sort-Object)) { $o.blocks[$b] = [ordered]@{ starts = $all[$b].starts; fail = $all[$b].fail; env = $all[$b].env } }
    [System.IO.File]::WriteAllText((Join-Path $dir "$($T.Id).json"), ($o | ConvertTo-Json -Depth 4 -Compress), $utf8)
    return $all[$k]
}
# "Parei no passo" da seção mais recente do delivery/<T-ID>.md; '' se não houver.
function Get-StopStep([string]$S, [string]$Id) {
    $dv = Join-Path $S "delivery/$Id.md"; if (-not (Test-Path -LiteralPath $dv)) { return '' }
    $secs = @([regex]::Matches((Read-Text $dv), '(?ms)^## .*?(?=^## |\z)')); if (-not $secs.Count) { return '' }
    $sm = [regex]::Match($secs[$secs.Count - 1].Value, '(?ms)^###\s+Parei no passo\s*\r?\n(.+?)(\r?\n\r?\n|\z)')
    if ($sm.Success) { return (($sm.Groups[1].Value.Trim() -split "`r?`n")[0]).Trim() } else { return '' }
}
# Outro script de conferência num processo filho (v3.51.4): os scripts escrevem com [Console]::Out, que no mesmo processo
# passa por fora do pipeline — o "| Out-String" voltava vazio e a saída do close/dispatch saía solta, sem ser lida.
function Invoke-Child([string]$Script, [string[]]$ArgList) {
    $ErrorActionPreference = 'Continue'
    $o = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot $Script) @ArgList 2>&1 | Out-String
    return @{ Code = $LASTEXITCODE; Out = $o }
}
# v3.52 (note.md item 9): o código da Task fechada vai a um commit próprio (`T-<nnn>: <título>`), sem .team-project/ (R31);
# projeto sem git: o checkpoint é por cópia (sprint-run.md, fechamento da Task). Devolve a linha para a saída.
# v3.52.2 (note.md item 10): a mensagem vai num arquivo (git commit -F) — aspas no título quebravam o -m no 5.1 — e o
# assunto longo é cortado no espaço, com o título inteiro no corpo; o stage é só o escopo do plano (Arquivos tocados e os
# testes das mutações): alteração pendente de outro dono fica fora do commit e é citada na saída. Nunca .team-project/.
# Devolve @{ Line; Sha }.
function Save-TaskCommit($T, [string]$S) {
    $ErrorActionPreference = 'Continue'
    $null = & git -C $Root rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0) { return @{ Line = "  commit: projeto sem git — checkpoint por cópia dos arquivos da $($T.Id) (sprint-run.md, fechamento da Task)"; Sha = '' } }
    $pf = Get-PlanFull $T $S; $scope = @()
    if ($pf) { $pt = Read-Text $pf; $scope = @(Get-PlanScope $pt) + @(Get-Mutations $pt | ForEach-Object { ($_.Test -replace '\\', '/') -replace '^\./', '' }) }
    # v3.54.1: os testes da margem stub (fora da lista, conferidos pelo close R7-margem) entram no commit da Task.
    $dvp = Join-Path $S "delivery/$($T.Id).md"
    if ($scope.Count -and (Test-Path -LiteralPath $dvp)) { $scope += @(Get-MarginAdjustments (Read-Text $dvp) | Where-Object { $_.Kind -eq 'stub' } | ForEach-Object { $_.File }) }
    $scope = @($scope | Where-Object { $_ -and $_ -notmatch '^\.team-project(/|$)' -and $_ -notmatch '[<>*?]' } | Select-Object -Unique)
    if (-not $scope.Count) { return @{ Line = "  commit: o plano da $($T.Id) sem **Arquivos tocados:** — nada versionado; o código segue no disco (commit à mão, só os arquivos da Task)"; Sha = '' } }
    foreach ($f in $scope) { $null = & git -C $Root add -A -- ":(literal)$f" 2>$null }
    $staged = @(& git -C $Root diff --cached --name-only -- @($scope | ForEach-Object { ":(literal)$_" }) 2>$null | Where-Object { $_ })
    $inScope = @{}; foreach ($f in $scope) { $inScope[$f.ToLowerInvariant()] = $true }
    $pending = @(& git -C $Root status --porcelain -uall 2>$null | ForEach-Object { ($_.Substring([Math]::Min(3, $_.Length)) -split ' -> ')[-1].Trim('"') } | Where-Object { $_ -and $_ -notmatch '^\.team-project/' -and -not $inScope.ContainsKey($_.ToLowerInvariant()) })
    $outTxt = if ($pending.Count) { " · fora do escopo, ficou fora do commit: $(($pending | Select-Object -First 5) -join ', ')$(if ($pending.Count -gt 5) { " e mais $($pending.Count - 5)" })" } else { '' }
    if (-not $staged.Count) { return @{ Line = "  commit: nada a versionar para a $($T.Id) no escopo do plano$outTxt"; Sha = '' } }
    $subj = "$($T.Id): $($T.Title)"; $body = ''
    if ($subj.Length -gt 72) { $cut = $subj.LastIndexOf(' ', 70); if ($cut -lt 20) { $cut = 70 }; $body = $subj; $subj = $subj.Substring(0, $cut).TrimEnd(' ', ',', ';', ':', '-', '—') + '…' }
    $mf = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($mf, $subj + $(if ($body) { "`n`n$body" } else { '' }) + "`n", $utf8)
        $o = & git -C $Root commit -q -F $mf -- @($staged | ForEach-Object { ":(literal)$_" }) 2>&1 | Out-String
        $code = $LASTEXITCODE
    } finally { Remove-Item -LiteralPath $mf -Force -ErrorAction SilentlyContinue }
    if ($code -ne 0) { return @{ Line = "  commit: falhou ($(($o -replace '\s+', ' ').Trim())) — o código da $($T.Id) segue no disco; reporte na Review$outTxt"; Sha = '' } }
    $sha = ([string](& git -C $Root rev-parse --short HEAD 2>$null)).Trim()
    return @{ Line = "  commit: $sha $subj ($($staged.Count) arquivo(s) do plano)$outTxt"; Sha = $sha }
}
# v3.52 (R29, parada (f)): Task fechada = ponto seguro. O marcador libera o fim de turno na G20; o próximo start o apaga.
function Set-SafePoint($T, [string]$n) {
    $o = [ordered]@{ task = $T.Id; sprint = $n; desde = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') }
    [System.IO.File]::WriteAllText((Join-Path $tp '.safe-point'), ($o | ConvertTo-Json -Compress), $utf8)
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
# v3.52.2 (note.md item 11, C6): "**Veredito (rodada 2):**" também vale, e vale a ÚLTIMA ocorrência do arquivo — o next
# só lia "**Veredito:**" exato e voltava a pedir "julgar (QA)" em laço.
function Get-VerdictOf([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    $ms = @([regex]::Matches((Read-Text $Path), '(?m)^\*\*Veredito[^*\r\n]*:\*\*(.*)$')); if (-not $ms.Count) { return '' }
    $mk = Get-VerdictMark $ms[$ms.Count - 1].Groups[1].Value; if ($mk) { return $mk } else { return '' }
}
# Aceite com dívida (C6): "**Decisão do PO:** aceito com dívida — <motivo e onde a dívida está>", escrita pela sessão.
function Test-PoDebt([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    return ((Read-Text $Path) -match '(?m)^\*\*Decis[ãa]o do PO:\*\*\s*aceit[oa] com d[íi]vida\s*[—–-]\s*\S')
}

# v3.52.3 (note.md item 10): a rota do 🔺 GAP e a queda de ambiente vão ao run-log.md pelo próprio done — no sprint 4 do
# garden o executor não escreveu nenhuma, e o registro do sprint ficou com uma linha só. Modelo: templates/run-log.md.
function Add-RunLog([string]$S, [string]$n, [string]$Item, [string]$Decision, [string]$Why, [string]$Evidence) {
    $p = Join-Path $S 'run-log.md'
    if (-not (Test-Path -LiteralPath $p)) {
        [System.IO.File]::WriteAllText($p, "# Registro de decisões do run — S$n`n> DOCUMENTO VIVO até o fechamento do sprint/bloco · Dono: SM · Escritores: a sessão que orquestra e o executor de Task (só as linhas da Task dele)`n`n| Quando | Item | Decisão | Porquê | Evidência |`n|---|---|---|---|---|`n", $utf8)
    }
    $cell = { param($x) $t = (([string]$x -replace '\|', '/') -replace '\s+', ' ').Trim(); if ($t.Length -gt 160) { $t.Substring(0, 160) + '…' } else { $t } }
    [System.IO.File]::AppendAllText($p, "| $(Get-Date -Format 'yyyy-MM-dd HH:mm') | $Item | $(& $cell $Decision) | $(& $cell $Why) | $(& $cell $Evidence) |`n", $utf8)
}

# Agente que parou sem SubagentStop (v3.52.3, note.md item 9): a G16 roda por ele, a partir do transcript. stdin em UTF-8 (o
# pipe do 5.1 manda ASCII e o acento do caminho do perfil virava "?"). A G16 grava só o que ainda não mediu (calls_total).
function Measure-CutAgent($Rc) {
    $hook = Join-Path $PSScriptRoot '..\..\hooks\subagent-stop.ps1'
    $hin = [ordered]@{ hook_event_name = 'SubagentStop'; agent_id = [string]$Rc.agent_id; agent_type = [string]$Rc.type; agent_transcript_path = [string]$Rc.transcript; transcript_path = [string]$Rc.session_transcript; cwd = $Root } | ConvertTo-Json -Compress
    try {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = 'powershell'; $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$hook`""
        $psi.UseShellExecute = $false; $psi.RedirectStandardInput = $true; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true
        $psi.EnvironmentVariables['CLAUDE_PROJECT_DIR'] = $Root
        $hp = [System.Diagnostics.Process]::Start($psi)
        $hb = $utf8.GetBytes($hin); $hp.StandardInput.BaseStream.Write($hb, 0, $hb.Length); $hp.StandardInput.Close()
        $null = $hp.StandardOutput.ReadToEnd(); $null = $hp.StandardError.ReadToEnd(); $hp.WaitForExit(60000) | Out-Null
    } catch { }
    Out "  consumo: $(([string]$Rc.type) -replace '^.*:', '') $(if ($Rc.work) { [string]$Rc.work }) medido pelo transcript (parou sem SubagentStop)"
}

# v3.53.6 (sprint 5 do garden, item 1): plano da Task acima do teto (plan.ps1 regra 22 reprova) — o do quadro, o que o
# Arquiteto deixou em plan/<ID>-*.md sem a sessão gravar a coluna Plano, ou o do plano externo devolvido (pack/review/). O
# tamanho é o estado: sem marcador novo. @{ Path; Rel; Kb } ou $null.
function Get-OversizedPlan($T) {
    $c = @(); $pf = Get-PlanFull $T $S; if ($pf) { $c += $pf }
    $c += @(Get-ChildItem -LiteralPath (Join-Path $S 'plan') -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -match ('^' + [regex]::Escape($T.Id) + '-.*\.md$') } | ForEach-Object { $_.FullName })
    $c += (Join-Path $S "pack/review/$($T.Id)-plan.md")
    foreach ($f in @($c | Select-Object -Unique)) {
        if (-not (Test-Path -LiteralPath $f -PathType Leaf)) { continue }
        $kb = Get-PlanKb (Read-Text $f)
        if ($kb -gt $script:PlanMaxKb) { $fn = $f -replace '\\', '/'; $ix = $fn.LastIndexOf('/.team-project/'); return @{ Path = $f; Rel = $(if ($ix -ge 0) { $fn.Substring($ix + 1) } else { $fn }); Kb = $kb } }
    }
    return $null
}
# Divisão da Task por uma instância curta do Arquiteto (v3.53.2: ficha com Arquivos previstos acima do teto; v3.53.6, item 1:
# plano acima de 30 KB — os blocos do plano grande são a base da divisão, para o trabalho não se perder). $F = ficha ou $null.
function Write-SplitAction($t, [string]$Story, $F, $Big) {
    $bdRel = ".team-project/architect/breakdown/S$n.md"
    # IDs novos: sufixo de uma letra (TaskIdRe), livres no quadro; a Task dividida não empresta o seu.
    $base = $t.Id -replace '[a-z]$', ''; $taken = @($tasks | ForEach-Object { $_.Id }) + $t.Id
    $newIds = @([char[]]'abcdefghijklmnopqrstuvwxyz' | ForEach-Object { "$base$_" } | Where-Object { $taken -notcontains $_ } | Select-Object -First 2)
    $mx = $script:FichaMaxFiles
    if (-not $Big) {
        Out "PRÓXIMA AÇÃO: dividir a $($t.Id) antes do plano — a ficha prevê $($F.Planned) arquivos (máximo $mx) (Arquiteto, instância curta)"
        Out "  $(Get-AgentLine 'architect')"
        Out "  prompt: `"A ficha da $($t.Id) em $bdRel prevê $($F.Planned) arquivos; o máximo por Task é $mx. Divida-a em $($newIds -join ', ') (e a letra seguinte, se precisar de mais) no próprio $bdRel, dentro da História ${Story}: uma linha da tabela e uma ficha por Task nova, cada ficha com **Arquivos previstos:** até $mx, a dependência entre elas na coluna Depende de, e retire a ficha da $($t.Id). O escopo da História não muda (R2). Não escreva plano. Volte em até 8 linhas: as Tasks novas, o título, a estimativa de cada uma (somando a da $($t.Id)) e a dependência.`""
        Out "  depois: a sessão troca a linha da $($t.Id) no Sprint Backlog pelas Tasks novas, transcritas do breakdown (mesma História), e roda run.ps1 next"
        return
    }
    $where = if ($F) { "No próprio ${bdRel}, dentro da História ${Story}: uma linha da tabela e uma ficha por Task nova, cada ficha com **Arquivos previstos:** até $mx e a linha **Base:** ``$($Big.Rel)`` — <os blocos ou passos que ela herda>, a dependência entre elas na coluna Depende de; retire a ficha da $($t.Id)." } else { "A $($t.Id) não tem ficha no breakdown: volte com, por Task nova, o título, a estimativa (somando a da $($t.Id)), a dependência e os blocos ou passos do plano que ela herda." }
    $plx = Get-RunPlanner $Root
    Out "PRÓXIMA AÇÃO: dividir a $($t.Id) — o plano dela tem $($Big.Kb) KB (teto $($script:PlanMaxKb) KB, regra 22): Task grande; os blocos do plano são a base da divisão (Arquiteto, instância curta)"
    Out "  $(Get-AgentLine 'architect')"
    Out "  prompt: `"O plano da $($t.Id) (``$($Big.Rel)``, $($Big.Kb) KB) passou do teto de $($script:PlanMaxKb) KB e reprovou no plan.ps1 (regra 22): a Task é grande demais para uma construção. Divida-a em $($newIds -join ', ') (e a letra seguinte, se precisar de mais) usando os blocos — ou grupos de passos — desse plano como base: cada Task nova herda blocos inteiros, com os arquivos e os testes deles, e o que já está decidido no plano não se decide de novo. Do plano, leia o cabeçalho e os títulos dos blocos e passos (Grep '^#{2,4} '); não o reescreva nem o corte. $where O escopo da História não muda (R2). Não escreva plano: cada Task nova ganha o seu no run.ps1 next. Volte em até 8 linhas: as Tasks novas, o título, a estimativa de cada uma e a dependência.`""
    Out "  depois: a sessão troca a linha da $($t.Id) no Sprint Backlog pelas Tasks novas$(if ($F) { ', transcritas do breakdown' }) (mesma História, coluna Plano sem link) e roda run.ps1 next; o plano grande fica no disco como base (não o apague)$(if ($plx -and @($plx.Tasks).Count -and (Test-ExternalTask $plx $t.Id)) { " · plano externo com a lista do piloto: as Tasks novas entram em guards.json → run.tasks (stakeholder)" })"
}

# v3.53.6 (sprint 5 do garden, item 2): os passos do plano que faltam, do ponto de retomada ("Parei no passo <n>") em diante —
# até o fim do bloco do passo (o bloco seguinte é de outra instância) ou da §4. Com -Block (ou "bloco <k>" no ponto), procura
# o passo dentro do bloco. Até $MaxBytes; acima, corta numa linha e aponta o resto no plano. @{ Num; Text; Cut } ou $null.
function Get-RemainingSteps([string]$PlanText, [string]$Stop, [string]$Blk, [int]$MaxBytes = 8192) {
    $sm = [regex]::Match($Stop, '(?i)\bpasso\s+(\d+(?:\.\d+)*)'); if (-not $sm.Success) { $sm = [regex]::Match($Stop, '^\s*(\d+(?:\.\d+)*)\b') }
    if (-not $sm.Success) { return $null }
    $num = $sm.Groups[1].Value
    # "4 de 4 — repositório compila, todos os testes passam": entrega terminada, nada a retomar.
    $dm = [regex]::Match($Stop, '(?i)\b(\d+)\s+de\s+(\d+)\b')
    if ($dm.Success -and $dm.Groups[1].Value -eq $dm.Groups[2].Value -and $Stop -notmatch '(?i)\bfalt|pendente|n[ãa]o (rodou|passou|terminei)') { return $null }
    $s4 = [regex]::Match($PlanText, '(?ms)^##\s+4\b[^\r\n]*\r?\n(.*?)(?=^##\s|\z)')
    $scope = if ($s4.Success) { $s4.Groups[1].Value } else { $PlanText }
    $bm = [regex]::Match($Stop, '(?i)\bbloco\s+(\d+)'); $bk = if ($Blk) { $Blk } elseif ($bm.Success) { $bm.Groups[1].Value } else { '' }
    if ($bk) { $b = [regex]::Match($scope, '(?ms)^###\s+Bloco\s+' + [regex]::Escape($bk) + '\b.*?(?=^###\s+Bloco\s|\z)'); if ($b.Success) { $scope = $b.Value } }
    $h = [regex]::Match($scope, '(?m)^#{3,4}\s+Passo\s+' + [regex]::Escape($num) + '(?![\w.])[^\r\n]*')
    if (-not $h.Success) { return $null }
    $rest = $scope.Substring($h.Index)
    $nb = [regex]::Match($rest, '(?m)^###\s+Bloco\s'); if ($nb.Success -and $nb.Index -gt 0) { $rest = $rest.Substring(0, $nb.Index) }
    $rest = $rest.TrimEnd(); $cut = ''
    if ($utf8.GetByteCount($rest) -gt $MaxBytes) {
        $keep = New-Object System.Collections.ArrayList; $size = 0; $lines = @($rest -split "`r?`n"); $i = 0
        for (; $i -lt $lines.Count; $i++) { $sz = $utf8.GetByteCount($lines[$i]) + 1; if ($size + $sz -gt $MaxBytes) { break }; [void]$keep.Add($lines[$i]); $size += $sz }
        $nx = @($lines | Select-Object -Skip $i | Where-Object { $_ -match '^#{3,4}\s+Passo\s' } | Select-Object -First 1)
        $cut = if ($nx.Count) { "a partir de '$($nx[0].Trim('#', ' '))'" } else { 'do meio do último passo citado' }
        $rest = ($keep -join "`n").TrimEnd()
    }
    return @{ Num = $num; Text = $rest; Cut = $cut; Block = $bk }
}

# Cartão de passagem (C2): o estado da Task em ~2 KB, para a instância nova não reler o plano inteiro nem o histórico.
# v3.53.6 (item 2): com ponto de retomada, o cartão leva os passos que faltam e o que já está provado (até ~10 KB).
function Write-Handoff($T, [string]$S, [string]$n) {
    $dir = Join-Path $S 'handoff'; New-Item -ItemType Directory -Force $dir | Out-Null
    $pf = Get-PlanFull $T $S; $planRel = if ($pf) { "sprints/$n/$($T.Plan)" } else { '(sem plano)' }
    $blocks = @(); $files = 0
    if ($pf) { $pt = Read-Text $pf; $blocks = @([regex]::Matches($pt, '(?m)^###\s+(Bloco\s+\d+.*)$') | ForEach-Object { $_.Groups[1].Value.Trim() }); $fm = [regex]::Match($pt, '(?s)\*\*Arquivos tocados:\*\*(.*?)(?:\r?\n[ \t]*\r?\n|\z)'); if ($fm.Success) { $files = @([regex]::Matches($fm.Groups[1].Value, '`[^`]+`')).Count } }
    $dv = Join-Path $S "delivery/$($T.Id).md"; $last = '(nenhuma entrega ainda)'; $stop = ''; $stopSec = ''; $gaps = @()
    if (Test-Path -LiteralPath $dv) {
        $dt = Read-Text $dv; $secs = @([regex]::Matches($dt, '(?ms)^## .*?(?=^## |\z)'))
        if ($secs.Count) {
            $ls = $secs[$secs.Count - 1].Value; $last = ($ls -split "`r?`n")[0].Trim(); $sm = [regex]::Match($ls, '(?ms)^###\s+Parei no passo\s*\r?\n(.+?)(\r?\n\r?\n|\z)'); if ($sm.Success) { $stop = $sm.Groups[1].Value.Trim() }
            # v3.53.6 (item 2): a subseção inteira — o que já está provado, com a saída, o que falta, os comandos e o alvo (G23).
            $ss = [regex]::Match($ls, '(?ms)^###\s+Parei no passo\s*\r?\n(.*?)(?=^#{2,3}\s|\z)'); if ($ss.Success) { $stopSec = $ss.Groups[1].Value.Trim() }
        }
        $gaps = @([regex]::Matches($dt, '(?m)^.*🔺.*$') | ForEach-Object { $_.Value.Trim() } | Select-Object -Last 3)
    }
    $vr = Join-Path (Get-VerifyDir $Root $T.Id) 'result.json'; $vtxt = 'sem verify'
    if (Test-Path -LiteralPath $vr) { try { $v = (Read-Text $vr | ConvertFrom-Json).full; if ($v) { $bad = @($v.commands | Where-Object { [int]$_.exit -ne 0 }); $vtxt = "full em $($v.at): " + $(if ($bad.Count) { ($bad | ForEach-Object { "$($_.key) exit $($_.exit)" }) -join ', ' } else { 'verde' }) } } catch { } }
    $dgRel = "operator/$n/$($T.Id)-alvo/diagnostico.md"; $dg = Join-Path $Root ".team-project/$dgRel"
    $ar = Join-Path ((Get-VerifyDir $Root $T.Id) -replace '[\\/]verify[\\/]', '/accept/') 'result.json'; $atxt = 'sem accept'
    if (Test-Path -LiteralPath $ar) { try { $a = Read-Text $ar | ConvertFrom-Json; $atxt = if ($a.environment) { "falha de ambiente: $($a.environment)" } else { "$($a.passed) de $($a.total) em $($a.at)" } } catch { } }
    $rem = if ($pf -and $stop) { Get-RemainingSteps $pt $stop $Block } else { $null }
    # v3.53.7: as decisões do sprint que valem para a Task (todas, as que a citam e as que o plano cita), uma linha cada.
    $dl = @(Get-TaskDecisionLines $Root $n $T.Id $(if ($pf) { $pt } else { '' }))
    # v3.56.0 (B, C): o conhecimento do projeto e as armadilhas da stack que casam com os arquivos da Task (glob), o T-ID ou o
    # plano — uma linha cada; ninguém abre o knowledge.md nem o pitfalls.md inteiros.
    $kl = @(Get-TaskKnowledgeLines $Root $n $T.Id $(if ($pf) { $pt } else { '' }))
    $sl = @(Get-StackPitfallLines $Root $n $T.Id $(if ($pf) { $pt } else { '' }))
    $md = @("# Cartão de passagem — $($T.Id) $($T.Title)", '', "**História:** $($T.Story) · **Marcador:** $($T.Mark) · **Depende de:** $(if ($T.Deps.Count) { $T.Deps -join ', ' } else { '—' })",
            ("**Plano:** ``$planRel`` · $files arquivo(s)" + $(if ($blocks.Count) { " · " + ($blocks -join ' · ') } else { '' })),
            # v3.52.3 (note.md item 1): o aceite só com alvo — sem guards.json → targets, o cartão mandava rodar o accept.ps1 e
            # 4 de 5 Tasks do sprint 4 do garden pararam no mesmo 🔺 GAP "accept sem .scn".
            # v3.56.0 (H2): a lista é a do plano quando ele existe (o backlog só antes dele) e o -Scenarios aponta o .scn da História.
            ("**Cenários$(if ($T.ScenariosFrom -eq 'plano') { ' (do plano)' }):** " + $(if (-not $T.Scenarios.Count) { 'nenhum no alvo' } elseif (Get-TargetsConfig $Root) { "$($T.Scenarios -join ', ') — ``accept.ps1 -Task $($T.Id)$(Get-AcceptArgs $T)``" } else { "$($T.Scenarios -join ', ') — sem alvo de execução: o accept não roda; os cenários se provam pelos testes do plano" }) + $(if ($T.TestScenarios.Count) { " · por teste do plano, sem accept: $($T.TestScenarios -join ', ')" } else { '' })),
            ("**Última entrega:** $last" + $(if ($stop) { " · parou: $((($stop -split "`r?`n")[0]).Trim())" } else { '' })),
            "**Verificação:** $vtxt · **Cenários no alvo:** $atxt",
            "**GAPs:** $(if ($gaps.Count) { $gaps -join ' · ' } else { 'nenhum' })",
            $(if ($dl.Count) { "**Decisões do sprint** (``architect/decisions/S$n.md`` — valem como o plano; não abra o arquivo):`n" + ($dl -join "`n") } else { $null }),
            $(if ($kl.Count) { "**Conhecimento do projeto** (``architect/knowledge.md`` — o que sprints anteriores ensinaram sobre os arquivos desta Task; vale como o plano; não abra o arquivo):`n" + ($kl -join "`n") } else { $null }),
            $(if ($sl.Count) { "**Armadilhas da stack** (``standards/stacks/<stack>/pitfalls.md`` do plugin e do projeto — comportamento do framework que pega quem não sabe; não abra o arquivo):`n" + ($sl -join "`n") } else { $null }),
            # v3.53.3: o diagnóstico do operator sobre a falha da prova no alvo (run.ps1 done -Result gap).
            $(if (Test-Path -LiteralPath $dg) { "**Diagnóstico do alvo (operator):** ``$dgRel`` · $((@((Read-Text $dg) -split "`r?`n" | Where-Object { $_.Trim() }) | Select-Object -First 1))" } else { $null }), '',
            $(if ($rem) { "Retomada do passo $($rem.Num): os passos que faltam estão abaixo, copiados do plano, e o que já está provado também. Siga por este cartão — não reabra o plano inteiro; abra só o trecho de que um passo precise e que não esteja aqui (Read com offset e limit; a §6 com os testes e as **Mutações:**, se o passo as pedir)." } else { 'Leia: este cartão, o cabeçalho e a §6 do plano e o seu bloco. O resto só se o passo pedir.' }))
    # v3.53.6 (sprint 5 do garden, item 2): a instância nova da G23 relia o cabeçalho, a §6 e o bloco inteiro para achar o
    # ponto. Com "Parei no passo", o cartão traz o que já está provado (a subseção do delivery, até ~2 KB) e os passos do
    # ponto em diante (até 8 KB; acima, o ponteiro para o resto no plano).
    if ($rem) {
        $proved = if ($stopSec.Length -gt 2000) { $stopSec.Substring(0, 2000).TrimEnd() + "`n… (o resto em sprints/$n/delivery/$($T.Id).md, ### Parei no passo)" } else { $stopSec }
        $md += @('', '## Já provado — ponto de retomada (delivery)', '', $proved, '', "## Passos que faltam — do plano, passo $($rem.Num) em diante$(if ($rem.Block) { " (Bloco $($rem.Block))" })", '', $rem.Text)
        if ($rem.Cut) { $md += @('', "… (cortado em 8 KB: o resto em ``$planRel`` §4$(if ($rem.Block) { ", Bloco $($rem.Block)" }), $($rem.Cut))") }
    }
    $script:CardResume = if ($rem) { $rem.Num } else { '' }
    $path = Join-Path $dir "$($T.Id).md"; [System.IO.File]::WriteAllText($path, (@($md | Where-Object { $null -ne $_ }) -join "`n") + "`n", $utf8)
    return "sprints/$n/handoff/$($T.Id).md"
}

# ---------- v3.55.0 (F2) · os comandos da Task, uma parada antes da construção ----------
# O plano declara os comandos ("### Comandos da Task", regra 32). O que a G14 ainda não libera (lista base + runCommands + reparo)
# o run.ps1 junta de TODOS os planos da História, e a sessão pergunta UMA vez ao stakeholder (AskUserQuestion, R22). O liberado
# é gravado em guards.json → runCommands por este script (run.ps1 allow), nunca à mão, com quem autorizou e quando no run-log.md.
# O que já foi perguntado fica em sprints/<n>/commands-asked.json: não pergunta de novo para o mesmo comando em Task seguinte.
function Get-AskedCommands([string]$S) {
    $r = @{ allowed = @(); denied = @() }
    $p = Join-Path $S 'commands-asked.json'
    if (Test-Path -LiteralPath $p) { try { $j = Read-Text $p | ConvertFrom-Json; $r.allowed = @($j.allowed | Where-Object { $_ }); $r.denied = @($j.denied | Where-Object { $_ }) } catch { } }
    return $r
}
# @{ Pending = prefixo → [Task-IDs] ainda não perguntados (planos da História da Task); DeniedForT = negados que a Task usa }
function Get-CommandStop($T, $Tasks, [string]$S) {
    $asked = Get-AskedCommands $S
    $pending = [ordered]@{}; $denied = @()
    $batch = @($Tasks | Where-Object { $_.Story -eq $T.Story -and $_.Mark -ne $E.Done -and (Get-PlanFull $_ $S) })
    foreach ($t in $batch) {
        $g = Get-PlanCommandGaps $Root (Read-Text (Get-PlanFull $t $S))
        foreach ($m in @($g.Missing)) {
            if (@($asked.denied) -contains $m) { if ($t.Id -eq $T.Id -and $denied -notcontains $m) { $denied += $m }; continue }
            if (@($asked.allowed) -contains $m) { continue }
            if (-not $pending.Contains($m)) { $pending[$m] = @() }
            $pending[$m] += $t.Id
        }
    }
    return [pscustomobject]@{ Pending = $pending; DeniedForT = $denied }
}
function Format-CommandStop($Cs, $T) {
    $l = @("PARADA ÚNICA — comandos que os planos de $($T.Story) declaram e a G14 ainda não libera (guards.json → runCommands):")
    foreach ($k in $Cs.Pending.Keys) { $l += "  - $k   ($((@($Cs.Pending[$k]) | Select-Object -Unique) -join ', '))" }
    $all = ($Cs.Pending.Keys -join ';')
    $l += "  A sessão abre UM formulário (AskUserQuestion, R22, `"pedir mais contexto`" por último): liberar todos · liberar alguns · negar e voltar ao Arquiteto · pedir mais contexto."
    $l += "  liberar todos:   run.ps1 allow -Commands `"$all`" -By <quem autorizou>"
    $l += "  liberar alguns:  run.ps1 allow -Commands `"<os liberados>`" -Deny `"<os negados>`" -By <quem autorizou>"
    $l += "  negar:           run.ps1 allow -Deny `"$all`" — o Arquiteto troca o comando no plano de cada Task citada (/arc question) e o plan.ps1 reconfere"
    $l += "  O script grava em runCommands (nunca à mão) e registra no run-log.md quem autorizou e quando; o mesmo comando não é perguntado de novo. Instalação, rede, push e destrutivo não passam por aqui."
    return ($l -join "`n")
}
# Acrescenta prefixos a guards.json → runCommands editando só o trecho da lista (o resto do arquivo fica byte a byte). Devolve os
# que entraram (os já cobertos por uma entrada existente ficam de fora).
function Add-RunCommands([string]$Root, [string[]]$Cmds) {
    $gp = Join-Path $Root '.team-project/guards.json'
    if (-not (Test-Path -LiteralPath $gp)) { throw 'sem .team-project/guards.json' }
    $bom = [System.IO.File]::ReadAllBytes($gp)[0] -eq 0xEF
    $t = Read-Text $gp; $j = $t | ConvertFrom-Json
    $have = @(); if ($j.PSObject.Properties['runCommands'] -and $j.runCommands) { $have = @($j.runCommands | ForEach-Object { [string]$_ }) }
    $new = @($Cmds | Where-Object { $c = $_.ToLowerInvariant(); -not @($have | Where-Object { Test-CommandPrefix $c $c $_ }).Count } | Select-Object -Unique)
    if (-not $new.Count) { return @() }
    $items = @($have + $new | ForEach-Object { '"' + (($_ -replace '\\', '\\') -replace '"', '\"') + '"' })
    $arr = '[' + ($items -join ', ') + ']'
    $rx = [regex]'"runCommands"\s*:\s*\[[^\]]*\]'
    $t2 = if ($rx.IsMatch($t)) { $rx.Replace($t, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) '"runCommands": ' + $arr }, 1) }
          else { ([regex]'^\s*\{').Replace($t, "{`n  `"runCommands`": $arr,", 1) }
    $chk = $t2 | ConvertFrom-Json   # o JSON tem de continuar válido e com exatamente a lista esperada
    if ((@($chk.runCommands | ForEach-Object { [string]$_ }) -join "`n") -ne (@($have + $new) -join "`n")) { throw 'guards.json: a lista runCommands não ficou como esperado — nada foi gravado' }
    [System.IO.File]::WriteAllText($gp, $t2, (New-Object System.Text.UTF8Encoding($bom)))
    return $new
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

    # v3.55.0 (F2): grava a decisão do formulário único — liberados em guards.json → runCommands, negados no registro.
    if ($Action -eq 'allow') {
        $al = @($Commands -split ';' | ForEach-Object { ($_.Trim() -replace '\s+', ' ') } | Where-Object { $_ })
        $dn = @($Deny -split ';' | ForEach-Object { ($_.Trim() -replace '\s+', ' ') } | Where-Object { $_ })
        if (-not $al.Count -and -not $dn.Count) { [Console]::Error.WriteLine('run allow pede -Commands "<prefixo>;<prefixo>" (liberar) e/ou -Deny "<prefixo>" (negar) — a decisão do formulário único.'); exit 2 }
        $bad = @($al | Where-Object { Get-ForbiddenCommandReason $_ })
        if ($bad.Count) { [Console]::Error.WriteLine("run allow: instalação, rede, push e destrutivo não entram no run (G14) — $($bad -join '; ') não vai a runCommands; a Task vai a bloqueio (degrau 1)."); exit 2 }
        $added = @(Add-RunCommands $Root $al)
        $asked = Get-AskedCommands $S
        $ap = Join-Path $S 'commands-asked.json'
        $doc = [ordered]@{ allowed = @(@($asked.allowed) + $al | Select-Object -Unique); denied = @(@($asked.denied) + $dn | Select-Object -Unique) }
        [System.IO.File]::WriteAllText($ap, ($doc | ConvertTo-Json -Compress), $utf8)
        if ($al.Count) { Add-RunLog $S $n 'comandos do run' "liberou: $($al -join '; ')" "autorizado por $By no formulário único antes da construção (F2); gravado pelo run.ps1 allow em runCommands — o script grava em nome da autorização do stakeholder, dono do guards.json" "guards.json → runCommands$(if ($added.Count) { ' (+' + $added.Count + ')' })" }
        if ($dn.Count) { Add-RunLog $S $n 'comandos do run' "negou: $($dn -join '; ')" "decisão de $By no formulário único (F2); a Task volta ao Arquiteto para trocar o comando no plano" 'commands-asked.json' }
        Out "run allow: $($al.Count) liberado(s)$(if ($al.Count) { ' (' + ($al -join '; ') + ')' }) → guards.json runCommands$(if ($added.Count -ne $al.Count) { " (já cobertos: $($al.Count - $added.Count))" }); $($dn.Count) negado(s)$(if ($dn.Count) { ' (' + ($dn -join '; ') + ') — Arquiteto troca o comando no plano de cada Task que o cita (/arc question) e plan.ps1 reconfere' }). Registrado em sprints/$n/run-log.md."
        exit 0
    }

    if ($Action -eq 'start') {
        if (-not $T) { [Console]::Error.WriteLine('run start pede -Task.'); exit 2 }
        $pf = Get-PlanFull $T $S; if (-not $pf) { [Console]::Error.WriteLine("run: $($T.Id) sem plano — o preparo da construção vem antes (run.ps1 next)."); exit 2 }
        # v3.54.1 (carta do sprint 5 do garden, item 2): plano acima do teto não vai ao dev. Na T-063 a decisão do 🔺 GAP levou o
        # plano a 30,1 KB e o dev seguiu com o plan.ps1 reprovado — a divisão (regra 22) só olhava Task antes da construção.
        # Com construção começada (relatório em delivery/), a Task não se divide: o código dela está no meio; o Arquiteto troca
        # o trecho que a decisão derrubou. Antes da construção, a divisão do run.ps1 next.
        $bigS = Get-OversizedPlan $T
        if ($bigS) {
            if (Test-Path -LiteralPath (Join-Path $S "delivery/$($T.Id).md")) {
                [Console]::Error.WriteLine("run start: o plano da $($T.Id) tem $($bigS.Kb) KB (teto $($script:PlanMaxKb) KB, regra 22) — o dev não começa com o plano reprovado. A construção já começou, então a Task não se divide: Arquiteto em instância curta (/arc question) com o prompt `"O plano $($bigS.Rel) passou do teto com a decisão do 🔺 GAP. Substitua no plano o texto que a decisão derrubou (passo, premissa, teste ou arquivo superado) pela decisão — não a acrescente ao lado e não corte o que segue valendo. Rode plan.ps1 -Plan <plano> até tamanho ok. Volte em até 5 linhas.`"; depois run.ps1 start -Task $($T.Id) de novo.")
            } else {
                [Console]::Error.WriteLine("run start: o plano da $($T.Id) tem $($bigS.Kb) KB (teto $($script:PlanMaxKb) KB, regra 22): Task grande — vai à divisão antes do dev. Rode run.ps1 next (ele dá o prompt do Arquiteto).")
            }
            exit 2
        }
        # v3.53.1 (plugin-report do sprint 4 do garden, item 3): dev desta Task ainda vivo (processo hospedeiro vivo e sinal de
        # vida há menos de 20 min) — outra instância poria dois devs no mesmo alvo físico.
        # v3.55.0 (F2): comando do plano que a G14 não libera → a parada única (formulário) vem antes do primeiro dev; negado
        # volta ao Arquiteto. O executor de Task não abre formulário: devolve a linha à sessão.
        if (-not $Block) {
            $csS = Get-CommandStop $T $tasks $S
            if ($csS.DeniedForT.Count) {
                [Console]::Error.WriteLine("run start: o plano da $($T.Id) declara comando que o stakeholder negou ($($csS.DeniedForT -join '; ')) — o dev não começa com ele. Arquiteto em instância curta (/arc question): trocar o comando no plano (### Comandos da Task) e rodar plan.ps1; depois run.ps1 start de novo.")
                exit 2
            }
            if ($csS.Pending.Count) {
                [Console]::Error.WriteLine("run start: comandos dos planos de $($T.Story) que a G14 ainda não libera — nenhum dev começa antes da decisão do stakeholder. Executor: não dispare o dev; devolva à sessão a linha `"$($T.Id) 🔺 comandos → formulário`".`n" + (Format-CommandStop $csS $T))
                exit 2
            }
        }
        $liveDev = @(Get-LiveAgents $Root $T.Id | Where-Object { ([string]$_.type -replace '^.*:', '') -eq 'developer' })
        if ($liveDev.Count) {
            $a = $liveDev[0]; $idle = [int]((Get-AgentIdleHours $a) * 60)
            [Console]::Error.WriteLine("run start: a $($T.Id) já tem um dev vivo ($(if ($a.agent_id) { "agent_id $($a.agent_id), " })última ação $(if ($a.last) { $a.last } else { 'disparado' }) há $idle min$(if ($a.host_pid) { ", processo $($a.host_pid)" })) — não dispare outro: seriam duas instâncias no mesmo alvo. Encerre o turno e espere a volta dele; se a sessão dele foi fechada, o registro deixa de valer depois de 20 min sem sinal de vida.")
            exit 2
        }
        # v3.53.3: o dev encerrou o turno esperando um comando em segundo plano — ele volta sozinho; outro seria o segundo.
        $busy = Get-TaskBusy $Root $T.Id
        if ($busy) {
            [Console]::Error.WriteLine("run start: a $($T.Id) ainda tem $busy rodando — o dev que o rodou encerrou o turno para esperar por ele e volta sozinho com o resultado. Não dispare outro dev (seriam dois na mesma Task e no mesmo alvo): encerre o turno; na volta dele, run.ps1 done.")
            exit 2
        }
        $planRel = ".team-project/sprints/$n/$($T.Plan)"
        # v3.52.2 (note.md item 9): sem "-Mark ''" — o 5.1 descarta argumento vazio em -File e o dispatch.ps1 caía com a Task
        # já em 🟨 (retomada depois de GAP).
        $dargs = @('-Role', 'developer', '-Id', $T.Id, '-Plan', $planRel, '-Root', $Root)
        if ($T.Mark -ne $E.Build) { $dargs += @('-Mark', 'build') }
        # v3.52.2 (note.md item 14): o start decide o modelo da linha — duas instâncias encerradas por falha de papel neste
        # bloco → a terceira com sonnet; quedas de ambiente (done -Result env) não contam. Chave do models.json vence.
        $cnt = Update-DevCounter $T $S 'starts'
        $mcs = Get-ModelsConfig $Root
        if ($cnt.fail -ge 2 -and -not ($mcs.State -eq 'ok' -and ($mcs.Models.ContainsKey('developer') -or $mcs.Executor))) {
            $dargs += @('-Model', 'sonnet', '-ModelWhy', "escalonamento: $($cnt.fail) instância(s) encerrada(s) por falha de papel$(if ($cnt.env) { "; $($cnt.env) queda(s) de ambiente não contam" })")
        }
        $dr = Invoke-Child 'dispatch.ps1' $dargs; $d = $dr.Out
        if ($dr.Code -ne 0) { [Console]::Error.WriteLine("run start: dispatch falhou — $($d.Trim())"); exit 2 }
        Remove-Item -LiteralPath (Join-Path $tp '.safe-point') -Force -ErrorAction SilentlyContinue   # v3.52: Task em voo não é ponto seguro
        $card = Write-Handoff $T $S $n
        Write-ScenarioDivergence $T $S $n
        $acc = if ($T.Scenarios.Count -and (Get-TargetsConfig $Root)) { " e accept.ps1 -Task $($T.Id)$(Get-AcceptArgs $T) no alvo" } else { '' }
        # v3.56.0 (H2): o plano manda nos cenários; a ordem do cartão que o contradiga é GAP de processo, não do plano.
        $acc += ". Cenários: o plano manda — ordem do cartão que contradiga o plano é 🔺 GAP de processo (diga 'processo' no GAP), não do plano"
        $blk = if ($Block) { " Bloco $Block." } else { '' }
        Out ($d.Trim())
        Out "  cartão: $card"
        # v3.51.4: o formato que o close.ps1 lê (garden item 17), a retomada do verify parcial (exit 3, garden item 18) e o
        # alvo pelo target.ps1, sem adb nem espera à mão (note.md item 4).
        $tgt = if (Get-TargetsConfig $Root) { " Alvo: confira com target.ps1 -Target <alvo> (com -Repair ele reinicia e espera); não use adb nem Start-Sleep." } else { '' }
        # v3.53.6 (item 2): com ponto de retomada, o cartão traz os passos que faltam — o plano não se reabre.
        $readTxt = if ($script:CardResume) { "Retome do passo $($script:CardResume): o cartão .team-project/$card traz os passos que faltam e o que já está provado — siga por ele e não reabra o plano $planRel, salvo o trecho de que um passo precise e que o cartão não traga (offset e limit)." } else { "Leia o cartão .team-project/$card, o cabeçalho e a §6 do plano $planRel e o seu bloco — não o plano inteiro." }
        Out "  prompt do dev: `"Construa a $($T.Id) — $($T.Title).$blk $readTxt Rode verify.ps1 -Mode focused durante, -Mode full no fim, -Mode mutation se o plano tem **Mutações:**$acc. Exit 3 = parcial (o tempo da chamada acabou): rode o MESMO comando de novo, ele continua de onde parou. Comando que a ferramenta moveu para segundo plano ('moved to the background'): encerre o turno com a primeira linha ESPERANDO <comando> — o aviso de conclusão traz o resultado e você segue; não sonde o log nem dispare outro verify (exit 5 = outra rodada ainda roda). Falhou, corrija você mesmo; exit 4 é ambiente: pare e diga.$tgt Dúvida de desenho: 🔺 GAP no relatório e pare. Grave a seção nova no fim de .team-project/sprints/$n/delivery/$($T.Id).md com a saída colada do verify e do accept — cada bloco de código começa com a linha do comando ('> verify.ps1 -Mode full …') e traz a saída embaixo — e ### Documentos vivos (R12) **Estado:** a consolidar. Volte em até 15 linhas (R28).`""
        Out "  ao voltar: run.ps1 done -Task $($T.Id) -Result ok|gap|env|teto (teto = o dev voltou com TETO: a G23 o parou no teto de contexto)"
        exit 0
    }

    if ($Action -eq 'done') {
        if (-not $T -or -not $Result) { [Console]::Error.WriteLine('run done pede -Task e -Result ok|gap|env|teto.'); exit 2 }
        # v3.53.3 (sprint 5 do garden): o dev "voltou" só porque encerrou o turno esperando um comando em segundo plano — a
        # entrega ainda não está no relatório. Fechar, reparar ou redisparar aqui punha um segundo dev ao lado do primeiro.
        $busy = Get-TaskBusy $Root $T.Id
        if ($busy) {
            Set-NextVerdict $Root 'esperar' $T.Id "comando: $busy"
            Out "run: ESPERANDO — a $($T.Id) ainda tem $busy rodando. O dev encerrou o turno para esperar esse comando (foi para segundo plano) e volta sozinho com o resultado. Não rode start, reparo nem Arquiteto: encerre o turno; o aviso da volta dele te acorda e aí rode run.ps1 done de novo."
            exit 3
        }
        # v3.53.3 (sprint 5 do garden): GAP da prova no alvo vai primeiro ao operator (haiku), que olha as capturas da falha.
        # Os 3 GAPs de alvo da T-041 foram ao Arquiteto (Opus, US$ 2,26) e o diagnóstico saiu errado ("APK sem os ids"): a
        # captura mostrava a tela inicial do Android. O done lê o veredito do operator: AMBIENTE → reparo · APP → dev · PLANO → Arquiteto.
        $diagRel = ".team-project/operator/$n/$($T.Id)-alvo/diagnostico.md"; $diagP = Join-Path $Root $diagRel; $diagV = ''
        if ($Result -eq 'gap') {
            $tgc = Get-TargetsConfig $Root; $dv0 = Join-Path $S "delivery/$($T.Id).md"
            $g0 = @(if (Test-Path -LiteralPath $dv0) { [regex]::Matches((Read-Text $dv0), '(?m)^.*🔺.*$') | ForEach-Object { $_.Value.Trim() } | Select-Object -Last 1 })
            $isTgt = [bool]($tgc -and $g0.Count -and $g0[0] -match '(?i)alvo|aceite|accept|emulador|tag n[ãa]o encontrada|tag ausente')
            if ($isTgt) {
                $fresh = (Test-Path -LiteralPath $diagP) -and (Test-Path -LiteralPath $dv0) -and (Get-Item -LiteralPath $diagP).LastWriteTime -ge (Get-Item -LiteralPath $dv0).LastWriteTime
                if ($fresh) { $vm = [regex]::Match((Read-Text $diagP), '(?im)^\W*Veredito\W*\s*(AMBIENTE|APP|PLANO)'); if ($vm.Success) { $diagV = $vm.Groups[1].Value.ToUpperInvariant() } }
                if (-not $fresh) {
                    $tn = @($tgc.PSObject.Properties | ForEach-Object { $_.Name })[0]
                    $accRel = (((Get-VerifyDir $Root $T.Id) -replace '[\\/]verify[\\/]', '/accept/').Substring($Root.Length + 1) -replace '\\', '/')
                    Add-RunLog $S $n $T.Id '🔺 GAP da prova no alvo → operator diagnostica pelas capturas antes do Arquiteto' ($g0[0] -replace '^[#>*\-\s]+', '') $diagRel
                    Out "run: $($T.Id) com 🔺 GAP na prova no alvo — antes do Arquiteto, o operator olha as capturas da falha (centavos; o Opus só entra se for plano):"
                    Out "  $(Get-AgentLine 'operator')"
                    Out "  prompt: `"Diagnostique a falha da prova no alvo da $($T.Id). Leia $accRel/result.md e abra com Read as capturas *-falha.png que ele cita; rode $plugin/target.ps1 -Target $tn (só a conferência, sem -Repair). Grave $diagRel com a primeira linha 'Veredito: AMBIENTE', 'Veredito: APP' ou 'Veredito: PLANO' e até 5 linhas do que viu nas capturas e no detalhe [tela · ids · textos] da falha. AMBIENTE = o app não estava aberto ou estava noutra tela (tela inicial do Android, página deixada por outro cenário), diálogo do sistema, alvo travado ou ocupado. APP = a tela certa estava aberta e o elemento, o texto ou o valor do cenário não estava lá. PLANO = o cenário ou o contrato de ids pede o que nenhuma Task cria, ou o cenário não prova o critério; não deu para ver, PLANO dizendo o que faltou. Não altere código, cenário nem plano; não rode accept nem verify. Volte com a linha do veredito.`""
                    Out "  depois: run.ps1 done -Task $($T.Id) -Result gap de novo — o done lê o veredito: AMBIENTE → reparo e dev novo · APP → dev novo com o diagnóstico · PLANO → Arquiteto"
                    exit 0
                }
                if ($diagV -eq 'AMBIENTE') { $Result = 'env'; Out "run: o operator diagnosticou AMBIENTE na prova da $($T.Id) ($diagRel) — rota de queda de ambiente:" }
                elseif ($diagV -eq 'APP') {
                    $null = Update-DevCounter $T $S 'fail'
                    $card = Write-Handoff $T $S $n
                    Add-RunLog $S $n $T.Id 'operator: APP (a tela certa estava aberta e o elemento faltou) → dev em instância nova com o diagnóstico' 'veredito do operator pelas capturas da falha' $diagRel
                    Out "run: o operator diagnosticou APP na prova da $($T.Id) — defeito do código, não do alvo nem do plano. Dev em instância NOVA: run.ps1 start -Task $($T.Id) (o cartão .team-project/$card aponta o diagnóstico $diagRel) e rode run.ps1 done de novo"
                    exit 0
                }
            }
        }
        if ($Result -eq 'gap') {
            # v3.51.4 (garden item 22): Task que a sessão já marcou 🟪 volta a 🟨 — ela segue na construção até o GAP se resolver.
            if ($T.Mark -eq $E.QA) { $mo = Set-Mark $T.Id 'build' 'sessão (run.ps1 done -Result gap)'; if ($mo) { Out "  $mo" } }
            $null = Update-DevCounter $T $S 'fail'   # v3.52.2 (item 14): GAP encerra a instância por falha de papel
            $card = Write-Handoff $T $S $n
            $dvp = Join-Path $S "delivery/$($T.Id).md"
            $gl = @(if (Test-Path -LiteralPath $dvp) { [regex]::Matches((Read-Text $dvp), '(?m)^.*🔺.*$') | ForEach-Object { $_.Value.Trim() } | Select-Object -Last 1 })
            # v3.53.4: Task do plano externo — a decisão do GAP vai num pacote, não ao Arquiteto Opus; a Task espera o retorno.
            $plx = Get-RunPlanner $Root
            if ($plx -and (Test-ExternalTask $plx $T.Id) -and (Get-Ficha $Root $n $T.Id)) {
                $gline = if ($gl.Count) { $gl[0] -replace '^[#>*\-\s]+', '' } else { '' }
                $gp = Start-GapPack $T $gline
                Add-RunLog $S $n $T.Id "🔺 GAP → external plan: pacote $($gp.Name) com o stakeholder; a Task espera a decisão" $(if ($gline) { $gline } else { 'GAP no relatório do dev' }) "sprints/$n/pack/out/$($gp.Name).zip"
                Out "run: $($T.Id) com 🔺 GAP — a decisão vai ao plano externo (guards.json → run.planner external), não ao Arquiteto Opus: pacote .team-project/sprints/$n/pack/out/$($gp.Name).zip (a pasta ao lado, para o app do Codex)$(if ($diagV) { " com o diagnóstico do operator (veredito $diagV)" })."
                Out "  executor: não dispare Arquiteto nem start. Devolva à sessão a linha `"$($T.Id) 🔺 GAP → external plan $($gp.Name)`" — o run.ps1 next mostra o pacote ao stakeholder e só reconstrói a Task quando a decisão voltar (plan.ps1 ok)."
                exit 0
            }
            Add-RunLog $S $n $T.Id '🔺 GAP → Arquiteto em instância nova (/arc question); a decisão fica no plano (R9)' $(if ($gl.Count) { $gl[0] -replace '^[#>*\-\s]+', '' } else { 'GAP no relatório do dev' }) "sprints/$n/delivery/$($T.Id).md"
            Out "run: $($T.Id) com 🔺 GAP — Arquiteto em instância NOVA (o cache de 5 min do anterior já venceu; C1), modo /arc question (rota gravada no run-log.md):"
            Out "  $(Get-AgentLine 'architect')"
            Out "  prompt: `"Decida o 🔺 GAP da $($T.Id): cartão .team-project/$card, plano .team-project/sprints/$n/$($T.Plan), relatório .team-project/sprints/$n/delivery/$($T.Id).md$(if ($diagV) { ", diagnóstico do operator $diagRel (veredito $diagV)" }). Registre a decisão no plano (R9) no lugar do texto que ela derruba (passo, premissa, teste ou arquivo superado) — não ao lado: o plano tem teto de $($script:PlanMaxKb) KB e o run.ps1 start recusa o plano acima dele. Toda decisão declara duas linhas (v3.56.0, regra 29): **Origem:** previsão | conhecimento | requisito | ambiente | processo (confirme a sugestão do dev) e **Lição:** projeto (fato deste sistema que vai se repetir → K no knowledge.md no fechamento) | stack:<nome> (comportamento do framework, vale para qualquer projeto com a mesma stack → armadilha da camada local) | plugin (defeito ou regra do plugin → ocorrência de plugin, sem contexto do projeto) | nenhuma (previsão única). No plano: **Decisão do GAP $($T.Id) (<data>):** <a decisão>, com as duas linhas embaixo. Grave-a UMA vez como D-<k> em .team-project/architect/decisions/S$n.md (## D-<k> — <título>, **Vale para:** todas | T-… | <glob>, as duas linhas, a regra em até 5 linhas) quando ela vale para mais de uma Task do sprint (alvo, APK, teste instável, regra de processo) OU a Lição é projeto ou stack — e no plano só a referência em **Decisões:** D-<k> — não copie o texto em plano nenhum: o cartão de cada Task a traz. Decisão ou K que já está lá: só a referência. Rode plan.ps1 -Plan .team-project/sprints/$n/$($T.Plan) antes de voltar. Não escreva código nem rode build. Volte em até 15 linhas.`""
            Out "  depois: dev em instância NOVA com a decisão — run.ps1 start -Task $($T.Id) (o cartão regerado aponta o plano com a decisão) e rode run.ps1 done de novo"
            exit 0
        }
        if ($Result -eq 'env') {
            $tg = Get-TargetsConfig $Root; $names = @(if ($tg) { $tg.PSObject.Properties | ForEach-Object { $_.Name } })
            $ec = Update-DevCounter $T $S 'env'   # v3.52.2 (item 14): queda de ambiente não conta para o escalonamento do dev
            # v3.54.2 (carta do sprint 5 do garden, item 3): o accept parou no ESTADO DE PARTIDA (os 2 primeiros cenários na
            # mesma tela, nenhum passou — startState no result.json). O reparo do emulador não muda a tela de partida e a
            # reabertura automática repetiria o accept que não passa (T-063: 🔴 → 🟪 → 🔴 → 🟪 → 🔴, um operator em cada).
            # Bloqueio sem a etiqueta da prova pendente; a decisão é do stakeholder.
            $arjS = Join-Path ((Get-VerifyDir $Root $T.Id) -replace '[\\/]verify[\\/]', '/accept/') 'result.json'
            $ass = $null; if (Test-Path -LiteralPath $arjS) { try { $ass = Read-Text $arjS | ConvertFrom-Json } catch { } }
            if ($ass -and $ass.PSObject.Properties['startState'] -and $ass.startState) {
                $stS = (([string]$ass.startState -replace '["|]', "'") -replace '\s+', ' ').Trim(); if ($stS.Length -gt 90) { $stS = $stS.Substring(0, 90) + '…' }
                $shS = @($ass.results | Where-Object { $_.shot } | ForEach-Object { [string]$_.shot }) | Select-Object -Last 1
                Add-RunLog $S $n $T.Id "accept parado no estado de partida ($stS) → 🔴 sem reabertura automática; decisão do stakeholder" 'startState no result.json do accept (2 primeiros cenários na mesma tela, nenhum passou)' "accept/$n/$($T.Id)/result.md"
                Out "run: $($T.Id) — o accept parou no ESTADO DE PARTIDA: $stS. Não é defeito do código nem queda do alvo: o reparo do emulador não muda a tela de partida e o dev não depura. Nenhum papel caro é chamado."
                Out "  1. $plugin/mark.ps1 -Task $($T.Id) -To blocked -Reason `"estado de partida — $stS`" (sem a etiqueta da prova pendente: o run.ps1 next não a reabre sozinho)"
                Out "  2. devolva `"$($T.Id) 🔴 bloqueada: estado de partida · a fila segue`". A sessão leva ao stakeholder num formulário (R22), com a captura $(if ($shS) { $shS } else { "de accept/$n/$($T.Id)/shots/" }): declarar o estado de partida (guards.json → targets.android.baseline = o nome de uma massa de targets.android.seeds) ou o QA ajustar o cenário; depois mark.ps1 -Task $($T.Id) -To qa e o accept pelo operator."
                exit 0
            }
            Add-RunLog $S $n $T.Id "queda de ambiente ($($ec.env) neste bloco) → reparo do alvo e dev em instância nova" 'o dev parou por ambiente (exit 4 do verify/accept, rede, energia); não conta para o escalonamento (R27)' "sprints/$n/delivery/$($T.Id).md"
            Out "run: $($T.Id) parou por FALHA DE AMBIENTE (D4) — não é defeito do código; nenhum papel caro é chamado. Registrada ($($ec.env) neste bloco); não conta para o escalonamento do dev (R27)."
            foreach ($nm in $names) { Out "  1. $plugin/target.ps1 -Target $nm -Repair" }
            Out "  2. pronto → dev em instância NOVA: run.ps1 start -Task $($T.Id) (o relatório em delivery/ diz o que já foi feito; rode de novo o que falhou)"
            # v3.53.6 (sprint 5 do garden, item 9): o accept da Task parou por ambiente e o reparo falhou → 🔴 com "prova no alvo
            # pendente" em Bloqueios (mark.ps1 -Reason), nunca ✅ com "nenhum aplicável — emulador fora do ar". O next reabre.
            $aenv = ''; $arj = Join-Path ((Get-VerifyDir $Root $T.Id) -replace '[\\/]verify[\\/]', '/accept/') 'result.json'
            if (Test-Path -LiteralPath $arj) { try { $aenv = [string](Read-Text $arj | ConvertFrom-Json).environment } catch { } }
            if ($aenv -and $names.Count) {
                $aenv = (($aenv -replace '["|]', "'") -replace '\s+', ' ').Trim(); if ($aenv.Length -gt 100) { $aenv = $aenv.Substring(0, 100) + '…' }
                Out "  3. sem reparo → $plugin/mark.ps1 -Task $($T.Id) -To blocked -Reason `"$($script:TargetPendingTag) — $aenv`" (grava a linha em Bloqueios; o run.ps1 next reabre a Task em 🟪 e manda rodar o accept quando o alvo voltar). Não feche a Task sem a prova. Devolva `"$($T.Id) 🔴 bloqueada: $($script:TargetPendingTag) · a fila segue`""
            } else {
                Out "  3. sem reparo → $plugin/mark.ps1 -Task $($T.Id) -To blocked -Reason `"ambiente: <motivo>`" (grava a linha em Bloqueios, com a ação para o stakeholder); a fila segue"
            }
            exit 0
        }
        # v3.53.1 (plugin-report do sprint 4 do garden, item 15): a G23 parou o dev no teto de contexto e ele gravou o ponto de
        # retomada. Não é falha de papel nem de ambiente — não conta para o escalonamento; a instância nova segue pelo cartão.
        if ($Result -eq 'teto') {
            $stop = Get-StopStep $S $T.Id
            Add-RunLog $S $n $T.Id 'teto de contexto do dev (G23) → dev em instância nova pelo cartão' 'a instância passou de guards.json → devContextCap; não conta para o escalonamento' "sprints/$n/delivery/$($T.Id).md"
            if (-not $stop) { Out "run: $($T.Id) — o dev voltou por TETO mas o delivery/$($T.Id).md não tem ### Parei no passo na seção mais recente: a instância nova recomeça do último verify. Siga:" }
            else { Out "run: $($T.Id) parou no TETO de contexto (G23), com o ponto de retomada gravado: $stop" }
            Out "  dev em instância NOVA: run.ps1 start -Task $($T.Id) (o cartão regerado traz o ponto; nada é refeito) e rode run.ps1 done de novo"
            exit 0
        }
        # v3.51.4 (garden item 19): confere ANTES (close.ps1 sem -Apply); fechando, a Task passa por 🟪 (verificação) e só então
        # o -Apply grava o ✅ — antes o -Post reprovava o R24 ("Registro sem a linha → 🟪") com a Task já ✅ e a estimativa baixada.
        $pr = Invoke-Child 'close.ps1' @('-Task', $T.Id, '-Root', $Root); $pre = $pr.Out
        if ($pr.Code -ne 0) {
            $null = Update-DevCounter $T $S 'fail'   # v3.52.2 (item 14): evidência reprovada é falha de papel
            $bad = @($pre -split "`r?`n" | Where-Object { $_ -match '\|\s*(R7[\w-]*|R12)\s*\|\s*falhou' } | ForEach-Object { ($_ -replace '\s+', ' ').Trim() })
            Out "run: $($T.Id) ainda não fecha — dev em instância NOVA (run.ps1 start -Task $($T.Id)) com o que falta (a Task segue em 🟨):"
            foreach ($b in $bad) { Out "  $b" }
            if (-not $bad.Count) { Out "  $(($pre -split "`r?`n" | Where-Object { $_.Trim() } | Select-Object -Last 2) -join ' ')" }
            exit 0
        }
        if ($T.Mark -ne $E.QA) { $mo = Set-Mark $T.Id 'qa' 'sessão (run.ps1 done)'; if ($mo) { Out "  $mo" } }
        $cr = Invoke-Child 'close.ps1' @('-Task', $T.Id, '-Apply', '-Root', $Root); $c = $cr.Out
        $code = $cr.Code
        if ($code -eq 0) {
            Out "run: $($T.Id) fechada pela evidência do dev (close.ps1 -Apply)."; Out (($c -split "`r?`n" | Where-Object { $_ -match '^\s*-\s|\*\*|Status' } | Select-Object -Last 6) -join "`n")
            $cm = Save-TaskCommit $T $S; Out $cm.Line
            Set-SafePoint $T $n
            # v3.52.2 (C3): quem lê isto é o executor de Task — ele devolve UMA linha à sessão, que segue com run.ps1 next.
            $k = 0; foreach ($v in (Get-DevCounter $T $S).Values) { $k += $v.starts }
            Out "  dispatch.ps1 -Clear; PONTO SEGURO gravado (.team-project/.safe-point). Devolva a linha à sessão: `"$($T.Id) ✅ fechada · commit $(if ($cm.Sha) { $cm.Sha } else { '—' }) · $([Math]::Max(1, $k)) rodadas`" — a sessão segue com run.ps1 next."
            exit 0
        }
        Out "run: $($T.Id) — o -Apply gravou o fechamento, mas o -Post não confirmou (R24); não feche de novo (baixaria a estimativa duas vezes):"
        Out "  $((($c -split "`r?`n") | Where-Object { $_ -match '\*\*-Apply:\*\*' } | Select-Object -First 1))"
        Out "  corrija o Registro/Série do kanban.md à mão (sprint-run.md §Marcador) e confira com close.ps1 -Task $($T.Id) -Post"
        exit 0
    }

    # ---------- next ----------
    # v3.53.5: a decisão de esperar vale só até o next seguinte — ele a regrava se a espera continua (G20 lê .next-verdict).
    Set-NextVerdict $Root ''
    # v3.51.4: o run parou por limite de uso da conta (.usage-limit, gravado pela G16 ou pelo Stop) — diz o motivo e segue.
    $lim = Join-Path $tp '.usage-limit'
    if (Test-Path -LiteralPath $lim) {
        try { $l = Read-Text $lim | ConvertFrom-Json; Out "RETOMADA: o run parou por LIMITE DE USO DA CONTA em $($l.desde)$(if ($l.reset) { " (reset: $($l.reset))" }) — $($l.quem)$(if ($l.item) { " em $($l.item)" }). Não é falha de processo: o que estava em voo se retoma por instância nova com o cartão (run.ps1 start) e pelo result.json do verify (sprint-run.md §Retomada após queda)." } catch { }
        # v3.53.1 (plugin-report do sprint 4 do garden, item 8): a mesma sessão seguiu depois do reset — sem SessionStart, nada
        # ia ao .interrupted e o agente cortado ficava fora do registro (≈ 13,9 mi). O que está no .active-agents com o
        # transcript terminado no limite é medido aqui e sai do registro.
        $up0 = Join-Path $tp 'usage.jsonl'; $tdir = ''
        if (Test-Path -LiteralPath $up0) { $lu = @([System.IO.File]::ReadAllLines($up0, $utf8) | Where-Object { $_.Trim() } | Select-Object -Last 1); if ($lu.Count) { try { $st = [string]($lu[0] | ConvertFrom-Json).session_transcript; if ($st) { $tdir = Split-Path $st } } catch { } } }
        foreach ($a in @(Get-ActiveAgents $Root | Where-Object { $_.agent_id -and $_.session })) {
            $atr = if ($tdir) { Join-Path $tdir "$([string]$a.session)/subagents/agent-$([string]$a.agent_id).jsonl" } else { '' }
            if (-not $atr -or -not (Get-LimitFromTranscript $atr)) { continue }
            Measure-CutAgent ([pscustomobject]@{ agent_id = [string]$a.agent_id; type = [string]$a.type; work = [string]$a.work; transcript = $atr; session_transcript = (Join-Path $tdir "$([string]$a.session).jsonl") })
            $null = Remove-ActiveAgent $Root ([string]$a.type) ([string]$a.agent_id)
        }
        Remove-Item -LiteralPath $lim -Force -ErrorAction SilentlyContinue
    }
    # v3.52: a sessão anterior parou no ponto seguro (Task fechada) — esta continua a fila; o marcador sai no próximo start.
    $sp = Get-Marker $Root '.safe-point'
    if ($null -ne $sp) {
        Out "RETOMADA: ponto seguro depois da $([string]$sp.task) (fechada em $([string]$sp.desde)). Esta sessão segue a fila pelo quadro; leia o run-log.md do sprint só se houver bloqueio ou retomada pendente."
        Remove-Item -LiteralPath (Join-Path $tp '.safe-point') -Force -ErrorAction SilentlyContinue   # vale só entre o done e o next
    }
    # v3.52.2 (note.md item 3, C2): a sessão anterior caiu (processo novo: o SessionStart moveu o .active-agents para o
    # .interrupted). Uma linha RETOMADA por item citado, com o "Parei no passo" do delivery; a fila segue normal — a Task em
    # 🟨 é a primeira. O mesmo comando inicia e retoma (/sm sprint run).
    $intP = Join-Path $tp '.interrupted'
    if (Test-Path -LiteralPath $intP) {
        $recs = @(); try { $recs = @((Read-Text $intP | ConvertFrom-Json) | ForEach-Object { $_ }) } catch { }   # no 5.1 a lista JSON chega como um objeto só
        foreach ($g in @($recs | Where-Object { $_ } | Group-Object { [string]$_.work })) {
            $r0 = @($g.Group | Sort-Object { [string]$_.at } -Descending)[0]
            $w = if ($g.Name) { $g.Name } else { '(sem item)' }
            $stop = if ($g.Name) { Get-StopStep $S $g.Name } else { '' }
            Out "RETOMADA: a sessão anterior caiu com $w em andamento ($((@($g.Group | ForEach-Object { [string]$_.type } | Where-Object { $_ } | Select-Object -Unique)) -join ', ')), última ação $(if ($r0.last) { [string]$r0.last } else { '—' }) às $(if ($r0.at) { [string]$r0.at } else { [string]$r0.desde })$(if ($stop) { " · parei no passo: $stop" })"
        }
        # v3.52.3 (note.md item 9): agente cortado pelo limite de uso nunca recebe SubagentStop — a G16 não o media (13,8 mi
        # do sprint 4 do garden fora do usage.jsonl). O SessionStart guardou o transcript dele; a G16 roda aqui por ele.
        foreach ($rc in @($recs | Where-Object { $_ -and $_.PSObject.Properties['transcript'] -and $_.transcript -and $_.agent_id -and (Test-Path -LiteralPath ([string]$_.transcript)) })) {
            Measure-CutAgent $rc
        }
        Remove-Item -LiteralPath $intP -Force -ErrorAction SilentlyContinue
    }
    $null = Invoke-Child 'kanban.ps1' @('-Init', '-Root', $Root)   # consumption.md do sprint, se a Planning não o criou (garden item 1)
    $est = Get-RunEstimate
    if ($est) { Out $est }
    # v3.52.2 (note.md item 17): o consumo da sessão principal, pelo transcript citado na última linha do usage.jsonl — a
    # estimativa acima é "sem a sessão". Sem transcript, cala.
    $up = Join-Path $tp 'usage.jsonl'
    if (Test-Path -LiteralPath $up) {
        $lastU = @([System.IO.File]::ReadAllLines($up, $utf8) | Where-Object { $_.Trim() } | Select-Object -Last 1)
        $stp = ''; if ($lastU.Count) { try { $stp = [string]($lastU[0] | ConvertFrom-Json).session_transcript } catch { } }
        $sg = Get-SessionGauge $stp
        if ($sg) {
            $kk = [int][Math]::Round($sg.LastContext / 1000)
            Out "SESSÃO: $($sg.Calls) chamada(s) · contexto da última $kk mil tokens"
            if ($sg.LastContext -gt 150000) { Out "  aviso: acima de 150 mil — a sessão está conduzindo trabalho que é do executor? (o executor de Task conduz start, dev e done; a sessão dispara e lê a linha de volta)" }
        }
    }
    # v3.53.4: plano externo — o retorno em pack/in/ se lê antes de decidir a próxima ação; cada plano passa pelo plan.ps1.
    Remove-Item -LiteralPath (Join-Path $tp '.external-plan') -Force -ErrorAction SilentlyContinue
    $planner = Get-RunPlanner $Root
    $imp = @(Import-PlanReturns $planner)
    if ($imp.Count) { foreach ($l in $imp) { Out $l }; $tasks = @(Get-SprintTasks $S) }
    $xst = Get-PackState
    foreach ($gid in @($xst.gaps.Keys | Where-Object { $xst.gaps[$_].fix })) {
        $gt = @($tasks | Where-Object { $_.Id -eq $gid }) | Select-Object -First 1
        if ($gt) { $gp = Start-GapPack $gt ''; Out "  external plan: a decisão do 🔺 GAP da $gid voltou reprovada — pacote de correção .team-project/sprints/$n/pack/out/$($gp.Name).zip" }
    }
    # Task com 🔺 GAP no plano externo espera a decisão: não se constrói nem se retoma até ela voltar aprovada.
    $gapWait = @((Get-PackState).gaps.Keys)
    $defined = Get-Defined $Root
    $hasTargets = [bool](Get-TargetsConfig $Root)
    $open = @($tasks | Where-Object { $_.Mark -ne $E.Done -and $_.Mark -ne $redMk })
    $doneIds = @($tasks | Where-Object { $_.Mark -eq $E.Done } | ForEach-Object { $_.Id })
    $deferred = Get-DeferredScenarios $Root
    $waiting = { param($sc) $deferred.ContainsKey($sc) -and $doneIds -notcontains $deferred[$sc] }
    $done = $doneIds
    $cur = @($open | Where-Object { ($_.Mark -eq $E.Build -or $_.Mark -eq $E.QA) -and $gapWait -notcontains $_.Id }) | Select-Object -First 1
    # v3.53.6 (sprint 5 do garden, item 9): Task 🔴 com "prova no alvo pendente" em Bloqueios (o accept parou por ambiente e o
    # reparo falhou). A cada next, sem Task em construção, confere o alvo (target.ps1 sem -Repair, só quando há uma assim): de
    # volta → a Task sai de 🔴 para 🟪 e o operator roda o accept dela; ainda fora → a fila segue, sem esperar.
    if (-not $cur -and $hasTargets) {
        $tpIds = @(Get-TargetPendingIds $S)
        $tpT = @($tasks | Where-Object { $_.Mark -eq $redMk -and $tpIds -contains $_.Id })
        # v3.54.2 (carta do sprint 5 do garden, item 4): reabertura automática UMA vez por Task. A T-063 foi e voltou de 🔴 duas
        # vezes, um operator por volta, com um accept que não tinha como passar; o alvo responder (target.ps1 ok) não prova que
        # o cenário roda. Já reaberta (linha "prova no alvo retomada" em Bloqueios) e de volta a 🔴: fica, e vai ao stakeholder.
        $blkL = Get-BlockLines $S
        $heldT = @($tpT | Where-Object { (Get-TargetRetakeCount $blkL $_.Id) -ge 1 })
        $tpT = @($tpT | Where-Object { (Get-TargetRetakeCount $blkL $_.Id) -lt 1 })
        foreach ($ht in $heldT) {
            $lf = Get-AcceptLastFailure $Root $ht.Id
            Out "  $($ht.Id) 🔴: já reaberta pelo alvo de volta e caiu de novo na prova no alvo — o next não a reabre outra vez (vaivém). Leve ao stakeholder num formulário (R22)$(if ($lf) { " com a última falha: $lf" }): reabrir (mark.ps1 -Task $($ht.Id) -To qa e o accept pelo operator) depois de preparar o estado de partida ou o alvo, ou seguir bloqueada. A fila continua."
        }
        if ($tpT.Count) {
            $tn = @((Get-TargetsConfig $Root).PSObject.Properties | ForEach-Object { $_.Name })[0]
            $hc = Invoke-Child 'target.ps1' @('-Target', $tn, '-Root', $Root)
            if ($hc.Code -eq 0) {
                $rt = $tpT[0]
                $mo = Set-Mark $rt.Id 'qa' 'sessão (run.ps1 next — alvo de volta)'; if ($mo) { Out "  $mo" }
                Add-RunLog $S $n $rt.Id "alvo $tn de volta → sai de 🔴 ($($script:TargetPendingTag)) para 🟪; operator roda o accept" 'target.ps1 ok no run.ps1 next' "sprints/$n/kanban.md (Bloqueios)"
                Write-ScenarioDivergence $rt $S $n
                $only = if ($rt.Scenarios.Count) { Get-AcceptArgs $rt } else { '' }   # v3.56.0 (H2): os do plano, com o .scn da História
                Out "PRÓXIMA AÇÃO: prova no alvo da $($rt.Id) — o alvo $tn voltou (target.ps1 ok): a Task sai de 🔴 para 🟪 e o operator roda o accept que ficou pendente"
                Out "  $(Get-AgentLine 'operator')"
                Out "  prompt: `"Rode na raiz: $plugin/accept.ps1 -Task $($rt.Id)$only (a prova no alvo que ficou pendente quando o alvo caiu). Exit 4 = ambiente: rode $plugin/target.ps1 -Target $tn -Repair uma vez e repita. Não altere código, cenário nem plano. Devolva o caminho do result.md e a linha de resumo.`""
                Out "  depois: run.ps1 done -Task $($rt.Id) -Result ok (fecha pela evidência: o verify do dev e este accept) · accept com exit 4 de novo → run.ps1 done -Task $($rt.Id) -Result env (volta a 🔴 pela prova pendente) · cenário que falhou: o done ok manda dev em instância nova"
                exit 0
            }
            $why = @(($hc.Out -split "`r?`n") | Where-Object { $_ -match 'FALHA DE AMBIENTE|erro' } | Select-Object -First 1)
            Out "  alvo $tn ainda fora$(if ($why.Count) { " ($((($why[0] -replace '^\s*target[^:]*:\s*', '') -replace '\s+', ' ').Trim()))" }): $(($tpT | ForEach-Object { $_.Id }) -join ', ') segue(m) 🔴 com a $($script:TargetPendingTag) — a fila continua; o next confere o alvo de novo na próxima chamada"
        }
    }
    # v3.53.2: cenário que aguarda outra Task (# aguarda <T-ID> no .scn) segura a Task que o cita como uma dependência.
    $blockers = { param($t) @(@($t.Deps | Where-Object { $done -notcontains $_ }) + @($t.Scenarios | Where-Object { & $waiting $_ } | ForEach-Object { $deferred[$_] }) | Select-Object -Unique) }
    # 1 · preparo da construção: por História, cenários executáveis (QA) e depois os planos (Arquiteto), antes de qualquer dev.
    # v3.51.4: sem alvo de execução (guards.json sem "targets") não há .scn a escrever — o accept não roda e os cenários
    # ficam rastreados nos planos e provados por teste (garden item 4). As Tasks da História entram em 🟦 no preparo (item 2).
    # v3.53.3 (sprint 5 do garden): UMA História por vez — a próxima a construir. O next só construía depois do preparo de
    # TODAS (15 Tasks em 🟦 antes da primeira construção): a QA escreveu os .scn de quatro Histórias antes de existir a Task
    # que cria os nomes de teste, o contrato dela cresceu três vezes (~US$ 19 de Opus) e os planos já escritos ficaram velhos
    # (3 GAPs na T-041). A História seguinte só se prepara quando a atual não tem Task a construir.
    # Ordem: a do quadro, mas a História com Task que depende de Task aberta de OUTRA História vem depois dela — a ficha segue
    # dando a sequência, e o plano de quem depende lê o resumo do plano da dependência e o código já construído.
    $prepared = @()
    $stories = @($open | Group-Object Story)
    $extDeps = { param($g) @($g.Group | ForEach-Object { $_.Deps } | Where-Object { $d = $_; $done -notcontains $d -and -not @($g.Group | Where-Object { $_.Id -eq $d }).Count -and @($open | Where-Object { $_.Id -eq $d }).Count }) }
    $stories = @(@($stories | Where-Object { -not @(& $extDeps $_).Count }) + @($stories | Where-Object { @(& $extDeps $_).Count }))
    foreach ($h in $stories) {
        # v3.52.2 (C5): a correção do portão (Q-S<n>) não escreve cenário novo — o plano de correção sai dos achados.
        if ($h.Name -eq $script:GateStory) {
            $noPlan = @($h.Group | Where-Object { -not (Get-PlanFull $_ $S) })
            if (-not $noPlan.Count) { $prepared += $h.Name; if (@($h.Group | Where-Object { @(& $blockers $_).Count -eq 0 }).Count) { break }; continue }
            foreach ($t in @($noPlan | Where-Object { $_.Mark -eq $todoMk })) { $mo = Set-Mark $t.Id 'plan' 'Arquiteto · plano de correção (run.ps1 next)'; if ($mo) { Out "  $mo" } }
            Out "PRÓXIMA AÇÃO: plano de correção do portão — $(($noPlan | ForEach-Object { $_.Id }) -join ', ') (Arquiteto)"
            Out "  $(Get-AgentLine 'architect')"
            Out "  prompt: `"Escreva o plano de correção de $(($noPlan | ForEach-Object { $_.Id }) -join ', ') em .team-project/sprints/$n/plan/<ID>-correcao.md (template fix-plan ou o plano enxuto), a partir dos achados 'Volta para: dev' de .team-project/sprints/$n/validation.md: **Arquivos tocados:** com os arquivos dos achados, teste de regressão por achado. O ✅ das Tasks originais não muda (R25). Rode plan.ps1 e corrija até passar; a sessão atualiza a coluna Plano do quadro. Volte em até 15 linhas.`""
            Out "  depois: plan.ps1 -Plan <caminho> e run.ps1 next (o executor de Task conduz a correção)"
            exit 0
        }
        # v3.53.6 (sprint 5 do garden, item 1): plano acima de 30 KB reprova no plan.ps1 e a Task vai à divisão (a mesma rota da
        # ficha grande), com os blocos do plano como base — antes ele passava com aviso e ia inteiro ao dev. Só Task ainda no
        # preparo; a que está em construção segue.
        $big = $null
        foreach ($bt in @($h.Group | Where-Object { $_.Mark -ne $E.Build -and $_.Mark -ne $E.QA })) { $bp = Get-OversizedPlan $bt; if ($bp) { $big = @{ T = $bt; P = $bp }; break } }
        if ($big) { Write-SplitAction $big.T $h.Name (Get-Ficha $Root $n $big.T.Id) $big.P; exit 0 }
        # v3.53.2: cenário declarado "# aguarda <T-ID>" no .scn não é pedido enquanto a Task que cria os nomes não fecha.
        $missScn = if ($hasTargets) { @($h.Group | ForEach-Object { $_.Scenarios } | Where-Object { $defined -notcontains $_ -and -not (& $waiting $_) } | Select-Object -Unique) } else { @() }
        $noPlan = @($h.Group | Where-Object { -not (Get-PlanFull $_ $S) })
        if ($missScn.Count -or $noPlan.Count) {
            foreach ($t in @($h.Group | Where-Object { $_.Mark -eq $todoMk })) { $mo = Set-Mark $t.Id 'plan' 'Arquiteto · preparo (run.ps1 next)'; if ($mo) { Out "  $mo" } }
        }
        if ($missScn.Count) {
            Out "PRÓXIMA AÇÃO: preparo da construção — cenários executáveis da História $($h.Name) (QA)"
            Out "  $(Get-AgentLine 'quality-assurance')"
            Out "  prompt: `"Escreva os cenários executáveis $($missScn -join ', ') em .team-project/quality-assurance/scenarios/$($h.Name).scn, na linguagem do accept.ps1 (cabeçalho do script), a partir dos critérios de aceite da $($h.Name) e das fichas SC-nnn. Use só os identificadores de teste do contrato; cada cenário com ao menos um assert-*. Cenário cujos identificadores nascem numa Task deste sprint: declare no .scn a linha '# aguarda <T-ID>: SC-…' em vez de escrevê-lo (o next o pede depois que ela fechar). Cenário que não se prova na tela (serviço, render, processo, gate, ação irreversível): aponte na volta como '(teste)' — a sessão marca na coluna Cenários e registra no run-log, sem formulário. Identificador que falta e nenhuma Task do sprint cria: 🔺 GAP. Confira com accept.ps1 -ParseOnly; não rode o app. Volte em até 15 linhas.`""
            Out "  depois: run.ps1 next"
            exit 0
        }
        # v3.53 (note.md itens 7 e 8): Task com ficha no breakdown ganha um Arquiteto próprio, que abre só a ficha, o template
        # e o plano da Task de que depende — a instância que planejava a História inteira foi 63 % dos subagentes no sprint 4
        # (cada chamada reenvia a conversa acumulada). Primeiro a Task cujas dependências já têm plano; uma por vez (R1).
        $withF = @($noPlan | ForEach-Object { $f = Get-Ficha $Root $n $_.Id; if ($f) { [pscustomobject]@{ T = $_; F = $f } } })
        # v3.53.4: plano externo — as Tasks com ficha (todas, ou as de run.tasks) vão num pacote da História, não ao Opus. A
        # ficha se confere antes, como antes do Opus: Task grande se divide e caminho que não existe se corrige (instância curta).
        $xpack = $null
        $extF = @($withF | Where-Object { Test-ExternalTask $planner $_.T.Id })
        if ($extF.Count) {
            $xbad = @($extF | Where-Object { ($null -ne $_.F.Planned -and $_.F.Planned -gt $script:FichaMaxFiles) -or @(Get-FichaMissing $Root $_.F).Count }) | Select-Object -First 1
            if ($xbad) { $withF = @($xbad) }
            else {
                $xpack = Update-StoryPack $h.Name @($extF | ForEach-Object { $_.T })
                $xids = @($extF | ForEach-Object { $_.T.Id })
                $withF = @($withF | Where-Object { $xids -notcontains $_.T.Id })
                $noPlan = @($noPlan | Where-Object { $xids -notcontains $_.Id })
                Out "  external plan: $(if ($xpack.New) { "pacote $($xpack.Name) gerado ($($xpack.Tasks -join ', '); $($xpack.Kb) KB)" } else { "aguardando o retorno de $($xids -join ', ') (pacote $($xpack.Name))" }) — com o stakeholder"
            }
        }
        if ($withF.Count) {
            $ready = { param($t) @($t.Deps | Where-Object { $d = $_; $dt = @($tasks | Where-Object { $_.Id -eq $d }) | Select-Object -First 1; $dt -and $dt.Mark -ne $E.Done -and -not (Get-PlanFull $dt $S) }).Count -eq 0 }
            $pick = @($withF | Where-Object { & $ready $_.T }) | Select-Object -First 1
            if (-not $pick) { $pick = $withF[0] }
            $t = $pick.T
            # v3.53.2 (plugin-report prévio do sprint 5 do garden): o que a ficha já mostra se confere ANTES do Opus — Task
            # grande se divide (o custo do plano cresce mais rápido que ela) e caminho que não existe se corrige numa instância
            # curta (no garden, só o plan.ps1 o via, com o plano já escrito e a conversa em ~280 mil tokens).
            $bdRel = ".team-project/architect/breakdown/S$n.md"
            if ($null -ne $pick.F.Planned -and $pick.F.Planned -gt $script:FichaMaxFiles) { Write-SplitAction $t $h.Name $pick.F $null; exit 0 }
            $miss = Get-FichaMissing $Root $pick.F
            if ($miss.Count) {
                Out "PRÓXIMA AÇÃO: corrigir a ficha da $($t.Id) antes do plano — caminho que não existe: $($miss -join ', ') (Arquiteto, instância curta)"
                Out "  $(Get-AgentLine 'architect')"
                Out "  prompt: `"Na ficha da $($t.Id) em $bdRel, corrija os caminhos que não existem: $($miss -join ', '). Ache a pasta certa com Glob; o que não existir sai da ficha. Não escreva plano nem abra outros arquivos. Volte em até 3 linhas.`""
                Out "  depois: run.ps1 next"
                exit 0
            }
            $dir = Join-Path $S 'handoff'; New-Item -ItemType Directory -Force $dir | Out-Null
            $depPlans = @($t.Deps | ForEach-Object { $d = $_; $dt = @($tasks | Where-Object { $_.Id -eq $d }) | Select-Object -First 1; if ($dt -and (Get-PlanFull $dt $S)) { ".team-project/sprints/$n/$($dt.Plan)" } })
            # v3.53.2: o resumo do plano da dependência vai no recorte; o plano inteiro só se abre no trecho que faltar.
            $depSum = @($depPlans | ForEach-Object { "## Plano da dependência — resumo de ``$_```n`n" + (Get-PlanSummary (Join-Path $Root $_)) })
            $card = "# Ficha da $($t.Id) — recorte de ``$bdRel```n`n> Gerado pelo ``run.ps1 next`` para o Arquiteto do plano (v3.53). A fonte é o breakdown: não edite aqui.`n`n" + $(if ($pick.F.Common) { $pick.F.Common + "`n`n" } else { '' }) + $pick.F.Body + "`n" + $(if ($depSum.Count) { "`n" + ($depSum -join "`n`n") + "`n" } else { '' }) + (Get-DecisionsDigest $Root $n) + (Get-KnowledgeDigest $Root) + (Get-StackPitfallDigest $Root $n $t.Id)   # v3.56.0 (B, C)
            [System.IO.File]::WriteAllText((Join-Path $dir "$($t.Id)-ficha.md"), $card, $utf8)
            $depTxt = if ($depPlans.Count) { '. O resumo do plano da dependência (' + ($depPlans -join ', ') + ': arquivos, nomes, passos) está no fim da ficha: abra esse plano só no trecho que faltar, com offset e limit' } else { '' }
            $rest = @($noPlan | Where-Object { $_.Id -ne $t.Id } | ForEach-Object { $_.Id })
            # v3.53.6 (item 1): Task que nasceu da divisão de um plano grande — a ficha aponta o plano de origem em **Base:**.
            $bm0 = [regex]::Match($pick.F.Body, '\*\*Base:\*\*\s*`([^`]+)`')
            if ($bm0.Success) { $depTxt += ". A ficha tem **Base:** ``$($bm0.Groups[1].Value)`` — o plano da Task dividida: reaproveite os blocos e passos que ela cita (abra só esse trecho, com offset e limit); o que muda é o recorte, não as decisões" }
            Out "PRÓXIMA AÇÃO: preparo da construção — plano da $($t.Id) (História $($h.Name)) pela ficha, um Arquiteto por Task (regra 25)"
            Out "  $(Get-AgentLine 'architect')"
            Out "  prompt: `"Escreva o Plano de Implementação da $($t.Id) — $($t.Title) em .team-project/sprints/$n/plan/$($t.Id)-<slug>.md, no template enxuto. Abra só a ficha .team-project/sprints/$n/handoff/$($t.Id)-ficha.md, o template `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/implementation-plan.md e o .team-project/architect/context.md$depTxt. Do código e das fontes, leia o trecho que a ficha aponta (caminho:linha e §), não o arquivo inteiro. O plano fica como sair: não o corte por tamanho (regra 22) — acima de $($script:PlanMaxKb) KB o plan.ps1 reprova e a Task se divide; aí volte dizendo 'tamanho', sem corrigir. Ler além dela vale: cada arquivo vai na linha **Li além da ficha:** do cabeçalho. Use os nomes comuns da ficha literalmente. Não abra o plan.ps1 nem plano de outro sprint: rode plan.ps1 e corrija pelo que ele imprime. A sessão atualiza a coluna Plano do quadro. Volte em até 15 linhas.`""
            Out "  depois: plan.ps1 -Plan <caminho> (exit 1 volta à mesma instância se ela respondeu há menos de 5 min; senão instância nova) e run.ps1 next$(if ($rest.Count) { " — faltam $($rest -join ', ')" })"
            exit 0
        }
        if ($noPlan.Count) {
            Out "PRÓXIMA AÇÃO: preparo da construção — planos da História $($h.Name) numa instância do Arquiteto (regra 25)"
            Out "  $(Get-AgentLine 'architect')"
            Out "  prompt: `"Escreva os Planos de Implementação de $(($noPlan | ForEach-Object { $_.Id }) -join ', ') (História $($h.Name)) em .team-project/sprints/$n/plan/<T-ID>-<slug>.md, no template enxuto (regras 22 a 25: cite em vez de copiar, sem cortar por tamanho, **Cenários:** com os da Task, **Risco:**, **Layout novo:**). Leia o SDD, os standards citados e o código uma vez para todas. Rode plan.ps1 em cada plano e corrija até passar — menos o 'tamanho' (acima de $($script:PlanMaxKb) KB): esse plano fica como está e a Task se divide no run.ps1 next; atualize a coluna Plano do quadro pela sessão. Volte em até 15 linhas.`""
            Out "  depois: para cada plano, plan.ps1 -Plan <caminho> (exit 1 volta à mesma instância se ela respondeu há menos de 5 min; senão instância nova) e run.ps1 next"
            exit 0
        }
        # v3.53.4: só falta o retorno do plano externo — a Task em construção segue; sem ela, o run espera o stakeholder.
        if ($xpack) { if ($cur) { break }; Write-ExternalWait }
        # v3.53.3: História preparada com Task a construir — constrói antes de preparar a próxima.
        $prepared += $h.Name
        if (@($h.Group | Where-Object { @(& $blockers $_).Count -eq 0 }).Count) { break }
    }
    # 2 · construção: Task em construção primeiro (retomada), depois a primeira elegível com as dependências fechadas — só
    # de História já preparada (v3.53.3: as outras ainda não têm plano nem .scn).
    $next = if ($cur) { $cur } else { @($open | Where-Object { $prepared -contains $_.Story -and $gapWait -notcontains $_.Id -and @(& $blockers $_).Count -eq 0 }) | Select-Object -First 1 }
    if ($gapWait.Count -and $next) { Out "  external plan: aguardando a decisão do 🔺 GAP de $($gapWait -join ', ') — com o stakeholder (pack/out/); a Task não se constrói até ela voltar" }
    # v3.52.2 (note.md item 4, C3): a construção é do executor de Task (team:task-runner), um por Task — ele roda start, dispara
    # o dev, roda done, leva o GAP ao Arquiteto e volta em UMA linha. A sessão não acumula o contexto da Task.
    if ($next) {
        # v3.53.1 (plugin-report do sprint 4 do garden, item 3): executor ou dev desta Task ainda vivo — de outra sessão aberta
        # no mesmo projeto, ou desta, antes do aviso de volta. Redisparar punha dois devs no mesmo emulador.
        $liveA = @(Get-LiveAgents $Root $next.Id | Where-Object { ([string]$_.type -replace '^.*:', '') -in 'task-runner', 'developer' })
        if ($liveA.Count) {
            $a = @($liveA | Sort-Object { [string]$_.at } -Descending)[0]
            $agTxt = "$(([string]$a.type) -replace '^.*:', '') vivo (última ação $(if ($a.last) { $a.last } else { 'disparado' }) há $([int]((Get-AgentIdleHours $a) * 60)) min$(if ($a.host_pid) { ", processo $($a.host_pid)" }))"
            Out "PRÓXIMA AÇÃO: esperar — a $($next.Id) já tem $agTxt. Não dispare outro executor nem dev: seriam duas instâncias no mesmo alvo. Encerre o turno; o aviso de volta reabre a sessão (se ele é de outra sessão, a volta chega lá). Sem sinal de vida por 20 min, o registro deixa de valer e o next segue."
            # v3.53.5: o comando que o agente espera, com o sinal de vida (CPU, arquivo, POSSÍVEL TRAVAMENTO).
            $wA = Get-TaskWait $Root $next.Id
            if ($wA) { Out "  espera: $($wA.Text)"; if ($wA.PSObject.Properties['NoProgress'] -and $wA.NoProgress) { Out "  SEM AVANÇO: $($wA.NoProgress). O accept não vai passar assim: leve ao stakeholder (formulário) — encerrar o accept (ele decide) e preparar o estado de partida (targets.android.baseline) ou o cenário, ou seguir esperando." } }
            Set-NextVerdict $Root 'esperar' $next.Id "agente: $agTxt"
            exit 3
        }
        # v3.53.3: sem agente no registro, mas com verify/accept da Task vivo — o dev esperava o comando quando o registro saiu.
        # v3.53.5: também o reparo do alvo; a linha traz o sinal de vida e, parado, a saída (não esperar às cegas).
        $wN = Get-TaskWait $Root $next.Id
        if ($wN) {
            Out "PRÓXIMA AÇÃO: esperar — a $($next.Id) ainda tem $($wN.Text) rodando (um dev esperava por ele). Não dispare executor nem dev: seriam dois na mesma Task e no mesmo alvo. Encerre o turno; rode run.ps1 next quando o aviso de volta chegar."
            if ($wN.PSObject.Properties['NoProgress'] -and $wN.NoProgress) { Out "  SEM AVANÇO: $($wN.NoProgress). O accept não vai passar assim: leve ao stakeholder (formulário) — encerrar o accept (ele decide) e preparar o estado de partida (targets.android.baseline) ou o cenário, ou seguir esperando." }
            if ($wN.Pulse.Stalled) { Out "  POSSÍVEL TRAVAMENTO: o comando não gasta CPU nem grava arquivo há 10 min ou mais. Não espere às cegas: leve ao stakeholder (formulário) — encerrar o processo (ele decide) e retomar a $($next.Id) por dev novo com o cartão (run.ps1 start), ou seguir esperando." }
            Set-NextVerdict $Root 'esperar' $next.Id "comando: $($wN.Text)"
            exit 3
        }
        # v3.55.0 (F2): a parada única dos comandos dos planos da História, antes do primeiro dev. Dispara a sessão, não o executor.
        $csN = Get-CommandStop $next $tasks $S
        if ($csN.DeniedForT.Count) {
            Out "PRÓXIMA AÇÃO: a $($next.Id) declara comando negado pelo stakeholder ($($csN.DeniedForT -join '; ')) — Arquiteto em instância curta (/arc question) troca o comando no plano (### Comandos da Task), plan.ps1 reconfere e run.ps1 next de novo. Não dispare executor nem dev."
            exit 3
        }
        if ($csN.Pending.Count) {
            Out "PRÓXIMA AÇÃO: formulário de comandos (uma vez) antes de construir $($next.Id) — não dispare executor nem dev."
            Out (Format-CommandStop $csN $next)
            Out "  ao voltar: run.ps1 next"
            exit 3
        }
        $dv = Join-Path $S "delivery/$($next.Id).md"
        $resume = if ($cur -and (Test-Path -LiteralPath $dv)) { " A Task já está em $($next.Mark) com relatório em .team-project/sprints/$n/delivery/$($next.Id).md: se o dev voltou com a entrega, comece por run.ps1 done; se caiu no meio, run.ps1 start retoma pelo cartão." } else { '' }
        Out "PRÓXIMA AÇÃO: construir $($next.Id) — $($next.Title) (executor de Task)"
        Out "  $(Get-AgentLine 'task-runner')"
        Out "  prompt: `"Conduza a $($next.Id) até fechar ou parar, pelo ciclo do agents/task-runner.md: run.ps1 start -Task $($next.Id), dev, run.ps1 done -Task $($next.Id) -Result ok|gap|env|teto (gap: Arquiteto e start de novo; teto: start de novo).$resume Volte em UMA linha.`""
        Out "  ao voltar: run.ps1 next"
        exit 0
    }
    if ($gapWait.Count -or @(Get-ExternalPending).Count) { Write-ExternalWait }
    if ($open.Count) { Out "PRÓXIMA AÇÃO: nenhuma Task elegível — $(($open | ForEach-Object { "$($_.Id) espera $((& $blockers $_) -join ',')" }) -join '; '). Bloqueio sobe pelo degrau 1 (R22)."; exit 3 }

    # 3 · validação do sprint: o operator mede (quality + todos os cenários), o QA julga.
    $sid = "S$n"
    $qr = Join-Path ((Get-VerifyDir $Root $sid) -replace '[\\/]verify[\\/]', '/quality/') 'result.json'
    $ar = Join-Path ((Get-VerifyDir $Root $sid) -replace '[\\/]verify[\\/]', '/accept/') 'result.json'
    $tree = Get-WorkTree $Root
    $fresh = { param($p) if (-not (Test-Path -LiteralPath $p)) { return $false }; try { $j = Read-Text $p | ConvertFrom-Json; return (-not $tree -or -not $j.tree -or [string]$j.tree -eq $tree) } catch { return $false } }
    $val = Join-Path $S 'validation.md'; $vv = Get-VerdictOf $val
    # v3.52.2 (C6): ⚠️ com "**Decisão do PO:** aceito com dívida — …" passa o portão; ❌ nunca.
    $poDebt = ($vv -eq $E.Warn) -and (Test-PoDebt $val)
    if ($vv -ne $E.Done -and -not $poDebt) {
        if (-not (& $fresh $qr) -or ((Get-TargetsConfig $Root) -and -not (& $fresh $ar))) {
            Out "PRÓXIMA AÇÃO: validação do sprint $n — medir (operator, comandos longos fora das instâncias caras; C3)"
            Out "  $(Get-AgentLine 'operator')"
            Out ("  prompt: `"Rode na raiz: $plugin/quality.ps1 -Id $sid" + $(if (Get-TargetsConfig $Root) { " e $plugin/accept.ps1 -Task $sid (todos os cenários)" } else { '' }) + ". Exit 4 = ambiente: rode target.ps1 -Repair uma vez e repita. Devolva os caminhos dos result.md e as linhas de resumo.`"")
            Out "  depois: run.ps1 next"
            exit 0
        }
        if ($null -eq $vv -or $vv -eq '') {
            Out "PRÓXIMA AÇÃO: validação do sprint $n — julgar (QA, uma passada só; portão da Review)"
            Out "  $(Get-AgentLine 'quality-assurance')"
            Out ("  prompt: `"/qa sprint $n — leia .team-project/quality/$n/$sid/result.md" + $(if (Get-TargetsConfig $Root) { " e .team-project/accept/$n/$sid/result.md (com as capturas)" } else { '' }) + ", os planos e o diff do sprint. Julgue SOLID, clean code, aderência à arquitetura e aos planos, padrões e segurança, citando standards/ (Q<n>). Escreva .team-project/sprints/$n/validation.md (template sprint-validation) com o veredito e os achados (Volta para: dev | Arquiteto). Não rode build nem o app. Volte em até 15 linhas.`"")
            exit 0
        }
        # v3.52.2 (note.md item 15, C5): medição mais nova que o validation.md = a correção fechou e o operator mediu de novo
        # → o QA revisa o veredito (rodada nova no mesmo arquivo). Senão, a correção vira Task Q-S<n> no quadro.
        $measAt = @($qr, $ar | Where-Object { Test-Path -LiteralPath $_ } | ForEach-Object { (Get-Item -LiteralPath $_).LastWriteTime } | Sort-Object -Descending)
        if ($measAt.Count -and $measAt[0] -gt (Get-Item -LiteralPath $val).LastWriteTime) {
            $round = @([regex]::Matches((Read-Text $val), '(?m)^\*\*Veredito[^*\r\n]*:\*\*')).Count + 1
            Out "PRÓXIMA AÇÃO: validação do sprint $n — revisar o veredito (QA, instância nova; a medição é mais nova que o validation.md)"
            Out "  $(Get-AgentLine 'quality-assurance')"
            Out ("  prompt: `"/qa sprint $n — a correção do portão fechou e o operator mediu de novo: leia .team-project/quality/$n/$sid/result.md" + $(if (Get-TargetsConfig $Root) { " e .team-project/accept/$n/$sid/result.md" } else { '' }) + ", os achados e o diff das Tasks Q-S$n. Acrescente no fim de .team-project/sprints/$n/validation.md a linha **Veredito (rodada $round):** ✅ | ⚠️ | ❌ com o estado de cada achado — não apague a rodada anterior. Não rode build nem o app. Volte em até 15 linhas.`"")
            Out "  depois: run.ps1 next"
            exit 0
        }
        $qs = @($tasks | Where-Object { $_.Id -match "^Q-S$n([a-z]?)$" } | ForEach-Object { $_.Id })
        $qid = if (-not $qs.Count) { "Q-S$n" } else { $sfx = @($qs | ForEach-Object { if ($_ -match '([a-z])$') { [int][char]$Matches[1] } else { [int][char]'a' } } | Sort-Object -Descending)[0]; "Q-S$n" + [char]($sfx + 1) }
        Out "PRÓXIMA AÇÃO: abrir $qid — correção do portão (validation.md: veredito $vv, sem decisão do PO)"
        Out "  1. a sessão grava a linha da $qid no quadro, seção '## Correção do portão — sprint $n' (a tabela das Histórias: ID, Task, Est., Dono, Depende de, Plano, Evidência, Cenários…), marcador $todoMk, com os achados 'Volta para: dev' do validation.md"
        Out "  2. achado com 'Volta para: Arquiteto' → /arc question (instância nova) com o caminho do validation.md"
        Out "  3. depois: run.ps1 next — o Arquiteto escreve o plano de correção (template fix-plan ou plano enxuto) e o executor de Task conduz a $qid; fechada, o operator mede de novo e o QA revisa o veredito. O ✅ das Tasks originais não muda (R25)"
        if ($vv -eq $E.Warn) { Out "  ⚠️ que o PO aceita como dívida (formulário): a sessão grava no validation.md **Decisão do PO:** aceito com dívida — <motivo e onde a dívida está registrada>; com ela o portão passa (❌ nunca passa)" }
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
