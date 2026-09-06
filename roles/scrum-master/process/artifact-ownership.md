# Propriedade de Artefatos — Quem escreve o quê

> **Dono:** SM · Cada arquivo tem **um único dono**. Quem não é dono lê, cita e pede alteração — nunca edita. É o que impede dois papéis de escreverem a mesma verdade em direções diferentes.

## 1. Matriz

Os caminhos concretos dos documentos do projeto estão em `.team-project/README.md` §4.

| Artefato | Dono | Regra |
|---|---|---|
| Código-fonte | dev | Só os arquivos listados no Plano de Execução vigente |
| Planos de Execução (`.team-project/architect/plans/`) | Arquiteto | Um plano por item, nome `<ID>-<slug>.md` |
| Arquitetura, modelo de dados, modelo de API (SDD) | Arquiteto | Grafia de entidades e endpoints é contrato — modelos em [`../../../deliverables/sdd/README.md`](../../../deliverables/sdd/README.md) |
| ADRs | Arquiteto | Decisão estrutural recorrente |
| `${CLAUDE_PLUGIN_ROOT}/standards/**` | **Arquiteto (dono editorial)** · dev e QA consumidores obrigatórios | Base de qualidade comum dos três (R16). Única caneta é do Arquiteto — muda só por `/review`. Agnóstico de produto — nunca ajustar para acomodar caso específico. Dev roteia defeito por 🔺 GAP, QA por achado de processo; os dois ao Arquiteto. Divergência de engenharia entre os três decide o Arquiteto; o que ultrapassa engenharia sobe ao stakeholder pelo SM |
| Mapas de jornada (`.team-project/user-experience/journeys/`) | UX | Um por objetivo do usuário |
| Especificações de tela (`.team-project/user-experience/screens/`) | UX | Os seis estados e os critérios de acessibilidade são obrigatórios |
| Protótipos | UX | Exploração, não código de produção |
| Objetivos, requisitos, fluxos, changelog funcional (SDD) | PO | Modelos e critérios em [`../../../deliverables/README.md`](../../../deliverables/README.md) |
| Escopo e critérios de sucesso | PO | Marcação exige evidência do QA — modelo em [`../../../deliverables/implementation/01-scope-and-criteria.md`](../../../deliverables/implementation/01-scope-and-criteria.md) |
| Product Backlog (`.team-project/product-owner/`) | PO | Priorizado por valor e risco funcional |
| Documento de status/progresso | SM | Memória de progresso e decisões — modelo em [`../../../deliverables/implementation/02-status.md`](../../../deliverables/implementation/02-status.md) |
| Quadro de trabalho (`.team-project/scrum-master/`) | SM | Sprint Backlog vivo |
| Registro de onboarding · brief de `brainstorm` | SM (**facilitação**) | Saída de `/sm onboarding` e `/team brainstorm` — registro do entendimento alinhado e do brief funcional. **Não substitui** a propriedade do PO sobre o requisito nem a divisão de autoria do SDD (PO: visão/requisitos/fluxos; Arquiteto: arquitetura/dados/API). Não vira arquivo permanente sem lugar declarado em `.team-project/` |
| `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/**` | SM | Processo — muda só a pedido do stakeholder, via `/review` (Agent `scrum-master`) |
| `${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/process-changelog.md` | SM (**curador**) | **Exceção à regra de dono único:** todo papel acrescenta a entrada da sua própria mudança de processo; o SM cura — consolida, aponta contradição e escala o que ficou inconsistente. Entrada nunca é reescrita |
| `${CLAUDE_PLUGIN_ROOT}/roles/<papel>/README.md`, `skills.md`, `templates/` | o próprio papel | Roteiro e modelos do papel — evoluem por `/review`, que roteia ao agente do papel dono, com registro no changelog do processo |
| `${CLAUDE_PLUGIN_ROOT}/roles/developer/**` | **Arquiteto** | **Exceção:** o dev não revisa os próprios normativos — roda no modelo mais simples do time, calibrado para executar plano, não para reescrever a regra que o governa. O Arquiteto revisa por `/review`, usando os 🔺 GAPs e as seções "Não fiz" dos relatórios como evidência |
| Contexto do projeto (`.team-project/**/context.md`) | SM, com aporte de cada papel | O papel dono do assunto propõe; o SM mantém a coerência |
| Mapa/inventário de código | QA | Uma linha por arquivo — modelo em [`../../../deliverables/implementation/03-code-map.md`](../../../deliverables/implementation/03-code-map.md) |
| Registro de GAPs abertos | QA | Levantado sobre código; vence a narrativa de status — modelo em [`../../../deliverables/implementation/pending.md`](../../../deliverables/implementation/pending.md) |
| Registro de evidências (`.team-project/quality-assurance/`) | QA | Comando, saída, veredito |
| `${CLAUDE_PLUGIN_ROOT}/agents/*`, `commands/*`, `.claude-plugin/*` | stakeholder | Composição e comportamento do time |
| `CHANGELOG.md` (raiz) — changelog de entregas | stakeholder | Registro das entregas versionadas do plugin (`vMAJOR.MINOR.PATCH`). O SM **reconcilia** no `/review`: toda entrada de `process-changelog.md` tem par aqui na mesma linha `vX.Y`; `version` de `.claude-plugin/plugin.json` == topo do `CHANGELOG.md` (R18 · [`workflow.md` §5d](workflow.md)) |
| Processo de lançamento — branch, PR, bump de `version`, `/team update` | stakeholder | Fecha a versão e corta a entrega. Roteiro em [`workflow.md` §5d](workflow.md); regra em R18. O SM verifica a rastreabilidade da entrega, não corta a release |

