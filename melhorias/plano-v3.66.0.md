# Plano da v3.66.0 — a matriz de impasses: um ponto só decide quem resolve

**Branch:** `feat/v3.66.0`, a partir de `develop` com a v3.65.15 mesclada.
**Origem:** a conferência da preparação do sprint 7 do garden (23/11, plugin 3.65.14). Foram 22 chamadas ao stakeholder, e 15 eram desnecessárias. O padrão volta a cada entrega (S5, S6 e S7): cada correção tapa um ponto, e o problema sai pelos outros.
**Status:** aprovado pelo stakeholder em 23/11:
- as **duas etapas** nesta versão;
- o registro **por trilha** (sprint ou bloco de fix), com as decisões no **kanban**;
- reuso, centralização e **design patterns** como standard do Arquiteto;
- **nomes de arquivo e identificadores em inglês** (o texto dos documentos segue em português, como o resto do plugin);
- **o sprint 7 do garden não muda**: as correções ficam no plugin.

## 0. O que a conferência achou

### A regra "quem resolve" mora em nove lugares
| Lugar | O que decide | Alcance |
|---|---|---|
| `run.ps1` (`Set-AskRoute` em 14 saídas, `$ownG` em `run.ps1:1235`, `$docOwnerRoles` em `run.ps1:360`, a escolha em `run.ps1:1347`) | causa da queda, dono do GAP, rota ao stakeholder | só no `sprint run` |
| `gate.ps1` (`Set-AskRoute` em 10 saídas, escada em `gate.ps1:600-640`) | dono do achado do portão | só no portão |
| `hooks/pre-tool.ps1` G24 (`pre-tool.ps1:143-181`) | **se** o formulário pode sair | **só na sessão do `sprint run`** (`pre-tool.ps1:146-149`) |
| `hooks/pre-tool.ps1` G3 (`pre-tool.ps1:83-127`) | **a forma** do formulário | toda sessão, mas não diz se a pergunta devia existir |
| `hooks/stop.ps1` G20 (`stop.ps1:47`, `Test-TextQuestion` em `stop.ps1:29`) | a pergunta escrita no fim do turno | só no `sprint run` |
| `templates/stakeholder-question.md` §"a decisão é dele?" | 25 linhas de casos, acumuladas da v3.58.3 à v3.65.13 | texto, sem verificação |
| `process/workflow-sprint.md` §Bloqueio (R25) | degraus 0, 1 (par PO + Arquiteto) e 2; a decisão estratégica vai direto | texto |
| `process/workflow.md` §6b | o QA roteia pelo objeto da dúvida | texto |
| `agents/task-runner.md`, `agents/product-owner.md` (triagem) | dono do 🔺 GAP; defeito, escopo ou dúvida | prompt |

O modelo certo já existe em duas peças: a rota gravada (`.ask-route`, com a G24) e a fonte única derivada e conferida (o `artifact-ownership.md` §1 gera o `hooks/ownership.json`, e o C3 do `release.ps1` confere os dois). A v3.66.0 junta as duas peças e as aplica a todo o plugin.

### As chamadas de 23/11 ao stakeholder, por causa
| Causa | Casos (horário local) |
|---|---|
| **a. licença para o próprio trabalho** (7) | "acionar a QA e abrir as F-IDs?" (10:17) · "anoto no `gaps.md`?" (10:39, 11:00) · "`fix plan` ou estimativas?" (12:05) · "faço a pergunta pelo formulário?" (13:27) · "conversa nova ou continuar?" (13:44) · "peça ao QA o SC-144" (15:18) |
| **b. já decidido ou já sabido** (6) | conferir no aparelho o que o stakeholder relatou depois de ver no aparelho (10:22) · liberar a 1.05.31, já instalada (10:05) · a seta do teclado, decidida no corte do S6 e citada pelo PO às 11:28, perguntada de novo às 11:58 · o card ativo reaberto no ③ depois do item 182 · a confirmação de F-010 e F-011, relatos dele (13:34) · GIT-01, conferível no remoto (10:56) |
| **c. decisão de outro papel** (4) | plugin de teclado (Arquiteto) · mínimo legível, altura do vizinho, letra grande (UX) · "rodar a triagem do `note.md` antes?" (roteiro do PO) · o CSV com vírgula registrado como pendência dele |
| **d. falha do plugin** (5) | apagar `architect/consolidation.md` (pedido 2×) · `npm install` negado pelo classificador · `npx cap sync` em formulário, consequência do "instalar já" · branch `feat/sprint-7` não criada por alteração pendente (`lib.ps1:3462-3466`), aviso 3× · o `kanban.md`, escrito à mão no passo 11, sem `## Série`: o `mark` falhou (`mark.ps1:179`) e a sessão estourou o contexto |
| **legítimas** (7) | limite de extras · card do Geral, que contradiz o aceite · centavos, que mudam dado gravado · escolha das baixas (pedido dele) · F-010 e F-011 no sprint (pedido dele) · sprint 0 (pergunta dele) · ③ |

