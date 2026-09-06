# Princípios de Implementação — Clean Architecture · Clean Code · CQRS · Testes

**Versão:** 1.1
**Data:** 06/09/2026
**Status:** Draft normativo
**Escopo:** agnóstico de produto **e** de linguagem/plataforma

> **Este é o normativo de nível 1 da organização.** Vale para **todo** projeto, em qualquer linguagem, framework ou plataforma: serviço, aplicação web, app, biblioteca, CLI ou worker. Todas as regras aqui são obrigatórias salvo decisão explícita em ADR do projeto.
>
> Ele define **o que** precisa ser verdade e **como se verifica** — nunca a ferramenta. A tradução para uma stack concreta é feita uma única vez por projeto, na **Ficha de Vinculação de Stack** (§6), e vive no documento de arquitetura daquele produto.
>
> Este guia não contém nomes de entidades, capacidades, integrações ou regras de negócio de nenhum produto específico.

---

## Os dois níveis do `${CLAUDE_PLUGIN_ROOT}/standards/`

| Nível | Documento | Responde |
|---|---|---|
| **1 — princípios** | **este documento** | O que vale em qualquer projeto, em qualquer linguagem |
| **2 — perfil de stack** | [`implementation-guide.md`](implementation-guide.md) · [`implementation-quality.md`](implementation-quality.md) | Como o nível 1 se escreve numa stack concreta (hoje: .NET / xUnit / GitLab CI) |
| **transversal** | [`implementation-security-lgpd-copyright.md`](implementation-security-lgpd-copyright.md) | Identidade, autorização, privacidade e direitos autorais — vale nos dois níveis |

**Regra de precedência:** onde o nível 2 divergir do nível 1, **o nível 1 vence** e a divergência é defeito de documento, corrigida no mesmo ciclo. Um perfil de stack pode **acrescentar** obrigação; nunca afrouxar uma daqui.

**Projeto cuja stack não tem perfil de nível 2** segue este documento e preenche a Ficha de Vinculação (§6) — não fica sem normativo, e **não** inventa um padrão paralelo.

---

## Documentos relacionados

| Documento | Conteúdo |
|---|---|
| [`implementation-guide.md`](implementation-guide.md) | Perfil .NET — estrutura de pastas, contratos de CQRS, portas de infraestrutura, logging, configuração |
| [`implementation-quality.md`](implementation-quality.md) | Perfil .NET/GitLab — analisadores, cobertura, métricas e pipeline |
| [`implementation-security-lgpd-copyright.md`](implementation-security-lgpd-copyright.md) | Autenticação, autorização, PII, retenção, direitos autorais |

---

## Decisões Firmadas

| Referência | Decisão | Origem |
|---|---|---|
| COVERAGE-STAT | O gate de 80% é aplicado como **mínimo por módulo medido** — **nunca** como média entre módulos | Stakeholder, 02/09/2026 |
| COVERAGE-SCOPE | O gate cobre **toda unidade implantável e todos os anéis**: domínio, aplicação, adaptadores, borda **e front-end**. Nenhum anel é isento | Stakeholder, 02/09/2026 |

**Nenhuma pendência aberta neste nível.** Pendências de *ferramenta* (qual detector de duplicação, qual medidor de cobertura de diff) vivem nos perfis de stack — nunca aqui, porque a regra não depende da ferramenta.

---

## Sumário

1. Como organizar qualquer projeto dentro destes padrões
2. Clean Architecture
3. CQRS
4. Clean Code
5. Testes e Cobertura *(inclui §5.6 — Desempenho)*
6. Ficha de Vinculação de Stack
7. Quadro de Verificação — o que bloqueia o quê
8. Adoção em projeto já existente

---

## 1. Como organizar qualquer projeto dentro destes padrões

Três passos, nesta ordem, antes do primeiro Plano de Execução:

1. **Declarar as unidades implantáveis.** Cada processo que sobe sozinho (API, worker, app, front, CLI) é uma unidade. Cada unidade tem os quatro anéis de §2 — mesmo que um anel seja pequeno.
2. **Preencher a Ficha de Vinculação de Stack (§6)** no documento de arquitetura do produto: o nome real de cada anel e a ferramenta concreta que verifica cada regra.
3. **Ligar os gates no pipeline** (§7) antes do primeiro item de negócio. Gate que entra depois nunca entra.

