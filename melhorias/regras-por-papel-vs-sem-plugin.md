# Regras do plugin por papel: o que cada uma corrige e como um modelo sem o plugin trataria

> Escrito em 06/11/2026, sobre a v3.55.0. **Dono:** stakeholder. Serve de base para o braço enxuto do `teste-eficiencia-p-r2.md` (§8).
> **Fontes:** `hooks/COVERAGE.md`, `roles/architect/templates/implementation-plan.md` e `plan-rules-why.md`, `roles/scrum-master/process/working-rules.md`, os scripts de `scripts/checks/`, `CHANGELOG.md` e `process-changelog-archive.md` (lidos por busca).
> **Régua "sem plugin":** o braço N-forte do benchmark. Ele recebe uma frase só: *"Implemente como um engenheiro sênior: plano curto, passos pequenos, teste para cada regra, build/lint/testes, README com como rodar e as decisões, confira cada critério antes de parar"* (`scrum-team-benchmark/env/driver.ps1:68`). Com essa frase entregou SunScape 15/15, lote 4/4, US$ 8,90 em 72 min, e Mente Ativa lote 4/4, US$ 6,44, com documentação mais bem avaliada que a do P-r6.

## Como ler a classificação

| Classe | Quer dizer | O que fazer com a regra |
|---|---|---|
| **N · nativo** | O modelo forte já faz isso com a frase do N-forte. A regra custa leitura e conferência sem ganho visível. | Candidata a sair |
| **I · instrução** | O problema é real, mas uma linha no `CLAUDE.md` do projeto ou uma configuração nativa do Claude Code (allowlist, notificação) resolve sem mecanismo próprio. | Virar linha de instrução |
| **T · trava que vale** | O problema é geral, o modelo sem plugin escorrega nele e uma trava mecânica barata (script ou hook) se paga. | **Núcleo a manter** |
| **P · problema do plugin** | O problema só existe por causa da estrutura do plugin: vários agentes, um planeja e outro constrói, run autônomo, cerimônia Scrum simulada, manutenção do próprio plugin. Um modelo sem o plugin nunca o encontra. | Some se a estrutura que o cria sair |

**Limite desta leitura.** A coluna "sem plugin" é medida só onde o N-forte dá prova: ele usou o emulador por conta própria (14 % do custo em "aparelho e cenários"), escreveu README, rodou testes e terminou o fix em 10 min. No resto, é julgamento meu, marcado com *(julg.)*. O garden não tem braço sem plugin, e nada aqui foi medido em projeto de vários sprints ou com pedido aberto.

---

## 1. Sessão principal e Scrum Master (orquestração)

| Regra | O que corrige (incidente) | Como um modelo sem o plugin trataria | Classe |
|---|---|---|---|
| R1 · uma Task por vez | Duas Tasks "90 % prontas" ao mesmo tempo (genérico) | Uma sessão só já trabalha em sequência | P |
| R2 · plano de até ~10 passos, senão divide | Piloto: 32 arquivos, 4 instâncias de dev, 2 paradas relatadas como prontas | Não há dev separado que perca o fio | P |
| R3 · contexto mínimo | Plano de 27 KB relido 117 vezes no piloto | Não há plano para reler; o código é a fonte *(julg.)* | I |
| R5 · interrupção é estado ("Parei no passo") | Agente de 4 h cujo relatório nunca chegou | "Commit a cada passo e anote onde parou" no `CLAUDE.md` | I |
| R6 · decisão vira registro | "Arqueologia" de decisões (genérico) | Já faz: o prompt pede README com as decisões; a documentação do N-forte teve nota melhor que a do P-r6 | N |
| R13 · APF/PMBOK por gatilho | — (método) | Não existe | P |
| R14 · onboarding antes da 1ª Planning | 14 sprints convivendo com 50 GAPs | Lê o repositório quando precisa *(julg.)* | P |
| R15 · brainstorm e portões ①②③ | genérico | Não existe; pedido fechado vira código. Pedido aberto **não medido** (Etapa 7) | P |
| R17/R18/R19 · teto do changelog, versão, evidência do `/review` | Changelog cresceu 12×; README parado na v3.3.0 | Só existem para manter o próprio plugin | P |
| R20/R21/R25 · História × Task, aceite na Review, sprint como unidade de aprovação | Review sem caminho para adiar (sprint 3) | Não existe; o critério é o pedido | P |
| R22 + G3 + H1 · pergunta em formulário com exemplo e "mais contexto" | Decisões chegavam em prosa | "Pergunte com opções e exemplo" no `CLAUDE.md`; a guarda é barata, mas a regra não precisa dela | I |
| R24 + `close -Post` · transição vira registro e série | Burndown "desenhado de trás para frente" | Não há quadro; o `git log` é o registro | P |
| R27 · falha de invocação não culpa o stakeholder | 3 "interrupted" sem ação dele; rede subiu o dev a Sonnet 2× | Só existe no run autônomo com vários agentes | P |
| R28 + G4 · saída pesada vai para arquivo | ~303 mi tokens com 20 subagentes; log de 100 MB no git; 123 retornos = 37 % do contexto | O harness já trunca a saída; "mande log longo para arquivo" basta. O tamanho do problema veio dos 20 subagentes | I |
| R29 + G21 · ritual em sessão nova | Sessão de 360 turnos/86 mi; P-r1 com 67 % do custo relendo contexto | Problema real em sessão longa, mas a sessão longa nasceu da sequência de rituais. Sem plugin: `/clear` entre tarefas | P |
| R31 + G1 · `.team-project` fora do git | Log de 100 MB no git | A pasta não existe | P |
| R32 · consultoria externa | — | Não existe | P |
| R33 · trilha fix com bloco e promoção | "Seis invocações para corrigir três linhas" | "Corrija isto e rode os testes": US$ 2,00 e 10 min no SunScape, lote 4/4 | P |
| R34 · prefixo e pendência para o celular | contato remoto | Não existe | P |
| G2 · não escrever na cópia instalada | cópia sobrescrita no update | Não existe | P |
| G13/G15/G16 · aviso de abertura, registro de permissão, `usage.jsonl` | número da notificação ≠ contexto processado | Útil só para medir o plugin; o Claude Code tem `/usage` e notificação nativos | P |
| G14 · lista de comandos com rota | Run v3.42: 4 agentes parados de 24 min a 5 h 33 min esperando permissão | **Allowlist nativa no `settings.json`** (`/fewer-permission-prompts`). A G14 gerou 19 a 30 falsos negados por sprint, ~25 formulários no garden S5 e negou o reparo do emulador | I |
| G17/G18 · modelo por papel, respostas do dossiê | preparação do benchmark | Não existe | P |
| G19 · não retomar papel caro parado | 16 retomadas do Arquiteto com cache vencido: US$ 22 | Não há Arquiteto para retomar | P |
| G20 · barra fim de turno com run ativo | ~24,5 h de paradas e ~122 h de máquina suspensa com run ativo | Não há run. **A própria G20 gerou o maior laço registrado:** 195 bloqueios no sprint 3 (~100 mi tokens) e 43 num dia na T-042; tem saída de emergência depois de 3 bloqueios | P |
| G22 · sem `Start-Sleep` nem segundo plano no run | P-r1: 48 chamadas só de espera (US$ 3,68) | "Comando longo: espere o aviso, não sonde" no `CLAUDE.md`; o harness já avisa quando termina | I |
| `mark.ps1`, `run.ps1 next` (WIP, uma História por vez, escalonamento, sinal de vida) | 15 Tasks preparadas antes da 1ª construção; dois devs no mesmo emulador | Não há quadro nem fila | P |