Custo que não chegou ao stakeholder: 8 bloqueios da G8 viraram mais um agente cada, e a G3 recusou 16 formulários antes de saírem.

## 1. Princípios da entrega
1. **Fonte única.** A regra fica num documento, `roles/scrum-master/process/impasse-matrix.md`, e num arquivo derivado, `hooks/impasses.json`, que hooks e scripts leem. O C3 confere os dois, como já faz com o `ownership.json`. Os outros oito lugares passam a apontar para a matriz e deixam de repetir a regra.
2. **Sem duplicar o que já tem dono.** O dono de um **arquivo** continua vindo do `hooks/ownership.json`; a matriz não copia essa lista. A escada R25 continua sendo a regra dos degraus, e a matriz só diz qual tipo de impasse passa por ela.
3. **O script confere o que é verificável.** Classificar o impasse é julgamento do modelo. O script exige que o julgamento chegue estruturado (tipo, parte, assunto, o que foi consultado) e confere os fatos: a decisão já existe, a citação do stakeholder está na conversa, a rota é da matriz.
4. **Tudo à vista do stakeholder.** O que o time decidiu sozinho e o que subiu, com o motivo, aparecem no kanban da trilha. O que for mal classificado fica visível e pode ser revertido.
5. **Comportamento atual preservado onde funciona.** As rotas do run e do portão mantêm o identificador atual como apelido (`legacyRoute`), e a suíte delas tem de dar a mesma saída.

## 2. Etapa 1 — a saída para o stakeholder em todo o plugin

### A · A matriz de impasses (prioridade alta)
**Arquivos:**
- `roles/scrum-master/process/impasse-matrix.md`, a fonte;
- `hooks/impasses.json`, derivado;
- o C3 (`scripts/checks/release.ps1`) confere: tipos, donos e `legacyRoute` iguais nos dois, e todo `Set-AskRoute` dos scripts com uma rota que existe na matriz.

**Campos por tipo (em inglês):** `type`, `owner` (papel, `routine` ou `stakeholder`), `reachesStakeholder` (`never` · `afterLadder` · `direct`), `evidence` (o que o `raise` exige), `legacyRoute` (o identificador atual, quando há), `examples` (os casos que hoje estão em `stakeholder-question.md`).

**Tipos que sobem ao stakeholder:**
| `type` | `reachesStakeholder` | `evidence` exigido |
|---|---|---|
| `scope` (entra, sai ou muda o que a História entrega) | `direct`, pelo PO | a parte e o que muda |
| `stored-data` (muda valor já salvo, migração destrutiva) | `direct` | o dado afetado |
| `schedule` (muda capacidade ou data) | `direct` | a diferença em dias |
| `contradicts-acceptance` (reabre decisão aceita) | `direct` | o item da §7 ou o aceite da Review que contradiz |
| `gate` (①, ③, aceite da Review, aceite do sprint 0, ajustes do `fix plan` R33, ⚠️ como dívida) | `direct` | só por script de modo ou com `-Gate <qual>` |
| `strategic` (stack, provedor, custo, licença, ADR) | `direct` (exceção da R25) | a categoria |
| `accepted-risk` | `direct` | o risco e onde fica registrado |
| `external-action` (push, rede, publicação, dependência que nenhuma decisão cobre) | `direct` | o comando exato |
| `configuration` (`guards.json`, `models.json`: arquivos do stakeholder no `ownership.json`) | `direct` | a chave e o valor |
| `authorization` (escopo de segurança, credencial) | `direct` | o alvo |
| `plugin-update` (o `/team update`) | `direct` | as versões |
| `stakeholder-request` (ele pediu o formulário) | `direct` | a frase dele, citada; a G24 confere que ela está numa fala dele na sessão |
| `blocked` (bloqueio que o par não fechou) · `product-gap` | `afterLadder` (R25: o par PO + Arquiteto primeiro) | o resultado do degrau 1 |
| as rotas atuais do run e do portão (`environment` = `ambiente`, `environment-repeated` = `ambiente-repetido`, `stalled` = `travamento`, `starting-state` = `estado-de-partida`, `commands` = `comandos`, `target-configuration` = `configuracao-do-alvo`) | como hoje | como hoje |

