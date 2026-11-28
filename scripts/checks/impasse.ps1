# v3.66.0 — declarar o impasse e saber quem resolve (roles/scrum-master/process/impasse-matrix.md, R36).
# Quem trava (papel ou sessão) não pergunta direto ao stakeholder: declara aqui. O script lê a matriz (hooks/impasses.json),
# recusa o que já foi decidido, confere a evidência do tipo, diz o dono e grava o caso no registro da trilha
# (sprints/<n>/ ou fixes/B-<nnn>/team-decisions.jsonl). Só o tipo que sobe grava a rota ao stakeholder (.ask-route), sem a
# qual a G24 não deixa sair formulário.
# Uso (raiz do projeto):
#   impasse.ps1 raise -Type <type> -Part <H-Z|T-098|F-010|S7|projeto> -Subject <chave> -Origin <papel ou modo>
#                     -Consulted "<§7 N | D-k | S7-I3 | none>" -Text "<o impasse numa frase>"
#                     [-Detail ..] [-NewFact ..] [-From <id>] [-Distinct ..] [-Quote ..] [-Gate ..] [-Path <arquivo>]
#   impasse.ps1 close -Id <id> -Summary "<a decisão em frase simples>" -Ref "<arquivo>#<âncora>" [-Allow "<cmd>;<cmd>"]
#   impasse.ps1 owner -Path <arquivo>
#   impasse.ps1 list [-Trail S7|B-002] [-Format plain|review]
# Exit 0 · 2 = erro de uso ou evidência que falta · 3 = já decidido (ou em andamento) — aplique a decisão mostrada.

param(
    [Parameter(Position = 0, Mandatory = $true)][ValidateSet('raise', 'close', 'owner', 'list')][string]$Action,
    [string]$Type = '',
    [string]$Part = '',
    [string]$Subject = '',
    [string]$Origin = '',
    [string]$Consulted = '',
    [string]$Text = '',
    [string]$Detail = '',
    [string]$NewFact = '',
    [string]$From = '',
    [string]$Distinct = '',
    [string]$Quote = '',
    [string]$Gate = '',
    [string]$Path = '',
    [string]$Id = '',
    [string]$Summary = '',
    [string]$Ref = '',
    [string]$Allow = '',
    [string]$Trail = '',
    [ValidateSet('plain', 'review')][string]$Format = 'plain',
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
. (Join-Path $PSScriptRoot '..\..\hooks\common.ps1')   # Test-GlobMatch, Get-AgentDispatchText, Get-Marker; carrega o plain.ps1 e o impasse-lib.ps1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
function Out([string]$s) { [Console]::Out.WriteLine($s) }
function Fail([string]$s, [int]$Code = 2) { [Console]::Error.WriteLine("impasse $Action`: $s"); exit $Code }

$tp = Join-Path $Root '.team-project'
if (-not (Test-Path -LiteralPath $tp)) { Fail "$tp não existe — rode na raiz do projeto ou passe -Root." }
$mx = Get-ImpasseMatrix $Root

# Regrava a seção "Decisões do time" do kanban da trilha (o kanban.ps1 é script: sem custo de token). Falha não sobe.
function Update-Board($Tr) {
    try {
        $kb = Join-Path $PSScriptRoot 'kanban.ps1'
        $args0 = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $kb, '-Root', $Root)
        if ($Tr.Kind -eq 'fix') { $args0 += @('-Block', $Tr.Id) }
        elseif (-not (Test-Path -LiteralPath $Tr.Kanban)) { return }
        $null = & powershell @args0 2>$null
    } catch { }
}

function Get-NextImpasseId($Tr) {
    $n = @(Read-ImpasseEvents $Tr.Path | Where-Object { [string]$_.event -in 'raise', 'refused' }).Count
    return "$($Tr.Id)-I$($n + 1)"
}

