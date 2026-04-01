/// 🤖 Generated wholely or partially with Claude Sonnet 4.5; Ynotes Theme ✨
library;

import 'package:flutter/material.dart';
import 'package:saber/components/theming/saber_theme.dart';
import 'package:saber/ynotes/design_system/design_system.dart';

/// Ynotes top-level theme factory.
///
/// Delegates to [SaberTheme.createThemeFromSeed] for the Material 3 baseline
/// and then applies Ynotes-specific token overrides (colours, typography,
/// radii, etc.).
///
/// Future phases can progressively replace more of the base theme
/// without touching [SaberTheme].
abstract final class YnotesTheme {
  /// Creates the Ynotes light theme.
  static ThemeData light({TargetPlatform? platform}) {
    final base = SaberTheme.createThemeFromSeed(
      YnotesColors.brandIndigo,
      Brightness.light,
      platform ?? TargetPlatform.iOS,
    );
    return _applyOverrides(base, Brightness.light);
  }

  /// Creates the Ynotes dark theme.
  static ThemeData dark({TargetPlatform? platform}) {
    final base = SaberTheme.createThemeFromSeed(
      YnotesColors.brandIndigo,
      Brightness.dark,
      platform ?? TargetPlatform.iOS,
    );
    return _applyOverrides(base, Brightness.dark);
  }

  // ── Private ───────────────────────────────────────────────────────────────

  static ThemeData _applyOverrides(ThemeData base, Brightness brightness) {
    final cs = base.colorScheme.copyWith(
      primary: YnotesColors.brandIndigo,
      onPrimary: YnotesColors.neutral0,
      secondary: YnotesColors.brandIndigoLight,
      surface: YnotesColors.surfacePrimary(brightness),
      onSurface: YnotesColors.onSurface(brightness),
    );

    return base.copyWith(
      colorScheme: cs,
      textTheme: YnotesTypography.textTheme.apply(
        bodyColor: YnotesColors.onSurface(brightness),
        displayColor: YnotesColors.onSurface(brightness),
      ),
      cardTheme: base.cardTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(YnotesRadius.card),
        ),
        elevation: 0,
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(YnotesRadius.xl),
          ),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: YnotesColors.surfaceTertiary(brightness),
        foregroundColor: YnotesColors.onSurface(brightness),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        titleTextStyle: YnotesTypography.headlineMedium.copyWith(
          color: YnotesColors.onSurface(brightness),
        ),
      ),
    );
  }
}
