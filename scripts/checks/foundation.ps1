# Sprint 0 — a fundação (v3.61.0 · R35). Antes do primeiro sprint funcional, o sistema fica documentado COMO É, nos modelos do
# SDD (deliverables/sdd/), e o ambiente de testes fica provado: comandos de verificação no guards.json, serviços no ar, baseline
# do QA e um cenário ponta a ponta rodado no alvo. O backlog funcional só abre depois do aceite do stakeholder (G25 · C2 R35).
# O sprint 0 não refatora: má prática achada vira dívida no backlog (o Arquiteto a registra em 03 §0.1; o PO a prioriza).
#
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/foundation.ps1" <ação> [opções] [-Root <projeto>]
#   assess                              classifica cada fonte (SDD 00–06 e ambiente): ausente · fora do padrão · conforme
#   init                                cria sprints/0/foundation.md com um item por fonte a criar ou revisar; README §2 → exigido
#   approve -Areas "A, B" -By <quem> [-Decision <texto>]   grava o escopo do formulário único (áreas da 1ª onda)
#   next                                transições do quadro e a próxima ação (o papel a disparar, com o prompt)
#   check [-Item S0-nn]                 a régua (só a do item, com -Item) — tabela regra · resultado · linha decisiva
#   area -Add "<área>" -By <quem>       reabre o sprint 0 para uma área que o backlog vai tocar e ainda não está documentada
#   close -By <quem> [-Decision <texto>]   aceite do stakeholder na review: Estado concluído e README §2
#   dispense -By <quem> -Because <motivo>  o stakeholder dispensa o sprint 0 (risco aceito): README §2 → dispensado
#   gate                                o sprint funcional pode abrir? (lido pela G25 e pelo C2)
# Exit: 0 · 1 = a régua ou o portão reprovou · 2 = erro de uso ou de leitura (nada gravado).

