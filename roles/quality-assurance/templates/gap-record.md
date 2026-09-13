# Template — Registro de GAP

Entra no registro de GAPs do projeto (caminho em `.team-project/README.md` §4), na seção da criticidade correspondente.

## Criticidade

| Nível | Significado |
|---|---|
| 🔴 **Crítica** | Funcionalidade documentada não funciona ponta a ponta, ou há exposição de segurança concreta. Bloqueia uso real. |
| 🟠 **Alta** | Requisito ou critério de sucesso declarado como atendido, mas não atendido de fato; ou risco operacional relevante. |
| 🟡 **Média** | Divergência entre especificação e código, lacuna de robustez, ou funcionalidade parcial que degrada sem impedir. |
| 🟢 **Baixa** | Dívida técnica, higiene de repositório, documentação e decisões a formalizar. |

## Abrir um GAP

```markdown
### <MÓDULO>-<NN> — <título afirmativo do defeito>
**Módulo:** <área do sistema> · **Criticidade:** <nível> · **Tipo:** código | processo · **Origem:** time | stakeholder
**Aguarda decisão do stakeholder:** não | sim — <pergunta no formato de R22 (alternativas descritas + recomendação), ou ponteiro para onde ela foi feita (PO, Sprint Review, `/sm agreement`)>
**Evidência:** [<arquivo>:<linha>](<caminho>#L<linha>) — <o fato, não a interpretação>
**Impacto:** <o que deixa de funcionar ou fica exposto, e para quem — cite o requisito ou critério afetado>
**Ação sugerida:** <caminho de correção em uma ou duas frases; sem escrever o plano — isso é do Arquiteto>
```

Depois de abrir: atualizar as tabelas de contagem do documento e, se afetar um critério de sucesso, a tabela correspondente.

### `Origem`

`time` é o padrão: achado levantado pelo próprio time (QA, dev via 🔺 GAP, Arquiteto, PO, UX) durante construção ou auditoria. `stakeholder` é o que ele chama de "bug" — defeito que **ele** relatou. Chega sempre **pelo PO** (nunca direto ao QA): o PO recebe o relato, classifica (defeito vs. mudança de escopo) e aciona o QA, que investiga, confirma com `arquivo:linha` e só então abre ou atualiza a entrada com `origem: stakeholder`. Sem reprodução, não abre entrada — fica como suspeita no veredito.

**Verificação:** toda entrada declara `Origem:` explicitamente (`time` ou `stakeholder`) na mesma linha de `Módulo`/`Criticidade`/`Tipo`. Entrada sem o campo é formato incompleto — não conta no resumo executivo até ser corrigida. Comando de checagem: buscar cada bloco `### <ID>` e confirmar que a linha seguinte contém `Origem:`.

### `Aguarda decisão do stakeholder`

Distingue a entrada que o time resolve sozinho da que está parada esperando uma decisão dele (R9, R22, `workflow.md` §6b — não é regra nova, é o registro **mostrando** um estado que já existia). `sim` só é válido quando a pergunta correspondente existe em algum canal (relato ao PO, pauta de Sprint Review, `/sm agreement`), na forma fixa de R22. `não` é o padrão — inclusive para toda entrada `origem: stakeholder` já respondida ou cuja correção não depende de nova decisão dele.

**Verificação:** entrada com `sim` sem a pergunta ou o ponteiro descrito é achado de formato — devolvida para completar antes de contar no resumo executivo ou na ordem de ataque.

## Tipo `código` × tipo `processo`

Espelha o `Tipo: plano | standard` do [`gap.md` do dev](../../developer/templates/gap.md).

| | `código` | `processo` |
|---|---|---|
| O que é | Defeito na entrega: requisito não atendido, exposição, divergência especificação × código, desvio de seção de standard **citada** no plano | Defeito no próprio `${CLAUDE_PLUGIN_ROOT}/standards/`: contradição entre seções, lacuna que impede executar um passo, regra sem forma de verificação |
| Entra no registro de GAPs do projeto? | Sim, na seção da criticidade | **Não** — o normativo é agnóstico, não é do projeto |
| Onde fica registrado | Este documento (`pending.md` ou o indicado no contexto) | Seção de roteamentos do veredito → `/review` |
| Fecha quando | O código é corrigido e revalidado | O Arquiteto corrige o texto no `/review` seguinte; a decisão técnica que desbloqueia a Task **não** fecha o achado de processo |
| Citação obrigatória | `arquivo:linha` | `arquivo:linha` do código que expôs o problema **+** `<arquivo do standard> §<n>` |

**Três sinais de defeito de standard:** contradição · lacuna · regra inverificável. **Não são defeito:** regra que dá mais trabalho, regra que eu faria diferente, regra que não entendi (reler antes).

## Fechar um GAP

1. Remover a Task da seção de criticidade.
2. Registrar na lista de resolvidos, no topo do documento: `<ID> (<o que resolveu>, <data>)`.
3. Atualizar as tabelas de contagem.
4. Avisar o SM — o registro histórico vai para o documento de status, não aqui (R12: cada dono no seu documento).

## Confirmar um **não-gap**

Task que parecia lacuna e foi verificado como correto vai para a seção de não-gaps, com a evidência. Isso poupa a próxima auditoria de reabrir a mesma suspeita.

```markdown
- **<tema>** — <por que está correto>, com evidência em [<arquivo>:<linha>](<caminho>#L<linha>).
```

## Regras

- **ID no padrão `MÓDULO-NN`**, nunca reaproveitado.
- **Evidência é fato observado no código**, com caminho e linha — não "parece que".
- **Impacto em linguagem de consequência**, não de código: quem é prejudicado e como.
- **Ação sugerida é direção, não plano.** O plano é do Arquiteto.
- Sem evidência conclusiva, a Task **não entra**: fica como suspeita no veredito até ser confirmado.
- **Tipo `processo` não abre Task aqui.** É achado de processo: registra-se na seção de roteamentos do veredito e segue ao `/review` (R16). Este documento só recebe defeitos do projeto.
- **Dono único do registro é o QA.** Os outros papéis reportam pelos canais que já têm (dev: 🔺 GAP; Arquiteto/PO/UX: achado; stakeholder: relato pelo PO) — o QA investiga e **transcreve com evidência `arquivo:linha` confirmada**. É o que garante que toda entrada aqui tem evidência verificada, não narrativa de terceiro.
- **`Origem` sempre preenchida** (`time` ou `stakeholder`) e **`Aguarda decisão do stakeholder`** sempre presente (`não` ou `sim` com a pergunta/ponteiro) — ver seções acima.

## Exemplo

```markdown
### ABC-02 — Chave de assinatura das URLs temporárias fica vazia
**Módulo:** Armazenamento / Segurança · **Criticidade:** 🔴 Crítica · **Origem:** time
**Aguarda decisão do stakeholder:** não
**Evidência:** [StorageOptions.cs:21](<caminho>#L21) — a chave nasce como string vazia; nem a configuração da aplicação nem o arquivo de ambiente a definem.
**Impacto:** a assinatura é calculada com chave vazia — valor público e determinístico. Qualquer pessoa forja uma URL assinada para qualquer arquivo, com validade arbitrária. Viola o requisito de download seguro.
**Ação sugerida:** tornar a chave obrigatória e validada no start (mesmo padrão já usado nas opções de autenticação), uma por ambiente, incluindo o caminho lógico e o escopo na mensagem assinada.
```
