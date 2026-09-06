# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/sm review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
| [`v2.4`](process-changelog-archive.md) | Aderência ao plano × aderência ao standard: `/arc comply` e a frente 2 do QA verificam objetos diferentes — 06/09/2026 |
| [`v2.3`](process-changelog-archive.md) | PO ganha a forma completa do RNF de performance e a cadeia RNF → V18 → veredito — 06/09/2026 |
| [`v2.2`](process-changelog-archive.md) | QA alinhado a R16 e ganha a frente de desempenho; veredito endereçado ao stakeholder — 06/09/2026 |
| [`v2.1`](process-changelog-archive.md) | PERF-TEST fechada: desempenho vira obrigação verificável nos dois níveis do `standards/` — 06/09/2026 |
| [`v2.0`](process-changelog-archive.md) | Changelog arquivado, contrato do `review` extraído, ciclo de eficiência PDCA e teto por entrada (R17) — 06/09/2026 |
| [`v1.9`](process-changelog-archive.md) | Arquiteto e dev revistos à luz de `.team/standards/` como base compartilhada; GAP de tipo `standard` ganha forma — 05/09/2026 |
| [`v1.8`](process-changelog-archive.md) | `standards/` promovido a diretório de primeiro nível e reclassificado como base de qualidade compartilhada (R16) — 05/09/2026 |
| [`v1.7`](process-changelog-archive.md) | Onboarding do projeto (R14) e brainstorm de descoberta funcional (R15) — 05/09/2026 |
| [`v1.6`](process-changelog-archive.md) | UX com repertório de padrões consolidados e método de pesquisa acionável por gatilho — 02/09/2026 |
| [`v1.5`](process-changelog-archive.md) | SM com repertório de PMBOK e APF acionável por gatilho, sobre a base Scrum — 02/09/2026 |
| [`v1.4`](process-changelog-archive.md) | Standards em dois níveis: princípios agnósticos de linguagem (Clean Architecture · Clean Code · CQRS · cobertura 80%) — 02/09/2026 |
| [`v1.3`](process-changelog-archive.md) | Reavaliação obrigatória no `review`, e os documentos do dev passam ao Arquiteto — 02/09/2026 |
| [`v1.2`](process-changelog-archive.md) | Evolução do processo distribuída por papel — 02/09/2026 |
| [`v1.1`](process-changelog-archive.md) | Comando de evolução do processo — 02/09/2026 · *(substituída pela v1.2)* |
| [`v1.0`](process-changelog-archive.md) | Linha de base do time — 01–02/09/2026 |

---

## v2.7 — Faxina pós-isolamento em plugin: resíduo de caminho, contagens do UX e extração dos modos frios — 06/09/2026

**Instrução:** *(stakeholder, direta)* "agora que isolamos em um plugin, revise tudo para remover redundância, validar links e relações entre os arquivos e otimizar o processo para menor consumo de tokens."
**Classificação:** formato de documento (caminhos e contagens obsoletos) + comportamento de agente (`agents/*` e `commands/*` compactados) — aplicada pelo **stakeholder**, não por um `review` de papel.
**Registrada por:** stakeholder. **Escopo fechado — uma faxina, sem mudança de regra, fluxo ou propriedade.**

