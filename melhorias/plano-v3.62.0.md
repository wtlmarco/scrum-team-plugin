# Plano de Implementação — v3.62.0: localizador CDP para app híbrido no alvo `android`

> **Escrito para:** você (autor do plugin), para aprovar, e para a sessão de desenvolvimento do plugin que vai construir a versão. Nada aqui é commitado nem vira PR sem pedido seu.

**Origem:** item 25 de `note.md`, que absorveu o antigo item 2 e o sub-item do `content-desc` do item 8.

**Decisões do stakeholder (16/11/2026, formulário):**
- Vira **versão v3.62.0 com plano**. Não é Task de `/review`.
- `assert-count` e `assert-order` valem para a **lista inteira**, igual nos três executores.
- **Revogada** a espera pelo espelho do id no `aria-label`. Os itens 2 e 8 foram fundidos no 25.
- **A correção é genérica.** Serve a qualquer projeto que instale o plugin e a qualquer app híbrido em WebView (Capacitor, Cordova, Ionic ou outro). O garden foi só o projeto em que o sintoma foi medido. No plugin não fica fixo nenhum app id, rota, seletor ou framework. O que é de um projeto vira configuração. O que é de uma stack vira recomendação no guia da stack, com valor padrão neutro.

---

> **Construído (16/11) — o que mudou em relação a este plano** (detalhe no bloco `## v3.62.0` do `CHANGELOG.md`):
> - **CONFIGURAÇÃO DO ALVO sai com exit 4**, com o campo `configuration` no `result.json`, e não com exit 2. Assim ela aproveita a rota que o `run.ps1 done -Result env` já tinha, que lê o `result.json` antes de reparar. O dev e o executor de Task não mudam, e não há reparo nem reabertura (§2.3).
> - **Os verbos de tela ficaram num módulo compartilhado**, `targets/cdp-verbs.js`. O `web-runner.js` também passou a usá-los, pela sessão CDP do Playwright e com clique de mouse, então "uma implementação" é literal. O `android-cdp.js` ficou só com a conexão com a WebView.
> - **Teste do `dom-probe.js`:** não ganhou teste `node:test` próprio. Ele é coberto pela paridade (`tests/parity.js`).
> - **Rolagem com mais um meio:** no Chromium headless, o gesto de toque não rola a página na vertical, mas a roda do mouse rola. A rolagem tenta, em ordem, `adb` → arrasto → gesto sintetizado → roda, e confere a posição. O ponto do gesto evita cair em outro rolador por cima.
> - **"Renderizado" sem `aria-hidden`:** um modal aberto marca o resto da página com `aria-hidden`, e isso esconderia elementos que estão de fato na tela.
> - **Medido:** 368 ms por passo, e paridade cdp 15/15 · web 15/15 em 3 rodadas seguidas.

## 1. Objetivo e fora de escopo

Depois desta versão, um projeto com app híbrido declara `"locator": "cdp"` em `guards.json → targets.android`. Os mesmos cenários `.scn` passam a localizar, ler, tocar e digitar pelo DOM da WebView, pelo DevTools Protocol (CDP), no mesmo emulador ou aparelho. O `result.json` do `accept` nesse modo é **prova de primeira classe**: sem desvio registrado, sem 🔺 GAP e sem decisão do Arquiteto por Task.

Ao mesmo tempo, a semântica de cada verbo fica escrita **uma vez** em `standards/` e é aplicada igual no `web`, no `android/uiautomator` e no `android/cdp`.

**Fora do escopo:**
- **App nativo (Compose, Views):** continua no `uiautomator`, e o padrão de `locator` é `uiautomator`. Nada muda para quem não declara a chave, exceto as correções de semântica da §4, que valem para todos.
- **iOS, Windows desktop e API:** ficam como estão.
- **`connectOverCDP` do Playwright na WebView:** não é usado, porque nunca foi medido. O transporte é o CDP cru (`WebSocket` global do Node ≥ 22), que já foi provado em campo.
- **Escrever no DOM para simular ação:** proibido, com duas exceções, definidas na §4: o `<select>` nativo e a seleção de texto antes do `type`. O executor nunca chama `Page.navigate`, que recarrega a WebView e derruba o app (IONIC-P15). Abrir, reabrir e voltar continuam pelo `adb`.

