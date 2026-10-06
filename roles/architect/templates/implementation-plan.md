# Template — Plano de Implementação

Salvo em `.team-project/sprints/<n>/plan/<T-ID>-<slug>.md` (plano de calibração, sem sprint corrente: `.team-project/architect/calibration/`) — dentro da pasta do sprint a que a Task pertence, na subpasta do Arquiteto ([`../../scrum-master/process/artifact-ownership.md` §1e](../../scrum-master/process/artifact-ownership.md)). **É o conteúdo técnico da Task**, não um artefato irmão dela: a Task é a unidade de trabalho no Sprint Backlog, e o plano é o que diz como ela se faz. É o contrato entre o Arquiteto e o dev: **o que não estiver aqui vira 🔺 GAP, nunca improviso.**

> **O caminho não é fixo:** `.team-project/README.md` §2 declara **qual é o sprint corrente**, e é por lá que o dev e o QA acham este plano. A coluna Plano do `sprint-backlog.md` aponta para ele; ponteiro que não resolve é achado de processo.

> **A fronteira funcional × técnica passa aqui** (R20). O "o quê" e o "para quê" já foram decididos na História, pelo PO, e aprovados pelo stakeholder no portão ③. Este plano é o primeiro lugar onde aparece decisão técnica — e o único.

```markdown
# Plano de Implementação — <T-ID> <título da Task>

**História:** H-<nnn> <título> · **Dono:** dev · **Origem:** GAP <ID> / critério de aceite <n> da História
**Estimativa:** <n> unidade(s) — a que o time deu na Planning
**Retomada de:** `sprints/<n-1>/plan/<T-ID>-<slug>.md` — parou no passo <n> de <m>, repositório <estado>
*(linha obrigatória só quando a Task volta de um sprint anterior; omitir quando a Task é nova)*
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

## 3. Ambiente medido e comandos validados (antes da lista de passos — R26)
> Medido com comando e **saída real** — por mim ou pelo agente `operator` —, nunca presumido nem
> lembrado de outro projeto. O que **o plano inteiro** exige, do primeiro ao último passo.
> Plano sem esta seção **não entra em construção** (mesma régua de R8).

**Medição do `operator` (quando foi ela):** `.team-project/operator/<sprint|pre-sprint>/<job>/report.md` (ou `report-<log>.md`) — trabalho
`<nome>`, código de saída `<n>`, veredito `<ok | falhou>`. Veredito `inconclusivo` **não** preenche
esta seção; medição citada depois de o arquivo que declara a toolchain mudar, ou cujo `report` sumiu do
caminho, caduca e é refeita (R26 · R28 · [`../skills.md`](../skills.md) §14).

**Pré-requisitos que o plano assume** — runtime, SDK, ferramenta de build, gerenciador de pacotes,
serviço local que algum passo exige:

| Pré-requisito | Comando de medição | Saída real (recortada) | Log bruto | Atende ao plano? |
|---|---|---|---|---|
| <o que o passo exige> | `<comando que imprime a versão>` | `<o que o comando devolveu, literal>` | `<caminho>.log` — <n> linhas | sim / **não — <o que falta>** |

**Comandos citados nos passos e na seção 7, validados na versão medida** — um por comando; memória de
outro projeto ou de outra stack não é validação:

| Comando citado | Onde aparece | Como confirmei que existe nesta versão | Saída |
|---|---|---|---|
| `<comando literal>` | Passo <n> / seção 7 | `<--version, --help ou equivalente>` | `<literal>` |

**Parada incondicional.** Se, ao iniciar o passo 1, **qualquer pré-requisito da primeira tabela estiver
ausente** — não instalado, não encontrado no caminho de execução, ou o comando de medição falhando —
o dev **para e abre 🔺 GAP**: não instala por conta própria, não troca por ferramenta equivalente e não
segue para o passo seguinte. Vale igualmente para versão fora da faixa aceita. **Faixa de versão não é
regra de parada:** ela diz o que aceitar, não o que fazer quando a ferramenta não existe.

## 4. Passos, em ordem de execução
*(Plano com mais de 8 arquivos: os passos ficam dentro de `### Bloco <k> — <título>`, cada um aberto por
`**Arquivos do bloco:**`, `**Depende de:**` e `**Pronto do bloco:**` — regra 2. Até 8 arquivos: passos direto.)*