param(
    [Parameter(Position = 0)][string]$Action = '',
    [string]$Item = '',
    [string]$Areas = '',
    [string]$Add = '',
    [string]$By = '',
    [string]$Decision = '',
    [string]$Because = '',
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
if (Test-Path -LiteralPath $Root) { $Root = (Get-Item -LiteralPath $Root).FullName.TrimEnd('\', '/') }   # nome longo: o FullName do Get-ChildItem vem expandido

$script:Todo = [char]::ConvertFromUtf32(0x2B1C); $script:Red = [char]::ConvertFromUtf32(0x1F534)
$script:Marks = @($script:Todo, $E.Plan, $E.Build, $E.QA, $E.Done, $script:Red)
$script:RowLabel = 'Sprint 0 (fundação)'
$script:Utf8 = New-Object System.Text.UTF8Encoding($false)
$script:MaxReturns = 3   # devoluções do mesmo item antes do 🔴 (degrau 1: PO + Arquiteto; depois, o stakeholder)

# Os sete documentos do SDD: prefixo, palavra do nome, dono, frente, título, régua.
$script:Docs = @(
    @{ N = '00'; Stem = '(?i)overview|vis[aã]o|objetiv'; Owner = 'PO'; Front = 'funcional'; Title = 'Visão geral e objetivos (00)'; Rule = 'SDD-00'; Model = '00-overview-objectives.md' }
    @{ N = '01'; Stem = '(?i)requirement|requisit'; Owner = 'PO'; Front = 'funcional'; Title = 'Requisitos com critério de aceite verificável (01)'; Rule = 'SDD-01'; Model = '01-requirements.md' }
    @{ N = '02'; Stem = '(?i)flow|fluxo|pap[eé]is|roles'; Owner = 'PO'; Front = 'funcional'; Title = 'Modelo conceitual, papéis e fluxos (02)'; Rule = 'SDD-02'; Model = '02-flows-and-roles.md' }
    @{ N = '03'; Stem = '(?i)architect|arquitet'; Owner = 'Arquiteto'; Front = 'técnica'; Title = 'Arquitetura com Ficha de Vinculação de Stack (03)'; Rule = 'SDD-03'; Model = '03-architecture.md' }
    @{ N = '04'; Stem = '(?i)data|dados'; Owner = 'Arquiteto'; Front = 'técnica'; Title = 'Modelo de dados (04)'; Rule = 'SDD-04'; Model = '04-data-model.md' }
    @{ N = '05'; Stem = '(?i)api|contrat|interface'; Owner = 'Arquiteto'; Front = 'técnica'; Title = 'Modelo de API e contratos (05)'; Rule = 'SDD-05'; Model = '05-api-model.md' }
    @{ N = '06'; Stem = '(?i)changelog|hist[oó]ric|mudan'; Owner = 'PO'; Front = 'funcional'; Title = 'Índice do SDD e changelog com a versão documentada (06)'; Rule = 'SDD-06'; Model = '06-changelog.md' }
)
$script:EnvItems = @(
    @{ Rule = 'AMB-verify'; Title = 'Comandos de verificação (build, testes, lint) e serviços do ambiente'; Owner = 'dev'; Front = 'ambiente'; Est = '1' }
    @{ Rule = 'AMB-baseline'; Title = 'Linha de base do QA (/qa baseline) com os comandos do ambiente'; Owner = 'QA'; Front = 'prova'; Est = '0,5' }
    @{ Rule = 'AMB-cenário'; Title = 'Suíte inicial de cenários e um cenário ponta a ponta rodado no alvo'; Owner = 'QA'; Front = 'prova'; Est = '0,5' }
)
$script:RoleAgent = @{ 'PO' = 'product-owner'; 'Arquiteto' = 'architect'; 'dev' = 'developer'; 'QA' = 'quality-assurance' }

function Fail([string]$Msg) { [Console]::Error.WriteLine("foundation: $Msg"); exit 2 }
function Out([string]$Text) { [Console]::Out.WriteLine($Text) }
function Today { (Get-Date).ToString('yyyy-MM-dd') }
function Now { (Get-Date).ToString('yyyy-MM-dd HH:mm') }
function Write-Utf8([string]$Path, [string]$Text) {
    New-Item -ItemType Directory -Force (Split-Path $Path) | Out-Null
    [System.IO.File]::WriteAllText($Path, $Text, $script:Utf8)
}

$script:Tp = Join-Path $Root '.team-project'
$script:ReadmePath = Join-Path $script:Tp 'README.md'
$script:S0 = Join-Path $script:Tp 'sprints/0'
$script:BoardPath = Join-Path $script:S0 'foundation.md'
$script:ConfPath = Join-Path $script:S0 'evidence/conformance.md'

# ---------------- leitura ----------------

function Get-ProductRel {
    if (-not (Test-Path -LiteralPath $script:ReadmePath)) { return 'docs/' }
    $m = [regex]::Match((Read-Text $script:ReadmePath), '\*\*Diretório de produto:\*\*\s*`?([^`\s]+)`?')
    if ($m.Success -and $m.Groups[1].Value -notmatch '<') { return ($m.Groups[1].Value.TrimEnd('/') + '/') }
    return 'docs/'
}

function Get-BoardText { if (Test-Path -LiteralPath $script:BoardPath) { return (Read-Text $script:BoardPath) } return $null }

function Get-BoardField([string]$Board, [string]$Label) {
    if (-not $Board) { return '' }
    $v = Get-LabelValue $Board $Label
    if ($null -eq $v) { return '' }
    return (Clean-Cell $v)
}

# O diretório do SDD: o que o quadro declara; senão, a pasta do produto com mais documentos 0n-<nome do SDD>.md.
function Get-SddRel {
    $b = Get-BoardText
    $d = Get-BoardField $b 'Diretório do SDD'
    if ($d -and -not (Test-Placeholder $d)) { return ($d.TrimEnd('/') + '/') }
    $prod = Get-ProductRel
    $pfull = Join-Path $Root $prod
    if (Test-Path -LiteralPath $pfull) {
        $best = $null; $bestN = 0
        # Pasta candidata: a que tem 0n-<nome>.md ou se chama sdd; vence a com mais documentos do SDD (numerados ou pelo nome).
        $groups = @(Get-ChildItem -LiteralPath $pfull -Recurse -File -Filter '*.md' -ErrorAction SilentlyContinue | Where-Object {
            $f = $_; ($f.Directory.Name -ieq 'sdd' -or $f.Name -match '^0[0-6]-') -and @($script:Docs | Where-Object { $f.BaseName -match $_.Stem }).Count -gt 0
        } | Group-Object DirectoryName)
        foreach ($g in $groups) { if ($g.Count -gt $bestN) { $best = $g.Name; $bestN = $g.Count } }
        if ($best) {
            $rel = $best.Substring($Root.Length + 1) -replace '\\', '/'
            return ($rel.TrimEnd('/') + '/')
        }
    }
    return ($prod + 'sdd/')
}

# O documento do SDD: 0n-<nome>.md (o modelo); senão, o que o projeto já tem com o nome do assunto (requirements.md,
# architecture.md, api-spec.md — o garden nasceu assim): ele é revisado onde está, sem renomear (links e scripts apontam
# para ele). Sem nenhum dos dois, o caminho do modelo, a criar.
function Get-DocPath([hashtable]$Doc, [string]$SddRel) {
    $dir = Join-Path $Root $SddRel
    if (Test-Path -LiteralPath $dir) {
        $all = @(Get-ChildItem -LiteralPath $dir -File -Filter '*.md' -ErrorAction SilentlyContinue | Sort-Object Name)
        $f = @($all | Where-Object { $_.Name -like "$($Doc.N)-*" -and $_.Name -match $Doc.Stem } | Select-Object -First 1)
        if (-not $f.Count) { $f = @($all | Where-Object { $_.Name -notmatch '^(0\d-|readme)' -and $_.BaseName -match $Doc.Stem } | Select-Object -First 1) }
        if ($f.Count) { return ($SddRel + $f[0].Name) }
    }
    return ($SddRel + $Doc.Model)
}

# Texto sem blocos de código, código em linha e comentários HTML — o que sobra é prosa e tabela.
function Get-Prose([string]$Text) {
    $t = [regex]::Replace($Text, '(?ms)^\s*```.*?^\s*```[^\r\n]*', '')
    $t = [regex]::Replace($t, '(?s)<!--.*?-->', '')
    return [regex]::Replace($t, '`[^`\r\n]*`', '``')
}

function Get-Placeholders([string]$Text) {
    $hits = @(); $n = 0
    foreach ($l in ((Get-Prose $Text) -split "`r?`n")) {
        $n++
        $m = [regex]::Match($l, '<[^<>\r\n]*\s[^<>\r\n]*>')
        if ($m.Success -and $m.Value -notmatch '^<(a|img|br|div|span|p|td|tr|table|sup|sub|details|summary)\b') { $hits += "linha ${n}: $($m.Value)" }
    }
    return $hits
}

# Seções cujo título começa pelo ID (### RF-001 — …): Id, Title e Body até o próximo título de nível igual ou acima.
function Get-IdSections([string]$Text, [string]$IdRe) {
    $out = @(); $lines = $Text -split "`r?`n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $m = [regex]::Match($lines[$i], '^(#{1,6})\s+(' + $IdRe + ')\b(.*)$')
        if (-not $m.Success) { continue }
        $lvl = $m.Groups[1].Value.Length; $buf = New-Object System.Collections.ArrayList
        for ($j = $i + 1; $j -lt $lines.Count; $j++) {
            $h = [regex]::Match($lines[$j], '^(#{1,6})\s'); if ($h.Success -and $h.Groups[1].Value.Length -le $lvl) { break }
            [void]$buf.Add($lines[$j])
        }
        $out += [pscustomobject]@{ Id = $m.Groups[2].Value; Title = $m.Groups[3].Value; Body = ($buf -join "`n") }
    }
    return $out
}

function Get-Areas([string]$Board) {
    $a = @()
    foreach ($label in 'Áreas em documentação', 'Áreas documentadas') {
        $v = Get-BoardField $Board $label
        if (-not $v -or (Test-Placeholder $v) -or $v -match '(?i)^nenhuma') { continue }
        $a += @($v -split '[,;]' | ForEach-Object { ($_ -replace '\(.*?\)', '').Trim() } | Where-Object { $_ })
    }
    return @($a | Select-Object -Unique)
}

# ---------------- régua ----------------
# Cada regra devolve @{ Status = ok|falhou|n-a; Line = …; Missing = $true quando o arquivo não existe }.

function Test-DocRule([hashtable]$Doc, [string]$SddRel, [string[]]$AreaList) {
    $rel = Get-DocPath $Doc $SddRel; $full = Join-Path $Root $rel
    if (-not (Test-Path -LiteralPath $full)) { return @{ Status = 'falhou'; Line = "$rel ausente (modelo: deliverables/sdd/$($Doc.Model))"; Missing = $true; File = $rel } }
    $t = Read-Text $full; $p = Get-Prose $t; $iss = @()
    switch ($Doc.N) {
        '00' {
            $obj = @(Get-IdSections $t 'OBJ-[A-Z0-9]+(?:-[A-Z0-9]+)*')
            if (-not $obj.Count) { $iss += 'nenhum objetivo OBJ-nnn' }
            foreach ($o in $obj) { if ($o.Body -notmatch '(?i)como saberemos') { $iss += "$($o.Id) sem 'Como saberemos que foi atingido'" } }
        }
        '01' {
            # ID com área também vale (RF-CAN-01, no garden); o modelo pede uma seção por requisito.
            $rfRe = 'RF-[A-Z0-9]+(?:-[A-Z0-9]+)*[a-z]?'
            $rf = @(Get-IdSections $t $rfRe | Where-Object { $_.Title -notmatch '(?i)descontinuad' })
            if (-not $rf.Count) {
                $inline = @([regex]::Matches($p, '\b' + $rfRe + '\b') | ForEach-Object { $_.Value } | Select-Object -Unique)
                if ($inline.Count) { $iss += "$($inline.Count) requisito(s) em lista ($($inline[0])…), sem seção própria (### $($inline[0]) — …) com critério de aceite e 'Como verificar'" }
                else { $iss += 'nenhum requisito RF-nnn' }
            }
            foreach ($r in $rf) {
                if ($r.Body -notmatch '(?i)crit[ée]rios?\s+de\s+aceite') { $iss += "$($r.Id) sem critério de aceite" }
                if ($r.Body -notmatch '(?i)como verificar') { $iss += "$($r.Id) sem 'Como verificar'" }
            }
            foreach ($r in @(Get-IdSections $t 'RNF-[A-Z0-9]+(?:-[A-Z0-9]+)*[a-z]?' | Where-Object { $_.Title -notmatch '(?i)descontinuad' })) {
                if ($r.Body -notmatch '(?i)como verificar') { $iss += "$($r.Id) sem 'Como verificar'" }
            }
        }
        '02' {
            if ($p -notmatch '(?i)\*\*Responsabilidade:\*\*') { $iss += "nenhum papel com '**Responsabilidade:**'" }
            if ($p -notmatch '(?im)^#{1,4}\s+.*fluxo') { $iss += 'nenhum fluxo (título com "Fluxo")' }
            if ($p -notmatch '(?i)pontos de falha') { $iss += "nenhum fluxo com 'Pontos de falha e retomada'" }
        }
        '03' {
            if ($p -notmatch '(?im)^#{1,4}\s+.*[íi]ndice') { $iss += 'sem índice' }
            $ficha = Get-Section $t '(?i)^#{1,4}\s+.*Ficha de Vincula'
            if (-not $ficha) { $iss += 'sem a Ficha de Vinculação de Stack (§2b)' }
            else {
                $rows = @{}
                foreach ($tb in (Get-Tables $ficha)) { foreach ($row in $tb.Rows) { $id = Clean-Cell $row[0]; if ($id -match '^V(\d+)$') { $rows[[int]$Matches[1]] = $row } } }
                $miss = @(); $blank = @()
                for ($v = 1; $v -le 22; $v++) {
                    if (-not $rows.ContainsKey($v)) { $miss += "V$v"; continue }
                    $last = @($rows[$v] | Where-Object { $_ -ne '' }); $val = if ($last.Count) { $last[-1] } else { '' }
                    $bare = ([regex]::Replace($val, '`[^`]*`', 'x') -replace '\*\*', '').Trim()   # código entre crases não é marcador (<commit-base> no V12 do garden)
                    if ($last.Count -lt 2 -or -not $bare -or $bare -match '^<[^<>]+>$' -or $bare -match '<[^<>]*\s[^<>]*>') { $blank += "V$v" }
                }
                if ($miss.Count) { $iss += 'Ficha sem as linhas ' + ($miss -join ', ') }
                if ($blank.Count) { $iss += 'Ficha com linha sem valor (escreva "não aplicável" e o que substitui): ' + ($blank -join ', ') }
            }
            $pr = @(Get-IdSections $t 'P-\d+')
            if (-not $pr.Count) { $iss += 'nenhum princípio P-nnn' }
            foreach ($x in $pr) { if ($x.Body -notmatch '(?i)consequ[êe]ncia observ[áa]vel') { $iss += "$($x.Id) sem 'Consequência observável'" } }
        }
        '04' {
            if ($p -notmatch '(?im)^#{1,4}\s+.*entidade') { $iss += 'sem a seção de entidades' }
            if ($p -notmatch '(?i)relacionamento') { $iss += 'sem relacionamentos' }
        }
        '05' {
            $na = [regex]::Match($p, '(?i)n[ãa]o (se )?aplic[áa](vel)?\s*[—–:-]\s*\S[^\r\n]{4,}')
            if (-not $na.Success -and $p -notmatch '(?im)^#{1,4}\s+.*contrato de erro') { $iss += "sem 'Contrato de erro' (ou 'não aplicável — <motivo>', em sistema sem API)" }
        }
        '06' {
            if ($p -notmatch '(?m)^#{2,3}\s+v?\d+(\.\d+)*') { $iss += 'nenhuma entrada de versão (## vX.Y …)' }
            if (-not (Test-Path -LiteralPath (Join-Path (Join-Path $Root $SddRel) 'README.md'))) { $iss += "sem o índice $($SddRel)README.md (deliverables/sdd/README.md §Modelo do índice)" }
        }
    }
    if ($Doc.N -in @('01', '02') -and $AreaList.Count) {
        $low = $p.ToLowerInvariant()
        $absent = @($AreaList | Where-Object { -not $low.Contains($_.ToLowerInvariant()) })
        if ($absent.Count) { $iss += 'área sem menção: ' + ($absent -join ', ') }
    }
    $ph = @(Get-Placeholders $t)
    if ($ph.Count) { $iss += "marcador do modelo ($($ph.Count)): " + (($ph | Select-Object -First 3) -join '; ') }
    $nameNote = if ((Split-Path $rel -Leaf) -notlike "$($Doc.N)-*") { " (nome do projeto, revisado onde está; o modelo chama $($Doc.Model))" } else { '' }
    if ($iss.Count) { return @{ Status = 'falhou'; Line = "${rel}${nameNote}: " + ($iss -join '; '); Missing = $false; File = $rel } }
    return @{ Status = 'ok'; Line = "$rel no modelo$nameNote"; Missing = $false; File = $rel }
}

function Get-Guards {
    $g = Join-Path $script:Tp 'guards.json'
    if (-not (Test-Path -LiteralPath $g)) { return $null }
    try { return (Read-Text $g | ConvertFrom-Json) } catch { return $null }
}

function Get-OpenedAt {
    $d = Get-FirstDate (Get-BoardField (Get-BoardText) 'Aberto em')
    return $d
}

function Test-EnvRule([string]$Rule) {
    switch ($Rule) {
        'AMB-verify' {
            $g = Get-Guards
            if ($null -eq $g) { return @{ Status = 'falhou'; Line = '.team-project/guards.json ausente ou ilegível' } }
            $v = $g.verify
            $suite = if ($v -and $v.PSObject.Properties['suite']) { [string]$v.suite } else { '' }
            $build = if ($v -and $v.PSObject.Properties['build']) { [string]$v.build } else { '' }
            if (-not $suite.Trim()) { return @{ Status = 'falhou'; Line = 'guards.json → verify.suite vazio: sem o comando da suíte, nada prova a entrega' } }
            $pre = @(); $pr = $g.run; if ($pr -and $pr.PSObject.Properties['prereqs']) { $pre = @($pr.prereqs | Where-Object { $_ -and $_.PSObject.Properties['check'] -and [string]$_.check }) }
            $bad = @()
            foreach ($x in $pre) {
                $nm = if ($x.PSObject.Properties['name'] -and $x.name) { [string]$x.name } else { [string]$x.check }
                $r = Invoke-Bounded $Root ([string]$x.check) 30
                if ($r.exit -ne 0) { $bad += "$nm fora do ar ($([string]$x.check) → exit $($r.exit))" }
            }
            if ($bad.Count) { return @{ Status = 'falhou'; Line = 'run.prereqs: ' + ($bad -join '; ') } }
            $extra = @(); if (-not $build.Trim()) { $extra += 'verify.build vazio (aviso)' }
            $extra += $(if ($pre.Count) { "$($pre.Count) serviço(s) de run.prereqs no ar" } else { 'nenhum serviço em run.prereqs' })
            return @{ Status = 'ok'; Line = "verify.suite = $suite; " + ($extra -join '; ') }
        }
        'AMB-baseline' {
            $b = Join-Path $script:Tp 'quality-assurance/baseline.md'
            if (-not (Test-Path -LiteralPath $b)) { return @{ Status = 'falhou'; Line = 'quality-assurance/baseline.md ausente (/qa baseline)' } }
            $op = Get-OpenedAt; $w = (Get-Item -LiteralPath $b).LastWriteTime
            if ($op -and $w.Date -lt $op.Date) { return @{ Status = 'falhou'; Line = "baseline.md de $($w.ToString('yyyy-MM-dd')), antes do sprint 0 ($($op.ToString('yyyy-MM-dd'))): rode /qa baseline de novo" } }
            return @{ Status = 'ok'; Line = "baseline.md de $($w.ToString('yyyy-MM-dd'))" }
        }
        'AMB-cenário' {
            $dir = Join-Path $script:Tp 'quality-assurance/scenarios'
            $hit = $null; $seen = 0
            if (Test-Path -LiteralPath $dir) {
                foreach ($f in @(Get-ChildItem -LiteralPath $dir -Recurse -File -Filter '*.md' -ErrorAction SilentlyContinue)) {
                    $hs = Get-Section (Read-Text $f.FullName) '(?i)^#{1,4}\s+Hist[óo]rico de execu'
                    if (-not $hs) { continue }
                    $seen++
                    foreach ($tb in (Get-Tables $hs)) {
                        $it = Find-Col $tb 'Task'; $ir = Find-Col $tb 'Resultado'
                        foreach ($row in $tb.Rows) {
                            if ((Get-Cell $row $it) -match '(?i)\bsprint\s*0\b|\bS0-\d+' -and (Get-Cell $row $ir).Contains($E.Done)) { $hit = $f.BaseName; break }
                        }
                        if ($hit) { break }
                    }
                    if ($hit) { break }
                }
            }
            if ($hit) { return @{ Status = 'ok'; Line = "$hit passou no sprint 0" } }
            return @{ Status = 'falhou'; Line = $(if ($seen) { "$seen cenário(s) na suíte, nenhum com execução ✅ do sprint 0 no Histórico" } else { 'nenhum cenário na suíte (quality-assurance/scenarios/)' }) }
        }
    }
    return @{ Status = 'n-a'; Line = "regra desconhecida: $Rule" }
}

# Veredito do QA por arquivo em sprints/0/evidence/conformance.md — vale só se não é mais velho que o arquivo.
function Test-Conformance([string[]]$Files) {
    if (-not $Files.Count) { return @{ Status = 'n-a'; Line = 'item sem documento' } }
    if (-not (Test-Path -LiteralPath $script:ConfPath)) { return @{ Status = 'falhou'; Line = 'sprints/0/evidence/conformance.md ausente (o QA ainda não conferiu)'; Pending = $Files } }
    $ct = Read-Text $script:ConfPath; $cw = (Get-Item -LiteralPath $script:ConfPath).LastWriteTime
    $iss = @(); $bad = @(); $pending = @()
    foreach ($f in $Files) {
        $name = Split-Path $f -Leaf; $row = $null; $vc = -1
        foreach ($tb in (Get-Tables $ct)) {
            $iv = Find-Col $tb 'Veredito'; if ($iv -lt 0) { continue }
            foreach ($r in $tb.Rows) { if ((Clean-Cell $r[0]).Contains($name)) { $row = $r; $vc = $iv } }
        }
        if ($null -eq $row) { $pending += $f; $iss += "$name sem linha do QA"; continue }
        $cell = Get-Cell $row $vc
        if (-not $cell.Contains($E.Done)) { $bad += $f; $iss += "${name}: $(Clean-Cell $cell)"; continue }
        $full = Join-Path $Root $f
        if ((Test-Path -LiteralPath $full) -and (Get-Item -LiteralPath $full).LastWriteTime -gt $cw.AddSeconds(2)) { $pending += $f; $iss += "$name mudou depois do veredito do QA" }
    }
    if ($iss.Count) { return @{ Status = 'falhou'; Line = ($iss -join '; '); Bad = $bad; Pending = $pending } }
    return @{ Status = 'ok'; Line = "QA ✅ em $(($Files | ForEach-Object { Split-Path $_ -Leaf }) -join ', ')"; Bad = @(); Pending = @() }
}

function Invoke-Rule([string]$Rule, [string]$SddRel, [string[]]$AreaList) {
    $d = @($script:Docs | Where-Object { $_.Rule -eq $Rule })
    if ($d.Count) { return (Test-DocRule $d[0] $SddRel $AreaList) }
    return (Test-EnvRule $Rule)
}

# ---------------- quadro ----------------

function Get-Items([string]$Board) {
    $items = @()
    if (-not $Board) { return $items }
    $sec = Get-Section $Board '^##\s+Itens'
    if (-not $sec) { return $items }
    foreach ($tb in (Get-Tables $sec)) {
        $c = @{}; foreach ($k in 'Item', 'Frente', 'Dono', 'Est', 'Régua', 'Arquivos', 'Área') { $c[$k] = Find-Col $tb $k }
        foreach ($row in $tb.Rows) {
            $idm = [regex]::Match($row[0], 'S0-\d+'); if (-not $idm.Success) { continue }
            $mark = $null; foreach ($m in $script:Marks) { if ($row[0].Contains($m)) { $mark = $m; break } }
            $files = @([regex]::Matches((Get-Cell $row $c['Arquivos']), '`([^`]+)`') | ForEach-Object { $_.Groups[1].Value })
            $rules = @((Clean-Cell (Get-Cell $row $c['Régua'])) -split '[,;\s]+' | Where-Object { $_ -match '^(SDD|AMB)-' })
            $items += [pscustomobject]@{ Id = $idm.Value; Mark = $mark; Title = (Clean-Cell (Get-Cell $row $c['Item'])); Front = (Clean-Cell (Get-Cell $row $c['Frente']))
                Owner = (Clean-Cell (Get-Cell $row $c['Dono'])); Rules = $rules; Files = $files; Area = (Clean-Cell (Get-Cell $row $c['Área'])) }
        }
    }
    return $items
}

function Set-Mark([string]$Id, [string]$To, [string]$Why) {
    $b = Get-BoardText
    $lines = New-Object System.Collections.ArrayList; foreach ($x in ($b -split "`r?`n")) { [void]$lines.Add($x) }
    $from = $null
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -notmatch ('^\|\s*\S*\s*' + [regex]::Escape($Id) + '\s*\|')) { continue }
        foreach ($m in $script:Marks) { if ($lines[$i].Contains($m)) { $from = $m; break } }
        $cells = Split-Row $lines[$i]
        $cells[0] = "$To $Id"
        $lines[$i] = '| ' + ($cells -join ' | ') + ' |'
        break
    }
    if ($null -eq $from -and -not ($lines -match [regex]::Escape($Id))) { Fail "$Id não está no quadro" }
    $text = ($lines -join "`n")
    $text = Add-RegistryLine $text $Id "$from → $To" $Why
    Write-Utf8 $script:BoardPath $text
}

