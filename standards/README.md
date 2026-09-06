# Standards — Normativo de Engenharia do Time

> **Normativo de engenharia do time, mantido pelo Arquiteto.** Não é pasta de um papel: é **diretório de primeiro nível do plugin**, irmão de [`deliverables/`](../deliverables/README.md), porque o dev executa contra ele e o QA valida contra ele todo ciclo. Fica aqui — e não junto da documentação do produto — porque é **agnóstico de produto** e viaja intacto quando o time é replicado em outro projeto (ver [`replicate-in-new-project.md`](../replicate-in-new-project.md)).

## Quem escreve, quem consome, por onde entra defeito (R16)

| Papel | Relação com este diretório | Quando encontra defeito aqui |
|---|---|---|
| **Arquiteto** | **Dono editorial** — a única caneta. Escreve, versiona e responde pela coerência entre o **nível 1** e os **perfis de nível 2** | edita, por **`/arc review`** |
| **dev** | **Consumidor obrigatório** — aplica a seção que o Plano de Execução cita, literalmente | abre **🔺 GAP** ao Arquiteto e **para de codificar** |
| **QA** | **Consumidor obrigatório** — valida a entrega contra estas regras; desvio de standard no código é **reprovação**, não ressalva | abre **achado de processo** roteado ao `/arc review` — não é achado de código |

**Defeito num standard não se corrige de passagem.** Contradição entre seções, lacuna que impede executar um passo, ou regra sem forma de verificação: o dev levanta 🔺 GAP, o QA levanta achado de processo, os dois vão ao Arquiteto, que resolve por `/arc review`. Quem consome **lê, cita e levanta** — não edita.

**Desempate:** divergência sobre uma regra de engenharia decide o **Arquiteto**. O que ultrapassa engenharia (custo, prazo, escopo, política) sobe ao **stakeholder pelo SM**.

Normativo de referência: [R16 em `working-rules.md`](../roles/scrum-master/process/working-rules.md) e [`artifact-ownership.md` §1a](../roles/scrum-master/process/artifact-ownership.md).

## O que entra aqui

Guias normativos **agnósticos de produto**: regras, princípios e contratos reutilizáveis por qualquer projeto desta organização, sem nomes de entidades, capacidades ou regras de negócio de um produto específico. A aplicação concreta desses padrões a um produto específico vive no documento de arquitetura daquele produto — o caminho está em `.team-project/README.md` §4.

## Dois níveis

| Nível | O que é | Vale para |
|---|---|---|
| **1 — princípios** | O normativo da organização: **Clean Architecture · Clean Code · CQRS · testes com gate de 80%**, com a forma de verificação de cada regra | **Qualquer** projeto, em qualquer linguagem ou plataforma |
| **2 — perfil de stack** | Como o nível 1 se escreve numa stack concreta: estrutura real de pastas, contratos, ferramentas, pipeline | Projetos daquela stack |

**Precedência:** onde o nível 2 divergir do nível 1, **o nível 1 vence**, e a divergência é defeito de documento — corrigida no mesmo ciclo. Perfil de stack pode acrescentar obrigação; nunca afrouxar uma do nível 1.

**Stack sem perfil de nível 2** não fica sem normativo: segue o nível 1 e preenche a **Ficha de Vinculação de Stack** ([`implementation-principles.md`](implementation-principles.md) §6) no documento de arquitetura do produto.

## Índice

| Arquivo | Nível | Conteúdo |
|---|---|---|
| [`implementation-principles.md`](implementation-principles.md) | **1** | Clean Architecture (quatro anéis e regra de dependência verificada por teste), CQRS, Clean Code (limites numéricos e regras verificáveis), testes e **gate de cobertura de 80%**, **desempenho (§5.6 — RNF verificável, orçamento e regressão)**, Ficha de Vinculação de Stack, quadro de verificação e roteiro de adoção em projeto existente |
| [`implementation-guide.md`](implementation-guide.md) | 2 — .NET | Estrutura de pastas, nomenclatura, contratos de CQRS, isolamento multi-tenant, adaptadores multi-provedor, portas de infraestrutura (Object Storage, Cache, Message Broker), logging, configuração, testes e **cenários de carga (§9.6)** |
| [`implementation-quality.md`](implementation-quality.md) | 2 — .NET/GitLab | Code Analysis, Coverage, Metrics, **gates de desempenho (§4.2)** e pipeline de CI |
| [`implementation-security-lgpd-copyright.md`](implementation-security-lgpd-copyright.md) | transversal | Segurança, Privacidade (LGPD) e Direitos Autorais — autenticação, autorização, multi-tenancy aplicada à identidade, proteção de dados pessoais e rastreabilidade de direitos autorais sobre conteúdo de terceiros |

## Como usar

Estes documentos nunca devem ser editados para acomodar uma decisão de um produto específico — a decisão concreta (nomes reais de entidades, capacidades, integrações, perfis, permissões) vai sempre no documento de arquitetura do produto, que referencia a seção correspondente aqui.

**Por papel:**

| Papel | Como consome |
|---|---|
| **Arquiteto** | Cita a seção aplicável em **cada Plano de Execução** que toca engenharia — anel, nomenclatura, testes/cobertura e, em item sensível, a seção de segurança |
| **dev** | Lê **as seções que o plano citou**, não o diretório inteiro (R3). O que o plano não citou e o passo exige é 🔺 GAP |
| **QA** | Valida a entrega contra as seções citadas no plano e contra os gates de cobertura e de análise estática |

**Por dúvida:**

- Projeto novo, ou stack sem perfil → **começar por `implementation-principles.md`** e preencher a Ficha de Vinculação (§6) antes do primeiro Plano de Execução
- Dúvida sobre camadas, CQRS, nomes, limites de código, testes ou cobertura → `implementation-principles.md`
- Dúvida sobre como isso se escreve em .NET (estrutura de pastas, contratos, logging, configuração) → `implementation-guide.md`
- Dúvida sobre analisadores, ferramenta de cobertura ou pipeline → `implementation-quality.md`
- Dúvida sobre **desempenho** (o que é RNF verificável, orçamento por operação, o que conta como regressão) → `implementation-principles.md` §5.6; a ferramenta e o cenário → `implementation-guide.md` §9.6; os gates no pipeline → `implementation-quality.md` §4.2. **Os números são do projeto**, na Ficha V18–V21
- Dúvida sobre autenticação, autorização, multi-tenancy de identidade, LGPD ou direitos autorais → `implementation-security-lgpd-copyright.md`
- Dúvida sobre como um desses padrões se aplica *na prática* ao produto → documento de arquitetura do projeto (ver `.team-project/README.md` §4)

## Documentos relacionados (fora deste diretório)

| Documento | Conteúdo |
|---|---|
| Documento de arquitetura do projeto | Aplicação concreta destes padrões ao produto (nomes reais de entidades, capacidades, integrações, enums) |
| Diretório de ADRs do projeto | Decisões arquiteturais formalizadas que fundamentam trechos destes guias |
| `.team-project/architect/context.md` *(no projeto onde o time está instalado)* | Como aquele projeto aplica os padrões: stack real, armadilhas do código, dívida arquitetural |
