# Testes das guardas (fase 1 e fase 2): entrega a cada despachante o JSON que o harness mandaria e confere a decisão.
# Uso (na raiz do repositório-fonte): powershell -NoProfile -File scripts/checks/tests/run-guard-tests.ps1
# Saída: tabela caso · esperado · obtido · ok; exit 1 se algum caso falhar.

$ErrorActionPreference = 'Stop'
$root  = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$hooks = Join-Path $root 'hooks'
$tmp   = Join-Path ([System.IO.Path]::GetTempPath()) ('team-guards-' + [guid]::NewGuid().ToString('N').Substring(0, 8))

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
    @{ Name = 'G3 formulário correto'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Q?'; header = 'Q'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G3 sem "Pedir mais contexto" por último'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Q?'; header = 'Q'; multiSelect = $false; options = @((Opt 'Pedir mais contexto'), (Opt 'Aprovar')) }) } } },
    @{ Name = 'G3 segunda pergunta errada'; Script = 'pre-tool.ps1'; Expect = 2
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
    @{ Name = 'G3 R34 sem Identificador remoto: prefixo não exigido'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o pacote?'; header = 'P'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G3 R34 com ID, pergunta sem prefixo'; Script = 'pre-tool.ps1'; Expect = 2
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/README.md') "# Contexto`n`n## 1. O produto`n**Identificador remoto:** ACME`n**Conta remota:** pessoal`n`n## 7. Decisões pendentes do stakeholder`n`n1. [ACME · S4 · ③ pacote] Aprova o pacote? — material: sprint-backlog.md — 2026-10-03 10:00`n`n## 7a. Registro de consultores`n" -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o pacote?'; header = 'P'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G3 R34 prefixo sem pendência em §7'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = '[ACME · S4 · ④ H-012] Aceita a H-012?'; header = 'P'; multiSelect = $false; options = @((Opt 'Aceita'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G3 R34 prefixo com pendência em §7'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = '[ACME · S4 · ③ pacote] Aprova o pacote?'; header = 'P'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    # ---------- Fase 2 (v3.42) — agent_type no formato medido pela sonda: team:<papel> ----------
    @{ Name = 'G7 dev dispara outro papel'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:developer'; tool_input = @{ subagent_type = 'team:architect'; prompt = 'x' } } },
    @{ Name = 'G7 QA dispara o operator'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:quality-assurance'; tool_input = @{ subagent_type = 'team:operator'; prompt = 'x' } } },
    @{ Name = 'G7 sessão principal dispara o dev'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:developer'; prompt = 'x' } } },
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
    @{ Name = 'G9 dev Set-Content fora do plano'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "Set-Content -Path src/b.cs -Value 'x'" } } },
    @{ Name = 'G9 dev log redirecionado (R28)'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'dotnet build *> build.log' } } },
    @{ Name = 'G9 dev New-Item no plano'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'New-Item -ItemType File -Force tests/ATests.cs' } } },
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
    @{ Name = 'G8 PO acrescenta Aceite em review.md'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:product-owner'; tool_input = @{ file_path = (Join-Path $proj '.team-project/sprints/1/review.md'); old_string = 'a'; new_string = 'b' } } },
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
    @{ Name = 'G14 --no-verify negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'git commit --no-verify -m "x"' } } },
    @{ Name = 'G14 escrita em destino variável negada'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'Get-ChildItem dist | ForEach-Object { Remove-Item $_ }' } } },
    @{ Name = 'G14 dev Edit no escopo liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'Edit'; agent_type = 'team:developer'; tool_input = @{ file_path = (Join-Path $proj 'src/e.cs'); old_string = 'a'; new_string = 'b' } } },
    @{ Name = 'G14 Arquiteto no scratchpad liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'Write'; agent_type = 'team:architect'; tool_input = @{ file_path = (Join-Path ([System.IO.Path]::GetTempPath()) 'claude/x/scratchpad/a.ts'); content = 'x' } } },
    @{ Name = 'G14 escrita fora do projeto negada'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'fora do projeto'
       Payload = @{ tool_name = 'Write'; agent_type = 'team:quality-assurance'; tool_input = @{ file_path = 'Z:\fora-do-projeto\x.md'; content = 'x' } } },
    @{ Name = 'G14 SM roda conferência C1'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:scrum-master'; tool_input = @{ command = "powershell -NoProfile -File `"$root\scripts\checks\close.ps1`" -Task T-001" } } },
    @{ Name = 'G15 pedido de permissão vai ao guards.log'; Script = 'notification.ps1'; Expect = 0
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw -Encoding UTF8) -like '*G15*run ativo: sprint 1*precisa de permissão*' }
       Payload = @{ hook_event_name = 'Notification'; notification_type = 'permission_prompt'; message = 'Claude precisa de permissão para usar PowerShell' } },
    @{ Name = 'G13 avisa marcador de run esquecido'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = '.active-run existe'
       Payload = @{ hook_event_name = 'SessionStart' } },
    @{ Name = 'Falha aberta: JSON inválido'; Script = 'pre-tool.ps1'; Expect = 1; Raw = '{nao-e-json' },
    @{ Name = 'guards.json desliga G3 e liga a sonda'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Remove-Item -LiteralPath (Join-Path $proj '.team-project/.active-run') -Force
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "disabled": ["G3"], "probe": true }' -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; agent_type = 'team:product-owner'; agent_id = 'a1'; tool_input = @{ questions = @(@{ question = 'Q?'; header = 'Q'; multiSelect = $false; options = @((Opt 'Sim'), (Opt 'Não')) }) } } },
    @{ Name = 'Sonda gravou agent_type no guards.log'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'desativadas G3'
       Check = { (Get-Content -LiteralPath (Join-Path $proj '.team-project/guards.log') -Raw) -like '*probe*agent_type=team:product-owner*script_ms=*' }
       Payload = @{ hook_event_name = 'SessionStart' } }
)

$rows = @(); $fail = 0
foreach ($c in $cases) {
    if ($c.Setup) { & $c.Setup }
    $envs = if ($c.Env) { $c.Env } else { @{} }
    $r = Invoke-Hook $c.Script $c.Payload $envs ([string]$c.Raw)
    $ok = ($r.Code -eq $c.Expect)
    if ($ok -and $c.ContainsKey('ExpectOut')) {
        if ($c.ExpectOut -eq '') { $ok = [string]::IsNullOrWhiteSpace($r.Out) } else { $ok = $r.Out -like "*$($c.ExpectOut)*" }
    }
    if ($ok -and $c.ContainsKey('ExpectErr')) { $ok = $r.Err -like "*$($c.ExpectErr)*" }
    if ($ok -and $c.Check) { $ok = [bool](& $c.Check) }
    if (-not $ok) { $fail++ }
    $detail = (($r.Err + ' ' + $r.Out) -replace '\s+', ' ').Trim()
    if ($detail.Length -gt 90) { $detail = $detail.Substring(0, 90) + '…' }
    $rows += [pscustomobject]@{ Caso = $c.Name; Esperado = $c.Expect; Obtido = $r.Code; Ok = $(if ($ok) { 'ok' } else { 'FALHOU' }); Mensagem = $detail }
}

Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
$rows | Format-Table -AutoSize -Wrap | Out-String -Width 220 | Write-Output
Write-Output ("{0} casos · {1} falharam" -f $cases.Count, $fail)
if ($fail -gt 0) { exit 1 }
exit 0