## 2. Product Owner e UX

| Regra | O que corrige | Como um modelo sem o plugin trataria | Classe |
|---|---|---|---|
| Brainstorm, backlog, Histórias, `/po note` | transformar pedido vago em escopo | Pedido fechado: lê e constrói. Pedido aberto: **não medido** (é a Etapa 7, onde o PO pode valer) | P |
| Protótipo navegado no portão ① (UX) | aprovar a interface antes do SDD | Não existe. P-r1: UX gastou US$ 0,69 só em leitura *(abertura)* | P |

## 3. Arquiteto (plano por Task)

As 32 regras do plano existem porque **quem planeja (Opus) não é quem constrói (Haiku)**: o plano é um contrato escrito entre duas instâncias. Cerca de 22 valem em todo plano, 16 com reprovação por script. O modelo do plano tem 30 KB, o mesmo tamanho do teto que ele impõe.

| Regra | O que corrige (incidente) | Como um modelo sem o plugin trataria | Classe |
|---|---|---|---|
| 1, 3, 4, 5, 6, 8, 9, 10 · sequência linear, repositório íntegro, uma migration, nomes da spec, arquivo a espelhar, anel, sem refatorar de passagem, citar o standard | boas práticas (sem incidente documentado, salvo a 10) | Faz ao planejar e construir no mesmo contexto: o prompt pede "plano curto, passos pequenos" | N |
| 2 · blocos acima de 8 arquivos | 4 instâncias de dev, paradas relatadas como prontas | Sem dev separado | P |
| 7 + 17 · contrato, não código; trecho literal ≤ 15 linhas | 5 de 8 Tasks com defeito no texto literal do plano, um GAP cada | Quem escreve o código compila na hora; o defeito aparece em segundos, não num ciclo de GAP | P |
| 11 + R26 · ambiente medido executando | Comando de scaffold inexistente; arquivo sensível sobrescrito | Roda o comando e vê o erro | N |
| 12 · plano novo na retomada | "Premissa velha é a causa nº 1 de GAP" | Lê o código atual | P |
| 13, 14, 19, 20 · Conferência por passo, registro do operator, rodar `plan.ps1`, "Planejado durante" | QA conferir a execução; plano em Opus pouco validado | Sem QA separado, operator nem conferidor do plano | P |
| 15 + 16 + G9 · Arquivos tocados fechados, dono e protegidos | Plano mandou o dev escrever documento do time; G9 com falha aberta deixou passar 9 edições | Sem dono por arquivo; o escopo é o pedido | P |
| **18 · mutação por regra** | 19 mutações adivinhadas viraram inconclusivas e GAP (garden S5) | **Não faz.** Escreve teste, mas não prova que o teste pega a regra. O N-forte tirou 15/15 sem isso: o valor é plausível e **não medido** | T* |
| 21 · render real para layout novo | Layout provado por seletor passou em tudo e quebrou no aparelho | Usou o emulador sozinho (14 % do custo do N-forte). "Prove layout no aparelho" reforça | I |
| 22 · plano até 30 KB, senão divide | P-r6 com média de 42 KB; cortes de ~US$ 9; planos de 60 e 46 KB levaram a 6 cortes da G23 e 3 GAPs | Não há plano para cortar | P |
| 23 · cenários citados existem | consistência com o QA | Sem QA separado | P |
| 24 · risco define o nível de teste | decisão do stakeholder (21/10) | "Regra de negócio tem teste de unidade; integração, teste de integração" no `CLAUDE.md` | I |
| 25 + ficha + 28 · um Arquiteto por Task, ficha, "Li além da ficha" | Plano de 8 Tasks = US$ 16,3 (63 % dos subagentes); abertura do Arquiteto ~117 mil tokens | Não existe o papel | P |
| 26 · premissas e contagens medidas | 27 de 29 GAPs nasceram no plano ou na spec; 9 premissas de layout lidas em `node_modules` | Não há premissa: quem constrói executa e vê | P |
| 27 · documentos vivos | o dev não edita o SDD | Atualiza o README junto | P |
| 29 · decisões do sprint num lugar só | A mesma decisão copiada em 8 planos, acréscimos de até 57 % | Uma instância só não copia para si mesma | P |
| 30 · margem do dev | 3 de 4 idas ao Arquiteto eram defeito do teste ou CSS; 29 casos de stub na T-063 | Quem constrói ajusta o próprio teste | P |
| 31 · testes herdados | T-072b: teste de outra Task apareceu só no fechamento | Roda a suíte inteira antes de parar (o prompt pede) | N |
| 32 · comandos da Task declarados | ~25 formulários da G14 no garden S5 | Allowlist nativa (ver G14) | P |
| R11 · seção de segurança | genérico | "Tarefa sensível: segredos fora do código, validação de entrada" no `CLAUDE.md` | I |
| R16 · standards com um editor | genérico | `CLAUDE.md` + linter no build | I |
| `ids.ps1 -Map/-Audit` | padrão de ids de teste | Só audita (exit 0); uma linha de instrução tem o mesmo efeito | I |

