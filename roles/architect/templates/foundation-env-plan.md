# Modelo — Plano de ambiente do sprint 0 (`.team-project/sprints/0/plan/S0-<nn>-ambiente.md`)

> **Dono:** Arquiteto · Curto: o ambiente de testes não é Task de entrega, e este plano não passa pelo `plan.ps1` · O `foundation.ps1 next` grava o escopo do dev a partir de **Arquivos tocados:** (G9) · Roteiro: `roles/scrum-master/process/workflow-sprint0.md` §Itens de ambiente · Regras: R26 (medir antes) · R35

~~~markdown
# Plano de ambiente — S0-<nn>

## 1. Ambiente medido (R26 — saída real, recortada)

| O que | Comando | Saída real | Atende? |
|---|---|---|---|
| build | <comando> | <recorte> | sim · não — <o que falta> |
| testes (suíte) | <comando> | <recorte: n testes, tempo> | |
| lint | <comando> | <recorte> | |
| serviço do ambiente | <check, ex.: docker info> | <recorte> | |
| alvo de prova | <navegador, emulador ou aparelho — como sobe> | <recorte> | |

## 2. O que o dev faz

**Arquivos tocados:** `<caminho>` · `<caminho>`

1. <passo, com o comando que prova que deu certo>

## guards.json proposto

```json
{ "verify": { "build": "<comando>", "suite": "<comando>", "lint": "<comando>" },
  "run": { "prereqs": [ { "name": "<serviço>", "check": "<comando que sai 0 com ele no ar>", "start": "<como subir>", "waitSec": 120 } ] } }
```

## 3. Fora deste plano

<o que o ambiente não cobre e fica como limitação declarada no README §5 — ex.: prova no aparelho físico>
~~~

## Regras

- **Medir antes de propor** (R26): comando que não rodou aqui não entra no `guards.json` proposto.
- **Só ambiente:** nada de refatorar código de produto. Configuração de teste, script de execução, `docker-compose` de teste, dependência de dev — sim; mudar regra de negócio para o teste passar — não (vira dívida no `03` §0.1).
- **Quem grava o `guards.json` é a sessão**, com a autorização do formulário do escopo — o dev não toca nele (arquivo da sessão na matriz de propriedade).
- **Serviço que sobe sozinho** vai em `run.prereqs` (v3.60.1): declarar é a autorização do stakeholder para o run subi-lo sem formulário.
