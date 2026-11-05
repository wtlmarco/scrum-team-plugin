# Arquivo de teste que monta um arquivo do escopo (v3.54.1). Dot-source: carregado pelo common.ps1 (G9) e pelo close.ps1
# (R7-margem) — sem efeito ao carregar (o common.ps1 troca a codificação do console, e o close não pode herdar isso).
# Requisito: Windows PowerShell 5.1.

# v3.54.1 (carta do sprint 5 do garden, item 2): teste que já existe e monta um arquivo do escopo — quebrou só porque o
# componente alterado ganhou uma dependência nova (inject(), argumento de construtor) e o stub do teste não a tem. Na T-063,
# 29 casos em dois specs fora da lista foram ao Arquiteto por isso. É a margem "stub" do dev: a G9 libera a edição e o
# close (R7-margem) exige a linha em ### Ajustes na margem. Devolve o arquivo do escopo que o teste cita pelo nome
# ('' quando não é arquivo de teste, não existe ou não cita nenhum arquivo de produção do escopo).
$script:TestFileRe = '(?i)(^|/)(tests?|__tests__|androidTest)/|[._-](spec|test)s?\.[a-z0-9]+$|Tests?\.(kt|java|cs|swift)$'
function Test-MountingSpec([string]$Root, [string]$Rel, [string[]]$Scope) {
    if (-not $Rel -or ($Rel -replace '\\', '/') -notmatch $script:TestFileRe) { return '' }
    $p = Join-Path $Root $Rel
    if (-not (Test-Path -LiteralPath $p -PathType Leaf)) { return '' }
    try { $text = [System.IO.File]::ReadAllText($p) } catch { return '' }
    foreach ($s in @($Scope)) {
        if (-not $s -or $s -match '[<>*?]' -or ($s -replace '\\', '/') -match $script:TestFileRe) { continue }
        $stem = (($s -replace '\\', '/') -split '/')[-1] -replace '\.[^.]+$', ''
        if ($stem.Length -lt 4) { continue }   # nome curto demais casaria por acaso
        if ($text -match ('(?<![\w-])' + [regex]::Escape($stem) + '(?![\w-])')) { return $s }
    }
    return ''
}
