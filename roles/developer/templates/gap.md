# Template — 🔺 GAP

Levantado pelo dev quando o plano — ou a seção de standard que ele citou — não cobre o que apareceu no código. **Ao escrever um GAP, a codificação para** (R9). O GAP vai no relatório de entrega gravado (`delivery/<T-ID>.md`; no fix, a seção da F-ID em `delivery.md` — v3.49), e o retorno a quem me disparou (o executor de Task no run; a sessão fora dele) diz `🔺 GAP` com o caminho do arquivo.

```markdown
🔺 GAP — <ID da Task | F-<nnn> na trilha fix> — passo <n> do plano

**Tipo:** plano | standard
**Natureza:** aparência | desenho | produto | processo | ambiente   *(v3.57.0; v3.57.1: obrigatória, e processo e ambiente entram — o que decide quem responde; abaixo)*
**Origem (sugestão):** previsão | conhecimento | requisito | ambiente | processo   (o Arquiteto confirma)
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

**A origem (v3.56.0)** diz de onde o GAP nasceu — eu sugiro, o Arquiteto confirma na decisão, e ela decide para onde vai a lição:

| Origem | Quando | Exemplo curto |
|---|---|---|
| `previsão` | o plano previu algo que o código ou o render real desmentiu, só nesta Task | o passo assumia 2 itens na lista e o render mostra 3 |
| `conhecimento` | um fato do próprio app, da stack ou do ambiente que já se sabia (ou devia se saber) e não chegou ao plano | o limiar de 160 px que já tinha reprovado num sprint anterior |
| `requisito` | o critério de aceite ou a regra de negócio não diz | o que mostrar quando a lista está vazia |
| `ambiente` | o ambiente real (emulador, APK, servidor, rede) se comporta diferente do que o plano mediu | o emulador sobe sem a WebView atualizada |
| `processo` | a regra, a guarda ou o script do plugin mandou o que o plano proíbe | o cartão mandou rodar um cenário que o plano tirou |

## A natureza do GAP — quem responde (v3.57.0)

No sprint 5 do garden, 4 de 5 GAPs de uma Task de interface eram decisões pequenas de medida ou de marcação, e cada um custou um Arquiteto novo mais um dev novo. A natureza que **você** marca decide a rota; na dúvida entre duas, marque a mais pesada.

| Natureza | Quando | Quem responde |
|---|---|---|
| `aparência` | uma **medida** (espaçamento, alinhamento, quebra de linha, tamanho) que cai fora do envelope do plano, ou uma **marcação** simples (rótulo acessível, identificador) — a decisão é uma regra de estilo ou um atributo | o Arquiteto, em **parecer curto** (até 8 linhas, sem reescrever o plano) |
| `desenho` | estrutura, fluxo, contrato, arquivo fora da lista, teste que não faz sentido — o resto dos GAPs | o Arquiteto, ciclo completo (como hoje) |
| `produto` | muda o que o usuário vê ou faz: regra de produto, texto de tela, empilhar ou esconder um controle | o **stakeholder** (formulário); o Arquiteto só registra depois |
| `processo` | regra do time ou do plugin em conflito: o cartão manda o que o plano proíbe, comando negado pela guarda, ordem do `verify`, gate que reprova o que não devia | o Arquiteto, ciclo completo |
| `ambiente` | alvo, emulador, prazo de comando, ferramenta ou massa de dados se comportam diferente do que o plano mediu | o Arquiteto, ciclo completo |

**A linha é obrigatória (v3.57.1).** No sprint 5 do garden ela veio em 2 de 22 GAPs — a lista não tinha `processo` nem `ambiente`, que eram a maioria — e sem ela não se mede quantos GAPs são de aparência (a decisão de mandá-los a um modelo mais barato depende disso). Sem a linha nem a palavra na linha do 🔺, o `run.ps1 done -Result gap` recusa e o executor da Task classifica pelo seu texto.

**Com envelope no plano** (`**Envelope de medidas**`, que o cartão traz): meça o caso, aplique o caso medido e registre a medida e a escolha no relatório (R9) — isso **não é GAP**. GAP de aparência só quando a medida cai **fora** do envelope.

**Um GAP de aparência por Task.** Antes de parar, meça **todos** os casos do envelope e do que a tela mostra; o GAP lista cada medida fora do envelope, uma linha cada (`<medida> · <o que mediu> · <opções>`). A1 e A2 do garden foram dois ciclos separados a 10 min um do outro por falta disso.

## Quando levantar (sempre)

- Assinatura diferente da descrita no plano
- Classe, método ou propriedade que o plano assume e não existe
- Ambiguidade de nome (dois candidatos plausíveis)
- Regra de negócio não especificada
- Autorização não indicada numa Task que mexe com dado sensível
- Passo que exige tocar arquivo fora da lista do plano
- Teste previsto que não faz sentido contra o código real
- Identidade/escopo que o plano pede vindo do request
- Passo que só cabe estourando um limite de código (função acima de 50 linhas, 10 de complexidade ciclomática ou 4 parâmetros — `${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §4.4) — quebrar a função é decisão de desenho
- Constante/valor que o passo exige e o plano não define
- **Defeito na seção de standard que o plano citou** — ver abaixo
- **Regra de engenharia que o passo exige e nenhuma seção citada cobre** — seção não citada é seção não lida (R3); pedir a citação é do Arquiteto
- **Comando de verificação ou gate de qualidade do plano que não existe, não resolve ou reprova** — desligar, afrouxar o limiar, tirar do build, trocar por outro comando ou contornar por configuração nunca é decisão do dev (R4 · R7)
- **Pré-requisito do ambiente ausente** — ferramenta, runtime ou SDK da seção 3 do plano que não existe aqui: parar no passo 1, sem instalar nem substituir por equivalente (R26)
- **Gate que não foi exercitado**, inclusive a reprovação dele quando o plano a pede: declarar **não exercitado**, com o motivo — nunca "pronto", nunca "% funcional"
- **Trilha `fix`:** teste de regressão que **passa** antes da correção, ou falha por outro motivo que não a asserção do mini-plano; arquivo da F-ID com mudança não commitada antes de eu começar; hook que reprova o commit da F-ID — a resposta pode ser a promoção da F-ID (R33)

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
- **GAP de tipo `standard` não fecha com a resposta.** A decisão técnica desbloqueia a Task; a correção do documento é do `/review` seguinte (R16). O dev registra o GAP no relatório de entrega mesmo quando já voltou a codificar.

## Exemplo 1 — tipo `plano`

```
🔺 GAP — ABC-05 — passo 3 do plano

**Tipo:** plano
**O que o plano diz:** "declarar a autorização do comando com a permissão `documento.escrever`".
**O que encontrei no código:** `PermissionCatalog.cs:46-62` — o catálogo tem 17 permissões
e nenhuma da família `documento.*`.
**Por que não consigo seguir:** a permissão referenciada não existe; sem cadastro, a verificação
vai negar toda requisição, inclusive a do perfil administrador.
**Opções que enxergo:** A) criar a migration de cadastro nesta mesma Task, incluindo o vínculo
aos perfis padrão; B) usar uma permissão já existente e deixar a dedicada para outra Task.
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
B) o Arquiteto fixar o conjunto mínimo de campos no plano desta Task. (não escolhi nenhuma)
**O que já entreguei até aqui:** passo 1 — o comando e o handler, sem auditoria.
**Estado do repositório:** compila; testes passam.
```

*(A resposta do Arquiteto desbloqueia a Task. A correção do texto do standard entra no `/review` seguinte — R16.)*
