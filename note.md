# Melhorias a aplicar neste plugin — fila do `/review`

> **Dono:** stakeholder. Só no repositório-fonte do plugin. Escreva cada item como **sintoma**, não como solução.

## Abertas

> Origem dos itens 1–5: primeiro sprint completo do projeto-piloto (04 a 13/10/2026, plugin 3.46.0) — relatório do SM ao dono do plugin e `guards.log`. Grupo C da avaliação; os grupos A e B entraram na v3.48.0.

1. **Retomada cara por `SendMessage`.** Instâncias do Arquiteto (Opus) com 480–490 mil tokens de contexto foram retomadas 4–5 vezes para respostas curtas (GAP, correção pequena); cada retomada de 3 chamadas custou ~1,4–1,5 M tokens processados, porque relê o contexto inteiro. 5 retomadas numa mesma instância, ≥ 3 por Task em outras. *Onde doeu:* `sprint-run.md` §Disparo · seleção de modelo. *Dono provável:* SM.
2. **Trabalho perdido em interrupção.** Arquiteto interrompido ~2 h sem ter gravado o plano; o roteiro do Arquiteto não diz onde gravar a quebra em Tasks (passo 4). Nada do que estava pronto sobrou para retomar. *Onde doeu:* `roles/architect/README.md` passo 4 · R27. *Dono provável:* Arquiteto (e QA, pelo mesmo padrão de gravar só no fim).
3. **Registro de consumo não fecha.** Os Totais declaravam 100 invocações e o Registro tinha 137 linhas (retomadas da mesma instância contadas à parte); uma linha de `operator` sem chamador; a linha do `sm` sem número processado; Totais corrigidos à mão por nota. *Onde doeu:* `scripts/checks/consumption.ps1` · `templates/consumption.md`. *Dono provável:* SM / sessão.
4. **Invocação única concentrando o sprint; haiku sem fôlego.** Uma invocação de dev (haiku) com 197 chamadas e 131 min consumiu ~15 % do sprint (40 M tokens: plano com 13 mutações e prova por bloco); uma Task de 32 arquivos sem blocos esgotou a capacidade em 4 instâncias de haiku. O `plan.ps1` já reprova lista > 8 sem blocos — a Task passou sem ele (plano anterior à v3.46 ou conferência não rodada). *Onde doeu:* tamanho do bloco de execução · `sprint-run.md` passo 3 (conferência do plano antes do dev). *Dono provável:* SM.
5. **Regressão de UI passou por todos os portões.** Mudança de layout (Ionic) provada por regra/estrutura — CSSOM, seletor — passou no plano, no QA e na mutação; o defeito só apareceu no aparelho e o conserto custou ~15,5 M tokens. A retrospectiva do piloto propôs, no projeto, exigir medição de caixas em render real (headless, 3 tamanhos de fonte). *Onde doeu:* cerimônia do QA · padrões do modelo de plano para UI. *Dono provável:* Arquiteto e QA.
