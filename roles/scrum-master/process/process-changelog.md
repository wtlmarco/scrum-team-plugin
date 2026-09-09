# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
| [`v3.1`](process-changelog-archive.md) | Protótipo funcional em HTML vira entregável e pré-condição do portão ①; o Sprint Backlog ganha o próprio nome — 08/09/2026 |
| [`v3.0`](process-changelog-archive.md) | Redesenho do modelo de trabalho: História e Task, sprint como caixa de tempo, aceite na Sprint Review — 08/09/2026 |
| [`v2.11`](process-changelog-archive.md) | Guias de raiz ganham dono; roteiro de instalação endurecido; R19 passa a exigir checagem semântica — 07/09/2026 |
| [`v2.10`](process-changelog-archive.md) | Reavaliação do conjunto: caminho de escrita do `/review`, contagem de regras e modo `note` reconciliados — 07/09/2026 |
| [`v2.9`](process-changelog-archive.md) | Processo de atualização e lançamento do plugin ganha documento e dono — 06/09/2026 |
| [`v2.8`](process-changelog-archive.md) | Evolução do processo num comando só: `/review`, guardado ao repositório-fonte, com `note.md` como fila — 06/09/2026 |
| [`v2.7`](process-changelog-archive.md) | Faxina pós-isolamento em plugin: resíduo de caminho, contagens do UX e extração dos modos frios — 06/09/2026 |
| [`v2.6`](process-changelog-archive.md) | QA frente 2 ganha a redação final: objeto próprio e o terceiro achado de processo — 06/09/2026 |
| [`v2.5`](process-changelog-archive.md) | Obsolescência corrigida nos documentos do Arquiteto: comply sob demanda e Ficha até V21 — 06/09/2026 |
| [`v2.4`](process-changelog-archive.md) | Aderência ao plano × aderência ao standard: `/arc comply` e a frente 2 do QA verificam objetos diferentes — 06/09/2026 |
| [`v2.3`](process-changelog-archive.md) | PO ganha a forma completa do RNF de performance e a cadeia RNF → V18 → veredito — 06/09/2026 |
| [`v2.2`](process-changelog-archive.md) | QA alinhado a R16 e ganha a frente de desempenho; veredito endereçado ao stakeholder — 06/09/2026 |
| [`v2.1`](process-changelog-archive.md) | PERF-TEST fechada: desempenho vira obrigação verificável nos dois níveis do `standards/` — 06/09/2026 |
| [`v2.0`](process-changelog-archive.md) | Changelog arquivado, contrato do `review` extraído, ciclo de eficiência PDCA e teto por entrada (R17) — 06/09/2026 |
| [`v1.9`](process-changelog-archive.md) | Arquiteto e dev revistos à luz de `.team/standards/` como base compartilhada; GAP de tipo `standard` ganha forma — 05/09/2026 |
| [`v1.8`](process-changelog-archive.md) | `standards/` promovido a diretório de primeiro nível e reclassificado como base de qualidade compartilhada (R16) — 05/09/2026 |
| [`v1.7`](process-changelog-archive.md) | Onboarding do projeto (R14) e brainstorm de descoberta funcional (R15) — 05/09/2026 |
| [`v1.6`](process-changelog-archive.md) | UX com repertório de padrões consolidados e método de pesquisa acionável por gatilho — 02/09/2026 |
| [`v1.5`](process-changelog-archive.md) | SM com repertório de PMBOK e APF acionável por gatilho, sobre a base Scrum — 02/09/2026 |
| [`v1.4`](process-changelog-archive.md) | Standards em dois níveis: princípios agnósticos de linguagem (Clean Architecture · Clean Code · CQRS · cobertura 80%) — 02/09/2026 |
| [`v1.3`](process-changelog-archive.md) | Reavaliação obrigatória no `review`, e os documentos do dev passam ao Arquiteto — 02/09/2026 |
| [`v1.2`](process-changelog-archive.md) | Evolução do processo distribuída por papel — 02/09/2026 |
| [`v1.1`](process-changelog-archive.md) | Comando de evolução do processo — 02/09/2026 · *(substituída pela v1.2)* |
| [`v1.0`](process-changelog-archive.md) | Linha de base do time — 01–02/09/2026 |

---

## v3.4 — Substantivo homônimo em lista de proibição: a régua, as cinco correções e o fecho do `/review note` — 09/09/2026

