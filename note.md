# Melhorias a aplicar neste plugin — fila do `/review`

> **Dono:** stakeholder. Só no repositório-fonte do plugin. Escreva cada item como **sintoma**, não como solução.
>
> As medições que dependem de construir o sprint 6 estão em `/melhorias/validacoes-sprint-6.md` (itens 6, 8, 9 e 12 a 17).
> Os itens 10 e 11 foram para o plano `/melhorias/plano-v3.55.0.md` (seções G e F).
> Os 11 sintomas do relatório intermediário do sprint 5 do garden (`/melhorias/plugin-report.md`) foram tratados na **v3.57.0**; as escolhas estão em `/melhorias/decisoes-plugin-report.md`.

## Abertas

1. **A sonda de progresso do build para o vigia** não existe: o vigia só vê "passou o tempo" e a sonda `run.ps1 wait` olha CPU, arquivo e agente, não o log do build nem a pasta do APK. Depende do comando de build do projeto (Gradle puro, Ionic/Capacitor ou outro), ainda não informado. (Item 13 do relatório.)
2. **O accept confirmar o id dinâmico em tempo de execução**: a terceira parte do item 7, que o stakeholder escolheu e eu recomendei deixar para depois — liga o `verify` ao aceite no emulador e só se prova em sessão real. Hoje a saída é declarar o id em `testIds.dynamic` ou em `// testid-dinamico:`.
3. **Cobertura "não medido" com a suíte verde** (uma rodada do sprint 5 do garden): a suspeita é o gate ler o resumo antes de a suíte gravá-lo; **não verificada**, ficou fora da v3.57.0 por falta de causa.
4. **O aviso de APK velho não cobre o código web de app híbrido**: a conferência olha `.kt`, `.java`, `res/`, o manifesto e `build.gradle`; o Capacitor copia o código web para `src/main/assets/public`, que não entra. Fecha junto com o item 1.
5. **A redação real do plano que declara "o aceite não roda"** não foi vista: a v3.57.0 cobre a linha `**Aceite:** não roda — <motivo>` e duas frases (`Aceite:`/`Decisão:` com "o aceite não roda"). Se o plano do garden disse de outro jeito, o cartão ainda contradiz o plano.
6. **Parecer curto de GAP de aparência por modelo mais barato**: hoje é por tamanho de resposta; o modelo do Arquiteto é o de `models.json` (G17, do stakeholder).
7. **Promover a regra 33 de aviso a reprovação**: o `plan.ps1` só avisa quando falta o `**Envelope de medidas**` num plano com `**Layout novo:** sim`; vira reprovação depois de uma rodada de uso real.
8. **Sem prova em sessão real** (só simulados): o `SubagentStop` real do vigia, a linha `vigia` na tabela do `consumption.md`, o `next` completo com um vigia em voo, o `target.ps1 -Kill` com o emulador real, o `Repair-Android` com o `repair` do container Docker pelo `Invoke-Bounded`.
