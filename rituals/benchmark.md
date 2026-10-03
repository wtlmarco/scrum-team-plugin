# Benchmark — o time compensa em relação ao Claude sem ele?

> Lido **só quando o stakeholder abre o experimento**. Fica fora de `commands/` pelo mesmo motivo de `init`, `update` e `version`: é pedido raramente, e o que está em `commands/` é carga fixa de toda invocação. Modelo dos registros: `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/templates/benchmark.md`. Pasta: `.team-project/benchmark/` (dono SM, não semeada — `artifact-ownership.md` §1).

**Pergunta:** quanto da qualidade vem **do plugin** (o pipeline: plano, dev júnior, QA independente, cerimônia) e quanto vem **da especificação** que ele produz (brainstorm, SDD, protótipo, História)? A resposta é **direcional**, não estatística: a amostra é pequena, e o resultado diz isso.

## 1. Protocolo — antes de qualquer execução

1. **Itens:** de **3 a 5**, já aceitos (História) ou fechados (Correção), com evidência, cobrindo tamanhos diferentes. Para cada um: ID, tamanho, por que foi escolhido e o **commit-base** — o commit **anterior** à entrega.
2. **Braços:** A · B · C, e B′ só se a proposta `guards` estiver aplicada — definição e o que cada um isola no modelo `benchmark.md`.
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
