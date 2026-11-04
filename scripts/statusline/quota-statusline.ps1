# Status line da cota da assinatura (v3.53.6, decisão do stakeholder: medir pela cota do plano Pro, não por US$ da API).
# O Claude Code passa à status line, no stdin, um JSON com rate_limits.five_hour / rate_limits.seven_day (used_percentage
# 0–100 e resets_at em epoch Unix) para quem assina Pro/Max, depois da primeira resposta da API — hook, OTEL e CLI não expõem
# a cota (code.claude.com/docs/en/statusline.md). Cada janela pode faltar. Este script:
#   1. imprime UMA linha curta: "Opus 5.5 · 5h 37% (reinicia 14:20) · semana 12%" (o que faltar sai da linha);
#   2. acrescenta uma leitura ao registro GLOBAL %USERPROFILE%\.claude\quota-log.jsonl (a cota é da conta, não do projeto)
#      só quando um percentual ou um reinício mudou desde a última leitura gravada — o último valor fica num arquivo de
#      estado ao lado (quota-log.state), sem ler o registro inteiro. Acima de 5 MB o registro vira quota-log.1.jsonl.
# Quem lê o registro: scripts/checks/consumption.ps1 (rateia a subida da cota entre as rodadas ativas em cada intervalo).
# Nunca falha: qualquer erro imprime uma linha mínima e sai 0 (a status line não pode quebrar a sessão).
# Configuração (~/.claude/settings.json → statusLine; how-to.md): powershell -NoProfile -ExecutionPolicy Bypass -File <este arquivo>
# Teste: -Log <caminho> ou a variável TEAM_QUOTA_LOG trocam o registro (e o estado ao lado) — o teste nunca grava no perfil.

param([string]$Log = '')

$out = 'cota: sem dado'
try {
    try { [Console]::InputEncoding = New-Object System.Text.UTF8Encoding($false) } catch { }
    try { [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false) } catch { }
    $raw = ([Console]::In.ReadToEnd()).TrimStart([char]0xFEFF).Trim()   # pipe com BOM (medido no PowerShell 5.1) quebra o ConvertFrom-Json
    $j = $raw | ConvertFrom-Json
    $inv = [Globalization.CultureInfo]::InvariantCulture

    $model = ''
    if ($j.model) { $model = if ($j.model.display_name) { [string]$j.model.display_name } elseif ($j.model.id) { [string]$j.model.id } else { [string]$j.model } }

    # Janela: percentual (double ou $null) e reinício (epoch ou $null).
    $win = { param($W)
        if ($null -eq $W) { return @{ P = $null; R = $null } }
        $p = $null; $r = $null
        if ($null -ne $W.used_percentage) { $p = [Math]::Round([double]$W.used_percentage, 1) }
        if ($null -ne $W.resets_at) { $r = [int64][double]$W.resets_at }
        return @{ P = $p; R = $r }
    }
    $rl = $j.rate_limits
    $five = & $win $(if ($rl) { $rl.five_hour } else { $null })
    $week = & $win $(if ($rl) { $rl.seven_day } else { $null })

    $parts = @()
    if ($model) { $parts += $model }
    if ($null -ne $five.P) {
        $s = '5h ' + ([Math]::Round($five.P)).ToString($inv) + '%'
        if ($null -ne $five.R) {
            $at = [DateTimeOffset]::FromUnixTimeSeconds($five.R).LocalDateTime
            $s += ' (reinicia ' + $(if ($at.Date -eq (Get-Date).Date) { $at.ToString('HH:mm') } else { $at.ToString('dd/MM HH:mm') }) + ')'
        }
        $parts += $s
    }
    if ($null -ne $week.P) { $parts += ('semana ' + ([Math]::Round($week.P)).ToString($inv) + '%') }
    if ($parts.Count) { $out = $parts -join ' · ' } elseif ($model) { $out = $model }

    # Leitura nova no registro global — só com cota no JSON, e só quando mudou (o registro fica pequeno).
    if ($null -ne $five.P -or $null -ne $week.P) {
        try {
            if (-not $Log) { $Log = if ($env:TEAM_QUOTA_LOG) { $env:TEAM_QUOTA_LOG } else { Join-Path $env:USERPROFILE '.claude\quota-log.jsonl' } }
            $state = [System.IO.Path]::ChangeExtension($Log, '.state')
            $fmt = { param($v) if ($null -eq $v) { 'null' } else { ([double]$v).ToString('0.0', $inv) } }
            $fmtR = { param($v) if ($null -eq $v) { 'null' } else { ([int64]$v).ToString($inv) } }
            $key = (& $fmt $five.P) + '|' + (& $fmtR $five.R) + '|' + (& $fmt $week.P) + '|' + (& $fmtR $week.R)
            $last = ''
            if (Test-Path -LiteralPath $state) { try { $last = ([System.IO.File]::ReadAllText($state)).Trim() } catch { } }
            if ($key -ne $last) {
                $dir = Split-Path -Parent $Log
                if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
                # Rotação: acima de 5 MB o registro vira <nome>.1.jsonl (o consumption.ps1 lê os dois).
                if (Test-Path -LiteralPath $Log) {
                    if ((New-Object System.IO.FileInfo($Log)).Length -gt 5MB) {
                        $old = [System.IO.Path]::Combine($dir, [System.IO.Path]::GetFileNameWithoutExtension($Log) + '.1.jsonl')
                        Move-Item -LiteralPath $Log -Destination $old -Force
                    }
                }
                $esc = { param($v) '"' + (([string]$v) -replace '\\', '\\' -replace '"', '\"' -replace '[\x00-\x1f]', ' ') + '"' }
                $sess = [string]$j.session_id
                $cwd = if ($j.workspace -and $j.workspace.current_dir) { [string]$j.workspace.current_dir } else { [string]$j.cwd }
                $mid = if ($j.model -and $j.model.id) { [string]$j.model.id } else { $model }
                $row = '{"at":' + (& $esc (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')) +
                       ',"five":' + (& $fmt $five.P) + ',"fiveReset":' + (& $fmtR $five.R) +
                       ',"week":' + (& $fmt $week.P) + ',"weekReset":' + (& $fmtR $week.R) +
                       ',"session":' + (& $esc $sess) + ',"model":' + (& $esc $mid) + ',"cwd":' + (& $esc $cwd) + '}'
                $u = New-Object System.Text.UTF8Encoding($false)
                [System.IO.File]::AppendAllText($Log, $row + "`n", $u)
                [System.IO.File]::WriteAllText($state, $key, $u)
            }
        } catch { }   # registro inacessível: a linha sai mesmo assim
    }
} catch {
    # JSON ausente ou ilegível: linha mínima.
}
[Console]::Out.Write($out)
exit 0
