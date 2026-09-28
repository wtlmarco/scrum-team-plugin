# Template — Índice da Suíte de Cenários (`scenarios/README.md`)

> **Dono:** QA · **Vive em:** `.team-project/quality-assurance/scenarios/README.md` · **Atualizado:** toda vez que um cenário nasce, muda de tipo (raro — regressivo que vira também critério de uma Task nova continua um único registro) ou é retirado por o fluxo que ele cobria ter deixado de existir
>
> A suíte **acumula através dos sprints** (`artifact-ownership.md` §1c, §1e): não fecha nem se fatia por sprint — é a base de todo regressivo futuro, e fatiá-la apagaria exatamente o que ela existe para enxergar. Um arquivo por cenário (`SC-nnn-<slug>.md`, modelo em [`scenario.md`](scenario.md)); este índice é a **navegação**, não uma cópia do conteúdo.

## Estrutura

```markdown
# Suíte de Cenários de Teste — Índice

> **DOCUMENTO VIVO** · **Dono:** QA · **Atualizado em:** <data>
> Um arquivo por cenário em `.team-project/quality-assurance/scenarios/SC-nnn-<slug>.md`. Este índice organiza a navegação e a busca por fluxo — nunca duplica o conteúdo do cenário.

## 1. Por ID

| ID | Título | Tipo | Origem (H-nnn) | Fluxos que toca | Última execução | Último resultado |
|---|---|---|---|---|---|---|
| [SC-001](SC-001-<slug>.md) | <título> | novo / regressivo | H-<nnn> | <fluxo(s)> | <data> | ✅ / ❌ / ⚠️ não executado |

## 2. Por fluxo funcional — a tabela que sustenta a escolha de regressivo

<Agrupamento invertido da tabela acima: cada fluxo de `02-flows-and-roles` (ou jornada do UX) lista os cenários que o tocam. É a consulta que a Planning faz para achar regressivo aplicável a uma Task nova (R30) — ver `scenario.md`, seção "Como escolher regressivos".>

| Fluxo funcional | Cenários que o tocam |
|---|---|
| <nome do fluxo, igual à grafia de `02-flows-and-roles`> | SC-001, SC-014, SC-027 |

## 3. Cenários com falha aberta

<Cenário cujo último resultado registrado é ❌, ainda sem correção revalidada — é o que a próxima Task que tocar o mesmo fluxo precisa saber antes de reexecutar. Vazio quando não há nenhum.>

| ID | Fluxo | Falhou em (data/Task) | GAP relacionado |
|---|---|---|---|
| SC-027 | <fluxo> | <data> / T-<nnn> | <ID de `pending.md`, se já aberto> |

## 4. Cenários "não executado — sem ferramenta"

<Cenário de interface que não rodou porque a extensão `mcp__claude-in-chrome` não estava conectada na sessão que executou (o card do QA e o do `operator` já carregam a ferramenta — R28). Lista separada porque não é falha do cenário nem do código — é limitação declarada de ambiente (R7), e a linha some na próxima execução com a extensão conectada, ou passa a rodar por script/CLI.>

| ID | Fluxo | Desde quando | Alternativa de execução avaliada |
|---|---|---|---|

## 5. Manutenção deste índice

- Cenário novo entra na tabela §1 e em toda linha de §2 correspondente aos fluxos que declara, na mesma sessão em que o arquivo nasce.
- Toda execução registrada no Histórico do próprio cenário atualiza "Última execução"/"Último resultado" aqui — nunca os dois documentos divergindo sobre a mesma data.
- Cenário cujo fluxo deixou de existir (funcionalidade removida) não é apagado — a linha registra "fluxo descontinuado em <data>, ver <onde a remoção foi decidida>", pelo mesmo motivo que `pending.md` mantém a seção de resolvidos em vez de apagar.
```

## Regras

- **O índice nunca copia o conteúdo do cenário** — pré-condição, passos, resultado esperado ficam só no arquivo `SC-nnn`. Duplicar aqui é o mesmo erro que a v3.21 corrigiu no Product Backlog (`artifact-ownership.md` §1d).
- **A tabela §2 (por fluxo) é a peça funcional do índice** — sem ela, escolher regressivo na Planning exigiria abrir todo cenário um a um. Índice sem §2 preenchida é achado de processo.
- **§3 e §4 existem para não esconder dívida** — cenário com falha aberta ou nunca executado por falta de ferramenta não desaparece silenciosamente entre os que passaram.
- **Toda linha da tabela §1 tem link que resolve** para o arquivo do cenário — ponteiro quebrado é achado de processo, mesma régua de qualquer outro ponteiro do QA (`verdict.md`, "Log bruto referenciado precisa resolver").

## Quando este documento nasce

Junto com o primeiro cenário da suíte — tipicamente na primeira Planning Meeting do projeto que mapeia cenários (R30), ou, em projeto retomado, quando `/qa baseline`/`/qa audit` identifica cenários funcionais já cobertos por teste existente e os retroalimenta na suíte.
