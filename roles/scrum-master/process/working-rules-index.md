# Índice das regras de trabalho — o que conferir (R1–R31)

> **Dono:** SM · **Derivado de [`working-rules.md`](working-rules.md)** — que continua sendo o normativo. Este índice existe para o **`/sm close`** e para a conferência a cada Task: uma linha por regra, com **o que conferir**, sem o texto da regra nem o "Evita". **Divergência entre este índice e a linha "SM verifica" da regra: vale a regra**, e o índice é corrigido no mesmo ciclo (R12). Abra `working-rules.md` na regra só quando a linha apontar violação ou dúvida.

## Quando percorrer

- **A cada `/sm close <T-ID>`:** as linhas marcadas **[close]**. Violação vira nota na coluna de notas da Task e ação corretiva no sprint seguinte; **não** bloqueia a entrega já feita (exceto R7 e R12, que bloqueiam o fechamento).
- **Na retrospectiva:** todas, junto com a tabela de indicadores de `working-rules.md` "Como o SM aplica".

## Eficiência

| Regra | Conferir |
|---|---|
| R1 · uma Task por vez **[close]** | no máximo uma Task em construção por dev disponível |
| R2 · Task cabe em uma unidade **[close]** | estimativa dentro da unidade; Task que estourou 2× a estimativa vira alerta na retrospectiva |
| R3 · contexto mínimo | plano lista "contexto de código a ler" com caminho e porquê; papel reinvocado sobre o mesmo tópico cita **o que mudou** desde a última leitura |
| R4 · não antecipar escopo **[close]** | relatório do dev com "Não fiz (fora do plano)" preenchido; diff × lista de arquivos do plano; entrada fora da Planning com "o que saiu para caber" |
| R5 · interrupção é estado | relatório com "Parei no passo"; Task inacabada volta ao Product Backlog com a História; verificação pesada deixa artefato em disco por etapa; relatório que não chegou tem o estado em disco lido antes de reinvocar |
| R6 · decisão registrada **[close]** | toda Task fechada com desvio tem a entrada correspondente |
| R28 · saída pesada em arquivo, execução pesada no `operator` **[close]** | trecho extraído **e** ponteiro do job (`operator/<sprint>/<job>/` ou `operator/pre-sprint/<job>/`), sempre juntos; `report` do job ≤ 200 linhas · 20 KB, um `report-<log>.md` por chamada na mesma pasta; log bruto podado não é achado (gatilho disparado → re-rodar pelo `operator`); build de fim de passo do dev isento de `report`; execução pesada nunca inline por Arquiteto, QA ou dev; contagem de chamadas × linhas `operator` (do sprint e de `.team-project/consumption.md`) fecha |
| R29 · fase heterogênea em sessão nova | o relatório que abre fase diferente não cita diagnóstico de fase já fechada verde; no consumo, a transição é bloco de invocação novo |

## Qualidade

| Regra | Conferir |
|---|---|
| R7 · sem evidência, não aconteceu **[close]** | bloco no registro de evidências com comando e saída; critério de aceite demonstrado na Review aponta a evidência da Task — **bloqueia o fechamento** |
| R8 · sem plano, sem código **[close]** | existe plano para toda Task em construção |
| R9 · gap vira pergunta **[close]** | gap respondido; decisão refletida no plano (não só em prosa); gap sem resposta há mais de um sprint vira bloqueio; quem respondeu não reproduziu a verificação do QA |
| R10 · nomenclatura é contrato | achado de nomenclatura no veredito conta como reprovação, não ressalva |
| R11 · segurança no plano | Task sensível sem seção de segurança no plano não entra em construção |
| R12 · documento vivo no mesmo ciclo **[close]** | atualizações feitas pelos donos (campo "Documentos vivos (R12)" do veredito); Review sem os gaps registrados não encerra o sprint — **bloqueia o fechamento** |

## Método

