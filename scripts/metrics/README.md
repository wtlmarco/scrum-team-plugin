# `scripts/metrics/` — medição de custo pelos transcripts

> **Dono:** stakeholder, como `hooks/` e `scripts/checks/` (`artifact-ownership.md` §1). Ferramenta do **mantenedor do plugin** e do **benchmark**: não roda dentro do time, nenhum papel a chama e nada aqui grava em `.team-project/`.

O registro de consumo do time (`usage.jsonl`, G16) mede só subagente e conta tokens processados. Esta ferramenta lê os **transcripts do Claude Code** e mede o que ficava de fora:
- a **sessão principal**, que no primeiro sprint do piloto foi ~40 % do custo;
- o custo em **US$ pelo modelo servido**, e não só o volume: com 94 % lido do cache, volume e custo dão ordens diferentes;
- as **quebras de cache** e o que estava pendente em cada uma;
- **o que enche o contexto**.

Vale igual para todos os braços do benchmark, com ou sem o plugin.

## Uso

```powershell
node scripts/metrics/transcript-metrics.js <comando> "<pasta do projeto>" [--since 2026-10-04T00:00:00-03:00] [--json saida.json]
```

A pasta do projeto fica em `~/.claude/projects/<projeto>/`, ou em `~/.claude-<perfil>/projects/…` quando há mais de um diretório de configuração. O nome é o caminho do projeto com `-` no lugar dos separadores.

| Comando | O que mede | Medido ou estimado |
|---|---|---|
| `cost` | volume × custo por quem (sessão ou papel) e modelo; o custo sem cache; as maiores instâncias | **medido** (`usage` de cada chamada × preço de API) |
| `breaks` | quebras de cache (a chamada lê menos de 90 % do contexto da anterior), pela causa: expirou depois de pausa maior que o TTL (com o que estava pendente), troca de modelo, compactação, prefixo mudado | **medido** |
| `growth` | de onde vem o crescimento do contexto (leitura de plano, de código, retorno de agente…); `--session` mede a sessão principal | **estimado**: tamanho do trecho × chamadas seguintes, calibrado pelo `usage` |
| `session` | chamadas da sessão principal por tipo de trabalho (disparo, marcador, `consumption.ps1`, conferências) | **medido** |
| `waits` | sessão parada à espera do stakeholder × à espera de agente | **medido**. Sessões simultâneas podem contar a mesma hora duas vezes, e a espera inclui máquina suspensa: separe-a com o log de energia do SO (R27). No piloto, ~122 h das esperas foram standby ou sleep |

## Limites

- **Preço de API**, da tabela no topo do script (lista de 2026-10-06). Não é o que o plano de assinatura cobra. Modelo fora da tabela conta no volume e fica fora do custo. A leitura de cache do Haiku 5.5 é suposta em 0,1× da entrada.
- **O formato do transcript não é documentado** pelo Claude Code: uma mudança do harness pode quebrar a leitura, como já vale para a G16 (`hooks/COVERAGE.md`).
- **Evento repetido** (mesmo `uuid`) é descartado: o harness regrava linhas antigas antes de uma compactação, com o horário original. Sem isso, uma resposta de dias antes parece uma pausa longa; no piloto, uma "parada de 68 h" que não existiu.
- **Escrita de cache** pelo TTL que a própria chamada registrou (`usage.cache_creation`): 1,25× a entrada para 5 min, 2× para 1 h.

Requisito: Node.js 18+. Diferente de `hooks/` e `scripts/checks/`, não roda em projeto consumidor, então não precisa do Windows PowerShell 5.1.
