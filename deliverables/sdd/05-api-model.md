# Modelo — `05-api-model.md`

> **Dono:** Arquiteto · **Muda quando:** endpoint, contrato ou formato de erro · **Revisa:** QA (rota × documento)

É o contrato exposto ao mundo. Rota documentada que não existe é tão defeituosa quanto rota que existe e não está documentada.

## Estrutura

```markdown
# 05. Modelagem de APIs

## Contrato de erro
<O formato único de erro da API, com um exemplo. Definido uma vez, vale para todos os endpoints.>

| Situação | Tipo/código | Status |
|---|---|---|
| Entrada inválida | <slug> | 400 |
| Não autenticado | <slug> | 401 |
| Sem permissão | <slug> | 403 |
| Inexistente (ou de outro escopo) | <slug> | 404 |
| Regra de negócio violada | <slug> | 422 |

## <Área funcional>

```http
POST   /api/<recurso>              # <o que faz>
GET    /api/<recurso>/{id}         # <o que faz>
GET    /api/<recurso>              # <o que faz — filtros e paginação>
PATCH  /api/<recurso>/{id}         # <o que faz>
DELETE /api/<recurso>/{id}         # <o que faz>
```

Exemplo — <operação>:

```json
{ "campo": "valor" }
```

**Autorização:** <permissão exigida por operação>
**Assíncrono:** <quais operações retornam 202 e como acompanhar o resultado>
**Requisitos atendidos:** <RF-nnn>

## <Próxima área funcional>
…
```

## Regras

- **Um contrato de erro para toda a API**, declarado uma vez no topo. Endpoint com formato próprio de erro é defeito.
- **Recurso de outro escopo responde 404, não 403** — não vazar existência.
- **Operação assíncrona declara como acompanhar.** Retornar 202 sem dizer onde consultar o resultado deixa o cliente sem saída.
- **Cada área cita os requisitos que atende.** É o que permite rastrear do RF ao endpoint e vice-versa.
- **Autorização documentada por operação.** "Endpoint autenticado" não basta: qual permissão, e o que acontece sem ela.
- **Documentar não é gerar.** Se o projeto publica um contrato gerado automaticamente, este documento continua sendo a fonte da intenção — o gerado confere, não substitui.

## Falhas comuns

| Falha | Como detectar |
|---|---|
| Rota documentada e inexistente | Chamada retorna 404 — verificação mais barata da auditoria |
| Rota existente e não documentada | Aparece no diff e não no documento; scope creep silencioso |
| Endpoint sem autorização declarada | O dev não implementa a verificação, e ninguém percebe até a auditoria de segurança |
| Formato de erro divergente entre áreas | O cliente precisa tratar N formatos; cada área inventa o seu |
