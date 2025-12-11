import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class QuickNavigation extends StatelessWidget {
  final VoidCallback? onBackToAgenda;
  final bool showBackButton;
  final String? customTitle;

  const QuickNavigation({
    super.key,
    this.onBackToAgenda,
    this.showBackButton = true,
    this.customTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.primary,
                size: 20,
              ),
              tooltip: 'Voltar',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: onBackToAgenda ?? () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: AppColors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      customTitle ?? 'Voltar à Agenda',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para navegação flutuante
class FloatingQuickNavigation extends StatelessWidget {
  final VoidCallback? onBackToAgenda;
  final String tooltip;

  const FloatingQuickNavigation({
    super.key,
    this.onBackToAgenda,
    this.tooltip = 'Voltar à Agenda',
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onBackToAgenda ?? () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      icon: const Icon(Icons.calendar_today),
      label: const Text('Agenda'),
      tooltip: tooltip,
    );
  }
}

// Widget para navegação em headers
class HeaderQuickNavigation extends StatelessWidget {
  final VoidCallback? onBackToAgenda;
  final String? customTitle;
  final double iconSize;

  const HeaderQuickNavigation({
    super.key,
    this.onBackToAgenda,
    this.customTitle,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onBackToAgenda ?? () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: iconSize,
                ),
                if (customTitle != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    customTitle!,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: iconSize * 0.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
