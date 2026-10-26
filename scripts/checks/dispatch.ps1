# Preparo do disparo de um papel no sprint run e no fix run (v3.49). Numa chamada, faz o que sprint-run.md passo 3 pedia em
# passos soltos:
#   - grava .team-project/.active-task (e .active-executor no perfil executor) no formato JSON que a G9 lê. No piloto, um
#     .active-task gravado como caminho solto derrubou o hook, e 9 edições do dev passaram sem G6/G8/G9;
#   - marca a Task pelo mark.ps1;
#   - imprime os parâmetros do Agent: o papel efetivo e o model do models.json (o que a G17 cobra) ou o -Model da exceção
#     (v3.52.2: sem run_in_background — a chamada volta "lançado" e o aviso traz o resultado).
# Uso: powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/dispatch.ps1" -Role developer -Id T-041 -Plan <plano> [-Trilha sprint|fix] [-Mark build] [-Root <projeto>]
#      ... -Role architect -Id T-041 [-Mark plan]       → só os parâmetros (e o marcador, se pedido): o Arquiteto planejando não tem escopo de escrita
#      ... -Clear                                       → apaga .active-task e .active-executor (saída da Task, sprint-run.md passo 8)
# -Role aceita o nome do agente ou o apelido do comando (arc dev po qa sm ux operator). Exit 0 · 2 = erro de uso (nada gravado).
param(
    [string]$Role = '',
    [string]$Id = '',
    [string]$Plan = '',
    [ValidateSet('sprint', 'fix')][string]$Trilha = 'sprint',
    [string]$Mark = '',
    [string]$Model = '',
    [string]$ModelWhy = '',
    [switch]$Clear,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '..\..\hooks\common.ps1')
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

