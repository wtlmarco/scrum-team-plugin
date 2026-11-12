# Como usar o time

Guia do **stakeholder**. Vive no plugin — uma cópia serve todos os projetos e chega atualizada por `claude plugin update team@team`; o `/team update` a copia para `.team-project/how-to.md`. O `.team-project/README.md` de cada projeto carrega só a versão operacional compacta, porque é lido pelos agentes em toda invocação e precisa ser barato.

## Em um minuto

O time trabalha numa cadência fixa, toda conduzida pelo `/sm`:

```
/sm brainstorm ─► /sm sdd ─► /sm sprint prepare ─► /sm sprint plan ─► /sm sprint run ─► /sm sprint review ─► /sm sprint close
   (ideia)        ① ②        (sem te acionar)         ③                (sem te acionar)        ④
```

**Correção pequena não espera sprint.** Defeito e ajuste pequeno sobre o que já existe têm uma trilha própria, mais barata, no mesmo molde (cenário D):

```
/sm fix plan ─► /sm fix run
 (triagem, ajustes)   (sem te acionar)
```

- **Você decide em quatro momentos — os portões ① ② ③ ④ —, sempre por formulário:** aprovar · aprovar com ajuste · reprovar · pedir mais contexto (no ④: aceita · aceita com ressalva · rejeitada · pedir mais contexto).
- **Toda pergunta do time chega como formulário**, não só as dos portões: opções curtas, a recomendada primeiro e "Pedir mais contexto" por último. Para responder do seu jeito, escreva no campo **"Outro"**. Pediu mais contexto? A explicação vem junto com o mesmo formulário.
- **Fora dos portões, o time não te chama**, salvo bloqueio que PO e Arquiteto não fecharam entre si, ou decisão estratégica (stack, provedor, custo, risco aceito).
- **A qualquer momento:** `/po status` diz onde o time está e quando entrega. O PO é o **seu canal** — demanda, prioridade, prazo e status passam por ele.

## O que você quer fazer → qual comando

