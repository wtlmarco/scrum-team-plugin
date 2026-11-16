# Guia de Implementação — Perfil de Stack Ionic + Capacitor (IONIC)

> **Nível 2** de [`../../implementation-principles.md`](../../implementation-principles.md) para aplicação híbrida Ionic (Angular) empacotada pelo Capacitor. Soma ao perfil [`../angular/guide.md`](../angular/guide.md) — anéis, portas, signals e testes de lá valem aqui; este guia só traz o que muda com o Ionic e a WebView. Onde divergirem, o nível 1 vence.
> **Stack alvo:** Ionic 8 · Angular 17+ · Capacitor 6+ · Karma/Jasmine · emulador Android (inclusive em container).
> **Identificadores:** `IONIC-<n>` para as seções deste guia; `IONIC-P<n>` para as armadilhas em [`pitfalls.md`](pitfalls.md).
> **Origem:** um projeto Ionic + Angular + Capacitor, sprints 1 a 5 (v3.56.0); IONIC-3 revisto na v3.62.0. Pacote de **um projeto só** até aqui: cada armadilha diz "confirmar em segundo projeto".

## IONIC-1 Identificador de teste

- No app híbrido, o atributo de teste é o **`id`** (`guards.json` → `testIds.attribute: "id"`, [`../../test-ids.md`](../../test-ids.md) §2): o `accept` o lê no DOM da WebView pelo CDP (`targets.android.locator: "cdp"`, IONIC-3). O `uiautomator` não recebe o `id` da WebView, e o `data-testid` não é o atributo desta stack.
- O id vai no **componente Ionic** (`ion-button`, `ion-item`, `ion-select`, `ion-input`), não no elemento interno que ele gera. Atributo ARIA também: ver IONIC-P1 e IONIC-P3.
- Item de lista leva `<área>.<elemento>.<id>` com o id do dado; a raiz de cada `*.page.html` leva o id da tela.

## IONIC-2 Harness do teste de render (Karma)

- `RouterTestingHarness` não põe a página dentro de `.ion-page` nem do `ion-router-outlet`: a barra de abas e o cabeçalho ficam fora da conta (IONIC-P9). Monte a página com o contêiner que o app real tem ou meça só o que não depende dele.
- Overlay (`ion-popover`, `ion-alert`, `ion-modal`) é preso ao `body`, fora do componente: meça depois do evento de apresentação (`ionPopoverDidPresent`, `didPresent`) e contra o viewport do Karma, não contra o aparelho (IONIC-P6, IONIC-P8, IONIC-P10).
- Medida de render no Karma **não é** medida do aparelho: a faixa útil muda com a barra do Chrome e com a densidade. O critério de tamanho na tela se prova no `accept` do alvo.

## IONIC-3 WebView, CDP e o alvo Android

- **Localizador:** `guards.json → targets.android.locator: "cdp"`. Os verbos de tela vão pelo DevTools Protocol da WebView, com a semântica de [`../../scenario-language.md`](../../scenario-language.md); o ciclo de vida continua pelo `adb` ([`../../test-ids.md`](../../test-ids.md) §6). Com o `uiautomator`, o `accept` para antes do 1º cenário com CONFIGURAÇÃO DO ALVO.
- **Depuração da WebView no build de debug:** o APK que o `accept` instala precisa dela. No Capacitor, é `android.webContentsDebuggingEnabled` no `capacitor.config` — o padrão segue o `debuggable` do APK; não a desligue no build de debug, e ligue-a (`true`) explicitamente se o projeto separa a configuração por build. Sem ela, o `accept` sai com CONFIGURAÇÃO DO ALVO, que é do stakeholder.
- **`targets.android.cdp`** — o que esta stack costuma declarar (exemplo; ajuste ao app):
  ```json
  "cdp": {
    "hiddenScopes": [".ion-page-hidden"],
    "readyExpr": "document.readyState === 'complete' && !!document.querySelector('ion-app.hydrated')",
    "failExpr": "!!document.querySelector('[id=\"app.erro\"]')"
  }
  ```
  - `hiddenScopes: [".ion-page-hidden"]`: o `ion-router-outlet` guarda no DOM as páginas anteriores da navegação com essa classe. Sem a chave, um id repetido na página em cache conta no `assert-count` e falseia o `assert-absent`.
  - `readyExpr`: o app pronto depois do `launch` — aqui, o `ion-app` hidratado. `failExpr`: a tela de falha do **próprio app**, pelo id que ela leva (vira FALHOU, não ambiente).
- **Valor de campo:** `ion-input` e `ion-textarea` guardam o valor na propriedade `value` do host. O `assert-text`/`assert-contains` o lê dali, e o `type` acha o campo interno — sem regra própria da stack (`scenario-language.md` §2). O id fica no host (IONIC-1).
- **O executor nunca navega a WebView:** `Page.navigate` recarrega a WebView do Capacitor e derruba o app (IONIC-P15). Navegação é sempre pelo próprio app, nos passos do cenário.
- APK novo pede build novo: o Gradle com `UP-TO-DATE` entrega o mesmo APK (IONIC-P16). Para provar que o build foi feito, compare o carimbo do APK com o do código, ou force o `assembleDebug` depois do `npx cap sync`.
- Emulador em container (serial de rede `localhost:5555`): o caminho está no `how-to.md` (v3.55.0 G) e em [`../../test-ids.md`](../../test-ids.md) §6.