---

## 2. Desenho

### 2.1 Quem faz o quê no modo `cdp`

| Camada | Onde | O quê |
|---|---|---|
| Ciclo de vida | `targets/android.ps1` (sem mudança de comportamento) | pré-voo, reparo, `serial`, instalação, `reset` (`pm clear`), `seed`, `baseline`, `launch`/`open`/`restart`, `back`, `clock`, `font-scale` (`settings put system font_scale`), `shot` (`screencap`), `wait` |
| Conexão | `targets/android.ps1` (funções novas `*-AndroidCdp`) | `pidof <pacote>` → socket `webview_devtools_remote_<pid>` em `/proc/net/unix` → `adb forward tcp:0 localabstract:<socket>` (porta livre escolhida pelo `adb`) → remoção do forward no fim |
| Verbos de tela | `targets/android-cdp.js` (novo) | `tap`, `type`, `select`, `slider` e todos os `assert-*`, além da espera de prontidão depois de abrir |
| Leitura do DOM | `targets/dom-probe.js` (novo, compartilhado) | busca por id, visibilidade, valor de campo, coleta de ids por prefixo e hit-test, como funções avaliadas na página. É usado pelo `android-cdp.js` e pelo `web-runner.js` |

**Chamada por passo.** O `Invoke-Once` do `accept.ps1`, no modo `cdp`, continua percorrendo os passos em PowerShell:
- os verbos de ciclo de vida vão ao `Invoke-AndroidStep`, como hoje;
- os verbos de tela vão a `node android-cdp.js <entrada.json> <saida.json>`, com o mesmo contrato de arquivo JSON do `web-runner.js`, num passo só.

O processo do Node abre a conexão, consulta o `/json`, executa o passo e fecha. Assim, a reconexão depois de `launch`, `restart`, `reset` e `font-scale` sai de graça: todo passo resolve a página de novo. O PowerShell refaz o `forward` só quando o pid do app muda.

- **Orçamento:** ≤ 0,5 s de sobrecarga por passo (abrir o Node, o `/json` e o WebSocket). É medido no passo A3.
- **Se estourar:** o `android-cdp.js` aceita a entrada com um **cenário inteiro** e devolve ao PowerShell só os verbos de ciclo de vida, por arquivo de retorno. Esse modo **não** é construído antes de a medição pedir.

### 2.2 Configuração — `guards.json → targets.android`

```json
"locator": "cdp",
"cdp": {
  "pageUrl": "^https?://localhost(/|$)",
  "readyExpr": "document.readyState === 'complete'",
  "readyTimeoutSec": 30,
  "failExpr": "",
  "hiddenScopes": [],
  "stepTimeoutSec": 60,
  "callTimeoutMs": 10000
}
```

| Chave | Padrão | Para que serve |
|---|---|---|
| `locator` | `"uiautomator"` | `"cdp"` liga o modo novo. Qualquer outro valor → `accept` sai com exit 2 |
| `cdp.pageUrl` | *(vazio)* | Expressão regular que escolhe a página do app no `/json`. Vazio: vale a única `page` com URL diferente de `about:blank`. Com mais de uma candidata e sem `pageUrl` → exit 2, pedindo a chave e listando as URLs vistas |
| `cdp.readyExpr` | `document.readyState === 'complete'` | Expressão JS que diz que o app está pronto depois de `launch`/`open`/`restart`. O projeto põe aqui a própria condição (rota inicial, splash fora do DOM) |
| `cdp.readyTimeoutSec` | 30 | Prazo da prontidão. Estourou → FALHOU no passo de abertura, com a URL e o título da página |
| `cdp.failExpr` | *(vazio)* | Expressão JS que é verdadeira quando o app está na **tela de falha dele mesmo**. Verdadeira na prontidão ou em qualquer passo → FALHOU ("o app está na tela de falha"), não AMBIENTE. Generaliza o `failRoute` sugerido no item: `location.pathname.startsWith('/falha')` é um caso |
| `cdp.hiddenScopes` | `[]` | Seletores CSS de áreas que o framework mantém no DOM sem estarem na tela (páginas em cache da navegação). Elementos dentro delas **não existem** para o cenário. O guia da stack recomenda o valor (§5) |
| `cdp.stepTimeoutSec` | 60 | Prazo do processo do Node por passo. Estourou → o processo é encerrado e o passo é AMBIENTE, com o comando |
| `cdp.callTimeoutMs` | 10000 | Prazo de cada chamada CDP dentro do passo |

