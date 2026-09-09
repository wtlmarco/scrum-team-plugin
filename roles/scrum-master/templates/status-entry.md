# Template — Entrada no documento de status (fechamento de Task)

O SM escreve isto no documento de progresso do projeto (caminho em `.team-project/README.md` §4) ao rodar `/sm close <T-ID>` — **só depois** de veredito ✅ do QA com evidência e dos documentos vivos atualizados pelos donos (R12).

> **Isto registra fechamento técnico, não aceite** (R21). "Concluída" aqui significa que o trabalho da Task acabou e passou no QA. Se a História a que ela pertence for rejeitada na Sprint Review, esta Task volta ao Product Backlog junto com as demais — e a entrada de status ganha um addendum dizendo isso, nunca é reescrita.

```markdown
- **<data> — <T-ID> (<título>) concluída.** <O que passou a funcionar, em uma frase, na linguagem do produto.>
  - **História:** H-<nnn> <título> — <n de m Tasks da História fechadas>
  - **Evidência:** <comando> → <saída real resumida>; <teste específico que cobre>; <smoke, se houve>.
  - **Arquivos:** <n> criados, <n> alterados — detalhe no inventário de código.
  - **Decisões fora da especificação:** <cada uma, com justificativa — ou "nenhuma">.
  - **GAP fechado:** <ID> — removido do registro de GAPs por <quem> em <data>.
  - **Pendência conscientemente adiada:** <o que ficou de fora e por quê — ou "nenhuma">.
  - **Não exercitado:** <o que não pôde ser validado neste ambiente e o motivo>.
```

## Regras

- **Evidência antes de narrativa.** A frase do produto vem primeiro por legibilidade, mas é a linha de evidência que sustenta o fechamento (R7).
- **Decisão fora da especificação nunca fica implícita** (R6). Se for estrutural e recorrente, o Arquiteto promove a ADR — e a entrada diz isso.
- **Pendência adiada não some.** Ela é registrada aqui *e* continua no registro de GAPs até ser resolvida.
- **"Não exercitado" é obrigatório** quando algo não pôde ser validado. A ausência sistemática dessa linha é o que produz funcionalidade declarada como pronta que nunca rodou.
- Não reescrever entradas antigas — o documento é histórico; correção vira entrada nova com a data de hoje.

## Exemplo

```markdown
- **08/09/2026 — ABC-01 (endpoint de download assinado) concluído.** Os arquivos gerados pela plataforma passam a ser efetivamente baixáveis pelo link temporário.
  - **Evidência:** <comando de teste> → 312 unitários + 74 de integração, 0 falhas, 0 avisos; a suíte de download cobre assinatura válida (200), expirada (410) e adulterada (403); smoke manual baixou um arquivo real do ambiente publicado.
  - **Arquivos:** 3 criados, 2 alterados — detalhe no inventário de código.
  - **Decisões fora da especificação:** a URL assinada passou a incluir o caminho lógico na mensagem — a especificação não definia a composição da mensagem; sem isso, uma assinatura válida servia para qualquer caminho.
  - **GAP fechado:** ABC-01 — removido pelo QA em 08/09/2026. ABC-02 fechado no mesmo ciclo.
  - **Pendência conscientemente adiada:** provedor de armazenamento remoto segue aberto — só o local implementado.
  - **Não exercitado:** download de arquivo acima de 2 GB; nenhum arquivo desse tamanho existe no ambiente.
```