### 1a. `${CLAUDE_PLUGIN_ROOT}/standards/` — dono editorial único, consumo compartilhado (R16)

"Base compartilhada entre Arquiteto, dev e QA" **não afrouxa o invariante de dono único** — o dono *editorial* continua sendo um só, o Arquiteto, e a caneta muda só por `/review`. O que é compartilhado é a **obrigação de consumo** e o **direito de levantar defeito**:

| Papel | Sobre `${CLAUDE_PLUGIN_ROOT}/standards/` | Como propõe mudança |
|---|---|---|
| **Arquiteto** | Dono editorial. Escreve, versiona, mantém a coerência entre nível 1 e perfis de nível 2 | `/review` |
| **dev** | Consumidor obrigatório: aplica a regra ao executar o plano | 🔺 GAP apontando contradição / lacuna / regra inverificável → Arquiteto decide → `/review` roteia a correção do texto ao Arquiteto (o dev não edita os próprios normativos — v1.3) |
| **QA** | Consumidor obrigatório: valida a entrega contra os standards | Achado de processo (não achado de código) → `/review` roteia ao Arquiteto |

**Desempate:** quando os três discordam sobre uma regra de engenharia, decide o **Arquiteto** — é o dono do desenho técnico. A divergência que ultrapassa engenharia (custo, prazo, escopo, política) sobe ao **stakeholder pelo SM**, com as posições lado a lado (consolidação de acordo). Defeito num standard **não se corrige de passagem** — vale a mesma regra do QA que acha defeito fora do item (abrir registro, não corrigir).

## 2. Fluxo de um artefato entre papéis

```
[projeto novo/retomado] ─▶ SM conduz onboarding (§5a) ─▶ contexto do projeto alinhado
[ideia sem documentação] ─▶ SM facilita brainstorm (§5b): PO+UX, depois +Arquiteto ─▶ brief funcional
           │
ideia ─────▶ PO escreve requisito e prioriza no backlog
              └─▶ SM cria item no quadro
                    └─▶ Arquiteto escreve plano
                          └─▶ dev escreve código+testes
                                └─▶ QA registra evidência
                                      ├─▶ QA atualiza inventário de código e registro de GAPs
                                      └─▶ SM atualiza o documento de status no fechamento
```

## 3. Conflitos comuns e como resolver

| Situação | Errado | Certo |
|---|---|---|
| Dev percebe requisito ambíguo | Decidir e seguir | 🔺 GAP → Arquiteto → (se funcional) PO |
| Dev não sabe o que mostrar no estado vazio ou de erro | Inventar a tela | 🔺 GAP → UX; a especificação é corrigida |
| UX precisa de um dado que a API não expõe | Supor o contrato | Levantar ao Arquiteto antes de fechar a especificação |
| UX quer mudar uma regra para simplificar a tela | Mudar no desenho | Escalação ao PO — regra é dele |
| Arquiteto quer renomear entidade da especificação | Renomear no plano | Mudança formal: PO aprova, Arquiteto atualiza o modelo, migration explícita |
| QA encontra defeito fora do item | Corrigir de passagem | Abrir GAP; SM entra na fila |
| Frente 2 do QA parece repetir o `/arc comply` | Reexecutar a tabela passo × conforme do comply | Checar o que o comply não vê: plano omitiu ou errou a seção que o item exigia — [`workflow.md` §4a](workflow.md) |
| SM vê status divergente do código | Ajustar o status pela intuição | Acionar `/qa audit`; corrigir com o achado |
| Mudança de `/review` aplicada mas não lançada | Assumir que as instalações já a têm | Entra numa entrega: branch, bump de `version`, entrada no `CHANGELOG.md` (R18 · [`workflow.md` §5d](workflow.md)) |
| PO quer marcar critério de sucesso como atendido | Marcar direto | Exige evidência no registro do QA |

## 4. Convenções

- **Idioma:** documentação e comunicação no idioma do time; código, identificadores e mensagens de commit seguem o padrão já existente no repositório.
- **IDs:** padrão definido no contexto do projeto; nunca reaproveitados.
- **Commits:** um item por commit sempre que possível, referenciando o ID.
- **Resolver GAP:** o QA remove o item do registro de GAPs e o SM registra a correção no documento de status — nunca os dois no mesmo arquivo.
- **Documento vivo** traz no topo a marcação **DOCUMENTO VIVO**, o dono e a data da última atualização.
- **Nomes de arquivo em `${CLAUDE_PLUGIN_ROOT}/` e `.team-project/`:** inglês, kebab-case, sem acento. Conteúdo no idioma do time. Documento vivo e modelo compartilham o nome — o modelo fica em `templates/`.
