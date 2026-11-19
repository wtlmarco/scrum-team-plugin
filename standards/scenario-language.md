# Linguagem de cenário — semântica dos verbos (nível 1, agnóstico de stack)

> **v3.62.0.** O que cada passo de um cenário `.scn` faz, **igual em todo alvo**: `web` (Playwright), `android` com `locator: "uiautomator"` (app nativo) e `android` com `locator: "cdp"` (app híbrido, WebView). Os nomes dos elementos vêm de [`test-ids.md`](test-ids.md). O executor é o `scripts/checks/accept.ps1`. A sintaxe está no cabeçalho dele, e os verbos de tela estão em `scripts/checks/targets/cdp-verbs.js`. Dono editorial: o Arquiteto (R16). Uma divergência entre alvos é defeito do executor e vai ao `/review`, nunca a uma decisão por Task.

## 1. Termos

- **Atributo de teste:** o de `guards.json → testIds.attribute` (`test-ids.md` §2). O seletor é sempre `[<atributo>="<id>"]`.
- **Renderizado:** o elemento atende às três condições:
  - nenhum ancestral (atravessando shadow root aberto) tem `display: none`, e o próprio elemento não tem `visibility: hidden`;
  - ele não está dentro de uma área de `hiddenScopes`;
  - ele tem caixa com área. Com `display: contents`, a caixa é a união da dos filhos.
- **`hiddenScopes`:** seletores CSS das áreas que o framework guarda no DOM sem estarem na tela, como as páginas anteriores da navegação. A configuração fica em `targets.web.hiddenScopes` ou `targets.android.cdp.hiddenScopes`. O padrão é vazio, e o valor de cada stack está no guia dela, em `stacks/<stack>/guide.md`.
- **Na tela:** renderizado, com o centro dentro da janela **e** dentro de todo ancestral que corta o conteúdo (`overflow` diferente de `visible`).
- **Achar `<id>`:** o **primeiro elemento renderizado**, na ordem do documento, com o atributo igual a `<id>`. Id repetido fora de `hiddenScopes` não é erro do executor: vale o primeiro renderizado.

## 2. Verbos de tela

| Verbo | Semântica |
|---|---|
| `tap <id>` | Acha o elemento e rola até ele ficar na tela. Faz o **hit-test** do centro: o ponto tem de cair no elemento ou num descendente dele, senão é FALHOU "coberto por …". Depois, **toque real** (dedo no aparelho, clique de mouse no web) e conferência de que o `pointerdown` chegou ao elemento. Nunca `el.click()` |
| `type <id> = <texto>` | **Substitui o valor.** Toca o elemento como no `tap` e acha o editável: o próprio campo, um `contenteditable` ou o primeiro `input`/`textarea` descendente, inclusive em shadow root aberto. Seleciona todo o conteúdo e insere o texto, que troca a seleção. No `uiautomator`, o transporte é outro: vai ao fim do campo, apaga o texto atual e digita. Ali, texto fora do ASCII é FALHOU com o motivo, nunca o texto corrompido |
| `select <id> = <opção>` | Num `<select>` nativo, escolhe a opção pelo rótulo visível, porque o seletor nativo abre fora da página. Num controle de outro tipo: toca, espera a opção **pelo texto visível** fora do controle, toca a opção e, se o seletor continuar aberto, toca o botão que casa `selectConfirm` |
| `slider <id> <v> <min> <max>` | Toque real no ponto proporcional da caixa. Depois lê o valor: diferente de `<v>` em mais de um passo do controle é FALHOU com o valor lido |
| `assert-text <id> = <t>` / `assert-contains` | Lê o elemento: num campo (`input`, `textarea`, `select`), o **valor**. Num web component com propriedade `value`, esse valor. Num elemento sem texto próprio com um único campo dentro, o valor desse campo. Fora isso, o texto renderizado (`innerText`) aparado. Espera até 4 s o elemento aparecer |
| `assert-exists <id>` | Existe renderizado. Espera até 8 s; se ainda não estiver no DOM (lista virtualizada), rola a página do topo ao fim procurando |
| `assert-absent <id>` | **Nenhum** elemento renderizado com o id. Um elemento dentro de `hiddenScopes`, ou não renderizado, conta como ausente |
| `assert-checked <id> = <bool>` | O `checked` do campo, senão o `aria-checked`, senão o `checked` do primeiro campo de dentro |
| `assert-count <prefixo> = <n>` | **Lista inteira** (decisão do stakeholder de 16/11/2026): todos os elementos renderizados cujo id começa pelo prefixo, dentro ou fora da janela. Quando a página rola, também os que aparecem do topo ao fim (lista virtualizada). Os de `hiddenScopes` não contam. O prefixo inclui o ponto final (`test-ids.md` §3) |
| `assert-order <prefixo> = a,b,c` | A mesma lista do `assert-count`, na ordem do documento (ou de aparição, na lista virtualizada). Os itens pedidos aparecem nessa ordem |