`testIds.attribute` continua valendo: no app híbrido é `id`. O seletor é sempre `[<atributo>="<id>"]`, nunca `#id` (`standards/test-ids.md` §2).

### 2.3 Códigos de saída e mensagens novas do `accept`

| Situação | Saída | Mensagem (resumo) | Por quê |
|---|---|---|---|
| `locator: cdp` e nenhum socket `webview_devtools_remote_<pid>` depois do `launch` | **exit 2, CONFIGURAÇÃO DO ALVO** | "o APK não liga a depuração da WebView — no Capacitor, `android.webContentsDebuggingEnabled: true` no `capacitor.config.*`; nos demais, `WebView.setWebContentsDebuggingEnabled(true)` no build de debug" | O reparo do emulador não resolve, e o dev não depura isso. É o mesmo tratamento do APK velho (exit 2). **Desvio do item:** o item sugeria AMBIENTE (exit 4). Escolhi exit 2 porque o exit 4 dispara reparo e reabertura sem efeito. Revise se discordar |
| `locator: cdp` com Node < 22 ou sem Node | exit 2 | "o `locator: cdp` precisa do Node 22 ou mais novo (WebSocket global)" | — |
| `locator: uiautomator` e o dump, com o app na frente, tem `android.webkit.WebView` sem nenhum `resource-id` fora dos do Android | **exit 2, CONFIGURAÇÃO DO ALVO**, antes do 1º cenário | "app híbrido: a WebView não publica o id HTML no uiautomator — declare `targets.android.locator = \"cdp\"` (standards/test-ids.md §6)" | Substitui o `Test-IdsHidden`, que só disparava depois de 2 cenários falharem e mandava "outro executor, com desvio registrado" |
| Toque num elemento coberto por outro | FALHOU (exit 1) | "toque em `<id>` caiu em `<tag#id.classe>` (coberto)" | Defeito do app ou do cenário, não do alvo |

O `run.ps1 done` trata a CONFIGURAÇÃO DO ALVO assim:
- a Task vai a 🔴 com o motivo "configuração do alvo";
- a sessão leva ao stakeholder, porque o `guards.json` e o build são dele;
- nada vai ao Arquiteto ou ao dev, e nada é reaberto sozinho.

O ramo `IDS NÃO PUBLICADOS` do `run.ps1` (linhas 1038 a 1057) sai. O `result.json` antigo com esse texto passa a ser lido como CONFIGURAÇÃO DO ALVO, para compatibilidade. A política `run.deviceProofFallback` continua valendo só para o ESTADO DE PARTIDA.

---

## 3. Arquivos — lista fechada

### A criar
| Caminho | O quê |
|---|---|
| `scripts/checks/targets/dom-probe.js` | Funções de leitura avaliadas na página, sem dependência: `find(id)`, `isRendered(el)`, `boxOf(el)` (com `display: contents`), `fieldValue(el)`, `editableOf(el)`, `idsByPrefix(prefix)`, `hitTest(x, y, el)` (atravessa shadow roots abertos). Exporta o código-fonte de cada uma para `Runtime.evaluate` e `page.evaluate` |
| `scripts/checks/targets/android-cdp.js` | Transporte CDP: `/json`, WebSocket com prazo por chamada, `Input.dispatchTouchEvent`, `Input.insertText`, arrasto horizontal, prontidão e `failExpr`. Vale para um passo por chamada (§2.1) |
| `scripts/checks/tests/fixtures/parity/index.html` | Página neutra da paridade (§6). Sem framework e sem nome de produto |
| `scripts/checks/tests/fixtures/parity/parity.scn` | Cenários com todos os verbos e os casos de regressão |
| `standards/scenario-language.md` | Semântica de cada verbo, igual em todo alvo (§4). Dono: Arquiteto |

