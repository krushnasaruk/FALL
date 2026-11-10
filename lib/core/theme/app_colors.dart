import 'package:flutter/material.dart';

/// Master Design System Color Tokens (Light Mode Primary + Independent Dark Mode).
/// Follows the disciplined 75-85% neutral surface balance, 10-20% restrained pastel
/// module identities, and crisp high-contrast semantic accents.
class AppColors {
  AppColors._();

  // Light Foundation Neutral Tokens (Primary Experience)
  static const Color background = Color(0xFFF8F9FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF1F3F9);
  static const Color border = Color(0xFFEAECF1);
  static const Color borderSubtle = Color(0xFFF3F5FA);
  static const Color divider = Color(0xFFEAECF1);

  // Dark Foundation Neutral Tokens (Independent Dark Theme)
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkSurfaceElevated = Color(0xFF21262D);
  static const Color darkBorder = Color(0xFF30363D);
  static const Color darkBorderSubtle = Color(0xFF21262D);
  static const Color darkDivider = Color(0xFF21262D);

  // Typography Colors
  static const Color textPrimary = Color(0xFF171923);
  static const Color textSecondary = Color(0xFF727786);
  static const Color textTertiary = Color(0xFFA0A5B0);
  static const Color textMuted = textTertiary;
  static const Color textLight = Color(0xFFFFFFFF);

  static const Color darkTextPrimary = Color(0xFFF0F6FC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF6E7681);
  static const Color darkTextMuted = darkTextTertiary;

  // Brand & Core Action Accents
  static const Color primary = Color(0xFF7167E8);
  static const Color primaryDark = Color(0xFF8B83F6);
  static const Color primarySoft = Color(0xFFEEECFC);
  static const Color secondary = Color(0xFF70BDEB);
  static const Color accent = Color(0xFFA586F8);
  static const Color buttonDark = Color(0xFF171923);

  // Semantics
  static const Color success = Color(0xFF62B989);
  static const Color warning = Color(0xFFE9B85B);
  static const Color error = Color(0xFFE47C86);
  static const Color info = Color(0xFF7167E8);

  static const Color infoSoft = Color(0xFFEEF2FF);
  static const Color successSoft = Color(0xFFECFDF5);
  static const Color warningSoft = Color(0xFFFFFBEB);
  static const Color errorSoft = Color(0xFFFEF2F2);

  // Semantic Module Identities — Soft Light Surfaces
  // Tasks: Soft Blue
  static const Color taskBlue = Color(0xFFA8DDF5);
  static const Color taskSurface = Color(0xFFF0F8FE);
  static const Color taskBorder = Color(0xFFD7ECFA);
  static const Color taskAccent = Color(0xFF2B7FB8);

  // Projects: Soft Lavender
  static const Color projectLavender = Color(0xFFE9E6FB);
  static const Color projectSurface = Color(0xFFF3F1FD);
  static const Color projectBorder = Color(0xFFDFD9F8);
  static const Color projectAccent = Color(0xFF5D52D6);

  // Legacy project pink tokens retained for controlled highlights
  static const Color projectPink = Color(0xFFF7A6D2);
  static const Color projectPinkHero = Color(0xFFE8437D);
  static const Color projectPinkEnd = Color(0xFFFF85B8);
  static const Color projectCoral = Color(0xFFFF9EAA);
  static const Color taskBlueStart = Color(0xFFBAE6FD);
  static const Color taskBlueEnd = Color(0xFF90DBF9);

  // Learning: Lavender & Sky Blue
  static const Color learningPurple = Color(0xFFD8B9F4);
  static const Color learningSurface = Color(0xFFF3EFFD);
  static const Color learningBorder = Color(0xFFE2D8FA);
  static const Color learningAccent = Color(0xFF6B4FD6);
  static const Color learningPurpleStart = Color(0xFFE6D2FB);
  static const Color learningPurpleEnd = Color(0xFFC79EF2);

  // Goals: Butter Yellow & Warm Orange
  static const Color goalYellow = Color(0xFFF5E69B);
  static const Color goalSurface = Color(0xFFFFF8E6);
  static const Color goalBorder = Color(0xFFF7E4B4);
  static const Color goalAccent = Color(0xFFB7791F);
  static const Color goalYellowStart = Color(0xFFFDF0B0);
  static const Color goalYellowEnd = Color(0xFFEED77A);

