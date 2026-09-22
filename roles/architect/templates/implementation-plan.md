# Template — Plano de Implementação

Salvo em `.team-project/sprints/<n>/plan/<T-ID>-<slug>.md` — dentro da pasta do sprint a que a Task pertence, na subpasta do Arquiteto ([`../../scrum-master/process/artifact-ownership.md` §1e](../../scrum-master/process/artifact-ownership.md)). **É o conteúdo técnico da Task**, não um artefato irmão dela: a Task é a unidade de trabalho no Sprint Backlog, e o plano é o que diz como ela se faz. É o contrato entre o Arquiteto e o dev: **o que não estiver aqui vira 🔺 GAP, nunca improviso.**

> **O caminho não é fixo:** `.team-project/README.md` §2 declara **qual é o sprint corrente**, e é por lá que o dev e o QA acham este plano. A coluna Plano do `sprint-backlog.md` aponta para ele; ponteiro que não resolve é achado de processo.

> **A fronteira funcional × técnica passa aqui** (R20). O "o quê" e o "para quê" já foram decididos na História, pelo PO, e aprovados pelo stakeholder no portão ③. Este plano é o primeiro lugar onde aparece decisão técnica — e o único.

```markdown
# Plano de Implementação — <T-ID> <título da Task>

**História:** H-<nnn> <título> · **Dono:** dev · **Origem:** GAP <ID> / critério de aceite <n> da História
**Estimativa:** <n> unidade(s) — a que o time deu na Planning
**Retomada de:** `sprints/<n-1>/plan/<T-ID>-<slug>.md` — parou no passo <n> de <m>, repositório <estado>
*(linha obrigatória só quando a Task volta de um sprint anterior; omitir quando a Task é nova)*
**Arquivos tocados:** <lista completa, caminho completo>

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

**Medição do `operator` (quando foi ela):** `.team-project/operator/<sprint>/<job>/` — trabalho
`<nome>`, código de saída `<n>`, veredito `<ok | falhou>`. Veredito `inconclusivo` **não** preenche
esta seção; medição citada depois de o arquivo que declara a toolchain mudar, ou cujo log sumiu do
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
cobertura — código de saída, pior módulo × limiar — **e** o caminho do log bruto (R28)
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
```

## Regras do formato

1. **Sequência linear** quando o time tem um único dev; sem faixas paralelas.
2. **Cabe em uma unidade de trabalho** — acima de ~10 passos ou duas áreas do sistema, quebrar em `<T-ID>a`/`<T-ID>b`, **sempre dentro da mesma História** (R2 · R20).
3. **Ordem preserva o repositório íntegro** no maior número de pontos intermediários.
4. **Uma migration de banco por Task.**
5. **Nomes exatamente como na especificação** — grafia é contrato.
6. **Nada de "siga o padrão"** — aponte o arquivo concreto a espelhar.
7. **Se o dev puder escolher entre duas formas, o plano está incompleto.**
8. **Todo passo declara o anel** do arquivo que toca. Passo que faz o domínio depender de fora, ou que põe regra de negócio na borda, é erro de plano — não de execução (`${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §2).
9. **Nenhum passo de refatoração "de passagem".** Melhoria fora do objetivo da Task vira Task própria — e, se nenhuma História a cobre, o PO escreve a História que declara o valor (§4.5 do mesmo normativo · R20).
10. **Todo passo com regra de engenharia cita a seção de `${CLAUDE_PLUGIN_ROOT}/standards/` aplicável, com número** (R16). O dev lê só o que o plano citou — seção não citada é seção não lida. "Seguir os standards" não é citação. Se a regra de que o passo precisa **não existe** no normativo, ou existe contraditória, isso é defeito do standard e é do Arquiteto: resolver por `/review` antes de liberar o plano.
11. **Ambiente medido antes dos passos** (R26). A seção 3 sai preenchida com comando e saída real — **minha ou do `operator`, com código de saída, versões e caminho do log bruto**, nunca veredito `inconclusivo`: nenhum passo cita comando que eu não vi existir na versão medida, e a parada incondicional cobre **ausência** do pré-requisito, não só versão fora da faixa. Faixa de versão sozinha não é regra de parada. Plano sem a seção 3 não entra em construção.
12. **Task retomada de outro sprint ganha plano novo, aqui, com a linha `Retomada de:`** — o plano antigo vive em `sprints/<n-1>/plan/` e é **registro fechado: não se edita, não se copia, não se reaproveita por referência**. O plano novo declara o que já foi feito (a partir do "Parei no passo" do relatório do dev) e **reconfere no código real** as assinaturas dos passos restantes: o repositório mudou no intervalo, e passo executado sobre premissa velha é a causa nº 1 de 🔺 GAP ([`../skills.md`](../skills.md) §1 · R3 · R5).

## Exemplo abreviado

```markdown
# Plano de Implementação — T-042 Chave de assinatura obrigatória

**História:** H-014 Exportar o resultado da análise
**Arquivos tocados:** `Infrastructure/Storage/StorageOptions.cs`, `Infrastructure/Storage/UrlSigner.cs`,
`Api/Program.cs`, `Api/appsettings.json`, `infra/.env.Development`, `Tests/Unit/UrlSignerTests.cs`

## 2. Contexto a ler
| Arquivo | Por que |
|---|---|
| `StorageOptions.cs:21` | a chave nasce vazia — é o defeito |
| `Program.cs` (registro das opções de autenticação) | padrão de validação no start a espelhar |
| `UrlSigner.cs` | como a mensagem assinada é composta hoje |

## 3. Ambiente medido e comandos validados
*(Medição do `operator`: `.team-project/operator/<sprint>/<job>/` — código de saída 0, veredito `ok`.)*

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

## 6. Testes
| Arquivo | Teste | Deve falhar se… |
|---|---|---|
| `UrlSignerTests.cs` | `Assinatura_ComCaminhoAlterado_DeveSerInvalida` | a mensagem assinada deixar de cobrir o caminho |

## 9. Onde parar e perguntar 🔺
- Se `UrlSigner` já compuser a mensagem de forma diferente da descrita no passo 2.
```