### O que mudou
| Documento | Mudança |
|---|---|
| `.claude-plugin/plugin.json` · `marketplace.json` | Descrições listavam 5 papéis — **UX ausente**. Corrigido nos dois manifestos |
| `process/artifact-ownership.md` | §1 — **linha duplicada removida** (`roles/<papel>/README.md, skills.md, templates/` aparecia 2×, com regras diferentes); prefixos `team/roles/…` → `${CLAUDE_PLUGIN_ROOT}/roles/…` e `team-project/` → `.team-project/` (6 linhas) |
| `standards/README.md` · `deliverables/README.md` · `roles/{architect,developer,quality-assurance,scrum-master}/README.md` | Resíduo `.team/standards/` → `standards/` e "diretório de primeiro nível de `.team/`" → "do plugin" (25 ocorrências). O repositório **é** o plugin desde a v2.0; o prefixo `.team/` descrevia a estrutura anterior |
| `agents/{product-owner,architect,user-experience,quality-assurance,scrum-master}.md` | Bloco "Evolução dos seus documentos (`review`)" — 3–4 parágrafos reproduzindo `review-contract.md` — **colapsado em ponteiro + alcance do papel**. O mesmo movimento que a v2.0 fez nos `commands/`, agora nos `agents/` |
| `agents/developer.md` · `commands/dev.md` | A justificativa de por que o dev não tem `review` estava **inteira nos dois**; fica o essencial em cada um, com o racional em `artifact-ownership.md` §1 |
| `commands/team.md` | Modo `init` (32 linhas) extraído para **`team-init.md`** — roda uma vez por projeto e pagava contexto em toda invocação de `/team`. Modo `brainstorm` colapsado em despacho + ponteiro para `workflow.md` §5b, que já continha o ritual completo |
| `team-init.md` | **Novo** — ritual do `/team init`, lido só nesse modo |
| `commands/team.md` · `commands/sm.md` · `process/workflow.md` · `scrum-master/{README,skills}.md` | Contagens obsoletas da entrada do UX: "cinco agentes/respondem" → **seis** no broadcast; e o onboarding §5a se contradizia — passo 4 dizia "os outros cinco papéis / Cinco leituras", a checklist de saída e três outros documentos diziam "seis". Unificado em **cinco leituras** (PO · Arquiteto · UX · dev · QA); o SM coordena e consolida, não escreve uma sobre si |
| `README.md` | Índice de estrutura não listava `how-to.md`, `review-contract.md`, `note.md` — nem o novo `team-init.md` |
| `process/process-changelog.md` | v2.4 arquivada (teto de 3 entradas, R17) — pendência aberta desde a v2.5 |

### Por quê (modo de falha evitado)
Dois modos, ambos já observados neste changelog. **Obsolescência silenciosa:** a v2.0 isolou o time num plugin, mas os caminhos `.team/` e `team/roles/` continuaram escritos em 6 roteiros — um agente que os siga procura um diretório que não existe, e o `review audit` os lê como se fossem verdade. Os manifestos omitindo o UX são a mesma falha na porta de entrada: quem instala o plugin lê que o time tem cinco papéis. **Custo fixo por invocação:** o contrato do `review` foi extraído dos `commands/` na v2.0 exatamente porque era injetado em toda invocação — mas ficou intacto nos `agents/`, onde tem o mesmo custo e a mesma raridade de uso; e o `init`, que roda **uma vez na vida do projeto**, era carregado em todo `/team`.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Todos com `review` | O contrato não está mais no corpo do agente: **ler `review-contract.md` ao entrar no modo** deixa de ser redundância e passa a ser obrigatório. O alcance do papel continua declarado no agente e no comando |
| SM (onboarding) | A entrega são **cinco** leituras de entrada, não seis. O SM coordena e consolida |
| `/team init` | Lê `team-init.md` antes de criar o `.team-project/` |
| Nenhum | Nenhuma regra (R1–R17), gate, DoR/DoD ou matriz de propriedade mudou de conteúdo |

### Conflitos com o processo vigente
Nenhum. Nenhuma regra nova, nenhuma removida. A contradição interna do onboarding (cinco × seis leituras) foi **resolvida em favor do passo 4 de `workflow.md` §5a**, que já nomeava os cinco papéis explicitamente — a checklist e os três documentos derivados é que estavam errados.

### Como saberemos que funcionou
- **Footprint (§5c) — carga fixa por invocação (`agents/<papel>.md` + `commands/<cmd>.md`), antes → depois:** `/sm` 11,5 → 10,7 KB · `/po` 8,7 → 7,6 · `/arc` 12,8 → 11,7 · `/ux` 9,4 → 8,5 · `/dev` 7,6 → 6,6 · `/qa` 11,6 → 10,7 · `/team` 13,1 → 8,7. **Total 74,7 → 64,5 KB (−10,2 KB, −14%);** `/team` sozinho −33%. Movido para leitura sob demanda: `team-init.md` 3,2 KB. Primeira redução líquida registrada desde a v2.0.
- `grep -r '\.team/' --exclude='*changelog*'` retorna **zero** — e volta a zero em toda `review audit`.
- Validação mecânica de links: **0 links relativos quebrados, 0 refs `${CLAUDE_PLUGIN_ROOT}` quebradas** (era 1 e 0). Repetir a cada `review audit`.
- `claude plugin details team@team` continua listando **7 comandos e 6 agents**.
- Se em 3 ciclos algum papel executar `review` sem os quatro passos, o ponteiro para `review-contract.md` não bastou e o contrato volta, resumido, ao corpo do agente.