**Regra:** projeto sem Ficha de Vinculação preenchida **não recebe Plano de Execução** — sem ela o plano não consegue apontar o anel de cada arquivo nem o comando que verifica a entrega, e o dev decide por conta.

**Regra:** estes princípios não dependem do tamanho do projeto. O que varia é o **peso** de cada anel, nunca a existência da fronteira: uma CLI pode ter um anel de borda de dez linhas, mas ainda assim tem o anel.

---

## 2. Clean Architecture

### 2.1 Os quatro anéis

```text
        ┌──────────────────────────────────────────┐
        │  Borda (entry points)                    │  HTTP, CLI, consumidor de fila, UI
        │  ┌────────────────────────────────────┐  │
        │  │  Adaptadores / Infraestrutura      │  │  banco, arquivos, integrações, mensageria
        │  │  ┌──────────────────────────────┐  │  │
        │  │  │  Aplicação (casos de uso)    │  │  │  orquestra o domínio, declara as portas
        │  │  │  ┌────────────────────────┐  │  │  │
        │  │  │  │  Domínio               │  │  │  │  entidades, invariantes, regras
        │  │  │  └────────────────────────┘  │  │  │
        │  │  └──────────────────────────────┘  │  │
        │  └────────────────────────────────────┘  │
        └──────────────────────────────────────────┘
                    dependência aponta ▲ para dentro
```

| Anel | Contém | Nunca contém |
|---|---|---|
| **Domínio** | Entidades, objetos de valor, enums, eventos de domínio, invariantes, exceções de domínio, contratos de repositório | Framework, ORM, HTTP, SDK de terceiro, I/O, log, serialização, anotação de persistência |
| **Aplicação** | Casos de uso (comandos e consultas), portas de infraestrutura, DTOs, comportamentos transversais | Referência a implementação concreta de infraestrutura |
| **Adaptadores/Infraestrutura** | Implementações das portas: persistência, mensageria, cache, armazenamento, integrações, criptografia | Regra de negócio |
| **Borda** | Controladores/rotas, middlewares, filtros, telas, comandos de CLI, consumidores, composição de dependências | Regra de negócio e acesso direto à infraestrutura fora da composição |

### 2.2 Regra de dependência

**A dependência aponta sempre para dentro.** O anel de fora conhece o de dentro; o de dentro nunca conhece o de fora — nem por import, nem por tipo em assinatura, nem por atributo/anotação.

- Toda dependência externa entra por uma **porta declarada na Aplicação** e é implementada nos Adaptadores.
- Nenhum tipo de framework/SDK atravessa a fronteira da Aplicação para dentro. Se o tipo do fornecedor aparece numa assinatura de caso de uso, a porta está errada.
- A **composição de dependências** acontece em um único ponto por unidade implantável. Registro solto espalhado pelo código é violação.
- Regra de negócio não vive na borda nem no adaptador. Validação de formato de entrada é da borda/aplicação; **decisão de negócio é do domínio**.

### 2.3 Verificação (obrigatória, automatizada)

> **A regra de dependência é verificada por teste automatizado, não por revisão humana.**

Cada projeto tem **um teste de arquitetura** que falha quando um anel importa para fora. Ele roda no mesmo estágio dos testes de unidade e bloqueia o merge. A ferramenta é declarada em §6 (V6).

Casos mínimos que esse teste cobre:

1. Domínio não referencia Aplicação, Adaptadores nem Borda.
2. Domínio não referencia nenhuma biblioteca externa à linguagem/base padrão, salvo lista fechada aprovada em ADR.
3. Aplicação não referencia Adaptadores nem Borda.
4. Nenhum SDK/cliente de um fornecedor específico é referenciado fora do diretório de adaptadores daquela integração.

**Ausência desse teste é achado bloqueante de aderência** — não é dívida negociável, porque sem ele a arquitetura degrada em silêncio e ninguém percebe até o custo já estar pago.

---

## 3. CQRS

### 3.1 A regra

A camada de Aplicação separa **escrita** de **leitura**:

