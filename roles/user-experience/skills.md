# UX — Skills

Competências transferíveis do papel. O inventário de telas, as convenções visuais e o ambiente de protótipo de cada projeto vivem em `.team-project/user-experience/context.md`.

## 1. Mapear jornada, não sequência de telas

Uma jornada responde: **o que traz o usuário aqui**, **o que ele leva embora** e **onde ele pode se perder**. Uma sequência de telas só lista rotas.

Os quatro pontos que uma jornada precisa marcar:

| Ponto | Por que importa |
|---|---|
| **Gatilho** | Sem ele, a tela existe sem motivo declarado |
| **Espera** | Processo longo sem feedback é abandono — e a maior parte dos sistemas tem mais espera do que admite |
| **Decisão humana** | Onde o sistema para e pergunta; se não for explícito, alguém decide sozinho no código |
| **Saída de erro** | Não basta mostrar o erro: a jornada precisa dizer para onde a pessoa vai depois |

## 2. Especificar os seis estados

**Vazio · carregando · sucesso · erro · sem permissão · volume extremo.** É a diferença entre uma especificação que o dev executa e uma que ele interpreta.

Dois deles são os mais esquecidos e os mais caros:

- **Vazio** — é a primeira tela que todo usuário novo vê. Se ela não ensina o próximo passo, o produto perde a pessoa no primeiro minuto.
- **Volume extremo** — nome de 80 caracteres, lista de 500 itens, texto sem quebra. O layout que só foi pensado com dado de exemplo quebra com dado real.

Os seis estados são da **tela**. Cada controle dentro dela tem o seu próprio eixo de estados — ver §8.

## 3. Reaproveitar antes de criar

Padrão novo custa consistência duas vezes: na implementação e na aprendizagem do usuário. Antes de desenhar, procure:

- a mesma interação em outra tela do produto;
- o componente já existente que resolve 80% do caso;
- a convenção que o produto já ensinou ao usuário.

Só introduza padrão novo quando o existente falhar — e escreva por que falhou. Essa frase é o que impede a próxima pessoa de "melhorar" de volta.

## 4. Escrever acessibilidade verificável

**Acessibilidade não é etapa final.** Ela entra quando a estrutura da tela está sendo decidida, no mesmo passe do layout — depois que a tela existe, o que sobra é remendo caro. Critério que o QA não consegue checar não é critério; prefira sempre a forma observável:

| ❌ Vago | ✅ Verificável |
|---|---|
| "A tela deve ser acessível" | "Todo controle é alcançável por Tab, na ordem visual, com foco visível" |
| "Bom contraste" | "Texto normal com contraste ≥ 4,5:1 contra o fundo; texto grande ≥ 3:1" |
| "Suporte a leitor de tela" | "Todo campo tem rótulo associado; ícone sem texto tem nome acessível" |
| "Botões clicáveis" | "Alvo de toque ≥ 44×44 px" |
| "Feedback de erro" | "Erro anunciado por região viva e associado ao campo que o causou" |
| "Funciona em qualquer tela" | "Conteúdo e função íntegros com zoom de 200% e em viewport de 320 px, sem rolagem horizontal" |
| "Animação suave" | "Nenhuma informação depende de movimento; a animação respeita a preferência de redução de movimento do sistema" |
| "Interação moderna" | "Nenhuma função depende só de gesto complexo (arrastar, pinçar, deslizar): há alternativa por clique ou toque simples" |
| "Linguagem clara" | "Rótulo e mensagem de erro em linguagem do usuário — sem jargão técnico, sem código de erro sozinho na tela" |

Base mínima que vale em qualquer projeto: **navegação por teclado · foco visível · rótulo acessível · contraste · alvo de toque · hierarquia semântica de títulos · texto alternativo · nada comunicado só por cor · conteúdo íntegro com zoom e em tela estreita · nenhuma função presa a gesto complexo ou a movimento**.

> **Decidido pelo stakeholder em 02/09/2026:** a régua vigente é **44×44**. O alvo mínimo de **48×48** que o repertório de sistemas de design maduros (§8) adota fica registrado como **referência, não como régua** — é um dos casos em que a convenção do time vence o repertório. Decisão no [changelog do processo](../scrum-master/process/process-changelog-archive.md) (v1.6); alterá-la exige nova decisão registrada. A especificação cita **uma** régua, nunca as duas.

### Design equitativo: quem fica de fora

Desenhar para o usuário médio é desenhar para quem já consegue. A pergunta que a especificação responde é a inversa: **quem não consegue, e o que o desenho faz por ele?** Cada tela nomeia ao menos uma condição de uso limitante — só teclado, leitor de tela, baixa visão, tela pequena, conexão lenta, primeiro contato com o produto, pressa — e diz o que muda por causa dela.

