# Template — Protótipo Funcional (`/ux prototype`)

> **Dono:** UX · **Entregável** — critérios completos em [`deliverables/prototype/README.md`](../../../deliverables/prototype/README.md)
> **Pré-condição do portão ①**: o stakeholder navega o protótipo antes de aprovar o SDD funcional.

## Estrutura de arquivos

```
.team-project/user-experience/prototype/
├── index.html          ← ponto de entrada único: índice dos fluxos + o que está fora
├── README.md           ← esta ficha, preenchida
├── verification-log.md ← checkpoint da verificação: append-only, uma linha por tela/fluxo
├── flows/
│   ├── <fluxo-1>.html
│   └── <fluxo-2>.html
└── assets/
    └── style.css       ← um arquivo só; sem build, sem dependência externa
```

**Sem build, sem servidor, sem back-end.** Abre com duplo clique. Se precisar de `npm`, `docker` ou terminal, está grande demais para um protótipo.

## Ficha do protótipo (`prototype/README.md`)

```markdown
# Protótipo Funcional — <produto / fatia> — v<n>

**Dono:** UX · **Atualizado em:** <data> · **Estado:** <em elaboração | navegado | aprovado no ① | vencido>
**Cobre a fatia:** <qual — a mesma que o SDD funcional descreve>

## Como abrir
Abrir `index.html` no navegador. Nada mais.

## Fluxos cobertos
| Fluxo (de `02-flows-and-roles`) | Ator | Arquivo | Caminho completo? | Estados de exceção |
|---|---|---|---|---|
| <nome do fluxo> | <ator> | `flows/<arquivo>.html` | ✅ / parcial: <o que falta> | vazio ✅ · erro ✅ · sem permissão ✅ |

## Requisitos da fatia representados
| RF | Aparece no protótipo? | Onde |
|---|---|---|
| RF-<nnn> | ✅ / ❌ (está em "fora") | <fluxo/tela> |

## O que está FORA deste protótipo
<Escrito também na própria `index.html`. É o que evita aprovar por engano
algo que o stakeholder supôs incluído.>

- <o que não está representado, e por quê>

## Premissas que o protótipo assume
<Coisas que o protótipo mostra de um jeito e ainda não estão decididas —
para o stakeholder não confundir escolha com decisão.>

| Premissa | Se mudar, o que muda no protótipo |
|---|---|

## Registro de verificação (harness)
**Modo desta rodada:** <completo | leve> · **Por quê:** <primeira entrega | mudança transversal
| ajuste pontual em: <telas nomeadas>>
**Rodadas leves consecutivas desde a última completa:** <n de 3>
**Telas/fluxos executados nesta rodada:** <lista>
**O restante está coberto pela verificação completa de:** <data> · protótipo v<n>
**Checkpoint:** `verification-log.md` — <n> linhas · última em <data/hora>

## Registro do portão ①
**Navegado pelo stakeholder em:** <data>
**Divergências encontradas na navegação:** <lista, ou "nenhuma">
**Situação:** <aprovado | aprovado com ajuste no SDD funcional | devolvido>
```

## Checkpoint da verificação (`verification-log.md`)

Gravado **a cada tela ou fluxo concluído**, durante a execução — não ao final. É o que faz uma sessão cortada no meio custar o que faltava, e não tudo de novo (R5 aplicada à verificação, [`../skills.md` §10](../skills.md)).

```markdown
# Verificação do protótipo — registro append-only
| Data/hora | Protótipo | Rodada (modo) | Tela/fluxo | Critérios exercitados | Veredito | O que falhou |
|---|---|---|---|---|---|---|
| <aaaa-mm-dd hh:mm> | v<n> | <nº> (completo\|leve) | <tela/fluxo> | <critérios, nomeados> | ✅ \| ❌ | <ou "—"> |
```

**Nunca reescrever linha antiga.** Reexecução é linha nova. Na retomada, roda-se só o que **não tem linha** da versão corrente.

## Regras

- **É pré-condição do portão ①, não decoração.** SDD funcional não é aprovado sem protótipo navegado. Sem protótipo, o Arquiteto não começa o SDD técnico.
- **O stakeholder navega — não lê.** Print de tela, gravação e descrição não substituem a navegação. "Aprovado sem navegar" é violação, e o SM registra.
- **Dados plausíveis, sempre.** `lorem ipsum` e `campo1` escondem exatamente o que o protótipo existe para revelar: nome que estoura o campo, lista vazia, valor negativo, data no passado.
- **Estados de exceção dos fluxos principais são obrigatórios** — vazio, erro, sem permissão. É onde o entendimento funcional diverge, e é barato descobrir aqui.
- **Nenhuma decisão técnica.** Sem framework, sem contrato de API, sem modelo de dados. O protótipo mostra *o quê*; o *como* nasce no Plano de Implementação (R20).
- **Nada daqui vira produção.** Reaproveitar HTML de protótipo sem passar por plano é dívida técnica com origem nobre.
- **É documento vivo enquanto a fatia não fecha** (R12): mudança funcional aprovada que altere fluxo principal atualiza o protótipo no mesmo ciclo. Entregue e aceita a fatia, ele é marcado **vencido** — a verdade passa a ser o produto.
- **Fidelidade visual é secundária.** O ① aprova entendimento funcional. Discussão de identidade visual não bloqueia o portão; vira registro para o backlog.
- **Verificação se grava enquanto acontece.** Uma linha no `verification-log.md` por tela/fluxo concluído, durante a execução. Interrupção retoma do checkpoint; o que tem linha da versão corrente não roda de novo.
- **O escopo da verificação é declarado, não presumido (R23).** Primeira entrega e mudança transversal (paleta, tipografia, grade, componente compartilhado, navegação) exigem harness **completo**; ajuste pontual sobre protótipo já verificado roda **leve** — telas alteradas mais a vizinhança de um salto. Modo leve reduz o que é executado, nunca a execução real: tela do escopo sem saída é **não exercitada** (R7). Três rodadas leves seguidas esgotam o modo — a quarta é completa.

## Falhas comuns

| Falha | Consequência |
|---|---|
| Protótipo que só cobre o caminho feliz | O portão ① aprova um entendimento que quebra no primeiro caso de borda |
| Protótipo bonito e incompleto | O stakeholder aprova a estética e o time entende que aprovou o fluxo |
| Protótipo que exige explicação para navegar | Não foi navegado — foi apresentado. São coisas diferentes |
| Protótipo com back-end "só para funcionar direito" | Deixou de ser descartável; agora há custo em jogá-lo fora, e ele vira produção por inércia |
| "Fora do escopo" só no `README.md`, não na página | Ninguém lê o README antes de navegar |
| Verificação inteira gravada só no fim | A sessão cortada no meio descarta tudo, e a retomada refaz da primeira tela |
| Modo leve numa mudança que toca todas as telas | Aprova-se o protótipo inteiro tendo exercitado duas telas — e a quebra aparece na navegação do stakeholder |
| Modo leve sem declarar o que **não** rodou | O leitor da ficha entende "tudo verificado"; a lacuna some sem nunca ter sido decidida |
