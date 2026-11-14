---
description: "Como está o sprint, em palavras simples e sem gastar token — o que já está pronto, o que está em andamento, o que parou e por quê, o que precisa de você e o que vem a seguir. Funciona no console, na extensão e pelo celular. Opcional: o número do sprint; \"detalhe\" para a visão técnica (comandos, tempos, registro)."
argument-hint: "[<n do sprint>] [detalhe]"
---

> **Normalmente este texto nem chega ao modelo:** o hook `prompt-submit.ps1` responde `/team-status` direto, pelo script, sem custo de token (v3.53.2). Se você está lendo isto, o hook não respondeu — faça só o passo abaixo.

Rode, na raiz do projeto, e mostre a saída **literal**, sem comentar nem resumir (acrescente `-Sprint <n>` se `$ARGUMENTS` trouxer um número e `-Detail` se trouxer "detalhe" ou "técnico"):

```powershell
powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/team-view.ps1" -View status
```

Depois, em uma linha: "o hook não respondeu ao /team-status — esta resposta passou pelo modelo".