**Instrução (1):** *(stakeholder, após triagem de `note.md` — Tasks 2, 3 e 4 fundidos)* "Escreva em `artifact-ownership.md` a nota de nomenclatura que fecha o círculo: quando um substantivo nomeia **dois artefatos de donos diferentes** (o caso `status`: executivo ao stakeholder = PO, documento de progresso = SM), toda menção em lista de proibição precisa **qualificar qual** e **nomear o dono** — porque proibição curta num papel cujo modo tem o mesmo nome derruba o modo. Cite o padrão que já funciona como forma a copiar. Deixe a nota utilizável como critério de verificação."

**Instrução (2), fecho do `/review note`:** curadoria das cinco correções · registrar `team-version.md` na matriz · corrigir a sobra da v3.3 no §5c, onde a mesma seção declara o `consult` extinto e sete linhas abaixo instrui a partir dele.

**Classificação:** propriedade de artefato (nomenclatura da fronteira entre artefatos homônimos; dono de guia de raiz) + escopo de papel (as cinco linhas de fronteira corrigidas) + obsolescência (§5c).

**Como esta mudança entrou — desvio de roteamento.** A triagem roteou as três fichas aos agentes donos (PO, QA e Arquiteto-pelo-dev); **os três caíram por limite de sessão e a sessão principal aplicou as três**, seguindo §1b, mais os dois cards autorizados pelo stakeholder. As fichas mudaram **sem passar pelo dono e sem entrada de changelog própria** — esta entrada as absorve, depois de o SM conferi-las por leitura. **Não vira precedente:** o atalho existiu porque o sintoma estava aberto em campo e a régua já estava escrita. Fica registrado porque quem ler o diff daqui a seis meses veria três papéis "concordando" com uma correção que nenhum deles escreveu.

**Curadoria:** as cinco linhas passaram nos três passos de §1b — qualificador **e** dono em 5/5, artefato próprio preservado na mesma linha em 3/5 (nos dois cards, em outra seção). Detalhe por arquivo no bloco de evidência. **O que a curadoria devolveu à régua:** o caso do QA mostrou que o substantivo cru é só metade do defeito — *"a especificação"* não diz se o vedado é **escrever** ou também **validar contra**, e validar contra é a frente 2 do papel. §1b ganhou o **verbo** como terceiro elemento da forma completa.

### O que mudou

| Documento | Seção | Mudança |
|---|---|---|
| `process/artifact-ownership.md` | **§1b nova** | *Substantivo homônimo — como se escreve uma proibição sem derrubar um modo.* Os 4 homônimos vivos (`status`, `especificação`, `protótipo`, `documentação`), a forma obrigatória (**qualificador + dono + verbo**, nunca o substantivo cru), por que a lista de proibição vence a linha que concede, e os **3 passos de verificação** do SM |
| | §3 · matriz | Conflito novo (*papel recusa o próprio modo citando "Não faz"*); a linha do documento de status passa a apontar o homônimo do PO e §1b; **`team-version.md` registrado** entre os guias de raiz, ao lado de `team-init`/`team-update`, que já estavam — dono stakeholder |
| 3 fichas + 2 cards | "Não faz" / "Proibido" | `status` (PO), `especificação` (QA) e `documentação` (dev) deixam de aparecer cruas, nas fichas e nos dois cards que carregam no subagente. **Aplicadas pela sessão principal, não pelos donos** — ver o desvio acima |
| `process/workflow.md` | §5c | **Sobra da v3.3 removida:** a seção declarava o `consult` extinto e, 7 linhas abaixo, instruía a partir dele com uma economia de "~38 KB" medida contra o broadcast que já não existe. A lição de R3 foi reancorada no **passo 1 do `/sm agreement`**, e ficou **sem número fechado** porque a tabela não sustenta o delta — ela soma `commands/` + `agents/`, e o `agreement` só acrescenta `agents/` |
| | §5c, custo | **Remedido:** `/sm` 13 → **15**, `/po` 10 → **13**, `/team cycle` 28 → **26**, `/review` 14 → **15**. Nota nova: os números somam `commands/` + `agents/`, e remedir é fase **Check** |

