# Armadilhas da stack — Angular (NG-P)

> Comportamento real do framework que já derrubou plano ou teste (v3.56.0). O cartão do dev e a ficha do Arquiteto trazem **só as entradas cujo Vale para casa com os arquivos da Task** — este arquivo não se lê inteiro. Só o `/review` grava aqui (R16); o projeto acrescenta a dele em `.team-project/standards/stacks/angular/pitfalls.md` (`NG-L<n>`), e o `/review` promove a que se confirmar.
> **Estado:** semeado com a primeira lição (v3.57.2, garden sprint 5) — **confirmar em segundo projeto**.

<!-- Formato de cada entrada:

## NG-P<n> — <título>
**Vale para:** <glob>, <glob>
**Sintoma:** <o que se vê: medida, erro, teste que falha>
**Fato:** <o comportamento real>
**Como testar:** <o teste ou a medida que pega, curto>
**Origem:** <projeto>, GAP <ref>
-->

## NG-P1 — Karma derruba a suíte completa com o prazo padrão de 30 s
**Vale para:** `karma.conf.js`, `src/**/*.spec.ts`, `src/**/*.render.spec.ts`
**Sintoma:** a suíte completa cai no meio com "Disconnected, no message in 30000 ms" (garden: em 711, 1150, 1653 e 1816 de 2102 casos; passou 2102/2102 em outras três rodadas), sem nenhum `FAILED`; o `verify full` sai vermelho e a cobertura não é medida.
**Fato:** o `browserNoActivityTimeout` padrão do Karma é 30 s; spec de render pesado ou o ChromeHeadless sob carga passa disso sem mandar mensagem, e o Karma desiste do navegador — em ~1 de cada 2 rodadas completas no garden.
**Como testar:** `karma.conf.js` com `browserNoActivityTimeout: 120000` e `browserDisconnectTolerance: 1` (Q-S5b do garden); a suíte completa roda 3 vezes seguidas sem desconexão. Não é defeito do código: rodada que caiu assim é ambiente, não reprovação.
**Origem:** garden, sprint 5 (ocorrência 6 do relatório de ocorrências; Q-S5b)