| | Comando | Consulta |
|---|---|---|
| Muda estado? | Sim | **Nunca** |
| Retorna | Identificador/resultado da operação, ou nada | DTO de leitura |
| Passa pelo domínio? | Sim — a decisão de negócio é da entidade | Não obrigatoriamente — lê estado já persistido |

Regras invioláveis:

- **Um caso de uso por comando/consulta**, em arquivo próprio, com um único handler.
- **Handler não chama handler.** Lógica reusada vira serviço de domínio.
- **Comando não retorna entidade de domínio**; **consulta não retorna entidade de domínio** — sempre DTO.
- **Consulta não escreve.** Nem "só o contador de acessos", nem "só o cache de leitura persistido".
- Preocupações transversais (log, validação, autorização, auditoria, transação) ficam em **pipeline fora do handler**, na mesma ordem para todos os casos de uso — nunca repetidas dentro de cada handler.
- Comando de escrita sensível declara explicitamente a autorização exigida (ver `implementation-security-lgpd-copyright.md` §5).

### 3.2 O que CQRS **não** obriga

CQRS aqui é separação de **modelo**, não de infraestrutura. **Não** exige banco de leitura separado, projeção assíncrona nem event sourcing. Adotar qualquer um dos três é decisão de ADR, justificada por um problema medido — nunca antecipação.

### 3.3 Verificação

- Nomenclatura distingue os dois lados (o padrão real de sufixo/pasta é declarado em §6) — divergência é achado de aderência.
- Teste de arquitetura: handler de consulta não depende de porta de escrita/persistência transacional.
- Revisão de aderência: nenhum handler injeta ou invoca outro handler.

---

## 4. Clean Code

Estas regras valem para todo código de produção, em qualquer linguagem. **Todas têm verificação automatizada ou critério objetivo de revisão** — regra de estilo que depende de gosto não entra aqui.

### 4.1 Nomes

- Nome revela **intenção**: o que é/faz, não como está implementado.
- Proibidos nomes genéricos como veículo de significado: `data`, `info`, `temp`, `obj`, `manager`, `helper`, `util`, `processor` — salvo quando o nome for de fato o conceito do domínio.
- Sem abreviação que não seja do domínio ou universal da stack.
- **A grafia definida na especificação (entidade, campo, enum, rota) é literal** — nunca "melhorada" no código.
- Um conceito, um nome, em todo o repositório. Sinônimos concorrentes para a mesma coisa são defeito.

### 4.2 Funções e classes

- Uma função faz **uma** coisa, em um único nível de abstração.
- **Máximo 4 parâmetros.** Acima disso, objeto de parâmetro.
- **Sem argumento-bandeira**: parâmetro booleano que troca o comportamento vira duas funções.
- Sem efeito colateral escondido: função cujo nome promete consulta não altera estado.
- Uma classe/módulo tem **uma** razão para mudar.

### 4.3 Corpo do código

- **Sem número ou texto mágico** — constante nomeada, ou configuração.
- **Sem duplicação**: bloco repetido acima do limite declarado em §6 (V9) bloqueia o merge.
- **Sem código comentado** e sem código morto (função/ramo inalcançável).
- Comentário explica **por quê**, nunca **o quê**. Comentário que descreve o código é removido junto com a necessidade dele.
- `TODO`/`FIXME` só entra no merge **com o ID de um item aberto**; sem ID, bloqueia.
- Tratamento de erro é explícito: exceção ou tipo de resultado. **Nunca** código de erro numérico, nunca retorno nulo silencioso, **nunca bloco de captura vazio ou que engole a exceção**.
- Aninhamento raso: retorno antecipado em vez de escada de condicionais.
- Formatação **não se discute em revisão** — é aplicada por formatter, verificada em modo `--check` no pipeline.

### 4.4 Limites numéricos — fonte única

Estes são os limites da organização. O perfil de stack configura a ferramenta que os mede; **se um perfil trouxer número diferente, o valor válido é o desta tabela.**

