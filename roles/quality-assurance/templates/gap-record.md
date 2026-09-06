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
**Módulo:** <área do sistema> · **Criticidade:** <nível> · **Tipo:** código | processo
**Evidência:** [<arquivo>:<linha>](<caminho>#L<linha>) — <o fato, não a interpretação>
**Impacto:** <o que deixa de funcionar ou fica exposto, e para quem — cite o requisito ou critério afetado>
**Ação sugerida:** <caminho de correção em uma ou duas frases; sem escrever o plano — isso é do Arquiteto>
```

Depois de abrir: atualizar as tabelas de contagem do documento e, se afetar um critério de sucesso, a tabela correspondente.

## Tipo `código` × tipo `processo`

Espelha o `Tipo: plano | standard` do [`gap.md` do dev](../../developer/templates/gap.md).

| | `código` | `processo` |
|---|---|---|
| O que é | Defeito na entrega: requisito não atendido, exposição, divergência especificação × código, desvio de seção de standard **citada** no plano | Defeito no próprio `${CLAUDE_PLUGIN_ROOT}/standards/`: contradição entre seções, lacuna que impede executar um passo, regra sem forma de verificação |
| Entra no registro de GAPs do projeto? | Sim, na seção da criticidade | **Não** — o normativo é agnóstico, não é do projeto |
| Onde fica registrado | Este documento (`pending.md` ou o indicado no contexto) | Seção de roteamentos do veredito → `/arc review` |
| Fecha quando | O código é corrigido e revalidado | O Arquiteto corrige o texto no `/arc review` seguinte; a decisão técnica que desbloqueia o item **não** fecha o achado de processo |
| Citação obrigatória | `arquivo:linha` | `arquivo:linha` do código que expôs o problema **+** `<arquivo do standard> §<n>` |

**Três sinais de defeito de standard:** contradição · lacuna · regra inverificável. **Não são defeito:** regra que dá mais trabalho, regra que eu faria diferente, regra que não entendi (reler antes).

## Fechar um GAP

1. Remover o item da seção de criticidade.
2. Registrar na lista de resolvidos, no topo do documento: `<ID> (<o que resolveu>, <data>)`.
3. Atualizar as tabelas de contagem.
4. Avisar o SM — o registro histórico vai para o documento de status, não aqui (R12: cada dono no seu documento).

## Confirmar um **não-gap**

Item que parecia lacuna e foi verificado como correto vai para a seção de não-gaps, com a evidência. Isso poupa a próxima auditoria de reabrir a mesma suspeita.

```markdown
- **<tema>** — <por que está correto>, com evidência em [<arquivo>:<linha>](<caminho>#L<linha>).
```

## Regras

- **ID no padrão `MÓDULO-NN`**, nunca reaproveitado.
- **Evidência é fato observado no código**, com caminho e linha — não "parece que".
- **Impacto em linguagem de consequência**, não de código: quem é prejudicado e como.
- **Ação sugerida é direção, não plano.** O plano é do Arquiteto.
- Sem evidência conclusiva, o item **não entra**: fica como suspeita no veredito até ser confirmado.
- **Tipo `processo` não abre item aqui.** É achado de processo: registra-se na seção de roteamentos do veredito e segue ao `/arc review` (R16). Este documento só recebe defeitos do projeto.

## Exemplo

```markdown
### ABC-02 — Chave de assinatura das URLs temporárias fica vazia
**Módulo:** Armazenamento / Segurança · **Criticidade:** 🔴 Crítica
**Evidência:** [StorageOptions.cs:21](<caminho>#L21) — a chave nasce como string vazia; nem a configuração da aplicação nem o arquivo de ambiente a definem.
**Impacto:** a assinatura é calculada com chave vazia — valor público e determinístico. Qualquer pessoa forja uma URL assinada para qualquer arquivo, com validade arbitrária. Viola o requisito de download seguro.
**Ação sugerida:** tornar a chave obrigatória e validada no start (mesmo padrão já usado nas opções de autenticação), uma por ambiente, incluindo o caminho lógico e o escopo na mensagem assinada.
```
