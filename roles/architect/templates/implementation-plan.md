# Template — Plano de Implementação

Salvo em `.team-project/sprints/<n>/plan/<T-ID>-<slug>.md` (sem sprint corrente, plano de calibração: `.team-project/architect/calibration/`), na subpasta do Arquiteto ([`artifact-ownership.md` §1e](../../scrum-master/process/artifact-ownership.md)). **É o conteúdo técnico da Task** e o contrato entre o Arquiteto e o dev: **o que não estiver aqui vira 🔺 GAP, nunca improviso.** O sprint corrente está em `.team-project/README.md` §2; a coluna Plano do `sprint-backlog.md` aponta para o plano.

> **Enxuto (regra 22): até ~12 KB**, escrito para quem constrói. SDD e `standards/` são **citados** (seção e linha), nunca copiados. **O dev lê o cabeçalho, a §6 e o seu bloco.** A fronteira funcional × técnica passa aqui (R20): o "o quê" foi decidido na História e aprovado no ③; este plano é o primeiro e único lugar de decisão técnica.

```markdown
# Plano de Implementação — <T-ID> <título da Task>

**História:** H-<nnn> <título> · **Dono:** dev · **Origem:** GAP <ID> / critério de aceite <n> da História
**Estimativa:** <n> unidade(s) · **Trilha:** plena | leve *(a do Sprint Backlog; leve → "Variante leve")*
**Planejado durante:** <T-ID> em 🟨 *(só quando outra Task estava em construção — regra 20)*
**Li além da ficha:** nenhum | `<arquivo>` — <porquê> · `<arquivo>` — <porquê> *(só Task com ficha — regra 28)*
**Cenários:** SC-<nnn>, SC-<nnn> *(regra 23)* | nenhum — <motivo>
**Risco:** regra de negócio | integração | interface simples | infraestrutura *(regra 24)*
**Layout novo:** sim | não *(só Task com interface — regras 21, 26 e 27)*
**Documentos vivos:** `<documento de desenho>` §<seção> — <o que muda> *(só com **Layout novo:** sim — regra 27)*
**Retomada de:** `sprints/<n-1>/plan/<T-ID>-<slug>.md` — parou no passo <n> de <m>, repositório <estado> *(só Task de sprint anterior — regra 12)*
**Arquivos tocados:** `<caminho relativo à raiz do repositório>`
`<um por linha, entre crases — produção e teste>`

**Arquivos protegidos:** nenhum | ver §12

## 1. Objetivo e fora de escopo
<Um parágrafo: o que passa a funcionar depois desta Task, e a que critério de aceite da História ela serve.>

**Fora do escopo:** <o que explicitamente NÃO se faz aqui — R4>

## 2. Contexto de código a ler antes de escrever
| Arquivo | Por que |
|---|---|
| <caminho:linha> | <o que observar — assinatura, padrão a espelhar, invariante> |

## 3. Ambiente medido e comandos validados (antes dos passos — R26)
**Medição do `operator` (quando foi ela):** `.team-project/operator/<sprint|pre-sprint>/<job>/report.md` — trabalho `<nome>`, código de saída `<n>`, veredito `<ok | falhou>` *(`inconclusivo` não preenche; medição feita antes de mudar o arquivo da toolchain, ou sem o `report`, caduca — R28)*

| Pré-requisito | Comando de medição | Saída real (recortada) | Log bruto | Atende ao plano? |
|---|---|---|---|---|
| <o que o passo exige> | `<comando que imprime a versão>` | `<o que o comando devolveu, literal>` | `<caminho>.log` — <n> linhas | sim / **não — <o que falta>** |
| *(Task com interface)* navegador headless do teste de render | `<comando de versão>` | `<literal>` | `<caminho>.log` — <n> linhas | sim / **não — 🔺 GAP (§9)** |

| Comando citado | Onde aparece | Como confirmei que existe nesta versão | Saída |
|---|---|---|---|
| `<comando literal>` | Passo <n> / seção 7 | `<--version, --help ou equivalente>` | `<literal>` |

**Parada incondicional.** Pré-requisito da primeira tabela **ausente** (não instalado, fora do caminho, medição falhando) ou fora da faixa ao iniciar o passo 1: o dev **para e abre 🔺 GAP** — não instala, não troca por equivalente, não segue.

## 4. Passos, em ordem de execução
*(Mais de 8 arquivos: passos dentro de `### Bloco <k> — <título>`, cada um aberto por `**Arquivos do bloco:**`, `**Depende de:**` e `**Pronto do bloco:**` — regra 2.)*

