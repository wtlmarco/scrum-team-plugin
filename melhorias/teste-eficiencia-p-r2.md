# Teste de eficiência: plugin atual × projeto sem plugin (P-r2 no SunScape)

> **Dono:** stakeholder (autoriza o custo e decide pelo resultado). **Executa:** a sessão do benchmark (`C:\app-personal\scrum-team-benchmark`), pelo `env\driver.ps1`.
> **06/11/2026, decisão do stakeholder:** a v3.56.0 (`plano-v3.56.0.md`) entra antes de retomar o uso do plugin, e o **P-r2 roda com a 3.56.0**. As referências à 3.55.0 abaixo valem para a 3.56.0, com o commit gravado na remontagem. A v3.56.0 é a exceção aprovada à regra do §7 ("só correções que bloqueiem o braço"). Depois dela, o congelamento volta a valer até o P-r2 fechar. O braço NT não muda: o kit de travas continua no commit `4da0283`.
> Escrito em 05/11/2026, a partir da avaliação do plugin 3.55.0. **Nada aqui muda limiar, portão ou peso do `protocol.md`:** o teste é a Etapa 6a já prevista (P+ × N-forte no SunScape), adiada desde 24/10.

## 1. Pergunta

Com a versão atual (3.55.0), o plugin entrega **a mesma qualidade** de um projeto sem plugin (braço N-forte) **a um custo e um tempo aceitáveis**?

## 2. Por que este teste e não outro

- As únicas medições contra um braço sem plugin são de versões antigas e ficaram muito longe do alvo:

  | Projeto | N-forte (sem plugin) | Plugin | Razão |
  |---|---|---|---|
  | Mente Ativa | US$ 6,44 · 62 min · lote 4/4 | P-r6 (v3.50.1): US$ 54,51 · 408 min · lote 2/4, docs piores na revisão cega | 8,5× custo · 6,5× tempo |
  | SunScape | US$ 8,90 · 72 min · 15/15 · lote 4/4 | P-r1 (v3.51.3): ~US$ 40 · 825 min, parou no teto sem terminar o sprint | ≥ 4,5× custo · 11× tempo |

- Entre a v3.51.3 e a 3.55.0 saíram ~15 versões, muitas voltadas a consumo (executor de Task, ficha por Task, G23, plano ≤ 30 KB, plano externo). **Nenhuma foi medida contra o N-forte.** O P-r2 chegou a ser montado com a 3.53.5 (02/11), mas não rodou.
- O garden não responde a esta pergunta: ele não tem um braço sem plugin para comparar. O SunScape tem oráculo, avaliador e dois braços de referência já reavaliados no container (N-forte-r1 e CO-r1: 15/15, lote 4/4, ANR 0).

## 3. Braços

| Braço | Estado | Roda de novo? |
|---|---|---|
| **N-forte-r1** (sem plugin) | medido: US$ 8,90 · 72 min · 15/15 · lote 4/4 | não — é a linha de base |
| **CO-r1** (protótipo Coordenador–Operador) | medido: US$ 26,45 · ~480 min · 15/15 · lote 4/4 | não — referência |
| **P-r1** (v3.51.3) | parado por teto | não — é o "antes" |
| **P-r2** (plugin **3.55.0**) | **a rodar** | **sim — é este teste** |
| **NT-r1** (N-forte + travas, §8.1) | a montar | sim — depois do P-r2, qualquer que seja o resultado |

## 4. Pré-requisitos (nesta ordem)

1. **Congelar o plugin.** A 3.55.0 (commit `4da0283`, branch `feat/v3.55.0`) é mesclada em `develop` e em `main`. **Nenhuma versão nova sai entre a montagem do braço e a avaliação dele.** Se um defeito bloquear o braço, ele é registrado como resultado, e a correção vai para depois.
2. **Atualizar o plugin no perfil dos braços** (`CLAUDE_CONFIG_DIR=%USERPROFILE%\.claude-pessoal`):
   ```powershell
   claude plugin marketplace update team
   claude plugin update team@team
   ```
   Depois, reiniciar a sessão do Claude Code.
