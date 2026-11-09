import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.3,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.35,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.25,
  );

  // Card specific minimal typography
  static const TextStyle cardHeader = TextStyle(
    fontSize: 16.5,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const TextStyle cardSub = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle cardPercent = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const TextStyle monoLarge = TextStyle(
    fontFamily: 'monospace',
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle monoMedium = TextStyle(
    fontFamily: 'monospace',
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle monoSmall = TextStyle(
    fontFamily: 'monospace',
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
}