| Métrica | Limite | O que evita |
|---|---|---|
| Complexidade ciclomática por função | ≤ 10 | Função que ninguém consegue testar por inteiro |
| Linhas executáveis por função | ≤ 50 | Função que faz mais de uma coisa |
| Parâmetros por função | ≤ 4 | Assinatura que esconde um conceito não modelado |
| Acoplamento por classe/módulo (tipos externos referenciados) | ≤ 9 | Módulo que sabe demais |
| Profundidade de herança | ≤ 5 | Hierarquia que só se entende de cima a baixo |
| Índice de manutenibilidade (escala 0–100, quando a stack o oferece) | ≥ 20 | Degradação silenciosa |

**Supressão** de um diagnóstico ou de um limite é permitida apenas com justificativa escrita na própria linha (ou na imediatamente anterior) e só pelo Arquiteto. Supressão sem justificativa é achado bloqueante. Exceção: arquivos gerados automaticamente.

### 4.5 O que **não** adotamos do Clean Code clássico — e por quê

| Prática clássica | Posição desta organização |
|---|---|
| *Boy Scout Rule* ("deixe o código melhor do que encontrou") | **Não vale como licença para refatorar de passagem.** O escopo é fechado pelo Plano de Execução; melhoria percebida vira item, registrada na seção "Não fiz (fora do plano)" do relatório do dev. Refatoração oportunista quebra a rastreabilidade entre item, mudança e evidência |
| "Todo comentário é uma falha" | Comentário de **porquê**, decisão e referência a ADR é desejável. O que se proíbe é o comentário que repete o código |
| Cobertura de 100% como meta | O gate é 80% (§5.4). Perseguir 100% produz teste de decoração, não proteção |

---

## 5. Testes e Cobertura

### 5.1 Níveis

| Nível | Escopo | Dependências reais | Onde roda |
|---|---|---|---|
| **Unidade** | Domínio e Aplicação | Nenhuma — substitutas nas portas | Todo push |
| **Arquitetura** | Regra de dependência (§2.3) e CQRS (§3.3) | Nenhuma | Todo push, junto com unidade |
| **Integração** | Adaptadores contra as dependências reais (banco, fila, cache, armazenamento) | Reais | Merge para a linha principal e de integração |
| **E2E** | Fluxo ponta a ponta pela borda | Todas | Merge para a linha principal |
| **Carga** | Só as operações declaradas sob orçamento de desempenho (§5.6, V18) | Reais, no ambiente de medição de V21 | Merge para a linha principal **e** em todo item que toca uma operação sob orçamento |

- **Nenhum mock de banco de dados em teste de integração.** Se o banco é falso, o teste não é de integração.
- Todo teste de integração que acessa dados isola o escopo (tenant/usuário) e prova que dado de outro escopo não vaza, respondendo `404` — nunca `403` — ao acesso cruzado (ver [`implementation-security-lgpd-copyright.md`](implementation-security-lgpd-copyright.md) §7).
- Cada test run cria e limpa os próprios dados.

### 5.2 O teste precisa proteger algo

Padrão de nome: `<Cenário>_<Condição>_<ResultadoEsperado>`.

Cada teste declara, em comentário de uma linha ou no próprio nome, **o que deve falhar se o código regredir**. Teste que continua passando com a regra removida é decoração e conta como ausência de teste na revisão de aderência.

### 5.3 Cobertura — o que se mede

- **Métrica:** cobertura de **linha**.
- **Escopo obrigatório:** **todo o código de produção de todas as unidades implantáveis** — domínio, aplicação, adaptadores/infraestrutura, borda **e front-end/app**. Nenhum anel é isento, nenhuma unidade fica de fora *(COVERAGE-SCOPE, firmada)*.
- **Exclusões permitidas — lista fechada:** código gerado automaticamente, arquivos de composição de dependências/bootstrap e migrations geradas. **Qualquer outra exclusão exige ADR** — é o mecanismo por onde o gate de cobertura costuma ser esvaziado sem ninguém notar.

### 5.4 O gate de 80%

> **Limiar: 80% de cobertura de linha. Abaixo disso, o merge é bloqueado.**

