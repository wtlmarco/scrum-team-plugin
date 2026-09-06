# Evidências — Registro de Verificação

> **DOCUMENTO VIVO** · **Dono:** QA · **Atualizado em:** <data>
> Um bloco por item validado. **Sem bloco aqui, o SM não fecha o item.**
> Regra: **saída real de comando, ou não aconteceu** (R7). O que não pôde ser executado é declarado como não exercitado, com o motivo.

## Linha de base

Registrar aqui os números do projeto **antes** de qualquer construção, reproduzidos no ambiente atual por `/qa baseline` — não copiados de documento.

| Medida | Valor declarado | Valor reproduzido | Fonte | Situação |
|---|---|---|---|---|
| Testes unitários | <n> | <n> | <documento> | ⏳ / ✅ / ⚠️ divergente |
| Testes de integração | <n> | <n> | | |
| Testes E2E | <n> | <n> | | |
| Build (erros/avisos) | <n>/<n> | <n>/<n> | | |
| Cobertura Domain/Application | <n>% | <n>% | | |

---

## Blocos por item

```markdown
## <ID> — <título> — <data>

**Veredito:** ✅ | ⚠️ | ❌

| Frente | Resultado | Evidência |
|---|---|---|
| Requisito | ok/falha | |
| Especificação técnica | ok/falha | |
| Segurança | ok/falha/n/a | |
| Testes / métricas | ok/falha | |
| Documentação | ok/falha | |

**Comandos executados**
```
> <comando>
<saída real>
```

**Achados**
| # | Gravidade | O quê | Onde | Volta para |
|---|---|---|---|---|

**Não exercitado**
- <o que e por quê>
```

---

## Como manter

- Um bloco por item, em ordem cronológica inversa (mais recente no topo dos blocos).
- Nunca editar bloco antigo: correção vira bloco novo com a data de hoje.
- A linha de base é reproduzida de novo sempre que o ambiente mudar (máquina nova, dependência atualizada).
