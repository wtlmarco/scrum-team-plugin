# Modelo — `03-architecture.md`

> **Dono:** Arquiteto · **Muda quando:** decisão estrutural, componente ou princípio novo · **Revisa:** QA (aderência do código)

É onde os padrões **genéricos** de engenharia ganham **aplicação concreta** neste produto: nomes reais, integrações reais, decisões reais. Os normativos agnósticos ficam em [`../../standards/`](../../standards/README.md); aqui fica o que este sistema faz com eles.

## Estrutura

```markdown
# 03. Arquitetura

> Este documento aplica os padrões de <standards> ao produto. Cada seção que aplica
> um padrão genérico indica a seção correspondente do guia.

## Índice
<Organizado por camada, para navegação direta. Documento grande sem índice não é lido.>

# 0. Decisões formalizadas (ADRs)
| ADR | Título | Status |
|---|---|---|
<Índice de referência rápida; os documentos completos ficam no diretório de ADRs.>

## 0.1 Pendentes de formalização
<Decisões já tomadas em código e ainda sem ADR — a dívida arquitetural visível.>

# 0a. Princípios Arquiteturais

## P-001 — <título>
<A regra, em uma ou duas frases, no imperativo.>
**Consequência observável:** <o que se vê no código quando o princípio é respeitado — é o que o QA verifica.>

# 1. Visão geral
<Diagrama de blocos: o que fala com o quê.>

# 2. Estrutura da solution / do repositório
<Árvore de diretórios com a responsabilidade de cada um.>

# 2a. Nomenclatura aplicada
<As convenções reais deste projeto: sufixos, prefixos, plural/singular, idioma.>

# 2b. Ficha de Vinculação de Stack  ← obrigatória
<A tabela V1–V21 de `${CLAUDE_PLUGIN_ROOT}/standards/implementation-principles.md` §6 preenchida: o nome real de cada anel,
as unidades implantáveis, e a ferramenta + comando que verifica cada regra (dependência, formatação,
lint, duplicação, testes, cobertura de 80%, métricas, estágios de CI, ponto de composição, pipeline
transversal) e, em V18–V21, o desempenho: operações sob orçamento (lista fechada, cinco campos por
linha), comando do teste de carga por unidade, margem de ruído medida do ambiente, ambiente de medição
e onde vive a baseline. Linha sem valor é gate ausente, não campo em branco: escrever "não aplicável"
**e** o que substitui.>

<**V18 transcreve, não origina, o número.** A origem de cada linha é o RNF de performance de
`01-requirements.md`, escrito pelo PO com os cinco campos de P1 (operação · métrica/percentil · limiar ·
condição de carga · ambiente). Número que aparece aqui sem RNF correspondente é orçamento inventado;
RNF com menos de cinco campos volta ao PO e o item não entra em construção.>

# 3. <Padrão estrutural adotado>
<Camadas, dependências permitidas e proibidas.>

# 3a..3z. <Aplicações concretas>
<Uma seção por assunto transversal: separação de leitura/escrita, isolamento por escopo,
autenticação e autorização, auditoria.>

# 4..8. <Componentes e integrações>
<Uma seção por componente real: ingestão, orquestração, filas, cache, armazenamento,
observabilidade, configuração, segurança de infraestrutura.>

# 9. Empacotamento e execução
<Containers, composição de ambientes, variáveis.>
```

## Regras

- **Ficha de Vinculação de Stack é pré-requisito do primeiro Plano de Execução.** Sem a §2b preenchida, o Arquiteto não consegue nomear o anel de cada arquivo nem o comando que verifica a entrega — e o dev decide por conta. Ficha com **V18–V21 ausentes** é ficha incompleta, não ficha "sem performance": "nenhuma operação sob orçamento" é resposta válida, mas escrita (§7 #22 do normativo).
- **Princípio sem consequência observável é slogan.** Cada `P-nnn` precisa dizer o que se vê no código quando é respeitado — senão o QA não consegue verificar e ninguém percebe quando é violado.
- **Aplicação, não repetição.** Se o padrão genérico já explica *como fazer*, aqui só entra o *o que foi escolhido* e o *por quê deste produto*.
- **Índice obrigatório.** Este documento cresce mais que os outros; sem índice, vira arquivo morto.
- **Marque a origem.** Seção que aplica um padrão genérico cita a seção do guia; seção que decorre de uma decisão cita a ADR.
- **Estrutura de diretórios documentada é estrutura verificada.** Quando o repositório mudar, esta seção muda no mesmo ciclo (R12).

## Falhas comuns

| Falha | Como detectar |
|---|---|
| Princípio que ninguém sabe verificar | Falta a linha "consequência observável" |
| Ficha de vinculação com linha em branco | O gate correspondente não existe no pipeline — confere rodando o comando declarado |
| Linha de V18 sem RNF de origem em `01-requirements.md` | Orçamento inventado aqui: o limiar não foi decidido pelo PO e ninguém o aceita ou rejeita |
| Documento que repete o padrão genérico | Duas verdades para manter; uma delas envelhece |
| Decisão estrutural registrada só aqui, sem ADR | A decisão é encontrada por acaso, sem contexto nem alternativas |
| Árvore de diretórios desatualizada | Confere contra o repositório numa auditoria — é o item mais barato de checar |