**Rolagem:**
- **Vertical:** no aparelho, o gesto do sistema (`adb input swipe`, em px físicos = CSS × `devicePixelRatio`). No web, a roda do mouse.
- **Horizontal, numa faixa rolável:** arrasto por toque.

O gesto vai a um ponto do rolador que não tem outro rolador por cima. O executor confere que a posição mudou e, se não mudou, tenta o meio seguinte.

## 3. Ciclo de vida

| Verbo | Android | Web |
|---|---|---|
| `reset` | `pm clear` do pacote | contexto novo do navegador |
| `launch` · `open [/caminho]` · `restart` | fecha e abre o app na tela inicial. Com `cdp`, depois espera a prontidão | abre ou recarrega a página |
| `back` | tecla voltar | voltar do navegador |
| `clock <aaaa-mm-dd hh:mm>` | data do aparelho | relógio do Playwright |
| `font-scale <f>` | escala de fonte do sistema. Com `cdp`, espera a prontidão de novo, porque a WebView é recriada | CSS no `html` |
| `seed <nome>` | comando de `targets.<alvo>.seeds.<nome>` | o mesmo |
| `wait <s>` · `shot <nome>` | espera · captura da tela | espera · captura da página |

**Prontidão (só `cdp`):**
- O app está pronto quando a expressão JS `targets.android.cdp.readyExpr` é verdadeira. O padrão é `document.readyState === 'complete'`.
- Se `targets.android.cdp.failExpr` for verdadeira na prontidão ou em qualquer passo, é FALHOU: o app está na **tela de falha dele mesmo**, e isso não é ambiente.
- O executor **nunca** navega a WebView por código, porque recarregar a WebView derruba o app híbrido.

**Tela de fora do app com `locator: "cdp"`** (decisão do stakeholder de 16/11/2026). Com o `cdp`, os verbos de tela vão à página do app. Uma tela do próprio Android (seletor de arquivos, permissão do sistema, outro aplicativo) não está nela. O critério que depende dessa tela é provado por **teste** (o cenário vai `(teste)`) e não por passo do `.scn`. O modo misto, em que o executor passa ao `uiautomator` os passos de tela do sistema, fica para quando aparecer o primeiro caso real (item da fila do `/review`).

## 4. Vereditos

| Veredito | Quando | Quem resolve |
|---|---|---|
| PASSOU | todos os passos passaram | — |
| FALHOU (exit 1) | o app ou o cenário: elemento ausente, valor diferente, toque coberto, tela de falha do app | o dev (app) ou o QA (cenário) |
| FALHA DE AMBIENTE (exit 4) | o alvo caiu: emulador, servidor, DevTools sem resposta | reparo e repetição |
| CONFIGURAÇÃO DO ALVO (exit 4, `configuration` no `result.json`) | o alvo, como está declarado, não prova nada: APK sem a depuração da WebView, Node < 22, mais de uma página sem `cdp.pageUrl`, `cdp.pageUrl` que não casa nenhuma página carregada, ou app híbrido com o `uiautomator` | o stakeholder (o `guards.json` e o build são dele). Sem reparo, sem dev e sem Arquiteto |

O `result.json` do `accept` com `locator: "cdp"` é **prova de primeira classe** no portão: a Task fecha por ele, sem decisão do Arquiteto e sem linha de desvio no `run-log.md`.

## 5. Executor do projeto (v3.62.3)

O projeto que já tem executor de cenários próprio (um script que lê os mesmos `.scn`, uma suíte de UI) não o roda **fora** do `accept.ps1`. No sprint 6 do projeto piloto, a Q-S6d dispensou o aceite e provou 49 cenários por um script do projeto: fora da trava do alvo, sem progresso que a sessão lesse, sem saber qual APK estava no emulador e com a prova fora de `.team-project/accept/`.

O plano da Task declara o executor no cabeçalho:

```
**Aceite:** comando — `<comando com {scn}, {out}, {only}, {task}>`
```

O `accept.ps1 -Task <ID>` lê a linha e faz o que faz sempre — trava do alvo, pré-voo e reparo, APK mais velho que o código, instalação, `targets.<alvo>.baseline` depois de instalar. No lugar do executor interno, chama o comando **um `.scn` por vez**, na raiz do projeto, num PowerShell filho:

| Marcador | Vira (um argumento inteiro, já entre aspas — não ponha aspas em volta) |
|---|---|
| `{scn}` (obrigatório) | o caminho do `.scn` |
| `{out}` | a pasta da prova desse arquivo: `.team-project/accept/<seg>/<ID>/cmd/<arquivo>` — as capturas vão aqui (`<SC-ID>*.png`) |
| `{only}` | os cenários da Task nesse arquivo, separados por vírgula; sem ele não há repetição |
| `{task}` | o ID da Task |

