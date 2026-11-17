# Executor da RODADA DESACOPLADA (v3.62.2) — não se chama à mão. O Start-DetachedJob (lib.ps1) o cria pelo WMI
# (Win32_Process.Create), fora da árvore de processos do Claude Code: quando o agente encerra o turno, o Claude Code encerra
# o comando dele e toda a árvore, mas não este processo nem os filhos dele.
# Lê <Dir>/job.run.json (cwd, comando em Base64, arquivo do ambiente), restaura o ambiente de quem chamou (o WMI não o herda)
# e apaga o arquivo dele, roda o comando num PowerShell filho com a saída em job.out/job.err e grava o código de saída em
# job.exit no fim (gravação atômica: job.exit.tmp → job.exit). Quem acompanha lê esses arquivos (Wait-DetachedJob).
param([Parameter(Mandatory = $true)][string]$Dir)

$u8 = New-Object System.Text.UTF8Encoding($false)
$code = 1
try {
    $run = [System.IO.File]::ReadAllText((Join-Path $Dir 'job.run.json'), $u8) | ConvertFrom-Json
    if ($run.env -and (Test-Path -LiteralPath ([string]$run.env))) {
        try {
            $envs = [System.IO.File]::ReadAllText([string]$run.env, $u8) | ConvertFrom-Json
            foreach ($p in $envs.PSObject.Properties) { [Environment]::SetEnvironmentVariable($p.Name, [string]$p.Value, 'Process') }
        } finally { Remove-Item -LiteralPath ([string]$run.env) -Force -ErrorAction SilentlyContinue }
    }
    # protocolo: desprendido — o filho é da rodada; o executor espera por ele e grava o código. Ambos ficam fora da árvore do chamador.
    $p = Start-Process -FilePath 'powershell' -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-EncodedCommand', [string]$run.encoded) -WorkingDirectory ([string]$run.cwd) -RedirectStandardOutput (Join-Path $Dir 'job.out') -RedirectStandardError (Join-Path $Dir 'job.err') -NoNewWindow -PassThru
    $null = $p.Handle   # sem o handle aberto, o ExitCode volta vazio no 5.1
    $p.WaitForExit()
    $code = $p.ExitCode
} catch {
    try { [System.IO.File]::AppendAllText((Join-Path $Dir 'job.err'), "detached-run: $($_.Exception.Message)`n", $u8) } catch { }
    $code = 2
} finally {
    $tmp = Join-Path $Dir 'job.exit.tmp'
    try { [System.IO.File]::WriteAllText($tmp, [string]$code, $u8); Move-Item -LiteralPath $tmp -Destination (Join-Path $Dir 'job.exit') -Force } catch { }
}
exit $code
