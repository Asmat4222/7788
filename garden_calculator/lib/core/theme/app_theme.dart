import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Builds the light and dark [ThemeData] used across the app.
///
/// Typography is intentionally large and readable (Plus Jakarta Sans for
/// headings, Inter for body) to improve on the reference experience.
class AppTheme {
  AppTheme._();

  static const double radiusSm = 12;
  static const double radiusMd = 18;
  static const double radiusLg = 26;

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        scaffold: AppColors.darkBg,
        surface: AppColors.darkSurface,
        surfaceAlt: AppColors.darkSurfaceAlt,
        border: AppColors.darkBorder,
        text: AppColors.textDark,
        textMuted: AppColors.textDarkMuted,
      );

  static ThemeData light() => _build(
        brightness: Brightness.light,
        scaffold: AppColors.lightBg,
        surface: AppColors.lightSurface,
        surfaceAlt: AppColors.lightSurfaceAlt,
        border: AppColors.lightBorder,
        text: AppColors.textLight,
        textMuted: AppColors.textLightMuted,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color scaffold,
    required Color surface,
    required Color surfaceAlt,
    required Color border,
    required Color text,
    required Color textMuted,
  }) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);

    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: text,
      displayColor: text,
    );

    final headingFont = GoogleFonts.plusJakartaSans(
      fontWeight: FontWeight.w800,
      color: text,
    );

    return base.copyWith(
      scaffoldBackgroundColor: scaffold,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.emerald,
        onPrimary: Colors.white,
        secondary: AppColors.gold,
        onSecondary: Colors.black,
        error: AppColors.rose,
        onError: Colors.white,
        surface: surface,
        onSurface: text,
        surfaceContainerHighest: surfaceAlt,
        outline: border,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: headingFont.copyWith(fontSize: 46, height: 1.05),
        displayMedium: headingFont.copyWith(fontSize: 36, height: 1.1),
        headlineMedium: headingFont.copyWith(fontSize: 26),
        headlineSmall: headingFont.copyWith(fontSize: 21),
        titleLarge: headingFont.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.plusJakartaSans(
            fontSize: 15, fontWeight: FontWeight.w700, color: text),
        labelLarge: GoogleFonts.inter(
            fontWeight: FontWeight.w600, letterSpacing: 0.2, color: text),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: textMuted),
        labelStyle: TextStyle(color: textMuted),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: border),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: AppColors.emerald, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.emerald,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusSm)),
          textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 0.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusSm)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surfaceAlt,
        side: BorderSide(color: border),
        labelStyle: TextStyle(color: text, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: surfaceAlt,
        contentTextStyle: TextStyle(color: text),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: surfaceAlt,
          borderRadius: BorderRadius.circular(radiusSm),
          border: Border.all(color: border),
        ),
        textStyle: TextStyle(color: text),
      ),
    );
  }
}
