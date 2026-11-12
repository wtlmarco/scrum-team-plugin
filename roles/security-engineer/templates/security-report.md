# Template — Relatório de Segurança

Produzido pelo Security Engineer ao fim de um engajamento, em `.team-project/security/<AAAA-MM-DD>/` (fora da pasta do sprint — o engajamento é sob demanda, não um rito do sprint). Um diretório por engajamento; o modo (black/gray/white) e o escopo autorizado abrem o `README.md`.

## Arquivos do diretório
Por modo, no mínimo: `README.md` (modo, escopo, autorização, sumário executivo), `FINDINGS.md` (os achados no formato abaixo), `REMEDIATION-PLAN.md` (P0–P3) e `COVERAGE.md` (o que foi e o que **não** foi exercitado, com o motivo). Black/gray acrescentam `RECONNAISSANCE.md`, `ATTACK-SURFACE.md` e `EXPLOITATION-EVIDENCE.md` (requisições/respostas sanitizadas); white acrescenta `ARCHITECTURE-OVERVIEW.md` e `DEPENDENCIES-SCA.md`.

## Formato por achado (os três modos)

```markdown
### SEC-<NNN> — <nome>
- **Severidade:** <CRÍTICA · ALTA · MÉDIA · BAIXA · INFORMATIVA> · CVSS 4.0 <vetor/nota, se aplicável>
- **Confiança:** confirmada · provável · indício a investigar · falso positivo
- **Alvo / Localização:** <URL + método, no black/gray · `arquivo:linha`, no white>
- **Descrição:** <a falha, em uma a três frases>
- **Descoberta:** <como se chegou a ela>
- **Evidência:** <requisição/resposta sanitizadas (black/gray) · trecho de código + fluxo source→sink (white)>
- **Exploração:** <o impacto demonstrado, sem ação destrutiva — interrompida na evidência mínima>
- **Impacto:** <o que um atacante consegue>
- **Correção:** <o que mudar; no white, com exemplo de código>
- **Causa-raiz sistêmica:** <standard ausente/fraco que permitiu a classe de falha — ou "específica desta implementação">
- **Referências:** <OWASP · CWE · CVE>
```

## Roteamento dos achados (o laço, R16-análogo)
- **Achado de código** (uma implementação específica falhou) → volta ao time pelo canal existente: crítico/alto, o papel sinaliza ao **PO**, que classifica e aciona `/qa bug`; médio/baixo/informativo, item do **Product Backlog** do PO. O Security Engineer **não** escreve `pending.md` (é do QA) nem corrige.
- **Achado de causa sistêmica** (o `Causa-raiz sistêmica` aponta standard ausente ou fraco) → **achado de processo ao `/review`**, que o direciona ao Arquiteto para complementar `standards/`. É o que faz o próximo plano nascer atendendo ao controle. Mesmo mecanismo que o QA usa para defeito de standard (R16).

## Plano de correção (`REMEDIATION-PLAN.md`)
P0 (emergencial) · P1 (alta) · P2 (média) · P3 (melhoria). Por item: problema, impacto, correção recomendada, prioridade, **critério de validação**. Separe correção de código, de configuração/deploy e de dependência/plataforma.

## Regras
- **Nunca afirmar exploração sem evidência**, nem declarar o sistema seguro por ausência de achado automático.
- **O que não pôde ser executado** (sem rede, sem ferramenta, sem credencial) entra no `COVERAGE.md` como **não exercitado**, com o motivo — nunca omitido.
- **Só dados fictícios** e contas de teste; evidência sempre **sanitizada** (sem segredo, token ou dado real de titular).
