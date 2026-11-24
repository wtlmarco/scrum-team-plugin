# Lições do sprint (v3.56.0, frente E): o SM traz para o projeto o que o sprint ensinou, no /sm sprint close, antes de
# fechar a pasta. Pedido do stakeholder: o plugin aderir melhor ao sistema que o usa. Na classificação dos 117 GAPs do garden
# (sprints 1 a 5), 40 lições eram do projeto, 7 da stack e 40 do plugin — e nenhuma voltava a um lugar que o sprint seguinte
# lesse: o limiar de 160 px reprovou na T-052 do S4 e de novo na T-063 do S5.
#
# Uso (na raiz do projeto):
#   knowledge.ps1 -Sprint <n> [-Check]   só lê: a tabela origem × destino, o que seria promovido, os achados (padrão)
#   knowledge.ps1 -Sprint <n> -Apply     grava a parte mecânica: D com Lição projeto → K-<n> em architect/knowledge.md;
#                                        Lição stack:<x> → <X>-L<n> em .team-project/standards/stacks/<x>/pitfalls.md;
#                                        sprints/<n>/lessons.md (a seção "Lições do sprint" da retrospectiva); acima do
#                                        teto, architect/consolidation.md (o primeiro item do próximo prepare)
#   knowledge.ps1 -Consolidated          (v3.66.0) fim da consolidação do Arquiteto: apaga architect/consolidation.md
#   knowledge.ps1 -Migrate [-Apply] [-Classify "D-1=conhecimento:projeto;D-3=processo:plugin@<até>"] [-Retire K-3]
#                                        /team update 7m: cria o knowledge.md (Classificação desde: o sprint seguinte ao
#                                        aberto) e a pasta local de stacks, lista as D sem classificação, grava a
#                                        classificação que o stakeholder escolheu no formulário e retira K cujo Até chegou
#
# A promoção é CÓPIA: o SM não reescreve conteúdo técnico (o texto é do Arquiteto). Decisão anterior à 3.56.0 (sem
# **Lição:**) entra como "sem classificação" e é promovida como projeto, com aviso. Saída curta; exit 1 com achado
# bloqueante (decisão sem Lição ou com valor fora da lista num sprint de classificação obrigatória), 2 = erro de uso.