### Pendente do stakeholder
- **Reiniciar a sessão** — mudança em `agents/` e `commands/` só entra em vigor no próximo carregamento.
- `note.md` continua com o item aberto "revise"; esta faxina o consome parcialmente. O que sobra e não foi tocado: a duplicação dos "Princípios inegociáveis" entre `agents/architect.md` e `roles/architect/README.md` — mantida de propósito (o agente é caminho quente, o roteiro é referência), mas é candidata a remoção numa `review metrics`.
- **Pendências herdadas, não tocadas aqui** (continuam roteadas): `agents/architect.md:33` "antes do QA" → `/arc review` (v2.5); `compliance-review.md:29` e `deliverables/sdd/03-architecture.md` §2b "V1–V17" → `/arc review` (v2.3/v2.4).

---

## v2.6 — QA frente 2 ganha a redação final: objeto próprio e o terceiro achado de processo — 06/09/2026

**Instrução:** *(roteada pelo SM ao QA, `/qa review` da v2.4)* substituir a nota provisória da frente 2 (`quality-assurance/README.md:23`) pela redação final da Opção C — objeto = normativo `.team/standards/` + completude do plano ante o item, quatro estados por área de engenharia, interseção reverificada; dar ao `verdict.md` a coluna "seção exigida × citada"; acrescentar a `skills.md` §9 o terceiro caso (plano que omitiu/errou a seção exigida = achado de processo) com o método de reconhecimento.
**Classificação:** formato de documento (roteiro do QA + template de veredito + skills), sob a decisão de fluxo da v2.4 (`workflow.md` §4a).
**Registrada por:** QA, via `/qa review`. **Escopo fechado — um assunto.** *(Deliberação na resposta do `review` — R17.)*

### O que mudou
| Documento | Mudança |
|---|---|
| `roles/quality-assurance/README.md` | Frente 2: nota provisória → parágrafo **"Objeto desta frente"** (normativo + completude do plano, não reexecução do `/arc comply`); lista dos **quatro estados** (citada e aplicada · citada e divergente = reprovação R16 · exigida e ausente / citada errada = processo → `/arc review`); parágrafo da **reverificação independente da interseção**, analogia da frente 3 — não depende de o comply ter rodado |
| `templates/verdict.md` | Linha "Especificação técnica" remete à nova sub-tabela **"Frente 2 — seção exigida pelo item × seção citada no plano"** (área de engenharia · seção exigida · seção citada · estado · volta para) + nota da reverificação. Regra estendida: **dois** achados tipo `processo` a `/arc review` sem virar GAP — defeito de standard **e** omissão/citação errada |
| `skills.md` §9 | **Terceiro caso**: método de reconhecimento em 4 passos (áreas de engenharia do item pelo aceite+diff → seção que governa cada uma → confronto com o citado → sinal de alerta), distinção dos outros dois casos, rota `/arc review` sem GAP |

### Por quê (modo de falha evitado)
A nota provisória deixava a frente 2 sem objeto próprio desde a v2.2: o QA ou repetia a tabela passo × conforme do `/arc comply` (o teste da v2.4 marca isso como achado de processo contra o veredito), ou abandonava a frente por redundância aparente. Nos dois casos ninguém pega o defeito que o autor do plano **estruturalmente não vê** — a seção que o item exigia e o plano omitiu, ou a que citou errada. O terceiro caso do §9 faltava por ser o mais difícil (exige a régua do item, não a leitura do plano); sem método escrito, não seria aplicado.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| QA | Frente 2 sempre com a sub-tabela "seção exigida × citada" e os quatro estados; interseção reverificada, não delegada ao comply; omissão/citação errada = achado de processo, não de código |
| SM | Verifica a presença da sub-tabela; veredito de frente 2 que só replica a tabela do comply = achado de processo (teste da v2.4, agora com o modelo que o torna natural de cumprir) |

