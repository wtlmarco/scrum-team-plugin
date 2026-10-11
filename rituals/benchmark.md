# Benchmark — o time compensa em relação ao Claude sem ele?

> Lido **só quando o stakeholder abre o experimento**. Fica fora de `commands/` pelo mesmo motivo de `init`, `update` e `version`: é pedido raramente, e o que está em `commands/` é carga fixa de toda invocação. Modelo dos registros: `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/benchmark.md`. Pasta: `.team-project/benchmark/` (dono SM, não semeada — `artifact-ownership.md` §1).

**Pergunta:** quanto da qualidade vem **do plugin** (o pipeline: plano, dev júnior, QA independente, cerimônia) e quanto vem **da especificação** que ele produz (brainstorm, SDD, protótipo, História)? A resposta é **direcional**, não estatística: a amostra é pequena, e o resultado diz isso.

## 1. Protocolo — antes de qualquer execução

1. **Itens:** de **3 a 5**, já aceitos (História) ou fechados (Correção), com evidência, cobrindo tamanhos diferentes. Para cada um: ID, tamanho, por que foi escolhido e o **commit-base** — o commit **anterior** à entrega.
2. **Braços:** A · B · C, e B′ só com a **fase 2** das guardas aplicada (G5–G11, `hooks/COVERAGE.md`) — definição e o que cada um isola no modelo `benchmark.md`.
3. **Regra de decisão:** copie a do modelo para o `protocol.md`, confirme ou troque os limiares e **date-a**. Data posterior à primeira execução invalida o experimento — a regra existe para não ser escrita depois de ver os números.

## 2. Sonda de orientação (uma vez por versão do plugin)

Dispare cada papel uma vez, no projeto, com a instrução **"leia o que o seu card manda ler antes de trabalhar e responda só OK"**. Os tokens dessa invocação são o **custo de orientação** do papel. Grave em `.team-project/benchmark/orientation-<versão>.md`. Comparado com a média por invocação do `consumption.md`, diz que fração do custo é só leitura — e se o próximo corte deve ser no texto do processo ou no trabalho.

## 3. Execução de cada braço (B, C, B′)

1. **Worktree fora do repositório do produto**, a partir do commit-base:
   `git worktree add ../<projeto>-bench-<item>-<braço> <commit-base>`
2. **Plugin desabilitado** no worktree: `.claude/settings.local.json` com `"enabledPlugins": { "team@team": false }`. Confira com `/plugin` antes de começar.
3. **Sessão nova** do Claude Code no worktree. Instrução fixa, idêntica para todos os braços, seguida da entrada do braço:

   > Implemente o que está descrito abaixo. Rode o build e os testes. Pare quando achar que terminou.

4. **Ninguém intervém no meio.** Pergunta do Claude é respondida, e **cada resposta é contada** — é o "toque no stakeholder" do braço.
5. No fim: `/usage`, colado em `.team-project/benchmark/<item>/<braço>/usage.md`, com a duração de relógio.

O braço **A** não é reexecutado: o custo é o do `consumption.md` da entrega, com as linhas de sessão lidas à parte.

## 4. Avaliação — cega e igual para todos os braços

1. **Cenários `SC-nnn`** da História (novos e regressivos), executados pelo `operator` em cada worktree: passou · falhou.
2. **Revisão cega:** os diffs dos braços são renomeados (X, Y, Z, W) e revisados por um agente que não sabe a origem, com este prompt fixo:

   > Revise o diff abaixo. Liste: defeitos com `arquivo:linha`; desvios dos `standards/` do projeto; problemas de segurança e LGPD; testes que continuariam passando se o código regredisse. Não sugira melhorias de estilo.

3. **Métricas mecânicas:** linhas alteradas, testes adicionados, avisos de build, cobertura do módulo.

**Defeitos do braço** = cenários que falharam + defeitos da revisão cega.

## 5. Leitura

Pela regra de decisão datada no `protocol.md`, **sem reinterpretar os limiares** — inclusive a diferença mínima de defeitos e a linha "inconclusivo → ampliar a amostra". Resultado em `result.md`: tabela por item e braço, a leitura e os limites (amostra, viés de ordem, o que não foi exercitado).

**Custo do próprio experimento:** registrado em `.team-project/consumption.md`, Categoria `cerimônia`, Unidade `benchmark`.

## 6. Feche

- `git worktree remove ../<projeto>-bench-<item>-<braço>` para cada braço. Nada do experimento entra em `docs/` nem no git do produto (R31).
- A ação que a leitura indicar vai ao `/review`, com o `result.md` como evidência.

## 7. Modo projeto — o plugin do pedido ao Pronto, sem intervenção (v3.47 · M4)

**Pergunta:** o plugin entrega um **projeto inteiro** melhor, mais barato e mais rápido que o Claude sem ele — e qual configuração do plugin é a melhor? Os §1–§6 medem itens já entregues; aqui o objeto é um **projeto-padrão** executado do zero, em **um sprint navegável**, por braços que ninguém acompanha. Lido só quando o stakeholder abre este experimento.

