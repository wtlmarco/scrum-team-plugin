# Template — Requisito

Entra no documento de requisitos do projeto (caminho em `.team-project/README.md` §4), seguindo a numeração existente.

```markdown
### <ID> — <título curto e afirmativo>

**Objetivo relacionado:** <ID do objetivo>
**Atores:** <quem executa>
**Precondições:** <estado necessário antes>

**Enunciado**
<O sistema deve ... — uma frase, na voz do produto, sem solução técnica.>

**Regras**
1. <regra de negócio, com o nome exato das entidades e enums da especificação>
2. <estados permitidos e transições>

**Casos de borda**
- <o que acontece quando não há dado / o dado é inválido / o recurso pertence a outro escopo>

**Erros esperados**
| Situação | Tipo/código | Status |
|---|---|---|

**Orçamento de desempenho** *(obrigatório se o requisito fixa tempo de resposta ou vazão — P1, `implementation-principles.md` §5.6)*
| Operação | Métrica | Limiar | Condição de carga | Ambiente |
|---|---|---|---|---|
| <caminho de uso real, nunca "o sistema"> | <percentil, nunca média> | <número + unidade> | <taxa/usuários **e** duração> | <onde o número vale — V21> |

**Critério de aceite**
- [ ] Dado <contexto>, quando <ação>, então <resultado observável>
- [ ] Dado <contexto de erro>, quando <ação>, então <erro esperado>
- [ ] *(se toca operação sob orçamento)* Dado <condição de carga>, quando <operação>, então <métrica> ≤ <limiar> — comprovado pela saída do comando de carga (V19)

**Como verificar**
```
<chamada com método, rota e corpo — ou passo de UI>
→ <resposta esperada>
```

**Fora do escopo**
- <o que este requisito explicitamente NÃO cobre>

**Impacto em requisitos existentes:** <ID alterado | nenhum>
```

## Regras

- Numeração **nunca reaproveitada**; requisito descontinuado é marcado, não apagado.
- Grafia de entidade, campo e enum idêntica à especificação (R10).
- Critério de aceite sem "como verificar" não é critério.
- "Fora do escopo" é obrigatório — é o que impede o dev de antecipar escopo (R4).
- O contrato de erro do projeto (formato, tipos, status) está no contexto do PO.
- **Requisito de performance só entra com os cinco campos do orçamento** (operação · métrica/percentil · limiar · condição de carga com duração · ambiente). Menos que isso, o Arquiteto devolve e o item não entra em construção (§7 #18). A forma completa, com exemplo e contraexemplo, está em [`../../../deliverables/sdd/01-requirements.md`](../../../deliverables/sdd/01-requirements.md).
- **Se o requisito toca uma operação sob orçamento** (Ficha V18), o critério de aceite **menciona o desempenho** — operação, percentil, limiar — com "como verificar" apontando o comando de carga (V19). RNF no documento de requisitos **não** substitui o critério verificável no item.

## Exemplo

```markdown
### RF-017a — Baixar o arquivo de uma entrega por link temporário

**Objetivo relacionado:** OBJ-004 · **Atores:** usuário autenticado, dono do recurso
**Precondições:** existe uma entrega em estado pronto

**Enunciado**
O sistema deve permitir baixar o arquivo de uma entrega através de uma URL temporária e revogável, sem expor o armazenamento subjacente.

**Regras**
1. A URL é obtida por um endpoint dedicado e vale por tempo limitado.
2. A autorização do download é a própria assinatura da URL — o endpoint de download não exige token.
3. A assinatura cobre o caminho lógico do arquivo e o instante de expiração.

**Casos de borda**
- Entrega de outro escopo → tratada como inexistente (404), nunca 403.
- Assinatura válida para outro arquivo → recusada.

**Erros esperados**
| Situação | Tipo/código | Status |
|---|---|---|
| Assinatura expirada | `signature-expired` | 410 |
| Assinatura inválida | `signature-invalid` | 403 |
| Entrega inexistente | `delivery-not-found` | 404 |

**Critério de aceite**
- [ ] Dado uma entrega pronta, quando acesso a URL assinada, então recebo 200 e o arquivo íntegro
- [ ] Dado uma URL expirada, então recebo 410
- [ ] Dado uma URL com o caminho alterado, então recebo 403

**Como verificar**
```
GET <endpoint da URL>       → 200 { "url": "..." }
GET <url>                   → 200 + arquivo
GET <url expirada>          → 410
```

**Fora do escopo**
- Download em lote; player inline; armazenamento remoto.

**Impacto:** complementa RF-017; depende do item que torna a chave de assinatura obrigatória.
```

## Exemplo — requisito de performance

Números **ilustrativos**; o valor real é do projeto, não deste modelo.

```markdown
### RNF-014 — Tempo de resposta da listagem de catálogo

**Objetivo relacionado:** OBJ-002 · **Atores:** usuário autenticado

**Enunciado**
O sistema deve responder à listagem de catálogo dentro de um tempo previsível sob carga nominal.

**Orçamento de desempenho**
| Operação | Métrica | Limiar | Condição de carga | Ambiente |
|---|---|---|---|---|
| GET /catalog (1ª página) | latência p95 | ≤ 400 ms | 50 req/s por 5 min | ambiente dedicado de carga (Ficha V21) |

**Critério de aceite**
- [ ] Dado 50 req/s por 5 min no ambiente de V21, quando chamo GET /catalog, então o p95 fica ≤ 400 ms
- [ ] O comando de carga (V19) sai com código ≠ 0 se o p95 passar de 400 ms

**Como verificar**
    <comando único do cenário de carga da Ficha, V19>  → p95 ≤ 400 ms, exit 0

**Fora do escopo**
- Percentis além do p95; outras rotas; dimensionamento de infraestrutura.

**Impacto:** nenhum requisito alterado; adiciona a operação à lista fechada V18 via Arquiteto.
```
