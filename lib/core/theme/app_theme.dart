import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme.dark().copyWith(
      primary: AppColors.primary,
      onPrimary: const Color(0xFF0F172A),
      primaryContainer: AppColors.primaryMuted,
      onPrimaryContainer: AppColors.darkTextPrimary,
      secondary: AppColors.info,
      onSecondary: Colors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkBorderSubtle,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: colorScheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      ),
      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.roundedMd,
          side: const BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: AppRadii.roundedMd,
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.roundedMd,
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.roundedMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.roundedMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1.0),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.darkTextMuted),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.darkTextSecondary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        indicatorColor: AppColors.primarySoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return AppTypography.caption.copyWith(color: AppColors.darkTextMuted);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 22);
          }
          return const IconThemeData(color: AppColors.darkTextMuted, size: 22);
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.darkTextPrimary),
        displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.darkTextPrimary),
        titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.darkTextPrimary),
        titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.darkTextPrimary),
        titleSmall: AppTypography.titleSmall.copyWith(color: AppColors.darkTextSecondary),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.darkTextPrimary),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.darkTextSecondary),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.darkTextMuted),
        labelSmall: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
      ),
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light().copyWith(
      primary: const Color(0xFF0284C7),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE0F2FE),
      onPrimaryContainer: const Color(0xFF0369A1),
      secondary: AppColors.info,
      onSecondary: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.lightBorder,
      outlineVariant: AppColors.lightBorderSubtle,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: colorScheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      ),
      cardTheme: CardTheme(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.roundedMd,
          side: const BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: AppRadii.roundedMd,
          borderSide: const BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.roundedMd,
          borderSide: const BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.roundedMd,
          borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.roundedMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1.0),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextMuted),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        indicatorColor: const Color(0xFFE0F2FE),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.caption.copyWith(
              color: const Color(0xFF0284C7),
              fontWeight: FontWeight.w700,
            );
          }
          return AppTypography.caption.copyWith(color: AppColors.lightTextMuted);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF0284C7), size: 22);
          }
          return const IconThemeData(color: AppColors.lightTextMuted, size: 22);
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.lightTextPrimary),
        displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.lightTextPrimary),
        titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.lightTextPrimary),
        titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.lightTextPrimary),
        titleSmall: AppTypography.titleSmall.copyWith(color: AppColors.lightTextSecondary),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.lightTextPrimary),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.lightTextMuted),
        labelSmall: AppTypography.caption.copyWith(color: AppColors.lightTextMuted),
      ),
    );
  }
}
