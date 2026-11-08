# Decisões do stakeholder sobre o plugin-report (sprint 5 do garden) — 2026-11-07

Origem: `melhorias/plugin-report.md`; sintomas numerados em `note.md` (itens 1 a 10). Escolhas feitas em formulário. **Nada implementado ainda**, exceto o item 1.

| Item | Decisão | Onde mexe |
|---|---|---|
| 1 Reparo sem prazo / pipe herdado | FEITO: `Invoke-CmdTx`, `repairTimeoutSec` (600 s) | `scripts/checks/targets/android.ps1` |
| 2 Sessão não reabre | **Prazo explícito no `next`**: ao responder "esperar", devolve a hora da próxima conferência e o comando; `sprint-run.md` proíbe encerrar o turno sem esse prazo | `run.ps1 next`, `sprint-run.md` |
| 3 `operator` entrega sem estado final | **Bloquear até o resultado** (usa o prazo do item 1); proibido mandar o reparo para segundo plano | prompt do `operator`, R28 |
| 4 Encerrar processo do alvo | **`target.ps1 -Kill`**: encerra só processos registrados pelo run (PID gravado ao iniciar / emulador do serial configurado), vai ao run-log; G14 segue negando `Stop-Process` solto | `target.ps1`, `targets/android.ps1`, G14 (mensagem), `sprint-run.md` item 5 |
| 5 Cartão × plano | **Cartão lê o plano**: se o plano declara que o aceite não roda, o `start` troca o comando pela justificativa | `run.ps1 start` |
| 6 `# aguarda` em ciclo | **Detectar ciclo e auto-espera**: ignora `aguarda` para a própria Task ou para a mãe dividida em A/B; `next`/`plan.ps1` avisam o ciclo com as Tasks envolvidas | `run.ps1`, `plan.ps1` |
| 7 Gate de ids | **Os três**: aviso quando o atributo usado diverge de `testIds.attribute`; ids dinâmicos declarados (`testIds.dynamic` ou `// testid-dinamico: <motivo>`, resultado INCONCLUSIVO só para eles); id dinâmico confirmado pelo accept | `verify.ps1` passo `testids`, `guards.json`, `accept.ps1` |
| 8 Tempo do `verify` | **Detectar salto de relógio** (parede × monotônico/CPU) e repetir a rodada, registrando "suspensão detectada". Cobertura "não medido": fora, sem causa | `verify.ps1` |
| 9 GAPs de aparência | **Os quatro**: envelope de decisão no plano; classificar o GAP ao abrir (aparência/desenho/produto); agrupar GAPs de aparência da mesma Task; sonda de medida no cartão | `plan.ps1`, `sprint-run.md` passo 4, `run.ps1 start`, prompts Arquiteto/dev |
| 10 G14 × Bypass | **Só a mensagem**: mantém a negação e aponta a rota oficial | `hooks` (G14) |

| 11 (A6) Mutante do plano não compila, visto só após ~20 min | **Precheck obrigatório na entrega** (o `start`/roteiro só entrega o plano ao dev com `verify -Mode mutation -Precheck` verde registrado) **+ aviso alto sem `verify.compile`** (Precheck e `plan.ps1` dizem que a compilação dos mutantes não foi conferida). Na mutação: **rodar todos e listar os inconclusivos no fim**, para o Arquiteto corrigir de uma vez. Fora: compilação padrão por stack; reexecutar só o corrigido | `verify.ps1` (Precheck, resumo da mutação), `plan.ps1`, `run.ps1 start`, `sprint-run.md` |

| 12 (APK) Build sem protocolo | **Build pelo `Invoke-Bounded`** com prazo declarado (`verify.buildTimeoutMinutes`, ou o `verify.timeoutMinutes` existente) e `-KeepDescendants` para não matar o daemon do Gradle. Build rodado à mão pelo dev passa a seguir o mesmo protocolo (prazo + espera declarada) | `verify.ps1`, `lib.ps1`, `sprint-run.md` §Disparo e espera item 5, `operator` |
| 13 (APK) Sonda de progresso do build para o vigia | O vigia lê sinais de vida do build: `build/outputs/apk/` mudou, log do build cresceu, CPU. Sem sinal por 10 min = POSSÍVEL TRAVAMENTO. **Depende do build do projeto (Gradle, Ionic/Capacitor, outro): comando de build ainda não informado** | `run.ps1 next` (sinal de vida), vigia |
| 14 (APK) Conferência do APK ao fim do build | Logo depois do build, conferir que o APK é mais novo que o código (`Get-ApkStaleness`, hoje só no `accept`); APK velho vira aviso no fim do build, não exit 2 no accept | `accept.ps1`/`lib.ps1` (`Get-ApkStaleness`), `verify.ps1` |

Antes de implementar o 11: conferir no run-log do projeto qual causa ocorreu (projeto sem `verify.compile`, Precheck não rodado, ou Precheck que deixou passar). Caminho do log não está neste repositório.

## Teste do vigia (07/11, branch feat/v3.57.0)
Agente barato (haiku, só PowerShell), `Start-Sleep 60`, turno da sessão encerrado sem sondar. **Resultado:** o aviso de conclusão chegou ~68 s depois e reabriu a sessão com a linha do vigia. O desenho "conferência por agente barato" funciona.
**Não coberto pelo teste:** com `.active-run` e as guardas G20/G22 ativas; a exceção da R1 (um agente por vez); o cancelamento por `TaskStop` quando o aviso real chega antes; a espera de 15 min em duas chamadas (teto de 10 min por chamada).

**Segundo achado (15:09):** o vigia pediu um comando de até 570 s e o ambiente o moveu para segundo plano após **180 s**, não 600 s. O vigia encerrou o turno cedo ("sem resultado ainda"), mas o aviso dele diz que volta sozinho quando o trabalho em segundo plano termina — e o mesmo task-id notifica de novo. Consequências para o protocolo: (a) o prazo por chamada do vigia é ~170 s; esperas longas = várias chamadas curtas OU confiar no segundo aviso; (b) o primeiro aviso pode ser parcial e precisa ser lido como "ainda não", nunca como veredito.

Pendente: versão e branch (`fix/` ou `feat/` a partir de `develop`), com o plugin congelado até o teste P-r2; teste automatizado de cada item; CHANGELOG.
