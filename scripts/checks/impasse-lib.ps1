# v3.66.0 — a matriz de impasses: um ponto só decide quem resolve (melhorias/plano-v3.66.0.md, item A, B e F).
# Núcleo compartilhado, sem dependência de lib.ps1: carregado pelo plain.ps1, e por isso disponível aos hooks (common.ps1),
# ao kanban.ps1, ao run.ps1 e ao impasse.ps1. A regra mora em roles/scrum-master/process/impasse-matrix.md (a fonte) e em
# hooks/impasses.json (o derivado que se lê aqui); o C3 (release.ps1) confere os dois.
# O registro de cada caso é por trilha: sprints/<n>/team-decisions.jsonl ou fixes/B-<nnn>/team-decisions.jsonl. Uma linha por
# evento (raise, close, refused), só acrescentada; o estado de cada impasse é a dobra dos eventos do mesmo id.
# Requisito: Windows PowerShell 5.1.

$script:ImpasseLibDir = $PSScriptRoot
$script:ImpUtf8 = New-Object System.Text.UTF8Encoding($false)

function Read-ImpText([string]$Path) { return [System.IO.File]::ReadAllText($Path, $script:ImpUtf8) }

# A matriz do plugin, com o acréscimo do projeto (guards.json → impasses.extra). O projeto acrescenta tipo novo ou exemplos;
# não muda dono nem "reachesStakeholder" de tipo que já existe — o que tentar fica em Rejected.
function Get-ImpasseMatrix([string]$ProjectDir = '') {
    $p = Join-Path $script:ImpasseLibDir '..\..\hooks\impasses.json'
    $m = Read-ImpText $p | ConvertFrom-Json
    $types = New-Object System.Collections.ArrayList
    foreach ($t in @($m.types)) { [void]$types.Add($t) }
    $rejected = @()
    if ($ProjectDir) {
        $gp = Join-Path $ProjectDir '.team-project/guards.json'
        if (Test-Path -LiteralPath $gp) {
            $extra = $null; try { $extra = (Read-ImpText $gp | ConvertFrom-Json).impasses.extra } catch { }
            foreach ($x in @($extra | Where-Object { $_ -and $_.type })) {
                $cur = @($types | Where-Object { $_.type -eq [string]$x.type }) | Select-Object -First 1
                if ($cur) { $rejected += "$([string]$x.type): já existe na matriz do plugin — o projeto não muda dono nem subida"; continue }
                if (@('direct', 'afterLadder', 'never') -notcontains [string]$x.reachesStakeholder -or -not $x.owner) { $rejected += "$([string]$x.type): sem owner ou com reachesStakeholder fora de direct · afterLadder · never"; continue }
                [void]$types.Add($x)
            }
        }
    }
    return [pscustomobject]@{ Types = @($types); OfferPhrases = @($m.offerPhrases); Rejected = $rejected; Version = [string]$m.version; Causes = $m.causes; Roles = $m.roles }
}

# v3.66.0 (etapa 2, item G): o dono de uma causa de 🔺 GAP (run.ps1 done) ou de achado do portão (gate.ps1), pela matriz —
# antes, dois mapas fixos ($ownG no run.ps1 e $owners no gate.ps1). @{ Cause; Type; Role; Command; Short; Label } ou $null.
function Resolve-ImpasseOwner([string]$Cause, $Matrix = $null) {
    if (-not $Matrix) { $Matrix = Get-ImpasseMatrix }
    $c = $Matrix.Causes.$Cause
    if (-not $c) { return $null }
    $t = Get-ImpasseType $Matrix ([string]$c.type)
    if (-not $t) { return $null }
    $role = [string]$t.owner; $ri = $Matrix.Roles.$role
    $seq = @(@($c.sequence) | Where-Object { $_ } | ForEach-Object { [string]$_ })
    return [pscustomobject]@{ Cause = $Cause; Type = [string]$t.type; Role = $role; Command = $(if ($ri) { [string]$ri.command } else { '' }); Short = $(if ($ri) { [string]$ri.short } else { $role }); Label = [string]$c.label; Sequence = $seq }
}

