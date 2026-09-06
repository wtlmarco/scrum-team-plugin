# Changelog do Processo

> **DOCUMENTO VIVO** · **Dono:** SM · Alimentado por `/sm review`
> Modelo da entrada: [`../templates/process-change.md`](../templates/process-change.md)

Registro de como o **processo de trabalho do time** evoluiu — o quê, quando, por quê e a pedido de quem. Cumulativo, mais recente no topo. Entrada antiga nunca é reescrita: reversão vira entrada nova, citando a que reverte.

Este documento viaja com o time na replicação: é a memória de por que cada regra existe, e o que impede alguém de desfazer uma regra por achá-la burocracia.

**Teto de leitura.** Este arquivo mantém as **três entradas mais recentes**. As anteriores vivem, íntegras e sem uma vírgula alterada, em [`process-changelog-archive.md`](process-changelog-archive.md) — arquivar é **relocar, não reescrever**. O índice abaixo é o caminho para elas. Quem precisa de uma entrada arquivada abre o arquivo; quem só precisa do estado atual não paga por ela.

## Versões arquivadas

| Versão | O que mudou |
|---|---|
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

## v2.4 — Aderência ao plano × aderência ao standard: `/arc comply` e a frente 2 do QA verificam objetos diferentes — 06/09/2026

**Instrução:** *(roteada pelo QA, `/qa review` v2.2, para decisão de fluxo do SM)* "decidir a divisão de trabalho entre `/arc comply` e `/qa <ID>` na verificação de aderência à seção de standard citada no plano." **Decisão do stakeholder: Opção C — não é duplicação, é sobreposição mal definida.** `/arc comply` afere **plano → código** (o autor conferindo a execução da sua instrução); a frente 2 afere **standard → código** e a **completude do plano ante o item** (o plano omitiu uma seção obrigatória ou citou a errada). A interseção — seção citada aplicada no código — o QA reverifica de forma independente por ser o gate ao stakeholder.
**Classificação:** fluxo (posicionamento do `/arc comply` e objeto de cada verificação de aderência) + formato de documento (linha de gate em `workflow.md`, linha de conflito em `artifact-ownership.md`).
**Registrada por:** SM, via `/sm review`. **Escopo fechado.** *(Deliberação e reavaliação do conjunto na resposta do `review`, não aqui — R17.)*

### O que mudou
| Documento | Mudança |
|---|---|
| `process/workflow.md` | **§4a nova** — "Aderência: `/arc comply` e a frente 2 do QA verificam objetos diferentes": o `/arc comply` **não é etapa do ciclo**, é revisão sob demanda em dois momentos (proativa antes do QA · rota de volta de achado de aderência ⚠️/❌ antes do `/dev resume`); tabela objeto × pergunta; critério verificável de que o veredito da frente 2 traz "seção exigida pelo item × seção citada" com quatro estados. §8 — gate novo: "seção de standard exigida pelo item presente no plano e aplicada no código · veredito · QA · R16 · §4a" |
| `process/artifact-ownership.md` | §3 — linha nova em "Conflitos comuns": frente 2 que parece repetir o `/arc comply` → checar o que o comply não vê (plano omitiu/errou a seção que o item exigia), ponteiro a `workflow.md` §4a |

### Por quê (modo de falha evitado)
A frente 2 do QA (v2.2) e `compliance-review.md:29` checavam ambos "seção de standard citada aplicada de fato" — trabalho e tokens potencialmente duplicados, e a frente 2 carregava nota provisória "pendente do SM". Sem a separação de objeto: ou o QA repete a revisão do Arquiteto (custo sem ganho), ou abandona a frente por parecer redundante — e aí ninguém pega o defeito que o autor do plano **estruturalmente não vê**: a seção obrigatória omitida ou a citada errada. O processo também se contradizia sobre quando o comply roda (`architect/README.md:51` "antes do QA" × `commands/qa.md:30` comply como remediação pós-QA) e `workflow.md` era silencioso.

### Resolução da contradição de fluxo
`/arc comply` **fora do ciclo**, sob demanda, nos dois momentos (antes do QA por iniciativa do Arquiteto · rota de volta de achado de aderência). **Não vira etapa formal** entre dev e QA — isso adicionaria uma invocação de agente por item, e a Opção C torna a frente 2 independente do comply de qualquer forma. `workflow.md` §4a é a fonte; os textos "antes do QA" em `architect/README.md:51` e `compliance-review.md:1` são roteados ao `/arc review`. Sem mudança de custo por item.

