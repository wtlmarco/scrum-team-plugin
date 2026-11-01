---
description: "Consumo do sprint sem gastar token — tokens, US$ e tempo dos agentes, por Task e por papel. Funciona no console, na extensão e pelo celular. Opcional: o número do sprint."
argument-hint: "[<n do sprint>]"
---

> **Normalmente este texto nem chega ao modelo:** o hook `prompt-submit.ps1` responde `/team-usage` direto, pelo script, sem custo de token (v3.53.2). Se você está lendo isto, o hook não respondeu — faça só o passo abaixo.

Rode, na raiz do projeto, e mostre a saída **literal**, sem comentar nem resumir (acrescente `-Sprint $ARGUMENTS` se houver número):

```powershell
powershell -NoProfile -File "${CLAUDE_PLUGIN_ROOT}/scripts/checks/team-view.ps1" -View usage
```

Depois, em uma linha: "o hook não respondeu ao /team-usage — esta resposta passou pelo modelo".