**Modo de falha que evita:** um papel recusar o modo que a própria ficha lhe dá, e devolver ao stakeholder um comando extinto. Em campo: `/po status` numa instalação v3.3.0 entregou a leitura de produto e **em seguida se desautorizou**, dizendo que status "é tipicamente papel do Scrum Master" e oferecendo um `/sm status` que a v3.3 havia removido. Instalação e contexto do projeto foram descartados como causa; era a palavra `status` **crua** na lista "Não faz" do PO, quatro linhas abaixo da que lhe dá "prazo, plano de entrega e status". A lista curta venceu a tabela, com o prior de Scrum empurrando junto.

### Quem passa a ser cobrado de forma diferente

| Papel | O que muda para ele |
|---|---|
| **SM** | Passo de verificação novo na reavaliação do `/review`: cruzar "Não faz" × modos declarados, papel a papel, **por leitura** — `grep` não distingue uso qualificado de uso cru |
| **PO · QA · dev** | Nenhuma conduta muda **exceto deixar de recusar o próprio modo**: o PO responde `/po status` sem se desautorizar, o QA mantém a frente 2, o dev entrega relatório e GAP |
| **Arquiteto · stakeholder** | Herdam o roteamento do §7 do dev (abaixo), cada um no seu arquivo |

### Roteamentos abertos

`Documentação não é minha/sua` continua cru no **Contrato §7** do dev — `roles/developer/README.md:28` (dono: **Arquiteto**) e `agents/developer.md:32` (dono: **stakeholder**). Está **fora** da superfície que §1b verifica e a frase seguinte preserva a exceção (*"Minha entrega é código, testes e o relatório"*), mas ficou em forma inconsistente com a linha 15, agora qualificada. É conteúdo do papel, não coerência de referência: **o SM roteia, não reescreve**.

### Conflitos com o processo vigente

**A régua poderia virar R22** em `working-rules.md` — R1–R21 governam como o time trabalha **num projeto**, e esta governa como os normativos do plugin são redigidos. **Escalado e decidido pelo stakeholder:** fica em `artifact-ownership.md`; regra que não se verifica numa Task não entra na lista percorrida a cada Task fechada. Precedente de forma: §1a, que R17 já nomeia como o lugar da "nota de racional no próprio documento normativo que ela governa".

### Como saberemos que funcionou

Zero ocorrências, nas próximas três versões, de papel recusando modo próprio ou oferecendo comando extinto. Verificável já no `/review` seguinte: o cruzamento "Não faz" × modos fecha **limpo nos seis papéis** — na abertura eram 3 sujos (PO, QA, dev), no fecho são 6 limpos na superfície verificada, com 2 resíduos roteados fora dela. O teste real é o próximo `/po status` em campo: entrega a leitura e **para**.

### Evidência (R19)

| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| Arquivamento | `Compare-Object` bloco `## v3.1` × `git show HEAD:` | 55 linhas, **0 diferenças**; arquivo 1244 → 1301; índice ganhou `v3.1` | ✅ |
| Extração / criação | `git show HEAD:…/artifact-ownership.md` × disco | **112 → 145 linhas**; §1b em 57–87; conflito novo em §3 | ✅ ¹ |
| Checagem semântica | leitura dos 4 homônimos de §1b na origem | os 4 conferem: `status` · `especificação` · `protótipo` · `documentação` | ✅ |
| Forma a copiar | leitura da linha "Não faz" de `roles/scrum-master/README.md` | *"…nem status **ao stakeholder** — é do PO (§6a)"*: qualificador + dono | ✅ |
| Teto de leitura | `^## v` no changelog quente | 3 entradas — v3.4, v3.3, v3.2 | ✅ |
| Curadoria das 5 correções | leitura contra os 3 passos de §1b (**não `grep`**) | 5/5 qualificador + dono; 3/5 preservam o próprio na mesma linha; 1 defeito de **verbo** → virou régua em §1b | ✅ |
| Resíduo do defeito | leitura de `Documentação não é (minha\|sua)` | 2 cruas: `roles/developer/README.md:28`, `agents/developer.md:32` — fora da superfície de §1b | ✅ roteado |
| Obsolescência §5c | `consult` em `workflow.md` | 2 na seção: `:245` declara a remoção, `:252` cita a origem histórica. Nenhuma instrui no presente | ✅ |
| Substituição do número | `38 KB` em `process/*.md` | 1, nesta entrada, citando o número errado como defeito. Zero no normativo | ✅ |
| Remedição do custo | `.Length` de `agents/*` + `commands/*` | sm 15,1 · po 13,0 · ux 10,7 · arc 9,7 · qa 9,8 · dev 6,9 KB — `/sm` e `/po` errados | ✅ |
| Guia sem dono | `team-version` na matriz + `Test-Path` | linha 41, com `team-init`/`team-update` que **já estavam**; arquivo existe | ✅ |
| Links | `](*.md)` nos 5 arquivos tocados | 2 achados, ambos **falsos positivos** (notação em crase). Reais: **0** | ✅ |
| **R17 — teto da entrada** | contagem do bloco `## v3.4` | **13,7 KB na 1ª medição — acima da barreira de 10 KB.** Excedente movido (curadoria detalhada → evidência; análise da régua → §1b); remedido | ✅ ² |

