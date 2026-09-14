import 'package:flutter/material.dart';

/// InSpace App Theme - Material 3 specification
/// Tailored for deep media contrast with Celestial Emerald and Nebula Indigo accents.
class InSpaceTheme {
  // Brand Palette Constants
  static const Color obsidianBg = Color(0xFF0B0F19);
  static const Color slateCard = Color(0xFF111827);
  static const Color slateElevated = Color(0xFF1F2937);
  static const Color slateBorder = Color(0xFF374151);

  static const Color indigoPrimary = Color(0xFF6366F1);
  static const Color emeraldFreed = Color(0xFF10B981);
  static const Color blueSynced = Color(0xFF3B82F6);
  static const Color amberVaulting = Color(0xFFF59E0B);
  static const Color slateLocal = Color(0xFF94A3B8);

  // Dark Theme (Default for media gallery apps)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: obsidianBg,
      colorScheme: const ColorScheme.dark(
        primary: indigoPrimary,
        onPrimary: Colors.white,
        secondary: emeraldFreed,
        onSecondary: Colors.black,
        surface: slateCard,
        onSurface: Colors.white,
        outline: slateBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: slateCard.withOpacity(0.92),
        indicatorColor: indigoPrimary.withOpacity(0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: indigoPrimary);
          }
          return const IconThemeData(color: Color(0xFF94A3B8));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: indigoPrimary);
          }
          return const TextStyle(fontSize: 11, fontWeight: FontWeight.normal, color: Color(0xFF94A3B8));
        }),
      ),
    );
  }
}

