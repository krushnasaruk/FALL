import 'package:flutter/material.dart';

class AppRadii {
  AppRadii._();

  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double card = 24.0;
  static const double cardLg = 28.0;
  static const double full = 999.0;

  static const BorderRadius roundedXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius roundedCard = BorderRadius.all(Radius.circular(card));
  static const BorderRadius roundedCardLg = BorderRadius.all(Radius.circular(cardLg));
  static const BorderRadius roundedFull = BorderRadius.all(Radius.circular(full));
}
