# Armadilhas da stack — Ionic + Capacitor (IONIC-P)

> Comportamento real do framework que já derrubou plano ou teste (v3.56.0). O cartão do dev e a ficha do Arquiteto trazem **só as entradas cujo Vale para casa com os arquivos da Task** — este arquivo não se lê inteiro. Só o `/review` grava aqui (R16); o projeto acrescenta a dele em `.team-project/standards/stacks/ionic-capacitor/pitfalls.md` (`IONIC-L<n>`).
> **Estado:** semeado com as lições de stack do garden (sprints 1 a 5) — **confirmar em segundo projeto**. As referências `S<sprint> #<n>` são da classificação dos GAPs do garden.

## IONIC-P1 — aria-label vai para o botão interno
**Vale para:** `src/app/**/*.html`, `src/app/**/*.spec.ts`
**Sintoma:** o teste procura o `aria-label` no `ion-button` e não acha; `getComputedStyle` do elemento interno devolve `''` no Karma.
**Fato:** o Ionic move o `aria-label` do host para o `<button>` interno (shadow DOM); no Karma o estilo computado do interno sai vazio.
**Como testar:** consultar o atributo no host antes da hidratação ou pelo `button` interno via `shadowRoot`; não medir estilo do interno no Karma.
**Origem:** garden, GAP S1 #6

## IONIC-P2 — aria-labelledby não chega ao modal
**Vale para:** `src/app/**/*.html`, `src/app/**/*modal*`
**Sintoma:** o leitor de tela não anuncia o título do `ion-modal`.
**Fato:** o Ionic 8.8 não repassa `aria-labelledby` ao `.modal-wrapper`.
**Como testar:** conferir o atributo no `.modal-wrapper` depois de `didPresent`; pôr o rótulo no wrapper pelo próprio código.
**Origem:** garden, GAP S2 #20

## IONIC-P3 — aria dinâmico antes da instância
**Vale para:** `src/app/**/*.html`
**Sintoma:** erro do Stencil no console ao montar o componente com `[attr.aria-label]` dinâmico.
**Fato:** o binding dinâmico dispara o `onAriaChanged` do Stencil antes de a instância existir.
**Como testar:** teste de render que monta o componente e falha com erro no console; usar valor estático ou definir depois de `componentOnReady`.
**Origem:** garden, GAP S3 #34

## IONIC-P4 — margem do ion-button soma ao clamp
**Vale para:** `src/app/**/*.scss`, `src/theme/**`, `src/app/**/*.render.spec.ts`
**Sintoma:** a régua de 8 px entre botões mede 16 px.
**Fato:** o `ion-button` tem 4 px de margem por lado, que somam ao `clamp`/gap do contêiner.
**Como testar:** medir a caixa do botão interno no render, não a do host; zerar `--margin-*` quando o espaçamento é do contêiner.
**Origem:** garden, GAPs S3 #37, S4 #11

## IONIC-P5 — ion-text-wrap vence white-space: nowrap
**Vale para:** `src/app/**/*.html`, `src/app/**/*.scss`
**Sintoma:** o texto quebra apesar do `white-space: nowrap`; a mutação que tira o `nowrap` não é pega (mutação equivalente).
**Fato:** a classe `ion-text-wrap` do item vence o `nowrap` do filho.
**Como testar:** tirar a classe do item ou medir a altura da linha no render; mutar a classe, não o `nowrap`.
**Origem:** garden, GAP S3 #42

## IONIC-P6 — popover animado: medir depois de apresentado
**Vale para:** `src/app/**/*popover*`, `src/app/**/*.render.spec.ts`
**Sintoma:** a caixa do popover mede 0 ou na posição inicial da animação.
**Fato:** o `ion-popover` anima ao abrir; a geometria só vale depois de `ionPopoverDidPresent`.
**Como testar:** esperar o evento antes de medir (o molde já existe no projeto que o usou).
**Origem:** garden, GAPs S2 #11, S5 #49

## IONIC-P7 — ion-select transborda texto longo
**Vale para:** `src/app/**/*.html`, `src/app/**/*.scss`
**Sintoma:** a opção longa sai da caixa do `ion-select`.
**Fato:** o `ion-select` usa `flex: 1 1 0`, e o texto não encolhe sem `min-width: 0` e reticências.
**Como testar:** render com o texto mais longo da massa; medir a caixa do texto contra a do select.
**Origem:** garden, GAP S4 #19

## IONIC-P8 — ion-alert preso ao body, botões abaixo de 44 px
**Vale para:** `src/app/**/*alert*`, `src/app/**/*.render.spec.ts`
**Sintoma:** a medida do alerta sai do tamanho do viewport do Karma; os botões no modo `md` medem 37–41 px de altura.
**Fato:** o `ion-alert` é anexado ao `body` (mede o viewport, não o componente); os botões `md` ficam abaixo da área de toque de 44 px.
**Como testar:** medir no `body` depois de `didPresent`; critério de área de toque pede CSS próprio nos botões do alerta.
**Origem:** garden, GAPs S5 #46, #48

