# Standards — Normativo de Engenharia do Time

> **Normativo de engenharia do time, mantido pelo Arquiteto.** Não é pasta de um papel: é **diretório de primeiro nível do plugin**, irmão de [`deliverables/`](../deliverables/README.md), porque o dev executa contra ele e o QA valida contra ele todo ciclo. Fica aqui — e não junto da documentação do produto — porque é **agnóstico de produto** e viaja intacto quando o time é replicado em outro projeto (ver [`how-to.md` § "Instalar e manter atualizado"](../how-to.md)).

## Quem escreve, quem consome, por onde entra defeito (R16)

| Papel | Relação com este diretório | Quando encontra defeito aqui |
|---|---|---|
| **Arquiteto** | **Dono editorial** — a única caneta. Escreve, versiona e responde pela coerência entre o **nível 1** e os **perfis de nível 2** | edita, por **`/review`** |
| **dev** | **Consumidor obrigatório** — aplica a seção que o Plano de Implementação cita, literalmente | abre **🔺 GAP** ao Arquiteto e **para de codificar** |
| **QA** | **Consumidor obrigatório** — valida a entrega contra estas regras; desvio de standard no código é **reprovação**, não ressalva | abre **achado de processo** roteado ao `/review` — não é achado de código |

**Defeito num standard não se corrige de passagem.** Contradição entre seções, lacuna que impede executar um passo, ou regra sem forma de verificação: o dev levanta 🔺 GAP, o QA levanta achado de processo, os dois vão ao Arquiteto, que resolve por `/review`. Quem consome **lê, cita e levanta** — não edita.

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
| [`implementation-principles.md`](implementation-principles.md) | **1** | Clean Architecture (quatro anéis e regra de dependência verificada por teste), CQRS, Clean Code (limites numéricos e regras verificáveis), testes e **gate de cobertura de 80%**, **desempenho (§5.6)**, Ficha de Vinculação de Stack (§6), **quadro de verificação (§7, regras Q1–Q23)** e adoção em projeto existente |
| [`test-ids.md`](test-ids.md) | **1** | **Padrão de ids de teste** (v3.55.0): quais elementos levam id, gramática única, atributo por alvo (web `data-testid`, híbrido `id`, Compose `testTag`), quem consome, prova em app híbrido |
| [`implementation-security-lgpd-copyright.md`](implementation-security-lgpd-copyright.md) | transversal | Segurança, Privacidade (LGPD) e Direitos Autorais |
| [`stacks/dotnet/guide.md`](stacks/dotnet/guide.md) · [`quality.md`](stacks/dotnet/quality.md) · [`desktop.md`](stacks/dotnet/desktop.md) | 2 — .NET | API e workers (estrutura, CQRS, portas, logging, configuração, carga) · analisadores, cobertura, métricas e pipeline · **desktop WPF, WinForms, WinUI** (MVVM, `AutomationId`) |
| [`stacks/kotlin-android/guide.md`](stacks/kotlin-android/guide.md) · [`quality.md`](stacks/kotlin-android/quality.md) | 2 — Kotlin/Android | anéis em pacotes, estado com `StateFlow`, Compose, `testTag`, testes por nível · detekt, ktlint, Lint, JaCoCo/Kover, Ficha pré-preenchida |
| [`stacks/react/guide.md`](stacks/react/guide.md) · [`quality.md`](stacks/react/quality.md) | 2 — React | anéis em pastas, estado do servidor × de tela, `data-testid`, testes por nível · ESLint, Prettier, Vitest, fronteira de import, Ficha pré-preenchida |
| [`stacks/angular/guide.md`](stacks/angular/guide.md) · [`quality.md`](stacks/angular/quality.md) | 2 — Angular | portas como `InjectionToken`, signals, `data-testid` · `angular-eslint`, Jest/Karma, Ficha pré-preenchida |
| [`stacks/ionic-capacitor/guide.md`](stacks/ionic-capacitor/guide.md) · [`pitfalls.md`](stacks/ionic-capacitor/pitfalls.md) | 2 — Ionic + Capacitor | soma ao perfil Angular: `id` como identificador de teste, harness do Karma com overlay e `.ion-page`, WebView/CDP só leitura, APK novo · 18 armadilhas do garden (v3.56.0, confirmar em segundo projeto) |