3. **Remontar o P-r2.** Mover a montagem 3.53.5 (`C:\app-personal\bt\sunscape-P-r2` e `results\sunscape\P-r2`) para `bt\_backup\P-r2-montagem-v3.53.5`. Em seguida:
   ```powershell
   cd C:\app-personal\scrum-team-benchmark
   powershell -NoProfile -File env\driver.ps1 -Action New -Project sunscape -Arm P -Rep 2
   ```
   Conferir no `results\sunscape\P-r2\run.json`: `plugin_version` = `3.55.0` e `plugin_commit` = o `origin/main`.
4. **Conferir o `guards.json` do braço** (vem de `projects/sunscape/bench/guards.android.json`). Ele precisa ter as chaves que as versões novas pedem: `targets.android.serial` = `localhost:5557`, `targets.android.repair`, `verify.env.ANDROID_SERIAL`, `run.planner` = `claude` (o plano externo fica **fora**: o N-forte não teve ajuda externa), `testIds.attribute` (se o projeto pedir) e `runCommands` declarados antes da construção (regra 32, v3.55.0). Rodar o `-ParseOnly` do accept e o `plan.ps1` vazio para ver se nada reprova por configuração.
5. **Emulador:** `env\setup-android.ps1 -Check` ok. Nenhum outro automatizador no `bench-emulador` (nem avaliador, nem sonda, nem o garden). Máquina na tomada e sem suspensão.
6. ~~Fixar o alvo da Sprint inteira antes de rodar.~~ **Decidido pelo stakeholder em 05/11/2026 e registrado no §17 do `protocol.md`:** a Sprint inteira (fases `sprint` e `fix`: planos, cenários, dev, portão do QA e orquestração) fica em **≤ 2× o custo e ≤ 3× o relógio** de build + fix do N-forte, ou seja, **≤ US$ 17,80 e ≤ 216 min**. A fase `open` fica fora, com orçamento próprio.
7. **Autorização de custo** do stakeholder. O teto do braço continua em US$ 90 e 480 min (`env/ceiling.json`). Estourar o teto é resultado, não motivo para continuar.

## 5. Execução

```powershell
cd C:\app-personal\scrum-team-benchmark
powershell -NoProfile -File env\driver.ps1 -Action Run -Project sunscape -Arm P -Rep 2 -Phase open
powershell -NoProfile -File env\driver.ps1 -Action Run -Project sunscape -Arm P -Rep 2 -Phase sprint
powershell -NoProfile -File env\driver.ps1 -Action Run -Project sunscape -Arm P -Rep 2 -Phase fix
powershell -NoProfile -File env\driver.ps1 -Action Summary -Project sunscape -Arm P -Rep 2
```

- Nenhuma intervenção humana além das respostas do `bench/answers.json` (G18).
- Pausa por limite de conta: anotar a hora de início e de fim. A pausa sai do relógio (como no P-r1), mas **é registrada**, porque mostra o peso do braço na cota.
- **Só avaliar depois que o braço terminar** (a contaminação do CO-r1 vem disso):
  ```powershell
  powershell -NoProfile -File env\eval\run-sunscape.ps1 -Label P-r2 -Apk C:\app-personal\bt\sunscape-P-r2\source\app\build\outputs\apk\release\app-release.apk
  ```

## 6. O que medir

### 6.1 Custo e tempo (vale contra o N-forte)