## IONIC-P9 — RouterTestingHarness sem .ion-page
**Vale para:** `src/app/**/*.render.spec.ts`, `src/app/**/*.page.spec.ts`
**Sintoma:** a barra de abas sai da tela no teste; a altura útil não bate com o app.
**Fato:** o `RouterTestingHarness` não põe a página dentro de `.ion-page` nem do outlet do Ionic.
**Como testar:** montar o contêiner `.ion-page` no teste ou medir só o que não depende dele (IONIC-2).
**Origem:** garden, GAP S3 #30

## IONIC-P10 — medida do Karma não é medida do aparelho
**Vale para:** `src/app/**/*.render.spec.ts`
**Sintoma:** o limiar passa no Karma e reprova no aparelho (ou o contrário).
**Fato:** a barra vertical do Chrome do Karma encolhe a faixa útil; densidade e fonte do aparelho são outras.
**Como testar:** limiar relativo à caixa do componente, não ao viewport; o critério de tamanho na tela se prova no `accept`.
**Origem:** garden, GAP S3 #44

## IONIC-P11 — ResizeObserver dentro da zona do Angular
**Vale para:** `src/app/**/*.ts`
**Sintoma:** detecção de mudança extra ou laço de render ao observar tamanho.
**Fato:** a primeira entrega do `ResizeObserver` roda dentro da zona do Angular.
**Como testar:** criar o observador em `runOutsideAngular` e voltar à zona só para atualizar o estado; contar as detecções no teste.
**Origem:** garden, GAP S3 #56

## IONIC-P12 — mutante que não compila em TypeScript estrito
**Vale para:** `src/**/*.ts`
**Sintoma:** a mutação planejada (`&& false`, `=== undefined`) não compila e sai inconclusiva.
**Fato:** com `strict`, o TypeScript recusa a expressão de tipo impossível.
**Como testar:** mutar o **valor** (outro número, outra string, ramo invertido), não o tipo.
**Origem:** garden, GAPs S2 #17, #24, S3 #31

## IONIC-P13 — Jasmine 5.1: callFake com arrow quebra new
**Vale para:** `src/**/*.spec.ts`
**Sintoma:** `TypeError: ... is not a constructor` no teste que espiona uma classe.
**Fato:** `and.callFake(() => …)` com arrow function não pode ser chamado com `new`.
**Como testar:** usar `function () { … }` no `callFake` de construtor.
**Origem:** garden, GAP S1 #2

## IONIC-P14 — seletor de atributo exige o prefixo app
**Vale para:** `src/app/**/*.ts`
**Sintoma:** o lint reprova a diretiva nova.
**Fato:** a regra do `angular-eslint` exige o prefixo do projeto (`app`) também no seletor de atributo (`[appX]`).
**Como testar:** rodar o lint na Task que cria diretiva.
**Origem:** garden, GAP S3 #47

## IONIC-P15 — CDP: Page.navigate derruba o app
**Vale para:** `scripts/**`, `tests/**/*alvo*`, `**/*.cdp.*`
**Sintoma:** depois de ler a tela pelo CDP, o app fecha ou volta ao início.
**Fato:** `Page.navigate` recarrega a WebView do Capacitor e derruba o app; o CDP serve só para leitura.
**Como testar:** só `Runtime.evaluate`/`DOM.*` de leitura; navegação pelo próprio app.
**Origem:** garden, GAP S5 #29

## IONIC-P16 — Gradle UP-TO-DATE entrega o mesmo APK
**Vale para:** `android/**`, `scripts/**apk*`, `scripts/**build*`
**Sintoma:** o gate de "APK novo" sai 3; o `accept` roda o app de antes da mudança.
**Fato:** sem mudança que o Gradle enxergue, `assembleDebug` fica `UP-TO-DATE` e devolve o APK idêntico.
**Como testar:** comparar o carimbo do APK com o do código depois de `npx cap sync`; forçar a tarefa quando o web mudou.
**Origem:** garden, GAP S5 #25

## IONIC-P17 — Node 24: node --test não aceita diretório
**Vale para:** `scripts/**`, `tests/**/*.mjs`, `tests/**/*.js`, `package.json`
**Sintoma:** `node --test tests/` não acha os testes (ou acha 0).
**Fato:** no Node 24, `node --test <dir>` não resolve o diretório; é preciso o glob ou a lista de arquivos.
**Como testar:** `node --test "tests/**/*.test.mjs"`; conferir que a saída não diz `tests 0`.
**Origem:** garden, GAP S5 #22

## IONIC-P18 — seletor de arquivo do Android não devolve pelo "visualizar"
**Vale para:** `src/app/**/*import*`, `src/app/**/*file*`, `.team-project/quality-assurance/scenarios/**`
**Sintoma:** o cenário toca o arquivo e o app não recebe nada.
**Fato:** no seletor de documentos do Android, o toque no ícone "visualizar" abre `VIEW`; só o toque no nome devolve o arquivo ao app.
**Como testar:** o cenário toca o nome do arquivo; prova de importação de arquivo pede a massa no aparelho.
**Origem:** garden, GAP S5 #57