### Passo 1 — <título>
- **Arquivo:** <caminho completo>
- **Anel:** domínio | aplicação | adaptador/infraestrutura | borda
- **Ação:** CRIAR | ALTERAR | REMOVER
- **Assinatura exata:**
  ```
  <classe / método / propriedade / rota / DTO — literal>
  ```
- **Modelo a espelhar:** <arquivo concreto do projeto>
- **Standard aplicável:** `${CLAUDE_PLUGIN_ROOT}/standards/<arquivo>.md` §<n> — <a obrigação em uma linha> *(ou "n/a" — regra 10)*
- **NÃO fazer:** <o desvio previsível que este passo tende a provocar>
- **Conferência:** <o que o QA observa para marcar "conforme" sem julgar desenho — regra 13>

### Passo 2 — …

## 5. Registros de infraestrutura (explícito — nunca "se necessário")
- **Injeção de dependência / registro de componente:** <o registro literal e onde>
- **Migration de banco:** <nome exato> — <tabelas/colunas>
- **Configuração:** <chave, onde declarar, se é obrigatória no start>
- **Mapeamento de erro:** <exceção nova → status HTTP>

## 6. Testes obrigatórios
| Arquivo | Nome do teste | Caso coberto | Deve falhar se… |
|---|---|---|---|

**Mutações:**
- M1 · teste `<arquivo de teste>` · `<arquivo de produção>` · `<trecho exato>` → `<trecho mutante>`
*(regra 18; teste sem regra a remover: `sem prova: <arquivo> — <motivo>`)*

**Render real** *(só com **Layout novo: sim** — regra 21)*:
| Teste de render | Tela (largura × altura) | Fontes | Caixas medidas | Deve falhar se… |
|---|---|---|---|---|
| `<arquivo de teste>` | `<cada tamanho relevante da spec de tela>` | `<padrão · menor · maior>` | `<elementos: posição, tamanho, sobreposição, transbordamento>` | `<a geometria que quebra>` |

