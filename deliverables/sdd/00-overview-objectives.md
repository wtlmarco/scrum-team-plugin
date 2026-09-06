# Modelo — `00-overview-objectives.md`

> **Dono:** PO · **Muda quando:** o produto muda de objetivo, fase ou roadmap · **Revisa:** stakeholder

É o documento que responde **por que este sistema existe**. Todo requisito deve poder ser rastreado até um objetivo daqui; requisito que não serve a nenhum objetivo é candidato a corte.

## Estrutura

```markdown
# SDD — <nome do produto>

## 00. Visão Geral e Objetivos

# 1. Visão Geral

## 1.1 Objetivo
<Um parágrafo: o que o sistema faz, para quem, e qual problema resolve. Sem solução técnica.>

<Opcional: o fluxo do produto em alto nível, do insumo à entrega.>

# 2. Objetivos do Produto

## OBJ-001 — <título afirmativo>
<O que o produto se compromete a garantir. Um parágrafo.>
**Como saberemos que foi atingido:** <sinal observável — não é critério de aceite de requisito, é a régua do objetivo.>

## OBJ-002 — <título> *(revisado vX.Y)*
…

# 3. Visão de Evolução
<As fases do produto, da atual às futuras. Deixa claro o que está fora do escopo agora e por quê.>

| Fase | Escopo | Situação |
|---|---|---|
| 1 | <o que entrega> | atual / futura |

# 4. Roadmap

## 4.1 <iniciativa futura>
<O que é, o que destrava, e o que precisa existir antes.>

# 5. Conclusão
<Uma síntese curta: o que o conjunto do SDD cobre e o que deliberadamente não cobre.>
```

## Regras

- **Objetivos são numerados e estáveis** (`OBJ-001`…). Não reaproveite número; objetivo abandonado é marcado, não apagado.
- **Objetivo não é funcionalidade.** "Evitar dependência de fornecedor" é objetivo; "permitir trocar de provedor na tela X" é requisito.
- **Todo objetivo tem sinal observável.** Sem isso, ninguém consegue dizer se foi atingido — e ele vira slogan.
- **Roadmap registra o que está fora do escopo agora**, com o gatilho de reavaliação. É o que impede a mesma ideia de voltar toda semana.

## Falhas comuns

| Falha | Consequência |
|---|---|
| Objetivos genéricos ("ser rápido", "ser fácil") | Não priorizam nada; toda decisão volta ao stakeholder |
| Roadmap sem gatilho | Vira lista de desejos e envelhece sem que ninguém perceba |
| Visão que descreve a solução técnica | O documento passa a competir com `03-architecture` e desatualiza junto com o código |