### Passo 1 — <título>
- **Arquivo:** <caminho completo>
- **Anel:** domínio | aplicação | adaptador/infraestrutura | borda
- **Ação:** CRIAR | ALTERAR | REMOVER
- **Assinatura exata:**
  ```
  <classe / método / propriedade / rota / DTO — literal>
  ```
- **Modelo a espelhar:** <arquivo concreto do projeto>
- **Standard aplicável:** `${CLAUDE_PLUGIN_ROOT}/standards/<arquivo>.md` §<n> — <a obrigação em uma linha> *(obrigatório quando o passo tem regra de engenharia: camada, contrato, nomenclatura, teste, log, configuração, segredo; "n/a" quando não tem)*
- **NÃO fazer:** <o desvio previsível que este passo tende a provocar>
- **Conferência:** <o que o QA observa para marcar "conforme" sem julgar desenho — `arquivo` contém a assinatura literal acima; registro de §5 presente onde declarado; teste de §6 que cobre o passo existe; o desvio de "NÃO fazer" ausente>

### Passo 2 — …

## 5. Registros de infraestrutura (explícito — nunca "se necessário")
- **Injeção de dependência / registro de componente:** <o registro literal e onde>
- **Migration de banco:** <nome exato> — <tabelas/colunas>
- **Configuração:** <chave, onde declarar, se é obrigatória no start>
- **Mapeamento de erro:** <exceção nova → status HTTP>

## 6. Testes obrigatórios
| Arquivo | Nome do teste | Caso coberto | Deve falhar se… |
|---|---|---|---|