¹ Desvio: escrevi "113 → 148" antes de contar; o real era 112 → 145. Contagem estimada não é evidência.
² A própria R17 reprovou esta entrada, duas vezes. O corte seguiu o critério dela: sai o raciocínio de uma vez, fica o registro permanente, e a análise que precisava sobreviver foi para §1b — o normativo que ela governa.

### Pendente do stakeholder

- **`agents/developer.md:32`** — o último `Documentação não é sua` cru, agora fora de forma com a ficha corrigida. Roteado acima.
- **`/team version`** (Task 1 de `note.md`) — reenquadrado por ele como **modo meta**, ao lado de `init` e `update`, e por isso sem colisão com a linha 10 de `commands/team.md`, que proíbe conversa. `commands/team.md` e `team-version.md` foram aplicados por ele; o que coube a mim foi **registrar o dono na matriz**, feito.
- **Reiniciar a sessão** — `agents/product-owner.md` e `agents/quality-assurance.md` mudaram, e comportamento de agente só entra em vigor depois.
- **Entrega:** esta versão de processo ainda não chegou a instalação nenhuma. `git commit` + `push` + `claude plugin marketplace update team` + `claude plugin update team@team` (R18). O sintoma de campo que abriu a v3.4 **continua vivo na instalação do cliente** até esse passo.

---

## v3.3 — O canal do stakeholder é o PO; o broadcast acaba; prazo, plano e status mudam de dono — 08/09/2026

**Instrução:** *(stakeholder, direta)* "podemos remover o comando `/team <mensagem>` pois eu como stakeholder devo me relacionar com o PO prioritariamente pois ele controla as minhas demandas, mas posso levar questões ao Arquiteto ou UX diretamente. O SM como mantenedor do processo tem como responsabilidade o PDCA do processo… Um acerto é o prazo, ele também é definido pelo PO e não o SM, o PO recebe as estimativas das tarefas do time mas como o representante do Produto ele detém o plano de entrega. O SM é processo, organização e eficiência. No caso do `/team agreement` podemos direcionar o comando ao PO que deverá orquestrar os envolvidos." Mais três decisões por questionário: **árbitro pelo tipo do achado** para o degrau 2 do QA · **SM mantém os rituais**, e prazo/status/planejamento vão ao PO · o acordo vira **`/sm agreement`**, não broadcast.

**Classificação:** escopo de papel (governança: quem fala com quem, e quem detém prazo, plano e status) + comportamento de agente (dois modos removidos, dois criados) + fluxo (§6 escalação, §6a e §6b novas, §5e Planning) + propriedade de artefato (plano de entrega e status executivo ganham dono) + formato de documento (modelo de status muda de papel e de unidade).

**Uma proposta foi aceita com correção.** O stakeholder propôs que o **PO orquestrasse o acordo**. Isso foi apontado como conflito e a proposta virou **`/sm agreement`**: o achado que atravessa papéis é, com frequência, *"o requisito está errado ou a implementação está?"* — e nessa pergunta **o PO é parte**. Fazê-lo conduzir o julgamento do próprio artefato contraria o princípio que já sustenta a frente 2 do QA (§4a: *um autor não audita a própria omissão*) e a regra de que o dev não revisa os próprios normativos. **Quem facilita é o SM, porque não é dono de requisito, desenho nem evidência.** O stakeholder acatou.

### O que mudou