try {
    $tp = Join-Path $Root '.team-project'
    if (-not (Test-Path -LiteralPath $tp)) { [Console]::Error.WriteLine("dispatch: $tp não existe — rode na raiz do projeto ou passe -Root."); exit 2 }
    $taskMarker = Join-Path $tp '.active-task'; $execMarker = Join-Path $tp '.active-executor'
    $utf8 = New-Object System.Text.UTF8Encoding($false)

    if ($Clear) {
        $gone = @(); foreach ($p in $taskMarker, $execMarker) { if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force; $gone += (Split-Path $p -Leaf) } }
        [Console]::Out.WriteLine('dispatch: ' + $(if ($gone.Count) { 'apagado(s) ' + ($gone -join ', ') } else { 'nenhum marcador de escopo a apagar' }))
        exit 0
    }

    if (-not $Role) { [Console]::Error.WriteLine('dispatch: -Role é obrigatório (ou -Clear).'); exit 2 }
    $r = $Role.Trim().ToLowerInvariant() -replace '^team:', ''
    if ($script:ModelAliases.ContainsKey($r)) { $r = $script:ModelAliases[$r] }
    if ($script:ModelRoles -notcontains $r) { [Console]::Error.WriteLine("dispatch: papel desconhecido '$Role' — use: $($script:ModelRoles -join ', ') (ou arc dev po qa sm ux)."); exit 2 }

    $mc = Get-ModelsConfig $Root
    $executor = ($mc.State -eq 'ok' -and $mc.Executor -and $Trilha -eq 'sprint')
    # Perfil executor (v3.47 · M2): o passo 3 dispara o Arquiteto em modo execute no lugar do dev.
    $effective = if ($r -eq 'developer' -and $executor) { 'architect' } else { $r }
    $writesCode = ($r -eq 'developer')

    $lines = @("dispatch: $effective$(if ($Id) { " · $Id" })$(if ($effective -ne $r) { ' (perfil executor: o Arquiteto implementa — modo execute)' })")
    if ($writesCode) {
        if (-not $Id -or -not $Plan) { [Console]::Error.WriteLine('dispatch: o dev precisa de -Id e -Plan (o escopo da G9 sai da lista do plano).'); exit 2 }
        $planFull = if ([System.IO.Path]::IsPathRooted($Plan)) { $Plan } else { Join-Path $Root $Plan }
        if (-not (Test-Path -LiteralPath $planFull)) { [Console]::Error.WriteLine("dispatch: plano não encontrado: $Plan"); exit 2 }
        # Relativo ao projeto, com a grafia original (o Get-RelativePath do common.ps1 devolve em minúsculas).
        $full = [System.IO.Path]::GetFullPath($planFull); $base = [System.IO.Path]::GetFullPath($Root).TrimEnd('\', '/')
        $rel = if ($full.StartsWith($base + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) { $full.Substring($base.Length + 1) } else { $full }
        $rel = $rel -replace '\\', '/'
        $json = [ordered]@{ trilha = $Trilha; id = $Id; plano = $rel } | ConvertTo-Json -Compress
        [System.IO.File]::WriteAllText($taskMarker, $json, $utf8)
        $lines += "  .active-task: $json"
        if ($effective -eq 'architect') {
            $ej = [ordered]@{ trilha = 'sprint'; id = $Id; desde = (Get-Date -Format 'yyyy-MM-dd HH:mm') } | ConvertTo-Json -Compress
            [System.IO.File]::WriteAllText($execMarker, $ej, $utf8)
            $lines += "  .active-executor: $ej"
        }
    }

    if ($Mark) {
        if (-not $Id) { [Console]::Error.WriteLine('dispatch: -Mark precisa de -Id.'); exit 2 }
        if ($Trilha -eq 'fix') { $lines += '  marcador: n/a — a trilha fix não tem quadro' }
        else {
            $global:LASTEXITCODE = 0
            $mo = & (Join-Path $PSScriptRoot 'mark.ps1') -Task $Id -To $Mark -By $(if ($effective -eq 'architect' -and $writesCode) { 'Arquiteto (executor)' } else { '' }) -Root $Root 2>&1 | Out-String
            if ($LASTEXITCODE -ne 0) { [Console]::Error.WriteLine("dispatch: o marcador não foi gravado — $($mo.Trim())"); exit 2 }
            $lines += '  ' + $mo.Trim()
        }
    }

    # Modelo: a chave do models.json vence o agente e as exceções do processo (sprint-run.md §Modelo por papel; G17 confere).
    # v3.52.2 (note.md item 14): -Model/-ModelWhy = a exceção decidida por quem chama (o run.ps1 start escala o dev).
    $cfgModel = if ($mc.State -eq 'ok' -and $mc.Models.ContainsKey($effective)) { $mc.Models[$effective] } else { '' }   # $model seria o -Model
    $modelText = if ($cfgModel) { "model `"$cfgModel`" (models.json)" }
                 elseif ($Model) { "model `"$Model`" ($(if ($ModelWhy) { $ModelWhy } else { 'exceção do processo' }))" }
                 else { "model omitido — vale o do agente ($(Get-AgentDefaultModel $effective)), e as exceções do processo (trilha leve, 3ª instância do bloco)" }
    # v3.51.4 (garden item 14): o tipo com o prefixo do plugin — "developer" sozinho não existe na instalação.
    # v3.52.2 (note.md item 2, C1): o Agent não tem mais run_in_background — toda chamada volta "lançado" e o resultado chega
    # por aviso. Quem dispara encerra o turno; o aviso o acorda (sem Start-Sleep, sem sondar o disco).
    $lines += "  Agent: subagent_type `"team:$effective`" · $modelText — dispare e encerre o turno; o aviso traz a volta"
    $lines += '  prompt: o caminho do plano (e o bloco), nunca o conteúdo colado; pedir o retorno curto de R28'
    [Console]::Out.WriteLine(($lines -join "`n"))
    exit 0
} catch {
    [Console]::Error.WriteLine("dispatch: erro — $($_.Exception.Message)")
    exit 2
}