### A alterar
| Caminho | Mudança |
|---|---|
| `scripts/checks/accept.ps1` | `-Target android` com `locator`. `Invoke-Once` encaminha os verbos de tela ao `android-cdp.js`. Novo pré-voo híbrido (§2.3). Sai o `Test-IdsHidden` e o texto da linha 239. Cabeçalho da linguagem: aponta para `standards/scenario-language.md` |
| `scripts/checks/targets/android.ps1` | Funções `Get-AndroidAppPid`, `Get-AndroidCdpSocket`, `Open-AndroidCdpForward`, `Close-AndroidCdpForward` e `Invoke-AndroidCdpStep`. Sai o comentário C2 das linhas 3-4, que é falso. Sai o recurso ao `content-desc` no `Find` (linhas 343-352). O `type` do `uiautomator` passa a substituir o valor (§4) |
| `scripts/checks/targets/web-runner.js` | Passa a usar o `dom-probe.js` para busca, visibilidade, valor e lista, e a receber `hiddenScopes` (`targets.web.hiddenScopes`). O `assert-absent` deixa de contar elemento não renderizado (§4) |
| `scripts/checks/targets/web.ps1` | Repassa `hiddenScopes` ao `web-runner.js` |
| `scripts/checks/run.ps1` | Ramo da CONFIGURAÇÃO DO ALVO no `done`, que substitui o `IDS NÃO PUBLICADOS` (§2.3) |
| `scripts/checks/lib.ps1` | Leitura e validação de `targets.android.locator` e `targets.android.cdp`. Comentário do `run.deviceProofFallback` (linha 1891) sem `IDS NÃO PUBLICADOS` |
| `scripts/checks/target.ps1` | O `-Kill` também remove os `adb forward` para `webview_devtools_remote_*` deste serial |
| `scripts/checks/tests/run-check-tests.ps1` | Testes novos (§6). Os testes do `content-desc` (≈2290-2318) e do `IDS NÃO PUBLICADOS` (≈2418-2483) são reescritos para o comportamento novo |
| `deliverables/team-project/guards.json` | Comentários das chaves `targets.android.locator`, `targets.android.cdp.*` e `targets.web.hiddenScopes`. O comentário de `run.deviceProofFallback` deixa de citar `IDS NÃO PUBLICADOS` |
| `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` | Versão 3.62.0 |
| `CHANGELOG.md` | Bloco `## v3.62.0` (R17) |

### Documentos — fase G, por `/review`, depois de A a F verdes (o dono de cada um aplica)
| Caminho | Dono | Mudança |
|---|---|---|
| `standards/test-ids.md` §2, §4, §6 | Arquiteto | A linha "Híbrido" passa a dizer que o `id` é lido **pelo CDP** (`locator: cdp`) e que o `uiautomator` não o publica nas WebViews atuais. Sai a "Evidência do híbrido" com o caminho de um projeto (é vazamento de contexto de projeto). A §6 é reescrita sem "Não há driver por CDP", e o `[PARCIAL]` deixa de ser o limite do híbrido |
| `standards/stacks/ionic-capacitor/guide.md` IONIC-3, linha 10 | Arquiteto | Recomenda `locator: cdp`, `hiddenScopes: [".ion-page-hidden"]` e `android.webContentsDebuggingEnabled` no build de debug. Explica que o valor de `ion-input`/`ion-textarea` sai do `.value` do host (já coberto pelo `fieldValue` genérico) |
| `roles/quality-assurance/README.md` (linhas 58 e 116) | QA | No híbrido, a tela da WebView vira cenário executável com `locator: cdp`. Sai o "vai como 🔺 GAP ao Arquiteto" para esse caso. "tag não encontrada" com `uiautomator` em app híbrido é configuração do alvo |
| `roles/developer/*` (GAP de `ambiente`) | Arquiteto | Mesma regra: não é GAP nem ambiente da Task |
| `roles/architect/templates/implementation-plan.md` | Arquiteto | Conferir se cita a prova por outro executor. Se citar, tirar |
| `roles/scrum-master/process/sprint-run.md` (linha 62) | SM | A rota de GAP da prova no alvo exclui a CONFIGURAÇÃO DO ALVO, que vai ao stakeholder |
| `how-to.md` (linhas 656 e 678), `rituals/team-init.md` (linha 56), `rituals/team-update.md` (linha 225) | stakeholder (proposta com texto pronto) | No formulário do atributo, a stack híbrida propõe também `targets.android.locator = "cdp"`. O `how-to` explica a configuração e a mensagem de CONFIGURAÇÃO DO ALVO |
| `note.md` e `roles/scrum-master/process/process-changelog.md` | SM | Tira o item 25 da fila (vai ao changelog) e registra a regra de portão nova (R17/R18) |

