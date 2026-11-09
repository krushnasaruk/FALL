import 'package:flutter/material.dart';

/// ProgressOS Design System - Visual Reference Palette
/// Based on modern soft pastel aesthetic: rounded cards, gentle multi-color gradients,
/// minimal text density, high visual delight.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFFF8F9FD); // Clean off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF1F3F9);
  static const Color border = Color(0xFFE9ECF5);
  static const Color borderSubtle = Color(0xFFF3F5FA);

  // Dark fallback / Command accents
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceElevated = Color(0xFF283548);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkBorderSubtle = Color(0xFF1E293B);

  // Text Colors
  static const Color textPrimary = Color(0xFF19213D);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFFFFFFFF);

  // Core Brand / Accent
  static const Color primary = Color(0xFF19213D); // Deep dark pill for active controls
  static const Color accent = Color(0xFF38BDF8);

  // 1. Projects Category (Pink & Coral)
  static const Color projectPink = Color(0xFFF7A6D2);
  static const Color projectPinkHero = Color(0xFFFF5E97); // Vivid pink in the hero card
  static const Color projectPinkEnd = Color(0xFFFF85B8);
  static const Color projectCoral = Color(0xFFFF9EAA);

  // 2. Tasks Category (Sky Blue)
  static const Color taskBlue = Color(0xFFA8DDF5);
  static const Color taskBlueStart = Color(0xFFBAE6FD);
  static const Color taskBlueEnd = Color(0xFF90DBF9);

  // 3. Learning & Skills Category (Lavender / Purple)
  static const Color learningPurple = Color(0xFFD8B9F4);
  static const Color learningPurpleStart = Color(0xFFE6D2FB);
  static const Color learningPurpleEnd = Color(0xFFC79EF2);

  // 4. Habits Category (Mint Green)
  static const Color habitGreen = Color(0xFFB9E7B7);
  static const Color habitGreenStart = Color(0xFFCCF2CA);
  static const Color habitGreenEnd = Color(0xFFA1DE9E);

  // 5. Goals Category (Soft Yellow)
  static const Color goalYellow = Color(0xFFF5E69B);
  static const Color goalYellowStart = Color(0xFFFDF0B0);
  static const Color goalYellowEnd = Color(0xFFEED77A);

  // 6. Analytics & Insights Category (Cyan / Aqua)
  static const Color analyticsCyan = Color(0xFFA9E9E8);
  static const Color analyticsCyanStart = Color(0xFFC3F3F2);
  static const Color analyticsCyanEnd = Color(0xFF8CE1E0);

  // 7. Notes & Vault Category (Warm Cream / Peach)
  static const Color noteCream = Color(0xFFF6EBDD);
  static const Color noteCreamStart = Color(0xFFFAF3EB);
  static const Color noteCreamEnd = Color(0xFFEFE0CD);

  // Priority Accents (Pastel chips)
  static const Color priorityLow = Color(0xFF64748B);
  static const Color priorityMedium = Color(0xFF3B82F6);
  static const Color priorityHigh = Color(0xFFF59E0B);
  static const Color priorityUrgent = Color(0xFFEF4444);

  // Semantics
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF6366F1);

  // Status Colors for Badges & Workflow
  static const Color statusActive = Color(0xFF10B981);
  static const Color statusPlanning = Color(0xFF6366F1);
  static const Color statusOnHold = Color(0xFFF59E0B);
  static const Color statusCompleted = Color(0xFF3B82F6);
  static const Color statusArchived = Color(0xFF64748B);

  // Backward Compatibility & System Aliases
  static const Color lightBackground = background;
  static const Color lightSurface = surface;
  static const Color lightSurfaceElevated = surfaceElevated;
  static const Color lightBorder = border;
  static const Color lightBorderSubtle = borderSubtle;
  static const Color lightTextPrimary = textPrimary;
  static const Color lightTextSecondary = textSecondary;
  static const Color lightTextMuted = textMuted;
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  static const Color primarySoft = Color(0xFFE2E8F0);
  static const Color infoSoft = Color(0xFFEEF2FF);
  static const Color successSoft = Color(0xFFECFDF5);
  static const Color warningSoft = Color(0xFFFFFBEB);
  static const Color errorSoft = Color(0xFFFEF2F2);

  static const Color techLanguage = Color(0xFF3B82F6);
  static const Color techFramework = Color(0xFF8B5CF6);
  static const Color techAI = Color(0xFFEC4899);
  static const Color techSystems = Color(0xFF10B981);
  static const Color techDatabase = Color(0xFFF59E0B);
  static const Color techCloud = Color(0xFF06B6D4);
  static const Color githubContributions = Color(0xFF22C55E);

  // Gradients for Cards
  static const LinearGradient projectHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF5290), Color(0xFFFF7BB3)],
  );

  static const LinearGradient projectPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFDE1EF), Color(0xFFF9B8DB)],
  );

  static const LinearGradient taskPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE1F4FD), Color(0xFFB3E5FC)],
  );

  static const LinearGradient learningPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF1E5FC), Color(0xFFDFC6F8)],
  );

  static const LinearGradient habitPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE4F9E3), Color(0xFFC2ECC0)],
  );

  static const LinearGradient goalPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFDF8DA), Color(0xFFF8ECC2)],
  );

  static const LinearGradient analyticsPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE1F9F8), Color(0xFFB8F0EE)],
  );

  static const LinearGradient cyanPastelGradient = analyticsPastelGradient;

  static const LinearGradient notePastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFAF4EC), Color(0xFFF2E6D5)],
  );
}
