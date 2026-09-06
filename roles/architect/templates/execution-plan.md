# Template — Plano de Execução

Salvo em `.team-project/architect/plans/<ID>-<slug>.md`. É o contrato entre o Arquiteto e o dev: **o que não estiver aqui vira 🔺 GAP, nunca improviso.**

```markdown
# Plano de Execução — <ID> <título>

**Dono:** dev · **Origem:** GAP <ID> / requisito <ID> · **Estimativa:** <n> unidade(s) de trabalho
**Arquivos tocados:** <lista completa, caminho completo>

## 1. Objetivo e fora de escopo
<Um parágrafo: o que passa a funcionar depois deste item.>

**Fora do escopo:** <o que explicitamente NÃO se faz aqui — R4>

## 2. Contexto de código a ler antes de escrever
| Arquivo | Por que |
|---|---|
| <caminho:linha> | <o que observar — assinatura, padrão a espelhar, invariante> |

## 3. Passos, em ordem de execução
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

## 4. Registros de infraestrutura (explícito — nunca "se necessário")
- **Injeção de dependência / registro de componente:** <o registro literal e onde>
- **Migration de banco:** <nome exato> — <tabelas/colunas>
- **Configuração:** <chave, onde declarar, se é obrigatória no start>
- **Mapeamento de erro:** <exceção nova → status HTTP>

## 5. Testes obrigatórios
| Arquivo | Nome do teste | Caso coberto | Deve falhar se… |
|---|---|---|---|

**Cobertura:** o item mantém o gate de **80% mínimo por módulo** na unidade implantável que ele toca —
back-end, worker **ou front-end**. O dev cola a saída real do comando de cobertura no relatório
(`${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §5.4 e §5.5).

## 6. Comandos de verificação
<Os comandos do projeto — ver `.team-project/developer/context.md`. Incluir **sempre** o comando do gate
de cobertura da unidade tocada; se aquela unidade ainda não tem comando de cobertura, isso é gap de
configuração e entra na seção 8, não vira item sem verificação.>

## 7. Critérios de aceite técnicos
- [ ] <checklist binário, verificável>

## 8. Onde parar e perguntar 🔺
- <ponto em que o dev deve levantar GAP em vez de decidir>
- *(fixo)* Se uma seção de standard citada aqui **se contradisser, tiver lacuna ou não disser como se verifica**: 🔺 GAP ao Arquiteto — o standard não se corrige de passagem (R16)

## 9. Segurança (obrigatório se o item toca autenticação, autorização, escopo, dado pessoal ou conteúdo de terceiro)
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
2. **Cabe em uma unidade de trabalho** — acima de ~10 passos ou duas áreas do sistema, quebrar em `<ID>a`/`<ID>b`.
3. **Ordem preserva o repositório íntegro** no maior número de pontos intermediários.
4. **Uma migration de banco por item.**
5. **Nomes exatamente como na especificação** — grafia é contrato.
6. **Nada de "siga o padrão"** — aponte o arquivo concreto a espelhar.
7. **Se o dev puder escolher entre duas formas, o plano está incompleto.**
8. **Todo passo declara o anel** do arquivo que toca. Passo que faz o domínio depender de fora, ou que põe regra de negócio na borda, é erro de plano — não de execução (`${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §2).
9. **Nenhum passo de refatoração "de passagem".** Melhoria fora do objetivo do item vira item próprio (§4.5 do mesmo normativo).
10. **Todo passo com regra de engenharia cita a seção de `${CLAUDE_PLUGIN_ROOT}/standards/` aplicável, com número** (R16). O dev lê só o que o plano citou — seção não citada é seção não lida. "Seguir os standards" não é citação. Se a regra de que o passo precisa **não existe** no normativo, ou existe contraditória, isso é defeito do standard e é do Arquiteto: resolver por `/arc review` antes de liberar o plano.

## Exemplo abreviado

```markdown
# Plano de Execução — ABC-02 Chave de assinatura obrigatória

**Arquivos tocados:** `Infrastructure/Storage/StorageOptions.cs`, `Infrastructure/Storage/UrlSigner.cs`,
`Api/Program.cs`, `Api/appsettings.json`, `infra/.env.Development`, `Tests/Unit/UrlSignerTests.cs`

## 2. Contexto a ler
| Arquivo | Por que |
|---|---|
| `StorageOptions.cs:21` | a chave nasce vazia — é o defeito |
| `Program.cs` (registro das opções de autenticação) | padrão de validação no start a espelhar |
| `UrlSigner.cs` | como a mensagem assinada é composta hoje |

## 3. Passo 1 — tornar a chave obrigatória
- **Arquivo:** `Infrastructure/Storage/StorageOptions.cs` · **Ação:** ALTERAR
- **Assinatura exata:** `[Required, MinLength(32)] public string SigningKey { get; set; } = string.Empty;`
- **Modelo a espelhar:** as opções de autenticação, que já validam no start
- **Standard aplicável:** `${CLAUDE_PLUGIN_ROOT}/standards/implementation-security-lgpd-copyright.md` §<n> — segredo por configuração validada no start, nunca com default vazio
- **NÃO fazer:** não gerar chave automática em runtime — falhar no start é o comportamento desejado

## 5. Testes
| Arquivo | Teste | Deve falhar se… |
|---|---|---|
| `UrlSignerTests.cs` | `Assinatura_ComCaminhoAlterado_DeveSerInvalida` | a mensagem assinada deixar de cobrir o caminho |

## 8. Onde parar e perguntar 🔺
- Se `UrlSigner` já compuser a mensagem de forma diferente da descrita no passo 2.
```