**Tipos que ficam no time:**
| `type` | `owner` |
|---|---|
| `technical` (biblioteca da stack, padrão, estimativa, desenho de código) | Arquiteto. Vira `strategic` só se mudar stack, provedor, custo ou licença |
| `design` (legibilidade, altura, letra, estado de tela) | UX |
| `product-rule` (regra dentro do escopo aprovado) | PO |
| `proof` (cenário, evidência, conferência no código; **relato observado pelo stakeholder vale como evidência**) | QA |
| `board` (ordem, sequência, qual passo vem primeiro, conversa nova ou não) | SM |
| `routine` ("sigo?", "rodo a triagem antes?", "aciono a QA?", ler estado ou log) | quem perguntou: executa o passo do roteiro |
| `record` (anotar num arquivo de papel) | o dono do arquivo, lido do `ownership.json` |
| `plugin-failure` (script, modelo incompleto, permissão negada a passo do roteiro) | operator e `note.md` (item E) |

**Encadeamento:** um dono do time que conclui que a decisão muda escopo, dado, prazo ou aceite abre um impasse novo do tipo que sobe, com `-From <id>` apontando o primeiro. O kanban mostra a cadeia.

**Projeto:** `guards.json → impasses.extra` acrescenta tipos ou exemplos, mas não tira nenhum tipo que sobe.

**Testes:** C3 com os dois arquivos iguais (ok) · um tipo só num deles (falha) · um `Set-AskRoute` com rota fora da matriz (falha) · `impasses.extra` que tenta mudar `reachesStakeholder` de um tipo que sobe (recusado).

### B · `impasse.ps1`: quem trava declara, o script roteia (prioridade alta)
**Arquivo:** `scripts/checks/impasse.ps1`, com o núcleo em `lib.ps1` (`Register-Impasse`, `Resolve-ImpasseOwner`, `Get-ImpasseTrail`, `Find-ImpasseDecision`), para a etapa 2 reaproveitar.

**`raise -Type <t> -Part <H-Z|T-098|F-010|S7> -Subject <key> -Origin <role or mode> -Consulted "<§7 N | D-k | none>" -Text "<the impasse in one sentence>" [-NewFact "<…>"] [-From <id>] [-Distinct "<why it differs>"] [-Quote "<stakeholder words>"] [-Gate <①|③|review|sprint0|fix-adjust>]`**
- **Assunto já decidido:** procura decisão resolvida para a mesma `-Part`, na §7 do README (marca `{subject: <key>}`, nova) e no `team-decisions.jsonl` da trilha. Com o mesmo `-Subject` e sem `-NewFact`, **recusa** e imprime a decisão: "já decidido em §7 187: aplique".
- **Assunto parecido:** imprime os assuntos já decididos da mesma `-Part`. Um `-Subject` novo para uma parte que já tem decisões exige `-Distinct`, que fica gravado. Isso evita fugir do "já decidido" trocando a palavra.
- **Evidência:** confere a de cada tipo da tabela A e recusa o tipo que sobe sem ela.
- **Tipo do time:** imprime a linha `Agent` do dono, no mesmo formato do `Get-AgentLine` do `run.ps1`, e grava o impasse. Não grava rota.
- **Tipo que sobe:**
  - grava a `.ask-route` pelo `Set-AskRoute` de hoje (`lib.ps1:1587`), com `plain` (o texto simples);
  - com Identificador remoto, já grava a pendência dentro da §7, com o prefixo R34 (item J).
- **Relato do stakeholder:** com `-Origin note.md` ou `-Quote`, o impasse `proof` leva a linha "observado pelo stakeholder: vale como evidência". A QA não pede que ele confira de novo.

**`close -Id <n> -Ref "<file>#<anchor>" [-Allow "<command>"]`**
- Liga o impasse ao lugar onde o dono gravou a decisão.
- `-Allow` grava no `commands-asked.json → allowed` da trilha os comandos que a decisão implica (item E).