  // Habits: Muted Mint Green
  static const Color habitGreen = Color(0xFFB9E7B7);
  static const Color habitSurface = Color(0xFFEEF9F2);
  static const Color habitBorder = Color(0xFFCDEBD7);
  static const Color habitAccent = Color(0xFF2E8555);
  static const Color habitGreenStart = Color(0xFFCCF2CA);
  static const Color habitGreenEnd = Color(0xFFA1DE9E);

  // Focus: Cyan & Blue
  static const Color analyticsCyan = Color(0xFFA9E9E8);
  static const Color focusSurface = Color(0xFFEBF8FC);
  static const Color focusBorder = Color(0xFFCCEBF5);
  static const Color focusAccent = Color(0xFF1D7FA8);
  static const Color analyticsCyanStart = Color(0xFFC3F3F2);
  static const Color analyticsCyanEnd = Color(0xFF8CE1E0);

  // Notes & Journal: Neutral with subtle warm tint
  static const Color noteCream = Color(0xFFF6EBDD);
  static const Color noteSurface = Color(0xFFF9F7F3);
  static const Color noteBorder = Color(0xFFEAE3D7);
  static const Color noteCreamStart = Color(0xFFFAF3EB);
  static const Color noteCreamEnd = Color(0xFFEFE0CD);

  // Independent Dark Module Tints (subtle translucent depth on dark surface)
  static const Color darkTaskSurface = Color(0xFF14212E);
  static const Color darkProjectSurface = Color(0xFF1A1B2E);
  static const Color darkLearningSurface = Color(0xFF1B1A2D);
  static const Color darkGoalSurface = Color(0xFF241E14);
  static const Color darkHabitSurface = Color(0xFF14231C);
  static const Color darkFocusSurface = Color(0xFF13222A);
  static const Color darkNoteSurface = Color(0xFF1B1A18);

  // Priority Accents
  static const Color priorityLow = Color(0xFF64748B);
  static const Color priorityMedium = Color(0xFF3B82F6);
  static const Color priorityHigh = Color(0xFFD97706);
  static const Color priorityUrgent = Color(0xFFDC2626);

  // Status Accents
  static const Color statusActive = Color(0xFF2E8555);
  static const Color statusPlanning = Color(0xFF5D52D6);
  static const Color statusOnHold = Color(0xFFB7791F);
  static const Color statusCompleted = Color(0xFF2B7FB8);
  static const Color statusArchived = Color(0xFF64748B);

  // System Aliases for Backward Compatibility
  static const Color lightBackground = background;
  static const Color lightSurface = surface;
  static const Color lightSurfaceElevated = surfaceElevated;
  static const Color lightBorder = border;
  static const Color lightBorderSubtle = borderSubtle;
  static const Color lightTextPrimary = textPrimary;
  static const Color lightTextSecondary = textSecondary;
  static const Color lightTextMuted = textTertiary;

  static const Color techLanguage = Color(0xFF3B82F6);
  static const Color techFramework = Color(0xFF8B5CF6);
  static const Color techAI = Color(0xFFEC4899);
  static const Color techSystems = Color(0xFF10B981);
  static const Color techDatabase = Color(0xFFF59E0B);
  static const Color techCloud = Color(0xFF06B6D4);
  static const Color githubContributions = Color(0xFF22C55E);

  // Restrained Gradients (subtle tonal shifts only where purposeful)
  static const LinearGradient todayProgressGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEDF1FD), Color(0xFFE3ECFC)],
  );

  static const LinearGradient focusPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEDF7FC), Color(0xFFE2F2FA)],
  );

  static const LinearGradient projectHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7167E8), Color(0xFF8A81F2)],
  );

  static const LinearGradient projectPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF3F1FD), Color(0xFFEAE6FA)],
  );

  static const LinearGradient taskPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0F8FE), Color(0xFFE3F2FC)],
  );

  static const LinearGradient learningPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF2EEFD), Color(0xFFE6EEFC)],
  );

  static const LinearGradient habitPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEEF9F2), Color(0xFFE2F4E9)],
  );

  static const LinearGradient goalPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF8E6), Color(0xFFFDF1D3)],
  );

  static const LinearGradient analyticsPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEDF6FD), Color(0xFFEDEBFD)],
  );

  static const LinearGradient cyanPastelGradient = analyticsPastelGradient;

  static const LinearGradient notePastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF9F7F3)],
  );

  static const LinearGradient notesPastelGradient = notePastelGradient;
}