| Documento | Onde | O quê |
|---|---|---|
| `commands/team.md` | modos | **`consult` removido** — não há mais broadcast. Sem termo reconhecido, `/team` **roteia sem disparar agente**: demanda ao PO, técnica ao Arquiteto, tela ao UX, questão que atravessa a `/sm agreement`, ideia sem cobertura a `brainstorm`. **`agreement` removido** daqui |
| `commands/sm.md` · `agents/scrum-master.md` · `roles/scrum-master/README.md` | modos, mandato | **`agreement` criado** — facilitação, não broadcast: o SM identifica **quais papéis a questão toca** (2–3, nunca os seis), consolida uma recomendação e registra a divergência. **`status` removido** |
| `commands/po.md` · `agents/product-owner.md` · `roles/product-owner/README.md` | modos, mandato | **`status` criado.** O PO passa a ser declarado **o canal do stakeholder** e dono de **prazo, plano de entrega e status** |
| `templates/status.md` | `roles/scrum-master/` → **`roles/product-owner/`** | Muda de dono **e de unidade**: fala em **Histórias**, não em Tasks. "Entregue" é História **aceita na Review** (R21) — não Task fechada nem soma delas. Lê o Sprint Backlog do SM, não o edita |
| `templates/product-backlog.md` | **seção nova** | **Plano de entrega** — que Histórias saem em que sprint, com soma estimada, capacidade do SM e compromisso externo. Seção do backlog, **não documento novo**, para não haver duas verdades sobre prazo |
| `process/workflow.md` | **§6a nova** | *O canal do stakeholder é o PO.* Declara o que mudou de dono e por quê: **quem ordena o backlog por valor e é dono das Histórias é quem pode dizer quando o valor chega**. Ao SM fica a pergunta vizinha — **quanto cabe** |
| | **§6b nova** | *Achado que atravessa papéis — o QA roteia pelo objeto.* Tabela de objeto → dono, a regra de que **quem recebe e não é dono devolve**, e o porquê de não haver orquestrador |
| | §6 escalação | "dúvida de prioridade → SM" **vira** "prioridade, prazo, plano → PO" e "capacidade, fila, bloqueio → SM" |
| | §5e Planning | **O SM facilita, o PO decide o conteúdo**: passa a 7 passos — o PO seleciona (2) e o PO corta no limite (6); o SM confere a DoR e **apresenta a conta** da capacidade (5). *"O SM não veta escopo por valor e o PO não altera a conta de capacidade"* |
| | §5, §5c | Daily passa a `/po status`; "Consulta ao time" e "Acordo" viram uma linha só, `/sm agreement`; a tabela de custo por comando perde os dois broadcasts |
| `process/artifact-ownership.md` | matriz, §3 | **Plano de entrega** e **status executivo** entram com dono PO; o Sprint Backlog ganha a fronteira explícita (*quanto cabe, não quando sai*); **4 conflitos novos**, entre eles "stakeholder quer saber prazo → é do PO" e "SM quer tirar História por baixo valor → valor é do PO" |
| `roles/quality-assurance/README.md` | escada de falha | Degrau 2 **vira dois**: `2 · Outro dono` (o QA classifica pelo objeto e entrega) e `2b · Não consigo classificar` (raro — vai a `/sm agreement`) |
| raiz e `.team-project/` | `README.md`, `how-to.md`, `project-context.md`, `replicate-in-new-project.md` | Superfície de comandos, seção "com quem o stakeholder fala", escada de falha e o bloco fixo §8 |

**Modo de falha que evita:** duas cabeças respondendo *quando o valor chega*. O SM detinha "prazos" enquanto o PO ordenava o backlog por valor e era dono das Histórias — e o stakeholder tinha seis interlocutores para uma pergunta que tem um dono. Também mata a via mais cara do time: o broadcast que reunia seis papéis para uma pergunta que quase sempre tinha um só.

**Quem passa a ser cobrado de forma diferente:** o **PO** (ganha prazo, plano de entrega e status, e passa a ser o canal); o **SM** (perde prazo e status, ganha a facilitação de acordo e a ênfase em rituais); o **QA** (roteia pelo objeto em vez de convocar o time); o **stakeholder** (fala com o PO, e com Arquiteto/UX quando quiser).

**Indicador de sucesso:** nenhum pedido de prazo ou status respondido pelo SM; nenhum acordo facilitado que tenha chamado papel que a questão não tocava; nenhuma História no Sprint Backlog escolhida por outro que não o PO.