**`owner -Path <file>`:** o dono do arquivo pelo `ownership.json`, com a linha `Agent` pronta (item I).

**Roteiros:** o trecho "Onde parar" do `/sm`, do `/po`, do `/ux`, do `/arc`, do `/qa`, do `/team` e dos agentes passa a dizer "impasse → `impasse.ps1 raise`; nunca pergunta direta ao stakeholder".

**Permissão:** o `impasse.ps1` entra no que a G14 libera aos papéis (os papéis chamam `raise` e `owner`).

**Testes:**
- cada tipo leva ao dono certo;
- assunto decidido sem fato novo (recusa) · com fato novo (sobe);
- assunto novo numa parte com decisões, sem `-Distinct` (recusa);
- tipo que sobe sem evidência (recusa);
- relato do stakeholder em `proof`;
- `close` com `-Ref` e com `-Allow`;
- `owner` para três caminhos;
- papel chamando o `raise` (a G14 libera).

### C · A G24 vale para toda sessão (prioridade alta)
**Proposta:** (`hooks/pre-tool.ps1` `Test-G24`)
- Sai a condição "só a sessão do `sprint run`" (`pre-tool.ps1:146-149`). Todo `AskUserQuestion` da sessão principal exige uma `.ask-route` válida, gravada pelo `impasse.ps1`, pelo `run.ps1` ou pelo `gate.ps1`.
- A regra "uma rota, um formulário, com refação em 10 min" fica igual (v3.60.1).
- A `stakeholder-request` só passa se a `-Quote` aparecer numa fala do stakeholder no transcrito da sessão (`transcript_path` do hook).
- Ficam de fora a G18 (benchmark) e o clone-fonte do plugin (`Test-PluginSource`).
- A recusa diz o tipo provável e o dono, lidos da matriz, no lugar da lista fixa de hoje (`pre-tool.ps1:176-180`).
- **Inventário antes de ligar:** todo formulário legítimo que os roteiros mandam abrir (são 52 arquivos que citam formulário) recebe o tipo dele, e um teste por modo garante que passa: `/team update`, onboarding, brainstorm, SDD ①, sprint 0, prepare, ③, Review, close (propostas de configuração), `fix plan` (R33), `/sec` (escopo), `/ux` (navegação do protótipo).

**Testes:** pergunta no prepare sem rota (recusa) · com rota `scope` (passa) · `stakeholder-request` com citação presente (passa) e ausente (recusa) · um teste por modo do inventário (passa) · bench e clone-fonte (passa).

### D · G26: o fim de turno sem "Quer que eu…?" (prioridade alta)
**Proposta:** (`hooks/stop.ps1`; guarda nova, porque a G20 é a do run e a G25 já existe)
- Na sessão principal **fora** do `sprint run` (dentro dele, a G20 já cobre), o turno que termina oferecendo uma ação ("Quer que eu…", "Posso…", "Me diga se quer…", "Prefere que eu…", "Sigo com…?") sem rota gravada nos últimos 15 min é barrado. A mensagem: "é passo do roteiro: execute pelo dono (`impasse.ps1 raise` diz quem) e informe".
- As frases ficam em `hooks/impasses.json → offerPhrases`, e não no código.
- **Passa:**
  - a resposta a uma pergunta direta do stakeholder, sem oferta de ação;
  - o turno com rota gravada (a pergunta vai em formulário);
  - o `/clear` pedido pelo roteiro (teto de contexto).
- **Modo de adoção:** `guards.json → impasses.offerGuard: "warn" | "enforce"`, padrão **`warn`** na v3.66.0. Só registra no `guards.log` e conta no `/team-usage`. Passa a `enforce` depois de medir o falso positivo em campo, porque a heurística é de texto.
- Em `enforce`, a 3ª tentativa em 10 min passa e registra, como a G20 (`stop.ps1:50-57`).

**Testes:** as seis frases de 23/11 (barra em `enforce`, registra em `warn`) · a resposta ao "Qual o próximo passo?" sem oferta (passa) · rota gravada (passa) · dentro do run (é da G20) · 3ª tentativa (passa).