## 4. Desenvolvedor

| Regra | O que corrige (incidente) | Como um modelo sem o plugin trataria | Classe |
|---|---|---|---|
| **R7 + `close` R7 + `verify` full/check na mesma árvore** | Relatar pronto sem saída real; evidência de outra árvore | **Escorrega:** às vezes declara pronto sem rodar tudo. O N-forte acertou com "confira cada critério", mas o garden é maior *(julg.)*. Um script que roda a suíte e grava a árvore é barato | **T** |
| **G5 · gate protegido** | Agente afrouxar lint/teste para passar | Escorrega (afrouxa config de lint ou teste) *(julg.)* | **T** |
| **G6 · skip de teste** | Teste ignorado para passar | Escorrega *(julg.)* | **T** |
| **`verify` node:test com 0 testes = inconclusivo** | `tests 0` lido como verde | Lê "0 falhas" como sucesso *(julg.)* | **T** |
| `verify` mutação e `-Precheck` | prova de falha do teste | ver regra 18 | T* |
| `verify` testids | "Nunca mais termos problema de QA" (stakeholder) | Não põe id de teste se não for pedido; a conferência no build é barata | T |
| R4 · não antecipar escopo | escopo crescer | "Só o pedido" no `CLAUDE.md` | I |
| R8, R9 · sem plano sem código; GAP escala | contrato Arquiteto→dev | Não há para quem escalar: decide e registra no README | P |
| R10 · nomes da spec | genérico | Faz | N |
| R12 · documentos vivos no mesmo ciclo | genérico | O prompt pede README; "atualize a doc junto" reforça | I |
| R7-margem, `delivery-report` (13,9 KB), cartão, "Parei no passo" | handoff entre instâncias do dev | Uma instância só, sem relatório para o próximo | P |
| G23 · teto de 100 mil para o dev | 6 devs de 61 a 159 chamadas = 34 % do US$ | O Haiku em sessão longa nasce do plano grande e do vaivém; um modelo forte numa sessão compacta sozinho *(julg.)* | P |
| `verify` exit 3/4/5, `focused` por caminho | verify passando de 600 s; dois full ao mesmo tempo | O exit 5 nasce de agentes paralelos; o resto é configuração | P |
| `run.ps1 start` (escalonamento a Sonnet, agente vivo, plano > 30 KB) | dev duplicado; rede subindo o modelo | Sem fila de agentes | P |

## 5. QA, Operator e alvo (emulador)

| Regra | O que corrige (incidente) | Como um modelo sem o plugin trataria | Classe |
|---|---|---|---|
| **`accept` sem assert = exit 2** | "18 de 18" numa WebView opaca | Escreve roteiro de UI que navega sem conferir *(julg.)* | **T** |
| **`accept` com APK mais velho que o fonte** | "tag não encontrada": APK do disco sem a mudança | Costuma rodar `installDebug`, mas pode testar build velho *(julg.)* | **T** |
| **`accept` com estado de partida (exit 4)** | T-063: 7 cenários falharam na introdução, ~50 min | Leva tempo para ver que o app abriu na tela errada *(julg.)* | **T** |
| **`seed`/`baseline`** | cenário que depende de massa de dados | Prepara dados à mão, sem repetição garantida *(julg.)* | **T** |
| **`target.ps1`: pré-voo, serial, `adb` com prazo, reparo, memória, um emulador só** | Reparo parado 81 min em `adb emu kill`; dois emuladores; qemu com 13,5 GB | **Sofre o mesmo ambiente.** Isso não depende do plugin: emulador em container trava para todos | **T** |
| R30 · cenários mapeados na Planning | QA chegava tarde | "Confira cada critério do pedido" já cobre | N |
| R23 · verificação plena na 1ª entrega | genérico | "Rode tudo antes de dizer pronto" | I |
| Portão do QA no fim do sprint | revisão independente | Não existe. **Não medido:** na revisão cega, o P-r6, com portão de QA, teve mais defeitos e documentação pior que o N-forte | P |
| G7, G11, R28 (delegação ao operator) | ~303 mi tokens com 20 subagentes | Roda o comando ele mesmo, em segundo plano, e espera o aviso | P |
| `run.ps1 done` com GAP de alvo ao operator | 3 GAPs de alvo ao Opus com diagnóstico errado (T-041) | Diagnostica no próprio contexto | P |

