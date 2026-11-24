# Plano da v3.66.1 — a suíte do plugin mais rápida e que sobrevive à sessão

**Branch:** `fix/v3.66.1`, a partir de `develop` com a v3.66.0 mesclada (`84ac1ef`, PR #225).
**Origem:** as rodadas da suíte durante a v3.66.0 (23 e 24/11):
- 16 minutos de parede com 4 processos;
- 48 falhas por tempo esgotado numa rodada com 8 processos e a máquina carregada;
- duas rodadas perdidas porque a sessão caiu no meio;
- o caso host_pid falhando em toda rodada separada.

**Status:** aprovado pelo stakeholder em 24/11. Só testes e o script que os roda; **nada muda no comportamento do plugin** nos projetos.

## 0. O que a medição achou

Medido na última rodada completa da v3.66.0 (`run-all-tests.ps1 -Workers 4`, 1289 casos) e no `test-times.json`:

| Medida | Valor | Leitura |
|---|---|---|
| Parede | 978 s (16 min) | com 4 processos; com 8 e a máquina carregada, 1.769 s e 48 falhas por tempo esgotado |
| Soma do trabalho | ≈ 4.200 s (3.688 s nos blocos de conferência + 509 s nas guardas) | a parede fica perto de soma ÷ processos: **o que manda é o total de trabalho** |
| Abrir um PowerShell | 0,16 s vazio · 0,41 s com `lib.ps1` + `common.ps1` | ≈ 1.300 aberturas ≈ 2 min de parede: não é o gargalo |
| Casos que esperam o relógio | paridade do cdp (7 variantes, 50 a 135 s), mutação (20 a 30 s cada), verify completo, OCUPADO (32 s), suíte perto do teto (23 s), protocolo de espera (25 s) | são os mesmos que estouram o prazo com a máquina carregada |
| Suíte das guardas | 509 s, em série | um caso herda o estado do anterior (o `fixes/B-001` aberto de outro caso mudou a trilha do teste do item J na v3.66.0) |
| Sessão que cai | a rodada morre junto | duas rodadas perdidas; a saída só aparece no fim |
| `Registro do Agent (host_pid)` | falha em toda rodada fora da sessão | o teste confere o processo do Claude Code, que não existe num processo separado |

## 1. Itens

### A · Nível "lento" (prioridade alta)
**Proposta:** (`scripts/checks/tests/run-all-tests.ps1`, `suite-blocks.ps1`)
- O caso cujo último tempo medido no `test-times.json` passa de **20 s** entra no nível lento, sem lista à mão: o caso que ficar mais rápido sai sozinho.
- O bloco com caso lento é marcado; o resto do bloco roda no nível rápido quando é possível separar a unidade do caso lento (a mesma regra de dependência do `suite-blocks.ps1`).
- **Sem parâmetro:** pula o nível lento, e é a rodada do dia a dia. A saída diz quantos casos ficaram de fora e quanto tempo isso poupou.
- **`-Full`:** roda tudo, e é a conferência antes do PR. O cabeçalho do script, o `rituals/review-contract.md` e o CHANGELOG passam a dizer isso.
- Caso sem tempo medido (novo) roda no rápido até ser medido.

**Testes:** classificação pelo tempo (acima e abaixo de 20 s, sem medição) · sem parâmetro pula os lentos e diz quantos · `-Full` roda todos · o caso que ficou rápido sai do lento na rodada seguinte.

### B · Só o que a mudança toca: `-Changed` (prioridade alta)
**Proposta:** (`run-all-tests.ps1`)
- **O que mudou:** os arquivos alterados em relação à `develop`, nos commits da branch e no disco (`git diff --name-only develop...HEAD` + `git status`).
- **Blocos de conferência:** os que chamam um script alterado (`Invoke-Check '<script>.ps1'`, `-File <script>.ps1`, `. <script>.ps1`), mais o C3 (`release.ps1`) sempre.
- **Biblioteca comum alterada** (`lib.ps1`, `hooks/common.ps1`, `plain.ps1`, `impasse-lib.ps1`, `hooks/*.json`): roda tudo, porque todos os scripts as carregam.
- **Hook alterado:** roda a suíte das guardas (com o C, só os grupos que chamam o hook alterado).
- **Só documento alterado** (`*.md`): roda o C3 e os blocos que leem o documento citado no teste (o modelo do plano, a matriz).
- A saída lista o que mudou e por que cada bloco entrou.
- `-Changed` não substitui o `-Full` antes do PR.

**Testes:** mudança só num script de borda (`kanban.ps1`) roda só os blocos dele e o C3 · mudança em `lib.ps1` roda tudo · mudança num hook roda as guardas · mudança só num `.md` roda o C3 · sem mudança nenhuma, só o C3.

### C · As guardas em grupos paralelos (prioridade média)
**Proposta:** (`run-guard-tests.ps1`, `run-all-tests.ps1`)
- A suíte das guardas se divide nas seções que já existem (`# ---------- vX.Y — … ----------`), e cada grupo roda num processo com o seu `$tmp` e o seu projeto falso, montado pelo mesmo preâmbulo.
- **Conferência de independência** (`run-guard-tests.ps1 -CheckGroups`): roda cada grupo sozinho e acusa o grupo que só passa depois de outro. O grupo acusado ganha o `Setup` que faltava (o estado que ele herdava passa a ser montado nele), e não se juntam grupos para esconder a dependência.
- O `run-all-tests.ps1` distribui os grupos das guardas junto com os blocos de conferência, pelo mesmo equilíbrio de tempos.
- `run-guard-tests.ps1` sozinho continua rodando tudo em série, como hoje.

**Testes:** a conferência de independência acusa um grupo que depende de outro (um caso de exemplo) · a contagem de casos das guardas é a mesma em série e em grupos · os grupos rodam em paralelo no `run-all-tests.ps1`.

### D · Rodada que sobrevive à sessão (prioridade alta)
**Proposta:**
- **`run-all-tests.ps1 -Detach`:**
  - sobe a suíte num processo separado, que continua se a sessão do Claude Code cair;
  - grava o log, um resumo (`summary.txt`: contagem, falhas com a saída, os mais lentos, a parede) e, no fim, a linha `FIM exit=<código>`;
  - volta na hora com o caminho e o pid.
- **`-Wait <caminho>`:** espera o `FIM` (ou o processo morrer) e imprime o resumo, como o vigia que usei na v3.66.0.
- **O caso host_pid deixa de depender da sessão:** o teste simula o processo hospedeiro (variável de ambiente que só a suíte liga, lida pelo `Get-HostProcess` do `hooks/common.ps1`). O caso continua provando que o registro do Agent leva o host vivo e o horário dele.

**Testes:** `-Detach` volta com o caminho e o processo segue · o resumo traz contagem e falhas · `-Wait` devolve o código · o host_pid passa fora da sessão.

### E · Processos em paralelo pela máquina (prioridade média)
**Proposta:** (`run-all-tests.ps1`)
- O padrão de `-Workers` passa a ser o menor entre: núcleos − 1, memória livre em GB ÷ 1,5 (cada processo da suíte com um projeto falso e uma suíte falsa chega a ~1,2 GB no pico) e **6**.
- Com a memória livre abaixo de 4 GB, sobe no máximo 2 processos e avisa ("máquina ocupada: N processos; a rodada fica mais lenta").
- `-Workers <n>` continua valendo quando dado.

**Testes:** a conta pelos três limites (núcleos, memória, teto) · o aviso com memória baixa · o `-Workers` explícito vence.

### F · Os casos lentos, um a um (prioridade média)
**Proposta:**
- Os casos que esperam o relógio de verdade passam a usar prazos de teste curtos, por variável de ambiente que só a suíte liga (`TEAM_TEST_FAST_CLOCK`), lida pelos scripts nos pontos de espera:
  - o `-WaitBusySeconds` do verify;
  - o teto por comando;
  - a espera do `run.ps1 wait`;
  - o prazo do mutante a frio;
  - a sonda do watcher.
- **O que cada caso confere não muda; muda só quanto tempo ele espera.** Na produção a variável não existe, e o prazo é o de sempre.
- Alvo: os 12 casos mais lentos da última rodada, exceto a paridade do cdp, que abre um navegador de verdade e fica no nível lento.
- Cada caso mexido mede antes e depois na mesma máquina, no CHANGELOG.

**Testes:** os próprios casos mexidos passam com o relógio curto · um caso novo confere que, sem a variável, o prazo é o de produção (o script lê o valor real).

## 2. Fora desta entrega
- **Rodar os scripts dentro do mesmo processo**, sem abrir um PowerShell por caso. Os scripts escrevem direto no console (`[Console]::Out`) e terminam com `exit`, e capturar isso dentro do processo exigiria refazer a saída de todos eles. O ganho medido é de uns 2 minutos de parede.
- **Mudar o que algum caso prova.** Caso que estiver redundante com outro vai como achado no CHANGELOG, para decisão à parte, e não sai nesta entrega.

## 3. Entrega
- **Ordem:** D e A primeiro (o dia a dia e a rodada que não morre), depois B, E, C e F.
- **Metas, medidas na mesma máquina e no CHANGELOG:**
  - rodada do dia a dia (padrão ou `-Changed`) até 5 minutos;
  - `-Full` até 10 minutos, contra 16 hoje, e sem falha por tempo esgotado com a máquina carregada;
  - rodada separada com 0 falhas quando tudo está certo.
- **Suítes:** a `-Full` completa antes do PR, com o C3; os casos novos marcados `v3.66.1`.
- **Documentação:** cabeçalho do `run-all-tests.ps1`, `rituals/review-contract.md` (a conferência antes do PR é o `-Full`), CHANGELOG e `process-changelog.md` (se a regra da conferência mudar de texto).
- Commit e PR só a pedido.