| Medida | Fonte | Comparar com |
|---|---|---|
| US$ e minutos por fase (open, sprint, fix) e total | `summary.json` do driver (soma pela diferença do acumulado da sessão, regra de 17/10) | N-forte-r1: build US$ 6,89 · 61,4 min / fix US$ 2,00 · 10,6 min (total US$ 8,90 · 72 min) |
| Custo por atividade: código, teste, verificação, aparelho e cenários, leitura, documentação, orquestração, registros, leitura do processo | `activity.txt`/`activity.json` | linha de base por atividade do N-forte-r1 e do CO-r1 |
| **Construção do dev** (código + teste + verificação + aparelho do papel `developer`) | `activity.json` | **≤ 1,5× custo e ≤ 2× relógio** do N-forte |
| **Sobrecusto do processo** (tudo que não é construção do dev) | `activity.json` | alvo da Sprint inteira (passo 4.6) |
| Custo por papel e por modelo (Opus/Sonnet/Haiku), com o Arquiteto em plano e em retrabalho separados | `consumption.ps1 -Session` e `consumption.md` do braço | garden S5: Arquiteto = 84 % dos subagentes |
| % da cota de 5 h e da semanal consumida pelo braço | `quota-log.jsonl` (status line) | — (dado novo; serve para o item 9 de `validacoes-sprint-6.md`) |

### 6.2 Qualidade (não pode cair)

| Medida | Fonte | Alvo |
|---|---|---|
| Fluxos do oráculo | `run-sunscape.ps1` | **15/15** |
| Lote de defeitos do fix | idem | **4/4** |
| RNF (arranque a frio, ANR, APK) | idem | ANR 0, arranque < 2 s |
| Revisão cega de código e documentação (rastreabilidade, correção, decisões, como rodar e estender, consistência) | mesmo roteiro do Mente Ativa (`review-X/Y`), com P-r2 e N-forte-r1 sorteados | docs **≥ N-forte-r1** e não abaixo do P-r6 |
| Avaliação por 3 IAs externas (organização das tarefas e documentação) | `avaliacao-externa/`, mesmo formato | média ≥ 4,0 |

### 6.3 Sinais do processo (explicam o resultado, não decidem)

Para cada Task, registrar: GAPs ao Arquiteto (plano e alvo), planos acima de 30 KB, instâncias cortadas pela G23, formulários ao stakeholder, comandos negados pela G14 e mutações `inconclusivo`. Fontes: `run-log.md`, `guards.log` e `consumption.md`. Esses mesmos números fecham, para o SunScape, os itens 8, 12, 15, 17 e 18 de `validacoes-sprint-6.md`.

## 7. Decisão pelo resultado

| Resultado do P-r2 | Leitura | Próximo passo |
|---|---|---|
| Qualidade igual (15/15, 4/4, docs ≥ N-forte), construção ≤ 1,5×/2× **e** Sprint inteira dentro do alvo | o plugin compete com o projeto sem plugin | Etapa 6b: P e N-forte no price-agent (confirmação em projeto novo) |
| Qualidade igual, construção dentro do alvo, Sprint inteira **fora** | o custo está no processo, não no dev | cortar processo (§8.2) e medir de novo antes de qualquer recurso novo |
| Qualidade igual e construção **fora** do alvo | o custo está no ciclo do dev (verify, accept, retrabalho) | atacar o ciclo do dev com os dados de 6.3 |
| Qualidade **abaixo** (fluxo falho, lote < 4/4 ou docs < N-forte) | o processo não paga o que custa | decisão do stakeholder sobre manter o plugin (regra da Etapa 6, `protocol.md` 19/10: encerrar exige falhar também no price-agent) |
| Parou no teto | resultado, como o P-r1 | ler 6.1 e 6.3 até o ponto da parada; nada de retomar o braço |

**Regra para a fila do `/review`:** até este teste fechar, entram no plugin só correções de defeito que bloqueiem o braço. Nenhum mecanismo novo de processo.

## 8. Braços seguintes

### 8.1 NT · N-forte + travas (roda sempre, depois do P-r2)

**Pergunta:** as travas mecânicas do plugin (classe T em `regras-por-papel-vs-sem-plugin.md`) melhoram a qualidade de um modelo que constrói sozinho? E a que custo? O P-r2 mede o plugin inteiro. O NT mede **só o núcleo que funciona sem Arquiteto, dev separado, run ou cerimônia**. Os dois respondem perguntas diferentes, por isso o NT roda qualquer que seja o resultado do P-r2.

**Como o braço é montado:**

