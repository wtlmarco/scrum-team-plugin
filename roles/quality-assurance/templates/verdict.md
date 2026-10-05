# Template — Veredito de QA (`/qa <ID>`)

```markdown
## QA — <ID> <título> — <data>

**Veredito:** ✅ Aprovado | ⚠️ Aprovado com ressalva | ❌ Reprovado

| Frente | Resultado | Evidência |
|---|---|---|
| Requisito | ok / falha | <critério + como verifiquei> |
| Especificação técnica | ok / falha | **Duas tabelas** abaixo, sempre as duas: **"passo do plano × conforme"** (objeto 1, aderência de execução) e **"seção exigida pela Task × seção citada"** (objeto 2, 4 estados) |
| Segurança | ok / falha / n/a | <arquivo:linha ou teste> |
| Testes / métricas | ok / falha | <trecho decisivo do comando de teste **e** do gate de cobertura — ponteiro do `report` em "Comandos executados"> |
| Documentação | ok / falha | <arquivo atualizado — detalhe em "Documentos vivos (R12)" abaixo> |
| Desempenho | dentro do orçamento / fora / não exercitado | <trecho decisivo do comando V19 — ponteiro do `report` em "Comandos executados" · ou o motivo do "não exercitado"> |

### Frente 2 — os dois objetos, sempre os dois (`workflow.md` §4a)
*(Task não fecha sem as duas tabelas abaixo preenchidas — DoD §4a-i)*

**Objeto 1 — passo do plano × conforme** *(aderência de execução; critério = o campo **Conferência** de cada passo do plano — [`implementation-plan.md`](../../architect/templates/implementation-plan.md) R13 — não julgamento próprio do QA)*

| # do passo do plano | Campo Conferência do plano | Conforme? | Evidência |
|---|---|---|---|
| <n> | <literal do campo **Conferência** do passo> | conforme / divergente / **inconferível sem decidir** | `arquivo:linha` quando divergente |

Divergência volta **direto** a `/dev resume`, sem Arquiteto. **Passo sem Conferência decidível** (o critério não basta para marcar conforme/divergente sem julgamento de desenho) é defeito do **plano**, não achado de execução: 🔺 **GAP** → `/arc question` (R13).

**Objeto 2 — seção exigida pela Task × seção citada no plano** *(completude/correção do standard citado; objeto = normativo `${CLAUDE_PLUGIN_ROOT}/standards/` + completude do plano ante a Task)*

| Área de engenharia | Seção que a Task exigia | Seção citada no plano | Estado | Volta para |
|---|---|---|---|---|
| <ex.: atomicidade de transação> | `<arquivo> §<n>` | `<arquivo> §<n>` ou "nenhuma" | citada e aplicada (ok) / citada e divergente (❌ R16) / exigida e ausente do plano / citada errada | — / dev (`/dev resume`) / `/arc question` (`/review`) / `/arc question` (`/review`) |

**Reverificação independente da interseção:** cada linha "citada e aplicada" teve a aplicação conferida neste veredito (`arquivo:linha` nos Achados quando divergente) — verificação própria, não a alegação do relatório do dev nem de qualquer auditoria anterior.

### Cenários de teste — resultado por cenário mapeado (R30)
*(Task não fecha sem esta tabela preenchida para todo cenário referenciado na Task do Sprint Backlog — DoD §4a-i. "Nenhum mapeado" só é válido quando a própria referência da Task já dizia isso, com o motivo.)*

| SC-nnn | Tipo | Resultado | Forma | Evidência |
|---|---|---|---|---|
| SC-<nnn> — `.team-project/quality-assurance/scenarios/SC-<nnn>-<slug>.md` | novo / regressivo | ✅ passou / ❌ falhou / ⚠️ não executado — <motivo> | manual / navegador / script | <trecho decisivo + ponteiro do `report` (execução pesada/lote via `operator`, R28), ou o que faltou> |

Cada linha desta tabela é também gravada no **Histórico de execuções** do próprio arquivo `SC-<nnn>` ([`templates/scenario.md`](scenario.md)) e reflete o "Último resultado" do índice ([`templates/scenarios-index.md`](scenarios-index.md)) — os três nunca divergem sobre a mesma execução.

**Cenário falhou (❌) — roteamento pelo bloqueio, não pela criticidade (R30):**

| GAP compromete a História em voo? | Caminho | Onde registro |
|---|---|---|
| **Sim, bloqueia** | Vira Task da mesma História, no sprint corrente (R25 · `workflow-sprint.md`, "Durante o sprint") | Entrada nos Achados abaixo, `Volta para: /sm` (SM registra a entrada fora da Planning) |
| **Não bloqueia** | Ganha entrada no Product Backlog, escrita pelo **PO**, no mesmo ciclo (R12) | GAP em `pending.md` com **ID: <MÓDULO-NN>** → **roteado ao PO** nesta linha; o PO abre a linha do Product Backlog citando este ID |

### Comandos executados
*(um bloco por comando; comando pesado — build, suíte, cobertura, lint do projeto inteiro, carga V19 — é delegado ao `operator`, R28. Comando leve, cuja saída já cabe sem inflar o contexto, roda direto e traz só o comando/saída, sem log próprio.)*
```
> <comando>
<trecho decisivo, verbatim>
```
**Relatório do `operator`:** `.team-project/operator/<sprint>/<job>/report.md` (ou `report-<log>.md`) · log bruto, disco local, pode ter sido podado: `<arquivo>.log` — <n> linhas *(ou "n/a — comando leve, sem `operator`")*
*(repetir o par comando/trecho + relatório do `operator` para cada comando executado)*

### Execução delegada
*(uma linha por chamada ao `operator`, com os números que a chamada devolveu ao terminar. Sem número: "não disponível — <motivo>", nunca estimado (R7). Sem chamada: "nenhuma". Não grava em `consumption.md` — a sessão que disparou o QA transcreve.)*

| Operator job | Task/História | Modelo | Tokens | Duração |
|---|---|---|---|---|
| `.team-project/operator/<sprint\|pre-sprint>/<job>/` | <T-ID / H-ID> | <`model:` de `agents/operator.md`> | <n ou "não disponível — motivo"> | <tempo ou "não disponível — motivo"> |

### Achados
| # | Gravidade | Tipo | O quê | Onde | Impacto | Volta para |
|---|---|---|---|---|---|---|
| 1 | 🔴/🟠/🟡/🟢 | código / processo | <defeito> | <arquivo:linha> (+ `<standard> §n` se `processo`) | <consequência> | dev / `/sm` / arquiteto / po / `/review` |

### Suspeitas (sem evidência conclusiva)
- <o que parece errado e o que falta para confirmar>

### Escopo
**Fora do plano:** nada | <lista de arquivos tocados além do previsto — R4>  *(diff × lista de arquivos do Plano, frente 2; transcrito ao bloco da evidência — o C1 lê esta linha)*
**Desvio aceito:** <aaaa-mm-dd — quem decidiu — onde está a decisão>  *(só com arquivo em "Fora do plano" e decisão registrada — Arquiteto, se técnico e incluído no plano; stakeholder por formulário, se muda escopo; sem decisão, omitir: o desvio segue achado. Na trilha `fix` não existe — arquivo fora do mini-plano é promoção)*

### Não exercitado
- <o que ficou sem validação e por quê>

### Documentos vivos (R12)
**Estado:** atualizados | pendentes  *(o `/sm sprint run` só fecha a Task com "atualizados" — `sprint-run.md` passo 7; ausente, vazio ou "pendentes" não fecha)*

| Documento | Dono | Atualizado? | Ponteiro |
|---|---|---|---|
| Inventário de código (`03-code-map`) | QA | sim / não | `arquivo:linha` |
| Registro de GAPs (`pending.md`) | QA | sim / não (fechado / aberto) | ID |
| Evidência da Task | QA | sim / não | `.team-project/sprints/<n>/evidence/<T-ID>.md` |
| Suíte de cenários — Histórico de cada `SC-nnn` mapeado e índice (`scenarios/README.md`) | QA | sim / não | `SC-nnn` |
| SDD funcional / técnico / ADR que a Task tocou | PO / Arquiteto | sim / não / n/a | arquivo (dono nomeado se "não") |

*(Qualquer "não" ⇒ Estado "pendentes", com o dono do documento na linha — devolve a ele, não ao dev. O Estado e uma linha com os documentos são transcritos ao bloco da evidência (`evidence.md`) — o C1 lê `### Documentos vivos (R12)` / `**Estado:**` lá.)*
```

## Regras

- **Executar antes de opinar** (R7). Veredito sem trecho decisivo **e** ponteiro do `report` (quando a verificação foi delegada ao `operator`, R28) não é veredito — comando leve, sem `operator`, traz o comando e a saída direto. Alegação sem nenhum dos dois não conta, do mesmo jeito que a saída completa colada por inteiro não é o formato certo.
- **O `report` referenciado precisa existir** — `report.md` (ou `report-<log>.md`) ausente no caminho é ausência de evidência (rejeição no aceite, R7); acima de 200 linhas ou 20 KB é achado de processo (R28). **Log bruto podado não é achado:** achado é gatilho de aprofundamento disparado com o log podado sem re-rodar o job pelo `operator` nem registrar "não verificado — log podado" (R7). Achado sem `arquivo:linha` vai a "Suspeitas".
- **Desvio de seção de standard citada no plano é reprovação, não ressalva** (R16). Defeito no próprio standard (contradição, lacuna, regra inverificável) é achado de **Tipo `processo`** só para `/review` — **não** vira GAP de projeto. Plano que **omitiu** a seção que a Task exigia ou **citou a errada** (tabela do objeto 2, estados 3 e 4) é **duplo**: 🔺 **GAP** para o Arquiteto via `/arc question` (desbloqueia a Task, `workflow.md` §4a) **e** achado de `processo` para `/review` (corrige o hábito) — os dois, não um no lugar do outro.
- **Frente 2 sem as duas tabelas não cobriu os dois objetos** (`workflow.md` §4a). Veredito com só a tabela do objeto 2 (como antes de v3.31) é achado de processo contra o próprio veredito. Divergência do objeto 1 volta **direto** a `/dev resume`, sem passar pelo Arquiteto. **Passo "inconferível sem decidir"** (Conferência do plano insuficiente, R13 de `implementation-plan.md`) não é "conforme" nem achado de execução: é 🔺 GAP do plano, para `/arc question`.
- **Desempenho registra sempre um dos três estados.** "Fora" (comando de V19 sai ≠ 0) é reprovação; "não exercitado" exige o motivo. Task que toca operação de V18 sem o trecho e o ponteiro do comando é achado bloqueante, não "ok" (`implementation-principles.md` §5.6 P6).
- **Cenário mapeado sem linha na tabela de resultado não fecha a Task** (R30, DoD §4a-i) — regressivo aplicável incluído. Cenário ❌ segue o roteamento pelo bloqueio: bloqueia a História em voo → Task no sprint corrente (R25); não bloqueia → **ID de `pending.md` explícito nesta seção, endereçado ao PO** — sem esse ID, o GAP fica preso em `pending.md` e nunca chega ao Product Backlog (R30 · R12).
- **"Não exercitado" é obrigatório**, mesmo que seja "nada — todo o fluxo foi exercitado".
- ⚠️ (ressalva) só quando a Task é utilizável e a pendência tem ID próprio no backlog.

Os comandos, limiares e limitações do ambiente estão em `.team-project/quality-assurance/context.md`.

## Variante trilha fix (R33) — `fixes/B-<nnn>/verdict.md`

Um arquivo por **bloco**, mas **o veredito é por F-ID**: o bloco não tem veredito, e um ❌ numa F-ID não reprova as outras. Não há Task, evidência por Task nem Sprint Backlog; o consumo (verificação, Unidade `B-<nnn>`) vai ao `consumption.md` do bloco. Os rótulos abaixo são **lidos pelo script C4** — não variar a grafia. Nenhum título usa "Aceite — …" (o C2 o procura). Roteiro: [`fix-run.md`](../../scrum-master/process/fix-run.md) (`${CLAUDE_PLUGIN_ROOT}/roles/scrum-master/process/fix-run.md`).

```markdown
# B-<nnn> · veredito
**Trilha:** fix · **Executado em:** aaaa-mm-dd hh:mm

