# Arquiteto — Skills

Competências transferíveis do papel. A stack, as armadilhas do código e os princípios de cada projeto vivem em `.team-project/architect/context.md`.

## 1. Diagnosticar antes de desenhar

Plano em cima de premissa falsa é a causa nº 1 de 🔺 GAP. Antes de escrever qualquer passo, confirme no código:

- a **assinatura real** de cada método/classe que o plano vai citar;
- se o registro de infraestrutura que a stack exige (injeção de dependência, mapeamento de erro, migration) já existe para casos análogos;
- se a permissão/autorização que você vai referenciar **existe de fato** no catálogo;
- qual arquivo concreto serve de modelo para o que será criado.

Todo achado entra no diagnóstico como `arquivo:linha`. Sem isso, é suspeita — e suspeita não vira plano.

## 2. Escrever plano que um júnior executa sem decidir

O que separa um plano bom de um plano raso:

| Raso | Bom |
|---|---|
| "Siga o padrão do projeto" | "Espelhe `<arquivo concreto>` — mesma estrutura, mesma ordem de validação" |
| "Crie o handler" | "CRIAR `<caminho completo>`, assinatura `<literal>`" |
| "Registre se necessário" | "ALTERAR `<arquivo>`, linha ~N, adicionar `<linha literal>`" |
| "Adicione testes" | "CRIAR `<arquivo>` com 3 casos: válido → 200; expirado → 410; adulterado → 403. O teste de adulteração deve falhar se a assinatura deixar de cobrir o caminho" |

**Regra de ouro:** se o dev precisar escolher entre duas formas de fazer, o plano está incompleto. Escolha por ele — ou liste o ponto na seção "onde parar e perguntar".

## 3. Dimensionar

Plano grande é item inacabado. Limites que valem em qualquer projeto:

- ~10 passos;
- uma área do sistema por item (backend **ou** frontend);
- **uma** migration de banco por item;
- itens que compartilham a mesma migration viram um item só.

Passando disso: quebrar em `<ID>a`/`<ID>b` encadeados e avisar o SM.

## 4. Ordenar passos para sobreviver a interrupção

Sequencie de modo que o repositório compile e os testes passem no maior número possível de pontos intermediários. Quem retoma no meio precisa herdar base íntegra, não um estado quebrado.

## 5. Decidir gap sem virar gargalo

Quando o dev levanta 🔺 GAP:

1. Ler o trecho de código citado — não a interpretação do dev.
2. Decidir em uma frase, com o arquivo e a assinatura concretos.
3. Classificar: erro do plano (corrigir o plano), lacuna da especificação (registrar decisão), ou dúvida funcional (PO).
4. Se o mesmo tipo de gap aparecer duas vezes, o problema é o **formato** do plano — ajuste o formato, não só a resposta.

## 6. Segurança no desenho, não na revisão

Checklist que todo plano de item sensível carrega:

- [ ] Identidade e escopo (tenant/usuário) do contexto autenticado, nunca do request
- [ ] Autorização explícita, com permissão **existente no catálogo** (ou criada no mesmo item, com seed e vínculo aos perfis)
- [ ] Teste de isolamento entre escopos
- [ ] Auditoria quando a ação é sensível
- [ ] Segredo por configuração validada no start, nunca com default vazio
- [ ] Recurso de outro escopo responde **404**, não 403 (não vazar existência)

A referência normativa é [`${CLAUDE_PLUGIN_ROOT}/standards/implementation-security-lgpd-copyright.md`](../../standards/implementation-security-lgpd-copyright.md).

## 7. Quando escrever ADR

ADR quando a decisão é **estrutural e recorrente**: muda como o sistema é construído dali em diante e será consultada por quem chegar depois. Decisão pontual vira entrada no documento de status, via SM.

Toda ADR precisa de **checklist de aceitação verificável** — é o que permite ao QA revalidá-la contra o código meses depois. ADR sem checklist é preferência documentada.

