# Padrão de ids de teste (nível 1, agnóstico de stack)

> **v3.55.0 · v3.62.0** (híbrido lido pelo CDP, §2 e §6). Um nome para cada elemento que um teste ou um cenário lê ou toca — o mesmo em todo o sistema, em qualquer alvo. O **nome** é único; o **atributo** que o carrega muda por alvo (§2). Dono editorial: o Arquiteto (R16). Dev e QA leem a seção citada; defeito aqui vai por GAP ou achado de processo ao `/review`.

## 1. Quais elementos levam id

Todo elemento que um teste ou um cenário `.scn` **lê ou toca**:

- a **raiz da tela**;
- **controles** (botão, campo, caixa de seleção, aba, opção de combo…);
- **itens de lista e linhas**;
- **células lidas**;
- **valores exibidos** (título, total, status…);
- **mensagens de erro**;
- **estados** vazio, carregando e erro.

Ficam de fora: texto decorativo e containers de layout. Id em tudo vira ruído.

O id **não substitui a acessibilidade**: `content-desc`, `aria-label` e os textos continuam; só deixam de ser seletor.

## 2. Atributo por alvo

| Alvo | Atributo | Por quê |
|---|---|---|
| Web pura (React, Angular, HTML) | `data-testid` | o executor web e o Testing Library o conhecem |
| **Híbrido** (Capacitor, Cordova, Ionic — WebView) | `id` (em lista, `[attr.id]`) | o executor lê o `id` **no DOM da WebView, pelo CDP** (`targets.android.locator = "cdp"`, §6). O `uiautomator` não o recebe das WebViews atuais: medido em Android 15 / WebView 124, o `resource-id` sai vazio e o `aria-label` chega como `text` |
| Compose (Android nativo) | `Modifier.testTag(...)` com `testTagsAsResourceId = true` | vira `resource-id` no dump do `uiautomator` (o `locator` padrão) |

O projeto declara o atributo em `guards.json → testIds.attribute` (`"id"` · `"data-testid"` · `"testTag"` · outro). Sem a chave, vale `targets.web.testIdAttribute` (compatibilidade) e, sem ela, o padrão da stack.

**Localizar por `[id="…"]`**, não por `#id`: o ponto do nome quebra o seletor `#`.

## 3. Gramática

- Segmentos em **minúsculas, kebab-case**, separados por `.`.
- O 1º item de uma lista leva o segmento `primeiro`; os demais levam a **chave da entidade**, **nunca o índice**.
- **Nenhum id de linha é prefixo de outro id** (`assert-count` do `accept` conta por prefixo): `pedido.lista.item.4` colide com `pedido.lista.item.42` — por isso a chave vem sempre seguida de `.` ou termina o id, e o prefixo contado inclui o ponto final (`pedido.lista.item.`).

| Elemento | Padrão | Exemplo |
|---|---|---|
| Tela (raiz) | `<tela>` | `pedido.lista` |
| Botão / ação | `<tela>.<ação>` | `pedido.lista.novo` |
| Campo | `<tela>.<campo>` | `pedido.form.nome` |
| Erro do campo | `<tela>.<campo>.erro` | `pedido.form.nome.erro` |
| Valor exibido | `<tela>.<dado>` | `pedido.detalhe.titulo` |
| Item / linha | `<tela>.item.<chave>` | `pedido.lista.item.42` |
| Célula | `<tela>.item.<chave>.<coluna>` | `pedido.lista.item.42.entrega` |
| Estados | `<tela>.vazio` · `.carregando` · `.erro` | `pedido.lista.vazio` |
| Opção de combo (popover) | `<combo>.opcao.<chave>` | `pedido.form.loja.opcao.primeiro` |

Convenção de projeto anterior a este padrão, escrita à mão no formato `<tela>.<elemento>.<s>` (com `primeiro`/id), é **compatível**: não se exige renomear o que já existe e segue a gramática.

## 4. Quem consome