### E · As falhas do plugin não viram pergunta (prioridade alta)
- **Comando implicado por decisão:**
  - Na ficha da Task, o Arquiteto declara **Comandos implicados:**, como o `npm install @capacitor/keyboard@^8` e o `npx cap sync`.
  - Quando o stakeholder aprova a opção que traz esses comandos, o `impasse.ps1 close -Allow` os grava no `commands-asked.json` da trilha.
  - O `run.ps1` (`run.ps1:998`) não abre a rota `commands` para comando já liberado.
- **Permissão negada a um passo do roteiro** (classificador ou `permissions` do Claude Code; o classificador não é do plugin):
  - impasse `plugin-failure`, com uma linha em `note.md` como ocorrência de plugin;
  - sobe ao stakeholder **uma vez por sessão**, como `external-action`, com o comando exato e o motivo em palavras simples;
  - não se repete.
- **Apagar o que o roteiro manda:** `knowledge.ps1 -Consolidated` (switch novo) apaga `architect/consolidation.md`, que o próprio `knowledge.ps1:288` cria. A consolidação do Arquiteto termina com ele, e o roteiro deixa de pedir que alguém apague à mão.
- **Branch do run com alteração pendente** (`Invoke-GitBegin`, `lib.ps1:3462-3466`):
  - Em vez de desistir, tenta o `git switch` levando as alterações. O próprio git recusa quando um arquivo pendente difere entre a branch atual e a base, e nada se perde.
  - Só com a recusa do git fica o comportamento de hoje.
  - O aviso sai **uma vez por run**, para o SM, e não ao stakeholder.
- **O kanban do sprint sai gerado:**
  - O passo 11 do `sprint plan` deixa de escrever o `kanban.md` à mão e passa a chamar `kanban.ps1 -Sprint <n> -Init`. Isso reaproveita o `-Init` que o bloco de fix já tem (`kanban.ps1:18`), com a linha 0 da Série, o Registro, o Controle e a seção do item F.
  - O `run.ps1 next` recusa partir com o kanban sem `## Série`, com uma mensagem que diz o comando, no lugar da falha do `mark`.

**Testes:**
- comandos implicados: liberados pelo `close -Allow`, sem rota `commands`;
- permissão negada 2× na mesma sessão: uma pergunta só;
- `-Consolidated`: apaga o arquivo;
- branch: com arquivo pendente igual nas duas pontas (troca, levando a alteração) · com conflito (não troca, um aviso só);
- kanban: `-Sprint <n> -Init` com a Série, o Registro e a seção F · `next` com o kanban sem Série (recusa com o comando).

### F · As decisões do time, por trilha, no kanban (pedido do stakeholder, 23/11)
- **Matriz e registro separados.** A matriz (item A) é só a regra geral do plugin. Cada caso vai ao `team-decisions.jsonl` da trilha em que aconteceu:
  - sprint aberto: `sprints/<n>/team-decisions.jsonl`;
  - bloco de fix aberto: `fixes/B-<nnn>/team-decisions.jsonl`;
  - fora dos dois (prepare, plan, triagem do `note.md`): o sprint em preparação, `sprints/<n+1>/team-decisions.jsonl`. A Planning herda.

  A regra fica em `Get-ImpasseTrail`, que lê o `.active-run`, o "Sprint corrente" do README §2 e o bloco aberto. O número corrente vem do README, e os scripts que listam pastas de sprint (`project.ps1:114`, `fix.ps1:283`) só olham sprint fechado ou arquivos que essa pasta não tem. Um teste garante que a pasta `n+1` só com esse arquivo não abre nem fecha nada.
- **A linha (campos em inglês):** `id`, `at`, `origin`, `type`, `part`, `subject`, `owner`, `result` (`team-resolved` · `escalated` · `refused-already-decided`), `summary` (a frase simples em português, para quem acompanha), `ref`, `from`.
- **A decisão em si** fica no lugar do dono, como hoje (resposta técnica do Arquiteto, spec do UX, História ou backlog do PO, cenário da QA). O `.jsonl` é o índice.
- **No kanban, onde o stakeholder acompanha:**
  - A seção **"Decisões do time"** fica no `## Controle` do `kanban.md` do sprint e na variante do bloco de fix.
  - É **gerada** pelo `kanban.ps1` a partir do `.jsonl`, regravando só essa seção, como o `Write-NowSection` faz com o `## Agora`, a cada `raise` e `close`. Não se edita à mão, e a G8 não barra o script.
  - Colunas: Quando · O que foi decidido · Quem decidiu · Por que não precisou de você · Onde está.
  - A coluna "Por que não precisou de você" traz o tipo em palavras: "decisão técnica", "desenho de tela", "já decidido em 23/11". As linhas que subiram dizem por que subiram ("muda o que já está gravado").
  - Linguagem de quem acompanha, regra v3.59.0: o código da parte vai no fim, entre parênteses.
  - O `## Resumo` ganha a linha "o time decidiu N coisas sozinho; M subiram a você".
  - O `-Init` da Planning traz as linhas herdadas do prepare.