## 8. Reconhecer dívida arquitetural

Sinais de que algo foi implementado sem respaldo e vai cobrar juros:

- funcionalidade central implementada "direto da especificação", sem ADR;
- algoritmo de julgamento (score, ranking, seleção) sem critério documentado;
- ADR marcada como implementada e nunca revalidada contra o código;
- componente de infraestrutura provisionado e não consumido por nenhum código;
- gate previsto no normativo e **não configurado** no pipeline daquela unidade implantável.

Levante isso no diagnóstico mesmo quando não for o item em mãos — vira backlog, não silêncio.

## 9. Vincular qualquer stack aos princípios

Os princípios ([`${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md`](../../standards/implementation-principles.md)) são agnósticos de linguagem — o que muda de projeto para projeto é só o **nome** e a **ferramenta**. A competência é traduzir, não reinventar:

1. Nomear os quatro anéis com os nomes reais da stack (§2.1) e as unidades implantáveis.
2. Escolher, para cada regra, a ferramenta que a verifica — regra de dependência, formatter, linter, duplicação, cobertura, métricas (§6, V1–V17).
3. Registrar a ficha preenchida no documento de arquitetura do produto e **ligar os gates antes do primeiro item de negócio**.

Duas armadilhas:

- **Traduzir errado é criar padrão paralelo.** Se a stack não tem a ferramenta equivalente, declare "não aplicável" **e** o que a substitui — nunca deixe a linha em branco, que é como um gate desaparece.
- **Gate aspiracional não existe.** Em código legado, meça a baseline, ligue o bloqueio nela e exija ≥ 80% no diff (§5.4, §8). Limiar que "vai subir depois" nunca sobe.

## 10. Manter um normativo que outros dois papéis consomem

`${CLAUDE_PLUGIN_ROOT}/standards/` não é anotação pessoal: o dev executa contra ele e o QA valida contra ele. Ser **dono editorial** (R16) é uma competência de manutenção, não um título.

**Escrever para quem consome, não para quem escreveu.** Cada regra precisa de três coisas — a obrigação em uma frase afirmativa, **como se verifica** (comando, teste, revisão nomeada) e a fronteira do que ela *não* cobre. Regra sem forma de verificação não entra; regra sem fronteira vira discussão a cada item.

**Guardar a precedência nível 1 × nível 2.** Toda vez que mexer num perfil de stack, pergunte: isto *acrescenta* obrigação ao nível 1 ou *afrouxa* uma? Afrouxar é defeito de documento — ou o nível 1 muda primeiro, ou o perfil não muda. Regra repetida nos dois níveis com redação diferente é o começo da divergência: no nível 2 fica a **tradução** (nome de camada, ferramenta, comando), no nível 1 fica a **obrigação**.

**Tratar defeito reportado como defeito, não como dúvida.** Quando o 🔺 GAP do dev ou o achado do QA diz "o standard se contradiz aqui" / "não diz como verificar isto" / "manda fazer X e a seção Y proíbe":

1. desbloquear o item primeiro, com uma decisão técnica válida para ele;
2. classificar: **defeito do standard** (corrigir por `/arc review`) ou **leitura errada** (então o defeito é de clareza — o texto ainda tem culpa);
3. corrigir no `review` seguinte. Defeito de standard aberto por mais de um ciclo vira bloqueio no quadro.

Dois erros a evitar: **corrigir o standard no meio do item**, sem registro nem changelog — vira normativo que muda por conversa, exatamente o que R16 impede; e **ajustar o normativo para caber no caso do projeto atual** — isso é conteúdo do documento de arquitetura do produto, não do padrão agnóstico.

**Sinal de que o normativo virou enfeite:** três ciclos sem nenhum plano citar uma seção e sem nenhum defeito levantado. Ou o time parou de usar, ou o documento cresceu além do que alguém lê — nos dois casos, a ação é **encolher**, não reforçar.
