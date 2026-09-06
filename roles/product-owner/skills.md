# PO — Skills

Competências transferíveis do papel. A cadeia funcional, a nomenclatura e a régua de priorização de cada projeto vivem em `.team-project/product-owner/context.md`.

## 1. Separar o pedido do problema

O stakeholder pede um recurso; o papel do PO é encontrar a necessidade por trás dele. É onde nascem as soluções melhores e mais baratas.

> Pedido: "quero exportar em mais um formato".
> Problema: o usuário precisa de uma forma barata de **testar** o resultado antes de investir na produção completa.
> Menor forma útil: um preview reduzido — resolve o problema sem abrir uma frente de mídia nova.

Quando negar, negue **com alternativa**. Negativa seca devolve o problema ao stakeholder sem avançar nada.

## 2. Classificar corretamente o tipo de validação

Confundir os quatro tipos produz regra de negócio dentro de validator e mensagem de erro no lugar errado:

| Tipo | Exemplo | Onde vive |
|---|---|---|
| Validação de formato | "o arquivo precisa ser de um tipo suportado" | Validator de entrada |
| Validação de entrada | "e-mail inválido" | Validator de entrada |
| Regra de negócio | "não é possível avançar antes da etapa anterior aprovada" | Domínio |
| Regra de consistência | "o filho precisa pertencer ao mesmo pai" | Domínio/repositório |

Requisito que menciona erro precisa dizer **qual erro e qual status** — o contrato de erro do projeto está no contexto.

## 3. Escrever critério de aceite verificável

```
❌ "O usuário deve conseguir baixar o resultado."
✅ Dado um recurso pronto, quando o usuário pede a URL e em seguida a acessa,
   então recebe 200 com o arquivo íntegro.
   URL expirada → 410. URL adulterada → 403.
```

Regra: se não é possível dizer **qual chamada fazer e qual resposta esperar** (ou qual passo de UI e qual resultado), o critério ainda não está pronto.

Para RNF de **performance**, "verificável" tem forma fixa — cinco campos juntos: operação · métrica (percentil, nunca média) · limiar · condição de carga (taxa/usuários **e** duração) · ambiente de medição. "Responder rápido" e até "responder em 400 ms" (sem os outros três) não são RNF. A forma completa está no modelo `deliverables/sdd/01-requirements.md`.

## 4. Ler a diferença entre "implementado" e "funcionando"

A armadilha mais cara do papel: aceitar como atendido um critério que só existe na narrativa de sprint. Marcar critério de sucesso exige **evidência registrada pelo QA** — saída de comando ou fluxo exercitado.

Sinais típicos de critério falsamente atendido:
- componente provisionado mas nunca consumido por nenhum código;
- funcionalidade que gera o artefato mas não permite obtê-lo;
- backend pronto e frontend ainda em mock;
- registro de auditoria previsto e ausente justamente nas ações sensíveis.

## 5. Priorizar na retomada de um projeto parado

Régua, nesta ordem:

1. **Impede o produto de funcionar ponta a ponta.**
2. **Expõe risco jurídico ou de segurança.**
3. **Impede saber se funciona** (nenhum caminho de sucesso exercitado).
4. **Degrada a experiência** sem impedir o fluxo.
5. **Dívida técnica e documentação.**

## 6. Escrever para quem implementa

O requisito precisa sobreviver a ser lido por um dev júnior sem contexto:

- Nome de entidade e enum **exatamente** como na especificação.
- Estados possíveis listados, não subentendidos.
- O caminho de erro descrito com o mesmo cuidado do caminho feliz.
- O que está **fora** do requisito dito explicitamente — é o que impede escopo antecipado.

## 7. Registrar o "fora de escopo"

Decisão de não fazer também é decisão. Registre o item, o motivo e o gatilho de reavaliação — poupa a discussão de voltar toda semana e evita que a mesma ideia seja reintroduzida por esquecimento.