## 6. Executor de Task (`task-runner`)

| Regra | O que corrige | Como um modelo sem o plugin trataria | Classe |
|---|---|---|---|
| Executor por Task, "nada além do cartão", `.active-agents`, sinal de vida, retomada pelo disco | Sessão do sprint 3 com ~800 mil de contexto; agentes assíncronos | Não há sessão orquestradora para proteger | P |

---

## 7. O que a classificação mostra

**Contagem por linha das tabelas** (linhas agrupadas contam uma vez):

| Classe | Linhas | Parcela |
|---|---|---|
| P · problema do plugin | 44 | 58 % |
| I · instrução | 14 | 18 % |
| T · trava que vale (contando as duas T*, que são a mesma mutação vista do plano e do `verify`) | 12 | 16 % |
| N · nativo | 6 | 8 % |
| **Total** | **76** | |

**De onde vêm os problemas do plugin.** Quase todas as linhas P saem de três escolhas de estrutura:

1. **Separar quem planeja (Opus) de quem constrói (Haiku).** Gera as regras de plano 2, 7, 12–17, 19, 20, 22, 23, 25–30 e 32, a G9, a G23, a margem do dev, o GAP, o `decisions/S<n>.md`, a ficha e o relatório de entrega. É também onde está o custo: Arquiteto = 63 % a 84 % dos subagentes, e 27 de 29 GAPs nasceram no plano. O N-forte não tem essa costura, por isso não perde informação nela.
2. **Run autônomo com vários agentes assíncronos.** Gera G7, G14, G19, G20, G21, G22, R1, R27, R29, o executor de Task, o `.active-agents` e o sinal de vida. Os maiores laços registrados (G20 com 195 bloqueios, G14 com até 30 falsos negados por sprint) são desta camada.
3. **Cerimônia Scrum simulada.** Gera R13–R15, R20, R21, R24, R25, R33, R34, o PO e a UX. Num pedido fechado não paga nada (fix do N-forte: US$ 2). Para pedido aberto (Etapa 7) **não foi medido**.

**O núcleo que vale sem a estrutura.** As 12 linhas T são scripts e hooks que funcionariam com **um modelo só, construindo numa sessão**:

- `verify` full na árvore atual, com 0 testes = inconclusivo e conferência de ids de teste;
- `close` exigindo a saída real (R7);
- G5 (gate protegido) e G6 (skip de teste);
- `accept`: assert obrigatório, APK atualizado, estado de partida, seed/baseline;
- `target.ps1`: pré-voo, reparo e prazo do `adb`;
- *com custo a medir:* mutação por regra.

Nada disso depende de Arquiteto, Haiku, run, quadro nem cerimônia.

**Recomendação para o teste** (adicionada ao `teste-eficiencia-p-r2.md` como §8.1, braço NT, em 06/11). O P-enxuto descrito no §8.2 daquele arquivo ainda mantém o dev separado. O braço que melhor responde à pergunta "o que do plugin vale" é outro, o **N-forte + travas**:

- a mesma frase do N-forte;
- um `CLAUDE.md` com as 14 linhas da classe I;
- só as travas da classe T instaladas: `verify`, `accept`, `target`, o `close` reduzido a "saída real exigida", G5 e G6.

Comparado com o N-forte-r1 no mesmo oráculo, ele mede se as travas melhoram a qualidade (lote, fluxos, revisão cega) e a que custo.

---

## 8. Os 44 itens P se o plano e a execução fossem só Opus

Pergunta do stakeholder (06/11): esses problemas deixariam de existir se o Opus fizesse tudo, do plano à construção e aos testes? "Só Opus" tem duas leituras, e a resposta muda entre elas:

- **V1 · mesma estrutura, todos os papéis em Opus.** Arquiteto, dev, operator, QA e executor continuam instâncias separadas, mas o dev e o operator deixam de ser Haiku.
- **V2 · um Opus só.** A mesma instância planeja, constrói e testa, na mesma sessão. É o N-forte, com as travas T se elas ficarem.

**Causas de cada item:**

| Código | Causa | Muda com o modelo? |
|---|---|---|
| **H** | **troca entre instâncias:** quem planeja não é quem constrói; o plano é um contrato escrito; o dev não pode desviar dele | não; só some se a mesma instância planejar e construir |
| **M** | **modelo fraco no dev:** o Haiku perde o fio em tarefa grande; preço 5× acima de 100 mil | sim; some com Opus no dev |
| **A** | **run autônomo com vários agentes:** fila, espera, agente assíncrono, fim de turno, permissão | não; some só sem vários agentes |
| **C** | **cerimônia Scrum simulada** | não; é escolha de processo |
| **I** | **infraestrutura do plugin ou do benchmark** | não |

### Item por item

