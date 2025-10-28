import 'package:flutter/material.dart';

/// 🎨 Paleta de cores principal e semântica
class AppColors {
  static const Color primary = Color(0xFF512DA8); // Roxo principal
  static const Color primaryDark = Color(0xFF311B92);
  static const Color secondary = Color(0xFFFFC107); // Amarelo destaque
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1E1E1E);
  static const Color card = Colors.white;
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color textDark = Colors.black87;
  static const Color textLight = Colors.white;
  static const Color error = Colors.redAccent;
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF2196F3);
}

/// 📏 Espaçamentos padronizados (evita valores mágicos)
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// 🔤 Estilos de texto globais
class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textDark,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: Colors.black54,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
}

/// 🌈 Tema global principal
final ThemeData appTheme = ThemeData(
  useMaterial3: true,

  /// Definição da paleta principal
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    background: AppColors.background,
    surface: AppColors.card,
    error: AppColors.error,
    brightness: Brightness.light,
  ),

  /// Fundo padrão das telas
  scaffoldBackgroundColor: AppColors.background,

  /// AppBar moderna e translúcida
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textLight,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: AppColors.textLight,
    ),
  ),

  /// Tipografia base
  textTheme: const TextTheme(
    titleLarge: AppTextStyles.title,
    titleMedium: AppTextStyles.subtitle,
    bodyMedium: AppTextStyles.body,
    bodySmall: AppTextStyles.caption,
  ),

  /// Botões de ação
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textLight,
      textStyle: AppTextStyles.button,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      elevation: 3,
    ),
  ),

  /// Botões secundários (text e outlined)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.secondary,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),

  /// Estilo padrão dos Cards
  cardTheme: const CardThemeData(
    color: AppColors.card,
    elevation: 3,
    shadowColor: Colors.black26,
    margin: EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  /// Campos de texto consistentes
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    labelStyle: const TextStyle(color: Colors.black87),
    hintStyle: const TextStyle(color: Colors.black54),
  ),

  /// Snackbars com contraste alto
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: AppColors.primary,
    contentTextStyle: TextStyle(color: AppColors.textLight),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
);