---

## 4. Semântica dos verbos — o texto de `standards/scenario-language.md`

Vale para `web`, `android/uiautomator` e `android/cdp`. Os termos:
- **Renderizado:** o elemento tem caixa com área maior que zero, ou, com `display: contents`, algum filho tem. Nenhum ancestral tem `display: none`, `visibility: hidden`, `hidden` ou `aria-hidden="true"`, e o elemento não está dentro de um `hiddenScopes`.
- **Na tela:** renderizado e dentro da janela visível.

| Verbo | Semântica única |
|---|---|
| achar `<id>` | O **primeiro elemento renderizado** com o atributo de teste igual a `<id>`, na ordem do documento. Id repetido fora de `hiddenScopes` não é erro do executor: vale o primeiro renderizado |
| `tap <id>` | Rola até o elemento ficar na tela. Faz o hit-test do centro: o ponto tem de cair no elemento ou num descendente dele, atravessando shadow DOM aberto. Senão, FALHOU "coberto por …". Depois, **toque real** (`touchStart`/`touchEnd`) e conferência de que o `pointerdown` chegou ao elemento. Nunca `el.click()` |
| `type <id> = <texto>` | **Substitui o valor.** Toca o elemento (como o `tap`) e acha o editável: o próprio `input`/`textarea`, ou o primeiro `input`/`textarea` descendente, inclusive em shadow root aberto. Seleciona todo o conteúdo (`setSelectionRange(0, length)`, que não grava valor) e insere o texto, que troca a seleção. No CDP, isso é `Input.insertText`, que aceita qualquer caractere. No `uiautomator`: `MOVE_END` mais `DEL` × o tamanho atual, e depois `input text`. Texto fora do ASCII nesse transporte → FALHOU "o uiautomator não digita fora do ASCII", nunca corrompe calado |
| leitura de `<id>` (`assert-text`, `assert-contains`) | Campo (`input`, `textarea`, `select`) → o **valor**. Elemento com propriedade `value` de texto (controle de formulário em web component) → esse valor. Elemento sem valor próprio que contém um editável → o valor do editável. Fora isso → o texto renderizado (`innerText`) aparado |
| `select <id> = <opção>` | `<select>` nativo → escolhe a opção pelo rótulo visível (exceção a "não escrever no DOM": o seletor nativo abre fora da WebView) e dispara `input`/`change`. Outro controle → toca, espera a opção **pelo texto visível** fora do controle, toca a opção e confirma no botão que casa com `selectConfirm`, se houver |
| `slider <id> <v> <min> <max>` | Toque real no ponto proporcional da caixa. Depois lê o valor. Diferente de `<v>` (com a tolerância de um passo do controle) → FALHOU com o valor lido |
| `assert-exists <id>` | Existe renderizado, rolando se preciso |
| `assert-absent <id>` | **Nenhum** elemento renderizado com o id. Elemento dentro de `hiddenScopes` ou não renderizado conta como ausente |
| `assert-count <prefixo> = <n>` / `assert-order` | **Lista inteira** (decisão de 16/11): todos os elementos renderizados com o prefixo, dentro ou fora da janela, rolando até não aparecer id novo (lista virtualizada). Excluem-se os de `hiddenScopes`. A ordem é a do documento, ou a de aparição na rolagem quando a lista é virtualizada |
| `assert-checked <id> = <bool>` | `checked` do campo, ou `aria-checked` do controle |
| `font-scale <f>` | Escala do sistema no aparelho (`android/*`). CSS no `html` no `web` |
| rolagem | Vertical: gesto do sistema (`adb input swipe`, px físicos = CSS × `devicePixelRatio`). Horizontal, dentro de uma faixa rolável: arrasto por toque |