O comando também recebe `ACCEPT_TASK`, `ACCEPT_TARGET`, `ACCEPT_SERIAL`, `ACCEPT_PACKAGE`, `ACCEPT_SCENARIOS`, `ACCEPT_ONLY` e `ACCEPT_OUT` no ambiente.

**O que o executor devolve:** uma linha por cenário na saída, `<SC-ID> PASSOU|FALHOU|NÃO EXERCITADO [detalhe]` (o ID pode vir entre colchetes, como o `accept.ps1` imprime; a última linha do cenário vale), e o código de saída:

| Exit do executor | O `accept` |
|---|---|
| 0, 1, 3 | lê as linhas; cenário da Task sem linha conta como **FALHOU** |
| 2 sem nenhuma linha | para com exit 2 (uso ou cenário malformado) |
| 4, ou o tempo por arquivo esgotado (`targets.<alvo>.commandTimeoutMin`; padrão 5 min por cenário, mínimo 10) | FALHA DE AMBIENTE (exit 4), com a última linha da saída |

Cenário que FALHOU é repetido uma vez, sozinho, quando o comando tem `{only}`, como no executor interno. O `accept` grava `progress.json` a cada arquivo e, no fim, o `result.json` e o `result.md` de sempre, com `executor: "comando"`, o comando e cada chamada (`runs`: arquivo, cenários, exit, segundos, log). O `close.ps1`, o `/team-status` e o portão do QA o leem como qualquer accept.

**Sem o localizador do plugin:** a tela é do executor — o pré-voo do `locator` não roda, e o `reset` de um cenário não reaplica o `baseline` (só a instalação o aplica). O comando passa pelo mesmo filtro da **Verificação:** — instalação, rede, push e destrutivo reprovam no `plan.ps1` e no `accept.ps1`. `**Aceite:** não roda` fica para cenário provado pelos testes do plano; o que cita um script do projeto reprova (regra 34).
## 6. Retomada do aceite — `-Resume` (v3.63.0)

`accept.ps1 -Task <ID> -Resume` não repete o que já está provado. Ele lê a rodada anterior da mesma pasta (o `progress.json` ou o `result.json`, o mais novo) e **reaproveita a linha PASSOU** de cada cenário quando duas coisas são iguais:
- **a identidade do app que o accept prova:** no `android`, o hash do APK **instalado no aparelho** (v3.63.1: o SHA-1 do `base.apk` lido por `pm path` e `sha1sum` — vale também para o APK instalado pelo comando do projeto, sem arquivo local; sem `sha1sum`, a versão e a hora da última instalação; o arquivo local só quando o aparelho não responde); no `web`, o hash dos arquivos de `targets.web.appSources` (máscaras, opcional) ou, sem ela, a árvore de produção;
- **o texto do cenário** (o id e os passos — o campo `hash` de cada linha do `result.json`).

Roda só os que faltaram, falharam ou mudaram. A linha reaproveitada sai com `reused: true` e a nota "reaproveitado: passou em <hora> com o mesmo app e o mesmo cenário" — a hora é a da prova original, mesmo depois de várias retomadas. App diferente, ou identidade que não pôde ser lida (`web:?`, `apk:?`), roda todos e diz por quê. Com o executor do projeto (§5), a retomada vale quando o comando tem `{only}`; sem ele, o arquivo inteiro roda de novo.

O `progress.json` guarda todas as linhas da rodada, e não só a última: a queda no cenário 30 de 49 deixa os 29 primeiros para a retomada. O `result.json` traz também `app`, `prod` (a árvore de produção) e `scenariosHash` (o conjunto de `.scn`) — é por eles que o portão do sprint sabe se a medição venceu (`sprint-run.md` §Validação do sprint).

**A prova da falha no android (v3.63.1).** O registro do aparelho começa limpo em cada cenário e, na falha, vai a `logs/<ID>-<tentativa>-logcat.txt` (com o buffer de crash); com o executor do projeto, um por arquivo (`logs/<arquivo>-logcat.txt`). A linha que falhou traz `signal`, `signalText` e `log`. O sinal é separado do foco — o app reiniciado também fica sem foco por instantes: `crash` (o app fechou com erro) · `anr` (parou de responder) · `closed` (o processo sumiu, sem crash) · `restarted` (pid novo, sem crash) · `webview-recreated` (mesmo pid, a página caiu) · `system-window` (outra janela em foco) · `no-focus` (o app roda e nenhuma janela dele tem o foco). O app que fecha com erro ou não responde ao abrir é **FALHOU do cenário**, não ambiente. A interrupção por ambiente grava `environmentSignal` (`kind`, `text`, `scenario`, `log`, `shot`), e o `run.ps1` manda ao diagnóstico do operator antes do reparo, salvo `system-window`.
