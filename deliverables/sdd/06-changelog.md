# Modelo — `06-changelog.md`

> **Dono:** PO · **Muda quando:** toda mudança funcional aceita · **Revisa:** SM (no fechamento da Task)

É a memória de **como o desenho chegou até aqui**. Sem ele, retomar um projeto meses depois exige arqueologia: o "por quê" de cada decisão desaparece e volta a ser discutido do zero.

## Estrutura

```markdown
# 06. Changelog

## vX.Y → vX.Z (<data>)

**Motivação:** <o que provocou a mudança — requisito novo, achado, decisão do stakeholder>

### Alterado
| Documento | Seção | Mudança |
|---|---|---|
| `01-requirements.md` | RF-0nn | <o que mudou, em uma linha> |
| `04-data-model.md` | §<n> | <campo/entidade acrescentada ou alterada> |

### Decisões
- **<decisão>** — <justificativa em uma frase>. <Virou ADR-nnn | registrada aqui apenas.>

### Impacto
<O que precisa mudar no código, se já houver implementação; ou "nenhum — mudança só de especificação".>

## vX.X → vX.Y (<data>)
…
```

## Regras

- **Cumulativo e em ordem inversa** — a versão mais recente no topo. Nunca reescrever entrada antiga: correção vira entrada nova.
- **Uma entrada por mudança de versão do conjunto**, não por arquivo alterado. Os sete documentos de conteúdo do SDD evoluem juntos.
- **Motivação é obrigatória.** O que mudou dá para ver no diff; *por que* mudou, não.
- **Decisão relevante aparece aqui e no seu lugar próprio** — ADR se for estrutural, "decisões tomadas" no documento de status se for de implementação. O changelog registra que existiu.
- **Mudança funcional aceita sem entrada no changelog bloqueia o fechamento da Task** (regra R12).

## Falhas comuns

| Falha | Consequência |
|---|---|
| Changelog que lista arquivos alterados, sem o porquê | Vira um `git log` pior; ninguém consulta |
| Entrada escrita meses depois, em lote | A motivação já se perdeu; o registro fica genérico |
| Decisão registrada só no changelog | Quem procura a decisão pelo assunto não a encontra — precisa varrer o histórico |

## Relação com os demais documentos

O changelog é o **único** documento do conjunto que só cresce. Os outros seis descrevem o estado atual; este descreve o caminho. Quando os dois divergem, o estado atual vence — e a divergência vira entrada nova.