| # | Item | Causa | V1 · todos Opus | V2 · um Opus só | Por quê |
|---|---|---|---|---|---|
| 1 | R1 · uma Task por vez | A | fica | some | o risco é ter vários devs, não a força do dev |
| 2 | R2 · plano de até ~10 passos | M+H | diminui | some | o Opus aguenta mais arquivos, mas segue recebendo um plano de outra instância |
| 3 | R13 · APF/PMBOK | C | fica | fica | método |
| 4 | R14 · onboarding | C | fica | fica | método |
| 5 | R15 · brainstorm e portões | C | fica | fica | método; o valor em pedido aberto não foi medido |
| 6 | R17/R18/R19 · manutenção do plugin | I | fica | fica | é do repositório do plugin |
| 7 | R20/R21/R25 · História, Review, sprint | C | fica | fica | método |
| 8 | R24 · registro e burndown | C | fica | fica | existe enquanto houver quadro |
| 9 | R27 · falha de invocação | A | diminui | some | o escalonamento do dev a Sonnet some; a queda do agente no run continua |
| 10 | R29 + G21 · sessão nova por ritual | A+C | fica | diminui | um Opus só fazendo um sprint inteiro numa sessão também cresce o contexto; vira "`/clear` entre Tasks, com notas" (classe I) |
| 11 | R31 + G1 · `.team-project` fora do git | C | fica | fica | existe enquanto houver pasta de processo |
| 12 | R32 · consultoria | C | fica | fica | método |
| 13 | R33 · trilha fix | C | fica | fica | método; o N-forte resolveu o fix com uma frase |
| 14 | R34 · celular | C | fica | fica | canal |
| 15 | G2 · cópia instalada | I | fica | fica | plugin |
| 16 | G13/G15/G16 · aviso, permissão, consumo | I | fica | fica | medição |
| 17 | G17/G18 · modelo por papel, dossiê | I | diminui | diminui | a G17 perde o sentido com um modelo só; a G18 é do benchmark |
| 18 | G19 · retomar papel caro parado | A | **piora** | some | com todos em Opus, toda retomada com cache vencido sai cara (hoje só a do Arquiteto: US$ 22 no piloto) |
| 19 | G20 · fim de turno barrado | A | fica | some | o laço nasce do run com agente assíncrono, não do modelo |
| 20 | `mark.ps1`, `run.ps1 next` | A+C | diminui | diminui | o escalonamento some em V1; em V2 a fila some, e o quadro só fica se a cerimônia ficar |
| 21 | PO | C | fica | fica | método |
| 22 | UX | C | fica | fica | método |
| 23 | Plano 2 · blocos acima de 8 arquivos | M+H | diminui | some | igual ao item 2 |
| 24 | Plano 7 + 17 · contrato, trecho literal ≤ 15 linhas | H | fica | some | **quem escreveu o texto com defeito já era o Opus;** o defeito existe porque o autor não compila |
| 25 | Plano 12 · plano novo na retomada | H | fica | some | premissa velha de outra instância |
| 26 | Plano 13/14/19/20 · Conferência, operator, `plan.ps1`, "Planejado durante" | H+A | fica | some | conferem a passagem entre papéis |
| 27 | Plano 15/16 + G9 · Arquivos tocados, dono | H | fica | some | o limite de escopo do dev continua; um dev Opus tende a fazer mais que o pedido, não menos *(julg.)* |
| 28 | Plano 22 · teto de 30 KB | H | fica | some | **os planos de 42 KB em média (P-r6) e os de 60 e 46 KB eram do Opus** |
| 29 | Plano 23 · cenários citados existem | H | fica | some | QA e Arquiteto separados |
| 30 | Plano 25 + ficha + 28 · um Arquiteto por Task | H | fica | some | o motivo é o custo do Opus planejando; com todos em Opus, pesa mais |
| 31 | Plano 26 · premissas medidas | H | fica | some | **as 9 premissas de layout lidas em `node_modules` eram do Opus;** quem lê sem executar erra em qualquer modelo |
| 32 | Plano 27 · documentos vivos | H+C | fica | some | o dev não edita o SDD |
| 33 | Plano 29 · decisões do sprint | H | fica | some | várias instâncias de plano copiando a mesma decisão |
| 34 | Plano 30 · margem do dev | H (+M) | diminui | some | a margem existe porque o processo proíbe o dev de mexer; com dev Opus a regra poderia afrouxar |
| 35 | Plano 32 · comandos da Task | A | fica | some | vira allowlist (classe I) |
| 36 | R8/R9 · sem plano sem código, GAP | H | fica | some | contrato entre papéis |
| 37 | R7-margem, relatório de entrega, cartão | H | fica | some | passagem entre instâncias do dev |
| 38 | G23 · teto de contexto do dev | M+H | diminui | some | a faixa 5× é do Haiku; a sessão longa vem do plano grande e do vaivém; com um Opus só, a compactação é nativa |
| 39 | `verify` exit 3/4/5 | A | fica | diminui | o exit 5 (outra rodada viva) some sem paralelismo; os prazos continuam |
| 40 | `run.ps1 start` · escalonamento, agente vivo, plano grande | A+M+H | diminui | some | o escalonamento some em V1; o resto é da fila |
| 41 | Portão do QA no fim | C | fica | some (opcional) | revisão independente; o valor não foi medido (o P-r6, que tinha o portão, teve mais defeitos na revisão cega que o N-forte) |
| 42 | G7/G11/R28 · delegação ao operator | A | diminui | some | o operator existe para executar barato e proteger o contexto; um operator Opus perde a primeira razão |
| 43 | GAP de alvo ao operator | H | fica | some | **o diagnóstico errado da T-041 foi do Opus,** que não via o aparelho |
| 44 | Executor de Task | A | fica | some | protege o contexto da sessão orquestradora |

### Resultado