- **Na Review e no fechamento do fix:** a seção "Decidido pelo time sem você" sai do mesmo `.jsonl`. Qualquer linha pode ser revertida, e a reversão vira `contradicts-acceptance` com `-From`.
- **No `/team-status`:** a contagem do Resumo. **No `/team-usage`:** impasses por tipo, os que subiram, as recusas por "já decidido" e as recusas da G3, para medir a meta.
- **Dono do arquivo:** o `team-decisions.jsonl` entra no `artifact-ownership.md` §1 e no `ownership.json` como escrito só pelo script.

**Testes:**
- onde gravar: sprint aberto · bloco aberto · prepare (vai a `n+1`, o README segue no sprint corrente, nenhum script trata a pasta como aberta);
- o kanban: a seção regravada sem tocar o resto do Controle · a frase sem jargão · o Resumo com a contagem · o `-Init` com as linhas herdadas · a variante do fix com a seção;
- a Review e a reversão: a seção da Review a partir de um `.jsonl` de exemplo · a reversão com `-From`;
- o C3 com o dono novo.

## 3. Etapa 2 — o run, o portão, o executor e a triagem na mesma matriz

### G · `run.ps1` e `gate.ps1` leem a matriz (prioridade média)
- Os mapas fixos (`$ownG` em `run.ps1:1235`, `$docOwnerRoles` em `run.ps1:360`, a escolha em `run.ps1:1347`, os ramos em `gate.ps1:600-640`) passam a chamar `Resolve-ImpasseOwner`.
- Cada `Set-AskRoute` do run e do portão passa por `Register-Impasse`. Ganha a linha no `team-decisions.jsonl` da trilha e a recusa por assunto já decidido.
- O identificador da rota gravado na `.ask-route` continua o atual (`legacyRoute`), para a G24, o `plain.ps1:283` e os testes.
- **Sem mudar comportamento:** a suíte do run e do portão tem de dar a mesma saída antes e depois. A migração só troca a origem da regra.

**Testes:** a suíte completa sem diferença de saída · um teste por rota conferindo a linha no `.jsonl`.

### H · O executor de Task e a triagem do PO usam o `raise` (prioridade média)
- **`agents/task-runner.md`:** o 🔺 GAP é levado pelo `impasse.ps1 raise -Origin task-runner`. A G7 recusa ao executor o `Agent` de um papel diferente do que o `raise` devolveu na mesma rodada.
- **`agents/product-owner.md`, na triagem:** defeito vai a `proof` (QA, depois F-ID); mudança de escopo vai a `scope` (sobe); dúvida de uso vai a `product-rule` (o PO responde).
- **`workflow.md` §6b, `workflow-sprint.md` §Bloqueio (R25) e `stakeholder-question.md` §"a decisão é dele?":**
  - A tabela de 25 linhas sai do template. Cada linha vira exemplo do tipo dela no `impasse-matrix.md`.
  - O template fica com a forma (R22, H1) e aponta a matriz.
  - O R25 e o §6b citam a matriz, sem repetir a lista.

**Testes:** GAP técnico ao Arquiteto pelo `raise` · o executor tentando o PO para GAP técnico (G7 recusa) · triagem de um defeito (QA, sem subir) · as 25 linhas presentes como exemplos na matriz (C3).

### I · A G8 diz o dono antes do bloqueio (prioridade baixa, barato)
A mensagem da G8 passa a trazer a linha `Agent` do dono, pelo `impasse.ps1 owner`, que lê o mesmo `ownership.json` da G8. Os roteiros mandam consultar o `owner` antes de disparar um papel para escrever. Meta: dos 8 redisparos de 23/11, no máximo 1 por preparação.