| Regra | Detalhe |
|---|---|
| **Valor** | 80%, mínimo |
| **Granularidade** | **Mínimo por módulo/pacote medido — nunca média do conjunto.** Um módulo a 40% não é compensado por outro a 100%; o gate reprova pelo pior módulo *(COVERAGE-STAT, firmada)* |
| **Abrangência** | **Toda unidade implantável e todo anel**, front-end incluído. Cada unidade tem o seu próprio comando de gate, declarado na Ficha (§6) *(COVERAGE-SCOPE, firmada)* |
| **Bloqueio** | O comando do gate retorna código de saída ≠ 0 e reprova o estágio. Gate que só imprime aviso não é gate |
| **Código novo/alterado** | Cobertura do diff ≥ 80%, **inclusive em repositório legado abaixo do limiar** |
| **Direção** | O limiar **só sobe**, nunca desce. Redução exige ADR com justificativa e prazo |
| **Evidência** | O relatório de entrega traz a **saída real** do comando de cobertura, não a alegação |

### 5.5 Adoção do gate por unidade implantável

Toda unidade implantável com código próprio tem **gate próprio, com comando próprio** — **incluindo front-end e app**, onde o que se cobre é a lógica de estado, os serviços, as regras de apresentação e os componentes.

- Unidade **sem suíte de testes** é medida em 0%, o gate é ligado nessa baseline e a regra de diff ≥ 80% (§5.4) passa a valer **imediatamente**, no primeiro item que tocar aquela unidade.
- Unidade **sem gate configurado** é achado **bloqueante** de aderência, não pendência de organização.
- "Essa unidade não tem como ser testada" não é resposta: se não há como medir, a Ficha (§6, V10–V12) registra a ferramenta escolhida e o item de configuração entra no backlog **antes** do próximo item de negócio daquela unidade.

> Front-end **não é exceção**. Foi a exceção mais comum e a que mais custou: interface sem teste é onde a regra de negócio reaparece duplicada e ninguém vê.

### 5.6 Desempenho — RNF verificável, orçamento e regressão

> **A obrigação aqui não é "ser rápido": é que desempenho seja um número medido por comando, comparável entre execuções e capaz de reprovar.** Enquanto não houver isso, o estado correto no veredito do QA é **"não exercitado"** — nunca "aprovado".

Este normativo **não** fixa nenhum número. Limiar, carga e ambiente são do projeto e vivem na Ficha (§6, V18–V21). O que é obrigatório em qualquer projeto são as seis regras abaixo.

#### P1 — RNF de performance só existe com cinco campos

Um requisito de desempenho só é aceitável quando declara, junto: **operação** (nome real, um caminho de uso, não "o sistema") · **métrica** (percentil, nunca média) · **limiar numérico** · **condição de carga** (taxa ou usuários simultâneos **e** duração) · **ambiente de medição**. Falta um campo, não é RNF — é intenção. *("Deve ser performático" não é RNF; "responder em até 500 ms no percentil 95" é — [`deliverables/sdd/01-requirements.md`](../deliverables/sdd/01-requirements.md).)*

