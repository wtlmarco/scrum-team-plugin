# Melhorias a aplicar neste plugin — fila do `/review`

> **Dono:** stakeholder. Só no repositório-fonte do plugin. Escreva cada item como **sintoma**, não como solução.

## Abertas

Origem: avaliação do sprint 4 do garden (plugin 3.52.2) de 27/10/2026, em `analise-consumo-s3-s4.md` e `respostas-gestor-plugin.md`. O que já foi aplicado está no `CHANGELOG.md` (v3.52.3 e v3.53.0). **Preço usado** (tabela da API, 2026-10, por milhão de entrada): Opus 5.5 $4, Sonnet 5.5 $2, Haiku 5.5 $0,10 até 100 mil de prompt e $0,50 acima; cache gravado 1,25×, cache lido 0,1×, saída 5×. Subagentes do sprint 4 ≈ US$ 25,9, dos quais todos os devs Haiku ≈ US$ 3,3.

6) O dev Haiku constrói e verifica com mais de 100 mil de prompt, faixa em que o preço do Haiku 5.5 é 5× maior: 55 de 64 chamadas no "Retomar T-049" (`aa86b003`), 50 de 80 no "Construa a T-051" (`af375d02`). As chamadas de verificação dos devs somam 13,8 mi brutos / 3,2 mi ponderados (61 rodar, 51 esperar, 40 ler resultado). Em dinheiro é pequeno (todos os devs ≈ US$ 3,3), mas é a parte que mais cresce quando a verificação demora. **Medir de novo no próximo sprint**, já com a espera da verificação resolvida na v3.52.3; só então decidir se a verificação final vai a uma instância leve. Dono: SM + dev.

8) Piloto da ficha por Task (v3.53.0) ainda não medido. **Medir no próximo sprint** contra o sprint 4 (plano da H-K1 ≈ US$ 16,3, um 🔺 GAP de plano por Task construída): US$ do plano por Task construída (`consumption.md`), GAPs de plano por Task e os arquivos em `**Li além da ficha:**` por plano. Alvo: custo ao menos 40 % menor sem subir os GAPs; se não, os lotes por dependência ({T-048, T-049, T-054}, {T-051, T-052}, {T-047, T-053}, {T-050} no sprint 4) são a segunda opção. Dono: SM + Arquiteto.

9) Falta saber qual peso o limite semanal da conta dá a cada parcela (entrada, cache gravado, cache lido, saída) e a cada modelo — o cliente não tem leitura da tela de uso antes e depois de um sprint. Sem isso, "custo" no `consumption.md` é o preço da API, não o consumo do limite. Dono: SM (medição no próximo sprint).

Origem: `plugin-report.md` do fim do sprint 4 do garden (3.52.2 → 3.53.0), avaliado em 31/10/2026. O que foi aplicado está no `CHANGELOG.md` (v3.53.1). O item 6 acima ganha a G23 (teto de 100 mil também tira o Haiku da faixa 5×) — medir junto.

10) Não há caminho oficial para provar critério de aceite de aplicação híbrida (WebView) em emulador Android em container (acesso por noVNC): o `target.ps1` só conhece AVD nativo, o `accept.ps1` depende de identificador de teste lido pelo `uiautomator`, e a prova real saiu por desvio autorizado (`adb input tap`/`screencap` + leitura de tela por CDP), com 5 comandos liberados um a um. Um projeto só até aqui; esperar o segundo caso antes de um driver por CDP. Dono: SM + QA.

11) Comando legítimo do projeto (`docker compose run`, `node`, leitura de zip/`aapt` pelo `operator`) só é descoberto quando a G14 o nega no meio do run — cada um virou parada e formulário (≈ 25 formulários para 4 Histórias, ≈ 3× o sprint anterior), e nada antes da construção mostra quais comandos os planos vão precisar. Dono: SM + Arquiteto.

12) Medir no próximo sprint a G23 (v3.53.1): instâncias de dev cortadas por TETO, o US$ delas contra os 34 % do sprint 4, 🔺 GAPs por Task (≤ 1,7) e se a instância nova perde estado do alvo. Dono: SM + dev.

Origem: avaliação do meio do sprint 5 do garden (3.53.1 → 3.53.2), em 02/11/2026. O que foi aplicado está no `CHANGELOG.md` (v3.53.3). Sprint 5 até 02/11 07:30: ~US$ 100 (subagentes US$ 79,81 + sessão US$ 20,34), 4 de 16 Tasks fechadas, Arquiteto US$ 66,77 (planos 38,2 · retrabalho 28,6).

13) Medir no sprint 6 se a v3.53.2 (modo de prova do cenário, `# aguarda`, Task de nomes na Planning) e a v3.53.3 (uma História por vez, GAP de alvo ao operator, `ESPERANDO`) acabaram com o vaivém entre construção e prova. Referência do sprint 5: ~12 formulários sobre nomes de teste (README §7 itens 9–20), contrato da Task de nomes ampliado 3× (~US$ 19 de Opus), 39 cenários tirados da prova depois de escritos, 9 GAPs ao Arquiteto (~US$ 7, 3 deles de alvo), 3 devs ao mesmo tempo na T-058. Alvo: perto de zero nos quatro primeiros e Arquiteto em retrabalho bem abaixo dos US$ 28,6. Fonte: `consumption.md` (categoria retrabalho, por papel), `run-log.md` e README §7 — nenhum agente novo. Dono: SM.