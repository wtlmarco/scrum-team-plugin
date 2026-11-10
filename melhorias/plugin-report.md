# Relatório ao dono do plugin — Sprint 5 — 2026-11-10

**Versão do plugin instalada:** 3.57.0 · **Unidade de estimativa:** dias · **Sprint de** 25 Tasks (22 no quadro final de planejamento + 3 de correção do portão) · 4 Histórias aceitas + 1 habilitadora
**Registro de consumo:** existe (1.218 linhas medidas; `-Session` rodado no fechamento). A cota da assinatura saiu "sem registro da cota" (status line do plugin não ligada neste projeto), então a seção 1 traz tokens e não cota.
**Ocorrência que motivou o relatório:** ambas — falha de execução persistente (≥ 2) **e** consumo anômalo (papel com consumo > 2× a média dos sprints anteriores: sessão principal 8,5× o sprint anterior; Arquiteto/Opus e executor de Task com contagem de agentes ≥ 3× a dos sprints 1–3). Mais 11 lições de plugin (iii) do `knowledge.ps1`. Decisão do stakeholder: **investigar**.

## 1. Consumo por papel e por modelo
> Fonte: `consumption.md` do sprint. Tokens são o total processado por invocação (entrada + cache gravado + cache lido + saída). Modelos como servidos, com versão.

| Papel | Modelo | Σ tokens | Instâncias · rodadas | Duração total | % do total |
|---|---|---|---|---|---|
| Arquiteto | opus 5.5 | 156.003.081 | 93 · 97 | 357:13 | 20,0% |
| dev | haiku 5.5 | 133.208.163 | 86 · 207 | 739:56 | 17,1% |
| dev | sonnet 5.5 | 34.557.836 | 83 · 179 | 383:33 | 4,4% |
| executor de Task (`task-runner`) | sonnet 5.5 | 34.024.455 | 169 · 525 | 94:53 | 4,4% |
| QA | sonnet 5.5 | 13.372.138 | 29 · 32 | 56:00 | 1,7% |
| SM | sonnet 5.5 | 6.460.930 | 12 · 14 | 16:45 | 0,8% |
| PO | sonnet 5.5 | 3.204.582 | 4 · 4 | 05:49 | 0,4% |
| vigia | haiku 5.5 | 133.222 | 5 · 5 | 00:43 | 0,02% |
| operator ← dev | haiku 5.5 | 12.676.865 | 34 · 61 | 100:02 | 1,6% |
| operator ← chamador não identificado ("?") | haiku 5.5 | 10.810.727 | 21 · 41 | 85:11 | 1,4% |
| operator ← task-runner | haiku 5.5 | 5.931.930 | 17 · 33 | 51:19 | 0,8% |
| operator ← Arquiteto | haiku 5.5 | 3.563.979 | 6 · 7 | 23:34 | 0,5% |
| operator ← QA | haiku 5.5 | 1.257.356 | 1 · 11 | 03:14 | 0,2% |
| dev / executor de Task (modelo ausente no transcript) | não disponível — o transcript não trouxe o modelo | 0 | 2 · 2 | 00:00 | 0% |
| **Total** (papéis + `operator`) | — | **415.205.264** | **562 · 1.218** | — | — |
| sessão principal (`consumption.ps1 -Session`, por `message.id`) | sonnet 5.5 | 364.384.614 | 20 sessões · 20 | 8480:08 | 46,7% do total geral (779.589.878) |

- **Contra o sprint anterior:** papéis + `operator` 185,4 M → 415,2 M (+124%); sessão principal 42,9 M → 364,4 M (8,5×). O sprint anterior havia validado a redução da sessão (227,8 → 42,9 M); neste a sessão voltou a dominar. Causa aparente: seção 2, itens 1 e 2.
- **Delegação ao `operator` (candidato a investigar):** 79 instâncias do `operator` (≈ 34 M tokens) no sprint; 21 delas (27%) sem chamador identificado ("?"). O registro não traz a mesma tarefa sem delegar, então não se afirma economia.

