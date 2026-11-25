# Testes das guardas (fase 1 e fase 2): entrega a cada despachante o JSON que o harness mandaria e confere a decisão.
# Uso (na raiz do repositório-fonte): powershell -NoProfile -File scripts/checks/tests/run-guard-tests.ps1
# Saída: tabela caso · esperado · obtido · ok; exit 1 se algum caso falhar.
# v3.66.1 (item C): os casos se dividem nos grupos das seções (# ---------- vX.Y — … ----------; suite-blocks.ps1,
# Get-GuardGroups), e cada grupo roda num processo com o seu $tmp e o seu projeto falso:
#   -ListGroups              os grupos, com o número de casos
#   -Groups 3,7              só esses grupos (o run-all-tests.ps1 sobe um processo por grupo, em paralelo)
#   -CheckGroups [-Workers n] roda cada grupo sozinho e acusa o que só passa depois de outro (o estado que ele herdava
#                            passa a ser montado no Setup dele — não se juntam grupos para esconder a dependência)
#   -ResultFile <json>       grava { fail, rows } para o run-all-tests.ps1
# Sem parâmetro, tudo em série, como antes.
param([string]$Groups = '', [string]$ResultFile = '', [switch]$ListGroups, [switch]$CheckGroups, [int]$Workers = 4)

$ErrorActionPreference = 'Stop'
$root  = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$hooks = Join-Path $root 'hooks'
$tmp   = Join-Path ([System.IO.Path]::GetTempPath()) ('team-guards-' + [guid]::NewGuid().ToString('N').Substring(0, 8))

# v3.64.1: prazo por caso (TEAM_TEST_CHECK_TIMEOUT_S, padrão 240 s) — a sentinela encerra o hook preso e o caso falha com
# TEMPO ESGOTADO, em vez de segurar a suíte.
if (-not $env:TEAM_TEST_CHECK_TIMEOUT_S) { $env:TEAM_TEST_CHECK_TIMEOUT_S = '240' }
New-Item -ItemType Directory -Force $tmp | Out-Null
$timeoutLog = Join-Path $tmp 'timeouts.log'
$watchdog = Start-Process powershell -WindowStyle Hidden -PassThru -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', (Join-Path $PSScriptRoot 'check-watchdog.ps1'), '-Parent', $PID, '-TimeoutSec', $env:TEAM_TEST_CHECK_TIMEOUT_S, '-Log', $timeoutLog)
function Get-TimeoutMark { if (Test-Path -LiteralPath $timeoutLog) { return [System.IO.File]::ReadAllText($timeoutLog) }; return '' }

# Projeto falso, com git e .team-project/ (o G1 consulta o stage).
$proj = Join-Path $tmp 'projeto'
New-Item -ItemType Directory -Force (Join-Path $proj '.team-project') | Out-Null
& git -C $proj init -q 2>$null
Set-Content -LiteralPath (Join-Path $proj 'app.txt') 'produto' -Encoding UTF8
Set-Content -LiteralPath (Join-Path $proj '.team-project/README.md') 'local' -Encoding UTF8

# Projeto sem .team-project/: as guardas por papel ficam caladas.
$bare = Join-Path $tmp 'sem-time'
New-Item -ItemType Directory -Force $bare | Out-Null

# Cópia instalada falsa (sem .git) para o G2.
$installed = Join-Path $tmp 'cache/team/3.39.0'
New-Item -ItemType Directory -Force $installed | Out-Null

function Invoke-Hook([string]$Script, [hashtable]$Payload, [hashtable]$Env = @{}, [string]$Raw = '') {
    if ($Raw) { $json = $Raw } else {
        $Payload['cwd'] = $proj
        $json = $Payload | ConvertTo-Json -Depth 8 -Compress
    }
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'powershell'
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$(Join-Path $hooks $Script)`""
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $psi.StandardErrorEncoding = [System.Text.Encoding]::UTF8
    $psi.EnvironmentVariables['CLAUDE_PROJECT_DIR'] = $proj
    $psi.EnvironmentVariables['CLAUDE_PLUGIN_ROOT'] = $root
    foreach ($k in $Env.Keys) { $psi.EnvironmentVariables[$k] = $Env[$k] }
    $p = [System.Diagnostics.Process]::Start($psi)
    $bytes = (New-Object System.Text.UTF8Encoding($false)).GetBytes($json)
    $p.StandardInput.BaseStream.Write($bytes, 0, $bytes.Length)
    $p.StandardInput.Close()
    $out = $p.StandardOutput.ReadToEnd()
    $err = $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    return @{ Code = $p.ExitCode; Out = $out; Err = $err }
}

function Opt([string]$Label) { @{ label = $Label; description = 'x' } }
# v3.66.0 (R36): a G24 vale em toda sessão principal — o caso que testa a forma do formulário (G3, H1, G18) grava antes a
# rota fresca, como o impasse.ps1 raise faria; o que testa a rota (G24) monta a sua.
$FreshRoute = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"scope","task":"T-1","motivo":"teste","at":"' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }

# v3.66.1 (item C): cada grupo (seção do $cases) roda também sozinho, num processo com o projeto falso recém-montado. O grupo
# cujos casos supõem um run em curso declara aqui o estado de partida, que o executor monta antes do primeiro caso dele — em
# série e sozinho. Antes, esse estado vinha dos casos de outro grupo, e 16 grupos só passavam depois dos anteriores.
#   -Task T-003|T-001 (o .active-task e o plano dela) · -Run <sprint> (o .active-run; -NoRun apaga) · -Guards <json> ('' apaga
#   o guards.json; '*' deixa) · -Backlog <chave de $Backlogs> (o sprint-backlog.md do sprint do run)
$Backlogs = @{
    'T2-elegivel'      = "## História H-1 — x`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2705)) T-1 | a | — |`n| $([char]::ConvertFromUtf32(0x2B1C)) T-2 | b | T-1 |`n| $([char]::ConvertFromUtf32(0x2B1C)) T-3 | c | T-9 |`n"
    'T3-bloqueada'     = "## História H-1 — x`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2B1C)) T-3 | c | T-9 |`n"
    'T3-rastreabilidade' = "## História H-1 — x`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2B1C)) T-3 | c | — |`n`n## Rastreabilidade`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2B1C)) T-99 | fantasma | — |`n"
    'portao-Q-S7'      = "## História H-1 — x`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2705)) T-1 | a | — |`n`n## Correção do portão — sprint 7`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2B1C)) Q-S7b | b | Q-S7 |`n| $([char]::ConvertFromUtf32(0x2B1C)) Q-S7 | achados do portão | T-1 |`n"
}
$RunBase = { param([string]$Task = 'T-003', [string]$Run = '1', [switch]$NoRun, [string]$Guards = '*', [string]$Backlog = '')
    $tp = Join-Path $proj '.team-project'; $u = New-Object System.Text.UTF8Encoding($true)
    New-Item -ItemType Directory -Force (Join-Path $tp 'sprints/1/plan'), (Join-Path $tmp 'transcripts') | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $tp 'sprints/1/plan/T-001-x.md'), "# Plano — T-001`n**História:** H-001`n**Arquivos tocados:** ``src/a.cs``,`n``tests/ATests.cs``, ``src/pages/plantio.page.ts```n`n## 1. Objetivo`n", $u)
    [System.IO.File]::WriteAllText((Join-Path $tp 'sprints/1/plan/T-003-z.md'), "# Plano — T-003`n**Arquivos tocados:** ``src/e.cs```n``tests/ETests.cs```n`n**Arquivos protegidos:** ver §12`n`n## 12. Arquivos protegidos`n| ``src/z.cs`` | x |`n", $u)
    $plan = if ($Task -eq 'T-001') { 'T-001-x.md' } else { 'T-003-z.md' }
    Set-Content -LiteralPath (Join-Path $tp '.active-task') ('{ "trilha": "sprint", "id": "' + $Task + '", "plano": ".team-project/sprints/1/plan/' + $plan + '" }') -Encoding UTF8
    if ($NoRun) { Remove-Item -LiteralPath (Join-Path $tp '.active-run') -Force -ErrorAction SilentlyContinue }
    else { Set-Content -LiteralPath (Join-Path $tp '.active-run') ('{ "trilha": "sprint", "id": "' + $Run + '", "desde": "2026-10-06 10:00" }') -Encoding UTF8 }
    if ($Guards -eq '') { Remove-Item -LiteralPath (Join-Path $tp 'guards.json') -Force -ErrorAction SilentlyContinue }
    elseif ($Guards -ne '*') { Set-Content -LiteralPath (Join-Path $tp 'guards.json') $Guards -Encoding UTF8 }
    if ($Backlog) { New-Item -ItemType Directory -Force (Join-Path $tp "sprints/$Run") | Out-Null; [System.IO.File]::WriteAllText((Join-Path $tp "sprints/$Run/sprint-backlog.md"), $Backlogs[$Backlog], $u) }
}
$npmTest = '{ "runCommands": ["npm test"] }'
$GroupBase = [ordered]@{
    'v3.44 — G14 run sem trava'      = { & $RunBase -NoRun -Guards '' }
    'v3.51.2 — negações do fix run'  = { & $RunBase -Guards $npmTest }
    'v3.47.1 — G14'                  = { & $RunBase -Guards $npmTest }
    'v3.48 — achados'                = { & $RunBase -Guards $npmTest }
    'v3.47 (M2)'                     = { & $RunBase -Guards '' }
    'v3.47 (M3)'                     = { & $RunBase -Task T-001 -Guards '' }
    'v3.57.0 — o watcher'            = { & $RunBase -Task T-001 -Run 7 -Guards '{ "disabled": [] }' -Backlog 'T2-elegivel' }
    'v3.57.2 (note.md item 23'       = { & $RunBase -Task T-001 -Run 7 -Guards '{ "disabled": [] }' -Backlog 'T2-elegivel' }
    'v3.65.7 — G20'                  = { & $RunBase -Task T-001 -Run 7 -Guards '{ "disabled": [] }' -Backlog 'T3-bloqueada' }
    'v3.65.11 —'                     = { & $RunBase -Task T-001 -Run 7 -Guards '{ "disabled": [] }' -Backlog 'T3-bloqueada' }
    'v3.51.4 —'                      = { & $RunBase -Task T-001 -Run 7 -Guards '{ "disabled": [] }' -Backlog 'T3-bloqueada' }
    'v3.52 — orquestrador'           = { & $RunBase -Task T-001 -Run 7 -Guards '' -Backlog 'T3-rastreabilidade' }
    'v3.52.2 —'                      = { & $RunBase -Task T-001 -Run 7 -Guards '' -Backlog 'T3-rastreabilidade' }
    'v3.53.1 —'                      = { & $RunBase -Task T-001 -Run 7 -Guards '' -Backlog 'portao-Q-S7' }
    'v3.53.5 —'                      = { & $RunBase -Task T-001 -Run 7 -Guards '' -Backlog 'portao-Q-S7' }
    'v3.64.1 (sprint 6'              = { & $RunBase -Task T-001 -Run 7 -Guards '{ "runCommands": ["npm test"], "targets": { "android": { "package": "br.x", "repair": "docker restart horta-emulador; adb connect localhost:5555" }, "web": { "url": "http://x" } } }' -Backlog 'portao-Q-S7' }
}