function Add-RegistryLine([string]$Text, [string]$Id, [string]$Change, [string]$Why) {
    $row = "| $(Now) | $Id | $Change | $($Why -replace '\|', '/') |"
    if ($Text -notmatch '(?m)^##\s+Registro') { return ($Text.TrimEnd() + "`n`n## Registro`n`n| Quando | Item | Mudança | Por quê |`n|---|---|---|---|`n$row`n") }
    return ($Text.TrimEnd() + "`n$row`n")
}

function Add-Registry([string]$Id, [string]$Change, [string]$Why) {
    Write-Utf8 $script:BoardPath (Add-RegistryLine (Get-BoardText) $Id $Change $Why)
}

function Get-Returns([string]$Id) {
    $sec = Get-Section (Get-BoardText) '^##\s+Registro'
    if (-not $sec) { return 0 }
    return @([regex]::Matches($sec, '(?m)^\|[^|]*\|\s*' + [regex]::Escape($Id) + '\s*\|\s*devolvido')).Count
}

function Set-BoardField([string]$Label, [string]$Value) {
    $b = Get-BoardText
    $re = '(?m)^(\|\s*\*\*' + [regex]::Escape($Label) + '\*\*\s*\|)[^\r\n]*(?=\r?$)'
    if ($b -notmatch $re) { Fail "o quadro não tem a linha '$Label'" }
    $b = [regex]::Replace($b, $re, { param($m) $m.Groups[1].Value + ' ' + $Value + ' |' })
    Write-Utf8 $script:BoardPath $b
}

