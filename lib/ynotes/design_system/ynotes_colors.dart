/// 🤖 Generated wholely or partially with Claude Sonnet 4.5; Ynotes Design System ✨
library;

import 'package:flutter/material.dart';

/// Ynotes brand palette and semantic colour tokens.
///
/// Usage:
/// ```dart
/// container.decoration = BoxDecoration(color: YnotesColors.surfacePrimary);
/// ```
abstract final class YnotesColors {
  // ── Brand primitives ──────────────────────────────────────────────────────

  /// Core brand indigo, mirrors GoodNotes' signature blue tone.
  static const brandIndigo = Color(0xFF3B5BDB);
  static const brandIndigoLight = Color(0xFF748FFC);
  static const brandIndigoDark = Color(0xFF2F4AC2);

  /// Accent amber used for highlights and active states.
  static const accentAmber = Color(0xFFFFC107);

  // ── Neutrals ──────────────────────────────────────────────────────────────

  static const neutral0 = Color(0xFFFFFFFF);
  static const neutral50 = Color(0xFFF8F9FA);
  static const neutral100 = Color(0xFFF1F3F5);
  static const neutral200 = Color(0xFFE9ECEF);
  static const neutral300 = Color(0xFFDEE2E6);
  static const neutral400 = Color(0xFFCED4DA);
  static const neutral500 = Color(0xFFADB5BD);
  static const neutral600 = Color(0xFF868E96);
  static const neutral700 = Color(0xFF495057);
  static const neutral800 = Color(0xFF343A40);
  static const neutral900 = Color(0xFF212529);
  static const neutral1000 = Color(0xFF000000);

  // ── Light-theme semantic surfaces ─────────────────────────────────────────

  /// The main canvas/paper background.
  static const lightSurfacePrimary = neutral0;

  /// Elevated cards and sheets.
  static const lightSurfaceSecondary = neutral50;

  /// Toolbar and navigation backgrounds.
  static const lightSurfaceTertiary = neutral100;

  /// Sidebar background.
  static const lightSurfaceSidebar = neutral200;

  /// Primary content text.
  static const lightOnSurface = neutral900;

  /// Secondary/muted text.
  static const lightOnSurfaceMuted = neutral600;

  // ── Dark-theme semantic surfaces ──────────────────────────────────────────

  static const darkSurfacePrimary = Color(0xFF1C1C1E);
  static const darkSurfaceSecondary = Color(0xFF2C2C2E);
  static const darkSurfaceTertiary = Color(0xFF3A3A3C);
  static const darkSurfaceSidebar = Color(0xFF242426);
  static const darkOnSurface = neutral50;
  static const darkOnSurfaceMuted = neutral500;

  // ── Semantic helpers ──────────────────────────────────────────────────────

  /// Returns the appropriate surface colour given [brightness].
  static Color surfacePrimary(Brightness brightness) =>
      brightness == Brightness.light ? lightSurfacePrimary : darkSurfacePrimary;

  static Color surfaceSecondary(Brightness brightness) =>
      brightness == Brightness.light
          ? lightSurfaceSecondary
          : darkSurfaceSecondary;

  static Color surfaceTertiary(Brightness brightness) =>
      brightness == Brightness.light
          ? lightSurfaceTertiary
          : darkSurfaceTertiary;

  static Color onSurface(Brightness brightness) =>
      brightness == Brightness.light ? lightOnSurface : darkOnSurface;

  static Color onSurfaceMuted(Brightness brightness) =>
      brightness == Brightness.light
          ? lightOnSurfaceMuted
          : darkOnSurfaceMuted;

  // ── Tool colours ──────────────────────────────────────────────────────────

  /// Default pen colours exposed in the Ynotes colour palette.
  static const List<Color> defaultPalette = [
    Color(0xFF000000), // Black
    Color(0xFF1C1C1E), // Off-black
    Color(0xFF3B5BDB), // Brand indigo
    Color(0xFF1971C2), // Blue
    Color(0xFF0CA678), // Teal
    Color(0xFF2F9E44), // Green
    Color(0xFFF76707), // Orange
    Color(0xFFE03131), // Red
    Color(0xFFAE3EC9), // Purple
    Color(0xFFE64980), // Pink
    Color(0xFF495057), // Dark grey
    Color(0xFF868E96), // Mid grey
    Color(0xFFADB5BD), // Light grey
    Color(0xFFFFFFFF), // White
    Color(0xFFFFF3BF), // Pale yellow
    Color(0xFFD3F9D8), // Pale green
    Color(0xFFD0EBFF), // Pale blue
    Color(0xFFF3D9FA), // Pale purple
    Color(0xFFFFE3E3), // Pale red
    Color(0xFFFFECD2), // Pale orange
    Color(0xFFFF922B), // Vivid orange
    Color(0xFF51CF66), // Vivid green
    Color(0xFF339AF0), // Vivid blue
    Color(0xFFCC5DE8), // Vivid purple
  ];
}
