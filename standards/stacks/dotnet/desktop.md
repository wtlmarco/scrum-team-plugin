# Guia de Implementação — .NET desktop (WPF · WinForms · WinUI) (NET-D)

> **Complemento do perfil .NET** ([`guide.md`](guide.md) e [`quality.md`](quality.md)) para aplicação Windows de desktop. Os anéis, o CQRS, os limites de Clean Code e o gate de 80 % são os mesmos; aqui fica o que muda quando a borda é uma janela e não uma API. Nível 1: [`../../implementation-principles.md`](../../implementation-principles.md).
> **Identificadores:** `NET-D<n>`, citados pelo plano e pelo veredito.

## NET-D1 Os anéis num app desktop

| Anel | Projeto | O que pode referenciar |
|---|---|---|
| Domínio | `{Produto}.Domain` | nada além do .NET base |
| Aplicação | `{Produto}.Application` (comandos e consultas, portas) | Domínio |
| Adaptadores | `{Produto}.Infrastructure` (banco local, arquivos, serviços, relógio) | Application, Domain |
| Borda | `{Produto}.Desktop` (janelas, views, **ViewModels**) | Application, Domain — nunca Infrastructure direto |

- A **ViewModel é borda**: traduz evento de tela em comando ou consulta da aplicação e o resultado em estado de tela. Regra de negócio na ViewModel ou no code-behind é erro de plano (nível 1 §2.1).
- O teste de arquitetura sobre os assemblies (perfil .NET) vale igual (Q1).

## NET-D2 MVVM

- **CommunityToolkit.Mvvm** (`ObservableObject`, `[ObservableProperty]`, `[RelayCommand]`) ou o equivalente do framework; **code-behind só com o que é da janela** (foco, animação), nunca com dado nem regra.
- **Thread da interface:** atualização de propriedade ligada à tela no dispatcher (`Dispatcher`/`DispatcherQueue`); trabalho de I/O em `async`, nunca bloqueando a thread da tela.
- **Navegação e diálogos são serviços injetados** (porta na aplicação ou na borda), para a ViewModel ser testável sem janela.

## NET-D3 Ponto de composição

`App.xaml.cs` (ou `Program.cs` no WinForms) monta o `IHost`/`ServiceCollection` com as mesmas extensões `Add{X}` do perfil .NET e resolve a janela principal — um lugar só (V16).

## NET-D4 Automação, acessibilidade e identificadores de teste

- **Todo controle interativo e todo item de lista tem `AutomationProperties.AutomationId="<área>.<elemento>[.<id>]"`** (WPF/WinUI; no WinForms, `AccessibleName` + `Name` estável). É o que a automação de interface do Windows (UI Automation, ferramenta FlaUI) usa para achar o elemento — no executor de cenários (`accept.ps1`, alvo desktop, no próximo incremento) e nos testes de UI.
- **Acessibilidade:** `AutomationProperties.Name` em todo controle sem texto, ordem de tabulação, alto contraste e escala de texto do Windows a 200 % sem cortar conteúdo.

## NET-D5 Testes por nível

| Nível | Projeto | Ferramenta |
|---|---|---|
| Unidade (domínio, aplicação, **ViewModels**) | `tests/{Produto}.Unit.Tests` | xUnit (como no perfil .NET) |
| Arquitetura | `tests/{Produto}.Architecture.Tests` | NetArchTest/ArchUnitNET |
| Integração (banco local, arquivos) | `tests/{Produto}.Integration.Tests` | xUnit com a dependência real |
| UI | `tests/{Produto}.UI.Tests` | FlaUI (UIA3) abrindo o executável |
| Cenários de aceite | `.team-project/quality-assurance/scenarios/*.scn` | `accept.ps1` (alvo desktop, próximo incremento) |

- **Comandos com higiene:** o `verify` acrescenta `MSBUILDDISABLENODEREUSE=1` e `UseSharedCompilation=false` (os nós do MSBuild e o servidor do compilador ficam vivos e seguram o chamador).

## NET-D6 Entrega

**MSIX** (ou o instalador do projeto) gerado do código final; o portão do QA abre o executável publicado (`dotnet publish -c Release`), não o de depuração.
