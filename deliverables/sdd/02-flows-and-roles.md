# Modelo — `02-flows-and-roles.md`

> **Dono:** PO · **Muda quando:** muda o modelo conceitual, um ator ou um fluxo · **Revisa:** Arquiteto (viabilidade)

É o documento que mostra **como as peças se encaixam ao longo do tempo**. Existe quando o sistema tem mais de um ator, etapas assíncronas, ou responsabilidades que se confundem sem um mapa.

## Estrutura

```markdown
# 02. Modelo Conceitual, Papéis e Fluxos

# 1. Modelo Conceitual
<As entidades conceituais do domínio e como se relacionam — em texto ou diagrama.
Não é o modelo de dados: é o vocabulário do produto.>

# 2. Papéis
<Um bloco por ator do sistema — humano, serviço, agente automatizado ou integração.>

## 2.1 <Ator>
**Responsabilidade:** <o que este ator decide ou produz>
**Entradas:** <o que recebe>
**Saídas:** <o que entrega>
**Não faz:** <a fronteira que evita sobreposição com o ator vizinho>

# 3. Fluxos

## 3.1 Fluxo principal
<A sequência do caminho feliz, do gatilho à entrega. Numerada, com o ator de cada passo.>

1. <ator> — <ação> → <resultado>
2. …

**Pontos de intervenção humana:** <onde o fluxo para e espera decisão>
**Pontos de falha e retomada:** <o que acontece quando um passo falha>

## 3.2 <Fluxo alternativo / variação>
<Quando o principal não se aplica, e o que muda.>
```

## Regras

- **Todo ator tem um "não faz".** É a linha que impede dois atores de decidirem a mesma coisa — e a causa mais comum de retrabalho quando falta.
- **Fluxo declara os pontos de intervenção humana.** Sistema que decide sozinho onde deveria perguntar é defeito de desenho, não de código.
- **Fluxo declara o comportamento em falha.** O caminho feliz é a parte fácil; o valor do documento está no que acontece quando um passo não completa.
- **Vocabulário conceitual, não implementação.** Os nomes técnicos vivem em `04-data-model`; aqui ficam os conceitos que o negócio usa.

## Falhas comuns

| Falha | Consequência |
|---|---|
| Só o caminho feliz documentado | Cada dev inventa o tratamento de falha; o comportamento fica inconsistente |
| Ator sem fronteira declarada | Responsabilidade duplicada, decisão tomada duas vezes |
| Fluxo que envelheceu junto com uma etapa removida | O documento passa a descrever um sistema que não existe |
