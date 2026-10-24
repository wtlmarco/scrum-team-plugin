# SessionStart — G13: autoteste de uma linha (estado do guards.json, guardas ativas e desativadas). Nunca bloqueia.

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')

try {
    $hookInput = Read-HookInput
    $projectDir = Get-ProjectDir $hookInput
    if (-not (Test-Path -LiteralPath (Join-Path $projectDir '.team-project'))) { exit 0 }   # projeto sem o time: silêncio
    $cfg = Get-GuardConfig $projectDir
    if (-not (Test-GuardEnabled $cfg 'G13')) { exit 0 }

    $all = 'G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8', 'G9', 'G11', 'G14', 'G15', 'G16', 'G17', 'G18', 'G19', 'G20', 'G21', 'G22'
    $on= @($all | Where-Object { Test-GuardEnabled $cfg $_ })
    $off = @($all | Where-Object { -not (Test-GuardEnabled $cfg $_) })
    $line = "Guardas do time (hooks/COVERAGE.md): ativas " + ($(if ($on.Count) { $on -join ', ' } else { 'nenhuma' })) +
            "; desativadas " + ($(if ($off.Count) { $off -join ', ' } else { 'nenhuma' })) +
            "; guards.json " + $cfg.state + $(if ($cfg.probe) { '; sonda ligada' } else { '' }) + '.'
    if ($cfg.state -eq 'invalido') { $line += ' guards.json inválido: valem os padrões — corrija ou recrie a partir do modelo.' }
    # v3.47: modelo por papel (.team-project/models.json) — uma linha só quando o arquivo existe.
    $mc = Get-ModelsConfig $projectDir
    if ($mc.State -eq 'ok') {
        $line += " Modelos por papel (models.json): " + $(if ($mc.Models.Count) { (($mc.Models.Keys | Sort-Object | ForEach-Object { "$_=$($mc.Models[$_])" }) -join ', ') } else { 'nenhum configurado' }) + '.'
        if ($mc.Executor) { $line += " Perfil executor ligado: o Arquiteto implementa o plano (sprint-run.md passo 3)." }
        if ($mc.Problems.Count) { $line += ' models.json ignora: ' + ($mc.Problems -join '; ') + '.' }
    } elseif ($mc.State -eq 'invalido') { $line += ' models.json ilegível: valem os modelos dos agentes — corrija o JSON.' }
    # v3.47 (M3): modo benchmark ligado em guards.json → uma linha de aviso.
    if ($null -ne $cfg.bench) { $line += " Modo benchmark ligado (guards.json → bench): AskUserQuestion é respondido pelo dossiê. Se a ferramenta AskUserQuestion não existir nesta sessão (claude -p), NÃO pare nem trate a pergunta como premissa sua: para cada formulário ao stakeholder rode powershell -NoProfile -File `"$env:CLAUDE_PLUGIN_ROOT/scripts/checks/bench-answer.ps1`" -Question `"<pergunta>`" -Header `"<cabeçalho>`" -Options `"<rótulo 1>|<rótulo 2>|…`" e siga a resposta como decisão do stakeholder" + $(if ($cfg.bench.foreground -eq $true) { '; agentes em primeiro plano' } else { '' }) + '.' }
    # v3.51 (proposta b): run que não terminou é RETOMADO, não só avisado — a sessão que reabre segue a fila pelo marcador.
    $runPath = Join-Path $projectDir '.team-project/.active-run'
    $run = Get-Marker $projectDir '.active-run'
    if ($null -ne $run -and [string]$run.trilha -in @('sprint', 'fix')) {
        $cmd = if ([string]$run.trilha -eq 'sprint') { '/sm sprint run' } else { '/sm fix run' }
        $line += " Retomada: o $([string]$run.trilha) run $([string]$run.id) estava em andamento (desde $([string]$run.desde)). Retome agora, sem esperar o stakeholder: $cmd — a fila continua pelo marcador do quadro e pelo run.ps1 next (sprint-run.md §Ordem da fila e retomada); agentes em primeiro plano, retomada por instância nova com o cartão. Só apague o .active-run se o run terminou ou o stakeholder mandou parar."
    } elseif (Test-Path -LiteralPath $runPath) {
        $line += " Atenção: .team-project/.active-run existe mas está ilegível — se nada está em andamento, retome com o comando do run ou apague o arquivo."
    }
    # Marcador da sessão anterior: spike ou executor que não terminou deixa a G8 aberta ao Arquiteto.
    foreach ($mk in '.active-spike', '.active-executor') {
        $m = Get-Marker $projectDir $mk
        if ($null -ne $m) { $line += " Atenção: .team-project/$mk existe (desde $([string]$m.desde)) — se nada está em andamento, retome com o comando do run/spike ou apague o arquivo." }
    }
    # v3.51 (D2): perfil do Windows com caractere fora do ASCII — ferramentas com cache no perfil podem falhar sem aviso.
    $prof = [string]$env:USERPROFILE
    if ($prof -match '[^\x00-\x7F]') {
        $gh = $null
        try { $gj = Get-Content -LiteralPath (Join-Path $projectDir '.team-project/guards.json') -Raw -Encoding UTF8 | ConvertFrom-Json; if ($gj.verify -and $gj.verify.env) { $gh = $gj.verify.env.GRADLE_USER_HOME } } catch { }
        if (-not $gh -and -not $env:GRADLE_USER_HOME) {
            $line += " Ambiente: o caminho do perfil do Windows ($prof) tem acento. Medido: os testes do Gradle falham sem aviso (ClassNotFoundException do GradleWorkerMain) — se o projeto usa Gradle, crie uma junção ASCII (cmd /c mklink /J C:\gradle-home `"$prof\.gradle`") e ponha `"env`": { `"GRADLE_USER_HOME`": `"C:\\gradle-home`" } em guards.json → verify (how-to.md §Ambiente). A conferir, se aparecer erro estranho de cache: NuGet (NUGET_PACKAGES) e npm (npm_config_cache)."
        }
    }
    [Console]::Out.Write($line)
    exit 0
} catch {
    exit 1
}
