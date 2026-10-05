# Melhorias a aplicar neste plugin — fila do `/review`

> **Dono:** stakeholder. Só no repositório-fonte do plugin. Escreva cada item como **sintoma**, não como solução.

## Abertas
- O `operator` tabula "código 0" — o código de saída do wrapper do PowerShell — para provas que reprovam, e não grava o `report.md` do job. (sprint 1 do projeto-piloto, achado registrado no `scrum-master/context.md`)
- O R7 do `close.ps1` reprova um veredito ✅ quando a mesma linha do veredito traz o histórico das rodadas anteriores (⚠️ → ❌ → ✅). (mesma origem)
- O R4 não tem onde registrar a decisão do stakeholder — quando ele decide sobre escopo durante o sprint, não há campo nem documento que a guarde. (mesma origem)
