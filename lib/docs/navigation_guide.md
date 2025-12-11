# Guia de Navegação - Agenda Doméstica

## Visão Geral
O app implementa um sistema de navegação inteligente que permite aos usuários voltar facilmente à tela principal da agenda de várias formas.

## Funcionalidades de Navegação

### 1. Botão Flutuante Inteligente
- **Na Agenda**: Mostra o botão "+" para adicionar nova faxina
- **Em outras telas**: Mostra o botão de calendário para voltar à agenda
- **Localização**: Sempre no centro da navegação inferior

### 2. Botões de "Voltar à Agenda" em AppBars
- **Ícone de calendário**: Presente em todas as telas secundárias
- **Funcionalidade**: Navega diretamente para a agenda principal
- **Posicionamento**: Lado direito do AppBar

### 3. Navegação Inferior Persistente
- **Dashboard**: Primeira aba (ícone de dashboard)
- **Agenda**: Tela central (ícone de calendário)
- **Configurações**: Terceira aba (ícone de engrenagem)

### 4. Botão de Rodapé Persistente
- **Visibilidade**: Aparece quando não está na agenda
- **Funcionalidade**: Botão grande e visível para voltar à agenda
- **Estilo**: Verde com ícone de calendário

### 5. Navegação Contextual
- **Botão Voltar**: Navega para a tela anterior
- **Botão Agenda**: Navega para a agenda principal
- **Navegação Inteligente**: `popUntil` para voltar à raiz

## Como Usar

### Para Desenvolvedores

#### 1. Widget AgendaNavigation
```dart
AgendaNavigation(
  title: 'Título da Tela',
  actions: [
    IconButton(
      icon: Icon(Icons.add),
      onPressed: () {},
    ),
  ],
  child: YourScreenContent(),
)
```

#### 2. Widget QuickNavigation
```dart
QuickNavigation(
  customTitle: 'Voltar ao Calendário',
  onBackToAgenda: () {
    // Lógica personalizada
  },
)
```

#### 3. Widget HeaderQuickNavigation
```dart
HeaderQuickNavigation(
  customTitle: 'Agenda',
  iconSize: 28,
)
```

### Para Usuários

#### 1. Navegação Rápida
- **Toque no botão flutuante** quando não estiver na agenda
- **Use o botão de rodapé** para voltar rapidamente
- **Toque no ícone de calendário** no AppBar

#### 2. Navegação por Abas
- **Dashboard**: Para ver estatísticas
- **Agenda**: Tela principal do calendário
- **Configurações**: Para gerenciar perfil e clientes

#### 3. Navegação Contextual
- **Botão Voltar**: Para a tela anterior
- **Botão Agenda**: Para a agenda principal

## Benefícios da UX

### 1. Consistência
- Botões de "Voltar à Agenda" em todas as telas
- Ícones padronizados e intuitivos
- Cores consistentes (verde e branco)

### 2. Acessibilidade
- Múltiplas formas de navegação
- Botões grandes e visíveis
- Tooltips informativos

### 3. Eficiência
- Navegação direta à agenda principal
- Redução de toques para voltar
- Indicadores visuais claros

### 4. Intuitividade
- Ícones familiares (calendário, seta)
- Posicionamento lógico dos botões
- Feedback visual imediato

## Estrutura de Arquivos

```
lib/
├── widgets/
│   ├── agenda_navigation.dart      # Widget principal de navegação
│   └── quick_navigation.dart       # Navegação rápida e flutuante
├── constants/
│   └── app_colors.dart            # Cores e estilos centralizados
└── docs/
    └── navigation_guide.md        # Esta documentação
```

## Manutenção

### Adicionando Nova Tela
1. Use `AgendaNavigation` como wrapper
2. Adicione botão de "Voltar à Agenda" no AppBar
3. Considere usar `QuickNavigation` para navegação adicional

### Modificando Navegação
1. Atualize os widgets em `lib/widgets/`
2. Mantenha consistência visual
3. Teste em diferentes tamanhos de tela

### Personalização
1. Modifique cores em `AppColors`
2. Ajuste estilos em `AppStyles`
3. Atualize ícones e textos conforme necessário