### Quem passa a ser cobrado de forma diferente
| Papel | O que muda |
|---|---|
| QA | Frente 2 nomeia, por área de engenharia do item, a seção **exigida** × a seção **citada**; omissão ou erro de citação = achado de processo ao `/arc review`, não achado de código; a interseção é reverificada, não delegada ao comply |
| Arquiteto | `/arc comply` declarado sob demanda, não etapa de ciclo; o comply responde só pela **aplicação** do que citou, não pela completude da citação |
| SM | Verifica que o veredito da frente 2 traz a coluna "seção exigida × citada"; veredito que só replica a tabela do comply = achado de processo |

### Conflitos com o processo vigente
- **`architect/README.md:51` / `compliance-review.md:1` "antes do QA" × `commands/qa.md:30` comply como remediação pós-QA.** Resolvido: comply é sob demanda nos dois momentos; `workflow.md` §4a é a fonte; edições de texto roteadas ao `/arc review`.
- Nenhum conflito com R16 — a frente 2 já era consumo obrigatório; §4a só define o objeto. Nenhuma regra nova (R18 avaliada e descartada — ver resposta do `review`).

### Como saberemos que funcionou
- Todo veredito de frente 2 do período traz a coluna "seção exigida pelo item × seção citada"; ausência = achado de processo.
- Nenhum veredito de frente 2 que apenas reproduz a tabela passo × conforme do `/arc comply`.
- Ao menos um achado de "seção obrigatória omitida do plano" ou "seção citada errada" roteado ao `/arc review` em até 3 ciclos que toquem engenharia — sinal de que a frente pega o que o comply não vê. Zero em 6 ciclos com itens de engenharia → §4a encolhe para nota e a frente 2 volta a confiar no comply.
- **Footprint (§5c):** `/sm` (`agents/scrum-master.md` + `commands/sm.md`) = 11,3 KB · `roles/scrum-master/` = 119,3 KB ativo (+ 90,2 KB de `process-changelog-archive.md`, frio). Total do papel = 130,6 KB. Esta rodada: `workflow.md` 20,6 → 23,1 KB (+2,5); `artifact-ownership.md` 8,3 → 8,6 KB (+0,3); `process-changelog.md` +7,8 KB (entrada v2.4). Primeira medição do footprint do SM pós-v2.0 — sem valor anterior para Δ. **Remoção candidata p/ a próxima `review metrics`:** os dois parágrafos finais de `workflow.md` §5a ("O que o SM pergunta primeiro..." / "O que o SM escala...") reafirmam a tabela de passos e a §6 — colapsáveis a ponteiro, ~0,6 KB. Não removido agora — escopo fechado.

### Roteamentos
| Achado | Para quem |
|---|---|
| `compliance-review.md:29` e §2 do template não delimitam que o comply afere só a **aplicação** do que o plano citou; `compliance-review.md:1` e o título `architect/README.md:51` dizem "antes do QA" — refletir o posicionamento sob demanda de `workflow.md` §4a | **`/arc review`** — instrução pronta na resposta do `review` |
| Nota provisória da frente 2 (`quality-assurance/README.md:23`) "pendente de decisão do SM — changelog v2.2" — trocar pela redação final da Opção C (objeto da frente 2, quatro estados, coluna "seção exigida × citada" no `verdict.md`, ajuste em `skills.md` §9) | **`/qa review`** — instrução pronta na resposta do `review` |
| *(carona, roteamento pendente do PO — v2.3)* `deliverables/sdd/03-architecture.md` §2b diz "A tabela **V1–V17**" e não reflete V18–V21 | **`/arc review`** — mesma instrução da v2.3 |
| Com a v2.4, o changelog vivo passa de 3 entradas | **stakeholder** — arquivar a v2.1; não toquei no arquivamento (R17) |

### Pendente do stakeholder
- **`commands/qa.md:30`, `commands/arc.md:16`, `commands/team.md` (passo 6 do `cycle`):** propostas de uma linha cada, texto pronto na resposta do `review`, para alinhar a linguagem do comply ("sob demanda", rota de achado de aderência). Não obrigatórias; vigoram só após reiniciar a sessão.
- **Confirmar** que `/arc comply` permanece **fora do ciclo** (resolução do SM) — ou, se quiser o comply como etapa formal entre dev e QA, isso adiciona uma invocação de agente por item e precisa do seu aval.

---
