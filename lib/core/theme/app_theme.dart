import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.indigo,
      brightness: Brightness.dark,
      surface: AppColors.card,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppFonts.primary,
      colorScheme: scheme.copyWith(
        primary: AppColors.indigo,
        secondary: AppColors.emerald,
        surface: AppColors.card,
        outline: AppColors.border,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
      ),
      cardTheme: CardThemeData(color: AppColors.card, margin: EdgeInsets.zero),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.card.withValues(alpha: .94),
        indicatorColor: AppColors.indigo.withValues(alpha: .22),
        labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
