# Template — Checkpoint de Spike

Salvo em `.team-project/architect/spikes/<ID>-<slug>.md` — **fora** da pasta do sprint ([`../../scrum-master/process/artifact-ownership.md` §1c](../../scrum-master/process/artifact-ownership.md)). Gravado **ao fim de cada etapa concluída**, antes da seguinte; na retomada, é lido primeiro. As regras estão em [`../skills.md`](../skills.md) §11 (chamada externa), §12 (checkpoint) e §14 (delegação ao `operator`) — aqui fica só a forma.

```markdown
# Spike — <ID> <pergunta que o spike responde>

**Pedido:** <quem pediu · data> · **Toca código:** sim — descartável, desfeito ao fim · **Próxima etapa:** <n — título> *(ou "encerrado")*

## Etapa <n> — <título> · **concluída** | **inconclusiva por causa externa**
- **Comando:** `<literal>` → código de saída `<n>` · `<trecho decisivo, literal>`
- **Log:** `.team-project/operator/<sprint|pre-sprint>/<job>/report.md` (ou `report-<nome>.md`) · log: `<nome>.log` — <n> linhas *(ou "n/a — comando leve, rodado por mim")*
- **Chamada externa:** timeout por tentativa `<s>` · tentativas `<n>` · teto da etapa `<s>` — *(ou "nenhuma")*; inconclusiva: `<erro literal do provedor>`
- **Decisão parcial que isto sustenta:** <uma frase, com a ADR que ela alimenta, se houver — ou "nenhuma: etapa inconclusiva não sustenta decisão">

## Etapa <n+1> — …

## Execução delegada
*(uma linha por chamada ao `operator` neste spike, acrescentada na mesma gravação da etapa que a usou, como índice do job.
Tokens e duração o hook G16 mede (v3.45). Sem chamada: "nenhuma". Não gravo em `consumption.md`.)*

| Operator job | Task/História |
|---|---|
| `.team-project/operator/<sprint\|pre-sprint>/<T-ID>[-<slug>]/` *(+ ` — <log>` se houver mais de uma chamada na mesma pasta)* | <T-ID / H-ID> |
```

## Regras

- **Checkpoint sem "Próxima etapa" não serve para retomar** (§12). Etapa sem desfecho — concluída com saída real, ou inconclusiva com o erro do provedor — é etapa não relatada (§11).
- **Toda linha de Log que aponta para `.team-project/operator/` tem linha em "Execução delegada"**, e vice-versa: o número de linhas da seção é o número de chamadas ao `operator` do spike ("nenhuma" quando zero). Os números vêm do hook G16; o checkpoint é o índice que o SM confere (R28).
