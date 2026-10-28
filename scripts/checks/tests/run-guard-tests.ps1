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
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Q? Exemplo: hoje a lista aparece vazia.'; header = 'Q'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
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
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o pacote? Exemplo: a tela de exportação.'; header = 'P'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G3 R34 com ID, pergunta sem prefixo'; Script = 'pre-tool.ps1'; Expect = 2
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/README.md') "# Contexto`n`n## 1. O produto`n**Identificador remoto:** ACME`n**Conta remota:** pessoal`n`n## 7. Decisões pendentes do stakeholder`n`n1. [ACME · S4 · ③ pacote] Aprova o pacote? — material: sprint-backlog.md — 2026-10-03 10:00`n`n## 7a. Registro de consultores`n" -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o pacote?'; header = 'P'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G3 R34 prefixo sem pendência em §7'; Script = 'pre-tool.ps1'; Expect = 2
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = '[ACME · S4 · ④ H-012] Aceita a H-012?'; header = 'P'; multiSelect = $false; options = @((Opt 'Aceita'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'G3 R34 prefixo com pendência em §7'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = '[ACME · S4 · ③ pacote] Aprova o pacote? Exemplo: a tela de exportação.'; header = 'P'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
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
    @{ Name = 'G14 Env: da sessão liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "Set-Content Env:MIG02_PROVA '1'; npm test; Remove-Item Env:MIG02_PROVA" } } },
    @{ Name = 'G14 escrita no registro negada'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = "New-Item -Path HKCU:\Software\Prova" } } },
    @{ Name = 'G14 --no-verify negado'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'git commit --no-verify -m "x"' } } },
    @{ Name = 'G14 escrita em destino variável negada'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G14'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'Get-ChildItem dist | ForEach-Object { Remove-Item $_ }' } } },
    @{ Name = 'G14 QA com comando em segundo plano: nega'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'operator'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:quality-assurance'; tool_input = @{ command = 'npm test'; run_in_background = $true } } },
    @{ Name = 'G14 operator com comando em segundo plano: liberado'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:operator'; tool_input = @{ command = 'npm test *> .team-project/operator/1/suite/test.log'; run_in_background = $true } } },
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
    @{ Name = 'G13 retoma o sprint run esquecido (v3.51, proposta b)'; Script = 'session-start.ps1'; Expect = 0; ExpectOut = 'Retomada: o sprint run 1 *Retome agora, sem esperar o stakeholder: /sm sprint run'
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
       Payload = @{ tool_name = 'Agent'; tool_input = @{ subagent_type = 'team:operator'; prompt = 'x' } } },
    @{ Name = 'G17 vale para o operator disparado pelo QA'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'sonnet'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/models.json') '{ "operator": "sonnet" }' -Encoding UTF8 }
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:quality-assurance'; tool_input = @{ subagent_type = 'team:operator'; prompt = 'x' } } },
    @{ Name = 'G17 operator disparado pelo Arquiteto com o model certo'; Script = 'pre-tool.ps1'; Expect = 0
       Payload = @{ tool_name = 'Agent'; agent_type = 'team:architect'; tool_input = @{ subagent_type = 'team:operator'; model = 'sonnet'; prompt = 'x' } } },
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
    @{ Name = 'G18 sem bench: a G3 segue valendo'; Script = 'pre-tool.ps1'; Expect = 0
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
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "bench": { "arm": "P0-r1" } }' -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Q?'; header = 'Q'; multiSelect = $false; options = @((Opt 'Sim'), (Opt 'Não')) }) } } },
    @{ Name = 'G18 desligada em guards.json: a G3 volta a valer'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'G3'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "disabled": ["G18"], "bench": { "arm": "x", "answers": "bench-answers.json" } }' -Encoding UTF8 }
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
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/README.md') "# Contexto`n" -Encoding UTF8; Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "disabled": [] }' -Encoding UTF8 }
       Payload = @{ tool_name = 'AskUserQuestion'; tool_input = @{ questions = @(@{ question = 'Aprova o ajuste?'; header = 'A'; multiSelect = $false; options = @((Opt 'Aprovar'), (Opt 'Pedir mais contexto')) }) } } },
    @{ Name = 'H1 exemplo na descrição de uma opção: liberado'; Script = 'pre-tool.ps1'; Expect = 0
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
    # ---------- v3.51.4 — negações reais do SunScape (note.md itens 3, 4, 5, 10) e do garden (itens 5, 6, 25) ----------
    @{ Name = 'G14 texto com $( ) entre aspas: subexpressões conferidas, rótulos não viram trecho (tests=, node:)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/.active-run') '{ "trilha": "sprint", "id": "1", "desde": "2026-10-06 10:00" }' -Encoding UTF8
                 Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "runCommands": ["npm test", ".\\source\\gradlew.bat"] }' -Encoding UTF8 }
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:developer'; tool_input = @{ command = 'Get-ChildItem *.xml | ForEach-Object { "tests=$($_.Name) node: $($_.Length) brotas" }' } } },
    @{ Name = 'G14 contagem e Select-String com "$($_.LineNumber): …" (Arquiteto)'; Script = 'pre-tool.ps1'; Expect = 0; ExpectOut = '"permissionDecision":"allow"'
       Payload = @{ tool_name = 'PowerShell'; agent_type = 'team:architect'; tool_input = @{ command = '$f=''plano.md''; (Get-Content $f).Count; Select-String -Path $f -Pattern ''Passo'' | ForEach-Object { "$($_.LineNumber): $($_.Line)" }' } } },
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
    @{ Name = 'G14 Wait-Process (v3.52.3): nega dizendo para encerrar o turno e esperar o aviso'; Script = 'pre-tool.ps1'; Expect = 2; ExpectErr = 'espera com Wait-Process*ENCERRE O TURNO*o aviso de conclusão traz o resultado'
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
                 foreach ($x in $a) { if ($x.type -eq 'team:developer') { $x.last = 'dotnet test'; $x.at = '2099-01-01 10:30:00' } }
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
       Payload = @{ hook_event_name = 'SubagentStop'; agent_id = 'run0000006'; agent_type = 'team:task-runner'; transcript_path = (Join-Path $tmp 'transcripts/sess6.jsonl') } }
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
    if ($ok -and $c.ContainsKey('NotOut')) { $ok = $r.Out -notlike "*$($c.NotOut)*" }
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
