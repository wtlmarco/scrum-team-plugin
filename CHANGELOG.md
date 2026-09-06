# Changelog de Entregas

> Versionamento de **entrega** do plugin, no padrão `vMAJOR.MINOR.PATCH` (`v2.x.y`).
> **Não confundir** com o [changelog do processo](roles/scrum-master/process/process-changelog.md) (`vX.Y`), que registra a evolução interna das regras de trabalho do time — esse é alimentado pelo `/review`.
>
> **Como funciona uma entrega:**
> 1. Branch `fix/vX.Y.Z` a partir de `main`.
> 2. As correções/mudanças da entrega vão nessa branch.
> 3. PR para `main` para aprovação.
> 4. Uma entrada aqui, mais recente no topo, com **o que foi entregue** e **a branch**.
>
> `MAJOR.MINOR` acompanham a versão do changelog do processo quando a entrega inclui mudança de processo; `PATCH` (`vX.Y.1`, `vX.Y.2`…) é correção sobre a mesma linha.

---

## v2.8.0 — 2026-09-06

**Branch:** `fix/v2.8.0` · **Base:** `main`

Primeira entrega versionada. Introduz o versionamento de entregas e consolida a centralização da evolução do processo.

### Entregue

- **Comando `/review` único** para evolução do processo do time — substitui os cinco modos `review` de papel (`/sm review`, `/arc review`, `/po review`, `/ux review`, `/qa review`). Triagem e curadoria no Scrum Master; a edição de cada documento continua sendo do papel dono (invariante de dono único preservado).
- **Guarda de repositório-fonte** — `/review` recusa rodar contra a cópia instalada num projeto, que o `claude plugin update` sobrescreve.
- **`note.md`** vira a fila de entrada do `/review` (sintoma → triagem → roteamento pelo SM).
- **`review-contract.md`** passa a ser o contrato do `/review`, com a tabela de alcance por papel centralizada.
- Modo `review` removido de `commands/{sm,po,arc,ux,qa,dev}.md` e `agents/*.md`; referências a `/<papel> review` reapontadas em todo o plugin. Contagem de comandos **7 → 8**.
- **Changelog do processo:** entrada `v2.8`; `v2.5` arquivada (teto de 3 — R17).
- **`replicate-in-new-project.md`:** deduplicação do bloco de instalação (fonte única: `how-to.md`) e da árvore `.team-project/` (fonte única: `roles/scrum-master/templates/project-context.md`).
- **Versionamento de entregas** — este `CHANGELOG.md`, a linha de versão no `README.md` e `.claude-plugin/plugin.json` sincronizado para `2.8.0`.

### Verificação

- `claude plugin validate . --strict` passa.
- `claude plugin details team@team` deve listar 8 comandos (`sm po arc ux dev qa team review`) e 6 agents — após reiniciar a sessão.