param(
    [string]$Sprint = '',
    [switch]$Check,
    [switch]$Apply,
    [switch]$Migrate,
    [string]$Classify = '',
    [string]$Retire = '',
    [switch]$Consolidated,   # v3.66.0: a consolidação do Arquiteto terminou — apaga architect/consolidation.md (o roteiro manda; antes, à mão)
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
. (Join-Path $PSScriptRoot '..\..\hooks\common.ps1')   # Test-GlobMatch, Get-InferredStacks
$utf8 = New-Object System.Text.UTF8Encoding($false)
$tp = Join-Path $Root '.team-project'
if (-not (Test-Path -LiteralPath $tp)) { [Console]::Error.WriteLine('knowledge: sem .team-project/ na raiz'); exit 2 }
$readmeP = Join-Path $tp 'README.md'
$cur = if (Test-Path -LiteralPath $readmeP) { Get-CurrentSprint (Read-Text $readmeP) } else { $null }
if (-not $Sprint) { $Sprint = [string]$cur }
function Out([string]$s) { [Console]::Out.WriteLine($s) }
function Save([string]$Path, [string]$Text) { New-Item -ItemType Directory -Force (Split-Path $Path) | Out-Null; [System.IO.File]::WriteAllText($Path, $Text, $utf8) }

# ---------- -Consolidated (v3.66.0) ----------
# O architect/consolidation.md é aberto por este script (teto do knowledge.md) e o roteiro manda apagá-lo ao fim da
# consolidação. No projeto piloto (23/11) a remoção foi negada pelas permissões e virou duas perguntas ao stakeholder.
if ($Consolidated) {
    $consP = Join-Path $tp 'architect/consolidation.md'
    if (-not (Test-Path -LiteralPath $consP)) { Out 'knowledge -Consolidated: não há consolidação aberta (architect/consolidation.md ausente) — nada a fazer.'; exit 0 }
    $kp0 = Get-KnowledgePath $Root
    $kb = if (Test-Path -LiteralPath $kp0) { [Math]::Round((Get-Item -LiteralPath $kp0).Length / 1KB, 1) } else { 0 }
    Remove-Item -LiteralPath $consP -Force
    Out "knowledge -Consolidated: consolidação encerrada — architect/consolidation.md apagado; knowledge.md com $kb KB$(if ($kb -gt 15) { ' (ainda acima do teto de 15 KB: o próximo close reabre a consolidação)' })."
    exit 0
}

$kPath = Get-KnowledgePath $Root
$kTemplate = Join-Path (Get-PluginRoot) 'roles/architect/templates/knowledge.md'
function New-KnowledgeFile([int]$Since) {
    $t = if (Test-Path -LiteralPath $kTemplate) { Read-Text $kTemplate } else { "# Conhecimento do projeto`n`n**Classificação desde:** S<n>`n" }
    Save $kPath ($t.Replace('**Classificação desde:** S<n>', "**Classificação desde:** S$Since"))
}

# ---------- -Migrate (/team update 7m) ----------
if ($Migrate) {
    $nxt = if ($cur -match '^\d+$') { [int]$cur + 1 } else { 1 }
    $lines = @()
    if (-not (Test-Path -LiteralPath $kPath)) {
        $lines += "criar architect/knowledge.md vazio, com **Classificação desde:** S$nxt (as decisões do sprint aberto, anteriores à 3.56.0, só avisam)"
        if ($Apply) { New-KnowledgeFile $nxt }
    } else { $lines += "architect/knowledge.md já existe (classificação desde S$(Get-KnowledgeSince $Root); $(@(Get-ProjectKnowledge $Root).Count) K)" }
    $lst = Join-Path $tp 'standards/stacks'
    if (-not (Test-Path -LiteralPath $lst)) { $lines += 'criar a pasta local .team-project/standards/stacks/ (a camada de stack do projeto)'; if ($Apply) { New-Item -ItemType Directory -Force $lst | Out-Null } }
    $stk = Get-Stacks $Root
    if (-not $stk.Declared) { $lines += "stacks: guards.json sem ""stacks"" — inferidas: $(if ($stk.Stacks.Count) { $stk.Stacks -join ', ' } else { 'nenhuma' }) (formulário ao stakeholder; a sessão grava a chave)" }
    # Classificação escolhida no formulário do update: grava as linhas na D do sprint (padrão: o aberto).
    $cls = @{}
    foreach ($pair in @($Classify -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
        $m = [regex]::Match($pair, '^(D-\d+)\s*=\s*([^:@]+):([^@]+)(?:@(.+))?$')
        if (-not $m.Success) { [Console]::Error.WriteLine("knowledge -Classify: '$pair' não é D-<k>=<origem>:<lição>[@<até>]"); exit 2 }
        $c = Get-LessonClass ("**Origem:** $($m.Groups[2].Value.Trim())`n**Lição:** $($m.Groups[3].Value.Trim())")
        if ($c.Issues.Count) { [Console]::Error.WriteLine("knowledge -Classify: $($m.Groups[1].Value): $($c.Issues -join ', ')"); exit 2 }
        $cls[$m.Groups[1].Value] = @{ O = $c.Origin; L = $c.Lesson; U = $(if ($m.Groups[4].Success) { $m.Groups[4].Value.Trim() } else { '' }) }
    }
    $dDir = Join-Path $tp 'architect/decisions'
    foreach ($df in @(Get-ChildItem -LiteralPath $dDir -Filter 'S*.md' -File -ErrorAction SilentlyContinue | Sort-Object Name)) {
        $sn = ($df.BaseName -replace '^S', '')
        $txt = Read-Text $df.FullName; $changed = $false
        foreach ($d in @(Get-SprintDecisions $Root $sn)) {
            if ($d.Class.Classified) { continue }
            if ($sn -eq $Sprint -and $cls.ContainsKey($d.Id)) {
                $c = $cls[$d.Id]
                $ins = "**Origem:** $($c.O)`n**Lição:** $($c.L)" + $(if ($c.U) { "`n**Até:** $($c.U)" } else { '' })
                $hm = [regex]::Match($txt, '(?m)^##\s+' + [regex]::Escape($d.Id) + '\s*[—–-][^\r\n]*\r?\n(\*\*Vale para:\*\*[^\r\n]*\r?\n)?')
                if ($hm.Success) { $txt = $txt.Insert($hm.Index + $hm.Length, $ins + "`n"); $changed = $true }
                $lines += "$($d.Id) do S$sn — $($d.Title): classificada $($c.O) · $($c.L)$(if ($c.U) { " · até: $($c.U)" })$(if (-not $Apply) { ' (a gravar com -Apply)' })"
            } else {
                $lines += "$($d.Id) do S$sn — $($d.Title): sem classificação → no close do S$sn entra como Lição: projeto (padrão). Outro destino: formulário e -Classify ""$($d.Id)=<origem>:<lição>[@<até>]"""
            }
        }
        if ($changed -and $Apply) { Save $df.FullName $txt }
    }
    # K com **Até:** — o remédio temporário de defeito do plugin. O update a retira quando a versão nova traz a correção.
    $ret = @($Retire -split '[,;\s]+' | Where-Object { $_ })
    $kn = @(Get-ProjectKnowledge $Root)
    foreach ($k in @($kn | Where-Object { $_.Until })) {
        if ($ret -contains $k.Id) { $lines += "$($k.Id) — $($k.Title): retirada (até: $($k.Until))$(if (-not $Apply) { ' (a retirar com -Apply)' })" }
        else { $lines += "$($k.Id) — $($k.Title): remédio até '$($k.Until)' — se esta versão traz a correção, confirme no formulário e rode -Retire $($k.Id)" }
    }
    if ($ret.Count -and $Apply -and (Test-Path -LiteralPath $kPath)) {
        $kt = Read-Text $kPath
        foreach ($id in $ret) { $kt = [regex]::Replace($kt, '(?ms)^##\s+' + [regex]::Escape($id) + '\s*[—–-].*?(?=^##\s|\z)', '') }
        Save $kPath $kt
    }
    Out "knowledge -Migrate$(if ($Apply) { ' -Apply' }): $($lines.Count) item(ns)"
    foreach ($l in $lines) { Out "  - $l" }
    exit 0
}

# ---------- fechamento do sprint ----------
if (-not ($Sprint -match '^\d+$')) { [Console]::Error.WriteLine('knowledge: diga -Sprint <n> (ou declare o sprint corrente no .team-project/README.md §2)'); exit 2 }
$S = Join-Path $tp "sprints/$Sprint"
if (-not (Test-Path -LiteralPath $S)) { [Console]::Error.WriteLine("knowledge: sem a pasta sprints/$Sprint"); exit 2 }
$strict = Test-LessonStrict $Root $Sprint
$taskRe = $script:TaskIdRe

# As decisões de 🔺 GAP do sprint: cada D-<k> e cada "**Decisão do GAP …:**" dos planos.
$items = @()
foreach ($d in @(Get-SprintDecisions $Root $Sprint)) {
    $tm = [regex]::Match($d.Body, '(?:\*\*Do GAP:\*\*\s*|GAP\s+(?:\d+\s+)?da\s+)(' + $taskRe + ')')
    $vm = [regex]::Match($d.Body, '(?m)^\*\*Vale para:\*\*\s*([^\r\n]*)$')
    $um = [regex]::Match($d.Body, '(?m)^\*\*At[ée]:\*\*\s*([^\r\n]+)$')
    $items += [pscustomobject]@{ Kind = 'D'; Id = $d.Id; Task = $(if ($tm.Success) { $tm.Groups[1].Value } elseif (@($d.Ids).Count) { @($d.Ids)[0] } else { '' }); Title = $d.Title; Class = $d.Class
        Scope = $(if ($vm.Success) { ($vm.Groups[1].Value -split '\s+·\s+')[0].Trim() } else { 'todas' }); Rule = @($d.Body -split "`r?`n" | Where-Object { $_.Trim() -and $_ -notmatch $script:EntryMetaRe } | ForEach-Object { $_.Trim() })
        Until = $(if ($um.Success) { $um.Groups[1].Value.Trim() } else { '' }); Key = "$($d.Id) do S$Sprint"; Body = $d.Body; Plan = '' }
}
foreach ($pf in @(Get-ChildItem -LiteralPath (Join-Path $S 'plan') -Filter '*.md' -File -ErrorAction SilentlyContinue | Sort-Object Name)) {
    $tid = ([regex]::Match($pf.Name, '^' + $taskRe)).Value; $ptxt = Read-Text $pf.FullName
    foreach ($g in @(Get-PlanGapDecisions $ptxt)) {
        $hm = [regex]::Match($g.Head, '^\*\*(Decis[ãa]o do (?:(?:🔺\s*)?GAP|stakeholder)\b[^*]*):\*\*\s*(.*)$')   # v3.65.0: a decisão do stakeholder que emenda o plano também
        $label = if ($hm.Success) { $hm.Groups[1].Value.Trim() } else { 'Decisão do GAP' }
        $first = if ($hm.Success) { $hm.Groups[2].Value.Trim() } else { '' }
        $rest = @(($g.Text -split "`r?`n") | Select-Object -Skip 1 | Where-Object { $_.Trim() -and $_ -notmatch $script:EntryMetaRe } | ForEach-Object { $_.Trim() })
        $um = [regex]::Match($g.Text, '(?m)^\*\*At[ée]:\*\*\s*([^\r\n]+)$')
        $title = if ($first.Length -gt 70) { $first.Substring(0, 70).TrimEnd() + '…' } else { $first }
        $items += [pscustomobject]@{ Kind = 'plano'; Id = "$tid · $label"; Task = $tid; Title = $title; Class = (Get-LessonClass $g.Text); Scope = $tid
            Rule = @(@($first) + $rest | Where-Object { $_ }); Until = $(if ($um.Success) { $um.Groups[1].Value.Trim() } else { '' }); Key = $(if ($label.Contains($tid)) { "$label · S$Sprint" } else { "$label da $tid · S$Sprint" }); Body = $g.Text; Plan = $ptxt }
    }
}

# Destino efetivo: a Lição declarada; sem ela, projeto (decisão anterior à 3.56.0).
$finds = @(); $block = $false; $warns = @()
foreach ($it in $items) {
    $it | Add-Member -NotePropertyName Lesson -NotePropertyValue $(if ($it.Class.Classified) { $it.Class.Lesson } else { 'projeto' })
    $it | Add-Member -NotePropertyName OriginShown -NotePropertyValue $(if ($it.Class.Classified -and $it.Class.Origin) { $it.Class.Origin } else { 'sem classificação' })
    if ($it.Class.Issues.Count) { $finds += "$($it.Key): $($it.Class.Issues -join ', ')"; $block = $true }
    elseif (-not $it.Class.Classified) {
        if ($strict) { $finds += "$($it.Key) sem **Origem:** e **Lição:** — achado de processo (o plan.ps1 devia ter barrado)"; $block = $true }
        else { $warns += "$($it.Key) sem classificação (anterior à 3.56.0): promovida como projeto" }
    }
}

# Tabela origem × destino (a linha de base do garden S5: previsão 11, processo 15, conhecimento 2, ambiente 10, requisito 1).
$origins = @($script:GapOrigins) + @('sem classificação')
$dests = @('projeto', 'stack', 'plugin', 'nenhuma')
$tbl = @('| Origem | projeto | stack | plugin | nenhuma | Total |', '|---|---|---|---|---|---|')
foreach ($o in $origins) {
    $row = @($items | Where-Object { $_.OriginShown -eq $o })
    if (-not $row.Count -and $o -eq 'sem classificação') { continue }
    $cells = @($dests | ForEach-Object { $dd = $_; @($row | Where-Object { ($_.Lesson -replace ':.*$', '') -eq $dd }).Count })
    $tbl += "| $o | $($cells -join ' | ') | $($row.Count) |"
}
$tot = @($dests | ForEach-Object { $dd = $_; @($items | Where-Object { ($_.Lesson -replace ':.*$', '') -eq $dd }).Count })
$tbl += "| **Total** | $($tot -join ' | ') | $($items.Count) |"

# Promoções: D (e decisão do plano) com Lição projeto → K; stack:<x> → <X>-L; plugin com **Até:** → K com Até (remédio).
$kText = if (Test-Path -LiteralPath $kPath) { Read-Text $kPath } else { '' }
$kNext = (@(@(Get-ProjectKnowledge $Root) | ForEach-Object { [int]($_.Id -replace '^K-', '') }) + @(0) | Measure-Object -Maximum).Maximum + 1
$prom = @(); $plugin = @(); $kAdd = ''; $lAdd = @{}
foreach ($it in $items) {
    $mark = "🔺 GAP · $($it.Key)$(if ($it.Task -and $it.Kind -eq 'D') { " ($($it.Task))" })"
    $toK = ($it.Lesson -eq 'projeto') -or ($it.Lesson -eq 'plugin' -and $it.Until)
    if ($it.Lesson -eq 'plugin') { $plugin += "$($it.Key)$(if ($it.Task) { " ($($it.Task))" }) — $($it.Title) · origem $($it.OriginShown)$(if ($it.Until) { " · remédio no projeto até: $($it.Until)" })" }
    if ($toK) {
        if ($kText.Contains($it.Key)) { $prom += "$($it.Key) → já no knowledge.md"; continue }
        $kid = "K-$kNext"; $kNext++
        $kAdd += "`n## $kid — $($it.Title)`n**Vale para:** $($it.Scope) · **Origem:** $mark · **Desde:** S$Sprint$(if ($it.Until) { " · **Até:** $($it.Until)" })`n" + ((@($it.Rule) | Select-Object -First 5) -join "`n") + "`n"
        $prom += "$($it.Key) → $kid$(if ($it.Until) { " (até: $($it.Until))" })"
    } elseif ($it.Lesson -like 'stack:*') {
        $stack = $it.Lesson.Substring(6)
        $lp = Join-Path $tp "standards/stacks/$stack/pitfalls.md"
        if (-not $lAdd.ContainsKey($stack)) { $lAdd[$stack] = @{ Path = $lp; Text = $(if (Test-Path -LiteralPath $lp) { Read-Text $lp } else { '' }); Add = ''; Next = 0 } }
        $la = $lAdd[$stack]
        if ($la.Text.Contains($it.Key)) { $prom += "$($it.Key) → já na camada local de $stack"; continue }
        $pre = ''
        $pp = Join-Path (Get-PluginRoot) "standards/stacks/$stack/pitfalls.md"
        if (Test-Path -LiteralPath $pp) { $pm = [regex]::Match((Read-Text $pp), '\(([A-Z][A-Z0-9-]*)-P\)'); if ($pm.Success) { $pre = $pm.Groups[1].Value } }
        if (-not $pre) { $pre = ($stack.ToUpperInvariant() -replace '[^A-Z0-9]', '') }
        if (-not $la.Next) { $la.Next = (@([regex]::Matches($la.Text, '(?m)^##\s+' + [regex]::Escape($pre) + '-L(\d+)') | ForEach-Object { [int]$_.Groups[1].Value }) + @(0) | Measure-Object -Maximum).Maximum + 1 }
        $lid = "$pre-L$($la.Next)"; $la.Next++
        $la.Add += "`n## $lid — $($it.Title)`n**Vale para:** $($it.Scope)`n**Fato:** $((@($it.Rule) | Select-Object -First 5) -join ' ')`n**Origem:** $mark · S$Sprint`n"
        $prom += "$($it.Key) → $lid (camada local de $stack)"
    }
}

# Repetição com registro: GAP de Origem conhecimento cuja decisão cita uma K, D ou armadilha que já existia — o registro
# existia e não chegou à Task (ou chegou e não foi seguido). É o indicador que pega um novo "160 px".
$reps = @()
$allK = @(Get-ProjectKnowledge $Root); $allP = @(Get-StackPitfalls $Root); $allD = @(Get-SprintDecisions $Root $Sprint)
foreach ($it in @($items | Where-Object { $_.Class.Origin -eq 'conhecimento' })) {
    $own = if ($it.Kind -eq 'D') { $it.Id } else { '' }
    $cited = @([regex]::Matches($it.Body, '\b(K-\d+|D-\d+|[A-Z][A-Z0-9-]*-[PL]\d+)\b') | ForEach-Object { $_.Value } | Where-Object { $_ -ne $own } | Select-Object -Unique)
    foreach ($cid in $cited) {
        $ent = @(@($allK) + @($allP) + @($allD) | Where-Object { $_.Id -eq $cid }) | Select-Object -First 1
        if (-not $ent) { continue }
        $ptxt = if ($it.Plan) { $it.Plan } else { $pp0 = @(Get-ChildItem -LiteralPath (Join-Path $S 'plan') -Filter "$($it.Task)-*.md" -File -ErrorAction SilentlyContinue) | Select-Object -First 1; if ($pp0) { Read-Text $pp0.FullName } else { '' } }
        $files = @(Get-TaskFiles $Root $Sprint $it.Task $ptxt)
        $hit = if ($it.Task) { (Test-EntryApplies $ent $it.Task $files @() $ptxt) -or ($ent.PSObject.Properties['Terms'] -and (Test-PlanTerms @($ent.Terms) $ptxt)) -or ($ent.PSObject.Properties['All'] -and $ent.All) -or (@($ent.Ids) -contains $it.Task) } else { $false }
        # v3.65.14 (B): a proposta pronta para o formulário do fechamento — o ID da Task, a pasta comum dos arquivos dela.
        $prop = ''
        if (-not $hit -and $it.Task) {
            $dirs = @($files | ForEach-Object { $d = ($_ -replace '\\', '/'); $i = $d.LastIndexOf('/'); if ($i -gt 0) { $d.Substring(0, $i) } } | Where-Object { $_ } | Select-Object -Unique)
            $common = ''
            if ($dirs.Count) { $common = $dirs[0]; foreach ($d in $dirs) { while ($common -and -not ($d + '/').StartsWith($common + '/')) { $i = $common.LastIndexOf('/'); $common = if ($i -gt 0) { $common.Substring(0, $i) } else { '' } } } }
            $opts = @("``$($it.Task)``"); if ($common) { $opts += "``$common/**``" }; $opts += '`plano: <termo que os planos dessas Tasks trazem>`'
            $prop = " — proposta: acrescentar ao **Vale para:** de $cid $($opts -join ' ou ')"
        }
        $reps += "$($it.Key)$(if ($it.Task) { " ($($it.Task))" }) repete $cid — " + $(if ($hit) { 'o registro chegou ao cartão (o Vale para casa com a Task) e não foi seguido: achado contra o plano e a ficha' } else { "o registro existia e NÃO chegou à Task (o Vale para de $cid não casa com os arquivos dela): achado contra a ficha e o cartão — alargar o Vale para$prop" })
    }
}

# v3.65.14 (B): o **Vale para** com condição em texto não chega a Task nenhuma — aviso nas decisões do sprint e nas K dele.
# Uma linha só (no garden S6 eram 26 das 31 decisões), com até 3 exemplos.
$proseIds = @(); $proseEx = @()
foreach ($ent in @(@($allD) + @($allK | Where-Object { $_.Since -eq [int]$Sprint }))) {
    $vl = if ($ent.PSObject.Properties['Scope']) { [string]$ent.Scope } else { $vm0 = [regex]::Match([string]$ent.Body, '(?m)^\*\*Vale para:\*\*\s*([^\r\n]*)$'); if ($vm0.Success) { $vm0.Groups[1].Value } else { '' } }
    $pr = @(Get-ScopeProse $vl)
    if ($pr.Count) { $proseIds += $ent.Id; if ($proseEx.Count -lt 3) { $proseEx += "$($ent.Id) '$($pr[0])'" } }
}
if ($proseIds.Count) { $warns += "$($proseIds.Count) registro(s) com **Vale para** em texto que o script não lê ($($proseIds -join ', ')) — ex.: $($proseEx -join '; '). A condição em texto não leva a regra a Task nenhuma: o Arquiteto reescreve com IDs de Task, caminhos com glob, ``todas`` ou ``plano: <termo que o plano traz>`` (ex.: ``plano: prova-cdp.mjs``)" }

# Teto: knowledge.md acima de 15 KB ou mais de 10 entradas locais de stack sem promoção → consolidação no próximo prepare.
$kBytes = $utf8.GetByteCount($kText + $kAdd)
$localN = 0
foreach ($lf in @(Get-ChildItem -LiteralPath (Join-Path $tp 'standards/stacks') -Filter 'pitfalls.md' -File -Recurse -ErrorAction SilentlyContinue)) { $localN += @(Read-PitfallFile $lf.FullName 'local' | Where-Object { -not $_.Promoted }).Count }
foreach ($k in $lAdd.Keys) { $localN += ([regex]::Matches($lAdd[$k].Add, '(?m)^##\s')).Count }
$teto = @()
if ($kBytes -gt $script:KnowledgeMaxKb * 1024) { $teto += "architect/knowledge.md com $([math]::Round($kBytes / 1024, 1)) KB (teto $($script:KnowledgeMaxKb) KB)" }
if ($localN -gt 10) { $teto += "$localN entradas locais de stack sem promoção (teto 10)" }

# Configuração do projeto que o sprint pediu: o que mudou no uso, como propostas para o formulário único do fechamento (R25).
$cfgP = @()
$stk = Get-Stacks $Root
if (-not $stk.Declared) { $cfgP += "declarar ""stacks"" no guards.json: $(if ($stk.Stacks.Count) { ($stk.Stacks | ForEach-Object { '"' + $_ + '"' }) -join ', ' } else { '(nenhuma inferida — dizer qual)' }) (hoje o cartão segue a inferência)" }
$rlP = Join-Path $S 'run-log.md'
if (Test-Path -LiteralPath $rlP) {
    $rl = Read-Text $rlP
    $lib = @([regex]::Matches($rl, '(?m)\|\s*liberou:\s*([^|]+)\|') | ForEach-Object { $_.Groups[1].Value.Trim() })
    # v3.65.14 (F · garden S6: a lista trazia "& '…\plugins\cache\team\team\3.64.0\accept.ps1'"): o caminho de uma versão
    # do plugin em runCommands fica velho no update seguinte — proposta própria, de tirar.
    $cacheRe = '(?i)[\\/]plugins[\\/]cache[\\/]|[\\/]\d+\.\d+\.\d+[\\/][\w-]+\.ps1'
    $libOld = @($lib | Where-Object { $_ -match $cacheRe } | Select-Object -Unique)
    $lib = @($lib | Where-Object { $_ -notmatch $cacheRe } | Select-Object -Unique)
    if ($lib.Count) { $cfgP += "comandos liberados no run e já gravados em runCommands: $($lib -join '; ') — manter (nada a fazer) ou tirar algum" }
    foreach ($o in $libOld) { $vm1 = [regex]::Match($o, '[\\/](\d+\.\d+\.\d+)[\\/]'); $cfgP += "runCommands com o caminho de uma versão do plugin$(if ($vm1.Success) { " ($($vm1.Groups[1].Value))" }): $o — tirar: o run chama os scripts do plugin pela versão instalada, e este caminho envelhece no próximo update" }
    $rep = @([regex]::Matches($rl, '(?mi)^\|[^\n]*\b(reparo|repair|target\.ps1 -Repair)\b[^\n]*$')).Count
    if ($rep) { $cfgP += "$rep linha(s) de reparo do alvo no run-log — rever targets.<alvo>.repair, maxUptimeHours ou freshStart" }
}
# v3.65.14 (F · garden S6: 12 linhas com o mesmo "rever a chave … (ex.: seedTimeoutSec, timeoutMinutes)", até para a Q9 e o
# executor, e repetindo as ocorrências de plugin): só o GAP de ambiente que não é ocorrência de plugin e cita uma chave de
# configuração vira proposta, e a linha traz a chave que ele citou.
$cfgKeyRe = '\b(targets\.[\w.]+|verify\.[\w.]+|run\.[\w.]+|quality\.[\w.]+|seedTimeoutSec|timeoutMinutes|maxUptimeHours|freshStart|readyExpr|baseline|runCommands|protectedPaths|coveragePattern|todoPattern|apkSources)\b'
foreach ($it in @($items | Where-Object { $_.Class.Origin -eq 'ambiente' -and $_.Lesson -ne 'plugin' })) {
    $keys = @([regex]::Matches(([string]$it.Title + "`n" + [string]$it.Body), $cfgKeyRe) | ForEach-Object { $_.Value } | Where-Object { $_ -notmatch '(?i)\.(ps1|md|json|ts|js|mjs|html|scn|txt)$' } | Select-Object -Unique)
    if ($keys.Count) { $cfgP += "GAP de ambiente $($it.Key)$(if ($it.Task) { " ($($it.Task))" }): $($it.Title) — rever no guards.json: $(($keys | ForEach-Object { '`' + $_ + '`' }) -join ', ')" }
}

# lessons.md — a seção "Lições do sprint" da retrospectiva.
$md = @("# Lições do sprint $Sprint", '', "> Gerado por ``knowledge.ps1 -Sprint $Sprint$(if ($Apply) { ' -Apply' })`` em $(Get-Date -Format 'yyyy-MM-dd HH:mm'). A retrospectiva cita este arquivo na seção **Lições do sprint**; o SM não reescreve o conteúdo técnico.", '',
        "## Origem × destino ($($items.Count) decisão(ões) de 🔺 GAP)", '') + $tbl + @('', '| Decisão | Task | Origem | Lição |', '|---|---|---|---|')
foreach ($it in $items) { $md += "| $($it.Key) — $($it.Title -replace '\|', '/') | $(if ($it.Task) { $it.Task } else { '—' }) | $($it.OriginShown) | $($it.Lesson)$(if (-not $it.Class.Classified) { ' (padrão)' }) |" }
$sec = { param($h, $l) $o = @('', "## $h", ''); if (@($l).Count) { $o += @($l | ForEach-Object { "- $_" }) } else { $o += '- nenhuma' }; $o }
$md += & $sec "Promoções$(if (-not $Apply) { ' (a fazer com -Apply)' })" $prom
$md += & $sec 'Ocorrências de plugin (iii) — para o formulário único do fechamento (investigar × ignorar)' $plugin
$md += & $sec 'Repetições com registro' $reps
$md += & $sec 'Achados de processo' @(@($finds) + @($warns))
$md += & $sec 'Propostas de configuração — para o mesmo formulário (R25); o SM só grava o que o stakeholder aprovar' $cfgP
$md += & $sec 'Teto' $(if ($teto.Count) { @($teto | ForEach-Object { "$_ → consolidação como primeiro item do próximo /sm sprint prepare (Arquiteto, uma instância)" }) } else { @("knowledge.md com $([math]::Round($kBytes / 1024, 1)) KB; $localN entrada(s) locais de stack — dentro do teto") })

if ($Apply) {
    if ($kAdd) {
        if (-not (Test-Path -LiteralPath $kPath)) { New-KnowledgeFile ([int]$Sprint + 1); $kText = Read-Text $kPath }
        Save $kPath ($kText.TrimEnd() + "`n" + $kAdd)
    }
    foreach ($k in $lAdd.Keys) {
        $la = $lAdd[$k]; if (-not $la.Add) { continue }
        $head = if ($la.Text) { $la.Text.TrimEnd() } else { "# Armadilhas da stack — $k (camada local do projeto)`n`n> Soma à do plugin (```${CLAUDE_PLUGIN_ROOT}/standards/stacks/$k/pitfalls.md``). Escritores: Arquiteto e SM (promoção mecânica do fechamento). Entrada com **Promovida:** <ID do plugin> deixa de ser lida; a promoção é do /review." }
        Save $la.Path ($head + "`n" + $la.Add)
    }
    Save (Join-Path $S 'lessons.md') ((($md -join "`n").TrimEnd()) + "`n")
    $cons = Join-Path $tp 'architect/consolidation.md'
    if ($teto.Count) { Save $cons ("# Consolidação do conhecimento — primeiro item do próximo /sm sprint prepare`n`n> Aberta por ``knowledge.ps1 -Sprint $Sprint -Apply`` em $(Get-Date -Format 'yyyy-MM-dd'). O Arquiteto, numa instância: junta entradas parecidas, apaga as superadas e sobe para os standards do projeto o que virou regra geral; propõe ao /review a promoção das entradas locais de stack confirmadas. Ao terminar, rode ``knowledge.ps1 -Consolidated`` (apaga este arquivo; sem pedir ao stakeholder).`n`n" + (($teto | ForEach-Object { "- $_" }) -join "`n") + "`n") }
}

Out "knowledge S${Sprint}$(if ($Apply) { ' -Apply' } else { ' -Check' }): $($items.Count) decisão(ões) · promoções $($prom.Count) · plugin $($plugin.Count) · repetições com registro $($reps.Count) · achados $($finds.Count)$(if ($warns.Count) { " · avisos $($warns.Count)" }) · propostas $($cfgP.Count)$(if ($teto.Count) { ' · TETO: consolidação no próximo prepare' })"
foreach ($l in @($prom | Select-Object -First 8)) { Out "  promoção: $l" }
foreach ($l in $plugin) { Out "  plugin (iii): $l" }
foreach ($l in $reps) { Out "  repetição com registro: $l" }
foreach ($l in $finds) { Out "  ACHADO: $l" }
foreach ($l in $teto) { Out "  teto: $l" }
if ($Apply) { Out "  lições: sprints/$Sprint/lessons.md$(if ($teto.Count) { ' · architect/consolidation.md' })" } else { Out "  (só leitura — -Apply grava as promoções e sprints/$Sprint/lessons.md)" }
if ($block) { exit 1 }
exit 0
