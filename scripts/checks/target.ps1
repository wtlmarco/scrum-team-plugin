# Pré-voo do alvo de execução (v3.51, D3): confere se o alvo está pronto para rodar o app e, com -Repair, tenta consertar
# uma vez. Mesmo contrato para todos os alvos; um adaptador por tecnologia em targets/. Configuração em guards.json → targets.
# Uso (raiz do projeto): powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/target.ps1" -Target android [-Repair] [-Unlock]
#   android  emulador ou aparelho: conectado, iniciado, tela desenhando (captura com tamanho real), uiautomator respondendo,
#            tempo ligado abaixo de targets.android.maxUptimeHours · reparo: o comando de targets.android.repair (v3.53.2,
#            emulador em container) ou, sem ele, reinicia o AVD de targets.android.avd · v3.53.6: memória do emulador
#            (targets.android.memoryCmd) acima de targets.android.maxMemoryMB também reprova e pede o reparo
#   web      site no ar (targets.web.health ou url) e Node instalado · reparo: sobe o servidor por targets.web.start
#   (api e desktop: próximo incremento)
# -Unlock apaga a trava de dono único (.team-project/.target-lock) deixada por um executor que caiu (v3.63.1: recusa, exit 4,
# quando o dono está vivo). -Who (v3.63.1, só leitura) diz quem usa o alvo: o dono da trava, cada accept no aparelho, os
# invólucros e quem só acompanha; -KillDuplicates encerra só o accept que não é o dono da trava.
# -Release (v3.58.4) desliga o emulador local que a construção não está usando (memória); o accept seguinte o religa.
# -Kill (v3.57.0) encerra o que o run registrou em .target-<alvo>.json; v3.63.1: e o dono da trava do alvo (o accept.ps1 ou o
# target.ps1 do plugin, reconhecido pela hora de criação e pela linha de comando), com a árvore dele.
# Exit 0 = alvo pronto · 2 = erro de uso · 4 = FALHA DE AMBIENTE (o motivo e a ação na saída). Quem vê 4 não depura o app.