1. **Repositório do experimento, fora do plugin e de qualquer worktree.** Guarda o protocolo **datado**, o dossiê (e o `answers.json`), o **oráculo oculto** (fluxos de aceite, lote do `fix`, RNF, verdade gerada por script) e os resultados. O plugin não o carrega nem o referencia por dentro (R31).
2. **Projeto-padrão.** O que vai aos braços: `pedido.md` fixo + o anexo de conteúdo + o contrato de teste (`testTag`). O que **não** vai: MVP com Histórias, backlog, referências e oráculo — entregá-los transformaria todo braço em "com a especificação". Escolha projetos **offline e determinísticos**, de **4 Histórias** navegáveis, com regras onde semear defeitos de sintoma e requisitos não funcionais medíveis num emulador de perfil fixo; prefira **tipos diferentes** entre projetos.
3. **Braços por projeto.** **P** (o plugin, na versão e no `models.json` sob teste) · **N** (Claude sem plugin, instrução mínima) · **N-forte** (sem plugin, com a instrução de um usuário competente: plano, testes, README). **N e N-forte ficam em cache**: rodam uma vez por projeto e só repetem se mudar o pedido, o oráculo ou o modelo base. N+S (N com o SDD do P) é opcional e mede o valor da especificação.
4. **Escopo de cada run.** Abertura (brainstorm → SDD → protótipo → portões ①②③) + **1 sprint** + **cauda de `fix`** (3 defeitos + 1 ajuste, descritos como sintoma). Custo e tempo saem **por fase** e totais; a abertura é custo fixo.
5. **Preparar o braço P.** Worktree limpo; plugin habilitado; `/team init`; `guards.json` com `protectedPaths`, `runCommands`, `verify` e **`bench`** — `{ "arm": "<id>", "answers": "<json de respostas>", "foreground": true }` ([`sprint-run.md`](../roles/scrum-master/process/sprint-run.md) §Modo benchmark); `models.json` da configuração, com `"executor": "architect"` no braço **P2**. Execução em `claude -p`, uma sequência fixa de prompts por braço, com `--permission-mode` que dispense os pedidos de edição (é por ele que passa o diff de arquivo protegido, §12 do plano).
6. **Sem o stakeholder.** A **G18** responde cada formulário pelo dossiê (`[bench] resposta do stakeholder: …`) e registra em `questions.log` — são os "toques" do braço, separando os que estavam no dossiê dos que não estavam. A navegação do protótipo é **simulada** (`n/a — navegação simulada (benchmark)`; o C2 só a aceita com `bench` ligado). O driver confere ao fim de cada `claude -p` se o turno terminou num **ponto legítimo** (fim da fila, bloqueio sem Task elegível, pré-condição falha); qualquer outro fim com Task elegível é **parada fora do contrato**: registra, retoma com `/sm sprint run`, teto de 3 retomadas por passo — passou disso, o braço aborta e o aborto é resultado.
7. **Avaliação cega e externa ao plugin.** Fluxos de aceite no emulador do perfil (relógio controlado), lote do `fix` injetado em `note.md`, fluxos de regressão depois do `fix`, RNF, **revisão cega** do código **e da documentação** (rubrica 0–3: rastreabilidade, correção, decisões, como rodar e estender, consistência, **teste de onboarding** por agente sem plugin e só com o repositório), e a **sonda de manutenibilidade** (agente sem plugin implementa uma mudança de escopo fixa do backlog; mede tokens, tempo e defeitos). Mais as conferências do próprio plugin: C1/C4, `result.json` do `verify`, `guards.log`.
8. **O que se mede.** Custo (`usage.jsonl` por papel, modelo e fase) · tempo (relógio por fase e por Task no `burndown.md`, Σ das durações dos agentes, paralelismo, segundos do `verify`) · toques e paradas · retrabalho · **precisão do plano** (GAPs por negação de guarda, planos reprovados no `plan.ps1`, mutações não pegas e, no perfil executor, as linhas de "Plano corrigido durante a execução") · **assertividade** (Histórias aceitas de primeira, falso verde).
9. **Regra datada antes da 1ª execução.** Portões eliminatórios (build e suíte, aceite ≥ 80%, RNF, conclusão, regressão) · "melhor produto" (menos defeitos, com diferença maior que a dispersão) · "melhor custo-benefício" (dominância de Pareto; sem dominância, nota composta com pesos datados) · linhas de decisão · repetições (≥ 2 por braço). Data posterior à primeira execução invalida o experimento.
10. **Laço de melhoria.** medir → achar o maior centro de custo, tempo ou defeito → **hipótese registrada** → mudar o plugin ou o `models.json` → rodar o braço P nos projetos → **aceitar** só se a qualidade não piora além da dispersão em nenhum projeto, custo ou tempo melhora em pelo menos 2 dos 3 e a mudança é **geral** (nada que cite um projeto) → repetir, com teto de iterações. Se todos os projetos entram no ajuste, o resultado final é **"dentro da amostra"**, otimista por construção — diga isso no relatório.
11. **Variáveis do laço.** `models.json` (modelo de cada papel) e `"executor": "architect"` (Arquiteto implementa, sem dev) são parâmetros de **configuração**, não versões do plugin: uma variável por iteração.
12. **Feche como o §6.** Worktrees removidos; nada em `docs/` nem no git do produto (R31); a ação que a leitura indicar vai ao `/review`, com o resultado como evidência.
