# Melhorias a aplicar neste plugin — fila do `/review`

> **Dono:** stakeholder. Só no repositório-fonte do plugin. Escreva cada item como **sintoma**, não como solução.

## Abertas

> **Origem:** o primeiro sprint completo do projeto-piloto (04 a 13/10/2026, plugin 3.46.0). Item 1: relatório do SM ao dono do plugin e `guards.log` (grupo C da avaliação; os grupos A e B entraram na v3.48.0). Itens 2–3: roteiro do `sprint run`, `usage.jsonl` do piloto, os transcripts do Claude Code do mesmo projeto recortados no sprint (128 subagentes e a sessão principal) e o log de energia do Windows, lidos em 15–16/10/2026.
> - **Medido** = contado no `usage` de cada chamada (`scripts/metrics/transcript-metrics.js`, v3.49).
> - **Estimado** = a divisão do contexto por fonte e os valores em dólar (preço de API da tabela de 06/10/2026, não o que o plano de assinatura cobrou).
>
> Toda a evidência é da v3.46.0: revalidar num sprint na versão atual.
>
> **Leitura conjunta: volume não é custo.** O sprint teve 758 M tokens e custou ~US$ 282: a sessão principal (Sonnet 5.5) foi 37 % do volume e 40 % do custo; o Arquiteto (Opus 5.5), 22 % e 38 %; o QA, 13 % e 13 %; o dev (Haiku 4.5 e 5.5), 23 % e 5 %. O dev pesa em relógio e capacidade, não em dinheiro. Grupo para o `/review` (os antigos itens 4, das paradas do `run`, e 2, da regressão de UI, foram aplicados e vivem no changelog do processo, v3.50; os antigos 3 e 5 passaram a 2 e 3):
> - **Instância e contexto:** 1, 2 e 3.

1. **Invocação única concentrando o sprint; haiku sem fôlego.** Uma invocação de dev (haiku) com 197 chamadas e 131 min somou ~15 % do **volume** do sprint (40 M tokens: plano com 13 mutações e prova por bloco), mas só ~US$ 0,5 (0,2 % do custo, Haiku 5.5): o que ela custou foi relógio no caminho crítico e capacidade. Uma Task de 32 arquivos sem blocos esgotou a capacidade em 4 instâncias de haiku. O `plan.ps1` já reprova lista > 8 sem blocos desde a v3.46 — a Task passou sem ele (plano anterior à v3.46 ou conferência não rodada); revalidar. *Onde doeu:* tamanho do bloco de execução · `sprint-run.md` passo 3. *Dono provável:* SM.
    *Decisão do stakeholder em 16/10/2026: esperar o benchmark.* Revalidar: se o plano da Task passou pelo `plan.ps1` v3.46+ (lista > 8 sem blocos reprova).
2. **O contexto cresce com os próprios documentos de passagem.** Nos transcripts do sprint, 15 % do processado pelos subagentes é a carga inicial e 85 % é crescimento; desse crescimento, ~43 % vem de ler documentos do time (estimado): plano 18 %, outros arquivos de `.team-project/` 16 %, processo do plugin 5 %, `docs/` 3,5 %; código e testes 15 %, buscas 9 %. Os que mais pesam: o plano da Task (27 KB, lido 117×, 68 M), `.team-project/README.md` (12,9 KB, 71×, 19 M) e `sprint-backlog.md` (18 KB, 30×, 10 M). O prompt do dev manda ler "o plano inteiro" mesmo para executar um bloco — mas o dev é ~5 % do custo; o crescimento que custa caro é o do Arquiteto em Opus (no dele: código-fonte 20 %, `.team-project/` 16 %, plano 11 %, buscas 11 %). *Onde doeu:* tamanho do plano e do README do time × duração da instância. *Dono provável:* SM e Arquiteto.
    *Decisão do stakeholder em 16/10/2026: esperar o benchmark.* Revalidar: posição A × B sobre ler o "plano inteiro" × a R26(i) (o plano mede o ambiente do plano inteiro), decidida com o número do sprint na v3.49.
3. **Trilha `fix`: uma instância de QA para o bloco inteiro.** **Leitura do roteiro, não medição.** O piloto não rodou a trilha fix; a primeira medição sai da cauda de `fix` do benchmark (`rituals/benchmark.md` §7.4). O QA faz numa instância só a verificação por F-ID, os regressivos R30 e a suíte do módulo. Ele é ~13 % do custo, e um comando longo dentro dele expira o cache de 5 min. *Onde doeu:* `fix-run.md` §Run passo 3. *Dono provável:* SM (com QA).
    *Decisão do stakeholder em 16/10/2026: esperar o benchmark.* Revalidar: a cauda de `fix` do benchmark (`rituals/benchmark.md` §7.4).
