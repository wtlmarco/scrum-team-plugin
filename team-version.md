# `/team version` — que versão do time está rodando aqui

> Lido **apenas quando `/team` entra no modo `version`**. Fica fora de `commands/team.md` pelo mesmo motivo de `init` e `update`: aquele arquivo é injetado no prompt em *toda* invocação de `/team`, e esta resposta é pedida raramente.

Modo **meta**, como `init` e `update`: fala sobre a instalação do time no projeto, não sobre o produto que o time constrói. Por isso não colide com a regra de que `/team` não é canal de conversa — não há pergunta de produto aqui, e **nenhum agente é disparado**.

**Este modo não usa rede.** Ele lê o que está instalado e responde. A pergunta "existe versão mais nova?" é do `/team update`, que consulta a origem — e é a única que paga rede. Separar as duas mantém esta barata o bastante para ser feita sem pensar.

## 1. Onde estamos

Se `${CLAUDE_PLUGIN_ROOT}/.git/` existir, este é o **repositório-fonte** — diga isso em uma linha, porque ali a versão de `plugin.json` é a que está sendo escrita, não a que algum projeto consome. Caso contrário é uma **cópia instalada**, e a versão é a que está de fato em vigor neste projeto.

## 2. As quatro respostas

Leia `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json` (campo `version`) e `${CLAUDE_PLUGIN_ROOT}/CHANGELOG.md` — **só a entrada da versão instalada**, não o arquivo inteiro. Responda nesta ordem, sem preâmbulo:

**a) Versão** — `vX.Y.Z`, e se é fonte ou cópia instalada.

**b) O que esta versão trouxe** — até 5 linhas, da entrada do CHANGELOG. Priorize, nesta ordem: o que **quebrou compatibilidade**, o que **mudou de dono**, o que é **comando novo ou removido**. Melhoria interna que não muda o que o stakeholder digita fica de fora.

**c) Guia rápido** — a tabela de comandos e modos. Não a reproduza de memória: a fonte é `${CLAUDE_PLUGIN_ROOT}/how-to.md` §"Os comandos". Marque com `*` os modos que entraram nesta versão.

**d) O que o time custa** — a carga fixa por comando, de `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/workflow.md` §5c. Diga junto as duas coisas que a tabela não mostra e que costumam dominar o custo real: **o modelo de cada agente** (`/arc` e `/ux` em Opus, `/dev` em Haiku — `/arc` carrega menos KB que `/sm` e custa mais) e a **leitura em tempo de execução**, que costuma superar a carga fixa. Número de carga fixa apresentado sozinho subestima a conta, e quem lê passa a otimizar a coisa errada.

## 3. Feche

Uma linha dizendo que **`/team update` é quem verifica se há versão mais nova** — este modo não olha a origem e por isso **nunca** afirma que a instalação está atualizada.

Se a versão instalada for anterior à do `CHANGELOG.md` que você acabou de ler (acontece no repositório-fonte, entre o bump e a publicação), diga qual é qual em vez de escolher uma.