## 2. Ineficiências observadas

| # | Padrão | Papel · modelo | Ocorrências | Σ tokens | Causa aparente (do registro/quadro) |
|---|---|---|---|---|---|
| 1 | Sessão principal que orquestra o `run` reenvia o histórico inteiro a cada despertar; contexto de 56 mil a 409 mil tokens numa sessão; na maior sessão, 56,1 M dos 57,3 M processados foram releitura de cache | sessão principal · sonnet 5.5 | 20 sessões; na maior, 238 chamadas (60 mensagens de progresso de subagente, 54 `run.ps1 next`, 53 avisos de término, 46 disparos, 13 formulários, 12 bloqueios de fim de turno) | 364,4 M | histórico nunca compactado; simulação com reinício e cartão de ~15 mil tokens: −35% (a cada 120 chamadas), −52% (60), −62% (30) |
| 2 | Executor de Task em ciclo vazio: dispara, olha e devolve | task-runner · sonnet 5.5 | 169 instâncias · 525 rodadas; numa medição anterior ao fim, 83% das rodadas tinham ≤ 3 chamadas; 18 agentes por Task (sprints 1–3: 5–5,5) | 34,0 M | `run.ps1 next` sem `esperar` válido com o vigia inoperante; G20 obriga a disparar algo (itens 1, 2, 8 e 15 da seção 4) |
| 3 | Arquiteto (modelo mais caro) concentra o custo: planos lidos com contexto grande, planos refeitos inteiros e toda decisão de GAP no mesmo modelo | arc · opus 5.5 | 93 instâncias · 97 rodadas (sprints 2–4: 19–25 agentes); replanos de uma Task ×5, outras ×3 | 156,0 M (37,6% de papéis + `operator`) | decisão de GAP com o contexto completo; ampliação de plano sem delta |
| 4 | Papel repetido na mesma Task | dev · haiku 5.5 / sonnet 5.5 | Task A: 73 rodadas de dev; Task B: 32; Task C: 30; Task D: 22 | Task A 69,5 M | prova no alvo que falha por ambiente e é repetida; execuções de suíte simultâneas (seção 3, item 1) |
| 5 | Task cara (> 2× a média de ≈ 14 M por Task) | vários | Task A (234 linhas, 4,9×), Task E (2,9×), Task F (2,0×) | 69,5 M · 41,7 M · 28,6 M | A: prova de tela em alvo instável; E: habilitação da prova de tela; F: GAPs de interface |
| 6 | Modelo × trabalho | dev · haiku 5.5 | 207 rodadas em 86 instâncias (2,4 por instância; sonnet: 2,2) | 133,2 M | **candidato a investigar, não a trocar às cegas**: o modelo barato concentra o retrabalho de dev (categoria retrabalho = 175,8 M, 42,3% de papéis + `operator`) |
| 7 | Consumo × falha | vários | 5 voltas de verificação para bloqueada por ambiente (3 numa Task, 1 em cada de outras duas); Task A com vários bloqueios de ambiente | Task A 69,5 M | alvo de prova (emulador) indisponível ou ocupado |
| 8 | Habilitação da ferramenta de prova de tela fora da Planning | dev · arc · operator | 6 Tasks + 2 canceladas | ≈ 99 M (≈ 31% do custo dos subagentes na medição de 09/11) | prova de tela do `accept` não funciona quando a WebView não publica ids no dump; cada projeto reconstrói a prova no sprint (seção 3, item 3) |

## 3. Bloqueios, falhas e gaps de processo

