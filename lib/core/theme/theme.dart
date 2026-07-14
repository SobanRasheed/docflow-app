import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final primary = AppColors.brand600;
    final onPrimary = Colors.white;
    final background = isLight ? AppColors.lightBackground : AppColors.darkBackground;
    final surface = isLight ? AppColors.lightSurface : AppColors.darkSurface;
    final onSurface = isLight ? AppColors.slate900 : AppColors.slate50;
    final outline = isLight ? AppColors.slate200 : AppColors.slate700;

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: AppColors.brand100,
        onPrimaryContainer: AppColors.brand900,
        secondary: AppColors.brand400,
        onSecondary: AppColors.slate900,
        secondaryContainer: AppColors.brand50,
        onSecondaryContainer: AppColors.brand800,
        tertiary: AppColors.info,
        onTertiary: Colors.white,
        error: AppColors.danger,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
      ),
      splashFactory: InkSparkle.splashFactory,
      dividerColor: outline,
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: onSurface,
        displayColor: onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: onSurface,
        titleTextStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacings.cardRadius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: primary,
          foregroundColor: onPrimary,
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacings.cardRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: primary,
          side: BorderSide(color: outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacings.cardRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AppColors.slate50 : AppColors.slate800,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacings.cardRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacings.cardRadius),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacings.cardRadius),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight ? AppColors.lightGlass : AppColors.darkGlass,
        elevation: 0,
        height: 72,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.brand100,
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        iconTheme: const WidgetStatePropertyAll(
          IconThemeData(size: 24),
        ),
      ),
      iconTheme: IconThemeData(
        color: onSurface,
        size: 24,
      ),
      dividerTheme: DividerThemeData(
        color: outline,
        thickness: 1,
        space: 1,
      ),
    );
  }
}