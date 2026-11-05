# Padrão de ids de teste (nível 1, agnóstico de stack)

> **v3.55.0.** Um nome para cada elemento que um teste ou um cenário lê ou toca — o mesmo em todo o sistema, em qualquer alvo. O **nome** é único; o **atributo** que o carrega muda por alvo (§2). Dono editorial: o Arquiteto (R16). Dev e QA leem a seção citada; defeito aqui vai por GAP ou achado de processo ao `/review`.

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
| **Híbrido** (Capacitor, Cordova, Ionic — WebView) | `id` (em lista, `[attr.id]`) | o `uiautomator` lê o atributo HTML `id` como `resource-id`; o `data-testid` **não chega** ao dump |
| Compose (Android nativo) | `Modifier.testTag(...)` com `testTagsAsResourceId = true` | vira `resource-id` no dump |

**Evidência do híbrido:** o dump `C:\app-personal\garden-management\.team-project\operator\5\T-071-apk\dump2.xml` do projeto garden (Ionic + Angular + Capacitor) traz `cabecalho.administracao` e `tab-button-estufa` como `resource-id`; nenhum `data-testid` aparece.

O projeto declara o atributo em `guards.json → testIds.attribute` (`"id"` · `"data-testid"` · `"testTag"` · outro). Sem a chave, vale `targets.web.testIdAttribute` (compatibilidade) e, sem ela, o padrão da stack.

**Localizar por `[id="…"]`**, não por `#id`: o ponto do nome quebra o seletor `#`.

## 3. Gramática

- Segmentos em **minúsculas, kebab-case**, separados por `.`.
- O 1º item de uma lista leva o segmento `primeiro`; os demais levam a **chave da entidade**, **nunca o índice**.
- **Nenhum id de linha é prefixo de outro id** (`assert-count` do `accept` conta por prefixo): `horta.lista.item.4` colide com `horta.lista.item.42` — por isso a chave vem sempre seguida de `.` ou termina o id, e o prefixo contado inclui o ponto final (`horta.lista.item.`).

| Elemento | Padrão | Exemplo |
|---|---|---|
| Tela (raiz) | `<tela>` | `horta.lista` |
| Botão / ação | `<tela>.<ação>` | `horta.lista.novo` |
| Campo | `<tela>.<campo>` | `horta.form.nome` |
| Erro do campo | `<tela>.<campo>.erro` | `horta.form.nome.erro` |
| Valor exibido | `<tela>.<dado>` | `horta.detalhe.titulo` |
| Item / linha | `<tela>.item.<chave>` | `horta.lista.item.42` |
| Célula | `<tela>.item.<chave>.<coluna>` | `horta.lista.item.42.plantio` |
| Estados | `<tela>.vazio` · `.carregando` · `.erro` | `horta.lista.vazio` |
| Opção de combo (popover) | `<combo>.opcao.<chave>` | `manejo.canteiros.opcao.primeiro` |

A convenção que o garden criou à mão (`<tela>.<elemento>.<s>`, `primeiro`/id) é **compatível**: não se exige renomear o que já existe e segue a gramática.

## 4. Quem consome

Testes, cenários `.scn` e scripts do alvo selecionam **pelo id**. Texto, `content-desc` ou `aria-label` como seletor só vale em **tela de fora do app** (seletor de arquivos do Android, outro aplicativo), e ali a ordem é `resource-id` do sistema → `text` → `content-desc`, com a **fixture copiada do dump real** (`medido: dump <caminho>` no plano; o ajuste de fixture na margem cita o dump — `working-rules.md`, "Margem do dev").

Os ids que o plano e o QA citam vêm do **mapa gerado do código** (`.team-project/architect/ids-map.md`, produzido por `scripts/checks/ids.ps1 -Map`): nunca de um documento escrito à mão, que desatualiza.

## 5. Exceção explícita

`sem-testid: <motivo>` (comentário na linha do elemento ou na anterior — `//`, `{/* */}`, `<!-- -->`). Sem motivo, continua reprovando. Uso típico: componente que repassa as props.

## 6. Prova em app híbrido num emulador de container

Caminho oficial para provar critério de aceite de aplicação híbrida (WebView) em emulador Android em container (acesso por noVNC):

1. alvo `android` com **serial de rede** (`host:porta`) — o pré-voo reconecta e separa porta recusada, aparelho offline e religado (v3.54.1);
2. `testIds.attribute = "id"` — o `uiautomator` vê o `id` como `resource-id`;
3. `targets.android.baseline` = massa de seeds aplicada depois de instalar e de cada reset (v3.54.2).

**Limite conhecido:** conteúdo que só existe dentro do WebView, sem `id` correspondente no dump, fica `[PARCIAL]` e vai ao stakeholder — não se contorna com `adb input` livre. Não há driver por CDP (decisão de 05/11: espera-se o segundo caso).
