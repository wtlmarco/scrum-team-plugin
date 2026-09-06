# Template — Especificação de Tela

> **Dono:** UX · Salvo em `.team-project/user-experience/screens/<slug>.md`

É o contrato entre o UX e o dev. **O que não estiver aqui, o dev vai perguntar — ou inventar.**

```markdown
# Tela — <nome>

**Rota:** <caminho> · **Requisitos atendidos:** <IDs> · **Item:** <ID no quadro>
**Reaproveita:** <telas/componentes existentes que servem de base>
**Fidelidade do entregável:** só especificação | baixa (estrutura) | alta (navegável) — <gatilho que justifica o nível>

## 1. Objetivo
<O que o usuário consegue fazer aqui, em uma frase. Se não couber em uma frase, provavelmente são duas telas.>

## 2. Layout e hierarquia
<Estrutura em blocos: cabeçalho, conteúdo, ações. O que é primário, secundário e destrutivo.
Use um esboço em texto quando ajudar.>

## 3. Componentes
| Componente | Origem | Comportamento |
|---|---|---|
| <nome> | existente / novo | <o que faz, o que desabilita, o que valida> |

### 3.1 Estados de interação dos controles
*(Eixo diferente dos seis estados: aqui é cada controle, não a tela.)*

| Controle | Repouso | Foco | Pressionado | Desabilitado — e por quê |
|---|---|---|---|---|
| <botão/campo/item> | <como aparece parado — obrigatório> | <como se distingue quando focado> | <retorno imediato ao acionar> | <quando fica assim e o que explica ao usuário> |

## 4. Conteúdo
<Rótulos, títulos, mensagens e microcópia — texto real, não placeholder.
Mensagem de erro e texto de estado vazio são parte do desenho.>

## 5. Os seis estados
| Estado | O que aparece | Como o usuário sai daqui |
|---|---|---|
| Vazio | | |
| Carregando | | |
| Sucesso | | |
| Erro | | |
| Sem permissão | | |
| Volume extremo | | |

*(Estado que não se aplica é declarado como "não se aplica — <motivo>", nunca omitido.)*

## 6. Acessibilidade — critérios verificáveis
- [ ] Todo controle alcançável por teclado, na ordem visual, com foco visível
- [ ] Todo campo com rótulo associado; ícone sem texto com nome acessível
- [ ] Contraste ≥ 4,5:1 (texto normal) e ≥ 3:1 (texto grande)
- [ ] Alvo de toque ≥ 44×44 px
- [ ] Hierarquia semântica de títulos correta
- [ ] Nenhuma informação comunicada só por cor
- [ ] Erro anunciado e associado ao campo que o causou
- [ ] Conteúdo e função íntegros com zoom de 200% e em viewport de 320 px, sem rolagem horizontal
- [ ] Nenhuma função depende só de gesto complexo ou de movimento; animação respeita a preferência de redução de movimento
- [ ] **Condição de uso limitante considerada:** <qual — só teclado, leitor de tela, tela pequena, conexão lenta, primeiro contato…> → <o que o desenho faz por ela>
- [ ] <critério específico desta tela>

## 7. Dados e contratos
| O que a tela precisa | De onde vem | Existe? |
|---|---|---|
| <dado> | <endpoint ou serviço> | sim / **não — levantar ao Arquiteto** |

## 8. Fora do escopo desta tela
<O que ela explicitamente não faz e onde isso acontece.>

## 9. Onde o dev deve parar e perguntar 🔺
<Pontos deixados em aberto de propósito, se houver.>
```

## Regras

- **Os seis estados são obrigatórios** — omitir um é transferir a decisão ao dev.
- **O estado de repouso de todo controle é obrigatório** (§3.1). Verificação: percorrer a tela com Tab e com o ponteiro — todo controle é visível e identificável parado, sem consultar o código.
- **Conteúdo real, não placeholder.** Rótulo e mensagem de erro são desenho, não detalhe de implementação.
- **Critério de acessibilidade sem forma de verificação não entra** — o QA precisa poder reprovar objetivamente.
- **Uma régua por critério.** Onde há valor numérico, a especificação cita o valor vigente do papel, nunca duas alternativas (ver `../skills.md` §4).
- **Reaproveite antes de criar**, e diga o que reaproveitou. Componente novo exige justificativa — e, antes de criar, o repertório consolidado (`../skills.md` §8) já resolve a maior parte dos casos.
- **Fidelidade declarada.** O nível do entregável é escolhido pelo gatilho (`../skills.md` §9), não por gosto — alta fidelidade antes de a estrutura estar acordada é retrabalho.
- **Dado que não existe vira levantamento ao Arquiteto**, não suposição na tela.
- **"Fora do escopo" é obrigatório** — é o que impede o dev de antecipar escopo (R4).

## Falhas comuns

| Falha | Consequência |
|---|---|
| Só o estado de sucesso especificado | Cada tela trata vazio e erro de um jeito; o produto fica incoerente |
| Controle sem estado de repouso especificado | A afordância existe no código e some na tela: o usuário não descobre que dá para agir |
| Microcópia deixada para o dev | Mensagens de erro técnicas chegam ao usuário final |
| Componente novo sem justificativa | Dois jeitos de fazer a mesma coisa no mesmo produto |
| Acessibilidade como frase genérica | O QA não consegue verificar; o critério não é cumprido e ninguém percebe |
| Alta fidelidade antes da estrutura acordada | Discute-se cor quando o problema era ordem de leitura; o retrabalho volta inteiro |
| Dado suposto | Descoberto na implementação, vira 🔺 GAP e replanejamento |