| Leitura | Some | Diminui | Fica (ou piora) |
|---|---|---|---|
| **V1 · mesma estrutura, todos Opus** | 0 | 9 | 35 |
| **V2 · um Opus só** | 26 | 4 | 14 |

**Por causa:** só **5 itens têm o modelo fraco (M) entre as causas** (2, 23, 34, 38 e 40), e todos eles também têm H. Nenhum item P depende só do Haiku. As causas reais são a **troca entre instâncias (H), em 18 itens**, e o **run com vários agentes (A), em 12**. Dois itens têm as duas causas, então H ou A aparecem em 28 itens. Os outros 16 são só cerimônia (C) ou infraestrutura (I). Muitos dos defeitos que motivaram as regras do plano foram produzidos pelo próprio Opus:
- planos de 42 KB em média;
- 27 de 29 GAPs nascidos no plano ou na spec;
- premissas de layout lidas no código;
- diagnóstico errado de alvo.

**V1 não resolve e custa mais.**
- Trocar o dev e o operator por Opus mantém 35 dos 44 itens e piora a G19.
- Pela tabela de preço do `validacoes-sprint-6.md`, o Opus custa 40× o Haiku por token até 100 mil e 8× acima. No sprint 4, todos os devs Haiku somaram ≈ US$ 3,3, então o dev em Opus iria para a faixa de US$ 25 a 130 por sprint. Ele faria menos chamadas e menos GAPs, então o valor real fica abaixo do teto, mas esse ganho não foi medido.
- Já existe um dado parecido: o **CO-r1** (planejador separado + construtor Opus numa sessão persistente) teve a mesma qualidade do N-forte com **3× o custo** (1,85× sem a contaminação). Separar quem planeja de quem constrói custou caro mesmo com Opus construindo.

**V2 resolve quase tudo, e o que sobra não depende do modelo.**
- Os 14 itens que ficam são cerimônia (C) e infraestrutura (I): onboarding, brainstorm, Histórias, Review, PO, UX, trilha fix, quadro, consultoria, celular e manutenção do plugin.
- Eles ficam por escolha de processo. Só vale manter os que se pagarem em pedido aberto ou em vários sprints, o que ainda não foi medido (Etapa 7 e garden).
- V2 com as travas T é exatamente o **braço NT** do `teste-eficiencia-p-r2.md` §8.1. O NT responde se V2 vale, e o P-r2 mede V1 com dev Haiku. Um braço "V1 todo em Opus" não parece valer o custo: a tabela mostra que ele mantém quase todos os problemas.

---

## 9. Critério para decidir o que fica: perda de contexto real × fronteira criada

Pergunta do stakeholder (06/11): a troca entre instâncias (H) não é o problema normal de toda IA, que perde a memória a cada chamada? E o plugin não estaria corrigindo esse problema com processo?

### 9.1 Onde a memória se perde de verdade

Cada chamada não é um agente novo. Dentro de uma sessão, o Claude Code reenvia a conversa inteira a cada chamada, quase toda pelo cache. O modelo guarda o que leu, rodou e decidiu até um destes três momentos:

| Momento | Existe sem o plugin? | Como um modelo sem o plugin trata |
|---|---|---|
| A sessão termina (outro dia, outro sprint) | **sim** | lê o repositório: código, testes que rodam, `git log`, README, `CLAUDE.md` |
| O contexto enche e é compactado | **sim** | compactação nativa, ou `/clear` entre Tasks com notas |
| O trabalho é passado de propósito a outro agente | **não**: é escolha de estrutura | — |

Os dois primeiros são o **problema normal**. Num projeto de vários sprints, como o garden, o processo do plugin pode valer aí: SDD, decisões, ADR, retomada. Isso ainda **não foi medido** contra um braço sem plugin. O terceiro é a **fronteira criada**: o N-forte fez o app inteiro numa sessão de 72 min, enquanto o plugin divide a mesma Task entre Arquiteto, dev (às vezes várias instâncias), operator, QA, executor e sessão.

### 9.2 Plano antes de codificar existe nos dois casos

O fluxo sem plugin também tem plano antes do código: o prompt do N-forte começa com "primeiro escreva um plano curto". O problema não é ter plano. É **o papel que o plano cumpre**:

| | Plano de quem vai executar (sem plugin) | Plano como contrato para outro agente (plugin) |
|---|---|---|
| Quem escreve e quem executa | a mesma instância, no mesmo contexto | o Arquiteto escreve; o dev, outra instância, executa |
| Para que serve | organizar o próprio trabalho: um rascunho | **substituir o contexto** de quem recebe |
| Tamanho | curto: o raciocínio por trás dele continua na memória | longo (média de 42 KB no P-r6, teto de 30 KB): tudo precisa estar escrito |
| Nível de detalhe | o quê e em que ordem; o como se decide ao codificar | desce ao trecho literal, à contagem e à mutação, porque quem recebe não pode decidir |
| Quando a realidade contradiz | corrige na hora, sem custo | o desvio é proibido (R8/R9) e vira GAP para outra instância (garden S5: 9 GAPs ao Arquiteto ≈ US$ 7, sem contar o retrabalho do plano) |
| Quem confere | o próprio executor, rodando | `plan.ps1` com 16 reprovações, antes de existir código para medir |

Com um modelo só, a premissa errada aparece na primeira compilação e é corrigida no mesmo turno. Com o plano como contrato, a mesma premissa atravessa o `plan.ps1`, chega ao dev, vira GAP, volta ao Arquiteto e gera uma regra nova para o próximo plano. As regras de plano 7, 17, 18, 22, 26, 29 e 30 tentam cada uma tapar uma variante dessa volta.

