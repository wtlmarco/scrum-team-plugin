# Conhecimento do projeto
> DOCUMENTO VIVO · Dono: Arquiteto · Escritores: Arquiteto (conteúdo) e SM (só a promoção mecânica do `knowledge.ps1 -Apply` no fechamento do sprint) · teto 15 KB

**Classificação desde:** S<n>

O que os sprints ensinaram sobre **este** sistema e vale para os próximos (v3.56.0). Ninguém lê este arquivo inteiro: o cartão do dev e a ficha do Arquiteto trazem só as entradas cujo **Vale para** casa com a Task (T-ID, `todas` ou glob dos arquivos dela). O plano cita a entrada em `**Decisões:** K-<n>` — não copia o texto (regra 29).

- **Vale para** — `todas`, T-IDs ou globs de caminho (`src/app/**/*.render.spec.ts`), separados por vírgula.
- **Origem** — o 🔺 GAP de onde a lição veio; **Desde** — o sprint em que entrou.
- **Até** — só no remédio temporário de defeito do plugin: a correção que o tira. O `/team update` retira a entrada quando a versão nova traz a correção.
- **Classificação desde** — a partir desse sprint, toda decisão de 🔺 GAP declara **Origem** e **Lição** (o `plan.ps1` reprova sem as duas linhas); antes dele, só avisa.
- **Teto de 15 KB.** Acima, a consolidação (juntar entradas parecidas, apagar as superadas, subir para os standards do projeto o que virou regra geral) é o primeiro item do próximo `/sm sprint prepare`, numa instância do Arquiteto.

<!-- Formato de cada entrada (apague este comentário na primeira):

## K-<n> — <título>
**Vale para:** todas | <glob>, <glob> | T-…   · **Origem:** 🔺 GAP <id> da T-… (S<n>) · **Desde:** S<n>
<a regra em até 5 linhas, com o arquivo de referência `caminho:linha` quando houver>
-->