### Conflitos com o processo vigente
Nenhum. A v2.4 decidiu a Opção C e o posicionamento do comply; a v2.5 escreveu a contraparte do Arquiteto. Esta entrada materializa o lado do QA. `.team/standards/` não tocado (R16). A tabela de README "Eu valido contra `.team/standards/`" e a Regra do `verdict.md` já roteavam "seção não citada → achado de processo"; ficaram coerentes.

### Como saberemos que funcionou
- Todo veredito de frente 2 traz a sub-tabela "seção exigida × citada" com um dos quatro estados por linha; ausência = achado de processo do SM.
- Nenhum veredito de frente 2 que só reproduz a tabela passo × conforme do `/arc comply`.
- Ao menos um achado "seção exigida e ausente do plano" ou "citada errada" ao `/arc review` em até 3 ciclos de engenharia (indicador da v2.4). Zero em 6 → a frente 2 encolhe para nota e volta a confiar no comply.
- **Footprint (§5c):** `/qa` carga fixa = 11,5 KB (`agents/quality-assurance.md` 7,7 + `commands/qa.md` 3,8), **inalterado**. `roles/quality-assurance/` = 28,4 → 32,1 KB (+3,7 / +13,0%, dentro do teto de 20%): README 10,2→11,0, skills 6,6→8,4, verdict 2,8→3,8. Primeira medição do conjunto do QA pós-v2.0 — sem Δ anterior. **Remoção candidata (mantida da v2.2):** `skills.md` §7 (auditoria cruzada em dois passes, ~0,9 KB — repete `templates/cross-audit.md` + README `/qa audit`) e §8 (linha de base, ~0,5 KB — repete README `/qa baseline`). Seguem válidas; não removidas — escopo fechado.

### Pendente do stakeholder
- Nada novo em `agents/` ou `commands/`. `commands/qa.md:30` (comply "como remediação pós-QA") já tem ajuste proposto na v2.4 — não reaberto aqui.
- Changelog vivo agora com 5 entradas (teto 3): arquivamento de v2.1 e v2.2 segue pendente do stakeholder (v2.4/v2.5). Não toquei no arquivamento (R17).

---

## v2.5 — Obsolescência corrigida nos documentos do Arquiteto: comply sob demanda e Ficha até V21 — 06/09/2026

**Instrução:** *(stakeholder, escopo fechado — quatro itens)* posicionar o comply como revisão **sob demanda**, fora do ciclo, em `compliance-review.md:1` e no título `architect/README.md:51`; **delimitar** (linha 29, cabeçalho da §2 e Regras) que ele afere só a **aplicação** do que o plano citou, não a completude da citação — esta é da frente 2 do QA (`workflow.md` §4a); e atualizar `deliverables/sdd/03-architecture.md` §2b de "V1–V17" para **V1–V21**, registrando que a Ficha **transcreve, não origina** o número *(item roteado pelo PO, v2.3)*.
**Classificação:** formato de documento (modelo de saída do comply + modelo de entregável SDD-03) + fluxo (posicionamento do comply refletido onde ele é lido).
**Registrada por:** Arquiteto, via `/arc review`. **Escopo fechado — rodada de correção de obsolescência.** *(Deliberação na resposta do `review`, não aqui — R17.)*