| # | O que aconteceu, sem o contexto do projeto | Regra / cerimônia | Degrau do bloqueio (R25) | Ocorrências |
|---|---|---|---|---|
| 1 | Dois ou mais desenvolvedores e suítes completas simultâneos na mesma Task: o `run.ps1 next` não enxerga o dev que "parou esperando comando em segundo plano" (lista de agentes ativos vazia) e manda construir de novo; cada executor novo roda `start` e dispara outro dev; a suíte reescreve o resumo de cobertura da outra | `sprint-run.md` (laço `next`), G20, `run.ps1 start` | stakeholder (formulário: encerrar as duas suítes mais novas) | 3 devs e 3 suítes simultâneas; ≥ 25 mil tokens por ciclo vazio |
| 2 | A sonda `run.ps1 wait` do vigia usa `Start-Sleep -Seconds 30`, que a G14 nega dentro do run | G14 · vigia (`sprint-run.md`) | par PO+Arquiteto (sem dono; registrado) | vigia disparado 3 vezes, 3 sem sonda |
| 3 | `accept.ps1` não prova tela quando o dump de acessibilidade não traz os ids da WebView (Android 15, WebView 124; no Android 13 trazia). `next`, `start` e cartão de passagem mandam rodar o `accept`; o plano manda o contrário porque o `accept` desinstala o app e apaga a base. O portão exige o resultado do `accept` fresco, sem rota para a prova pelo CDP | `sprint-run.md` §Validação do sprint · `accept.ps1` · `targets/android.ps1` | stakeholder (autorizou rodar o `accept` só para registrar a falha e apagar a base) | 3 formulários; o resultado do portão saiu ❌ por limite da ferramenta |
| 4 | `verify -Mode full` roda o passo `coverage` ANTES da suíte e lê o resumo que a suíte anterior deixou; uma suíte que cai o deixa corrompido ("0/0") e o `full` seguinte reprova com "na baseline e não foi medido" | `verify.ps1` | par PO+Arquiteto | 4 rodadas perdidas numa Task |
| 5 | Mensagem enganosa do `verify`: exit 4 "navegador não instalado" quando o Chrome sem cabeça não sobe por "Failed to create a temp dir" (órfão de rodada que caiu) | `verify.ps1` | par PO+Arquiteto | 1 |
| 6 | `close.ps1` só reconhece "nenhum — motivo" na linha **Cenários:** do plano (não "nenhum aplicável — motivo"); o `plan.ps1` aceita as duas formas; sem rota de desvio para o R7-aceite | `plan.ps1` regra de Cenários · `close.ps1` R7-aceite | par PO+Arquiteto | 1 Task, várias idas e voltas |
| 7 | `run.ps1 next` ignora a dependência de uma Task em construção: continuou mandando construir a Task dependente enquanto a outra estava em 🟨 | `run.ps1 next` · `Depende de` | par PO+Arquiteto | 4 `next` seguidos |
| 8 | `quality.ps1`: a regra de TODO sem ID casa a palavra "TODOS" (59 falsos positivos); a regra de cobertura leu "Unknown 0/0" quando o `guards.json` aponta o gate errado | `quality.ps1` Q9, Q11 | par PO+Arquiteto | 2 regras, portão ❌ por medição |
| 9 | O executor de prova pelo CDP (script do projeto) só aceita rótulo de Task `T-NNN[a-z]` (recusa `S<n>`); a G14 recusa `Set-Location …; node …` e o diretório não persiste entre chamadas | G14 · `runCommands` padrão do alvo | par PO+Arquiteto | 1 portão |
| 10 | O classificador de permissões negou o encerramento de processos do próprio projeto (suítes duplicadas) mesmo com o stakeholder pedindo; só passou depois de nova ordem | permissões · rota do `operator` | stakeholder | 1 |
| 11 | O executor de Task desobedece a nota da sessão ("não rode start") quando o `done` reprova por evidência faltando e a única rota é `start`; escreve a nota no retorno em vez do `run-log.md` | `sprint-run.md` · `run.ps1 done` | par PO+Arquiteto | 2 Tasks |
| 12 | Caminho do script de reparo do alvo com acento + processo filho herdando o pipe do chamador: o reparo ficou preso ("POSSÍVEL TRAVAMENTO") e exigiu encerramento manual 3 vezes | `target.ps1 -Repair` · `run.ps1 next` (travamento) | stakeholder (formulário a cada vez) | 3 |
| 13 | Entradas fora da Planning acima da capacidade: 11 entradas (9 mantidas, 2 canceladas), todas por decisão do stakeholder com "nada saiu para caber"; soma 16,0 d contra capacidade 11,83 d (+35%) | R4 · R13 · §5e capacidade | stakeholder | 11 |
| 14 | A pasta de evidência por Task da QA ficou vazia em todas as 25 Tasks (a evidência está nos relatórios do dev e no portão); repete o achado do sprint anterior (6 de 9) | R7 · R12 · artifact-ownership | par PO+Arquiteto | 25 de 25 |

