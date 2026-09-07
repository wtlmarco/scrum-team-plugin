# Template — Mudança de Processo

> **Dono:** SM · Saída de `/review` · Registrada em [`../process/process-changelog.md`](../process/process-changelog.md)

Toda instrução de melhoria do stakeholder vira uma entrada. É o que impede o processo de mudar por conversa e ninguém lembrar do porquê seis meses depois.

```markdown
## <vX.Y> — <título curto da mudança> — <data>

**Instrução:** <o que o stakeholder pediu, literal>
**Classificação:** regra · fluxo · cerimônia · propriedade · formato de documento · escopo de papel · comportamento de agente

### O que mudou
| Documento | Seção | Mudança |
|---|---|---|
| `<caminho>` | `<seção>` | <o que entrou, saiu ou foi reescrito> |

### Por quê
<O problema que a mudança resolve — o modo de falha que ela evita. Sem isso, a próxima
pessoa desfaz a mudança por achar que é burocracia.>

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda para ele |
|---|---|

### Conflitos com o processo vigente
<Regra ou etapa que a mudança contradiz, e como foi resolvido — ou "nenhum".>

### Como saberemos que funcionou
<O indicador que deve se mover, e em quanto tempo. Mudança de processo sem indicador
é opinião com data.>

### Evidência (R19)
| Classe | Comando | Saída | Ok? |
|---|---|---|---|
| <arquivamento \| substituição de padrão \| extração/remoção> | `<o comando, literal>` | <o que ele devolveu> | ✅ \| ❌ + o que foi consertado |

### Pendente do stakeholder
<Mudança em `agents/` ou `commands/` proposta e não aplicada — ou "nada".>
```

## Regras

- **Uma entrada por instrução**, com data e versão. Cumulativo, mais recente no topo.
- **Nunca reescrever entrada antiga.** Mudança que reverte outra é entrada nova, citando a que reverte.
- **"Por quê" é obrigatório.** O que mudou dá para ver no diff; o modo de falha que a mudança evita, não.
- **Regra nova sem verificação não entra** — se o SM não consegue dizer como confere, a regra não é aplicável.
- **Toda mudança declara o indicador** que prova que funcionou. Sem isso, o processo cresce sem nunca encolher.
- **Toda entrada que edita traz o bloco de evidência** (R19) — o comando e a saída, não a afirmação de que foi feito. Substituição de padrão se verifica em **todos** os arquivos da classe, não no primeiro. Entrada sem o bloco não fecha o `/review`.
- **`agents/` e `commands/` são do stakeholder** — a entrada registra a proposta, e só marca como aplicada depois da aprovação.

## Falhas comuns

| Falha | Consequência |
|---|---|
| Registrar o que mudou sem o porquê | A regra é desfeita na primeira vez que incomodar |
| Regra nova sem indicador | Ninguém sabe se resolveu; o processo só acumula |
| Mudança aplicada em `agents/` sem aprovação | O comportamento do time muda sem o stakeholder saber |
| Conflito com regra vigente resolvido em silêncio | Duas regras contraditórias, e cada papel segue a que preferir |
