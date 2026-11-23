# v3.65.14 (J) — o git do sprint e do fix: a branch do run, e no fechamento o commit da documentação, o push e o texto do PR.
# Uso (na raiz do projeto, pela SESSÃO — nunca por subagente: o push é ação de fora):
#   powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/git-flow.ps1" begin  [-Track sprint|fix] [-Id <n|B-001>]
#   powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/git-flow.ps1" finish [-Track sprint|fix] [-Id <n|B-001>] [-Title "<objetivo>"]
# Sem -Track/-Id, lê o .team-project/.active-run (e, no sprint, o "Sprint corrente" do README).
#   begin  → cria a branch feat/sprint-<n> ou fix/<id> a partir da base (guards.json → git.base, padrão develop; sem ela, main)
#            ou volta a ela; com alteração pendente fora de .team-project/, não troca e avisa (o run segue na branch atual).
#   finish → commit "docs: …" dos caminhos de git.docsPaths que estão pendentes, git push -u origin <branch> (git.push) e o
#            título e o corpo do PR para a base, na tela e em .team-project/pr/<branch>.md, com o link de abertura (GitHub).
# O commit de cada Task é do run.ps1 done (Save-TaskCommit), como antes. Exit 0 · 2 = uso.
param(
    [Parameter(Position = 0, Mandatory = $true)][ValidateSet('begin', 'finish')][string]$Action,
    [ValidateSet('', 'sprint', 'fix')][string]$Track = '',
    [string]$Id = '',
    [string]$Title = '',
    [string]$Root = (Get-Location).Path
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
. (Join-Path $PSScriptRoot '..\..\hooks\common.ps1')   # Test-GlobMatch (git.docsPaths)
$tp = Join-Path $Root '.team-project'
function Say([string]$T) { [Console]::Out.WriteLine($T) }

if (-not $Track -or -not $Id) {
    $ar = Join-Path $tp '.active-run'
    if (Test-Path -LiteralPath $ar) { try { $j = Read-Text $ar | ConvertFrom-Json; if (-not $Track) { $Track = [string]$j.trilha }; if (-not $Id) { $Id = [string]$j.id } } catch { } }
}
if (-not $Track) { $Track = 'sprint' }
if (-not $Id -and $Track -eq 'sprint') {
    $rp = Join-Path $tp 'README.md'
    if (Test-Path -LiteralPath $rp) { $m = [regex]::Match((Read-Text $rp), $script:SprintLineRe); if ($m.Success) { $Id = $m.Groups[1].Value } }
}
if (-not $Id) { [Console]::Error.WriteLine('git-flow: sem -Id e sem .active-run — diga o sprint (-Id 7) ou o fix (-Track fix -Id B-002).'); exit 2 }

if ($Action -eq 'begin') {
    $r = Invoke-GitBegin $Root $Track $Id
    foreach ($l in $r.Lines) { Say $l }
    if (-not $r.Lines.Count -and $r.Branch) { Say "git: já na branch $($r.Branch)" }
    exit 0
}

# finish: o que ficou pendente e o veredito, no sprint.
$pending = @(); $verdict = ''
if ($Track -eq 'sprint') {
    $S = Join-Path $tp "sprints/$Id"
    if (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md')) {
        $pending = @(Get-SprintTasks $S | Where-Object { $_.Mark -ne $E.Done } | ForEach-Object { "$($_.Id) — $($_.Title)" })
        if (-not $Title) { $gm = [regex]::Match((Read-Text (Join-Path $S 'sprint-backlog.md')), '(?m)^\*\*(Objetivo|Meta)( do sprint)?:\*\*\s*([^\r\n]+)'); if ($gm.Success) { $Title = $gm.Groups[3].Value.Trim() } }
    }
    $vp = Join-Path $S 'validation.md'
    if (Test-Path -LiteralPath $vp) { $vm = [regex]::Match((Read-Text $vp), '(?m)^\*\*Veredito:\*\*\s*([^\r\n]+)'); if ($vm.Success) { $verdict = "veredito do portão: $($vm.Groups[1].Value.Trim())" } }
}
$r = Invoke-GitFinish $Root $Track $Id $Title $pending $verdict
foreach ($l in $r.Lines) { Say $l }
if ($r.Title) {
    $branch = Get-RunBranchName $Track $Id
    $prDir = Join-Path $tp 'pr'; New-Item -ItemType Directory -Force $prDir | Out-Null
    $prFile = Join-Path $prDir (($branch -replace '[\\/]', '-') + '.md')
    [System.IO.File]::WriteAllText($prFile, "# $($r.Title)`n`n$($r.Body)`n", (New-Object System.Text.UTF8Encoding($false)))
    Say ''
    Say "PR para $(Get-GitBase $Root) — cole no GitHub$(if ($r.Url) { " ($($r.Url))" }) · cópia em .team-project/pr/$(Split-Path $prFile -Leaf)"
    Say '----- título -----'
    Say $r.Title
    Say '----- descrição -----'
    Say $r.Body
    Say '------------------'
}
exit 0
