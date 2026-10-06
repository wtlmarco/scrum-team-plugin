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
- **Standard aplicável:** ```${CLAUDE_PLUGIN_ROOT}/standards/implementation-guide.md`` §3 — contrato

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

function Invoke-Check([string]$Script, [string[]]$Arguments) {
    $ErrorActionPreference = 'Continue'   # no 5.1, stderr de processo filho com 2>&1 viraria exceção
    $out = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $checks $Script) @Arguments 2>&1 | Out-String
    return @{ Code = $LASTEXITCODE; Out = $out }
}

function Edit-File([string]$Path, [string]$From, [string]$To) {
    $t = [System.IO.File]::ReadAllText($Path, $utf8); [System.IO.File]::WriteAllText($Path, $t.Replace($From, $To), $utf8)
}

function Remove-Line([string]$Path, [string]$Line) {
    $t = [System.IO.File]::ReadAllText($Path, $utf8); [System.IO.File]::WriteAllText($Path, ($t -replace ([regex]::Escape($Line) + '\r?\n'), ''), $utf8)
}

$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('team-checks-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
$rows = @(); $fail = 0
function Check([string]$Name, $Result, [int]$Code, [string[]]$Expect) {
    $ok = $Result.Code -eq $Code
    foreach ($x in $Expect) { if ($Result.Out -notmatch $x) { $ok = $false } }
    if (-not $ok) { $script:fail++; Write-Output "---- $Name (exit $($Result.Code))"; Write-Output $Result.Out }
    $script:rows += [pscustomobject]@{ Caso = $Name; Exit = $Result.Code; Ok = $(if ($ok) { 'ok' } else { 'FALHOU' }) }
}

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
$warn = [char]::ConvertFromUtf32(0x26A0); $x = [char]::ConvertFromUtf32(0x274C)
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
Check 'Consumo: medidas entram, manual e sessão ficam, sem duplicar' $r 0 @('3 linha\(s\) medida\(s\), 3 mantida', 'operator \| haiku \| `Agent` · suite \| T-041 \| verificação \| H-014 \| 40.000', 'chamado por dev; medido: o1#1', '\| dev \| haiku .*\| retrabalho \| H-014 \| 100.000', '\| operator ← dev \| haiku \| 40.000 \| 1 ', '\| operator ← qa \| haiku \| 0 \| 1 \| 00:30 \| 500 \|', 'linha de sessão')
if (([regex]::Matches($r.Out, 'medido: d1#1')).Count -ne 1) { $fail++; Write-Output '---- consumo duplicou a linha medida' }
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 depois do consumo medido: R28 conta a linha do operator da Task' $r 0 @('\| R28 \| falhou.*1 report.*2 linha')
Put $p '.team-project/sprints/1/retrospective.md' "# Retro`n"
$r = Invoke-Check 'consumption.ps1' @('-Root', $p)
Check 'Consumo: sprint fechado não recebe linha' $r 0 @('está fechado')

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
Check 'verify mutation: M1 pega, árvore restaurada igual' $r 0 @('restaurada igual', 'M1 src/calc.ts: ok')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R7-mutação ok' $r 0 @('\| R7-verify \| ok', '\| R7-mutação \| ok.*1 mutação')
Edit-File (Join-Path $p $pl) '- M1 · teste' "- M2 · teste ``tests/check.ps1`` · ``src/calc.ts`` · ``// fim`` → ``// x```n- M1 · teste"
$r = Invoke-Check 'verify.ps1' @('-Task', 'T-041', '-Mode', 'mutation', '-Plan', $pl, '-Only', 'M2', '-Root', $p)
Check 'verify mutation decorativa (-Only M2): exit 1' $r 1 @('M2 src/calc.ts: falhou')
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 R7-mutação com M2 não pega (M1 da amostra anterior mantida)' $r 1 @('\| R7-mutação \| falhou.*não pegas: M2')

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

# 5f. plan.ps1 (v3.46): o plano é conferido antes do dev.
$p = Join-Path $tmp 'plano'; New-Project $p
$pl = '.team-project/sprints/1/plan/T-050-x.md'; $fence = '```'
Put $p $pl ("# Plano`n`n**Arquivos tocados:** ``src/a.ts```n``tests/a.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 4. Passos`n`n### Passo 1 — x`n- **Assinatura exata:**`n  $fence`n  export function a(): number`n  $fence`n`n## 6. Testes`n`n**Mutações:**`n- M1 · teste ``tests/a.spec.ts`` · ``src/a.ts`` · ``return 1`` → ``return 0```n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano em contrato: exit 0' $r 0 @('\| lista \| ok', '\| protegidos \| ok', '\| blocos \| n-a', '\| trecho \| ok', '\| mutação \| ok.*1 muta')
$long = (1..20 | ForEach-Object { "  linha $_" }) -join "`n"
Put $p $pl ("# Plano`n`n**Arquivos tocados:** " + ((1..9 | ForEach-Object { "``src/f$_.ts``" }) -join "`n") + "`n`n## 4. Passos`n`n### Passo 1 — x`n$fence`n$long`n$fence`n`n## 6. Testes`n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano com código longo, 9 arquivos sem bloco, sem teste, sem mutação, sem protegidos: exit 1' $r 1 @('\| lista \| falhou', '\| protegidos \| falhou', '\| blocos \| falhou.*9 arquivos', '\| trecho \| falhou.*Passo 1 \(20 linhas\)', '\| mutação \| falhou', 'não vai ao dev')
Put $p $pl ("# Plano`n**Trilha:** leve`n`n**Arquivos tocados:** " + ((1..5 | ForEach-Object { "``src/f$_.ts``" }) -join "`n") + "`n``tests/f.spec.ts```n`n**Arquivos protegidos:** nenhum`n`n## 6. Testes`nsem prova: só configuração`n")
$r = Invoke-Check 'plan.ps1' @('-Plan', $pl, '-Root', $p)
Check 'Plano leve com 6 arquivos: volta à plena' $r 1 @('\| leve \| falhou.*6 arquivos', '\| mutação \| ok.*sem prova')

# 6. Duas Tasks em construção com 1 dev → R1 falhou; T-041 não confunde com T-041a.
$p = Join-Path $tmp 'r1'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.qa) T-041 |" "| $($e.build) T-041 |"
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| $($e.todo) T-041a |" "| $($e.build) T-041a |"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 duas em construção: R1 falhou' $r 0 @('\| R1 \| falhou.*T-041.*T-041a')

# 7. Erro de uso: sem .team-project → exit 2.
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $tmp)
Check 'C1 sem .team-project: exit 2' $r 2 @()

# 8. C2 no projeto feliz (sem git: R31 n-a).
$p = Join-Path $tmp 'feliz'
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
}

# 10. C4 (fix.ps1): bloco B-001 com um defeito, um ajuste e uma promovida.
$ck = [char]::ConvertFromUtf32(0x2714)
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

Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
$rows | Format-Table -AutoSize | Out-String -Width 200 | Write-Output
Write-Output ("{0} casos · {1} falharam" -f $rows.Count, $fail)
if ($fail -gt 0) { exit 1 }
exit 0