### O que mudou
| Documento | Mudança |
|---|---|
| `roles/architect/templates/compliance-review.md` | Cabeçalho reescrito: sob demanda, **não é etapa do ciclo**, os dois momentos (a) iniciativa antes do QA / (b) rota de volta de achado ⚠️/❌ antes do `/dev resume`; parágrafo **"Objeto: o Plano de Execução vigente"** com a exclusão explícita da completude da citação. Nota de escopo sob o cabeçalho da §2; linha 29 reescrita para "seção **citada pelo passo** aplicada de fato — *só a aplicação do que o plano citou*". Regra nova: omissão ou citação errada é da frente 2 e vira 🔺 GAP na seção 5, nunca linha da §2. Veredito da §4 ganha a forma da rota (b) |
| `roles/architect/README.md` | Título §`/arc comply` de "antes do QA" → **"sob demanda, fora do ciclo"**; corpo ganha os dois momentos e a fronteira com a frente 2 |
| `deliverables/sdd/03-architecture.md` | §2b: **V1–V17 → V1–V21**, com os campos de V18–V21 (operações sob orçamento · comando de carga por unidade · margem de ruído medida · ambiente e baseline) e o parágrafo **"V18 transcreve, não origina, o número"** (origem = RNF de `01-requirements.md`, cinco campos de P1). Regra de pré-requisito ganha "Ficha com V18–V21 ausentes é ficha incompleta" (§7 #22). Falha comum nova: linha de V18 sem RNF de origem |

### Por quê (modo de falha evitado)
Documento obsoleto não é ruído neutro. "Antes do QA" reintroduz o comply como etapa obrigatória — a invocação de agente por item que o stakeholder recusou; a linha 29 sem delimitação faz o QA concluir que a frente 2 é redundante e abandoná-la, deixando sem dono o defeito que o autor do plano não vê. "V1–V17" faz a Ficha ser dada como completa sem V18–V21: o projeto entra em construção com desempenho nem medido nem declarado "não exercitado" — o estado que §5.6 proíbe. E sem "transcreve, não origina", o Arquiteto inventa limiar na Ficha, quebrando a cadeia PO → V18 → veredito da v2.3.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| Arquiteto | Roda comply por decisão sua, não por etapa; citação omitida não vira linha de tabela — vira 🔺 GAP. Ao preencher §2b, cobre V18–V21 e aponta o RNF de origem de cada linha de V18 |
| Dev · QA | Nada muda no que executam; o modelo do Arquiteto passa a **confirmar** por escrito que a completude da citação é da frente 2 |

### Conflitos com o processo vigente
Nenhum. `commands/arc.md:16` e `commands/team.md` passo 6 já traziam a delimitação (v2.4) e ficaram coerentes com estes textos. `standards/implementation-principles.md:382` ("Ajuste antes do QA") é coluna de **consequência** do achado, não de momento — sem conflito. `.team/standards/` não foi tocado.

### Como saberemos que funcionou
- Nenhum `/arc comply` do período traz linha de §2 acusando "seção obrigatória omitida do plano" (omissão vai à seção 5 como 🔺 GAP), e toda ocorrência declara qual dos dois momentos a motivou.
- Próximo projeto que preencher a §2b entrega V18–V21 no primeiro passe, cada linha de V18 com o RNF de origem citado. Ficha em V1–V17 de novo em até 2 projetos → o modelo não está sendo lido, e a Ficha vira checklist de gate no `execution-plan.md`.
- **Footprint (§5c):** `/arc` = 12,2 KB (`agents/architect.md` 8,0 + `commands/arc.md` 4,2) · `roles/architect/` = 34,7 KB (+0,3, todo em `compliance-review.md` 4,2 → 4,5). `.team/standards/` (dono editorial) = 135,5 KB, **inalterado**. `deliverables/sdd/03-architecture.md` 4,3 → 5,0 KB. **Remoção candidata:** `architect/README.md` §"Dono editorial de `.team/standards/`" (~1,4 KB), que repete `standards/README.md` — colapsável a ponteiro. Não removido: escopo fechado.

### Pendente do stakeholder
- **`agents/architect.md:33`** — "revisar o que voltou do dev contra o padrão **antes do QA**" é o último texto obsoleto e está fora da minha caneta. Substituição proposta: *"**Aderência** — sob demanda, revisar o que voltou do dev contra o plano e o padrão: cada passo como escrito e a seção de standard que o passo citou aplicada de fato (`workflow.md` §4a)."* Não obrigatória; vigora só após reiniciar a sessão.
- Com a v2.5 o changelog vivo fica com **4 entradas** (teto = 3): arquivar a v2.1 continua pendente da v2.4. Não toquei no arquivamento (R17).

---