**Mudança visível para projetos existentes:**
- no `web`, o `assert-absent` não conta mais elemento escondido;
- o id repetido passa a valer pelo primeiro renderizado;
- no `uiautomator`, o `type` substitui o valor em vez de inserir no cursor.

Os três entram no CHANGELOG como correção de semântica. Nenhum cenário bem escrito deixa de passar por isso.

---

## 5. Passos

Cada passo fecha com a verificação dele. Do B em diante, a suíte `run-check-tests.ps1` fica verde ao fim de cada passo.

### A. Transporte CDP, sem tocar no `accept`
1. **`dom-probe.js`:** funções puras da §3, sem nenhum nome de framework. **Verificação:** um teste `node:test` em `scripts/checks/tests/` avalia cada função num DOM de navegador real, pelo mesmo headless do item A2. Isso cobre `display: contents`, shadow root aberto, `hiddenScopes` e id repetido.
2. **`android-cdp.js` contra um Chromium de desktop:** o transporte não depende do Android. O teste sobe Edge ou Chrome headless com `--remote-debugging-port=0`, lê a porta do `DevToolsActivePort`, liga `Emulation.setTouchEmulationEnabled` e aponta o executor para essa porta com `scrollVia: "cdp"`. Nesse modo, o arrasto vertical também sai pelo CDP. **Verificação:** todos os verbos de tela passam na página de paridade (§6), sem emulador.
3. **Medição da sobrecarga por passo:** 50 `assert-exists` seguidos, no desktop e, se houver emulador, no aparelho. **Verificação:** o número vai ao CHANGELOG. Acima de 0,5 s por passo, abre-se o modo "cenário inteiro" da §2.1 antes do passo B.

### B. Conexão no `android.ps1`
4. `Get-AndroidAppPid` (`pidof`), `Get-AndroidCdpSocket` (`/proc/net/unix`, só `webview_devtools_remote_<pid>`, ignorando `chrome_devtools_remote`), `Open-AndroidCdpForward` (`adb forward tcp:0 …`, que devolve a porta), `Close-AndroidCdpForward` (`--remove`). Toda chamada vai por `AdbT` com prazo. **Verificação:** testes com o `adb` simulado (o padrão que a suíte já usa para o `android.ps1`) cobrem pid ausente, socket ausente, porta devolvida e remoção.
5. `Invoke-AndroidCdpStep`: escreve a entrada (porta, `pageUrl`, atributo, `hiddenScopes`, `readyExpr`, `failExpr`, prazos, `adb` e `serial` para a rolagem, `devicePixelRatio`), chama o Node com o prazo `stepTimeoutSec` (encerra o processo se estourar) e lê a saída. Refaz o forward quando o pid muda. **Verificação:** teste com o Node simulado que estoura o prazo → AMBIENTE com o comando, sem processo órfão.

### C. `accept.ps1`
6. Lê `locator` e valida a chave (§2.2). No `Invoke-Once` com `cdp`, os verbos de ciclo de vida vão ao `Invoke-AndroidStep` e os de tela ao `Invoke-AndroidCdpStep`. Depois de `launch`/`open`/`restart`, um passo implícito de prontidão (`readyExpr`, `failExpr`). Os forwards são removidos no `finally`, junto com a trava do alvo. **Verificação:** `-ParseOnly` sem mudança, e um teste de roteamento verbo a transporte com os dois simulados.
7. Pré-voo híbrido (§2.3): com `cdp`, Node ≥ 22 e o socket depois do primeiro `launch`. Com `uiautomator`, o dump da WebView sem ids do app → exit 2 antes do 1º cenário. Saem o `Test-IdsHidden` e o texto da linha 239. **Verificação:** os testes ≈2483 reescritos dão exit 2 com "declare `targets.android.locator`", sem cenário rodado. Um teste novo cobre o socket ausente → exit 2 com a mensagem da depuração da WebView.