Equipes humanas também fazem plano antes de codificar, mas no nível de desenho: o quê, por quê e onde. O como fica com quem implementa. O plugin desceu ao como porque quem recebia era o Haiku e porque os GAPs custavam caro, e isso deixou o plano mais frágil. A própria regra 7 ("contrato, não código") já tentava desfazer esse efeito.

### 9.3 O que se passa adiante: estado ou intenção

| | Passagem normal (entre sessões) | Passagem do plugin (dentro da Task) |
|---|---|---|
| Quando | **depois** do trabalho feito | **antes** do trabalho existir |
| O que passa | **estado:** código que compila, testes que rodam | **intenção:** plano que descreve código ainda não escrito |
| Como o próximo confere | roda os testes e lê o código | não confere: o plano é contrato |
| Onde erra | pouco: a verdade está no repositório | premissa não medida, trecho literal com defeito, mutação adivinhada (27 de 29 GAPs nasceram no plano) |

Algumas peças do plugin já são **passagem de estado** e devem ficar em qualquer formato:
- "Parei no passo" e a retomada pelo disco (R5);
- o cartão da G23 com os passos que faltam;
- as decisões num lugar só (R6/R29);
- o `ids-map.md` gerado do código;
- commit por Task;
- as travas T, que conferem o estado e não a intenção.

### 9.4 O critério

1. **Quebrar o contexto só quando for inevitável:** o contexto encheu, a Task terminou ou a sessão acabou. Uma quebra dentro da Task só entra com ganho medido (paralelismo real, parte mecânica barata) contra o custo da passagem. Nos dados até agora, a economia do dev em Haiku (≈ US$ 3,3 por sprint) é pequena perto do plano em Opus (63 % a 84 % dos subagentes).
2. **Plano é do executor.** Plano curto, escrito por quem vai codificar, no nível do quê e da ordem. Se outra instância precisar dele, ele passa como desenho (o quê, por quê, onde), nunca como código previsto.
3. **Ao quebrar, passar estado verificável:** código commitado, testes que rodam, notas curtas de onde parou e decisões num lugar só. Nunca um documento que o próximo precise aceitar sem poder conferir.
4. **Regra nova passa por este filtro.** Antes de criar uma regra para tapar um problema, perguntar se ele nasce de uma fronteira criada. Se nasce, a correção é tirar a fronteira, não acrescentar regra.

---

## 10. De onde vêm os GAPs: os 117 do garden, sprints 1 a 5

Pedido do stakeholder (06/11). Premissa dele: com um plano bom, o Haiku erra menos e pode ser multiplicado. Então o caminho é melhorar o plano a cada GAP, para o próximo não repetir o erro, que é o que o plugin vem fazendo. **A pergunta:** que parte dos GAPs esse aprendizado consegue evitar?

**Método.**
- **Fontes:** as seções "Decisões de GAP" dos planos, os "Gaps levantados" e "🔺 GAP" das entregas, o `run-log.md`, o `consumption.md`, as retrospectivas e o `architect/decisions/S5.md` de `garden-management/.team-project/sprints/1..5`.
- **Contagem:** cada GAP conta uma vez, mesmo quando aparece no plano e na entrega. Os registros "não é GAP" e as premissas não exercitadas ficaram fora.
- **Classificação:** feita por dois levantamentos em paralelo (sprints 1–3 e 4–5), com o mesmo critério. Os itens duvidosos estão marcados "(incerto)" nos levantamentos.
- **Amostragem conferida:** o limiar de 160 px reprovou na T-052 do S4 (`delivery/T-052.md:110`, deu 137) e de novo na T-063 do S5 (`delivery/T-063.md:207`, deu 152), resolvido pela D-1. O `verify.compile`, que faltava no S2, hoje está no `guards.json` do garden.

**Tipos:**

| Tipo | Quer dizer |
|---|---|
| **Previsão** | o plano afirmou algo que só se sabe executando: render, CSS ou Ionic, comportamento de framework ou de harness, contagem, mutação que não falha, teste existente que trava |
| **Conhecimento** | um fato do projeto que já existia (decisão anterior, padrão no código, standard, comentário) e não foi consultado |
| **Requisito** | ambiguidade da História ou decisão de produto |
| **Ambiente** | emulador, build, ferramenta |
| **Processo** | uma regra ou guarda do plugin travou um trabalho que estava certo |

### 10.1 Contagem

| Tipo | S1 | S2 | S3 | S4 | S5 | Total | % |
|---|---|---|---|---|---|---|---|
| Previsão | 5 | 12 | 16 | 5 | 11 | **49** | 42 % |
| Processo | 1 | 3 | 2 | 5 | 15 | **26** | 22 % |
| Conhecimento | 1 | 4 | 8 | 7 | 2 | **22** | 19 % |
| Ambiente | 0 | 1 | 2 | 2 | 10 | **15** | 13 % |
| Requisito | 0 | 1 | 1 | 2 | 1 | **5** | 4 % |
| **Total** | 7 | 21 | 29 | 21 | 39 | **117** | |

O Arquiteto (Opus) decidiu cerca de 96 dos 117. O PO decidiu 7, e o stakeholder ou a sessão, o resto.

### 10.2 O que um plano melhor ou um registro poderia evitar