if ($Action -eq 'owner') {
    if (-not $Path) { Fail 'owner pede -Path <arquivo>.' }
    $rel = $Path -replace '\\', '/'
    $full = $Root -replace '\\', '/'
    if ($rel.StartsWith($full, [StringComparison]::OrdinalIgnoreCase)) { $rel = $rel.Substring($full.Length).TrimStart('/') }
    $hit = Find-OwnershipRule $rel -PluginSource:(Test-PluginSource $Root)
    if (-not $hit) { Out "owner: $rel — sem regra na matriz de propriedade: fora de .team-project/ e de docs/ é código-fonte (escreve o dev, pelo plano; o Arquiteto planeja)."; exit 0 }
    if (-not @($hit.Writers).Count) { Out "owner: $rel — dono: $($hit.Owner); só a sessão principal escreve (em nome do stakeholder ou pelo script)."; exit 0 }
    Out "owner: $rel — dono: $($hit.Owner); escrevem: $($hit.WriterNames -join ' · ')."
    Out "  $(Get-AgentDispatchText $Root ([string]@($hit.Writers)[0]))"
    exit 0
}

if ($Action -eq 'list') {
    $tr = if ($Trail) { if ($Trail -match '^S(\d+)$') { Get-ImpasseTrailById $Root "$Trail-I1" } elseif ($Trail -match '^B-\d+$') { Get-ImpasseTrailById $Root "$Trail-I1" } else { Fail "-Trail '$Trail' inválido — use S<n> ou B-<nnn>." } } else { Get-ImpasseTrail $Root }
    $items = @(Get-TeamDecisions $tr.Path)
    if ($Format -eq 'review') {
        Out "## Decidido pelo time sem você"
        Out ''
        Out "O que o time resolveu sozinho neste $(if ($tr.Kind -eq 'fix') { "bloco ($($tr.Id))" } else { "sprint ($($tr.Id))" }), o que subiu a você e por quê. Qualquer linha pode ser revertida: diga qual, e ela volta como ""contradiz uma decisão aceita""."
        Out ''
        if ($items.Count) { Out (Format-TeamDecisionsTable $items $mx "`n") } else { Out '*(nenhum impasse registrado nesta trilha)*' }
        exit 0
    }
    Out "impasses de $($tr.Id) ($($tr.Rel)/team-decisions.jsonl): $($items.Count)"
    foreach ($d in $items) { Out "  $($d.Id) · $($d.Type) · $($d.Part)/$($d.Subject) · $($d.Result) · $(Get-ImpasseOwnerName $d.Owner)$(if ($d.Summary) { " — $($d.Summary)" } else { " — $($d.Text)" })" }
    exit 0
}

if ($Action -eq 'close') {
    if (-not $Id) { Fail 'close pede -Id <S<n>-I<k> | B-<nnn>-I<k>>.' }
    $tr = Get-ImpasseTrailById $Root $Id
    if (-not $tr) { Fail "-Id '$Id' inválido — use o id que o raise imprimiu (S7-I3, B-002-I1)." }
    $cur = @(Get-TeamDecisions $tr.Path | Where-Object { $_.Id -eq $Id }) | Select-Object -First 1
    if (-not $cur) { Fail "$Id não está em $($tr.Rel)/team-decisions.jsonl." }
    if ($cur.Result -eq 'refused-already-decided') { Fail "$Id foi uma recusa por já estar decidido — não há o que fechar." }
    if (-not $Summary.Trim()) { Fail 'close pede -Summary "<a decisão em frase simples>" — é o que o kanban mostra a quem acompanha.' }
    if (-not $Ref.Trim()) { Fail 'close pede -Ref "<arquivo>#<âncora>" — onde o dono gravou a decisão (resposta técnica, spec, História, cenário, README §7).' }
    $refFile = ($Ref -split '#')[0].Trim() -replace '\s+§.*$', ''
    if ($refFile -and -not (Test-Path -LiteralPath (Join-Path $Root $refFile))) { Fail "-Ref '$Ref': $refFile não existe a partir da raiz do projeto." }
    $allowRun = @(); $allowSession = @()
    foreach ($c in @($Allow -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
        if ($c -match '(?i)^(npm|pnpm|yarn)\s+(i|install|add)\b|^pip3?\s+install\b|^dotnet\s+(add|tool\s+install)\b|^choco\s|^winget\s|\bgit\s+push\b|^(curl|wget|Invoke-WebRequest|iwr)\b') { $allowSession += $c } else { $allowRun += $c }
    }
    if ($allowRun.Count -and $tr.Kind -eq 'sprint' -and (Test-Path -LiteralPath (Join-Path $tr.Dir 'sprint-backlog.md'))) {
        $o = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'run.ps1') allow -Commands ($allowRun -join ';') -By "stakeholder (decisão $Id)" -Root $Root 2>&1 | Out-String
        Out "  run allow: $(($o -replace '\s+', ' ').Trim())"
    } elseif ($allowRun.Count) { $allowSession += $allowRun }
    Add-ImpasseEvent $tr.Path ([ordered]@{ id = $Id; event = 'close'; at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); summary = $Summary.Trim(); ref = $Ref.Trim(); allow = @($allowRun + $allowSession) })
    # v3.66.0 (item J, R34): a pendência que o raise gravou na §7 sai como resolvida, na mesma resposta.
    $rEv = @(Read-ImpasseEvents $tr.Path | Where-Object { [string]$_.id -eq $Id -and [string]$_.event -eq 'raise' }) | Select-Object -First 1
    if ($rEv -and $rEv.pending) { if (Set-ImpassePendingResolved $Root ([int]$rEv.pending) $Summary.Trim()) { Out "  R34: pendência $($rEv.pending) da §7 marcada como resolvida." } }
    Update-Board $tr
    Out "impasse close: $Id fechado — $($Summary.Trim()) ($($Ref.Trim())). Registrado em $($tr.Rel)/team-decisions.jsonl; o kanban mostra na seção Decisões do time."
    foreach ($c in $allowSession) { Out "  autorizado pela decisão ${Id}: a sessão roda agora ``$c`` (instalação, rede ou envio não vão ao papel nem a runCommands — G14)." }
    exit 0
}

