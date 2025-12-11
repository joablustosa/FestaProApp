import 'package:flutter/material.dart';

class AgendaNavigation extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AgendaNavigation({
    super.key,
    required this.child,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          // Botão de "Voltar à Agenda" sempre presente
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Navega de volta para a agenda principal
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            tooltip: 'Voltar à Agenda',
          ),
          // Ações adicionais se fornecidas
          if (actions != null) ...actions!,
        ],
      ),
      body: child,
    );
  }
}

// Widget para botão flutuante de "Voltar à Agenda"
class AgendaFloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String tooltip;

  const AgendaFloatingButton({
    super.key,
    this.onPressed,
    this.tooltip = 'Voltar à Agenda',
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed ?? () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      backgroundColor: Colors.green,
      child: const Icon(Icons.calendar_today, color: Colors.white),
      tooltip: tooltip,
    );
  }
}

// Widget para botão de "Voltar à Agenda" em headers
class AgendaHeaderButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String tooltip;
  final double size;

  const AgendaHeaderButton({
    super.key,
    this.onPressed,
    this.tooltip = 'Voltar à Agenda',
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      icon: Icon(
        Icons.calendar_today,
        color: Colors.white,
        size: size,
      ),
      tooltip: tooltip,
    );
  }
}
