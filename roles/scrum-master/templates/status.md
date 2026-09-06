# Template — Status executivo (`/sm status`)

Formato de resposta do SM. **Seis linhas.** O stakeholder lê isso em pé.

```markdown
## Status — <data>

**Onde estamos:** <1-2 frases: bloco atual e o que ele destrava.>
**Concluído no ciclo:** <ID> — <evidência: teste/build/smoke>
**Em andamento:** <ID> — <dono> — <o que falta>
**Bloqueado:** <ID> — <bloqueio> — <quem destrava, desde quando>
**Próximo:** <1-3 IDs na ordem> — <por que nesta ordem>
**Riscos:** <o que pode dar errado e o gatilho de alerta>
```

## Regras

- Ler o quadro (`.team-project/scrum-master/work-board.md`) e o documento de status do projeto **antes** de responder. Nunca recompor o estado de memória.
- Sem adjetivo. Com ID e evidência.
- "Concluído" exige saída real de comando (R7). Sem evidência, o item continua em validação.
- Não propor trabalho novo neste modo — isso é `/sm plan`.
- Se o documento de status divergir do que o registro de GAPs mostra, registrar como risco e acionar `/qa audit`. Não arredondar.

## Exemplo

```markdown
## Status — 01/09/2026

**Onde estamos:** projeto retomado após interrupção longa; base construída e 50 pendências abertas. Nenhum item da retomada entrou em construção ainda.
**Concluído no ciclo:** nenhum — o time acabou de ser montado.
**Em andamento:** nenhum.
**Bloqueado:** ABC-11 — sem credenciais do provedor externo — stakeholder, desde 01/09.
**Próximo:** ABC-02 → ABC-01 (a chave precisa existir antes de haver assinatura a validar), depois ABC-03.
**Riscos:** o documento de status declara a base inteira concluída enquanto o registro de GAPs aponta 6 pendências críticas — status inflado até `/qa baseline` reproduzir os números.
```
