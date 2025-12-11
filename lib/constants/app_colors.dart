import 'package:flutter/material.dart';

class AppColors {
  // Cores principais
  static const Color primary = Colors.green;
  static const Color primaryAccent = Colors.greenAccent;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Colors.green, Colors.greenAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Cores de estado
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;
  
  // Cores de texto
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color textLight = Colors.white;
  static const Color textLightSecondary = Colors.white70;
  
  // Cores de fundo
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;
  
  // Sombras
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  
  // Bordas arredondadas
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(8));
}

class AppStyles {
  // Textos
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: AppColors.textLight,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: AppColors.textLightSecondary,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
  
  // Espaçamentos
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Tamanhos de ícones
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
}