### Evidência (R19)

| Classe | Comando | Resultado |
|---|---|---|
| Arquivamento | `Compare-Object` do bloco `## v3.0` movido × `git show HEAD` | **67 × 67 linhas, diff = 0.** Índice de arquivadas ganhou a linha `v3.0` |
| Renomeação | `git mv roles/scrum-master/templates/status.md → roles/product-owner/templates/status.md` | rename detectado pelo git; conteúdo reescrito para a unidade História |
| Substituição de padrão | `/team <mensagem>` · `/team <questão>` · `/team agreement` · `/sm status` · `prazo é do SM` | **0 ocorrências** de cada, fora dos changelogs |
| **Checagem semântica** | leitura de cada tabela de comando e de cada escada de falha | a tabela do `/team` em `how-to.md` usava `<ID>` e **não casou** com a substituição automática — pego na leitura, corrigido à mão. Idem a linha de estrutura `scrum-master/ processo, quadro, status` no `README.md` |
| Ponteiros | varredura de todo `](….md)` relativo | **0 quebrados** *(1 falso positivo conhecido: link dentro do bloco gerado de `project-context.md`)* |
| Encoding | decodificação UTF-8 estrita de todo `*.md` | **0 arquivos inválidos** |

### Pendente do stakeholder

- **Fecho da entrega:** passa a **`v3.3.0`** — carrega quatro entradas de processo (v3.0, v3.1, v3.2, v3.3).
- **Reiniciar a sessão** — `agents/` e `commands/` mudaram.
- ~~**`impact-analysis.md` continua no SM**~~ — **resolvida no addendum abaixo.**

### Addendum — 08/09/2026 · a análise de impacto migra ao PO

*(Anexado, não reescrito — R17. Resolve a pendência que esta mesma entrada declarou; não corrige nada acima.)*

**Instrução:** *(stakeholder, direta)* "sim, migra também."

**O que mudou:** `templates/impact-analysis.md` sai de `roles/scrum-master/` e vai para `roles/product-owner/` (`git mv`); **`/sm impact` vira `/po impact <mudança>`**. O objeto da análise é o **plano de entrega** — manter a análise no SM deixaria o dono do plano sem o instrumento que o altera.

**A fronteira que não migrou.** O template passa a declarar **três insumos com dono explícito**, e o PO **consolida sem inventar nenhum**: quadro, capacidade e "o que sai para caber" vêm do **SM**; retrabalho, contrato e migration vêm do **Arquiteto**, porque **o PO não decide "como"**; risco e recomendação são dele. Regras novas: *"não invente insumo técnico — estimar retrabalho sem o Arquiteto é opinião com aparência de número"* e *"não recalcule capacidade — a conta é do SM"*.

**Por que isto não contradiz o `/sm agreement` desta mesma entrada.** Lá o SM facilita porque há **disputa** e o PO seria **parte** (*"o requisito está errado ou a implementação está?"*). Aqui **não há disputa**: é a análise de uma mudança a um plano que é do PO. **Reunir insumo para informar a própria decisão não é arbitrar** — arbitrar é decidir entre duas partes, e o PO não está julgando ninguém. A distinção está escrita nos dois documentos, para que a próxima leitura não os veja como contraditórios.

**R13 se divide, e continua coerente:** **nomear o instrumento é do SM** — método é o domínio dele, e ele **sinaliza o gatilho** de controle integrado de mudanças; **conduzir a mudança de baseline é do PO**, porque a baseline vive no plano de entrega. Refletido em `skills.md` §9, `working-rules.md` R13, `commands/{sm,po}.md` e nos dois roteiros.

**Evidência (R19):** `git mv` detectado como rename; **`grep '/sm impact'` fora dos changelogs = 0**; a **leitura no contexto** pegou três ocorrências que a substituição de padrão não casaria — o título da seção no roteiro do SM, a linha da tabela de documentos dele e o texto de `skills.md` §9, todos reescritos à mão para a divisão insumo/instrumento. **Sem bump de versão:** a entrega segue `v3.3.0`, porque isto completa uma decisão já registrada, não abre uma nova.

---

## v3.2 — A métrica de eficiência para de medir história fria; o `/review` sai do caminho quente — 08/09/2026

**Instrução:** *(stakeholder, direta)* "faça uma revisão de processo geral e otimização sempre com o objetivo de otimizar o gasto com tokens e garantia de qualidade do processo e do produto desenvolvido pelo time."