| Quero… | Comando |
|---|---|
| Instalar o time num projeto | instalação (abaixo) e depois `/team init` |
| Começar de uma ideia sem documentação | `/sm brainstorm <ideia>` → cenário A |
| Assumir um projeto que já existe | `/sm onboarding` → cenário B |
| Evoluir uma área que já está documentada | `/po analyze <ideia>` → `/sm sdd` → cenário C |
| Transformar o brief ou a decisão em SDD e Histórias | `/sm sdd` |
| Abrir um sprint | `/sm sprint prepare` e depois `/sm sprint plan` |
| Mandar o time construir | `/sm sprint run` (a fila) ou `/sm sprint run <T-ID>` (uma Task) |
| Saber onde estamos, prazo, andamento | `/po status` |
| Acompanhar o sprint **sem gastar token** (console ou celular) — [como ler](#acompanhar-o-sprint-sem-gastar-token) | `/team-status` (quadro, quem trabalha agora, o que espera você) · `/team-usage` (tokens e US$ por Task e por papel) |
| Ver o quadro do sprint | `/sm board` |
| Saber o custo de uma mudança antes de pedir | `/po impact <mudança>` |
| Saber se o time compensa (custo × qualidade) | `/usage` no fim de cada sessão, colado ao time · retrospectiva "Custo × resultado" · experimento em `rituals/benchmark.md` → cenário H |
| Relatar e corrigir problemas | anote em `.team-project/note.md` → `/sm fix plan` → `/sm fix run` → cenário D |
| Só relatar, sem corrigir agora | anote em `.team-project/note.md` e rode `/po note`, ou `/po bug <relato>` → cenário D |
| Ver a fila de correções | `/sm fix` |
| Tirar uma dúvida técnica | `/arc question <dúvida>` |
| Resolver uma questão que envolve vários papéis | `/sm agreement <questão>` |
| Ouvir um consultor externo antes de decidir (técnico ou de negócio) | `/sm consulting <domínio> <tema>` — **fora do `sprint run`** → cenário G |
| Aceitar o que o sprint entregou | `/sm sprint review` |
| Encerrar o sprint | `/sm sprint close` |
| Atualizar o plugin / ver a versão | `/team update` · `/team version` |
| Responder e retomar pelo celular | `/team remote` (uma vez por projeto) → seção "Responder pelo celular" |
| Mudar como o time trabalha (regra, cerimônia, modelo) | `/review` — **só no repositório-fonte do plugin** |

## Os cenários

### A · Projeto novo, a partir de uma ideia

```
/team init                  cria .team-project/ e o contexto
/sm onboarding              o time lê o que existe e lista o que falta decidir — você responde em formulário
/sm brainstorm <ideia>      fase 1: você + PO + UX moldam a ideia (funcional)
                            fase 2: entra o Arquiteto (viabilidade), em rodadas, até não haver objeção bloqueante
/sm sdd                     o time escreve o SDD e as Histórias:
                              PO escreve o SDD funcional · UX faz jornadas e o protótipo em HTML
                              ① você NAVEGA o protótipo e decide
                              Arquiteto escreve o SDD técnico da primeira fatia
                              ② você decide o SDD técnico
                              PO cria as Histórias no Product Backlog
/sm sprint prepare          o time detalha as candidatas (regras, critérios, telas, cenários de teste) — sem te acionar
/sm sprint plan             Planning: quebra em Tasks, estima, corta pela capacidade, costura o protótipo do sprint
                              ③ você navega o protótipo do sprint e decide o PACOTE
/sm sprint run              o time constrói a fila inteira — um executor de Task por Task, sem te acionar; para na Review
/sm sprint review           ④ você decide, uma pergunta por História
/sm sprint close            retrospectiva; o sprint seguinte começa no prepare
```

O `brainstorm` existe porque ideia sem documentação não deve virar requisito pela mão de um papel só: a inviabilidade técnica só apareceria na construção.

### B · Projeto que já existe (retomada)

Há código, e a documentação pode não corresponder a ele.

```
/team init                  cria .team-project/
/sm onboarding              inventário das fontes; o que a documentação não cobre vira pergunta a você
/qa audit                   cruza os documentos com o código real
/qa baseline                reproduz os números declarados (build, testes, cobertura) — a régua de regressão
```

Depois, conforme o que o onboarding encontrou:

- **Há SDD aproveitável** → ele vale como aprovado; o PO escreve as Histórias do que a auditoria achou (`/po story <ID>`) e segue para `/sm sprint prepare`.
- **Não há SDD, ou ele não corresponde ao código** → `/sm sdd`, como no cenário A.

**Comece pela auditoria, não pelo plano.** O status de um projeto retomado costuma declarar mais pronto do que o código sustenta; o levantamento sobre o código vence a narrativa, e a divergência vira risco no quadro.

### C · Evoluir o produto

| A ideia é… | Caminho |
|---|---|
| Em **área já documentada** | `/po analyze <ideia>` → o PO decide e declara o que muda → `/sm sdd` atualiza só as seções afetadas, com portões só no que mudou → `/sm sprint prepare` → `plan` → … |
| **Capacidade nova**, sem cobertura no SDD | `/sm brainstorm <ideia>` → segue o cenário A a partir do `/sm sdd` |

Se a mudança mexe em algo já planejado ou em construção, rode antes **`/po impact <mudança>`**: o PO diz o que ela custa, o que quebra e o que sai para caber.

### D · Corrigir um problema

**Você relata** anotando cada problema em `.team-project/note.md`, seção **Abertas**, um por linha, como **sintoma** ("depois de salvar duas vezes seguidas em X, a tela trava" — não "corrigir o timeout de X"). Depois, dois comandos:

```
/sm fix plan        o time faz a triagem da fila e planeja o bloco de correções
                      PO classifica cada item · QA reproduz os defeitos
                      ajuste pequeno → você confirma em formulário (uma pergunta por ajuste)
                      Arquiteto planeja cada correção e confere se ela cabe na trilha
                      você recebe: o que virou correção, o que foi para outro caminho, o bloco planejado
/sm fix run         o time corrige e valida o bloco — sem te acionar
                      uma correção por vez, cada uma com teste que falha antes e passa depois
                      você recebe o resultado por correção
```

O que o PO classifica em cada item:

| O item é… | Vai para |
|---|---|
| **Defeito** — o sistema não faz o que a documentação já diz — e é pequeno | **Correção** (`F-<nnn>`), depois que o QA o reproduz |
| **Ajuste pequeno** — muda no máximo uma regra que já existe, sem tela nova | **Correção**, depois da sua confirmação no formulário |
| Defeito ou ajuste que **não cabe** (tela nova, regra nova, API, banco, segurança, dado sensível, mais de 5 arquivos) | Product Backlog → sprint: `/sm sprint prepare` → `plan` → … (ou correção pontual no sprint, se couber na folga) |
| **Mudança de escopo disfarçada** | Product Backlog — se quiser saber o custo, `/po impact` |
| **Dúvida de uso** | o PO responde |
| Defeito que o QA **não reproduziu** | volta a você como suspeita, pedindo mais detalhe |

Item tratado **sai do `note.md`** e passa a viver no destino.

- **Uma correção que deixa de caber no meio do caminho é promovida**: sai do bloco com o motivo, vai ao Product Backlog, e o resto do bloco segue. Isso é a trilha funcionando, não falha.
- **O bloco tem limite** (5 correções). O que sobrar fica na fila para o próximo `/sm fix plan`; `/sm fix` mostra a fila.
- **Com sprint aberto:** o `fix plan` roda a qualquer hora; o `fix run` espera a Task em construção terminar, e nenhuma Task começa enquanto ele roda. O custo das correções fica na pasta do bloco, fora do sprint.
- **Correção fechada pelo QA está encerrada** — não passa pela Sprint Review. Se o problema voltar, anote no `note.md` citando a correção (`F-<nnn>`): ela é reaberta no próximo `/sm fix plan`.
- **Só relatar, sem corrigir agora:** `/po note` (a fila) ou `/po bug <relato>` (um item). A triagem é a mesma; as correções ficam na fila até o próximo `/sm fix plan`.

**O time também acha defeito sozinho** — QA numa validação, dev implementando, Arquiteto revisando. Isso vai direto ao registro do QA, sem passar por você. Se bloqueia uma História do sprint, vira Task no próprio sprint; se não, o PO o leva ao Product Backlog.

**Quando o QA reprova uma Task**, o achado volta para quem é dono do problema:

| O achado é… | Vai para |
|---|---|
| Correção local, dentro do plano aprovado | o dev (`/dev resume <ID>`) — o `run` já faz isso |
| Do domínio de outro papel | o dono: `/po` · `/arc question` · `/ux` |
| De dois donos, sem dar para dizer qual | `/sm agreement <questão>` |
| O desenho não sustenta o requisito | o Arquiteto (`/arc question`) |
| Dúvida se o **critério** estava certo | o PO (`/po`) |

### E · Pedido novo no meio do sprint

**O sprint não cresce depois da Planning.** O pedido vai ao Product Backlog e concorre no próximo `prepare`. Rode `/po impact <mudança>` se precisar saber o custo antes. Única exceção: um problema que **bloqueia** uma História já no sprint — entra como Task, registrado com o que saiu para caber.

### F · O trabalho parou no meio

- **O `run` foi interrompido** (sessão fechada, erro de ambiente): ao reabrir a sessão, a abertura vê o `.team-project/.active-run` e avisa **"RETOMADA"** (v3.52.2: os agentes que estavam em andamento morrem com a sessão e ficam anotados em `.interrupted`). **A retomada é o mesmo comando que inicia:** rode `/sm sprint run` — o `run.ps1 next` diz de onde seguir e retoma cada Task do passo em que parou (o "Parei no passo" do relatório do dev), sem replanejar o que já tem plano. Para não parar, deixe o computador acordado durante o run (ver "Responder pelo celular", item 9).
- **Falha de ambiente** (v3.51): quando o `verify` ou o executor de cenários devolvem **exit 4**, o problema é a máquina, não o código — tempo esgotado, emulador com a tela em branco, site fora do ar, outro automatizador usando o aparelho, perfil do Windows com acento. O time tenta o reparo uma vez e, sem sucesso, a Task fica bloqueada por ambiente com a ação para você (§"Ambiente de execução", abaixo).
- **O `fix run` foi interrompido:** rode `/sm fix run` de novo. Ele retoma da correção em que parou; as já fechadas não são refeitas.
- **O `sdd` parou num portão:** rode `/sm sdd` de novo; ele retoma na primeira etapa não concluída.
- **Não sabe em que ponto está:** `/po status` (visão de entrega) ou `/sm board` (quadro do sprint).

### G · Pedir consultoria externa

Quando uma decisão especializada pede segunda opinião — **técnica** (`database`, `security`, `design`, `architecture`, `infrastructure`) ou **de negócio** (`business:<área>`, para o PO e você nos processos de uma área que o time não domina: faturamento, regulatório, atendimento…) —, rode `/sm consulting <domínio> <tema>`. **Só fora do `sprint run`**: no onboarding, no brainstorm, no `sdd`, no `prepare` ou entre sprints.

```
/sm consulting <domínio> <tema>     o SM abre o caso; os papéis do domínio escrevem a carta; o QA confere a sanitização (+ PO no business)
você                                leva a carta ao consultor do registro (.team-project/README.md §7a) e cola a resposta, sem editar
o time                              valida a resposta; sem consenso, réplica — no máximo 3
                                    consenso → 3 opções comparáveis, com a recomendação do time
você                                escolhe em formulário; o Arquiteto registra o ADR (técnico) ou o PO a regra no SDD funcional (business)
```

- **O plugin não chama consultor nenhum.** Você transporta cada rodada — para uma IA ou para um especialista humano; o protocolo é o mesmo. Trocar de consultor é editar o registro no `.team-project/README.md` §7a.
- **Nada sai sem sanitização**: sem dado pessoal, segredo, nome de cliente ou contrato; no `business`, sem valores reais, parceiros, preços ou documentos internos.
- **A resposta do consultor é dado, não decisão.** Ela só chega a você depois de validada pelo time; a escolha é sua.

### H · Avaliar se o time compensa

O time mede, a cada sprint, **quanto custa entregar valor e com que qualidade** — e, quando você quiser, compara com o Claude usado sem o plugin.

- **No fim de cada sessão de trabalho, rode `/usage` e cole a saída para o time.** É o único custo em US$ observado: o registro de consumo dos papéis mede só tokens e não enxerga a sessão principal. Até ser verificado num projeto real, esse número é lido **à parte**, sem somar ao dos papéis.
- **Na retrospectiva**, o bloco **"Custo × resultado"** mostra tokens e US$ por História aceita, onde o custo está (especificação · produção · verificação · retrabalho · cerimônia), aprovação na 1ª passada do QA, GAPs por Task, **defeitos que escaparam** (os que você relata até 2 sprints depois do aceite) e quantas vezes o time te acionou.
- **Ao relatar um defeito de algo já aceito**, diga, se souber, de qual História é: o PO registra a **História do aceite**, e o defeito entra na conta do que escapou.
- **Comparação com o Claude sem o plugin:** siga `rituals/benchmark.md`. De 3 a 5 itens já aceitos são refeitos em worktrees, sem o plugin — com a especificação do time e só com o seu pedido original —, e avaliados às cegas contra o que o time entregou. **Você data a regra de decisão antes da primeira execução**; o resultado é direcional, não estatístico.

## Quando uma guarda bloqueia

Algumas regras são garantidas pelo próprio Claude Code, por **guardas** (hooks do plugin), e não só pelo texto que o agente lê. A sessão abre com uma linha "Guardas do time: ativas …".

| Guarda | Bloqueia ou avisa | O que fazer |
|---|---|---|
| **G1** | commit com arquivo de `.team-project/` (R31) | `git restore --staged .team-project` e commitar só o produto. Na migração do `/team update` (passo 7b), o próprio ritual desliga a G1 durante o passo |
| **G2** | edição da cópia instalada do plugin | mudança de processo vai pelo `/review`, no clone do repositório do plugin |
| **G3** | formulário cuja última opção não é "Pedir mais contexto" (R22), ou sem um exemplo prático (v3.51, H1); em projeto com identificador remoto, pergunta sem o prefixo `[<ID> · …]` ou sem a pendência gravada antes (R34) | o agente refaz a pergunta; vale para toda pergunta, até a simples |
| **G4** | aviso: saída de comando com mais de 300 linhas no contexto (R28) | delegar a execução pesada ao `operator` |
| **G5** | subagente editando arquivo de gate (`.editorconfig`, CI, `*.ruleset`… — lista em `guards.json` → `protectedPaths`) | o papel levanta 🔺 GAP; mudança de gate é sua. Projeto com outro arquivo de gate: acrescente-o à lista |
| **G6** | dev acrescentando teste ignorado (`[Skip`, `.skip(`, `xit(`…) | o dev levanta 🔺 GAP ao Arquiteto |
| **G7** | Arquiteto, QA, dev ou UX disparando outro papel pela ferramenta `Agent` (R28) | só o `operator` é disparado por eles; o resto volta a quem orquestra |
| **G8** | papel editando arquivo de outro dono (matriz de `artifact-ownership.md`) ou código-fonte — o Arquiteto inclusive, salvo em spike declarado (`.team-project/.active-spike`) | o papel pede a mudança ao dono; o Arquiteto decide e devolve a resposta, validando no scratchpad. Nada é perguntado a você |
| **G9** | dev editando arquivo fora da lista do plano (R4 · R8), ou sem Task ativa | 🔺 GAP ao Arquiteto, que acrescenta o arquivo ao plano. Rodando `/dev` à mão, a sessão grava antes `.team-project/.active-task` |
| **G11** | `operator` escrevendo fora da pasta do próprio job | — (o `operator` só grava log e relatório) |
| **G14** | durante o `sprint run`/`fix run`: **libera** sozinho o operacional dos papéis (leitura, git sem push, build/teste de `guards.json` → `runCommands`) e nega o que está fora da lista, inclusive comando em segundo plano fora do `operator` | nenhum pedido de permissão para no meio da fila; todo agente do run volta assíncrono: quem o dispara encerra o turno e o aviso de conclusão reabre a sessão. Comando de build/teste que falta: o plano o declara em `### Comandos da Task` e o `run.ps1` pede a liberação **uma vez** antes da construção (`run.ps1 allow` grava em `runCommands`; v3.55.0) |
| **G17** | disparo de papel (inclusive o `operator`) com modelo diferente do de `.team-project/models.json` | dispare de novo com o `model` indicado. Para trocar o modelo de um papel, edite `models.json` (`{ "developer": "sonnet", "architect": "opus" }`; vale para os 7 papéis, vence o agente e as exceções do processo; `scripts/checks/models.ps1` mostra o que está em vigor) |
| **G18** | só no experimento de benchmark (`guards.json` → `bench`): o `AskUserQuestion` é negado e respondido pelo dossiê; com `foreground`, `Agent` em segundo plano é negado | siga a resposta `[bench]` como se fosse a do stakeholder (`rituals/benchmark.md` §7). Fora do experimento não há `bench` no `guards.json`: nada a fazer |
| **G15** | registra no `guards.log` todo pedido de permissão do Claude Code | — (é o rastro para diagnosticar chamada interrompida, R27) |
| **G19** | a sessão retomando por `SendMessage` um papel caro (Arquiteto, QA, PO, UX, SM) parado há mais de 5 min (v3.51) | — o time abre uma instância nova com o cartão de passagem; retomar regravaria todo o contexto no modelo caro |
| **G20** | o fim de turno no meio do `sprint run` com Task elegível no quadro (v3.51) | — a sessão segue a fila sozinha; esperar agente disparado nesta sessão é permitido (o aviso reabre a sessão) |
| **G16** | registra em `.team-project/usage.jsonl` o consumo **medido** de cada subagente (tokens processados, contexto final, modelo, duração, Task) | — e roda `scripts/checks/consumption.ps1`, que escreve o `consumption.md` (v3.49; antes, a sessão o rodava); ninguém copia número da notificação |
| **G23** | durante o run, o dev cujo contexto passou do teto (`guards.json` → `devContextCap`, padrão 100 mil; v3.53.1) roda comando ou edita código | — o dev grava o ponto de retomada no relatório e volta com `TETO`; o executor de Task abre instância nova, que segue dali. Projeto que precise de outro teto: ajuste o número (0 desliga) |

- **O agente recebe o motivo e corrige o rumo** — você normalmente nem vê o bloqueio. As guardas por papel (G5–G11) não valem para a sua sessão principal.
- **Falso positivo:** acrescente a guarda a `"disabled"` em `.team-project/guards.json`; vale na hora. Leve o caso ao `/review`, para a guarda ser corrigida.
- **Cada disparo custa de 0,8 a 1,2 s.** O que cada guarda **não** cobre está em `hooks/COVERAGE.md`; as decisões ficam em `.team-project/guards.log`, contadas na retrospectiva.
- **O `/sm close` começa por uma conferência automática** (`close.ps1`): sem evidência com veredito ✅ (R7) ou com documento vivo pendente (R12), a Task não fecha.
- **Verificação uma vez só** (v3.45.1, com `verify` no `guards.json`): o dev roda `scripts/checks/verify.ps1` — o teste focado durante o bloco, build/lint/suíte/cobertura uma vez no fim — e o resultado fica amarrado à impressão digital do código no disco. O QA confere com `-Mode check` e só roda a suíte de novo se o código mudou; o `close` não fecha com o `verify` vermelho ou de um código que mudou depois dele.
- **Plano em contrato** (v3.46): o Arquiteto escreve assinaturas, testes com "deve falhar se…" e a **mutação** que prova cada um — não o código inteiro (trecho literal até 15 linhas, ou validado). O `plan.ps1` confere o plano antes de o dev começar, e o `verify.ps1 -Mode mutation` prova que cada teste falha sem a regra, restaurando o arquivo depois.
- **Trilha leve** (v3.46): Task de até meio dia, até 4 arquivos, sem migration, segurança, interface nem arquivo de gate é marcada `leve` na Planning — plano curto e QA só no que ela toca, com a mesma evidência.
- **Fechamento sem o SM** (v3.46): no `sprint run`, a sessão fecha cada Task com `close.ps1 -Apply` (quadro, burndown, conferência e a entrada de status para colar); o SM só entra quando o fechamento pede decisão.

## Os seus quatro portões

| Portão | Onde | O que você recebe | Como decide |
|---|---|---|---|
| **① SDD funcional** | `/sm sdd` | o protótipo funcional em HTML, com todos os fluxos principais — e, no projeto remoto, o link para abrir no celular | **navega** o protótipo e responde o formulário; "aprovar" **declara** que você navegou |
| **② SDD técnico** | `/sm sdd` | arquitetura, dados e API da primeira fatia, resumidos pelo Arquiteto | formulário |
| **③ Pacote do sprint** | `/sm sprint plan` | Sprint Backlog fechado · critérios de aceite · protótipo do sprint · `planning.md` (inclusive o que **não** entrou e por quê) | **navega** o protótipo do sprint (na máquina ou pelo link no celular) e responde um formulário só para o pacote inteiro; "aprovar" **declara** que você navegou |
| **④ Aceite** | `/sm sprint review` | o dossiê de cada História, critério a critério, com a evidência do QA | uma pergunta por História |

- **Por que navegar, e não ler.** Aprovar texto é aprovar uma descrição; a divergência entre o que você imaginou e o que o time entendeu só aparece quando você atravessa o fluxo. No ① o que se joga fora é HTML; depois, é arquitetura e código.
- **O ③ aprova todas as Histórias do sprint de uma vez** e é o que faz o sprint arrancar: nenhuma Task entra em construção antes dele. Se reprovar, o PO reordena, o corte é refeito e o pacote volta.
- **No ④, ressalva, gap e erro** viram entrada no Product Backlog na mesma sessão, com dono, e a priorização deles volta a você no pacote do sprint seguinte.
- **Na evolução de área documentada (cenário C)**, um portão sem nada a decidir é dispensado — só com o dono declarando, com motivo, que aquela parte não muda.
- **Um `/ux prototype` ou `/arc` rodado avulso não abre nem fecha portão**: a decisão fica pendente até o `/sm sdd`.

## Acompanhar o sprint sem gastar token

Dois comandos mostram como o sprint está andando. Quem responde é um script: o modelo não é acionado, então **não gastam token** (medido: 0 tokens, US$ 0, resposta em ~2 s). Funcionam no console e no terminal do VS Code; pelo app do celular e com um `sprint run` em andamento devem funcionar igual, mas isso ainda não foi medido. Eles só leem os arquivos do projeto e não mudam nada.

| Comando | Mostra | Use quando quiser saber |
|---|---|---|
| `/team-status` | O quadro do sprint e o que espera você | "Como está o sprint? Quem está trabalhando? Tem decisão minha parada?" |
| `/team-usage` | Quanto o sprint gastou, por Task e por papel, e quanto da cota da assinatura | "Quanto da minha cota já foi? Qual Task ou papel gasta mais?" |

Sem número, mostram o sprint corrente. Com um número, mostram outro: `/team-status 4`, `/team-usage 4`.

**O que o `/team-status` mostra:**

```text
Sprint 5 · 16 Tasks · ✅ 1 · 🟪 0 · 🟨 0 · 🟦 13 · ⬜ 2 · 🔴 0
Restante: 12 de 12,0 (estimativa)
Run: sprint 5 em andamento desde 2026-11-02 14:31
Agora: nenhum agente em execução

Em execução: T-061 · Novo Manejo (canteiros) · há 1h21 (start às 02/11 19:22)
  último sinal de vida há 1h21 (start, 19:22)
  comando: reparo/conferência do alvo android (target.ps1 android) (pid 2032, desde 2026-11-02 19:22:37) — há 1h21 · CPU 1 s · esperando: adb.exe emu kill · ⚠ POSSÍVEL TRAVAMENTO (sem CPU, processo filho nem arquivo novo há 10 min ou mais)

🟦 Plano: T-071 T-041 T-042 …
⬜ A fazer: T-065 T-066
✅ Fechada: T-056

Última transição: T-064 ⬜ → 🟦 · 2026-11-01 14:41

Esperando você: 2 decisão(ões) em README §7
  1. [ACME · S4 · ④ APK] Liberar o APK 1.05.30? …
```

- **1ª linha:** o placar. ✅ fechada · 🟪 em verificação · 🟨 em construção · 🟦 com plano · ⬜ a fazer · 🔴 bloqueada.
- **Restante:** quanto falta do sprint, pela estimativa do burndown.
- **Run e Agora:** se um `sprint run` está rodando e quais agentes trabalham neste momento, em qual Task e há quanto tempo.
- **Em execução (v3.53.5):** a Task em construção e há quanto tempo, desde o último `start`. Também mostra o último sinal de vida dela, o mais recente entre o agente, a pasta do `verify`, a do `accept` e o relatório. Se a Task espera um comando (`verify`, `accept`, reparo do alvo), aparecem o tempo, a CPU, o processo em que ele espera e o último arquivo gravado. Use isto para ler uma espera longa:
  - **⚠ POSSÍVEL TRAVAMENTO:** o comando roda há 10 min ou mais sem gastar CPU nem gravar arquivo. Esperar não adianta: o `run.ps1 next` leva a decisão a você (encerrar o processo ou seguir esperando).
  - **⚠ PARADA:** o run está em andamento, mas nenhum agente nem comando roda para a Task há 20 min ou mais. Retome com `/sm sprint run`.
  - **run pausado:** nada roda porque o run foi pausado de propósito.
  - Sem Task em construção, aparece a última Task trabalhada e há quanto tempo o relatório dela foi gravado.
- **As colunas:** em que etapa cada Task está.
- **Esperando você:** as decisões suas que estão paradas (até 3 aparecem; o resto está em `.team-project/README.md` §7).

**O que o `/team-usage` mostra:**

```text
Consumo · Sprint 4 (fechado) · 185,40 mi tokens · 13h24 de agente · 140 rodadas
Cota agora (04/11 10:12): 5h 37% · semana 41% · a semanal subiu 28,0 ponto(s) desde a 1ª rodada do sprint (agentes, sessão e uso fora do plugin juntos)

Por Task (tokens · tempo):
  T-053  57,38 mi · 3h09
  T-047  53,54 mi · 2h35
  …

Por papel (tokens · % dos tokens · rodadas):
  dev (haiku 5.5, sonnet 5.5)  112,94 mi · 61% · 35
  arc (opus 5.5)  45,81 mi · 25% · 19
  …

Última rodada: 31/10 23:21 · po · T-054 · 181 mil
```

- **1ª linha:** o total do sprint: tokens, tempo somado dos agentes e quantas vezes um agente rodou ("rodadas").
- **Cota (v3.53.6):** o uso atual da janela de 5 h e da semanal da sua assinatura, e quanto a semanal subiu desde a primeira rodada do sprint. Vem da status line do plugin (veja **Cota da assinatura**, abaixo). Sem ela ativa, a linha diz como ativar. Desde a v3.53.6 não há mais valor em dólar: o que importa num plano por assinatura é a cota.
- **Por Task:** da que mais gastou para a que menos gastou.
- **Por papel:** quanto cada papel do time gastou, com o modelo que usou e a sua parte nos tokens.
- **Quanto da cota cada rodada, Task e modelo gastou** está no `consumption.md` do sprint, seção **Cota da assinatura**.

### Cota da assinatura (v3.53.6)

O Claude Code só mostra o uso da cota (janela de 5 h e semanal) num lugar: o JSON que ele passa à **status line**. O plugin traz uma status line que mostra a cota no rodapé e grava cada mudança num registro (`%USERPROFILE%\.claude\quota-log.jsonl`). Com esse registro, o `consumption.ps1` divide a subida da cota entre as rodadas de agente que rodavam em cada intervalo.

**Ativar**, no `~/.claude/settings.json`:

```json
"statusLine": { "type": "command", "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"<pasta do usuário>/.claude/plugins/marketplaces/team/scripts/statusline/quota-statusline.ps1\"" }
```

O rodapé passa a mostrar algo como `Opus 5.5 · 5h 37% (reinicia 14:20) · semana 12%`. A cota só aparece depois da primeira resposta do modelo na sessão e só para assinatura Pro, Max ou Ultra.

**Bom saber:**

- **A divisão é uma estimativa.** A Anthropic não publica quanto cada modelo pesa na cota. Quando duas rodadas correm ao mesmo tempo, a subida é dividida pelos tokens de cada uma, com um peso por modelo (de início, a proporção de preço da API). O `consumption.md` traz a tabela de calibração (% da cota por milhão de tokens, medida nos intervalos em que só um modelo rodou). Para trocar os pesos, grave `.team-project/quota-weights.json`.
- **Os números finais saem no fechamento e na retrospectiva** (`consumption.ps1 -Session`), que separam a sessão principal. Antes disso, a parte da sessão cai nas rodadas.
- **Tudo o que usa a conta entra no registro**, inclusive o claude.ai e outros projetos abertos no mesmo intervalo.

**Bom saber:**

- **Conta só os agentes.** A conversa principal com você não entra aqui; ela é medida no fechamento da Task e na retrospectiva.
- **Logo depois de atualizar o plugin** (`/team update`), feche e abra a sessão para os comandos funcionarem sem token.
- **Se aparecer uma resposta do modelo em vez da tela acima**, o atalho sem token não funcionou nessa sessão. O resultado é o mesmo, mas gasta um pouco de token. Feche e abra a sessão. Se continuar, avise o dono do plugin.

## Conhecimento do projeto: o que o sprint ensinou volta para o próximo (v3.56.0)

Todo 🔺 GAP ensina alguma coisa. Até a v3.55, essa lição ficava no plano da Task ou na ficha do sprint e morria com ele: o mesmo limiar de 160 px reprovou numa Task do sprint 4 e de novo numa do sprint 5. Agora cada lição tem um destino, e o sprint seguinte a recebe sem ninguém reler arquivo inteiro.

**Como funciona:**

1. **Na decisão do GAP**, o Arquiteto escreve duas linhas: de onde o GAP veio (**Origem**: previsão, conhecimento, requisito, ambiente ou processo) e para onde vai a lição (**Lição**):
   - `projeto`: um fato deste sistema que vai se repetir. Vai para `.team-project/architect/knowledge.md`;
   - `stack:<nome>`: um comportamento do framework que pegaria qualquer projeto com a mesma tecnologia. Vai para a camada da stack do projeto (`.team-project/standards/stacks/<nome>/pitfalls.md`);
   - `plugin`: um defeito ou uma regra do próprio plugin. Vira ocorrência de plugin;
   - `nenhuma`: algo que só aconteceu nessa Task.
2. **No fechamento do sprint** (`/sm sprint close`), o SM roda o `knowledge.ps1` e copia cada lição para o destino dela, sem reescrever. Você recebe a tabela "de onde vieram × para onde foram" na retrospectiva. As lições de plugin e as **propostas de configuração** entram no mesmo formulário de "investigar ou ignorar". Uma proposta de configuração é, por exemplo, "declarar as stacks" ou "aumentar o tempo da massa de dados". Você aprova, e o SM grava só o que você aprovou.
3. **No sprint seguinte**, o cartão de cada Task traz as entradas cujo **Vale para** casa com os arquivos dela, por exemplo `src/app/**/*.render.spec.ts`, e as armadilhas da stack (até 6). Nem o dev nem o Arquiteto abrem os arquivos inteiros.

**O que você decide:**
- **As stacks do projeto** ficam em `guards.json`, na chave `"stacks": ["angular", "ionic-capacitor"]`. Sem ela, o plugin adivinha pelo `package.json` e avisa quando a sessão abre.
- **O teto:** acima de 15 KB de conhecimento, o próximo `/sm sprint prepare` começa com o Arquiteto consolidando: junta as entradas parecidas e apaga as superadas.
- **Repetição com registro** é o indicador a olhar na retrospectiva. Ele aparece quando um GAP repete algo que já estava registrado e o registro não chegou à Task. O alvo é zero.

**Ao atualizar para a 3.56.0** (`/team update`, passo 7m): o update cria o `knowledge.md` e pergunta as stacks e o destino das decisões do sprint aberto. As decisões antigas não são reescritas: as do sprint aberto vão para o conhecimento no fechamento dele.

## Plano externo: planejar fora do Claude (v3.53.4)

O plano de cada Task (o Arquiteto, no modelo Opus) é o que mais pesa no limite da conta: no sprint 5 do garden, foi cerca de 2/3 do gasto. Com o plano externo, esse trabalho vai para um assistente de fora (o app do Codex, um chat na web), e o Claude só constrói. As conferências não mudam: o plano que volta passa pelo `plan.ps1` antes de entrar no quadro, e a construção segue com `verify`, `accept` e `close`.

**O que continua no Claude:** o `prepare`, a Planning (inclusive a **ficha** de cada Task, que é o que o pacote leva), os cenários da QA, a construção e o fechamento. Só o plano da Task com ficha (e a decisão de um 🔺 GAP dela) sai.

**Ligar** — no `.team-project/guards.json` do projeto, a qualquer momento antes do `sprint run` (nada antes dele lê a chave):

```json
"run": { "planner": "external", "tasks": [] }
```

- `tasks` vazio: todas as Tasks com ficha vão para fora.
- `tasks` com IDs (`["T-045", "T-046"]`): só elas — é o piloto. As IDs só existem depois da Planning.
- Desligar: `"planner": "claude"` (o padrão). Vale no próximo `run.ps1 next`.

**O ciclo, por História** (o run prepara uma História por vez):

1. O run para e mostra `PRÓXIMA AÇÃO: external plan`, com o caminho do pacote. Parado, ele não gasta nada; a Task que já estava em construção segue.
2. **Pegue** em `.team-project/sprints/<n>/pack/out/`:
   - **chat na web:** suba o `H-012.zip` e escreva *"siga o INSTRUCTIONS.md"*;
   - **app do Codex:** abra a pasta `out/H-012/` com a mesma frase.
3. **Devolva** o `H-012-return.zip` que ele gerar (ou os `T-045-plan.md` soltos) em `.team-project/sprints/<n>/pack/in/`.
4. Rode `/sm sprint run`. O `next` lê `pack/in/`, confere cada plano com o `plan.ps1` e:
   - **aprovado:** grava em `plan/` com o nome que a Planning deu e põe o link na coluna Plano; a Task vai à construção;
   - **reprovado:** não entra; sai um pacote de correção (`H-012-fix1.zip`) com o plano devolvido e a tabela do que faltou — volte ao passo 2;
   - **arquivo que não é `<T-ID>-plan.md`** (código, outra pasta): ignorado, nada entra no projeto.
   O que foi lido vai para `pack/done/`.

**🔺 GAP na construção:** quando o dev para com uma dúvida de desenho numa Task do plano externo, a decisão também vai num pacote (`T-045-gap.zip`, com o plano atual, o relatório do dev e o diagnóstico do alvo). A Task espera; volta à construção quando o plano com a decisão passa pelo `plan.ps1`.

**Na trilha fix (`/sm fix plan` e `/sm fix run`)** a mesma chave vale. A estrutura do fix não muda: só o passo do Arquiteto vai para fora.

1. O `/sm fix plan` faz a triagem, monta o bloco e o formulário dos ajustes como sempre. No passo dos mini-planos, ele para e mostra o pacote do bloco: `.team-project/fixes/B-007/pack/out/B-007.zip` (ou a pasta `out/B-007/`).
2. Você leva o pacote, devolve o `B-007-return.zip` (com um arquivo só, o `B-007-plan.md`) em `.team-project/fixes/B-007/pack/in/` e roda **`/sm fix plan` de novo**. Ele não refaz a triagem nem o formulário: confere o retorno com o `fix.ps1 -PlanOnly` e, aprovado, mostra o resumo do bloco. Reprovado, sai o `B-007-fix1.zip`.
3. O `/sm fix run` segue igual. Um 🔺 GAP numa Correção vai num pacote (`F-012-gap.zip`, devolvido como `F-012-plan.md`, só com a seção dela). As outras Correções seguem, e a do GAP volta quando a decisão passar na conferência.

Para o piloto, `tasks` aceita também o bloco (`"B-007"`) ou uma Correção (`"F-012"`).

**Bom saber:**

- **O pacote é pequeno:** a ficha, o modelo do plano, o ambiente medido no sprint, os cenários e os arquivos que a ficha aponta — não o projeto inteiro.
- **Quem está de fora não roda comando.** O roteiro manda copiar o ambiente medido no sprint e transformar o que não foi medido em premissa, nunca inventar uma saída.
- **O consumo de fora não é medido** pela G16; o run-log marca `external plan` em cada Task, para comparar com o sprint anterior.
- **Conta:** o Claude na web, na mesma conta do Claude Code, usa o **mesmo limite** — não alivia nada. Use outro assistente.

## Responder pelo celular

O time pode te perguntar — e você pode retomar o trabalho — pelo **Claude Code no celular**, por **Remote Control**: a sessão continua rodando no seu computador, e o app do Claude se conecta a ela.

1. **Uma vez por projeto:** `/team remote`. Ele define o **identificador** do projeto (ex.: `ACME`) e a conta (pessoal ou da organização), confere o que dá para medir e imprime o comando de abertura.
2. **Abra cada projeto na sua própria janela de terminal** com o comando impresso — `claude --remote-control "ACME · <produto>"`. Um projeto, uma sessão. Remote Control não roda na extensão do VS Code. Se a extensão usa uma conta e o terminal outra, veja [abaixo](#quando-a-extensão-do-vs-code-usa-uma-conta-e-o-terminal-usa-outra).
3. **No app do Claude, aba Code:** cada projeto aparece como uma sessão, com o nome do comando.
4. **Toda pergunta do time começa com o prefixo** — `[ACME · S4 · ③ pacote]`: projeto, sprint e o que se decide. Responda pelos cartões, como no terminal. Os comandos também funcionam digitados no app (`/sm sprint review`, `/po status`).
5. **Não espere notificação:** no Android a pergunta não avisa (medido). Abra **Code** no app para ver o que está esperando.
   **Para acompanhar sem gastar token,** digite `/team-status` (quadro, quem trabalha agora, o que espera você) ou `/team-usage` (tokens e US$ por Task e por papel). Veja [Acompanhar o sprint sem gastar token](#acompanhar-o-sprint-sem-gastar-token).
6. **"Pular" não decide nada:** a pergunta fica pendente em `.team-project/README.md` §7 e volta quando o time retomar.
7. **① e ③ também se respondem pelo celular.** A pergunta traz o link do protótipo publicado como página privada na sua conta: navegue nele e decida. "Aprovar" declara que você navegou — a responsabilidade é sua. Se o produto também tem site, a navegação no desktop continua por sua conta.
8. **Quando a fila do `sprint run` termina,** chega `[ACME · S4 · fim do run] Iniciar a Sprint Review?` — no terminal e no celular. "Agora" já abre a Review; "depois" deixa anotado. Iniciar a Review não é aceitar nada.
9. **Se o computador suspender, a sessão cai.** Nada se perde: a pergunta está em §7 e volta quando você reabrir o projeto. Enquanto existir `.team-project/.active-run` (um `sprint run` ou `fix run` em andamento), mantenha o computador acordado: na tomada, com a suspensão e a hibernação desligadas. No Windows: `powercfg /change standby-timeout-ac 0` e `powercfg /change hibernate-timeout-ac 0` (a tela pode apagar; ela não é a suspensão) e, em notebook, a ação de fechar a tampa em "Não fazer nada" (Opções de energia → Escolher a função do fechamento da tampa). Desfaça ao fim do run. Medido no piloto: ~122 h de máquina suspensa com agentes em segundo plano, que viraram o vigia de 600 s, rede caída e um desligamento inesperado. Se a máquina suspendeu, os agentes em andamento morreram com a sessão: ao reabrir, a abertura avisa a retomada e você roda o mesmo comando (`/sm sprint run` ou `/sm fix run`); o time segue do passo em que parou, sem reenviar a fila.

### Quando a extensão do VS Code usa uma conta e o terminal usa outra

Cada conta do Claude fica numa **pasta de login** diferente no seu computador. Exemplo: a pasta `.claude` guarda a conta da empresa, usada pelo terminal, e a pasta `.claude-pessoal` guarda a conta pessoal, usada pela extensão. A extensão usa a pasta pessoal porque ela está indicada no VS Code, em `claudeCode.environmentVariables` → `CLAUDE_CONFIG_DIR`. O terminal não recebe essa indicação e, por isso, entra na outra conta.

Como o Remote Control só roda no terminal, abra o terminal **indicando a pasta da conta que você quer usar**:

1. **Feche o painel do Claude na extensão** (pela ordem de `rituals/team-remote.md` §1a, se houver um run em andamento). Um projeto, uma sessão.
2. No VS Code, abra o projeto e um terminal: **Terminal → New Terminal**.
3. Cole o comando, com a pasta e o nome do seu projeto:
   ```powershell
   $env:CLAUDE_CONFIG_DIR = "$HOME\.claude-pessoal"; claude --remote-control "ACME · <produto>"
   ```
4. Na sessão que abrir, digite `/status` e confira se é a conta certa. Ela precisa ser **Pro ou Max**, não chave de API.

A indicação vale **só para aquela janela de terminal**: o console normal continua na outra conta. Para não precisar colar o comando toda vez, ponha no `.vscode/settings.json` **do projeto** (assim, todo terminal novo do VS Code nesse projeto já abre na conta pessoal):

```json
{
  "terminal.integrated.env.windows": {
    "CLAUDE_CONFIG_DIR": "C:\\Users\\<você>\\.claude-pessoal"
  }
}
```

Depois disso, basta `claude --remote-control "ACME · <produto>"`. Duas coisas para manter iguais: o plugin precisa estar instalado **nessa pasta de login** (cada pasta tem os seus plugins), e a **Conta remota** do projeto em `/team remote` precisa ser a mesma conta, porque o protótipo publicado só abre para a conta que o publicou.

## Regras que valem em qualquer cenário

- **Toda Task pertence a uma História**, e nenhuma entra em construção antes do ③. Trabalho técnico sem valor declarado não entra.
- **Sem plano, sem código.** O dev executa o Plano de Implementação do Arquiteto; lacuna vira 🔺 GAP, não improviso.
- **Nada é "pronto" sem saída real de comando.** O que não foi exercitado é declarado como não exercitado.
- **O QA reprova, não corrige.** O aceite de valor é seu, por História, na Sprint Review.
- **Fechar uma Task não é aceitar a História.** Se a História for rejeitada na Review, todas as Tasks dela voltam — inclusive as que passaram no QA.
- **Cada papel escreve só o que lhe pertence.** Requisito e História são do PO; desenho, ADR e standards, do Arquiteto; telas e protótipos, do UX; quadro e status do sprint, do SM; evidência e mapa de código, do QA; código, do dev.
- **Dúvida funcional vai ao PO, técnica ao Arquiteto, estratégica a você.**

## Referência dos comandos

| Comando | Modos | Papel |
|---|---|---|
| `/sm` | `onboarding` · `brainstorm <ideia>` · `sdd [<tema>]` · `sprint prepare \| plan \| run [<T-ID>] \| review \| close` *(`review` tem o alias `/sm review`)* · `fix [plan [<F-ID> …] \| run]` · `board` · `agreement <questão>` · `consulting <domínio> <tema>` · `close <T-ID>` | Scrum Master — cadência, rituais, quadro, capacidade, riscos |
| `/po` | `status` · `impact <mudança>` · `analyze <ideia>` · `requirement <ID>` · `story <H-ID>` · `prioritize` · `accept <H-ID>` · `bug <relato>` · `note` | Product Owner — **o seu canal**: status, prazo, requisitos, Histórias, backlog, aceite, defeitos que você relata |
| `/arc` | `plan <ID>` · `adr <tema>` · `question <dúvida>` | Arquiteto — desenho, SDD técnico, Plano de Implementação, ADR, standards |
| `/ux` | `prototype` · `prototype sprint <n>` · `prototype screen <tela>` · `journey <fluxo>` · `screen <nome>` · `review-ui <tela>` | UX — protótipos, jornadas, telas, usabilidade, acessibilidade |
| `/dev` | `<ID>` · `resume <ID>` · `gap <resposta>` | Desenvolvedor — executa o plano, não improvisa |
| `/qa` | `<ID>` · `baseline` · `audit` · `security <ID>` · `bug <descrição\|lista>` *(acionado pelo PO ou pelo `fix plan`)* · `scenarios create` · `scenarios run <SC-nnn\|grupo\|all>` | QA — o veredito de qualidade que responde a você |
| `/sec` | `blackbox [escopo]` · `graybox [escopo]` · `whitebox [escopo]` | Security Engineer — engajamento de segurança **profundo e sob demanda** (pentest e secure code review do sistema), fora da cadência do sprint; reporta, não corrige. A checagem leve por Task é a frente 3 do `/qa` |
| `/team` | `init` · `update` · `version` · `remote` | Instala, atualiza e informa a versão — não dispara agente |
| `/review` | `<instrução>` · `note` · `metrics` · `audit` · `history` | Evolução do processo do time — **só no repositório-fonte do plugin** |
| `/team-status` · `/team-usage` | `[<n do sprint>]` (sem número: o sprint corrente) | Consulta **sem token**: um script responde e o modelo não é acionado. `/team-status` mostra o quadro, quem trabalha agora, o run e o que espera você; `/team-usage` mostra tokens, US$ e tempo dos agentes, por Task e por papel |

**No dia a dia você usa quase só `/sm`, `/po` e, às vezes, `/arc question`.** Os `/sm` de ritual chamam os outros papéis por você.

**Comandos de papel avulsos** (`/arc plan`, `/dev`, `/qa <ID>`, `/sm close`) existem para acompanhar uma Task etapa por etapa, ou para **calibrar** a instalação antes da primeira Planning (o plano vai para `.team-project/architect/calibration/`, sem fechamento). No fluxo normal, o `/sm sprint run` faz essa sequência por você.

**Os três `prototype` são artefatos diferentes:** sem argumento é o **protótipo funcional do produto** (portão ①); `sprint <n>` é o **protótipo costurado do sprint** (portão ③); `screen <tela>` é uma **tela isolada**, para explorar, sem portão.

**História × Task.** A **História** é a unidade de valor — do PO, aprovada por você no ③ e aceita no ④. A **Task** é a unidade de trabalho — nasce da quebra da História na Planning e carrega o plano do Arquiteto. Comando com `<H-ID>` opera sobre valor; com `<T-ID>`, sobre trabalho.

**`/sm sprint review` não é `/review`.** O primeiro é a Sprint Review, no projeto, onde você aceita as Histórias. O segundo muda o processo do time e roda só no repositório-fonte do plugin.

**Duas filas de anotação, dois alvos.** `.team-project/note.md` é a fila do **produto** — problemas que você encontra usando o que o time construiu; o PO a trata com `/po note`. O `note.md` do repositório do plugin é a fila do **processo** — como o time trabalha; o `/review` a trata. Melhoria de processo percebida num projeto é anotada como sintoma lá, não aqui.

**Se um comando não for reconhecido, use o prefixo do plugin:** `/team:sm`, `/team:po`, `/team:review`… Isso acontece quando outro plugin instalado declara o mesmo nome curto.

## Onde cada coisa mora

| Camada | Diretório | Muda por |
|---|---|---|
| Processo do time | o plugin (`${CLAUDE_PLUGIN_ROOT}`) | só o `/review`, no repositório-fonte do plugin |
| Contexto e controles do projeto | `.team-project/` — **local, fora do git** | o trabalho normal do time |
| Entregáveis do produto | `docs/` do projeto (SDD, ADR, implementação) — **no git, sem referência a `.team-project/`** | os donos declarados em `deliverables/README.md` |
| Código | o diretório de código do projeto | só o dev, e só os arquivos do plano vigente |

### O que o `/team init` cria no seu projeto

Uma pasta só, `.team-project/`, na raiz. **Nada fora dela é tocado** — a não ser uma linha `.team-project/` acrescentada ao `.gitignore`, se o projeto é repositório git: o processo é **local**, e o git recebe só o produto (código e `docs/`).

```
.team-project/
├── README.md              contexto do projeto · declara o SPRINT CORRENTE (§2)
├── how-to.md              cópia deste guia, atualizada a cada /team update
├── note.md                sua fila de relatos — escreva o sintoma, o PO trata em /po note
│
├── consumption.md         consumo fora de sprint (onboarding, brainstorm, prepare, sdd, entre sprints) — mesmo modelo do de dentro do sprint
├── consulting/            casos de consultoria externa (/sm consulting) — nasce só quando você pede um
├── benchmark/             o experimento "o time compensa?" (rituals/benchmark.md) — nasce só quando você o abre
├── guards.json            liga e desliga as guardas deste projeto ("disabled") · guards.log: o que elas barraram
├── fixes.md               a fila e o histórico das correções (/sm fix) — nasce na primeira correção
├── fixes/                 uma ficha por correção (F-<nnn>.md) e uma pasta por bloco:
│   └── B-<nnn>/           plan.md · consumption.md (o custo do bloco, fora do sprint) · verdict.md
│
├── sprints/               O REGISTRO DE EXECUÇÃO, um subdiretório por sprint
│   └── 1/ 2/ 3/ …
│       ├── planning.md              o que foi decidido na Planning, e o que NÃO entrou
│       ├── sprint-backlog.md        o quadro vivo do sprint, com a sua decisão do ③
│       ├── stories/                 as Histórias como você as aprovou (congeladas)
│       ├── plan/                    um Plano de Implementação por Task
│       ├── evidence/                a evidência de cada Task: comando e saída real
│       ├── consumption.md           tokens e duração por invocação (inclui o operator)
│       ├── kanban.md                Kanban, rodadas (tokens e tempo), burndown e controle das Tasks
│       ├── review.md                a Sprint Review e a sua decisão por História
│       ├── retrospective.md         o que o time corrige no sprint seguinte
│       └── plugin-report.md         só se você escolher "investigar" uma ocorrência de plugin na Review: relatório de processo, sem contexto do projeto, que você encaminha ao dono do plugin
│
├── product-owner/         context.md · product-backlog.md (índice) · stories/ (fonte viva)
├── scrum-master/          context.md (inclui o SDD em elaboração e as candidatas do próximo sprint)
├── architect/             context.md · spikes/ · calibration/ (planos antes da 1ª Planning)
├── user-experience/       context.md · prototype/ (+ prototype/sprint-<n>/) · journeys/ · screens/
├── developer/             context.md
└── quality-assurance/     context.md · baseline.md (a régua de regressão do projeto)
```

- **Por que o registro é por sprint, e não por papel.** Um sprint produz artefatos de quatro donos. Em `sprints/3/` está tudo: o que foi planejado, o que você aprovou, como foi construído, com que evidência, o que você aceitou e o que o time decidiu corrigir. O dono continua declarado por subpasta.
- **Sprint fechado não se edita.** Depois da retrospectiva, a pasta vira registro histórico; o `/team update` nunca reconcilia estrutura nova dentro dela.
- **Fica fora da pasta do sprint** o que soma ou evolui através dos sprints: Product Backlog e Histórias vivas, SDD, ADRs, registro de GAPs, mapa de código, baseline, protótipo funcional do ①, casos de consultoria externa e as correções da trilha `fix`, com o consumo de cada bloco.
- **Onde está o quadro de hoje:** `.team-project/README.md` §2 declara o sprint corrente.

## Instalar e manter atualizado

O projeto-alvo **não precisa ser repositório git**.

**1. Adicione o marketplace** — sempre com a **URL `.git` completa**, nunca `owner/repo`, e **no escopo do projeto**:

```powershell
claude plugin marketplace add https://github.com/wtlmarco/scrum-team-plugin.git --scope project
claude plugin marketplace list      # o team tem de aparecer nas settings do PROJETO
```

O `.claude/settings.json` do projeto deve ficar assim:

```json
{
  "extraKnownMarketplaces": {
    "team": { "source": { "source": "git", "url": "https://github.com/wtlmarco/scrum-team-plugin.git" } }
  },
  "enabledPlugins": { "team@team": true }
}
```

**2. Instale e reinicie a sessão** — plugin só carrega na inicialização do Claude Code:

```powershell
claude plugin install team@team --scope project -y
```

Depois de reiniciar, `/plugin` mostra `team@team` como **enabled** e `/help` lista os **9 comandos** (`/sm /po /arc /ux /dev /qa /sec /team /review`) e os **9 agentes** (os seis papéis dos rituais, o Security Engineer sob demanda, o `operator` e o executor de Task `task-runner`). Se não listar, veja *Problemas de instalação*.

**3. `/team init`** — cria o `.team-project/` e conduz o preenchimento. Sem ele, todo papel para e pede que seja criado.

**Atualizar:** `/team update` compara a versão instalada com a do `main` da origem, mostra o que mudou e, com a sua confirmação, aplica e reconcilia o `.team-project/` — substitui o que é cópia literal (este guia) e **propõe** o delta do que tem conteúdo seu, nunca apagando nada sem aprovação. À mão: `claude plugin marketplace update team` e `claude plugin update team@team`, e reinicie a sessão.

**Uma origem, vários projetos.** O plugin é genérico: replicar o time é instalar o plugin e escrever o contexto do projeto (`.team-project/`), nunca copiar a pasta do plugin para dentro de cada projeto — as cópias divergem. Melhorias chegam a todos por `claude plugin marketplace update team` + `claude plugin update team@team`. A origem pode ser a URL `.git` ou um caminho local; use a mesma forma de identificador em todos os registros.

### Calibrar a instalação

**Composição do time.** A distribuição de modelos é escolha de custo/qualidade, não regra:

| Papel | Modelo | Por quê |
|---|---|---|
| Arquiteto | Opus | Concentra o raciocínio de desenho técnico; plano raso custa a Task inteira |
| UX, SM, PO, QA | Sonnet | Leitura, julgamento e verificação; no UX, a janela de 1M comporta o protótipo navegável de um arquivo só |
| Dev | Haiku | Executa plano detalhado; a qualidade vem do plano, não do modelo |

**Haiku não é opção para o UX:** a janela de 200K não sustenta um `index.html` navegável ponta a ponta, e truncá-lo quebra um portão (① e ③). Projeto **sem interface** pode dispensar o UX; projeto sem base de código legada pode dispensar o QA no começo; mais de uma frente independente justifica um segundo dev (faixas em [`roles/scrum-master/process/workflow.md`](roles/scrum-master/process/workflow.md) §7). Os princípios de **nível 1** ([`standards/implementation-principles.md`](standards/implementation-principles.md)) são agnósticos de stack; só o **perfil de nível 2** (`implementation-guide` / `implementation-quality`, hoje .NET/GitLab) se substitui quando a stack é outra — pelo Arquiteto, via `/review`, num clone do repositório-fonte.

**Primeira rodada de validação** — antes da 1ª Planning, nesta ordem, para confirmar que o time está calibrado:

```
/qa baseline          → os números declarados batem com a realidade?
/po status            → o status sai em 6 linhas, em Histórias, com evidência?
/arc plan <T-ID>      → o plano é executável por um júnior sem decidir nada?
/dev <T-ID> · /qa <T-ID> → a Task fecha com veredito e evidência real?
```

Antes da 1ª Planning use os comandos de papel; `/sm sprint run <T-ID>` exige o pacote do sprint aprovado e a Task no quadro. Se o primeiro plano do Arquiteto precisar de mais de dois 🔺 GAPs para ser executado, o problema não é o time — é o `context.md` do Arquiteto, raso: a métrica mais barata de saúde da instalação. O que mais rende ao escrever os `context.md` são as **armadilhas** do projeto ("handler novo exige registro manual, senão devolve 500"). Projeto retomado: comece pelo `pending.md` — `/qa audit` + `/qa baseline` revelam o tamanho verdadeiro do trabalho.

**Checklist da instalação**

- [ ] `claude plugin marketplace list` mostra o `team` nas **settings do projeto**, não nas do usuário
- [ ] `claude plugin list` mostra `team@team` habilitado (exibição duplicada é ruído)
- [ ] Sessão reiniciada; `/plugin` mostra `team@team` **enabled** e `/help` lista os 8 comandos e os 8 agentes
- [ ] `/team init` executado; `.team-project/README.md` escrito (stack, fontes da verdade, comandos, limitações) e os seis `context.md` com as armadilhas do projeto
- [ ] Em repositório git: `.gitignore` com `.team-project/` e `git ls-files .team-project` vazio (R31); `.team-project/consumption.md` existe
- [ ] Projeto retomado: `pending.md` produzido por `/qa audit` antes de qualquer planejamento
- [ ] Backlog inicial semeado com IDs (projeto novo: cenário A; retomada: cenário B)
- [ ] `/qa baseline` registrado em `.team-project/quality-assurance/baseline.md`
- [ ] Primeira Task fechada com veredito ✅ (`/sm sprint run`, depois da 1ª Planning com pacote aprovado)

### Ambiente de execução (v3.51)

O time roda o app de verdade para provar que ele funciona: no emulador ou aparelho (Android), no navegador com o site no ar (web). Isso se configura no `.team-project/guards.json`:

```json
"verify": { "build": "...", "suite": "...", "timeoutMinutes": 9, "env": { "GRADLE_USER_HOME": "C:\\gradle-home" } },
"targets": {
  "android": { "package": "br.com.app", "apk": "app/build/outputs/apk/release/app-release.apk", "avd": "Pixel_API_34", "serial": "emulator-5554", "maxUptimeHours": 24 },
  "web": { "url": "http://localhost:4200", "start": "npm run start", "startTimeoutSec": 120 }
}
```

**Ids de teste e app híbrido (v3.55.0).** O cenário e o teste localizam o elemento **pelo id**, numa convenção única de nomes (`standards/test-ids.md`); o atributo que carrega o id muda por alvo e se declara em `"testIds": { "attribute": "id" }` — `id` em app híbrido (Capacitor, Cordova, Ionic: o `uiautomator` lê o `id` HTML como `resource-id`, o `data-testid` não chega), `data-testid` em web pura, `testTag` em Compose. O mapa de ids sai **do código** (`ids.ps1 -Map` → `.team-project/architect/ids-map.md`), nunca escrito à mão. **Prova de app híbrido em emulador de container:** alvo `android` com serial de rede (`"serial": "localhost:5555"`), `testIds.attribute = "id"` e `targets.android.baseline` (massa de seeds aplicada depois de instalar e de cada reset); o que só existe dentro do WebView sem `id` correspondente no dump fica `[PARCIAL]` e vai a você — o time não contorna com `adb input` livre. **WebView que não publica o `id` (v3.57.1):** em versões novas do Android/WebView (medido: Android 15, WebView 124) o `uiautomator` não traz o `id` HTML como `resource-id` — o elemento aparece só com o texto. O `accept` procura o id também no **nome acessível** (`content-desc`, que vem do `aria-label`): o app espelha o id no `aria-label` **só no build de prova** (depuração), e o `resource-id` continua valendo primeiro. Quando os dois primeiros cenários falham com "tag ausente" e o dump só tem ids do próprio Android, o `accept` diz **IDS NÃO PUBLICADOS** (e não "estado de partida": declarar `baseline` não resolve). `/team update` (passo 7l) audita o projeto existente e propõe o retrofit; nunca corrige sozinho. **Projeto com dois runners de teste** (por exemplo Karma e `node:test`) declara `verify.focused` como lista de objetos `{ "command": "…", "paths": ["glob"] }`: o comando é escolhido pelo caminho do teste.

- **`scripts/checks/target.ps1 -Target android|web [-Repair]`** confere se o alvo está pronto (emulador desenhando a tela, site respondendo) e, com `-Repair`, tenta consertar uma vez (reinicia o emulador, sobe o servidor).
- **`scripts/checks/accept.ps1 -Task <ID>`** roda os cenários de `.team-project/quality-assurance/scenarios/*.scn` no alvo, com uma captura de tela por cenário (a prova que o QA anexa ao veredito). Um cenário que falha é repetido uma vez do zero; o relatório mostra as duas tentativas.
- **Um automatizador por vez.** A trava `.team-project/.target-lock` impede dois executores no mesmo aparelho (os dois quebram). Executor que caiu deixa a trava: `target.ps1 -Unlock`.
- **Web sem baixar navegador:** o executor usa o navegador do Playwright e, sem ele, o Edge ou o Chrome instalados. O Playwright vem do projeto (`npm i -D playwright`).
- **Comandos que não terminam:** o `verify` encerra cada comando em `timeoutMinutes` (padrão 9) e mata os processos que sobram (daemon do Gradle, nós do MSBuild). A higiene de cada ferramenta (Gradle sem daemon, `dotnet` sem reúso de nó, `CI=true` no Node) entra sozinha, de `scripts/checks/tool-hygiene.json`. Comando de teste em modo de observação (`ng test` sem `--watch=false`, `vitest` sem `run`) gera aviso.
- **Perfil do Windows com acento** (`C:\Users\João…`): os testes do Gradle falham sem aviso. Crie uma junção ASCII (`cmd /c mklink /J C:\gradle-home "%USERPROFILE%\.gradle"`) e ponha `GRADLE_USER_HOME` em `verify.env`, como no exemplo. A abertura da sessão avisa quando falta.
- **Emulador ligado por muito tempo para de desenhar a tela** (medido: depois de ~1 dia). O pré-voo confere o tempo ligado (`maxUptimeHours`) e reinicia o AVD no reparo.
- **Emulador num container (Docker) ou fora do SDK local:** declare o conserto em `"repair"` dentro de `targets.android`, por exemplo `"repair": "& ./docker/emulator-repair.ps1"` (um script do projeto que prepara e reinicia o container). Declarar o comando já é a sua autorização: o `-Repair` o roda sozinho, espera o aparelho iniciar e confere de novo, sem pedir licença a cada queda.
- **Um emulador só (v3.53.5).** Dois emuladores nas mesmas portas (5554/5555), como um AVD local e um container, deixam o `adb` "offline" e travam o reparo. Com o emulador num container, tire `"avd"` do `targets.android` e deixe só o `"repair"`. Se o AVD local estiver declarado e as portas já estiverem ocupadas por outro processo, o reparo recusa abrir um segundo emulador e diz quem está nas portas.
- **`"serial"` (v3.53.5):** o aparelho de trabalho, por exemplo `"serial": "emulator-5554"`. Com ele, todo `adb` vai a esse aparelho. Sem ele, se o `adb devices` lista mais de um aparelho (o mesmo emulador como `emulator-5554` e `localhost:5555`, depois de um `adb connect`), o pré-voo para e pede o `serial`, porque todo `adb shell` falharia com "more than one device".
- **Todo `adb` tem prazo (v3.53.5):** 90 s por chamada, 600 s para instalar o APK e 180 s para o aparelho voltar depois do reparo. Comando que estoura o prazo é encerrado e vira falha de ambiente, em vez de prender a trava do alvo por horas.
- **Memória do emulador (v3.53.6):** `"memoryCmd"` é um comando do projeto que imprime a memória do emulador (por exemplo `docker stats --no-stream --format "{{.MemUsage}}" <container>`), e `"maxMemoryMB"` é o limite. Acima dele, o pré-voo reprova e o reparo roda. No garden, o emulador do container chegou a 13,5 GB depois de 5 h ligado.
- **Container reiniciado no primeiro accept de cada Task (v3.53.6):** com `"repair"` declarado, o primeiro `accept` de cada Task roda o reparo antes dos cenários, para a prova começar de um emulador limpo (~2,5 min). As repetições na mesma Task reaproveitam o emulador. Desligue com `"freshStart": false`.
- **APK velho (v3.53.6):** o `accept` instala o APK mais novo de `build/outputs/apk/` — **por cima**, mantendo os dados do app (v3.57.2; antes desinstalava e apagava a base; só desinstala se o Android recusar a atualização, e avisa). Se o código do app mudou depois dele, o `accept` para com exit 2 e pede para reconstruir (`assembleDebug`): rodar os cenários num APK antigo acusa "tag não encontrada" sem defeito nenhum.
- **Sinal de vida de um comando longo do projeto (v3.57.1):** o `watcher` sabe se o `verify` e o `accept` andam, mas não um comando do próprio projeto que o dev roda (o build do APK num container, por exemplo: a CPU é do Docker e os arquivos caem num volume que o Windows não vê) — sem sinal, ele só diz "dev vivo há N min". Declare o sinal em `"waitSignals"` no `guards.json`, no nível de cima: `[{ "when": "alvo:apk", "paths": ["source/www", "source/android/app/src/main/assets/public", "source/dist"], "alive": "docker ps --filter name=meuprojeto-builder --format {{.Names}}" }]`. Quando a última ação do agente contém o `when`, a espera mostra o último arquivo gravado nessas pastas e se o `alive` imprime algo (ele roda com prazo de 20 s); 10 min sem ação do agente, sem arquivo novo e sem saída do `alive` = POSSÍVEL TRAVAMENTO, que vai a você.
- **APK fora de `build/outputs` e app híbrido (v3.57.1):** se o build não deixa o APK em `build/outputs/apk/` (build num container com a pasta `build` em volume do Docker, script que copia o APK para outra pasta), declare onde ele fica em `"apk"`, com máscara no nome se ele muda a cada build — `"apk": "source/dist/meuapp-*-debug.apk"` pega o mais novo. Em app híbrido (Capacitor, Cordova), o código que entra no APK é o web, não o `.kt`: declare-o em `"apkSources": ["source/src", "source/capacitor.config.ts"]` (testes `*.spec.*`/`*.test.*` e `node_modules` não contam). Sem `apkSources` e com o APK fora de `build/outputs`, o `verify full` e o `accept` avisam que a idade do APK não foi conferida.
- **Alvo fora do ar não fecha Task (v3.53.6):** se o `accept` para por ambiente e o reparo não resolve, a Task vai a 🔴 com "prova no alvo pendente" na tabela de Bloqueios. A fila segue com as outras Tasks. A cada `run.ps1 next`, o alvo é conferido: quando ele volta, a Task sai de 🔴 e o accept pendente roda. "Nenhum aplicável" por alvo indisponível é recusado no fechamento.
- **Ids de teste são obrigatórios (v3.53.6):** todo controle interativo tem id de teste (`testTag` no Android, `data-testid` na web) e todo id que um cenário cita tem de existir no código. O `verify -Mode full` reprova o que faltar e diz o arquivo e a linha. Caso legítimo sem id: comentário `// sem-testid: <motivo>` na linha ou na anterior.
- **Massa de dados (v3.53.7):** o `reset` zera a base do app. O cenário que precisa de dados pede `seed <nome>` (depois do `reset`, antes do `launch`), e o comando de cada massa fica em `targets.<alvo>.seeds`, por exemplo `"seeds": { "canteiros-3": "& ./tools/seed/canteiros.ps1 -Qtd 3" }` (`"seedTimeoutSec"`, padrão 300). O script é do projeto: recebe `ACCEPT_TARGET`, `ACCEPT_SEED`, `ACCEPT_SERIAL` e `ACCEPT_PACKAGE` (Android) ou `ACCEPT_URL` (web), e sai com 0 quando carregou. Massa não declarada reprova o `accept -ParseOnly` do QA, antes de qualquer aparelho. Massa que falha ao carregar é falha de ambiente (exit 4), não defeito do app.
- **Serial de rede se religa (v3.54.1):** com `"serial": "localhost:5555"` (emulador em container), a conexão do `adb` cai quando o servidor do `adb` reinicia ou a máquina suspende, e o emulador continua no ar. O pré-voo roda `adb connect` antes de reprovar e diz qual é o caso: emulador ou container fora (porta recusada), aparelho offline (iniciando ou travado) ou religado (segue a conferência).
- **Estado de partida do app (v3.54.2):** `"baseline": "<nome de uma massa de seeds>"` em `targets.android` põe o app na tela que os cenários esperam: introdução dispensada, login feito, base mínima. O `accept` a aplica depois de instalar o APK e depois de cada `reset`. Sem ela, um app reinstalado pode abrir na introdução, e todo cenário falha ali.
- **Accept que para cedo (v3.54.2):** se os 2 primeiros cenários falham na mesma tela e nenhum passa, o `accept` para (exit 4) com "ESTADO DE PARTIDA" e a tela em texto, em vez de rodar o resto (~7 min por cenário). Isso não é queda do emulador: a Task vai a 🔴 "estado de partida", sem reparo nem reabertura automática, e o formulário pergunta se você declara o `"baseline"` ou se o QA ajusta o cenário. Enquanto o accept roda, o `run.ps1 next` mostra quantos cenários passaram e quantos falharam, e avisa **SEM AVANÇO** quando nenhum passou em 15 min.
- **Reabertura automática uma vez (v3.54.2):** a Task 🔴 por "prova no alvo pendente" é reaberta sozinha quando o alvo volta, uma vez. Se o accept cai de novo, ela fica 🔴 e o `next` pede a sua decisão com a última falha. O quadro mostra Task nova em ⬜ assim que ela entra no Sprint Backlog e o motivo curto ao lado de cada Task 🔴.
- **Escolher opção (v3.53.7):** `select <id> = <opção>` toca o combo, a lista suspensa ou o seletor, escolhe a opção pelo texto visível e, se o seletor abriu um diálogo com botão de confirmação, confirma. `"selectConfirm"` troca a expressão do botão (padrão `^(OK|Ok|Confirmar|Concluir|Pronto|Aplicar|Done)$`).
- **"OCUPADO" no `verify`:** uma verificação anterior da mesma Task ainda está rodando, em geral de uma instância que caiu. O dev roda o mesmo comando com `-WaitBusySeconds 540`, que espera a anterior acabar e segue, sem pausar o run.

### Problemas de instalação

- **O plugin "some" na sessão.** O registro caiu em *user settings*, não no projeto: remova e refaça com `--scope project`. A forma do identificador também importa — `{"source":"github","repo":…}` e `{"source":"git","url":"….git"}` são dois identificadores para o mesmo marketplace, e misturá-los impede o resolvedor de casar o plugin com o cache.
- **Mais de um perfil de config (Windows).** Com mais de um `CLAUDE_CONFIG_DIR` (ex.: `~/.claude` e `~/.claude-pessoal`), rode **todos** os `claude plugin …` no mesmo ambiente com que você abre o Claude Code; fora dele, tudo vai para o perfil errado.
- **Instalado mas não habilita.** Confira em `plugins/installed_plugins.json` se o `projectPath` do `team@team` bate **exatamente** com o caminho que o Claude Code mostra, inclusive a caixa do drive (`C:` × `c:`). Abra o projeto sempre pelo mesmo caminho.
- **`git clone` "vermelho" no PowerShell 5.1.** O progresso sai em stderr e o PS 5.1 o mostra como erro, às vezes com exit 128, mesmo com o clone certo. Confira `$LASTEXITCODE` e os arquivos. Caminho longo: `git -c core.longpaths=true clone …`.
- **`team@team` aparece duas vezes em `claude plugin list`** — ruído de exibição, não instalação duplicada.
