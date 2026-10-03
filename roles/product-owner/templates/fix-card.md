# Template — Ficha da Correção (trilha `fix`, R33)

> **Dono:** PO · **Quem abre:** a sessão, na triagem (`${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/fix-run.md` §Triagem), com o que o PO classificou · Vive em `.team-project/fixes/F-<nnn>.md`, uma por Correção, viva até o estado final dela.
> **Os rótulos abaixo são lidos pela conferência C4 (`scripts/checks/fix.ps1`) — não variar a grafia.** Nenhum título deste modelo começa com a palavra "Aceite": a Correção não tem aceite na Review (P3) e a conferência C2 procura esse título de dossiê.

## Modelo

```
# F-<nnn> · <título>
**Tipo:** defeito | ajuste · **Triada em:** aaaa-mm-dd
**História do aceite:** <H-nnn + sprint do aceite | H-nnn · fora da janela | não identificada | não aplicável> — ver pending.md
**Relato:** <sintoma, como veio do note.md>
## Elegibilidade funcional
- C1 ✔ · <evidência>
- C2 ✔ · <evidência>
- C3 ✔ · <evidência>
- C4 ✔ · <evidência>
## Reprodução
**Entrada no pending.md:** <ID> · **Causa:** <arquivo>:<linha>      (defeito; ajuste: "n/a — ajuste")
## Delta (ajuste)
<requisito: antes → depois; o que NÃO muda; linha do 06-changelog — rascunho até o ✅>
## Confirmação do stakeholder
**Data:** aaaa-mm-dd · **Decisão:** aprovado | ajustado      (ajuste; defeito: "n/a — defeito")
## Destino
**Bloco:** B-<nnn> · **Estado:** triada | em bloco | fechada | promovida | devolvida
**Critério que caiu:** C<n> — <motivo>      (só se promovida)
```

## Regras de preenchimento

- **Tipo (D2).** **Defeito**: o código diverge do que o SDD já diz. **Ajuste**: o SDD precisa mudar, em delta mínimo. **SDD omisso não é Correção** — preencher lacuna é criar requisito (C1 cai) e segue a rota de lacuna de especificação; não abra ficha.
- **C1–C4 são meus, assinados na triagem**, um por linha, com a evidência em uma linha (requisito lido, História em voo consultada no quadro). **✘ no lugar de ✔ quando o critério falha — e aí não é Correção**: não abra a ficha; o item segue a rota que a classificação mandar. C1 no ajuste: no máximo **um** requisito existente alterado, nenhum criado.
- **História do aceite** segue a regra do `/po bug` ([`README.md`](../README.md)): leio dos dossiês de aceite, sem abrir código, e **repasso por item ao `/qa bug` em lista**. A ficha só **aponta** para o `pending.md` — o registro é da QA. **Ajuste: `não aplicável`.** Reabertura de F-ID fechada **não é novo escape**: a ficha mantém o valor original, não gera entrada de defeito nova e não conta de novo no indicador.
- **Reprodução** é o ponteiro (ID da entrada + `arquivo:linha`) que a QA trouxe; **não copio a evidência** nem escrevo no `pending.md`. Ajuste: `n/a — ajuste`.
- **Delta (ajuste)** é meu: o requisito **antes → depois**, o que **não** muda e a linha do `06-changelog`, como **rascunho**. Só vai ao SDD e ao changelog **depois do ✅ do QA**, no `fix run` (R12 · R15, emenda). Defeito: `n/a — defeito`.
- **Confirmação do stakeholder** é preenchida pela sessão com a decisão do formulário do `fix plan` (R22). Defeito: `n/a — defeito`.
- **Destino** é atualizado pela sessão (bloco e estado); promoção registra o **critério que caiu** e o motivo — e, se ajuste promovido, o delta segue como insumo da História no Product Backlog, sem nunca ter ido ao SDD.
- **Ficha curta:** é um registro de triagem, não uma análise. Detalhe técnico (arquivos, passos) é do mini-plano do Arquiteto (`fixes/B-<nnn>/plan.md`), não daqui.