**Testes:** `owner` para `sprints/<n>/stories/` (PO), `architect/breakdown/` (Arquiteto) e `sprints/<n>/sprint-backlog.md` (SM) · a mensagem da G8 com a linha.

### J · O formulário passa na G3 de primeira (prioridade baixa)
O `raise` de um tipo que sobe grava a pendência **dentro** da §7, com o prefixo R34 e a data e hora, e devolve o texto simples pronto. Em 23/11 as pendências caíram depois da §8, e a G3 recusou 4 vezes. A G3 continua conferindo como hoje. Meta: no máximo 2 recusas por preparação, contra 16.

**Testes:** `raise` com Identificador remoto grava dentro da §7 · o formulário montado da rota passa na G3.

## 4. Reuso, centralização e design patterns no standard do Arquiteto (aprovado em 23/11)

### K · O standard e o plano dizem o que se reaproveita e qual padrão se usa
**Hoje:**
- O princípio existe ("desenhar dentro do padrão existente… preferir estender a criar paralelo novo", `roles/architect/README.md:32`).
- A resposta técnica cita o arquivo-modelo (`technical-decision.md:21`).
- O `skills.md:10` confere os registros de infraestrutura análogos.
- A linha 8 do Quadro de Verificação (V9, `quality.ps1` Q8) mede a duplicação **depois**, no código.

**Falta:** o modelo do plano (`implementation-plan.md` §1 a §12) não pede o reuso, o `plan.ps1` não confere, e a quebra do sprint não procura o que as Tasks compartilham. No S7, a F-010 pede "a lua do semeio igual à do Geral", e nada obriga o plano a dizer se reaproveita o componente do Geral ou cria outro.

**O standard** (`standards/implementation-principles.md`, nível 1, sem produto nem stack; títulos e marcadores em inglês, texto em português):
- **§4.6 Reuse, componentization and centralization.** Entra no §4 para não renumerar o §5 ao §8, que o plugin cita.
  - procurar antes de criar: o plano cita a busca feita;
  - estender antes de duplicar;
  - a mesma regra de negócio, o mesmo cálculo ou a mesma decisão tem **um lugar só** (policy, domain service, tabela de configuração, componente compartilhado), e os outros pontos chamam esse lugar;
  - a peça usada por duas ou mais telas ou casos de uso vira componente ou serviço compartilhado, na camada certa do §2;
  - o que varia por projeto ou ambiente vira configuração, não ramo de código.
- **§4.7 Design patterns.**
  - O padrão vem do problema: o plano nomeia o padrão, o problema que ele resolve ali e a alternativa mais simples que foi descartada.
  - Catálogo curto, com os nomes em inglês:
    - **Strategy** ou tabela de regras, para comportamento que varia por tipo;
    - **Adapter** ou **Port**, para integração externa (o anel de infraestrutura do §2);
    - **Factory**, para construção com variação;
    - **Observer** ou **Mediator**, para reagir a evento sem acoplar;
    - **Template Method** ou composição, para fluxo comum com passos variáveis;
    - **Repository**, que o §2 já tem.
  - O que **não** se faz: padrão sem problema presente (camada, interface ou fábrica "para o futuro"), herança só para reaproveitar código, **Singleton** com estado.
- **§4.5** ganha a linha: "abstração especulativa não é reuso".
- **§7 Quadro de Verificação** ganha a linha "reuse and patterns declared in the plan": verificada pelo `plan.ps1`, com a revisão de aderência do QA, e bloqueia a construção.
- **Perfis de stack** (`standards/stacks/<stack>/guide.md`), com um exemplo cada, não normativo:
  - **angular** e **ionic-capacitor:** componente standalone compartilhado, pipe, serviço `providedIn: 'root'`, estilo no tema global em vez de SCSS copiado por tela;
  - **react:** hook e componente compartilhados;
  - **dotnet:** domain policy, pipeline behavior do mediator;
  - **kotlin-android:** use case e composable compartilhado.
- **`roles/architect/README.md:32`** aponta o §4.6 e o §4.7 como régua. **`roles/architect/skills.md`** ganha a competência "achar o que já existe e escolher o padrão pelo problema", com o "como se verifica" apontando o §2a do plano.

