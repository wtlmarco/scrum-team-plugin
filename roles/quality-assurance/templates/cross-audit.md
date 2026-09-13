# Template — Auditoria Cruzada (`/qa audit`)

Rodar a cada 3 ciclos. Dois passes, para não gastar contexto à toa (R3). **Não corrigir nada — só listar.**

## Passe 1 — mapeamento (barato: só documentos)

Compara o documento de status, o escopo/critérios, o inventário de código e o registro de GAPs entre si.

```markdown
## Auditoria — Passe 1 (mapeamento) — <data>

### 1. Concluído sem código correspondente
| Task marcada como concluído | Onde | Arquivo esperado no inventário | Situação |
|---|---|---|---|

### 2. Código sem tarefa correspondente (possível scope creep)
| Arquivo | Sprint/Task declarado | Tarefa correspondente | Situação |
|---|---|---|---|

### 3. Decisões que já deveriam ser ADR
| Decisão | Onde está registrada | Por que deveria ser ADR |
|---|---|---|

### 4. Divergência entre status e GAPs abertos
| Critério / requisito | O status diz | O registro de GAPs diz | Quem tem razão |
|---|---|---|---|

**Pontos suspeitos para o Passe 2:** <lista curta — só o que justifica ler código>
```

## Passe 2 — conteúdo (caro: com código, só nos pontos suspeitos)

```markdown
## Auditoria — Passe 2 (conteúdo) — <data>

**Escopo lido:** <arquivos, e por que estes>

### 1. Divergências de nomenclatura
| Especificado | Implementado | Onde | Documento de referência |
|---|---|---|---|

### 2. Implementado e não especificado
| Entidade / campo / endpoint | Onde | Risco |
|---|---|---|

### 3. Especificado e não implementado (em escopo já fechado)
| Especificação | Documento | Deveria estar em | Impacto |
|---|---|---|---|

### GAPs a abrir
| ID proposto | Criticidade | Origem | Resumo |
|---|---|---|---|
<!-- Origem: quase sempre `time` (auditoria é levantamento do próprio QA); `stakeholder` só quando o achado confirma um relato que já havia chegado pelo PO. -->

### Achados de processo em `${CLAUDE_PLUGIN_ROOT}/standards/` — rota `/review`
| Onde (`<arquivo> §<n>`) | Sinal (contradição / lacuna / inverificável) | Resumo |
|---|---|---|

### Não-gaps confirmados
- <tema> — <por que está correto>
```

## Regras

- **Passe 2 só nos pontos que o Passe 1 apontou.** Ler tudo "por garantia" é o oposto de eficiência (R3).
- **Nada é corrigido na auditoria.** O resultado vira GAPs; o SM enfileira.
- **Incoerência dentro de `${CLAUDE_PLUGIN_ROOT}/standards/`** (contradição entre seções, regra sem verificação, perfil de nível 2 que afrouxa o nível 1) é **achado de processo roteado ao `/review`** (R16) — não vira GAP de projeto e não se corrige aqui. Achar e rotear; a caneta do normativo é do Arquiteto.
- **Confirmar não-gap é entrega**, não sobra: poupa a próxima auditoria.
- A auditoria é o mecanismo que impede o retorno do problema mais comum de projeto longo: documentação descrevendo um sistema que não existe mais.

O resultado da última auditoria deste projeto está em `.team-project/quality-assurance/context.md`.
