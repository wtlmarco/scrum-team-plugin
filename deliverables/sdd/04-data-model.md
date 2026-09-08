# Modelo — `04-data-model.md`

> **Dono:** Arquiteto · **Muda quando:** entidade, campo, enum ou relacionamento · **Revisa:** QA (código × modelo)

É o documento de maior **força de contrato** do conjunto: a grafia daqui é a grafia do código. Divergência entre os dois é achado de QA, não detalhe (regra R10).

## Estrutura

```markdown
# 04. Modelagem de Dados

## 1. Entidades principais
```text
<Lista simples de todas as entidades, para dar a visão do conjunto de uma vez.>
```

## 2. Relacionamentos
```text
<Árvore de agregação: o que pertence a quê, do raiz às folhas.>
```
Entidades transversais (não pertencem a uma única ramificação): <lista>.

## 3. <Entidade>

<Uma frase: o que representa no domínio.>

| Campo | Tipo | Obrigatório | Regra |
|---|---|---|---|
| `Id` | <tipo> | sim | — |
| `<Campo>` | <tipo> | sim/não | <invariante, default, faixa de valores> |

**Enums:** `<Enum>` = `<Valor1>` \| `<Valor2>` \| `<Valor3>`
**Relacionamentos:** <pai, filhos, cardinalidade, política de exclusão>
**Invariantes:** <o que nunca pode ser verdade>
**Índices/unicidade:** <quando relevante>

## 4. <Entidade> *(revisado vX.Y)*
…
```

## Regras

- **A grafia é literal.** `ProductionArtifact` no documento é `ProductionArtifact` no código — não `ProductionArtefact`, não `production_artifact` na camada de domínio.
- **Enum documentado é enum fechado.** Valor novo é mudança de contrato: passa pelo Arquiteto e gera migration.
- **Toda entidade declara suas invariantes.** É o que o dev transforma em guarda no construtor e o QA transforma em teste.
- **Campo opcional precisa dizer por quê.** Nulo sem justificativa vira interpretação livre na implementação.
- **Uma migration por mudança de Task.** O nome da migration entra no Plano de Implementação, não é escolhido pelo dev.
- **Numere as seções e mantenha a ordem estável.** Entidade nova entra com sufixo (`17a`) em vez de renumerar tudo — há referências cruzadas apontando para os números.

## Falhas comuns

| Falha | Consequência |
|---|---|
| Campo documentado como obrigatório e nullable no código | O QA reprova; a regra some no meio da implementação |
| Enum ampliado sem atualizar o documento | O próximo dev não sabe que o valor existe; o mapeamento de erro esquece o caso |
| Relacionamento sem política de exclusão | Descoberto em produção, quando o registro pai não pode ser removido |
| Entidade documentada e nunca implementada | Achado clássico da auditoria de conteúdo |

## Relação com os demais documentos

- Os endpoints que expõem estas entidades ficam em `05-api-model`.
- Regras de negócio que atravessam entidades ficam em `01-requirements`; aqui ficam as invariantes estruturais.
- Decisão de modelagem com alternativas relevantes vira ADR.
