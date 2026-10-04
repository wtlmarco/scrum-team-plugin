# Trilha `fix` — Correção em bloco (R33)

> **Dono:** SM · **Lido sob demanda** pelos modos `/sm fix`, `/sm fix plan` e `/sm fix run`, e pela triagem de `/po note` e `/po bug` · Regra: R33 (`working-rules.md`) · Instrumento: C4 (`scripts/checks/fix.ps1`) · Índice: `.team-project/fixes.md` ([`../templates/fix-log.md`](../templates/fix-log.md))

**Unidades.** **Correção** = `F-<nnn>` (ficha `fixes/F-<nnn>.md`, do PO) · **bloco** = `B-<nnn>` (pasta `fixes/B-<nnn>/`: `plan.md` do Arquiteto, `verdict.md` do QA, `consumption.md` do SM). Dois tipos: **defeito** (o código diverge do que o SDD já diz) e **ajuste** (mudança pequena que altera o SDD funcional em delta mínimo). **Discriminador:** se o código deve passar a obedecer ao SDD, é defeito; se o SDD precisa mudar, é ajuste — ou não é Correção. **SDD omisso não é Correção:** preencher a lacuna é criar requisito (C1 cai) e segue a rota de lacuna de especificação (`workflow.md` §6); depois de preenchida, o desvio do código pode voltar como defeito.

**Quem orquestra.** A **sessão** (como no `sprint run`): uma invocação por papel para o bloco inteiro. Sem `board`, sem `close` do Agent `scrum-master`, sem pacote, sem portões ①②③④ e sem Review. O índice e o fechamento são escritos pela sessão. Formatos exatos dos documentos: os modelos citados; **o C4 lê os rótulos com esta grafia**, não variar.

## §Elegibilidade — todos os critérios, por Correção

| # | Critério | Quem confere | Quando |
|---|---|---|---|
| C1 | Não cria requisito novo nem regra de negócio nova (**ajuste:** altera no máximo **um** requisito existente, sem criar outro; SDD omisso não é ajuste) | PO | triagem |
| C2 | Não cria tela, estado de tela nem passo de jornada (texto, mensagem e validação de campo existente podem mudar) | PO (UX, se houver dúvida) | triagem |
| C3 | Não toca uma História **em voo** no sprint corrente (essa tem rota: Task da mesma História, R30) | PO | triagem; a sessão confere de novo no `fix run` |
| C4 | Não envolve dado pessoal sensível nem regra LGPD | PO | triagem |
| C5 | Não muda contrato de API, schema, migration, autenticação nem autorização | Arquiteto | `fix plan` |
| C6 | Toca no máximo **N arquivos de produção** (N em `.team-project/README.md` §2a, "Limite de arquivos por Correção (N)"; padrão **5**) e **não cria arquivo** além do de teste | Arquiteto | `fix plan` |
| C7 | Não exige dependência nova, mudança de toolchain nem de configuração de gate | Arquiteto | `fix plan` |
| C8 | A causa está identificada com `arquivo:linha` (o QA a traz da reprodução; o Arquiteto confere). Sem causa, é investigação: `/arc question` antes, ou spike | Arquiteto | `fix plan` |

Critério **sem julgamento de tamanho em horas**: tudo se confere lendo o requisito, o diff planejado e o código. Critério que falha → **aquela** Correção não é Correção (marca `✘` na linha dela; ver §Promoção). Defeito de segurança, dado pessoal sensível, autenticação e autorização vão **sempre** à trilha Sprint. Cada critério é registrado como `- C<n> ✔ · <evidência em uma linha>` (ficha: C1–C4; `plan.md`: C5–C8).

## §Triagem — fonte única

Usada pelo `/sm fix plan` (passo 1) e, avulsa, por `/po note` e `/po bug`. **O stakeholder não escolhe a trilha; o critério de elegibilidade escolhe.** A entrada é o sintoma anotado em `.team-project/note.md` (Abertas, um por linha) ou `/po bug`.

