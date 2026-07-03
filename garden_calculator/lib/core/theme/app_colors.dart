import 'package:flutter/material.dart';

/// Central colour palette for GrowVault.
///
/// The brand is an original "emerald garden" identity — deep midnight-green
/// backgrounds, vivid emerald primaries and a warm gold accent. None of the
/// reference site's colours, logos or assets are reused.
class AppColors {
  AppColors._();

  // Brand primaries
  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldLight = Color(0xFF34D399);
  static const Color emeraldDark = Color(0xFF059669);

  // Warm accent (used for value / gold highlights)
  static const Color gold = Color(0xFFF59E0B);
  static const Color goldLight = Color(0xFFFBBF24);

  // Secondary accent (cosmic / rare mutations)
  static const Color violet = Color(0xFF8B5CF6);
  static const Color sky = Color(0xFF38BDF8);
  static const Color rose = Color(0xFFF43F5E);

  // Dark surfaces
  static const Color darkBg = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF111C2E);
  static const Color darkSurfaceAlt = Color(0xFF16233A);
  static const Color darkBorder = Color(0xFF223048);

  // Light surfaces
  static const Color lightBg = Color(0xFFF3F7F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFEAF2EE);
  static const Color lightBorder = Color(0xFFDCE7E1);

  // Text
  static const Color textDark = Color(0xFFE2E8F0);
  static const Color textDarkMuted = Color(0xFF94A3B8);
  static const Color textLight = Color(0xFF0F1B15);
  static const Color textLightMuted = Color(0xFF5B6B62);

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [emeraldLight, emeraldDark],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, gold],
  );

  static const LinearGradient cosmicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [violet, sky],
  );

  static const RadialGradient heroGlowDark = RadialGradient(
    center: Alignment(0, -1.1),
    radius: 1.4,
    colors: [Color(0xFF14493A), darkBg],
    stops: [0.0, 0.6],
  );

  static const RadialGradient heroGlowLight = RadialGradient(
    center: Alignment(0, -1.1),
    radius: 1.4,
    colors: [Color(0xFFD6EFE3), lightBg],
    stops: [0.0, 0.6],
  );
}
