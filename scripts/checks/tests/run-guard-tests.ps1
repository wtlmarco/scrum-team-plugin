# Testes das guardas da fase 1: entrega a cada despachante o JSON que o harness mandaria e confere a decisão.
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
    @{ Name = 'Falha aberta: JSON inválido'; Script = 'pre-tool.ps1'; Expect = 1; Raw = '{nao-e-json' },
    @{ Name = 'guards.json desliga G3 e liga a sonda'; Script = 'pre-tool.ps1'; Expect = 0
       Setup = { Set-Content -LiteralPath (Join-Path $proj '.team-project/guards.json') '{ "disabled": ["G3"], "probe": true }' -Encoding UTF8 }
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