# ---------- raise ----------
$t = Get-ImpasseType $mx $Type
if (-not $t) { Fail "-Type '$Type' não está na matriz. Tipos: $((@($mx.Types) | Where-Object { -not $_.scriptOnly } | ForEach-Object { $_.type }) -join ' · ') (roles/scrum-master/process/impasse-matrix.md §1)." }
if ($t.scriptOnly) { Fail "o tipo '$($t.type)' só é gravado pelo run.ps1 ou pelo gate.ps1 (a rota $(@($t.legacyRoutes) -join '/') sai do next). Rode run.ps1 next." }
foreach ($req in @(@{ v = $Part; n = '-Part' }, @{ v = $Subject; n = '-Subject' }, @{ v = $Origin; n = '-Origin' }, @{ v = $Text; n = '-Text' }, @{ v = $Consulted; n = '-Consulted' })) {
    if (-not ([string]$req.v).Trim()) { Fail "falta $($req.n). O raise pede -Part, -Subject, -Origin, -Text e -Consulted (o que você consultou antes: '§7 N', 'D-k', um id de impasse, ou 'none')." }
}
$P = $Part.Trim().ToUpperInvariant() -replace '\s+', '-'
if ($P -notmatch '^[A-Z0-9][A-Z0-9-]*$') { Fail "-Part '$Part' — use o código da parte (H-Z, T-098, F-010, S7, PROJETO)." }
$Sj = ConvertTo-ImpasseSubject $Subject
if (-not $Sj) { Fail "-Subject '$Subject' vazio depois de normalizar — use uma chave curta (ex.: seta-teclado, ordem-fix-plan)." }
$tr = Get-ImpasseTrail $Root
$nowS = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$escal = Test-ImpasseEscalates $t

# R25 (c): durante o sprint run, quem leva ao stakeholder é o run.ps1 e o gate.ps1.
$ar = Get-Marker $Root '.active-run'
if ($escal -and $ar -and [string]$ar.trilha -eq 'sprint' -and $t.type -ne 'stakeholder-request') {
    Fail "durante o sprint run a rota ao stakeholder vem do run.ps1 next (R25 c) — '$($t.type)' não sobe por aqui. Leve o impasse ao dono pelo next (GAP de produto, bloqueio) ou, se o stakeholder interrompeu e pediu, run.ps1 pause antes e -Type stakeholder-request com a frase dele."
}

