# Testes das conferências C1 (close.ps1) e C2 (project.ps1): monta no temp um projeto falso com um sprint
# completo e confere o caminho feliz e as falhas. Uso: powershell -NoProfile -File scripts/checks/tests/run-check-tests.ps1
# (O projeto falso é gerado aqui, e não versionado, para o plugin não carregar pastas .team-project/ — R31.)

$ErrorActionPreference = 'Stop'
$checks = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$e = @{ ok = [char]::ConvertFromUtf32(0x2705); build = [char]::ConvertFromUtf32(0x1F7E8); qa = [char]::ConvertFromUtf32(0x1F7EA)
        plan = [char]::ConvertFromUtf32(0x1F7E6); todo = [char]::ConvertFromUtf32(0x2B1C) }
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Put([string]$Base, [string]$Rel, [string]$Text) {
    $p = Join-Path $Base $Rel
    New-Item -ItemType Directory -Force (Split-Path $p) | Out-Null
    [System.IO.File]::WriteAllText($p, $Text, $utf8)
}

function New-Project([string]$Dir) {
    Put $Dir '.team-project/README.md' @"
# Contexto do Projeto — Teste

## 2. Situação atual

| | |
|---|---|
| **Sprint corrente** | **1** — exportar o resultado · quadro vivo: ``.team-project/sprints/1/sprint-backlog.md`` |

## 2a. Cadência — respondida pelo stakeholder no onboarding (R14)

| | |
|---|---|
| **Duração do sprint** | 1 semana |
| **Unidade de estimativa** | dia ideal |
| **Capacidade de dev** | 1 desenvolvedor |

## 4. Fontes da verdade

| Assunto | Onde |
|---|---|
| Requisitos | docs/sdd/02-requirements.md |

**Diretório de produto:** ``docs/``

## 7. Decisões pendentes do stakeholder

1. nenhuma
"@
    Put $Dir '.team-project/sprints/1/sprint-backlog.md' @"
# Sprint Backlog

## Sprint 1

### Pacote de abertura — o portão ③ deste sprint

| | |
|---|---|
| **Decisão do stakeholder (formulário — R22)** | aprovar |
| **Aprovado por** | Stakeholder |
| **Aprovado em** | 2026-09-01 |
| **Protótipo navegável do sprint** | prototype/sprint-1/index.html · **navegado em** 2026-09-01 · **fluxo ponta a ponta coberto:** exportar análise |
| **O que foi submetido** | Sprint Backlog + critérios + protótipo + planning.md |
| **Ajustes pedidos na aprovação** | nenhum |
| **``stories/`` congelado em** | 2026-09-01 |

---

## História H-014 — Exportar o resultado da análise (alta)

| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários | Critério de pronto |
|---|---|---|---|---|---|---|---|---|
| $($e.qa) T-041 | Endpoint de exportação | 1 | dev | — | [``plan/T-041-export.md``](plan/T-041-export.md) | [``evidence/T-041.md``](evidence/T-041.md) | SC-014 (novo) | teste de integração |
| $($e.todo) T-041a | Variante | 1 | dev | T-041 | [``plan/T-041a-x.md``](plan/) | [``evidence/T-041a.md``](evidence/) | nenhum aplicável — refatoração interna | teste |

---

## Entradas fora da Planning

| Task | História | Por que entrou fora da Planning | O que saiu para caber | Data |
|---|---|---|---|---|

## Bloqueios e riscos abertos

| # | Task / História | Natureza | Degrau | Quem destrava | Desde |
|---|---|---|---|---|---|
| 1 | T-041a | dependência | par PO+Arquiteto desde 2026-09-02 | PO | 2026-09-02 |
"@
    Put $Dir '.team-project/sprints/1/stories/H-014.md' "# H-014`n"
    Put $Dir '.team-project/sprints/1/planning.md' @"
# Planning — Sprint 1

## 5. O que NÃO entrou

- nenhum — tudo o que veio da Review anterior entrou
"@
    Put $Dir '.team-project/sprints/1/plan/T-041-export.md' @"
# Plano de Implementação — T-041 Endpoint de exportação

## 3. Ambiente medido e comandos validados

| Pré-requisito | Comando de medição | Saída real (recortada) | Log bruto | Atende ao plano? |
|---|---|---|---|---|
| .NET 8 | dotnet --version | 8.0.401 | — | sim |

## 4. Passos, em ordem de execução

### Passo 1 — endpoint
- **Standard aplicável:** ```${CLAUDE_PLUGIN_ROOT}/standards/stacks/dotnet/guide.md`` §3 — contrato

## 9. Onde parar e perguntar
- **Pré-requisito ausente** — 🔺 GAP
"@
    Put $Dir '.team-project/sprints/1/evidence/T-041.md' @"
## T-041 — Endpoint de exportação — 2026-09-03

**Veredito:** $($e.ok)

### Cenários de teste — resultado por cenário mapeado (R30)

| SC-nnn | Tipo | Resultado | Forma | Evidência |
|---|---|---|---|---|
| SC-014 | novo | $($e.ok) | script | teste de integração |

### Comandos executados
``````
> dotnet test
Passed! - Failed: 0, Passed: 12
``````
**Relatório do ``operator``:** ``.team-project/operator/1/job1/report.md``

### Documentos vivos (R12)
**Estado:** atualizados
**Documentos:** mapa de código

### Escopo
**Fora do plano:** nada
"@
    Put $Dir '.team-project/operator/1/job1/report.md' "# report`nok`n"
    Put $Dir '.team-project/sprints/1/consumption.md' @"
# Consumo — Sprint 1

## Registro
| Data | Papel | Modelo | Comando | Task/História | Categoria | Unidade | Tokens | Duração | Nota |
|---|---|---|---|---|---|---|---|---|---|
| 2026-09-03 | qa | sonnet | ``/qa`` | T-041 | verificação | H-014 | 1000 | 01:00 | — |
| 2026-09-03 | operator | haiku | ``/qa`` | T-041 | verificação | H-014 | 500 | 00:30 | chamado por qa |
"@
    Put $Dir '.team-project/sprints/1/burndown.md' @"
# Burndown — Sprint 1

## Série

| Dia | Data | Evento | Est. restante | Tasks restantes |
|---|---|---|---|---|
| 0 | 2026-09-01 | pacote aprovado | 2 | 2 |
| 0 | 2026-09-01 10:00 | T-041 $($e.todo) → $($e.plan) | 2 | 2 |
| 1 | 2026-09-02 09:00 | T-041 $($e.plan) → $($e.build) | 2 | 2 |
| 2 | 2026-09-03 15:00 | T-041 $($e.build) → $($e.qa) | 2 | 2 |

## Registro de transições (R24)

| Task | De → Para | Quando | Por quem |
|---|---|---|---|
| T-041 | $($e.todo) → $($e.plan) | 2026-09-01 10:00 | Arquiteto |
| T-041 | $($e.plan) → $($e.build) | 2026-09-02 09:00 | dev |
| T-041 | $($e.build) → $($e.qa) | 2026-09-03 15:00 | QA |
"@
}

# Grava o fechamento de T-041 no burndown.md: linha → ✅ no Registro e ponto na Série.
function Close-T041([string]$Dir) {
    $bd = Join-Path $Dir '.team-project/sprints/1/burndown.md'
    Edit-File $bd "| T-041 | $($e.build) → $($e.qa) | 2026-09-03 15:00 | QA |" ("| T-041 | $($e.build) → $($e.qa) | 2026-09-03 15:00 | QA |`n| T-041 | $($e.qa) → $($e.ok) | 2026-09-04 | SM (``/sm close``) |")
    Edit-File $bd "| 2 | 2026-09-03 15:00 | T-041 $($e.build) → $($e.qa) | 2 | 2 |" ("| 2 | 2026-09-03 15:00 | T-041 $($e.build) → $($e.qa) | 2 | 2 |`n| 3 | 2026-09-04 | T-041 $($e.qa) → $($e.ok) | 1 | 1 |")
}

$script:autoCmds = $true
function Invoke-Check([string]$Script, [string[]]$Arguments) {
    # v3.55.0 (regra 32): os planos dos casos antigos não têm "### Comandos da Task". Sem mudar cada um, o plano que o caso grava
    # ganha a seção "nenhum além da lista base" antes do plan.ps1 — os casos novos da regra 32 desligam isso ($script:autoCmds).
    if ($script:autoCmds -and $Script -eq 'plan.ps1') {
        $pi = [array]::IndexOf($Arguments, '-Plan'); $ri = [array]::IndexOf($Arguments, '-Root')
        if ($pi -ge 0 -and $ri -ge 0) {
            $pf = $Arguments[$pi + 1]; if (-not [System.IO.Path]::IsPathRooted($pf)) { $pf = Join-Path $Arguments[$ri + 1] $pf }
            if (Test-Path -LiteralPath $pf -PathType Leaf) {
                $pt = [System.IO.File]::ReadAllText($pf, $utf8)
                if ($pt -notmatch '(?m)^###\s+Comandos da Task') { [System.IO.File]::WriteAllText($pf, $pt.TrimEnd() + "`n`n### Comandos da Task`n- nenhum além da lista base`n", $utf8) }
            }
        }
    }
    $ErrorActionPreference = 'Continue'   # no 5.1, stderr de processo filho com 2>&1 viraria exceção
    $tl0 = Get-TimeoutMark
    $out = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $checks $Script) @Arguments 2>&1 | Out-String
    $code = $LASTEXITCODE
    # v3.64.1: a sentinela encerrou esta chamada pelo prazo — o caso falha dizendo isso, e a suíte segue.
    $tl1 = Get-TimeoutMark
    if ($tl1.Length -gt $tl0.Length) { $code = 124; $out += "`nTEMPO ESGOTADO (sentinela, $($env:TEAM_TEST_CHECK_TIMEOUT_S) s): $($tl1.Substring($tl0.Length).Trim())" }
    return @{ Code = $code; Out = $out }
}
function Get-TimeoutMark { if ($script:timeoutLog -and (Test-Path -LiteralPath $script:timeoutLog)) { return [System.IO.File]::ReadAllText($script:timeoutLog) }; return '' }

function Edit-File([string]$Path, [string]$From, [string]$To) {
    $t = [System.IO.File]::ReadAllText($Path, $utf8); [System.IO.File]::WriteAllText($Path, $t.Replace($From, $To), $utf8)
}

function Remove-Line([string]$Path, [string]$Line) {
    $t = [System.IO.File]::ReadAllText($Path, $utf8); [System.IO.File]::WriteAllText($Path, ($t -replace ([regex]::Escape($Line) + '\r?\n'), ''), $utf8)
}

$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('team-checks-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
# v3.53.6: o registro da cota (status line) é global, no perfil — os testes apontam para um caminho no temp que não existe;
# quem testa a cota troca a variável no próprio caso. Nenhum teste grava em %USERPROFILE%\.claude.
$env:TEAM_QUOTA_LOG = Join-Path $tmp 'sem-cota/quota-log.jsonl'
# v3.63.2: a trava de aparelho é da máquina (%LOCALAPPDATA%\team-plugin\device-locks) e o serial padrão vem do adb — os testes
# usam uma pasta própria e um serial fixo: nenhum teste toca a trava real nem disputa o emulador de um projeto rodando.
$env:TEAM_DEVICE_LOCK_DIR = Join-Path $tmp 'device-locks'; $env:TEAM_TEST_DEVICE_SERIAL = 'emulator-teste'
# v3.64.0 (item 7): a máquina medida (CPU, emuladores, servidores do adb) também é fixa — nenhum teste depende do que roda de
# verdade na máquina; os casos do item 7 trocam a medida no próprio caso.
$env:TEAM_TEST_ADB_PORTS = '5037'; $env:TEAM_TEST_MACHINE_LOAD = '{"cpu":10,"emulators":[],"adbPorts":[5037],"others":[]}'; $env:TEAM_TEST_HEAVY_POLL_S = '1'
# v3.64.1: prazo por chamada de script de um caso (TEAM_TEST_CHECK_TIMEOUT_S, padrão 240 s) — a sentinela encerra a árvore de
# quem passa dele e o caso falha com TEMPO ESGOTADO; antes, um verify preso segurou a suíte por 29 min.
if (-not $env:TEAM_TEST_CHECK_TIMEOUT_S) { $env:TEAM_TEST_CHECK_TIMEOUT_S = '240' }
New-Item -ItemType Directory -Force $tmp | Out-Null
$script:timeoutLog = Join-Path $tmp 'timeouts.log'
$script:watchdog = Start-Process powershell -WindowStyle Hidden -PassThru -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', (Join-Path $PSScriptRoot 'check-watchdog.ps1'), '-Parent', $PID, '-TimeoutSec', $env:TEAM_TEST_CHECK_TIMEOUT_S, '-Log', $script:timeoutLog)
$rows = @(); $fail = 0
# v3.57.0: o tempo de cada caso (do Check anterior a este) entra na linha, e os mais lentos saem no fim — a suíte passou de ~570 s
# para ~1000 s sem que nenhum caso falhasse, e sem o tempo por caso não havia como achar de onde veio.
$script:lastT = [datetime]::UtcNow
function Check([string]$Name, $Result, [int]$Code, [string[]]$Expect) {
    $nowT = [datetime]::UtcNow; $seg = [int]($nowT - $script:lastT).TotalSeconds; $script:lastT = $nowT
    $ok = $Result.Code -eq $Code
    foreach ($x in $Expect) { if ($Result.Out -notmatch $x) { $ok = $false } }
    if (-not $ok) { $script:fail++; Write-Output "---- $Name (exit $($Result.Code))"; Write-Output $Result.Out }
    $script:rows += [pscustomobject]@{ Caso = $Name; Exit = $Result.Code; Ok = $(if ($ok) { 'ok' } else { 'FALHOU' }); Seg = $seg }
}

# v3.64.1: constantes e ajudantes que vários trechos usam ficam aqui, no preâmbulo — cada bloco da suíte roda sozinho
# (run-all-tests.ps1, em paralelo) e não pode depender de uma definição feita no meio de outro bloco.
$warn = [char]::ConvertFromUtf32(0x26A0); $x = [char]::ConvertFromUtf32(0x274C)
$ck = [char]::ConvertFromUtf32(0x2714)
$bdText = "# Quebra — Sprint 1`n`n## H-014 Exportar`n`n### Decisões comuns — H-014`n- ``export_job`` — tabela dos pedidos · T-041, T-041a`n`n### Ficha T-041a — Variante`n**Código a ler:**`n- ``src/a.ts:3`` — padrão a espelhar (``IExporter``)`n`n**Fontes:** ``docs/sdd/03-architecture.md`` §4 · ``standards/implementation-principles.md`` §2 · ``IExporter```n**Nomes comuns:** ``export_job```n**Arquivos previstos:** 2`n`n## H-020 Outra`n`n### Ficha T-099 — fora`n**Nomes comuns:** ``outro```n"
function New-FixBlock([string]$Dir) {
    Put $Dir 'docs/implementation/pending.md' "# GAPs`n`n## GAP-007 — exportação perde a última linha`n"
    Put $Dir '.team-project/fixes.md' @"
# Correções — trilha fix (R33)

## Correções
| F-ID | Data | Tipo | Relato (1 linha) | C1–C4 (PO) | Reproduzido (QA) | C5–C8 (Arq) | Bloco | Estado | Veredito | Promovida para | Reaberta em |
|---|---|---|---|---|---|---|---|---|---|---|---|
| F-001 | 2026-09-03 | defeito | exportação perde a última linha | ok | GAP-007 | ok | B-001 | em bloco | | | |
| F-002 | 2026-09-03 | ajuste | mensagem de erro do filtro | ok | n/a | ok | B-001 | em bloco | | | |
| F-003 | 2026-09-03 | defeito | ordem das colunas | ok | GAP-008 | C5 caiu | B-001 | promovida | | Product Backlog H-020 | |
| F-004 | 2026-09-03 | defeito | rodapé do relatório | ok | GAP-009 | | B-001 | devolvida | | devolvida — área distante | |
"@
    Put $Dir '.team-project/fixes/F-001.md' @"
# F-001 · exportação perde a última linha
**Tipo:** defeito · **Triada em:** 2026-09-03
**História do aceite:** H-014 + sprint 1 — ver pending.md
## Elegibilidade funcional
- C1 $ck · nenhum requisito novo
- C2 $ck · nenhuma tela nova
- C3 $ck · H-014 não está em voo
- C4 $ck · sem dado sensível
## Reprodução
**Entrada no pending.md:** GAP-007 · **Causa:** src/Export.cs:42
## Destino
**Bloco:** B-001 · **Estado:** em bloco
"@
    Put $Dir '.team-project/fixes/F-002.md' @"
# F-002 · mensagem de erro do filtro
**Tipo:** ajuste · **Triada em:** 2026-09-03
## Elegibilidade funcional
- C1 $ck · altera só RF-12
- C2 $ck · mensagem de campo existente
- C3 $ck · fora de História em voo
- C4 $ck · sem dado sensível
## Destino
**Bloco:** B-001 · **Estado:** em bloco
"@
    Put $Dir '.team-project/fixes/F-003.md' @"
# F-003 · ordem das colunas
**Tipo:** defeito · **Triada em:** 2026-09-03
## Destino
**Bloco:** B-001 · **Estado:** promovida
**Critério que caiu:** C5 — muda o contrato da API de exportação
"@
    $fsec = { param($id, $prod)
@"
## $id · correção
**Tipo:** defeito · **Ficha:** fixes/$id.md
### Elegibilidade técnica
- C5 $ck · sem contrato
- C6 $ck · 1 arquivo
- C7 $ck · sem dependência
- C8 $ck · causa localizada
### Arquivos
- produção: $prod
- teste: tests/${id}Tests.cs
### Revalidação
n/a — sem mudança
"@ }
    Put $Dir '.team-project/fixes/B-001/plan.md' ("# B-001 · mini-planos`n**Data:** 2026-09-03 10:00 · **Correções:** F-001, F-002, F-003`n`n" + (& $fsec 'F-001' '`src/Export Final.cs`') + "`n" + (& $fsec 'F-002' 'src/Filter.cs') + "`n## F-003 · ordem`n**Critério que caiu:** C5 — muda o contrato`n")
    $vsec = { param($id)
@"
## QA — $id correção — 2026-09-04
**Veredito:** $($e.ok)
**Commit:** n/a — sem git
### Teste de regressão
**Antes:** exit 1
> dotnet test --filter $id
Failed: 1
**Depois:** exit 0
> dotnet test --filter $id
Passed: 1
### Escopo
**Fora do plano:** nada
### Documentos vivos (R12)
**Estado:** atualizados
"@ }
    Put $Dir '.team-project/fixes/B-001/verdict.md' ("# B-001 · veredito`n**Trilha:** fix · **Executado em:** 2026-09-04 10:00`n`n" + (& $vsec 'F-001') + "`n" + (& $vsec 'F-002'))
}
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
$e0 = $e
$gh63 = Join-Path $tmp 'gate-h.ps1'
[System.IO.File]::WriteAllText($gh63, @'
param([string]$Checks, [string]$Root)
$ErrorActionPreference = 'Stop'
. (Join-Path $Checks 'lib.ps1')
. (Join-Path $Checks 'gate.ps1')
$utf8 = New-Object System.Text.UTF8Encoding($false)
$n = '1'; $S = Join-Path $Root '.team-project/sprints/1'; $plugin = '${CLAUDE_PLUGIN_ROOT}/scripts/checks'; $todoMk = [char]::ConvertFromUtf32(0x2B1C)
$tasks = @(); if (Test-Path -LiteralPath (Join-Path $S 'sprint-backlog.md')) { $tasks = @(Get-SprintTasks $S) }
function Out([string]$s) { [Console]::Out.WriteLine($s) }
function Say([string]$s) { [Console]::Out.WriteLine("PARA O STAKEHOLDER: $s") }
function Get-AgentLine([string]$Role) { return "Agent: team:$Role" }
function Get-VerdictOf([string]$Path) { if (-not (Test-Path -LiteralPath $Path)) { return $null }; $ms = @([regex]::Matches((Read-Text $Path), '(?m)^\*\*Veredito[^*\r\n]*:\*\*(.*)$')); if (-not $ms.Count) { return '' }; $mk = Get-VerdictMark $ms[$ms.Count - 1].Groups[1].Value; if ($mk) { return $mk } else { return '' } }
function Test-PoDebt([string]$Path) { return $false }
function Add-RunLog { param($S, $n, $Item, $Decision, $Why, $Evidence) [Console]::Out.WriteLine("RUNLOG: $Item | $Decision") }
function Get-WatcherLine { return 'WATCHER-LINE' }
Invoke-GateStep
'GATE-RETURNED'
'@, (New-Object System.Text.UTF8Encoding($true)))
$g63 = { param($pp) $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $gh63 -Checks $checks -Root $pp 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
$lib63 = { param($expr) $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -Command ". '$(Join-Path $checks 'lib.ps1')'; $expr" 2>&1 | Out-String; $o.Trim() }

# ==== início dos casos ==== (run-all-tests.ps1 divide daqui até o fim em blocos independentes; o que vem antes é o preâmbulo de cada bloco)
# 1. Caminho feliz: nada falha.
$p = Join-Path $tmp 'feliz'; New-Project $p
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 feliz: exit 0, nenhuma regra falhou' $r 0 @('\| R7 \| ok', '\| R7-verify \| n-a', '\| R12 \| ok', '\| R1 \| ok', '\| R4 \| ok', '\| R8 \| ok', '\| R16 \| ok', '\| R20 \| ok', '\| R24 \| n-a', '\| R25 \| ok', '\| R26 \| ok', '\| R28 \| ok', '\| R30 \| ok')
if ($r.Out -match '\| falhou \|') { $fail++; Write-Output '---- feliz com falhou:'; Write-Output $r.Out }

# 2. -Post sem a linha → ✅ falha R24; com a linha, ok.
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Post', '-Root', $p)
Check 'C1 -Post sem → ✅: R24 falhou' $r 0 @('\| R24 \| falhou')
Close-T041 $p
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Post', '-Root', $p)
Check 'C1 -Post com → ✅ e burndown: R24 ok' $r 0 @('\| R24 \| ok.*4 transi')

# 2b. Sprint aberto antes da v3.44.1: Registro ainda no sprint-backlog.md → lido de lá.
$p = Join-Path $tmp 'r24legado'; New-Project $p; Close-T041 $p
$bdp = Join-Path $p '.team-project/sprints/1/burndown.md'; $sbp = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'
$bdt = [System.IO.File]::ReadAllText($bdp, $utf8); $ix = $bdt.IndexOf('## Registro de transi')
[System.IO.File]::WriteAllText($bdp, $bdt.Substring(0, $ix), $utf8)
Edit-File $sbp '## Entradas fora da Planning' ($bdt.Substring($ix) + "`n## Entradas fora da Planning")
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Post', '-Root', $p)
Check 'C1 -Post com Registro no sprint-backlog (legado): R24 ok' $r 0 @('\| R24 \| ok', '\| R20 \| ok.*2026-09-01 ≤ 1ª entrada em construção 2026-09-02')

# 2c. Série sem a linha de uma transição (burndown parado) → R24 falhou.
$p = Join-Path $tmp 'r24serie'; New-Project $p; Close-T041 $p
Remove-Line (Join-Path $p '.team-project/sprints/1/burndown.md') "| 1 | 2026-09-02 09:00 | T-041 $($e.plan) → $($e.build) | 2 | 2 |"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Post', '-Root', $p)
Check 'C1 -Post com a Série parada: R24 falhou' $r 0 @('\| R24 \| falhou.*Série com 3 linha.*4 transi')

# 2d. Registro sem → 🟨 (marcador não acompanhado) → R24 falhou.
$p = Join-Path $tmp 'r24marcador'; New-Project $p; Close-T041 $p
Remove-Line (Join-Path $p '.team-project/sprints/1/burndown.md') "| T-041 | $($e.plan) → $($e.build) | 2026-09-02 09:00 | dev |"
Remove-Line (Join-Path $p '.team-project/sprints/1/burndown.md') "| 1 | 2026-09-02 09:00 | T-041 $($e.plan) → $($e.build) | 2 | 2 |"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Post', '-Root', $p)
Check 'C1 -Post sem → 🟨 no Registro: R24 falhou' $r 0 @('\| R24 \| falhou.*marcador não acompanhado')

# 3. R12 pendentes → exit 1 (bloqueia).
$p = Join-Path $tmp 'r12'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') '**Estado:** atualizados' '**Estado:** pendentes'
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R12 pendentes: exit 1' $r 1 @('\| R12 \| falhou', 'Não fecha')

# 4. Veredito ⚠ → R7 falha, exit 1.
$p = Join-Path $tmp 'r7'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') ("**Veredito:** " + $e.ok) ("**Veredito:** " + [char]::ConvertFromUtf32(0x26A0))
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 veredito ⚠: R7 falhou, exit 1' $r 1 @('\| R7 \| falhou')

# 4b. Veredito ✅ com o histórico das rodadas na mesma linha → R7 ok (o primeiro marcador decide); ⚠ antes do ✅ → falha.
$p = Join-Path $tmp 'r7hist'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') ("**Veredito:** " + $e.ok) ("**Veredito:** " + $e.ok + " Aprovado na 3ª rodada (antes $warn e $x)")
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 ✅ com histórico na linha: R7 ok, exit 0' $r 0 @('\| R7 \| ok')
Edit-File (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') ("**Veredito:** " + $e.ok + " Aprovado") ("**Veredito:** " + $warn + " ressalva; ia para " + $e.ok)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 ⚠ antes do ✅: R7 falhou, exit 1' $r 1 @('\| R7 \| falhou', 'primeiro marcador')

# 4c. Fora do plano com desvio aceito e data → R4 ok; sem data → falha. Pasta operator/sprint-1 → R28 aponta o nome.
$p = Join-Path $tmp 'r4aceito'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') '**Fora do plano:** nada' "**Fora do plano:** ci.yml:6-7 (2 linhas de comentário)`n**Desvio aceito:** 2026-09-04 — stakeholder (formulário) — sprint-backlog.md bloqueio 14"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 desvio aceito com data: R4 ok' $r 0 @('\| R4 \| ok', 'desvio aceito em 2026-09-04')
Edit-File (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') '**Desvio aceito:** 2026-09-04 — stakeholder' '**Desvio aceito:** pendente — stakeholder'
Put $p '.team-project/operator/sprint-1/arc-job/report.md' "# report`n"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 desvio sem data: R4 falhou; operator/sprint-1: R28 aponta' $r 0 @('\| R4 \| falhou', 'sem \*\*Desvio aceito:\*\* com data', 'pasta fora do padrão: operator/sprint-1/')

# 5. Fora do plano com arquivo, cenário sem resultado, operator sem linha de consumo, construção antes do pacote.
$p = Join-Path $tmp 'varios'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') '**Fora do plano:** nada' '**Fora do plano:** src/Extra.cs'
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') 'SC-014 (novo)' 'SC-014 (novo), SC-020 (regressivo)'
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') '| **Aprovado em** | 2026-09-01 |' '| **Aprovado em** | 2026-09-05 |'
Put $p '.team-project/operator/1/T-041-cobertura/report.md' "# report 2`n"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 falhas não bloqueantes: exit 0' $r 0 @('\| R4 \| falhou.*src/Extra.cs', '\| R30 \| falhou.*SC-020', '\| R28 \| falhou.*2 report.*1 linha', '\| R20 \| falhou')

# 5b. R28 por Task (v3.45): job de outra Task sem linha no consumo não reprova T-041; job sem Task no nome e não citado não conta.
$p = Join-Path $tmp 'r28task'; New-Project $p
Put $p '.team-project/operator/1/T-099/report.md' "# report de outra Task`n"
Put $p '.team-project/operator/1/avulso/report.md' "# job sem Task no nome`n"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R28 por Task: outra Task divergente não reprova' $r 0 @('\| R28 \| ok.*T-041: 1 report')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041a', '-Root', $p)
Check 'C1 R28 Task sem operator: ok (sem evidência, R7 barra: exit 1)' $r 1 @('\| R28 \| ok.*T-041a sem job do operator')

# 5c. consumption.ps1 (v3.45): linhas medidas do usage.jsonl entram no Registro, a manual fica, os Totais se refazem; rodar de novo não duplica.
$p = Join-Path $tmp 'consumo'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/consumption.md') '| 2026-09-03 | operator | haiku' "| 2026-09-03 | sessão | vários | ``/usage`` | n/a | cerimônia | sprint-1 | x | 1h | linha de sessão |`n| 2026-09-03 | operator | haiku"
Put $p '.team-project/sprints/1/consumption.md' ((Get-Content -Raw -Encoding UTF8 (Join-Path $p '.team-project/sprints/1/consumption.md')) + "`n## Totais do sprint (derivado)`n`n| Papel | Modelo | Σ tokens | Nº de invocações | Duração total |`n|---|---|---|---|---|`n| x | y | 0 | 0 | 00:00 |`n")
$dst = '.team-project/sprints/1/consumption.md'
Put $p '.team-project/usage.jsonl' (@(
    ('{"agent_id":"d1","role":"developer","description":"dev T-041","round":1,"work":"T-041","model":"claude-haiku-4-5","start":"2026-09-03T10:00:00","duration_s":125,"calls":10,"processed":300000,"final_context":50000,"cache_read":250000,"output":4000,"first_context":15000,"peak_context":50000,"children":["o1"],"dest":"' + $dst + '","dest_note":""}'),
    ('{"agent_id":"o1","role":"operator","description":"suite","round":1,"work":"T-041","model":"claude-haiku-4-5","start":"2026-09-03T10:01:00","duration_s":60,"calls":3,"processed":40000,"final_context":12000,"cache_read":30000,"output":500,"first_context":9000,"peak_context":12000,"children":[],"dest":"' + $dst + '","dest_note":""}'),
    ('{"agent_id":"d1","role":"developer","description":"dev T-041","round":2,"work":"T-041","model":"claude-haiku-4-5","start":"2026-09-03T12:00:00","duration_s":60,"calls":5,"processed":100000,"final_context":60000,"cache_read":90000,"output":1000,"first_context":50000,"peak_context":60000,"children":[],"dest":"' + $dst + '","dest_note":""}')
) -join "`n")
$r = Invoke-Check 'consumption.ps1' @('-Root', $p)
$r = Invoke-Check 'consumption.ps1' @('-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 (Join-Path $p $dst))
Check 'Consumo: medidas entram, manual e sessão ficam, sem duplicar' $r 0 @('3 linha\(s\) medida\(s\), 3 mantida', 'operator \| haiku 4\.5 \| `Agent` · suite \| T-041 \| verificação \| H-014 \| 40.000', 'chamado por dev; medido: o1#1', '\| dev \| haiku 4\.5 .*\| retrabalho \| H-014 \| 100.000', '\| operator ← dev \| haiku 4\.5 \| 40.000 \| 1 \| 1 ', '\| operator ← qa \| haiku \| não medido — só notificação \| 1 \| 1 \| 00:30 \| 500 \|', 'linha de sessão')
if (([regex]::Matches($r.Out, 'medido: d1#1')).Count -ne 1) { $fail++; Write-Output '---- consumo duplicou a linha medida' }
# v3.49: Totais separam instâncias (agentes distintos) de rodadas — o dev d1 tem 2 rodadas e 1 instância — e o modelo vem com a versão.
Check 'Consumo: Totais com instâncias × rodadas e modelo com versão (v3.49)' $r 0 @('\| Papel \| Modelo \| Σ tokens processados \| Instâncias \| Rodadas \|', '\| dev \| haiku 4\.5 \| 400.000 \| 1 \| 2 \|')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 depois do consumo medido: R28 conta a linha do operator da Task' $r 0 @('\| R28 \| falhou.*1 report.*2 linha')
Put $p '.team-project/sprints/1/retrospective.md' "# Retro`n"
$r = Invoke-Check 'consumption.ps1' @('-Root', $p)
Check 'Consumo: sprint fechado não recebe linha' $r 0 @('está fechado')

# 5c'. consumption.ps1 (v3.49): operator sem o filho na linha do pai — o chamador sai pelo horário, na mesma Task.
$p = Join-Path $tmp 'consumo-horario'; New-Project $p
$dst = '.team-project/sprints/1/consumption.md'
Put $p $dst ((Get-Content -Raw -Encoding UTF8 (Join-Path $p $dst)) + "`n## Totais do sprint (derivado)`n`n| a | b |`n|---|---|`n| x | y |`n")
Put $p '.team-project/usage.jsonl' (@(
    ('{"agent_id":"q1","role":"quality-assurance","description":"qa T-041","round":1,"work":"T-041","model":"claude-sonnet-5-5","start":"2026-09-03T10:00:00","duration_s":600,"calls":10,"processed":200000,"final_context":50000,"cache_read":150000,"output":4000,"first_context":15000,"peak_context":50000,"children":[],"dest":"' + $dst + '","dest_note":""}'),
    ('{"agent_id":"o9","role":"operator","description":"cenarios","round":1,"work":"T-041","model":"claude-haiku-5-5","start":"2026-09-03T10:04:00","duration_s":60,"calls":3,"processed":40000,"final_context":12000,"cache_read":30000,"output":500,"first_context":9000,"peak_context":12000,"children":[],"dest":"' + $dst + '","dest_note":""}')
) -join "`n")
$r = Invoke-Check 'consumption.ps1' @('-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 (Join-Path $p $dst))
Check 'Consumo: operator sem filho no pai ganha o chamador pelo horário (v3.49)' $r 0 @('chamado por qa \(pelo horário\); medido: o9#1', '\| operator ← qa \| haiku 5\.5 \| 40.000 \| 1 \| 1 ')

# 5c''. consumption.ps1 -Session (v3.49): a sessão principal medida pelo transcript que a G16 grava em cada linha;
# uuid repetido (linha regravada antes de compactação) não conta; sem -Session a linha medida fica.
$p = Join-Path $tmp 'consumo-sessao'; New-Project $p
Put $p $dst ((Get-Content -Raw -Encoding UTF8 (Join-Path $p $dst)) + "`n## Totais do sprint (derivado)`n`n| a | b |`n|---|---|`n| x | y |`n")
$sess = Join-Path $p 'sess-abcdef12.jsonl'
Put $p 'sess-abcdef12.jsonl' (@(
    '{"type":"assistant","uuid":"u1","timestamp":"2026-09-03T09:00:00Z","message":{"id":"x0","model":"claude-sonnet-5-5","usage":{"input_tokens":1,"cache_creation_input_tokens":1,"cache_read_input_tokens":1,"output_tokens":1}}}',
    '{"type":"assistant","uuid":"u2","timestamp":"2026-09-03T13:05:00Z","message":{"id":"s1","model":"claude-sonnet-5-5","usage":{"input_tokens":10,"cache_creation_input_tokens":1000,"cache_read_input_tokens":4000,"output_tokens":90}}}',
    '{"type":"assistant","uuid":"u3","timestamp":"2026-09-03T13:20:00Z","message":{"id":"s2","model":"claude-sonnet-5-5","usage":{"input_tokens":10,"cache_creation_input_tokens":100,"cache_read_input_tokens":5000,"output_tokens":90}}}',
    '{"type":"assistant","uuid":"u3","timestamp":"2026-09-03T13:20:00Z","message":{"id":"s2","model":"claude-sonnet-5-5","usage":{"input_tokens":10,"cache_creation_input_tokens":100,"cache_read_input_tokens":5000,"output_tokens":90}}}'
) -join "`n")
$sj = ($sess -replace '\\', '\\')
Put $p '.team-project/usage.jsonl' ('{"agent_id":"q1","role":"quality-assurance","description":"qa T-041","round":1,"work":"T-041","model":"claude-sonnet-5-5","start":"' + ([datetime]'2026-09-03T13:00:00Z').ToString('yyyy-MM-ddTHH:mm:ss') + '","duration_s":600,"calls":10,"processed":200000,"final_context":50000,"cache_read":150000,"output":4000,"first_context":15000,"peak_context":50000,"children":[],"dest":"' + $dst + '","dest_note":"","session_transcript":"' + $sj + '"}')
$r = Invoke-Check 'consumption.ps1' @('-Root', $p, '-Session')
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 (Join-Path $p $dst))
Check 'Consumo -Session: a sessão principal vira linha medida e entra nos Totais (v3.49)' $r 0 @('\| sessão \| sonnet 5\.5 \| `sessão principal` \| n/a \| cerimônia \| sprint-1 \| 10.300 \|', 'medido: sessão sess-abc; 2 chamada\(s\)', '\| sessão principal \| sonnet 5\.5 \| 10.300 \| 1 \| 1 \|')
$r = Invoke-Check 'consumption.ps1' @('-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 (Join-Path $p $dst))
Check 'Consumo sem -Session mantém a linha da sessão já medida' $r 0 @('medido: sessão sess-abc', '\| sessão principal \| sonnet 5\.5 \| 10.300 \|')
if (([regex]::Matches($r.Out, 'medido: sessão sess-abc')).Count -ne 1) { $fail++; Write-Output '---- consumo duplicou a linha da sessão' }

# 5c''''. bench-answer.ps1 (v3.50.1): sem AskUserQuestion (claude -p) a sessão consulta o dossiê pela mesma lógica da G18.
$p = Join-Path $tmp 'bench-answer'; New-Project $p
$r = Invoke-Check 'bench-answer.ps1' @('-Question', 'Aprova o pacote?', '-Options', 'Aprovar|Pedir mais contexto', '-Root', $p)
Check 'bench-answer.ps1: sem bench a pergunta é do stakeholder' $r 2 @('modo benchmark desligado')
Set-Content -LiteralPath (Join-Path $p 'bench-answers.json') '{ "respostas": [ { "tema": "Portões", "match": "(?i)pacote", "pick": "(?i)^aprovar" } ] }' -Encoding UTF8
Set-Content -LiteralPath (Join-Path $p '.team-project/guards.json') '{ "bench": { "arm": "P0-r1", "answers": "bench-answers.json" } }' -Encoding UTF8
$r = Invoke-Check 'bench-answer.ps1' @('-Question', 'Aprova o pacote?', '-Options', 'Reprovar|Aprovar|Pedir mais contexto', '-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 (Join-Path $p '.team-project/benchmark/P0-r1/questions.log'))
Check 'bench-answer.ps1: o dossiê responde e a pergunta vai ao questions.log' $r 0 @('\[bench\] resposta do stakeholder: Aprovar', '\| dossie \| Aprova o pacote\? \| Aprovar')
$r = Invoke-Check 'bench-answer.ps1' @('-Question', 'Qual lib?', '-Options', 'A|B (Recomendado)|Pedir mais contexto', '-Root', $p)
Check 'bench-answer.ps1: fora do dossiê vale a recomendada' $r 0 @('stakeholder: B \(Recomendado\)')

# 5c'''. mark.ps1 (v3.49): a transição numa chamada — quadro, Série (estimativa inalterada) e Registro; o ✅ é do close.
$p = Join-Path $tmp 'marcador'; New-Project $p
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041a', '-To', 'plan', '-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 (Join-Path $p '.team-project/sprints/1/sprint-backlog.md')) + (Get-Content -Raw -Encoding UTF8 (Join-Path $p '.team-project/sprints/1/burndown.md'))
Check 'mark.ps1: quadro, Série e Registro numa chamada' $r 0 @("mark: T-041a $($e.todo) → $($e.plan)", "\| $($e.plan) T-041a \| Variante", "\| T-041a $($e.todo) → $($e.plan) · dev \| 2 \| 2 \|", "\| T-041a \| $($e.todo) → $($e.plan) \| [\d-]+ [\d:]+ \| dev · sessão \(``mark\.ps1``\) \|")
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041a', '-To', 'plan', '-Root', $p)
Check 'mark.ps1: Task já no marcador pedido não grava' $r 2 @('já está')
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'done', '-Root', $p)
Check 'mark.ps1: o ✅ é do close.ps1 -Apply' $r 2 @('close\.ps1 -Apply')
$bd = Join-Path $p '.team-project/sprints/1/burndown.md'
Edit-File $bd '| Dia | Data | Evento | Est. restante | Tasks restantes |' "| Dia | Data | Evento | Est. restante | Tasks restantes | $($e.todo) | $($e.plan) | $($e.build) | $($e.qa) | $($e.ok) | $([char]::ConvertFromUtf32(0x1F534)) |"
Edit-File $bd '|---|---|---|---|---|' '|---|---|---|---|---|---|---|---|---|---|---|'
Edit-File $bd "| T-041a $($e.todo) → $($e.plan) · dev | 2 | 2 |" "| T-041a $($e.todo) → $($e.plan) · dev | 2 | 2 | 0 | 1 | 0 | 1 | 0 | 0 |"
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041a', '-To', 'build', '-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 $bd)
Check 'mark.ps1: a composição recontada na Série' $r 0 @("\| T-041a $($e.plan) → $($e.build) · dev \| 2 \| 2 \| 0 \| 0 \| 1 \| 1 \| 0 \| 0 \|")
# v3.52.1 (garden item 15): a Série e o Registro apontam a última rodada medida da Task (usage.jsonl).
Put $p '.team-project/usage.jsonl' ('{"ts":"2026-09-02T10:05:00","agent_id":"arcabc123456","role":"architect","model":"claude-opus-5-5","work":"T-041a","works":["T-041a"]}' + "`n" + '{"ts":"2026-09-02T10:40:00","agent_id":"dev9876543210","role":"developer","model":"claude-haiku-5-5","work":"T-041a","works":["T-041a"]}' + "`n" + '{"ts":"2026-09-02T10:50:00","agent_id":"outra0000000","role":"developer","model":"claude-haiku-5-5","work":"T-099","works":["T-099"]}' + "`n")
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041a', '-To', 'qa', '-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 $bd)
Check 'mark.ps1: a transição aponta a última rodada da Task (papel · agente · hora), não a de outra Task (garden 15)' $r 0 @("T-041a $($e.build) → $($e.qa) · QA ← developer dev98765 10:40", "após a rodada developer dev98765 10:40")

# 5c''''. dispatch.ps1 (v3.49): .active-task em JSON, marcador, modelo do models.json, primeiro plano no benchmark, -Clear.
$p = Join-Path $tmp 'disparo'; New-Project $p
Put $p '.team-project/sprints/1/plan/T-041a-x.md' '# Plano'
$r = Invoke-Check 'dispatch.ps1' @('-Role', 'dev', '-Id', 'T-041a', '-Plan', '.team-project/sprints/1/plan/T-041a-x.md', '-Mark', 'build', '-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 (Join-Path $p '.team-project/.active-task'))
Check 'dispatch.ps1: .active-task em JSON, marcador e parâmetros do Agent' $r 0 @('\{"trilha":"sprint","id":"T-041a","plano":".team-project/sprints/1/plan/T-041a-x.md"\}', "mark: T-041a $($e.todo) → $($e.build)", 'subagent_type "team:developer" · model omitido — vale o do agente \(haiku\)', 'dispare e encerre o turno; o aviso traz a volta')
Put $p '.team-project/models.json' '{ "developer": "sonnet" }'
Put $p '.team-project/guards.json' '{ "bench": { "arm": "t", "answers": "x.json", "foreground": true } }'
$r = Invoke-Check 'dispatch.ps1' @('-Role', 'qa', '-Id', 'T-041a', '-Root', $p)
Check 'dispatch.ps1: papel sem escopo de escrita, sem run_in_background (v3.52.2, C1)' $r 0 @('subagent_type "team:quality-assurance"', 'dispare e encerre o turno; o aviso traz a volta')
if (Test-Path -LiteralPath (Join-Path $p '.team-project/.active-task')) { } else { $fail++; Write-Output '---- dispatch do QA apagou o .active-task do dev' }
$r = Invoke-Check 'dispatch.ps1' @('-Role', 'developer', '-Id', 'T-041a', '-Plan', '.team-project/sprints/1/plan/T-041a-x.md', '-Root', $p)
Check 'dispatch.ps1: model do models.json' $r 0 @('model "sonnet" \(models\.json\)')
Put $p '.team-project/models.json' '{ "executor": "architect" }'
$r = Invoke-Check 'dispatch.ps1' @('-Role', 'developer', '-Id', 'T-041a', '-Plan', '.team-project/sprints/1/plan/T-041a-x.md', '-Root', $p)
Check 'dispatch.ps1: perfil executor dispara o Arquiteto e grava .active-executor' $r 0 @('perfil executor', 'subagent_type "team:architect"', '\.active-executor: \{"trilha":"sprint","id":"T-041a"')
$r = Invoke-Check 'dispatch.ps1' @('-Clear', '-Root', $p)
Check 'dispatch.ps1 -Clear apaga os dois marcadores' $r 0 @('apagado\(s\) \.active-task, \.active-executor')
$r = Invoke-Check 'dispatch.ps1' @('-Role', 'dev', '-Id', 'T-041a', '-Root', $p)
Check 'dispatch.ps1: dev sem plano não grava nada' $r 2 @('precisa de -Id e -Plan')

# 5d. verify.ps1 (v3.45.1): evidência mecânica amarrada à árvore; o C1 a lê quando guards.json tem "verify".
$p = Join-Path $tmp 'verify'; New-Project $p
$ErrorActionPreference = 'Continue'   # aviso de CRLF do git no stderr viraria exceção no 5.1
& git -C $p init -q 2>$null; Put $p 'src/a.ts' "x`n"; Put $p '.gitignore' "coverage/`n.team-project/`n"
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $p '.team-project/guards.json' '{ "verify": { "focused": "Write-Output \"Tests: 2 passed {tests}\"", "build": "Write-Output \"Build succeeded. 0 Warning(s)\"", "suite": "Write-Output \"Tests: 12 passed\"; New-Item -ItemType Directory -Force coverage | Out-Null; Set-Content coverage/l.info x" } }'
Put $p 'src/novo.ts' "y`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'focused', '-Root', $p)
Check 'verify focused sem -Tests: exit 2' $r 2 @()
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'verify full verde: exit 0, log e result.json em verify/1/T-041' $r 0 @('verify full T-041', 'tudo exit 0', 'verify/1/T-041/result.json', 'suite: exit 0 .*Tests: 12 passed')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R7-verify ok com a árvore igual' $r 0 @('\| R7-verify \| ok.*árvore igual')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'check', '-Root', $p)
Check 'verify check com a árvore igual: exit 0' $r 0 @('IGUAL')
Put $p 'src/outro.ts' "z`n"   # arquivo novo não rastreado depois do verify (o furo da T-019 do piloto)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'check', '-Root', $p)
Check 'verify check com arquivo novo não rastreado: árvore diferente, exit 1' $r 1 @('DIFERENTE')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R7-verify falhou com a árvore mudada: exit 1' $r 1 @('\| R7-verify \| falhou.*a árvore mudou', 'Não fecha')
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output ok", "suite": "cmd /c exit 4" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'verify full com suíte reprovada: exit 1 e o código real' $r 1 @('suite: exit 4')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R7-verify falhou com verify vermelho' $r 1 @('\| R7-verify \| falhou.*suite exit 4')
# v3.57.0 (item 8): suspensão do sistema no meio do comando — o relógio andou horas contra o prazo; a rodada é repetida uma vez.
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output \"Build succeeded. 0 Warning(s)\"", "suite": "Write-Output \"Tests: 12 passed\"; New-Item -ItemType Directory -Force coverage | Out-Null; Set-Content coverage/l.info x" } }'
$env:TEAM_TEST_CLOCK_SKEW_MIN_ONCE = '540'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Remove-Item Env:\TEAM_TEST_CLOCK_SKEW_MIN_ONCE -ErrorAction SilentlyContinue
Check 'v3.57.0 item 8: suspensão do sistema na 1ª rodada → o verify repete, passa (exit 0) e registra a suspensão, sem reprovar a suíte' $r 0 @('tudo exit 0', 'atenção: build: suspensão do sistema detectada: o relógio andou 5\d\d min contra o prazo de 9 min .* rodada repetida e válida')
# v3.63.1 (pedido 8 do sprint 6 do projeto piloto, Q-S6d): o navegador da suíte cai no meio — a suíte falsa imprime as linhas do
# Karma; KMODE: once = cai só na 1ª rodada · diff = cai nas 2, em pontos diferentes · same = cai nas 2 no mesmo teste.
# Num projeto próprio: o $p segue com o full verde que os casos abaixo reaproveitam.
$pOrig = $p; $p = Join-Path $tmp 'karma-queda'; New-Project $p
$ErrorActionPreference = 'Continue'; & git -C $p init -q 2>$null; Put $p 'src/a.ts' "x`n"; Put $p '.gitignore' "coverage/`n.team-project/`n"; & git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null; $ErrorActionPreference = 'Stop'
Put $p '.team-project/karma-fake.ps1' @'
$c = '.team-project/kn.txt'; $n = 1 + [int](Get-Content $c -ErrorAction SilentlyContinue); Set-Content $c $n
if ($env:KMODE -eq 'once' -and $n -gt 1) { 'Chrome Headless 120.0 (Windows 10): Executed 2926 of 2926 SUCCESS (61 secs / 58 secs)'; 'Tests: 2926 passed'; New-Item -ItemType Directory -Force coverage | Out-Null; Set-Content coverage/l.info x; exit 0 }
$at = if ($env:KMODE -eq 'same') { 1840 } else { 1830 + $n }
"Chrome Headless 120.0 (Windows 10): Executed $at of 2926 SUCCESS (40 secs / 38 secs)"
"18 11 2026 08:00:00.000:WARN [Chrome Headless 120.0 (Windows 10)]: Disconnected (0 times) because no message in 120000 ms."
'Chrome Headless 120.0 (Windows 10) ERROR'
exit 1
'@
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output \"Build succeeded. 0 Warning(s)\"", "minFreeMB": 0, "suite": "powershell -NoProfile -ExecutionPolicy Bypass -File .team-project/karma-fake.ps1" } }'
$kr = { param($mode) Remove-Item -LiteralPath (Join-Path $p '.team-project/kn.txt') -Force -ErrorAction SilentlyContinue; $env:KMODE = $mode; $x = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Fresh', '-Root', $p); Remove-Item Env:\KMODE -ErrorAction SilentlyContinue; $x }
$r = & $kr 'once'
Check 'v3.63.1 pedido 8: o navegador da suíte cai na 1ª rodada (Karma: no message in 120000 ms) → o verify repete uma vez, passa e registra a queda' $r 0 @('verify: suite — o navegador da suíte caiu no meio \(.*Disconnected \(0 times\) because no message in 120000 ms.*\) depois do teste 1831 de 2926 .* repetindo a rodada uma vez', 'tudo exit 0', 'atenção: suite: o navegador da suíte caiu no meio .* rodada repetida e válida')
$r = & $kr 'diff'
Check 'v3.63.1 pedido 8: caiu nas 2 rodadas em pontos diferentes → FALHA DE AMBIENTE (exit 4) com a memória medida e o que é configuração do projeto' $r 4 @('FALHA DE AMBIENTE em 1 comando', 'ambiente \(suite\): o navegador da suíte caiu nas 2 rodadas .* em pontos diferentes \(depois do teste 1831 e do 1832 de 2926\)', 'memória livre -?\d+ MB', 'browserNoActivityTimeout', 'não é defeito do código')
$r = & $kr 'same'
Check 'v3.63.1 pedido 8: caiu nas 2 rodadas no MESMO teste → não é ambiente: um teste trava o navegador (exit 1, sem FALHA DE AMBIENTE)' $r 1 @('1 comando\(s\) com falha', 'suite: exit 1 .* caiu duas vezes no MESMO ponto \(depois do teste 1840 de 2926\)', '^(?![\s\S]*FALHA DE AMBIENTE)')
# ----- v3.64.0 · item 7: a máquina dividida entre projetos -----
$mlKeep = $env:TEAM_TEST_MACHINE_LOAD
$env:TEAM_TEST_MACHINE_LOAD = '{"cpu":91,"emulators":["horta-api35","bench-a01-api29"],"adbPorts":[5037,5557],"others":["setup-android de C:\\outro"]}'
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output \"Build succeeded. 0 Warning(s)\"", "minFreeMB": 0, "suite": "powershell -NoProfile -ExecutionPolicy Bypass -File .team-project/karma-fake.ps1" }, "targets": { "android": { "package": "br.x" } } }'
$r = & $kr 'diff'
Check 'v3.64.0 item 7 A: queda em pontos diferentes com a máquina ocupada (CPU, emulador e adb de outro projeto) → "máquina ocupada", sem mandar abrir Task de configuração' $r 4 @('FALHA DE AMBIENTE em 1 comando', 'máquina ocupada quando o navegador da suíte caiu', 'CPU 91%', 'emulador\(es\) ligado\(s\): horta-api35, bench-a01-api29', '2 servidores do adb \(portas 5037, 5557\)', 'outro projeto com trava viva: setup-android de C:\\outro', 'não abra Task', '^(?![\s\S]*vão por Task)')
$env:TEAM_TEST_MACHINE_LOAD = $mlKeep
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output \"Build succeeded. 0 Warning(s)\"", "minFreeMB": 0, "suite": { "command": "powershell -NoProfile -ExecutionPolicy Bypass -File .team-project/karma-fake.ps1", "inputs": ["src/**"] } } }'
Remove-Item -LiteralPath (Join-Path $p '.team-project/kn.txt') -Force -ErrorAction SilentlyContinue; $env:KMODE = 'once'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.64.0 item 7 C: suíte declarada como objeto { command, inputs } roda e fica como último verde (lastGreen)' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/verify/1/T-041/result.json'), $utf8) } 0 @('tudo exit 0', '"lastGreen":\s*\{[\s\S]*"suite":')
Put $p 'tools/x.mjs' "y`n"
$kn0 = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/kn.txt')).Trim()
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$kn1 = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/kn.txt')).Trim()
Check 'v3.64.0 item 7 C: mudou só arquivo fora dos inputs da suíte → a suíte é reaproveitada do último verde (não roda), com a lista do que mudou fora' @{ Code = $r.Code; Out = $r.Out + "`nKN=$kn0/$kn1`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/verify/1/T-041/result.json'), $utf8) } 0 @('suite: reaproveitado do verde de .* nada do que ele lê \(inputs\) mudou; mudaram fora: tools/x\.mjs', "KN=$kn0/$kn0", '"reusedBy":\s*"inputs"')
Put $p 'src/a.ts' "y`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$kn2 = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/kn.txt')).Trim()
Check 'v3.64.0 item 7 C: mudou arquivo dos inputs → a suíte roda de novo' @{ Code = $r.Code; Out = $r.Out + "`nKN=$kn0/$kn2" } 0 @('^(?![\s\S]*suite: reaproveitado do verde)', "KN=$kn0/(?!$kn0\b)\d+")
Remove-Item Env:\KMODE -ErrorAction SilentlyContinue
# Trava pesada (B): outro projeto vivo segura a máquina → a suíte espera o prazo (0 aqui) e sai como ambiente, sem rodar.
$hlk = Join-Path $env:TEAM_DEVICE_LOCK_DIR 'machine-heavy.json'
New-Item -ItemType Directory -Force (Split-Path $hlk) | Out-Null
[System.IO.File]::WriteAllText($hlk, (@{ kind = 'heavy'; owner = 'setup-android bench'; pid = $PID; desde = '2026-11-18 19:21:00'; root = 'C:\outro-projeto' } | ConvertTo-Json -Compress), $utf8)
Put $p '.team-project/guards.json' '{ "machine": { "heavyWaitMin": 0 }, "verify": { "build": "Write-Output \"Build succeeded. 0 Warning(s)\"", "minFreeMB": 0, "suite": "powershell -NoProfile -ExecutionPolicy Bypass -File .team-project/karma-fake.ps1" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Fresh', '-Root', $p)
Check 'v3.64.0 item 7 B: outro projeto segura a trava pesada → a suíte não roda e sai como ambiente "máquina ocupada", com o dono' $r 4 @('FALHA DE AMBIENTE em 1 comando', 'máquina ocupada — a máquina está em uso por OUTRO projeto \(C:\\outro-projeto\) — .setup-android bench.', 'trabalho pesado de projetos diferentes roda um por vez')
$r = Invoke-Check 'machine-lock.ps1' @('-Who')
Check 'v3.64.0 item 7 B: machine-lock.ps1 -Who diz quem segura a máquina' $r 0 @("machine-lock: em uso por 'setup-android bench' de C:\\outro-projeto")
$r = Invoke-Check 'machine-lock.ps1' @('-Take', '-Owner', 'eu', '-WaitMin', '0', '-Root', $p)
Check 'v3.64.0 item 7 B: machine-lock.ps1 -Take com a máquina de outro projeto → exit 3 com quem a usa' $r 3 @('machine-lock: ocupada — a máquina está em uso por OUTRO projeto')
Remove-Item -LiteralPath $hlk -Force
$r = Invoke-Check 'machine-lock.ps1' @('-Take', '-Owner', 'eu', '-WaitMin', '0', '-HolderPid', "$PID", '-Root', $p)
$r2 = Invoke-Check 'machine-lock.ps1' @('-Release', '-HolderPid', "$PID")
Check 'v3.64.0 item 7 B: machine-lock.ps1 -Take livre → tomada; -Release solta' @{ Code = $r.Code + $r2.Code; Out = $r.Out + $r2.Out + "`nFILE=" + (Test-Path -LiteralPath $hlk) } 0 @("machine-lock: tomada por 'eu'", 'machine-lock: solta', 'FILE=False')
# D8: dois servidores do adb e a porta do emulador fora do padrão → a trava do alvo recusa, com a causa.
$lt = { param($ports, $serial) $ErrorActionPreference = 'Continue'; Put $p '.team-project/guards.json' ('{ "targets": { "android": { "package": "br.x"' + $(if ($serial) { ", `"serial`": `"$serial`"" }) + ' } } }'); $o = & powershell -NoProfile -Command "`$env:TEAM_TEST_ADB_PORTS='$ports'; . '$(Join-Path $checks 'lib.ps1')'; `$m = Enter-TargetLock '$p' 'android' 'teste'; if (`$m) { 'RECUSA: ' + `$m } else { 'TOMADA'; Exit-TargetLock '$p' }" 2>&1 | Out-String; @{ Code = 0; Out = $o } }
$r = & $lt '5037,5557' ''
Check 'v3.64.0 D8: dois servidores do adb → a trava do alvo recusa com a causa e não desliga nenhum' $r 0 @('RECUSA: dois servidores do adb na máquina \(portas 5037, 5557\)', 'O plugin não desliga o de outro projeto')
$r = & $lt '5037' 'emulator-5555'
Check 'v3.64.0 D8: porta do emulador ímpar → recusa com a proposta da primeira par livre (sem gravar)' $r 0 @('RECUSA: guards\.json → targets\.android\.serial = emulator-5555: a porta do emulador é par', 'Proposta: emulator-55\d\d')
$r = & $lt '5037' 'emulator-5556'
Check 'v3.64.0 D8: um servidor do adb e a porta par declarada → a trava do alvo é tomada' $r 0 @('TOMADA')
$r = & $lt '5037' ''
Check 'v3.65.0 A2-03: sem serial declarado e um servidor do adb → nada a conferir na porta, a trava do alvo é tomada' $r 0 @('TOMADA')
# v3.65.0 A2-07: fora do verify, o accept e o reparo do android tomam a trava pesada pelo Enter-TargetLock — outro projeto com
# ela → recusa na hora (sem esperar o heavyWaitMin), com o dono, e devolve a trava do alvo e a do aparelho.
$hlk65 = Join-Path $env:TEAM_DEVICE_LOCK_DIR 'machine-heavy.json'
New-Item -ItemType Directory -Force (Split-Path $hlk65) | Out-Null
[System.IO.File]::WriteAllText($hlk65, (@{ kind = 'heavy'; owner = 'accept S9'; pid = $PID; desde = '2026-11-19 09:00:00'; root = 'C:\outro-projeto' } | ConvertTo-Json -Compress), $utf8)
$sw65 = [System.Diagnostics.Stopwatch]::StartNew(); $r = & $lt '5037' ''; $sw65.Stop()
$left65 = @(Get-ChildItem -LiteralPath $env:TEAM_DEVICE_LOCK_DIR -File -Filter '*.json' | Where-Object { $_.Name -ne 'machine-heavy.json' }).Count
Check 'v3.65.0 A2-07: outro projeto segura a trava pesada → a trava do alvo android recusa na hora, com o dono, e não fica com trava nenhuma' @{ Code = 0; Out = $r.Out + "`nRAPIDO=$($sw65.Elapsed.TotalSeconds -lt 30) ALVO=$(Test-Path -LiteralPath (Join-Path $p '.team-project/.target-lock')) APARELHO=$left65" } 0 @("RECUSA: a máquina está em uso por OUTRO projeto \(C:\\outro-projeto\) — 'accept S9'", 'RAPIDO=True ALVO=False APARELHO=0')
[System.IO.File]::WriteAllText($hlk65, (@{ kind = 'heavy'; owner = 'verify T-041'; pid = $PID; desde = '2026-11-19 09:00:00'; root = $p } | ConvertTo-Json -Compress), $utf8)
$r = & $lt '5037' ''
Check 'v3.65.0 A2-07: a trava pesada do MESMO projeto não recusa (reentrante) — a trava do alvo é tomada' $r 0 @('TOMADA')
Remove-Item -LiteralPath $hlk65 -Force -ErrorAction SilentlyContinue
# v3.65.0: o adb atual sobe o servidor como "adb -L tcp:<porta> fork-server server" — só o -P era lido e todo servidor contava 5037.
$o = & powershell -NoProfile -Command ". '$(Join-Path $checks 'lib.ps1')'; @('adb -L tcp:5037 fork-server server --reply-fd 704', 'adb -L tcp:5038 fork-server server --reply-fd 704', 'adb -P 5041 server nodaemon', 'adb fork-server server', 'adb -L tcp:localhost:5039 fork-server server') | ForEach-Object { 'P=' + (Get-AdbServerPortFromCommandLine `$_) }" 2>&1 | Out-String
Check 'v3.65.0: porta do servidor do adb lida do -L tcp:<porta> (forma atual), do -P e, sem porta, a padrão' @{ Code = 0; Out = $o } 0 @('P=5037\s+P=5038\s+P=5041\s+P=5037\s+P=5039')
$eKeep = $e   # o lib.ps1 carregado aqui grava $script:E (os marcadores) — e a suíte usa $e: restaurado logo abaixo
$r = & { $o = & { . (Join-Path $checks 'lib.ps1'); $a = Get-RunnerDisconnect "Executed 5 of 9`nChromeHeadless was not killed in 2000 ms`nChrome Headless 120 (Windows 10) crashed"; $b = Get-RunnerDisconnect "Executed 9 of 9 (1 FAILED)`nTOTAL: 1 FAILED, 8 SUCCESS"; "A=$($a.Text)|$($a.At)/$($a.Total) B=$(if ($b) { 'caiu' } else { 'nada' })" }; @{ Code = 0; Out = "$o" } }
Check 'v3.63.1 pedido 8: Get-RunnerDisconnect reconhece o Chrome que fechou e não confunde teste reprovado com queda do navegador' $r 0 @('A=Chrome Headless 120 \(Windows 10\) crashed\|5/9', 'B=nada')
$e = $eKeep; $p = $pOrig
# v3.57.0 (item 12): o build tem prazo próprio (verify.buildTimeoutMinutes); a suíte segue o verify.timeoutMinutes.
Put $p '.team-project/guards.json' '{ "verify": { "buildTimeoutMinutes": 0.05, "build": "Start-Sleep 8; Write-Output ok", "suite": "Write-Output \"Tests: 12 passed\"; New-Item -ItemType Directory -Force coverage | Out-Null; Set-Content coverage/l.info x" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.57.0 item 12: build acima do verify.buildTimeoutMinutes → exit 124, falha de ambiente (exit 4); a suíte, com o teto dela, passa' $r 4 @('build: exit 124', 'ambiente \(build\): tempo esgotado \(0\.05 min\)', 'suite: exit 0')
# v3.57.0 (item 14): APK mais velho que o código ao fim de um full verde, com alvo android → aviso já no verify (antes só o accept recusava).
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } }, "verify": { "build": "Write-Output \"Build succeeded. 0 Warning(s)\"", "suite": "Write-Output \"Tests: 12 passed\"; New-Item -ItemType Directory -Force coverage | Out-Null; Set-Content coverage/l.info x" } }'
Put $p 'app/build/outputs/apk/debug/app-debug.apk' 'apk'
(Get-Item -LiteralPath (Join-Path $p 'app/build/outputs/apk/debug/app-debug.apk')).LastWriteTime = (Get-Date).AddHours(-1)
Put $p 'app/src/main/java/A.kt' "class A`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.57.0 item 14: full verde com APK mais velho que o código → "atenção: o APK … não regerou o APK — rode assembleDebug" (exit 0)' $r 0 @('tudo exit 0', 'atenção: o APK app[\\/]build[\\/]outputs[\\/]apk[\\/]debug[\\/]app-debug\.apk é de .* e app[\\/]src[\\/]main[\\/]java[\\/]A\.kt mudou em .*o comando ''build'' não regerou o APK — rode assembleDebug')
(Get-Item -LiteralPath (Join-Path $p 'app/build/outputs/apk/debug/app-debug.apk')).LastWriteTime = (Get-Date).AddMinutes(5)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.57.0 item 14: APK mais novo que o código → sem aviso' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'não regerou o APK') { "`nAVISOU" }) } 0 @('tudo exit 0', '^(?![\s\S]*AVISOU)')
# v3.58.4 (sprint 6 do garden, T-081): memória livre antes da suíte. Abaixo de verify.minFreeMB, o verify tenta desligar o
# emulador local (target.ps1 -Release) e, ainda abaixo, segue com o aviso e os maiores consumidores. Serial de rede: o
# -Release recusa sem tocar em processo nenhum (o teste nunca desliga o emulador da máquina).
$suiteOk = '"suite": "Write-Output \"Tests: 12 passed\"; New-Item -ItemType Directory -Force coverage | Out-Null; Set-Content coverage/l.info x"'
Put $p '.team-project/guards.json' ('{ "targets": { "android": { "package": "br.x", "serial": "localhost:5555", "repair": "Write-Output x" } }, "verify": { "build": "Write-Output ok", ' + $suiteOk + ' } }')
Put $p 'src/mem.ts' "m`n"
$env:TEAM_TEST_FREE_MB = '1000'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.58.4: memória abaixo de verify.minFreeMB antes da suíte → tenta liberar o emulador (container: recusa), avisa com os maiores consumidores e a suíte roda (exit 0)' $r 0 @('verify: memória livre 1000 MB, abaixo de 6144 MB \(verify\.minFreeMB\) antes da suíte — alvo: não liberado — emulador em container', 'atenção: memória livre 1000 MB antes da suíte \(verify\.minFreeMB 6144\); maiores consumidores: \S', 'suite: exit 0', 'tudo exit 0')
Put $p '.team-project/guards.json' ('{ "verify": { "minFreeMB": 0, "build": "Write-Output ok", ' + $suiteOk + ' } }')
Put $p 'src/mem.ts' "m2`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.58.4: verify.minFreeMB 0 desliga a conferência de memória' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'memória livre') { "`nCONFERIU" }) } 0 @('tudo exit 0', '^(?![\s\S]*CONFERIU)')
Put $p '.team-project/guards.json' ('{ "verify": { "build": "Write-Output ok", ' + $suiteOk + ' } }')
Put $p 'src/mem.ts' "m3`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.58.4: sem alvo android, só o aviso (nenhuma liberação tentada)' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'alvo:') { "`nLIBEROU" }) } 0 @('atenção: memória livre 1000 MB antes da suíte', 'tudo exit 0', '^(?![\s\S]*LIBEROU)')
Remove-Item Env:\TEAM_TEST_FREE_MB -ErrorAction SilentlyContinue
# target.ps1 -Release: recusa sem reparo declarado e com serial de rede; alvo web não tem o que liberar.
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
$r = Invoke-Check 'target.ps1' @('-Target', 'android', '-Release', '-Root', $p)
Check 'v3.58.4: target.ps1 -Release sem targets.android.repair nem avd → não liberado (exit 4): o plugin não saberia religar' $r 4 @('target android: não liberado — (sem targets\.android\.repair nem avd|adb não encontrado)')
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x", "serial": "10.0.0.5:5555", "repair": "Write-Output x" } } }'
$r = Invoke-Check 'target.ps1' @('-Target', 'android', '-Release', '-Root', $p)
Check 'v3.58.4: target.ps1 -Release com serial de rede → não liberado (exit 4): o container é do projeto' $r 4 @('target android: não liberado — (emulador em container \(serial de rede 10\.0\.0\.5:5555\)|adb não encontrado)')
$r = Invoke-Check 'target.ps1' @('-Target', 'web', '-Release', '-Root', $p)
Check 'v3.58.4: target.ps1 -Release no alvo web → nada a liberar (exit 0)' $r 0 @('target web: -Release só desliga emulador android — nada a liberar')

# 5d2. verify.ps1 -Mode mutation e C1 R7-mutação (v3.46): a prova de falha declarada no plano, executada e restaurada.
$p = Join-Path $tmp 'mutacao'; New-Project $p
$ErrorActionPreference = 'Continue'
& git -C $p init -q 2>$null; Put $p '.gitignore' ".team-project/`n"
Put $p 'src/calc.ts' "export function soma(a, b) {`n  return a + b; // fim`n}`n"
Put $p 'tests/check.ps1' 'param($t) if ((Get-Content src/calc.ts -Raw) -match "a \+ b") { "Tests: 1 passed" } else { "Tests: 1 failed"; exit 1 }'
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $p '.team-project/guards.json' '{ "verify": { "focused": "powershell -NoProfile -File tests/check.ps1 {tests}", "suite": "powershell -NoProfile -File tests/check.ps1 all" } }'
Edit-File (Join-Path $p '.team-project/sprints/1/plan/T-041-export.md') '## 3. Ambiente' ("**Arquivos tocados:** ``src/calc.ts```n``tests/check.ps1```n`n**Mutações:**`n- M1 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a - b```n`n## 3. Ambiente")
$pl = '.team-project/sprints/1/plan/T-041-export.md'
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R7-mutação sem execução: não fecha' $r 1 @('\| R7-verify \| falhou', '\| R7-mutação \| falhou.*M1 e nenhuma execução')
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
Check 'verify mutation: M1 pega, árvore restaurada igual (v3.57.0: sem verify.compile, o aviso alto de que a compilação dos mutantes não foi conferida)' $r 0 @('restaurada igual', 'M1 src/calc.ts: ok', 'ATENÇÃO: o projeto não declara verify\.compile em guards\.json')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R7-mutação ok' $r 0 @('\| R7-verify \| ok', '\| R7-mutação \| ok.*1 mutação')
Edit-File (Join-Path $p $pl) '- M1 · teste' "- M2 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``// fim`` → ``// x```n- M1 · teste"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Only', 'M2', '-Root', $p)
Check 'verify mutation decorativa (-Only M2): exit 1' $r 1 @('M2 src/calc.ts: falhou')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R7-mutação com M2 não pega (M1 da amostra anterior mantida)' $r 1 @('\| R7-mutação \| falhou.*não pegas: M2')

# 5d3. verify.ps1 -Mode mutation (v3.47.1): exit ≠ 0 só prova com o teste rodando de verdade — linha de base, mutante que
# não compila, zero teste executado; -MaxMinutes com retomada; -Only e -Tests em lista por vírgula; verify.testRoot.
$p = Join-Path $tmp 'mutacao2'; New-Project $p
$ErrorActionPreference = 'Continue'
& git -C $p init -q 2>$null; Put $p '.gitignore' ".team-project/`n"
Put $p 'src/calc.ts' "export function soma(a, b) {`n  return a + b; // fim`n}`n"
Put $p 'tests/check.ps1' ('$c = Get-Content src/calc.ts -Raw' + "`n" + 'if ($c -match "NAOCOMPILA") { "src/calc.ts(2,3): error TS2871: x"; exit 1 }' + "`n" + 'if ($c -match "ZEROTESTE") { "Executed 0 of 0 ERROR"; exit 1 }' + "`n" + 'if ($c -match "a \+ b") { "Tests: 1 passed" } else { "Tests: 1 failed"; exit 1 }')
Put $p 'tests/base.ps1' '"Tests: 1 failed"; exit 1'
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $p '.team-project/guards.json' '{ "verify": { "focused": "powershell -NoProfile -File {tests}", "suite": "powershell -NoProfile -File tests/check.ps1" } }'
$pl = '.team-project/sprints/1/plan/T-041-export.md'
Edit-File (Join-Path $p $pl) '## 3. Ambiente' ("**Arquivos tocados:** ``src/calc.ts```n``tests/check.ps1```n`n**Mutações:**`n- M1 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a - b```n- M2 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``// fim`` → ``// NAOCOMPILA```n- M3 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``// fim`` → ``// ZEROTESTE```n- M4 · teste ``tests/base.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a * b```n`n## 3. Ambiente")
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-MaxMinutes', '0', '-Root', $p)
Check 'verify mutation -MaxMinutes 0: roda uma, o resto pendente, exit 3' $r 3 @('M1 src/calc.ts: ok', '3 pendente', 'parcial: M2, M3, M4')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-MaxMinutes', '0', '-Root', $p)
Check 'verify mutation retomada: M1 não roda de novo, M2 roda' $r 3 @('M2 src/calc.ts: inconclusivo.*error TS2871', 'M1 src/calc.ts: ok.*chamada anterior', 'parcial: M3, M4')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
Check 'verify mutation: zero teste e linha de base vermelha são inconclusivos, exit 1' $r 1 @('M3 src/calc.ts: inconclusivo.*Executed 0 of 0', 'M4 src/calc.ts: inconclusivo.*falha sem mutação', '1 de 4 mutação')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R7-mutação com inconclusivas: não fecha' $r 1 @('\| R7-mutação \| falhou.*não pegas: M2 inconclusivo, M3 inconclusivo, M4 inconclusivo')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Only', 'M1,M2', '-Root', $p)
Check 'verify mutation -Only "M1,M2" numa string só (powershell -File)' $r 1 @('1 de 2 mutação', 'M1 src/calc.ts: ok', 'M2 src/calc.ts: inconclusivo')
# 5d3b. v3.52.1 (garden item 28): mutante que não compila no TypeScript não conta como pego, mesmo sem a palavra "error" na
# frente do código (ts-jest, Karma/Angular) e quando o Jest/esbuild avisam que a suíte nem rodou.
$p = Join-Path $tmp 'mutacao3'; New-Project $p
$ErrorActionPreference = 'Continue'
& git -C $p init -q 2>$null; Put $p '.gitignore' ".team-project/`n"
Put $p 'src/calc.ts' "export function soma(a, b) {`n  return a + b; // fim`n}`n"
Put $p 'tests/check.ps1' ('$c = Get-Content src/calc.ts -Raw' + "`n" + 'if ($c -match "TSJEST") { "FAIL src/calc.spec.ts"; "  Test suite failed to run"; "    src/calc.ts:2:3 - TS18047: x is possibly null."; exit 1 }' + "`n" + 'if ($c -match "ANGULAR") { "Chrome 120: Executed 0 of 5 ERROR"; "Error: src/app/x.ts:12:5 - TS2339: Property a does not exist on type never."; exit 1 }' + "`n" + 'if ($c -match "ESBUILD") { "Error: Transform failed with 1 error:"; "src/calc.ts:2:3: ERROR: Unexpected token"; exit 1 }' + "`n" + 'if ($c -match "a \+ b") { "Tests: 1 passed" } else { "Tests: 1 failed"; exit 1 }')
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $p '.team-project/guards.json' '{ "verify": { "focused": "powershell -NoProfile -File {tests}", "suite": "powershell -NoProfile -File tests/check.ps1" } }'
$pl = '.team-project/sprints/1/plan/T-041-export.md'
Edit-File (Join-Path $p $pl) '## 3. Ambiente' ("**Arquivos tocados:** ``src/calc.ts```n``tests/check.ps1```n`n**Mutações:**`n- M1 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a - b```n- M2 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``// fim`` → ``// TSJEST```n- M3 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``export function`` → ``// ANGULAR```n- M4 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``return a`` → ``// ESBUILD```n`n## 3. Ambiente")
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
Check 'verify mutation: TS sem "error" na frente, suíte que não rodou e esbuild são inconclusivos (garden 28)' $r 1 @('M1 src/calc.ts: ok', 'M2 src/calc.ts: inconclusivo.*TS18047', 'M3 src/calc.ts: inconclusivo.*(Executed 0 of 5|TS2339)', 'M4 src/calc.ts: inconclusivo.*Transform failed', '1 de 4 mutação')
Put $p '.team-project/guards.json' '{ "verify": { "focused": "Write-Output \"Tests: 2 passed [{tests}]\"", "testRoot": "source/" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'focused', '-Tests', 'source/a.spec.ts,source/b.spec.ts', '-Root', $p)
Check 'verify focused -Tests "a,b" com testRoot: dois testes, sem o prefixo' $r 0 @('Tests: 2 passed \[a\.spec\.ts b\.spec\.ts\]')
# v3.48.1 — verify.testItem: runner que recebe classe, não caminho (Gradle --tests).
Put $p '.team-project/guards.json' '{ "verify": { "focused": "Write-Output \"Tests: 2 passed [{tests}]\"", "testRoot": "source/", "testItem": "--tests {class}" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'focused', '-Tests', 'source/app/src/test/java/br/app/agenda/AgendaTest.kt,source/app/src/androidTest/kotlin/br/app/ui/TelaTest.kt', '-Root', $p)
Check 'verify focused com testItem "--tests {class}": um --tests por classe qualificada (v3.48.1)' $r 0 @('Tests: 2 passed \[--tests br\.app\.agenda\.AgendaTest --tests br\.app\.ui\.TelaTest\]')
Put $p '.team-project/guards.json' '{ "verify": { "focused": "Write-Output \"Tests: 1 passed [{tests}]\"", "testItem": "{path}::{class}" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'focused', '-Tests', 'tests/test_calc.py', '-Root', $p)
Check 'verify testItem fora de src/<conjunto>/: {class} é o nome do arquivo' $r 0 @('Tests: 1 passed \[tests/test_calc\.py::test_calc\]')
# v3.55.0 (B1): verify.focused com objetos — o comando sai do caminho do teste; sem casamento, o item padrão (sem paths).
Put $p '.team-project/guards.json' '{ "verify": { "focused": [ { "command": "Write-Output \"Tests: 1 passed [NODE {tests}]\"", "paths": ["a/**"], "testRoot": "a/" }, "Write-Output \"Tests: 1 passed [PADRAO {tests}]\"" ] } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'focused', '-Tests', 'a/x.test.mjs,src/y.spec.ts', '-Root', $p)
Check 'v3.55.0 B1: focused por caminho — a/x.test.mjs vai ao comando do paths (testRoot do objeto), src/y.spec.ts ao padrão' $r 0 @('Tests: 1 passed \[NODE x\.test\.mjs\]', 'Tests: 1 passed \[PADRAO src/y\.spec\.ts\]')
Put $p '.team-project/guards.json' '{ "verify": { "focused": [ { "command": "Write-Output \"Tests: 1 passed [NODE {tests}]\"", "paths": ["a/**"] } ] } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'focused', '-Tests', 'src/y.spec.ts', '-Root', $p)
Check 'v3.55.0 B1: nenhum item casa e não há padrão — erro de uso (exit 2)' $r 2 @('nenhum item de verify\.focused casa o teste src/y\.spec\.ts')
Put $p '.team-project/guards.json' '{ "verify": { "focused": [ "Write-Output \"Tests: 1 passed [UM {tests}]\"", "Write-Output \"Tests: 1 passed [DOIS {tests}]\"" ] } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'focused', '-Tests', 'a/x.test.mjs,src/y.spec.ts', '-Root', $p)
Check 'v3.55.0 B1: lista de strings (guards.json antigo) segue igual — todo comando leva todos os testes' $r 0 @('Tests: 1 passed \[UM a/x\.test\.mjs src/y\.spec\.ts\]', 'Tests: 1 passed \[DOIS a/x\.test\.mjs src/y\.spec\.ts\]')
# B1 na mutação: a linha de base e o mutante de um teste node:test rodam o comando dele, não o do Karma.
Put $p 'tests/node/n.ps1' 'if ((Get-Content src/calc.ts -Raw) -match "a \+ b") { "Tests: 1 passed" } else { "NODE-RAN Tests: 1 failed"; exit 1 }'
Put $p '.team-project/guards.json' '{ "verify": { "focused": [ { "command": "powershell -NoProfile -File {tests}", "paths": ["tests/node/**"] }, "Write-Output \"KARMA-RAN Tests: 1 passed\"" ], "suite": "Write-Output \"Tests: 1 passed\"" } }'
Put $p $pl ("# Plano`n**Arquivos tocados:** ``src/calc.ts```n``tests/node/n.ps1```n`n**Mutações:**`n- M1 · teste ``tests/node/n.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a - b```n`n## 3. Ambiente`n")
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
Check 'v3.55.0 B1: mutação de teste node:test roda o comando do paths (e não o padrão)' $r 0 @('M1 src/calc\.ts: ok.*NODE-RAN', '1 de 1 mutação')
# B2: "tests 0" do node:test (formato TAP) e arquivo que o runner não achou são inconclusivos.
Put $p 'tests/node/zero.ps1' '"# tests 0"; "# pass 0"'
Put $p $pl ("# Plano`n**Arquivos tocados:** ``src/calc.ts```n``tests/node/zero.ps1```n`n**Mutações:**`n- M1 · teste ``tests/node/zero.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a - b```n`n## 3. Ambiente`n")
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
Check 'v3.55.0 B2: node:test com "tests 0" na linha de base é inconclusivo, não ok' $r 1 @('M1 src/calc\.ts: inconclusivo.*tests 0')
# 5d3c. v3.58.2: mutação em observação (verify.watch) — um runner por teste; a 1ª rodada é a linha de base; cada mutante e cada
# restauração são rodadas incrementais; o mutante que não compila sai inconclusivo sem esperar o prazo; a restauração que não volta
# verde derruba a sessão (o resto roda a frio); o runner que não chega à 1ª rodada cai para a frio. Com toda mutação em observação,
# o precheck automático confere só o trecho (sem o verify.compile por mutante).
$p = Join-Path $tmp 'mutacao-watch'; New-Project $p
$ErrorActionPreference = 'Continue'
& git -C $p init -q 2>$null; Put $p '.gitignore' ".team-project/`n"
Put $p 'src/calc.ts' "export function soma(a, b) {`n  return a + b; // fim`n}`n"
Put $p 'tests/check.ps1' 'if ((Get-Content src/calc.ts -Raw) -match "a \+ b") { "COLD-RAN Tests: 1 passed" } else { "COLD-RAN Tests: 1 failed"; exit 1 }'
Put $p 'tests/watch.ps1' @'
param($t, $modo = 'normal')
$last = ''; $n = 0
while ($true) {
    $c = $last; try { $c = [System.IO.File]::ReadAllText((Join-Path (Get-Location) 'src/calc.ts')) } catch { }
    if ($c -ne $last) {
        $last = $c; $n++
        [Console]::Out.WriteLine('Application bundle generation complete.')
        if ($c -match 'NAOCOMPILA') { [Console]::Out.WriteLine('src/calc.ts:2:3 - error TS2304: Cannot find name x') }
        elseif ($modo -eq 'instavel' -and $n -gt 2) { [Console]::Out.WriteLine('Chrome: Executed 1 of 1 (1 FAILED) (0.1 secs / 0.1 secs)') }
        elseif ($c -match 'a \+ b') { [Console]::Out.WriteLine("Chrome: Executed 1 of 1 SUCCESS (0.1 secs / 0.1 secs) [$t]") }
        else { [Console]::Out.WriteLine('Chrome: Executed 1 of 1 (1 FAILED) (0.1 secs / 0.1 secs)') }
        [Console]::Out.Flush()
    }
    Start-Sleep -Milliseconds 150
}
'@
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $p '.team-project/guards.json' '{ "verify": { "focused": "powershell -NoProfile -File tests/check.ps1 {tests}", "watch": { "command": "powershell -NoProfile -File tests/watch.ps1 {tests}", "runStart": "bundle generation complete" }, "compile": "Write-Output COMPILOU", "suite": "powershell -NoProfile -File tests/check.ps1" } }'
$pl = '.team-project/sprints/1/plan/T-041-export.md'
Put $p $pl ("# Plano`n**Arquivos tocados:** ``src/calc.ts```n``tests/check.ps1```n`n**Mutações:**`n- M1 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a - b```n- M2 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``// fim`` → ``// NAOCOMPILA```n- M3 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``// fim`` → ``// x```n`n## 3. Ambiente`n")
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
$vdW = Join-Path $p '.team-project/verify/1/T-041'
$left = @(Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" | Where-Object { $_.CommandLine -match 'tests[\\/]watch\.ps1' }).Count
Check 'v3.58.2: mutação em observação — base na 1ª rodada, M1 pega, M2 (não compila) inconclusivo pelo TS2304, M3 decorativa falha; uma sessão; precheck só do trecho; árvore igual' $r 1 @('Precheck \(automático, antes da mutação\).*trecho único; a compilação de cada mutante aparece na própria rodada em observação', 'M1 src/calc\.ts: ok', 'M2 src/calc\.ts: inconclusivo.*TS2304', 'M3 src/calc\.ts: falhou.*decoração', 'em observação \(verify\.watch\): 3 mutação\(ões\).*1 sessão', 'restaurada igual', '^(?![\s\S]*COLD-RAN)', '^(?![\s\S]*ATENÇÃO: o projeto não declara)')
Check 'v3.58.2: a sessão sai no fim (nenhum runner vivo, sem running.json), sem build por mutante e com o log da rodada' @{ Code = $(if (-not $left -and -not (Test-Path (Join-Path $vdW 'running.json')) -and -not (Test-Path (Join-Path $vdW 'precheck-M1.log')) -and ([System.IO.File]::ReadAllText((Join-Path $vdW 'mutation-M1.log'), $utf8) -match 'rodada em observação')) { 0 } else { 1 }); Out = "vivos=$left running=$(Test-Path (Join-Path $vdW 'running.json')) precheck-M1=$(Test-Path (Join-Path $vdW 'precheck-M1.log')) em $([int]$sw.Elapsed.TotalSeconds) s" } 0 @()
$rj = Get-Content (Join-Path $vdW 'result.json') -Raw | ConvertFrom-Json
Check 'v3.58.2: o result.json marca as mutações que rodaram em observação' @{ Code = $(if (@($rj.mutation.items | Where-Object { $_.watch -eq $true }).Count -eq 3) { 0 } else { 1 }); Out = ($rj.mutation.items | ConvertTo-Json -Depth 4) } 0 @()
# Restauração que não volta verde: o "pegou" do M1 não vale e o resto do teste (M3) roda a frio.
Put $p '.team-project/guards.json' '{ "verify": { "focused": "powershell -NoProfile -File tests/check.ps1 {tests}", "watch": "powershell -NoProfile -File tests/watch.ps1 {tests} instavel", "suite": "powershell -NoProfile -File tests/check.ps1" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Only', 'M1,M3', '-Root', $p)
Check 'v3.58.2: restauração vermelha em observação → M1 inconclusivo, sessão encerrada, M3 a frio' $r 1 @('M1 src/calc\.ts: inconclusivo — com o arquivo restaurado, a rodada em observação não voltou verde \(teste reprovado\)', 'M3 src/calc\.ts: falhou.*COLD-RAN', 'observação: M1: .*o resto dele roda a frio', 'restaurada igual')
# Runner que não chega à 1ª rodada (prazo curto): as mutações caem para a frio, com a nota.
Put $p '.team-project/guards.json' '{ "verify": { "focused": "powershell -NoProfile -File tests/check.ps1 {tests}", "watch": "Write-Output carregando; Start-Sleep 60 # {tests}", "timeoutMinutes": 0.1, "suite": "powershell -NoProfile -File tests/check.ps1" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Only', 'M1', '-Root', $p)
Check 'v3.58.2: a observação não chega à 1ª rodada → a frio, com a nota; nenhum processo fica' $r 0 @('M1 src/calc\.ts: ok.*COLD-RAN', 'observação: a observação de tests/check\.ps1 não chegou à 1ª rodada \(timeout\)')
# O tempo esgotado de um comando a frio não conta como "o teste reprovou" (antes: exit 124 → ok).
Put $p '.team-project/guards.json' '{ "verify": { "focused": "powershell -NoProfile -File {tests}", "timeoutMinutes": 0.1, "suite": "powershell -NoProfile -File tests/check.ps1" } }'
Put $p 'tests/lento.ps1' 'if ((Get-Content src/calc.ts -Raw) -match "a \+ b") { "Tests: 1 passed" } else { Start-Sleep 60 }'
Put $p $pl ("# Plano`n**Arquivos tocados:** ``src/calc.ts```n``tests/lento.ps1```n`n**Mutações:**`n- M1 · teste ``tests/lento.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a - b```n`n## 3. Ambiente`n")
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
Check 'v3.58.2: mutante a frio que estoura o prazo é inconclusivo, não "pego"' $r 1 @('M1 src/calc\.ts: inconclusivo.*TEMPO ESGOTADO')
# v3.51 (D1/D2/D4): tempo limite próprio, árvore de processos encerrada, higiene por ferramenta e falha de ambiente (exit 4).
Put $p '.team-project/guards.json' '{ "verify": { "build": "Start-Process powershell -ArgumentList ''-NoProfile'',''-Command'',''Start-Sleep 90'' -WindowStyle Hidden; Write-Output ''Build succeeded''", "suite": "Start-Sleep 60", "timeoutMinutes": 0.08 } }'
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-051', '-Mode', 'full', '-Root', $p)
Check 'verify: filho que deixa processo vivo não prende a espera; suíte que não termina estoura o tempo: exit 4 (ambiente)' $r 4 @('build: exit 0', 'suite: exit 124', 'FALHA DE AMBIENTE', 'ambiente \(suite\): tempo esgotado')
Check 'verify: o tempo total respeita o limite (bem abaixo dos 60 s da suíte e dos 90 s do órfão)' @{ Code = $(if ($sw.Elapsed.TotalSeconds -lt 40) { 0 } else { 1 }); Out = "$([int]$sw.Elapsed.TotalSeconds) s" } 0 @()
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output ''Caused by: java.lang.ClassNotFoundException: worker.org.gradle.process.internal.worker.GradleWorkerMain''; exit 1 # ./gradlew", "lint": "Write-Output (''GO='' + $env:GRADLE_OPTS + '' UH='' + $env:GRADLE_USER_HOME + '' CI='' + $env:CI) # ./gradlew lint e npm", "env": { "GRADLE_USER_HOME": "C:\\gh" } } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-051', '-Mode', 'full', '-Root', $p)
Check 'verify: assinatura do Gradle com perfil acentuado é falha de ambiente (exit 4), com a ação' $r 4 @('ambiente \(build\): o Gradle não carrega o worker', 'GRADLE_USER_HOME')
$lintLog = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/verify/1/T-051/full-lint.log'), $utf8)
Check 'verify: higiene entra no filho (Gradle sem daemon, CI=true no node) e verify.env vence' @{ Code = 0; Out = $lintLog } 0 @('GO=-Dorg.gradle.daemon=false', 'UH=C:\\gh', 'CI=true')
Put $p '.team-project/guards.json' '{ "verify": { "suite": "Write-Output ''Tests: 3 passed'' # ng test" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-051', '-Mode', 'full', '-Root', $p)
Check 'verify: ng test sem --watch=false passa, mas com o aviso de que nunca termina' $r 0 @('tudo exit 0', 'atenção: ng test sem --watch=false')

# v3.51 (F1, D3): executor de cenários e pré-voo do alvo — o que se confere sem emulador nem navegador.
$p = Join-Path $tmp 'accept'; New-Project $p
Put $p '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-001 Abre`nreset`nlaunch`nassert-text texto.raio = 150 km`n`nscenario SC-002 Conta`nlaunch`nassert-count destino.card. = 12`n"
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-ParseOnly', '-Root', $p)
Check 'accept -ParseOnly: cenários do QA lidos do lugar padrão' $r 0 @('2 cenário\(s\) válidos em 1 arquivo', 'SC-001, SC-002')
Put $p '.team-project/quality-assurance/scenarios/b.scn' "tap antes`nscenario SC-003 Ruim`npular muro`nassert-text texto.raio`n`nscenario SC-001 Repetido`nlaunch`n"
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-ParseOnly', '-Root', $p)
Check 'accept: cenário malformado sai com arquivo:linha (passo desconhecido, sem "=", id repetido): exit 2' $r 2 @("passo desconhecido 'pular'", "'assert-text' pede '<id> = <valor>'", 'SC-001 definido mais de uma vez')
Remove-Item -LiteralPath (Join-Path $p '.team-project/quality-assurance/scenarios/b.scn') -Force
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-ParseOnly', '-Only', 'SC-009', '-Root', $p)
Check 'accept -Only com cenário que não existe: exit 2' $r 2 @('SC-009 pedido em -Only não existe')
Put $p '.team-project/guards.json' '{ "targets": { "web": { "url": "http://127.0.0.1:9", "startTimeoutSec": 3 } } }'
$r = Invoke-Check 'target.ps1' @('-Target', 'web', '-Root', $p)
Check 'target web fora do ar: FALHA DE AMBIENTE (exit 4), com a ação' $r 4 @('FALHA DE AMBIENTE', 'não responde em http://127.0.0.1:9', '-Repair')
Put $p '.team-project/.target-lock' ('{"target":"web","owner":"accept T-777","pid":' + $PID + ',"desde":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '"}')
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-Target', 'web', '-Root', $p)
Check 'accept com o alvo em uso por outro automatizador: exit 4, sem tocar no alvo' $r 4 @('está em uso por ''accept T-777''')
Put $p '.team-project/.target-lock' '{"target":"web","owner":"accept velho","pid":999999,"desde":"2026-01-01 00:00:00"}'
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-Target', 'web', '-NoRepair', '-Root', $p)
Check 'accept: trava de processo morto é ignorada; sem servidor e sem reparo: exit 4 pelo pré-voo' $r 4 @('FALHA DE AMBIENTE \(web\)', 'não responde')
Check 'accept: a trava é devolvida ao sair' @{ Code = $(if (Test-Path -LiteralPath (Join-Path $p '.team-project/.target-lock')) { 1 } else { 0 }); Out = '' } 0 @()
# v3.51 (A4): métricas do portão do QA, uma linha por regra do nível 1 (Quadro de Verificação §7).
$p = Join-Path $tmp 'quality'; New-Project $p
Put $p 'src/app.ts' "export const a = 1 // TODO melhorar`n// eslint-disable-next-line no-console`nexport const b = 2 // TODO T-041 ok`n"
Put $p '.team-project/guards.json' '{ "quality": { "coverage": "Write-Output ''All files | 72.5 % |''", "lint": "Write-Output ''0 problems''", "architecture": "Write-Output ''erro de dependencia''; exit 1" } }'
$r = Invoke-Check 'quality.ps1' @('-Id', 'S1', '-Root', $p)
Check 'quality: cobertura abaixo do limiar, regra de dependência quebrada, TODO sem ID e supressão sem motivo: exit 1' $r 1 @('Q11 falhou.*72\.5 % medido × limiar 80', 'Q7 ok', 'Q1 falhou', 'Q6 não configurado', 'Q9 falhou.*src/app\.ts:1', 'Q17 falhou.*src/app\.ts:2', 'quality/1/S1/result\.md')
Put $p 'src/app.ts' "export const a = 1 // TODO T-050 melhorar`n// eslint-disable-next-line no-console -- log de diagnóstico exigido pela regra R12`n// todo o card cabe na linha; Todos os campos vêm do serviço`n"   # v3.57.2 (item 16): "todo" em português não é TODO
Put $p '.team-project/guards.json' '{ "quality": { "coverage": "Write-Output ''Total coverage: 86%''", "coverageThreshold": 85 } }'
$r = Invoke-Check 'quality.ps1' @('-Id', 'S1', '-Root', $p)
Check 'quality: cobertura acima do limiar configurado, padrões com ID e justificativa, "todo" em português não é TODO (v3.57.2): exit 0' $r 0 @('Q11 ok.*86 % medido × limiar 85', 'Q9 ok', 'Q17 ok', 'regras configuradas ok')
# v3.51 (G1, G2): kanban.md no lugar do burndown.md (o controle das Tasks embaixo) e o kanban.html regravado a cada transição.
$p = Join-Path $tmp 'kanban'; New-Project $p
$bd = Join-Path $p '.team-project/sprints/1/burndown.md'
$kb = Join-Path $p '.team-project/sprints/1/kanban.md'
[System.IO.File]::WriteAllText($kb, "# Kanban — Sprint 1`n`n## Kanban`n`n| x |`n|---|`n`n" + [System.IO.File]::ReadAllText($bd, $utf8).Replace('# Burndown — Sprint 1', '') + "`n## Controle`n`n### Bloqueios e riscos abertos`n`n| # | Task / História | Natureza | Degrau | Quem destrava | Desde |`n|---|---|---|---|---|---|`n| 1 | T-041a | ambiente | par PO+Arquiteto desde 2026-09-02 | PO | 2026-09-02 |`n", $utf8)
Remove-Item -LiteralPath $bd -Force
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041a', '-To', 'plan', '-Root', $p)
$html = Join-Path $p '.team-project/sprints/1/kanban.html'
Check 'mark com kanban.md: a transição vai ao kanban.md e a tabela Kanban é regravada, sem kanban.html (v3.51.2)' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText($kb, $utf8) + "`nHTML=" + $(if (Test-Path -LiteralPath $html) { 'presente' } else { 'ausente' }) } 0 @('Registro em kanban\.md', 'T-041a ⬜ → 🟦', '\| T-041a \|', 'Bloqueios e riscos abertos', '## Rodadas', 'HTML=ausente')
# v3.51.2 (note.md itens 7, 9 e 10): rodadas no kanban.md do sprint; kanban.md e consumption.md do bloco de fix.
Put $p '.team-project/usage.jsonl' ('{"role":"developer","work":"T-041a","model":"claude-sonnet-5-5","start":"2026-09-03T10:00:00","duration_s":360,"processed":180000,"dest":".team-project/sprints/1/consumption.md"}' + "`n" + '{"role":"developer","work":"F-001","model":"claude-haiku-4-5-20251001","start":"2026-09-03T11:00:00","duration_s":120,"processed":50000,"dest":".team-project/fixes/B-001/consumption.md"}' + "`n" + '{"role":"quality-assurance","work":"B-001","model":"claude-sonnet-5-5","start":"2026-09-03T12:00:00","duration_s":240,"processed":90000,"dest":".team-project/fixes/B-001/consumption.md"}' + "`n")
$r = Invoke-Check 'kanban.ps1' @('-Root', $p)
Check 'kanban (sprint): seção Rodadas com papel, modelo, tokens e tempo, e o total (v3.60.0: a rodada a rodada no consumption.md)' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText($kb, $utf8) + "`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/consumption.md'), $utf8) } 0 @('1 rodada', '\| dev \| sonnet 5\.5 \| 1 \| 180\.000 \| 06:00 \|', '\| 2026-09-03 10:00 \| T-041a \| dev \|', '\*\*Total\*\*')
Put $p '.team-project/fixes/B-001/plan.md' "# B-001 · mini-planos`n`n## F-001 · Data futura`n`n### Arquivos`n- produção: ``src/a.ts```n`n## F-002 · CPF`n`n**Critério que caiu:** C5 — schema`n`n## Verificação do bloco`n"
$r = Invoke-Check 'kanban.ps1' @('-Root', $p, '-Block', 'B-001', '-Init')
$kbB = Join-Path $p '.team-project/fixes/B-001/kanban.md'
Check 'kanban -Block -Init: cria consumption.md e kanban.md; F-001 dev → QA, F-002 em promoção' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText($kbB, $utf8) + "`nCONS=" + $(if (Test-Path -LiteralPath (Join-Path $p '.team-project/fixes/B-001/consumption.md')) { 'ok' } else { 'ausente' }) } 0 @('consumption\.md e kanban\.md', '\| F-001 \| — \| 50\.000 · 02:00 \| — \| — \| 50\.000 · 02:00 \|', '\| \*\*Consolidado\*\* \| — \| 50\.000 · 02:00 \| 90\.000 · 04:00 \| — \| \*\*140\.000 · 06:00\*\* \|', '\| F-001 \| ⬜ → 🟨 \|', '\| F-001 \| 🟨 → 🟪 \| 2026-09-03 12:00 \| qa \|', 'F-002 \(promoção\)', '\| qa \| sonnet 5\.5 \| 1 \| 90\.000 \| 04:00 \|', 'CONS=ok')
Put $p '.team-project/fixes/B-001/verdict.md' "# Veredito`n`n## Fechamento`n`n**Fechado em:** 2026-09-04`n`n| F-ID | Estado final |`n|---|---|`n| F-001 | fechada |`n| F-002 | promovida |`n"
$r = Invoke-Check 'kanban.ps1' @('-Root', $p, '-Block', 'B-001')
$r2 = Invoke-Check 'kanban.ps1' @('-Root', $p, '-Block', 'B-001')
Check 'kanban -Block no fechamento: estados finais e Fechado em; depois disso não regrava' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText($kbB, $utf8) + "`n" + $r2.Out } 0 @('\| F-001 \| 🟪 → ✅ \| 2026-09-04 \| sessão — fechada \|', 'F-002 \(promovida\)', '\*\*Fechado em:\*\* 2026-09-04', 'bloco B-001 fechado')

# v3.51 (B1, C2): run.ps1 — a próxima ação do sprint sai do quadro e do disco, pronta para a sessão executar.
$p = Join-Path $tmp 'run-sem-alvo'; New-Project $p
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'run next sem alvo (guards.json sem targets): não pede .scn, vai aos planos e marca 🟦 (v3.51.4)' $r 0 @('planos da História H-014', "mark: T-041a $($e.todo) → $($e.plan)")
$p = Join-Path $tmp 'run'; New-Project $p
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'run next: sem .scn, o preparo começa pelos cenários executáveis da História (QA)' $r 0 @('preparo da construção — cenários executáveis da História H-014', 'SC-014', 'team:quality-assurance')
Put $p '.team-project/quality-assurance/scenarios/H-014.scn' "scenario SC-014 Exporta`nlaunch`n"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'run next: com os cenários, os planos que faltam da História numa instância do Arquiteto' $r 0 @('planos da História H-014 numa instância do Arquiteto', 'T-041a', 'team:architect')
Put $p '.team-project/sprints/1/plan/T-041a-x.md' "# Plano`n"
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') '[`plan/T-041a-x.md`](plan/)' '[`plan/T-041a-x.md`](plan/T-041a-x.md)'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'run next: preparo completo, a Task em andamento vai ao executor de Task (C3), sem run_in_background (C1)' $r 0 @('construir T-041 — .*\(executor de Task\)', 'subagent_type "team:task-runner".*dispare e encerre o turno', 'run\.ps1 start -Task T-041', 'ao voltar: run\.ps1 next')
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$card = Join-Path $p '.team-project/sprints/1/handoff/T-041.md'
Check 'run handoff: cartão de passagem curto com plano, cenários e o comando do accept' @{ Code = $r.Code; Out = $(if (Test-Path -LiteralPath $card) { [System.IO.File]::ReadAllText($card, $utf8) + "`nKB=" + [int]((Get-Item -LiteralPath $card).Length / 1024) } else { 'sem cartão' }) } 0 @('Cartão de passagem — T-041', 'accept\.ps1 -Task T-041 -Scenarios \.team-project/quality-assurance/scenarios/H-014\.scn -Only SC-014', 'KB=[0-2]\b')

# 5d1b. v3.53.2 (sprint 5 do garden): cenário provado por teste "(teste)" não pede .scn nem accept; cenário que aguarda a
# Task que cria os nomes de teste ("# aguarda T-041: SC-016" no .scn) não trava o preparo e segura só a Task que o cita.
$p = Join-Path $tmp 'cenarios'; New-Project $p
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
$sb = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'
Edit-File $sb 'SC-014 (novo)' 'SC-014 (novo) · SC-015 (teste)'
Edit-File $sb 'nenhum aplicável — refatoração interna' 'SC-016'
Put $p '.team-project/quality-assurance/scenarios/H-014.scn' "# aguarda T-041: SC-016`nscenario SC-014 Exporta`nlaunch`nassert-exists x`n"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.2: (teste) e "aguarda" não travam o preparo — segue aos planos sem pedir .scn' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'cenários executáveis') { "`nPEDIU-SCN" } else { '' }) } 0 @('planos da História H-014 numa instância do Arquiteto', '^(?![\s\S]*PEDIU-SCN)')
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$card = Join-Path $p '.team-project/sprints/1/handoff/T-041.md'
Check 'v3.53.2: cartão — accept só do cenário de tela; o (teste) aparece como prova pelo plano' @{ Code = $r.Code; Out = $(if (Test-Path -LiteralPath $card) { [System.IO.File]::ReadAllText($card, $utf8) } else { 'sem cartão' }) } 0 @('accept\.ps1 -Task T-041 -Scenarios \.team-project/quality-assurance/scenarios/H-014\.scn -Only SC-014`', 'por teste do plano, sem accept: SC-015')
Put $p '.team-project/sprints/1/plan/T-041a-x.md' "# Plano`n"
Edit-File $sb '[`plan/T-041a-x.md`](plan/)' '[`plan/T-041a-x.md`](plan/T-041a-x.md)'
Edit-File $sb "| $($e.qa) T-041 | Endpoint de exportação | 1 | dev | — |" "| $($e.todo) T-041 | Endpoint de exportação | 1 | dev | T-041a |"
Edit-File $sb "| T-041 | [``plan/T-041a-x.md``]" "| — | [``plan/T-041a-x.md``]"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.2: Task cujo cenário aguarda outra Task não é construída antes dela (o bloqueio aparece; v3.57.0: o ciclo T-041 ↔ T-041a é dito e a Task não espera por si mesma)' $r 3 @('nenhuma Task elegível — .*T-041a espera T-041', 'CICLO de espera: (T-041 → T-041a → T-041|T-041a → T-041 → T-041a)', '^(?![\s\S]*T-041 espera T-041a,T-041)')
$arpB = Join-Path $p '.team-project/.ask-route'
Check 'v3.58.3: nenhuma Task elegível grava a rota "bloqueio" — o formulário de R25 (c) passa pela G24' @{ Code = 0; Out = $(if (Test-Path -LiteralPath $arpB) { [System.IO.File]::ReadAllText($arpB, $utf8) } else { 'ausente' }) } 0 @('"rota":"bloqueio"', '"task":"[^"]*T-041', 'degrau 1')
Edit-File $sb "| $($e.todo) T-041 | Endpoint de exportação | 1 | dev | T-041a |" "| $($e.ok) T-041 | Endpoint de exportação | 1 | dev | — |"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.2: fechada a Task que cria os nomes, o next pede o cenário que aguardava (QA)' $r 0 @('cenários executáveis da História H-014', 'SC-016', "aguarda <T-ID>")
$pl = '.team-project/sprints/1/plan/T-041a-x.md'
Put $p $pl ("# Plano`n**Cenários:** SC-014, SC-016, SC-015 (teste)`n**Risco:** infraestrutura`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 3. Ambiente`n`n| Pré-requisito | Comando de medição | Saída real |`n|---|---|---|`n| Node 20 | node --version | v20.11.0 |`n`n## 6. Testes`nsem prova: x`n`n## 9. Onde parar`n- **Pré-requisito ausente** — 🔺 GAP`n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.53.2 regra 23: cenário que aguarda conta como declarado; (teste) fica fora do .scn' $r 0 @('\| cenários \| ok.*SC-014.*SC-016 \(aguarda T-041\); por teste: SC-015')
# v3.57.7 (sprint 6 do garden, T-067): o plano cita o ID sem o "(teste)" e o .scn o declara "# SC-015 (teste) …" → vale; ID
# sem definição e sem a declaração (SC-099) continua reprovando.
Put $p '.team-project/quality-assurance/scenarios/H-014.scn' "# aguarda T-041: SC-016`n# SC-015 (teste) total do export: export.spec.ts`nscenario SC-014 Exporta`nlaunch`nassert-exists x`n"
Put $p $pl ([System.IO.File]::ReadAllText((Join-Path $p $pl), $utf8).Replace('SC-015 (teste)', 'SC-015'))
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.57.7 regra 23: ID sem "(teste)" no plano, declarado "(teste)" no .scn → ok, e a linha diz o porquê' $r 0 @('\| cenários \| ok.*SC-014.*por teste: SC-015 \(SC-015 declarados \(teste\) no \.scn\)')
Put $p $pl ([System.IO.File]::ReadAllText((Join-Path $p $pl), $utf8).Replace('SC-014, SC-016, SC-015', 'SC-014, SC-016, SC-015, SC-099'))
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.57.7 regra 23: ID sem definição nem declaração (teste) no .scn continua reprovando' $r 1 @('\| cenários \| falhou.*sem definição nos \.scn: SC-099 \|')

# 5d2. v3.53 (note.md itens 7 e 8): Task com ficha no breakdown → um Arquiteto por Task, que abre só o recorte da ficha.
$p = Join-Path $tmp 'ficha'; New-Project $p
Put $p '.team-project/architect/breakdown/S1.md' $bdText
$fc = Join-Path $p '.team-project/sprints/1/handoff/T-041a-ficha.md'
# v3.53.2: a ficha se confere ANTES do Arquiteto — caminho que não existe (o nome de classe em Fontes não é caminho).
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.2: ficha com caminho que não existe → corrigir a ficha antes do plano (nome de classe em Fontes não conta)' @{ Code = $r.Code; Out = $r.Out + "`nrecorte=" + (Test-Path -LiteralPath $fc) } 0 @('corrigir a ficha da T-041a antes do plano — caminho que não existe: src/a\.ts, docs/sdd/03-architecture\.md \(', 'Não escreva plano', 'recorte=False')
Check 'v3.53.2: IExporter em Fontes não é caminho' @{ Code = 0; Out = $(if ($r.Out -match 'IExporter') { 'contou' } else { 'ignorado' }) } 0 @('ignorado')
Put $p '.team-project/architect/breakdown/S1.md' ($bdText -replace 'Arquivos previstos:\*\* 2', 'Arquivos previstos:** 9')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.2: ficha que prevê 9 arquivos → dividir a Task antes do plano (Arquiteto curto, sessão troca a linha)' $r 0 @('dividir a T-041a antes do plano — a ficha prevê 9 arquivos \(máximo 6\)', 'Divida-a em T-041b, T-041c ','Não escreva plano', 'troca a linha da T-041a no Sprint Backlog')
Put $p '.team-project/architect/breakdown/S1.md' $bdText
$pl = '.team-project/sprints/1/plan/T-041a-x.md'
$fbase = "**Cenários:** nenhum — interno`n**Risco:** infraestrutura`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 3. Ambiente`n`n| Pré-requisito | Comando de medição | Saída real |`n|---|---|---|`n| Node 20 | node --version | v20.11.0 |`n`n## 6. Testes`nsem prova: x`n`n## 9. Onde parar`n- **Pré-requisito ausente** — 🔺 GAP`n"
Put $p $pl ("# Plano de Implementação — T-041a Variante`n" + $fbase)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.53 regra 28: sem Li além da ficha, sem o nome comum e a ficha com caminho que não existe: exit 1' $r 1 @('\| ficha \| falhou.*sem \*\*Li além da ficha:\*\*.*export_job.*caminho que não existe.*src/a\.ts, docs/sdd/03-architecture\.md')
Put $p 'src/a.ts' "export const a = 1`n"; Put $p 'docs/sdd/03-architecture.md' "# Arquitetura`n"
Remove-Item -LiteralPath (Join-Path $p $pl) -Force
# v3.60.0: a faixa da ficha que passa do fim do arquivo (src/a.ts:3 num arquivo de 1 linha) se corrige antes do plano.
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.60.0: faixa da ficha fora do arquivo → corrigir a ficha antes do plano (Grep, faixa nova caminho:a-b)' @{ Code = $r.Code; Out = $r.Out + "`nrecorte=" + (Test-Path -LiteralPath $fc) } 0 @('corrigir a ficha da T-041a antes do plano — faixa fora do arquivo: src/a\.ts:3 \(1 linhas\)', 'escreva a faixa nova como caminho:a-b', 'Não escreva plano', 'recorte=False')
Put $p 'src/a.ts' ((1..60 | ForEach-Object { "export const v$_ = $_" }) -join "`n")
Put $p 'docs/sdd/03-architecture.md' "# Arquitetura`n`n## 3. Antes`nTEXTO-ANTES`n`n## 4. Camadas`nCAMADA-DOMINIO no centro`n`n### 4.1 Detalhe`nDETALHE-41`n`n## 5. Depois`nTEXTO-DEPOIS`n"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
$fcText = if (Test-Path -LiteralPath $fc) { [System.IO.File]::ReadAllText($fc, $utf8) } else { 'sem ficha' }
Check 'v3.53: Task com ficha → plano por Task pela ficha, sem abrir o plan.ps1; v3.53.2: resumo da dependência no recorte, sem corte; v3.60.0: ficha e context.md numa chamada, o que faltar numa chamada só' @{ Code = $r.Code; Out = $r.Out + "`n" + $fcText } 0 @('plano da T-041a \(História H-014\) pela ficha, um Arquiteto por Task', 'handoff/T-041a-ficha\.md e o \.team-project/architect/context\.md, os dois na mesma chamada', 'resumo do plano da dependência \(\.team-project/sprints/1/plan/T-041-export\.md', 'A ficha já traz os trechos do código e das fontes', 'sem abrir o template inteiro', 'peça tudo numa chamada só', 'não o corte por tamanho', 'Li além da ficha', 'Não abra o plan\.ps1', '### Decisões comuns — H-014', '### Ficha T-041a', '## Plano da dependência — resumo de `\.team-project/sprints/1/plan/T-041-export\.md`', '# Plano de Implementação — T-041 Endpoint', 'Passos/blocos:\*\*\s+- Passo 1 — endpoint')
Check 'v3.53: o recorte leva só a ficha da Task (não a da outra História)' @{ Code = 0; Out = $(if ($fcText -notmatch 'T-099') { 'só a ficha' } else { 'vazou' }) } 0 @('só a ficha')
Check 'v3.60.0: o recorte traz os trechos — caminho:linha vira 40 linhas numeradas; §4 do SDD só a seção (com a 4.1); o standard do plugin' @{ Code = 0; Out = $fcText } 0 @('## Trechos que a ficha aponta', '### `src/a\.ts` — linhas 1–40 de 60 · padrão a espelhar', '(?m)^ 3  export const v3 = 3$', '(?m)^40  export const v40 = 40$', '### `docs/sdd/03-architecture\.md` — linhas 6–11 de 13', 'CAMADA-DOMINIO', 'DETALHE-41', '### `standards/implementation-principles\.md` — linhas \d+–\d+ de \d+', '^(?![\s\S]*v41 = 41)(?![\s\S]*TEXTO-DEPOIS)(?![\s\S]*TEXTO-ANTES)')
$tplLen = [System.IO.File]::ReadAllText((Join-Path $checks '..\..\roles\architect\templates\implementation-plan.md'), $utf8).Length
$gi = $fcText.IndexOf('## Guia de escrita do plano')
Check 'v3.60.0: o recorte traz o guia de escrita — esqueleto e uma linha por regra com a linha no template, sem o exemplo, menor que o template' @{ Code = 0; Out = $fcText + "`nGUIA=" + $(if ($gi -ge 0 -and ($fcText.Length - $gi) -lt 0.65 * $tplLen) { 'enxuto' } else { 'grande' }) } 0 @('## Guia de escrita do plano', '### Esqueleto', '# Plano de Implementação — <T-ID> <título da Task>', '28\. ✓ \*\*Plano pela ficha.*\*\(l\. \d+\)\*', '### Variante leve', 'GUIA=enxuto', '^(?![\s\S]*Chave de assinatura obrigatória)')
# v3.60.0: faixa exata e faixa extra do mesmo arquivo na linha (`:c-d`) — só as linhas pedidas.
Put $p '.team-project/architect/breakdown/S1.md' ($bdText.Replace('`src/a.ts:3` — padrão a espelhar', '`src/a.ts:10-12` — padrão a espelhar (`:50-52`)'))
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
$fcText = if (Test-Path -LiteralPath $fc) { [System.IO.File]::ReadAllText($fc, $utf8) } else { 'sem ficha' }
Check 'v3.60.0: faixa exata e faixa extra na mesma linha → só as linhas pedidas' @{ Code = $r.Code; Out = $fcText } 0 @('### `src/a\.ts` — linhas 10–12, 50–52 de 60', '(?m)^12  export const v12 = 12$', '(?m)^51  export const v51 = 51$', '^(?![\s\S]*v13 = 13)(?![\s\S]*v49 = 49)')
Put $p '.team-project/architect/breakdown/S1.md' $bdText
# v3.60.0 (pergunta do stakeholder: "uma tarefa pode modificar o código e assim as referências irão quebrar"): as linhas da
# ficha são as do código no início do sprint; o git as traz para hoje. No garden (S6), 6 de 60 faixas tinham andado até o
# plano — `migracoes.ts:1131` 80 linhas. Base = último commit antes da 1ª linha do run-log.md; ficha corrigida no run, o
# commit da correção (.ficha-base.json).
$pg = Join-Path $tmp 'ficha-git'; New-Project $pg
Put $pg '.team-project/architect/breakdown/S1.md' ($bdText.Replace('`src/a.ts:3` — padrão a espelhar', '`src/a.ts:10-12` — padrão a espelhar'))
Put $pg 'src/a.ts' ((1..60 | ForEach-Object { "export const v$_ = $_" }) -join "`n")
Put $pg 'docs/sdd/03-architecture.md' "# Arquitetura`n`n## 4. Camadas`nX`n"; Put $pg '.gitignore' ".team-project/`n"
$ErrorActionPreference = 'Continue'   # aviso do git no stderr (fim de linha) não é falha do teste
& git -C $pg init -q 2>$null; & git -C $pg config user.email t@t 2>$null; & git -C $pg config user.name t 2>$null; & git -C $pg config core.autocrlf false 2>$null
$env:GIT_AUTHOR_DATE = '2026-01-01T10:00:00'; $env:GIT_COMMITTER_DATE = '2026-01-01T10:00:00'
& git -C $pg add -A 2>$null; & git -C $pg commit -qm 'base do sprint' 2>$null
Put $pg '.team-project/sprints/1/run-log.md' "# Run-log`n`n| quando | item | decisão |`n|---|---|---|`n| 2026-01-02 09:00 | sprint 1 · run | Run iniciado |`n"
Put $pg 'src/a.ts' ((@(1..5 | ForEach-Object { "// novo $_" }) + @(1..60 | ForEach-Object { "export const v$_ = $_" })) -join "`n")
$env:GIT_AUTHOR_DATE = '2026-01-03T10:00:00'; $env:GIT_COMMITTER_DATE = '2026-01-03T10:00:00'
& git -C $pg commit -qam 'T-041: cabeçalho novo em a.ts' 2>$null
Remove-Item Env:GIT_AUTHOR_DATE, Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
$ErrorActionPreference = 'Stop'
$fcg = Join-Path $pg '.team-project/sprints/1/handoff/T-041a-ficha.md'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pg)
$fcText = if (Test-Path -LiteralPath $fcg) { [System.IO.File]::ReadAllText($fcg, $utf8) } else { 'sem ficha' }
Check 'v3.60.0: Task anterior empurrou o código 5 linhas → a faixa 10-12 da ficha vira 15-17, com a nota e a Task que mudou' @{ Code = $r.Code; Out = $fcText } 0 @('### `src/a\.ts` — linhas 15–17 de 65', 'linhas da ficha deslocadas desde a Planning \(por T-041\): 10-12 → 15-17', '(?m)^15  export const v10 = 10$', '(?m)^17  export const v12 = 12$', '^(?![\s\S]*v13 = 13)(?![\s\S]*novo 5)')
Put $pg 'src/a.ts' ((@(1..5 | ForEach-Object { "// novo $_" }) + @(1..60 | ForEach-Object { if ($_ -eq 11) { 'export const v11 = 1100 // mudou' } else { "export const v$_ = $_" } })) -join "`n")
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pg)
$fcText = if (Test-Path -LiteralPath $fcg) { [System.IO.File]::ReadAllText($fcg, $utf8) } else { 'sem ficha' }
Check 'v3.60.0: o próprio trecho mudou desde a Planning → copia o de hoje, com ⚠ para conferir' @{ Code = $r.Code; Out = $fcText } 0 @('⚠ trecho alterado desde a Planning \(por T-041\): 10-12 — o copiado é o de hoje', '(?m)^16  export const v11 = 1100 // mudou$')
$ErrorActionPreference = 'Continue'; & git -C $pg checkout -q -- src/a.ts 2>$null; $hdSha = "$(& git -C $pg rev-parse HEAD 2>$null)".Trim(); $ErrorActionPreference = 'Stop'
Put $pg '.team-project/architect/breakdown/S1.md' ($bdText.Replace('`src/a.ts:3` — padrão a espelhar', '`src/a.ts:90-95` — padrão a espelhar'))
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pg)
$fbj = Join-Path $pg '.team-project/sprints/1/.ficha-base.json'
Check 'v3.60.0: faixa fora do arquivo → correção da ficha, e a base dela passa a ser o commit da correção' @{ Code = $r.Code; Out = $r.Out + "`nBASE=" + $(if (Test-Path -LiteralPath $fbj) { [System.IO.File]::ReadAllText($fbj, $utf8) } else { 'sem' }) } 0 @('faixa fora do arquivo: src/a\.ts:90-95 \(65 linhas\)', "BASE=\{`"T-041a`":`"$hdSha`"\}")
Put $pg '.team-project/architect/breakdown/S1.md' ($bdText.Replace('`src/a.ts:3` — padrão a espelhar', '`src/a.ts:15-17` — padrão a espelhar'))
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pg)
$fcText = if (Test-Path -LiteralPath $fcg) { [System.IO.File]::ReadAllText($fcg, $utf8) } else { 'sem ficha' }
Check 'v3.60.0: ficha corrigida pelas linhas de hoje não é deslocada de novo' @{ Code = $r.Code; Out = $fcText } 0 @('### `src/a\.ts` — linhas 15–17 de 65 · padrão a espelhar', '(?m)^15  export const v10 = 10$', '^(?![\s\S]*deslocadas desde a Planning)')

# v3.60.0 (pedido do stakeholder, 15/11/2026): acompanhamento — a Série, o Registro de transições, a Rodada a rodada e a
# Espera de comando vão ao consumption.md; o kanban.md ganha a previsão de cada parte, o farol do prazo e o Burndown visual.
# Agora fixo (TEAM_SCHEDULE_NOW): T-041 (1) pronta em 04/09 10:00, abertura 01/09 10:00 → 74 h por dia estimado; a T-041a (1)
# termina 07/09 14:00; Janela até 10/09 → folga de 82 h > 15 % de 230 h → Adiantado.
$pk = Join-Path $tmp 'acompanha'; New-Project $pk
Edit-File (Join-Path $pk '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 | Endpoint" "| $($e.ok) T-041 | Endpoint"
Remove-Item -LiteralPath (Join-Path $pk '.team-project/sprints/1/burndown.md') -Force
Put $pk '.team-project/sprints/1/kanban.md' "# Kanban — Sprint 1`n`n## Kanban`n`n## Controle`n`n### Bloqueios e riscos abertos`n`n| # | Task / História | Natureza | Degrau | Quem destrava | Desde |`n|---|---|---|---|---|---|`n`n## Linha de base`n`n| | |`n|---|---|`n| **Sprint** | 1 |`n| **Janela** | 2026-09-01 → 2026-09-10 |`n`n## Série`n`n| Dia | Data | Evento | Est. restante | Tasks restantes |`n|---|---|---|---|---|`n| 0 | 2026-09-01 | pacote aprovado | 2 | 2 |`n| 0 | 2026-09-01 10:00 | T-041 $($e.todo) → $($e.plan) | 2 | 2 |`n| 1 | 2026-09-02 09:00 | T-041 $($e.plan) → $($e.build) | 2 | 2 |`n| 2 | 2026-09-03 15:00 | T-041 $($e.build) → $($e.qa) | 2 | 2 |`n| 3 | 2026-09-04 10:00 | T-041 $($e.qa) → $($e.ok) | 1 | 1 |`n`n## Registro de transições (R24)`n`n| Task | De → Para | Quando | Por quem |`n|---|---|---|---|`n| T-041 | $($e.todo) → $($e.plan) | 2026-09-01 10:00 | Arquiteto |`n| T-041 | $($e.plan) → $($e.build) | 2026-09-02 09:00 | dev |`n| T-041 | $($e.build) → $($e.qa) | 2026-09-03 15:00 | QA |`n| T-041 | $($e.qa) → $($e.ok) | 2026-09-04 10:00 | SM |`n`n## Rodadas`n"
Put $pk '.team-project/verify/1/T-041/time.jsonl' "{`"mode`":`"full`",`"seconds`":125}`n"
$env:TEAM_SCHEDULE_NOW = '2026-09-04 12:00'
$r = Invoke-Check 'kanban.ps1' @('-Root', $pk)
$kbA = [System.IO.File]::ReadAllText((Join-Path $pk '.team-project/sprints/1/kanban.md'), $utf8)
$csA = [System.IO.File]::ReadAllText((Join-Path $pk '.team-project/sprints/1/consumption.md'), $utf8)
Check 'v3.60.0: Série, Registro, Rodada a rodada e Espera de comando vão ao consumption.md; o kanban.md fica sem elas' @{ Code = $r.Code; Out = "@@KANBAN@@`n$kbA`n@@CONSUMO@@`n$csA" } 0 @('(?ms)@@CONSUMO@@.*^## Série\r?\n.*\| 3 \| 2026-09-04 10:00 \| T-041', '(?ms)@@CONSUMO@@.*^## Registro de transições \(R24\)\r?\n.*\| T-041 \| \S+ → \S+ \| 2026-09-04 10:00 \| SM \|', '(?ms)@@CONSUMO@@.*^## Rodada a rodada', '(?ms)@@CONSUMO@@.*^## Espera de comando.*\| T-041 \| 1 \| — \| 02:05 \| — \| \*\*02:05\*\* \|', '(?ms)@@CONSUMO@@.*^## Registro\r?\n\| Data \| Papel', '(?m)\A(?![\s\S]*@@KANBAN@@[\s\S]*^## S[ée]rie[\s\S]*@@CONSUMO@@)(?![\s\S]*@@KANBAN@@[\s\S]*^## Registro de transi[\s\S]*@@CONSUMO@@)(?![\s\S]*@@KANBAN@@[\s\S]*### Rodada a rodada[\s\S]*@@CONSUMO@@)')
Check 'v3.60.0: o Kanban traz quanto falta de cada parte aberta e quando termina, pelo ritmo medido (74 h por dia estimado)' @{ Code = $r.Code; Out = $kbA } 0 @('\(T-041a\) · falta ~3,1 dias · termina por volta de 07/09 às 14:00')
Check 'v3.60.0: farol no Resumo e no Burndown — Adiantado, previsão 07/09 14:00, prazo pela Janela (fim do dia 10/09)' @{ Code = $r.Code; Out = $kbA } 0 @('(?m)^- \*\*Prazo:\*\* 🔵 Adiantado — previsão de término 07/09 às 14:00 \(faltam ~3,1 dias de relógio\); prazo 10/09 \(fim do dia\), o fim do sprint\.', '(?ms)^## Kanban.*^## Burndown.*^## Controle', '- \*\*Ritmo medido:\*\* 1 dias estimados prontos em ~3,1 dias de relógio desde a abertura — ~3,1 dias por dia estimado')
Check 'v3.60.0: Burndown visual — Mermaid com a linha ideal (cinza) e a real (azul), legenda em texto e a tabela por dia' @{ Code = $r.Code; Out = $kbA } 0 @('\*\*Legenda:\*\* linha azul = restante real · linha cinza = ritmo ideal até o prazo', '"plotColorPalette": "#9a9993, #2a78d6"', '(?m)^xychart-beta$', 'x-axis \["01/09", "02/09", "03/09", "04/09", "05/09", "06/09", "07/09", "08/09", "09/09", "10/09"\]', 'y-axis "Restante" 0 --> 2', '(?m)^    line \[2, 1\.78, 1\.56, 1\.33, 1\.11, 0\.89, 0\.67, 0\.44, 0\.22, 0\]$', '(?m)^    line \[2, 2, 2, 1\]$', '\| 3 \| 04/09 \| 1 \| 1,33 \| ██████████ \|', '\| 4 \| 05/09 \| — \| 1,11 \|  \|')
$env:TEAM_SCHEDULE_NOW = '2026-09-12 10:00'
$r = Invoke-Check 'kanban.ps1' @('-Root', $pk)
$kbA = [System.IO.File]::ReadAllText((Join-Path $pk '.team-project/sprints/1/kanban.md'), $utf8)
Check 'v3.60.0: com o prazo vencido e parte aberta → Atrasado' @{ Code = $r.Code; Out = $kbA } 0 @('(?m)^- \*\*Prazo:\*\* 🔴 Atrasado — previsão de término')
Remove-Item Env:TEAM_SCHEDULE_NOW -ErrorAction SilentlyContinue
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041a', '-To', 'plan', '-By', 'teste', '-Root', $pk)
$csA = [System.IO.File]::ReadAllText((Join-Path $pk '.team-project/sprints/1/consumption.md'), $utf8)
$kbA = [System.IO.File]::ReadAllText((Join-Path $pk '.team-project/sprints/1/kanban.md'), $utf8)
Check 'v3.60.0: o mark.ps1 grava a Série e o Registro no consumption.md (e não os recria no kanban.md)' @{ Code = $r.Code; Out = $r.Out + "`n@@CONSUMO@@`n$csA`n@@KANBAN@@`n$kbA" } 0 @('Registro em consumption\.md', '(?ms)@@CONSUMO@@.*\| T-041a \| \S+ → \S+ \| \d{4}-\d\d-\d\d \d\d:\d\d \| teste', '(?ms)@@CONSUMO@@.*T-041a \S+ → \S+ · teste', '(?m)\A(?![\s\S]*@@KANBAN@@[\s\S]*^## S[ée]rie)')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Post', '-Root', $pk)
Check 'v3.60.0: a R24 do close.ps1 -Post lê o Registro e a Série no consumption.md' @{ Code = 0; Out = $r.Out } 0 @('\| R24 \| ok')
Put $p $pl ("# Plano de Implementação — T-041a Variante`n**Li além da ficha:** ``src/b.ts`` — o leitor do export_job`n" + $fbase)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.53 regra 28: plano pela ficha conferido — nomes, caminhos, "li além" contado e (v3.53.2) previsto × plano' $r 0 @('\| ficha \| ok.*1 nome.*3 caminho.*li além da ficha: 1; arquivos previstos 2, no plano 2')
Put $p '.team-project/sprints/1/plan/T-050-x.md' ("# Plano`n" + $fbase)
$r = Invoke-Check 'plan.ps1' @('-Plan', '.team-project/sprints/1/plan/T-050-x.md', '-Root', $p)
Check 'v3.53 regra 28: Task sem ficha segue sem a conferência (n-a)' $r 0 @('\| ficha \| n-a')
Remove-Item -LiteralPath (Join-Path $p '.team-project/architect/breakdown/S1.md') -Force
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53: sem ficha no breakdown, o preparo volta a ser por História (regra 25)' $r 0 @('planos da História H-014 numa instância do Arquiteto')

# 5e. close.ps1 -Apply (v3.46): a sessão fecha sem o Agent scrum-master — quadro, Registro, Série, -Post e entrada de status.
$p = Join-Path $tmp 'apply'; New-Project $p
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Apply', '-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 (Join-Path $p '.team-project/sprints/1/sprint-backlog.md')) + (Get-Content -Raw -Encoding UTF8 (Join-Path $p '.team-project/sprints/1/burndown.md'))
Check 'C1 -Apply: quadro ✅, Registro e Série gravados, -Post R24 ok, entrada de status' $r 0 @('\*\*-Apply:\*\*.*R24 \| ok', "\| $($e.ok) T-041 \|", "\| T-041 \| $($e.qa) → $($e.ok) \| \d{4}-\d\d-\d\d \d\d:\d\d \| sessão", "T-041 $($e.qa) → $($e.ok) \| 1 \| 1 \|", 'Entrada de status', 'H-014 — 1 de 2 Tasks')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Apply', '-Root', $p)
Check 'C1 -Apply de novo: Task já ✅, exit 2' $r 2 @()
$p = Join-Path $tmp 'applyr12'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') '**Estado:** atualizados' '**Estado:** pendentes'
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Apply', '-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 (Join-Path $p '.team-project/sprints/1/sprint-backlog.md'))
Check 'C1 -Apply com R12 pendente: não fecha, quadro intacto' $r 1 @('Não fecha', "\| $($e.qa) T-041 \|")

# 5e2. v3.51 (A3): a Task fecha pela evidência do DEV (delivery/<T-ID>.md), com os cenários rodados no alvo (R7-aceite).
$p = Join-Path $tmp 'dev-evid'; New-Project $p
Remove-Item -LiteralPath (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') -Force
Put $p '.team-project/sprints/1/delivery/T-041.md' ("## Entrega — T-041 Endpoint`n`n### Verificação`n``````n> verify full T-041`nverify full T-041 · tudo exit 0`n``````n`n### Documentos vivos (R12)`n**Estado:** a consolidar no fim do sprint — 03-architecture §4`n`n### Não fiz (fora do plano)`nnada`n")
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 evidência do dev sem alvo configurado: fecha (R7 do dev, R12 a consolidar, R7-aceite n-a)' $r 0 @('\| R7 \| ok.*evidência do dev', '\| R12 \| ok.*a consolidar', '\| R7-aceite \| n-a')
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 evidência do dev com alvo e sem accept: não fecha (R7-aceite)' $r 1 @('\| R7-aceite \| falhou.*accept\.ps1 -Task T-041 -Only SC-014', 'Não fecha')
Put $p '.team-project/accept/1/T-041/result.json' '{ "task": "T-041", "target": "android", "at": "2026-10-21 10:00:00", "tree": null, "environment": null, "results": [ { "id": "SC-014", "status": "FALHOU", "detail": "x" } ] }'
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 evidência do dev com cenário reprovado no alvo: não fecha' $r 1 @('\| R7-aceite \| falhou.*falharam: SC-014')
Put $p '.team-project/accept/1/T-041/result.json' '{ "task": "T-041", "target": "android", "at": "2026-10-21 10:00:00", "tree": null, "environment": null, "results": [ { "id": "SC-014", "status": "PASSOU", "detail": "" } ] }'
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 evidência do dev com os cenários da Task passando no alvo: fecha' $r 0 @('\| R7-aceite \| ok.*1 cenário', '\| R30 \| ok.*SC-014')
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') 'SC-014 (novo)' 'SC-014 (teste)'
Remove-Item -LiteralPath (Join-Path $p '.team-project/accept/1/T-041/result.json') -Force
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.53.2: Task só com cenário (teste), com alvo e sem accept: fecha (R30 por teste, R7-aceite n-a)' $r 0 @('\| R30 \| ok.*todos provados por teste do plano: SC-014', '\| R7-aceite \| n-a.*nenhum cenário de tela')

# 5f. plan.ps1 (v3.46): o plano é conferido antes do dev.
$p = Join-Path $tmp 'plano'; New-Project $p
$pl = '.team-project/sprints/1/plan/T-050-x.md'; $fence = '```'
$amb = "## 3. Ambiente medido`n`n| Pré-requisito | Comando de medição | Saída real |`n|---|---|---|`n| Node 20 | node --version | v20.11.0 |`n"
$parar = "## 9. Onde parar`n- **Pré-requisito ausente** — 🔺 GAP`n"
Put $p $pl ("# Plano`n**Cenários:** nenhum — só domínio, coberto por teste unitário`n**Risco:** regra de negócio`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n$amb`n## 4. Passos`n`n### Passo 1 — x`n- **Assinatura exata:**`n  $fence`n  export function a(): number`n  $fence`n`n## 6. Testes`n`n**Mutações:**`n- M1 · teste ``tests/a.spec.ts`` · ``src/a.ts`` · regra: devolver outro valor que não 1`n`n$parar")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano em contrato: exit 0 (v3.54: mutação de arquivo novo declarada pela regra)' $r 0 @('\| lista \| ok', '\| protegidos \| ok', '\| blocos \| n-a', '\| trecho \| ok', '\| mutação \| ok.*1 muta.*1 pela regra')
$long = (1..20 | ForEach-Object { "  linha $_" }) -join "`n"
Put $p $pl ("# Plano`n`n**Arquivos tocados:** " + ((1..9 | ForEach-Object { "``src/f$_.ts``" }) -join "`n") + "`n`n## 4. Passos`n`n### Passo 1 — x`n$fence`n$long`n$fence`n`n## 6. Testes`n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano com código longo, 9 arquivos sem bloco, sem teste, sem mutação, sem protegidos: exit 1' $r 1 @('\| lista \| falhou', '\| protegidos \| falhou', '\| blocos \| falhou.*9 arquivos', '\| trecho \| falhou.*Passo 1 \(20 linhas\)', '\| mutação \| falhou', 'não vai ao dev')
Put $p $pl ("# Plano`n**Trilha:** leve`n`n**Arquivos tocados:** " + ((1..5 | ForEach-Object { "``src/f$_.ts``" }) -join "`n") + "`n``tests/f.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 6. Testes`nsem prova: só configuração`n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano leve com 6 arquivos: volta à plena' $r 1 @('\| leve \| falhou.*6 arquivos', '\| mutação \| ok.*sem prova')
Put $p $pl ("# Plano`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 6. Testes`n`n**Mutações:**`n- M1 · teste ``tests/a.spec.ts`` · ``src/a.ts`` · ```` → ``x```n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano com trecho de mutação vazio (crase dupla): exit 1 (v3.47.1)' $r 1 @('\| mutação \| falhou.*M1: trecho vazio')
Put $p $pl ("# Plano`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 6. Testes`n`n**Mutações:**`n- M1 · teste ``tests/a.spec.ts::Soma_DoisValores_DevolveTotal`` · ``src/a.ts`` · regra: devolver outro valor que não a soma`n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.57.6: teste da mutação com ::NomeDoTeste → diz o motivo, não "fora de Arquivos tocados" (T-081 do garden)' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'teste \S+ fora de') { "`nMSG-VAGA" } else { '' }) } 1 @('\| mutação \| falhou.*M1: o campo teste traz o nome do teste .*só o caminho do arquivo, `tests/a\.spec\.ts`, sem ::Soma_DoisValores_DevolveTotal; o nome do teste vai no texto da regra \(tests/a\.spec\.ts está em \*\*Arquivos tocados:\*\*\)', '^(?![\s\S]*MSG-VAGA)')
Put $p $pl ("# Plano`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n``.team-project/scrum-master/context.md```n``.github/workflows/ci.yml```n`n**Arquivos protegidos:** nenhum`n`n## 6. Testes`nsem prova: x`n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano com documento de outro papel e arquivo de gate na lista: exit 1 (v3.48)' $r 1 @('\| dono \| falhou.*scrum-master/context\.md é de SM.*ci\.yml é arquivo de gate')
Put $p $pl ("# Plano`n**Cenários:** nenhum — configuração`n**Risco:** infraestrutura`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n``.team-project/developer/context.md```n`n**Arquivos protegidos:** nenhum`n`n$amb`n## 6. Testes`nsem prova: x`n`n$parar")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano com o contexto do próprio dev: dono ok (v3.48)' $r 0 @('\| dono \| ok')
# v3.51 — plano enxuto (22), cenários ao lado (23), teste pelo risco (24) e render só com layout novo (21).
$head = "**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n$amb`n## 6. Testes`nsem prova: x`n`n$parar"
Put $p $pl ("# Plano`n**Cenários:** SC-001, SC-009`n**Risco:** interface simples`n**Layout novo:** não`n`n" + $head)
Put $p '.team-project/quality-assurance/scenarios/t.scn' "scenario SC-001 Abre`nlaunch`n"
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano cita cenário que não existe nos .scn: exit 1 (regra 23)' $r 1 @('\| cenários \| falhou.*SC-009', '\| render \| n-a.*sem layout novo', '\| risco \| ok')
Put $p '.team-project/quality-assurance/scenarios/t.scn' "scenario SC-001 Abre`nlaunch`n`nscenario SC-009 Conta`nlaunch`n"
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano com cenários existentes e interface simples sem layout novo: exit 0' $r 0 @('\| cenários \| ok.*SC-001, SC-009', '\| tamanho \| ok')
Put $p $pl ("# Plano`n**Cenários:** SC-001`n**Risco:** regra de negócio`n`n" + $head)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano de regra de negócio sem mutação: exit 1 (regra 24)' $r 1 @('\| risco \| falhou.*pede mutação')
Put $p $pl ("# Plano`n**Cenários:** SC-001`n**Risco:** interface simples`n`n" + $head)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano de interface sem **Layout novo:**: exit 1 (regra 21)' $r 1 @('\| render \| falhou.*Layout novo')
Put $p $pl ("# Plano`n**Cenários:** SC-001`n**Risco:** interface simples`n**Layout novo:** sim`n`n" + $head)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano com layout novo sem Render real: exit 1 (proposta d ajustada)' $r 1 @('\| render \| falhou.*Render real.*headless')
Put $p $pl ("# Plano`n**Risco:** infraestrutura`n`n" + $head + ('x' * 21000))
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.53.2: plano de 21 KB não reprova por tamanho (sem corte); sem **Cenários:** exit 1 (regra 23)' $r 1 @('\| tamanho \| ok', '\| cenários \| falhou.*sem \*\*Cenários')
Put $p $pl ("# Plano`n**Cenários:** SC-001, SC-009`n**Risco:** interface simples`n**Layout novo:** não`n`n" + $head + ('x' * 32000))
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.53.6 item 1: plano acima de 30 KB reprova (exit 1) — Task grande à divisão, nunca corte nem correção (regra 22)' $r 1 @('\| tamanho \| falhou.*acima de 30 KB \(regra 22\)\. Antes da construção: Task grande — NÃO corte nem encurte', 'run\.ps1 next a divide com os blocos deste plano', "volte dizendo 'tamanho'", 'Construção começada \(plano emendado por decisão do stakeholder, Q-S ou GAP\): a Task não se divide', '^(?![\s\S]*volta ao Arquiteto com esta tabela)')
# v3.60.1 (sprint 6 do garden, T-090): as decisões de 🔺 GAP não contam para o teto — 27 KB de plano + 4 KB de decisões passa.
$gapDec = "**Decisão do GAP T-001 (2026-11-15):** " + ('d' * 2000) + "`n**Origem:** processo`n**Lição:** nenhuma`n`n**Decisão do GAP T-001 (2026-11-15):** " + ('e' * 2000) + "`n**Origem:** ambiente`n**Lição:** projeto`n`n"
Put $p $pl ("# Plano`n**Cenários:** SC-001, SC-009`n**Risco:** interface simples`n**Layout novo:** não`n`n" + $gapDec + $head + ('x' * 27000))
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.60.1: decisões de 🔺 GAP fora da conta do teto — 27 KB de plano + 4 KB de decisões passa, e a linha diz quanto ficou fora' $r 0 @('\| tamanho \| ok \| 2\d(?:[.,]\d)? KB \(\+4[.,]\d KB de decisões de 🔺 GAP e do stakeholder, fora da conta; arquivo com 3\d(?:[.,]\d)? KB\)')
Put $p $pl ("# Plano`n**Cenários:** SC-001, SC-009`n**Risco:** interface simples`n**Layout novo:** não`n`n" + $gapDec + $head + ('x' * 31000))
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.60.1: plano acima do teto sem as decisões continua reprovando' $r 1 @('\| tamanho \| falhou.*\(\+4[.,]\d KB de decisões de 🔺 GAP')

# 5g. v3.48 — achados do primeiro sprint do piloto: revisão sem veredito acima da rodada, entrada aceita pelo stakeholder,
# report gravado pelo hook com nome livre, pasta citada sem report, -Apply com o Registro no quadro antigo.
$p = Join-Path $tmp 'v348'; New-Project $p
$ev = Join-Path $p '.team-project/sprints/1/evidence/T-041.md'
Edit-File $ev '## T-041 — Endpoint de exportação — 2026-09-03' "## Nota do Arquiteto — 2026-09-04`nRevisão do plano corrigido; sem rodada nova do QA.`n`n## T-041 — Endpoint de exportação — 2026-09-03"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 nota sem veredito acima da rodada: R7 e R12 leem a rodada, exit 0' $r 0 @('\| R7 \| ok.*1 bloco\(s\) mais novo\(s\) sem veredito', '\| R12 \| ok')
$sb = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'
$hdr = '| O que saiu para caber | Data |'
Edit-File $sb $hdr "$hdr`n|---|---|---|---|---|`n| T-041 | H-014 | pedido do stakeholder na Review | nada | 2026-09-02 |"   # a linha |---| original sobra depois: Get-Tables a ignora
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 entrada fora da Planning sem nada sair e sem decisão: R4 falhou' $r 0 @('\| R4 \| falhou.*nem "Decisão do stakeholder" com data', '\| R30 \| ok')
Edit-File $sb $hdr '| O que saiu para caber | Data | Decisão do stakeholder |'
Edit-File $sb '| nada | 2026-09-02 |' '| nada | 2026-09-02 | aceito em 2026-09-02 (formulário) |'
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 entrada com Decisão do stakeholder datada: R4 ok' $r 0 @('\| R4 \| ok.*aceita pelo stakeholder em 2026-09-02')
Put $p '.team-project/operator/1/job1/report-ab12cd34-r2.md' "<!-- G16 -->`nsegunda resposta`n"
Edit-File (Join-Path $p '.team-project/sprints/1/consumption.md') '| 500 | 00:30 | chamado por qa |' "| 500 | 00:30 | chamado por qa |`n| 2026-09-03 | operator | haiku | ``/qa`` | T-041 | verificação | H-014 | 300 | 00:10 | chamado por qa |"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R28 conta todo report*.md da pasta citada (nome do hook G16)' $r 0 @('\| R28 \| ok.*2 report\(s\) = 2 linha')
Edit-File $ev '`.team-project/operator/1/job1/report.md`' '`.team-project/operator/1/job2/report.md`'
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R28 pasta citada sem report: aponta a pasta' $r 0 @('\| R28 \| falhou.*report ausente em \.team-project/operator/1/job2/')
$p = Join-Path $tmp 'applylegado'; New-Project $p
$bdp = Join-Path $p '.team-project/sprints/1/burndown.md'; $sbp = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'
$bdt = [System.IO.File]::ReadAllText($bdp, $utf8); $ix = $bdt.IndexOf('## Registro de transi')
[System.IO.File]::WriteAllText($bdp, $bdt.Substring(0, $ix), $utf8)
Edit-File $sbp '## Entradas fora da Planning' ($bdt.Substring($ix) + "`n## Entradas fora da Planning")
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Apply', '-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 $sbp)
Check 'C1 -Apply com o Registro no sprint-backlog (quadro antigo): grava lá, R24 ok' $r 0 @('Registro no sprint-backlog\.md', '\*\*-Apply:\*\*.*R24 \| ok', "\| T-041 \| $($e.qa) → $($e.ok) \| \d{4}-\d\d-\d\d \d\d:\d\d \| sessão")

# 6. Duas Tasks em construção com 1 dev → R1 falhou; T-041 não confunde com T-041a.
$p = Join-Path $tmp 'r1'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.todo) T-041a |" "| $($e.build) T-041a |"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 duas em construção: R1 falhou' $r 0 @('\| R1 \| falhou.*T-041.*T-041a')

# 7. Erro de uso: sem .team-project → exit 2.
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $tmp)
Check 'C1 sem .team-project: exit 2' $r 2 @()

# 8. C2 no projeto feliz (sem git: R31 n-a). v3.64.1: um projeto próprio no mesmo estado do "feliz" do caso 1 (New-Project e
# o fechamento da T-041), para o trecho rodar sozinho num bloco do run-all-tests.ps1.
$p = Join-Path $tmp 'feliz-c2'; New-Project $p; Close-T041 $p
if (Test-Path (Join-Path $checks 'project.ps1')) {
    $r = Invoke-Check 'project.ps1' @('-Root', $p)
    Check 'C2 feliz: R14 ok, R21 ok, R31 n-a' $r 0 @('\| R14 \| ok', '\| R21 \| ok', '\| R31 \| n-a')
    Put $p '.team-project/product-owner/notes.md' "## Aceite — H-014`n"
    $r = Invoke-Check 'project.ps1' @('-Root', $p)
    Check 'C2 dossiê de aceite fora da Review: R21 falhou' $r 0 @('\| R21 \| falhou', '\| R34 \| n-a')

    # R34: projeto remoto
    $p = Join-Path $tmp 'remoto'; New-Project $p
    Edit-File (Join-Path $p '.team-project/README.md') '## 2. Situação atual' "**Identificador remoto:** ACME`n**Conta remota:** pessoal`n**Verificação remota:** 2026-08-30`n`n## 2. Situação atual"
    Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') '| **Aprovado em** | 2026-09-01 |' "| **Aprovado em** | 2026-09-01 |`n| **Canal da decisão** | celular |`n| **Protótipo (URL · rótulo)** | https://claude.ai/artifact/AbC123 · ③ v2 |"
    $r = Invoke-Check 'project.ps1' @('-Root', $p)
    Check 'C2 R34 remoto completo: ok' $r 0 @('\| R34 \| ok.*ACME.*pessoal.*2026-08-30')
    Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') '| **Canal da decisão** | celular |' '| **Canal da decisão** | <canal> |'
    Edit-File (Join-Path $p '.team-project/README.md') '1. nenhuma' '1. [ACME · S1 · ③ pacote] Aprova? — decisão: [No preference]'
    $r = Invoke-Check 'project.ps1' @('-Root', $p)
    Check 'C2 R34 sem canal e No preference como decisão: falhou' $r 0 @('\| R34 \| falhou.*Canal da decisão.*No preference')
    Edit-File (Join-Path $p '.team-project/README.md') '**Verificação remota:** 2026-08-30' '**Verificação remota:**'
    Edit-File (Join-Path $p '.team-project/README.md') '1. [ACME · S1 · ③ pacote] Aprova? — decisão: [No preference]' '1. nenhuma'
    $r = Invoke-Check 'project.ps1' @('-Root', $p)
    Check 'C2 R34 configurado sem verificação: aviso' $r 0 @('\| R34 \| aviso.*não verificado')

    # v3.47 (M3): "navegação simulada" só vale com guards.json → bench ligado.
    $p = Join-Path $tmp 'bench'; New-Project $p
    Put $p '.team-project/user-experience/prototype/ficha.md' "# Protótipo funcional`n`n**Navegado pelo stakeholder em:** n/a — navegação simulada (benchmark)`n"
    $r = Invoke-Check 'project.ps1' @('-Root', $p)
    Check 'C2 navegação simulada sem bench: R15 falhou' $r 0 @('\| R15 \| falhou.*navegação simulada.* fora do modo benchmark')
    Put $p '.team-project/guards.json' '{ "bench": { "arm": "P0-r1", "answers": "bench/answers.json", "foreground": true } }'
    $r = Invoke-Check 'project.ps1' @('-Root', $p)
    Check 'C2 navegação simulada com bench: R15 n-a' $r 0 @('\| R15 \| n-a.*modo benchmark')
    Put $p '.team-project/user-experience/prototype/ficha.md' "# Protótipo funcional`n`n**Navegado pelo stakeholder em:** 2026-09-01 · canal: terminal · declarada`n"
    $r = Invoke-Check 'project.ps1' @('-Root', $p)
    Check 'C2 navegação real com bench ligado: R15 segue a regra de sempre' $r 0 @('\| R15 \| n-a')
}

# v3.65.0 A1-09/A1-10: R15 e R31 do C2 num projeto git — o SDD técnico (03/04/05) comparado à navegação do ① pela data do
# git log (autor); o .team-project/ fora do git, ignorado e sem citação no diretório de produto.
$mk65c2 = { param($dir, $date)
    New-Project $dir
    Put $dir '.team-project/user-experience/prototype/ficha.md' "# Protótipo funcional`n`n**Navegado pelo stakeholder em:** 2026-09-01 · canal: terminal · declarada`n"
    Put $dir 'docs/sdd/03-architecture.md' "# Arquitetura`n"; Put $dir '.gitignore' ".team-project/`n"
    $ErrorActionPreference = 'Continue'
    & git -C $dir init -q 2>$null; & git -C $dir config user.email t@t 2>$null; & git -C $dir config user.name t 2>$null
    & git -C $dir add -A 2>$null; & git -C $dir commit -qm sdd "--date=$($date)T10:00:00" 2>$null
}
$p65a = Join-Path $tmp 'v3650-c2-antes'; & $mk65c2 $p65a '2026-08-20'
$r = Invoke-Check 'project.ps1' @('-Root', $p65a)
Check 'v3.65.0 A1-09: SDD técnico criado antes da navegação do ① (git log) → R15 falhou com o arquivo e a data' $r 0 @('\| R15 \| falhou \| SDD técnico antes da navegação do ① \(2026-09-01\): 03-architecture\.md em 2026-08-20')
$p65b = Join-Path $tmp 'v3650-c2-depois'; & $mk65c2 $p65b '2026-09-05'
$r = Invoke-Check 'project.ps1' @('-Root', $p65b)
Check 'v3.65.0 A1-09: SDD técnico criado depois da navegação do ① → R15 ok' $r 0 @('\| R15 \| ok \| 1 documento\(s\) 03/04/05 criados depois do ① \(2026-09-01\)')
Check 'v3.65.0 A1-10: .team-project/ ignorado, fora do git e docs/ sem citação → R31 ok' $r 0 @('\| R31 \| ok \| \.team-project/ fora do git e ignorado; docs/ sem referência')
Put $p65b 'docs/sdd/guia.md' "Veja .team-project/README.md`n"
$r = Invoke-Check 'project.ps1' @('-Root', $p65b)
Check 'v3.65.0 A1-10: docs/ citando .team-project → R31 falhou com o arquivo' $r 0 @('\| R31 \| falhou \| docs/ cita \.team-project em 1 arquivo\(s\) \(ex\.: docs.sdd.guia\.md\)')
Remove-Item -LiteralPath (Join-Path $p65b 'docs/sdd/guia.md') -Force
Put $p65b '.gitignore' "node_modules/`n"
$r = Invoke-Check 'project.ps1' @('-Root', $p65b)
Check 'v3.65.0 A1-10: .gitignore sem a linha do .team-project/ → R31 falhou' $r 0 @('\| R31 \| falhou \| \.team-project/ não está no \.gitignore', '^(?![\s\S]*arquivo\(s\) de \.team-project/ no git)')
Put $p65b '.gitignore' ".team-project/`n"
$ErrorActionPreference = 'Continue'; & git -C $p65b add -f .team-project/README.md 2>$null; & git -C $p65b commit -qm rastreado 2>$null; $ErrorActionPreference = 'Stop'
$r = Invoke-Check 'project.ps1' @('-Root', $p65b)
Check 'v3.65.0 A1-10: arquivo de .team-project/ rastreado no git → R31 falhou com o exemplo' $r 0 @('\| R31 \| falhou \| 1 arquivo\(s\) de \.team-project/ no git \(ex\.: \.team-project/README\.md\)')

# v3.65.0 A1-11: os ramos "falhou" do C1 que o caminho feliz não cobre — R8 (sem plano), R16 (sem standard com §), R26 (sem
# as seções 3 e 9) e R25 (pacote incompleto, bloqueio sem degrau).
$p65r8 = Join-Path $tmp 'v3650-c1-r8'; New-Project $p65r8
Remove-Item -LiteralPath (Join-Path $p65r8 '.team-project/sprints/1/plan/T-041-export.md') -Force
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p65r8)
Check 'v3.65.0 A1-11: sem plano da Task → R8 falhou; R16 e R26 n-a (sem plano)' $r 0 @('\| R8 \| falhou \| nenhum plano para T-041 em sprints/1/plan/', '\| R16 \| n-a \| sem plano', '\| R26 \| n-a \| sem plano')
$p65c1 = Join-Path $tmp 'v3650-c1-plano'; New-Project $p65c1
$pl65 = Join-Path $p65c1 '.team-project/sprints/1/plan/T-041-export.md'
$t65 = [System.IO.File]::ReadAllText($pl65, $utf8) -replace '(?m)^- \*\*Standard aplicável:\*\*.*$', '- **Standard aplicável:** n/a — passo sem padrão' -replace '(?s)## 3\. Ambiente.*?(?=## 4\.)', '' -replace '(?s)## 9\..*$', ''
[System.IO.File]::WriteAllText($pl65, $t65, $utf8)
$sb65 = Join-Path $p65c1 '.team-project/sprints/1/sprint-backlog.md'
Edit-File $sb65 '| **Aprovado por** | Stakeholder |' '| **Aprovado por** | <quem aprovou> |'
Edit-File $sb65 ' · **fluxo ponta a ponta coberto:** exportar análise' ''
Edit-File $sb65 '| par PO+Arquiteto desde 2026-09-02 |' '| esperando |'
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p65c1)
Check 'v3.65.0 A1-11: plano sem citação de standards/ com § → R16 falhou' $r 0 @('\| R16 \| falhou \| nenhuma citação de standards/ com § numerado')
Check 'v3.65.0 A1-11: plano sem as seções 3 e 9 → R26 falhou com as duas' $r 0 @('\| R26 \| falhou \| seção 3 \(ambiente medido\) ausente ou depois dos passos; seção 9 sem "Pré-requisito ausente"')
Check 'v3.65.0 A1-11: pacote sem "Aprovado por", protótipo sem fluxo e bloqueio sem degrau → R25 falhou com os três' $r 0 @('\| R25 \| falhou \| Aprovado por não preenchido; Protótipo sem caminho, data de navegação ou fluxo ponta a ponta; bloqueio 1 sem degrau nomeado')

# 10. C4 (fix.ps1): bloco B-001 com um defeito, um ajuste e uma promovida.

$p = Join-Path $tmp 'fix'; New-Project $p; New-FixBlock $p
$r = Invoke-Check 'fix.ps1' @('-Block', 'B-001', '-Root', $p)
Check 'C4 feliz: exit 0' $r 0 @('R33/4 veredito \| ok', 'R33/1 C1–C8 \| ok', 'R33/2 reprodução \| ok', 'R33/3 antes/depois \| ok', 'R33/5 arquivos \| ok', 'R33/6 teto \| ok', 'R33/7 consumo \| ok', 'R33/8 Task em construção \| ok', 'R33/10 promoção \| ok', 'indicadores')
$r = Invoke-Check 'fix.ps1' @('-Block', 'B-001', '-Pre', '-Root', $p)
Check 'C4 -Pre sem Task em construção: exit 0' $r 0 @('R33/pre-R1 \| ok')
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
$r = Invoke-Check 'fix.ps1' @('-Block', 'B-001', '-Pre', '-Root', $p)
Check 'C4 -Pre com Task em construção: exit 1' $r 1 @('R33/pre-R1 \| falhou.*T-041', 'não começa')

$p = Join-Path $tmp 'fix2'; New-Project $p; New-FixBlock $p
$vt = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/fixes/B-001/verdict.md'), $utf8)
$i = $vt.IndexOf('## QA — F-002'); $vt = $vt.Substring(0, $i) + $vt.Substring($i).Replace('**Antes:** exit 1', '**Antes:** exit 0')
[System.IO.File]::WriteAllText((Join-Path $p '.team-project/fixes/B-001/verdict.md'), $vt, $utf8)
Edit-File (Join-Path $p '.team-project/fixes/F-003.md') '**Critério que caiu:** C5 — muda o contrato da API de exportação' ''
Edit-File (Join-Path $p '.team-project/sprints/1/consumption.md') '| 2026-09-03 | qa | sonnet | `/qa` | T-041 |' '| 2026-09-04 | dev | haiku | `/sm fix run` | B-001 |'
$r = Invoke-Check 'fix.ps1' @('-Block', 'B-001', '-Root', $p)
Check 'C4 teste não falhou antes, promoção sem motivo, consumo fora: exit 1' $r 1 @('R33/3 antes/depois \| falhou.*F-002', 'R33/10 promoção \| falhou.*F-003', 'R33/7 consumo \| aviso', 'Não fecham:.*F-002.*F-003')
if ($r.Out -match 'Não fecham:[^\r\n]*F-001') { $fail++; Write-Output '---- F-001 não deveria estar em Não fecham'; Write-Output $r.Out }

$p = Join-Path $tmp 'fix3'; New-Project $p; New-FixBlock $p
$vt = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/fixes/B-001/verdict.md'), $utf8)
$i = $vt.IndexOf('## QA — F-002')
$vt = $vt.Substring(0, $i).Replace("**Veredito:** $($e.ok)", "**Veredito:** $($e.ok) na 2ª rodada (antes $x)") + $vt.Substring($i).Replace("**Veredito:** $($e.ok)", "**Veredito:** $warn ressalva")
[System.IO.File]::WriteAllText((Join-Path $p '.team-project/fixes/B-001/verdict.md'), $vt, $utf8)
$r = Invoke-Check 'fix.ps1' @('-Block', 'B-001', '-Root', $p)
Check 'C4 ✅ com histórico fecha; ⚠ não fecha' $r 1 @('R33/4 veredito \| falhou.*F-002', 'Não fecham:.*F-002')
if ($r.Out -match 'Não fecham:[^\r\n]*F-001') { $fail++; Write-Output '---- F-001 (✅ com histórico) não deveria estar em Não fecham'; Write-Output $r.Out }

# 9. C3 num repositório-fonte mínimo: versão divergente e bloco acima da barreira.
$rp = Join-Path $tmp 'fonte'
Put $rp '.claude-plugin/plugin.json' '{ "name": "team", "version": "9.1.0" }'
Put $rp 'README.md' "# Plugin`n`n> **Versão atual: v9.1.0** · x`n"
Put $rp 'CHANGELOG.md' "# Changelog`n`n## v9.1.0 — 2026-10-02`n`nx`n"
Put $rp 'roles/scrum-master/process/process-changelog.md' "# Processo`n`n## v9.1 — Teste (SM) — 02/10/2026`n`ncurto`n`n---`n"
Put $rp 'roles/scrum-master/templates/modelo.md' "# modelo`n"
Put $rp 'roles/scrum-master/README.md' "usa templates/modelo.md`n"
Put $rp 'roles/scrum-master/process/artifact-ownership.md' "# Propriedade`n`n## 1. Matriz`n`n| Artefato | Dono | Regra |`n|---|---|---|`n| Planos (``.team-project/sprints/<n>/plan/``) | Arquiteto | x |`n| **Jobs** (``a\|b``) | **SM** · papel chamador | y |`n`n### 1a. Outra`n"
Put $rp 'hooks/ownership.json' '{ "roles": { "architect": "Arquiteto", "operator": "operator" }, "project": [ { "paths": [".team-project/sprints/*/plan/**"], "writers": ["architect"], "matriz": "Planos (`.team-project/sprints/<n>/plan/`)", "dono": "Arquiteto" }, { "paths": [".team-project/operator/**"], "writers": ["operator"], "matriz": "Jobs", "dono": "papel chamador" }, { "paths": [".team-project/**"], "writers": [], "nota": "sem linha" } ], "pluginSource": [] }'
$r = Invoke-Check 'release.ps1' @('-Root', $rp)
Check 'C3 fonte coerente: exit 0' $r 0 @('\| R18 \| ok', '\| R17 \| ok', '\| ownership \| ok.*2 regra', '\| órfãos \| ok')
Edit-File (Join-Path $rp 'hooks/ownership.json') '"dono": "Arquiteto"' '"dono": "QA"'
$r = Invoke-Check 'release.ps1' @('-Root', $rp)
Check 'C3 ownership.json com dono divergente da matriz: exit 1' $r 1 @('\| ownership \| falhou.*dono ''QA''')
Edit-File (Join-Path $rp 'hooks/ownership.json') '"dono": "QA"' '"dono": "Arquiteto"'
Put $rp 'README.md' "# Plugin`n`n> **Versão atual: v9.0.0** · x`n"
Put $rp 'roles/scrum-master/process/process-changelog.md' ("# Processo`n`n## v9.1 — Teste (SM) — 02/10/2026`n`n" + ('x' * 11000) + "`n`n---`n")
Remove-Item -LiteralPath (Join-Path $rp 'roles/scrum-master/README.md')
Put $rp 'hooks/sem-bom.ps1' "# script sem BOM`n"
$r = Invoke-Check 'release.ps1' @('-Root', $rp)
Check 'C3 versão divergente, bloco grande, órfão, .ps1 sem BOM: exit 1' $r 1 @('\| R18 \| falhou.*v9\.0\.0', '\| R17 \| falhou.*barreira 10240', '\| ps1-5.1 \| falhou.*hooks/sem-bom.ps1', '\| órfãos \| aviso')

# 10. v3.47 — models.ps1: modelo por papel (.team-project/models.json).
$p = Join-Path $tmp 'modelos'; New-Project $p
$r = Invoke-Check 'models.ps1' @('-Role', 'developer', '-Root', $p)
Check 'models.ps1 sem arquivo: vazio, exit 0' $r 0 @('^\s*$')
$r = Invoke-Check 'models.ps1' @('-Check', '-Root', $p)
Check 'models.ps1 -Check sem arquivo: exit 0' $r 0 @('models\.json ausente')
Put $p '.team-project/models.json' '{ "_comentario": "x", "developer": "Sonnet", "arc": "opus", "operator": "", "product-owner": "haiku" }'
$r = Invoke-Check 'models.ps1' @('-Role', 'developer', '-Root', $p)
Check 'models.ps1 -Role developer: sonnet (caixa ignorada)' $r 0 @('^\s*sonnet\s*$')
$r = Invoke-Check 'models.ps1' @('-Role', 'dev', '-Root', $p)
Check 'models.ps1 -Role dev (apelido): sonnet' $r 0 @('^\s*sonnet\s*$')
$r = Invoke-Check 'models.ps1' @('-Role', 'architect', '-Root', $p)
Check 'models.ps1 chave por apelido (arc) vale para architect: opus' $r 0 @('^\s*opus\s*$')
$r = Invoke-Check 'models.ps1' @('-Role', 'operator', '-Root', $p)
Check 'models.ps1 chave vazia = não configurado' $r 0 @('^\s*$')
$r = Invoke-Check 'models.ps1' @('-Role', 'quality-assurance', '-Root', $p)
Check 'models.ps1 papel sem chave: vazio' $r 0 @('^\s*$')
$r = Invoke-Check 'models.ps1' @('-Role', 'po', '-Root', $p)
Check 'models.ps1 -Role po (apelido): haiku' $r 0 @('^\s*haiku\s*$')
$r = Invoke-Check 'models.ps1' @('-Role', 'cozinheiro', '-Root', $p)
Check 'models.ps1 papel desconhecido: exit 2' $r 2 @('papel desconhecido')
$r = Invoke-Check 'models.ps1' @('-Check', '-Root', $p)
Check 'models.ps1 -Check arquivo bom: exit 0' $r 0 @('models\.json ok: 3 papel')
$r = Invoke-Check 'models.ps1' @('-Root', $p)
Check 'models.ps1 tabela: efetivo e origem de cada papel' $r 0 @('\| developer \| sonnet \| models\.json', '\| architect \| opus \| models\.json', '\| operator \| haiku \| agents/operator\.md', '\| scrum-master \| sonnet \| agents/scrum-master\.md')
Put $p '.team-project/models.json' '{ "developer": "gpt-9", "cozinheiro": "opus", "scrum-master": "opus" }'
$r = Invoke-Check 'models.ps1' @('-Check', '-Root', $p)
Check 'models.ps1 -Check valor e papel inválidos: exit 1' $r 1 @('ignorado: developer: modelo ''gpt-9''', 'ignorado: papel desconhecido ''cozinheiro''', 'models\.json ok: 1 papel')
Put $p '.team-project/models.json' '{ "executor": "architect", "developer": "sonnet" }'
$r = Invoke-Check 'models.ps1' @('-Check', '-Root', $p)
Check 'models.ps1 -Check com perfil executor: exit 0' $r 0 @('models\.json ok: 1 papel.*perfil executor: architect')
$r = Invoke-Check 'models.ps1' @('-Root', $p)
Check 'models.ps1 tabela mostra o perfil executor ligado' $r 0 @('Perfil executor: LIGADO', '\| developer \| sonnet \| models\.json')
$r = Invoke-Check 'models.ps1' @('-Role', 'executor', '-Root', $p)
Check 'models.ps1 -Role executor não é papel: exit 2' $r 2 @('papel desconhecido')
Put $p '.team-project/models.json' '{ "executor": "developer" }'
$r = Invoke-Check 'models.ps1' @('-Check', '-Root', $p)
Check 'models.ps1 -Check executor inválido: exit 1' $r 1 @('ignorado: executor: valor ''developer''')
$r = Invoke-Check 'models.ps1' @('-Root', $p)
Check 'models.ps1 tabela com executor inválido: perfil desligado' $r 0 @('Perfil executor: desligado')
Put $p '.team-project/models.json' '{ nao-e-json'
$r = Invoke-Check 'models.ps1' @('-Check', '-Root', $p)
Check 'models.ps1 -Check JSON ilegível: exit 1' $r 1 @('ilegível')
$r = Invoke-Check 'models.ps1' @('-Role', 'developer', '-Root', $p)
Check 'models.ps1 JSON ilegível: -Role cai no padrão (vazio), exit 0' $r 0 @('^\s*$')

# 11. v3.51.4 — relato do SunScape (note.md) e do garden (plugin-report-garden.md).
# 11a. Parser do quadro (garden 12, 13, 20): tabelas depois da última História, Habilitadora, Task retirada; "Sprint corrente"
# sem negrito (garden 3).
$p = Join-Path $tmp 'parser'; New-Project $p
$sbp = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'
Edit-File $sbp '## Entradas fora da Planning' ("## Habilitadora — ambiente`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários | Critério de pronto |`n|---|---|---|---|---|---|---|---|---|`n| $($e.todo) T-050 | Scaffold | 1 | dev | — | ``plan/`` | — | nenhum aplicável — infraestrutura | build |`n| $($e.todo) ~~T-051~~ retirada | x | 1 | dev | — | — | — | — | — |`n`n## Rastreabilidade Task ↔ História`n`n| ID | História | Trilha |`n|---|---|---|`n| T-041 | H-014 | plena |`n| T-041a | H-014 | plena |`n| T-050 | — | plena |`n`n## Entradas fora da Planning")
Edit-File (Join-Path $p '.team-project/README.md') '| **Sprint corrente** | **1** —' '| **Sprint corrente** | sprint **1** —'
Put $p '.team-project/sprints/1/kanban.md' ("# Kanban — Sprint 1`n`n## Kanban`n`n| x |`n|---|`n`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/burndown.md'), $utf8).Replace('# Burndown — Sprint 1', ''))
Remove-Item -LiteralPath (Join-Path $p '.team-project/sprints/1/burndown.md') -Force
$r = Invoke-Check 'kanban.ps1' @('-Root', $p)
Check 'kanban: só as Tasks do quadro (3), sem as linhas da rastreabilidade nem a retirada; "sprint **1**" aceito' $r 0 @('· 3 Task\(s\)')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-050', '-Root', $p)
Check 'C1 Task sob ## Habilitadora: não herda a História de cima; R20 falhou (Task sem História)' $r 1 @('\| R20 \| falhou.*Habilitadora.*R20')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'run next: plano da História H-014 lista só T-041a, sem IDs repetidos (garden 13)' $r 0 @('Implementação de T-041a \(História H-014\)')

# 11b. kanban.ps1 -Init cria o consumption.md do sprint; rodadas rateadas entre as Tasks citadas, fase pelo marcador, pausa e
# espera de comando (garden 1, 8, 9; note.md 12 e 13).
# v3.60.0: a Série e o Registro de transições já moram no consumption.md deste projeto (as regravações acima os levaram) — o
# teste do -Init tira o arquivo do caminho e o devolve depois, em vez de apagar o histórico.
$consP = Join-Path $p '.team-project/sprints/1/consumption.md'
Move-Item -LiteralPath $consP -Destination "$consP.bak" -Force
$r = Invoke-Check 'kanban.ps1' @('-Init', '-Root', $p)
Check 'kanban -Init: cria o consumption.md do sprint' @{ Code = $r.Code; Out = $r.Out + "`nCONS=" + $(if (Test-Path -LiteralPath $consP) { 'ok' } else { 'ausente' }) } 0 @('consumption\.md criado', 'CONS=ok')
Move-Item -LiteralPath "$consP.bak" -Destination $consP -Force
Put $p '.team-project/usage.jsonl' ('{"role":"architect","work":"T-041","works":["T-041","T-041a"],"model":"claude-opus-5-5","start":"2026-09-01T11:00:00","duration_s":600,"paused_s":0,"processed":1000000,"dest":".team-project/sprints/1/consumption.md"}' + "`n" + '{"role":"quality-assurance","work":"T-041","model":"claude-sonnet-5-5","start":"2026-09-01T12:00:00","duration_s":120,"paused_s":0,"processed":10000,"dest":".team-project/sprints/1/consumption.md"}' + "`n" + '{"role":"developer","work":"T-041","model":"claude-haiku-5-5","start":"2026-09-02T10:00:00","duration_s":300,"paused_s":9000,"processed":50000,"dest":".team-project/sprints/1/consumption.md"}' + "`n")
Put $p '.team-project/verify/1/T-041/time.jsonl' ('{"at":"2026-09-02T10:01:00","mode":"full","seconds":480}' + "`n" + '{"at":"2026-09-02T10:20:00","mode":"mutation","seconds":300}' + "`n")
$r = Invoke-Check 'kanban.ps1' @('-Root', $p)
$kbt = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/kanban.md'), $utf8)
Check 'kanban: plano por História rateado (500 mil em cada), QA antes da construção conta no Plano, pausa e espera de comando (v3.60.0: no consumption.md)' @{ Code = $r.Code; Out = $kbt + "`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/consumption.md'), $utf8) } 0 @('\| T-041 \| 510\.000 · 07:00 \| 50\.000 · 05:00 \| — \| — \| 560\.000 · 12:00 \| 150:00 \|', '\| T-041a \| 500\.000 · 05:00 \|', '(?m)^## Espera de comando', '\| T-041 \| 2 \| — \| 08:00 \| 05:00 \| \*\*13:00\*\* \|')

# 11c. run.ps1 done (garden 19, 22): confere antes; fechando, passa por 🟪 e o -Post fica ok; GAP volta a 🟨.
$p = Join-Path $tmp 'done'; New-Project $p
Remove-Item -LiteralPath (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') -Force
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
Edit-File (Join-Path $p '.team-project/sprints/1/burndown.md') "| T-041 | $($e.build) → $($e.qa) | 2026-09-03 15:00 | QA |" ''
Remove-Line (Join-Path $p '.team-project/sprints/1/burndown.md') "| 2 | 2026-09-03 15:00 | T-041 $($e.build) → $($e.qa) | 2 | 2 |"
Put $p '.team-project/sprints/1/delivery/T-041.md' ("## Entrega — T-041`n`n### Verificação`n```````nverify full T-041 · árvore abc · tudo exit 0`n  build: exit 0`n```````n`n### Documentos vivos (R12)`n**Estado:** a consolidar`n")
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R7 do dev com a saída do verify sem a linha "> comando" no topo: ok (garden 17)' $r 0 @('\| R7 \| ok.*evidência do dev')
Put $p '.team-project/sprints/1/delivery/T-041.md' ("## Entrega — T-041`n`n### Verificação`nrodei e passou`n`n### Documentos vivos (R12)`n**Estado:** a consolidar`n")
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'ok', '-Root', $p)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 (Join-Path $p '.team-project/sprints/1/sprint-backlog.md'))
Check 'run done sem evidência: não fecha, não marca 🟪, volta ao dev' $r 0 @('ainda não fecha', 'R7 \| falhou', "\| $($e.build) T-041 \|")
# v3.57.2 (note.md item 22): o que falta vai ao cartão do dev novo com a ordem de só completar a evidência, e a rota ao run-log.
$hc = Join-Path $p '.team-project/sprints/1/handoff/T-041.md'; $rlg = Join-Path $p '.team-project/sprints/1/run-log.md'
Check 'v3.57.2 item 22: done reprovado por evidência → cartão com "Só completar a evidência" (sem mudar código), arquivo do que falta e a rota no run-log' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText($hc, $utf8) + "`n" + [System.IO.File]::ReadAllText($rlg, $utf8) + "`nEVF=" + (Test-Path -LiteralPath (Join-Path $p '.team-project/sprints/1/handoff/T-041-evidencia.md')) } 0 @('falta EVIDÊNCIA, não código', 'dev em instância NOVA só para a evidência', '\*\*Só completar a evidência\*\* \(o done reprovou: rode os comandos de prova que faltam.*R7 \| falhou', 'evidência incompleta → dev em instância nova SÓ para completar a evidência', 'EVF=True', '^(?![\s\S]*não mude código)')
Put $p '.team-project/sprints/1/delivery/T-041.md' ("## Entrega — T-041`n`n### Verificação`n```````n> verify.ps1 -Mode full`nverify full T-041 · tudo exit 0`n```````n`n### Documentos vivos (R12)`n**Estado:** a consolidar`n")
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'ok', '-Root', $p)
Check 'run done ok: 🟨 → 🟪 pelo mark, depois -Apply com -Post R24 ok (garden 19)' $r 0 @("mark: T-041 $($e.build) → $($e.qa)", 'fechada pela evidência do dev', 'PONTO SEGURO')
Check 'v3.57.2 item 22: a Task fechada apaga o arquivo do que faltava na evidência' @{ Code = 0; Out = "EVF=" + (Test-Path -LiteralPath (Join-Path $p '.team-project/sprints/1/handoff/T-041-evidencia.md')) } 0 @('EVF=False')
# v3.52: Task fechada grava .safe-point (a G20 libera o fim de turno) e diz o commit; sem git, o checkpoint é por cópia.
$sp = Join-Path $p '.team-project/.safe-point'
Check 'run done ok: grava .safe-point e informa o commit (v3.52)' @{ Code = $r.Code; Out = $r.Out + "`nSP=" + $(if (Test-Path -LiteralPath $sp) { (Get-Content -LiteralPath $sp -Raw -Encoding UTF8) } else { 'ausente' }) } 0 @('  commit: ', 'SP=\{"task":"T-041","sprint":"1"')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'run next depois do ponto seguro: RETOMADA pelo marcador e o marcador sai (v3.52)' @{ Code = $r.Code; Out = $r.Out + "`nSP=" + $(if (Test-Path -LiteralPath $sp) { 'presente' } else { 'apagado' }) } $r.Code @('RETOMADA: ponto seguro depois da T-041', 'SP=apagado')
$p = Join-Path $tmp 'gap'; New-Project $p
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Nature', 'desenho', '-Root', $p)
Check 'run done gap com a Task em 🟪: volta a 🟨 (garden 22)' $r 0 @("mark: T-041 $($e.qa) → $($e.build)", 'GAP')
# v3.57.0 (item 9): a natureza que o dev marcou no GAP decide quem responde.
$dgp = Join-Path $p '.team-project/sprints/1/delivery/T-041.md'
function Put-Gap([string]$Nat) { Put $p '.team-project/sprints/1/delivery/T-041.md' ("## Entrega — T-041`n`n🔺 GAP — T-041 — passo 2 do plano`n`n**Tipo:** plano`n" + $(if ($Nat) { "**Natureza:** $Nat`n" } else { '' }) + "**O que encontrei no código:** a.ts:3 — x`n") }
Put-Gap 'aparência'
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $p)
Check 'v3.57.0 item 9 (v3.63.0: causa appearance, com o nome antigo como sinônimo): GAP de aparência → parecer curto do Arquiteto (prompt com PARECER CURTO, até 8 linhas)' $r 0 @('GAP de causa APPEARANCE — parecer curto do Arquiteto', 'prompt: "PARECER CURTO \(GAP de aparência ou marcação\)', 'em até 8 linhas', 'Arquiteto em instância NOVA')
Put-Gap 'produto'
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $p)
Check 'v3.63.0 (antes v3.57.0 item 9): GAP produto (sinônimo de requirement) → o PO decide, e o que for do stakeholder ele devolve em STAKEHOLDER: — não vai direto ao formulário nem ao ciclo do Arquiteto' $r 0 @('GAP de causa REQUISITO — quem decide é o PO', 'team:product-owner', 'STAKEHOLDER: <a pergunta e as opções>', 'depois: Arquiteto em instância NOVA, PARECER CURTO', '^(?![\s\S]*prompt: "Decida o 🔺 GAP)')
Put-Gap 'desenho'
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $p)
Check 'v3.57.0 item 9: GAP natureza desenho → ciclo completo do Arquiteto, sem parecer curto' $r 0 @('Arquiteto em instância NOVA', 'prompt: "Decida o 🔺 GAP da T-041', '^(?![\s\S]*PARECER CURTO)')
$gcf = Join-Path $p '.team-project/sprints/1/handoff/T-041-gap.md'
Check 'v3.57.2 item 23: o Arquiteto decide pelo recorte (o GAP, o cabeçalho e os passos citados) e muda o plano por delta (Edit)' @{ Code = $r.Code; Out = $r.Out + "`n" + $(if (Test-Path -LiteralPath $gcf) { [System.IO.File]::ReadAllText($gcf, $utf8) } else { 'sem recorte' }) } 0 @('pelo RECORTE \.team-project/sprints/1/handoff/T-041-gap\.md', 'Abra o plano inteiro .* só se o recorte não bastar', 'com o Edit, no lugar do texto que ela derruba', '## O GAP \(relatório do dev\)', '🔺 GAP — T-041 — passo 2 do plano', '## Cabeçalho do plano')
Put-Gap ''
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $p)
Check 'v3.57.1 item 6 (v3.63.0: -Cause): GAP sem causa (nem **Cause:** nem a palavra na linha do 🔺) → recusa antes de qualquer efeito (exit 2) e o executor classifica com -Cause' $r 2 @('veio sem causa', 'done -Task T-041 -Result gap -Cause <appearance \| design \| scenario \| screen \| requirement \| process \| environment>', 'process = regra do time', '^(?![\s\S]*Arquiteto em instância NOVA)')
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Nature', 'aparencia', '-Root', $p)
Check 'v3.57.1 item 6: -Nature do executor vale quando o dev não marcou (aparência → parecer curto) e o run-log grava a natureza e quem a deu' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/run-log.md'), $utf8) } 0 @('GAP de causa APPEARANCE', '🔺 GAP \[appearance · executor \(-Cause\)\]')
Put $p '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041`n`n### 🔺 GAP (ambiente / massa): a massa base não tem lote COLHIDO`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $p)
Check 'v3.57.1 item 6: a palavra na linha do 🔺 ("🔺 GAP (ambiente / massa)", como os devs do garden escreviam) vale como natureza' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/run-log.md'), $utf8) } 0 @('GAP de causa ENVIRONMENT \(linha do 🔺\)', '🔺 GAP \[environment · linha do 🔺\]')
# v3.63.0: **Cause:** screen vai ao UX (a especificação da tela ganha o caso), scenario ao QA (corrige o .scn, sem Arquiteto).
Put $p '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041`n`n🔺 GAP — T-041 — passo 2 do plano`n`n**Cause:** screen`n**O que encontrei no código:** a.ts:3 — o título não cabe na fonte grande`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $p)
Check 'v3.63.0: GAP de causa screen → o UX acrescenta o caso na especificação da tela; o Arquiteto só registra (parecer curto)' $r 0 @('GAP de causa TELA — quem decide é o UX', 'team:user-experience', 'acrescente na especificação da tela o caso que faltou', 'depois: Arquiteto em instância NOVA, PARECER CURTO')
Put $p '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041`n`n🔺 GAP — T-041 — passo 2 do plano`n`n**Cause:** scenario`n**O que encontrei no código:** SC-014 usa um id que não existe mais`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $p)
Check 'v3.63.0: GAP de causa scenario → o QA corrige o .scn e o dev volta, sem o Arquiteto' $r 0 @('GAP de causa CENÁRIO — quem decide é o QA', 'team:quality-assurance', 'corrija o \.scn', 'depois: dev em instância NOVA — run.ps1 start -Task T-041', '^(?![\s\S]*PARECER CURTO)')

# 11d. run.ps1 next com o sinal de limite de uso e a estimativa do que falta (note.md 2 e 11).
$p = Join-Path $tmp 'limite'; New-Project $p
Put $p '.team-project/.usage-limit' '{"desde":"2026-10-22 16:29:00","reset":"11:50pm","quem":"developer","item":"T-041","texto":"You have hit your session limit"}'
Put $p '.team-project/usage.jsonl' ('{"role":"developer","work":"T-041","model":"claude-haiku-5-5","start":"2026-09-02T10:00:00","duration_s":600,"processed":2000000,"dest":".team-project/sprints/1/consumption.md"}' + "`n")
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.ok) T-041 |"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'run next: diz que parou por limite de conta, apaga o sinal e estima o que falta' @{ Code = $r.Code; Out = $r.Out + "`nSINAL=" + $(if (Test-Path -LiteralPath (Join-Path $p '.team-project/.usage-limit')) { 'presente' } else { 'apagado' }) } 0 @('LIMITE DE USO DA CONTA em 2026-10-22 16:29:00 \(reset: 11:50pm\)', 'CONSUMO DO SPRINT.*2,0 mi tokens · 10 min.*as 1 aberta\(s\) ≈ 2,0 mi', 'SINAL=apagado')

# 11e. close.ps1 R28: medição de outra Task da mesma História reaproveitada no plano não reprova esta (garden 21).
$p = Join-Path $tmp 'r28'; New-Project $p
Put $p '.team-project/operator/1/T-040-amb/report.md' "# medição`n"
Edit-File (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') '**Relatório do `operator`:** `.team-project/operator/1/job1/report.md`' '**Relatório do `operator`:** `.team-project/operator/1/T-040-amb/report.md`'
Edit-File (Join-Path $p '.team-project/sprints/1/consumption.md') '| 2026-09-03 | operator | haiku | `/qa` | T-041 | verificação | H-014 | 500 | 00:30 | chamado por qa |' ''
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R28 com a medição de outra Task reaproveitada: ok' $r 0 @('\| R28 \| ok.*1 medição\(ões\) de outra Task/História reaproveitada')

# 11f. plan.ps1: §3/§9 cobradas no plano (garden 16), trecho duplicado no arquivo existente (garden 27), cenários sem .scn e sem alvo.
$p = Join-Path $tmp 'plano2'; New-Project $p
Put $p 'src/a.ts' "export const a = () => { return 1 }`nexport const b = () => { return 1 }`n"
$pl = '.team-project/sprints/1/plan/T-060-x.md'
Put $p $pl ("# Plano`n**Cenários:** SC-014`n**Risco:** regra de negócio`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 3. Ambiente`nNode 20 medido.`n`n## 6. Testes`n`n**Mutações:**`n- M1 · teste ``tests/a.spec.ts`` · ``src/a.ts`` · ``return 1`` → ``return 0```n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano com §3 em prosa, sem §9 e trecho duplicado no arquivo: exit 1; cenários sem .scn e sem alvo: n-a' $r 1 @('\| ambiente \| falhou.*§3 sem a tabela.*§9 sem', '\| mutação \| falhou.*aparece 2 vezes em src/a\.ts', '\| cenários \| n-a.*sem alvo')

# 11g. verify.ps1: full parcial retomável (garden 18), daemon só durante a chamada (note.md 14), -Precheck (garden 27), time.jsonl.
$p = Join-Path $tmp 'verify2'; New-Project $p
$ErrorActionPreference = 'Continue'
& git -C $p init -q 2>$null; Put $p '.gitignore' ".team-project/`n"
Put $p 'src/calc.ts' "export function soma(a, b) {`n  return a + b; // fim`n}`n"
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output ''Build succeeded''", "suite": "Write-Output ''Tests: 3 passed''" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-MaxMinutes', '0', '-Root', $p)
Check 'verify full -MaxMinutes 0: roda o build, deixa a suíte pendente, exit 3' $r 3 @('PARCIAL: 1 comando', 'pendente\(s\): suite', 'MESMO comando')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'verify full retomado: roda só a suíte e grava o full com os dois' $r 0 @('tudo exit 0', 'build: exit 0', 'suite: exit 0')
$tj = Join-Path $p '.team-project/verify/1/T-041/time.jsonl'
Check 'verify: tempo de comando somado em time.jsonl' @{ Code = $(if ((Test-Path -LiteralPath $tj) -and @(Get-Content -LiteralPath $tj).Count -eq 2) { 0 } else { 1 }); Out = '' } 0 @()
$mark = 'team-daemon-' + [guid]::NewGuid().ToString('N').Substring(0, 6)
Put $p '.team-project/guards.json' ('{ "verify": { "daemon": true, "build": "Start-Process powershell -ArgumentList ''-NoProfile'',''-Command'',''Start-Sleep 120 # ' + $mark + ''' -WindowStyle Hidden; Write-Output ''Build ok''", "suite": "Write-Output (''GO='' + $env:GRADLE_OPTS + '' VIVO='' + @(Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like ''*' + $mark + '*'' }).Count)" } }')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$alive = @(Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like "*$mark*" -and $_.CommandLine -notlike '*Get-CimInstance*' }).Count
$suiteLog = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/verify/1/T-041/full-suite.log'), $utf8)
Check 'verify.daemon: o processo do build sobrevive para o comando seguinte e morre no fim da chamada' @{ Code = $r.Code; Out = $suiteLog + "`nDEPOIS=$alive" } 0 @('GO=.*-Dorg\.gradle\.daemon=true', 'VIVO=[1-9]', 'DEPOIS=0')
Put $p '.team-project/guards.json' '{ "verify": { "focused": "Write-Output ok {tests}", "compile": "powershell -NoProfile -Command \"if ((Get-Content src/calc.ts -Raw) -match ''NAOCOMPILA'') { ''error TS2322''; exit 1 }\"" } }'
$pl = '.team-project/sprints/1/plan/T-041-export.md'
Edit-File (Join-Path $p $pl) '## 3. Ambiente' ("**Arquivos tocados:** ``src/calc.ts```n``tests/check.ps1```n`n**Mutações:**`n- M1 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a - b```n- M2 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``// fim`` → ``// NAOCOMPILA```n- M3 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``zzz`` → ``y```n`n## 3. Ambiente")
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Precheck', '-Root', $p)
Check 'verify mutation -Precheck: M1 pronta, M2 não compila, M3 sem trecho; árvore igual; exit 1' $r 1 @('1 de 3 mutação', 'M2: o mutante não compila', 'M3: o trecho aparece 0 vez')
$ErrorActionPreference = 'Continue'; $st = (& git -C $p status --porcelain 2>$null) -join ' '; $ErrorActionPreference = 'Stop'
Check 'verify -Precheck devolve o arquivo igual' @{ Code = $(if ($st -notmatch 'calc\.ts') { 0 } else { 1 }); Out = $st } 0 @()
# v3.57.0 (item A6): com verify.compile declarado, a mutação roda o Precheck sozinha antes e para cedo com a lista (nada de ~20 min
# até descobrir um mutante que não compila); com um Precheck verde registrado para a árvore, não repete.
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
Check 'v3.57.0 A6: mutação sem -Precheck e com verify.compile → Precheck automático, para cedo no mutante que não compila (exit 1)' $r 1 @('Precheck \(automático, antes da mutação\)', 'M2: o mutante não compila', 'M3: o trecho aparece 0 vez')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Precheck', '-Only', 'M1', '-Root', $p)
$r2 = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Only', 'M1', '-Root', $p)
Check 'v3.57.0 A6: Precheck verde registrado para a árvore → a mutação seguinte não o repete' @{ Code = 0; Out = "pre=$($r.Code) " + $r2.Out + $(if ($r2.Out -match 'automático') { "`nREPETIU" }) } 0 @('pre=0', '^(?![\s\S]*REPETIU)')

# 12. v3.52.2 — note.md itens 2 a 17 (sprint 3 do piloto) e os contratos C1 a C8 da spec.
# 12a. item 8: "targets": {} (o modelo do guards.json) não é alvo configurado.
$p = Join-Path $tmp 'alvo-vazio'; New-Project $p
Put $p '.team-project/guards.json' '{ "targets": {} }'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'item 8: targets {} — o next não pede .scn, vai aos planos' $r 0 @('planos da História H-014')
Put $p '.team-project/sprints/1/plan/T-070-x.md' "# Plano`n**Cenários:** SC-014`n"
$r = Invoke-Check 'plan.ps1' @('-Plan', '.team-project/sprints/1/plan/T-070-x.md', '-Root', $p)
Check 'item 8: targets {} — plan.ps1 cenários n-a (sem alvo)' $r 1 @('\| cenários \| n-a.*sem alvo')

# 12b. item 12: a linha de abertura do Registro com várias Tasks não conta como transição da primeira (reproduzido antes).
$p = Join-Path $tmp 'r24-abertura'; New-Project $p
$bd = Join-Path $p '.team-project/sprints/1/burndown.md'
Edit-File $bd "| T-041 | $($e.todo) → $($e.plan) | 2026-09-01 10:00 | Arquiteto |" ("| T-041, T-041a | — → $($e.todo) | 2026-09-01 | SM (Planning) |`n| T-041 | $($e.todo) → $($e.plan) | 2026-09-01 10:00 | Arquiteto |")
Close-T041 $p
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Post', '-Root', $p)
Check 'item 12: -Post com a abertura multi-Task no Registro e a da Série sem Task: R24 ok (4 transições)' $r 0 @('\| R24 \| ok.*4 transi')

# 12c. itens 9 e 14: start com a Task já em 🟨 (sem -Mark vazio); escalonamento só por falha de papel, queda de ambiente não conta.
$p = Join-Path $tmp 'start'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
Check 'item 9: run start com a Task em 🟨 — dispatch sem -Mark, prompt do dev' $r 0 @('dispatch: developer · T-041', 'prompt do dev', 'model omitido')
$null = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $p)
$null = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Nature', 'desenho', '-Root', $p)
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
Check 'item 14: 1 queda de ambiente + 1 GAP — o dev segue sem escalar' @{ Code = $(if ($r.Code -eq 0 -and $r.Out -notmatch 'sonnet') { 0 } else { 1 }); Out = $r.Out } 0 @()
$null = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Nature', 'desenho', '-Root', $p)
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
$hj = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/handoff/T-041.json'), $utf8)
Check 'item 14: 2 falhas de papel — a 3ª instância com sonnet, a queda de ambiente fora da conta' @{ Code = $r.Code; Out = $r.Out + "`n" + $hj } 0 @('model "sonnet" \(escalonamento: 2 instância\(s\) encerrada\(s\) por falha de papel; 1 queda\(s\) de ambiente não contam\)', '"starts":3,"fail":2,"env":1')

# 12d. item 10: commit pela mensagem em arquivo (aspas, corte no espaço), stage só do escopo do plano.
$p = Join-Path $tmp 'commit'; New-Project $p
$ErrorActionPreference = 'Continue'
& git -C $p init -q 2>$null; & git -C $p config user.email t@t 2>$null; & git -C $p config user.name t 2>$null
Put $p '.gitignore' ".team-project/`n"; Put $p 'src/a.ts' "a`n"; Put $p 'other.txt' "x`n"
& git -C $p add -A 2>$null; & git -C $p commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
$sbp = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'
Edit-File $sbp "| $($e.qa) T-041 | Endpoint de exportação |" "| $($e.build) T-041 | Endpoint ""exportar"" com aspas e um título comprido o bastante para passar do limite |"
Edit-File (Join-Path $p '.team-project/sprints/1/burndown.md') "| T-041 | $($e.build) → $($e.qa) | 2026-09-03 15:00 | QA |" ''
Remove-Line (Join-Path $p '.team-project/sprints/1/burndown.md') "| 2 | 2026-09-03 15:00 | T-041 $($e.build) → $($e.qa) | 2 | 2 |"
Remove-Item -LiteralPath (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') -Force
Put $p '.team-project/sprints/1/delivery/T-041.md' ("## Entrega — T-041`n`n### Verificação`n```````n> verify.ps1 -Mode full`nverify full T-041 · tudo exit 0`n```````n`n### Documentos vivos (R12)`n**Estado:** a consolidar`n")
Edit-File (Join-Path $p '.team-project/sprints/1/plan/T-041-export.md') '## 3. Ambiente medido' "**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n## 3. Ambiente medido"
Put $p 'src/a.ts' "b`n"; Put $p 'tests/a.spec.ts' "t`n"; Put $p 'other.txt' "y`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'ok', '-Root', $p)
$ErrorActionPreference = 'Continue'
$msgF = Join-Path $p 'msg.out'; & git -C $p log -1 --format=%B "--output=$msgF" 2>$null   # o console do 5.1 não decodifica o "…" em UTF-8
$msgL = @([System.IO.File]::ReadAllLines($msgF, $utf8)); Remove-Item -LiteralPath $msgF -Force
$subj = $msgL[0]; $bodyC = ($msgL | Select-Object -Skip 1) -join ' '
$files = @(& git -C $p show --name-only --format= HEAD 2>$null | Where-Object { $_ }) -join ','; $stc = (& git -C $p status --porcelain 2>$null) -join ' '
$ErrorActionPreference = 'Stop'
$okC = ($subj.Length -le 72) -and $subj.EndsWith('…') -and $subj.StartsWith('T-041: Endpoint "exportar"') -and ($bodyC -match 'passar do limite') -and ($files -eq 'src/a.ts,tests/a.spec.ts') -and ($stc -match 'other\.txt')
Check 'item 10: commit -F com aspas e assunto cortado no espaço; só o escopo do plano; pendente de fora citado' @{ Code = $(if ($okC) { 0 } else { 1 }); Out = $r.Out + "`nSUBJ=$subj`nBODY=$bodyC`nFILES=$files`nST=$stc" } 0 @('commit: [0-9a-f]{7,} T-041: ', 'fora do escopo, ficou fora do commit: other\.txt', 'Devolva a linha à sessão: "T-041 ✅ fechada · commit [0-9a-f]{7,} · 1 rodadas"')

# 12e. item 13: o documento de desenho (docs/) fica fora da impressão da árvore; o código continua dentro.
$p = Join-Path $tmp 'arvore'; New-Project $p
$ErrorActionPreference = 'Continue'
& git -C $p init -q 2>$null; Put $p '.gitignore' ".team-project/`n"
Put $p 'src/calc.ts' "export function soma(a, b) {`n  return a + b; // fim`n}`n"; Put $p 'docs/sdd/03-architecture.md' "# SDD`n"
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $p '.team-project/guards.json' '{ "verify": { "focused": "Write-Output ''Tests: 1 passed'' {tests}", "suite": "Write-Output ''Tests: 3 passed''" } }'
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Put $p 'docs/sdd/03-architecture.md' "# SDD`natualizado depois do full`n"; Put $p 'docs/sdd/04-novo.md' "# novo`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'check', '-Root', $p)
Check 'item 13: SDD editado depois do full não muda a árvore (verify check IGUAL)' $r 0 @('IGUAL')
Put $p 'src/calc.ts' "export function soma(a, b) {`n  return a + b + 0; // fim`n}`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'check', '-Root', $p)
Check 'item 13: código mudado depois do full continua mudando a árvore' $r 1 @('DIFERENTE')
# item 7: o mesmo leitor no verify — linha em branco no meio do bloco **Mutações:** não o encerra.
Edit-File (Join-Path $p '.team-project/sprints/1/plan/T-041-export.md') '## 3. Ambiente' ("**Arquivos tocados:** ``src/calc.ts```n``tests/check.ps1```n`n**Mutações:**`n- M1 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``a + b + 0`` → ``a - b```n`n- M2 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``// fim`` → ``// x```n`n**Cobertura:** n/a`n`n## 3. Ambiente")
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', '.team-project/sprints/1/plan/T-041-export.md', '-Precheck', '-Root', $p)
Check 'item 7: verify lê as 2 mutações separadas por linha em branco' $r 0 @('2 de 2 mutação')

# 12f. C4 (item 5) e item 7 no plan.ps1: contagem recontada, premissas, documento de desenho, um leitor das mutações.
$p = Join-Path $tmp 'plano3'; New-Project $p
Put $p 'src/a.ts' "foo()`nfoo()`nbar`nqux`n"; Put $p 'src/b.ts' "foo`n"; Put $p 'docs/x.md' "foo`n"
$pl = '.team-project/sprints/1/plan/T-080-x.md'
$planHead = "# Plano`n**Cenários:** nenhum — interno`n**Risco:** regra de negócio`n**Layout novo:** sim`n**Envelope de medidas:** nenhum — fixture (regra 33, v3.57.1)`n`n"
$planEnv = "**Arquivos protegidos:** nenhum`n`n## 3. Ambiente`n| Pré-requisito | Comando | Saída real | Log | Atende? |`n|---|---|---|---|---|`n| Node | node -v | v20 | — | sim |`n`n## 6. Testes`n`n**Mutações:**`n- M1 · teste ``tests/a.spec.ts`` · ``src/a.ts`` · ``bar`` → ``baz```n`n- M2 · teste ``tests/a.spec.ts`` · ``src/a.ts`` · ``qux`` → ``quux```n`n"
Put $p $pl ($planHead + "**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n" + $planEnv + "**Cobertura:** x`n- M3 · teste ``tests/a.spec.ts`` · ``src/a.ts`` · ``zz`` → ``yy```n`n### Premissas`n- Contagem: ``foo`` em ``src/*.ts`` → 3`n- Contagem: ``foo`` em ``src/a.ts;docs/*.md`` → 5`n- P1 · src tem dois arquivos · medido: ``ls src`` → 2`n- P2 · o render é estável`nIsto está não validado.`n`n## 9. Onde parar`n- Pré-requisito ausente`n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'C4: contagem errada, premissa sem medição, "não validado" solto, layout sem Documentos vivos, mutação fora do bloco: exit 1' $r 1 @('\| mutação \| falhou.*M3 fora do bloco', '\| contagem \| falhou.*o plano diz 5, a recontagem dá 3', '\| premissa \| falhou.*P2 · o render.*não validado', '\| desenho \| falhou.*sem a linha \*\*Documentos vivos:')
Put $p $pl ($planHead + "**Documentos vivos:** ``docs/sdd/03-architecture.md`` §4 — tela de exportação`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n" + $planEnv + "### Premissas`n- Contagem: ``foo`` em ``src/*.ts`` → 3`n- Contagem: ``foo`` em ``src/a.ts;docs/*.md`` → 3`n- P1 · src tem dois arquivos · medido: ``ls src`` → 2`n- P2 · o render é estável · não exercitada: sem navegador no plano · verifica: dev em verify full`n`n## 9. Onde parar`n- Pré-requisito ausente`n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'C4: contagens iguais, premissas medidas ou com quem verifica, Documentos vivos com o SDD; 2 mutações com linha em branco entre elas' $r 0 @('\| mutação \| ok.*2 mutação', '\| contagem \| ok.*2 contagem', '\| premissa \| ok.*2 premissa\(s\): 1 medida', '\| desenho \| ok.*Documentos vivos: docs/sdd/03')
Put $p $pl ($planHead + "**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n``docs/sdd/03-architecture.md```n`n" + $planEnv + "### Premissas`n- P1 · o render é estável · não exercitada: sem navegador · verifica: dev em verify full`n`n## 9. Onde parar`n- Pré-requisito ausente`n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'C4: layout novo sem premissa medida; SDD em Arquivos tocados (o dev não edita o SDD): falhou' $r 1 @('\| premissa \| falhou.*Layout novo:\*\* sim sem nenhuma premissa medido', '\| desenho \| falhou.*o dev não edita o SDD')

# 12g. C2 (item 3): .interrupted vira RETOMADA com o "Parei no passo"; item 17: SESSÃO medida pelo transcript.
$p = Join-Path $tmp 'queda'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
Put $p '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041`n`n### Parei no passo`npasso 3 de 5 — testes do exportador`n"
Put $p '.team-project/.interrupted' '[{"type":"team:task-runner","work":"T-041","parent":"","desde":"2026-10-26 10:00:00","last":"Edit src/a.ts","at":"10:42","session":"s1"},{"type":"team:developer","work":"T-041","parent":"abc","desde":"2026-10-26 10:05:00","last":"verify.ps1","at":"10:41","session":"s1"}]'
$tr = (Join-Path $p 'transcript.jsonl') -replace '\\', '/'
Put $p 'transcript.jsonl' ('{"type":"assistant","uuid":"u1","message":{"model":"claude-opus-5-5","id":"msg_1","type":"message","usage":{"input_tokens":10,"cache_creation_input_tokens":100,"cache_read_input_tokens":1000,"output_tokens":5}}}' + "`n" + '{"type":"assistant","uuid":"u2","message":{"model":"claude-opus-5-5","id":"msg_1","type":"message","usage":{"input_tokens":10,"cache_creation_input_tokens":100,"cache_read_input_tokens":1000,"output_tokens":9}}}' + "`n" + '{"type":"assistant","uuid":"u3","message":{"model":"<synthetic>","id":"msg_9","type":"message","usage":{"input_tokens":0,"cache_creation_input_tokens":0,"cache_read_input_tokens":0,"output_tokens":0}}}' + "`n" + '{"type":"assistant","uuid":"u4","message":{"model":"claude-opus-5-5","id":"msg_2","type":"message","usage":{"input_tokens":5,"cache_creation_input_tokens":20000,"cache_read_input_tokens":150000,"output_tokens":50}}}' + "`n")
Put $p '.team-project/usage.jsonl' ('{"role":"developer","work":"T-041","model":"claude-haiku-5-5","start":"2026-09-02T10:00:00","duration_s":60,"processed":1000,"dest":".team-project/sprints/1/consumption.md","session_transcript":"' + $tr + '"}' + "`n")
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'C2: .interrupted — RETOMADA por Task com os tipos, a última ação e o Parei no passo; o arquivo sai' @{ Code = $r.Code; Out = $r.Out + "`nINT=" + $(if (Test-Path -LiteralPath (Join-Path $p '.team-project/.interrupted')) { 'presente' } else { 'apagado' }) } 0 @('RETOMADA: a sessão anterior caiu com T-041 em andamento \(team:task-runner, team:developer\), última ação Edit src/a\.ts às 10:42 · parei no passo: passo 3 de 5', 'INT=apagado')
Check 'item 17: SESSÃO com chamadas por message.id (sem <synthetic>) e o contexto da última; aviso acima de 150 mil' $r 0 @('SESSÃO: 2 chamada\(s\) · contexto da última 170 mil tokens', 'aviso: acima de 150 mil')
# v3.57.2 (note.md item 21): acima do teto e sem agente em voo, a próxima ação é reiniciar a sessão (o veredito libera a G20); teto 0 desliga.
Check 'v3.57.2 item 21: sessão acima do teto (150 mil) sem agente em voo → PRÓXIMA AÇÃO: reiniciar a sessão (/clear e /sm sprint run) e o veredito "reiniciar"' @{ Code = $r.Code; Out = $r.Out + "`nNV=" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/.next-verdict')) } 0 @('PRÓXIMA AÇÃO: reiniciar a sessão — contexto da última chamada 170 mil', '/clear e depois /sm sprint run', 'NV=.*"acao":"reiniciar"')
Put $p '.team-project/guards.json' '{ "run": { "sessionContextCap": 0 } }'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.57.2 item 21: run.sessionContextCap 0 desliga o reinício (o aviso fica)' $r $r.Code @('aviso: acima de 150 mil', '^(?![\s\S]*reiniciar a sessão)')
Remove-Item -LiteralPath (Join-Path $p '.team-project/guards.json') -Force -ErrorAction SilentlyContinue
# v3.57.4: depois do /clear o usage.jsonl ainda cita a sessão antiga (170 mil); a SESSÃO mede a corrente (.session-transcript).
$trN = (Join-Path $p 'nova.jsonl') -replace '\\', '/'
Put $p 'nova.jsonl' ('{"type":"assistant","uuid":"n1","message":{"model":"claude-opus-5-5","id":"msg_n1","type":"message","usage":{"input_tokens":5,"cache_creation_input_tokens":30000,"cache_read_input_tokens":20000,"output_tokens":50}}}' + "`n")
Put $p '.team-project/.session-transcript' $trN
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.57.4: sessão nova pelo .session-transcript (50 mil) — usage.jsonl antigo acima do teto não manda reiniciar' $r $r.Code @('SESSÃO: 1 chamada\(s\) · contexto da última 50 mil tokens', '^(?![\s\S]*reiniciar a sessão)', '^(?![\s\S]*170 mil)')
Put $p '.team-project/.session-transcript' ((Join-Path $p 'ainda-nao-existe.jsonl') -replace '\\', '/')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.57.4: transcript da sessão nova ainda sem arquivo — SESSÃO cala, sem cair no usage.jsonl antigo' $r $r.Code @('^(?![\s\S]*SESSÃO:)', '^(?![\s\S]*reiniciar a sessão)')
Remove-Item -LiteralPath (Join-Path $p '.team-project/.session-transcript') -Force -ErrorAction SilentlyContinue

# 12h. C5 (item 15) e C6 (item 11): veredito da última rodada, aceite com dívida do PO e a correção do portão como Q-S<n>.
$p = Join-Path $tmp 'portao'; New-Project $p
$sbp = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'
Edit-File $sbp "| $($e.qa) T-041 |" "| $($e.ok) T-041 |"; Edit-File $sbp "| $($e.todo) T-041a |" "| $($e.ok) T-041a |"
$qrj = Join-Path $p '.team-project/quality/1/S1/result.json'; Put $p '.team-project/quality/1/S1/result.json' '{"tree":null}'
$valp = Join-Path $p '.team-project/sprints/1/validation.md'
$setTimes = { param($valNewer) $now = Get-Date; (Get-Item -LiteralPath $qrj).LastWriteTime = $(if ($valNewer) { $now.AddHours(-1) } else { $now }); (Get-Item -LiteralPath $valp).LastWriteTime = $(if ($valNewer) { $now } else { $now.AddHours(-1) }) }
$warn = [char]::ConvertFromUtf32(0x26A0) + [char]0xFE0F; $failMk = [char]::ConvertFromUtf32(0x274C)
Put $p '.team-project/sprints/1/validation.md' "# Validação`n`n**Veredito:** $warn aprovado com ressalva — 2026-09-05`n"; & $setTimes $true
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'C5: veredito ⚠️ sem decisão do PO — abrir Q-S1 (seção Correção do portão) e a via do aceite com dívida' $r 0 @('abrir Q-S1 — correção do portão', '## Correção do portão — sprint 1', 'Decisão do PO:\*\* aceito com dívida')
[System.IO.File]::AppendAllText($valp, "`n**Veredito (rodada 2):** $($e.ok) aprovado — 2026-09-06`n", $utf8); & $setTimes $true
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'C6: **Veredito (rodada 2):** ✅ (a última ocorrência) passa o portão' $r 0 @('consolidação dos documentos vivos')
Put $p '.team-project/sprints/1/validation.md' "# Validação`n`n**Veredito:** $failMk reprovado`n`n**Veredito (rodada 2):** $warn aprovado com ressalva`n`n**Decisão do PO:** aceito com dívida — contraste da tela 3, H-020 no backlog`n"; & $setTimes $true
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'C6: ⚠️ com Decisão do PO aceito com dívida passa o portão' $r 0 @('consolidação dos documentos vivos')
Edit-File $valp "**Veredito (rodada 2):** $warn aprovado com ressalva" "**Veredito (rodada 2):** $failMk reprovado"; & $setTimes $true
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'C6: ❌ nunca passa pela Decisão do PO' $r 0 @('abrir Q-S1')
Edit-File $sbp '## Entradas fora da Planning' ("## Correção do portão — sprint 1`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários | Critério de pronto |`n|---|---|---|---|---|---|---|---|---|`n| $($e.todo) Q-S1 | Corrigir achados 1 e 2 | 1 | dev | — | ``plan/`` | — | nenhum aplicável — correção do portão | testes |`n`n## Entradas fora da Planning")
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'C5: Q-S1 no quadro sem plano — plano de correção (Arquiteto), marcada 🟦 pelo mark.ps1' $r 0 @('plano de correção do portão — Q-S1', "mark: Q-S1 $($e.todo) → $($e.plan)", 'team:architect')
$r = Invoke-Check 'close.ps1' @('-Task', 'Q-S1', '-Root', $p)
Check 'C5: close.ps1 acha a Q-S1 sob ## Correção do portão — R20 ok' $r 1 @('\| R20 \| ok.*correção do portão')
Edit-File $sbp "| $($e.plan) Q-S1 |" "| $($e.ok) Q-S1 |"; & $setTimes $true
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'C5: Q-S1 fechada e veredito ainda ❌ mais novo que a medição — abrir Q-S1b' $r 0 @('abrir Q-S1b')
& $setTimes $false
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'C5: medição mais nova que o validation.md — o QA revisa o veredito (rodada 3)' $r 0 @('revisar o veredito', 'Veredito \(rodada 3\)')

# 12i. C7 (item 16): Review adiada é caminho formal no R21; a Review seguinte traz as Histórias herdadas.
$p = Join-Path $tmp 'adiada'; New-Project $p
Put $p '.team-project/sprints/1/retrospective.md' "# Retro`n"
Put $p '.team-project/sprints/1/review.md' "# Review — Sprint 1`n`n**Estado:** adiada para o sprint 2 — alvo de execução indisponível; decisão do stakeholder em README §7`n"
$r = Invoke-Check 'project.ps1' @('-Root', $p)
Check 'C7: sprint fechado com Review adiada (sem dossiê nem tabela): R21 ok' $r 0 @('\| R21 \| ok.*Review adiada: sprint 1 → 2')
Put $p '.team-project/sprints/2/retrospective.md' "# Retro`n"; Put $p '.team-project/sprints/2/review.md' "# Review — Sprint 2`n`n### Histórias do sprint`n"
$r = Invoke-Check 'project.ps1' @('-Root', $p)
Check 'C7: a Review do sprint 2 sem "Histórias herdadas do sprint 1": R21 falhou' $r 0 @('\| R21 \| falhou.*Histórias herdadas do sprint 1')
Put $p '.team-project/sprints/1/review.md' "# Review — Sprint 1`n`n**Estado:** adiada`n"
$r = Invoke-Check 'project.ps1' @('-Root', $p)
Check 'C7: adiada sem o sprint de destino e o motivo: R21 falhou' $r 0 @('\| R21 \| falhou.*adiada sem .para o sprint')

# 12j. C3: o executor de Task (role task-runner, gravado pela G16) é papel próprio no consumo e no kanban; o filho diz quem o chamou.
$p = Join-Path $tmp 'executor'; New-Project $p
$bdx = Join-Path $p '.team-project/sprints/1/burndown.md'; $kbx = Join-Path $p '.team-project/sprints/1/kanban.md'
[System.IO.File]::WriteAllText($kbx, "# Kanban — Sprint 1`n`n## Kanban`n`n| x |`n|---|`n`n" + [System.IO.File]::ReadAllText($bdx, $utf8).Replace('# Burndown — Sprint 1', ''), $utf8); Remove-Item -LiteralPath $bdx -Force
Put $p '.team-project/usage.jsonl' ('{"role":"task-runner","work":"T-041","model":"claude-sonnet-5-5","start":"2026-09-03T10:00:00","duration_s":120,"processed":50000,"dest":".team-project/sprints/1/consumption.md","agent_id":"tr1","round":1,"children":["dv1"]}' + "`n" + '{"role":"developer","work":"T-041","model":"claude-haiku-5-5","start":"2026-09-03T10:01:00","duration_s":300,"processed":200000,"dest":".team-project/sprints/1/consumption.md","agent_id":"dv1","round":1}' + "`n")
[System.IO.File]::AppendAllText((Join-Path $p '.team-project/sprints/1/consumption.md'), "`n## Totais do sprint (derivado)`n| Papel | Modelo | Σ tokens processados | Instâncias | Rodadas | Duração total | Σ notificação |`n|---|---|---|---|---|---|---|`n", $utf8)
$r = Invoke-Check 'consumption.ps1' @('-Root', $p)
$r2 = Invoke-Check 'kanban.ps1' @('-Root', $p)
Check 'C3: task-runner nas tabelas (Totais e Por papel e modelo), o dev "chamado por task-runner"' @{ Code = $r.Code + $r2.Code; Out = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/consumption.md'), $utf8) + "`n" + [System.IO.File]::ReadAllText($kbx, $utf8) } 0 @('\| task-runner \| sonnet 5\.5 \| `Agent` \| T-041 \| cerimônia', '\| dev \| haiku 5\.5 .*chamado por task-runner; medido: dv1#1', '\| task-runner \| sonnet 5\.5 \| 50\.000 \| 1 \| 1 ', '\| task-runner \| sonnet 5\.5 \| 1 \| 50\.000 \| 02:00 \|')

# 13. v3.52.3 — note.md itens 1 a 5, 9 e 10 (sprint 4 do garden).
# 13a. item 1: sem alvo, o cartão não manda rodar o accept.
$p = Join-Path $tmp 'cartao-sem-alvo'; New-Project $p
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$card = Join-Path $p '.team-project/sprints/1/handoff/T-041.md'
$ct = if (Test-Path -LiteralPath $card) { [System.IO.File]::ReadAllText($card, $utf8) } else { 'sem cartão' }
Check 'item 1: sem targets, o cartão diz que o accept não roda e não traz o comando' @{ Code = $(if ($ct -notmatch 'accept\.ps1 -Task') { $r.Code } else { 1 }); Out = $ct } 0 @('\*\*Cenários:\*\* SC-014 — sem alvo de execução: o accept não roda')

# 13b. item 2: o orçamento do full estima a suíte pela história dela, não pela duração do build.
$p = Join-Path $tmp 'verify3'; New-Project $p
$ErrorActionPreference = 'Continue'
& git -C $p init -q 2>$null; Put $p '.gitignore' ".team-project/`n"; Put $p 'src/calc.ts' "export const x = 1`n"
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output ''Build succeeded''", "suite": "Write-Output ''Tests: 3 passed''" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-MaxMinutes', '1', '-Root', $p)
Check 'item 2: sem história da suíte, vale a regra antiga (cabe no minuto, roda tudo)' $r 0 @('tudo exit 0', 'suite: exit 0')
Put $p '.team-project/verify/1/T-040/result.json' '{ "task": "T-040", "full": { "at": "2026-10-26 10:00:00", "tree": "x", "commands": [ { "key": "build", "exit": 0, "seconds": 20 }, { "key": "suite", "exit": 0, "seconds": 480 } ] } }'
Put $p 'src/calc.ts' "export const x = 2`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-MaxMinutes', '1', '-Root', $p)
Check 'item 2: suíte de 480 s na história de outra Task não cabe no minuto que sobra: fica pendente, exit 3' $r 3 @('PARCIAL: 1 comando', 'pendente\(s\): suite')
# 13b2. v3.57.1 (note.md item 3, sprint 5 do garden): a cobertura não roda antes da suíte pendente — lia o resumo da rodada
# anterior ("não medido" ou verde velho). A cobertura daqui só passa se ler o resumo que a suíte DESTA rodada gravou.
$pv = Join-Path $tmp 'verify-cov'; New-Project $pv
$ErrorActionPreference = 'Continue'
& git -C $pv init -q 2>$null; Put $pv '.gitignore' ".team-project/`nout/`n"; Put $pv 'src/calc.ts' "export const x = 1`n"
& git -C $pv add -A 2>$null; & git -C $pv -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $pv '.team-project/guards.json' '{ "verify": { "build": "Write-Output ''Build succeeded''", "suite": "New-Item -ItemType Directory -Force out | Out-Null; Set-Content out/resumo.txt (git rev-parse HEAD); Write-Output ''Tests: 3 passed''", "coverage": "if ((Test-Path out/resumo.txt) -and ((Get-Content out/resumo.txt) -eq (git rev-parse HEAD))) { Write-Output ''cobertura: medida'' } else { Write-Output ''cobertura: modulo nao medido''; exit 1 }" } }'
Put $pv '.team-project/verify/1/T-040/result.json' '{ "task": "T-040", "full": { "at": "2026-10-26 10:00:00", "tree": "x", "commands": [ { "key": "build", "exit": 0, "seconds": 20 }, { "key": "suite", "exit": 0, "seconds": 480 }, { "key": "coverage", "exit": 0, "seconds": 2 } ] } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-MaxMinutes', '1', '-Root', $pv)
Check 'v3.57.1 item 3: suíte pendente leva a cobertura junto (antes a cobertura rodava sem a suíte e lia o resumo velho)' $r 3 @('PARCIAL: 1 comando', 'pendente\(s\): suite, coverage', '^(?![\s\S]*coverage: exit)')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-MaxMinutes', '1', '-Root', $pv)
Check 'v3.57.1 item 3: na chamada seguinte a suíte roda e a cobertura logo depois dela (curta pela história, fora do orçamento), e lê o resumo desta rodada' $r 0 @('tudo exit 0', 'suite: exit 0', 'coverage: exit 0 .*cobertura: medida')

# 13c. item 4: uma rodada por Task — trava viva → exit 5; trava de processo morto é resto e sai.
$lk = Join-Path $p '.team-project/verify/1/T-041/verify.lock'
Put $p '.team-project/verify/1/T-041/verify.lock' ('{"pid":' + $PID + ',"started":"' + (Get-Process -Id $PID).StartTime.ToString('o') + '","mode":"full","at":"2026-10-27 10:00:00"}')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'item 4: outra rodada viva da mesma Task: OCUPADO, exit 5, a trava dela fica' @{ Code = $r.Code; Out = $r.Out + "`nTRAVA=" + (Test-Path -LiteralPath $lk) } 5 @('OCUPADO — outra rodada desta Task \(full', '-WaitBusySeconds 540', 'TRAVA=True')
Put $p '.team-project/verify/1/T-041/verify.lock' '{"pid":999999,"started":"2001-01-01T00:00:00","mode":"full","at":"2026-10-27 09:00:00"}'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'item 4: trava de processo morto sai; a rodada roda e apaga a própria trava' @{ Code = $r.Code; Out = $r.Out + "`nTRAVA=" + (Test-Path -LiteralPath $lk) } 0 @('tudo exit 0', 'TRAVA=False')
# v3.53.2: -WaitBusySeconds espera a rodada viva acabar na mesma chamada e segue (o dev novo não pausa o run).
# v3.65.9: a rodada viva dura 20 s (eram 7): com 8 blocos em paralelo o verify levava mais de 7 s para subir, achava a trava
# já solta e o caso falhava sem "esperou" (3 rodadas completas seguidas).
$sleeper = Start-Process powershell -ArgumentList '-NoProfile', '-Command', 'Start-Sleep -Seconds 20' -PassThru -WindowStyle Hidden
Put $p '.team-project/verify/1/T-041/verify.lock' ('{"pid":' + $sleeper.Id + ',"started":"' + $sleeper.StartTime.ToString('o') + '","mode":"full","at":"2026-10-27 10:00:00"}')
Put $p 'src/calc.ts' "export const x = 21`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-MaxMinutes', '30', '-WaitBusySeconds', '60', '-Root', $p)
Check 'v3.53.2: OCUPADO com -WaitBusySeconds espera a rodada anterior acabar e roda a sua' @{ Code = $r.Code; Out = $r.Out + "`nTRAVA=" + (Test-Path -LiteralPath $lk) } 0 @('esperou \d+ s pela rodada anterior \(full, pid', 'tudo exit 0', 'TRAVA=False')

# 13d. item 5: comando acima de 80 % do teto por comando sai com "atenção:".
Put $p '.team-project/guards.json' '{ "verify": { "suite": "Start-Sleep -Milliseconds 14000; Write-Output ''Tests: 3 passed''" } }'
Put $p 'src/calc.ts' "export const x = 3`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-042', '-Mode', 'full', '-TimeoutMinutes', '0.3', '-Root', $p)
Check 'item 5: suíte perto do teto (18 s): atenção com a fração e a saída (dividir verify.suite)' $r 0 @('atenção: suite levou 1[4-8] s, (7[89]|[89]\d|100) % do teto por comando \(18 s', 'divide o comando em guards.json → verify')

# 13e. item 10: o done -Result gap grava a rota no run-log.md e pede ao Arquiteto estender a decisão.
$p = Join-Path $tmp 'gap-log'; New-Project $p
Put $p '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041`n`n🔺 GAP: o plano manda rodar accept sem .scn`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Nature', 'processo', '-Root', $p)
$rl = Join-Path $p '.team-project/sprints/1/run-log.md'
Check 'item 10: rota do GAP no run-log.md (pelo done); v3.53.7: decisão comum uma vez em architect/decisions, citada nos planos' @{ Code = $r.Code; Out = $r.Out + "`n" + $(if (Test-Path -LiteralPath $rl) { [System.IO.File]::ReadAllText($rl, $utf8) } else { 'sem run-log' }) } 0 @('grave-a UMA vez como D-<k> em \.team-project/architect/decisions/S1\.md', 'não copie o texto em plano nenhum', '\| Quando \| Item \| Decisão \| Porquê \| Evidência \|', '\| T-041 \| 🔺 GAP \[process · executor \(-Cause\)\] → Arquiteto em instância nova .* \| 🔺 GAP: o plano manda rodar accept sem \.scn \| sprints/1/delivery/T-041\.md \|')
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $p)
Check 'item 10: queda de ambiente também vira linha do run-log.md' @{ Code = $r.Code; Out = [System.IO.File]::ReadAllText($rl, $utf8) } 0 @('\| T-041 \| queda de ambiente \(1 neste bloco\)')

# 13f. item 9: o agente cortado pelo limite (sem SubagentStop) é medido pelo run.ps1 next; o consumo tem a coluna US$.
$p = Join-Path $tmp 'cortado'; New-Project $p
$sd = Join-Path $tmp 'tr-cortado/sessX/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
$atr = Join-Path $sd 'agent-cut0000001.jsonl'
[System.IO.File]::WriteAllLines($atr, [string[]]@(
    '{"type":"user","timestamp":"2026-10-27T03:00:00Z","message":{"role":"user","content":"Construa a T-041 — exporta"}}',
    '{"type":"assistant","timestamp":"2026-10-27T03:00:10Z","message":{"id":"c1","model":"claude-haiku-5-5","usage":{"input_tokens":10,"cache_creation_input_tokens":1000,"cache_read_input_tokens":200000,"output_tokens":100}}}',
    '{"type":"assistant","timestamp":"2026-10-27T03:58:31Z","message":{"id":"c2","model":"<synthetic>","content":[{"type":"text","text":"You''ve hit your weekly limit · resets Oct 30, 1pm"}],"usage":{"input_tokens":0,"cache_creation_input_tokens":0,"cache_read_input_tokens":0,"output_tokens":0}}}'), (New-Object System.Text.UTF8Encoding($false)))
$stj = (Join-Path $tmp 'tr-cortado/sessX.jsonl'); Set-Content -LiteralPath $stj '{}' -Encoding UTF8
Put $p '.team-project/.interrupted' ('[' + (@{ type = 'team:developer'; work = 'T-041'; parent = ''; desde = '2026-10-27 03:00:00'; last = 'verify.ps1'; at = '2026-10-27 03:58:00'; session = 'sessX'; agent_id = 'cut0000001'; transcript = $atr; session_transcript = $stj } | ConvertTo-Json -Compress) + ']')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
$uj = Join-Path $p '.team-project/usage.jsonl'
Check 'item 9: agente cortado medido pelo next, com US$ do Haiku acima de 100 mil (0,5) e sem a chamada sintética' @{ Code = $r.Code; Out = $r.Out + "`n" + $(if (Test-Path -LiteralPath $uj) { [System.IO.File]::ReadAllText($uj, $utf8) } else { 'sem usage' }) } $r.Code @('consumo: developer T-041 medido pelo transcript \(parou sem SubagentStop\)', '"agent_id":"cut0000001".*"calls":2.*"processed":201110,"usd":0\.0109')
$p = Join-Path $tmp 'usd'; New-Project $p
Put $p '.team-project/usage.jsonl' ('{"role":"architect","work":"T-041","model":"claude-opus-5-5","start":"2026-09-03T10:00:00","duration_s":120,"processed":500000,"usd":1.5,"dest":".team-project/sprints/1/consumption.md","agent_id":"ar1","round":1}' + "`n" + '{"role":"developer","work":"T-041","model":"claude-haiku-4-5","start":"2026-09-03T10:05:00","duration_s":60,"processed":100000,"dest":".team-project/sprints/1/consumption.md","agent_id":"dv1","round":1}' + "`n")
[System.IO.File]::AppendAllText((Join-Path $p '.team-project/sprints/1/consumption.md'), "`n## Totais do sprint (derivado)`n| a | b |`n|---|---|`n", $utf8)
$r = Invoke-Check 'consumption.ps1' @('-Root', $p)
# v3.53.6 (decisão do stakeholder): sai o US$ — Totais com Cota 5h e Cota semana; sem registro da cota, "—" e o aviso.
$ct = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/consumption.md'), $utf8)
Check 'v3.53.6: Totais sem US$, com Cota 5h e Cota semana "—" e o aviso sem registro da cota; a Nota sem US$' @{ Code = $r.Code; Out = $r.Out + $ct + $(if ($ct -match 'US\$') { "`nUSD=presente" } else { '' }) } 0 @('\| Σ notificação \| Cota 5h \| Cota semana \|', '\| arc \| opus 5\.5 \| 500\.000 \| 1 \| 1 \| 02:00 \| 0 \| — \| — \|', '\| dev \| haiku 4\.5 \| 100\.000 \| 1 \| 1 \| 01:00 \| 0 \| — \| — \|', '## Cota da assinatura \(derivado\)', 'sem registro da cota — ative a status line do plugin \(how-to\)', 'mantida\(s\); sem registro da cota\.')
if ($ct -match 'US\$') { $fail++; Write-Output '---- consumo ainda escreve US$' }

# 14. v3.53.1 — plugin-report do sprint 4 do garden (itens 1, 3, 8, 14, 15, 16).
# 14a. item 15: o dev voltou com TETO (G23) — done -Result teto grava o run-log e manda instância nova, sem Arquiteto.
$p = Join-Path $tmp 'teto'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.todo) T-041a |" "| $($e.ok) T-041a |"   # sem plano, levaria o next ao preparo
Put $p '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041`n`n### Parei no passo`npasso 3 de 5 — falta a mutação; emulador ligado`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'teto', '-Root', $p)
$rl = Join-Path $p '.team-project/sprints/1/run-log.md'
Check 'item 15: done -Result teto — ponto de retomada, run-log e start de novo sem Arquiteto' @{ Code = $r.Code; Out = $r.Out + "`n" + $(if (Test-Path -LiteralPath $rl) { [System.IO.File]::ReadAllText($rl, $utf8) } else { 'sem run-log' }) } 0 @('parou no TETO de contexto \(G23\), com o ponto de retomada gravado: passo 3 de 5', 'run\.ps1 start -Task T-041', '\| T-041 \| teto de contexto do dev \(G23\)')
# 14b. item 3: dev da Task vivo (sinal de vida recente) — start recusa outro, next manda esperar; registro velho não segura.
$n0 = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
Put $p '.team-project/.active-agents' ('[{"type":"team:developer","description":"Dev T-041","desde":"' + $n0 + '","session":"sOutra","parent":"","agent_id":"devviv1","work":"T-041","last":"verify.ps1 -Mode full","at":"' + $n0 + '","host_pid":' + $PID + ',"host_start":"' + (Get-Process -Id $PID).StartTime.ToString('yyyy-MM-dd HH:mm:ss') + '"}]')
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
Check 'item 3: start com dev vivo da Task (processo hospedeiro vivo): exit 2, não dispara outro' $r 2 @('já tem um dev vivo \(agent_id devviv1', 'duas instâncias no mesmo alvo')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'item 3: next com dev vivo da Task em 🟨: esperar, exit 3 (v3.57.0: e a linha do watcher, sem ID de Task no disparo)' $r 3 @('PRÓXIMA AÇÃO: esperar — a T-041 já tem developer vivo', "conferência por tempo \(protocolo de espera\): dispare o watcher — Agent\(subagent_type 'team:watcher', model 'haiku', description 'Watcher da espera', prompt 'Rode a sonda do seu roteiro e devolva a linha\.'\), sem ID de Task")
Put $p '.team-project/.active-agents' ('[{"type":"team:developer","desde":"' + $n0 + '","session":"sOutra","parent":"","agent_id":"devmor1","work":"T-041","last":"x","at":"' + $n0 + '","host_pid":999999,"host_start":"2001-01-01 00:00:00"}]')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'item 3: processo hospedeiro encerrado: o next segue com o executor' $r 0 @('PRÓXIMA AÇÃO: construir T-041')
# v3.59.1 (sprint 6 do garden, T-069b 19:27–19:47): executor "aguardando filho" de um dev que já parou há mais de 3 min — o
# next mandava esperar os 20 min do prazo de sinal de vida; agora segue. Com o filho parado há menos de 3 min, espera (o aviso
# do filho está acordando o executor).
$hs = (Get-Process -Id $PID).StartTime.ToString('yyyy-MM-dd HH:mm:ss'); $tA = (Get-Date).AddMinutes(-8).ToString('yyyy-MM-dd HH:mm:ss'); $tB = (Get-Date).AddMinutes(-6).ToString('yyyy-MM-dd HH:mm:ss')
$ua = Join-Path $p '.team-project/usage.jsonl'; $uaOld = if (Test-Path -LiteralPath $ua) { [System.IO.File]::ReadAllText($ua, $utf8) } else { $null }
$wrU = { param([string]$devTs, [string]$extra = '') [System.IO.File]::WriteAllText($ua, ('{"ts":"' + $tA.Replace(' ', 'T') + '","agent_id":"run591","role":"task-runner","description":"Executor T-041","children":["dev591"]}' + "`n" + '{"ts":"' + $devTs + '","agent_id":"dev591","role":"developer","description":"Dev T-041","children":[]' + $extra + '}' + "`n"), $utf8) }
& $wrU $tB.Replace(' ', 'T')
Put $p '.team-project/.active-agents' ('[{"type":"team:task-runner","description":"Executor T-041","desde":"' + $tA + '","session":"s1","parent":"","agent_id":"run591","work":"T-041","last":"aguardando filho","at":"' + (Get-Date).AddMinutes(-2).ToString('yyyy-MM-dd HH:mm:ss') + '","host_pid":' + $PID + ',"host_start":"' + $hs + '"},{"type":"team:developer","description":"Dev T-041","desde":"' + $tA + '","session":"s1","parent":"run591","agent_id":"dev591","work":"T-041","last":"Add-Content","at":"' + $tA + '","host_pid":' + $PID + ',"host_start":"' + $hs + '"}]')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.59.1 item 1: executor aguardando filho de dev que parou há 6 min (e o registro do dev, resto) → o next segue' $r 0 @('PRÓXIMA AÇÃO: construir T-041')
& $wrU (Get-Date).AddMinutes(-1).ToString('yyyy-MM-ddTHH:mm:ss')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.59.1 item 1: dev parou há 1 min → o executor está sendo acordado: esperar' $r 3 @('PRÓXIMA AÇÃO: esperar — a T-041 já tem task-runner vivo')
& $wrU $tB.Replace(' ', 'T') ',"waiting":true'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
# v3.62.2 (garden, Q-S6d): o Claude Code encerra o comando do agente com o turno — o ESPERANDO sem comando vivo da Task não
# espera nada (antes: esperar, e o run parava). Com um comando da Task vivo (o verify da trava), continua esperando.
Check 'v3.62.2: dev parou há 6 min com ESPERANDO e nenhum comando da Task roda → o next segue (antes esperava o aviso que não vem)' $r 0 @('PRÓXIMA AÇÃO: construir T-041')
$lk62 = Join-Path $p '.team-project/verify/1/T-041/verify.lock'
Put $p '.team-project/verify/1/T-041/verify.lock' ('{"pid":' + $PID + ',"started":"' + (Get-Process -Id $PID).StartTime.ToString('o') + '","mode":"full","at":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '"}')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.62.2: ESPERANDO com o verify da Task vivo (não desacoplado) → esperar, como antes' $r 3 @('PRÓXIMA AÇÃO: esperar — a T-041 já tem task-runner vivo')
Remove-Item -LiteralPath $lk62 -Force -ErrorAction SilentlyContinue
if ($null -ne $uaOld) { [System.IO.File]::WriteAllText($ua, $uaOld, $utf8) } else { Remove-Item -LiteralPath $ua -Force }
Remove-Item -LiteralPath (Join-Path $p '.team-project/.active-agents') -Force -ErrorAction SilentlyContinue
# v3.57.2 (note.md item 14, ocorrência 8 do sprint 5 do garden): duas Tasks em 🟨, a primeira do quadro depende da segunda —
# o next constrói a dependência, não a que espera por ela (antes saía "construir Q-S5" com a Q-S5b em construção).
$p = Join-Path $tmp 'dep-cur'; New-Project $p
$sbp = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'; $sbl = [System.IO.File]::ReadAllLines($sbp, $utf8)
$iA = [array]::FindIndex($sbl, [Predicate[string]]{ param($x) $x -like '*T-041a |*' }); $i0 = [array]::FindIndex($sbl, [Predicate[string]]{ param($x) $x -like "| $($e.qa) T-041 |*" })
$rA = $sbl[$iA].Replace("| $($e.todo) T-041a |", "| $($e.build) T-041a |").Replace('[`plan/T-041a-x.md`](plan/)', '[`plan/T-041a-x.md`](plan/T-041a-x.md)'); $r0 = $sbl[$i0].Replace("| $($e.qa) T-041 |", "| $($e.build) T-041 |")
$sbl[$i0] = $rA; $sbl[$iA] = $r0; [System.IO.File]::WriteAllLines($sbp, $sbl, $utf8)
Put $p '.team-project/sprints/1/plan/T-041a-x.md' "# Plano T-041a`n**Cenários:** nenhum — refatoração interna`n"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.57.2 item 14: com duas Tasks em 🟨, o next constrói a dependência (T-041), não a que depende dela (T-041a, primeira do quadro)' $r 0 @('PRÓXIMA AÇÃO: construir T-041 —', '^(?![\s\S]*construir T-041a)')
# 14c. item 8: a mesma sessão seguiu depois do limite — o agente do .active-agents que parou no limite é medido pelo next.
$p = Join-Path $tmp 'limite-mesma'; New-Project $p
$sd = Join-Path $tmp 'tr-lim/sessL/subagents'; New-Item -ItemType Directory -Force $sd | Out-Null
[System.IO.File]::WriteAllLines((Join-Path $sd 'agent-cutL0001.jsonl'), [string[]]@(
    '{"type":"user","timestamp":"2026-10-30T03:00:00Z","message":{"role":"user","content":"Construa a T-041 — exporta"}}',
    '{"type":"assistant","timestamp":"2026-10-30T03:00:10Z","message":{"id":"l1","model":"claude-sonnet-5-5","usage":{"input_tokens":10,"cache_creation_input_tokens":1000,"cache_read_input_tokens":50000,"output_tokens":100}}}',
    '{"type":"assistant","timestamp":"2026-10-30T03:10:00Z","message":{"id":"l2","model":"<synthetic>","content":[{"type":"text","text":"You''ve hit your weekly limit · resets Oct 31, 1pm"}],"usage":{"input_tokens":0,"output_tokens":0}}}'), (New-Object System.Text.UTF8Encoding($false)))
$stl = (Join-Path $tmp 'tr-lim/sessL.jsonl') -replace '\\', '/'; Set-Content -LiteralPath $stl '{}' -Encoding UTF8
Put $p '.team-project/usage.jsonl' ('{"role":"quality-assurance","work":"T-041","model":"claude-sonnet-5-5","start":"2026-10-30T02:00:00","duration_s":60,"processed":1000,"dest":".team-project/sprints/1/consumption.md","session_transcript":"' + $stl + '"}' + "`n")
Put $p '.team-project/.usage-limit' '{"desde":"2026-10-30 03:10:00","reset":"Oct 31, 1pm","quem":"sessão","item":"T-041","texto":"You have hit your weekly limit"}'
Put $p '.team-project/.active-agents' '[{"type":"team:developer","desde":"2026-10-30 03:00:00","session":"sessL","parent":"","agent_id":"cutL0001","work":"T-041","last":"verify.ps1","at":"2026-10-30 03:09:00"}]'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
$uj = Join-Path $p '.team-project/usage.jsonl'
Check 'item 8: limite na mesma sessão — o agente parado no limite é medido pelo next e sai do registro' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText($uj, $utf8) + "`nREG=" + $(if (Test-Path -LiteralPath (Join-Path $p '.team-project/.active-agents')) { 'presente' } else { 'vazio' }) } $r.Code @('LIMITE DE USO DA CONTA', 'consumo: developer T-041 medido pelo transcript', '"agent_id":"cutL0001".*"calls":2', 'REG=vazio')
# 14d. item 1: cenário sem nenhum assert não prova o critério — malformado (exit 2).
$p = Join-Path $tmp 'sem-assert'; New-Project $p
Put $p '.team-project/quality-assurance/scenarios/w.scn' "scenario SC-031 Abre a WebView`nlaunch`nshot inicial`n`nscenario SC-032 Conta`nlaunch`nassert-count destino.card. = 2`n"
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-ParseOnly', '-Root', $p)
Check 'item 1: cenário só com launch/shot (sem assert-*): exit 2, nomeado; o outro não' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'SC-032 sem nenhum') { "`nSC032=errado" } else { '' }) } 2 @('cenário SC-031 sem nenhum assert-\*')
# 14e. item 16: duas transições no mesmo minuto — vale a de baixo no Registro (🟨), não a ordem do Sort-Object.
$p = Join-Path $tmp 'empate'; New-Project $p
$bdx = Join-Path $p '.team-project/sprints/1/burndown.md'; $bd = Join-Path $p '.team-project/sprints/1/kanban.md'
[System.IO.File]::WriteAllText($bd, "# Kanban — Sprint 1`n`n## Kanban`n`n| x |`n|---|`n`n" + [System.IO.File]::ReadAllText($bdx, $utf8).Replace('# Burndown — Sprint 1', ''), $utf8); Remove-Item -LiteralPath $bdx -Force
Edit-File $bd "| T-041 | $($e.plan) → $($e.build) | 2026-09-02 09:00 | dev |" ("| T-041 | $($e.plan) → $($e.build) | 2026-09-02 09:00 | dev |`n| T-041 | $($e.build) → $($e.todo) | 2026-09-02 10:01 | sessão |`n| T-041 | $($e.todo) → $($e.build) | 2026-09-02 10:01 | dev |")
Put $p '.team-project/usage.jsonl' ('{"role":"developer","work":"T-041","works":["T-041"],"model":"claude-sonnet-5-5","start":"2026-09-02T10:01:39","duration_s":600,"paused_s":0,"processed":1000000,"dest":".team-project/sprints/1/consumption.md"}' + "`n")
$r = Invoke-Check 'kanban.ps1' @('-Root', $p)
$kbt = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/kanban.md'), $utf8)
Check 'item 16: empate de minuto no Registro — a rodada do dev vai à Construção' @{ Code = $r.Code; Out = $kbt } 0 @('\| T-041 \| — \| 1\.000\.000 · 10:00 \| — \| — \|')
# 14f. item 14: a versão do plugin na rodada vai à Nota do consumption.md.
$p = Join-Path $tmp 'versao'; New-Project $p
Put $p '.team-project/usage.jsonl' ('{"role":"developer","work":"T-041","model":"claude-sonnet-5-5","start":"2026-09-03T10:00:00","duration_s":60,"processed":1000,"dest":".team-project/sprints/1/consumption.md","agent_id":"dvv1","round":1,"plugin":"3.53.1"}' + "`n")
$r = Invoke-Check 'consumption.ps1' @('-Root', $p)
Check 'item 14: Nota com a versão do plugin da rodada' @{ Code = $r.Code; Out = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/consumption.md'), $utf8) } 0 @('medido: dvv1#1.*; plugin 3\.53\.1')

# 14g. v3.53.6 — cota da assinatura: a status line grava a leitura (só quando muda) e o consumption.ps1 rateia a subida.
$statusScript = Join-Path (Split-Path $checks) 'statusline/quota-statusline.ps1'
function Invoke-StatusLine([string]$Json, [string]$LogPath) {
    $ErrorActionPreference = 'Continue'
    $old = $env:TEAM_QUOTA_LOG; $env:TEAM_QUOTA_LOG = $LogPath
    $oe = [Console]::OutputEncoding; [Console]::OutputEncoding = $utf8
    try { $out = $Json | & powershell -NoProfile -ExecutionPolicy Bypass -File $statusScript 2>&1 | Out-String; $code = $LASTEXITCODE }
    finally { [Console]::OutputEncoding = $oe; $env:TEAM_QUOTA_LOG = $old }
    return @{ Code = $code; Out = $out }
}
$ql = Join-Path $tmp 'cota-sl/quota-log.jsonl'
$rs5 = [DateTimeOffset]::Now.AddHours(1).ToUnixTimeSeconds(); $rsw = [DateTimeOffset]::Now.AddDays(3).ToUnixTimeSeconds()
$js = '{"session_id":"s-1","cwd":"C:\\proj","model":{"id":"claude-opus-5-5","display_name":"Opus 5.5"},"rate_limits":{"five_hour":{"used_percentage":37.2,"resets_at":' + $rs5 + '},"seven_day":{"used_percentage":12,"resets_at":' + $rsw + '}}}'
$r = Invoke-StatusLine $js $ql
$r2 = Invoke-StatusLine $js $ql
$qlt = if (Test-Path -LiteralPath $ql) { [System.IO.File]::ReadAllText($ql, $utf8) } else { 'sem registro' }
Check 'status line: modelo, 5h com o reinício e a semana numa linha; a leitura vai ao registro com os campos' @{ Code = $r.Code + $r2.Code; Out = $r.Out + "`n" + $qlt } 0 @('^Opus 5\.5 · 5h 37% \(reinicia (\d\d/\d\d )?\d\d:\d\d\) · semana 12%', ('"five":37\.2,"fiveReset":' + $rs5 + ',"week":12\.0,"weekReset":' + $rsw + ',"session":"s-1","model":"claude-opus-5-5","cwd":"C:\\\\proj"'))
Check 'status line: a mesma leitura duas vezes grava uma linha só (estado ao lado do registro)' @{ Code = 0; Out = "LINHAS=$(@($qlt -split "`n" | Where-Object { $_.Trim() }).Count)" } 0 @('LINHAS=1$')
$r = Invoke-StatusLine ($js -replace '37\.2', '38') $ql
$qlt = [System.IO.File]::ReadAllText($ql, $utf8)
Check 'status line: percentual mudou — linha nova' @{ Code = $r.Code; Out = "LINHAS=$(@($qlt -split "`n" | Where-Object { $_.Trim() }).Count)`n$qlt" } 0 @('LINHAS=2', '"five":38\.0')
$r = Invoke-StatusLine '{"model":{"id":"claude-haiku-5-5","display_name":"Haiku 5.5"},"session_id":"s-2"}' $ql
$qlt = [System.IO.File]::ReadAllText($ql, $utf8)
Check 'status line sem rate_limits (API ou antes da 1ª resposta): só o modelo, nada no registro' @{ Code = $r.Code; Out = $r.Out + "LINHAS=$(@($qlt -split "`n" | Where-Object { $_.Trim() }).Count)" } 0 @('^Haiku 5\.5\s*LINHAS=2$')
$r = Invoke-StatusLine 'não é json' $ql
Check 'status line com entrada ilegível: linha mínima, exit 0' $r 0 @('^cota: sem dado\s*$')

# Rateio: arc (Opus) e dev (Haiku) juntos 10:00–10:10 dividem +10,5% pelo peso (Opus 1 × Haiku 0,025); 10:10–10:30 sobe 1%
# sem rodada; às 11:10 a janela de 5 h reiniciou (passou do reset das 11:00) e o QA (Sonnet, sozinho) leva os 3% da janela
# nova — e é o intervalo de calibração; o dev das 11:20 não tem leitura depois: "cota sem registro".
$p = Join-Path $tmp 'cota'; New-Project $p
$qd = Join-Path $tmp 'cota-log/quota-log.jsonl'
$ep = { param($s) ([DateTimeOffset][datetime]::ParseExact($s, 'yyyy-MM-ddTHH:mm:ss', [Globalization.CultureInfo]::InvariantCulture)).ToUnixTimeSeconds() }
$R1 = & $ep '2026-09-03T11:00:00'; $R2 = & $ep '2026-09-03T16:00:00'; $W1 = & $ep '2026-09-07T00:00:00'
Put (Split-Path $qd) 'quota-log.jsonl' ((@(
    ('{"at":"2026-09-03T09:55:00","five":10.0,"fiveReset":' + $R1 + ',"week":5.0,"weekReset":' + $W1 + ',"session":"x","model":"m","cwd":"c"}'),
    ('{"at":"2026-09-03T10:10:00","five":20.5,"fiveReset":' + $R1 + ',"week":6.0,"weekReset":' + $W1 + ',"session":"x","model":"m","cwd":"c"}'),
    ('{"at":"2026-09-03T10:30:00","five":21.5,"fiveReset":' + $R1 + ',"week":6.0,"weekReset":' + $W1 + ',"session":"x","model":"m","cwd":"c"}'),
    ('{"at":"2026-09-03T11:10:00","five":3.0,"fiveReset":' + $R2 + ',"week":7.0,"weekReset":' + $W1 + ',"session":"x","model":"m","cwd":"c"}')
) -join "`n") + "`n")
$dq = '.team-project/sprints/1/consumption.md'
$tok = '"input":0,"cache_write":0,"cache_read":0,"output":100000,"processed":100000'
Put $p '.team-project/usage.jsonl' ((@(
    ('{"agent_id":"a1","role":"architect","round":1,"work":"T-041","model":"claude-opus-5-5","start":"2026-09-03T10:00:00","duration_s":600,"paused_s":0,' + $tok + ',"dest":"' + $dq + '"}'),
    ('{"agent_id":"d1","role":"developer","round":1,"work":"T-041","model":"claude-haiku-5-5","start":"2026-09-03T10:00:00","duration_s":600,"paused_s":0,' + $tok + ',"dest":"' + $dq + '"}'),
    ('{"agent_id":"q1","role":"quality-assurance","round":1,"work":"T-041a","model":"claude-sonnet-5-5","start":"2026-09-03T11:00:00","duration_s":600,"paused_s":0,' + $tok + ',"dest":"' + $dq + '"}'),
    ('{"agent_id":"d2","role":"developer","round":1,"work":"T-041a","model":"claude-haiku-5-5","start":"2026-09-03T11:20:00","duration_s":60,"paused_s":0,' + $tok + ',"dest":"' + $dq + '"}')
) -join "`n") + "`n")
Put $p $dq ((Get-Content -Raw -Encoding UTF8 (Join-Path $p $dq)) + "`n## Totais do sprint (derivado)`n| a | b |`n|---|---|`n")
$r = Invoke-Check 'consumption.ps1' @('-Root', $p, '-QuotaLog', $qd)
$r2 = Invoke-Check 'consumption.ps1' @('-Root', $p, '-QuotaLog', $qd)
$ct = [System.IO.File]::ReadAllText((Join-Path $p $dq), $utf8)
Check 'cota: sobreposição rateada pelo peso do modelo, reinício da janela conta do zero, rodada sem leitura depois "sem registro"' @{ Code = $r.Code + $r2.Code; Out = $r2.Out + $ct } 0 @(
    'medido: a1#1.*; cota 5h \+10,2% · semana \+1,0% \|', 'medido: d1#1.*; cota 5h \+0,3% · semana \+<0,1% \|', 'medido: q1#1.*; cota 5h \+3,0% · semana \+1,0% \|', 'medido: d2#1.*; cota sem registro \|',
    '\| arc \| opus 5\.5 \| 100\.000 \| 1 \| 1 \| 10:00 \| 0 \| \+10,2% \| \+1,0% \|', '\| qa \| sonnet 5\.5 \| 100\.000 \| 1 \| 1 \| 10:00 \| 0 \| \+3,0% \| \+1,0% \|', '\*\*Total do sprint\*\* .* \| \*\*\+13,5%\*\* \| \*\*\+2,0%\*\* \|',
    '\| \*\*Total do sprint\*\* \(rodadas\) \| \*\*3\*\* \| \*\*\+13,5%\*\* \| \*\*\+2,0%\*\* \|', '\| sem rodada medida no intervalo .* \| — \| \+1,0% \| \+0,0% \|',
    '\| T-041 \| 2 \| \+10,5% \| \+1,0% \|', '\| T-041a \| 1 \| \+3,0% \| \+1,0% \|', '\| sonnet 5\.5 \| 1 \| 0,50 \| 6,000 \| 2,000 \|', 'Sem `-Session`', 'mantida\(s\); cota 5h \+13,5% · semana \+2,0%\.')
if (([regex]::Matches($ct, '## Cota da assinatura')).Count -ne 1) { $fail++; Write-Output '---- seção da cota duplicou na segunda execução' }
# Sem o registro: tokens seguem, a cota diz por quê.
$r = Invoke-Check 'consumption.ps1' @('-Root', $p, '-QuotaLog', (Join-Path $tmp 'cota-log/nao-existe.jsonl'))
$ct = [System.IO.File]::ReadAllText((Join-Path $p $dq), $utf8)
Check 'cota sem registro: aviso para ativar a status line, Totais com tokens e "—", Nota sem cota' @{ Code = $r.Code; Out = $ct + $(if ($ct -match 'cota 5h \+') { "`nCOTA=sobrou" } else { '' }) } 0 @('sem registro da cota — ative a status line do plugin \(how-to\)', '\| arc \| opus 5\.5 \| 100\.000 \| 1 \| 1 \| 10:00 \| 0 \| — \| — \|')
if ($ct -match 'cota 5h \+') { $fail++; Write-Output '---- cota antiga ficou na Nota sem registro' }

# 15. v3.53.2 — /team-status e /team-usage sem custo de token (team-view.ps1; o hook prompt-submit.ps1 o chama).
$p = Join-Path $tmp 'view'; New-Project $p
# v3.59.0: /team-status abre em palavras simples; a visão técnica de antes sai com -Detail (/team-status detalhe).
$r = Invoke-Check 'team-view.ps1' @('-View', 'status', '-Root', $p)
Check 'v3.59.0 team-view status em palavras simples: andamento, nome de negócio com o código no fim, o que precisa de você, quadro por etapa e o caminho do detalhe' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'T-041 ·|Verificação:|Run:') { "`nTECNICO=sobrou" } else { '' }) } 0 @('Sprint 1 — 0 de 2 partes prontas \(cerca de 0% do trabalho estimado\)', 'Agora: ninguém do time está trabalhando', 'Em andamento: Exportar o resultado da análise — parte 1 de 2 \(T-041\) — em teste', 'Precisa de você: o sprint está pausado — para continuar, digite /sm sprint run', 'A seguir: Exportar o resultado da análise — parte 2 de 2 \(T-041a\)', "$($e.qa) Em teste \(1\)\r?\n\s+· Exportar o resultado da análise — parte 1 de 2 \(T-041\)", 'Detalhe técnico \(comandos, tempos, registro\): /team-status detalhe', '^(?![\s\S]*TECNICO=sobrou)')
$r = Invoke-Check 'team-view.ps1' @('-View', 'status', '-Detail', '-Root', $p)
Check 'team-view status: placar, restante da Série, quadro por coluna, última transição; "1. nenhuma" não é pendência' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'Esperando você') { "`nPEND=errado" } else { '' }) } 0 @("Sprint 1 · 2 Tasks · $($e.ok) 0 · $($e.qa) 1 · $($e.build) 0 · $($e.plan) 0 · $($e.todo) 1", 'Restante: 2 de 2', 'Run: parado', 'Agora: nenhum agente', "$($e.qa) Verificação: T-041\r?\n$($e.todo) A fazer: T-041a", "Última transição: T-041 $($e.build) → $($e.qa) · 2026-09-03 15:00")
# v3.59.0: a resolvida e a repetida não contam (no garden, "131 decisões" com 98 resolvidas).
Edit-File (Join-Path $p '.team-project/README.md') '1. nenhuma' "1. **[TST · S1 · ③ pacote]** Aprovar o pacote? — material: x — 2026-09-01 10:00`n2. **[RESOLVIDO em 2026-09-02] [TST · S1 · nome]** Qual nome mostrar? — Horta Fácil`n3. **[TST · S1 · ③ pacote]** Aprovar o pacote? — material: x — 2026-09-01 10:00"
Put $p '.team-project/.active-run' '{ "trilha": "sprint", "id": "1", "desde": "2026-09-02 08:00" }'
Put $p '.team-project/.active-agents' ('[{"type":"team:developer","desde":"2026-09-02 09:00:00","work":"T-041a","last":"verify.ps1 -Mode focused","at":"' + (Get-Date).AddMinutes(-3).ToString('yyyy-MM-dd HH:mm:ss') + '"}]')
$r = Invoke-Check 'team-view.ps1' @('-View', 'status', '-Detail', '-Root', $p)
Check 'team-view status: run em andamento, agente vivo com "há 3 min" e a pendência de §7 sem negrito (v3.59.0: sem a resolvida nem a repetida)' $r 0 @('Run: sprint 1 em andamento desde 2026-09-02 08:00', 'Agora \(1\):', 'dev · T-041a · há 3 min · verify\.ps1 -Mode focused', 'Esperando você: 1 decisão', '\d\. \[TST · S1 · ③ pacote\] Aprovar')
$r = Invoke-Check 'team-view.ps1' @('-View', 'status', '-Root', $p)
Check 'v3.59.0 team-view status simples: quem trabalha agora em frase simples e a pendência que espera o stakeholder (a resolvida não conta)' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'pausado') { "`nPAUSADO=errado" } else { '' }) } 0 @('Agora:\r?\n\s+- Desenvolvedor — Exportar o resultado da análise — parte 2 de 2 \(T-041a\): rodando os testes do que mudou \(desde 09:00\)', 'Precisa de você: 1 decisão na lista de pendências \(README §7\); a mais recente: "Aprovar o pacote\?', '^(?![\s\S]*PAUSADO=errado)')
$r = Invoke-Check 'team-view.ps1' @('-View', 'usage', '-Root', $p)
Check 'team-view usage sem rodadas: diz que nada foi medido' $r 0 @('Nenhuma rodada de agente medida')
Put $p '.team-project/usage.jsonl' ('{"role":"architect","work":"T-041","works":["T-041","T-041a"],"model":"claude-opus-5-5","start":"2026-09-01T11:00:00","duration_s":600,"processed":1000000,"usd":2.0,"dest":".team-project/sprints/1/consumption.md"}' + "`n" + '{"role":"developer","work":"T-041","model":"claude-haiku-5-5","start":"2026-09-02T10:00:00","duration_s":300,"processed":50000,"usd":0.5,"dest":".team-project/sprints/1/consumption.md"}' + "`n" + '{"role":"quality-assurance","work":"T-041a","model":"claude-sonnet-5-5","start":"2026-09-03T10:00:00","duration_s":30,"processed":8000,"dest":".team-project/sprints/1/consumption.md"}' + "`n" + '{"role":"developer","work":"T-099","model":"claude-haiku-5-5","start":"2026-08-01T10:00:00","duration_s":30,"processed":7,"usd":9,"dest":".team-project/consumption.md"}' + "`n")
# v3.53.6 (item 10): sem US$ — tokens, % dos tokens por papel e a cota da assinatura lida do registro da status line.
$qlOld = $env:TEAM_QUOTA_LOG; $env:TEAM_QUOTA_LOG = Join-Path $tmp 'view-quota/quota-log.jsonl'
$r = Invoke-Check 'team-view.ps1' @('-View', 'usage', '-Root', $p)
Check 'v3.53.6 team-view usage: só o sprint, sem US$, rateio entre as Tasks citadas, papel com % dos tokens; sem registro da cota, como ativar' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'US\$|sem preço') { "`nUSD=ainda" } else { '' }) } 0 @('Consumo · Sprint 1 · 1,06 mi tokens · 15 min de agente · 3 rodadas', 'Cota: sem registro — ative a status line do plugin', 'T-041  550 mil · 10 min', 'T-041a  508 mil · 5 min', 'arc \(opus 5\.5\)  1,00 mi · 95% · 1', 'qa \(sonnet 5\.5\)  8 mil · 1% · 1', 'Última rodada: 03/09 10:00 · qa · T-041a · 8 mil\r?$')
Put $tmp 'view-quota/quota-log.jsonl' ('{"at":"2026-08-31T10:00:00","five":5.0,"fiveReset":1,"week":10.0,"weekReset":100,"session":"s","model":"m","cwd":"c"}' + "`n" + '{"at":"2026-09-01T12:00:00","five":20.0,"fiveReset":2,"week":15.0,"weekReset":100,"session":"s","model":"m","cwd":"c"}' + "`n" + '{"at":"2026-09-02T12:00:00","five":30.0,"fiveReset":3,"week":18.0,"weekReset":100,"session":"s","model":"m","cwd":"c"}' + "`n" + '{"at":"2026-09-03T11:00:00","five":40.0,"fiveReset":4,"week":2.0,"weekReset":200,"session":"s","model":"m","cwd":"c"}' + "`n")
$r = Invoke-Check 'team-view.ps1' @('-View', 'usage', '-Root', $p)
Check 'v3.53.6 team-view usage: cota agora e a subida da semanal desde a 1ª rodada (leitura anterior não conta; reinício da janela conta do zero)' $r 0 @('Cota agora \(03/09 11:00\): 5h 40% · semana 2% · a semanal subiu 10,0 ponto\(s\) desde a 1ª rodada do sprint')
$env:TEAM_QUOTA_LOG = $qlOld
$r = Invoke-Check 'team-view.ps1' @('-View', 'kanban', '-Root', $p)
Check 'team-view -View inválido: exit 2' $r 2 @('inválido')
# v3.59.0 (sprint 6 do garden): o registro da Task (.active-task) que sobrou de uma Task já ✅ não a põe "em execução" nem
# PARADA — a T-069a saía em execução, PARADA e Fechada na mesma tela.
Put $p '.team-project/.active-task' '{"trilha":"sprint","id":"T-041","plano":".team-project/sprints/1/plan/T-041-export.md"}'
(Get-Item -LiteralPath (Join-Path $p '.team-project/.active-task')).LastWriteTime = (Get-Date).AddMinutes(-40)
Remove-Item -LiteralPath (Join-Path $p '.team-project/.active-agents') -Force
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.ok) T-041 |"
$r = Invoke-Check 'team-view.ps1' @('-View', 'status', '-Detail', '-Root', $p)
$r2 = Invoke-Check 'team-view.ps1' @('-View', 'status', '-Root', $p)
Check 'v3.59.0 team-view: Task do registro já ✅ não está em execução nem PARADA (detalhe e simples)' @{ Code = $r.Code; Out = $r.Out + "`n" + $r2.Out + $(if (($r.Out + $r2.Out) -match 'PARADA|Atenção: nada roda') { "`nALARME" } else { '' }) } 0 @("Em execução: nenhuma Task · a T-041 do registro já está $($e.ok) no quadro", '^(?![\s\S]*ALARME)')

# 16. v3.53.3 (avaliação do sprint 5 do garden).
# 16a. item 3: preparo de UMA História por vez — a preparada com Task a construir é construída antes de preparar a próxima.
$p = Join-Path $tmp 'wip'; New-Project $p
$sb = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'
$h20 = "## História H-020 — Outra coisa (média)`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários | Critério de pronto |`n|---|---|---|---|---|---|---|---|---|`n| $($e.todo) T-050 | Outra coisa | 1 | dev | DEP | [``plan/T-050-x.md``](plan/) | [``evidence/T-050.md``](evidence/) | nenhum aplicável — interno | teste |`n`n---`n`n"
Edit-File $sb "| $($e.qa) T-041 | Endpoint" "| $($e.ok) T-041 | Endpoint"
Edit-File $sb '[`plan/T-041a-x.md`](plan/)' '[`plan/T-041a-x.md`](plan/T-041a-x.md)'
Put $p '.team-project/sprints/1/plan/T-041a-x.md' "# Plano`n"
Edit-File $sb '## Entradas fora da Planning' ($h20.Replace('DEP', '—') + '## Entradas fora da Planning')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.3 item 3: História preparada com Task a construir → constrói antes de preparar a próxima' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'História H-020') { "`nPREPAROU-H020" } else { '' }) } 0 @('construir T-041a', '^(?![\s\S]*PREPAROU-H020)')
# A História que depende de Task aberta de outra História espera por ela: a da dependência se prepara primeiro.
$p = Join-Path $tmp 'wip-dep'; New-Project $p
$sb = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'
Edit-File $sb "| $($e.qa) T-041 | Endpoint" "| $($e.ok) T-041 | Endpoint"
Edit-File $sb '## História H-014' ($h20.Replace('DEP', 'T-041a') + '## História H-014')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.3 item 3: H-020 vem antes no quadro mas depende da T-041a (H-014) — o preparo começa pela H-014' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'planos da História H-020') { "`nPREPAROU-H020" } else { '' }) } 0 @('planos da História H-014', '^(?![\s\S]*PREPAROU-H020)')

# 16b. item 4: dev que encerrou o turno esperando verify/accept em segundo plano — done espera, start e next não redisparam.
$p = Join-Path $tmp 'ocupado'; New-Project $p
$vl = '.team-project/verify/1/T-041/verify.lock'
Put $p $vl ('{"pid":' + $PID + ',"started":"' + (Get-Process -Id $PID).StartTime.ToString('o') + '","mode":"full","at":"2026-11-02 07:15:00"}')
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'ok', '-Root', $p)
Check 'v3.53.3 item 4: done com o verify da Task vivo → ESPERANDO, exit 3, nada fechado' $r 3 @('ESPERANDO — a T-041 ainda tem verify full \(pid \d+', 'encerre o turno')
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
Check 'v3.53.3 item 4: start com o verify da Task vivo → não dispara outro dev, exit 2' $r 2 @('ainda tem verify full', 'Não dispare outro dev')
Remove-Item -LiteralPath (Join-Path $p $vl) -Force
# v3.62.2 (garden, Q-S6d): o verify em processo próprio (job/job.json com o executor vivo) não depende do dev e não acorda
# ninguém — o done não espera o aviso que não vem; o start dispara o dev novo, que reencontra a rodada pelo mesmo comando.
$pd = Join-Path $tmp 'ocupado-desacoplado'; New-Project $pd
Put $pd $vl ('{"pid":' + $PID + ',"started":"' + (Get-Process -Id $PID).StartTime.ToString('o') + '","mode":"full","at":"2026-11-17 13:43:00"}')
$cr62 = (Get-CimInstance Win32_Process -Filter "ProcessId=$PID").CreationDate.ToString('o')
Put $pd '.team-project/verify/1/T-041/job/job.json' ('{"sig":"x","label":"full","tree":"","pid":' + $PID + ',"created":"' + $cr62 + '","at":"2026-11-17 13:43:00"}')
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'ok', '-Root', $pd)
Check 'v3.62.2: done com o verify em processo próprio → não fecha nem espera o aviso; manda o dev novo, que reencontra a rodada' $r 3 @('verify full em processo próprio', 'o dev voltou sem o resultado — não feche', 'run\.ps1 start -Task T-041', 'reencontra esta rodada', 'nenhum vem')
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $pd)
Check 'v3.62.2: start com o verify em processo próprio e sem dev vivo → dispara o dev, com o aviso da rodada (antes: exit 2, esperar a volta)' @{ Code = $r.Code; Out = $r.Out } 0 @('verify: verify full em processo próprio', 'o dev novo roda o MESMO comando do verify e a reencontra', 'Exit 3 do verify = a rodada segue em processo próprio', 'Nunca encerre o turno para esperar um comando', '^(?![\s\S]*ESPERANDO <comando>)')
Put $p '.team-project/sprints/1/plan/T-041a-x.md' "# Plano`n"
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') '[`plan/T-041a-x.md`](plan/)' '[`plan/T-041a-x.md`](plan/T-041a-x.md)'
Put $p '.team-project/.target-lock' ('{"target":"android","owner":"accept T-041","pid":' + $PID + ',"desde":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '"}')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.3 item 4: next com o accept da Task em 🟪 vivo → esperar, exit 3' $r 3 @('esperar — a T-041 ainda tem accept no alvo android \(pid')
Put $p '.team-project/.target-lock' ('{"target":"android","owner":"accept T-099","pid":' + $PID + ',"desde":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '"}')
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'teto', '-Root', $p)
Check 'v3.53.3 item 4: accept de OUTRA Task no alvo não segura o done desta' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'ESPERANDO') { "`nESPEROU" } else { '' }) } 0 @('TETO', '^(?![\s\S]*ESPEROU)')

# 16c. item 2: GAP da prova no alvo → operator pelas capturas antes do Arquiteto; o done segue o veredito dele.
$p = Join-Path $tmp 'gap-alvo'; New-Project $p
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
$dvg = '.team-project/sprints/1/delivery/T-041.md'; $dgr = '.team-project/operator/1/T-041-alvo/diagnostico.md'
Put $p $dvg "## Entrega`n`n🔺 GAP (aceite/alvo): tap tab-button-estufa: tag não encontrada`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $p)
Check 'v3.53.3 item 2: GAP de alvo → operator com as capturas e o caminho do veredito; nada ao Arquiteto' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'team:architect') { "`nXARQ-DISPARADO" } else { '' }) } 0 @('team:operator', 'capturas \*-falha\.png', [regex]::Escape($dgr), 'Veredito: AMBIENTE', 'target\.ps1 -Target android', '^(?![\s\S]*XARQ-DISPARADO)')
Put $p $dgr "Veredito: APP`nA tela da Estufa estava aberta; o botão não existe.`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $p)
$cg = Join-Path $p '.team-project/sprints/1/handoff/T-041.md'
Check 'v3.53.3 item 2: veredito APP → dev em instância nova, cartão com o diagnóstico' @{ Code = $r.Code; Out = $r.Out + "`n" + $(if (Test-Path -LiteralPath $cg) { [System.IO.File]::ReadAllText($cg, $utf8) } else { 'sem cartão' }) } 0 @('diagnosticou APP', 'run\.ps1 start -Task T-041', 'Diagnóstico do alvo \(operator\):\*\* `operator/1/T-041-alvo/diagnostico\.md` · Veredito: APP')
Put $p $dgr "Veredito: PLANO`nO cenário pede um id que nenhuma Task cria.`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Nature', 'desenho', '-Root', $p)
Check 'v3.53.3 item 2: veredito PLANO → Arquiteto com o diagnóstico' $r 0 @('team:architect', 'diagnóstico do operator .*\(veredito PLANO\)')
Put $p $dvg "## Entrega`n`n🔺 GAP (aceite/alvo): tap tab-button-estufa: tag não encontrada`n"
Put $p $dgr "Veredito: AMBIENTE`nA captura mostra a tela inicial do Android.`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $p)
Check 'v3.53.3 item 2: veredito AMBIENTE → rota de queda de ambiente (reparo e dev novo), sem Arquiteto' $r 0 @('diagnosticou AMBIENTE', 'FALHA DE AMBIENTE', 'target\.ps1 -Target android -Repair')
Start-Sleep -Milliseconds 1100
Put $p $dvg "## Entrega 2`n`n🔺 GAP (aceite/alvo): assert-text alertas.titulo`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $p)
Check 'v3.53.3 item 2: GAP de alvo novo depois do diagnóstico → operator de novo' $r 0 @('team:operator')
Put $p $dvg "## Entrega 3`n`n🔺 GAP: o serviço precisa de uma transação que o plano não prevê`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Nature', 'desenho', '-Root', $p)
Check 'v3.53.3 item 2: GAP de desenho (não de alvo) segue direto ao Arquiteto' $r 0 @('team:architect')

# 16d. item 1: launch do android abre do zero e, sem o app na frente, para como AMBIENTE (adb e relógio falsos).
$hs = Join-Path $tmp 'android-harness.ps1'
[System.IO.File]::WriteAllText($hs, @'
param([string]$Adapter, [string]$Case)
$ErrorActionPreference = 'Stop'
. $Adapter
$script:log = New-Object Collections.Generic.List[string]; $script:clock = [datetime]'2026-01-01'
function Start-Sleep { }
function Get-Date { $script:clock = $script:clock.AddSeconds(1); $script:clock }
$script:focus = ''
switch ($Case) { 'outro' { $script:focus = '  mCurrentFocus=Window{2b u0 com.android.launcher3/com.android.launcher3.Launcher}' } 'erro' { $script:focus = '  mCurrentFocus=Window{3c u0 Application Error: br.x}' } 'tap' { $script:focus = '  mCurrentFocus=Window{1a u0 br.x/br.x.MainActivity}' } }
function Sh { $c = $args -join ' '; $script:log.Add($c); if ($c -like 'monkey*' -and $Case -eq 'ok') { $script:focus = '  mCurrentFocus=Window{1a u0 br.x/br.x.MainActivity}' }; if ($c -eq 'dumpsys window') { return @('  x', $script:focus) }; return @() }
function Adb { if (($args -join ' ') -like 'exec-out cat*') { return '<?xml version="1.0"?><hierarchy><node resource-id="br.x:id/alertas.titulo" text="Alertas" bounds="[0,0][100,100]" checked="false" /></hierarchy>' }; return @() }
$script:Pkg = 'br.x'
$step = if ($Case -eq 'tap') { 'tap' } else { 'launch' }; $arg = if ($Case -eq 'tap') { 'tab-button-estufa' } else { '' }
try { Invoke-AndroidStep $step $arg 'x'; 'RESULT=ok' } catch { "RESULT=$($_.Exception.Message)" }
'LOG=' + ($script:log -join ' | ')
'@, $utf8)
$ad = Join-Path $checks 'targets/android.ps1'
$hr = { param($case) $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $hs -Adapter $ad -Case $case 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
$r = & $hr 'ok'
Check 'v3.53.3 item 1: launch fecha o app (force-stop) antes de abrir e volta quando ele fica na frente' $r 0 @('RESULT=ok', 'LOG=am force-stop br\.x \| monkey -p br\.x')
$r = & $hr 'outro'
Check 'v3.53.3 item 1: app que não fica na frente → AMBIENTE com o foco, sem apertar HOME' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'keyevent 3') { "`nHOME" } else { '' }) } 0 @('RESULT=AMBIENTE: o app br\.x não ficou na frente em 3 aberturas', 'launcher3', '^(?![\s\S]*\nHOME)')
$r = & $hr 'erro'
Check 'v3.53.3 item 1: janela de erro do próprio app ao abrir → falha do app, não ambiente' $r 0 @('RESULT=o app br\.x fechou ou travou ao abrir')
$r = & $hr 'tap'
Check 'v3.53.3 item 1: tag não encontrada diz a tela, os ids e os textos visíveis' $r 0 @('RESULT=tag não encontrada: tab-button-estufa \[tela: br\.x/br\.x\.MainActivity · ids: alertas\.titulo · textos: Alertas\]')

# 16e. v3.53.5 — espera com sinal de vida (sprint 5 do garden: o reparo do alvo ficou 81 min parado em "adb emu kill", com
# dono "target.ps1 android" na trava, que o next não via). O reparo segura a Task; parado = POSSÍVEL TRAVAMENTO; o next grava
# a decisão de esperar (.next-verdict, lida pela G20); o /team-status mostra a Task em execução, o comando e a PARADA.
$p = Join-Path $tmp 'espera-pulso'; New-Project $p
Put $p '.team-project/sprints/1/plan/T-041a-x.md' "# Plano`n"
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') '[`plan/T-041a-x.md`](plan/)' '[`plan/T-041a-x.md`](plan/T-041a-x.md)'
$slp = Start-Process powershell -ArgumentList '-NoProfile', '-Command', 'Start-Sleep 600' -PassThru -WindowStyle Hidden
try {
    $tlk = { param($min) Put $p '.team-project/.target-lock' ('{"target":"android","owner":"target.ps1 android","pid":' + $slp.Id + ',"desde":"' + (Get-Date).AddMinutes(-$min).ToString('yyyy-MM-dd HH:mm:ss') + '"}') }
    & $tlk 25
    $r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
    $nvp = Join-Path $p '.team-project/.next-verdict'
    # v3.58.3: a primeira vez da Task não vai ao stakeholder — regra 5 do protocolo de espera (uma tentativa automática).
    $rlp = Join-Path $p '.team-project/sprints/1/run-log.md'
    Check 'v3.58.3: POSSÍVEL TRAVAMENTO na primeira vez da Task → encerrar e retomar sem formulário (comando de encerrar, run-log, sem .next-verdict)' @{ Code = $r.Code; Out = $r.Out + "`nverdict=" + $(if (Test-Path -LiteralPath $nvp) { [System.IO.File]::ReadAllText($nvp, $utf8) } else { 'ausente' }) + "`n" + $(if (Test-Path -LiteralPath $rlp) { [System.IO.File]::ReadAllText($rlp, $utf8) } else { 'sem run-log' }) } 0 @('PRÓXIMA AÇÃO: encerrar e retomar — POSSÍVEL TRAVAMENTO na T-041: reparo/conferência do alvo android \(target\.ps1 android\) \(pid \d+', 'há 25 min · CPU \d+ s', 'sem formulário', 'target\.ps1 -Target android -Kill', 'verdict=ausente', '\| T-041 \| POSSÍVEL TRAVAMENTO → encerrado e retomado sem formulário')
    $r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
    $arp = Join-Path $p '.team-project/.ask-route'
    Check 'v3.58.3: POSSÍVEL TRAVAMENTO de novo na mesma Task → formulário: rota gravada para a G24 e .next-verdict esperar' @{ Code = $r.Code; Out = $r.Out + "`nroute=" + $(if (Test-Path -LiteralPath $arp) { [System.IO.File]::ReadAllText($arp, $utf8) } else { 'ausente' }) + "`nverdict=" + $(if (Test-Path -LiteralPath $nvp) { [System.IO.File]::ReadAllText($nvp, $utf8) } else { 'ausente' }) } 3 @('POSSÍVEL TRAVAMENTO na T-041 de novo', 'leve ao stakeholder num formulário', 'target\.ps1 -Target android -Kill', 'route=\{"rota":"travamento","task":"T-041"', 'verdict=\{"acao":"esperar","task":"T-041"')
    $r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
    Check 'v3.53.5: start com o reparo do alvo vivo não dispara outro dev' $r 2 @('reparo/conferência\s+do\s+alvo\s+android', 'Não\s+dispare\s+outro\s+dev')
    & $tlk 1
    $r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
    Check 'v3.53.5: reparo recente (1 min) → esperar, sem POSSÍVEL TRAVAMENTO' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'POSSÍVEL TRAVAMENTO') { "`nTRAVOU" } else { '' }) } 3 @('esperar — a T-041', 'há 1 min', '^(?![\s\S]*TRAVOU)')
    & $tlk 25
    Put $p '.team-project/.active-task' '{"trilha":"sprint","id":"T-041","plano":".team-project/sprints/1/plan/T-041-export.md"}'
    $r = Invoke-Check 'team-view.ps1' @('-View', 'status', '-Detail', '-Root', $p)
    Check 'v3.53.5: /team-status — Task em execução, há quanto tempo, último sinal de vida e o comando parado' $r 0 @('Em execução: T-041 · .* · há \d+ s \(start às', 'último sinal de vida há', 'comando: reparo/conferência do alvo android .*POSSÍVEL TRAVAMENTO')
} finally { Stop-Process -Id $slp.Id -Force -ErrorAction SilentlyContinue }
Remove-Item -LiteralPath (Join-Path $p '.team-project/.target-lock') -Force
(Get-Item -LiteralPath (Join-Path $p '.team-project/.active-task')).LastWriteTime = (Get-Date).AddMinutes(-40)
Put $p '.team-project/.active-run' '{ "trilha": "sprint", "id": "1", "desde": "2026-11-02 14:31" }'
$r = Invoke-Check 'team-view.ps1' @('-View', 'status', '-Detail', '-Root', $p)
Check 'v3.53.5: /team-status — run em andamento sem agente nem comando há 40 min → PARADA' $r 0 @('Em execução: T-041 .* há 40 min', 'PARADA: o run está em andamento, mas nenhum agente nem comando vivo para a T-041 há 40 min')
$r = Invoke-Check 'team-view.ps1' @('-View', 'status', '-Root', $p)
Check 'v3.59.0: /team-status simples — o mesmo caso em frase simples, com o comando que retoma' $r 0 @('Atenção: nada roda para Exportar o resultado da análise — parte 1 de 2 \(T-041\) há 40 min, com o sprint em andamento — para retomar, digite /sm sprint run\.')
Remove-Item -LiteralPath (Join-Path $p '.team-project/.active-run') -Force
$r = Invoke-Check 'team-view.ps1' @('-View', 'status', '-Detail', '-Root', $p)
Check 'v3.53.5: /team-status — run pausado não soa como PARADA' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'PARADA') { "`nALARME" } else { '' }) } 0 @('run pausado: nada roda para a T-041', '^(?![\s\S]*ALARME)')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
$nvP = Join-Path $p '.team-project/.next-verdict'
Check 'v3.53.5: next sem espera não deixa decisão de esperar (v3.65.7: deixa a ação pendente "agir" do construir, com o executor); v3.58.3: o "construir" apaga a rota ao stakeholder (.ask-route)' @{ Code = $r.Code; Out = $r.Out + "`nverdict=" + $(if (Test-Path -LiteralPath $nvP) { [System.IO.File]::ReadAllText($nvP) } else { 'nenhum' }) + "`nroute=" + (Test-Path -LiteralPath (Join-Path $p '.team-project/.ask-route')) } 0 @('verdict=\{"acao":"agir","task":"","motivo":"disparar team:task-runner — construir T-041', '^(?![\s\S]*"acao":"esperar")', 'PRÓXIMA AÇÃO: construir T-041', 'route=False')
Check 'v3.59.0: next "construir" — a fala ao stakeholder com o nome da parte e o código no fim' $r 0 @('PARA O STAKEHOLDER: Construindo Exportar o resultado da análise — parte 1 de 2 \(T-041\)\.')

# 16f. v3.53.5 — adaptador android: prazo no adb (o processo é encerrado) e a recusa de abrir um segundo emulador.
$fakeSdk = Join-Path $tmp 'fake-sdk'; New-Item -ItemType Directory -Force (Join-Path $fakeSdk 'platform-tools') | Out-Null
$hs2 = Join-Path $tmp 'android-timeout.ps1'
[System.IO.File]::WriteAllText($hs2, @'
param([string]$Adapter, [string]$Sdk)
$ErrorActionPreference = 'Stop'
$env:ANDROID_HOME = $Sdk
. $Adapter
$null = Initialize-Android ([pscustomobject]@{ package = 'br.x' })
$script:Adb = (Get-Command powershell).Source
$sw = [Diagnostics.Stopwatch]::StartNew()
$o = AdbT 2 @('-NoProfile', '-Command', 'Start-Sleep 30')
"TIMEOUT=[$($script:AdbTimeout)] em $([int]$sw.Elapsed.TotalSeconds) s"
$o = AdbT 20 @('-NoProfile', '-Command', 'Write-Output "a b"; Write-Output $args.Count')
"OK=[$($script:AdbTimeout)] SAIDA=$($o -join '|')"
'@, $utf8)
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $hs2 -Adapter (Join-Path $checks 'targets/android.ps1') -Sdk $fakeSdk 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
Check 'v3.53.5: adb sem resposta é encerrado no prazo (2 s, não 30) e o comando vai em $script:AdbTimeout' $r 0 @('TIMEOUT=\[adb -NoProfile -Command Start-Sleep 30 sem resposta em 2 s\] em [2-5] s', 'OK=\[\] SAIDA=a b')

# 17. v3.53.4 — plano externo (guards.json → "run": { "planner": "external" }): pacote por História, retorno conferido
# pelo plan.ps1, correção, GAP em pacote e o piloto por lista de Tasks.
$zipList = { param($z) $za = [System.IO.Compression.ZipFile]::OpenRead($z); try { ($za.Entries | ForEach-Object { $_.FullName }) -join "`n" } finally { $za.Dispose() } }
$zipMake = { param($z, $entries) $fs = [System.IO.File]::Open($z, [System.IO.FileMode]::Create); try { $za = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create); try { foreach ($k in $entries.Keys) { $w = New-Object System.IO.StreamWriter($za.CreateEntry($k).Open(), $utf8); try { $w.Write($entries[$k]) } finally { $w.Dispose() } } } finally { $za.Dispose() } } finally { $fs.Dispose() } }
# v3.57.7 (sprint 6 do garden): a lista "O que a conferência recusa" do roteiro externo ficou atrás do plan.ps1 três entregas
# seguidas (v3.57.5, v3.57.6, e as regras 21/23/26/33 na T-067). Toda regra que o plan.ps1 pode reprovar tem a instrução no
# roteiro, marcada com o nome da linha da tabela entre colchetes: regra nova sem instrução quebra aqui, não no sprint.
$planSrc = [System.IO.File]::ReadAllText((Join-Path $checks 'plan.ps1'), $utf8)
$xtpl = [System.IO.File]::ReadAllText((Join-Path $checks '..\..\roles\architect\templates\external-plan.md'), $utf8)
$xrules = @([regex]::Matches($planSrc, "Add-Result '([^']+)' 'falhou'") | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique)
$xmiss = @($xrules | Where-Object { $xtpl -notmatch ('`\[' + [regex]::Escape($_) + '\]`') })
Check 'v3.57.7: toda regra que o plan.ps1 reprova tem instrução no roteiro do pacote externo ([<regra>])' @{ Code = 0; Out = "regras=$($xrules.Count) faltam=[$($xmiss -join ', ')]" } 0 @('regras=(1[5-9]|[2-9]\d)', 'faltam=\[\]')
$xp = Join-Path $tmp 'externo'; New-Project $xp
Put $xp '.team-project/architect/breakdown/S1.md' $bdText
Put $xp 'src/a.ts' "export const a = 1`nexport const b = 2`nexport const c = 3`n"; Put $xp 'docs/sdd/03-architecture.md' "# Arquitetura`n"
Put $xp '.team-project/guards.json' '{ "run": { "planner": "external", "tasks": [] } }'
$xsb = Join-Path $xp '.team-project/sprints/1/sprint-backlog.md'; $xpk = Join-Path $xp '.team-project/sprints/1/pack'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $xp)
Check 'v3.53.4: planner external → pacote da História gerado (sem Arquiteto) e a Task em construção segue' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'team:architect') { "`nXARQ-DISPARADO" } else { '' }) } 0 @('external plan: pacote H-014 gerado \(T-041a; \d+ KB\)', 'construir T-041 ', '^(?![\s\S]*XARQ-DISPARADO)')
$zl = & $zipList (Join-Path $xpk 'out/H-014.zip')
$ins = [System.IO.File]::ReadAllText((Join-Path $xpk 'out/H-014/INSTRUCTIONS.md'), $utf8)
Check 'v3.53.4: o zip leva o roteiro, a ficha (com o resumo da dependência), o modelo, o ambiente medido e os arquivos da ficha, com "/"' @{ Code = 0; Out = $zl + "`n" + $ins + "`n" + [System.IO.File]::ReadAllText((Join-Path $xpk 'out/H-014/tasks/T-041a-ficha.md'), $utf8) } 0 @('(?m)^INSTRUCTIONS\.md$', '(?m)^tasks/T-041a-ficha\.md$', '(?m)^context/implementation-plan\.md$', '(?m)^context/environment\.md$', '(?m)^files/src/a\.ts$', '(?m)^files/docs/sdd/03-architecture\.md$', '(?m)^files/plugin/standards/implementation-principles\.md$', '`T-041a-plan\.md` — Variante', '`H-014-return\.zip`', '\| 1 \| T-041a \| Variante \| T-041 \|', 'Nunca invente uma saída', '## Plano da dependência — resumo de `sprints/1/plan/T-041-export\.md`')
# v3.60.0: a ficha do pacote traz os trechos nas linhas de hoje, e o roteiro manda citar essas linhas, não as da ficha.
Check 'v3.60.0: pacote externo — a ficha traz os trechos (linhas de hoje) e o roteiro manda usá-los antes de files/' @{ Code = 0; Out = [System.IO.File]::ReadAllText((Join-Path $xpk 'out/H-014/tasks/T-041a-ficha.md'), $utf8) + "`n" + $ins } 0 @('## Trechos que a ficha aponta', '### `src/a\.ts` — linhas 1–3 de 3 · padrão a espelhar', '(?m)^3  export const c = 3$', 'com o número da linha \*\*de hoje\*\*', 'O que faltar, leia em `files/`')
$xb = Join-Path $tmp 'externo-faixa'; New-Project $xb
Put $xb '.team-project/architect/breakdown/S1.md' ($bdText.Replace('`src/a.ts:3` — padrão a espelhar', '`src/a.ts:90-95` — padrão a espelhar'))
Put $xb 'src/a.ts' "export const a = 1`nexport const b = 2`nexport const c = 3`n"; Put $xb 'docs/sdd/03-architecture.md' "# Arquitetura`n"
Put $xb '.team-project/guards.json' '{ "run": { "planner": "external", "tasks": [] } }'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $xb)
Check 'v3.60.0: pacote externo — faixa fora do arquivo volta à correção da ficha antes do pacote' @{ Code = $r.Code; Out = $r.Out + "`npack=" + (Test-Path -LiteralPath (Join-Path $xb '.team-project/sprints/1/pack/out')) } 0 @('corrigir a ficha da T-041a antes do plano — faixa fora do arquivo: src/a\.ts:90-95 \(3 linhas\)', 'pack=False')
Edit-File $xsb "| $($e.qa) T-041 | Endpoint" "| $($e.ok) T-041 | Endpoint"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $xp)
Check 'v3.53.4: sem Task em construção, o run espera o stakeholder (exit 3) e diz onde pegar e onde devolver; a marca libera a G20' @{ Code = $r.Code; Out = $r.Out + "`nmarca=" + (Test-Path -LiteralPath (Join-Path $xp '.team-project/.external-plan')) } 3 @('aguardando o retorno de T-041a \(pacote H-014\)', 'PRÓXIMA AÇÃO: external plan — com o stakeholder', 'pack/out/H-014\.zip \(chat na web\)', 'pack/out/H-014/ \(app do Codex\)', 'devolva o H-014-return\.zip .* em \.team-project/sprints/1/pack/in/', 'marca=True')
$xbase = "**Cenários:** nenhum — interno`n**Risco:** infraestrutura`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`nUsa a tabela export_job.`n`n## 3. Ambiente`n`n| Pré-requisito | Comando de medição | Saída real |`n|---|---|---|`n| Node 20 | node --version | v20.11.0 |`n`n## 6. Testes`nsem prova: x`n`n## 9. Onde parar`n- **Pré-requisito ausente** — 🔺 GAP`n`n### Comandos da Task`n- nenhum além da lista base`n"
$xbad ="# Plano de Implementação — T-041a Variante`n" + $xbase
$xgood = "# Plano de Implementação — T-041a Variante`n**Li além da ficha:** nenhum`n" + $xbase
New-Item -ItemType Directory -Force (Join-Path $xpk 'in') | Out-Null
& $zipMake (Join-Path $xpk 'in/H-014-return.zip') @{ 'T-041a-plan.md' = $xbad; 'src/hack.ts' = 'x' }
$r = Invoke-Check 'run.ps1' @('next', '-Root', $xp)
Check 'v3.53.4: plano reprovado pelo plan.ps1 não entra; arquivo que não é plano é ignorado; sai o pacote de correção com a tabela' @{ Code = $r.Code; Out = $r.Out + "`nplano=" + (Test-Path -LiteralPath (Join-Path $xp '.team-project/sprints/1/plan/T-041a-x.md')) + " hack=" + (Test-Path -LiteralPath (Join-Path $xp 'src/hack.ts')) + "`n" + (& $zipList (Join-Path $xpk 'out/H-014-fix1.zip')) } 3 @('T-041a reprovado pelo plan\.ps1 \(ficha\)', 'ignorado em H-014-return\.zip .*src/hack\.ts', 'pacote H-014-fix1 gerado \(T-041a', 'plano=False hack=False', '(?m)^review/T-041a-check\.txt$', '(?m)^review/T-041a-plan\.md$')
Check 'v3.53.4: o roteiro da correção pede só as linhas falhou' @{ Code = 0; Out = [System.IO.File]::ReadAllText((Join-Path $xpk 'out/H-014-fix1/INSTRUCTIONS.md'), $utf8) } 0 @('## Correção \(rodada 2\)', 'corrija só as linhas `falhou`', '`H-014-fix1-return\.zip`')
Put $xp '.team-project/sprints/1/pack/in/T-041a-plan (1).md' $xgood
$r = Invoke-Check 'run.ps1' @('next', '-Root', $xp)
$xrow = @([System.IO.File]::ReadAllLines($xsb, $utf8) | Where-Object { $_ -match 'T-041a \| Variante' })[0]
Check 'v3.53.4: plano aprovado entra no nome da Planning, o quadro ganha o link e a Task vai à construção; o retorno vai a done/' @{ Code = $r.Code; Out = $r.Out + "`n" + $xrow + "`nin=" + @(Get-ChildItem -LiteralPath (Join-Path $xpk 'in') -File).Count + " done=" + @(Get-ChildItem -LiteralPath (Join-Path $xpk 'done') -File).Count } 0 @('external plan: T-041a aceito \(plan\.ps1 ok\) → sprints/1/plan/T-041a-x\.md', 'construir T-041a', '\[`plan/T-041a-x\.md`\]\(plan/T-041a-x\.md\)', 'in=0 done=2')
Check 'v3.53.4: o run-log registra o pacote, a reprovação e o aceite' @{ Code = 0; Out = [System.IO.File]::ReadAllText((Join-Path $xp '.team-project/sprints/1/run-log.md'), $utf8) } 0 @('external plan: pacote H-014 gerado', 'external plan reprovado pelo plan\.ps1 \(ficha\)', 'external plan aceito \(plan\.ps1 ok\)')
# GAP da Task do plano externo: a decisão vai num pacote, a Task espera.
Edit-File $xsb "| $($e.plan) T-041a |" "| $($e.build) T-041a |"
Put $xp '.team-project/sprints/1/delivery/T-041a.md' "## Entrega`n`n🔺 GAP: o export_job precisa de índice que o plano não prevê`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041a', '-Result', 'gap', '-Nature', 'desenho', '-Root', $xp)
Check 'v3.53.4: 🔺 GAP da Task do plano externo → pacote de decisão, sem Arquiteto nem start' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'team:architect') { "`nXARQ-DISPARADO" } else { '' }) + "`n" + (& $zipList (Join-Path $xpk 'out/T-041a-gap.zip')) } 0 @('decisão vai ao plano externo', 'pack/out/T-041a-gap\.zip', 'não dispare Arquiteto nem start', '(?m)^review/T-041a-plan\.md$', '(?m)^review/T-041a-delivery\.md$', '^(?![\s\S]*XARQ-DISPARADO)')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $xp)
Check 'v3.53.4: com o GAP fora, a Task não é reconstruída — o run espera a decisão (exit 3)' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'construir T-041a') { "`nRECONSTRUIU" } else { '' }) } 3 @('decisão do 🔺 GAP da T-041a: pegue .*T-041a-gap\.zip', '^(?![\s\S]*RECONSTRUIU)')
Put $xp '.team-project/sprints/1/pack/in/T-041a-plan.md' ($xgood.Replace('**Li além da ficha:** nenhum', "**Li além da ficha:** nenhum`n**Decisão do GAP (02/11/2026):** índice em export_job"))
$r = Invoke-Check 'run.ps1' @('next', '-Root', $xp)
Check 'v3.53.4: a decisão do GAP volta aprovada → substitui o plano e a Task volta à construção' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText((Join-Path $xp '.team-project/sprints/1/plan/T-041a-x.md'), $utf8) } 0 @('decisão do 🔺 GAP aceita \(plan\.ps1 ok\)', 'construir T-041a', 'Decisão do GAP \(02/11/2026\)')
# Piloto: com a lista, só as Tasks dela vão para fora — as outras seguem com o Opus.
$xp2 = Join-Path $tmp 'externo-piloto'; New-Project $xp2
Put $xp2 '.team-project/architect/breakdown/S1.md' $bdText
Put $xp2 'src/a.ts' "export const a = 1`nexport const b = 2`nexport const c = 3`n"; Put $xp2 'docs/sdd/03-architecture.md' "# Arquitetura`n"
Put $xp2 '.team-project/guards.json' '{ "run": { "planner": "external", "tasks": ["T-099"] } }'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $xp2)
Check 'v3.53.4: Task fora da lista do piloto → Arquiteto Opus pela ficha, sem pacote' @{ Code = $r.Code; Out = $r.Out + "`npack=" + (Test-Path -LiteralPath (Join-Path $xp2 '.team-project/sprints/1/pack')) } 0 @('plano da T-041a \(História H-014\) pela ficha', 'pack=False')
Put $xp2 '.team-project/guards.json' '{ "run": { "planner": "claude", "tasks": [] } }'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $xp2)
Check 'v3.53.4: planner "claude" (o padrão) → nada muda' $r 0 @('plano da T-041a \(História H-014\) pela ficha')
# Trilha fix: o mini-plano do bloco (fix plan, passo 4) e a decisão do 🔺 GAP (fix run) pelo fix-pack.ps1.
$fx = Join-Path $tmp 'externo-fix'; New-Project $fx; New-FixBlock $fx
Remove-Item -LiteralPath (Join-Path $fx '.team-project/fixes/B-001/plan.md'), (Join-Path $fx '.team-project/fixes/B-001/verdict.md') -Force
Put $fx 'src/Export.cs' "class Export {}`n"; Put $fx 'src/Filter.cs' "class Filter {}`n"
$r = Invoke-Check 'fix-pack.ps1' @('-Block', 'B-001', '-Root', $fx)
Check 'v3.53.4 fix: sem run.planner external, o fix-pack recusa (exit 2) e o passo segue com o Arquiteto' $r 2 @('segue com o Arquiteto')
Put $fx '.team-project/guards.json' '{ "run": { "planner": "external", "tasks": [] } }'
$fpk = Join-Path $fx '.team-project/fixes/B-001/pack'
$r = Invoke-Check 'fix-pack.ps1' @('-Block', 'B-001', '-Root', $fx)
$fins = if (Test-Path -LiteralPath (Join-Path $fpk 'out/B-001/INSTRUCTIONS.md')) { [System.IO.File]::ReadAllText((Join-Path $fpk 'out/B-001/INSTRUCTIONS.md'), $utf8) } else { 'sem roteiro' }
Check 'v3.53.4 fix: pacote do bloco só com as F-IDs em bloco (sem a promovida e a devolvida), exit 3 e onde pegar/devolver' @{ Code = $r.Code; Out = $r.Out + "`n" + (& $zipList (Join-Path $fpk 'out/B-001.zip')) + "`n" + $fins } 3 @('pacote B-001 gerado \(F-001, F-002;', 'PRÓXIMA AÇÃO: external plan', 'fixes/B-001/pack/out/B-001\.zip \(chat na web\)', 'em \.team-project/fixes/B-001/pack/in/', '(?m)^INSTRUCTIONS\.md$', '(?m)^fixes/F-001\.md$', '(?m)^context/fix-plan\.md$', '(?m)^context/pending\.md$', '(?m)^files/src/Export\.cs$', '`B-001-plan\.md`', 'N = 5', '\| F-002 \| ajuste \|')
$r = Invoke-Check 'fix-pack.ps1' @('-Block', 'B-001', '-Root', $fx)
Check 'v3.53.4 fix: sem retorno, só espera (não regera)' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'gerado') { "`nREGEROU" } else { '' }) } 3 @('aguardando o retorno do plano do bloco B-001 \(pacote B-001\)', '^(?![\s\S]*REGEROU)')
$ck2 = [char]::ConvertFromUtf32(0x2714)
$fxs = { param($id, $prod, [switch]$NoMut)
    "## $id · correção`n**Tipo:** defeito · **Ficha:** fixes/$id.md`n### Elegibilidade técnica`n- C5 $ck2 · sem contrato`n- C6 $ck2 · 1 arquivo`n- C7 $ck2 · sem dependência`n- C8 $ck2 · ``${prod}:42```n### Causa`n``${prod}:42`` — laço curto`n### Arquivos`n- produção: ``$prod```n- teste: ``tests/${id}Tests.cs```n### Teste de regressão`n**Nome:** ``ultima_linha`` · **Afirma:** a exportação leva a última linha`n**Comando (só este teste):** ``dotnet test --filter $id```n**Antes da correção, falha com:** ``expected 3, got 2```n" + $(if (-not $NoMut) { "**Mutações:**`n- M$($id.Substring(4)) · teste ``tests/${id}Tests.cs`` · ``$prod`` · ``i <= n`` → ``i < n```n" } else { '' }) + "### Passos`n1. **ALTERAR** ``tests/${id}Tests.cs`` — teste; rodar → exit ≠ 0`n   **Conferência:** o teste existe`n2. **ALTERAR** ``$prod`` — ``i < n`` → ``i <= n```n   **Conferência:** a linha mudou`n3. Rodar o teste → exit 0`n   **Conferência:** depois exit 0`n### Standard aplicável`nnenhuma — validação`n### Onde parar e perguntar`n- o laço não estar na linha 42`n### Revalidação`nn/a — sem mudança`n`n" }
$fhead = "# B-001 · mini-planos`n**Data:** 2026-11-02 10:00 · **Correções:** F-001, F-002 · **Área:** exportação`n`n"
$ftail = "## Verificação do bloco`n**Fonte (R26 por citação):** ``.team-project/developer/context.md`` §Comandos`n"
New-Item -ItemType Directory -Force (Join-Path $fpk 'in') | Out-Null
& $zipMake (Join-Path $fpk 'in/B-001-return.zip') @{ 'B-001-plan.md' = ($fhead + (& $fxs 'F-001' 'src/Export.cs') + (& $fxs 'F-002' 'src/Filter.cs' -NoMut) + $ftail); 'src/Export.cs' = 'hack' }
$r = Invoke-Check 'fix-pack.ps1' @('-Block', 'B-001', '-Root', $fx)
Check 'v3.53.4 fix: plano do bloco reprovado pelo fix.ps1 -PlanOnly (F-002 sem mutação) não entra; o código de fora é ignorado; sai a correção' @{ Code = $r.Code; Out = $r.Out + "`nplano=" + (Test-Path -LiteralPath (Join-Path $fx '.team-project/fixes/B-001/plan.md')) + " codigo=" + [System.IO.File]::ReadAllText((Join-Path $fx 'src/Export.cs'), $utf8).Trim() + "`n" + (& $zipList (Join-Path $fpk 'out/B-001-fix1.zip')) } 3 @('reprovado pelo fix\.ps1 -PlanOnly \(mini-planos\)', 'ignorado em B-001-return\.zip .*src/Export\.cs', 'pacote B-001-fix1 gerado', 'plano=False codigo=class Export \{\}', '(?m)^review/B-001-check\.txt$')
Put $fx '.team-project/fixes/B-001/pack/in/B-001-plan.md' ($fhead + (& $fxs 'F-001' 'src/Export.cs') + (& $fxs 'F-002' 'src/Filter.cs') + $ftail)
$r = Invoke-Check 'fix-pack.ps1' @('-Block', 'B-001', '-Root', $fx)
Check 'v3.53.4 fix: plano do bloco aprovado entra no plan.md e o fix plan segue (exit 0)' @{ Code = $r.Code; Out = $r.Out + "`nplano=" + (Test-Path -LiteralPath (Join-Path $fx '.team-project/fixes/B-001/plan.md')) } 0 @('plano do bloco B-001 aceito \(fix\.ps1 -PlanOnly ok\)', 'nada espera o stakeholder', 'plano=True')
Put $fx '.team-project/fixes/B-001/delivery.md' "## F-001 · entrega`n`n🔺 GAP: o laço está num método gerado; o plano não prevê o gerador`n`n## F-002 · entrega`nok`n"
$r = Invoke-Check 'fix-pack.ps1' @('-Block', 'B-001', '-Gap', 'F-001', '-Root', $fx)
Check 'v3.53.4 fix: 🔺 GAP da F-ID → pacote de decisão com a seção dela e o relatório, sem Arquiteto' @{ Code = $r.Code; Out = $r.Out + "`n" + (& $zipList (Join-Path $fpk 'out/F-001-gap.zip')) + "`n" + [System.IO.File]::ReadAllText((Join-Path $fpk 'out/F-001-gap/review/F-001-delivery.md'), $utf8) } 0 @('a decisão vai ao plano externo', 'F-001 🔺 GAP → external plan F-001-gap', '(?m)^review/F-001-plan\.md$', '(?m)^review/F-001-delivery\.md$', 'método gerado', '^(?![\s\S]*F-002 · entrega)')
$r = Invoke-Check 'fix-pack.ps1' @('-Block', 'B-001', '-Root', $fx)
Check 'v3.53.4 fix: com o GAP fora, o fix-pack diz que a F-ID espera e as outras seguem (exit 3)' $r 3 @('decisão do 🔺 GAP da F-001 \(as outras F-IDs seguem\): pegue .*F-001-gap\.zip')
Put $fx '.team-project/fixes/B-001/pack/in/F-001-plan.md' ((& $fxs 'F-001' 'src/Export.cs').Replace('— `i < n` → `i <= n`', '— `i < n` → `i <= n` (GAP 02/11/2026: alterar o gerador)'))
$r = Invoke-Check 'fix-pack.ps1' @('-Block', 'B-001', '-Root', $fx)
$fpt = [System.IO.File]::ReadAllText((Join-Path $fx '.team-project/fixes/B-001/plan.md'), $utf8)
Check 'v3.53.4 fix: a decisão do GAP aprovada troca só a seção da F-ID no plan.md' @{ Code = $r.Code; Out = $r.Out + "`n" + $fpt } 0 @('F-001 — decisão do 🔺 GAP aceita', 'GAP 02/11/2026: alterar o gerador', '## F-002 · correção', '## Verificação do bloco', '\*\*Data:\*\* 2026-11-02 10:00')
$x2 = [char]::ConvertFromUtf32(0x2718)
$fpromo = "## F-002 · correção`n**Tipo:** ajuste · **Ficha:** fixes/F-002.md`n### Elegibilidade técnica`n- C5 $x2 · muda o contrato da API`n- C6 $ck2 · 1 arquivo`n- C7 $ck2 · sem dependência`n- C8 $ck2 · ``src/Filter.cs:9```n### Arquivos`nn/a — promovida`n### Onde parar e perguntar`n**Critério que caiu:** C5 — muda o contrato da API`n`n"
Put $fx '.team-project/fixes/B-001/plan.md' ($fhead + (& $fxs 'F-001' 'src/Export.cs') + $fpromo + $ftail)
$r = Invoke-Check 'fix.ps1' @('-Block', 'B-001', '-PlanOnly', '-Root', $fx)
Check 'v3.53.4 fix.ps1 -PlanOnly: promoção com o critério que caiu passa e é listada' $r 0 @('\| mini-planos \| ok .*promovida\(s\): F-002', '\| teto \| ok')
Put $fx '.team-project/fixes/B-001/plan.md' ($fhead + (& $fxs 'F-001' 'src/Export.cs') + $fpromo.Replace("**Critério que caiu:** C5 — muda o contrato da API`n", '') + $ftail)
$r = Invoke-Check 'fix.ps1' @('-Block', 'B-001', '-PlanOnly', '-Root', $fx)
Check 'v3.53.4 fix.ps1 -PlanOnly: C5 ✘ sem o critério que caiu volta (exit 1)' $r 1 @('F-002: C5 ✘ sem \*\*Critério que caiu:\*\*', 'O plano do bloco volta')
Put $fx '.team-project/fixes/B-001/plan.md' ($fhead + (& $fxs 'F-001' 'src/Export.cs').Replace('teste `tests/F-001Tests.cs` ·', 'teste `tests/F-001Tests.cs::UltimaLinha` ·') + $fpromo + $ftail)
$r = Invoke-Check 'fix.ps1' @('-Block', 'B-001', '-PlanOnly', '-Root', $fx)
Check 'v3.57.6 fix.ps1 -PlanOnly: teste da mutação com ::NomeDoTeste volta, com o motivo' $r 1 @('F-001: M1: o campo teste traz o nome do teste \(`tests/F-001Tests\.cs::UltimaLinha`\) — escreva só o caminho do arquivo')

# 17b. v3.57.7 (sprint 6 do garden, T-067): o environment.md do pacote é medido pelo run ao montar o pacote, e a referência
# só vem de plano escrito no Claude — o plano externo (Task no state.json) recopiava a §3 "sem medição" do pacote anterior.
$ev = Join-Path $tmp 'env-medido'; New-Item -ItemType Directory -Force $ev | Out-Null
Put $ev 'front/package.json' '{ "name": "x" }'; Put $ev 'front/angular.json' '{}'
Put $ev 'front/node_modules/@angular/core/package.json' '{ "version": "20.3.1" }'
Put $ev '.team-project/sprints/1/pack/state.json' '{ "packs": { "H-1": { "name": "H-1", "round": 1, "tasks": ["T-050"], "rejected": [], "at": "" } }, "gaps": {} }'
Put $ev '.team-project/sprints/1/plan/T-041-y.md' "# Plano`n`n## 3. Ambiente`n`n| Pré-requisito | Comando de medição | Saída real |`n|---|---|---|`n| Node | node --version | v20.11.0 |`n`n## 4. Passos`n"
Put $ev '.team-project/sprints/1/plan/T-050-x.md' "# Plano`n`n## 3. Ambiente`n`n| Pré-requisito | Comando de medição | Saída real |`n|---|---|---|`n| Node | node --version | sem medição no pacote |`n`n## 4. Passos`n"
(Get-Item -LiteralPath (Join-Path $ev '.team-project/sprints/1/plan/T-041-y.md')).LastWriteTime = (Get-Date).AddHours(-2)
$fakeChrome = Join-Path $tmp 'fake-chrome.cmd'; [System.IO.File]::WriteAllText($fakeChrome, "@echo ^<html^>^<body^>^</body^>^</html^>`r`n", [System.Text.Encoding]::ASCII)
$hs3 = Join-Path $tmp 'pack-env.ps1'
[System.IO.File]::WriteAllText($hs3, @'
param([string]$Checks, [string]$Root, [string]$Chrome)
$ErrorActionPreference = 'Stop'
. (Join-Path $Checks 'lib.ps1')
$n = '1'; $S = Join-Path $Root '.team-project/sprints/1'; $utf8 = New-Object System.Text.UTF8Encoding($false); $tasks = @()
. (Join-Path $Checks 'external-plan.ps1')
$env:CHROME_BIN = $Chrome
$ctx = Join-Path $Root 'ctx'; New-Item -ItemType Directory -Force $ctx | Out-Null
Write-PackEnv $ctx
[System.IO.File]::ReadAllText((Join-Path $ctx 'environment.md'), $utf8)
"LOG=" + (Test-Path -LiteralPath (Join-Path $S 'pack/environment.log'))
'@, $utf8)
$runEnv = { param($c) & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $hs3 -Checks $checks -Root $ev -Chrome $c 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } } }
$r = & $runEnv $fakeChrome
Check 'v3.57.7: environment.md medido ao montar o pacote — tabela no formato da §3, headless aberto (sim), Angular lido do node_modules, premissas prontas e a saída bruta em pack/' $r 0 @('Medido pelo `run\.ps1` do plugin ao montar este pacote', '\| Node\.js \| `node --version` \| ', '\| Angular \(@angular/core instalado\) \| `[^`|]+` \| 20\.3\.1 \| .* \| \*\*sim\*\* \|', '\| Navegador headless do teste de render \| `[^`]+` \| abriu headless e devolveu o DOM \(exit 0\) · CHROME_BIN \| .* \| \*\*sim\*\* \|', '(?m)^- P\d+ · ambiente: Navegador headless do teste de render · medido: `[^`]+` → abriu headless', 'LOG=True')
Check 'v3.57.7: a referência vem do plano escrito no Claude (T-041), nunca do plano externo (T-050, no state.json do pacote)' $r 0 @('Fonte: `sprints/1/plan/T-041-y\.md`', '^(?![\s\S]*T-050-x\.md)')
$r = & $runEnv (Join-Path $tmp 'nao-existe\chrome.exe')
Check 'v3.57.7: CHROME_BIN apontando para arquivo que não existe → headless **não**, sem premissa pronta dele' $r 0 @('\| Navegador headless do teste de render \| .*CHROME_BIN aponta para arquivo que não existe.*\| \*\*não\*\* — ', '^(?![\s\S]*ambiente: Navegador headless)')

# 18. v3.53.6 parte B (sprint 5 do garden) — item 4: ids de teste conferidos no verify -Mode full (chave testids): id do .scn
# da Task fora do código e controle interativo sem id reprovam, com o .scn ou arquivo:linha; exceção "sem-testid: <motivo>".
$p = Join-Path $tmp 'testids'; New-Project $p
$ErrorActionPreference = 'Continue'
& git -C $p init -q 2>$null; Put $p '.gitignore' ".team-project/`nbuild/`n"; Put $p 'README.md' "x`n"
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output \"Build succeeded\"" } }'
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') 'SC-014 (novo)' 'SC-014 (novo) · SC-015 · SC-016 (teste)'
Edit-File (Join-Path $p '.team-project/sprints/1/plan/T-041-export.md') '## 3. Ambiente' ("**Arquivos tocados:** ``app/src/main/java/x/Tela.kt```n``web/src/Form.tsx```n``web/src/app/lista.html```n`n## 3. Ambiente")
Put $p '.team-project/quality-assurance/scenarios/H-014.scn' "# aguarda T-099: SC-015`nscenario SC-014 Salva`nlaunch`ntap horta.salvar`nassert-text horta.titulo = Horta`nassert-count lista.item. = 2`nassert-exists lista.item.7`ntype form.nome = Ana`n`nscenario SC-015 Depois`nlaunch`nassert-exists outro.id`n`nscenario SC-016 Teste`nlaunch`nassert-exists so.no.teste`n"
$kt = @'
package x
const val TITULO = "horta.titulo"
@Composable
fun Tela(itens: List<Item>, modifier: Modifier = Modifier) {
    Button(onClick = { salvar() }, modifier = Modifier.testTag("horta.salvar")) { Text("Salvar (já)") }
    LazyColumn {
        items(itens, key = { it.id }) { Card(Modifier.fillMaxWidth().testTag("lista.item.${it.id}")) { Text(it.nome) } }
    }
    // sem-testid: o testTag vem no modifier do chamador
    IconButton(onClick = {}, modifier = modifier) { Icon(Icons.Default.Add, null) }
}
'@
Put $p 'app/src/main/java/x/Tela.kt' $kt
Put $p 'web/src/Form.tsx' "export function Form() {`n  return (<form>`n    <input data-testid=`"form.nome`" onChange={(e) => set(e.target.value)} />`n    {/* sem-testid: link decorativo do rodapé */}`n    <a href=`"/sobre`">Sobre</a>`n    <input type=`"hidden`" name=`"t`" />`n  </form>)`n}`n"
Put $p 'web/src/app/lista.html' "<button data-testid=`"lista.limpar`" (click)=`"limpar()`">Limpar</button>`n<a [attr.data-testid]=`"'lista.link.' + i.id`" [routerLink]=`"i.url`">ver</a>`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.53.6 item 4: ids do .scn no código (literal, constante, dinâmico) e todo controle com id → testids exit 0' $r 0 @('tudo exit 0', 'testids: exit 0 .*ids de teste: 5 id\(s\) dos cenários no código, 3 arquivo\(s\) de tela')
$res = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/verify/1/T-041/result.json'), $utf8)
Check 'v3.53.6 item 4: testids vai ao result.json como comando do full' @{ Code = 0; Out = $res } 0 @('"key":\s+"testids"')
# Reprovação: id do .scn sem o código (só num teste), controles sem testTag, exceção sem motivo.
Put $p 'app/src/androidTest/java/x/TelaTest.kt' "class TelaTest { val t = `"horta.salvar`" }`n"
$kt2 = $kt.Replace('modifier = Modifier.testTag("horta.salvar")', 'modifier = Modifier.padding(4.dp)').Replace('.testTag("lista.item.${it.id}")', '.clickable { abrir(it) }').Replace('// sem-testid: o testTag vem no modifier do chamador', '// sem-testid:') + "`n@Composable`nfun Opcao() {`n    Switch(`n        checked = true,`n        onCheckedChange = {}`n    )`n    Text(`"x`", Modifier.clickable { }.padding(2.dp).testTag(`"opcao.texto`"))`n}`n"
Put $p 'app/src/main/java/x/Tela.kt' $kt2
Put $p 'web/src/app/lista.html' "<button (click)=`"limpar()`">Limpar</button>`n<!-- sem-testid: -->`n<select [(ngModel)]=`"x`"></select>`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.53.6 item 4: id do .scn fora do código (o do teste não conta) e controles sem id → exit 1 com .scn e arquivo:linha' $r 1 @(
    'testids: exit 1', 'id ausente no código: horta\.salvar — SC-014 \(\.team-project/quality-assurance/scenarios/H-014\.scn:4\)',
    'id ausente no código: lista\.item\. \(prefixo\) — SC-014', 'id ausente no código: lista\.item\.7 — SC-014',
    'sem id de teste: app/src/main/java/x/Tela\.kt:5 — Button\( sem testTag\( no modifier', 'Tela\.kt:7 — \.clickable sem testTag\( na mesma cadeia',
    'Tela\.kt:7 — items\( da lista sem testTag\( no item', 'Tela\.kt:10 — IconButton\( sem testTag\( no modifier \(a exceção .sem-testid:. está sem motivo\)',
    'Tela\.kt:14 — Switch\( sem testTag', 'web/src/app/lista\.html:1 — <button sem data-testid', 'lista\.html:3 — <select sem data-testid \(a exceção',
    '^(?![\s\S]*outro\.id)', '^(?![\s\S]*so\.no\.teste)', '^(?![\s\S]*Tela\.kt:18)', '^(?![\s\S]*Form\.tsx)', 'o dev cria no código o id que o \.scn cita')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'check', '-Root', $p)
Check 'v3.53.6 item 4: verify check vê o full com testids reprovado' $r 1 @('full com falha', 'testids: exit 1')
# v3.57.0 (item 7): id que só existe em tempo de execução, declarado dinâmico — pelo guards.json ou por comentário no código —
# não reprova (fica listado como não conferido); o que não foi declarado continua reprovando.
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output \"Build succeeded\"" }, "testIds": { "dynamic": ["lista.item.*"] } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.57.0 item 7: testIds.dynamic ["lista.item.*"] → lista.item. e lista.item.7 não reprovam (listados como não conferidos); horta.salvar e os controles seguem reprovando' $r 1 @('ids de teste: id dinâmico declarado \(lista\.item\.\*\), não conferido estaticamente: lista\.item\.7 — SC-014', 'ids de teste: id dinâmico declarado \(lista\.item\.\*\), não conferido estaticamente: lista\.item\. — SC-014', 'id ausente no código: horta\.salvar', '^(?![\s\S]*id ausente no código: lista\.item)')
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output \"Build succeeded\"" } }'
Put $p 'app/src/main/java/x/Tela.kt' ($kt2 + "`n// testid-dinamico: lista.item.* — montado pelo LazyColumn a partir da chave da entidade`n")
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.57.0 item 7: "// testid-dinamico: lista.item.* — <motivo>" no código vale como a declaração do guards.json' $r 1 @('id dinâmico declarado \(lista\.item\.\*\), não conferido estaticamente: lista\.item\.7', '^(?![\s\S]*id ausente no código: lista\.item)', 'id ausente no código: horta\.salvar')
# v3.57.0 (item 7): controles com "id" e o atributo não declarado — o gate assumia data-testid e reprovava sem dizer por quê.
$pi = Join-Path $tmp 'v3570-attr'; New-Project $pi
$ErrorActionPreference = 'Continue'
& git -C $pi init -q 2>$null; Put $pi '.gitignore' ".team-project/`nbuild/`n"; Put $pi 'README.md' "x`n"
& git -C $pi add -A 2>$null; & git -C $pi -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $pi '.team-project/guards.json' '{ "verify": { "build": "Write-Output \"Build succeeded\"" } }'
Edit-File (Join-Path $pi '.team-project/sprints/1/plan/T-041-export.md') '## 3. Ambiente' ("**Arquivos tocados:** ``web/src/app/lista.html```n`n## 3. Ambiente")
Put $pi 'web/src/app/lista.html' "<button id=`"limpar`" (click)=`"limpar()`">Limpar</button>`n<input id=`"nome`" />`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pi)
Check 'v3.57.0 item 7: controles com id e atributo não declarado → reprova, mas diz que o gate assumiu data-testid e que o stakeholder declara testIds.attribute' $r 1 @('testids: exit 1', 'ids de teste: atributo de teste não declarado: o gate assumiu data-testid, mas 2 dos 2 controle\(s\) sem data-testid têm id', 'testIds\.attribute: "id"')
Put $pi '.team-project/guards.json' '{ "verify": { "build": "Write-Output \"Build succeeded\"" }, "testIds": { "attribute": "id" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pi)
Check 'v3.57.0 item 7: com testIds.attribute "id" declarado, os mesmos controles passam e não há aviso' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'atributo de teste não declarado') { "`nAVISOU" }) } 0 @('tudo exit 0', '^(?![\s\S]*AVISOU)')

# v3.55.0 (C2/C3): atributo configurável (testIds.attribute), controles do Ionic, item de lista e raiz da tela.
$pa = Join-Path $tmp 'v355-attr'; New-Item -ItemType Directory -Force $pa | Out-Null
$e0b = $e   # o lib.ps1 dentro de & { } define $script:E, que é o mesmo $e do teste (PowerShell não distingue maiúsculas): guarda e devolve
$ui = & {
    . (Join-Path $checks 'lib.ps1')
    $o = @()
    $n = { param($rel, $txt, $attr) "{0}" -f @(Find-UntaggedUi $rel $txt $attr).Count }
    $o += 'ION-SEM-ID=' + (& $n 'a.html' "<ion-button>Salvar</ion-button>`n" 'id') + ' ' + (@(Find-UntaggedUi 'a.html' "<ion-button>Salvar</ion-button>`n" 'id') -join '|')
    $o += 'ION-COM-ATTR=' + (& $n 'a.html' "<ion-button [attr.id]=`"'a.b'`">Salvar</ion-button>`n" 'id')
    $o += 'ION-TAB=' + (& $n 'a.html' "<ion-tab-button tab=`"estufa`"><ion-label>Estufa</ion-label></ion-tab-button>`n" 'id')
    $o += 'ION-ITEM-SIMPLES=' + (& $n 'a.html' "<ion-item><ion-label>x</ion-label></ion-item>`n" 'id')
    $o += 'ION-ITEM-CLICK=' + (& $n 'a.html' "<ion-item button (click)=`"abrir()`">x</ion-item>`n" 'id')
    $o += 'PAGINA-SEM-ID=' + (& $n 'x/home.page.html' "<ion-header></ion-header>`n<ion-content></ion-content>`n" 'id') + ' ' + (@(Find-UntaggedUi 'x/home.page.html' "<ion-header></ion-header>`n<ion-content></ion-content>`n" 'id') -join '|')
    $o += 'PAGINA-CONTENT-ID=' + (& $n 'x/home.page.html' "<ion-header></ion-header>`n<ion-content id=`"home.lista`"></ion-content>`n" 'id')
    $o += 'PAGINA-RAIZ-ID=' + (& $n 'x/home.page.html' "<!-- comentario -->`n<div id=`"home`"><ion-content></ion-content></div>`n" 'id')
    $o += 'COMPONENTE-SEM-RAIZ=' + (& $n 'x/card.component.html' "<div></div>`n" 'id')
    $o += 'LISTA-NGFOR=' + (& $n 'a.html' "<ion-item *ngFor=`"let h of hortas`"><ion-label>x</ion-label></ion-item>`n" 'id')
    $o += 'LISTA-NGFOR-ID=' + (& $n 'a.html' "<ion-item *ngFor=`"let h of hortas`" [attr.id]=`"'horta.item.' + h.id`"><ion-label>x</ion-label></ion-item>`n" 'id')
    $o += 'LISTA-AT-FOR=' + (& $n 'a.html' "@for (h of hortas; track h.id) {`n  <li>{{ h.nome }}</li>`n}`n" 'id')
    $o += 'ID-REPROVA-TESTID=' + (& $n 'a.html' "<button data-testid=`"x.salvar`">ok</button>`n" 'id')
    $o += 'ID-PASSA-ID=' + (& $n 'a.html' "<button id=`"x.salvar`">ok</button>`n" 'id')
    $o += 'ID-NAO-E-DATA-ID=' + (& $n 'a.html' "<button data-id=`"3`" class=`"hidden`">ok</button>`n" 'id')
    $o += 'TESTID-PASSA=' + (& $n 'a.html' "<button data-testid=`"x.salvar`">ok</button>`n" 'data-testid')
    $o += 'TESTID-REPROVA-ID=' + (& $n 'a.html' "<button id=`"x.salvar`">ok</button>`n" 'data-testid')
    Put $pa '.team-project/guards.json' '{ "testIds": { "attribute": "id" }, "targets": { "web": { "testIdAttribute": "data-testid" } } }'
    $o += 'ATTR-GUARDS=' + (Get-TestIdAttribute $pa)
    Put $pa '.team-project/guards.json' '{ "targets": { "web": { "testIdAttribute": "data-qa" } } }'
    $o += 'ATTR-TARGETS=' + (Get-TestIdAttribute $pa)
    Put $pa '.team-project/guards.json' '{ "targets": {} }'
    $o += 'ATTR-PADRAO=' + (Get-TestIdAttribute $pa)
    $o -join "`n"
}
$e = $e0b
Check 'v3.55.0 C3: ion-button sem id reprova; com [attr.id] passa; ion-tab-button e ion-item simples são isentos; ion-item com button pede id' @{ Code = 0; Out = $ui } 0 @('ION-SEM-ID=1 a\.html:1 — <ion-button sem id', 'ION-COM-ATTR=0', 'ION-TAB=0', 'ION-ITEM-SIMPLES=0', 'ION-ITEM-CLICK=1')
Check 'v3.55.0 C3: página sem id na raiz nem no ion-content reprova; id no ion-content ou na raiz passa; componente fora de *.page.html não é conferido' @{ Code = 0; Out = $ui } 0 @('PAGINA-SEM-ID=1 x/home\.page\.html:1 — raiz da tela', 'PAGINA-CONTENT-ID=0', 'PAGINA-RAIZ-ID=0', 'COMPONENTE-SEM-RAIZ=0')
Check 'v3.55.0 C3: item de lista (*ngFor e @for) em ion-item/li pede id' @{ Code = 0; Out = $ui } 0 @('LISTA-NGFOR=1', 'LISTA-NGFOR-ID=0', 'LISTA-AT-FOR=1')
Check 'v3.55.0 C2: com o atributo "id", <button id> passa e <button data-testid> reprova; "data-id" não vale como id; sem a chave o comportamento atual se mantém' @{ Code = 0; Out = $ui } 0 @('ID-REPROVA-TESTID=1', 'ID-PASSA-ID=0', 'ID-NAO-E-DATA-ID=1', 'TESTID-PASSA=0', 'TESTID-REPROVA-ID=1')
Check 'v3.55.0 C2: precedência testIds.attribute → targets.web.testIdAttribute → data-testid' @{ Code = 0; Out = $ui } 0 @('ATTR-GUARDS=id', 'ATTR-TARGETS=data-qa', 'ATTR-PADRAO=data-testid')

# v3.55.0 (C5/D1): ids.ps1 -Map gera o mapa do código (literais e prefixos); -Audit grava as seis seções e sai sempre com 0.
$pi = Join-Path $tmp 'v355-ids'; New-Project $pi
$ErrorActionPreference = 'Continue'
& git -C $pi init -q 2>$null
$ErrorActionPreference = 'Stop'
Put $pi '.team-project/guards.json' '{ "testIds": { "attribute": "id" } }'
Put $pi 'capacitor.config.ts' "export default { appId: 'br.x' };`n"
Put $pi 'src/app/horta/horta.page.html' "<ion-content id=`"horta.lista`">`n  <ion-item *ngFor=`"let h of hortas`" [attr.id]=`"'horta.lista.item.' + h.id`"><ion-label>x</ion-label></ion-item>`n  <ion-button id=`"horta.lista.novo`">Novo</ion-button>`n</ion-content>`n"
Put $pi 'src/app/manejo/manejo.page.html' "<div id=`"manejo.form`">`n  <ion-input id=`"manejo.form.nome`"></ion-input>`n  <ion-button>sem id</ion-button>`n  <span id=`"Manejo_Ruim`">x</span>`n  <p id=`"manejo.linha.{{ m.id }}`">y</p>`n</div>`n"
Put $pi 'src/app/onb/onb.page.html' "<ion-content id=`"onboarding`"><ion-button id=`"onboarding.pular`">Pular</ion-button></ion-content>`n"
Put $pi 'scripts/capturar.mjs' "await tocarTexto('Pular');`n"
Put $pi '.team-project/quality-assurance/scenarios/H-001.scn' "scenario SC-001 Lista`nlaunch`ntap horta.lista.novo`ntap horta.inexistente`nassert-count horta.lista.item. = 2`n"
$r = Invoke-Check 'ids.ps1' @('-Map', '-Root', $pi)
$mapTxt = [System.IO.File]::ReadAllText((Join-Path $pi '.team-project/architect/ids-map.md'), $utf8)
Check 'v3.55.0 C5: -Map grava o mapa com as duas telas, ids literais e prefixos dinâmicos' @{ Code = $r.Code; Out = $r.Out + "`n" + $mapTxt } 0 @('gerado por ids\.ps1 — não editar', '## src/app/horta/horta\.page\.html', '`horta\.lista\.novo`', '`horta\.lista\.item\.<…>`', '## src/app/manejo/manejo\.page\.html', '`manejo\.form\.nome`', '`manejo\.linha\.<…>`')
$r = Invoke-Check 'ids.ps1' @('-Audit', '-Root', $pi)
$audTxt = [System.IO.File]::ReadAllText((Join-Path $pi '.team-project/architect/ids-audit.md'), $utf8)
Check 'v3.55.0 D1: -Audit grava as seis seções (atributo, sem id, gramática, .scn, texto, planos) e sai com 0' @{ Code = $r.Code; Out = $audTxt } 0 @(
    '## 1\. Atributo do id', 'Detectado pela stack: `id` — app híbrido \(capacitor\.config\.ts\)', 'Coincidem', '## 2\. Telas e controles sem id', 'manejo\.page\.html',
    '## 3\. Ids fora da gramática', '`Manejo_Ruim`', '## 4\. Ids dos cenários \(\.scn\) que não existem no código', '`horta\.inexistente`', '^(?![\s\S]*`horta\.lista\.novo` em `\.team-project)',
    '## 5\. Seletores por texto', 'scripts/capturar\.mjs:1', 'já existe o id `onboarding\.pular`', '## 6\. Planos do sprint aberto')
Check 'v3.55.0 D1: -Audit só lê — o código não muda e o resumo sai em uma linha' @{ Code = $r.Code; Out = $r.Out } 0 @('ids -Audit: atributo id \(detectado id\)', 'fora da gramática: 1', '\.scn sem id no código: 1', 'por texto: 1')
$r = Invoke-Check 'ids.ps1' @('-Root', $pi)
Check 'v3.55.0 C5: sem -Map nem -Audit é erro de uso (exit 2)' $r 2 @('use -Map')

# 18b. v3.53.6 parte B — itens 5 e 7 no adaptador android (sem adb): memória do emulador, reinício no primeiro accept da
# Task e APK mais velho que o código do módulo.
$hs3 = Join-Path $tmp 'android-b.ps1'
[System.IO.File]::WriteAllText($hs3, @'
param([string]$Adapter, [string]$Work)
$ErrorActionPreference = 'Stop'
. $Adapter
"MB1=" + (ConvertTo-MemoryMB '2.5GiB / 7.6GiB'); "MB2=" + (ConvertTo-MemoryMB '1500'); "MB3=" + (ConvertTo-MemoryMB '512MiB'); "MB4=" + (ConvertTo-MemoryMB '800 MB'); "MB5=[" + (ConvertTo-MemoryMB 'sem número') + "]"
$script:AdCfg = [pscustomobject]@{ memoryCmd = 'Write-Output "3.5GiB / 8GiB"'; maxMemoryMB = 3072 }
"MEM1=" + (Test-AndroidMemory)
$script:AdCfg = [pscustomobject]@{ memoryCmd = 'Write-Output "3.5GiB / 8GiB"'; maxMemoryMB = 4096 }
"MEM2=[" + (Test-AndroidMemory) + "]"
$script:AdCfg = [pscustomobject]@{ memoryCmd = 'Write-Output "nada"'; maxMemoryMB = 100 }
"MEM3=[" + (Test-AndroidMemory) + "]"
$d = Join-Path $Work 'accept/1/T-041'
$rep = [pscustomobject]@{ repair = 'docker restart x' }
"FS1=" + (Test-AndroidFreshStartDue $rep $d $false)
"FS2=" + (Test-AndroidFreshStartDue $rep $d $true)
"FS3=" + (Test-AndroidFreshStartDue ([pscustomobject]@{ repair = 'docker restart x'; freshStart = $false }) $d $false)
"FS4=" + (Test-AndroidFreshStartDue ([pscustomobject]@{ avd = 'Pixel' }) $d $false)
Set-AndroidFreshStartDone $d 'T-041'
"FS5=" + (Test-AndroidFreshStartDue $rep $d $false)
$apk = Join-Path $Work 'app/build/outputs/apk/debug/app-debug.apk'; $kt = Join-Path $Work 'app/src/main/java/x/A.kt'; $tst = Join-Path $Work 'app/src/test/java/x/ATest.kt'
foreach ($f in $apk, $kt, $tst) { New-Item -ItemType Directory -Force (Split-Path $f) | Out-Null; Set-Content -LiteralPath $f 'x' }
(Get-Item $apk).LastWriteTime = (Get-Date).AddMinutes(-30); (Get-Item $kt).LastWriteTime = (Get-Date).AddMinutes(-60); (Get-Item $tst).LastWriteTime = (Get-Date)
$s = Get-ApkStaleness $apk; "AP1=$($s.Stale)|$($s.Note)"
(Get-Item $kt).LastWriteTime = (Get-Date).AddMinutes(-5)
$s = Get-ApkStaleness $apk; "AP2=$($s.Stale)|$(Split-Path $s.File -Leaf)|$($s.Task)"
$out = Join-Path $Work 'solto.apk'; Set-Content -LiteralPath $out 'x'
$s = Get-ApkStaleness $out; "AP3=$($s.Stale)|$($s.Note)"
# v3.57.1 (note.md item 4): app híbrido com o APK fora de build/outputs (garden: build no Docker, APK em source/dist/<nome>-<T-ID>-debug.apk)
$hg = Join-Path $Work '.team-project'; New-Item -ItemType Directory -Force $hg | Out-Null
Set-Content -LiteralPath (Join-Path $hg 'guards.json') '{ "targets": { "android": { "package": "br.x", "apk": "source/dist/app-*-debug.apk", "apkSources": ["source/src", "source/capacitor.config.ts"] } } }' -Encoding UTF8
$a1 = Join-Path $Work 'source/dist/app-T-001-debug.apk'; $a2 = Join-Path $Work 'source/dist/app-T-002-debug.apk'; $ts = Join-Path $Work 'source/src/app/tela.ts'; $sp = Join-Path $Work 'source/src/app/tela.spec.ts'; $cc = Join-Path $Work 'source/capacitor.config.ts'
foreach ($f in $a1, $a2, $ts, $sp, $cc) { New-Item -ItemType Directory -Force (Split-Path $f) | Out-Null; Set-Content -LiteralPath $f 'x' }
Set-Content -LiteralPath $a2 'build T-002'   # v3.65.10: dois builds de verdade (igual byte a byte, o segundo seria cópia do primeiro)
(Get-Item $a1).LastWriteTime = (Get-Date).AddMinutes(-60); (Get-Item $a2).LastWriteTime = (Get-Date).AddMinutes(-30); (Get-Item $ts).LastWriteTime = (Get-Date).AddMinutes(-45); (Get-Item $cc).LastWriteTime = (Get-Date).AddMinutes(-50); (Get-Item $sp).LastWriteTime = (Get-Date)
$pa = Get-ProjectApk $Work; "AP4=$(Split-Path $pa -Leaf)"
$s = Get-ApkStaleness $pa $Work; "AP5=$($s.Stale)|$($s.Note)"
(Get-Item $ts).LastWriteTime = (Get-Date).AddMinutes(-5)
$s = Get-ApkStaleness $pa $Work; "AP6=$($s.Stale)|$(Split-Path $s.File -Leaf)|$($s.Task)"
$script:AdCfg = [pscustomobject]@{ apk = 'source/dist/app-*-debug.apk' }; "AP7=$(Split-Path (Resolve-AndroidApk $Work '') -Leaf)"
Set-Content -LiteralPath (Join-Path $hg 'guards.json') '{ "targets": { "android": { "package": "br.x", "apk": "source/dist/app-*-debug.apk" } } }' -Encoding UTF8
$s = Get-ApkStaleness $pa $Work; "AP8=$($s.Stale)|$($s.Note)"
# v3.62.0: o id é só o resource-id — o content-desc (v3.57.1) não acha mais; WebView sem nenhum id do app = app híbrido
$script:Nodes = @([pscustomobject]@{ Id = ''; Text = 'Estufa'; Desc = 'tab-button-estufa'; X1 = 1; Y1 = 1; X2 = 9; Y2 = 9 }, [pscustomobject]@{ Id = 'geral.card'; Text = 'B9'; Desc = ''; X1 = 1; Y1 = 1; X2 = 9; Y2 = 9 }, [pscustomobject]@{ Id = 'geral.card'; Text = 'outro'; Desc = ''; X1 = 1; Y1 = 1; X2 = 9; Y2 = 9 })
"FD1=[$((Find 'tab-button-estufa').Text)]|FD2=$((Find 'geral.card').Text)|FD3=[$((Find 'inexistente').Text)]"
$wv = [pscustomobject]@{ Id = ''; Class = 'android.webkit.WebView' }
"HY1=$(Test-HybridWithoutIds @($wv, [pscustomobject]@{ Id = 'content'; Class = 'android.widget.FrameLayout' }))|HY2=$(Test-HybridWithoutIds @($wv, [pscustomobject]@{ Id = 'tela.lista'; Class = 'android.view.View' }))|HY3=$(Test-HybridWithoutIds @([pscustomobject]@{ Id = ''; Class = 'android.widget.TextView' }))"
# v3.57.2 (item 19): o accept instala por cima (mantém a base); só desinstala quando o Android recusa a atualização
$script:Pkg = 'br.x'; $script:calls = @(); $script:mode = 'ok'
function AdbT([int]$Sec, [string[]]$A) { $script:calls += ($A -join ' '); if ($script:mode -eq 'ok' -or ($A[0] -eq 'install' -and @($script:calls | Where-Object { $_ -like 'uninstall*' }).Count)) { 'Success' } elseif ($A[0] -eq 'install') { 'Failure [INSTALL_FAILED_UPDATE_INCOMPATIBLE: Package br.x signatures do not match]' } else { 'Success' } }
$ie = Install-AndroidApk $a2; "IN1=[$ie]|$(@($script:calls | ForEach-Object { ($_ -split ' ')[0..1] -join ' ' }) -join ';')|NOTE=[$($script:InstallNote)]"
$script:calls = @(); $script:mode = 'assinatura'; $ie = Install-AndroidApk $a2; "IN2=[$ie]|$(@($script:calls | ForEach-Object { ($_ -split ' ')[0..1] -join ' ' }) -join ';')|NOTE=[$($script:InstallNote)]"
# v3.58.4: liberar o emulador entre Tasks — quem pode ser desligado, por qual porta, e o emulador recém-ligado que já conta como limpo
$script:Serial = 'localhost:5555'; "RB1=" + (Get-AndroidReleaseBlock ([pscustomobject]@{ repair = 'x' }))
$script:Serial = 'emulator-5556'; "RB2=" + (Get-AndroidReleaseBlock ([pscustomobject]@{ package = 'br.x' })); "RB3=[" + (Get-AndroidReleaseBlock ([pscustomobject]@{ repair = 'x' })) + "]"; "RB4=[" + (Get-AndroidReleaseBlock ([pscustomobject]@{ avd = 'Pixel' })) + "]"
"PT1=" + (Get-AndroidConsolePort); $script:Serial = ''; "PT2=" + (Get-AndroidConsolePort)
"FM1=" + (Get-AndroidFreshMinutes ([pscustomobject]@{ repair = 'x' })) + "|FM2=" + (Get-AndroidFreshMinutes ([pscustomobject]@{ freshStartMinutes = 10 }))
function AdbT([int]$Sec, [string[]]$A) { $script:AdbTimeout = ''; if ($A -contains '/proc/uptime') { '754.32 1500.10' } else { '' } }
"UP1=" + (Get-AndroidUptimeMin)
function AdbT([int]$Sec, [string[]]$A) { $script:AdbTimeout = 'adb shell sem resposta'; '' }
"UP2=[" + (Get-AndroidUptimeMin) + "]"
function Get-LocalEmulatorProcs { @() }
$st = Stop-AndroidEmulator; "SE1=$($st.Stopped)|$($st.Text)"
$fd = Join-Path $Work 'accept/1/T-050'; Set-AndroidFreshStartDone $fd 'T-050' 'ligado há 5 min'; "FS6=" + ([System.IO.File]::ReadAllText((Join-Path $fd 'fresh-start.json'), [System.Text.Encoding]::UTF8) -match 'ligado há 5 min')
# v3.62.0: localizador CDP — pid, socket da WebView, forward de porta livre, reconexão só com pid novo, limpeza só deste aparelho
function AdbT([int]$Sec, [string[]]$A) { $script:AdbTimeout = ''; $j = $A -join ' '; $script:calls += $j
    if ($j -like 'shell pidof*') { $script:pidNow } elseif ($j -like 'shell cat /proc/net/unix*') { '0000: 00000002 0 10000 0001 01 12345 @webview_devtools_remote_42420'; "0000: 00000002 0 10000 0001 01 12346 @webview_devtools_remote_$($script:pidNow)" }
    elseif ($j -like 'forward tcp:0*') { '38123' } elseif ($j -eq 'forward --list') { 'emulator-5554 tcp:38123 localabstract:webview_devtools_remote_4242'; 'emulator-5556 tcp:38999 localabstract:webview_devtools_remote_77'; 'emulator-5554 tcp:5000 tcp:5000' } else { '' } }
$script:Pkg = 'br.x'; $script:Serial = 'emulator-5554'; $script:calls = @(); $script:pidNow = '4242'
"CD1=$(Get-AndroidAppPid)|$(Get-AndroidCdpSocket 4242)|[$(Get-AndroidCdpSocket 99)]"
Connect-AndroidCdp; "CD2=$($script:CdpPort)|$($script:CdpPid)"
$script:calls = @(); Connect-AndroidCdp; "CD3=$($script:calls -join ';')"
$script:pidNow = '5353'; $script:calls = @(); Connect-AndroidCdp; "CD3b=$(@($script:calls | Where-Object { $_ -like 'forward*' }) -join ';')|$($script:CdpPid)"
$script:calls = @(); "CD4=$(Clear-AndroidCdpForwards)|$(@($script:calls | Where-Object { $_ -like 'forward --remove*' }) -join ';')"
$script:AdCfg = [pscustomobject]@{ locator = 'CDP'; cdp = [pscustomobject]@{ pageUrl = '^x'; hiddenScopes = @('.a', '.b') } }
$cc = Get-AndroidCdpCfg; "CD5=$(Get-AndroidLocator)|$($cc.pageUrl)|$($cc.readyTimeoutSec)|$($cc.hiddenScopes -join ',')|$($cc.readyExpr)|$($cc.stepTimeoutSec)"
$script:AdCfg = $null; "CD6=$(Get-AndroidLocator)"
function AdbT([int]$Sec, [string[]]$A) { $script:AdbTimeout = ''; if (($A -join ' ') -like 'shell pidof*') { '5151' } else { '' } }
$script:CdpPid = 0; $script:CdpPort = 0; $script:CdpSocketWaitSec = 1
try { Connect-AndroidCdp; 'CD7=sem erro' } catch { "CD7=$($_.Exception.Message)" }
function AdbT([int]$Sec, [string[]]$A) { $script:AdbTimeout = ''; '' }
try { Connect-AndroidCdp; 'CD8=sem erro' } catch { "CD8=$($_.Exception.Message)" }
# v3.62.0: type no uiautomator substitui o valor (fim do campo, apaga o atual, digita) e recusa texto fora do ASCII
function Tap([string]$Id) { $script:calls += "tap $Id" }
function Dump { $script:Nodes = @([pscustomobject]@{ Id = 'f.campo'; Text = 'abc'; Desc = ''; X1 = 0; Y1 = 0; X2 = 1; Y2 = 1 }); $script:Nodes }
function AdbT([int]$Sec, [string[]]$A) { $script:AdbTimeout = ''; $script:calls += ($A -join ' '); '' }
$script:calls = @(); TypeText 'f.campo' 'novo valor'; "TY1=$($script:calls -join ';')"
try { TypeText 'f.campo' 'maçã'; 'TY2=sem erro' } catch { "TY2=$($_.Exception.Message)" }
'@, $utf8)
$wk = Join-Path $tmp 'android-b'; New-Item -ItemType Directory -Force $wk | Out-Null
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $hs3 -Adapter (Join-Path $checks 'targets/android.ps1') -Work $wk 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
Check 'v3.53.6 item 5a: memória lida com a unidade (GiB, MiB, MB, sem unidade = MB)' $r 0 @('MB1=2560\b', 'MB2=1500\b', 'MB3=512\b', 'MB4=800\b', 'MB5=\[\]')
Check 'v3.53.6 item 5a: memória acima de maxMemoryMB reprova o pré-voo; abaixo passa; saída sem número não reprova' $r 0 @('MEM1=o emulador está com 3584 MB de memória \(limite 3072 MB', 'MEM2=\[\]', 'MEM3=\[\]', 'memoryCmd não devolveu a memória')
Check 'v3.53.6 item 5b: reinício só no 1º accept da Task, com repair; freshStart false, -NoRepair e AVD local não reiniciam' $r 0 @('FS1=True', 'FS2=False', 'FS3=False', 'FS4=False', 'FS5=False')
Check 'v3.53.6 item 7: APK mais velho que o código do módulo é recusado (o teste não conta); fora de build/outputs/apk, só a nota' $r 0 @('AP1=False\|\r?\n', 'AP2=True\|A\.kt\|assembleDebug', 'AP3=False\|idade do APK não conferida: o módulo não se infere')
Check 'v3.57.1 item 4: app híbrido — targets.android.apk com máscara acha o APK mais novo de source/dist (verify e accept); apkSources compara com o código web, sem o .spec; sem apkSources, a nota pede a declaração' $r 0 @('AP4=app-T-002-debug\.apk', 'AP5=False\|\r?\n', 'AP6=True\|tela\.ts\|o build que gera o APK', 'AP7=app-T-002-debug\.apk', 'AP8=False\|.*declare em targets\.android\.apkSources')
Check 'v3.62.0: o id é só o resource-id (o content-desc não acha mais); WebView sem nenhum id do app = app híbrido, com id do app ou sem WebView não' $r 0 @('FD1=\[\]\|FD2=B9\|FD3=\[\]', 'HY1=True\|HY2=False\|HY3=False')
Check 'v3.62.0: localizador CDP — pid e socket da WebView, forward tcp:0 com a porta devolvida, mesmo pid não refaz, pid novo refaz, limpeza só dos forwards da WebView deste aparelho' $r 0 @('CD1=4242\|webview_devtools_remote_4242\|\[\]', 'CD2=38123\|4242', 'CD3=shell pidof br\.x\r?\n', 'CD3b=forward --remove tcp:38123;forward tcp:0 localabstract:webview_devtools_remote_5353\|5353', 'CD4=1\|forward --remove tcp:38123\r?\n')
Check 'v3.62.0: configuração do cdp com padrões (locator sem caixa; v3.65.6: readyExpr padrão = DOM lido), sem socket = CONFIGURAÇÃO (depuração da WebView), app fechado = falha do passo' $r 0 @("CD5=cdp\|\^x\|30\|\.a,\.b\|document\.readyState !== 'loading'\|60", 'CD6=uiautomator', 'CD7=CONFIGURAÇÃO: o APK não liga a depuração da WebView.*webview_devtools_remote_5151.*webContentsDebuggingEnabled', 'CD8=o app br\.x não está rodando')
Check 'v3.62.0: type no uiautomator substitui o valor (MOVE_END, DEL × 3, texto) e recusa fora do ASCII' $r 0 @('TY1=tap f\.campo;shell input keyevent 123;shell input keyevent 67 67 67;shell input text novo%svalor;shell input keyevent 111', 'TY2=o uiautomator não digita fora do ASCII')
Check 'v3.58.4: liberação do emulador — serial de rede e projeto sem reparo declarado não se liberam; repair ou avd, sim; a porta do console vem do serial (padrão 5554)' $r 0 @('RB1=emulador em container \(serial de rede localhost:5555\)', 'RB2=sem targets\.android\.repair nem avd', 'RB3=\[\]', 'RB4=\[\]', 'PT1=5556', 'PT2=5554')
Check 'v3.58.4: emulador ligado há menos de freshStartMinutes (padrão 30) conta como reiniciado; uptime pelo /proc/uptime, sem resposta = desconhecido; nada na porta = nada desligado' $r 0 @('FM1=30\|FM2=10', 'UP1=12\b', 'UP2=\[\]', 'SE1=False\|nenhum emulador local na porta 5554', 'FS6=True')
Check 'v3.57.2 item 19: o accept instala por cima sem desinstalar (a base fica); com assinatura diferente, desinstala, reinstala e avisa que a base foi apagada' $r 0 @('IN1=\[\]\|install -r\|NOTE=\[\]', 'IN2=\[\]\|install -r;uninstall br\.x;install -r\|NOTE=\[o APK não instalava por cima \(INSTALL_FAILED_UPDATE_INCOMPATIBLE\).*base do app no aparelho foi apagada\]')

# 19. v3.53.6 (sprint 5 do garden) — plano grande vai à divisão, cartão com os passos que faltam, prova no alvo pendente.
# 19a. item 1: plano acima de 30 KB no disco (a sessão nem gravou a coluna Plano) → o next divide a Task, com o plano de base.
$p = Join-Path $tmp 'plano-grande'; New-Project $p
$bigPlan = "# Plano de Implementação — T-041a Variante`n`n## 4. Passos`n`n### Bloco 1 — modelo`n`n### Passo 1 — x`n" + ('x' * 32000) + "`n`n### Bloco 2 — tela`n"
Put $p '.team-project/sprints/1/plan/T-041a-x.md' $bigPlan
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.6 item 1: plano de 31 KB (sem ficha) → dividir a Task com os blocos do plano como base, sem plano novo nem corte' $r 0 @('dividir a T-041a — o plano dela tem 3\d[\d,.]* KB \(teto 30 KB, regra 22\)', '`\.team-project/sprints/1/plan/T-041a-x\.md`', 'blocos — ou grupos de passos — desse plano como base', 'não o reescreva nem o corte', 'Divida-a em T-041b, T-041c', 'não tem ficha no breakdown', 'troca a linha da T-041a no Sprint Backlog', 'o plano grande fica no disco como base')
Put $p '.team-project/architect/breakdown/S1.md' $bdText
Put $p 'src/a.ts' "export const a = 1`nexport const b = 2`nexport const c = 3`n"; Put $p 'docs/sdd/03-architecture.md' "# Arquitetura`n"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.6 item 1: com ficha, cada ficha nova leva **Base:** com o plano grande e os blocos que herda' $r 0 @('dividir a T-041a — o plano dela tem', 'No próprio \.team-project/architect/breakdown/S1\.md', '\*\*Base:\*\* `\.team-project/sprints/1/plan/T-041a-x\.md`')
Put $p '.team-project/architect/breakdown/S1.md' (([System.IO.File]::ReadAllText((Join-Path $p '.team-project/architect/breakdown/S1.md'), $utf8)) -replace '(\*\*Arquivos previstos:\*\* 2)', "`$1`n**Base:** ``.team-project/sprints/1/plan/T-041a-x.md`` — Bloco 1")
Remove-Item -LiteralPath (Join-Path $p '.team-project/sprints/1/plan/T-041a-x.md') -Force
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.6 item 1: Task nova com **Base:** na ficha → o Arquiteto do plano reaproveita o trecho do plano de origem' $r 0 @('plano da T-041a \(História H-014\) pela ficha', 'A ficha tem \*\*Base:\*\* `\.team-project/sprints/1/plan/T-041a-x\.md`', 'reaproveite os blocos e passos')
# 18b. item 1, plano externo: o plano devolvido acima de 30 KB vai à divisão, não a um pacote de correção.
$xg = Join-Path $tmp 'externo-grande'; New-Project $xg
Put $xg '.team-project/architect/breakdown/S1.md' $bdText
Put $xg 'src/a.ts' "export const a = 1`nexport const b = 2`nexport const c = 3`n"; Put $xg 'docs/sdd/03-architecture.md' "# Arquitetura`n"
Put $xg '.team-project/guards.json' '{ "run": { "planner": "external", "tasks": [] } }'
$null = Invoke-Check 'run.ps1' @('next', '-Root', $xg)
Put $xg '.team-project/sprints/1/pack/in/T-041a-plan.md' ($xgood + "`n## 4. Passos`n`n### Bloco 1 — x`n" + ('y' * 32000))
$r = Invoke-Check 'run.ps1' @('next', '-Root', $xg)
$xgpk = Join-Path $xg '.team-project/sprints/1/pack'
Check 'v3.53.6 item 1: plano externo de 31 KB → reprovado por tamanho, sem pacote de correção; a Task vai à divisão com pack/review/ de base' @{ Code = $r.Code; Out = $r.Out + "`nfix1=" + (Test-Path -LiteralPath (Join-Path $xgpk 'out/H-014-fix1.zip')) } 0 @('T-041a reprovado por tamanho \(3\d[\d,.]* KB, teto 30 KB\) — não volta em pacote de correção', 'dividir a T-041a — o plano dela tem', '`\.team-project/sprints/1/pack/review/T-041a-plan\.md`', 'fix1=False')

# 18c. item 2: cartão de retomada com os passos que faltam (do "Parei no passo" em diante) e o que já está provado.
$p = Join-Path $tmp 'retomada'; New-Project $p
$rpl = "# Plano de Implementação — T-041 Endpoint`n`n**Arquivos tocados:** ``src/a.ts```n`n## 4. Passos, em ordem de execução`n`n### Passo 1 — modelo`n- **Arquivo:** src/m.ts PASSO-UM`n`n### Passo 2 — serviço`n- **Arquivo:** src/s.ts PASSO-DOIS`n`n### Passo 3 — rota`n- **Arquivo:** src/r.ts PASSO-TRES`n`n## 6. Testes`n| a | b |`n"
Put $p '.team-project/sprints/1/plan/T-041-export.md' $rpl
Put $p '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041 — instância 1`n`n### Parei no passo`npasso 2 de 3 — falta o teste do serviço; emulador ligado`n- provado: verify focused verde (12 testes)`n`n### Documentos vivos (R12)`n**Estado:** a consolidar`n"
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$card = Join-Path $p '.team-project/sprints/1/handoff/T-041.md'
$ct = if (Test-Path -LiteralPath $card) { [System.IO.File]::ReadAllText($card, $utf8) } else { 'sem cartão' }
Check 'v3.53.6 item 2: cartão com os passos do ponto em diante, o já provado, e sem mandar reabrir o plano' @{ Code = $r.Code; Out = $ct + $(if ($ct -match 'PASSO-UM') { "`nPASSO1-VAZOU" } else { '' }) + $(if ($ct -match '## 6\.') { "`nSEC6-VAZOU" } else { '' }) } 0 @('Retomada do passo 2', 'não reabra o plano inteiro', '## Já provado — ponto de retomada', 'verify focused verde \(12 testes\)', '## Passos que faltam — do plano, passo 2 em diante', '### Passo 2 — serviço', 'PASSO-DOIS', '### Passo 3 — rota', '^(?![\s\S]*PASSO1-VAZOU)', '^(?![\s\S]*SEC6-VAZOU)')
Put $p '.team-project/sprints/1/plan/T-041-export.md' ($rpl.Replace('PASSO-DOIS', ("linha longa do passo dois`n" * 600)))
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$ct = [System.IO.File]::ReadAllText($card, $utf8)
Check 'v3.53.6 item 2: passos acima de 8 KB → cortados numa linha, com o ponteiro para o resto no plano' @{ Code = $r.Code; Out = $ct + "`nKB=" + [int]((Get-Item -LiteralPath $card).Length / 1024) } 0 @('cortado em 8 KB: o resto em `sprints/1/plan/T-041-export\.md` §4, a partir de .Passo 3 — rota.', 'KB=(8|9|10|11)\b')
Put $p '.team-project/sprints/1/plan/T-041-export.md' "# Plano`n`n## 4. Passos`n`n### Bloco 1 — a`n`n#### Passo 1 — a1`nBLOCO-UM`n`n### Bloco 2 — b`n`n#### Passo 1 — b1`nBLOCO-DOIS-P1`n`n#### Passo 2 — b2`nBLOCO-DOIS-P2`n"
Put $p '.team-project/sprints/1/delivery/T-041.md' "## Entrega`n`n### Parei no passo`nbloco 2, passo 1 de 2 — teto (G23)`n"
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$ct = [System.IO.File]::ReadAllText($card, $utf8)
Check 'v3.53.6 item 2: plano em blocos — o passo é procurado no bloco do ponto de parada' @{ Code = $r.Code; Out = $ct + $(if ($ct -match 'BLOCO-UM') { "`nBLOCO1-VAZOU" } else { '' }) } 0 @('passo 1 em diante \(Bloco 2\)', 'BLOCO-DOIS-P1', 'BLOCO-DOIS-P2', '^(?![\s\S]*BLOCO1-VAZOU)')
Put $p '.team-project/sprints/1/delivery/T-041.md' "## Entrega`n`n### Parei no passo`n2 de 2 — repositório compila, todos os testes passam`n"
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$ct = [System.IO.File]::ReadAllText($card, $utf8)
Check 'v3.53.6 item 2: entrega terminada ("2 de 2") não vira retomada — o cartão segue o de sempre' @{ Code = $r.Code; Out = $ct } 0 @('Leia: este cartão, o cabeçalho e a §6', '^(?![\s\S]*Passos que faltam)')

# 18d. item 9: "nenhum aplicável" por alvo fora do ar não fecha; a Task vai a 🔴 com a prova pendente e o next a reabre.
$p = Join-Path $tmp 'prova-pendente'; New-Project $p
$psb = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'
Edit-File $psb 'SC-014 (novo)' 'nenhum aplicável — emulador fora do ar no dia'
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.53.6 item 9a: "nenhum aplicável — emulador fora do ar" → R30 e R7-aceite falham, não fecha (exit 1), com a rota do bloqueio' $r 1 @('\| R30 \| falhou.*alvo indisponível.*mark\.ps1 -Task T-041 -To blocked -Reason', '\| R7-aceite \| falhou', 'Não fecha')
Edit-File $psb 'nenhum aplicável — emulador fora do ar no dia' 'SC-014 (novo)'
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041a', '-To', 'qa', '-Reason', 'x', '-Root', $p)
Check 'v3.53.6 item 9b: -Reason só com -To blocked (exit 2)' $r 2 @('só vale com -To blocked')
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041a', '-To', 'blocked', '-Reason', 'prova no alvo pendente — o site não responde', '-Root', $p)
Check 'v3.53.6 item 9b: mark -To blocked -Reason grava a linha em Bloqueios, com degrau nomeado' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText($psb, $utf8) } 0 @('T-041a ⬜ → 🔴', 'Bloqueios: linha 2 em sprint-backlog\.md', '\| 2 \| T-041a \| prova no alvo pendente — o site não responde \| escalado ao stakeholder em \d{4}-\d\d-\d\d \| stakeholder \(ambiente\)')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.53.6 item 9b: a linha gravada tem o degrau que o R25 lê' $r 0 @('\| R25 \| ok')
Edit-File $psb "| $($e.qa) T-041 |" "| $($e.ok) T-041 |"
Put $p '.team-project/guards.json' '{ "targets": { "web": { "url": "http://127.0.0.1:9", "startTimeoutSec": 3 } } }'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.53.6 item 9c: alvo ainda fora → a Task segue 🔴 e a fila continua (sem esperar)' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'team:operator.*accept\.ps1 -Task T-041a') { "`nREABRIU" } else { '' }) } 0 @('alvo web ainda fora \(.*não responde', 'T-041a segue\(m\) 🔴 com a prova no alvo pendente', 'PRÓXIMA AÇÃO: validação do sprint 1', '^(?![\s\S]*REABRIU)')
# v3.65.7 (garden S6): o next que manda disparar grava a ação pendente que a G20 lê — no portão não há Task elegível.
$nvF = Join-Path $p '.team-project/.next-verdict'
Check 'v3.65.7: o next que manda medir o portão grava .next-verdict "agir" com o agente e a PRÓXIMA AÇÃO' @{ Code = 0; Out = $(if (Test-Path -LiteralPath $nvF) { [System.IO.File]::ReadAllText($nvF) } else { 'sem .next-verdict' }) } 0 @('"acao":"agir"', '"motivo":"disparar team:operator — validação do sprint 1')
$port = Get-Random -Minimum 41000 -Maximum 49000
$srv = Start-Job -ArgumentList $port -ScriptBlock { param($port)
    $l = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, $port); $l.Start()
    try { for ($i = 0; $i -lt 20; $i++) { while (-not $l.Pending()) { Start-Sleep -Milliseconds 100 }; $c = $l.AcceptTcpClient(); $s = $c.GetStream(); $buf = New-Object byte[] 4096; $null = $s.Read($buf, 0, 4096)
        $b = [System.Text.Encoding]::ASCII.GetBytes("HTTP/1.1 200 OK`r`nContent-Length: 2`r`nConnection: close`r`n`r`nok"); $s.Write($b, 0, $b.Length); $s.Flush(); $c.Close() } } finally { $l.Stop() } }
$sw = [Diagnostics.Stopwatch]::StartNew()
while ($sw.Elapsed.TotalSeconds -lt 20) { try { $tc = New-Object System.Net.Sockets.TcpClient('127.0.0.1', $port); $tc.Close(); break } catch { Start-Sleep -Milliseconds 300 } }
Put $p '.team-project/guards.json' ('{ "targets": { "web": { "url": "http://127.0.0.1:' + $port + '/", "startTimeoutSec": 3 } } }')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Stop-Job $srv -ErrorAction SilentlyContinue; Remove-Job $srv -Force -ErrorAction SilentlyContinue
Check 'v3.53.6 item 9c: alvo de volta → a Task sai de 🔴 para 🟪, a linha vira "retomada" e o operator roda o accept' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText($psb, $utf8) } 0 @('mark: T-041a 🔴 → 🟪', 'prova no alvo da T-041a — o alvo web voltou', 'team:operator', 'accept\.ps1 -Task T-041a', 'run\.ps1 done -Task T-041a -Result ok', 'prova no alvo retomada em \d{4}-\d\d-\d\d')
# v3.54.2 (carta do sprint 5 do garden, item 4): reaberta uma vez e de volta a 🔴 pela prova no alvo → o next não reabre de
# novo (a T-063 foi e voltou duas vezes, um operator em cada); vai ao stakeholder com a última falha do accept.
$null = Invoke-Check 'mark.ps1' @('-Task', 'T-041a', '-To', 'blocked', '-Reason', 'prova no alvo pendente — o accept caiu de novo', '-Root', $p)
Put $p '.team-project/accept/1/T-041a/result.json' '{ "environment": "x", "passed": 0, "total": 2, "results": [ { "id": "SC-014", "status": "FALHOU", "detail": "tag não encontrada: tab [tela: br.x/.Intro · ids: nenhum · textos: Bem-vindo]", "shot": ".team-project/accept/1/T-041a/shots/SC-014-falha.png" } ] }'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.54.2: Task já reaberta uma vez e de volta a 🔴 → o next não reabre; formulário com a última falha' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'team:operator.*accept\.ps1 -Task T-041a') { "`nREABRIU" } else { '' }) } 0 @('T-041a 🔴: já reaberta pelo alvo de volta', 'última falha: SC-014 — tag não encontrada: tab \[tela: br\.x/\.Intro', 'captura \.team-project/accept/1/T-041a/shots/SC-014-falha\.png', '^(?![\s\S]*REABRIU)')
# done -Result env com o accept parado por ambiente → a rota do bloqueio com a etiqueta.
$p = Join-Path $tmp 'env-alvo'; New-Project $p
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
Put $p '.team-project/accept/1/T-041/result.json' '{ "environment": "nenhum emulador ou aparelho disponível" }'
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $p)
Check 'v3.53.6 item 9b: done -Result env com o accept parado por ambiente → sem reparo, mark -To blocked -Reason "prova no alvo pendente — …"' $r 0 @('target\.ps1 -Target android -Repair', 'mark\.ps1 -Task T-041 -To blocked -Reason "prova no alvo pendente — nenhum emulador ou aparelho disponível"', 'T-041 🔴 bloqueada: prova no alvo pendente')
# v3.54.2 (item 3): accept parado no estado de partida → sem reparo do emulador nem etiqueta da prova pendente; stakeholder.
Put $p '.team-project/accept/1/T-041/result.json' '{ "environment": "ESTADO DE PARTIDA: …", "startState": "br.x/.IntroActivity · textos: Bem-vindo(a) à Horta", "results": [ { "id": "SC-117", "status": "FALHOU", "shot": ".team-project/accept/1/T-041/shots/SC-117-falha.png" } ] }'
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $p)
Check 'v3.54.2: done -Result env com startState → sem reparo, bloqueio "estado de partida" (sem a etiqueta), formulário com baseline' $r 0 @('ESTADO DE PARTIDA: br\.x/\.IntroActivity', 'mark\.ps1 -Task T-041 -To blocked -Reason "estado de partida — br\.x/\.IntroActivity', 'T-041 🔴 bloqueada: estado de partida', 'targets\.android\.baseline', 'SC-117-falha\.png', '^(?![\s\S]*-Repair)', '^(?![\s\S]*prova no alvo pendente)')
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'blocked', '-Reason', 'estado de partida — br.x/.IntroActivity', '-Root', $p)
Check 'v3.54.2: bloqueio por estado de partida vai ao stakeholder e não diz que o next reabre' @{ Code = $r.Code; Out = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/sprint-backlog.md'), $utf8) } 0 @('T-041 \| estado de partida — br\.x/\.IntroActivity \| escalado ao stakeholder.*reabre com mark\.ps1 -To qa')
# v3.64.1 (sprint 6 do projeto piloto, Q-S6e): só a etiqueta da prova no alvo pendente leva a promessa de reabrir pelo next.
$pk641 = Join-Path $tmp 'v3641-mark'; New-Project $pk641
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'blocked', '-Reason', 'ambiente: suíte Karma cai com Chrome Headless desconectado', '-Root', $pk641)
$r2 = Invoke-Check 'mark.ps1' @('-Task', 'T-041a', '-To', 'blocked', '-Reason', 'prova no alvo pendente — nenhum emulador', '-Root', $pk641)
$sb641 = [System.IO.File]::ReadAllText((Join-Path $pk641 '.team-project/sprints/1/sprint-backlog.md'), $utf8)
Check 'v3.64.1: bloqueio de ambiente sem a etiqueta da prova no alvo → reabre pelo mark.ps1 (-Reopen resume ou replan, v3.64.2), não pelo next; com a etiqueta, a promessa fica' @{ Code = $r.Code + $r2.Code; Out = $sb641 } 0 @('T-041 \| ambiente: suíte Karma[^\r\n]*mark\.ps1 -To build -Reopen resume[^\r\n]*-Reopen replan', 'T-041a \| prova no alvo pendente — nenhum emulador[^\r\n]*o run\.ps1 next reabre quando o alvo responder', '^(?![\s\S]*T-041 \| ambiente: suíte Karma[^\r\n]*quando o alvo responder)')
# v3.64.2 (sprint 6 do projeto piloto, Q-S6e): sair de 🔴 diz como — retomar ou replanejar com o Arquiteto antes do dev.
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'build', '-Root', $pk641)
Check 'v3.64.2: tirar de 🔴 sem -Reopen → recusa (exit 2) com as duas formas, nada gravado' @{ Code = $r.Code; Out = $r.Out + "`nB=" + [System.IO.File]::ReadAllText((Join-Path $pk641 '.team-project/sprints/1/sprint-backlog.md'), $utf8) } 2 @('diga\s+como:\s+-Reopen\s+resume', '-Reopen\s+replan\s+-Decision', 'Nada\s+gravado', 'B=[\s\S]*🔴 T-041 \|')
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'build', '-Reopen', 'replan', '-Root', $pk641)
Check 'v3.64.2: -Reopen replan sem -Decision → recusa (exit 2)' $r 2 @('-Reopen replan pede -Decision')
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041a', '-To', 'qa', '-Root', $pk641)
Check 'v3.64.2: a reabertura que já tem dono (prova no alvo pendente) segue sem -Reopen' $r 0 @('mark: T-041a 🔴 → 🟪')
Put $pk641 'src/a.ts' "export const a = 1`n"
Put $pk641 '.team-project/sprints/1/plan/T-041-export.md' "# Plano de Implementação — T-041 Endpoint de exportação`n`n**Cenários:** nenhum — interno`n**Risco:** infraestrutura`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 3. Ambiente`n`n| Pré-requisito | Comando de medição | Saída real |`n|---|---|---|`n| Node 20 | node --version | v20.11.0 |`n`n## 6. Testes`nsem prova: x`n`n### Comandos da Task`n- nenhum além da lista base`n`n## 9. Onde parar`n- **Pré-requisito ausente** — 🔺 GAP`n"
(Get-Item -LiteralPath (Join-Path $pk641 '.team-project/sprints/1/plan/T-041-export.md')).LastWriteTime = (Get-Date).AddMinutes(-30)
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'build', '-Reopen', 'replan', '-Decision', 'Ajustar a espera do Karma — o Arquiteto ajusta', '-Root', $pk641)
$rp642 = Join-Path $pk641 '.team-project/sprints/1/handoff/T-041-replan.md'
Check 'v3.64.2: -Reopen replan -Decision → a Task vai a 🟦 (não a 🟨) e a decisão fica em handoff/<ID>-replan.md com o bloqueio' @{ Code = $r.Code; Out = $r.Out + "`nRP=" + $(if (Test-Path -LiteralPath $rp642) { [System.IO.File]::ReadAllText($rp642, $utf8) } else { 'ausente' }) } 0 @('mark: T-041 🔴 → 🟦', 'por quem: Arquiteto · replanejar', 'RP=# Replanejar a T-041', '\*\*Bloqueio:\*\* ambiente: suíte Karma', '\*\*Decisão:\*\* Ajustar a espera do Karma')
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $pk641)
Check 'v3.64.2: run.ps1 start recusa o dev enquanto o plano não foi emendado depois da decisão (⏸ replanejar)' $r 2 @('decisão do stakeholder para replanejar', 'o dev não começa', 'T-041 ⏸ replanejar')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pk641)
Check 'v3.64.2: run.ps1 next dispara o Arquiteto para emendar o plano com a decisão, antes de qualquer dev' $r 0 @('emendar o plano da T-041 com a decisão do stakeholder', 'team:architect', 'handoff/T-041-replan\.md', 'plan/T-041-export\.md', 'Plano corrigido durante a execução', '^(?![\s\S]*team:developer)', '^(?![\s\S]*team:task-runner)')
Edit-File (Join-Path $pk641 '.team-project/sprints/1/plan/T-041-export.md') '## 9. Onde parar' "**Plano corrigido durante a execução:** 2026-11-19 — a espera do Karma passa a 300 s (decisão do stakeholder)`n`n## 9. Onde parar"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pk641)
$sb642 = [System.IO.File]::ReadAllText((Join-Path $pk641 '.team-project/sprints/1/sprint-backlog.md'), $utf8)
Check 'v3.64.2: plano emendado e plan.ps1 verde → a Task vai a 🟨, a decisão sai do handoff e a fila segue (aqui, o preparo da T-041a)' @{ Code = $r.Code; Out = $r.Out + "`nRP=$(Test-Path -LiteralPath $rp642)`nB=" + $sb642 } 0 @('mark: T-041 🟦 → 🟨', 'por quem: sessão \(run\.ps1 next — plano emendado\)', 'RP=False', 'B=[\s\S]*🟨 T-041 \|', '^(?![\s\S]*emendar o plano da T-041)', '^(?![\s\S]*não passa no plan\.ps1)')
# v3.64.3 (sprint 6 do projeto piloto, Q-S6e): o plano emendado acima do teto de tamanho não prende a Task num laço.
$pf643 = Join-Path $pk641 '.team-project/sprints/1/plan/T-041-export.md'
$null = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'blocked', '-Reason', 'ambiente: suíte caiu de novo', '-Root', $pk641)
$null = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'build', '-Reopen', 'replan', '-Decision', 'mudar a espera', '-Root', $pk641)
(Get-Item -LiteralPath $rp642).LastWriteTime = (Get-Date).AddMinutes(-10)
Edit-File $pf643 '## 9. Onde parar' ("## 8. Notas do Arquiteto`n" + (('- a emenda da espera do Karma, com o motivo e o que fica de fora ' * 6 + "`n") * 90) + "`n## 9. Onde parar")
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pk641)
Check 'v3.64.3/v3.64.4: plano emendado acima do teto de tamanho → Arquiteto substitui o texto que a decisão derrubou (regra do start, v3.54.1), sem cortar nem dividir; a Task não vai a 🟨' @{ Code = $r.Code; Out = $r.Out + "`nRP=" + [System.IO.File]::ReadAllText($rp642, $utf8) } 0 @('não passa no plan\.ps1 — Arquiteto \(instância nova\) corrige e regrava', 'substitua no plano o texto que a decisão derrubou', 'não a acrescente ao lado e não corte o que segue valendo', 'RP=[\s\S]*- plan\.ps1 reprovou em [^\r\n]*\| tamanho \| falhou', '^(?![\s\S]*mark: T-041 🟦 → 🟨)', '^(?![\s\S]*team:developer)')
$null = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'blocked', '-Reason', 'ambiente: suíte caiu outra vez', '-Root', $pk641)
$null = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'build', '-Reopen', 'replan', '-Decision', 'mudar a espera de novo', '-Root', $pk641)
(Get-Item -LiteralPath $rp642).LastWriteTime = (Get-Date).AddMinutes(-10)
Edit-File $pf643 '**Risco:** infraestrutura' '**Risco:** a decidir'
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pk641)
Check 'v3.64.3: plano emendado que reprova por outra regra → a reprovação vai ao handoff e o Arquiteto corrige (nenhum dev)' @{ Code = $r.Code; Out = $r.Out + "`nRP=" + [System.IO.File]::ReadAllText($rp642, $utf8) } 0 @('não passa no plan\.ps1 — Arquiteto \(instância nova\) corrige e regrava', 'team:architect', 'RP=[\s\S]*- plan\.ps1 reprovou em \d{4}-\d\d-\d\d \d\d:\d\d: \| risco \| falhou', '^(?![\s\S]*team:developer)')
(Get-Item -LiteralPath $pf643).LastWriteTime = (Get-Date).AddMinutes(5)
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pk641)
$ar643 = $(try { (Get-Content -LiteralPath (Join-Path $pk641 '.team-project/.ask-route') -Raw -Encoding UTF8) } catch { '' })
Check 'v3.64.3: a mesma reprovação pela 2ª vez → degrau 1 (PO + Arquiteto), rota de bloqueio, sem outro Arquiteto igual nem dev' @{ Code = $r.Code; Out = $r.Out + "`nrota=$ar643" } 0 @('reprovou IGUAL pela 2ª vez no plan\.ps1 — degrau 1', 'rota=.*"rota":"bloqueio"', '^(?![\s\S]*team:architect)', '^(?![\s\S]*team:developer)')
# v3.64.4 (sprint 6 do projeto piloto, Q-S6e): depois da emenda, o relatório e a prova são de antes dela — o dev vem primeiro.
Put $pk641 '.team-project/sprints/1/plan/T-041-export.md' "# Plano de Implementação — T-041 Endpoint de exportação`n`n**Cenários:** nenhum — interno`n**Risco:** infraestrutura`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 3. Ambiente`n`n| Pré-requisito | Comando de medição | Saída real |`n|---|---|---|`n| Node 20 | node --version | v20.11.0 |`n`n## 6. Testes`nsem prova: x`n`n### Comandos da Task`n- nenhum além da lista base`n`n**Plano corrigido durante a execução:** 2026-11-19 — a decisão substituiu o passo que ela derrubou`n`n## 9. Onde parar`n- **Pré-requisito ausente** — 🔺 GAP`n"
(Get-Item -LiteralPath $pf643).LastWriteTime = (Get-Date).AddMinutes(6)
Put $pk641 '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041 (antes da emenda)`n`nverify full: suite exit 1`n"
(Get-Item -LiteralPath (Join-Path $pk641 '.team-project/sprints/1/delivery/T-041.md')).LastWriteTime = (Get-Date).AddMinutes(-20)
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pk641)
$rd644 = Join-Path $pk641 '.team-project/sprints/1/handoff/T-041-replanned.md'
Check 'v3.64.4: o plano emendado leva a 🟨 e deixa a marca handoff/<ID>-replanned.md' @{ Code = $r.Code; Out = $r.Out + "`nRD=" + $(if (Test-Path -LiteralPath $rd644) { [System.IO.File]::ReadAllText($rd644, $utf8) } else { 'ausente' }) } 0 @('mark: T-041 🟦 → 🟨', 'RD=# Replanejar a T-041', '\*\*Plano emendado:\*\* \d{4}-\d\d-\d\d')
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'ok', '-Root', $pk641)
Check 'v3.64.4: done com o relatório de antes da emenda → recusa e manda o dev em instância nova (start), sem fechar nem medir' $r 0 @('o plano foi emendado com a decisão do stakeholder depois do último relatório do dev', 'run\.ps1 start -Task T-041', 'nenhum operator', '^(?![\s\S]*team:operator)', '^(?![\s\S]*falta RODAR a prova)')
Edit-File (Join-Path $pk641 '.team-project/sprints/1/sprint-backlog.md') '[`plan/T-041a-x.md`](plan/)' '[`plan/T-041a-x.md`](plan/T-041a-x.md)'
Put $pk641 '.team-project/sprints/1/plan/T-041a-x.md' ([System.IO.File]::ReadAllText($pf643, $utf8) -replace 'T-041 Endpoint de exportação', 'T-041a Variante')
(Get-Item -LiteralPath (Join-Path $pk641 '.team-project/sprints/1/delivery/T-041.md')).LastWriteTime = (Get-Date).AddMinutes(-20)
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pk641)
Check 'v3.64.4: o disparo do executor depois da emenda manda começar pelo start, não pelo done' $r 0 @('construir T-041', 'comece por run\.ps1 start — o dev em instância nova aplica a emenda', 'Não comece por run\.ps1 done', '^(?![\s\S]*se o dev voltou com a entrega, comece por run\.ps1 done)')
Put $pk641 '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041 (com a emenda)`n`nverify full: tudo exit 0`n"
(Get-Item -LiteralPath (Join-Path $pk641 '.team-project/sprints/1/delivery/T-041.md')).LastWriteTime = (Get-Date).AddMinutes(10)
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'ok', '-Root', $pk641)
Check 'v3.64.4: o relatório novo, depois da emenda, libera o done e apaga a marca' @{ Code = 0; Out = $r.Out + "`nRD=$(Test-Path -LiteralPath $rd644)" } 0 @('RD=False', '^(?![\s\S]*o plano foi emendado com a decisão do stakeholder depois do último relatório)')
Put $p '.team-project/accept/1/T-041/result.json' '{ "environment": "IDS NÃO PUBLICADOS: …", "startState": "br.x/br.x.MainActivity · textos: Cultiva", "results": [ { "id": "SC-165", "status": "FALHOU", "shot": ".team-project/accept/1/T-041/shots/SC-165-falha.png" } ] }'
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $p)
Check 'v3.62.0: done -Result env com o IDS NÃO PUBLICADOS de um result.json antigo → CONFIGURAÇÃO DO ALVO (locator cdp), sem reparo, sem baseline, sem aria-label' $r 0 @('CONFIGURAÇÃO DO ALVO: app híbrido.*targets\.android\.locator = .cdp.', 'mark\.ps1 -Task T-041 -To blocked -Reason "configuração do alvo — ', 'T-041 🔴 bloqueada: configuração do alvo', '^(?![\s\S]*-Repair)', '^(?![\s\S]*targets\.android\.baseline)', '^(?![\s\S]*aria-label)')
Put $p '.team-project/accept/1/T-041/result.json' '{ "environment": "CONFIGURAÇÃO DO ALVO: o APK não liga a depuração da WebView", "configuration": "o APK não liga a depuração da WebView — no Capacitor: android.webContentsDebuggingEnabled", "startState": null, "results": [] }'
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $p)
Check 'v3.62.0: done -Result env com configuration no result.json → bloqueio "configuração do alvo", rota ao stakeholder, sem reparo nem Arquiteto' @{ Code = $r.Code; Out = $r.Out + "`nrota=" + $(try { (Get-Content -LiteralPath (Join-Path $p '.team-project/.ask-route') -Raw -Encoding UTF8) } catch { '' }) } 0 @('CONFIGURAÇÃO DO ALVO: o APK não liga a depuração da WebView', 'nem decisão do Arquiteto', 'mark\.ps1 -Task T-041 -To blocked -Reason "configuração do alvo — o APK não liga', 'rota=.*configuracao-do-alvo', '^(?![\s\S]*-Repair)', '^(?![\s\S]*team:architect)')
Put $p '.team-project/accept/1/T-041/result.json' '{ "environment": "IDS NÃO PUBLICADOS: …", "startState": "br.x/br.x.MainActivity · textos: Cultiva", "results": [ { "id": "SC-165", "status": "FALHOU", "shot": ".team-project/accept/1/T-041/shots/SC-165-falha.png" } ] }'
# v3.60.1 (sprint 6 do garden, T-090): "provar por teste" aplicado pelo script — plano, quadro, lista da validação, 🔴 → 🟨.
$null = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'blocked', '-Reason', 'ids não publicados pela WebView — br.x', '-Root', $p)
$plP = Join-Path $p '.team-project/sprints/1/plan/T-041-export.md'
Edit-File $plP "# Plano de Implementação — T-041 Endpoint de exportação`n" "# Plano de Implementação — T-041 Endpoint de exportação`n**Cenários:** SC-014`n"
Edit-File $plP "# Plano de Implementação — T-041 Endpoint de exportação`r`n" "# Plano de Implementação — T-041 Endpoint de exportação`r`n**Cenários:** SC-014`r`n"
$r = Invoke-Check 'run.ps1' @('prove', '-Task', 'T-041', '-By', 'stakeholder (README §7 item 21)', '-Because', 'a WebView não publica os ids', '-Root', $p)
$bk = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/sprint-backlog.md'), $utf8)
Check 'v3.60.1: run.ps1 prove — cenário (teste) no plano e no quadro, prova pendente no plano e na lista da validação, 🔴 → 🟨, rota apagada' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText($plP, $utf8) + "`n" + $bk + "`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/device-pending.md'), $utf8) + "`nrota=" + (Test-Path -LiteralPath (Join-Path $p '.team-project/.ask-route')) } 0 @('run prove: T-041 provada pelos testes do plano', 'mark: T-041 🔴 → 🟨', 'run\.ps1 done -Task T-041 -Result ok', '\*\*Cenários:\*\* SC-014 \(teste\)', '\*\*Prova no aparelho pendente:\*\* SC-014 — a WebView não publica os ids', 'T-041 \| Endpoint de exportação[^\r\n]*SC-014 \(teste\)', '\| T-041 \| SC-014 \| a WebView não publica os ids \| stakeholder \(README §7 item 21\) \|', 'rota=False')
$r = Invoke-Check 'run.ps1' @('prove', '-Task', 'T-041', '-Root', $p)
Check 'v3.60.1: run.ps1 prove de novo não duplica nada' @{ Code = $r.Code; Out = [System.IO.File]::ReadAllText($plP, $utf8) + "`nN=" + ([regex]::Matches([System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/device-pending.md'), $utf8), '\| T-041 \|').Count) } 0 @('SC-014 \(teste\)(?! \(teste\))', 'N=1', '^(?![\s\S]*\(teste\) \(teste\))')
# Política do projeto: o done -Result env aplica a prova por teste sozinho, sem 🔴 e sem rota ao stakeholder.
$p = Join-Path $tmp 'env-politica'; New-Project $p
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } }, "run": { "deviceProofFallback": "teste" } }'
Put $p '.team-project/accept/1/T-041/result.json' '{ "environment": "CONFIGURAÇÃO DO ALVO: app híbrido", "configuration": "app híbrido: declare targets.android.locator = cdp", "results": [ { "id": "SC-014", "status": "FALHOU" } ] }'
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $p)
Check 'v3.62.0: com run.deviceProofFallback = teste, a CONFIGURAÇÃO DO ALVO não vira prova por teste — vai ao stakeholder' $r 0 @('CONFIGURAÇÃO DO ALVO: app híbrido', 'mark\.ps1 -Task T-041 -To blocked -Reason "configuração do alvo', '^(?![\s\S]*Política do projeto)')
Remove-Item -LiteralPath (Join-Path $p '.team-project/.ask-route') -Force -ErrorAction SilentlyContinue
Put $p '.team-project/accept/1/T-041/result.json' '{ "environment": "ESTADO DE PARTIDA: …", "startState": "br.x/br.x.MainActivity · textos: Cultiva", "results": [ { "id": "SC-014", "status": "FALHOU" } ] }'
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $p)
Check 'v3.60.1: com run.deviceProofFallback = teste, ESTADO DE PARTIDA → prova por teste sem formulário nem 🔴; o executor fecha' @{ Code = $r.Code; Out = $r.Out + "`nrota=" + (Test-Path -LiteralPath (Join-Path $p '.team-project/.ask-route')) + "`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/run-log.md'), $utf8) } 0 @('Política do projeto \(guards\.json → run\.deviceProofFallback = teste\)', 'run\.ps1 done -Task T-041 -Result ok', 'Não abra formulário', 'rota=False', 'prova por teste: SC-014 \(teste\)', '^(?![\s\S]*mark\.ps1 -Task T-041 -To blocked)')
# Pausa pelo script (o Remove-Item do .active-run foi negado no garden).
Put $p '.team-project/.active-run' '{ "trilha": "sprint", "id": "1", "desde": "2026-11-15 10:00" }'
$r = Invoke-Check 'run.ps1' @('pause', '-Root', $p)
Check 'v3.65.12: run.ps1 pause sem -Because → recusado (exit 2), o .active-run fica e nada vai ao run-log como pedido do stakeholder' @{ Code = $r.Code; Out = $r.Out + "`nrun=" + (Test-Path -LiteralPath (Join-Path $p '.team-project/.active-run')) } 2 @('run pause: recusado — falta -Because', 'problema técnico .* é do time: rode run\.ps1 next', 'run=True')
$r = Invoke-Check 'run.ps1' @('pause', '-Because', 'o stakeholder pediu', '-Root', $p)
Check 'v3.60.1: run.ps1 pause apaga o .active-run e registra no run-log' @{ Code = $r.Code; Out = $r.Out + "`nrun=" + (Test-Path -LiteralPath (Join-Path $p '.team-project/.active-run')) + "`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/run-log.md'), $utf8) } 0 @('run pause: o sprint run 1 está pausado', '/sm sprint run', 'run=False', 'pausa a pedido de stakeholder \(sprint run 1\) \| o stakeholder pediu')
# Pré-requisito do ambiente (Docker no garden): sobe pelo start declarado; sem start, falha com o motivo.
$p = Join-Path $tmp 'prereq'; New-Item -ItemType Directory -Force (Join-Path $p '.team-project') | Out-Null
Put $p '.team-project/guards.json' '{ "run": { "prereqs": [ { "name": "Serviço X", "check": "if (Test-Path x.flag) { exit 0 } else { exit 1 }", "start": "Set-Content x.flag 1", "waitSec": 30 } ] } }'
$ErrorActionPreference = 'Continue'
$pqs = Join-Path $tmp 'prereq-probe.ps1'; [System.IO.File]::WriteAllText($pqs, ("param([string]`$Root)`n. '" + $checks + "\lib.ps1'`n`$r = Invoke-RunPrereqs `$Root`n'OK=' + `$r.Ok + ' L=' + (`$r.Lines -join ';') + ' F=' + `$r.Fail`n"), (New-Object System.Text.UTF8Encoding($true)))
$pq = & powershell -NoProfile -ExecutionPolicy Bypass -File $pqs -Root $p 2>&1 | Out-String
Put $p '.team-project/guards.json' '{ "run": { "prereqs": [ { "name": "Serviço Y", "check": "exit 3" } ] } }'
$pq2 = & powershell -NoProfile -ExecutionPolicy Bypass -File $pqs -Root $p 2>&1 | Out-String
$ErrorActionPreference = 'Stop'
Check 'v3.60.1: run.prereqs — o desligado sobe pelo start e espera o check; sem start, falha com o motivo' @{ Code = 0; Out = $pq + "`n" + $pq2 } 0 @('OK=True L=Serviço X estava desligado — subiu', 'OK=False L= F=Serviço Y não responde \(exit 3 saiu com 3\)')

# v3.54.2 (item 3): o accept para cedo quando os 2 primeiros cenários falham na mesma tela, grava progress.json a cada
# cenário e o startState no result.json (as funções do accept.ps1 com Invoke-Once falso — sem aparelho).
$hs5 = Join-Path $tmp 'accept-partida.ps1'
[System.IO.File]::WriteAllText($hs5, @'
param([string]$Accept, [string]$Lib, [string]$Root, [string]$Case)
$ErrorActionPreference = 'Stop'
. $Lib
$utf8 = New-Object System.Text.UTF8Encoding($false); $Task = 'T-041'; $NoRetry = $true; $NoRepair = $true; $Apk = ''
$ast = [System.Management.Automation.Language.Parser]::ParseFile($Accept, [ref]$null, [ref]$null)
foreach ($f in $ast.FindAll({ param($a) $a -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) { if ($f.Name -in 'Invoke-Accept', 'Get-FailScreen', 'Write-AcceptConfig', 'Write-AcceptProgress', 'Invoke-AcceptBaseline', 'Get-AcceptReuse', 'New-ReusedRow', 'Get-ScenarioHash', 'Get-AppIdentity', 'Get-AcceptNoRetryKind', 'Add-AcceptStepTime', 'Get-AcceptTiming', 'Format-AcceptTiming', 'Format-AcceptFresh', 'Test-AcceptFresh', 'Write-AcceptStale') { . ([scriptblock]::Create($f.Extent.Text)) } }
$script:Tgt = 'web'; $script:ran = 0; $script:Locator = 'uiautomator'
function Stop-WebServer { }
function Invoke-Once($Block) {
    $script:ran++
    if ($Case -eq 'config') { if ($script:ran -eq 2) { return @{ config = 'o APK não liga a depuração da WebView' } }; return @{ status = 'PASSOU'; detail = ''; shot = '' } }
    $tela = if ($Case -eq 'mesma') { 'br.x/.IntroActivity' } else { "br.x/.Tela$($script:ran)" }
    if ($Case -eq 'ocultos') { return @{ status = 'FALHOU'; detail = "passo 'assert-exists tab-button-estufa': tag ausente: tab-button-estufa [tela: br.x/br.x.MainActivity · ids: action_bar_root, content · textos: Cultiva / Área administrativa]"; shot = (Join-Path $Root ".team-project/accept/1/T-041/shots/$($Block.id)-falha.png") } }
    return @{ status = 'FALHOU'; detail = "passo 'tap tab-button-estufa': tag não encontrada: tab-button-estufa [tela: $tela · ids: intro.pular · textos: Bem-vindo(a) à Horta]"; shot = (Join-Path $Root ".team-project/accept/1/T-041/shots/$($Block.id)-falha.png") }
}
$blocks = @(1..5 | ForEach-Object { @{ id = "SC-10$_"; title = "c$_"; steps = @() } })
$code = Invoke-Accept $blocks $null { $null } { $null }
"CODE=$code RAN=$($script:ran)"
$d = Join-Path $Root '.team-project/accept/1/T-041'
'RESULT=' + ([System.IO.File]::ReadAllText((Join-Path $d 'result.json')) -replace '\s+', ' ')
'PROGRESS=' + ([System.IO.File]::ReadAllText((Join-Path $d 'progress.json')) -replace '\s+', ' ')
'@, (New-Object System.Text.UTF8Encoding($true)))   # com BOM: o 5.1 lê o "·" do detalhe como o accept.ps1 o escreve
$ha = { param($case) $pp = Join-Path $tmp "partida-$case"; New-Project $pp; $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $hs5 -Accept (Join-Path $checks 'accept.ps1') -Lib (Join-Path $checks 'lib.ps1') -Root $pp -Case $case 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
$r = & $ha 'mesma'
Check 'v3.54.2: 2 primeiros cenários na mesma tela, nenhum passou → para (exit 4) com ESTADO DE PARTIDA e startState; 3 não rodam' $r 0 @('CODE=4 RAN=2', 'ESTADO DE PARTIDA: os 2 primeiros cenários \(SC-101, SC-102\) pararam na mesma tela — br\.x/\.IntroActivity · textos: Bem-vindo\(a\) à Horta', '3 cenário\(s\) não rodaram', '"startState":\s*"br\.x/\.IntroActivity · textos: Bem-vindo\(a\) à Horta"', 'PROGRESS=.*"passed":\s*0.*"failed":\s*2.*"streak":\s*2')
$r = & $ha 'diferente'
Check 'v3.54.2: falhas em telas diferentes → o accept roda todos (exit 1), sem startState' $r 0 @('CODE=1 RAN=5', '"startState":\s*null', '"failed":\s*5')
$r = & $ha 'ocultos'
Check 'v3.62.0: tag ausente nos 2 primeiros na mesma tela → ESTADO DE PARTIDA (o app híbrido com o uiautomator para antes, na CONFIGURAÇÃO DO ALVO); o IDS NÃO PUBLICADOS saiu' $r 0 @('CODE=4 RAN=2', 'ESTADO DE PARTIDA: os 2 primeiros cenários \(SC-101, SC-102\)', '^(?![\s\S]*IDS NÃO PUBLICADOS)', '^(?![\s\S]*content-desc)')
# v3.62.0: paridade dos executores — a página neutra e os cenários de fixtures/parity pelo CDP (toque por dedo, Chromium de
# desktop: o caminho do locator "cdp" sem emulador) e pelo web-runner (Playwright, quando PARITY_PLAYWRIGHT_ROOT o resolve).
$r = & { $ErrorActionPreference = 'Continue'; $o = & node (Join-Path $PSScriptRoot 'parity.js') 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
Check 'v3.62.0: paridade — os 24 cenários (type que substitui, web component, página em cache, display contents, toque coberto, lista inteira, faixa horizontal, select, slider, fora do ASCII; v3.65.1: toque que fecha o alerta, alvo ainda deslizando; v3.65.2: assert que relê até bater e que desiste no prazo, toque que redesenha a lista; v3.65.3: rolador no shadow root com conteúdo por slot e campo de slot emulado, faixa de pílulas ida e volta, toque engolido que se repete e clique cancelado pelo app que não se repete) dão o veredito esperado pelo CDP; web junto quando há Playwright' $r 0 @('paridade: cdp 24/24 · web (24/24|NÃO EXECUTADO)', '^(?![\s\S]*DIVERGE)')
# v3.65.6 (garden S6, SC-161): a fonte de fora que nunca termina segurava o readyState em 'interactive' com o app na tela. O
# padrão novo (DOM lido) passa; o 'complete' estoura o prazo e a mensagem diz a parte falsa, as fontes e o endereço que não chega.
$r = & { $ErrorActionPreference = 'Continue'; $o = & node (Join-Path $PSScriptRoot 'parity.js') --ready 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
Check 'v3.65.6: prontidão com recurso de fora pendente — o padrão passa; readyState complete estoura com a parte falsa, as fontes carregando e o host; as partes do readyExpr por && no nível de fora' $r 0 @('R1=ok', 'R2=o app não ficou pronto em 3 s .*falsa: document\.readyState === ''complete'' — readyState interactive · fontes loading \(Letra Pendente\) — a página espera recurso de fora que não terminou: fontes\.pendente\.test', '^(?![\s\S]*falsa: [^—]*p\.app)', 'R3=\["a","b"\] \| \[\] \| \["f\(x && y\)","''&&''","\[1 && 2\]"\] \| \["a","\(b \|\| c\)","\\"x && y\\""\] \| \[\]')
# v3.64.5: a página do app se acha pela origem, não pela rota da tela — o pageUrl da tela inicial segue valendo depois da
# troca de rota (Capacitor https e http, rota por #, Cordova file://); sem nenhuma página que case, CONFIGURAÇÃO com as URLs vistas.
$cdpJs = (Join-Path $checks 'targets/android-cdp.js') -replace '\\', '/'
$pk = @"
const { choosePage, pageKey, openSession } = require('$cdpJs');
const pg = (id, url) => ({ id, url, type: 'page' });
const pick = (pages, re) => { const p = choosePage(pages, re); return p ? p.id : 'null'; };
console.log('PK1=' + pageKey('https://localhost/tabs/geral?x=1#y') + '|' + pageKey('http://localhost/') + '|' + pageKey('file:///android_asset/www/index.html#/tabs/geral') + '|' + pageKey('https://localhost/#/pedido/42'));
console.log('PK2=' + pick([pg('a', 'https://localhost/tabs/geral')], '^https://localhost/$'));
console.log('PK3=' + pick([pg('a', 'http://localhost/tabs/geral')], '^http://localhost(/|$)'));
console.log('PK4=' + pick([pg('a', 'file:///android_asset/www/index.html#/tabs/geral')], 'index\\.html$'));
console.log('PK5=' + pick([pg('a', 'https://localhost/'), pg('b', 'https://localhost/tabs/geral')], 'tabs/geral'));
console.log('PK6=' + pick([pg('a', 'https://outra.com/')], '^https://localhost/$'));
const http = require('http');
const srv = http.createServer((q, s) => { s.setHeader('content-type', 'application/json'); s.end(JSON.stringify([{ id: 'a', type: 'page', url: 'https://outra.com/login' }, { id: 'b', type: 'page', url: 'about:blank' }])); });
srv.listen(0, '127.0.0.1', async () => {
  try { await openSession({ port: srv.address().port, pageUrl: '^https://localhost/$', callTimeoutMs: 2000, pageWaitMs: 600 }); console.log('PK7=sem erro'); }
  catch (e) { console.log('PK7=' + e.kind + '|' + e.message); }
  const s2 = http.createServer((q, s) => { s.end('[]'); }).listen(0, '127.0.0.1', async () => {
    try { await openSession({ port: s2.address().port, pageUrl: '^https://localhost/$', callTimeoutMs: 2000, pageWaitMs: 600 }); console.log('PK8=sem erro'); }
    catch (e) { console.log('PK8=' + (e.kind || 'fail') + '|' + e.message); }
    srv.close(); s2.close();
  });
});
"@
$pkf = Join-Path $tmp 'v3645-pagekey.js'; [System.IO.File]::WriteAllText($pkf, $pk, (New-Object System.Text.UTF8Encoding($false)))
$r = & { $ErrorActionPreference = 'Continue'; $o = & node $pkf 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
Check 'v3.64.5: a página do app pela URL sem a rota — o pageUrl da tela inicial acha o app em outra aba; Capacitor https/http, rota por #, Cordova file://; a URL inteira tem precedência' $r 0 @('PK1=https://localhost/\|http://localhost/\|file:///android_asset/www/index\.html\|https://localhost/\r?\n', 'PK2=a\b', 'PK3=a\b', 'PK4=a\b', 'PK5=b\b', 'PK6=null')
Check 'v3.64.5: nenhuma página casa o pageUrl → CONFIGURAÇÃO com as URLs vistas (sem about:blank); sem página nenhuma, segue "o app fechou"' $r 0 @('PK7=config\|nenhuma página do /json casa targets\.android\.cdp\.pageUrl \(\^https://localhost/\$\): https://outra\.com/login — o pageUrl é a regex da origem', 'PK8=fail\|a página do app não está no /json')
$r = & $ha 'config'
Check 'v3.62.0: cenário que para na CONFIGURAÇÃO DO ALVO → exit 4, configuration no result.json com os cenários já rodados, sem rodar o resto' $r 0 @('CODE=4 RAN=2', 'CONFIGURAÇÃO DO ALVO \(web\): o APK não liga a depuração da WebView', '"configuration":\s*"o APK não liga a depuração da WebView"', '"environment":\s*"CONFIGURAÇÃO DO ALVO: ', '"passed":\s*1')

# v3.53.7 (encadeamento do sprint 5 do garden, decisões do stakeholder de 04/11): select e seed no accept, premissa de layout
# medida executando, decisões do sprint citadas e não copiadas.
$p = Join-Path $tmp 'v3537-accept'; New-Project $p
Put $p '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-001 Registra em vários`nreset`nseed canteiros-3`nlaunch`nselect canteiro.tipo = Horta`nassert-count canteiro.card. = 3`n`nscenario SC-002 Ruim`nselect canteiro.tipo`nseed`nassert-exists x`n"
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-ParseOnly', '-Root', $p)
Check 'v3.53.7: select sem "=" e seed sem nome reprovam o -ParseOnly' $r 2 @("'select' pede '<id> = <valor>'", "'seed' pede um nome só")
Put $p '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-001 Registra em vários`nreset`nseed canteiros-3`nlaunch`nselect canteiro.tipo = Horta`nassert-count canteiro.card. = 3`n"
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-ParseOnly', '-Root', $p)
Check 'v3.53.7: massa não declarada em targets.<alvo>.seeds reprova o -ParseOnly do QA, antes do aparelho' $r 2 @("cenário SC-001: massa de dados 'canteiros-3' não declarada em guards\.json → targets\.android\.seeds")
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x", "seeds": { "canteiros-3": "exit 0" } } } }'
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-ParseOnly', '-Root', $p)
Check 'v3.53.7: massa declarada e select com opção passam o -ParseOnly' $r 0 @('1 cenário\(s\) válidos', 'SC-001')
# Invoke-TargetSeed: exit 0 carrega; exit ≠ 0 devolve o motivo com a saída; o ambiente leva o alvo e o nome.
$sc = '{ "seeds": { "ok": "if ($env:ACCEPT_TARGET -eq ''android'' -and $env:ACCEPT_SEED -eq ''ok'' -and $env:ACCEPT_PACKAGE -eq ''br.x'') { exit 0 } else { exit 9 }", "ruim": "Write-Output ''tabela canteiros nao existe''; exit 3" } }' | ConvertFrom-Json
# o lib.ps1 grava $script:E (marcadores), que é o $e dos testes (o PowerShell não diferencia maiúsculas) mesmo
# carregado num escopo filho — guarda e devolve o $e.
$sr = & { . (Join-Path $checks 'lib.ps1'); @{ s1 = (Invoke-TargetSeed $p 'android' $sc 'ok' @{ ACCEPT_PACKAGE = 'br.x' }); s2 = (Invoke-TargetSeed $p 'android' $sc 'ruim'); s3 = (Invoke-TargetSeed $p 'android' $sc 'nenhuma') } }
$s1 = $sr.s1; $s2 = $sr.s2; $s3 = $sr.s3; $e = $e0
Check 'v3.53.7: Invoke-TargetSeed — carregou (com o ambiente), falhou (exit e saída) e não declarada' @{ Code = 0; Out = "S1=[$s1]`nS2=[$s2]`nS3=[$s3]" } 0 @('S1=\[\]', "S2=\[massa de dados 'ruim' não carregou \(exit 3\): tabela canteiros nao existe\]", "S3=\[massa de dados 'nenhuma' não declarada")

$p = Join-Path $tmp 'v3537-plano'; New-Project $p
Put $p 'src/a.ts' "bar`nqux`n"
$pl = '.team-project/sprints/1/plan/T-080-x.md'
$h7 = "# Plano`n**Cenários:** nenhum — interno`n**Risco:** regra de negócio`n**Layout novo:** sim`n**Documentos vivos:** ``docs/sdd/03-architecture.md`` §4 — canteiros`n**Envelope de medidas:** nenhum — fixture dos testes de plano (regra 33, v3.57.1)`n"
$b7 = "**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 3. Ambiente`n| Pré-requisito | Comando | Saída real | Log | Atende? |`n|---|---|---|---|---|`n| Node | node -v | v20 | — | sim |`n`n## 6. Testes`n`n**Mutações:**`n- M1 · teste ``tests/a.spec.ts`` · ``src/a.ts`` · ``bar`` → ``baz```n`n"
$f7 = "`n## 9. Onde parar`n- Pré-requisito ausente`n"
Put $p $pl ($h7 + "`n" + $b7 + "### Premissas`n- P1 · o popover abre abaixo do campo, sem sobreposição · medido: ``Grep popover node_modules/@ionic/core/dist`` → placement bottom`n- P2 · src tem a.ts · medido: ``ls src`` → a.ts`n" + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.53.7: com layout novo, premissa de geometria medida por leitura (node_modules) reprova; premissa não geométrica lida passa' $r 1 @('\| premissa \| falhou.*P1 é premissa de layout medida por leitura \(medido: Grep popover node_modules/@ionic/core/dist\).*sonda de render pelo operator', '^(?![\s\S]*P2 é premissa de layout)')
Put $p $pl ($h7 + "`n" + $b7 + "**Envelope de medidas:** nenhum — a tela só ganha um rótulo, sem medida a decidir`n`n### Premissas`n- P1 · o popover abre abaixo do campo, sem sobreposição · medido: job ``operator/1/T-080-plano/`` → caixa do popover y=212, campo y2=200`n- P2 · a margem do card é 16 px · não exercitada: o card nasce no passo 2 · verifica: dev em passo 4 (teste de render)`n" + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.53.7: geometria medida pela sonda do operator, ou não exercitada com o dev no render, passa' $r 0 @('\| premissa \| ok.*2 premissa\(s\): 1 medida')
# v3.57.0 (item 9, regra 33): com Layout novo: sim, o plano traz o envelope de decisão das medidas.
# v3.57.1 (note.md item 7): sem o envelope REPROVA; a saída declarada é "**Envelope de medidas:** nenhum — <motivo>".
Check 'v3.57.1 item 7: Layout novo: sim com "**Envelope de medidas:** nenhum — <motivo>" passa (o plano antigo que volta num GAP não trava)' $r 0 @('\| envelope \| ok.*nenhuma medida visual a decidir — ')
Put $p $pl ($h7.Replace("**Envelope de medidas:** nenhum — fixture dos testes de plano (regra 33, v3.57.1)`n", '') + "`n" + $b7 + "### Premissas`n- P1 · o popover abre abaixo do campo, sem sobreposição · medido: job ``operator/1/T-080-plano/`` → caixa do popover y=212, campo y2=200`n- P2 · a margem do card é 16 px · não exercitada: o card nasce no passo 2 · verifica: dev em passo 4 (teste de render)`n" + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.57.1 item 7: Layout novo: sim sem **Envelope de medidas** → reprova pela regra 33 (era aviso na v3.57.0)' $r 1 @('\| envelope \| falhou.*\*\*Layout novo:\*\* sim sem \*\*Envelope de medidas\*\*.*"\*\*Envelope de medidas:\*\* nenhum — <motivo>" \(regra 33\)')
$env7 = "**Envelope de medidas**:`n- E1 · espaçamento entre os dois botões · sonda: ``operator/1/T-080-plano/medida.ps1`` · (a) se medir 0 px → aplique gap de 8 px · (b) se medir 8 px → nada · fora disso → 🔺 GAP ``aparência```n`n"
Put $p $pl ($h7 + "`n" + $b7 + $env7 + "### Premissas`n- P1 · o popover abre abaixo do campo, sem sobreposição · medido: job ``operator/1/T-080-plano/`` → caixa do popover y=212, campo y2=200`n- P2 · a margem do card é 16 px · não exercitada: o card nasce no passo 2 · verifica: dev em passo 4 (teste de render)`n" + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.57.0 item 9: envelope com sonda e os casos (a)/(b) → ok, 1 medida' $r 0 @('\| envelope \| ok.*1 medida\(s\) com sonda e árvore de decisão', '^(?![\s\S]*AVISO \(regra 33\))')
Put $p $pl ($h7 + "`n" + $b7 + "**Envelope de medidas**:`n- E1 · espaçamento entre os botões · (a) se medir 0 px → aplique gap de 8 px`n`n### Premissas`n- P1 · o popover abre abaixo do campo, sem sobreposição · medido: job ``operator/1/T-080-plano/`` → caixa do popover y=212, campo y2=200`n- P2 · a margem do card é 16 px · não exercitada: o card nasce no passo 2 · verifica: dev em passo 4 (teste de render)`n" + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.57.1 item 7: linha do envelope sem sonda e sem o caso (b) → reprova e nomeia a linha (E1)' $r 1 @('\| envelope \| falhou.*1 linha\(s\) do envelope sem sonda: `<comando>` ou sem os casos "\(a\) se …" e "\(b\) se …": E1 \(regra 33\)')
# v3.57.7 (sprint 6 do garden, T-067): "(a) se `scrollWidth ≤ clientWidth` …" sem a palavra "medir" é a mesma árvore.
Put $p $pl ($h7 + "`n" + $b7 + "**Envelope de medidas**:`n- E1 · quebra do ion-title · sonda: ``getBoundingClientRect`` + ``scrollWidth/clientWidth`` · (a) se ``scrollWidth ≤ clientWidth`` e até 2 linhas, manter · (b) se ficar em 3 linhas sem corte, deixar a toolbar crescer; fora disso → 🔺 GAP ``aparência```n`n### Premissas`n- P1 · o popover abre abaixo do campo, sem sobreposição · medido: job ``operator/1/T-080-plano/`` → caixa do popover y=212, campo y2=200`n" + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.57.7: envelope com "(a) se …" e "(b) se …" sem a palavra medir → ok (T-067 do garden)' $r 0 @('\| envelope \| ok.*1 medida\(s\) com sonda e árvore de decisão')
# v3.57.1 (note.md item 5, regra 34): a dispensa do aceite num lugar só — a frase solta reprova sem a linha **Aceite:** do
# cabeçalho (16 planos do garden dispensaram, a leitura da v3.57.0 reconheceu 7); "- **Aceite de D-8:**" não é a linha;
# com **Cenários:** nenhum não há o que dispensar. Só a linha "aceite" importa aqui (o resto do plano é mínimo).
$h8 = "# Plano`n**Cenários:** SC-014`n**Risco:** regra de negócio`n**Layout novo:** não`n"
$w8 = "- **Decisão herdada do GAP da T-060 (2026-11-02, Arquiteto):** com o emulador fora, o dev não roda ``accept.ps1`` nem ``target.ps1```n- **Aceite de D-8 (ações em coluna):** o stakeholder viu a captura`n`n"
Put $p $pl ($h8 + "`n" + $b7 + $w8 + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.57.1 item 5: o plano dispensa o aceite numa frase e não tem a linha **Aceite:** → reprova pela regra 34 (o item "- **Aceite de D-8:**" não conta)' $r 1 @('\| aceite \| falhou.*o plano dispensa o aceite fora da linha \*\*Aceite:\*\* \(1 linha\(s\), ex\.: "- \*\*Decisão herdada do GAP da T-060.*\(regra 34\)')
Put $p $pl ($h8.Replace("**Layout novo:** não`n", "**Layout novo:** não`n**Aceite:** não roda — D-5: o emulador está fora (o dev não roda o accept.ps1)`n") + "`n" + $b7 + $w8 + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.57.1 item 5: com a linha **Aceite:** do cabeçalho, a frase solta não reprova' @{ Code = 0; Out = $r.Out } 0 @('\| aceite \| ok \| linha do cabeçalho: Aceite: não roda — D-5', '^(?![\s\S]*\| aceite \| falhou)')
Put $p $pl ($h7 + "`n" + $b7 + "**Envelope de medidas:** nenhum — teste`n`n" + $w8 + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.57.1 item 5: com **Cenários:** nenhum não há aceite a dispensar (n-a)' @{ Code = 0; Out = $r.Out } 0 @('\| aceite \| n-a \| \*\*Cenários:\*\* nenhum')
# v3.62.3 (sprint 6 do projeto piloto, Q-S6d): o executor do projeto pelo accept — "**Aceite:** comando — `<cmd>`" passa; o
# "não roda" que prova os cenários por um script do projeto reprova e aponta o comando; comando sem {scn} ou proibido reprova.
$h62 = { param($ac) $h8.Replace("**Layout novo:** não`n", "**Layout novo:** não`n$ac`n") + "`n" + $b7 + $f7 }
Put $p $pl (& $h62 '**Aceite:** comando — `node tools/prova.mjs --cenarios {scn} --saida {out} --only {only}`')
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.62.3: **Aceite:** comando com {scn} e {out} → ok, o accept.ps1 roda o executor um .scn por vez' @{ Code = 0; Out = $r.Out } 0 @('\| aceite \| ok \| executor do projeto `node tools/prova\.mjs --cenarios \{scn\} --saida \{out\} --only \{only\}` — o accept\.ps1 o roda um \.scn por vez', '^(?![\s\S]*sem \{out\})')
Put $p $pl (& $h62 '**Aceite:** não roda — o accept não acha id do app (D-16); os 49 se provam pelo `prova-cdp.mjs`, pelo operator')
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.62.3: **Aceite:** não roda que prova os cenários por script do projeto → reprova e aponta o **Aceite:** comando (o accept.ps1 citado não conta)' $r 1 @('\| aceite \| falhou \| \*\*Aceite:\*\* não roda e os cenários se provam por prova-cdp\.mjs — é o aceite por outro executor', 'declare `\*\*Aceite:\*\* comando — `<comando com \{scn\} e \{out\}>``', '^(?![\s\S]*se provam por accept\.ps1)')
# v3.65.3 (garden Q-S6g): o "roda" que prova pelo script do projeto também reprova; o "roda" que só diz quem roda (ou cita o
# accept.ps1) passa; linha fora das três formas reprova com elas.
Put $p $pl (& $h62 '**Aceite:** roda — operator, pelo dev, no passo 1, pelo executor do projeto (`prova-cdp.mjs --only SC-122,SC-147,SC-161`)')
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.65.3: **Aceite:** roda que prova os cenários pelo script do projeto → reprova e aponta o **Aceite:** comando' $r 1 @('\| aceite \| falhou \| \*\*Aceite:\*\* roda e os cenários se provam por prova-cdp\.mjs — é o aceite por outro executor', 'o close exige o do accept\.ps1', 'declare `\*\*Aceite:\*\* comando — `<comando com \{scn\} e \{out\}>``')
Put $p $pl (& $h62 '**Aceite:** roda — operator, pelo dev, no passo 5 (`accept.ps1 -Task T-041 -Only SC-210`)')
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.65.3: **Aceite:** roda que cita só o accept.ps1 → ok' @{ Code = 0; Out = $r.Out } 0 @('\| aceite \| ok \| linha do cabeçalho: Aceite: roda — operator', '^(?![\s\S]*\| aceite \| falhou)')
Put $p $pl (& $h62 '**Aceite:** pendente para o QA (D-4) — o dev não roda o accept')
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.65.3: **Aceite:** fora das três formas → reprova com as formas que os scripts leem' $r 1 @('\| aceite \| falhou \| \*\*Aceite:\*\* "pendente para o QA \(D-4\)', 'fora das três formas', '`roda — <quem roda>`', '`não roda — <motivo>`', '`comando — `<cmd com \{scn\}>``')
Put $p $pl (& $h62 '**Aceite:** comando — `node tools/prova.mjs --saida {out}`')
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.62.3: **Aceite:** comando sem {scn} → reprova (o accept chama um arquivo de cenários por vez)' $r 1 @('\| aceite \| falhou \| \*\*Aceite:\*\* comando sem \{scn\}')
Put $p $pl (& $h62 '**Aceite:** comando — `npm install; node tools/prova.mjs --cenarios {scn}`')
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.62.3: **Aceite:** comando com instalação → reprova; sem {out}, o ok avisa' $r 1 @('\| aceite \| falhou \| \*\*Aceite:\*\* comando que o run nunca roda: npm install \(instalação\)')
$ps62 = Join-Path $tmp 'plan-scenarios-v3623.ps1'
[System.IO.File]::WriteAllText($ps62, @'
param([string]$Lib)
. $Lib
$a = Get-PlanScenarios "**Cenários:** SC-014, SC-015 (teste)`r`n**Aceite:** comando — ``x {scn}```r`n"
'T=' + ($a.Target -join ',') + ' X=' + ($a.Test -join ',') + ' C=' + $a.Command + ' W=' + [bool]$a.Waived
$b = Get-PlanScenarios "**Cenários:** SC-014`n**Aceite:** não roda — testes do plano`n"
'T2=' + ($b.Target -join ',') + ' W2=' + [bool]$b.Waived
'@, (New-Object System.Text.UTF8Encoding($true)))
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $ps62 -Lib (Join-Path $checks 'lib.ps1') 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
Check 'v3.62.3: com **Aceite:** comando os cenários ficam no alvo (o cartão, o start e o close mandam o accept); com não roda, vão aos testes do plano' $r 0 @('T=SC-014 X=SC-015 C=x \{scn\} W=False', 'T2= W2=True')
Put $p '.team-project/architect/decisions/S1.md' "# Decisões do sprint 1`n`n## D-1 — Emulador fora do ar`n**Vale para:** todas · **Origem:** 🔺 GAP da T-041 · 2026-11-02`nCom o alvo fora do ar depois do reparo, a Task vai a bloqueada com prova no alvo pendente.`n`n## D-2 — APK antes do accept`n**Vale para:** T-080 · **Origem:** 🔺 GAP da T-041`nReconstruir o APK com assembleDebug antes de todo accept da Task de ids de teste.`n"
Put $p $pl ($h7 + "**Decisões do sprint:** D-1, D-9`n`n" + $b7 + "Reconstruir o APK com assembleDebug antes de todo accept da Task de ids de teste.`n`n### Premissas`n- P1 · src tem a.ts · medido: ``ls src`` → a.ts`n- P2 · a margem é 16 px · não exercitada: nasce no passo 2 · verifica: dev em passo 4`n" + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.53.7: decisão do sprint inexistente citada e texto de decisão copiado no plano reprovam (regra 29)' $r 1 @('\| decisões \| falhou.*cita D-9 que não existe\(m\) em architect/decisions/S1\.md.*copia o texto da D-2')
Put $p $pl ($h7 + "**Decisões do sprint:** D-1, D-2`n`n" + $b7 + "### Premissas`n- P1 · src tem a.ts · medido: ``ls src`` → a.ts`n- P2 · a margem é 16 px · não exercitada: nasce no passo 2 · verifica: dev em passo 4`n" + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.53.7: plano que só cita as decisões passa' $r 0 @('\| decisões \| ok.*cita D-1, D-2; 2 decisão\(ões\) no sprint, 0 K no projeto, nenhuma copiada', '\| herdados \| n-a')
# v3.65.4 (regra 34): a decisão do sprint que chega à Task (citada, ou com a Task no Vale para) e prova os cenários por
# script do projeto, ou dispensa o aceite, sem a linha **Aceite:** no plano → reprova; com a linha, ou decisão só "todas"
# não citada, ou script do plugin, não.
$dec65 = "# Decisões do sprint 1`n`n## D-1 — Emulador fora do ar`n**Vale para:** todas · **Origem:** 🔺 GAP da T-041 · 2026-11-02`nCom o alvo fora do ar depois do reparo, a Task vai a bloqueada com prova no alvo pendente.`n`n## D-2 — APK antes do accept`n**Vale para:** T-080 · **Origem:** 🔺 GAP da T-041`nReconstruir o APK com assembleDebug antes de todo accept da Task de ids de teste.`n"
Put $p '.team-project/architect/decisions/S1.md' ($dec65 + "`n## D-3 — Prova cruzada pelo executor do projeto`n**Vale para:** todas (prova pelo ``tools/prova.mjs``)`nO achado se dá por provado quando os passos dele passam.`n`n## D-4 — Alvo fora na Task de exportação`n**Vale para:** T-080`nCom o emulador fora, o dev não roda o accept; a prova é a captura.`n`n## D-5 — Rodada do aceite`n**Vale para:** todas`nOs cenários se provam pelo ``accept.ps1 -Only`` com os que falharam.`n")
$h654 = { param($extra) "# Plano`n**Cenários:** SC-014`n**Risco:** regra de negócio`n**Layout novo:** não`n$extra`n" + $b7 + $f7 }
Put $p $pl (& $h654 '**Decisões:** D-3')
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.65.4: plano sem **Aceite:** que cita decisão de prova por script do projeto → reprova e aponta a linha' $r 1 @('\| aceite \| falhou \| o plano não tem a linha \*\*Aceite:\*\* e a D-3 prova os cenários por tools/prova\.mjs', 'a D-4 dispensa o aceite', '`\*\*Aceite:\*\* comando — `<cmd com \{scn\} e \{out\}>``')
Put $p $pl (& $h654 "**Decisões:** D-3`n**Aceite:** comando — ``node tools/prova.mjs {scn} {out}``")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.65.4: com **Aceite:** comando, a decisão de prova por script do projeto não reprova' @{ Code = 0; Out = $r.Out } 0 @('\| aceite \| ok \| executor do projeto', '^(?![\s\S]*\| aceite \| falhou)')
Put $p '.team-project/architect/decisions/S1.md' ($dec65 + "`n## D-3 — Prova cruzada pelo executor do projeto`n**Vale para:** todas (prova pelo ``tools/prova.mjs``)`nO achado se dá por provado quando os passos dele passam.`n`n## D-5 — Rodada do aceite`n**Vale para:** todas`nOs cenários se provam pelo ``accept.ps1 -Only`` com os que falharam.`n")
Put $p $pl (& $h654 '**Decisões:** D-5')
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.65.4: decisão "todas" não citada e decisão que só cita script do plugin não reprovam' @{ Code = 0; Out = $r.Out } 0 @('\| aceite \| n-a \| o plano não dispensa o aceite')
Put $p '.team-project/architect/decisions/S1.md' $dec65
# v3.55.0 (A4): plano que corrige outra Task traz "### Testes herdados"; plano comum não é afetado.
$prem = "### Premissas`n- P1 · src tem a.ts · medido: ``ls src`` → a.ts`n- P2 · a margem é 16 px · não exercitada: nasce no passo 2 · verifica: dev em passo 4`n"
Put $p $pl ($h7 + "**Corrige:** T-040`n`n" + $b7 + $prem + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.55.0 A4: plano com **Corrige:** sem ### Testes herdados reprova' $r 1 @('\| herdados \| falhou.*corrige T-040 e não tem .### Testes herdados.')
Put $p $pl ($h7 + "**Corrige:** T-040`n`n" + $b7 + $prem + "`n### Testes herdados`n- ``tests/t040.spec.ts`` · a fixture troca content-desc por text`n" + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.55.0 A4: com a seção e uma linha passa' $r 0 @('\| herdados \| ok.*1 linha\(s\) em ### Testes herdados \(T-040\)')
Put $p $pl ($h7 + "**Corrige:** T-040`n`n" + $b7 + $prem + "`n### Testes herdados`n- nenhum — a Task original não tem teste sobre a regra corrigida`n" + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.55.0 A4: "nenhum — motivo" passa' $r 0 @('\| herdados \| ok')
Put $p $pl ($h7 + "**Corrige:** T-040`n`n" + $b7 + $prem + "`n### Testes herdados`n- nenhum`n" + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.55.0 A4: "nenhum" sem motivo reprova' $r 1 @('\| herdados \| falhou.*nenhum. sem motivo')
# v3.55.0 (F1, regra 32): "### Comandos da Task" conferida contra a lista da G14 + runCommands (o mesmo casamento por prefixo).
$script:autoCmds = $false
$gjPath = Join-Path $p '.team-project/guards.json'
$gjBefore = if (Test-Path -LiteralPath $gjPath) { [System.IO.File]::ReadAllText($gjPath, $utf8) } else { $null }
Put $p '.team-project/guards.json' '{ "runCommands": ["npm run test:alvo"], "verify": { "focused": "powershell -NoProfile -File tests/check.ps1 {tests}" } }'
$planCmd = { param($cmds) Put $p $pl ($h7 + "`n" + $b7 + $prem + "`n### Comandos da Task`n" + $cmds + $f7) }
& $planCmd "- ``npm run test:alvo`` · testes node:test do alvo`n- ``git status`` · estado`n"
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.55.0 F1: comando que o runCommands cobre por prefixo e o da lista base passam' $r 0 @('\| comandos \| ok.*todos os comandos da Task já estão na lista base ou em runCommands')
& $planCmd "- ``docker compose run --rm app npm test`` · testes em container`n- ``npm run test:alvo`` · alvo`n"
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.55.0 F1: comando ausente de runCommands é listado como faltante (o prefixo a liberar), sem reprovar o plano' $r 0 @('\| comandos \| ok.*faltam em guards\.json → runCommands: docker compose run — o run\.ps1 pede', '^(?![\s\S]*faltam[^\n]*npm run test:alvo)')
& $planCmd "- nenhum além da lista base`n"
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.55.0 F1: "nenhum além da lista base" passa' $r 0 @('\| comandos \| ok.*nenhum além da lista base')
& $planCmd "- ``npm install left-pad`` · dependência`n"
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.55.0 F1: comando de instalação reprova o plano (bloqueio da Task, degrau 1)' $r 1 @('\| comandos \| falhou.*npm install left-pad \(instalação\).*degrau 1')
Put $p $pl ($h7 + "`n" + $b7 + $prem + $f7)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.55.0 F1: plano sem ### Comandos da Task reprova' $r 1 @("\| comandos \| falhou.*plano sem '### Comandos da Task'")
if ($null -ne $gjBefore) { Put $p '.team-project/guards.json' $gjBefore } else { Remove-Item -LiteralPath $gjPath -Force -ErrorAction SilentlyContinue }
$script:autoCmds = $true
# Cartão do dev: a decisão "todas" entra em uma linha; a que vale só para outra Task, não.
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$card = Join-Path $p '.team-project/sprints/1/handoff/T-041.md'
Check 'v3.53.7: cartão traz as decisões do sprint que valem para a Task, uma linha cada' @{ Code = $r.Code; Out = $(if (Test-Path -LiteralPath $card) { [System.IO.File]::ReadAllText($card, $utf8) } else { 'sem cartão' }) } 0 @('\*\*Decisões do sprint\*\* \(`architect/decisions/S1\.md`', '- D-1 — Emulador fora do ar: Com o alvo fora do ar', '^(?![\s\S]*D-2 — APK)')
$dg = & { . (Join-Path $checks 'lib.ps1'); Get-DecisionsDigest $p '1' }; $e = $e0
Check 'v3.53.7: recorte da ficha traz todas as decisões, com a quem valem, para o Arquiteto citar' @{ Code = 0; Out = $dg } 0 @('## Decisões do sprint', 'D-1 — Emulador fora do ar · vale para todas', 'D-2 — APK antes do accept · vale para T-080', 'cite, não copie')
# v3.57.2 (note.md item 15, ocorrência 7): "nenhum aplicável — motivo" na linha **Cenários:** vale como "nenhum — motivo".
$nap = & { . (Join-Path $checks 'lib.ps1'); $a = Get-PlanScenarios "# P`n**Cenários:** nenhum aplicável — refatoração interna`n"; $b = Get-PlanScenarios "# P`n**Cenários:** nenhum — interno`n"; "A=$($a.None)|$($a.Reason) B=$($b.None)|$($b.Reason)" }; $e = $e0
Check 'v3.57.2 item 15: "nenhum aplicável — motivo" e "nenhum — motivo" na linha **Cenários:** do plano valem igual' @{ Code = 0; Out = $nap } 0 @('A=True\|refatoração interna B=True\|interno')
# v3.57.2 (note.md item 18, ocorrência 5): ChromeHeadless que não sobe por pasta temporária (Chrome órfão) não é "navegador não instalado".
$ef = & { . (Join-Path $checks 'lib.ps1'); 'T=' + (Get-EnvFailure "ERROR [launcher]: Cannot start ChromeHeadless`n[ERROR:file_util.cc] Failed to create a temp dir") + ' | N=' + (Get-EnvFailure 'ERROR [launcher]: No binary for ChromeHeadless browser') }; $e = $e0
Check 'v3.57.2 item 18: Chrome órfão (pasta temporária) tem mensagem própria; navegador ausente segue com a de instalar' @{ Code = 0; Out = $ef } 0 @('T=o ChromeHeadless não subiu por resto de rodada anterior.*Chrome órfão', 'N=o navegador headless não está instalado')

# v3.54 (decisões do stakeholder de 04/11): mutação declarada pela regra, com o trecho escrito pelo dev sobre o código real,
# e a margem do dev (defeito do próprio teste, CSS da regra do projeto) com as travas conferidas no close.
$p = Join-Path $tmp 'v354'; New-Project $p
$ErrorActionPreference = 'Continue'
& git -C $p init -q 2>$null; Put $p '.gitignore' ".team-project/`n"
Put $p 'src/calc.ts' "export function soma(a, b) {`n  return a + b; // fim`n}`n"
Put $p 'tests/check.ps1' 'param($t) if ((Get-Content src/calc.ts -Raw) -match "a \+ b") { "Tests: 1 passed" } else { "Tests: 1 failed"; exit 1 }'
Put $p 'tests/other.ps1' '"Tests: 1 passed"'
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $p '.team-project/guards.json' '{ "verify": { "focused": "powershell -NoProfile -File tests/check.ps1 {tests}", "suite": "powershell -NoProfile -File tests/check.ps1 all" } }'
$pl = '.team-project/sprints/1/plan/T-041-export.md'
Edit-File (Join-Path $p $pl) '## 3. Ambiente' ("**Arquivos tocados:** ``src/calc.ts```n``tests/check.ps1```n``tests/other.ps1```n`n**Mutações:**`n- M1 · teste ``tests/check.ps1`` · ``src/calc.ts`` · regra: somar deixa de ser soma (o resultado muda de operação)`n`n## 3. Ambiente")
$dvp = Join-Path $p '.team-project/sprints/1/delivery/T-041.md'
Put $p '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041`n`n### Gaps levantados`nnenhum`n"
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
Check 'v3.54: mutação pela regra sem o trecho do dev: inconclusiva, com o que escrever' $r 1 @('M1 src/calc\.ts: inconclusivo — declarada pela regra \(somar deixa de ser soma.*sem o trecho do dev')
[System.IO.File]::AppendAllText($dvp, "`n## Entrega — T-041 (fim)`n`n**Mutações:**`n- M1 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a - b```n", $utf8)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
Check 'v3.54: com o trecho do dev no relatório, a mutação roda, é pega e leva a regra ao registro' $r 0 @('M1 src/calc\.ts: ok.*regra: somar deixa de ser soma.*trecho do dev: `a \+ b` → `a - b`')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.54: close — R7-mutação ok pela linha do dev; sem ajuste na margem, R7-margem n-a' $r 0 @('\| R7-mutação \| ok.*M1', '\| R7-margem \| n-a')
[System.IO.File]::AppendAllText($dvp, "`n## Retomada`n`n**Mutações:**`n- M1 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``// fim`` → ``// x```n", $utf8)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
Check 'v3.54: trecho do dev trocado na mesma árvore roda de novo (a última linha vale) — a decorativa não é pega' $r 1 @('M1 src/calc\.ts: falhou')
[System.IO.File]::AppendAllText($dvp, "`n### Ajustes na margem`n- A1 · teste · ``tests/check.ps1`` · a espera passou a aguardar o elemento antes de medir`n- A2 · css · ``src/calc.ts`` · botão de 40 para 44 px`n- A3 · teste · ``tests/other.ps1`` · referência de medida trocada para a janela`n- A4 · teste · ``tests/fora.ps1`` · x`n- ajuste solto sem formato`n", $utf8)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.54: margem sem as travas não fecha — teste com mutação não pega, CSS sem regra, teste sem mutação, fora da lista, linha solta' $r 1 @('\| R7-margem \| falhou.*A1: a\(s\) mutação\(ões\) M1 do teste tests/check\.ps1 não foram pegas.*A2: ajuste de CSS sem .regra:.*A3: o teste tests/other\.ps1 não tem mutação no plano.*A4: tests/fora\.ps1 fora de \*\*Arquivos tocados:\*\*', 'linha fora do formato', 'Não fecha')
Put $p '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041`n`n**Mutações:**`n- M1 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a - b```n`n### Ajustes na margem`n- A1 · teste · ``tests/check.ps1`` · a espera passou a aguardar o elemento antes de medir`n- A2 · css · ``src/calc.ts`` · botão de 40 para 44 px · regra: standards/ui.md §3 (alvo de toque 44 px)`n"
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.54: margem com as travas fecha — teste ajustado com a mutação pega na árvore final, CSS com a regra citada' $r 0 @('\| R7-margem \| ok.*2 ajuste\(s\).*A1 teste \(M1 pegas\).*A2 css \(standards/ui\.md §3')
# v3.54.1 (carta do sprint 5 do garden, item 2): margem stub — spec que já existia, fora da lista, que monta um arquivo do
# plano e ganhou o stub da dependência nova. Alterado sem a linha, não fecha; com ela, fecha; o que não monta nada é GAP.
$ErrorActionPreference = 'Continue'
Put $p 'tests/calc.render.spec.ts' "import { soma } from '../src/calc';`n// casos`n"
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm spec 2>$null
$ErrorActionPreference = 'Stop'
Put $p 'tests/calc.render.spec.ts' "import { soma } from '../src/calc';`n// stub do FornecedorService`n// casos`n"
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.54.1: spec fora da lista que monta arquivo do plano, alterado sem a linha stub → R7-margem não fecha' $r 1 @('\| R7-margem \| falhou.*tests/calc\.render\.spec\.ts \(teste fora da lista que monta src/calc\.ts\) foi alterado sem linha')
# v3.60.1 (sprint 6 do garden, T-093): o mesmo arquivo, já alterado quando a Task começou (retrato do run.ps1 start) e igual
# desde então, não é da Task — o close não o cobra; mexido depois do retrato, volta a cobrar.
$frg = Join-Path $p '.team-project/sprints/1/handoff/T-041-alheios.json'
$sha1 = [System.Security.Cryptography.SHA1]::Create(); $hsh = ([BitConverter]::ToString($sha1.ComputeHash([System.IO.File]::ReadAllBytes((Join-Path $p 'tests/calc.render.spec.ts')))) -replace '-', '').ToLowerInvariant(); $sha1.Dispose()
Put $p '.team-project/sprints/1/handoff/T-041-alheios.json' ('{ "task": "T-041", "at": "2026-11-15 10:00:00", "files": { "tests/calc.render.spec.ts": "' + $hsh + '" } }')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.60.1: arquivo alterado antes da Task e igual desde então não trava o R7-margem' @{ Code = $r.Code; Out = $r.Out } 0 @('^(?![\s\S]*foi alterado sem linha)')
Put $p '.team-project/sprints/1/handoff/T-041-alheios.json' '{ "task": "T-041", "at": "2026-11-15 10:00:00", "files": { "tests/calc.render.spec.ts": "0000" } }'
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.60.1: alterado depois do retrato do start, volta a ser da Task — R7-margem cobra' $r 1 @('\| R7-margem \| falhou.*tests/calc\.render\.spec\.ts \(teste fora da lista que monta src/calc\.ts\) foi alterado sem linha')
Remove-Item -LiteralPath $frg -Force
[System.IO.File]::AppendAllText($dvp, "- A3 · stub · ``tests/calc.render.spec.ts`` · stub do FornecedorService (inject novo em src/calc.ts)`n- A4 · stub · ``tests/other.ps1`` · x`n", $utf8)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.54.1: stub de teste que não monta arquivo do plano é GAP; o declarado deixa de ser cobrado' $r 1 @('\| R7-margem \| falhou.*A4: tests/other\.ps1 não é teste existente que cita um arquivo', '^(?![\s\S]*foi alterado sem linha)')
Edit-File $dvp "- A4 · stub · ``tests/other.ps1`` · x`n" ''
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.54.1: margem stub com a linha fecha' $r 0 @('\| R7-margem \| ok.*3 ajuste\(s\).*A3 stub \(tests/calc\.render\.spec\.ts monta src/calc\.ts\)')
# v3.65.0 (decisão Q1 do stakeholder): o C1 confere os arquivos mudados × o plano — o que escapou da G9 aparece na linha
# R4-arquivos (reprova o R4, não trava o close: o QA decide no portão); a margem declarada não conta.
Put $p 'src/extra.ts' "export const x = 1;`n"
# a árvore mudou: sem o verify de novo, o R7-verify (que bloqueia) reprovaria antes — o caso mede só o R4-arquivos
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.65.0 Q1: arquivo alterado fora de **Arquivos tocados:** e fora da margem → R4-arquivos falhou com o caminho; o close não trava por ele' $r 0 @('\| R4-arquivos \| falhou \| \d+ arquivo\(s\) alterado\(s\) fora de \*\*Arquivos tocados:\*\*.*`src/extra\.ts`', '^(?![\s\S]*R4-arquivos[^\r\n]*tests/calc\.render\.spec\.ts)')
Remove-Item -LiteralPath (Join-Path $p 'src/extra.ts') -Force
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Root', $p)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.65.0 Q1: sem o arquivo fora do plano, a linha R4-arquivos não o cita' $r 0 @('\| R4-arquivos \| (ok|falhou)', '^(?![\s\S]*src/extra\.ts)')
# v3.55.0 (A3): margem fixture — fecha com a regra do padrão de ids; sem regra e com dump inexistente não fecha.
[System.IO.File]::AppendAllText($dvp, "- A7 · fixture · ``tests/check.ps1`` · content-desc trocado por text na fixture · regra: standards/test-ids.md §4 (id é o seletor)`n", $utf8)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.55.0 A3: fixture com a regra do padrão de ids fecha' $r 0 @('\| R7-margem \| ok.*A7 fixture \(standards/test-ids\.md')
Edit-File $dvp "- A7 · fixture · ``tests/check.ps1`` · content-desc trocado por text na fixture · regra: standards/test-ids.md §4 (id é o seletor)`n" "- A7 · fixture · ``tests/check.ps1`` · content-desc trocado por text na fixture`n"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.55.0 A3: fixture sem regra não fecha' $r 1 @('\| R7-margem \| falhou.*A7: ajuste de fixture sem .regra:')
Edit-File $dvp "content-desc trocado por text na fixture`n" "content-desc trocado por text na fixture · regra: dump .team-project/operator/5/T-071/dump-que-nao-existe.xml`n"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.55.0 A3: fixture com dump inexistente não fecha' $r 1 @('\| R7-margem \| falhou.*A7: o dump citado na regra não existe: \.team-project/operator/5/T-071/dump-que-nao-existe\.xml')
Edit-File $dvp "- A7 · fixture · ``tests/check.ps1`` · content-desc trocado por text na fixture · regra: dump .team-project/operator/5/T-071/dump-que-nao-existe.xml`n" ''
# v3.55.0 (A1): linha fora do formato (sem crases) não esconde as outras travas — a saída traz o formato E a falta de mutação.
[System.IO.File]::AppendAllText($dvp, "- A5 · teste · tests/other.ps1 · mudou a referência`n", $utf8)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.55.0: A1 — linha sem crases devolve o formato e a falta de mutação numa única saída (v3.64.0: o formato lido vira aviso; a trava segue reprovando)' $r 1 @('\| R7-margem \| falhou.*A5: o teste tests/other\.ps1 não tem mutação no plano.*aviso: linha A5 fora do formato \(lida assim mesmo\).*tests/other\.ps1')
Edit-File $dvp "- A5 · teste · tests/other.ps1 · mudou a referência`n" ''
# v3.55.0 (A2): plano com "sem prova:" — ajuste de teste vai direto ao GAP, com a mensagem que diz isso.
Edit-File (Join-Path $p $pl) '## 3. Ambiente' "sem prova: teste node:test fora do verificador`n`n## 3. Ambiente"
[System.IO.File]::AppendAllText($dvp, "- A6 · teste · ``tests/check.ps1`` · fixture trocada`n", $utf8)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.55.0: A2 — plano em sem prova: ajuste de teste não passa pela margem, abre GAP' $r 1 @('\| R7-margem \| falhou.*A6: o plano declara .sem prova: .*GAP com esta linha')
Edit-File $dvp "- A6 · teste · ``tests/check.ps1`` · fixture trocada`n" ''
# plan.ps1: o trecho literal só quando já existe no código; a regra diz o que quebra.
Put $p $pl ("# Plano`n**Cenários:** nenhum — interno`n**Risco:** regra de negócio`n`n**Arquivos tocados:** ``src/calc.ts```n``src/novo.ts```n``tests/check.ps1```n`n**Arquivos protegidos:** nenhum`n`n## 3. Ambiente`n| Pré-requisito | Comando | Saída real |`n|---|---|---|`n| Node | node -v | v20 |`n`n## 6. Testes`n`n**Mutações:**`n- M1 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``a * b`` → ``a / b```n- M2 · teste ``tests/check.ps1`` · ``src/novo.ts`` · ``x > 1`` → ``x >= 1```n- M3 · teste ``tests/check.ps1`` · ``src/novo.ts`` · regra: curta`n- M4 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``a + b`` → ``a - b```n`n## 9. Onde parar`n- Pré-requisito ausente`n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.54: plano com trecho adivinhado (inexistente no código ou em arquivo novo) e regra vazia reprova; trecho que já existe passa' $r 1 @('\| mutação \| falhou.*M1: o trecho ainda não existe em src/calc\.ts — declare pela regra.*M2: o trecho ainda não existe em src/novo\.ts.*M3: .regra:. vazia ou curta', '^(?![\s\S]*M4: o trecho)')

# v3.54.1 (carta do sprint 5 do garden, item 2): plano reconferido com a construção no meio — a contagem escrita antes dela
# vale também pelo último commit; número que não bate em nenhum dos dois segue reprovando.
$plc = '.team-project/sprints/1/plan/T-099-contagem.md'
$calc0 = [System.IO.File]::ReadAllText((Join-Path $p 'src/calc.ts'), $utf8)
Put $p 'src/calc.ts' ($calc0 + "export const soma2 = soma;`n")
Put $p $plc "# Plano`n**Cenários:** nenhum — interno`n**Risco:** interface simples`n`n**Arquivos tocados:** ``src/calc.ts```n`n## 6. Testes`n`n### Premissas`n- Contagem: ``soma`` em ``src/*.ts`` → 1`n`n## 9. Onde parar`n- x`n"
$r = Invoke-Check 'plan.ps1' @('-Plan', $plc, '-Root', $p)
Check 'v3.54.1: contagem que bate no último commit (a árvore já tem a construção) passa' @{ Code = 0; Out = $r.Out } 0 @('\| contagem \| ok.*1 pelo último commit')
Edit-File (Join-Path $p $plc) '→ 1' '→ 3'
$r = Invoke-Check 'plan.ps1' @('-Plan', $plc, '-Root', $p)
Check 'v3.54.1: contagem que não bate nem na árvore nem no último commit reprova' @{ Code = 0; Out = $r.Out } 0 @('\| contagem \| falhou.*o plano diz 3, a recontagem dá 2')
Put $p 'src/calc.ts' $calc0
# run.ps1 start: plano acima do teto não vai ao dev; com a construção começada, troca do trecho superado (sem divisão).
Put $p $pl ("# Plano`n**Arquivos tocados:** ``src/calc.ts```n" + ('x' * 32000))
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
Check 'v3.54.1: start com plano acima do teto e construção começada → Arquiteto troca o trecho superado, sem divisão' $r 2 @('tem\s+[\d.,]+\s+KB', 'Task\s+não\s+se\s+divide', 'Substitua\s+no\s+plano\s+o\s+texto')
Remove-Item -LiteralPath $dvp -Force
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
Check 'v3.54.1: start com plano acima do teto antes da construção → divisão pelo next' $r 2 @('vai\s+à\s+divisão\s+antes\s+do\s+dev')

# v3.55.0 (F2): comandos dos planos — o start para uma vez com os faltantes; o allow grava em runCommands (resto do guards.json
# intacto) e no run-log; o mesmo comando não é perguntado de novo; negado volta ao Arquiteto; instalação não passa.
$p = Join-Path $tmp 'cmds'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
Put $p '.team-project/guards.json' "{`n  `"verify`": { `"suite`": `"x`" }`n}`n"
$plF = Join-Path $p '.team-project/sprints/1/plan/T-041-export.md'
$planBase = [System.IO.File]::ReadAllText($plF, $utf8)
[System.IO.File]::WriteAllText($plF, $planBase.TrimEnd() + "`n`n### Comandos da Task`n- ``docker compose run --rm app npm test`` · testes em container`n- ``aapt dump badging app.apk`` · leitura do apk`n- ``git status`` · estado`n", $utf8)
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
Check 'v3.55.0 F2: start com comandos que a G14 não libera para antes do dev e lista os prefixos faltantes de todos os planos da História' $r 2 @('PARADA ÚNICA', 'docker compose run\s+\(T-041', 'aapt dump badging\s+\(T-041', 'UM formulário', 'run\.ps1 allow -Commands', '^(?![\s\S]*dispatch: developer)')
$r = Invoke-Check 'run.ps1' @('allow', '-Commands', 'npm install left-pad', '-Root', $p)
Check 'v3.55.0 F2: allow recusa comando de instalação (não entra no run)' $r 2 @('instalação, rede, push e destrutivo não entram no run')
# v3.64.1 (sprint 6 do projeto piloto, 19/11): o script do plugin não vai a runCommands, nem pelo nome nem pelo caminho do cache.
$r = Invoke-Check 'run.ps1' @('allow', '-Commands', "& 'C:\Users\x\.claude\plugins\cache\team\team\3.64.0\accept.ps1'; verify.ps1", '-Root', $p)
$gj641 = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/guards.json'), $utf8)
Check 'v3.64.1: allow recusa script do plugin (caminho do cache com a versão, ou o nome solto) e não grava nada' @{ Code = $r.Code; Out = $r.Out + "`n" + $gj641 } 2 @('script do plugin não vai a runCommands', 'a mensagem da G14 traz o certo', '^(?![\s\S]*plugins\\cache[^\r\n]*"\s*\])', '^(?![\s\S]*"verify\.ps1")')
$r = Invoke-Check 'run.ps1' @('allow', '-Commands', 'docker compose run', '-Deny', 'aapt dump badging', '-By', 'Marco', '-Root', $p)
$gjAfter = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/guards.json'), $utf8)
$rlAfter = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/run-log.md'), $utf8)
Check 'v3.55.0 F2: allow grava o liberado em runCommands (verify intacto), registra quem autorizou e nega o resto' @{ Code = $r.Code; Out = $r.Out + "`n" + $gjAfter + "`n" + $rlAfter } 0 @('1 liberado\(s\)', '1 negado\(s\)', '"runCommands": \["docker compose run"\]', '"verify": \{ "suite": "x" \}', 'liberou: docker compose run.*autorizado por Marco', 'negou: aapt dump badging')
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
Check 'v3.55.0 F2: comando negado volta ao Arquiteto — o start não dispara o dev e não pergunta de novo o que já foi decidido' $r 2 @('stakeholder negou \(aapt dump badging\)', 'Arquiteto', '^(?![\s\S]*PARADA ÚNICA)')
[System.IO.File]::WriteAllText($plF, $planBase.TrimEnd() + "`n`n### Comandos da Task`n- ``docker compose run --rm app npm test`` · testes em container`n- ``git status`` · estado`n", $utf8)
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
Check 'v3.55.0 F2: com o comando liberado e o negado fora do plano, o start segue sem nova parada' $r 0 @('dispatch: developer · T-041', 'prompt do dev')

# v3.54.1 (carta do sprint 5 do garden, item 1): serial de rede — o pré-voo religa (adb connect) antes de reprovar e separa
# porta recusada, aparelho offline e tempo ligado; o reparo religa em laço em vez do wait-for-device (adb falso).
$hs4 = Join-Path $tmp 'android-rede.ps1'
[System.IO.File]::WriteAllText($hs4, @'
param([string]$Adapter, [string]$Case)
$ErrorActionPreference = 'Stop'
. $Adapter
$script:Serial = if ($Case -eq 'local') { 'emulator-5554' } else { 'localhost:5555' }
$script:AdCfg = [pscustomobject]@{ package = 'br.x'; maxUptimeHours = 3 }
function Start-Sleep { }
$script:conn = $false; $script:tries = 0; $script:log = New-Object Collections.Generic.List[string]
function AdbT([int]$Sec, [string[]]$A) {
    $script:AdbTimeout = ''; $k = @($A) -join ' '; $script:log.Add($k)
    if ($k -eq 'devices') { if ($script:conn) { return @('List of devices attached', "localhost:5555`t$(if ($Case -eq 'offline') { 'offline' } else { 'device' })") }; return @('List of devices attached') }
    if ($k -like 'connect *') { $script:tries++; if ($Case -eq 'recusa' -or ($Case -eq 'reparo' -and $script:tries -lt 3)) { return @("failed to connect to 'localhost:5555': Connection refused") }; $script:conn = $true; return @('connected to localhost:5555') }
    if ($k -eq 'shell getprop sys.boot_completed') { return @('1') }
    if ($k -eq 'shell screencap -p | wc -c') { return @('50000') }
    if ($k -eq 'exec-out cat /sdcard/ui.xml') { return @('<?xml version="1.0"?><hierarchy></hierarchy>') }
    if ($k -eq 'shell cat /proc/uptime') { if ($Case -eq 'uptime') { return @('21600.5 100') }; return @('100.5 100') }
    return @()
}
if ($Case -eq 'reparo') { $w = Wait-AndroidSerial 180; "WAIT=[$w] TRIES=$($script:tries)" } else { $h = Test-AndroidHealth; "HEALTH=[$h]" }
'LOG=' + ($script:log -join ' | ')
'@, $utf8)
$hn = { param($case) $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $hs4 -Adapter (Join-Path $checks 'targets/android.ps1') -Case $case 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
$r = & $hn 'perdida'
Check 'v3.54.1: conexão do adb perdida com o emulador no ar → religada no pré-voo, alvo pronto' $r 0 @('religada com adb connect', 'HEALTH=\[\]', 'LOG=devices \| connect localhost:5555 \| devices')
$r = & $hn 'recusa'
Check 'v3.54.1: porta recusada → emulador ou container fora (não "nenhum aparelho")' $r 0 @("HEALTH=\[o emulador \(ou o container dele\) está fora: a porta localhost:5555 recusou o adb connect \(failed to connect")
$r = & $hn 'offline'
Check 'v3.54.1: conexão aceita com o aparelho offline → iniciando ou travado' $r 0 @("HEALTH=\[a conexão do adb com localhost:5555 foi aceita, mas o aparelho está 'offline'")
$r = & $hn 'uptime'
Check 'v3.54.1: religado e ligado acima do limite → a causa real (tempo ligado), não "fora"' $r 0 @('religada', 'HEALTH=\[o emulador está ligado há 6 h \(limite 3 h\)')
$r = & $hn 'local'
Check 'v3.54.1: serial local (emulator-5554) sem aparelho → sem adb connect, mensagem de antes' $r 0 @('HEALTH=\[nenhum emulador ou aparelho conectado', '^(?![\s\S]*connect localhost)')
$r = & $hn 'reparo'
Check 'v3.54.1: reparo de serial de rede religa em laço até o aparelho voltar (não wait-for-device)' $r 0 @('WAIT=\[\] TRIES=3', '^(?![\s\S]*wait-for-device)')

# v3.65.3 (garden SC-204): font-scale com o valor mudado espera a WebView trocar de página (o app recriado) antes do ready;
# valor igual, ou sem DevTools ligado, não espera. O valor vai ao aparelho com ponto decimal, em qualquer cultura.
$hs5 = Join-Path $tmp 'android-fonte.ps1'
[System.IO.File]::WriteAllText($hs5, @'
param([string]$Adapter, [string]$Case)
$ErrorActionPreference = 'Stop'
. $Adapter
[Threading.Thread]::CurrentThread.CurrentCulture = [Globalization.CultureInfo]'pt-BR'
$script:Serial = 'emulator-5554'; $script:CdpPort = if ($Case -eq 'semcdp') { $null } else { 9555 }
function Start-Sleep { }
$script:log = New-Object Collections.Generic.List[string]; $script:polls = 0
function AdbT([int]$Sec, [string[]]$A) { $k = @($A) -join ' '; $script:log.Add($k); if ($k -eq 'shell settings get system font_scale') { if ($Case -eq 'igual') { return @('0.85') }; return @('1.0') }; return @() }
function Invoke-RestMethod { $script:polls++; $id = if ($Case -eq 'muda' -and $script:polls -ge 3) { 'NOVA' } else { 'VELHA' }; return @([pscustomobject]@{ type = 'page'; id = $id }) }
$t = [datetime]::UtcNow; Set-AndroidFontScale 0.85; $ms = ([datetime]::UtcNow - $t).TotalMilliseconds
"POLLS=$($script:polls) RAPIDO=$($ms -lt 1500)"
'LOG=' + ($script:log -join ' | ')
'@, $utf8)
$hf = { param($case) $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $hs5 -Adapter (Join-Path $checks 'targets/android.ps1') -Case $case 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
$r = & $hf 'muda'
Check 'v3.65.3: font-scale com valor novo espera a página do /json mudar e volta assim que muda (valor com ponto decimal)' $r 0 @('POLLS=3 RAPIDO=True', 'settings put system font_scale 0\.85')
$r = & $hf 'naorecria'
Check 'v3.65.3: font-scale com valor novo num app que não recria a página espera o prazo e segue' $r 0 @('POLLS=([5-9]|\d{2,})\b', 'settings put system font_scale 0\.85')
$r = & $hf 'igual'
Check 'v3.65.3: font-scale com o valor atual não consulta o /json' $r 0 @('POLLS=0 RAPIDO=True', 'settings put system font_scale 0\.85')
$r = & $hf 'semcdp'
Check 'v3.65.3: font-scale sem DevTools ligado (uiautomator) segue como antes' $r 0 @('POLLS=0 RAPIDO=True')

# v3.54.2 (carta do sprint 5 do garden, item 4): Task sem marcador (recém-entrada no Sprint Backlog) aparece em ⬜ A fazer;
# a 🔴 traz o motivo curto ao lado.
$p = Join-Path $tmp 'v3542-quadro'; New-Project $p
Put $p '.team-project/sprints/1/kanban.md' ("# Kanban — Sprint 1`n`n## Kanban`n`n| x |`n|---|`n`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/burndown.md'), $utf8).Replace('# Burndown — Sprint 1', ''))
Remove-Item -LiteralPath (Join-Path $p '.team-project/sprints/1/burndown.md') -Force
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "$($e.todo) T-041a" 'T-041a'
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'blocked', '-Reason', 'prova no alvo pendente — emulador fora', '-Root', $p)
# v3.59.0: o quadro em lista por etapa, com o nome de negócio e o código no fim; a parada traz o motivo em frase simples.
Check 'v3.54.2: quadro — Task sem marcador em Na fila; 🔴 com o motivo ao lado (v3.59.0: em frase simples)' @{ Code = $r.Code; Out = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/kanban.md'), $utf8) } 0 @("\*\*$($e.todo) Na fila \(1\)\*\*\r?\n- Exportar o resultado da análise — parte 2 de 2 \(T-041a\)", '\*\*\S+ Paradas \(1\)\*\*\r?\n- Exportar o resultado da análise — parte 1 de 2 \(T-041\) — falta testar no app rodando: o ambiente de teste caiu')
# v3.59.0: o "## Resumo" em palavras simples no topo e o registro técnico no fim, sob "## Detalhe técnico" — só move seções
# inteiras (o Registro e a Série ficam iguais) e regravar de novo não muda a ordem nem duplica.
$kbp = Join-Path $p '.team-project/sprints/1/kanban.md'
# v3.60.0: a Série e o Registro já foram ao consumption.md (o mark.ps1 acima regravou o kanban) — o "não muda" se confere lá.
$csp = Join-Path $p '.team-project/sprints/1/consumption.md'
$kb1 = [System.IO.File]::ReadAllText($csp, $utf8)
$null = Invoke-Check 'kanban.ps1' @('-Root', $p)
$kb2 = [System.IO.File]::ReadAllText($kbp, $utf8); $cs2 = [System.IO.File]::ReadAllText($csp, $utf8)
$heads = (@([regex]::Matches($kb2, '(?m)^## ([^\r\n]+)') | ForEach-Object { $_.Groups[1].Value.Trim() }) -join ' > ')
$reg1 = [regex]::Match($kb1, '(?ms)^## Registro de transi.*?(?=^## |\z)').Value.TrimEnd(); $reg2 = [regex]::Match($cs2, '(?ms)^## Registro de transi.*?(?=^## |\z)').Value.TrimEnd()
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
$news1 = $r.Out
$null = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'qa', '-Root', $p)
$null = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'blocked', '-Reason', 'estado de partida — tela Login', '-Root', $p)
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
$news2 = $r.Out
$r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
Check 'v3.59.0: next — PARA O STAKEHOLDER: em toda ação; o que parou desde o next anterior abre a fala, uma vez, em frase simples' @{ Code = 0; Out = "N1=[$news1]`nN2=[$news2]`nN3=[$($r.Out)]" } 0 @('N1=\[[\s\S]*PARA O STAKEHOLDER: (?!Pronto|Parou)', 'N2=\[[\s\S]*PARA O STAKEHOLDER: Parou: Exportar o resultado da análise — parte 1 de 2 \(T-041\) — o teste no app não encontra a tela por onde começa; precisa de uma decisão\. ', 'N3=\[(?![^\]]*Parou:)[\s\S]*PARA O STAKEHOLDER: ')
Check 'v3.59.0: kanban.md — Resumo no topo, quadro, depois o Detalhe técnico; v3.60.0: o Burndown depois do quadro, a Série e o Registro no consumption.md; regravar não duplica nem muda o Registro' @{ Code = 0; Out = "HEADS=$heads`nREG=$($reg1 -eq $reg2 -and $reg1.Length -gt 0)`n$kb2" } 0 @('(?m)^HEADS=Resumo > Kanban > Burndown > Detalhe técnico > Rodadas\r?$', 'REG=True', '- \*\*Andamento:\*\* 0 de 2 partes prontas \(cerca de 0% do trabalho estimado\)', '- \*\*Parado:\*\* Exportar o resultado da análise — parte 1 de 2 \(T-041\) — falta testar no app rodando', '- \*\*A seguir:\*\* Exportar o resultado da análise — parte 2 de 2 \(T-041a\)')

# v3.54.2 (item 3): espera de um accept que só falha — o next mostra o avanço (progress.json do mesmo processo) e, sem nenhum
# cenário passando em 15 min, SEM AVANÇO (a captura de falha contava como sinal de vida: T-063, 50 min esperando).
$p = Join-Path $tmp 'v3542-avanco'; New-Project $p
Put $p '.team-project/sprints/1/plan/T-041a-x.md' "# Plano`n"
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') '[`plan/T-041a-x.md`](plan/)' '[`plan/T-041a-x.md`](plan/T-041a-x.md)'
$slp = Start-Process powershell -ArgumentList '-NoProfile', '-Command', 'Start-Sleep 600' -PassThru -WindowStyle Hidden
try {
    Put $p '.team-project/.target-lock' ('{"target":"android","owner":"accept T-041","pid":' + $slp.Id + ',"desde":"' + (Get-Date).AddMinutes(-25).ToString('yyyy-MM-dd HH:mm:ss') + '"}')
    Put $p '.team-project/accept/1/T-041/progress.json' ('{ "task": "T-041", "pid": ' + $slp.Id + ', "total": 7, "passed": 0, "failed": 3, "streak": 3, "last": { "id": "SC-117", "status": "FALHOU", "detail": "tag não encontrada: tab-button-estufa [tela: br.x/.IntroActivity · ids: intro.pular · textos: Bem-vindo(a) à Horta]", "shot": ".team-project/accept/1/T-041/shots/SC-117-falha.png" } }')
    $r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
    Check 'v3.54.2: espera de accept mostra cenários passados/falhados e SEM AVANÇO com a tela da última falha' $r 3 @('cenários: 0 passaram, 3 falharam de 7 \(3 seguidos\); último: SC-117 — tag não encontrada', 'SEM AVANÇO: 3 cenário\(s\) falharam e nenhum passou em 2\d min', 'textos: Bem-vindo\(a\) à Horta')
    Put $p '.team-project/accept/1/T-041/progress.json' ('{ "task": "T-041", "pid": ' + $slp.Id + ', "total": 7, "passed": 2, "failed": 1, "streak": 1, "last": { "id": "SC-118", "status": "FALHOU", "detail": "x", "shot": "" } }')
    $r = Invoke-Check 'run.ps1' @('next', '-Root', $p)
    Check 'v3.54.2: accept com cenário passando não é SEM AVANÇO' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'SEM AVANÇO') { "`nSEMAVANCO" } else { '' }) } 3 @('cenários: 2 passaram, 1 falharam de 7', '^(?![\s\S]*SEMAVANCO)')
} finally { Stop-Process -Id $slp.Id -Force -ErrorAction SilentlyContinue }

# v3.54.2 (item 3): o estado de partida é uma massa declarada — o -ParseOnly do QA reprova baseline fora de seeds.
$p = Join-Path $tmp 'v3542-baseline'; New-Project $p
Put $p '.team-project/quality-assurance/scenarios/H-014.scn' "scenario SC-014 x`nlaunch`nassert-exists a.b`n"
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x", "baseline": "sem-intro", "seeds": { "outra": "exit 0" } } } }'
$r = Invoke-Check 'accept.ps1' @('-ParseOnly', '-Root', $p)
Check 'v3.54.2: baseline que não é massa de seeds reprova o -ParseOnly' $r 2 @("targets\.android\.baseline 'sem-intro' não é uma massa de targets\.android\.seeds")
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x", "baseline": "sem-intro", "seeds": { "sem-intro": "exit 0" } } } }'
$r = Invoke-Check 'accept.ps1' @('-ParseOnly', '-Root', $p)
Check 'v3.54.2: baseline declarada passa no -ParseOnly' $r 0 @('1 cenário\(s\) válidos')

# v3.56.0 H1 (sprint 5 do garden #32): -Only valida só os cenários pedidos (e os erros do arquivo).
$p = Join-Path $tmp 'v3560-only'; New-Project $p
Put $p '.team-project/quality-assurance/scenarios/H-014.scn' "scenario SC-1 válido`nlaunch`nassert-exists a.b`n`nscenario SC-2 sem assert`nlaunch`n"
$r = Invoke-Check 'accept.ps1' @('-ParseOnly', '-Only', 'SC-1', '-Root', $p)
Check 'v3.56.0 H1: -Only SC-1 passa com SC-2 inválido no mesmo arquivo (aviso de uma linha)' $r 0 @('1 erro\(s\) em cenários fora do -Only', '1 cenário\(s\) válidos.*SC-1')
$r = Invoke-Check 'accept.ps1' @('-ParseOnly', '-Only', 'SC-2', '-Root', $p)
Check 'v3.56.0 H1: -Only SC-2 reprova pelo próprio erro' $r 2 @('cenário SC-2 sem nenhum assert')
Put $p '.team-project/quality-assurance/scenarios/H-015.scn' "tap antes`nscenario SC-3 x`nlaunch`nassert-exists a.b`n"
$r = Invoke-Check 'accept.ps1' @('-ParseOnly', '-Only', 'SC-1', '-Root', $p)
Check 'v3.56.0 H1: erro do arquivo (passo antes do primeiro scenario) continua reprovando com -Only' $r 2 @("passo antes do primeiro 'scenario'")

# v3.56.0 H2 (sprint 5 do garden #28, #33, #38…): o cartão e o despacho seguem os cenários do plano, não os do backlog.
$p = Join-Path $tmp 'v3560-cenarios-plano'; New-Project $p
Put $p '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') 'SC-014 (novo)' 'SC-014 (novo) · SC-016'
Put $p '.team-project/quality-assurance/scenarios/H-014.scn' "scenario SC-014 Exporta`nlaunch`nassert-exists a.b`n`nscenario SC-016 Outro`nlaunch`nassert-exists a.c`n"
Put $p '.team-project/quality-assurance/scenarios/H-099.scn' "scenario SC-900 Outra história`nlaunch`n"
$plT = Join-Path $p '.team-project/sprints/1/plan/T-041-export.md'
[System.IO.File]::WriteAllText($plT, ("# Plano`n**Cenários:** SC-014`n" + [System.IO.File]::ReadAllText($plT, $utf8).Substring(1)), $utf8)
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$card = Join-Path $p '.team-project/sprints/1/handoff/T-041.md'
$ct = if (Test-Path -LiteralPath $card) { [System.IO.File]::ReadAllText($card, $utf8) } else { 'sem cartão' }
Check 'v3.56.0 H2: backlog SC-014 e SC-016, plano SC-014 → cartão só com SC-014 e -Scenarios do .scn da História' @{ Code = $r.Code; Out = $ct + $(if ($ct -match 'SC-016') { "`nTEM-016" }) } 0 @('\*\*Cenários \(do plano\):\*\* SC-014 — `accept\.ps1 -Task T-041 -Scenarios \.team-project/quality-assurance/scenarios/H-014\.scn -Only SC-014`', '^(?![\s\S]*TEM-016)', '^(?![\s\S]*H-099)')
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
$rl = Join-Path $p '.team-project/sprints/1/run-log.md'
Check 'v3.56.0 H2: start manda o accept do plano, diz que o plano manda e registra a divergência no run-log (sem formulário)' @{ Code = $r.Code; Out = $r.Out + "`n" + $(if (Test-Path -LiteralPath $rl) { [System.IO.File]::ReadAllText($rl, $utf8) } else { '' }) } 0 @('accept\.ps1 -Task T-041 -Scenarios \S+H-014\.scn -Only SC-014 no alvo', 'o plano manda — ordem do cartão que contradiga o plano é 🔺 GAP de processo', '\| T-041 \| cenários: o plano manda \(SC-014\) \| backlog: SC-014, SC-016')
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
Check 'v3.56.0 H2: a divergência entra uma vez só no run-log' @{ Code = 0; Out = "N=" + ([regex]::Matches([System.IO.File]::ReadAllText($rl, $utf8), 'cenários: o plano manda')).Count } 0 @('N=1$')
[System.IO.File]::WriteAllText($plT, [System.IO.File]::ReadAllText($plT, $utf8).Replace('**Cenários:** SC-014', '**Cenários:** nenhum — o GAP tirou a prova de tela'), $utf8)
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$ct = [System.IO.File]::ReadAllText($card, $utf8)
Check 'v3.56.0 H2: plano com "nenhum — motivo" → cartão sem linha de accept' @{ Code = $r.Code; Out = $ct + $(if ($ct -match 'accept\.ps1 -Task') { "`nTEM-ACCEPT" }) } 0 @('\*\*Cenários \(do plano\):\*\* nenhum no alvo', '^(?![\s\S]*TEM-ACCEPT)')
# v3.57.0 (item 9): o envelope de medidas do plano vai ao cartão, com a regra de um GAP por Task.
[System.IO.File]::WriteAllText($plT, [System.IO.File]::ReadAllText($plT, $utf8) + "`n**Envelope de medidas**:`n- E1 · espaçamento entre os botões · sonda: ``operator/1/T-041-plano/medida.ps1`` · (a) se medir 0 px → gap de 8 px · (b) se medir 8 px → nada · fora disso → 🔺 GAP ``aparência```n", $utf8)
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$ct = [System.IO.File]::ReadAllText($card, $utf8)
Check 'v3.57.0 item 9: o cartão traz o envelope do plano (a sonda e os casos) e a regra de medir tudo antes de abrir um único GAP' @{ Code = $r.Code; Out = $ct } 0 @('\*\*Envelope de medidas\*\* \(do plano — meça com a sonda e aplique o caso medido', 'um GAP por Task', '- E1 · espaçamento entre os botões · sonda: `operator/1/T-041-plano/medida\.ps1`')
# v3.57.0 (plugin-report do sprint 5 do garden, item 5): o plano que DECLARA que o aceite não roda vale mais que a lista de cenários.
[System.IO.File]::WriteAllText($plT, [System.IO.File]::ReadAllText($plT, $utf8).Replace('**Cenários:** nenhum — o GAP tirou a prova de tela', "**Cenários:** SC-014`n**Aceite:** não roda — emulador indisponível neste sprint (D-3)"), $utf8)
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$ct = [System.IO.File]::ReadAllText($card, $utf8)
Check 'v3.57.0 item 5: plano com "**Aceite:** não roda — motivo" (e Cenários ainda com SC-014) → cartão sem comando de accept, com o motivo do plano e SC-014 por teste' @{ Code = $r.Code; Out = $ct + $(if ($ct -match 'accept\.ps1 -Task') { "`nTEM-ACCEPT" }) } 0 @('\*\*Cenários \(do plano\):\*\* o accept não roda nesta Task — o plano declara: Aceite: não roda — emulador indisponível neste sprint \(D-3\); os cenários se provam pelos testes do plano \(não rode o accept\.ps1\)', 'por teste do plano, sem accept: SC-014', '^(?![\s\S]*TEM-ACCEPT)')
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $p)
Check 'v3.57.0 item 5: start com o aceite declarado como não rodando não manda o accept' @{ Code = $r.Code; Out = $r.Out + $(if ($r.Out -match 'accept\.ps1 -Task T-041') { "`nTEM-ACCEPT" }) } 0 @('o plano manda — ordem do cartão que contradiga o plano', '^(?![\s\S]*TEM-ACCEPT)')

# v3.56.0 A (regra 29 ampliada): toda decisão de GAP declara Origem e Lição; K citada inexistente ou copiada reprova (B).
$p = Join-Path $tmp 'v3560-licao'; New-Project $p
Put $p 'src/a.ts' "bar`nqux`n"
$pl = '.team-project/sprints/1/plan/T-080-x.md'
$hA = "# Plano`n**Cenários:** nenhum — interno`n**Risco:** regra de negócio`n**Layout novo:** não`n"
$bA = "**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 3. Ambiente`n| Pré-requisito | Comando | Saída real | Log | Atende? |`n|---|---|---|---|---|`n| Node | node -v | v20 | — | sim |`n`n## 6. Testes`n`n**Mutações:**`n- M1 · teste ``tests/a.spec.ts`` · ``src/a.ts`` · ``bar`` → ``baz```n`n### Premissas`n- P1 · src tem a.ts · medido: ``ls src`` → a.ts`n"
$fA = "`n## 9. Onde parar`n- Pré-requisito ausente`n"
$kHead = "# Conhecimento do projeto`n> DOCUMENTO VIVO · Dono: Arquiteto`n`n**Classificação desde:** S1`n`n"
Put $p '.team-project/architect/knowledge.md' ($kHead + "## K-1 — Limiar relativo à caixa`n**Vale para:** ``src/**/*.ts`` · **Origem:** 🔺 GAP 2 da T-063 (S5) · **Desde:** S5`nO limiar de toque se mede contra a caixa do componente, nunca contra 160 px fixos do viewport.`n`n## K-2 — Só para documentos`n**Vale para:** ``docs/**`` · **Origem:** 🔺 GAP 1 da T-050 (S4) · **Desde:** S4`nO SDD cita a seção, não copia.`n")
Put $p '.team-project/architect/decisions/S1.md' "# Decisões do sprint 1`n`n## D-1 — Emulador fora do ar`n**Vale para:** todas · **Do GAP:** T-041 · 2026-11-02`nCom o alvo fora do ar depois do reparo, a Task vai a bloqueada com prova no alvo pendente.`n"
Put $p $pl ($hA + "**Decisões:** D-1`n`n" + $bA + $fA)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.56.0 A: D-<k> que vale para a Task sem Origem/Lição reprova (sprint com classificação obrigatória)' $r 1 @('\| decisões \| falhou.*D-1 sem \*\*Origem:\*\* e \*\*Lição:\*\*')
Put $p '.team-project/architect/decisions/S1.md' "# Decisões do sprint 1`n`n## D-1 — Emulador fora do ar`n**Vale para:** todas · **Do GAP:** T-041 · 2026-11-02`n**Origem:** palpite`n**Lição:** projeto`nCom o alvo fora do ar depois do reparo, a Task vai a bloqueada com prova no alvo pendente.`n"
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.56.0 A: Origem fora da lista reprova' $r 1 @("\| decisões \| falhou.*D-1: \*\*Origem:\*\* 'palpite' fora da lista")
Put $p '.team-project/architect/decisions/S1.md' "# Decisões do sprint 1`n`n## D-1 — Emulador fora do ar`n**Vale para:** todas · **Do GAP:** T-041 · 2026-11-02`n**Origem:** ambiente`n**Lição:** plugin`nCom o alvo fora do ar depois do reparo, a Task vai a bloqueada com prova no alvo pendente.`n"
Put $p $pl ($hA + "**Decisões:** D-1`n`n**Decisão do GAP T-080 (06/11/2026):** a lista vazia mostra o aviso padrão.`n`n" + $bA + $fA)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.56.0 A: decisão de GAP no plano sem as duas linhas reprova' $r 1 @("\| decisões \| falhou.*'\*\*Decisão do GAP T-080 \(06/11/2026\):\*\*.*sem \*\*Origem:\*\* e \*\*Lição:\*\*")
Put $p $pl ($hA + "**Decisões:** D-1, K-1`n`n**Decisão do GAP T-080 (06/11/2026):** a lista vazia mostra o aviso padrão.`n**Origem:** requisito`n**Lição:** stack:ionic-capacitor`n`n" + $bA + $fA)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.56.0 A/B: decisões classificadas e **Decisões:** D-1, K-1 passam' $r 0 @('\| decisões \| ok.*cita D-1, K-1; 1 decisão\(ões\) no sprint, 2 K no projeto, nenhuma copiada')
Put $p $pl ($hA + "**Decisões:** D-1, K-9`n`n" + $bA + "O limiar de toque se mede contra a caixa do componente, nunca contra 160 px fixos do viewport.`n" + $fA)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.56.0 B: K citada que não existe e texto de K copiado reprovam' $r 1 @('\| decisões \| falhou.*cita K-9 que não existe\(m\) em architect/knowledge\.md.*copia o texto da K-1')
Remove-Item -LiteralPath (Join-Path $p '.team-project/architect/knowledge.md') -Force
Put $p '.team-project/architect/decisions/S1.md' "# Decisões do sprint 1`n`n## D-1 — Emulador fora do ar`n**Vale para:** todas · **Origem:** 🔺 GAP da T-041 · 2026-11-02`nCom o alvo fora do ar depois do reparo, a Task vai a bloqueada com prova no alvo pendente.`n"
Put $p $pl ($hA + "**Decisões do sprint:** D-1`n`n" + $bA + $fA)
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'v3.56.0 A: projeto sem knowledge.md (antes do update) — D sem classificação só avisa; o rótulo antigo vale' $r 0 @('\| decisões \| ok.*cita D-1.*D-1 sem classificação \(anterior à 3\.56\.0: só aviso\)')

# v3.56.0 B e C: o cartão traz a K e a armadilha da stack que casam por glob com os arquivos da Task; não traz as outras.
$p = Join-Path $tmp 'v3560-cartao'; New-Project $p
Put $p '.team-project/architect/knowledge.md' ($kHead + "## K-1 — Limiar relativo à caixa`n**Vale para:** ``src/app/**/*.render.spec.ts`` · **Origem:** 🔺 GAP 2 da T-063 (S5) · **Desde:** S5`nO limiar de toque se mede contra a caixa do componente.`n`n## K-2 — Só para documentos`n**Vale para:** ``docs/**`` · **Origem:** 🔺 GAP 1 da T-050 (S4) · **Desde:** S4`nO SDD cita a seção, não copia.`n`n## K-3 — Remédio do plugin`n**Vale para:** T-041 · **Origem:** 🔺 GAP 3 da T-060 (S5) · **Desde:** S5 · **Até:** a mutação rodar node:test`nRode o node:test pelo operator.`n")
Put $p '.team-project/guards.json' '{ "stacks": ["testex"] }'
Put $p '.team-project/standards/stacks/testex/pitfalls.md' "# Armadilhas locais — testex`n`n## TESTEX-L1 — Margem do botão`n**Vale para:** ``src/app/**``, ``src/theme/**```n**Sintoma:** régua de 8 px vira 16`n**Fato:** o botão soma 4 px por lado ao clamp`n**Como testar:** medir a caixa do botão interno`n`n## TESTEX-L2 — Já no plugin`n**Vale para:** ``src/**```n**Fato:** promovida`n**Promovida:** TESTEX-P9`n`n## TESTEX-L3 — Outra pasta`n**Vale para:** ``android/**```n**Fato:** só do Gradle`n"
$plT = Join-Path $p '.team-project/sprints/1/plan/T-041-export.md'
[System.IO.File]::WriteAllText($plT, "# Plano — T-041`n**Cenários:** nenhum — interno`n**Decisões:** K-2`n`n**Arquivos tocados:** ``src/app/home/home.render.spec.ts```n``src/app/home/home.page.ts```n`n## 6. Testes`n", $utf8)
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$card = Join-Path $p '.team-project/sprints/1/handoff/T-041.md'
$ct = if (Test-Path -LiteralPath $card) { [System.IO.File]::ReadAllText($card, $utf8) } else { 'sem cartão' }
Check 'v3.56.0 B: cartão traz a K que casa por glob, a citada no plano e a do T-ID (com o Até); não traz a que não casa' @{ Code = $r.Code; Out = $ct } 0 @('\*\*Conhecimento do projeto\*\* \(`architect/knowledge\.md`', '- K-1 — Limiar relativo à caixa: O limiar de toque', '- K-2 — Só para documentos', '- K-3 — Remédio do plugin: Rode o node:test pelo operator\. \(até: a mutação rodar node:test\)')
[System.IO.File]::WriteAllText($plT, "# Plano — T-041`n**Cenários:** nenhum — interno`n`n**Arquivos tocados:** ``src/app/home/home.render.spec.ts```n`n## 6. Testes`n", $utf8)
$r = Invoke-Check 'run.ps1' @('handoff', '-Task', 'T-041', '-Root', $p)
$ct = [System.IO.File]::ReadAllText($card, $utf8)
Check 'v3.56.0 B/C: sem citar, a K de docs/** fica fora; a armadilha local que casa entra, a promovida e a de outra pasta não' @{ Code = $r.Code; Out = $ct + $(if ($ct -match 'K-2') { "`nTEM-K2" }) + $(if ($ct -match 'TESTEX-L2|TESTEX-L3') { "`nTEM-L2L3" }) } 0 @('\*\*Armadilhas da stack\*\*', '- TESTEX-L1 — Margem do botão: o botão soma 4 px por lado ao clamp · teste: medir a caixa do botão interno', '^(?![\s\S]*TEM-K2)', '^(?![\s\S]*TEM-L2L3)')

# v3.56.0 E: knowledge.ps1 — no fechamento, cada lição vai ao destino (cópia mecânica), com a tabela origem × destino.
$kHead = "# Conhecimento do projeto`n> DOCUMENTO VIVO · Dono: Arquiteto`n`n**Classificação desde:** S1`n`n"
$p = Join-Path $tmp 'v3560-knowledge'; New-Project $p
Put $p '.team-project/architect/knowledge.md' ($kHead + "## K-1 — Limiar relativo à caixa`n**Vale para:** ``src/legacy/**`` · **Origem:** 🔺 GAP 2 da T-063 (S5) · **Desde:** S1`nO limiar de toque se mede contra a caixa do componente.`n")
Put $p '.team-project/sprints/1/plan/T-041-export.md' "# Plano — T-041`n**Cenários:** nenhum — interno`n`n**Arquivos tocados:** ``src/app/home.page.ts```n`n**Decisão do GAP T-041 (06/11/2026):** a lista vazia mostra o aviso padrão do app.`n**Origem:** requisito`n**Lição:** projeto`n`n## 6. Testes`n"
Put $p '.team-project/architect/decisions/S1.md' ("# Decisões do sprint 1`n`n## D-1 — Limiar de novo`n**Vale para:** ``src/app/**/*.render.spec.ts`` · **Do GAP:** T-041 · 2026-11-06`n**Origem:** conhecimento`n**Lição:** projeto`nO limiar de toque é relativo à caixa (repete K-1).`n`n" +
    "## D-2 — Margem do botão`n**Vale para:** ``src/app/**/*.scss`` · **Do GAP:** T-041`n**Origem:** previsão`n**Lição:** stack:testex`nO botão soma 4 px por lado ao clamp.`n`n" +
    "## D-3 — Mutação sem node:test`n**Vale para:** todas · **Do GAP:** T-041`n**Origem:** processo`n**Lição:** plugin`n**Até:** a mutação rodar node:test`nRode o node:test pelo operator e cole a saída.`n`n" +
    "## D-4 — Só esta vez`n**Vale para:** T-041 · **Do GAP:** T-041`n**Origem:** previsão`n**Lição:** nenhuma`nA lista tinha 3 itens, não 2.`n")
$r = Invoke-Check 'knowledge.ps1' @('-Sprint', '1', '-Root', $p)
Check 'v3.56.0 E: -Check só lê — conta promoções, plugin e a repetição com registro, sem gravar' @{ Code = $r.Code; Out = $r.Out + $(if (Test-Path -LiteralPath (Join-Path $p '.team-project/sprints/1/lessons.md')) { "`nGRAVOU" }) } 0 @('knowledge S1 -Check: 5 decisão\(ões\) · promoções 4 · plugin 1 · repetições com registro 1 · achados 0', '^(?![\s\S]*GRAVOU)')
$r = Invoke-Check 'knowledge.ps1' @('-Sprint', '1', '-Apply', '-Root', $p)
$kt = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/architect/knowledge.md'), $utf8)
$lt = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/standards/stacks/testex/pitfalls.md'), $utf8)
$ls = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/sprints/1/lessons.md'), $utf8)
Check 'v3.56.0 E: -Apply promove D → K (com o Até do remédio) e D → L da stack, cópia literal' @{ Code = $r.Code; Out = $kt + "`n=====`n" + $lt } 0 @('## K-2 — Limiar de novo\r?\n\*\*Vale para:\*\* `src/app/\*\*/\*\.render\.spec\.ts` · \*\*Origem:\*\* 🔺 GAP · D-1 do S1 \(T-041\) · \*\*Desde:\*\* S1\r?\nO limiar de toque é relativo à caixa \(repete K-1\)\.', '## K-3 — Mutação sem node:test\r?\n.*\*\*Até:\*\* a mutação rodar node:test', '## K-4 — a lista vazia mostra o aviso padrão do app\.', '## TESTEX-L1 — Margem do botão\r?\n\*\*Vale para:\*\* `src/app/\*\*/\*\.scss`\r?\n\*\*Fato:\*\* O botão soma 4 px por lado ao clamp\.', '^(?![\s\S]*Só esta vez)')
Check 'v3.56.0 E: lessons.md — tabela origem × destino, ocorrência de plugin (iii) e a repetição que não chegou à Task' @{ Code = 0; Out = $ls } 0 @('\| conhecimento \| 1 \| 0 \| 0 \| 0 \| 1 \|', '\| previsão \| 0 \| 1 \| 0 \| 1 \| 2 \|', '\| \*\*Total\*\* \| 2 \| 1 \| 1 \| 1 \| 5 \|', '## Ocorrências de plugin \(iii\)[\s\S]*D-3 do S1 \(T-041\) — Mutação sem node:test', 'D-1 do S1 \(T-041\) repete K-1 — o registro existia e NÃO chegou à Task', 'declarar "stacks" no guards\.json')
$r = Invoke-Check 'knowledge.ps1' @('-Sprint', '1', '-Apply', '-Root', $p)
$kt2 = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/architect/knowledge.md'), $utf8)
Check 'v3.56.0 E: -Apply de novo não duplica (idempotente)' @{ Code = $r.Code; Out = "K=" + ([regex]::Matches($kt2, '(?m)^## K-')).Count + " L=" + ([regex]::Matches([System.IO.File]::ReadAllText((Join-Path $p '.team-project/standards/stacks/testex/pitfalls.md'), $utf8), '(?m)^## TESTEX-L')).Count } 0 @('K=4 L=1')
Put $p '.team-project/architect/decisions/S1.md' "# Decisões do sprint 1`n`n## D-1 — Sem lição`n**Vale para:** todas`nA regra.`n"
Put $p '.team-project/architect/knowledge.md' ($kHead + "## K-1 — Grande`n**Vale para:** todas`n" + ('x' * 16000) + "`n")
$r = Invoke-Check 'knowledge.ps1' @('-Sprint', '1', '-Apply', '-Root', $p)
Check 'v3.56.0 E: decisão sem Lição em sprint de classificação obrigatória é achado bloqueante (exit 1); acima de 15 KB abre a consolidação' @{ Code = $r.Code; Out = $r.Out + $(if (Test-Path -LiteralPath (Join-Path $p '.team-project/architect/consolidation.md')) { "`nCONSOLIDA" }) } 1 @('ACHADO: D-1 do S1 sem \*\*Origem:\*\* e \*\*Lição:\*\*', 'TETO: consolidação no próximo prepare', 'CONSOLIDA')

# v3.56.0 F: -Migrate sobre um decisions/S<n>.md como o do garden S5 (três D anteriores à 3.56.0, sem classificação).
$p = Join-Path $tmp 'v3560-migrate'; New-Project $p
Put $p '.team-project/architect/decisions/S1.md' "# Decisões do sprint 1`n`n## D-1 — Limiar relativo à caixa`n**Vale para:** todas · **Origem:** 🔺 GAP da T-063 · 2026-11-03`nO limiar de toque se mede contra a caixa do componente.`n`n## D-2 — Injetar o caminho do artefato`n**Vale para:** todas · **Origem:** 🔺 GAP da T-056`nO teste recebe o caminho do APK por parâmetro em vez de apagar o arquivo.`n`n## D-3 — node:test fora do verify`n**Vale para:** todas · **Origem:** 🔺 GAP da T-072`nRode o node:test pelo operator e cole a saída.`n"
$r = Invoke-Check 'knowledge.ps1' @('-Migrate', '-Root', $p)
Check 'v3.56.0 F: -Migrate lista o que o update cria e as D sem classificação (promoção só no close)' @{ Code = $r.Code; Out = $r.Out + $(if (Test-Path -LiteralPath (Join-Path $p '.team-project/architect/knowledge.md')) { "`nCRIOU" }) } 0 @('criar architect/knowledge\.md vazio, com \*\*Classificação desde:\*\* S2', 'D-1 do S1 — Limiar relativo à caixa: sem classificação → no close do S1 entra como Lição: projeto', 'D-3 do S1', '^(?![\s\S]*CRIOU)')
$r = Invoke-Check 'knowledge.ps1' @('-Migrate', '-Apply', '-Classify', 'D-1=conhecimento:projeto;D-2=previsão:projeto;D-3=processo:plugin@a mutação rodar node:test', '-Root', $p)
$dt = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/architect/decisions/S1.md'), $utf8)
Check 'v3.56.0 F: -Migrate -Apply cria o knowledge.md e grava a classificação do formulário nas D' @{ Code = $r.Code; Out = $dt + "`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/architect/knowledge.md'), $utf8) } 0 @('## D-3 — node:test fora do verify\r?\n\*\*Vale para:\*\*[^\n]*\r?\n\*\*Origem:\*\* processo\r?\n\*\*Lição:\*\* plugin\r?\n\*\*Até:\*\* a mutação rodar node:test', '\*\*Classificação desde:\*\* S2')
$r = Invoke-Check 'knowledge.ps1' @('-Sprint', '1', '-Apply', '-Root', $p)
$kt = [System.IO.File]::ReadAllText((Join-Path $p '.team-project/architect/knowledge.md'), $utf8)
Check 'v3.56.0 F: close do sprint migrado — D-1 → K-1, D-2 → K-2 sem Até, D-3 → K-3 com Até e ocorrência de plugin' @{ Code = $r.Code; Out = $r.Out + "`n" + $kt } 0 @('## K-1 — Limiar relativo à caixa', '## K-2 — Injetar o caminho do artefato\r?\n\*\*Vale para:\*\* todas · \*\*Origem:\*\* 🔺 GAP · D-2 do S1 \(T-056\) · \*\*Desde:\*\* S1\r?\n', '## K-3 — node:test fora do verify\r?\n[^\n]*\*\*Até:\*\* a mutação rodar node:test', 'plugin \(iii\): D-3 do S1')
$r = Invoke-Check 'knowledge.ps1' @('-Migrate', '-Apply', '-Retire', 'K-3', '-Root', $p)
Check 'v3.56.0 F: o update retira a K cujo Até chegou' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText((Join-Path $p '.team-project/architect/knowledge.md'), $utf8) } 0 @('K-3 — node:test fora do verify: retirada', '^(?![\s\S]*## K-3)', '## K-2')

# v3.57.0 — protocolo de espera: guarda de processo solto e casos do Invoke-Bounded (lib.ps1).
# Guarda: todo Start-Process / Process]::Start fora do lib.ps1 (e dos testes) leva "# protocolo: adb" ou "# protocolo: desprendido"
# na linha ou na anterior — o comando de terceiros passa pelo Invoke-Bounded; só o adb (prazo próprio) e o processo que deve
# sobreviver (emulador, servidor web) ficam de fora, com a marca. StandardOutput.ReadToEnd é proibido: lê pipe sem prazo.
$loose = @()
foreach ($sf in @(Get-ChildItem -LiteralPath (Resolve-Path (Join-Path $checks '..')).Path -Recurse -Filter '*.ps1' | Where-Object { $_.FullName -notmatch '[\\/]tests[\\/]' -and $_.Name -ne 'lib.ps1' })) {
    $ln = [System.IO.File]::ReadAllLines($sf.FullName, $utf8)
    for ($i = 0; $i -lt $ln.Count; $i++) {
        if ($ln[$i].TrimStart().StartsWith('#')) { continue }
        if ($ln[$i] -match 'StandardOutput\.ReadToEnd\(\)|StandardError\.ReadToEnd\(\)') { $loose += "$($sf.Name):$($i + 1) leitura de pipe sem prazo (ReadToEnd)"; continue }
        if ($ln[$i] -match 'Start-Process|Process\]::Start') {
            $mark = ($ln[$i] -match '#\s*protocolo:\s*(adb|node|desprendido)') -or ($i -gt 0 -and $ln[$i - 1] -match '#\s*protocolo:\s*(adb|node|desprendido)')
            if (-not $mark) { $loose += "$($sf.Name):$($i + 1) processo disparado fora do Invoke-Bounded e sem marca de protocolo" }
        }
    }
}
Check 'v3.57.0 protocolo: nenhum processo solto — Start-Process/Process::Start fora do lib.ps1 só com "# protocolo: adb|node|desprendido" (node: v3.62.0, executor cdp com prazo próprio)' @{ Code = [int]($loose.Count -gt 0); Out = $(if ($loose.Count) { $loose -join "`n" } else { 'sem processo solto' }) } 0 @('sem processo solto')

$bt = Join-Path $tmp 'bounded-test.ps1'
[System.IO.File]::WriteAllText($bt, @'
param([string]$Lib, [string]$Root)
. $Lib
$kid = 'Start-Process powershell -ArgumentList ''-NoProfile'',''-Command'',''Start-Sleep 12'' -NoNewWindow; "pronto"'
$r = Invoke-Bounded $Root $kid 60 -KeepDescendants
"A filho-herdado-sobrevive: rapido=$($r.seconds -lt 10) exit=$($r.exit) timedOut=$($r.timedOut) kept=$(@($r.kept).Count -ge 1) out=$($r.out)"
$r = Invoke-Bounded $Root $kid 60
"B sem-keep-filho-morre: rapido=$($r.seconds -lt 10) kept=$(@($r.kept).Count)"
$r = Invoke-Bounded $Root 'Start-Sleep 30' 2
"C prazo: exit=$($r.exit) timedOut=$($r.timedOut) rapido=$($r.seconds -lt 15)"
$r = Invoke-Bounded $Root '"v=$env:XPTO"; $l = [Console]::In.ReadLine(); "in=$l"; exit 7' 20 -Env @{ XPTO = 'abc' } -InputText "ola`n"
"D exit-env-stdin: exit=$($r.exit) out=$(($r.out -replace '\r?\n', '|'))"
$r = Invoke-Bounded $Root 'Write-Error "falhou aqui"; exit 5' 20
"E erro-visivel: exit=$($r.exit) msg=$($r.out -match 'falhou aqui')"
'@, $utf8)
$bo = (& powershell -NoProfile -ExecutionPolicy Bypass -File $bt -Lib (Join-Path $checks 'lib.ps1') -Root $tmp 2>&1 | ForEach-Object { "$_" }) -join "`n"
Check 'v3.57.0 protocolo: Invoke-Bounded — filho com saída herdada não prende (sobrevive só com -KeepDescendants), prazo vira 124, exit/env/stdin passam, erro aparece' @{ Code = 0; Out = $bo } 0 @('A filho-herdado-sobrevive: rapido=True exit=0 timedOut=False kept=True out=pronto', 'B sem-keep-filho-morre: rapido=True kept=0', 'C prazo: exit=124 timedOut=True rapido=True', 'D exit-env-stdin: exit=7 out=v=abc\|in=ola', 'E erro-visivel: exit=5 msg=True')

# v3.62.1 — log preso por descendente órfão (o daemon de uso único do Gradle, que sobe quando org.gradle.jvmargs difere da
# JVM cliente): o Invoke-ProjectCommand lia o .err e acrescentava ao log 200 ms depois do comando sair e caía com "o processo
# não pode acessar o arquivo" (ensaio NT do benchmark, 17/11: 3 de 3 com o build verde). Agora espera o arquivo ficar livre.
# A: órfão de ~4 s (o cmd intermediário sai antes, como o gradlew) · B: Add-LogText com o arquivo preso por quem escreve
# compartilhando (grava pelo caminho de reserva) · C: preso sem compartilhar (devolve $false, não lança) · D: Get-Decisive lê
# com o arquivo aberto para escrita.
$lt = Join-Path $tmp 'lograce-test.ps1'
[System.IO.File]::WriteAllText($lt, @'
param([string]$Lib, [string]$Root)
$ErrorActionPreference = 'Stop'
. $Lib
$log = Join-Path $Root 'lograce-a.log'
try { $r = Invoke-ProjectCommand -Root $Root -Key 'k' -Cmd 'cmd /c "start /b powershell -NoProfile -Command Start-Sleep -Seconds 4"; Write-Output pronto' -Log $log -TimeoutMinutes 1 -EnvExtra $null
      "A orfao: exit=$($r.exit) pronto=$((Get-Content $log -Raw) -match 'pronto') fim=$((Get-Content $log -Raw) -match 'EXIT=0') err=$(Test-Path ""$log.err"")" } catch { "A orfao: ERRO $($_.Exception.Message)" }
$f = Join-Path $Root 'lograce-b.log'; [IO.File]::WriteAllText($f, "base`n")
$h = New-Object System.IO.FileStream($f, [IO.FileMode]::Open, [IO.FileAccess]::Write, [IO.FileShare]::ReadWrite)
try { $ok = Add-LogText $f "nova`n" 1; "B compartilhado: ok=$ok" } catch { "B compartilhado: ERRO $($_.Exception.Message)" } finally { $h.Dispose() }
"B texto: $((Get-Content $f -Raw) -match 'nova')"
$h = New-Object System.IO.FileStream($f, [IO.FileMode]::Open, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
$sw = New-Object System.IO.StringWriter; $oldErr = [Console]::Error; [Console]::SetError($sw)   # nada pode sair no stderr (derrubaria quem chama com 2>&1)
try { $ok = Add-LogText $f "x`n" 1; "C exclusivo: ok=$ok stderr=$($sw.ToString().Length)" } catch { "C exclusivo: ERRO $($_.Exception.Message)" } finally { [Console]::SetError($oldErr); $h.Dispose() }
$h = New-Object System.IO.FileStream($f, [IO.FileMode]::Open, [IO.FileAccess]::Write, [IO.FileShare]::ReadWrite)
try { $d = Get-Decisive $f; "D decisive: linhas=$($d.Lines)" } catch { "D decisive: ERRO $($_.Exception.Message)" } finally { $h.Dispose() }
'@, $utf8)
$lo = (& powershell -NoProfile -ExecutionPolicy Bypass -File $lt -Lib (Join-Path $checks 'lib.ps1') -Root $tmp 2>&1 | ForEach-Object { "$_" }) -join "`n"
Check 'v3.62.1 log preso por órfão: o verify espera o log ficar livre (órfão do Gradle), grava compartilhando como reserva, não lança com o arquivo exclusivo e lê o decisivo com o arquivo aberto' @{ Code = 0; Out = $lo } 0 @('A orfao: exit=0 pronto=True fim=True err=False', 'B compartilhado: ok=True', 'B texto: True', 'C exclusivo: ok=False stderr=0', 'D decisive: linhas=2')

# v3.57.0 (item 6) — Find-WaitCycle: ciclo de 2 e de 3 Tasks, ciclo com cauda, e fila sem ciclo (espera por Task fora do quadro não é ciclo).
$wc = Join-Path $tmp 'waitcycle-test.ps1'
[System.IO.File]::WriteAllText($wc, @'
param([string]$Lib)
. $Lib
function T([hashtable]$e) { return (@(Find-WaitCycle $e) -join '>') }
"1 sem=" + (T @{ 'T-1' = @('T-2'); 'T-2' = @() })
"2 dois=" + (T @{ 'T-1' = @('T-2'); 'T-2' = @('T-1') })
"3 tres=" + (T @{ 'T-1' = @('T-2'); 'T-2' = @('T-3'); 'T-3' = @('T-1') })
"4 cauda=" + (T @{ 'T-0' = @('T-1'); 'T-1' = @('T-2'); 'T-2' = @('T-1') })
"5 fantasma=" + (T @{ 'T-1' = @('T-99') })
'@, $utf8)
$wco = (& powershell -NoProfile -ExecutionPolicy Bypass -File $wc -Lib (Join-Path $checks 'lib.ps1') 2>&1 | ForEach-Object { "$_" }) -join "`n"
Check 'v3.57.0 item 6: Find-WaitCycle acha ciclo de 2, de 3 e com cauda; fila sem ciclo e espera por Task fora do quadro não são ciclo' @{ Code = 0; Out = $wco } 0 @('1 sem=\r?\n', '2 dois=T-1>T-2>T-1', '3 tres=T-1>T-2>T-3>T-1', '4 cauda=T-1>T-2>T-1', '5 fantasma=\s*$')

# v3.57.0 — run.ps1 wait (a sonda só de leitura do watcher): terminou (0) · vivo (3) · POSSÍVEL TRAVAMENTO (5), e nada gravado.
$wt = Join-Path $tmp 'wait-test.ps1'
[System.IO.File]::WriteAllText($wt, @'
param([string]$Run, [string]$Proj)
$u8 = New-Object System.Text.UTF8Encoding($false)
$tp = Join-Path $Proj '.team-project'
New-Item -ItemType Directory -Force (Join-Path $tp 'verify\7\T-2') | Out-Null
$dash = [string][char]0x2014
[System.IO.File]::WriteAllText((Join-Path $tp 'README.md'), "# Contexto`n`n## 2. Situacao atual`n`n| | |`n|---|---|`n| **Sprint corrente** | **7** $dash teste |`n", $u8)
function W { $o = (& powershell -NoProfile -ExecutionPolicy Bypass -File $Run wait -Root $Proj 2>&1 | ForEach-Object { "$_" }) -join ' '; return "exit=$LASTEXITCODE $o" }
$now = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
"1 " + (W)
[System.IO.File]::WriteAllText((Join-Path $tp '.next-verdict'), ('{"acao":"esperar","task":"T-2","motivo":"x","at":"' + $now + '"}'), $u8)
"2 " + (W)
[System.IO.File]::WriteAllText((Join-Path $tp '.active-agents'), ('[{"type":"team:developer","description":"Dev T-2","desde":"' + $now + '","session":"s","parent":"","agent_id":"a1","work":"T-2","last":"Bash","at":"' + $now + '"}]'), $u8)
"3 " + (W)
Remove-Item (Join-Path $tp '.active-agents') -Force
$sl = Start-Process powershell -ArgumentList '-NoProfile', '-Command', 'Start-Sleep 90' -PassThru -WindowStyle Hidden
Start-Sleep 2
$lk = Join-Path $tp 'verify\7\T-2\verify.lock'
[System.IO.File]::WriteAllText($lk, ([ordered]@{ pid = $sl.Id; started = $sl.StartTime.ToString('o'); at = (Get-Date).AddMinutes(-15).ToString('yyyy-MM-dd HH:mm:ss'); mode = 'full' } | ConvertTo-Json -Compress), $u8)
"4 " + (W)
[System.IO.File]::WriteAllText($lk, ([ordered]@{ pid = $sl.Id; started = $sl.StartTime.ToString('o'); at = (Get-Date).AddMinutes(-1).ToString('yyyy-MM-dd HH:mm:ss'); mode = 'full' } | ConvertTo-Json -Compress), $u8)
"5 " + (W)
"6 verdict-intacto=" + ((Get-Content (Join-Path $tp '.next-verdict') -Raw) -match '"motivo":"x"')
function WF([int]$For) { $o = (& powershell -NoProfile -ExecutionPolicy Bypass -File $Run wait -For $For -Every 1 -Root $Proj 2>&1 | ForEach-Object { "$_" }) -join ' '; return "exit=$LASTEXITCODE $o" }
"7 " + (WF 3)
$fim = Start-Process powershell -ArgumentList '-NoProfile', '-Command', ('Start-Sleep 2; Remove-Item -LiteralPath ''' + $lk + ''' -Force') -PassThru -WindowStyle Hidden
"8 " + (WF 20)
$old = (Get-Date).AddMinutes(-15).ToString('yyyy-MM-dd HH:mm:ss')
[System.IO.File]::WriteAllText((Join-Path $tp '.active-agents'), ('[{"type":"team:developer","description":"Dev T-2","desde":"' + $old + '","session":"s","parent":"","agent_id":"a1","work":"T-2","last":"Set-Location source; npm run alvo:apk -- T-2","at":"' + $old + '"}]'), $u8)
[System.IO.File]::WriteAllText((Join-Path $tp 'guards.json'), '{ "waitSignals": [ { "when": "alvo:apk", "paths": ["out/www"], "alive": "Write-Output garden-management-builder-run-1" } ] }', $u8)
"9 " + (W)
[System.IO.File]::WriteAllText((Join-Path $tp 'guards.json'), '{ "waitSignals": [ { "when": "alvo:apk", "paths": ["out/www"], "alive": "exit 0" } ] }', $u8)
"10 " + (W)
New-Item -ItemType Directory -Force (Join-Path $Proj 'out/www') | Out-Null; [System.IO.File]::WriteAllText((Join-Path $Proj 'out/www/main.js'), 'x', $u8)
"11 " + (W)
Remove-Item (Join-Path $tp '.active-agents'), (Join-Path $tp 'guards.json') -Force
# v3.58.1: build feito de filhos curtos — a CPU viva da árvore é baixa (o filho que terminou levou a dele), mas um filho
# nasceu agora: vivo, não POSSÍVEL TRAVAMENTO (antes: 15 min e CPU < 5 s = travado falso).
$pa = Start-Process powershell -ArgumentList '-NoProfile', '-Command', '& powershell -NoProfile -Command ''Start-Sleep 60''' -PassThru -WindowStyle Hidden
Start-Sleep 3
[System.IO.File]::WriteAllText($lk, ([ordered]@{ pid = $pa.Id; started = $pa.StartTime.ToString('o'); at = (Get-Date).AddMinutes(-15).ToString('yyyy-MM-dd HH:mm:ss'); mode = 'full' } | ConvertTo-Json -Compress), $u8)
"12 " + (W)
Remove-Item $lk -Force
Get-CimInstance Win32_Process -Filter "ParentProcessId=$($pa.Id)" | ForEach-Object { try { Stop-Process -Id $_.ProcessId -Force } catch { } }
try { Stop-Process -Id $pa.Id -Force } catch { }
try { Stop-Process -Id $sl.Id -Force } catch { }
'@, $utf8)
$wo = (& powershell -NoProfile -ExecutionPolicy Bypass -File $wt -Run (Join-Path $checks 'run.ps1') -Proj (Join-Path $tmp 'wait-proj') 2>&1 | ForEach-Object { "$_" }) -join "`n"
Check 'v3.57.0 protocolo: run.ps1 wait — nada registrado/nada em espera = 0, dev vivo = 3, comando 15 min sem CPU nem arquivo = 5 (POSSÍVEL TRAVAMENTO), o mesmo com 1 min = 3, e o .next-verdict fica intacto; v3.57.1: -For espera dentro do script (vivo o prazo todo = 3 com várias conferências; terminou no meio = 0 e para cedo); waitSignals do projeto: build no container com alive = vivo, sem arquivo nem alive há 15 min = 5, arquivo novo = vivo' @{ Code = 0; Out = $wo } 0 @('1 exit=0 wait: terminou — nenhuma espera registrada', '2 exit=0 wait: terminou — a T-2 não tem agente nem comando', '3 exit=3 wait: vivo — T-2 · developer vivo', '4 exit=5 wait: POSSÍVEL TRAVAMENTO — T-2 · verify full', '5 exit=3 wait: vivo — T-2 · verify full', '6 verdict-intacto=True', '7 exit=3 wait: vivo — T-2 · verify full.*\(conferido [2-4] vez\(es\) em [2-6] s\)', '8 exit=0 wait: terminou — a T-2 não tem agente nem comando.*\(conferido \d vez\(es\) em [1-6] s\)', '9 exit=3 wait: vivo — T-2 · developer vivo \(última ação .*alvo:apk.* há 1[56] min\) · sinal do projeto \(alvo:apk\) · nenhum arquivo nas pastas declaradas · alive: rodando', '10 exit=5 wait: POSSÍVEL TRAVAMENTO — T-2 .*alive: sem saída \(sem ação do agente, sem arquivo novo e sem o alive há 10 min ou mais\)', '11 exit=3 wait: vivo — T-2 .*último arquivo em out/www há 0 min · alive: sem saída', '12 exit=3 wait: vivo — T-2 · verify full .*há 1[56] min · CPU \d s .*processo filho novo há 0 min')
# v3.58.1: o comando do watcher cabe no limite da ferramenta — o -For do roteiro não passa do teto do run.ps1 (90 s), a
# chamada leva timeout explícito, e o roteiro do SM cita o mesmo comando (a v3.57.1 escolheu 150 s contra um limite de 180 s
# que não existia: toda chamada passava dos 120 s e ia para segundo plano, às vezes com a saída vazia).
$wmd = Get-Content -LiteralPath (Join-Path $checks '../../agents/watcher.md') -Raw -Encoding UTF8
$srm = Get-Content -LiteralPath (Join-Path $checks '../../roles/scrum-master/process/sprint-run.md') -Raw -Encoding UTF8
$rps = Get-Content -LiteralPath (Join-Path $checks 'run.ps1') -Raw -Encoding UTF8
$wFor = if ($wmd -match 'run\.ps1" wait -For (\d+)') { [int]$Matches[1] } else { -1 }
$wCap = if ($rps -match '\$script:waitMaxFor = (\d+)') { [int]$Matches[1] } else { -1 }
$wRot = $srm.Contains('wait -For ' + $wFor + '`')
$wOut = "for=$wFor cap=$wCap cabe=$($wFor -gt 0 -and $wFor -le $wCap -and $wCap -le 100) timeout=$($wmd -match 'timeout: 300000') roteiro=$wRot vazia=$($wmd -match 'Saída vazia')"
Check 'v3.58.1: o watcher roda wait -For <= teto do run.ps1 (<= 100 s, abaixo dos 120 s da ferramenta), com timeout explícito, o roteiro cita o mesmo -For e a saída vazia tem regra' @{ Code = 0; Out = $wOut } 0 @('cabe=True', 'timeout=True', 'roteiro=True', 'vazia=True')

# v3.57.1 (note.md item 11) — "## Agora" para quem acompanha: papel com nome de gente, título da Task (a linha com marcador,
# não a tabela de Histórias; a frase em negrito vira o nome), o que faz numa frase simples e horários fixos (sem "Há N min").
$ag = Join-Path $tmp 'agora-test.ps1'
[System.IO.File]::WriteAllText($ag, @'
param([string]$Common, [string]$P)
. $Common
$u8 = New-Object System.Text.UTF8Encoding($false)
New-Item -ItemType Directory -Force (Join-Path $P '.team-project/sprints/3') | Out-Null
[System.IO.File]::WriteAllText((Join-Path $P '.team-project/README.md'), "# x`n`n| **Sprint corrente** | **3** $([char]0x2014) t |`n", $u8)
[System.IO.File]::WriteAllText((Join-Path $P '.team-project/sprints/3/sprint-backlog.md'), "| T-9 | H-A | H-A | 1 |`n`n| ID | Task |`n|---|---|`n| $([char]::ConvertFromUtf32(0x1F7E8)) T-9 | Tela de login (com ``ids`` novos) | 1 |`n| $([char]::ConvertFromUtf32(0x2B1C)) Q-S3b | **Suíte estável:** ``karma.conf.js`` com prazo | 1 |`n", $u8)
[System.IO.File]::WriteAllText((Join-Path $P '.team-project/sprints/3/kanban.md'), "# Kanban`n`n## Agora`nvelho`n`n## Kanban`nx`n", $u8)
$at = (Get-Date).AddMinutes(-12).ToString('yyyy-MM-dd HH:mm:ss')
Write-NowSection $P @(
  [pscustomobject]@{ type = 'team:task-runner'; desde = $at; parent = ''; agent_id = 'r1'; work = 'T-9'; last = 'aguardando filho'; at = $at },
  [pscustomobject]@{ type = 'team:developer'; desde = $at; parent = 'r1'; agent_id = 'd1'; work = 'T-9'; last = 'powershell -NoProfile -File "C:/p/scripts/checks/verify.ps1" -Task T-9 -Mode full'; at = $at },
  [pscustomobject]@{ type = 'team:watcher'; desde = $at; parent = ''; agent_id = 'w1'; work = ''; last = 'powershell -NoProfile -File "C:/p/scripts/checks/run.ps1" wait -For 150'; at = $at },
  [pscustomobject]@{ type = 'team:developer'; desde = $at; parent = ''; agent_id = 'd2'; work = 'Q-S3b'; last = 'Edit karma.conf.js'; at = $at })
[System.IO.File]::ReadAllText((Join-Path $P '.team-project/sprints/3/kanban.md'))
'@, (New-Object System.Text.UTF8Encoding($true)))
$hm = (Get-Date).AddMinutes(-12).ToString('HH:mm')
$ao = (& powershell -NoProfile -ExecutionPolicy Bypass -File $ag -Common (Join-Path $checks '../../hooks/common.ps1') -P (Join-Path $tmp 'agora-proj') 2>&1 | ForEach-Object { "$_" }) -join "`n"
# v3.59.0: o papel com o nome que alguém de negócio reconhece e a parte pelo nome, com o código no fim.
Check 'v3.57.1 item 11: "## Agora" com papel por nome, nome da parte, frase simples e horários fixos (sem "Há N min" nem comando cru)' @{ Code = 0; Out = $ao } 0 @('\| Quem \| Em quê \| O que está fazendo \| Última ação às \| Começou às \|', "\| Coordenador da tarefa \| Tela de login \(T-9\) \| esperando o membro do time que ele chamou terminar \| $hm \| $hm \|", '\| Desenvolvedor \(chamado pelo Coordenador da tarefa\) \| Tela de login \(T-9\) \| conferindo tudo: compilação, testes e cobertura \|', '\| Vigia \(só acompanha a espera\) \| — \| conferindo se a espera terminou \|', '\| Desenvolvedor \| Suíte estável \(Q-S3b\) \| alterando o arquivo karma\.conf\.js \|', '^(?![\s\S]*(velho|verify\.ps1|\d+ min \|))', '## Kanban\nx')
# v3.59.0 — o nome de cada parte para quem acompanha (plain.ps1): a coluna "Para o stakeholder" vence; sem ela, o título da
# História (sem o parêntese do fim) com "parte k de m"; a correção do portão, "ajustes pedidos na revisão final"; a retirada fica fora.
$pnp = Join-Path $tmp 'plain-names'
Put $pnp '.team-project/sprints/2/sprint-backlog.md' ("## História H-W — Geral: filtro ``Estado`` responde ao toque (2 Tasks)`n`n| ID | Task | Est. | Cenários | Critério de pronto | Para o stakeholder |`n|---|---|---|---|---|---|`n| $($e.todo) T-1 | ``opcoesFiltroStatus`` vira campo calculado | 1 | — | x | filtro de estado da tela Geral |`n| $($e.todo) T-2 | ``trackBy`` por valor | 1 | — | x | |`n| $($e.todo) ~~T-3~~ retirada | x | 1 | — | x | |`n`n## História H-V — Vendas por Período (alta)`n`n| ID | Task | Est. |`n|---|---|---|`n| $($e.todo) T-4 | ``VendaService`` | 1 |`n`n## Correção do portão — sprint 2`n`n| ID | Task | Est. |`n|---|---|---|`n| $($e.todo) Q-S2 | achados 1 e 2 | 1 |`n")
$pnScript = Join-Path $tmp 'plain-names.ps1'
[System.IO.File]::WriteAllText($pnScript, "param([string]`$Plain, [string]`$P)`n. `$Plain`n`$n = Get-PlainNames `$P '2'`nforeach (`$k in (`$n.Keys | Sort-Object)) { `"`$k=`$(`$n[`$k])`" }`n`"LABEL=`$(Get-PlainLabel `$n 'T-2')`"`n`"REASON=`$(Get-PlainReason 'dependência de método: cada migração só se planeja com a anterior')`"`n", (New-Object System.Text.UTF8Encoding($true)))
$pno = (& powershell -NoProfile -ExecutionPolicy Bypass -File $pnScript -Plain (Join-Path $checks 'plain.ps1') -P $pnp 2>&1 | ForEach-Object { "$_" }) -join "`n"
Check 'v3.59.0: nome da parte — coluna Para o stakeholder, História com parte k de m, correção do portão; a retirada fica fora' @{ Code = 0; Out = $pno } 0 @('(?m)^Q-S2=ajustes pedidos na revisão final$', '(?m)^T-1=filtro de estado da tela Geral$', '(?m)^T-2=Geral: filtro Estado responde ao toque — parte 2 de 2$', '(?m)^T-4=Vendas por Período$', 'LABEL=Geral: filtro Estado responde ao toque — parte 2 de 2 \(T-2\)', 'REASON=espera outra parte ficar pronta', '^(?![\s\S]*T-3=)')
# v3.57.0 — modo desprendido e target.ps1 -Kill: só o que o run registrou é encerrado; o de fora e o PID reaproveitado, não.
$kt = Join-Path $tmp 'kill-test.ps1'
[System.IO.File]::WriteAllText($kt, @'
param([string]$Checks, [string]$Proj)
. (Join-Path $Checks 'lib.ps1')
New-Item -ItemType Directory (Join-Path $Proj '.team-project') -Force | Out-Null
$mk = { Start-Process powershell -ArgumentList '-NoProfile', '-Command', 'Start-Sleep 90' -PassThru -WindowStyle Hidden }
$a = & $mk; $b = & $mk; $c = & $mk
Start-Sleep 2
$null = Register-Detached $Proj 'android' @($a.Id) 'teste'
# v3.63.1: sem o SDK no ambiente — o -Kill do android limpa os adb forward da WebView, e o adb real da máquina (um accept de
# projeto rodando no emulador) perderia o forward dele no meio de um cenário (medido em 18/11: a suíte removeu o forward do piloto).
$env:ANDROID_HOME = Join-Path $Proj 'sem-sdk'; $env:ANDROID_SDK_ROOT = ''; $env:PATH = (@($env:PATH -split ';') | Where-Object { $_ -and $_ -notmatch '(?i)platform-tools|Android\\Sdk' }) -join ';'
$f = Join-Path $Proj '.team-project/.target-android.json'
$j = [System.IO.File]::ReadAllText($f) | ConvertFrom-Json
$j.procs = @($j.procs) + @([pscustomobject]@{ pid = $c.Id; created = '2001-01-01T00:00:00.0000000+00:00' })
[System.IO.File]::WriteAllText($f, ($j | ConvertTo-Json -Depth 4 -Compress))
$o = (& powershell -NoProfile -File (Join-Path $Checks 'target.ps1') -Target android -Kill -Root $Proj 2>&1 | ForEach-Object { "$_" }) -join ' '
Start-Sleep 2; $a.Refresh(); $b.Refresh(); $c.Refresh()
"1 saida: $o"
"2 registrado-morreu=$($a.HasExited) fora-do-registro-vivo=$(-not $b.HasExited) pid-reaproveitado-vivo=$(-not $c.HasExited) registro-apagado=$(-not (Test-Path $f))"
$o2 = (& powershell -NoProfile -File (Join-Path $Checks 'target.ps1') -Target android -Kill -Root $Proj 2>&1 | ForEach-Object { "$_" }) -join ' '
"3 de-novo: $o2"
foreach ($x in @($b, $c)) { try { Stop-Process -Id $x.Id -Force -ErrorAction SilentlyContinue } catch { } }
'@, $utf8)
$ko = (& powershell -NoProfile -ExecutionPolicy Bypass -File $kt -Checks $checks -Proj (Join-Path $tmp 'kill-proj') 2>&1 | ForEach-Object { "$_" }) -join "`n"
Check 'v3.57.0 protocolo: target.ps1 -Kill encerra só o processo registrado pelo run (o de fora e o PID reaproveitado ficam; o registro some; de novo = nada registrado)' @{ Code = 0; Out = $ko } 0 @('1 saida: target android: -Kill — 1 encerrado\(s\), 0 já tinha\(m\) saído, 1 com PID reaproveitado', '2 registrado-morreu=True fora-do-registro-vivo=True pid-reaproveitado-vivo=True registro-apagado=True', '3 de-novo: target android: nada registrado')

# ---------- v3.57.3 (plugin-report do sprint 5 do garden; decisões do stakeholder de 10/11) ----------
$p = Join-Path $tmp 'v3573'; New-Project $p
$ErrorActionPreference = 'Continue'
& git -C $p init -q 2>$null; Put $p 'src/a.ts' "x`n"; Put $p '.gitignore' "coverage/`n.team-project/`n"
& git -C $p add -A 2>$null; & git -C $p -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
$plv = Join-Path $p '.team-project/sprints/1/plan/T-041-export.md'
$plv0 = [System.IO.File]::ReadAllText($plv, $utf8)
# Leitor da linha **Verificação:** (regra 35).
$gv = & { . (Join-Path $checks 'lib.ps1')
    $a = Get-PlanVerification "# P`n**Verificação:** dispensada — laudo sem código`n"
    $b = Get-PlanVerification "# P`n**Verificação:** comando — ``node --test scripts/x.test.mjs`` — runner nativo`n"
    $c = Get-PlanVerification "# P`n**Verificação:** talvez`n"
    $d = Get-PlanVerification "# P`n**Cenários:** nenhum — x`n"
    "A=$($a.Mode)|$($a.Reason) B=$($b.Mode)|$($b.Command)|$($b.Reason) C=$($c.Mode) D=$($null -eq $d)" }; $e = $e0
Check 'v3.57.3 regra 35: **Verificação:** dispensada / comando / fora do formato / ausente' @{ Code = 0; Out = $gv } 0 @('A=dispensada\|laudo sem código', 'B=comando\|node --test scripts/x\.test\.mjs\|runner nativo', 'C=inválida', 'D=True')
# plan.ps1: a linha da regra 35 (só a linha "verificação" importa aqui).
$cases35 = @(
    @('**Verificação:** dispensada — laudo sem código', '\| verificação \| ok \| dispensada — laudo sem código'),
    @("**Verificação:** comando — ``node --test scripts/x.test.mjs``", "\| verificação \| ok \| comando ``node --test scripts/x\.test\.mjs``"),
    @("**Verificação:** comando — ``npm install x``", '\| verificação \| falhou \| \*\*Verificação:\*\* comando que o run nunca roda: npm install x \(instalação\)'),
    @('**Verificação:** depois a gente vê', '\| verificação \| falhou \| \*\*Verificação:\*\* fora do formato'))
foreach ($c35 in $cases35) {
    [System.IO.File]::WriteAllText($plv, $plv0.Replace('## 3. Ambiente', "$($c35[0])`n`n## 3. Ambiente"), $utf8)
    $r = Invoke-Check 'plan.ps1' @('-Plan', $plv, '-Root', $p)
    Check "v3.57.3 regra 35 no plan.ps1: $($c35[0])" @{ Code = 0; Out = $r.Out } 0 @($c35[1])
}
[System.IO.File]::WriteAllText($plv, $plv0.Replace('## 3. Ambiente', "**Verificação:** dispensada — laudo`n`n**Mutações:**`n- M1 · teste ``tests/a.test.ts`` · ``src/a.ts`` · regra: aceitar valor igual ao limite`n`n## 3. Ambiente"), $utf8)
$r = Invoke-Check 'plan.ps1' @('-Plan', $plv, '-Root', $p)
Check 'v3.57.3 regra 35: dispensa do full com **Mutações:** reprova' @{ Code = 0; Out = $r.Out } 0 @('\| verificação \| falhou \| \*\*Verificação:\*\* dispensada com \*\*Mutações:\*\*')
# verify.ps1: o comando do plano vira o passo "plano" no focused (sem -Tests) e no full.
Put $p '.team-project/guards.json' '{ "verify": { "focused": "Write-Output \"Tests: 2 passed {tests}\"", "build": "Write-Output \"Build succeeded. 0 Warning(s)\"", "suite": "Write-Output \"Tests: 12 passed\"" } }'
[System.IO.File]::WriteAllText($plv, $plv0.Replace('## 3. Ambiente', "**Verificação:** comando — ``Write-Output 'node: tests 3 pass 3'`` — runner nativo`n`n## 3. Ambiente"), $utf8)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'focused', '-Root', $p)
Check 'v3.57.3 regra 35: verify focused sem -Tests roda o comando do plano (passo "plano")' $r 0 @('verify focused T-041', 'plano: exit 0 .*tests 3 pass 3', 'o comando de \*\*Verificação:\*\* do plano rodou')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
Check 'v3.57.3 regra 35: verify full roda build, suíte e o passo "plano"' $r 0 @('build: exit 0', 'suite: exit 0', 'plano: exit 0')
# close.ps1: com a dispensa, o R7-verify é n-a mesmo sem verify full.
[System.IO.File]::WriteAllText($plv, $plv0.Replace('## 3. Ambiente', "**Verificação:** dispensada — laudo sem código`n`n## 3. Ambiente"), $utf8)
$vdir = Join-Path $p '.team-project/verify'
if (Test-Path -LiteralPath $vdir) { Get-ChildItem -LiteralPath $vdir -Recurse -Filter 'result.json' -File | ForEach-Object { [System.IO.File]::Delete($_.FullName) } }
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.57.3 regra 35: close com **Verificação:** dispensada → R7-verify n-a, o QA revisa' @{ Code = 0; Out = $r.Out } 0 @('\| R7-verify \| n-a \| o plano dispensa o verify full .*laudo sem código.*o QA revisa a dispensa')
[System.IO.File]::WriteAllText($plv, $plv0, $utf8)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.57.3 regra 35: sem a linha, o R7-verify segue exigindo o full' @{ Code = 0; Out = $r.Out } 0 @('\| R7-verify \| falhou \| sem verify full')

# verify.ps1 -Kill: a rodada viva da trava e o órfão registrado; e a rodada nova encerra o órfão da anterior que caiu.
$vk = Join-Path $tmp 'verify-kill.ps1'
[System.IO.File]::WriteAllText($vk, @'
param([string]$Checks, [string]$Proj)
. (Join-Path $Checks 'lib.ps1')
$u8 = New-Object System.Text.UTF8Encoding($false)
$d = Join-Path $Proj '.team-project/verify/1/T-041'; New-Item -ItemType Directory -Force $d | Out-Null
$mk = { Start-Process powershell -ArgumentList '-NoProfile', '-Command', 'Start-Sleep 90' -PassThru -WindowStyle Hidden }
$owner = & $mk; $orph = & $mk; $out = & $mk
Start-Sleep 2
[System.IO.File]::WriteAllText((Join-Path $d 'verify.lock'), ([ordered]@{ pid = $owner.Id; started = $owner.StartTime.ToString('o'); mode = 'full'; at = 'agora' } | ConvertTo-Json -Compress), $u8)
[System.IO.File]::WriteAllText((Join-Path $d 'running.json'), ([ordered]@{ pid = $orph.Id; created = (Get-ProcessCreated $orph.Id); key = 'suite'; owner = 1; at = 'agora' } | ConvertTo-Json -Compress), $u8)
$o = (& powershell -NoProfile -File (Join-Path $Checks 'verify.ps1') -Task T-041 -Kill -Root $Proj 2>&1 | ForEach-Object { "$_" }) -join ' '
Start-Sleep 1; $owner.Refresh(); $orph.Refresh(); $out.Refresh()
"1 saida: $o"
"2 dono-morreu=$($owner.HasExited) orfao-morreu=$($orph.HasExited) de-fora-vivo=$(-not $out.HasExited) trava-saiu=$(-not (Test-Path (Join-Path $d 'verify.lock'))) registro-saiu=$(-not (Test-Path (Join-Path $d 'running.json')))"
$o2 = (& powershell -NoProfile -File (Join-Path $Checks 'verify.ps1') -Task T-041 -Kill -Root $Proj 2>&1 | ForEach-Object { "$_" }) -join ' '
"3 de-novo: $o2"
$orph2 = & $mk; Start-Sleep 2
[System.IO.File]::WriteAllText((Join-Path $d 'running.json'), ([ordered]@{ pid = $orph2.Id; created = (Get-ProcessCreated $orph2.Id); key = 'suite'; owner = 1; at = 'agora' } | ConvertTo-Json -Compress), $u8)
$o3 = (& powershell -NoProfile -File (Join-Path $Checks 'verify.ps1') -Task T-041 -Mode full -Root $Proj 2>&1 | ForEach-Object { "$_" }) -join ' '
Start-Sleep 1; $orph2.Refresh()
"4 rodada-nova: orfao-morreu=$($orph2.HasExited) $o3"
"5 running-depois-do-full=$(Test-Path (Join-Path $d 'running.json'))"
foreach ($x in @($out, $orph2)) { try { Stop-Process -Id $x.Id -Force -ErrorAction SilentlyContinue } catch { } }
'@, $utf8)
$ko = (& powershell -NoProfile -ExecutionPolicy Bypass -File $vk -Checks $checks -Proj $p 2>&1 | ForEach-Object { "$_" }) -join "`n"
Check 'v3.57.3 item 1: verify -Kill encerra a rodada viva da trava e o órfão registrado (o de fora fica); de novo = nada; a rodada nova encerra o órfão da anterior e não deixa registro' @{ Code = 0; Out = $ko } 0 @('1 saida: verify -Kill T-041: rodada full encerrada \(verify pid \d+, desde agora\).*órfão do passo suite encerrado', '2 dono-morreu=True orfao-morreu=True de-fora-vivo=True trava-saiu=True registro-saiu=True', '3 de-novo: verify -Kill T-041: nada a encerrar', '4 rodada-nova: orfao-morreu=True verify: encerrado o processo órfão da rodada anterior que caiu \(passo suite', '5 running-depois-do-full=False')

# v3.62.2 (sprint 6 do garden, Q-S6d): RODADA DESACOPLADA. O Claude Code encerra o comando do agente — e a árvore dele — quando
# o agente dá a resposta final; a suíte de 17–25 min morria com o turno do dev. Agora a rodada roda num processo criado pelo
# WMI e a chamada só a acompanha: exit 3 "RODANDO", o MESMO comando volta a acompanhá-la, e ela sobrevive à árvore de quem chamou.
$pj = Join-Path $tmp 'verify-desacoplado'; New-Project $pj
$ErrorActionPreference = 'Continue'
& git -C $pj init -q 2>$null; Put $pj '.gitignore' ".team-project/`n"; Put $pj 'src/calc.ts' "export const x = 1`n"
& git -C $pj add -A 2>$null; & git -C $pj -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
Put $pj '.team-project/guards.json' '{ "verify": { "minFreeMB": 0, "build": "Write-Output ''Build succeeded''", "suite": "Start-Sleep -Seconds 9; Write-Output ''Tests: 3 passed''" } }'
$jd62 = Join-Path $pj '.team-project/verify/1/T-041/job'
$env:TEAM_VERIFY_FRONT_SEC = '3'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pj)
Check 'v3.62.2: full mais longo que a espera da chamada → exit 3 RODANDO em processo próprio, com a instrução de rodar o MESMO comando no mesmo turno' $r 3 @('verify full T-041 · RODANDO em processo próprio \(pid \d+', 'rode o MESMO comando de novo AGORA, no mesmo turno \(exit 3\)', 'Não encerre o turno para esperar')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'focused', '-Tests', 'src/calc.ts', '-Root', $pj)
Check 'v3.62.2: outro pedido da mesma Task com a rodada viva → OCUPADO, exit 5 (não abre uma segunda rodada)' $r 5 @('OCUPADO — outra rodada desta Task \(full, pid \d+', 'em processo próprio')
$env:TEAM_VERIFY_FRONT_SEC = '60'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pj)
Check 'v3.62.2: o MESMO comando volta a acompanhar a mesma rodada e entrega o resultado dela (exit 0), sem deixar a pasta da rodada' @{ Code = $r.Code; Out = $r.Out + "`nJOB=" + (Test-Path -LiteralPath (Join-Path $jd62 'job.json')) } 0 @('acompanhando a rodada que já roda em processo próprio', 'tudo exit 0', 'suite: exit 0 .*Tests: 3 passed', 'JOB=False')
# A árvore de quem chamou morre no meio da suíte (o que o Claude Code faz no fim do turno): a rodada segue e a chamada seguinte a entrega.
Put $pj 'src/calc.ts' "export const x = 2`n"
$vs = Join-Path $tmp 'verify-sobrevive.ps1'
[System.IO.File]::WriteAllText($vs, @'
param([string]$Checks, [string]$Proj)
. (Join-Path $Checks 'lib.ps1')
$ag = Start-Process powershell -ArgumentList '-NoProfile', '-Command', "& powershell -NoProfile -ExecutionPolicy Bypass -File '$(Join-Path $Checks 'verify.ps1')' -Task T-041 -Mode full -Root '$Proj'" -PassThru -WindowStyle Hidden
Start-Sleep -Seconds 5
$k = Stop-ProcessTree $ag.Id
$job = Get-DetachedJob (Join-Path $Proj '.team-project/verify/1/T-041/job')
"1 agente-encerrado=$($k -ge 1) rodada=$(if ($job) { $job.State } else { 'nenhuma' })"
'@, $utf8)
$so = (& powershell -NoProfile -ExecutionPolicy Bypass -File $vs -Checks $checks -Proj $pj 2>&1 | ForEach-Object { "$_" }) -join "`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pj)
Check 'v3.62.2: a árvore de quem chamou encerrada no meio da suíte (o fim do turno do agente) — a rodada sobrevive e o MESMO comando a entrega' @{ Code = $r.Code; Out = $so + "`n" + $r.Out } 0 @('1 agente-encerrado=True rodada=running', 'acompanhando a rodada que já roda em processo próprio', 'tudo exit 0')
# Rodada que caiu sem resultado (executor encerrado de fora): a chamada diz e abre outra.
Put $pj 'src/calc.ts' "export const x = 3`n"
Put $pj '.team-project/verify/1/T-041/job/job.json' '{"sig":"task=T-041|mode=full|tests=|plan=|only=|precheck=False|fresh=False|timeout=0","label":"full","tree":"x","pid":999999,"created":"2001-01-01T00:00:00","at":"2026-11-17 13:43:00"}'
Put $pj '.team-project/verify/1/T-041/job/job.out' "linha da suíte que caiu`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pj)
Check 'v3.62.2: rodada anterior que caiu sem gravar o resultado → a chamada diz, com o fim da saída, e abre outra' $r 0 @('terminou sem gravar o resultado .*fim da saída: linha da suíte que caiu', 'Abro uma rodada nova', 'tudo exit 0')
# Rodada terminada que ninguém recolheu (quem acompanhava caiu): na mesma árvore, o resultado é o dela; árvore mudada, roda de novo.
$env:TEAM_VERIFY_FRONT_SEC = '3'
Put $pj 'src/calc.ts' "export const x = 4`n"
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pj)
# v3.62.3: espera a rodada terminar (job.exit) em vez de 12 s fixos — build + suíte de 9 s + o processo próprio levam ~15 s,
# e o caso falhava sempre, também na develop.
$t62 = [datetime]::UtcNow; while (-not (Test-Path -LiteralPath (Join-Path $jd62 'job.exit')) -and ([datetime]::UtcNow - $t62).TotalSeconds -lt 60) { Start-Sleep -Milliseconds 500 }
Start-Sleep -Seconds 1
$env:TEAM_VERIFY_FRONT_SEC = '60'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pj)
Check 'v3.62.2: rodada terminada sem ninguém recolher, mesma árvore → o resultado é o dela, sem rodar de novo' $r 0 @('rodada deste pedido terminada às .* em processo próprio .* a mesma árvore; o resultado é o dela', 'tudo exit 0')
# -Kill encerra a rodada em processo próprio e a árvore dela.
$env:TEAM_VERIFY_FRONT_SEC = '3'
Put $pj 'src/calc.ts' "export const x = 5`n"
$null = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pj)
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Kill', '-Root', $pj)
Start-Sleep -Seconds 1
$vivos62 = @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object { [string]$_.CommandLine -match [regex]::Escape($jd62) -or [string]$_.CommandLine -match [regex]::Escape("-Root '$pj'") }).Count
Check 'v3.62.2: verify -Kill encerra a rodada em processo próprio (executor, verify e suíte) e apaga a pasta dela' @{ Code = $r.Code; Out = $r.Out + "`nVIVOS=$vivos62 JOB=" + (Test-Path -LiteralPath (Join-Path $jd62 'job.json')) } 0 @('rodada em processo próprio encerrada \(\d+ processo', 'VIVOS=0 JOB=False')
Remove-Item Env:TEAM_VERIFY_FRONT_SEC -ErrorAction SilentlyContinue
# detach.ps1: comando longo do operator em processo próprio, com o mesmo contrato.
$dj = Join-Path $pj '.team-project/operator/1/T-041-longo'
$r = Invoke-Check 'detach.ps1' @('-Dir', $dj, '-Command', "Start-Sleep -Seconds 6; Write-Output 'pronto'; exit 7", '-WaitSeconds', '2', '-Root', $pj)
Check 'v3.62.2: detach.ps1 com comando mais longo que a espera → exit 3 RODANDO' $r 3 @('detach: RODANDO em processo próprio \(pid \d+', 'rode o MESMO comando de novo AGORA')
$r = Invoke-Check 'detach.ps1' @('-Dir', $dj, '-Command', "Write-Output outro", '-Root', $pj)
Check 'v3.62.2: detach.ps1 com outro comando na mesma pasta viva → OCUPADO, exit 5' $r 5 @('detach: OCUPADO — outro comando roda')
$r = Invoke-Check 'detach.ps1' @('-Dir', $dj, '-Command', "Start-Sleep -Seconds 6; Write-Output 'pronto'; exit 7", '-Root', $pj)
Check 'v3.62.2: detach.ps1, o MESMO comando: acompanha a rodada e sai com o exit do comando, com o log no disco' @{ Code = $r.Code; Out = $r.Out + "`nLOG=" + (Test-Path -LiteralPath (Join-Path $dj 'output.log')) } 7 @('acompanhando a rodada que já roda', 'detach: terminou · exit 7', '  pronto', 'LOG=True')

# quality.ps1 Q11: reaproveita a cobertura do verify full da mesma árvore; 0/0 vira "não medido".
Put $p '.team-project/guards.json' '{ "verify": { "build": "Write-Output ok", "suite": "Write-Output \"Tests: 12 passed\"", "coverage": "Write-Output \"All files  |  91.5 %\"" }, "quality": { "coverage": "Write-Output \"Statements   : Unknown% ( 0/0 )\"; exit 1" } }'
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $p)
$r = Invoke-Check 'quality.ps1' @('-Id', 'S1', '-Root', $p)
Check 'v3.57.3 item 2: Q11 com o verify full da mesma árvore — reaproveitada (91.5 %), sem rodar o quality.coverage' $r 0 @('Q11 ok: .*reaproveitada do verify full da T-041 .*mesma árvore.*91\.5 % medido')
Put $p 'src/b.ts' "nova`n"   # árvore mudou: o full antigo não vale; o quality.coverage roda e não mede nada
$r = Invoke-Check 'quality.ps1' @('-Id', 'S1', '-Root', $p)
Check 'v3.57.3 item 2: Q11 "Unknown% ( 0/0 )" → não medido, com a causa; não reprova o portão' $r 0 @('ATENÇÃO: Q11 não medida', 'Q11 não medido: .*a cobertura não mediu nada \(Unknown% / 0 de 0, exit 1\).*quality\.coverage')
Put $p '.team-project/guards.json' '{ "quality": { "coverage": "Write-Output \"Total coverage 42 %\"" } }'
$r = Invoke-Check 'quality.ps1' @('-Id', 'S1', '-Root', $p)
Check 'v3.57.3 item 2: Q11 medida abaixo do limiar segue reprovando' $r 1 @('Q11 falhou: .*42 % medido × limiar 80 % .*abaixo do limiar')
# v3.65.1 (garden S6-F12, D-20): com o coveragePattern do projeto, toda ocorrência conta e vale a menor, com o módulo na linha.
$covMods = 'OK módulo apresentacao: 89.63% de linhas — piso 88%\nOK módulo raiz: 85.00% de linhas — piso 84%\nOK módulo servicos: 93.84% de linhas — piso 92%'
Put $p '.team-project/guards.json' ('{ "quality": { "coverage": "Write-Output \"' + $covMods + '\"", "coveragePattern": "m.dulo\\s+\\S+:\\s+(\\d+(?:\\.\\d+)?)%" } }')
$r = Invoke-Check 'quality.ps1' @('-Id', 'S1', '-Root', $p)
Check 'v3.65.1: Q11 com coveragePattern — o menor percentual entre os módulos (85 de 3), com a linha do módulo' $r 0 @('Q11 ok: .*— 85 % medido × limiar 80 % · exit 0 · o menor de 3 \(''m.dulo raiz: 85\.00%''\)')
Put $p '.team-project/guards.json' ('{ "quality": { "coverage": "Write-Output \"' + ($covMods -replace '85\.00', '72.40') + '\"", "coveragePattern": "m.dulo\\s+\\S+:\\s+(\\d+(?:\\.\\d+)?)%" } }')
$r = Invoke-Check 'quality.ps1' @('-Id', 'S1', '-Root', $p)
Check 'v3.65.1: Q11 com coveragePattern — um módulo abaixo do limiar reprova, mesmo com o primeiro acima' $r 1 @('Q11 falhou: .*— 72\.4 % medido × limiar 80 % .*o menor de 3 \(''m.dulo raiz: 72\.40%''\).*abaixo do limiar')
# v3.65.1 (garden S6-F11, D-19): Q9 conta só o marcador, não a palavra em caixa alta no meio da frase.
$pt = Join-Path $tmp 'quality-todo'; New-Project $pt
Put $pt '.team-project/guards.json' '{}'
Put $pt 'src/a.ts' "// app.module.ts) e cobre TODO o app de uma vez`n// adicionar a opção ANO TODO`" — culturas`nexport const TODOS = 1`n"
Put $pt 'src/b.ts' "const x = 1 // TODO melhorar`n/* FIXME vazamento */`n * TODO no bloco`n// pendente: TODO(lote) e FIXME: aqui`n# TODO em script`n// TODO T-041 com ID`n"
$r = Invoke-Check 'quality.ps1' @('-Id', 'S1', '-Root', $pt)
Check 'v3.65.1: Q9 — "cobre TODO o app", "ANO TODO" e TODOS não contam; o marcador (//, /*, *, #, TODO(, FIXME:) conta; com ID não' $r 1 @('Q9 falhou: .*— 5 sem ID: src/b\.ts:1, src/b\.ts:2, src/b\.ts:3, src/b\.ts:4, src/b\.ts:5', '^(?![\s\S]*src/a\.ts)')
Put $pt '.team-project/guards.json' '{ "quality": { "todoPattern": "\\bXXX\\b" } }'
$r = Invoke-Check 'quality.ps1' @('-Id', 'S1', '-Root', $pt)
Check 'v3.65.1: Q9 — quality.todoPattern troca a regra do marcador' $r 0 @('Q9 ok')

# Capacidade (kanban.ps1 -Capacity e o R4 do close).
$sbv = Join-Path $p '.team-project/sprints/1/sprint-backlog.md'
Edit-File $sbv '| **Aprovado por** | Stakeholder |' "| **Aprovado por** | Stakeholder |`n| **Capacidade** | 1,5 · média entregue nos 3 sprints anteriores: 1,5 |`n| **Somatório planejado** | 1 — dentro da capacidade |"
$r = Invoke-Check 'kanban.ps1' @('-Capacity', '-Add', '0.5', '-Root', $p)
Check 'v3.57.3 item 4: kanban -Capacity -Add traz a conta (capacidade, planejado, quadro, com a entrada) e diz ACIMA' $r 0 @('capacidade 1,5 d · planejado na Planning 1 d · no quadro 2 d \(\+33 %\) · com a entrada \(\+0,5 d\): 2,5 d \(\+67 %\) — ACIMA da capacidade')
Edit-File $sbv '| **Capacidade** | 1,5 ·' '| **Capacidade** | 5 ·'
$r = Invoke-Check 'kanban.ps1' @('-Capacity', '-Add', '1', '-Root', $p)
Check 'v3.57.3 item 4: dentro da capacidade, "cabe"' $r 0 @('capacidade 5 d .*com a entrada \(\+1 d\): 3 d \(-40 %\) — cabe na capacidade')
Edit-File $sbv '| **Capacidade** | 5 ·' '| **Capacidade** | 1,5 ·'
[System.IO.File]::WriteAllText($sbv, [regex]::Replace([System.IO.File]::ReadAllText($sbv, $utf8), '(\| O que saiu para caber \| Data \|\r?\n\|---\|---\|---\|---\|---\|)', "`$1`n| T-041 | H-014 | GAP que bloqueia a H-014 | T-099 | 2026-09-02 |"), $utf8)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'v3.57.3 item 4: R4 com entrada fora da Planning traz a conta quando o quadro passa da capacidade (informa, não reprova)' @{ Code = 0; Out = $r.Out } 0 @('\| R4 \| ok \| .*entrada fora da Planning declarada; o quadro passa da capacidade: capacidade 1,5 d .*no quadro 2 d \(\+33 %\)')

# v3.59.1 (sprint 6 do garden: suíte de 10–25 min, 35 rodadas em 13 Tasks) — full: comando curto que falha poupa a suíte;
# full de novo na mesma árvore roda só o que não saiu verde (mesmo comando); -Fresh roda tudo.
$pf = Join-Path $tmp 'v3591-full'; New-Project $pf
$ErrorActionPreference = 'Continue'
& git -C $pf init -q 2>$null; Put $pf '.gitignore' ".team-project/`n"; Put $pf 'README.md' "x`n"
& git -C $pf add -A 2>$null; & git -C $pf -c user.email=t@t -c user.name=t commit -qm init 2>$null
$ErrorActionPreference = 'Stop'
$ran = (Join-Path $pf '.team-project/ran.txt') -replace '\\', '/'
$mk = { param([string]$lint) '{ "verify": { "build": "Add-Content -LiteralPath ''' + $ran + ''' build; Write-Output ok", "lint": "' + $lint + '", "suite": "Add-Content -LiteralPath ''' + $ran + ''' suite; Write-Output \"Tests: 3 passed\"", "coverage": "Add-Content -LiteralPath ''' + $ran + ''' coverage; Write-Output \"All files | 90 %\"" } }' }
Put $pf '.team-project/guards.json' (& $mk ('Add-Content -LiteralPath ''' + $ran + ''' lint; Write-Output erro; exit 1'))
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pf)
$log = (Get-Content -LiteralPath $ran -Encoding UTF8) -join ','
Check 'v3.59.1 item 3: lint reprovado → suíte e cobertura não rodam (o full já está vermelho)' @{ Code = $r.Code; Out = "$($r.Out) ran=$log" } 1 @('lint: exit 1', 'não rodou: suite, coverage — lint falhou antes', 'ran=build,lint$')
Put $pf '.team-project/guards.json' (& $mk ('Add-Content -LiteralPath ''' + $ran + ''' lint2; Write-Output ok'))
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pf)
$log = (Get-Content -LiteralPath $ran -Encoding UTF8) -join ','
Check 'v3.59.1 item 3: mesma árvore, lint corrigido → build reaproveitado (mesmo comando), lint, suíte e cobertura rodam' @{ Code = $r.Code; Out = "$($r.Out) ran=$log" } 0 @('tudo exit 0', 'build: exit 0 .*reaproveitado da rodada de', 'mesma árvore do full de .*: build reaproveitado', 'ran=build,lint,lint2,suite,coverage$')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pf)
$log = (Get-Content -LiteralPath $ran -Encoding UTF8) -join ','
Check 'v3.59.1 item 3: full de novo na mesma árvore, tudo verde → nada roda de novo' @{ Code = $r.Code; Out = "$($r.Out) ran=$log" } 0 @('tudo exit 0', 'build, lint, suite, coverage reaproveitado', 'ran=build,lint,lint2,suite,coverage$')
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'check', '-Root', $pf)
Check 'v3.59.1 item 3: o check aceita o full reaproveitado' $r 0 @()
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Fresh', '-Root', $pf)
$log = (Get-Content -LiteralPath $ran -Encoding UTF8) -join ','
Check 'v3.59.1 item 3: -Fresh roda tudo' @{ Code = $r.Code; Out = "$($r.Out) ran=$log" } 0 @('tudo exit 0', 'ran=build,lint,lint2,suite,coverage,build,lint2,suite,coverage$', '^(?![\s\S]*reaproveitado)')
Put $pf 'src/novo.ts' "x`n"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'full', '-Root', $pf)
Check 'v3.59.1 item 3: árvore mudou → roda tudo, sem reaproveitar' $r 0 @('tudo exit 0', '^(?![\s\S]*reaproveitado)')

# v3.59.2 (R12; garden: consolidação do sprint 5 "feita" sem commit e pedidos ao PO nunca aplicados) — o next confere no git
# os documentos do Arquiteto, dispara os donos dos pedidos uma vez cada, faz o commit próprio e leva o que faltou à Review.
$pd = Join-Path $tmp 'v3592-docs'; New-Project $pd
$ErrorActionPreference = 'Continue'
& git -C $pd init -q 2>$null; Put $pd '.gitignore' ".team-project/`n"; Put $pd 'docs/sdd/api.md' "# API`n"; Put $pd 'docs/sdd/requirements.md' "# Req`n"; Put $pd 'docs/sdd/status.md' "# Status`n"
& git -C $pd add -A 2>$null; & git -C $pd -c user.email=t@t -c user.name=t commit -qm init 2>$null
& git -C $pd config user.email t@t 2>$null; & git -C $pd config user.name t 2>$null
$ErrorActionPreference = 'Stop'
$sbd = Join-Path $pd '.team-project/sprints/1/sprint-backlog.md'
Edit-File $sbd "| $($e.qa) T-041 |" "| $($e.ok) T-041 |"; Edit-File $sbd "| $($e.todo) T-041a |" "| $($e.ok) T-041a |"
Put $pd '.team-project/quality/1/S1/result.json' '{"tree":null}'
Put $pd '.team-project/sprints/1/validation.md' "# Validação`n`n**Veredito:** $($e.ok) aprovado — 2026-09-05`n"
(Get-Item -LiteralPath (Join-Path $pd '.team-project/quality/1/S1/result.json')).LastWriteTime = (Get-Date).AddHours(-1)
# O sprint "começa" daqui a 1 h: o commit init fica antes dele, então só conta a alteração pendente no disco.
$rld = Join-Path $pd '.team-project/sprints/1/run-log.md'
Put $pd '.team-project/sprints/1/run-log.md' ("# Run-log`n`n| Data | Item | O quê | Por quê | Ref |`n|---|---|---|---|---|`n| " + (Get-Date).AddHours(1).ToString('yyyy-MM-dd HH:mm') + " | T-041 | início | — | — |`n")
$cd = Join-Path $pd '.team-project/sprints/1/docs-consolidation.md'
Put $pd '.team-project/sprints/1/docs-consolidation.md' "**Estado:** feita`n`n# Sprint 1`n`n- api.md atualizado`n"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pd)
Check 'v3.59.2: consolidação "feita" fora do modelo → Arquiteto reescreve no modelo (uma vez)' $r 0 @('PRÓXIMA AÇÃO: consolidação fora do modelo', 'team:architect', 'roles/architect/templates/docs-consolidation\.md')
Put $pd '.team-project/sprints/1/docs-consolidation.md' ("**Estado:** feita`n`n# Sprint 1`n`n## Aplicado pelo Arquiteto`n`n| Documento | O que mudou | Task |`n|---|---|---|`n| ``docs/sdd/api.md`` §2 | linha nova | T-041 |`n`n## Pedidos aos donos`n`n| Documento | O que mudar | Origem | Dono |`n|---|---|---|---|`n| ``docs/sdd/requirements.md`` RF-1 (:3) | vários canteiros | T-041 | PO |`n| ``docs/sdd/status.md`` | retrato | — | SM |`n| ``.team-project/README.md`` | §7 | — | SM |`n`n## Sem mudança`n`n| Task | Motivo |`n|---|---|`n| T-041a | só teste |`n")
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pd)
Check 'v3.59.2: documento do Arquiteto sem mudança no disco nem commit no sprint → Arquiteto de novo (aplicar ou mover para Sem mudança)' $r 0 @('consolidação declarada sem mudança no disco — docs/sdd/api\.md', 'team:architect', "Sem mudança' com o motivo")
Put $pd 'docs/sdd/api.md' "# API`n`nlinha nova`n"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pd)
Check 'v3.59.2: com o documento do Arquiteto alterado, os pedidos vão ao PO (só os documentos dele; .team-project fora)' $r 0 @('pedidos da consolidação ao dono PO — docs/sdd/requirements\.md', 'team:product-owner', '^(?![\s\S]*\.team-project/README)')
Put $pd 'docs/sdd/requirements.md' "# Req`n`nRF-1 vários canteiros`n"
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pd)
Check 'v3.59.2: depois do PO, o SM com o documento dele' $r 0 @('pedidos da consolidação ao dono SM — docs/sdd/status\.md', 'team:scrum-master')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pd)
$ErrorActionPreference = 'Continue'; $glog = (& git -C $pd log -1 --format='%s|%h' 2>$null); $gfiles = (& git -C $pd show --name-only --format= HEAD 2>$null) -join ','; $ErrorActionPreference = 'Stop'
Check 'v3.59.2: SM não aplicou → commit próprio só com os documentos que mudaram, pendência no formulário da Review e no run-log' @{ Code = $r.Code; Out = "$($r.Out)`nLOG=$glog`nFILES=$gfiles`nRL=" + [System.IO.File]::ReadAllText($rld, $utf8) } 0 @('commit da consolidação: [0-9a-f]{7,} \(2 documento\(s\): docs/sdd/api\.md, docs/sdd/requirements\.md\)', 'LOG=docs\(sdd\): consolidação dos documentos vivos do sprint 1\|', 'FILES=docs/sdd/api\.md,docs/sdd/requirements\.md\r?\n', 'PRÓXIMA AÇÃO: fim da fila', 'documentos vivos com pendência \(R12\).*pedido ao SM não aplicado: docs/sdd/status\.md', 'RL=[\s\S]*\| S1 \| commit da consolidação[\s\S]*\| S1 \| documentos vivos: pendência que vai à Review')
$r = Invoke-Check 'run.ps1' @('next', '-Root', $pd)
$rlTxt = [System.IO.File]::ReadAllText($rld, $utf8)
Check 'v3.59.2: next de novo — sem commit nem linha de run-log repetidos' @{ Code = $r.Code; Out = "$($r.Out)`nN=" + ([regex]::Matches($rlTxt, '\| S1 \| commit da consolidação')).Count + '/' + ([regex]::Matches($rlTxt, 'pendência que vai à Review')).Count } 0 @('PRÓXIMA AÇÃO: fim da fila', '^(?![\s\S]*commit da consolidação:)', '^(?![\s\S]*declarado pelo Arquiteto)', 'pedido ao SM não aplicado', 'N=1/1')

# ---------- v3.61.0 — sprint 0 (R35): foundation.ps1, G25 no C2 e a R15 dos documentos aceitos no sprint 0 ----------
$f0 = Join-Path $tmp 'sprint0'
Put $f0 '.team-project/README.md' ("# Ctx`n`n## 2. Situação atual`n`n| | |`n|---|---|`n| **Sprint corrente** | **<n>** — x |`n`n**Diretório de produto:** ``docs/```n" -replace "`n", "`r`n")   # CRLF: o README de projeto no Windows
Put $f0 'src/app.ts' 'export const a = 1;'
Put $f0 'docs/sdd/01-requirements.md' "# 01`n`n### RF-001 — Cadastrar canteiro`n`n**Critério de aceite**`n- [ ] Dado x`n"
$r = Invoke-Check 'foundation.ps1' @('assess', '-Root', $f0)
Check 'v3.61.0 assess: 00 ausente, 01 fora do padrão (RF sem Como verificar), ambiente ausente, tipo retomada' $r 0 @('SDD-00 · docs/sdd/00-overview-objectives\.md \| ausente', "SDD-01 · docs/sdd/01-requirements\.md \| fora do padrão \| .*RF-001 sem 'Como verificar'", 'AMB-verify .*\| ausente', 'Tipo: retomada — .*src/app\.ts')
$r = Invoke-Check 'foundation.ps1' @('gate', '-Root', $f0)
Check 'v3.61.0 gate sem a linha Sprint 0 (projeto anterior): ok' $r 0 @('gate: ok .*anterior à v3\.61\.0')
$r = Invoke-Check 'foundation.ps1' @('init', '-Root', $f0)
$rd = [System.IO.File]::ReadAllText((Join-Path $f0 '.team-project/README.md'), $utf8)
Check 'v3.61.0 init: 7 documentos + ambiente no quadro; README §2 → exigido logo abaixo do Sprint corrente' @{ Code = $r.Code; Out = "$($r.Out)`nRD=$rd" } 0 @('criado com 10 item\(ns\) \(retomada\)', 'Sprint corrente\*\* \| \*\*<n>\*\* — x \|\r?\n\| \*\*Sprint 0 \(fundação\)\*\* \| exigido — em andamento')
$r = Invoke-Check 'foundation.ps1' @('gate', '-Root', $f0)
Check 'v3.61.0 gate com o sprint 0 exigido: exit 1' $r 1 @('gate: bloqueado — sprint 0 exigido')
$r = Invoke-Check 'foundation.ps1' @('next', '-Root', $f0)
Check 'v3.61.0 next sem escopo: formulário do escopo, nenhum papel disparado' $r 0 @('PRÓXIMA AÇÃO: formulário do escopo', 'foundation\.ps1 approve -Areas', '^(?![\s\S]*Agent:)')
$r = Invoke-Check 'foundation.ps1' @('approve', '-Areas', 'Canteiros', '-By', 'Stakeholder', '-Root', $f0)
$r = Invoke-Check 'foundation.ps1' @('next', '-Root', $f0)
Check 'v3.61.0 next: S0-01 → 🟨 e o PO disparado com o modelo do SDD e a régua do item' $r 0 @("S0-01 → $($e.build) — PO escreve docs/sdd/00-overview-objectives\.md", 'team:product-owner', 'deliverables/sdd/00-overview-objectives\.md', 'COMO ELE É HOJE', 'check -Item S0-01')
$r = Invoke-Check 'foundation.ps1' @('next', '-Root', $f0)
Check 'v3.61.0 next: o PO voltou sem o documento → devolvido 1/3 com a falha da régua' $r 0 @('S0-01 devolvido \(1/3\) — régua: .*00-overview-objectives\.md ausente', 'team:product-owner')
$ficha = (1..22 | ForEach-Object { "| V$_ | item | valor $_ |" }) -join "`n"
Put $f0 'docs/sdd/00-overview-objectives.md' "# SDD`n`n## OBJ-001 — Cuidar da horta`n`n**Como saberemos que foi atingido:** regas em dia.`n"
Put $f0 'docs/sdd/01-requirements.md' "# 01`n`n### RF-001 — Cadastrar canteiro`n`n**Critério de aceite**`n- [ ] Dado x`n`n**Como verificar**`nteste`n"
Put $f0 'docs/sdd/02-flows-and-roles.md' "# 02`n`n# 2. Papéis`n`n## 2.1 Jardineiro`n**Responsabilidade:** cuida dos canteiros`n`n# 3. Fluxos`n`n## 3.1 Fluxo principal`n**Pontos de falha e retomada:** offline.`n"
Put $f0 'docs/sdd/03-architecture.md' "# 03`n`n## Índice`n- x`n`n## P-001 — Offline primeiro`nRegra.`n**Consequência observável:** sem chamada de rede.`n`n# 2b. Ficha de Vinculação de Stack`n`n| # | Item | Valor |`n|---|---|---|`n$ficha`n"
Put $f0 'docs/sdd/04-data-model.md' "# 04`n`n## 1. Entidades principais`nCanteiro.`n`n## 2. Relacionamentos`nnenhum`n"
Put $f0 'docs/sdd/05-api-model.md' "# 05`n`nNão se aplica — o app é offline, sem API.`n"
Put $f0 'docs/sdd/06-changelog.md' "# 06`n`n## v1.0 (2026-11-16)`n**Motivação:** sprint 0`n"
Put $f0 'docs/sdd/README.md' "# SDD`n"
$r = Invoke-Check 'foundation.ps1' @('check', '-Item', 'S0-02', '-Root', $f0)
Check 'v3.61.0 check -Item: só a régua do item; o 01 cita a área do escopo' $r 1 @('\| SDD-01 \| falhou \| .*área sem menção: Canteiros', '^(?![\s\S]*SDD-00)')
Put $f0 'docs/sdd/01-requirements.md' "# 01`n`n### RF-001 — Cadastrar canteiro (Canteiros)`n`n**Critério de aceite**`n- [ ] Dado x`n`n**Como verificar**`nteste`n"
Put $f0 'docs/sdd/02-flows-and-roles.md' "# 02`n`n# 2. Papéis`n`n## 2.1 Jardineiro`n**Responsabilidade:** cuida dos Canteiros`n`n# 3. Fluxos`n`n## 3.1 Fluxo principal`n**Pontos de falha e retomada:** offline.`n"
Put $f0 'docs/sdd/03-architecture.md' "# 03`n`n## Índice`n- x`n`n## P-001 — Offline primeiro`nRegra.`n**Consequência observável:** sem chamada de rede.`n`n# 2b. Ficha de Vinculação de Stack`n`n| # | Item | Valor |`n|---|---|---|`n$($ficha -replace '\| V7 \| item \| valor 7 \|', '| V7 | item | <ferramenta + comando> |')`n"
$r = Invoke-Check 'foundation.ps1' @('check', '-Root', $f0)
Check 'v3.61.0 check completo: Ficha com marcador do modelo reprova o 03; ambiente e conformidade pendentes' $r 1 @('\| SDD-00 \| ok', '\| SDD-03 \| falhou \| .*Ficha com linha sem valor .*V7', '\| SDD-05 \| ok', '\| AMB-verify \| falhou', '\| QA-conformidade \| falhou', '\| itens \| falhou')
Put $f0 'docs/sdd/03-architecture.md' "# 03`n`n## Índice`n- x`n`n## P-001 — Offline primeiro`nRegra.`n**Consequência observável:** sem chamada de rede.`n`n# 2b. Ficha de Vinculação de Stack`n`n| # | Item | Valor |`n|---|---|---|`n$ficha`n"
$r = Invoke-Check 'foundation.ps1' @('next', '-Root', $f0)
Check 'v3.61.0 next: régua do item ok → 🟪 e o QA disparado com o modelo da conformidade' $r 0 @("S0-01 → $($e.qa)", 'team:quality-assurance', 'templates/conformance\.md')
Put $f0 '.team-project/sprints/0/evidence/conformance.md' "# Conformidade`n`n| Documento | Régua | Fidelidade | Veredito |`n|---|---|---|---|`n| 00-overview-objectives.md | ok | RF-001 sem código | $([char]::ConvertFromUtf32(0x274C)) |`n"
$r = Invoke-Check 'foundation.ps1' @('next', '-Root', $f0)
Check 'v3.61.0 next: QA ❌ → volta ao dono (🟨) com o ponteiro dos achados' $r 0 @("S0-01 devolvido \(2/3\) — QA: 00-overview-objectives\.md", 'team:product-owner', 'evidence/conformance\.md')
$okRows = @('00-overview-objectives', '01-requirements', '02-flows-and-roles', '03-architecture', '04-data-model', '05-api-model', '06-changelog') | ForEach-Object { "| $_.md | ok | ok | $($e.ok) |" }
Start-Sleep -Seconds 2
Put $f0 '.team-project/sprints/0/evidence/conformance.md' ("# Conformidade`n`n| Documento | Régua | Fidelidade | Veredito |`n|---|---|---|---|`n" + ($okRows -join "`n") + "`n")
$out = ''; for ($k = 0; $k -lt 16; $k++) { $r = Invoke-Check 'foundation.ps1' @('next', '-Root', $f0); $out += $r.Out; if ($r.Out -match 'o Arquiteto escreve o plano do ambiente') { break } }
Check 'v3.61.0 next em laço: os 7 documentos fecham com régua + QA, e o ambiente começa pelo plano do Arquiteto' @{ Code = $r.Code; Out = $out } 0 @("S0-07 $($e.ok) — QA $($e.ok) em 06-changelog\.md", "S0-08 → $($e.plan) — o Arquiteto escreve o plano do ambiente", 'team:architect', 'foundation-env-plan\.md')
Put $f0 '.team-project/sprints/0/plan/S0-08-ambiente.md' "# Plano`n`n**Arquivos tocados:** ``package.json```n`n## guards.json proposto`n`n{ }`n"
$r = Invoke-Check 'foundation.ps1' @('next', '-Root', $f0)
$at = [System.IO.File]::ReadAllText((Join-Path $f0 '.team-project/.active-task'), $utf8)
Check 'v3.61.0 next: plano → 🟨, escopo do dev gravado (G9) e o dev disparado' @{ Code = $r.Code; Out = "$($r.Out)`nAT=$at" } 0 @("S0-08 → $($e.build) — o dev executa", 'team:developer', 'AT=\{"trilha":"sprint","id":"S0-08","plano":".team-project/sprints/0/plan/S0-08-ambiente\.md"\}')
Put $f0 '.team-project/sprints/0/delivery/S0-08.md' "# Entrega`nok`n"
$r = Invoke-Check 'foundation.ps1' @('next', '-Root', $f0)
Check 'v3.61.0 next: com a entrega e a régua ainda reprovada, a sessão grava o guards.json proposto (uma vez)' $r 0 @("a sessão grava em \.team-project/guards\.json o bloco '## guards\.json proposto'")
Put $f0 '.team-project/guards.json' '{ "verify": { "suite": "npm test", "build": "npm run build" } }'
$r = Invoke-Check 'foundation.ps1' @('next', '-Root', $f0)
Check 'v3.61.0 next: AMB-verify ok → S0-08 ✅, escopo do dev apagado, baseline ao QA' @{ Code = $r.Code; Out = "$($r.Out)`nAT=$(Test-Path (Join-Path $f0 '.team-project/.active-task'))" } 0 @("S0-08 $($e.ok) — verify\.suite = npm test", "S0-09 → $($e.build) — o QA prova o ambiente", '/qa baseline', 'AT=False')
Put $f0 '.team-project/quality-assurance/baseline.md' "# Baseline`n"
Put $f0 '.team-project/quality-assurance/scenarios/SC-001.md' "# SC-001`n`n## Histórico de execuções`n| Data | Task/Sprint | Resultado | Forma | Evidência |`n|---|---|---|---|---|`n| 2026-11-16 | S0-10 / sprint 0 | $($e.ok) passou | script | npm test |`n"
$r = Invoke-Check 'foundation.ps1' @('next', '-Root', $f0); $r = Invoke-Check 'foundation.ps1' @('next', '-Root', $f0)
Check 'v3.61.0 next: baseline e cenário do sprint 0 → todos prontos, review' $r 0 @('todos os itens prontos — /clear e /sm sprint0 review')
$r = Invoke-Check 'foundation.ps1' @('close', '-Root', $f0)
Check 'v3.61.0 close sem -By: erro de uso, nada gravado' $r 2 @('close exige -By')
$r = Invoke-Check 'foundation.ps1' @('close', '-By', 'Stakeholder', '-Root', $f0)
$rd = [System.IO.File]::ReadAllText((Join-Path $f0 '.team-project/README.md'), $utf8)
Check 'v3.61.0 close: régua completa ok, aceite gravado e README §2 → concluído com as áreas' @{ Code = $r.Code; Out = "$($r.Out)`nRD=$rd" } 0 @('\| QA-conformidade \| ok', '\| itens \| ok \| todos', 'RD=[\s\S]*\| \*\*Sprint 0 \(fundação\)\*\* \| concluído em \d{4}-\d{2}-\d{2} — áreas documentadas: Canteiros')
$r = Invoke-Check 'foundation.ps1' @('gate', '-Root', $f0)
Check 'v3.61.0 gate depois do aceite: ok' $r 0 @('gate: ok — sprint 0 concluído')
$r = Invoke-Check 'foundation.ps1' @('area', '-Add', 'Alertas', '-By', 'Stakeholder', '-Root', $f0)
$r2 = Invoke-Check 'foundation.ps1' @('gate', '-Root', $f0)
$rd = [System.IO.File]::ReadAllText((Join-Path $f0 '.team-project/README.md'), $utf8)
Check 'v3.61.0 area: reabre só a área (4 itens), o portão segue aberto e o README (CRLF) tem a linha uma vez só' @{ Code = $r.Code; Out = "$($r.Out)`n$($r2.Out)`nN=" + ([regex]::Matches($rd, 'Sprint 0 \(fundação\)')).Count + " LF=" + ([regex]::Matches($rd, "(?<!`r)`n")).Count } 0 @("área 'Alertas' reaberta com 4 item\(ns\)", 'gate: ok — sprint 0 concluído .*área Alertas em documentação', 'N=1 LF=0')
# Documento com o nome do projeto (sem 0n-) e requisitos em lista, com ID por área (o formato do garden).
$f2 = Join-Path $tmp 'sprint0-nomes'
Put $f2 '.team-project/README.md' "# Ctx`n`n**Diretório de produto:** ``docs/```n"
Put $f2 'docs/sdd/requirements.md' "# Requisitos`n`n## 4. Requisitos funcionais`n`n- **RF-CAN-01** — CRUD de canteiro`n- **RF-CAN-02** — Visão geral`n"
Put $f2 'docs/sdd/architecture.md' "# Arquitetura`n`n## Índice`n`n| V12 | gate | ``npm run gate -- --diff <commit-base>`` |`n"
$r = Invoke-Check 'foundation.ps1' @('assess', '-Root', $f2)
Check 'v3.61.0 assess: acha o documento pelo nome do projeto, avisa o nome do modelo e conta os RF em lista sem seção' $r 0 @('SDD-01 · docs/sdd/requirements\.md \| fora do padrão \| .*nome do projeto.*01-requirements\.md.*2 requisito\(s\) em lista \(RF-CAN-01…\), sem seção própria', 'SDD-03 · docs/sdd/architecture\.md \| fora do padrão \| .*Ficha', '^(?![\s\S]*Ficha com linha sem valor[^|]*V12)')
# C2: R35 e a R15 dos documentos aceitos no sprint 0.
$r = Invoke-Check 'project.ps1' @('-Root', $f0)
Check 'v3.61.0 C2: R35 ok com o sprint 0 concluído' $r 0 @('\| R35 \| ok \| sprint 0 concluído')
$f1 = Join-Path $tmp 'sprint0-pulado'; New-Project $f1
Edit-File (Join-Path $f1 '.team-project/README.md') '| **Sprint corrente** | **1** — exportar o resultado' "| **Sprint 0 (fundação)** | exigido — em andamento desde 2026-08-30 |`n| **Sprint corrente** | **1** — exportar o resultado"
$r = Invoke-Check 'project.ps1' @('-Root', $f1)
Check 'v3.61.0 C2: sprint 1 com pacote aprovado e o sprint 0 exigido → R35 falhou' $r 0 @("\| R35 \| falhou \| sprint 1 com pacote aprovado e o sprint 0 'exigido")
$r = Invoke-Check 'foundation.ps1' @('dispense', '-By', 'Stakeholder', '-Because', 'documentação do cliente já auditada', '-Root', $f1)
$r = Invoke-Check 'project.ps1' @('-Root', $f1)
Check 'v3.61.0 C2: sprint 0 dispensado pelo stakeholder → R35 ok com o risco aceito' $r 0 @('\| R35 \| ok \| sprint 0 dispensado em .* por Stakeholder — documentação do cliente já auditada')

# v3.62.3 (sprint 6 do projeto piloto, Q-S6d): o executor de cenários do projeto roda PELO accept.ps1 — "**Aceite:** comando"
# no plano. Executor falso neutro (tools/fake.ps1): imprime "<SC-ID> PASSOU|FALHOU <detalhe>" e grava a captura em {out}.
$fakeExec = @'
param([string]$Scn, [string]$Out, [string]$Only = '')
$c = $env:FAKE_CASE
$ids = if ($Only) { @($Only -split ',') } else { @([regex]::Matches([IO.File]::ReadAllText($Scn), '(?m)^scenario\s+(\S+)') | ForEach-Object { $_.Groups[1].Value }) }
if ($c -eq 'uso') { Write-Output 'uso: fake --cenarios <arquivo>'; exit 2 }
if ($c -eq 'amb' -and $Scn -like '*b.scn') { Write-Output 'emulador fora do adb'; exit 4 }
$r2 = $Out -like '*-r2'; $fail = $false; $k = 0
foreach ($i in $ids) {
    $k++
    if ($c -eq 'semlinha' -and $k -eq 2) { continue }
    if ($c -eq 'falha' -and $k -eq 1 -and -not $r2) { Write-Output "$i FALHOU tag nao encontrada: x"; New-Item -ItemType File -Force (Join-Path $Out "$i-falha.png") | Out-Null; $fail = $true; continue }
    if ($c -eq 'falha2' -and $k -eq 1) { Write-Output "[$i] FALHOU  -> sempre"; $fail = $true; continue }
    Write-Output "$i PASSOU"; New-Item -ItemType File -Force (Join-Path $Out "$i-final.png") | Out-Null
}
if ($fail) { exit 1 }; exit 0
'@
$pa = Join-Path $tmp 'v3623-accept'; New-Project $pa
Put $pa 'tools/fake.ps1' $fakeExec
Put $pa '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-001 Abre`nlaunch`nassert-exists a`n`nscenario SC-002 Conta`nlaunch`nassert-exists b`n"
Put $pa '.team-project/quality-assurance/scenarios/b.scn' "scenario SC-003 Fecha`nlaunch`nassert-exists c`n"
$port = Get-Random -Minimum 47100 -Maximum 47900
Put $pa 'tools/srv.js' "require('http').createServer((q, s) => s.end('ok')).listen(Number(process.argv[2]), '127.0.0.1');"
Put $pa '.team-project/guards.json' ('{ "targets": { "web": { "url": "http://127.0.0.1:' + $port + '", "start": "node tools/srv.js ' + $port + '", "startTimeoutSec": 30 } } }')
Edit-File (Join-Path $pa '.team-project/sprints/1/plan/T-041-export.md') '# Plano de Implementação — T-041 Endpoint de exportação' ("# Plano de Implementação — T-041 Endpoint de exportação`n`n**Aceite:** comando — ``powershell -NoProfile -ExecutionPolicy Bypass -File tools/fake.ps1 -Scn {scn} -Out {out} -Only {only}``")
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-ParseOnly', '-Root', $pa)
Check 'v3.62.3 accept -ParseOnly: o **Aceite:** comando do plano da Task aparece como o executor' $r 0 @('3 cenário\(s\) válidos em 2 arquivo', 'executor do projeto \(plano \.team-project/sprints/1/plan/T-041-export\.md\): `powershell -NoProfile -ExecutionPolicy Bypass -File tools/fake\.ps1 -Scn \{scn\} -Out \{out\} -Only \{only\}`')
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-ParseOnly', '-Command', 'node tools/prova.mjs --saida {out}', '-Root', $pa)
Check 'v3.62.3 accept -Command sem {scn}: exit 2 antes de tocar no alvo' $r 2 @('não recebe o arquivo de cenários — o comando leva \{scn\}')
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-ParseOnly', '-Command', 'git push; node tools/prova.mjs {scn}', '-Root', $pa)
Check 'v3.62.3 accept -Command com push: exit 2 (o run nunca roda)' $r 2 @('trecho que o run nunca roda: git push \(push\)')
$env:FAKE_CASE = 'semlinha'
$r = Invoke-Check 'accept.ps1' @('-Task', 'T-041', '-Root', $pa)
$env:FAKE_CASE = $null
$ad = Join-Path $pa '.team-project/accept/1/T-041'
$rj = if (Test-Path -LiteralPath (Join-Path $ad 'result.json')) { [System.IO.File]::ReadAllText((Join-Path $ad 'result.json'), $utf8) -replace '\s+', ' ' } else { '' }
$pj = if (Test-Path -LiteralPath (Join-Path $ad 'progress.json')) { [System.IO.File]::ReadAllText((Join-Path $ad 'progress.json'), $utf8) -replace '\s+', ' ' } else { '' }
Check 'v3.62.3 accept pelo executor do projeto: sobe o alvo pelo reparo, roda um .scn por vez, cenário sem linha = FALHOU (exit 1), result.json/progress.json de sempre, trava devolvida' @{ Code = $r.Code; Out = "$($r.Out)`nRJ=$rj`nPJ=$pj`nLOCK=$(Test-Path (Join-Path $pa '.team-project/.target-lock'))" } 1 @('accept: executor do projeto — a \(2 cenário\(s\)\)', '\[SC-001\] PASSOU  Abre', '\[SC-002\] FALHOU  Conta  -> o executor do projeto não devolveu linha para este cenário \(exit 0; log \.team-project/accept/1/T-041/cmd/a\.log\)', '\[SC-003\] PASSOU  Fecha', 'executor do projeto · 2 de 3 cenário\(s\) passaram', 'RJ=.*"executor": "comando".*"commandFrom": "plano \.team-project/sprints/1/plan/T-041-export\.md".*"passed": 2, "total": 3', 'RJ=.*cmd/a/SC-001-final\.png', 'RJ=.*"runs": \[ \{ "file": "\.team-project/quality-assurance/scenarios/a\.scn", "only": "SC-001,SC-002", "exit": 0', 'PJ=.*"total": 3, "passed": 2, "failed": 1', 'LOCK=False')
# As funções do accept com o comando falso direto (sem alvo): repetição do que falhou, ambiente (exit 4) e uso (exit 2).
$hs6 = Join-Path $tmp 'accept-comando.ps1'
[System.IO.File]::WriteAllText($hs6, @'
param([string]$Accept, [string]$Lib, [string]$Root, [string]$Case)
$ErrorActionPreference = 'Stop'
. $Lib
$utf8 = New-Object System.Text.UTF8Encoding($false); $Task = 'T-041'; $NoRetry = $false; $NoRepair = $true; $Apk = ''
$ast = [System.Management.Automation.Language.Parser]::ParseFile($Accept, [ref]$null, [ref]$null)
foreach ($f in $ast.FindAll({ param($a) $a -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) { if ($f.Name -in 'Invoke-AcceptCommand', 'Invoke-AcceptCommandRun', 'Find-AcceptShot', 'Write-AcceptProgress', 'Get-AcceptReuse', 'New-ReusedRow', 'Get-ScenarioHash', 'Get-AcceptNoRetryKind', 'Add-AcceptStepTime', 'Get-AcceptTiming', 'Format-AcceptTiming', 'Format-AcceptFresh', 'Test-AcceptFresh', 'Write-AcceptStale') { . ([scriptblock]::Create($f.Extent.Text)) } }
$script:Tgt = 'web'; $script:Serial = ''; $script:Pkg = ''
function Stop-WebServer { }
$env:FAKE_CASE = $Case
$script:ExtCmd = 'powershell -NoProfile -ExecutionPolicy Bypass -File tools/fake.ps1 -Scn {scn} -Out {out} -Only {only}'; $script:ExtFrom = 'teste'
$a = Join-Path $Root 'cen a.scn'; $b = Join-Path $Root 'b.scn'
$blocks = @(@{ id = 'SC-1'; title = 'um'; steps = @(); file = $a }, @{ id = 'SC-2'; title = 'dois'; steps = @(); file = $a }, @{ id = 'SC-3'; title = 'tres'; steps = @(); file = $b })
$d = Join-Path $Root '.team-project/accept/1/T-041'; New-Item -ItemType Directory -Force $d | Out-Null
$code = Invoke-AcceptCommand $d $blocks $null | Select-Object -Last 1
"CODE=$code"
'RESULT=' + ([System.IO.File]::ReadAllText((Join-Path $d 'result.json')) -replace '\s+', ' ')
'@, (New-Object System.Text.UTF8Encoding($true)))
$hc = { param($case) $pp = Join-Path $tmp "comando-$case"; Put $pp 'tools/fake.ps1' $fakeExec; Put $pp 'cen a.scn' "scenario SC-1 um`n"; Put $pp 'b.scn' "scenario SC-3 tres`n"; $ErrorActionPreference = 'Continue'; Push-Location $pp; try { $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $hs6 -Accept (Join-Path $checks 'accept.ps1') -Lib (Join-Path $checks 'lib.ps1') -Root $pp -Case $case 2>&1 | Out-String } finally { Pop-Location }; @{ Code = $LASTEXITCODE; Out = $o } }
$r = & $hc 'falha'
Check 'v3.62.3: cenário que falha no executor do projeto é repetido uma vez só ele ({only}); passou na 2ª → PASSOU com a nota' $r 0 @('CODE=0', '\[SC-1\] PASSOU  um  \(passou na 2ª tentativa; 1ª: tag nao encontrada: x\)', '"only": "SC-1", "exit": 0', 'cen a-r2/SC-1-final\.png')
$r = & $hc 'falha2'
Check 'v3.62.3: falhou nas 2 tentativas → FALHOU (exit 1); a linha com colchetes e "->" também vale' $r 0 @('CODE=1', '\[SC-1\] FALHOU  um  -> sempre  \(falhou nas 2 tentativas\)')
$r = & $hc 'amb'
Check 'v3.62.3: executor do projeto sai 4 → FALHA DE AMBIENTE (exit 4) com a última linha, os que rodaram no result.json e quantos ficaram de fora' $r 0 @('CODE=4', 'FALHA DE AMBIENTE \(web\): o executor do projeto saiu 4 \(ambiente\) em b: emulador fora do adb · 2 de 2 antes da interrupção, 1 não rodaram', '"environment": "o executor do projeto saiu 4')
$r = & $hc 'uso'
Check 'v3.62.3: executor do projeto sai 2 sem linha nenhuma → exit 2 (uso), sem environment' $r 0 @('CODE=2', 'saiu 2 \(uso ou cenário malformado\) em cen a', '"environment": null')

$ok63 = [char]::ConvertFromUtf32(0x2705); $fail63 = [char]::ConvertFromUtf32(0x274C); New-Item -ItemType Directory -Force $tmp | Out-Null
# ======================= v3.63.0 · portão do QA por marcos, causa com dono, controle e prova guardada =======================
# O passo do portão (gate.ps1) com as funções do run.ps1 simuladas, num projeto git de verdade (a árvore de produção é do git).
$pg = Join-Path $tmp 'v3630-gate'
Put $pg '.team-project/README.md' "| | |`n|---|---|`n| **Sprint corrente** | **1** — x |`n"
Put $pg '.team-project/sprints/1/sprint-backlog.md' "# SB`n`n## História H-1 — x`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok63 T-001 | a | 1 | dev | — | — | — | SC-1 |`n"
Put $pg '.team-project/guards.json' '{ "targets": { "web": { "url": "http://127.0.0.1:9" } }, "quality": { "toolingPaths": ["tools/**"] } }'
Put $pg '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-1 um`nlaunch`nassert-exists a`n"
Put $pg 'src/a.ts' "export const a = 1`n"; Put $pg 'tools/p.mjs' "x`n"
$ErrorActionPreference = 'Continue'; & git -C $pg init -q 2>$null; Put $pg '.gitignore' ".team-project/`n"; & git -C $pg add -A 2>$null; & git -C $pg -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$prod63 = & $lib63 "Get-ProductionTree '$pg'"
$scn63 = & $lib63 "Get-ScenarioSetHash (Get-SprintScenarioFiles '$pg')"
$r = & $g63 $pg
Check 'v3.63.0 portão sem medição: o operator mede a qualidade e o aceite com -Resume' $r 0 @('medir \(operator.*qualidade: sem medição · aceite: sem medição', 'accept\.ps1 -Task S1 -Resume')
$qd63 = Join-Path $pg '.team-project/quality/1/S1'; $ad63 = Join-Path $pg '.team-project/accept/1/S1'
Put $qd63 'result.json' (@{ id = 'S1'; at = '2026-11-17 10:00:00'; prod = $prod63; rows = @() } | ConvertTo-Json)
Put $ad63 'result.json' (@{ task = 'S1'; at = '2026-11-17 10:05:00'; prod = $prod63; scenariosHash = $scn63; environment = 'massa base não carregou (exit 7)'; results = @() } | ConvertTo-Json)
$r = & $g63 $pg
Check 'v3.63.0 A: aceite que parou no ambiente não é medição — reparo e repetição com -Resume, sem QA nem Q-S' $r 0 @('reparar o alvo e repetir o aceite', 'target\.ps1 -Target web -Repair e, pronto, .*accept\.ps1 -Task S1 -Resume', '^(?![\s\S]*team:quality-assurance)', '^(?![\s\S]*abrir Q-S)')
Put $ad63 'result.json' (@{ task = 'S1'; at = '2026-11-17 10:20:00'; prod = $prod63; scenariosHash = $scn63; environment = 'massa base não carregou (exit 7)'; results = @() } | ConvertTo-Json)
$r = & $g63 $pg
Check 'v3.63.0 A: a 2ª falha de ambiente seguida vai ao stakeholder (formulário), uma linha no run-log, sem QA' $r 0 @('formulário ao stakeholder — o aceite do portão do sprint 1 parou no ambiente pela 2ª vez seguida', 'RUNLOG: S1 \| portão: o aceite parou no ambiente', '^(?![\s\S]*team:quality-assurance)')
Put $ad63 'result.json' (@{ task = 'S1'; at = '2026-11-17 10:30:00'; prod = $prod63; scenariosHash = $scn63; configuration = 'APK sem a depuração da WebView'; environment = 'CONFIGURAÇÃO DO ALVO: x'; results = @() } | ConvertTo-Json)
$r = & $g63 $pg
Check 'v3.63.0 A: configuração do alvo vai direto ao stakeholder' $r 0 @('formulário ao stakeholder — .*\(configuração do alvo\)')
Put $ad63 'result.json' (@{ task = 'S1'; at = '2026-11-17 10:40:00'; prod = $prod63; scenariosHash = $scn63; environment = $null; passed = 1; total = 1; results = @(@{ id = 'SC-1'; status = 'PASSOU'; shot = '' }) } | ConvertTo-Json -Depth 4)
Put $ad63 'shots/SC-1-final.png' 'png'; Put $ad63 'run.log' 'log bruto'
$r = & $g63 $pg
$gj63 = [System.IO.File]::ReadAllText((Join-Path $pg '.team-project/sprints/1/gate.json'), $utf8) -replace '\s+', ' '
$pf63 = (@(Get-ChildItem (Join-Path $pg '.team-project/sprints/1/proof') -Recurse -File | ForEach-Object { $_.Name }) | Sort-Object) -join ','
Check 'v3.63.0 H: rodada 1 — a prova (resultado e captura, sem o log bruto) vai a proof/S1/round-1 e o QA a lê de lá; gate.json com a rodada e as bases' @{ Code = $r.Code; Out = "$($r.Out)`nGJ=$gj63`nPF=$pf63" } 0 @('julgar \(QA, rodada 1', 'proof/S1/round-1/quality/result\.md e \.team-project/sprints/1/proof/S1/round-1/accept/result\.md', 'Cause code\|design\|scenario\|screen\|requirement\|environment', 'GJ=.*"round": 1.*"judged".*"prod": "prod:', 'PF=result\.json,result\.json,SC-1-final\.png')
Put $pg '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $fail63 reprovado — 2026-11-17`n`n## Frentes`n| Front | State | Round | Proof |`n|---|---|---|---|`n| functional | pass | 1 | x |`n| review | fail | 1 | x |`n`n## Achados`n| ID | Task | Achado | Onde | Cause | Owner | State |`n|---|---|---|---|---|---|---|`n| S1-F1 | T-001 | critério ambíguo | x | requirement | PO | open |`n| S1-F2 | T-001 | título corta na fonte grande | x | screen | UX | open |`n| S1-F3 | T-001 | soma errada | a.ts:1 | code | dev | open |`n"
$r = & $g63 $pg
Check 'v3.63.0 F: requisito primeiro — o PO decide (STAKEHOLDER: para o que for do stakeholder) e grava a resolução' $r 0 @('requisito: S1-F1 → /po', 'team:product-owner', 'STAKEHOLDER: <a pergunta e as opções>', 'gate/<ID>\.md com a linha \*\*Resolution:\*\* done\|code\|debt', '^(?![\s\S]*abrir Q-S)')
Put $pg '.team-project/sprints/1/gate/S1-F1.md' "**Resolution:** done — critério esclarecido`n"
$r = & $g63 $pg
Check 'v3.63.0 F: depois do PO, a tela vai ao UX (a especificação ganha o caso)' $r 0 @('tela: S1-F2 → /ux', 'team:user-experience', 'Acrescente o caso que faltou')
Put $pg '.team-project/sprints/1/gate/S1-F2.md' "**Resolution:** code — precisa mudar o layout`n"
$r = & $g63 $pg
Check 'v3.63.0 F: o código (e a tela que o UX resolveu como code) vira uma Q-S que cita os IDs' $r 0 @('abrir Q-S1 — correção do portão: S1-F2, S1-F3 \(causa code\)', 'com os IDs S1-F2, S1-F3 na coluna Task')
Edit-File (Join-Path $pg '.team-project/sprints/1/sprint-backlog.md') "| SC-1 |`n" ("| SC-1 |`n`n## Correção do portão — sprint 1`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok63 Q-S1 | corrige S1-F2 e S1-F3 | 1 | dev | — | — | — | SC-1 |`n")
Put $pg 'tools/p.mjs' "y`n"
$prod63b = & $lib63 "Get-ProductionTree '$pg'"
Check 'v3.63.0 C: mudar só quality.toolingPaths não muda a árvore de produção (o julgamento de código não vence)' @{ Code = 0; Out = "A=$prod63 B=$prod63b" } 0 @("A=$([regex]::Escape($prod63)) B=$([regex]::Escape($prod63))$")
$r = & $g63 $pg
Check 'v3.63.0 D: Q-S fechada sem mudar produção — rodada 2 focada: nenhuma frente de código a julgar, só os achados abertos' $r 0 @('revisar o veredito \(QA, instância nova, rodada 2 focada\)', 'frentes a julgar: nenhuma \(só os achados\) · ficam como estavam: functional, measured, review, security · achados abertos: S1-F1, S1-F2, S1-F3', 'proof/S1/round-2/')
Put $pg 'src/a.ts' "export const a = 2`n"
$r = & $g63 $pg
Check 'v3.63.0 C/D: código de produção mudou — mede de novo a qualidade e o aceite (este com -Resume)' $r 0 @('medir .*qualidade: o código de produção mudou · aceite: o código de produção mudou', 'Revisão final: medindo de novo só o que a correção mudou')

# ---------- v3.65.8 · a medição do portão que já roda não é medida de novo, nem vira pergunta ao stakeholder ----------
# Garden S6 (21/11, 19:18 → 19:32): o quality.ps1 rodava, o next mandava medir outra vez, a sonda dizia "terminou" e a sessão,
# sem caminho que a G20 aceitasse, perguntou ao stakeholder se esperava. Estado de processo tem resposta do next.
$keep658 = @{}; foreach ($f in '.next-verdict', '.ask-route') { $fp = Join-Path $pg ".team-project/$f"; $keep658[$f] = if (Test-Path -LiteralPath $fp) { [System.IO.File]::ReadAllText($fp, $utf8) } else { $null } }
$gjKeep658 = [System.IO.File]::ReadAllText((Join-Path $pg '.team-project/sprints/1/gate.json'), $utf8)
$run658 = Join-Path $checks 'run.ps1'; $nvP658 = Join-Path $pg '.team-project/.next-verdict'; $arP658 = Join-Path $pg '.team-project/.ask-route'
$wait658 = { $ErrorActionPreference = 'Continue'; $o = (& powershell -NoProfile -ExecutionPolicy Bypass -File $run658 wait -Root $pg 2>&1 | ForEach-Object { "$_" }) -join ' '; "WAIT=$LASTEXITCODE $o" }
$nv658 = { if (Test-Path -LiteralPath $nvP658) { 'NV=' + [System.IO.File]::ReadAllText($nvP658, $utf8) } else { 'NV=nenhum' } }
$sl658 = Start-Process powershell -ArgumentList '-NoProfile', '-Command', 'Start-Sleep 120' -PassThru -WindowStyle Hidden
Start-Sleep 2
$ql658 = Join-Path $qd63 'quality.lock'
$lock658 = { param([int]$AgoMin) [System.IO.File]::WriteAllText($ql658, ([ordered]@{ pid = $sl658.Id; started = $sl658.StartTime.ToString('o'); at = (Get-Date).AddMinutes(-$AgoMin).ToString('yyyy-MM-dd HH:mm:ss') } | ConvertTo-Json -Compress), $utf8) }
& $lock658 1
$r = & $g63 $pg
Check 'v3.65.8: a medição de qualidade do portão já roda → esperar com o watcher; sem operator, sem formulário; a G20 libera (esperar) e a sonda diz vivo' @{ Code = $r.Code; Out = "$($r.Out)`n$(& $nv658)`n$(& $wait658)" } 3 @('PRÓXIMA AÇÃO: esperar — a medição do portão do sprint 1 já roda: quality \(pid', 'WATCHER-LINE', 'sem precisar de você', 'NV=.*"acao":"esperar".*"task":"S1"', 'WAIT=3 wait: vivo — S1 · quality \(pid', '^(?![\s\S]*Agent: team:operator)', '^(?![\s\S]*formulário ao stakeholder)')
$qo658 = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $checks 'quality.ps1') -Id S1 -Root $pg 2>&1 | Out-String
Check 'v3.65.8: o quality.ps1 com a medição viva recusa a segunda (exit 5, "em uso por") e não apaga a trava dela' @{ Code = $LASTEXITCODE; Out = "$qo658`nLOCK=$(Test-Path -LiteralPath $ql658)" } 5 @('quality S1: já roda — em uso por quality \(pid', 'LOCK=True')
& $lock658 20
foreach ($f in @(Get-ChildItem -LiteralPath $qd63 -File)) { $f.LastWriteTime = (Get-Date).AddMinutes(-30) }
$r = & $g63 $pg
$gs658 = [System.IO.File]::ReadAllText((Join-Path $pg '.team-project/sprints/1/gate.json'), $utf8) -replace '\s+', ' '
Check 'v3.65.8: POSSÍVEL TRAVAMENTO da medição, 1ª vez → encerrar (quality.ps1 -Kill) e retomar sozinho, sem formulário (regra 5)' @{ Code = $r.Code; Out = "$($r.Out)`nGJ=$gs658" } 0 @('PRÓXIMA AÇÃO: encerrar e retomar — POSSÍVEL TRAVAMENTO na medição do portão do sprint 1', 'quality\.ps1 -Id S1 -Kill', 'RUNLOG: S1 \| portão: POSSÍVEL TRAVAMENTO', 'GJ=.*"stall": 1', '^(?![\s\S]*formulário ao stakeholder)', '^(?![\s\S]*Agent: team:operator)')
$r = & $g63 $pg
Check 'v3.65.8: POSSÍVEL TRAVAMENTO de novo → aí sim o formulário (rota travamento), com a decisão "esperar" gravada' @{ Code = $r.Code; Out = "$($r.Out)`n$(& $nv658)`nAR=$(if (Test-Path -LiteralPath $arP658) { [System.IO.File]::ReadAllText($arP658, $utf8) })" } 3 @('formulário ao stakeholder — a medição do portão do sprint 1 travou de novo', 'AR=.*"rota":"travamento"', 'NV=.*"acao":"esperar"')
$ko658 = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $checks 'quality.ps1') -Id S1 -Kill -Root $pg 2>&1 | Out-String
Start-Sleep 1
Check 'v3.65.8: quality.ps1 -Kill encerra a medição viva e apaga a trava' @{ Code = $LASTEXITCODE; Out = "$ko658`nVIVO=$([bool](Get-Process -Id $sl658.Id -ErrorAction SilentlyContinue)) LOCK=$(Test-Path -LiteralPath $ql658)" } 0 @("quality -Kill S1: medição encerrada \(pid $($sl658.Id)", 'VIVO=False LOCK=False')
$r = & $g63 $pg
Check 'v3.65.8: sem medição viva, o portão volta a medir (o operator); v3.65.9: o quality vai pelo detach.ps1' $r 0 @('medir .*qualidade: o código de produção mudou', 'Agent: team:operator', 'rode-o pelo .*detach\.ps1 -Dir \.team-project/operator/1/S1-quality')
$qKeep658 = [System.IO.File]::ReadAllText((Join-Path $qd63 'result.json'), $utf8)
$qo658 = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $checks 'quality.ps1') -Id S1 -Root $pg 2>&1 | Out-String
Check 'v3.65.8: a medição que termina solta a própria trava' @{ Code = $LASTEXITCODE; Out = "$qo658`nLOCK=$(Test-Path -LiteralPath $ql658)" } 0 @('quality S1 · ', 'LOCK=False')
[System.IO.File]::WriteAllText((Join-Path $qd63 'result.json'), $qKeep658, $utf8)

# Contrato (v3.65.8): para cada comando do plugin em voo no portão, o next não dispara o operator por cima dele nem abre
# formulário na primeira vez — grava "esperar", que a G20 aceita (run-guard-tests, G20 v3.53.5). Comando novo do portão que
# rode longo entra nesta tabela.
$vd658 = Join-Path $pg '.team-project/verify/1/S1'; New-Item -ItemType Directory -Force $vd658 | Out-Null
$inflight658 = @(
    @{ Name = 'verify do sprint (verify.lock)'; Path = (Join-Path $vd658 'verify.lock'); Body = { param($pp) [ordered]@{ pid = $pp.Id; started = $pp.StartTime.ToString('o'); mode = 'full'; at = (Get-Date).AddMinutes(-1).ToString('yyyy-MM-dd HH:mm:ss') } } },
    @{ Name = 'accept do sprint (.target-lock)'; Path = (Join-Path $pg '.team-project/.target-lock'); Body = { param($pp) [ordered]@{ target = 'web'; owner = 'accept S1'; pid = $pp.Id; desde = (Get-Date).AddMinutes(-1).ToString('yyyy-MM-dd HH:mm:ss') } } },
    @{ Name = 'quality do sprint (quality.lock)'; Path = $ql658; Body = { param($pp) [ordered]@{ pid = $pp.Id; started = $pp.StartTime.ToString('o'); at = (Get-Date).AddMinutes(-1).ToString('yyyy-MM-dd HH:mm:ss') } } }
)
foreach ($c658 in $inflight658) {
    # A linha de comando cita accept.ps1: o dono da trava do alvo precisa parecer script do plugin (Test-TargetLockOwnerProcess);
    # processo estranho com o alvo vai ao stakeholder de propósito (v3.63.1).
    $pp658 = Start-Process powershell -ArgumentList '-NoProfile', '-Command', 'Start-Sleep 60; # \fake\accept.ps1' -PassThru -WindowStyle Hidden
    Start-Sleep 2
    [System.IO.File]::WriteAllText($c658.Path, ((& $c658.Body $pp658) | ConvertTo-Json -Compress), $utf8)
    Remove-Item -LiteralPath $nvP658, $arP658 -Force -ErrorAction SilentlyContinue
    $r = & $g63 $pg
    Check "v3.65.8 contrato: $($c658.Name) em voo → esperar, sem operator por cima e sem formulário" @{ Code = $r.Code; Out = "$($r.Out)`n$(& $nv658)" } 3 @('PRÓXIMA AÇÃO: esperar', 'NV=.*"acao":"esperar"', '^(?![\s\S]*Agent: team:operator)', '^(?![\s\S]*formulário ao stakeholder)')
    Stop-Process -Id $pp658.Id -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $c658.Path -Force -ErrorAction SilentlyContinue
}
Stop-Process -Id $sl658.Id -Force -ErrorAction SilentlyContinue
foreach ($f in $keep658.Keys) { $fp = Join-Path $pg ".team-project/$f"; if ($null -ne $keep658[$f]) { [System.IO.File]::WriteAllText($fp, $keep658[$f], $utf8) } else { Remove-Item -LiteralPath $fp -Force -ErrorAction SilentlyContinue } }
[System.IO.File]::WriteAllText((Join-Path $pg '.team-project/sprints/1/gate.json'), $gjKeep658, $utf8)
Put $pg '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $fail63 reprovado`n`n## Achados`n| ID | Task | Achado | Onde | Cause | Owner | State |`n|---|---|---|---|---|---|---|`n| S1-F9 | T-001 | x | x | bug | ? | open |`n"
$prod63c = & $lib63 "Get-ProductionTree '$pg'"
Put $qd63 'result.json' (@{ id = 'S1'; at = '2026-11-17 12:00:00'; prod = $prod63c; rows = @() } | ConvertTo-Json)
Put $ad63 'result.json' (@{ task = 'S1'; at = '2026-11-17 12:05:00'; prod = $prod63c; scenariosHash = $scn63; environment = $null; passed = 1; total = 1; results = @(@{ id = 'SC-1'; status = 'PASSOU' }) } | ConvertTo-Json -Depth 4)
$r = & $g63 $pg
Check 'v3.63.0 E: causa fora da lista → o QA só classifica (sem causa não há dono)' $r 0 @('o QA classifica S1-F9 \(\?bug\)', 'Dê a cada um UMA causa')
Put $pg '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $fail63 reprovado`n`n| # | Task | Achado | Onde | Volta para | Estado |`n|---|---|---|---|---|---|`n| 1 | T-001 | x | y | dev | aberto |`n"
$r = & $g63 $pg
Check 'v3.63.0 E: validation.md no formato antigo (sem a tabela com Cause) → o caminho de antes (Q-S pelos "Volta para: dev")' $r 0 @('abrir Q-S1b — correção do portão .*formato anterior à v3.63.0', "achados 'Volta para: dev'")
# ----- v3.64.0 · item 8: o portão preso no formato antigo (sprint 6 do projeto piloto, 18/11) -----
$dg64 = Join-Path $pg '.team-project/operator/1/S1-alvo/diagnostico.md'
Put $pg '.team-project/operator/1/S1-alvo/diagnostico.md' "Veredito: PLANO`nCenário: SC-1`nMotivo: valor errado`n"
$r = & $g63 $pg
Check 'v3.64.0 item 8 C/A: diagnóstico mais novo que o validation.md antigo → rodada focada no formato novo, com Cause na coluna e a conversão dos achados antigos abertos' $r 0 @('revisar o veredito .*o diagnóstico do aceite é mais novo que o validation\.md', '\| ID \| Task \| Achado \| Onde \| Cause \| Owner \| State \| Evidência \|', 'não dentro do ID', 'formato anterior à v3\.63\.0 .*reescreva nessa tabela CADA achado antigo ainda aberto', '^(?![\s\S]*abrir Q-S)')
Remove-Item -LiteralPath $dg64 -Force
$sb64 = Join-Path $pg '.team-project/sprints/1/sprint-backlog.md'
Edit-File $sb64 "| $ok63 Q-S1 | corrige S1-F2 e S1-F3 | 1 | dev | — | — | — | SC-1 |`n" ("| $ok63 Q-S1 | corrige S1-F2 e S1-F3 | 1 | dev | — | — | — | SC-1 |`n| $([char]::ConvertFromUtf32(0x1F534)) Q-S1b | corrige a rodada 2 | 1 | dev | — | ``plan/Q-S1b.md`` | — | SC-1 |`n")
Put $pg '.team-project/sprints/1/plan/Q-S1b.md' "# Plano — Q-S1b`n`n**Corrige:** Q-S1`n"
Put $pg '.team-project/sprints/1/kanban.md' "# K`n`n### Bloqueios e riscos abertos`n`n| # | Task / História | Natureza | Degrau | Quem destrava | Desde |`n|---|---|---|---|---|---|`n| 1 | Q-S1b | ambiente: suíte caiu com a máquina ocupada | stakeholder | stakeholder | 2026-11-18 |`n"
Put $pg '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $fail63 reprovado`n`n| # | Task | Achado | Onde | Volta para | Estado |`n|---|---|---|---|---|---|`n| 1 | T-001 | x | y | dev | aberto |`n"
$r = & $g63 $pg
Check 'v3.64.0 item 8 B: formato antigo com uma correção aberta (Q-S1b 🔴) → os achados vão para ela e o Arquiteto emenda o plano; nenhuma Q-S nova' $r 0 @("incluir os achados 'Volta para: dev' do validation\.md na Q-S1b", 'não abra outra Q-S1', 'emende o plano \.team-project/sprints/1/plan/Q-S1b\.md', 'plan\.ps1 -Plan', 'está 🔴 \(ambiente: suíte caiu com a máquina ocupada\)', '^(?![\s\S]*abrir Q-S1c)')
Put $pg '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $fail63 reprovado`n`n## Achados`n| ID | Task | Achado | Onde | Cause | Owner | State |`n|---|---|---|---|---|---|---|`n| S1-F5 | T-001 | R`$0.00 em vez de 0,00 | vendas | code | dev | open |`n"
$r = & $g63 $pg
Check 'v3.64.0 item 8 B: achado code sem Q-S que o cite, com a Q-S1b aberta → incluir na Q-S1b (não abrir Q-S1c)' $r 0 @('incluir S1-F5 \(causa code\) na Q-S1b', 'os IDs S1-F5 na coluna Task da linha da Q-S1b', '^(?![\s\S]*abrir Q-S1c)')
Edit-File $sb64 '| corrige a rodada 2 |' '| corrige a rodada 2 e S1-F5 |'
Put $pg '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $fail63 reprovado`n`n## Achados`n| ID | Task | Achado | Onde | Cause | Owner | State |`n|---|---|---|---|---|---|---|`n| S1-F5 | T-001 | R`$0.00 em vez de 0,00 | vendas | code | dev | open |`n"
$r = & $g63 $pg
Check 'v3.64.0 item 8 B: o achado já está na Q-S1b, que está 🔴 → a rota do bloqueio dela (exit 0), nunca "esperar" (exit 3)' $r 0 @('destravar Q-S1b \(🔴\) .*Q-S1b: ambiente: suíte caiu com a máquina ocupada', 'Não abra outra Q-S1', '^(?![\s\S]*PRÓXIMA AÇÃO: esperar)')
# v3.64.1 (sprint 6 do projeto piloto, 18/11): a Q-S6e em 🔴 pelo Karma, o código parcial dela na árvore e o portão mediu de novo.
(Get-Item -LiteralPath (Join-Path $qd63 'result.json')).LastWriteTime = (Get-Date).AddMinutes(10)
$r = & $g63 $pg
Check 'v3.64.1: medição mais nova que o veredito com a Q-S1b 🔴 → a rota do bloqueio dela antes da rodada focada (o QA não julga código de correção parada)' $r 0 @('destravar Q-S1b \(🔴\)', '^(?![\s\S]*revisar o veredito)', '^(?![\s\S]*team:quality-assurance)')
Put $pg 'src/a.ts' "export const a = 3`n"
$r = & $g63 $pg
$ar641 = $(try { (Get-Content -LiteralPath (Join-Path $pg '.team-project/.ask-route') -Raw -Encoding UTF8) } catch { '' })
Check 'v3.64.1: produção mudou com a Q-S1b 🔴 → sem medir (nenhum operator, quality nem accept): a rota do bloqueio dela, com o motivo e o mark -To build; rota ambiente ao stakeholder' @{ Code = $r.Code; Out = $r.Out + "`nrota=$ar641" } 0 @('destravar Q-S1b \(🔴\) — a medição do portão do sprint espera', 'Q-S1b: ambiente: suíte caiu com a máquina ocupada', 'mark\.ps1 -Task <ID> -To build', 'rota=.*"rota":"ambiente"', '^(?![\s\S]*team:operator)', '^(?![\s\S]*accept\.ps1 -Task S1 -Resume)', '^(?![\s\S]*quality\.ps1)')
Edit-File $sb64 "| $ok63 T-001 | a |" "| $([char]::ConvertFromUtf32(0x1F534)) T-001 | a |"
Edit-File $sb64 "| $([char]::ConvertFromUtf32(0x1F534)) Q-S1b |" "| $ok63 Q-S1b |"
$r = & $g63 $pg
Check 'v3.64.1: Task original em 🔴 (sem correção parada) também segura a medição' $r 0 @('destravar T-001 \(🔴\) — a medição do portão do sprint espera', 'T-001: motivo não registrado', '^(?![\s\S]*team:operator)')
Edit-File $sb64 "| $([char]::ConvertFromUtf32(0x1F534)) T-001 | a |" "| $ok63 T-001 | a |"
Edit-File $sb64 "| $ok63 Q-S1b |" "| $([char]::ConvertFromUtf32(0x1F534)) Q-S1b |"
Put $pg 'src/a.ts' "export const a = 2`n"
Edit-File $sb64 "| corrige a rodada 2 e S1-F5 | 1 | dev | — | ``plan/Q-S1b.md`` | — | SC-1 |`n" "| corrige a rodada 2 e S1-F5 | 1 | dev | — | ``plan/Q-S1b.md`` | — | SC-1 |`n| $([char]::ConvertFromUtf32(0x2B1C)) Q-S1c | substitui a Q-S1b | 1 | dev | — | ``plan/Q-S1c.md`` | — | SC-1 |`n"
Put $pg '.team-project/sprints/1/plan/Q-S1c.md' "# Plano — Q-S1c`n`n**Corrige:** Q-S1b`n"
Put $pg '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $fail63 reprovado`n`n## Achados`n| ID | Task | Achado | Onde | Cause | Owner | State |`n|---|---|---|---|---|---|---|`n| S1-F5 | T-001 | R`$0.00 em vez de 0,00 | vendas | code | dev | open |`n"
$r = & $g63 $pg
Check 'v3.64.0 item 8 B: a Q-S1c declara **Corrige:** Q-S1b → a Q-S1b conta como substituída; o achado que só ela citava vai à Q-S1c' $r 0 @('a Q-S1b conta como substituída pela Q-S1c', 'incluir S1-F5 \(causa code\) na Q-S1c', '^(?![\s\S]*destravar Q-S1b)')
Remove-Item -LiteralPath (Join-Path $pg '.team-project/sprints/1/kanban.md') -Force
Put $pg '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $ok63 aprovado`n"
$r = & $g63 $pg
Check 'v3.63.0: portão aprovado → o passo volta sem sair (segue a consolidação)' $r 0 @('GATE-RETURNED')
# ----- v3.65.9 · L1: o contador do dono conta disparos, zera com progresso e escala ao Arquiteto antes do stakeholder -----
# Garden S6 (21/11, 19:44): routed 4 para S6-F10/S6-F15 com 2 disparos reais do QA, cada rodada caindo num ponto diferente,
# e o formulário foi direto ao stakeholder. Cada "rodada" aqui: aceite (t), diagnóstico (t+1), resolução (t+2), validation (t+3).
$p659 = Join-Path $tmp 'v3659-gate'
Put $p659 '.team-project/README.md' "| | |`n|---|---|`n| **Sprint corrente** | **1** — x |`n"
Put $p659 '.team-project/sprints/1/sprint-backlog.md' "# SB`n`n## História H-1 — x`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok63 T-001 | a | 1 | dev | — | — | — | SC-1 |`n"
Put $p659 '.team-project/guards.json' '{ "targets": { "web": { "url": "http://127.0.0.1:9" } } }'
Put $p659 '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-1 um`nlaunch`nassert-exists a`n"
Put $p659 'src/a.ts' "export const a = 1`n"
$ErrorActionPreference = 'Continue'; & git -C $p659 init -q 2>$null; Put $p659 '.gitignore' ".team-project/`n"; & git -C $p659 add -A 2>$null; & git -C $p659 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$prod659 = & $lib63 "Get-ProductionTree '$p659'"
$scn659 = & $lib63 "Get-ScenarioSetHash (Get-SprintScenarioFiles '$p659')"
Put $p659 '.team-project/quality/1/S1/result.json' (@{ id = 'S1'; at = '2026-11-21 01:00:00'; prod = $prod659; rows = @() } | ConvertTo-Json)
$s659 = Join-Path $p659 '.team-project/sprints/1'
$round659 = {
    param([int]$K, [string]$Det)
    $base = (Get-Date).AddHours(-6).AddMinutes($K * 10); $at = $base.ToString('yyyy-MM-dd HH:mm:ss')
    $ar = Join-Path $p659 '.team-project/accept/1/S1/result.json'
    Put $p659 '.team-project/accept/1/S1/result.json' (@{ task = 'S1'; at = $at; prod = $prod659; scenariosHash = $scn659; environment = $null; passed = 0; total = 1; results = @(@{ id = 'SC-1'; status = 'FALHOU'; detail = $Det; shot = '' }) } | ConvertTo-Json -Depth 4)
    (Get-Item -LiteralPath $ar).LastWriteTime = $base
    $dg = Join-Path $p659 '.team-project/operator/1/S1-alvo/diagnostico.md'
    Put $p659 '.team-project/operator/1/S1-alvo/diagnostico.md' "Veredito: PLANO`n`nCenário: SC-1`nMotivo: elemento ausente`nDono: QA`n"
    (Get-Item -LiteralPath $dg).LastWriteTime = $base.AddMinutes(1)
    if ($K -gt 1) { $gf = Join-Path $s659 'gate/S1-F1.md'; Put $p659 '.team-project/sprints/1/gate/S1-F1.md' "**Resolution:** done — tentativa $($K - 1) no .scn`n"; (Get-Item -LiteralPath $gf).LastWriteTime = $base.AddMinutes(2) }
    $gp = Join-Path $s659 'gate.json'
    $gj = if (Test-Path -LiteralPath $gp) { [System.IO.File]::ReadAllText($gp, $utf8) | ConvertFrom-Json } else { [pscustomobject]@{ round = 0; judged = [pscustomobject]@{ prod = $prod659; scn = $scn659; accept = ''; quality = '2026-11-21 01:00:00'; qs = '' }; proof = 0 } }
    $gj.round = $K; $gj.proof = $K; $gj.judged.accept = $at
    [System.IO.File]::WriteAllText($gp, ($gj | ConvertTo-Json -Depth 6), $utf8)
    $vp = Join-Path $s659 'validation.md'
    Put $p659 '.team-project/sprints/1/validation.md' ("# V`n" + (@(1..$K) | ForEach-Object { "**Veredito (rodada $_):** $fail63 reprovado`n" }) + "`n## Achados`n| ID | Task | Achado | Onde | Cause | Owner | State |`n|---|---|---|---|---|---|---|`n| S1-F1 | T-001 | SC-1 não acha o botão | SC-1 | scenario | QA | open |`n")
    (Get-Item -LiteralPath $vp).LastWriteTime = $base.AddMinutes(3)
}
$rt659 = { $j = [System.IO.File]::ReadAllText((Join-Path $s659 'gate.json'), $utf8) | ConvertFrom-Json; "ROUTED=$($j.routed.'S1-F1') ESC=$(if ($j.PSObject.Properties['escalated'] -and $j.escalated.PSObject.Properties['S1-F1']) { 'sim' } else { 'nao' })" }
& $round659 1 "passo 'tap a.b': tag não encontrada: a.b"
$r = & $g63 $p659; $r = & $g63 $p659; $r = & $g63 $p659
Check 'v3.65.9 L1: o next repetido 3 vezes na mesma rodada é UM disparo do QA (routed 1)' @{ Code = $r.Code; Out = "$($r.Out)`n$(& $rt659)" } 0 @('cenário: S1-F1 → /qa', 'ROUTED=1 ESC=nao', '^(?![\s\S]*formulário ao stakeholder)')
& $round659 2 "passo 'tap a.b': tag não encontrada: a.b"
$r = & $g63 $p659
Check 'v3.65.9 L1: a rodada seguinte com a MESMA falha conta o 2º disparo (ainda o QA)' @{ Code = $r.Code; Out = "$($r.Out)`n$(& $rt659)" } 0 @('cenário: S1-F1 → /qa', 'ROUTED=2', '^(?![\s\S]*formulário ao stakeholder)')
& $round659 3 "passo 'tap a.b': tag não encontrada: a.b"
$r = & $g63 $p659; $r2 = & $g63 $p659
Check 'v3.65.9 L1: 3ª rodada na mesma falha → Arquiteto (degrau 1), sem formulário; o next repetido reimprime o Arquiteto' @{ Code = $r.Code; Out = "$($r.Out)`n----`n$($r2.Out)`n$(& $rt659)" } 0 @('S1-F1 \(cenário\) voltou depois de 2 resoluções de /qa → /arc question \(degrau 1', 'Agent: team:architect', 'RUNLOG: S1 \| portão: S1-F1 \(cenário\) voltou', '----[\s\S]*→ /arc question \(degrau 1', 'ROUTED=3 ESC=sim', '^(?![\s\S]*formulário ao stakeholder)')
& $round659 4 "passo 'tap a.b': tag não encontrada: a.b"
$r = & $g63 $p659
Check 'v3.65.9 L1: voltou na mesma falha DEPOIS do Arquiteto → aí sim o formulário' $r 0 @('formulário ao stakeholder — S1-F1 \(cenário\) .*e da decisão do Arquiteto \(degrau 1\)')
& $round659 5 "passo 'tap c.d': tag não encontrada: c.d"
$r = & $g63 $p659
Check 'v3.65.9 L1: a falha mudou de passo (progresso) → a conta volta a 1 e o achado volta ao QA, sem formulário' @{ Code = $r.Code; Out = "$($r.Out)`n$(& $rt659)" } 0 @('cenário: S1-F1 → /qa', 'ROUTED=1 ESC=nao', '^(?![\s\S]*formulário ao stakeholder)')

# ----- v3.65.5 · sprint 6 do projeto piloto (21/11): rodadas focadas sem nada mudado e a metade do teste sem dono -----
# S1-F1 (design) resolvido como code, com a parte do .scn ainda não aplicada; S1-F2 (scenario) com um "done" que a rodada
# seguinte desmentiu; S1-F3 (code) com a Q-S1 fechada e já julgada. As resoluções são de antes do validation.md.
$p655 = Join-Path $tmp 'v3655-gate'
Put $p655 '.team-project/README.md' "| | |`n|---|---|`n| **Sprint corrente** | **1** — x |`n"
Put $p655 '.team-project/sprints/1/sprint-backlog.md' "# SB`n`n## História H-1 — x`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok63 T-001 | a | 1 | dev | — | — | — | SC-1 |`n`n## Correção do portão — sprint 1`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok63 Q-S1 | corrige S1-F1 e S1-F3 | 1 | dev | — | — | — | SC-1 |`n"
Put $p655 '.team-project/guards.json' '{ "targets": { "web": { "url": "http://127.0.0.1:9" } } }'
Put $p655 '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-1 um`nlaunch`nassert-exists a`n"
Put $p655 'src/a.ts' "export const a = 1`n"
$ErrorActionPreference = 'Continue'; & git -C $p655 init -q 2>$null; Put $p655 '.gitignore' ".team-project/`n"; & git -C $p655 add -A 2>$null; & git -C $p655 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$prod655 = & $lib63 "Get-ProductionTree '$p655'"
$scn655 = & $lib63 "Get-ScenarioSetHash (Get-SprintScenarioFiles '$p655')"
Put $p655 '.team-project/quality/1/S1/result.json' (@{ id = 'S1'; at = '2026-11-21 01:00:00'; prod = $prod655; rows = @() } | ConvertTo-Json)
Put $p655 '.team-project/accept/1/S1/result.json' (@{ task = 'S1'; at = '2026-11-21 01:05:00'; prod = $prod655; scenariosHash = $scn655; environment = $null; passed = 1; total = 1; results = @(@{ id = 'SC-1'; status = 'PASSOU' }) } | ConvertTo-Json -Depth 4)
$gj655 = { param($qs) Put $p655 '.team-project/sprints/1/gate.json' (([ordered]@{ round = 2; judged = [ordered]@{ prod = $prod655; scn = $scn655; accept = '2026-11-21 01:05:00'; quality = '2026-11-21 01:00:00'; qs = $qs }; env = [ordered]@{ attempts = 0; at = ''; asked = ''; sent = 0; sentAt = '' }; proof = 2; routed = [ordered]@{ 'S1-F1' = 1; 'S1-F2' = 1 } }) | ConvertTo-Json -Depth 5) }
& $gj655 'Q-S1'
$g655 = Join-Path $p655 '.team-project/sprints/1/gate'
Put $p655 '.team-project/sprints/1/gate/S1-F1.md' "**Resolution:** code — o app ganha o id manutencao.menu.x; o QA troca no SC-1 o toque por manutencao.menu.x`n"
Put $p655 '.team-project/sprints/1/gate/S1-F2.md' "**Resolution:** done — open da rota repetido com wait 3`n"
foreach ($f655 in 'S1-F1', 'S1-F2') { (Get-Item -LiteralPath (Join-Path $g655 "$f655.md")).LastWriteTime = (Get-Date).AddHours(-2) }
$v655 = "# V`n**Veredito:** $fail63 reprovado`n`n## Achados`n| ID | Task | Achado | Onde | Cause | Owner | State |`n|---|---|---|---|---|---|---|`n| S1-F1 | T-001 | id do menu não existe | SC-1 | design | Arquiteto | open |`n| S1-F2 | T-001 | app volta na aba errada | SC-1 | scenario | QA | open |`n| S1-F3 | T-001 | soma errada | a.ts:1 | code | dev | open |`n`n**Veredito (rodada 2):** $fail63 reprovado`n"
Put $p655 '.team-project/sprints/1/validation.md' $v655
$r = & $g63 $p655
Check 'v3.65.5: "done" que a rodada seguinte desmentiu não segura o achado — volta ao QA com a resolução anterior no prompt' $r 0 @('cenário: S1-F2 → /qa', 'a resolução anterior \(done: open da rota repetido com wait 3\) não se sustentou', '^(?![\s\S]*S1-F1 → /arc)', '^(?![\s\S]*revisar o veredito)')
Put $p655 '.team-project/sprints/1/gate/S1-F2.md' "**Resolution:** done — navegação pela aba Estufa em vez do open`n"
$r = & $g63 $p655
Check 'v3.65.5: resolução code com a parte do .scn não aplicada e a Q-S1 fechada → o QA aplica a metade do teste antes da rodada nova' $r 0 @('aplicar a parte do \.scn de S1-F1 → /qa', 'o app já mudou na Q-S1', 'o QA troca no SC-1', '\*\*Scenario applied:\*\*', '^(?![\s\S]*revisar o veredito)', '^(?![\s\S]*abrir Q-S1b)')
$sp655 = & $lib63 "`$x = Get-FindingScenarioPart '$(Join-Path $p655 '.team-project/sprints/1')' 'S1-F3'; 'need=' + `$x.need"
Put $p655 '.team-project/sprints/1/gate/S1-F1.md' "**Resolution:** code — o app ganha o id manutencao.menu.x; o QA troca no SC-1 o toque por manutencao.menu.x`n**Scenario applied:** 2026-11-21 — SC-1 toca manutencao.menu.x`n"
$r = & $g63 $p655
Check 'v3.65.5: code puro com a Q-S1 fechada e já julgada (gate.json judged.qs) → correção nova; o achado com a parte do .scn recém-aplicada segue com a Q-S1' @{ Code = $r.Code; Out = "$($r.Out)`n$sp655" } 0 @('abrir Q-S1b — correção do portão: S1-F3 \(causa code\)', '^(?![\s\S]*abrir Q-S1b — correção do portão: S1-F1)', '^(?![\s\S]*revisar o veredito)', 'need=False')
Edit-File (Join-Path $p655 '.team-project/sprints/1/sprint-backlog.md') '| corrige S1-F1 e S1-F3 |' '| corrige S1-F1 |'
Edit-File (Join-Path $p655 '.team-project/sprints/1/validation.md') '| S1-F3 | T-001 | soma errada | a.ts:1 | code | dev | open |' '| S1-F3 | T-001 | soma errada | a.ts:1 | code | dev | fixed |'
foreach ($f655 in 'S1-F1', 'S1-F2') { (Get-Item -LiteralPath (Join-Path $g655 "$f655.md")).LastWriteTime = (Get-Date).AddHours(-2) }
Edit-File (Join-Path $p655 '.team-project/sprints/1/validation.md') '| S1-F2 | T-001 | app volta na aba errada | SC-1 | scenario | QA | open |' '| S1-F2 | T-001 | app volta na aba errada | SC-1 | scenario | QA | fixed |'
$r = & $g63 $p655
Check 'v3.65.5: code com o .scn já aplicado e a rodada seguinte mantendo o achado aberto → volta ao dono (Arquiteto), sem rodada nova' $r 0 @('desenho: S1-F1 → /arc question', 'a resolução anterior \(code: .*\) não se sustentou', '^(?![\s\S]*revisar o veredito)')
# A Q-S fechada só é novidade uma vez: fora de judged.qs → rodada focada; dentro → nada novo (antes, toda chamada abria rodada).
Put $p655 '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $fail63 reprovado`n`n## Achados`n| ID | Task | Achado | Onde | Cause | Owner | State |`n|---|---|---|---|---|---|---|`n| S1-F3 | T-001 | soma errada | a.ts:1 | code | dev | open |`n"
Edit-File (Join-Path $p655 '.team-project/sprints/1/sprint-backlog.md') '| corrige S1-F1 |' '| corrige S1-F3 |'
& $gj655 ''
$r = & $g63 $p655
Check 'v3.65.5: Q-S1 fechada que nenhuma rodada julgou (fora de judged.qs) → rodada focada, e a rodada grava a Q-S1 em judged.qs' @{ Code = $r.Code; Out = $r.Out + "`nGJ=" + ([System.IO.File]::ReadAllText((Join-Path $p655 '.team-project/sprints/1/gate.json'), $utf8) -replace '\s+', ' ') } 0 @('revisar o veredito .*Q-S fechada', 'GJ=.*"qs": "Q-S1"')
$r = & $g63 $p655
Check 'v3.65.5: a mesma Q-S1, agora em judged.qs, não abre outra rodada (o achado code aberto pede correção nova)' $r 0 @('abrir Q-S1b — correção do portão: S1-F3', '^(?![\s\S]*revisar o veredito)')
# gate.json anterior à v3.65.5 (sem judged.qs): vale o delivery/<Q-S>.md mais velho que o validation.md.
$gjOld = [System.IO.File]::ReadAllText((Join-Path $p655 '.team-project/sprints/1/gate.json'), $utf8) -replace ',\s*"qs":\s*"[^"]*"', ''
Put $p655 '.team-project/sprints/1/gate.json' $gjOld
Put $p655 '.team-project/sprints/1/delivery/Q-S1.md' "# Entrega Q-S1`n"
(Get-Item -LiteralPath (Join-Path $p655 '.team-project/sprints/1/delivery/Q-S1.md')).LastWriteTime = (Get-Date).AddHours(-3)
$r = & $g63 $p655
Check 'v3.65.5: gate.json sem judged.qs e delivery da Q-S1 mais velho que o validation.md → a Q-S1 conta como julgada' $r 0 @('abrir Q-S1b — correção do portão: S1-F3', '^(?![\s\S]*revisar o veredito)')
# Quadro: a seção da validação no kanban.md.
Put $pg '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $fail63 reprovado`n`n## Frentes`n| Front | State | Round | Proof |`n|---|---|---|---|`n| functional | fail | 1 | x |`n`n## Achados`n| ID | Task | Achado | Onde | Cause | Owner | State |`n|---|---|---|---|---|---|---|`n| S1-F1 | T-001 | critério ambíguo | x | requirement | PO | open |`n| S1-F3 | T-001 | soma errada | a.ts:1 | code | dev | fixed |`n"
$kh63 = Join-Path $tmp 'gate-kanban.ps1'
[System.IO.File]::WriteAllText($kh63, @'
param([string]$Checks, [string]$Root)
. (Join-Path $Checks 'lib.ps1')
$ast = [System.Management.Automation.Language.Parser]::ParseFile((Join-Path $Checks 'kanban.ps1'), [ref]$null, [ref]$null)
foreach ($f in $ast.FindAll({ param($a) $a -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) { if ($f.Name -eq 'Format-GateSection') { . ([scriptblock]::Create($f.Extent.Text)) } }
Format-GateSection (Join-Path $Root '.team-project/sprints/1') '1' "`n"
'@, (New-Object System.Text.UTF8Encoding($true)))
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $kh63 -Checks $checks -Root $pg 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
Check 'v3.63.0 G: kanban.md — seção Validação do sprint com a situação, as frentes e cada achado com causa e quem resolve, em palavras simples' $r 0 @('## Validação do sprint', '\*\*Situação:\*\* .* reprovada', '\| funcional \(testes no aparelho\) \| .* reprovada \|', '\| S1-F1 \| critério ambíguo \| regra ou critério \| dono do produto \| aberto \|', '\| S1-F3 \| soma errada \| código do app \| desenvolvedor \| resolvido \|', 'Prova guardada:\*\* `sprints/1/proof/S1/round-')
# Retomada do aceite (B): o executor interno com Invoke-Once falso, num projeto git (a identidade do app web é a árvore).
$rh63 = Join-Path $tmp 'accept-resume.ps1'
[System.IO.File]::WriteAllText($rh63, @'
param([string]$Accept, [string]$Lib, [string]$Root)
$ErrorActionPreference = 'Stop'
. $Lib
$utf8 = New-Object System.Text.UTF8Encoding($false); $Task = 'T-041'; $NoRetry = $true; $NoRepair = $true; $Apk = ''; $Resume = $false
$ast = [System.Management.Automation.Language.Parser]::ParseFile($Accept, [ref]$null, [ref]$null)
foreach ($f in $ast.FindAll({ param($a) $a -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) { if ($f.Name -in 'Invoke-Accept', 'Write-AcceptProgress', 'Get-FailScreen', 'Write-AcceptConfig', 'Invoke-AcceptBaseline', 'Get-AcceptReuse', 'New-ReusedRow', 'Get-ScenarioHash', 'Get-AppIdentity', 'Get-AcceptNoRetryKind', 'Add-AcceptStepTime', 'Get-AcceptTiming', 'Format-AcceptTiming', 'Format-AcceptFresh', 'Test-AcceptFresh', 'Write-AcceptStale') { . ([scriptblock]::Create($f.Extent.Text)) } }
$script:Tgt = 'web'; $script:Serial = ''; $script:Pkg = ''; $script:Locator = 'uiautomator'; $script:ScnFiles = @(); $script:ExtCmd = ''
function Stop-WebServer { }
$script:ran = @()
function Invoke-Once($Block) { $script:ran += $Block.id; if ($env:FAIL_ID -and $Block.id -eq $env:FAIL_ID) { return @{ status = 'FALHOU'; detail = 'x'; shot = '' } }; return @{ status = 'PASSOU'; detail = ''; shot = '' } }
$blocks = @(1..4 | ForEach-Object { @{ id = "SC-10$_"; title = "c$_"; steps = @("assert-exists a$_"); file = (Join-Path $Root 'a.scn') } })
$env:FAIL_ID = 'SC-103'; $c1 = Invoke-Accept $blocks $null { $null } { $null } | Select-Object -Last 1; "R1 CODE=$c1 RAN=$($script:ran -join ',')"
$script:ran = @(); $Resume = $true; $env:FAIL_ID = ''
$c2 = Invoke-Accept $blocks $null { $null } { $null } | Select-Object -Last 1; "R2 CODE=$c2 RAN=$($script:ran -join ',')"
$blocks[1].steps = @('assert-exists mudou'); $script:ran = @()
$c3 = Invoke-Accept $blocks $null { $null } { $null } | Select-Object -Last 1; "R3 CODE=$c3 RAN=$($script:ran -join ',')"
'@, (New-Object System.Text.UTF8Encoding($true)))
$pr63 = Join-Path $tmp 'v3630-resume'; Put $pr63 '.team-project/README.md' "| **Sprint corrente** | **1** — x |`n"; Put $pr63 'src.ts' "x`n"
$ErrorActionPreference = 'Continue'; & git -C $pr63 init -q 2>$null; Put $pr63 '.gitignore' ".team-project/`n"; & git -C $pr63 add -A 2>$null; & git -C $pr63 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $rh63 -Accept (Join-Path $checks 'accept.ps1') -Lib (Join-Path $checks 'lib.ps1') -Root $pr63 2>&1 | Out-String; @{ Code = 0; Out = $o } }
Check 'v3.63.0 B: accept -Resume roda só o que falhou (mesmo app, mesmo cenário) e depois só o cenário cujo texto mudou; a hora da prova original fica' $r 0 @('R1 CODE=1 RAN=SC-101,SC-102,SC-103,SC-104', 'R2 CODE=0 RAN=SC-103\r?\n', 'R3 CODE=0 RAN=SC-102\r?\n', '\[SC-101\] PASSOU  c1  \(reaproveitado: passou em \S+ \S+ com o mesmo app e o mesmo cenário\)')
$pr63b = Join-Path $tmp 'v3630-resume-semgit'; Put $pr63b '.team-project/README.md' "| **Sprint corrente** | **1** — x |`n"
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $rh63 -Accept (Join-Path $checks 'accept.ps1') -Lib (Join-Path $checks 'lib.ps1') -Root $pr63b 2>&1 | Out-String; @{ Code = 0; Out = $o } }
Check 'v3.63.0 B: sem identidade do app (web:?) o -Resume não reaproveita nada — roda todos' $r 0 @('a identidade do app instalado não pôde ser lida \(web:\?\)', 'R2 CODE=0 RAN=SC-101,SC-102,SC-103,SC-104')
# v3.65.2 (garden, portão do S6): a 2ª tentativa só para a falha que pode ser oscilação; o tempo por verbo no resultado.
$rh652 = Join-Path $tmp 'accept-retry.ps1'
[System.IO.File]::WriteAllText($rh652, @'
param([string]$Accept, [string]$Lib, [string]$Root)
$ErrorActionPreference = 'Stop'
. $Lib
$utf8 = New-Object System.Text.UTF8Encoding($false); $Task = 'T-041'; $NoRetry = $false; $NoRepair = $true; $Apk = ''; $Resume = $false
$ast = [System.Management.Automation.Language.Parser]::ParseFile($Accept, [ref]$null, [ref]$null)
foreach ($f in $ast.FindAll({ param($a) $a -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) { if ($f.Name -in 'Invoke-Accept', 'Write-AcceptProgress', 'Get-FailScreen', 'Write-AcceptConfig', 'Invoke-AcceptBaseline', 'Get-AcceptReuse', 'New-ReusedRow', 'Get-ScenarioHash', 'Get-AppIdentity', 'Get-AcceptNoRetryKind', 'Add-AcceptStepTime', 'Get-AcceptTiming', 'Format-AcceptTiming', 'Format-AcceptFresh', 'Test-AcceptFresh', 'Write-AcceptStale') { . ([scriptblock]::Create($f.Extent.Text)) } }
# As mensagens reais das rodadas 5 e 6 do garden: '' = repete.
$cases = [ordered]@{
    'ausente' = "passo 'assert-exists manejo-semeio.semeios': tag ausente: manejo-semeio.semeios"
    'naoachou' = "passo 'tap administracao.menu.parametrizacoes': tag não encontrada: administracao.menu.parametrizacoes"
    'rolagem' = "passo 'type semeio.obs = Naoperder': semeio.obs existe, mas a rolagem não o trouxe à tela"
    'contagem' = "passo 'assert-count estufa.encerrar. = 0': esperado 0 itens 'estufa.encerrar.*' na lista inteira, obtido 15: [a,b]"
    'contem' = "passo 'assert-contains vendas.resumo.receita-realizada = 0,00': 'Receita Realizada 10,00' não contém '0,00' em vendas.resumo.receita-realizada"
    'toque' = "passo 'tap manejo-confirmacao.cancelar': o toque em manejo-confirmacao.cancelar não chegou a ele (pointerdown em span.alert-button-inner)"
    'coberto' = "passo 'tap a': toque em a cairia em div.tampa (coberto)"
    'conexao' = "passo 'tap a': a conexão com a página caiu"
}
foreach ($k in $cases.Keys) { "KIND $k=[$(Get-AcceptNoRetryKind $cases[$k] '')]" }
"KIND sinal=[$(Get-AcceptNoRetryKind $cases['ausente'] 'restarted')]"
$script:Tgt = 'web'; $script:Serial = ''; $script:Pkg = ''; $script:Locator = 'uiautomator'; $script:ScnFiles = @(); $script:ExtCmd = ''
function Stop-WebServer { }
$script:ran = @()
function Invoke-Once($Block) {
    $script:ran += $Block.id; $script:Executions++; Add-AcceptStepTime 'tap' 1200; Add-AcceptStepTime 'assert-text' 300
    $d = @{ 'SC-201' = $cases['ausente']; 'SC-202' = $cases['toque']; 'SC-203' = $cases['ausente'] }[$Block.id]
    if (-not $d) { return @{ status = 'PASSOU'; detail = ''; shot = ''; stepMs = @(1200, 300) } }
    return @{ status = 'FALHOU'; detail = $d; shot = ''; stepMs = @(1200); signal = $(if ($Block.id -eq 'SC-203') { [pscustomobject]@{ kind = 'restarted'; text = 'o app foi reiniciado' } }) }
}
$blocks = @(1..4 | ForEach-Object { @{ id = "SC-20$_"; title = "c$_"; steps = @("tap a$_", "assert-text a$_ = x"); file = (Join-Path $Root 'a.scn') } })
$c = Invoke-Accept $blocks $null { $null } { $null } | Select-Object -Last 1
"CODE=$c RAN=$($script:ran -join ',')"
$d = Join-Path $Root '.team-project/accept/1/T-041'
'MD=' + ([System.IO.File]::ReadAllText((Join-Path $d 'result.md')) -replace '\r?\n', ' ¶ ')
$j = [System.IO.File]::ReadAllText((Join-Path $d 'result.json')) | ConvertFrom-Json
"TIMING exec=$($j.timing.executions) tap=$($j.timing.byVerb.tap.n)/$($j.timing.byVerb.tap.avgMs) first=$(@($j.timing.byVerb.PSObject.Properties.Name)[0]) row4=$(@($j.results)[3].stepMs -join ',')"
'@, (New-Object System.Text.UTF8Encoding($true)))
$pr652 = Join-Path $tmp 'v3652-retry'; Put $pr652 '.team-project/README.md' "| **Sprint corrente** | **1** — x |`n"; Put $pr652 'src.ts' "x`n"
$ErrorActionPreference = 'Continue'; & git -C $pr652 init -q 2>$null; Put $pr652 '.gitignore' ".team-project/`n"; & git -C $pr652 add -A 2>$null; & git -C $pr652 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $rh652 -Accept (Join-Path $checks 'accept.ps1') -Lib (Join-Path $checks 'lib.ps1') -Root $pr652 2>&1 | Out-String; @{ Code = 0; Out = $o } }
Check 'v3.65.2: não repete id ausente, rolagem e valor diferente (as mensagens do garden); repete toque, coberto, conexão e a falha com sinal do app' $r 0 @('KIND ausente=\[o id não está na tela', 'KIND naoachou=\[o id não está na tela', 'KIND rolagem=\[a rolagem não traz', 'KIND contagem=\[o valor lido é outro', 'KIND contem=\[o valor lido é outro', 'KIND toque=\[\]', 'KIND coberto=\[\]', 'KIND conexao=\[\]', 'KIND sinal=\[\]')
Check 'v3.65.2: no laço do accept, o id ausente roda uma vez com a nota; o toque e a falha com sinal repetem' $r 0 @('CODE=1 RAN=SC-201,SC-202,SC-202,SC-203,SC-203,SC-204\r?\n', '\[SC-201\] FALHOU .*\(não repetido: o id não está na tela, depois da espera e da busca\)  \[\d+(\.\d+)? s\]', '\[SC-202\] FALHOU .*\(falhou nas 2 tentativas\)', '\[SC-203\] FALHOU .*\(falhou nas 2 tentativas\)')
Check 'v3.65.2: o tempo da rodada no result.md e no result.json — execuções, soma e média por verbo (o mais caro primeiro) e o passo a passo de cada cenário' $r 0 @('\*\*Tempo:\*\* [\d.,]+ min · 6 execução\(ões\) de 4 cenário\(s\) rodado\(s\) · por verbo: tap 6× · 7\.2 s \(média 1\.2 s\) · assert-text 6×', '\| Prova \(captura\) \| s \|', 'TIMING exec=6 tap=6/1200 first=tap row4=1200,300')
# Consumo (G): o portão (S<n>) e o achado (S<n>-F<k>) com unidade própria; a 2ª rodada do portão é retrabalho.
$pc63 = Join-Path $tmp 'v3630-consumo'; New-Project $pc63
$dst63 = '.team-project/sprints/1/consumption.md'
Put $pc63 '.team-project/usage.jsonl' (@(
    ('{"agent_id":"q1","role":"quality-assurance","description":"/qa sprint 1","round":1,"work":"S1","gate_round":1,"model":"claude-sonnet-4-5","start":"2026-09-03T10:00:00","duration_s":120,"calls":10,"processed":300000,"final_context":50000,"cache_read":250000,"output":4000,"first_context":15000,"peak_context":50000,"children":[],"dest":"' + $dst63 + '","dest_note":""}'),
    ('{"agent_id":"o2","role":"operator","description":"medir S1","round":1,"work":"S1","gate_round":2,"model":"claude-haiku-4-5","start":"2026-09-03T12:00:00","duration_s":60,"calls":3,"processed":40000,"final_context":12000,"cache_read":30000,"output":500,"first_context":9000,"peak_context":12000,"children":[],"dest":"' + $dst63 + '","dest_note":""}'),
    ('{"agent_id":"p1","role":"product-owner","description":"/po S1-F1","round":1,"work":"S1-F1","gate_round":1,"model":"claude-sonnet-4-5","start":"2026-09-03T11:00:00","duration_s":60,"calls":3,"processed":50000,"final_context":12000,"cache_read":30000,"output":500,"first_context":9000,"peak_context":12000,"children":[],"dest":"' + $dst63 + '","dest_note":""}')
) -join "`n")
$r = Invoke-Check 'consumption.ps1' @('-Root', $pc63)
$r.Out = $r.Out + (Get-Content -Raw -Encoding UTF8 (Join-Path $pc63 $dst63))
Check 'v3.63.0 G: consumo — S1 na unidade "validação do sprint", S1-F1 em "correção do portão", a 2ª rodada do portão como retrabalho, e a tabela por rodada' $r 0 @('\| operator \| haiku[^|]*\| `Agent` · medir S1 \| S1 \| retrabalho \| validação do sprint \|', '\| po \| sonnet[^|]*\| `Agent` · /po S1-F1 \| S1-F1 \| [^|]+ \| correção do portão \|', '### Por rodada do portão', '\| 2 \| operator \| 1 \| 40\.000 \| [^|]+ \| retrabalho \|')
# O hook reconhece o portão e o achado como trabalho, sem casar a Q-S.
$wh63 = Join-Path $tmp 'workid.ps1'
[System.IO.File]::WriteAllText($wh63, @'
param([string]$Hook)
$ast = [System.Management.Automation.Language.Parser]::ParseFile($Hook, [ref]$null, [ref]$null)
foreach ($f in $ast.FindAll({ param($a) $a -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) { if ($f.Name -eq 'Get-WorkId') { . ([scriptblock]::Create($f.Extent.Text)) } }
'A=' + (Get-WorkId 'Chamador: sessão S6 — Rode na raiz') + ' B=' + (Get-WorkId '/po — decida S6-F2 (T-001)') + ' C=' + (Get-WorkId 'Executor da Q-S6d') + ' D=' + (Get-WorkId 'leia .team-project/sprints/6/proof/S6/round-2/')
'@, (New-Object System.Text.UTF8Encoding($true)))
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $wh63 -Hook (Join-Path $checks '../../hooks/subagent-stop.ps1') 2>&1 | Out-String; @{ Code = 0; Out = $o } }
Check 'v3.63.0 G: Get-WorkId do hook — S6 e S6-F2 são trabalho; Q-S6d continua Q-S6d' $r 0 @('A=S6 B=S6-F2 C=Q-S6d D=S6')
# Registro de agentes (I): sem sinal há 37 min e sem filho vivo sai do .active-agents para o .interrupted; o "## Agora" diz.
$sh63 = Join-Path $tmp 'stale.ps1'
[System.IO.File]::WriteAllText($sh63, @'
param([string]$Common, [string]$Lib, [string]$Root)
. $Lib; . $Common
$old = (Get-Date).AddMinutes(-37).ToString('yyyy-MM-dd HH:mm:ss'); $now = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
$list = @(
    [pscustomobject]@{ type = 'team:task-runner'; description = 'Executor da Q-S1'; desde = $old; session = 's'; parent = ''; agent_id = 'aExec'; work = 'Q-S1'; last = 'Agent'; at = $old },
    [pscustomobject]@{ type = 'team:developer'; description = 'dev Q-S1'; desde = $old; session = 's'; parent = 'aExec'; agent_id = 'aDev'; work = 'Q-S1'; last = 'powershell'; at = $old },
    [pscustomobject]@{ type = 'team:task-runner'; description = 'Executor da T-001'; desde = $old; session = 's'; parent = ''; agent_id = 'bExec'; work = 'T-001'; last = 'aguardando filho'; at = $old },
    [pscustomobject]@{ type = 'team:developer'; description = 'dev T-001'; desde = $now; session = 's'; parent = 'bExec'; agent_id = 'bDev'; work = 'T-001'; last = 'powershell'; at = $now })
[System.IO.File]::WriteAllText((Join-Path $Root '.team-project/.active-agents'), (ConvertTo-Json -InputObject $list -Depth 3 -Compress), (New-Object System.Text.UTF8Encoding($false)))
Write-NowSection $Root $list
$kb = [System.IO.File]::ReadAllText((Join-Path $Root '.team-project/sprints/1/kanban.md'))
'NOW=' + (([regex]::Match($kb, '(?ms)^## Agora.*?(?=^## )')).Value -replace '\s+', ' ')
$gone = @(Remove-StaleAgents $Root 'Q-S1'); 'GONE=' + (($gone | ForEach-Object { $_.agent_id }) -join ',')
$gone2 = @(Remove-StaleAgents $Root 'T-001'); 'GONE2=' + (($gone2 | ForEach-Object { $_.agent_id }) -join ',')
'LEFT=' + ((@(Get-ActiveAgents $Root) | ForEach-Object { $_.agent_id }) -join ',')
'INT=' + ((@((Get-Content (Join-Path $Root '.team-project/.interrupted') -Raw | ConvertFrom-Json) | ForEach-Object { $_ }) | ForEach-Object { $_.agent_id }) -join ',')
'@, (New-Object System.Text.UTF8Encoding($true)))
$ps63 = Join-Path $tmp 'v3630-stale'; New-Project $ps63; Put $ps63 '.team-project/sprints/1/kanban.md' "# Kanban`n`n## Kanban`n`nx`n"
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $sh63 -Common (Join-Path $checks '../../hooks/common.ps1') -Lib (Join-Path $checks 'lib.ps1') -Root $ps63 2>&1 | Out-String; @{ Code = 0; Out = $o } }
Check 'v3.63.0 I: registro sem sinal há 37 min aparece como "provavelmente encerrado" e sai para o .interrupted; o pai com filho vivo fica' $r 0 @('NOW=.*sem sinal desde \d\d:\d\d — provavelmente encerrado', 'GONE=aExec,aDev\r?\n', 'GONE2=\r?\n', 'LEFT=bExec,bDev\r?\n', 'INT=aExec,aDev')

# ======================= v3.63.1 · diagnóstico automático da falha de cenário, prova no aparelho, alvo preso =======================
# Origem: pedidos do sprint 6 do projeto piloto (18/11). O portão com o gate-h.ps1 da v3.63.0, num projeto git próprio.
$pg64 = Join-Path $tmp 'v3640-gate'
Put $pg64 '.team-project/README.md' "| | |`n|---|---|`n| **Sprint corrente** | **1** — x |`n"
Put $pg64 '.team-project/sprints/1/sprint-backlog.md' "# SB`n`n## História H-1 — x`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok63 T-001 | a | 1 | dev | — | — | — | SC-1 |`n"
Put $pg64 '.team-project/guards.json' '{ "targets": { "web": { "url": "http://127.0.0.1:9" } } }'
Put $pg64 '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-1 um`nlaunch`nassert-exists a`n"
Put $pg64 'src/a.ts' "export const a = 1`n"
$ErrorActionPreference = 'Continue'; & git -C $pg64 init -q 2>$null; Put $pg64 '.gitignore' ".team-project/`n"; & git -C $pg64 add -A 2>$null; & git -C $pg64 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$prod64 = & $lib63 "Get-ProductionTree '$pg64'"; $scn64 = & $lib63 "Get-ScenarioSetHash (Get-SprintScenarioFiles '$pg64')"
$ad64 = Join-Path $pg64 '.team-project/accept/1/S1'; $dg64 = '.team-project/operator/1/S1-alvo/diagnostico.md'
Put $pg64 '.team-project/quality/1/S1/result.json' (@{ id = 'S1'; at = '2026-11-18 08:00:00'; prod = $prod64; rows = @() } | ConvertTo-Json)
$acc64 = { param($at, $envT, $sig, $rows) Put $ad64 'result.json' (@{ task = 'S1'; at = $at; prod = $prod64; scenariosHash = $scn64; environment = $envT; environmentSignal = $sig; passed = 0; total = @($rows).Count; results = @($rows) } | ConvertTo-Json -Depth 5); Start-Sleep -Milliseconds 30 }
& $acc64 '2026-11-18 08:10:00' $null $null @(@{ id = 'SC-1'; status = 'FALHOU'; detail = "passo 'tap tab-estufa': a conexão com a página caiu"; shot = '.team-project/accept/1/S1/shots/SC-1-falha.png'; signal = 'webview-recreated'; signalText = 'a WebView foi recriada no mesmo processo'; log = '.team-project/accept/1/S1/logs/SC-1-1-logcat.txt' })
$r = & $g63 $pg64
Check 'v3.63.1 pedido 1: cenário FALHOU no aceite do portão → o operator diagnostica (capturas, registro do aparelho, sinal) antes do QA julgar, pedindo o elemento e onde' $r 0 @('diagnosticar a falha do aceite antes de o julgamento do QA', 'team:operator', 'cenário\(s\) que falharam: SC-1', 'accept/1/S1/logs/\*-logcat\.txt', "'Elemento: <o id", "'Onde: <tela, aba e posição", "'Dono: QA'", 'operator/1/S1-alvo/diagnostico\.md', 'AMBIENTE SÓ com prova', '^(?![\s\S]*team:quality-assurance)')
Put $pg64 $dg64 "Veredito: PLANO`nCenário: SC-1`nMotivo: WebView recriada`nElemento: tab-estufa`nOnde: barra inferior, 3ª aba`nDono: QA`n"
$r = & $g63 $pg64
Check 'v3.63.1 pedido 1: com o diagnóstico da rodada, o QA julga com o veredito, o elemento e onde (PLANO → scenario com Dono QA)' $r 0 @('julgar \(QA, rodada 1', 'veredito PLANO; elemento: tab-estufa; onde: barra inferior, 3ª aba', 'PLANO → Cause scenario \(Dono QA\)')
& $acc64 '2026-11-18 08:20:00' 'o app br.x não ficou na frente em 3 aberturas de 15 s (foco: nenhum)' @{ kind = 'no-focus'; text = 'o app está rodando (pid 4242) e nenhuma janela dele ficou em foco'; scenario = 'SC-1' } @()
$r = & $g63 $pg64
Check 'v3.63.1 pedidos 2 e 3: "app não ficou na frente" com sinal do app não é ambiente sozinho — diagnóstico antes do reparo (o diagnóstico anterior é de outra rodada)' $r 0 @('diagnosticar a falha do aceite antes de tratar como ambiente', 'interrupção com sinal do app: no-focus: o app está rodando \(pid 4242\)', '^(?![\s\S]*reparar o alvo)')
Put $pg64 $dg64 "Veredito: APP`nCenário: SC-1`nMotivo: app reiniciado`nElemento: tab-estufa`nOnde: aba Estufa`n"
$r = & $g63 $pg64
Check 'v3.63.1 pedido 1: diagnóstico APP da interrupção → a rodada vale como medição e vai ao QA (achado code), sem reparo' $r 0 @('julgar \(QA, rodada 1', 'veredito APP', 'APP → achado com Cause code', '^(?![\s\S]*reparar o alvo)')
& $acc64 '2026-11-18 08:30:00' 'o app br.x não ficou na frente' @{ kind = 'system-window'; text = 'outra janela em foco: Window{1 u0 Application Not Responding: com.android.systemui}'; scenario = 'SC-1' } @()
$r = & $g63 $pg64
Check 'v3.63.1: interrupção com janela do sistema (prova de ambiente) → reparo e retomada direto, sem diagnóstico' $r 0 @('reparar o alvo e repetir o aceite', '^(?![\s\S]*diagnosticar a falha)')
$r = & $g63 $pg64
$r2 = & $g63 $pg64
Check 'v3.63.1 pedido 7: o mesmo result.json pedindo reparo de novo (o aceite não rodou depois) → na 3ª vez, stakeholder em vez de repetir' @{ Code = $r2.Code; Out = "1: $($r.Out)`n2: $($r2.Out)" } 0 @('1: [\s\S]*reparar o alvo e repetir o aceite', '2: [\s\S]*formulário ao stakeholder — o aceite do portão do sprint 1 parou no ambiente — e o aceite não rodou de novo depois de 2 pedidos de reparo', 'target\.ps1 -Target web -Kill encerra o dono da trava')
# Alvo preso (pedidos 5 e 7): um accept.ps1 "órfão" de mentira (o nome do script conta: é o que o -Kill reconhece) e um processo de fora.
$fk64 = Join-Path $tmp 'v3640-fake'; Put $fk64 'accept.ps1' "Start-Sleep -Seconds 90`n"
$orf = Start-Process powershell -ArgumentList @('-NoProfile', '-File', (Join-Path $fk64 'accept.ps1')) -PassThru -WindowStyle Hidden
Start-Sleep -Milliseconds 1500
$orfC = & $lib63 "Get-ProcessCreated $($orf.Id)"
$lk64 = { param($procId, $created) Put $pg64 '.team-project/.target-lock' ('{"target":"web","owner":"accept S1","pid":' + $procId + ',"created":"' + $created + '","desde":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '","dir":".team-project/accept/1/S1"}') }
& $lk64 $orf.Id $orfC
$r = & $g63 $pg64
Check 'v3.63.1 pedido 7: alvo em uso pelo accept do plugin que anda → esperar (watcher), sem reparo nem outro aceite' $r 3 @('PRÓXIMA AÇÃO: esperar — o alvo web está em uso por .accept S1. \(PID \d+', 'WATCHER-LINE', '^(?![\s\S]*reparar o alvo)')
$fora = Start-Process powershell -ArgumentList @('-NoProfile', '-Command', 'Start-Sleep -Seconds 90') -PassThru -WindowStyle Hidden
Start-Sleep -Milliseconds 800
& $lk64 $fora.Id ''
$r = & $g63 $pg64
Check 'v3.63.1 pedido 7: alvo preso por processo que não é do plugin → stakeholder na primeira vez (encerrar à mão e -Unlock), sem repetir' $r 0 @('formulário ao stakeholder — o alvo web está preso por', 'não é um script do plugin reconhecível', 'target\.ps1 -Target web -Unlock', 'RUNLOG: S1 \| portão: alvo preso')
$r = Invoke-Check 'target.ps1' @('-Target', 'web', '-Kill', '-Root', $pg64)
$foraVivo = -not $fora.HasExited
Check 'v3.63.1 pedido 5: target.ps1 -Kill não toca o dono da trava que não é do plugin' @{ Code = $r.Code; Out = "$($r.Out)`nvivo=$foraVivo" } 0 @('não é um script do plugin reconhecível .* não tocado', 'vivo=True')
try { $fora.Kill() } catch { }
& $lk64 $orf.Id $orfC
$r = Invoke-Check 'target.ps1' @('-Target', 'web', '-Kill', '-Root', $pg64)
$null = $orf.WaitForExit(5000)
Check 'v3.63.1 pedido 5: target.ps1 -Kill encerra o accept órfão que segura a trava (e a árvore dele) e apaga a trava' @{ Code = $r.Code; Out = "$($r.Out)`nsaiu=$($orf.HasExited) trava=$(Test-Path -LiteralPath (Join-Path $pg64 '.team-project/.target-lock'))" } 0 @("encerrado o dono da trava 'accept S1' \(PID $($orf.Id)", 'saiu=True trava=False', '^(?![\s\S]*nada registrado)')
$orf2 = Start-Process powershell -ArgumentList @('-NoProfile', '-File', (Join-Path $fk64 'accept.ps1')) -PassThru -WindowStyle Hidden
Start-Sleep -Milliseconds 1500
& $lk64 $orf2.Id '2001-01-01T00:00:00.0000000-03:00'
$r = Invoke-Check 'target.ps1' @('-Target', 'web', '-Kill', '-Root', $pg64)
Check 'v3.63.1 pedido 5: PID reaproveitado (hora de criação diferente da trava) não é tocado pelo -Kill' @{ Code = $r.Code; Out = "$($r.Out)`nvivo=$(-not $orf2.HasExited)" } 0 @('não tocado', 'vivo=True')
try { $orf2.Kill() } catch { }
Remove-Item -LiteralPath (Join-Path $pg64 '.team-project/.target-lock') -Force -ErrorAction SilentlyContinue
# Quem usa o alvo (sprint 6 do piloto, 18/11: um accept, o invólucro e as cópias do detach.ps1 que acompanhavam a mesma rodada
# foram lidos como "três accepts", e dois observadores foram encerrados como duplicados). Dono da trava, duplicado deste projeto
# e um observador; um accept de outro projeto que esteja rodando na máquina aparece como de outro projeto e nunca é tocado.
Put $fk64 'detach.ps1' "Start-Sleep -Seconds 90`n"
$mkA = { Start-Process powershell -ArgumentList @('-NoProfile', '-File', (Join-Path $fk64 'accept.ps1'), '-Task', 'S1', '-Root', $pg64) -PassThru -WindowStyle Hidden }
$accA = & $mkA; $accB = & $mkA
$watW = Start-Process powershell -ArgumentList @('-NoProfile', '-File', (Join-Path $fk64 'detach.ps1'), '-Dir', (Join-Path $pg64 '.team-project\operator\1\S1-accept'), '-Command', '"powershell -NoProfile -File accept.ps1 -Task S1"') -PassThru -WindowStyle Hidden
Start-Sleep -Milliseconds 1800
& $lk64 $accA.Id (& $lib63 "Get-ProcessCreated $($accA.Id)")
$r = Invoke-Check 'target.ps1' @('-Target', 'android', '-Who', '-Root', $pg64)
Check 'v3.63.1: target.ps1 -Who separa o dono da trava, o accept duplicado deste projeto e quem só acompanha (detach.ps1)' $r 0 @("trava: 'accept S1' PID $($accA.Id).* vivo", "accept \(usa o aparelho\): PID $($accA.Id) · -Task S1 .*dono da trava", "accept \(usa o aparelho\): PID $($accB.Id) · -Task S1 .*DUPLICADO \(deste projeto", "acompanhando \(detach\.ps1, não usa o aparelho; encerrá-lo não muda o teste\): PID $($watW.Id)", 'conclusão: DUPLICADO — 2 accepts no aparelho; o dono da trava é o PID', '-KillDuplicates')
$r = Invoke-Check 'target.ps1' @('-Target', 'android', '-Unlock', '-Root', $pg64)
Check 'v3.63.1: target.ps1 -Unlock recusa (exit 4) a trava de um dono vivo — sem ela, o próximo accept entraria ao lado dele' @{ Code = $r.Code; Out = "$($r.Out)`ntrava=$(Test-Path -LiteralPath (Join-Path $pg64 '.team-project/.target-lock'))" } 4 @("trava NÃO removida — o dono 'accept S1' \(PID $($accA.Id)", 'trava=True')
$r = Invoke-Check 'target.ps1' @('-Target', 'android', '-KillDuplicates', '-Root', $pg64)
Start-Sleep -Milliseconds 800; $accA.Refresh(); $accB.Refresh(); $watW.Refresh()
Check 'v3.63.1: target.ps1 -KillDuplicates encerra só o duplicado deste projeto — o dono da trava e quem acompanha ficam' @{ Code = $r.Code; Out = "$($r.Out)`ndono=$(-not $accA.HasExited) dup=$(-not $accB.HasExited) obs=$(-not $watW.HasExited)" } 0 @("duplicado encerrado: accept S1 PID $($accB.Id)", 'dono=True dup=False obs=True')
# A trava de um dono vivo que ainda anda não é tomada nem depois de 3 h (um aceite de 49 cenários passa disso); parado há mais de 3 h, sim.
$adW = Join-Path $pg64 '.team-project/accept/1/S9'   # pasta própria: a accept/1/S1 é a do diagnóstico, logo abaixo
Put $pg64 '.team-project/.target-lock' ('{"target":"android","owner":"accept S1","pid":' + $accA.Id + ',"created":"' + (& $lib63 "Get-ProcessCreated $($accA.Id)") + '","desde":"' + (Get-Date).AddHours(-5).ToString('yyyy-MM-dd HH:mm:ss') + '","dir":".team-project/accept/1/S9"}')
Put $adW 'progress.json' '{ "pid": 1, "passed": 3, "total": 49 }'
$e1 = & $lib63 "`$m = Enter-TargetLock '$pg64' 'android' 'accept S1' 3 '$adW'; if (`$m) { 'M1=' + `$m } else { 'M1=tomou' }"
Get-ChildItem -LiteralPath $adW -Recurse -File | ForEach-Object { $_.LastWriteTime = (Get-Date).AddMinutes(-30) }
$e2 = & $lib63 "`$m = Enter-TargetLock '$pg64' 'android' 'accept S1' 3 '$adW'; if (`$m) { 'M2=' + `$m } else { 'M2=tomou' }"
Check 'v3.63.1: a trava de um dono vivo que grava progresso não é tomada depois de 3 h; parado (sem arquivo, filho nem CPU) há mais de 3 h, sim' @{ Code = 0; Out = "$e1`n$e2" } 0 @("M1=o alvo android está em uso por 'accept S1'", 'M2=tomou')
& $lk64 $accA.Id (& $lib63 "Get-ProcessCreated $($accA.Id)")
$r = Invoke-Check 'detach.ps1' @('-Dir', '.team-project/operator/1/outra', '-Root', $pg64, '-WaitSeconds', '5', '-Command', "powershell -NoProfile -File $(Join-Path $fk64 'accept.ps1') -Task S1")
Check 'v3.63.1: detach.ps1 não abre uma rodada nova de accept com o alvo nas mãos de outro accept vivo (exit 5, sem job)' @{ Code = $r.Code; Out = "$($r.Out)`njob=$(Test-Path -LiteralPath (Join-Path $pg64 '.team-project/operator/1/outra/job.json'))" } 5 @("detach: OCUPADO — o alvo web já está com 'accept S1' \(PID $($accA.Id)", 'Não abro outra rodada de accept', 'job=False')
foreach ($x in @($accA, $accB, $watW)) { try { $x.Kill() } catch { } }
Remove-Item -LiteralPath (Join-Path $pg64 '.team-project/.target-lock') -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $adW -Recurse -Force -ErrorAction SilentlyContinue
# Pedido 6: a trava grava a hora de criação e a pasta do dono; o sinal de vida do alvo preso lê o progress.json dela.
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -Command ". '$(Join-Path $checks 'lib.ps1')'; `$null = Enter-TargetLock '$pg64' 'web' 'accept S1' 3 '$ad64'; Get-Content -Raw '$(Join-Path $pg64 '.team-project/.target-lock')'" 2>&1 | Out-String; @{ Code = 0; Out = $o } }
Check 'v3.63.1 pedidos 5 e 6: a trava do accept grava created e a pasta do accept (accept/1/S1)' $r 0 @('"created":"\d{4}-', '"dir":".team-project/accept/1/S1"')
Remove-Item -LiteralPath (Join-Path $pg64 '.team-project/.target-lock') -Force -ErrorAction SilentlyContinue
# Leitura do diagnóstico: só o da rodada (mais novo que o result.json) vale; Dono e Elemento lidos.
# ======================= v3.63.2 · a trava do aparelho, comum aos projetos da máquina =======================
# Dois projetos com o mesmo emulador: a trava de cada projeto não via o outro, e os dois entravam (e o reparo de um derrubava o
# teste do outro). pA segura o aparelho (um processo vivo com a linha de comando de um accept); pB tenta entrar.
$pA = Join-Path $tmp 'v3632-proj-a'; $pB = Join-Path $tmp 'v3632-proj-b'
Put $pA '.team-project/guards.json' '{ "targets": { "android": { "package": "br.a" } } }'
Put $pB '.team-project/guards.json' '{ "targets": { "android": { "package": "br.b" } } }'
$dlk = Join-Path $env:TEAM_DEVICE_LOCK_DIR 'emulator-teste.json'
$holdA = Start-Process powershell -ArgumentList @('-NoProfile', '-File', (Join-Path $fk64 'accept.ps1'), '-Task', 'T-1', '-Root', $pA) -PassThru -WindowStyle Hidden
Start-Sleep -Milliseconds 1500
$holdC = & $lib63 "Get-ProcessCreated $($holdA.Id)"
Put (Split-Path $dlk) 'emulator-teste.json' ('{"device":"emulator-teste","target":"android","owner":"accept T-1","pid":' + $holdA.Id + ',"created":"' + $holdC + '","desde":"' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '","root":"' + ($pA -replace '\\', '\\') + '"}')
$r = & { $o = & $lib63 "`$m = Enter-TargetLock '$pB' 'android' 'accept T-2'; if (`$m) { 'M=' + `$m } else { 'M=tomou' }; 'PROJ=' + (Test-Path '$(Join-Path $pB '.team-project/.target-lock')')"; @{ Code = 0; Out = "$o" } }
Check 'v3.63.2: o projeto B não entra no aparelho que o projeto A usa — a mensagem diz o projeto, e a trava do projeto B é devolvida' $r 0 @('M=o aparelho emulator-teste está em uso por OUTRO projeto \(.*v3632-proj-a\) — .accept T-1. \(PID \d+', 'targets\.android\.serial', 'PROJ=False')
$r = Invoke-Check 'target.ps1' @('-Target', 'android', '-Who', '-Root', $pB)
Check 'v3.63.2: target.ps1 -Who no projeto B mostra o aparelho com o OUTRO projeto' $r 0 @("aparelho emulator-teste: em uso por 'accept T-1' PID $($holdA.Id).* OUTRO projeto \(.*v3632-proj-a\)")
$r = & { $o = & $lib63 "`$b = Get-TargetBusy '$pB'; 'F=' + `$b.Foreign + ' P=' + `$b.Plugin + ' T=' + `$b.Text"; @{ Code = 0; Out = "$o" } }
Check 'v3.63.2: Get-TargetBusy do projeto B vê o aparelho com o outro projeto (o portão espera o que anda e leva ao stakeholder o parado)' $r 0 @('F=True P=True T=.accept T-1. do OUTRO projeto .*v3632-proj-a.* no aparelho emulator-teste')
Put $pB '.team-project/guards.json' '{ "targets": { "android": { "package": "br.b", "serial": "emulator-5556" } } }'
$r = & { $o = & $lib63 "`$m = Enter-TargetLock '$pB' 'android' 'accept T-2'; 'M=' + `$(if (`$m) { `$m } else { 'tomou' }); 'D=' + (Test-Path '$(Join-Path $env:TEAM_DEVICE_LOCK_DIR 'emulator-5556.json')'); Exit-TargetLock '$pB'; 'DEPOIS=' + (Test-Path '$(Join-Path $env:TEAM_DEVICE_LOCK_DIR 'emulator-5556.json')') + '/' + (Test-Path '$(Join-Path $pB '.team-project/.target-lock')')"; @{ Code = 0; Out = "$o" } }
Check 'v3.63.2: com o seu aparelho declarado (targets.android.serial), o projeto B entra ao lado do A; o Exit-TargetLock devolve as duas travas' $r 0 @('M=tomou', 'D=True', 'DEPOIS=False/False')
try { $holdA.Kill(); $null = $holdA.WaitForExit(5000) } catch { }
Put $pB '.team-project/guards.json' '{ "targets": { "android": { "package": "br.b" } } }'
$r = & { $o = & $lib63 "`$m = Enter-TargetLock '$pB' 'android' 'accept T-2'; 'M=' + `$(if (`$m) { `$m } else { 'tomou' }); 'ROOT=' + ((Get-Content -Raw '$dlk' | ConvertFrom-Json).root)"; @{ Code = 0; Out = "$o" } }
Check 'v3.63.2: trava do aparelho de um dono morto é assumida pelo outro projeto' $r 0 @('M=tomou', 'ROOT=.*v3632-proj-b')
Remove-Item -LiteralPath $dlk, (Join-Path $pB '.team-project/.target-lock') -Force -ErrorAction SilentlyContinue
$r = & { $o = & $lib63 "`$env:TEAM_TEST_DEVICE_SERIAL = ''; 'WEB=' + (Get-DeviceKey '$pg64' 'web') + '|'; 'SERIAL=' + (Get-DeviceKey '$pB' 'android')"; @{ Code = 0; Out = "$o" } }
Check 'v3.63.2: o alvo web não tem trava de aparelho (cada projeto sobe o seu site); sem serial nem aparelho único, o aparelho padrão da máquina' $r 0 @('WEB=\|', 'SERIAL=\S+')

$rdx64 = "`$d = Read-AcceptDiagnosis '$(Join-Path $pg64 $dg64)' '$(Join-Path $ad64 'result.json')'; if (`$d) { 'D=' + `$d.Verdict + '/' + `$d.Owner + '/' + `$d.Element + '/' + `$d.Where } else { 'D=nenhum' }"
$d1 = & $lib63 $rdx64
Start-Sleep -Milliseconds 30; Put $pg64 $dg64 "Veredito: PLANO`nElemento: btn-x`nOnde: topo`nDono: Arquiteto`n"
$d2 = & $lib63 $rdx64
Check 'v3.63.1: Read-AcceptDiagnosis ignora o diagnóstico mais velho que a rodada e lê veredito, dono, elemento e onde' @{ Code = 0; Out = "1:$d1 2:$d2" } 0 @('1:D=nenhum', '2:D=PLANO/Arquiteto/btn-x/topo')

# Sinal da falha no android (pedidos 2 e 3): Get-AndroidFailSignal com o pid e o foco simulados.
$sg64 = Join-Path $tmp 'android-signal.ps1'
[System.IO.File]::WriteAllText($sg64, @'
param([string]$Android)
$ast = [System.Management.Automation.Language.Parser]::ParseFile($Android, [ref]$null, [ref]$null)
foreach ($f in $ast.FindAll({ param($a) $a -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) { if ($f.Name -in 'Get-AndroidFailSignal', 'Get-AndroidInstalledIdentity') { . ([scriptblock]::Create($f.Extent.Text)) } }
$script:Pkg = 'br.x'
function Get-AndroidAppPid { return [int]$env:PID_NOW }
function Get-FocusLine { return $env:FOCUS }
$t = { param($before, $now, $focus, $detail, $main, $crash) $env:PID_NOW = "$now"; $env:FOCUS = $focus; $s = Get-AndroidFailSignal $before $detail @{ Main = @($main); Crash = @($crash) }; "$($s.kind)|$($s.text)" }
'A=' + (& $t 100 0 '' 'x' @('11-18 08:22:31 E AndroidRuntime: FATAL EXCEPTION: main', '11-18 08:22:31 E AndroidRuntime: Process: br.x, PID: 100', '11-18 08:22:31 E AndroidRuntime: java.lang.IllegalStateException: boom') @())
'B=' + (& $t 100 222 '  mCurrentFocus=Window{a u0 br.x/br.x.MainActivity}' 'x' @() @())
'C=' + (& $t 100 100 '  mCurrentFocus=Window{a u0 br.x/br.x.MainActivity}' "passo 'tap a': a conexão com a página caiu (a WebView foi recriada ou o app fechou)" @() @())
'D=' + (& $t 0 4242 '  mCurrentFocus=null' 'o app br.x não ficou na frente em 3 aberturas de 15 s (foco: nenhum)' @() @())
'E=' + (& $t 0 4242 '  mCurrentFocus=Window{b u0 Application Not Responding: com.android.systemui}' 'o app br.x não ficou na frente' @() @())
'F=' + (& $t 100 0 '' 'x' @() @())
'G=' + (& $t 100 100 '' 'x' @('11-18 08:22 E ActivityManager: ANR in br.x (br.x/.MainActivity)') @())
# Identidade do app instalado: pm path → sha1sum do base.apk; sem sha1sum, versão + última instalação.
function Sh { $c = ($args -join ' '); if ($c -like 'pm path*') { return @('package:/data/app/~~q/br.x-1/base.apk', 'package:/data/app/~~q/br.x-1/split_config.arm64.apk') }; if ($c -like 'sha1sum*' -and $env:NO_SHA -ne '1') { return @('0123456789abcdef0123456789abcdef01234567  /data/app/~~q/br.x-1/base.apk') }; if ($c -like 'dumpsys package*') { return @('    versionCode=7 minSdk=24', '    lastUpdateTime=2026-11-18 06:10:02') }; return @('sha1sum: not found') }
'I1=' + (Get-AndroidInstalledIdentity)
$env:NO_SHA = '1'; 'I2=' + (Get-AndroidInstalledIdentity)
'@, (New-Object System.Text.UTF8Encoding($true)))
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $sg64 -Android (Join-Path $checks 'targets/android.ps1') 2>&1 | Out-String; @{ Code = 0; Out = $o } }
Check 'v3.63.1 pedidos 2 e 3: o sinal separa crash, app reiniciado, WebView recriada, sem foco, janela do sistema, app fechado e ANR' $r 0 @('A=crash\|o app fechou com erro \(crash no registro\): java\.lang\.IllegalStateException: boom', 'B=restarted\|o app foi reiniciado \(pid 100 → 222\)', 'C=webview-recreated\|a WebView foi recriada no mesmo processo \(pid 100\)', 'D=no-focus\|o app está rodando \(pid 4242\)', 'E=system-window\|outra janela em foco: Window\{b u0 Application Not Responding', 'F=closed\|o processo do app não está rodando \(era o pid 100\)', 'G=anr\|')
Check 'v3.63.1 pedido 4: a identidade do -Resume é a do app instalado no aparelho (sha1 do base.apk; sem sha1sum, versão + última instalação)' $r 0 @('I1=0123456789ab\r?\n', 'I2=v7@20261118061002')
# Invoke-Once (pedido 2): o app que fecha com erro ao abrir é FALHOU do cenário, com o registro; a janela do sistema segue ambiente.
$io64 = Join-Path $tmp 'accept-once.ps1'
[System.IO.File]::WriteAllText($io64, @'
param([string]$Accept, [string]$Lib, [string]$Root)
$ErrorActionPreference = 'Stop'
. $Lib
$ast = [System.Management.Automation.Language.Parser]::ParseFile($Accept, [ref]$null, [ref]$null)
foreach ($f in $ast.FindAll({ param($a) $a -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) { if ($f.Name -in 'Invoke-Once', 'Get-AcceptFailEvidence', 'Invoke-AcceptBaseline', 'Get-AcceptNoRetryKind', 'Add-AcceptStepTime', 'Get-AcceptTiming', 'Format-AcceptTiming', 'Format-AcceptFresh', 'Test-AcceptFresh', 'Write-AcceptStale') { . ([scriptblock]::Create($f.Extent.Text)) } }
$screenVerbs = @('tap'); $script:Tgt = 'android'; $script:Locator = 'uiautomator'; $script:Attempt = @{}; $script:AdbTimeout = ''; $script:BaseCfg = $null
$script:Shots = Join-Path $Root '.team-project/accept/1/T-1/shots'; New-Item -ItemType Directory -Force $script:Shots | Out-Null
function Clear-AndroidLog { }
function Save-AndroidLog([string]$Path) { New-Item -ItemType Directory -Force (Split-Path $Path) | Out-Null; [System.IO.File]::WriteAllText($Path, 'log'); return @{ Main = @(); Crash = @() } }
function Save-AndroidShot([string]$Path) { }
function Get-AndroidAppPid { return 77 }
function Get-AndroidFailSignal($b, $d, $l) { return [pscustomobject]@{ kind = $env:SIG; text = "sinal $env:SIG" } }
function Invoke-AndroidStep($v, $r, $b) { if ($v -eq 'launch') { throw 'AMBIENTE: o app br.x não ficou na frente em 3 aberturas de 15 s (foco: nenhum)' } }
$b = @{ id = 'SC-9'; title = 't'; steps = @('launch', 'assert-exists a') }
$env:SIG = 'crash'; $o = Invoke-Once $b; "CRASH status=$($o.status) env=$($o.environment) sig=$($o.signal.kind) log=$($o.signal.log) detail=$($o.detail)"
$env:SIG = 'system-window'; $o = Invoke-Once $b; "SYS status=$($o.status) env=$($o.environment) sig=$($o.signal.kind) log=$($o.signal.log)"
'@, (New-Object System.Text.UTF8Encoding($true)))
$po64 = Join-Path $tmp 'v3640-once'; Put $po64 '.team-project/README.md' "| **Sprint corrente** | **1** — x |`n"
$r = & { $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $io64 -Accept (Join-Path $checks 'accept.ps1') -Lib (Join-Path $checks 'lib.ps1') -Root $po64 2>&1 | Out-String; @{ Code = 0; Out = $o } }
Check 'v3.63.1 pedido 2: o app que fecha com erro ao abrir é FALHOU do cenário (não ambiente), com o registro do aparelho; a janela do sistema segue ambiente, com o sinal' $r 0 @('CRASH status=FALHOU env= sig=crash log=\.team-project/accept/1/T-1/logs/SC-9-1-logcat\.txt detail=passo .launch.: sinal crash — o app br\.x não ficou na frente', 'SYS status= env=o app br\.x não ficou na frente .* sig=system-window log=\.team-project/accept/1/T-1/logs/SC-9-2-logcat\.txt')
# done -Result env da Task (pedido 1): com cenário falhado no result.json → diagnóstico antes da rota de ambiente; APP → dev; PLANO/QA → /qa.
$pe64 = Join-Path $tmp 'v3640-env'; New-Project $pe64
Put $pe64 '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
Put $pe64 '.team-project/accept/1/T-041/result.json' '{ "environment": "o app br.x não ficou na frente (foco: nenhum)", "environmentSignal": { "kind": "no-focus", "text": "o app está rodando e nenhuma janela dele ficou em foco", "scenario": "SC-119" }, "results": [ { "id": "SC-118", "status": "FALHOU", "detail": "a conexão com a página caiu", "shot": "x" } ] }'
Start-Sleep -Milliseconds 30
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $pe64)
Check 'v3.63.1 pedido 1: done -Result env com cenário falhado e sinal do app → operator diagnostica antes da rota de ambiente (sem reparo)' $r 0 @('Antes de tratar como ambiente, o operator diagnostica', 'team:operator', 'cenário\(s\) que falharam: SC-118 · interrupção com sinal do app: no-focus', 'operator/1/T-041-alvo/diagnostico\.md', 'done -Task T-041 -Result env de novo', '^(?![\s\S]*target\.ps1 -Target android -Repair)')
Put $pe64 '.team-project/operator/1/T-041-alvo/diagnostico.md' "Veredito: PLANO`nCenário: SC-118`nElemento: tab-estufa`nOnde: barra inferior, 3ª aba`nDono: QA`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $pe64)
Check 'v3.63.1 pedido 1: diagnóstico PLANO com Dono QA → o QA corrige o .scn com o elemento e onde ele fica; o dev volta pelo start' $r 0 @('diagnosticou PLANO na prova da T-041 · elemento: tab-estufa · onde: barra inferior, 3ª aba', 'team:quality-assurance', 'corrija só o\(s\) cenário\(s\) citado\(s\)', 'run\.ps1 start -Task T-041', '^(?![\s\S]*-Repair)')
Put $pe64 '.team-project/operator/1/T-041-alvo/diagnostico.md' "Veredito: APP`nCenário: SC-118`nMotivo: o app perdeu a aba ao recriar a WebView`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $pe64)
Check 'v3.63.1 pedido 1: diagnóstico APP → dev em instância nova com o diagnóstico (defeito, não ambiente)' $r 0 @('diagnosticou APP na prova da T-041', 'run\.ps1 start -Task T-041', '^(?![\s\S]*-Repair)')
Put $pe64 '.team-project/operator/1/T-041-alvo/diagnostico.md' "Veredito: AMBIENTE`nMotivo: janela do sistema`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $pe64)
Check 'v3.63.1: diagnóstico AMBIENTE → a rota de ambiente de sempre (reparo)' $r 0 @('FALHA DE AMBIENTE \(D4\)', 'target\.ps1 -Target android -Repair')

# ======================= v3.64.0 · itens 2 e 5: a evidência que o script já sabe e o cartão que não contradiz o plano =======================
$p64 = Join-Path $tmp 'v3640-done'; New-Project $p64
Remove-Item -LiteralPath (Join-Path $p64 '.team-project/sprints/1/evidence/T-041.md') -Force
Edit-File (Join-Path $p64 '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
Edit-File (Join-Path $p64 '.team-project/sprints/1/burndown.md') "| T-041 | $($e.build) → $($e.qa) | 2026-09-03 15:00 | QA |" ''
Remove-Line (Join-Path $p64 '.team-project/sprints/1/burndown.md') "| 2 | 2026-09-03 15:00 | T-041 $($e.build) → $($e.qa) | 2 | 2 |"
Put $p64 '.team-project/guards.json' '{ "verify": { "suite": "echo ok" } }'
Put $p64 'src/a.ts' "export const a = 1`n"
$ErrorActionPreference = 'Continue'; & git -C $p64 init -q 2>$null; Put $p64 '.gitignore' ".team-project/`n"; & git -C $p64 add -A 2>$null; & git -C $p64 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$pl64 = Join-Path $p64 '.team-project/sprints/1/plan/T-041-export.md'
[System.IO.File]::WriteAllText($pl64, [System.IO.File]::ReadAllText($pl64, $utf8).Replace("## 3. Ambiente", "**Verificação:** comando — ``npm test```n**Aceite:** não roda — sem alvo neste projeto`n**Documentos vivos:** ``docs/api.md```n`n## 3. Ambiente"), $utf8)
$tree64 = & powershell -NoProfile -Command ". '$(Join-Path $checks 'lib.ps1')'; Get-WorkTree '$p64'"
$vr64 = Join-Path $p64 '.team-project/verify/1/T-041/result.json'
$dv64 = Join-Path $p64 '.team-project/sprints/1/delivery/T-041.md'
Put $p64 '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041`n`nrodei a suíte e passou`n"
# B: sem verify full → só um comando falta: o operator roda, sem dev.
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'ok', '-Root', $p64)
Check 'v3.64.0 item 2 B: prova não rodada (sem verify full) → o operator roda o comando, sem dev e sem "não mude código"' $r 0 @('falta RODAR a prova', 'team:operator', 'verify\.ps1 -Task T-041 -Mode full', 'evidência mecânica preenchida pelo script: R12', '^(?![\s\S]*run\.ps1 start -Task T-041)', '^(?![\s\S]*não mude código)')
Check 'v3.64.0 item 2 A: a seção R12 que o dev não escreveu sai do cabeçalho do plano (a consolidar, com os documentos)' @{ Code = 0; Out = [System.IO.File]::ReadAllText($dv64, $utf8) } 0 @('### Documentos vivos \(R12\)\r?\n\*\*Estado:\*\* a consolidar\r?\n\*\*Documentos:\*\* `docs/api\.md` \(do cabeçalho do plano\)')
# C: a mesma reprovação na mesma árvore, de novo → Arquiteto, sem outro operator.
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'ok', '-Root', $p64)
Check 'v3.64.0 item 2 C: a mesma reprovação na mesma árvore pela 2ª vez → Arquiteto (/arc question); nem dev nem operator' $r 0 @('reprovou IGUAL pela 2ª vez', 'Arquiteto em instância nova \(/arc question\)', '^(?![\s\S]*team:operator)')
# Vermelha: suíte com falha → dev em instância normal, que pode mudar código.
Put $p64 '.team-project/verify/1/T-041/result.json' (@{ task = 'T-041'; full = @{ at = '2026-11-18 10:00:00'; tree = "$tree64".Trim(); commands = @(@{ key = 'suite'; command = 'echo ok'; exit = 1; environment = $null }) } } | ConvertTo-Json -Depth 5)
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'ok', '-Root', $p64)
$cd64 = Join-Path $p64 '.team-project/sprints/1/handoff/T-041.md'
Check 'v3.64.0 item 2 B: suíte vermelha → dev em instância nova pelo cartão, que pode mudar código ("O done reprovou", sem "não mude código")' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText($cd64, $utf8) } 0 @('o done reprovou \(a Task segue', 'run\.ps1 start -Task T-041', '\*\*O done reprovou\*\* \(corrija o que falhou', '^(?![\s\S]*não mude código)', '^(?![\s\S]*Só completar a evidência)')
Check 'v3.64.0 item 5 A: o cartão separa o que o plano manda (cópia literal) do que já rodou (etiquetas próprias)' @{ Code = 0; Out = [System.IO.File]::ReadAllText($cd64, $utf8) } 0 @('\*\*O que o plano manda\*\* \(cópia do cabeçalho de `sprints/1/plan/T-041-export\.md`\): \*\*Verificação:\*\* comando — `npm test` · \*\*Aceite:\*\* não roda — sem alvo neste projeto', '\*\*O que já rodou:\*\* \*\*Verify registrado:\*\* full em 2026-11-18 10:00:00: suite exit 1 · \*\*Accept registrado:\*\* nenhum ainda', '^(?![\s\S]*sem verify)')
# A: verify verde na árvore de agora, sem a saída colada → o R7 vale pela prova registrada e o done fecha, copiando o resumo.
Put $p64 '.team-project/verify/1/T-041/result.json' (@{ task = 'T-041'; full = @{ at = '2026-11-18 10:05:00'; tree = "$tree64".Trim(); commands = @(@{ key = 'suite'; command = 'echo ok'; exit = 0; environment = $null }) } } | ConvertTo-Json -Depth 5)
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p64)
Check 'v3.64.0 item 2 A: sem a saída colada, com o verify full verde na árvore de agora → R7 ok pela prova registrada' $r 0 @('\| R7 \| ok \| pela prova registrada: verify full em 2026-11-18 10:05:00')
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'ok', '-Root', $p64)
Check 'v3.64.0 item 2 A: o done fecha e copia a prova registrada para o relatório (o QA lê no portão)' @{ Code = $r.Code; Out = $r.Out + "`n" + [System.IO.File]::ReadAllText($dv64, $utf8) } 0 @('prova registrada copiada para delivery/T-041\.md', 'fechada pela evidência do dev', '### Prova registrada \(gerada pelo run\.ps1 — não editar\)', '> verify full · árvore \S{12} · 2026-11-18 10:05:00', 'suite 0')
# Item 5 B: sem verify registrado e o plano com **Aceite:** não roda → a mensagem do R7 fala só do verify, citando o plano.
$p64b = Join-Path $tmp 'v3640-r7'; New-Project $p64b
Remove-Item -LiteralPath (Join-Path $p64b '.team-project/sprints/1/evidence/T-041.md') -Force
Put $p64b '.team-project/guards.json' '{ "verify": { "suite": "echo ok" }, "targets": { "web": { "url": "http://127.0.0.1:9" } } }'
$pl64b = Join-Path $p64b '.team-project/sprints/1/plan/T-041-export.md'
[System.IO.File]::WriteAllText($pl64b, [System.IO.File]::ReadAllText($pl64b, $utf8).Replace("## 3. Ambiente", "**Aceite:** não roda — laudo`n`n## 3. Ambiente"), $utf8)
Put $p64b '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041`n`nrodei`n`n### Documentos vivos (R12)`n**Estado:** n/a — o Arquiteto consolida no fim`n"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p64b)
# ----- v3.64.0 · item 6: a árvore com dono -----
$p66 = Join-Path $tmp 'v3640-tree'; New-Project $p66
Remove-Item -LiteralPath (Join-Path $p66 '.team-project/sprints/1/evidence/T-041.md') -Force
Edit-File (Join-Path $p66 '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
Put $p66 '.team-project/guards.json' '{ "verify": { "suite": "echo ok" }, "treeIgnore": ["*.zip"] }'
$pl66 = Join-Path $p66 '.team-project/sprints/1/plan/T-041-export.md'
[System.IO.File]::WriteAllText($pl66, [System.IO.File]::ReadAllText($pl66, $utf8).Replace("## 3. Ambiente", "**Arquivos tocados:** ``src/a.ts```n`n## 3. Ambiente"), $utf8)
Put $p66 'src/a.ts' "export const a = 1`n"; Put $p66 'src/b.ts' "export const b = 1`n"
$ErrorActionPreference = 'Continue'; & git -C $p66 init -q 2>$null; Put $p66 '.gitignore' ".team-project/`n"; & git -C $p66 add -A 2>$null; & git -C $p66 -c user.email=t@t -c user.name=t commit -qm i 2>$null; & git -C $p66 config user.email t@t; & git -C $p66 config user.name t; $ErrorActionPreference = 'Stop'
$wt66 = { param($pp) (& powershell -NoProfile -Command ". '$(Join-Path $checks 'lib.ps1')'; Get-WorkTree '$pp'; '|'; (Get-GitPendingFiles '$pp') -join ','" | Out-String) }
$t66a = & $wt66 $p66
Put $p66 'horta_backup.zip' 'zip'
$t66b = & $wt66 $p66
Check 'v3.64.0 item 6 B: arquivo em guards.json → treeIgnore fica fora da impressão da árvore e dos pendentes' @{ Code = 0; Out = "A=$($t66a -replace '\s+', ' ') B=$($t66b -replace '\s+', ' ')" } 0 @('^A=(\S+) \| *B=\1 \|')
Put $p66 'src/a.ts' "export const a = 2`n"
$r = Invoke-Check 'mark.ps1' @('-Task', 'T-041', '-To', 'blocked', '-Reason', 'ambiente: emulador fora do ar', '-Root', $p66)
$log66 = & git -C $p66 log -1 --format='%s%n%b' 2>$null | Out-String
Check 'v3.64.0 item 6 A: Task em 🟨 vai a 🔴 com código do plano no disco → checkpoint só do escopo, com Task-State: parcial; o marcador fica 🔴' @{ Code = $r.Code; Out = $r.Out + "`nLOG=" + $log66 + "`nBOARD=" + [System.IO.File]::ReadAllText((Join-Path $p66 '.team-project/sprints/1/sprint-backlog.md'), $utf8) } 0 @('mark: checkpoint da T-041: \S+ \(1 arquivo\(s\) do plano, sem fechar — parada em 🔴: ambiente: emulador fora do ar\)', 'LOG=T-041 \(checkpoint, sem fechar\): Endpoint de exportação', 'Task-State: parcial', "\| $([char]::ConvertFromUtf32(0x1F534)) T-041 \|")
$t66c = (& powershell -NoProfile -Command ". '$(Join-Path $checks 'lib.ps1')'; Get-WorkTree '$p66'" | Out-String).Trim()
Put $p66 '.team-project/verify/1/T-041/result.json' (@{ task = 'T-041'; full = @{ at = '2026-11-18 11:00:00'; tree = $t66c; commands = @(@{ key = 'suite'; command = 'echo ok'; exit = 0 }) } } | ConvertTo-Json -Depth 5)
Put $p66 'src/b.ts' "export const b = 2`n"
Put $p66 '.team-project/sprints/1/delivery/T-041.md' "## Entrega — T-041`n`nx`n`n### Documentos vivos (R12)`n**Estado:** a consolidar`n"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p66)
Check 'v3.64.0 item 6 D: "a árvore mudou depois do verify" diz o arquivo que mudou' $r 1 @('\| R7-verify \| falhou \| a árvore mudou depois do verify full de 2026-11-18 11:00:00 \(\S+ → \S+\): src/b\.ts — se não é da Task')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p64b)
Check 'v3.64.0 item 5 B: plano com **Aceite:** não roda → o R7 pede só a saída do verify e cita o plano; R12 "n/a" no modo dev vale como a consolidar' $r 1 @('\| R7 \| falhou \| delivery/T-041\.md sem a saída colada do verify na seção mais recente \(plano: \*\*Aceite:\*\* não roda\)', '\| R12 \| ok \| Estado: n/a')

# ----- v3.65.0 A2-06: o checkpoint "sem fechar" na pausa do run e no início de outra Task -----
$pc65 = Join-Path $tmp 'v3650-checkpoint'; New-Project $pc65
$sbc65 = Join-Path $pc65 '.team-project/sprints/1/sprint-backlog.md'
Edit-File $sbc65 "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
Edit-File $sbc65 '](plan/) |' '](plan/T-041a-x.md) |'
$plc65 = Join-Path $pc65 '.team-project/sprints/1/plan/T-041-export.md'
[System.IO.File]::WriteAllText($plc65, [System.IO.File]::ReadAllText($plc65, $utf8).Replace("## 3. Ambiente", "**Arquivos tocados:** ``src/a.ts```n`n## 3. Ambiente"), $utf8)
Put $pc65 '.team-project/sprints/1/plan/T-041a-x.md' "# Plano de Implementação — T-041a Variante`n`n**Arquivos tocados:** ``src/b.ts```n`n### Comandos da Task`n- nenhum além da lista base`n"
Put $pc65 'src/a.ts' "export const a = 1`n"; Put $pc65 'src/b.ts' "export const b = 1`n"
$ErrorActionPreference = 'Continue'; & git -C $pc65 init -q 2>$null; Put $pc65 '.gitignore' ".team-project/`n"; & git -C $pc65 config user.email t@t; & git -C $pc65 config user.name t; & git -C $pc65 add -A 2>$null; & git -C $pc65 commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
Put $pc65 'src/a.ts' "export const a = 2`n"; Put $pc65 'src/b.ts' "export const b = 2`n"
$r = Invoke-Check 'run.ps1' @('pause', '-Because', 'o stakeholder pediu', '-Root', $pc65)
$ErrorActionPreference = 'Continue'; $lg65 = & git -C $pc65 log -1 --format='%s%n%b' 2>$null | Out-String; $st65 = & git -C $pc65 status --porcelain 2>$null | Out-String; $ErrorActionPreference = 'Stop'
Check 'v3.65.0 A2-06: run.ps1 pause → checkpoint "sem fechar" só da Task em 🟨 e só do escopo do plano dela (a ⬜ fica pendente)' @{ Code = $r.Code; Out = $r.Out + "`nLOG=" + $lg65 + "`nST=" + $st65 } 0 @('checkpoint da T-041: \S+ \(1 arquivo\(s\) do plano, sem fechar — pausa do run\)', 'LOG=T-041 \(checkpoint, sem fechar\): Endpoint de exportação', 'Task-State: parcial', 'ST=\s*M src/b\.ts', '^(?![\s\S]*ST=[\s\S]*src/a\.ts)', '^(?![\s\S]*checkpoint da T-041a)')
$r = Invoke-Check 'run.ps1' @('start', '-Task', 'T-041', '-Root', $pc65)
$ErrorActionPreference = 'Continue'; $lg65 = & git -C $pc65 log -1 --format='%s%n%b' 2>$null | Out-String; $st65 = & git -C $pc65 status --porcelain -- src 2>$null | Out-String; $ErrorActionPreference = 'Stop'
Check 'v3.65.0 A2-06: run.ps1 start com pendente do escopo de OUTRA Task aberta → checkpoint dela antes do dev, com Task-State: parcial' @{ Code = $r.Code; Out = $r.Out + "`nLOG=" + $lg65 + "`nST=[" + $st65.Trim() + ']' } 0 @('run start: checkpoint da T-041a: \S+ \(1 arquivo\(s\) do plano, sem fechar — arquivos pendentes dela no início da T-041\)', 'LOG=T-041a \(checkpoint, sem fechar\): Variante', 'Task-State: parcial', 'ST=\[\]', 'dispatch: developer · T-041')

# ----- v3.65.0 A2-06/A2-08: o portão antes de medir (checkpoint das abertas; suíte só reaproveitada por inputs → verify -Fresh)
# e a Q11, que recusa a cobertura com reusedBy: inputs -----
$pq65 = Join-Path $tmp 'v3650-gate'
Put $pq65 '.team-project/README.md' "| | |`n|---|---|`n| **Sprint corrente** | **1** — x |`n"
Put $pq65 '.team-project/sprints/1/sprint-backlog.md' "# SB`n`n## História H-1 — x`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $($e.ok) T-001 | a | 1 | dev | — | — | — | — |`n| $($e.qa) T-002 | b | 1 | dev | — | [plan/T-002.md](plan/T-002.md) | — | — |`n"
Put $pq65 '.team-project/sprints/1/plan/T-002.md' "# Plano — T-002 b`n`n**Arquivos tocados:** ``src/b.ts```n"
Put $pq65 '.team-project/guards.json' '{ "quality": { "coverage": "Write-Output \"Total coverage 42 %\"" } }'
Put $pq65 'src/a.ts' "export const a = 1`n"; Put $pq65 'src/b.ts' "export const b = 1`n"
$ErrorActionPreference = 'Continue'; & git -C $pq65 init -q 2>$null; Put $pq65 '.gitignore' ".team-project/`n"; & git -C $pq65 config user.email t@t; & git -C $pq65 config user.name t; & git -C $pq65 add -A 2>$null; & git -C $pq65 commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
Put $pq65 'src/b.ts' "export const b = 2`n"; Put $pq65 'tools/z.txt' "sobra`n"
$r = & $g63 $pq65
$ErrorActionPreference = 'Continue'; $lg65q = & git -C $pq65 log -1 --format='%s%n%b' 2>$null | Out-String; $ErrorActionPreference = 'Stop'
Check 'v3.65.0 A2-06: portão antes de medir → checkpoint "sem fechar" da Task não fechada (escopo do plano) e o pendente sem dono avisado' @{ Code = $r.Code; Out = $r.Out + "`nLOG=" + $lg65q } 0 @('checkpoint da T-002: \S+ \(1 arquivo\(s\) do plano, sem fechar — antes da medição do portão\)', 'atenção: pendente sem commit no disco, que a medição inclui: tools/z\.txt', 'medir \(operator', 'LOG=T-002 \(checkpoint, sem fechar\): b', 'Task-State: parcial')
Remove-Item -LiteralPath (Join-Path $pq65 'tools') -Recurse -Force
$tr65 = & $lib63 "Get-WorkTree '$pq65'"
Put $pq65 '.team-project/verify/1/T-001/coverage.log' "All files  |  91.5 %`n"
$vr65 = { param($reused) $c = @(@{ key = 'suite'; command = 'echo ok'; exit = 0 }, @{ key = 'coverage'; command = 'echo cov'; exit = 0; log = '.team-project/verify/1/T-001/coverage.log' }); if ($reused) { foreach ($cc in $c) { $cc.reusedBy = 'inputs' } }; Put $pq65 '.team-project/verify/1/T-001/result.json' (@{ task = 'T-001'; full = @{ at = '2026-11-19 10:00:00'; tree = "$tr65".Trim(); commands = $c } } | ConvertTo-Json -Depth 5) }
& $vr65 $true
$r = & $g63 $pq65
Check 'v3.65.0 A2-08: a suíte desta árvore só existe reaproveitada por inputs → o portão manda verify -Mode full -Fresh antes da qualidade' $r 0 @('verify\.ps1 -Task S1 -Mode full -Fresh e \S*quality\.ps1 -Id S1', 'suíte: só reaproveitada por inputs nesta árvore')
$r = Invoke-Check 'quality.ps1' @('-Id', 'S1', '-Root', $pq65)
Check 'v3.65.0 A2-08: Q11 recusa a cobertura reaproveitada por inputs — roda quality.coverage (42 %, falhou)' $r 1 @('Q11 falhou: .*42 % medido × limiar 80 %', '^(?![\s\S]*reaproveitada do verify full)')
& $vr65 $false
Remove-Item -LiteralPath (Join-Path $pq65 '.team-project/quality') -Recurse -Force -ErrorAction SilentlyContinue   # o quality.ps1 acima gravou a medição: sem ela, o portão mede de novo
$r = & $g63 $pq65
Check 'v3.65.0 A2-08: suíte rodada de fato nesta árvore → o portão mede só a qualidade, sem verify -Fresh' $r 0 @('medir \(operator', 'quality\.ps1 -Id S1', '^(?![\s\S]*-Mode full -Fresh)')
$r = Invoke-Check 'quality.ps1' @('-Id', 'S1', '-Root', $pq65)
Check 'v3.65.0 A2-08: Q11 com a cobertura rodada de fato no verify full da mesma árvore → reaproveitada (91.5 %)' $r 0 @('Q11 ok: .*reaproveitada do verify full da T-001 .*mesma árvore.*91\.5 % medido')

# ======================= v3.65.10 · o app no aparelho é o código da árvore? =======================
# Origem: sprint 6 do garden (20–21/11). Sem targets.android.apk, o accept não achava APK local e seguia calado: as rodadas 6
# a 12 rodaram sobre o APK da Q-S6f (apk:731dfab5b3fd), "tag não encontrada" virou APP e a Q-S6h passou a ✅ sem a mudança.
$ok10 = [char]::ConvertFromUtf32(0x2705); $pa10 = Join-Path $tmp 'v36510-fresh'
Put $pa10 '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
Put $pa10 'source/src/tela.ts' "export const t = 1`n"; Put $pa10 'server/api.ts' "export const s = 1`n"
$ErrorActionPreference = 'Continue'; & git -C $pa10 init -q 2>$null; Put $pa10 '.gitignore' ".team-project/`ndist/`n"; & git -C $pa10 add -A 2>$null; & git -C $pa10 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$tr10 = (& $lib63 "Get-WorkTree '$pa10'").Trim()
$acc10 = { param($rel, $app, $tree, $at) Put $pa10 $rel (@{ task = 'T-001'; target = 'android'; at = $at; tree = $tree; app = $app; passed = 1; total = 1; results = @(@{ id = 'SC-1'; status = 'PASSOU' }) } | ConvertTo-Json -Depth 5) }
& $acc10 '.team-project/accept/1/T-001/result.json' 'apk:731dfab5b3fd' $tr10 '2026-11-20 11:10:00'
$hsE = "`$h = Get-InstalledAppStaleness '$pa10' 'apk:731dfab5b3fd'; 'S=' + `$h.Stale + '|' + `$h.Since + '|' + (`$h.Files -join ',') + '|' + `$h.Dir"
$a1 = & $lib63 $hsE
Put $pa10 'source/src/tela.spec.ts' "test`n"
$a2 = & $lib63 $hsE
Put $pa10 'source/src/tela.ts' "export const t = 2 // manejo-semeio.insumos.unidade`n"
$a3 = & $lib63 $hsE
$a4 = & $lib63 "`$h = Get-InstalledAppStaleness '$pa10' 'apk:0000aaaa1111'; 'S=' + `$h.Stale"
# Só o servidor mudou, com targets.android.apkSources = o código web: não é app velho.
Edit-File (Join-Path $pa10 'source/src/tela.ts') 'export const t = 2 // manejo-semeio.insumos.unidade' 'export const t = 1'
Put $pa10 'server/api.ts' "export const s = 2`n"
$a5 = & $lib63 $hsE
Put $pa10 '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x", "apkSources": ["source/src"] } } }'
$a6 = & $lib63 $hsE
Put $pa10 'server/api.ts' "export const s = 1`n"
Check 'v3.65.10 A: o mesmo app de uma rodada anterior e o código do app mudado desde ela → app velho (teste e servidor fora das apkSources não contam); outro app, não' @{ Code = 0; Out = "A1=$a1`nA2=$a2`nA3=$a3`nA4=$a4`nA5=$a5`nA6=$a6" } 0 @('A1=S=False\|', 'A2=S=False\|', 'A3=S=True\|2026-11-20 11:10:00\|source/src/tela\.ts\|\.team-project/accept/1/T-001', 'A4=S=False', 'A5=S=True\|.*server/api\.ts', 'A6=S=False\|')
# O APK local reconstruído depois da mudança (mesmos bytes) não é app velho; a cópia igual mais velha conta pela data dela (D).
Put $pa10 'source/src/tela.ts' "export const t = 3`n"
New-Item -ItemType Directory -Force (Join-Path $pa10 'dist') | Out-Null
$apkA = Join-Path $pa10 'dist/app-Q-S6-debug.apk'; [System.IO.File]::WriteAllBytes($apkA, [byte[]](1..200)); (Get-Item $apkA).LastWriteTime = (Get-Date).AddMinutes(-30)
$apkB = Join-Path $pa10 'dist/app-Q-S6d-debug.apk'; [System.IO.File]::WriteAllBytes($apkB, [byte[]](1..200)); (Get-Item $apkB).LastWriteTime = (Get-Date).AddMinutes(5)
(Get-Item (Join-Path $pa10 'source/src/tela.ts')).LastWriteTime = (Get-Date).AddMinutes(-10)
$d1 = & $lib63 "`$s = Get-ApkStaleness '$apkB' '$pa10'; 'ST=' + `$s.Stale + '|' + (Split-Path `$s.Twin -Leaf) + '|' + (Split-Path `$s.File -Leaf)"
$d2 = & $lib63 "`$h = Get-InstalledAppStaleness '$pa10' 'apk:731dfab5b3fd' '$apkB'; 'S=' + `$h.Stale"
[System.IO.File]::WriteAllBytes($apkB, [byte[]](1..201)); (Get-Item $apkB).LastWriteTime = (Get-Date).AddMinutes(5)
$d3 = & $lib63 "`$s = Get-ApkStaleness '$apkB' '$pa10'; 'ST=' + `$s.Stale + '|tw=' + `$s.Twin; `$h = Get-InstalledAppStaleness '$pa10' 'apk:731dfab5b3fd' '$apkB'; 'S=' + `$h.Stale"
Check 'v3.65.10 D: o APK igual byte a byte a uma cópia mais velha conta pela cópia (mais velho que o código); o APK novo de verdade, depois da mudança, não é velho' @{ Code = 0; Out = "D1=$d1`nD2=$d2`nD3=$d3" } 0 @('D1=ST=True\|app-Q-S6-debug\.apk\|tela\.ts', 'D2=S=True', 'D3=ST=False\|tw=\s*S=False')
Remove-Item -LiteralPath (Join-Path $pa10 'dist') -Recurse -Force
# B: o aviso quando não há APK local.
$b1 = & $lib63 "'N=' + (Get-ApkDeclarationNote '$pa10')"
Put $pa10 '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x", "apk": "dist/app-*-debug.apk", "apkSources": ["source/src"] } } }'
$b2 = & $lib63 "'N=' + (Get-ApkDeclarationNote '$pa10')"
Put (Join-Path $tmp 'v36510-web') '.team-project/guards.json' '{ "targets": { "web": { "url": "http://127.0.0.1:9" } } }'; $b3 = & $lib63 "'N=' + (Get-ApkDeclarationNote '$(Join-Path $tmp 'v36510-web')')"
Check 'v3.65.10 B: alvo android sem APK local → aviso (sem declaração, pede apk e apkSources; com máscara que não casa, diz isso); alvo web, nada' @{ Code = 0; Out = "B1=$b1`nB2=$b2`nB3=$b3" } 0 @('B1=N=nenhum APK local \(targets\.android\.apk não declarado.*declare no guards\.json targets\.android\.apk', "B2=N=targets\.android\.apk 'dist/app-\*-debug\.apk' não casa nenhum arquivo", 'B3=N=\s*$')
Put $pa10 '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
# A e C pelo accept: Test-AcceptFresh com as funções do accept.ps1 (sem aparelho).
$hs10 = Join-Path $tmp 'accept-fresh.ps1'
[System.IO.File]::WriteAllText($hs10, @'
param([string]$Accept, [string]$Lib, [string]$Root, [string]$App)
$ErrorActionPreference = 'Stop'
. $Lib
$utf8 = New-Object System.Text.UTF8Encoding($false); $Task = 'S1'
$ast = [System.Management.Automation.Language.Parser]::ParseFile($Accept, [ref]$null, [ref]$null)
foreach ($f in $ast.FindAll({ param($a) $a -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) { if ($f.Name -in 'Test-AcceptFresh', 'Write-AcceptStale', 'Format-AcceptFresh') { . ([scriptblock]::Create($f.Extent.Text)) } }
$script:Tgt = 'android'; $script:AppId = $App; $script:Installed = $false; $script:ScnFiles = @()
$script:ApkDeclNote = Get-ApkDeclarationNote $Root ''
$d = Join-Path $Root '.team-project/accept/1/S1'
$c = Test-AcceptFresh $d '' $null
"CODE=$c"
'FRESH=' + (($script:Fresh | ConvertTo-Json -Compress))
'MD=' + (Format-AcceptFresh)
if (Test-Path (Join-Path $d 'result.json')) { 'RESULT=' + ([System.IO.File]::ReadAllText((Join-Path $d 'result.json')) -replace '\s+', ' ') }
'@, (New-Object System.Text.UTF8Encoding($true)))
$af10 = { param($app) $ErrorActionPreference = 'Continue'; $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $hs10 -Accept (Join-Path $checks 'accept.ps1') -Lib (Join-Path $checks 'lib.ps1') -Root $pa10 -App $app 2>&1 | Out-String; @{ Code = $LASTEXITCODE; Out = $o } }
$r = & $af10 'apk:731dfab5b3fd'
Check 'v3.65.10 A: o accept recusa o app instalado igual ao de uma rodada anterior com o código mudado (exit 2, staleApp no result.json, sem cenários)' $r 0 @('o app instalado \(apk:731dfab5b3fd\) é o mesmo da rodada de 2026-11-20 11:10:00 \(\.team-project/accept/1/T-001\), e o código do app mudou desde ela \(1 arquivo\(s\): source/src/tela\.ts\)', 'Reconstrua o APK e instale-o', 'CODE=2', 'RESULT=.*"staleApp":\s*"o app instalado', 'RESULT=.*"total":\s*0')
# v3.65.12: o Arquiteto atestou estes bytes (alarme falso da conferência) → o accept segue; atestação de outro hash não vale.
$at12 = Join-Path $pa10 '.team-project/apk-attest.json'
Put $pa10 '.team-project/apk-attest.json' '{ "hash": "731dfab5b3fd", "by": "architect", "why": "o conteúdo que entra no app não mudou desde o APK", "at": "2026-11-22 09:30" }'
Remove-Item -LiteralPath (Join-Path $pa10 '.team-project/accept/1/S1/result.json') -Force -ErrorAction SilentlyContinue
$r = & $af10 'apk:731dfab5b3fd'
Check 'v3.65.12: app instalado atestado pelo Arquiteto (o mesmo hash) → o accept segue (exit 0), sem a recusa, conferido pelo Arquiteto' $r 0 @('CODE=0', 'atestado pelo Arquiteto como o código da árvore', 'FRESH=\{"checked":true,.*"attest":"o conteúdo que entra no app não mudou', 'MD=\s*\*\*App no aparelho:\*\* apk:731dfab5b3fd · sem APK local · frescor: conferido pelo Arquiteto', '^(?![\s\S]*Reconstrua o APK)')
Put $pa10 '.team-project/apk-attest.json' '{ "hash": "999999999999", "by": "architect", "why": "outro build", "at": "2026-11-22 09:30" }'
$r = & $af10 'apk:731dfab5b3fd'
Check 'v3.65.12: atestação de outro hash não vale → a recusa de sempre (exit 2)' $r 0 @('CODE=2', 'Reconstrua o APK e instale-o')
Remove-Item -LiteralPath $at12 -Force
$r = & $af10 'apk:5555bbbb6666'
Check 'v3.65.10 B/C: app novo sem APK local → segue (exit 0) com o frescor NÃO conferido, o motivo e o aviso — o elemento ausente não vira APP' $r 0 @('atenção — frescor do app não conferido \(apk:5555bbbb6666\): sem APK local \(o aviso acima\)', 'CODE=0', 'FRESH=\{"checked":false,"installed":"apk:5555bbbb6666","build":null,"reason":"nenhum APK local', 'MD=\s*\*\*App no aparelho:\*\* apk:5555bbbb6666 · sem APK local · frescor: \*\*não conferido\*\*')
# C: o diagnóstico APP sem frescor conferido vale PLANO com o Arquiteto; com frescor (ou result.json antigo, sem o campo), APP.
$rc10 = Join-Path $pa10 '.team-project/accept/1/S2/result.json'; $dc10 = Join-Path $pa10 '.team-project/operator/1/S2-alvo/diagnostico.md'
$c10 = { param($fresh) $o = [ordered]@{ task = 'S2'; target = 'android'; at = '2026-11-21 10:00:00'; app = 'apk:731dfab5b3fd'; results = @() }; if ($null -ne $fresh) { $o.fresh = [ordered]@{ checked = $fresh; installed = 'apk:731dfab5b3fd'; build = $null; reason = 'nenhum APK local' } }; Put $pa10 '.team-project/accept/1/S2/result.json' ($o | ConvertTo-Json -Depth 5); Start-Sleep -Milliseconds 50; Put $pa10 '.team-project/operator/1/S2-alvo/diagnostico.md' "Veredito: APP`nCenário: SC-161`nMotivo: elemento ausente`nElemento: manejo-semeio.insumos.unidade`n"; (& $lib63 "`$d = Read-AcceptDiagnosis '$dc10' '$rc10'; `$d.Verdict + '|' + `$d.Owner + '|' + `$d.Reason") }
$cA = & $c10 $false; $cB = & $c10 $true; $cC = & $c10 $null
Check 'v3.65.10 C: diagnóstico APP com fresh.checked false → PLANO, Dono Arquiteto, "build não conferido"; com frescor conferido ou sem o campo, APP' @{ Code = 0; Out = "C1=$cA`nC2=$cB`nC3=$cC" } 0 @('C1=PLANO\|Arquiteto\|build não conferido — o app no aparelho \(apk:731dfab5b3fd\) não foi conferido com o build da árvore: nenhum APK local \(o operator disse APP: elemento ausente\)', 'C2=APP\|\|elemento ausente', 'C3=APP\|')
$pr10 = & $lib63 "Get-AcceptDiagPrompt 'sessão S1' 'S1' '.team-project/accept/1/S1' 'x/diagnostico.md' 'android' 'P' `$null"
Check 'v3.65.10 C: o prompt do diagnóstico pede a linha App/build/frescor e diz que APP só vale com fresh.checked = true' @{ Code = 0; Out = $pr10 } 0 @("'App: <fresh\.installed", 'APP só com o campo fresh\.checked = true', "'Motivo: build não conferido")
# C no done da Task: -Result gap e -Result env com APP sem frescor → PLANO, ao Arquiteto (não ao dev).
$pt10 = Join-Path $tmp 'v36510-done'; New-Project $pt10
Put $pt10 '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
Put $pt10 '.team-project/accept/1/T-041/result.json' '{ "target": "android", "app": "apk:731dfab5b3fd", "fresh": { "checked": false, "installed": "apk:731dfab5b3fd", "build": null, "reason": "nenhum APK local" }, "results": [ { "id": "SC-161", "status": "FALHOU", "detail": "tag não encontrada: manejo-semeio.insumos.unidade", "shot": "x" } ] }'
Start-Sleep -Milliseconds 50
Put $pt10 '.team-project/sprints/1/delivery/T-041.md' "## Entrega`n`n🔺 GAP (aceite/alvo): tag não encontrada: manejo-semeio.insumos.unidade`n"
Start-Sleep -Milliseconds 50
Put $pt10 '.team-project/operator/1/T-041-alvo/diagnostico.md' "Veredito: APP`nCenário: SC-161`nMotivo: elemento ausente`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'gap', '-Root', $pt10)
Check 'v3.65.10 C: done -Result gap com APP e o frescor do app não conferido → vale PLANO (Arquiteto), não dev novo' $r 0 @('diagnosticou APP na prova da T-041, mas o app no aparelho \(apk:731dfab5b3fd\) não foi conferido com o build da árvore: nenhum APK local', 'Vale PLANO: o Arquiteto decide', '^(?![\s\S]*defeito do código, não do alvo nem do plano)')
Put $pt10 '.team-project/accept/1/T-041/result.json' '{ "target": "android", "app": "apk:731dfab5b3fd", "environment": "o app br.x não ficou na frente (foco: nenhum)", "environmentSignal": { "kind": "no-focus", "text": "nenhuma janela dele ficou em foco", "scenario": "SC-161" }, "fresh": { "checked": false, "installed": "apk:731dfab5b3fd", "build": null, "reason": "nenhum APK local" }, "results": [ { "id": "SC-161", "status": "FALHOU", "detail": "tag não encontrada: manejo-semeio.insumos.unidade", "shot": "x" } ] }'
Start-Sleep -Milliseconds 50
Put $pt10 '.team-project/operator/1/T-041-alvo/diagnostico.md' "Veredito: APP`nCenário: SC-161`nMotivo: elemento ausente`n"
$r = Invoke-Check 'run.ps1' @('done', '-Task', 'T-041', '-Result', 'env', '-Root', $pt10)
Check 'v3.65.10 C: done -Result env com APP e o frescor não conferido → PLANO ao Arquiteto, que decide reconstruir e reinstalar antes de mudar código' $r 0 @('o operator disse APP, mas o app no aparelho \(apk:731dfab5b3fd\) não foi conferido', 'team:architect', 'decida reconstruir e reinstalar o APK e repetir o accept', '^(?![\s\S]*defeito do código, não do alvo)')
# v3.65.12 (garden S6, 22/11): a data mais nova que o APK sem mudança de conteúdo não é app velho; conteúdo mudado (na cópia
# de trabalho ou num commit posterior) e arquivo fora do git, sim.
$pc12 = Join-Path $tmp 'v36512-conteudo'
Put $pc12 'source/src/tela.html' "<p>a</p>`n"; Put $pc12 'source/dist/app-debug.apk' 'APK1'
$ErrorActionPreference = 'Continue'; & git -C $pc12 init -q 2>$null; & git -C $pc12 add -A 2>$null; & git -C $pc12 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
Put $pc12 '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x", "apk": "source/dist/app-*.apk", "apkSources": ["source/src"] } } }'
$apk12 = Join-Path $pc12 'source/dist/app-debug.apk'; $tela12 = Join-Path $pc12 'source/src/tela.html'
# O APK depois do commit; a fonte com a data mais nova que o APK e o mesmo conteúdo do commit (o caso do garden).
(Get-Item $apk12).LastWriteTime = (Get-Date).AddMinutes(1); (Get-Item $tela12).LastWriteTime = (Get-Date).AddMinutes(5)
$c1 = & $lib63 "`$s = Get-ApkStaleness '$apk12' '$pc12'; 'S=' + `$s.Stale"
Set-Content -LiteralPath $tela12 "<p>b</p>" -Encoding UTF8; (Get-Item $tela12).LastWriteTime = (Get-Date).AddMinutes(5)
$c2 = & $lib63 "`$s = Get-ApkStaleness '$apk12' '$pc12'; 'S=' + `$s.Stale + '|' + (Split-Path `$s.File -Leaf)"
$ErrorActionPreference = 'Continue'; & git -C $pc12 checkout -q -- source/src/tela.html 2>$null; $ErrorActionPreference = 'Stop'
Put $pc12 'source/src/nova.ts' "export const n = 1`n"; (Get-Item (Join-Path $pc12 'source/src/nova.ts')).LastWriteTime = (Get-Date).AddMinutes(5); (Get-Item $tela12).LastWriteTime = (Get-Date).AddMinutes(5)
$c3 = & $lib63 "`$s = Get-ApkStaleness '$apk12' '$pc12'; 'S=' + `$s.Stale + '|' + (Split-Path `$s.File -Leaf)"
Check 'v3.65.12: idade do APK pelo conteúdo — fonte só com a data mais nova não é app velho; conteúdo mudado ou arquivo novo, sim' @{ Code = 0; Out = "C1=$c1`nC2=$c2`nC3=$c3" } 0 @('C1=S=False', 'C2=S=True\|tela\.html', 'C3=S=True\|nova\.ts')
$h12 = & $lib63 "Get-FileHash12 '$apk12'"
Put $pc12 '.team-project/apk-attest.json' "{ `"hash`": `"$h12`", `"by`": `"architect`", `"why`": `"prova`", `"at`": `"agora`" }"
$c4 = & $lib63 "'A=' + [bool](Get-ApkAttest '$pc12' '$h12') + '|B=' + [bool](Get-ApkAttest '$pc12' 'apk:$h12') + '|C=' + [bool](Get-ApkAttest '$pc12' '000000000000')"
Put $pc12 '.team-project/apk-attest.json' "{ `"hash`": `"$h12`", `"by`": `"architect`", `"why`": `"`", `"at`": `"agora`" }"
$c5 = & $lib63 "'D=' + [bool](Get-ApkAttest '$pc12' '$h12')"
Check 'v3.65.12: atestação do Arquiteto vale só para o hash dela (com ou sem apk:) e só com a prova (why)' @{ Code = 0; Out = "$c4`n$c5" } 0 @('A=True\|B=True\|C=False', 'D=False')
# O portão: o accept recusado manda reconstruir e reinstalar (operator), não medir de novo nem julgar; recusado de novo, ao stakeholder.
$pg10 = Join-Path $tmp 'v36510-gate'
Put $pg10 '.team-project/README.md' "| | |`n|---|---|`n| **Sprint corrente** | **1** — x |`n"
Put $pg10 '.team-project/sprints/1/sprint-backlog.md' "# SB`n`n## História H-1 — x`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok10 T-001 | a | 1 | dev | — | — | — | SC-1 |`n"
Put $pg10 '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
Put $pg10 '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-1 um`nlaunch`nassert-exists a`n"
Put $pg10 'src/a.ts' "export const a = 1`n"
$ErrorActionPreference = 'Continue'; & git -C $pg10 init -q 2>$null; Put $pg10 '.gitignore' ".team-project/`n"; & git -C $pg10 add -A 2>$null; & git -C $pg10 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$prod10 = & $lib63 "Get-ProductionTree '$pg10'"; $scn10 = & $lib63 "Get-ScenarioSetHash (Get-SprintScenarioFiles '$pg10')"
Put $pg10 '.team-project/quality/1/S1/result.json' (@{ id = 'S1'; at = '2026-11-21 08:00:00'; prod = $prod10; rows = @() } | ConvertTo-Json)
$st10 = { param($at) Put $pg10 '.team-project/accept/1/S1/result.json' (@{ task = 'S1'; target = 'android'; at = $at; prod = $prod10; scenariosHash = $scn10; app = 'apk:731dfab5b3fd'; staleApp = 'o app instalado (apk:731dfab5b3fd) é o mesmo da rodada de 2026-11-20 11:10:00, e o código do app mudou desde ela'; environment = $null; passed = 0; total = 0; results = @() } | ConvertTo-Json -Depth 5) }
& $st10 '2026-11-21 09:00:00'
$r = & $g63 $pg10
Check 'v3.65.10: portão com o accept recusado (app de antes do código) → reconstruir e reinstalar pelo build do projeto e repetir o aceite; sem QA nem nova medição por cima' $r 0 @('reconstruir e reinstalar o app, depois repetir o aceite', 'team:operator', 'Gere o APK pelo build do projeto', 'mesmo com o hash igual ao de antes', 'accept\.ps1 -Task S1 -Resume', '^(?![\s\S]*team:quality-assurance)', '^(?![\s\S]*formulário)')
# v3.65.12 (garden S6, 22/11): o operator devolveu "o mesmo hash" sem repetir o aceite — o mesmo result.json não pede a mesma
# reconstrução de novo (era o laço): vai ao Arquiteto, sem formulário.
$r = & $g63 $pg10
Check 'v3.65.12: o mesmo result.json recusado depois do pedido de reconstruir → Arquiteto (o build é do time), sem formulário nem novo pedido ao operator' $r 0 @('a reconstrução pedida não deu um app com o código da árvore → /arc question', 'team:architect', 'Primeiro confira se a recusa procede', 'alarme falso da conferência do plugin\. Grave \.team-project/apk-attest\.json', '\.team-project/note\.md um item .defeito do plugin', 'Ache a causa no caminho da fonte ao APK', 'accept\.ps1 -Task S1 -Resume', 'nada vai ao stakeholder', 'você não precisa fazer nada', '^(?![\s\S]*formulário)', '^(?![\s\S]*team:operator)')
$r = & $g63 $pg10
Check 'v3.65.12: o mesmo aceite recusado depois do Arquiteto → formulário ao stakeholder em texto simples (sem build, cache, hash nem arquivo na fala)' $r 0 @('formulário ao stakeholder — o Arquiteto já tratou a geração do app', 'PARA O STAKEHOLDER: .*A revisão final está parada: a versão do app usada nos testes não está saindo com as últimas correções', '^(?![\s\S]*PARA O STAKEHOLDER:[^\r\n]*(apk|hash|cache|build|APK))')
# Recusado de novo por um aceite novo (o operator repetiu o aceite): a 2ª recusa vai ao Arquiteto, a 3ª ao stakeholder.
Remove-Item -LiteralPath (Join-Path $pg10 '.team-project/sprints/1/gate.json') -Force -ErrorAction SilentlyContinue
& $st10 '2026-11-21 10:00:00'; $r = & $g63 $pg10
Check 'v3.65.12: nova recusa, 1ª vez → operator reconstrói e repete o aceite' $r 0 @('team:operator', '^(?![\s\S]*team:architect)')
& $st10 '2026-11-21 10:30:00'; $r = & $g63 $pg10
Check 'v3.65.12: recusado de novo por um aceite novo depois do pedido → Arquiteto, não o stakeholder' $r 0 @('/arc question', 'team:architect', '^(?![\s\S]*formulário)')
& $st10 '2026-11-21 11:00:00'; $r = & $g63 $pg10
Check 'v3.65.12: recusado ainda depois do Arquiteto (aceite novo) → formulário ao stakeholder' $r 0 @('formulário ao stakeholder — o Arquiteto já tratou a geração do app', '^(?![\s\S]*team:operator)')
Remove-Item -LiteralPath (Join-Path $pg10 '.team-project/accept') -Recurse -Force
$r = & $g63 $pg10
Check 'v3.65.10 B: portão que vai medir o aceite com alvo android sem APK local → o aviso da declaração junto do pedido de medir' $r 0 @('atenção \(guards\.json, do stakeholder; v3\.65\.10\): nenhum APK local', 'medir \(operator')

# ======================= v3.65.11 · o app que a correção provou × o app da medição do portão =======================
# Garden S6 (21/11 21:13 → 22/11 02:21): o aceite do portão rodou com o app de antes da correção (731dfab5); as Q-S6i, j e k
# provaram o SC-161 com o app novo (eb971aea), sem mudar a produção, e o QA julgou a mesma rodada velha três vezes.
$pg11 = Join-Path $tmp 'v36511-gate'
Put $pg11 '.team-project/README.md' "| | |`n|---|---|`n| **Sprint corrente** | **1** — x |`n"
Put $pg11 '.team-project/sprints/1/sprint-backlog.md' "# SB`n`n## História H-1 — x`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok10 T-001 | a | 1 | dev | — | — | — | SC-1 |`n`n## Correção do portão — sprint 1`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok10 Q-S1 | corrige S1-F1 | 1 | dev | — | — | — | SC-1 |`n"
Put $pg11 '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
Put $pg11 '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-1 um`nlaunch`nassert-exists a`n"
Put $pg11 'src/a.ts' "export const a = 1`n"
$ErrorActionPreference = 'Continue'; & git -C $pg11 init -q 2>$null; Put $pg11 '.gitignore' ".team-project/`n"; & git -C $pg11 add -A 2>$null; & git -C $pg11 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$prod11 = & $lib63 "Get-ProductionTree '$pg11'"; $scn11 = & $lib63 "Get-ScenarioSetHash (Get-SprintScenarioFiles '$pg11')"
Put $pg11 '.team-project/quality/1/S1/result.json' (@{ id = 'S1'; at = '2026-11-21 21:00:00'; prod = $prod11; rows = @() } | ConvertTo-Json)
$acc11 = { param($task, $at, $app, $st) Put $pg11 ".team-project/accept/1/$task/result.json" (@{ task = $task; target = 'android'; at = $at; prod = $prod11; scenariosHash = $scn11; app = $app; environment = $null; passed = $(if ($st -eq 'PASSOU') { 1 } else { 0 }); total = 1; results = @(@{ id = 'SC-1'; status = $st; detail = $(if ($st -eq 'PASSOU') { '' } else { 'tag não encontrada: insumos.unidade' }); shot = '' }) } | ConvertTo-Json -Depth 5) }
& $acc11 'S1' '2026-11-21 21:13:35' 'apk:731dfab5b3fd' 'FALHOU'
& $acc11 'Q-S1' '2026-11-22 00:42:13' 'apk:eb971aea13b1' 'PASSOU'
Put $pg11 '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $fail63 reprovado — 2026-11-21`n`n## Frentes`n| Front | State | Round | Proof |`n|---|---|---|---|`n| functional | fail | 1 | x |`n`n## Achados`n| ID | Task | Achado | Onde | Cause | Owner | State |`n|---|---|---|---|---|---|---|`n| S1-F1 | T-001 | SC-1 falha: tag não encontrada | a.ts:1 | code | dev | open |`n"
$r = & $g63 $pg11
Check 'v3.65.11 A: a Q-S fechada provou o cenário com outro app, na mesma produção e depois da medição → o operator mede o aceite de novo (só ele), sem correção nova nem formulário' $r 0 @('medir \(operator.*aceite: o app mudou desde a medição — a Q-S1 provou SC-1 com o app apk:eb971aea13b1 \(2026-11-22 00:42:13\), e o aceite do portão \(2026-11-21 21:13:35\) rodou com apk:731dfab5b3fd', 'accept\.ps1 -Task S1 -Resume', 'o app a medir é o que a Q-S1 provou \(apk:eb971aea13b1\)', 'RUNLOG: S1 \| portão: a Q-S1 provou SC-1 com outro app', 'a correção já passou no teste dela com a versão nova do app', '^(?![\s\S]*quality\.ps1)', '^(?![\s\S]*abrir Q-S)', '^(?![\s\S]*PRÓXIMA AÇÃO: formulário)', '^(?![\s\S]*\.\.)')
# O portão mais novo que a correção, com outro app da mesma produção: o aparelho não tem o app provado → o caminho do app velho.
& $acc11 'S1' '2026-11-22 01:50:00' 'apk:731dfab5b3fd' 'FALHOU'
$r = & $g63 $pg11
Check 'v3.65.11 A: o aceite do portão, mais novo que a correção, rodou com outro app da mesma produção → reconstruir e reinstalar (o caminho do app velho da v3.65.10), sem QA' $r 0 @('reconstruir e reinstalar o app, depois repetir o aceite', 'a Q-S1 provou SC-1 com o app apk:eb971aea13b1, da mesma produção', '^(?![\s\S]*team:quality-assurance)', '^(?![\s\S]*abrir Q-S)')
# O mesmo app nas duas rodadas, já julgadas: contradição → o Arquiteto decide a causa uma vez; depois, o caminho de antes.
Remove-Item -LiteralPath (Join-Path $pg11 '.team-project/sprints/1/gate.json') -Force -ErrorAction SilentlyContinue
& $acc11 'Q-S1' '2026-11-22 00:42:13' 'apk:731dfab5b3fd' 'PASSOU'
Start-Sleep -Milliseconds 50; Put $pg11 '.team-project/operator/1/S1-alvo/diagnostico.md' "Veredito: APP`nCenário: SC-1`nMotivo: elemento ausente`n"
$r = & $g63 $pg11
Check 'v3.65.11 B: o cenário passou na correção recém-fechada (ainda não julgada) e falhou no portão com o mesmo app e a mesma produção → /arc question (degrau 1), antes de uma rodada do QA sobre a mesma prova e sem abrir outra Q-S' $r 0 @('S1-F1: o mesmo app passou na Q-S1 e falhou no portão → /arc question', 'team:architect', 'Mudar o código de novo não muda esse resultado', 'RUNLOG: S1 \| portão: S1-F1 — SC-1 passou na Q-S1', '^(?![\s\S]*abrir Q-S)', '^(?![\s\S]*team:quality-assurance)')
Put $pg11 '.team-project/sprints/1/delivery/Q-S1.md' "# entrega`n"; (Get-Item -LiteralPath (Join-Path $pg11 '.team-project/sprints/1/delivery/Q-S1.md')).LastWriteTime = (Get-Date).AddHours(-2)
$r = & $g63 $pg11
Check 'v3.65.11 B: o Arquiteto já foi chamado para a contradição → o caminho de antes (a resolução dele governa; sem ela, correção nova)' $r 0 @('abrir Q-S1[a-z] — correção do portão: S1-F1', '^(?![\s\S]*o mesmo app passou)')
# Itens 1, 2 e 4 da revisão do QA: a correção que fechou sem mudar nada, a que não mudou a produção, e o resumo da rodada.
$pg12 = Join-Path $tmp 'v36511-noop'
Put $pg12 '.team-project/README.md' "| | |`n|---|---|`n| **Sprint corrente** | **1** — x |`n"
Put $pg12 '.team-project/sprints/1/sprint-backlog.md' "# SB`n`n## História H-1 — x`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok10 T-001 | a | 1 | dev | — | — | — | SC-1 |`n`n## Correção do portão — sprint 1`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok10 Q-S1 | corrige S1-F1 | 1 | dev | — | — | — | SC-1 |`n"
Put $pg12 '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
Put $pg12 '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-1 um`nlaunch`nassert-exists a`n"
Put $pg12 'src/a.ts' "export const a = 1`n"
$ErrorActionPreference = 'Continue'; & git -C $pg12 init -q 2>$null; Put $pg12 '.gitignore' ".team-project/`n"; & git -C $pg12 add -A 2>$null; & git -C $pg12 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$prod12 = & $lib63 "Get-ProductionTree '$pg12'"; $scn12 = & $lib63 "Get-ScenarioSetHash (Get-SprintScenarioFiles '$pg12')"; $tree12 = & $lib63 "Get-WorkTree '$pg12'"
Put $pg12 '.team-project/quality/1/S1/result.json' (@{ id = 'S1'; at = '2026-11-21 21:00:00'; prod = $prod12; rows = @() } | ConvertTo-Json)
Put $pg12 '.team-project/accept/1/S1/result.json' (@{ task = 'S1'; target = 'android'; at = '2026-11-21 21:13:35'; tree = $tree12; prod = $prod12; scenariosHash = $scn12; app = 'apk:731dfab5b3fd'; environment = $null; passed = 0; total = 1; results = @(@{ id = 'SC-1'; status = 'FALHOU'; detail = 'tag não encontrada: insumos.unidade'; shot = '' }) } | ConvertTo-Json -Depth 5)
Put $pg12 '.team-project/sprints/1/gate.json' (@{ round = 1; judged = @{ prod = $prod12; scn = $scn12; accept = '2026-11-21 21:13:35'; quality = '2026-11-21 21:00:00'; qs = '' } } | ConvertTo-Json -Depth 4)
Put $pg12 '.team-project/operator/1/S1-alvo/diagnostico.md' "Veredito: APP`nCenário: SC-1`nMotivo: elemento ausente`n"
Start-Sleep -Milliseconds 50
Put $pg12 '.team-project/sprints/1/validation.md' "# V`n**Veredito:** $fail63 reprovado — 2026-11-21`n`n## Frentes`n| Front | State | Round | Proof |`n|---|---|---|---|`n| functional | fail | 1 | x |`n`n## Achados`n| ID | Task | Achado | Onde | Cause | Owner | State |`n|---|---|---|---|---|---|---|`n| S1-F1 | T-001 | SC-1 falha: tag não encontrada | a.ts:1 | code | dev | open |`n"
$r = & $g63 $pg12
Check 'v3.65.11 item 2: a Q-S fechou sem mudar nada desde a medição (a árvore é a mesma) → o operator mede de novo uma vez, sem rodada do QA nem correção nova' $r 0 @('medir \(operator.*aceite: a Q-S1 fechou sem mudar nada desde a medição', 'a correção terminou sem precisar mudar nada', 'RUNLOG: S1 \| portão: a Q-S1 fechou sem mudar nada', '^(?![\s\S]*team:quality-assurance)', '^(?![\s\S]*abrir Q-S)')
$r = & $g63 $pg12
Check 'v3.65.11 item 1: já medida de novo (gate.json → noop), a prova é a mesma e a única novidade é a Q-S fechada sem mudar a produção → /arc question uma vez, sem rodada do QA sobre a mesma prova' $r 0 @('S1-F1: a Q-S1 fechou sem mudar o app nem os cenários → /arc question', 'team:architect', 'RUNLOG: S1 \| portão: S1-F1 — a Q-S1 fechou sem mudar a produção', '^(?![\s\S]*team:quality-assurance)', '^(?![\s\S]*medir \(operator)')
$r = & $g63 $pg12
$sum12 = Join-Path $pg12 '.team-project/sprints/1/proof/S1/round-2/abertos.md'; $st12 = if (Test-Path -LiteralPath $sum12) { [System.IO.File]::ReadAllText($sum12, $utf8) -replace '\s+', ' ' } else { 'SEM-RESUMO' }
Check 'v3.65.11 item 4: depois do Arquiteto, a rodada focada do QA lê o resumo dos achados abertos (abertos.md, com o último veredito), não o validation.md inteiro' @{ Code = $r.Code; Out = "$($r.Out)`nSUM=$st12" } 0 @('revisar o veredito \(QA, instância nova, rodada 2 focada\)', 'resumo dos achados abertos: \.team-project/sprints/1/proof/S1/round-2/abertos\.md', 'não releia o validation\.md inteiro', 'SUM=.*Último veredito:\*\* .*reprovado.*\| S1-F1 \| T-001 \| SC-1 falha')
# A declaração do APK inferida do disco.
$pa11 = Join-Path $tmp 'v36511-apk'
Put $pa11 'source/dist/garden-T-063-debug.apk' 'a'; Put $pa11 'source/dist/garden-Q-S6d-debug.apk' 'bb'; Put $pa11 'source/capacitor.config.ts' 'x'; Put $pa11 'source/src/main.ts' 'x'; Put $pa11 'source/node_modules/pkg/lixo.apk' 'z'
$i1 = & $lib63 "`$c = Find-ApkCandidate '$pa11'; 'F=' + `$c.Found + '|A=' + `$c.Apk + '|S=' + (`$c.Sources -join ',')"
Put $pa11 'outro/app.apk' 'c'
$i2 = & $lib63 "`$c = Find-ApkCandidate '$pa11'; 'F=' + `$c.Found + '|N=' + `$c.Note"
Remove-Item -LiteralPath (Join-Path $pa11 'outro') -Recurse -Force
Check 'v3.65.11: a declaração do APK se infere do disco (uma pasta: a máscara do nome e, no híbrido, src/ e o capacitor.config; node_modules fora); APKs em duas pastas → ambíguo, sem inferência' @{ Code = 0; Out = "I1=$i1`nI2=$i2" } 0 @('I1=F=True\|A=source/dist/garden-\*-debug\.apk\|S=source/src,source/capacitor\.config\.ts', 'I2=F=False\|N=APKs em 2 pastas')
Put $pa11 '.team-project/README.md' "| | |`n|---|---|`n| **Sprint corrente** | **1** — x |`n"
Put $pa11 '.team-project/sprints/1/sprint-backlog.md' "# SB`n`n## História H-1 — x`n`n| ID | Task | Est. | Dono | Depende de | Plano | Evidência | Cenários |`n|---|---|---|---|---|---|---|---|`n| $ok10 T-001 | a | 1 | dev | — | — | — | SC-1 |`n"
Put $pa11 '.team-project/guards.json' '{ "targets": { "android": { "package": "br.x" } } }'
Put $pa11 '.team-project/quality-assurance/scenarios/a.scn' "scenario SC-1 um`nlaunch`nassert-exists a`n"
$ErrorActionPreference = 'Continue'; & git -C $pa11 init -q 2>$null; Put $pa11 '.gitignore' ".team-project/`n*.apk`n"; & git -C $pa11 add -A 2>$null; & git -C $pa11 -c user.email=t@t -c user.name=t commit -qm i 2>$null; $ErrorActionPreference = 'Stop'
$r = & $g63 $pa11
Check 'v3.65.11: portão que vai medir o aceite sem o APK declarado e inferível → a sessão declara antes de medir (sem formulário), com o valor inferido' $r 0 @('declarar o APK do projeto antes de medir o aceite \(a sessão; sem formulário', '"apk": "source/dist/garden-\*-debug\.apk", "apkSources": \["source/src", "source/capacitor\.config\.ts"\]', 'como desfazer', 'RUNLOG: S1 \| portão: APK do projeto sem declaração e inferível', '^(?![\s\S]*team:operator)')

# ==== fim dos casos ====
try { Stop-Process -Id $script:watchdog.Id -Force -ErrorAction SilentlyContinue } catch { }
Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
$rows | Format-Table -AutoSize | Out-String -Width 200 | Write-Output
foreach ($sl in @($rows | Sort-Object Seg -Descending | Select-Object -First 12)) { $sn = [string]$sl.Caso; Write-Output ("lento: {0,5} s  {1}" -f $sl.Seg, $(if ($sn.Length -gt 120) { $sn.Substring(0, 120) } else { $sn })) }
Write-Output ("soma dos casos: {0} s" -f (($rows | Measure-Object Seg -Sum).Sum))
Write-Output ("{0} casos · {1} falharam" -f $rows.Count, $fail)
if ($fail -gt 0) { exit 1 }
exit 0
