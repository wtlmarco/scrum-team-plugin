# Melhorias a aplicar neste plugin — fila do `/review`

> **Dono:** stakeholder. Só no repositório-fonte do plugin. Escreva cada item como **sintoma**, não como solução.
>
> As medições que dependem de construir o sprint 6 estão em `/melhorias/validacoes-sprint-6.md` (itens 6, 8, 9 e 12 a 17).
> Os itens 10 e 11 foram para o plano `/melhorias/plano-v3.55.0.md` (seções G e F).

## Abertas

Origem: `melhorias/plugin-report.md` (sprint 5 do garden, intermediário, 2026-11-07). Triagem plugin × cliente feita em 07/11.

1. **Reparo do alvo sem prazo e preso ao pipe.** `Repair-Android` lia o comando declarado por pipeline e só seguia com o pipe fechado; filho de longa duração com saída herdada (emulador, `adb`) prendia a Task por ~2 h (2 ocorrências). *Tratado no código em 07/11 (android.ps1: `Invoke-CmdTx`, prazo `repairTimeoutSec`, padrão 600 s); reprodução: 26 s no caminho antigo × 4 s no novo. O estouro sai pelo `exit 4` de FALHA DE AMBIENTE do target.ps1 (lido no código, não rodado de ponta a ponta). Falta: entrada no CHANGELOG/versão e um teste automatizado.*
2. Sessão não reabre sozinha quando o processo em segundo plano trava: o `next` só roda com aviso de conclusão, e o POSSÍVEL TRAVAMENTO depende de alguém rodá-lo depois de 10 min (`sprint-run.md` §Disparo e espera; G20/G22). 1 vez (2 h) + 1 no sprint 5 anterior (81 min).
3. `operator` devolve relatório com o estado final do alvo "não confirmado" e deixa processo rodando sem prazo (R28).
4. Sem caminho oficial para encerrar processo do alvo que o próprio run iniciou: G14 nega `Stop-Process` e o roteiro manda "levar ao stakeholder". 2 vezes. (Ideia do stakeholder: `target.ps1 -Kill`.)
5. Cartão de passagem manda rodar o aceite numa Task cujo plano diz que ele não roda (`run.ps1 start` × passo 5). 1 vez, 2 instâncias.
6. `# aguarda` gera ciclo quando a Task cria e prova os próprios ids de teste, ou espera a Task-mãe que nunca fecha. 2 vezes.
7. Gate de ids de teste reprova sem dizer que o projeto usa `id` em vez de `data-testid` (1 vez) e reprova ids gerados em tempo de execução, que o verificador estático não vê (1 vez, falso positivo).
8. `verify` conta o tempo de suspensão do SO como tempo de suíte (2 vezes); na segunda, cobertura "não medido" com suíte verde — causa **não verificada**.
9. GAPs de aparência viram 3 instâncias cada (dev → Arquiteto opus → dev novo) para decisões que o plano já delimitava: 4 de 5 GAPs da Task A. Sugestões do stakeholder (para avaliar, não aprovadas): envelope de decisão no plano; classificar o GAP (aparência/desenho/produto); agrupar GAPs de aparência; sonda de medida no cartão.
10. G14 nega `-ExecutionPolicy Bypass` em `runjob` que o próprio plugin usa internamente (3 vezes); a morte da suíte por memória com emulador ligado é do ambiente.
11. Mutante do plano que não compila só aparece depois de ~20 min de mutação: o `verify` o marca "inconclusivo" e a mutação sai com exit 1 (8 de 9 pegas). O `-Precheck` com `verify.compile` já cobre o caso, mas nada garante que rode antes do dev nem avisa com destaque quando o projeto não declara `verify.compile`. 1 vez (A6). Causa não apurada: projeto sem `verify.compile`, Precheck não rodado, ou Precheck que deixou passar.

Fora do plugin (do cliente/stakeholder): decisão de produto de empilhar botões em tela estreita (A3), qualidade do plano/código do projeto (A1, A4), o script de reparo redirecionar a saída.