**Como se verifica:** a especificação traz a condição nomeada e a providência; o QA checa a providência como qualquer outro critério. Condição nomeada sem providência é decoração, e conta como critério ausente.

## 5. Desenhar para quem implementa

A especificação é lida por um dev júnior sem contexto. Ela precisa dizer:

- **hierarquia** (o que é primário, secundário, destrutivo);
- **conteúdo real**, não *lorem ipsum* — rótulo, mensagem de erro e texto de estado vazio são parte do desenho;
- **comportamento**, não só aparência: o que acontece no clique, o que fica desabilitado e por quê;
- **o que está fora** da tela — é o que impede escopo antecipado.

Se o dev puder escolher entre duas formas, a especificação está incompleta.

## 6. Separar achado de mudança

Achado fora da Task vira registro com severidade para o backlog do PO; nunca mudança de passagem em tela alheia à Task.

## 7. Saber onde termina o seu papel

| Situação | Quem decide |
|---|---|
| A tela exige mudar uma regra de negócio | PO |
| A tela exige um endpoint ou contrato novo | Arquiteto |
| A tela exige um componente que não existe | Arquiteto (estrutura) + você (comportamento) |
| A direção visual do produto muda | Stakeholder |
| **Quem é o ator** — quem existe no sistema e o que tem permissão de fazer | PO |
| **Como esse ator se comporta** — familiaridade, contexto de uso, restrição | **Você** |
| **Teste com pessoa** (observar comportamento numa tarefa) | **Você** |
| **Verificação de critério** (checar objetivamente o que a especificação exigiu) | QA |
| Como o usuário atravessa o fluxo | **Você** |

Perfil de uso **descreve** um ator que o PO já definiu; não cria ator novo nem permissão nova. Se o perfil que você precisa desenhar não existe no requisito, isso é escalação ao PO — não um personagem inventado na jornada.

Levantar cedo custa uma pergunta; descobrir na implementação custa a Task inteira.

## 8. Repertório de padrões consolidados — não inventar o que já está resolvido

Antes de desenhar um padrão do zero há duas fontes, nesta ordem: **a convenção que o produto já ensinou ao usuário** (§3) e, quando ela não existe, o **repertório consolidado dos sistemas de design maduros** — o *Material Design* é o mais completo e documentado, e é dele que vem a maior parte do vocabulário abaixo.

**A referência é do padrão, não da biblioteca.** Adotar o comportamento que o padrão descreve não obriga o projeto a instalar implementação nenhuma, nem a se parecer com nada: a stack e a direção visual estão declaradas no contexto do projeto e na decisão do stakeholder. Quando a convenção do produto contradiz o repertório, **a convenção vence** — e a especificação diz por quê.

| Frente | O que o repertório já resolve | Quando recorrer |
|---|---|---|
| **Estados de interação do controle** | repouso, hover, foco, pressionado, selecionado, desabilitado | sempre — é a lista mínima que a especificação declara |
| **Hierarquia de ação** | uma ação primária por tela; secundária sem peso de primária; destrutiva confirmada e nunca colada na primária | tela com mais de dois botões |
| **Comunicação transitória** | efêmera que não bloqueia e some sozinha × aviso persistente que fica até resolver × diálogo que bloqueia e exige decisão | toda mensagem de resultado, erro ou confirmação |
| **Feedback de espera** | indicador determinado quando há progresso conhecido; indeterminado quando não; esqueleto quando a estrutura já é conhecida | todo ponto de espera do mapa de jornada |
| **Navegação** | persistente × contextual × retorno; e onde mora o "onde estou" | fluxo com mais de duas telas |
| **Ritmo visual** | grade de espaçamento com um múltiplo único; escala tipográfica com poucos degraus nomeados; agrupar por superfície em vez de borda em tudo | tela nova, antes de inventar medida |
| **Formulário e entrada** | rótulo persistente (nunca só placeholder), texto de ajuda, erro junto ao campo, validação no momento certo | toda entrada de dado |

E as **heurísticas de usabilidade** — o vocabulário com que se nomeia o *critério violado* numa revisão, em vez de opinar: visibilidade do estado do sistema · correspondência com o mundo real · controle e liberdade para desfazer ou sair · consistência e padrões · prevenção de erro · reconhecer em vez de lembrar · flexibilidade e atalho · design minimalista · ajudar a reconhecer, diagnosticar e recuperar do erro · ajuda e documentação.

### Os dois eixos de estado que não se confundem