## QA — F-<nnn> <título> — <data>
**Veredito:** ✅ | ⚠️ | ❌

| Frente | Resultado | Evidência |
|---|---|---|
| Requisito | ok / falha | o mesmo passo de reprodução da triagem, agora passando (defeito) ou o requisito alterado (ajuste), com a borda do caso relatado |
| Especificação técnica | ok / falha | só "diff da F-ID × arquivos do mini-plano dela"; sem as duas tabelas do modelo Task |
| Segurança | ok / falha / n/a | checklist do projeto aplicado ao trecho tocado — `arquivo:linha` |
| Testes / métricas | ok / falha | teste de regressão (seção abaixo) e build sem avisos |
| Documentação | n/a — trilha fix (R33) | só no ajuste: o delta da ficha bate com o código (senão "n/a — defeito") |
| Desempenho | n/a — trilha fix (R33) | só se a Correção toca operação de V18–V21: então um dos três estados, com o trecho do comando V19 |

**Commit:** <sha | n/a — sem git>

### Teste de regressão
**Antes:** exit <n≠0>
> <comando>
<saída decisiva — a do dev, antes da correção>
**Depois:** exit 0
> <comando>
<saída decisiva — a do QA, agora>

### Escopo
**Fora do plano:** nada | <arquivos tocados além dos do mini-plano da F-ID>

