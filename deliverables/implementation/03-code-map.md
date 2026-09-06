# Modelo — `03-code-map.md`

> **Dono:** QA · **Muda quando:** arquivo de código é criado, alterado ou removido · **Revisa:** Arquiteto (na auditoria)

É o **inventário do código**: onde está cada arquivo, o que ele faz e a que entrega pertence — sem conter o código em si. É o que permite ao Arquiteto pedir *os três arquivos certos* em vez de abrir o repositório inteiro (regra R3), e ao QA detectar código sem tarefa correspondente.

## Estrutura

```markdown
# CODE-MAP — Mapa de Código

**Última atualização:** <data> — <o que mudou no último ciclo, em 1-3 frases>

## Legenda de Status
✅ Implementado e validado | 🟨 Implementado, pendente validação
⚠️ Decisão fora da especificação | 🗑️ Removido/obsoleto | ➡️ Renomeado/movido

## <Camada / módulo>

| Arquivo | Responsabilidade | Ciclo | Status |
|---|---|---|---|
| `<caminho relativo à raiz da camada>` | <o que faz, em uma linha — e a invariante ou decisão relevante> | <n> | ✅ |

## <Próxima camada / módulo>
…

## Dependências externas introduzidas
| Dependência | Para quê | Ciclo | Onde é usada |
|---|---|---|---|
```

Agrupe por camada, módulo ou área do sistema — a mesma divisão que a arquitetura usa. Arquivos irmãos e triviais podem entrar numa linha só (`ExceptionA.cs, ExceptionB.cs, ExceptionC.cs`), desde que compartilhem responsabilidade.

## Regras

- **Uma linha por arquivo relevante**, não por arquivo existente. Gerados, migrations e triviais entram agregados ou não entram.
- **A responsabilidade explica, não repete o nome.** "Repositório de X" não acrescenta nada; "acesso a X, com filtro de escopo aplicado no repositório" acrescenta.
- **Marque a decisão fora da especificação com ⚠️** e aponte onde ela está registrada. É como o mapa vira também um índice de dívida.
- **Registre remoção e renomeação** (🗑️ / ➡️) em vez de apagar a linha — quem procura pelo nome antigo precisa encontrar o rastro.
- **Atualize no mesmo ciclo** (R12). Mapa que atrasa dois ciclos deixa de ser confiável e passa a ser reescrito do zero — que é caro.
- **Se crescer demais**, resuma módulos estáveis em uma linha por pasta e mantenha o detalhe por arquivo só nos módulos ativos.

## Falhas comuns

| Falha | Consequência |
|---|---|
| Mapa desatualizado | O Arquiteto pede o arquivo errado; o plano nasce em cima de premissa falsa |
| Arquivo no mapa sem tarefa correspondente | Scope creep silencioso — achado do passe 1 da auditoria |
| Tarefa concluída sem arquivo no mapa | Ou a tarefa não foi feita, ou o mapa atrasou; os dois casos precisam de resposta |
| Responsabilidade que repete o nome do arquivo | O mapa ocupa espaço e não economiza leitura |

## Relação com os demais documentos

- Cruzado com `01-scope-and-criteria` na auditoria: tarefa concluída ↔ arquivo existente.
- Arquivos marcados ⚠️ apontam para a decisão registrada em `02-status`.
- Arquivo que implementa algo divergente da especificação vira GAP em `pending.md`.
