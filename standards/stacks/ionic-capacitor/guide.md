# Guia de Implementação — Perfil de Stack Ionic + Capacitor (IONIC)

> **Nível 2** de [`../../implementation-principles.md`](../../implementation-principles.md) para aplicação híbrida Ionic (Angular) empacotada pelo Capacitor. Soma ao perfil [`../angular/guide.md`](../angular/guide.md) — anéis, portas, signals e testes de lá valem aqui; este guia só traz o que muda com o Ionic e a WebView. Onde divergirem, o nível 1 vence.
> **Stack alvo:** Ionic 8 · Angular 17+ · Capacitor 6+ · Karma/Jasmine · emulador Android (inclusive em container).
> **Identificadores:** `IONIC-<n>` para as seções deste guia; `IONIC-P<n>` para as armadilhas em [`pitfalls.md`](pitfalls.md).
> **Origem:** garden, sprints 1 a 5 (v3.56.0). Pacote de **um projeto só** até aqui: cada armadilha diz "confirmar em segundo projeto".

## IONIC-1 Identificador de teste

- No app híbrido, o atributo de teste é o **`id`** (`guards.json` → `testIds.attribute: "id"`, [`../../test-ids.md`](../../test-ids.md)): o `uiautomator` lê o `id` do elemento da WebView como `resource-id`; `data-testid` não chega ao aparelho.
- O id vai no **componente Ionic** (`ion-button`, `ion-item`, `ion-select`), não no elemento interno que ele gera. Atributo ARIA também: ver IONIC-P1 e IONIC-P3.
- Item de lista leva `<área>.<elemento>.<id>` com o id do dado; a raiz de cada `*.page.html` leva o id da tela.

## IONIC-2 Harness do teste de render (Karma)

- `RouterTestingHarness` não põe a página dentro de `.ion-page` nem do `ion-router-outlet`: a barra de abas e o cabeçalho ficam fora da conta (IONIC-P9). Monte a página com o contêiner que o app real tem ou meça só o que não depende dele.
- Overlay (`ion-popover`, `ion-alert`, `ion-modal`) é preso ao `body`, fora do componente: meça depois do evento de apresentação (`ionPopoverDidPresent`, `didPresent`) e contra o viewport do Karma, não contra o aparelho (IONIC-P6, IONIC-P8, IONIC-P10).
- Medida de render no Karma **não é** medida do aparelho: a faixa útil muda com a barra do Chrome e com a densidade. O critério de tamanho na tela se prova no `accept` do alvo.

## IONIC-3 WebView, CDP e o alvo Android

- A WebView do Capacitor pode ser lida pelo DevTools Protocol (CDP) por `adb forward` — **só leitura**: `Page.navigate` recarrega a WebView e derruba o app (IONIC-P15).
- APK novo pede build novo: o Gradle com `UP-TO-DATE` entrega o mesmo APK (IONIC-P16). Para provar que o build foi feito, compare o carimbo do APK com o do código, ou force o `assembleDebug` depois do `npx cap sync`.
- Emulador em container (serial de rede `localhost:5555`): o caminho e os limites estão no `how-to.md` (v3.55.0 G) — WebView sem `id` fica PARCIAL.