| Eixo | Do quê | Quais |
|---|---|---|
| Os seis estados (§2) | da **tela** e do dado que ela mostra | vazio · carregando · sucesso · erro · sem permissão · volume extremo |
| Estados de interação (§8) | de **cada controle** dentro da tela | repouso · hover · foco · pressionado · selecionado · desabilitado |

Uma tela em pleno estado de sucesso pode ter um botão invisível em repouso. O modo de falha é sempre o mesmo: a afordância existe no código e some na tela, porque a especificação descreveu só o que acontece **depois** do clique.

**Como se verifica:** percorrer a tela com Tab e com o ponteiro — todo controle é visível e identificável em repouso, distinguível quando focado, e o desabilitado diz por que está desabilitado. Sem consultar o código.

## 9. Método de pesquisa e prototipação — etapa acionada por gatilho

O método que o *Google UX Design Certificate* sistematiza — **empatizar · definir · idear · prototipar · testar**, com iteração — é o repertório completo do papel. Rodá-lo inteiro em toda Task afogaria um time pequeno; ignorá-lo é desenhar no escuro. A régua é a mesma do dimensionamento: **cada etapa é acionada por um gatilho objetivo, e o default é desenhar a partir do requisito e do critério de aceite do PO.**

| Etapa | O que produz | Gatilho objetivo | Sem o gatilho |
|---|---|---|---|
| **Pesquisa com usuário** | comportamento observado, com participante, data e nº | fluxo novo cujo público o time nunca observou, ou dois papéis discordando sobre o que o usuário faz, com a discordância registrada por escrito (ata, relato ou changelog) | requisito do PO + inspeção das telas existentes |
| **Perfil de uso** (persona) | familiaridade, contexto e restrição do ator já definido pelo PO | uma mesma tela servindo a dois perfis com objetivos diferentes | o campo **Ator** do mapa de jornada basta |
| **Referência externa** (auditoria de padrão) | como o problema já é resolvido fora | padrão ausente do produto **e** ausente do repertório (§8) | reaproveitar (§3) |
| **Definição do problema** | uma frase ligando requisito a comportamento observável | a tela existe e o usuário não completa a tarefa | o objetivo em uma frase da especificação |
| **Ideação** | mais de uma alternativa antes de fechar | decisão de navegação difícil de reverter, ou tela que concentra o fluxo inteiro | alternativa única, com o motivo escrito |
| **Baixa fidelidade** | estrutura, hierarquia e ordem de leitura | tela nova ou reorganização de layout | especificação textual |
| **Alta fidelidade** | fluxo navegável com conteúdo real | mais de três telas encadeadas, espera longa a validar, ou interação que o texto não consegue explicar | especificação é o entregável |
| **Teste de usabilidade** | tarefa, taxa de conclusão, ponto de travamento | fluxo crítico do produto antes de virar padrão, ou achado 🔴 que reaparece em ≥ 2 revisões consecutivas da mesma tela | revisão por inspeção, declarada como inspeção |
| **Iteração** | o que mudou e por causa de qual achado | qualquer etapa acima que produziu achado | — |

Três regras transversais:

1. **Nomear a etapa e o gatilho na saída.** Sem isso ninguém distingue desenho apoiado em evidência de desenho apoiado em suposição — e os dois custam o mesmo para implementar.
2. **Pesquisa declarada é pesquisa feita.** Sem participante real, o que houve foi **inspeção**, e se escreve assim. "Os usuários preferem", "o usuário espera" sem participante, data e número é invenção — e contamina toda decisão que se apoiar nela depois. *(É a R7 — "sem evidência, não aconteceu" — aplicada ao território do desenho.)*
3. **Artefato de pesquisa só vira permanente com lugar declarado** no contexto do projeto. Perfil de uso que ninguém mantém envelhece e passa a mentir com autoridade.

**Como se verifica:** o `context.md` do projeto lista cada artefato de pesquisa permanente e quem o mantém; artefato fora dessa lista é achado de processo contra quem o criou.

### Fidelidade: o que cada nível fixa

| Nível | O que fixa | O que ainda **não** fixa |
|---|---|---|
| **Baixa** | blocos, hierarquia, ordem de leitura, o que cabe na tela | cor, tipografia, microcópia final, animação |
| **Alta** | fluxo entre telas, conteúdo real, estados percorríveis | estrutura de código e implementação |
| **Só especificação** | tudo em texto, quando a tela reaproveita padrão existente ponta a ponta | — |

Subir de fidelidade antes de a estrutura estar acordada é o retrabalho mais comum do papel: discute-se cor quando o problema era ordem de leitura. **Protótipo, em qualquer nível, é exploração — nunca código de produção.**