function Set-ReadmeRow([string]$Value) {
    if (-not (Test-Path -LiteralPath $script:ReadmePath)) { Fail ".team-project/README.md não existe — rode /team init" }
    $t = Read-Text $script:ReadmePath; $nl = if ($t.Contains("`r`n")) { "`r`n" } else { "`n" }
    $re = '(?m)^(\|\s*\*\*' + [regex]::Escape($script:RowLabel) + '\*\*\s*\|)[^\r\n]*(?=\r?$)'
    $row = "| **$($script:RowLabel)** | $Value |"
    if ($t -match $re) { $t = [regex]::Replace($t, $re, { param($m) $row }) }
    elseif ($t -match '(?m)^\|\s*\*{0,2}Sprint corrente\*{0,2}\s*\|[^\r\n]*(?=\r?$)') { $t = ([regex]'(?m)^(\|\s*\*{0,2}Sprint corrente\*{0,2}\s*\|[^\r\n]*)(?=\r?$)').Replace($t, { param($m) $m.Groups[1].Value + $nl + $row }, 1) }
    elseif ($t -match '(?m)^##\s+2\.[^\r\n]*(?=\r?$)') { $t = ([regex]'(?m)^(##\s+2\.[^\r\n]*)(?=\r?$)').Replace($t, { param($m) $m.Groups[1].Value + "$nl| | |$nl|---|---|$nl" + $row }, 1) }
    else { $t = $t.TrimEnd() + "$nl$nl## 2. Situação atual$nl| | |$nl|---|---|$nl$row$nl" }
    Write-Utf8 $script:ReadmePath $t
}

function Get-ReadmeRow {
    if (-not (Test-Path -LiteralPath $script:ReadmePath)) { return $null }
    $m = [regex]::Match((Read-Text $script:ReadmePath), '(?m)^\|\s*\*{0,2}' + [regex]::Escape($script:RowLabel) + '\*{0,2}\s*\|([^\r\n]*)\|\s*$')
    if (-not $m.Success) { return $null }
    return (Clean-Cell $m.Groups[1].Value)
}

# ---------------- avaliação ----------------

