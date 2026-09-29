# Template — Relatório ao dono do plugin

> **Dono:** SM · Vive em `.team-project/sprints/<n>/plugin-report.md` · Escrito no `/sm sprint close`, junto com a retrospectiva · **Encaminhado pelo stakeholder**

O projeto **não edita o plugin**. Este relatório é o canal de volta: tira da retrospectiva o que diz respeito ao **processo do time** — consumo por papel e por modelo, invocações repetidas, bloqueios e falhas ligados a regra ou cerimônia — e o apresenta **sem nada do projeto**, para que o stakeholder o entregue ao dono do plugin. O `/review`, no repositório-fonte, é quem o transforma em mudança; aqui só há **evidência e sintoma**, nunca a regra reescrita.

**Fluxo.** SM escreve no `/sm sprint close`, com a retrospectiva à vista → **o stakeholder lê antes de encaminhar** (é a única barreira contra vazamento que o SM não consegue provar sozinho) → leva ao dono do plugin → os sintomas entram em `RAIZ/note.md` e o relatório serve de evidência ao `/review`. Nada aqui muda o plugin instalado.

**O que NÃO entra (vazamento de contexto).** Nome do projeto, do cliente, do produto ou de pessoa; domínio de negócio; código, caminho de arquivo ou dado do projeto; título ou conteúdo de História; ID de Task ou de História (use **"Task A", "Task B"…**, só para ligar linhas dentro do relatório). **O que entra:** papel, modelo, comando, regra (`R<n>`), cerimônia, seção de documento do plugin, contagens, tokens e durações.

```markdown
# Relatório ao dono do plugin — Sprint <n> — <data>

**Versão do plugin instalada:** <x.y.z, como `/team version` mostra> · **Unidade de estimativa:** <a do projeto> · **Sprint de** <n> Tasks · <n> Histórias
**Registro de consumo:** <existe | n/a — o projeto não registra consumo; seções 1 e 2 ficam "n/a">

## 1. Consumo por papel e por modelo
> Fonte: `consumption.md` do sprint. O **modelo** é o configurado no cartão do agente (ou override declarado), não o servido; tokens são um total por invocação, sem divisão entrada/saída. **Piso** — a sessão principal não se autoobserva. O `operator` entra no total, em linha própria por papel chamador; premissa: o número do papel não inclui o do `operator` aninhado.

| Papel | Modelo | Σ tokens | Invocações | Duração total | % do total |
|---|---|---|---|---|---|
| <papel> | <modelo \| "não disponível — <motivo>"> | <n> | <n> | <mm:ss> | <n%> |
| operator ← <papel chamador> *(uma linha por chamador)* | <modelo do `operator`> | <n> | <n chamadas> | <mm:ss> | <n%> |
| **Total** (papéis + `operator`) | — | **<n>** | **<n>** | **<mm:ss>** | 100% |

- **Contra o sprint anterior:** <Δ% e a causa | primeiro sprint com registro>
- **Delegação ao `operator` (candidato a investigar):** por Task (A, B…) que delegou, consumo do papel chamador × consumo do `operator` que ele chamou, cada um com o modelo — <Task · papel · Σ · modelo × Σ · modelo | nenhuma delegação>. Não afirma economia absoluta: o registro não traz o custo da mesma tarefa sem delegar.

## 2. Ineficiências observadas
> As cinco verificações da retrospectiva (repetição, Task cara, papel desproporcional, modelo × trabalho, consumo × falha). Só o que tem linha de registro que o sustente.

| # | Padrão | Papel · modelo | Ocorrências | Σ tokens | Causa aparente (do registro/quadro) |
|---|---|---|---|---|---|
| 1 | <ex.: mesmo papel 4× na mesma Task> | <papel · modelo> | <n> | <n> | <plano raso, GAP, reprovação, bloqueio, comando refeito> |

## 3. Bloqueios, falhas e gaps de processo
> Só os que tocam **o processo** (regra, cerimônia, modelo, comando) — não o produto.

| # | O que aconteceu, sem o contexto do projeto | Regra / cerimônia | Degrau do bloqueio (R25) | Ocorrências |
|---|---|---|---|---|
| 1 | <fato> | <R<n> · §<x>> | <par PO+Arquiteto · stakeholder · estratégico> | <n> |

## 4. Sintomas para o `note.md` do plugin
> **Sintoma, não solução** — é o formato da fila do `/review`. Cada linha de 1–3 que merece mudança vira uma linha aqui.

| # | Sintoma observado neste sprint | Onde doeu (regra, cerimônia, modelo, comando, `templates/<y>.md`) | Quantas vezes |
|---|---|---|---|
| 1 | <o que aconteceu, sem propor a correção> | <onde> | <n> |

## 5. Encaminhamento
- **Relido contra vazamento de contexto pelo SM:** <sim>
- **Lido pelo stakeholder antes de encaminhar:** <sim, em <data> | pendente>
- **Encaminhado ao dono do plugin:** <sim, em <data> | não — fica registrado para reincidência>
- **Sintomas levados ao `RAIZ/note.md`:** <quais, em <data> | nenhum>
```

## Regras

- **Sem contexto do projeto — nunca.** O relatório é lido por quem não tem acesso ao projeto; vazamento aqui expõe cliente e domínio. Na dúvida, generalize ou corte.
- **Sintoma, não proposta.** O dono do plugin e o `/review` analisam conflito com regra vigente; relatório que já traz a regra reescrita pulou esse lugar.
- **Número sem fonte não entra (R7).** Seções 1–2 saem só de `consumption.md`; seção 3, do quadro e da retrospectiva. Sem o registro de consumo, escreva "n/a" — não estime.
- **Uma ação, não uma lista.** A retrospectiva mantém a **única** ação do próximo sprint; o relatório não a substitui, e os sintomas não viram tarefa do sprint.
- **Não substitui a retrospectiva.** Ela fica com o contexto do projeto e fecha com a pasta; este arquivo é a versão **sem contexto**, para sair do projeto.