1. **PO, uma invocação para a fila inteira.** Classifica cada item: **defeito** · **ajuste** · **mudança de escopo disfarçada** · **dúvida de uso**. Para defeito e ajuste, confere C1–C4. Defeito de funcionalidade de História já aceita: registra a **História do aceite** (`H-nnn + sprint do aceite` · `H-nnn · fora da janela` · `não identificada` · `não aplicável`, lida dos dossiês, sem abrir código) **por item**; ajuste: `não aplicável`. Ajuste elegível: escreve o **delta** na ficha (requisito: antes → depois; o que **não** muda; linha do `06-changelog` — rascunho até o ✅). Escopo → Product Backlog (`/po impact` se o stakeholder quiser o custo); dúvida → resposta; fora de C1–C4 → rota de hoje (Product Backlog → sprint; correção pontual só se não elegível e couber na folga, `workflow-sprint.md` §5g). **Item que cita F-ID fechada:** a F-ID é **reaberta** (coluna "Reaberta em" de `fixes.md`), volta à triagem como defeito, e **não gera nova entrada de defeito no `pending.md` nem conta de novo como escape**.
2. **QA, uma invocação (`/qa bug` aceita lista):** reproduz **todos** os defeitos elegíveis, uma linha por item — reproduzido com `arquivo:linha` (entrada no `pending.md` com `Origem: stakeholder` e a História do aceite recebida do PO, sem reinterpretar) · não reproduzido. **Só defeito reproduzido vira Correção.** Não reproduzido volta ao PO como suspeita, fora do bloco. Ajuste não passa pelo QA (não há o que reproduzir).
3. **A sessão abre `F-<nnn>` triada:** ficha (modelo [`fix-card.md`](../../product-owner/templates/fix-card.md), que **aponta** para a entrada do `pending.md` e não copia a História do aceite) e linha em `fixes.md`. O item tratado **sai do `note.md`**.
4. **Consumo da triagem:** vai aos destinos de sempre (sprint aberto, senão fora de sprint), com **Nota iniciando em `triagem;`** — mesmo quando roda dentro do `fix plan`, porque a triagem também trata o que não vira Correção e porque a correção pontual de hoje também a paga à parte (`templates/consumption.md`).

## §Plan — `/sm fix plan [<F-ID> …]`

**Pré-condições:** (1) onboarding concluído (R14); (2) `developer/context.md` e `quality-assurance/context.md` existem; (3) **nenhum bloco aberto** (planejado ou em execução) — há um: pare e indique `/sm fix run`; (4) há o que fazer (itens em Abertas **ou** F-IDs triadas) — nenhum: pare e reporte. **Não** exige histórico de sprints, folga nem pacote aprovado, e **pode rodar a qualquer momento** (não escreve código; R1 permite paralelismo entre papéis).

1. **Triagem** (§Triagem), só se `note.md` tem itens em Abertas. Com `F-ID` explícita e sem fila, pula.
2. **Monta o bloco:** as F-IDs triadas, na ordem de prioridade do PO, **mesma área primeiro**, até o **teto: no máximo 5 Correções (rótulo "Teto de Correções por bloco") e 2N arquivos de produção somados**. O que passar fica `triada` para o próximo bloco; fila que nunca cabe em blocos é sinal de sprint de manutenção. **A pasta `fixes/B-<nnn>/` nasce aqui; daqui em diante todo consumo é do bloco.** Nenhuma F-ID triada → termina com o resumo da triagem, sem bloco.
3. **Formulário dos ajustes (R22):** **um**, uma pergunta por ajuste (até 4 por chamada) — *aprovar · ajustar · tratar como Sprint · pedir mais contexto*; decisão de escopo da triagem que é do stakeholder entra no mesmo formulário. **Em projeto com Identificador remoto (R34):** cada pergunta leva o prefixo `[<ID> · B-<nnn> · ajuste F-<nnn>]` (a da triagem, `[<ID> · B-<nnn> · escopo F-<nnn>]`) e **uma linha numerada em `README.md` §7 por pergunta, gravada antes** do formulário (`N. [<prefixo>] <pergunta> — material: fixes/F-<nnn>.md — aaaa-mm-dd hh:mm`); decidida, a linha sai de §7 para a ficha. Pergunta pulada (`[No preference]`) ou expirada **não é decisão**: o ajuste fica sem confirmação e **não entra no bloco** — a linha continua em §7. Registra data e decisão na ficha (`## Confirmação do stakeholder`). Ajuste não aprovado sai do bloco (`devolvida` ou promovida).
4. **Arquiteto, uma invocação:** um mini-plano por F-ID em `fixes/B-<nnn>/plan.md` (modelo [`fix-plan.md`](../../architect/templates/fix-plan.md); **teto de 60 linhas por F-ID**): C5–C8 conferidos com o código real, causa, **lista fechada de arquivos** (`- produção:` ≤ N, mais o `- teste:`), teste de regressão (nome, arquivo, o que afirma; tem de **falhar** antes da correção), passos (1–5, cada um com Conferência), **comando de verificação já validado** no `developer/context.md` (R26 se cumpre citando-o, sem medir de novo, salvo Correção que toque toolchain — e então não é elegível), standard (R16) só da seção tocada, "onde parar e perguntar". Critério que cai → **promoção** (§Promoção). Pode devolver à fila F-ID de área distante.
5. **Resumo ao stakeholder:** o que virou Correção, o que foi para outra rota (e onde está), o bloco planejado (F-IDs, arquivos por F-ID) e as promoções com motivo. **Sem mais pergunta.**

## §Run — `/sm fix run`

