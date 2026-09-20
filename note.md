# Melhorias a aplicar neste plugin — fila do `/review`

> **Dono:** stakeholder. Só no repositório-fonte do plugin. Escreva cada item como **sintoma**, não como solução.

## Abertas

*(vazia)*

---

## Encerrados na rodada v3.25 · v3.26 · v3.27

O relato do incidente T‑001 e os três pontos que dele sobraram foram tratados e vivem agora no changelog do processo. Nada aqui é pendência — é rastro, e pode ser apagado quando a próxima fila começar.

| Sintoma relatado | Onde foi parar |
|---|---|
| Plano "fechado" sem medir o ambiente; parada que não previa pré-requisito ausente | **R26** + §3 nova no modelo de plano + gate em `workflow.md` §8 |
| Rota do 🔺 GAP: gap de desenho × relato do dev a conferir | **R9 ampliada** — decide e documenta, não executa; conferência segue do QA (R7) |
| Dev declarou PASS/ENTREGUE sobre gate que falhava, não rodava ou fora removido | Contrato do dev (item 6), relatório de entrega, `/arc comply`, `agents/developer.md` |
| Notificação de consumo parcial × final na mesma invocação | `templates/consumption.md` |
| `/dev` não resolve; o comando é `/team:dev` | Nota de troubleshooting em `how-to.md` — não era erro do guia: o prefixo é desambiguação do Claude Code quando há colisão entre plugins |
| Teto de 10 KB por entrada não escalava com o tamanho da rodada | **R17 alterada** — 10 KB até dois papéis, +2,5 KB por papel adicional, teto 20 KB; e a medição passa a exigir decodificação UTF‑8 explícita |
| Chamadas ao agente canceladas com "Request interrupted by user" sem ação do usuário | **R27 nova** — retentativa, e falha de ambiente nunca é reportada como interrupção do stakeholder |
| Relatório de retomada que não chega; agente de 4h cujo relatório se perdeu | **R5 ampliada** — quem orquestra lê o estado em disco antes de reinvocar ou declarar perda |

**Fora do alcance do processo, registrado e fechado:** a string "Request interrupted by user for tool use" é do harness do Claude Code, não do plugin — a R27 trata como o time *reage* a ela, não a causa, que é externa e pode mudar numa atualização.
