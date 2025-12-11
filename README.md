# Agenda Doméstica

Um aplicativo Flutter para gerenciar agenda de faxinas domésticas, desenvolvido com foco em usabilidade e design moderno.

## 🚀 Funcionalidades

### 📱 Tela Principal (Calendário)
- Visualização mensal do calendário
- Lista de faxinas do dia selecionado
- Navegação entre meses
- Indicadores visuais para dias com faxinas agendadas

### 📊 Dashboard
- Resumo financeiro do mês
- Total de faxinas realizadas
- Valor total a receber
- Progresso mensal com gráfico
- Lista das próximas faxinas

### ⚙️ Configurações
- Perfil do usuário
- Configurações de notificação
- Privacidade e segurança
- Histórico de pagamentos
- Ajuda e suporte

### ➕ Gerenciamento de Eventos
- Adicionar novas faxinas
- Editar informações existentes
- Marcar como realizada/não realizada
- Excluir faxinas
- Dados completos: cliente, endereço, valor, data e hora

## 🎨 Design

- **Cores principais**: Verde e branco
- **Interface**: Moderna e intuitiva
- **Responsivo**: Adaptável a diferentes tamanhos de tela
- **Ícones**: Material Design Icons

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento
- **Dart**: Linguagem de programação
- **table_calendar**: Widget de calendário
- **intl**: Internacionalização e formatação de datas

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/
│   └── faxina.dart          # Modelo de dados para faxinas
└── screens/
    ├── home_screen.dart      # Tela principal com navegação
    ├── calendar_screen.dart  # Tela do calendário
    ├── day_details_screen.dart # Detalhes do dia selecionado
    ├── dashboard_screen.dart # Dashboard com resumos
    └── profile_screen.dart   # Tela de perfil e configurações
```

## 🚀 Como Executar

1. **Instalar dependências**:
   ```bash
   flutter pub get
   ```

2. **Executar o aplicativo**:
   ```bash
   flutter run
   ```

3. **Para executar no simulador**:
   ```bash
   flutter run -d <device_id>
   ```

## 📱 Funcionalidades Principais

### Adicionar Nova Evento
- Cliente (nome)
- Endereço completo
- Valor (R$)
- Data selecionada
- Hora escolhida

### Visualização no Calendário
- Dots indicam dias com faxinas
- Lista resumida abaixo do calendário
- Navegação para detalhes do dia

### Dashboard
- Cards informativos com métricas
- Gráfico de progresso mensal
- Lista das próximas faxinas

## 🔧 Configurações

O aplicativo está configurado com:
- Tema verde como cor principal
- Navegação inferior com 3 abas
- Botão flutuante central para adicionar faxinas
- Gradientes e sombras para design moderno

## 📋 Requisitos

- Flutter SDK 3.0.0 ou superior
- Dart 3.0.0 ou superior
- Android Studio / VS Code com extensões Flutter

## 🎯 Próximas Funcionalidades

- [ ] Persistência de dados local
- [ ] Sincronização com servidor
- [ ] Notificações push
- [ ] Relatórios detalhados
- [ ] Múltiplos usuários
- [ ] Backup e restauração

## 📄 Licença

Este projeto é desenvolvido para fins educacionais e de demonstração.

---

Desenvolvido com ❤️ usando Flutter