Testes, cenários `.scn` e scripts do alvo selecionam **pelo id** — no app híbrido também, pelo CDP (§6): o id não se copia para o `aria-label` nem para o `content-desc` para o `uiautomator` achá-lo. Texto, `content-desc` ou `aria-label` como seletor só vale em **tela de fora do app** (seletor de arquivos do Android, outro aplicativo), e ali a ordem é `resource-id` do sistema → `text` → `content-desc`, com a **fixture copiada do dump real** (`medido: dump <caminho>` no plano; o ajuste de fixture na margem cita o dump — `working-rules.md`, "Margem do dev"). Com o `locator: "cdp"`, a tela de fora do app não é alcançada pelo cenário: o critério é provado por teste (`scenario-language.md` §3).

Os ids que o plano e o QA citam vêm do **mapa gerado do código** (`.team-project/architect/ids-map.md`, produzido por `scripts/checks/ids.ps1 -Map`): nunca de um documento escrito à mão, que desatualiza.

## 5. Exceção explícita

`sem-testid: <motivo>` (comentário na linha do elemento ou na anterior — `//`, `{/* */}`, `<!-- -->`). Sem motivo, continua reprovando. Uso típico: componente que repassa as props.

## 6. Prova em app híbrido (WebView) no alvo Android

Caminho oficial para provar critério de aceite de aplicação híbrida, em aparelho, emulador local ou emulador em container (acesso por noVNC). A semântica de cada verbo é a de [`scenario-language.md`](scenario-language.md), igual à do alvo `web`.

1. `testIds.attribute = "id"` (§2);
2. `targets.android.locator = "cdp"`: os verbos de tela (`tap`, `type`, `select`, `slider`, `assert-*`) leem e tocam o DOM da WebView pelo DevTools Protocol; o ciclo de vida (instalar, `reset`, `seed`, `launch`, `back`, `clock`, `font-scale`, captura) continua pelo `adb`. Pede o **APK de debug com a depuração da WebView ligada** (`WebView.setWebContentsDebuggingEnabled(true)`; a chave de cada framework está no guia da stack) e Node 22+. O que é do projeto vai em `targets.android.cdp` (`pageUrl`, `readyExpr`, `failExpr`, `hiddenScopes`, prazos), descrito no `guards.json` modelo;
   - **a página se identifica pela origem; a tela, pelo id da raiz** (v3.64.5). O `pageUrl` diz **qual é o app** na WebView (ex.: `^https://localhost(/|$)`; no Cordova, `index\.html`) e nunca em que tela ele está: o app de página única muda a URL a cada navegação (`/tabs/geral`, `#/pedido/42`). O executor casa o `pageUrl` com a URL inteira e, sem nenhuma assim, com a URL sem a rota (origem + `/` em `http(s)`; sem `?` e `#` em `file://`), então um `pageUrl` escrito na tela inicial continua achando o app em outra tela. Que o app chegou à tela certa se prova com `assert-exists <tela>` (§3), o mesmo id que a arquitetura, o plano, o código e o QA citam pelo `ids-map.md`;
3. no emulador em container, **serial de rede** (`host:porta`) — o pré-voo reconecta e separa porta recusada, aparelho offline e religado (v3.54.1);
4. `targets.android.baseline` = massa de seeds aplicada depois de instalar e de cada reset (v3.54.2).

**Prova:** o `result.json` do `accept` com `locator: "cdp"` e os cenários PASSOU é prova de **primeira classe** no portão — a Task fecha por ele, sem decisão do Arquiteto e sem prova por outro meio.

**CONFIGURAÇÃO DO ALVO** (`accept` exit 4, campo `configuration` no `result.json`): o alvo, como está declarado, não prova nada — app híbrido com o `uiautomator` (a tela é uma WebView sem nenhum id do app: todo passo daria "tag não encontrada"), APK sem a depuração da WebView, Node < 22, mais de uma página sem `cdp.pageUrl`, `cdp.pageUrl` que não casa nenhuma página carregada (a mensagem lista as URLs vistas no `/json`, v3.64.5). O `run.ps1 done` leva ao **stakeholder**, dono do `guards.json` e do build. Não é 🔺 GAP, não é ambiente da Task, não é decisão do Arquiteto nem defeito do app, e não se contorna com `adb input` livre, coordenada ou seletor por texto.
