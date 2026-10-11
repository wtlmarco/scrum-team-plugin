# Modelo por papel (v3.47) — lê .team-project/models.json e diz com qual `model` disparar cada papel.
# Uso:  powershell -NoProfile -File scripts/checks/models.ps1 -Role developer     → imprime só o modelo configurado (vazio = não configurado)
#       powershell -NoProfile -File scripts/checks/models.ps1                      → tabela dos 7 papéis (efetivo, origem)
#       powershell -NoProfile -File scripts/checks/models.ps1 -Check               → valida o arquivo; exit 1 se houver problema
# -Role aceita o nome do agente ou o apelido do comando (arc dev po qa sm ux). Chave ligada vence o modelo do agente e as
# exceções do processo (trilha leve, 3ª instância); sem a chave, valem eles. A guarda G17 nega o disparo com outro modelo.
# Requisito: Windows PowerShell 5.1.

param([string]$Role, [switch]$Check, [string]$Root = (Get-Location).Path)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '..\..\hooks\common.ps1')

try {
    $mc = Get-ModelsConfig $Root

    if ($Role) {
        $r = $Role.Trim().ToLowerInvariant()
        if ($script:ModelAliases.ContainsKey($r)) { $r = $script:ModelAliases[$r] }
        if ($script:ModelRoles -notcontains $r) { [Console]::Error.WriteLine("papel desconhecido '$Role' — use: $($script:ModelRoles -join ', ') (ou arc dev po qa sm ux)"); exit 2 }
        if ($mc.State -eq 'ok' -and $mc.Models.ContainsKey($r)) { [Console]::Out.WriteLine($mc.Models[$r]) }
        exit 0
    }

    if ($Check) {
        switch ($mc.State) {
            'ausente'  { Write-Output 'models.json ausente: valem os modelos dos agentes e as exceções do processo.'; exit 0 }
            'invalido' { Write-Output 'models.json ilegível: JSON inválido — valem os modelos dos agentes.'; exit 1 }
        }
        Write-Output ("models.json ok: {0} papel(is) configurado(s)$(if ($mc.Executor) { '; perfil executor: architect' })." -f $mc.Models.Count)
        foreach ($p in $mc.Problems) { Write-Output "  ignorado: $p" }
        if ($mc.Problems.Count) { exit 1 }
        exit 0
    }

    $out = New-Object System.Text.StringBuilder
    [void]$out.AppendLine("Perfil executor: " + $(if ($mc.State -eq 'ok' -and $mc.Executor) { 'LIGADO — o Arquiteto implementa o plano (sprint-run.md passo 3)' } else { 'desligado — o dev implementa' }))
    [void]$out.AppendLine('')
    [void]$out.AppendLine('| Papel | Modelo efetivo | Origem |')
    [void]$out.AppendLine('|---|---|---|')
    foreach ($role in $script:ModelRoles) {
        if ($mc.State -eq 'ok' -and $mc.Models.ContainsKey($role)) { [void]$out.AppendLine("| $role | $($mc.Models[$role]) | models.json (vence o agente e as exceções) |") }
        else {
            $d = Get-AgentDefaultModel $role
            [void]$out.AppendLine("| $role | $(if ($d) { $d } else { '?' }) | agents/$role.md (exceções do processo valem) |")
        }
    }
    [Console]::Out.Write($out.ToString())
    if ($mc.State -eq 'invalido') { [Console]::Out.WriteLine(''); [Console]::Out.WriteLine('models.json ilegível — ignorado.') }
    foreach ($p in $mc.Problems) { [Console]::Out.WriteLine("ignorado: $p") }
    exit 0
} catch {
    [Console]::Error.WriteLine("models.ps1: " + $_.Exception.Message)
    exit 2
}
