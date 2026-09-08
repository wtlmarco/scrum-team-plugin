# Replicar este time em um novo projeto

O plugin é **inteiramente genérico**: não contém nada de um produto específico. Replicar não é adaptar o time — é **instalar o plugin** e **escrever o contexto do novo projeto**.

| Diretório | Natureza | Ao replicar |
|---|---|---|
| O plugin | Processo: papéis, regras, fluxo, padrões, modelos, changelog do processo | **Copiar ou apontar — nada a editar** |
| `.team-project/` | Contexto: produto, stack, comandos, quadro, backlog, planos, evidências | **Criar do zero** |

## Passo 1 — Instalar o time

Este repositório **é** um plugin do Claude Code autocontido. Os comandos `claude plugin marketplace add` / `install` / `update` e o passo de reiniciar a sessão estão em [`how-to.md` § "Instalar em um projeto"](how-to.md) — a fonte única desse bloco. O que é próprio da replicação:

- A origem pode ser um caminho local (`../scrum-team-plugin`) ou o repositório git. O registro vai para `.claude/settings.json` do novo projeto; **caminho relativo é preservado**, então pode ser versionado. **Use a mesma forma de identificador em todos os registros** — URL `.git` completa ou caminho local, nunca `owner/repo` misturado com URL (`how-to.md` passo 1).
- O novo projeto **não precisa ser repositório git** para receber o time.
- **Uma origem, vários projetos.** Melhorias no processo chegam a todos de uma vez por `claude plugin marketplace update team` + `claude plugin update team@team`. Copiar a pasta para dentro de cada projeto cria versões que divergem — não faça isso.

## Passo 2 — Criar o contexto do projeto: `/team init`

Depois de reiniciar a sessão, rode **`/team init`**. Ele cria a estrutura de `.team-project/` a partir dos modelos, lê o repositório para preencher o que já dá para inferir, pergunta só o que falta e aponta o próximo passo conforme o projeto seja novo ou retomado.

O guia de uso — instalação, atualização, os quatro caminhos de entrada (projeto novo · retomada · bug · melhoria) e as regras que valem sempre — está em [`how-to.md`](how-to.md).

Sem `.team-project/`, os agentes param e pedem que ele seja criado. A **estrutura do diretório, a tabela arquivo → modelo de origem e o que vai em cada `context.md`** estão em [`roles/scrum-master/templates/project-context.md`](roles/scrum-master/templates/project-context.md) — a fonte única. Consulte-a se preferir montar à mão ou conferir o que o `/team init` produziu.

**O que mais rende ao escrever:** as **armadilhas** do projeto no `context.md` do Arquiteto e do Dev. Uma linha como *"handler novo exige registro manual, senão devolve 500"* evita mais retrabalho do que três parágrafos de descrição de arquitetura.

## Passo 3 — Abrir o conjunto de entregáveis

O time também **elabora e mantém** os documentos de projeto. A estrutura de cada um está em [`deliverables/`](deliverables/README.md), em dois conjuntos:

| Conjunto | Responde | Donos |
|---|---|---|
| [`sdd/`](deliverables/sdd/README.md) — 8 documentos | o que o sistema é | PO (5) · Arquiteto (3) |
| [`implementation/`](deliverables/implementation/README.md) — 4 documentos | como a construção está indo | PO (1) · SM (1) · QA (2) |

**Projeto novo:** crie no dia 1 apenas o **índice do SDD** e o documento de **escopo e critérios** — o resto nasce quando a necessidade aparecer. Depois siga a ordem de elaboração de [`deliverables/README.md`](deliverables/README.md).

**Projeto retomado:** comece pelo `pending.md`. `/qa audit` + `/qa baseline` produzem o levantamento sobre código que vira o backlog inicial — e revelam o tamanho verdadeiro do trabalho, que costuma diferir do que o documento de status declara.