# Já decidido (ou em andamento) para a mesma parte e o mesmo assunto.
$prev = Find-ImpasseDecision $Root $P $Sj
if ($prev -and -not $NewFact.Trim()) {
    $rid = Get-NextImpasseId $tr
    Add-ImpasseEvent $tr.Path ([ordered]@{ id = $rid; event = 'refused'; at = $nowS; origin = $Origin; type = $t.type; part = $P; subject = $Sj; owner = [string]$t.owner; reaches = [string]$t.reachesStakeholder; text = $Text.Trim(); ref = $prev.Ref; previous = $prev.Id })
    Update-Board $tr
    if ($prev.Open) { Fail "$P/$Sj já está em andamento ($($prev.Id), com $(Get-ImpasseOwnerName $prev.Owner)) — espere a volta do dono; não abra outro. Com fato novo, -NewFact." 3 }
    Fail "$P/$Sj já foi decidido ($($prev.Id)$(if ($prev.At) { ", $($prev.At)" })): $(if ($prev.Summary) { $prev.Summary } else { '(sem resumo)' })$(if ($prev.Ref) { " — $($prev.Ref)" }). Aplique a decisão; não pergunte de novo. Se algo mudou desde então, -NewFact ""<o que mudou>"". Recusa registrada ($rid)." 3
}
# Assunto novo numa parte que já tem decisões: diga por que é outro assunto.
$known = @(Get-ImpasseSubjects $Root $P | Where-Object { $_ -ne $Sj })
if ($known.Count -and -not $prev -and -not $Distinct.Trim()) {
    Fail "$P já tem decisões sobre: $($known -join ', '). Se o impasse é um desses, use o mesmo -Subject (e o raise mostra a decisão); se é outro, -Distinct ""<por que é outro assunto>""."
}
# Evidência do tipo.
switch ([string]$t.evidence) {
    'detail' { if (-not $Detail.Trim()) { Fail "o tipo '$($t.type)' pede -Detail: $($t.detailLabel)." } }
    'ladder' { if (-not $Detail.Trim()) { Fail "o tipo '$($t.type)' sobe só depois do degrau 1 (R25): -Detail com $($t.detailLabel)." } }
    'consulted' { if ($Consulted -notmatch '(?i)§\s*7\s*\d+|\bD-\d+\b|\bS\d+-I\d+\b|\bB-\d+-I\d+\b|\breview\b') { Fail "o tipo '$($t.type)' pede em -Consulted a decisão aceita que ele contradiz ('§7 N', 'D-k', o id do impasse ou 'review S<n>')." } }
    'quote' { if ($Quote.Trim().Length -lt 8) { Fail "o tipo '$($t.type)' pede -Quote com a frase do stakeholder (pelo menos 8 caracteres) — a G24 confere que ela está numa fala dele nesta sessão." } }
    'gate' { if ($Gate -notin '①', '③', '1', '3', 'review', 'sprint0', 'fix-adjust', 'debt') { Fail "o tipo 'gate' pede -Gate ① · ③ · review · sprint0 · fix-adjust · debt." } }
}
if ($t.type -eq 'strategic' -and $Detail -notmatch '^(?i)\s*(stack|provider|cost|license|adr)\b') { Fail "o tipo 'strategic' pede -Detail começando pela categoria: stack · provider · cost · license · adr." }
if ($From -and $From -notmatch '^(S\d+|B-\d+)-I\d+$') { Fail "-From '$From' — use o id de um impasse (S7-I3, B-002-I1)." }

# O dono.
$owner = [string]$t.owner; $ownerLine = ''
if ($owner -eq 'file-owner') {
    if (-not $Path) { Fail "o tipo 'record' pede -Path <arquivo> — o dono vem do hooks/ownership.json." }
    $hit = Find-OwnershipRule (($Path -replace '\\', '/').TrimStart('/'))
    if ($hit -and @($hit.Writers).Count) { $owner = [string]@($hit.Writers)[0]; $ownerLine = Get-AgentDispatchText $Root $owner }
    else { $owner = 'routine'; $ownerLine = 'a sessão principal escreve (arquivo sem papel dono)' }
} elseif ($owner -notin 'stakeholder', 'routine') { $ownerLine = Get-AgentDispatchText $Root $owner }

$iid = Get-NextImpasseId $tr
$ev = [ordered]@{ id = $iid; event = 'raise'; at = $nowS; origin = $Origin.Trim(); type = $t.type; part = $P; subject = $Sj; owner = $owner; reaches = [string]$t.reachesStakeholder; text = $Text.Trim(); consulted = $Consulted.Trim() }
foreach ($kv in @(@{ k = 'detail'; v = $Detail }, @{ k = 'newFact'; v = $NewFact }, @{ k = 'from'; v = $From }, @{ k = 'distinct'; v = $Distinct }, @{ k = 'quote'; v = $Quote }, @{ k = 'gate'; v = $Gate }, @{ k = 'path'; v = $Path })) { if (([string]$kv.v).Trim()) { $ev[$kv.k] = ([string]$kv.v).Trim() } }
if ($prev) { $ev['previous'] = $prev.Id }
# v3.66.0 (item J, R34): o que sobe, em projeto com Identificador remoto, grava antes a pendência dentro da §7, com o prefixo.
$pend = $null
if ($escal) { $pend = Add-ImpassePending $Root $tr.Id $P $Text.Trim() $Sj $(if ($Detail) { $Detail.Trim() } else { "impasse $iid" }) }
if ($pend) { $ev['pending'] = $pend.N; $ev['prefix'] = $pend.Prefix }
Add-ImpasseEvent $tr.Path $ev