| Peça | O que é | De onde vem |
|---|---|---|
| Prompt | **o mesmo do N-forte** (`driver.ps1:68`), sem nenhuma palavra a mais; a diferença fica toda no `CLAUDE.md` e nas travas | `driver.ps1` |
| `CLAUDE.md` do worktree | as 14 linhas da classe I (rascunho abaixo) | este arquivo |
| Kit de travas em `.travas/` | cópia **fixa** de `verify.ps1`, `accept.ps1`, `target.ps1`, `targets/`, `lib.ps1`, `common.ps1` e `web-runner.js` do commit `4da0283` (3.55.0), mais o formato do `.scn` (README do QA, seção do cenário) | repositório do plugin; **não é versão nova do plugin**: é uma cópia para o benchmark |
| `.team-project/guards.json` | só `verify` (comandos do Gradle, `testIds`), `targets.android` (serial `localhost:5557`, `repair`, `seeds`) e `protectedPaths`. Os scripts leem e gravam nesta pasta, que fica fora do git | `projects/sunscape/bench/guards.android.json`, sem as chaves de run, plano e papéis |
| Hooks em `.claude/settings.json` do worktree | **G5** (nega escrita nos `protectedPaths`), **G6** (nega aumento de skip em teste) e **trava de evidência no `Stop`**: barra o fim de turno se o último `verify full` não está verde **na árvore atual**, ou se o último `accept` falhou. Libera depois de 3 bloqueios seguidos, como a G20, e registra cada bloqueio | trechos extraídos do `pre-tool.ps1` e do `close.ps1` (R7, R7-verify, R7-aceite) para um script pequeno |
| Plugin | **desligado** (`enabledPlugins` com `team@team: false`, como no N-forte) | `protocol.md` |

**Fica fora:** mutação (depende das linhas `M<k>` do plano; o valor dela é medido no P-r2, item 17), quadro, Histórias, plano escrito, relatório de entrega e QA separado.

**Rascunho do `CLAUDE.md` (classe I):**

```markdown
# Como trabalhar neste projeto
- Leia só o necessário para o passo atual; na releitura, só o que mudou.
- Faça commit a cada passo concluído e anote em NOTAS.md onde parou, para retomar após interrupção.
- Só o que o pedido pede: nada de recurso ou refatoração fora dele.
- Regra de negócio tem teste de unidade; integração tem teste de integração. Cada critério do pedido tem um cenário em docs/cenarios/*.scn (formato em .travas/README-cenario.md).
- Todo controle interativo da tela tem testTag na gramática de .travas/test-ids.md.
- Tarefa sensível: segredo fora do código, entrada validada.
- Siga os padrões do linter do build; não afrouxe a configuração dele.
- Atualize README e decisões no mesmo passo em que o código muda.
- Layout novo se prova no aparelho, pelo accept, não por leitura do código.
- Saída de comando longa vai para arquivo; leia o resumo.
- Comando longo: rode em segundo plano e espere o aviso de término; não sonde nem use sleep.
- Antes de dizer pronto: `powershell -File .travas/verify.ps1 -Task build -Mode full` e `powershell -File .travas/accept.ps1 -Task build -Target android -Scenarios docs/cenarios` verdes na árvore atual.
- Pergunta ao stakeholder: em formulário, com opções, exemplo e recomendação.
```

A linha da G14 vira configuração: allowlist em `.claude/settings.json` com os mesmos comandos do `runCommands` do `guards.json` do SunScape.

**Preparação (no repositório do benchmark, sem mexer no plugin congelado):**

1. `env/driver.ps1`: braço `NT` no `ValidateSet`, com a mesma sequência do N-forte (build, depois fix) e a montagem do kit, do `CLAUDE.md`, do `guards.json` reduzido e dos hooks no `New`.
2. `env/travas/`: script que copia o kit do commit fixado e o script dos hooks (G5, G6, trava de evidência).
3. **Ensaio sem custo de modelo:** rodar o kit no código já pronto do N-forte-r1 (`bt\sunscape-N-forte-r1`). O `verify full` tem de passar, e o `accept` tem de rodar cenários escritos à mão para 3 dos 15 fluxos. Ver também se o `testids` acusa controles sem id: isso mostra, de graça, o que as travas pegariam no código do N-forte.
4. Registrar o braço no `protocol.md` §17 **antes de rodar** (emenda: braço novo, mesmas medidas, mesmo oráculo).
5. Autorização de custo. **Proposta de teto:** US$ 30 e 180 min (cerca de 3× o N-forte-r1).