| Regra | Conferir |
|---|---|
| R13 · instrumento pelo gatilho | História > 3× a unidade, status com > 5 riscos, ou mudança de baseline/contrato: a saída traz o instrumento formal **ou** a justificativa de por que o Scrum basta |
| R14 · onboarding antes de `prepare`/Planning | primeira Planning cita o registro de onboarding; checklist completa; `.team-project/README.md` §4 e §7 preenchidos e datados; divergência status × código é linha de risco |
| R15 · brainstorm, `/sm sdd` e portões ①② | requisito novo rastreia brainstorm ou `/po analyze`; SDD elaborado por `/sm sdd` (estado em `context.md` §"SDD em elaboração"); portão dispensado só com delta nulo declarado pelo dono; fases 1 (sem Arquiteto) e 2; protótipo funcional com registro de navegação datado; `03/04/05` não antes do ①, História não antes do ② |
| R16 · standards como base | plano cita a seção de standard aplicável; desvio de standard = reprovação; defeito do próprio standard chega ao `/review` seguinte |
| R17 · changelog do processo | bloco `## vX.Y` medido em bytes UTF‑8 dentro da barreira da rodada (10 KB até dois papéis, +2,5 KB por papel, teto 20 KB); só as três entradas mais recentes no arquivo vivo |
| R18 · entrega versionada | merge em `develop` com bump em `plugin.json` = entrada topo do `CHANGELOG.md` = banner do `README.md`; par `vX.Y` entre `process-changelog.md` e `CHANGELOG.md` |
| R19 · evidência do `/review` | entrada do changelog do processo com bloco de evidência; reexecutar um comando por amostragem |
| R20 · História × Task **[close]** | toda Task com História de origem; História detalhada antes da quebra; **nenhuma Task em construção antes da data do pacote aprovado**; detalhamento sem arquivo/classe/endpoint; Product Backlog só índice com ponteiro |
| R21 · aceite por História **[close]** | nenhum aceite fora da Review; todo aceite cita por critério a evidência da Task; ressalva virou Task com dono; nenhum `/po accept` mira Task |
| R22 · pergunta e decisão de portão em formulário | alternativas descritas + recomendação + "pedir mais contexto" por último; decisão de portão ①–④ chegou em `AskUserQuestion`, não em texto corrido (achado contra a orquestração); ③ registrado no Sprint Backlog, ④ em `review.md` |
| R23 · modo leve | entrega "leve" declara o que foi e o que não foi reexecutado; nenhum gate do §8 pulado; nunca na primeira entrega |
| R24 · transições e burndown **[close]** | `/sm close` tem linha no Registro de transições (Para ✅, data); burndown não cai sem linha de fechamento; `/sm board` que muda marcador grava a linha |
| R25 · unidade de aprovação e entrega **[close]** | pacote aprovado (data, quem, decisão, ponteiro do protótipo); `planning.md` com o que não entrou e por quê; protótipo cobre fluxo ponta a ponta; degrau nomeado em cada bloqueio; `stories/` congelado; nenhum gate do §8 dispensado pelo ciclo |
| R26 · plano mede o ambiente | seção de ambiente medido (comando e saída, próprios ou do `operator` com caminho do log) antes dos passos; comando citado validado; "onde parar" cobre pré-requisito **ausente** |
| R27 · falha de invocação | retentativa e texto literal do harness; nenhum relatório atribui ao stakeholder interrupção sem ação dele registrada |
| R30 · cenários mapeados **[close]** | Task com cenários novos + regressivos aplicáveis (ou "nenhum aplicável", com motivo) antes da construção; veredito traz o resultado de cada um; GAP que bloqueia História em voo vira Task no sprint; GAP não-bloqueante tem par no Product Backlog (escrito pelo PO) |
| R31 · git só com o produto | `git ls-files .team-project` vazio e `.gitignore` com `.team-project/`; `docs/` (e os modelos que o geram) sem caminho `.team-project/` |