**Classificação:** formato de documento (extração de conteúdo frio do caminho quente) + regra (a métrica de §5c e os indicadores de retrospectiva mudam de definição). Nenhum fluxo, cerimônia, portão ou propriedade de artefato alterado — **a garantia de qualidade não foi tocada**, e a auditoria abaixo confirma que continua íntegra.

### Medição — a fase Check do PDCA (§5c)

| Papel | Carga fixa antes | Carga fixa depois | Δ |
|---|---|---|---|
| scrum-master | 13,5 KB | 12,7 KB | −6% |
| product-owner | 10,4 KB | 10,0 KB | −4% |
| architect | 10,9 KB | 9,8 KB | −10% |
| user-experience | 11,2 KB | 10,7 KB | −4% |
| developer | 7,4 KB | 6,9 KB | −7% |
| quality-assurance | 10,2 KB | 9,6 KB | −6% |
| **Total** | **63,6 KB** | **59,7 KB** | **−6%** |

Custo de um broadcast `/team <mensagem>`: **69 KB** (os seis fixos + `commands/team.md`), antes de qualquer leitura de `.team-project/`. É a operação mais cara do time por uma ordem de grandeza.

### O que mudou

| Documento | Onde | O quê |
|---|---|---|
| `agents/{scrum-master,product-owner,architect,user-experience,quality-assurance}.md` | seção final | A seção "Evolução dos seus documentos" **era duplicação literal** de `review-contract.md` §"Alcance por papel" — inclusive os "cuidados do Arquiteto sobre `standards/`", quase palavra por palavra. Reduzida a **um parágrafo** que aponta para o contrato e preserva a única regra que precisa ser lida antes dele: *escreva na RAIZ, nunca em `${CLAUDE_PLUGIN_ROOT}`*. **−1,9 KB de caminho quente, zero informação perdida** |
| `commands/{po,arc,qa,ux,dev,sm}.md` | seção final | O parágrafo "Evolução dos documentos do X — não é aqui" repetia o que o `review-contract.md` já diz. Comprimido a **uma linha de roteamento** (`/X review …` → `/review …`), que é a única parte usada em tempo de invocação. As instruções operacionais ("ao receber o veredito/relatório…") foram **preservadas na íntegra** |
| `process/workflow.md` | §5c, "Métrica por papel" | **Passa a ser dois números, nunca somados:** *carga fixa* (`agents/` + `commands/`, paga em toda invocação) e *conjunto sob demanda* (`roles/<papel>/`, **sem os changelogs**). Seção nova ordenando onde o corte rende mais, e o custo do broadcast declarado |
| `process/working-rules.md` | indicadores | A linha única de footprint vira **duas**, alinhadas à métrica nova |
| `templates/retrospective.md` | métricas | Idem: carga fixa e conjunto separados; o teto de entrada de changelog (R17) vira linha própria |
| `review-contract.md` | `/review metrics` | O giro **Act** passa a exigir os dois números separados, e a preferir a remoção na carga fixa |

**O defeito que a métrica tinha.** `roles/scrum-master/` mede **320,9 KB**, dos quais **159,4 KB (50%) são o changelog arquivado** — frio por construção (só lido em `/review history`) e **monotonicamente crescente por decisão do próprio processo**, já que R17 manda arquivar em vez de apagar. Contra ~30 KB dos outros papéis, o SM aparecia dez vezes mais pesado por causa de história que ninguém carrega. O giro **Act** apontaria sempre para o SM e nunca para o desperdício real, que estava nos 63,6 KB de carga fixa. **Métrica errada não deixa de corrigir — dirige o corte para o lugar errado**, e teria custado ao time um giro inteiro de PDCA cortando o documento errado.

**Modo de falha que evita:** o ciclo de eficiência otimizar o que não custa e ignorar o que custa. É o análogo, para o processo, do que R7 evita no produto: decidir sem medir o que importa.

**Quem passa a ser cobrado de forma diferente:** o **SM** (reporta dois números na retrospectiva, não um) e **todo papel** no `/review metrics`.

**Indicador de sucesso:** a carga fixa total não volta a subir sem regra ou cerimônia nova que a justifique; o próximo `/review metrics` propõe remoção na carga fixa, não no conjunto sob demanda.

