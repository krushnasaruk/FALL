import 'package:flutter/material.dart';

/// Consistent 4/8dp Multiples Spacing Scale
class AppSpacing {
  AppSpacing._();

  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 40.0;
  static const double massive = 48.0;

  static const double pageHorizontal = 20.0;

  // Insets
  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
  static const EdgeInsets card = EdgeInsets.all(16.0);
  static const EdgeInsets compactCard = EdgeInsets.all(14.0);
  static const EdgeInsets modal = EdgeInsets.all(24.0);
}