**Um diretório por tecnologia** (v3.51), sempre com o mesmo par: `guide.md` (como se escreve) e `quality.md` (com qual ferramenta, o comando do `guards.json`, a coluna **ecossistema restrito** — o substituto aceito quando o projeto proíbe ferramenta de terceiros — e a **Ficha de Vinculação pré-preenchida**, que o Arquiteto copia e ajusta em vez de escrever as 22 linhas do zero). Stack sem perfil segue o nível 1 e preenche a Ficha.

### Armadilhas da stack — `pitfalls.md` (v3.56.0)

Cada stack tem, ao lado do `guide.md`, um **`pitfalls.md`**: o comportamento real do framework que já derrubou plano ou teste (`## <STACK>-P<n>`, com **Vale para** em glob, **Sintoma**, **Fato** e **Como testar**). Ninguém lê o arquivo inteiro: o cartão do dev e a ficha do Arquiteto trazem só as entradas cujo **Vale para** casa com os arquivos da Task, até 6 por Task.

- **As stacks do projeto** ficam em `guards.json` → `"stacks": ["angular", "ionic-capacitor"]`. Sem a chave, o plugin infere pelo `package.json`, `build.gradle` ou `*.csproj` da raiz e das pastas do primeiro nível, e o SessionStart (G13) avisa.
- **Extensão sem mexer no plugin:** o projeto tem a própria camada em `.team-project/standards/stacks/<stack>/pitfalls.md` (`## <STACK>-L<n>`), que **soma** à do plugin. Uma entrada local com `**Promovida:** <ID do plugin>` deixa de ser lida. Stack nova: uma pasta nova aqui, pelo `/review`, ou só a camada local no projeto até o `/review` promover.
- **Quem grava:** aqui, só o `/review` (R16). Na camada local, o Arquiteto e o SM — este só pela promoção mecânica do fechamento (`knowledge.ps1 -Apply`, a `D-<k>` com `Lição: stack:<nome>`).
### Identificadores — leia a seção, não o arquivo

Cada regra verificável tem um identificador estável. **O plano e o veredito citam o identificador; o dev e o QA leem só a seção citada.** No benchmark, `implementation-principles.md` sozinho foi relido 7 vezes num sprint (2,6 milhões de tokens).

| Identificador | Onde | Exemplo |
|---|---|---|
| `Q1`–`Q23` | `implementation-principles.md` §7 (Quadro de Verificação) — também as linhas do `scripts/checks/quality.ps1` | `Q11` cobertura ≥ 80 % em cada módulo |
| `§n.n` do nível 1 | `implementation-principles.md` | `§4.4` limites numéricos |
| `KA-<n>` · `KA-Q<n>` | `stacks/kotlin-android/` | `KA-6` identificadores de teste |
| `RE-<n>` · `RE-Q<n>` | `stacks/react/` | `RE-3` estado e efeitos |
| `NG-<n>` · `NG-Q<n>` | `stacks/angular/` | `NG-Q2` `guards.json` de referência |
| `NET-D<n>` · seção do `guide.md`/`quality.md` .NET | `stacks/dotnet/` | `NET-D4` `AutomationId` |
| `IONIC-<n>` · `IONIC-P<n>` | `stacks/ionic-capacitor/` | `IONIC-P4` margem do `ion-button` |
| `<STACK>-P<n>` · `<STACK>-L<n>` | `stacks/<stack>/pitfalls.md` do plugin · `.team-project/standards/stacks/<stack>/pitfalls.md` do projeto | `NG-P1`, `IONIC-L2` |
## Documentos relacionados (fora deste diretório)

| Documento | Conteúdo |
|---|---|
| Documento de arquitetura do projeto | Aplicação concreta destes padrões ao produto (nomes reais de entidades, capacidades, integrações, enums) |
| Diretório de ADRs do projeto | Decisões arquiteturais formalizadas que fundamentam trechos destes guias |
| `.team-project/architect/context.md` *(no projeto onde o time está instalado)* | Como aquele projeto aplica os padrões: stack real, armadilhas do código, dívida arquitetural |