## 10. Verificar o protótipo sem pagar a verificação duas vezes

Protótipo entregável — o funcional do ① e o do sprint — não se declara pronto: ele é **exercitado**. A verificação executável — o *harness*: um script sem interface que abre cada tela, percorre cada caminho e confere cada critério, no runtime declarado no contexto do projeto — é a evidência de R7 no meu território. Ela é também a coisa mais cara que eu rodo. As três disciplinas abaixo cortam o custo sem tocar no rigor: as duas primeiras, **o que é executado**; a terceira, **o que volta ao meu contexto** depois de executado.

### Checkpoint: verificação interrompida não volta ao zero

Harness completo de um protótipo inteiro é trabalho longo, e trabalho longo é interrompido — limite de sessão, corte de chamada, fim do dia. Sem registro, a retomada recomeça da primeira tela e joga fora tudo o que já tinha passado. É a R5 ("interrupção é estado, não perda") aplicada à verificação.

**A disciplina:** a cada **tela ou fluxo concluído**, gravar o resultado parcial em disco — não ao final, não em memória. O registro é **append-only** — uma linha por tela/fluxo verificado, com a versão do protótipo, os critérios exercitados, o veredito e o que falhou — e vive **ao lado do protótipo que ele exercitou**: `prototype/verification-log.md` para o funcional, `prototype/sprint-<n>/verification-log.md` para o do sprint. Um registro por artefato; somar os dois num arquivo só confundiria qual protótipo passou.

Na retomada: ler o registro, rodar **só o que ainda não tem linha** e continuar a mesma execução. Duas invalidações — quando o checkpoint deixa de valer e a verificação volta a ser completa:

- **o protótipo mudou de versão** desde a linha gravada — o que passou passou sobre outro artefato;
- **a linha não diz qual critério foi exercitado** — registro sem critério nomeado não é checkpoint, é lembrança.

**Como se verifica:** o registro existe com linhas anteriores ao corte, e a retomada não repete tela que já tem linha da mesma versão. Verificação que terminou sem registro parcial é indistinguível de verificação afirmada — e vale o mesmo que ela.

### Modo leve: reduzir o escopo executado, nunca a evidência

**É a R23 no meu território.** A primeira entrega paga o harness completo; ajuste sobre protótipo **já verificado por um harness completo** paga só o que a mudança alcança.

| Situação | Escopo do harness |
|---|---|
| Primeira entrega do protótipo funcional, fatia nova, ou **primeiro** protótipo de sprint do projeto | **Completo** |
| Ajuste pontual no funcional (tela nomeável, rótulo, conteúdo, um passo) | **Leve** — telas alteradas mais a vizinhança de navegação de um salto |
| Mudança transversal (paleta, tipografia, grade, componente compartilhado, navegação persistente, estrutura de arquivos), ou telas afetadas que não se consegue **nomear** | **Completo**, ainda que o diff seja de uma linha |
| Sprint: tela reaproveitada de protótipo verificado por completo, sem alteração | **Leve** — só os saltos que entram e saem dela |
| Sprint: tela nova ou alterada para caber no caminho; componente de navegação criado para a costura | **Completo** nela / no componente |
| Sprint: recostura depois de pacote devolvido | **Leve** sobre o que a devolução alcançou; **completo** se ela mudou o fluxo ponta a ponta |

No sprint o leve é o caso comum: exercita-se **o caminho costurado** (cada salto do fluxo ponta a ponta, os estados de exceção que ele atravessa e as telas nascidas na costura), não as telas uma a uma.

**Guarda-corpo, nos dois protótipos:**

1. **Roda de verdade.** Leve reduz *quantas* telas; não troca execução por leitura de código. Tela sem saída real é **não exercitada** (R7). O **fluxo ponta a ponta do sprint roda em toda rodada** — ele sustenta a verificação de valor (R25 (b)).
2. **O que não rodou é declarado:** a ficha nomeia as telas executadas e aponta a verificação completa que cobre o restante (data e versão).
3. **Portão nenhum muda** (R23): ① e ③ continuam exigindo o stakeholder navegando; os seis estados e os critérios de acessibilidade continuam exigidos por tela.
4. **Não se acumula:** depois de **três** rodadas leves seguidas sobre a mesma versão base, a próxima é completa. No sprint a contagem é **por pasta** `sprint-<n>/`, e recostura conta como rodada.

**Como se verifica:** o registro mostra, por rodada, modo, justificativa de alcance, telas executadas e a contagem de leves desde a última completa. Leve declarado com mudança transversal, quarta leve seguida, ou **protótipo de sprint sem linha de execução do fluxo ponta a ponta**, é reprovação de método.