| Grupo | GAPs | % | O que resolve |
|---|---|---|---|
| **Evitável por registro do projeto:** os 22 de conhecimento e as 10 previsões cujo fato já tinha sido visto antes, como o aria do Ionic, o `flex 1 1 0` comentado no `global.scss`, o "CDP só lê" e o molde `ionPopoverDidPresent` | 32 | 27 % | memória do projeto consultada pelo plano: decisões, standards, ficha com `caminho:linha` |
| **Evitável por conferência mecânica:** mutante que não compila, âncora repetida, contagem conferível por grep, conferência contra a spec | 9 | 8 % | `-Precheck` e `verify.compile` (já existem) |
| **Só executando:** comportamento novo de CSS, Ionic, Karma, harness ou framework | 30 | 26 % | **nenhuma regra de plano;** só quem executa descobre |
| **Criado pelo próprio plugin (processo):** `accept` sem `.scn` ou sem assert, cartão ou pedido da sessão contradizendo o plano, G14 negando comando, G9 negando arquivo de build, R7-margem | 26 | 22 % | corrigir o plugin, não o plano |
| **Ambiente:** emulador, APK, base, instâncias concorrentes (3 delas causadas pela orquestração) | 15 | 13 % | travas do alvo (classe T) |
| **Requisito** | 5 | 4 % | PO; as Histórias quase não geram GAP |

As 49 previsões se dividem em 10 evitáveis por registro, 9 por conferência mecânica e 30 só executando. A soma dos grupos dá os 117.

**Resposta à premissa.** Um plano perfeito, que aprendesse com todos os GAPs anteriores, evitaria **no máximo 35 %** (registro + conferência mecânica). E mesmo isso não vem de regra nova no modelo do plano: vem da memória do projeto e de uma conferência que já existe. Os outros 65 % não dependem da qualidade do plano:
- 26 % só aparecem executando;
- 22 % são criados pelo próprio plugin;
- 13 % são ambiente;
- 4 % são requisito.

### 10.3 O que a série mostra

- **O aprendizado por registro funciona quando existe registro.** O conhecimento caiu de 7 GAPs no S4 para 2 no S5. Foi o primeiro sprint planejado com a ficha por Task (v3.53.0), que aponta o código por `caminho:linha`. A queda é sugestiva, mas é um sprint só. Antes da ficha e do `decisions/S<n>.md`, a mesma lição se repetiu:
  - limiar de 160 px na T-052 (S4) e na T-063 (S5);
  - alvo de 41,6 px e contraste da T-027 repetidos na T-028;
  - política da T-032 contrariada na T-034.
- **A previsão não cai.** Foram 5, 12, 16, 5 e 11 por sprint. As regras 21 e 26 (render medido, premissas medidas) não impediram 6 GAPs de CSS do Ionic no S5. Os dois levantamentos chegaram à mesma raiz principal: **render, CSS ou Ionic previsto por leitura**, com 16 GAPs, e **comportamento de framework ou harness**, com 9.
- **O processo sobe:** 1, 3, 2, 5 e 15 por sprint. No S5, a maior fonte única de GAP foi o próprio plugin: `accept` sem entrada válida e pedido da sessão contradizendo o plano (13 GAPs), além de G14 e G9 (5). Cada regra nova para evitar GAP abre uma classe nova de GAP.
- **O ambiente sobe com a prova no aparelho:** 10 GAPs no S5, quando o `accept` passou a rodar no emulador.
- **O retrabalho não converge:** 81,6 % do consumo das Tasks no S2 estava em Tasks com GAP ou reabertura. Desde então, o retrabalho ficou em 35 % no S3, 35 % no S4 (US$ 32,43 só nas linhas com valor) e 38 % no S5 (81,2 mi tokens, 43,1 mi deles do Arquiteto). O maior retrabalho do S5 (T-071, 39 mi) nem foi GAP: foram 3 reinícios pela G23 e o contrato de ids ampliado 3 vezes.
- **GAP por Task:** cerca de 2,3 no S2, 2,1 no S3, 2,3 no S4 e 3,5 no S5, contando as entregas de cada sprint (9, 14, 9 e 11). É aproximado, mas não há queda.

### 10.4 O que isso muda no critério do §9

1. **Lição de GAP de conhecimento vai para a memória do projeto, não para o modelo do plano.** Os registros que já existem cobrem isso: `decisions/S<n>.md`, ficha com `caminho:linha`, standards do projeto e `ids-map.md`. O que falta é **manter o registro entre sprints**: uma decisão que vale além do sprint sobe para os standards do projeto. Hoje o `decisions/S<n>.md` é por sprint, e o limiar de 160 px repetiu justamente na troca de sprint.
2. **GAP de previsão do tipo "só executando" não vira regra.** Ele vai para quem executa: o dev com liberdade dentro do contrato, ou o Arquiteto com uma sonda curta antes de planejar. Mais regras de premissa não reduziram esse tipo em cinco sprints.
3. **GAP de processo é defeito do plugin.** Os 13 do `accept` e do cartão e os 5 da G14 e da G9 são correções de script, e todas são bloqueantes para um braço do benchmark. Pela regra do `teste-eficiencia-p-r2.md`, só esse tipo de correção entra antes do P-r2.
4. **A premissa "plano bom → Haiku multiplicado" esbarra nos 65 %** que nenhum plano evita, e no gargalo de verificação e alvo descrito no §9. Ela continua testável no P-enxuto (§8.2 do roteiro), mas com o teto de ganho conhecido: no máximo um terço dos GAPs. Se o custo ficar perto do N-forte com qualidade igual ou maior, esse é o produto. O resto do plugin volta só com medição que mostre ganho, começando pela cerimônia em pedido aberto (Etapa 7).
