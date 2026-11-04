# Melhorias a aplicar neste plugin — fila do `/review`

> **Dono:** stakeholder. Só no repositório-fonte do plugin. Escreva cada item como **sintoma**, não como solução.

## Abertas

Origem: avaliação do sprint 4 do garden (plugin 3.52.2) de 27/10/2026, em `analise-consumo-s3-s4.md` e `respostas-gestor-plugin.md`. O que já foi aplicado está no `CHANGELOG.md` (v3.52.3 e v3.53.0). **Preço usado** (tabela da API, 2026-10, por milhão de entrada): Opus 5.5 $4, Sonnet 5.5 $2, Haiku 5.5 $0,10 até 100 mil de prompt e $0,50 acima; cache gravado 1,25×, cache lido 0,1×, saída 5×. Subagentes do sprint 4 ≈ US$ 25,9, dos quais todos os devs Haiku ≈ US$ 3,3.

6) O dev Haiku constrói e verifica com mais de 100 mil de prompt, faixa em que o preço do Haiku 5.5 é 5× maior: 55 de 64 chamadas no "Retomar T-049" (`aa86b003`), 50 de 80 no "Construa a T-051" (`af375d02`). As chamadas de verificação dos devs somam 13,8 mi brutos / 3,2 mi ponderados (61 rodar, 51 esperar, 40 ler resultado). Em dinheiro é pequeno (todos os devs ≈ US$ 3,3), mas é a parte que mais cresce quando a verificação demora. **Medir de novo no próximo sprint**, já com a espera da verificação resolvida na v3.52.3; só então decidir se a verificação final vai a uma instância leve. Dono: SM + dev.

8) Piloto da ficha por Task (v3.53.0) ainda não medido. **Medir no próximo sprint** contra o sprint 4 (plano da H-K1 ≈ US$ 16,3, um 🔺 GAP de plano por Task construída): US$ do plano por Task construída (`consumption.md`), GAPs de plano por Task e os arquivos em `**Li além da ficha:**` por plano. Alvo: custo ao menos 40 % menor sem subir os GAPs; se não, os lotes por dependência ({T-048, T-049, T-054}, {T-051, T-052}, {T-047, T-053}, {T-050} no sprint 4) são a segunda opção. Dono: SM + Arquiteto.

9) Falta saber qual peso o limite semanal da conta dá a cada parcela (entrada, cache gravado, cache lido, saída) e a cada modelo — a Anthropic não publica. **v3.53.6:** a status line do plugin grava a cota (`quota-log.jsonl`) e o `consumption.md` traz a tabela de calibração (% por milhão de tokens nos intervalos com um modelo só); os pesos iniciais são a razão de preço da API. **Medir no sprint 6** e trocar `quota-weights.json` se a calibração divergir. Dono: SM.

Origem: `plugin-report.md` do fim do sprint 4 do garden (3.52.2 → 3.53.0), avaliado em 31/10/2026. O que foi aplicado está no `CHANGELOG.md` (v3.53.1). O item 6 acima ganha a G23 (teto de 100 mil também tira o Haiku da faixa 5×) — medir junto.

10) Não há caminho oficial para provar critério de aceite de aplicação híbrida (WebView) em emulador Android em container (acesso por noVNC): o `target.ps1` só conhece AVD nativo, o `accept.ps1` depende de identificador de teste lido pelo `uiautomator`, e a prova real saiu por desvio autorizado (`adb input tap`/`screencap` + leitura de tela por CDP), com 5 comandos liberados um a um. Um projeto só até aqui; esperar o segundo caso antes de um driver por CDP. Dono: SM + QA.

11) Comando legítimo do projeto (`docker compose run`, `node`, leitura de zip/`aapt` pelo `operator`) só é descoberto quando a G14 o nega no meio do run — cada um virou parada e formulário (≈ 25 formulários para 4 Histórias, ≈ 3× o sprint anterior), e nada antes da construção mostra quais comandos os planos vão precisar. Dono: SM + Arquiteto.

12) Medir no próximo sprint a G23 (v3.53.1): instâncias de dev cortadas por TETO, o US$ delas contra os 34 % do sprint 4, 🔺 GAPs por Task (≤ 1,7) e se a instância nova perde estado do alvo. Dono: SM + dev.