### Auditoria de qualidade — o que foi verificado e está íntegro

| Verificação | Resultado |
|---|---|
| Toda regra tem forma de verificação ("SM verifica") | **21/21** |
| Contagem declarada × real de regras | 21 × 21, e 21 linhas no resumo |
| Modelo órfão (template que ninguém referencia) | **0** |
| Links `.md` quebrados | **0** *(1 falso positivo: link dentro do bloco markdown gerado de `project-context.md`)* |
| Portões, gates, DoR/DoD, escada de falha, seis frentes do QA | **inalterados** — nenhum controle de qualidade foi removido nesta entrada |

### Evidência (R19)

| Classe | Comando | Resultado |
|---|---|---|
| Arquivamento | `Compare-Object` do bloco `## v2.11` movido × `git show HEAD` | **53 × 53 linhas, diff = 0.** Índice de arquivadas ganhou a linha `v2.11` |
| Extração | tamanho de `agents/` + `commands/` antes e depois | 63,6 KB → 59,7 KB (−6%); por papel, na tabela acima |
| **Integridade da extração** | `grep` de "Alcance por papel" e dos 5 papéis em `review-contract.md`; `grep` do roteamento `/X review` nos 6 comandos | contrato cobre **5/5** papéis e os cuidados de `standards/`; roteamento preservado em **6/6** comandos |
| **Encoding** | contagem de mojibake (`Ã`, `â€`, `Â`) em `agents/` e `commands/` | **0.** Uma primeira tentativa da extração usou `Get-Content` (ANSI no PS 5.1) com `WriteAllLines` (UTF-8) e **corrompeu 5 arquivos por dupla codificação** — detectado porque os *bytes subiram enquanto as linhas caíam*; revertido com `git checkout` e refeito com `ReadAllText`/`WriteAllText` |
| Auditoria | varredura de regras sem verificação, modelos órfãos, contagens e links | tabela acima |

### Pendente do stakeholder

- **Fecho da entrega:** a entrega passa a **`v3.2.0`** — carrega três entradas de processo (v3.0, v3.1, v3.2).
- **Reiniciar a sessão** — `agents/*` e `commands/*` mudaram.
- **Não aplicado, proposto:** o bloco fixo §8 do `.team-project/README.md` custa **2,6 KB lidos por todo papel em toda invocação**. Cortá-lo exige decidir o que o agente precisa saber de cor sobre a superfície de comandos — é a maior economia restante, e é sua a caneta sobre esse bloco.

### Addendum — 08/09/2026 · correção do custo de broadcast

*(Anexado, não reescrito — R17. A entrada acima fica como foi registrada.)*

O número **"69 KB por broadcast"** registrado acima **está errado**. Ele somava os seis arquivos de `commands/` à carga do broadcast, e eles **não são carregados ali**: `commands/<x>.md` entra no **contexto principal** quando o stakeholder digita `/x`; `agents/<papel>.md` entra no contexto do **subagente**. Um broadcast carrega `commands/team.md` **uma vez** mais um `agents/<papel>.md` por subagente — nunca os seis arquivos de comando.

**Valores corretos:** `/team <mensagem>` = **47,9 KB** · `/team agreement` = 55,1 KB · `/team brainstorm` = 36,6 KB · `/team cycle` = 27,6 KB. A ordem de grandeza e a conclusão não mudam — o broadcast continua sendo a operação mais cara —, mas o número estava 44% acima do real.

**O que a correção acrescentou ao normativo:** `workflow.md` §5c passou a declarar **onde cada arquivo é carregado** (principal × subagente), a tabela de custo por comando, e as **três coisas que a carga fixa não mostra** e costumam dominar o custo real — o **modelo** de cada agente (`/arc` e `/ux` em Opus, `/dev` em Haiku: `/arc` carrega menos que `/sm` e custa mais), a **leitura em tempo de execução** (que costuma superar a carga fixa e é multiplicada pelo número de subagentes) e o **retorno das respostas** ao contexto principal na consolidação.

**Como foi detectado:** o stakeholder perguntou quais são os comandos mais caros do time; a conta refeita papel a papel não fechou com o registrado. **Modo de falha que isto expõe:** medir sem declarar *onde* cada arquivo é carregado produz número plausível e errado — e a v3.2 é exatamente uma entrada sobre não confiar em métrica mal definida.

