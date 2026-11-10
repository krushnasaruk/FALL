import 'package:flutter/material.dart';

/// Restrained Radii Tokens (16-20px cards, 12px inputs, pill chips).
class AppRadii {
  AppRadii._();

  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 14.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double cardSm = 14.0;
  static const double card = 18.0;
  static const double cardLg = 20.0;
  static const double full = 999.0;

  static const BorderRadius roundedXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius roundedCardSm = BorderRadius.all(Radius.circular(cardSm));
  static const BorderRadius roundedCard = BorderRadius.all(Radius.circular(card));
  static const BorderRadius roundedCardLg = BorderRadius.all(Radius.circular(cardLg));
  static const BorderRadius roundedFull = BorderRadius.all(Radius.circular(full));
}