function Get-ProjectKind {
    $prod = (Get-ProductRel).TrimEnd('/')
    $isGit = $false
    try { $null = & git -C $Root rev-parse --is-inside-work-tree 2>$null; $isGit = ($LASTEXITCODE -eq 0) } catch { }
    $files = @()
    if ($isGit) { $files = @(& git -C $Root ls-files 2>$null) }
    else { $files = @(Get-ChildItem -LiteralPath $Root -Recurse -File -ErrorAction SilentlyContinue | Select-Object -First 400 | ForEach-Object { $_.FullName.Substring($Root.TrimEnd('\', '/').Length + 1) -replace '\\', '/' }) }
    $code = @($files | Where-Object { $_ -notmatch '^\.' -and $_ -notmatch '/\.' -and -not $_.StartsWith("$prod/") -and $_ -notmatch '(?i)\.(md|txt)$' -and $_ -notmatch '(?i)^(license|readme)' })
    if ($code.Count) { return @{ Kind = 'retomada'; Line = "sistema com código ($($code.Count) arquivo(s) fora de $prod/, ex.: $($code[0]))" } }
    return @{ Kind = 'novo'; Line = 'sem código fora da documentação' }
}

function Get-Assessment {
    $sdd = Get-SddRel; $board = Get-BoardText; $areas = @(Get-Areas $board)
    $rows = @()
    foreach ($d in $script:Docs) {
        $r = Test-DocRule $d $sdd $areas
        $state = if ($r.Missing) { 'ausente' } elseif ($r.Status -eq 'ok') { 'conforme' } else { 'fora do padrão' }
        $rows += [pscustomobject]@{ Rule = $d.Rule; Source = $r.File; State = $state; Line = $r.Line; Doc = $d }
    }
    foreach ($x in $script:EnvItems) {
        $r = Test-EnvRule $x.Rule
        $state = if ($r.Status -eq 'ok') { 'conforme' } elseif ($r.Line -match 'ausente|nenhum') { 'ausente' } else { 'fora do padrão' }
        $rows += [pscustomobject]@{ Rule = $x.Rule; Source = $x.Title; State = $state; Line = $r.Line; Doc = $null }
    }
    return @{ Sdd = $sdd; Rows = $rows }
}

function New-BoardText($Assessment, $Kind) {
    $n = 0; $lines = @()
    $docRows = @($Assessment.Rows | Where-Object { $_.Doc })
    foreach ($r in $docRows) {
        # Todo documento entra: o que não existe é criado; o que existe é revisado contra o código e conferido pelo QA.
        $n++; $verb = if ($r.State -eq 'ausente') { 'criar' } else { 'revisar contra o código' }
        $area = if ($r.Doc.N -in @('01', '02', '04', '05')) { '1ª onda' } else { 'transversal' }
        $est = if ($r.State -eq 'conforme') { '0,5' } else { '1' }
        $lines += "| $($script:Todo) S0-$('{0:d2}' -f $n) | $($r.Doc.Title) — $verb | $($r.Doc.Front) | $($r.Doc.Owner) | $est | $($r.Rule) | ``$($r.Source)`` | $area |"
    }
    foreach ($x in $script:EnvItems) {
        $st = @($Assessment.Rows | Where-Object { $_.Rule -eq $x.Rule })[0]
        if ($st.State -eq 'conforme' -and $x.Rule -eq 'AMB-verify') { continue }   # baseline e cenário rodam sempre: são a prova do ambiente no sprint 0
        $n++
        $lines += "| $($script:Todo) S0-$('{0:d2}' -f $n) | $($x.Title) | $($x.Front) | $($x.Owner) | $($x.Est) | $($x.Rule) | — | transversal |"
    }
    $kindText = if ($Kind.Kind -eq 'retomada') { 'retomada — documentar o sistema como ele é' } else { 'novo — o SDD veio do /sm sdd; o sprint 0 confere e monta o ambiente' }
    return @"
# Sprint 0 — Fundação

> **DOCUMENTO VIVO** · **Dono:** SM · os marcadores, o Registro e as linhas de cabeçalho são gravados pelo ``foundation.ps1`` (init · approve · next · area · close) — não edite à mão · modelo: ``roles/scrum-master/templates/foundation.md`` · roteiro: ``roles/scrum-master/process/workflow-sprint0.md`` · regra: R35

| | |
|---|---|
| **Estado** | proposta |
| **Tipo** | $kindText |
| **Aberto em** | $(Today) |
| **Diretório do SDD** | ``$($Assessment.Sdd)`` |
| **Áreas em documentação** | <a decidir no formulário do escopo> |
| **Áreas documentadas** | nenhuma |
| **Escopo aprovado** | <data — decisão — por quem> |
| **Aceite** | <data — decisão — por quem> |

## Itens

Legenda: $($script:Todo) a fazer · $($E.Plan) plano · $($E.Build) construção · $($E.QA) conformidade (QA) · $($E.Done) pronto · $($script:Red) bloqueado

| ID | Item | Frente | Dono | Est. | Régua | Arquivos | Área |
|---|---|---|---|---|---|---|---|
$($lines -join "`n")

> **Como sai do lugar:** ``foundation.ps1 next`` marca, confere a régua e diz quem disparar. Documento fecha com a régua ok **e** o ✅ do QA em ``evidence/conformance.md``; ambiente fecha com a régua ``AMB-*`` ok. **O sprint 0 não refatora**: má prática achada vai à dívida (03 §0.1 pelo Arquiteto; o PO a leva ao backlog na review).

## Registro

| Quando | Item | Mudança | Por quê |
|---|---|---|---|
| $(Now) | S0 | criado | foundation.ps1 init — $($n) item(ns) a partir da avaliação |
"@
}

# ---------------- próxima ação ----------------

function Get-AgentLine([string]$Agent) {
    $global:LASTEXITCODE = 0
    $o = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'dispatch.ps1') -Role $Agent -Root $Root 2>&1 | Out-String
    $m = [regex]::Match($o, '(?m)^\s*(Agent:.*)$')
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return "Agent: subagent_type `"team:$Agent`" — dispare e encerre o turno; o aviso traz a volta"
}

function Say-Dispatch([string]$Agent, [string]$Prompt, [string]$Plain) {
    Out "  $(Get-AgentLine $Agent)"
    Out "  prompt: `"$Prompt`""
    if ($Plain) { Out "PARA O STAKEHOLDER: $Plain" }
}

function Get-DocPrompt($It, [string]$Sdd, [string[]]$AreaList, [string]$Extra) {
    $areaText = if ($AreaList.Count) { $AreaList -join ', ' } else { 'as do escopo' }
    $files = ($It.Files | ForEach-Object { "``$_``" }) -join ', '
    $models = @($script:Docs | Where-Object { $It.Rules -contains $_.Rule } | ForEach-Object { "`${CLAUDE_PLUGIN_ROOT}/deliverables/sdd/$($_.Model)" }) -join ', '
    $debt = if ($It.Owner -eq 'Arquiteto') { 'Má prática no código não se corrige aqui: registre em 03 §0.1 (Pendentes de formalização) e cite no retorno como dívida.' } else { 'Comportamento que o código não sustenta não entra; divergência entre documento antigo e código vai no retorno como achado (não corrija código).' }
    $p = "Sprint 0 (fundação), item $($It.Id) — $($It.Title). Escreva ou revise $files no modelo $models, descrevendo o sistema COMO ELE É HOJE: leia o código e a documentação existente; áreas: $areaText, mais o que é transversal. $debt Antes de devolver, rode a régua: powershell -NoProfile -File `${CLAUDE_PLUGIN_ROOT}/scripts/checks/foundation.ps1 check -Item $($It.Id). Roteiro: `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/workflow-sprint0.md §Itens de documentação. Retorno curto (R28): arquivos gravados, achados e dívidas em uma linha cada."
    if ($Extra) { $p += " Devolvido: $Extra" }
    return $p
}

function Get-QaDocPrompt($It) {
    $files = ($It.Files | ForEach-Object { "``$_``" }) -join ', '
    return "Sprint 0 (fundação), item $($It.Id) — conformidade de $files. Confira (1) a régua: powershell -NoProfile -File `${CLAUDE_PLUGIN_ROOT}/scripts/checks/foundation.ps1 check -Item $($It.Id); (2) a fidelidade ao código por amostra — afirmações verificáveis do documento conferidas com arquivo:linha; (3) a verificabilidade dos critérios de aceite. Grave em .team-project/sprints/0/evidence/conformance.md, no modelo `${CLAUDE_PLUGIN_ROOT}/roles/quality-assurance/templates/conformance.md, uma linha por arquivo com Veredito ✅, ⚠️ ou ❌ e os achados com arquivo:linha. Você reprova, não corrige. Retorno curto (R28)."
}

function Invoke-Next {
    $b = Get-BoardText
    if (-not $b) {
        Out 'PRÓXIMA AÇÃO: não há sprint 0 — rode foundation.ps1 assess e, com o stakeholder de acordo (formulário do onboarding, passo 3), foundation.ps1 init'
        exit 0
    }
    $estado = Get-BoardField $b 'Estado'
    if ($estado -match '(?i)^conclu') { Out "PRÓXIMA AÇÃO: nenhuma — sprint 0 $estado. Área nova que o backlog vai tocar: /sm sprint0 area <área>."; exit 0 }
    if ($estado -match '(?i)^dispensad') { Out "PRÓXIMA AÇÃO: nenhuma — sprint 0 $estado."; exit 0 }
    $esc = Get-BoardField $b 'Escopo aprovado'
    if (-not $esc -or (Test-Placeholder $esc)) {
        Out 'PRÓXIMA AÇÃO: formulário do escopo — UMA chamada de AskUserQuestion (R22) com: as áreas da 1ª onda (as que o backlog vai tocar primeiro; o resto é documentado quando o backlog chegar nelas), os itens do quadro e a autorização para a sessão gravar no guards.json os comandos que o plano de ambiente medir. Depois: foundation.ps1 approve -Areas "<áreas>" -By "<quem>" -Decision "<aprovar | aprovar com ajuste — …>"'
        Out 'PARA O STAKEHOLDER: Antes de começar a construir, o time vai documentar o sistema como ele é e deixar o ambiente de testes funcionando. Preciso que você escolha por quais áreas começamos.'
        exit 0
    }
    $sdd = Get-SddRel; $areas = @(Get-Areas $b)
    $items = @(Get-Items $b)
    $done = @($items | Where-Object { $_.Mark -eq $E.Done }).Count
    Out "SPRINT 0 · $done/$($items.Count) itens prontos"
    foreach ($it in $items) {
        if ($it.Mark -eq $E.Done) { continue }
        if ($it.Mark -eq $script:Red) { continue }
        $isDoc = ($it.Front -match '(?i)funcional|t[ée]cnica')
        $agent = $script:RoleAgent[$it.Owner]
        if ($isDoc) {
            $reg = @($it.Rules | ForEach-Object { Invoke-Rule $_ $sdd $areas })
            $regFail = @($reg | Where-Object { $_.Status -eq 'falhou' } | ForEach-Object { $_.Line })
            if ($it.Mark -eq $script:Todo) {
                Set-Mark $it.Id $E.Build "dono: $($it.Owner)"
                Out "PRÓXIMA AÇÃO: $($it.Id) → $($E.Build) — $($it.Owner) escreve $($it.Files -join ', ')"
                Say-Dispatch $agent (Get-DocPrompt $it $sdd $areas '') "Agora: $($it.Title.ToLowerInvariant())."
                exit 0
            }
            if ($it.Mark -eq $E.Build) {
                if ($regFail.Count) { Invoke-Return $it $agent "régua: $($regFail -join '; ')" (Get-DocPrompt $it $sdd $areas "a régua reprovou — $($regFail -join '; ')"); exit 0 }
                Set-Mark $it.Id $E.QA 'régua ok — conformidade do QA'
                Out "PRÓXIMA AÇÃO: $($it.Id) → $($E.QA) — o QA confere $($it.Files -join ', ')"
                Say-Dispatch 'quality-assurance' (Get-QaDocPrompt $it) ''
                exit 0
            }
            if ($it.Mark -eq $E.QA) {
                $c = Test-Conformance $it.Files
                if ($regFail.Count) { Set-Mark $it.Id $E.Build 'a régua caiu depois da conformidade'; Invoke-Return $it $agent "régua: $($regFail -join '; ')" (Get-DocPrompt $it $sdd $areas "a régua reprovou — $($regFail -join '; ')"); exit 0 }
                if ($c.Status -eq 'ok') { Set-Mark $it.Id $E.Done $c.Line; Out "$($it.Id) $($E.Done) — $($c.Line)"; continue }
                if (@($c.Bad).Count) {
                    Set-Mark $it.Id $E.Build 'o QA reprovou'
                    Invoke-Return $it $agent "QA: $($c.Line)" (Get-DocPrompt $it $sdd $areas "o QA reprovou — leia os achados das linhas $((@($c.Bad) | ForEach-Object { Split-Path $_ -Leaf }) -join ', ') em .team-project/sprints/0/evidence/conformance.md")
                    exit 0
                }
                Out "PRÓXIMA AÇÃO: $($it.Id) — o QA ainda não gravou o veredito ($($c.Line))"
                Say-Dispatch 'quality-assurance' (Get-QaDocPrompt $it) ''
                exit 0
            }
            continue
        }
        # Ambiente e prova
        $reg = @($it.Rules | ForEach-Object { Invoke-Rule $_ $sdd $areas })
        $regFail = @($reg | Where-Object { $_.Status -eq 'falhou' } | ForEach-Object { $_.Line })
        if ($it.Front -match '(?i)ambiente') {
            $plan = @(Get-ChildItem -LiteralPath (Join-Path $script:S0 'plan') -File -Filter "$($it.Id)-*.md" -ErrorAction SilentlyContinue | Select-Object -First 1)
            $planRel = if ($plan.Count) { ".team-project/sprints/0/plan/$($plan[0].Name)" } else { '' }
            $delivery = Join-Path $script:S0 "delivery/$($it.Id).md"
            if ($it.Mark -eq $script:Todo -and -not $regFail.Count) { Set-Mark $it.Id $E.Done 'a régua já passa — nada a construir'; Out "$($it.Id) $($E.Done) — régua ok sem construção"; continue }
            if ($it.Mark -eq $script:Todo -or ($it.Mark -eq $E.Plan -and -not $planRel)) {
                if ($it.Mark -eq $script:Todo) { Set-Mark $it.Id $E.Plan 'plano do Arquiteto' }
                Out "PRÓXIMA AÇÃO: $($it.Id) → $($E.Plan) — o Arquiteto escreve o plano do ambiente"
                Say-Dispatch 'architect' "Sprint 0 (fundação), item $($it.Id) — $($it.Title). Escreva o plano curto em .team-project/sprints/0/plan/$($it.Id)-ambiente.md no modelo `${CLAUDE_PLUGIN_ROOT}/roles/architect/templates/foundation-env-plan.md: meça no ambiente (saída real) o que falta para build, testes e lint rodarem por um comando cada e quais serviços precisam estar no ar; liste em **Arquivos tocados:** (caminhos entre crases) o que o dev cria ou altera; e escreva o bloco '## guards.json proposto' (verify e run.prereqs) — quem grava o guards.json é a sessão. Régua hoje: $($regFail -join '; '). Retorno curto (R28)." 'Agora: o arquiteto prepara o ambiente de testes.'
                exit 0
            }
            if ($it.Mark -eq $E.Plan) {
                Set-Mark $it.Id $E.Build "dev pelo plano $planRel"
                $global:LASTEXITCODE = 0
                $o = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'dispatch.ps1') -Role developer -Id $it.Id -Plan $planRel -Root $Root 2>&1 | Out-String
                if ($LASTEXITCODE -ne 0) { Fail "dispatch do dev: $($o.Trim())" }
                Out "PRÓXIMA AÇÃO: $($it.Id) → $($E.Build) — o dev executa $planRel (escopo gravado em .active-task)"
                $am = [regex]::Match($o, '(?m)^\s*(Agent:.*)$'); Out "  $(if ($am.Success) { $am.Groups[1].Value.Trim() } else { 'Agent: subagent_type "team:developer"' })"
                Out "  prompt: `"Sprint 0 (fundação), item $($it.Id): execute o plano $planRel. Grave a entrega em .team-project/sprints/0/delivery/$($it.Id).md com o que mudou e os comandos rodados com a saída real. Não grave o guards.json (é da sessão). Retorno curto (R28).`""
                Out 'PARA O STAKEHOLDER: Agora: o desenvolvedor monta o ambiente de testes.'
                exit 0
            }
            if ($it.Mark -eq $E.Build) {
                if (-not (Test-Path -LiteralPath $delivery)) { Out "PRÓXIMA AÇÃO: $($it.Id) — o dev ainda não gravou .team-project/sprints/0/delivery/$($it.Id).md; se ele voltou sem entrega, dispare-o de novo com o mesmo prompt"; exit 0 }
                if (-not $regFail.Count) {
                    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'dispatch.ps1') -Clear -Root $Root 2>&1 | Out-Null
                    Set-Mark $it.Id $E.Done (($reg | ForEach-Object { $_.Line }) -join '; ')
                    Out "$($it.Id) $($E.Done) — $(($reg | ForEach-Object { $_.Line }) -join '; ')"
                    continue
                }
                $applied = (Get-Returns $it.Id) -gt 0 -or ((Get-Section (Get-BoardText) '^##\s+Registro') -match ('\|\s*' + [regex]::Escape($it.Id) + '\s*\|\s*guards\.json'))
                if (-not $applied -and $planRel) {
                    Add-Registry $it.Id 'guards.json' 'a sessão grava o bloco proposto do plano (autorizado no escopo)'
                    Out "PRÓXIMA AÇÃO: $($it.Id) — a sessão grava em .team-project/guards.json o bloco '## guards.json proposto' de $planRel (autorizado no formulário do escopo; guards.json é da sessão) e roda o next de novo"
                    Out "  régua hoje: $($regFail -join '; ')"
                    exit 0
                }
                & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'dispatch.ps1') -Clear -Root $Root 2>&1 | Out-Null
                Set-Mark $it.Id $E.Plan 'a régua do ambiente não passou com o plano aplicado'
                Invoke-Return $it 'architect' "régua: $($regFail -join '; ')" "Sprint 0 (fundação), item $($it.Id): o ambiente montado pelo plano $planRel não passa na régua — $($regFail -join '; '). Leia a entrega .team-project/sprints/0/delivery/$($it.Id).md, meça de novo e corrija o plano (mesmo arquivo). Retorno curto (R28)."
                exit 0
            }
            continue
        }
        # Prova (QA): baseline e cenário ponta a ponta.
        $qaPrompt = if ($it.Rules -contains 'AMB-baseline') { "Sprint 0 (fundação), item $($it.Id) — /qa baseline: reproduza build, testes, cobertura e lint pelos comandos de .team-project/guards.json → verify e grave .team-project/quality-assurance/baseline.md. Número que diverge do declarado vira GAP e achado no retorno. Retorno curto (R28)." }
                    else { "Sprint 0 (fundação), item $($it.Id) — crie a suíte inicial a partir do SDD das áreas $(if ($areas.Count) { $areas -join ', ' } else { 'do escopo' }) (/qa scenarios create) e rode UM cenário ponta a ponta no alvo (/qa scenarios run <SC-nnn>; grupo e all vão ao operator — R28), com 'Task/Sprint' = '$($it.Id) / sprint 0' no Histórico de execuções. Sem a ferramenta do alvo: ⚠️ não executado — sem ferramenta, e diga no retorno o que falta. Retorno curto (R28)." }
        if ($it.Mark -eq $script:Todo) {
            if (-not $regFail.Count -and $it.Rules -notcontains 'AMB-cenário') { Set-Mark $it.Id $E.Done 'a régua já passa'; continue }
            Set-Mark $it.Id $E.Build 'QA'
            Out "PRÓXIMA AÇÃO: $($it.Id) → $($E.Build) — o QA prova o ambiente"
            Say-Dispatch 'quality-assurance' $qaPrompt 'Agora: a qualidade confere se o ambiente de testes funciona de ponta a ponta.'
            exit 0
        }
        if ($it.Mark -eq $E.Build) {
            if (-not $regFail.Count) { Set-Mark $it.Id $E.Done (($reg | ForEach-Object { $_.Line }) -join '; '); Out "$($it.Id) $($E.Done)"; continue }
            Invoke-Return $it 'quality-assurance' "régua: $($regFail -join '; ')" ($qaPrompt + " Devolvido: a régua reprovou — $($regFail -join '; ').")
            exit 0
        }
    }
    $blocked = @($items | Where-Object { $_.Mark -eq $script:Red })
    if ($blocked.Count) {
        Out "PRÓXIMA AÇÃO: $($blocked.Count) item(ns) $($script:Red) — $(($blocked | ForEach-Object { $_.Id }) -join ', '): degrau 1 (PO + Arquiteto, /sm agreement); o que eles não fecharem vai ao stakeholder em formulário (R25). Depois, foundation.ps1 next."
        exit 0
    }
    Out 'PRÓXIMA AÇÃO: todos os itens prontos — /clear e /sm sprint0 review (o PO apresenta; o stakeholder aceita num formulário só; foundation.ps1 close)'
    Out 'PARA O STAKEHOLDER: A documentação e o ambiente de testes estão prontos para a sua aprovação.'
    exit 0
}

function Invoke-Return($It, [string]$Agent, [string]$Why, [string]$Prompt) {
    $n = Get-Returns $It.Id
    if ($n -ge $script:MaxReturns) {
        Set-Mark $It.Id $script:Red "$n devoluções — degrau 1 (PO + Arquiteto)"
        Out "PRÓXIMA AÇÃO: $($It.Id) → $($script:Red) — $n devoluções sem fechar ($Why). Degrau 1: /sm agreement com PO e Arquiteto; o que não fechar vai ao stakeholder em formulário (R25). Os outros itens seguem: foundation.ps1 next."
        return
    }
    Add-Registry $It.Id 'devolvido' $Why
    Out "PRÓXIMA AÇÃO: $($It.Id) devolvido ($($n + 1)/$($script:MaxReturns)) — $Why"
    Say-Dispatch $Agent $Prompt ''
}

# ---------------- ações ----------------

try {
    if (-not (Test-Path -LiteralPath $script:Tp)) { Fail "$($script:Tp) não existe — rode na raiz do projeto ou passe -Root." }
    switch ($Action.ToLowerInvariant()) {
        'assess' {
            $a = Get-Assessment; $k = Get-ProjectKind
            Out "### Sprint 0 · avaliação ($($a.Sdd))"
            Out ''
            Out '| Fonte | Estado | Linha decisiva |'
            Out '|---|---|---|'
            foreach ($r in $a.Rows) { Out "| $($r.Rule) · $($r.Source) | $($r.State) | $(($r.Line -replace '\|', '/')) |" }
            $open = @($a.Rows | Where-Object { $_.State -ne 'conforme' }).Count
            Out ''
            Out "Tipo: $($k.Kind) — $($k.Line)"
            Out "Recomendação: sprint 0 — $open fonte(s) a criar ou adequar, e todo documento existente revisado contra o código e conferido pelo QA (R35). Dispensa só por decisão do stakeholder, com o risco aceito (foundation.ps1 dispense)."
            exit 0
        }
        'init' {
            if (Test-Path -LiteralPath $script:BoardPath) { Fail 'sprints/0/foundation.md já existe — siga com foundation.ps1 next' }
            $a = Get-Assessment; $k = Get-ProjectKind
            Write-Utf8 $script:BoardPath (New-BoardText $a $k)
            Set-ReadmeRow "exigido — em andamento desde $(Today) · quadro: ``.team-project/sprints/0/foundation.md``"
            $n = @(Get-Items (Get-BoardText)).Count
            Out "foundation: sprints/0/foundation.md criado com $n item(ns) ($($k.Kind)); README §2 → '$($script:RowLabel)': exigido. Próximo: foundation.ps1 next (formulário do escopo)."
            exit 0
        }
        'approve' {
            if (-not (Get-BoardText)) { Fail 'não há sprints/0/foundation.md — rode foundation.ps1 init' }
            if (-not $Areas.Trim() -or -not $By.Trim()) { Fail 'approve exige -Areas "<áreas da 1ª onda>" e -By "<quem aprovou>"' }
            $dec = if ($Decision.Trim()) { $Decision.Trim() } else { 'aprovar' }
            Set-BoardField 'Áreas em documentação' ($Areas.Trim() -replace '\|', '/')
            Set-BoardField 'Escopo aprovado' "$(Today) — $($dec -replace '\|', '/') — $($By -replace '\|', '/')"
            Set-BoardField 'Estado' 'vigente'
            Add-Registry 'S0' 'escopo aprovado' "áreas: $Areas · $dec · $By"
            Out "foundation: escopo aprovado ($Areas) — próximo: foundation.ps1 next"
            exit 0
        }
        'next' { Invoke-Next }
        'check' {
            $b = Get-BoardText; $sdd = Get-SddRel; $areas = @(Get-Areas $b)
            if ($Item) {
                $it = @(Get-Items $b | Where-Object { $_.Id -eq $Item })
                if (-not $it.Count) { Fail "$Item não está no quadro" }
                foreach ($r in $it[0].Rules) { $x = Invoke-Rule $r $sdd $areas; Add-Result $r $x.Status $x.Line }
                Write-Results "Sprint 0 · régua de $Item"
            } else {
                foreach ($d in $script:Docs) { $x = Test-DocRule $d $sdd $areas; Add-Result $d.Rule $x.Status $x.Line }
                foreach ($x in $script:EnvItems) { $y = Test-EnvRule $x.Rule; Add-Result $x.Rule $y.Status $y.Line }
                $files = @($script:Docs | ForEach-Object { Get-DocPath $_ $sdd })
                $c = Test-Conformance $files; Add-Result 'QA-conformidade' $c.Status $c.Line
                if ($b) {
                    $items = @(Get-Items $b); $open = @($items | Where-Object { $_.Mark -ne $E.Done })
                    if ($open.Count) { Add-Result 'itens' 'falhou' ("$($open.Count) de $($items.Count) sem ✅: " + (($open | ForEach-Object { "$($_.Mark) $($_.Id)" }) -join ', ')) }
                    else { Add-Result 'itens' 'ok' "$($items.Count) item(ns) ✅" }
                } else { Add-Result 'itens' 'n-a' 'sem sprints/0/foundation.md' }
                Write-Results 'Sprint 0 · régua completa'
            }
            if (@($script:Results | Where-Object { $_.Resultado -eq 'falhou' }).Count) { exit 1 }
            exit 0
        }
        'area' {
            $b = Get-BoardText
            if (-not $b) { Fail 'não há sprints/0/foundation.md — a área nova entra pelo sprint 0 do projeto (foundation.ps1 init)' }
            if (-not $Add.Trim() -or -not $By.Trim()) { Fail 'area exige -Add "<área>" -By "<quem pediu>"' }
            if ((Get-BoardField $b 'Estado') -notmatch '(?i)^conclu') { Fail "o sprint 0 ainda não fechou — some a área ao escopo dele (foundation.ps1 approve -Areas)" }
            $sdd = Get-SddRel; $items = @(Get-Items $b)
            $n = 0; foreach ($i in $items) { $v = [int]($i.Id -replace '\D', ''); if ($v -gt $n) { $n = $v } }
            $area = $Add.Trim() -replace '\|', '/'; $new = @()
            foreach ($d in @($script:Docs | Where-Object { $_.N -in @('01', '02', '04', '05') })) {
                $n++; $new += "| $($script:Todo) S0-$('{0:d2}' -f $n) | $($d.Title) — área $area | $($d.Front) | $($d.Owner) | 0,5 | $($d.Rule) | ``$(Get-DocPath $d $sdd)`` | $area |"
            }
            $lines = New-Object System.Collections.ArrayList; foreach ($x in ($b -split "`r?`n")) { [void]$lines.Add($x) }
            $sec = -1; for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^##\s+Itens') { $sec = $i; break } }
            $last = -1; for ($i = $sec + 1; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^##\s') { break }; if ($lines[$i] -match '^\|.*S0-\d+') { $last = $i } }
            if ($last -lt 0) { Fail 'tabela de Itens não encontrada no quadro' }
            $lines.InsertRange($last + 1, [string[]]$new)
            Write-Utf8 $script:BoardPath ($lines -join "`n")
            Set-BoardField 'Áreas em documentação' $area
            Set-BoardField 'Escopo aprovado' "$(Today) — área $area — $($By -replace '\|', '/')"
            Set-BoardField 'Estado' "vigente — área $area"
            Add-Registry 'S0' 'área reaberta' "$area · $By"
            $row = Get-ReadmeRow
            if ($row -and $row -notmatch [regex]::Escape("área $area")) { Set-ReadmeRow (($row -replace '\s*·\s*área .* em documentação$', '') + " · área $area em documentação") }
            Out "foundation: área '$area' reaberta com $($new.Count) item(ns) — próximo: foundation.ps1 next. O sprint funcional segue aberto para as áreas já documentadas."
            exit 0
        }
        'close' {
            $b = Get-BoardText
            if (-not $b) { Fail 'não há sprints/0/foundation.md' }
            if (-not $By.Trim()) { Fail 'close exige -By "<quem aceitou>"' }
            $sdd = Get-SddRel; $areas = @(Get-Areas $b)
            foreach ($d in $script:Docs) { $x = Test-DocRule $d $sdd $areas; Add-Result $d.Rule $x.Status $x.Line }
            foreach ($x in $script:EnvItems) { $y = Test-EnvRule $x.Rule; Add-Result $x.Rule $y.Status $y.Line }
            $c = Test-Conformance @($script:Docs | ForEach-Object { Get-DocPath $_ $sdd }); Add-Result 'QA-conformidade' $c.Status $c.Line
            $open = @(Get-Items $b | Where-Object { $_.Mark -ne $E.Done })
            if ($open.Count) { Add-Result 'itens' 'falhou' (($open | ForEach-Object { "$($_.Mark) $($_.Id)" }) -join ', ') } else { Add-Result 'itens' 'ok' 'todos ✅' }
            if (@($script:Results | Where-Object { $_.Resultado -eq 'falhou' }).Count) {
                Write-Results 'Sprint 0 · o aceite não grava: a régua reprovou'
                exit 1
            }
            $dec = if ($Decision.Trim()) { $Decision.Trim() -replace '\|', '/' } else { 'aprovar' }
            $docd = @((Get-BoardField $b 'Áreas documentadas') -split '[,;]' | ForEach-Object { $_.Trim() } | Where-Object { $_ -and $_ -notmatch '(?i)^nenhuma' -and -not (Test-Placeholder $_) })
            $now = @((Get-BoardField $b 'Áreas em documentação') -split '[,;]' | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not (Test-Placeholder $_) -and $_ -notmatch '(?i)^nenhuma' })
            $all = @(@($docd) + @($now) | Select-Object -Unique)
            Set-BoardField 'Áreas documentadas' $(if ($all.Count) { $all -join ', ' } else { 'transversal' })
            Set-BoardField 'Áreas em documentação' 'nenhuma'
            Set-BoardField 'Aceite' "$(Today) — $dec — $($By -replace '\|', '/')"
            Set-BoardField 'Estado' "concluído em $(Today)"
            Add-Registry 'S0' 'aceite' "$dec · $By"
            Set-ReadmeRow "concluído em $(Today) — áreas documentadas: $(if ($all.Count) { $all -join ', ' } else { 'transversal' }) · quadro: ``.team-project/sprints/0/foundation.md``"
            Write-Results 'Sprint 0 · aceite gravado'
            Out ''
            Out "foundation: sprint 0 concluído — o backlog funcional abre (/clear e /sm sprint prepare). História de área fora de '$($all -join ', ')': /sm sprint0 area <área> antes."
            exit 0
        }
        'dispense' {
            if (-not $By.Trim() -or -not $Because.Trim()) { Fail 'dispense exige -By "<quem decidiu>" e -Because "<motivo — o risco aceito>"' }
            Set-ReadmeRow "dispensado em $(Today) por $($By -replace '\|', '/') — $($Because -replace '\|', '/')"
            if (Get-BoardText) { Set-BoardField 'Estado' "dispensado em $(Today)"; Add-Registry 'S0' 'dispensado' "$Because · $By" }
            Out "foundation: sprint 0 dispensado pelo stakeholder — risco aceito registrado no README §2"
            exit 0
        }
        'gate' {
            $row = Get-ReadmeRow
            if ($null -eq $row) { Out "gate: ok — README §2 sem a linha '$($script:RowLabel)' (projeto anterior à v3.61.0)"; exit 0 }
            if ($row -match '(?i)^(conclu|dispensad)') { Out "gate: ok — sprint 0 $row"; exit 0 }
            if (Test-Placeholder $row) { Out "gate: bloqueado — a linha '$($script:RowLabel)' do README §2 não foi decidida: o /sm onboarding (passo 3) decide se há sprint 0"; exit 1 }
            Out "gate: bloqueado — sprint 0 $row. O backlog funcional abre depois do aceite (/sm sprint0 run → /sm sprint0 review) ou da dispensa do stakeholder (foundation.ps1 dispense)."
            exit 1
        }
        default { Fail "ação desconhecida '$Action' — use assess, init, approve, next, check, area, close, dispense ou gate" }
    }
} catch {
    [Console]::Error.WriteLine("foundation: erro — $($_.Exception.Message) (linha $($_.InvocationInfo.ScriptLineNumber))")
    exit 2
}
