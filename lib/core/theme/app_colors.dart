import 'package:flutter/material.dart';

/// ProgressOS Design System - Color Palette
/// Designed with a minimalist, sophisticated tech command center aesthetic:
/// Deep slate/zinc neutrals, high contrast readability, precise semantic accents.
class AppColors {
  AppColors._();

  // Dark Palette (Primary Command Center experience)
  static const Color darkBackground = Color(0xFF090D16);
  static const Color darkSurface = Color(0xFF111726);
  static const Color darkSurfaceElevated = Color(0xFF192237);
  static const Color darkBorder = Color(0xFF222F4C);
  static const Color darkBorderSubtle = Color(0xFF1A2338);

  // Light Palette
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderSubtle = Color(0xFFEDF2F7);

  // Text Colors - Dark Mode
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Text Colors - Light Mode
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Brand / Primary Accents
  static const Color primary = Color(0xFF38BDF8); // Electric Sky
  static const Color primaryHover = Color(0xFF0284C7);
  static const Color primaryMuted = Color(0xFF075985);
  static const Color primarySoft = Color(0x1F38BDF8);

  // Semantic Accents
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color successSoft = Color(0x1F10B981);
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningSoft = Color(0x1FF59E0B);
  static const Color error = Color(0xFFEF4444); // Crimson
  static const Color errorSoft = Color(0x1FEF4444);
  static const Color info = Color(0xFF6366F1); // Indigo
  static const Color infoSoft = Color(0x1F6366F1);

  // Priority Accents
  static const Color priorityLow = Color(0xFF64748B); // Slate
  static const Color priorityMedium = Color(0xFF3B82F6); // Blue
  static const Color priorityHigh = Color(0xFFF59E0B); // Amber
  static const Color priorityUrgent = Color(0xFFEF4444); // Crimson

  // Skill / Tech Category Accents
  static const Color techLanguage = Color(0xFF38BDF8); // Cyan/Sky
  static const Color techFramework = Color(0xFF818CF8); // Indigo
  static const Color techAI = Color(0xFFA855F7); // Purple
  static const Color techSystems = Color(0xFF10B981); // Emerald
  static const Color techDatabase = Color(0xFFEC4899); // Pink
  static const Color techCloud = Color(0xFFF97316); // Orange

  // Project Status Accents
  static const Color statusPlanning = Color(0xFFA855F7);
  static const Color statusActive = Color(0xFF10B981);
  static const Color statusOnHold = Color(0xFFF59E0B);
  static const Color statusCompleted = Color(0xFF06B6D4);
  static const Color statusArchived = Color(0xFF64748B);
}
