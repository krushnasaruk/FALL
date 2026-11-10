import 'package:flutter/material.dart';

/// Master Typography Scale using Plus Jakarta Sans.
/// Hierarchy relies on crisp scale, weight differentiation, and tabular numerals.
class AppTypography {
  AppTypography._();

  static const String primaryFontFamily = 'Plus Jakarta Sans';

  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  // Primary Design Roles
  static const TextStyle display = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.15,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 27.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    height: 1.22,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 19.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static const TextStyle body = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.45,
  );

  static const TextStyle secondary = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle metadata = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.3,
  );

  // Tabular Numerical Statistics
  static const TextStyle statNumerical = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 30.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.1,
    fontFeatures: tabularFigures,
  );

  static const TextStyle statMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    height: 1.15,
    fontFeatures: tabularFigures,
  );

  static const TextStyle timerDisplay = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 44.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.05,
    fontFeatures: tabularFigures,
  );

  // Backward-compatible semantic aliases (preserving all references safely)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 19.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.35,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.45,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.45,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.05,
    height: 1.3,
  );

  static const TextStyle cardHeader = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.15,
    height: 1.3,
  );

  static const TextStyle cardSub = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.35,
  );

  static const TextStyle cardPercent = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    fontFeatures: tabularFigures,
  );

  static const TextStyle monoLarge = TextStyle(
    fontFamily: 'monospace',
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    fontFeatures: tabularFigures,
  );

  static const TextStyle monoMedium = TextStyle(
    fontFamily: 'monospace',
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    fontFeatures: tabularFigures,
  );

  static const TextStyle monoSmall = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    fontFeatures: tabularFigures,
  );
}