**Cobertura:** a Task mantém o gate de **80% mínimo por módulo** na unidade implantável que ela toca —
back-end, worker **ou front-end**. O dev leva ao relatório o trecho decisivo da saída do comando de
cobertura — código de saída, pior módulo × limiar — **e** o ponteiro do `report` do job (R28)
(`${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §5.4 e §5.5).

## 7. Comandos de verificação
<Os comandos do projeto — ver `.team-project/developer/context.md`. Cada um já validado na seção 3.
Incluir **sempre** o comando do gate de cobertura da unidade tocada; se aquela unidade ainda não tem
comando de cobertura, isso é gap de configuração e entra na seção 9, não vira Task sem verificação.>

## 8. Critérios de aceite técnicos
- [ ] <checklist binário, verificável>

## 9. Onde parar e perguntar 🔺
- <ponto em que o dev deve levantar GAP em vez de decidir>
- *(fixo)* Se uma seção de standard citada aqui **se contradisser, tiver lacuna ou não disser como se verifica**: 🔺 GAP ao Arquiteto — o standard não se corrige de passagem (R16)
- *(fixo)* **Pré-requisito ausente** — qualquer item da seção 3 que não exista no ambiente, além do caso "versão incompatível": 🔺 GAP, sem instalar por conta própria e sem substituir por ferramenta equivalente (R26)
- *(fixo)* **Gate de qualidade que não roda, não resolve ou reprova**: 🔺 GAP. Desligar, afrouxar limiar, remover do build, trocar por comando equivalente ou acrescentar configuração que contorne a checagem **nunca** é decisão do dev (R4 · R7)

## 10. Segurança (obrigatório se a Task toca autenticação, autorização, escopo, dado pessoal ou conteúdo de terceiro)
- [ ] Identidade/escopo do contexto autenticado, nunca do request
- [ ] Autorização declarada com permissão <nome> (existe no catálogo? senão, cadastro nesta migration)
- [ ] Teste de isolamento entre escopos
- [ ] Auditoria, se a ação é sensível
- [ ] Segredo validado no start, sem default vazio
- [ ] Recurso de outro escopo → 404, não 403
- **Regra aplicável:** `${CLAUDE_PLUGIN_ROOT}/standards/implementation-security-lgpd-copyright.md` §<n>

## 11. Execução delegada (registro do Arquiteto — não é passo; o dev não executa nada daqui)
*(uma linha por chamada minha ao `operator` para este plano — tipicamente a medição da seção 3. É o
**índice dos jobs** que o C1 confere (R28); tokens e duração o hook G16 mede no transcript do `operator`
e o `consumption.ps1` grava — não copio número. Sem chamada: "nenhuma".)*

| Operator job | Task/História |
|---|---|
| `.team-project/operator/<sprint\|pre-sprint>/<T-ID>[-<slug>]/` *(+ ` — <log>` se houver mais de uma chamada na mesma pasta)* | <T-ID / H-ID> |

## 12. Arquivos protegidos — a sessão aplica antes do dev *(só quando o cabeçalho diz "ver §12")*
*(Arquivo de `guards.json` → `protectedPaths` que a Task precisa mudar. A G5 o nega a todo subagente —
inclusive a mim e ao dev —, então o plano entrega o texto pronto e a sessão do `sprint run` o aplica no
passo 3, com a permissão do stakeholder. Não entra em `**Arquivos tocados:**`.)*

| Arquivo | Por que a Task precisa mudá-lo |
|---|---|
| `<caminho>` | <motivo, ligado ao passo que depende dele> |

**Diff exato de `<caminho>`:**
~~~diff
<trecho antes/depois, literal — sem "algo como">
~~~
```

## Regras do formato

1. **Sequência linear** quando o time tem um único dev; sem faixas paralelas.
2. **Cabe em uma unidade de trabalho** — acima de ~10 passos ou duas áreas do sistema, quebrar em `<T-ID>a`/`<T-ID>b`, **sempre dentro da mesma História** (R2 · R20). **Blocos (v3.45): acima de 8 arquivos em `**Arquivos tocados:**` (produção + teste), os passos se dividem em `### Bloco <k> — <título>`**, cada um com até 8 arquivos e três linhas antes dos passos: `**Arquivos do bloco:**` (subconjunto da lista do cabeçalho, entre crases — a G9 continua lendo só o cabeçalho), `**Depende de:** bloco <j> | nenhum` e `**Pronto do bloco:** <comando focado> → exit 0 · <n> teste(s) passando` (o critério objetivo com que o dev para e a sessão segue). Cada bloco deixa o repositório compilando. O dev recebe **um bloco por instância** ([`sprint-run.md`](../../scrum-master/process/sprint-run.md) passo 3): bloco grande esgota o contexto do dev, que para no meio e relata como pronto (sprint 1 do projeto-piloto: 32 arquivos, quatro instâncias, duas paradas no meio; com blocos de até ~8, nenhuma).
3. **Ordem preserva o repositório íntegro** no maior número de pontos intermediários.
4. **Uma migration de banco por Task** — Tasks que dependem da mesma migration viram uma Task só.
5. **Nomes exatamente como na especificação** — grafia é contrato.
6. **Nada de "siga o padrão"** — aponte o arquivo concreto a espelhar.
7. **Se o dev puder escolher entre duas formas, o plano está incompleto.**
8. **Todo passo declara o anel** do arquivo que toca. Passo que faz o domínio depender de fora, ou que põe regra de negócio na borda, é erro de plano — não de execução (`${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §2).
9. **Nenhum passo de refatoração "de passagem".** Melhoria fora do objetivo da Task vira Task própria — e, se nenhuma História a cobre, o PO escreve a História que declara o valor (§4.5 do mesmo normativo · R20).
10. **Todo passo com regra de engenharia cita a seção de `${CLAUDE_PLUGIN_ROOT}/standards/` aplicável, com número** (R16). O dev lê só o que o plano citou — seção não citada é seção não lida. "Seguir os standards" não é citação. Se a regra de que o passo precisa **não existe** no normativo, ou existe contraditória, isso é defeito do standard e é do Arquiteto: resolver por `/review` antes de liberar o plano.
11. **Ambiente medido antes dos passos** (R26). A seção 3 sai preenchida com comando e saída real — **minha ou do `operator`, com código de saída, versões e o ponteiro do `report` do job (R28)**, nunca veredito `inconclusivo`: nenhum passo cita comando que eu não vi existir na versão medida, e a parada incondicional cobre **ausência** do pré-requisito, não só versão fora da faixa. Faixa de versão sozinha não é regra de parada. Plano sem a seção 3 não entra em construção.
12. **Task retomada de outro sprint ganha plano novo, aqui, com a linha `Retomada de:`** — o plano antigo vive em `sprints/<n-1>/plan/` e é **registro fechado: não se edita, não se copia, não se reaproveita por referência**. O plano novo declara o que já foi feito (a partir do "Parei no passo" do relatório do dev) e **reconfere no código real** as assinaturas dos passos restantes: o repositório mudou no intervalo, e passo executado sobre premissa velha é a causa nº 1 de 🔺 GAP ([`../skills.md`](../skills.md) §1 · R3 · R5).
13. **Todo passo é conferível pelo QA sem julgamento de desenho** — é deste plano que sai a tabela passo × conforme da frente 2 ([`workflow.md` §4a](../../scrum-master/process/workflow.md)). A linha **Conferência** diz o que se observa no código (arquivo, assinatura, nomenclatura, registro de infra, teste); a seção de standard citada no passo diz contra o quê. Passo que o QA não consegue marcar conforme/divergente sem decidir é defeito do plano e volta ao Arquiteto (🔺 GAP → `/arc question`); divergência de execução volta ao dev (`/dev resume`).
14. **Seção 11 sempre presente — é o controle da delegação** (R28). Todo job citado na seção 3 tem linha na seção 11, e toda chamada que fiz ao `operator` para este plano também — inclusive uma remedição posterior, que **acrescenta** linha. O número de linhas é o número de chamadas ("nenhuma" quando zero). O C1 lê os jobs daqui para contar os `report*.md` da Task; os números vêm do hook G16, não desta seção. Plano retomado (regra 12) lista só as chamadas feitas para o plano novo. A frente 2 do QA não confere a seção 11: ela não é passo.
15. **`**Arquivos tocados:**` é lido por script — a guarda G9 nega ao dev todo arquivo de produto fora dela** (R4 · R8). Lista **fechada e completa** — produção **e** teste, inclusive arquivo novo —, um caminho por linha, **entre crases**, relativo à raiz do repositório, com `/`; as linhas seguem o rótulo sem linha em branco no meio (a linha em branco encerra a lista). Nada de diretório, curinga nem "e afins". Arquivo que um 🔺 GAP acrescentar entra **aqui**, além do passo — senão o dev é barrado ao retomar. Rótulo com outra grafia não é lido. **Todo arquivo de produção da lista leva o seu arquivo de teste na lista** — o que a seção 6 prevê, e também o teste existente que o passo altera; arquivo de produção sem teste só com a linha `sem teste: <arquivo> — <motivo>` na seção 6 (teste esquecido na lista vira negação da G9 no meio da Task).
16. **Arquivo de gate protegido não é do dev nem meu** — `guards.json` → `protectedPaths` (`.editorconfig`, CI, hooks de pre-commit…): a G5 o nega a todo subagente. Se a Task precisa mudá-lo, ele vai em `**Arquivos protegidos:** ver §12`, com o diff exato na seção 12, **separado por linha em branco** de `**Arquivos tocados:**` (senão a G9 o leria como do dev); a sessão aplica antes de disparar o dev ([`sprint-run.md`](../../scrum-master/process/sprint-run.md) passo 3). Sem arquivo protegido: `**Arquivos protegidos:** nenhum`. Descobrir no meio da Task que precisa mudar um é 🔺 GAP: o plano ganha a seção 12 e a sessão aplica antes de retomar o dev.

## Exemplo abreviado

```markdown
# Plano de Implementação — T-042 Chave de assinatura obrigatória

**História:** H-014 Exportar o resultado da análise
**Arquivos tocados:** `Infrastructure/Storage/StorageOptions.cs`
`Infrastructure/Storage/UrlSigner.cs`
`Api/Program.cs`
`Api/appsettings.json`
`infra/.env.Development`
`Tests/Unit/UrlSignerTests.cs`
`Tests/Unit/StorageOptionsTests.cs`

**Arquivos protegidos:** nenhum

## 2. Contexto a ler
| Arquivo | Por que |
|---|---|
| `StorageOptions.cs:21` | a chave nasce vazia — é o defeito |
| `Program.cs` (registro das opções de autenticação) | padrão de validação no start a espelhar |
| `UrlSigner.cs` | como a mensagem assinada é composta hoje |

## 3. Ambiente medido e comandos validados
*(Medição do `operator`: `.team-project/operator/<sprint>/<job>/report.md` — código de saída 0, veredito `ok`.)*

| Pré-requisito | Comando de medição | Saída real | Log bruto | Atende? |
|---|---|---|---|---|
| <runtime da unidade tocada> | `<comando de versão>` | `<versão devolvida>` | `<caminho>.log` — <n> linhas | sim |
| <ferramenta de build> | `<comando de versão>` | `<versão devolvida>` | `<caminho>.log` — <n> linhas | sim |

| Comando citado | Onde | Como confirmei | Saída |
|---|---|---|---|
| `<comando de teste>` | Passo 4 / seção 7 | `<comando --help>` | `<literal>` |

**Parada incondicional:** pré-requisito acima ausente no ambiente → 🔺 GAP no passo 1, sem instalar nem substituir.

## 4. Passo 1 — tornar a chave obrigatória
- **Arquivo:** `Infrastructure/Storage/StorageOptions.cs` · **Ação:** ALTERAR
- **Assinatura exata:** `[Required, MinLength(32)] public string SigningKey { get; set; } = string.Empty;`
- **Modelo a espelhar:** as opções de autenticação, que já validam no start
- **Standard aplicável:** `${CLAUDE_PLUGIN_ROOT}/standards/implementation-security-lgpd-copyright.md` §<n> — segredo por configuração validada no start, nunca com default vazio
- **NÃO fazer:** não gerar chave automática em runtime — falhar no start é o comportamento desejado
- **Conferência:** `StorageOptions.cs` contém a assinatura literal acima; nenhuma atribuição de valor a `SigningKey` fora da configuração (nem geração em runtime)

## 6. Testes
| Arquivo | Teste | Deve falhar se… |
|---|---|---|
| `UrlSignerTests.cs` | `Assinatura_ComCaminhoAlterado_DeveSerInvalida` | a mensagem assinada deixar de cobrir o caminho |
| `StorageOptionsTests.cs` | `Start_SemChaveDeAssinatura_DeveFalhar` | a chave voltar a aceitar valor vazio (cobre também o registro em `Program.cs`) |

sem teste: `Api/appsettings.json`, `infra/.env.Development` — configuração; o comportamento é o de `StorageOptionsTests.cs`

## 9. Onde parar e perguntar 🔺
- Se `UrlSigner` já compuser a mensagem de forma diferente da descrita no passo 2.

## 11. Execução delegada
| Operator job | Task/História |
|---|---|
| `.team-project/operator/<sprint>/T-042-ambiente/` | T-042 |
```
