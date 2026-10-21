# Template — Validação do sprint (portão do QA, v3.51)

Salvo em `.team-project/sprints/<n>/validation.md`. É o **portão de validação do produto entregue pelo dev**, uma passada só no fim da construção e **premissa da Sprint Review** (`sprint-run.md` §Validação do sprint). Substitui a verificação do QA Task a Task: as Tasks fecharam pela evidência do dev (verify, mutação e os cenários da Task no alvo — `close.ps1`, R7-aceite).

**O QA não roda comando longo** (o cache da instância dele dura 5 min): as medições chegam prontas do `operator` — `scripts/checks/quality.ps1 -Id S<n>` e `scripts/checks/accept.ps1 -Task S<n>` (todos os cenários do sprint, no alvo real, com captura de cada um). O QA lê, confere e julga.

```markdown
# Validação do sprint <n>

**Veredito:** ✅ aprovado | ⚠️ aprovado com ressalva | ❌ reprovado — <aaaa-mm-dd hh:mm>
**Árvore validada:** `<12 primeiros do result.json>` · **Rodada:** <1, 2…>

## 1. Funcional — prova no alvo real

`.team-project/accept/<n>/S<n>/result.md` — <passaram> de <total> cenários, alvo <android|web>, <data>.

| Cenário | História | Resultado | Prova (captura) | Observação |
|---|---|---|---|---|
| SC-<nnn> | H-<nnn> | ✅ / ❌ / não exercitado | `shots/SC-<nnn>-final.png` | <o que a captura mostra, quando conta> |

*(Cenário "não exercitado" — alvo indisponível — reprova o portão: é bloqueio de ambiente, nunca aprovação.)*

## 2. Qualidade de código — medida

`.team-project/quality/<n>/S<n>/result.md`

| Regra (standards nível 1, §7) | Resultado | Número |
|---|---|---|
| Q11 cobertura ≥ limiar em cada módulo | ok / falhou / não configurado | <pior módulo × limiar> |
| Q1 regra de dependência | | |
| Q6 limites numéricos | | |
| Q7 lint e formatação | | |
| Q8 duplicação | | |
| Q9 TODO com ID | | |
| Q17 supressão justificada | | |

## 3. Qualidade de código — julgamento

O que a ferramenta não mede, com `arquivo:linha` e a seção de `standards/` que embasa (o perfil da tecnologia em `standards/stacks/<tecnologia>/`):

| Frente | Resultado | Achados |
|---|---|---|
| SOLID e responsabilidade única | ✅ / ⚠️ / ❌ | |
| Clean code (nomes, funções, corpo — §4.1 a §4.3) | | |
| Aderência à arquitetura do SDD e aos planos (diff × **Arquivos tocados:**) | | |
| Padrões de escrita da tecnologia | | |
| Segurança (`implementation-security-lgpd-copyright.md`, checklist do projeto) | | |
| Testes que protegem algo (§5.2) — amostra | | |

## 4. Achados

| # | Task | Achado | Onde (`arquivo:linha`) | Volta para | Estado |
|---|---|---|---|---|---|
| 1 | T-<nnn> | <o que está errado e o que o standard pede> | | dev · Arquiteto (dúvida de desenho) | aberto · corrigido em <data> |

## 5. Consolidação dos documentos vivos (R12)

*(Preenchida pelo Arquiteto depois do veredito ✅ — uma vez no sprint, A5.)*
**Estado:** feita | pendente — <aaaa-mm-dd>
- <documento> — <o que mudou> — <dono>
```

## Regras

- **Uma passada, o incremento inteiro.** O QA olha o todo, não Task a Task; o diff do sprint e os planos são a base da aderência.
- **Achado tem endereço:** `arquivo:linha` ou saída de comando, a regra (`Q<n>` ou a seção) e para quem volta. Sem isso é suspeita, não achado.
- **Achado de execução volta ao dev** (Haiku, retomável); **dúvida de desenho, ao Arquiteto** (instância nova, com o caminho deste arquivo). Depois da correção, o `operator` mede de novo o que mudou e o QA, em instância nova, revisa o veredito **neste mesmo arquivo** (nova rodada, sem apagar a anterior).
- **⚠️ aprovado com ressalva** só com o achado aceito pelo PO como dívida, com Task no backlog.
- **A Review só abre com ✅ ou ⚠️** e com a consolidação dos documentos vivos feita.