**Pré-condições:** (1) existe bloco **planejado** (`plan.md` escrito e sem `## Fechamento` no `verdict.md`); (2) **nenhuma Task em 🟨** no sprint corrente — e nenhuma entra enquanto o run roda (R1); (3) nenhuma F-ID do bloco toca História que entrou em voo depois do `plan` (C3) — tocou: aquela F-ID é promovida antes de o dev começar. Falhou: pare e reporte. **Interrompido:** rode de novo; retoma da Correção em que parou, e as fechadas não são refeitas (R5).

0. **C4 `-Pre`:** `powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/fix.ps1" -Block B-<nnn> -Pre`. A saída é a evidência (R7). **Exit 1 = o run não começa** (bloco sem plano, Task em 🟨 ou bloco acima do teto): pare, reporte a linha que falhou. Registre `**Executado em:**` (data e hora) no `verdict.md`.
1. **Revalidação (D9):** arquivos de alguma F-ID mudaram desde a `**Data:**` do `plan.md`? Com git: `git log --since="<Data do plan>" -- <arquivos da F-ID>`; sem git: Task ✅ depois do `plan` cujo plano lista arquivo da F-ID. Sim → **Arquiteto revalida só aquelas F-IDs**, preenchendo `### Revalidação` (data, o que mudou, o que o plano passou a dizer); não → `n/a — sem mudança`, custo zero. Revalidação que derruba C5–C8 promove a F-ID.
2. **dev, uma invocação, uma F-ID por vez** — **antes de disparar, a sessão grava `.team-project/.active-task`** com `{ "trilha": "fix", "id": "B-<nnn>", "plano": ".team-project/fixes/B-<nnn>/plan.md" }` (a guarda **G9** libera ao dev só os caminhos de `- produção:`/`- teste:` do `plan.md`; com `"id": "F-<nnn>"`, só os daquela F-ID — use ao devolver **uma** Correção ao dev para retrabalho). Cada F-ID vai com **checkpoint em disco e diff isolado** (R5): commit próprio quando o produto é repositório git, com mensagem iniciando em `F-<nnn>:` (o C4 junta o `**Commit:**` do `verdict.md` **e** os commits `F-<nnn>:` — inclusive de retrabalho — como os da própria Correção nos itens 5 e 9; jobs do `operator` em `.team-project/operator/B-<nnn>/<F-ID|bloco>/`, R28); sem git, checkpoint com a lista de arquivos **e a cópia dos trechos originais**, para a Correção poder ser desfeita sozinha. Sequência: **teste de regressão (tem de FALHAR — saída colada)** → correção → teste passa → verificação do plano. 🔺 GAP: rota de sempre (Arquiteto decide no mini-plano; dev retoma por `SendMessage`). GAP que quebra C5–C8 → **promoção** daquela F-ID; as outras seguem. O relatório do dev traz, **por F-ID**, o "Teste de regressão: saída antes / saída depois" (`delivery-report.md`).
3. **QA, uma invocação** (verifica quem **não** corrigiu — o dev): `verdict.md` com **uma seção `## QA — F-<nnn>` por F-ID**, na variante "trilha fix" (modelo do QA) — `**Veredito:**`, `**Antes:** exit <n>` e `**Depois:** exit 0` com comando e saída, `### Escopo`/`**Fora do plano:**`, `### Documentos vivos (R12)`/`**Estado:**`; mais, **uma vez por bloco**, os regressivos R30 dos fluxos tocados (cada defeito funcional vira um cenário `SC-nnn`) e a suíte do módulo tocado. **Não existe veredito do bloco:** um ❌ numa F-ID não reprova as outras; ⚠️/❌ volta ao dev ou ao Arquiteto **só para ela**, como no `sprint run`. Execução pesada pelo `operator` (R28).
4. **[há ajuste com ✅]** **PO aplica o delta** ao requisito e ao `06-changelog` (R12, R15 — só depois do ✅). **[o ajuste muda texto citado literalmente numa especificação de tela]** **UX atualiza a especificação**, uma invocação curta por bloco (P4); sem citação literal, não há UX.
5. **C4 completo:** `... fix.ps1 -Block B-<nnn>` **antes** de gravar qualquer estado final. **Exit 1 = só as F-IDs listadas em "Não fecham" não fecham** (as outras fecham — D6): a sessão devolve cada uma ao dev (veredito ⚠️/❌ ou item faltando), ou a promove (§Promoção), e roda o C4 de novo. Linhas de aviso (consumo fora de `fixes/`, sobreposição com Task em 🟨, revalidação ausente) vão para o resultado e para a retrospectiva; não bloqueiam.
6. **Fechamento (§Fechamento).**

## §Promoção — individual e obrigatória

