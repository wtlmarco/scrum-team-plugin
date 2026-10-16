# Resposta do stakeholder simulado no modo benchmark, quando o AskUserQuestion não existe (v3.50.1).
# Sob `claude -p` a ferramenta AskUserQuestion não é oferecida à sessão, então a guarda G18 (que a nega e devolve o dossiê)
# nunca dispara. Aqui a sessão consulta o mesmo dossiê (guards.json → bench.answers) pela mesma lógica da G18 e grava a
# pergunta em .team-project/benchmark/<arm>/questions.log.
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/bench-answer.ps1" -Question "<pergunta>" -Header "<cabeçalho>" -Options "Opção A|Opção B" [-Root <projeto>]
# Saída: "[bench] resposta do stakeholder: <rótulo>". Exit 0 · 2 = modo benchmark desligado ou sem dossiê (a pergunta é do stakeholder).
param(
    [Parameter(Mandatory = $true)][string]$Question,
    [string]$Header = '',
    [Parameter(Mandatory = $true)][string]$Options,   # os rótulos separados por | (o -File do powershell colapsa uma lista em uma string só)
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '..\..\hooks\common.ps1')

$cfg = Get-GuardConfig $Root
$form = [pscustomobject]@{
    questions = @([pscustomobject]@{
        question = $Question
        header   = $Header
        options  = @($Options -split '\|' | ForEach-Object { $_.Trim() } | Where-Object { $_ } | ForEach-Object { [pscustomobject]@{ label = $_ } })
    })
}
$answers = Get-BenchAnswers $cfg $Root $form
if ($null -eq $answers) {
    [Console]::Error.WriteLine('bench-answer: modo benchmark desligado ou sem dossiê (guards.json → bench.answers) — a pergunta é do stakeholder.')
    exit 2
}
Write-Output ("[bench] " + (Format-BenchAnswers $answers))
exit 0
