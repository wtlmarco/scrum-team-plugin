# Melhorias a aplicar neste plugin — fila do `/review`

> **Dono:** stakeholder. Fila de coisas a corrigir ou melhorar **no próprio time** — não no projeto onde ele está instalado.
>
> Esta lista é a **entrada do comando `/review`**. Nada aqui é normativo. O `/review` (Agent `scrum-master`) levanta cada item, **classifica** e **roteia** ao papel dono, que aplica seguindo [`review-contract.md`](review-contract.md). O registro do que foi de fato aplicado vive no [changelog do processo](roles/scrum-master/process/process-changelog.md), não aqui.
>
> **Só no repositório-fonte do plugin.** Melhoria percebida enquanto se trabalha num projeto onde o time está instalado: anote o sintoma (num rascunho seu, num issue), traga para cá num clone do repositório do plugin e rode `/review`. A cópia instalada num projeto é descartável — o próximo `claude plugin update` a sobrescreve.

## Abertas

*(vazia)*

> **v3.0** — o bloco "Revisão do Processo" e os três itens sobre `deliverables/` e o `update` foram aplicados e saíram daqui, conforme a regra 4 abaixo. Ver a entrada [`v3.0` do changelog do processo](roles/scrum-master/process/process-changelog-archive.md).
>
> **v3.4** — os cinco itens restantes saíram no mesmo `/review note`: `/team version` (reenquadrado como modo meta pelo stakeholder, ao lado de `init` e `update`) · o sintoma de campo do `/po status`, sua evidência e o princípio por trás dele (fundidos, viraram a régua **§1b** de `artifact-ownership.md`) · a varredura das outras cinco fichas (feita — dois achados, `especificação` no QA e `documentação` no dev, os dois corrigidos; SM, Arquiteto e UX limpos) · a curadoria das cinco correções e o registro de `team-version.md` na matriz · a sobra do modo `consult` no §5c. O que foi feito, com que evidência e **com que desvio de roteamento** está na entrada [`v3.4`](roles/scrum-master/process/process-changelog.md).

## Como usar esta lista

1. Escreva o item como **sintoma**, não como solução — *"o veredito não diz de onde veio o número"* rende mais que *"adicionar campo X"*.
2. Não precisa dizer a qual papel pertence — o `/review` classifica e roteia. Se souber, pode anotar como pista.
3. Rode **`/review`** (reavaliação + triagem da fila, sem editar) para ver o roteamento proposto, ou **`/review note`** para processar a fila item a item. Item avulso: **`/review <instrução>`**.
4. Item aplicado sai daqui e passa a existir como entrada no changelog do processo. Lista de pendência que também vira histórico deixa de ser lida.