### GAPs de processo — as lições de plugin (iii) do sprint (v3.56.0)
> Fonte: `lessons.md` §"Ocorrências de plugin (iii)". Sem contexto do projeto.

| # | Tipo | Sintoma (genérico) | Regra · guarda · script envolvido | Remédio no projeto (`**Até:**`)? |
|---|---|---|---|---|
| 1 | falta de caminho oficial | Teste fora do `verify` (runner nativo do Node) não tem margem nem linha de mutação `M<k>` | `verify.ps1` · plano de mutação | sim — procedimento local, até a mutação rodar esse runner |
| 2 | script contradiz o plano | O cartão manda o dev provar no alvo; o plano diz que dev não roda `accept` nem `adb` (toque em janela é do `operator`) | cartão de passagem · `sprint-run.md` | não |
| 3 | conferência reprova o certo | Id de cenário montado em tempo de execução não é visto pelo verificador de ids de teste ("id ausente") | `testids` do `verify` · `guards.json` | sim — ids dinâmicos declarados em `testIds.dynamic` |
| 4 | conferência reprova o certo | Dump do alvo sem nenhum id da WebView é classificado como "id ausente"/estado de partida em vez de ambiente | `accept.ps1` · `targets/android.ps1` | não |
| 5 | falta de caminho oficial | Task sem teste do framework principal não roda `verify -Mode focused`; a prova é o comando da Task com a saída colada | `verify.ps1` · `close.ps1` | não |
| 6 | conferência reprova o certo | Cenário de tela provado por executor de prova que não é o `accept` fecha pela evidência do QA, não pelo R7-aceite do dev | `close.ps1` R7-aceite | não |
| 7 | falta de caminho oficial | Task que só reorganiza um arquivo de teste (sem arquivo de produção) não tem linha de mutação possível | `plan.ps1` · `close.ps1` R7-mutação | não |
| 8 | guarda nega o legítimo | Não há dispensa do `verify full` no fechamento: toda Task com `verify` configurado roda o `full`, mesmo a que só mexe em configuração de teste | `close.ps1` R7-verify | não |
| 9 | guarda nega o legítimo | Mesmo sintoma do item 8, registrado na decisão do fechamento da Task (R7-verify sem dispensa por plano) | `close.ps1` R7-verify | não |
| 10 | conferência reprova o certo | Raiz de componente recebe id em runtime; o `testids` do `full` acusa 8 linhas até o id ser declarado dinâmico | `testids` · `guards.json` | sim — igual ao item 3 |
| 11 | falta de caminho oficial | Task de laudo, sem código e sem teste, não tem modo do `verify` aplicável | `verify.ps1` · `close.ps1` | não |

## 4. Sintomas para o `note.md` do plugin
> Sintoma, não solução.

