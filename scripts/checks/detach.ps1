# Comando longo em processo próprio (v3.62.2) — para o operator e qualquer papel cujo comando possa passar de ~2 min.
# O Claude Code ENCERRA o comando do agente que ele moveu para segundo plano quando o agente dá a resposta final ("it is
# terminated when you give your final response and no notification can follow that"), com a árvore inteira. Este script roda
# o comando num processo criado pelo WMI, fora dessa árvore (Start-DetachedJob, lib.ps1), e só o ACOMPANHA por até
# -WaitSeconds (padrão 480, abaixo dos 600 s da ferramenta: a chamada nunca vai para segundo plano).
# Uso (raiz do projeto; timeout da ferramenta 600000 ms):
#   powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/detach.ps1" -Dir <pasta do job> -Command "<comando>"
#   … de novo, o MESMO comando na MESMA pasta: volta a acompanhar a rodada viva (não abre outra) e entrega o resultado.
#   … -Dir <pasta> -Kill: encerra a rodada viva da pasta (só ela e os filhos dela).
# Saída: a última parte da saída do comando e o caminho do log (<Dir>/output.log, saída inteira com stderr).
# Exit: o do comando quando ele terminou (a linha diz "terminou · exit N") · 3 = RODANDO (rode o mesmo comando de novo, no
# mesmo turno) · 4 = a rodada caiu sem resultado ou o WMI não a criou (ambiente) · 5 = outro comando roda nesta pasta · 2 = uso.
param(
    [Parameter(Mandatory = $true)][string]$Dir,
    [string]$Command = '',
    [int]$WaitSeconds = 480,
    [switch]$Kill,
    [int]$Tail = 15,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$out = { param([string]$s) [Console]::Out.WriteLine($s) }
try {
    $full = if ([System.IO.Path]::IsPathRooted($Dir)) { $Dir } else { Join-Path $Root $Dir }
    if ($Kill) {
        $n = Stop-DetachedJob $full
        & $out $(if ($n) { "detach -Kill: rodada de $Dir encerrada ($n processo(s))" } else { "detach -Kill: nada a encerrar em $Dir" })
        exit 0
    }
    if (-not $Command.Trim()) { [Console]::Error.WriteLine('detach: -Command "<comando>" é obrigatório (ou -Kill).'); exit 2 }
    $WaitSeconds = [Math]::Max(1, [Math]::Min($WaitSeconds, 540))
    $sig = "cmd=$($Command.Trim())|root=$Root"
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $job = Get-DetachedJob $full
    if ($job -and $job.Sig -ne $sig) {
        if ($job.State -eq 'running') { & $out "detach: OCUPADO — outro comando roda em $Dir (pid $($job.Pid), desde $($job.At)): $($job.Label). Use outra pasta de job, ou -Kill para encerrá-lo."; exit 5 }
        Clear-DetachedJob $full; $job = $null
    }
    $note = ''
    if ($job -and $job.State -eq 'dead') { $note = "a rodada anterior deste comando (pid $($job.Pid), desde $($job.At)) caiu sem resultado; abro outra"; Clear-DetachedJob $full; $job = $null }
    if ($job -and $job.State -eq 'running') { & $out "detach: acompanhando a rodada que já roda (pid $($job.Pid), desde $($job.At), há $([int]$job.Minutes) min) — mesmo comando; não abro outra." }
    elseif (-not $job) {
        if ($note) { & $out "detach: $note." }
        # Código de saída real (o do último nativo; cmdlet que falha sem código = 1), como o Invoke-ProjectCommand.
        $wrapped = '$global:LASTEXITCODE = 0; ' + $Command + '; if (-not $?) { if ($LASTEXITCODE) { exit $LASTEXITCODE } else { exit 1 } }; exit $LASTEXITCODE'
        $label = if ($Command.Length -gt 80) { $Command.Substring(0, 80) + '…' } else { $Command }
        $why = Start-DetachedJob $full $Root $wrapped $sig $label
        if ($why) { & $out "detach: FALHA DE AMBIENTE — $why."; exit 4 }
    }
    $job = Wait-DetachedJob $full ([int][Math]::Max(1, $WaitSeconds - $sw.Elapsed.TotalSeconds))
    if ($job -and $job.State -eq 'done') {
        $o = Read-DetachedOutput $full
        $log = Join-Path $full 'output.log'
        [System.IO.File]::WriteAllText($log, $o.Out + $(if ($o.Err) { "`n--- stderr ---`n" + $o.Err } else { '' }) + "`nEXIT=$($job.Exit)`n", (New-Object System.Text.UTF8Encoding($false)))
        $lines = @((Read-LogText $log) -split "`r?`n")
        Clear-DetachedJob $full
        & $out "detach: terminou · exit $($job.Exit) · começou $($job.At) · log $log ($($lines.Count) linhas)"
        foreach ($l in @($lines | Where-Object { $_.Trim() } | Select-Object -Last $Tail)) { & $out "  $l" }
        exit ([int]$job.Exit)
    }
    if (-not $job -or $job.State -eq 'dead') {
        $tail = if ($job) { @(((Read-DetachedOutput $full).Out -split "`r?`n") | Where-Object { $_.Trim() } | Select-Object -Last 3) -join ' / ' } else { '' }
        Clear-DetachedJob $full
        & $out "detach: FALHA DE AMBIENTE — a rodada caiu sem gravar o resultado$(if ($tail) { "; fim da saída: $tail" }). Rode o mesmo comando UMA vez de novo; caindo outra vez, pare (ambiente)."
        exit 4
    }
    & $out "detach: RODANDO em processo próprio (pid $($job.Pid), desde $($job.At), há $([int]$job.Minutes) min) — $($job.Label)"
    & $out "  rode o MESMO comando de novo AGORA, no mesmo turno (exit 3): ele volta a acompanhar esta rodada e entrega o resultado quando ela acabar. Não encerre o turno para esperar: nenhum aviso vem."
    exit 3
} catch {
    [Console]::Error.WriteLine("detach: erro — $($_.Exception.Message)")
    exit 2
}