Critério C1–C8 que deixa de valer, **em qualquer etapa**, tira **aquela** Correção do bloco — nenhum papel continua uma Correção sabendo que ela não cabe mais. O papel que detecta **para naquela Correção** e escreve `**Critério que caiu:** C<n> — <motivo>` no mini-plano (e, na ficha, em `## Destino`). A sessão muda o estado para **`promovida`** e devolve ao PO, que segue a rota de hoje: GAP não-bloqueante → item no Product Backlog (R30); bloqueia História em voo → Task da História no sprint. **O resto do bloco segue.** Trabalho feito: o mini-plano vira insumo do Plano de Implementação; o código da promovida é descartado pelo diff isolado, salvo o Arquiteto o declarar aproveitável. **Ajuste promovido depois do formulário:** o delta nunca foi aplicado ao SDD; segue como insumo da História, citando a decisão do stakeholder, e a História passa pelo ③ do pacote como qualquer outra. **Promoção não é falha da trilha** — falha é a Correção que deveria ter sido promovida e não foi (julgamento do SM na retrospectiva).

## §Fechamento — passo 6 do `run`

Só depois do C4 do passo 5 (F-IDs que fecham = veredito ✅ e itens bloqueantes ok):

1. **Estado final de cada F-ID** em `fixes.md` (`fechada` · `promovida` · `devolvida`) e na ficha (`## Destino`); **`devolvida` leva o motivo** na célula "Promovida para" (`devolvida — <motivo>`, [`fix-log.md`](../templates/fix-log.md)); linha do bloco (Planejado · Executado · Fechado · Correções · "Fechadas · promovidas · devolvidas" · "Durante sprint"). A coluna "Σ tokens" é derivada.
2. **`## Fechamento` do `verdict.md`:** `**Fechado em:** aaaa-mm-dd` e a tabela `| F-ID | Estado final |`. **Apague `.team-project/.active-task`.** **A pasta fica imutável**: bloco fechado nunca recebe linha. Copie `**Fechado em:**` para o rodapé do `consumption.md` do bloco (completo, com "Totais do bloco" derivados).
3. **`pending.md`:** a entrada de cada defeito `fechada` fecha com ponteiro para a `F-<nnn>` (QA, mesmo ciclo — R12).
4. **Resultado ao stakeholder, por F-ID:** fechada · promovida (e por quê) · devolvida à fila. **Sem aceite na Review e sem formulário:** o ✅ do QA encerra a Correção (R33) — **o fim do `fix run` não tem formulário de autorização** (o de R34 vale só para o `sprint run`): não há decisão do stakeholder a pedir, é relatório; no celular, esse resultado só aparece abrindo App → Code (limitação medida, sem *push*); **reabrir é anotar no `note.md` citando a F-ID** — a triagem a marca `reaberta`.

## Bloco — resumo das regras

| Aspecto | Regra |
|---|---|
| **Composição** | F-IDs `triada`s por prioridade do PO, mesma área primeiro; `/sm fix plan F-012 F-015` escolhe explicitamente |
| **Teto** | **5 Correções e 2N arquivos de produção** somados |
| **Estados** | **planejado** (`plan.md` escrito) → **em execução** (`fix run` começou) → **fechado** (`## Fechamento` no `verdict.md`; todas as F-IDs em estado final) |
| **Invocações de um bloco de N Correções** | só defeitos: Arquiteto (plan) · dev · QA = **3**; com ajuste: + PO = **4**; + Arquiteto se há revalidação; + UX se há texto de tela citado literal |
| **Capacidade** | só o `fix run` disputa a construção (R1, D7); o consumo vive no bloco e **não** entra na capacidade observada — a retrospectiva o mostra ao lado ("Trilha fix no período") |
| **Gates** | todos os técnicos, **por Correção**: plano (R8, em forma de mini-plano), standard (R16), build e testes com saída real (R7), segurança (R11), documentação (R12), teste de regressão que falha antes e passa depois, verificador diferente de quem corrigiu. Os de pacote e Review não se aplicam (`workflow.md` §8) |

## Frentes do QA por Correção

| Frente | Na trilha `fix` |
|---|---|
| 1 · Requisito | o comportamento do SDD (defeito) ou do requisito alterado (ajuste) exercitado, inclusive borda do caso relatado — o mesmo passo da reprodução, agora passando |
| 2 · Especificação técnica | **reduzida:** diff da F-ID × arquivos do mini-plano dela; sem as duas tabelas completas |
| 3 · Segurança | checklist do projeto aplicado ao trecho tocado |
| 4 · Testes e métricas | teste de regressão `Antes: exit ≠ 0` / `Depois: exit 0`; build sem avisos |
| 5 · Documentação | só no ajuste: o delta da ficha bate com o código; defeito: `n/a — trilha fix (R33)` |
| 6 · Desempenho | só se a Correção toca operação de V18–V21; senão `n/a — trilha fix (R33)` |