| # | Sintoma observado neste sprint | Onde doeu | Quantas vezes |
|---|---|---|---|
| 1 | O `run.ps1 next` não trata "dev esperando comando em segundo plano" como espera: manda construir e dispara dev duplicado | `run.ps1 next` · `start` · G20 | 3 devs/suítes simultâneos |
| 2 | A sonda do vigia (`run.ps1 wait`) usa `Start-Sleep`, que a G14 nega: o vigia nunca sonda | G14 · vigia | 3 |
| 3 | A G20 obriga a disparar um agente a cada fim de turno, mesmo quando a resposta correta é esperar; ciclos vazios de executor | G20 · `run.ps1 next` | 83% das rodadas do executor com ≤ 3 chamadas (medição parcial) |
| 4 | O `accept` não prova tela quando o dump não traz ids; o `next`, o `start` e o cartão mandam rodá-lo mesmo assim; o portão exige o resultado dele; o `accept` reinstala o app e apaga a base de teste | `accept.ps1` · `targets/android.ps1` · `sprint-run.md` §Validação | 3 formulários ao stakeholder |
| 5 | Sem caminho oficial para aceitar a prova de tela por CDP no portão | `sprint-run.md` §Validação do sprint | 1 sprint |
| 6 | O passo `coverage` do `verify full` roda antes da suíte e lê resumo corrompido | `verify.ps1` | 4 rodadas |
| 7 | Mensagem de erro do `verify` não aponta a causa (Chrome órfão / pasta temporária) | `verify.ps1` | 1 |
| 8 | `plan.ps1` e `close.ps1` aceitam formas diferentes da linha **Cenários:**; sem rota de desvio no R7-aceite | `plan.ps1` · `close.ps1` | 1 |
| 9 | `run.ps1 next` ignora `Depende de` para Task já em construção | `run.ps1 next` | 4 |
| 10 | Regra de TODO sem ID casa "TODOS"; regra de cobertura lê o comando errado e reporta "Unknown 0/0" | `quality.ps1` Q9, Q11 | 2 |
| 11 | O padrão de stack para front-end com runner Karma não traz o limite de inatividade e a tolerância de desconexão como armadilha conhecida; o padrão de 30 s derrubou a suíte completa em cerca de 1 de cada 2 rodadas | `standards/stacks` | quase toda Task do sprint |
| 12 | A sessão principal do `run` fica fora da contabilidade do `usage.jsonl` quando o `-Session` não roda; quando roda, ela é 46,7% do total; falta reinício por Task ou por N chamadas com cartão de passagem; subagentes mandam progresso por `SendMessage` à sessão | `consumption.md` · `sprint-run.md` | 20 sessões |
| 13 | O Arquiteto em Opus recebe toda decisão de GAP com contexto completo e refaz planos inteiros em vez de delta | `agents/architect` · `/arc plan` | 93 instâncias |
| 14 | A tabela de preço do Haiku no `usage.jsonl` é inconsistente: o mesmo modelo e a mesma versão do plugin têm preço implícito por token diferente (0,1 em 312 linhas; 0,2–0,5 em cerca de 50) — a confirmar | `prices.ps1` · `usage.jsonl` | ≈ 50 linhas |
| 15 | O `operator` sai sem chamador identificado em 27% das instâncias ("?"), pelo 5º sprint seguido; o `report.md` por chamada só aparece quando o chamador cita a pasta do job | `consumption.ps1` · `agents/operator.md` · R28 | 21 de 79 |
| 16 | O encerramento de processos do próprio projeto (suíte/Chrome/node duplicados) não tem rota oficial; o classificador de permissões nega | permissões · `operator` | 1 |
| 17 | O reparo do alvo prende em "POSSÍVEL TRAVAMENTO" quando o processo filho herda o pipe; o `next` não distingue de espera legítima | `target.ps1 -Repair` · `run.ps1 next` | 3 |
| 18 | A prova de tela por CDP não vem pronta no plugin; cada projeto a reconstrói dentro do sprint (≈ 31% do custo dos subagentes) | `targets/android.ps1` · `accept.ps1` | 6 Tasks fora da Planning |

## 5. Encaminhamento
- **Relido contra vazamento de contexto pelo SM:** sim (sem nome de projeto, cliente, produto, domínio, caminhos de arquivo do projeto, IDs de Task/História; Tasks identificadas por letras)
- **Lido pelo stakeholder antes de encaminhar:** pendente
- **Encaminhado ao dono do plugin:** não — fica registrado para reincidência
- **Sintomas levados ao `RAIZ/note.md`:** nenhum (o stakeholder encaminha)
