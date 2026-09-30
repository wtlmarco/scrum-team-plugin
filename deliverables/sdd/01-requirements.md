# Modelo — `01-requirements.md`

> **Dono:** PO · **Muda quando:** requisito novo, alterado ou descontinuado · **Revisa:** QA (verificabilidade)

É a fonte da verdade sobre **o que o sistema faz**. Toda História nasce daqui ou de um GAP; todo aceite é conferido contra aqui.

## Estrutura

```markdown
# 01. Requisitos

## 1.1 Requisitos Funcionais

### RF-001 — <título curto e afirmativo>

**Objetivo relacionado:** <OBJ-nnn>

<O que o sistema deve fazer, na voz do produto. Sem solução técnica.>

O sistema deverá:
- <regra>
- <regra>

**Critério de aceite**
- [ ] Dado <contexto>, quando <ação>, então <resultado observável>

**Como verificar**
<chamada + resposta esperada, ou passo de UI + resultado>

**Fora do escopo:** <o que este requisito NÃO cobre>

### RF-002 — <título> *(revisado vX.Y)*
…

## 1.2 Requisitos Não Funcionais

### RNF-001 — <título>
<A restrição, com número sempre que possível.>
**Como verificar:** <medição, teste ou inspeção que comprova>

### RNF-002 — <título de um RNF de performance>
**Operação:** <um caminho de uso real — nunca "o sistema">
**Métrica:** <percentil — nunca média>
**Limiar:** <número + unidade>
**Condição de carga:** <taxa ou usuários simultâneos **e** duração>
**Ambiente de medição:** <onde o número vale>
**Como verificar:** <comando único do cenário de carga (Ficha V19); sai com código ≠ 0 se o limiar é violado>
```

O modelo detalhado de um requisito individual — com casos de borda e tabela de erros — está em [`../../roles/product-owner/templates/requirement.md`](../../roles/product-owner/templates/requirement.md).

## RNF de performance — a forma completa

O princípio "RNF precisa ser verificável" continua valendo igual; performance só exige **mais forma**. Um RNF de tempo de resposta ou de vazão declara **cinco campos juntos** — é o P1 de [`../../standards/implementation-principles.md`](../../standards/implementation-principles.md) §5.6:

| Campo | O que é | Erro que o invalida |
|---|---|---|
| Operação | um caminho de uso real, nomeado | "o sistema", "as telas" — não é operação |
| Métrica | percentil (p95, p99) | média — esconde a cauda |
| Limiar | número com unidade | "rápido", "aceitável" |
| Condição de carga | taxa **ou** usuários simultâneos **e** duração | só a taxa, sem duração |
| Ambiente de medição | onde aquele número vale | medir na máquina do dev e comparar com produção |

Falta um campo, não é RNF — é intenção. O Arquiteto devolve e a Task **não entra em construção** (`implementation-principles.md` §7, item 18).

**Exemplo — preenchido** *(números ilustrativos; o valor real é do projeto, não deste modelo)*

> ### RNF-014 — Tempo de resposta da listagem de catálogo
> **Operação:** `GET /catalog` — primeira página, caminho principal declarado
> **Métrica:** latência no percentil 95
> **Limiar:** ≤ 400 ms
> **Condição de carga:** 50 requisições/s sustentadas por 5 min
> **Ambiente de medição:** ambiente dedicado de carga da Ficha (V21), base com volume de referência
> **Como verificar:** cenário de carga versionado, executado pelo comando único da Ficha (V19); o comando sai com código ≠ 0 se o p95 passar de 400 ms.

**Contraexemplo**

> ❌ "O catálogo deve carregar rápido." — zero campos.
> ❌ "`GET /catalog` responde em até 400 ms." — só operação e limiar; sem percentil, sem carga, sem ambiente. Volta ao PO (`implementation-principles.md` §7, item 18).

### A cadeia

Você (PO) escreve o RNF com os cinco campos; o Arquiteto os transcreve para a Ficha de Vinculação de Stack (V18–V21, `implementation-principles.md` §6) e o QA valida contra ela. **V18 é lista fechada:** operação que você não colocar num RNF de performance não entra em V18 e não é medida por ninguém — priorize a operação síncrona do caminho principal e a assíncrona cuja demora o usuário percebe. Projeto sem operação sob orçamento é estado válido, desde que **declarado** (V18 vazia com motivo).

### Critério de aceite de História que toca operação sob orçamento

O RNF existir **não basta**. A História que toca uma operação de V18 leva o desempenho no **próprio critério de aceite**, com "como verificar" apontando o comando de V19 e o estado esperado. Número que só vive aqui não protege a entrega; o critério de aceite da História é o gancho que prova que *aquela* entrega foi medida — sem ele o aceite vira opinião, e "implementado" não é "funcionando".

## Regras

- **Numeração nunca reaproveitada.** Requisito descontinuado é marcado (`*(descontinuado vX.Y)*`), não apagado — há código e testes apontando para o número.
- **Sufixo para desdobramento** (`RF-004a`) quando um requisito ganha uma variação que não cabe no original.
- **Critério de aceite sem "como verificar" não existe** — é a regra que impede aceite por opinião.
- **RNF também precisa ser verificável.** "Deve ser performático" não é RNF; "responder em até 500 ms no percentil 95" já se pode medir.
- **Grafia das entidades igual a `04-data-model`.** O requisito é lido por quem implementa.

## Falhas comuns

| Falha | Como detectar |
|---|---|
| Requisito que descreve a tela, não a regra | Não sobrevive a uma mudança de UI |
| Critério de aceite não verificável | O QA não consegue produzir evidência; o aceite vira opinião |
| Caminho de erro ausente | O dev inventa o comportamento; o QA reprova depois |
| Requisito marcado como atendido sem evidência | Divergência entre o documento e o que o código sustenta — achado clássico de auditoria |

## Relação com os demais documentos

- Cada RF rastreia até um `OBJ-nnn` de `00-overview-objectives`.
- Os endpoints que realizam o RF vivem em `05-api-model`; as entidades, em `04-data-model`.
- Mudança aceita gera entrada em `06-changelog`.