**O plano, a quebra e a QA** (marcadores em inglês):
- **`implementation-plan.md`, seção nova "§2a Reuse and patterns"**, obrigatória no plano pleno (a variante leve fica de fora):
  - cada peça nova de código (componente, serviço, helper, estilo) tem uma linha `reuses: <file>`, `extends: <file>` ou `new: <why nothing existing fits>`;
  - cada padrão usado tem `pattern: <Name> — <problem> — <simpler alternative rejected>`;
  - o `plan.ps1` recusa o plano pleno sem a seção, com `new:` sem motivo ou com `pattern:` sem o problema.
- **`breakdown.md`, linha nova `**Shared parts:**`.** O Arquiteto lista as peças que duas ou mais Tasks do sprint tocam igual e em qual Task cada uma nasce. As outras Tasks citam `reuses:` com a Task de origem.
- **QA (aderência, frente 2):** confere `reuses:` e `extends:` contra o diff. Código novo onde o plano dizia `reuses:` é achado. A V9 segue como a medida final.

**Testes:** plano pleno sem §2a (recusa) · `new:` sem motivo (recusa) · `pattern:` sem o problema (recusa) · leve sem §2a (passa) · `Shared parts` citada por duas Tasks · os links para §4.6 e §4.7 resolvem · nenhuma citação a §5–§8 quebrada.

## 5. Riscos e como a entrega os trata
| Risco | Tratamento |
|---|---|
| a sessão declara um tipo que sobe para fugir da matriz | evidência por tipo (A); `stakeholder-request` só com a citação presente no transcrito (C); toda subida aparece no kanban com o motivo (F) |
| o mesmo assunto com outro nome escapa do "já decidido" | `-Part` obrigatório e a lista de assuntos da parte; assunto novo exige `-Distinct`, que fica gravado (B) |
| a G24 em toda sessão barra um formulário legítimo | o inventário dos modos e um teste por modo, antes de ligar (C) |
| falso positivo da heurística de texto da G26 | `warn` como padrão nesta versão, medido no `guards.log` e no `/team-usage`; `enforce` depois do campo (D) |
| a migração da etapa 2 muda o comportamento do run e do portão | `legacyRoute` e a suíte com a mesma saída antes e depois (G) |
| a regra volta a se espalhar em texto | o C3 confere a matriz, as rotas dos scripts e os exemplos; o template e os processos só apontam (A, H) |
| custo | o `raise`, o `close` e a regravação do kanban são scripts, sem modelo; o ganho esperado são menos formulários, menos recusas da G3 e menos redisparos da G8 |

## 6. Fora desta entrega
- O sprint 7 do garden não muda: segue na 3.65.14 até fechar, por decisão do stakeholder.
- A forma da G3 (R22, H1, jargão) fica como está; muda só o J.
- O classificador de permissões do Claude Code não é do plugin; o E garante uma pergunta só, com o comando exato.
- Renomear para inglês os identificadores atuais das rotas (`ambiente`, `travamento`…) fica para depois; nesta versão eles são `legacyRoute`.

## 7. Entrega
- **Ordem:** A, B, C, D, E, F (etapa 1); G, H, I, J (etapa 2); K. Dentro do K: o standard, o modelo do plano, o `plan.ps1`, a quebra e a QA.
- **Regras e guardas:**
  - regra nova **R36** ("impasse vai ao dono da matriz; ao stakeholder só os tipos que sobem"), no `working-rules.md` e no índice;
  - a G24 estendida e a **G26** nova no `hooks/COVERAGE.md` e na linha de guardas do SessionStart;
  - o `artifact-ownership.md` §1 e o `ownership.json` com o `impasse-matrix.md`, o `impasses.json` e o `team-decisions.jsonl`.
- **Suítes:** `run-all-tests.ps1` completa, com o C3; casos marcados `v3.66.0` em `run-check-tests.ps1` e `run-guard-tests.ps1`; na etapa 2, a suíte do run e do portão comparada antes e depois.
- **Medição em campo**, no próximo prepare e plan de um projeto piloto. A conta vem do `team-decisions.jsonl` e do `guards.log`:
  - no máximo 1 chamada desnecessária ao stakeholder;
  - no máximo 2 recusas da G3;
  - no máximo 1 redisparo por G8;
  - o falso positivo da G26 em `warn` medido, para decidir o `enforce`.
- **Documentação:** CHANGELOG e `process-changelog.md` com a origem (§0) e a classificação; `how-to.md` com a seção "Decisões do time" do kanban.
- Commit e PR só a pedido.
