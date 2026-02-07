import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final LinearGradient scaffoldGradient;
  final Color glassBaseColor;
  final Color glassBorderColor;
  final Color accentColor;
  final Color textColor;
  final Color secondaryTextColor;

  const AppThemeExtension({
    required this.scaffoldGradient,
    required this.glassBaseColor,
    required this.glassBorderColor,
    required this.accentColor,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  AppThemeExtension copyWith({
    LinearGradient? scaffoldGradient,
    Color? glassBaseColor,
    Color? glassBorderColor,
    Color? accentColor,
    Color? textColor,
    Color? secondaryTextColor,
  }) {
    return AppThemeExtension(
      scaffoldGradient: scaffoldGradient ?? this.scaffoldGradient,
      glassBaseColor: glassBaseColor ?? this.glassBaseColor,
      glassBorderColor: glassBorderColor ?? this.glassBorderColor,
      accentColor: accentColor ?? this.accentColor,
      textColor: textColor ?? this.textColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      scaffoldGradient: LinearGradient.lerp(
        scaffoldGradient,
        other.scaffoldGradient,
        t,
      )!,
      glassBaseColor: Color.lerp(glassBaseColor, other.glassBaseColor, t)!,
      glassBorderColor: Color.lerp(
        glassBorderColor,
        other.glassBorderColor,
        t,
      )!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      secondaryTextColor: Color.lerp(
        secondaryTextColor,
        other.secondaryTextColor,
        t,
      )!,
    );
  }

  static const AppThemeExtension dark = AppThemeExtension(
    
    scaffoldGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0F172A), Color(0xFF1E293B), Colors.black],
    ),
    glassBaseColor: Color(0x1AFFFFFF),
    glassBorderColor: Color(0x33FFFFFF),
    accentColor: Color(0xFF38BDF8),
    textColor: Colors.white,

    secondaryTextColor: Color(0xFF94A3B8),
  );

  static const AppThemeExtension light = AppThemeExtension(
    scaffoldGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0), Colors.white],
    ),
    glassBaseColor: Color(0x0D0F172A),
    glassBorderColor: Color(0x1A0F172A),
    accentColor: Color(0xFF0369A1), 
    textColor: Color(0xFF0F172A),
    secondaryTextColor: Color(0xFF475569),
  );
}