### Documentos vivos (R12)
**Estado:** atualizados | pendentes

## Regressivos e suíte do módulo
<uma vez por bloco: regressivos R30 dos fluxos tocados (SC-nnn · resultado) e suíte do módulo (comando · trecho decisivo · ponteiro do `report` do `operator` quando pesado)>

## Fechamento
**Fechado em:** aaaa-mm-dd
| F-ID | Estado final |
|---|---|
| F-<nnn> | fechada | promovida | devolvida |
```

Regras da variante:

- **Uma seção `## QA — F-<nnn> …` por F-ID** do bloco, na ordem do `plan.md`; `### Teste de regressão`, `### Escopo` e `### Documentos vivos (R12)` dentro de cada uma. Frentes 2 parcial, 5 e 6 são "n/a — trilha fix (R33)" **exceto** nas condições da própria linha (ajuste; operação de V18–V21).
- **Teste de regressão é piso, não ressalva:** `Antes` com exit ≠ 0 (saída do dev) **e** `Depois` com exit 0 (saída do QA, rodada por mim) — sem os dois, o veredito da F-ID não é ✅ (R7, `workflow.md` §8). Defeito sem teste que falhava antes é ❌.
- **Regressivos e suíte do módulo: uma vez por bloco**, não por F-ID; suíte inteira só pelo `operator`, quando o contexto do QA a exige para o módulo (R28). Falha atribuível a uma F-ID reprova **aquela** F-ID.
- **Defeito funcional achado** (regressivo falhou, borda não coberta) vira `SC-nnn` na suíte de cenários (`scenario.md`), com o roteamento pelo bloqueio de sempre.
- **`## Fechamento` é gravado pela sessão** (passo final do `fix run`, depois do C4), não por mim; eu entrego os vereditos. Fechado, nada mais é gravado na pasta.