param(
    [Parameter(Mandatory = $true)][ValidateSet('android', 'web')][string]$Target,
    [switch]$Repair,
    [switch]$Unlock,
    [switch]$Kill,
    [switch]$Release,
    [switch]$Who,
    [switch]$KillDuplicates,
    [string]$Root = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')

try {
    # -Who (v3.63.1, só leitura): quem usa o alvo — o dono da trava com o sinal de vida e o progresso, cada accept que roda
    # cenários, os invólucros da rodada desacoplada e quem só acompanha (detach.ps1). Antes de concluir "teste duplicado" pela
    # lista de processos: no sprint 6 do projeto piloto, um accept, o invólucro e as cópias do detach.ps1 que acompanhavam a
    # mesma rodada foram lidos como "três accepts no aparelho", e dois observadores foram encerrados como duplicados.
    if ($Who) {
        $u = Get-TargetUsers $Root
        $o = { param($s) [Console]::Out.WriteLine($s) }
        & $o "target ${Target}: quem usa o alvo"
        if ($u.Lock) {
            $pu = if ($u.LockPid) { Get-WaitPulse $u.LockPid ([string]$u.Lock.desde) (Get-TargetLockDir $Root $u.Lock) } else { $null }
            $g = if ([string]$u.Lock.owner -match '^accept (\S+)$') { Get-AcceptProgress $Root $Matches[1] } else { $null }
            & $o "  trava: '$([string]$u.Lock.owner)' PID $([int]$u.Lock.pid), desde $([string]$u.Lock.desde) — $(if ($u.LockPid) { "vivo · $($pu.Text)" } else { 'dono morto ou PID reaproveitado: trava velha (o próximo accept a assume)' })$(if ($g -and $g.Pid -eq $u.LockPid) { " · cenários: $($g.Passed) passaram, $($g.Failed) falharam de $($g.Total)" })"
        } else { & $o '  trava: nenhuma — nenhum executor do plugin segura o alvo' }
        foreach ($a in $u.Accepts) { & $o "  accept (usa o aparelho): PID $($a.Pid)$(if ($a.Task) { " · -Task $($a.Task)" }) · desde $($a.Since)$(if ($a.Pid -eq $u.LockPid) { ' · dono da trava' } elseif ($a.Mine -eq $true -and $u.LockPid) { ' · DUPLICADO (deste projeto, não é o dono da trava)' } elseif ($a.Mine -eq $false) { ' · de OUTRO projeto (no mesmo emulador também atrapalha; não é encerrado por aqui)' } else { ' · projeto não identificado (não é encerrado por aqui)' })" }
        foreach ($w in $u.Wrappers) { & $o "  invólucro (não usa o aparelho por si): PID $($w.Pid) · desde $($w.Since)$(if ($w.Dir) { " · $($w.Dir)" })" }
        foreach ($w in $u.Watchers) { & $o "  acompanhando (detach.ps1, não usa o aparelho; encerrá-lo não muda o teste): PID $($w.Pid) · desde $($w.Since)$(if ($w.Dir) { " · $($w.Dir)" })" }
        $nA = @($u.Accepts | Where-Object { $_.Mine -eq $true }).Count
        & $o $(if ($u.Duplicates.Count) { "  conclusão: DUPLICADO — $nA accepts no aparelho; o dono da trava é o PID $($u.LockPid). Encerre só os duplicados: target.ps1 -Target $Target -KillDuplicates" }
               elseif ($nA -gt 1) { "  conclusão: $nA accepts vivos e nenhum dono vivo da trava — leve ao stakeholder antes de encerrar qualquer um" }
               elseif ($nA -eq 1) { '  conclusão: um accept só no aparelho — sem duplicado; quem acompanha não atrapalha' }
               else { '  conclusão: nenhum accept rodando' })
        $nF = @($u.Accepts | Where-Object { $_.Mine -ne $true }).Count
        if ($nF -and $Target -eq 'android') { & $o "  atenção: $nF accept(s) de outro projeto ou não identificado(s) na máquina — no mesmo emulador, um atrapalha o outro; quem decide é o stakeholder" }
        exit 0
    }
    # -KillDuplicates (v3.63.1): encerra SÓ o accept vivo que não é o dono da trava (e o invólucro dele); o dono e os observadores ficam.
    if ($KillDuplicates) { foreach ($l in @(Stop-TargetDuplicates $Root)) { [Console]::Out.WriteLine("target ${Target}: -KillDuplicates — $l") }; exit 0 }
    # -Kill (v3.57.0, protocolo de espera): encerra os processos do alvo que o PRÓPRIO run iniciou e registrou em
    # .team-project/.target-<alvo>.json (emulador pelo AVD, filhos que o reparo declarado deixa vivos, servidor web). Não precisa
    # de autorização do stakeholder: nada fora do registro é tocado (PID reaproveitado é reconhecido e pulado). Com a trava
    # de dono único ativa, avisa quem a segura — encerrar o alvo no meio de um accept derruba o cenário dele.
    if ($Kill) {
        # v3.63.1 (sprint 6 do projeto piloto, pedido 5): o dono da trava — o accept.ps1 ou o target.ps1 que o próprio run disparou
        # e que ficou órfão quando o agente foi encerrado pelo watchdog — sai com a árvore dele. Antes, o -Kill dizia "nada
        # registrado" e o run.ps1 next repetia "reparar e repetir" contra o alvo preso. Processo de fora segue intocado.
        $lh = Stop-TargetLockHolder $Root
        if ($lh.Text) { [Console]::Out.WriteLine("target ${Target}: -Kill — $($lh.Text)") }
        $lp = Join-Path $Root '.team-project/.target-lock'
        $held = if (Test-Path -LiteralPath $lp) { (Get-Content -LiteralPath $lp -Raw -ErrorAction SilentlyContinue) } else { '' }
        $k = Stop-Detached $Root $Target
        # v3.62.0: os adb forward para a WebView (locator "cdp") que um accept encerrado no meio deixou.
        if ($Target -eq 'android') {
            try {
                . (Join-Path $PSScriptRoot 'targets/android.ps1')
                $tc = Get-TargetsConfig $Root
                if (-not (Initialize-Android $(if ($tc -and $tc.PSObject.Properties['android']) { $tc.android } else { $null }))) { $fw = Clear-AndroidCdpForwards; if ($fw) { [Console]::Out.WriteLine("target android: -Kill — $fw forward(s) da WebView removido(s)") } }
            } catch { }
        }
        if (-not $k.registered) { if (-not $lh.Stopped) { [Console]::Out.WriteLine("target ${Target}: nada registrado — o run não iniciou nenhum processo deste alvo (processo de fora não é tocado)") }; exit 0 }
        [Console]::Out.WriteLine("target ${Target}: -Kill — $($k.stopped) encerrado(s), $($k.gone) já tinha(m) saído, $($k.reused) com PID reaproveitado (não tocado)" + $(if ($held) { "; ATENÇÃO: a trava do alvo estava com outro executor (.target-lock)" } else { '' }))
        exit 0
    }
    if ($Unlock) {
        $lp = Join-Path $Root '.team-project/.target-lock'
        if (Test-Path -LiteralPath $lp) {
            # v3.63.1: a trava de um dono VIVO não sai pelo -Unlock — sem ela, o próximo accept entraria ao lado dele no mesmo
            # aparelho (os dois quebram). Dono parado: target.ps1 -Kill; dono que anda: esperar.
            $l = $null; try { $l = Read-Text $lp | ConvertFrom-Json } catch { }
            if ($l -and [int]$l.pid -ne $PID -and (Test-TargetLockHolderAlive $l)) {
                $pu = Get-WaitPulse ([int]$l.pid) ([string]$l.desde) (Get-TargetLockDir $Root $l)
                [Console]::Out.WriteLine("target ${Target}: trava NÃO removida — o dono '$([string]$l.owner)' (PID $([int]$l.pid), desde $([string]$l.desde)) está vivo ($($pu.Text)). Sem a trava, o próximo accept entraria ao lado dele no mesmo aparelho. $(if ($pu.Stalled) { "Parado: target.ps1 -Target $Target -Kill (encerra o dono e a árvore dele; decisão do stakeholder)" } else { 'Ele ainda anda: espere terminar' }) · quem usa o alvo: target.ps1 -Target $Target -Who")
                exit 4
            }
            Remove-Item -LiteralPath $lp -Force; [Console]::Out.WriteLine('target: trava removida')
        }
    }
    $targets = Get-TargetsConfig $Root
    $cfg = if ($targets -and $targets.PSObject.Properties[$Target]) { $targets.$Target } else { $null }
    # -Release (v3.58.4): desliga o emulador local quando a construção não precisa dele (run.ps1 start, entre Tasks; verify full,
    # com pouca memória livre antes da suíte). Com a trava do alvo: nunca no meio de um accept ou de um reparo. Exit 0 com o
    # emulador desligado ou nada a desligar · 4 quando não pode (alvo em uso, container, sem reparo declarado) — quem chama segue.
    if ($Release) {
        if ($Target -ne 'android') { [Console]::Out.WriteLine("target ${Target}: -Release só desliga emulador android — nada a liberar"); exit 0 }
        . (Join-Path $PSScriptRoot 'targets/android.ps1')
        $init = Initialize-Android $cfg
        if ($init) { [Console]::Out.WriteLine("target android: não liberado — $init"); exit 4 }
        $blk = Get-AndroidReleaseBlock $cfg
        if ($blk) { [Console]::Out.WriteLine("target android: não liberado — $blk"); exit 4 }
        $lock = Enter-TargetLock $Root $Target "target.ps1 $Target -Release"
        if ($lock) { [Console]::Out.WriteLine("target android: não liberado — $lock"); exit 4 }
        try {
            $k = Stop-Detached $Root 'android'   # o que o próprio run subiu e registrou (AVD local)
            $st = Stop-AndroidEmulator           # e o dono da porta do console (o reparo declarado sobe por fora do registro)
        } finally { Exit-TargetLock $Root }
        if ($st.Stopped -or $k.stopped) { [Console]::Out.WriteLine("target android: liberado — $($st.Text); o próximo accept o religa pelo reparo declarado, e target.ps1 -Target android -Repair o sobe antes, se um comando do projeto precisar do aparelho"); exit 0 }
        [Console]::Out.WriteLine("target android: nada a liberar — $($st.Text)")
        exit 0
    }
    if ($Target -eq 'android') { . (Join-Path $PSScriptRoot 'targets/android.ps1'); $init = Initialize-Android $cfg; $health = { Test-AndroidHealth }; $fix = { Repair-Android } }
    else {
        if (-not $cfg) { [Console]::Error.WriteLine('target: guards.json sem targets.web'); exit 2 }
        . (Join-Path $PSScriptRoot 'targets/web.ps1'); $init = Initialize-Web $cfg $Root; $health = { Test-WebHealth }; $fix = { Repair-Web }
    }
    if ($init) { [Console]::Out.WriteLine("target ${Target}: FALHA DE AMBIENTE — $init"); exit 4 }
    $lock = Enter-TargetLock $Root $Target "target.ps1 $Target"
    if ($lock) { [Console]::Out.WriteLine("target ${Target}: FALHA DE AMBIENTE — $lock"); exit 4 }
    try {
        $h = & $health
        if ($h -and $Repair) { [Console]::Out.WriteLine("target ${Target}: $h — tentando o reparo"); $h = & $fix }
    } finally { Exit-TargetLock $Root }
    if ($h) { [Console]::Out.WriteLine("target ${Target}: FALHA DE AMBIENTE — $h" + $(if (-not $Repair) { ' (rode com -Repair para tentar consertar)' } else { '' })); exit 4 }
    [Console]::Out.WriteLine("target ${Target}: pronto")
    exit 0
} catch {
    [Console]::Error.WriteLine("target: erro — $($_.Exception.Message)")
    exit 2
}