### D. Semântica nos três executores
8. `web-runner.js` passa a usar o `dom-probe.js` (busca, `assert-absent`, `assert-count`/`order` e leitura de valor) e recebe `hiddenScopes`. **Verificação:** a paridade no `web` (§6) e os testes do `web` que já existem continuam verdes.
9. `uiautomator`: `type` substitui o valor e recusa texto fora do ASCII; sai o recurso ao `content-desc` no `Find`; sai o comentário C2. **Verificação:** teste do `type` com o `adb` simulado (sequência `MOVE_END`/`DEL`/`input text`), e o teste ≈2318 reescrito: o `content-desc` não acha mais id.

### E. Portões
10. `run.ps1 done`: o ramo da CONFIGURAÇÃO DO ALVO, mais a leitura de compatibilidade do `IDS NÃO PUBLICADOS` (§2.3). **Verificação:** os testes ≈2420 e ≈2436 reescritos dão 🔴 "configuração do alvo", sem `-Repair`, sem Arquiteto e sem `prove`. Um teste novo cobre o `result.json` do `accept` com `locator: cdp` e todos os cenários PASSOU: a Task fecha sem nenhuma linha de desvio no `run-log.md`.
11. `target.ps1 -Kill` remove os forwards da WebView deste serial. **Verificação:** teste com o `adb` simulado.

### F. Modelo, versão e release
12. `deliverables/team-project/guards.json`, a versão nos dois `.json` do `.claude-plugin/` e o `CHANGELOG.md` (`## v3.62.0`, com "Testes novos", "Mudança visível" da §4 e "Não testado em sessão real"). **Verificação:** `scripts/checks/release.ps1` dá C3 ok, conferências N/0 e guardas N/0.

### G. Documentos, por `/review`, na mesma branch e depois de F verde
13. `/review` com a instrução "aplicar a fase G do plano-v3.62.0": cada dono aplica o que é dele (tabela da §3) e o SM faz a curadoria e tira o item 25 da fila. **Verificação:** `release.ps1` de novo, e um Grep sem resultado por "outro executor, com desvio registrado", "espelha o id no aria-label" e "Não há driver por CDP" fora de `CHANGELOG.md` e dos arquivos de histórico.

---

## 6. Teste de paridade

**Página neutra** (`fixtures/parity/index.html`), com um caso por regressão medida e nada de produto:

| Caso | Na página | O que prova |
|---|---|---|
| `type` em campo com texto | `<input id="p.campo" value="texto antigo">` | o valor final é exatamente o digitado |
| controle de formulário em web component | elemento customizado com shadow root aberto, `<textarea>` interno e a propriedade `value` no host | `type` e leitura pelo `.value` |
| página em cache com id repetido | dois blocos com o mesmo `id`, um dentro de `.p-cache` (declarado em `hiddenScopes`, renderizado fora da tela por `transform`) e outro visível | busca, `assert-absent` e `assert-count` ignoram o bloco em cache |
| `display: contents` | `<div id="p.contents" style="display:contents"><span>…</span></div>` | `assert-exists` e `tap` acham a caixa pelos filhos |
| camada cobrindo o alvo | botão sob uma sobreposição transparente | `tap` dá FALHOU "coberto por …" |
| fora da janela | lista de 40 itens `p.lista.item.<n>.` | `assert-count = 40` e `tap` no último exigem rolagem |
| faixa horizontal | trilho rolável na horizontal com o alvo no fim | o arrasto horizontal alcança o alvo |
| `select` e `slider` | `<select>` nativo, um seletor feito de botões e um `<input type="range">` | os dois verbos nos dois transportes |
| `type` fora do ASCII | `ação, maçã — ✓` | CDP e `web` passam |