$cases = @(
    @{ Name = 'G1 commit com .team-project no stage'; Script = 'pre-tool.ps1'; Expect = 2; Setup = { & git -C $proj add -f .team-project/README.md 2>$null }
       Payload = @{ tool_name = 'PowerShell'; tool_input = @{ command = 'git commit -m "x"' } } },
    @{ Name = 'G1 commit só com produto'; Script = 'pre-tool.ps1'; Expect = 0; Setup = { & git -C $proj reset -q 2>$null; & git -C $proj add app.txt 2>$null }
       Payload = @{ tool_name = 'PowerShell'; tool_input = @{ command = 'git commit -m "x"' } } },
    @{ Name = 'G1 git add -f .team-project'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Bash'; tool_input = @{ command = 'git add -f .team-project/note.md' } } },
    @{ Name = 'G1 comando sem git'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; tool_input = @{ command = 'Get-ChildItem' } } },
    @{ Name = 'G2 Write na cópia instalada'; Script = 'pre-tool.ps1'; Expect = 2; Env = @{ CLAUDE_PLUGIN_ROOT = $installed }
       Payload = @{ tool_name = 'Write'; tool_input = @{ file_path = (Join-Path $installed 'roles/x.md'); content = 'x' } } },
    @{ Name = 'G2 Write no repositório-fonte (tem .git)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Edit'; tool_input = @{ file_path = (Join-Path $root 'roles/x.md'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G2 Write fora do plugin'; Script = 'pre-tool.ps1'; Expect = 0; Env = @{ CLAUDE_PLUGIN_ROOT = $installed }
       Payload = @{ tool_name = 'Write'; tool_input = @{ file_path = (Join-Path $proj 'app.txt'); content = 'x' } } },
    @{ Name = 'G3 formulário correto'; Script = 'pre-tool.ps1'; Expect = 0; Setup = $FreshRoute
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Q? Exemplo: hoje a lista aparece vazia.'; header = 'Q'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G3 sem "Pedir mais contexto" por último'; Script = 'pre-tool.ps1'; Expect = 2; Setup = $FreshRoute
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Q?'; header = 'Q'; multiSelect = $false; options = @((Opt 'Pedir mais contexto'), (Opt 'Aprovar')) }) } } },
    @{ Name = 'G3 segunda pergunta errada'; Script = 'pre-tool.ps1'; Expect = 2; Setup = $FreshRoute
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(
           @{ question = 'A?'; header = 'A'; multiSelect = $false; options = @((Opt 'Sim'), (Opt 'pedir mais contexto')) },
           @{ question = 'B?'; header = 'B'; multiSelect = $false; options = @((Opt 'Sim'), (Opt 'Não')) }) } } },
    @{ Name = 'G4 saída grande vira aviso'; Script = 'post-tool.ps1'; Expect = 0; ExpectOut = 'G4'
       Payload = @{ tool_name = 'PowerShell'; tool_input = @{ command = 'x' }; tool_response = @{ stdout = ((1..400) -join "`n") } } },
    @{ Name = 'G4 saída pequena, silêncio'; Script = 'post-tool.ps1'; Expect = 0; ExpectOut = ''
       Payload = @{ tool_name = 'PowerShell'; tool_input = @{ command = 'x' }; tool_response = @{ stdout = 'ok' } } },
    @{ Name = 'G4 silencioso dentro do operator'; Script = 'post-tool.ps1'; Expect = 0; ExpectOut = ''
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'x' }; tool_response = @{ stdout = ((1..400) -join "`n") } } },
    @{ Name = 'G13 autoteste';Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'Guardas do time'
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'G3 R34 sem Identificador remoto: prefixo não exigido'; Script = 'pre-tool.ps1'; Expect = 0; Setup = $FreshRoute
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o pacote? Exemplo: a tela de exportação.'; header = 'P'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G3 R34 com ID, pergunta sem prefixo'; Script = 'pre-tool.ps1'; Expect = 2
       Setup = { & $FreshRoute; Set-Content -LiteralPath (Join-Path $proj '.team-project/README.md') "# Contexto`n`n## 1. O produto`n**Identificador remoto:** ACME`n**Conta remota:** pessoal`n`n## 7. Decisões pendentes do stakeholder`n`n1. [ACME · S4 · ③ pacote] Aprova o pacote? — material: sprint-backlog.md — 2026-10-03 10:00`n`n## 7a. Registro de consultores`n" -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o pacote?'; header = 'P'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G3 R34 prefixo sem pendência em §7'; Script = 'pre-tool.ps1'; Expect = 2; Setup = $FreshRoute
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = '[ACME · S4 · ④ H-012] Aceita a H-012?'; header = 'P'; multiSelect = $false; options = @((Opt 'Aceita'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G3 R34 prefixo com pendência em §7'; Script = 'pre-tool.ps1'; Expect = 0; Setup = $FreshRoute
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = '[ACME · S4 · ③ pacote] Aprova o pacote? Exemplo: a tela de exportação.'; header = 'P'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    # ---------- Fase 2 (v3.42) — agent_type no formato medido pela sonda: team:<papel> ----------
    @{ Name = 'G7 dev dispara outro papel'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:developer'; tool_input = @{ subagent_type = 'team:architect'; prompt = 'x' } } },
    @{ Name = 'G7 QA dispara o operator'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:quality-assurance'; tool_input = @{ subagent_type = 'team:operator'; prompt = "Chamador: qa T-041`nx" } } },
    @{ Name = 'G7 sessão principal dispara o dev'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; prompt = 'x' } } },
    @{ Name = 'G7 Security Engineer dispara o operator (v3.58)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:security-engineer'; tool_input = @{ subagent_type = 'team:operator'; prompt = "Chamador: sec blackbox`nx" } } },
    @{ Name = 'G7 Security Engineer dispara outro papel: nega'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:security-engineer'; tool_input = @{ subagent_type = 'team:developer'; prompt = 'x' } } },
    @{ Name = 'G9 dev sem .active-task'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); content = 'x' } } },
    @{ Name = 'G9 dev em arquivo do plano'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = {
           New-Item -ItemType Directory -Force (Join-Path $proj '.team-project/sprints/1/plan') | Out-Null
           Set-Content -LiteralPath (Join-Path $proj '.team-project/sprints/1/plan/T-001-x.md') "# Plano — T-001`n**História:** H-001`n**Arquivos tocados:** ``src/a.cs``,`n``tests/ATests.cs```n`n## 1. Objetivo`n" -Encoding UTF8
           Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-task') '{ "trilha": "sprint", "id": "T-001", "plano": ".team-project/sprints/1/plan/T-001-x.md" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); content = 'x' } } },
    @{ Name = 'G9 dev fora do plano'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/b.cs'); old_string = 'a'; new_string = 'b' } } },
    # v3.56.0 H3 (sprint 5 do garden #26, #58): saída de build ignorada pelo git não é produto — a G9 libera e registra.
    @{ Name = 'G9 (v3.56.0) saída ignorada pelo git (dist/) fora do plano: liberada e registrada'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.gitignore') "/dist`n" -Encoding ASCII; New-Item -ItemType Directory -Force (Join-Path $proj 'dist') | Out-Null; Remove-Item -LiteralPath (Join-Path $proj '.team-project/guards.log') -Force -ErrorAction SilentlyContinue }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'dist/x.apk'); content = 'x' } }
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G9 liberado (ignorado pelo git)*dist/x.apk*' } },
    @{ Name = 'G9 (v3.56.0) Remove-Item de saída ignorada (renomear/apagar o APK): liberado'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'Remove-Item -Force dist/app-debug.apk' } } },
    @{ Name = 'G9 (v3.56.0) com .gitignore, src/ fora do plano continua negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G9'
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/x.ts'); content = 'x' } } },
    @{ Name = 'G9 (v3.56.0) ignorado e em protectedPaths: a G5 nega antes'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G5'
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'dist/.editorconfig'); content = 'x' } }
       Check = { Remove-Item -LiteralPath (Join-Path $proj '.gitignore') -Force -ErrorAction SilentlyContinue; $true } },
    # v3.54.1 (carta do sprint 5 do garden, item 2): margem stub — teste que já existe e monta um arquivo do plano.
    @{ Name = 'G9 (v3.54.1) margem stub: spec existente que monta arquivo do plano liberado'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = {
           Set-Content -LiteralPath (Join-Path $proj '.team-project/sprints/1/plan/T-001-x.md') "# Plano — T-001`n**História:** H-001`n**Arquivos tocados:** ``src/a.cs``,`n``tests/ATests.cs``, ``src/pages/plantio.page.ts```n`n## 1. Objetivo`n" -Encoding UTF8
           New-Item -ItemType Directory -Force (Join-Path $proj 'src/pages') | Out-Null
           Set-Content -LiteralPath (Join-Path $proj 'src/pages/filtro.render.spec.ts') "import { PlantioPage } from './plantio.page';`ndescribe('x', () => {});" -Encoding UTF8
           Set-Content -LiteralPath (Join-Path $proj 'src/pages/outro.spec.ts') "import { Outra } from './outra.page';" -Encoding UTF8 }
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/pages/filtro.render.spec.ts'); old_string = 'x'; new_string = 'y' } } },
    @{ Name = 'G9 (v3.54.1) margem stub: spec que não monta arquivo do plano negado'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/pages/outro.spec.ts'); old_string = 'x'; new_string = 'y' } } },
    @{ Name = 'G9 (v3.54.1) margem stub: spec novo (não existe) negado'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/pages/novo.spec.ts'); content = "import { PlantioPage } from './plantio.page';" } } },
    @{ Name = 'G9 (v3.54.1) margem stub: arquivo de produção que cita o do plano segue negado'; Script = 'pre-tool.ps1'; Expect = 2
       Setup = { Set-Content -LiteralPath (Join-Path $proj 'src/pages/menu.page.ts') "import { PlantioPage } from './plantio.page';" -Encoding UTF8 }
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/pages/menu.page.ts'); old_string = 'x'; new_string = 'y' } } },
    @{ Name = 'G9 dev Set-Content fora do plano'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "Set-Content -Path src/b.cs -Value 'x'" } } },
    @{ Name = 'G9 dev log redirecionado (R28)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'dotnet build *> build.log' } } },
    @{ Name = 'G9 dev New-Item no plano'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'New-Item -ItemType File -Force tests/ATests.cs' } } },
    # v3.44.2 — achados do guards.log do primeiro sprint run (falso positivo Env: e "erro" IsPathRooted)
    @{ Name = 'G9 dev em Env: não é arquivo'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "Set-Content Env:MIG02_PROVA '1'; npm test; Remove-Item Env:MIG02_PROVA" } } },
    @{ Name = 'G9 dev Remove-Item -Path Env:\ não é arquivo'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'Remove-Item -Path Env:\MIG02_PROVA -ErrorAction SilentlyContinue' } } },
    @{ Name = 'Alvo com caractere inválido não derruba o hook'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'Write-Output "List<T>" >"x<y>"' } } },
    @{ Name = 'Caractere inválido não esconde a escrita seguinte'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G9'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "Write-Output 'a' >`"<td>`"; Set-Content -Path src/b.cs -Value 'x'" } } },
    @{ Name = 'G6 dev acrescenta [Skip'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'tests/ATests.cs'); old_string = '[Fact]'; new_string = '[Fact(Skip = "x")]' } } },
    @{ Name = 'G6 dev edita teste sem pular'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'tests/ATests.cs'); old_string = 'Assert.True(a)'; new_string = 'Assert.False(a)' } } },
    @{ Name = 'G9 trilha fix: arquivo da F-ID'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = {
           New-Item -ItemType Directory -Force (Join-Path $proj '.team-project/fixes/B-001') | Out-Null
           Set-Content -LiteralPath (Join-Path $proj '.team-project/fixes/B-001/plan.md') "# B-001 · mini-planos`n`n## F-001 · x`n### Arquivos`n- produção: ``src/c.ts```n- teste: ``src/c.test.ts```n`n## F-002 · y`n### Arquivos`n- produção: ``src/d.ts```n" -Encoding UTF8
           Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-task') '{ "trilha": "fix", "id": "F-001", "plano": ".team-project/fixes/B-001/plan.md" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/c.ts'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G9 trilha fix: arquivo de outra F-ID'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/d.ts'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G5 dev escreve .editorconfig'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj '.editorconfig'); content = 'x' } } },
    @{ Name = 'G5 QA Out-File em workflow de CI'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = "'x' | Out-File .github/workflows/ci.yml" } } },
    @{ Name = 'G5 deny cita a rota da sessão (passo 3)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'sprint-run.md passo 3'
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj '.github/workflows/ci.yml'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G9 §12 do plano não entra no escopo do dev'; Script = 'pre-tool.ps1'; Expect = 2
       Setup = {
           Set-Content -LiteralPath (Join-Path $proj '.team-project/sprints/1/plan/T-003-z.md') "# Plano — T-003`n**Arquivos tocados:** ``src/e.cs```n``tests/ETests.cs```n`n**Arquivos protegidos:** ver §12`n`n## 12. Arquivos protegidos`n| ``src/z.cs`` | x |`n" -Encoding UTF8
           Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-task') '{ "trilha": "sprint", "id": "T-003", "plano": ".team-project/sprints/1/plan/T-003-z.md" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/z.cs'); content = 'x' } } },
    @{ Name = 'G9 plano com Arquivos protegidos: teste listado liberado'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'tests/ETests.cs'); content = 'x' } } },
    @{ Name = 'G5 sessão principal escreve .editorconfig'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; tool_input = @{ file_path = (Join-Path $proj '.editorconfig'); content = 'x' } } },
    @{ Name = 'G8 PO escreve plano do Arquiteto'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Write'; agent_type = 'team:product-owner'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/1/plan/T-001-x.md'); content = 'x' } } },
    @{ Name = 'G8 Arquiteto escreve o plano'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/1/plan/T-002-y.md'); content = 'x' } } },
    @{ Name = 'G8 dev grava o relatório de entrega (v3.49)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/1/delivery/T-001.md'); content = 'x' } } },
    @{ Name = 'G8 QA no relatório de entrega do dev'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:quality-assurance'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/1/delivery/T-001.md'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G8 dev grava delivery.md do bloco fix'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj '.team-project/fixes/B-001/delivery.md'); content = 'x' } } },
    @{ Name = 'G8 dev no plan.md do bloco fix'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj '.team-project/fixes/B-001/plan.md'); content = 'x' } } },
    @{ Name = 'G8 Arquiteto grava a quebra em Tasks (v3.49)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj '.team-project/architect/breakdown/S1.md'); content = 'x' } } },
    @{ Name = 'G8 PO acrescenta Aceite em review.md'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:product-owner'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/1/review.md'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G8 Security Engineer grava o relatório (v3.58)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:security-engineer'; tool_input = @{ file_path = (Join-Path $proj '.team-project/security/2026-11-12/FINDINGS.md'); content = 'x' } } },
    @{ Name = 'G8 QA no relatório de segurança do Security Engineer'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Write'; agent_type = 'team:quality-assurance'; tool_input = @{ file_path = (Join-Path $proj '.team-project/security/2026-11-12/FINDINGS.md'); content = 'x' } } },
    @{ Name = 'G8 Security Engineer em código-fonte: nega (reporta, não corrige)'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:security-engineer'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G8 SM em arquivo sem linha na matriz'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Write'; agent_type = 'team:scrum-master'; tool_input = @{ file_path = (Join-Path $proj '.team-project/rascunho.md'); content = 'x' } } },
    @{ Name = 'G8 QA escreve código-fonte'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:quality-assurance'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G8 Arquiteto em código-fonte sem spike: nega com a rota'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'scratchpad'
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj 'src/spike.cs'); content = 'x' } } },
    @{ Name = 'G8 Arquiteto com .active-spike'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = ''
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-spike') '{ "id": "S-001", "motivo": "spike S-001", "desde": "2026-10-06 10:00" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj 'src/spike.cs'); content = 'x' } } },
    @{ Name = 'G8 Arquiteto Set-Content em código, sem spike'; Script = 'pre-tool.ps1'; Expect = 2
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-spike') -Force }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:architect'; tool_input = @{ command = "Set-Content -Path src/relogio.service.spec.ts -Value 'x'" } } },
    @{ Name = 'G8 Arquiteto no scratchpad (fora do projeto)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $tmp 'scratchpad/relogio.service.ts'); content = 'x' } } },
    @{ Name = 'G8 QA com log redirecionado'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'npm test *> test.log' } } },
    @{ Name = 'G8 PO escreve em docs/'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:product-owner'; tool_input = @{ file_path = (Join-Path $proj 'docs/sdd/01-requirements.md'); content = 'x' } } },
    @{ Name = 'G8 UX escreve o protótipo'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:user-experience'; tool_input = @{ file_path = (Join-Path $proj '.team-project/user-experience/prototype/index.html'); content = 'x' } } },
    @{ Name = 'G11 operator na pasta do job'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:operator'; tool_input = @{ file_path = (Join-Path $proj '.team-project/operator/1/build/report.md'); content = 'x' } } },
    @{ Name = 'G11 operator no código'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Write'; agent_type = 'team:operator'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); content = 'x' } } },
    @{ Name = 'G8 /review: SM edita card de agente'; Script = 'pre-tool.ps1'; Expect = 2; Env = @{ CLAUDE_PROJECT_DIR = $root }
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:scrum-master'; tool_input = @{ file_path = (Join-Path $root 'agents/developer.md'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G8 /review: QA edita o próprio roteiro'; Script = 'pre-tool.ps1'; Expect = 0; Env = @{ CLAUDE_PROJECT_DIR = $root }
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:quality-assurance'; tool_input = @{ file_path = (Join-Path $root 'roles/quality-assurance/README.md'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G8 /review: PO escreve no changelog do processo'; Script = 'pre-tool.ps1'; Expect = 0; Env = @{ CLAUDE_PROJECT_DIR = $root }
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:product-owner'; tool_input = @{ file_path = (Join-Path $root 'roles/scrum-master/process/process-changelog.md'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'Fase 2 calada em projeto sem o time'; Script = 'pre-tool.ps1'; Expect = 0; Env = @{ CLAUDE_PROJECT_DIR = $bare }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $bare 'src/a.cs'); content = 'x' } } },
    # ---------- v3.44 — G14 run sem trava (.active-run) · G15 pedido de permissão no guards.log ----------
    @{ Name = 'G14 sem run ativo: nada liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = ''
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'git status' } } },
    @{ Name = 'G14 run ativo: git status liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "1", "desde": "2026-10-06 10:00" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'git status' } } },
    @{ Name = 'G14 leitura composta liberada'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = "git -C src diff --stat; Get-ChildItem src -Recurse | Select-String -Pattern 'a|b' | ForEach-Object { `$_.Line }" } } },
    @{ Name = 'G14 sessão principal: harness decide'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = ''
       Payload = @{ tool_name = 'PowerShell'; tool_input = @{ command = 'git status' } } },
    @{ Name = 'G14 sem runCommands: comando do projeto fica com o harness'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = ''
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'npm test' } } },
    @{ Name = 'G14 runCommands: comando do projeto liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "runCommands": ["npm test", "npx tsc"] }' -Encoding UTF8 }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'npm test -- relogio *> test.log' } } },
    @{ Name = 'G14 comando fora da lista: nega com a rota'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'runCommands'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'npm install lodash' } } },
    @{ Name = 'G14 v3.55.0 (F3): a negação aponta o formulário único (run.ps1 allow), não "reporte a quem orquestra"'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'formulário único*run.ps1 allow'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "runCommands": ["npm test"] }' -Encoding UTF8 }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'docker compose run --rm app npm test' } } },
    @{ Name = 'G14 Env: da sessão liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "Set-Content Env:MIG02_PROVA '1'; npm test; Remove-Item Env:MIG02_PROVA" } } },
    @{ Name = 'G14 escrita no registro negada'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "New-Item -Path HKCU:\Software\Prova" } } },
    @{ Name = 'G14 --no-verify negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'git commit --no-verify -m "x"' } } },
    @{ Name = 'G14 escrita em destino variável negada'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'Get-ChildItem dist | ForEach-Object { Remove-Item $_ }' } } },
    @{ Name = 'G14 QA com comando em segundo plano: nega e aponta o detach.ps1 (v3.62.2)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'encerra quando você der a resposta final*detach.ps1'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'npm test'; run_in_background = $true } } },
    # v3.62.2 (garden, Q-S6d): o Claude Code encerra o comando em segundo plano com o turno — o operator também deixa de poder.
    @{ Name = 'G14 v3.62.2: operator com comando em segundo plano: nega (antes liberado)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'detach.ps1'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'npm test *> .team-project/operator/1/suite/test.log'; run_in_background = $true } } },
    @{ Name = 'G14 v3.62.2: operator pelo detach.ps1 com comando de dentro da lista: liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = "powershell -NoProfile -File `"$root\scripts\checks\detach.ps1`" -Dir .team-project/operator/1/T-001-suite -Command `"npm test`"" } } },
    @{ Name = 'G14 v3.62.2: detach.ps1 com comando de dentro fora da lista: nega pelo trecho de dentro'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'git push'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = "powershell -NoProfile -File `"$root\scripts\checks\detach.ps1`" -Dir .team-project/operator/1/T-001-x -Command `"npm test; git push`"" } } },
    @{ Name = 'G14 v3.62.2: detach.ps1 sem -Command entre aspas: nega'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = "powershell -NoProfile -File `"$root\scripts\checks\detach.ps1`" -Dir .team-project/operator/1/T-001-x -Command npm" } } },
    # v3.65.9 (garden S6, 19:18): o operator passou o script do plugin ao detach com aspas escapadas por crase e o caminho numa
    # variável do comando de fora; a G14 partia o texto na primeira `" e o operator rodou o quality direto (órfão).
    @{ Name = 'G14 v3.65.9: detach.ps1 com script do plugin entre aspas escapadas (`") e $root do comando de fora: liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = ('$root = "' + ($root -replace '\\', '/') + '"; powershell -NoProfile -File "$root/scripts/checks/detach.ps1" -Dir .team-project/operator/1/S1-quality -Command "powershell -NoProfile -File `"$root/scripts/checks/quality.ps1`" -Id S1"') } } },
    @{ Name = 'G14 v3.65.9: detach.ps1 com aspas escapadas e comando de dentro fora da lista: nega pelo trecho de dentro'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'git push'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = ('powershell -NoProfile -File "' + ($root -replace '\\', '/') + '/scripts/checks/detach.ps1" -Dir .team-project/operator/1/x -Command "git push `"origin`" main"') } } },
    @{ Name = 'G14 v3.65.9: detach.ps1 com script FORA do plugin entre aspas escapadas: nega'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = ('powershell -NoProfile -File "' + ($root -replace '\\', '/') + '/scripts/checks/detach.ps1" -Dir .team-project/operator/1/x -Command "powershell -File `"C:/temp/evil.ps1`""') } } },
    @{ Name = 'G14 v3.62.2: detach.ps1 -Kill: liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = "powershell -NoProfile -File `"$root\scripts\checks\detach.ps1`" -Dir .team-project/operator/1/T-001-x -Kill" } } },
    @{ Name = 'G14 dev Edit no escopo liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/e.cs'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G14 Arquiteto no scratchpad liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path ([System.IO.Path]::GetTempPath()) 'claude/x/scratchpad/a.ts'); content = 'x' } } },
    @{ Name = 'G14 escrita fora do projeto negada'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'fora do projeto'
       Payload = @{ tool_name = 'Write'; agent_type = 'team:quality-assurance'; tool_input = @{ file_path = 'Z:\fora-do-projeto\x.md'; content = 'x' } } },
    @{ Name = 'G14 SM roda conferência C1'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:scrum-master'; tool_input = @{ command = "powershell -NoProfile -File `"$root\scripts\checks\close.ps1`" -Task T-001" } } },
    @{ Name = 'G14 dev roda verify.ps1 no run (v3.45.1)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "powershell -NoProfile -File `"$root\scripts\checks\verify.ps1`" -Task T-001 -Mode focused -Tests src/a.spec.ts src/b.spec.ts" } } },
    # ---------- v3.51.2 — negações do fix run (note.md itens 1, 2 e 3) ----------
    @{ Name = 'G14 verify.ps1 do plugin dentro de comando composto liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'Set-Location src; $log = "verify.log"; powershell -NoProfile -ExecutionPolicy Bypass -File "' + $root + '\scripts\checks\verify.ps1" -Task B-001 -Mode full 2>&1 | Select-Object -Last 30' } } },
    @{ Name = 'G14 script scripts/checks fora da pasta do plugin negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'fora da pasta do plugin'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'powershell -NoProfile -File "' + $proj + '\scripts\checks\verify.ps1" -Task B-001 -Mode full' } } },
    @{ Name = 'G14 Arquiteto cria pasta no scratchpad por $env:TEMP'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:architect'; tool_input = @{ command = '$d = "$env:TEMP\claude\x\scratchpad\f003"; New-Item -ItemType Directory -Force $d' } } },
    @{ Name = 'G14 Arquiteto executa arquivo do scratchpad: negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:architect'; tool_input = @{ command = 'node "$env:TEMP\claude\x\scratchpad\f003\gap1.js"' } } },
    # ---------- v3.47.1 — G14: propriedade entre parênteses, método negado, git branch de leitura, --version, trecho citado ----------
    @{ Name = 'G14 (Get-Content f).Count liberado (teto do report do operator)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = '(Get-Content .team-project/operator/1/T-001/report.md).Count; (Get-Item .team-project/operator/1/T-001/report.md).Length' } } },
    @{ Name = 'G14 (Get-Content f | Measure-Object -Line).Lines liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = '(Get-Content src/a.cs | Measure-Object -Line).Lines' } } },
    @{ Name = 'G14 método sobre o resultado negado, com o trecho citado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'chamada de método .Delete() sobre o resultado'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = '(Get-Item src/a.cs).Delete()' } } },
    @{ Name = 'G14 comando composto: nega citando só o trecho fora da lista'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'npm install lodash? (os outros trechos do comando composto passaram'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'Set-Location src; npm install lodash' } } },
    @{ Name = 'G14 git branch -a liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:architect'; tool_input = @{ command = 'git branch -a --contains HEAD' } } },
    @{ Name = 'G14 git branch -v -D negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:architect'; tool_input = @{ command = 'git branch -v -D feature/x' } } },
    @{ Name = 'G14 git branch <nome> (cria) negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'git branch novo' } } },
    @{ Name = 'G14 versão de ferramenta liberada (R26)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:architect'; tool_input = @{ command = 'node --version; npm --version; java -version' } } },
    # ---------- v3.48 — achados do guards.log do primeiro sprint do piloto (first-result/) ----------
    @{ Name = 'G8 ">" dentro de padrão entre aspas não é destino (Arquiteto)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:architect'; tool_input = @{ command = "Select-String -Path src/x.scss -Pattern 'ion-item > ion-label'" } } },
    @{ Name = 'G9 ">" dentro de código citado não é destino (dev)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "Select-String -Path src/e.cs -Pattern 'a > this.gravar(loteId, x)'" } } },
    @{ Name = 'G9 redirecionamento real fora do plano continua negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G9'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "Write-Output 'a > b' > src/b.cs" } } },
    @{ Name = 'G9 destino em variável do mesmo comando se resolve (fora do plano: nega)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'src/b.cs'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = '$p = "src/b.cs"; Set-Content -Path $p -Value x' } } },
    @{ Name = 'G14 New-Item com caminho entre aspas no projeto liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = "New-Item -ItemType Directory -Force -Path `"$proj\.team-project\operator\1\T-003`"" } } },
    @{ Name = 'G14 pasta do job em variável do mesmo comando liberada'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = '$dir = ".team-project/operator/1/T-003"; if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }' } } },
    @{ Name = 'G14 Join-Path (Get-Location) do mesmo comando liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = '$job = Join-Path (Get-Location) ".team-project/operator/1/T-003-medicao"; New-Item -ItemType Directory -Force -Path $job' } } },
    @{ Name = 'G14 caminho entre aspas fora do projeto continua negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'New-Item -ItemType Directory -Path "Z:\fora-do-projeto\x"' } } },
    @{ Name = 'G14 conferência com 2>&1 liberada'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:architect'; tool_input = @{ command = "powershell -NoProfile -File `"$root\scripts\checks\plan.ps1`" -Plan .team-project/sprints/1/plan/T-003-z.md 2>&1" } } },
    @{ Name = 'G14 Get-Process liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'Get-Process node,chrome -ErrorAction SilentlyContinue | Select-Object Name,Id' } } },
    @{ Name = 'G14 npm --prefix casa com runCommands'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'npm --prefix src test *> ".team-project/operator/1/T-003/test.log"' } } },
    @{ Name = 'G14 [Math]::Min dentro de leitura liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = "Select-String -Path src/a.cs -Pattern 'x' | ForEach-Object { `$_.Line.Substring(0, [Math]::Min(80, `$_.Line.Length)) }" } } },
    @{ Name = 'G14 separador dentro de aspas não parte o comando'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = "Select-String -Path src/a.cs -Pattern 'a; npm install x | rm'" } } },
    @{ Name = 'G14 Start-Sleep nega com a rota própria'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'espera com Start-Sleep'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'Start-Sleep -Seconds 240' } } },
    @{ Name = 'guards.log: comando multilinha fica numa linha'; Script = 'pre-tool.ps1'; Expect = 2
       Check = { -not (@(Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Encoding UTF8) | Where-Object { $_ -match '^npm install segunda' }) }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "npm install primeira`nnpm install segunda" } } },
    @{ Name = 'G9 .active-task ilegível nega (antes derrubava o hook)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'escopo ativo ilegível'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-task') '.team-project/sprints/1/plan/T-003-z.md' -Encoding UTF8 }
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/e.cs'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G11 operator/sprint-1 negado com o segmento certo'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'operator/1/, nunca operator/sprint-1/'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-task') '{ "trilha": "sprint", "id": "T-003", "plano": ".team-project/sprints/1/plan/T-003-z.md" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:operator'; tool_input = @{ file_path = (Join-Path $proj '.team-project/operator/sprint-1/T-003/x.log'); content = 'x' } } },
    @{ Name = 'G11 operator em B-nnn/F-ID liberado'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:operator'; tool_input = @{ file_path = (Join-Path $proj '.team-project/operator/B-001/F-001/checkpoint.md'); content = 'x' } } },
    @{ Name = 'G15 ignora o formulário (AskUserQuestion)'; Script = 'notification.ps1'; Expect = 0
       Check = { -not (@(Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Encoding UTF8) | Where-Object { $_ -match '\| G15 \|.*AskUserQuestion' }) }
       Payload = @{ hook_event_name = 'Notification'; notification_type = 'permission_prompt'; message = 'Claude needs your permission to use AskUserQuestion' } },
    @{ Name = 'G15 pedido de permissão vai ao guards.log'; Script = 'notification.ps1'; Expect = 0
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G15*run ativo: sprint 1*precisa de permissão*' }
       Payload = @{ hook_event_name = 'Notification'; notification_type = 'permission_prompt'; message = 'Claude precisa de permissão para usar PowerShell' } },
    @{ Name = 'G16 rodada do subagente vai ao usage.jsonl (dedup por message.id, Task do prompt, filho)'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { $sd = Join-Path $tmp 'transcripts/sess1/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
                 Set-Content -LiteralPath (Join-Path $tmp 'transcripts/sess1.jsonl') '{}' -Encoding UTF8
                 $u1 = '{"type":"assistant","timestamp":"2026-10-06T10:00:00Z","message":{"id":"m1","model":"claude-haiku-4-5","usage":{"input_tokens":10,"cache_creation_input_tokens":1000,"cache_read_input_tokens":0,"output_tokens":1}}}'
                 $u1b = '{"type":"assistant","timestamp":"2026-10-06T10:00:05Z","message":{"id":"m1","model":"claude-haiku-4-5","usage":{"input_tokens":10,"cache_creation_input_tokens":1000,"cache_read_input_tokens":0,"output_tokens":50}}}'
                 $u2 = '{"type":"assistant","timestamp":"2026-10-06T10:02:00Z","message":{"id":"m2","model":"claude-haiku-4-5","usage":{"input_tokens":5,"cache_creation_input_tokens":200,"cache_read_input_tokens":1000,"output_tokens":20}}}'
                 $p1 = '{"type":"user","timestamp":"2026-10-06T09:59:59Z","message":{"role":"user","content":"Execute o plano da T-007, bloco 1"}}'
                 $tr = '{"type":"user","message":{"content":[{"type":"tool_result","content":[{"type":"text","text":"Async agent launched successfully.\nagentId: fedcba9876 (internal ID)"}]}]}}'
                 [System.IO.File]::WriteAllLines((Join-Path $sd 'agent-abc1234567.jsonl'), [string[]]@($p1, $u1, $u1b, $tr, $u2), (New-Object System.Text.UTF8Encoding($false))) }
       Check = { $l = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8); $l.Count -eq 1 -and $l[0] -match '"role":"developer".*"round":1.*"work":"T-007".*"calls":2.*"processed":2285.*"final_context":1225.*"children":\["fedcba9876"\]' }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'abc1234567'; agent_type = 'team:developer'; transcript_path = (Join-Path $tmp 'transcripts/sess1.jsonl') } },
    @{ Name = 'G16 parada sem chamada nova não duplica'; Script = 'subagent-stop.ps1'; Expect = 0
       Check = { @(Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl')).Count -eq 1 }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'abc1234567'; agent_type = 'team:developer'; transcript_path = (Join-Path $tmp 'transcripts/sess1.jsonl') } },
    @{ Name = 'G16 retomada por SendMessage vira rodada 2 com o delta'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { Add-Content -LiteralPath (Join-Path $tmp 'transcripts/sess1/subagents/agent-abc1234567.jsonl') @('{"type":"user","timestamp":"2026-10-06T11:00:00Z","message":{"role":"user","content":"Resposta do GAP da T-007: siga"}}', '{"type":"assistant","timestamp":"2026-10-06T11:00:30Z","message":{"id":"m3","model":"claude-sonnet-5-5","usage":{"input_tokens":5,"cache_creation_input_tokens":100,"cache_read_input_tokens":1200,"output_tokens":30}}}') -Encoding UTF8 }
       Check = { $l = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8); $l.Count -eq 2 -and $l[1] -match '"round":2.*"model":"claude-sonnet-5-5".*"calls":1,"calls_total":3.*"processed":1335' }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'abc1234567'; agent_type = 'team:developer'; transcript_path = (Join-Path $tmp 'transcripts/sess1.jsonl') } },
    @{ Name = 'G16 usd pelo preço do modelo (v3.52.3): Sonnet 5.5 com preço, Haiku 4.5 fora da tabela = null'; Script = 'subagent-stop.ps1'; Expect = 0
       Check = { $l = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8); $l[0] -match '"processed":2285,"usd":null' -and $l[1] -match '"processed":1335,"usd":0\.0008' }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'abc1234567'; agent_type = 'team:developer'; transcript_path = (Join-Path $tmp 'transcripts/sess1.jsonl') } },
    @{ Name = 'G16 grava a linha medida no consumption.md do sprint aberto (v3.49)'; Script = 'subagent-stop.ps1'; Expect = 0; ExpectOut = ''
       Setup = { $sd = Join-Path $tmp 'transcripts/sess1/subagents'
                 New-Item -ItemType Directory -Force (Join-Path $proj '.team-project/sprints/1') | Out-Null
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/README.md') "# Contexto`n`n| Campo | Valor |`n|---|---|`n| **Sprint corrente** | **1** |" -Encoding UTF8
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/sprints/1/consumption.md') "# Consumo — Sprint 1`n`n## Registro`n| Data | Papel | Modelo | Comando | Task/História | Categoria | Unidade | Tokens | Duração | Nota |`n|---|---|---|---|---|---|---|---|---|---|`n`n## Totais do sprint (derivado)`n| a | b |`n|---|---|`n| x | y |" -Encoding UTF8
                 $p = '{"type":"user","timestamp":"2026-10-06T11:30:00Z","message":{"role":"user","content":"Plano da T-009"}}'
                 $a = '{"type":"assistant","timestamp":"2026-10-06T11:31:00Z","message":{"id":"q1","model":"claude-opus-5-5","usage":{"input_tokens":5,"cache_creation_input_tokens":100,"cache_read_input_tokens":0,"output_tokens":10}}}'
                 [System.IO.File]::WriteAllLines((Join-Path $sd 'agent-arc9876543.jsonl'), [string[]]@($p, $a), (New-Object System.Text.UTF8Encoding($false))) }
       Check = { $c = Get-Content -LiteralPath (Join-Path $proj '.team-project/sprints/1/consumption.md') -Raw -Encoding UTF8
                 $ok = ($c -like '*| arc | opus 5.5 |*| T-009 |*medido: arc9876543#1*') -and ($c -like '*| arc | opus 5.5 | 115 | 1 | 1 |*')
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/README.md') 'local' -Encoding UTF8; $ok }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'arc9876543'; agent_type = 'team:architect'; transcript_path = (Join-Path $tmp 'transcripts/sess1.jsonl') } },
    @{ Name = 'G16 operator: a resposta vira report.md na pasta do job (v3.48)'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { $sd = Join-Path $tmp 'transcripts/sess1/subagents'
                 $p = '{"type":"user","timestamp":"2026-10-06T12:00:00Z","message":{"role":"user","content":"Rode a suíte da T-003; job .team-project/operator/1/T-003-suite/"}}'
                 $a = '{"type":"assistant","timestamp":"2026-10-06T12:01:00Z","message":{"id":"o1","model":"claude-haiku-4-5","content":[{"type":"text","text":"## Relatório\nVeredito: ok · exit 0 · log: .team-project/operator/1/T-003-suite/test.log"}],"usage":{"input_tokens":5,"cache_creation_input_tokens":100,"cache_read_input_tokens":0,"output_tokens":10}}}'
                 [System.IO.File]::WriteAllLines((Join-Path $sd 'agent-op12345678.jsonl'), [string[]]@($p, $a), (New-Object System.Text.UTF8Encoding($false))) }
       Check = { $f = Join-Path $proj '.team-project/operator/1/T-003-suite/report.md'
                 (Test-Path -LiteralPath $f) -and ((Get-Content -LiteralPath $f -Raw -Encoding UTF8) -like '*G16: resposta do operator*Veredito: ok*') -and
                 ((Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8 | Select-Object -Last 1) -match '"report":".team-project/operator/1/T-003-suite/report.md"') }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'op12345678'; agent_type = 'team:operator'; transcript_path = (Join-Path $tmp 'transcripts/sess1.jsonl') } },
    @{ Name = 'G16 operator no bloco de fix, sem pasta citada: relatório em operator/B-<nnn>/<F-ID>-<agente>/ (garden 24, v3.52.1)'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { New-Item -ItemType Directory -Force (Join-Path $proj '.team-project/fixes/B-001') | Out-Null
                 $runPath = Join-Path $proj '.team-project/.active-run'
                 $script:runSalvo = if (Test-Path -LiteralPath $runPath) { [System.IO.File]::ReadAllText($runPath) } else { $null }
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "fix", "id": "B-001", "desde": "2026-10-06 10:00" }' -Encoding UTF8
                 $sd = Join-Path $tmp 'transcripts/sess5/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
                 $p = '{"type":"user","timestamp":"2026-10-06T12:00:00Z","message":{"role":"user","content":"Rode o teste focado da F-001 e devolva o resultado"}}'
                 $a = '{"type":"assistant","timestamp":"2026-10-06T12:01:00Z","message":{"id":"of1","model":"claude-haiku-4-5","content":[{"type":"text","text":"## Relatório\nVeredito: ok · exit 0"}],"usage":{"input_tokens":5,"cache_creation_input_tokens":100,"cache_read_input_tokens":0,"output_tokens":10}}}'
                 [System.IO.File]::WriteAllLines((Join-Path $sd 'agent-opfix12345.jsonl'), [string[]]@($p, $a), (New-Object System.Text.UTF8Encoding($false))) }
       Check = { $f = Join-Path $proj '.team-project/operator/B-001/F-001-opfix123/report.md'; $okR = (Test-Path -LiteralPath $f) -and ((Get-Content -LiteralPath $f -Raw -Encoding UTF8) -like '*Veredito: ok*'); if ($script:runSalvo) { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/.active-run'), $script:runSalvo) }; $okR }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'opfix12345'; agent_type = 'team:operator'; transcript_path = (Join-Path $tmp 'transcripts/sess5.jsonl') } },
    @{ Name = 'G16 operator retomado: segunda resposta vira report-<agente>-r2.md'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { Add-Content -LiteralPath (Join-Path $tmp 'transcripts/sess1/subagents/agent-op12345678.jsonl') @('{"type":"user","timestamp":"2026-10-06T12:10:00Z","message":{"role":"user","content":"Rode de novo o focado"}}', '{"type":"assistant","timestamp":"2026-10-06T12:11:00Z","message":{"id":"o2","model":"claude-haiku-4-5","content":[{"type":"text","text":"Focado: exit 1 — 1 falhou."}],"usage":{"input_tokens":5,"cache_creation_input_tokens":10,"cache_read_input_tokens":100,"output_tokens":10}}}') -Encoding UTF8 }
       Check = { $f = Join-Path $proj '.team-project/operator/1/T-003-suite/report-op123456-r2.md'
                 (Test-Path -LiteralPath $f) -and ((Get-Content -LiteralPath $f -Raw -Encoding UTF8) -like '*Focado: exit 1*') -and
                 ((Get-Content -LiteralPath (Join-Path $proj '.team-project/operator/1/T-003-suite/report.md') -Raw -Encoding UTF8) -like '*Veredito: ok*') }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'op12345678'; agent_type = 'team:operator'; transcript_path = (Join-Path $tmp 'transcripts/sess1.jsonl') } },
    @{ Name = 'G13 retoma o sprint run esquecido (v3.51, proposta b)'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'Retomada: o sprint run 1 *Pedido desta sessão = /sm sprint run*retome sem esperar o stakeholder, pelo run.ps1 next (cartão: roles/scrum-master/process/sprint-run-session.md)'
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'G13 retoma o fix run esquecido com o comando do fix'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'Retomada: o fix run B-002 */sm fix run'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "fix", "id": "B-002", "desde": "2026-10-06 10:00" }' -Encoding UTF8 }
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'G13 .active-run ilegível: só o aviso'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = '.active-run existe mas está ilegível'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') 'não é json' -Encoding UTF8 }
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'G13 perfil com acento: avisa a junção ASCII do Gradle (v3.51, D2)'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'tem acento*GRADLE_USER_HOME'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "1", "desde": "2026-10-06 10:00" }' -Encoding UTF8 }
       Env = @{ USERPROFILE = 'C:\Users\JoãoAçaí'; GRADLE_USER_HOME = '' }
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'G13 perfil com acento e GRADLE_USER_HOME já definido: sem aviso'; Script = 'session-start.ps1'; Expect = 0; NotOut = 'tem acento'
       Env = @{ USERPROFILE = 'C:\Users\JoãoAçaí'; GRADLE_USER_HOME = 'C:\gh' }
       Payload = @{ hook_event_name = 'SessionStart' } },
    # ---------- v3.47 — G17: modelo por papel (.team-project/models.json) ----------
    @{ Name = 'G17 sem models.json: disparo livre (como na v3.46)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; model = 'opus'; prompt = 'x' } } },
    @{ Name = 'G17 sessão dispara o dev sem model; models.json pede sonnet (agente é haiku)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'sonnet'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "developer": "sonnet" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; prompt = 'x' } } },
    @{ Name = 'G17 sessão dispara o dev com model sonnet'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; model = 'sonnet'; prompt = 'x' } } },
    @{ Name = 'G17 sessão dispara o dev com model diferente'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G17'
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; model = 'haiku'; prompt = 'x' } } },
    @{ Name = 'G17 chave vence a exceção do processo (3ª instância pede sonnet, models.json pede haiku)'; Script = 'pre-tool.ps1'; Expect = 2
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "developer": "haiku" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; model = 'sonnet'; prompt = 'x' } } },
    @{ Name = 'G17 papel sem chave segue livre (Arquiteto em sonnet na trilha leve)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:architect'; model = 'sonnet'; prompt = 'x' } } },
    @{ Name = 'G17 chave igual ao modelo do agente dispensa o model (operator haiku)'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "operator": "haiku" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:operator'; prompt = "Chamador: sessão S1`nx" } } },
    @{ Name = 'G17 vale para o operator disparado pelo QA'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'sonnet'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "operator": "sonnet" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:quality-assurance'; tool_input = @{ subagent_type = 'team:operator'; prompt = "Chamador: qa T-041`nx" } } },
    @{ Name = 'G17 operator disparado pelo Arquiteto com o model certo'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:architect'; tool_input = @{ subagent_type = 'team:operator'; model = 'sonnet'; prompt = "Chamador: arc T-041`nx" } } },
    @{ Name = 'G17 todos os papéis: PO, QA, SM, UX e Arquiteto configurados'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'opus'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "product-owner": "haiku", "quality-assurance": "opus", "scrum-master": "opus", "user-experience": "haiku", "architect": "sonnet" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:quality-assurance'; prompt = 'x' } } },
    @{ Name = 'G17 PO com model certo'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:product-owner'; model = 'haiku'; prompt = 'x' } } },
    @{ Name = 'G17 SM sem model: o agente é sonnet, o arquivo pede opus'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:scrum-master'; prompt = 'x' } } },
    @{ Name = 'G17 apelido do comando vale como chave (ux)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'haiku'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "ux": "haiku", "dev": "opus" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'user-experience'; model = 'sonnet'; prompt = 'x' } } },
    @{ Name = 'G17 apelido dev com model certo, subagent_type sem prefixo'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'developer'; model = 'opus'; prompt = 'x' } } },
    @{ Name = 'G17 agente fora do time não é tocado'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'Explore'; model = 'haiku'; prompt = 'x' } } },
    @{ Name = 'G17 valor inválido e papel desconhecido são ignorados (falha aberta)'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "developer": "gpt-9", "cozinheiro": "opus", "_comentario": "x" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; model = 'haiku'; prompt = 'x' } } },
    @{ Name = 'G17 chave vazia = não configurado'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "developer": "", "architect": null }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; model = 'opus'; prompt = 'x' } } },
    @{ Name = 'G17 models.json ilegível: falha aberta'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ nao-e-json' -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; model = 'opus'; prompt = 'x' } } },
    @{ Name = 'G17 desligada em guards.json'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "developer": "sonnet" }' -Encoding UTF8
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "disabled": ["G17"] }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; model = 'haiku'; prompt = 'x' } } },
    @{ Name = 'G17 projeto sem o time (.team-project ausente): silêncio'; Script = 'pre-tool.ps1'; Expect = 0; Env = @{ CLAUDE_PROJECT_DIR = $bare }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; model = 'haiku'; prompt = 'x' } } },
    @{ Name = 'G13 mostra os modelos em vigor'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'Modelos por papel (models.json): developer=sonnet'
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/guards.json') -Force -ErrorAction SilentlyContinue }
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'G13 avisa models.json ilegível'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'models.json ilegível'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ nao-e-json' -Encoding UTF8 }
       Payload = @{ hook_event_name = 'SessionStart' } },
    # v3.56.0 (B, E): o SM escreve no knowledge.md e na camada local da stack (promoção mecânica do fechamento); o dev não.
    @{ Name = 'G8 (v3.56.0) SM grava architect/knowledge.md'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:scrum-master'; tool_input = @{ file_path = (Join-Path $proj '.team-project/architect/knowledge.md'); content = 'x' } } },
    @{ Name = 'G8 (v3.56.0) SM grava a camada local da stack'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:scrum-master'; tool_input = @{ file_path = (Join-Path $proj '.team-project/standards/stacks/ionic-capacitor/pitfalls.md'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G8 (v3.56.0) SM segue sem escrever o resto de architect/'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G8'
       Payload = @{ tool_name = 'Write'; agent_type = 'team:scrum-master'; tool_input = @{ file_path = (Join-Path $proj '.team-project/architect/breakdown/S1.md'); content = 'x' } } },
    @{ Name = 'G8 (v3.56.0) dev não grava o knowledge.md'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G8'
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj '.team-project/architect/knowledge.md'); content = 'x' } } },
    # v3.56.0 (C): sem guards.json → "stacks", o SessionStart avisa e mostra a inferência (package.json da raiz e do 1º nível).
    @{ Name = 'G13 (v3.56.0) sem "stacks": avisa com as stacks inferidas'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = '*guards.json sem "stacks"*(angular, ionic-capacitor)*'
       Setup = { New-Item -ItemType Directory -Force (Join-Path $proj 'source') | Out-Null; Set-Content -LiteralPath (Join-Path $proj 'source/package.json') '{ "dependencies": { "@angular/core": "17", "@ionic/angular": "8", "@capacitor/core": "6" } }' -Encoding UTF8 }
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'G13 (v3.56.0) com "stacks" declarada: sem o aviso'; Script = 'session-start.ps1'; Expect = 0; NotOut = 'sem "stacks"'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "stacks": ["angular", "ionic-capacitor"] }' -Encoding UTF8 }
       Payload = @{ hook_event_name = 'SessionStart' }
       Check = { Remove-Item -LiteralPath (Join-Path $proj 'source') -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -LiteralPath (Join-Path $proj '.team-project/guards.json') -Force -ErrorAction SilentlyContinue; $true } },
    @{ Name = 'G17 limpeza: sem models.json volta ao livre'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/models.json') -Force -ErrorAction SilentlyContinue }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; model = 'haiku'; prompt = 'x' } } },
    # ---------- v3.47 (M2) — perfil Arquiteto executor: models.json "executor" + .active-executor ----------
    @{ Name = 'M2 sem perfil: o Arquiteto segue sem escrever código (G8)'; Script = 'pre-tool.ps1'; Expect = 2
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/models.json') -Force -ErrorAction SilentlyContinue
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-executor') '{ "trilha": "sprint", "id": "T-001", "desde": "2026-10-10 09:00" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); content = 'x' } } },
    @{ Name = 'M2 só o perfil, sem o marcador: G8 nega'; Script = 'pre-tool.ps1'; Expect = 2
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-executor') -Force -ErrorAction SilentlyContinue
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "executor": "architect" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); content = 'x' } } },
    @{ Name = 'M2 perfil + marcador: o Arquiteto escreve arquivo do plano'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-executor') '{ "trilha": "sprint", "id": "T-001", "desde": "2026-10-10 09:00" }' -Encoding UTF8
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-task') '{ "trilha": "sprint", "id": "T-001", "plano": ".team-project/sprints/1/plan/T-001-x.md" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); content = 'x' } } },
    @{ Name = 'M2 perfil + marcador: arquivo fora do plano é negado pela G9 (com a rota do executor)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'Perfil executor'
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj 'src/b.cs'); content = 'x' } } },
    @{ Name = 'M2 perfil + marcador: o Arquiteto edita o plano em .team-project/'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/1/plan/T-001-x.md'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'M2 o executor não acrescenta teste ignorado (G6)'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj 'tests/ATests.cs'); content = '[Ignore] void T() {}' } } },
    @{ Name = 'M2 o executor não toca arquivo de gate (G5)'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj '.editorconfig'); content = 'x' } } },
    @{ Name = 'M2 o PO continua sem escrever código com o perfil ligado'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Write'; agent_type = 'team:product-owner'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); content = 'x' } } },
    @{ Name = 'M2 valor inválido de executor é ignorado (falha aberta: G8 nega)'; Script = 'pre-tool.ps1'; Expect = 2
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "executor": "developer" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); content = 'x' } } },
    @{ Name = 'M2 o SessionStart mostra o perfil executor ligado'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'Perfil executor ligado'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "executor": "architect" }' -Encoding UTF8 }
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'M2 o SessionStart avisa .active-executor esquecido'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = '.active-executor existe'
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'M2 limpeza dos marcadores e do perfil'; Script = 'pre-tool.ps1'; Expect = 2
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-executor') -Force -ErrorAction SilentlyContinue
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/models.json') -Force -ErrorAction SilentlyContinue }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); content = 'x' } } },
    # ---------- v3.47 (M3) — G18 modo benchmark: respostas do dossiê e primeiro plano ----------
    @{ Name = 'G18 sem bench: a G3 segue valendo'; Script = 'pre-tool.ps1'; Expect = 0; Setup = $FreshRoute
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = '[ACME · S4 · ③ pacote] Aprova o pacote? Exemplo: a tela de exportação.'; header = 'P'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G18 bench: o dossiê responde (pick casa o rótulo)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'resposta do stakeholder: Aprovar'
       Setup = { Set-Content -LiteralPath (Join-Path $proj 'bench-answers.json') '{ "respostas": [ { "tema": "Portões", "match": "(?i)pacote|portão", "pick": "^(?i)aprovar" } ] }' -Encoding UTF8
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "bench": { "arm": "P0-r1", "answers": "bench-answers.json", "foreground": true } }' -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o pacote de abertura?'; header = 'Portão ③'; multiSelect = $false; options = @((Opt 'Reprovar'), (Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G18 bench: a pergunta vai para o questions.log com o tema e a origem'; Script = 'pre-tool.ps1'; Expect = 2
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/benchmark/P0-r1/questions.log') -Raw -Encoding UTF8) -like '*| Portões | dossie | Aprova o pacote de abertura? | Aprovar*' }
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o pacote de abertura?'; header = 'Portão ③'; multiSelect = $false; options = @((Opt 'Reprovar'), (Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G18 bench: fora do dossiê vale a opção recomendada, nunca "Pedir mais contexto"'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'Opção B (Recomendado)'
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Qual biblioteca de datas?'; header = 'Lib'; multiSelect = $false; options = @((Opt 'Opção A'), (Opt 'Opção B (Recomendado)'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G18 bench: sem recomendada, a primeira que não é "Pedir mais contexto"'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'resposta do stakeholder: Sim'
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Posso seguir assim?'; header = 'Q'; multiSelect = $false; options = @((Opt 'Sim'), (Opt 'Não'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G18 bench: formulário com duas perguntas responde as duas'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'pergunta 2'
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(
           @{ question = 'Aprova o pacote?'; header = 'A'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) },
           @{ question = 'Qual cor?'; header = 'B'; multiSelect = $false; options = @((Opt 'Azul'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G18 bench: foreground nega agente em segundo plano'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'primeiro plano'
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; run_in_background = $true; prompt = 'x' } } },
    @{ Name = 'G18 bench: foreground aceita agente em primeiro plano'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; run_in_background = $false; prompt = 'x' } } },
    @{ Name = 'G18 bench sem answers: a G3 decide (formulário sem "Pedir mais contexto" é negado)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G3'
       Setup = { & $FreshRoute; Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "bench": { "arm": "P0-r1" } }' -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Q?'; header = 'Q'; multiSelect = $false; options = @((Opt 'Sim'), (Opt 'Não')) }) } } },
    @{ Name = 'G18 desligada em guards.json: a G3 volta a valer'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G3'
       Setup = { & $FreshRoute; Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "disabled": ["G18"], "bench": { "arm": "x", "answers": "bench-answers.json" } }' -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o pacote?'; header = 'Q'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Não')) }) } } },
    @{ Name = 'G13 avisa o modo benchmark ligado'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'Modo benchmark ligado'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "bench": { "arm": "P0-r1", "foreground": true } }' -Encoding UTF8 }
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'G13 bench: sem AskUserQuestion (claude -p) a sessão é mandada ao bench-answer.ps1'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'scripts/checks/bench-answer.ps1'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "bench": { "arm": "P0-r1", "foreground": true } }' -Encoding UTF8 }
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'G18 limpeza: sem bench'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/guards.json') -Force -ErrorAction SilentlyContinue }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; run_in_background = $true; prompt = 'x' } } },
    @{ Name = 'Falha aberta: JSON inválido'; Script = 'pre-tool.ps1'; Expect = 1; Raw = '{nao-e-json' },
    @{ Name = 'guards.json desliga G3 e liga a sonda'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-run') -Force
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "disabled": ["G3"], "probe": true }' -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; agent_type = 'team:product-owner'; agent_id = 'a1'; tool_input = @{ questions = @(@{ question = 'Q?'; header = 'Q'; multiSelect = $false; options = @((Opt 'Sim'), (Opt 'Não')) }) } } },
    @{ Name = 'Sonda gravou agent_type no guards.log'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'desativadas G3'
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw) -like '*probe*agent_type=team:product-owner*script_ms=*' }
       Payload = @{ hook_event_name = 'SessionStart' } },
    # ---------- v3.51 — H1 (G3 com exemplo prático), G19 (retomada de papel caro) e G20 (hook Stop) ----------
    @{ Name = 'H1 pergunta sem exemplo prático: negada pela G3'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'H1 (v3.51)'
       Setup = { & $FreshRoute; Set-Content -LiteralPath (Join-Path $proj '.team-project/README.md') "# Contexto`n" -Encoding UTF8; Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "disabled": [] }' -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o ajuste?'; header = 'A'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'H1 exemplo na descrição de uma opção: liberado'; Script = 'pre-tool.ps1'; Expect = 0; Setup = $FreshRoute
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o ajuste?'; header = 'A'; multiSelect = $false; options = @(@{ label = 'Aprovar'; description = 'por exemplo: o raio começa em 150 km' }, (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G19 SendMessage ao Arquiteto parado há 20 min: instância nova'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G19'
       Setup = { Add-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') ('{"ts":"' + (Get-Date).AddMinutes(-20).ToString('yyyy-MM-ddTHH:mm:ss') + '","agent_id":"arc19old","role":"architect","model":"claude-opus-5-5"}') -Encoding UTF8
                 Add-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') ('{"ts":"' + (Get-Date).AddMinutes(-2).ToString('yyyy-MM-ddTHH:mm:ss') + '","agent_id":"arc19new","role":"architect","model":"claude-opus-5-5"}') -Encoding UTF8
                 Add-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') ('{"ts":"' + (Get-Date).AddMinutes(-40).ToString('yyyy-MM-ddTHH:mm:ss') + '","agent_id":"dev19old","role":"developer","model":"claude-haiku-5-5"}') -Encoding UTF8 }
       Payload = @{ tool_name = 'SendMessage'; tool_input = @{ to = 'arc19old'; message = 'x' } } },
    @{ Name = 'G19 Arquiteto parado há 2 min: retomada liberada'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'SendMessage'; tool_input = @{ to = 'arc19new'; message = 'x' } } },
    @{ Name = 'G19 dev (Haiku) parado há 40 min: retomada liberada'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'SendMessage'; tool_input = @{ to = 'dev19old'; message = 'x' } } },
    @{ Name = 'G20 sem .active-run: fim de turno livre'; Script = 'stop.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-run') -Force -ErrorAction SilentlyContinue
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue
                 New-Item -ItemType Directory -Force (Join-Path $proj '.team-project/sprints/7') | Out-Null
                 [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/sprints/7/sprint-backlog.md'), "## História H-1 — x`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2705)) T-1 | a | — |`n| $([char]::ConvertFromUtf32(0x2B1C)) T-2 | b | T-1 |`n| $([char]::ConvertFromUtf32(0x2B1C)) T-3 | c | T-9 |`n", (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'G20 run ativo com Task elegível: barra o fim de turno'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'T-2 está elegível'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "7", "desde": "2026-10-06 10:00" }' -Encoding UTF8 }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'G20 agente em segundo plano em voo: espera legítima'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:developer","description":"Dev T-2","desde":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '"}]') -Encoding UTF8 }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'G20 SubagentStop tira o agente da lista; o fim de turno volta a ser barrado'; Script = 'stop.ps1'; Expect = 2
       Setup = { $null = Invoke-Hook 'subagent-stop.ps1' @{ hook_event_name = 'SubagentStop'; agent_id = 'semtranscript'; agent_type = 'team:developer' } }
       Check = { -not (Test-Path -LiteralPath (Join-Path $proj '.team-project/.active-agents')) }
       Payload = @{ hook_event_name = 'Stop' } },
    # ---------- v3.57.0 — o watcher da espera (agents/watcher.md, protocolo de espera; "vigia" até a v3.57.0): só a sessão o dispara, entra em .active-agents, a G20 o respeita ----------
    @{ Name = 'v3.57.0 watcher: a sessão dispara team:watcher — registrado em .active-agents, sem work (o disparo não cita ID de Task)'; Script = 'pre-tool.ps1'; Expect = 0
       Check = { $a = Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8; $a -match '"type":"team:watcher"' -and $a -match '"work":""' }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:watcher'; model = 'haiku'; description = 'Watcher da espera'; prompt = 'Rode a sonda do seu roteiro e devolva a linha.' } } },
    @{ Name = 'v3.57.0 watcher em voo + Task elegível: a G20 libera o fim de turno (o controle sem agente é o caso anterior, que barra)'; Script = 'stop.ps1'; Expect = 0
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'v3.57.0 watcher: o executor de Task não o dispara (G7)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G7'
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; agent_id = 'tr0000001'; tool_input = @{ subagent_type = 'team:watcher'; description = 'Watcher da espera'; prompt = 'x' } } },
    @{ Name = 'v3.57.0 watcher: o dev não o dispara (G7: só o operator)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G7'
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:developer'; agent_id = 'dv0000001'; tool_input = @{ subagent_type = 'team:watcher'; description = 'Watcher da espera'; prompt = 'x' } } },
    @{ Name = 'v3.57.0 watcher: SubagentStop mede a rodada (role watcher, Haiku) e o tira da lista'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { $sd = Join-Path $tmp 'transcripts/vig/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
                 Set-Content -LiteralPath (Join-Path $tmp 'transcripts/vig.jsonl') '{}' -Encoding UTF8
                 $v1 = '{"type":"user","timestamp":"2026-10-06T09:59:59Z","message":{"role":"user","content":"Rode a sonda do seu roteiro e devolva a linha."}}'
                 $v2 = '{"type":"assistant","timestamp":"2026-10-06T10:00:00Z","message":{"id":"vg1","model":"claude-haiku-5-5","usage":{"input_tokens":10,"cache_creation_input_tokens":800,"cache_read_input_tokens":0,"output_tokens":40}}}'
                 [System.IO.File]::WriteAllLines((Join-Path $sd 'agent-vig0000001.jsonl'), [string[]]@($v1, $v2), (New-Object System.Text.UTF8Encoding($false))) }
       Check = { $u = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8 | Where-Object { $_ -match 'vig0000001' } | ConvertFrom-Json)[0]
                 $u -and $u.role -eq 'watcher' -and $u.model -eq 'claude-haiku-5-5' -and $u.processed -eq 850 -and -not (Test-Path -LiteralPath (Join-Path $proj '.team-project/.active-agents')) }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'vig0000001'; agent_type = 'team:watcher'; transcript_path = (Join-Path $tmp 'transcripts/vig.jsonl') } },
    @{ Name = 'v3.57.0 watcher: ID de Task na descrição vira work (por isso o disparo do watcher não cita nenhum); limpeza'; Script = 'pre-tool.ps1'; Expect = 0
       Check = { $a = Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8; Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force; $a -match '"work":"T-2"' }
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:watcher'; description = 'Watcher da espera da T-2'; prompt = 'x' } } },
    # v3.57.1: o comando do roteiro do watcher passa pela G14 (é conferência do plugin); o laço antigo com Start-Sleep, não —
    # no sprint 5 do garden os 5 disparos reais foram negados assim e voltaram em ~8 s sem conferir nada.
    @{ Name = 'v3.57.1 watcher: o comando exato do roteiro (v3.66.2: run.ps1 wait -For 540, com timeout 570000) é liberado pela G14 durante o run'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:watcher'; agent_id = 'wt0000001'; tool_input = @{ command = "powershell -NoProfile -File `"$root/scripts/checks/run.ps1`" wait -For 540"; timeout = 570000 } } },
    @{ Name = 'v3.57.1 watcher: o laço da v3.57.0 (Start-Sleep no comando) continua negado pela G14 com runCommands, como no garden — por isso a espera foi para dentro do script'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'espera com Start-Sleep'
       Setup = { $g = Join-Path $proj '.team-project/guards.json'; Copy-Item -LiteralPath $g (Join-Path $tmp 'guards-antes-watcher.json') -Force -ErrorAction SilentlyContinue
                 Set-Content -LiteralPath $g '{ "runCommands": ["npm test"] }' -Encoding UTF8 }
       Check = { $g = Join-Path $proj '.team-project/guards.json'; $b = Join-Path $tmp 'guards-antes-watcher.json'
                 if (Test-Path -LiteralPath $b) { Move-Item -LiteralPath $b $g -Force } else { Remove-Item -LiteralPath $g -Force }; $true }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:watcher'; agent_id = 'wt0000001'; tool_input = @{ command = "`$t = Get-Date; do { Start-Sleep -Seconds 30; `$o = (& powershell -NoProfile -File `"$root/scripts/checks/run.ps1`" wait 2>&1 | ForEach-Object { `"`$_`" }) -join ' '; `$c = `$LASTEXITCODE } while (`$c -eq 3 -and ((Get-Date) - `$t).TotalSeconds -lt 150); `"`$c `$o`"" } } },    # ---------- v3.57.2 (note.md item 20) — a suíte e a cobertura do projeto só pelo verify.ps1 para o dev e o executor ----------
    @{ Name = 'v3.57.2 G14: o dev rodando a suíte do guards.json direto (fora do verify.ps1) é negado — o next/start/done não veriam a espera'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'suíte ou cobertura do projeto fora do verify.ps1'
       Setup = { $g = Join-Path $proj '.team-project/guards.json'; Copy-Item -LiteralPath $g (Join-Path $tmp 'guards-antes-suite.json') -Force -ErrorAction SilentlyContinue
                 Set-Content -LiteralPath $g '{ "runCommands": ["Set-Location source", "npm run test:cobertura", "npm run test:cobertura:suite"], "verify": { "suite": "Set-Location source; npm run test:cobertura:suite -- --browsers=ChromeHeadless", "coverage": "Set-Location source; npm run gate:cobertura", "focused": "Set-Location source; npx ng test --watch=false --include {tests}" } }' -Encoding UTF8 }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; agent_id = 'dv0000002'; tool_input = @{ command = 'Set-Location source; npm run test:cobertura:suite -- --browsers=ChromeHeadless' } } },
    @{ Name = 'v3.57.2 G14: o operator roda a mesma suíte (execução longa é dele, R28)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; agent_id = 'op0000002'; tool_input = @{ command = 'Set-Location source; npm run test:cobertura:suite -- --browsers=ChromeHeadless' } } },
    @{ Name = 'v3.62.2 G14: o dev rodando a suíte por dentro do detach.ps1 é negado como a suíte direta (só pelo verify)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'suíte ou cobertura do projeto fora do verify.ps1'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; agent_id = 'dv0000002'; tool_input = @{ command = "powershell -NoProfile -File `"$root/scripts/checks/detach.ps1`" -Dir .team-project/operator/1/x -Command `"Set-Location source; npm run test:cobertura:suite -- --browsers=ChromeHeadless`"" } } },
    @{ Name = 'v3.62.2 G14: o operator roda a suíte pelo detach.ps1 (execução longa é dele, em processo próprio)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; agent_id = 'op0000002'; tool_input = @{ command = "powershell -NoProfile -File `"$root/scripts/checks/detach.ps1`" -Dir .team-project/operator/1/x -Command `"Set-Location source; npm run test:cobertura:suite -- --browsers=ChromeHeadless`"" } } },
    @{ Name = 'v3.57.2 G14: o verify.ps1 do dev segue liberado (é o caminho da suíte)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Check = { $g = Join-Path $proj '.team-project/guards.json'; $b = Join-Path $tmp 'guards-antes-suite.json'
                 if (Test-Path -LiteralPath $b) { Move-Item -LiteralPath $b $g -Force } else { Remove-Item -LiteralPath $g -Force }; $true }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; agent_id = 'dv0000002'; tool_input = @{ command = "powershell -NoProfile -File `"$root/scripts/checks/verify.ps1`" -Task T-2 -Mode full" } } },
    @{ Name = 'v3.57.2 G20: o veredito "reiniciar" do run.ps1 next (sessão acima do teto, sem agente em voo) libera o fim de turno'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.next-verdict') ('{"acao":"reiniciar","task":"","motivo":"sessão com 170 mil","at":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Check = { $ok = (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G20*liberado: o run.ps1 next mandou reiniciar*'; Remove-Item -LiteralPath (Join-Path $proj '.team-project/.next-verdict') -Force; $ok }
       Payload = @{ hook_event_name = 'Stop' } },
    # ---------- v3.57.2 (note.md item 23, decisão de 09/11: contexto enxuto) — plano existente muda por delta (Edit) ----------
    @{ Name = 'v3.57.2 G14: o Arquiteto regravando inteiro um plano que já existe (Write) é negado — delta pelo Edit'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'plano que já existe regravado inteiro'
       Setup = { New-Item -ItemType Directory -Force (Join-Path $proj '.team-project/sprints/7/plan') | Out-Null; Set-Content -LiteralPath (Join-Path $proj '.team-project/sprints/7/plan/T-2-x.md') ('# Plano T-2' + "`n" + ('linha do plano ' * 300)) -Encoding UTF8 }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; agent_id = 'ar0000001'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/7/plan/T-2-x.md'); content = '# Plano T-2 reescrito' } } },
    @{ Name = 'v3.57.2 G14: o Write de um plano novo segue liberado ao Arquiteto'; Script = 'pre-tool.ps1'; Expect = 0
       Check = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/sprints/7/plan') -Recurse -Force; $true }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; agent_id = 'ar0000001'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/7/plan/T-3-novo.md'); content = '# Plano T-3' } } },
    @{ Name = 'G20 laço: depois de 3 bloqueios em 10 min, libera'; Script = 'stop.ps1'; Expect = 0
       Setup = { foreach ($i in 1..3) { Add-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') ("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | G20 | sessao |  | T-2 | bloqueio: fim de turno com Task elegível") -Encoding UTF8 } }
       Payload = @{ hook_event_name = 'Stop'; stop_hook_active = $true } },
    @{ Name = 'G20 trilha fix: fora do escopo da v1'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "fix", "id": "B-001", "desde": "2026-10-06 10:00" }' -Encoding UTF8 }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'G20 run ativo e nenhuma elegível (dependência aberta): libera'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "7", "desde": "2026-10-06 10:00" }' -Encoding UTF8
                 [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/sprints/7/sprint-backlog.md'), "## História H-1 — x`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2B1C)) T-3 | c | T-9 |`n", (New-Object System.Text.UTF8Encoding($false)))
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/guards.log') -Force -ErrorAction SilentlyContinue }
       Payload = @{ hook_event_name = 'Stop' } },
    # ---------- v3.65.7 — G20 lê a ação pendente do next (.next-verdict "agir"): o portão sem Task elegível não para calado ----------
    @{ Name = 'v3.65.7 G20: sem Task elegível e sem ação pendente, libera e deixa a linha no guards.log'; Script = 'stop.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.next-verdict') -Force -ErrorAction SilentlyContinue
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.ask-route') -Force -ErrorAction SilentlyContinue
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/guards.log') -Force -ErrorAction SilentlyContinue }
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G20*liberado: nenhuma Task elegível no quadro e nenhuma ação pendente do next*' }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'v3.65.7 G20: o next mandou disparar o operator no portão (sem Task elegível) e nenhum agente está em voo — barra com a ação'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'ação pendente: disparar team:operator — validação do sprint 7'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.next-verdict') ('{"acao":"agir","task":"","motivo":"disparar team:operator — validação do sprint 7 — medir","at":"' + (Get-Date).AddMinutes(-38).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G20*bloqueio: ação pendente do run.ps1 next sem agente em voo*' }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'v3.65.7 G20: a mesma ação pendente com o agente disparado e em voo — espera legítima'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:operator","description":"Operator mede S7","desde":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '"}]') -Encoding UTF8 }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'v3.65.7 G20: o agente voltou (fora do registro) e a ação segue pendente — barra até o run.ps1 next'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'Se ele já voltou, rode run.ps1 next'
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'v3.65.7 G20: a rota ao stakeholder gravada depois da ação pendente libera (a decisão é dele)'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"ambiente","task":"S7","motivo":"x","at":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Check = { $ok = (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G20*liberado: a rota ao stakeholder (ambiente) veio depois da ação pendente*'
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.ask-route') -Force -ErrorAction SilentlyContinue; $ok }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'v3.65.7 G20: rota ao stakeholder mais velha que a ação pendente não libera'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'ação pendente'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"ambiente","task":"S7","motivo":"x","at":"' + (Get-Date).AddHours(-2).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Check = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.ask-route') -Force -ErrorAction SilentlyContinue
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.next-verdict') -Force -ErrorAction SilentlyContinue; $true }
       Payload = @{ hook_event_name = 'Stop' } },
    # ---------- v3.65.11 — pergunta escrita ao stakeholder barrada (G20) e linguagem do processo recusada no formulário (G3) ----------
    @{ Name = 'v3.65.11 G20: a última fala termina em pergunta escrita ao stakeholder, sem rota — barra'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'pergunta escrita ao stakeholder'
       Setup = { $t = Join-Path $tmp 'tq.jsonl'
                 $a1 = '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"PowerShell","input":{}}]}}'
                 $a2 = '{"type":"assistant","message":{"content":[{"type":"text","text":"Nao abri a Q-S6l.\n\nRefazer o aceite com o APK atual (recomendo).\nSeguir a fila do script.\n\nQual voce escolhe?"}]}}'
                 [System.IO.File]::WriteAllLines($t, [string[]]@($a1, $a2), (New-Object System.Text.UTF8Encoding($false)))
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.ask-route') -Force -ErrorAction SilentlyContinue
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/guards.log') -Force -ErrorAction SilentlyContinue }
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G20*bloqueio: pergunta escrita ao stakeholder*' }
       Payload = @{ hook_event_name = 'Stop'; transcript_path = (Join-Path $tmp 'tq.jsonl') } },
    @{ Name = 'v3.65.11 G20: "Até você responder" sem ponto de interrogação também é pedido de decisão — barra'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'pergunta escrita'
       Setup = { $t = Join-Path $tmp 'tq2.jsonl'
                 [System.IO.File]::WriteAllLines($t, [string[]]@('{"type":"assistant","message":{"content":[{"type":"text","text":"Preciso que voce diga como quer seguir:\n- refazer\n- pausar\n\nAte voce responder, o run fica parado aqui."}]}}'), (New-Object System.Text.UTF8Encoding($false)))
                 $t2 = (Get-Content -LiteralPath $t -Raw) -replace 'Ate voce', 'Até você'; [System.IO.File]::WriteAllText($t, $t2, (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ hook_event_name = 'Stop'; transcript_path = (Join-Path $tmp 'tq2.jsonl') } },
    @{ Name = 'v3.65.11 G20: com a rota ao stakeholder dos últimos 15 min (o formulário foi o caminho), a fala com pergunta não barra'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"ambiente","task":"S7","motivo":"x","at":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Check = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.ask-route') -Force -ErrorAction SilentlyContinue; $true }
       Payload = @{ hook_event_name = 'Stop'; transcript_path = (Join-Path $tmp 'tq.jsonl') } },
    @{ Name = 'v3.65.11 G20: fala que só informa (sem pergunta; a pergunta citada em bloco de código não conta) segue a regra de antes — libera sem Task elegível'; Script = 'stop.ps1'; Expect = 0
       Setup = { $t = Join-Path $tmp 'tq3.jsonl'
                 [System.IO.File]::WriteAllLines($t, [string[]]@('{"type":"assistant","message":{"content":[{"type":"text","text":"O operator mede de novo com a versao nova.\n```\nQual voce escolhe?\n```\nSigo quando ele voltar."}]}}'), (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ hook_event_name = 'Stop'; transcript_path = (Join-Path $tmp 'tq3.jsonl') } },
    @{ Name = 'v3.65.11 G20: pergunta escrita de OUTRA sessão (não a que conduz o run) não barra'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.run-session') '{"session":"sessao-do-run","at":"2026-11-22 02:00:00"}' -Encoding UTF8 }
       Check = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.run-session') -Force -ErrorAction SilentlyContinue; $true }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'outra-sessao'; transcript_path = (Join-Path $tmp 'tq.jsonl') } },
    @{ Name = 'v3.65.11 G3: hash, ID interno, arquivo, código de saída e papel interno na pergunta — negada com os termos'; Script = 'pre-tool.ps1'; Expect = 2; Setup = $FreshRoute; ExpectErr = "linguagem do processo na pergunta ao stakeholder: código de versão 'eb971aea13b1' · ID interno 'SC-161' · nome de arquivo 'target.ps1'"
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'O aceite rodou com o APK velho. Exemplo: o SC-161 falha. Como seguir?'; header = 'Q'; multiSelect = $false; options = @(@{ label = 'Reinstalar'; description = 'o operator reinstala o eb971aea13b1; o target.ps1 deu exit 4' }, (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'v3.65.11 G3: a mesma decisão em linguagem simples passa (R$ e versão do plugin não são jargão)'; Script = 'pre-tool.ps1'; Expect = 0; Setup = $FreshRoute
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'O aparelho de teste continua com uma versão antiga do app. Exemplo: a correção do campo de unidade em Insumos não aparece nele. Como seguir?'; header = 'Q'; multiSelect = $false; options = @(@{ label = 'Conferir a geração do app'; description = 'você confere como o app é gerado; custa R$ 0 e a versão 3.65.11 do time segue' }, (Opt 'Pedir mais contexto')) }) } } },
    # ---------- v3.51.4 — negações reais do SunScape (note.md itens 3, 4, 5, 10) e do garden (itens 5, 6, 25) ----------
    @{ Name = 'G14 texto com $( ) entre aspas: subexpressões conferidas, rótulos não viram trecho (tests=, node:)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "1", "desde": "2026-10-06 10:00" }' -Encoding UTF8
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "runCommands": ["npm test", ".\\source\\gradlew.bat"] }' -Encoding UTF8 }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'Get-ChildItem *.xml | ForEach-Object { "tests=$($_.Name) node: $($_.Length) brotas" }' } } },
    @{ Name = 'G14 contagem e Select-String com "$($_.LineNumber): …" (Arquiteto)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:architect'; tool_input = @{ command = '$f=''plano.md''; (Get-Content $f).Count; Select-String -Path $f -Pattern ''Passo'' | ForEach-Object { "$($_.LineNumber): $($_.Line)" }' } } },
    @{ Name = 'G14 (v3.57.0): -ExecutionPolicy Bypass num script fora do plugin é negado com a rota (sem a opção, ou o script do plugin que já usa Bypass por dentro)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'não repita a opção'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'powershell -NoProfile -ExecutionPolicy Bypass -File .\runjob.ps1' } } },
    @{ Name = 'G14 propriedade com os argumentos do comando de fora: Get-Content (gci x).FullName -Encoding UTF8'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'foreach($n in 19..25){ Get-Content (Get-ChildItem "SC-0$n*.md").FullName -Encoding UTF8 }' } } },
    @{ Name = 'G14 [xml]$x = …; $pct = if (…) {…} else {…} (operator medindo cobertura)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'foreach ($f in @(''r.xml'')) { [xml]$x = Get-Content $f -Raw; $pct = if ($x) { 1 } else { 0 }; "covered=$pct" }' } } },
    @{ Name = 'G14 leitura por .NET e [array]::IndexOf não são "escrita por .NET"'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:architect'; tool_input = @{ command = '$p=''plano.md''; $l=[IO.File]::ReadAllLines($p,[Text.Encoding]::UTF8); $ini = [array]::IndexOf($l, ''## 6.''); $l.Count' } } },
    @{ Name = 'G14 Add-Content $log com $log ← $job ← "$root\…" (operator)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = '$root = ''' + $proj + '''; $job = "$root\.team-project\operator\1\T-001-avd"; $log = Join-Path $job ''out.log''; Add-Content $log ''inicio''' } } },
    @{ Name = 'G14 cmd /c "<comando da lista>" lido por dentro: liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'Set-Location src; cmd /c "npm test -- --watch=false"' } } },
    @{ Name = 'G14 cmd /c com redirecionamento ao log do job (operator)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'cmd /c ".\source\gradlew.bat -p source verificarCobertura > .team-project\operator\1\T-001-cob\gradle.log"' } } },
    @{ Name = 'G14 cmd /c com comando fora da lista: nega'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'cmd /c'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'cmd /c "curl http://x > saida.log"' } } },
    @{ Name = 'G14 função definida no próprio comando (QA)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = "`$d='.team-project/quality-assurance/tabela-ouro'`nfunction H { Get-ChildItem `$d -Filter *.csv | Out-Null; 'ok' }`nH" } } },
    @{ Name = 'G14 script do próprio papel em .team-project/: o conteúdo passa pela G14'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Setup = { New-Item -ItemType Directory -Force (Join-Path $proj '.team-project/quality-assurance/tabela-ouro') | Out-Null
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/quality-assurance/tabela-ouro/gerar.ps1') "param(`$Anexo)`n`$l = Get-Content `$Anexo -Encoding UTF8`n`$l.Count`nSet-Content -LiteralPath '.team-project/quality-assurance/tabela-ouro/ouro.csv' -Value 'x'" -Encoding UTF8 }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'powershell -NoProfile -File .team-project/quality-assurance/tabela-ouro/gerar.ps1 -Anexo docs/anexo.md' } } },
    @{ Name = 'G14 script do papel com comando fora da lista: nega'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/quality-assurance/tabela-ouro/baixa.ps1') "Invoke-WebRequest http://x -OutFile y" -Encoding UTF8 }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = '& .\.team-project\quality-assurance\tabela-ouro\baixa.ps1' } } },
    @{ Name = 'G14 escrita por .NET com destino resolvido e do papel: liberada (.scn do QA sem BOM)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = '$d=''.team-project/quality-assurance/scenarios''; [IO.File]::WriteAllText("$d/H-001.scn", ''scenario SC-1 x'', (New-Object Text.UTF8Encoding($false)))' } } },
    @{ Name = 'G8 escrita por .NET em arquivo de outro papel: negada pela G8'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G8'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = '[IO.File]::WriteAllText(''.team-project/sprints/1/sprint-backlog.md'', ''x'')' } } },
    @{ Name = 'G14 apagar por .NET continua negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'Remove-Item'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = '[IO.File]::Delete(''app.txt'')' } } },
    @{ Name = 'G14 conferência do plugin com o caminho numa variável ($acc)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = '$acc = ''' + $root + '\scripts\checks\accept.ps1''; powershell -NoProfile -File $acc -Task T-003 -Only ''SC-001,SC-002''' } } },
    @{ Name = 'G14 operator encerra o processo preso pelo número'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'Get-CimInstance Win32_Process -Filter "Name=''powershell.exe''" | Select-Object ProcessId, CommandLine; Stop-Process -Id 105376 -Force' } } },
    @{ Name = 'G14 dev não encerra processo'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'Stop-Process'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'Stop-Process -Id 105376 -Force' } } },
    @{ Name = 'G14 adb direto: nega com a rota do target.ps1'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'target.ps1'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'adb devices 2>&1; "EXIT=$LASTEXITCODE"' } } },
    @{ Name = 'G14 Start-Sleep: nega com a rota do target.ps1 -Repair e do exit 3'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'exit 3'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'Start-Sleep -Seconds 60; "ok"' } } },
    @{ Name = 'G14 Wait-Process (v3.52.3; v3.62.2): nega e aponta o processo próprio do verify/detach, sem encerrar o turno'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'espera com Wait-Process*processo próprio*rode o MESMO comando de novo, no mesmo turno'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'Wait-Process -Id 4242' } } },
    @{ Name = 'G8 New-Item da pasta delivery/ pelo dev: a pasta casa a linha da matriz (garden item 25)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'New-Item -ItemType Directory -Force .team-project/sprints/2/delivery' } } },
    @{ Name = 'G8 Copy-Item para a pasta stories/ pelo PO: dono PO (note.md item 1, garden item 6)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:product-owner'; tool_input = @{ command = 'Copy-Item .team-project/product-owner/stories/H-001.md -Destination .team-project/sprints/2/stories/' } } },
    @{ Name = 'G8 pasta stories/ pelo dev: negada (a pasta é do PO)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'PO'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'New-Item -ItemType Directory -Force .team-project/sprints/2/stories' } } },
    @{ Name = 'Agent da sessão entra no .active-agents com session e parent vazio, sem .active-run (garden item 5; v3.52.2)'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-run'), (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/guards.json') -Force -ErrorAction SilentlyContinue }
       Check = { $a = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8 | ConvertFrom-Json); $a.Count -eq 1 -and $a[0].session -eq 'sessG5' -and $a[0].parent -eq '' -and -not $a[0].PSObject.Properties['bg'] -and $a[0].work -eq 'T-021' }
       Payload = @{ tool_name = 'Agent'; session_id = 'sessG5'; tool_input = @{ subagent_type = 'team:architect'; description = 'Planos T-021 e T-026'; prompt = 'Escreva os planos de T-021, T-026' } } },
    @{ Name = 'PreToolUse do subagente grava a última ação no .active-agents'; Script = 'pre-tool.ps1'; Expect = 0
       Check = { $a = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8 | ConvertFrom-Json); $a[0].agent_id -eq 'arc0000001' -and $a[0].last -like 'Write plano*' }
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; agent_id = 'arc0000001'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/2/plan/plano.md'); content = 'x' } } },
    @{ Name = 'G20 lê só as tabelas de Task (Rastreabilidade fora)'; Script = 'stop.ps1'; Expect = 2
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "7", "desde": "2026-10-06 10:00" }' -Encoding UTF8
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue
                 [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/sprints/7/sprint-backlog.md'), "## História H-1 — x`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2B1C)) T-3 | c | — |`n`n## Rastreabilidade`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2B1C)) T-99 | fantasma | — |`n", (New-Object System.Text.UTF8Encoding($false)))
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/guards.log') -Force -ErrorAction SilentlyContinue }
       ExpectErr = 'T-3'
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'G20 turno que acabou no limite de uso da conta: libera e grava .usage-limit'; Script = 'stop.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue
                 New-Item -ItemType Directory -Force (Join-Path $tmp 'transcripts') | Out-Null
                 Set-Content -LiteralPath (Join-Path $tmp 'transcripts/lim.jsonl') @('{"type":"user","message":{"role":"user","content":"siga"}}', '{"type":"assistant","isApiErrorMessage":true,"message":{"id":"x1","model":"<synthetic>","content":[{"type":"text","text":"You''ve hit your session limit · resets 11:50pm"}],"usage":{"input_tokens":0,"output_tokens":0}}}') -Encoding UTF8 }
       Check = { $l = Get-Content -LiteralPath (Join-Path $proj '.team-project/.usage-limit') -Raw -Encoding UTF8 | ConvertFrom-Json; $l.reset -eq '11:50pm' -and $l.quem -eq 'sessão' }
       Payload = @{ hook_event_name = 'Stop'; transcript_path = (Join-Path $tmp 'transcripts/lim.jsonl') } },
    @{ Name = 'G20 com o sinal .usage-limit gravado: não barra'; Script = 'stop.ps1'; Expect = 0
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'G16 rodada que cita duas Tasks grava "works" com as duas; pausa acima de 20 min fora da duração'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.usage-limit') -Force -ErrorAction SilentlyContinue
                 $sd = Join-Path $tmp 'transcripts/sess4/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
                 Set-Content -LiteralPath (Join-Path $sd 'agent-wrk0000001.jsonl') @('{"type":"user","timestamp":"2026-10-22T10:00:00Z","message":{"role":"user","content":"Planos de T-021, T-026 e T-021 de novo"}}', '{"type":"assistant","timestamp":"2026-10-22T10:01:00Z","message":{"id":"w1","model":"claude-opus-5-5","usage":{"input_tokens":10,"cache_creation_input_tokens":0,"cache_read_input_tokens":0,"output_tokens":5}}}', '{"type":"assistant","timestamp":"2026-10-22T12:01:00Z","message":{"id":"w2","model":"claude-opus-5-5","usage":{"input_tokens":10,"cache_creation_input_tokens":0,"cache_read_input_tokens":0,"output_tokens":5}}}', '{"type":"assistant","timestamp":"2026-10-22T12:02:00Z","message":{"id":"w3","model":"<synthetic>","content":[{"type":"text","text":"You''ve hit your session limit · resets 3pm"}],"usage":{"input_tokens":0,"output_tokens":0}}}') -Encoding UTF8 }
       Check = { $u = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8 | Where-Object { $_ -match 'wrk0000001' } | ConvertFrom-Json)[0]
                 (@($u.works) -join ',') -eq 'T-021,T-026' -and [int]$u.paused_s -eq 7200 -and [int]$u.duration_s -eq 60 -and $u.model -notmatch 'synthetic' -and (Test-Path -LiteralPath (Join-Path $proj '.team-project/.usage-limit')) }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'wrk0000001'; agent_type = 'team:architect'; transcript_path = (Join-Path $tmp 'transcripts/sess4.jsonl') } },
    @{ Name = 'G16 v3.53: plano por Task que cita o plano da dependência no caminho — "works" só com a Task do plano'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.usage-limit') -Force -ErrorAction SilentlyContinue
                 $sd = Join-Path $tmp 'transcripts/sess5/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
                 Set-Content -LiteralPath (Join-Path $sd 'agent-wrk0000002.jsonl') @('{"type":"user","timestamp":"2026-10-28T10:00:00Z","message":{"role":"user","content":"Escreva o Plano de Implementação da T-049 em .team-project/sprints/4/plan/T-049-<slug>.md. Abra só a ficha .team-project/sprints/4/handoff/T-049-ficha.md e o plano da dependência .team-project/sprints/4/plan/T-048-tabela.md"}}', '{"type":"assistant","timestamp":"2026-10-28T10:01:00Z","message":{"id":"v1","model":"claude-opus-5-5","usage":{"input_tokens":10,"cache_creation_input_tokens":0,"cache_read_input_tokens":0,"output_tokens":5}}}') -Encoding UTF8 }
       Check = { $u = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8 | Where-Object { $_ -match 'wrk0000002' } | ConvertFrom-Json)[0]
                 (@($u.works) -join ',') -eq 'T-049' }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'wrk0000002'; agent_type = 'team:architect'; transcript_path = (Join-Path $tmp 'transcripts/sess5.jsonl') } },
    # ---------- v3.52 — orquestrador enxuto: ponto seguro (G20), espera da sessão (G22), ritual em sessão nova (G21) ----------
    @{ Name = 'G20 ponto seguro (.safe-point, Task recém-fechada): libera sem apagar o .active-run'; Script = 'stop.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.usage-limit'), (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "7", "desde": "2026-10-06 10:00" }' -Encoding UTF8
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.safe-point') '{ "task": "T-1", "sprint": "7", "desde": "2026-10-23 10:00:00" }' -Encoding UTF8 }
       Check = { (Test-Path -LiteralPath (Join-Path $proj '.team-project/.active-run')) -and ((Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G20*T-1*ponto seguro*') }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'G20 sem o ponto seguro (Task em voo): volta a barrar e cita a parada (f)'; Script = 'stop.ps1'; Expect = 2; ExpectErr = '(f) ponto seguro'
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.safe-point') -Force -ErrorAction SilentlyContinue }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'G20 (v3.53.4): o run espera o plano externo (.external-plan) — libera o fim de turno sem apagar o .active-run'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.external-plan') '{ "sprint": "7", "pendente": ["H-1"], "desde": "2026-11-02 10:00:00" }' -Encoding UTF8 }
       Check = { $ok = (Test-Path -LiteralPath (Join-Path $proj '.team-project/.active-run')) -and ((Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G20*plano externo (H-1)*'); Remove-Item -LiteralPath (Join-Path $proj '.team-project/.external-plan') -Force -ErrorAction SilentlyContinue; $ok }
       Payload = @{ hook_event_name = 'Stop' } },
    @{ Name = 'G22 sessão com Start-Sleep durante o run: nega'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G22'
       Payload = @{ tool_name = 'PowerShell'; tool_input = @{ command = 'Start-Sleep -Seconds 598; Get-Content .team-project/sprints/1/delivery/T-003.md' } } },
    @{ Name = 'G22 sessão com comando em segundo plano durante o run: nega'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'operator'
       Payload = @{ tool_name = 'PowerShell'; tool_input = @{ command = 'powershell -NoProfile -File accept.ps1 -Task T-003 *> lote1.out'; run_in_background = $true } } },
    @{ Name = 'G22 sessão em primeiro plano sem espera durante o run: livre'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; tool_input = @{ command = 'Get-Content .team-project/sprints/7/sprint-backlog.md' } } },
    @{ Name = 'G22 sessão com Start-Sleep sem run ativo: livre'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-run') -Force -ErrorAction SilentlyContinue }
       Payload = @{ tool_name = 'PowerShell'; tool_input = @{ command = 'Start-Sleep -Seconds 5' } } },
    @{ Name = 'G21 ritual novo em sessão que já rodou outro (formato interativo): avisa'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = '[G21]'
       Setup = { Set-Content -LiteralPath (Join-Path $tmp 'transcripts/g21.jsonl') @('{"type":"user","message":{"role":"user","content":"<command-message>sm</command-message>\n<command-name>/sm</command-name>\n<command-args>sprint plan</command-args>"}}', '{"type":"assistant","message":{"id":"a1","content":[{"type":"text","text":"ok"}]}}') -Encoding UTF8 }
       Payload = @{ prompt = '/sm sprint run'; transcript_path = (Join-Path $tmp 'transcripts/g21.jsonl') } },
    @{ Name = 'G21 o mesmo ritual de novo (retomada): silêncio'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = ''
       Payload = @{ prompt = '/sm sprint plan'; transcript_path = (Join-Path $tmp 'transcripts/g21.jsonl') } },
    @{ Name = 'G21 formato do claude -p (texto cru com BOM): avisa'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = '/sm fix plan'
       Setup = { Set-Content -LiteralPath (Join-Path $tmp 'transcripts/g21p.jsonl') @(('{"type":"user","message":{"role":"user","content":"' + [char]0xFEFF + '/sm sprint run\r\n"}}')) -Encoding UTF8 }
       Payload = @{ prompt = '/team:sm fix plan'; transcript_path = (Join-Path $tmp 'transcripts/g21p.jsonl') } },
    @{ Name = 'G21 comando que não é ritual: silêncio'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = ''
       Payload = @{ prompt = '/po status'; transcript_path = (Join-Path $tmp 'transcripts/g21.jsonl') } },
    @{ Name = 'v3.57.4 primeiro prompt da sessão nova (transcript ainda sem arquivo): grava o .session-transcript dela'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = ''
       Check = { $f = Join-Path $proj '.team-project/.session-transcript'; $ok = (Test-Path -LiteralPath $f) -and ((Get-Content -LiteralPath $f -Raw -Encoding UTF8).Trim() -eq (Join-Path $tmp 'transcripts/pos-clear.jsonl')); Remove-Item -LiteralPath $f -Force -ErrorAction SilentlyContinue; $ok }
       Payload = @{ prompt = '/sm sprint run'; transcript_path = (Join-Path $tmp 'transcripts/pos-clear.jsonl') } },
    # ---------- v3.61.0 — G25: o backlog funcional espera o sprint 0 (R35) ----------
    @{ Name = 'G25 /sm sprint prepare com o sprint 0 exigido: bloqueia o prompt com a rota'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = '"decision":"block"'
       Setup = { foreach ($n in 'README.md', 'guards.json') { $s = Join-Path $proj ".team-project/$n"; if (Test-Path -LiteralPath $s) { Copy-Item -LiteralPath $s -Destination "$s.g25bak" -Force } }; [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/README.md'), "# Ctx`n`n## 2. Situação atual`n| | |`n|---|---|`n| **Sprint 0 (fundação)** | exigido — em andamento desde 2026-11-16 |`n", (New-Object System.Text.UTF8Encoding($false))) }
       Check = { $l = Join-Path $proj '.team-project/guards.log'; (Test-Path -LiteralPath $l) -and ((Get-Content -LiteralPath $l -Raw -Encoding UTF8) -match 'G25') }
       Payload = @{ prompt = '/team:sm sprint plan' } },
    @{ Name = 'G25 o motivo cita o caminho (sprint0 run → review) e a dispensa'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = '/sm sprint0 run'
       Payload = @{ prompt = '/sm sprint prepare' } },
    @{ Name = 'G25 /sm sprint run não passa pela G25 (o pacote já foi aprovado)'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = ''
       Payload = @{ prompt = '/sm sprint run' } },
    @{ Name = 'G25 linha com o marcador do modelo (onboarding sem decisão): bloqueia'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = 'ainda não foi decidida'
       Setup = { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/README.md'), "| **Sprint 0 (fundação)** | <exigido — … · concluído em <data> · dispensado …> |`n", (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ prompt = '/sm sprint prepare' } },
    @{ Name = 'G25 sprint 0 concluído: silêncio'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = ''
       Setup = { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/README.md'), "| **Sprint 0 (fundação)** | concluído em 2026-11-20 — áreas documentadas: Canteiros |`n", (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ prompt = '/sm sprint prepare' } },
    @{ Name = 'G25 sprint 0 dispensado: silêncio'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = ''
       Setup = { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/README.md'), "| **Sprint 0 (fundação)** | dispensado em 2026-11-20 por Stakeholder — risco aceito |`n", (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ prompt = '/sm sprint plan' } },
    @{ Name = 'G25 desligada no guards.json: silêncio mesmo com o sprint 0 exigido'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = ''
       Setup = { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/README.md'), "| **Sprint 0 (fundação)** | exigido — em andamento desde 2026-11-16 |`n", (New-Object System.Text.UTF8Encoding($false))); Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "disabled": ["G25"] }' -Encoding UTF8 }
       Payload = @{ prompt = '/sm sprint prepare' } },
    @{ Name = 'G25 sem a linha (projeto anterior à v3.61.0): silêncio'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = ''
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/guards.json') -Force -ErrorAction SilentlyContinue; Set-Content -LiteralPath (Join-Path $proj '.team-project/README.md') 'local' -Encoding UTF8 }
       Payload = @{ prompt = '/sm sprint prepare' } },
    @{ Name = 'G25 (fim): README e guards.json do projeto falso voltam ao que eram'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = ''
       Setup = { foreach ($n in 'README.md', 'guards.json') { $s = Join-Path $proj ".team-project/$n"; if (Test-Path -LiteralPath "$s.g25bak") { Move-Item -LiteralPath "$s.g25bak" -Destination $s -Force } } }
       Payload = @{ prompt = '/po status' } },
    @{ Name = 'G19 SendMessage da sessão durante o run, até ao dev (Haiku): nega com a rota da instância nova (v3.52)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'instância NOVA'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "7", "desde": "2026-10-06 10:00" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'SendMessage'; tool_input = @{ to = 'dev19old'; message = 'x' } } },
    # ---------- v3.52.2 — agente assíncrono (G20), registro com session/parent, retomada após queda, executor de Task (G7/G8/G14/G16), Q-S ----------
    @{ Name = 'G20 agente sem bg desta sessão: espera legítima (todo agente é assíncrono)'; Script = 'stop.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/guards.log'), (Join-Path $proj '.team-project/models.json') -Force -ErrorAction SilentlyContinue
                 $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:task-runner","description":"Executor T-3","desde":"' + $n + '","session":"sessA","parent":"","agent_id":"","work":"T-3","last":"disparado","at":"' + $n + '"}]') -Encoding UTF8 }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessA' } },
    @{ Name = 'G20 agente de outra sessão não segura o turno'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'dispare e encerre o turno'
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.external-plan') -Force -ErrorAction SilentlyContinue }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessB' } },
    @{ Name = 'Registro aninhado: Agent do executor grava parent = agent_id dele e a session (G7 deixa o dev)'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue
                 $null = Invoke-Hook 'pre-tool.ps1' @{ tool_name = 'Agent'; session_id = 'sessA'; tool_input = @{ subagent_type = 'team:task-runner'; description = 'Executor T-041'; prompt = 'Conduza a T-041 até fechar ou parar' } } }
       Check = { $a = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ })
                 $r = @($a | Where-Object { $_.type -eq 'team:task-runner' })[0]; $d = @($a | Where-Object { $_.type -eq 'team:developer' })[0]
                 $a.Count -eq 2 -and $r.agent_id -eq 'run0000001' -and $r.parent -eq '' -and $d.parent -eq 'run0000001' -and $d.session -eq 'sessA' -and $d.work -eq 'T-041' }
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; agent_id = 'run0000001'; session_id = 'sessA'; tool_input = @{ subagent_type = 'team:developer'; description = 'Dev T-041'; prompt = 'Execute o plano da T-041' } } },
    @{ Name = 'SubagentStop do executor com filho vivo: fica no registro, aguardando filho'; Script = 'subagent-stop.ps1'; Expect = 0; ExpectOut = ''
       Check = { $a = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ })
                 $a.Count -eq 2 -and @($a | Where-Object { $_.agent_id -eq 'run0000001' -and $_.last -eq 'aguardando filho' }).Count -eq 1 }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run0000001'; agent_type = 'team:task-runner' } },
    @{ Name = 'G20 com o executor aguardando filho: espera legítima'; Script = 'stop.ps1'; Expect = 0
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessA' } },
    @{ Name = 'SessionStart clear: não mexe no .active-agents'; Script = 'session-start.ps1'; Expect = 0; NotOut = 'sessão anterior caiu'
       Check = { (Test-Path -LiteralPath (Join-Path $proj '.team-project/.active-agents')) -and -not (Test-Path -LiteralPath (Join-Path $proj '.team-project/.interrupted')) }
       Payload = @{ hook_event_name = 'SessionStart'; source = 'clear'; session_id = 'sessA' } },
    @{ Name = 'SessionStart startup: registro vai a .interrupted e a sessão recebe a RETOMADA'; Script = 'session-start.ps1'; Expect = 0
       Setup = { $p = Join-Path $proj '.team-project/.active-agents'; $a = @(Get-Content -LiteralPath $p -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ })
                 foreach ($x in $a) { if ($x.type -eq 'team:developer') { $x.last = 'dotnet test'; $x.at = '2099-01-01 10:30:00' }; $x.host_pid = 999999 }   # v3.53.1: processo da sessão anterior encerrado
                 [System.IO.File]::WriteAllText($p, (ConvertTo-Json -InputObject @($a) -Compress), (New-Object System.Text.UTF8Encoding($false))) }
       ExpectOut = 'RETOMADA: a sessão anterior caiu com T-041 em andamento (developer, última ação dotnet test às 2099-01-01 10:30). Rode /sm sprint run — o run.ps1 next diz de onde retomar.'
       Check = { $i = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.interrupted') -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ })
                 $i.Count -eq 2 -and @($i | Where-Object { $_.parent -eq 'run0000001' -and $_.session -eq 'sessA' -and $_.work -eq 'T-041' }).Count -eq 1 -and -not (Test-Path -LiteralPath (Join-Path $proj '.team-project/.active-agents')) }
       Payload = @{ hook_event_name = 'SessionStart'; source = 'startup'; session_id = 'sessC' } },
    @{ Name = 'SessionStart startup (v3.52.3): o .interrupted leva o agent_id e o transcript do agente, para a G16 medi-lo no next'; Script = 'session-start.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.interrupted') -Force -ErrorAction SilentlyContinue
                 $sd = Join-Path $tmp 'transcripts/sessT/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null; Set-Content -LiteralPath (Join-Path $sd 'agent-cut0000009.jsonl') '{}' -Encoding UTF8
                 $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:developer","desde":"' + $n + '","session":"sessT","parent":"","agent_id":"cut0000009","work":"T-041","last":"verify.ps1","at":"' + $n + '"}]') -Encoding UTF8 }
       Check = { $i = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.interrupted') -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ })
                 $i.Count -eq 1 -and $i[0].agent_id -eq 'cut0000009' -and $i[0].transcript -like '*sessT*subagents*agent-cut0000009.jsonl' -and $i[0].session_transcript -like '*transcripts*sessT.jsonl' }
       Payload = @{ hook_event_name = 'SessionStart'; source = 'startup'; session_id = 'sessN'; transcript_path = (Join-Path $tmp 'transcripts/sessN.jsonl') } },
    @{ Name = 'SubagentStop do filho e depois do executor: registro vazio'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.interrupted') -Force -ErrorAction SilentlyContinue
                 $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:task-runner","desde":"' + $n + '","session":"sessA","parent":"","agent_id":"run0000002","work":"T-041","last":"aguardando filho","at":"' + $n + '"},{"type":"team:developer","desde":"' + $n + '","session":"sessA","parent":"run0000002","agent_id":"dev0000002","work":"T-041","last":"x","at":"' + $n + '"}]') -Encoding UTF8
                 $null = Invoke-Hook 'subagent-stop.ps1' @{ hook_event_name = 'SubagentStop'; agent_id = 'dev0000002'; agent_type = 'team:developer' } }
       Check = { -not (Test-Path -LiteralPath (Join-Path $proj '.team-project/.active-agents')) }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run0000002'; agent_type = 'team:task-runner' } },
    # v3.66.2 (garden S7, T-100, 24/11 07:53): o dev interrompido na volta da espera do Windows não teve SubagentStop; o executor
    # parou e ficou "aguardando filho" dele. Com o fim na transcrição do dev, o executor e o dev saem juntos, na hora.
    @{ Name = 'SubagentStop do executor com o dev interrompido (fim na transcrição, sinal há 0 min): os dois saem do registro'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { $sd = Join-Path $tmp 'transcripts/sessA/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
                 Set-Content -LiteralPath (Join-Path $sd 'agent-devInt0002.jsonl') @('{"type":"assistant","message":{"id":"m1","content":[{"type":"text","text":"x"}]}}', '{"type":"user","message":{"role":"user","content":[{"type":"text","text":"[Request interrupted by user]"}]}}') -Encoding UTF8
                 [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/.session-transcript'), (Join-Path $tmp 'transcripts/sessMain.jsonl'), (New-Object System.Text.UTF8Encoding($false)))
                 $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:task-runner","desde":"' + $n + '","session":"sessA","parent":"","agent_id":"run0066202","work":"T-041","last":"Agent","at":"' + $n + '"},{"type":"team:developer","desde":"' + $n + '","session":"sessA","parent":"run0066202","agent_id":"devInt0002","work":"T-041","last":"verify.ps1","at":"' + $n + '"}]') -Encoding UTF8 }
       Check = { $gone = -not (Test-Path -LiteralPath (Join-Path $proj '.team-project/.active-agents')); Remove-Item -LiteralPath (Join-Path $proj '.team-project/.session-transcript') -Force -ErrorAction SilentlyContinue; $gone }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run0066202'; agent_type = 'team:task-runner'; session_id = 'sessA' } },
    @{ Name = 'SubagentStop do executor com o dev vivo (sinal há 0 min, sem interrupção): o executor fica aguardando filho'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:task-runner","desde":"' + $n + '","session":"sessA","parent":"","agent_id":"run0066203","work":"T-041","last":"Agent","at":"' + $n + '"},{"type":"team:developer","desde":"' + $n + '","session":"sessA","parent":"run0066203","agent_id":"devViv0003","work":"T-041","last":"verify.ps1","at":"' + $n + '"}]') -Encoding UTF8 }
       Check = { $a = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ })
                 $ok = $a.Count -eq 2 -and @($a | Where-Object { $_.agent_id -eq 'run0066203' -and $_.last -eq 'aguardando filho' }).Count -eq 1
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue; $ok }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run0066203'; agent_type = 'team:task-runner'; session_id = 'sessA' } },
    @{ Name = 'SubagentStop do executor com o dev parado há 70 min sem linha de rodada (o caso da T-100): os dois saem do registro'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'; $old = (Get-Date).AddMinutes(-70).ToString('yyyy-MM-dd HH:mm:ss')
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:task-runner","desde":"' + $old + '","session":"sessA","parent":"","agent_id":"run0066204","work":"T-041","last":"Agent","at":"' + $n + '"},{"type":"team:developer","desde":"' + $old + '","session":"sessA","parent":"run0066204","agent_id":"devOld0004","work":"T-041","last":"verify.ps1","at":"' + $old + '"}]') -Encoding UTF8 }
       Check = { -not (Test-Path -LiteralPath (Join-Path $proj '.team-project/.active-agents')) }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run0066204'; agent_type = 'team:task-runner'; session_id = 'sessA' } },
    @{ Name = 'G7 executor de Task dispara o product-owner: negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'executor de Task dispara só'
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; agent_id = 'run0000003'; tool_input = @{ subagent_type = 'team:product-owner'; prompt = 'x' } } },
    @{ Name = 'G7 executor de Task dispara o Arquiteto (GAP): permitido'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; agent_id = 'run0000003'; tool_input = @{ subagent_type = 'team:architect'; prompt = 'GAP da T-041' } } },
    @{ Name = 'G7 dev dispara o Arquiteto: negado (só o operator)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'serve só ao operator'
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:developer'; tool_input = @{ subagent_type = 'team:architect'; prompt = 'x' } } },
    @{ Name = 'G8 executor escreve o run-log.md do sprint: permitido'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:task-runner'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/7/run-log.md'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G8 executor escreve o run-log.md do bloco de fix (Add-Content): permitido'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:task-runner'; tool_input = @{ command = "Add-Content -LiteralPath .team-project/fixes/B-002/run-log.md -Value '- F-003 fechada'" } } },
    @{ Name = 'G8 executor no quadro (sprint-backlog.md): negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G8'
       Payload = @{ tool_name = 'Write'; agent_type = 'team:task-runner'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/7/sprint-backlog.md'); content = 'x' } } },
    @{ Name = 'G8 executor em código-fonte: negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'código-fonte'
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:task-runner'; tool_input = @{ file_path = (Join-Path $proj 'src/a.cs'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G14 executor roda o run.ps1 do plugin: liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:task-runner'; tool_input = @{ command = "powershell -NoProfile -File `"$root\scripts\checks\run.ps1`" start -Task T-041" } } },
    @{ Name = 'G20 Q-S elegível na seção "Correção do portão": barra'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'Q-S7 está elegível'
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents'), (Join-Path $proj '.team-project/guards.log') -Force -ErrorAction SilentlyContinue
                 [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/sprints/7/sprint-backlog.md'), "## História H-1 — x`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2705)) T-1 | a | — |`n`n## Correção do portão — sprint 7`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x2B1C)) Q-S7b | b | Q-S7 |`n| $([char]::ConvertFromUtf32(0x2B1C)) Q-S7 | achados do portão | T-1 |`n", (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessA' } },
    @{ Name = 'G16 executor: filho ligado pelo agentId do lançamento assíncrono (texto real)'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { $sd = Join-Path $tmp 'transcripts/sess6/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
                 $p1 = '{"type":"user","timestamp":"2026-10-26T10:00:00Z","message":{"role":"user","content":"Conduza a T-041 até fechar ou parar"}}'
                 $a1 = '{"type":"assistant","timestamp":"2026-10-26T10:00:10Z","message":{"id":"r1","model":"claude-sonnet-5-5","usage":{"input_tokens":5,"cache_creation_input_tokens":100,"cache_read_input_tokens":0,"output_tokens":10}}}'
                 $tr = '{"type":"user","message":{"role":"user","content":[{"tool_use_id":"toolu_1","type":"tool_result","content":[{"type":"text","text":"Async agent launched successfully. (This tool result is internal metadata.)\nagentId: 0a1b2c3d4e5f6a7b8 (internal ID - do not mention to user. Use SendMessage with to: ''0a1b2c3d4e5f6a7b8'' to continue this agent.)\nThe agent is working in the background."}]}]},"toolUseResult":{"isAsync":true,"status":"async_launched","agentId":"0a1b2c3d4e5f6a7b8","description":"Dev T-041"}}'
                 $a2 = '{"type":"assistant","timestamp":"2026-10-26T10:00:20Z","message":{"id":"r2","model":"claude-sonnet-5-5","usage":{"input_tokens":5,"cache_creation_input_tokens":10,"cache_read_input_tokens":100,"output_tokens":10}}}'
                 [System.IO.File]::WriteAllLines((Join-Path $sd 'agent-run0000006.jsonl'), [string[]]@($p1, $a1, $tr, $a2), (New-Object System.Text.UTF8Encoding($false))) }
       Check = { $u = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8 | Where-Object { $_ -match 'run0000006' } | ConvertFrom-Json)
                 $u.Count -eq 1 -and $u[0].role -eq 'task-runner' -and $u[0].work -eq 'T-041' -and [int]$u[0].calls -eq 2 -and (@($u[0].children) -join ',') -eq '0a1b2c3d4e5f6a7b8' }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run0000006'; agent_type = 'team:task-runner'; transcript_path = (Join-Path $tmp 'transcripts/sess6.jsonl') } },
    @{ Name = 'G16 executor acordado pelo aviso do filho: rodada 2 com o delta e o item do primeiro prompt'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { Add-Content -LiteralPath (Join-Path $tmp 'transcripts/sess6/subagents/agent-run0000006.jsonl') @('{"type":"user","timestamp":"2026-10-26T10:20:00Z","message":{"role":"user","content":"Another Claude session sent a message while you were working:\n<agent-message from=\"0a1b2c3d4e5f6a7b8\">\n  H-9: entrega pronta, verify full ok\n</agent-message>"}}', '{"type":"assistant","timestamp":"2026-10-26T10:20:30Z","message":{"id":"r3","model":"claude-sonnet-5-5","usage":{"input_tokens":5,"cache_creation_input_tokens":10,"cache_read_input_tokens":200,"output_tokens":10}}}') -Encoding UTF8 }
       Check = { $u = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8 | Where-Object { $_ -match 'run0000006' } | ConvertFrom-Json)
                 $u.Count -eq 2 -and [int]$u[1].round -eq 2 -and $u[1].work -eq 'T-041' -and [int]$u[1].calls -eq 1 -and [int]$u[1].calls_total -eq 3 -and [int]$u[1].processed -eq 225 }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run0000006'; agent_type = 'team:task-runner'; transcript_path = (Join-Path $tmp 'transcripts/sess6.jsonl') } },
    @{ Name = 'G16 SubagentStop repetido do mesmo executor: não duplica consumo'; Script = 'subagent-stop.ps1'; Expect = 0
       Check = { @(Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8 | Where-Object { $_ -match 'run0000006' }).Count -eq 2 }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run0000006'; agent_type = 'team:task-runner'; transcript_path = (Join-Path $tmp 'transcripts/sess6.jsonl') } },
    # ---------- v3.53.1 — plugin-report do sprint 4 do garden: agente vivo de outra sessão, teto do dev (G23), works do dev, git de leitura ----------
    # v3.66.1 (item D): o hospedeiro é simulado (TEAM_TEST_HOST_PID = esta suíte) — fora da sessão do Claude Code (rodada
    # desacoplada) não há hospedeiro de verdade, e o caso falhava em toda rodada separada. Prova o mesmo: o registro leva o
    # processo vivo e o horário de início dele.
    @{ Name = 'Registro do Agent (v3.53.1): leva o processo hospedeiro (host_pid vivo, host_start)'; Script = 'pre-tool.ps1'; Expect = 0; Env = @{ TEAM_TEST_HOST_PID = [string]$PID }
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue }
       Check = { $a = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ })
                 $a.Count -eq 1 -and [int]$a[0].host_pid -eq $PID -and $a[0].host_start -eq (Get-Process -Id $PID).StartTime.ToString('yyyy-MM-dd HH:mm:ss') }
       Payload = @{ tool_name = 'Agent'; session_id = 'sessH'; tool_input = @{ subagent_type = 'team:task-runner'; description = 'Executor T-050'; prompt = 'Conduza a T-050' } } },
    @{ Name = 'SessionStart startup (v3.53.1): agente com o processo hospedeiro vivo fica e a sessão é avisada; o de processo morto vai ao .interrupted'; Script = 'session-start.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.interrupted') -Force -ErrorAction SilentlyContinue
                 $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'; $st = (Get-Process -Id $PID).StartTime.ToString('yyyy-MM-dd HH:mm:ss')
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:developer","desde":"' + $n + '","session":"sessV","parent":"","agent_id":"viv0000001","work":"T-050","last":"verify.ps1","at":"' + $n + '","host_pid":' + $PID + ',"host_start":"' + $st + '"},{"type":"team:developer","desde":"' + $n + '","session":"sessM","parent":"","agent_id":"mor0000001","work":"T-051","last":"x","at":"' + $n + '","host_pid":999999,"host_start":"2001-01-01 00:00:00"}]') -Encoding UTF8 }
       ExpectOut = 'AGENTE VIVO EM OUTRA SESSÃO: T-050 (developer, processo'
       Check = { $a = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ })
                 $i = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.interrupted') -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ })
                 $a.Count -eq 1 -and $a[0].agent_id -eq 'viv0000001' -and $i.Count -eq 1 -and $i[0].agent_id -eq 'mor0000001' }
       Payload = @{ hook_event_name = 'SessionStart'; source = 'startup'; session_id = 'sessNova' } },
    @{ Name = 'G20 (v3.53.1): a Task elegível tem executor vivo de outra sessão — libera o fim de turno'; Script = 'stop.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.safe-point'), (Join-Path $proj '.team-project/.usage-limit') -Force -ErrorAction SilentlyContinue
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "7", "desde": "2026-10-06 10:00" }' -Encoding UTF8
                 $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'; $st = (Get-Process -Id $PID).StartTime.ToString('yyyy-MM-dd HH:mm:ss')
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:task-runner","desde":"' + $n + '","session":"sessOutra","parent":"","agent_id":"runQ00001","work":"Q-S7","last":"aguardando filho","at":"' + $n + '","host_pid":' + $PID + ',"host_start":"' + $st + '"}]') -Encoding UTF8 }
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G20*Q-S7*agente vivo de outra sessão*' }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessA' } },
    @{ Name = 'G20 (v3.53.1): o executor de outra sessão com processo encerrado não segura — barra'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'Q-S7 está elegível'
       Setup = { $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:task-runner","desde":"' + $n + '","session":"sessOutra","parent":"","agent_id":"runQ00002","work":"Q-S7","last":"x","at":"' + $n + '","host_pid":999999,"host_start":"2001-01-01 00:00:00"}]') -Encoding UTF8 }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessA' } },
    # ---------- v3.53.5 — G20 segue a decisão "esperar" do run.ps1 next (.next-verdict) e cita a Task em construção ----------
    # v3.66.2 (garden S7, T-100, 24/11 08:01): o "esperar" fresco liberava sozinho; o watcher voltou "vivo", a sessão encerrou o
    # turno sem redisparar ninguém e o sprint parou. Agora a espera só libera com agente desta sessão em voo (o watcher conta).
    @{ Name = 'G20 (v3.66.2): o next mandou esperar há 2 min e nenhum agente desta sessão está em voo — barra (espera sem quem avise)'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'nenhum agente desta sessão está em voo'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') '' -Encoding UTF8
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents'), (Join-Path $proj '.team-project/.ask-route') -Force -ErrorAction SilentlyContinue
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.next-verdict') ('{"acao":"esperar","task":"Q-S7","motivo":"comando: reparo do alvo android","at":"' + (Get-Date).AddMinutes(-2).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G20*Q-S7*bloqueio: espera sem quem avise (comando: reparo do alvo android)*' }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessA' } },
    @{ Name = 'G20 (v3.66.2): esperar com o watcher desta sessão em voo — libera (o aviso dele reabre a sessão)'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') '' -Encoding UTF8
                 $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:watcher","description":"Watcher da espera","desde":"' + $n + '","session":"sessA","parent":"","agent_id":"wt0066201","work":"","last":"powershell -NoProfile -File run.ps1 wait -For 540","at":"' + $n + '"}]') -Encoding UTF8 }
       Check = { -not ((Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*bloqueio*') }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessA' } },
    @{ Name = 'G20 (v3.66.2): esperar com o dev desta sessão interrompido (fim na transcrição do subagente) — não conta como em voo, barra'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'nenhum agente desta sessão está em voo'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') '' -Encoding UTF8
                 $sd = Join-Path $tmp 'transcripts/sessA/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
                 Set-Content -LiteralPath (Join-Path $sd 'agent-devInt0001.jsonl') @('{"type":"assistant","message":{"id":"m1","content":[{"type":"text","text":"rodando o verify"}]}}', '{"type":"user","message":{"role":"user","content":[{"type":"text","text":"[Request interrupted by user]"}]}}', '{"type":"attachment","attachment":{}}') -Encoding UTF8
                 [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/.session-transcript'), (Join-Path $tmp 'transcripts/sessMain.jsonl'), (New-Object System.Text.UTF8Encoding($false)))
                 $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:developer","desde":"' + $n + '","session":"sessA","parent":"","agent_id":"devInt0001","work":"Q-S7","last":"verify.ps1 -Mode full","at":"' + $n + '"}]') -Encoding UTF8 }
       Check = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.session-transcript') -Force -ErrorAction SilentlyContinue; $true }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessA' } },
    @{ Name = 'G20 (v3.66.2): esperar com a rota ao stakeholder gravada depois (travamento repetido) — libera'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') '' -Encoding UTF8
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.next-verdict') ('{"acao":"esperar","task":"Q-S7","motivo":"comando: x","at":"' + (Get-Date).AddMinutes(-1).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"travamento","task":"Q-S7","motivo":"x","at":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Check = { $ok = (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G20*liberado: a rota ao stakeholder (travamento) veio com a espera*'
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.ask-route'), (Join-Path $proj '.team-project/.next-verdict') -Force -ErrorAction SilentlyContinue; $ok }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessA' } },
    @{ Name = 'G20 (v3.53.5): a Task em construção (.active-task) é a citada, não a primeira do quadro'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'T-5 está elegível'
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.next-verdict') -Force -ErrorAction SilentlyContinue
                 New-Item -ItemType Directory -Force (Join-Path $proj '.team-project/sprints/8') | Out-Null
                 [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/sprints/8/sprint-backlog.md'), "## História H-1 — x`n`n| ID | Task | Depende de |`n|---|---|---|`n| $([char]::ConvertFromUtf32(0x1F7E6)) T-2 | b | — |`n| $([char]::ConvertFromUtf32(0x1F7E8)) T-5 | e | — |`n", (New-Object System.Text.UTF8Encoding($false)))
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "8", "desde": "2026-10-06 10:00" }' -Encoding UTF8
                 $atp = Join-Path $proj '.team-project/.active-task'; if (Test-Path -LiteralPath $atp) { Copy-Item -LiteralPath $atp "$atp.bak" -Force }
                 Set-Content -LiteralPath $atp '{ "trilha": "sprint", "id": "T-5", "plano": ".team-project/sprints/8/plan/T-5-x.md" }' -Encoding UTF8 }
       Check = { $atp = Join-Path $proj '.team-project/.active-task'
                 if (Test-Path -LiteralPath "$atp.bak") { Move-Item -LiteralPath "$atp.bak" $atp -Force } else { Remove-Item -LiteralPath $atp -Force -ErrorAction SilentlyContinue }
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "7", "desde": "2026-10-06 10:00" }' -Encoding UTF8; $true }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessA' } },
    @{ Name = 'G23 dev acima do teto de contexto (120 mil ≥ 100 mil) roda comando no run: nega com a rota do ponto de retomada'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'teto de contexto desta instância do dev (120 mil, teto 100 mil'
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue
                 $sd = Join-Path $tmp 'transcripts/sessG23/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
                 Set-Content -LiteralPath (Join-Path $sd 'agent-dev0000023.jsonl') @('{"type":"user","message":{"role":"user","content":"Construa a T-041"}}', '{"type":"assistant","message":{"id":"g1","model":"claude-sonnet-5-5","usage":{"input_tokens":5,"cache_creation_input_tokens":1000,"cache_read_input_tokens":118995,"output_tokens":10}}}') -Encoding UTF8 }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; agent_id = 'dev0000023'; session_id = 'sessG23'; transcript_path = (Join-Path $tmp 'transcripts/sessG23.jsonl'); tool_input = @{ command = 'git status' } } },
    @{ Name = 'G23 dev acima do teto grava o ponto de retomada no delivery/: liberado'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Write'; agent_type = 'team:developer'; agent_id = 'dev0000023'; session_id = 'sessG23'; transcript_path = (Join-Path $tmp 'transcripts/sessG23.jsonl'); tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/7/delivery/T-041.md'); content = '### Parei no passo' } } },
    @{ Name = 'G23 com devContextCap 0 no guards.json: desligada'; Script = 'pre-tool.ps1'; Expect = 0; NotOut = 'G23'
       Setup = { $gp = Join-Path $proj '.team-project/guards.json'; $script:g23Saved = if (Test-Path -LiteralPath $gp) { [System.IO.File]::ReadAllText($gp) } else { $null }
                 $g = if ($script:g23Saved) { $script:g23Saved | ConvertFrom-Json } else { [pscustomobject]@{} }; $g | Add-Member -NotePropertyName devContextCap -NotePropertyValue 0 -Force
                 [System.IO.File]::WriteAllText($gp, ($g | ConvertTo-Json -Depth 8), (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; agent_id = 'dev0000023'; session_id = 'sessG23'; transcript_path = (Join-Path $tmp 'transcripts/sessG23.jsonl'); tool_input = @{ command = 'git status' } } },
    @{ Name = 'G23 dev abaixo do teto (50 mil): segue (git status liberado pela G14)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Setup = { $gp = Join-Path $proj '.team-project/guards.json'; if ($script:g23Saved) { [System.IO.File]::WriteAllText($gp, $script:g23Saved, (New-Object System.Text.UTF8Encoding($false))) } else { Remove-Item -LiteralPath $gp -Force -ErrorAction SilentlyContinue }
                 Set-Content -LiteralPath (Join-Path $tmp 'transcripts/sessG23/subagents/agent-dev0000023.jsonl') @('{"type":"assistant","message":{"id":"g2","model":"claude-sonnet-5-5","usage":{"input_tokens":5,"cache_creation_input_tokens":1000,"cache_read_input_tokens":48995,"output_tokens":10}}}') -Encoding UTF8 }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; agent_id = 'dev0000023'; session_id = 'sessG23'; transcript_path = (Join-Path $tmp 'transcripts/sessG23.jsonl'); tool_input = @{ command = 'git status' } } },
    @{ Name = 'G14 git só de leitura no run (v3.53.1): git cat-file e git worktree list liberados'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'git cat-file -p HEAD; git worktree list' } } },
    @{ Name = 'G14 git worktree add no run: não é liberado (sem runCommands, fica com o harness)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = ''
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'git worktree add ../x' } } },
    @{ Name = 'G16 dev (v3.53.1): "works" só com a Task do disparo — a outra citada no prompt é referência'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { $sd = Join-Path $tmp 'transcripts/sess7/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
                 Set-Content -LiteralPath (Join-Path $sd 'agent-dev0000077.jsonl') @('{"type":"user","timestamp":"2026-10-31T06:53:00Z","message":{"role":"user","content":"Construa a T-052 — prova no alvo. Reaproveite o roteiro de captura da T-051."}}', '{"type":"assistant","timestamp":"2026-10-31T06:54:00Z","message":{"id":"d1","model":"claude-sonnet-5-5","usage":{"input_tokens":10,"cache_creation_input_tokens":0,"cache_read_input_tokens":0,"output_tokens":5}}}') -Encoding UTF8 }
       Check = { $u = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8 | Where-Object { $_ -match 'dev0000077' } | ConvertFrom-Json)[0]
                 (@($u.works) -join ',') -eq 'T-052' -and $u.plugin -match '^\d+\.\d+\.\d+$' }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'dev0000077'; agent_type = 'team:developer'; transcript_path = (Join-Path $tmp 'transcripts/sess7.jsonl') } },
    # ---------- v3.53.2 — /team-status e /team-usage respondidos pelo hook, sem passar pelo modelo ----------
    @{ Name = '/team-status: o hook responde com decision=block e o texto do team-view.ps1'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = '"decision":"block"'
       Payload = @{ prompt = '/team-status'; transcript_path = '' } },
    @{ Name = '/team:team-usage 7 (forma com o namespace e o número do sprint): bloqueia e passa o sprint pedido'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = 'Sprint 7'
       Payload = @{ prompt = '/team:team-usage 7'; transcript_path = '' } },
    @{ Name = '/team-status com texto a mais: não é a visão, segue ao modelo (silêncio)'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = ''
       Payload = @{ prompt = '/team-status por favor explique'; transcript_path = '' } },
    # v3.59.0: "detalhe" (ou "técnico"), em qualquer ordem com o número, abre a visão técnica — sem passar pelo modelo.
    @{ Name = 'v3.59.0 /team-status 7 detalhe: bloqueia e passa o sprint pedido à visão técnica'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = 'Sprint 7'
       Payload = @{ prompt = '/team-status 7 detalhe'; transcript_path = '' } },
    @{ Name = 'v3.59.0 /team-status técnico: bloqueia (decision=block)'; Script = 'prompt-submit.ps1'; Expect = 0; ExpectOut = '"decision":"block"'
       Payload = @{ prompt = '/team-status técnico'; transcript_path = '' } },
    # ---------- v3.53.2 — R22: a forma da conversa com o stakeholder no contexto de toda sessão ----------
    @{ Name = 'SessionStart (v3.53.2): a sessão recebe a forma da conversa — toda pergunta em formulário, "Outro" para digitar'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = "Conversa com o stakeholder (R22): toda pergunta a ele*formulário AskUserQuestion, na mesma resposta*campo 'Outro'*repita o formulário na mesma resposta"
       Payload = @{ hook_event_name = 'SessionStart'; source = 'clear' } },
    @{ Name = 'SessionStart com a G13 desligada: a forma da conversa sai mesmo assim (não é guarda)'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'Conversa com o stakeholder (R22)'
       Setup = { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/guards.json'), '{ "disabled": ["G13"] }', (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ hook_event_name = 'SessionStart'; source = 'clear' } },
    # ---------- v3.53.6 (sprint 5 do garden, item 6) — G14: target.ps1 do plugin em qualquer forma e o reparo declarado ----------
    @{ Name = 'G14 (v3.53.6): & "<plugin>\scripts\checks\target.ps1" -Target android -Repair liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "7", "desde": "2026-10-06 10:00" }' -Encoding UTF8
                 [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/guards.json'), '{ "runCommands": ["npm test"], "targets": { "android": { "package": "br.x", "repair": "docker restart horta-emulador; adb connect localhost:5555" }, "web": { "url": "http://x" } } }', (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "& `"$root\scripts\checks\target.ps1`" -Target android -Repair" } } },
    @{ Name = 'G14 (v3.53.6): caminho direto do target.ps1 do plugin, sem & nem aspas, liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "$root\scripts\checks\target.ps1 -Target android" } } },
    @{ Name = 'G14 (v3.53.6): pwsh -File do target.ps1 do plugin liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = "pwsh -NoProfile -File `"$root\scripts\checks\target.ps1`" -Target android" } } },
    @{ Name = 'G14 (v3.53.6): & "$env:CLAUDE_PLUGIN_ROOT\scripts\checks\target.ps1" liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = '& "$env:CLAUDE_PLUGIN_ROOT\scripts\checks\target.ps1" -Target android' } } },
    @{ Name = 'G14 (v3.53.6): & de um scripts\checks\target.ps1 fora da pasta do plugin: negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'fora da pasta do plugin'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "& `"$proj\scripts\checks\target.ps1`" -Target android" } } },
    @{ Name = 'G14 (v3.53.6): & de um .ps1 qualquer entre aspas não passa mais como expressão'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "& `"$proj\tools\limpa.ps1`"" } } },
    # ---------- v3.64.1 (sprint 6 do projeto piloto, 19/11) — G14: script do plugin no caminho errado ----------
    @{ Name = 'G14 (v3.64.1): & "<plugin>\accept.ps1" (sem scripts\checks\) negado com o caminho certo, sem mandar ao run allow'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'caminho errado do script do plugin*o accept.ps1 fica em*scripts/checks/accept.ps1*Não peça run allow'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = "& '$root\accept.ps1' -Task S6 -Resume" } } },
    @{ Name = 'G14 (v3.64.1): powershell -File "<plugin>\accept.ps1" também recebe o caminho certo'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'caminho errado do script do plugin'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = "powershell -NoProfile -File '$root\accept.ps1' -Task S6 -Resume" } } },
    @{ Name = 'G14 (v3.64.1): accept.ps1 do PROJETO não é confundido com o do plugin (segue a regra do script do papel)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'passa o script que o próprio papel gravou'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = "& '$proj\tools\accept.ps1' -Task S6" } } },
    @{ Name = 'G14 (v3.64.1): o caminho certo do accept.ps1 do plugin segue liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = "& '$root\scripts\checks\accept.ps1' -Task S6 -Resume" } } },
    @{ Name = 'G14 (v3.53.6): o reparo declarado em targets.android.repair liberado, trecho a trecho'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'docker restart horta-emulador; adb connect localhost:5555' } } },
    @{ Name = 'G14 (v3.53.6): docker fora do reparo declarado: negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'docker rm -f horta-emulador' } } },
    @{ Name = 'G14 (v3.53.6): adb fora do reparo declarado segue negado com a rota do target.ps1'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'target.ps1'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'adb shell input keyevent 3' } } },
    # ---------- v3.57.3 — G7: o pedido ao operator diz quem chama; G14: Set-Location dentro do projeto ----------
    @{ Name = 'G7 (v3.57.3): pedido ao operator sem a linha Chamador: negado, com a linha certa'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'Chamador: qa T-041'
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/models.json') -Force -ErrorAction SilentlyContinue }
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:quality-assurance'; tool_input = @{ subagent_type = 'team:operator'; prompt = 'Rode a suíte da T-041; job .team-project/operator/1/T-041-suite/' } } },
    @{ Name = 'G7 (v3.57.3): Chamador que não é quem dispara: negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'quem dispara o operator é dev'
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:developer'; tool_input = @{ subagent_type = 'team:operator'; prompt = "Chamador: qa T-041`nRode a suíte" } } },
    @{ Name = 'G7 (v3.57.3): sessão com "Chamador: sessão S5" passa'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:operator'; prompt = 'Chamador: sessão S5 — Rode na raiz: quality.ps1 -Id S5' } } },
    @{ Name = 'G7 (v3.57.3): executor com "Chamador: executor T-041" passa (vale como task-runner)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; tool_input = @{ subagent_type = 'team:operator'; prompt = 'Chamador: executor T-041 — Diagnostique a falha' } } },
    @{ Name = 'G7 (v3.57.3): Agent a outro papel não pede Chamador'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; tool_input = @{ subagent_type = 'team:developer'; prompt = 'Construa a T-041' } } },
    @{ Name = 'G16 (v3.57.3): a linha Chamador do pedido vai ao usage.jsonl (caller)'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { $sd = Join-Path $tmp 'transcripts/sess9/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
                 $p = '{"type":"user","timestamp":"2026-10-06T12:00:00Z","message":{"role":"user","content":"Chamador: sessão S1 — Rode a medição; job .team-project/operator/1/S1-medida/"}}'
                 $a = '{"type":"assistant","timestamp":"2026-10-06T12:01:00Z","message":{"id":"oc1","model":"claude-haiku-4-5","content":[{"type":"text","text":"Veredito: ok · log: .team-project/operator/1/S1-medida/output.log"}],"usage":{"input_tokens":5,"cache_creation_input_tokens":100,"cache_read_input_tokens":0,"output_tokens":10}}}'
                 [System.IO.File]::WriteAllLines((Join-Path $sd 'agent-opcall1234.jsonl'), [string[]]@($p, $a), (New-Object System.Text.UTF8Encoding($false))) }
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/usage.jsonl') -Encoding UTF8 | Select-Object -Last 1) -match '"agent_id":"opcall1234".*"caller":"sessão"' }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'opcall1234'; agent_type = 'team:operator'; transcript_path = (Join-Path $tmp 'transcripts/sess9.jsonl') } },
    @{ Name = 'G14 (v3.57.3): Set-Location para pasta do projeto + o script do runCommands escrito a partir dela: liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "5", "desde": "2026-10-06 10:00" }' -Encoding UTF8
                 New-Item -ItemType Directory -Force (Join-Path $proj 'source/scripts/alvo') | Out-Null
                 [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/guards.json'), '{ "runCommands": ["node source/scripts/alvo/prova-cdp.mjs"] }', (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'Set-Location source; node scripts/alvo/prova-cdp.mjs --task S5' } } },
    @{ Name = 'G14 (v3.57.3): o mesmo comando sem o Set-Location (caminho de dentro da pasta, a partir da raiz): negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'node scripts/alvo/prova-cdp.mjs --task S5' } } },
    @{ Name = 'G14 (v3.57.3): Set-Location para fora do projeto não reescreve o caminho: negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'Set-Location ..; node scripts/alvo/prova-cdp.mjs --task S5' } } },
    @{ Name = 'G14 (v3.57.3): Set-Location com aspas e -Path também vale'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'Set-Location -Path "source"; node scripts/alvo/prova-cdp.mjs' } } },
    # ---------- v3.58.3 — G24: na sessão do sprint run, formulário só pela rota do run.ps1 (R25 c) ----------
    @{ Name = 'G24 (v3.58.3): a sessão que roda o run.ps1 next fica registrada como a do run (.run-session)'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/guards.json'), '{ }', (New-Object System.Text.UTF8Encoding($false)))
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "6", "desde": "2026-11-13 10:00" }' -Encoding UTF8
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.run-session'), (Join-Path $proj '.team-project/.ask-route') -Force -ErrorAction SilentlyContinue }
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/.run-session') -Raw -Encoding UTF8) -match '"session":"sessRun"' }
       Payload = @{ tool_name = 'PowerShell'; session_id = 'sessRun'; tool_input = @{ command = 'powershell -NoProfile -File "C:/p/scripts/checks/run.ps1" next' } } },
    @{ Name = 'G24 (v3.58.3): Task bloqueada com a fila andando, sem rota do run.ps1 — formulário negado, com o caminho do roteiro'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'R25 (c): durante o sprint run*par PO + Arquiteto*rode run.ps1 next*parada (d)'
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessRun'; tool_input = @{ questions = @(@{ question = 'A T-089 está parada por um teste de Manejo. Como seguir? Exemplo: hoje o teste espera a ordem antiga.'; header = 'T-089'; multiSelect = $false; options = @((Opt 'Corrigir o Manejo (Recomendado)'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G24 (v3.58.3): com a rota que o run.ps1 gravou, o mesmo formulário passa'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"bloqueio","task":"T-089","motivo":"nenhuma Task elegível","at":"' + (Get-Date).AddMinutes(-5).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessRun'; tool_input = @{ questions = @(@{ question = 'A T-089 está bloqueada e nenhuma Task anda. Como seguir? Exemplo: hoje o teste espera a ordem antiga.'; header = 'T-089'; multiSelect = $false; options = @((Opt 'Corrigir o Manejo (Recomendado)'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G24 (v3.60.1): o primeiro formulário marca a rota como usada; a refação logo depois (G3 recusou a forma) passa'; Script = 'pre-tool.ps1'; Expect = 0
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') -Raw -Encoding UTF8) -match '"usado":"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d"' }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessRun'; tool_input = @{ questions = @(@{ question = 'A T-089 está bloqueada e nenhuma Task anda. Como seguir? Exemplo: hoje o teste espera a ordem antiga.'; header = 'T-089'; multiSelect = $false; options = @((Opt 'Corrigir o Manejo (Recomendado)'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G24 (v3.60.1): rota já usada por um formulário há mais de 10 min — outra pergunta é negada'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'já foi usada por um formulário*uma pergunta por rota*run.ps1 prove*run.ps1 pause'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"bloqueio","task":"T-089","motivo":"x","at":"' + (Get-Date).AddMinutes(-30).ToString('yyyy-MM-dd HH:mm:ss') + '","usado":"' + (Get-Date).AddMinutes(-15).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessRun'; tool_input = @{ questions = @(@{ question = 'Os arquivos soltos travam o fechamento. Guardo tudo? Exemplo: 5 testes alterados.'; header = 'Arquivos'; multiSelect = $false; options = @((Opt 'Guardar tudo'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G24 (v3.58.3): rota com mais de 24 h vale como ausente — negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'durante o sprint run o formulário'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"bloqueio","task":"T-089","motivo":"x","at":"' + (Get-Date).AddHours(-25).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessRun'; tool_input = @{ questions = @(@{ question = 'Tento de novo? Exemplo: a verificação falhou duas vezes.'; header = 'Q'; multiSelect = $false; options = @((Opt 'Tentar de novo'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G24 (v3.66.0): outra sessão no mesmo projeto (o /team update) sem rota — negado, com o impasse.ps1 raise e os tipos que sobem'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'R36 (matriz de impasses)*impasse.ps1*raise -Type*Sobem ao stakeholder só: scope*plugin-update*stakeholder-request -Quote'
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessUpdate'; tool_input = @{ questions = @(@{ question = 'Atualizar o plugin? Exemplo: a mutação cai de 17 para 2,5 min.'; header = 'Atualizar'; multiSelect = $false; options = @((Opt 'Atualizar agora'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G24 (v3.58.3): papel não é conferido pela G24'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessRun'; agent_type = 'team:product-owner'; agent_id = 'po1'; tool_input = @{ questions = @(@{ question = 'Q? Exemplo: x.'; header = 'Q'; multiSelect = $false; options = @((Opt 'Sim'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G24 (v3.66.0): trilha fix sem rota — o formulário dos ajustes (R33) pede o impasse.ps1 raise -Type gate'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'R36'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "fix", "id": "B-009", "desde": "2026-11-13 10:00" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessRun'; tool_input = @{ questions = @(@{ question = 'Aprova o ajuste? Exemplo: o rótulo muda.'; header = 'A'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G24 (v3.66.0): sem .active-run (interrupção, parada d) e sem rota — negado fora do run (R36)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'R36'
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-run') -Force -ErrorAction SilentlyContinue }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessRun'; tool_input = @{ questions = @(@{ question = 'Quais as opções? Exemplo: corrigir antes.'; header = 'Q'; multiSelect = $false; options = @((Opt 'Planejar a correção'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G24 (v3.58.3): desligável em guards.json → disabled'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "6", "desde": "2026-11-13 10:00" }' -Encoding UTF8
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.ask-route') -Force -ErrorAction SilentlyContinue
                 [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/guards.json'), '{ "disabled": ["G24"] }', (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessRun'; tool_input = @{ questions = @(@{ question = 'Sigo? Exemplo: x.'; header = 'Q'; multiSelect = $false; options = @((Opt 'Sim'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'SessionStart (v3.58.3): a retomada vale para o comando do run; outro comando diz em uma linha, sem formulário'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = '23 de 23 ativas;*Pedido desta sessão = /sm sprint run*retome sem esperar o stakeholder*Outro comando*sem formulário*formulário só quando o run.ps1 manda levar ao stakeholder (G24'
       Setup = { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/guards.json'), '{ }', (New-Object System.Text.UTF8Encoding($false))) }
       Check = { foreach ($f in '.active-run', '.run-session', '.ask-route') { Remove-Item -LiteralPath (Join-Path $proj ".team-project/$f") -Force -ErrorAction SilentlyContinue }; $true }
       Payload = @{ hook_event_name = 'SessionStart'; source = 'startup' } },
    # ---------- v3.59.1 — registro de agentes (sprint 6 do garden, T-069b): filho encerrado não segura o pai; agente acordado de novo volta ao registro; remoção só pelo agent_id ----------
    @{ Name = 'v3.59.1 item 1: SubagentStop do executor com filho que JÁ parou (linha no usage.jsonl depois do último sinal) → os dois saem do registro'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { $u = Join-Path $proj '.team-project/usage.jsonl'; $t0 = (Get-Date).AddMinutes(-3).ToString('yyyy-MM-dd HH:mm:ss'); $t1 = (Get-Date).AddMinutes(-2).ToString('yyyy-MM-ddTHH:mm:ss')
                 Add-Content -LiteralPath $u ('{"ts":"' + $t1 + '","agent_id":"dev359a","role":"developer","description":"Dev T-069b","children":[]}') -Encoding UTF8
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:task-runner","description":"Executor T-069b","desde":"' + $t0 + '","session":"sessA","parent":"","agent_id":"run359a","work":"T-069b","last":"aguardando filho","at":"' + $t0 + '"},{"type":"team:developer","description":"Dev T-069b","desde":"' + $t0 + '","session":"sessA","parent":"run359a","agent_id":"dev359a","work":"T-069b","last":"Add-Content","at":"' + $t0 + '"}]') -Encoding UTF8 }
       Check = { -not (Test-Path -LiteralPath (Join-Path $proj '.team-project/.active-agents')) }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run359a'; agent_type = 'team:task-runner' } },
    @{ Name = 'v3.59.1 item 1: filho com rodada aberta (sinal depois da última linha) mantém o executor aguardando filho'; Script = 'subagent-stop.ps1'; Expect = 0
       Setup = { $n = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') ('[{"type":"team:task-runner","description":"Executor T-069b","desde":"' + $n + '","session":"sessA","parent":"","agent_id":"run359a","work":"T-069b","last":"run.ps1","at":"' + $n + '"},{"type":"team:developer","description":"Dev T-069b","desde":"' + $n + '","session":"sessA","parent":"run359a","agent_id":"dev359a","work":"T-069b","last":"verify.ps1","at":"' + $n + '"}]') -Encoding UTF8 }
       Check = { $a = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ }); $a.Count -eq 2 -and @($a | Where-Object { $_.agent_id -eq 'run359a' -and $_.last -eq 'aguardando filho' }).Count -eq 1 }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run359a'; agent_type = 'team:task-runner' } },
    @{ Name = 'v3.59.1 item 1: SubagentStop de agent_id fora do registro não mexe no executor de outro agent_id (antes casava pelo tipo)'; Script = 'subagent-stop.ps1'; Expect = 0
       Check = { $a = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ }); $a.Count -eq 2 -and @($a | Where-Object { $_.agent_id -eq 'run359a' -and $_.last -eq 'aguardando filho' }).Count -eq 1 }
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run359zz'; agent_type = 'team:task-runner' } },
    @{ Name = 'v3.59.1 item 2: agente acordado de novo (fora do registro, já com rodada no usage.jsonl) volta ao registro com o item e o pai'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue
                 $u = Join-Path $proj '.team-project/usage.jsonl'; $t1 = (Get-Date).AddMinutes(-1).ToString('yyyy-MM-ddTHH:mm:ss')
                 Add-Content -LiteralPath $u ('{"ts":"' + $t1 + '","agent_id":"run359b","role":"task-runner","description":"Executor conduz T-069b","children":["dev359b"]}') -Encoding UTF8
                 Add-Content -LiteralPath $u ('{"ts":"' + $t1 + '","agent_id":"dev359b","role":"developer","description":"Dev T-069b pós-GAP","children":[]}') -Encoding UTF8 }
       Check = { $a = @(Get-Content -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Raw -Encoding UTF8 | ConvertFrom-Json | ForEach-Object { $_ }); $a.Count -eq 1 -and $a[0].agent_id -eq 'dev359b' -and $a[0].work -eq 'T-069b' -and $a[0].parent -eq 'run359b' -and $a[0].session -eq 'sessA' -and $a[0].last -like 'git status*' }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; agent_id = 'dev359b'; session_id = 'sessA'; tool_input = @{ command = 'git status' } } },
    @{ Name = 'v3.59.1 item 2: agente sem rodada no usage.jsonl e fora do registro não é inventado'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue }
       Check = { -not (Test-Path -LiteralPath (Join-Path $proj '.team-project/.active-agents')) }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; agent_id = 'dev359nunca'; session_id = 'sessA'; tool_input = @{ command = 'git status' } } },
    # ---------- v3.66.0 — R36: a G24 em toda sessão, o stakeholder-request pela frase dele, a G26 no fim de turno ----------
    @{ Name = 'v3.66.0 G24: fora do run, com a rota do impasse.ps1 raise (tipo que sobe), o formulário passa'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { foreach ($f in '.active-run', '.run-session') { Remove-Item -LiteralPath (Join-Path $proj ".team-project/$f") -Force -ErrorAction SilentlyContinue }
                 [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/guards.json'), '{ }', (New-Object System.Text.UTF8Encoding($false)))
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"scope","task":"H-Q","motivo":"cards","at":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '","impasse":"S2-I1","origem":"impasse"}') -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessPrep'; tool_input = @{ questions = @(@{ question = 'Os cards podem ficar lado a lado? Exemplo: hoje cada card ocupa a linha inteira.'; header = 'Cards'; multiSelect = $false; options = @((Opt 'Quando couber (Recomendado)'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'v3.66.0 G24: fora do run, a rota já usada há mais de 10 min — outra pergunta é negada pela R36'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'R36 (matriz de impasses): A rota*já foi usada*impasse.ps1'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"scope","task":"H-Q","motivo":"x","at":"' + (Get-Date).AddMinutes(-30).ToString('yyyy-MM-dd HH:mm:ss') + '","usado":"' + (Get-Date).AddMinutes(-15).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessPrep'; tool_input = @{ questions = @(@{ question = 'Quer que eu acione a QA? Exemplo: os dois campos brancos.'; header = 'QA'; multiSelect = $false; options = @((Opt 'Sim'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'v3.66.0 G24: stakeholder-request cuja frase NÃO está numa fala dele na sessão — negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'não está numa fala do stakeholder nesta sessão'
       Setup = { $t = Join-Path $tmp 'sr.jsonl'
                 [System.IO.File]::WriteAllLines($t, [string[]]@('{"type":"user","message":{"role":"user","content":"Vamos adicionar as medias ao sprint"}}', '{"type":"assistant","message":{"content":[{"type":"text","text":"Certo."}]}}'), (New-Object System.Text.UTF8Encoding($false)))
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"stakeholder-request","task":"S7","motivo":"baixas","at":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '","impasse":"S7-I9","quote":"apresente em modo formulario e eu escolho"}') -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessPrep'; transcript_path = (Join-Path $tmp 'sr.jsonl'); tool_input = @{ questions = @(@{ question = 'Quais baixas entram? Exemplo: o texto do alerta.'; header = 'Baixas'; multiSelect = $false; options = @((Opt 'Entra'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'v3.66.0 G24: stakeholder-request com a frase dele na sessão (sem acento e caixa) — passa'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { $t = Join-Path $tmp 'sr2.jsonl'
                 [System.IO.File]::WriteAllLines($t, [string[]]@('{"type":"user","message":{"role":"user","content":[{"type":"text","text":"Vamos adicionar as médias, e para as baixas Apresente em modo formulário e eu escolho a que entra"}]}}'), (New-Object System.Text.UTF8Encoding($false)))
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"stakeholder-request","task":"S7","motivo":"baixas","at":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '","impasse":"S7-I9","quote":"apresente em modo formulario e eu escolho"}') -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessPrep'; transcript_path = (Join-Path $tmp 'sr2.jsonl'); tool_input = @{ questions = @(@{ question = 'Quais baixas entram? Exemplo: o texto do alerta.'; header = 'Baixas'; multiSelect = $false; options = @((Opt 'Entra'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'v3.66.0 G26 (warn, padrão): fim de turno "Quer que eu acione a QA?" fora do run — não barra, registra no guards.log'; Script = 'stop.ps1'; Expect = 0
       Setup = { $t = Join-Path $tmp 'of.jsonl'
                 [System.IO.File]::WriteAllLines($t, [string[]]@('{"type":"assistant","message":{"content":[{"type":"text","text":"A triagem terminou.\n\nQuer que eu acione a QA para os dois campos e abra as F-IDs?"}]}}'), (New-Object System.Text.UTF8Encoding($false)))
                 Remove-Item -LiteralPath (Join-Path $proj '.team-project/.ask-route'), (Join-Path $proj '.team-project/guards.log') -Force -ErrorAction SilentlyContinue }
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G26*aviso (warn)*Quer que eu acione a QA*' }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessPrep'; transcript_path = (Join-Path $tmp 'of.jsonl') } },
    @{ Name = 'v3.66.0 G26 (enforce): a mesma fala barra, com o caminho (executar pelo dono)'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'G26] A sua fala termina oferecendo*execute pelo dono*impasse.ps1 raise'
       Setup = { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/guards.json'), '{ "impasses": { "offerGuard": "enforce" } }', (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessPrep'; transcript_path = (Join-Path $tmp 'of.jsonl') } },
    @{ Name = 'v3.66.0 G26 (enforce): "Posso anotar no gaps.md?" também é oferta — barra'; Script = 'stop.ps1'; Expect = 2; ExpectErr = 'A sua fala termina oferecendo'
       Setup = { $t = Join-Path $tmp 'of2.jsonl'
                 [System.IO.File]::WriteAllLines($t, [string[]]@('{"type":"assistant","message":{"content":[{"type":"text","text":"O registro da QA ainda diz que a prova e estatica.\nPosso anotar no gaps.md que o defeito foi visto no aparelho?"}]}}'), (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessPrep'; transcript_path = (Join-Path $tmp 'of2.jsonl') } },
    @{ Name = 'v3.66.0 G26 (enforce): resposta que só informa, sem oferta de ação — não barra'; Script = 'stop.ps1'; Expect = 0
       Setup = { $t = Join-Path $tmp 'of3.jsonl'
                 [System.IO.File]::WriteAllLines($t, [string[]]@('{"type":"assistant","message":{"content":[{"type":"text","text":"O proximo passo e o planejamento do sprint 7.\nDigite /clear e depois /team:sm sprint plan."}]}}'), (New-Object System.Text.UTF8Encoding($false))) }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessPrep'; transcript_path = (Join-Path $tmp 'of3.jsonl') } },
    @{ Name = 'v3.66.0 G26 (enforce): com rota gravada nos últimos 15 min (a pergunta foi em formulário), não barra'; Script = 'stop.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') ('{"rota":"scope","task":"H-Q","motivo":"x","at":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Check = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.ask-route') -Force -ErrorAction SilentlyContinue; [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/guards.json'), '{ }', (New-Object System.Text.UTF8Encoding($false))); $true }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessPrep'; transcript_path = (Join-Path $tmp 'of.jsonl') } },
    @{ Name = 'v3.66.0 G26: desligável em guards.json → disabled'; Script = 'stop.ps1'; Expect = 0
       Setup = { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/guards.json'), '{ "disabled": ["G26"], "impasses": { "offerGuard": "enforce" } }', (New-Object System.Text.UTF8Encoding($false))) }
       Check = { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/guards.json'), '{ }', (New-Object System.Text.UTF8Encoding($false))); $true }
       Payload = @{ hook_event_name = 'Stop'; session_id = 'sessPrep'; transcript_path = (Join-Path $tmp 'of.jsonl') } },
    # ---------- v3.66.0 (item H) — G7: o executor de Task segue a sequência do 🔺 GAP aberto, da matriz de impasses ----------
    @{ Name = 'v3.66.0 G7: GAP de requisito aberto da T-077 — o executor dispara o PO para ela (antes negado)'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.gap-route') ('{"task":"T-077","cause":"requirement","sequence":["product-owner","architect","developer"],"at":"' + (Get-Date).AddHours(-0).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; agent_id = 'run077'; tool_input = @{ subagent_type = 'team:product-owner'; prompt = '/po — decida o 🔺 GAP de requisito da T-077' } } },
    @{ Name = 'v3.66.0 G7: GAP de requisito da T-077 — a QA está fora da sequência (PO → Arquiteto → dev): negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'GAP aberto da T-077 (causa requirement) vai pela sequência da matriz de impasses: product-owner → architect → developer'
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; agent_id = 'run077'; tool_input = @{ subagent_type = 'team:quality-assurance'; prompt = '/qa — confira o GAP da T-077' } } },
    @{ Name = 'v3.66.0 G7: o operator fica sempre liberado no GAP aberto'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; agent_id = 'run077'; tool_input = @{ subagent_type = 'team:operator'; prompt = "Chamador: task-runner T-077`nmeça" } } },
    @{ Name = 'v3.66.0 G7: pedido que cita outra Task segue a regra de antes (UX negado ao executor)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'o executor de Task dispara só developer, architect, operator e quality-assurance'
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; agent_id = 'run078'; tool_input = @{ subagent_type = 'team:user-experience'; prompt = '/ux — a tela da T-078' } } },
    @{ Name = 'v3.66.0 G7: GAP técnico aberto (Arquiteto → dev) — levar ao PO é negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'architect → developer'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.gap-route') ('{"task":"T-077","cause":"design","sequence":["architect","developer"],"at":"' + (Get-Date).AddHours(-0).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; agent_id = 'run077'; tool_input = @{ subagent_type = 'team:product-owner'; prompt = '/po — o GAP de desenho da T-077' } } },
    @{ Name = 'v3.66.0 G7: rota do GAP com mais de 6 h vale como ausente (regra de antes)'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'o executor de Task dispara só'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.gap-route') ('{"task":"T-077","cause":"requirement","sequence":["product-owner","architect","developer"],"at":"' + (Get-Date).AddHours(-7).ToString('yyyy-MM-dd HH:mm:ss') + '"}') -Encoding UTF8 }
       Check = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.gap-route') -Force -ErrorAction SilentlyContinue; $true }
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:task-runner'; agent_id = 'run077'; tool_input = @{ subagent_type = 'team:product-owner'; prompt = '/po — decida o GAP da T-077' } } },
    @{ Name = 'v3.66.0 J: o impasse.ps1 raise grava a pendência na §7 com o prefixo R34 — o formulário que começa por ele passa na G3 e na G24 de primeira'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { [System.IO.File]::WriteAllText((Join-Path $proj '.team-project/README.md'), "# Contexto`n`n## 1. O produto`n**Identificador remoto:** ACME`n`n## 7. Decisões pendentes do stakeholder`n`nnenhuma`n`n## 8. Outra`n", (New-Object System.Text.UTF8Encoding($false)))
                 foreach ($f in '.active-run', '.run-session', '.ask-route', 'fixes') { Remove-Item -LiteralPath (Join-Path $proj ".team-project/$f") -Recurse -Force -ErrorAction SilentlyContinue }   # sem bloco de fix aberto: a trilha é o sprint (S1)
                 $null = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root 'scripts/checks/impasse.ps1') raise -Type scope -Part H-Q -Subject cards -Origin po -Consulted none -Text 'Os cards podem ficar lado a lado?' -Detail 'muda o card ativo' -Root $proj 2>&1 }
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/README.md') -Raw -Encoding UTF8) -match '(?s)## 7\..*1\. \[ACME · S1 · H-Q\] Os cards.*## 8\.' }
       Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessPrep'; tool_input = @{ questions = @(@{ question = '[ACME · S1 · H-Q] Os cards podem ficar lado a lado? Exemplo: hoje cada card ocupa a linha inteira.'; header = 'Cards'; multiSelect = $false; options = @((Opt 'Quando couber (Recomendado)'), (Opt 'Pedir mais contexto')) }) } } }
)


# v3.66.0 (R36) — o inventário dos formulários legítimos: cada modo que abre formulário ao stakeholder declara o impasse do
# tipo dele (impasse.ps1 raise) e o formulário passa na G24 de primeira, fora do sprint run. Um caso por modo.
$invModes = @(
    @{ M = '/team update'; Part = 'MODO-UPDATE'; A = @('-Type', 'plugin-update', '-Detail', '3.65.14 para 3.66.0') },
    @{ M = 'onboarding (cadência)'; Part = 'MODO-ONBOARDING'; A = @('-Type', 'configuration', '-Detail', 'guards.json → run.planner = claude') },
    @{ M = 'brainstorm'; Part = 'MODO-BRAINSTORM'; A = @('-Type', 'scope', '-Detail', 'a ideia entra no backlog') },
    @{ M = 'SDD ①'; Part = 'MODO-SDD'; A = @('-Type', 'gate', '-Gate', '①') },
    @{ M = 'sprint 0 (aceite)'; Part = 'MODO-SPRINT0'; A = @('-Type', 'gate', '-Gate', 'sprint0') },
    @{ M = 'prepare (escopo)'; Part = 'MODO-PREPARE'; A = @('-Type', 'scope', '-Detail', 'a H-S reduzida a Compras') },
    @{ M = 'plan ③'; Part = 'MODO-PLAN'; A = @('-Type', 'gate', '-Gate', '③') },
    @{ M = 'review (aceite)'; Part = 'MODO-REVIEW'; A = @('-Type', 'gate', '-Gate', 'review') },
    @{ M = 'close (propostas de configuração)'; Part = 'MODO-CLOSE'; A = @('-Type', 'configuration', '-Detail', 'targets.android.repair') },
    @{ M = 'fix plan (ajustes, R33)'; Part = 'B-901'; A = @('-Type', 'gate', '-Gate', 'fix-adjust') },
    @{ M = '/sec (escopo autorizado)'; Part = 'MODO-SEC'; A = @('-Type', 'authorization', '-Detail', 'pentest gray-box em homologação') },
    @{ M = 'decisão estratégica'; Part = 'MODO-ADR'; A = @('-Type', 'strategic', '-Detail', 'provider: trocar o serviço de e-mail') }
)
foreach ($im in $invModes) {
    $imArgs = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', (Join-Path $root 'scripts/checks/impasse.ps1'), 'raise', '-Part', $im.Part, '-Subject', 'formulario', '-Origin', $im.M, '-Consulted', 'none', '-Text', "decisão do modo $($im.M)") + $im.A + @('-Root', $proj)
    $cases += @{ Name = "v3.66.0 inventário: $($im.M) — o raise do tipo dele grava a rota e o formulário passa na G24"; Script = 'pre-tool.ps1'; Expect = 0
        Setup = [scriptblock]::Create("[System.IO.File]::WriteAllText((Join-Path `$proj '.team-project/README.md'), ""# Contexto``n``n## 7. Decisões pendentes do stakeholder``n``nnenhuma``n"", (New-Object System.Text.UTF8Encoding(`$false))); foreach (`$f in '.active-run', '.run-session', '.ask-route') { Remove-Item -LiteralPath (Join-Path `$proj "".team-project/`$f"") -Force -ErrorAction SilentlyContinue }; `$o = & powershell $(($imArgs | ForEach-Object { "'" + ($_ -replace "'", "''") + "'" }) -join ' ') 2>&1; if (`$LASTEXITCODE -ne 0) { Write-Host ('raise falhou: ' + (`$o -join ' ')) }")
        Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/.ask-route') -Raw -Encoding UTF8) -match '"usado":' }
        Payload = @{ tool_name = 'AskUserQuestion'; session_id = 'sessInv'; tool_input = @{ questions = @(@{ question = 'Você aprova esta decisão? Exemplo: o que muda para você em cada opção está na descrição.'; header = 'Modo'; multiSelect = $false; options = @((Opt 'Aprovar (Recomendado)'), (Opt 'Pedir mais contexto')) }) } } }
}

# v3.66.1 (item C): os grupos.
. (Join-Path $PSScriptRoot 'suite-blocks.ps1')
$gg = Get-GuardGroups $PSCommandPath
$stopAll = { try { Stop-Process -Id $watchdog.Id -Force -ErrorAction SilentlyContinue } catch { }; Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue }
if ($ListGroups) {
    $sum = 0; $seen = @{}
    foreach ($g in $gg.Groups) { $gc = @(Get-GuardGroupCases $gg $g.Index $cases.Count); $sum += $gc.Count; foreach ($k in $gc) { $seen[$k] = 1 + [int]$seen[$k] }; Write-Output ("grupo {0,2}  {1,3} casos  linhas {2}–{3}  {4}" -f $g.Index, $gc.Count, $g.From, $g.To, $g.Title) }
    $one = @($seen.Values | Where-Object { $_ -ne 1 }).Count -eq 0 -and $seen.Count -eq $cases.Count
    Write-Output ("{0} casos nos {1} grupos · a lista tem {2}{3}" -f $sum, $gg.Groups.Count, $cases.Count, $(if ($one -and $sum -eq $cases.Count) { ' · cada caso num grupo só' } else { ' · DIVERGE' }))
    & $stopAll; exit 0
}
if ($CheckGroups) {
    $cg = Invoke-GuardGroupCheck $PSCommandPath $gg $tmp $Workers
    foreach ($l in $cg.Lines) { Write-Output $l }
    & $stopAll
    if ($cg.Bad) { exit 1 }; exit 0
}
$sel = @(0..($cases.Count - 1))
if ($Groups) {
    $sel = @()
    foreach ($gi in @($Groups -split '[,\s]+' | Where-Object { $_ })) { $sel += @(Get-GuardGroupCases $gg ([int]$gi) $cases.Count) }
    $sel = @($sel | Sort-Object -Unique)
}

# O estado de partida de cada grupo ($GroupBase), no primeiro caso dele. Chave que não acha exatamente uma seção quebra a
# suíte: seção renomeada não pode deixar o grupo sem o estado que ele supõe.
$groupStart = @{}
foreach ($k in $GroupBase.Keys) {
    $hit = @($gg.Groups | Where-Object { $_.Title.StartsWith($k) })
    if ($hit.Count -ne 1) { & $stopAll; throw "run-guard-tests: a chave '$k' de `$GroupBase acha $($hit.Count) seções (esperado 1)" }
    $first = @(Get-GuardGroupCases $gg $hit[0].Index $cases.Count)
    if ($first.Count) { $groupStart[$first[0]] = $GroupBase[$k] }
}
$rows = @(); $fail = 0
foreach ($ci in $sel) {
    $c = $cases[$ci]
    $cw = [System.Diagnostics.Stopwatch]::StartNew()
    if ($groupStart.ContainsKey($ci)) {
        try { & $groupStart[$ci] } catch { $fail++; $rows += [pscustomobject]@{ Caso = $c.Name; Esperado = $c.Expect; Obtido = 'base'; Ok = 'FALHOU'; Mensagem = "o estado de partida do grupo quebrou: $($_.Exception.Message)"; Seg = 0 }; continue }
    }
    # v3.66.1: a Setup que quebra (o estado que ela esperava não existe) falha o caso, com o erro — não derruba o processo.
    if ($c.Setup) {
        try { & $c.Setup } catch {
            $fail++; $rows += [pscustomobject]@{ Caso = $c.Name; Esperado = $c.Expect; Obtido = 'Setup'; Ok = 'FALHOU'; Mensagem = "a Setup quebrou: $($_.Exception.Message)"; Seg = [int]$cw.Elapsed.TotalSeconds }
            continue
        }
    }
    $envs = if ($c.Env) { $c.Env } else { @{} }
    $tl0 = Get-TimeoutMark
    $r = Invoke-Hook $c.Script $c.Payload $envs ([string]$c.Raw)
    $tl1 = Get-TimeoutMark
    $timedOut = $tl1.Length -gt $tl0.Length
    if ($timedOut) { $r.Err = "TEMPO ESGOTADO (sentinela, $($env:TEAM_TEST_CHECK_TIMEOUT_S) s) " + $r.Err }
    $ok = ($r.Code -eq $c.Expect) -and -not $timedOut
    if ($ok -and $c.ContainsKey('ExpectOut')) {
        if ($c.ExpectOut -eq '') { $ok = [string]::IsNullOrWhiteSpace($r.Out) } else { $ok = $r.Out -like "*$($c.ExpectOut)*" }
    }
    if ($ok -and $c.ContainsKey('ExpectErr')) { $ok = $r.Err -like "*$($c.ExpectErr)*" }
    if ($ok -and $c.ContainsKey('NotOut')) { $ok = $r.Out -notlike "*$($c.NotOut)*" }
    if ($ok -and $c.Check) { try { $ok = [bool](& $c.Check) } catch { $ok = $false; $r.Err = "o Check quebrou: $($_.Exception.Message) " + $r.Err } }
    if (-not $ok) { $fail++ }
    $detail = (($r.Err + ' ' + $r.Out) -replace '\s+', ' ').Trim()
    if ($detail.Length -gt 90) { $detail = $detail.Substring(0, 90) + '…' }
    $rows += [pscustomobject]@{ Caso = $c.Name; Esperado = $c.Expect; Obtido = $r.Code; Ok = $(if ($ok) { 'ok' } else { 'FALHOU' }); Mensagem = $detail; Seg = [int]$cw.Elapsed.TotalSeconds }
}

& $stopAll
if ($ResultFile) { [System.IO.File]::WriteAllText($ResultFile, (ConvertTo-Json -InputObject ([ordered]@{ fail = $fail; rows = @($rows) }) -Depth 4), (New-Object System.Text.UTF8Encoding($false))) }
$rows | Select-Object Caso, Esperado, Obtido, Ok, Mensagem | Format-Table -AutoSize -Wrap | Out-String -Width 220 | Write-Output
Write-Output ("{0} casos · {1} falharam" -f $sel.Count, $fail)
if ($fail -gt 0) { exit 1 }
exit 0
