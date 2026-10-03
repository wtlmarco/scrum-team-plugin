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

## Registro de transições (dado bruto do burndown — R24)

| Task | De → Para | Quando | Por quem |
|---|---|---|---|
| T-041 | $($e.todo) → $($e.plan) | 2026-09-01 | Arquiteto |
| T-041 | $($e.plan) → $($e.build) | 2026-09-02 | dev |
| T-041 | $($e.build) → $($e.qa) | 2026-09-03 | QA |

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
| 1 | 2026-09-02 | — | 2 | 2 |
"@
}

function Invoke-Check([string]$Script, [string[]]$Arguments) {
    $ErrorActionPreference = 'Continue'   # no 5.1, stderr de processo filho com 2>&1 viraria exceção
    $out = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $checks $Script) @Arguments 2>&1 | Out-String
    return @{ Code = $LASTEXITCODE; Out = $out }
}

function Edit-File([string]$Path, [string]$From, [string]$To) {
    $t = [System.IO.File]::ReadAllText($Path, $utf8); [System.IO.File]::WriteAllText($Path, $t.Replace($From, $To), $utf8)
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
Check 'C1 feliz: exit 0, nenhuma regra falhou' $r 0 @('\| R7 \| ok', '\| R12 \| ok', '\| R1 \| ok', '\| R4 \| ok', '\| R8 \| ok', '\| R16 \| ok', '\| R20 \| ok', '\| R24 \| n-a', '\| R25 \| ok', '\| R26 \| ok', '\| R28 \| ok', '\| R30 \| ok')
if ($r.Out -match '\| falhou \|') { $fail++; Write-Output '---- feliz com falhou:'; Write-Output $r.Out }

# 2. -Post sem a linha → ✅ falha R24; com a linha, ok.
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Post', '-Root', $p)
Check 'C1 -Post sem → ✅: R24 falhou' $r 0 @('\| R24 \| falhou')
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') "| T-041 | $($e.build) → $($e.qa) | 2026-09-03 | QA |" ("| T-041 | $($e.build) → $($e.qa) | 2026-09-03 | QA |`n| T-041 | $($e.qa) → $($e.ok) | 2026-09-04 | SM (``/sm close``) |")
Edit-File (Join-Path $p '.team-project/sprints/1/burndown.md') '| 1 | 2026-09-02 | — | 2 | 2 |' ("| 1 | 2026-09-02 | — | 2 | 2 |`n| 2 | 2026-09-04 | T-041 $($e.ok) | 1 | 1 |")
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Post', '-Root', $p)
Check 'C1 -Post com → ✅ e burndown: R24 ok' $r 0 @('\| R24 \| ok')

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

# 5. Fora do plano com arquivo, cenário sem resultado, operator sem linha de consumo, construção antes do pacote.
$p = Join-Path $tmp 'varios'; New-Project $p
Edit-File (Join-Path $p '.team-project/sprints/1/evidence/T-041.md') '**Fora do plano:** nada' '**Fora do plano:** src/Extra.cs'
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') 'SC-014 (novo)' 'SC-014 (novo), SC-020 (regressivo)'
Edit-File (Join-Path $p '.team-project/sprints/1/sprint-backlog.md') '| **Aprovado em** | 2026-09-01 |' '| **Aprovado em** | 2026-09-05 |'
Put $p '.team-project/operator/1/job2/report.md' "# report 2`n"
$r = Invoke-Check 'close.ps1' @('-Task', 'T-041', '-Root', $p)
Check 'C1 falhas não bloqueantes: exit 0' $r 0 @('\| R4 \| falhou.*src/Extra.cs', '\| R30 \| falhou.*SC-020', '\| R28 \| falhou.*2 report', '\| R20 \| falhou')

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
    Check 'C2 dossiê de aceite fora da Review: R21 falhou' $r 0 @('\| R21 \| falhou')
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

# 9. C3 num repositório-fonte mínimo: versão divergente e bloco acima da barreira.
$rp = Join-Path $tmp 'fonte'
Put $rp '.claude-plugin/plugin.json' '{ "name": "team", "version": "9.1.0" }'
Put $rp 'README.md' "# Plugin`n`n> **Versão atual: v9.1.0** · x`n"
Put $rp 'CHANGELOG.md' "# Changelog`n`n## v9.1.0 — 2026-10-02`n`nx`n"
Put $rp 'roles/scrum-master/process/process-changelog.md' "# Processo`n`n## v9.1 — Teste (SM) — 02/10/2026`n`ncurto`n`n---`n"
Put $rp 'roles/scrum-master/templates/modelo.md' "# modelo`n"
Put $rp 'roles/scrum-master/README.md' "usa templates/modelo.md`n"
$r = Invoke-Check 'release.ps1' @('-Root', $rp)
Check 'C3 fonte coerente: exit 0' $r 0 @('\| R18 \| ok', '\| R17 \| ok', '\| órfãos \| ok')
Put $rp 'README.md' "# Plugin`n`n> **Versão atual: v9.0.0** · x`n"
Put $rp 'roles/scrum-master/process/process-changelog.md' ("# Processo`n`n## v9.1 — Teste (SM) — 02/10/2026`n`n" + ('x' * 11000) + "`n`n---`n")
Remove-Item -LiteralPath (Join-Path $rp 'roles/scrum-master/README.md')
$r = Invoke-Check 'release.ps1' @('-Root', $rp)
Check 'C3 versão divergente, bloco grande, órfão: exit 1' $r 1 @('\| R18 \| falhou.*v9\.0\.0', '\| R17 \| falhou.*barreira 10240', '\| órfãos \| aviso')

Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
$rows | Format-Table -AutoSize | Out-String -Width 200 | Write-Output
Write-Output ("{0} casos · {1} falharam" -f $rows.Count, $fail)
if ($fail -gt 0) { exit 1 }
exit 0