**Como se verifica:** leitura do documento de requisitos antes do plano. RNF de performance incompleto **volta ao PO** e o item não entra em construção (§7, #18).

#### P2 — Orçamento de desempenho é uma lista fechada e declarada

As operações sob orçamento vivem em **V18**, uma linha por operação com os cinco campos de P1. Entram na lista, e só elas: operação síncrona da borda que o produto declara como caminho principal, e operação assíncrona cuja demora o usuário percebe.

**Fronteira:** operação fora da lista **não** bloqueia nada e não se mede "por via das dúvidas" — orçamento inventado é escopo antecipado. Projeto que não declara nenhuma linha em V18 tem desempenho **não exercitado**, o que é um estado válido, explícito e registrado; o que não é válido é a linha ausente da Ficha.

**Como se verifica:** V18 preenchida (ou declarada vazia com o motivo) é condição de Ficha completa — sem Ficha, sem Plano de Execução (§1).

#### P3 — Cenário de carga é código versionado, com o limiar dentro dele

Cada linha de V18 tem **um cenário executável** no repositório, rodado por um **comando único** (V19) que termina com **código de saída ≠ 0** quando o limiar é violado. Cenário que só imprime números não é gate — é a mesma regra do gate de cobertura (§5.4).

- O cenário carrega o limiar de P1; limiar que só existe no documento não protege nada.
- O cenário **cria e limpa os próprios dados** e usa escopo (tenant/usuário) próprio de carga.
- **Carga nunca roda contra dado pessoal de produção** nem com cópia dele — ver [`implementation-security-lgpd-copyright.md`](implementation-security-lgpd-copyright.md) §8.
- Código de cenário de carga **não é código de produção**: não entra na medição de cobertura e **não** conta como exclusão de §5.3.

#### P4 — Baseline é medida, não declarada

A baseline é o resultado **real** da última execução aceita: valor da métrica, data, identificador da versão do código e ambiente. Vive versionada no repositório (V21). Comparação só vale entre execuções do **mesmo** cenário, no **mesmo** ambiente. Número que veio de documento, de estimativa ou de outra máquina não é baseline.

#### P5 — Regressão: o que é, e quando bloqueia

**Regressão de performance** é a piora da métrica declarada, na mesma operação, mesmo cenário e mesmo ambiente, **acima da margem de ruído medida** do ambiente (V20). Margem estimada "no olho" não serve: ela é medida executando o cenário sem mudança de código e registrando a variação.

| Situação | Consequência |
|---|---|
| Limiar absoluto do orçamento violado (P1/V18) | **Bloqueia** a promoção à linha principal |
| Piora acima da margem, ainda dentro do limiar | **Bloqueia** — a única saída é **atualizar a baseline no mesmo merge**, com justificativa no registro da mudança |
| Variação dentro da margem | Passa, sem discussão |

Atualizar a baseline é a válvula de escape, e ela é **visível**: aparece no diff, é revisada, e não some no meio do log do pipeline. Perda de desempenho aceita em definitivo (mudança de limiar de V18 para pior) exige **ADR** — mesma direção do gate de cobertura (§5.4): o limiar **só aperta**.

#### P6 — Evidência e quando se exercita

- O relatório de entrega traz a **saída real** do comando de V19, não a alegação — mesma regra de §5.4.
- Carga **não roda a todo push** (custo e ruído). Roda no merge para a linha principal e, obrigatoriamente, **no item que toca uma operação de V18**.
- Item que toca operação de V18 **sem a saída do comando** não é dado como verificado — é achado bloqueante de aderência, como a unidade sem gate de cobertura (§5.5).
- Unidade de front-end com orçamento declarado usa a ferramenta do próprio ecossistema, com o mesmo formato: comando único, limiar dentro do cenário, artefato de saída (V19).

**O que esta seção não cobre:** otimização especulativa, *profiling*, dimensionamento de infraestrutura e custo de execução. Nada disso vira obrigação por aqui — o que vira obrigação é o número medido e comparável.

---

## 6. Ficha de Vinculação de Stack

Preenchida uma vez por projeto pelo Arquiteto, mantida no documento de arquitetura do produto e atualizada no mesmo ciclo em que a stack mudar. É o que permite aplicar este normativo **a qualquer linguagem ou plataforma** sem reescrevê-lo.

| # | Item a vincular | O que preencher |
|---|---|---|
| V1 | Nome real do anel de **Domínio** | módulo/pasta/pacote |
| V2 | Nome real do anel de **Aplicação** | módulo/pasta/pacote |
| V3 | Nome real do anel de **Adaptadores/Infraestrutura** | módulo/pasta/pacote |
| V4 | Nome real do anel de **Borda** | módulo/pasta/pacote |
| V5 | **Unidades implantáveis** | uma linha por processo que sobe sozinho — **cada linha traz o seu próprio V11 e V12** |
| V6 | **Verificação da regra de dependência** | ferramenta + onde o teste vive + comando |
| V7 | **Formatter** | ferramenta + comando de verificação (`--check`) |
| V8 | **Linter/analisador estático** | ferramenta + configuração + comando |
| V9 | **Detector de duplicação** | ferramenta + limite (tamanho do bloco) |
| V10 | **Runner de teste por nível** | unidade · arquitetura · integração · E2E — **por unidade implantável**, front-end incluído |
| V11 | **Ferramenta de cobertura, por unidade implantável** | uma linha por unidade (back-end, worker, front-end, app, CLI): ferramenta + formato do relatório. Linha ausente = unidade sem gate = achado bloqueante (§5.5) |
| V12 | **Comando do gate de 80%, por unidade implantável** | comando literal, um por unidade, que falha com código ≠ 0 quando **qualquer módulo** fica abaixo de 80% — mínimo por módulo, nunca média (§5.4) |
| V13 | **Métricas de código** (§4.4) | ferramenta + comando; se a stack não oferece uma métrica, declarar "não aplicável" **e** o que a substitui |
| V14 | **Plataforma de CI e estágios bloqueantes** | nome dos estágios e o que cada um reprova |
| V15 | **Exclusões de cobertura aprovadas** | lista fechada + ADR de cada exclusão fora de §5.3 — vale para **todas** as unidades, inclusive o front-end |
| V16 | **Ponto único de composição de dependências** | arquivo por unidade implantável |
| V17 | **Mecanismo do pipeline transversal** (§3.1) | como log/validação/autorização/auditoria envolvem o handler |
| V18 | **Operações sob orçamento de desempenho** (§5.6) | lista fechada, uma linha por operação, com os **cinco campos** de P1: operação · métrica (percentil) · limiar numérico · condição de carga (taxa/usuários **e** duração) · ambiente. Linha com menos de cinco campos não é orçamento. **Nenhuma operação** é resposta válida — escrita, não omitida |
| V19 | **Ferramenta e comando do teste de carga, por unidade implantável** | ferramenta + caminho do cenário + **comando literal** que sai com código ≠ 0 quando o limiar é violado + artefato de saída. Uma linha por unidade que tenha operação em V18, front-end incluído |
| V20 | **Margem de ruído do ambiente de medição** | percentual de variação aceito entre execuções, **medido** (execuções repetidas sem mudança de código) e como foi medido — nunca estimado |
| V21 | **Ambiente de medição e onde vive a baseline** | ambiente (dedicado/compartilhado, e o que ele tem de diferente da produção) + arquivo versionado da baseline + quem aprova a atualização dela |

> **Regra de preenchimento:** V11 e V12 são **por unidade implantável**, não por repositório. Uma ficha com um único comando de cobertura num repositório com back-end e front-end é ficha incompleta — e o front-end é exatamente a unidade que costuma sumir da lista.

### 6.1 Exemplos por ecossistema — ilustrativos, não normativos

Servem para acelerar o preenchimento; nenhum projeto é obrigado a usar as ferramentas abaixo, e a lista não é exaustiva.

| Ecossistema | Regra de dependência | Lint + formatter | Cobertura + gate | Métricas |
|---|---|---|---|---|
| .NET | teste de arquitetura sobre os assemblies | analisadores do compilador + regras de estilo no build | ferramenta de cobertura do runner com limiar no comando | métricas oficiais do compilador |
| TypeScript/Node | regra de fronteira de import no linter | linter + formatter no pipeline | cobertura do runner com limiar por módulo | plugin de complexidade do linter |
| Java/Kotlin | teste de arquitetura sobre os pacotes | linter/estilo + formatter | ferramenta de cobertura com regra de limite | ferramenta de métricas do build |
| Python | verificador de imports por camada | linter + formatter | ferramenta de cobertura com `fail-under` | plugin de complexidade do linter |
| Go | verificação de dependência entre pacotes | vet + formatter | cobertura nativa com limiar em script | analisador de complexidade |

---

## 7. Quadro de Verificação — o que bloqueia o quê

Toda regra deste normativo tem uma forma de verificação. Regra sem verificação não é regra.

| # | Regra | Como se verifica | Estágio | Consequência |
|---|---|---|---|---|
| 1 | Regra de dependência entre anéis (§2.2) | Teste de arquitetura (V6) | testes | **Bloqueia o merge** |
| 2 | Domínio sem dependência externa (§2.1) | Teste de arquitetura + revisão de aderência | testes | **Bloqueia o merge** |
| 3 | SDK de fornecedor fora do adaptador (§2.3) | Teste de arquitetura ou regra de lint | análise | **Bloqueia o merge** |
| 4 | Consulta não escreve (§3.1) | Teste de arquitetura + revisão de aderência | testes | **Bloqueia o merge** |
| 5 | Handler não chama handler (§3.1) | Revisão de aderência (`/arc comply`) | revisão | Ajuste antes do QA |
| 6 | Limites numéricos de §4.4 | Ferramenta de métricas (V13) | análise | **Bloqueia o merge** |
| 7 | Lint e formatação (§4.3) | Linter + formatter em modo verificação (V7/V8) | análise | **Bloqueia o merge** |
| 8 | Duplicação acima do limite (§4.3) | Detector de duplicação (V9) | análise | **Bloqueia o merge** |
| 9 | `TODO`/`FIXME` sem ID de item (§4.3) | Busca por padrão no pipeline | análise | **Bloqueia o merge** |
| 10 | Captura de exceção vazia (§4.3) | Regra de lint/analisador | análise | **Bloqueia o merge** |
| 11 | **Cobertura ≥ 80% em cada módulo — mínimo, nunca média (§5.4)** | Comando do gate da unidade (V12), código de saída ≠ 0 | testes | **Bloqueia o merge** |
| 12 | Cobertura do diff ≥ 80% (§5.4) | Relatório de cobertura do diff | testes | **Bloqueia o merge** |
| 13 | Exclusão de cobertura fora da lista fechada (§5.3) | Revisão da configuração + ADR | revisão | Ajuste antes do QA |
| 14 | **Toda unidade implantável tem gate próprio — front-end incluído (§5.5)** | Um estágio de cobertura por unidade no pipeline, com o comando de V12 | auditoria | Achado bloqueante de aderência |
| 15 | Teste que não protege nada (§5.2) | Revisão do QA: "o que falha se a regra sumir?" | QA | Item volta |
| 16 | Ficha de Vinculação preenchida (§6) | Seção existe no documento de arquitetura do produto | antes do plano | Sem ficha, sem Plano de Execução |
| 17 | Supressão sem justificativa (§4.4) | Busca por padrão + revisão | análise | **Bloqueia o merge** |
| 18 | RNF de performance sem os **cinco campos** (§5.6 P1) | Leitura do documento de requisitos | antes do plano | RNF volta ao PO; o item não entra em construção |
| 19 | Limiar do orçamento violado (§5.6 P3) | Comando de carga (V19), código de saída ≠ 0 | carga | **Bloqueia** a promoção à linha principal |
| 20 | Regressão acima da margem medida (§5.6 P5) | Comparação com a baseline versionada (V21), margem de V20 | carga | **Bloqueia** — só passa com baseline atualizada e justificada no mesmo merge |
| 21 | Operação de V18 sem cenário executável, ou item que a toca sem a saída do comando (§5.6 P6) | Uma linha de V18 ↔ um cenário ↔ um job; saída real no relatório de entrega | auditoria | Achado bloqueante de aderência |
| 22 | Ficha com V18–V21 ausentes (§5.6 P2) | Seção existe no documento de arquitetura do produto | antes do plano | Ficha incompleta — sem Plano de Execução |

---

## 8. Adoção em projeto já existente

Ordem obrigatória — cada passo deixa o repositório em estado verificável:

1. **Preencher a Ficha (§6)** com o que já existe, incluindo o que ainda não existe, marcado como ausente. A ficha é o diagnóstico.
2. **Ligar formatter e linter** em modo verificação. É o passo mais barato e o que gera mais ruído — fazer isolado, num item próprio, nunca junto de mudança funcional.
3. **Medir a baseline** de cobertura e de métricas, **por módulo e por unidade implantável — front-end incluído**. O número medido vence qualquer número declarado em documento; unidade sem suíte entra na conta como 0%, não como "não aplicável".
4. **Ligar os gates na baseline medida**, imediatamente bloqueantes, mais a regra de diff ≥ 80% (§5.4). Gate "aspiracional" nunca é ligado.
5. **Escrever o teste de arquitetura** (§2.3) com as violações atuais registradas como exceções nomeadas e datadas — cada exceção vira item de backlog. Exceção sem item é dívida invisível.
6. **Subir o limiar** a cada ciclo até 80%, nunca descendo.
7. **Medir a baseline de desempenho** (§5.6 P4) das operações de V18, junto com a margem de ruído do ambiente (V20), e ligar os gates de carga na baseline medida. Sem V18 declarada, o passo é declarar a lista vazia e registrar desempenho como **não exercitado** — nunca deixar a linha em branco.

**Regra:** nenhum passo acima é feito "de passagem" dentro de um item de negócio. Cada um é um item próprio, com plano, evidência e registro — pelo mesmo motivo de §4.5.
