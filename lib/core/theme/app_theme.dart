import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_theme_extension.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    extensions: [AppThemeExtension.light],
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0F172A),
      secondary: AppColors.secondary,
      surface: Colors.white,
      error: AppColors.error,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1.copyWith(color: const Color(0xFF0F172A)),
      displayMedium: AppTextStyles.h2.copyWith(color: const Color(0xFF0F172A)),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: const Color(0xFF1E293B),
      ),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: const Color(0xFF1E293B),
      ),
      labelLarge: AppTextStyles.buttonLabel,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF0F172A)),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    extensions: [AppThemeExtension.dark],
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1,
      displayMedium: AppTextStyles.h2,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      labelLarge: AppTextStyles.buttonLabel,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
