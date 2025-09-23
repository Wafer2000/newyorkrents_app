import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColorsLight.primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: AppColorsLight.primary,
        onPrimary: AppColorsLight.textOnPrimary,
        surface: AppColorsLight.surface,
        background: AppColorsLight.background,
        error: AppColorsLight.error,
      ),
      scaffoldBackgroundColor: AppColorsLight.background,
      textTheme: AppTypography.lightText().apply(
        bodyColor: AppColorsLight.textPrimary,
        displayColor: AppColorsLight.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsLight.surface,
        elevation: 0,
        foregroundColor: AppColorsLight.textPrimary,
      ),
      chipTheme: const ChipThemeData(
        side: BorderSide(color: Color(0xFFE0E0E0)),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColorsDark.primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: AppColorsDark.primary,
        onPrimary: AppColorsDark.textOnPrimary,
        surface: AppColorsDark.surface,
        background: AppColorsDark.background,
        error: AppColorsDark.error,
      ),
      scaffoldBackgroundColor: AppColorsDark.background,
      textTheme: AppTypography.darkText().apply(
        bodyColor: AppColorsDark.textPrimary,
        displayColor: AppColorsDark.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsDark.surface,
        elevation: 0,
        foregroundColor: AppColorsDark.textPrimary,
      ),
      chipTheme: const ChipThemeData(
        side: BorderSide(color: Color(0xFF3C4150)),
      ),
    );
  }
}
