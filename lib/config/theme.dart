import 'package:flutter/material.dart';
import 'tokens.dart';

class AppTheme {
  static ThemeData buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentPlayer,
        secondary: AppColors.accentEnemy,
        surface: AppColors.surfacePrimary,
        background: AppColors.backgroundPrimary,
        error: AppColors.stateDanger,
        onPrimary: AppColors.backgroundPrimary,
        onSecondary: AppColors.backgroundPrimary,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: AppTypography.headlineSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: AppTypography.letterSpacingTight,
        ),
        titleMedium: TextStyle(
          fontSize: AppTypography.titleSize,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppTypography.bodySize,
          fontWeight: FontWeight.w500,
          color: AppColors.textMuted,
        ),
        labelLarge: TextStyle(
          fontSize: AppTypography.labelSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: AppTypography.letterSpacingWide,
        ),
      ),
    );
  }
}