**Onde roda:**
- **`web` (Playwright):** na suíte, quando o Playwright está instalado. Sem ele, o teste sai como **NÃO EXECUTADO** com o motivo, nunca como verde.
- **`cdp` contra o Chromium de desktop:** na suíte, sempre que houver Edge ou Chrome. Os dois têm de dar **os mesmos vereditos**, cenário a cenário, e o teste compara os dois `result.json`.
- **`android/cdp` num emulador real:** manual, fora da suíte. É a prova de campo da §7.

O `uiautomator` entra na paridade só pelos verbos que ele sabe fazer, com o `adb` simulado.

---

## 7. Critério de pronto

**No plugin (obrigatório para o merge):**
- `run-check-tests.ps1` e `run-guard-tests.ps1` verdes, e `release.ps1` com C3 ok;
- paridade `web` × `cdp` (desktop) com vereditos idênticos em todos os casos da §6;
- nenhum app id, rota, seletor de framework ou nome de projeto em `scripts/checks/targets/*` e `standards/scenario-language.md`. Grep por `ion-`, `capacitor`, `horta` e `garden` nesses arquivos: zero, fora de comentário de histórico.

**Prova de campo (num projeto real com app híbrido, depois do merge):**
- Com `"locator": "cdp"`, o `accept -Target android` sobre o APK de debug dá PASSOU num cenário com `type` em campo que já tem texto (o valor é substituído) e com `assert-contains` lido do valor do campo.
- O `run.ps1 done` fecha a Task pelo `result.json` do `accept`, sem decisão do Arquiteto e sem "desvio registrado".
- O `accept` dos cenários do sprint termina sem nenhum `NÃO EXERCITADA (ambiente)` causado por id.
- Um cenário com id dinâmico (item de lista pela chave da entidade) passa no aparelho. Isso fecha o antigo item 2: o id dinâmico confirmado em execução.
- O projeto em que o sintoma foi medido serve para esta prova, com o SC-147 e o SC-204 de lá. Mas a prova **não define** a solução. Se ela pedir algo específico daquele app, isso vira configuração, não código do plugin.

**Do lado do projeto de campo (não é deste repositório):** ligar a depuração da WebView no build de debug, trocar o `locator` no `guards.json`, declarar `readyExpr`, `failExpr` e `hiddenScopes`, e aposentar o executor CDP próprio.

---

## 8. Riscos

| Risco | Mitigação |
|---|---|
| Sobrecarga do Node por passo | Medida no A3, com orçamento de 0,5 s. O modo "cenário inteiro" existe como saída, não como primeira opção |
| Porta de depuração ocupada por outro Chrome (ex.: o Karma) | Porta livre escolhida pelo `adb` (`tcp:0`) e página filtrada por `pageUrl`. Nunca porta fixa |
| Forward esquecido depois de queda | Removido no `finally` do `accept` e pelo `target.ps1 -Kill`. A trava do alvo impede duas execuções no mesmo serial |
| WebView recriada (`font-scale`, `restart`) | Todo passo resolve a página no `/json` de novo. O forward é refeito quando o pid muda |
| A mudança de semântica no `web` muda resultado de cenário existente | Só deixa de contar elemento escondido e passa a pegar o primeiro renderizado. Vai ao CHANGELOG em "Mudança visível" |
| `Input.insertText` em controle com máscara de entrada | Fora do caso medido. Se aparecer, vira cenário de paridade e item de `pitfalls` da stack, não remendo no executor |

---

## 9. Decisões de desenho tomadas aqui (revisáveis antes de começar)

1. **Socket ausente = exit 2 (CONFIGURAÇÃO DO ALVO), não AMBIENTE.** Motivo na §2.3.
2. **`failRoute` virou `failExpr`** (expressão JS). Cobre rota, elemento ou qualquer condição do app sem o plugin conhecer a navegação.
3. **`hiddenScopes` por configuração, com padrão vazio**, em vez de `.ion-page-hidden` fixo. A recomendação fica no guia da stack.
4. **Uma chamada do Node por passo**, com o ciclo de vida em PowerShell. Mantém o `android.ps1` como dono do aparelho, e a reconexão sai de graça.
5. **Documento novo `standards/scenario-language.md`** em vez de crescer o `test-ids.md`, que trata de nomes, não de verbos.
