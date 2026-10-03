# Guardas do time — o que cobrem e o que **não** cobrem

> Dono: **stakeholder** (`hooks/` muda o comportamento do harness, como `agents/` e `commands/`). Os papéis propõem pelo `/review`; não aplicam.
> Uma guarda sem limite declarado aqui seria lida como cobertura total — e nenhuma é. **O hook vê a chamada de ferramenta, não a intenção.**

## Como funcionam

- **Requisito de ambiente:** **Windows PowerShell 5.1** (`powershell.exe`, que vem com o Windows) — é o do computador que roda os projetos. Os hooks e as conferências chamam `powershell`, nunca `pwsh`, e não usam recurso exclusivo do PowerShell 7. Os `.ps1` ficam em **UTF-8 com BOM**: sem ele, o 5.1 lê o arquivo como ANSI e quebra acentos e emojis — quem editar um `.ps1` mantém o BOM. As suítes de `scripts/checks/tests/` rodam nesse PowerShell.
- **Distribuição:** `hooks/hooks.json` viaja com o plugin; chega a todo projeto pelo `claude plugin update` e vale depois de **reiniciar a sessão**. Confira com `/hooks`.
- **Um despachante por evento** (`pre-tool.ps1`, `post-tool.ps1`, `session-start.ps1`): o PowerShell sobe uma vez por chamada de ferramenta, não uma por guarda. Funções comuns em `common.ps1`.
- **Falha aberta:** erro de script (exceção, JSON inválido) sai com código 1, que o harness lê como **não bloqueante**, e vira linha `erro` em `.team-project/guards.log`. Só o veredito explícito de uma guarda bloqueia (exit 2, motivo no stderr, que volta ao agente como erro de ferramenta — ele pode corrigir o rumo).
- **Configuração por projeto:** `.team-project/guards.json` — `disabled` (a válvula do stakeholder: guarda com falso positivo é desligada ali, na hora, e o desligamento vira achado para o `/review` seguinte), `maxInlineLines`, `probe`. Ausente → todas as guardas ligadas, com os padrões.
- **Registro:** toda negação e todo aviso vão para `.team-project/guards.log` (`data | guarda | papel | ferramenta | alvo | motivo`). Sem `.team-project/`, nada é gravado.
- **Custo medido** (Windows PowerShell 5.1, 2026-10-02): **0,6 a 0,8 s por disparo**, quase tudo subida do processo. O `PreToolUse` dispara em `PowerShell`, `Bash`, `Edit`, `Write` e `AskUserQuestion`; um `sprint run` com centenas dessas chamadas ganha alguns minutos. A sonda (`"probe": true`) grava o tempo do script em cada disparo; a subida do processo não aparece nela.

## Fase 1 (v3.39)

| Guarda | Evento · ferramenta | Regra | Decisão | O que **não** cobre |
|---|---|---|---|---|
| **G1** | `PreToolUse` · `PowerShell`, `Bash` | R31 | **nega** `git commit` com arquivo de `.team-project/` no stage, e `git add -f`/`--force` citando `.team-project` | commit feito fora do Claude Code; `git commit <caminho>` de arquivo **não** staged; comando montado em variável ou script (`& $cmd`, `.ps1` que roda git); repositório git que não é o `cwd` do projeto. A conferência C2 (`git ls-files .team-project`) pega o que escapar |
| **G2** | `PreToolUse` · `Edit`, `Write` | — (a cópia instalada é sobrescrita no update) | **nega** escrita dentro de `${CLAUDE_PLUGIN_ROOT}` quando ele **não** tem `.git/` (cópia instalada); libera no repositório-fonte | escrita pelo `PowerShell` (`Set-Content`, `Out-File`, cópia de arquivo) — o hook não lê o comando para isso; outra cópia instalada que não seja a deste plugin |
| **G3** | `PreToolUse` · `AskUserQuestion` | R22 | **nega** pergunta com menos de 2 alternativas ou cuja **última** não começa com "Pedir mais contexto" | a **qualidade** das alternativas (descritas, com custo e recomendação) — é julgamento, segue no texto de R22; pergunta feita em texto corrido, sem `AskUserQuestion` (achado contra a orquestração, R22). Vale para **toda** pergunta no projeto, inclusive fora do processo do time |
| **G4** | `PostToolUse` · `PowerShell`, `Bash` | R28 | **avisa** quando a saída passa de `maxInlineLines` (padrão 300) | saída de outras ferramentas (`Read` de arquivo grande); saída que o harness já truncou; o campo da saída no input do `PostToolUse` não é documentado — o script procura `stdout`, `output`, `content`, `result` e, sem nenhum, não avisa (a sonda registra os campos recebidos) |
| **G13** | `SessionStart` | — | **avisa** em uma linha: guardas ativas e desativadas, estado do `guards.json`, sonda | — (só informa; projeto sem `.team-project/` fica em silêncio) |

## Sonda da fase 2

A fase 2 (guardas por papel: gate protegido, teste ignorado, `Agent` só para o `operator`, matriz de propriedade, escopo do dev) depende de o hook saber **qual agente** age — o campo `agent_type` do input dentro de subagente, **não documentado** para agente de plugin. Com `"probe": true` no `guards.json`, o `pre-tool.ps1` grava em cada disparo `agent_type`, `agent_id` e o tempo do script, e o `post-tool.ps1` grava os campos de `tool_response`. Uma sessão com um `/po status` e um `/dev` de calibração basta; o resultado vai ao `/review` que abrir a fase 2. Depois, desligue a sonda (`"probe": false`).

## Testes

`powershell -NoProfile -File scripts/checks/tests/run-guard-tests.ps1`, na raiz do repositório-fonte: cada caso entrega ao despachante o JSON que o harness mandaria e confere a decisão (G1 com repositório git temporário; G2 com cópia instalada falsa; falha aberta com JSON inválido; `guards.json` desligando guarda e ligando a sonda). **O teste que vale por último é o disparo real** numa sessão com o plugin atualizado: `/hooks` listando os três eventos, e um caso de cada guarda com o texto literal devolvido ao agente.
