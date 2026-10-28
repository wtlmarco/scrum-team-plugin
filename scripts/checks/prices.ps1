# Preço por chamada ao modelo (v3.52.3, note.md item 9): o registro de consumo somava entrada, cache gravado, cache lido e
# saída com o mesmo peso e sem o preço do modelo — no sprint 4 do garden, em tokens brutos o plano da História parecia perto
# da espera dos devs; em dinheiro era ~5× todos os devs juntos (cache lido custa 0,1× a entrada; Opus custa 40× o Haiku).
# Tabela da API (US$ por milhão de tokens de ENTRADA; cache gravado 1,25×, cache lido 0,1×, saída 5×), conferida em 2026-10.
# Modelo fora da tabela: $null ("sem preço"), nunca 0. Preço mudou: atualize aqui — é a única cópia (hook G16 e consumption.ps1).
# Lido por dot-source (hooks/subagent-stop.ps1, scripts/checks/consumption.ps1); não roda sozinho.

$script:PriceTable = @{
    'opus-5-5'   = @{ Input = 4.0 }
    'sonnet-5-5' = @{ Input = 2.0 }
    # Haiku 5.5: a faixa sobe com o tamanho do prompt (entrada + cache gravado + cache lido) da chamada.
    'haiku-5-5'  = @{ Input = 0.10; Above = 100000; InputAbove = 0.50 }
}
$script:PriceDate = '2026-10'

function Get-CallUsd([string]$Model, $Usage) {
    $m = [regex]::Match($Model, '(?i)(opus|sonnet|haiku|fable)-(\d+)-(\d{1,2})(?!\d)')
    if (-not $m.Success) { return $null }
    $p = $script:PriceTable[("{0}-{1}-{2}" -f $m.Groups[1].Value.ToLowerInvariant(), $m.Groups[2].Value, $m.Groups[3].Value)]
    if ($null -eq $p) { return $null }
    $in = [double]$Usage.input_tokens; $cw = [double]$Usage.cache_creation_input_tokens; $cr = [double]$Usage.cache_read_input_tokens; $out = [double]$Usage.output_tokens
    $rate = $p.Input
    if ($p.ContainsKey('Above') -and ($in + $cw + $cr) -gt $p.Above) { $rate = $p.InputAbove }
    return ($in + 1.25 * $cw + 0.1 * $cr + 5 * $out) * $rate / 1e6
}