Origem: avaliação do meio do sprint 5 do garden (3.53.1 → 3.53.2), em 02/11/2026. O que foi aplicado está no `CHANGELOG.md` (v3.53.3). Sprint 5 até 02/11 07:30: ~US$ 100 (subagentes US$ 79,81 + sessão US$ 20,34), 4 de 16 Tasks fechadas, Arquiteto US$ 66,77 (planos 38,2 · retrabalho 28,6).

13) Medir no sprint 6 se a v3.53.2 (modo de prova do cenário, `# aguarda`, Task de nomes na Planning) e a v3.53.3 (uma História por vez, GAP de alvo ao operator, `ESPERANDO`) acabaram com o vaivém entre construção e prova. Referência do sprint 5: ~12 formulários sobre nomes de teste (README §7 itens 9–20), contrato da Task de nomes ampliado 3× (~US$ 19 de Opus), 39 cenários tirados da prova depois de escritos, 9 GAPs ao Arquiteto (~US$ 7, 3 deles de alvo), 3 devs ao mesmo tempo na T-058. Alvo: perto de zero nos quatro primeiros e Arquiteto em retrabalho bem abaixo dos US$ 28,6. Fonte: `consumption.md` (categoria retrabalho, por papel), `run-log.md` e README §7 — nenhum agente novo. Dono: SM.

Origem: pedido do stakeholder em 02/11/2026 — tirar do limite da conta Claude o trabalho que mais pesa (o plano do Arquiteto, ~2/3 do sprint 5), sem perder as conferências. O que foi aplicado está no `CHANGELOG.md` (v3.53.4).

14) Medir o piloto do plano externo (`guards.json` → `run.planner external`, com `run.tasks` de 3 Tasks do sprint 6): planos que passaram no `plan.ps1` de primeira (de quantas rodadas de correção cada um precisou), 🔺 GAPs de PLANO na construção dessas Tasks contra as do Opus no mesmo sprint, US$ de Arquiteto que deixou de existir (`consumption.md`) e o tempo do stakeholder por pacote. Na trilha fix (mesma chave, `fix-pack.ps1`), o primeiro bloco com plano externo: o `B-<nnn>-plan.md` passou no `fix.ps1 -PlanOnly` em quantas rodadas, e as promoções e os GAPs do `fix run` contra os blocos planejados pelo Opus. Desliga (`planner: claude`) se os GAPs subirem. Não testado ainda: pacote num assistente real (app do Codex ou chat na web) e o retorno dele. Dono: SM + Arquiteto.

Origem: relatório do sprint 5 (parcial) do garden, 03/11/2026, e decisões do stakeholder de 04/11. O que foi aplicado está no `CHANGELOG.md` (v3.53.6). O teto de contexto do Arquiteto ficou fora por decisão: medir antes (pico de 292 mil num plano no sprint 5).

15) Medir no sprint 6 a v3.53.6: planos acima de 30 KB que chegaram ao dev (alvo zero) e Tasks divididas por plano grande; instâncias da G23 que reabriram o plano inteiro depois do cartão com os passos; "tag não encontrada" no accept e reprovações da chave `testids` (falsos positivos da heurística pedem `sem-testid`); Tasks ✅ sem prova no alvo (alvo zero) e 🔴 "prova no alvo pendente" reabertas pelo `next`; tempo do reinício no 1º accept; pico de contexto do Arquiteto por plano (decide o teto). Dono: SM.

Origem: relatório de encadeamento do sprint 5 do garden e decisões do stakeholder de 04/11/2026. O que foi aplicado está no `CHANGELOG.md` (v3.53.7). A mutação escrita pelo dev e a margem do dev foram decididas em seguida e entraram na v3.54.0. Ficaram como estão: teto do plano em 30 KB e a QA do fim do sprint.

16) Medir no sprint 6 a v3.53.7: decisões copiadas entre planos (alvo zero; S5: a mesma em 8) e o tamanho dos acréscimos de GAP nos planos (S5: até 57 % de um plano); reprovações da premissa de layout e GAPs de layout por Task com layout novo (S5: 4 numa Task); cenários tirados da prova por gesto ou massa (S5: 16) e falhas de `seed`. Dono: SM.

17) Medir no sprint 6 a v3.54.0: mutações `inconclusivo` por trecho (alvo zero), 🔺 GAPs ao Arquiteto por Task construída contra o sprint 5, ajustes na margem por Task, reprovações da R7-margem e quantos ajustes ou mutações do dev o QA julgou divergentes (alvo zero; acima disso, a margem volta ao `/review`). Dono: SM + QA.