**Cobertura:** 80 % mínimo por módulo na unidade implantável tocada (back-end, worker ou front-end); o dev leva ao relatório o código de saída, o pior módulo × limiar e o `report` do job (R28 · `${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §5.4 e §5.5).

### Premissas
*(regra 26 — uma linha por afirmação sobre código ou ambiente que algum passo assume; substitui prosa, não soma)*
- Contagem: `<regex>` em `<glob>` → <n>
- P1 · <afirmação> · medido: `<comando ou job do operator>` → <resultado literal>
- P2 · <afirmação> · não exercitada: <motivo> · verifica: <papel> em <passo>

## 7. Comandos de verificação
<Com `verify` no `.team-project/guards.json`: os testes do Pronto de cada bloco e "`verify.ps1 -Mode full` no fim" — os comandos vivem no `guards.json`. Sem `verify`: os do `.team-project/developer/context.md`, validados na §3. **Sempre** o gate de cobertura da unidade tocada; sem comando de cobertura, é gap de configuração na §9.>

## 8. Critérios de aceite técnicos
- [ ] <checklist binário, verificável>

## 9. Onde parar e perguntar 🔺
- <ponto em que o dev deve levantar GAP em vez de decidir>
- *(fixo)* Seção de standard citada que **se contradiz, tem lacuna ou não diz como se verifica**: 🔺 GAP ao Arquiteto (R16)
- *(fixo)* **Pré-requisito ausente** — item da §3 que não existe no ambiente, além de versão incompatível: 🔺 GAP, sem instalar nem substituir (R26)
- *(fixo)* **Gate de qualidade que não roda, não resolve ou reprova**: 🔺 GAP — desligar, afrouxar limiar, tirar do build ou contornar **nunca** é decisão do dev (R4 · R7)
- *(fixo em Task com interface)* **Navegador headless ausente, ou teste de render que não abre a tela ou não mede**: 🔺 GAP (regra 21 · R23 · R26)

## 10. Segurança (obrigatório se a Task toca autenticação, autorização, escopo, dado pessoal ou conteúdo de terceiro)
- [ ] Identidade/escopo do contexto autenticado, nunca do request
- [ ] Autorização declarada com permissão <nome> (existe no catálogo? senão, cadastro nesta migration)
- [ ] Teste de isolamento entre escopos
- [ ] Auditoria, se a ação é sensível
- [ ] Segredo validado no start, sem default vazio
- [ ] Recurso de outro escopo → 404, não 403
- **Regra aplicável:** `${CLAUDE_PLUGIN_ROOT}/standards/implementation-security-lgpd-copyright.md` §<n>

## 11. Execução delegada (registro do Arquiteto — não é passo)
*(uma linha por chamada minha ao `operator` para este plano — regra 14; sem chamada: "nenhuma")*

| Operator job | Task/História |
|---|---|
| `.team-project/operator/<sprint\|pre-sprint>/<T-ID>[-<slug>]/` *(+ ` — <log>` se mais de uma chamada na pasta)* | <T-ID / H-ID> |

## 12. Arquivos protegidos — a sessão aplica antes do dev *(só quando o cabeçalho diz "ver §12")*
| Arquivo | Por que a Task precisa mudá-lo |
|---|---|
| `<caminho>` | <motivo, ligado ao passo que depende dele> |

**Diff exato de `<caminho>`:**
~~~diff
<trecho antes/depois, literal — sem "algo como">
~~~
```

## Regras do formato

> **Só o operativo** (v3.53). O porquê, a medição que motivou cada regra e a versão em que nasceu: [`../plan-rules-why.md`](../plan-rules-why.md) — não é leitura do plano. **✓ = o `plan.ps1` confere**; as mensagens dele dizem o que corrigir — **não abra o script**.

1. **Sequência linear** com um único dev; sem faixas paralelas.
2. ✓ **Cabe numa unidade de trabalho.** Acima de ~10 passos ou duas áreas do sistema, quebre em `<T-ID>a`/`<T-ID>b`, na mesma História (R2 · R20). **Acima de 8 arquivos** em `**Arquivos tocados:**` (produção + teste), os passos vão em `### Bloco <k> — <título>`, até 8 arquivos cada, abertos por `**Arquivos do bloco:**` (subconjunto do cabeçalho, entre crases), `**Depende de:** bloco <j> | nenhum` e `**Pronto do bloco:** <comando focado — com `verify`, "`verify.ps1 -Mode focused -Tests <testes do bloco>`"> → exit 0 · <n> teste(s) passando`. Cada bloco deixa o repositório compilando; o dev recebe um bloco por instância.
3. **Ordem preserva o repositório íntegro** no maior número de pontos intermediários.
4. **Uma migration de banco por Task** — Tasks da mesma migration viram uma só.
5. **Nomes exatamente como na especificação** — grafia é contrato.
6. **Nada de "siga o padrão"** — aponte o arquivo concreto a espelhar.
7. **Contrato, não código.** Se o dev puder escolher entre duas formas que **mudam comportamento, contrato, camada ou o que um standard exige**, o plano está incompleto. O corpo é do dev: assinatura, Conferência, teste com "Deve falhar se…" e mutação fecham o resultado.
8. **Todo passo declara o anel.** Domínio dependendo de fora, ou regra de negócio na borda, é erro de plano (`${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §2).
9. **Sem refatoração "de passagem".** Melhoria fora do objetivo vira Task própria; sem História que a cubra, o PO a escreve (§4.5 do mesmo normativo · R20).
10. **Passo com regra de engenharia cita a seção de `${CLAUDE_PLUGIN_ROOT}/standards/`, com número** (R16) — o dev lê só o citado; "seguir os standards" não é citação. Regra ausente ou contraditória no normativo: resolver por `/review` antes de liberar o plano.
11. ✓ **Ambiente medido antes dos passos** (R26 · R28). A §3 traz comando, saída real, código de saída e o `report` do job (meu ou do `operator`; nunca `inconclusivo`); nenhum passo cita comando que eu não vi existir na versão medida; a parada cobre **ausência**, não só versão fora da faixa. Plano sem a §3 não entra em construção.
12. **Task retomada de outro sprint ganha plano novo**, com `Retomada de:`. O antigo é registro fechado: não se edita, não se copia, não se referencia. O novo declara o feito (pelo "Parei no passo" do relatório) e **reconfere no código** as assinaturas dos passos restantes.
13. **Todo passo é conferível pelo QA sem julgar desenho** (frente 2, [`workflow.md` §4a](../../scrum-master/process/workflow.md)): a **Conferência** diz o que se observa no código; o standard citado, contra o quê. Passo que o QA não marca sem decidir volta a mim (🔺 GAP → `/arc question`); divergência de execução volta ao dev.
14. **§11 sempre presente** (R28): uma linha por chamada minha ao `operator` para este plano, inclusive remedição; "nenhuma" quando zero; plano retomado lista só as do plano novo. Os números vêm do G16, não daqui.
15. ✓ **`**Arquivos tocados:**` é lido pela G9** (R4 · R8): lista **fechada e completa** — produção e teste, inclusive arquivo novo —, um caminho por linha, entre crases, relativo à raiz, com `/`, sem linha em branco no meio, sem diretório, curinga nem "e afins"; rótulo com outra grafia não é lido. Arquivo que um 🔺 GAP acrescentar entra aqui. **Todo arquivo de produção leva o seu teste na lista**, ou a linha `sem teste: <arquivo> — <motivo>` na §6.
16. ✓ **Só arquivo do executor na lista.** Documento de `.team-project/` de outro papel (G8) sai — vai como pedido ao dono. Arquivo de gate (`guards.json` → `protectedPaths`; a G5 o nega a todo subagente) vai em `**Arquivos protegidos:** ver §12`, com o diff exato, **separado por linha em branco** de `**Arquivos tocados:**`; a sessão aplica antes do dev ([`sprint-run.md`](../../scrum-master/process/sprint-run.md) passo 3). Sem protegido: `**Arquivos protegidos:** nenhum`. Descoberto no meio da Task: 🔺 GAP e §12 nova.
17. ✓ **Trecho literal até 15 linhas por bloco de código**, só onde a forma é a decisão (expressão regular, consulta, configuração, mensagem de erro). Acima disso, `**Validado em:** <scratchpad: caminho> | <job do operator>` no passo, ou encurte para contrato. Teste não vai escrito: vai a linha da §6.
18. ✓ **Prova de falha** (pelo risco, regra 24). Cada teste com "Deve falhar se…" ganha `- M<k> · teste `<arquivo de teste>` · `<arquivo de produção>` · `<trecho exato>` → `<trecho mutante>`` em `**Mutações:**`. O trecho aparece **uma vez** no arquivo depois da implementação, não é vazio e não tem crase; o mutante **compila** — confiro antes de entregar, pelo `operator` ou, com `verify.compile`, por `verify.ps1 -Mode mutation -Plan <plano> -Precheck`; trecho que só nasce na Task sai premissa `não exercitada … · verifica: dev em verify -Precheck`. Os dois arquivos estão em `**Arquivos tocados:**`. Teste sem regra a remover: `sem prova: <arquivo de teste> — <motivo>`.
19. **Conferência antes do dev:** `scripts/checks/plan.ps1 -Plan <caminho>`; reprovado, corrijo na mesma instância.
20. **Plano escrito com outra Task em construção** (R1): `**Planejado durante:** <T-ID> em 🟨`, só para Task que não depende dela.
21. ✓ **Layout novo se prova em render real.** Task com interface declara `**Layout novo:** sim | não`. Com **sim** (muda posição, tamanho ou fluxo visível), a §6 tem ao menos um **teste de render**: navegador headless, caixas dos elementos afetados medidas (posição, tamanho, sobreposição, transbordamento) em **3 tamanhos de fonte** (padrão, menor, maior suportados) × **cada tela relevante** da spec (sem lista: a menor e a maior); a tabela **Render real** declara a matriz e o "Deve falhar se…" descreve a geometria. Prova só por estrutura (CSSOM, seletor, snapshot) não basta (`implementation-principles.md` §5.1). Ao menos uma `M<k>` tem o teste de render e reverte a declaração de estilo ou marcação da Task — **tem de quebrar a medição**. Navegador headless é pré-requisito da §3: ausente, a linha sai "não", a §9 leva o GAP e a Task não entra em construção até a decisão do stakeholder. A Conferência do passo de teste diz que o render existe e mede a matriz.
22. ✓ **Enxuto: ~12 KB** (aviso acima de 12, reprova acima de 20). Sai: trecho do SDD e do `standards/` copiado (cite), por que o padrão existe, contexto que o dev não usa. Fica: cada arquivo, cada passo com a Conferência, cada teste com o que afirma, os comandos e o "pronto" de cada bloco.
23. ✓ **Cenários ao lado do plano.** O QA escreve os `.scn` (`.team-project/quality-assurance/scenarios/`, linguagem do `accept.ps1`) antes do dev; `**Cenários:**` cita os da Task, que têm de existir nos `.scn`, ou `nenhum — <motivo>`. O dev os roda no alvo (`accept.ps1 -Task <ID> -Only <cenários>`).
24. ✓ **Teste pelo risco** — `**Risco:**` escolhe o nível:

| Risco | Testes da §6 | Mutação (regra 18) | Render real (regra 21) |
|---|---|---|---|
| **regra de negócio** (domínio, cálculo, regra do SDD) | completos, com borda | obrigatória | se layout novo |
| **integração** (banco, API externa, arquivo, relógio) | contrato + falha da dependência | obrigatória | — |
| **interface simples** (tela que só mostra e navega) | teste de UI do contrato (identificadores e estados) + os cenários da Task | `sem prova:` | só com **Layout novo: sim** |
| **infraestrutura** (scaffold, configuração, build) | o que prova que sobe e compila | `sem prova:` | — |

  O freio é o portão do QA: cobertura medida com limiar de 80 % por unidade implantável (`implementation-principles.md` §5).
25. **Quem planeja (v3.51 · v3.53).** Task com **ficha** no `.team-project/architect/breakdown/S<n>.md` é planejada por um Arquiteto só dela (regra 28). Task sem ficha é planejada junto das outras da História, numa instância que lê o SDD, os standards e o código uma vez. Cada plano num arquivo próprio, com a sua lista fechada.
26. ✓ **O plano prova o que afirma**, na `### Premissas` da §6:
    - **Contagem:** toda contagem ou inventário é `- Contagem: `<regex>` em `<glob>` → <n>` (glob relativo à raiz, `;` separa vários, regex sensível a maiúsculas; o script reconta nos arquivos versionados). Número de ocorrências fora dessa forma não se escreve.
    - **Premissa:** `- P<k> · <afirmação> · medido: <comando ou job> → <resultado>` ou `- P<k> · <afirmação> · não exercitada: <motivo> · verifica: <papel> em <passo>`; "não validado" solto reprova.
    - **Quem mede:** leitura (contagem, busca, seletor contra o lint), eu, com comando curto e a saída colada; o que depende de executar (app, teste, build, contraste, compilar o mutante), o `operator`, job `operator/<n>/<T-ID>-plano/`, linha na §11.
    - Número de aceite da spec do UX entra como premissa **medida**. Com `**Layout novo:** sim`, ao menos uma `medido:`. A premissa substitui a prosa que afirmava o mesmo.
27. ✓ **Mudança visível aponta o documento de desenho.** Com `**Layout novo:** sim`, a linha `**Documentos vivos:**` traz o documento (`docs/sdd/…`) e a seção que muda; ele **não** entra em `**Arquivos tocados:**` — o dev anota no relatório e eu consolido uma vez no sprint (A5, `docs-consolidation.md`).
28. ✓ **Plano pela ficha (v3.53).** Task com ficha: abro só a ficha (o recorte em `sprints/<n>/handoff/<T-ID>-ficha.md`), este template, o plano da Task de que ela depende e o `architect/context.md`; do código, leio o que a ficha aponta. Ler além dela vale — cada arquivo vai em `**Li além da ficha:**`, numa linha (`nenhum` quando não li): é a medida da qualidade da ficha. Os **nomes comuns** da ficha aparecem literalmente no plano. Não abro o `plan.ps1` nem plano de outro sprint. Formato da ficha: [`breakdown.md`](breakdown.md).

## Variante leve (R23)

Para Task com **`Trilha: leve`** no Sprint Backlog — decidida na Planning, só se tudo for verdade: estimativa ≤ 0,5; até 4 arquivos; sem migration; sem item da §10; sem interface (mudança visível de layout **nunca é leve**); sem arquivo protegido. Documentação pura entra sempre como leve. O `plan.ps1` confere o mecânico; o resto é da Planning. Disparado com `model: "sonnet"`.

```markdown
# Plano de Implementação — <T-ID> <título> · leve
**História:** H-<nnn> · **Trilha:** leve · **Estimativa:** <≤ 0,5>
**Arquivos tocados:** `<até 4>`

**Arquivos protegidos:** nenhum

## 1. Objetivo e fora de escopo
## 6. Testes obrigatórios (+ **Mutações:** ou `sem prova:` + `### Premissas`, regra 26)
## 7. Comandos de verificação — "verify.ps1 -Mode full no fim" (R26 por citação do `developer/context.md`; sem `operator`)
## 9. Onde parar e perguntar 🔺 (as três linhas fixas)
```

A leve reduz **escopo**, nunca evidência (R23): o `verify full`, a mutação e o veredito continuam. Critério que cai no meio da Task (arquivo a mais, migration, mudança visível) devolve a Task à trilha plena.

## Exemplo abreviado

```markdown
# Plano de Implementação — T-042 Chave de assinatura obrigatória

**História:** H-014 Exportar o resultado da análise
**Li além da ficha:** nenhum
**Cenários:** nenhum — configuração validada no start, coberta por teste unitário
**Risco:** regra de negócio
**Arquivos tocados:** `Infrastructure/Storage/StorageOptions.cs`
`Infrastructure/Storage/UrlSigner.cs`
`Api/appsettings.json`
`Tests/Unit/UrlSignerTests.cs`
`Tests/Unit/StorageOptionsTests.cs`

**Arquivos protegidos:** nenhum

## 4. Passo 1 — tornar a chave obrigatória
- **Arquivo:** `Infrastructure/Storage/StorageOptions.cs` · **Anel:** adaptador/infraestrutura · **Ação:** ALTERAR
- **Assinatura exata:** `[Required, MinLength(32)] public string SigningKey { get; set; } = string.Empty;`
- **Modelo a espelhar:** as opções de autenticação, que já validam no start
- **Standard aplicável:** `${CLAUDE_PLUGIN_ROOT}/standards/implementation-security-lgpd-copyright.md` §<n> — segredo validado no start, sem default vazio
- **NÃO fazer:** gerar chave automática em runtime — falhar no start é o comportamento desejado
- **Conferência:** `StorageOptions.cs` contém a assinatura literal; nenhuma atribuição a `SigningKey` fora da configuração

## 6. Testes
| Arquivo | Teste | Deve falhar se… |
|---|---|---|
| `UrlSignerTests.cs` | `Assinatura_ComCaminhoAlterado_DeveSerInvalida` | a mensagem assinada deixar de cobrir o caminho |
| `StorageOptionsTests.cs` | `Start_SemChaveDeAssinatura_DeveFalhar` | a chave voltar a aceitar valor vazio |

sem teste: `Api/appsettings.json` — configuração; o comportamento é o de `StorageOptionsTests.cs`

**Mutações:**
- M1 · teste `Tests/Unit/UrlSignerTests.cs` · `Infrastructure/Storage/UrlSigner.cs` · `$"{path}|{expires}"` → `$"{expires}"`
- M2 · teste `Tests/Unit/StorageOptionsTests.cs` · `Infrastructure/Storage/StorageOptions.cs` · `[Required, MinLength(32)]` → `[MinLength(0)]`

### Premissas
- Contagem: `SigningKey` em `Infrastructure/Storage/*.cs;Api/*.cs` → 4
- P1 · `UrlSigner` é o único leitor de `SigningKey` · medido: `Grep SigningKey Infrastructure/` → 1 arquivo (`UrlSigner.cs:18`)
- P2 · os dois mutantes compilam · não exercitada: o trecho novo nasce no passo 1 · verifica: dev em `verify.ps1 -Mode mutation -Precheck`

## 11. Execução delegada
| Operator job | Task/História |
|---|---|
| `.team-project/operator/<sprint>/T-042-plano/` | T-042 |
```
