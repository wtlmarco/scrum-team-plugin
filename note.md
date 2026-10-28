# Melhorias a aplicar neste plugin — fila do `/review`

> **Dono:** stakeholder. Só no repositório-fonte do plugin. Escreva cada item como **sintoma**, não como solução.

## Abertas

Origem: avaliação do sprint 4 do garden (plugin 3.52.2) de 27/10/2026, em `analise-consumo-s3-s4.md` e `respostas-gestor-plugin.md`. O que já foi aplicado está no `CHANGELOG.md` (v3.52.3 e v3.53.0). **Preço usado** (tabela da API, 2026-10, por milhão de entrada): Opus 5.5 $4, Sonnet 5.5 $2, Haiku 5.5 $0,10 até 100 mil de prompt e $0,50 acima; cache gravado 1,25×, cache lido 0,1×, saída 5×. Subagentes do sprint 4 ≈ US$ 25,9, dos quais todos os devs Haiku ≈ US$ 3,3.

6) O dev Haiku constrói e verifica com mais de 100 mil de prompt, faixa em que o preço do Haiku 5.5 é 5× maior: 55 de 64 chamadas no "Retomar T-049" (`aa86b003`), 50 de 80 no "Construa a T-051" (`af375d02`). As chamadas de verificação dos devs somam 13,8 mi brutos / 3,2 mi ponderados (61 rodar, 51 esperar, 40 ler resultado). Em dinheiro é pequeno (todos os devs ≈ US$ 3,3), mas é a parte que mais cresce quando a verificação demora. **Medir de novo no próximo sprint**, já com a espera da verificação resolvida na v3.52.3; só então decidir se a verificação final vai a uma instância leve. Dono: SM + dev.

8) Piloto da ficha por Task (v3.53.0) ainda não medido. **Medir no próximo sprint** contra o sprint 4 (plano da H-K1 ≈ US$ 16,3, um 🔺 GAP de plano por Task construída): US$ do plano por Task construída (`consumption.md`), GAPs de plano por Task e os arquivos em `**Li além da ficha:**` por plano. Alvo: custo ao menos 40 % menor sem subir os GAPs; se não, os lotes por dependência ({T-048, T-049, T-054}, {T-051, T-052}, {T-047, T-053}, {T-050} no sprint 4) são a segunda opção. Dono: SM + Arquiteto.

9) Falta saber qual peso o limite semanal da conta dá a cada parcela (entrada, cache gravado, cache lido, saída) e a cada modelo — o cliente não tem leitura da tela de uso antes e depois de um sprint. Sem isso, "custo" no `consumption.md` é o preço da API, não o consumo do limite. Dono: SM (medição no próximo sprint).