**Medidas:** as mesmas do §6.1 e do §6.2. A elas se somam as que mostram se as travas pagam:
- quantas vezes o `verify` e o `accept` saíram vermelhos e foram corrigidos antes do fim;
- bloqueios da trava de evidência no `Stop`;
- negações da G5 e da G6;
- reprovações do `testids`;
- o custo da atividade "aparelho e cenários" contra os 14 % do N-forte.

**Leitura:**

| Resultado do NT-r1 contra o N-forte-r1 | Leitura | Próximo passo |
|---|---|---|
| Qualidade **maior** (menos defeitos na revisão cega, ou 15/15 e 4/4 com menos achados) e custo ≤ 1,5× | as travas são o que o plugin tem de valor | o produto passa a ser o kit de travas; P-r2 e NT no price-agent para confirmar |
| Qualidade **igual** e custo ≤ 1,5× | as travas não atrapalham, mas não aparecem num projeto pequeno | repetir no price-agent (motor de regras: mais chance de defeito) |
| Qualidade igual e custo > 1,5× | as travas custam mais do que pegam neste tamanho de projeto | ver quais travas dispararam; tirar as que não pegaram nada |
| Qualidade **menor** | a trava atrapalhou (laço no `Stop`, contexto gasto com as travas) | ler o `guards.log` do braço antes de qualquer conclusão |

**Comparação a três:** com o P-r2, o NT-r1 e o N-forte-r1 no mesmo oráculo, a diferença P-r2 − NT é o que a estrutura do plugin (Arquiteto, dev separado, run, cerimônia) acrescenta **além** das travas, em custo e em qualidade. Se ela for custo sem qualidade, a estrutura sai.

### 8.2 P-enxuto (só se o P-r2 cair na 2ª ou 3ª linha do §7)

Se o resultado do P-r2 cair na segunda ou na terceira linha da tabela do §7, roda também um **P-enxuto** no mesmo SunScape, com as mesmas medidas:

- sem abertura completa (brainstorm, onboarding, SDD e protótipo), com o pedido e os anexos como especificação;
- sem plano do Arquiteto por Task: a sessão (Sonnet) escreve um plano curto, e o Arquiteto entra só no GAP;
- dev, `verify`, `accept` e portão do QA iguais aos do P-r2.

Se o P-enxuto empatar em qualidade com custo menor, ele vira o modo padrão, e cada fase cortada volta só com medição que mostre o ganho.

Se o NT-r1 já tiver mostrado, antes, qualidade igual ou maior que a do N-forte com custo ≤ 1,5×, o P-enxuto **não roda**: ele mantém o dev separado, e o NT terá mostrado que essa separação não é necessária.

## 9. Limites declarados

- **1 repetição por braço:** uma diferença pequena (< 10 pontos na nota composta, < 3 defeitos) é empate.
- O SunScape tem especificação fechada. Ele **não** testa os rituais de preparação (Etapa 7) nem o ganho do plugin ao longo de vários sprints (rastreabilidade, regressão). Para esse ganho, o garden continua sendo a fonte, sem braço de controle.
- Os preços são os da API (o driver lê o `total_cost_usd`). Na assinatura Pro, o peso real é a cota: o `quota-log.jsonl` registra a cota, mas os pesos por modelo ainda não estão calibrados (item 9).
- O N-forte-r1 rodou em 18/10 com o plugin desligado, e o `run.json` dele não registra o modelo da sessão. Se o modelo padrão da conta mudou (hoje: Opus 5.5), registrar no `run.json` o modelo de cada braço novo e **rodar um N-forte-r2** com o modelo atual antes de comparar. Vale para o P-r2 e para o NT-r1.
