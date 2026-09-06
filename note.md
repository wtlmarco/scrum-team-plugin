# Melhorias a aplicar neste plugin — fila do `/review`

> **Dono:** stakeholder. Fila de coisas a corrigir ou melhorar **no próprio time** — não no projeto onde ele está instalado.
>
> Esta lista é a **entrada do comando `/review`**. Nada aqui é normativo. O `/review` (Agent `scrum-master`) levanta cada item, **classifica** e **roteia** ao papel dono, que aplica seguindo [`review-contract.md`](review-contract.md). O registro do que foi de fato aplicado vive no [changelog do processo](roles/scrum-master/process/process-changelog.md), não aqui.
>
> **Só no repositório-fonte do plugin.** Melhoria percebida enquanto se trabalha num projeto onde o time está instalado: anote o sintoma (num rascunho seu, num issue), traga para cá num clone do repositório do plugin e rode `/review`. A cópia instalada num projeto é descartável — o próximo `claude plugin update` a sobrescreve.

## Abertas

- preciso que faça um teste comparativo desse plugin para a criação de um projeto simples por ele e por prompt independente para avaliar o consumo de token e a qualidade do que foi desenvolvido como podemos fazer? Um tipo de teste de performance para calibrarmos nosso processo e aperfeiçoá-lo; Abra e sessões de claude e gere os 2 projetos de exemplo em 2 pastas para depois compararmos; estou aberto a responder o necessário do que cada agente precisar para desenvolvê-lo.

## Como usar esta lista

1. Escreva o item como **sintoma**, não como solução — *"o veredito não diz de onde veio o número"* rende mais que *"adicionar campo X"*.
2. Não precisa dizer a qual papel pertence — o `/review` classifica e roteia. Se souber, pode anotar como pista.
3. Rode **`/review`** (reavaliação + triagem da fila, sem editar) para ver o roteamento proposto, ou **`/review note`** para processar a fila item a item. Item avulso: **`/review <instrução>`**.
4. Item aplicado sai daqui e passa a existir como entrada no changelog do processo. Lista de pendência que também vira histórico deixa de ser lida.