### Delegar a execução e trazer de volta só o que decide

**É a R28 no meu território** — a regra geral manda cada papel que roda esse tipo de comando detalhar, no próprio `skills.md`, o que extrair da saída antes de descartar o resto. **Alcance honesto: vale para o harness, e só para ele.** Dos modos do papel, apenas `/ux prototype` e `/ux prototype sprint` executam alguma coisa; jornada, especificação de tela, protótipo de tela sem ambiente e revisão de usabilidade não rodam comando nenhum, e nada desta seção se aplica a eles.

**Quem roda.** Harness **completo** é execução pesada — R5 já o equipara ao spike do Arquiteto — e vai para o agente `operator`: uma invocação, um trabalho, um relatório. Harness **leve** vai pelo mesmo caminho, porque é ele que dá endereço ao `report` e porque delegar duas telas custa menos que engolir a saída delas. **Não reexecuto o harness para conferir o que o `operator` devolveu** — leio o trecho e o ponteiro. O que não muda de dono é o **veredito**: o `operator` executa, quem declara uma tela exercitada sou eu.

**O que trago de volta — o que conta como "falha relevante" aqui.** Cinco coisas, e nada mais:

| O que extraio | Por que sem isso o achado não fecha |
|---|---|
| **Tela · estado · critério nomeado** de cada asserção que falhou | é o que a linha do `verification-log.md` exige; sem o critério nomeado o registro não é checkpoint, é lembrança |
| **Medido × exigido**, quando o critério é numérico (contraste 3,8:1 × ≥ 4,5:1; alvo 32×32 × ≥ 44×44) | o número é o que torna o achado corrigível sem rodar de novo |
| **O elemento e o arquivo** onde a asserção parou | localiza a correção; sem ele, a próxima rodada procura |
| **O salto que não resolveu**, como par origem → destino | é a falha típica da costura do sprint, e a que derruba o fluxo ponta a ponta |
| **Os totalizadores:** telas percorridas, asserções passadas × falhadas | é o que preenche a ficha e prova que o escopo executado foi o escopo declarado |

Fica no log e **não** volta: a linha de "ok" de cada asserção que passou — que é a esmagadora maioria e quase todo o volume —, dump de DOM, ruído do navegador sem interface e eco de instalação do runtime.

**Trecho e ponteiro, sempre os dois.** A ficha do protótipo traz, ao lado do checkpoint, o caminho do `report` do job (`report.md`, ou `report-<log>.md` quando há mais de uma chamada na pasta) — é o ponteiro; a linha do `verification-log.md` carrega o mesmo ponteiro. Ponteiro sem trecho não deixa ninguém decidir; trecho sem ponteiro não deixa ninguém conferir.

**Quando abro o log bruto assim mesmo.** Os gatilhos de aprofundamento obrigatório são os de **R28** — lista canônica lá, não repetida aqui. Fora deles, abrir o log é opção minha, não obrigação.

**Veredito `inconclusivo` não aprova nada.** Tela cujo relatório voltou inconclusivo é **não exercitada** (R7), com o motivo escrito — nunca ✅ no `verification-log.md`, nunca coberta por um "o restante está coberto pela verificação completa de".

**Retrato da chamada — seção "Execução delegada".** No relatório final (a ficha do protótipo), retrato cada chamada ao `operator`, uma linha por chamada, na seção "Execução delegada" — colunas no modelo ([`functional-prototype.md`](templates/functional-prototype.md)) —, com os números que a chamada devolveu ao terminar. Número que não veio: "não disponível — <motivo>", nunca estimado (R7). Sem chamada: "nenhuma". **Não gravo em `consumption.md`** — a sessão que me disparou transcreve as linhas. Serve para mostrar, por Task, o consumo meu × o do `operator` (a economia da delegação, R28).

**Como se verifica:** ficha com rodada declarada e sem o caminho do `report` do job, ou com `report` que não existe ou passa de 200 linhas / 20 KB, é achado de processo — **log bruto podado não é**, e, se um gatilho de R28 dispara com o log podado, re-rodo o job pelo `operator` ou registro "não verificado — log podado" (R7); linha ❌ no `verification-log.md` sem trecho extraído, ou com trecho e sem ponteiro, idem; harness completo rodado inline em vez de delegado ao `operator` é achado contra mim (R28); relatório com chamada ao `operator` e sem a seção "Execução delegada" (ou com número estimado) idem; e tela com veredito `inconclusivo` contada como exercitada é reprovação de método, não ressalva.