**Não escreva os doze de uma vez.** Documento escrito antes da necessidade envelhece antes de ser lido.

## Passo 4 — Ajustar a composição do time

A distribuição de modelos é uma escolha de custo/qualidade, não uma regra:

| Papel | Modelo | Por quê |
|---|---|---|
| Arquiteto | Opus | Concentra todo o raciocínio de desenho técnico |
| UX | Opus | Desenho de jornada e tela é raciocínio original, não execução de padrão |
| SM, PO, QA | Sonnet | Leitura, julgamento e verificação — não precisam de desenho original |
| Dev | Haiku | Executa plano detalhado; a qualidade vem do plano, não do modelo |

**Dois papéis em Opus custam mais.** É deliberado: são os dois que produzem especificação que os outros executam — plano raso e tela mal especificada custam a Task inteira. Projeto **sem interface** (biblioteca, serviço, CLI) pode dispensar o UX; projeto sem base de código legada pode dispensar o QA no começo. Projeto com mais de uma frente independente justifica um segundo dev — nesse caso, reative as regras de faixas descritas em [`roles/scrum-master/process/workflow.md`](roles/scrum-master/process/workflow.md) §7.

Os princípios de engenharia de **nível 1** ([`standards/implementation-principles.md`](standards/implementation-principles.md)) são agnósticos de linguagem e plataforma — não mudam entre projetos. Só o **perfil de stack de nível 2** (os guias `implementation-guide` / `implementation-quality`, hoje calibrados para .NET/GitLab) é substituído quando a stack do novo projeto é outra — é o único ponto do plugin que pode precisar de troca, feita pelo Arquiteto via `/review`, num clone do repositório-fonte do plugin.

## Passo 5 — Semear o backlog inicial

O time só arranca com uma **lista de Tasks com ID**:

- **Projeto existente** — rode `/qa audit` e `/qa baseline` primeiro. O resultado (pendências com evidência + números reais de build/teste) vira o backlog inicial.
- **Projeto novo** — `/po analyze <visão do produto>` para os primeiros requisitos, depois `/sm plan`.

## Passo 6 — Primeira rodada de validação

Nesta ordem, para confirmar que o time está calibrado antes de confiar nele:

```
/qa baseline          → os números declarados batem com a realidade?
/sm status            → o status sai em 6 linhas, com ID e evidência?
/arc plan <ID>       → o plano é executável por um júnior sem decidir nada?
/team cycle <ID>      → o ciclo fecha com veredito e evidência real?
```

Se o primeiro plano do Arquiteto precisar de mais de dois 🔺 GAPs para ser executado, o problema não é o time — é o `context.md` do Arquiteto, que está raso. É a métrica mais barata de saúde da instalação.

## Checklist de replicação

- [ ] `claude plugin marketplace list` mostra o `team` declarado nas **settings do projeto**, não nas do usuário
- [ ] Plugin instalado (`claude plugin list` mostra `team@team` habilitado — exibição duplicada é ruído, não instalação dupla)
- [ ] `claude plugin details team@team` lista os 8 comandos (`sm` `po` `arc` `ux` `dev` `qa` `team` `review`) e os 6 agents
- [ ] Sessão reiniciada; `/plugin` mostra `team@team` **enabled** e `/help` lista os 8 comandos e os 6 agentes
- [ ] `/team init` executado; `.team-project/README.md` escrito, com stack, fontes da verdade, comandos e limitações
- [ ] Os seis `context.md` escritos, com as armadilhas do projeto
- [ ] Índice do SDD e documento de escopo criados a partir de `deliverables/`; demais conforme a necessidade
- [ ] Em projeto retomado: `pending.md` produzido por `/qa audit` antes de qualquer planejamento
- [ ] Backlog inicial semeado com IDs
- [ ] `/qa baseline` executado e registrado em `.team-project/quality-assurance/evidence.md`
- [ ] Primeiro `/team cycle` fechado com veredito ✅