# Falha do plugin: a ocorrência vai ao note.md (o /review a leva ao plugin).
if ($t.type -eq 'plugin-failure') {
    $np = Join-Path $tp 'note.md'
    # v3.67.0: [plugin] no início — o /po analyze pula o item (não é pedido do stakeholder) e ele fica para o /review.
    $line = "`n- [plugin] **Ocorrência de plugin** ($nowS, $iid, $P): $($Text.Trim()) — $($Detail.Trim())`n"
    try { [System.IO.File]::AppendAllText($np, $line, (New-Object System.Text.UTF8Encoding($false))) } catch { }
}

if (-not $escal) {
    Update-Board $tr
    Out "impasse raise: $iid · $($t.type) — fica no time: $(Get-ImpasseOwnerName $owner). Registrado em $($tr.Rel)/team-decisions.jsonl$(if ($tr.Preparing) { ' (o sprint em preparação; a Planning herda)' })."
    if ($owner -eq 'routine') { Out "  é passo do roteiro: quem perguntou executa e informa em uma linha — sem formulário ao stakeholder." }
    elseif ($ownerLine) { Out "  dono: $ownerLine — prompt: ""$($Text.Trim())$(if ($Detail) { " ($($Detail.Trim()))" }) — impasse $iid; decida, grave no seu documento e devolva a decisão em uma frase e o lugar onde gravou.""" }
    if ($t.type -eq 'plugin-failure') { Out "  ocorrência registrada em .team-project/note.md (item com [plugin] no início: o /po analyze não o trata). Siga pelo caminho do script, se há; se a ação ainda precisa de autorização de fora, raise -Type external-action com o comando exato (uma vez)." }
    Out "  ao voltar: impasse.ps1 close -Id $iid -Summary ""<a decisão>"" -Ref ""<arquivo>#<âncora>"""
    exit 0
}

# Sobe ao stakeholder: a rota da G24, com o texto simples de onde o formulário parte.
Set-AskRoute $Root $t.type $P $Text.Trim() -NoRegister
Add-AskRoutePlain "$($Text.Trim())$(if ($Detail) { " — $($Detail.Trim())" })"
try {
    $arp = Join-Path $tp '.ask-route'; $arj = Read-Text $arp | ConvertFrom-Json
    $arj | Add-Member -NotePropertyName impasse -NotePropertyValue $iid -Force
    $arj | Add-Member -NotePropertyName origem -NotePropertyValue 'impasse' -Force
    if ($Quote) { $arj | Add-Member -NotePropertyName quote -NotePropertyValue $Quote.Trim() -Force }
    if ($pend) { $arj | Add-Member -NotePropertyName prefix -NotePropertyValue $pend.Prefix -Force; $arj | Add-Member -NotePropertyName pendencia -NotePropertyValue $pend.N -Force }
    [System.IO.File]::WriteAllText($arp, ($arj | ConvertTo-Json -Compress), (New-Object System.Text.UTF8Encoding($false)))
} catch { }
Update-Board $tr
Out "impasse raise: $iid · $($t.type) — sobe a você: $($t.plain). Rota gravada (.team-project/.ask-route): um formulário (R22 e H1: o problema simples, um exemplo, as opções com a recomendação primeiro e 'Pedir mais contexto' por último)."
if ($pend) { Out "  R34: pendência $($pend.N) gravada na §7 do README — a pergunta começa com $($pend.Prefix) (a G3 confere)." }
Out "  ao responder: impasse.ps1 close -Id $iid -Summary ""<a escolha dele>"" -Ref "".team-project/README.md#§7 $(if ($pend) { $pend.N } else { '<N>' })""$(if ($pend) { ' (marca a pendência como resolvida)' })"
exit 0