# v3.66.0 (item H, G7): a sequência de papéis que o executor de Task pode disparar para o 🔺 GAP aberto da Task — a da causa
# na matriz (§1a, sequence), gravada pelo run.ps1 done -Result gap em .team-project/.gap-route. Sem causa na matriz, o ciclo
# do Arquiteto (architect → developer). Sai quando a Task fecha ou com o GAP seguinte; vale no máximo 6 h.
function Set-GapRoute([string]$ProjectDir, [string]$Task, [string]$Cause) {
    $o = Resolve-ImpasseOwner $Cause
    $seq = if ($o -and @($o.Sequence).Count) { @($o.Sequence) } else { @('architect', 'developer') }
    $p = Join-Path $ProjectDir '.team-project/.gap-route'
    [System.IO.File]::WriteAllText($p, ([ordered]@{ task = $Task; cause = $Cause; sequence = $seq; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') } | ConvertTo-Json -Compress), $script:ImpUtf8)
    return $seq
}
function Get-GapRoute([string]$ProjectDir) {
    $p = Join-Path $ProjectDir '.team-project/.gap-route'
    if (-not (Test-Path -LiteralPath $p)) { return $null }
    $g = $null; try { $g = Read-ImpText $p | ConvertFrom-Json } catch { return $null }
    $age = 999; try { $age = ((Get-Date) - [datetime]::ParseExact([string]$g.at, 'yyyy-MM-dd HH:mm:ss', $null)).TotalHours } catch { }
    if ($age -ge 6) { return $null }
    return $g
}
function Clear-GapRoute([string]$ProjectDir, [string]$Task = '') {
    $p = Join-Path $ProjectDir '.team-project/.gap-route'
    if (-not (Test-Path -LiteralPath $p)) { return }
    if ($Task) { $g = $null; try { $g = Read-ImpText $p | ConvertFrom-Json } catch { }; if ($g -and [string]$g.task -ne $Task) { return } }
    Remove-Item -LiteralPath $p -Force -ErrorAction SilentlyContinue
}

# O papel (sufixo do agent_type) pelo nome do dono na matriz de propriedade ("PO", "Arquiteto"…) — o hooks/ownership.json → roles
# lido ao contrário. Fonte única do run.ps1 (consolidação dos documentos vivos). '' se não há.
function Get-RoleByOwnerName([string]$Name) {
    $own = Read-ImpText (Join-Path $script:ImpasseLibDir '..\..\hooks\ownership.json') | ConvertFrom-Json
    foreach ($p in $own.roles.PSObject.Properties) { if ([string]$p.Value -eq $Name) { return $p.Name } }
    return ''
}

# v3.66.0 (item G): toda rota que o run.ps1 e o gate.ps1 gravam (Set-AskRoute, lib.ps1) entra no registro da trilha, com o tipo
# da matriz pela rota antiga. Não recusa nada: o run e o portão têm a escada deles (a 2ª queda, o 2º travamento), e a suíte deles
# não muda. A mesma rota com o mesmo motivo, ainda aberta, não ganha linha nova (o next repetido regrava a rota). Devolve o id.
function Register-ImpasseRoute([string]$ProjectDir, [string]$Rota, [string]$Task, [string]$Motivo) {
    $mx = Get-ImpasseMatrix $ProjectDir
    $t = Get-ImpasseType $mx $Rota
    if (-not $t) { return '' }
    $tr = Get-ImpasseTrail $ProjectDir
    $part = if ($Task) { $Task.ToUpperInvariant() } else { $tr.Id }
    $txt = ($Motivo -replace '\s+', ' ').Trim(); if (-not $txt) { $txt = [string]$t.plain }
    $open = @(Get-TeamDecisions $tr.Path | Where-Object { $_.Origin -eq 'run.ps1' -and $_.Result -eq 'escalated' -and $_.Type -eq [string]$t.type -and $_.Part -eq $part -and $_.Text -eq $txt }) | Select-Object -Last 1
    if ($open) { return $open.Id }
    $n = @(Read-ImpasseEvents $tr.Path | Where-Object { [string]$_.event -in 'raise', 'refused' }).Count
    $iid = "$($tr.Id)-I$($n + 1)"
    Add-ImpasseEvent $tr.Path ([ordered]@{ id = $iid; event = 'raise'; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); origin = 'run.ps1'; type = [string]$t.type; part = $part; subject = (ConvertTo-ImpasseSubject $Rota); owner = 'stakeholder'; reaches = [string]$t.reachesStakeholder; text = $txt; consulted = 'run.ps1 next'; route = $Rota })
    return $iid
}

# A rota apagada pelo run.ps1 (start, construir, pausa) fecha os impasses abertos que ele mesmo registrou: a decisão já foi
# aplicada e está no run-log.md da trilha.
function Close-ImpasseRoutes([string]$ProjectDir) {
    $tr = Get-ImpasseTrail $ProjectDir
    if (-not (Test-Path -LiteralPath $tr.Path)) { return }
    $ref = "$($tr.Rel)/run-log.md"
    foreach ($d in @(Get-TeamDecisions $tr.Path | Where-Object { $_.Origin -eq 'run.ps1' -and $_.Result -eq 'escalated' })) {
        Add-ImpasseEvent $tr.Path ([ordered]@{ id = $d.Id; event = 'close'; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); summary = 'respondido; o run seguiu com a decisão'; ref = $ref })
    }
}

# O tipo pelo nome (em inglês) ou pela rota antiga que o run.ps1 e o gate.ps1 gravam (legacyRoutes). $null se não existe.
function Get-ImpasseType($Matrix, [string]$Name) {
    if (-not $Name) { return $null }
    $n = $Name.Trim().ToLowerInvariant()
    foreach ($t in @($Matrix.Types)) { if ([string]$t.type -eq $n) { return $t } }
    foreach ($t in @($Matrix.Types)) { if (@($t.legacyRoutes) -contains $n) { return $t } }
    return $null
}

function Test-ImpasseEscalates($Type) { return ($Type -and [string]$Type.reachesStakeholder -ne 'never') }

# Chave de assunto normalizada: minúsculas, espaço vira hífen, só [a-z0-9/._-].
function ConvertTo-ImpasseSubject([string]$Text) {
    $s = $Text.Trim().ToLowerInvariant()
    $s = $s.Normalize([System.Text.NormalizationForm]::FormD)
    $s = -join ($s.ToCharArray() | Where-Object { [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne [System.Globalization.UnicodeCategory]::NonSpacingMark })
    $s = $s -replace '\s+', '-' -replace '[^a-z0-9/._-]', ''
    return $s.Trim('-')
}

# Onde gravar o caso (item F): o bloco de fix do run ativo ou aberto; senão o sprint aberto; fora dos dois, o sprint em
# preparação (n+1), que a Planning herda. O número corrente vem do README §2 ("Sprint corrente"), nunca da pasta.
function Get-ImpasseTrail([string]$ProjectDir) {
    $tp = Join-Path $ProjectDir '.team-project'
    $ar = $null; $arp = Join-Path $tp '.active-run'
    if (Test-Path -LiteralPath $arp) { try { $ar = Read-ImpText $arp | ConvertFrom-Json } catch { } }
    $block = ''
    if ($ar -and [string]$ar.trilha -eq 'fix' -and [string]$ar.id -match '^B-\d+$') { $block = [string]$ar.id }
    if (-not $block) {
        $fx = Join-Path $tp 'fixes'
        if (Test-Path -LiteralPath $fx) {
            foreach ($d in @(Get-ChildItem -LiteralPath $fx -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^B-\d+$' } | Sort-Object Name -Descending)) {
                $closed = $false
                foreach ($f in 'verdict.md', 'kanban.md') { $fp = Join-Path $d.FullName $f; if ((Test-Path -LiteralPath $fp) -and ((Read-ImpText $fp) -match '(?m)^\*\*Fechado em:\*\*')) { $closed = $true } }
                if (-not $closed) { $block = $d.Name; break }
            }
        }
    }
    if ($block) {
        $dir = Join-Path $tp "fixes/$block"
        return [pscustomobject]@{ Kind = 'fix'; Id = $block; Sprint = ''; Dir = $dir; Rel = ".team-project/fixes/$block"; Path = (Join-Path $dir 'team-decisions.jsonl'); Kanban = (Join-Path $dir 'kanban.md') }
    }
    $n = 0
    $rd = Join-Path $tp 'README.md'
    if (Test-Path -LiteralPath $rd) {
        $m = [regex]::Match((Read-ImpText $rd), '(?im)^\|\s*\*{0,2}Sprint corrente\*{0,2}\s*\|\s*(?:\*\*)?\s*(?:sprint\s*)?(?:\*\*)?\s*(\d+)')
        if ($m.Success) { $n = [int]$m.Groups[1].Value }
    }
    $open = $false
    if ($n -gt 0) {
        $S = Join-Path $tp "sprints/$n"
        # aberto = o quadro existe (kanban.md desde a v3.51; burndown.md ou só o sprint-backlog.md antes) e não há retrospectiva
        $open = (@('kanban.md', 'burndown.md', 'sprint-backlog.md') | Where-Object { Test-Path -LiteralPath (Join-Path $S $_) }).Count -gt 0 -and -not (Test-Path -LiteralPath (Join-Path $S 'retrospective.md'))
    }
    $k = if ($open) { $n } else { $n + 1 }
    $dir = Join-Path $tp "sprints/$k"
    return [pscustomobject]@{ Kind = 'sprint'; Id = "S$k"; Sprint = "$k"; Dir = $dir; Rel = ".team-project/sprints/$k"; Path = (Join-Path $dir 'team-decisions.jsonl'); Kanban = (Join-Path $dir 'kanban.md'); Preparing = (-not $open) }
}

# O arquivo da trilha pelo id do impasse: "S7-I3" → sprints/7; "B-002-I1" → fixes/B-002.
function Get-ImpasseTrailById([string]$ProjectDir, [string]$Id) {
    $tp = Join-Path $ProjectDir '.team-project'
    if ($Id -match '^S(\d+)-I\d+$') { $d = Join-Path $tp "sprints/$($Matches[1])"; return [pscustomobject]@{ Kind = 'sprint'; Id = "S$($Matches[1])"; Sprint = $Matches[1]; Dir = $d; Rel = ".team-project/sprints/$($Matches[1])"; Path = (Join-Path $d 'team-decisions.jsonl'); Kanban = (Join-Path $d 'kanban.md') } }
    if ($Id -match '^(B-\d+)-I\d+$') { $d = Join-Path $tp "fixes/$($Matches[1])"; return [pscustomobject]@{ Kind = 'fix'; Id = $Matches[1]; Sprint = ''; Dir = $d; Rel = ".team-project/fixes/$($Matches[1])"; Path = (Join-Path $d 'team-decisions.jsonl'); Kanban = (Join-Path $d 'kanban.md') } }
    return $null
}

# Eventos crus de um team-decisions.jsonl (linha ilegível é ignorada).
function Read-ImpasseEvents([string]$Path) {
    if (-not $Path -or -not (Test-Path -LiteralPath $Path)) { return @() }
    $o = @()
    foreach ($l in [System.IO.File]::ReadAllLines($Path, $script:ImpUtf8)) { if ($l.Trim()) { try { $o += ($l | ConvertFrom-Json) } catch { } } }
    return $o
}

# Acrescenta um evento (uma linha JSON). Cria a pasta da trilha se faltar (o sprint em preparação só ganha este arquivo).
function Add-ImpasseEvent([string]$Path, $Event) {
    $d = Split-Path $Path; if (-not (Test-Path -LiteralPath $d)) { New-Item -ItemType Directory -Force $d | Out-Null }
    $line = ($Event | ConvertTo-Json -Compress -Depth 5) + "`n"
    for ($i = 0; $i -lt 10; $i++) { try { [System.IO.File]::AppendAllText($Path, $line, $script:ImpUtf8); return } catch { Start-Sleep -Milliseconds 100 } }
    [System.IO.File]::AppendAllText($Path, $line, $script:ImpUtf8)
}

# O estado de cada impasse: o raise, com o close (o mais recente) por cima. Recusas ("refused") entram como item próprio.
function Get-TeamDecisions([string]$Path) {
    $ev = @(Read-ImpasseEvents $Path)
    $by = [ordered]@{}
    foreach ($e in $ev) {
        $id = [string]$e.id; if (-not $id) { continue }
        if ([string]$e.event -eq 'raise' -or [string]$e.event -eq 'refused') { $by[$id] = [pscustomobject]@{ Raise = $e; Close = $null } }
        elseif ([string]$e.event -eq 'close' -and $by.Contains($id)) { $by[$id].Close = $e }
    }
    $o = @()
    foreach ($k in $by.Keys) {
        $r = $by[$k].Raise; $c = $by[$k].Close
        $res = if ([string]$r.event -eq 'refused') { 'refused-already-decided' }
            elseif ($c) { if ([string]$r.reaches -eq 'never') { 'team-resolved' } else { 'decided-by-stakeholder' } }
            else { if ([string]$r.reaches -eq 'never') { 'routed' } else { 'escalated' } }
        $o += [pscustomobject]@{ Id = $k; At = [string]$r.at; Type = [string]$r.type; Part = [string]$r.part; Subject = [string]$r.subject; Owner = [string]$r.owner; Reaches = [string]$r.reaches; Text = [string]$r.text; Origin = [string]$r.origin; From = [string]$r.from; Result = $res; Summary = $(if ($c) { [string]$c.summary } else { '' }); Ref = $(if ($c) { [string]$c.ref } else { [string]$r.ref }); ClosedAt = $(if ($c) { [string]$c.at } else { '' }) }
    }
    return $o
}

# Todos os team-decisions.jsonl do projeto (sprints e blocos), o mais recente primeiro.
function Get-AllTeamDecisionFiles([string]$ProjectDir) {
    $tp = Join-Path $ProjectDir '.team-project'
    $o = @()
    foreach ($sub in 'sprints', 'fixes') {
        $d = Join-Path $tp $sub
        if (Test-Path -LiteralPath $d) { $o += @(Get-ChildItem -LiteralPath $d -Recurse -Filter 'team-decisions.jsonl' -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | ForEach-Object { $_.FullName }) }
    }
    return $o
}

# A decisão que já existe para a parte e o assunto: no registro de qualquer trilha (impasse fechado ou ainda aberto) e,
# na §7 do README, a linha [RESOLVIDO …] com a marca {subject: <chave>}. $null se não há.
function Find-ImpasseDecision([string]$ProjectDir, [string]$Part, [string]$Subject) {
    $P = $Part.Trim().ToUpperInvariant(); $Sj = ConvertTo-ImpasseSubject $Subject
    foreach ($f in @(Get-AllTeamDecisionFiles $ProjectDir)) {
        $hit = @(Get-TeamDecisions $f | Where-Object { $_.Part.ToUpperInvariant() -eq $P -and $_.Subject -eq $Sj -and $_.Result -ne 'refused-already-decided' }) | Select-Object -Last 1
        if ($hit) { return [pscustomobject]@{ Source = 'registro'; Id = $hit.Id; Open = ($hit.Result -in 'routed', 'escalated'); Owner = $hit.Owner; Summary = $hit.Summary; Ref = $hit.Ref; At = $(if ($hit.ClosedAt) { $hit.ClosedAt } else { $hit.At }) } }
    }
    $rd = Join-Path $ProjectDir '.team-project/README.md'
    if (Test-Path -LiteralPath $rd) {
        $sec = [regex]::Match((Read-ImpText $rd), '(?ms)^##\s+7\.\s.*?(?=^##\s|\z)')
        if ($sec.Success) {
            foreach ($l in ($sec.Value -split "`r?`n")) {
                $sm = [regex]::Match($l, '\{subject:\s*([^}]+)\}')
                if (-not $sm.Success -or (ConvertTo-ImpasseSubject $sm.Groups[1].Value) -ne $Sj) { continue }
                if ($l -notmatch '(?i)RESOLVID') { continue }
                $nm = [regex]::Match($l, '^\s*(\d+)\.'); $txt = ($l -replace '\s+', ' ').Trim(); if ($txt.Length -gt 200) { $txt = $txt.Substring(0, 200) + '…' }
                return [pscustomobject]@{ Source = 'readme'; Id = $(if ($nm.Success) { "§7 $($nm.Groups[1].Value)" } else { '§7' }); Open = $false; Owner = 'stakeholder'; Summary = $txt; Ref = ".team-project/README.md §7$(if ($nm.Success) { ' ' + $nm.Groups[1].Value })"; At = '' }
            }
        }
    }
    return $null
}

# Os assuntos já registrados para a parte (para o raise mostrar e exigir -Distinct num assunto novo).
function Get-ImpasseSubjects([string]$ProjectDir, [string]$Part) {
    $P = $Part.Trim().ToUpperInvariant(); $o = @()
    foreach ($f in @(Get-AllTeamDecisionFiles $ProjectDir)) { $o += @(Get-TeamDecisions $f | Where-Object { $_.Part.ToUpperInvariant() -eq $P -and $_.Result -ne 'refused-already-decided' } | ForEach-Object { $_.Subject }) }
    return @($o | Select-Object -Unique)
}

# A regra do hooks/ownership.json que casa o caminho (a primeira, como na G8) — fonte única da G8 e do impasse.ps1 owner.
# @{ Rule; Roles; Writers (nomes); Owner } ou $null. Usa o Test-GlobMatch do hooks/common.ps1.
function Find-OwnershipRule([string]$Rel, [switch]$PluginSource) {
    $own = Read-ImpText (Join-Path $script:ImpasseLibDir '..\..\hooks\ownership.json') | ConvertFrom-Json
    $rules = if ($PluginSource) { $own.pluginSource } else { $own.project }
    $r = ($Rel -replace '\\', '/').TrimStart('/')
    foreach ($rule in @($rules)) {
        if (-not (Test-GlobMatch $r @($rule.paths))) { continue }
        $names = @(@($rule.writers) | ForEach-Object { [string]$own.roles.$_ })
        return [pscustomobject]@{ Rule = $rule; Roles = $own.roles; Writers = @($rule.writers); WriterNames = $names; Owner = [string]$rule.dono }
    }
    return $null
}

# v3.66.0 (item J, R34): em projeto com Identificador remoto, o impasse que sobe grava a pendência DENTRO da §7 do README —
# "N. [<ID> · <trilha> · <parte>] <pergunta> {subject: <chave>} — material: … — aaaa-mm-dd hh:mm" —, de onde a G3 confere o
# prefixo. No sprint 7 do projeto piloto, as pendências caíram depois da §8 e a G3 recusou o formulário quatro vezes.
# @{ N; Prefix } ou $null (projeto sem Identificador remoto, ou README sem §7).
function Add-ImpassePending([string]$ProjectDir, [string]$TrailId, [string]$Part, [string]$Text, [string]$Subject, [string]$Material) {
    $rd = Join-Path $ProjectDir '.team-project/README.md'
    if (-not (Test-Path -LiteralPath $rd)) { return $null }
    $t = Read-ImpText $rd
    $im = [regex]::Match($t, '(?m)^\*\*Identificador remoto:\*\*\s*([A-Z]{3,8})\b')
    if (-not $im.Success) { return $null }
    $sec = [regex]::Match($t, '(?ms)^##\s+7\.\s.*?(?=^##\s|\z)')
    if (-not $sec.Success) { return $null }
    $nl = if ($t.Contains("`r`n")) { "`r`n" } else { "`n" }
    $nums = @([regex]::Matches($sec.Value, '(?m)^\s*(\d+)\.') | ForEach-Object { [int]$_.Groups[1].Value })
    $n = 1 + $(if ($nums.Count) { ($nums | Measure-Object -Maximum).Maximum } else { 0 })
    $prefix = "[$($im.Groups[1].Value) · $TrailId · $Part]"
    $line = "$n. $prefix $(($Text -replace '\s+', ' ').Trim()) {subject: $Subject} — material: $(($Material -replace '\s+', ' ').Trim()) — $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    $body = $sec.Value.TrimEnd()
    $new = $t.Substring(0, $sec.Index) + $body + $nl + $line + $nl + $nl + $t.Substring($sec.Index + $sec.Length)
    [System.IO.File]::WriteAllText($rd, $new, $script:ImpUtf8)
    return [pscustomobject]@{ N = $n; Prefix = $prefix }
}

# Respondido o impasse, a pendência N da §7 ganha "[RESOLVIDO em aaaa-mm-dd — <a decisão>]" (o registro do caso; o
# Find-ImpasseDecision a lê pelo {subject: …}). $false se a linha não existe.
function Set-ImpassePendingResolved([string]$ProjectDir, [int]$N, [string]$Summary) {
    $rd = Join-Path $ProjectDir '.team-project/README.md'
    if (-not (Test-Path -LiteralPath $rd)) { return $false }
    $t = Read-ImpText $rd
    $sec = [regex]::Match($t, '(?ms)^##\s+7\.\s.*?(?=^##\s|\z)')
    if (-not $sec.Success) { return $false }
    $lm = [regex]::Match($sec.Value, "(?m)^(\s*$N\.\s+)(?!\*{0,2}\[RESOLVID)")
    if (-not $lm.Success) { return $false }
    $at = $sec.Index + $lm.Index + $lm.Groups[1].Length
    $s = ($Summary -replace '\s+', ' ').Trim()
    $new = $t.Substring(0, $at) + "[RESOLVIDO em $(Get-Date -Format 'yyyy-MM-dd') — $s] " + $t.Substring($at)
    [System.IO.File]::WriteAllText($rd, $new, $script:ImpUtf8)
    return $true
}

# Quem decide, em palavras de quem acompanha.
function Get-ImpasseOwnerName([string]$Owner) {
    switch ($Owner) {
        'stakeholder' { 'você' } 'routine' { 'o roteiro (o próprio time executa)' } 'file-owner' { 'o dono do arquivo' }
        'architect' { 'Arquiteto' } 'user-experience' { 'Designer (UX)' } 'product-owner' { 'Dono do produto (PO)' }
        'quality-assurance' { 'Qualidade (QA)' } 'scrum-master' { 'Scrum Master' } 'operator' { 'Operador de testes' }
        'developer' { 'Desenvolvedor' } 'security-engineer' { 'Segurança' } default { $Owner }
    }
}

function Format-ImpasseCell([string]$Text, [int]$Max = 160) {
    $t = ($Text -replace '\|', '/' -replace '\s+', ' ').Trim()
    if ($t.Length -gt $Max) { $t = $t.Substring(0, $Max - 1) + '…' }
    return $t
}

# A tabela "Decisões do time" (kanban do sprint e do bloco; Review) a partir do registro da trilha. Linguagem de quem
# acompanha (v3.59.0): o tipo em palavras, o código da parte no fim, entre parênteses.
function Format-TeamDecisionsTable($Items, $Matrix, [string]$Nl) {
    $rows = @('| Quando | O que foi decidido | Quem decidiu | Por que não precisou de você | Onde está |', '|---|---|---|---|---|')
    foreach ($d in @($Items | Sort-Object At)) {
        $t = Get-ImpasseType $Matrix $d.Type
        $plain = if ($t -and $t.plain) { [string]$t.plain } else { $d.Type }
        $when = try { ([datetime]$d.At).ToString('dd/MM HH:mm') } catch { $d.At }
        switch ($d.Result) {
            'team-resolved' { $what = $d.Summary; $who = Get-ImpasseOwnerName $d.Owner; $why = $plain }
            'routed' { $what = "em andamento: $($d.Text)"; $who = Get-ImpasseOwnerName $d.Owner; $why = $plain }
            'refused-already-decided' { $what = "não perguntou de novo: $($d.Text)"; $who = 'o time'; $why = "já decidido$(if ($d.Ref) { " ($($d.Ref))" })" }
            'escalated' { $what = "esperando você: $($d.Text)"; $who = 'você'; $why = "subiu a você: $plain" }
            default { $what = $d.Summary; $who = 'você'; $why = "subiu a você: $plain" }
        }
        $where = if ($d.Ref) { "$($d.Ref) ($($d.Part))" } else { "($($d.Part))" }
        $rows += "| $when | $(Format-ImpasseCell $what) | $(Format-ImpasseCell $who 40) | $(Format-ImpasseCell $why 90) | $(Format-ImpasseCell $where 90) |"
    }
    return ($rows -join $Nl)
}

# Contagem para o Resumo do kanban e o /team-status: o que o time decidiu sozinho e o que subiu.
function Get-TeamDecisionCounts([string]$Path) {
    $all = @(Get-TeamDecisions $Path)
    return [pscustomobject]@{
        Team = @($all | Where-Object { $_.Result -eq 'team-resolved' }).Count
        Routed = @($all | Where-Object { $_.Result -eq 'routed' }).Count
        Up = @($all | Where-Object { $_.Result -in 'escalated', 'decided-by-stakeholder' }).Count
        Refused = @($all | Where-Object { $_.Result -eq 'refused-already-decided' }).Count
        Total = $all.Count
    }
}

# Troca (ou insere no fim da "## <Parent>") a subseção "### <Heading>". Sem a "## <Parent>", cria as duas no fim.
function Set-ImpasseSubSection([string]$Text, [string]$Parent, [string]$Heading, [string]$Body, [string]$Nl) {
    $block = "### $Heading$Nl$Body$Nl$Nl"
    $sub = [regex]::Match($Text, '(?ms)^###\s+' + [regex]::Escape($Heading) + '\s*\r?\n.*?(?=^###?\s|\z)')
    if ($sub.Success) { return $Text.Substring(0, $sub.Index) + $block + $Text.Substring($sub.Index + $sub.Length) }
    $par = [regex]::Match($Text, '(?ms)^##\s+' + [regex]::Escape($Parent) + '[^\r\n]*\r?\n.*?(?=^##\s|\z)')
    if ($par.Success) {
        $end = $par.Index + $par.Length
        $head = $Text.Substring(0, $end).TrimEnd() + $Nl + $Nl
        return $head + $block + $Text.Substring($end)
    }
    return $Text.TrimEnd() + $Nl + $Nl + "## $Parent$Nl$Nl" + $block
}

$script:TeamDecisionsIntro = '> Gerada pelo `kanban.ps1` a partir do registro da trilha (`team-decisions.jsonl`) a cada impasse aberto ou fechado — não editar à mão. O que o time resolveu sem você, o que subiu a você e por quê; qualquer linha pode ser revertida (a reversão volta como "contradiz uma decisão aceita").'

# A subseção "### Decisões do time" do kanban.md do sprint (dentro do "## Controle"). Sem registro, a tabela vazia com a nota.
function Update-TeamDecisionsInText([string]$Text, [string]$JsonlPath, $Matrix, [string]$Nl) {
    $items = @(Get-TeamDecisions $JsonlPath)
    $body = $script:TeamDecisionsIntro + $Nl + $Nl + $(if ($items.Count) { Format-TeamDecisionsTable $items $Matrix $Nl } else { '*(nenhum impasse registrado nesta trilha)*' })
    return (Set-ImpasseSubSection $Text 'Controle' 'Decisões do time' $body $Nl)
}

# Frase do Resumo: "o time decidiu N coisas sozinho; M subiram a você". '' sem registro.
function Get-TeamDecisionsLine([string]$JsonlPath) {
    if (-not $JsonlPath -or -not (Test-Path -LiteralPath $JsonlPath)) { return '' }
    $c = Get-TeamDecisionCounts $JsonlPath
    if (-not $c.Total) { return '' }
    $p = @("o time decidiu $($c.Team) $(if ($c.Team -eq 1) { 'coisa' } else { 'coisas' }) sozinho")
    if ($c.Routed) { $p += "$($c.Routed) em andamento com o dono" }
    $p += "$($c.Up) $(if ($c.Up -eq 1) { 'subiu' } else { 'subiram' }) a você"
    if ($c.Refused) { $p += "$($c.Refused) não $(if ($c.Refused -eq 1) { 'foi perguntada' } else { 'foram perguntadas' }) de novo por já estar decidida" }
    return (($p -join '; ') + ' (quadro, seção Decisões do time).')
}

# G26: a fala termina oferecendo uma ação do roteiro ("Quer que eu…?", "Posso…?")? Olha as 4 últimas linhas com texto, fora
# de bloco de código e de citação, contra hooks/impasses.json → offerPhrases. Devolve a linha que casou, ou ''.
function Find-OfferPhrase([string]$Text, [string[]]$Phrases) {
    if (-not $Text) { return '' }
    $t = [regex]::Replace($Text, '(?s)```.*?```', '')
    $lines = @($t -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -and $_ -notmatch '^>' })
    foreach ($l in @($lines | Select-Object -Last 4)) {
        $c = $l -replace '^[-*\d.\s]+', '' -replace '\*\*', ''
        foreach ($p in @($Phrases)) { if ($p -and [regex]::IsMatch($c, $p, 'IgnoreCase')) { return $l } }
    }
    return ''
}

# A frase citada pelo stakeholder está numa fala dele na sessão? (G24, tipo stakeholder-request.) Compara sem caixa, acento
# nem espaço repetido; ignora o texto que o próprio comando de barra injeta (skill expandida) e os resultados de ferramenta.
function Test-ImpasseQuoteInTranscript([string]$TranscriptPath, [string]$Quote) {
    if (-not $Quote -or $Quote.Trim().Length -lt 8 -or -not $TranscriptPath -or -not (Test-Path -LiteralPath $TranscriptPath)) { return $false }
    $norm = { param($s) $x = ([string]$s).ToLowerInvariant().Normalize([System.Text.NormalizationForm]::FormD); $x = -join ($x.ToCharArray() | Where-Object { [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne [System.Globalization.UnicodeCategory]::NonSpacingMark }); ($x -replace '\s+', ' ').Trim() }
    $q = & $norm $Quote
    foreach ($l in [System.IO.File]::ReadAllLines($TranscriptPath, $script:ImpUtf8)) {
        if ($l -notmatch '"type"\s*:\s*"user"') { continue }
        $o = $null; try { $o = $l | ConvertFrom-Json } catch { continue }
        if ([string]$o.type -ne 'user' -or $o.isMeta -eq $true -or -not $o.message) { continue }
        $c = $o.message.content
        $texts = @()
        if ($c -is [string]) { $texts += $c } else { foreach ($p in @($c)) { if ([string]$p.type -eq 'text') { $texts += [string]$p.text } } }
        foreach ($t in $texts) {
            if ($t -match '^\s*<(command-|local-command|system-reminder|task-notification)') { continue }
            if ((& $norm $t).Contains($q)) { return $true }
        }
    }
    return $false
}
