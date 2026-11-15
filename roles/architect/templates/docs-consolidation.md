# Template — Consolidação dos documentos vivos (`sprints/<n>/docs-consolidation.md`)

Salvo em `.team-project/sprints/<n>/docs-consolidation.md`, uma vez por sprint, depois do veredito ✅ (ou ⚠️ aceito) do portão do QA (R12, A5). Dono: Arquiteto. Fontes: as seções "Documentos vivos (R12)" de `sprints/<n>/delivery/*.md` e `architect/decisions/S<n>.md`.

**O `run.ps1 next` lê este arquivo (v3.59.2).** O formato abaixo não é estético: o script lê as tabelas e age por elas.

- **`## Aplicado pelo Arquiteto`:** cada documento citado tem de ter mudado no sprint, com alteração pendente no disco ou commit desde a 1ª linha do `run-log.md`. Sem mudança, o Arquiteto é chamado de novo uma vez, para aplicar a mudança ou mover a linha para `## Sem mudança`. Se ainda assim o documento não mudar, vira pendência da Review.
- **`## Pedidos aos donos`:** o script dispara o dono da última coluna (PO, UX, SM ou QA), uma vez, com os documentos dele. O pedido conta como aplicado quando o documento muda depois de o pedido aparecer. Pedido não aplicado vira pendência da Review.
- **Commit:** o script versiona os documentos das duas tabelas num commit próprio, `docs(sdd): consolidação dos documentos vivos do sprint <n>`, separado dos commits das Tasks. **O Arquiteto e os donos não fazem commit.**

Regras do formato:

- **1ª linha:** `**Estado:** feita`. Enquanto ela não existir, o next chama o Arquiteto.
- **1ª coluna:** o caminho de cada documento entre crases, relativo à raiz do projeto (`` `docs/sdd/api-spec.md` §2.4``). Mais de um documento na mesma linha: um par de crases para cada. Nome sem pasta herda a pasta do primeiro caminho da célula.
- **Última coluna de `## Pedidos aos donos`:** só a sigla do dono — `PO`, `UX`, `SM` ou `QA`.
- **Arquivos de `.team-project/`:** não entram nas tabelas, porque são registro do time e não documento do produto.

```markdown
**Estado:** feita

# Sprint <n> — consolidação dos documentos vivos (R12)

**Autor:** Arquiteto · <data> · fontes: <relatórios lidos, decisões>

## Aplicado pelo Arquiteto

| Documento | O que mudou | Task / decisão |
|---|---|---|
| `docs/sdd/api-spec.md` §2.4 | linha nova `marcarPerdido(id, motivo)` | T-041 |
| `docs/sdd/adr/0011-transacao.md` | usos vigentes: as duas `remover` | T-059, T-060 |

## Pedidos aos donos

| Documento | O que mudar | Origem | Dono |
|---|---|---|---|
| `docs/sdd/requirements.md` RF-MAN-02 | manejo para vários canteiros, tudo ou nada | T-060 | PO |
| `docs/sdd/implementation/status.md` | retrato do sprint <n> | — | SM |

## Sem mudança

| Task | Motivo |
|---|---|
| T-065 | investigação, sem código de produto |
```
