# Template — 🔺 GAP

Levantado pelo dev quando o plano — ou a seção de standard que ele citou — não cobre o que apareceu no código. **Ao escrever um GAP, a codificação para** (R9).

```markdown
🔺 GAP — <ID da tarefa> — passo <n> do plano

**Tipo:** plano | standard
**O que o plano diz:** <trecho literal>
**O que encontrei no código:** <arquivo:linha> — <o fato observado>
**Por que não consigo seguir:** <1-2 frases>
**Opções que enxergo:** A) … B) …   (não escolhi nenhuma)
**O que já entreguei até aqui:** <arquivos e passos concluídos>
**Estado do repositório:** <compila? testes passam?>
```

**Quando o tipo é `standard`**, duas linhas a mais, no lugar de "O que o plano diz":

```markdown
**Standard citado:** `${CLAUDE_PLUGIN_ROOT}/standards/<arquivo>.md` §<n> — <a obrigação, literal>
**Defeito:** contradição (com `<arquivo> §<m>` / com o passo <n>) | lacuna | regra sem forma de verificação
```

## Quando levantar (sempre)

- Assinatura diferente da descrita no plano
- Classe, método ou propriedade que o plano assume e não existe
- Ambiguidade de nome (dois candidatos plausíveis)
- Regra de negócio não especificada
- Autorização não indicada num item que mexe com dado sensível
- Passo que exige tocar arquivo fora da lista do plano
- Teste previsto que não faz sentido contra o código real
- Identidade/escopo que o plano pede vindo do request
- Passo que só cabe estourando um limite de código (função acima de 50 linhas, 10 de complexidade ciclomática ou 4 parâmetros — `${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §4.4) — quebrar a função é decisão de desenho
- Constante/valor que o passo exige e o plano não define
- **Defeito na seção de standard que o plano citou** — ver abaixo
- **Regra de engenharia que o passo exige e nenhuma seção citada cobre** — seção não citada é seção não lida (R3); pedir a citação é do Arquiteto

## Defeito em `${CLAUDE_PLUGIN_ROOT}/standards/` — o GAP de tipo `standard`

`${CLAUDE_PLUGIN_ROOT}/standards/` é a base de qualidade comum do time. O **dono editorial é o Arquiteto**; o dev e o QA são **consumidores obrigatórios** (R16). Por isso defeito ali **não se corrige de passagem**: vira GAP, o dev **para de codificar**, e a correção sai por `/review`.

O que caracteriza:

| Defeito | Como se reconhece |
|---|---|
| **Contradição** | A seção citada obriga X e outra seção do normativo — ou o próprio passo do plano — proíbe X |
| **Lacuna** | A seção não alcança o caso do passo, e sem ela restam duas formas igualmente defensáveis |
| **Regra inverificável** | A obrigação existe, mas não diz o comando, o teste ou o critério objetivo que prova o cumprimento |

**Não é defeito de standard:** regra que o dev não entendeu (reler antes), regra que dá mais trabalho, regra que ele faria diferente. Discordar é legítimo; decidir não é do dev.

**As três saídas erradas:** editar o arquivo do standard, improvisar uma interpretação e seguir, ou ignorar a seção citada e entregar assim mesmo.

## Quando **não** levantar

- Dúvida que o próprio plano já responde em outro passo — reler antes
- Preferência de estilo (nomear variável, ordenar imports) — seguir o padrão do arquivo
- Curiosidade sobre o porquê da decisão, sem impedimento para executar
- Discordância de mérito com uma regra de standard, sem contradição, lacuna nem falta de verificação

## Regras

- **Não escolher uma das opções.** Listar é ajudar; escolher é decidir — e decidir não é do dev.
- **Citar `arquivo:linha`**, não a impressão. O Arquiteto vai ler o código antes de responder. No GAP de tipo `standard`, citar também `<arquivo do standard> §<n>`.
- **Dizer o que já foi entregue e como o repositório ficou** — permite ao Arquiteto decidir se vale continuar ou reverter.
- Depois da resposta, retomar por `/dev gap <resposta>` (ou continuar o mesmo agente), do passo em que parou.
- **GAP de tipo `standard` não fecha com a resposta.** A decisão técnica desbloqueia o item; a correção do documento é do `/review` seguinte (R16). O dev registra o GAP no relatório de entrega mesmo quando já voltou a codificar.

## Exemplo 1 — tipo `plano`

```
🔺 GAP — ABC-05 — passo 3 do plano

**Tipo:** plano
**O que o plano diz:** "declarar a autorização do comando com a permissão `documento.escrever`".
**O que encontrei no código:** `PermissionCatalog.cs:46-62` — o catálogo tem 17 permissões
e nenhuma da família `documento.*`.
**Por que não consigo seguir:** a permissão referenciada não existe; sem cadastro, a verificação
vai negar toda requisição, inclusive a do perfil administrador.
**Opções que enxergo:** A) criar a migration de cadastro neste mesmo item, incluindo o vínculo
aos perfis padrão; B) usar uma permissão já existente e deixar a dedicada para outro item.
(não escolhi nenhuma)
**O que já entreguei até aqui:** passos 1 e 2 — os 5 comandos marcados, sem a permissão.
**Estado do repositório:** compila; testes passam (nenhum cobre o caminho autorizado ainda).
```

## Exemplo 2 — tipo `standard`

```
🔺 GAP — ABC-07 — passo 2 do plano

**Tipo:** standard
**Standard citado:** `${CLAUDE_PLUGIN_ROOT}/standards/<perfil de stack>.md` §<n> — "toda operação de escrita
registra evento de auditoria antes de retornar".
**Defeito:** regra sem forma de verificação — a seção não diz o que o evento precisa conter
nem por qual teste ou comando se prova que ele foi emitido.
**O que encontrei no código:** `<Adaptador de auditoria>:31-58` — os dois usos existentes gravam
campos diferentes, e nenhum teste cobre a emissão.
**Por que não consigo seguir:** o passo exige "auditar conforme o standard", e o standard não fixa
o conteúdo nem o critério de aceite — qualquer escolha minha vira decisão de desenho.
**Opções que enxergo:** A) espelhar o uso mais recente e cobrir com teste de emissão;
B) o Arquiteto fixar o conjunto mínimo de campos no plano deste item. (não escolhi nenhuma)
**O que já entreguei até aqui:** passo 1 — o comando e o handler, sem auditoria.
**Estado do repositório:** compila; testes passam.
```

*(A resposta do Arquiteto desbloqueia o item. A correção do texto do standard entra no `/review` seguinte — R16.)*
